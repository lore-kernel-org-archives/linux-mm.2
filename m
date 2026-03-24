Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 580B6D58CC9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90BE16B0005; Tue, 24 Mar 2026 08:42:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895F26B0088; Tue, 24 Mar 2026 08:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 784286B0089; Tue, 24 Mar 2026 08:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 630466B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:42:12 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D60A1A0525
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:42:12 +0000 (UTC)
X-FDA: 84580919304.06.F69223C
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3977140015
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:42:08 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ri4tlIP0;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774356130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3241e3s+MiyU5BLwErJgFwVhtp2oe3MRGyxbrwZaWPo=;
	b=Jv+nMjJwZHKr5AWQZgHv2KnMVo9IA90o/2mg0Is++XucLA3I6WeLxamZ6Tm2D9xvIyypBP
	tIw/t5z8RJ4PsARR8bvpk69Ysg2akxZHQvbZ0dyIvZDvEk1vNYOEk4cakKtTZDbOD9cTS3
	Pq1yOJdkLKs6YCIwT7NsQyvOTnsoh68=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Ri4tlIP0;
	spf=pass (imf01.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774356130; a=rsa-sha256;
	cv=none;
	b=6pnwxp8T7idLi9CT5yKqKHa0XZzu8BFRIC9DdicZOM7p2Ict26jqQviSUubXkYHFyVEHhl
	RDRnlGs5k+3MdGUVZxI4M3V/AvdhyEopExG84uRGdp6H9y2FJTk9lc1uFf3HDpvxsyxTzY
	l/3SwS5uVZOsJqq8pMFxKnpvSnmlbC0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774356125; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=3241e3s+MiyU5BLwErJgFwVhtp2oe3MRGyxbrwZaWPo=;
	b=Ri4tlIP0Meanxv6Kypzu9QN3HNaEHmDXATeDKmpWDJIpKU2znEYw+SDySwVarm06cYpamfV78fTPWCYJJXJU1RJmqN4U7AXP64oEncHVOgpBIPdLgSclvJNiq7l4+M++uxPhOfdqNQZx4rnz8mBG0PxMCcGmKn/TSptCHk/fPRI=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.eWkM2_1774356123;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.eWkM2_1774356123 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Mar 2026 20:42:04 +0800
Message-ID: <551b3c0f-5f49-4c00-ba79-7726e5c5e9de@linux.alibaba.com>
Date: Tue, 24 Mar 2026 20:42:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/13] mm/huge_memory: separate out the folio part of
 zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org>
 <ce065f40-38a6-4601-845a-78021af80f04@linux.alibaba.com>
 <2f8decdb-4ff7-4482-b50d-6718f25df8f9@lucifer.local>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <2f8decdb-4ff7-4482-b50d-6718f25df8f9@lucifer.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3977140015
X-Stat-Signature: 3tyy9pooprg3ziosda6d6kb77mwe4ku3
X-Rspamd-Server: rspam06
X-HE-Tag: 1774356128-291240
X-HE-Meta: U2FsdGVkX18sGQS9/lLfE+BHETQ3fNkFltcLPKaa2YoqumzY897qeCcgs3ERUT5wzavgc/aarSn76GN5NnDenbl7V49g6PpkSEiSPayGglFZ7CnLGar5spyM6znhwc5eCT4DNx90cyoV689tsFOnBXuhsqRFukZzoYIzSOiKBgBwLthtM/bb/9f4S4cnkbIapB+lZwqRl3R5zcfy5/N0A/WIzkAqlhn3LP3Pqf5nZxQIN5pfCIeA79/341m9m/JxQkZCwFlrF6wmI3cuWtI5rWzR03rfvwItRm+JGr5UYVMSiqGt7gGQ4yUjD8OXDyNMtEV4WH1D6rQPBfnY1ctqACuAS2dQ/LCjs2etvhDctR/AFAfDET5z7oCOb8tPJZzDxa+y7VuOLbGfNYa3EEjX2oS31YIj8zv2X4k4qXXIPEGOnhiBtfOwvcM7Ua3enjA4HygmWac+ec4DAhG0s1XmpcJijOFlygrMk4BZaxTPtdwet3m+us6Ewxeyjyj+Us9bVA0jZUm1tImS+QDLogmmJG4Cfr4ADGqxM6oytSLFt0f7tZjfaFbTOuL58rdDAopF2f5BVum1RNrCf6AMnqSB9cfqkyn3yvyyvSmGmn3AxxuJJstfpTrsxQTg0eV6jQXRcOBWGZ+/NCVUgfJH1fNlqItZhgFNnYfTJch6XI/YEG+NUJwyfllYnn4mcgnJaFQHvzjRVXGMcMOtH9+JCgAvN6+awNEpMHH/oz6Dex8EOWQDFwolkYvSGkmIGfszK842E3xLN3kxE2VfOENgNT3CdF3KPqh9ppBE3L9irMGcryOn8yHgkpmE+T44IBFVpsefCv7v8A+9LBPVJRTCnRHkI8I9kkkomEyQZ9MmaOogp6eDyq41XD75+1itnBHjUbeEup3FxBhlY5HM2Z872jInCnFbGjxJD/SFrN8LeAhQr2ZoiOW57iWc6/SdVbh0OEGRXe/dZQ0XXGbtClM3Ng3
 hDjz1+t2
 XP3gUweyNhptrQ27Zf9zngaI1zmrrwA1SdaQaSOhkWbslRZF4EQkV+/T4BY7e6zyPQv2UhxP30H4JoXPQ3B6NrRZ70z6ddFqkw2TK5PUPxvJr1A6jIITelsvxGLnc740CB9hMuigb+Rs0L/d7x6RTZjdlILrq4N7NeZ4N2WKHCt/yevejYTFNvbyrDBKEYjcmo9fQVTXO7fP79TTufdrxKjbA2LZ5J46i162iVCbSwr+CgEMpvkGYXConYhqZof8UY3xe+2k8fulaevE+ZPhy+Ps2noc8bHsiFpIhzTxfykuLNx4EXJV7bayJj6pWAR83334QRcM3m1+eUe2d4dYbr9oHokb8rWl1CFsvgL27nKZKYFVLk9BkWv1OuJZG31hadJDWPPfBDYCgfIZhtv4sA9/KQB93SboBsc4p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/23/26 6:42 PM, Lorenzo Stoakes (Oracle) wrote:
> On Sat, Mar 21, 2026 at 01:59:34PM +0800, Baolin Wang wrote:
>>
>>
>> On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
>>> Place the part of the logic that manipulates counters and possibly updates
>>> the accessed bit of the folio into its own function to make zap_huge_pmd()
>>> more readable.
>>>
>>> Also rename flush_needed to is_present as we only require a flush for
>>> present entries.
>>>
>>> Additionally add comments as to why we're doing what we're doing with
>>> respect to softleaf entries.
>>>
>>> This also lays the ground for further refactoring.
>>>
>>> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>> ---
>>>    mm/huge_memory.c | 61 +++++++++++++++++++++++++++---------------------
>>>    1 file changed, 35 insertions(+), 26 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index 673d0c4734ad..9ddf38d68406 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -2325,6 +2325,37 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>>>    	mm_dec_nr_ptes(mm);
>>>    }
>>> +static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>> +		pmd_t pmdval, struct folio *folio, bool is_present,
>>> +		bool *has_deposit)
>>> +{
>>> +	const bool is_device_private = folio_is_device_private(folio);
>>> +
>>> +	/* Present and device private folios are rmappable. */
>>> +	if (is_present || is_device_private)
>>> +		folio_remove_rmap_pmd(folio, &folio->page, vma);
>>> +
>>> +	if (folio_test_anon(folio)) {
>>> +		*has_deposit = true;
>>> +		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
>>> +	} else {
>>> +		add_mm_counter(mm, mm_counter_file(folio),
>>> +			       -HPAGE_PMD_NR);
>>> +
>>> +		/*
>>> +		 * Use flush_needed to indicate whether the PMD entry
>>> +		 * is present, instead of checking pmd_present() again.
>>> +		 */
>>> +		if (is_present && pmd_young(pmdval) &&
>>> +		    likely(vma_has_recency(vma)))
>>> +			folio_mark_accessed(folio);
>>
>> Nit: these comments were added by me to explain why 'flush_needed' was
>> used:). Since it has been renamed to the more readable 'is_present', these
>> comments are now redundant and can be removed.
> 
> Ack, I think it's _probably_ ok to leave that as a later commit removes it
> anyway, if that works for you?

Ah, I saw you removed them in the following patch. Looks fine to me. Thanks.

