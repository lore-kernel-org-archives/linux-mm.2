Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1A7EC4452B
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 21:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6530C6B007B; Tue, 21 Jul 2026 17:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 603536B008A; Tue, 21 Jul 2026 17:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FC96B008C; Tue, 21 Jul 2026 17:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF9E6B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 17:12:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1D19A02BE
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:12:55 +0000 (UTC)
X-FDA: 85014033510.29.FBBBF04
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id CC65B80014
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 21:12:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=moTgEIVr;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784668373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50DG1DUhzmetZRiBRhuUiP6VEDW+D6fHhN+LDrz6EsU=;
	b=2PU1eHiWbgarwa1lIBzp4oWFCIzNEmjL7zchhRR23eiGLnL101iAt8OmHHUHNYmPXUbcoD
	fkpozUe8yt8g4/KbHDT2RKLJC0SwRlkNZhOtRbXL1rPNnQnADkDnRfKUgIL5Id0Ap1oX2n
	N5pFbm7QzKcPFEWu3CIItv+oLqyUsRY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=moTgEIVr;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784668374;
	b=Q0mU4clsHxnOfpIvvaFwl9PDwjPOuBCqibmX+LHkDlKmJiZtswtwSWUzBTX0x37K8uvRct
	jM4l0MYP2UAstsAQgGd/5cnstYoTsn+xT4u52gnAZjFcVNDTbbXI3GZds1sbLknzzU/2Ws
	rO1kCg+20D4IbJjZuszFlNeRbPgo/rY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A5D8543D69;
	Tue, 21 Jul 2026 21:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3821F00A3A;
	Tue, 21 Jul 2026 21:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784668372;
	bh=50DG1DUhzmetZRiBRhuUiP6VEDW+D6fHhN+LDrz6EsU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=moTgEIVrWpADWURju9wqyqLD8qgacfuZLrzgUPW2PUfwS84q38YHdGjSYfwxzRrKL
	 8viY9+VAA1xGowWbdZq4mzrlUNPiG+pPM6RLC59nV4shbJh4Dqv+knroeCi5gnih/m
	 6Ul2oT7RKtL7yYe/SktlIjNlvcVyqaHlZuk09BuM=
Date: Tue, 21 Jul 2026 14:12:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-mm@kvack.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, notasas@gmail.com, vega@nebusec.ai, rakukuip@gmail.com
Subject: Re: [PATCH 1/1] mm: fix out-of-bounds access and race in
 generic_access_phys
Message-Id: <20260721141251.ea1eafd7b9a3e0c9d4d36c53@linux-foundation.org>
In-Reply-To: <f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com>
References: <cover.1784428532.git.rakukuip@gmail.com>
	<f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CC65B80014
X-Stat-Signature: 7syjsxhrt64wgzrwob7hesgnc6un3b89
X-HE-Tag: 1784668373-150326
X-HE-Meta: U2FsdGVkX1/rZYCfI8kUMhvJGIUUggdtxOpNgtt+Fp2zV/M6NjRlJELvO8fYqvtaVE8f+CSEmlwutbHVzjuEfTWtX0LCM7zntCv6hxhH1hy6CFEE4UgExRD+lAPXQuqqrXr6KExqplLrg7aiSFqUYE36dQf0QCfEORZTEvNgN1pjbEO2t2j48zcRMIlySNUu5UIf8xTIWExAbopWX+HS5JAQuJHM0SLl8O3Pdvnv6Z6zt/p8kIrPJjqYqb08xMfWJJlU9kS0N4wKM3nWmQbZA2QlCArL6Eq861G2UGSQ7p26FI2oMn76oWnUlPJqYBFxvNcs8uPCUus/Mmocp+WioPLtk0hslO0Ae8fflh/CyP3xN9LuohcO8jEa0/JrHaznKObh6pObcs1hZvdLOHD12BwdadJ4Rump+BFoyhoBxpo+84JmNx7v7/ofr7n2u+84sjRv/aQCusFatTTGl+tHlKanVngN0oiJm7t3Sf1Zn7H/EOzVH1e9i/NynfSQfGhD7E6YfFT/ZV5d0ysjYwDgoI5CWGIMHrBDu6odGLGtcjt3B63YUAneF2N+ILu0PQE6E7PmXrpT48I/M2SkCVOGlRuRebxD0aZOPrX5vXHwnjJuxzudKT63B2E5ANgCqajel5PLozecqczNyirkPnn6q48o3IRLlDu0jwQ5KxpSLs1oiwRVKfjG2Woery/OUR/lp8eDuTvsWpK6bTz87Eoa3lKnLZbxepUgDyXLyDUyc8V1k5iisq9jWXE+l4pNdywOzJkIrsy4FMmRHY/C4eHHRzaWN2SGWnnmfbFnVIoRZMydTTlCl0qFWr+82yw3KagRS8tPva5dDm6pgWx9mbbC4GF5PjL9gmGLMa42A/qF2KxCeM5vcc1TuNNUAXBJqBXSG6DjM/cGBvJ1NS/8mGs81TGiH6Ms0GqN1id0rtHyRnrW92Us9+Sn9TvZXDQ+YalCMFtRNruN0eDwWUOjL85
 Mytpccep
 r7BYNjFa0zEhj2NFYKGL/Yc7+Oo+hQWWOl6GJ+zlwQoVGLKLSBFn1BklcR41/vncwXTPbEm8RVdDDnUsiFotU2KK61XTlx11lO2TW8ba3+QriWk6p9ziAzj6zRNBcNZi/gLbXzu43eP0Qsb0xVQh7T6btjRAhLJM41V48FSE7VSY/I5+9swwDAFpJGZ7DTsADILicbxXk/jtpvjRYNvC0vJ94fg7ODJ3dJZycO4twZuHiOSzQ+Cl7sPCMBangvOcJ4YpaUmx0s7H5y5AXu/PIHJWIoO/CHjrFp0vn1xY7ejv63RWSrpv0zdxjcBdFYaazRG9guGBdoPLfPwYV0QM4Mj8f4AFxxcc0IVji0pXgTAxXUXmIBmiQFHTyQZXrRcJsNym4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 22:26:04 +0800 Ren Wei <enjou1224z@gmail.com> wrote:

> From: Luxiao Xu <rakukuip@gmail.com>
> 
> generic_access_phys() improperly validates the memory access range. It
> only validates the start address using follow_pfnmap_start() and then
> uses ioremap_prot() to map the entire requested length. This fails to
> verify if the access range stays within the VMA boundaries or if it
> crosses into adjacent physical/MMIO mappings, allowing out-of-bounds
> read or write access.
> 
> Furthermore, the previous implementation failed to handle partial
> progress semantics required by __access_remote_vm() and lacked
> necessary concurrency checks (retry logic) to prevent the use of
> stale mappings after releasing the PFNMAP lock.
> 
> Fix this by:
> - Processing memory access in page-sized chunks, ensuring every page
>   is validated within its VMA boundaries.
> - Introducing a retry mechanism to re-validate the PFN/protection
>   after mapping, ensuring safety against concurrent page table
>   modifications.
> - Returning the total number of bytes successfully copied to satisfy
>   the partial progress semantics of the access_process_vm
>   infrastructure.

Thanks.

> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6966,50 +6966,61 @@ EXPORT_SYMBOL_GPL(follow_pfnmap_end);
>
> ...
>
> +		if ((pgprot_val(prot) != pgprot_val(args.pgprot)) ||
> +		    (phys_addr != (args.pfn << PAGE_SHIFT)) ||

AI review
(https://sashiko.dev/#/patchset/f618e2f57ad0086a8d7a95cb17dcf5a1f0cf0e45.1784428532.git.rakukuip@gmail.com)
indicates that this might be missing a (resource_size_t) cast.

> +		    (writable != args.writable)) {
> +			follow_pfnmap_end(&args);
> +			iounmap(maddr);
> +			goto retry;
> +		}


