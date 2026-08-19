Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3695C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 09:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB41B6B009B; Wed, 19 Aug 2026 05:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B846B009D; Wed, 19 Aug 2026 05:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC85E6B009E; Wed, 19 Aug 2026 05:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8716B009B
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 05:05:59 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 156A240487
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:05:59 +0000 (UTC)
X-FDA: 85117436838.10.772DD05
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5166D100008
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 09:05:56 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=eO7szIPe;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787130357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GR0Iu6H6PDazI16+rVYPbxLdITggVxZY8J6rOkCftR8=;
	b=X4KzmjHHyxF6E9EP+2WiK50pnGZmiC0ADRqhVsGoI26uKquAqp9eFWnMk1yS+3aBU4NJNs
	uAlp0SL2vHnMWlthvTIfvA1JSldIQ2J4RGaSIdRKhBgwH381B7cPiMNDRajqHVVsL+y5pA
	St+G8HCkQaIrQv3y2YTGrEVOQ5kF6Wk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=eO7szIPe;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787130357;
	b=s8t+GZQJJL9gXhHpri26xIBIPvWiEHU548mDVADYx/HiKXy0+HYm7P581zc7vidF9b8BJ7
	rpYB24ey8ru02n2KkMeV6n2dHdTc66btGqTItkwOivxxDcKEMCopw4/fCr0WYaIT6+AroO
	hOyX36xfEHF6sUQic5CpT1bSONaEyLQ=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=GR0Iu6H6PDazI16+rVYPbxLdITggVxZY8J6rOkCftR8=;
	b=eO7szIPeS+RuMp5eFxXT4g5QYQfc7ul8QUKX7mF8bmrTOZYsOcE5zofFJSOgD5x0NxVLmtqjZ
	MbA36pR7X7zBCG/4J9k6p+oWcdHA+nXG92jj7aNnLwby509v0toNtU52WDN4gFqPZmrb5SLLaqo
	WuQfhIUvFZyJZx2TqdRzdFc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hQ0kt5w1nz1prQt;
	Wed, 19 Aug 2026 16:55:02 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 26FD24056D;
	Wed, 19 Aug 2026 17:05:46 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Aug 2026 17:05:45 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 19 Aug 2026 17:05:44 +0800
Subject: Re: [PATCH v2 7/7] mm/rmap: batch the unmap of large folios in
 try_to_migrate_one()
To: Lance Yang <lance.yang@linux.dev>
CC: <shivankg@amd.com>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<ljs@kernel.org>, <riel@surriel.com>, <liam@infradead.org>,
	<vbabka@kernel.org>, <harry@kernel.org>, <jannh@google.com>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<matthew.brost@intel.com>, <joshua.hahnjy@gmail.com>, <rakie.kim@sk.com>,
	<byungchul@sk.com>, <gourry@gourry.net>, <ying.huang@linux.alibaba.com>,
	<apopple@nvidia.com>, <kmanaouil.dev@gmail.com>, <fvdl@google.com>,
	<kinseyho@google.com>, <weixugc@google.com>, <bharata@amd.com>,
	<rientjes@google.com>, <dev.jain@arm.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <860941c2-287f-f88f-920c-6d99e2cd4483@huawei.com>
 <20260818092032.47670-1-lance.yang@linux.dev>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d471430f-aa41-4825-201c-4a0e04cf7a58@huawei.com>
Date: Wed, 19 Aug 2026 17:05:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260818092032.47670-1-lance.yang@linux.dev>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Stat-Signature: k7xy1gu6hyzmoxrf84qckx4ch7483nct
X-Rspamd-Queue-Id: 5166D100008
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787130356-678043
X-HE-Meta: U2FsdGVkX19zpe2lOOvuO0XQELDdjnnV86d+1ClJIldokRzJMCU9NWQuVICkgr5A+askEY1em+PkQd5F5dAdolmMkKGvCZIT7dv3XQaIvzJkqTM3NIqKgC8m8C9oTz+sey6oqQvTxz9YYpE+ctAwV5nJ9OzAKvk5SauhOrwnFCbPhpLfbFV2mqctltfHrs0akKswybFkCx0XBOJfoui6+rGyT+Z2E2LsiWHXsIZZgFhaA1uil3l7TbSy5/vyyFnPTRoN45YbLpu4tvuoinANzpkR4BLx1IimkbbwRwpmbw0adpUwPce+38ekvm/ypc/hHR+Vkyya/AfzDd9H4ibVYRFCHul2SvP8Yizfqv5pX30QKGPIqiB/Az8TseZvAixwcP0hoN1p+LAIwbTk85FtLHaGZoOyZynDD9X4XSagfM/ACGqMa91U0ooETuwZJXjLUWwXQplI6BoQtnEEyxJCTvZb9AmpLH5Di89JgPymBMUNFxGMGPLuDNuW8wGQcuy84IB3Nqsj7jJW7D2QnAu2+sMlDfmyVy3p7kb7AZoMoYUaXApu44r5aYcef+ZT1Shqqrvxv0MXFSCtZ0GnJt7JtQgHQvxpytw9gNOf4m73VPDsC8DofS5KDtadzOK+Nr9KBw35FJ4YKxYIq9jeRZ0Z0/B9y+33BdcTHkUQrrEz2bEWnTfcdx2SNY0/sTimP87iXJnN+N7AktRZtgzBIgfCMN9mnFaebfhhf41MR7UjG4NNQNXuVoA4FJ9A7JsGFN7uD4FRjh06Q1C+kdBmvyuOeWE0+v3CbGEblMV6X5RNHjetEF3aitGTjnMCYDPcv0TcWuJmaPipt5frE1S1om4G9R5WmjDjw1tWh96siIWW/QNCIR4O+Iph/T/ceEvCkXEXYVeRiUH4WruJiRQXZS1hENVHDxsBMf6zpWoUGni0ElmPg8KA3nt0oA1/qL7JmDR36AwnenywJkMwvKYRMT3
 mXOwIqSC
 lqHN/ALTPBn8UheW/7jeuY8R88TksgUOulzTvpU1HyBBvdupltNDv7N6iYSlWJAoVpwI5vC+ym4Cdgvmdkpn3TrfW5O11Zzo5XueMZ7RGu/h1h+Shx8ul57uAgJ3vYQc9na0gdAwgtg5Leton+rP3Z108YfXwRWl/gqf1OuAwXQsKgP29olpM4xL4EDNGBM9avt5VnwdBM2M3ETgXSvZe0BjXyLI+wW/PciuvUmlfthAigG/4sCOAzpd4UQIB+5wVvPcDpDKX1smGViJvzy4knGNSk11Kus4+LOViTz8sTRdwXE01Yn2+QJQY/4kmQV12HAfbk7jp/vAAvXpmwRN9KORirlqngdYg+6G9eIb9qow1xJKJnJXHiWc0zmiD7CCVG1C7FlqeqyhFQKMqsQ/NdrYPfMmcJ5mVTI1wR9FIcakyB+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/8/18 17:20, Lance Yang wrote:
> 
> On Tue, Aug 18, 2026 at 04:55:06PM +0800, Miaohe Lin wrote:
>> On 2026/8/17 17:14, Lance Yang wrote:
>>> +Cc Miaohe
>>>
>>> On Thu, Aug 13, 2026 at 04:23:18AM +0000, Shivank Garg wrote:
>>>> try_to_migrate_one() converts present PTEs to migration entries one at a
>>>> time. For a PTE-mapped large folio, this repeat calls to ptep clear+flush,
>>>> the migration entry build and set, folio_remove_rmap_pte() and folio_put(),
>>>> each re-entering page_vma_mapped_walk() once per base page (256 times for
>>>> 1M folio).
>>>>
>>>> Mirror try_to_unmap_one() to introduce folio_migrate_pte_batch() to detect
>>>> eligible batch for PTEs mapping conseuctive subpages of a large folios,
>>>> and convert the whole batch in one shot using the batched helpers.
>>>>
>>>> A side-effect of this change is trace_set_migration_pte() will record
>>>> one event per batched run instead of earlier behavior of one per base page.
>>>>
>>>> Signed-off-by: Shivank Garg <shivankg@amd.com>
>>>> ---
>>>> mm/rmap.c | 115 ++++++++++++++++++++++++++++++++++++++++++++++----------------
>>>> 1 file changed, 86 insertions(+), 29 deletions(-)
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 35752a70f3a0..63b885c0b7ef 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2675,6 +2675,44 @@ static bool try_to_migrate_hugetlb_one(struct folio *folio,
>>>> 	return ret;
>>>> }
>>>>
>>>> +static inline unsigned int folio_migrate_pte_batch(struct folio *folio,
>>>> +		struct page_vma_mapped_walk *pvmw, pte_t pte,
>>>> +		struct page *subpage, bool anon_exclusive)
>>>> +{
>>>> +	unsigned long end_addr, addr = pvmw->address;
>>>> +	struct vm_area_struct *vma = pvmw->vma;
>>>> +	unsigned int max_nr, nr;
>>>> +
>>>> +#ifdef __HAVE_ARCH_UNMAP_ONE
>>>> +	/* Cannot batch unmap if arch_unmap_one() is defined. */
>>>> +	return 1;
>>>> +#endif
>>>> +
>>>> +	if (!folio_test_large(folio))
>>>> +		return 1;
>>>> +	if (folio_is_zone_device(folio) || folio_test_has_hwpoisoned(folio))
>>>> +		return 1;
>>>> +	if (pte_unused(pte))
>>>> +		return 1;
>>>> +
>>>> +	/* We may only batch within a single VMA and a single page table. */
>>>> +	end_addr = pmd_addr_end(addr, vma->vm_end);
>>>> +	max_nr = (end_addr - addr) >> PAGE_SHIFT;
>>>
>>> Hmm ... can this still batch over a poisoned tail page?
>>>
>>> memory_failure() sets PageHWPoison() before taking folio lock, but
>>> cannot set PG_has_hwpoisoned until it acquires and releases that lock.
>>>
>>> So tail page can already be poisoned while folio_test_has_hwpoisoned()
>>> still returns false ... no?
>>
>> When memory error hits thp pages, memory_failure() first set PG_has_hwpoisoned and
>> then tries to split thp pages. And try_to_migrate() will be called to set migration
>> entries for anon pages. Does folio_migrate_pte_batch() work on this case? If so, the
>> folio_test_has_hwpoisoned() check above could catch the bad pages?
>>
>> Or do you worry about the scene that meory error hits a thp while it's under migration?
> 
> Yeah, latter case is exactly what I meant.
> 
> try_to_migrate() is called with folio lock held. If migration already
> owns the lock, memory_failure() can set PageHWPoison() on a tail page and
> then block in folio_lock(), before reaching folio_set_has_hwpoisoned().
> try_to_migrate_one() may meanwhile start from a healthy subpage, see
> PageHWPoison(subpage) clear and PG_has_hwpoisoned still clear, then batch
> across poisoned tail and install a normal migration entry for it.

Even if try_to_migrate() batches across poisoned tail and install a normal migration entry
for it, memory_failure() will call try_to_split_thp_page() and unmap_poisoned_folio() to
unmap the poisoned tail. So it seems work. Or am I miss something?

Thanks.
.

