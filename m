Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38DCFCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 14:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68FF18E0145; Tue,  4 Nov 2025 09:32:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 640DA8E0124; Tue,  4 Nov 2025 09:32:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 556BC8E0145; Tue,  4 Nov 2025 09:32:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4142D8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 09:32:04 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E43B288D4E
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:32:03 +0000 (UTC)
X-FDA: 84073164126.26.EC58889
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5E3EF40011
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 14:32:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnaL4sZQ;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762266722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nb1bYuG05zbFdQL1R98XA+IFCzV7NinUKDDK2JN4fzI=;
	b=SJMsr8VflQVGO8uEU4mBlysRZKGYRSOPYV5VkG/PFkMCQsvhU8VTOpD1ihhzI1FdwriOoo
	frp8hTLWMiHkoRUgVSCsAOHpdz2PQSzd9OGAhyT1NpyIPRGnnhilCCoR3NvWNtRVL9+Jao
	7hfLXYRfHkuPEoopzSidA0zJojapfyM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnaL4sZQ;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762266722; a=rsa-sha256;
	cv=none;
	b=fLQRE1VQJj6b58sv9xy2VETdWNtB6RJgFv3evf18J2O5HVgUFFdRS6TRvc6oXEccr5HYqG
	9TKuWVghRBzJpjAPL0DX/F3UsFZSzIiogRbz+eV0WBXsECwZVb347slMbxQEuLzURgu+RC
	IBL9NyhERGpDXlskRcj5zs2qlfert3U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D43C601EB;
	Tue,  4 Nov 2025 14:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AD56C116B1;
	Tue,  4 Nov 2025 14:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762266721;
	bh=8W4axGtzep0PSa+t2A3pgDKAtbFw4XdyrfNDp7pGJnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jnaL4sZQvfUoDwrR8UBqQ5So4v/ALu+u4JJclBYQEgXnbBy1fQMQxod8h80BQRPux
	 YWEvy3nrChwSkoq1bXsoyPkyl0so63krb67i2xL5N7xeslpYw7ok8e0IQvANfsGUiL
	 S+cK8pbsHqL0La+kI9pQgqUW4kS2a/2Re1Q9NIawUGMEYUVwvj/Wvrlp66w/gtF4//
	 opsJTg6nCMLJd96BsYddpZW1PyYxrqkaTBcFGvynSnd9elqBWbyjPG6Gz+otq57fK5
	 bwk8+LWv7a3zghpNBuu4fse44vxjAkY0KhdEaJfsA7gICwvoGA30Ezvc/ekZwkgpKL
	 6KEN/WRMMJtfA==
Date: Tue, 4 Nov 2025 16:31:54 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: fix unpreservation of higher-order vmalloc
 preservations
Message-ID: <aQoOWtjJWjr81lBj@kernel.org>
References: <20251103180235.71409-1-pratyush@kernel.org>
 <20251103180235.71409-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103180235.71409-2-pratyush@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5E3EF40011
X-Stat-Signature: 6ppmodho11hdjq8kgwj5s4g8xwhz48s6
X-Rspam-User: 
X-HE-Tag: 1762266722-400091
X-HE-Meta: U2FsdGVkX1/PgTZJeVzzaFmUkje2dhUtKup9z8FyktuHH068sf7xCHi6JSDnxr/gwM6ilK2djfc1ssKl2XMmzLDo8L44nE3ua4HMH53Kiz9PRqd7acw3sjsORcAkzYfQPwenOpdUFU22WJ6uSrE5GefWi7sFmdloScWnvnbcFgArwt7fhmcF22MtPmKjcA3FGuOdSlP3Bvhf2q063WPSfz8tOE12au3arIxVIoBomksxJM5QdS2fOw8aVo9moSaobrT/Gm87Io+OSWN965KiBwLO/ZUQmRiTeOfcf0oHU/jIhA3HDF64y30R4/AkwaT4W+0mTgRQHPLt1fE4n9N9cjcDWlFQcmtSuvmeTE9WndLNhVJSQgM7AI8rDtbi86s2xbpFr4Qh9fTgthVjsChYbAO0Tgu2uFCy9sZ/n0iG141LUf3gJ2BICVUSgEunqhvjNcHjTQJrm3akGD1GkKNNTLuvtv4Ax+jgnufWS3Eep7tF98yuyq2DBMP9IHHfQzMBipp93X0U2vyRqxuoDYSuUjDGg68mNZRHcWmMsJBscrgIwkPtV+Ha/lcQDHHKD+YHC3xb3S4Tmp/ANZkjVtAizIoIQaGzHh3MLzZ63+wIdZ+5Hb0s+BDllS0uNwls+J095dksSGWKpm8XR+LRxJwh9MO9Wdm6xuVVfesN2uwoIfibNJ9VBPTT8mlNEYB+YDdyKiCWvpVpSxlwB3eaC2+kgBh4R/oSG/6/OodbUfEA4xV0+e3Wwl01Ir1HegcZM+ZbtU5AtUSbAv2S7DS2EaMpmAgivpPX5LeU5fPy13cEaRHkzvFF9BvKKpvkiYWBnF1b81CSjKyT8Kfgu0nyCZV7Aywut8YVb7zz1ZV8a9dxpf9liiTFyJIhIZy65tPaw6Q2BEJ8PVSdTFpuxtkIKEMTkUBrX5enO9GiK26bwNflIlZmSWb4q3Zx9vO+TAw2MoPn8f+gGt1+g8R/jc8SrFl
 TExCVTbE
 H5UVNMVaJBPN/ByE+VdbOCQUuRioOX2GjYbfHZPGo2G7rIEg76LRTWjTJ9tqSlkEvqsNCI7Arb1tfTVGAfD9MaLBHoBJRRDEtgnvcfxIXF5eBBpglsIHZr50qX339P8t0/SwrB7FdmO0QEAxUyburqgFV8HJleioggfvUl6fj9CoxB4dI0E/2N2xn4O2JfMarwIX+B7/0q2Pb+mnl1PKtwST4FTUxTemU+vLwNd3XqKQ9iv+5XwqSUcT43gSGYHcBeHa0/qCydtsgprKEA+Z2ylDU0gmm+ePWaomER5dBw5nlqGZbseqFA9TR+gibUVnckVIgQd9aOfCHwzIKTgvkk4+Chw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 07:02:31PM +0100, Pratyush Yadav wrote:
> kho_vmalloc_unpreserve_chunk() calls __kho_unpreserve() with end_pfn as
> pfn + 1. This happens to work for 0-order pages, but leaks higher order
> pages.
> 
> For example, say order 2 pages back the allocation. During preservation,
> they get preserved in the order 2 bitmaps, but
> kho_vmalloc_unpreserve_chunk() would try to unpreserve them from the
> order 0 bitmaps, which should not have these bits set anyway, leaving
> the order 2 bitmaps untouched. This results in the pages being carried
> over to the next kernel. Nothing will free those pages in the next boot,
> leaking them.
> 
> Fix this by taking the order into account when calculating the end PFN
> for __kho_unpreserve().
> 
> Fixes: a667300bd53f2 ("kho: add support for preserving vmalloc allocations")
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Notes:
>     When Pasha's patch [0] to add kho_unpreserve_pages() is merged, maybe it
>     would be a better idea to use kho_unpreserve_pages() here? But that is
>     something for later I suppose.
>     
>     [0] https://lore.kernel.org/linux-mm/20251101142325.1326536-4-pasha.tatashin@soleen.com/
> 
>  kernel/kexec_handover.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
> index cc5aaa738bc50..c2bcbb10918ce 100644
> --- a/kernel/kexec_handover.c
> +++ b/kernel/kexec_handover.c
> @@ -862,7 +862,8 @@ static struct kho_vmalloc_chunk *new_vmalloc_chunk(struct kho_vmalloc_chunk *cur
>  	return NULL;
>  }
>  
> -static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
> +static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk,
> +					 unsigned short order)
>  {
>  	struct kho_mem_track *track = &kho_out.ser.track;
>  	unsigned long pfn = PHYS_PFN(virt_to_phys(chunk));
> @@ -871,7 +872,7 @@ static void kho_vmalloc_unpreserve_chunk(struct kho_vmalloc_chunk *chunk)
>  
>  	for (int i = 0; i < ARRAY_SIZE(chunk->phys) && chunk->phys[i]; i++) {
>  		pfn = PHYS_PFN(chunk->phys[i]);
> -		__kho_unpreserve(track, pfn, pfn + 1);
> +		__kho_unpreserve(track, pfn, pfn + (1 << order));
>  	}
>  }
>  
> @@ -882,7 +883,7 @@ static void kho_vmalloc_free_chunks(struct kho_vmalloc *kho_vmalloc)
>  	while (chunk) {
>  		struct kho_vmalloc_chunk *tmp = chunk;
>  
> -		kho_vmalloc_unpreserve_chunk(chunk);
> +		kho_vmalloc_unpreserve_chunk(chunk, kho_vmalloc->order);
>  
>  		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>  		free_page((unsigned long)tmp);
> -- 
> 2.47.3
> 

-- 
Sincerely yours,
Mike.

