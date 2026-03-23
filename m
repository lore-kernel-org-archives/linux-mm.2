Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F92DD58CBE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 02:07:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4EB6B0005; Sun, 22 Mar 2026 22:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C526B0088; Sun, 22 Mar 2026 22:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B8F96B0089; Sun, 22 Mar 2026 22:07:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F2A66B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:07:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E0D2C1A0999
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:06:59 +0000 (UTC)
X-FDA: 84575689758.19.A5360C2
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf30.hostedemail.com (Postfix) with ESMTP id 608E580004
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 02:06:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=APFX8z0y;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774231618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNiA7OVXpLLl4t81t0ptBo8UsknaoPeMCCc80Vt33to=;
	b=T9+6vBxAuZ7nXrmMs84uvTQQ55kibxhgC7GLRjeJtF+AGDHDhFaa6NDXkT3Njk2KCyaTb1
	3Xt6Pjm3XoAhqCBOn8shDt6rskBrOF3w4KKO1j0pwypVyGmh9JmfbsqNhZe0KFuAQHLqhm
	vkg2ge8byjblGaH4nvfCH1EKINaMJRg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774231618; a=rsa-sha256;
	cv=none;
	b=m7/By2siO3Dfigrmvwprg1FBdL+DEbSVHy+FiyGalBkAGZApWP3wyJZaaYvKcuxrg41wOv
	Ngh9s2IoM2293tcAqcxCEAOxuDOiwu6M3dPAn+ZZ8R+nefnfVpQ+FIh7P1J8R2GQTOwT6I
	ffICqNBCaWN+Y9s0j8U5qYkrDa+XuQc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=APFX8z0y;
	spf=pass (imf30.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=kNiA7OVXpLLl4t81t0ptBo8UsknaoPeMCCc80Vt33to=;
	b=APFX8z0ytDJNBAQAsmSr7COgmPJoWZMoJ4Fy99jQIqYC3doKO3fo/FeIfX15qIbP+5upaEUoK
	VCRrCT+rYEwcZC1shsiidqsuX3mUCZMSGyI6fCwahdhuc5DeFg9KEQgiNlTMC8M0beYWjg25j9U
	cJLuoQRdsubJ7SUYoDepBos=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ffGbf4C3FzKm4Q;
	Mon, 23 Mar 2026 10:00:46 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 908C240562;
	Mon, 23 Mar 2026 10:06:52 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 23 Mar
 2026 10:06:51 +0800
Message-ID: <92337d7e-90e7-4dc7-a3a8-2a9df2a3fe5b@huawei.com>
Date: Mon, 23 Mar 2026 10:06:28 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: Andrew Morton <akpm@linux-foundation.org>
CC: <david@kernel.org>, <lorenzo.stoakes@oracle.com>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <baohua@kernel.org>,
	<ryan.roberts@arm.com>, <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>
References: <20260321075214.3305564-1-tujinjiang@huawei.com>
 <20260321110704.82472cb5b8238ce8a5f40bbd@linux-foundation.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260321110704.82472cb5b8238ce8a5f40bbd@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 608E580004
X-Stat-Signature: fgc7qxim3tyq9brx35wse1kobqqwsq5w
X-Rspam-User: 
X-HE-Tag: 1774231616-332135
X-HE-Meta: U2FsdGVkX18MkyEZ/ro5ghyMNs1B255SkPZ0j8eHrn2tw1Jvs4kn2WKxr2PdgIKAXulHl4NDK2Gum/4QmgBk/FijnIPkJ+8rZXl3GWnCcQwNjrCIt2RgmsJfA+oUueeKM8PToLBnKmgr/UwFaPLPw3jf+YA+YLRxdQ1587laO5dX1fNKinyxz1rEkootGGYY3REmgNWKjsNaKjtVS2a6Fq+zq91TyJLQWhdV2sn5mLMUOL4E6FQBT4jOeRU6BwCRAsukTEW8E6WyV8YqlM+qxAzFIm8RXgZrFlCPsSYN3f+zPiw5cpMDExMuuWQ65NTlcHKaa4/RDxo5STZeMI1/ssMsNjdPLdVxXseXH4Pfgn19yt9bJ2sDIRW9Bp9J7Sj5CRellbHJ+c/NWqZAdLP5hJMwPaVoR3cD0y92+58V3MZP6wDt95tk7j+slgvrDtUR9L/Yr03RkaZdpvFGxr5Ne2bxMvJAmrfY0RLVTGpuDFEOd/MGdI7TfGRl/cbpj5feI0pwn4JnnQgQVhMB3CtUD0uaxgyJ5HgSXhh8WB6tZT3/1AV2iPaV3GZaiUBbNExjDWHqMdSctqmX2LUFaURDIKSMyGxFcSR+kJZgRRYMJJdHyMJnH7PdFWn91OzcL5GIqFzDpbr5nmH6vkQl4vXFViX9sdR599NcSzV0YRvEHI1tvLfKg2lvAnbk+EsGibQ2legLteaqt7+mQKY3ABnMqGET8EMmYUNV+j3UYP13SOq5WfjUpjrzcx/3GIlrdU9BBdHDQiIB77X3VNm5XsD4ElRNnwgLwdWYiyc2EeB7lgq4gUx/SPpMoEPgSw/BBqv8YT5+RiVtReed2/my0ZNqdRVe5LSBhy+sMJyq0COBzD7fcxYOI08q0x8DdpeWEu8c/B33IbNmAgc6pmSY4WTVAlcRcfM5hJ/dfVqV83qmeIyGXtMOxhk7OnaGFv1sbC51Kr3xJeZ9KsfJQmJRQ21
 VAjd2jdb
 DGMRbkV3BMG6QIXFbh7OXZG4S57LaVz4cCcB5E1sboxqRZhT8hlgP2glj3ltZCQkXoTEGK3Q93GjuoMHTLiIb0Q2SayMhk7mdqIzWkNR3o/4MEN0PANiQs1FZbsV9Q/Sx0Hb1wS1faDV71VKZcFcu2J1MsNxW8rC2kbd4bvjaDGNIybNdQmmHCVkBREwN+a9YBM9A02k5uuLQi/AiD6bzJ8f8LrPmBQ5BYzSDD06LpYtILUhZ3ub7slVbOkUM+HoWGRL3B+TRimXmZn07D4T7uO8XTcqrS2EsPuqgyeDADsO3YCsdL1bOwgtpoLAJ//3iAI88e8wPf/Zzki7wWXhAzzs7r28BpeGwQBb8IHUZRSVOWfFvsBk+o9+lceGL0l7lwdJaa0v+UiPiGfSlh/TjQIIxMEJcwvA+AL7JUkqmjsf9NAqbS9cjppeyqMTEcugrEUCtgddfvPjzYqCDr8duLjRu+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/22 2:07, Andrew Morton 写道:
> On Sat, 21 Mar 2026 15:52:14 +0800 Jinjiang Tu <tujinjiang@huawei.com> wrote:
>
>> On arm64 server, we found folio that get from migration entry isn't locked
>> in softleaf_to_folio(). This issue triggers when mTHP splitting and
>> zap_nonpresent_ptes() races, and the root cause is lack of memory barrier
>> in softleaf_to_folio(). The race is as follows:
>>
>> 	CPU0                                             CPU1
>>
>> deferred_split_scan()                              zap_nonpresent_ptes()
>>    lock folio
>>    split_folio()
>>      unmap_folio()
>>        change ptes to migration entries
>>      __split_folio_to_order()                         softleaf_to_folio()
>>        set flags(including PG_locked) for tail pages    folio = pfn_folio(softleaf_to_pfn(entry))
>>        smp_wmb()                                        VM_WARN_ON_ONCE(!folio_test_locked(folio))
>>        prep_compound_page() for tail pages
>>
>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
>> are visible before the tail page becomes non-compound. smp_wmb() should
>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>> page before page->flags.
>>
>> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
>> in softleaf_to_folio() and softleaf_to_page().
> AI review isn't entirely happy:
> 	https://sashiko.dev/#/patchset/20260321075214.3305564-1-tujinjiang@huawei.com

commit 54150f26b76fbe8cbf90c19d0052add5199851f0
Author: Jinjiang Tu <tujinjiang@huawei.com>
mm/huge_memory: fix folio isn't locked in softleaf_to_folio()
This commit adds a memory barrier to softleaf_to_folio() and
softleaf_to_page() to prevent a race condition during mTHP splitting
where the updated compound_head of a tail page might be observed before
its page flags.
> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
> --- a/include/linux/leafops.h
> +++ b/include/linux/leafops.h
> @@ -363,6 +363,23 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>      return swp_offset(entry) & SWP_PFN_MASK;
>  }
>  
> +static inline void softleaf_migration_sync(softleaf_t entry,
> +        struct folio *folio)
"This isn't a bug, but is the entry parameter needed here? It doesn't appear
to be used in the function body."

Indeed, the previous version move softleaf_is_migration() check out of
softleaf_migration_sync(), the parameter could be removed.

> +{
> +    /*
> +     * Ensure we do not race with split, which might alter tail pages into new
> +     * folios and thus result in observing an unlocked folio.
> +     * This matches the write barrier in __split_folio_to_order().
> +     */
> +    smp_rmb();
> +
> +    /*
> +     * Any use of migration entries may only occur while the
> +     * corresponding page is locked
> +     */
> +    VM_WARN_ON_ONCE(!folio_test_locked(folio));
> +}
> +
>  /**
>   * softleaf_to_page() - Obtains struct page for PFN encoded within leaf entry.
>   * @entry: Leaf entry, softleaf_has_pfn(@entry) must return true.
> @@ -374,11 +391,8 @@ static inline struct page *softleaf_to_page(softleaf_t entry)
>      struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>  
>      VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
> -    /*
> -     * Any use of migration entries may only occur while the
> -     * corresponding page is locked
> -     */
> -    VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
> +    if (softleaf_is_migration(entry))
> +        softleaf_migration_sync(entry, page_folio(page));
>  
>      return page;
>  }
"Can this still race if callers use softleaf_to_page() followed by
page_folio()?
If a caller does something similar to:
page = softleaf_to_page(entry);
folio = page_folio(page);
if (folio_test_locked(folio)) { ... }
The call to page_folio() performs a new read of compound_head. Because
this new read and the subsequent reads of folio->flags both execute after
the smp_rmb() inside softleaf_to_page(), there is no memory barrier
between them.
If a weakly-ordered CPU speculatively reads folio->flags before the new
read of compound_head evaluates as order-0, could the caller still see
stale flags and reproduce the crash this patch intends to fix?
Would it be safer to require vulnerable callers to use softleaf_to_folio()
directly?
[ ... ]
"

This issue only exist when the softleaf_entry is migration entry and is
pte-level. Check all callsites of softleaf_to_page(), the softleaf entries
are almost SOFTLEAF_DEVICE_* or pmd-level. The exceptions are smaps_pte_entry()
and pte_to_pagemap_entry(), they only collect information for userspace, and
I think such race doesn't matter. So, I think this AI review comment is false positive.

Thanks.


