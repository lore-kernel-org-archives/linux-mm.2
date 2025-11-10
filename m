Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B43CCCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 14:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7CC68E0026; Mon, 10 Nov 2025 09:32:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54368E000D; Mon, 10 Nov 2025 09:32:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C919D8E0026; Mon, 10 Nov 2025 09:32:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B90388E000D
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 09:32:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BB3016012E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:32:06 +0000 (UTC)
X-FDA: 84094937052.28.1182435
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E8B1140010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 14:32:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZdxsKEPh;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf26.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762785124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bhHrB1HSxvoafTpG3mRoRQ2KfFhGifY0ghBmaRNnyuM=;
	b=kuQ9olFlRWqIvVDm57kAIVTBl7JZSYRrQKMQ/8SVxGdCc4oqbXwzCCQl1fyFy7R+jDKj8L
	olsbnessWj6l/LbdztZ9TXbW1RF9cAZM3guhDyWRRlBsKoWWiufFDINo6eaTpLqoKeRLIm
	argONsGSXTGLAo9IogIpD0lvE8rriTk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762785124; a=rsa-sha256;
	cv=none;
	b=50cZgUFW37yCy7r0qi1xb5DbaS2UqDYr3MJqItM7qhq4NSix5cQJGV4gn/nuhI004HFPrM
	5LBskqHRq0yBi8RTtPk95pjWq1rdtoRX1dZkVKRsflkQr6Zeziwc3fcOXQMCil8pQ7sfY2
	eWj7zbClezpeT0/GQm2KCSzPGUxGhvo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=ZdxsKEPh;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf26.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1762785122;
	bh=kcFPyAPegURGwddLv2f+fRKaTdSqTIloprh0VWcvNZs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZdxsKEPhdiwtrjGqeAH3wtTaB2rZU8znSlNMBv8diVJYmi95Ac2t63egnX1aiVsPX
	 2jgxoyLLTPLuGc9+gYf3axkmvu86R7dTHj6pVu7uV9SB46Zfa+uSvgpXpkpzYEEsXM
	 9SOYiRNge1VQjzLKuJonqeEaM1WkhQtXCBPKpw1A1rY6q4rmO/CIZd/NKUZEIuJ8oh
	 zl7Fo/0/ghmWJr58rGYnJjnuyOZyMGBZURwoBYLI1tP6L1RHWBi7exJPQFPHEQVjZ6
	 Pd83MyZKl1iUjkomdZPBv1PIuWRwIdGmTjcXp32hpMbr1VMq762KMuV9UG/AiektkW
	 FcoJACQ8VcfaQ==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D3A1517E12C4;
	Mon, 10 Nov 2025 15:32:01 +0100 (CET)
Message-ID: <313f7e46-e1ce-46de-ab81-d842c07485df@collabora.com>
Date: Mon, 10 Nov 2025 15:32:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 04/12] drm/gem: Introduce drm_gem_get_unmapped_area()
 fop
To: Hugh Dickins <hughd@google.com>
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
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Andrew Morton <akpm@linux-foundation.org>, Al Viro
 <viro@zeniv.linux.org.uk>, =?UTF-8?Q?Miko=C5=82aj_Wasiak?=
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>,
 Nitin Gote <nitin.r.gote@intel.com>, Andi Shyti
 <andi.shyti@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>,
 Christopher Healy <healych@amazon.com>, Matthew Wilcox
 <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
References: <20251021113049.17242-1-loic.molinari@collabora.com>
 <20251021113049.17242-5-loic.molinari@collabora.com>
 <f34bd4ef-5779-b364-0df6-e52f8377b461@google.com>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <f34bd4ef-5779-b364-0df6-e52f8377b461@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r6sqhraroex4ecu8d4wotssqe7tqz49d
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E8B1140010
X-Rspamd-Server: rspam10
X-HE-Tag: 1762785124-623223
X-HE-Meta: U2FsdGVkX18hRyHvXjJgGZtU9LiAbYdyDmOJO1ykeOOvs7GPsv3xePHT5Kz9NtwBPuM8gHbgxunDTvYzMO6DdmQL7SHoN+KZoJDNaspcOacNaQ9OI16cI7v3PM7CwnK20l3xHqQ5ecx0aCZJjiPKwxrcOn8YW3wU6ErdWIJWdadtAwFpuWr77PqPaPJhgDSt3pWf13jPjziDQIcj92QcDbYl853oMk2pkwzVzJJWS40+2X5ND06rZy1ob8kbQyrqTZHBWGGnucByV8pJbA73pYwo7NKitbmOxIchNIUbeAsjcI2uCssKmSydm7QQS0Ni/2J4WgqZD9x0uQo22NwclUHdqYnHYZWzJHMJRaRhUqler+JhWkiRthCKLmJA/z5G2oKyfb/N+f/TgainUsikdbbuB5FUFQcJYtA3792ofvbqHpBX8QGow5WdXdpHeiKykLDdMdxAYGd/pwBAsHoGRQ9vn1ciI917BLWO9ABDhmbXiad3DAprBAidJWldRgPRiezBgoql57PoPWqqR8ksoI+X39KHFeQLr8+3ZGtQRXnTHpbyso3ShlAC1nFr8WO/2LCFr608JO8YMSkr1tChUiIQT4WWtoBWXwOIG4JCkNWc0i4yNDIMACFCqko9UZRt5C4MfycgC8qXEC9RX05XSdzeahgGKVyJ4y00YZ+xWqL7jFkBPsZ01blQTpkHUXsWUCWhyoOsXvXM+TGl8wrJiv1IDNiFOarneuzwWev5ECThy6F0gTlkgG0EMSZKt1fdauxQbJ+o5ZRAuC3LCi4cEbxzgHCeBXZSEodbbhnebRu/rYameb9RJuzjVeGulphqaRh6nhJ9xDgAp+WoWc3xY3YzJHN2JgIYdE1hFhhGlZ37uJ60YFwHdS4m0DaY/YJzy4/+bBZXVWcTG7NshjTEuGttHqsYNK3FcJ5259McFCv451YSTuh3nk7IBIK1XVVIzX5r7cyyB9FOwPvF0eU
 ZMd6btjt
 D3H1VVeRgjem28mgeibcTcZqfD2jhss/b7ad8QNQyxVIa9eWE/A12rDD59qTZJDyOGxrRkXCUfBPxg/goiF1X2Gd82H2W9DY8nZUm2FBKd0sSaSI3tXHPfoJHh9GAc+LmXrEUPQBBrgAQw0iktR4szAxs5feVB6EIo+jF+qu8uAc0xZrjuaF83McTaZpD9RuWGqteKe0ks67r00Phu/0tXsHID0ov4eTJKEYCNndKBznlyh43zoZYATH7HAvKq8n2/b54xufhW9srzNpzDvEXo7lLch+WF/9I2nxghg5vTKL2YqynF3+z27HRVWt3cOuednWRFEY4ZBUvFGQYIhUN5pTc8GfMuXi3LV+AO3c+InJM6eGF4Jnk2jqYC6etCRjowuzvgz1sY+hPdLT2OQZ8QGchBh3893EWxa1FfMtf/lMYiu4P6ovdpL4xfrFDeByW0MeJ0b1qj04MLRTK8tC3L84nd1zdffgu1vsUGq/rCmUSda+/14BGgSQC6Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hugh,

On 27/10/2025 12:38, Hugh Dickins wrote:
> On Tue, 21 Oct 2025, Loïc Molinari wrote:
> 
>> mmap() calls on the DRM file pointer currently always end up using
>> mm_get_unmapped_area() to get a free mapping region. On builds with
>> CONFIG_TRANSPARENT_HUGEPAGE enabled, this isn't ideal for GEM objects
>> backed by shmem buffers on mountpoints setting the 'huge=' option
>> because it can't correctly figure out the potentially huge address
>> alignment required.
>>
>> This commit introduces the drm_gem_get_unmapped_area() function which
>> is meant to be used as a get_unmapped_area file operation on the DRM
>> file pointer to lookup GEM objects based on their fake offsets and get
>> a properly aligned region by calling shmem_get_unmapped_area() with
>> the right file pointer. If a GEM object isn't available at the given
>> offset or if the caller isn't granted access to it, the function falls
>> back to mm_get_unmapped_area().
>>
>> This also makes drm_gem_get_unmapped_area() part of the default GEM
>> file operations so that all the DRM drivers can benefit from more
>> efficient mappings thanks to the huge page fault handler introduced in
>> previous commit 'drm/shmem-helper: Add huge page fault handler'.
>>
>> The shmem_get_unmapped_area() function needs to be exported so that
>> it can be used from the DRM subsystem.
>>
>> v3:
>> - add missing include: 'linux/sched/mm.h'
>> - forward to shmem layer in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> 
> Seems reasonable, but a couple of minor remarks below.
> 
>> ---
>>   drivers/gpu/drm/drm_gem.c | 107 ++++++++++++++++++++++++++++++--------
>>   include/drm/drm_gem.h     |   4 ++
>>   mm/shmem.c                |   1 +
>>   3 files changed, 90 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
>> index a1a9c828938b..a98d5744cc6c 100644
>> --- a/drivers/gpu/drm/drm_gem.c
>> +++ b/drivers/gpu/drm/drm_gem.c
>> @@ -36,6 +36,7 @@
>>   #include <linux/module.h>
>>   #include <linux/pagemap.h>
>>   #include <linux/pagevec.h>
>> +#include <linux/sched/mm.h>
>>   #include <linux/shmem_fs.h>
>>   #include <linux/slab.h>
>>   #include <linux/string_helpers.h>
>> @@ -1187,36 +1188,27 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>>   }
>>   EXPORT_SYMBOL(drm_gem_mmap_obj);
>>   
>> -/**
>> - * drm_gem_mmap - memory map routine for GEM objects
>> - * @filp: DRM file pointer
>> - * @vma: VMA for the area to be mapped
>> - *
>> - * If a driver supports GEM object mapping, mmap calls on the DRM file
>> - * descriptor will end up here.
>> - *
>> - * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
>> - * contain the fake offset we created when the GTT map ioctl was called on
>> - * the object) and map it with a call to drm_gem_mmap_obj().
>> - *
>> - * If the caller is not granted access to the buffer object, the mmap will fail
>> - * with EACCES. Please see the vma manager for more information.
>> +/*
>> + * Look up a GEM object in offset space based on the exact start address. The
>> + * caller must be granted access to the object. Returns a GEM object on success
>> + * or a negative error code on failure. The returned GEM object needs to be
>> + * released with drm_gem_object_put().
>>    */
>> -int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
>> +static struct drm_gem_object *
>> +drm_gem_object_lookup_from_offset(struct file *filp, unsigned long start,
>> +				  unsigned long pages)
>>   {
>>   	struct drm_file *priv = filp->private_data;
>>   	struct drm_device *dev = priv->minor->dev;
>>   	struct drm_gem_object *obj = NULL;
>>   	struct drm_vma_offset_node *node;
>> -	int ret;
>>   
>>   	if (drm_dev_is_unplugged(dev))
>> -		return -ENODEV;
>> +		return ERR_PTR(-ENODEV);
>>   
>>   	drm_vma_offset_lock_lookup(dev->vma_offset_manager);
>>   	node = drm_vma_offset_exact_lookup_locked(dev->vma_offset_manager,
>> -						  vma->vm_pgoff,
>> -						  vma_pages(vma));
>> +						  start, pages);
>>   	if (likely(node)) {
>>   		obj = container_of(node, struct drm_gem_object, vma_node);
>>   		/*
>> @@ -1235,14 +1227,85 @@ int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
>>   	drm_vma_offset_unlock_lookup(dev->vma_offset_manager);
>>   
>>   	if (!obj)
>> -		return -EINVAL;
>> +		return ERR_PTR(-EINVAL);
>>   
>>   	if (!drm_vma_node_is_allowed(node, priv)) {
>>   		drm_gem_object_put(obj);
>> -		return -EACCES;
>> +		return ERR_PTR(-EACCES);
>>   	}
>>   
>> -	ret = drm_gem_mmap_obj(obj, drm_vma_node_size(node) << PAGE_SHIFT,
>> +	return obj;
>> +}
>> +
>> +/**
>> + * drm_gem_get_unmapped_area - get memory mapping region routine for GEM objects
>> + * @filp: DRM file pointer
>> + * @uaddr: User address hint
>> + * @len: Mapping length
>> + * @pgoff: Offset (in pages)
>> + * @flags: Mapping flags
>> + *
>> + * If a driver supports GEM object mapping, before ending up in drm_gem_mmap(),
>> + * mmap calls on the DRM file descriptor will first try to find a free linear
>> + * address space large enough for a mapping. Since GEM objects are backed by
>> + * shmem buffers, this should preferably be handled by the shmem virtual memory
>> + * filesystem which can appropriately align addresses to huge page sizes when
>> + * needed.
>> + *
>> + * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
>> + * contain the fake offset we created) and call shmem_get_unmapped_area() with
>> + * the right file pointer.
>> + *
>> + * If a GEM object is not available at the given offset or if the caller is not
>> + * granted access to it, fall back to mm_get_unmapped_area().
>> + */
>> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
>> +					unsigned long len, unsigned long pgoff,
>> +					unsigned long flags)
>> +{
>> +	struct drm_gem_object *obj;
>> +	unsigned long ret;
>> +
>> +	obj = drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIFT);
>> +	if (IS_ERR(obj))
>> +		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
>> +					    flags);
>> +
>> +	ret = shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
>> +
>> +	drm_gem_object_put(obj);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(drm_gem_get_unmapped_area);
> 
> Not something I'll make an issue of, but this does look rather like
> a drm EXPORT_SYMBOL() of a shmem EXPORT_SYMBOL_GPL().
> 
> Not your intention, I think, and a quick look around suggests some
> inconsistency as to whether symbols here are exported _GPL() or not.
> 
> Maybe there's good (historical?) reason for which is which, or
> maybe it's something maintainers would like to clean up one day.
> 
> Please make this one EXPORT_SYMBOL_GPL() if you can.
> 
>> +
>> +/**
>> + * drm_gem_mmap - memory map routine for GEM objects
>> + * @filp: DRM file pointer
>> + * @vma: VMA for the area to be mapped
>> + *
>> + * If a driver supports GEM object mapping, mmap calls on the DRM file
>> + * descriptor will end up here.
>> + *
>> + * Look up the GEM object based on the offset passed in (vma->vm_pgoff will
>> + * contain the fake offset we created) and map it with a call to
>> + * drm_gem_mmap_obj().
>> + *
>> + * If the caller is not granted access to the buffer object, the mmap will fail
>> + * with EACCES. Please see the vma manager for more information.
>> + */
>> +int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma)
>> +{
>> +	struct drm_gem_object *obj;
>> +	int ret;
>> +
>> +	obj = drm_gem_object_lookup_from_offset(filp, vma->vm_pgoff,
>> +						vma_pages(vma));
>> +	if (IS_ERR(obj))
>> +		return PTR_ERR(obj);
>> +
>> +	ret = drm_gem_mmap_obj(obj,
>> +			       drm_vma_node_size(&obj->vma_node) << PAGE_SHIFT,
>>   			       vma);
>>   
>>   	drm_gem_object_put(obj);
>> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
>> index 8d48d2af2649..7c8bd67d087c 100644
>> --- a/include/drm/drm_gem.h
>> +++ b/include/drm/drm_gem.h
>> @@ -469,6 +469,7 @@ struct drm_gem_object {
>>   	.poll		= drm_poll,\
>>   	.read		= drm_read,\
>>   	.llseek		= noop_llseek,\
>> +	.get_unmapped_area	= drm_gem_get_unmapped_area,\
>>   	.mmap		= drm_gem_mmap, \
>>   	.fop_flags	= FOP_UNSIGNED_OFFSET
>>   
>> @@ -506,6 +507,9 @@ void drm_gem_vm_close(struct vm_area_struct *vma);
>>   int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
>>   		     struct vm_area_struct *vma);
>>   int drm_gem_mmap(struct file *filp, struct vm_area_struct *vma);
>> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
>> +					unsigned long len, unsigned long pgoff,
>> +					unsigned long flags);
>>   
>>   /**
>>    * drm_gem_object_get - acquire a GEM buffer object reference
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index b9081b817d28..612218fc95cb 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -2851,6 +2851,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
>>   		return addr;
>>   	return inflated_addr;
>>   }
>> +EXPORT_SYMBOL_GPL(shmem_get_unmapped_area);
> 
> As you have it, that export comes under #ifdef CONFIG_SHMEM.
> 
> I know parts of drm do "select SHMEM" these days, but you might not
> be covered by those: maybe you need a "select SHMEM" in the relevant
> Kconfig, or maybe you prefer to duplicate that export line after the
> later !CONFIG_SHMEM definitiion of shmem_get_unmapped_area().
> 
> Or better, make no export here at all, but drm_gem_get_unmapped_area()
> use obj->filp->f_op->get_unmapped_area()?

This is indeed better, thanks. I've just proposed a v6 doing so.

>>   
>>   #ifdef CONFIG_NUMA
>>   static int shmem_set_policy(struct vm_area_struct *vma, struct mempolicy *mpol)
>> -- 
>> 2.47.3

Loïc

