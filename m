Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1444CCFA13
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 19:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE9068E0003; Thu,  6 Nov 2025 14:50:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9A8B8E0002; Thu,  6 Nov 2025 14:50:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C896E8E0003; Thu,  6 Nov 2025 14:50:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B501D8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 14:50:21 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 24B544AE8F
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:50:21 +0000 (UTC)
X-FDA: 84081223842.03.2964D99
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B3E94000A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 19:50:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0S5PF1s7;
	spf=none (imf07.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762458619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TZQw23ttLoTVA2bBH5a8WLwflYyR1wSU2x8Igu6ImY8=;
	b=JIcAtEvsM9b0QackQ2gU/aVomAXpXLqb1AifK/OokwimHeazaVaRotfpqhzeHF+C+Np+QP
	IV6KcB90xEaPlmUMh1+Y3HrXme/xmdISZKvDL54/+SY9G8RO85cd76/QeL7VkOJ+GOVOfO
	kAXon6ZS7PR0ewgyIDsx34qKe0kkGbo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=0S5PF1s7;
	spf=none (imf07.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762458619; a=rsa-sha256;
	cv=none;
	b=PreUeXuC4TsoTeaLMANFP6OR2AXNvwM2YnhY+Mam5jJcdcNzxbhxX5GTAtlCL6yH6+2XqW
	QqjJWcnfKpO+bqZUA73tOu6p3gvoavZLOB+xcWsIZdPntGBSKxiR5Tqk4etTyfalvBuIKb
	Y4WF0OrJxRZm8vILqCu/n6DsMZGIk2Y=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=TZQw23ttLoTVA2bBH5a8WLwflYyR1wSU2x8Igu6ImY8=; b=0S5PF1s7Z3+3+S6pQIKmCqY0jP
	drS+pA0q9aVjtmISaobTvzTl1jkOZSfzgOc92RcJr0DRdkWda9yrlj0uSCAAF0rOy8SFZ6Wk+v498
	GrwMCgA0Gf+XAwNNlx54m4zqyFG/N7iMaEW/G6riJ7FFy3GWOwUV9g7sQybKR0y9Kt5gUcIhw2gpK
	ezbUCFqCKnkr7z4pC/vUOfLdfx7HR+Dj3EP21Gmv54rSN/gEygFVeTQjMtzVLJ+COODhPItpH40Ac
	aLZabhu3/6JZ+AyPJlobFEVROiucfiI7QysjlT2LBC6b1c6f3mb7jfWjLZ5wUhhxLYtaPCUITJpJM
	p/UkTvCw==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vH5zn-0000000GBF5-3TGi;
	Thu, 06 Nov 2025 19:50:11 +0000
Message-ID: <55391dad-339b-47f8-8996-afe337b238e0@infradead.org>
Date: Thu, 6 Nov 2025 11:50:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/4] drivers/iommu: Add page_ext for
 IOMMU_DEBUG_PAGEALLOC
To: Mostafa Saleh <smostafa@google.com>, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com,
 akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 rppt@kernel.org, Qinxin Xia <xiaqinxin@huawei.com>
References: <20251106163953.1971067-1-smostafa@google.com>
 <20251106163953.1971067-2-smostafa@google.com>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20251106163953.1971067-2-smostafa@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B3E94000A
X-Stat-Signature: xg7w74wa4pdqxngyqzmb5kkp855enjnx
X-Rspam-User: 
X-HE-Tag: 1762458618-115855
X-HE-Meta: U2FsdGVkX1/o+3we6PJliVSIptHUYqZaMtB8SFQkmk1bM8la1iO77U9fK2kbJR7svsQo1Hs7wbV8U+8XDE/7Unh4O4ctmKxtP7RGRb8rxexzh3dmTghhKsWmnSVGZWS/7ZctuBnQHEpAskVI2jS0iXUfT2UPsTbuUQlQ/nzHQPfsQpmT4QiKw1cWAB2unEAkB4xHuapSQ+gTqPGcZWDJDtQ//D9/8PopTxAv3/jVcqs0kGcK4Uelv+SF7pgCIT27Nz7NH+z+OXP0Ri7WGQBAe+8zLVZ6R6f4uG9wD3tj9NLw5MIR7kWEZcagWFJS/p/dS9oIhQEVyMd0f3AInJM/zNALqcK3X3SJ7WapYaV16oBiWSzv7EpKhlDctq/+vKOe1/iANeZKEEXbCeJL2/F8CVlafI9mi6rpm7+vu28H0vHApbwr9PyxQGGq8WIVDzwFHyFIOS4CmAZTJe3+W1qJBz1Q6idJpbUBfe9leYpFKEnEhI2RY9tWua6v171cdKXlIxatRk0oPVnj3/AwtquiMOVJlIeRYElXb9QsnzICIOCeyw+BOvGg8kfFZSEB4YYealjttwrKARf31sMCCDR9RAbU1Mbvu0wTvraP/jAJI2EUVNoAdUn8AoNF0+CTDDrO+UDhLFwJwqmP2yoIXaklL48MNDxgzm8Mr9oWyTBi3EGv2m8S4Rt9MCqqmjlMKl6IMXqsFVeW2Ca8PWw0CX7BnXd2LDDKnV7o9wCRZGc+4+cR0mrqXWiNvc/cYgByF+JURll5iJQLNhRDYvDoLNrgrInNFA7WajBfctT/vCu0rleVb1CV+cvfFRpmTkwmLbAXSH8aKhDmBdSrTH7pCga/rWzumu4kzBW3elsi8E+ydlbbd4Wi3tXvHTQDVgcif/JlvMRSQhiAlY7ESiIF2jvdDeAc0ro/AY12+HAoE2CAxuG6H5aylr8wrCxjaOsyLGeEeoIqZUwirAJ3jtqblMx
 29hX6MGW
 WvuoDdL3ivi+AWnxo5IYd66ek2fg4JrYrmbM5EQ7/ETxNeKDIhk59tjGe1p/ywUMHUbImE5C4RGUphrmRZlb0ajtlbXHuLMpj3bJt/d+Oi3Dbq8mJpQkoACuuufstc3+A8cORsv640odV7PW+N0tb+NyMAsQCbR6XAgxT2wsomFUWajXvuAM8s/1gegRxlgb03V1nyZPkUZDkpp1oQq2IX2COBpAfibe6nBkkJFIrqQj1dFZzOjnY0AmtJejkTOroXoPeoQi5EwNDen8qF71d/U1E8AQs18wj/dbIV9r7zctH8LOIQXMEzb8xKHKTnN42/2knNqDYCj67F3pXGHvjnylERQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
> index 70d29b14d851..6b5e9a2d936a 100644
> --- a/drivers/iommu/Kconfig
> +++ b/drivers/iommu/Kconfig
> @@ -383,4 +383,19 @@ config SPRD_IOMMU
>  
>  	  Say Y here if you want to use the multimedia devices listed above.
>  
> +config IOMMU_DEBUG_PAGEALLOC
> +	bool "Debug page memory allocations against IOMMU"
> +	depends on DEBUG_PAGEALLOC && IOMMU_API && PAGE_EXTENSION
> +	help
> +	  This config checks that a page is freed(unmapped) or mapped by the
> +	  kernel is not mapped in any IOMMU domain. It can help with debugging
> +	  use-after-free or out-of-bound maps from drivers doing DMA through
> +	  the IOMMU API.
> +	  This santaizer can have false-negative cases where some problems

	       sanitizer

> +	  won't be detected.
> +	  Expect overhead when enabling this and enabling the kernel command
> +	  line iommu.debug_pagealloc.
> +
> +	  If unsure, say N here.
> +
>  endif # IOMMU_SUPPORT


-- 
~Randy


