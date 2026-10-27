Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE743606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Arjlk7Qt
Received: by kanga.kvack.org (Postfix)
	id AC3A86B0748; Tue, 27 Oct 2026 09:35:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B2C6B0749; Tue, 27 Oct 2026 09:35:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B1056B074A; Tue, 27 Oct 2026 09:35:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD556B0748
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:35:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7C89A8751
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:35:25 +0000 (UTC)
X-FDA: 85368503010.15.E31A93D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1DDD440005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:35:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Arjlk7Qt;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793108124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXXfHQerXMejJc/h/G8QmxS8zRqgGjGP7S6FBaiQJf8=;
	b=1bA0khzacFltOQxynGgUdL0FmSutd2htaD3vcC859afX4MoJQf53Oi4EH0J4XR/y+9FBjr
	oe2HK6t1H97FBNVlvhpIV9FazM9f1Yhm08kQZVzb+HD6Ix+QcZ6jv1re+msggWgK/jd1jm
	BCV2/p9AsLqPCGdNmVo3WN+OR6DSH2E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793108124;
	b=2Yk0R6v7tYONHFQTPjpF6F+H5sGNlerYPv41Gqy98gAEIwpDAv+XPnkd5Lh0xXWbdo+Rdl
	6vKh9zvXEVpNyF4Oe3w2X8zq+VF+wP+U85xs6F307Krm4nG5hmXz2F9NGo35D9L/gO7kun
	S8hdDLIewVucPRX2a1D5Ib3yBphUGBA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Arjlk7Qt;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DDC4410BD;
	Tue, 27 Oct 2026 13:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BBD1F01825;
	Tue, 27 Oct 2026 13:35:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793108123;
	bh=DXXfHQerXMejJc/h/G8QmxS8zRqgGjGP7S6FBaiQJf8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Arjlk7Qt+D1zP0rhgU2TwlPbSPFeu6d5zAdGJpJ/2t/12E+ySLcT7HupgwQfHwTAR
	 CKigig4dKa9KrHuLiIIcZnpXkxuj+2s0w/PHf6jcH05B8QTQjwpYAWFdaECJtjh3FY
	 yHCoG1lLYscIjICHqfjZOpOBtu5IPgdZCTQS08TfhBNied3uoJHdEBCQw6sQEnQIHU
	 W7k1Op/YP3pkt+lNUUPbs+5oMoWSQ6DmsbAqQzi0/kjOQsKXohLK5IxIzR8UjKgdRV
	 oXJXb79cWZVJqnEf/ALW0tnCrC4p78g9GZJHxS+jZNchp2c2ip3sb69ZGxq1YGrBDS
	 DyMPPLUExJ0yg==
Message-ID: <d7a634b6-8668-4753-8bfc-e9334dde705e@kernel.org>
Date: Tue, 27 Oct 2026 14:35:13 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv7 13/18] mm: Drop fake head checks
To: Muchun Song <muchun.song@linux.dev>, Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>
References: <20260227194302.274384-1-kas@kernel.org>
 <20260227194302.274384-14-kas@kernel.org>
 <ebc7bde1-f52e-4da8-b16f-822d6c0a4d74@kernel.org>
 <at_f43oDv73y-t7O@thinkstation>
 <f97a8d33-50b2-4a86-8381-ee840cdfa2f9@kernel.org>
 <20261027110028.GH2668564@noisy.programming.kicks-ass.net>
 <auCKv_omLGRc6wv2@thinkstation>
 <f3f3aca9-bdb7-4aec-9099-9fb63a60e61d@kernel.org>
 <auCZFckDfBMrlfxV@thinkstation>
 <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <070DDE5C-2183-4A8B-AC2D-891CAE15E581@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1DDD440005
X-Stat-Signature: mtb1nhozdf6s9sn1zeauujrjbz6e1h75
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793108123-433733
X-HE-Meta: U2FsdGVkX18S61Qxp7RfIGfwRcgeuWo6zVD9KR0YFvL7aPW76X83SrLR+qvmR+6rDkRyH3n4Ymp6YuUAyZYrFfPRBYc68u9bP4JwavwZZ4wCQq7/OdIkEaumC9bdgmxLVCgzRLe50AHPJkztI39CaD+1fhBPsU9ek1JsfkoKIckJ5tDay8XTJN6O/ZZ5tpe5pXB+sKU7F+Q1tAdlr+N/71Qd6GFa4fKAN3MbmUrRUxqQJ8bs7xx/68EP3bBdN08BlQ26JUXq54NAy9LeseIMkQYg13C4NbxavXDhfGPfgd/C8zMHTMh2Iv2xVakK2bkXFqJEzYjo+lnDKS5ROBGB7vXjduxDkp6mmFCQdjcPrV+W2Zi+wo4gIugRuWDzWqyxGp8KeoGdelIrqK07egJKUrKMGvVrFMlAgC4swUuI3e012QA4qJ/62GuNCaFH6L2il5pvG1pOV/zwlfb43oalgfexG+cmNDWi/bblZzXCOhrp5OYBcmqIz2fyT9oUClLx5RkbWbmUfE+3dOZWS9RuTnPXW0f+4MSEbz3hxltWAkO1dFVVGPNdf9hS8TgBKANicyKWnvnP9o5CFhJCvyGHyA+fRqAIJgVYVptFWb7VBVQzuPwMzDgazrvJN0eZ+tnHlsVb4+WezmNTCY93Kk9qlRQZjGqeW00rmrbNYQGlZ4AxT2HT2wjOLFk1neBdomo3348MD+FRCAhzDgy8LAm8iOkNYu8nKezcIQRH71gkFdjB0Ti3LFv1Y5RHBl43FoWN96PBRKHTtwRtAJIYxfxXxxbWABoR6yd2bR8gCDa8/6X3eB7G5DiCzouRlwSQ1oq+ZhItZceDnwH4JwPwgFP48CSl6irjx/5bHK9FBmsc01k//4fx3xVPMzI1jwFptFk01eC6vFTUMIlN1TBM1xAb7qFfRM6LlU8L3v0rlr1jrD4WZJnEav00Hxdn+d3WAkKUmazUBcNqfQ7HLncWTpx
 hFz68wLY
 Os8KWY64KIgytHOF0fsh2gW3jrITjWW1fsiuXfYLOubSXh8NVwJbyYn3z5LvZnWegbNlzu8N11ioyfP0zITOhMEEISRJ1gjaYVJI2byNytdkQElKjnuJT9FBJjaY2dQNXmIolPPS9ptaKvTVcNvTcpOy44L9QOz6LW3snaUEMJMn4rNSz4Gr+Yb2jucZXr2SbcYlqo95mlmxNF/sypN31s1zHYv/hClolpRN6Z0ooKO06WFb6RSIoCE8QNNBcnGjOPDeP2u2hoissBklOrkwT2P5mgCZeiPSw2xTI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/27/26 14:13, Muchun Song wrote:
> 
> 
>> On Oct 27, 2026, at 20:31, Kiryl Shutsemau <kas@kernel.org> wrote:
>>
>> On Tue, Oct 27, 2026 at 01:05:58PM +0100, David Hildenbrand (Arm) wrote:
>>>
>>> Right. Without HVO we would just corrupt pages in the single folio (which is
>>> also not nice).
>>>
>>> I'm also questioning whether we need this RO protection all the time active.
>>
>> What do you have in mind? RO only under a debug option, or switching the
>> tail page to RO some time after the remap?
> 
> I don't think enabling RO only on debug kernels is a good choice.
> 
> Within ByteDance, we once successfully caught memory failures using RO (because
> we backported HVO, but some missing commits in memory failure caused write
> operations on tail pages to persist). These operations triggered invalid writes
> to shared tail pages.

But would you have caught it with debug setting on in initial rollout / experiments?

> 
> Under the old HVO schema, this invalid write only corrupted one folio, but under
> the new schema, it corrupts all HVOed folios. Therefore, I personally believe
> that for the new schema, the value of RO is even greater.
But doesn't that mean that you would find serious bugs faster one way or the other?

Silent corruption of any folio state is not good.

-- 
Cheers,

David

