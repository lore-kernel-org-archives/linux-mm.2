Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5F0ED1171C
	for <linux-mm@archiver.kernel.org>; Tue,  2 Dec 2025 17:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFFFD6B0028; Tue,  2 Dec 2025 12:20:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD6A16B0029; Tue,  2 Dec 2025 12:20:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BED376B002A; Tue,  2 Dec 2025 12:20:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AE09B6B0028
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 12:20:04 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DE8C012C62
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:20:00 +0000 (UTC)
X-FDA: 84175193760.21.7A66D40
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF32E40013
	for <linux-mm@kvack.org>; Tue,  2 Dec 2025 17:19:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oCby9haV;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf17.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764695998; a=rsa-sha256;
	cv=none;
	b=fyA/37WdrSXHWbTivqFhtcVIv2T6nIEWjpXUxjC0im/1T3ye0ltUAhThRqiJkngtQOsjk0
	gwf5yRjvmvfOwX5wbzbm3k/4dVF5RYjWsdzYyPG93sZD0gO9MXnGA65tIk7zN+hE6OQlAD
	LARxPPV0Qg9QCeDWWQqfp0Jr3GwjJCc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oCby9haV;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf17.hostedemail.com: domain of mcanal@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=mcanal@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764695998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyCbUcL1nm1MZzDeCwaTG3zHrny4GdzBK6n/2gvUbXQ=;
	b=6K+M8dbpU3ncoP3eFxoeMT3p6Bsb0m3NcL1tfCvvbiCYfWyshKe9sZkbwT2v+OZ5TmI9vB
	WSF2IO1fgI8+bc7nEXJQAnvfT9DU8sKniRrla3F+aMR0c+TyLsACIRnHNs/VtVLHn+AzJV
	28g+HcWAUzHd2ozch6gEhG4M8cfgcFI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UyCbUcL1nm1MZzDeCwaTG3zHrny4GdzBK6n/2gvUbXQ=; b=oCby9haVuYdOrAIteZZoLwWkPu
	sVdsFQ//4adybW7oMm9kFJboF2Ed5gLUvpgNJeyfT6dBuHGoWMHO1Mhf2DFoaJTMSuH/A2LVghfoL
	HZzgX9yQPT4Weo65SlpJIWdO8XsR3Tfqq/NMlQofpliTvfwCD7kh9HYuaVROCYhk2q1PVXeHE30Vz
	t96mk3OxHne0/rWxVJ/174Yr/P9JJZOczGShKJYOSgSxAnW9vJKMH0Y+pUH2RvHsWc3Xnosbbcc9P
	W881kVQnLSY6Exd/GHsd2LeUq6HmZ8iFF6GwfbXBuWhkPT9NGD/+/YZIZfVeSr9uEXrbW0Hlz81w2
	sp0agC2Q==;
Received: from gwsc.sc.usp.br ([143.107.225.16] helo=[172.24.21.125])
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (Exim)
	id 1vQU20-007tsJ-AQ; Tue, 02 Dec 2025 18:19:16 +0100
Message-ID: <489a6590-7d1a-46f9-a980-5c30b2b44c4c@igalia.com>
Date: Tue, 2 Dec 2025 14:19:02 -0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 10/10] Documentation/gpu/drm-mm: Add THP paragraph to
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
References: <20251202101720.3129-1-loic.molinari@collabora.com>
 <20251202101720.3129-11-loic.molinari@collabora.com>
From: =?UTF-8?Q?Ma=C3=ADra_Canal?= <mcanal@igalia.com>
Content-Language: en-US
Autocrypt: addr=mcanal@igalia.com; keydata=
 xsBNBGcCwywBCADgTji02Sv9zjHo26LXKdCaumcSWglfnJ93rwOCNkHfPIBll85LL9G0J7H8
 /PmEL9y0LPo9/B3fhIpbD8VhSy9Sqz8qVl1oeqSe/rh3M+GceZbFUPpMSk5pNY9wr5raZ63d
 gJc1cs8XBhuj1EzeE8qbP6JAmsL+NMEmtkkNPfjhX14yqzHDVSqmAFEsh4Vmw6oaTMXvwQ40
 SkFjtl3sr20y07cJMDe++tFet2fsfKqQNxwiGBZJsjEMO2T+mW7DuV2pKHr9aifWjABY5EPw
 G7qbrh+hXgfT+njAVg5+BcLz7w9Ju/7iwDMiIY1hx64Ogrpwykj9bXav35GKobicCAwHABEB
 AAHNIE1hw61yYSBDYW5hbCA8bWNhbmFsQGlnYWxpYS5jb20+wsCRBBMBCAA7FiEE+ORdfQEW
 dwcppnfRP/MOinaI+qoFAmcCwywCGwMFCwkIBwICIgIGFQoJCAsCBBYCAwECHgcCF4AACgkQ
 P/MOinaI+qoUBQgAqz2gzUP7K3EBI24+a5FwFlruQGtim85GAJZXToBtzsfGLLVUSCL3aF/5
 O335Bh6ViSBgxmowIwVJlS/e+L95CkTGzIIMHgyUZfNefR2L3aZA6cgc9z8cfow62Wu8eXnq
 GM/+WWvrFQb/dBKKuohfBlpThqDWXxhozazCcJYYHradIuOM8zyMtCLDYwPW7Vqmewa+w994
 7Lo4CgOhUXVI2jJSBq3sgHEPxiUBOGxvOt1YBg7H9C37BeZYZxFmU8vh7fbOsvhx7Aqu5xV7
 FG+1ZMfDkv+PixCuGtR5yPPaqU2XdjDC/9mlRWWQTPzg74RLEw5sz/tIHQPPm6ROCACFls7A
 TQRnAsMsAQgAxTU8dnqzK6vgODTCW2A6SAzcvKztxae4YjRwN1SuGhJR2isJgQHoOH6oCItW
 Xc1CGAWnci6doh1DJvbbB7uvkQlbeNxeIz0OzHSiB+pb1ssuT31Hz6QZFbX4q+crregPIhr+
 0xeDi6Mtu+paYprI7USGFFjDUvJUf36kK0yuF2XUOBlF0beCQ7Jhc+UoI9Akmvl4sHUrZJzX
 LMeajARnSBXTcig6h6/NFVkr1mi1uuZfIRNCkxCE8QRYebZLSWxBVr3h7dtOUkq2CzL2kRCK
 T2rKkmYrvBJTqSvfK3Ba7QrDg3szEe+fENpL3gHtH6h/XQF92EOulm5S5o0I+ceREwARAQAB
 wsB2BBgBCAAgFiEE+ORdfQEWdwcppnfRP/MOinaI+qoFAmcCwywCGwwACgkQP/MOinaI+qpI
 zQf+NAcNDBXWHGA3lgvYvOU31+ik9bb30xZ7IqK9MIi6TpZqL7cxNwZ+FAK2GbUWhy+/gPkX
 it2gCAJsjo/QEKJi7Zh8IgHN+jfim942QZOkU+p/YEcvqBvXa0zqW0sYfyAxkrf/OZfTnNNE
 Tr+uBKNaQGO2vkn5AX5l8zMl9LCH3/Ieaboni35qEhoD/aM0Kpf93PhCvJGbD4n1DnRhrxm1
 uEdQ6HUjWghEjC+Jh9xUvJco2tUTepw4OwuPxOvtuPTUa1kgixYyG1Jck/67reJzMigeuYFt
 raV3P8t/6cmtawVjurhnCDuURyhUrjpRhgFp+lW8OGr6pepHol/WFIOQEg==
In-Reply-To: <20251202101720.3129-11-loic.molinari@collabora.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EF32E40013
X-Stat-Signature: mc58fj3qorg49d1bssio65gz89keosja
X-Rspam-User: 
X-HE-Tag: 1764695997-314685
X-HE-Meta: U2FsdGVkX1+qP+mFp8l1bfqr51xbMZYIKoEf1u4IReoOqQko9R7RCkFxNHdHCVCSN4FMJFhFYvCBjRKNdHTQawFnP9fFQSupBAHotKuUjtYPlqhDdEhp2h3E5p86IiAi1ohl2yd+TWtAnaa417GxUCCsV/xiyF0LRVoyMQOI5DsPsI0pLHGK8d3aJuYFTUWm2ymAhMXw8DHZfkYRA9UG7PpkkpkviJinpTCCmps+3eHzmfFbDEU6QHx+Rnw2BGbJpBgesiEVhb6yEbvO4Z5t+z+f27gk/2IDxd7QFqLLtzbB/4yW6noUWTmm8XwK0YLvjRhQ7tvBaiKLayYnV/stACizXxBctuhSCiHQTtY64KYThrDNuqFOvlAOWJ25YByIlAJLx6uA0dKxbJjuUT1rJUJLoFlsDNZKvIyJpMMWjaJYSGPhIx+FggGlPBlzkP0li6vjHgisDISwgx14M752r8e6XavgeMyfbauVeUMwjr+8lhZvD+87/P/+6bx0tiiTU7la93cqqOhP1R+ShA4husKm/ROm2b0wz8knPaC03W3cDEDXLQ/xJp6uOJHLUycJLA2/r7+exvfa+VejU3N2hWkIm95EvOFJT5+l+hiUoRf6epWhsY4cPtzF9adHe0D6a8jWjZhRyhhc9/68staPbmdU8xwFCcpZFYZr/0H8ka02458Kvhv5/bP6DDJoKPjicDZeTgrMQvHnyZvDqHQB1Unwxv/p7x43hMmCFOxlvnLsB9qKEl4XV+5U7dCyu1B2ab9USgU6IIv5b4tjxD30belLsQOkGXZq8rQCol00QBlt20fb+KMtyfL0rupBtE6A5mcRpcMRuxvMjwB9OEDZPOAHbDQyzedBJJvD+EbmamC6g9/ffXWyRbWbNk7FBh6lUCLiU6EDzCwEmDvlH9kH2pCjkaivaxJCNs05Qb3RThWUWBx0nG9Zebo2i60u0ZxDD81m7aofkWIan7TATpU
 t3HuVdRy
 xjGHkAPlnIIu8+++6RtDBMwrTffZHIjVOrKqGDyadn9DEQHQCimaRUfe6AVfQZQ7XyGJzsoBM0XoIXSV1jWIj8HOdBL0vro7OKaClKnSnG5XtcgqOHJ6wsQjj6J1EphzJ38c03rCjcIbuZMHBcPVFPbjF9YbRjvYx5XdYAu9ocDNTsmuLD/QIAHu4XeuvfupOg+47ooJO2BD0MJXzsW7YsKxMXDL0T+2EbJa7Csjcw8Sx8Fj8Du1hxWGeZ0Cq2KcAK03HMorC4/zi+DObCsSBWWelh3p7vCX8sAbhPTX0i4/hnzcaAllxI9mD4fqDF8w7muDoef3MxcFKrTzsTOcRnGC5jBvvpNenHlhFmEWnQlrEnq4iMkhOU1Itg9bwit0nYpPgyc9fwEhnXuaY3LTJWosBxJtze1vnfB7UuK/bfH5OY1Hh8yvByK2+U7getOURifB7rr3itFFS3Rs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Loïc,

On 12/2/25 07:17, Loïc Molinari wrote:
> Add a paragraph to the GEM Objects Creation section about the
> drm_gem_huge_mnt_create() helper and to the GEM objects mapping
> section explaining how transparent huge pages are handled by GEM.
> 
> v4:
> - fix wording after huge_pages handler removal
> 
> v6:
> - fix wording after map_pages handler removal
> 
> v11:
> - mention drm_gem_huge_mnt_create() helper
> - add Boris and Maíra R-bs
> 
> Signed-off-by: Loïc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
> Reviewed-by: Maíra Canal <mcanal@igalia.com>

Just confirming my R-b:

Reviewed-by: Maíra Canal <mcanal@igalia.com>

Best Regards,
- Maíra

> ---
>   Documentation/gpu/drm-mm.rst | 29 +++++++++++++++++++++++------
>   1 file changed, 23 insertions(+), 6 deletions(-)
> 
> diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
> index d55751cad67c..f22433470c76 100644
> --- a/Documentation/gpu/drm-mm.rst
> +++ b/Documentation/gpu/drm-mm.rst
> @@ -155,7 +155,12 @@ drm_gem_object_init() will create an shmfs file of the
>   requested size and store it into the struct :c:type:`struct
>   drm_gem_object <drm_gem_object>` filp field. The memory is
>   used as either main storage for the object when the graphics hardware
> -uses system memory directly or as a backing store otherwise.
> +uses system memory directly or as a backing store otherwise. Drivers
> +can call drm_gem_huge_mnt_create() to create, mount and use a huge
> +shmem mountpoint instead of the default one ('shm_mnt'). For builds
> +with CONFIG_TRANSPARENT_HUGEPAGE enabled, further calls to
> +drm_gem_object_init() will let shmem allocate huge pages when
> +possible.
>   
>   Drivers are responsible for the actual physical pages allocation by
>   calling shmem_read_mapping_page_gfp() for each page.
> @@ -290,15 +295,27 @@ The open and close operations must update the GEM object reference
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
> +
>   For platforms without MMU the GEM core provides a helper method
>   drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to get a
>   proposed address for the mapping.


