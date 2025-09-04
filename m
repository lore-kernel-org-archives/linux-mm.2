Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C1B4CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:50:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B06A6B0008; Thu,  4 Sep 2025 19:50:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 787CE6B000C; Thu,  4 Sep 2025 19:50:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C4E66B000D; Thu,  4 Sep 2025 19:50:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8256B0008
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:50:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15CDC1A0440
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:50:29 +0000 (UTC)
X-FDA: 83853214578.05.0D78B78
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id 586DC4000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:50:27 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s2q6tezP;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757029827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EcoOi63+8ErVCjATfSW78fVTOIe8m0/lvvNKJAzSLt8=;
	b=S0CzEcqGUQFPwKJ6XgJik/Rlqw/nH3t4goTQiKcgXdRcla2hxxo/0ga3Yy2q6B2TrQw2t1
	15F/3hTkTNEy1kYJxnQMqBNQt+etKC0kmS3Dc9tHPe1dK/P07w/on+owM14XaKVeh5mpQZ
	0IUXyEVcZOCTcmWmtDiNpslSg/ArQ+c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=s2q6tezP;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757029827; a=rsa-sha256;
	cv=none;
	b=YxYQ3SwNBzj+abH5GA1QOuS8BajDRR5NUXxZYDlkHK3/kIeaADZWFtLNTQLveN7MnIfTES
	6hAgLupnE60gbYsuSC0jfk275ojFtirMGSMypY+ykhbt9X9IXyY0LyD45HA/wXPgAPLLds
	VMD5MKTl4LECeh0WsdIio+fEc86c0AA=
Date: Thu, 4 Sep 2025 16:50:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757029825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EcoOi63+8ErVCjATfSW78fVTOIe8m0/lvvNKJAzSLt8=;
	b=s2q6tezPZeSmesxSDgaE8+n9vbDTU0MO+2z+vXbPRt63svdVgoDc7UT3UpTt8DErPzsBX3
	NNNgUFCG0/CBwrrH/pfNyidiqF5MIc5F/hYr8KQoD7Ar9MYzP4muLgM9puSLmNvYcgi+2g
	ggq1GbrnOO9tWPypkcNpVLh64Ra0yes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: zhongjinji <zhongjinji@honor.com>
Cc: mhocko@suse.com, rientjes@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, 
	liam.howlett@oracle.com, lorenzo.stoakes@oracle.com, surenb@google.com, 
	liulu.liu@honor.com, feng.han@honor.com
Subject: Re: [PATCH v7 2/2] mm/oom_kill: The OOM reaper traverses the VMA
 maple tree in reverse order
Message-ID: <llxw4jc4okxjxjcco5vacqiushvr642u2lto5sml3vc6wlqboe@lyfqb5anihq6>
References: <20250903092729.10611-1-zhongjinji@honor.com>
 <20250903092729.10611-3-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250903092729.10611-3-zhongjinji@honor.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 586DC4000B
X-Stat-Signature: g7yxkq5diwabrwksudha6i9gm6akbdng
X-Rspam-User: 
X-HE-Tag: 1757029827-591900
X-HE-Meta: U2FsdGVkX1/z06gFtVPj7pZS+UxF8EnekW5tahyM5ZmrDUYtkrnE8VOu7wdTCJYh0ZgZnC2KscTv9MJPGJ85VFUSgBBTdEAZuNkXQ59FAMBkom0HDuJRVIUkvNOFE0p1s43Ei0iDQcM/lrBPwMwW8CjcGLboh1T8iTSr1WnD1kjUc5vyFBQ6hiSmd+t0JxguhZ3u1MpPPY8QMP0kVmJHDLdFjbSJwb/++Eh26LyhedL9xzvQx9HKkk4rGFRLR6kqZQyCuTv5inr8jhXDCcVeR5WZe9nFgv8plYz3NF98ReVH9DQHg+A9Hd92AH1zeLndpR0xxK72HAKL+FMqGcs0cN5mitiFpzsxEYJBt2AA44dMgwyVsseB4C33Ej08Lw6moV25XMoGZ8hhyXQZEI3l1ejnniSy39zY80g1Z1ASux5tZjaft/zF8kYhElv7tmfpCRScGyv+dElK/zyDI19yEHKcrBeEVCfdduxENVwVm8jvYinCKFZiogppg+vWFDV499L688RlixEl2LI7CX7iXDr0hwK2fR+QvF+C09P3QjoEL3UfBng1cRbwJzcAGBMLOKtyEtfKTFCqkkOv3eP7faj3QbVLhhNIhR/MBDn4X9txDW7G6hO72NJST2clXOGNEGCf1cmylrjYfn58/fYT5+UHs3JJfOR6X2LFNIoHfw3v7Q2KMr6vCw8wPBWkSIC5GUBplxOMxIQ523zZ9XP+6kkpBu59y3u1nJLUzwxbe+BmRujadKaBtt5xxGSi/8Xe1+VtVGwqX1S03O22VRSnRLqlgjJleygz+7CDQeCI9TmWqgY4PcXhBZATf6wU9TS4ZiwL7AE225zEslzjJVMwqiOMSEIvjLqLNqEF1BDMtwaYRWAMDn7zu2J8MVhf72YQqAplK9LhXeKiTnbcksRs+cNtQvtmybIS6ybSYbtFjGXxkoVFpiybjdBZpNUr8KD+RW8b2SPQBnHreX3UGGd
 jRhGBR9h
 XDFGUAp6OhNno4OSuzFmHume/SAJzgDsml/8qYX0KA5JVysx//fS/oN3HDC60i7Vlw+37W/W6nkgYtxcI04xre/vlaTEvvMExwzC6yDcTwSzSx2z6Tz+9MHlZkGR4syW2sBBmXimsSm58zQMedvdA89/It4mgz3INjVa4Qk26jfmSmUgvmhim19LgSRXZUmmD0CokYUMIHUTerBUMTe5NevaP/dGIus81iEqfAx5IO+iQEh803UJBbz3Z111x1lUPCvli599L43KSh2oHtO7nWcba6eGjrfHuUNX05qizwotf2HalfKJIY7kG2NTpuhmX/yJx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 05:27:29PM +0800, zhongjinji wrote:
> Although the oom_reaper is delayed and it gives the oom victim chance to
> clean up its address space this might take a while especially for
> processes with a large address space footprint. In those cases
> oom_reaper might start racing with the dying task and compete for shared
> resources - e.g. page table lock contention has been observed.
> 
> Reduce those races by reaping the oom victim from the other end of the
> address space.
> 
> It is also a significant improvement for process_mrelease(). When a process
> is killed, process_mrelease is used to reap the killed process and often
> runs concurrently with the dying task. The test data shows that after
> applying the patch, lock contention is greatly reduced during the procedure
> of reaping the killed process.
> 
> Without the patch:
> |--99.74%-- oom_reaper
> |  |--76.67%-- unmap_page_range
> |  |  |--33.70%-- __pte_offset_map_lock
> |  |  |  |--98.46%-- _raw_spin_lock
> |  |  |--27.61%-- free_swap_and_cache_nr
> |  |  |--16.40%-- folio_remove_rmap_ptes
> |  |  |--12.25%-- tlb_flush_mmu
> |  |--12.61%-- tlb_finish_mmu
> 
> With the patch:
> |--98.84%-- oom_reaper
> |  |--53.45%-- unmap_page_range
> |  |  |--24.29%-- [hit in function]
> |  |  |--48.06%-- folio_remove_rmap_ptes
> |  |  |--17.99%-- tlb_flush_mmu
> |  |  |--1.72%-- __pte_offset_map_lock
> |  |--30.43%-- tlb_finish_mmu
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

