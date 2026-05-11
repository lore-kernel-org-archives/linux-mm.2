Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4818CCD37B9
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:20:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDE46B00D6; Mon, 11 May 2026 08:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC4F26B00D7; Mon, 11 May 2026 08:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A02BD6B00D9; Mon, 11 May 2026 08:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE2E6B00D6
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:20:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 464C614070B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:20:03 +0000 (UTC)
X-FDA: 84755045886.14.6DEF027
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9EF0040008
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:19:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Bh5dXj92;
	spf=pass (imf11.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778502001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dCZIFtJXMuE+2/COrqhhAueJybF64/skKJvrKCDcOGM=;
	b=p/chxV+RPrAkUME/MoKG2WT9gL2hNaJ9EsNYu/m/NRJxPPKuV3MCfFdSb784RhE90bhmfE
	4MCkKYssSA6dY+izkwbe42KfUiScyzFDlOFIRHglD24HtL2vbZWalfPZoHVPdmV1mowYfD
	W8ZsLsGDTFMbUl8YU9BhmMl88tjgFHA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Bh5dXj92;
	spf=pass (imf11.hostedemail.com: domain of yuzenghui@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=yuzenghui@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778502001; a=rsa-sha256;
	cv=none;
	b=MURz6CCkfU2y1Z+I4Y3jfO5sPFvyWF0SnmuRn58OxfbkRP88z1PGFfofBazr9R152l7Bk2
	RKHhyGUqBInggQ0u4u6tigF4HtNBhSSzz6cAkbHrXxAnBg1SlmwZRbam0f82k0DhV0fDnD
	sJFvCgRBdTmy+0sHNKWl4xaanHoLXnU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=dCZIFtJXMuE+2/COrqhhAueJybF64/skKJvrKCDcOGM=;
	b=Bh5dXj92XABk0Z6o9gsjDjMJJilr6EB2ssykDKq4GGLCxFvle5JubTYP/v3JgYYj5Cbt1sYem
	ZkFXZ6wkVSly7b8lmNLEjtSMewNBHToQBu93c8Oura37K4ZnfIUmQAP3/Wt/7BrvgXG9ZnTmhBr
	bf0mdP4xkLGG0Xmou/XMcOk=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4gDdsK4gRHzpT0B;
	Mon, 11 May 2026 20:12:53 +0800 (CST)
Received: from kwepemk200017.china.huawei.com (unknown [7.202.194.83])
	by mail.maildlp.com (Postfix) with ESMTPS id C8C014056D;
	Mon, 11 May 2026 20:19:51 +0800 (CST)
Received: from [10.174.178.219] (10.174.178.219) by
 kwepemk200017.china.huawei.com (7.202.194.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 11 May 2026 20:19:50 +0800
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: "David Hildenbrand (Arm)" <david@kernel.org>
CC: Zenghui Yu <zenghui.yu@linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <jgg@ziepe.ca>, <leon@kernel.org>, Andrew
 Morton <akpm@linux-foundation.org>, <ljs@kernel.org>, <liam@infradead.org>,
	<vbabka@kernel.org>, <rppt@kernel.org>, <surenb@google.com>,
	<mhocko@suse.com>, Alistair Popple <apopple@nvidia.com>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
From: Zenghui Yu <yuzenghui@huawei.com>
Message-ID: <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
Date: Mon, 11 May 2026 20:19:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.219]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemk200017.china.huawei.com (7.202.194.83)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EF0040008
X-Rspam-User: 
X-Stat-Signature: jwh19wefxwhkte9tk3qmhdnch38wcsq8
X-HE-Tag: 1778501999-355209
X-HE-Meta: U2FsdGVkX18p7xicwtHVSPBYylpJ07I4WZSzSJ0CVkzzaa1iQ0mVZigc0n0MUUzOBFeopMzzybt7ANAweSkfZdNGJjZZwQbmqPxNdzoDr8wGO61L0jpvxU58FzZUnQ37gACiS3rAwiUATyBGQ/AijezphBwyQtuixew/XeJFkxnmeyq5HEcbWv9ZmCoOXH7nO3WFYulSLRWI1D6o1DDX/1C7J92C/DgTuNN3AfYdMHDAncwYik45qD1sD1DMO8hJPNSkW9T3Pjx8DlDQ+eSYtX23gBpweYt+kfWFNj4+w4u+D8V68H5MM59QXmEi9/VpIRrexMGADZBwGbgDt6M4kobZ4rZtFhfpVYfZ6GBsricWIxRdjPb/9vdM/091IHMBw/Gp2Rsg3m+YasX17xSrCNwtJjWp/yzXDgDsaP/ejB/qrh8mSMtAth/A02JgracMa1oh17nTPQGnlNEWe4qRmC1AvvadoUlJvlulBub9s83X/6fJyI6cpGk6iwtUUUD3NqrLxtH+n9g6MnB0gKnyK4+oucZojdVyf/vJO0Fj29z+QJKOw8xcYiIrtSHgCUjGxy4Z4JixJpF1/0aNe9k29eyTAdpI1Xi1RVkGnoYNtf6hh3qHRLkeeqEZxYHF1wMnL2OMjKoeMYuLqUCbkWU07emUiFMiiXcyiboW/5XDm2Nff1FQXbLyC/ZBBaUSrcuO0Gv2fJV3f3mW9EfAfHpcqgsPg4z/tSPNHlRveXOjiPRxwT8ehkH0sI0huNlJuUwB2IaJo34yvX0rt5CPcAFcVrS8VvmKnHxM2iwn9jVohdad1TfSjxsKYJxnFddIB9Oe/X6PXNqrvymvXQP2RBEY5WyA9OgbYo3xVDJVGot4E3/EyTlnTz1FB7+MlaMKwe2KP7+GqGxS1jxvaTcSaTi9ZmnvlhBcbEWfwr+Nl0Fz8NFydHfpAf+BEGY1rA+g5sRVklgiU0wIcxILYDDlcIO
 5YBFx6lf
 OCUskZLuNsp0tEVpDqGH4FaPhC6XozNyGKyRGeuxIlHXW7aDL3wj0o6AF55fy/vXpne/8Qc4Kt4hxMS2jszWqHNBSgyeesE8jPIhWovasPXy43cyV2zkplfcqVVbQg9ayDmigXgKyUwQL9x1YP7HmV/jtq0LgjkXjJF8hsXOMasjFiuJujfTFvdMQzXN/nx0FgJyk+fQADKHiaoWg9PDSoXqIfjLoAGHF9ZxK+FO+TvE15AaJqe/bRaus1ez4fmdXqxK68XZ7jYnL5zYNIxQtE8UJCplHqhPVPa9qrEFyLDIVWgosK3hNmmWtY+Q73ic+yItazsyZ9Dd+Z/ClSHYDOnwNUtVZA5GOdxO8EjCSNnc9f8BEdER7wHRZ/tc4AMKnSEdx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/8 19:53, David Hildenbrand (Arm) wrote:
> On 5/6/26 17:42, Zenghui Yu wrote:
> > Hi all,
> >
> > Running mm/ksft_hmm.sh triggers the following splat:
> >
> >  ------------[ cut here ]------------
> >  alloc_tag was not set
> >  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0,
> > CPU#5: hmm-tests/2020
> >  Modules linked in: test_hmm rfkill drm backlight fuse
> >  CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted
> > 7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
> >  Hardware name: QEMU QEMU Virtual Machine, BIOS
> > edk2-stable202408-prebuilt.qemu.org 08/13/2024
> >  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> >  pc : ___free_pages+0x2a0/0x2d0
> >  lr : ___free_pages+0x2a0/0x2d0
> >  sp : ffff80008345b530
> >  x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
> >  x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
> >  x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
> >  x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
> >  x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
> >  x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
> >  x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
> >  x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
> >  x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
> >  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
> >  Call trace:
> >   ___free_pages+0x2a0/0x2d0 (P)
> >   __free_pages+0x14/0x20
> >   dmirror_devmem_free+0x13c/0x158 [test_hmm]
> >   free_zone_device_folio+0x144/0x1e4
> >   __folio_put+0x124/0x130
> >   free_folio_and_swap_cache+0xa8/0xcc
> >   __folio_split+0x664/0x7fc
> >   split_folio_to_list+0x50/0x5c
> >   migrate_vma_split_folio+0x13c/0x25c
> >   migrate_vma_collect_pmd+0xed4/0xf68
> >   walk_pgd_range+0x598/0x9a0
> >   __walk_page_range+0x90/0x1a0
> >   walk_page_range_mm_unsafe+0x194/0x20c
> >   walk_page_range+0x20/0x2c
> >   migrate_vma_setup+0x18c/0x224
> >   dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
> >   do_swap_page+0x1458/0x185c
> >   __handle_mm_fault+0x85c/0x1ba0
> >   handle_mm_fault+0xb0/0x290
> >   do_page_fault+0x1f8/0x6f8
> >   do_translation_fault+0x60/0x6c
> >   do_mem_abort+0x44/0x94
> >   el0_da+0x30/0xdc
> >   el0t_64_sync_handler+0xd0/0xe4
> >   el0t_64_sync+0x198/0x19c
> >  ---[ end trace 0000000000000000 ]---
> >  lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has
> > 16744448 allocated at module unload
> >
> >
> > It was tested on kernel built with arm64's virt.config and
> >
> > +CONFIG_ZONE_DEVICE=y
> > +CONFIG_DEVICE_PRIVATE=y
> > +CONFIG_TEST_HMM=m
> > +CONFIG_MEM_ALLOC_PROFILING=y
> > +CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
> 
> I assume there is a weird interaction between alloc tags and simulated
> ZONE_DEVICE memory in test_hmm.c

FYI this can be reproduced by running the migrate_partial_unmap_fault
test case.

TEST_F(hmm, migrate_partial_unmap_fault)
{
	buffer->mirror = malloc(TWOMEG);
	buffer->ptr = map;	// points to a THP

	/* Initialize buffer in system memory. */
	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
		ptr[i] = i;

	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);

	munmap(buffer->ptr, ONEMEG);

	/* Fault pages back to system memory and check them. */
	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
		if (i * sizeof(int) < 0 ||
		    i * sizeof(int) >= ONEMEG)
			ASSERT_EQ(ptr[i], i);	// triggers a fault ->


dmirror_devmem_fault()
	migrate_vma_setup()
		migrate_vma_collect_pmd()
			// !pte_present(pte) && folio_test_large(folio)
			migrate_vma_split_folio()
				split_folio()
					[...]

__folio_split() {
	unmap_folio();

	__folio_freeze_and_split_unmapped() {
		__split_unmapped_folio();

		for (...) {
			zone_device_private_split_cb(.., new_folio);
			// -> dmirror_devmem_folio_split() which doesn't
			// set alloc tag for the backing system memory
			// page being split, i.e., rpage_tail
		}

		zone_device_private_split_cb(.., NULL);
	}

	remap_page();

	for (...)
		free_folio_and_swap_cache(new_folio);
		// -> dmirror_devmem_free()/__free_page() which warns if
		// the page being freed doesn't have alloc tag set, in
		// alloc_tag_sub_check().
}

The WARN disappears with the following diff. But I'm not sure if I've
missed more important points (which is likely to happen ;-) ).

diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index ed1bdcf1f8ab..eefa2a739917 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -191,6 +191,7 @@ void pgalloc_tag_split(struct folio *folio, int
old_order, int new_order)
 		}
 	}
 }
+EXPORT_SYMBOL(pgalloc_tag_split);

 void pgalloc_tag_swap(struct folio *new, struct folio *old)
 {
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..3bec51828916 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1713,6 +1713,7 @@ static void dmirror_devmem_folio_split(struct
folio *head, struct folio *tail)
 	rfolio = page_folio(rpage);

 	if (tail == NULL) {
+		pgalloc_tag_split(rfolio, folio_order(rfolio), 0);
 		folio_reset_order(rfolio);
 		rfolio->mapping = NULL;
 		folio_set_count(rfolio, 1);

Thanks,
Zenghui

