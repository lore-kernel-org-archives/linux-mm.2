Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94E39CD484C
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0856C6B014B; Mon, 11 May 2026 12:39:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05E436B014C; Mon, 11 May 2026 12:39:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDCC86B014D; Mon, 11 May 2026 12:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D8B3F6B014B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:39:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A6A97C0506
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:39:01 +0000 (UTC)
X-FDA: 84755698482.21.6582996
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf15.hostedemail.com (Postfix) with ESMTP id 915B4A0002
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:38:59 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HPVz3qKC;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778517540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atbYDvhBZSt0K6jPPBLuz6AZnTDfzHuTJr9adJta60Q=;
	b=L/8PA6Cfrp0OB7lJiJS3U3tMQkR/d2ULRRTM/uY1ipbIIET/IqCGb5auFQXAe5l13S1yfJ
	pEWiyYvNf2dwKh/K6otmeqprd3PfRcYcc8vjOsiloTJs32DepXe/tXArJjW1TqRcaLFN+1
	3eSMRZxex8dWJq1KQYO24dm74Fepd5M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HPVz3qKC;
	spf=pass (imf15.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778517540; a=rsa-sha256;
	cv=none;
	b=57yUPYJXfg85VcQWWKKJOKGWlY3ofUCHvIKrNanzCfPE57BJqbIMX7qqEwFtWxQkBZQMyh
	knvqbDFvyqOzKY4R2JYjMlrNkjKFgPBOU0bOLVmd/VdzO53FiDE6WyVv4ItjlXZkROB205
	OXb/48XJ6EzBKINboRFk/20BrNKfwx8=
Message-ID: <dff84fe1-ae17-410a-93a2-c5fb921e7f8f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778517536;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=atbYDvhBZSt0K6jPPBLuz6AZnTDfzHuTJr9adJta60Q=;
	b=HPVz3qKC0mlPPZmmMKe3J4vbCgTMVfn2DcNZC1+M/f9M+SEXrcIhkEiCf/86dPHEUG1bkG
	tw5nAOI9f8c7aQL07C4voz1JGK6Na9VaUgsy/dxnWg9cvcDM5JaPxby/TlO12+j35TLXXP
	kkLSOyb06x2/9Z+05GuzavuU3UKCp24=
Date: Tue, 12 May 2026 00:38:36 +0800
MIME-Version: 1.0
Subject: Re: "alloc_tag was not set" when running mm/ksft_hmm.sh
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, jgg@ziepe.ca, leon@kernel.org,
 Andrew Morton <akpm@linux-foundation.org>, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, Alistair Popple <apopple@nvidia.com>
References: <be9a8bae-9223-4966-bba9-2cbe39c8f4de@linux.dev>
 <10e4565a-b416-45d9-a8b0-cd32532b2630@kernel.org>
 <2b46241c-158b-c9dd-9b81-a98366b2c9fb@huawei.com>
 <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <c16350fa-2f74-4517-8d97-4772def97b78@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zdxyxrmu8eezf5zcais9kyob4k7sjzw7
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 915B4A0002
X-Rspam-User: 
X-HE-Tag: 1778517539-113270
X-HE-Meta: U2FsdGVkX191LeU1td7XjCti+Ls0O9XwtYITT4lpfO3WShwXLZg7WiFwN5q8dpzQTAIoqgEiAckmmXeHk3CGIKkJje0SomR6Hn3Jea6T3z7QbW+htlOdZHD4WQp4peU28N9RgP2db0Kf6KsCJG9Y3sax9690lR3afxUvzdq8hkt1Dy3oLMZOmB2AZ5CgFQqk4aiys2BEn6d6lKo/Xo1CVxofWlgCPVl0FgdMx5Sfs4C7G747f3xzKWVE3FvItod28/LGlMkdrul/n59ngq2F9XOF3NT3P9UhfiptpKmFWStcxo4kwdH6cXMHkQy26wgoSSaKwmszAl2AS/9/BS1xCypNW22t2A/pkHcp9fJXGteBPUMif9PxvuXsR/2Jg0wKkmaxor8tSEAUlXQUwAzcHOgQpDH5e8tjN78FrQ8IMuHwuBmNgtIVv35qrffxpwzy8xSuKZlren/RRAD+0hgXW8WQAPD1b/ONaOKYK+HBzSwQEJf6M7u4x+o0R04vvS465OkJ8XryDtdeZmWKAlKsGBSIxPrMk6Ee8VTVRS1Nvl/TN5QE7Zs6fnMkr4CH0ZILLl9CbYw59dnm5eNbTB0syiJOPKO5xnODnD9+5WmpVw87daMHeRUGzcJPsmraEImaey6dVaJpZOuGKxx9LjkVfY5vyUIXDJzwp7lN0JT89QIvWpijopFO+FnjwEo/kaYufDKgujqgXRvUSKtHiBYdIHZdyXj7VLRp7xF7mxLKu9PUh1FjekiaiMaX+C3583nvKH4U34R046eUMO0ogAPMtpiXabi+iFkHC+CzNavyjK3qdirz1c/pt8r9YuRJYMaSRUtFUaHfD8DCCdgX2g/F3g7dYtmRICWa8IPVJHebutm/V833Uo0lTU/55GyGMgg3k2zkeDdfc+mco5QvtaHAgrg57Hs8rUWW/GNXjFz0CBciWijGe60tJDk50PRhTTbrqGfpYKS7y+0AUi/IK8t
 Uj4vP8p9
 erU15vjQFPl4FO5QKXI4/5qDx5oiL08dsWkaXiofGcCQuHUSGAKqMfi3Y8UADfBFnVrVojauwyli+g4N4TLpqBotq5ljvvBCtKTB4yxz5eGH0abvIvhlD/MKThSFeEyz3jzNpf/+TkBAoIlSkK+F+pLpFZZj+8YDGjepkqHVxBIJpxVMqB+4x7xkVNvbusEZjMy8bCXF+ODSp5Q1p+vISKemx595FBvce1jz1hl7dJFKmbCEcSDHEw11Kaixw+ppRfLMKCKPZ6yrqRx8Bi15nik6wqpOpXpbGxOcsG8B8fsNkkYgqBR+Ez5Mv2IYX5rlRvyD7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On 5/11/26 8:47 PM, David Hildenbrand (Arm) wrote:
> On 5/11/26 14:19, Zenghui Yu wrote:
> > On 2026/5/8 19:53, David Hildenbrand (Arm) wrote:
> > > On 5/6/26 17:42, Zenghui Yu wrote:
> > > > Hi all,
> > > >
> > > > Running mm/ksft_hmm.sh triggers the following splat:
> > > >
> > > >  ------------[ cut here ]------------
> > > >  alloc_tag was not set
> > > >  WARNING: ./include/linux/alloc_tag.h:164 at ___free_pages+0x2a0/0x2d0, CPU#5: hmm-tests/2020
> > > >  Modules linked in: test_hmm rfkill drm backlight fuse
> > > >  CPU: 5 UID: 0 PID: 2020 Comm: hmm-tests Kdump: loaded Not tainted 7.1.0-rc2-00099-gadc1e5c6203c-dirty #285 PREEMPT
> > > >  Hardware name: QEMU QEMU Virtual Machine, BIOS edk2-stable202408-prebuilt.qemu.org 08/13/2024
> > > >  pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS BTYPE=--)
> > > >  pc : ___free_pages+0x2a0/0x2d0
> > > >  lr : ___free_pages+0x2a0/0x2d0
> > > >  sp : ffff80008345b530
> > > >  x29: ffff80008345b530 x28: ffff80008345b700 x27: ffffffffbfff8040
> > > >  x26: ffff0000c41cb360 x25: ffff0000c0c64008 x24: ffff800081aae400
> > > >  x23: 05ffff0000000200 x22: 0000000000000000 x21: 0000000000000000
> > > >  x20: fffffdffc5f20040 x19: 0000000000000000 x18: fffffffffffe7c78
> > > >  x17: 0000000000000000 x16: 0000000000000000 x15: fffffffffffe7c98
> > > >  x14: 00000000000001d1 x13: ffff8000818f3d58 x12: 0000000000000573
> > > >  x11: fffffffffffe7c98 x10: ffff80008194bd58 x9 : 3ffffffffffff000
> > > >  x8 : ffff8000818f3d58 x7 : ffff80008194bd58 x6 : 0000000000000000
> > > >  x5 : ffff0001fedb1088 x4 : 0000000000000001 x3 : 0000000000000000
> > > >  x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000c7f58000
> > > >  Call trace:
> > > >   ___free_pages+0x2a0/0x2d0 (P)
> > > >   __free_pages+0x14/0x20
> > > >   dmirror_devmem_free+0x13c/0x158 [test_hmm]
> > > >   free_zone_device_folio+0x144/0x1e4
> > > >   __folio_put+0x124/0x130
> > > >   free_folio_and_swap_cache+0xa8/0xcc
> > > >   __folio_split+0x664/0x7fc
> > > >   split_folio_to_list+0x50/0x5c
> > > >   migrate_vma_split_folio+0x13c/0x25c
> > > >   migrate_vma_collect_pmd+0xed4/0xf68
> > > >   walk_pgd_range+0x598/0x9a0
> > > >   __walk_page_range+0x90/0x1a0
> > > >   walk_page_range_mm_unsafe+0x194/0x20c
> > > >   walk_page_range+0x20/0x2c
> > > >   migrate_vma_setup+0x18c/0x224
> > > >   dmirror_devmem_fault+0x188/0x2b8 [test_hmm]
> > > >   do_swap_page+0x1458/0x185c
> > > >   __handle_mm_fault+0x85c/0x1ba0
> > > >   handle_mm_fault+0xb0/0x290
> > > >   do_page_fault+0x1f8/0x6f8
> > > >   do_translation_fault+0x60/0x6c
> > > >   do_mem_abort+0x44/0x94
> > > >   el0_da+0x30/0xdc
> > > >   el0t_64_sync_handler+0xd0/0xe4
> > > >   el0t_64_sync+0x198/0x19c
> > > >  ---[ end trace 0000000000000000 ]---
> > > >  lib/test_hmm.c:705 module test_hmm func:dmirror_devmem_alloc_page has 16744448 allocated at module unload
> > > >
> > > >
> > > > It was tested on kernel built with arm64's virt.config and
> > > >
> > > > +CONFIG_ZONE_DEVICE=y
> > > > +CONFIG_DEVICE_PRIVATE=y
> > > > +CONFIG_TEST_HMM=m
> > > > +CONFIG_MEM_ALLOC_PROFILING=y
> > > > +CONFIG_MEM_ALLOC_PROFILING_DEBUG=y
> > >
> > > I assume there is a weird interaction between alloc tags and simulated
> > > ZONE_DEVICE memory in test_hmm.c
> >
> > FYI this can be reproduced by running the migrate_partial_unmap_fault
> > test case.
> >
> > TEST_F(hmm, migrate_partial_unmap_fault)
> > {
> > 	buffer->mirror = malloc(TWOMEG);
> > 	buffer->ptr = map;	// points to a THP
> >
> > 	/* Initialize buffer in system memory. */
> > 	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
> > 		ptr[i] = i;
> >
> > 	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
> >
> > 	munmap(buffer->ptr, ONEMEG);
> >
> > 	/* Fault pages back to system memory and check them. */
> > 	for (i = 0, ptr = buffer->ptr; i < TWOMEG / sizeof(*ptr); ++i)
> > 		if (i * sizeof(int) < 0 ||
> > 		    i * sizeof(int) >= ONEMEG)
> > 			ASSERT_EQ(ptr[i], i);	// triggers a fault ->
> >
> >
> > dmirror_devmem_fault()
> > 	migrate_vma_setup()
> > 		migrate_vma_collect_pmd()
> > 			// !pte_present(pte) && folio_test_large(folio)
> > 			migrate_vma_split_folio()
> > 				split_folio()
> > 					[...]
> >
> > __folio_split() {
> > 	unmap_folio();
> >
> > 	__folio_freeze_and_split_unmapped() {
> > 		__split_unmapped_folio();
> >
> > 		for (...) {
> > 			zone_device_private_split_cb(.., new_folio);
> > 			// -> dmirror_devmem_folio_split() which doesn't
> > 			// set alloc tag for the backing system memory
> > 			// page being split, i.e., rpage_tail
> > 		}
> >
> > 		zone_device_private_split_cb(.., NULL);
> > 	}
> >
> > 	remap_page();
> >
> > 	for (...)
> > 		free_folio_and_swap_cache(new_folio);
> > 		// -> dmirror_devmem_free()/__free_page() which warns if
> > 		// the page being freed doesn't have alloc tag set, in
> > 		// alloc_tag_sub_check().
> > }
> >
> > The WARN disappears with the following diff. But I'm not sure if I've
> > missed more important points (which is likely to happen ;-) ).
> >
> > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > index ed1bdcf1f8ab..eefa2a739917 100644
> > --- a/lib/alloc_tag.c
> > +++ b/lib/alloc_tag.c
> > @@ -191,6 +191,7 @@ void pgalloc_tag_split(struct folio *folio, int old_order, int new_order)
> >  		}
> >  	}
> >  }
> > +EXPORT_SYMBOL(pgalloc_tag_split);
> >
> >  void pgalloc_tag_swap(struct folio *new, struct folio *old)
> >  {
> > diff --git a/lib/test_hmm.c b/lib/test_hmm.c
> > index 213504915737..3bec51828916 100644
> > --- a/lib/test_hmm.c
> > +++ b/lib/test_hmm.c
> > @@ -1713,6 +1713,7 @@ static void dmirror_devmem_folio_split(struct folio *head, struct folio *tail)
> >  	rfolio = page_folio(rpage);
> >
> >  	if (tail == NULL) {
> > +		pgalloc_tag_split(rfolio, folio_order(rfolio), 0);
> >  		folio_reset_order(rfolio);
> >  		rfolio->mapping = NULL;
> >  		folio_set_count(rfolio, 1);
> 
> 
> zone_device_private_split_cb(), that ends up calling ->folio_split().
> 
> We do have a call to pgalloc_tag_split() in __split_unmapped_folio(), invoked in
> __folio_freeze_and_split_unmapped() before calling
> zone_device_private_split_cb() when iterating the folios.

If I read the code correctly, pgalloc_tag_split() in
__split_unmapped_folio() deals with device private pages' alloc tag. But
what alloc_tag_sub_check() warns on are real system memory pages (device
page's backing page), which are allocated by
dmirror_devmem_alloc_page()/folio_page().

static void dmirror_devmem_folio_split(struct folio *head, struct folio
*tail)
{
	struct page *rpage = BACKING_PAGE(folio_page(head, 0));

Thanks,
Zenghui

> The zone_device_private_split_cb(folio, NULL); is then called on the first folio
> after looping over the other (new) folios.
> 
> I would assume that __folio_freeze_and_split_unmapped() would already do the
> right thing?
> 
> Maybe the issue is the hard-coded folio_reset_order() in
> dmirror_devmem_folio_split(), where we seem to assume that we split to an
> order-0 folio?
> 

