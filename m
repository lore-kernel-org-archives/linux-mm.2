Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 541B2CCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 10:17:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B638E0011; Thu,  6 Nov 2025 05:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC7E8E0002; Thu,  6 Nov 2025 05:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5094D8E0011; Thu,  6 Nov 2025 05:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9A48E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 05:17:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B9E36578F4
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:17:08 +0000 (UTC)
X-FDA: 84079779336.15.D59291F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 04EDC4000A
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 10:17:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KsX/Wk0Z";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762424227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4jDFu/uD7S0ILXQc0l4ufSAYQXxC/QL8k9B0N9IdHt0=;
	b=VsNs7XaseXOO4W6OH6kmRvW7M47S3cViBy8OlR/iHZr85gEE9WhcJRB+VWzHQLCWyQGfju
	TjnRisMA7yVWcrpnLi7XIiSZUSELFF1P1KvxlLwqLYyOMIKt72jcVHDlES6iEHbhNy0xBr
	i4qlyY7C1bP8bW+bsI4iWN+YCiBSkig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762424227; a=rsa-sha256;
	cv=none;
	b=cOPepktNtGiYF/9ekrHXawwPBH6MAoBcPq2pZ1qPfU6T4sBUQ7jXEavPF5rbu+Bp7eGRsm
	+FUKOWjNaH7ypa8dQJBgA9ejFp1NjsyMulE/8MnuidrOh7jAdi3tUQWBrRwkkLMFsT9B7f
	jbCLZ4boaz5lq9dl77vSgdRu5vrPC40=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="KsX/Wk0Z";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 10BBA601F8;
	Thu,  6 Nov 2025 10:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8C3C4CEF7;
	Thu,  6 Nov 2025 10:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762424225;
	bh=+AdCY9zJ+6gonNM8lcWLBTOcj/jVl6gpKb1/3jbrTb8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KsX/Wk0ZG7NWpSkzVKkKLiVz4Ii+escxaZvcpN6wTvlUxJpurW8XK2bKgNyq/7BKT
	 3JIOOTmMj9izaHy7YqZNt8Z2pE8J/8ykEYwVZh2BYINlT59UB1lh78ci9V3VbACFVp
	 T4ctfPVo/ixmV0Fbv0H0qjGKpuyW7AzRBs0O0BRXG3ylm9JQl3u3l0GgcITvpjEyi6
	 Dd5mT7kUnXFpsdmOxtzxU51Z7Jya7Po8iKc7P4slXvAUhdqF3Ta4hagS1R1Eaj0Ago
	 auh9Cqum7Du82YwJ8LIXqQilLRIg0oBxAqCA4+oblIlvwT1nx4WLsdMTm32UAH4qKf
	 LVhX7gFkwQ74A==
Message-ID: <c2d8380b-6452-4b12-9d51-2741f86180b5@kernel.org>
Date: Thu, 6 Nov 2025 11:17:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 1/2] mm/huge_memory: introduce enum split_type for
 clarity
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
 <20251106034155.21398-2-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251106034155.21398-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 04EDC4000A
X-Stat-Signature: nu8ds71g6jgr5ewznesdps1tx5os19ui
X-HE-Tag: 1762424226-894988
X-HE-Meta: U2FsdGVkX1/Bwy0FbM2j9y0bCW5Q7dveqBj804BmpPllpHxAMj1jYD1TXmORAL7h4yQWgl7tePHaQySu64qtxuZaOygTY3agxoxgWMyh+MEVRWm1hEXeJbCzJHM8TIafhok/1fBEMVRh+pbJXq9iuLCkj5uinRp/LxLxA6DkYm5rlUBxtp1erJu2fpQrrkeEQXUP/i30Hgvg31cGkWdziDRbcbkomqbHqavqYz3OSHAMeoOUrgpk02+zw3R6y9HSnUqveeQYBYuI606YuaS73XxkxiUfF+lBCu73tusi7QTP84Is8oKeB/TZhF+lPG4BDDiHje3/rrWPMB0jJdSSkU6sxEvZpxiT6iVJp7RVz4EHBC45AcDaLfr/Uk+20JXbJERHw812c4fvoVas9JEvpzFZ86/g2cmkxWoyu8Uktl2wUD4jxOFNue4+d2h4ksZdHmMMvmafgxSiG9wxD0UGiL+E5ny9mkhz81JAcwFX6aXiW3eLGTFpVo6ofsEQcx2UeVDhMJS/eAZPj/gCQCFFRu55YjT7OyMRXeEn5jY0OuBTZLvbGUIhfuy8mIbBNud0DzVbYejrMl5u8W+RzvBhnj42lBxFp6MpMiZHPaa7nmnk+tSsBNNnFJ3Gcjl7j64PpyftIMfbOW9Y+Yrh8sm7eHTrmKmagN0sLllUK9L/QB9b8ldP2TTFMIhrwxvod77HO/TezNCST9tjVo1UGH7Nnk+iyAbdbdF6dMiTTFQfQixKLZeeVPOryZHzktklpRfxVhyP81AsWjs1YxwJxcEfwz+r1zsdy/FNFFzodCn+of6LhgHGFGdqnik+4hu0ONZk3U1EcelZ6HwCToVoEBD5KsaIFZ2Sc1lRV96DZe8+JzqjORQWVqDAjVM0zomvUK0IDBFp2HtD1XETydTaK9X6//xGENr9YS6yfPpKyPo2j5YGHCg8jdgKrPh5KVGgvFPg1fWSkqFy4SvR3ipDEak
 LShpYo1G
 JdBvNs5p7i62Nyei04GZ6TKY2UtJlEdUIiIuC9jB8ZEB1o20WWAWlnY1zriiS6XXlrSualzJYQqG1DDUP6BSIk9X5JdCcluCQ5+TKtWyFUXg4b5hKBePlJODsA2r44RlqByr34QNl7UOTBshL5MQDBL6szRRZ3d7HkZwpafTr0SCBSAkXrFnQi6WGbJszVTR+r2uhB50GppIwpvzEyB8WRtlJR5OPSbfeVzUnio7mll5Fc9lnvHp7r9NHtv63n9xQJ0/96sUp9/Ox4nK3YofAYIlI52M6PScBvZa1hd+Yh/d7ZianvWBnkRNwV9l9gU6xAllXShfPXWl6oMIYZm1tuoUoPisV2TFQhabLFYq7SLUngtm8nb20RFLnC80/8UdP+/YE+AOl6GW9+G215fyb25FufpQaCWzVdWEC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.11.25 04:41, Wei Yang wrote:
> We currently handle two distinct types of large folio splitting:
>    * uniform split
>    * non-uniform split
> 
> Differentiating between these types using a simple boolean variable is
> not obvious and can harm code readability.
> 
> This commit introduces enum split_type to explicitly define these two
> types. Replacing the existing boolean variable with this enumeration
> significantly improves code clarity and expressiveness when dealing with
> folio splitting logic.
> 
> No functional change is expected.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
> ---

...

>   		 * Unfreeze after-split folios and put them back to the right
> @@ -4149,8 +4149,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
>   {
>   	struct folio *folio = page_folio(page);
>   
> -	return __folio_split(folio, new_order, &folio->page, page, list, true,
> -				unmapped);
> +	return __folio_split(folio, new_order, &folio->page, page, list,
> +				SPLIT_TYPE_UNIFORM, unmapped);
>   }
>   
>   /**
> @@ -4181,7 +4181,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
>   		struct page *split_at, struct list_head *list)
>   {
>   	return __folio_split(folio, new_order, split_at, &folio->page, list,
> -			false, false);
> +				SPLIT_TYPE_NON_UNIFORM, false);

Looks like both these are not properly aligned.

Should be

return __folio_split(folio, new_order, split_at, &folio->page, list,
		     SPLIT_TYPE_NON_UNIFORM, false);


Thanks!

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

