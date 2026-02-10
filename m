Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80BF2EA8118
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0356B0005; Tue, 10 Feb 2026 08:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7B026B0088; Tue, 10 Feb 2026 08:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CBF6B0089; Tue, 10 Feb 2026 08:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 969B26B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:45:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 587C7C1BA1
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:45:08 +0000 (UTC)
X-FDA: 84428668296.21.2C9F8C2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id AB38914000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:45:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L07Th7f5;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770731106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSwYNeCOyJFr9mH7yM3wvUmcRA7MNm7DC826kAO04RA=;
	b=K7LkPtotirq4EbPeZIFd4K2S/e0AB3orFsdlgchUPQ9tZC8BEoaTsMLm6iFFunvn6QxMDz
	jZyLhwN76AioyrfNGjL85MgOMTCSo/pRPv+t/PoW8/R20nh7A7g7NIzmQLJ4dOcLq1jkWG
	HJXsY1j4+eTBjZ1SoJsxb2Hx6Lzv4/w=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L07Th7f5;
	spf=pass (imf09.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770731106; a=rsa-sha256;
	cv=none;
	b=5j3THijTM352VaQ+CDXrdQxG4EP95nE2MHTXjDqShx5PbNTYJwYxWXBAhRUf3wGJIwJDGI
	JFX9v6EOTGMVyjtNNV67JsCRgrxWU2SCJdNSRM5C5pj7jNJ6K+YlLrlP5KnYU5Jr9SnJ34
	JS4b7V/JBMXLTOGaVtU7kVoGgvys2K8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 232E260136;
	Tue, 10 Feb 2026 13:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09900C16AAE;
	Tue, 10 Feb 2026 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770731105;
	bh=26+FDCEQwNmok8Zy9VH7xG1rfoNpFpyh5Os30EkIFhg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=L07Th7f5XZMNL4DPZNp7iGhK/MkggMhPQd+6GnpSRO9uacbIChCGIArP3Bk65MT7e
	 VeVhJoldE25cfN6Mnr0ssXWFinpEq7DyU+kTPVT3Dc+/RfRDh73hcocq+JHplE/xcp
	 3VkH4D/F4PW7wkpFZ2SZavF9ycU+9UyN6+yOMQDxqR25sjr5HE780HZXaBRIWigGsC
	 yMD6SG8159daR0BsYEMUsVHf5un/W1geMNRnsc2zn6jvopbYhfOlo0UVT/hFzpgTss
	 NOMM9bNJb1/HL4Z0+KU6IUMExl2XBc7G3ZylQHhhvXzwED9dPJIWZFC3JUNd5/IyZq
	 nmCXB/3rkO+eA==
From: Pratyush Yadav <pratyush@kernel.org>
To: ranxiaokai627@163.com
Cc: graf@amazon.com,  rppt@kernel.org,  pasha.tatashin@soleen.com,
  pratyush@kernel.org,  akpm@linux-foundation.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  ran.xiaokai@zte.com.cn,
  stable@vger.kernel.org
Subject: Re: [PATCH -next 1/2] kho: fix missing early_memunmap() call in
 kho_populate()
In-Reply-To: <20260206043121.197564-2-ranxiaokai627@163.com> (ranxiaokai's
	message of "Fri, 6 Feb 2026 04:31:20 +0000")
References: <20260206043121.197564-1-ranxiaokai627@163.com>
	<20260206043121.197564-2-ranxiaokai627@163.com>
Date: Tue, 10 Feb 2026 14:45:02 +0100
Message-ID: <2vxzv7g4sof5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AB38914000B
X-Stat-Signature: w597zj3ijxcay7aynxa7g7seup7qo17z
X-Rspam-User: 
X-HE-Tag: 1770731106-814310
X-HE-Meta: U2FsdGVkX1/5BQl9akQgVs3TkIFFK5ohYnzZbZUbq8unoG8uXsb3szg0ajHsukeHJIJlcWlRvXCxTcfzw5xwEF9+TCzE7GkZykiWYuiZFQKxt2cnGEao7CTB4p95U3u5MXbow/ayVH0RdIzxbYFE44BW80fWSdrtYhzA0e2uvpB84XRAjMdMehU/BQle8zdpWiMqakQz6SJTv4jSpYgo9O6/78aGDvIkWKKMShTglKRCq5QSFaYKlco6p4LHhk2Qh6EMUhATof6dZSiAaVgl5NMaQlLw24UH6CpelMRzlu3TlAWTHycUdb/XOid/uPlZgMZ914zXenemw0ziBugXUn4D1KDcgm8kXHr8m1rC/cSlPD/sJfcPJ+Wqn17X7q5Ub3RKzwEBAaR8oqcKZkZbnXCEjOmhZoVCaFvptsD18MzJKUZJA0V+5tXPkVXWWB+S0bFAMrRQQEasbd4XVwaHRTfc/dAefsmvNCwfT6g3meR8ZE51wqaIPErjFGGNXHxuWtVWgovYp5jxg0FH0LgVnE3SmG+ykItzO8nXlbFZJ/rHK7+xGZ3AUD4yxm7+RfPvXBFLPTdwww86+9hNFfvbmkibu2bTYZd0jx9uxWB3vZE6eL5R0queOwgdUos8xtsgqyBrpoGApavy5nm5NpIPCCNbf20EQU08qWTJRItVR4KdV3uTAsaMrZlBoSTpB0F/saFpM3mnTjpDpgfSFNMAFPENwoyQkI66gwRX9QCmENu3n+sKCfoPj5GpBghuqZmsC/0Rj6iUTtJS4nYxe16Kar1jbSVAmuQEyT7CoOU1MAvnwvEzwytRbqcBXRggYy8O+gMOgVV/TqGRhB2I+dERHlUxa/V8m48IeLEHibTQR1LAv/z4FJwFjVeiRydQGZwBokU/uI3ZCBrZDAKDVp29f6ZzmZOzruQl+PzZFbfFQ1UrjMDbEFOhtxiIXdzvR02R4pWvqzqlRv5iDXKLhSv
 6fU1RS8y
 Ko3HpfWR2S0V/reIvzxC87b4uNp13ot+faT2CW2Pd3yvEHpjXJqXJAGRvRkuT4LE3Gg8aLov/a7NCdtktOx63dM4pDyQG86SvEZTRhQNpABDNpYqBegRyzUsAXf9oz8Y2zlTIM9kJybVa2lMV/HBi6Hv0B1gSv0q+a7Jjphb1R1YJKKMNQSZlXl/aSNCxibnothw1AKga7SV5Bc1a3VLI/W95GWzZUezt0Lp58nsmrd47z6MOFOw+UD0F150H9carkt8+R8t41n+iW8wZOc+criNMJUqfpds39FI/OsRHRA6bv3lB6J/lP3/A733b/ltxc6jl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ran,

Thanks for the fix.

On Fri, Feb 06 2026, ranxiaokai627@163.com wrote:

> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
>
> kho_populate() returns without calling early_memunmap() on success
> path, this will cause early ioremap virtual address space leak.
>
> Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> ---
>
> b50634c5e84a ("kho: cleanup error handling in kho_populate()")
> has not landed in upstream, so
> Cc: <stable@vger.kernel.org> is unnecessary?
>
>  kernel/liveupdate/kexec_handover.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index fb3a7b67676e..76b714db175d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1463,6 +1463,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	struct kho_scratch *scratch = NULL;
>  	phys_addr_t mem_map_phys;
>  	void *fdt = NULL;
> +	int populated = 0;

Nit: Please use a bool and true/false. I think it reads much nicer.

>  	int err;
>  
>  	/* Validate the input FDT */
> @@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	kho_in.scratch_phys = scratch_phys;
>  	kho_in.mem_map_phys = mem_map_phys;
>  	kho_scratch_cnt = scratch_cnt;
> -	pr_info("found kexec handover data.\n");
>  
> -	return;
> +	populated = 1;
> +	pr_info("found kexec handover data.\n");
>  
>  err_unmap_scratch:
>  	early_memunmap(scratch, scratch_len);
>  err_unmap_fdt:
>  	early_memunmap(fdt, fdt_len);
>  err_report:

Nit: now that this code can be reached by non-error paths, we should
re-name the labels. I think dropping the "err_" prefix should be enough.

With these fixed,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

> -	pr_warn("disabling KHO revival\n");
> +	if (!populated)
> +		pr_warn("disabling KHO revival\n");
>  }
>  
>  /* Helper functions for kexec_file_load */

-- 
Regards,
Pratyush Yadav

