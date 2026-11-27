Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75302606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 18:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kxtuAMNE
Received: by kanga.kvack.org (Postfix)
	id 981796B05B2; Fri, 27 Nov 2026 13:51:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 932686B05B3; Fri, 27 Nov 2026 13:51:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F9D06B05B4; Fri, 27 Nov 2026 13:51:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 624966B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:51:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E7CFB80439
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:51:11 +0000 (UTC)
X-FDA: 85481791542.13.2906E9A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 259C54000D
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 18:51:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxtuAMNE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795805470;
	b=8U07rLpfhXrYPguPisEV1qvHL4u+hlUIBuM4Vv6af27SsFRL2aV/UnRU8GqUAeIV20sMzo
	XdPrR0GOEiDsO25qN+aOGlisoUfA1gevYEhq98nPN0DKDQrKNbsIciooT5doCMKB/SO65j
	OmMkH5WxFvUW7LAHpOcKZvyYHKNajZM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795805470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUPbdRTQ+KtTe4Rbzg/fr/c1oAIi674W+toxM+o6f4U=;
	b=vrOfRNasFgBcxSrqwhxiiNFdmt7oEQZ7ILketjm7xlktPstg3kaRwJhTNu2kJ1r5PxeGN/
	7aUcQdoJzMjeptHNjf0x2uWpdV6mNNZ9TbWw24pCUoi2ZwtTbJ+GKtoHwQjy2MhZUsi5aD
	uIub1T8QTsoOLl6VNhmIVd+d1R3h1B8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kxtuAMNE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0B06040377;
	Fri, 27 Nov 2026 18:51:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAA11F00897;
	Fri, 27 Nov 2026 18:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795805468;
	bh=IUPbdRTQ+KtTe4Rbzg/fr/c1oAIi674W+toxM+o6f4U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kxtuAMNEzEsMz/Sir3jzlsu5BcJrrfBIaSOV+nsP1lVr6sxjr7HuwQtsDPf6Iab1e
	 syAI/aB1vcLUBasfQZd/ARFlWZXbVDwEnwKj8G8iNbEwjos+VJnlfzLZYAWJyGyhS2
	 wIz0V+6kfBm48h3K+xHE4TeiGo4eW8x0JxJk+zHByHg6S6nwILj9rWYkJ580iaJaQx
	 3mMHvNjWSBrby5nrsdPuSVIRBjfJ2lGoD/HMv3kA8qZhfBFfixbqq59QPzLhS/LiFR
	 p9WYrjHLkR4arzzoup7SA38KbpfbGi2VkCx7WTY+hOYyHufnUEeyogjA5UVETc5SQl
	 SgigXIOYy+vDA==
Message-ID: <1793383c-1c33-47c6-ae02-ba12f2bad4e9@kernel.org>
Date: Fri, 27 Nov 2026 19:51:01 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/cma: reject long-term pins of HugeTLB folios
 overlapping crashkernel CMA
To: Jiri Bohac <jbohac@suse.cz>
Cc: Sang-Heon Jeon <ekffu200098@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Usama Arif <usama.arif@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Frank van der Linden <fvdl@google.com>, Kiryl Shutsemau <kas@kernel.org>,
 Baoquan He <baoquan.he@linux.dev>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>,
 kexec@lists.infradead.org
References: <20261125155108.24098-1-ekffu200098@gmail.com>
 <f79014e3-3c81-4b2b-87f6-df0c2d946357@kernel.org>
 <awnBTG3budAQqfSq@dwarf.suse.cz>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <awnBTG3budAQqfSq@dwarf.suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 259C54000D
X-Stat-Signature: 9yrwzgbhb69sc43tcnmmj5k5hbyfcqwt
X-Rspam-User:
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795805469-790757
X-HE-Meta: U2FsdGVkX18wKAYeWU5DvhYYLGNLnJkhBU+BFCXrcCJENSntvFckWAuiQh+mTBUs4bbHFcsfkiObrvGneKRSeU6u+Q//vAjcD2A9ZXrcTsnSoRIsqjbqAjuXIR8fMRR/p5slZ+QtAURe8lUUlAtq58yOWMBwps3SyMaWiB/By+8OkzM+MDl8NiLEfEu7CYVJDcwqh5FR2jzv6BrxlPkwrcnrpVODYqp9iP5BQAe6TtpApcgHA2D6+uWjAtM90SRhwblo0hNKt7/5N3vXi8vLG74klBGJO6+UYcE0md8Kmr7H1FD+8MKBMfRdCs62TfW+k0ZhtExxhVk4IImiSRVwsnK4f7+G80MBbKbK+wmbYjj7HSL/DNAIK8pdeGs+zawyL5UvAHHcKDTgM7x7XVMKmpm9rkfX6w4Hv1gns5kXITRJJkwHDR/xdiV+5lGQlrQ7YgWGneLdfRmJpLNk+1bWWdfifzUNX+Mv8ssQSVUZn6+Ua9YaT6gxWk6Oifpx7d5UVmTmy8WYRPEbXkR5v22T4s05+k3KqDqVwBG3wnvd8+Dw94tj07JOFayYbcMsIMWw3PXXb4BlS8BI8WEFGoMCYOXNiDH6L/I19rs2ODx1PthDf3Exs1ZGGu3318VM2rdLcyfrdHMWzOC/9TVtJRjk44SxpVTSm/2S+8eZJAL7qxmpdQJ1o6ktWyv8nTBUtHfCv4zaAXYBEys/9XIOLWisLg09owaStuNQE8Mi65w0KwBBpKJ9n/mgnbEiJ8dcUGTITaJa3zOpM3b93NLHaGXWdPd2k8HgwfyTUiE7QMTfbhq0yz0DBC6RBUyB6pe6+5+beNYTQePWu0iC8fE5mBNZU80L9jsO+9vCy4x6LVQbij5Tqsq1CDoqSJ7XW0hi+i710tPtVDBNqx9lt5K02nyhprbJvmSzGx6Y+e/vKBRDgRRccm/IWQIwyFVb1yzusIvEz5MsbH+ZIQ2Nhu9l3Fj
 MCN0NgLk
 /h/T1iYdjANkaeqHXd+1JIPFxhr5RKNNTWNJ1FUeHof+1mIinUlwT7pUuDv2BRuofTe/zzdpOXjVjOh1jK1hLWkVggjOeXkJzp4RXXPUCesdWo5l713hr/ID5pjSj/988vj+tB5iKxNzZ98vcyDzkJ3F1APtS9IrikmdivTENPXN+fzFU4JPpblJebzxTQq9fjPcR0gK+Wxz22cpo53cOWSxWFCkhKxpJaaC8ixlHJkHDTyMSgMiZzLzeTskt9GwqhqZjaLLw9sYqTVY7VpRxqmBLqXoSKh2uEqx2t//doM+1udkccckoIpUd2cGLqGU66FzBXkOXDVBh9LdCRc1UYM8IKeUdMoXEDuap/OUI7f+xIDxCEomJwHenXLENE5zyD5lzdcMzRPnS0ViINkN7ZXxwVIUYyK4YaFmvlwt8XKG+r2YKM5sZ6Zb5zeiux+AEqkDkh3rC+lpi7/V4sNgpzeHjzkeM+2P6QVCQHAQD2EzGNBa7bW4ziib399vCSI5LQ3K5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/27/26 18:43, Jiri Bohac wrote:
> On Wed, Nov 25, 2026 at 11:43:40PM +0100, David Hildenbrand (Arm) wrote:
>> On 11/25/26 16:51, Sang-Heon Jeon wrote:
>>> crashkernel=size,cma uses existing hugetlb_cma memory, so
>>> crashk_cma_ranges[] may contain HugeTLB folios. HugeTLB folios allocated
>>> from hugetlb_cma can be long-term pinned without being migrated.
>>>
>>> After a crash, the crash kernel uses the memory in crashk_cma_ranges[],
>>> but a device can still write to a long-term pinned folio.
>>>
>>> So reject long-term pins of HugeTLB folios overlapping
>>> crashk_cma_ranges[].
>>>
>>> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
>>> ---
>>> The above scenario is only possible with the two patches below applied.
>>> Currently only linux-next, which is targeting v7.5, has both of them.
>>>
>>>   "mm/hugetlb: allow crashkernel to reuse hugetlb CMA memory" (kexec-next)
>>
>> I think that's a real problem with this thing.
>>
>> The solution is not to disallow long-term pinning. :/
> 
> This patch does not disallow or break the long-term pinning. It just makes
> sure the pages are migrated away from the CMA before get_user_pages pins them.

It disallows long-term pinning.

So you have to migrate.

Good luck migrating a 1 GiB folio.

-- 
Cheers,

David

