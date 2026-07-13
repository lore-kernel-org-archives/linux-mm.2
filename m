Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69975C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:59:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41BCF6B008A; Mon, 13 Jul 2026 02:59:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A61D6B008C; Mon, 13 Jul 2026 02:59:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 296B16B0092; Mon, 13 Jul 2026 02:59:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 02BB76B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:59:04 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F19CC8038
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:59:04 +0000 (UTC)
X-FDA: 84982851408.01.2153070
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0C58C20014
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:58:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qXCC1xCt;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783925942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hiXNQPcCJUljcMWWjch223cmCy8YoOLb2FyOyIh3bIA=;
	b=IMPIvx15kiUsNGCWl5NQLsI4VXQQydXvWfZcwrXZllFWOJoKNOCp+M2E7eB9BZvxqK+SrP
	3+jrSHLubhubEBNi9niWEsZqR4y/kSc+uTtxj8NgZ7ErTB9Hqcop/KpkSunhre99I/PIvT
	fF/Tv/8vgeV+s/tyPoy8+szhAwCX5ss=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=qXCC1xCt;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783925942;
	b=K0PPY/gJKvoAi6rP+bbKFtFfIvivFQbVRFCHLPBwjTa5Yaf5VzAHTDU3Z05MGcH54mVxLg
	wF2RYG2YtalEYtJsoVkZygOtkaGzEkQuKipKc0z6jBpP6cvhRt59Ux61pg3fRGIRLqb1YM
	Jlr97Phu1RIYZBGSPqr9JhXDkIJ8Cgw=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hiXNQPcCJUljcMWWjch223cmCy8YoOLb2FyOyIh3bIA=;
	b=qXCC1xCto41/2vrxiSRcbyvVvDaWGsHIXb39FpqShIXihCz9LW7ZYY0A+QoVF1yUYBipT1Jmi
	do0wHc/uOTWwaQbysrxultC1K6f23YMILt9G+NXtZ+Bm8U80r/QpwRPBYBlV+J83gxvEsg6KLOO
	hVlsSYJGG6vJdIEJ2LDCw+U=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4gzCjM0mdkz1T4Jg;
	Mon, 13 Jul 2026 14:49:43 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id BDFD32025F;
	Mon, 13 Jul 2026 14:58:50 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 13 Jul
 2026 14:58:49 +0800
Message-ID: <8b51832b-391d-4497-8135-8a3cdd4e4f57@huawei.com>
Date: Mon, 13 Jul 2026 14:58:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] fs: stable_page_flags(): use folio_test_*() helpers
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ziy@nvidia.com>, <luizcap@redhat.com>, <willy@infradead.org>,
	<linmiaohe@huawei.com>, <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260702110614.2176986-1-tujinjiang@huawei.com>
 <20260702110614.2176986-3-tujinjiang@huawei.com>
 <905c7dc9-a0d5-4b28-a899-53798fc4628e@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <905c7dc9-a0d5-4b28-a899-53798fc4628e@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C58C20014
X-Stat-Signature: fuximp6pszqt1w6i111qkrhssiemernp
X-HE-Tag: 1783925939-470160
X-HE-Meta: U2FsdGVkX1+SZFQvwsjs0/e9x/WzQHI0ybVMEqfroJmDQ6WRmJxuvyqrlvk1phtiDbI+6l/RT8/DqL2dT2GCqLH8OItTjDRVP0zwJCirQ99U4ad5CBPAo5mNAdvnbCpQ/16734/ZneWBgprsdKH7kHcV8eUTXd2N/R4iZ8uOwukvDJ094qFFM/sY5+olclMpPN6AyvfXhfwcdhMLShyQrI9s3QikTv04pFNKEbipZi1al0A9vw2rn8uIG27/eWDpRqLuRR11M+GCY8uqah1ga0a1TmezuGD6vnpe3R37VxCllzMH2pwOJ5RdHdK7pJDbELxh+4a7s5wcync8hR57eHSMaexM/aHUw1Wy9EDpUnyzfuMfKlDJ+Q8CXmGB+yXrnaBYPLTFKhUM29siz9J0hGhv25CGmMKuiPh61RKkRY+K03vF/U6jAYX6RNPEuZwRO0v5k4LGdBZXuENnLCNNpqY55zM8yEOEhA/wLKInoe/2qyNZPZwqhgWnbaq3DACkTq/xe27z5EdzrfuQqawnhIDcthyCibzcgVSiVGmgpnpzgUmMzNS512wH23sjuyHJdbkoYPoMPYPceOvJrKpy0CZ/gfSU2RkPOvgbcdaoU+6iwbFOf5IlxhVKaQBN34eBtxp9bJ7+wJP3UEiVtQO29s1bJtkxyrPtvKT6G+QGu6P+ZPpreNKrKRZzrnRPZwGqKmbhaOVAoo8Y5qzgdFCRiL8qJeREHFR5rkgKReVZOEfVc1prpbJdLYsTLXaOhWBnDvdtgCadrHct+UIxmIPKNDznwxOe+4N0zpR0mPxg9Cqg6W0xeDSY22BDzS+h8koRTiMhO7xuY8Himw+sU6C2B0gQAJlYKCZ6kVgOIg78UszgQZXUOqZdg351iR0LrE4sMsc9yAyAxSogU3wv4Sfs/NCAKPeQR61SM1BlRcp5Ut8tEK/qv7ll+RJLZpLhyCzupWpYxkXWodJelLE0slV
 alYX+VjX
 /Isqb+fpD/ynMmyLOw3WCfphxwcAXoAJddFBQ3DBiXOUpzuNX3ZdS6xUmag3BstWAYAFmK3+kyePuIiAad47o3KFV4A0/nWJtMOj32IrQ30GAxqZsEL+NcKhlemONcJNkz+ozw+kQZZMWa0BdoqBsvd77oEy8TYLVa5XOQ5ek++nmUt5rwaAZ5Vyi5KVaQhjQ1HEym5c0DL8AKdujkhsjHsA/BYsCpwKZ3H8bmwM+kpewa6KQR6Z9Z1I+l3oEUUg5lxX75WmrgaAfIkSAMIkMfknFI0BiaSOr6ltKYXkfDR2oZHIb64CHA0ZcRQobroBanO9q9A43anQ9Hkqlfj6eQj9IPyPPRaFhBJlgnoWmLPbZ71dQlneolF7tAGh7elIH3J1K/sBSjoZGBJbNfxpZfUvuNvFxXH3HXRbv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/10 19:29, David Hildenbrand (Arm) 写道:
> On 7/2/26 13:06, Jinjiang Tu wrote:
>> stable_page_flags() currently accesses folio->flags.f directly. Since
>> commit 476d87d6a061 ("fs: stable_page_flags(): use snapshot_page()"), we
>> can replace these raw flag accesses with the existing folio_test_*()
>> helpers, thereby cleaning up the open‑coded flag handling.
>>
>> For KPF_IDLE, set_ps_flags() already handles both 64‑bit and 32‑bit
>> cases, so the duplicate code in stable_page_flags() that deals with
>> CONFIG_PAGE_IDLE_FLAG for the 64‑bit case is removed.
>>
>> The flag bits that has no folio_test_*() helpers are left unchanged,
>> including PG_owner_priv_1, PG_arch_*.
>>
>> No functional change is intended.
>>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   fs/proc/page.c | 94 ++++++++++++++++++++++++++------------------------
>>   1 file changed, 49 insertions(+), 45 deletions(-)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index 2717dbb0431b..0dbd46fa84ea 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -148,8 +148,6 @@ u64 stable_page_flags(const struct page *page)
>>   	const struct folio *folio;
>>   	struct page_snapshot ps;
>>   	unsigned long k;
>> -	unsigned long mapping;
>> -	bool is_anon;
>>   	u64 u = 0;
>>   
>>   	/*
>> @@ -163,17 +161,14 @@ u64 stable_page_flags(const struct page *page)
>>   	folio = &ps.folio_snapshot;
>>   
>>   	k = folio->flags.f;
>> -	mapping = (unsigned long)folio->mapping;
>> -	is_anon = mapping & FOLIO_MAPPING_ANON;
>> -
>>   	/*
>>   	 * pseudo flags for the well known (anonymous) memory mapped pages
>>   	 */
>>   	if (folio_mapped(folio))
>>   		u |= BIT_ULL(KPF_MMAP);
>> -	if (is_anon) {
>> +	if (folio_test_anon(folio)) {
>>   		u |= BIT_ULL(KPF_ANON);
>> -		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>> +		if (folio_test_ksm(folio))
>>   			u |= BIT_ULL(KPF_KSM);
>>   	}
> These make sense.
>
>>   
>> @@ -181,10 +176,12 @@ u64 stable_page_flags(const struct page *page)
>>   	 * compound pages: export both head/tail info
>>   	 * they together define a compound page's start/end pos and order
>>   	 */
>> -	if (ps.idx == 0)
>> -		u |= kpf_copy_bit(k, KPF_COMPOUND_HEAD, PG_head);
>> -	else
>> +	if (ps.idx == 0) {
>> +		if (folio_test_head(folio))
>> +			u |= BIT_ULL(KPF_COMPOUND_HEAD);
>
> Once we decouple folios from pages, we will have compound pages that are not
> folios. PG_head is not folio specific.
>
> But then, some of the flags below are used in other context outside of folios.
>
> I would focus here only on converting things to use folios that will actually be
> folio-specific: like the folio_test_anon() above.

Understood, thanks.

In addition to anon, ksm check, The swapcache check is also folio-specific.

#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
	if ((k & SWAPCACHE) == SWAPCACHE)
		u |= 1 << KPF_SWAPCACHE;

>
>> +	} else {
>>   		u |= BIT_ULL(KPF_COMPOUND_TAIL);
>> +	}
>>   	if (folio_test_hugetlb(folio))
>>   		u |= BIT_ULL(KPF_HUGE);
>>   	else if (folio_test_large(folio) &&
>> @@ -201,6 +198,9 @@ u64 stable_page_flags(const struct page *page)
>>   	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
>>   		u |= BIT_ULL(KPF_BUDDY);
>>   
>> +	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
>> +		u |= BIT_ULL(KPF_IDLE);
>> +
> That looks like an independent cleanup, right? Should probably go in a separate
> patch then.

Indeed, will send as a separate patch.

>>   	if (folio_test_offline(folio))
>>   		u |= BIT_ULL(KPF_OFFLINE);
>>   	if (folio_test_pgtable(folio))
>> @@ -208,42 +208,46 @@ u64 stable_page_flags(const struct page *page)
>>   	if (folio_test_slab(folio))
>>   		u |= BIT_ULL(KPF_SLAB);
>>   
>> -#if defined(CONFIG_PAGE_IDLE_FLAG) && defined(CONFIG_64BIT)
>> -	u |= kpf_copy_bit(k, KPF_IDLE,          PG_idle);
>> -#else
>> -	if (ps.flags & PAGE_SNAPSHOT_PG_IDLE)
>> -		u |= BIT_ULL(KPF_IDLE);
>> -#endif
>> -
>> -	u |= kpf_copy_bit(k, KPF_LOCKED,	PG_locked);
>> -	u |= kpf_copy_bit(k, KPF_DIRTY,		PG_dirty);
>> -	u |= kpf_copy_bit(k, KPF_UPTODATE,	PG_uptodate);
>> -	u |= kpf_copy_bit(k, KPF_WRITEBACK,	PG_writeback);
>> -
>> -	u |= kpf_copy_bit(k, KPF_LRU,		PG_lru);
>> -	u |= kpf_copy_bit(k, KPF_REFERENCED,	PG_referenced);
>> -	u |= kpf_copy_bit(k, KPF_ACTIVE,	PG_active);
>> -	u |= kpf_copy_bit(k, KPF_RECLAIM,	PG_reclaim);
>> -
>> -#define SWAPCACHE ((1 << PG_swapbacked) | (1 << PG_swapcache))
>> -	if ((k & SWAPCACHE) == SWAPCACHE)
>> -		u |= 1 << KPF_SWAPCACHE;
>> -	u |= kpf_copy_bit(k, KPF_SWAPBACKED,	PG_swapbacked);
>> -
>> -	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
>> -	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
>> -
>> -#ifdef CONFIG_MEMORY_FAILURE
>> -	if (u & (1 << KPF_HUGE))
>> -		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
>> -	else
>> -		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
>> -#endif
>> +	if (folio_test_locked(folio))
>> +		u |= BIT_ULL(KPF_LOCKED);
>> +	if (folio_test_dirty(folio))
>> +		u |= BIT_ULL(KPF_DIRTY);
>> +	if (folio_test_uptodate(folio))
>> +		u |= BIT_ULL(KPF_UPTODATE);
>> +	if (folio_test_writeback(folio))
>> +		u |= BIT_ULL(KPF_WRITEBACK);
>> +
>> +	if (folio_test_lru(folio))
>> +		u |= BIT_ULL(KPF_LRU);
>> +	if (folio_test_referenced(folio))
>> +		u |= BIT_ULL(KPF_REFERENCED);
>> +	if (folio_test_active(folio))
>> +		u |= BIT_ULL(KPF_ACTIVE);
>> +	if (folio_test_reclaim(folio))
>> +		u |= BIT_ULL(KPF_RECLAIM);
>> +
>> +	if (folio_test_swapcache(folio))
>> +		u |= BIT_ULL(KPF_SWAPCACHE);
>> +	if (folio_test_swapbacked(folio))
>> +		u |= BIT_ULL(KPF_SWAPBACKED);
>> +	if (folio_test_unevictable(folio))
>> +		u |= BIT_ULL(KPF_UNEVICTABLE);
>> +	if (folio_test_mlocked(folio))
>> +		u |= BIT_ULL(KPF_MLOCKED);
>> +
>> +	if ((folio_test_hugetlb(folio) && folio_test_hwpoison(folio))
>> +		|| PageHWPoison(&ps.page_snapshot))
>> +		u |= BIT_ULL(KPF_HWPOISON);
>> +
>> +	if (folio_test_reserved(folio))
>> +		u |= BIT_ULL(KPF_RESERVED);
> That is not a pure folio flag.
>
>> +	if (folio_test_owner_2(folio))
>> +		u |= BIT_ULL(KPF_OWNER_2);
>> +	if (folio_test_private(folio))
>> +		u |= BIT_ULL(KPF_PRIVATE);
>> +	if (folio_test_private_2(folio))
>> +		u |= BIT_ULL(KPF_PRIVATE_2);
> These as well.
>
> So I'd probably leave the page bit checking alone for now and focus on the
> mapping only.
>

