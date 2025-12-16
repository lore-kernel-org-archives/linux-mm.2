Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4FB8D609A6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 15:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331516B0005; Tue, 16 Dec 2025 10:11:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E5516B0089; Tue, 16 Dec 2025 10:11:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21F1F6B008A; Tue, 16 Dec 2025 10:11:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D6F26B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:11:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CC07D8AFF1
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:11:23 +0000 (UTC)
X-FDA: 84225672846.02.C3D7F29
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3382620012
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 15:11:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765897882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gDM+CZRPQ21dH1svIlz6hQF9ngitkkkIJSqO7qKjJCQ=;
	b=yGutNaD5MzerThDYjWiojfPLSbIdqWUw2dQH8LjT+rY5J/ZzO8igtExEEuSoYw/ZZBOCHN
	x/84pbO7sO+tK4JCpyvuGhaym6JPzoZxXkV+Uu0kE0bkDIh89bysic0R63UV8MM1LpBYDo
	YTl3BDepxqK8BB4Z2IEkMF1QEf2VrG4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765897882; a=rsa-sha256;
	cv=none;
	b=bhoWl/meQQ+Bpq3V7wp13G1dbDYT6odwFkarp5ap5i0YtK9bIDokRFw5uFh+pLenBOfVTg
	ZIuyHEbF1FbLSooN+tguEY3viv5cp+IAdl0LrPeYk7BXBlk2K7NAfX4COmlosCnKFbukG+
	m0L6OOPKPqmur6JFZ4mkeuR9XPNGeoI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 312BAFEC;
	Tue, 16 Dec 2025 07:11:14 -0800 (PST)
Received: from [10.57.91.77] (unknown [10.57.91.77])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 241FA3F73B;
	Tue, 16 Dec 2025 07:11:14 -0800 (PST)
Message-ID: <916c17ba-22b1-456e-a184-cb3f60249af7@arm.com>
Date: Tue, 16 Dec 2025 15:11:13 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] introduce pagetable_alloc_nolock()
Content-Language: en-GB
To: Yeoreum Yun <yeoreum.yun@arm.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, bigeasy@linutronix.de,
 clrkwllms@kernel.org, rostedt@goodmis.org, catalin.marinas@arm.com,
 will@kernel.org, kevin.brodsky@arm.com, dev.jain@arm.com,
 yang@os.amperecomputing.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-arm-kernel@lists.infradead.org
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20251212161832.2067134-1-yeoreum.yun@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ck1suo7qenpfnni6zge9fp3rsshce5hi
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3382620012
X-HE-Tag: 1765897881-433042
X-HE-Meta: U2FsdGVkX1+52oN7MTx7yD49I8xWJMgNagmz4HfZPO3RAuu5MS+GxV8Wqya7BjMSyOHQ04nbo3YdY8TYTy09Zg7PtQb/S7xPem3AhOebtxNtc2eg2JjYZ/g6PFa35k3SUAANvyjsS47W5l7zGMPEPhKKhgvo/GbbCTKUd1GlV9/iWpl+3Ev4i7E+qCIxP42BorAPAJl1V/ANrXzVP1//LiaDXh6Mg79awVZewrIx85V8NNZlt9p149iPeX8DZGOjUbE3OpJufn2kGmBIJL2w8q/EjRTrYD4ka0ewL3/s9MRife3GE9JTdDuRtw/Pwiyz9f14G28L6tXl7ZpnKQoa3z9tOIc+PmzwDDtDqpQHiCUTiQANthTqx/HFril5TySFAQT/Yj6dZgFt2r8XrIib8WHAmrR4aeVp7HzAlSS8FBy/gUeVMJ5NqGlQrO67BLrlzWyx9KwRSLaeFRi45WOioY/Otf2RG7CVfs58GMqr8JXhQsIsNUrNqPEkBpQgg7+9ZmZtuNcHt4MrJf71Pxj5DjxlkPf1CQ61Pzon0YynwMgDbGE2sj/cy8mHRTHi7cnCX9p8vRf5BwT4FVwMq18Xc/RZIA5JF1eRSqIz0j+BrXNJbm26RMLr9n9VEas7u0pUkDN1kkF3uPB89RYKZldQZlYpK5HeXc6tQIwZLw5kp0sAzvMLr+xTE23RnzqUyR7I51Rf6jKG0d7z1ze4sXYCCMCK6y45WQL93P42XbYawVO3c149Lo2lr4PDlp/vqCeTgSeM9b2Om57jSlEc7IPDlCN0QEfuYjp1Qgn3/PvZAIYG74dxWVcS+atvLHuSd3Vw9HhbYLrG2aRoM3auO3yJCtTH7EjR3DYtbijkRtNOV+bgw4cgz5OFJ5szZXaZJMm2zFZXz+d6TrvjXgqqTUd3ZpeGyjZ7Q94xrg5eufXmGywHSWOh7SwBAuxLoGTgApu2+ipXaYKofy3xo4YBPWP
 M6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/12/2025 16:18, Yeoreum Yun wrote:
> Some architectures invoke pagetable_alloc() or __get_free_pages()
> with preemption disabled.
> For example, in arm64, linear_map_split_to_ptes() calls pagetable_alloc()
> while spliting block entry to ptes and __kpti_install_ng_mappings()
> calls __get_free_pages() to create kpti pagetable.
> 
> Under PREEMPT_RT, calling pagetable_alloc() with
> preemption disabled is not allowed, because it may acquire
> a spin lock that becomes sleepable on RT, potentially
> causing a sleep during page allocation.
> 
> Since above two functions is called as callback of stop_machine()
> where its callback is called in preemption disabled,
> They could make a potential problem. (sleeping in preemption disabled).
> 
> To address this, introduce pagetable_alloc_nolock() API.

I don't really understand what the problem is that you're trying to fix. As I
see it, there are 2 call sites in arm64 arch code that are calling into the page
allocator from stop_machine() - one via via pagetable_alloc() and another via
__get_free_pages(). But both of those calls are passing in GFP_ATOMIC. It was my
understanding that the page allocator would ensure it never sleeps when
GFP_ATOMIC is passed in, (even for PREEMPT_RT)?

What is the actual symptom you are seeing?

If the page allocator is somehow ignoring the GFP_ATOMIC request for PREEMPT_RT,
then isn't that a bug in the page allocator? I'm not sure why you would change
the callsites? Can't you just change the page allocator based on GFP_ATOMIC?

Thanks,
Ryan

> 
> Yeoreum Yun (2):
>   mm: introduce pagetable_alloc_nolock()
>   arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
> 
>  arch/arm64/mm/mmu.c  | 23 ++++++++++++++++++-----
>  include/linux/mm.h   | 18 ++++++++++++++++++
>  kernel/bpf/stream.c  |  2 +-
>  kernel/bpf/syscall.c |  2 +-
>  mm/page_alloc.c      | 10 +++-------
>  5 files changed, 41 insertions(+), 14 deletions(-)
> 
> --
> LEVI:{C3F47F37-75D8-414A-A8BA-3980EC8A46D7}
> 


