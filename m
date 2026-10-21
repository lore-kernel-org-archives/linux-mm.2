Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D4877606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 02:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=KnZygorN
Received: by kanga.kvack.org (Postfix)
	id D27526B05A8; Tue, 20 Oct 2026 22:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD8256B05AA; Tue, 20 Oct 2026 22:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE496B05AB; Tue, 20 Oct 2026 22:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC8D6B05A8
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 22:38:29 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2DB69A7D2B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:38:29 +0000 (UTC)
X-FDA: 85345074738.19.909FE75
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4484640003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:38:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KnZygorN;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792550307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3um0oSkFchI+VCovec//CZdEMgzXeLCw0E3DOZkZLFM=;
	b=aSYBx59qfSdDxefYTs3iZd6my0SEJlZQjFq7Ni1kbKRMMrTLxcTb0WDn3w1lDG2r1kHZ4i
	iNLF1SX4cWWwaDmZ/lu8WWo8KjrG5fkreLmxwgtAzKy37qpjaW7hcWezLOAorVuCnBSRUe
	2ieDSxkWiCiqgMpX0WbtkHT6a8KI8z8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792550307;
	b=O2AGGwhPIn9RfWhHOMWc7ZGgppeuBCBt4rNSVwD9OZFWGDCq/iWU+MMs+vIZL7UefRGY+Q
	Do6y+cbjiHIYln2JTPIit99xQakPF/GHE1c/zpHBif7phWcshfudGTU0MJRy36rVHyf5kN
	yfvHIvZvjKOFzx6dyv9Igpx5T2gGJXo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=KnZygorN;
	spf=pass (imf11.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792550298; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=3um0oSkFchI+VCovec//CZdEMgzXeLCw0E3DOZkZLFM=;
 b=KnZygorNvUDC31e41SbkkHNOHcDVkQUtxHE7QIaAilN+Xrtg3MOGhJQCGd1244FNHb4DxH
 fSkgJcPeHQi82+1mU/8C+c4EXFi6x5kXcPXuo6bou3hhpgvrPXdvEoE4gaYvlzPAPGfOLD
 NjdtSP2xjfggH/Ka+CAIyQOv+K0FRoJ2afLebGYlDqrCuO+QU5BCrrFVHG8uYdBYnwb1r6
 clEoByIUdJHgOqMus528jYmuPVojq8n1aFZCs3+ZkdrNo7KVYzJTYU6yurak56Tf4Kq3fi
 1iBhu1buvWkPvgk/vUfH/f4r3wZDc7Wltpm2Gg7rBMPCaixhAhrLIsmC5xIC+A==
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ad82598+509b36+kvack.org+lizhe.67@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 21 Oct 2026 10:38:03 +0800
Message-Id: <6d3aafde-9082-4c74-bf50-a440671632bc@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH V2 1/3] mm/hugetlb: fix mremap move length truncation
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, <muchun.song@linux.dev>, 
	<osalvador@suse.de>, <akpm@linux-foundation.org>, <rppt@kernel.org>, 
	<peterx@redhat.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
User-Agent: Mozilla Thunderbird
In-Reply-To: <b6d4de88-cf2c-444d-8050-da2a9b22c7b9@kernel.org>
References: <20261019113034.97690-1-lizhe.67@bytedance.com> <20261019113034.97690-2-lizhe.67@bytedance.com> <b6d4de88-cf2c-444d-8050-da2a9b22c7b9@kernel.org>
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4484640003
X-Stat-Signature: ccrpmg9qyqgguj3xsp7jorcynxchs5or
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792550306-125863
X-HE-Meta: U2FsdGVkX19XhBUFbhrBMCvzkjwfxsQKQbN34/xSGoNpAkxx4PCinlzK9Z1TFXe8HEnEuwYwRNy/Nhaqj1JB86zqHwUYGTZk6bZZe3torecn5vnpwJ/6Nqzsl7OVUBVzLUCrE2qVYT02dKRHVAm48e2gcXOLlJA15AlLdEa11FVaT8A159+n4xSbLaUDkm/DI2Uq1Co9YPTge1wJy3AfqGaZ/AVDGu71hUoLqg393ifgP7ic+WHtmoxIGWW3s0rUx6KlSw0sXO4dkI9Sp4qqZ90c8e2SCAFoGpc35RaL4kF6Vzg3+ojcyUXrd4pK4U6QXDo6AfWBibMKCSqvh1R4VF0TsbEvUkEzxrzgOjJFMMptC+sMDrK2sELy6U2c57qC56+/jMsRxXMmoINb/wqOVm25Mf2jV2Y4NCfH4VSMB4FsHIpBLFzwCHstwJ7V3cb8o/ebR4nFyK1tg2Abd3Lu+Uv8Pi7JovHzOGILe1KzcBZDz+R+5H7jPQcnhAKXr2SRFqXeLV6/FAVWr1x4UU5xv3H6GEiY/HFmqScpkbTniT+nO8Pk5D64Lah8L7i7KTwavM3nr+wxAa4KZleOv0au3TEyFofnoisD4ZaEBz/sIwopbS87YG8Oy+j48KYVHKmAilpV4rAjx4ZfQCQqPb9cAbPAzTKlkZo0GATnjux0tquuSlsg/ZKYV4WJf3uInBx4s24dNGrb9sYRoF3KRVWabbTu4znyOrBRcA483gCox6JZ14XmZmSDjiIn3ANJ2i9YCDB8zW0kDo0LgtcZuOC/ydSAlY19+3vT7mxox1bzguzd6zMBOXarTOiy1I8UwO+TrtwtA2ghQcYlScE27JK05CNE7DRwFj6VghFSQu+TMRD/U7WfvHz1gJZVCR2reg5ScH/Kb50vGyzLoStP2OxZRz97r8mZ6R4wC/sfv6vG6uH9W8c9cgtTGAbqH1gLYQgRqyFEmgOgPrvadvY3AS8
 mmdyL3jU
 A9LOM2RWHwgRf5fVLOC15lGPgpcBZsKVss0qe8BFfp3jjPPLr825pul+6IppxfURZf/vCxcRTJJu5fm7DTaIFp6S1XT1Ib0HC5ufVie9KJRqDZTuJCF/0lVcVSTujx33Jca5GmXz+F6DXqKbTnrlZDhALhsw8E8+HUdmhovOMjQv5O97pF54ChJFmDrg8NEZOClNXr2hjzPK0JOklMZ73H5YHNWFRhtf9F2waM2eyK6jKbDBdWGfj1nhF2s+it6vG3AOs9EMGa341xSKPVglwakkZjTmE9rRfpQLMLr2lPfq6cAV9Wm1AIPMW2wWE8ykQwFE5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/20/26 4:18 PM, David Hildenbrand (Arm) wrote:
> On 10/19/26 13:30, Li Zhe wrote:
>> move_hugetlb_page_tables() returns the number of bytes moved, but
>> its return type is int while the generic move_page_tables() path uses
>> unsigned long lengths.
>>
>> A hugetlb mremap() move length above INT_MAX can therefore be
>> misreported to copy_vma_and_data(). The out-of-range conversion to int
>> is implementation-defined; on common 64-bit builds, for example, a
>> 4 GiB move can be reported as zero, making the caller treat the move as
>> a failure and use the wrong length for rollback.
> Sounds like we want to CC stable here, right?


Thanks, I will add Cc: stable@vger.kernel.org in v3.

>
>> Return unsigned long from move_hugetlb_page_tables(), matching
>> move_page_tables() and preserving the full byte count.
>>
>> Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   include/linux/hugetlb.h | 18 +++++++++---------
>>   mm/hugetlb.c            |  8 ++++----
>>   2 files changed, 13 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>> index 16c4c4caa126..cc12040e4032 100644
>> --- a/include/linux/hugetlb.h
>> +++ b/include/linux/hugetlb.h
>> @@ -121,10 +121,10 @@ void hugepage_put_subpool(struct hugepage_subpool *spool);
>>   
>>   void hugetlb_dup_vma_private(struct vm_area_struct *vma);
>>   void clear_vma_resv_huge_pages(struct vm_area_struct *vma);
>> -int move_hugetlb_page_tables(struct vm_area_struct *vma,
>> -			     struct vm_area_struct *new_vma,
>> -			     unsigned long old_addr, unsigned long new_addr,
>> -			     unsigned long len);
>> +unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
>> +				       struct vm_area_struct *new_vma,
>> +				       unsigned long old_addr, unsigned long new_addr,
>> +				       unsigned long len);
> While at it, can you convert all these to use double tab indent instead?
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>


Thanks, I will fix the indentation in v3.

Thanks,
Zhe


