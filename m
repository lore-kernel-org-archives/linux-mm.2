Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 682A6D47CA3
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 23:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F5826B0005; Thu, 15 Jan 2026 18:51:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2AC6B0088; Thu, 15 Jan 2026 18:51:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 677DF6B0089; Thu, 15 Jan 2026 18:51:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 565C56B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 18:51:26 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D2FCA1604D2
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:51:25 +0000 (UTC)
X-FDA: 84335847330.04.33DCA7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 019EFC0002
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 23:51:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lom27nSF;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768521084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OROeZFt7uSmuSQn+r0BcEN76XTeuRITw1wphgn0aif8=;
	b=yyhkxCm6XEl25rkdxuvyscJwUFJybA3fGCL8zAYK2YOJFU4b4aYChj9wVL+mi9AxUQ4Abw
	+pUu6FCqCH6FSK3X7In6qgfdowBTdedYkn2ZalashZyRG869HiNo3t8MOb18tthoFfLtHQ
	iC4FLucyhCVV2Lv6zPqVQVq9fZ/HqYU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Lom27nSF;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768521084; a=rsa-sha256;
	cv=none;
	b=rLLOI+igdSlwLlH9X+NxW3/HNKIS/GF86rg56/LupjgPXueZPmyfNrXRCy4FZYxkgPSXSY
	+XS3clhzjM9T75BsVax9RDMMvcnR4IUjSNoDgpbA8ZtTHrLPlBN4BK9mSQFDKf10i6cBeA
	WlyBC6fqUtnrvJng45fgRn5p35dF7xw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E4FAF41998;
	Thu, 15 Jan 2026 23:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584A1C116D0;
	Thu, 15 Jan 2026 23:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768521082;
	bh=J9U91kHuzCxLJ2wCZehjDvOC05vEXeGwmi7t2v6qWI8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Lom27nSF4ZGMNiTOQZ2hrnpyFYXi+irmoZmvUJIWw5cJRwiCyL0vT5OYRNTB3k5vl
	 JLBG9A9pL8RMnmvZ7kd+U9RhutPGsG8QDhVSnI51+7hUt79DGZn3lQC+jdnR7o0nLr
	 H/3tvU5cOUj1J9sQE8xisEK9VOv/h5Q6ggBXlF5qM6gUQYB1uZPBkPs3QRVMbz8jgk
	 sM3gUfqnlbQ7kQMCtBpJH+Cwd5qs1nasJuEFsOtf7L3ZnXg0E+prCwpDUJijjMIGfG
	 qSXsIxClwHJW1rbuEG1DBmKCKCt4ZA7gJfqW9r/Dh4QcFVf9ah9PcoPPc63sjBCwM7
	 OmA34UcE5bEyg==
Message-ID: <1d9019a0-8427-466c-a8da-b373562c4566@kernel.org>
Date: Fri, 16 Jan 2026 00:51:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 4/5] mm/khugepaged: use enum scan_result for result
 variables and return types
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251224111351.41042-4-shivankg@amd.com>
 <20251224111351.41042-12-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251224111351.41042-12-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ca9fm4pqog3c7tk4xag8sgssa97mdy98
X-Rspam-User: 
X-Rspamd-Queue-Id: 019EFC0002
X-Rspamd-Server: rspam08
X-HE-Tag: 1768521083-152927
X-HE-Meta: U2FsdGVkX1/iXuoivKwogfjRA+wcWGzR9tqrFByMsSs0KWvfSnAQSqfvGz1B5FZkP0ECeNNgDrj5g0i4aFhSywfPtj2GOdgvfZlwCh3gVTSP535j6jGQsJ2Vcoauu6PfmfqR+WATjuiRy8wGJZv4J/M6WTgekYm/cpRIqgsD13Q+ks6jBGaDKYZlHfiOsn2TKcUhA/t7v036bH/q6AjQqVVVw4XN3jqdY1FgxH2cCrrWhG3vZ/xmcncvdjFxZUeW8o4iQpIuKnwE7wI6yt038vvHj0DyeTlnFGAhv1+DZdHIwwoUNO/ftC2aRDlk2BRwtZghdjnfz274KH2wpRfR3hvF7rArnOwjFgRSQoirrXo/KIbIyniWr0KD4eiHA3FnExY6/LfXBUHGfFXIICHHT33sOV+0igWa5to7QyGwJl3Fz1mg8fHFvtiTsvnlacDxgp/+t81t7VOCH3ZuFvj3gagCosn6GUVDgvaAxXiTYMplFseX7Zc7sUur5F0gVe/OB9oNaP4oLJAkOPLUWeOgvwWdie2/s/WQak59PCgYgpHlK/Yt1VWtTX9h6mM2IJJ4REZcdJNfkoi65a6BBzoCdiyVIuYyVVA5cGrHrOrZKtMsB6+MHQgLbOriJWtPe3qdvlq5LsTfob7DHZfp0ob2k5RBbOjNs6LzWtZx/7bqN51SdQVz9J+bQgyI69RqtPaeBMrsWqyafW0d+cyUyppSzE1ZvmR2pkn3tZ2MEJL8DvcX7ypAx/1JYtUayUhwer79Ker9Tehr8cSOV8kfco4Q7RQ/UijCD7TmsJuqCcdofP/lDv1ffaiodMbwGMgD5b4BuGtEqmZqaI+ogz2XHB4OKgkS1RJFR7ah7bH1NHnOvswfDgz2IgqHS8nrGrZWOHr1APSG9vWAyK+hmnpvS20Aq9Qcl9Ol7Pm+vE1Oj7T/Rxm97zw/4rrzR9Oj06Dc1Ya7xX8sYvfOQdFoBDf5tbc
 cu0f7541
 GS0OlM6nRLdJOrwdmvpmLPNTeUFOI46x0KXkUpiIT/jpXkvJnpp2P89QeYPXLBNjzvKe9i3M/4ySQj/8H77oJwIyNzVQcOyyD1DU5xd6kwxjtQJEtNlIL7VFvlPatrtAfsLhCmnenLt7zQSVoDTX6u637S43yBPRshBhQuuBgsZl7mmM8cpxYzWIWzHTWDuxftUhz9gA7lSeVZn6r4xMS97RJCKj5drO0gz4jAmH5DUH2iXMa3VBlgC/xEILYbGArTvHjFJG+I/AQfHatAXlNA8+uqd4jhn1OFuODx+Qmn/fXrGth7Ash+YoS50qh3S1IXRGLPFai7IHotgc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 12:13, Shivank Garg wrote:
> Convert result variables and return types from int to enum scan_result
> throughout khugepaged code. This improves type safety and code clarity
> by making the intent explicit.
> 
> No functional change.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   mm/khugepaged.c | 111 +++++++++++++++++++++++++-----------------------
>   1 file changed, 57 insertions(+), 54 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 04ff0730c9a1..6892b23d6fc4 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -537,17 +537,18 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   	}
>   }
>   
> -static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
> -					unsigned long start_addr,
> -					pte_t *pte,
> -					struct collapse_control *cc,
> -					struct list_head *compound_pagelist)
> +static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
> +						     unsigned long start_addr,
> +						     pte_t *pte,
> +						     struct collapse_control *cc,
> +						     struct list_head *compound_pagelist)

Another reason to use to tabs to indent.

(Again, applies to all cases where you touch the lines either way :) )

-- 
Cheers

David

