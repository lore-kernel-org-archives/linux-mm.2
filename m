Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0C04606A322
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 03:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=2212171451 header.b=m/M3nNSa
Received: by kanga.kvack.org (Postfix)
	id 9BF0F6B05B1; Sun,  8 Nov 2026 22:01:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9705C6B05B2; Sun,  8 Nov 2026 22:01:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8862D6B05B8; Sun,  8 Nov 2026 22:01:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E3516B05B1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 22:01:47 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE513405AB
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:01:46 +0000 (UTC)
X-FDA: 85414080612.02.C10356F
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf02.hostedemail.com (Postfix) with ESMTP id A2D0B80006
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 03:01:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="m/M3nNSa";
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794193305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1hRQQIAsbz+9/1zs9i6aKCxFWN+3vpkyx/yMvD7P5R0=;
	b=qkd1nEP11gJ5g2D/0/xpFI18t/hkzGX1YNU/vjQFdeXaYbwx4bPQvXm4GduXAAngnz7uZG
	1nuRzUOQ+QqJFkqdLCAMmQqCphO11seZuN0flpKEhrd8t91SKTkOCWWkMnBir3GhEjxWPN
	8kOoKfo6gOjKJ5rxst7CfoOg9a35z34=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794193305;
	b=u+U/e2KcaT7XY3qei05TYNvj2GafwyihxP8308BRWCbPKKqR3xSxg0jWQK9k+0TO5kfIOc
	70yDOjeI2DQCiWZiIYZxcKfhRX0+JZl//O6p3dlvDQvY6iT8pFINWAQ/e1B2DOZQVln8cY
	qeizjFLCxvgHRQu7yq+Gn2kfW3O/hd8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b="m/M3nNSa";
	spf=pass (imf02.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1794193299; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1hRQQIAsbz+9/1zs9i6aKCxFWN+3vpkyx/yMvD7P5R0=;
 b=m/M3nNSaCgcFvkdm/HHNAAMt37vXUvpsM73KpNkVPbPSmtGywXj+ugLFJJa9jxCZuHhIgR
 npcEy8Iu5Ve50j8kMiadiWIuq6/GOFpXBysKFXaqZz6gQnj4579jgYwYDEeZ4W+Mv7YqCe
 bhNnBZbKO/GD/SeqQRlxRbTzAZ+jr/9JFHuoiwPPHVnwjABm3+ZPWNMHvtM7EUUeucHMOk
 CyAPPIeMorkQkfmYpaup6/nw5WPnbQ0L3bEMkplPRgYeq4BPk+iW5lJqicG0/CH2o/xsbV
 cv4wJOmyrDgKTgecpKGNWFizghBk/29pCOo1EK3WyMTMU7cvHt7BLzty9PqwrQ==
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <david@kernel.org>, 
	<akpm@linux-foundation.org>, <rppt@kernel.org>, <apopple@nvidia.com>, 
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
Subject: Re: [PATCH 2/2] mm/hugetlb: optimize bootmem hugepage tail vmemmap init
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
In-Reply-To: <au2qhlsxQt3SRwIu@parvat>
User-Agent: Mozilla Thunderbird
To: "Balbir Singh" <balbirs@nvidia.com>
Date: Mon, 9 Nov 2026 11:01:22 +0800
Content-Transfer-Encoding: 7bit
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Message-Id: <ca38db3a-a8fe-47c3-8813-5c3b0ac4b7ac@bytedance.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26af13791+271c33+kvack.org+lizhe.67@bytedance.com>
References: <20261105120615.16817-1-lizhe.67@bytedance.com> <20261105120615.16817-3-lizhe.67@bytedance.com> <au2qhlsxQt3SRwIu@parvat>
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: e1i1gbpf3q3xz541s7wq1p4tysom4559
X-Rspamd-Queue-Id: A2D0B80006
X-Rspam-User: 
X-HE-Tag: 1794193304-905416
X-HE-Meta: U2FsdGVkX1/0b69hOc8gUrFnBFDx4tQcJGMAXR1R1as5hecfKTzA5n30vfUV6anFG3eeqMh/iMbLZtneXXjOkQWun8IDaMuT9mTHqg9YAyTbj8y7CuY+oovUTo8mu/ApE1kakKyud4/Eu+eMvkLnbS523fGA6+bkgAbJDQLxcJ+0+IIq1/5l1M6QEMO09CXwWL59P5Y1/0zLed8Z2WQFJxXW3mKAty0FLEF+2m96PM8o6XdJv4GTHadJPomyIn3aRNZSEAuDNHy67SnwWIUrz4kKsbCA7skkZFs/81vVwhCNdw/X+Pl+FLoIF3dnD+OWqF6JP02fUYxZAFm3S3ynil+aoKQNhOTSthxD2AEbuQVeBooIgHHuxMd6E8LTFeBQvpN+uqm7MQlSZ17/SXPZt5Q1t7TnTeDthY3VCWly7h1pFeR1XUA1X5WorCHtMwMQqwOQuTYkk4tFQgH1lDl1/bQPhFRwuTDDSAyruJB4rOd4kXblYxs1KJjNdnof6KBmN0/7FHOad/sGKeSGjB5n5raw8LNrQo4+AfUtnQam7vuYQmaD80025VqPPlaTIJXByZxb7Y1vfp0tyeypPatkyplQignERZHrFPQmw+tSoDTQXkUBMiQk3O70F4nEOC3l1VntFs4GelAARUm4GgkodX8OxfQMKceRXjnteyY7/pfRySzvqfdnma/enZk04Vn0tDwcxI90Fod4Rkm0MbZnsluDj5gMKW0lEUugtU1qBo6VROYQxTxMbczzigzR0fJGLG7oJMwnBkPSDZtIYaeW8OmNsBf+nX+41uUvMrGLmR9IwlVWUcMpyThHrc9/eUDZ33lb0LoWwkgYJEjJV6C2qi7EQfd+a5Bg0CO73qdIYYALfb2jeEwhUnSp0Ja52MCdP9bFZqt9ElHuSc5tvk+bZGwXtu9vzJtNW0PDGyKRGggnqZ4GbnzUkq7M57ZcPjTNEXeyd91oeQ6C1jmy4LC
 TlxZdz2S
 n8cmM21KEbdacq5tap5TwMHg9mxxblWhpm8EdDq5Gh9khSEUZOgeXqmFbVkYcg9QwVkFo628BTMRPuM2l30Xu8BjKdKtTQP2N12Nw0Nr3hcboQyqYxXBEfGCNkvhNNIk8wSFnF5E9L5ITdEHoJ9hiU7mQf3xC0RY4vnw9JYTH9fT+M0xBSDpxM5limiJ9mgRMRtevz5yztnZ+k8nhCVJhZgUPnf/Wul+bAF87aOvFTlE49EIbFPnlJaXcz4+SwmO6Et8ub8GPBhTB1pgyQkmL9XUa/CVKBzJ2lNx1bgGnkcXX8JxRaD++/DfGY7KMMOFWaGsi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 6:23 PM, Balbir Singh wrote:
> On Thu, Nov 05, 2026 at 08:06:15PM +0800, Li Zhe wrote:
>> Boot-time HugeTLB allocation has to initialize tail struct pages itself
>> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
>> gigantic pages, this can cover a large number of tail pages.  Most state
>> installed by __init_single_page() and prep_compound_tail() is identical
>> for every tail page in the same huge page; only PFN-dependent fields
>> need refreshing.
>>
>> Initialize the first tail page normally, copy it into a local template,
>> then initialize the remaining tails from that template with
>> memmap_init_page_from_template().  This avoids repeatedly doing the full
>> __init_single_page() and prep_compound_tail() sequence for state that is
>> identical across tail pages in the same huge page.
>>
>> On an arm64 QEMU/KVM guest using 4K pages and 64 boot-time 1G hugepages
>> (HVO unavailable on arm64 in v7.4-rc1), the measured fallback tail
>> initialization time improved by 36.43%, measured with a temporary
>> jiffies-based printk modeled after the existing timing in
>> memmap_init_zone_device():
>>
>>    base:             318.4 ms
>>    with this patch:  202.4 ms
>>
>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>> ---
>>   mm/hugetlb.c | 23 ++++++++++++++++++-----
>>   1 file changed, 18 insertions(+), 5 deletions(-)
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index da5d04edf7c1..987f16a5ea27 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -3219,19 +3219,32 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>>   	enum zone_type zone = folio_zonenum(folio);
>>   	int nid = folio_nid(folio);
>>   	struct page *page = folio_page(folio, start_page_number);
>> +	struct page template;
>>   	unsigned long head_pfn = folio_pfn(folio);
>>   	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>>   	unsigned int order = huge_page_order(h);
>>   
>> +	if (start_page_number >= end_page_number)
>> +		return;
>> +
> Can this actually happen?


No, current callers always pass a non-empty range. I kept this to
preserve the old for-loop no-op semantics for an empty range, but it is
not needed here. I will remove it in v2.

>
>>   	/*
>>   	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>>   	 * we must initialize them ourselves here.
>>   	 */
>> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
>> -		__init_single_page(page, pfn, zone, nid);
>> -		prep_compound_tail(page, &folio->page, order);
>> -		set_page_count(page, 0);
>> -	}
>> +	pfn = head_pfn + start_page_number;
>> +
>> +	/*
>> +	 * Seed a template from the first real tail page and refresh only
>> +	 * PFN-dependent fields before copying it.
>> +	 */
>> +	__init_single_page(page, pfn, zone, nid);
>> +	prep_compound_tail(page, &folio->page, order);
>> +	set_page_count(page, 0);
>> +	memcpy(&template, page, sizeof(template));
> Do we need a separate template and page?
Yes. page is the first tail page that has already been initialized
normally. A separate template is needed so that later iterations can
refresh the PFN-dependent fields before memcpy_nontemporal() copies the
final state to each destination page.

Thanks for the review and the Ack.

Thanks,
Zhe

>
>> +
>> +	for (pfn++; pfn < end_pfn; pfn++)
>> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn, zone,
>> +					       &template);
>>   }
>>   
>>   static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
> Acked-by: Balbir Singh <balbirs@nvidia.com>

