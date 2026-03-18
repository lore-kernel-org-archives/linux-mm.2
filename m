Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B520FCD0AE
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 05:26:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91BD66B00EC; Wed, 18 Mar 2026 01:26:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CCAC6B00ED; Wed, 18 Mar 2026 01:26:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E29B6B00EE; Wed, 18 Mar 2026 01:26:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B7F36B00EC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 01:26:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A2E9F13B234
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:26:54 +0000 (UTC)
X-FDA: 84558049548.29.F70424F
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id CE5574000A
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 05:26:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AgcAb+ih;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773811613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Z4amKDNTYd95vquDsXEN0iZpe11i0wN2Sp8KnGkFtCE=;
	b=QKpHbHiGj8yHRgzYKmUCHgWTPYStMmUN85N2H7I10yprdZJeOVknE8cNa0xseaSf5qv0bb
	wHfA7C0+9aiNG9oqkN/hSghd4alVL+QfDNTuUTNBg8pv+l1Z7nFUMSN+wDtN/qggToPLqk
	96cs9I5Hx78KDAcgmkta7++2Gs67GUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773811613; a=rsa-sha256;
	cv=none;
	b=LHiQzrEX3kBhhG4g6wFcPiKyNUNAgbUxpIUhwqiSn3aEMzrFi6qaOF73/f5f37swD/ZnlG
	xmk2XAjlh1xbmeBxCNzWi+RUR+EL+NCVNUM7kT9fByc6y9f1L3mtBEFBr6VU+lcG/xuNM3
	Vj3ofe6sY+EHXM5y2eYuSDN/U5Dz8X0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AgcAb+ih;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
Message-ID: <8bd0396a-8997-4d2e-a13f-5aac033083d7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773811610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Z4amKDNTYd95vquDsXEN0iZpe11i0wN2Sp8KnGkFtCE=;
	b=AgcAb+ih8Bt20XGQZ3JD8GSpVg3oPLc5aYOIv89KXtIZOdjLPO48xNrmqSTLbc0mAdDRug
	yIabSPw5sFeU/e1IqRZljvKBLXZBCD+gUYatMGXKQYyhV5NDZNj/UstSCsDR73Ik/004n8
	4KBzbxk90jFQ3xDwaG2C9D36BPJ2BZs=
Date: Wed, 18 Mar 2026 13:26:39 +0800
MIME-Version: 1.0
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
Content-Language: en-US
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: jgg@ziepe.ca, leon@kernel.org, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Subject: running mm/ksft_hmm.sh on arm64 results in a kernel panic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE5574000A
X-Stat-Signature: kbrqffnri478z5prgcimni1z5iozpxy5
X-Rspam-User: 
X-HE-Tag: 1773811612-758123
X-HE-Meta: U2FsdGVkX18j/aSQBvRyNftmqJPUscXwINQ8zfBesTS4xMeSQMgjE0ai5SX63jfvQNa13sHjrsp03oG3VA4cAjiIE+UXr/e1EG3+TKSEbRnm2GZkd31QOvzUuhOpJcUTjeGUMmCKFpbGjXEesul5oLNEklJhCFAwGA2elyRdXxuLLeG5cp7lzd+/Q0Vmmn0LLn0tc8W24+V2K1Bft2HxIyRP+1p8xS7sHn1sNWwgqamcNl1Yvr2uHi8lrYCwRDpSMeYEGFa1tMj9wqA+cBz0gSqxsSBaeTf42Yd2ep48K7HhLKtuTe6ERvuxLMyCKX3E5r6PPxamzoG22Vv2Fj5JJqGexaKm4ypVweGgIlWN2HLt3syUCvY4Y0H1Msn+MHxOYzuTgq2klnLFt6c4kiw5tWLPmBzbwi4QHeMf9kF5QONKqxexyBqib5F4OMCbwJDVqrHMvfu7HA8m+w9XKzROvzoYBR3TGJEAsHL1n0IiAoecxy6wD98nqCPRczWk9lFiNmGZPxgINTo6zhys+olpT1dzYtGIOTSpws8iMozJ17n2ccQYpeZ0LwJ5+qWH/7W8mMDSoga928xptkb5mBIBzjw9V/2TTrAcx22kI71C7/mO5NruNA9x/FDI2Sea7psQVz9d0qNB/yjpayV+iktfQS0Jw2goD+T6iDeq/K8LnIwpCosuxjvj5nf79kE3jQtea8+K7yFfqwKYK0rVsfu9SpwAGWz6XVpcfezxGSsrPWdxFsBtBUbwFali+kFa9aVkF11lrnv7k02rsNaQH5sUB6T0jFc3rIDA88l7bhl0+7v2GiuxcE88r/bFRoMC99ufh3gB7rtFLDrSQiH0C8ZYdSQR5s9+fNMSh3hZvVEYggI9axJ76/lVhYK4Xu0qqAVeKNGw5X0r0QS4wr6v6BSoMCfJhjVx1AOE/iaPMN+/qxMxOtmaj/8+1rQ9vQXabBMx44dtr8XGj4WVyR77n3y
 wdA5quTJ
 9c6qSAnIsDPhGsIdlgZfyAojhnhq0GWCkE3cpEzW4KNLHFyI+MWERRFQpwua5fl3FkW1pGOjDx1/eymv87W1mmMsovSKL5RJaIc995Xs9CNcMGnMUIh9KEBFED3CVdWFTY88VNahSM7OYQ456Who/+Ga7IwkcZfLfpsCWeH3IJXU+qnN2lu08+ULz9LXK2+C4VpF2Hw1L4ubMxajeKvkte2jQfVwzedi132YF+J0Om6GTvl75XUTDSkGSSZ31NKxueZbPe4djk1Ki2qFYtd8DAQiY8Hojr0ELz3MZoG81ruloEqTnmhuM/DscsD7VwPLpdb54
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

When running mm/ksft_hmm.sh in my arm64 virtual machine, I ran into the
following kernel panic:

[root@localhost mm]# ./ksft_hmm.sh
TAP version 13
# --------------------------------
# running bash ./test_hmm.sh smoke
# --------------------------------
# Running smoke test. Note, this test provides basic coverage.
# TAP version 13
# 1..74
# # Starting 74 tests from 4 test cases.
# #  RUN           hmm.hmm_device_private.benchmark_thp_migration ...
#
# HMM THP Migration Benchmark
# ---------------------------
# System page size: 16384 bytes
#
# === Small Buffer (512KB) (0.5 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 0.423 ms        | 0.182 ms        | -133.0%
# Dev->Sys Migration   | 0.027 ms        | 0.025 ms        | -7.0%
# S->D Throughput      | 1.15 GB/s      | 2.69 GB/s      | -57.1%
# D->S Throughput      | 18.12 GB/s      | 19.38 GB/s      | -6.5%
#
# === Half THP Size (1MB) (1.0 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 0.367 ms        | 1.187 ms        | 69.0%
# Dev->Sys Migration   | 0.048 ms        | 0.049 ms        | 2.2%
# S->D Throughput      | 2.66 GB/s      | 0.82 GB/s      | 222.9%
# D->S Throughput      | 20.53 GB/s      | 20.08 GB/s      | 2.3%
#
# === Single THP Size (2MB) (2.0 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 0.817 ms        | 0.782 ms        | -4.4%
# Dev->Sys Migration   | 0.089 ms        | 0.096 ms        | 7.1%
# S->D Throughput      | 2.39 GB/s      | 2.50 GB/s      | -4.2%
# D->S Throughput      | 22.00 GB/s      | 20.44 GB/s      | 7.6%
#
# === Two THP Size (4MB) (4.0 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 3.419 ms        | 2.337 ms        | -46.3%
# Dev->Sys Migration   | 0.321 ms        | 0.225 ms        | -42.6%
# S->D Throughput      | 1.14 GB/s      | 1.67 GB/s      | -31.6%
# D->S Throughput      | 12.17 GB/s      | 17.36 GB/s      | -29.9%
#
# === Four THP Size (8MB) (8.0 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 4.535 ms        | 4.563 ms        | 0.6%
# Dev->Sys Migration   | 0.583 ms        | 0.582 ms        | -0.2%
# S->D Throughput      | 1.72 GB/s      | 1.71 GB/s      | 0.6%
# D->S Throughput      | 13.39 GB/s      | 13.43 GB/s      | -0.2%
#
# === Eight THP Size (16MB) (16.0 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 10.190 ms        | 9.805 ms        | -3.9%
# Dev->Sys Migration   | 1.130 ms        | 1.195 ms        | 5.5%
# S->D Throughput      | 1.53 GB/s      | 1.59 GB/s      | -3.8%
# D->S Throughput      | 13.83 GB/s      | 13.07 GB/s      | 5.8%
#
# === One twenty eight THP Size (256MB) (256.0 MB) ===
#                      | With THP        | Without THP     | Improvement
# ---------------------------------------------------------------------
# Sys->Dev Migration   | 80.464 ms        | 92.764 ms        | 13.3%
# Dev->Sys Migration   | 9.528 ms        | 18.166 ms        | 47.6%
# S->D Throughput      | 3.11 GB/s      | 2.70 GB/s      | 15.3%
# D->S Throughput      | 26.24 GB/s      | 13.76 GB/s      | 90.7%
# #            OK  hmm.hmm_device_private.benchmark_thp_migration
# ok 1 hmm.hmm_device_private.benchmark_thp_migration
# #  RUN           hmm.hmm_device_private.migrate_anon_huge_zero_err ...
# # hmm-tests.c:2622:migrate_anon_huge_zero_err:Expected ret (-2) == 0 (0)

[  154.077143] Unable to handle kernel paging request at virtual address
0000000000005268
[  154.077179] Mem abort info:
[  154.077203]   ESR = 0x0000000096000007
[  154.077219]   EC = 0x25: DABT (current EL), IL = 32 bits
[  154.078433]   SET = 0, FnV = 0
[  154.078434]   EA = 0, S1PTW = 0
[  154.078435]   FSC = 0x07: level 3 translation fault
[  154.078435] Data abort info:
[  154.078436]   ISV = 0, ISS = 0x00000007, ISS2 = 0x00000000
[  154.078459]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  154.078479]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  154.078484] user pgtable: 16k pages, 47-bit VAs, pgdp=000000010b920000
[  154.078487] [0000000000005268] pgd=0800000101b4c403,
p4d=0800000101b4c403, pud=0800000101b4c403, pmd=0800000108cd8403,
pte=0000000000000000
[  154.078520] Internal error: Oops: 0000000096000007 [#1]  SMP
[  154.098664] Modules linked in: test_hmm rfkill drm fuse backlight ipv6
[  154.100468] CPU: 7 UID: 0 PID: 1357 Comm: hmm-tests Kdump: loaded Not
tainted 7.0.0-rc4-00029-ga989fde763f4-dirty #260 PREEMPT
[  154.103855] Hardware name: QEMU QEMU Virtual Machine, BIOS
edk2-stable202408-prebuilt.qemu.org 08/13/2024
[  154.104409] pstate: 61400005 (nZCv daif +PAN -UAO -TCO +DIT -SSBS
BTYPE=--)
[  154.104847] pc : dmirror_devmem_fault+0xe4/0x1c0 [test_hmm]
[  154.105758] lr : dmirror_devmem_fault+0xcc/0x1c0 [test_hmm]
[  154.109465] sp : ffffc000855ab430
[  154.109677] x29: ffffc000855ab430 x28: ffff8000c9f73e40 x27:
ffff8000c9f73e40
[  154.110091] x26: ffff8000cb920000 x25: ffffc000812e0000 x24:
0000000000000000
[  154.110540] x23: ffff8000c9f73e40 x22: 0000000000000000 x21:
0000000000000008
[  154.110888] x20: ffff8000c07e1980 x19: ffffc000855ab618 x18:
ffffc000855abc40
[  154.111223] x17: 0000000000000000 x16: 0000000000000000 x15:
0000000000000000
[  154.111563] x14: 0000000000000000 x13: 0000000000000000 x12:
ffffc00080fedd68
[  154.111903] x11: 00007fffa3bf7fff x10: 0000000000000000 x9 :
1ffff00019166a41
[  154.112244] x8 : ffff8000c132df20 x7 : 0000000000000000 x6 :
ffff8000c53bfe88
[  154.112581] x5 : 0000000000000009 x4 : ffffc000855ab3d0 x3 :
0000000000000004
[  154.112921] x2 : 0000000000000004 x1 : ffff8000c132df18 x0 :
0000000000005200
[  154.113254] Call trace:
[  154.113370]  dmirror_devmem_fault+0xe4/0x1c0 [test_hmm] (P)
[  154.113679]  do_swap_page+0x132c/0x17b0
[  154.113912]  __handle_mm_fault+0x7e4/0x1af4
[  154.114124]  handle_mm_fault+0xb4/0x294
[  154.114398]  __get_user_pages+0x210/0xbfc
[  154.114607]  get_dump_page+0xd8/0x144
[  154.114795]  dump_user_range+0x70/0x2e8
[  154.115020]  elf_core_dump+0xb64/0xe40
[  154.115212]  vfs_coredump+0xfb4/0x1ce8
[  154.115397]  get_signal+0x6cc/0x844
[  154.115582]  arch_do_signal_or_restart+0x7c/0x33c
[  154.115805]  exit_to_user_mode_loop+0x104/0x16c
[  154.116030]  el0_svc+0x174/0x178
[  154.116216]  el0t_64_sync_handler+0xa0/0xe4
[  154.116414]  el0t_64_sync+0x198/0x19c
[  154.116594] Code: d2800083 f9400280 f9003be0 2a0303e2 (b9406800)
[  154.116891] ---[ end trace 0000000000000000 ]---
[  158.741771] Kernel panic - not syncing: Oops: Fatal exception
[  158.742164] SMP: stopping secondary CPUs
[  158.742970] Kernel Offset: disabled
[  158.743162] CPU features: 0x0000000,00060005,11210501,94067723
[  158.743440] Memory Limit: none
[  164.002089] Starting crashdump kernel...
[  164.002867] Bye!

[root@localhost linux]# ./scripts/faddr2line lib/test_hmm.ko
dmirror_devmem_fault+0xe4/0x1c0
dmirror_devmem_fault+0xe4/0x1c0:
dmirror_select_device at /root/code/linux/lib/test_hmm.c:153
(inlined by) dmirror_devmem_fault at /root/code/linux/lib/test_hmm.c:1659

The kernel is built with arm64's virt.config plus

+CONFIG_ARM64_16K_PAGES=y
+CONFIG_ZONE_DEVICE=y
+CONFIG_DEVICE_PRIVATE=y
+CONFIG_TEST_HMM=m

I *guess* the problem is that migrate_anon_huge_zero_err() has chosen an
incorrect THP size (which should be 32M in a system with 16k page size),
leading to the failure of the first hmm_migrate_sys_to_dev(). The test
program received a SIGABRT signal and initiated vfs_coredump(). And
something in the test_hmm module doesn't play well with the coredump
process, which ends up with a panic. I'm not familiar with that.

Note that I can also reproduce the panic by aborting the test manually
with following diff (and skipping migrate_anon_huge{,_zero}_err()):

diff --git a/tools/testing/selftests/mm/hmm-tests.c
b/tools/testing/selftests/mm/hmm-tests.c
index e8328c89d855..8d8ea8063a73 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -1027,6 +1027,8 @@ TEST_F(hmm, migrate)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);

+	ASSERT_TRUE(0);
+
 	/* Check what the device read. */
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);

Please have a look!

Thanks,
Zenghui

