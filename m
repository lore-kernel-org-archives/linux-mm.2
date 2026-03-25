Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA1EEFEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 08:57:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3196B0005; Wed, 25 Mar 2026 04:57:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5544E6B008C; Wed, 25 Mar 2026 04:57:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46A1D6B0092; Wed, 25 Mar 2026 04:57:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 33A496B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 04:57:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA5865B0FB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:57:42 +0000 (UTC)
X-FDA: 84583982364.01.CD4B702
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3733840005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 08:57:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Up7LdXhy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429061; a=rsa-sha256;
	cv=none;
	b=j6ZNH4tEoGWijxUFeWxj71GZUOg8Fw+e5uX/Upes4vwM+HntQfiLexaLbXHwoLP5GWabbH
	ye5J8jSHyPWPig5ucGvtS9KkQzNfW2ZvH+YZhl5SaxOpxz62f0FabyUoYqJcrVyXF5e0Dw
	qRajbJ9PeqcROjC0NrmWr4UiIR/MWXA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Up7LdXhy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+i4QtjsZduZvrgtOyI0JoJhbcx6QDc5DtE1CkJjHOM=;
	b=1AglqQkkuHVH4s1GLN1agR+OZJzuGMOx9rb+6VkaawCycBZFvma4x6AIWQwUHXHlOlsYSP
	5sp3lCVWdBHJsV42CLT2241sFINkAGyO5+MaeSY1DOwkv6y8vDAS/NTyXXJ2O53zcz9ABt
	roSNea6nznBUQ8l/bPWYfhjcM6sFsIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5640543F0A;
	Wed, 25 Mar 2026 08:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DC5C4CEF7;
	Wed, 25 Mar 2026 08:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774429060;
	bh=yfxv6pHELzGlv2oobJT9AbDKLWNfM0JfoxxEIEleLqA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Up7LdXhyLQj2Uj4oDFLXhdmGHMqOhUL+XCximoI0LCeWAmcG3+n1T/b0ZgRc3kE6q
	 ArPo1EXE8R48KzNNzdt6yCvT3aHF4RG0z3VvQbnoHiFVXdrgbo9MhBRZhI4FPnsRku
	 /zg6d1YEF1wixxP/JXLmHLwqxgyAgv0uzitxifSQ3oqC+uwSrLDrw/RyAfC6ZHrGNN
	 luLMjjt5tY0jRuCvI/ag8QknNU1ijC43qm99tCMQJk5dcuNpU6TjWoR/ivA7ZmC0jZ
	 ljzRuVTNrLdAiaO4ulQYeyXnhbsFrb5Y62VZv4fNhVIuO0auUors/U5COdlDV8Z+mQ
	 7wvdDEhmQ57Dw==
Message-ID: <e5bd51ae-8937-4cca-94bb-b705b1e8aa26@kernel.org>
Date: Wed, 25 Mar 2026 09:57:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/6] tools/testing/vma: add test for vma_flags_test(),
 vma_desc_test()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
 Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
 Sandeep Dhavale <dhavale@google.com>, Hongbo Li <lihongbo22@huawei.com>,
 Chunhai Guo <guochunhai@vivo.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
 Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>,
 James Morse <james.morse@arm.com>, Babu Moger <babu.moger@amd.com>,
 Damien Le Moal <dlemoal@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 Johannes Thumshirn <jth@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Jan Kara <jack@suse.cz>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jason Gunthorpe <jgg@ziepe.ca>,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, linux-erofs@lists.ozlabs.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, linux-fsdevel@vger.kernel.org
References: <cover.1772704455.git.ljs@kernel.org>
 <376a39eb9e134d2c8ab10e32720dd292970b080a.1772704455.git.ljs@kernel.org>
 <f11ec383-d688-4512-a9ea-700cc2d42f3a@kernel.org>
 <f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f6f396d2-1ba2-426f-b756-d8cc5985cc7c@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7bqybidptc7manwxip6g9uen3nx18bd4
X-Rspamd-Queue-Id: 3733840005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774429061-607319
X-HE-Meta: U2FsdGVkX18PVsAvgRO2HFgoOvGG2i08MotJCdXbpQp31iy+6/9gJBUvz6RD922Cyv4/+Hykn5/QplbHPAW9P67IqUWQwIZ2gfGlXBlExFeUGGq4NFYRYiT3uAg0q3XpOjQ3seVHpL6vi9A0qeX8dFtGhkuESGAh4mB9ZDoBb3ZpvdzHyhkMjn+lvvLGlvForkRkOa7Q5efH3c6yq6n9i/lAVooOV8jmp0zpNN0G7bc0kVaUnqxxNWmFNbu7pU/PGWXK8EvMMLrJKen67hRhlYHFQTooye5x07BneKTpJtxJzv2s/BGCrX9GyUy6caJriwg4duars0EwGpOsnEvSd/y24qWdyyjMJAgpXUoLzFf7Lvq9KsxcC3yZZ6QoIvHZ/1dOVU1IBvJopGxlOmyrDp5F8MMJ2vJpRNryf8LJxh9IEef15332++wEi519WBObux98XzYCOYbgXsZOn+pWrYxyWBro6KAN4QbQNIAN7ErtxTNkQb3uNGjxS42yMz1jkYK9Pu+qXGoLGouT0u5UpiN3nW539XoOQtCZafjUGOXvXKnfn75zQV8kV5HwVPcOxnUXNK63aL7ojXa8XhA8QcR9PKk7QkX65EQ+ntWLkC49AdnWjV8OrdE2aOa8U7+TiIPY1Shz7+hHmZdz7wKHRWt5RgtGGkm+/w4fOd6djPpSR3t+oGI/C41NeBhSBfIf9Z2CVNgqDL8bqmu92KBMiFNOeH8ISDykseZ1kFtIjS56ENy9ewpek9phOwpY0rB3KowwJwt2ap5jXbCSzNuVuxdPmXpUEyz1q5RUsyqVdDAi/jeSO6i8aTQtma8k9WrigJNX1OmjNGOE5kw3Tv9mU6h0ndqrPn24pixq/igXNxlMFd+6ysYZMpvcB0oUlxyNdkItgrcFhBHm9wdHISBhB2q//VRloALJCJenFZ7RZMD4TrHQAMX0T16+evyJJ0tKbUORxTy2StFgzRgrWrw
 pb1J4LEJ
 T1Ao13SBKCnQ/vQE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/5/26 16:01, Lorenzo Stoakes (Oracle) wrote:
> On Thu, Mar 05, 2026 at 02:52:20PM +0100, David Hildenbrand (Arm) wrote:
>> On 3/5/26 11:50, Lorenzo Stoakes (Oracle) wrote:
>>> Now we have helpers which test singular VMA flags - vma_flags_test() and
>>> vma_desc_test() - add a test to explicitly assert that these behave as
>>> expected.
>>>
>>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> ---
>>>  tools/testing/vma/tests/vma.c | 36 +++++++++++++++++++++++++++++++++++
>>>  1 file changed, 36 insertions(+)
>>>
>>> diff --git a/tools/testing/vma/tests/vma.c b/tools/testing/vma/tests/vma.c
>>> index f031e6dfb474..1aa94dd7e74a 100644
>>> --- a/tools/testing/vma/tests/vma.c
>>> +++ b/tools/testing/vma/tests/vma.c
>>> @@ -159,6 +159,41 @@ static bool test_vma_flags_word(void)
>>>  	return true;
>>>  }
>>>
>>> +/* Ensure that vma_flags_test() and friends works correctly. */
>>> +static bool test_vma_flags_test(void)
>>> +{
>>> +	const vma_flags_t flags = mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT,
>>> +					       VMA_EXEC_BIT, 64, 65);
>>
>> When already using numbers, I was wondering whether you'd want to stick
>> to numbers only here.
> 
> Numbers are for flags > 64 bits, we currently don't define any, it's to make
> sure everything works at higher bitmap sizes, the tests currently set the bitmap
> size to 128 bits.
> 
>>
>>> +	struct vm_area_desc desc;
>>
>>
>> struct vm_area_desc desc = {
>> 	.vma_flags = flags,
>> };
>>
>> ?
> 
> Ack can do, fix-patch for Andrew below :)

Not sure if I provided a tag, but here it comes

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

