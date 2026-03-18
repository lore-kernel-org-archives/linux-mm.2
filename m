Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0446EFCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A636B0126; Wed, 18 Mar 2026 04:20:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BA06B0127; Wed, 18 Mar 2026 04:20:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 148CB6B0128; Wed, 18 Mar 2026 04:20:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 034136B0126
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:20:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1AEE59A11
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:20:23 +0000 (UTC)
X-FDA: 84558486726.06.E962D85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 154A3100018
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:20:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXWpygRH;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773822022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4DaNeLwypBT1GTy8cCTZ3Oc0AmJX69XAjth74owcgWU=;
	b=pkauzLggelZZoyzhFQuRbAAifMB4/W4Q/Yxx9mcUOPIEWRDsVy2DPQgAweZxAL7Qr0hmVe
	vFwTg1DB0r6SqYHrmZdoaDbjtUVIIlGJzTpvo84EkmI7R/2WvwYxz3bGj2C/EZhQ9ooCOJ
	QkS6bRtzaY5wOpYlb9IB9Ez+DE4xEXU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773822022; a=rsa-sha256;
	cv=none;
	b=3RsmdUPm8XX4hEEpeD5vIJ2ljYHBHmh5PwiqCHcOyLwZFUwrbrnPvRfM6gc88JqOHFsPD0
	Q+2YqxrnfuKmw+tb1cZOHV9JRPIZdi64oK/+VQlBcnxkCqIsUM1ro9C1pQuVa6njxAMnDR
	FWZTaS5zvAXOR2ES57tpIDuwyVQJlmc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXWpygRH;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 79A77600C4;
	Wed, 18 Mar 2026 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B42A2C19421;
	Wed, 18 Mar 2026 08:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773822021;
	bh=aQAhk0sXXDYLvUo6haMj9vWgsIfwV36jAQ6E1OobyX4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jXWpygRHCWyhLEE+w7ya/9J5hxUvfUcyAIJcOaTEBfJjhiXVhVNFnzwLsLn1x8tcA
	 GwfaCkHE2oYzOmw1atEtba+VRHMoKJkrkkaWPZ7WI8cI8jLXOsrrzzF6oRq9OcLXCa
	 8ZYJgbIBXVc7B6FZTaXzmobFa/fjhQzwZiIDatb1bXsoZtsVl5qsagoo88d3eTuENG
	 8wN7AgE5PS+nBmxjL7Kvs2VplQoCI5CIIH+okwNXGzu4pSmGklVacd6cLC7ld3YUKq
	 yqaivLf5KshOZ/aId7JS/WdnDCiS1rsdDdWARgFNJXGlxxG8MRt8SXskbTaBWz2YtO
	 tuyTLdBlJTaMw==
Date: Wed, 18 Mar 2026 10:20:14 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 07/14] mm/bootmem_info: avoid using
 sparse_decode_mem_map()
Message-ID: <abpgPvayKswnaEJl@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-8-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317165652.99114-8-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 154A3100018
X-Stat-Signature: y8o66g1gikrricgc4eyupbihc7c7zpzj
X-HE-Tag: 1773822021-6084
X-HE-Meta: U2FsdGVkX1/69AOGeaI33qFBLRhIwCZO52IiKCDf7yUPcqJA114eyAkBZKSJU2nWZYyE9E2Jl7ZocnmvSaPW2jzE3VVifm8kxLbWJaDUGLo4vfHeeDvSzRbLhlfFlspD8aBM0QEaeYW5xGs/y86+puQF30lB0Xuvm9gYhNs1w6lklKXvBhsZwT4Gh1dWO7ui84vaFzL6dUCZ/N8I0ev/oQ0CZmewgM8WN/65OXerjD4teRCO4zbqoNpbpCjaFutmXogmRl2KokSQKPastaZm69lKtexSKt/LKrI0DSuqo3iDZGUBfGD8vkZ7MbUMCExs+DR5gQsDyLXn8/0cAirHez51A1BMZsk04Zq8tkVto7AA47kvk72zffJFnBb9jFlvpygLJQ6r+Ev9JUz9DXbUgzqKqt6A4cbIsH0HJMtfkReZNzOKZATqmz53OhVD5VU645/Cg6IRZNKzMuj4/5l45avh6rty7reHAeQiA/uzQA1IB7mWYHEeGbYITWDsYz5qh0V8WPAIgG5XFmQ/yfs65sAfdVBee/fjD8spyP1M/3iHjs+WKt/lqMrFXf6EermSG0IgrqeuiV1JysqgtSBpLKFaHPYjnJDRhuutDGVCUZh6B8e/EufyrCP/sDfiLLZ+h/lkCbBmYO+pHM4rGGGVM3bJlsI2VJvMfwKMto9kmfKIhlnTU3xQgwVtj/oWwh0ln5cnYriA97/Ox0tjqCl40wdi47Ytt3D3vdL0FjA6Mup/PEA+oH2PgfzRo6dLNfvSAqc1jDqt0+6hfF6oYiDTyEjlw4y0cMPh3ZEB3Wy8vQ7mV8xOZcxF2gB0xh7bHZ0C0c8dwjKyIO1ZqkAfn6l4/jM8PI4CMQHqVnDUqxCgyk701yarlDNZxuX8wOfkxPdxpi7MEPAdYZ1mkp6qEh9oMUm6C1ATRTgJ97X2zXBvlX1AAXiHOC1GyuCu52HZAJah0zMllH/RuK/aAWHfFRU
 Vq1h73iq
 igEb6brKllsn++e1MmBsIssBgMLVmZPBI7eXrsVq+wJfs5RGOqvOtEi3R/Xdn0SjdWsr1in0JogKZk7V07atFtW2u6BVXyvYCIqmYQ7k5l1B6AmFEBFzowlJqhJlOo0d3rkpPGxwQuQh36cnXxVCHL7lg+P3+WSgU8UMOrggI+cDWtoxSGF7mP5OXNsuwY57+4zRWReEYLEw/DhCuftjwphVf0TfngkKsuwBVTLAXKBFIXC748eKSc32+Og5ZDx/AqmzMd84EHZhDFTJoZ/NdRbmWaQjmRi/YXgPdiEW+5VMyXKD3oSLnZsBaw3rV+sUJsCCp9YdeP52Bo5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 17, 2026 at 05:56:45PM +0100, David Hildenbrand (Arm) wrote:
> With SPARSEMEM_VMEMMAP, we can just do a pfn_to_page(). It is not super
> clear whether the start_pfn is properly aligned ... so let's just make
> sure it is.
> 
> We will soon might try to remove the bootmem info completely, for now,
> just keep it working as is.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/bootmem_info.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index e61e08e24924..3d7675a3ae04 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -44,17 +44,16 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  {
>  	unsigned long mapsize, section_nr, i;
>  	struct mem_section *ms;
> -	struct page *page, *memmap;
>  	struct mem_section_usage *usage;
> +	struct page *page;
>  
> +	start_pfn = SECTION_ALIGN_DOWN(start_pfn);
>  	section_nr = pfn_to_section_nr(start_pfn);
>  	ms = __nr_to_section(section_nr);
>  
> -	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
> -
>  	if (!preinited_vmemmap_section(ms))
> -		register_page_bootmem_memmap(section_nr, memmap,
> -				PAGES_PER_SECTION);
> +		register_page_bootmem_memmap(section_nr, pfn_to_page(start_pfn),
> +					     PAGES_PER_SECTION);
>  
>  	usage = ms->usage;
>  	page = virt_to_page(usage);
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

