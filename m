Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BB89606A320
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PMeX0QQv
Received: by kanga.kvack.org (Postfix)
	id B5BC96B05BC; Sat, 31 Oct 2026 05:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33416B05BF; Sat, 31 Oct 2026 05:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A233C6B05C0; Sat, 31 Oct 2026 05:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 794576B05BC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:34:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 114F01608F4
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:34:58 +0000 (UTC)
X-FDA: 85382412276.20.53068CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 456BC20006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:34:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMeX0QQv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9o1mQzkbmTdaiTKQdIgL8fzuR8hlpHa+FcuDOUlG7g=;
	b=MQX1NnCkLU134sBAZ2rxVfoVyHOC4Hosn3NhhTvWz4XtB+loM6BvSPN83NyMCCO6KHMJzL
	d4snqYyYctZ9W/tjoQmL/eEH14WF6BsDMxZdQajZrwcB2DFLxIL23VvMpfeqm3xH0pvnyu
	0lRLsOlr821aXFKmoyyq6PcBph8E4tA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PMeX0QQv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439296;
	b=3bIXxMfenr18XTMh4lAqbk8zZ8tWb0xlJhnaG1RfmQojGmTh4UfeqdEB3qN4dd6mTrz6ID
	+LEI4ttgjWexRci7BtvuUvNOTBjzWnLly4+UsPaCK8/Qig0Vjt4hlYbrx2cegdiqJ7di6i
	Zbecj0msY4sgI4V8ravxiO33O9KFeKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C6A3F60236;
	Sat, 31 Oct 2026 09:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCAA11F000C1;
	Sat, 31 Oct 2026 09:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439295;
	bh=P9o1mQzkbmTdaiTKQdIgL8fzuR8hlpHa+FcuDOUlG7g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PMeX0QQvPBgkOrecOplu7IqNxYMnMEyiD5AjPxAjtugRusW9fJiuNj9IXZNPcnSH/
	 WMqSf4rUuty4Ax+BW2IdK8zetJkUQAMx3/TqvyUINiyjs6NfC0rfqsO3X79DBBi4Sc
	 WhfQaM1PTWd6z3XfFqVDPxoYFuZCr8x+mzLIQ503fxBBUSUX6dp+bH4tgB3FpN4yeA
	 JimfPT0DLgkb4O0DeQsG/FdpYWITpOIdsyvhtAmXLxivSzB4EiIbnVSluZg62j/4Ro
	 txxIMOW7G42uEhpVi6RVyYto7K6f2/WDA2zTfShc/YtXJ3HZghe/m3wXmmC0cGiTT8
	 MG8uqaygp9/SQ==
Message-ID: <04155e81-a88f-4bba-a77f-0aad1ffdcde0@kernel.org>
Date: Sat, 31 Oct 2026 10:34:47 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/swapfile: drop a large unmapped swap-in folio in
 unuse_pte()
To: Andrew Morton <akpm@linux-foundation.org>,
 Mani Tofigh <mt4022@columbia.edu>
Cc: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, tz2294@columbia.edu, stable@vger.kernel.org
References: <20261030-swapin-large-unmapped-v1-1-41e4ae378e6c@columbia.edu>
 <20261030155419.b10056c8fb37bc784b0d2778@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261030155419.b10056c8fb37bc784b0d2778@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 456BC20006
X-Stat-Signature: rcsumj7148q9a889dabi4wdztuzfyf8u
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793439297-249927
X-HE-Meta: U2FsdGVkX18BZm/ypbL7MFCRwAoPg9vqihPVBXZKqJB0vA0GNVUOqIibyEHlZ936O5sROOBNzIWoNosGm5kCAKIGQehe6Zd75iv+lb1E2TiNiYMYEyFAtndn7wE0oFxmqdCXUUA1PJvYMTXpbpQXN6lKJlXPNRBBUHq9s98FosokcgwiX3IWOZn1/bUCj6wwI/+nqGSkunSezmnwf6uxHTmX1xj9EvYOtcukczxK472WBh7SgfXMeYZSeCl6F3pK5T9n5m+hHjkrbaHosBZ/OjZWtEJVliIDnpKINmNByaA8U+KJ9bwa/9XtH0Khp3nKmoz0gZeO93oCvK2gRJkV18kVOV7M9JczhtLTASRVWqVbva4Bs5nolSas0PIlxHw2mP0qvyaHToxzOGH/Zim+G4oWqOAmSI/uK1m+nNDXO3GbqhVwehf8zxDgXS1w5ImM+YGBy5wdg3Dhl6NZ7lbANX4qZxmoSEs4f25cSS7lmt2gsduDqB1o6qv8B47BMhEoVErY1mBtrZOTJiyWbfwkBoCM3yRtC1buqOoj90Yme7DJmDATr1xRmMuIgVuWDQSsASU8ympvMwM9zU3M1GII47LpFt26Wht91MHWBJB3UV9mahYrInzbWmtJ4d7yqDrM9L0PEfelrYqFJM8b1AZ6v70IlUfuk3lmQUl0YhANEQQsUKD4qcZ8GQkoIvunr3V/n1FOIaZoGv1+bd/mo+cR8KbDpmc50GZPbiHIOpdZGgabyPerpLS8az1Benfn2/qWncbE34fcq2VRZlk2t1Lja/sQ0kwR5sYIrsbLHhwSgJ1dkQO9eltl7291PWYmD7wXZ7A67372llqZrDn751Z01+e8NibOw5bjWd72PHbU3ILzGYnSsZxKlMvC9waO6sKrgwatJcwvTNxXuNJJYI0nbdqVELnP+gi2VThZpbubl4B0yqgELRZRBxe8kvSjPeLigR2IBoATYgxvk8ADAQ3
 hqEmfyTi
 z5GaQ+mHfHrjrxYic9y+qPLpT/GVF/5lxPmxZF5eLtsWTDq3VSN2P9APfY5xTsaZrMw9Vi2L6gluJ4CVe4KMFT5qZzxw3EdjijppHNTmBYYHtQFHNnN4gZfUhdgwAVa4oc1jaBPibWGRMkk9qlJJIxmkTh1QMcaVQ9OSo7p06kdo2sFbLnOcOmcDLYw2nNSa52FSjpwaOTo707/6ozg8dS5QA96/+mRtk+JR3zhz6gDA43TJ1FICCubvXJJF4fXuAg2cJ5gkcDGnukAxuO401UexfDyMqKxl7QPotCgNy/dv2AoD7h+3J4cxi6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/30/26 23:54, Andrew Morton wrote:
> On Fri, 30 Oct 2026 15:11:56 -0400 Mani Tofigh <mt4022@columbia.edu> wrote:
> 
>> Since commit f1879e8a0c60 ("mm, swap: never bypass the swap cache even
>> for SWP_SYNCHRONOUS_IO"), a fault can read a swapped-out mTHP range into
>> one large folio in the swap cache.  The folio only becomes anon once
>> do_swap_page() maps all of it, so if the faulting PTE changes in the
>> meantime the folio stays in the swap cache while not being mapped or
>> anon:
>>
>>   Task A (fault)                       Task B
>>   do_swap_page()
>>     /* swaps in large folio F */
>>                                        madvise(MADV_DONTNEED)
>>                                          /* zaps the faulting PTE */
>>     /* PTE changed (F not mapped) */
>>
>> swapoff then maps it, which marks all of its pages as mapped and
>> exclusive, and the next fault on one of the other PTEs crashes in
>> do_swap_page():
>>
>>   [    6.424485] kernel BUG at mm/memory.c:5195!
>>
>> ...
>>
>> do_swap_page() already drops such a folio from the swap cache when it
>> can't map all of it.  Do the same in unuse_pte() so that swapoff swaps
>> the entries in again.  With the fix, nothing is reported.
>>
>> This bug was identified and confirmed with the help of a deterministic
>> hypervisor currently under development.  The C reproducer below however
>> hits it within a second.
>>
>> --- a/mm/swapfile.c
>> +++ b/mm/swapfile.c
>> @@ -2518,6 +2518,18 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>>  	if (!folio_matches_swap_entry(folio, entry))
>>  		return 0;
>>  
>> +	/*
>> +	 * A large folio that is not anon yet was swapped in by a page fault
>> +	 * that did not map it (yet). It can only be mapped as a whole, by
>> +	 * do_swap_page(). Drop it from the swap cache and swap in small
>> +	 * folios instead.
>> +	 */
>> +	if (unlikely(folio_test_large(folio) && !folio_test_anon(folio))) {
>> +		if (!WARN_ON_ONCE(folio_test_dirty(folio)))
>> +			swap_cache_del_folio(folio);
>> +		return 0;
>> +	}
> 
> Let's not WARN here.  If it hits and someone reports it, what do we
> tell them?  "uh, that's working as designed, no action needed".

I thought harder about this, and it just shouldn't happen.

Something that was swapped in and never mapped (!anon) that would be dirty would
reveal a bug elsewhere.

I think we can just turn that into a VM_WARN_ON_ONCE() and still drop the folio.

(there is a reason we never saw this so far in do_swap_page())

-- 
Cheers,

David

