Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62D09CCD193
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 20:42:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D0A88E0005; Wed, 15 Oct 2025 16:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8468E0057; Wed, 15 Oct 2025 16:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8EA8B8E0005; Wed, 15 Oct 2025 16:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7B6808E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 16:42:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C87513A7EC
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:42:05 +0000 (UTC)
X-FDA: 84001520610.24.E4073BA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C018180008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:42:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MuAGazgH;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760560923; a=rsa-sha256;
	cv=none;
	b=3vestBXAscn1IHCnKyIhCluDGdqcNTwMw6+274+O3K6DwmlBZTXqPWoUKPElFyodxfChTo
	Vpjk62CfWUWJAVLJW9A1Zi8XSqsHKdHUX77VY7fA661r4IgIMk7ayDgxBMmP6o/M0NHjQa
	fR7ZPQ+uKnuMqlRoA4BSXd8V86ql+uw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=MuAGazgH;
	dmarc=pass (policy=none) header.from=collabora.com;
	spf=pass (imf24.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760560923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9BU+Ina17XWpogHmVUKIVXEkGA9CX8oA0k8fU1AM3Y=;
	b=jPumjKFGe/dKBmnl+akC1XLhCYQl/nKqBJh+X0QA/pkU4KikFHP98zl+3VD8tJxea7HmA2
	fAXPEijq3MM2hxr9CTTO5LqCNRZj/Pjc30bWIEIgbZtmwKoh6NL/9Uu9rIFYDUSxKeDKkX
	AjqaDKXGOmfmmr8FB44r4qZciZQUZcE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760560920;
	bh=6NFItZksUnL4AeNLzkE9uW56mfjFXSMe3I2p1k1atTk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MuAGazgHFf5NMEd+91RF7Wbfyfomf3WrSUyB9/IZolPbvVH5lTuwAPCHd7tE6/Bq7
	 QqCVAo7pOpD5H83FsAH3RRWYz68OQPN+OeXkMVTIM6jkrZS4ylGZUoy4zi8xMfgBdW
	 cD+AO81Ijw1bO1YB494nBepz2rX7bX43B0L+WMFhLbczgk3sm91zprnGct2I7/iP0D
	 G38aiNIDYCkYwl/E2lkzLt7zE0PVuX3pGypRYRN5cqRJbG7stRBmvSZVJF9dedIGdW
	 7mU087gqoePoUadp0Z94Elm1QCIxIMvrH+Uwil+z9n3QN0DEgbVvE/3cjWk9jflzhe
	 RfSGnUk7yuuFQ==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id B526017E0C54;
	Wed, 15 Oct 2025 22:41:59 +0200 (CEST)
Message-ID: <efc1d805-1613-45a9-aa15-fcc009adf27c@collabora.com>
Date: Wed, 15 Oct 2025 22:41:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/13] drm/v3d: Fix builds with
 CONFIG_TRANSPARENT_HUGEPAGE=n
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
References: <20251015153018.43735-1-loic.molinari@collabora.com>
 <20251015153018.43735-9-loic.molinari@collabora.com>
 <20251015201737.3956f801@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251015201737.3956f801@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8C018180008
X-Stat-Signature: fs5pe5i5abzgjhnxd1wnh573moai7noc
X-HE-Tag: 1760560923-307069
X-HE-Meta: U2FsdGVkX18YV7qJZiRzunEQ16px1ZTNBVladlF9wKvTyj8EWTWPd0qYdTuN0HZ6GS9UuS3SMNPDd+XfCepKDzWSETvnlEhaMuUTT+1o41hz69YBwzCXdMOgUSBp7vCjdGk1cVQ80Vd74n6K8nxH5UeoXujUDJrfSe6chNnIhgMYkqrCJdElRPA4YAknqd37YYPzXDWSMtdYGUkQqkIVOSuwbWE2G14p3sWmAPmhdyqN/Oq4g0jG+9v+imE7qxg4gpJmEVrcXN1HwXOSI+rK6w4peQ0hwu95G0buBT4/y43dsA5fYykG7Ro3AhLYnOCJNqtKrmoAAM4kzsOl00crLRXA3CwhTw0wfmZsiYNMTsSCFfgd8uqlt1obKSbOnOVnQgt+hJf/zdy5ocs82v6XV9k7u6SX3kU2F1EO1Xpfot19nNNX4HVTk8jflKnbSINLMN8pJDfO/Zf9bOraor8ARvl5bgIP1zE9+PuUak3+Ks2hmY9zrNcpk8/lgq7uyi6IS5sMF8ZToupHW82xHSwIQR4O1ourizywCDYFhI1Nn3dyirI9LuKDqd5eDKjXIK3c4J48sYfCxqSw7Bo0NkGqOIeKWA/eafZPnou9bYgpvhqY7R/0olKt2l0kQ80wCuydeAMTmoFd3DTb+WUdgsyDcW96bAj7f/CPJWEji0IYu6bla2Q0SsGDTNWVs8nZE2FVq4DFLVhu2Ji9ZQvFIWKIs513l0VSdwb7pCxcxkpbWLyJFGe2U4yg8MqjIpVwv0fy1WvJeYc2gXlyJrksb4Ciid9s5a57CCkkyRg7gxNse3HE7XK85fRsJT/fxzt+ld7J8HeiIGw9sX3BVPpLIz9n94wxujue3gOQpqYWhx3sCtnFei1OUKzzc2AAkQ2ZutKEfPgkXAgFSmrCBMg8jgNkYNTd9VE2x8E2ATubE1JDP+NTsC4r6Am5RZg9amSu/rbzqladJ5P9dpNQH/FvTSb
 OohwCJdg
 3274lu1tTbGScNzdvqbfCnJktRxnDY5+6odZbmIKg2XFR29mrG53wdvhDsTJP1J5JL85yMwYtSIDgc6vutVt5ImIKEbdoSQRnvva8IwZJGvxr9ES4ZAsSM55VYoiHqC+vdNJCk77HLq3frng0LpEk/vQKC5GoBvDq6r1nVT/6QGl7xXNzIDEKE2NnoAMiufoDy2O7ZWKrRglsZS8s5tT+Exz/nEe2X4EeELBFGYyXJsylyM89Woc/e8jCzMB4mpkjo7/Ko/RzT4tWNwS/OmDaOLTujrOS55cYEXZbHOCBWalnkJzqlkd61XFkrVs/haX1T9hkobZcBhyDw5NfWnT3EHolwbSJC9S89KlV/o68lbuHnVsjHTcas6Mb1LNiQif+tR/zhDKwC7yOqn9UdZTRu4USmOrVrx1dHvABU3peOx9Ye40TKYGO1ZPk5w2F9Nx//z9LjlhC9GXCnZ0zr5Or2JvMKFsCJeO/9tXHtVHJo8lM2Zb7k78HxeXexrhQqhec4zLZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 15/10/2025 20:17, Boris Brezillon wrote:
> On Wed, 15 Oct 2025 17:30:12 +0200
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> Don't declare "super_pages" on builds with CONFIG_TRANSPARENT_HUGEPAGE
>> disabled to prevent build error:
>>
>> ERROR: modpost: "super_pages" [drivers/gpu/drm/v3d/v3d.ko] undefined!
> 
> I believe this is a bug introduced by the previous commit: the
> compiler probably drops any code between the
> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) check and the err label
> because IS_ENABLED() evaluates to false at compile time. So I'd squash
> those changes in the previous commit.

Right, it's been introduced in previous commit.

>
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> ---
>>   drivers/gpu/drm/v3d/v3d_drv.h | 2 ++
>>   drivers/gpu/drm/v3d/v3d_gem.c | 2 ++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
>> index 99a39329bb85..481502104391 100644
>> --- a/drivers/gpu/drm/v3d/v3d_drv.h
>> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
>> @@ -564,7 +564,9 @@ extern const struct dma_fence_ops v3d_fence_ops;
>>   struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
>>   
>>   /* v3d_gem.c */
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>   extern bool super_pages;
>> +#endif
>>   int v3d_gem_init(struct drm_device *dev);
>>   void v3d_gem_destroy(struct drm_device *dev);
>>   void v3d_reset_sms(struct v3d_dev *v3d);
>> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
>> index 635ff0fabe7e..0039063eb8b2 100644
>> --- a/drivers/gpu/drm/v3d/v3d_gem.c
>> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
>> @@ -269,7 +269,9 @@ v3d_huge_mnt_init(struct v3d_dev *v3d)
>>   	 * match our usecase.
>>   	 */
>>   
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>   	if (super_pages)
>> +#endif
>>   		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> 
> Why not
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>    	if (super_pages)
>    		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> #endif
> 
> I guess
> 
> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
> 		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> 
> would also do, since it's likely to rely on the same optimization the
> previous v3d_gemfs_init() implementation was relying on, but it's
> fragile (not sure what happens when compiled with -O0).

I'll remove the #ifdef/#endif around the super_pages declaration in 
v3d_drv.h because it isn't necessary if super_pages is compiled out in 
v3d_huge_mnt_init().

In v3d_huge_mnt_init(), I'd add the #ifdef before the ret variable 
declaration and the #endif right after the last else so that it's clear 
drm_notice("THP is recommended...") is called unconditionally when 
CONFIG_TRANSPARENT_HUGEPAGE=n, whatever the optim level. What do you think?

> 
>>   
>>   	if (v3d->drm.huge_mnt)
> 


