Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A603CFC295
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 17:09:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1106B002B; Fri, 21 Nov 2025 12:09:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 978F86B002C; Fri, 21 Nov 2025 12:09:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B5A26B002D; Fri, 21 Nov 2025 12:09:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 790766B002B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 12:09:26 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E7D0BBA743
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:09:25 +0000 (UTC)
X-FDA: 84135250290.08.43A5BB9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2A9484001F
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 17:09:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ODepD5DC;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763744964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwAcWMplDqNL4zpiZZqIc8wNhnOOOAO06Vg7iEtF0gU=;
	b=zemOH5dSKcnLJGTvswRhFSUgJzQNp6PazgzDszIOR751xD7i3hRlro7Doidg83eX18GEzq
	ruDC1G7zVfNmP1Tw2FYENkzSFT5iqcbEgsqn1yCI8N8HQePaj/BaZ5HbkiG5G4v9Ozar/0
	qW3w1w1dm3Fl0V4ZTS1GRclxRkEdi7s=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ODepD5DC;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763744964; a=rsa-sha256;
	cv=none;
	b=8QBQwvyKn/4SLI4shIILSV2gKN+rvWoBEfu+y/7+zzDKg5rAb9nTEOXQjZIHdvF/Sk8103
	UMNtur53Lt/AG+mEfEN3DHzO6+X1BieLsTJuF3W3IJHPAVeS9WM3Q/g83Rx8PBoBqlmgUF
	KBq2qEXdvLxkiU+ZIA1yGyDssed1Rl8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C31EF4063A;
	Fri, 21 Nov 2025 17:09:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8246BC4CEF1;
	Fri, 21 Nov 2025 17:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763744962;
	bh=wbtbUmI+JYBD2T+C4kTcqxXZdRf5waIyL5iLdAIi17I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ODepD5DCIv5oRt2HVCh5GwfvCEkSdBsa9KK7pBqILQdKuNbSqMeSJtIi/PaTKYmVe
	 KJ45zZjgb/1Dkmu/Xu3M+lQ5kjQpOGKMX7opaOYWO4HABkS11L2YMUS5sxtE4Hx2R1
	 q1MVVEqCmnHhyOCHzhkTpB9OSdPvu9jEb62+5sLEu5lO7yy4K1nuRg5KfWqL+Mpa2p
	 WO8uifpeuNXi5CJMvIB2upXpp1NPov2CwTCmyvBjnu1qxLyGtmHwBud8qDK4snUE9t
	 dZreWNmiDJzdonAjkfsywN9wmVbBsav6MlxrmLqAvVbDm17sglU0PNsu0bGy6NdR8C
	 ZSHfquPmOps3g==
Message-ID: <fa8c3018-f4a9-466e-af4c-6f97e3247b3b@kernel.org>
Date: Fri, 21 Nov 2025 18:09:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] mm/huge_memory: prevent NULL pointer dereference
 in try_folio_split_to_order()
To: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251120035953.1115736-1-ziy@nvidia.com>
 <20251120035953.1115736-2-ziy@nvidia.com>
 <875584d7-5a68-4f7a-8549-2a9cd6c7f9d8@kernel.org>
 <FCFED9E9-56A9-4260-8B42-D0BCFC83C506@nvidia.com>
 <c29e2ec1-c607-4467-b500-617584c8fb6c@kernel.org>
 <73075A18-3C07-46F5-B8C8-9018D2CD22DE@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <73075A18-3C07-46F5-B8C8-9018D2CD22DE@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2A9484001F
X-Stat-Signature: aamt85ezen75jehyjhome8ygqc5sfhnj
X-Rspam-User: 
X-HE-Tag: 1763744963-774893
X-HE-Meta: U2FsdGVkX1+eLKI8UVomzbSqO1KYh+M/aEyEwm8M27KdcQc0rwybxBjgJ3YenVEvgRjw/T+RK26vdAYFEZBEjcGxxegJTAeMZd+fka2mMFOrZ8ALHXDwReNUgCC2aA+E4nVcWplzY9kL2fJOPL3Vo47vYa/3JniTrrztomRrsf+XYskl8E8BFk2fdmGcfJEBRQmv4MhE0alWAouishHrCq79d95sEzfXaAWIGPDWGVgdIAveJxnzQFQ/OYWar2g3YFgg3CgQlVu8IewvjeYtCOf9ck/Fng6RnOu7AXsSxoEws6nbJU7zdc+9wX18R9bA67GTg+V05D91C+aGvtUvJOfghERkLo0AjTU9m4WunSAc1jGnUM7RL8cT43D25u4w2xMRJKVosHw7hv/3nACIT8OWI07QPuOSwzOk5LoPEWXoSS1bL1Uh75dbkb3tUuJT3yXhCObWZzCdmj8mCpJk9tTL1ghBASuePhKYUQSxeg/Q5NGeUQKe3NsZjJX6MElmwVjE+NR4v5umZQhC4WPrLrpxULif71Yqi1OFjv9S5rTUGcVwEzL3PtDqCFkKEuT2l0S2yzBAcb/uOAz3li+X0B0LiRrxphxl3Vluy6P/vQe8G0UD8jfh7kadXVgiJhUoi+kCNhWe19w6E7tYMmFblfc+aUAOfJ2HSZdXJlR4PK6Shd6yXEqMd7HC5Mc6zo0D7/BnEri+4xNYLCN+b7a5HHrxguiVq95zJOw2+tKDTB4KeGCxE26UsGY8Xrdqn7AKWsmua1t1tbqbfX8Ut6G+esKz56E08S6x+L0nocnlgWUgHbSce212BF2OOHLt0gCQbvc//OoiTv8tBOEkqxBBTNzF7UxGbXzNEPEKM+c2K5nhK59HWo7lqiT3gyaIp8GHEU7aIivc1WnIhsdJ5YjNXQSdQXO/HAM6yFBThSY80+t2Zemq6nhFot60KCCLhmMq/1H24IS8EJndy/zmjqu
 B6dpUIBW
 Elc0gM2vUiV7htolzwTHeTltDAuIZYpoP9jgTXt8UX7LINJ/szC2S8AwRLQhs31UCfVWQ2fYYYhdy3EFtF9Gu/WbZAM9f2T0MajsxX8liMAY9iMy52Dd89rAjCHxsNjqWNPT7oDBODWOd3mnnkBxMqQb0hFuUato9LARTI2YrNj6sN6w24huY1KeuoSd9JIWfYI4pyvsOMbUqmT4Yn8IV3TN/k5MFrs1yQENpx32+uICAYMRN9bxBJAGy2K2aK8JCJI4INvwYM9cOnfiOfWrc1UeYMng3XBwm+u+V9uKULBZ2ACQRPD6VTYouIBiVC+xqaU1z2OctAlACyX1X7Jlfm58tv63fj4QIopqkt6TTHnNNtuIrsm16EgAqgneTn9hKxpLz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> BTW, I wonder if the is_huge_zero_folio() check should go into folio_split_supported() and just return in -EINVAL. (we shouldn't really trigger that). Similarly we could add a hugetlb sanity check.
> 
> Yeah, is_huge_zero_folio() should return -EINVAL not -EBUSY, except
> the case the split happens before a process writes 0 to a zero large folio
> and gets a new writable large folio, in which we can kinda say it looks like
> -EBUSY. But it is still a stretch.

I see what you mean, but I think this has less to do with actual races. 
SO yeah, -EINVAL is likely the tight thing.

> 
> Ack on adding hugetlb sanity check.
> 
> OK, just to reiterate my above idea on renaming folio_split_supported().
> Are you OK with renaming it to folio_split_check(), so that returning -EBUSY
> and -EINVAL looks more reasonable? The benefit is that we no longer need
> to worry about we need to always do folio->mapping check before
> folio_split_supported(). (In addition, I would rename can_split_folio()
> to folio_split_refcount_check() for clarification)
I guess having some function that tells you "I performed all checks I 
could without taking locks/references (like anon_vma) and starting with 
the real magic" is what you have in mind.

For these we don't have to prefix with "folio_split" if it sounds weird.

folio_check_splittable() ?

Regarding can_split_folio(), I was wondering whether we can just get rid 
of it and use folio_expect_ref_count() instead?

For the two callers that need extra_pins, we could just have something 
simple helper in huge_memory.c like

/* Number of folio references from the pagecache or the swapcache. */
unsigned int folio_cache_references(const struct folio *folio)
{
	if (folio_test_anon(folio) && !folio_test_swapcache(folio))
		return 0;
	return folio_nr_pages(folio);
}


-- 
Cheers

David

