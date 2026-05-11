Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39C9CCD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 18:26:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B9A26B0005; Mon, 11 May 2026 14:26:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56A786B008C; Mon, 11 May 2026 14:26:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47FEA6B0092; Mon, 11 May 2026 14:26:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37A056B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:26:41 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9C7D14025F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:26:40 +0000 (UTC)
X-FDA: 84755969760.27.F88687B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1EE9780011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 18:26:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M4QdrK9j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778523999; a=rsa-sha256;
	cv=none;
	b=vEaOFJq1odX3HvpTSwlFNqWzIE5oRLyHZwYc/ZUaDK/zwWPcajRz+qAzEKgxUlOmmgPo98
	i9EjaCyYeKU6ZTY90t4eh6tXzPKbZbIDPvpZcFTVOPt8lI8H8wkvZfb21ojSm2uizSrOAf
	RsHbGSC6JqMTq4aIgCjdmf52stp6Fgs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M4QdrK9j;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778523999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lgtg2QDgkd7bffpdNe5qS2myb61Nh7NkkYvhHjSH9Aw=;
	b=vBvynS21uhnl4VYZUD22wt87Np2GUkZFq7rQUETlWXjW+cL5Ts7nVO+cz6COJkIHOumiPD
	10DzTKpHIVxZ711BZUXM4T96FSm98XDLu3e59oJeLKUXN2k9m9cM7ZMeFIpyRAYHhGaG9L
	pY0fKJhj0+h1wSD/CMalELRwsTrvL54=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12FB840684;
	Mon, 11 May 2026 18:26:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA26C2BCB0;
	Mon, 11 May 2026 18:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778523997;
	bh=F4yALa9/mbx93iXUR1lV9RhmDxIVOyP5f3cddxveM0o=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=M4QdrK9j7KL5ewkhJdjg3PFODsbRCUkpQlbz4xIVSd8cSmlJNYYY/e6UsBDawFvni
	 ft/BdUiSlweokt9yWedK+FWhXxkPs268g1yanFRM98Krgf8Zohc43lEqGmEsRWFX6Y
	 92uBrEMqWXVt5tFnYzm9mdGDzHneUjc90XCY4aoq3SLeBX6SUqe//A6iQjaMwOFTmB
	 uPOEciT/tppboWfsgqgIEgguUiKbHO7q3vsnjCkOmr+Uw9xsYnLzPkl5yTU5f0St2o
	 9QavZdDUdOVHxMBkMrMQlfYQk8N789j0JAhru4QCqAYbpryDxZLzkUTcXs3aSQVpPG
	 QMMu4kIL2PfVg==
Message-ID: <00d11da5-437e-4f3a-88cf-66ab0a729cd1@kernel.org>
Date: Mon, 11 May 2026 20:26:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/22] mm: introduce freetype_t
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, patrick.roy@linux.dev,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski
 <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: iagnj18d5jam5i15i7br15jd7mftnoct
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EE9780011
X-Rspamd-Server: rspam07
X-HE-Tag: 1778523998-182833
X-HE-Meta: U2FsdGVkX19jcMZ8R5Sj0CpvZXZGYTFvgbGJBZlsyn4tG3hVCWPWqt/4DOGii9j7iLX9RABETPnsF9hkRrYW3ABmQcUOBTMmD4hoTotlsBqlY2vpQjqkA3JKdZ7JkaAIjH/s8AhP6LU3BnmsSBhCnJ0jwkr/DRrBLOzMV/HEBVIthDqJp9KzczURjXaNILgjCFkS5EhCg5GH4x1RRG6FE0aeNb4jAfuu9ZxH4tCltKu60U/w3LpVjhISgMXAO3vPnPxcPMlMfAV94wPedxAEqaIGXan7GXNEC/EylJUpUhRxAZgjvqZflEbe1vDGMJhYOSPbjJLWEk8NRskbMbpU0LkffeHhxrkhzm3quckfzmt7CqnZrQ5BABDeX06zsEzcvVkM7Rs7SyQnqXi5VZbXBhx+2OdzmXTR3cFb4d7BOzJTxxqdiEI5Kx7sXZBbzvJMcQQNYDb5XRKOpdLYy8xWI7InZbH2Py/NEN84lNFVjEHWVtfiUvl/CoM94Xxo6ljYwVHNfnqGJTWgI5i6G5OnJRbEsZaisRDEKM8bgEI2/Qhc0drL5jLRSsj9jKwp1742QypL6W+psbj8ZB2y7jhYmNeOq2JUyvF4ZXbI8TfIk/8UecJ+KPf9RMOpajlZ66CmEj1Lv+yFsP4Sg6T6nIfOKVKHRYXi9iVvL1whx+LN+53M2PXN3LwMp0u/X6xrSL/XxIeVFxwTXaUtME1iPOyvb5hT3Vk5/0x38adPno4GL3ytl3tbzMmnIrBdkMdg5Sc3TS6WHTaIvhPT7bZ3vvSnSU2qwXSUKgiTkAAJbB2GNkaZSBv5erKekXFZ0CPIb6kIEhDX+y2lPRBElw9CFsv6Bl29SwyWXxoNUqAzopYYi2uTAJIPCCBhDlKTMx+xPki6sz4/p/cr+jc1F7vzkVJIr3JiPIUWjiPfVhyqasVw0gFs5xRLTfKu3+ESO+h4mAerGfz5vTqW7is7MXuG2mW
 mwg3Je18
 DDkyF5PXXpwVnE2FzdcPxZgLoHOTqbJITMc+Yl63ORW+32JqwE+aeTYYEYZ0ViheRF4C9BoWd0iATb+XxuXvXq5d1EfxJ9jwrX632X1sFL60QQS3XIEDTE6+VbowfDA02HfRrY5jirqrl9LrrPU/m5poxyZmnZBQbUkePZ5aiyNsLDBDO7i4SEPd84B64Mf650eRwobHbcKnO/JkXrFgTOKBgNQifLkSSbCry8q5HvmuA1GIb/HEloZBlTaIEab9o1HizClG3G0UW9RTrqc6ZmpVJ8biubDkblmIc+CbCWOW8X536wMBsYmaM2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/20/26 19:23, Brendan Jackman wrote:
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -422,6 +422,37 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
>  	return test_bit(bitidx + pb_bit, bitmap_word);
>  }
>  
> +/**
> + * __get_pfnblock_freetype - Return the freetype of a pageblock, optionally
> + * ignoring the fact that it's currently isolated.
> + * @page: The page within the block of interest
> + * @pfn: The target page frame number
> + * @ignore_iso: If isolated, return the migratetype that the block had before
> + *              isolation.
> + */
> +__always_inline freetype_t
> +__get_pfnblock_freetype(const struct page *page, unsigned long pfn,
> +			bool ignore_iso)

Hm I also noticed ignore_iso is ... ignored until later patch.

> +{
> +	int mt = get_pfnblock_migratetype(page, pfn);
> +
> +	return migrate_to_freetype(mt, 0);
> +}
> +
> +/**
> + * get_pfnblock_migratetype - Return the freetype of a pageblock
> + * @page: The page within the block of interest
> + * @pfn: The target page frame number
> + *
> + * Return: The freetype of the pageblock
> + */
> +__always_inline freetype_t
> +get_pfnblock_freetype(const struct page *page, unsigned long pfn)
> +{
> +	return __get_pfnblock_freetype(page, pfn, 0);

And here it passes 0 to bool.

> +}
> +
> +

