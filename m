Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066B9CD5BD5
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:25:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F7A36B009D; Wed, 27 May 2026 02:25:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE236B009F; Wed, 27 May 2026 02:25:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60BFC6B00A0; Wed, 27 May 2026 02:25:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8C76B009D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:25:29 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 14E13404EF
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:25:29 +0000 (UTC)
X-FDA: 84812213178.13.8AEF4B0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 14B6940004
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:25:26 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PydP0Ujd;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m1zgrGPeMao8J4xGlyLb/q2cSMf+8Wq1BfCmY/13lV4=;
	b=vRq2JN99AyeHK9DyKCfoGn42pul3uUTSrT3Y8qeOgZrQHE2bAMq6rUXELaFQzpRByL0DNt
	rqpRnD6NBvo4yBZXSiYUjCIMqpHIs2/1+o5BKwJ+QB55igxpe69JMr0jpQ8aknTT11bpCq
	Pxr1GvQ4U5l8JU2aj7lTBgoZMQsZpEs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PydP0Ujd;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863127; a=rsa-sha256;
	cv=none;
	b=udbPSWxIFdT5l5FkG08NSdq2OL7uujSPPCAPH8Rd4RfffJM8TXR70RP4kRji35uirekQS1
	hEpzbhHrWhN7FSo0W/tDxHW6FJKyZk1rjL2YPMZ3taGWS3xcC2dvR/jYin2+dMTCV7Hlpz
	JOoTQ0bqUEp23FcV0gRMyAvFNBJ5sos=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0538016F2;
	Tue, 26 May 2026 23:25:21 -0700 (PDT)
Received: from [10.164.19.7] (unknown [10.164.19.7])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0A8BB3F7D8;
	Tue, 26 May 2026 23:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779863126; bh=XYu6VQADzDpdw6q2TY6lK1+GI951HIpJzp0bX60oZgU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PydP0UjdZDCNTpScwrFAsMRsTLKwFIK5YBghaJduK7HGmvo3TZq2q2T+sFXXX+2gf
	 MwwRXey5UkH5o+sbVLxMa+putsdHUQ792P59cEXT9BIZrcuEAI92zO0/yD4aXgRpMH
	 rjWFdBF1fQ8EBemiyat4eK/Kw+oHpwIRoZos6Oqs=
Message-ID: <3f55655c-b50b-45fa-9314-23e35d04ae7e@arm.com>
Date: Wed, 27 May 2026 11:55:17 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 6/6] mm/vmalloc: align vm_area so vmap() can batch
 mappings
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com
References: <20260522053146.83209-1-jiangwenxiaomi@gmail.com>
 <20260522053146.83209-7-jiangwenxiaomi@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260522053146.83209-7-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: ihje1dsoi74wcs5y95p1f3goyfg9n3gs
X-Rspam-User: 
X-Rspamd-Queue-Id: 14B6940004
X-HE-Tag: 1779863126-870458
X-HE-Meta: U2FsdGVkX19YgkR9d/kLsFQxqrHx059JL33Biwwt/KfIaQOcQh5pYD1ikCjqhVR/FKzVjEhREAPMwqqHMCdVOKZdfdPUNQjpxbF7OoA2+Fl0BRu7Kx1MLfZ116fNee4LQXy1qm5AGW69ifbw1q3Dfbc9paqBHJUJNH0y/AFhv/ElHiV17gizAyJrzc9PA94BnZGuqe+7efaqzhOxP1cdV4JVrulKdgG5c2TFrRmvg1qmqa4BWNvUerY3ElvZ2BjX3RnGrHB8UyeoIGfSviiZaRMH6WiaVoq0ILrBG0StIU6m9jxhKNp5CVELoIQq+h/4zj+xcBTvopznUFWQ6PAqYNyQh4hrLmd0SSbmlH4ydzwAWiTB3PziFaWJRWMs00uPfvH83WCH0E1vTAlUEGlFTi9cRatNFUkv1x2YwimyFUltLFLT7fHAnG3i6JJRpOx0WFMZ7rPUpcnMEAgsrnh+aTQd1OcZburBwMdXYrdY2AkpWznfFj8hX/BQXOZ9XtM0CBcwTxOkl0mSoKUPTRiHh54zvc0YARN/nATG6RXLT+J+ZLrcUKuPyBMNZmp60RpBX2O4hsJvnp6EzHXf+vsJmlu10DuQnUAybj6pGSyzfCuqxg3jD3oOhIREIlbItQDlHlOpLvVGu03YUUp3D6BIRp/9cn0gHnWOdorcn23NrsIQUrTO5FAlXGz/gdozAykQOl5mbrxKL8hG3CoDI66GYiZu9G2IcLKHRCElyaByc7J+9yYQ2S9aOS1mtXyGT1T0vmfC1kBMKZdnovxqSlNiOE3e9RZZmnNyaYa/w79MKbkgMfO7iHBPDff+rEdqxEFDNK1n6Tj3WUV3+yW576Ps1fWOSl4bQqX3uzwncewRmOPhtk7w4/7hLgzrdbwTDc5CAzHL9YUbwvDKUoNxnolq5kCHEgSa5ATFiFanzhze5Dj2tFkFDrAHrgivyC4/WQOx+LVuY3b/6oeRqfEDy5q
 jhadsCcP
 A7T8zojPp/2R3JPjNffzWK+KF4P9h5hU5g94WJUiKPhWPjUn1AgE5SFjImR8A9zKg36sqBReNcluGGq9SmckW+jivbCluSGyIqMse1Za3FtGhsf2HYL1rXHayEtsgmqixGhuEu4TAqchollZeobTAqZsZGtbHaRUEvUM+tk9C8fmTPMLqVrjex4j3BK4/fExvXtqPccNfL78Lw3BSKF9XTFwS9CIuVfQRQ+2TekHaCN+SnaClVb7/a1/zVysJMYqCqmlDizNlTtgdR9K8sF5/N/KaaOyzMIao6sD34oJLX5KvSoyyk/mna1p948J27lQyqZvwS6iFuk2e7bIGP+k5XJRY1HUBN08SqM9yt95a65tmoqHZgOukFuDiVx/e3csi+WbCwj24+WKCVXkIIdr7SuAhN7jVCsmcPa7G4sC2cKC5bS3TiNeIEFsgBgyAfVbaRqiDuKWTEhJo8vs87M4JudrAzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/05/26 11:01 am, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> Try to align the vmap virtual address to PMD_SHIFT or a
> larger PTE mapping size hinted by the architecture, so
> contiguous pages can be batch-mapped when setting PMD or
> PTE entries.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>


Hmm okay I would have preferred to squash this in the previous, but
the correctness of previous patch does not rely on this, so it's fine.

> ---
>  mm/vmalloc.c | 33 ++++++++++++++++++++++++++++++++-
>  1 file changed, 32 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 50642246f4d40..040d400928aab 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3620,6 +3620,37 @@ static int vmap_batched(unsigned long addr, unsigned long end,
>  	return err;
>  }
>  

This is screaming for a helper :)

> +static struct vm_struct *get_aligned_vm_area(unsigned long size,
> +		unsigned long flags, const void *caller)


Call this vmap_get_aligned_vm_area, then ...


> +{
> +	struct vm_struct *vm_area;
> +	unsigned int shift;
> +
> +	/* Try PMD alignment for large sizes */
> +	if (size >= PMD_SIZE) {
> +		vm_area = __get_vm_area_node(size, PMD_SIZE, PAGE_SHIFT, flags,
> +				VMALLOC_START, VMALLOC_END,
> +				NUMA_NO_NODE, GFP_KERNEL, caller);

Add a wrapper over this called __get_vm_area_node_aligned_caller, which can
call __get_vm_area_node() with all other arguments fixed, except "align".

> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Try CONT_PTE alignment */
> +	shift = arch_vmap_pte_supported_shift(size);
> +	if (shift > PAGE_SHIFT) {
> +		vm_area = __get_vm_area_node(size, 1UL << shift, PAGE_SHIFT, flags,
> +				VMALLOC_START, VMALLOC_END,
> +				NUMA_NO_NODE, GFP_KERNEL, caller);
> +		if (vm_area)
> +			return vm_area;
> +	}
> +
> +	/* Fall back to page alignment */
> +	return __get_vm_area_node(size, PAGE_SIZE, PAGE_SHIFT, flags,
> +			VMALLOC_START, VMALLOC_END,
> +			NUMA_NO_NODE, GFP_KERNEL, caller);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -3658,7 +3689,7 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
>  
>  	size = (unsigned long)count << PAGE_SHIFT;
> -	area = get_vm_area_caller(size, flags, __builtin_return_address(0));
> +	area = get_aligned_vm_area(size, flags, __builtin_return_address(0));
>  	if (!area)
>  		return NULL;
>  


