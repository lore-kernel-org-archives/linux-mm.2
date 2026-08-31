Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828FAC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D62F6B0092; Mon, 31 Aug 2026 07:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AEBC6B0095; Mon, 31 Aug 2026 07:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC126B0096; Mon, 31 Aug 2026 07:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8F76B0092
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:16:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1EE21C201E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:16:51 +0000 (UTC)
X-FDA: 85161312222.21.A779A72
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6492C40006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:16:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bd1eZyep;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175010;
	b=Qo2gzm4z25Pj9EpFLv5akYexWLPR0doEEoi7r83o1SczbAkChx2D63fDigWIqQx7NjWcfX
	jq60U1IBQmyYEwI46LPjvDFM5h6do6PcJYQ7WuBztFM1ixDEGis8UgTm4bfSBmhSkJmmBX
	haExRfkuGYEKUnbNxO+jYy/R5fAIZhg=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Bd1eZyep;
	spf=pass (imf17.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VwdftaVIZmlh3CDWUjMMFKtdPpiSiH6htcM146k0hFw=;
	b=v2DGdS8lwpWxy3t8cZgBpBIkAvb1JhOD+dlkqbdybSzf+EPSfXvfdekCRE36/wy9JXHjzQ
	qbYc1qLbA6ObnlRvjLIwVupyuG1PcOujqTke57p5oJOPyIMP4mLjyI4dHvDcHicaJN0ONG
	jcq4L8+D+9liJXsZL7SQU5kW2CFz5yM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YWlxGEd+q0psBfApITqKzWdA2Uw4k5OebAGh84O7dtE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788175008; v=1; x=1788779808;
 b=Bd1eZyepJx6PRVcMTMWIlRP0f7pJy/cLLz2ciTdASJ1IBA23DNGpHDlL67xdx1J8o32VGXwt
 c7yOurJw6GgP/WLL7pQoUT+IVX3mddS9HpZUaXfRb85/5pIHEjeMqSff0bYZGZHMbvYAgNbR1LM
 a51mhcOaFR68btTKtJUR+iD4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5bea7a6055a809e8;
	Mon, 31 Aug 2026 11:16:47 +0000
X-Mizu-Trace-ID: 5bea7a6055a809e8
X-Migadu-Flow: FLOW_OUT
Message-ID: <249e0c30-bdd2-4dec-8c21-57cc4c2dd617@linux.dev>
Date: Mon, 31 Aug 2026 19:16:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/huge_memory: do not touch frozen folios in
 deferred_split_isolate()
Content-Language: en-US
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: ziy@nvidia.com, kasong@tencent.com, hannes@cmpxchg.org, david@kernel.org,
 hughd@google.com, baolin.wang@linux.alibaba.com, baohua@kernel.org,
 liam@infradead.org, usama.arif@linux.dev, nico.pache@linux.dev,
 dev.jain@arm.com, ryan.roberts@arm.com, balbirs@nvidia.com, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
 ljs@kernel.org
References: <20260831091514.1879786-1-kirill@shutemov.name>
 <20260831091514.1879786-2-kirill@shutemov.name>
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260831091514.1879786-2-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6492C40006
X-Stat-Signature: m73e7r1zqrs51kmf67rjbb1ppedxa3ds
X-Rspam-User: 
X-HE-Tag: 1788175009-782502
X-HE-Meta: U2FsdGVkX1/V3cUhsNtgVdv9sPU7ivcRan1/jNRnGG4S9+xFm+FkqGNQILnNuofQ/r3fnmR4kLQcfJbViQKAYInfVBqkmqXyZ3R3CKqtR1xH4m9+PZ399Arv4NpbF27npzDnhBG5fAQIWkCUZ5fiRD6lKKT8K0BgyHKCahknihnBBMoE1RtifrVZp06D2O0YoraaJXa8eDfGlzX2vAdnfpYC26nrsio8/JmmL+GiID6YmZBnaTWqCx3Q2/mBd08lnKi97DczjSiOYARDnGB9w+Vdxd1ku4gDh5PWBuRWb4S2swXcXwe3uGFK2lPh2YO++68d1XdJMhwYfEfpJEvJOUYnuL6Aun326qt1+nZcf6Mio75jVqvJkGb/FSsk7FrLP9bBujWD5MCpxQZYMfJ/ZfDk9iid09wa/blW4pc5sHnNRMm3/kRsVGArhC/4Qpqm0pntWQ425h0sbzv2XzxIjidTiyC+a51h3uRaBRmXbTmIhc21HcEOYsFz9zebRjTGuinbSI6ku+zuhwhH6fIL2Fc6yyLg+RXZBPH59jWiX9ePEeUbKQAhmUxydbzB9q7DqnWZoTRFSTVYf3S3mkUqybFp4wDMFJroRQmSh/LOvxhJr7RljNibLB9Yb9sMjMsa9MLCeEshs7DnddSsWLccO3c0VXuEOLNjgt6AHz96/KGupuYguizSvEtAXwduK8puJZ7HneJRCBTvT1C81NFBZTZBdHsz95KBMa2HHlmkZwp71y+bbu5BWls4SDYzzMcLkq/P9kyhIxt4LMVgVGOc/i5FayZnvNCtqXfzUhMDyvpvVo9u5ZoPW2X9M9PJu68VQmIEPSg8ZslHsoam4v0M1c6aeo9fUSjW/6VjcM6Lniiis7M0q+ghQ+p6D4n+uJrjoCRzJ81x0xdm8HopfSYPBja092Y8spWiRBnDnF6ORrgvCQaWtEq9YbVmckzzFBVCzQtmKKvCH7XPxgKV7pt
 dmM8DpuV
 T1WVZdpGkOh6uAQTC1K717ns6pzzsiiVMC/yUUupRLjL/LYYIPq23/lyGuFl84cyUBLJvUrkj/PzkG/uii/XGP4oCELzlFd2m3LYGAlNEkZar1uP25twBcFAQ7SN2CPcNWgDRZGxZ4CWKDUuPmmbRYwh5WmkcgALeoT63In3U6SabMf4guzIKkIlC9pvDdPwTujvySFTUEbUUZn2ITfLTCZoFWZoCCnMguPQn5z1piEzB8PR/eDYG6oq6Cp/LndRruOHs77dVTojOz4n0dmbevM+BP1yqqKevM8wgVpLvtEK10xsV12ujRd12R1xLNZSCmuc3B6FH3G5BGJOVCdJTcHy9Px5nXeTZ6PTghKd2VS2rUxOP0wAsHPSNXSIIgKuK9iVXxpC7rQebTSXDp3g/ookaRD9njJOzB0AOIOadqqOhnKI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/31 17:15, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> deferred_split_isolate() probes each queued folio with folio_try_get().
> folio_try_get() failure is treated as a lost race with folio_put(): clear
> PG_partially_mapped, correct MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, take
> the folio off the queue.
> 
> The folio_put() race is the most common case for !folio_try_get(), but
> it is not the only option. Another scenario is folio_ref_freeze().
> 
> A zero refcount in such cases does not mean the folio is going away.  It
> means "don't touch me" and current deferred_split_isolate() doesn't
> respect it. It can lead to unqueueing folios from the deferred list for
> no reason:
> 
>      CPU 0                            CPU 1
>      ---------------------------      ------------------------------
>      freeze a mapped folio            deferred_split_scan()
>        folio_ref_freeze()               folio_try_get() fails
>                                         folio_clear_partially_mapped()
>                                         NR_ANON_PARTIALLY_MAPPED--
>                                         folio off the queue
>      give up, put it back
>        folio_ref_unfreeze()
> 
> The folio is still partially mapped, but it is no longer a split candidate.
> Nothing queues it again until part of it is unmapped once more.
> 
> Skip the folio instead: whoever freezes the folio, owns it and owner is
> responsible for its fate. It also covers the folio_put() case:
> __folio_put() unqueues the folio via folio_unqueue_deferred_split().
> 
> Nothing is lost by skipping.  Everything that frees a queued folio
> unqueues it first, and folio_unqueue_deferred_split() clears
> PG_partially_mapped and brings MTHP_STAT_NR_ANON_PARTIALLY_MAPPED down
> on the way:
> 
>      __folio_put(), folios_put_refs()   mm/folio.c
>      __folio_migrate_mapping()          mm/migrate.c
>      shrink_folio_list()                mm/vmscan.c
> 
> __folio_freeze_and_split_unmapped() does the same by hand, under the
> list_lru lock it holds across the freeze.  A freeze that ends in
> folio_ref_unfreeze() leaves a folio that is still partially mapped and
> still belongs on the queue.
> 
> Fixes: 8422acdc97ed ("mm: introduce a pageflag for partially mapped folios")
> Reported-by: Lance Yang <lance.yang@linux.dev>
> Closes: https://lore.kernel.org/all/20260824131224.73344-1-lance.yang@linux.dev/
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> ---

LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

