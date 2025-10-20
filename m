Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 312D7CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0E38E0027; Mon, 20 Oct 2025 10:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880C88E0002; Mon, 20 Oct 2025 10:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7485F8E0027; Mon, 20 Oct 2025 10:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6FA8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:13:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14678118610
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:13:35 +0000 (UTC)
X-FDA: 84018685590.14.C56B7C5
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf19.hostedemail.com (Postfix) with ESMTP id 14E7D1A000A
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:13:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UKJ1t2Mv;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760969613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kixpsS7htDVvtxMkpB6cVVoUOMh2C7IjldIFMjoIMeE=;
	b=TQvm/YCyrq3tGygtVALdkogurLY51ceUS7rWvv6ZszAs2o6hFQW/8416Z0GCkZs04/b3tt
	nDZt+PFoWq/jdEIRdipAMmcQp00xRZwV+J1ak/VKoBv1PTWeV7+B14pj2kdAbv4hB1PL+e
	J2pHSPgfYgZP9rGlBulR+ZNy4HdJnCQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UKJ1t2Mv;
	spf=pass (imf19.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760969613; a=rsa-sha256;
	cv=none;
	b=0uw7xR4Wk696sstTP5HoSt6eWDJhRlclSoSe2o30vBM1SCZ896Z5sA9hTs9/3y0m/lmbwS
	oeEqrSjeWT4GyT6kGPpgEBs5nAaByNoaBxxg5J/HcZdZ0mzT0cAuXu4tvgrf3EJV55MImK
	43dQi9ocrqSBkw+vXi2dIbdPO3hfoS0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760969610;
	bh=TvYssAkPQLG2m2KKWp4oKulXBwqsnyHFiW1/8FMfTRw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UKJ1t2Mv9iTIFpZ0UNlXXnBI2ZEV3XsYaDmlhtXR5AiCvXUxut2ycdosfITanbF9U
	 nf41fXqA/SaR/AWtSs3EA9CjkZgDlGjON7CpU1VvQLR7Ozsz1pATxR518yyagkWO/Z
	 n1N07PDRUYXGF6L2x+ibF9GKaiiViLXCj92pj3VW8swdx7m5LCqzzPb0A7+zod4+Lt
	 TxueDTAvsgJas1VH3ETOAcCMu7hWXCRTmPnZXuh1i9Zseu7zozKur0BjsvE3JrGxsw
	 CiVm4zTx4i8yWmPsrDfAI7iQSyGJCrFJUGqi1WHjFIJa+09qdRm7EQ+uxnfRd4mgR7
	 ZkX2C+sn/MnyQ==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 643FD17E02B0;
	Mon, 20 Oct 2025 16:13:29 +0200 (CEST)
Message-ID: <8ba7350a-83a7-4c83-8d91-83803d0c06e8@collabora.com>
Date: Mon, 20 Oct 2025 16:13:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] drm/gem: Add huge tmpfs mount point helper
To: Tvrtko Ursulin <tursulin@ursulin.net>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Boris Brezillon <boris.brezillon@collabora.com>,
 Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
 Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
 =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
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
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-6-loic.molinari@collabora.com>
 <7584abe7-0c3f-4022-b510-c2a57fd167bb@ursulin.net>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <7584abe7-0c3f-4022-b510-c2a57fd167bb@ursulin.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14E7D1A000A
X-Stat-Signature: 99r6aw9kudcgbm1fouinqrktb59ycyrb
X-Rspam-User: 
X-HE-Tag: 1760969612-524734
X-HE-Meta: U2FsdGVkX182nzcCDcShgj6cold4nldE9zSqgZtVoO2+PygIWeqW6UtSBfmkWk7bQh8wFngcBOuzBrPRooPejF37hMMsvQgbecQw2BSA19AF3mXZbwTWZwABuRZQvwXJgQnYIp4POLa4uIWBt99tD/F3zjU2lCAsJIeX1Otx7z9cAy3CJnplIeqrirEGW9Pgvo5vfG3ZAASfru4luAxMNWqrSNPZzkIj4bF6Y69kRu1XNYfT0MT3+ww37dq80E0S431DiAHjWC/lKfZSyfolpmPQGbUAKAdNrUgA1zMRNGz2ceJiuRL5yADzuZsMhd1O1RLfZbH4J6BgFviZCJ7/4a6MJODBjAy9bNzdhyeZlyCtsDpQfbCDlABPSB2keiKGp2afmHhW84V+WHukQQg/9XE1yqP1nGsC+mL93370GD96s3N8t/sEoU1t/B8p/Exvy0iHwvPkTUqs1IsYCiwBnSpnz0FspUGQ8bRLvYARfdDoR6nhPagtzKf/7A7x5fW8WkVDeRLG+sRbJ4NZL4Q0tV6TOT5bxnHjUvgBBlrZ9usWI2mgzspnjMh28aBguMWUcDUvT6C6QZg7IbtYy/r0S4WTjZCdGtTTs0syFfxFPGh3ZZNPIbFqxoSpNzdAf9gTdYcaiFTyYRxyqZh7ndHD5pw0KXqallSl4gd7MFBL06Vf+Zp+Goy0JnUWcRwzqM61LSZ6d+ZyPhHIFUxpNTuhKNtESAYczk0kIXGMdMJ3i5qz0husSNCHzmENBckA/4DRax1PDE840QMV9rkRffHMAKSD72+jDJj454NSeW+wXTCeC6misYtuy+letlClm6hlD7dnBInFmJSnnnPjsUv3S/4Z3xhDE2g063cbhcjKw6TlzYbYlzM5pS/2vvInD7COckZ8fL25JB6RrihntLct1RzJTBnhgHoxHzV7v286dQlZGKR3SZsOkSsUTP9qzuibM1SoaNe/otOeoKUqxYa
 KAYsjrYj
 Z1MJLYKuDEyIRV9ftrsoHnttgOpeHJ9reNzEU8BvbNpr/5bk6ykMNb7PJmNfeRfyOTAMSN7uAaqQS+/B23SDBDbZej4p36vG9p1AjuvClvL53YSrph+2cRHZURGf1JRHx+IORjm0WxBWlolGAW9Utth3e7Dj8vnifF+D19G/0UVmEfnDotg4hXGKFqTITEVO32L96vBS9VYbjBdwIM1ZMaq+QMQqEo3+O5/Uq4LCIN69okASerKyF/QhHxqggqX9TTSIPFg+rpqXcdBEgnCFLUAZact99esNf5EogUmOAbKTFpvgcQQLCT/Dll+DOUNb5xiQr8X+Nt9H3o4AfSV51DOZX40pg1dZFfh0ir0rClbkdecc6K1RCd0EUvwN9lCLckPjDrsgqil2ULoyYCp5A52+WKQWnU7vp/EII5KBOXFaQmiKTZ2zCYy+veB7jsH7wPl/mxjwDBTEc6cg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/10/2025 11:10, Tvrtko Ursulin wrote:
> 
> On 15/10/2025 16:30, Loïc Molinari wrote:
>> Add the drm_gem_huge_mnt_create() helper to avoid code duplication in
>> the i915, V3D, Panfrost and Panthor drivers. It creates and mounts a
>> dedicated huge tmpfs mountpoint, for the lifetime of a DRM device,
>> used at GEM object initialization.
>>
>> The next commits will port drivers to this helper.
>>
>> v3:
>> - store huge tmpfs mountpoint in drm_device
>>
>> v4:
>> - return 0 in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
>> - return 0 when huge_mnt already exists
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> ---
>>   drivers/gpu/drm/drm_gem.c | 58 +++++++++++++++++++++++++++++++++++++++
>>   include/drm/drm_device.h  | 11 ++++++++
>>   include/drm/drm_gem.h     |  1 +
>>   3 files changed, 70 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
>> index a98d5744cc6c..db8c0a217add 100644
>> --- a/drivers/gpu/drm/drm_gem.c
>> +++ b/drivers/gpu/drm/drm_gem.c
>> @@ -29,6 +29,7 @@
>>   #include <linux/export.h>
>>   #include <linux/file.h>
>>   #include <linux/fs.h>
>> +#include <linux/fs_context.h>
>>   #include <linux/iosys-map.h>
>>   #include <linux/mem_encrypt.h>
>>   #include <linux/mm.h>
>> @@ -82,6 +83,63 @@
>>    * up at a later date, and as our interface with shmfs for memory 
>> allocation.
>>    */
>> +static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
>> +{
>> +    drm_WARN_ON(dev, dev->huge_mnt == NULL);
> 
> I don't see a benefit of adding this check but maybe I am missing 
> something.

That was mostly to detect and warn drivers setting the drm_device's 
huge_mnt pointer directly. I can remove that.

>> +
>> +    kern_unmount(dev->huge_mnt);
>> +    dev->huge_mnt = NULL;
> 
> Ditto - device is going away, no? So why bother clearing the pointer?

This one is necessary to let drivers tear down and reload. 
drm_gem_huge_mnt_create() returns if the pointer isn't NULL.

> Also, is the compiler smart enough to not compile or complain this 
> function is unused in the !CONFIG_TRANSPARENT_HUGEPAGE case?

No compiler warnings, but this might not be the case with different 
compilers/versions so I'll ifdef it out.

>> +}
>> +
>> +/**
>> + * drm_gem_huge_mnt_create - Create, mount and use a huge tmpfs 
>> mountpoint
>> + * @dev: drm_device a huge tmpfs mountpoint should be used with
>> + * @value: huge tmpfs mount option value
>> + *
>> + * This function creates and mounts a dedicated huge tmpfs mountpoint 
>> for the
>> + * lifetime of the drm device @dev which is used at GEM object 
>> initialization
>> + * with drm_gem_object_init().
>> + *
>> + * The most common option value @value is "within_size" which only 
>> allocates
>> + * huge pages if the page will be fully within the GEM object size. 
>> "always",
>> + * "advise" and "never" are supported too but the latter would just 
>> create a
>> + * mountpoint similar to the default one (`shm_mnt`). See shmemfs and
>> + * Transparent Hugepage for more information.
>> + *
>> + * Returns:
>> + * 0 on success or a negative error code on failure.
>> + */
>> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
>> +{
>> +    struct file_system_type *type;
>> +    struct fs_context *fc;
>> +    int ret;
>> +
>> +    if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>> +        return 0;
> 
> Is there a specific reason why the !CONFIG_TRANSPARENT_HUGEPAGE path is 
> not implemented in the header as a static inline? That would enable 
> those builds to avoid the pointless function in text and function call 
> in the drivers.

Good point. I'll propose a new version with drm_gem_huge_mnt_create() 
implemented as a static inline function that calls into 
__drm_gem_huge_mnt_create() only for builds with 
CONFIG_TRANSPARENT_HUGEPAGE=y.

>  
>> +    if (unlikely(dev->huge_mnt))
>> +        return 0;
> 
> Any special reason why it is allowed to call it multiple times with 
> success?

That was initially returning -EEXIST in v3 but got changed after review 
to simplify call sites.

> 
>> +
>> +    type = get_fs_type("tmpfs");
>> +    if (unlikely(!type))
>> +        return -EOPNOTSUPP;
>> +    fc = fs_context_for_mount(type, SB_KERNMOUNT);
>> +    if (IS_ERR(fc))
>> +        return PTR_ERR(fc);
>> +    ret = vfs_parse_fs_string(fc, "source", "tmpfs");
>> +    if (unlikely(ret))
>> +        return -ENOPARAM;
>> +    ret = vfs_parse_fs_string(fc, "huge", value);
>> +    if (unlikely(ret))
>> +        return -ENOPARAM;
>> +
>> +    dev->huge_mnt = fc_mount_longterm(fc);
>> +    put_fs_context(fc);
>> +
>> +    return drmm_add_action_or_reset(dev, drm_gem_huge_mnt_free, NULL);
>> +}
>> +EXPORT_SYMBOL_GPL(drm_gem_huge_mnt_create);
>> +
>>   static void
>>   drm_gem_init_release(struct drm_device *dev, void *ptr)
>>   {
>> diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
>> index 778b2cca6c49..352e3db402d7 100644
>> --- a/include/drm/drm_device.h
>> +++ b/include/drm/drm_device.h
>> @@ -3,6 +3,7 @@
>>   #include <linux/list.h>
>>   #include <linux/kref.h>
>> +#include <linux/mount.h>
>>   #include <linux/mutex.h>
>>   #include <linux/idr.h>
>>   #include <linux/sched.h>
>> @@ -168,6 +169,16 @@ struct drm_device {
>>        */
>>       struct drm_master *master;
>> +    /**
>> +     * @huge_mnt:
>> +     *
>> +     * Huge tmpfs mountpoint used at GEM object initialization
>> +     * drm_gem_object_init(). Drivers can call 
>> drm_gem_huge_mnt_create() to
>> +     * create a huge tmfps mountpoint. The default tmpfs mountpoint
>> +     * (`shm_mnt`) is used if NULL.
>> +     */
>> +    struct vfsmount *huge_mnt;
> 
> Maybe it would be nice to hide this in the !CONFIG_TRANSPARENT_HUGEPAGE 
> case? A bit ugly to add an ifdef but it is also a bit questionable to 
> force the member on everyone.

It was initially stored in drivers' data structures but, as mentioned 
above for v3, got put in drm_device to simplify call sites.

Both V3D and i915 are testing for that pointer in a few places and that 
would require adding ifdefs there too. This would also be the same for 
any drivers adding support for huge pages. Is that really worth it?

> 
> Regards,
> 
> Tvrtko
> 
>> +
>>       /**
>>        * @driver_features: per-device driver features
>>        *
>> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
>> index 7c8bd67d087c..7285a62d9afc 100644
>> --- a/include/drm/drm_gem.h
>> +++ b/include/drm/drm_gem.h
>> @@ -492,6 +492,7 @@ struct drm_gem_object {
>>           DRM_GEM_FOPS,\
>>       }
>> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
>>   void drm_gem_object_release(struct drm_gem_object *obj);
>>   void drm_gem_object_free(struct kref *kref);
>>   int drm_gem_object_init(struct drm_device *dev,
> 


