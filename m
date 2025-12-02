Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B28C3D116FE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 10:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1BA6B009E; Tue,  2 Dec 2025 05:26:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B8E16B009F; Tue,  2 Dec 2025 05:26:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F6966B00A0; Tue,  2 Dec 2025 05:26:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 012EB6B009E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 05:26:18 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A222B1A055E
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:26:18 +0000 (UTC)
X-FDA: 84174151236.14.933379E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf21.hostedemail.com (Postfix) with ESMTP id A741D1C0007
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 10:26:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="bFOm8/v6";
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764671177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjkSLtm28g9c5imfHKVdkdIKMN+ljMc1mINeIQ/kvpw=;
	b=y1X4WPv9r/BFQ+yrNtlY4u3+Mukudv7qWK+UjAAbUVrMT526eZq7ZL19bnrnHtL/1dWvL8
	0HMNVRlq5Ean7R5XXIrT+JKyQBgQkS3Y3WNHE5rqlWNA8U3+LK8vxCczl1xxFK0XusfZrk
	Jazzy46aqvjO9qvyKwoC7IsDyVz/jjo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b="bFOm8/v6";
	spf=pass (imf21.hostedemail.com: domain of loic.molinari@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=loic.molinari@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764671177; a=rsa-sha256;
	cv=none;
	b=RPjS9nePN6/+vfuwhM5uiyuCX+q7T5+25fPJTV2vN+l8QD7lFwsC2NmyoJeALgdP3JuzHM
	35UR8Fmt30m2kePLNV0Jy70zhnDxeqAavoc0UvU0CS9lDA1frSqR3Jw7ZmpS8mKyz/iVIs
	l0oCTewmyqT49bPk6VnPiFFhfz3p830=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764671174;
	bh=e7TL2i9NphOc/kce1J1qGMHgFQPOLfYmW0DnWE9bCNo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bFOm8/v6aGx1M8z9Zpyb9UCv3oCX5iuw35PHBfvlLzi1JdAc/hfcxthIarnTbNCmy
	 2I0VCRherX6/R1pZ7//qNSValT98ap82x/aN8rBQadvr/Sqp/fCX03wW2OP0k00VlR
	 BNYWfg0jR7SWsb5PuFzr2aPjdx25oUmHUZCb9wL3kl6gaWVsd3sl9q22u8MS9gbY1m
	 biItp7+M0CcXY89Skv35SgVG3yNdN3Twq6IUnzBBPyLTnrsqNNs/tC8WG0dtzdLHmY
	 zQlHEjlBD/b2u6jACtPmAUphkSD0T77qcK4KuQxC8PeqtJQrzbo8d+J2XIwpuAkP8C
	 N60bj6/UJdbjQ==
Received: from [IPV6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa] (unknown [IPv6:2a01:e0a:5e3:6100:7aed:fe0e:8590:cbaa])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: loicmolinari)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 91D2717E114C;
	Tue,  2 Dec 2025 11:26:13 +0100 (CET)
Message-ID: <5554e135-8184-4aab-9b25-19f9e8cf1d7c@collabora.com>
Date: Tue, 2 Dec 2025 11:26:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 10/10] Documentation/gpu/drm-mm: Add THP paragraph to
 GEM mapping section
To: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>,
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
 <f1a5e5a9-2193-4a47-9fce-c51b223985aa@igalia.com>
Content-Language: fr
From: =?UTF-8?Q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>
Organization: Collabora Ltd
In-Reply-To: <f1a5e5a9-2193-4a47-9fce-c51b223985aa@igalia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: qj96anaz3quw5zumzpprdjsoq45jsym4
X-Rspam-User: 
X-Rspamd-Queue-Id: A741D1C0007
X-Rspamd-Server: rspam09
X-HE-Tag: 1764671176-935743
X-HE-Meta: U2FsdGVkX19od/pERCHZxwYW5CFtqZJ2h856LiWhPD3sOYspmyRCJ5aZekjv8rFGlhCChxxWpE0udH4lp7pHTYzU6UNqokHsqyvbQauM7X8J20xohm9uAOnPrQTVQaJR8olRFD0AYmNIM0uZneDEs7yh5zOClnpToA1jonSsbXKkbDRGUWlzW8O02riRVNdezzPrF+PAYU0A8proBo8kMceXj0Gbg+pWsH8YvH2ewOQHj3QsIgtGjGALmLGi/JsIRh9iTsk+50kwtz6wDDjWZeRcYA0Joxbw0hE0fl6VKyykpmL/+m/CKQyOcGrvnGXfQSOr+mnKCQ+F42sB7iQJZQ+fKPsb/cM85FrdzOsbsVd3OEbtcry7HBVrL5E+/BriX9j8gINl8ZFIQOb6d+4YTr4Y8bZl4dRi64JLQ3UZZcsiCFYNWprE6aOGg8GABIstqk79IWwDKTmzxjS2mXnEhpoK255gcsIiSDwfTBRq9QIWm9lSJJF/9ducN3dX+qJn8bIB4W11I7pIAHNdQdTBXt1q9qgPLapouyS468STPLwSi+n2tU4GfqDJLxS0Xj1PL6nVtgqR4Nid8AY0czIRnM0oYguJTLcTbmZhkMglA30FBv1ggAHw1mpWfk5xH+maVbYk8i1zWZO5AAmqoW2KUVjedBkYb02fBkf+D8HY3o+nw7Kk2tUm2IByXM3SslD0MyCpS3EUvOpbXT8XJmvVYRn+/I6ftljTLJlS/ZYax8LRHugAsdGqyvirA+/gwpgygDfhGtTL5d4uLoxWasBkZi+PigQqB8ArWcfpdc1RvTICEyv6vn9a7litrH/Tr1JfIypwBZKdX0DED3O42J/2p3MAm80ZZ4lz3Or5mw+WSfspGhuJiWOuwRGJkZgKwPVaHp6s5JMz0poK6SnZUkvBIEuP9/c81JeMLS0HbxFhQxmriugLeHK11Xwru7vLB/Y46GG9n33PO2eykEi9oWl
 uS6xBrfL
 Wb0+gBP9WDYDRhlwQiIjRPcW88fEw+kXXIeFJjLqXgWtP3yaGDs1pG6T/yWNWv+P93cBkU7shERf0023DNQWOjaNphm/D/5eX7G1ouGA4qOv1G44wUL76WwBsrVXWpKiAOJMZW/HH9KR5H/irHPKkyehTYPzdWBZr7u6vruaMUydLOuBB1pbFXsm33WYHuhgOrf8JaM4h7YX/hu6AJ9PSaoaG01KPmS7RMAairTcBowCK6k0CgoeSMfst1HEvf2icCrtpOLY0IjRP6G763rFu7XKyMYqMtTomUvyXK8/A8tAJ7XuGaP5i5qnHM4MN2/rNkaJ9BI8He7F8fzEicpdlluPJ3zs02S8r06qV17z/EZkdfJphhw5QjL4r2wM7Ke2nKrXxp4y+MTBzq1HkVit0+8NOcHiugdrfRCSJI7yUVWyLvsk03whbczeC2US0Xbr+8NKqeCrzjlNxwHAsZ2tBkbBDCB+/OrJelTo09ZTYWVX/5FU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Maíra,

On 01/12/2025 14:27, Maíra Canal wrote:
> Hi Loïc,
> 
> On 28/11/25 15:52, Loïc Molinari wrote:
>> Add a paragraph to the GEM objects mapping section explaining how
>> transparent huge pages are handled by GEM.
>>
>> v4:
>> - fix wording after huge_pages handler removal
>>
>> v6:
>> - fix wording after map_pages handler removal
>>
>> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
>> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
>> ---
>>   Documentation/gpu/drm-mm.rst | 22 +++++++++++++++++-----
>>   1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
>> index d55751cad67c..d69eab0b4093 100644
>> --- a/Documentation/gpu/drm-mm.rst
>> +++ b/Documentation/gpu/drm-mm.rst
>> @@ -290,15 +290,27 @@ The open and close operations must update the 
>> GEM object reference
>>   count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() 
>> helper
>>   functions directly as open and close handlers.
>> -The fault operation handler is responsible for mapping individual pages
>> -to userspace when a page fault occurs. Depending on the memory
>> -allocation scheme, drivers can allocate pages at fault time, or can
>> -decide to allocate memory for the GEM object at the time the object is
>> -created.
>> +The fault operation handler is responsible for mapping pages to
>> +userspace when a page fault occurs. Depending on the memory allocation
>> +scheme, drivers can allocate pages at fault time, or can decide to
>> +allocate memory for the GEM object at the time the object is created.
>>   Drivers that want to map the GEM object upfront instead of handling 
>> page
>>   faults can implement their own mmap file operation handler.
>> +In order to reduce page table overhead, if the internal shmem mountpoint
>> +"shm_mnt" is configured to use transparent huge pages (for builds with
>> +CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
>> +managed to allocate a huge page for a faulty address, the fault handler
>> +will first attempt to insert that huge page into the VMA before falling
>> +back to individual page insertion. mmap() user address alignment for GEM
>> +objects is handled by providing a custom get_unmapped_area file
>> +operation which forwards to the shmem backing store. For most drivers,
>> +which don't create a huge mountpoint by default or through a module
>> +parameter, transparent huge pages can be enabled by either setting the
>> +"transparent_hugepage_shmem" kernel parameter or the
>> +"/sys/kernel/mm/transparent_hugepage/shmem_enabled" sysfs knob.
> 
> It would be nice to have a paragraph about the use of the huge tmpfs
> mountpoint helpers (maybe in the "GEM Objects Creation" section?).

Thanks for the review.

I've added a few words about the drm_gem_huge_huge_mnt() helper into the 
"GEM Objects Creation" section in patch series v11. I've also just 
realized that I added your R-b to that commit without you asking for 
it... sorry for that. I'll remove it in v12 unless you explicitly ask to 
let it there.

Regards,
Loïc

> Best Regards,
> - Maíra
> 
>> +
>>   For platforms without MMU the GEM core provides a helper method
>>   drm_gem_dma_get_unmapped_area(). The mmap() routines will call this 
>> to get a
>>   proposed address for the mapping.
> 


