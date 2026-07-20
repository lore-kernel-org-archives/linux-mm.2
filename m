Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84024C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:26:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1465D6B008C; Sun, 19 Jul 2026 23:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F88A6B0092; Sun, 19 Jul 2026 23:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00DD16B0093; Sun, 19 Jul 2026 23:26:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF0686B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:26:57 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 487F0406DF
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:26:57 +0000 (UTC)
X-FDA: 85007718474.25.BAE0320
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5ADBD180003
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:26:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=McRk5Ehn;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784518015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pcqWYtbj4hnbd0xFCTmQXFIXCByQL/lwaFTPHzhkzbA=;
	b=bhWzTLfdMKjmNXtExtNRhAGBFfojrJHvytVxdUSCmaOoYRryC2Ib/cCMixdP4YNSWiGpR2
	hpoa8mPL+IsmVj1nmGqgbKPhduFcSwiE3ZN5ANYSXg1a/gwwrVLo+VGWv8EpYR7hlVwiyo
	T5oNe9w9C/MET3pXa/2kDhjVIRIdhyg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=McRk5Ehn;
	spf=pass (imf06.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784518015;
	b=Qq+G8Jo/UgYnZwHpoatEJdi7p8/23JYFWRW6lnMHpx6hyqgA6RDkHLhg8qSmKwSIu1Uzb/
	GsKbJHWHP/O4c8nwo1dbo0A8Ngs1rqrVlV41GQ0jKWJI6LrkAn0tzvB0014gbBEB2EREzn
	9RgWH+vdta8K3r9zL9aLDn31obiyGrc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pcqWYtbj4hnbd0xFCTmQXFIXCByQL/lwaFTPHzhkzbA=;
	b=McRk5Ehn0L0nIHaDuVJo17IKRfNyMU4yei5R2Q3Yao3+02ko0lXLbfaZUAwkeSGfEqt6iPYcW
	qzvQpTFzfUAfhsVGbIOFRf9rttV85U6AGJorekOb7fNknCz4QyEuA8GRTpG5WC/VEnI7u4Lnz1M
	7vgNypIsUmK29UdWmOlO8eQ=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4h3Qg417bYzcb4V;
	Mon, 20 Jul 2026 11:17:20 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id C697440591;
	Mon, 20 Jul 2026 11:26:44 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 11:26:44 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 20 Jul 2026 11:26:43 +0800
Subject: Re: [PATCH v3] mm/huge_memory: unlock i_mmap_rwsem before releasing
 after-split folios
To: Kiryl Shutsemau <kirill@shutemov.name>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
	"Ryan Roberts" <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
	<usama.arif@linux.dev>, Hao Zhang <zhanghao1@kylinos.cn>, Hao Zhang
	<hao_zhang_kdev@163.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	<stable@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Naoya
 Horiguchi" <nao.horiguchi@gmail.com>
References: <20260716095424.471052-1-kirill@shutemov.name>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <2680d603-d666-224f-a708-f2136908876e@huawei.com>
Date: Mon, 20 Jul 2026 11:26:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260716095424.471052-1-kirill@shutemov.name>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5ADBD180003
X-Stat-Signature: u3qe1rdmp41thb6nowry1emmq98fx7x9
X-HE-Tag: 1784518013-911301
X-HE-Meta: U2FsdGVkX18uIyROOH/k1FAHOsl91VIcbTo41myo7qaPEIO/LSqo8duCSmHlR7SzYlyJNpftbjYB/3nKOqaO/GOvFV5UkUfJX7YFtPkYYj9FS5FbGxD1GFetOea2NRBlEb/GQ3Mtk8yIurzmCmaKZOg2MVVzc2+20Ix3jUKwM0qIR27GsARuD5gUjGs0R6SngHUGsDiHVBEMQB7vIP5dbmXXnm28wUPMu/cDVY8oNtXzy5Fyhdv0zwpv473rY8t07iBlwIXhR4GBhzY/1CEkvkoI/0NXQ6te9D3O+oT6elUyeXKKM9UKJ8ODe6ttCmZibSUCX4MgwksAYj0U3LGamYn7P09u+DA07RRyt46J9aUXaYJ/g6aXijOgPwpNNt4RVS5o7QjBt8sxT+/lVpcTpHE+v9zM9/JmLWdPVQ4Reopdn8Uq3ta8CvEGC/dNTWK7Ll3Q9qXbjvRkmYSZ+M3uIBdUMEKnsqt8ilkiOocQg7UpFdB14b6Bq57r6Ek1aAlck5526XqQ+msnr2qrNQD51KjTE29pkxiDKNL55OSmIYKWYXjh4ccttN3nxWLyUuXu3CXAblrOjocIq6kYA2xHpEynQK1YkE+V/sZFJyzkavVkLt6t3KimR0CI4E1cr5zxvhPeOec9WAKuB2CmEAQYDbR8KgmTGYX+MjBPT7rDsVq1VnQiKlo1FngHstC5BYHMRWyOjWDh0L/HwkHnu5ZS1FnHohkpOxkZCjb+9hzlOjvLTHohkm9BqpKUCZQ68QOQkdWS58xpflSvR8vB1pVXT3oQWvYSa1UKin6BLrxLf5PTDpqKeHBbY/cCQncGkY/dFTqbT089f1Goz6iqpF6eXUt1SLhNjRslsxljIK8ZSvQsS+/MdDvyLuSZeoBUhWEhwpha2jvXn9MLWkVq+NHpyBioD8y4UGl2VJCO1v0ATh3ekFbjk2Yz9QhC50P6ucGpFEPRqghOcQrsoe3VBPc
 Q7o6M/cQ
 RW99yuCx81nlm7/bGYaBbsWs3PmsDdO//3EE20lh49czKMQ41ogQ1cOLyu7Nf+oJ/QP8423+psatneFoTI7t3kqrO0thaij5tswhERdlJO157llB4KDr+QbTizswM79v1ogONTyNLIwCuvHaypryUEWhIpKaiu4WKOS0qYES5EcSxutxK1IcVzzPc0cm1DuHtmvEh4UTOIokBHe9tkRWjgBizMuLUUUBjtbvTT7o2reV7I/BVx3reXJDz5IEssiryY288ZUZjlksdIG+ABjJILiZyxW0h7RZaLpmc8+9GhwTg2vLHE777WEggf5o5HIrwrAh8H6ce4+zeOGhylhpYrlkoR19UVKCrbki3J/eTzg/qyllG9808tRGpOEiVRKBytmXjkUMGhM0WKAdb8RRgYGf2wlEi/qTjrmPNi2bPrd4QFFBiD9/amzWwlKXeRxNjYpuah5VXhYxa9VyHPv1eDg4udkV91f+ADRXSo+NcAmORQ1j8ECN87jVEag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/7/16 17:54, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
> 
> __folio_split() keeps dereferencing the mapping after the split:
> shmem_uncharge(mapping->host) and remap_page() while the folios are still
> frozen/locked, and i_mmap_unlock_read(mapping) at the very end, after the
> after-split folios have been unlocked and freed.
> 
> Nothing holds an inode reference across that. The split relies on @folio
> -- which the beyond-EOF drop loop never removes, as it starts at
> folio_next(folio) -- staying locked and in the page cache to hold off
> eviction. But the unlock loop unlocks @folio before i_mmap_unlock_read()
> runs. If the caller's @lock_at is a tail beyond EOF, as memory_failure()
> passes when splitting a poisoned tail of a shmem THP that reaches past
> i_size during truncation, it too is gone from the page cache; so once
> @folio is unlocked no locked, in-cache folio pins the inode, and a
> concurrent final iput() can evict and RCU-free it before
> i_mmap_unlock_read() touches i_mmap_rwsem:
> 
>   BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
>    i_mmap_unlock_read include/linux/fs.h:537 [inline]
>    __folio_split+0x732/0x1640 mm/huge_memory.c:4100
>    try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
>    memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470
> 
>   Freed by task 4601:
>    shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
>    evict+0x57f/0xac0 fs/inode.c:870
> 
> Do every mapping dereference while @folio still pins the inode: drop
> i_mmap_rwsem right after remap_page(), before the loop that unlocks and
> frees the after-split folios, and clear @mapping so the exit path does not
> unlock it again. shmem_uncharge() and remap_page() already run before that
> point, so after this nothing past the unlock loop touches the inode or the
> mapping.
> 
> This is now a rule the split depends on, alongside keeping @folio frozen
> until the page cache is updated: no inode or mapping dereference once the
> after-split folios start being unlocked.
> 
> Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
> Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
> Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
> Cc: <stable@vger.kernel.org>
> Co-developed-by: Hao Zhang <zhanghao1@kylinos.cn>
> Signed-off-by: Hao Zhang <zhanghao1@kylinos.cn>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>

Thanks.
.

