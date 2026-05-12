Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E1ABCD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:14:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B86D6B0088; Tue, 12 May 2026 02:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FB06B008A; Tue, 12 May 2026 02:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A52C6B0096; Tue, 12 May 2026 02:14:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 290AA6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:14:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AD2421C0E79
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:14:27 +0000 (UTC)
X-FDA: 84757753374.08.09F0A50
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id C604540009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:14:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDehqxco;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gISX9vUkJGId9ol9xwP12uVXnjbioIxF2OMrLDdJl78=;
	b=wOo68ryZ92KilxHmjbG1jMf5wSzsf6UKWsy0gjtJg4NJZxI/tZhrw0ucQZEvl0fM3zvlrz
	sEjPCj8XT4AwPCcEDhH+idlfP9Bt0+7sjB7A5bj6FFT3DQrck1STRWZPpf6cyUs8QHF019
	V6E1C4Nviz0r7+a8mSQbM2OHOkWN/ng=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566466; a=rsa-sha256;
	cv=none;
	b=PwmVXdUU9NYXfQNLtsfe8HPX+T4P50IZV5hOmxd/MTJMOoDQ8TV4aTaie30LPMgjO9pCzk
	Bb31xXKuFX2ynnPQLhbMjEvlvQo+pEw5K77tKySIIGxlAKQSUweZ1w/kggRLRYbnDfFxsQ
	ARRWVPGVIi0Lch4qP6I/kzXRryHL4HA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HDehqxco;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C716B438A9;
	Tue, 12 May 2026 06:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E579C2BCB8;
	Tue, 12 May 2026 06:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778566464;
	bh=0EZtptM8iTZEc9KkhIGOPS4y0SLEEYo00bdW3QFajZA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HDehqxcoOny8+q9R/EQrECENhPrcPyoKzzgP48p0XVXIeAHZK7kpMVnvB44IoPzBo
	 t6peJordL6ZByfnTUShrHNma+rjCqHTXfn9dvabV+92O0EfkBkI8KUoBKymYSOty0d
	 0DAxql17MW5mjR1tyRF5NcCKv0QZCAUpwjGe6tslOAClLsNNSGbJ6CB+qQ2vBal5uB
	 +th+LAgu3k/fmOJc1Du1SrOEBn/5tIRmvvsIdh9cXGYHQ35ks0K9D8FMEwuUphn9nQ
	 EJfLzffgxpbdRb43CYfTDmjNKAn9dLdq4RyT8l+6poo9Dk2F5WGu15s/fBUx90mvT6
	 o0aHe7Qa+VN7Q==
Message-ID: <c0effa9f-1262-4bed-a99e-ae5441ac47ea@kernel.org>
Date: Tue, 12 May 2026 08:14:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/5] mm: support zswap-backed anonymous large folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>, fujunjie <fujunjie1@qq.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Jonathan Corbet <corbet@lwn.net>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Chengming Zhou <chengming.zhou@linux.dev>, Baoquan He <bhe@redhat.com>,
 Lorenzo Stoakes <ljs@kernel.org>
References: <tencent_8B437BE4F586C162950BF71954316C1EDB05@qq.com>
 <agJT6D5zaUD6FpwQ@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <agJT6D5zaUD6FpwQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C604540009
X-Rspamd-Server: rspam04
X-Stat-Signature: yjrydd3hd71zscffnbryygconqq3t8na
X-HE-Tag: 1778566465-558032
X-HE-Meta: U2FsdGVkX19oEFxxGUBxRb2o8rMR3sIO2yIY6e8J/Zm5a4NA0pTcJc7KfkECRXZqHxHzWrIwBkfGtmtRwSHzt9O6oxFs7QaEq1zjEIEkxm/g8BD+6BxoX9zMGPYCj3UioZN49/LTd1mPrP0ZsWlufhcOveGt8yuXy8aY9p7+gQjyCkMHjb92e8EuuQvkYDBfW6KB+ZtScqLk/Yo1ZxAA6TK+i//KimdGg5dw5yjzt6JHbwqDsclxwtCcQGnZBi6G/Y9o4gNK4iCgLhaFGufLV1n8bH9fc/jZfRXz2Er+VS+sPkOZbKG2jmAu8XguyIQA/xO0Kzl5ZIah61pUScVPsgCqw5eJhWMqK0+nM/R8H1w/CwOI7lKal9zqm7YS9Csxt0AK/JF8bFkVFNdtthbpoQzWGhxWayp1feVVDaMt1YGIP5H8Ed8FpTMr0HUwsFt2ejZIycJBuUAHS1C2FR9/WPBJ5D+Dh5uG9MGAIAStf8pti/16Rm27p7hqKS3snaTkDbW+JFOX/BM7vj5+1D/EG7tuniUQhbiOYWqejizsY9qsiCljQ4OpgzljN0b2vqQ6WqoMDUk7Rq6THh/oT1YmkmwiUN5izRLTclSQzSoXRf12Xtmiwnh/3gWY5aSx1kV+O2m932ISKdLogZO9F8HrckAtR/Qpwj0TADunrmKXIveNTEsI0RoO+3q0ygGbbzHf94kSjLn+bflyQZXNF44/1n+RUAQG1yR38PHKFaHa2E455MBqXvnvvYOl9w7PfnQOzQGg2LnGQSO8cqcReVUWrJdEzLZsCDvFQ/75qfjrNj25Cl2t4iQv9ULs+wVvUS1/BWgwb3Fg0tOp0KhK3MsIc4EhNOKYNuydrI9/wv2/6HUZnnUJrpIkKLwdcJ/NC/fURbSRRIRJ8mK2gXXWvk+5jZZcofAY2Q2DdlCNGfq6ZoJvzN4dDY0vCbDz2G3wCyW0NqLaLLtr2gesp6eYcr3
 DBAJergr
 +/pG2g7RmK5pU7w+LxrjitnnE6hlTTeFhDvz8qL9ePY3q2Ldege/RdSpmXMgiuOSUdsrAa2XT6xBOWGmdo1FVMLIgfUm+RexnQVROOi+xyKbxnMN5Lij6X8HmUUS293is6rHcF6S8okEmiix5g442QOmX6kUjiyKZcfbXVX6bgXR8JoZVq51hUUXt+4b8Vtf21sY6MqkpilP43Z3IgC6vMjIgihzqlpa2wYdKswG8rNTL3y6IQ39mVFF5Uysasjrq0VWn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 00:13, Yosry Ahmed wrote:
> On Fri, May 08, 2026 at 08:18:29PM +0000, fujunjie wrote:
>> Hi,
>>
>> This RFC explores anonymous large folio swapin when a contiguous swap
>> range is backed consistently by zswap.
>>
>> Large folio swapout to zswap is already supported by storing each base
>> page in the folio as a separate zswap entry. The anonymous synchronous
>> swapin path has remained order-0 once zswap has ever been enabled:
>> zswap_load() rejected large folios, and alloc_swap_folio() avoided large
>> folio allocation to protect against mixed backend ranges.
>>
>> This RFC keeps the scope intentionally conservative. It does not try to
>> read one large folio from mixed zswap and disk backends, and it does not
>> change shmem swapin. Shmem still has its existing zswap fallback and is
>> left for later discussion. For anonymous swapin, the backend rule is made
>> explicit:
>>
>> - a range fully absent from zswap can keep using the disk backend
>> - a range fully present in zswap can be decompressed into a large folio
>> - a mixed zswap/non-zswap range falls back to order-0 swapin
>>
>> The series adds a zswap range query helper, teaches zswap_load() to
>> decompress all-zswap large folios one base page at a time, accounts mTHP
>> swpin for zswap-loaded large folios, retries synchronous large-folio
>> insertion races with order-0 swapin, and removes the anonymous
>> zswap-never-enabled restriction once mixed ranges are filtered.
>>
>> I tested the series with a full bzImage build using CONFIG_ZSWAP=y,
>> CONFIG_ZRAM=y, CONFIG_MEMCG=y and CONFIG_THP_SWAP=y.
>>
>> The QEMU/KVM runs covered both the fully-zswap path and the mixed-backend
>> fallback path. In the all-zswap run, a 512MiB anonymous mapping was faulted
>> as 8192 64KiB groups, reclaimed into zswap, and faulted back. Reclaim
>> reported mthp64_zswpout=8192 and zswpout=131072. Refault then reported
>> mthp64_swpin=8192 and zswpin=131072, and pagemap/kpageflags showed 8192
>> order-4 THP groups in the mapping.
>>
>> In the mixed-backend run, the workload used a 64MiB anonymous mapping
>> split into 1024 64KiB groups. After shrinker debugfs wrote back exactly
>> one zswap base-page entry, refault left 1023 order-4 THP groups and one
>> order-0 mixed group. The kernel stats matched that shape:
>> mthp64_swpin=1023, zswpin=16383 and zswpwb=1.
>>
>> CONFIG_SHRINKER_DEBUG is only a test aid for making that one zswap
>> writeback deterministic; it is not required by the implementation.
>>
>> Nhat Pham's active Virtual Swap Space series is adjacent work. It moves
>> swap cache and zswap entry state into a virtual swap descriptor, and lists
>> mixed backing THP swapin as a future use case. This RFC is independent and
>> works with the current swap/zswap infrastructure, but may need rebasing if
>> VSS lands first.
>>
>> Feedback would be especially helpful on:
>>
>> 1. whether it makes sense to support all-zswap large folio swapin first,
>>    while keeping mixed zswap/disk ranges on the order-0 fallback path
> 
> I think so, yes, but based on my read of the code this RFC only affects
> synchornous swapin, which is more-or-less zram+zswap. This is an
> uncommon setup outside of testing.

BLK_FEAT_SYNCHRONOUS is also set for pmem and brd devices I think, but that's
also pretty uncommon I assume. Well, maybe if your hypervisor provides you with
an emulated NVDIMM to use as swap backend ... maybe.

I thought there were other ways to get BLK_FEAT_SYNCHRONOUS set, but I don't see
other usage.

So seeing it for zswap is pretty rare I assume.

-- 
Cheers,

David

