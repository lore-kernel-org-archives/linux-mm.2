Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9699D3CCA6
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 03:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A626B0089; Wed, 14 Jan 2026 22:01:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 327D36B008A; Wed, 14 Jan 2026 22:01:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F0AA6B008C; Wed, 14 Jan 2026 22:01:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0D7B96B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 22:01:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 90E7488B2D
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:01:58 +0000 (UTC)
X-FDA: 84332698716.29.022D015
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id EC0011C0006
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 03:01:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=omuyeZrw;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768446117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5zQLK1Kx4KSHBdB8iyadgaDb9pVP4BI/1Am6eQhl6y0=;
	b=JlOjPpHJZlhAL6sL2olLx5IRf+JrbY7P+f2QdoaIO63xBl413fD9F63UcVSkVT7Khq6AII
	Qseq5MKVOkkHaMIloOVnmpAXrUjLGHezhPH/9knPg0OUzGK7MMpqSbPJ5m1Sub3uvWKEkP
	9rIEADA391eAybNXb6ldy7+F6AUnscs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768446117; a=rsa-sha256;
	cv=none;
	b=ugmGPEUI8HUk/alCwyVSIS+VyIVtPio1rI8nTZif+/8FgwW19rPbB1POl9S0Ij682u8yQ/
	O3GHn36IpFDxTNpYxfrNAGIIwRJrGzgQObYFu0pAvplglB3CUcylL4MSSHzTWIkQpRZ0Vb
	g9BWwdl1Db6l/KV3OpQAsMMeyPjxXgs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=omuyeZrw;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51D4660140;
	Thu, 15 Jan 2026 03:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7A77C4CEF7;
	Thu, 15 Jan 2026 03:01:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768446116;
	bh=t62plHsTL0NzPFD3kffjbbJXeKPsO+HXKRB8ZhdlO8k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=omuyeZrwDujiPdNf06U42mHqbJE+T8krxLxsXa0Dh7kwj5wgnsDsccsWbhd7wdXP4
	 UC66ZVu6CpbnfNPYvmLzhn5wXv+rRL9cYqbyE5VJMvghF+HKu7COLRojjM/kTPkbVc
	 +6YenfbpT4eR4UVzrm/t6nRiEN5v/+/MXNu4aqwo=
Date: Wed, 14 Jan 2026 19:01:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Francois Dugast <francois.dugast@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Matthew
 Brost <matthew.brost@intel.com>, Zi Yan <ziy@nvidia.com>, Alistair Popple
 <apopple@nvidia.com>, adhavan Srinivasan <maddy@linux.ibm.com>, Nicholas
 Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Felix Kuehling
 <Felix.Kuehling@amd.com>, Alex Deucher <alexander.deucher@amd.com>,
 Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, Lyude Paul <lyude@redhat.com>,
 Danilo Krummrich <dakr@kernel.org>, David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>, Leon
 Romanovsky <leon@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Balbir Singh
 <balbirs@nvidia.com>, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 nouveau@lists.freedesktop.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
Subject: Re: [PATCH v5 1/5] mm/zone_device: Reinitialize large zone device
 private folios
Message-Id: <20260114190154.c05e460ebf4054828430633f@linux-foundation.org>
In-Reply-To: <20260114192111.1267147-2-francois.dugast@intel.com>
References: <20260114192111.1267147-1-francois.dugast@intel.com>
	<20260114192111.1267147-2-francois.dugast@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EC0011C0006
X-Rspam-User: 
X-Stat-Signature: 39x9194quyngaz34cde9eqfx381himo6
X-HE-Tag: 1768446116-797156
X-HE-Meta: U2FsdGVkX1+l4RPpPzuwl+QB3ALfnGuv0fuClq6/Ene2q1vgJQhzCyNbLnm4Q+s/E+G3gVLYulBMfvY3JMtOWEiDGtH99Yh1Y+UJfbiSArourjcXVTlrHQySw5Nm30GSM+KojKRnfeRhiQlS8UOdnDK8vjk5aVOWt6jDXkCZDbmtwLRlutaCD8HyuSMElKlTBi+mQC8YTI3eiEJZiNSfmOC09rvXQw22DagDFhdF5UtbdAlOZJ+3iU1wz9DmCQ9vmu9cv9xW46exukjcLcvd0E8ViaXPo0av8vsiTk27EHdWVNogBXKOtLE9r5Kwq/+IOsQnX3YXj48u54Gu3IAgdoXk4W6J6vQvRv3A8FAKPJgqVEA0LaZzL/sx+pwgPILU2nuD51bu0dek+RNOoP2JWfscMBdYBS7zh2xFcrpWlLyG4s22zqLPCGJhiAewgP3imqZAP0LE9dtG3uX7jBXWLkHX+23xKd3d+Ycd1xtEpoRMjjJxugYcXqa35eyFO8HfRqa6PgyUEsvkeC5Z510wNF7i9WkrWxchE5Twndm0Z6jNvJJYqdh5lOvQoH3d8Pte9xGCMwlwSfdccyLdiZflIuLPqgtDMKyN50Ih1Zb1X8dsC6vCSeMb9xTnc7iviV5J8oJ+dHDHXLcNfa3bMRaH2Jca/Ld9ngvdOgqzn612dDm9pUXnJA3k7ITDX0ILmQVb5y/LvNaWWTP7DG+z2TTItS49j/Z4NxmiD4mJ92S0r3Ou38nnmJdGe4t6xJnhbRQvooqm7oj+hqSy61K7DaCBB54NkUx3oLzjPUM+V6iYeZyxexEu3MnPZC83orbfVxKODpapiRJ9NW/EObffZtzLVnuA8qPJsrxVAIoRMNVCBl2vu+46uiMlmofDh8pBrtrxz59RKv/QP/ALAar/OBKyU/o/FttqrpH4Ll79yW/jMRjhsImT+zqEC3xjuc/MW3Lwf9K5gfpgrMItP5KRTSj
 JFVbotZd
 pF5hLbpS5foW7AvyiU81k9vu9PO0Q4HanP+qiOJOQT4jXbcNtwO4kMctCiN9zvvMr+UfZk/SNzlWcjW8MRAM6wGlIWxsFSXjTc4GBQUAODn5oCPmtPos5fdrczlGetsffeDCao/IUj2z10bgdETL7YucIvUpPtVbkp/d4ScKKSRnnVH6A5tbcwujLmCfYZZmJ6QKSyb7DJ4xZ6ovYnQxJaIFexeQFeqqpxDx82/L6fqRGCawGG5TlrqGcAImTdFE5iz2jOlD9jGoGcO1805Jh7+fuXtBD5HT4c3u6tamqLW3WhWXFbsczP5NdAMxYyPtTLGYo86o2sFVX9oci2IXPQ43eXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 20:19:52 +0100 Francois Dugast <francois.dugast@intel.com> wrote:

> From: Matthew Brost <matthew.brost@intel.com>
> 
> Reinitialize metadata for large zone device private folios in
> zone_device_page_init prior to creating a higher-order zone device
> private folio. This step is necessary when the folio’s order changes
> dynamically between zone_device_page_init calls to avoid building a
> corrupt folio. As part of the metadata reinitialization, the dev_pagemap
> must be passed in from the caller because the pgmap stored in the folio
> page may have been overwritten with a compound head.
> 
> --- a/drivers/gpu/drm/drm_pagemap.c
> +++ b/drivers/gpu/drm/drm_pagemap.c
> @@ -201,7 +201,7 @@ static void drm_pagemap_get_devmem_page(struct page *page,
>  					struct drm_pagemap_zdd *zdd)
>  {
>  	page->zone_device_data = drm_pagemap_zdd_get(zdd);
> -	zone_device_page_init(page, 0);
> +	zone_device_page_init(page, zdd->dpagemap->pagemap, 0);
>  }

drivers/gpu/drm/drm_pagemap.c:200:40: error: 'struct drm_pagemap_zdd' has no member named 'dpagemap'

I guess this was accidentally fixed in a later patch?

Please let's decide whether to fast-track the [1/N] fix into mainline
and if so, prepare something which compiles!

