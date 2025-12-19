Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1ACE3D7495D
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A6956B0088; Fri, 19 Dec 2025 01:42:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04B506B0089; Fri, 19 Dec 2025 01:42:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E783F6B008A; Fri, 19 Dec 2025 01:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D69266B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:42:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 94447C05BD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:41:59 +0000 (UTC)
X-FDA: 84235275558.26.7F936FA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id DE844A0009
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:41:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YVtdQwEF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766126518; a=rsa-sha256;
	cv=none;
	b=NBVeOWMFFfZ/ENHs895VocU0zj4H0ELxS55qMj58U6SDzKzi4g7PJFg4lDoQNMTfJmj+WO
	5T95d39qVoCwvLqediBqsSdKrA1VeHwS0t7zMa+Pn2OdLRPp2+OnLic4P8+Bo2zuJFXNPk
	6n0SdCHbWE3++Xx/OMiO0pFZ0oBu46M=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YVtdQwEF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766126518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oAP6Z0e/yWsNG1D2mwSpfmhrnvSiAbTcGRMa3P4yRgA=;
	b=EG9pKjsq6BUMSOtv3v9nKzt1aDDusHbrZQXDzZxB7ChkHJwIqLR+UM0NTKEr3tL8gtxHRC
	outTuSPSvsg864FAYIXyv7OxwBitPpjO2XKYK5FJqxbxW/SlPkd4K9KUSNLVU3ljkaey/X
	AbYxLh6UBdJfefct0AOc58C0kl1n770=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DFE1440734;
	Fri, 19 Dec 2025 06:41:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC21C4CEF1;
	Fri, 19 Dec 2025 06:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766126516;
	bh=HzEKMFvO/dlheq7ln+rLHMiIciSJnfxSw3qvsSgM+PU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YVtdQwEF8ZPRKcW5SvddzS/n5jX0AfDpfi6uBms4JQBoUoqt9ySK4jaBmNy3/v93x
	 z6plPJd7pHQPJi0rdGg6otDHy0kDOnOtoCE44riDat91Jzd2FPuTOFQIdLPehcV8Vc
	 /9YVerVnQnb6vYuBKWOpS70A8Vj8JHFixjEJE/ZCzvJ70x1KVKgF7UfRg+VbDM6biP
	 L0AHmjPx6QGhyeO4wwyfSQCO0pA6kUpAU2yGcVd+fG4cWbmPY87ukp71Cjr3GjAVyx
	 4wLvcQ9WGBJeVO6Z6nfHX1mBcSqTDJBMEo0FVEu5YwMn/9jnbZ6mq8QvdNzts4R7p9
	 fhYRoT+OpH1Hg==
Date: Fri, 19 Dec 2025 08:41:50 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, graf@amazon.com,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, pratyush@kernel.org,
	ricardo.neri-calderon@linux.intel.com
Subject: Re: [PATCH v2] kho: validate preserved memory map during population
Message-ID: <aUTzrnz3ZBm_APmv@kernel.org>
References: <20251219030854.3527871-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219030854.3527871-1-pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: DE844A0009
X-Rspamd-Server: rspam03
X-Stat-Signature: 6wuqjpgynuimegtnraczzppse99391kk
X-Rspam-User: 
X-HE-Tag: 1766126517-996429
X-HE-Meta: U2FsdGVkX1+4fkWkFtJPxiHyReU04+nkxSjRKCuQDZ2hcyvAhfH/RGqL2F2KFDj2LYq4ZanZuv9Bd5m5aeM/FqSi1Wa7sF29t0uG/YjtTCdqbSAnxfp4eVoWuzLXz7LSgNdTtMxDA7QC+LcXJzljy82Sk7wfikDatcj4VhyDUx+YZKgXLoJky19IXoI4b3m2aGnoCNKgoCpel3CCim20RflencCQJ1MCmcr1PRdYR4j/gDbzAIyRqmsE52P1wSfRwJBpTPuOnlQLNoWGM7fyYH58VhcXHjUC6xc1VXkoft9cKj0R+bOhNI9hpqdd5fF8J8qAzBYUYJmw29Ur3+YnyVGONi2SYefR4tDEqWqDXEe+H5fXYOcPyeCK9K5Qk/xOLgtV3/hoLLWV/zP3bUV2yCaEfiCn0Bx3oBaCbnRAvtU2KXbamEzOOmKKmG3kd1456yZVtltWg15u9RYiD61E5vrFuoWnuW38OSTr/SURrSYPazXKFIa64pwN/PQvE5ppvXBXxOGVmOohs5GvDwEJx01K7uGuWUUGe//0DxT5cQPTq3sd7kqh0B7jS0NbStAHnwHVFEHjJHSkSH8tiM1L+H6CaMPqMupLrAhzFnNZPI6XPYwR8mng+uDh7NJsDkd9KqJLg6sRjslnkIEcbf6q/d/zwUo4Y828p/eSs58hWKBkgOtnSoi9tseQyZHZilL03dCWjD6R0rZHZkL2ZI4/Iq2CxfL2LhnSn2XiXeTyjIowHzCL7mayJe5Hd3eM6yHh+efQmsb/c8Z2NjPvYRXYt6W3gB+CGexSS0V+sNfWz5Xz4hfY4F/wY3Tt0e/GFZdJhx1I9eYZNtYjPyugkw7+aeIzMPg1QSj/B0xvnjIKFFjOzUj8Ky2CO6STKb80Ew8gv18XyfYm1FFZcImQhcycmVlTZzMXens2MAiRnt6lJWS5Tsg6+VuhqsItU6b+rzqgcc1lxtnJCgJ5fmFuj+0
 lRfZRRNY
 ocIOXrc+dBnJlcjQ9jxfcEDKIdD+ejNTD7qvjfCUhIOAXx2WhrD7Nl3cLhEtS4B755zhSm1t4O+wTjpZP/fH6ZsG5nNjlBrzOtxHGIgiInSyH/cGMtl67cZAcOTEt2MKbyluKsaGNmA3vZW58o+kcpTEhccT2DfbWJ8jmF7f14KK8qD+Z0JMC71XUB2VxEsvIIuCjA3ykizqXOAlmkCeoGwkiZlazV8EHvyQoOzFzpfIBLGR502pwrwaJSjGpIZvOtfR3L6IZdIwOtj6mMofvDGSwhf0NrHqqwkaf9ZT4ristRSmYqV3gAoQkv+4cEToTZNQk+v31+kuY2inPSDSeQnjg8qNkz+VJJxdwaJ4MVZt9PI/zqRB7YrKLEYNBtLZzMPPa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 10:08:54PM -0500, Pasha Tatashin wrote:
> If the previous kernel enabled KHO but did not call kho_finalize()
> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> the 'preserved-memory-map' property in the FDT remains empty/zero.
> 
> Previously, kho_populate() would succeed regardless of the memory map's
> state, reserving the incoming scratch regions in memblock. However,
> kho_memory_init() would later fail to deserialize the empty map. By that
> time, the scratch regions were already registered, leading to partial
> initialization and subsequent list corruption (double-free) during
> kho_init().
> 
> Move the validation of the preserved memory map earlier into
> kho_populate(). If the memory map is empty/NULL:
> 1. Abort kho_populate() immediately with -ENOENT.
> 2. Do not register or reserve the incoming scratch memory, allowing the new
>    kernel to reclaim those pages as standard free memory.
> 3. Leave the global 'kho_in' state uninitialized.
> 
> Consequently, kho_memory_init() sees no active KHO context
> (kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
> allocating fresh scratch memory as if it were a standard cold boot.
> 
> Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
> Reported-by: Ricardo <ricardo@example.com>

I believe Ricardo has a real email ;-)

> Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
> Changes v2:
> - Removed phys_to_virt() from kho_populate().
> 
>  kernel/liveupdate/kexec_handover.c | 39 ++++++++++++++++--------------
>  1 file changed, 21 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f..6ba554208c81 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -460,27 +460,23 @@ static void __init deserialize_bitmap(unsigned int order,
>  	}
>  }
>  
> -/* Return true if memory was deserizlied */
> -static bool __init kho_mem_deserialize(const void *fdt)
> +/* Returns head of preserved physical memory chunks pointer from FDT */
> +static phys_addr_t __init kho_get_mem_chunks_phys(const void *fdt)

Let's s/mem_chunks/mem_map/ everywhere please.
And the comment would become

/* Returns physical address of the preserved memory map from FDT */

Other than that

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

