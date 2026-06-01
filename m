Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D461CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 820036B0403; Mon,  1 Jun 2026 11:05:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F7B96B0405; Mon,  1 Jun 2026 11:05:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70DC56B0406; Mon,  1 Jun 2026 11:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5FD8A6B0403
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:05:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0EADB12072B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:05:53 +0000 (UTC)
X-FDA: 84831668586.13.D631A0B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id E812E4000B
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:05:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9zgfUpQ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l79QFJh+1tc8WOfin3+3RXKBIcle3fpVG/8qDloYB3E=;
	b=jYQ9xo0X0JGHDLy8XDVjczU7UG97G410ybbvnGZlA3JRsvtoupURoqAdI7t2qWnaBU1LGQ
	dN4//6UZvOhukke8n7FuhWtz0iPZ/qPs0HC7LosGgkiP/2aQs9B6PgAkqiIOXuHT/RYQJB
	tWYnZUjbxFaxbG6TUpZwVjvgiQ0KaUY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n9zgfUpQ;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780326351; a=rsa-sha256;
	cv=none;
	b=IUnyNvnsvbzIBfnei5lB7W36OUVrhejHflbgIjY0+eXeQUmWjZZ9oqL9KmACGkGI8VJ/2/
	AO+x21LrqSfnBc8saX3aBOJiobTwYZSaJVMrF9JypGNV1MSPi7R7M6WnXPt84knZKXgCXE
	UcQZBwWpwSj80sgNjcf+KKZ7pp7jTv4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0A29843FA1;
	Mon,  1 Jun 2026 15:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EFA1F00893;
	Mon,  1 Jun 2026 15:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780326349;
	bh=l79QFJh+1tc8WOfin3+3RXKBIcle3fpVG/8qDloYB3E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n9zgfUpQtpGFrY1KUN7yIVATJn4jFQRI7ZnP+d29X9eBrBBakEvRRxKg7Cve2XVHS
	 vohWdWBIxOKeSXuYufrzZh1zX8FIayu+Q598rlVvm5QSnKlPWDUeB+C+8ZC16wBoW6
	 UrgKxsXBAxkeKYR3RQ8rduOhWQf2ro2/w13Eu6dHjyWwtPmN3AeZKWhfWxTiYqp6Rb
	 xToKV0+X6Jt4CAeQNlp4Y8u2n8CgMt4lZ4iMqVokB8pYM32r7AaZyZ6zxMtFEiRU2B
	 wEiyOxYHfrCCUMNdKSRVR38lWPKkmsCkBu0SAkKb7x4fqKX/U8MSgyK9wdDykITbI3
	 /BfAeoGbT+Y5w==
Message-ID: <0bb49c47-8c41-478c-847e-b9154c75e59c@kernel.org>
Date: Mon, 1 Jun 2026 17:05:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Nico Pache <npache@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org, aarcange@redhat.com,
 akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com,
 catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net,
 dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net,
 hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, jackmanb@google.com,
 jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com,
 kas@kernel.org, liam@infradead.org, ljs@kernel.org,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 usama.arif@linux.dev
References: <2024af56-5e99-4799-a586-e9ba756cecb9@kernel.org>
 <20260601032804.96122-1-lance.yang@linux.dev>
 <f5d38f64-ab92-496d-afd3-29ccc17fec2b@kernel.org>
 <616de1a8-1cfd-40b8-b04f-7b324be40bfd@linux.dev>
 <6b11bf0a-769c-4ef2-ac6f-2af38200a6bc@kernel.org>
 <baa0a462-46e0-44ab-b583-c722ad253afe@linux.dev>
 <06d9b665-945f-4967-9ed9-b06514478996@kernel.org>
 <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAA1CXcAeEGOsqp-ywAQ7GMYQzXEeco-rUxUkk2hEF69HybC4=w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1nbrsehr3sg3iirarwt33obhnc9epw3g
X-Rspamd-Queue-Id: E812E4000B
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780326350-92018
X-HE-Meta: U2FsdGVkX19L7dySkGHABlvL6X+iQQykU5GrVYuPIENSGhqzaWdAwnUAIeehAuZ3f5xT29D4PjAr/Q4DPGG6gsBGdDA0qk/PnuoT+bN9kUkp+85BPdAHvNIL3fYY4RHQAGApYSSJLQbIu9HcIOAqmA7KbfIc5dpseDWqQFMt60woETYXXpzXE1rU37F0PBHbipygREQfiQDuDjX8QQsRvRjopvaOx4YT0a4v5oSUmtUNS/1vYJZkXmkFdhzs8wbBuVQ3ct3+h0NBm2bbsQThTjBl1ASp3WEiszuPcZiz7OI/BylTqSvo5JG2R3bLH+JlhZI+SYhr/waiPj6Iez5jn121cD05o1r7b0ltqDVvjl1dc3zzQ+xbg1jXO4J9rZqTHKeKMFJzwmYVk/0QNgLrol6mLZd+B3MWOzwq3NNiSd/b4cNlt3bLqkj4TlfzRSKt6jzzQc0++dOpjMfMoQtQcz0PDRc0JA6fPq6PK9QYF55jIGAV4T3Vz81DqEVOHVlh1lK838Y68CQEvmIq++ydKUbYG2hqXhOyj6PphOcwzotFCR98f2/lXpRbGClqW3bc/FDy24YNCOLGn+Ioe9iSBGuQs+ZS54lPNC6owTPoSKYWdPPUC6fUA7Phb5Tst/7thDrnuljlizCpKgUChT53+U+9jcH6M7fstJpuWW+Gd6KVbrNzulnUxJHjbSIzdPx7mrxN4Mbe//pVflQZXNRA+zV/KovUVrLjAHo3RAp47BYzhQgyyUjBuzhj49aEEFc6a0DV6QRHMqSJ7Gv+g7KFW6FapuJ9KGowGYQNn+UP/jyIHFE/gXzXGAw2r/LcOlyN1g1vy5f2KrkXJt0wp8ngQBFIwJTLjd6WmOgFqPemPOSPSTtdrHgEx0EIWN6S61acCgIjypQ7qs6B6+5h8LVVvkF/qStTszxlwVMdQfheydIyCdi8iNxQxroMbYDY0I3VZXF1voDR6VA/gB2I5hC
 tjP1gxTa
 y30iWOvY8ACi8KF8GKigGu9Pxy6llO4Bo6b67HfU2nm/zHQ6JCUD6PEh/30sPEtoTJY22AVRqTcVOmeqpW5UtFhL94SHQeD+Jm1jayfZ2CwgbTBSsF//GH53NDrfevyCmKvOdFVj2QPSpB/2bCQweDmzVLNRjP6WXu4RmCzrZdEV/EkEQv4MXxBTT7zh4RwO9LToRHDuxsnPYualEiPiQFDEjRhCVY3eUZylCb0dvyHOZ3qFTPlGzEwZx0fQL8vJ9DzEZQRNonJ7rNSQiO/lf7b3xG2aMD1wvOukYuCLc805txEQ9YM5kqghC+mk44gg1OB8y2w+XZzXKx8RlLtyxEYPDoQbsJjowOb6B4x3Xb+2YN1KGylS/Z6MWQWQtsOazqwC3pR9NeF0od4wFSg7aydtv10RcldliZ+FN0jrswL/kiU/8rLN2Ss2jtoKjb6Q1NqPpY6BEUvcT77Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/1/26 17:00, Nico Pache wrote:
> On Mon, Jun 1, 2026 at 5:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 6/1/26 12:47, Lance Yang wrote:
>>>
>>>
>>>
>>> Ah, cool! __folio_mark_uptodate() already does the job :P
>>>
>>> So yeah, no extra smp_wmb() needed here!
>>
>> Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
>> draft.
> 
> Okay, I read the above and did some investigating.
> 
> I will try to implement and verify the changes you suggested :)
> 
> Or an even crazier idea... what if we ensure MIPS checks for PMD_none
> before walking a PTE table?

But how would they update the cache then correctly?

I'm too non-MIPS to know the answer :)

-- 
Cheers,

David

