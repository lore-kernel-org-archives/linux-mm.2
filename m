Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774A3C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD2646B00AF; Thu, 27 Aug 2026 12:24:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAB166B00B0; Thu, 27 Aug 2026 12:24:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71E66B00B1; Thu, 27 Aug 2026 12:24:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84BB46B00AF
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:57 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0951614011C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:57 +0000 (UTC)
X-FDA: 85147573434.12.92225D1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A3791C0005
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JEtcCobY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847895;
	b=W+ubKs4Okp8Qu4qUjihmIg2FbBE2/70HUW6WkrugLp62mVmJDuHEOrbtGzoNSUDo1NbrOW
	j9SrTginxHJi42YQm2W5IdnoL6E1RGTfNeh5zeRSW6kIY6khRQ9CP7z7osaMK3CEWbkhV8
	SMXtuFz0/X4Gfo0yenMWdloi+2K5/UM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JEtcCobY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k4IjVQ8xYYn/f853vC0nwnTtzI4QKlFBwZHa3KQVQaI=;
	b=OhF3mPB0PNlbIpe8k8SmzXYdYxhihSAKylb9CDoqfnLV627nqWuriW6USe3HrOnRLrhSnC
	Eh4mEf3l6aMC4AVOIMdNTuurPgNV3KLtyzYnPz/hlDk8xlBq7gl1Xr3H9t0Rt090SxrMzV
	WtP5TbtJgrNwhPLTy5/8BOnX3LaBAfE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6B9A601EF;
	Thu, 27 Aug 2026 16:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950DF1F000E9;
	Thu, 27 Aug 2026 16:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787847894;
	bh=k4IjVQ8xYYn/f853vC0nwnTtzI4QKlFBwZHa3KQVQaI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JEtcCobYmE8v4gjFqS5QX3ezIKi7e48vKFSKg3Nbom0U+iCeQzCBtG5QkgoQqLi+s
	 x9bMqAp7QtFfuxOZmlf/O52d6wsmZRxtCP2alX/BBYOpoVcIMlbmO3GLOUCAO8Xl9J
	 a1WfTChbQcWVC45Gl+eNSlXV2Cpug1sWasrfx9CzPQh4SsuIeGB5hF2sRbeITAZhxl
	 n41vy5sqsu8SSmqxaRq6b1NXZJ8+pLkk0P5Sry/URPF3e36E9x30+vE0gf/FXvBGhs
	 JRmu7proFNKPFvoa7ii5H5vI6/lSVQwY2xSh/iCdQ40ntY+oKORNYaesrVv73RVwGe
	 Qw8EuRnDnNRQQ==
Message-ID: <598cb41a-7455-4889-b5b2-585bde87a6ea@kernel.org>
Date: Thu, 27 Aug 2026 18:24:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/18] mm/huge_memory: consolidate irq and locking for
 folio split
To: kasong@tencent.com, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>,
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-6-9b43f5163238@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260821-swap-thp-cleanup-v3-6-9b43f5163238@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: tzj3wzyi7r7uxsnn3og9a39m86kmkw9m
X-Rspamd-Queue-Id: 4A3791C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1787847895-672988
X-HE-Meta: U2FsdGVkX18/PJXqgrt0hfYRbX3lcpDDgiIvwq6EKwgJ3h+lTu69X+10cwhcQQsBkxsJFfV3ddeeIBjFC+kHqb1FGN/BoTIjZJs5MTOi7gtCXhl/PTa5GNhjYYpg84P/0gEjbq88sgNcuATX7/398InVz7xQdTqHBtNC9Wl6hI7cYmolylvLCy1/LVtUjHxnCIBExa6UKiz5pdz7TlKW0rQtEMyzwOb7VAcGTK+aZ/lGdPbIG3SK7rQZ0DSTB/PDztWga4qjQ0dWHE+I7sRJKwFrmKDRZPIfmICL1bIUM4ywhi9ryXLbEDSxsyINIc8TunQTmnD6hgOUhM0fRn85xmew98nXyPG51JrdpvHUL1dBxY7bNH4Q/QJlE/LmhxtIoLt4PraBGqpKpDqo8UGOvINxBPQMBG8fTARfco+XnmuO0OEBT7nxcIw/zxSm+G7RNUot3s9mxQx3cPLKhrdj+Hy4DbWGCrP+JDiLMJ7dh4MEruDVpOXzt2mV1KUxA4j7P9TzQ4bOWUsCohXEV4DIEjdwG3Flyl5dtsPGEeC5Wtn6SJLKZXSjU31a2fMVoH/ZfsYiIUsRq4Wt5vb4Yt1XIrzo1zV1pyYL4x5o/MZIOF4ieRQ9mWY+SOm9geyxdO8ZIBOp++iZbZc0iZhE8raCrPajAS1aiBigsRMd2f89YNouRzk5Umn1DsswA+2oZNnombkA+8BuPADu5XGa6aQVJU+kuBHKPYtEQQePQq0adLRQL91TV/HT7avN9IEA+R9NesNenT8nLlwpAuuQewVTMwnxx6r+ExCTNCPlmbL3XMv97csq04ZmYOc/N5fcDyxCdoNn5wybpzgKmfRyu4Gy4AlzvG1vV37j6sQW5T+pryHjOodwjnY48GeOaBH04BTd6InNCcsMYRK9R4LIrO9llMPEpYVxhYDjh1svemDTDWaBtOgysbryH3eC9jbwRwF+Bn8WaFxgOB1DdEvCPwF
 60ToPf8Z
 deDHetnJVuPhQBhuZPZprXckROlIlnXsIVrOrB5PQcR31/mCSDH7IKho/3a/I5QpAobGPzzz3GK0H7AawS6dNNoYqOPj1R+NtSq4D74jGv1WojlAgbMaNeREGhFHBDb5amHiWGmpyaLzHpb2Kan7eox/+Ep9ERpw6IDQmHDR82j0Te5+yPOmTVEXDVfnDtVEJAt5xzp7zil2cHT9L1buixo/iCZvRZkt5PNbqMVWSdsKhQSvuqQUhIaaiMFLiptvuEVaURDx0Y7L5FcrOzJcMfVKStjHUqBVuNrgRPAKgaJypFPhDiK+TF/Ohvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> +
> +	/*
> +	 * Check if the folio is present in page cache.
> +	 * We assume all tail are present too, if folio is there.
> +	 */
> +	if (xas_load(xas) != folio) {
> +		ret = -EAGAIN;
> +		goto fail;
> +	}

How can this actually happen? We locked the folio and folio->mapping is set. How
could it possibly get truncated in the meantime?

> +
> +	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1)) {
> +		ret = -EAGAIN;
> +		goto fail;
> +	}
>  
>  	if (folio_test_pmd_mappable(folio) &&
>  	    new_order < HPAGE_PMD_ORDER) {
> @@ -4106,6 +4123,8 @@ static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int
>  	if (do_lru)
>  		lruvec_unlock(lruvec);
>  
> +fail:
> +	xas_unlock_irq(xas);
>  	return ret;
>  }
>  
> @@ -4245,19 +4264,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>  
>  	unmap_folio(folio);
>  
> -	/* block interrupt reentry in xa_lock and spinlock */
> -	local_irq_disable();
> -	if (mapping) {
> -		/*
> -		 * Check if the folio is present in page cache.
> -		 * We assume all tail are present too, if folio is there.
> -		 */
> -		xas_lock(&xas);
> -		xas_reset(&xas);
> -		if (xas_load(&xas) != folio) {
> -			ret = -EAGAIN;
> -			goto fail;
> -		}
> +	if (!is_anon) {

Ah, there it is :)

Nice!


-- 
Cheers,

David

