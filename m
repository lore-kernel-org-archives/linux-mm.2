Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D66DFCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:10:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB278E0012; Mon, 20 Oct 2025 05:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B2048E0002; Mon, 20 Oct 2025 05:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7E98E0012; Mon, 20 Oct 2025 05:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18F548E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:10:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD5F81A04AC
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:10:38 +0000 (UTC)
X-FDA: 84017922156.10.85B9688
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf08.hostedemail.com (Postfix) with ESMTP id A20AA160008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:10:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ursulin-net.20230601.gappssmtp.com header.s=20230601 header.b=LKguxIPr
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760951436; a=rsa-sha256;
	cv=none;
	b=6WOXPz4yzQUhLCjiJpjUTQ+givVdExEjfrHVRSduTLwrEqcLR2S3Z4sEnz4wN6ElkO1Ke4
	My6sfe3iCecb1vun2n5PH43HpplJIkPaTN379U+onJVaO7inDyAfiVxAIImGUFFEF3nK7O
	K0fRf2NFpVGrDWobLfV1mn52EO+dcYY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ursulin-net.20230601.gappssmtp.com header.s=20230601 header.b=LKguxIPr;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of tursulin@ursulin.net has no SPF policy when checking 209.85.128.48) smtp.mailfrom=tursulin@ursulin.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760951436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b5tedAT73HO5ufC/WfszXWOSmLN+gIpMiv+Y/meRlwI=;
	b=52zL+o6xYyPfosYTBawgo2710ZUS7IpktMdkfe06/Th8aNDwpmzd9VQ1ZMLzaWGKcNC6al
	k8t79nBaY4cjP4f0V7n93BWpvVlt/7aQ82t0m0nh7wMnC/L83Zc2MBfFQJxJoYhc6KUxgP
	A5fAXbI/vzWj7YgxClz1URr1HdEkeFM=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-471191ac79dso32846985e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin-net.20230601.gappssmtp.com; s=20230601; t=1760951435; x=1761556235; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b5tedAT73HO5ufC/WfszXWOSmLN+gIpMiv+Y/meRlwI=;
        b=LKguxIPrH/AnRYDXsho585XLqOwdMIyuHSZ6OXSp0FIbv7b3cLKGv3ywroC7P3sVAv
         4KliYI0CAE8nvVzL0+gPBXPf0VL9AB4qjLZSbss6aNYD09h2/b35PWLS5dF2QmklBkT2
         KAF2ziEmwDe7QJIsKAACoJWfvvXfrHl1xUkzJ6VZMTk4YYzdZxERAjPnLR8mrs5tGcSZ
         1gS0mbYPv6AlV1RYT07+fQUEhwi/CNra5Yg1aHJkPUGZe6uVmDfQsq5N8jpT9eG8ePjd
         vCMWpP2QJ3lDCgRtEsF/fQzKB2u1mwQ6OjciSmng/ko96Km28pN8wxqMofp+P3diHPha
         V1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760951435; x=1761556235;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b5tedAT73HO5ufC/WfszXWOSmLN+gIpMiv+Y/meRlwI=;
        b=aMLoNM/AJcTGJqrj2npdkeBRf+E1PmW3CRTUTtzpiI3eTH8ZkYE82LKdngMHlFos+T
         iSRCetPI/CwR0JcMlRxyeiOS5WjUc5NYW8ruzGfPddU7HPlLB2dItMy+F+FUlSeRbcmy
         k+3Pn2N6FhMbMmDlvR7l6W9mNC9UY46ttvxRCwLKfomvUCQfCz6W9/UGZQHcTe/6fmOu
         neQzB79VmoQIodVMNCCna3zqfp+KvyIBHEG8ywJaPt5vXJ6yhOYVhqj6ELjzlwbJye4q
         hyt7ltFnEKDsD1A8FMbJzHfBm0UKsaX8shVAuYxHD5zYE9vV4EXasNjZZZcHU7VIpiVV
         toqQ==
X-Forwarded-Encrypted: i=1; AJvYcCVWhRiow58Ci+ec7aHFxaYPN/YsLa+kVq1kZpCzcmz/sfSZdX5GKMXb3MiuqpZ9Caf789v++u+Tgw==@kvack.org
X-Gm-Message-State: AOJu0YxtEdGbCZ+HuiX5MYplfxAm58M2cYaX3gSSRSfT+FjLfYESF3j0
	SC0cS8FcKtEVpKLJca++gUMAXls1uJ+pNkP4JFY8LD3umgXRLhoXLqdfkIdfM9POTot0ytswkyE
	7ZuzrdwY=
X-Gm-Gg: ASbGncs4tnieR2ejtkwGXFvMpKGYIKevgKpQj5rC3bu0jsbFbbL1h9scUR7v8GEtmnH
	3orc7IwEBbtrrjnhqEB4rJ6SN3NATajEgE20tbDHk5uPimtO/kicDw4Y7shAEs0DbEjvBpKMK4c
	3QxV/bLcP0YhGECcwLdf0aTt0lz2xnzUqOw78rPsT56PoEDMdMu1zNGYiDNlc0OmHRJAVy5KakQ
	JFeQlXuB1YygD+wgV6kIL77kFYjdYemTzigF++GfliEuu1XkpWqPxK8sMV9RGtCG2pCiIk9CkXL
	5z4LOoDVtiZhZFoGNJ749vU3rxChPN97INYGdv44C7Fx/EeFIcEeVvuKdfsMkXFyuEr3iPiSWJY
	T/WBmmE7ibz+7GqFdLlPJg1ptUDm8kx8pKjWBIpSswpDDHKFuM2HQ1HwSGeQjP0Z3aZt/Rdiqtd
	gW4fh89MGlsHVTLQ4=
X-Google-Smtp-Source: AGHT+IH3gXMi4edAZfP0WIQNa+oQTzYbMLse+FRL4oaUtLdeWvDJfxezX0KKAC3SgkQ3mXsP943ZWw==
X-Received: by 2002:a05:600c:3b03:b0:46e:330a:1762 with SMTP id 5b1f17b1804b1-471179079dfmr97785585e9.22.1760951434703;
        Mon, 20 Oct 2025 02:10:34 -0700 (PDT)
Received: from [192.168.0.101] ([90.242.12.242])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4715257d972sm137948265e9.1.2025.10.20.02.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 02:10:34 -0700 (PDT)
Message-ID: <7584abe7-0c3f-4022-b510-c2a57fd167bb@ursulin.net>
Date: Mon, 20 Oct 2025 10:10:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/13] drm/gem: Add huge tmpfs mount point helper
To: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>,
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
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20251015153018.43735-6-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r4qwasfbmwc3113jh5bqo5co7c9cmqd8
X-Rspamd-Queue-Id: A20AA160008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760951436-584092
X-HE-Meta: U2FsdGVkX1+s+oO6LFUqZYSeVFLBTUNyTYs1UsMQXpGn4VpmMzztud7xSctI93LmDuWRssnKTaNHeRQBmwNT89zUU/WPSR8nWiylO2zmBHyaU2/vpOMsxYWir9jYTDS2ciCvXK7b34CKaDDAzWJXJja2R6MZFkidovZg9pi31nDt3U6sQM0PYfYFqUrWEyZsTXINRUTs5qMpPrK8Xo4qmWLLo3XMV6GtC0exhaV5zvmZSFg+UwMBleeGvrMbGGHuNASz7Ntl90YgW0ASsOVYBN38QSXkGy7iU4QTdK9SwoDwAvd6ERV+e7uFFKPl5itxh4oVXAcDZWzfthkCSwkPaCvJFAGWo98eOlbBba/eihhaUd0tQIUE0HGHBGi6k5lxd47G3qUrrmm53FIO/ThNJ2B7v1KtJ2DxbKdjVw/+yV9vjMsSfYhIsLJBsTT9DPs7kScgbPC4Xz6J6T6BH6wXukoC55Vc3F3yMu6e71rLQwz2CYSU+r5pVItE42dza0E3ZYXa6v/xzptOEFfz6W9XEmjjB1KOcNi/St8nZE+5+I6nZClyYxnprFiB3sA3UvaSM7D7ypVHpGTEWb/FfrEpYMAdeYOOnsRclUYwPMGSPCmZi8TDpBcHHzZbwuWjEP0a5OG4X6K/FIr4+doSGUTLSRuu0SQVZVfIRFH6c/xTaXP5sp0u6kgbN0AQO6luh4uULNY3ub2IuEKHQyzIGx2EMeohfH+AXAGXgYG84IvJqrmWg6Ydjn1RtClP14PewxYuzvdqCgWWG2cSTOru0v5NzwNBqeg5feQ9l0GRRoyQKgXzNIo3inb8jPe1a1VCh1rlkjzy9VgruaeCljQha+tfrNaH3AFx/4fxYZ+Ol6m20xm4MMSoB/Thq9CqE/puDT5JxFu0MmFrpGj57+Xf+1C781G/iQjErsVRXpmUX+Dl4wveJ0nLZwXazENzhzFg4p6WV0Mj9NJpa8T/noz4Nd6
 haSnQNWg
 B3DPvqVB8IHFtWA9HH97nTJF1rOGSCHwuCwxrm22lHKM9zbTykJJZvXKe9b4RRvW2BRtb6kBMJOjOAwHjO7/Ghz/JY00nsi6xuEz7+K7gGoheEzfLb72tqgbSxl79r2AaY/Q7c8P6Qe6+NKuH3MrMmKHWZ2S7Y8Nkn05dBp7A+xjJsIfglmdZRLo1hRsIZuWZgU0uMyCW4Ms4PHcqyM4u/qb4Fua8m+N93+xYWEmXG5K9Mst3402jpouyxYMNcMpXk/pk/7NXta9NfANEEFyAETjiczuw1AJQuYpheVe3PLst9hNwh+lp6m/EmuVhHXpIY0znjvuvlf8hLrpyMic2vqbpVG8xq3YRwtpDh2OB27+vB/5GzKoaoIiyBr2fAL83loijD04vB3235tpOKyxG63v/Px6TkBDbT09f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 15/10/2025 16:30, Loïc Molinari wrote:
> Add the drm_gem_huge_mnt_create() helper to avoid code duplication in
> the i915, V3D, Panfrost and Panthor drivers. It creates and mounts a
> dedicated huge tmpfs mountpoint, for the lifetime of a DRM device,
> used at GEM object initialization.
> 
> The next commits will port drivers to this helper.
> 
> v3:
> - store huge tmpfs mountpoint in drm_device
> 
> v4:
> - return 0 in builds with CONFIG_TRANSPARENT_HUGEPAGE=n
> - return 0 when huge_mnt already exists
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> ---
>   drivers/gpu/drm/drm_gem.c | 58 +++++++++++++++++++++++++++++++++++++++
>   include/drm/drm_device.h  | 11 ++++++++
>   include/drm/drm_gem.h     |  1 +
>   3 files changed, 70 insertions(+)
> 
> diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
> index a98d5744cc6c..db8c0a217add 100644
> --- a/drivers/gpu/drm/drm_gem.c
> +++ b/drivers/gpu/drm/drm_gem.c
> @@ -29,6 +29,7 @@
>   #include <linux/export.h>
>   #include <linux/file.h>
>   #include <linux/fs.h>
> +#include <linux/fs_context.h>
>   #include <linux/iosys-map.h>
>   #include <linux/mem_encrypt.h>
>   #include <linux/mm.h>
> @@ -82,6 +83,63 @@
>    * up at a later date, and as our interface with shmfs for memory allocation.
>    */
>   
> +static void drm_gem_huge_mnt_free(struct drm_device *dev, void *data)
> +{
> +	drm_WARN_ON(dev, dev->huge_mnt == NULL);

I don't see a benefit of adding this check but maybe I am missing something.

> +
> +	kern_unmount(dev->huge_mnt);
> +	dev->huge_mnt = NULL;

Ditto - device is going away, no? So why bother clearing the pointer?

Also, is the compiler smart enough to not compile or complain this 
function is unused in the !CONFIG_TRANSPARENT_HUGEPAGE case?

> +}
> +
> +/**
> + * drm_gem_huge_mnt_create - Create, mount and use a huge tmpfs mountpoint
> + * @dev: drm_device a huge tmpfs mountpoint should be used with
> + * @value: huge tmpfs mount option value
> + *
> + * This function creates and mounts a dedicated huge tmpfs mountpoint for the
> + * lifetime of the drm device @dev which is used at GEM object initialization
> + * with drm_gem_object_init().
> + *
> + * The most common option value @value is "within_size" which only allocates
> + * huge pages if the page will be fully within the GEM object size. "always",
> + * "advise" and "never" are supported too but the latter would just create a
> + * mountpoint similar to the default one (`shm_mnt`). See shmemfs and
> + * Transparent Hugepage for more information.
> + *
> + * Returns:
> + * 0 on success or a negative error code on failure.
> + */
> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value)
> +{
> +	struct file_system_type *type;
> +	struct fs_context *fc;
> +	int ret;
> +
> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> +		return 0;

Is there a specific reason why the !CONFIG_TRANSPARENT_HUGEPAGE path is 
not implemented in the header as a static inline? That would enable 
those builds to avoid the pointless function in text and function call 
in the drivers.

> +	if (unlikely(dev->huge_mnt))
> +		return 0;

Any special reason why it is allowed to call it multiple times with success?

> +
> +	type = get_fs_type("tmpfs");
> +	if (unlikely(!type))
> +		return -EOPNOTSUPP;
> +	fc = fs_context_for_mount(type, SB_KERNMOUNT);
> +	if (IS_ERR(fc))
> +		return PTR_ERR(fc);
> +	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
> +	if (unlikely(ret))
> +		return -ENOPARAM;
> +	ret = vfs_parse_fs_string(fc, "huge", value);
> +	if (unlikely(ret))
> +		return -ENOPARAM;
> +
> +	dev->huge_mnt = fc_mount_longterm(fc);
> +	put_fs_context(fc);
> +
> +	return drmm_add_action_or_reset(dev, drm_gem_huge_mnt_free, NULL);
> +}
> +EXPORT_SYMBOL_GPL(drm_gem_huge_mnt_create);
> +
>   static void
>   drm_gem_init_release(struct drm_device *dev, void *ptr)
>   {
> diff --git a/include/drm/drm_device.h b/include/drm/drm_device.h
> index 778b2cca6c49..352e3db402d7 100644
> --- a/include/drm/drm_device.h
> +++ b/include/drm/drm_device.h
> @@ -3,6 +3,7 @@
>   
>   #include <linux/list.h>
>   #include <linux/kref.h>
> +#include <linux/mount.h>
>   #include <linux/mutex.h>
>   #include <linux/idr.h>
>   #include <linux/sched.h>
> @@ -168,6 +169,16 @@ struct drm_device {
>   	 */
>   	struct drm_master *master;
>   
> +	/**
> +	 * @huge_mnt:
> +	 *
> +	 * Huge tmpfs mountpoint used at GEM object initialization
> +	 * drm_gem_object_init(). Drivers can call drm_gem_huge_mnt_create() to
> +	 * create a huge tmfps mountpoint. The default tmpfs mountpoint
> +	 * (`shm_mnt`) is used if NULL.
> +	 */
> +	struct vfsmount *huge_mnt;

Maybe it would be nice to hide this in the !CONFIG_TRANSPARENT_HUGEPAGE 
case? A bit ugly to add an ifdef but it is also a bit questionable to 
force the member on everyone.

Regards,

Tvrtko

> +
>   	/**
>   	 * @driver_features: per-device driver features
>   	 *
> diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
> index 7c8bd67d087c..7285a62d9afc 100644
> --- a/include/drm/drm_gem.h
> +++ b/include/drm/drm_gem.h
> @@ -492,6 +492,7 @@ struct drm_gem_object {
>   		DRM_GEM_FOPS,\
>   	}
>   
> +int drm_gem_huge_mnt_create(struct drm_device *dev, const char *value);
>   void drm_gem_object_release(struct drm_gem_object *obj);
>   void drm_gem_object_free(struct kref *kref);
>   int drm_gem_object_init(struct drm_device *dev,


