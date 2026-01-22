Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6214D3EE64
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:25:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 285CC6B01F2; Thu, 22 Jan 2026 08:25:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25D4A6B01F3; Thu, 22 Jan 2026 08:25:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A0C6B01F4; Thu, 22 Jan 2026 08:25:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E68AE6B01F2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:25:18 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 93DDA1A02CC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:25:18 +0000 (UTC)
X-FDA: 84359671116.19.00B9936
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D63DB180007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:25:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrWDFB4L;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769088317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTHvVWFze9CJnkjQ6D1yc3NzdZ7K4HhoZBQaVdDFWhQ=;
	b=kCtPdNf2GxEXfzHf2DUnLL0We/iF5fuDPPnQDrDkz7XX5OH2Jtfj1xRGmEMSVfiCzK2RBN
	0L0SPrpkB6chI9NoszIlPbaJBvZvSbZdKJ5RWtvolher31isIRWfeP175lowaT1udQZtva
	Rc01pSpwD2aVkKGIhZM1rjZHxp0i2iQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769088317; a=rsa-sha256;
	cv=none;
	b=K5bpkw9C03ydbqBgTnTeuexSDo6qGX7nM4EALGQS/wIonGNEQpx3ax/OXOqX4npRib0BFD
	dQxT83ibbnYjdUMu/hNXdx/d62Qj17HZkVBeyDIn9+tTttRzTPrOrbKQUrPWL9JmdFc3+G
	fMEy9PRO7iUww0t4DDKagnKvMf33nc8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YrWDFB4L;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC2944384A;
	Thu, 22 Jan 2026 13:25:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51BE2C116C6;
	Thu, 22 Jan 2026 13:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769088315;
	bh=d1MizkSspn35pSSs7WFrLUELoQ81+EVmGUW7ZT92Lrk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YrWDFB4LDs5qEsCqYCX4YttxexqobOOT5/sJCBLb0TEh9RryY3YsPgJZ/e5riSTlR
	 IQ30Vc0vhpPtnYWppdOv4w+ZHtC8SNvTXJ8Kif6FC36DzL2brlBX+okaosbATHG8DH
	 OiYwZLCElV2t0XYYeIHbXIiql8paKwShrc3rN80YTviSbeSNBx3NvpQpZlrT99h8QJ
	 lcXzaakIx/Lee+fvfPbbHkIMGcXMFp56ydFtnTcHz+NXe0rS/olpls4/T2D8QlvNAT
	 ed+eqflFLefMPQSfIEQwJP82SaiVpEjY5Olt34bHZaoNrvsc7amCvDKhh1gdK63vB1
	 TJJtGQeF9zNsQ==
Date: Thu, 22 Jan 2026 15:25:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] kho: cleanup error handling in kho_populate()
Message-ID: <aXIlNX5uxms5DLrj@kernel.org>
References: <20260122121757.575987-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122121757.575987-1-rppt@kernel.org>
X-Rspamd-Queue-Id: D63DB180007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: wtx8dkaz7tbnw1rzkcjfkxues7pn96cz
X-HE-Tag: 1769088316-84939
X-HE-Meta: U2FsdGVkX18gPMYq/DnrwxIH+y30IhK3LO/goIklSeuoggnGQc0tdk3+VlRAVA0ZLPCUUy7mYH6oZDyN0Haz9eMXg7q64sNF04GdaqCFg8TnzvbjjZr1V1fSuKGtS/U0AQdUHVwpetFn8CpDY3Jl5bGiIcPsN5eLVdXy/8ci6xpiJ1pbZA2VTmJyyV+BiIVWRQUzLGeJh6FjNnpUwhswnhNlaFkREH5ZnOfD8B9c8QIC9Dz0hc8zjISSaNxXOwuNKFiSZzDSx6mtaNHpEdcL9PFXnmOMKdomMNKkvklvrmck776sRIRqu0OyVyjbBZKEc/pHv9qxz28Wto7x4NvZ20SW+0tg2AJm1wxdfLp0pzIqTZNSk34HNkwLvF8LufMz+dLuxKef5kidnRNry2CxA/DpjV/WnGsUphsOV3OKg2dAPPs6MqpD5XOFYreMLujuxj2dhcOamF2wSUwi092YAsbtDHb/BHu5O1THO5HWIoTGXpXwePT2oGc5VEJnXWT56bvGOJbmRoPJuTocyXmaHixZMwTwaPhwnO4QdqCddBBKEU85hUKNCPrD4XCMaBA8exDLJCm7hveEiZakmJ9iSSgA1a3vsgg/1eVGgwqW1D8FS7tGvsO81KuyCpj3sAWLhevCskwPIINQpAK8rMGVpRrLB55CxFCiaFaQCKMiNVJa16UjmU5LSQCLfuWQ5oZ0ZFx8BXcAURIvtRWniaghT+BewQxlLM/xH5HDWgjATNlv/LgdUktZhtpbj47squxCaPkB4HMj0JCNuVSK2e668ytpapNVpob2JXTG1c5Ujb4uwbHHbvfWJuXKCkHpNh1viJVhgJiCzs+gsbz88sOnEqoxxkeoMKK3CF3/u/Xd8weagoazQCY8U0Y74IV3CiymkVwNhvoZUV6Aq/c8otx+xgGmbt7zAVEbBH+A770cRXDfUX5hzL3pdGhPkOZAnLl4KqTc6WZWMWNaRS/u8OP
 OIn4clzT
 gZiszziFQxK7Q7xgsQm7qFLtxOHCCLbtwG8TtYts2A1/8OPRMa5nz2oCAJ5GJPkk375wcyJW6LhCEuerXcVlMX6SUVBUBoqFvfbl+grI6h6ocAbHU5JJRO8V6Ov8TRbdtgMVRLa/GxNMwhYNXf0cLkKo278Ph1LhIDVOF91SEnUnckPh7EQN5jVjG3tv7WO8GPRf5khnyb8XM294zu7erwmNJezqKKSHx/afZeZccKqPM1HoqxZ2PjEmGK8F0xvw9nszA2reyVdtgAKb00b9FBfBoNmfx771TElwA9Q59pi9Fz8F7rWY+4rXkZt9rvrk/sFTq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

(cc the correct Pratyush's address)

On Thu, Jan 22, 2026 at 02:17:57PM +0200, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> * use dedicated labels for error handling instead of checking if a pointer
>   is not null to decide if it should be unmapped
> * drop assignment of values to err that are only used to print a numeric
>   error code, there are pr_warn()s for each failure already so printing a
>   numeric error code in the next line does not add anything useful
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 39 +++++++++++++-----------------
>  1 file changed, 17 insertions(+), 22 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d4482b6e3cae..e248ce2e04b7 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1441,46 +1441,40 @@ void __init kho_memory_init(void)
>  void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  			 phys_addr_t scratch_phys, u64 scratch_len)
>  {
> +	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
>  	struct kho_scratch *scratch = NULL;
>  	phys_addr_t mem_map_phys;
>  	void *fdt = NULL;
> -	int err = 0;
> -	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
> +	int err;
>  
>  	/* Validate the input FDT */
>  	fdt = early_memremap(fdt_phys, fdt_len);
>  	if (!fdt) {
>  		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
> -		err = -EFAULT;
> -		goto out;
> +		goto err_report;
>  	}
>  	err = fdt_check_header(fdt);
>  	if (err) {
>  		pr_warn("setup: handover FDT (0x%llx) is invalid: %d\n",
>  			fdt_phys, err);
> -		err = -EINVAL;
> -		goto out;
> +		goto err_unmap_fdt;
>  	}
>  	err = fdt_node_check_compatible(fdt, 0, KHO_FDT_COMPATIBLE);
>  	if (err) {
>  		pr_warn("setup: handover FDT (0x%llx) is incompatible with '%s': %d\n",
>  			fdt_phys, KHO_FDT_COMPATIBLE, err);
> -		err = -EINVAL;
> -		goto out;
> +		goto err_unmap_fdt;
>  	}
>  
>  	mem_map_phys = kho_get_mem_map_phys(fdt);
> -	if (!mem_map_phys) {
> -		err = -ENOENT;
> -		goto out;
> -	}
> +	if (!mem_map_phys)
> +		goto err_unmap_fdt;
>  
>  	scratch = early_memremap(scratch_phys, scratch_len);
>  	if (!scratch) {
>  		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
>  			scratch_phys, scratch_len);
> -		err = -EFAULT;
> -		goto out;
> +		goto err_unmap_fdt;
>  	}
>  
>  	/*
> @@ -1497,7 +1491,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  		if (WARN_ON(err)) {
>  			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
>  				&area->addr, &size, ERR_PTR(err));
> -			goto out;
> +			goto err_unmap_scratch;
>  		}
>  		pr_debug("Marked 0x%pa+0x%pa as scratch", &area->addr, &size);
>  	}
> @@ -1519,13 +1513,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	kho_scratch_cnt = scratch_cnt;
>  	pr_info("found kexec handover data.\n");
>  
> -out:
> -	if (fdt)
> -		early_memunmap(fdt, fdt_len);
> -	if (scratch)
> -		early_memunmap(scratch, scratch_len);
> -	if (err)
> -		pr_warn("disabling KHO revival: %d\n", err);
> +	return;
> +
> +err_unmap_scratch:
> +	early_memunmap(scratch, scratch_len);
> +err_unmap_fdt:
> +	early_memunmap(fdt, fdt_len);
> +err_report:
> +	pr_warn("disabling KHO revival\n");
>  }
>  
>  /* Helper functions for kexec_file_load */
> 
> base-commit: 24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
> -- 
> 2.51.0
> 

-- 
Sincerely yours,
Mike.

