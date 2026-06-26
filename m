Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33373C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 16:20:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8DAC6B00F0; Fri, 26 Jun 2026 12:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E5C6B00F2; Fri, 26 Jun 2026 12:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2ECB6B00F3; Fri, 26 Jun 2026 12:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1CA96B00F0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 12:20:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 33A51A04CE
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:20:43 +0000 (UTC)
X-FDA: 84922577166.07.7EC67F5
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 684451C000B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 16:20:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lORE1EzE;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782490841;
	b=nkDQEtHUyyYrpwQMITdsDoRH19gPzItvq5lh10Zqp5l++5FUD81+UBegkqqMgayg64yMYj
	yG3yqIfm/8M9NDasnwZYHvyAmUmscNuJ7PgxuTlJWyNEi9/UzwhjQYd4gv8w617YlJUO50
	CqU+R7NVGCdYabiZ1IEI9nmIQns1lsQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782490841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tKsbGrcR78zcHbLWs3JHmwiHpOL5AjwjOIZHc1xSi0=;
	b=vt34ipvIjMye7+On6cP7+jCiuuAv/CS9UIvIBqNvh2/jPfmQAIXNzAgkrDuS+t122SqHWk
	IA2EkDgariartI1DRWJ+Sr0t2yaL/EA9IhXth1VMQZdtU+EdtvI2xOrl+CEOzDOMCqKrfJ
	Gozz+dZhy1zxXJzPaEAYtwsFtNdGv9Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lORE1EzE;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5ad58f31846so1057654e87.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 09:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782490840; x=1783095640; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4tKsbGrcR78zcHbLWs3JHmwiHpOL5AjwjOIZHc1xSi0=;
        b=lORE1EzEceqCy1A62FIM6WKet/jHK1+w1foRl1sz7tQWFoCPZd7gZulfWemTE2jxL9
         Gubmct3PpifkC5wq9c5Y+c/Sd4akzastsmfhPOpCmBcWdcPrLgb46lOxnKVrwapdQXuG
         KyeR2UJQpVDKIPX5uJUdO7Sdfl06PJgkzDydM1Lg5fO/LqvB/+p+mPAhiYi+2VsfF0nE
         NoKhqowuKKsu0YgSmP1ou8miLdpZ7gtH30lsyaNRSk4yWlms+aXt/CfMS/SP1s6xwPxT
         +zhR7CeTrYvIm1iH9RM2nLFAR6k9QRC170hSiAjCKg4ybkngezzUc1WRVRsJtsb8MhAj
         xh1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782490840; x=1783095640;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tKsbGrcR78zcHbLWs3JHmwiHpOL5AjwjOIZHc1xSi0=;
        b=cfUZdZEIpRrxgvIvoQXWGDyioAFO+Y37BiWRZyLrmu7C8ECfKZiDEhIQVbk26zQWX6
         9abgE5ocLamZSYwP3Y93p/L3KwCa8eQhtFR7ygWZrjLgh7ta8Yi4bLJHNChqH3d6gpQR
         pKM3r0XB7jm5QcSEmvxYrHuo7kHZshIUj6nkknUtEc0bJBu8eewCz8sNgRe2tFDETHQn
         01iD9cD6tbDm8Cl4jCeMRisuHfLDJ+hRF8egcwscJwn6wxxSPE4Q61ZxG3Pw5tk3M1AT
         Zvxhm0fsFWyxlJD91SKZKqo5D3MGcvNF0g4C3IuwL+GqAuyfy0ntznpa03K2/OrZrgZs
         se2g==
X-Gm-Message-State: AOJu0YyQ3itS2rcX4eGh7V4GtXSVgnGUE7DmVZhptZqdceNnR4jzoq43
	tD65Ucq6wtFIEe3CCyKHo3TdMNd5T/BbNGrwHEm0h4fb2tEFacGHb5sy
X-Gm-Gg: AfdE7cneYt3MuxmwxWxmicbTbXbxkZdafBlyZTiOAHSZE4C/XxNM/mLHC2oBmwJYvhm
	UQZKZzo8qszm9r0gEHSpXLPitALSOYIx51htascz0FMadL7SdAvNDwCD8vzFw6PW3lXWie4I5gH
	Au2vLuherjVczQt7guF92O13DrFo3aTpmzma0Ma26ar94B68CqwShLhbzf3D8DUGkhySzOtH8i5
	U1OfHVC4gRFVZtEw504uGmB1ql7MXOYJ2TIxHopZpJp4Iymh1VfqSLztB6jbbW+wuFPWXOnlI6V
	5EJvwdIj2dVaFg30OZmrYyg606303KfQv/q0CQXy/+D+Pr5zg+tdxLQ8dgtfkGVN5gh+OSzpilE
	2fXGN8gPKVdymUlmTGj+3h8JYBeA9lKmSnOblnBVezVz5Bsi1Tp3+Hw==
X-Received: by 2002:ac2:4bc9:0:b0:5aa:71fd:de75 with SMTP id 2adb3069b0e04-5aea94adf59mr297281e87.39.1782490839450;
        Fri, 26 Jun 2026 09:20:39 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5ad69550ff7sm3611804e87.20.2026.06.26.09.20.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 09:20:38 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Fri, 26 Jun 2026 18:20:37 +0200
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
	urezki@gmail.com, baohua@kernel.org, Xueyuan.chen21@gmail.com,
	dev.jain@arm.com, rppt@kernel.org, david@kernel.org,
	ryan.roberts@arm.com, anshuman.khandual@arm.com, ajd@linux.ibm.com,
	linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
	shanghaoqiang@xiaomi.com
Subject: Re: [PATCH v4 6/6] mm/vmalloc: align vm_area so vmap() can batch
 mappings
Message-ID: <aj6m1cFUTlr_DCdj@milan>
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-7-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260618084726.1070022-7-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 684451C000B
X-Stat-Signature: bs16ys4eppqrsypfynbzys49y5wx5e1o
X-HE-Tag: 1782490841-862927
X-HE-Meta: U2FsdGVkX19ytk8vjxFlGVmAE/nCZSdco1c6MtWHeuw2+daqnRlFE1dvcs1Ln8DLByC5xQsXbpHBLU3kvS4GLu601eHT7lS5hIoU8hfjitk7rI8A54Zb4cKZdGBVcZN0JzTRFPPTcqd7fT11r2y4zozj6UT4kPTKtpiEb/eij4J97UoBx87W2MBH3dqWrzB1iCUeyWUu0ocunaS+8BI2pzpl0a/hxUTjq+acoBQ80QdAOKvovrrbTH+uEG5J4C97udL598SBp+NsI6L9EPaaPqRTecMeWKPmeo92j8RE5M1lwKLu8I8oBeczFtQi6UP7dSiIYV8gwlfMNTgQ4DjuJJcboK1+m4ZiCQ6aFe2xCLwlasPy2PDUKVL/kdxjqsfcVcITHABSEx0yOSDa3UMP6lIvyqQKs608Ncu4/H9ETZtgV56eDe58hi/Vqf5/Wz0uLOEFOhudj3kVqPa0lddN3AEIG1SNteI7h+JFW0ERtz2gSfax0b0XnaF4tBlW+2Z4vM6+cX+2gkDeFJHYFN3nqM9huo73js85VmlpgYlDTkC62GA4UeQ6U9kVqgW8n+6H7a1kS1LkiK4hUSKZ2xZVRMTPPntUmBbw353FtEAVFHfRcPL/HuR5HF5rgbsOL0dIWixHkYDPLVu/xHJZWeBqRcfZ6LZas92a1bzyDFEWKvfv4BMvN9fv9SBbZ+FRBoHtNeF3Z1BJPpqFDkNEg+KSkl+BTIdG8d5/mD4oUWyIItSh7NaTCQu6uCqstC4zy1LLxaiADVLiTIcYIH7yrPoe/2ZfOTLIeB1p6yef09bkvHniEzKCywvzfCDv3pGoQHFiUW8KcWaEKDffWMcRLFivHfvQiJ4Wqm5EVPuBnnRyGbwR/2K1TDO5K5uBLYtaofaVhhqW/UsaUfUvOcMZIRw1vUJo58ECcYQUAHCsVSE4fFtE3ivdvN/V/sDIZ2+ANR+BohuwUosr55aNLVyjTBu
 lMJJE0/n
 FC0JwqOvibBWA4QAFSFJnVEYy7xrJln6xHVIobYb8FgWVScWd+PZnW4FCCdB9g5aNzEzC55YxI0w1gXj9P7qnsgHsnw4z7yUUxsJD+ATGDxx4ZmxAoCqtAgi1Tp7vtUHtuVH55hpP53MDdDqpwYmIe0+ToOLSVT7rhOI6QSJtQ2eh+2Ke1ppJ/aUfFS+xxgznXCKzXdh1d9fQmSy2x55I8JBZxHDXRQzAaPOz1nekLs3J64pS6FC4jNXsHLo9S3tdQu4AfwEp4ZThrJKVDZPYlpbyR03L0wF6Al1UvuEr6o3V7x5YADT/YFtynFqSq4P8Rsf8GrC19KJf/r64phjZL3zqfbJyaIFZFhhVbftwnlUhlmRn6XxnVlK/vjksKcrQHiJ77CPpQ/Cj75UMl+7dft+oruGLqEgqlcsfVjhTdbK3yWpB/pW8n5V6UHBp9x5ImQLbFpAKVVMIBgzcYH3i3Fle1umRoEnXiOzQqfCAT3K0SaGUlokZvSDN1TngS+xXTS+paipmEWyhlQHPbYgiFDWzN4ePrfOlWE3xDk96H+Na2rxHjf+qBZkrIAwgEH1AVCUIFif0MDrRhzVVvyrjWitZgMyjM0f0PAro70/loDf3vPVAvnQ6onFgn9JPMohgGmQt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 18, 2026 at 04:47:26PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries.
> 
> Add __get_vm_area_node_aligned_caller() as a wrapper over
> __get_vm_area_node() to simplify repeated calls with fixed
> arguments.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmalloc.c | 37 ++++++++++++++++++++++++++++++++++++-
>  1 file changed, 36 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index fffb885cb2158..bc9fa93e2bdc6 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3628,6 +3628,41 @@ static int vmap_batched(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  
> +static struct vm_struct *__get_vm_area_node_aligned_caller(unsigned long size,
> +		unsigned long align, unsigned long flags, const void *caller)
> +{
> +	return __get_vm_area_node(size, align, PAGE_SHIFT, flags,
> +			VMALLOC_START, VMALLOC_END,
> +			NUMA_NO_NODE, GFP_KERNEL, caller);
> +}
> +
> +static struct vm_struct *vmap_get_aligned_vm_area(unsigned long size,
> +		unsigned long flags, const void *caller)
> +{
> +	struct vm_struct *vm_area;
> +	unsigned int shift;
> +
> +	/* Try PMD alignment for large sizes */
> +	if (size >= PMD_SIZE) {
> +		vm_area = __get_vm_area_node_aligned_caller(size, PMD_SIZE,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Try CONT_PTE alignment */
> +	shift = arch_vmap_pte_supported_shift(size);
> +	if (shift > PAGE_SHIFT) {
> +		vm_area = __get_vm_area_node_aligned_caller(size, 1UL << shift,
> +				flags, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Fall back to page alignment */
> +	return __get_vm_area_node_aligned_caller(size, PAGE_SIZE, flags, caller);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3666,7 +3701,7 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	size = (unsigned long)count << PAGE_SHIFT;
> -	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
> +	area = vmap_get_aligned_vm_area(size, flags, __builtin_return_address(0));
>  	if (!area)
>  		return NULL;
>  
> -- 
> 2.34.1
> 
Did intensive random mapping/unmaping, so i have not noticed any issues.

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

