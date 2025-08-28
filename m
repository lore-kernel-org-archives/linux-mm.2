Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 070F4CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 08:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3265E8E000E; Thu, 28 Aug 2025 04:29:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD928E000B; Thu, 28 Aug 2025 04:29:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EC8B8E000E; Thu, 28 Aug 2025 04:29:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAF08E000B
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 04:29:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B1AB65C27E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:29:14 +0000 (UTC)
X-FDA: 83825491428.03.C7A40C4
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf22.hostedemail.com (Postfix) with ESMTP id ECD6BC0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:29:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TlLb0tNu;
	spf=pass (imf22.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756369753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ryFoikwhtamjRw1NiA17KwMCvHI+xUzbwz7LQyXdMfk=;
	b=U0oXOmeIpgFso7GnCB2qSOCK4s3D3zYh2sQ7IMjDKIIc6x5Ji3T6St2SU88yoh6Fdmq1Rt
	uNAXaCI5sVwKfQo3rsZ0ShhUg2oGkVTpedugRRQgyVTm+17EtscAXSPM3y47unz3LeZb5L
	vwo2X6xUysK7/M9CPw7VLqRAPDp6XZI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756369753; a=rsa-sha256;
	cv=none;
	b=Tu1bYgJmhx21HeBI1ZgVIKO7T+EKcPpQdIsJUZq/zSoPIymRFTr5qq3GCbxmqsCS8HMkFN
	c6BU85uZFgq79mwHYiTTLM1MSqTwR66YfwIYO6I6hTjPuD4uvAM4Z0wR4tHkNTB8eFtBmZ
	u6buU8OcalM2p4rpNhpJPnsnu4O/oY0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TlLb0tNu;
	spf=pass (imf22.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-45a20c51c40so5150155e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 01:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756369751; x=1756974551; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ryFoikwhtamjRw1NiA17KwMCvHI+xUzbwz7LQyXdMfk=;
        b=TlLb0tNuY+uG96TwnUZR6GIGcerYMgGZ1NCcbp0NSlaqnXZVm7F+k/48OwF1ilz+By
         RXvBk9KuyVmMwR94svKtgtmYuVnCJHJeI+pUIdVlHhK4ztZOGG41yECTsTj1+eqQFEYs
         I1I9Dhm7rY/4W8dQsPUc8MKysiZJx70P0eV/bXnHr7A1ZxZwmeEL43uEo0fFGTGxm52v
         7oj5+y1kU40RzL/OJm7QJXQ9IilP4mRADMd0vwhGmnPY/W4it8SO4zXk+Kat4EA4elJ1
         mHpguF8VmK1hkc2ZTZi10aGnQwekQW4tDPMFtCY4lopnBJSMY9RWeGux1kOr+EoJseqm
         ZMJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756369751; x=1756974551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ryFoikwhtamjRw1NiA17KwMCvHI+xUzbwz7LQyXdMfk=;
        b=O18JsLm5s2dxkS3NsFejhJPeuO3q7aKLHFX0UpPXFkc0bKPJGEBr4PsLjwmO/LE0nK
         qH02TtKgVK84OHkmthwlaHvzp5akhjyq1BXD1CPuF6XSFf5sLsHHtCv2a/YXNKaactg6
         XKisjov9yQbBpcDmUWa/fbGw8eyAGzlSuFjVZdiz7vHbbBtdAYFcyMSS/AUj9AYcmWBm
         k1uSbtY5le6XrrTlIB7SRAz+4AdYTQBu9RqnuwMYIKCRQsP6zTOxmTPMC3MXjOKRA8th
         vwN5Y3f147qUUNt+rOgwu4BIa8IP6C5jrP2u6+hf6aL9swOlJ1yA50FZZNF2vKC+qKLh
         b1kA==
X-Forwarded-Encrypted: i=1; AJvYcCW2FnLDVr84lRy4+Ae0WBgctRKY/+8gUTY5b+0LN/EtMKLacJEXZyz0AlGUUKouIjnWztCVg8LSkA==@kvack.org
X-Gm-Message-State: AOJu0Yzn83G6gct6elor9PsdOTV4A2HthtaqDkdIRon4QDgxR+qYFiSL
	0Yf/1KxreKww6u2eawyvX6EhAyvifH01vobD6EF3B5Ge7eD4r9yZQGhGzJRxUAyiPhNN3A==
X-Gm-Gg: ASbGncti2Wnma3Ou69MsmaqxXl28+YjgKYN52c3eJW4TIhA7jVfKQqtDUFIakPT2sVj
	2yQvcIvVBgXnwfemjanK7gfPWIhRk+JylgK1oVTv4woKRX8eETdTKpskEW1WESFYQ/MsbDiTb8v
	1bh2v+IoS5swe+fC4dZJ7FGZVO+pVzxkizxbkV8NH+QjHGocT95+/am2+I/7/GFJ6HKlnrLnDAy
	7yvcwIc9WH9nQkPOdp+xj5WwmEdXGIx/3ta8CcrxfPp+QdcgPLVn9W147Q7WSJjkkZRQbsKwdPC
	VQmf7LdtHgf08wAl0MfSCTDvbbiqbRVA182tGhyp/34lVAJ/p+5qmLgS6k3+yW08YkxPk1qHaOF
	4BpKyC3Ntl/dpD2tdq41kET8l9oM1eJ5NOoUJD14zwMofRTLnWMHMQjzyfak=
X-Google-Smtp-Source: AGHT+IE0sIvr/Dhg2uhwu5NF3Oz+4LbEkvjZJ4QN1Fgg3xTGv7XSA8AcvCWCc5jJRXG3OPVYl6SreA==
X-Received: by 2002:a05:6000:4023:b0:3cb:3490:6b72 with SMTP id ffacd0b85a97d-3cb34906d34mr8075280f8f.13.1756369751190;
        Thu, 28 Aug 2025 01:29:11 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:8::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ce318fc9f4sm1368041f8f.48.2025.08.28.01.29.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 01:29:10 -0700 (PDT)
Date: Thu, 28 Aug 2025 01:29:08 -0700
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
Message-ID: <aLATVGnVx4Z+aHAh@devbig569.cln6.facebook.com>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <aK9htWRehfJDLFJD@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK9htWRehfJDLFJD@fedora>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECD6BC0006
X-Stat-Signature: kwh6biqxed53r4zoncxqxqyg4u8r41ai
X-Rspam-User: 
X-HE-Tag: 1756369752-129251
X-HE-Meta: U2FsdGVkX19J5p78sLWQM9onRefFTQZL5MNOQUsjA1twn2+iY/B2cem3dsQoHeReSma3NgiUhFl8mweCfjfQ6j7C4h4BliYvEQ11MgWzD7xbXVIUMRwZ5J8Ce5cyJ23UFjzeorS0+QVvzwbbdImjqIIdz+c48m3EbuR921Hl/9TdQ4418bdLjB0xhfnEoLAav5lKZfIpFGMI8Or+h2bnUfrUVfoGYIY8zyAmgMLGAH0j6riTcgZ2aiy9n/CdVp2Tw0oWqJ1aXQZMgT4gfjg2MRt5SdbvAYdbGRf5tZ/DKhj6NJNle0hED2a1fLRnFAd0mGMcH7eIZRiBFGncEjkw0JFb0qNroAAc0LQ0yw3oFMDLdiUiOD5UJq97PbPJz2RDWHdBtYZwGAi4ZcEfXHYH7EpOqfP/dv5L2Uvl61F9ko3JCKJZnDSrkaC5SkoGm50LtL7RU6IVh+Va68oTyQNAE62s7Oxh3HUTdBpjfuzxqPkYnRx1VB7AANTNkD/5rGBitqEjH++yXGceHz6cCi3OXZUFdBEsw+Td9w+cX+0ESRV+VzksIY21cp5RygMd51zwCKZrWQ16EWm1WSzCCWnfTn36s1mHGAmR65Q5/Yyb7EnfNiEkwJLBCxwzzs++jT0PeyRRoouF8OkpuqBEDhDRlWlA3GP7JQBooPkO3iF8uQ+0vu6se9V/iqgEw2C93Ppr+aRvaLPNMlhc2np850thHX+McZWA5UTs2F1yj/5bGYRxAz+GNha+t67ypP1ZEsb+cPrymJ/YEecWJINoqDGWnt96VSuiOov5d+Y08zSiJ4vONiPdP7CAsXw07lAWvrSRzmpEeVaE5RAbkCoK2/2Z14+/k4dkEYSuVzzAKNRLSG37uSDc4HA6r9Mipn9rmJWOrFMWKXwX9RIO7+zZ7ojv+dc+j5ecw3VGtaQGl/4KjxXYYdkePi4tzd5+cZ63R+/77+Cyz6uFaCfR8ogT/Ou
 eV7cxDkm
 4EG3CMW3EPcs6LrSW3GnnvZGXb4N906cvNnL+/gcnUhLWJS2bJ5SfabEsplpQ/dnwLdf3dj+C7aB1tf1tLBNUsI5ECRkxf4GmzU7IRpVQaixIzFn35uCkqYaPY7zvHq/SM75d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 12:51:17PM -0700, Vishal Moola (Oracle) wrote:
> On Wed, Aug 27, 2025 at 11:34:21AM -0700, Yueyang Pan wrote:
> > This patch set fixes two issues we saw in production rollout. 
> > 
> > The first issue is that we saw all zero output of memory allocation 
> > profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING 
> > is set and sysctl.vm.mem_profiling=0. In this case, the behaviour 
> > should be the same as when CONFIG_MEM_ALLOC_PROFILING is unset, 
> 
> Did you mean to say when sysctl.vm.mem_profiling=never?
> 
> My understanding is that setting the sysctl=0 Pauses memory allocation
> profiling, while 1 Resumes it. When the sysctl=never should be the same
> as when the config is unset, but I suspect we might still want the info
> when set to 0.

Thanks for your feedback Vishal. Here I mean for both =0 and =never. 
In both cases, now __show_mem() will print all 0s, which both is redundant 
and also makes differentiate hard. IMO when __show_mem() prints something 
the output should be useful at least. 

> 
> > where show_mem prints nothing about the information. This will make 
> > further parse easier as we don't have to differentiate what a all 
> > zero line actually means (Does it mean  0 bytes are allocated 
> > or simply memory allocation profiling is disabled).
> > 
> > The second issue is that multiple entities can call show_mem() 
> > which messed up the allocation info in dmesg. We saw outputs like this:  
> > ```
> >     327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
> >    48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
> >    7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
> >     298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
> >     250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
> >     1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
> >     1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
> >      651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
> >      419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
> >      404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one
> > ```
> > The above example is because one kthread invokes show_mem() 
> > from __alloc_pages_slowpath while kernel itself calls 
> > oom_kill_process()
> 
> I'm not familiar with show_mem(). Could you spell out what's wrong with
> the output above?

So here in the normal case, the output should be sorted by size. Here 
two print happen at the same time so they interleave with each other, 
making further parse harder (need to sort again and dedup).

> 
> > Yueyang Pan (2):
> >   mm/show_mem: No print when not mem_alloc_profiling_enabled()
> >   mm/show_mem: Add trylock while printing alloc info
> > 
> >  mm/show_mem.c | 5 ++++-
> >  1 file changed, 4 insertions(+), 1 deletion(-)
> > 
> > -- 
> > 2.47.3
> > 

Thanks,
Pan

