Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E7AEC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 06:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B38AE6B007B; Fri, 24 Jul 2026 02:10:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F276B0088; Fri, 24 Jul 2026 02:10:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25986B008C; Fri, 24 Jul 2026 02:10:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78C166B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 02:10:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01ED512029A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:10:51 +0000 (UTC)
X-FDA: 85022646744.08.90535FA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 99DC780006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:10:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="HU/a7MTW";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784873448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lXb99Tnv57pcrI8S5LLsibaYJImwUhZe8y5wxuPa8eE=;
	b=BS7FLjJY9mh1aaFxcnYZp4EXGE1jy9oxuH+DfclAxoAxlc7t4Cnw7ldD/4Xc+Y+Qh+QNr6
	EX4S3QlD7zjC2orjCR4s9DoclXPiKRxkvk8Ci8kFZAQkHP6sRG96pnwIR9KshddCXof5zo
	sSwiGJNDmHyvxNpfLkUsBhGJETzv/aw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="HU/a7MTW";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784873448;
	b=UQbVll00Mfy6a1h7EdkUPRysVknil3+T0BUbc7r51crLb76ZZ66qwWwz3FOUzwcJT+MS0u
	dicCjwDYgDwN0rcB97+09vTHj3oG5FuxWf0Rs1sxjLHgo5yl44N1PyFuGfLLbeHiqEZSoN
	QJ7qpgcdKLDqVObJq49K70LvmEVN8i8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 058041477;
	Thu, 23 Jul 2026 23:10:42 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DCA483F66F;
	Thu, 23 Jul 2026 23:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784873446; bh=J96VFyk9PGn8YyeTGzVOaRpj+S3LUu9gshct9gb/QeQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HU/a7MTWgbwkE3Cn0OZG0UUhbr8qMmr+Tpq7RykHBoVU17RtBX2K47oKjYS78Tand
	 uYU406QHXG4sRORMa/qI7Xvc7yLjwhocEVFRj4T7jCv4zOwmg+jSSFkOmgh7hylKcy
	 VMBln1PeS4uylznX5Yn8k0iWLilj/famGa4IywEE=
Message-ID: <a3f9dba0-8ec9-413e-82a2-75f4f90911c7@arm.com>
Date: Fri, 24 Jul 2026 11:40:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/11] mm: add PMD swap entry detection support
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com, Baoquan He <baoquan.he@linux.dev>,
 willy@infradead.org, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org,
 baohua@kernel.org, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, kernel-team@meta.com
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-2-usama.arif@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260722152043.2273289-2-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99DC780006
X-Rspam-User: 
X-Stat-Signature: kfhbp51qu48s8ut34y3y8t4zjr69czb5
X-HE-Tag: 1784873447-46035
X-HE-Meta: U2FsdGVkX18uNDXbaQEbuJbluiVLlwiV+Sp+LUMPAgx0q5Qh7tLf6NErRw6MBhb1iMz2eQyQ3LAkI5j0lPUPiKZKlPD5mFPY5rksWrhHwm9CsgjIcS0U4MGgysFBM7Z6USQuRy28IxdKk3tlATqOM4xJxCpTzIhibRSkDSzT+tFXPhDbq/MZfiHfxJ22ZI3FbxsIm3mGm1OAoIeOnsIlvznYU2AwsYIKzYmmFmkaX9xPyv+f/XKKBSIdYUarAVhXYo2m2+/KQ2fkOvzXBTv2MuV3/U+JoJFG/EQxLxlS+8g3kwYKYVm5XzgUe4U2m3YrUt/87Zud52icJ/9F3/b9Iwji+8UUIO+ktGc7T8/p2AYRLmfUdukXRpJzEMD/ZQ8SsvJDaxZAnw5x5Wfc43KW2XA1YnTkJQNOSLqkHeExfcaLW+VmU0GUd+n96e4XDPHyphD0xTqPrG9MA7qB69WTsXmpJXpcucRjmbWAQJChMbAgNNJl973lMRKFk2Rdmm+RGApuBTee/l/Gv9eS/qUtpLmvblUQDZsW7zk9cv2UvPMdakkn0AE0/InwN/ZkIRrtBviO10Sq9tRdjyazrmgaCswEaeI2G2CTuT1xKZUka3OX7gzDwMofGx7IBNfHtxyRT+6OCGchCo0YXM83oTOp6NIrx7r3/8gpQmUorOR764lWQryjSo9EZsrJAuV8rhi4LMLuAWG0QGnRXUuMxUYHIS4JC8J3qcPscgdF8yMNpbi/WXyJbYOa7XsQSHKYPxBoG1pSBv20MndA/TtTw/sWBLeb6+oSLG337HEVbvIf/btq4drK98EWf1YQAamZuMStaa0gjTvp+3TAo03eet7S1yRNufdVqIYRXpg4vdHZIFf1OU2B8uG/RePVbreQSrfpM/yL2JUVusQJX668rmC7gtqpNye5bmcDyjp584Qy1oI6gE5XIqvwClDot6ONS6TfV/0iN1XMpkAr1cbNQvX
 DyyokLpi
 q+6uJSLYcIUDc7QakwME3I+cqX+U3PtweN0DXFnsda8XMcImaTr5L5cuEMh8HsVchbxfBM084KT83Jnya9wJeX1O1H2tHBJAoIJx8WeNXVGPl1WZzIneRHACtMaDRH27SBkjzw5aZJuhE/MhWCGswSXzqwGyWhnw3e7h+c3y4fRsKVkM4KRUqu0gmRJLLUKEj8QoWPb2Qu8YM3D+nqnSStuc6EEPm6b6QBg0uhKTy36RrjDM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[------]

> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> index 4c1476ae3234..8397193ba399 100644
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -102,6 +102,8 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
>  		pmd = pmd_swp_clear_soft_dirty(pmd);
>  	if (pmd_swp_uffd(pmd))
>  		pmd = pmd_swp_clear_uffd(pmd);
> +	if (pmd_swp_exclusive(pmd))
> +		pmd = pmd_swp_clear_exclusive(pmd);
>  	arch_entry = __pmd_to_swp_entry(pmd);
>  
>  	/* Temporary until swp_entry_t eliminated. */
> @@ -634,18 +636,30 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
>   */
>  static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
>  {
> -	/* Only device private, migration entries valid for PMD. */
> +	/* Device private, migration, and swap entries valid for PMD. */
>  	return softleaf_is_device_private(entry) ||
> -		softleaf_is_migration(entry);
> +		softleaf_is_migration(entry) ||
> +		softleaf_is_swap(entry);
> +}
> +
> +/**
> + * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
> + * @pmd: PMD entry.
> + *
> + * Returns: true if the PMD encodes a swap entry, otherwise false.
> + */
> +static inline bool pmd_is_swap_entry(pmd_t pmd)
> +{
> +	return softleaf_is_swap(softleaf_from_pmd(pmd));
>  }
>  
>  /**
>   * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
>   * @pmd: PMD entry.
>   *
> - * PMD leaf entries are valid only if they are device private or migration
> - * entries. This function asserts that a PMD leaf entry is valid in this
> - * respect.
> + * PMD leaf entries are valid only if they are device private, migration,
> + * or swap entries. This function asserts that a PMD leaf entry is valid
> + * in this respect.
>   *
>   * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
>   */
> @@ -673,6 +687,8 @@ static inline struct folio *pmd_to_softleaf_folio(pmd_t pmd)

Nit: This function really should have been named "softleaf_pmd_to_folio", or
"pmd_softleaf_to_folio", perhaps throw in a patch to rename?


>  		VM_WARN_ON_ONCE(true);
>  		return NULL;
>  	}
> +	if (!softleaf_has_pfn(entry))
> +		return NULL;

I am guessing that after the later patches add swp support, we should
never reach pmd_to_softleaf_folio() with a swap entry, in which case,
we could add a WARN_ON_ONCE() here. (didn't check if you have done that
later, just writing this here)

>  	return softleaf_to_folio(entry);
>  }
>  
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 8c093c119e5a..e10a7e91e426 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1917,6 +1917,23 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
>  }
>  #endif
>  
> +#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
> +static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
> +{
> +	return pmd;
> +}
> +
> +static inline bool pmd_swp_exclusive(pmd_t pmd)
> +{
> +	return false;
> +}
> +
> +static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
> +{
> +	return pmd;
> +}
> +#endif
> +
>  #ifndef __HAVE_PFNMAP_TRACKING
>  /*
>   * Interfaces that can be used by architecture code to keep track of


