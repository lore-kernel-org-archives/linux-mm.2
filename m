Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 934A11093163
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 02:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F35A66B041D; Thu, 19 Mar 2026 22:35:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CE06B0421; Thu, 19 Mar 2026 22:35:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22EE6B0422; Thu, 19 Mar 2026 22:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE67D6B041D
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 22:35:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 70622C271D
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:35:04 +0000 (UTC)
X-FDA: 84564874128.27.16C5E14
Received: from canpmsgout06.his.huawei.com (canpmsgout06.his.huawei.com [113.46.200.221])
	by imf03.hostedemail.com (Postfix) with ESMTP id E72B62000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 02:35:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="W37/tQve";
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773974102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q6qbOMaGXyAMKNATL9zvSjMQbIEHr83FuGmXDCPxJgY=;
	b=AtdT9hWYfNRiLgd95bwzKDJR96FxeJWl1OMFKLiyN+f4Shdp2mpryWNowktebBiV9h/de0
	PhH9wvgYv60xd055vc23KEC9SEYKVBzoKBGwV+FpmNpqeQzdKcm3PEW1ulV8BgoSWdk2AI
	EHMaSj1kvNhvOVTcY7D58czg2uYInMA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773974102; a=rsa-sha256;
	cv=none;
	b=cJyVPwHs86BDn0PJhvyv+82ehPNmj26aRSY4ezUweS4/+++vCO57WUBVKET9jrgyq9zAi7
	80eF9VnTqIO6CDwwYBxzZVhv73nW3TRqT6ySrJUUCud6JAmg268g2sl2VAjbPMvbSXGPy9
	v7Jy7+ZiZ6l6xMxEWmdceRjTXy7Qnlw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="W37/tQve";
	spf=pass (imf03.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.221 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=q6qbOMaGXyAMKNATL9zvSjMQbIEHr83FuGmXDCPxJgY=;
	b=W37/tQve9FL8B6F+M3zu06EbDwtHalOo8N8L3CdwKRAeWXMEugf67B37VPkY8+CMvdoz59Jo5
	Ei4s1jVFuVcsNeWl9zXRNchtgyT7jxQS5sZHAUQ6np/+fv92d0YDQ6FIqE4asRhBfroZ+wOn8xz
	XA3LDzViW4YMdUc4rG1rcHc=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout06.his.huawei.com (SkyGuard) with ESMTPS id 4fcRNf3W9yzRhQf;
	Fri, 20 Mar 2026 10:29:54 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 4A9624056A;
	Fri, 20 Mar 2026 10:34:54 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:34:54 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 20 Mar 2026 10:34:53 +0800
Subject: Re: [PATCH] mm/hugetlb: fix memory offline failure due to hwpoisoned
 file hugetlb
To: Jinjiang Tu <tujinjiang@huawei.com>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <osalvador@suse.de>,
	<david@kernel.org>, <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>
References: <20260318020711.3596947-1-tujinjiang@huawei.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <0374ef8e-0da1-ad3c-c669-4946f5268881@huawei.com>
Date: Fri, 20 Mar 2026 10:34:52 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260318020711.3596947-1-tujinjiang@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Stat-Signature: 1r47emw6x15gyrh9wbppx59qcyaeedhy
X-Rspamd-Queue-Id: E72B62000C
X-Rspamd-Server: rspam03
X-HE-Tag: 1773974100-421698
X-HE-Meta: U2FsdGVkX19VFv4p+W9W5hc/CZSy3nNgUwNnVg7RJZ3oHm3W85O7anq9cNiOyrvLmlXVWWP2z2UGQeGDkGUXWzwlVt/I6Udv0p9ImjtimG08XCAd/ckjAzws9h5nDcbDK3C0Nga/y1NwE+ceiYekOwPYEFS/XSkc9n9VAqzXBRMCYIcGbxGQbGnGc3zbU5Q07OrT0n2lkYe7XJk7PvUG/MWFmZz3Z22dW6wgsvxQPxj3KhlriPscLZu5Meay9exCoBgyaQXUDuNfpmbLva91ggt94Fr22d519I9FHJUpz/yMF/+5azr0Q9maFcCR3syhoYRdsbY57UVQ3flAtOqSuxKFok0VGW3d5UIMgXGYbH5q6YOq/L5j3STtqANlXFHbiBmrYZXgYcYY6VfQoe32bAV11lz6KKsD3xn7xnzpI0gUSr7mKklW1HPKo2Cw1Y+phb3EsN8IJmd+VxP0jJmIQBhNRH0PQkAyeS5knC/WmAifZXcU9zMVLwWzlkeP5+58i8KX2NvuwvTviCr3eUFSPSW71ADb0jZE0An+stw2WNAusPvVXoNJpAYVZzJQr5nIJWb7wXqunfojKpvMewR/VC2wRaiHrIFMsRbnpY1lGYUkvrtzagtcj5jK0OWJp1S49Wh7Kjo8Y+sAR4cd1eoJ2waxsUUS8xlCvUoWjxozyjiGF7DodmYbf8OKecp9Yh6pclFnl7XMp69Nzy4KGZJ/SmxKnpsodjyxDhI3++MLfpBbMBT9zS4Hm191VkqhaduV/ZIPLa20NucKGqdI6J72+8fILxDyVLYbqdAqK5PMWv/mO0oXVmy4gL45zGKcsqWPK1En2sgTWwIu4JZlDOacxEDsKiShFP7N5itsvTolJpkh5Ccnu455pmXxpvqAWe6f+CcA5ScHFxSIG69LyK70YCKR5oSMyQ7MNC8nX4QzaDKMllU/MaJORs/12vhco+GI+nRHmJmwO/0gONaSji8
 pdh69+A0
 rPUOq5vV9r6GAJ64QrpbKYt6u54HBnB7Ph0nM/KMvYjQh6NNo/Jc1e5aRY/GOtzUb2fmRb4vTZdTE5zHaZfMzvHlBfVqnV3aHwSHsZXY8iR+XI9Xu44q+GITmLWvD7zVxClryKGOLzepu9WZAa3Mh9Ub4xqGh1PGpTrM+Mn0JJZVVC8t6qtPq1ob5CWA0cGj2VuYgCK4l/IASTvY4KP0/mBw9kVYy3IFcSRq4zfRzoWA3UOp1bFRBT4aBPs1R/XQtjEzHu/OtZG8Zg/bncHLfnVYpOML7hU5Af/77BQEeYICoYlfBPtxYdt2gD7yk5Q+7mrj6VO52fYd+5Y9IxGeoByVhQJBS//0bTbLbOHtUz+mA+AjmBEiXJtjPhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/3/18 10:07, Jinjiang Tu wrote:
> When a file hugetlb folio triggers UCE, me_huge_page() will keep the
> hugetlb folio in pagcahe with refcount increased and PG_hwpoison set. Even
> after the hugetlb file is deleted, the hugetlb folio is still leaked.
> 
> If we want to offline the memory block that the hwpoisoned hugetlb folio
> belongs to, it fails in dissolve_free_hugetlb_folios() due to the
> hwpoisoned hugetlb folio isn't free.
> 
> I can reproduce this issue with the following steps in qemu:
>  1) echo offline >/sys/devices/system/memory/auto_online_blocks
>  2) in qemu monitor:
>        object_add memory-backend-ram,id=mem10,size=1G
>        device_add pc-dimm,id=dimm1,memdev=mem10,node=2
>  3) echo online_movable > /sys/devices/system/node/node2/memory136/state
>  4) echo 5 > /sys/devices/system/node/node2/hugepages/hugepages-2048kB/nr_hugepages
>  5) run ./hugetlb_file. This process will receive SIGBUS.
>  6) remove the hugetlbfs file.
>  7) echo offline > /sys/devices/system/node/node2/memory136/state
> 
> hugetlb_file.c:
>   fd = open("/dev/hugepages/my_hugepage_file", O_CREAT | O_RDWR, 0755);
>   fallocate(fd, 0, 0, HUGEPAGE_SIZE * 2);
>   addr = mmap(NULL, HUGEPAGE_SIZE * 2, PROT_READ | PROT_WRITE,
> 		MAP_SHARED | MAP_HUGETLB, fd, 0);
>   memset(addr, 0xaa, HUGEPAGE_SIZE * 2);
>   madvise(addr, HUGEPAGE_SIZE, MADV_HWPOISON);
> 
> To fix it, when deleting hugetlb folio from pagecache, mark the hugetlb
> folio temporary, and put the refcount increased by memory-failure. After
> the hugetlb folio is deleted from pagecache, the refcount is decreased to
> zero and the hugetlb folio is dissolved.

Thanks for your patch.

> 
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  fs/hugetlbfs/inode.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 3f70c47981de..6bebe2e67f3e 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -603,6 +603,11 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
>  							index, truncate_op))
>  				freed++;
>  
> +			if (unlikely(folio_test_hwpoison(folio))) {
> +				folio_set_hugetlb_temporary(folio);

I think it is not needed to mark the hugetlb folio as temporary because
offline_pages() will call dissolve_free_hugetlb_folios().

> +				folio_put(folio);

__get_huge_page_for_hwpoison() will always set hwpoison for hugetlb folio
even without page refcnt increased. So this folio_put() might be unexpected.
Please see [1] for detail.

Thanks.
.

