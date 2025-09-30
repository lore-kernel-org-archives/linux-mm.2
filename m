Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97713CCA472
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 16:42:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A24588E0005; Tue, 30 Sep 2025 12:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986F98E0002; Tue, 30 Sep 2025 12:42:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87B118E0005; Tue, 30 Sep 2025 12:42:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF7F8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 12:42:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1193AC079B
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:42:13 +0000 (UTC)
X-FDA: 83946484146.17.60EECB7
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2338B4000C
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 16:42:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UprHlYym;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759250531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AzjCiIqU5frx4saTL8qqec68O1JpgjL4nX59TMq9Tb4=;
	b=44/0lQAVLRAEbEDrU3IRYSrRuESD3W3CEdSfW2u4gfoAh7ZycW8Q1f7mbt8tuDSTGgr0db
	VH/Y1Ofp1ZBjBTrOdW8qrd0vJB1xOl/lRMq2RuMa1no2JYfbd9pezUnJHX9MP5C/ktFOJ4
	l2ZsSg2KUqXgB7WEvOif+SrsBMrRA7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759250531; a=rsa-sha256;
	cv=none;
	b=HdVh8JltzwAVNFEUXxAJVlVraIDRdmUA1zKhhugcQyEeUFks7iog2XFbR9lZo5V1C0dOOq
	TodYnhQmGF220NB/7uV2hdViqdirCu9PtpIad7E0le8awuvHHK8FqDT0SGOxgA/PYXZW6s
	2nLovqVmPl8HM2bwSBYU0xbQOuWtdyc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=UprHlYym;
	spf=pass (imf11.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759250528;
	bh=jguk/JSzmwgQx5dX/LxO/aT6uGm3rPlRw2544tHroQM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UprHlYymrE1wHFS94X2ZBnAUqm9aNsgUCUOlzig/pmQXcpAZ73A3Tia1Of5aWIe/p
	 Hg6srSyneiERMdMKwL2Y70gerM0fbtzNW/3HL7F6MAP8JfZHU6TRCVLm5OFrVNyybG
	 DKagN9kmi2XMl3lrd9fOpVr4GPY19suaQx5YD7eZLhC/AoIRn55lPgn7URWj85tdgT
	 FlZjWRtPVV1NbTxi3bU8xIMoqMJrDPuN8WhViUSo2Zou+lipclEuJQ0wk/BggPaGj/
	 jxG4pvjhJDrMM7ZDNe28fy37ZyOBz6XpB8EMOasW6BybaQnWWvrspuOTSdF/c5ja3i
	 eVBNN3HKTsNKA==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 07CFC17E010B;
	Tue, 30 Sep 2025 18:42:07 +0200 (CEST)
Message-ID: <22680961-1a51-469a-93df-ee9a63b3fd66@collabora.com>
Date: Tue, 30 Sep 2025 18:42:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] drm/gem: Introduce drm_gem_get_unmapped_area() fop
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
 <andi.shyti@linux.intel.com>, linux-kernel@vger.kernel.org,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 linux-mm@kvack.org, kernel@collabora.com
References: <20250929200316.18417-1-loic.molinari@collabora.com>
 <20250929200316.18417-3-loic.molinari@collabora.com>
 <20250930123003.75370854@fedora>
 <cd9084e1-16d9-4fd6-9c64-1876d53d5225@collabora.com>
 <20250930182920.5604ca49@fedora>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <20250930182920.5604ca49@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2338B4000C
X-Stat-Signature: m83axayezcrh9kqqfdaakm61uzkcnpdq
X-Rspam-User: 
X-HE-Tag: 1759250530-524328
X-HE-Meta: U2FsdGVkX18zFGwf7WGtPXjUeoZd+/vRyxS3WTTPJfCs0X84/yBzxGDNvhHOsXQsOsH1nDoEuNYTvVwCLR3zW5W/fWlRu8S91mP5jUQUE/Q6IXoFRUj1y4+6kZI+K3+fBW8vwswNC2w9z4ln4ahTIullfN2zt2qy+a3yPs3KglktfZucA3tR3NP0NowynxYkIXW+l+oiatRxwfSB8CcTX5z0ssqen4jk663Na1e+eEH98lbuD2UV0ECCCUPoK5RLuSwRcR1K1nbKPdKAp7NczkQhtDV8UZ3Bgh8S9rKgDUQTjFTPGiVZj/TMlQZa79ql/SdAWz/MYfl8Lt8/1j4LM8KN5SRHuwqsgecUUq9hjBuVt2/i2ERluG1+qnxZrXM1Q858ShSleaPd+Q2Vaq1HQLOoniGPfbbhtvnqbyKsIfK+iQKnWwuiwdJodV0X4G87ViUnjSYNSKx4MPtSUcItVCo1oYKuIC/XkeabfBxE1qIh6TjyzePJcbVIohcNEVUK2qHxzcd//yw7E9OI8huofxqhsB0/444Y0qVibWCbrUjE97LSVP4GBaCMR6AJs3bKCBKOMiGqVRheHr6G6mkVf9MeL8zPtyuQY3hR2MZ+X5cw19y1Cm87UPcgoY5iy+b/xDENG6usUEPEsG/fEhFiY2aSaVWt9xfQTVg4ZeJnblHDqshQmp4uIRGw5xUdKa2YQnQ64bBUq9qWzQnvXi5bnas+KzkoQiUOKH2EldAw0EkUCMf+vieruJeFBwU2zUy4SlyGc4iDf/Kv/ef/ys3BS/ES+rBV/TyKxRRDOtd+KOptCcSByDos7RYbPVLhLYTH4dTjzja8cDDbWtyfh1ZTTYutHWLIphZJDrx0F30/UK1/ogpO2L7ryIdcAZDHVKpeTO1CNA2CtofSNNg0tQRfKBGpkrOqAon3t/Bm3pQ49fDykAaHoAlU77DgMvWmDDRAg3pE2AxWIaofup6p7f0
 +PzBBoUq
 RmWn0VRpFWuaSY9TW6vuUbZdLtq6ZR1Dx+9MIkaCKiI5cjX+/Fe/PaXF6AqRSMuWu9K0aSeGU2Wc97cBZHmDWtdTJqobXg+wlLMCxVWDR8cE/wwESIw11/tLr6ly/uGPYw/9TbZj22buNrmlhMCCY9/vN0lYn9hBktY7031uCbfYmvVUs3hlt57YHc2pX+uSoAI575yRkfo5GYAX/Jk9DCDxXKMbMdjtFuC1UZRK+YgS9+pCuaIe3aCCXHvFv4AtVIiSGBn7K29my3rutTattXKUh857igrO3VX4+Ct+wnLmjIPRnqFInO3f7+oWfp0DvF+aRgUlhOQpzbBqk/HIT1d9m7GiuYPOaUxexZOcTIY7PnCczfHYG6GnYkdTFd2DwmQdwN1ihwWFyeRPvLVn9wPB9nLS8jIEPjSfYIGhbyZcmSF5rMaEc2Vz94xtF19xDaLFONTJb83u9S9k8uEvqY3045BL3p/+CrZkzXAzRS7vJLv42frerYQ/OpEgn7GV+SluQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30/09/2025 18:29, Boris Brezillon wrote:
> On Tue, 30 Sep 2025 18:09:37 +0200
> Loïc Molinari <loic.molinari@collabora.com> wrote:
> 
>> On 30/09/2025 12:30, Boris Brezillon wrote:
>>> On Mon, 29 Sep 2025 22:03:10 +0200
>>>
>>> Loïc Molinari <loic.molinari@collabora.com> wrote:
>>>> +unsigned long drm_gem_get_unmapped_area(struct file *filp, unsigned long uaddr,
>>>> +					unsigned long len, unsigned long pgoff,
>>>> +					unsigned long flags)
>>>> +{
>>>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>> +	struct drm_gem_object *obj;
>>>> +	unsigned long ret;
>>>> +
>>>> +	obj = drm_gem_object_lookup_from_offset(filp, pgoff, len >> PAGE_SHIFT);
>>>> +	if (IS_ERR(obj))
>>>> +		return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0,
>>>> +					    flags);
>>>> +
>>>> +	ret = shmem_get_unmapped_area(obj->filp, uaddr, len, 0, flags);
>>>> +
>>>> +	drm_gem_object_put(obj);
>>>> +
>>>> +	return ret;
>>>> +#else
>>>> +	return mm_get_unmapped_area(current->mm, filp, uaddr, len, 0, flags);
>>>
>>> Looks like the above code covers the non-THP case too, do we really need
>>> to specialize for !CONFIG_TRANSPARENT_HUGEPAGE here?
>>
>> It does cover the !CONFIG_TRANSPARENT_HUGEPAGE case
>> (shmem_get_unmapped_area() would just call and return the
>> mm_get_unmapped_area() address) but the idea here is to avoid the GEM
>> object lookup cost by calling mm_get_unmapped_area() directly.
> 
> I'd expect the extra GEM lookup to be negligible compared to the overall
> mmap() operation to be honest, but I guess if we really want to avoid
> the overhead, we could still write it without this ifdef.
> 
> 	if (!IS_ENABLED(TRANSPARENT_HUGEPAGE))
> 		return mm_get_unmapped_area(current->mm, filp, uaddr,
> 					    len, 0, flags);
> 
> 	...
> 
> My main concern is that shmem_get_unmapped_area() evolves with more
> !TRANSPARENT_HUGEPAGE cases, and by calling mm_get_unmapped_area()
> directly, we miss the opportunity to get optimizations for these cases,
> just like we missed them by not forwarding the ->get_unmapped_area()
> requests to the shmem layer so far.

Yes, sounds like a very good point. I'll remove the ifdef and forward to 
the shmem layer unconditionally.

>>
>>>> +#endif
>>>> +}
>>>> +EXPORT_SYMBOL(drm_gem_get_unmapped_area);
>>
>> Loïc
> 


