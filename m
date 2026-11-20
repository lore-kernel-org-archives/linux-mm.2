Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3282606A337
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 02:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=oSSHBxkz
Received: by kanga.kvack.org (Postfix)
	id 0629A6B0702; Thu, 19 Nov 2026 21:59:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013876B0705; Thu, 19 Nov 2026 21:59:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C9C6B0734; Thu, 19 Nov 2026 21:59:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C173A6B0702
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:59:39 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 474D91A0D1D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:59:39 +0000 (UTC)
X-FDA: 85453992078.02.3077DDC
Received: from mta0.migadu.com (out-81.mta0.migadu.com [91.218.175.81])
	by imf16.hostedemail.com (Postfix) with ESMTP id D9164180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:59:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oSSHBxkz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795143577;
	b=jT7OfElZW66AttqkVmdPsO6+EfDD9pVlxUmQhav4w7qDU1R4d/dtoKYZoQ2K10KAjohaDa
	HpNUVXKNuAlF4Y3WVPzVEwNjGdLJB0OlMnMQmLYEkiXdy2ytknOoMvxT92pLfpHQQB9xXH
	hf092M8gUt2uOg5zYVosE7VAJWvZnaQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795143577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fvu+xmi6UAM2iEO+qK5+UmYLpk5vCo6FIx3dU82MR8E=;
	b=lODOZ6gCqMVZEqa0FTvP0ws5Uc4AA2eEuhrhtmz6yQ8gkl/JLHnEPmQu7FHFUZRCHjTP45
	MKnoceENLZc+hZYsqhrvGY90vVK2UlE3Lk143P8KtfoPFV7CEcgqPqYXVrmlWk3u7NSRpL
	aUzS6b3bByBnB1Gz/jGs07S59IqxHi8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oSSHBxkz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.81 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xf1Ty42kwvSN/jnqX8X1h+tJ+g/k4LBm2sjhuEXhJYk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795143575; v=1; x=1795748375;
 b=oSSHBxkzlInc8+y/vBw+9o6iJl/SFY/CXEaSardW5xhMTA3dOeG7HV0CUE7PMWjEeCtLASBx
 P4FLOxLvb/a/b/Yj5qIntLCfhSDmJ8TrQWn212Nmg7I2fiG0Mnsv4lRvPcXQKf0reosWEq7kCBP
 szI2/fHhE+RXhW2yqIZvsXVU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7819671ee5c7563b;
	Fri, 20 Nov 2026 02:59:34 +0000
X-Mizu-Trace-ID: 7819671ee5c7563b
X-Migadu-Flow: FLOW_OUT
Message-ID: <aa414751-9913-43ac-9782-aa9043b77517@linux.dev>
Date: Fri, 20 Nov 2026 10:59:26 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] lib/test_hmm: fix alloc tag leak when splitting
 device-private folios
To: Nilay Vaish <nilayvaish@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Balbir Singh <balbirs@nvidia.com>, David Hildenbrand <david@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Zi Yan <ziy@nvidia.com>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20261119233119.1721789-1-nilayvaish@google.com>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20261119233119.1721789-1-nilayvaish@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9164180002
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: y5ghz4hpny9omcdxuqdojjwtwe8iyih1
X-Rspam-User:
X-HE-Tag: 1795143576-105047
X-HE-Meta: U2FsdGVkX1/Ys2TgbEhxEAxh6ckayWfxFf5sxvq6YeauFxKDWAHSSLoWyAdPSBpDRmMLUm9vNFkqNNVDrIek8a6VSvtQOad+9goPHAzcCNRB6/rblWIkUWczI1znb5RqwiSf6R0wv2XvtE16oVqf2OnvBWeXWgsyU35Nslvhta/ACJdzHmghbEuqDc560xKtONqWGaKqr95UAkPKH4A5tuh5ZBawCzIWT+0UjPixH0jm1HsxUJC6vXjjThF3iTRxIbvTfSgJ/PZ4ZdqYXJBA7tNj/8bvtyu/9pUt5ZSelJiBDT8Pdsic0fHCgXBISF1mhFO/KTqufHGFaT85ThLHnzTsI0E9ljZ6CHhkOTsxIDqkQC1z23HSJ91Dzo8T/xwQG3qfzCKLgAW5ydkg4PSqFDoqq92qS3zqMLrMWArMCCTOeZQf/s9n5hKtZVzpFaUUI1/76ntJjj6A791Ha3ZzfaSm61n7L5DFdpkp8pq3b2aoCNDhed2RldLxUpr4hg6cZHWEGUQP/s8NvKbY0TuhYloHjC2bBBz+F+qULlezvyUOR33l6PMzydy8RvrOhk8ZLdWcVZnwG4lLxg4LQPZ9fNP/gGDLUz3nOXlha7V/JKjA151UNU8fcchGeQ3PIzHTDpjoD+w9VObY9Cy2MzRTSW/xdheb5HDqXKkD/rfXGhp1Idra/T6xDUeoh1xiQw75FEyCim9MJryQkG7EscmOQtlY1nLOL0/I2KBQ+Pk2Fkpz68nKrH32H3b9xxvt98dMMMmbxppLLKXFCbFIVPDFE1GJcP6bt6K5GTRgNyd5bLWTmWR/Bb4EEqukeX7sXsL8/e+zWEbBfGl/EMqZtJmyuzdGGg2/MgU9lAzfZjL8Q26I5lFw7tV8wA/8NZQzRZYbRVj8ciWjZnCM0H06RS00qGnq51DyFnN1kGqwPsEq+AyhyBr/Cvyjok6R74yfvw/IwcVAZ+Gm34XJzjYvw7y
 oD402TDU
 nQ/0KIKDofI+Cip07Q8bxQZXSyUFBwTk4NLn/xq/sGRM86SERHdGoS/qhKghL0m8IKkdz2bh8EIEl+f+LOlpnUmYq+CTugxCBMMMGUEOnzm6b/+QjaRiEzKbxOinx3/XpD4+vJNaN/sGVMLXL9PJgdt895V311nlFALsZbs/olmC0iPpxWUBUXGuOd4UxlNUNEwBJbehB2NcKbU7QarZi9FKVZFg7L8e+IXBhwvoV+/57ezobVcytDy5lLWv2d1mDfrauEPLnX8YKQmSoVaxwHxXg0wVmPYgzwIyzY8pQ5V4RffLHw/ku+pMxoZN/Yk7wIodx1bEUQdtkGQCzWp9g4hq4NVDxr41k/nR94iCpTG+lBZSM8aJJ8e1gGSXAzstbD9h2fYN40QTkUd7mBALvBxJtZGHpK5O+gaX/Hj8RKKSa5AmG7YONSgZLrspWI1Pl/8yJ05OOEldphP8XtVNH4VIwu4A0Zgai/q1E++ANKQ8u1hVgT9ZbN+wtBYEx2fIL+XiCfSW8r2MDJs9MzOJeYB13UwfT0q4yvpCOZ+Lp2nkYHMV6/545G6nIoXD3vHiC59rVHeafj9ageN4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/20/26 7:31 AM, Nilay Vaish wrote:
> For device-private memory, test_hmm backs each fake device folio with
> real system RAM of the same order, allocated with folio_alloc() in
> dmirror_devmem_alloc_page().
> 
> When the core MM splits a large device-private folio, the driver's
> ->folio_split() callback, dmirror_devmem_folio_split(), has to split
> the backing memory as well. It does that by hand: clear_compound_head()
> on the tail pages, folio_reset_order() on the head page, and
> folio_set_count() on each of them. dmirror_devmem_free() then frees
> every backing page as an order-0 page.
> 
> This open-coded split does not split the allocator's metadata. The
> allocation tag and the page_owner record still describe one high-order
> allocation, and PG_head stays set on the head page. When the pages are
> freed one by one, the tag is debited for only one page when the head is
> freed, and the tail pages carry no tag at all. With
> CONFIG_MEM_ALLOC_PROFILING, running the HMM selftests and unloading the
> module reports the leak:
> 
>   lib/test_hmm.c:808 module test_hmm func:dmirror_devmem_alloc_page has 16744448 allocated at module unload
> 
> and with CONFIG_MEM_ALLOC_PROFILING_DEBUG freeing a tail page triggers:
> 
>   alloc_tag was not set
>   WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0
> 
> The backing memory is a private buffer of the test driver and nothing
> requires it to be a folio. Allocate it with alloc_pages() instead and
> split it right away with split_page(), which splits the allocation tag,
> page_owner and memcg state and is already exported to modules. It is
> still allocated as one high-order block rather than as individual
> order-0 pages because the driver finds the backing page of the Nth page
> of a device folio by offsetting from the first backing page, so the
> backing pages have to be physically contiguous. Every backing page is
> then an independent order-0 page for its whole lifetime, so
> dmirror_devmem_folio_split() only has to point the new device folio at
> its backing page, and dmirror_devmem_free() frees the backing pages one
> at a time.
> 
> As the backing pages no longer form a folio, take the order from the
> device folio rather than from the backing page, and index and copy the
> backing pages individually instead of using folio_page() and
> folio_copy().
> 
> With this patch the device-private HMM selftests pass and the module
> unloads without the messages above.
> 
> Fixes: 56ef39899643 ("mm/memremap: add driver callback support for folio splitting")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/linux-mm/be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev/
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/linux-mm/8ef6e92d-4cb3-444e-857e-fdbf88c035ea@kernel.org/
> Signed-off-by: Nilay Vaish <nilayvaish@google.com>

Tested-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>

Thanks!
Zenghui

