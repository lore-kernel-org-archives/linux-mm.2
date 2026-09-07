Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E86E6C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 07:26:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CC476B009D; Mon,  7 Sep 2026 03:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A3BD6B009E; Mon,  7 Sep 2026 03:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9196B009F; Mon,  7 Sep 2026 03:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 644226B009D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 03:26:36 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D92B1C0686
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:26:35 +0000 (UTC)
X-FDA: 85186133550.02.1F54243
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id BBB7D40006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 07:26:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P+bJvJln;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788765994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nGo4YFKM9biZdQ6+wYj7CRnf1DHFyHvKdOV4NarY9xc=;
	b=ZPEZv4tRX8qffKAPTq7XlxJReqOAMMrG4ahCh6iLjAyJULhHejrmdXBtWUP2tYdHti11LE
	v13tBY7c17C9rMxFnGawEy82TPBEztDFVaXlLdFoVU2Hmc+ns7Cihe2+TAl20LlCp+GNd3
	EME9se/xfPoNdEYgxTZN03dhYpCuwrQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788765994;
	b=15OWp51dDzKP1G/B6HZhLOc/hCvhcV/sIYWeJ3WheyrQuY1NcztrpreHf1Nx/TsZC5b05S
	U93JgAFzzI1TJUwHjsH9n1AUtHg/39h4ZYabfFLDQLOfmH5rzIaF3OQvWe0/CaunNbDb5/
	OP3RsmXmNWhHVSoUU44pttZKL3x1p7I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=P+bJvJln;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-49b8ce9b733so25154595e9.1
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 00:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788765992; x=1789370792; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nGo4YFKM9biZdQ6+wYj7CRnf1DHFyHvKdOV4NarY9xc=;
        b=P+bJvJln5Fv6Mr5CqJcc0TizqtREB2oBbnSAPEiktgrRlBVVqOXMhIt00Kx3ElPFPq
         xvpUXCPInGHrW9lfoJ6GjkaWnw9LHOIa3Mti3IPraxt89c9Cs1nRpf4IVHcLEc8dzZJh
         EDAK+wH85WE5SkxMqqfjnUrS/N2X/KvOpyS0yf6uGe9jxFl64lIP5a7w0no7AnmcsygG
         E5lvp6/fLfHaLWW18EEobFwNMX74LzXHiZC07qele4aYO78i1+JQSynEUngCFr2TSQVK
         7QyXCaCnCufYqrEPe7twuuq3AtREFVUOW42K3YWKZ2JoBu0hudijf/6tIeoA3NwCirRr
         CP/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788765992; x=1789370792;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=nGo4YFKM9biZdQ6+wYj7CRnf1DHFyHvKdOV4NarY9xc=;
        b=dse6Dtj5iGk5zsFIH9mAr77PoPnncjyxTy91WUR4e5LjieOFAc5NlkItsL3RfvgdUh
         VUHtBvqi2jBseTLHJ3sYvjODCAhj+9Wp4odpOk/NydDySOFPRSfs7Ud/oHvcuyMIz306
         ObRX1r4p1NfvMfjXx3+XQshrQBtMSdn3ZQSOGbEADY710VplafwsZYmXtJPJbmDjTMqm
         oNoMHBtB3oBRG6clrRDA80QssR3LqTV9Hk1hUb4bB4/cUVOROQW9B1yEB3dl4IYLJau+
         yvwbfXKjEZCj6QKOxdk2/F7TUtWxYH7ETwQfuXN46CdBuaoatIroPEHYUTclSQbDZHG2
         gdrg==
X-Forwarded-Encrypted: i=1; AKwUvBzKNBn6zP5HDtHjDE8RgJ4dVrTPPe+v+eNTE1SGeE529kqqqPRm5Io1i9/jH6Kls+TX0ICcC40WdQ==@kvack.org
X-Gm-Message-State: AFuF++nzpHy/jBIt7xs6hkyBlu1Tdj3Mvs+xw/aAA4VE1UhrbjS03Q4r
	z3BQNagWhY0tzRAx8Px3+7xxTc1dyKv2e7arQNVbdxq9cKXU7Mv/6t1rHXcch9YaDGW3yWuGu1Y
	h/7hjVMI=
X-Gm-Gg: AYBFou2xXl+JABFxjm0l1tViW3eLdUwwwmTPUsU1xTNpqeRlDSLyTWCaATpdq5h26/N
	JIjYSoOre1dOIim6Nc/n3czLFFLWgtqrlM1M3aggrUVEM6OKte3sMglxOcw2JMY1eCG/3Zi0Ite
	/keghNDAQjZy5P5PTL/OQVu4iMRDZIEG92rP7ha8pQjA58yCYgqCtrVQYRd/8coFG+Rk6aZ0nLQ
	fjpG5UYeSurhQpm+fu87VsT7KxcQCvo5C302U+y3tCowhduN5zwAhBzYh753xySVJJV2hv3tJ4q
	IuHCn8WwML54WhivVOhRtlRxgdA+ocYBUGiivHPs2uNnQ5o+9ATVFA5AzXueUvI6Aict8cAPEl9
	di8mYIqgq9sZL1W0HkkEqj6TualkwqZa5boxvQ7MrHgPFxtH5hVPnbxYQFHb11AE3kpZihKV1u2
	z9p4nyc0SmFSSuzNcTHCLkFzEnKtJwwA9+JLrh4+fPmW3AUMnQfFF4DY1aEGZfROG4xdZppXPpw
	A==
X-Received: by 2002:a05:600c:37c8:b0:49c:cee2:a508 with SMTP id 5b1f17b1804b1-49cf826c4e2mr199881165e9.16.1788765992092;
        Mon, 07 Sep 2026 00:26:32 -0700 (PDT)
Received: from localhost (109-81-91-122.rct.o2.cz. [109.81.91.122])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d07b371afsm186708135e9.9.2026.09.07.00.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 00:26:31 -0700 (PDT)
Date: Mon, 7 Sep 2026 09:26:30 +0200
From: Michal Hocko <mhocko@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Charan Teja Kalla <quic_charante@quicinc.com>,
	akpm@linux-foundation.org, mgorman@techsingularity.net,
	david@redhat.com, vbabka@suse.cz, hannes@cmpxchg.org,
	quic_pkondeti@quicinc.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 3/3] mm: page_alloc: drain pcp lists before oom kill
Message-ID: <ap5nJm1mH-4nfLaY@tiehlicka>
References: <cover.1699104759.git.quic_charante@quicinc.com>
 <a8e16f7eb295e1843f8edaa1ae1c68325c54c896.1699104759.git.quic_charante@quicinc.com>
 <aphSYFTd12oia8K2@google.com>
 <apkhSHr3by5Bf8jW@tiehlicka>
 <CAO9r8zPCYNmJbkQEA62z75AB=ziWqGb38_E-ee_6o40Sz=zHXA@mail.gmail.com>
 <apqppFukssaAQz3w@tiehlicka>
 <CAO9r8zMBBhhqepbLR9buOOu7bpyLW+UTu55DjbCYrbBp56rkCw@mail.gmail.com>
 <aprxXHSh-LyqaFCW@tiehlicka>
 <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zO93CMjJHLO1ZqHY0Tr2kDfvpMHfH3MLkR37vV0YROf_g@mail.gmail.com>
X-Stat-Signature: 4xn76scufbdszir3h9hph7qhczb6udgm
X-Rspamd-Queue-Id: BBB7D40006
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788765993-30356
X-HE-Meta: U2FsdGVkX1/pSXK06gL9LVq3kp/H/h/IkolXFiEDGkxeK2K2EvIcSqZwj2JY6oNmyCf/rhw/8I8u9LW4aZ//8xvIIO3XWgozspH1ACYZ8KRsbb+TOD+5B+ppXA/pwF4jwHNbBjVU4i/aOpUKQQrMXY0alpVlIUpzdNYQxHdvvoy3aklLEvUpL3bKUDylMlESJ6tuFSel/3nzTRmfabCihV8efM/ThuZVZ5y0bpWMmF7Tz0vrUp7B/UGVSS02rRO8kXBUIYIPOX4rfnaZkHWGHyEpL/0jWeN6xuNSy0owjsIyw0bOX+jUWgEulj39XHdUKRfTMwm1n67Fl74yfJMRQMU5oAOmo5uVBCS5itG+HvjHx6fhk3jYiLRzCFAisdg2MLVMddUsFftMGhRdXZ0L3wZUyj++dsuCoJar8IXy2nebuqI509ZXaVBeTZy7qym3SpghsqQ4l8GFfkOpDyg+zVY/Dp/zoxaJwZAjPtjrgnlOCWbG7M3TBPtv8eSNCJ7b9c4PhEkaun3c6jlqpZz3KZzPN+txTRzyA1qlyDQMDCM7SyKbFJjhJA8JUDZ6NtZ3PAe9o1/TzIXRVqscA79jv0eQfqYH54XUvmAzUK/GNZneqM3H1d+pEL0tJtqBnx9CcTkuRK7LQyovNZn10rwwLaSOiUDKESxZsvQKaj2clSdhh+4nRRv3/MKIaokcQordgDqU0dcKMmYKmudhpGRsc5YMvFKEhalMZdPnZCLl33/fEQIxchvsf6CuSorBoKqA8Y3PAxTxxFhvxj9U8H063Z4jHaprf4wAze4t5VVKVwBd1cjvSZHHFbipI422IpapQxPRvlBnVAZlekXPnnHIqAZyNBY3v5zisp+eic2kjTPz0gTNXPI7kX5Ne+pRmTWRdfPZlkXqbGXbZR1s9D7H+29vcO2E+L+vewWhx5CL3JHD51S1qA4obvznVz7wxOJGOg0TZLnr1EzhLJnA3k3
 ZycWqNv5
 AmlhekrdswZPZbTkMh3nNowGPlzdF/UpjC2CHk6KKqOz2KbXAN7AoPsB7khCFhS7FUqi983eFJW4zTEP7qnocqVu1YE89JQkygwMW6JzM5ycAeukkekMrtKz3gA2dYnR1RRUDWUVQbmK9sGIb1AH0pegtKNCOXZuQJnQWEQOYqeFIqubEGSUc8hdLf+FVkV5Od/cGi+1CZBnhyqQA/Hz+RuGLaRF8yC9F3y3rwMr4UyLlUokoO9NxSoaanXeomXM8b6qbF73dvjvMO2lpQrg6L3KSDyM8reysLYHfNZhfKy+luG02OnmphWUw0EUN4VCHoGfivd9297MIEBCHj+bf7hBDyRGkOY7EvaEq1I33jXHmaE4c8xUpj3iI9fvvWrC723IjcjFGUsGqXfHlym5BnemKRkyrhKTG5tUS5N/afNer4G8rXT0+ftYU/+cgLHAoojcwbk7KxZXAOQKXqsDwJ11tgPtDYuBTfzf7yRjavC/MHyE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 04-09-26 09:35:55, Yosry Ahmed wrote:
> On Fri, Sep 4, 2026 at 9:27 AM Michal Hocko <mhocko@suse.com> wrote:
[...]
> > > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > > index 8d79f76cdd0e1..98e9079240ad5 100644
> > > --- a/mm/page_alloc.c
> > > +++ b/mm/page_alloc.c
> > > @@ -4592,11 +4592,12 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > > unsigned int order,
> > >         psi_memstall_enter(&pflags);
> > >         *did_some_progress = __perform_reclaim(gfp_mask, order, ac);
> > >         if (unlikely(!(*did_some_progress)))
> > > -               goto out;
> > > +               goto drain;
> > >
> > >  retry:
> > >         page = get_page_from_freelist(gfp_mask, order, alloc_flags, ac);
> > >
> > > +drain:
> > >         /*
> > >          * If an allocation failed after direct reclaim, it could be because
> > >          * pages are pinned on the per-cpu lists or in high alloc reserves.
> > > @@ -4608,7 +4609,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask,
> > > unsigned int order,
> > >                 drained = true;
> > >                 goto retry;
> > >         }
> > > -out:
> > >         psi_memstall_leave(&pflags);
> >
> > Ideally if we can make the function call less hairy. Maybe we want to
> > make draining part of the reclaim as the last resort when normal reclaim
> > fails.
> 
> Do you mean do the draining in __perform_reclaim(), or deeper into the
> reclaim stack?
> 
> The thing is that __alloc_pages_direct_reclaim() currently drains when
> __perform_reclaim() fails to make any progress and we still cannot
> allocate. The change above makes it drain if it cannot allocate after
> __perform_reclaim(), regardless of progress. So if you want to move it
> into __perform_reclaim(), we'll have it in both places.
> 
> Or maybe I just don't understand what you meant :)

Sorry for not being clear enough. I meant to pull draining out of
__alloc_pages_direct_reclaim and instead have it somewhere in the
reclaim path. It is not entirely clear to me  where at the moment but we
do not need to have the same behavior as now. The idea behind the code
is to not drain way too much. Maybe we want to drain when dropping the
priority down to 0.

-- 
Michal Hocko
SUSE Labs

