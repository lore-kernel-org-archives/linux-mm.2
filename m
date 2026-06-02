Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D1FCCD6E57
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 18:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 587A56B0088; Tue,  2 Jun 2026 14:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5386D6B008A; Tue,  2 Jun 2026 14:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426F46B008C; Tue,  2 Jun 2026 14:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 336F66B0088
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 14:56:44 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CCEBA1409C7
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:56:43 +0000 (UTC)
X-FDA: 84835879086.21.EC530F8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 13FED100003
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:56:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4lP3MaD;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780426602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9cejjzLubS+fRPmCUkiWzNoFa5RRSek41ZLe2/1/OLc=;
	b=aNdTnbk4SGvWDuxkWyNT8OuEhHub5oOwrbg7laYkAUE1sjZ9uhJilctXZS2DF/PjYPWSjK
	NP20DpsT3JYiBh8fkyKGm26NA0L7dYhagNoutMUQu8gzBhOfTIvCSFPZAsKRk3bITlUTZy
	odgxYLiOWafLFQM0A1hdlnr3XmSSYEc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q4lP3MaD;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780426602;
	b=hRmDnJyE47RG2iLtPSrT27VmAbALWNjSLXI2TWwyY87mu0ZYC1wdOWUFt9hGQhkr9/pzUy
	2N1H9UD+iG7KBDmasX2FXmn7K+6eYCBfbaqnm6Akk8y6S8dEUdBo+upzpZtT62Xrndx20u
	XkQaSmE5o+Thcykd6lG3Zx8T7o6YEAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D50460098;
	Tue,  2 Jun 2026 18:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0482D1F00893;
	Tue,  2 Jun 2026 18:56:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780426601;
	bh=9cejjzLubS+fRPmCUkiWzNoFa5RRSek41ZLe2/1/OLc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Q4lP3MaDlvX0mnm+6mrSmEmXPxxkFpEi2fB2vW5lkMSVz8Zrz8VGVqJVy6GgIp8So
	 QTnAE+C2nMV/0l1b+EWq+n1Edjt8lSCKs+BX20RARRcDfsFiA7rtVuQf/GX5UcCj0N
	 LbeR04Kk04HGzVKm18l3h7lfWbZhGJX0HaVBN1EWZGjEICPefs7tqkToLgz3RX8KjG
	 UIxMjrZQ8al+nyS8CNGDAgWHwWgPJTajRwOVp1BqzT8r2bUBaJ/lUJ3B9r2fzGmWCD
	 dju8sklgpO+9GPZ8StjqxbHDED3XQT4zA21G+enU5n+Kv6Ek9rfSFWuQavH4e6n4MA
	 N45+fzAEm+o2A==
Message-ID: <b03c0d32-07e6-4148-bebd-50784aa3cbb1@kernel.org>
Date: Tue, 2 Jun 2026 20:56:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while
 scanning compound pages
To: Zi Yan <ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Liu Shixin <liushixin2@huawei.com>,
 Oscar Salvador <osalvador@suse.de>, muchun.song@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260602130755.38794-1-kaitao.cheng@linux.dev>
 <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <34F0943E-4ACD-4655-B9B8-41F658FCDB7E@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 13FED100003
X-Stat-Signature: zt1bemad18jboxu7jzo5oacs6h8i8tpa
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780426601-799437
X-HE-Meta: U2FsdGVkX1/p8Mhy7fW4fuWEFjk91BkOK48rVV6U+qeuDvJeOjkq5M4iazSFll8c0bdJt0VTDrl+NRhh5SCjlmd9moLWWoZIVEhv5T897zwxwn2o+Co+VoAFOnW4fmVPLs4KAT3PfcScAT+QFO9b4wjTxtzP7uu1vuqWlmC3ggJKSBGYYh+LwUAWr/ksE/rEhau+FWLKbeQBGxca4ZARAnUMJh468qz6FoYveYRASN+zVYoGs0Kt0YXIOJBptZh9EEArzVXvr/2Jq4IORHwEvo9FRKQM+OwVKuzweReEQE/6GMGO0PqO1P5zLmmzmUcgWvl1EbfBByJ1jMQcJZiuuKmMSnABaiACCnsEonJ8BQTjk8+1lzC1Avn1bADgaUmiVQFVX/YkEzM38wCh+joVgrEhrhOksimtu3gk+xg6zQxAC0altUpSkJGDft6N8GLItr0pM85cZVx6RAl9vyklMfW0nUaNm5YF40SJH8HOOEUJgWI1CgnQ/QD6Rg8eUh9EbjdtrkBjlDmOnFxMLiLiWSFb4IugiIUsdBO/yknfChqpFUtgWEeh7Y65W7E7NNom6FrvXnMZpslVdj0r/uuANZoKypjo8P9Y9dGQ588CWQKqLeVr8TBx29l6hRaXDwG/gNt5h58g9Lzxdtt+zSCshLODnSRn3s+RIu83lnQbzbFh3sWftp0WyZwpZudtduqVmhLXWdlKubLSS2Y9+ksSxjVwMejIxCES0jgCOmXVsVrgFS9K0WAhVcYxPD4Vrcu3PCedH+dzEf1vhLiZDoCxEEqpV4jewIRqptfy1hsVsB1fmGGcPNjzFfT0auhM13m4b/3UqCxqtUiiF11HY938/YR8/kH0kXDOkNjvvjJjDffW+G8xl2mVoulOy4EJcMfWW50+Xilpy3nEgihnDCfEqtPquSe0/Xa5susVIuAsF8BU1WBoGFGNMnmXDjBaD9yZf1dTi7IkmCMeHPlk8uF
 fNMN37h7
 iUcECd9t7PcsEdZ1qR73/pCiASdfFzdO8gPz6sJBqmq4iw11DA/1vQskyO3Vc/ErBGCUDGQ8EAW/A1Oq4A5DrXqpb2j9/2xzLcFW86He2l9f/+J4MeoB55i1+4xQYjmMjMBVSrvd7ogrk2PDzalM8a+InAsYVSfXYavJK0EEG1l+5jrohYf7kIElBGKO/ODPK7zgAFwJ9v/IeqxvPT+n0f/lIVpxuU8VQH4ELDj9NgnMdxUQvvd+cKXNr2fxpXLdGJQd/dP3pMjB8glkzLtUBuq7eS41qbwjVLJHhRjOvCRW/wXYmPr2rsTebUZJ+PykAIYOltnrRhTxEMao=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/2/26 17:02, Zi Yan wrote:
> On 2 Jun 2026, at 9:07, Kaitao Cheng wrote:
> 
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> page_is_unmovable() can inspect compound pages without holding a folio
>> reference or any lock. The folio can therefore be freed, split or reused
>> while the scanner is still looking at it.
>>
>> The existing HugeTLB handling already avoids folio_hstate() for this
>> reason, but it still derives the hstate from folio_size() and later
>> derives the scan step from folio_nr_pages() and folio_page_idx().
>> These helpers rely on the folio still being a valid folio head. If
>> the folio changed concurrently, the scanner can read inconsistent folio
>> metadata and compute a wrong step. In the worst case, folio_nr_pages()
>> can return 1 for what used to be a tail page and the subtraction from
>> folio_page_idx() can underflow.
>>
>> There is a similar issue for non-Hugetlb compound pages: folio_test_lru()
>> expects a valid folio. If the previously observed head page has been
>> reused as a tail page of another compound page, the folio flag checks
>> can trigger VM_BUG_ON_PGFLAGS().
>>
>> Read the compound order once with compound_order(), reject obviously
>> bogus orders, and derive the hstate and scan step from that order
>> instead of querying folio size information again. Also use PageLRU(page),
>> which is safe for the page being scanned, instead of folio_test_lru()
>> on a potentially stale folio pointer.
>>
>> Treat an unknown HugeTLB hstate as unmovable so the scanner does not try
>> to skip over an unstable HugeTLB folio.
>>
>> Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
>> Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
>> ---
>> Changes in v2:
>> - Avoid unsafe folio metadata reads in the unlocked scanner by deriving
>>   the hstate and scan step from compound_order(). (David Hildenbrand,
>>   Andrew Morton)
>> - Treat invalid compound orders or unknown HugeTLB hstates as unmovable.
>> - Use PageLRU(page) instead of folio_test_lru(folio) to avoid folio flag
>>   checks on a stale folio pointer. ()
>> - Update the commit log (David Hildenbrand)
>>
>> Link to v1:
>> https://lore.kernel.org/all/20260519121646.40833-1-kaitao.cheng@linux.dev/
>>
>> ---
>>  mm/page_isolation.c | 19 +++++++++++++------
>>  1 file changed, 13 insertions(+), 6 deletions(-)
>>
>> diff --git a/mm/page_isolation.c b/mm/page_isolation.c
>> index 7a9d631945a3..32ce8a7d9df3 100644
>> --- a/mm/page_isolation.c
>> +++ b/mm/page_isolation.c
>> @@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>>  	 * We need not scan over tail pages because we don't
>>  	 * handle each tail page individually in migration.
>>  	 */
>> -	if (PageHuge(page) || PageCompound(page)) {
>> +	if (PageCompound(page)) {
>>  		struct folio *folio = page_folio(page);
>> +		unsigned long nr_pages, pfn;
>> +		unsigned int order;
>> +
>> +		order = compound_order(&folio->page);
>> +		if (order > MAX_FOLIO_ORDER)
>> +			return true;
>>
>>  		if (folio_test_hugetlb(folio)) {
>>  			struct hstate *h;
>> @@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
>>  			 * The huge page may be freed so can not
>>  			 * use folio_hstate() directly.
>>  			 */
>> -			h = size_to_hstate(folio_size(folio));
>> -			if (h && !hugepage_migration_supported(h))
>> +			h = size_to_hstate(PAGE_SIZE << order);
>> +			if (!h || !hugepage_migration_supported(h))
>>  				return true;
>> -
>> -		} else if (!folio_test_lru(folio)) {
>> +		} else if (!PageLRU(page)) {
>>  			return true;
>>  		}
>>
>> -		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
>> +		nr_pages = 1UL << order;
>> +		pfn = page_to_pfn(page);
>> +		*step = (pfn | (nr_pages - 1)) + 1 - pfn;
>>  		return false;
>>  	}
> 
> LGTM. Thanks.
> 
> Just a comment, order can be dropped and use
> nr_pages = compound_nr(&folio->page) instead:
> 1. order > MAX_FOLIO_ORDER -> nr_pages > MAX_FOLIO_NR_PAGES
> 2. PAGE_SIZE << order -> PAGE_SIZE * nr_pages.
> But it is not worth a new version.

If we use compound_nr, we have to check for power-of-2, like
scan_movable_pages(),  as folio_large_nr_pages() might use the per-computed
value (which might read garbage).

-- 
Cheers,

David

