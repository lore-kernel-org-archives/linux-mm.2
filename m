Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01A05D172DA
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 06:26:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22676B0088; Mon,  2 Feb 2026 01:26:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD04A6B0089; Mon,  2 Feb 2026 01:26:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB21D6B008A; Mon,  2 Feb 2026 01:26:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 992A36B0088
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 01:26:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D747160A95
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:26:21 +0000 (UTC)
X-FDA: 84398532162.17.1CBA20F
Received: from mail-qk1-f194.google.com (mail-qk1-f194.google.com [209.85.222.194])
	by imf19.hostedemail.com (Postfix) with ESMTP id 879E01A000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 06:26:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PLHuu9lp;
	spf=pass (imf19.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.222.194 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770013579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=SDLXRhkACUlRTr33K5zCU7rNMCIsE+1uXoK+L/CDrNA=;
	b=ypymHkmoP0weEEmF17CFuH4nOKrwRzy6mlxYPezObfECRroKixwBrNwcf68Q5nStip40vb
	Q6iRhCYDYH+v6tgi0wMLSPu9nH8YwGi+tGxJrfIKiD56tkR+EQpAQrlhqEQHZGBOqoYUf4
	dluexSor5gY5aHBqdCWH2MFkkijcpV4=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PLHuu9lp;
	spf=pass (imf19.hostedemail.com: domain of coregee2000@gmail.com designates 209.85.222.194 as permitted sender) smtp.mailfrom=coregee2000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770013579; a=rsa-sha256;
	cv=pass;
	b=fWmiQA69cKg/7WAOk4aytG80g9ciQyE6biqesU5h5Jk6015gebxf04wzNfQ11gFvZUFAf4
	cmGFD2tioKEMhyebQIg/HrVDUtZMktub5QSNc9EsDWCllE0uXMOOB4CRoZiLYzzs0B/fCf
	FE+K6tAYMoYks1GWOV7EL7ncUbVi1QI=
Received: by mail-qk1-f194.google.com with SMTP id af79cd13be357-8c5384ee23fso469270885a.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 22:26:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770013578; cv=none;
        d=google.com; s=arc-20240605;
        b=enivUc8X2dyWOsYJzkgl7DtrS0DHzYq6YWGFWZ4wl7kBPAIbk2+Ma+6yofHk/F9b1k
         8uz7NxIAiPyugrJcitMFOfcjvlT1mebka2KayRc9rQQrDf9O15lWPV2iugTQ+PxSI8hv
         Gh1Tvh1tD4UMcoX7xTBSogMfue8GdLaPuVdRwuGVH5CYG2ossLMIbe/9BiKPfuciXMiD
         q0pHeVJRJlCHeg/cPk+pk5GdTFATb30/mkJIxpehulYoRyMdajRDZbr86d5l/1MjOUdC
         lEPq7CbzxwH5sLoBYmORxd2BD4hSsZGY1B3c2W44ngZGWWgEucPSphtBWLiOFHjT8GUY
         kH6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=SDLXRhkACUlRTr33K5zCU7rNMCIsE+1uXoK+L/CDrNA=;
        fh=sKrXaOBjF71l19TgHR0s7jOWJRsqOSk6y7pga4HoeQ4=;
        b=BkBBZ0f8TUftSlusq3S5/uWdMFePj2ZI6ptD1aoCf4+Y7hbW1ZMxQJQ5ZsGmkRT71V
         /flb3Tj35AvRZfS5sVaKsauNbR1lF3p0JdmAGuvZdBe9SBfYS6AEY6gc+DZAW/gqsbVS
         jjbOx0u2arA5m0xWLhKi3sKr/k8ZP1X4CiDGYDcFsK+jRm8Re++Hn5Be80doJD6SSXEB
         nCBp8F1P7Uym090oZ29BjItDkpUl7AUljd4WvKmHA42G9hNq9fzin3TKwhzNrVkrVY0v
         VbWfpYfoIZFqtPXvlX9/3KqHarjZiUC4cZ62bnYtl4say1AtVhmj5Rx/xEKy+XaEOjel
         YLmw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770013578; x=1770618378; darn=kvack.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SDLXRhkACUlRTr33K5zCU7rNMCIsE+1uXoK+L/CDrNA=;
        b=PLHuu9lp+IeFjU0z6bxtn7K1lBKmL4Pv+MDYziJnGeassSK3wFY3Vdp1x3puFPqNZ/
         YZQJB8Y1tA0DLHmK7iYQHdVgW6g/w+7uRDbyzqXg9LAJuUJVqmOjjtKudq3bHVlde4W+
         szULrtsLp3WWZKhUQiy5g0+F6Kn4gzavd3T6ztG31hzKEB9AWrfW0XlhJl0byoaWmSCv
         ZNK/BmcwDtYjcv90x2lLEndn4kEePRdDIC8vkceWpmZifPukru3LKjBIeSMD4ivb2sY6
         Oa66AS8wUXbsxcd/Z+q5/7Lzn8KlKeUh2wCSE1emF3YaDmyXDkFSfd11FLno9k4t+RQT
         l6jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770013578; x=1770618378;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SDLXRhkACUlRTr33K5zCU7rNMCIsE+1uXoK+L/CDrNA=;
        b=PBU/gS2xXS5K3Gp87sSpxiNfayY/8r0ZnCwTGTdwzk07fjmSZOKAldMyVPE6WFPw9i
         axWrdagfz7qqtVqLC7JJUY3TQLe9h2zQwL01vfVSU/uCe54ggoniKG7xkxBSwC8SUSuG
         09sW3GBDMN23Vhm2J3T211H3GDdqrmwrSlni1Zq/8ZHHG9e4/eGyKfzUFmOZuoijGVS0
         bCAlTwP3Ecfp0hODRe5PosoibF108ITXCFKNTyGRt78DfODEFryfbOFSIsaORB1PwdMg
         ti1ztf8knKbcEXTQwbATr+xWesogyWI70JkijzjFcq2hviDzmMrfTsPNg6tzjftdkwW8
         l0Vg==
X-Forwarded-Encrypted: i=1; AJvYcCX65ZR+cuUzC2VloV/wyXdp+4Bg4GnNdfEEKeco+FIRqMulH12MsFLAHnCGPSYuAvYC+Ef5MbH2ow==@kvack.org
X-Gm-Message-State: AOJu0YxZvuGXCFWbWd6UdruEfXxqnkwONA7x5j8n+YGQhMPODkSj3I35
	vyi8ZqTnebHWvtxaiEV+BzJA9JwzPV0p5HVquFY/cIZRCODyDsr+cji3WGUlAGxw6MTVlIXktun
	cN72OIwaRTxPQj7JmMl1SPLlX+t/fGmsJSr3Hh60TjQ==
X-Gm-Gg: AZuq6aIis+guetpCZPPD17WkjqVhnTwJ2jAdpv2P6WUAOLdGJk70lfEPjb9CyciCNbW
	A1jzfcQSAE/0y2mkCqimULzmqSSKLUKt6z/J8C/IyXQduF0BT0YkkG5lIShwPOlOz9cIPpdQZpt
	FP3bQQX2TYAIv5O4tD7kdQqIMZI1EdAQIzjXRCEW6e0T5quOh8fXwsigk9CYv2pBiNg1ChYv5ie
	uTOJcLpOKQYxmYOgJWnVe1WH/YSTn2p70zeCgmECpYuXobK+Q+68VhuO4g/mQrnYFysIib944Mp
	wUMc/9HuuOWVpcJxglJgSK8aveIhPryShG4=
X-Received: by 2002:a05:6214:2306:b0:895:9df:ce78 with SMTP id
 6a1803df08f44-89509dfdc34mr36498546d6.12.1770013262129; Sun, 01 Feb 2026
 22:21:02 -0800 (PST)
MIME-Version: 1.0
From: =?UTF-8?B?5p2O6b6Z5YW0?= <coregee2000@gmail.com>
Date: Mon, 2 Feb 2026 14:20:50 +0800
X-Gm-Features: AZwV_Qi5qn6zGo-j-Et5-o9B7T2Kq2RXM4xyjMnrUyp9HzYe1lO_cApxJJmCD2I
Message-ID: <CAHPqNmyHRaGj0fn+2FvvaJYi4WYOVmai6XX3bRCwbAZoj_GwWg@mail.gmail.com>
Subject: [Kernel Bug] KASAN: slab-use-after-free Read in filemap_free_folio
To: syzkaller@googlegroups.com, willy@infradead.org, akpm@linux-foundation.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: uopecw75g8ejm98qiohrq9kj7xb8qw5f
X-Rspamd-Queue-Id: 879E01A000A
X-Rspam-User: 
X-HE-Tag: 1770013579-198645
X-HE-Meta: U2FsdGVkX1+sldOoTt2EiFe3ae2MAI/U+kD8THZ9i8GBnBzGQ/gdkYka46UxlkqsXhn8ISPTUUkef23hmZ/VtkAY2KW4GJu+LAmqcFIpZw7HYOOAfJDQVQDH+LDxddln+C0Y9J3PJwUtpwF9vVRjloFYhqp59BdAHBYoXIXNHq9nRPtNMh3m8YY9Vfe8wr5SsI6tD1akPvdFlPd+WufogKMUG/r1AqKE6M1lZTKVzTTNaJatxC5bBGd5sw3o0Uncm05Ndh9MRFdyyQ+Z4uhQ6MrwTFuHkAWqVqUCyLRjA5NdD7Tu2f5Kh2+W67jMjabQIidIn7XExbogu2OolgVtgI+ySfayohgIPrdrqeV88/2hKeBR7eSC5DNcPgAdATy8L6tRpNMsHHel7MxxRdOdgclH2LPAwx/F1h9SBXcM/SJrUh317j2mjvCqmeefCkL3296ga3XqduZlymPFtVZ253eCFmKlkYAoaBsCt+cu7XNtxrObd50ZbEXN4h+gWEh23qeD0ncIQTu2qt5DVgUgP4+BSnBwGim5LOjvas1AJJtF0bonI8w/y3HJtxjzWm73hpsPNjtYDhRr2oAF4eXEaoh2BpX/4dj6Kl3rnPlFfqsmafw3ZxWMv3ixN9Bz0T58KvedGYwJThP9dUHL59zVrhZxdOn+rdjrL5k6CB6mXjNVy5xoNHVAIh3IjvHA7MO2qbX7OwvRXFnnfbqbLU0pfAEUKyfbQ0tIjbScxFXsjTtF4uGD1SaU82teB1GUxdkjuVIb6BJmvyv8XeMpCimSZ4aR1f1MWEmub2eyKZLPLoO4yLwP0yo2gYg6xo4Ame2FqTi6U5Ck8RgLOVS/Yhyk939MRoW+mSqVxReK7KYyFdddwiguFF8MygX1mZ3nsrTIzl9Mr1RhsjkjqRU56QuvjD6s8B1PvQGN66F6CX5qDgmlOoh9sRnDutkx3dOTBwhoEfn9lKRD4mo/G047ZFc
 kOQAmXdn
 gz4i/BseLLyOFS/i8GXhVxvnjjLj+hKYndIdHyN5QvDABUUo3lPVzfaTvOxBNQnv2321U0+AZ+cxhgggQm3X9A2qZdtWrhTlfkLZnZ3hn2d77PNpl9s5+l11YBn+ypeYpstVRr4IpHwaCBczlkogScuidBS3lGnmHZJyJzbMuMvb7GA7GOYcpItbiKyB69U7P/8I862KQdMD8nTe+RxQZ7bXLA9N4pteMZLsdUiHhMU01ZuSjfxQrAkvOkGBzOQWIfdpQnOyvwXMyeexhvzNXYQUbk/qMtbzyCxu2/rDMGEzwXc28JIxTwWzWsRaSuwfzf8Fh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Dear Linux kernel developers and maintainers,

We would like to report a new kernel bug found by our tool. KASAN:
slab-use-after-free Read in filemap_free_folio. Details are as
follows.

Kernel commit: v6.18.2
Kernel config: see attachment
report: see attachment

We are currently analyzing the root cause and  working on a
reproducible PoC. We will provide further updates in this thread as
soon as we have more information.

Best regards,
Longxing Li

==================================================================
BUG: KASAN: slab-use-after-free in filemap_free_folio+0x147/0x170
mm/filemap.c:234
Read of size 8 at addr ffff88805e6535a8 by task kworker/u9:28/46327

CPU: 1 UID: 0 PID: 46327 Comm: kworker/u9:28 Not tainted 6.18.2 #1 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1 04/01/2014
Workqueue: ext4-rsv-conversion ext4_end_io_rsv_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x630 mm/kasan/report.c:482
 kasan_report+0xe0/0x110 mm/kasan/report.c:595
 filemap_free_folio+0x147/0x170 mm/filemap.c:234
 folio_unmap_invalidate+0x514/0x850 mm/truncate.c:653
 filemap_end_dropbehind+0x17f/0x1d0 mm/filemap.c:1616
 folio_end_dropbehind mm/filemap.c:1637 [inline]
 folio_end_dropbehind+0xbe/0xe0 mm/filemap.c:1624
 folio_end_writeback+0xe4/0x1f0 mm/filemap.c:1695
 ext4_finish_bio+0x78f/0xa20 fs/ext4/page-io.c:144
 ext4_release_io_end+0x119/0x3a0 fs/ext4/page-io.c:159
 ext4_end_io_end+0x13e/0x4a0 fs/ext4/page-io.c:210
 ext4_do_flush_completed_IO fs/ext4/page-io.c:290 [inline]
 ext4_end_io_rsv_work+0x205/0x380 fs/ext4/page-io.c:305
 process_one_work+0x9cf/0x1b70 kernel/workqueue.c:3263
 process_scheduled_works kernel/workqueue.c:3346 [inline]
 worker_thread+0x6c8/0xf10 kernel/workqueue.c:3427
 kthread+0x3c5/0x780 kernel/kthread.c:463
 ret_from_fork+0x675/0x7d0 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 49607:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_lru_noprof+0x254/0x6e0 mm/slub.c:5307
 ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393
 alloc_inode+0x64/0x240 fs/inode.c:346
 new_inode+0x22/0x1c0 fs/inode.c:1145
 __ext4_new_inode+0x392/0x4f00 fs/ext4/ialloc.c:961
 ext4_create+0x303/0x550 fs/ext4/namei.c:2822
 lookup_open.isra.0+0x11d3/0x1580 fs/namei.c:3796
 open_last_lookups fs/namei.c:3895 [inline]
 path_openat+0x893/0x2cb0 fs/namei.c:4131
 do_filp_open+0x20b/0x470 fs/namei.c:4161
 do_sys_openat2+0x11b/0x1d0 fs/open.c:1437
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x174/0x210 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 49611:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 __kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2543 [inline]
 slab_free mm/slub.c:6642 [inline]
 kmem_cache_free+0x2d4/0x6c0 mm/slub.c:6752
 i_callback+0x46/0x70 fs/inode.c:325
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0x79c/0x1530 kernel/rcu/tree.c:2861
 handle_softirqs+0x219/0x8e0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1052
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

Last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:559
 __call_rcu_common.constprop.0+0xa5/0xa10 kernel/rcu/tree.c:3123
 destroy_inode+0x12c/0x1b0 fs/inode.c:401
 evict+0x5b4/0x920 fs/inode.c:834
 iput_final fs/inode.c:1914 [inline]
 iput.part.0+0x6a9/0xb00 fs/inode.c:1966
 iput+0x35/0x40 fs/inode.c:1929
 do_unlinkat+0x518/0x6a0 fs/namei.c:4744
 __do_sys_unlink fs/namei.c:4783 [inline]
 __se_sys_unlink fs/namei.c:4781 [inline]
 __x64_sys_unlink+0xc5/0x110 fs/namei.c:4781
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Second to last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:559
 insert_work+0x36/0x230 kernel/workqueue.c:2186
 __queue_work+0x97e/0x1160 kernel/workqueue.c:2341
 queue_work_on+0x15f/0x1f0 kernel/workqueue.c:2392
 queue_work include/linux/workqueue.h:669 [inline]
 ext4_add_complete_io fs/ext4/page-io.c:266 [inline]
 ext4_put_io_end_defer fs/ext4/page-io.c:325 [inline]
 ext4_put_io_end_defer+0x398/0x460 fs/ext4/page-io.c:321
 ext4_end_bio+0x2bc/0x580 fs/ext4/page-io.c:385
 bio_endio+0x713/0x860 block/bio.c:1672
 blk_update_request+0x93e/0x15f0 block/blk-mq.c:999
 scsi_end_request+0x7c/0x9c0 drivers/scsi/scsi_lib.c:637
 scsi_io_completion+0x17d/0x14c0 drivers/scsi/scsi_lib.c:1078
 scsi_complete+0x124/0x250 drivers/scsi/scsi_lib.c:1547
 blk_complete_reqs+0xb1/0xf0 block/blk-mq.c:1236
 handle_softirqs+0x219/0x8e0 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_call_function_single arch/x86/kernel/smp.c:266 [inline]
 sysvec_call_function_single+0x57/0xc0 arch/x86/kernel/smp.c:266
 asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:704

The buggy address belongs to the object at ffff88805e652fd0
 which belongs to the cache ext4_inode_cache of size 2320
The buggy address is located 1496 bytes inside of
 freed 2320-byte region [ffff88805e652fd0, ffff88805e6538e0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x5e650
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8880268b4801
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff888101bc3a00 ffffea0001822400 dead000000000002
raw: 0000000000000000 00000000000d000d 00000000f5000000 ffff8880268b4801
head: 00fff00000000040 ffff888101bc3a00 ffffea0001822400 dead000000000002
head: 0000000000000000 00000000000d000d 00000000f5000000 ffff8880268b4801
head: 00fff00000000003 ffffea0001799401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Reclaimable, gfp_mask
0xd2050(__GFP_RECLAIMABLE|__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC),
pid 15633, tgid 15633 (syz-executor.7), ts 460463106471, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1af/0x220 mm/page_alloc.c:1845
 prep_new_page mm/page_alloc.c:1853 [inline]
 get_page_from_freelist+0x10a3/0x3a30 mm/page_alloc.c:3879
 __alloc_frozen_pages_noprof+0x25f/0x2470 mm/page_alloc.c:5178
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3059 [inline]
 allocate_slab mm/slub.c:3232 [inline]
 new_slab+0x24a/0x360 mm/slub.c:3286
 ___slab_alloc+0xd79/0x1a50 mm/slub.c:4655
 __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4778
 __slab_alloc_node mm/slub.c:4854 [inline]
 slab_alloc_node mm/slub.c:5276 [inline]
 kmem_cache_alloc_lru_noprof+0x443/0x6e0 mm/slub.c:5307
 ext4_alloc_inode+0x28/0x610 fs/ext4/super.c:1393
 alloc_inode+0x64/0x240 fs/inode.c:346
 new_inode+0x22/0x1c0 fs/inode.c:1145
 __ext4_new_inode+0x392/0x4f00 fs/ext4/ialloc.c:961
 ext4_symlink+0x462/0xde0 fs/ext4/namei.c:3388
 vfs_symlink fs/namei.c:4817 [inline]
 vfs_symlink+0x403/0x680 fs/namei.c:4801
 do_symlinkat+0x261/0x310 fs/namei.c:4843
 __do_sys_symlinkat fs/namei.c:4859 [inline]
 __se_sys_symlinkat fs/namei.c:4856 [inline]
 __x64_sys_symlinkat+0x93/0xc0 fs/namei.c:4856
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88805e653480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805e653500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88805e653580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                  ^
 ffff88805e653600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88805e653680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================

https://drive.google.com/file/d/1ZjRNEOf0XFYtFl5UZ7dvpJpzmPhje8it/view?usp=drive_link

https://drive.google.com/file/d/1ShZndTsP1CZuwyZmbuZ-e5nHEdPjeIVX/view?usp=drive_link

