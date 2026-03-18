Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9709103E195
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 15:05:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15FED6B026C; Wed, 18 Mar 2026 11:05:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111AD6B026E; Wed, 18 Mar 2026 11:05:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 026926B026F; Wed, 18 Mar 2026 11:05:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E0FE06B026C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:05:40 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4CBB61607FA
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:05:40 +0000 (UTC)
X-FDA: 84559508040.28.D31D5C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 83A6D1C0019
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 15:05:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i0FiVqMn;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773846338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A+mPOv44cn20MbMO3nwiA/pGyDxNpzpqLiZdaFl+Slk=;
	b=5x7tswbx0Mkthl2ImNTzRMeirFva5AyLVRdM55JMnCHU+c4lAwVjY2v/f2og1VRsSV8GTJ
	MrJzZ3TfUZzI2eqVYFE2mrQteh+jCIlQh3ImAszFkrmxNG2ph/JPmljqcRRW+KFdIL/tUm
	ZtAHQIYN5svVdfH2E/vbQvlvKbei4dM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773846338; a=rsa-sha256;
	cv=none;
	b=8D3YKxSSrchMCeyMlaB+haCBGJzVytSwb5ok81GjIiPmvuXqDz6dOPzV4w8n24VPWQDkCS
	3RU8AjRHIJ+UfsllO4AaH+VH6fD/udQ2JvKrh2Jg8M89MSQfE1R+FooFcwqul/sL3Tvn9W
	pHjEZgH4dTOEVdBaSeOy8z7XdytYti8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i0FiVqMn;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 40C0D434F1;
	Wed, 18 Mar 2026 15:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57ADDC19421;
	Wed, 18 Mar 2026 15:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773846337;
	bh=+RkusO5tORcNLy97IFZ2zGptLBs0NF+ENbJvxHQgkus=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=i0FiVqMnbCcGHRSh1pmKaoeXTS0DSpeVIYPP5DreYtlOv6HxPpyiiH9LGjABHz47V
	 IbQHo9TBzbF9bOKaWrMF4q/sR795bYcMbcDMOAibc1FsI2yHhT1mcPpTlx7q4yhWJZ
	 9VkR7QHUsvdIhto1ZrZcQca3OzIgCPKMMnYEaRiHTKrrBm00i2qRSWWVjKfxVJR1a8
	 sIwf1JtJ3x6nWcxQngVFXYAT/5nAZz0FdkysUCOW2XckA2isnA6cjrDt++ieMOL+IU
	 Nl4bN/z1X9UzO5k4L/PmDCiDuZ6uSYb8xOLBEJvMTDXVcW68noOESN9L4mf/vRNRIo
	 nU3xlm61ovKHQ==
Date: Wed, 18 Mar 2026 15:05:31 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, jgg@ziepe.ca, 
	leon@kernel.org, akpm@linux-foundation.org, david@kernel.org, 
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com
Subject: Re: running mm/ksft_hmm.sh on arm64 results in a kernel panic
Message-ID: <3f58a6f6-bf26-4c6c-8bc4-c05264ad0cc3@lucifer.local>
References: <8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83A6D1C0019
X-Stat-Signature: fs5ec33do4bbtzgpx7q16dsqzogykdmp
X-Rspam-User: 
X-HE-Tag: 1773846338-123781
X-HE-Meta: U2FsdGVkX19dTHSUEx039SUDJ6r2rSjF5idruLUFo/cuMSLbvEjf7YWrGQ7P+lFChvU8VMR2gBGzTao7mm3eQp8Z6e6gP/edIZeOdxk3SjyvC5ntLa0wvLS1/J3mHNarOUcx2EA2MWMA3K4eA2s9hb4jEUUfeRgdg7A+XYJUNKCTMsLyxUZBmgQrcuUDh8j0uQRxSHqImCewl3ce9s+ezLts4ODHJJxvsBZkQq9vGyP5s7daskIayJXFndn7f4UEyUhk7rWQ52Lgih3VgxILTDnI9oiuoGey/2Z/MaApEP4DS0ScYkZURNnSyF9D84YYAQj7wsX8H3CmsuKUL1fLjnnx7g07JyqZGMvJgERbk7OnZUZDKJDF5TH00Lm6dYHRXw9PtpFeCHxgwgxzxAXB7F04uWikfVnYaoy727vGuBpKFTN0svI2+QaQDlTzZXSECmdN78s0bkAF9ruRGOHchIn+XdJD/s9iloGiLtLLFSnfYF5xfsa9R+M4NWaDTUwndn7FfjSNBeArr/gU0ibMtQX23etvQhxtlgCDOPT+HseKUJ/LLvFqETTW4+ZUNFKLNPE1ISq40ZFG4aIloqVP2DLabqjxunoUwRW4kKu+rY8Cz2VO6yTP17OhRs7RLYJptP5v5C19xtf1JADEQVPATi17VMZIf3KbRsgnFBi0/o26ShIBFUazJOKvp4mwPPJ6o2RV2iGj02s3uEvzrl6Ifa1uPu1yB6/vVCuzT9VCXVHatcqO0OtUjl5zSg8l1Pgz1JvRdtLrXlItZPVThUmu2WAx1ZhkXC5V57GYPbbI35Ea32CufU1G46RZLSW0krNhxib7FrRfOoU4WS+4OQaYjDj+EkX9MENAm0sVEP0spocwsOqOr9KpGIGcJfEf7YJAU/ohrW+ft7pYgkn9RUaLU+L/25BVTfA7tb+YNkgphiQ2JkDi2qrCtSIRMQjpQ3qYxKEr3sA+MrkB9NFL9fV
 kk+xV2qf
 aHdg7Jwgr6VAk481bbUthb/LBTbqgOkpgtB1Rzw22+wyV+SwqYsR1MNoVi8Y5MKVXTykNLbDgtjx/VoNVzYFTBAyjn4rqMBToWAdq1MmDfhp1Q+5Wu4MwzCT6mIRa/D35Bci6o0YbHymi5H4i10M0ifBW5p2+riQqK5mMMiYZblmqziZuIHdVgXnBSuSDpNTCPXdVzhbUdr2WiaEKrvCCsoYj1i56pEqQ0l4WqEwBclAUTpnGbQkOmpbPg16GDxAqFmJEllSgDnhzCi6YRxgFiQBSX7fki9kJzk5+OJQWjOla5kzyIvWzonhkUtyrvbWii9YX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 01:26:39PM +0800, Zenghui Yu wrote:
> Hi all,
>
> When running mm/ksft_hmm.sh in my arm64 virtual machine, I ran into the
> following kernel panic:
>
> [root@localhost mm]# ./ksft_hmm.sh
> TAP version 13
> # --------------------------------
> # running bash ./test_hmm.sh smoke
> # --------------------------------
> # Running smoke test. Note, this test provides basic coverage.
> # TAP version 13
> # 1..74
> # # Starting 74 tests from 4 test cases.
> # #  RUN           hmm.hmm_device_private.benchmark_thp_migration ...
> #
> # HMM THP Migration Benchmark
> # ---------------------------
> # System page size: 16384 bytes
> #
> # === Small Buffer (512KB) (0.5 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 0.423 ms        | 0.182 ms        | -133.0%
> # Dev->Sys Migration   | 0.027 ms        | 0.025 ms        | -7.0%
> # S->D Throughput      | 1.15 GB/s      | 2.69 GB/s      | -57.1%
> # D->S Throughput      | 18.12 GB/s      | 19.38 GB/s      | -6.5%
> #
> # === Half THP Size (1MB) (1.0 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 0.367 ms        | 1.187 ms        | 69.0%
> # Dev->Sys Migration   | 0.048 ms        | 0.049 ms        | 2.2%
> # S->D Throughput      | 2.66 GB/s      | 0.82 GB/s      | 222.9%
> # D->S Throughput      | 20.53 GB/s      | 20.08 GB/s      | 2.3%
> #
> # === Single THP Size (2MB) (2.0 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 0.817 ms        | 0.782 ms        | -4.4%
> # Dev->Sys Migration   | 0.089 ms        | 0.096 ms        | 7.1%
> # S->D Throughput      | 2.39 GB/s      | 2.50 GB/s      | -4.2%
> # D->S Throughput      | 22.00 GB/s      | 20.44 GB/s      | 7.6%
> #
> # === Two THP Size (4MB) (4.0 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 3.419 ms        | 2.337 ms        | -46.3%
> # Dev->Sys Migration   | 0.321 ms        | 0.225 ms        | -42.6%
> # S->D Throughput      | 1.14 GB/s      | 1.67 GB/s      | -31.6%
> # D->S Throughput      | 12.17 GB/s      | 17.36 GB/s      | -29.9%
> #
> # === Four THP Size (8MB) (8.0 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 4.535 ms        | 4.563 ms        | 0.6%
> # Dev->Sys Migration   | 0.583 ms        | 0.582 ms        | -0.2%
> # S->D Throughput      | 1.72 GB/s      | 1.71 GB/s      | 0.6%
> # D->S Throughput      | 13.39 GB/s      | 13.43 GB/s      | -0.2%
> #
> # === Eight THP Size (16MB) (16.0 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 10.190 ms        | 9.805 ms        | -3.9%
> # Dev->Sys Migration   | 1.130 ms        | 1.195 ms        | 5.5%
> # S->D Throughput      | 1.53 GB/s      | 1.59 GB/s      | -3.8%
> # D->S Throughput      | 13.83 GB/s      | 13.07 GB/s      | 5.8%
> #
> # === One twenty eight THP Size (256MB) (256.0 MB) ===
> #                      | With THP        | Without THP     | Improvement
> # ---------------------------------------------------------------------
> # Sys->Dev Migration   | 80.464 ms        | 92.764 ms        | 13.3%
> # Dev->Sys Migration   | 9.528 ms        | 18.166 ms        | 47.6%
> # S->D Throughput      | 3.11 GB/s      | 2.70 GB/s      | 15.3%
> # D->S Throughput      | 26.24 GB/s      | 13.76 GB/s      | 90.7%
> # #            OK  hmm.hmm_device_private.benchmark_thp_migration
> # ok 1 hmm.hmm_device_private.benchmark_thp_migration
> # #  RUN           hmm.hmm_device_private.migrate_anon_huge_zero_err ...
> # # hmm-tests.c:2622:migrate_anon_huge_zero_err:Expected ret (-2) == 0 (0)
>
> [  154.077143] Unable to handle kernel paging request at virtual address
> 0000000000005268
> [  154.077179] Mem abort info:
> [  154.077203]   ESR = 0x0000000096000007
> [  154.077219]   EC = 0x25: DABT (current EL), IL = 32 bits
> [  154.078433]   SET = 0, FnV = 0
> [  154.078434]   EA = 0, S1PTW = 0
> [  154.078435]   FSC = 0x07: level 3 translation fault
> [  154.078435] Data abort info:
> [  154.078436]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
> [  154.078459]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
> [  154.078479]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
> [  154.078484] user pgtable: 16k pages, 47-bit VAs, pgdp=000000010b920000
> [  154.078487] [0000000000005268] pgd=0800000101b4c403,
> p4d=0800000101b4c403, pud=0800000101b4c403, pmd=0800000108cd8403,
> pte=0000000000000000
> [  154.078520] Internal error: Oops: 0000000096000007 [#1]  SMP
> [  154.098664] Modules linked in: test_hmm rfkill drm fuse backlight ipv6
> [  154.100468] CPU: 7 UID: 0 PID: 1357 Comm: hmm-tests Kdump: loaded Not
> tainted 7.0.0-rc4-00029-ga989fde763f4-dirty #260 PREEMPT
> [  154.103855] Hardware name: QEMU QEMU Virtual Machine, BIOS
> edk2-stable202408-prebuilt.qemu.org 08/13/2024
> [  154.104409] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS
> BTYPE=--)
> [  154.104847] pc : dmirror_devmem_fault+0xe4/0x1c0 [test_hmm]
> [  154.105758] lr : dmirror_devmem_fault+0xcc/0x1c0 [test_hmm]
> [  154.109465] sp : ffffc000855ab430
> [  154.109677] x29: ffffc000855ab430 x28: ffff8000c9f73e40 x27:
> ffff8000c9f73e40
> [  154.110091] x26: ffff8000cb920000 x25: ffffc000812e0000 x24:
> 0000000000000000
> [  154.110540] x23: ffff8000c9f73e40 x22: 0000000000000000 x21:
> 0000000000000008
> [  154.110888] x20: ffff8000c07e1980 x19: ffffc000855ab618 x18:
> ffffc000855abc40
> [  154.111223] x17: 0000000000000000 x16: 0000000000000000 x15:
> 0000000000000000
> [  154.111563] x14: 0000000000000000 x13: 0000000000000000 x12:
> ffffc00080fedd68
> [  154.111903] x11: 00007fffa3bf7fff x10: 0000000000000000 x9 :
> 1ffff00019166a41
> [  154.112244] x8 : ffff8000c132df20 x7 : 0000000000000000 x6 :
> ffff8000c53bfe88
> [  154.112581] x5 : 0000000000000009 x4 : ffffc000855ab3d0 x3 :
> 0000000000000004
> [  154.112921] x2 : 0000000000000004 x1 : ffff8000c132df18 x0 :
> 0000000000005200
> [  154.113254] Call trace:
> [  154.113370]  dmirror_devmem_fault+0xe4/0x1c0 [test_hmm] (P)
> [  154.113679]  do_swap_page+0x132c/0x17b0
> [  154.113912]  __handle_mm_fault+0x7e4/0x1af4
> [  154.114124]  handle_mm_fault+0xb4/0x294
> [  154.114398]  __get_user_pages+0x210/0xbfc
> [  154.114607]  get_dump_page+0xd8/0x144
> [  154.114795]  dump_user_range+0x70/0x2e8
> [  154.115020]  elf_core_dump+0xb64/0xe40
> [  154.115212]  vfs_coredump+0xfb4/0x1ce8
> [  154.115397]  get_signal+0x6cc/0x844
> [  154.115582]  arch_do_signal_or_restart+0x7c/0x33c
> [  154.115805]  exit_to_user_mode_loop+0x104/0x16c
> [  154.116030]  el0_svc+0x174/0x178
> [  154.116216]  el0t_64_sync_handler+0xa0/0xe4
> [  154.116414]  el0t_64_sync+0x198/0x19c
> [  154.116594] Code: d2800083 f9400280 f9003be0 2a0303e2 (b9406800)
> [  154.116891] ---[ end trace 0000000000000000 ]---
> [  158.741771] Kernel panic - not syncing: Oops: Fatal exception
> [  158.742164] SMP: stopping secondary CPUs
> [  158.742970] Kernel Offset: disabled
> [  158.743162] CPU features: 0x0000000,00060005,11210501,94067723
> [  158.743440] Memory Limit: none
> [  164.002089] Starting crashdump kernel...
> [  164.002867] Bye!

That 'Bye!' is delightful :)

>
> [root@localhost linux]# ./scripts/faddr2line lib/test_hmm.ko
> dmirror_devmem_fault+0xe4/0x1c0
> dmirror_devmem_fault+0xe4/0x1c0:
> dmirror_select_device at /root/code/linux/lib/test_hmm.c:153
> (inlined by) dmirror_devmem_fault at /root/code/linux/lib/test_hmm.c:1659
>
> The kernel is built with arm64's virt.config plus
>
> +CONFIG_ARM64_16K_PAGES=y
> +CONFIG_ZONE_DEVICE=y
> +CONFIG_DEVICE_PRIVATE=y
> +CONFIG_TEST_HMM=m
>
> I *guess* the problem is that migrate_anon_huge_zero_err() has chosen an
> incorrect THP size (which should be 32M in a system with 16k page size),

Yeah, it hardcodes to 2mb:

TEST_F(hmm, migrate_anon_huge_zero_err)
{
	...

	size = TWOMEG;
}

Which isn't correct obviously and needs to be fixed.

We should read /sys/kernel/mm/transparent_hugepage/hpage_pmd_size instead.

vm_utils.h has read_pmd_pagesize() So this can be fixed with:

	size = read_pmd_pagesize();

We then madvise(.., MADV_HUGEPAGE) region of size, which is now too small.:

TEST_F(hmm, migrate_anon_huge_zero_err)
{
	...

	size = TWOMEG;

	...

	ret = madvise(map, size, MADV_HUGEPAGE);
	ASSERT_EQ(ret, 0); <-- but should succeed anyway, just won't do anything

	...

	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
}

Then we switch into lib/test_hmm.c:

static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
					   struct dmirror *dmirror)
{
	...

	for (addr = args->start; addr < args->end; ) {
		...

		if (dmirror->flags & HMM_DMIRROR_FLAG_FAIL_ALLOC) {
			dmirror->flags &= ~HMM_DMIRROR_FLAG_FAIL_ALLOC;
			dpage = NULL;  <-- force failure for 1st page

	...

		if (!dpage) {
			...

			if (!is_large) <-- isn't large, as MADV_HUGEPAGE failed
				goto next;

	...
next:
		src++;
		dst++;
		addr += PAGE_SIZE;
	}
}

Back to the hmm-tests.c selftest:

TEST_F(hmm, migrate_anon_huge_zero_err)
{
	...

	ret = hmm_dmirror_cmd(self->fd, HMM_DMIRROR_FLAGS, buffer,
			      HMM_DMIRROR_FLAG_FAIL_ALLOC);
	ASSERT_EQ(ret, 0);                  <-- succeeds but...
	ASSERT_EQ(buffer->cpages, npages);  <-- cpages = npages - 1.
}

So then we try to teardown which inokves:

FIXTURE_TEARDOWN(hmm)
{
	int ret = close(self->fd);  <-- triggers kernel dmirror_fops_release()
	...
}

In the kernel:

static int dmirror_fops_release(struct inode *inode, struct file *filp)
{
	struct dmirror *dmirror = filp->private_data;
	...

	kfree(dmirror);  <-- frees dmirror...
	return 0;
}

So dmirror is fred but in dmirror_migrate_alloc_and_copy(), for all those pages
we DID migrate:

static void dmirror_migrate_alloc_and_copy(struct migrate_vma *args,
					   struct dmirror *dmirror)
{
	...

	for (addr = args->start; addr < args->end; ) {
		...

		if (!dpage) { <-- we will succeed allocation so don't branch.
			...
		}

		rpage = BACKING_PAGE(dpage);

		/*
		 * Normally, a device would use the page->zone_device_data to
		 * point to the mirror but here we use it to hold the page for
		 * the simulated device memory and that page holds the pointer
		 * to the mirror.
		 */
		rpage->zone_device_data = dmirror;

		...
	}

	...
}

So now a bunch of device private pages have a zone_device_data set to a dangling
dmirror pointer.

Then on coredump, we walk the VMAs, meaning we fault in device private pages and
end up invoking do_swap_page() which in turn calls dmirror_devmem_fault() (via
the struct dev_pagemap_ops
dmirror_devmem_ops->migrate_to_ram=dmirror_devmem_fault callback)

This is via get_dump_page() -> __get_user_pages_locked(..., FOLL_FORCE |
FOLL_DUMP | FOLL_GET) -> __get_user_pages() -> handle_mm_fault() ->
__handle_mm_fault() -> do_swap_page() and:

vm_fault_t do_swap_page(struct vm_fault *vmf)
{
	...
		entry = softleaf_from_pte(vmf->orig_pte);
	if (unlikely(!softleaf_is_swap(entry))) {
		if (softleaf_is_migration(entry)) {
			...
		} else if (softleaf_is_device_private(entry)) {
			...

			if (trylock_page(vmf->page)) {
				...

				ret = pgmap->ops->migrate_to_ram(vmf);

				...
			}

			...
		}

		...
	}

	...
}

(BTW, we seriously need to clean this up).

And in dmirror_devmem_fault callback():

static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
{
	...

	/*
	 * Normally, a device would use the page->zone_device_data to point to
	 * the mirror but here we use it to hold the page for the simulated
	 * device memory and that page holds the pointer to the mirror.
	 */
	rpage = folio_zone_device_data(page_folio(vmf->page));
	dmirror = rpage->zone_device_data;

	...

	args.pgmap_owner = dmirror->mdevice; <-- oops

	...
}

So in terms of fixing:

1. Fix the test (trivial)

Use

	size = read_pmd_pagesize();

Instead of:

	size = TWOMEG;

2. Have dmirror_fops_release() migrate all the device private pages back to ram
   before freeing dmirror or something like this

You'd want to abstract code from dmirror_migrate_to_system() to be shared
between the two functions I think.

But I leave that as an exercise for the reader :)

> leading to the failure of the first hmm_migrate_sys_to_dev(). The test
> program received a SIGABRT signal and initiated vfs_coredump(). And
> something in the test_hmm module doesn't play well with the coredump
> process, which ends up with a panic. I'm not familiar with that.
>
> Note that I can also reproduce the panic by aborting the test manually
> with following diff (and skipping migrate_anon_huge{,_zero}_err()):
>
> diff --git a/tools/testing/selftests/mm/hmm-tests.c
> b/tools/testing/selftests/mm/hmm-tests.c
> index e8328c89d855..8d8ea8063a73 100644
> --- a/tools/testing/selftests/mm/hmm-tests.c
> +++ b/tools/testing/selftests/mm/hmm-tests.c
> @@ -1027,6 +1027,8 @@ TEST_F(hmm, migrate)
>  	ASSERT_EQ(ret, 0);
>  	ASSERT_EQ(buffer->cpages, npages);
>
> +	ASSERT_TRUE(0);

This makes sense as the same dangling dmirror pointer issue arises.

> +
>  	/* Check what the device read. */
>  	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
>  		ASSERT_EQ(ptr[i], i);
>
> Please have a look!

Hopefully did so usefully here :)

>
> Thanks,
> Zenghui

Cheers, Lorenzo

