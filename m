Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8F6B606D80B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=SXTVQlGK
Received: by kanga.kvack.org (Postfix)
	id A86766B00EF; Tue,  3 Nov 2026 14:48:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E516B05B1; Tue,  3 Nov 2026 14:48:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D776B05BB; Tue,  3 Nov 2026 14:48:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68A1F6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:40 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09F10A0448
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:48:40 +0000 (UTC)
X-FDA: 85394845200.07.490EE6F
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id 34DB41A0007
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:48:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SXTVQlGK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793735318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmIYdzsXtSLJ4H9TN4ODtrKjdEj6BTA0VO5FF1tJVsk=;
	b=nKmhftAz3H5Da4CMOl290h6TKWVwlN89H+nzo5mno2ZR8SmUL8kLUrvnJvrx+RVx6GOANN
	dK63R9oluv5VRymgmnzHQNIMSkMplSd9f1iFBb6pZznL/16LbRC3No/WRfZ2AZUT4D/hPc
	FdL0aZNUTT952SRPu5mp7xkYH1PYHbo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793735318;
	b=FWbJsgpl3wmOki9DuqP8Ifxf2hXf3T+we3YMR9/evS/JskwLKNViy80pXri2D0TwpbhPFC
	oVPijTuJqoLY7XYF6BBbFI64ZETM5UUS6lryYdnmu4fjQVCDTcXbL/JKyJCAtlyVbv9MfU
	KMQQxLBFRZTgAC50kRlrqKXHzswIb80=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=SXTVQlGK;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-7a6e560f580so3082287137.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 11:48:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793735317; x=1794340117; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mmIYdzsXtSLJ4H9TN4ODtrKjdEj6BTA0VO5FF1tJVsk=;
        b=SXTVQlGKi0Zdhx77L9yUM7Qu8viCSnUrnTzeiRkaM5n9H5G9gf18P4gLPadTM20RCs
         Og+u3oPiGH4by3mgVUwoFx8Wjvy+4Wg6cFSCr3bCwTT4y78Sy8c3Qr8You8lClcrTrza
         CbIEXL47993sl6mZK+xNqti7hYN301Ly4FKuE8RiE5ijgbFn3m5fuJ7ItxtnIBEnnUfm
         OqMMO1Zc5VkdDUfFsKrQxX0jTSkUteWnN8V/Lx7NVfayBUXoIjETeQumW7q0ZDPbkzcX
         jrkVvnrjGM0EoJyUkelAwohhtm8XajypPfmCatztwPfEdyOFOErac9+t5md0xRLlz0nE
         ZaRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793735317; x=1794340117;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mmIYdzsXtSLJ4H9TN4ODtrKjdEj6BTA0VO5FF1tJVsk=;
        b=ZTnbwYthLcuoyX/8TnLY3N8dRHi3W889DUin1AOws9YkPU1Z0kveqTvCpE/c0xC5br
         s1FvxU7FxiuSk9yV9gOtuVQ1iTkU6cJG+95/g7XHc7gwMBJ8jUrEZvL8dwmQMDJE7rkA
         XiAA4bRiLsxPcOkCgu27qoAAZrdecD0ojkZXk8WCWFrcmrx8OS4I2iVCQ4IrfuxhTgWO
         UokYmhAI4iQ9OO28ibnxPJHamflKN/KcaD74WHyJWNHatO9/rBhu0SUmp4WVSwhSjAgm
         TQzCMXvZdm9kZhEQ3PU4pLYumkeDzaWGsCjK4R2eSGXw2qCeYY4x//RDCtzUIhOAgUlJ
         SnTQ==
X-Forwarded-Encrypted: i=1; AKwUvBw230Zgx7fm6OYQKug+z0xUg88bQmEZl7sTItOZFpM9G2E6Vfiy2foM2/8cU6hKgR73z6Ite+t4iw==@kvack.org
X-Gm-Message-State: APuU4Z9K/fwibnRS+ic9rWRMqtqjP2SUe5rOPfxZVwawNbuwN9C6hBIk
	yv1Dc+jjSCzhxyjedFm65DxCHsYw3eFkGBNpPzb26Tv8P6h8EbMHPHtld7ZGwsfDedc=
X-Gm-Gg: AYBFou30qu6xkXRuuYkYqJjTkDNsMMBWHBzM0KDc9mEDCbbD9Z3m7Ue28OFWNsR0qgp
	Sjv/RQ73PWLuEJ12yzKeGHzfqI39/shfihq65bA4JmzLdzrS0Y3jWOEo3yH8nRudGTrhRgBecya
	CfUfkybVfoDyED8WOQl2ROqjuMqTr1C8L5xBd1XkMLkv5L5bVTCoT9k9DIFRKhC8Gqt8thNJ0kr
	fsfcxxtc51ORL/kacnz6MrxTbVL/8EdroJ9Or+Gayg2Z0cYdyEFVZ9n1TQJlIUHz5FkUFv1kPmw
	3flGXqi7OFS1W3EFooW+M+19khahMISscxRzG1YIxMc+KhuP9wJBZ/Q87Zf9RIQzuDQC/Cvg1w3
	7srHsOidj50T7CZHjmkk4Ck9x5WJZMJNwUkZVp2U5mn5GJxkOqF0R/bv3Aap8Gm3faUjoKvht/n
	TVsXZXPJnck8lRjrr5+ytIJxomaaqH8p8hiWUkfBRN8z/wep5nvnOgtDIUs01X50Vmi5yZ08oB9
	vna3lt70KDZ7ja63u1D/qn88OlD3pJCN7U6Ohkk9HTq77nUBY9hDmqrdhghfNlUpVVAL2vTv1B6
	wx23w2Puzi7oNzeiXoJDHEnJgKnBlzIxt73ILTDfWumebxf2G/sVG0HNDhgU+stwkgCfUfthq0S
	xogje/Il3GU9H6uYfD88RdZ2LLo/3G5c=
X-Received: by 2002:a05:6102:549f:b0:7c3:ac79:9b09 with SMTP id ada2fe7eead31-7d072735c70mr6239243137.30.1793735317321;
        Tue, 03 Nov 2026 11:48:37 -0800 (PST)
Received: from google.com (64.167.245.35.bc.googleusercontent.com. [35.245.167.64])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d9c906fcsm51783241.11.2026.11.03.11.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 11:48:36 -0800 (PST)
Date: Tue, 3 Nov 2026 14:48:36 -0500
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chen Pei <cp0613@linux.alibaba.com>, 
	George Guo <guodongtai@kylinos.cn>, Kexin Liu <liukexin@kylinos.cn>, 
	Sourabh Jain <sourabhjain@linux.ibm.com>, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH 1/2] kho: skip zero-sized lowmem and global bootmem areas
Message-ID: <auo3PzmisfK3br1l@google.com>
References: <20261103-kho-bootmem-sizing-v1-0-45aa74098f34@kernel.org>
 <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103-kho-bootmem-sizing-v1-1-45aa74098f34@kernel.org>
X-Stat-Signature: pp7bcpnxhsou1fowiqrrjm73wmqkxy9z
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 34DB41A0007
X-HE-Tag: 1793735318-496849
X-HE-Meta: U2FsdGVkX1+fkuFWA9iMy6Ro7qIZQK9BvsnlCXox5SmS5spzDuJemv8cwxkyGHKZDnluQkUYzxLxC4nNS89f31/zmWCFAc5QcQU6WhfWQuezhPJBzm9QeOZIjKBiu3sg0EFSxfvHkNY+/X3ghdW5JTzcTELQ19+ptfS62pcPKTMib4HOvKHfZaO5HeocLVswplLqXHEooGo6MnjnwqMFfftC98B4IZZLPnrcmXRGnMI4mYj8+uNLGKGTpD3rUEUGj6Tq/kchiiLB/fLbjS/u10s6xtzD7jg2rQAtIXZ/n50pJyBBtZPPAVgzB9daNndyXak+mr1SQ4VUyCB8q21cLPcNqEeExm8t1DPlU6UYvx7WVPk8CMtRrJLDh7bUyjM6Hjz0uejPq1PlEL6jiMKswCamJ7NkIe6bhxzniSa7n/BnIlIRE2vF3MR+PE+3vyYzfX2kSATIeW2Xl7zZo37QQb4AFeNXklC+2Dtz2IO6WcgaSaZMd6rd4+CuLGssD6moHmanCj3VLCt81DnSo4YbvCiSLlrE/7Q8lwjuRcOl35DOka9ZD11qrY9tES+hiCCZX4p/M6K5QfsAFPnOaAX3sR5LwJdn/2Vng1dQ2Wfhu34xwpJWadaegkXMekDCMBkTRlLp4jw6zzPLioLas09/XAaZK+kBpBL3lVe3AAnLqw0PzfO5RblRj6k2BrQMRuwJTflCZv+oWryZRZQCawH3Kw2XG7ruD3j+GC6QenGe7VjdLOIEuCj62t1Fk379E23K4Lj51tA6/mCKArhZHKoHAcv8SCL5/Vt9z8OHTG+Nz4Vshso5IPZUitHls4sFQvFlZRcWW7hbe9cDHAdPMVcawlC3Xqw0xIParvqljz0mPBlm//ZEqqLwioJSbUVpmx+XqExRcl4VZoht+r9sAGUq1mr/72JTOtafFDIqaE2JT96AGu9Y7CnbHmNhxQIcaZHV/ePNPqI6VxKBZcvOEJP
 drn5gNyw
 sXLFke5CFNPZBrgE7jq97XsDbpBLD2pM9jLQe84ziXrAphb/NpPHQOOFdmwReiJSVT4bctNTzLlTyrF8p5i/0lsDKmmoZUrX7WLA1lXcuG1nB6vkQPDUhcC57ZHy0ExU06uqYQ74OLZW7Rw5A3EHv3LOPwKjZkdzCcTvYvja5G8oo/ayWkCUdxTBt9VRkAMRnyCFU3WQ9bucFFK0KBUGFJkVxHvqRedoF/2ikGqAkqD/Sp+iWo+yjmDlQS1Ll1aBiwfxvxDGTwRbM2Ww5qkND5v5V+86e/h94c6pD3SPoWOkvMW/CTocdkhk9LqghPUGG36VZKU1c54EEry20KtdJJwXsJZw6R010kGhYQw1Os1TrdCWCTiDeq3TilymEqWSez5zrH5CSNdr7Ajw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11-03 13:49, Mike Rapoport (Microsoft) wrote:
> The lowmem and the global bootmem areas can have zero size, for example
> when none or all of the memory is below ARCH_LOW_ADDRESS_LIMIT, or when
> either of those areas is explicitly set to zero with kho_bootmem=.
> 
> For a zero-sized allocation memblock returns an address without reserving
> anything, and that empty area is recorded in kho_bootmem. If there is no
> memory below ARCH_LOW_ADDRESS_LIMIT, allocation of the empty lowmem area
> fails and KHO gets disabled.
> 
> Extract a helper that checks for zero size and allocates memory from
> memblock, and use it to skip empty areas the same way as empty per-node
> areas are skipped.
> 
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Chen Pei <cp0613@linux.alibaba.com>
> Closes: https://lore.kernel.org/all/20261026131851.9942-1-cp0613@linux.alibaba.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 61 ++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 32 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 6f1f55fe31819..f268c57413a7e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -820,6 +820,27 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>  	return false;
>  }
>  
> +static int __init kho_reserve_bootmem_area(int *idx, phys_addr_t size,
> +					   phys_addr_t end, int nid)
> +{
> +	phys_addr_t addr;
> +	int i = *idx;
> +
> +	if (!size)
> +		return 0;
> +
> +	addr = memblock_alloc_range_nid(size, BOOTMEM_ALIGNMENT_BYTES, 0, end,
> +					nid, true);
> +	if (!addr)
> +		return -ENOMEM;
> +
> +	kho_bootmem[i].addr = addr;
> +	kho_bootmem[i].size = size;
> +	*idx = i + 1;
> +
> +	return 0;
> +}
> +
>  /**
>   * kho_reserve_bootmem - Reserve a contiguous chunk of memory for kexec
>   *
> @@ -832,7 +853,7 @@ bool kho_bootmem_overlap(phys_addr_t phys, size_t size)
>  static void __init kho_reserve_bootmem(void)
>  {
>  	int nid, i = 0, max_nr_bootmem;
> -	phys_addr_t addr, size;
> +	phys_addr_t size;
>  
>  	if (!kho_enable)
>  		return;
> @@ -852,56 +873,32 @@ static void __init kho_reserve_bootmem(void)
>  	 * reserve bootmem area in low memory for lowmem allocations in the
>  	 * next kernel
>  	 */
> -	size = bootmem_size_lowmem;
> -	addr = memblock_phys_alloc_range(size, BOOTMEM_ALIGNMENT_BYTES, 0,
> -					 ARCH_LOW_ADDRESS_LIMIT);
> -	if (!addr) {
> +	if (kho_reserve_bootmem_area(&i, bootmem_size_lowmem,
> +				     ARCH_LOW_ADDRESS_LIMIT, NUMA_NO_NODE)) {
>  		pr_err("Failed to reserve lowmem bootmem\n");

You are adding a helper that returns an error code and then ignoring it 
at all call sites. Even though it can only return -ENOMEM right now, 
dropping the return value is not good practice.

Either capture and print the error in pr_err(), or even better have 
kho_reserve_bootmem_area() return bool and move the pr_err() 
inside it, using nid != NUMA_NO_NODE for per-node areas and a name 
argument for "lowmem"/"global".

