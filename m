Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EA33C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 02:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328096B0088; Sun, 27 Sep 2026 22:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFE36B0095; Sun, 27 Sep 2026 22:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23DDF6B0096; Sun, 27 Sep 2026 22:00:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E71D66B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 22:00:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 435DD1A0ABF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:59:50 +0000 (UTC)
X-FDA: 85261514940.21.95AA8E9
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2D559160004
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:59:47 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uElmx2Qu;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790560788;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wif+2OotdgNoSE2PDumw0Ytb2mptobrggVKd9yP4JUs=;
	b=ZV2F8B29MlmwZYFOWJ5lTq001jdzcj4mv6+VUcfSoJE8F3XgAj4lfUGHJpl7fNBYhNFT6r
	MEbKPuHXmTHykUVHPfl36DBt8SEjnCP07CAhtwFflExUCiUWfGMYAGsMitA47y+KM8TQ0f
	71/kqlVUWZb/YkoLvlsWWP8xraEq9zo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790560788;
	b=1yPldCWWJ4/g1UvARoO8uUneokc8iyeQK7I+pn/xbo/gbkFpycJPqIQ/MxgdaipC1vS2u6
	xGr0fXZke19WdNfBA2ANVSm92Qu0VKtYPWfgcxyG7RkxSMRZlgrHOowx3BNl+R/tGG9k/U
	X5MNEMG4iq0UJ11AhD1liLzq4yfZGMI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uElmx2Qu;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BcqFNljILjUCpRPkdS11OgSUczWkfuZ6jLqgRCapH/U=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790560786; v=1; x=1791165586;
 b=uElmx2QurfqyOBKvVv01kL0GN9zGPkXnf6SJYkbAl1EmIrE5DScIEK6w8GFWLZB8CFXbXkrY
 sDWlS6JocYM9T976nT3Mc9pvDCu7aM+4NgwIvB+nTy0ugAiogEk96kDKqow7fM6hNj++5I0W2HV
 LqoTNJX7I/WGo9C6SQ93x8aw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8140d4f261078bf9;
	Mon, 28 Sep 2026 01:59:46 +0000
X-Mizu-Trace-ID: 8140d4f261078bf9
X-Migadu-Flow: FLOW_OUT
Message-ID: <5b775a0f-322c-45f2-939c-ad508490b4ff@linux.dev>
Date: Mon, 28 Sep 2026 09:59:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 6/6] mm/mm_init: add zone mismatch warning during page
 init
To: Muchun Song <songmuchun@bytedance.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin
 <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev
References: <20260924075259.2013039-1-songmuchun@bytedance.com>
 <20260924075259.2013039-7-songmuchun@bytedance.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260924075259.2013039-7-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D559160004
X-Stat-Signature: 3dhi1d6igpfxx9bqkxwme6kmi3e5zune
X-Rspam-User: 
X-HE-Tag: 1790560787-159928
X-HE-Meta: U2FsdGVkX19iCUzauUf7uBebkX93ZAvbvwBZH+4HAJ4xOMT0cO8cj3TUqF1RJf/Va2+v5DqHO+wUgACNnFw1ATg/UHT3OmDMb0VVU43gajLcrl1o0HEwFQcMYd7hTU97KjzbHu87nqpfMxKHQo4uUyF7JctsQlZBiPK5PQfG6ibAyd2ylTU1aTTJ23sn4X80iz3F7vFu/VQTcUgveSJBIpaCvmosR1QlXV4ACpQBPTdrtjoRb8JYwx79eApCCLoepsPyrhXXv7E8iOn1vKKWyMvsAx5/OwIEH4f86J364VZrU1oU0GNdR8hIaldUgkNFDXNlilPin94Hp8rgWlVrsf/bGf/QEML67QDMMFNsi2N1zFV4o8Zr/FuWWyCltv0G7dUa61xzs6TZZZDhqJwaHnhW04QFLH0dD/qt4u+2Ig6A97BhwTuEwPxJ5ZXjkvxidZIyoPc3MjtdM9JQSCQ90O6hPbUAvcbksZ8n+EU46waIj5SNx+4gMx0ZbpErC2q9MErRrnf5ZhfzwJXzVKOwaIp8L3UViFTOP8APvtvRV1zaMOnHfZ0RnJyFjG2CDBmfK9g8bWkcybOrJ3+ACg/qPdtNnxVqH3PENvUvsOCZu0Pg2LMTYBRpAYZ5w9ZiEn8xOdd47uE/dKrMM+7oX5O5c7m3TxK7JDbavV4PHspBYRkEffczjzpmWJ1kEAmBpxqz8/BDC4NF5OSuIZvqPCe72eFpFnXtjXODLWL92QBPolioNrmatfMyhv19/OpOGpwUJ1SjOfwBvDyAzjM5ZQAMW++/jySBP8XCzsdp11pHkYtDHNvC9VvS5FGnfWqRGPKnIKG+YIPW/zkuaExcmjDTu6SFmJvmt9GO2z5YxBknYFNJimCbm9gZ66c9CQiH5w63eqjv913uU3O6p6uuwATqYUXeo5d/3qeD5iH72C0IgBEUbXAIf9J17clXhkG2TnuzZHFdfDqTmcIdMuNQAnN
 OnBbHjfW
 DEXu6+F0IJ/R5fUrDvqIBFdXSYDhvyCWadGo/hqb6PwKPBQBtJKv1ccA+TQHeBHQI0nUI7HEPvNhCzicNOuPiA0tKdMwfVAEY6lXfnkfxkh6OUvpkxGo4ApwUhNyFJIUtLKfE0aLcZyAPsmSTEKKZKUrtq91805NEixUIy6xbYQBP045kO8VRhMN151hZF2g9oEOuAPhK0d+e78QKPcZl8VJCAs2K1zIuXlTiPyk7J5EJouet7D+FGN/gyzNPaNdyF/eo50JWe7tNEM+lQQe/RjilTqxkW+YIcIQsgk8J6eeqC33bmKlCOraaGhXq9Y6sO9vhM+kvkrMvcpJlNP74cXPNDtMpZY+aIRAD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/24/26 3:52 PM, Muchun Song wrote:
> For vmemmap-optimized sections, tail struct pages may be backed by
> shared vmemmap pages. Those shared pages must carry the same page zone
> ID as the struct pages initialized for the section.
> 
> Warn in __init_single_page() if the shared tail page has a different
> page_zone_id(), which would indicate inconsistent initialization.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - New patch.
> ---
>   mm/mm_init.c | 3 +++
>   1 file changed, 3 insertions(+)

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 1650d6bc1211..bd02e8d06965 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -609,6 +609,9 @@ void __meminit __init_single_page(struct page *page, unsigned long pfn,
>   	if (!is_highmem_idx(zone))
>   		set_page_address(page, __va(pfn << PAGE_SHIFT));
>   #endif
> +	VM_WARN_ON_ONCE(vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)) &&
> +			page_zone_id(page + VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES) !=
> +			page_zone_id(page));
>   }
>   
>   #ifdef CONFIG_NUMA


