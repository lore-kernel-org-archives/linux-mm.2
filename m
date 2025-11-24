Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9022DCFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D52D86B002A; Mon, 24 Nov 2025 05:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDC906B002B; Mon, 24 Nov 2025 05:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA34A6B002C; Mon, 24 Nov 2025 05:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A027C6B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:43:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 322C558434
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:43:12 +0000 (UTC)
X-FDA: 84145163424.29.E9172BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8E2A61C0005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:43:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FhkI/+ir";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763980990; a=rsa-sha256;
	cv=none;
	b=Lt/eR8NEvOwIOxZTgNMqjiL6D0kymbL9JPQjoxDAlPSb3F/a2b4y8uzJ0e3zUXe29hQJXA
	8BpdoqYakiawlHV8H0dHr8X1YOm77nOjaDokb0p0r4Wr6EV/Sz4hHTywExx48n+rlV0zw6
	X2MR9qq5DMsvMWZ74LP2yoR1ZkwRbvQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="FhkI/+ir";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763980990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIevBit2LsYqWr+//U2F+2wvKyXvcZUoDycDBVMPR8k=;
	b=l42jqnHyYqhR/gQnXtO2zIQxy2jCt8O7W84RDcIBXDGmGd4pl55eN4FkDzVgnmm606GZzI
	8o9jeaXWOFmEnlHUiTsdG0vgS2huMCukiQUjvbx03YqSbzPWwd5W8woXwXRTFf/3swx1JG
	TyLlfCYCRt+LzM2pif9QmKu2G218YO4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 09AC66016A;
	Mon, 24 Nov 2025 10:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F97CC4CEF1;
	Mon, 24 Nov 2025 10:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763980989;
	bh=8yb/Zh8IAsTuyjN2fF0L3+H/I8uGrHqhJzE3awGGxmo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FhkI/+ir/Y5bu4smkD5Dwiy9+sPSNUS/9fjx2uGPQ6n0JvQh67miHY4FSU8MEIKgO
	 amkv+wUp0mylorizSl0Pb4QmzLWVKpdEnBuKNfudku/Oez8D7WtlAEJ1eEUeIyFnhB
	 CC77P1EYfJH8/puLaX1si83dJrEpDIH0i4Um/8KBXVx31RRjsfAc5V+rDskmrHiBl9
	 1UTFas2ELYz8hA/saYlmBaqTivJ2nP8Q4p5shN4T8htWyMeco1Ow2Yoj3uopulzicA
	 3UdW1zgTQMTIM9/m38MxRHcWJdMqunYrb5Ca5Rao2c/bxs+5W1msWTA4cMydYw9x9U
	 JzlUeGdXQGVvQ==
Message-ID: <257c778f-1997-4986-8a6b-ae42bffc46d6@kernel.org>
Date: Mon, 24 Nov 2025 11:43:03 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] mm/huge_memory: make min_order_for_split() always
 return an order
To: Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
 Balbir Singh <balbirs@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251122025529.1562592-1-ziy@nvidia.com>
 <20251122025529.1562592-4-ziy@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251122025529.1562592-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8E2A61C0005
X-Stat-Signature: 3tqqwkz9edmb7razwye85njnkbekeqs4
X-HE-Tag: 1763980990-544801
X-HE-Meta: U2FsdGVkX19ztanZFjw9CFNiKUwxwTtJK5SrlKNqvHPym6gKoDxjJ68G4KhZUZCjUyGVEQIbt9+j0R+G5fEDMxKWLcZaPZwvr6BOPZ+I3R57L12UwyUFpiImKy76cctDU9o2416mW3irSdZWaxi3CNUgDPrqkFmup+R8+XnboSEprbYzd6JjpZWIUHo9wOZcXCIpyrkKOhHtXCxSryinSvJUjza2cELwzqzPpcFOXtMfKAZZUHqxzvIdz84UO3nHTBn3AVrJdIqszyj/KMSxk8j9wZU6wEiORMwJR1qnRUG+ebVI+XgfRN+EB3aKCxXEXqBFZRTQynpmBcY2l3xTxnkqzJelH9IAMcFmfK4uZz56Sq/7BzKpghE6NcR70ZlKslR/qz0+lxjIUpn/+P2X3dw/uHoPONwA1k2KlvonJLWz3UNpVcgRfN9y61uMldkZwIq23CpsiFjj+3g4qKJ/2VeOvfKfbaGWm4a+dCrRAyRayIFk3hdO1Zk4RK+++BPEghiR0gAG+HXIN5G+ng4yMK+cKe0SJF+t6vWuuREiO71b7Ix0O6yHceceZwSRGyYkj7n2lWPMd+NhLZoZKvFAx51rJOAqjCtVgm7iBUtdDdjF9gitbwlxD5gOOW345X+Egy0ZOG+iw0/OJwd7DkEe00GFbHSMEvSvO1w+OC0jW31zJT5kBSH5xTInSrvvWNgZDQyjWKaVaPGAFVb1a5KBRX2fyjO18WwBoiJpitdJ2N3yZF+vnwtYNkEkuK0swRlXhW+iYFltf4v6SJBtFosoIti1VFmOpstcvuFjZDeaKmAIo2O9QiFxTsumY1zfsU0zh/3C+GY3dO8LkUG9OOv6AjBofRDQEuMJI5dQxVvtS7DzW59Bz5kOD64MLQn+of7dlCzXj45oWesZQ1AmnEI4iO9NASQg7JVct7BRaWU5ADN3EZJbbLQOCJvY/nsy8P+rOugRstxw2pHFEo5Ou6L
 I9DY0Zli
 IpvQtg915Ry5KcNpW5e+YpyCN1grq2PlC1ZGPgx9522RoaCuGAxjjgLz65LuTB/LvykIGeA3xJwXmI9CLjtHTqulOr4akuuX78a3ZlVc5Viq2gOCr2ykpicCLuzlgbE2hgvaa6HGbFJ5mQWnqi+g8zF+LUCsg+8xtgtldtKJYuN5Msu8KGoA/NavZKaagS3K4+OcMMVtV6/c2cQSOGZ2+15R73LJQH9jcH8mJA4xJZx2NJ3pFMzsZjIZH4pJ3s/v8G0Y1PjVHDY1xqm4p8MfAUzG4ZahdG/wNjp9SnW9ve7amZWqTrgk9cvpa3aW6oosROQEKbFgnxikq3egL0nGfyoP9/tIqT7F/Cd3M7dv/fDKTNaZDt/BEtX7fL8yswwAPMgjGJifTgXf4T6+uVZP/y354dLl3YIOApKX9i4ORD3wVX/Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 03:55, Zi Yan wrote:
> min_order_for_split() returns -EBUSY when the folio is truncated and cannot
> be split. In commit 77008e1b2ef7 ("mm/huge_memory: do not change
> split_huge_page*() target order silently"), memory_failure() does not
> handle it and pass -EBUSY to try_to_split_thp_page() directly.
> try_to_split_thp_page() returns -EINVAL since -EBUSY becomes 0xfffffff0 as
> new_order is unsigned int in __folio_split() and this large new_order is
> rejected as an invalid input. The code does not cause a bug.
> soft_offline_in_use_page() also uses min_order_for_split() but it always
> passes 0 as new_order for split.
> 
> Fix it by making min_order_for_split() always return an order. When the
> given folio is truncated, namely folio->mapping == NULL, return 0 and let
> a subsequent split function handle the situation and return -EBUSY.
> 
> Add kernel-doc to min_order_for_split() to clarify its use.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

