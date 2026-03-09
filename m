Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97DF5F417F3
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAE0C6B0005; Mon,  9 Mar 2026 11:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C99BC6B0088; Mon,  9 Mar 2026 11:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6196B008A; Mon,  9 Mar 2026 11:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AB6556B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:18:42 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6797CB604F
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:18:42 +0000 (UTC)
X-FDA: 84526881684.12.2C38ED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 774E3180012
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:18:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJf0p1+T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773069520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3IYnFIIy8KDio/iM3HwOyD6w1kUAWLnDMqZUa54gdxE=;
	b=RkUrOiTH2FYLagyPlIMjaDbcbpjaO1YCL7YCRlKeG56gEPE2D/MnwR6S0/MPcII2KImL1W
	jiyuV3OkBoZ7LmfWPQx7khpRqN+SWyis1krtAmDHjIGt2wfRN+sq7CP4yanurbDgL9QTRS
	qookREZlJjOyEurieq0iHyHcyz4FczA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773069520; a=rsa-sha256;
	cv=none;
	b=J5hpRM/d9Hk7lWtUpxb/ymf47i/op1fjMRPlaDkl/qhCJveskfrlTFA2lq4izLQHhBhSSY
	akBPz6JwxekvuvnCBgtX+Gmj2O/lPX9n0HbspiDR2BtThGZgTtsQrvI2FqBfsgx9MQ38JE
	F/ZLHqM5aEKKryzuq4BGmf3jvhb6mVI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UJf0p1+T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F4BA443C1;
	Mon,  9 Mar 2026 15:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7252EC4CEF7;
	Mon,  9 Mar 2026 15:18:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773069519;
	bh=Tmlct5yti5Nzvu864y6m7qzoF3qxE95FBRq7jzbfHy4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UJf0p1+TzB+pXOrVGFSCej1LqFgXVQgcbvxFKJSlTrtAz29CkovetwiQerry37Vad
	 oxlwScXzf4hdF0Mjg0qDZY/pWrvBBlQi7I6jpkzaY2P1tMNpk+WhhkK+e65sEafFB/
	 nv5aBYPF6G4CnY8jzaLL7CBqSr6/y5R1kwYsSCDi7wRBLYuqBlDJ5DEqxxB1IiCm+D
	 ssaqVEz5/qPuZexvnxnHzXVOi+jHF1XtJ4Y4N1ZtcV7vCn8idJIXXFBOzdywuz9eqc
	 3KeMPQaO1CDjUp5Hq6FhesO9gJaddulH3QaRadR7/KbpAeun5YerHwe4XkPGoCEEQF
	 I1Ksl33mCy1lw==
Message-ID: <c74e3941-f977-4b19-9d71-972bd9ed5c60@kernel.org>
Date: Mon, 9 Mar 2026 16:18:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/migrate_device: document folio_get requirement before
 frozen PMD split
To: Usama Arif <usama.arif@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, npache@redhat.com,
 ziy@nvidia.com, linux-mm@kvack.org, mpenttil@redhat.com, balbirs@nvidia.com
Cc: matthew.brost@intel.com, joshua.hahnjy@gmail.com, hannes@cmpxchg.org,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, apopple@nvidia.com, riel@surriel.com,
 shakeel.butt@linux.dev, kas@kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
References: <20260306104409.3915811-1-usama.arif@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260306104409.3915811-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 774E3180012
X-Stat-Signature: a7nxown9qkui885co43qd1ujw9jnodtu
X-Rspam-User: 
X-HE-Tag: 1773069520-643277
X-HE-Meta: U2FsdGVkX1/DcaxN05VZBIhz58d60sLeogVyspBcPcprb2nMxeXWkC/RCb9KQekORmMLp9Ud3l0e3RIBUO8K2vvS60sW5HoTKJ3tS/epNmngREIMBuSn6TTwh5zGdSd8jXe1DpYeexerPUwadOJNm68Kx2X0u0YLIURLPGDDe+4AFQvJZRGC5U8e+BZzUQmE/RF7+F7ygvWZD3fMcts6YaldnPNWyFIk3rr8u3z1/12Zq9wdM6sXdHcLFbn9OgLA2RRo3hvSZxr1TrV3ZvbTQdjFh9WB8DNmHm6J2jFj93yQik5pyvIRyame6a8j3A0A9wZ7GFxqGk6TBEMQrTRJCMPFqiCm1Zd+znBwUIjyySVMqff//aZsBnq4xZ45EXnzx5yf/5o9D3p8Hq+Wzsw8wVUQ6+L8GtligjwBcF+zuN/3RFiIhqPDpy2JaipO/ikcGBWpDXr6eeo76YYuzD/pTPaRj8tSTlCpPTURhyaYKqud+XoLRppo4HKNq8t5DAs2PtMSixO9ELzCHfk37lutn2SODuRoe92M2MrG3TbZbLBk/a/UNRDcHJXmfufRJRoTMleYpDdVHF1W5SiiPZCOkIVkWOtoeG6+jdFBfSbpD2sVAjlqVmYynGMVT2e7kYLi3yYXeQD3TiUNbY3s8VSmRkjwgfGtMETW2JwmcD/pvRJP2AoQpxt6JFFEqZLPtDP+UBOCRjILkHPsTZLWu2+W0GrIuHjw642YHyro3KwVqr8ZJAsnhoM9nkxjP5c8aKBI//RcMshIQbfuSPqdAxOV4+muIpperFi+QCNN0TN8rK7pOm4YqSpK2cI3g1D80Wi8kT8J8BlrGFA0Oxjyvmo/01YOPX0FeOINIl9CL1UjWHnQ87nOlmt7mHOKzUK3NQWy3CjUTbSBNbxma2cGmTzOJy/4JHmsx2+WwMCFb6BjCbR+ZW0+8mic24Tt1utO5JiMJn0ibRo67zD5ubFtBRG
 zttWM7C4
 Gjq5xIYpQGCySBN1WdLn9IPZQ9KaJd0wIUBQwrtfk0KGM/Qr/EnL8n5fz9U9cAs4tksdk4MwQCZ4RJPaAHgSb+xOCphKNZiZyARrAkYfjMaXfB1nUDGjn08MDzyemLPeurhwPIQCfsNs06lSyInzmjgI6LUtI6H7z2Pl68nWSiikmgJ1O7FfY4VqfZg7GYZTTO2IL3/F24QXVjKXKNaC0IHt8mViL609ndOuvskXN99LxZmqsAa1rYZiBjeR0Kc7NHOLsWNFqLDIpC4IR2WPMHi0Gg1/vQCszp57jBssoua/LSUNHXU5cFOf2SAzvlymoa/pYnC81aQrON+Zv8Y0++YclLjgPK/8WqvsQoOyZPTOi8dQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/6/26 11:44, Usama Arif wrote:
> split_huge_pmd_address() with freeze=true splits a PMD migration entry
> into PTE migration entries, consuming one folio reference in the
> process.  The folio_get() before it provides this reference.
> 
> Add a comment explaining this relationship and a VM_WARN_ON_ONCE to
> catch an unexpected refcount != 1 entry state.
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>  mm/migrate_device.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 78c7acf024615..6fa2878848a7e 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -908,6 +908,11 @@ static int migrate_vma_split_unmapped_folio(struct migrate_vma *migrate,
>  	unsigned long flags;
>  	int ret = 0;
>  
> +	VM_WARN_ON_ONCE(folio_ref_count(folio) != 1);

Can't we have speculative references here? In general, asserting that
the refcount has an exact value (besides 0) is often shaky.

> +	/*
> +	 * take a reference, since split_huge_pmd_address() with freeze = true
> +	 * drops a reference at the end.
> +	 */
>  	folio_get(folio);
>  	split_huge_pmd_address(migrate->vma, addr, true);
>  	ret = folio_split_unmapped(folio, 0);


-- 
Cheers,

David

