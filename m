Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B75FFF886F
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 03:03:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B6D76B009E; Tue, 28 Apr 2026 23:03:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78DED6B00A0; Tue, 28 Apr 2026 23:03:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CB826B00A1; Tue, 28 Apr 2026 23:03:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 605FD6B009E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:03:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC9BC1605ED
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:03:31 +0000 (UTC)
X-FDA: 84710097822.03.7C3D431
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id 147D3100006
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 03:03:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGEDJbIp;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777431810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rVdIF5xMMbMuztmqCdOg6Gne4HRwdJsr6QDFaBOJNgA=;
	b=lKgK3sIcoBShM2YgpJWdx5gF0RAHi56UbgeAXt30TNyuyp1rzcyX8Qvoq5ESOQNKoQpa2A
	SrCY8iZqkatj6kKbpwxEK5BVtWuxxF8l900tYn7w+2J2i1vIy5bp6g9uJzOTU4rtmHg72i
	+kq8WEbJKl9Bueyz/i8qH+8QkBfDoec=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DGEDJbIp;
	spf=pass (imf14.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777431810; a=rsa-sha256;
	cv=none;
	b=J44XfbxfHvYbAamEKlegKIE7twoGgZ0391aEJh+JNdT7mURvI/xLo0vHSFr0vq0MppKHfi
	YHMaNM5gg/eSzaDPuInAd3VxrPnbp4OgUuyUKDr/2EW3lr8uRkNb59r49yvoCyDHfuMMDz
	ARrCR6LlQTXQAB77nCH6ixh3jGuB/QI=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1777431808;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVdIF5xMMbMuztmqCdOg6Gne4HRwdJsr6QDFaBOJNgA=;
	b=DGEDJbIpy7JGrpJ59uRvmyWQ/+oc4LxI28LHP8B9Ra69Qv+7lS7boZ1Xzep4QMP9B6i/OW
	BFhKEhdpsJ6o+T2i8BGqENxPbqRMQh1DnhZg2CUpl2lTelQMthpw207HvXyrmA10mtWizu
	UQzVlpvn0F4A0q5MBdSB0nfKcttgSTE=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.500.181\))
Subject: Re: [PATCH 11/49] mm: defer sparse_init() until after zone
 initialization
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <afBepGBqlKTyOFob@kernel.org>
Date: Wed, 29 Apr 2026 11:02:42 +0800
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com,
 joao.m.martins@oracle.com,
 linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <DB04EB19-B371-497D-B2D3-C8564B127CD0@linux.dev>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-12-songmuchun@bytedance.com>
 <afBepGBqlKTyOFob@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 147D3100006
X-Stat-Signature: bqwsyszjf6wpsh8e6jzz5zhmqt5p4zra
X-HE-Tag: 1777431809-191181
X-HE-Meta: U2FsdGVkX1+1P3UyZkBJ6z+0gWkE7rsmuRGPbEctSiFwDpB63ql3rvJyXtAIr0B2280R/YqWwa91p3RBFUKGkXNZmYqFBPDVCTQqgIY2RZDyWd4WPGoY6LTdVbP+VPq/It6WpJlJr9Q733XZnemrdWjXiFpqesfL2/W48S20WZTGG/ywdII7SdODxiXEBuzgpWTKecc+lb18RzsjIOi0JELhxRu34qd/243+D5zopkFCGJwYVTUaTRYrECmZjEAkqDYDu6qNYV+17cM75nJwCznkHQeR2E/DBJrjzflbIUZ/E3FvcSz/YtDf4MYJYgcx+5gu5zNMcF19WnJ0QKJOkk7ZwEKThfW5m32Fc6So/EDUMPMKeYYUU/7LYWtSa4Awqxl10/r3kQIUpATLzVUqXDUTzfiJ10OTgD4HJCBwyPZQtNZkN0KdFsVKFInCYqi1wvcvVmRxZLw5BGYIH7KDs1BU+ANC5yxaoU6CQKKoUt1gUiLk84W6SPyzMk1nYj0QozCbvBtALfn9Jg9rpKTJF2FuB+1Bt/jnEjPX8mqBa/GxJCKA7QCEG/DxEljJVWyWGotUw0e46n6d6Jp8yiGx7Sz7fK5IaEj/tNAq7AceEyNhjCEybV7GjT+ch5AwlLxdoA09eU2JjVOvXagOVS1kYbd6tCBF4EXcaSqMhcV9eGPuAEzYJoNKvBlTSPCn0jcFW8lD4u6jtqP4R/ZVcCH0ZL9+xqaGof0/NAFwpZUK1hR9okIqirM76JNWAmhdLr5x0GrR7hl9lMLlR1jaI5rdo3k2un93CD95DNJpBQ5ahtyIIvxj33FVKmfqXa56faR1nwjEX1rO6kg1bs2EIupt3NxAluFAzD2kQyU1zaja5/3i+F/ge0e9s77nrTAHwLKrfzyMbJxttHRl8osJvVtxLhefa7Ixbq2vfEW8x9mXenzSN4mKSiAV0YThAni/RfBsX58z57PV+FyTUfXIozI
 0P29fI00
 arA5yLFPliO+1AXuJaQyxThlTG68m/d0dEOwzqCgCzwyOEkWlRZ+VaOwkPFQRYK8kMB989Ki9u5J5fZ1TwHEcE2nv8tWSI401fyArpZVZahNuPf2CQh9GPsbIjQszEAWNmaRMB/EuoC5YR4zvMVWMdqGsj9h8EU3r2zAd3qc9tVB5BcF6CF1SaaxlewX5R3pm3vbwDCjRkGZ6yTZDCUQHviWjUn7Ctbk4TYBrqDNr1Q3v7gEU2pGq3m0AlCWoQ8FSRLNXPLI5Ze9xEDLIA/20UDuAGCWcxcfb92F0nNxT53Pc+P7C3ontc8+oWnp4FUbljPLnYRf1+vi9FJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Apr 28, 2026, at 15:15, Mike Rapoport <rppt@kernel.org> wrote:
> 
> On Sun, Apr 05, 2026 at 08:52:02PM +0800, Muchun Song wrote:
>> According to the comment of free_area_init(), its main goal is to
>> initialise all pg_data_t and zone data. However, sparse_init() and
>> memmap_init() are aimed at allocating vmemmap pages and initializing
>> struct page respectively, which differs from the goal of free_area_init().
>> Therefore, it is reasonable to move them out of free_area_init().
>> 
>> Call sparse_init() after free_area_init() to guarantee that zone data
>> structures are available when sparse_init() executes. This change is a
>> prerequisite for integrating vmemmap initialization steps and allows
>> sparse_init() to safely access zone information if needed (e.g. HVO case).
>> 
>> Also, move hugetlb reservation functions (hugetlb_cma_reserve() and
>> hugetlb_bootmem_alloc()) to be after free_area_init(). This allows
>> hugetlb reservation to access zone information to ensure that contiguous
>> pages are not allocated across zone boundaries, which simplifies the
>> hugetlb code. So this is a preparation for subsequent changes.
>> 
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> ---
>> mm/mm_init.c | 15 ++++++++-------
>> mm/sparse.c  |  3 ---
>> 2 files changed, 8 insertions(+), 10 deletions(-)
>> 
>> diff --git a/mm/sparse.c b/mm/sparse.c
>> index c7f91dc2e5b5..5fe0a7e66775 100644
>> --- a/mm/sparse.c
>> +++ b/mm/sparse.c
>> @@ -406,9 +406,6 @@ void __init sparse_init(void)
>> pnum_begin = first_present_section_nr();
>> nid_begin = sparse_early_nid(__nr_to_section(pnum_begin));
>> 
>> - 	/* Setup pageblock_order for HUGETLB_PAGE_SIZE_VARIABLE */
>> - 	set_pageblock_order();
>> -
> 
> This does not seem related to this patch. Otherwise

Right. I will move this to the following patch as you suggested.

> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks.

> 
>> for_each_present_section_nr(pnum_begin + 1, pnum_end) {
>> int nid = sparse_early_nid(__nr_to_section(pnum_end));
>> 
>> -- 
>> 2.20.1
>> 
> 
> -- 
> Sincerely yours,
> Mike.



