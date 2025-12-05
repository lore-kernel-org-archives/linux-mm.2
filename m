Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A271D2F7DD
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 11:18:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFB076B014E; Fri,  5 Dec 2025 06:18:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AABDD6B0150; Fri,  5 Dec 2025 06:18:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 973456B0151; Fri,  5 Dec 2025 06:18:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2DA6B014E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 06:18:46 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1089AB9E6D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:18:46 +0000 (UTC)
X-FDA: 84185169852.23.07AD410
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id E975640006
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:18:43 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=ursulin.net header.s=google header.b=q9nvmGQA;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of tursulin@ursulin.net designates 209.85.128.50 as permitted sender) smtp.mailfrom=tursulin@ursulin.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764933524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oRa0aI+MLlxCctgkmk7qeii5icGh5uMqffO/FVoB8G8=;
	b=k3T+XX2oGpulnkf0AtVzEoHLJI5FuedZghJ/KB1UUrHfWWNqtXcuyw6WiHKsHOIk8aR6Tg
	JXSlkOAoDPcrVJsUCr2QjDHh1nl1DuYuyVC2wmPwVTiU1XPnvDAdeCDefIM6Tj13CotzHM
	BifWIyJGyySRmb1GkLXpYSazvXYdwog=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=ursulin.net header.s=google header.b=q9nvmGQA;
	dmarc=none;
	spf=pass (imf04.hostedemail.com: domain of tursulin@ursulin.net designates 209.85.128.50 as permitted sender) smtp.mailfrom=tursulin@ursulin.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764933524; a=rsa-sha256;
	cv=none;
	b=Y9CqBYkIdl2InDrG7gkPOZ+9urCHby7bZIokwXOPfjkNO2TK8lrQL+oYxF0nVMzkeplFit
	lWxnGAYPg4LjGUX8pP5jr84QsS1vUzdQfRs+LwE1LLUGLj+GLTsd3dq5pzlhdvZOtdg6G9
	a55AVA/fBx64W4HKUyLMe50rfZnoxlA=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4779adb38d3so18348695e9.2
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 03:18:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ursulin.net; s=google; t=1764933522; x=1765538322; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oRa0aI+MLlxCctgkmk7qeii5icGh5uMqffO/FVoB8G8=;
        b=q9nvmGQAC6On1qXXrN2gF8H01wVqTJAuEQn5ON90nnlfpPAKA/L0g0s6kbM6o+pm0j
         NDcaJA/pb8ODohQvhZYq9K+MC3IZrpNcJDNKT2CpfjFIAy+ppPBreFCSOP8kmPOMQtLd
         R8cwA7QgdANtGxU0z2fOu4KL1LeMv3/dcOEEPZa3TpAAVm9WEiEV/sOMt/kLydlCcWek
         QraQMM1FQK02dE1yqY4yWxPFqbPdXWljpqtrbzzyxNWMD5Or2X8cUIy/b+yarZm/WYgW
         v58T+uGADVLIRLJjbVrAfB+w/QHuo+vtBf/a6H996HNxsiRpv8nOLTwLoXdzbk0i7xeX
         AKgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764933522; x=1765538322;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oRa0aI+MLlxCctgkmk7qeii5icGh5uMqffO/FVoB8G8=;
        b=Bm/cfNINM4nNBgOEtExcpzw8n46Sk/NUsErMa7yvMtQBwzcdOsla8fwPEFOuKCoUj/
         lMpd18y79IontR3dQ3ATWejrq3ySt3N/1wUQkIbZ3EtlAloN5FGvIkt/dmMP/FgOV+6E
         jW4U3mgda+TuZRsL+86ov96XBzrsaDqnjROj8n7NpFbN63MNeaAuy+/QIyj6dU4AGD+q
         ajEwJNooS6Q4dsgjv4qTx2bg8hcwwCUG9mym9AwbHeV9vy5YolYmYjxvG6SSfFM9K/pM
         KLa9UijAES5R3NsMti7nm1JqYtjP8Cr2gRbALS+3WFIXbPTJt6+h8O5luE7nTKcRD4If
         01+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUTUI30bqFD9O100iBvrg7iBb/NEJrVTCAnMkfwrOqQfWflLvMwue10rdFPyadjMUAypL36WNgQpQ==@kvack.org
X-Gm-Message-State: AOJu0YycK7VJHsJ1UTKoZRqW/HLDHT6oqesnQzUFXDec5gziNtGOvthr
	Km7VvMN7/d1mDZbQQ+T7/vFk7NaX13zWFDMbzT0E3Za68dSzrLI8hX4rFnNzcg3vmeo=
X-Gm-Gg: ASbGncv6rBYZ0DYdTvJb3U5BADYi2qq7aPlEkzJwTCe9MQLignruolM/vEllM57IAA2
	WFv/xqZpCaSFdMQkXTQHD0xdAlpK4Jd7DCPpqbZ7/2DWVwHSK9rOOdbRp5ytoZYRwXv34EMxBDo
	5H0Hrh5sMKYGitcGptTREWtd5zKfENC+OwXWs0+Br1uCA2+thll3UH7TzGEf8Yr4rOxoz5lphkD
	hMvASf4W/ihIvDyQD+Siegr3qQBEKOxkogLsSiEtNXBCNWYzsUHhkzQTzUruVahGofxkcgbWSvs
	eCvH1o3I9Y2qzajSluYnOF0d5y68JyhP+XE/lsWDiA+TJcqxtYdvBkOvImVLjgEu/qC3Nlu9Qx1
	xyyN6p1x/xjGerX9qU4f7eY4eDjVvt/7dzO/sppNe1cw/RHIje19AB5E1jvP8a3Cw5QtfrPtvXQ
	+h+OiaV5lpZRoA1f6pUDiGCeH2gcQtBt/D
X-Google-Smtp-Source: AGHT+IFOWnMguvYE5DbQkTSb1Ne++ALXCEzXlubqgJCDZmtKhVzb/Zqc2ZZzK46kFVz4wM7OJw/MRA==
X-Received: by 2002:a05:600c:4592:b0:46e:53cb:9e7f with SMTP id 5b1f17b1804b1-4792f38615amr59145845e9.18.1764933521427;
        Fri, 05 Dec 2025 03:18:41 -0800 (PST)
Received: from [192.168.0.101] ([90.240.106.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b12411fsm69885495e9.3.2025.12.05.03.18.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 03:18:40 -0800 (PST)
Message-ID: <f08c170b-714f-46d0-87fc-3218c42ce93a@ursulin.net>
Date: Fri, 5 Dec 2025 11:18:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v12 05/10] drm/i915: Use huge tmpfs mountpoint helpers
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
References: <20251205091216.150968-1-loic.molinari@collabora.com>
 <20251205091216.150968-6-loic.molinari@collabora.com>
Content-Language: en-GB
From: Tvrtko Ursulin <tursulin@ursulin.net>
In-Reply-To: <20251205091216.150968-6-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E975640006
X-Rspamd-Server: rspam11
X-Stat-Signature: iy9431xemhp7eig6bumk1pjdgr94ieut
X-HE-Tag: 1764933523-676140
X-HE-Meta: U2FsdGVkX1+AujPi9CJQ2zYY5XXFyvPz2NpyzJ9AFll9Gl1cCn3M8VuXPmRM1i7b3zcWHYHVktVUA+mvtfh4MbZDMnSbz6ht7FyeiYfOwc3uCGnc9ZDx/QcGqidoJsMEbKCVs392bSDP+dtADpJsQJXNG5fZJUABsLytpEttENbh2aVRFzk1fI+B82zXStZTbJucOJslqx34FR/KCiEB1nQYbw4pXiAhFeupIiCpezSHyBMx1CDPGExs+jgOW9pRwUCC0DdoGkBAX5a3YaL/fUa9Fo9TLZDjKNaL/UkQnoysja5r27nDMwV7dD9s6wfy4Ck4MoFam+elfUfY1GfyacP78yjXitNPkk+R64lp2nJEU7WwJaeW5q1usl3xXmHZOxoqIjlbZgDPMSqwVZCvrFPY8DlmR64L2e2KVxaGjwsC7VPvqx2yJR9yuiZP/aB+wb4Ni8ab8CDWAwDuSQWDgio4ygnNRw5hMF8MKwTi3bCnNJARxSHoO8HZyTHUMxWemQLh3fID4KEmAS6t5iEMTfFUvYBqkzT5ccqopUMmoCamrfvsL0QTwk8FkBPNwkofS7IPsE3ouOn33AnuT3t61RMOhFtYL4qbZmyI/Lg8foi8ROaCdwKRel/854v/vUAm6IANmRD8b4mNzAnJoXYl9n4b1dDIrQsh6GVPpSQCrPKU/KVv8A1sYMcQqI62KxKs10aw6tCLuDiWmE7ipBG2h9sYabkLHvg1iQikeDpvl6kZNX/JmpGfuf7z609qPObaN5hZT7Ug5JasTNdfzqGL/fREPryZVlJe64RhPBib8Oe+PToIArT66Tae2fHqPniQrm2LzpR2QVum8K53ZZDQHFUHNs7FAKkvsNBX6ewJazypEbbRozNNgIqEgR73RuuCpUDT58xDHaNibiQOdKxS2FUBIAhEnv4O/J7t83Jipoxbk2Zi22wSwS2DAHZglfCLXIVIk+oo2LwQILJhV+w
 ZdRz5Zz7
 3F5ceYQ6H2gff6kxCKhG233IjZSvX13hQJfZ6V8ZSxNzW6R0DSiGV66bGX0ph3yYxvtPlz3zCzDphowNC2OYBeSLHs7dssOtAjvpkJIy3m8YwBGoRuL4GpCQ3XmyGQqgJeE2df3Vc3UduUndw4v1OPyuV7q9st+wxabguh+MMCWN5/ImrhsVdVinfaAhBzPgMgayQq1QiyC0RCTQ1z9R7sCWvquN3Sw7NOxiHU3V8+2+LCUVt55TLY/JsIj6bZEy4wjvrbxH67TLOHvL/3gGI8HSkNaOUUxjiLqMgr+vTBIBIklthRDb1dETueoeZdOl20lyon/OlpWmUNZer1UafVNI/Nvfudfmxbw4wHJOuwN52EzPJrT8iv54zMqzpmSDxWGLI5JJbP8BpsXDL+H9TIPOYGywe+QMsVEm6NK4ncbxzAAzXveKduc0+QIfXybGahPYwqGDUgWBukFxpwRMWPZkiWDWGp8iA/8KSaRcznBL1kxBlhDHevCspDpIiJm35WEXo32UG64jxPk4jFV7llVvp8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 05/12/2025 09:12, Loïc Molinari wrote:
> Make use of the new drm_gem_huge_mnt_create() and
> drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
> it's just a few lines long, the single function in i915_gemfs.c is
> moved into i915_gem_shmem.c.
> 
> v3:
> - use huge tmpfs mountpoint in drm_device
> - move i915_gemfs.c into i915_gem_shmem.c
> 
> v4:
> - clean up mountpoint creation error handling
> 
> v5:
> - use drm_gem_has_huge_mnt() helper
> 
> v7:
> - include <drm/drm_print.h> in i915_gem_shmem.c
> 
> v8:
> - keep logging notice message with CONFIG_TRANSPARENT_HUGEPAGE=n
> - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n
> 
> v9:
> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
> - remove useless ternary op test in selftests/huge_pages.c
> 
> v12:
> - fix layering violation in selftests (Tvrtko)
> - fix incorrect filename in commit message

Thanks, looks good to me.

Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

What are your plans for landing the series? Presumably you'd like to do 
it in one go via drm-misc-next rather than in stages and different trees?

Regards,

Tvrtko

> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> ---
>   drivers/gpu/drm/i915/Makefile                 |  3 +-
>   .../gpu/drm/i915/gem/i915_gem_object_types.h  |  9 +--
>   drivers/gpu/drm/i915/gem/i915_gem_shmem.c     | 58 ++++++++++-----
>   drivers/gpu/drm/i915/gem/i915_gemfs.c         | 71 -------------------
>   drivers/gpu/drm/i915/gem/i915_gemfs.h         | 14 ----
>   .../gpu/drm/i915/gem/selftests/huge_pages.c   | 15 +---
>   drivers/gpu/drm/i915/i915_drv.h               |  5 --
>   7 files changed, 50 insertions(+), 125 deletions(-)
>   delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.c
>   delete mode 100644 drivers/gpu/drm/i915/gem/i915_gemfs.h
> 
> diff --git a/drivers/gpu/drm/i915/Makefile b/drivers/gpu/drm/i915/Makefile
> index 84ec79b64960..b5a8c0a6b747 100644
> --- a/drivers/gpu/drm/i915/Makefile
> +++ b/drivers/gpu/drm/i915/Makefile
> @@ -169,8 +169,7 @@ gem-y += \
>   	gem/i915_gem_ttm_move.o \
>   	gem/i915_gem_ttm_pm.o \
>   	gem/i915_gem_userptr.o \
> -	gem/i915_gem_wait.o \
> -	gem/i915_gemfs.o
> +	gem/i915_gem_wait.o
>   i915-y += \
>   	$(gem-y) \
>   	i915_active.o \
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> index 64600aa8227f..f94409e8ec4c 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
> @@ -348,12 +348,13 @@ struct drm_i915_gem_object {
>    */
>   #define I915_BO_ALLOC_GPU_ONLY	  BIT(6)
>   #define I915_BO_ALLOC_CCS_AUX	  BIT(7)
> +#define I915_BO_ALLOC_NOTHP	  BIT(8)
>   /*
>    * Object is allowed to retain its initial data and will not be cleared on first
>    * access if used along with I915_BO_ALLOC_USER. This is mainly to keep
>    * preallocated framebuffer data intact while transitioning it to i915drmfb.
>    */
> -#define I915_BO_PREALLOC	  BIT(8)
> +#define I915_BO_PREALLOC	  BIT(9)
>   #define I915_BO_ALLOC_FLAGS (I915_BO_ALLOC_CONTIGUOUS | \
>   			     I915_BO_ALLOC_VOLATILE | \
>   			     I915_BO_ALLOC_CPU_CLEAR | \
> @@ -363,9 +364,9 @@ struct drm_i915_gem_object {
>   			     I915_BO_ALLOC_GPU_ONLY | \
>   			     I915_BO_ALLOC_CCS_AUX | \
>   			     I915_BO_PREALLOC)
> -#define I915_BO_READONLY          BIT(9)
> -#define I915_TILING_QUIRK_BIT     10 /* unknown swizzling; do not release! */
> -#define I915_BO_PROTECTED         BIT(11)
> +#define I915_BO_READONLY          BIT(10)
> +#define I915_TILING_QUIRK_BIT     11 /* unknown swizzling; do not release! */
> +#define I915_BO_PROTECTED         BIT(12)
>   	/**
>   	 * @mem_flags - Mutable placement-related flags
>   	 *
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> index 26dda55a07ff..6ad1d6f99363 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -9,14 +9,16 @@
>   #include <linux/uio.h>
>   
>   #include <drm/drm_cache.h>
> +#include <drm/drm_gem.h>
> +#include <drm/drm_print.h>
>   
>   #include "gem/i915_gem_region.h"
>   #include "i915_drv.h"
>   #include "i915_gem_object.h"
>   #include "i915_gem_tiling.h"
> -#include "i915_gemfs.h"
>   #include "i915_scatterlist.h"
>   #include "i915_trace.h"
> +#include "i915_utils.h"
>   
>   /*
>    * Move folios to appropriate lru and release the batch, decrementing the
> @@ -494,9 +496,11 @@ const struct drm_i915_gem_object_ops i915_gem_shmem_ops = {
>   
>   static int __create_shmem(struct drm_i915_private *i915,
>   			  struct drm_gem_object *obj,
> -			  resource_size_t size)
> +			  resource_size_t size,
> +			  unsigned int flags)
>   {
> -	unsigned long flags = VM_NORESERVE;
> +	unsigned long shmem_flags = VM_NORESERVE;
> +	struct vfsmount *huge_mnt;
>   	struct file *filp;
>   
>   	drm_gem_private_object_init(&i915->drm, obj, size);
> @@ -515,11 +519,12 @@ static int __create_shmem(struct drm_i915_private *i915,
>   	if (BITS_PER_LONG == 64 && size > MAX_LFS_FILESIZE)
>   		return -E2BIG;
>   
> -	if (i915->mm.gemfs)
> -		filp = shmem_file_setup_with_mnt(i915->mm.gemfs, "i915", size,
> -						 flags);
> +	huge_mnt = drm_gem_get_huge_mnt(&i915->drm);
> +	if (!(flags & I915_BO_ALLOC_NOTHP) && huge_mnt)
> +		filp = shmem_file_setup_with_mnt(huge_mnt, "i915", size,
> +						 shmem_flags);
>   	else
> -		filp = shmem_file_setup("i915", size, flags);
> +		filp = shmem_file_setup("i915", size, shmem_flags);
>   	if (IS_ERR(filp))
>   		return PTR_ERR(filp);
>   
> @@ -548,7 +553,7 @@ static int shmem_object_init(struct intel_memory_region *mem,
>   	gfp_t mask;
>   	int ret;
>   
> -	ret = __create_shmem(i915, &obj->base, size);
> +	ret = __create_shmem(i915, &obj->base, size, flags);
>   	if (ret)
>   		return ret;
>   
> @@ -644,21 +649,40 @@ i915_gem_object_create_shmem_from_data(struct drm_i915_private *i915,
>   
>   static int init_shmem(struct intel_memory_region *mem)
>   {
> -	i915_gemfs_init(mem->i915);
> -	intel_memory_region_set_name(mem, "system");
> +	struct drm_i915_private *i915 = mem->i915;
>   
> -	return 0; /* We have fallback to the kernel mnt if gemfs init failed. */
> -}
> +	/*
> +	 * By creating our own shmemfs mountpoint, we can pass in
> +	 * mount flags that better match our usecase.
> +	 *
> +	 * One example, although it is probably better with a per-file
> +	 * control, is selecting huge page allocations ("huge=within_size").
> +	 * However, we only do so on platforms which benefit from it, or to
> +	 * offset the overhead of iommu lookups, where with latter it is a net
> +	 * win even on platforms which would otherwise see some performance
> +	 * regressions such a slow reads issue on Broadwell and Skylake.
> +	 */
>   
> -static int release_shmem(struct intel_memory_region *mem)
> -{
> -	i915_gemfs_fini(mem->i915);
> -	return 0;
> +	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
> +		goto no_thp;
> +
> +	drm_gem_huge_mnt_create(&i915->drm, "within_size");
> +	if (drm_gem_get_huge_mnt(&i915->drm))
> +		drm_info(&i915->drm, "Using Transparent Hugepages\n");
> +	else
> +		drm_notice(&i915->drm,
> +			   "Transparent Hugepage support is recommended for optimal performance%s\n",
> +			   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
> +						      " when IOMMU is enabled!");
> +
> + no_thp:
> +	intel_memory_region_set_name(mem, "system");
> +
> +	return 0; /* We have fallback to the kernel mnt if huge mnt failed. */
>   }
>   
>   static const struct intel_memory_region_ops shmem_region_ops = {
>   	.init = init_shmem,
> -	.release = release_shmem,
>   	.init_object = shmem_object_init,
>   };
>   
> diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.c b/drivers/gpu/drm/i915/gem/i915_gemfs.c
> deleted file mode 100644
> index 1f1290214031..000000000000
> --- a/drivers/gpu/drm/i915/gem/i915_gemfs.c
> +++ /dev/null
> @@ -1,71 +0,0 @@
> -// SPDX-License-Identifier: MIT
> -/*
> - * Copyright © 2017 Intel Corporation
> - */
> -
> -#include <linux/fs.h>
> -#include <linux/mount.h>
> -#include <linux/fs_context.h>
> -
> -#include <drm/drm_print.h>
> -
> -#include "i915_drv.h"
> -#include "i915_gemfs.h"
> -#include "i915_utils.h"
> -
> -void i915_gemfs_init(struct drm_i915_private *i915)
> -{
> -	struct file_system_type *type;
> -	struct fs_context *fc;
> -	struct vfsmount *gemfs;
> -	int ret;
> -
> -	/*
> -	 * By creating our own shmemfs mountpoint, we can pass in
> -	 * mount flags that better match our usecase.
> -	 *
> -	 * One example, although it is probably better with a per-file
> -	 * control, is selecting huge page allocations ("huge=within_size").
> -	 * However, we only do so on platforms which benefit from it, or to
> -	 * offset the overhead of iommu lookups, where with latter it is a net
> -	 * win even on platforms which would otherwise see some performance
> -	 * regressions such a slow reads issue on Broadwell and Skylake.
> -	 */
> -
> -	if (GRAPHICS_VER(i915) < 11 && !i915_vtd_active(i915))
> -		return;
> -
> -	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
> -		goto err;
> -
> -	type = get_fs_type("tmpfs");
> -	if (!type)
> -		goto err;
> -
> -	fc = fs_context_for_mount(type, SB_KERNMOUNT);
> -	if (IS_ERR(fc))
> -		goto err;
> -	ret = vfs_parse_fs_string(fc, "source", "tmpfs");
> -	if (!ret)
> -		ret = vfs_parse_fs_string(fc, "huge", "within_size");
> -	if (!ret)
> -		gemfs = fc_mount_longterm(fc);
> -	put_fs_context(fc);
> -	if (ret)
> -		goto err;
> -
> -	i915->mm.gemfs = gemfs;
> -	drm_info(&i915->drm, "Using Transparent Hugepages\n");
> -	return;
> -
> -err:
> -	drm_notice(&i915->drm,
> -		   "Transparent Hugepage support is recommended for optimal performance%s\n",
> -		   GRAPHICS_VER(i915) >= 11 ? " on this platform!" :
> -					      " when IOMMU is enabled!");
> -}
> -
> -void i915_gemfs_fini(struct drm_i915_private *i915)
> -{
> -	kern_unmount(i915->mm.gemfs);
> -}
> diff --git a/drivers/gpu/drm/i915/gem/i915_gemfs.h b/drivers/gpu/drm/i915/gem/i915_gemfs.h
> deleted file mode 100644
> index 16d4333c9a4e..000000000000
> --- a/drivers/gpu/drm/i915/gem/i915_gemfs.h
> +++ /dev/null
> @@ -1,14 +0,0 @@
> -/* SPDX-License-Identifier: MIT */
> -/*
> - * Copyright © 2017 Intel Corporation
> - */
> -
> -#ifndef __I915_GEMFS_H__
> -#define __I915_GEMFS_H__
> -
> -struct drm_i915_private;
> -
> -void i915_gemfs_init(struct drm_i915_private *i915);
> -void i915_gemfs_fini(struct drm_i915_private *i915);
> -
> -#endif
> diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> index bd08605a1611..02e9bf87f654 100644
> --- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> +++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
> @@ -1316,7 +1316,7 @@ typedef struct drm_i915_gem_object *
>   
>   static inline bool igt_can_allocate_thp(struct drm_i915_private *i915)
>   {
> -	return i915->mm.gemfs && has_transparent_hugepage();
> +	return !!drm_gem_get_huge_mnt(&i915->drm);
>   }
>   
>   static struct drm_i915_gem_object *
> @@ -1761,7 +1761,6 @@ static int igt_tmpfs_fallback(void *arg)
>   	struct drm_i915_private *i915 = arg;
>   	struct i915_address_space *vm;
>   	struct i915_gem_context *ctx;
> -	struct vfsmount *gemfs = i915->mm.gemfs;
>   	struct drm_i915_gem_object *obj;
>   	struct i915_vma *vma;
>   	struct file *file;
> @@ -1779,15 +1778,8 @@ static int igt_tmpfs_fallback(void *arg)
>   	}
>   	vm = i915_gem_context_get_eb_vm(ctx);
>   
> -	/*
> -	 * Make sure that we don't burst into a ball of flames upon falling back
> -	 * to tmpfs, which we rely on if on the off-chance we encounter a failure
> -	 * when setting up gemfs.
> -	 */
> -
> -	i915->mm.gemfs = NULL;
> -
> -	obj = i915_gem_object_create_shmem(i915, PAGE_SIZE);
> +	obj = i915_gem_object_create_region(i915->mm.regions[INTEL_REGION_SMEM],
> +					    PAGE_SIZE, 0, I915_BO_ALLOC_NOTHP);
>   	if (IS_ERR(obj)) {
>   		err = PTR_ERR(obj);
>   		goto out_restore;
> @@ -1819,7 +1811,6 @@ static int igt_tmpfs_fallback(void *arg)
>   out_put:
>   	i915_gem_object_put(obj);
>   out_restore:
> -	i915->mm.gemfs = gemfs;
>   
>   	i915_vm_put(vm);
>   out:
> diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
> index 95f9ddf22ce4..93a5af3de334 100644
> --- a/drivers/gpu/drm/i915/i915_drv.h
> +++ b/drivers/gpu/drm/i915/i915_drv.h
> @@ -141,11 +141,6 @@ struct i915_gem_mm {
>   	 */
>   	atomic_t free_count;
>   
> -	/**
> -	 * tmpfs instance used for shmem backed objects
> -	 */
> -	struct vfsmount *gemfs;
> -
>   	struct intel_memory_region *regions[INTEL_REGION_UNKNOWN];
>   
>   	struct notifier_block oom_notifier;


