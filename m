Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7F6BC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 17:19:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4F86B0088; Sun, 30 Aug 2026 13:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7957E6B008A; Sun, 30 Aug 2026 13:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65D686B008C; Sun, 30 Aug 2026 13:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 394E96B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 13:19:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B40BEC02FA
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:19:22 +0000 (UTC)
X-FDA: 85158596964.09.7232358
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf19.hostedemail.com (Postfix) with ESMTP id EAA831A0008
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 17:19:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=siUlewY0;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788110360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2hq6QuB9tMpONgBvXPbELPoG76SYlrSEl+e1j2HRJk=;
	b=FkZT2qZXyfA5SL8CqJ80h1kVtkWsNJ8Kwa0prxLrhqM4HTwO6ES6EEMVZGrhjPnx575gmE
	7Ff8/8HIunBRWDJlhm0j1olN1rcaqu2TdrY5k+GOOEYwlnp/1TAY9/QafbJpjou0ojnrFJ
	OR5DxxRb2nM1rTh5sUoGz/Tw2CSL6WQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788110360;
	b=7He79pLBRuF7lvV6ZebQemiG/MLiG718ZQdBJrjS9+4Y3krFEms2UyNw5G9FMXtLgJYQVm
	nscLp5x64v7WtdfT3t1d4XarIbAZ1CvlrYyKzjn1ckzO4CRsLWn1JtbIsDvqxcOJem3+7Q
	S8GScKDr6Q+r8gsAs/x4wTUR5ovmokQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=siUlewY0;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-398b3c37877so1142956a91.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 10:19:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788110360; x=1788715160; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y2hq6QuB9tMpONgBvXPbELPoG76SYlrSEl+e1j2HRJk=;
        b=siUlewY0Ip9UwQzsNIWLEoEWA2oVUeuCeox77uaizDxH+dT4afOK8GcYeKn02OVgxD
         wvyBpBqiEKBCFsnYIQRfjxd3zIEcD/gJLxUQBexXstINtftkAAhGHqm2GjtuNw8me2ml
         hvcqoRWiyBS2WWJNjqjTEI1fNDe65G/dAgmB2uCe6dwJ0LsPfd8wjJbIMRSJdHJU9j73
         cEbgdgCSN8f5mkwp5e8/iJ+rWbYh+YzLE1wLbe1tC/KRrqGB7u1iXHO6ZCfzDt4feUa3
         askX6yFzH/46YKwG4QEYgeyqDlxzUKLih8XMEeabGGIUYWo08axe8fsciz+S37ANRjxz
         sPUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788110360; x=1788715160;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y2hq6QuB9tMpONgBvXPbELPoG76SYlrSEl+e1j2HRJk=;
        b=WjYseiLST9VlJB7TQMOZCQT9BQQD257xXDd0zmJEPC9p4540LJtAzKiUxqRT2amtuJ
         YcnUTH8bA/OJaj/0F/8RzpggK2QE4CRSIMF9lKPJ1AIRM0O7xyPu6uL4xD6AVEfzha2G
         LHBtVA01m+LKDW9ynn22Fc6fhrtRTI3Rdxl/TSuHhjnSpysua30QQJiHxqn09ce95+ib
         dM7sbmLcHZ8qn1pKNrsl0pzjymVC2EjOyRkzmcprbduwsEs2kqw9+BRXawwLV+aQBYli
         eZxz4oXqGWzvkuGoAGU/Nw5ii8fn6BOs0ffRbfbl1d0WY5+/VlS143a3nuCJjXD4AcAO
         Ae/w==
X-Forwarded-Encrypted: i=1; AKwUvBwCGpOwTT6978Vo3FHtoxEhy/jXW6hLbLn0YSLMErIsXolzHMSh2Set5Z8Hbh9mMSTKjwkpRmQ8wQ==@kvack.org
X-Gm-Message-State: AFuF++lWlSpH8/JmC9s26D9gdpCUuNE8rpk9Jaz0QkVIjZZqC3n2yZ7T
	Y8OlJu/2+z6nz8CY6i5TNDa7FeEXs/wjtCvTDMla6kNHfUQOvMaUPWSF
X-Gm-Gg: AYBFou1Ou4/h7TX8YqGjqrpreslBoUJHTFQOqSVKb4e4iPS625o88Gq5pMjtcBDpTaK
	POzA28HgsauNsvOZtjrdJwG6UoIOR+C9q40tXQtMKUrqK+Z0930bRLuIgPn4JJ2ID3EsNAWtTsN
	r63BTktqKBVbe9vVZIYwK2rAWMwudboSye7hc94BHhlJ9GXPPWnUoNG8NzOy55aLkMeDfSyFLnw
	WlXBliFQLy0RJ9N5Fdc8OpAZ5sJuxBX81yW9AGIowLWls2gS1zf/PwptCEAnJg0+G+QnkHHALaB
	RFqgXItvd94fAnpYsjUnAM/IW8/ACXH0NfWXxqPDXqM+ajWF8lDxvvUwfq/ixHq6A5quXC64sgw
	9uq7Ek0OMU8dNHZmU1ot3mvlC/3/llOaj30IK5xVtMawxUlSuzUtNAyC5dYTSIaWWamyKRoz8LK
	4hIndlqJbuknq2Vbei/DuGNvESZMsA7n4jGKO9PLrOIxV45ArhDz6nx5fSvAOjZYxxBvO9jFhTT
	zjTBDrq4gtcYEMOgWr04GdYT37P9SpDHQQ=
X-Received: by 2002:a17:90b:54c5:b0:395:4de4:92c7 with SMTP id 98e67ed59e1d1-396d0e5ccc7mr35280422a91.3.1788110359674;
        Sun, 30 Aug 2026 10:19:19 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b1992e05sm17245893a91.15.2026.08.30.10.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 10:19:19 -0700 (PDT)
Date: Mon, 31 Aug 2026 01:19:11 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: kasong@tencent.com, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Yu Zhao <yuzhao@google.com>, 
	Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] mm/mglru: introduce helpers for manipulating gen
 and refs flags
Message-ID: <apRkq7A-tvmNvO0O@KASONG-MC4>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-2-d9f1c75549c8@tencent.com>
 <ad8acdc0-7618-4caf-88ca-4780e39ff324@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad8acdc0-7618-4caf-88ca-4780e39ff324@linux.dev>
X-Stat-Signature: fwos4geqozbzkynkbgfpw8qiib1ewrzu
X-Rspamd-Queue-Id: EAA831A0008
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788110360-393520
X-HE-Meta: U2FsdGVkX197ufvqtFeFRQCJ4zU1gtnOmA3LG0mjtBGPvR72N/nu3t3X3LN39nGwuU/qgGELr0SuSUUevGRHMOiQc8r6RQLNPkSknYVgtmJi5nK1uEWpX+yovcf6/n04CiGDIRRvtoGm99bS0rx5lgDQwUNd+RG5PwkBaphG/dGSgEpw3Wk2QxFeT/qQFOdhZyE9xdC8yGfubkPfMrsMvLH6HqX5b0id+GsjOPSTjbbTiCgzN1NxamImUnx5yRsKOwEiT2fqYIpeRbTCToxjaea2CBFMn1J6STplPR6tB/+gtpMiDYYREVE1qNDcKUARBujGKZvWGQlTh4O8ynmpJjzzfWnhTtA2nly2FeKdYUjZ2FzyfeJcmMYpZ4nBZ8lxSLKTatB9mkx6vtmM5sPhNXHgUW5SW2OM/xA/JolfhRzCmi/jVo5KnsBuGRiEZqtttZJXWB4o98HMxsFCSzqqUVzh7DN12DihCY9FGcDhyzn0nxqKEi0PuiVHz9PRbiTSGbRJ6UipY+hmzlAjvLh23IWASgkYzd5mppJzShP5tuflFWi6CUeWnjofMo4tkA6rVX/q1MpvLxAdVK065FFL1PP6CCI8sH4YHUE+RrfRSAxn9D4tNVZcMB2Tl9D+uV1cKPsz2gSN+oTfeHQSkO4qA8OxJNzXTSb8N5IwXE8yNf6RgI3L3TeG+eFay9Hnt9PjCAU8mDBh7d2L0vXFWRqofD1xqptq/Bzz7asvyOZrtDaGKS2pRaVTO2PcSOYFv/w4CordRA9jOflPu7UMBpWpfclhZ4Prj/90dr+Rz3T/v/bWN+lE3kan7muztMkNwVyrAkVYtVf5fkAiPzSUvI2g9TKrzJBwlgjv1TRP7/P40SQPH5m7qbErBH7hQ3EB3YdvqqpcvrCpkoIeRzWk3z+ZNMBRx96RSaQG+978/duAYXK3VVRiieR5/0zs4nLmvjjtNrgAh3aZe86kqNXDS9P
 vTfP97IN
 l5rMk7xDpIVIVZENTvG/j5Pjerz0ofauQBcyNrVU1v2c+LHjqnikpIOg5gyRN00ktvnBnsfmrtDTKu0Zl3HDORum5lkMkzTvT8uveS3SzKX4i3jI2gmk/qvlHkbpiKJpLrXAEfo1qe8ZwXBZU7xw929TbwRb6xf+I3nGngOKf5FmKvnqjxPvUruylWrh0ymeHzbUlObgff8jd43Q40PUWLYnKpipWgqj2qMnodP62oWcUmRSpNryIs3IesKiBv9S2rTGTJSoRQIyld9VBJed18EZDM7y+QGBMfCI/jQo+JXLSSqGAmuPAalLwDJAkH57T9LtxEPVbvJr2cP3KKqoynMvSVEYnpNdZ1plHRR8rtQp38PcMPTYLNc278a82u7BHWxrT6Fu7XcrPQbjiNWY6NFPNnQfSFeSZvK+TdBAzGkVNFdXBkZZn2uJt2Iy0BB4jcCdrpD/EAgUpSxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 04:39:33PM +0800, Ridong Chen wrote:
> 
> 
> On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> > 
> > Instead of doing bit ops on folio->flags.f, introduce helpers for
> > adjusting a folio's refs and generation info, making the code easier
> > to debug and understand.
> > 
> > No functional change is intended: some combined atomic operations are
> > split into two, which only creates harmless transient states. There is
> > no measurable performance impact, and some paths even look slightly
> > better in the generated assembly.
> > 
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   include/linux/mm_inline.h | 76 ++++++++++++++++++++++++++++++++++++++++++-----
> >   include/linux/mmzone.h    |  1 +
> >   mm/folio.c                | 19 +++++++-----
> >   mm/vmscan.c               | 61 ++++++++++++++++++++-----------------
> >   4 files changed, 114 insertions(+), 43 deletions(-)
> > 

...

> > diff --git a/mm/folio.c b/mm/folio.c
> > index c02dcea9c03c..a932059057ac 100644
> > --- a/mm/folio.c
> > +++ b/mm/folio.c
> > @@ -353,26 +353,28 @@ static void __lru_cache_activate_folio(struct folio *folio)
> >   static void lru_gen_inc_refs(struct folio *folio)
> >   {
> > -	unsigned long new_flags, old_flags = READ_ONCE(folio->flags.f);
> > +	unsigned long new_flags, old_flags = READ_ONCE(*folio_flags(folio, 0));
> > +	int refs;
> >   	if (folio_test_unevictable(folio))
> >   		return;
> >   	/* see the comment on LRU_REFS_FLAGS */
> > -	if (!folio_test_referenced(folio)) {
> > -		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, BIT(PG_referenced));
> > +	if (!folio_lru_refs(folio)) {
> > +		folio_set_lru_refs(folio, 1);
> >   		return;
> >   	}
> 
> Do we still need this branch now?
> 
> If folio_lru_refs(folio) == 0, that means refs =
> lru_refs_from_flags(old_flags) == 0, correct?
> 
> If so, the do-while loop below already handles this case, making this early
> return redundant.
> 
> Or am I missing something here?

You are right, it can be optimized. And that's is not the only part can be
optimized after the cleanup I think. But perhaps optimization can come
later? The helper convertion will be harder to review if mixed with
optimization I think.

