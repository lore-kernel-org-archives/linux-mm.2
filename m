Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6714ECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 07:38:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4346B008A; Wed, 17 Jun 2026 03:38:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355136B008C; Wed, 17 Jun 2026 03:38:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26AFB6B0092; Wed, 17 Jun 2026 03:38:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E4BD66B008A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 03:38:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 685B1A0349
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:38:26 +0000 (UTC)
X-FDA: 84888601812.13.12B7A25
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf28.hostedemail.com (Postfix) with ESMTP id 58E81C0009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 07:38:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=L1cW5Lko;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781681903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OlHpfhG6RtHov9Iyyi+B0BO0xvSLE7bwTX2Gg1r93rs=;
	b=VxUbpRA1SbvWo5zqfgLX8IiyzwxvyydZidhaxPtyQzRC57LPNJm6u6Kso6QE06BWqiAFMr
	l2hO5HKJfxSYBL+D6OegMi8BZLRZEsV2QU3JTae118o34ZfDi7KBlWn0NDqpqjOUYXpvbj
	xhFXTPjcmSoJlNTmFEvNbN1pRYWyRwQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=L1cW5Lko;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781681903;
	b=MAbIeMgxO2hcZOlJ07qnaJj2cITNIFk4z8ALhw914qNzBaMEBntwXLmuIVkHZowY7IDkk/
	kQ6P0w1QE/h30hva6jtae7NhFJOR2IQgmidrB8QYyu1WfB0Sm9FNx0CiY3cWjDx+kL36dA
	+SRmvKuw7W3cCtxAj4IQdjVH0D6RSEM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=OlHpfhG6RtHov9Iyyi+B0BO0xvSLE7bwTX2Gg1r93rs=;
	b=L1cW5Lko8NTkoTU61zFAqQl6tc/dqLCfB1VusVhd8zgxxrESR45LRPCFHhA01wV2X8PlyYFT/
	QRBgnpC43exbQnQN4Fg6iPly0OzYZupdlflCdX5g6MmYd7jZLdxArz0s9TQsK/I8FulUzIubeU5
	SHoTN5mNfSkoR4XOIMVgPJQ=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4ggFqB2WH9z12LDV;
	Wed, 17 Jun 2026 15:29:26 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 6676340575;
	Wed, 17 Jun 2026 15:38:17 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 15:38:02 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 15:38:00 +0800
Subject: Re: [PATCH v5 4/4] selftests/mm: add hard memory failure anonymous 1G
 HugeTLB page test
To: Jiaqi Yan <jiaqiyan@google.com>
CC: <osalvador@suse.de>, <lorenzo.stoakes@oracle.com>, <jackmanb@google.com>,
	<hannes@cmpxchg.org>, <nao.horiguchi@gmail.com>, <david@kernel.org>,
	<william.roche@oracle.com>, <tony.luck@intel.com>,
	<wangkefeng.wang@huawei.com>, <jane.chu@oracle.com>,
	<akpm@linux-foundation.org>, <muchun.song@linux.dev>, <liam@infradead.org>,
	<rientjes@google.com>, <duenwen@google.com>, <jthoughton@google.com>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <shuah@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, <boudewijn@delta-utec.com>, <ljs@kernel.org>,
	<osalvador@kernel.org>, <ziy@nvidia.com>, <harry.yoo@oracle.com>,
	<willy@infradead.org>
References: <20260531055829.3636554-1-jiaqiyan@google.com>
 <20260531055829.3636554-5-jiaqiyan@google.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <d1333353-b615-2dc1-ecff-8093d237cba7@huawei.com>
Date: Wed, 17 Jun 2026 15:38:00 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20260531055829.3636554-5-jiaqiyan@google.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 4xutkkrqd7fztfidpn1qrkjsifscot59
X-Rspamd-Queue-Id: 58E81C0009
X-HE-Tag: 1781681902-882030
X-HE-Meta: U2FsdGVkX18P1b2ApgsPIj3+VS3OYz74nTvyTrUcPgHnewQ9XM5ivMDueqkXqcSRy/v0Dp/wxSGRiHCfuBoZ2FNf1lEbBn0G+arw06sXXp1uv4xSJEOh9Q2ugDLrPoqNH0Rkwc3KD6CZmCZ3gKQ0nyF5DoLXCW0bDTapA8OK4Jg0z9/NQmwYFGXcd+SmD6fJMxNz1qJLAnXYIKQ2XswCeLdTdMzDUcrqRwDuKd+6KPwa2JbuKoMszyn3l2O5uBTs+7RMfGYnpWlKVFcXABF2NEGSJqATrU+1lzkxs4ENqsGnk9onQKfeJ992rDuj0kjcgnEpLir7ZZyk9ACVqVBHxO0085ZUwKDMt04uspQsm2s/IElJ/piyBKEilRcnmjavgIjw2SWqw06ftL1DB3xtAJybfhfQWDT37BnkayDuzch8Jq6RbTsyL2XQa4XQl/qu45zynlmfE7gfavmLInC8e9/iMoxAGC8Lk0RwMUP/2qYWPJ+47im5+iQDqEiVNDsgZvAkk+CcXODWniCAgb6JEiUtL5QmaAc900H1t+leaP5T9PBJ4IB5fGUzKvDErLpYV1YZ4695MFem957G8VKo7U4shi8DIEZ3cvGbi2TPnrKbipMePX4zgZxqQ89EtROhFkho5YUY1yVMVxQk3CzEJ2LE7Tj+eZor37LNU58ji4di7Fy+cv/ADtxY3nx6zuOwBGtq7LTjvsud3HL/5yMSr0j7CCTiNQrm9ZC4OOUFSczZ9VNiSGj74CPq0Kw+LQO6HsZUjsncEBIN3R5YcboqIQVjElUmZ//FVCNvIs3EkbMpZKX+V0WU7DD0FKa8H2oAIDP92WFdRehKfYgBsRVH9l9yhhMpOV88QujlwcmqTFCTtFNDe6i3ROrlHX1VLT0+PEj/7VJdQRGUf9JJGo802RAKRRJ/ksgxcHOyeaAIMI/JS399bEGV/VH5oP9yVFpHwZd2T8AOT/M1QO5cooa
 E6iKzZI4
 QsYPyiP8Se6JSd8ROKljJQqNXQsZ6JpgW3ks8Asd7IofVOXMFrL3Lt/RJQyGt8URDelJGCZgEbGLVCGDfgqlSqri6Ts48h2BsJuu2aQGLjk5K2sc/vs+t142O3TtZLAfuKKhBfTbgxCwAAxQRBJppEAPN2+Rkc0uhAywIyONCAvkItZuGbOn+Lim3ZZUD0Lnc1QmDY3OILQu63rkG0VzG8Toi6E4F9YYgTzTEeziCSAaMnXbVlaGKD26clmXShIr1JfADyNI38EVuq/Kk8oomuScuwUNeIWL0hazZcDhSf+LJl/hsne1/qEYpP9mOgKNDMY6Uo7EchGFpDuhl0qhgJBOli+ee9RhpR3HIm0QwQo0/lduXYctv6ITrHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/31 13:58, Jiaqi Yan wrote:
> Add a new testcase to validate memory failure recovery for HWPoison
> anonymous 1G HugeTLB page, including proper SIGBUS delivery,
> releasing a 1G HugeTLB page containing one HWPoison page to buddy
> allocator, and isolation of the raw HWPoison page.
> 
> Although can be added in future, this patch does not support testing
> the MADV_SOFT variant.
> 

Thanks for your patch. Some comments below.

> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> ---
>  tools/testing/selftests/mm/memory-failure.c | 73 +++++++++++++++++++--
>  1 file changed, 68 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/mm/memory-failure.c b/tools/testing/selftests/mm/memory-failure.c
> index 032ed952057c..ea43b2877c81 100644
> --- a/tools/testing/selftests/mm/memory-failure.c
> +++ b/tools/testing/selftests/mm/memory-failure.c
> @@ -18,6 +18,7 @@
>  #include <linux/magic.h>
>  #include <errno.h>
>  
> +#include "hugepage_settings.h"
>  #include "vm_util.h"
>  
>  enum inject_type {
> @@ -27,6 +28,7 @@ enum inject_type {
>  
>  enum result_type {
>  	MADV_HARD_ANON,
> +	MADV_HARD_ANON_HUGETLB,
>  	MADV_HARD_CLEAN_PAGECACHE,
>  	MADV_HARD_DIRTY_PAGECACHE,
>  	MADV_SOFT_ANON,
> @@ -47,6 +49,8 @@ FIXTURE(memory_failure)
>  	int pagemap_fd;
>  	int kpageflags_fd;
>  	bool triggered;
> +	/* Number of initial HugeTLB pages with default page size. */
> +	unsigned long nr_hugetlb_pages;
>  };
>  
>  FIXTURE_VARIANT(memory_failure)
> @@ -157,11 +161,11 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>  		  void *vaddr, enum result_type type, int setjmp)
>  {
>  	unsigned long size;
> +	unsigned long nr_hugetlb_pages;
>  	uint64_t pfn_flags;
>  
>  	switch (type) {
>  	case MADV_SOFT_ANON:
> -	case MADV_HARD_CLEAN_PAGECACHE:
>  	case MADV_SOFT_CLEAN_PAGECACHE:
>  	case MADV_SOFT_DIRTY_PAGECACHE:
>  		/* It is not expected to receive a SIGBUS signal. */
> @@ -174,6 +178,7 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>  		ASSERT_NE(pagemap_get_pfn(self->pagemap_fd, vaddr), self->pfn);
>  		break;
>  	case MADV_HARD_ANON:
> +	case MADV_HARD_ANON_HUGETLB:
>  	case MADV_HARD_DIRTY_PAGECACHE:
>  		/* The SIGBUS signal should have been received. */
>  		ASSERT_EQ(setjmp, 1);
> @@ -183,17 +188,36 @@ static void check(struct __test_metadata *_metadata, FIXTURE_DATA(memory_failure
>  		ASSERT_EQ(siginfo.si_code, BUS_MCEERR_AR);
>  		ASSERT_EQ(1UL << siginfo.si_addr_lsb, self->page_size);
>  		ASSERT_EQ(siginfo.si_addr, vaddr);
> -
> -		/* XXX Check backing pte is hwpoison entry when supported. */
> -		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));

Can we write this as something like:

		if (type != MADV_HARD_ANON_HUGETLB)
			/*
			 * XXX Check backing pte is hwpoison entry when supported.
			 * Check backing pte is hwpoison entry when supported.
			 * Although try_to_unmap_one() also installs hwpoison entry
			 * for HugeTLB, pagemap_hugetlb_range() doesn't parse
 			 * swap entries at all.
			 */
			ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));

So we don't need to modify the if condition when more base page size tests are added?

>  		break;
>  	default:
>  		SKIP(return, "unexpected inject type %d.\n", type);
>  	}
>  
> +	if (type == MADV_HARD_ANON || type == MADV_HARD_DIRTY_PAGECACHE) {
> +		/*
> +		 * Check backing pte is hwpoison entry when supported.
> +		 * Although try_to_unmap_one() also installs hwpoison entry
> +		 * for HugeTLB, pagemap_hugetlb_range() doesn't parse
> +		 * swap entries at all.
> +		 */
> +		ASSERT_TRUE(pagemap_is_swapped(self->pagemap_fd, vaddr));
> +	}
> +
>  	/* Check if the value of HardwareCorrupted has increased. */
>  	ASSERT_EQ(get_hardware_corrupted_size(&size), 0);
> -	ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
> +
> +	if (type == MADV_HARD_ANON_HUGETLB) {
> +		/*
> +		 * Only one page is hardware corrupted; the rest should all be
> +		 * released to buddy allocator.
> +		 */
> +		ASSERT_EQ(size, self->corrupted_size + getpagesize() / 1024);
> +		/* HugeTLB should have lost the HWPoison HugeTLB page. */
> +		nr_hugetlb_pages = hugetlb_nr_default_pages();
> +		ASSERT_EQ(nr_hugetlb_pages + 1, self->nr_hugetlb_pages);
> +	} else {
> +		ASSERT_EQ(size, self->corrupted_size + self->page_size / 1024);
> +	}
>  
>  	/* Check if HWPoison flag is set. */
>  	ASSERT_EQ(pageflags_get(self->pfn, self->kpageflags_fd, &pfn_flags), 0);
> @@ -247,6 +271,45 @@ TEST_F(memory_failure, anon)
>  	ASSERT_EQ(munmap(addr, self->page_size), 0);
>  }
>  
> +TEST_F(memory_failure, anon_hugetlb)
> +{
> +	char *addr;
> +	int ret;
> +	const unsigned long nr_alloc_hugetlb_pages = 4;
> +	unsigned long alloc_size;
> +
> +	if (variant->type == MADV_SOFT)
> +		SKIP(return, "Soft offline test is not implemented");
> +
> +	/* HugeTLB settings will be automatically restored when test exits. */
> +	hugetlb_setup_default(nr_alloc_hugetlb_pages);
> +
> +	alloc_size = default_huge_page_size() * nr_alloc_hugetlb_pages;
> +	self->page_size = default_huge_page_size();
> +	self->nr_hugetlb_pages = hugetlb_nr_default_pages();
> +
> +	addr = mmap(0, alloc_size, PROT_READ | PROT_WRITE,
> +		    MAP_ANONYMOUS | MAP_PRIVATE | MAP_HUGETLB, -1, 0);
> +	if (addr == MAP_FAILED)
> +		SKIP(return, "mmap failed, not enough memory or 1G hugetlb not supported.\n");

This test is no longer 1G specific, so "1G" should be removed too?

> +	memset(addr, 0xce, alloc_size);

For 1G hugetlb, alloc_size will be 4G. Would memset() here take a long time to finish its work?
Same issue in check_memory(). Should we try to enhance this or it is just acceptable?

Thanks.
.

