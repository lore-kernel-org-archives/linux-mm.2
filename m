Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC82CCA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 17:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DD598E0023; Wed, 20 Aug 2025 13:44:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B4C88E000B; Wed, 20 Aug 2025 13:44:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F19A8E0023; Wed, 20 Aug 2025 13:44:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBD78E000B
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 13:44:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B8E7EC05FF
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:44:24 +0000 (UTC)
X-FDA: 83797860048.01.548179F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf02.hostedemail.com (Postfix) with ESMTP id E29A380005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 17:44:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0bnL8T2y
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755711863; a=rsa-sha256;
	cv=none;
	b=stW0nrfOjUtQIMOj2/5pDy1z+2F3EWacM8WDzTPkFJXE6JZww6Hfp+OZ3SIizgJQP/Ax9l
	c+vDN0B3KxobJlhkXZ3gk47Xhcio3dH4AAT+cwsTP/BSjIjSQaSOC8N23OkPjWrXaDMgMT
	CujYFXvpo8KEA0jyxfGtSRTQnbrKS4U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0bnL8T2y;
	dmarc=none;
	spf=none (imf02.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755711863;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YxAG2wevlF9hvSfOpG1gi4gKf2kHDvkSjadttXruPpE=;
	b=6DslC4cIXipL7vO8bTNjejFf9KJidXPVUzlNHVm6UL6I9I8FP37Ew/cWsFASW1uWK1qYQt
	Ve1Qzp+mE/zmEyI+PJwMNhSytxyz3QT9NHL8h61hsl/7K8bProW1jmUAJK6Y+pDoRh1BiD
	32fVYB2V7QHDB2Ywrih1XRKfsCs589M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=YxAG2wevlF9hvSfOpG1gi4gKf2kHDvkSjadttXruPpE=; b=0bnL8T2ybDOrHa+Py3KB+20XsQ
	krFSkRJ/lGSHI9KlQ0qlkdhK+qS23YBluLAvVOyoBvbJO/SbTCQXDRBwJo0tZ+Cp1m4DSS1z7XGDT
	bq75CSkTotCMGqtD4tBJ7i8YIpE632ix5UOtckpT48GQey1yMweypKEPi1eouIUYb+w6RTQ0TeOYI
	wwoHU5dIl+eMuf1/t1xis+rSnKTjBKynLeo+mDeoVyVPXnDdZUOyF4W1BgoI2zlm/SJELWzpgpvX9
	8tvSWxDqv45x4EHLAoK02HGSqLAaZNADQVCvJUVy3JC9HhNc1ybuyAFZufFH2NHAbbXOxL6igBxc6
	4N59ti0g==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uomrD-0000000Eaag-3xcU;
	Wed, 20 Aug 2025 17:44:20 +0000
Message-ID: <a68bf620-14b5-4500-8cb9-26a7b28af058@infradead.org>
Date: Wed, 20 Aug 2025 10:44:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/8] lib: Support
 ARCH_HAS_CPU_CACHE_INVALIDATE_MEMREGION
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Catalin Marinas <catalin.marinas@arm.com>, james.morse@arm.com,
 linux-cxl@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-acpi@vger.kernel.org, linux-arch@vger.kernel.org, linux-mm@kvack.org,
 Will Deacon <will@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
 Davidlohr Bueso <dave@stgolabs.net>, "H . Peter Anvin" <hpa@zytor.com>,
 Peter Zijlstra <peterz@infradead.org>
Cc: Yicong Yang <yangyicong@huawei.com>, linuxarm@huawei.com,
 Yushan Wang <wangyushan12@huawei.com>,
 Lorenzo Pieralisi <lpieralisi@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 Andy Lutomirski <luto@kernel.org>
References: <20250820102950.175065-1-Jonathan.Cameron@huawei.com>
 <20250820102950.175065-4-Jonathan.Cameron@huawei.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20250820102950.175065-4-Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E29A380005
X-Stat-Signature: 365u65jo1noi1e3rk3ynmzhronqzgq3w
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755711862-187456
X-HE-Meta: U2FsdGVkX1+30sglEbejROau7qjvxN9+ff66UAryhi59H/PUwR33NLTFKj3ze2e9vXHuZ1LevE3qjXvyJzXeFh0IHOBFKIBEmZszoT3JIBjpPkasiyeSjc2ti3Aeygidtw5lH0YrMl6ERBCOmOOCN2qWhh3jMe22GA6yVllQs8XCDob7xMP6pBbsXrVTGR1Aex1wOxjxJ8bcJeQzOBnsSbpwTk1wGV6tGLZOHhbEOFXARjVgV7i/M/WT8bpXWifd5sm5W067LYdA63ubKKAvi3/Yrltk2zgYSvOrtrCVRsOQacnt4TT94I4TeAmS22RD7pB2NQLp8ZBLK1UE0AmUQZy50tOowyc9l2m5vtDwgFcgs6a8ofWlZHdhyoUuPeq532npkXZaj0L4s6kFYgeoYFYGuKu8qPduU2qJI8+gbokrLmdHRowNtQvcbotjKJ+a0OQdo81nU324M57tDJ8ahGNxh95GE7Dv3C8IT12rY9LrExXJq7ENrgEfb9giVXhu/7w5rfiiwsx6b0jXtvEFs5Iok5/3PY1wJJX/FVpxp0dE62PszBSDk9KJyvWre1kcj+zMQiY1FldFkRXEXNytC+Dvq3cTXs40NIkDf1JkW+Cy5t2X0E9PaBhaOO91gZNgVgwFWqHLa42Ph/pV7/P+xDwfulkwoGHMpfqz2JLWCsqrXNXNJwjODaEQcNbTiBKatYoqorSEnk+T3JpxpmFMsB+1Q8qAISRCxXWXNWLK+8MoEpWi3aFVyDw2zWaDfwVj7l5Y+6zjSyQCqNMxYaSSE2GVwJ5ITJYVDoPSFhB92AM9OEl9VcSutTEjo8ZBuxYWSs8aS5x6QnqtOkHCuEZ/VL09ZrGimqIePxd6sFADCvewoCk5nWjFrgdrM5GULBicSPpVDiSw6b2w9evN6by46R58I+y5wpHuO1VTtyukHNXvVoOcFyBe+Se77X7GSG40WdCMXgHX1VEzdd1vFrH
 7j6yNnNW
 g55FJzm/vDAw/Bv6LC6skfQGpaHQClFAK7eW903T/+xMnK5GcYEginrR1TGMud0CuNoNILOPyVZV2w7yQCncXVtRD/kiY2ZzvVwgdGYCrMFeR4Gd/XxaGEPC5d8FEULpkQ4Ck0Lq2Gj7zsQcDyJw2PzpaHtqrgpnO+Jq/dL4M07PyUqzj0zF59HpgaECr2isdtUaFe3EbMRNcpbK+Wb03q3Hn15sKCu8u1cYnecWB0DBQJSNoerabEvQyy7gYkpTPTmV/RuVLPiApZ40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/20/25 3:29 AM, Jonathan Cameron wrote:
> +struct cache_coherency_device *
> +_cache_coherency_device_alloc(const struct coherency_ops *ops, size_t size);
> +/**
> + * cache_coherency_device_alloc - Allocate a cache coherency device
> + * @ops: Cache maintenance operations
> + * @drv_struct: structure that contains the struct cache_coherency_device
> + * @member: Name of the struct cache_coherency_device member in @drv_struct.
> + *
> + * This allocates and initializes the cache_coherency_device embedded in the
> + * drv_struct. Upon success the pointer must be freed via
> + * cache_coherency_device_free().
> + *
> + * Returns a 'drv_struct \*' on success, NULL on error.

Preferably:

 * Returns: a &drv_struct * on success, %NULL on error.


> + */
> +#define cache_coherency_device_alloc(ops, drv_struct, member)	    \
> +	({								    \
> +		static_assert(__same_type(struct cache_coherency_device,    \
> +					  ((drv_struct *)NULL)->member));   \
> +		static_assert(offsetof(drv_struct, member) == 0);	    \
> +		(drv_struct *)_cache_coherency_device_alloc(ops,	    \
> +			sizeof(drv_struct));				    \
> +	})
> +void cache_coherency_device_free(struct cache_coherency_device *ccd);
> +
> +#endif

-- 
~Randy


