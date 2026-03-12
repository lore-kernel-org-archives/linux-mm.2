Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E698106705A
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 15:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45E096B0005; Thu, 12 Mar 2026 11:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40BB46B0089; Thu, 12 Mar 2026 11:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EDA96B008A; Thu, 12 Mar 2026 11:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1516B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:53:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AABC8B7A90
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:53:26 +0000 (UTC)
X-FDA: 84537855612.27.56E64A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id CCA10140007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 15:53:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d8lFNpuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773330805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QQ3LjaRmVTzt1sd/4FgixfTncgJyPQYJIahrPuld1Og=;
	b=5VSEMi99JXF2btB4b9fIoar8946QUffRfowDcmsYqPG4LKN8jtT9SjAU96Adxu/OnsPCO2
	mgx9pKsrWYIE3VaoNPFvXLg9DJp0+e/tZcHaZEd7D8h8rZHvmlnWh4iOTev+Rf7t9eMOKt
	MaEDFLYfv+OzBJgCKr4czXmhdROVj5s=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=d8lFNpuT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773330805; a=rsa-sha256;
	cv=none;
	b=I3hlpEzDdkODxdQNYuTgVT2NReS/+0RnCe4ShFLMygtRXpxtiu6Nl8B7t3QC8Q4eCXvYm6
	Kl/z73Ryni6SIsg0fR2YRE3/T8qkqMjbsqkbkcMzluBImMwZMmuhFhjCL/O1D5STyYBUC0
	lu3WWMEJuRleyp7WPxbqCRHtXho4gug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A22CC44085;
	Thu, 12 Mar 2026 15:53:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690D5C4CEF7;
	Thu, 12 Mar 2026 15:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773330803;
	bh=narsuI8QHu8jwbyWEKrAT/NVxEMQP93/0vn0hBb11cw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=d8lFNpuTJVK5h3GzJ7vhWy0sRKr2WIQJn0BngvBlY3yHXQs76cf8hC7kojjfBRmod
	 hrh86WXbahlTH18zBuE3NTU53rUK4PkgHi2ZJLeBSd6V+7M+x9XLRNlfqI7RUiS2Ef
	 GK5hesIXPnF52dCQphPuyBL5s89rhL5RBYPObwpffTiPqnC7D37FDTKz437WVz/19q
	 /9yRGIr7wuhaU9ZzI6jwSWpZTsf4cpoCagAwt9GlyUWfLtKYDrgV0Zh3jX2nV8o4cQ
	 qGeRo2gseZDA0W3TYiTgdRmNnNPtam5w94uxUjIAfp4ATEOP3/dHZuU9Ao2ou5CQXk
	 tvmpv+X7uIpAA==
Message-ID: <bca4ea00-3052-425b-8f39-729d504fd4db@kernel.org>
Date: Thu, 12 Mar 2026 16:53:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] huge_mm: add stubs for THP-disabled configs
To: WANG Rui <r@hev.cc>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>,
 Christian Brauner <brauner@kernel.org>, Dev Jain <dev.jain@arm.com>,
 Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260310031138.509730-1-r@hev.cc>
 <20260310031138.509730-2-r@hev.cc>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260310031138.509730-2-r@hev.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CCA10140007
X-Stat-Signature: y4fbkedp1urtsxi8ajrh3ymeswam8tse
X-Rspam-User: 
X-HE-Tag: 1773330804-452888
X-HE-Meta: U2FsdGVkX1/Q8NRZVfZQTbzwEVV0A6T0/JFWX3MXF9LI4SeLfHdWSSwCNPDnXsIeLDyxoF66tzgaVG0JOlospClHBXtqnmkPiJbXPBJOLBFNSvte9CtushGkMltiRFmf4TdKFbbuojJpqSjRLvF66aguk4cIAeDWIRLjbneUMaBiI2zVIAXHkq2SIlZZsodgpSiZG3PGY5ubfWX1THI3wjZk/zx8aOMsIhLnRVSspF7BHf/zgccOz+69Es/wb5TzaeZNOVTW816mdhVk6SKeuoSvM+cZAuEJxdcac5XqJp9uiPdRzFRotB7UghzVWne8besQCthBmd5IaDJpUujSG8hzHm31f+mozEnSaSArco6m3ef9TxgXor9GAl/ig1uCeIJtu+jWO6H38+T1u3W5aX5r4I6tdYaSSDRSio+Kt5RNGDEBDbym6bWJlb7LrCD771lbX+/YflqmaGN6d08ii4QB/a7S9elSYAHMUtiR4NFvJX6yU0+7zANBG1AUBYKCBhkTT3oZxVWbO//Unt69XQ+PD7E2EjowEJaCcLYEsKVqgix0xS2Uxnpfn543SsczOBVl1KYUFu4zwZU29r1BsjrJRuMqyFKs0AhgZxZda0w7lg9ZfMR6I9hdfiky7ecqh1PsFjj715SWX6e0nRDi0b6oUuNyG3As5KSNwKfJgv8nCPEAps68yZiB5qwuoCGqJshqfNmSUr2ykjTN5tTis+/3Y1uJRV53nYMLr3nbXtXswgfRNAFpS0Gj8d8ctrxSKrnanFPKw8LDTcQK6PwmexKBl2qb6FFnR3OWzB4oFtDg5+9P6Y+7mal/EZTxMI/6X7W3yUKuhHb9j+kbrlMydrJdXp2wqTKplYxNXEvVs6R4eIvSD0Ivz0iQIRUklv4n/Mdo++j34tZTzOK++E11PP9RGleEaTjWEclUQdp/KeKSnPy80t6SHW4eCAVmU3HI06CsPb/bQ75dnAhjZMb
 FAFeDNvc
 9yof/y70FouwVOkvx36C9CSVyTxmyhAKLlrefQ5GWJ9ryK7ZsVX3jz1GjS0Bg3GS/JstwMYVqmMpUGW2Tokwk8hOHAGL1/QEG5jBHyWTaKTfU1vcDbbVoWnhu9nYpm+sPnJXtE1FLrTn0Qf9jInJ/dym63nHMI7pyvHt8FZOvKN9yFu49G/fbLbchFXQ8Im3soQgvdGqwHdYOsvGYqmKkUJJtuBuJPKsxMDQ29ljiSJ28/sZXCqGLuY6ss4AH1jVJEVzVKjkntSUlM2FVFuKobAQcGnLgIWPHSYDO7Nqy07yC+BwMaIQgX9ELXlFolks9tyDHdaU3eBem0mhPhRQWkn1Q+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/10/26 04:11, WANG Rui wrote:
> hugepage_global_enabled() and hugepage_global_always() only exist
> when CONFIG_TRANSPARENT_HUGEPAGE is set.  Add inline stubs that
> return false to let code compile when THP is disabled.
> 
> Signed-off-by: WANG Rui <r@hev.cc>
> ---
>  include/linux/huge_mm.h | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index a4d9f964dfde..badeebd4ea98 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -570,6 +570,16 @@ void map_anon_folio_pmd_nopf(struct folio *folio, pmd_t *pmd,
>  
>  #else /* CONFIG_TRANSPARENT_HUGEPAGE */
>  
> +static inline bool hugepage_global_enabled(void)
> +{
> +	return false;
> +}
> +
> +static inline bool hugepage_global_always(void)
> +{
> +	return false;
> +}
> +
>  static inline bool folio_test_pmd_mappable(struct folio *folio)
>  {
>  	return false;

There are other ways to enable PMD THP. So I don't quite think this is
the right tool for the job.

-- 
Cheers,

David

