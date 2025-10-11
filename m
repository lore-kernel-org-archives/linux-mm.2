Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B55FCCD183
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 04:12:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7DA18E0018; Sat, 11 Oct 2025 00:12:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EAE8E000E; Sat, 11 Oct 2025 00:12:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964A88E0018; Sat, 11 Oct 2025 00:12:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 817E98E000E
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 00:12:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE39E593AB
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 04:12:26 +0000 (UTC)
X-FDA: 83984511492.03.605D823
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf29.hostedemail.com (Postfix) with ESMTP id 13C05120002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 04:12:22 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KW5EKoBu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760155944; a=rsa-sha256;
	cv=none;
	b=li8EjsQW1+tYyFSx8VwHjq5+Z+l1x1uvgVWfU4Z6V1bN7iAy35lDfzmld4nOo6GtH1Ioth
	lY2Mhagd/MLZ3ZhmKnZ5O46tnnc8vYQ0N6eV3KAlPt1JGM/LjcUEe2xMKTL52wXMZbgnwV
	MXC1BTa5xirilCHue5E0w5eqq6uPQ50=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=KW5EKoBu;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760155944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygFS1bldtMkr5dFGTAJA64zNslwuK13Ve5ak8PbmFps=;
	b=dJgWkNiHakUznWSNqTKed77aBUr07GAsC4Gsxey0KnGI2DIW22/2Wv+9uctPRsvRTeNzDN
	WjkLhzE7fqGcxToloELWSxWQHR6s7nReEco8DvBUgeBGgtCcUhccmxmWEmaYvqNEbN5uSW
	r9oJevF3vc9+FRdMmacxs0/Y2bk1PEs=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=ygFS1bldtMkr5dFGTAJA64zNslwuK13Ve5ak8PbmFps=;
	b=KW5EKoBu0ELPnLe7ewEVMD/Rw+7ZwHyBBfHXllC7O9UycE3vBbIFbbHCOSHRKJMKoYpk2vnAw
	9owfJMl95t95dJi44FzsWsNTrTwPS7dhFFXUYYhW/npBheqwJmbFqhINODkboOWabiuK+7oWuLv
	v8V7af/tBTSbFiTlSppR7CE=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4ck9Cf4d1gz12LDR;
	Sat, 11 Oct 2025 12:11:26 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 26A4A1402CA;
	Sat, 11 Oct 2025 12:12:14 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 12:12:13 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 11 Oct 2025 12:12:12 +0800
Subject: Re: [PATCH 2/2] mm/memory-failure: improve large block size folio
 handling.
To: Zi Yan <ziy@nvidia.com>
CC: <akpm@linux-foundation.org>, <mcgrof@kernel.org>,
	<nao.horiguchi@gmail.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
	<Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
	<ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, "Matthew Wilcox
 (Oracle)" <willy@infradead.org>, <linux-fsdevel@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <david@redhat.com>,
	<jane.chu@oracle.com>, <kernel@pankajraghav.com>,
	<syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com>,
	<syzkaller-bugs@googlegroups.com>
References: <20251010173906.3128789-1-ziy@nvidia.com>
 <20251010173906.3128789-3-ziy@nvidia.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <934db898-5244-50b9-7ef7-b42f1e40ddca@huawei.com>
Date: Sat, 11 Oct 2025 12:12:12 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20251010173906.3128789-3-ziy@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 13C05120002
X-Stat-Signature: igw6qganjcazbbzajubn1oh5oi6g6e6j
X-HE-Tag: 1760155942-132805
X-HE-Meta: U2FsdGVkX1+DsVlxGcWeVOVisAzDRxpkotoDV6848CqeiJyXBHmZAEZwv5VKmxDlROqyeWEKiQNU4OjiEzXJSj7GSOeqnwiXC7JAHJ7nZtJHrTs7GxT1pksAHr2Ac0KxuDIWYpsCnUYQ2U2prWHPTdyXXubTY0cVibBHyQ9z02O8CknNI0PSt6dSSdIyqo3xcCVGYcQ/+G04c5g69kmfMhsd9tWVUR9694U8oc2fUUtOMOPJHXKMwnIvIix4kZOgLeX9j2eMsHDSyD2NvPiHkO8v4tctu4Jz6GeLDkL8zP2Xg6XFbADqGT2CBaVqXfQDvqnNFzwz56DiAhNcy29ScuM3B6cU629La7fEeY5/YTRhkcwrkWWFP4Gu4m6pT/7f00FKunZKuM3ofzItS3ahu7wDerGKx839Q4pUPJbv703bLYV/UlSZlabB4diOMQYFCQEob1nRR5HgysDLpaSbctwAKKkssrk3bp30IK11ku504wY0Z71Ier4MkYFeL+aKWeUly3T8iuoauivp3EEwXdQ3Cchujnxlvk18Ewy8anTlufbcFLHfQbwTLl6YOf4CoYbU+4msjQ0dKaNDh8YzfZfOaXHK0NzF+tLI3XrX8DuGGub3AsiB6xpSV7K4yLuaaPD5Rkn1rksFjzvHdSbb8Cm0pGls3gQn6nYRiuvGKBbxhF1AiiwEeHiP6REE0EnO1ISaLy9yqRmzzPZBBbRDO3g8JCArnb460Jr9ydOdHcsdQGaV77FI+vDltjnwvNSGONg3Insxc4vIoG+nZlJczYCzr3PRwBK/Ac85qBze30+4CLtyNREJFt6slkFAkuIotk2X9xQ5C88aWmqube0XP+IYmIvmAk78xrA5HMRr7KgPNdzF/4OMkUfqe4uTq+uiIVvtIuH2xn7rfDDCFIo6JXrkKGRvsbjwDRM+6zE41iaEGiHOmKFknjxD5hwsswzTwhw/qLvHb53SCe/JHg2
 b4+Tf31i
 SlFgUgKqKRXQovXgPVHhvksrLGRLoMpymyBK9pap+D0gpcCJBEjBNuzdMh1fZz706rcgxTtNTZA08FVep+Z3ssaG2YQlJ7xYi9YThwO+AIL2RUx0MA1eue6GcBaSUuzQEjGb2nKWjL8nsKt6nntaAiXpeH8fOnH5qFHDLs6ogul1J82CqBx4NeJPgfRMBWoyhvplmb2oBBfACO+kHt/BPS3L3gf7cMpVV/DTgNLpZdD7MbOjfr5KnvgL2qeRGghZQ5drtidswzW3Qz+CXsIDor0OpuyOGYl4Yxmjl9K6GPObCdjGlfxah6xYhDVR4Ybu1d1QnMF+cWEj5Cny8U1YakLK3dBR7nsBTWFKutOgCHGIATL+r5MVq5eXOTvOvFvBSRXvgZWJ1RibnnmpExDK2OePcLK+f8tL6leJQbLW79w4RGhMZTlLBWLF9WW0XdwVvI3FrkqSwmscU05+/4OD/shicAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/11 1:39, Zi Yan wrote:
> Large block size (LBS) folios cannot be split to order-0 folios but
> min_order_for_folio(). Current split fails directly, but that is not
> optimal. Split the folio to min_order_for_folio(), so that, after split,
> only the folio containing the poisoned page becomes unusable instead.
> 
> For soft offline, do not split the large folio if it cannot be split to
> order-0. Since the folio is still accessible from userspace and premature
> split might lead to potential performance loss.

Thanks for your patch.

> 
> Suggested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  mm/memory-failure.c | 25 +++++++++++++++++++++----
>  1 file changed, 21 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index f698df156bf8..443df9581c24 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>   * there is still more to do, hence the page refcount we took earlier
>   * is still needed.
>   */
> -static int try_to_split_thp_page(struct page *page, bool release)
> +static int try_to_split_thp_page(struct page *page, unsigned int new_order,
> +		bool release)
>  {
>  	int ret;
>  
>  	lock_page(page);
> -	ret = split_huge_page(page);
> +	ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>  	unlock_page(page);
>  
>  	if (ret && release)
> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
>  	folio_unlock(folio);
>  
>  	if (folio_test_large(folio)) {
> +		int new_order = min_order_for_split(folio);
>  		/*
>  		 * The flag must be set after the refcount is bumped
>  		 * otherwise it may race with THP split.
> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags)
>  		 * page is a valid handlable page.
>  		 */
>  		folio_set_has_hwpoisoned(folio);
> -		if (try_to_split_thp_page(p, false) < 0) {
> +		/*
> +		 * If the folio cannot be split to order-0, kill the process,
> +		 * but split the folio anyway to minimize the amount of unusable
> +		 * pages.
> +		 */
> +		if (try_to_split_thp_page(p, new_order, false) || new_order) {
> +			/* get folio again in case the original one is split */
> +			folio = page_folio(p);

If original folio A is split and the after-split new folio is B (A != B), will the
refcnt of folio A held above be missing? I.e. get_hwpoison_page() held the extra refcnt
of folio A, but we put the refcnt of folio B below. Is this a problem or am I miss
something?

Thanks.
.


