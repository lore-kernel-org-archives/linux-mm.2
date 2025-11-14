Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58291CE8D60
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AF08E0014; Fri, 14 Nov 2025 12:21:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B533C8E0010; Fri, 14 Nov 2025 12:21:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8FA18E0014; Fri, 14 Nov 2025 12:21:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9ABBB8E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:21:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 61C50139D01
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:21:32 +0000 (UTC)
X-FDA: 84109879224.28.91ABCD0
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5D2224000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:21:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aZEWjh2W;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763140890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=24kCOvea3EWaJbQNX30SQJO2VhYAAHekLZAG1ARIFTk=;
	b=oJ3a4n3ejwQO9VSbyYWIGlBRMGlthpx1uhiFrCdCrnd0+Ou7EALaW3qx4diJQ/h61ZdO41
	JCG/pLhrn00JE0bMnzfCc6S6IPrQy0Nhi/Am40abmeCLri/k48wuSdPSoBGeFalJDQVEXC
	amFjxkD+Ns1X4Ksogbg6QD+75J7aKW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763140890; a=rsa-sha256;
	cv=none;
	b=xbwJN0ydp4rFQlp/i0rZHkETe5mx16S8f19yJoDzO8F8S1iJtHXVr1z8rZQg77NPRZ7ujG
	8np1PCVegf92IcxrLd36z2mJFvbaD+nz/N9ACjrk3/p0o5eASUFHXwEF/sIFTq02shr92U
	q/deF1e7mWvrVAKiMObBj6DfnYm2+kI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=aZEWjh2W;
	spf=pass (imf01.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1763140888;
	bh=oj7XvIjYe1pE+bYy9IlB8i4bQFjMilLPQjx7YB4+1fA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=aZEWjh2Wv997fvjzfjYyiNTQsFctnvqof5bgUkdK3o3MvxxU3L95EO36ZFtvaekJS
	 bZAOmQW3lf4woB4mnn3aD5fFsnOqaiwBr6Unx6D28n/OhmaUMcto0pQ09uGJFMv32Q
	 THqCeF0gelYBNeFeiWVOPdzmBRhLCKoGCqx90SlnQw4cIoeNxTu3IEmqa7QDlKImSY
	 AYkUwTK58gic2wO1WcZDsdSqxvedDR/kGjwS6x3W8gdDro4c+P5vsMEAtppXec2FjI
	 QazQ6Ew3Qv4PS3ZhA2FcGOa8jYwJWTS2znHOiR3JtY/3AXrMIoI9xYNIna7rXnbfkb
	 13A8uW35xzEEA==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 59A9117E01EB;
	Fri, 14 Nov 2025 18:21:27 +0100 (CET)
Message-ID: <95ce7e6d-a2f3-4dff-adaf-22455f78a836@collabora.com>
Date: Fri, 14 Nov 2025 18:21:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/11] drm/v3d: Use huge tmpfs mountpoint helpers
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin
 <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?Q?Ma=C3=ADra_Canal?=
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>,
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
References: <20251114170303.2800-1-loic.molinari@collabora.com>
 <20251114170303.2800-7-loic.molinari@collabora.com>
 <20251114181144.51b44c8b@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251114181144.51b44c8b@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5D2224000A
X-Stat-Signature: 7fnhpe5hwda5t6kfu84oybemns4bbnu4
X-HE-Tag: 1763140890-12380
X-HE-Meta: U2FsdGVkX19QlThTT4LReRQbeB03ub3xxUAAYvfew2xjCXYifW1/LGN2QPb0rKOXym7Uh8cRnIORBLhuL8FCybIr+YvIFvw0PEuHghf6O/XwlFc2+ih4ufWxidPhrQJ2o6MpuWFI0o/djX160ZKmktB+pM0DJ9bh7iQRyg9BCs1UuvdI+fZGFRaQcSKbhjvviHwvJkU4DEpi3gQZFUWixCvNo9L1pIgBIKG5uSsbtK6Mv9vWUjy3FYOnv0PDkR1hsD2WEp8CrJ8cfpCtxHXUFkfdTTWeI78iA+EGKHxNBJ0mowo5B6o59ujiKw+w4niYi3+RLTlI7FiLSp2WZdgIghBMlrXvzHdQGKCJOcazHdmp4+a0xG4QhCpUn/8giSaga9mj/rr7ihaXpcU6WjaYN5b2yI5Ahda7l9FNGBbaURaeUpxtI89FoFCbv9mtgs3zn434lL2YwYqRhsD3qHGCeVF3uDPPXQsbdd/3HXkAYUBTE75vTRK/wsi5HTObhk5OfrIIBW9X7LqJv2VxigNy2KU0f+J+CY3LeoAAAHBhHRVaKkDzllDNzF3K1mf2+Hg8Xh/63TXWAat3KAKoVjus9yWHpN9Exg+RjeSNYx6kNI1f+MQqGdckmwGKheg9TF3D070E8pwaCRxQEPDhWTCb9Rus+f5HIBDLz7XQSwQHVOsN+rj4Vu4R9CSv3Siw7O9HpSVqc/IfrrTeS1ypmDOoGPOOA6K6SQHxeEr4aFjZ6tZ8T1QLbWE5zbhnYxFwYiU8WxEsggcdeEyRkGKCL5NlcwXf5nakoSK3SyrBfJsPcH9l/bhvfJGujH7zmI6zIfpYtdFKA7M6NuW98mgBaqmWuZWfXB48IGAYlo3YR6KeYPT8dyQx/5H9DMwtJEdFN5KML/wvltAhVfEA7Akiqv09c7Au1wCsjNLh0EMWgiwgLKvanLreahW4HDmAcu4zOo4DTTU0umKfgFP+VX4Q4YN
 HCkh1QLy
 1Taiw8VAr7ivYo1Z+uUzulZjne0gRqv8zRg7CRSd+Gbovt2KmmzdedyF3vmruEkBtgQE2vCQLIcc/iTiFUTH3OY0ge+B5r8WgPLrBMzBhgl4vQtcRo61kIsX/jj+9fUMTy0OxHm9oxWYqtWMBHLDJLmTJW2j35AH/gnOiRvAAkH38jwBuwbipjWCHXgiYN7RPhiMpyyeH7oLos2mBLhTtAC/OmAa/+ZhGJ+5LHt+lg1sinWPfE39xHxtgPVZ3dQMxe8R7qZIBTgyQLMFMrZpqvEqiQjcrpXW2SPx1cZ5KmfiJpES7KCNadZHT2X0mt4fpJhYHheiZgbldYH4/ICYdtjTHCRPOfgcMFQy2YebKntCCb7r37BksIZKJtW7fuycSyOkgiG4/8c/k6K3lYmybB7xpS3jMMNWRGssoCOFWCZdyCfAoneUKN2TAJve3AUwDJHaXct8ZTFbiJTU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/11/2025 18:11, Boris Brezillon wrote:
> On Fri, 14 Nov 2025 18:02:57 +0100
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> Make use of the new drm_gem_huge_mnt_create() and
>> drm_gem_get_huge_mnt() helpers to avoid code duplication. Now that
>> it's just a few lines long, the single function in v3d_gemfs.c is
>> moved into v3d_gem.c.
>>
>> v3:
>> - use huge tmpfs mountpoint in drm_device
>> - move v3d_gemfs.c into v3d_gem.c
>>
>> v4:
>> - clean up mountpoint creation error handling
>>
>> v5:
>> - fix CONFIG_TRANSPARENT_HUGEPAGE check
>> - use drm_gem_has_huge_mnt() helper
>>
>> v8:
>> - don't access huge_mnt field with CONFIG_TRANSPARENT_HUGEPAGE=n
>>
>> v9:
>> - replace drm_gem_has_huge_mnt() by drm_gem_get_huge_mnt()
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> ---
>>   drivers/gpu/drm/v3d/Makefile    |  3 +-
>>   drivers/gpu/drm/v3d/v3d_bo.c    |  9 +++--
>>   drivers/gpu/drm/v3d/v3d_drv.c   |  2 +-
>>   drivers/gpu/drm/v3d/v3d_drv.h   | 11 +-----
>>   drivers/gpu/drm/v3d/v3d_gem.c   | 27 ++++++++++++--
>>   drivers/gpu/drm/v3d/v3d_gemfs.c | 62 ---------------------------------
>>   6 files changed, 34 insertions(+), 80 deletions(-)
>>   delete mode 100644 drivers/gpu/drm/v3d/v3d_gemfs.c
>>
>> diff --git a/drivers/gpu/drm/v3d/Makefile b/drivers/gpu/drm/v3d/Makefile
>> index fcf710926057..b7d673f1153b 100644
>> --- a/drivers/gpu/drm/v3d/Makefile
>> +++ b/drivers/gpu/drm/v3d/Makefile
>> @@ -13,8 +13,7 @@ v3d-y := \
>>   	v3d_trace_points.o \
>>   	v3d_sched.o \
>>   	v3d_sysfs.o \
>> -	v3d_submit.o \
>> -	v3d_gemfs.o
>> +	v3d_submit.o
>>   
>>   v3d-$(CONFIG_DEBUG_FS) += v3d_debugfs.o
>>   
>> diff --git a/drivers/gpu/drm/v3d/v3d_bo.c b/drivers/gpu/drm/v3d/v3d_bo.c
>> index d9547f5117b9..211578abf9b6 100644
>> --- a/drivers/gpu/drm/v3d/v3d_bo.c
>> +++ b/drivers/gpu/drm/v3d/v3d_bo.c
>> @@ -114,7 +114,7 @@ v3d_bo_create_finish(struct drm_gem_object *obj)
>>   	if (IS_ERR(sgt))
>>   		return PTR_ERR(sgt);
>>   
>> -	if (!v3d->gemfs)
>> +	if (!drm_gem_get_huge_mnt(obj->dev))
>>   		align = SZ_4K;
>>   	else if (obj->size >= SZ_1M)
>>   		align = SZ_1M;
>> @@ -150,12 +150,15 @@ struct v3d_bo *v3d_bo_create(struct drm_device *dev, struct drm_file *file_priv,
>>   			     size_t unaligned_size)
>>   {
>>   	struct drm_gem_shmem_object *shmem_obj;
>> -	struct v3d_dev *v3d = to_v3d_dev(dev);
>>   	struct v3d_bo *bo;
>>   	int ret;
>>   
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>   	shmem_obj = drm_gem_shmem_create_with_mnt(dev, unaligned_size,
>> -						  v3d->gemfs);
>> +						  dev->huge_mnt);
>> +#else
>> +	shmem_obj = drm_gem_shmem_create(dev, unaligned_size);
>> +#endif
> 
> Why not drop the ifdef and go for
> 
> 	shmem_obj = drm_gem_shmem_create_with_mnt(dev,
> 						  unaligned_size,
> 						  drm_gem_get_huge_mnt(obj->dev));
> 
> ?

Oops, I overlooked that one.

> 
>>   	if (IS_ERR(shmem_obj))
>>   		return ERR_CAST(shmem_obj);
>>   	bo = to_v3d_bo(&shmem_obj->base);


