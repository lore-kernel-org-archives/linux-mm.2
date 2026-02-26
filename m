Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2D43FD4606
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 02:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9BB16B0088; Wed, 25 Feb 2026 21:01:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73506B0089; Wed, 25 Feb 2026 21:01:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA0D6B008A; Wed, 25 Feb 2026 21:01:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2FB86B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:01:27 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5003D13AD34
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:27 +0000 (UTC)
X-FDA: 84484955814.03.F23B839
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0152920002
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:01:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=akfDwK07;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772071285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8bESDNreYva4GKLrKUGtqNs97ZkQMtHC/4uCqHccoR0=;
	b=FagSKzp4YaZWZxfbQv4qEUVQZ4TC874dBjCpzX+/S65XXxuLNnln+Fl9MEl9cvLDITUCET
	m04QbpNdbrPHSBPtnoXXBcaKaCS7DcB/II8FuRPrMrOf8VSl2qPywA2Y6b68mxW+5Hprz+
	3Z6gZfGfi/VeNjqoFVJdsY/qaMF5kuc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=akfDwK07;
	spf=pass (imf03.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772071285; a=rsa-sha256;
	cv=none;
	b=X5EL1AUv1qU42sX1nZmXznCnwpSHuyLWQ5uD/0uJni9EFR68nAvLXWWrhDeV1tIo3sfsd4
	d3TvG0K8v2CDQZdosNSxhIBFbG49gu2Bb/qlNmJoaiSrbC1eiEX95Y/xqHymOK/Wyk2TxE
	sVX7IIMem5V46K9gl3E+WqZTxJmBJp4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8bESDNreYva4GKLrKUGtqNs97ZkQMtHC/4uCqHccoR0=;
	b=akfDwK07iSf8D8JNSiaGpdICIskvi9uTjD1ZDlrOTI4r8rcOqFEWPIHAg5YFNivA1RJEiS/Ps
	Ki1s47xCAt4B35F5tXCLqLHRTOWemQNBbXDdBa+6/BxWtqJlKwU9vE12EBVzVdXzYLvm13DoAC1
	57qW6qlYAfZNrwxLyXYeBks=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4fLvhH3gXVz1cyxm;
	Thu, 26 Feb 2026 09:56:31 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8228B40563;
	Thu, 26 Feb 2026 10:01:18 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 26 Feb
 2026 10:01:17 +0800
Message-ID: <2a46b99d-7f03-4e47-b0ec-da2475d49af8@huawei.com>
Date: Thu, 26 Feb 2026 10:01:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix folio isn't locked in
 softleaf_to_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>,
	<fengwei.yin@intel.com>, <baohua@kernel.org>, <ryan.roberts@arm.com>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260225081240.253057-1-tujinjiang@huawei.com>
 <db51a324-ee8e-44fe-b7bc-6ca65a3c2a3d@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <db51a324-ee8e-44fe-b7bc-6ca65a3c2a3d@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 0152920002
X-Stat-Signature: k5nddq81jatnzy6n9bf7bjrng8okk6q9
X-HE-Tag: 1772071283-986966
X-HE-Meta: U2FsdGVkX1/IkIiUoUB/o8Or+FTd3G8p1wDsx74j/Uu5SPMHCZkI5LOxrOCGHWC3sIVAeR0eN+iOo2HMfH7s9RG4LytXus+HO9Nrv1gAh7hNfV0YEt8uI50TLCMCGTDF/8Fwr4P3hSiHtXJQteRwMZ2b6mfAE9JDOY1vs9bCZ9AZUGrIwLRrknI5FDTrkA5KUR2+/b/Y42pp86wRaIUPlLEpUUwJYSe3qUttJi2ErL5vn5NZIgode+GUs5Fii71W2wgmmNkWoH0YAAjaGA3epXRxU/ZFpu2xLsZe6k4qnLw1/RoCw8qZemPHqSBKlBWPEy5inf84bAw9BqlD/65OxydxPGgpz8D7oFxrfOl5dFHIfFgUbmnNuZZPHxnVIL3F3xzKL/lpasXiVlLIF3pFCkqszCD52wlLXe3Add57HrlBB9tu6xueKjuZNCRYeScRt4grN5wxTNzCRlYh1N9Vhn/qkR7qxnAGv4uLY+xzplCSEk9JNPGA2V+HjX8Y+TTCRDY+SsPiOJCQ5+djQUrfXdItzotMPbFRC4VX2F5TPaAPdba+gVXNcBoCd9WngpJywijhI3it88sAJk1yfirXtTki9o2MjDsxBGrZj8tHbZV7wICq+gtzfypqV6/NM3JvsiIIeey5F/a4v5+tJhMLx2hwrBqcmqz1dlY4KVpcFM3U/JWVpBIlHhFT6XmKAuPlXmTNtGJKSh+V6M5a7vfYemExXViYzuUKXuBG5eYHRduoYUCr0q+w8A/0ySpi7lR7udcWyNMUf8HA5pOZjNxAKujbVAI5UiIZ5zEbZzmgtKKmeR6iOkyrl1NUNevVwa2RqLOJsY39CXVN2r5/r2f7p6n7MbplxEj4UnrjjzlfxpkLj3aNSafI4esGMdug50MR7Cy3C1RJHnhdu8duIHd53EgoLhhgLCgMi0H5YyXm41JdIyIaKm5E/ac0iMcYXV0KGeIdKap81qihnK/TA34
 C24eEMLu
 DSFcDZmvCUgcFSf6YdUpIjJUTfTsME7nztlOKsZN3PWKswSENXmSYRBSB/xeyUnCqqdvdezyta/4n+/AUrXTae2mvRq+3KeWyg5YDhMHRYBlDNLZcMy6YE9+rNu6LC/jVsW5atWXMN3UD0Xmg7kAk7ozEBzeSaGJx8LKWXEBfNZqFOhLtdN6UAoZDYkRc6uudToMHXD/Y4JbzFLetpySJHdgTjYVWKA8O5ngvyT8jyNew0ovgL+qQKNdnWYnlWpg9eB132PpMWtLt21I+c2DxDV54VEif6BffHLH1H94R8Szl/vgQjSMe1zLF+I8cKQ21i4o8btzQaQxnjikZQyKsOL5fTVUlcynIgImrE9/63LIx7e6zthOi/xOoYciES1CnfAOf0WHtyesgBg8iLfGc8V9kBhHJm4gBIrtL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/2/25 17:15, David Hildenbrand (Arm) 写道:
> On 2/25/26 09:12, Jinjiang Tu wrote:
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
> In general, relying on a "struct page" for a migration entry is shaky,
> because it can change any time from being a large folio to being a small
> folio.
>
> So we generally only check properties that would be true for either the
> old (large) or the new (smaller) folio, like folio_test_ksm() or
> folio_test_anon().
>
> It's important that these properties were written for the new folio
> before a migration entry user might look at the page indeed.
>
> So it's not just about the locked state.
>
>> In __split_folio_to_order(), smp_wmb() guarantees page flags of tail pages
>> are visible before the tail page becomes non-compound. smp_wmb() should
>> be paired with smp_rmb() in softleaf_to_folio(), which is missed. As a
>> result, if zap_nonpresent_ptes() accesses migration entry that stores
>> tail pfn, softleaf_to_folio() may see the updated compound_head of tail
>> page before page->flags.
>>
>> Although the code exists for long time, this issue should only exist after
>> mTHP splitting is supported. For THP splitting, there is only a pmd
>> migration entry
> When splitting, we first install a PTE table, no?
>
> unmap_folio() passes TTU_SPLIT_HUGE_PMD.
>
> and it's impossible to access migration entry that stores

Indeed, I misunderstood the code. So the fix tag is incorrect.

>> tail page pfn.
>>
>> To fix it, add missing smp_rmb() if the softleaf entry is migration entry
>> in softleaf_to_folio() and softleaf_to_page().
>>
>> Fixes: 7dc7c5ef6463 ("mm: allow deferred splitting of arbitrary anon large folios")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   include/linux/leafops.h | 39 ++++++++++++++++++++++++++-------------
>>   1 file changed, 26 insertions(+), 13 deletions(-)
>>
>> diff --git a/include/linux/leafops.h b/include/linux/leafops.h
>> index a9ff94b744f2..f823f390ba6b 100644
>> --- a/include/linux/leafops.h
>> +++ b/include/linux/leafops.h
>> @@ -371,14 +371,21 @@ static inline unsigned long softleaf_to_pfn(softleaf_t entry)
>>    */
>>   static inline struct page *softleaf_to_page(softleaf_t entry)
>>   {
>> -	struct page *page = pfn_to_page(softleaf_to_pfn(entry));
>> +	struct page *page;
>>   
>>   	VM_WARN_ON_ONCE(!softleaf_has_pfn(entry));
>> -	/*
>> -	 * Any use of migration entries may only occur while the
>> -	 * corresponding page is locked
>> -	 */
>> -	VM_WARN_ON_ONCE(softleaf_is_migration(entry) && !PageLocked(page));
>> +
>> +	page = pfn_to_page(softleaf_to_pfn(entry));
>> +	if (softleaf_is_migration(entry)) {
>> +		/* See __split_folio_to_order() comment */
>> +		smp_rmb();
>> +
>> +		/*
>> +		 * Any use of migration entries may only occur while the
>> +		 * corresponding page is locked
>> +		 */
>> +		VM_WARN_ON_ONCE(!PageLocked(page));
>> +	}
> Conceptually, wouldn't the smb_rmb() have to happen *after* the
> page_folio(), like we have in softleaf_to_folio()?

the comments of page_folio() says:
  * Context: No reference, nor lock is required on @page.  If the caller
  * does not hold a reference, this call may race with a folio split, so
  * it should re-check the folio still contains this page after gaining
  * a reference on the folio.
  * Return: The folio which contains this page.

The old large folio is locked and freezed during splitting, page_folio()
couldn't be called with reference held, so the result is unstable, the
caller should recheck after gaining a reference, at that time splitting
finishes, and folio_get() contains memory barrier already, ensuring the
folio flags is seen after compound_head.

>

