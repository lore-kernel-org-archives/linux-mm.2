Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB702FF8862
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 08:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00F1D6B0088; Mon, 27 Apr 2026 04:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F29756B008A; Mon, 27 Apr 2026 04:00:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E65E36B008C; Mon, 27 Apr 2026 04:00:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D857A6B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 04:00:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87A0E1607C1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:00:24 +0000 (UTC)
X-FDA: 84703588368.05.466EE30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id A8D261A000D
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:00:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vNZsVs5d;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777276822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PuZQxqHroHOLffHYEMi3Pfqn5+RFbjA73RJP47DZNxg=;
	b=bixBQaciz2XFhAVwXAe22C8tacNnhySl49x5lsUevX2Dn2okWmd+bQRH2Plu8hwlHwrAC6
	wSyadyaQCdlfPeTYpafYgo6KVpUXueXvhu/RkUh+DrZsL9yXMt+JxpEWhAvXiK4n1lvFDJ
	/SnNulkkscAAL95XhFZcWNLR18WHyyo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vNZsVs5d;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777276822; a=rsa-sha256;
	cv=none;
	b=70IesHYVG9ctC8m/MaxpgsdTZ3QeKcdiUU/sNAmZaB2lGpD17irWBeFwuPwvxofXIz7fDN
	p+Qi2I56QAcDmOQUUDYdSxmA7CKE2fZz4aJMNN18125eG1gzNe+rCiEf+5uiKEeHlX0/wP
	gqzyltLRN508UnqQp/x9XDG2RnoiOL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 91CA642D73;
	Mon, 27 Apr 2026 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FDABC19425;
	Mon, 27 Apr 2026 08:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777276821;
	bh=6lSQYBY2+IuLHDfyeYcIQP7M9ufPZ8ri79+137pQ1+w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=vNZsVs5dlJ6IIUwPClc7UZHRymQhjIiYtz4kz7lvFmHQK3+4MOCMw8gtFBpQFAy+c
	 HLiRM0b1nxo6h1KtTqewlfvqG92VW6laNBiW4JdS7lf0apSF9XsJ+6jgf4HGTHsnLB
	 FV2HKV1iVmhhpvKUPno4SpNZXdAektVWSB3+CntNHeor54MMpLDARIaAHT/ZtYf+6P
	 /fv4A+8woGTR4scKjC6Gqh+idMLufSrwNEy8xxZRTkBQA2GzO9RVyUt6ZTsYFIv/fe
	 2rEtyeSGu74o8HZDeVjqdvh3Dyd8AGTmbxAj2QnFT4hlQkZuF7/w4AbYrSR0mryuTH
	 w1r1neGMuyw7A==
Message-ID: <c3f7b8e4-85ae-4e80-bb02-a7b205cec88e@kernel.org>
Date: Mon, 27 Apr 2026 10:00:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes v2 0/2] mm/page_alloc,slab: return NULL early
 from *_nolock() memory allocation APIs in NMI on UP
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260427-nolock-api-fix-v2-0-a6b83a92d9a4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A8D261A000D
X-Rspam-User: 
X-Stat-Signature: g5aihwqgaiabhbmyq3uzou53mnj1uzwk
X-HE-Tag: 1777276822-169950
X-HE-Meta: U2FsdGVkX1+clT8DqM/8CMTEGOPuSZhl8fOs2H5PMy9EWT7g7FGf42lWEHAMokmkBXeor5haTGY+PlqXqS2EASTgfi3UZBIASeSeLU1hM11x/3nEGG2jtQR1lxgbEhcp4cXH9DxF0dlv2bungb6Bxop5bTfyNXDZ2gdTHWHQVNQKsfGcfvLyX/5xNVKY4x3BqhlHM85HiKe6kiv/4SaVmnEtCF4N1LI20io0+eaK8mnsCJ4elYrK/3FDW8kbmV08LGKRZroQHYXD7n5Tzo60I57EPe/+u52kIbUcHYAxxexC0FVKduMkGcj5bCCeH1jcLBQw9fj6HGtwTSN3UGPKTm4cWCUsOIYnsPP7brN2BRJEd7HI1Vod4+yEqXXHFThggrjm+iF/ko5ZFiQyFq5+wt+n4vfHbC48sMptG22eK3FZHw9F0FTruhiuRMKuXxf3jygm8h8BQSkwulrz6rAzOAVFkuKJ9Cgqpzv//Jm+FvkZIL3yjhcTnfiCgzWDP5xNf/VHtA5qirPvcoXUcbBfn/5TGPHzLbG8T1R9A7MNevvJBMb3Tm4SxObhPBxzDOkjKj34bGy15DlyA1T+ua9Ds06ojPXDV+la+l5MbvMkGtFpHolgA3Dx1XXJWTQ0irs0ZfMrDdH2APvFi5aq+D4WxbMc6EIYcB2SkL/d2zhWEGHD/FDkqlTaG0RA4lA3pCZsx01QER31X/J5yNeZH4Tdui4FBVS5NWL4KyYmJe5un2Td9euKqligkD8BP+JxgHyaQ0l1TZxSIucy9CsboM7M72SKxgT2MejMSxx+/s3CAfDDubIBr/5pgWG/h9+g0zXerDytgg923q8T5RPKPgeHPppoiO8dU/uoTYP/+z+7yrdapjIq89FPtBTqCU3ZwIjDZonEL29zlupysQ4d+FsnXbeJHVVfrc49BELQMl+0gCdJn2yHU6gfxSYBT8TdXce608a4wV98lYQjuoOryKJ
 HiSTXC9Z
 uvZ3pKbt/cXz5YmqtzmEQtC6443sb2dSxz4dC12VBAPqLL15nzyzYugxTxnkjCUh3T/QK6ZHv8RIR52JTNkD68QSBX+ZuxRCsFfuqO+lvjxC9s0mVAtgp/30D0VX12pncWjDePhFZg+oXTETontVFJoc/ETWpmt0bidOowxQt5qA6+f4BYiNQt/+oU2qrXuW+Ldc3zQoh1vatjfQA3V3gDQIYN1FYvGRn0dmgdSMfSIL+i3YWabs42co/cgYjJY0fJOdlYB3mrv+PAaH+6ji/0TUedL3G5fcNXHE/h0k8twK86MM+gHiV8oX6V2VOnThp8OK8hePKhfI10cs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/27/26 09:09, Harry Yoo (Oracle) wrote:
> Due to my mistake, V1 was sent twice w/o proper cover letter and
> Cc: stable. Please ignore V1. Apologies for the noise. 
> 
> Changes since V1:
> - used b4 to send patch series (w/ a proper cover letter) instead of
>   my broken git send-email script (Thanks Vlastimil)
> - added Cc: stable to patches 1 and 2
> 
> On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
> unconditionally succeeds even when the lock is already held.
> As a result, alloc_frozen_pages_nolock() and kmalloc_nolock() called
> from an NMI context can successfully re-acquire the lock that the
> page/slab allocators are already holding (no deadlock because it's
> trylock,  but leads to e.g., allocating the same page/object twice and
> causing use-after-free).
> 
> It was discovered while testing the new kmalloc/kfree_nolock() test case
> in the slub_kunit test module with CONFIG_DEBUG_SPINLOCK=y on a UP
> kernel.
> 
> Patch 1 fixes alloc_frozen_pages_nolock() and
> patch 2 fixes kmalloc_nolock().

Thanks. Given the problem exposed is in a slab kunit test I think it's
better to handle this in the slab tree. The page_alloc change is small and
should not cause conflicts. So I've merged both in slab/for-next.

> Note: As pointed out by Vlastimil Babka [1], in theory a kprobe in a
> locked section could trigger the same issue. However, fixing that
> involves a non-trivial rework (e.g., inventing a new spinlock type) or
> introduces unnecessary overhead for all spinlocks on UP (e.g., let all
> spinlocks check locked status on UP).
> 
> Given that BPF tracing on UP is rare, and it's even more unlikely to
> trace a function called from the memory allocator within the locked
> section, this patch series addresses the issue only on NMI contexts
> (which is rare as well but now covered by the new test case).
> 
> [1] https://lore.kernel.org/linux-mm/af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org
> 
> Cc: stable.vger.kernel.org
> ---
> Harry Yoo (Oracle) (2):
>       mm/page_alloc: return NULL early from alloc_frozen_pages_nolock() in NMI on UP
>       mm/slab: return NULL early from kmalloc_nolock() in NMI on UP
> 
>  mm/page_alloc.c | 5 +++++
>  mm/slub.c       | 4 ++++
>  2 files changed, 9 insertions(+)
> ---
> base-commit: ba24da38a519dfcff8cce3f3f2726d7b159a4d75
> change-id: 20260427-nolock-api-fix-bd056911e68e
> 
> Best regards,
> --  
> Cheers,
> Harry / Hyeonggon
> 


