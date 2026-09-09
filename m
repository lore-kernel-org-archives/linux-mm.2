Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92FE3C79FB5
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 07:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 509646B008A; Wed,  9 Sep 2026 03:36:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BACF6B008C; Wed,  9 Sep 2026 03:36:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9546B0092; Wed,  9 Sep 2026 03:36:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16F9C6B008A
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 03:36:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 555271A0121
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:36:15 +0000 (UTC)
X-FDA: 85193415510.03.9E8DE74
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2F75A100003
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 07:36:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qtk7LEl1;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788939373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V3OoG3DjDJcclfZFhjtGj32TTpN8ta/8kYvfy2cZ0Ak=;
	b=VdsZV6MQ3ATQKqwImyj1E4LZEecANBVBzQIEG7miTjzntpRdNApT0Y9/4b9DBVqf5iYKhP
	bgIY6lFezSJl0r8nCzhQlBpMA349LpsANqoG5Vt1jlyypVpIIBW04laWoiOUEWMIClJpYv
	fEYVgOXqWbqOElh+tJA6PEQykyCSpSk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788939373;
	b=XRd1JpKvHShbxn3J2LPfzdPeDIIRVJrzqgKVgsXSkewrQPcl2YRpNFeF5F+qVjzgWmGwL+
	VJhE8qub3KhXd2mjjLw2htxgDER9WMdpodDI3fCzHj4FblmvCDQlGP7EUqXFcfTp6r2JPU
	N2fY6zo1YE5uYJ7UZMvPQz6GSMC4XWQ=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Qtk7LEl1;
	spf=pass (imf05.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso42156455e9.0
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 00:36:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788939372; x=1789544172; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=V3OoG3DjDJcclfZFhjtGj32TTpN8ta/8kYvfy2cZ0Ak=;
        b=Qtk7LEl1VTilxP5U0Hxkf9KWXo9SFHqzd/hDmt4HM7b+w0rqNj9s/Oj10LKekO782i
         98zCS4KTYxIxQQR6KcIQbE2bDAEwr355qhQ9dkMsE5N91yWG81BYBugrhbRVkdV9V+ck
         KkzvZgtaSyPnnMpYGCpAFDFiCzND4tTMd1wzfrVew8E4BDc4I+dhuZG1iKOFkmitV4dF
         A6G2/exzHkN9Tkn2Pxh0bWChixbjmTReoq/uQNoqRGFtVrOnte/zUujRXaL9JGao01LY
         7rS2QRUlikLuPZZApG4RiPUPWKq/cq/cQubCef3WVt221G19xXi9hi9IHGMTo3va8nVI
         MD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788939372; x=1789544172;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V3OoG3DjDJcclfZFhjtGj32TTpN8ta/8kYvfy2cZ0Ak=;
        b=dsz7FjZNPfDMgKUekVPqzwXAsHzydiTBNErWUpMZ6BDW/Vu/i8VggIIPklDnJCgRor
         FrakXcPJucVjunJofxtgl6pIRjiewPDb6mLrimZZ+03DaE7N3x1ij6iV+VmQ9JFHzAip
         D9LwmH6jVbk0clkS9ngyXGwtAVp3AVxYiWMAvFg5aSj82J7HnJAc6mV7dq4CL4c1FC6d
         7DTw3e89SQzGxbNlQVFHWIB9VFPOckRHQ0I3H/HKWQ/2knmOXwK7/ax0ZQPryNQeW00v
         redvxS4SZICH7uOtFzkVA8/j7YybpDEBRs9ehUbMEdfjKx6DliyIg3KzmC3Wv40Vi1tI
         do0A==
X-Forwarded-Encrypted: i=1; AKwUvBwxksZO1XPzZ1RypoesbT4QEmC9gEw/dVhEFPB9vKVpekKrF1FIMziWdfS8dWTV8b3leP+26CrmqQ==@kvack.org
X-Gm-Message-State: AFuF++nhl2wvMB3EoqB+qR49OR0tHVut3TnyAIIk5pPxAQ7jeXvplUVY
	RxHFSDcALzpHXDkXHCYzaw1/DZ/r7Y6DLxaUrpXstDJITpfotz071J7gr6Jw0g64wn8=
X-Gm-Gg: AYBFou2v2ouAGmc+ZVjXnT4/H76d1cbYlTg7AjfUAoELlYTHMxX59vDiwKpFzwwtSXK
	7cfN/v5rB1QY4JbKav/FjdsHEVtW5ezesiAnQXBhuYtCcaDUoI+Z0NC5uho6CIBLSxdKJFccU+1
	HfLjyuTMIkHknJ3nK/RGwASmX0jA7JyNqSsfgwedMhaEMrTYTWxM4yAQcl+TpcegiWxt+HEe8j2
	cgQFssK8TUENU24aXhDsclyJgVcKWreRJdaijZwG44geRilCos+jUp/XcVgoIQMTOqUz5Xhq8+0
	m03IuMaUncqdBrvJo0sNIAe4IXi2oxJaFVrHyp/sr5vjpoaBvS9Pr48ILA7Bv6fjTg5q/kk1uTc
	FKOE9eI9pUX4DC4YJkr4GneoD6mv1hgidZE1SB7TbsHtnU3Rwi3G7YlwCF1LFHEtzyNnBpbL0QR
	YugvB0IGfifqb+z+K0mCH6QIJccyTpgSHfnBW8fIq9h4DdPneYnQj7jGyYkBNeyEtxmfzyF2tJz
	OsoUcM=
X-Received: by 2002:a05:600c:600b:b0:49b:90bc:d4f3 with SMTP id 5b1f17b1804b1-49cee5d6287mr321995535e9.4.1788939371754;
        Wed, 09 Sep 2026 00:36:11 -0700 (PDT)
Received: from localhost (109-81-20-2.rct.o2.cz. [109.81.20.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48588394fa1sm39983209f8f.8.2026.09.09.00.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 00:36:11 -0700 (PDT)
Date: Wed, 9 Sep 2026 09:36:10 +0200
From: Michal Hocko <mhocko@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, mgorman@techsingularity.net,
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org,
	quic_pkondeti@quicinc.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <aqEMagbMGPlkuP2P@tiehlicka>
References: <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com>
 <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
 <apqppFukssaAQz3w@tiehlicka>
 <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
 <aprxXHSh-LyqaFCW@tiehlicka>
 <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
 <ap5nJm1mH-4nfLaY@tiehlicka>
 <CAO9r8zOaAGHXK6FZ0PM9sJL2zH4fQe5kh+W2TBNL90YZV2detQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zOaAGHXK6FZ0PM9sJL2zH4fQe5kh+W2TBNL90YZV2detQ@mail.gmail.com>
X-Stat-Signature: atx5npt6btzg66eug55wnpgi7d9hne7u
X-Rspam-User: 
X-Rspamd-Queue-Id: 2F75A100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1788939373-40796
X-HE-Meta: U2FsdGVkX18G97c8CHBKm7vcsCaXzewmXxj92ZVV4LAGs/c5j3Xg/zBak2q+7qf027EF4qjgQUW86o+kRH+ojQwsRxuGt8i5PQ1+zdUPZWrwTDl5NqMPJAGUwav5N8vSfuuao6oRMTCW6/Dn2SO5oLZG6XwBKiaHZ4AbkzEv1tJRq0qbU7msLHp3IgHw4pNVhiK6/27jmnkbfm7fhLv/G6MAJnwsOpgBhIpbCFPDwtj8DbP+g68cf0rbgOdon+t309+zq8FlSDgNy26RDKbJ4a7/IXSWZ8y9gY2qL4Y0rzNB7RDZDGMqitoHXP8FNshxhVxwRIlgesH1rY01dcelWYNOtzxppYOOI0dVQRHos9yg7TsKNfdDDnYIDApihb31YKTiX/ogOnbN46djOfKWbJyOD1sPFofRpvWi0dCynFklQ7DNXl8eIdXJ+DS1Ya7qMsa1WZR2dI5nK85Mozmyhriy9ZC+mlHtKiIWxTJ2Bny0ckYdU+ETl7Or4V0SOTLLVIzXxO478z01no0MlpodwCbXya9K/d8V1AprMrbSlye6yLwAstXFdDnGzFFgATzqexTK/BVXqgOKWa3WtxqHCoDWdWWxoI5x/V13c31HVXKg4d8ZsSTeBA0SYTfBImbyS5vfeycPldyEicFO8yStKcOvq3iTHzabktZth2mdoakKWgDeME0+JKV2uLeBpKjnQWcb0BqQyJd6TCXzlc3xAhdzrq1eFmPUiDWfuVUNhU/BAC0Qs/YozMn46evbL53o/5NWKWrUyZRLswqswY6i0FCPxvVsLPM0OjxCU+Tw8byf2i3L0gM9JmNzNVSlF8bYSZmKHdmzMow0feIhurYU5wpJTj2pRZTKGCct2LK16jCuMItCzZqRJs7pRoYUWztVdUxavrurNKvyaQ3vw/+BZhC8Mhs6r//b/qnGtzYUzO4BSI3K2bpdf4JueXcW+cH/Gtfl3TeLpT0GkJkv38H
 UuwEM7OM
 OPz8ujbUkbqM4eZkYtcGxssiOo0vqsropvR2w0/ONqQozu6fzi2ABGEpVXg6KdMfIHQxwecb0VgBH1pfTSo73Z5tQV6SsiHsNzB80zN8uPEVfBY0oe1Hjun/L9mribyDNDixazj09rUhundWBb982c71UACrVYSiGq8jtiKyaajKGcaJpVfENc7uvYkqZZqbGvT5bwF2sPGBZu5texSoMRbO/gFO3KKkU40r+dUF4wugXVg52o2QsEqXObYYFhBn+PDw7CqwkDvSGL9B94y/cuNRorJqZzzklEtSctmv/4ZSspNAhwmZ+Lgy28fxpiD778Y8RGrlcVAnPs1q4w09nnRyI52EiWUCyz/LPv0bwduSYAlqSc75u10aEsKstQoF104Vr+X1FLkXFBVy2QbkMqzgYLyfypTkwN2erhl4m2uq+DAfxHK/+r9ya8bIkXBsLCK5/ICJlTHkan+ZKswBNLqEZIjicAn8GAfNblmOlwH3s0xA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 07-09-26 01:49:39, Yosry Ahmed wrote:
> On Mon, Sep 7, 2026 at 12:26 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 04-09-26 09:35:55, Yosry Ahmed wrote:
> > > On Fri, Sep 4, 2026 at 9:27 AM Michal Hocko <mhocko@suse.com> wrote:
> > [...]
> > > > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > > > index 8d79f76cdd0e1..98e9079240ad5 100644
> > > > > --- a/mm/page_alloc.c
> > > > > +++ b/mm/page_alloc.c
> > > > > @@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > > > > unsigned int order,
> > > > >         psi_memstall_enter(&pflags);
> > > > >         *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> > > > >         if (unlikely(!(*did_some_progress)))
> > > > > -               goto out;
> > > > > +               goto drain;
> > > > >
> > > > >  retry:
> > > > >         page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
> > > > >
> > > > > +drain:
> > > > >         /*
> > > > >          * If an allocation failed after direct reclaim, it could be because
> > > > >          * pages are pinned on the per-cpu lists or in high alloc reserves.
> > > > > @@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > > > > unsigned int order,
> > > > >                 drained = true;
> > > > >                 goto retry;
> > > > >         }
> > > > > -out:
> > > > >         psi_memstall_leave(&pflags);
> > > >
> > > > Ideally if we can make the function call less hairy. Maybe we want to
> > > > make draining part of the reclaim as the last resort when normal reclaim
> > > > fails.
> > >
> > > Do you mean do the draining in __perform_reclaim(), or deeper into the
> > > reclaim stack?
> > >
> > > The thing is that __alloc_pages_direct_reclaim() currently drains when
> > > __perform_reclaim() fails to make any progress and we still cannot
> > > allocate. The change above makes it drain if it cannot allocate after
> > > __perform_reclaim(), regardless of progress. So if you want to move it
> > > into __perform_reclaim(), we'll have it in both places.
> > >
> > > Or maybe I just don't understand what you meant :)
> >
> > Sorry for not being clear enough. I meant to pull draining out of
> > __alloc_pages_direct_reclaim and instead have it somewhere in the
> > reclaim path. It is not entirely clear to me  where at the moment but we
> > do not need to have the same behavior as now. The idea behind the code
> > is to not drain way too much. Maybe we want to drain when dropping the
> > priority down to 0.
> 
> If we want to maintain the current behavior of only doing this for
> direct reclaim (not kswapd, cgroup reclaim, or proactive reclaim),
> then I was going to suggest adding it to do_try_to_free_pages().
> However, we bail before priority reaches 0 if we are able to make
> progress or compaction is ready.
> 
> Also, I think in do_try_to_free_pages() we don't have enough context
> to decide if we need to drain the pcplists. Looking at the comment in
> __alloc_pages_direct_reclaim(), we specifically drain the pcplists if
> the allocation fails after reclaim makes progress to make sure all
> reclaimed pages (e.g. in other CPUs' pcplists) are made available to
> the allocation. So I think it fits better in the allocation path, so
> that we only drain if we cannot allocate after direct reclaim.
> 
> I think the main issue is that we only drain today if we know direct
> reclaim made progress, so it potentially freed some pages to pcplists.
> However, it is possible that reclaim did not make progress but there
> were already pages on the pcplists (e.g. freed concurrently or were
> already there). I don't think the right place to do this is reclaim
> path.
> 
> I personally think either Charan's original patch (draining in
> should_reclaim_retry()), or the diff I proposed upthread (draining in
> __alloc_pages_direct_reclaim()) are probably the best places. Please
> let me know if you still disagree.

In that case should_reclaim_retry seems a better fitting fix. 
Thanks!
-- 
Michal Hocko
SUSE Labs

