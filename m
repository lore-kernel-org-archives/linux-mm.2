Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 055A1606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 06:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=typf2NDB
Received: by kanga.kvack.org (Postfix)
	id 1B3086B00EF; Thu, 19 Nov 2026 01:39:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B826B05B0; Thu, 19 Nov 2026 01:39:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002CB6B05B1; Thu, 19 Nov 2026 01:39:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CE22A6B00EF
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 01:39:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C0ACA8741
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:39:44 +0000 (UTC)
X-FDA: 85450917888.30.27FB37A
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf06.hostedemail.com (Postfix) with ESMTP id 391D2180002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:39:40 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=typf2NDB;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795070381;
	b=jDkiFLghmTkp1+kBRxpid/8K8tcDuMs84yLEt0WAJCGEH6V6S2m+osYgvvqqePc2hQj2gi
	BIIqAtQ+qmm7lFdRJAJZX8KfogyA0fkF+W/wlJ82jJLTVwwfGfLW/zTxhtIDxny6c5Vk/K
	d61kvIuxhuLMF7G55GV6luWWh7WRqj4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=typf2NDB;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795070381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q7gZgAjC3J0Vq/5Bve85q8SO+8zS+ANsoLKzL7Nl/Ho=;
	b=6r/C/y1tYVw0AryvF5RwD/vovkAOJY/QWXCYBdRNgie0SAyOY4673QVWysb8cviRmc0bKY
	tDp6yd83Zfxo+2p0vf9Cc70u7Rpl7Mz3J0f0EAd1aptTWUfFVpKLUy1Wgu2aPbY85Jbhcp
	e+nIXg9iHPupnJVnQMHDRcoxQzzvsSE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=q7gZgAjC3J0Vq/5Bve85q8SO+8zS+ANsoLKzL7Nl/Ho=;
	b=typf2NDBaqz7szJt4untS8E56QxUTy6k4l5lbmw8xo2YzKELIdr6PDQlDtxJ9a01RJS+zlzIR
	iqkDLpxZpgfaJf6FtI9ORmHgxxkqsL5AIwdqZnliy6tyexxrXVHHXZDAnygzRUzYk5Q/kcexB9j
	rmoR2w2Lr4aQ78gCUlt39Q0=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4jVTMB4J6Xz1T4Fp;
	Thu, 19 Nov 2026 14:38:46 +0800 (CST)
Received: from whupemk100004.china.huawei.com (unknown [7.152.185.74])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C57B4057D;
	Thu, 19 Nov 2026 14:39:27 +0800 (CST)
Received: from [10.173.125.21] (10.173.125.21) by
 whupemk100004.china.huawei.com (7.152.185.74) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 19 Nov 2026 14:39:25 +0800
Subject: Re: [PATCH v2 1/2] mm/memory-failure: don't unpoison a leaked
 raw_hwp_unreliable folio
To: <mt4022@columbia.edu>
CC: Naoya Horiguchi <nao.horiguchi@gmail.com>, Matthew Wilcox
	<willy@infradead.org>, Jane Chu <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Kaitao Cheng <kaitao.cheng@linux.dev>, Mike Rapoport
	<rppt@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Yu Zhao
	<yuzhao@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tz2294@columbia.edu>, <stable@vger.kernel.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <20261103-hugetlb-hwpoison-leak-v2-0-98085750c145@columbia.edu>
 <20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <11f434ce-58c4-ff16-9c93-946a1e83eb10@huawei.com>
Date: Thu, 19 Nov 2026 14:39:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261103-hugetlb-hwpoison-leak-v2-1-98085750c145@columbia.edu>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemk100004.china.huawei.com (7.152.185.74)
X-Rspam-User: 
X-Rspamd-Queue-Id: 391D2180002
X-Stat-Signature: kg1wt9abf8h6ozsado6f965xrdis5edd
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-19.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795070380-804742
X-HE-Meta: U2FsdGVkX1/Yla+HxJ8+I8DqDrjqnS0/qHHNnrqXpY9Uymh1zJwznIHuPt32NQYtC58GmgEMUOxU2pPLamb1RVfwKakC3BXSbQzYOVoZ7CC0abw2hx5OMkkLQiwe0+xxulsc5XbqaPErWgUrfIucJmFWllOnYwUa26K/qJAUMf6FDjsKCS/o/zmQOgeQO+ymLdPKDRdMbnE/AxWjc1iWUOfnA/5w8odSOUENSuJ+/cDQXgInkCS3csGTCaD7KIdr+1StkBJwzJkjxPMHP/vvTeICOtrhXRc+vofeqMO2QjYu6VbmPFRcniyXuLFXu1fzFgO/XFLUqQB+b/MKrDa6EpS2p/I6N88hoipTcRw3pfQP026pI1Jigq3YaXUwYRb6TbrYySzRVKEkH9C/qxlJh1EEu0KlfFrPSNZKKzhyNKhjcqLx2VMw/t0StAc16QcvHHaDdj/YBaOYw/qQwFhKO47/hVeOKmC3xGNm5zT2QkzIyyXmueFWJS5d0S5+Wfzi6NstdtWHridTdOiBYDrikTOvlky47IanrHKV1YAP7iiYcS56dXBfj3bguBim1jHOtWhG4IGPozRC/YA9zLt80FfpaIftlYOaJOgoAKB6ITyUoY8g41qgfGBLKBKpJVWanrbR1xZiJeF2hx9d+kuyKB36WHLoZPeo8E2ZqyM1ZfluASH+9D3WIYbros4uc/2oEf8jNAQtK63MS+B4b0cuBBPD7Ul0VXXtZP87wRab6NtZjk+IWVup8qorr/3nfwBR2+cMVmHyWhFpO+VlDZYFFIJlIhrvDFfpchvjSy3BXL8WmDc2fl6rZ+1lmEQU7n2LeldtHS4H0GxlBTwbJqDq/fae7yjuPPb6WlFKHQI5Jusw8OB5vsl7p1saR6utrJESO4WO/2pG5z73IvmLu4YwaFxCi8VIflHgJfe5PN6AJlZzxbvcftnYvUIlLJf+Cub+Q+s0u8IMmlfywQo/UA2
 MQzKI1Da
 U11wjOiCT3c5lIiPojnY+wmgAOxVrzmcEBKPYdQQkzA3Olc9L1KbxioP+2IvFEKjGMeiriPJCrphY4SVgnvWoyPrLxUhnaMqx18j9+YA/gAAtOsfGVqYX97mrhXFTf5Li/JDkj5EUw/92yHmeBgOINfmRjci9YrfH+LIoWIO3iDVOk5D3jiZNyWrbIFqLjvy86FEd1l3h5arI/VHw9skcZmaG1wEXB4J+tsg6Dz0pdEG+n/U+aTl0eomRf6q0ljvBrNfuguQEIdux99SQn77MqQLeQdv3iDT4eNtdNKTVcbOanB2/Xl3AsigKfZhvDq9Gnm6Aa8uKHjE4TpdtBwQCF96ej6xUUfnMmT0kmvXzVbgtoAtMUxv87jpH2InFf7PALoX5SzFdo4S9P3CV9rv9QKCj7ZNljwFi1rLFY8BddEds2bn3baXDR+mvB9vGX8UcQuQb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/11/4 5:00, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> If memory_failure() can't save the raw error page of a hugetlb folio,
> it marks the folio raw_hwp_unreliable and unpoison_memory() refuses to
> unpoison it, since we don't know which subpages are poisoned.  Once the
> folio is freed, __update_and_free_hugetlb_folio() leaks it on purpose.
> If its hugetlb flag is cleared by then, e.g., without vmemmap
> optimization, unpoison_memory() doesn't see a hugetlb folio anymore.
> It treats the leaked folio as a normal page and clears PG_hwpoison on
> its head, while the poisoned subpages are still unknown.
> 
> The leaked folio is still a large folio and raw_hwp_unreliable stays set
> in folio->private.  We now check it on any large folio before taking the
> page, so unpoison_memory() refuses the folio whether it's still hugetlb
> or not.  With the fix, it returns -EBUSY for the leaked folio as it did
> before the folio was freed.
> 
> Fixes: ac5fcde0a96a ("mm, hwpoison: make unpoison aware of raw error info in hwpoisoned hugepage")
> Reported-by: Miaohe Lin <linmiaohe@huawei.com>
> Closes: https://lore.kernel.org/all/ae6058ae-3703-a1d5-d82f-4102b46f227b@huawei.com/
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
>  mm/memory-failure.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index b215312f261b..496eacbefdf2 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -2809,6 +2809,15 @@ int unpoison_memory(unsigned long pfn)
>  		goto unlock_mutex;
>  	}
>  
> +	/*
> +	 * A hugetlb folio without reliable raw error info is leaked once it
> +	 * is freed, and its hugetlb flag may be cleared by then.  Check the
> +	 * flag in folio->private, which stays set on the leaked folio.
> +	 */
> +	if (folio_test_large(folio) &&
> +	    folio_test_hugetlb_raw_hwp_unreliable(folio))

It might be better to add a unpoison_pr_info here?

> +		goto unlock_mutex;

Anyway, this patch LGTM:

Acked-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

