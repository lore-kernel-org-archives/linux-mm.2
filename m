Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 615C7CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 22:07:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7765C6B0026; Thu, 28 Aug 2025 18:07:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7003A6B0027; Thu, 28 Aug 2025 18:07:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C7976B0028; Thu, 28 Aug 2025 18:07:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47D426B0026
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 18:07:14 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 84916138FF0
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:07:13 +0000 (UTC)
X-FDA: 83827552746.07.D9A5DA2
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf21.hostedemail.com (Postfix) with ESMTP id 95FFA1C0011
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 22:07:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zj0V0tEV;
	spf=pass (imf21.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756418830; a=rsa-sha256;
	cv=none;
	b=bfsE1JWVURp0Up4RWdTZPBHz3YGma426cbKzfMYvvTCWyYR0I+ghZr3z49fWdTSqwXxxJn
	DaaCfsZptBQC/N0rYXJXcFNUv3vNXMWryMupZgDM4yc3TgDvkwMtUZUcru3tqrYqA59pRs
	riIi2zRa5NgBPVcG+4xftzde2vcpMYo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Zj0V0tEV;
	spf=pass (imf21.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756418830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/AnHM5Ys5MspHOXR+HJG2nQahjdzPCxrStRtIapffc=;
	b=tnBwudYQCcbxjkGOlB+QWiTWreOijpl2zEm+KApHz+OeY65+rfzzgO3yZE89BgH6ayO87H
	5UxHp7pkoPs27ftO6hCm1YDi53B2uRveBWB8KlpUMl7vHBUYow0ivJiD5ycGXoQXTdohmV
	0Y6CJYVKQPU5sKryLQhc0BbqvORwEhk=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-45b7c56a987so3882085e9.1
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 15:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756418829; x=1757023629; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1/AnHM5Ys5MspHOXR+HJG2nQahjdzPCxrStRtIapffc=;
        b=Zj0V0tEV7/f5LE6JV9/BLBeQQSjbozgONZbIj6bqjytw/ErLAqfpltMuS5D1MlgID7
         g/UBrREZDYmkxNFJsOv/723ymtxbI9Mfclb0/IRP0+T3i3zlJGSVb1RI2zuLhq5sR7E5
         ZunRn3WKuYvez5/rj1BDM8ELlqYV6eK3x93HrNJ30UkTP3IXpbAx2PeVbQZ0KZoZlOG0
         AZTDSyP1OX1tt1k7FvyJYGOI7KSk/SOuQkCC5DkDFim5+TfRBPg0rBDzA2Tpk7icHQ7Z
         n1ozPaLactH4RT/HqfNhOyeb8Y0F9Xg+RvlrsGu/lagPWa1yunNJXff4GvS302lQ+LpS
         kxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756418829; x=1757023629;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1/AnHM5Ys5MspHOXR+HJG2nQahjdzPCxrStRtIapffc=;
        b=CpZ8QGemHsRpbnQQ2TZOzxWlK9VaH6HZsSe334bC4kxpSjIuhjDIn/af9+R1qhEI5X
         /i7icYC52TQX0z2q08JKBw//xSfs1gZ25q88w6CzZ0t4pMK45+5PX1IagrbT+gLSrys1
         /82piKlxcb1episbUP8Q5K1SQ0Mn2sL/2Q4UQGrxFCzVAiYrMKmjDcYXUh3xyZ38omtd
         yM4Stq7Vw1wpyB4t65ZArl/tRiwY6RFC1LN7ulNdFht9/EBlBwH+WFQeyyVPoj+ezDMO
         GrYCc66ztdt9e7+LNs11+fwwrt4G2RIq6KwCDWz06Z8AU66/+5WLM9rP8qoqOzWoLfpq
         Sw3A==
X-Forwarded-Encrypted: i=1; AJvYcCWa7r7vjJCBFdiQISHfcDvUxIdKMFZ6LhnKip6bmAydw3SkJScclOZhleqrhm1RkAOfuNyNLaUfCA==@kvack.org
X-Gm-Message-State: AOJu0YzTCvXOyEZMwmNH/MZ93WOfQl2A7hrHu4Hvad7kKNg5kkMNonRX
	Lk+9QwHkwmUH10eYQ7kCfvg3EYtGLTdyvtqBPs7p/zlTvp32mgo7PY7J
X-Gm-Gg: ASbGncsff+VfbgzXTZoqkTmPE9h8sBBRXkja3shvAGtmSHmNpKo8EAQWoXNOIrklLf8
	DxGos7AaZKgHxe5kaYO1Mt5RaJeFVwdpBbOGGGK2GltGflmxuOz3zQzdmGoicKc9SFQx+Wxtg5p
	CX6GtwxH2jrZMXUWPa7ln/0kYyVpNLadOjjsmhcOd8EEWq0gEn4w5P7uS6otuTK9ZEUYVEsrlaG
	Y7hReRFnxlWaGF2cglzLhYWiWEDtJKnqjs9Jr4JGqKc36IzQh0+7fh38sZCHEP9LZ6++kKVFMr9
	JWR/ReHb45DAXIgdKcVf8FO12aG/g2oGNp+Pf31PUHzt01QxRKmyk6ZbqwyHjfV6syNyyElKujG
	Tu7veSjoAGIczLq+MrFi8BZEBSy74CuIQkTTAga0=
X-Google-Smtp-Source: AGHT+IG1+AIr99KFjMYVoVuiy5WkytM9+XOL5QNqyv4VEiPFHZ/q2dKTsnCr0aimIS6RwmgQIysRjw==
X-Received: by 2002:a05:600c:1f88:b0:45b:67e9:121f with SMTP id 5b1f17b1804b1-45b67e91509mr135069255e9.16.1756418828609;
        Thu, 28 Aug 2025 15:07:08 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:72::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7e7d141esm12130995e9.2.2025.08.28.15.07.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 15:07:07 -0700 (PDT)
Date: Thu, 28 Aug 2025 15:07:01 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/show_mem: Bug fix for print mem alloc info
Message-ID: <aLDTBSuM3xVbUok2@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <aK9htWRehfJDLFJD@fedora>
 <aLATVGnVx4Z+aHAh@devbig569.cln6.facebook.com>
 <aLCMTu-Ci2yV40zn@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLCMTu-Ci2yV40zn@fedora>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 95FFA1C0011
X-Stat-Signature: bdozi3gw9y8px8ksxkszkttsdz1yxefg
X-Rspam-User: 
X-HE-Tag: 1756418830-732309
X-HE-Meta: U2FsdGVkX1/jW27q4WJ78EasAEt0aZO/bZSjoDm0CnJu7iLXZJjVJA8IMjjbeZtxjP+9G+CeCBYjZzJQgxiMiXKVZ8dNMc84kKo4LAQ3AFrB7TQcTM3kUSjDdBoynVlqkYz0Ow8XlTyN1vlomSkSdYqneHSw0XYXUdt9Tzmb5uiYWo5dUeTm1r4AhAmQoh9aX4qOa39Np/fHf59yELzDJ92yBLuDHEAZXyfjHkUb6CKQL6QRu2lkLvqawSfb88WPyvy3Y0JR6auLOQ9hfpQ1H0D7aOGQM4y8kBWbYuvSM5nn4iQpsDvZP/GQrxYp08lCoDUCRfl2Azj7Rld1Etg3AWvh76wiBR3/PTJccly4uO6wJ5CwIcOLngeD6ZvR8rwa3sQ+uEkvlAYaTNX4QZnmajxTff70cjryQLgZ0WKOuSQn6VdO2cfqTfI2m39EvuDPX0H37pHHeWir8WlGEE2LhSNySUs7LATHW1bNBVxd7zi0ggwW+BKezSlBGGLe2mWeAKALs9Gbx/QX9kOhFh8kamRVH0PGjMua7hBZ3Wcq/0TTP/0WN3Uv4nNAj07Y5/4nlxXv5AWxzPFlGPBqRA8vZSwxHuhbNT97/iN1NyOL/PXlcwONtmpC/1RZqPVbD0IvfgAUFRSXGsePSEy1Qrz5y/9T9CfXuvdR1byPxfaEnXwY2/6lrWoqYwMa6Ug2laH/7HQM96hrJVdRbQYbmThQ5sdo7NcRtuZR9VY94a5ZxAmIiZdPvg3aYUb7VYAfzgA8jDdJ3kZw2ADZwuyyVGUwo7HFjHE9trgWPru5s+AGQ8K0Re7dbkNoXH5I9z6K8IWetWaLfJGjsyua8vsTak9YnQWEwHXWbti4/BuWSri+o+6E6YDMF3v30LWbXGTIyHBW6nRjW4jzq1GXmBUQlY5KqL7GUKek+LER3KskNFh2u7Dwqpzp6cXreUmIPdKxEsAg5Gf2FyhZL4dkPhEDjWu
 V3AWNjGS
 FFZzAn8yXDpxFoXD72eTrgDs+1p0M1cM/IjOxso+AJd4hAsUcgBG+hxWDDmnxJMa+QZPNjHCBr2v1LrWdcRI2mkTWN4UMK75d8Ss7S5UOZB86aXDC469piXMha+Cj4U9kWWoiWBmZPf5sokEYils5P9HQ9qMCCQ4lezjYg88U+gYedFSzDcOqc7p+85C7Z+xn+1r8OpJVY/bOYFI+OXUyCZLEhfOUR3xxIKjgjWQSZ0e9zarxq80nAJVXQDeO4c3iaJ6bxXY61kONstchtNodOUwCWCBEVUcKGHAhlVk4SFMOmSTI2izm3hypxuFSgZZVChuuWJxJyuhcgqQw5OnWRp/cslprpJVee877fvsusCPElxGgTFMdnnUDA4EPg2bQBk3p7O6yMXKo9qLwPduFQ2BR+qrFcIM/19GoAQpJ+Rt80B0n1MdO4vsoiLwVGW7HVflkJrhqVAnhslKnzL2hNBHN3bmqR9T+dzSbkjVG5db9IzyCthfuCFE2JEXCwlLuf0yx6PWu6FVq3tpVtdk5w3XOn3nnB6e5VZRk1CVE2YvFEYLkYQAhZc68hy/K/PYAfxK6BeqoXNHv1LDeiqGBM8qCRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 10:05:18AM -0700, Vishal Moola (Oracle) wrote:
> On Thu, Aug 28, 2025 at 01:29:08AM -0700, Yueyang Pan wrote:
> > On Wed, Aug 27, 2025 at 12:51:17PM -0700, Vishal Moola (Oracle) wrote:
> > > On Wed, Aug 27, 2025 at 11:34:21AM -0700, Yueyang Pan wrote:
> > > > This patch set fixes two issues we saw in production rollout. 
> > > > 
> > > > The first issue is that we saw all zero output of memory allocation 
> > > > profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING 
> > > > is set and sysctl.vm.mem_profiling=0. In this case, the behaviour 
> > > > should be the same as when CONFIG_MEM_ALLOC_PROFILING is unset, 
> > > 
> > > Did you mean to say when sysctl.vm.mem_profiling=never?
> > > 
> > > My understanding is that setting the sysctl=0 Pauses memory allocation
> > > profiling, while 1 Resumes it. When the sysctl=never should be the same
> > > as when the config is unset, but I suspect we might still want the info
> > > when set to 0.
> > 
> > Thanks for your feedback Vishal. Here I mean for both =0 and =never. 
> > In both cases, now __show_mem() will print all 0s, which both is redundant 
> > and also makes differentiate hard. IMO when __show_mem() prints something 
> > the output should be useful at least. 
> 
> If differentiating between 0 allocations vs disabled is the primary
> concern, I think prefacing the dump with the status of the tool is
> better than treating =0 and =never as the same.
> 
> The way I see it, the {0,1,never} tristate offers a level of versatility
> that I'm not sure we need to eliminate.
> 
> I'm thinking about cases where we may temporarily set =1 to track some
> allocations, then back to =0 'pause' on that exact period of time. Memory
> allocation profiling still has those allocations tracked while set to =0
> (we can still see them in /proc/allocinfo at least). If a user decided to
> do that just before an oom, could they see something useful from
> show_mem() even when =0?

This is a good point. I agree with your suggestion about adding the state 
to print. I am still unsure about if we want to print it when =0. The first 
reason is that memory allocation profiler does not support runtime enabling 
now. We have to set it via boot cmdline. It will make more sense if we 
have this feature. Second is because memory allocation profiling is quite 
light-weighted, I would assume user really don't need this feature when 
they set =0.

The original reason why I tried to disable this is because in our production 
table we see a lot of 0Bs coming from the machines where the changes in boot 
cmdline have not been pushed to. If we have state info, we could possibly 
filter this info out before sending it to the table. So I agree upon adding 
the state to print.

Maybe others also have thoughts about this?

> 
> > > 
> > > > where show_mem prints nothing about the information. This will make 
> > > > further parse easier as we don't have to differentiate what a all 
> > > > zero line actually means (Does it mean  0 bytes are allocated 
> > > > or simply memory allocation profiling is disabled).
> > > > 
> > > > The second issue is that multiple entities can call show_mem() 
> > > > which messed up the allocation info in dmesg. We saw outputs like this:  
> > > > ```
> > > >     327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
> > > >    48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
> > > >    7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
> > > >     298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
> > > >     250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
> > > >     1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
> > > >     1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
> > > >      651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
> > > >      419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
> > > >      404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one
> > > > ```
> > > > The above example is because one kthread invokes show_mem() 
> > > > from __alloc_pages_slowpath while kernel itself calls 
> > > > oom_kill_process()
> > > 
> > > I'm not familiar with show_mem(). Could you spell out what's wrong with
> > > the output above?
> > 
> > So here in the normal case, the output should be sorted by size. Here 
> > two print happen at the same time so they interleave with each other, 
> > making further parse harder (need to sort again and dedup).
> 
> Gotcha.
> 
> > > 
> > > > Yueyang Pan (2):
> > > >   mm/show_mem: No print when not mem_alloc_profiling_enabled()
> > > >   mm/show_mem: Add trylock while printing alloc info
> > > > 
> > > >  mm/show_mem.c | 5 ++++-
> > > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > > 
> > > > -- 
> > > > 2.47.3
> > > > 
> > 
> > Thanks,
> > Pan

