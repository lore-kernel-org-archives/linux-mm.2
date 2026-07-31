Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CB72C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 11:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F0716B008A; Fri, 31 Jul 2026 07:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C8076B008C; Fri, 31 Jul 2026 07:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8AB6B0092; Fri, 31 Jul 2026 07:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2A96B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 07:59:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D69A1A0404
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:59:23 +0000 (UTC)
X-FDA: 85048926606.01.A15317B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F25BC40005
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:59:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvoDkQlu;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785499162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nm4XNdosDTkLpy1A2APf3Rq2Y20s3PmQ81LS+20iumM=;
	b=gqn+PiU3qW3bN42rdT37vrVzCZk5cWZvVbIDdmEHR+nL/5GGMG13d4XZYrs1565T6G4YYh
	OBgGgYuZAWIwSmefqN6gCnx4hv8AJg6Uspq4DpBbfa30c3mUPFf+enCPSCYG2Ab45L7C22
	3is7jQrsoGdHhqsruStqNEYDWUKvedE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KvoDkQlu;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785499162;
	b=t5PiodOAO5MWGssuK2EtfWbp9Ndcgc0kDmaBddz2Ey4fw7WqgpJ/cwS7LnQwr4Cl/NkZ/j
	EgmPPX9AK8ttXpcoy8K5pUflz7rzjSSjxKDfOuPmNQJUmxqTB/HMmXqoAoR5S4yFfN2bxc
	XKivwDC08o3RPdfaN/kwMjhc3j1o4ik=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA62E41B23;
	Fri, 31 Jul 2026 11:59:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75C541F000E9;
	Fri, 31 Jul 2026 11:59:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785499160;
	bh=Nm4XNdosDTkLpy1A2APf3Rq2Y20s3PmQ81LS+20iumM=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=KvoDkQluOqIEZqgpMUedMAAOQZiM8Px+cdim13BhGWGcz0luftftif+Cex6mR4bSV
	 gn5P+xU2YooQ3Z2SdV7qPHL2pJ7r6g31jBlgtau48sz4n1qgfWJBrdohaEdZwkECTL
	 Eut9WfJq6LEaJiPWx2qEQ65O0oj9AwH4xpXnDsgw8X8UnhDL05lP4hGQYtH6TRqFpe
	 kk9qzkt+ptAmYy3WQnFunTrOFyvkt8xnhNdDCTsDboPYvLJgdOzltNvsCWbgbWmPKN
	 96YXjoNb4IYBa1EkNJapNnEmz+0jyskTAUeQnAHQEAaYszPi1OfZmiDEQ4+18Hd18+
	 ICAFYfm9QPX1A==
Message-ID: <edc3566b-370c-41a0-a71d-2e4a0e1a94f7@kernel.org>
Date: Fri, 31 Jul 2026 13:59:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/41] mm: swap: Introduce lru_add_drain_progressive()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>, aik@amd.com,
 andrew.jones@linux.dev, binbin.wu@linux.intel.com, brauner@kernel.org,
 chao.p.peng@linux.intel.com, jmattson@google.com, jthoughton@google.com,
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com,
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com,
 shivankg@amd.com, steven.price@arm.com, tabba@google.com,
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com,
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com,
 aneesh.kumar@kernel.org, liam@infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Sean Christopherson
 <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Youngjun Park <youngjun.park@lge.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kiryl Shutsemau <kas@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 "hughd@google.com" <hughd@google.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-coco@lists.linux.dev
References: <20260728-gmem-inplace-conversion-v9-0-35f9aec2aed2@google.com>
 <20260728-gmem-inplace-conversion-v9-14-35f9aec2aed2@google.com>
 <4460e252-b6de-4df3-bea8-0368a9d0f4ff@kernel.org>
 <CAEvNRgEUQSju2tW_1zMk2=QmveZNtmkjjCZdqVBgBD2JPh0k4Q@mail.gmail.com>
 <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <a823e3d2-8acf-49d9-a812-ac1bb2136d7f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F25BC40005
X-Rspam-User: 
X-Stat-Signature: puyp6tzx3sgefezyicfwbabhhhgieym1
X-Rspamd-Server: rspam04
X-HE-Tag: 1785499161-655624
X-HE-Meta: U2FsdGVkX1/JMdV3KFk/7bym7U3guhbG86SyTlSYIViJoddW768N/yTs6H3ONidyqYX2Q66m4vfQ6lNrRuIGSKd9O10AfP4eeaM3qgAUxHAh0IyqefAY1SHMnxctKSX/FFqPeFK3Xyt/tANscHDIric9z52/Z8kxbNpq2veKOMh10y4nCBJQGd4d6dhFwRPzlwis+xSrf3FejZHfGL/LVEKXH/YtjI3kbx0QdI2Cs5stnqpFbv5nZbRpNOYyXYqNW/GSYK1aZdKe7EJjgj6ACmpw4sof4t2+cxTMrG02C2TxOhTj8MQWzm0J4/JY0B+D8tsFBYHyHsjs/dVxeygdyoGijEplJp9AVL13Bhf8DkNVFo3nXg4Jfu+e2tGPmhK2EbZS+L6WQ9YdOxF6cSjKPr4cqgZBrv+TIu7a0az6aaKadcbpQyWriIMljHJ2J98a9C3743x7h9iFLdPbM/7Sl373bzNrRCOrik4ELRNVCRlOuMEaINbzm6vjVu+C3671zX9/fTz7mMcgZIuNm8tnedmhJvZCXJWtTAa8rY1rvNcYJhTdOXXElJQywxXzl/l1bR/Sqect9oqBibzSYXdaMvDaLlIEhbK+MAIYSRCPSzPgRknVCwje7jZkkZiktvFRvOepzHg9xznWORNJTEhL3LY7WgBc3A/0m2S8FRVJ5toNrn1eClt7L6oxcF9n9+u5QC5hGv6PyDMi9KXkTYozCK25Cxgd+64iSy+wkikNavjr1zj7K5puNE0WVlkda5RC7ua6+trhA1g5Fd9EhayciaeOYOUIdLr3gSU79bru4d7yGU9ohe7ouVy7I75MoqDsIGWCPdwrTs0oHKBg+HShV7cmIScMInbF2oOI+hao36hA91iOT/ihAUfy4CUJ9UtfNoHy6vc+Dnhk1i0LzTKpulwoB/bnMl+zl5ANQSZ+fCvGbR4tL6TMxJGScucP5Q2Tm/8vZFOpEjvhmbjD+o7
 h98jdL+R
 0dpIEOZvKExZw/IL8ITLBPVq7hhZLgafSGQWEJiZ/3VQFlQ80dUQELbiIiSMX6EqB8nnCW5JD09EBIXhG2wHMObAzn8J3dDki3guM7bsmlAcYynZ0ZueUbmgx0UhOlmAoW9iBjxYKfB1uFU79uuqbJeEpM3PrZ+UYS1UM/R9lkBxascK1vo8wC5bF9ePApts0O/MbZlV6KawlkFgopX1WUZamwFBM9sl3KBNeJ0uknczg/c67+4vATq9mvGrSbSULdkWNw2tRm/3+JglBuGneGdwnMuMuMpITve3nf6wblNZiOWeY795umsIEBjctjFyvrEy79LLKIX8Z7dDDXHi5lBM4HZrNBd9MtID0X3hTU9PK5g059lh2qokfNc+zRrmZIrqpNxED5DpAyLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/31/26 12:22, David Hildenbrand (Arm) wrote:
>>
>> I didn't really like this either, the drain_state thing is really
>> awkward, but in both usages (collect_longterm_unpinnable_folios() and
>> guest_memfd), there's an outer loop where if the draining happened on
>> the local CPU before it should skip straight to just draining on all the
>> other CPUs.
> 
> Just nasty :)
> 
>>
>>> I was hoping that we could embed more logic in a helper. The history [1] of the
>>> refcount check is rather sad:
>>>
>>> https://lore.kernel.org/all/c5bac539-fd8a-4db7-c21c-cd3e457eee91@google.com/
>>>
>>> ... primarily because of mlock() handling.
>>>
>>
>> In the original code in collect_longterm_unpinnable_folios(), I couldn't
>> find anything that handles folio_test_mlock(), so I was lost for a while
>> until I realized mlock() doesn't add a refcount to the folio.
> 
> mlocked folios in the mlock cache hold a reference as well.
> 
>>
>> Are you kind of proposing an optimization to
>> collect_longterm_unpinnable_folios() by adding a check for
>> !folio_test_mlock()? I hope we can put that in a separate patch series,
>> I'm still hoping to get this series in for 7.3!!
> 
> I was trying to avoid messing with the refcount for ordinary LRU cache pages.
> mlock() should be a corner case for guest_memfd.
> 
> Relying on the refcount just means that one unconditionally performs a lot of LRU
> cache draining even though it doesn't make any sense.
> 
>>
>>> For guest_memfd(), would mlock() ever apply on a path where you need that check?
>>>
>>
>> For guest_memfd, if a folio were mlocked, unmapping it would fail, and
>> so the refcount on the folio would be elevated. The
>> kvm_gmem_is_safe_for_conversion() check in the patch after this one
>> would fail, correctly.
>>
>> I really wanted the caller of the lru_add_drain_progressive() function
>> to control whether to do the drain (see below), which would solve the
>> mlock problem by not assuming the use of folio_expected_ref_count() to
>> determine whether to do draining.
> 
> Again, the problem is that on *any* raised reference you would drain. I
> was trying to limit the harm.
> 
> [...]
> 
>>> + */
>>> +static void lru_cache_drain_for_folio(const struct folio *folio,
>>> +		enum lru_cache_drained *drained)
>>
>> The main thing I wanted in the proposed version
>> (lru_add_drain_progressive()), was to let the caller determine whether
>> to try or to continue draining.
> 
> Why?
> 
>>
>> I wanted the caller to have full control over whether to drain or not,
>> so I didn't want to pass folio into the function. I thought the caller
>> should first determine whether to drain, then call the function.
> 
> Why?
> 
> That's literally what the existing refcount check tries to do: figure out if
> there are LRU caches.
> 
>>
>> This version assumes that the caller wants to continue draining based on
>> something to do with a folio, and the folio may or may not be on the
>> lru_add fbatch at all, which is a little strange to me.
> 
> I really don't understand what you are trying to say.
> 
> Draining only makes sense if something is on the LRU cache. And there are
> better ways of checking that than relying only on even less precise refcounts.
> 
> If someone wants to do an early refcount check to abort the overall
> operation, that's fine.
> 
>>
>> Also, this version enforces a certain definition of "expected" number of
>> refcounts on the folio. I guess in this case this definition works with
>> guest_memfd, but guest_memfd doesn't support swap so the swapcache check
>> in folio_expected_ref_count() isn't necessary.
> 
> ?!
> 
> That's why we have the universal definition of expected references and the
> common helper.
> 
> Because pagecache pages commonly don't support the swapcache.
> 
>> Also, if the definition
>> folio_expected_ref_count() changes, then guest_memfd is implicitly
>> affected. Not sure if the "expected" definition is the same for all
>> callers?
> 
> It must, because that is used all over the place. The only thing it
> cannot deal with is references held by the caller (which could be supplied
> through and "additional references" parameter like we do elsewhere).
> 
>>
>> I guess if there was a function named
>> folio_ref_counts_indicate_presence_only_in_the_filemap() instead of
>> folio_expected_ref_count(), then it'd be the perfect function for
> 
> You're not seriously proposing such an abomination I hope?
> 
>> guest_memfd to use. The current definition of folio_expected_ref_count()
>> also includes page table mappings, but in this check guest_memfd really
>> wants to make sure that there are no page table mappings.
> 
> You can just check early for mappings.
> 
> Remember: this is about LRU draining, *not* about your final
> "unexpected references" check.
> 
>>
>> This version folds folio_likely_lru_cached() into the check, and I
>> adopted the check for guest_memfd because it'd help with huge pages,
>> though technically guest_memfd is always 4K now so the check is also
>> pointless.
> 
> Who cares if we end up with a common usable helper? We have usless
> checks *all over the place* in common helpers.
> 
>>
>> I tried a macro version of this where the macro caller can pass in a
>> full condition, which would look like this:
>>
>>   lru_add_drain_while(folio_may_be_lru_cached(folio) &&
>>                       folio_ref_count(folio) != expected_refcount,
>>                       drain_state);
> 
> Yuk.
> 
>>
>> but I thought that just created something people have to jump to, to
>> first understand how the macro works, so I left it as an explicit while
>> loop instead.
>>
>>> +{
>>> +	if (!folio_likely_lru_cached(folio))
>>> +		return false;
>>> +
>>> +	/* Try local draining first, if not already done previously. */
>>> +	if (*drained == LRU_CACHE_NOT_DRAINED) {
>>> +		lru_add_drain();
>>> +		*drained = LRU_CACHE_DRAINED;
>>> +	}
>>> +	/* Try draining all CPUs next if still not an LRU folio. */
>>> +	if (folio_likely_lru_cached(folio) && *drained == LRU_CACHE_DRAINED) {
>>> +		lru_add_drain_all();
>>> +		*drained = LRU_CACHE_DRAINED_ALL;
>>> +	}
>>> +}
>>> +
>>>  /*
>>>   * Returns the number of collected folios. Return value is always >= 0.
>>>   */
>>> @@ -2266,9 +2316,9 @@ static unsigned long collect_longterm_unpinnable_folios(
>>>  		struct list_head *movable_folio_list,
>>>  		struct pages_or_folios *pofs)
>>>  {
>>> +	enum lru_cache_drained drained = LRU_CACHE_NOT_DRAINED;
>>
>> I also considered an enum, but it would be another thing to export. I
>> was thinking to have drain_state just be opaque to the caller and the
>> only thing the caller needs to know is to initialize it to 0.
>>
>> Perhaps there's a better way to "make it opaque"?
> 
> Putting an enum into a header is a problem in which universe? :)
> 
> Ackerley, please stop making up stuff. Having generic helper is not a problem. Doing
> checks in common helpers is not a problem. Putting enums in headers is not a problem.
> 
> Your version is just bad.
> 
> I can later try something that keeps the questionable refcount checks in place,
> maybe that could do as a temporary solution until Hugh possibly finds a way to
> remove the need for draining entirely.
> 

And looking at it, the current folio_ref_count() in GUP is entirely wrong
and always makes us drain local+all.

Let me fix that first, which will also modify this code.

I'd say, to unblock gmem we could have something minimal that I would clean
up later, but I think the problem is that lru_add_drain() / lru_add_drain_all()
is not exported, right?

-- 
Cheers,

David

