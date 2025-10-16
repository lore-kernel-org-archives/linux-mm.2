Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 378ACCCD195
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 07:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75BBE8E0006; Thu, 16 Oct 2025 03:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 733BF8E0002; Thu, 16 Oct 2025 03:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6223C8E0006; Thu, 16 Oct 2025 03:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E7E78E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 03:09:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1C52160228
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:09:32 +0000 (UTC)
X-FDA: 84003101784.09.9EBCEFF
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf20.hostedemail.com (Postfix) with ESMTP id DCF5F1C0006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 07:09:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fpKLHuCK;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760598571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjvME3iLSdqs7fnPfJnqJAO3QDEDT9eRIUvR5RurIH8=;
	b=BrppOd5LKGdznmNIVjgD0FTJ1tHj29rcy+GuMUykVGiXvpQ763n9vh91L8IcOaZHTH9zP6
	Kl6+sSHepbvsiVGEKiuajcQ4YVcZxK1/T8cNgUuTQN0bprbgIr2IIxyC/JTAjzJQvSpXip
	n43IPviRz6BB//2EcXeerQs1v5rk2Fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760598571; a=rsa-sha256;
	cv=none;
	b=wSR05rHS9iOG9vLMlYpxKyjM8ciWRboytnEjoHXjoQsQOba2sWl/hTKFPdPiqsl8bf8+xS
	Q7rKyL2y2Bb6y4QyCC/1EU5bnKWaPor2X3IVn2vW5mDBmekqgG+idpYH0isUNuW/c83rmk
	N6NBT6/fprs1/x3j23V7KvEW39/aIlg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=fpKLHuCK;
	spf=pass (imf20.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1760598567;
	bh=wn0XYjgDUo7meinqB6BVytuKFbpuX7M+TXDWRXqZTFE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fpKLHuCK3bPwex9k7zImSkr4e9sRbUoIKgvaRTS2zY2K5gDqgUytx6A8FGQlm710A
	 9SpZ6cjecVW/vuaLXncA26yveOEUYMMEx94CVPrNL9QZ2iyJAW/xdt3WmUwFfmukZd
	 PxqXaM882ixQmb2SWB/X3gRHgJE3IpHedCsrjNy6/QR9J5t6xeBTsDfMhwFrJMsowQ
	 MAmFsdt9SduJLiwvOmE3UQCTec7G9XeStuEZjBMz9gXqGQICDjDswvdPAsVn/A9Eg6
	 E/iqNFK3EgTBX1vFeEpzqEt6KXi6WSwsq2EA4/wfRdmHN+wG+1JcRxqYGSJNS5C465
	 CaYbz1cB1MdNg==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id DD4AA17E12BA;
	Thu, 16 Oct 2025 09:09:26 +0200 (CEST)
Message-ID: <02c8447d-25fc-4503-873f-0b2932e218ec@collabora.com>
Date: Thu, 16 Oct 2025 09:09:26 +0200
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
 <efc1d805-1613-45a9-aa15-fcc009adf27c@collabora.com>
 <20251016075637.3aec3465@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20251016075637.3aec3465@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: m44xkaxc8sx1665twuesqthjkbhd1f1s
X-Rspam-User: 
X-Rspamd-Queue-Id: DCF5F1C0006
X-HE-Tag: 1760598570-314426
X-HE-Meta: U2FsdGVkX1+3h+Wt3FMiROrnB4rkkpsW4er+wmgZjiNV4SNDbePKZpRzlEVQ9Hv5HSCbIgNvR3IJZgRce/ckQCX9J0PpNl/qpH0mjkvsKIBwbxUryzvB79X7xt4dKW/Nx2lNy1W6/W9rz4nHC25lFpQ5NJ72kfjC+1Bkl4B9KWNVh9vGZrc2Nt8Cay3fdgx8jCCccoLHfFP99eVrsQbRbRfMO54kVpP1kexwZWtyaNk5scawoyQUngS3qSOd5n3qwXzf+W8yezx9hKW8O00osVYCJCT6jkpwPJRzWyPf5ALTW66AHzRbBPAg/xAXbaB8KOc9sagjd4An5s7aDQzPW+aeB9uGSqtI/b1SsIMhFF33KWtQ1Co0EOCFet4s0Sju9H5zH/d6TA2M6ymvQD2im5ZbL7JcXpCxMsRJDk4J8Oxx3tkeBw/PyR0ZEPygjlz73bU1jnnzHvTOVIu8rczKqk/EdPclIwPrvPA6VYaV4DozwpCUxe78gasxH6TxpDQo9vJPgJZVtfPR+XWaMW/Swe/AbPjhvEYRgGXnvfDWFUJrtjFXSnccs2j5KQawV7jO0ju3w8N+bCwW3dOp0nOsriIhTE4VoAOayEKRu30y6V5V+JRcV6gHW2oEPx/pdgRkFzEd8Xp5EITtO2u9QnnqolvrLUZDWq72va/CujLT/0gccf09aSVXeXmGoSoQ6WcpUVcXPnzX1mAHJj8mE60jEDtXkHE+Bpg1oL/l3DpXFihwYopdCC35v+IWkyHjdDRf3qczyZnQVAEOIlOwL1HHjQietHzAyM7/eUDvCxGHNL0Jn4zWlnEaA6ZxbhIP+l1Z96OGIQs3C7CXUwIuQpaSlscKh+J01AtyHXhwK8lMjIVmpsz+mjjsXrdKz1EnUXpOAlF0+DIeASm0XJckR3TG9G7Fnk4nCEfOegPiUjGIjTAetl7xEqYZLB3WjXMb+eKK7VEPjBTE8gL7QiAEPSZ
 SzNdMm/c
 oMLwPIdVM8281ENqR8eqBmUP8NsaSsLaLtNuorFKrXRszpVT8rxL9J/PtnbwpIMJKLkI6/w+tRg7AeEc50PKW810Ju9aqCObKzfp7E1Ac/FMNr7YexNLhbGYkYwPDNRAce4amL0+s8/14OqTooSjJ0mUIdahOt+djxDM6Wda5rH3BFaOGnyX7L6O7PB0uoBH6kWwMrotUb11yF5/tepixvp5XsbjtYYJDQl+Hwsy/CYQ+cIHmpoyaeFnB/PRxEWKaTndzFNoQ4dXf9s4cKpNjBNiXbjsAGp2IetwSBe8+un1yi4YuVTZqXZShExE4GQlqmFsmrjVZ7NUJkzKWKqqp6H4lZn9DOwKTQYmyv2hGZKZ2u/K2GMETc/kMlz3ORp0+sZWeJbO8qhDSPK7ok2n86K0vcsffzOAEFyw/ibTpVyAq25ww9nJu4nQbMzz1Ww+VLKQgz+PhDK3R4ETmuC6XkYPTEHW7TRk3MyhN94DCJ/lDKJzQPN+5bRDN3Smhp0S5d+cr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Boris,

On 16/10/2025 07:56, Boris Brezillon wrote:
> On Wed, 15 Oct 2025 22:41:59 +0200
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> On 15/10/2025 20:17, Boris Brezillon wrote:
>>> On Wed, 15 Oct 2025 17:30:12 +0200
>>> Loïc Molinari <loic.molinari@collabora.com> wrote:
>>>    
>>>> Don't declare "super_pages" on builds with CONFIG_TRANSPARENT_HUGEPAGE
>>>> disabled to prevent build error:
>>>>
>>>> ERROR: modpost: "super_pages" [drivers/gpu/drm/v3d/v3d.ko] undefined!
>>>
>>> I believe this is a bug introduced by the previous commit: the
>>> compiler probably drops any code between the
>>> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) check and the err label
>>> because IS_ENABLED() evaluates to false at compile time. So I'd squash
>>> those changes in the previous commit.
>>
>> Right, it's been introduced in previous commit.
>>
>>>   
>>>>
>>>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>>>> ---
>>>>    drivers/gpu/drm/v3d/v3d_drv.h | 2 ++
>>>>    drivers/gpu/drm/v3d/v3d_gem.c | 2 ++
>>>>    2 files changed, 4 insertions(+)
>>>>
>>>> diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
>>>> index 99a39329bb85..481502104391 100644
>>>> --- a/drivers/gpu/drm/v3d/v3d_drv.h
>>>> +++ b/drivers/gpu/drm/v3d/v3d_drv.h
>>>> @@ -564,7 +564,9 @@ extern const struct dma_fence_ops v3d_fence_ops;
>>>>    struct dma_fence *v3d_fence_create(struct v3d_dev *v3d, enum v3d_queue q);
>>>>    
>>>>    /* v3d_gem.c */
>>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>    extern bool super_pages;
>>>> +#endif
>>>>    int v3d_gem_init(struct drm_device *dev);
>>>>    void v3d_gem_destroy(struct drm_device *dev);
>>>>    void v3d_reset_sms(struct v3d_dev *v3d);
>>>> diff --git a/drivers/gpu/drm/v3d/v3d_gem.c b/drivers/gpu/drm/v3d/v3d_gem.c
>>>> index 635ff0fabe7e..0039063eb8b2 100644
>>>> --- a/drivers/gpu/drm/v3d/v3d_gem.c
>>>> +++ b/drivers/gpu/drm/v3d/v3d_gem.c
>>>> @@ -269,7 +269,9 @@ v3d_huge_mnt_init(struct v3d_dev *v3d)
>>>>    	 * match our usecase.
>>>>    	 */
>>>>    
>>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>>    	if (super_pages)
>>>> +#endif
>>>>    		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
>>>
>>> Why not
>>>
>>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>     	if (super_pages)
>>>     		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
>>> #endif
>>>
>>> I guess
>>>
>>> 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && super_pages)
>>> 		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
>>>
>>> would also do, since it's likely to rely on the same optimization the
>>> previous v3d_gemfs_init() implementation was relying on, but it's
>>> fragile (not sure what happens when compiled with -O0).
>>
>> I'll remove the #ifdef/#endif around the super_pages declaration in
>> v3d_drv.h because it isn't necessary if super_pages is compiled out in
>> v3d_huge_mnt_init().
>>
>> In v3d_huge_mnt_init(), I'd add the #ifdef before the ret variable
>> declaration and the #endif right after the last else so that it's clear
>> drm_notice("THP is recommended...") is called unconditionally when
>> CONFIG_TRANSPARENT_HUGEPAGE=n, whatever the optim level. What do you think?
> 
> First off, I'm not a huge fan of the following pattern
> 
> #if foo
> 	if (xxxx)
> #endif
> 		do_something
> 
> which also applies to
> 
> #if foo
> 	if (xxxx)
> 		do_xxx
> 	else if (yyy)
> 		do_yyy
> 	else
> #endif
> 		do_something
> 
> I'd rather have do_something duplicated in an #else section
> like that:
> 
> #if foo
> 	if (xxxx)
> 		do_xxx
> 	else if (yyy)
> 		do_yyy
> 	else
> 		do_something
> #else
> 	do_something
> #endif
> 
> But I'm not even seeing what the problem is here. If you do:
> 
> 	int err = 0;
> 
> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>      	if (super_pages)
>      		err = drm_gem_huge_mnt_create(&v3d->drm, "within_size");
> #endif
> 
> 	if (v3d->drm.huge_mnt)
> 		drm_info(&v3d->drm, "Using Transparent Hugepages\n");
> 	else if (err)
> 		drm_warn(&v3d->drm, "Can't use Transparent Hugepages (%d)\n", err);
> 	else
> 		drm_notice(&v3d->drm,
> 			   "Transparent Hugepage support is recommended for optimal performance on this platform!\n");
> 
> You're guaranteed that err=0 and v3d->drm.huge_mnt=NULL when
> CONFIG_TRANSPARENT_HUGEPAGE=n, so the "THP recommended"
> message should be displayed unconditionally. Am I missing
> something?

It doesn't really matter here but I just thought it would be cleaner to 
explicitly let just the drm_notice() because the compiler doesn't know 
v3d->drm.huge_mnt is always NULL here and would emit a branch in 
CONFIG_TRANSPARENT_HUGEPAGE=n builds. I know your dislike for this 
pattern now, so I will stick to the suggestion :)

Loïc

