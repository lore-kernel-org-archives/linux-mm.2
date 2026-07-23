Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F606C531CB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 12:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7805D6B007B; Thu, 23 Jul 2026 08:45:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 731ED6B0088; Thu, 23 Jul 2026 08:45:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 646FE6B008A; Thu, 23 Jul 2026 08:45:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3520E6B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 08:45:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AFAD91A04BA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:45:34 +0000 (UTC)
X-FDA: 85020012588.29.9DCD0D8
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id B47DC40008
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 12:45:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O6PCeemo;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784810733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fi7Yg8IOfCZrBlHXrltI73qzUIgGZEMeZzt8zqMdn/E=;
	b=Bru7UnBgatG/roJjQhdKrUQ15jTiRNU/JbeHKM3deNRyDhURPMmLCMAbOAgG0I0hvLeRMT
	zR+yHePps45hRChhNAJsU4vDrj/6GjROcvSBxpQS5ya8Ut3+QEXJV9dgYl8U73pByjeXh1
	yaSAhKICSoGf+IDifjHpMU8PJmiTUy8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784810733;
	b=SAcPhJBw1LATRj2ZIOELc0FEfF0Hjk9QDVSdYBDK8Rp1wZfmSTgfhIJVRnH/KieweHmZRL
	0ZWx21wDEZdBDy+Vynr2NtDVqfivn069U0ZfUA0vbORKpBAwyAr6afZH/MGD4k9eQPyl/k
	zSj8pRNE19hHy5adCp/JAVD88CFUmQA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O6PCeemo;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <ee172b01-54c3-47ef-9040-1342a1566796@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784810730;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Fi7Yg8IOfCZrBlHXrltI73qzUIgGZEMeZzt8zqMdn/E=;
	b=O6PCeemoOgURF0840AgkMJOELEbNSRja2/yiK7zmwHaqO8NyAwa4fZtUa985iRRynONcbp
	rTfkeI/IbBC32Rw/THBy43qi7WFikAn/uygPWv4SVBc7cDEB3c83VputH1O5q2wsw/eSh1
	JMZRGCiFka5EAf7QBHPplXmzg3YUBww=
Date: Thu, 23 Jul 2026 13:45:15 +0100
MIME-Version: 1.0
Subject: Re: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio
 swapin
To: Yosry Ahmed <yosry@kernel.org>, Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org, ziy@nvidia.com,
 linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, kernel-team@meta.com,
 Alexandre Ghiti <alexghiti@fb.com>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
 <20260722152043.2273289-5-usama.arif@linux.dev> <amFZmtGHEZjXEw5R@google.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <amFZmtGHEZjXEw5R@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: m4ikgpzgxmhdrjxcec33fjoomrpxubko
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B47DC40008
X-HE-Tag: 1784810732-767365
X-HE-Meta: U2FsdGVkX19bHSQ8zaxK9+yg6AWaiU5YfSBRg/kkJ+4FH1U3VZKCz8R3HGiCetUKn/OAwWlALU19+03s4MK7P6130ut4Z3bRiNlScHw6yql6FmOgNUxvE91CH2eS66mCHLOs94eIhgTEOf4cYvaqJC0dVlIImGSqmzgZ/rzOO9hVf0RWMgFDQczbiH/APPY1BEkq+f16u8rX5Yp20wx6XMqNEQQmSo93K0/tXjLLnqWSYWZfqXn/wIYqi+oEAgQAt+ycud80cJrW/9egUsXPqJ5ObYtIZsj9fs7YMJHR4nPNkJdKIcBbqTegFsYKNbEzumrd0WDiXw53WAgd5UqPKPDC6d+JYbEQzK8qOPKNSV+BuZliaCkC4BYFTBURlFRMtDYqXuWPicj6CwCv6FEpsX9rbXZRUCi+klDhsggliWEP6qiFVvn0PQ9jV9/1MdkI2jdgnGxkjou9u8XtwfiRhb1I/GbTCWdLqMOZG40qeumSoD7lUOPIXNT+n2aqYCNATM4wYjswkDgnevPmBRLb+InybLyAMliLwhkaRgxtcrwzSrFyWnA6lRl/1mkOGFFVMsW91hImcl4Bo68r1Osp7hBDeScqs+rrOI1itedrj0vnEpk2SDQIVCwYSZQ3Xy8RPu1d6Nhm6XfOhMHz7Nl/TfwSgYeV2qAjtDF6Kh9Pxs9rX2D2F9lzmddg33lXlm5G+FLcA8TLI89ORhtwPBm+O+hyRh3DmDADdVASBuLi9SiyfGBexljML0fe4RTjG4NYLIbMmBxLKeyymGMK/T9dNByptoX002C6tdO3cz9qG3KZhaQ8q9wbBsbIRqviXYEtTOP/tsdb4k37C58ah10IXI7COH651EdpoZviT5foOFvtI68IZsykJ9U7w6As/RhVvARe4igwKaD5de0JwFzjp2OC2zeFNbBebp+FlNHpX1AKgACBRYpUgwgnSd/bvonOytn+UmB9aCVJA3hNGCp
 CMPJGsRb
 qn1w0GvDQseYtaK0PSToa4NkblYq7+m0jgMdHlqZ5j8UmV/eV8liCZDzOvOP5Hl+lbkTcShtCQc0Nislk9zE4FBhtBPA0uX9ttwgU+rmGRX+GovXCjCGNJpj6wsC1/tN7ndLtCJgdc0lYtX0DzfJmG4ZYnIN68F9dEKuYWxztdaOOmsUSuDzwZiMnBiln/+Bj/T+8+RW8kUMEWVMUxJTzW0Eq6Pq+QUoZbK9lTOnguRkAaSE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/07/2026 01:01, Yosry Ahmed wrote:
> On Wed, Jul 22, 2026 at 08:19:35AM -0700, Usama Arif wrote:
>> From: Alexandre Ghiti <alexghiti@fb.com>
>>
>> A large folio reaches zswap_load() only when the caller expects
>> the whole range to be on disk. Zswap still stores large folios as
>> independent order-0 entries, so reconstructing a large folio from
>> zswap entries would risk returning partially initialized data.
>>
>> Teach zswap_load() to scan the covered range. If no slot is in zswap,
>> return -ENOENT so swap_read_folio() reads the backing device. If any
>> slot is still in zswap, fail the large-folio read so the caller can
>> fall back to per-page swapin.
>>
>> Return -EIO rather than -EINVAL for that conflict. Large-folio loads
>> are now valid requests; the error means zswap cannot safely satisfy
>> the request from partial per-page compressed state, not that the
>> request is unsupported. Existing callers only distinguish -ENOENT,
>> so this is a semantic clarification rather than a behavioral change.
>>
>> Add zswap_is_present() so PMD swap-entry consumers can make the same
>> range decision before attempting PMD-order swapin.
>>
>> Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
>> ---
>>  include/linux/zswap.h |  6 ++++++
>>  mm/zswap.c            | 42 ++++++++++++++++++++++++++++++++----------
>>  2 files changed, 38 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
>> index 30c193a1207e..cd9efcf9dec9 100644
>> --- a/include/linux/zswap.h
>> +++ b/include/linux/zswap.h
>> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>>  void zswap_folio_swapin(struct folio *folio);
>>  bool zswap_is_enabled(void);
>>  bool zswap_never_enabled(void);
>> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>>  #else
>>  
>>  struct zswap_lruvec_state {};
>> @@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
>>  	return true;
>>  }
>>  
>> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>> +{
>> +	return false;
>> +}
>> +
>>  #endif
>>  
>>  #endif /* _LINUX_ZSWAP_H */
>> diff --git a/mm/zswap.c b/mm/zswap.c
>> index 4e76a4a87cdc..384492f1f696 100644
>> --- a/mm/zswap.c
>> +++ b/mm/zswap.c
>> @@ -1561,6 +1561,23 @@ bool zswap_store(struct folio *folio)
>>  	return ret;
>>  }
>>  
>> +/**
>> + * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
>> + * @entry: base swap entry of the range
>> + * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
>> + */
>> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>> +{
>> +	pgoff_t offset = swp_offset(entry);
>> +	struct xarray *tree = swap_zswap_tree(entry);
>> +	unsigned long index = offset;
>> +
>> +	if (!nr || zswap_never_enabled())
>> +		return false;
>> +
>> +	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
>> +}
>> +
>>  /**
>>   * zswap_load() - load a folio from zswap
>>   * @folio: folio to load
>> @@ -1573,10 +1590,9 @@ bool zswap_store(struct folio *folio)
>>   *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
>>   *  will SIGBUS).
>>   *
>> - *  -EINVAL: if the swapped out content was in zswap, but the page belongs
>> - *  to a large folio, which is not supported by zswap. The folio is unlocked,
>> - *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
>> - *  do_swap_page() will SIGBUS).
>> + *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
>> + *  The folio is unlocked, but NOT marked up-to-date, so that an IO
>> + *  error is emitted (e.g. do_swap_page() will SIGBUS).
>>   *
>>   *  -ENOENT: if the swapped out content was not in zswap. The folio remains
>>   *  locked on return.
>> @@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
>>  		return -ENOENT;
>>  
>>  	/*
>> -	 * Large folios should not be swapped in while zswap is being used, as
>> -	 * they are not properly handled. Zswap does not properly load large
>> -	 * folios, and a large folio may only be partially in zswap.
>> +	 * A large folio reaches zswap_load() only when its whole range is
>> +	 * expected to be on disk: PMD swap-entry consumers split before
>> +	 * calling into PMD-order swapin whenever any slot is still in zswap.
>> +	 * Confirm the range is entirely absent from zswap and return -ENOENT
>> +	 * so the caller reads it from disk; if a slot is unexpectedly still in
>> +	 * zswap, fail the read rather than return partially-initialized data.
>>  	 */
>> -	if (WARN_ON_ONCE(folio_test_large(folio))) {
>> -		folio_unlock(folio);
>> -		return -EINVAL;
>> +	if (folio_test_large(folio)) {
>> +		if (zswap_is_present(swp, folio_nr_pages(folio))) {
> 
> Is dropping the warning here intentional (for the folio_test_large() &&
> zswap_is_present() case)?
> 


Yes, so we can end up in a race, which should be handled gracefully.

For example, lets say we have zswap writeback enabled, which means we
can end up in a state where we have a PMD swap entry and 511 of the 512
slots have been written to disk, but 1 slot (slot X) is still in zswap.

We can then have the following race:


  CPU A: PMD swap-in                  CPU B: split-PTE swap-in
  ------------------                 ------------------------

  Checks swap cache: empty

                                       Faults slot X
                                       Adds order-0 folio F
                                       zswap_load(F):
                                         removes X from zswap
                                         marks F dirty

  Checks zswap range: empty
  A is preempted

                                       Unmaps/reclaims F
                                       zswap_store(F):
                                         puts X back in zswap
                                       Removes F from swap cache

  A resumes
  Allocates large swap-cache folio G
  zswap_load(G) finds X in zswap



The correct action would be to reject the PMD order read and fall back
to per-page loading.

I am bit torn about what to do for zswap here. The series is quite big
already. Alexandre is looking at adding support for PMD swap, but will
send patches once this series gets merged. My initial versions 1
and 2, basically stopped installing PMD swap entry if zswap was ever enabled.
From v3, I used Alexandre's suggestion to do zswap_is_present() test
so that PMD swap entry can keep on working.

Both of these paths are temporary till Alex sends his series. I
do feel my initial version was simpler but will basically stop
working if zswap is ever enabled. Do you have any suggestions on
what your preference is for zswap?

Thanks!
Usama  


>> +			folio_unlock(folio);
>> +			return -EIO;
>> +		}
>> +		return -ENOENT;
>>  	}
>>  
>>  	entry = xa_load(tree, offset);
>> -- 
>> 2.53.0-Meta
>>


