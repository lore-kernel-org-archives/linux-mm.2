Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59506C61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05C826B0088; Sun, 30 Aug 2026 14:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DF36B008A; Sun, 30 Aug 2026 14:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E42036B008C; Sun, 30 Aug 2026 14:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B92106B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:34:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C1298035B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:34:54 +0000 (UTC)
X-FDA: 85158787308.25.F97BA05
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6000F40005
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:34:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fnh1fYTB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788114892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G0B4wZ3fn9SdpG81JGH8ihBKW0Pv8b+m2YhlqJODgpk=;
	b=pID2YApuypMt1eU0nr6sfWXiEpjscLTSazPpH9RLkynOdNCCjlwsmc5DXU/QE+pppqqod8
	wFJEtNts7cb+ISTs2agzKvQ6AncwhUCIqxVxqUaOQwsBiK0xGdLLmr2CdJ47OtIwcEN+YK
	V3ziMrHOgQfCCXTNmNiBkTbPPalZTMs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fnh1fYTB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788114892;
	b=N35MqKUSLFlGctliOPxen9W/Ar9x64xkHZ07Ru8G5vM6ZZBGYHKWzZVE0RQ+k34e3sndm6
	e/C1hbKm1iPkfb1ZWfWXKa8PhJlZhafOr5nJ3Ph+P7KKPfEwpG5I3M2tEO3vkUz5+Wk1Wv
	c0k5x6IqL8af/fkvUHw7v5jqcWVZjzU=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3969e82ff8fso2892331a91.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788114891; x=1788719691; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=G0B4wZ3fn9SdpG81JGH8ihBKW0Pv8b+m2YhlqJODgpk=;
        b=fnh1fYTBvebKta9n1wtPMec17maVxpwoqmk3FU2AfnZCQStKmHfj4VE5GMjnWOGFnj
         wSIoxhhZgQEJuP1K6sMZyC/yAqVEnKIU20VOwcSzhT9UexwjysRWuP0Km/MTzDt/8909
         qg1Ic6oKgR/QD72TsGG1cFmdvr/pnknek+Y/q6s26xr/x17YrLG516F7CUxnYk5qkmH3
         hCDblAlyjJjQ8AJLzKuT0oawzDeDd0/g6K+F5NqEWyeWfWTE2mMCLaLGsWNzf6z/8pK9
         JIGXLXvepoovpLetLfkqjyLUYuiwfyOb6PxOqzYKEoptsHCaAFzpa8HGHafR4JoON3RV
         sygg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788114891; x=1788719691;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=G0B4wZ3fn9SdpG81JGH8ihBKW0Pv8b+m2YhlqJODgpk=;
        b=FHnWN9AZ2TlabCz3XpPK9P5n1ic5TV59mci7gsB0+UDAPIEfkGqox5zEDll0/8nn0c
         ckM6WBapZDIysAjiTqqBvLk/nV5wUD4lYBuz8hflIR2A7e9Vdtmkv4lt7SNA+vdUZbT9
         p2sJlBcETFzMK/azL8hgZZfL3bk00rP0PKvohH8gVWtsE0GMbAnRqDS37KCQhUdBDIgQ
         FQ1n8bQ4C6fIOCdxccXRiXayjhgSZ1PmPvCH534QDL9jZ2AlWVwKJw4aRt5mlHCTLxgh
         612TqmBnO8gGdkldfHC1tXt1VgaQiR0CLT2tzPP1h5OYEyaLKs/CJl/iy98Cxf+1eWOA
         KyaA==
X-Gm-Message-State: AFuF++kd8qkS/QMa+hFhKXrA4IDPl0i28PiYvcP1jD8cPotYAgbzGy9Q
	s7W1mLo7rZNjXGH769EdlIahT3iMkq0VD04wL8Gd+qNBBQMr8AiE8Vnn
X-Gm-Gg: AYBFou2Vf7JIPRmE7d6/ffoA68tBEjYO9byKam9JqFXP/j9TqMItaJMb1i1YFWNjRTp
	9y5hD3QHJo/SGZHoJmpV5nPXQBkeO7zoDUXt7C12iwCjlDthtrEBfz7qENYZgOI6mHbz51r108k
	S8gUUr9h9eHNFzNGJp3rvDjgpzKDphu3s7zYt/lVfIGZLYsmA/2Jqt+7VOzZbhRjc1AMg+F/ysY
	Vh/90Mnhu/KOqdaBqeRlXPtDx9PKMslSOBEb2V6tQ+9PpnQNGrcbRBwVPmuoiznYMWQxcyBWgiC
	lBMYjrvqnVBOuAaRE08PBbkXNGzd4/VUiZ5Lon+fm3cyG9K8UmivilrwSee+U1lKHsVZhFsWa3h
	2yOEyIZGJCSuPb8opUMtb6Hi+PRyvmN9gdqvRFLOkseXh0t9MxMDemf5TTYaR1v8t367nHIe6gM
	brYa9VOYi0wa7NazwxXr5jS5PxFY4O0Xa7/qfcpWOu+IgVStf/gFeMyzSXiY8as4pwUZtc6g3tP
	CvBm4w2RX2KR8P2oEKaSg91bA==
X-Received: by 2002:a17:90a:4ca6:b0:398:bd66:35f5 with SMTP id 98e67ed59e1d1-398bd66372fmr8496745a91.25.1788114890953;
        Sun, 30 Aug 2026 11:34:50 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-398a2d45bd0sm3248973a91.0.2026.08.30.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 11:34:50 -0700 (PDT)
Date: Mon, 31 Aug 2026 02:34:41 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Barry Song <baohua@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ridong Chen <ridong.chen@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
	Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
Message-ID: <apR2LxjPMbripExL@KASONG-MC4>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <CAGsJ_4yasRXO52K-13dx9ZXPw95wEyn2bpnf0NiQ2z56dxf-vQ@mail.gmail.com>
 <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7B7TFfBZLPorZEmg5y9u6TzFbYVQXZNC8+iztGtifmdKQ@mail.gmail.com>
X-Stat-Signature: why8wp6psbiztou4gbeazns6rpfpqotk
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6000F40005
X-Rspam-User: 
X-HE-Tag: 1788114892-809392
X-HE-Meta: U2FsdGVkX1+HE3vg1KL9hizwq64m18gAp0J6goekRKRBCRyJXtKCxLvphx81jhTKCPFeUyB2GFiJywFMVrUxYCKEZtfqa1msA6li/n/ywMw7SVv/klXA4HO+Du60ypFslFzBuO+3Zc/PERkn4cMg44ptcAdTPhBhgnZE+HGHJein6g7oDB6/Snx5LuB1P+3TcA+P9oQ8I+mWA1Uv7/NHEBfd3N/odnaAokJSi+FWDFIgw3Y/JSaDpQXYLxrj1rwSblulM6Tbsy9RAsChF+WnLasSF/pZe/r9ArQ9mB+6uRNwEcYQRzSMzwCTn+0DENMfYpTLHhl5zKYwXyO320YAtvcTVnMajujkdzgRwh5rPEdVytDeEB6dZ6nnJRzyKeRAHv5gjTX4CAMGKwKPa2XHoLGyfOT9TpyGrHb4niduKeP99dpm5YQyoTv7pi1e9qLHpPmtYJPZRcJc3+ih/KE9BnwWCYVSgaQpMibIqihSRLy2ajhEuZPQH68c0czMmnnp8yV3W9MPmG126cPkm64dB4CHQjsgnXEXjJdNL6FesLKQrb/12mG9DCcrbDBYj3GLdN9pl6/g67A9X/I5V/XBV95gzkQ7PUFSsHSG/ldagcUGlrlPKlCtKrdpl9u4ScHLd0+8pOi5SDKVyfeZK+36O6TvjN9IVY2EESv/kBabrVhKHwbYVY8rH+pVzm0wiFargpf/n5j5bJhvtPb1rLJP0LaihWjHXRQ97tEKS0MkOemxhk495d670DiF1BEoQ8FW02mFjXlWyl2pGjBUcuNpeeNS8wBif2gPkjxrfB8BD/Y2rg3Ebc8kOd6cYtFjEaJFUaLpJL8lEV8uG9hARhRHr1z4z+UHPQaVAsTwiuqbWWJk1MTYYmqOE0rk50uEMk43gLfMt6L8ADvrkDLkb6C980l6KEQp4dSKtgODXzhGeIHU+WY0Xw0jWkSH8CpPorDpXZp4peJo7E8BnaIuZfQ
 nH7BTTz4
 ZFteCmil0hEBcH4ZIqQvp8PKcPyKC08AEDoF95BzSVTIiY3wWPEkl6qJM8NbLg1zUUF951kncX95UxUKvlMoom4acjKisd4REXDcbLWEMHxzW3kY7X5WikCdY8ez6acoqk/+oHRVj22XG7/Qpdx2wRv5gpkISDq8HtTVShcZwNwo27Kd66STDp93vmhwzvv1QTpiaWS0yBFWPKZfeo03IRl367E23oiBnj6gboYwhs57AfAGZBk92CnWd5WeJBK7Jv2cgZ0TAY3AERRQG2V0kjbuVbUoL5EOP+S7Yg5rHPhkYVE84gWeX23S3l81akXc7SqbXtKDN6NRTNcE5pzwfZOxO/lezErx285xYmo9lS79yIOquu/12WCnLME4TEOVGw/32PkYIvMJJEp6f8cy56Q0OVngRq/8h15XP68j4+JR251/kYox35gDkvJLOFXFQDP6Tpl5HBDwiy2AbzxGl//l/I5z3JSIXbMJjj8xQM02583vFzaKJfTthk4KepPhnFTY6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 03:47:42PM +0800, Kairui Song wrote:
> On Sat, Aug 29, 2026 at 12:22 PM Barry Song <baohua@kernel.org> wrote:
> >
> > On Wed, Aug 26, 2026 at 1:53 AM Kairui Song via B4 Relay
> > <devnull+kasong.tencent.com@kernel.org> wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > > adjusting a folio's refs and generation info, making the code easier
> > > to debug and understand.
> > >
> > > No functional change is intended: some combined atomic operations are
> > > split into two, which only creates harmless transient states. There is
> > > no measurable performance impact, and some paths even look slightly
> > > better in the generated assembly.
> >
> > Hi Kairui,
> >
> > I like your idea. Overall, it looks good to me. With some cleanup,
> > we might have the following:
> >
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> > > ---
> > >  include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
> > >  include/linux/mmzone.h    |  1 +
> > >  mm/folio.c                | 19 +++++++-----
> > >  mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
> > >  4 files changed, 114 insertions(+), 43 deletions(-)
> > >
> > > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > > index 621c8653d8f7..edfaf2661812 100644
> > > --- a/include/linux/mm_inline.h
> > > +++ b/include/linux/mm_inline.h
> > > @@ -142,10 +142,42 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
> > >         return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
> > >  }
> > >
> > > -static inline int folio_lru_refs(const struct folio *folio)
> > > +/**
> > > + * lru_gen_from_flags - Return the LRU generation number from folio flags.
> > > + * @flags: folio flags
> > > + *
> > > + * Returns: A number between 0 and (MAX_NR_GENS - 1), inclusive. Returns
> > > + * -1 if the flags indicate the folio is off the list (e.g., isolated).
> > > + */
> > > +static inline int lru_gen_from_flags(unsigned long flags)
> > > +{
> > > +       int gen = ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF);
> > > +
> > > +       BUILD_BUG_ON(LRU_GEN_MASK & LRU_REFS_MASK);
> > > +       gen -= 1;
> > > +       VM_WARN_ON_ONCE(gen != -1 && gen >= MAX_NR_GENS);
> >
> > Since `gen` is an `int`, it seems a bit odd to have
> > `gen != -1 && gen >= MAX_NR_GENS` combined here.
> >
> > Do you actually mean the following instead?
> >
> > VM_WARN_ON_ONCE(gen < -1 || gen >= MAX_NR_GENS);
> 
> Thanks for the review!
> 
> Yeah, thats's a better sanity check, will udpate it.

Hi Barry

After second though, I now remember why I did this in the first place.
And there is already many following checks in upstream:

VM_WARN_ON_ONCE(new_gen != -1 && new_gen >= MAX_NR_GENS);
VM_WARN_ON_ONCE(old_gen != -1 && new_gen >= MAX_NR_GENS);

And gen is signed everything since it has a -1 special value.

The reason is MAX_NR_GENS is unsigned, so a signed -1 will
look larger and trigger false warning on it.

Or we will have to have something like:
VM_WARN_ON_ONCE(gen < -1 || gen >= (int)MAX_NR_GENS)

I prefer to keep it with the existing style, with proper
comment, further sanity check cleanup later. Right now the
usage of MAX_NR_GENS is limited so I think we are fine.

In fact I'm think we can get rid of the -1 by combining with
PG_lru, or use a formal special flag. Which can be done later.

