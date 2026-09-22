Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61F64C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 12:06:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7A96B009B; Tue, 22 Sep 2026 08:06:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AF5B6B009D; Tue, 22 Sep 2026 08:06:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6896B00A1; Tue, 22 Sep 2026 08:06:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2436B009B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 08:06:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1709A120469
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:06:46 +0000 (UTC)
X-FDA: 85241271612.19.D208E4C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F38314000B
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 12:06:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGGg4AAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790078804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MxlDmX+e0b6KB3MhtozDXlgLx/F3M53sleUSkCPy1qI=;
	b=BDoUGS+dgCKuL1gFWafY/k/pVOPmf7rWnSrStBwEf5e48Zs9BCEnQDfgxqrogYFSpbpX29
	C3Bv22NfsQpTtK/3EQXZBr3MGr0wq16qPkjj7arLYypf+J50l/Vu36WFeJX/bxZ0rRJqxZ
	YQhRDunlYL8NdFmgUmhFRhlUwZ4ATD4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LGGg4AAA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790078804;
	b=d0uTcJtmZHetgdAZXi92f8PI/iFyrmVS/bzo5OBijIunmorTcxmhQmD3PDnVblMBo+KaV3
	FqO524xNJ2C5bX7YJIC7z7G16VjNzY4ae+JRwyrSzwnFNfOKW9jNb4IztUcaPh7tNGVQEF
	KwOt6/CYinUvO+NCqj7nVsfG9e+MxkE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DF22F601F7;
	Tue, 22 Sep 2026 12:06:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2674A1F000FF;
	Tue, 22 Sep 2026 12:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790078803;
	bh=MxlDmX+e0b6KB3MhtozDXlgLx/F3M53sleUSkCPy1qI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LGGg4AAAsAjFT7XGGUb3i++YdPBigXKt+aF0zsZUSNXyCIoK3TGwC+O2xBL7RaF7n
	 kokh7RjEair7AA8ebNERqQJ9dbHbj4SIedSt9G1+ITtzEBWns+AGXAdh85zjhpblZ2
	 MYrylunDpGT9u0f8adSMMDEP9taQjsGslJ/4mxEWkqDSkYfYysREuPf0ly+iqsD05N
	 gVjM/HLTV4gWrPvxkF5jBzrFxj+6cCUdVRK21Wbsx1vP6WESj9I7lVu6/nd0c3fyE2
	 HYbqTlUe1iSizJYw3fmSPg3Bnt+80bNK8gxmBUH8A8JNJprG5MChZ7GRaOsOza8YPQ
	 TOmOyO4+jIaEQ==
Message-ID: <72674485-6ec2-4cb4-a854-b937333cbf97@kernel.org>
Date: Tue, 22 Sep 2026 14:06:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: page_alloc: remove ALLOC_NON_BLOCK from
 ALLOC_RESERVES
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
 Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
 abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
 brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
 dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
 hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 mhocko@suse.com, ritesh.list@gmail.com, rvvandan@amazon.com,
 stable@vger.kernel.org, surenb@google.com, willy@infradead.org,
 ziy@nvidia.com
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it> <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
 <arFBJdYaRx_iJNDA@cmpxchg.org> <arFBr22V60BMmVpl@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
In-Reply-To: <arFBr22V60BMmVpl@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: rqhjszzyadfqdumy1we8xw9npbobibwm
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F38314000B
X-HE-Tag: 1790078804-262628
X-HE-Meta: U2FsdGVkX1/WmNe+V35iM6ZQ9bRdDZPVGt+0xwVdJNcoJh/lOwmhGyksfUYosOAoKoqw1I/o64trR6DqwpnMpAtIov/6DmXcEBgmy2+8TtuwsAmpRAeYU4VywBqsU4UV4JjvlenXC9fJzZC4JTISxRbR5Zi78t+UPOEseNPOP3VbsJ6WdtuEkuID4yzNFc4BW6C1na6ADHknB8mpq/Wq4mSjHe6n7CfAM4e0/RRRTEBjibBJzKV3VbzYcfNO/TDoS9DktUtny7UNQtO9FgAdDZJowE94tuuSdSbJPTqVmQfDXeRszpMG+UAT9c8YMvIE0CGOvG20H/1tqNV6I9rjYzaE46ZD8Y1XFGX6RgmgpZaZRWWHmQAcEZScKCgPQ2Y204uRuch6S3zD6J3k/A/bGnZyAs/Bt8T3QBYVrjDli+NktpEEPch2r12BV3CiaA7qfv7SR6apydBTNFkmYK2bVtKyMdVoNBFk1yRohoaz1hHWL8hQeo6dINbzUprOVN9F3tPWWVBUqJPs74xT+Rpke3HzCxWkwmosiuaqbtLbVRCpWnvESahcRRQP+qw14H7y8UK4G2s0AWJaIWECJqeYaYoL7nWErdePgmN1qwvj1SpcXoFGAT/aMiqrCdAW9Bcc7efoyFDXRH6L+PBF2YrJVrJysYTBk8O9Kdx2bLQ25X+pKzM0WnJGplSmg4dFZu6n+haSOi0gHKgVX4RPj10mcPFpGjs5WmKWEhG5T3HTuSKsWTeFT8eLtIzaj5Vr4aRW0/SZt/F467ai1Qk2JNUlKx6TUTPxB7fu1va8zyxBPY5y7p+WWTt20l/UAAAMuCzodGfTnZ9RcRiMCTxgns0wjHViT+B7IAArJ9J4YAYQelB9Ao7UIaklpMqnYif0DQRcgd+cD7iV9mY6o0O/mznt4yNCebFGiL3ScfgTmAMcM3+E0rMRzYWmZ1cOlRFKqTl3lazc9Sdm08DFEm0Ihga
 fyONoWop
 wSzXT7AWgJpypnCbrmigI+PTGlqzJmbTim5/FcoxMk8uzELZ+vZKmfVzU1OZeKZWSrfcWh/s4lb2a4IpmV/D4vGLdDDsymMhCrZWbwakkvPT0SE/fMdrGVsDBp+B3CuRvyMv5KIfI1pg17cL6uRWyGZogI0jm/B6DtNAOoF0N7JPQ6ua9sBfK6sZ8WlzYKuV164P3FssSGeUlsSrlvUqc7cWr/J7485NsHCj5XhEtTgMYER2QMNBJy8Odi01v26Wg65rB0VR63Ud+d/o7tFWj8Zq2GyrV047o09xxzfxxkAuD5VPuoTZror7GDvomp1DKZv28g+hcBgCv/5BYqYvfBn1icYWzNoxB8fvHQUohm8tUrxKEXtuTFZ2Rv1mxdp/xTfaoqCFAYYNyZx6xrXXwpJOv5WJo/wIsOjwrCiWYZ9oelB7013SQj2dPjS+w5aNRER7WIKWWSnMt1UJ2UqcwfYyOEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/21/26 4:39 PM, Johannes Weiner wrote:
> 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH
> non-blocking allocations accesses reserves") stopped handing out
> reserve access for ALLOC_NON_BLOCK on its own: the extra 25% below the
> min watermark is now only granted on top of ALLOC_MIN_RESERVE. But the
> flag was left in ALLOC_RESERVES, which produces something odd:
> 
> With the ALLOC_RESERVES match, __zone_watermark_unusable_free() doesn't
> subtract the free highatomic pages for them. So in the slowpath, they
> get to consume regular blocks below the min watermark by the number of
> free highatomic pages. The highatomic reserve is capped at 1% of the
> zone, which on any decently sized machine is a multiple of the min
> watermark: GFP_NOWAIT can drain regular memory to zero.
> 
> The user-visible result is brutal hiccups during bursts of GFP_NOWAIT
> allocations under memory pressure. On a 32G box with an anonymous
> working set, swap, and a filled 290M highatomic reserve, a GFP_NOWAIT
> burst drove regular free memory in the 28G Normal zone (min=60M) to
> 28M, 0.8M and 0.6M in three runs. Swapout failed to allocate its swap
> table, reclaim scanned 13M pages to reclaim 200k, page faults stalled
> for tens to hundreds of milliseconds. The machine survives it, but not
> by design: direct reclaimers eventually fail and start unreserving
> highatomic blocks, until the allocation succeeds or the reserve is
> gone and the OOM killer runs. That reserve exists for high-order
> atomic allocations; here it is destroyed to bail out a GFP_NOWAIT
> consumer that was never entitled to the memory.

This suggests to me that a LLM review of 1/2 spotted this issue and also
(or you) constructed a test doing the GFP_NOWAIT bursts to confirm the
impact, but it has not been observed in production? But if it was, can
we make it clear?

> Remove ALLOC_NON_BLOCK from ALLOC_RESERVES. With that, the GFP_NOWAIT
> burst is stopped short at the min watermark. No direct reclaim, no
> stalls, no failed allocations, and the highatomic reserve stays intact
> for the requests it exists for.
> 
> __zone_watermark_ok() is unaffected, since everything it keys on
> ALLOC_NON_BLOCK is already nested under ALLOC_MIN_RESERVE. Update the
> flag comments accordingly: ALLOC_NON_BLOCK just means the caller can't
> block; the reserve math belongs with ALLOC_MIN_RESERVE.
> 
> Fixes: 1ebbb21811b7 ("mm/page_alloc: explicitly define how __GFP_HIGH non-blocking allocations accesses reserves")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

The change itself is fine and we don't need ALLOC_NON_BLOCK in
ALLOC_RESERVES. But I wonder if we should also make the
__zone_watermark_unusable_free() check more precise, by using
may_access_highatomic_reserves() there instead of ALLOC_RESERVES?
Which would mean that the function should however also evaluate
ALLOC_HIGHATOMIC, and restrict the other checks to order=0, to be usable
from both callers.

> ---
>  mm/page_alloc.h | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> index ad89f83d1dab..c8af79decbd0 100644
> --- a/mm/page_alloc.h
> +++ b/mm/page_alloc.h
> @@ -32,12 +32,11 @@
>  #define ALLOC_OOM		ALLOC_NO_WATERMARKS
>  #endif
>  
> -#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. Allow access
> -				       * to 25% of the min watermark or
> -				       * 62.5% if __GFP_HIGH is set.
> -				       */
> +#define ALLOC_NON_BLOCK		 0x10 /* Caller cannot block. */
>  #define ALLOC_MIN_RESERVE	 0x20 /* __GFP_HIGH set. Allow access to 50%
> -				       * of the min watermark.
> +				       * of the min watermark, or 62.5% if
> +				       * the caller cannot block either
> +				       * (ALLOC_NON_BLOCK).
>  				       */
>  #define ALLOC_CPUSET		 0x40 /* check for correct cpuset */
>  #define ALLOC_CMA		 0x80 /* allow allocations from CMA areas */
> @@ -58,7 +57,7 @@
>  #define ALLOC_NO_CODETAG       0x1000
>  
>  /* Flags that allow allocations below the min watermark. */
> -#define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> +#define ALLOC_RESERVES (ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>  
>  /* Flags that mean GFP_ATOMIC */
>  #define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)


