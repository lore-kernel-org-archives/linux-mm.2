Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DB64C531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 647DF6B008A; Fri, 24 Jul 2026 11:49:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F9C26B008C; Fri, 24 Jul 2026 11:49:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50E7E6B0092; Fri, 24 Jul 2026 11:49:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2F4C96B008A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:49:03 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2A0AA0333
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:49:02 +0000 (UTC)
X-FDA: 85024103724.13.00D26A2
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id A51F120004
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:49:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nwts4fjd;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784908141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wpu1gJe0sM1zpg7qn6uKI6n3VZyrOevD5zqeBPXBfwE=;
	b=SO1Qdb90V2xwDNTZirnToPaBLxKljotxZF/o/cOTlI6QRwlC33SsJL3J+AeOWfLnMCacF3
	toUJ3ZZMsztgWWNxD9n+hZJfiiLN6kpYCfgweDo8eDdkOo3dzocGC7tqiYlnm0QHIFqp+o
	NmJeeTNGE7iVgkVvGio0G/u7c8tJ7sc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784908141;
	b=rsWTXMp5ALfLOofyZe8OVEKMYQZ/QICfc0y6jInI+0Ze0q6ohZRt3W0yl2wwsc0rjv0PxO
	YRtKVp7vmETskn+DI+WPJiFMR3Cp91r8gqAP1zWIXsvdOjJ+DlqWYM1ObXHM8mDInBDmVo
	IndwomQDInQcOeNNFOR/5CrwXRuohDw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Nwts4fjd;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fd239383-dcbe-4daf-b337-32facef07076@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784908138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wpu1gJe0sM1zpg7qn6uKI6n3VZyrOevD5zqeBPXBfwE=;
	b=Nwts4fjdNhRkKoiWWgZb1pTyJfagzBgyAnhKRuaoRCtBx7aSslbqFtzy/tsaZj6SPePbPj
	+h8333InKBjxMVvWvd3VZk65pWaNGEHdIfYDP0nvTh3PcpkutNlEUvY2oMMCgrEm5Igfrr
	HnNV1rKdfXh4xzFXjakZOI0RjFHt+wk=
Date: Fri, 24 Jul 2026 16:48:50 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
To: Pedro Falcato <pfalcato@suse.de>
Cc: Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 Helge Deller <deller@gmx.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kevin Brodsky <kevin.brodsky@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
 <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
 <amOEUZlp1BxYh6_t@pedro-suse>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <amOEUZlp1BxYh6_t@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A51F120004
X-Stat-Signature: uajcn5qn47d4p4ikdmi19zkb8zzx5ni9
X-Rspam-User: 
X-HE-Tag: 1784908140-473286
X-HE-Meta: U2FsdGVkX1/idNkHfPckjVFsKjYcLAZ0ygUGB0GX/jxHDw4k2QsUt6O2MJt9b+9L3nsXsdLhMuSdwjZsGbP9zJeajHWDH0RB1itf4ylKFyA0Z94u3jCHoMVG58S4abSM0TAbuSd1+XtDbmwYy+ifmvpZxpkOT0P8uTTZYWskrtTPWLj4dMS9EH4eC/Ds5cN/Eln5OG2Lwk4gp1Z4JF7pomoFdl9qupCUF0+1mqv1cyDx576uXM7BCvY2DNCeJYV97Z+3Cp47/ZXHkBcHs2L6orG+GjSG57jN4FHxsGAL2fKmyIbrr8qf+rT2fOsyc3rgVCRULpu5ypJIN689UdADAwuc7T7c9T7UX8y6rYcHjYKJwrYnXY18ub1gUpLQBv+JW/nOous83N6CdC4xz6NN9I9x6NLO+UczJMzz5EHPVTkfleV5U6pwi5ItGqNRIVRvpWNZD/o2IC6jPKB3FFE+35MbfhvY/7p8gyC6uJa4vQmjIvT7RgDgERu/wTD9n1F/nqvrqE0RVK5WziQ56p+Sh74YE5TUUKlAUuZIIafE47uf0Tx9r0RJwN8yeKKj73/zBVUl/pF4uCJQ42T7Y1tO82JoE5OP0NjpHKyN/SixGi2HQTQaMc6pIyHIhHUw+JLQwgfGFtd3G7n8ws1ok++qASyTMARS3ECS8iUM8LlWCTuDCQ54Zqa6H9TGF9lVSPCyMM6EydGTW/5Eqg2iySdqXyQo2gTHluZn42b38wV9P/gsQyGggre1o/IlKPK+Lyk4RBHej8YQ8p9E/xJr7xe8ntRKt/Mol5nspkaHN4KUrpNWurkmGy6JvQBoedKu35X8qoKEEiLeXUNJkxdDXtInJHDy2GT2Hytuc7+3ccWYH6UitGWreB9vcTnpuBrfYZtwAgxN2iOk0vx8r/eWJXaj3Le1jaPbQVIrxDApV1Pj4q0Sc3XOJlT40A+c03M8f04mvYsNNDVMITEpI5n0Q9w
 aTWV5fXC
 G9Xhwo2n2+Czk9JUo7Z6GqiGM1OpR0IPr8kj4ore/MBahkt0TnjZMtWSIXxaSeqN7jhtKPl/rSMtSWDx8g0uGNDrTiQXGfHs8WsajFNRiw7nGxJ/yLsjWU6nvtNZEe6zmtDbFu8oYIwWO8oS2R6eRVIgyZKD0XSVfnJBQzdk1yoFCZmPau6BNZSuGqZuOOUCplAznlZ67XBB4sjHlphvVQVLonYWxoAY2VEhAK8CSYFMuBpnvXzoDWpZO4m+JalNJNxUFgVp109s+8+dH6IeK/5XQ7VIiHvU5MCDxQ9fEQ22umj5zY64bDwvEwt3N2p8xp04B3U8upRGAOx0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/2026 16:32, Pedro Falcato wrote:
> On Fri, Jul 24, 2026 at 04:03:44PM +0100, Usama Arif wrote:
>>
>>
>> On 24/07/2026 15:14, Matthew Wilcox wrote:
>>> On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
>>>>
>>>>
>>>> On 24/07/2026 11:20, Pedro Falcato wrote:
>>>>> ptep_get() does not need write access to the PTE.
>>>>>
>>>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>>>>> ---
>>>>>  arch/parisc/include/asm/pgtable.h | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>> hmm I think you might break build bisectibility if
>>>> you separate out the patches, you should squash patch 3 and 4,
>>>> with patch 1.
>>>
>>> I don't see how this breaks bisectability.  Can you elaborate on what
>>> you think would break?
>>
>> Patch 1 does:
>>
>> -static inline pte_t ptep_get_lockless(pte_t *ptep)
>> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
>>  {
>>  	return ptep_get(ptep);
>>  }
>>
>>
>> ptep_get() takes a non-const arg till patch 3 for example for parsic.
>> I don't think you can pass a const variable to non const function arg?
>>
>> So parsic won't compile in patch 1 and 2, powerprc wont compile
>> for patches 1, 2 and 3..
> 
> Aha, yes, nice catch! I'll have to rethink that. Maybe squashing the patches
> would be the cleanest way forward.
> 

Yes, squashing is the simplest way forward.

> FWIW, the vast majority of architectures aren't doing funny things on
> ptep_get(). E.g PA-RISC, loongarch only define these so they can use it in
> their own asm/pgtable.h. I'd really like to delete these but I can't tell
> if they are *actually* required.
> 

Ah maybe there is something in git history on why it was needed?

If not, hopefully someone from the arch lists could clarify..

> With those gone only PPC 8xx and generic would need to be squashed (arm64 also
> defines its own version of ptep_get_lockless()).
> 
> 


