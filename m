Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5247ECCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 11:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 914298E001F; Thu, 16 Oct 2025 07:17:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C4768E0003; Thu, 16 Oct 2025 07:17:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E18A8E001F; Thu, 16 Oct 2025 07:17:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE388E0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:17:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0D789C028C
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:17:14 +0000 (UTC)
X-FDA: 84003725988.24.139DA8E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf27.hostedemail.com (Postfix) with ESMTP id EB6F24000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 11:17:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=hxewQKBU;
	spf=pass (imf27.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760613432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MqRY3Czjb/qmaEQM0EuyflNGhq0tB06IT5PcEAa34z4=;
	b=B6eSnoXa7wIQZqhs07pKGkb3SVRB93Zl+9sOpFKI8ZCAQHdqM4QuW7BAtIhEGD1A63ny4u
	lMYe+ouqtK72RB2NRVF1W6+5yThrkvf1I1slkyPqaQNQlj5SqzTJtqMr9rCDUK3yncKt6A
	Qn/94SCtgd7esgPh9wwHteYnacFutJA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760613432; a=rsa-sha256;
	cv=none;
	b=q7pumACL3fMxasKIb59z8iS0ZzQSOzmKBQ3spx51e9oNm5gOFKxqXXsfRV974LSpqCKXVu
	96wEzvPMAFzGT84tFvNnr05hhyAn0OM+NspK09e1+xRlP26thxnJKjX+P6TJwiFui/x8AJ
	2HeXnBf8hmwi0uUyo5f6uiYElrj3vag=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=hxewQKBU;
	spf=pass (imf27.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760613429;
	bh=DSWwjOXOC7bi7nAeIFr1fihi8RD0f4mgzm3t1e4srsw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=hxewQKBU4XBHVdn3n/KWzRglcS5kWQfTmJoEpRWVU198WIarQ/E/+omVH/nlKQX86
	 zAeUuogdHv/xjZLpNQ5nYCedzd5JkS8lINjMIOZ+2UbMzQLQO2ie1ZhE/JJ8+rSr1t
	 gU6UQhHE0FeXHYklZgaWiD7c4UI1m1YLcHSrqe/gcID9ypINTXCRdjOjrQU9APyPJh
	 IQ7djMFdCLeplC77JE9a1JNCPjJPBYOGMzeQ7JOk2pHwdEnPDqf8t9CWC5Mm6/lqIk
	 +WSWiXPyBreEMGKgPGQZPAEGB887tu0Is9V//WxznJuFGUUVk/Z5bfYL3y1/LCK1en
	 jE954CUpZbWmQ==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 0F59C17E0C54;
	Thu, 16 Oct 2025 13:17:08 +0200 (CEST)
Message-ID: <f564735b-7cbd-486c-9dd4-a4555e73edde@collabora.com>
Date: Thu, 16 Oct 2025 13:17:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 03/13] drm/shmem-helper: Map huge pages in fault
 handlers
To: Matthew Wilcox <willy@infradead.org>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Bagas Sanjaya
 <bagasdotme@gmail.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-4-loic.molinari@collabora.com>
 <aO_ZmA6yoqbzTKt9@casper.infradead.org>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <aO_ZmA6yoqbzTKt9@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: m5be4ompig4sqfgwgjuwsnmpmjj9gqhy
X-Rspam-User: 
X-Rspamd-Queue-Id: EB6F24000A
X-HE-Tag: 1760613431-784847
X-HE-Meta: U2FsdGVkX19r2r3IUcFGtF4Ly+1ZTJX5IML/x0iQlapQkX/8MtVaiXsdpF560ro+SHj0iQo1eL4/cCYsUVZNWU3KUtJY3XZix5sdwmOIdEARY3GXlE9jh1Isz+hKboyNGCoBc5hdO5yyL4A2v6I0rsrVyisHwd+IFyenJNe/CrEL/2/TGDfORceHxZ8YUGA9EGnTOBJJAVfWQDXAQakVpCryPAkx/0MsblPMlDovQp2EsFsBjgKaoKfSVHDC0bEu5WsrpakE/lDEl9x9qQ2hZoRZ+v2GcvJgSJUYCCSbz2ocJ9aPfXq2pwvCTprpe2Xc1smfznTv39MgHs8LdLpCypCsaIrHCcpD84Pl198E6pW/awVH+KD7EUQ3rRAMoDT0SVTQ72HwIy8kDikqJmF8IpggzHs+Bl1ETBgpPphC/X2l/1gCgm/CvchjzGoxsS4SHBgzVOVJml8jo5hanLdt5DCwYTAT1J3Pf1zNdaS/mzpiUJ1/1EwB0nI8qIg4eWvt6x10dtftR/Em3Weg8lZ8qJWYm4yZGpMAHlpJoTxd70TTobbTMMUqOkIhpq4/Kx9K+TgN8kizXSSdi9szKdHkqpJdOvqeiQ8deGMRurYUH7jS45guygZ4pUAipxhOjHFxpbE5tAceWx6Hoz//dxBsrxW+/quO5BDCjuVM/WUZotVrN1hrJEg3jjNPozoJ9RGHtICASFHTcBSroIG1A5IDC9tWFupqdALChINCQXaHleomb8Ioiii3BH02PN46gloVOVc7GJ5RMU9KJU42ZOsFxSfy9M3GO3Xxp5hTwH+yuLdc7PzGju6xDIZpR2OxsY8kfagTcBDLInBFF1Ti7aHE2polg4wnmWeYYeF8YaM7OG+Uiojv3qCr+G6lAfSLlJwtaEyDFbtcAoqflr4fHmnVM8HSphORXhTbkjkfroatwjk+/GmZXPbdbGQC9dLWHZd96HI/1XJEfFAVfdAhYLM
 HBM43lW9
 V0wK2b+6CotOq16qYSIbL/eT9/hDicLp6ER/SeriMhcRe9Xlnjg6t5/rBFXu597ijSCltWmIlprpTZjZFHXIzLQAzM0VWpYYQzPCnQVCHJyca4E25saAVoQHtuYJehpkh8F3dR57SecfBYAf3bFgnPFpz1Byc5L3ylVm5SilTUt5U6yN9/cjMPzo9zJYOUfigVyiCNHmLmb97ex6PxNyxHL7p1ry7NLUiD6dLwxh4QD3uOkv4k8UD8Ee9gVSjQ1kc/eoMb2REN5PJUjgHN2MYGueImjMbxHYD+LDsMnjY9a5N94m9emVCdUTIkZr3SGAXnucz1mxfEV3gQJ36Fto/QP79f8PNBuhnoFfB7wgbF3OSIvN7TNN+sMHbtUAZXz4oBNDpUVfxfiTwzSEeXcqAMYje4cUNXy6z52Gss7WA9+ZbwAhpHF8CWvy8+kQwPsfK5MM46aIvCUX+jWkSuYe4b4uhfgr64OrhULF43MGd3nnC6E+Nu5KxlARzhSBupntwRSmMK3O7i7FE0Sw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Matthew,

On 15/10/2025 19:27, Matthew Wilcox wrote:
> On Wed, Oct 15, 2025 at 05:30:07PM +0200, Loïc Molinari wrote:
> 
> This looks fine, no need to resend to fix this, but if you'd written
> the previous patch slightly differently, you'd've reduced the amount of
> code you moved around in this patch, which would have made it easier to
> review.
> 
>> +	/* Map a range of pages around the faulty address. */
>> +	do {
>> +		pfn = page_to_pfn(pages[start_pgoff]);
>> +		ret = vmf_insert_pfn(vma, addr, pfn);
>> +		addr += PAGE_SIZE;
>> +	} while (++start_pgoff <= end_pgoff && ret == VM_FAULT_NOPAGE);
> 
> It looks to me like we have an opportunity to do better here by
> adding a vmf_insert_pfns() interface.  I don't think we should delay
> your patch series to add it, but let's not forget to do that; it can
> have very good performnce effects on ARM to use contptes.

Agreed. I initially wanted to provide such an interface based on 
set_ptes() to benefit from arm64 contptes but thought it'd better be a 
distinct patch series.

> 
>> @@ -617,8 +645,9 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
> [...]
>>   
>> -		ret = vmf_insert_pfn(vma, vmf->address, page_to_pfn(page));
>> +	if (drm_gem_shmem_map_pmd(vmf, vmf->address, pages[page_offset])) {
>> +		ret = VM_FAULT_NOPAGE;
>> +		goto out;
>>   	}
> 
> Does this actually work?

Yes, it does. Huge pages are successfully mapped from both map_pages and 
fault handlers. Anything wrong with it?


There seems to be an another issue thought. There are failures [1], all 
looking like that one [2]. I think it's because map_pages is called with 
the RCU read lock taken and the DRM GEM map_pages handler must lock the 
GEM object before accessing pages with dma_resv_lock(). The locking doc 
says: "If it's not possible to reach a page without blocking, filesystem 
should skip it.". Unlocking the RCU read lock in the handler seems wrong 
and doing without a map_pages implementation would be unfortunate. What 
would you recommend here?

Loïc

[1] https://patchwork.freedesktop.org/series/156001/
[2] 
https://intel-gfx-ci.01.org/tree/drm-tip/Patchwork_156001v1/bat-dg1-7/igt@vgem_basic@dmabuf-mmap.html

