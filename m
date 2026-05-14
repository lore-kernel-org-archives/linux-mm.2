Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B19CD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 09:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F276B0088; Thu, 14 May 2026 05:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E516B0099; Thu, 14 May 2026 05:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73CC26B00A0; Thu, 14 May 2026 05:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5DE8D6B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 05:45:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 250BF1A02B3
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:45:06 +0000 (UTC)
X-FDA: 84765541812.22.4A2C4A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 540E318000C
	for <linux-mm@kvack.org>; Thu, 14 May 2026 09:45:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EkoU6SkV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778751904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jYIdQbY7BX/fa2WJ3GVr8q6tRRhYxAP/XZfsxhMB+w=;
	b=fEgClct0HFzacCwdJBfh+AflwNhBavXnQ7EkaMy7s/AJjhAjFNU51SiZwwqLWgQaniqyHZ
	FkZ9Yea0Og1jNmXQgN7VaL/e4kmzBC4ZkVn/9HKibdxd2kZUWFGuxFAh8fj6+3OpALwz6z
	rnPRr1iqV0ABFj1uoDo60G67rpVyobw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778751904; a=rsa-sha256;
	cv=none;
	b=ssGYVKFsYiK4bwLY55XhB2l+qtPJBlNeHm7YavkCWH7FAM0JMWFIwxAslD7X08AbQ9cFGz
	l0t6RecNMlhOvWOFosBbXDpDdIUBKsA07REYtFm1LqJJWh/M+bkFuoOovJxI5QNzn2g0lY
	L7vEUMlIZmkwi2kR40qIce3qov4Ua1k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EkoU6SkV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA92D60008;
	Thu, 14 May 2026 09:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED29DC2BCB3;
	Thu, 14 May 2026 09:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778751903;
	bh=PLNJMPTVnkRKB2ZVyKp4WUwzWIH4JrjwI4L1YKFK+5E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EkoU6SkVlkLreI3yOVr8L+wl8F9b3HyU2LzVUKB4V4atMh+/XhxHNwLwuhes9k3/f
	 02P+xM6XY3kqYpGPkkxGAQ5wjSGLEuZwVSjvYOyr1FPKll5jzffV0MNgvBnVKmaNpb
	 HB3zHJRARq+FEqWhiz/jBsoS1M/+bVs3QNGGoCAX59UDZ3hFJyfOmubFYC+wLFRYul
	 YOP8d3YjQyD7NzOfUb3etaPbM/T5ON9VNhDx8XjkXLFC6KscLNAPlxo8RqmXrClFwd
	 x2zIHInQdC3oqd9t7RvoPXa5vwMBtX+kPSUP4YJoiJGxNM91Fz4Fw1nM9zmXWRlTzU
	 HKvAtqCJLU01A==
Date: Thu, 14 May 2026 10:45:00 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	aarsenovic@baylibre.com, dri-devel@lists.freedesktop.org, matthew.brost@intel.com, 
	thomas.hellstrom@linux.intel.com, jhubbard@nvidia.com, david@kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/memory: Fix spurious warning when unmapping
 device-private/exclusive pages
Message-ID: <agWYFd2H8baj_Six@lucifer>
References: <20260501065116.2057242-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260501065116.2057242-1-apopple@nvidia.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 540E318000C
X-Rspamd-Server: rspam04
X-Stat-Signature: finwizo366skp9xtgiiuquufpp4bu4i3
X-HE-Tag: 1778751904-344065
X-HE-Meta: U2FsdGVkX1/PnlZgSrHdXQCiS6mFJhXzmeq+oLHqQw9hcO/v0d8pyr0acI17hLiws5GD/gsM1k0Csbd/eowPaPwfdp1qUB1vidA6F4FJnuGZGmcPBznqtsN4Vm/vt4swnvFgD/SBPvxdp4GOVbTX5WUMonsT+MRLnrM+HH2D2JgC8dvuRzUZB/CNgTUxPIPRdmnq3sz3BxBu6Mj8S97gYgJ41cBrI3amGEIKMcRrY8hyEVAQWKVTLvwDgT/VdMP6jx8f0okDN0C6ww4JZGK8l+jgpG72gnOND/S9w5yMsDGhuoU7S5CKFn/Di2XUR7srHgmiQrKFlKf2VlJ8/dUmF6YxN746GIeN4wHkJhD1U7b/4TSkf9oRksAmPSdxlpg2Jr/9FLpataCzD6mo8CtcNUVCpTacv+DFIs9bHA15CRLXGG+0WrVYKTjBDDHjuYIH0xW3+IVVwlc/EB3H8Adhg6CNaO0IOmL/mZsUCrReO1ELhLX+4AcU1ot/LETwkcXeQQrLU1QZMtLw1cgIDMcbQPZv8Yp3WXoKisH7liQGIRXXgcfcoPgFmV8yhZIKkeMKje1njeEglL268dmlcUNTERFxqNCQqor8pAPRxaUZXfkOam+TZfe5utsIHqkwkIHOumM0EMkAvhAw+ctSA9R+PyLmqVNSgiFFHTlkZNd0kSOdoqa0JbJfpt7t231YlU/acZ0KkZagYa+pnMYdLNR0JGjwmdyyqTcerqlOHCQdDP+f9GGawiDL7+BMrSrLZUJQWhz1Oh10Q/EgKUtVYObEbsz7orw7xy0z8tuArWxeKoQoyOi4b4OVFRssxMSxuPPgHmAwZrEXVYM0203PUra11GkJ8rpu85zk9JJbBN785lx3kkfpmffCYx3r28a74h1M1MOpbpuSkZ9aoHa3KUhnFkegiuMtT7lNGuC+0UAD9byw/wggc2d4LX82r9lP6XpsZoI46VTzDNiYXag+R11
 n84bvKRs
 dk+REGQBXcCiIE49GPBr6BlaUG+Ffi8yJ1MirlfnX/CftZSwf7j75fGiTzT2wEupEqG0JRyMZIRNXQYe+d5wkNOlvbQgRQDrh0PN8bQRrC/9cLn4L5cQBmbOpxRHSLCmpmM2nEQUGvENxleCvAOFpeSbSER521C1aD3MyQazY+fZ//AoGQB4FXWxT6wy9QJYH09zliW/NO7JEiMNuG9qW5M7sUHsMhDbNObdKaBCP1sX/w0iYiVgZ9JN+udPQjGV2ihg3UShsBFgMUcAmmrVgB2BDxGwiiL2CBGjQ00BFytYgG3CmmsKxJ3bahkRZj046ASmeU/JwksI0wmLtpsYkFf5Nst5fcTetOmbsfVuLT8UusGjsquom4mvixEvWvehmdB5kAGIfRGky21qrAs3XkWTxl3/LzPArWZxu1Yl3n6BKnv4yrUgHFetkro0pqMvKchRB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 01, 2026 at 04:51:16PM +1000, Alistair Popple wrote:
> Device private and exclusive entries are only supported for anonymous
> folios. This condition is tested in __migrate_device_pages() and
> make_device_exclusive() using folio_test_anon(). However the unmap path
> tests this assumption using vma_is_anonymous().
>
> This is wrong because whilst anonymous VMAs can only contain folios
> where folio_test_anon() is true the opposite relation does not
> hold. A folio for which folio_test_anon() is true does not imply
> vma_is_anonymous() is true. Such a condition can occur if for example a
> folio is part of a private filebacked mapping.

Yes this is a classic case of anon _VMA_ vs. anon _folio_ :) and it's our good
friend MAP_PRIVATE file-backed mappings at play also.

>
> In this case vma_is_anonymous() is false as the mapping is filebacked,
> but folio_test_anon() may be true, thus permitting devices to migrate
> the folio to device private memory. This can lead to the following
> spurious warnings during process teardown:
>
> [  772.737706] ------------[ cut here ]------------
> [  772.739201] WARNING: mm/memory.c:1754 at unmap_page_range.cold+0x26/0x18a, CPU#17: hmm-tests/2041
> [  772.742050] Modules linked in: test_hmm nvidia_uvm(O) nvidia(O)
> [  772.743959] CPU: 17 UID: 0 PID: 2041 Comm: hmm-tests Tainted: G        W  O        7.0.0+ #387 PREEMPT(full)
> [  772.747104] Tainted: [W]=WARN, [O]=OOT_MODULE
> [  772.748509] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.17.0-0-gb52ca86e094d-prebuilt.qemu.org 04/01/2014
> [  772.752117] RIP: 0010:unmap_page_range.cold+0x26/0x18a
> [  772.753780] Code: 7e fe ff ff 48 89 4c 24 78 4c 89 44 24 38 e8 f2 ff b1 00 48 8b 4c 24 78 4c 8b 44 24 38 48 8b 44 24 18 48 83 78 48 00 74 04 90 <0f> 0b 90 48 89 ca b8 ff ff 37 00 48 c1 ea 03 48 c1 e0 2a 80 3c 02
> [  772.759602] RSP: 0018:ffff888112607550 EFLAGS: 00010286
> [  772.761310] RAX: ffff88811bbf4dc0 RBX: dffffc0000000000 RCX: ffffea03e9bfffd8
> [  772.763583] RDX: 1ffff1102377e9c1 RSI: 0000000000000008 RDI: ffff88811bbf4e08
> [  772.765914] RBP: 0000000000000006 R08: ffff8881059f7448 R09: ffffed10224c0e68
> [  772.768184] R10: ffff888112607347 R11: 0000000000000001 R12: 0000000000000001
> [  772.770461] R13: ffffea03e9bfffc0 R14: ffff888112607908 R15: ffffea03e9bfffc0
> [  772.772782] FS:  00007f327caa2780(0000) GS:ffff888427b7d000(0000) knlGS:0000000000000000
> [  772.775328] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  772.777187] CR2: 00007f327ca89000 CR3: 00000001994d5000 CR4: 00000000000006f0
> [  772.779135] Call Trace:
> [  772.779792]  <TASK>
> [  772.780317]  ? dmirror_interval_invalidate+0x1a3/0x290 [test_hmm]
> [  772.781873]  ? vm_normal_page_pud+0x2b0/0x2b0
> [  772.782992]  ? __rwlock_init+0x150/0x150
> [  772.784006]  ? lock_release+0x216/0x2b0
> [  772.785008]  ? __mmu_notifier_invalidate_range_start+0x505/0x6e0
> [  772.786522]  ? lock_release+0x216/0x2b0
> [  772.787498]  ? unmap_single_vma+0xb6/0x210
> [  772.788573]  unmap_vmas+0x27d/0x520
> [  772.789506]  ? unmap_single_vma+0x210/0x210
> [  772.790607]  ? mas_update_gap.part.0+0x620/0x620
> [  772.791834]  unmap_region+0x19e/0x350
> [  772.792769]  ? remove_vma+0x130/0x130
> [  772.793684]  ? mas_alloc_nodes+0x1f2/0x300
> [  772.794730]  vms_complete_munmap_vmas+0x8c1/0xe20
> [  772.795926]  ? unmap_region+0x350/0x350
> [  772.796917]  do_vmi_align_munmap+0x36a/0x4e0
> [  772.798018]  ? lock_release+0x216/0x2b0
> [  772.799024]  ? vma_shrink+0x620/0x620
> [  772.799983]  do_vmi_munmap+0x150/0x2c0
> [  772.800939]  __vm_munmap+0x161/0x2c0
> [  772.801872]  ? expand_downwards+0xd60/0xd60
> [  772.802948]  ? clockevents_program_event+0x1ef/0x540
> [  772.804217]  ? lock_release+0x216/0x2b0
> [  772.805158]  __x64_sys_munmap+0x59/0x80
> [  772.805776]  do_syscall_64+0xfc/0x670
> [  772.806336]  ? irqentry_exit+0xda/0x580
> [  772.806976]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
> [  772.807772] RIP: 0033:0x7f327cbb2717
> [  772.808323] Code: 73 01 c3 48 8b 0d f9 76 0d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 0b 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d c9 76 0d 00 f7 d8 64 89 01 48
> [  772.811337] RSP: 002b:00007ffde7f57d38 EFLAGS: 00000202 ORIG_RAX: 000000000000000b
> [  772.812564] RAX: ffffffffffffffda RBX: 00007f327cc9c000 RCX: 00007f327cbb2717
> [  772.813733] RDX: 0000000000000000 RSI: 0000000000400000 RDI: 00007f327c289000
> [  772.814867] RBP: 0000000000421360 R08: 000000000000001a R09: 0000000000000000
> [  772.815991] R10: 0000000000000003 R11: 0000000000000202 R12: 00007ffde7f57d74
> [  772.817121] R13: 00007f327c689010 R14: 0000000000100000 R15: 00007f327c289000
> [  772.818272]  </TASK>
> [  772.818614] irq event stamp: 0
> [  772.819159] hardirqs last  enabled at (0): [<0000000000000000>] 0x0
> [  772.820174] hardirqs last disabled at (0): [<ffffffff82a57ab3>] copy_process+0x19f3/0x6440
> [  772.821511] softirqs last  enabled at (0): [<ffffffff82a57b00>] copy_process+0x1a40/0x6440
> [  772.822869] softirqs last disabled at (0): [<0000000000000000>] 0x0
> [  772.823871] ---[ end trace 0000000000000000 ]---
>
> Fix this by using the same check for folio_test_anon() in
> zap_nonpresent_ptes(). Also add a hmm-test case for this.
>
> Signed-off-by: Alistair Popple <apopple@nvidia.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

> Reported-by: Arsen Arsenović <aarsenovic@baylibre.com>
> Fixes: 999dad824c39e ("mm/shmem: persist uffd-wp bit across zapping for file-backed")
> Cc: stable@vger.kernel.org
> ---
>  mm/memory.c                            |  2 +-
>  tools/testing/selftests/mm/hmm-tests.c | 50 ++++++++++++++++++++++++++
>  2 files changed, 51 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index c65e82c86fed..3f22a67a4d7f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1750,7 +1750,7 @@ static inline int zap_nonpresent_ptes(struct mmu_gather *tlb,
>  		 * consider uffd-wp bit when zap. For more information,
>  		 * see zap_install_uffd_wp_if_needed().
>  		 */
> -		WARN_ON_ONCE(!vma_is_anonymous(vma));

I actually wonder if we should rename this to vma_is_pure_anon() or something to
make it clearer. But that'd be quite some churn, even for me :)

> +		WARN_ON_ONCE(!folio_test_anon(folio));
>  		rss[mm_counter(folio)]--;
>  		folio_remove_rmap_pte(folio, page, vma);
>  		folio_put(folio);
> diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
> index e8328c89d855..eb860b5d6f85 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -1034,6 +1034,56 @@ TEST_F(hmm, migrate)
>  	hmm_buffer_free(buffer);
>  }
>
> +/*
> + * Migrate private file memory to device private memory.
> + */
> +TEST_F(hmm, migrate_file_private)
> +{
> +	struct hmm_buffer *buffer;
> +	unsigned long npages;
> +	unsigned long size;
> +	unsigned long i;
> +	int *ptr;
> +	int ret;
> +	int fd;
> +
> +	npages = ALIGN(HMM_BUFFER_SIZE, self->page_size) >> self->page_shift;
> +	ASSERT_NE(npages, 0);
> +	size = npages << self->page_shift;
> +
> +	fd = hmm_create_file(size);
> +	ASSERT_GE(fd, 0);
> +
> +	buffer = malloc(sizeof(*buffer));
> +	ASSERT_NE(buffer, NULL);
> +
> +	buffer->fd = fd;
> +	buffer->size = size;
> +	buffer->mirror = malloc(size);
> +	ASSERT_NE(buffer->mirror, NULL);
> +
> +	buffer->ptr = mmap(NULL, size,
> +			   PROT_READ | PROT_WRITE,
> +			   MAP_PRIVATE,
> +			   buffer->fd, 0);
> +	ASSERT_NE(buffer->ptr, MAP_FAILED);
> +
> +	/* Initialize buffer in system memory. */
> +	for (i = 0, ptr = buffer->ptr; i < size / sizeof(*ptr); ++i)
> +		ptr[i] = i;
> +
> +	/* Migrate memory to device. */
> +	ret = hmm_migrate_sys_to_dev(self->fd, buffer, npages);
> +	ASSERT_EQ(ret, 0);
> +	ASSERT_EQ(buffer->cpages, npages);
> +
> +	/* Check what the device read. */
> +	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
> +		ASSERT_EQ(ptr[i], i);
> +
> +	hmm_buffer_free(buffer);
> +}
> +
>  /*
>   * Migrate anonymous memory to device private memory and fault some of it back
>   * to system memory, then try migrating the resulting mix of system and device
> --
> 2.54.0
>
>
>

