Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D7EACD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 07:13:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FAE6B0092; Mon, 18 May 2026 03:13:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 330516B0093; Mon, 18 May 2026 03:13:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246476B0095; Mon, 18 May 2026 03:13:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1364D6B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 03:13:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B16CB140803
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:13:10 +0000 (UTC)
X-FDA: 84779674140.11.4ED94F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CF5EFA0004
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:13:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1CoG76U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779088389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w//u+bcu6bEFFf4hkl3TmHbxNLthvsjfAS1dKuJsB+k=;
	b=Hu9Cu7OVD7iqarDey+4YHAqQq2IQEDSKYfO3T8vp/CDTOZTmxMvSMZDEniiCjNGJf2TgIO
	OKRIwWHZGbMIlLzrmTiwz8oEUuMKHt4KERbdFGrYJDyArnGAE7Mh2oQJSSB0gTUHQBh9KS
	AbosXRvryGKfK67pfO1ivXB56qDer90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779088389; a=rsa-sha256;
	cv=none;
	b=WsNIRkZZBv59/u1N1XXKvWf4IrmrW3GUukvoCBJ+5VJlKde59c+X+G/+ApjvSGO//sTuq/
	UVwq1WpCxOEtC469PXXfX3j7eB0rVYyWrYhLDggj9M5r2kPEcEHWY5gR6N/rYLNhEQvCN7
	Sk3gk3dUuxFaLKKrG1xrjMKv6atb2VU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l1CoG76U;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B710644229;
	Mon, 18 May 2026 07:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C626AC2BCB7;
	Mon, 18 May 2026 07:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779088387;
	bh=930TpXdZ/FMxfv50jSabcgi0AeRxc9llv/0FoB5li7M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l1CoG76UtDT/Nn/abnAi6atlXDQ94ypEYxm38VavHpCrS0GfcLYc/I1gr93a08UOo
	 7LHQk7ied8yIFUz17RmGykmTb9hXjDFDVzc1voKUDTxq7nRIR4nMFbGpvt4ig+4kLS
	 PbaZM51GZF6anbCmGwJ5GUgYxuZIDeMUUOdFMQ6KD47s063qicc7kbEcNfsAU30J79
	 mkPLMGyelQdS1oG4xWZ6pMPTJXcK+TD6Idj65DsG7+iYlCCEHhCEPuBG9b3LVsSyL3
	 L4k9nLdyfvV1++nAnC0lF5EzPLz2UF/ex7yOGyzJkXaSh6ZjSESn42j4X769S1ExeB
	 chtc+Afy/fILg==
Message-ID: <c828da43-ba49-40d8-b57b-02b6f3d53070@kernel.org>
Date: Mon, 18 May 2026 16:12:56 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC] __GFP_UNMAPPED and __GFP_PRIVATE follow up
Content-Language: en-US
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, jackmanb@google.com
Cc: kernel-team@meta.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, longman@redhat.com, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
 linux@rasmusvillemoes.dk, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
 mkoutny@suse.com, sj@kernel.org, baolin.wang@linux.alibaba.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, muchun.song@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev, jannh@google.com,
 linmiaohe@huawei.com, nao.horiguchi@gmail.com, pfalcato@suse.de,
 rientjes@google.com, shakeel.butt@linux.dev, riel@surriel.com,
 harry.yoo@oracle.com, cl@gentwo.org, roman.gushchin@linux.dev,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, zhengqi.arch@bytedance.com,
 terry.bowman@amd.com
References: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
From: "Harry Yoo (Oracle)" <harry@kernel.org>
In-Reply-To: <agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CF5EFA0004
X-Stat-Signature: ro3dqsdiy5bjafwftd3cjms8b85m87xb
X-Rspam-User: 
X-HE-Tag: 1779088388-389805
X-HE-Meta: U2FsdGVkX1/sdNbtrO2m3mG/c4qKbdKEGd2nElSpTI0VbBOqhUGSUYnat/OD23jeNbzS294hjfQV0htaC5PBVvmoQU71uq5Oz34VAL/L4pKcxL1mSvKDmOwXVU32st/Z1EMmt+UPfDks6gOM/TZg6snTQgGu7yFwlSRWEB9YrHU+RdPtye6g5ZDSMteII8Nxo+iip0ZbmONye7m70sSAWO4NA+3H+36E+7rp06LOuD0VjesbJZPCPWxYx9dEfN/XLmTW2ufjA1T/EBtpzCw6hAj6l+GM4/b+mq253ERRCXCQpENZSOAT5GEefNxGV6c2bcXEx3poQJgkzax+f5AOBBONtiYTplNQ0Og+Ieolhkv5MfDBRtn525aOHD6ykT9wJjWyioF3llDmN2h/x1qBvrPjkCkgvsu73U6kfN8TVUPsoVy+U3W1ZVhaFQBrckAz0ftZhvbFkRSCtr5eovIdSRmS5I2ELpg/V2bDKOZiIRvCyhzLWezV8bZD87vQ+kIExaofikqt5cUnRRzwK6FbTr32kbKIB55LMOFeP5n4pqtiLtJ/Yy/vtzV7xoZlxgopY9JaatGJSH/lDCwWqdrWt/zst8N9IN0wq1tGzSnC2zy1vpkkq+pK4YU95ZVMw9sox2gZm0EqXM+wM40TRyT0l2gjSemUl22FLwuoyeGfR8i26GN6fqkv1wUSQviRdPwNw+qJ+biWTvfO8LEu0YSmnqqfT00DiYbWIfAtn4lfj5WIBILuqM+b3stALFEXJR9/1aQDJo/cggU/aoTc1DBi7papxhICLV5DucKrUgkdYuIQ7Tor6yTLyNL2SapBF8kBxiJ8NHEOCRm3UdIeXEZxvng4PCncHRXQo2WhUpPHs038pZnybKHT7dGMp4b4le3FhwF4kzMrHE2amIxONRa2Bns2OBo2Tkk5mcaSM/BJZs7CaeJaj5PerNL8GNca36phVx8UrUvlOOHFv3IL2r6
 O6Gtnnrb
 EoxV0gjT/to3OEdfEIYh06jzXFOeBIj9zt4F4jikcPcNwsBM4K35mtMLffImjzqSXwnUOago7dy2oe3khrA+5dThat1gWSg+oq7sYMjBdotZjPK/sFgKLmpkXBMi2+lkXCrs3S8OCSflV/WaLM4+jniHHZZpZHjbB3cSJBRysk4KWVt+ZJ0cUMEemSHc62y6gZoH8x8WGbftNZYVHkT6uLObb9URdU+Ej0SAizJSTVs5vsWG270Ha0n2c3Sxk2AHLqGMzVABP4xKMytzU3Ud39TkVccpesGFBaMVlEg0W3NlmzrPxqDAC+YmVGsnJZz+NPjNz4pb5GJRTRhH4xo5Llj1msRV5b2jkXeoOL6oTmBd+cKpjTMeoH8MBYBZXmNFrXJ6vlMxLtlYzYa9JBf3ERN0FasmP/atd/ldwFy9X4/dz2qU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/15/26 2:42 AM, Gregory Price wrote:
> The reality we really need to make the allocation request explicit
> via some argument to the allocator if we want to re-use that code.
> 
> 
> Yesterday I spitballed the addition of a new alloc interface:
> https://lore.kernel.org/linux-mm/agS76pNPlPVLgpFA@gourry-fedora-PF4VCD3F/
> 
> I cannot speak for Brendan, however, in his cover letter he said:
> https://lore.kernel.org/linux-mm/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com/
> 
>    For now I still assume a GFP flag is the cleanest way to get that
>    but in principle I'm not opposed to alloc_unmapped_pages() ...
> 
> 
> His proposal looks a lot like ALLOC_CMA, in my opinion.
> 
> I'm wondering if we can solve both of these with an alloc_context
> extension.  In fact, I'm wondering if some GFP flags should actually
> be alloc flags anyway.
> 
> We have more flexibility with alloc_flags (for now) because they're only
> defined in mm/internal.h.

It would be nice if we could have a flag for 
alloc_{,frozen_}pages_nolock(). IIRC we wanted to introduce a GFP flag 
for this.

But since it's a precious resource, we ended up with a new trick.
the kernel detects "cannot spinning on a lock" when
__GFP_KSWAPD_RECLAIM is not specified. But that caused some surprises
like commit fd3634312a04 ("debugobject: Make it work with deferred page
initialization - again") where the user doesn't want to wake up kswapd, 
but it can spin on a lock.

> Maybe we could modify alloc_flags to be a struct, and export that
> without being tied to down to a 32/64-bit flag field - and mark certain
> sets of alloc flags verboten (internally controlled / controlled by GFP
> flags, and will either be ignored or cause a BUG()).
> 
> Then we could get something like:
> 
>      struct alloc_flags {
>          /*
> 	 * internal only: will be ignored, cleared, or cause BUG() if used,
> 	 * or should be applied via the appropriate __GFP flag.
> 	 */
>          uint64_t wmark_min : 1;
>          uint64_t wmark_low : 1;
>          uint64_t wmark_high : 1;
> 	... etc ...
> 	/*
> 	 * external context flags
> 	 * allows explicit access to certain resources
> 	 */
> 	uint64_t cma          : 1; /* allows access to CMA regions */
> 	uint64_t unmapped     : 1; /* return pages in unmapped state */
> 	uint64_t managed_node : 1; /* allows access to managed node */
> 	... etc ...
>      };
> 
>      ___alloc_frozen_pages_noprof(..., struct alloc_context *ac) {
>          ac->flags.wmark_low = 1;
> 	...
> 	prepare_alloc_pages(..., ac);
> 	ac->flags.nofrag = alloc_flags_nofragment(...)
> 
> 	/* First allocation attempt */
>          page = get_page_from_freelist(alloc_gfp, order, &ac);
> 	...
>      }
> 
>      __alloc_frozen_pages_noprof(...) {
>          struct alloc_context ac = {};
> 
> 	___alloc_frozen_pages_noprof(..., ac);
>      }
> 
>      __alloc_frozen_pages_context_noprof(..., struct alloc_flags *aflags) {
>          struct alloc_context ac = {};
> 	
>          /* Snapshot to prevent external changes */
> 	ac.flags = aflags ? *aflags : 0;
> 
>          sanitize_alloc_flags(&ac.flags); /* BUG() on insanity */
>          ___alloc_frozen_pages_noprof(..., ac);
>      }


-- 
Cheers,
Harry / Hyeonggon


