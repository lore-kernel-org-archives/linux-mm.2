Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2180CC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:05:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6807E8E0014; Thu, 28 Aug 2025 13:05:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657C58E0008; Thu, 28 Aug 2025 13:05:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59C998E0014; Thu, 28 Aug 2025 13:05:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 476358E0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:05:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1AF36B7FC8
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:05:26 +0000 (UTC)
X-FDA: 83826792252.09.00B1E6B
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf29.hostedemail.com (Postfix) with ESMTP id 340A2120006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:05:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aO3nzL6G;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756400724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oaKngwQqagIZTuDtH8xBI75d9Ygzs4ncLlpZaeJH/So=;
	b=ZKisc3/pnPATHyX1/hAbY6fkjyOR0G5RZIEWR2X4cu0pfoMf4bFRHFDnwjgSVPPUskVNer
	oVHcTTQtcHGh2C5RpSNSNSw38LPlI064kDNHZWHInFlnVtH+M6fGTHJK02BbMn4Cb78k9O
	HJqjkcttTcmsn6bKVofjmxrLXdEo+vQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aO3nzL6G;
	spf=pass (imf29.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756400724; a=rsa-sha256;
	cv=none;
	b=R2P2deBb6e6SYLvojDDIS94cjFj+WUNVE/aYuhxRHMabIUyr5vs11gwwtPGKSmuq9U/Ji/
	GKB60TGEYYJjA8JkqfJ06Xd/5oq72a+e+YTooA1LCOZvxrVL3JP4RIaGkKTRciu+FTmnVF
	mZ7A+J+h0lF9AkIzXCVY1xfBuSHhIFw=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4c738ee2fbso410311a12.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756400723; x=1757005523; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oaKngwQqagIZTuDtH8xBI75d9Ygzs4ncLlpZaeJH/So=;
        b=aO3nzL6GoHGU7unLELKdxkTxciZEKjZ4LGV+cbvuWs3bNJ6QpugAYCplS3gsQcMNMA
         b8MSrWlAYJV14XkhpP6iXz7WpqcxEbgfiZBRkn6MqW6eoMLY5mS1rkjtSHIUg8R36yVB
         4if8ArYQqTzbaEtLObhQns/qbtlfY7XOoyKWm9h+K/SCkjRHeGTS6yy1TH1jstyLkKEb
         uI0HQWBAv+qvmtLryg217wNgIMy/Vc6S7qAn52uJexMICfa+4R0s/+64C7Y/mO5mTEoC
         hxdySq1i8O4pS/XHOlEgi8zigzHMG4CBqnmYkKt976cbvsx2IpPF58WZyNGyFkPhTHZm
         NnAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756400723; x=1757005523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oaKngwQqagIZTuDtH8xBI75d9Ygzs4ncLlpZaeJH/So=;
        b=GnAsvbjWN/2+4B4Nl+GDcc9YhZYIKy7q2lF+0xIVuXb/Kmw1c7nEkPHliB85+O3WFV
         TDQlNZ1sAmg0YzRMHJmI9LU9/++71pREn9C6MII9B1ZJvnAbXmlWAtuzRKcAjoDmLs3G
         ttXYJ0sVbUzUrzp6duD4tE6YlaZtz3m+0SQR4TdTW80w3IlmeLYivtZb4L10umpoKE+f
         6Dtm+IAcrlHEojYh5ecGIS7PMuNKbl4pkj4bMjJ2Lj/TNCfGmA8z/5bueBbqq3Ri3SJA
         cZa1ciDG5Cf/fgjM2Ff6kWDAR17hLk509HUBM6l9URjLykcFciyEGwI5cmdSVRyAquJR
         dLHA==
X-Forwarded-Encrypted: i=1; AJvYcCWZ+0Yos++eSh4Jusl7gGCxfbnwnkJuSPCr5TmhvYJP1A6IjYeZon6jHv5pM7dJJvyBk0M8MbNVXw==@kvack.org
X-Gm-Message-State: AOJu0Yy0LegUNz4YRfoJ6ai6Fqg+MID7UnUHASfgodPXbrwOZYGIgeIS
	oj56Ph5Cx49rgyr8rwyG48WP9C8UP2748KvEUPUrW+6HIo9m/6ZZcW5WRW0bJg==
X-Gm-Gg: ASbGncttK6fnsi4uyUZuRWdbcoJS8jU2nDMYhM42uZKlPhUrboOUC3IknhhCwv2Wlzq
	85Qmm+lH50Ns94cGX0HIF4H/cqFQ9D2fGV/HdE/dHBbSZppKRi1aaA8wZmPlzsncmggFkg4Aj5a
	NMcMSsC1pH/noqSZOm1JdpoOptfyHJDrkvH9Zp7Epy0ziB51tRBOiJAWvvVaSaYMsmUdFTo0ziP
	SLI1RMT+WaCEKCi8XQaIyKrubRJ5Lsou3sE8Hq+JqH+lqNRfiEhI01eLBJPE4ohFLHp88UydGRf
	TMWqYHS9grCkT+NX3t/4tgr8zMCTkftwF28a81tQ7Zn9muo30/y/XEyHr4AlgO7a5jZxF9H+Dqh
	SWiXX1iBAcxY5e4W9UmTKXoHvCvMR+CZQ5eQCsH9MkGamIXE0jFdoOg==
X-Google-Smtp-Source: AGHT+IEDGdjnSAyHBeE9MTUce7G4V5CtnVHQ5MuvcLxNqHjArd56/Drml7Qh+LbolqzPL9NaeoaQHg==
X-Received: by 2002:a17:902:da89:b0:248:cd4d:a72b with SMTP id d9443c01a7336-248cd4da80cmr60475305ad.20.1756400722854;
        Thu, 28 Aug 2025 10:05:22 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-249066e042asm441305ad.146.2025.08.28.10.05.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 10:05:22 -0700 (PDT)
Date: Thu, 28 Aug 2025 10:05:18 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] mm/show_mem: Bug fix for print mem alloc info
Message-ID: <aLCMTu-Ci2yV40zn@fedora>
References: <cover.1756318426.git.pyyjason@gmail.com>
 <aK9htWRehfJDLFJD@fedora>
 <aLATVGnVx4Z+aHAh@devbig569.cln6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLATVGnVx4Z+aHAh@devbig569.cln6.facebook.com>
X-Stat-Signature: coswdf87dmycydgayf13xmqqg1148xok
X-Rspam-User: 
X-Rspamd-Queue-Id: 340A2120006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756400724-774902
X-HE-Meta: U2FsdGVkX1+26hbJjm282kFTVQ/zYbjg9Q/FrwSaEz3VZ5v9O7pI+vz2EwVb1Pcstxk9E5TP16I+HEv4kqSubu93RWrrVqFuyucvrOA2/lstRUTq5tgfrFAIyKyhbnNY4yijBwMKd+x8mf5EgRIcOCZQ7Ti607yv0m2tydjwO7lrFPGivMY7kww/g7TcIcrPyxR0/F/3XRRZJPzUkprm+XgcUiL2+sExpbDPLyflSQOKkYnWaIt0/7VWwVZCIgFj5Tu2qwBCB+Wmwcf2AtkPx9etfXz4+qt5JM3vXNVvSp50GXYFWQ8IjdJQqNBUIJqalUVQO2C+8UOPsSTX1kM1dVT+PgnkldXpykYZmM0K4C8V4cVKdwEx2nQL158j+3IldReI0wcGSax28FvVlvrODZ55lWlka8JcncBqvgIWTkc81SLjWj/7l1aG8Pefa/vBmO4Lq+9nJciSavqmkkYSib7gEc69Jn9Od1vqldtjxGfTTVREfWhrEX3T8Vczz18KDsfNgHh9nXHoGjwju49nvRdhm3bHGxcuL71CC4iJ3SaQdhHjSdAN0DHTdZ3PVUs0iFnwiQRaADhCq3EleYz9pFhK+fAWTS21GYhpFh+vwBd2Y64cZNCB9dLdgbPtvcWTVdXHyX0yUt8J54AHR1E9Ci/IVMZnReVyprEPOcutK7nDuaqsNiiWqYmxpQV/3BPe+rSNnpD7k8wQ54DJrYimSUBUPFkndr/9y0oFVmCXYWVVmL9j8EVb7jCdxnrSboi3EFRa6fRICAJtjTNkrMkk+I9P4uLRrhWe9vnHij9AhdCz9c7AhoWZgHkJoQ5SECS2shHwkifch+H77lOoHFeg9WG+NDzCQPe7EUztIrbuE2/dfyWA41jagTs97hHpzzqLOMPE6UhQ5bpOq1I9qnsMw/d8T8NIkd/ueuusC+zorE0RbbxihM4F78dmR8b0KH2VV4elEEp3WFZVF3eOePw
 cUin2zt+
 1o2E9+fjWp6p55gAgWPXGo+RUPKppQkelclbyPsooH23XDxGhgvl8La2eJ1j46PuBk1cVHQfeLtEui8MQGMNcdFwDT0LaWyzc2ubXHkHq3JdbUGDdDpCAwd4qvsnAOyP8HxggZIm+qYVgESEyr12F7ONT5WLhseZX+zy1wPRjnBT9kaEwYnU7926KaAvJuHSHUybXYwtPOO81yEPT97Z+po9qLBlk6CZeT5x5K8p8WZIGg8jFM9L43Z+YEYv7YDf0GX4/S2ybpnHeNjTwYLMK+xH+sbPDm+TRLyN7W81e/BXMk6zw1mP1hbBmL7NegWIKVKVqTLyZ+kPOioGL6LJnVXyIBabbqDvJ3Gb+YSCnPZ296E0K8oGerm9nQ32AJtV5t9+BKbhE5Phq5ldOhR+Mfw+jqsNuXaaiTPowsyMQSdNh78CqxKboyOo0SF/AFapfH3CPe8tPAVx9NYMzEF0P4SEotRfV4s38GygOf+hyGVTib1wQkcD1GB/ezyxwyzmuQNxH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 01:29:08AM -0700, Yueyang Pan wrote:
> On Wed, Aug 27, 2025 at 12:51:17PM -0700, Vishal Moola (Oracle) wrote:
> > On Wed, Aug 27, 2025 at 11:34:21AM -0700, Yueyang Pan wrote:
> > > This patch set fixes two issues we saw in production rollout. 
> > > 
> > > The first issue is that we saw all zero output of memory allocation 
> > > profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING 
> > > is set and sysctl.vm.mem_profiling=0. In this case, the behaviour 
> > > should be the same as when CONFIG_MEM_ALLOC_PROFILING is unset, 
> > 
> > Did you mean to say when sysctl.vm.mem_profiling=never?
> > 
> > My understanding is that setting the sysctl=0 Pauses memory allocation
> > profiling, while 1 Resumes it. When the sysctl=never should be the same
> > as when the config is unset, but I suspect we might still want the info
> > when set to 0.
> 
> Thanks for your feedback Vishal. Here I mean for both =0 and =never. 
> In both cases, now __show_mem() will print all 0s, which both is redundant 
> and also makes differentiate hard. IMO when __show_mem() prints something 
> the output should be useful at least. 

If differentiating between 0 allocations vs disabled is the primary
concern, I think prefacing the dump with the status of the tool is
better than treating =0 and =never as the same.

The way I see it, the {0,1,never} tristate offers a level of versatility
that I'm not sure we need to eliminate.

I'm thinking about cases where we may temporarily set =1 to track some
allocations, then back to =0 'pause' on that exact period of time. Memory
allocation profiling still has those allocations tracked while set to =0
(we can still see them in /proc/allocinfo at least). If a user decided to
do that just before an oom, could they see something useful from
show_mem() even when =0?

> > 
> > > where show_mem prints nothing about the information. This will make 
> > > further parse easier as we don't have to differentiate what a all 
> > > zero line actually means (Does it mean  0 bytes are allocated 
> > > or simply memory allocation profiling is disabled).
> > > 
> > > The second issue is that multiple entities can call show_mem() 
> > > which messed up the allocation info in dmesg. We saw outputs like this:  
> > > ```
> > >     327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
> > >    48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
> > >    7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
> > >     298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
> > >     250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
> > >     1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
> > >     1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
> > >      651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
> > >      419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
> > >      404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one
> > > ```
> > > The above example is because one kthread invokes show_mem() 
> > > from __alloc_pages_slowpath while kernel itself calls 
> > > oom_kill_process()
> > 
> > I'm not familiar with show_mem(). Could you spell out what's wrong with
> > the output above?
> 
> So here in the normal case, the output should be sorted by size. Here 
> two print happen at the same time so they interleave with each other, 
> making further parse harder (need to sort again and dedup).

Gotcha.

> > 
> > > Yueyang Pan (2):
> > >   mm/show_mem: No print when not mem_alloc_profiling_enabled()
> > >   mm/show_mem: Add trylock while printing alloc info
> > > 
> > >  mm/show_mem.c | 5 ++++-
> > >  1 file changed, 4 insertions(+), 1 deletion(-)
> > > 
> > > -- 
> > > 2.47.3
> > > 
> 
> Thanks,
> Pan

