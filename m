Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25E19E81BA5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 11:54:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7248C6B0005; Mon,  9 Feb 2026 06:54:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2266B0088; Mon,  9 Feb 2026 06:54:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D4526B0089; Mon,  9 Feb 2026 06:54:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 491EC6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 06:54:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D4C113BA8A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:54:34 +0000 (UTC)
X-FDA: 84424760868.28.1800E99
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6724A40005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 11:54:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PJQejhtF;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770638072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=87jS9hA6CNFtZFnnBnwUEZeCAKiOLm/Lt+umcyTbarg=;
	b=mHNUGLNZGBA+6YkasG/lvQRr+cWi4Mfnk9/lBvQjvrn1nUXgQ/s7rLK14a839jvlVinQSs
	yixIhHhjAb8eD56U9woXC/LMed2EUeWKt4x/glloNzehs1nz8hCwOMXAfn0eBAvik2wGyZ
	dCGmAyHN2nY/lQAe56spzXNzp37wz8Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PJQejhtF;
	spf=pass (imf04.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770638072; a=rsa-sha256;
	cv=none;
	b=BiOKUSwKa1IHVr2TqcmFaJD+gB+CawHUI/0jpdYzcoLikvFGI0v0tLlkVxNxTBHAm0LGe8
	KglBraCfT3uD/ogkqqKVU6a2InvRDLcb25QSkRX8lc6q4ioVifur6mhE7gWGg9QwPqFanM
	gbAt8QeTIbeIJC7hse3nDolDry7iRXU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=87jS9hA6CNFtZFnnBnwUEZeCAKiOLm/Lt+umcyTbarg=;
	b=PJQejhtFjpPok7RdAijwT4qVRey94d/d5Q2JD6Bgs7i9GG9/A9Yn6EDExt4Ws7Xh+HuHdPvrp
	wstjXUuVW2s5YVPxmZhor7wF7Wm2wbIbZvkoU2pl05doyqfkjbd0244GwUnWN/a4vcBPGEto2lU
	A2rxUzdf3cNE+sWShagONgI=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4f8jfl2PRhzcbNJ;
	Mon,  9 Feb 2026 19:49:51 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 2B64C40567;
	Mon,  9 Feb 2026 19:54:23 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Feb 2026 19:54:22 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 9 Feb 2026 19:54:21 +0800
Subject: Re: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <nao.horiguchi@gmail.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <osalvador@suse.de>, <rientjes@google.com>,
	<duenwen@google.com>, <jthoughton@google.com>, <jgg@nvidia.com>,
	<ankita@nvidia.com>, <peterx@redhat.com>, <sidhartha.kumar@oracle.com>,
	<ziy@nvidia.com>, <david@redhat.com>, <dave.hansen@linux.intel.com>,
	<muchun.song@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
	<william.roche@oracle.com>, <harry.yoo@oracle.com>, <jane.chu@oracle.com>
References: <20260203192352.2674184-1-jiaqiyan@google.com>
 <20260203192352.2674184-2-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com>
Date: Mon, 9 Feb 2026 19:54:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260203192352.2674184-2-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6724A40005
X-Stat-Signature: yu5rjwatsoogbhkmwb51h5nuofuc5yyw
X-Rspam-User: 
X-HE-Tag: 1770638070-505239
X-HE-Meta: U2FsdGVkX19GwDNXMon9fim+YqsInCJ5jwsuXBs9bbdxNvFRgUrnwvwIj0am6JXbQMrjdg4NITKv1/kVpG13aBtHV5CLStVtTEcADwwaoyLY0JOBGOWmtYs8um/leNb/r/fvtgQBKE2z3fblp/TxyXW8fx28m7JWpIQW6B3CsjV2/HJji/HWz7eOt4RaAF30NElWq8mMkwMKI2iQvf7Cf6xr65pSXMqnVsNdw1gFktUq+pAg1P34bJWrXU9QG0+kb22ULTijg8tM00o9ZJSdS+Fx5JETnucvkr0KTQEL/NRRbyIkhLwPEhmT2qZf3G1CSR8tsDzTY97AmSAoFeARluFCiHAlnDrbmZhuX3KQq9wqM1F4mP1oEBp9Twv5XzvXwcNmiGLwMpogaSMlGv2LvQKoft+HZWESm9+RORJZA414ioqIrl1Em43yLE3wwMdfK9ePjEAUFTHjJupyLhgvlQKKXS+9qb1YUMicBXYeHNRJG0PBO0gv4rPLE/ecxqQJmuunJWYLm9IpL0kLAsjVs13hCEWR0SOGfXeOVTViaqjKAj/nNuv6+Z3Zk+bXWy5sEDtrnThMjc2LyNkPPXDXGuVkvSe1fr5y2d+1ccuBTEFSWXxh+JK996UUpkBFFwUf7hNK2x2w8sOH4CPzAgeBJJq7+lXlsHgaNGVixSvAYdEMvvhFg+G1mAtV5MDhQjNMGtHSp6lB57qmtJGpX6+Kpywai5kQsSf2R3AzCa49pRKbGt9QmM7yqL79zcKvOus+qu3qKnApFaGD/VaUqxaN3hIVfDj9TAaZvuKJ/gnDO4VH8+FMtyoYsPSZ17SLgbRsPpSL1o4hPcU92LEk9g0HImQsCOXiMrlDupHqz2raXXVbEhOa3h/qDzZNIIhhqAp9qdnFjWNNHrzW6Duy7ORAYP0B/Koq7EKtRlmbN9hhggusBcWS60SgmCrOgGwdL4IBtUXxD34zrsXrdZl4rsL
 OR3P5uBM
 IpvPw9GdDm9H1u7SKwyl4VYNfq4j5olyI9hgxPIQbTSTCB4Olzsb3J5GXasRs8k9wt2uRUaT9TmfcGAJ78QqqsuHSuPerMzlZHTzSQGuFvhO/ZO1WecPducmU3fONWbIqnBRt5J7J0Pe7CHy4N9T6UeBYJijC+vFJ76PtHb5zg3mtyucCmW4C2ZfPvm86UlXKEvGpDy+QX/gd86utYot7neVkR6lfZRbfRt6auU3dHQ1oIurfyFyym5kIoDJBdtB6g4QHGggqwCMGCdNE6c4sGgQtVhvsv2CcIafPnEDE5flOZ978SjVEjP+lk1bxsZS8mC1YPVxGWe7CiYOJ8YUZTDIMp8MWVP4HQqno
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/2/4 3:23, Jiaqi Yan wrote:
> Sometimes immediately hard offlining a large chunk of contigous memory
> having uncorrected memory errors (UE) may not be the best option.
> Cloud providers usually serve capacity- and performance-critical guest
> memory with 1G HugeTLB hugepages, as this significantly reduces the
> overhead associated with managing page tables and TLB misses. However,
> for today's HugeTLB system, once a byte of memory in a hugepage is
> hardware corrupted, the kernel discards the whole hugepage, including
> the healthy portion. Customer workload running in the VM can hardly
> recover from such a great loss of memory.

Thanks for your patch. Some questions below.

> 
> Therefore keeping or discarding a large chunk of contiguous memory
> owned by userspace (particularly to serve guest memory) due to
> recoverable UE may better be controlled by userspace process
> that owns the memory, e.g. VMM in the Cloud environment.
> 
> Introduce a memfd-based userspace memory failure (MFR) policy,
> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
> but the current implementation only covers HugeTLB.
> 
> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
> whenever it runs into a new UE,
> 
> * MFR defers hard offline operations, i.e., unmapping and

So the folio can't be unpoisoned until hugetlb folio becomes free?

>   dissolving. MFR still sets HWPoison flag, holds a refcount
>   for every raw HWPoison page, record them in a list, sends SIGBUS
>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
>   If userspace is able to handle the SIGBUS, the HWPoison hugepage
>   remains accessible via the mapping created with that memfd.
> 
> * If the memory was not faulted in yet, the fault handler also
>   allows fault in the HWPoison folio.
> 
> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
> when userspace process truncates its hugepages:
> 
> * When the HugeTLB in-memory file system removes the filemap's
>   folios one by one, it asks MFR to deal with HWPoison folios
>   on the fly, implemented by filemap_offline_hwpoison_folio().
> 
> * MFR drops the refcounts being held for the raw HWPoison
>   pages within the folio. Now that the HWPoison folio becomes
>   free, MFR dissolves it into a set of raw pages. The healthy pages
>   are recycled into buddy allocator, while the HWPoison ones are
>   prevented from re-allocation.
> 
...

>  
> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *folio)
> +{
> +	int ret;
> +	struct llist_node *head;
> +	struct raw_hwp_page *curr, *next;
> +
> +	/*
> +	 * Since folio is still in the folio_batch, drop the refcount
> +	 * elevated by filemap_get_folios.
> +	 */
> +	folio_put_refs(folio, 1);
> +	head = llist_del_all(raw_hwp_list_head(folio));

We might race with get_huge_page_for_hwpoison()? llist_add() might be called
by folio_set_hugetlb_hwpoison() just after llist_del_all()?

> +
> +	/*
> +	 * Release refcounts held by try_memory_failure_hugetlb, one per
> +	 * HWPoison-ed page in the raw hwp list.
> +	 *
> +	 * Set HWPoison flag on each page so that free_has_hwpoisoned()
> +	 * can exclude them during dissolve_free_hugetlb_folio().
> +	 */
> +	llist_for_each_entry_safe(curr, next, head, node) {
> +		folio_put(folio);

The hugetlb folio refcnt will only be increased once even if it contains multiple UE sub-pages.
See __get_huge_page_for_hwpoison() for details. So folio_put() might be called more times than
folio_try_get() in __get_huge_page_for_hwpoison().

> +		SetPageHWPoison(curr->page);

If hugetlb folio vmemmap is optimized, I think SetPageHWPoison might trigger BUG.

> +		kfree(curr);
> +	}

Above logic is almost same as folio_clear_hugetlb_hwpoison. Maybe we can reuse that?

> +
> +	/* Refcount now should be zero and ready to dissolve folio. */
> +	ret = dissolve_free_hugetlb_folio(folio);
> +	if (ret)
> +		pr_err("failed to dissolve hugetlb folio: %d\n", ret);
> +}
> +

Thanks.
.


