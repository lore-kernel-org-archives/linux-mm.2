Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8315FD116F5
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 13:28:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E540C6B002A; Mon,  1 Dec 2025 08:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B6E6B008A; Mon,  1 Dec 2025 08:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D419F6B008C; Mon,  1 Dec 2025 08:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C0E006B002A
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:28:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 75705140204
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:28:01 +0000 (UTC)
X-FDA: 84170980362.27.7C05393
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id A2CC64001B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:27:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=T9l4N5HL;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf12.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764595679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0SaEHpLgPQWDg/1suaX25LTMCjnE+f1eGygaTvce+bc=;
	b=5ZKU156boAUneMmH+NsZiJ8Ne44nOAqHcfNiqKg9J3H3NcRz36rS3mYu7HIi8I9Mbsrg++
	GNt5zsRZNcDM7+VnfyptLUrtnaFI9CMuMuFVf76JU9++YhbA0v1pePIkvYtCG9Cyl/a9wk
	GQER5LLn6Cs2yv7j30p14A+IyxaXr+0=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=T9l4N5HL;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf12.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764595679; a=rsa-sha256;
	cv=none;
	b=TI2rn6xmA0/gFjHvLV5Z0fi0E21CQYlzAs1i1/JWI04e4QYKXOXGo8PIFR7AN1zMeSC/Sj
	qeXsdkOeQ6bqbn1L4EbiwlhSamso7biVDmVG1yKh/5KtrY+0YcaakO+EeU2lpSnNYOWYUf
	qjlPd+pihG8pdIw/fBA8rCxcyk2L+/w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0SaEHpLgPQWDg/1suaX25LTMCjnE+f1eGygaTvce+bc=; b=T9l4N5HLxjxjguG4+xviCO4s3B
	FLkJ4toDbnJQsMpkA821HVAMJww1WQ1ckNVYFRgrbrysOjyrftAMbVjZ76ckiwwMFsSWsgB6QX3bH
	C9KPEPeAmie7IGXskDbwv8+4gyQsv3f1KF5NXVSSa/FQ4dEQYeQnD1OdyxxDL12tz+hLfS2CcAmsO
	2LzyqIdCz+5Ghd7fGvs0/JpXOriFtzi5TxV+Xdj74HJBvZnVXHa5Wofnldywwwvu08+peC9JpTVqS
	MaCqXen8cNLjejSVp7p2SVG1YADH6RCExxXYnYcZn3evk3uuMnuO3j0/oM6DouJK6udtzey1XMUbZ
	MTmwFtrQ==;
Received: from [189.7.87.198] (helo=[192.168.0.4])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vQ3vu-007OVO-IP; Mon, 01 Dec 2025 14:27:14 +0100
Message-ID: <f1a5e5a9-2193-4a47-9fce-c51b223985aa@igalia.com>
Date: Mon, 1 Dec 2025 10:27:02 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/10] Documentation/gpu/drm-mm: Add THP paragraph to
 GEM mapping section
To: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251128185252.3092-1-loic.molinari@collabora.com>
 <20251128185252.3092-11-loic.molinari@collabora.com>
From: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>
Content-Language: en-US
In-Reply-To: <20251128185252.3092-11-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A2CC64001B
X-Rspamd-Server: rspam11
X-Stat-Signature: gx73m36gp5hwcwk8da11wn4pfb4h9o6j
X-HE-Tag: 1764595679-251089
X-HE-Meta: U2FsdGVkX1+HXq8/JW1iLlYOXDUNzzZCyhIP0PEVVCvbEOdjBLI/6EVc8By9KE3Uds1dRs66h59YvZLD14rSbgSa3swRkTXdIVIicraZzLj42/Lz38d2fJs47N3X+FuFvUQ09xaEoe0/Bk8MvRWgk2qYgV4hLkAOsPKIE82+b0bWt4F8pP+JcsZ99ML6vX7ZDJ4Q1hROMBlQI8jK4htQwIR1UbBJoUbYHKS9bZ+kqe8PiCsPcsICs/uFgKuuXJyO2oGdyHTnY7nTEoWa9tVpOJlLaxOWryIGojIEYpopgt1wYiRYPyZah7RVbsFK3b5WX/9qeNy9WstLK5sfkZBrr2VJ17OxqoiWptNhYz2P4s6WlXBMUa2Y/DZ8hVcb9TD7g5pLkwvg4EB5UyKl9+TXLpp9KCNlIwc1g1OFrOCVHsJ2Vbt4ey2/MGawM1IHEG3O+sSprMdwiYgyrBrZvTKRE92NRDYhjc/Y5hwRdG9/R675DpLy/Gbk+3J2fvH1xqiH1FysKSEsJMlZo7v8kgtCxIj3bvOmlOz0nMAZwhXywmdvBCd4IGCrAzVDVhTQfWB9mRgpRln3ou1yhanU6S/+xSd/iqI/6jM6ZwCiM2Nl2BKhoJpPuCTq0ZDLXBVBNvUmyFVZAoBgCQRvFqPedrqTMXQZ5W7PcrwvYQSAyrtCq0ji/DMRbeJiHvDXmdWDHK2Me4w4Ytm0tTOxzPxyJ0gguJZdPgox8JkB1OPiOTmtLZR24PliGdC80eS2Wdh9qKZi6ac075+/HFlCvfYsA/nIlCQ60v8auQjlsqe4m+22+FgOx6uRtTYOQL84zW4sy0cfwnw6EPOB6Y1hkdRgWXhBTr6kn/WjyRlqSQq5IMLaumMwuJT2Y16Ab4YH3QnoS7FIurlw7a2bctqTbyecm33dM18S4LDGEckLKMRLGCaFbiz/QoPTaFz+mM79Gg1VEwvUXVb3ZLiMW4Q+lzp6GhT
 XIJkaVBm
 6vXha+23VrYhgnlpt4/uaRWWrcPY238tH21pBGyRC2ZzbYbhQhcHaVU5flLH9c422DXtQREWBnGGE8Yrb0Elt2myizt9tLnrepWk4eU1Pi3ZSn2BNqe6mvIQJJVoP111YONN0fyZ8p6IiWsGu/xI/CugvN9WMkbNCUUbCDKifuQtJrmzwOP1IDwidvocnEgY+sC8844iRyM/mMojmeIh1FIiYs5Ow97olgbFH6C0B8THDpO/b+Ycjqgj2VrC7Jg5RhZ6hYURRbcoGg4y2jPPeQXAz4615u9i3zPnwCzMr/5DnBtmD1qjXr4SmePqZYbGl9gS24rpZRT1fFJfzudPUp6/3DfigjKmUXVrcH2TP8uJAC1spFG18qT3AtjupQb1QX2WGGDbrsfjOZbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

On 28/11/25 15:52, Loïc Molinari wrote:
> Add a paragraph to the GEM objects mapping section explaining how
> transparent huge pages are handled by GEM.
> 
> v4:
> - fix wording after huge_pages handler removal
> 
> v6:
> - fix wording after map_pages handler removal
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> ---
>   Documentation/gpu/drm-mm.rst | 22 +++++++++++++++++-----
>   1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
> index d55751cad67c..d69eab0b4093 100644
> --- a/Documentation/gpu/drm-mm.rst
> +++ b/Documentation/gpu/drm-mm.rst
> @@ -290,15 +290,27 @@ The open and close operations must update the GEM object reference
>   count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() helper
>   functions directly as open and close handlers.
>   
> -The fault operation handler is responsible for mapping individual pages
> -to userspace when a page fault occurs. Depending on the memory
> -allocation scheme, drivers can allocate pages at fault time, or can
> -decide to allocate memory for the GEM object at the time the object is
> -created.
> +The fault operation handler is responsible for mapping pages to
> +userspace when a page fault occurs. Depending on the memory allocation
> +scheme, drivers can allocate pages at fault time, or can decide to
> +allocate memory for the GEM object at the time the object is created.
>   
>   Drivers that want to map the GEM object upfront instead of handling page
>   faults can implement their own mmap file operation handler.
>   
> +In order to reduce page table overhead, if the internal shmem mountpoint
> +"shm_mnt" is configured to use transparent huge pages (for builds with
> +CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
> +managed to allocate a huge page for a faulty address, the fault handler
> +will first attempt to insert that huge page into the VMA before falling
> +back to individual page insertion. mmap() user address alignment for GEM
> +objects is handled by providing a custom get_unmapped_area file
> +operation which forwards to the shmem backing store. For most drivers,
> +which don't create a huge mountpoint by default or through a module
> +parameter, transparent huge pages can be enabled by either setting the
> +"transparent_hugepage_shmem" kernel parameter or the
> +"/sys/kernel/mm/transparent_hugepage/shmem_enabled" sysfs knob.

It would be nice to have a paragraph about the use of the huge tmpfs
mountpoint helpers (maybe in the "GEM Objects Creation" section?).

Best Regards,
- Maíra

> +
>   For platforms without MMU the GEM core provides a helper method
>   drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to get a
>   proposed address for the mapping.


