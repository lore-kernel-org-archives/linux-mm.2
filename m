Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F7BEC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 21:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0D426B0092; Fri, 26 Jun 2026 17:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3D86B0093; Fri, 26 Jun 2026 17:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22C36B0095; Fri, 26 Jun 2026 17:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AAC786B0092
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:29:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CBD8A05D3
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:29:16 +0000 (UTC)
X-FDA: 84923354712.23.57C9266
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id 634C640003
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:29:14 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbKmuihO;
	spf=pass (imf01.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782509354;
	b=XiP2CwKXRLcLO3fDApzIAb4n3ryjz+GMwmTV/E56w9ipnTfPFQJAl3ufOaMGL4frPuPf8w
	BIUYynDaACltV05phTxJG9Hu/QyHBAie0qlAqtAYWwED6CzGdFRRJJTQiPMeymt0/RziH5
	UpDxPyCtphKiK5d5l0SODGpP652Rudw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782509354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=z/zAorgq1/ywAsmIYSwvtFRcj4ZBEEX9Hieid4JjiU8=;
	b=jm9JGnJlbkHg34CGbmUdFoqQ6ceZzIf4YzlLbttND6o6e66DOpK9+j1gnJzjsdChV+PBRp
	70pJCQEjgsu1sFnxmyfy0lR3HrIOxA+yThWcbuumCsM5d9gEpztFmSv3hujyjDCaaBnP5a
	bQBX0rO/hLjO4SlG06B3RoLctn7jdKU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nbKmuihO;
	spf=pass (imf01.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-5bbdf91a888so42670e0c.2
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509353; x=1783114153; darn=kvack.org;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z/zAorgq1/ywAsmIYSwvtFRcj4ZBEEX9Hieid4JjiU8=;
        b=nbKmuihOdscjJ89CPA97MRlRJE4XlNBgEwY+/oQ0AXSm2NkjB7GPPTHDYcyg5chfv2
         HRkhZQV2qzfiH088CUUvfyzX8Y0exqNjybkegbSIlQdUDob7T7RdFgWznvxGtT8a8HMz
         J/LbasijRg32GjE6+qJGigJ0i/X+SLPGKl11zhD4BV68HKXlLDXotBf03d1clwRacvLW
         Vrr2RwEvwD0/DoJYDIfpLq0pSifqE19yiCcIc5BXfRoU5sbb4O6PueGmA1O0aqpaaNM8
         GEVx+Cw1UJS1D2EmslQPKj0rdT94iOLJst6PlyODJPxuUmoBGhLXXfeaeNSvljvEdW38
         HevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509353; x=1783114153;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=z/zAorgq1/ywAsmIYSwvtFRcj4ZBEEX9Hieid4JjiU8=;
        b=C8g+c/maMbCzeyAqKflJQW0bKqcAUhfp5VrgJpXTguvZhZ4hdvbnAsxv9Nyd07Aeue
         qA9bOC3oBPzn+mGDvrWeABhH0B5XP5U6t6xwoK26Jw/89S4ZBKgR4i0MhNyj25ZK3RRW
         GHomk0OrXm6rFxS1c+aSM0v4mTpQJh3edwulmL0uWSYTFI44Ll53EE4EVIBKg+PH1+Vj
         1NRlKKpS9Tyo9JGZfxf8x8/6uzQUIwzauDuBKUxVsnHc1jAyJ4NQZqGml1riAO4crZ3/
         4DycoMOOF8IBBvILFD53gPInz3Lauunta1YY8B3L4XhQaMljmKBoPvOWQ3IKIMnjzob/
         R3FA==
X-Forwarded-Encrypted: i=1; AHgh+RrMVMVNkgwy6vsbx3YZSReyEp1JMhw2WHSm0qY1DDLExJPGk1rX9J0mfezfjwuRKOWKKgPOEpTwuw==@kvack.org
X-Gm-Message-State: AOJu0YwDaPexlJ97804vvoQBvKFrhmTsGhGkOK0x1/pl2PqT+7z0KIRV
	UftnDVtnaEAJrtJ8Zmzjq4VALzPERGN0V4aOBz9XjbZNE41F3+rNd5W6
X-Gm-Gg: AfdE7ckKUCMbXJj0gVGcMgp938MmWgJQw/HNheAZQl2EqimqN9rO3NLVmh0r1yfDO8u
	mzcZ1LvE7a2V4q++icpQNtrwD4GlqNKz8MeJIk8A5+gxXj8hqTfqUwgp79IRwXw4qsx4eVoPYut
	IUr/iL75UpxTrnHmvEdbffb52/Ayb/oUSvcUMIwJM1nSlRMlIc3ZhIJVRKOnVEdiOn5cMxuX/0F
	ILV1QXOUsfuWNWjExTJd/7mZQ9QnVim1Q9PctwI6s53OIjnmC3yhg+K0l83VuBhugxSUdytViFH
	CJPz6+o9ruipo47hRLuxDiwnaUtpmkq1aDml4qRaWXTYpvjhQrPpmXtghtgL7tc1PRnZqU00g+Q
	3Rf97OmkuuhfmTvvxBxZDjWL3ATqyerT3MrQWoTeHhRbfelSW/V/wqw1JO/cB1XxnbBspLpQZOh
	k1uSwhnvzCPDObDVsaw9XVzA5BfPDlWw9sx1VnxnrO5qJZsbp5w/9ti8FjZOle6I/CcYZACBm3K
	48mAIcMgt+B
X-Received: by 2002:a05:6122:2bc9:b0:59b:96df:f92b with SMTP id 71dfb90a1353d-5bd69e016e8mr1043235e0c.3.1782509353399;
        Fri, 26 Jun 2026 14:29:13 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bd78e4c6cbsm1892538e0c.4.2026.06.26.14.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:29:12 -0700 (PDT)
Message-ID: <6a3eef28.4ad61264.123291.6658@mx.google.com>
Date: Fri, 26 Jun 2026 14:29:12 -0700 (PDT)
Subject: WARNING in bdev_getblk
To: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: sanan.hasanou@gmail.com
X-Stat-Signature: 73rod958ydtmn7t5wy76qjt47836i7ts
X-Rspamd-Queue-Id: 634C640003
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782509354-365585
X-HE-Meta: U2FsdGVkX1/nkvOBWGKKeQu1TZkyQ7Ra1HJ20l9vwfJme2IUK0wTgu1hlpmRWmE1oCyWRqZ2nG3Jb1nOewHSMfpm/8zic520hkyT9BKhOH/iYV/d/j/obXqArkuLrLWIQpLIXenFcsfLagWlxXaLBEVUhiGfPeDiIjIro14gwCH0nWx8G5/y4Wakgp37mK4Bo3j2C9lphQJHUL1UtbeVSxZvQ9oSU1BzzdOIS8bdaYe2PBkk+OipyYWHk7Zl+PpeKDwodrFDaotNMSZGApphc68Di66VARXPrQbT5YAdqBaDzAMaZ1c0dDdhVPSx6EcoriHqRwlcAJcrHP5YD5iIeoQs2Mc/kCVpuCVIW8aNDC2HQvrUwvNBSVNmFmAShTytPjsvtyCaCRHkDU1rUm0F0MownZ0QsXNLdBoKfBaTRJjPThqZLde8+3ANQEuadTZN9eqxMT9F1hboAgmwBt/+e0vuxuGzY/gW0rPzxP4OCB2fHTMlWYcsITYAEnI5T3fH0wwm/VSoxQgXbAsfiOJiV2hYPNuNZSTQi6v/xl7Jol7k/bWKyvk4YIx5McmT/pk1vCFGL8qBzdhnKqbrBcVsSu8gn453Yc8XaBCR8UTvIJQwWA90JK4cBtKDF/5lGfawBI1fy4NWUaBp2nwjjKRW67SeoqC+7rDt24M5o98j8SFbDw+WoPTx9RevuSBfAs4bLzvIT8LOEB1p4A4DTvdZujpu8EfB/QRuNBiRn6N7Yeosm2xNS6KaOqhpHWpY5OpyBxBzOlPQsBPV3fJjwgNSG0asiZswkzU2XToEqclS9HdjG4D+tVPIgUO3Ky3VRpUDhNnhviXbeh8CmooCAolnzmXCHuAfPEL0/BFV6Z6hiQd4BOu7tvdpLfytrnyE8P16ogxDYIRnqB3TDfEpJ/Kn1dKk2TTby9JP0lRPYoEGshsJn5t1A9fpqZKhi6HXsz7p9aIezYwLxoI9uFR7hEK
 LBH+wSiM
 kjtK6vdVkfO2LQGC6+7Y5BVgDduINgK59+1f2U7h4bKc5HCTA7DAN7Cm/pyruk3YuWnCqScHU2FDLcuyIygHvbeHbpIGiGiXISN/yQSFG79I6J53bQZiQfLK/EKWFtS/fJKlZOk3fubaqUCpPCzwXY9YNbDI3xKP9P4NzC1KcVMGP9eT9bl8SCzBDV96DGPOcVplEialhmsCk2KTAtZXzTSBpQvHJLT46RhZV1PWECXIzEkAKdiH7pqCbef9JoYRnWJ8VKpc7VNV+aka6bbtg2xuJfG1ZklQE8YvwGFQjXelcjdNaUMZPRqIv1eRrcP9i0nj20rEAhNLvPF72I3AKF0cY4/mzDxVQWtC+bfMEwGBaDCintR3xbtG9ejd4VLOe1zf5rgmpkGwSdG+uVGcHiKZwqgt9J0MfGdhVzMaFXJ3ufv6OjOD1GI1XGQTdcHaMhOVDw7LywtU8y5YBBmgrsRr1IBCq2b62+ojQGllH9mawqKFVwIksWEpZYUr0IhuNThzuQpriH9qLylE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1I8_6za7gDPbA6deS4Bad6VdpoR41-ODM>
Reproducer: <https://drive.google.com/open?id=1xQ5SMK9Hx-abwuL0OR8zB7Uv3-R6rT9S>
Thank you!

Best regards,
Sanan Hasanov

------------[ cut here ]------------
current->flags & PF_MEMALLOC
WARNING: mm/page_alloc.c:4741 at __alloc_pages_slowpath+0xd1e/0xd50 mm/page_alloc.c:4741, CPU#0: kswapd1/87
Modules linked in:
CPU: 0 UID: 0 PID: 87 Comm: kswapd1 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xd1e/0xd50 mm/page_alloc.c:4741
Code: 8b 1c 25 08 00 ba 90 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 84 c0 75 23 f6 43 01 08 48 8b 54 24 08 0f 84 2d f3 ff ff 90 <0f> 0b 90 e9 24 f3 ff ff e8 55 26 fd 08 90 0f 0b 90 eb c1 89 d9 80
RSP: 0018:ffffc9000156e7f8 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88804128802c RCX: dffffc0000000000
RDX: ffffc9000156e920 RSI: 0000000000000000 RDI: 0000000000148c48
RBP: 0000000000148c48 R08: ffff88803fffd9b0 R09: 00000000000095f5
R10: dffffc0000000000 R11: ffffed100fffb449 R12: ffffc9000156e920
R13: 1ffff920002add20 R14: 0000000000148c48 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88809b080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007facf51fc504 CR3: 000000001b54e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x314/0x370 mm/page_alloc.c:5263
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2484
 alloc_frozen_pages_noprof mm/mempolicy.c:2555 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2575
 folio_alloc_noprof+0x1e/0x30 mm/mempolicy.c:2585
 filemap_alloc_folio_noprof+0x107/0x470 mm/filemap.c:1013
 __filemap_get_folio_mpol+0x3fc/0xb00 mm/filemap.c:2006
 __filemap_get_folio include/linux/pagemap.h:774 [inline]
 grow_dev_folio fs/buffer.c:1047 [inline]
 grow_buffers fs/buffer.c:1113 [inline]
 __getblk_slow fs/buffer.c:1131 [inline]
 bdev_getblk+0x1f7/0x6e0 fs/buffer.c:1458
 __getblk include/linux/buffer_head.h:380 [inline]
 sb_getblk include/linux/buffer_head.h:386 [inline]
 ext4_xattr_block_set+0x1d6b/0x2ab0 fs/ext4/xattr.c:2131
 ext4_xattr_move_to_block fs/ext4/xattr.c:2669 [inline]
 ext4_xattr_make_inode_space fs/ext4/xattr.c:2744 [inline]
 ext4_expand_extra_isize_ea+0x12da/0x1ea0 fs/ext4/xattr.c:2832
 __ext4_expand_extra_isize+0x308/0x400 fs/ext4/inode.c:6297
 ext4_try_to_expand_extra_isize fs/ext4/inode.c:6340 [inline]
 __ext4_mark_inode_dirty+0x45c/0x730 fs/ext4/inode.c:6418
 ext4_dirty_inode+0xcb/0x110 fs/ext4/inode.c:6450
 __mark_inode_dirty+0x39d/0x1470 fs/fs-writeback.c:2608
 mark_inode_dirty_sync include/linux/fs.h:2217 [inline]
 sync_lazytime+0x13b/0x2d0 fs/fs-writeback.c:1722
 iput+0x230/0xe80 fs/inode.c:1997
 __dentry_kill+0x198/0x5d0 fs/dcache.c:670
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1147
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1174
 prune_dcache_sb+0x10e/0x170 fs/dcache.c:1256
 super_cache_scan+0x365/0x4a0 fs/super.c:223
 do_shrink_slab+0x6d2/0x1160 mm/shrinker.c:437
 shrink_slab_memcg mm/shrinker.c:550 [inline]
 shrink_slab+0x7ef/0x10d0 mm/shrinker.c:628
 shrink_one+0x2d9/0x720 mm/vmscan.c:4928
 shrink_many mm/vmscan.c:4989 [inline]
 lru_gen_shrink_node mm/vmscan.c:5067 [inline]
 shrink_node+0x3134/0x3a20 mm/vmscan.c:6047
 kswapd_shrink_node mm/vmscan.c:6894 [inline]
 balance_pgdat mm/vmscan.c:7070 [inline]
 kswapd+0x1688/0x2d50 mm/vmscan.c:7343
 kthread+0x389/0x480 kernel/kthread.c:467
 ret_from_fork+0x507/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:245
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

Modules linked in:
CPU: 0 UID: 0 PID: 87 Comm: kswapd1 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xd1e/0xd50
Code: 8b 1c 25 08 00 ba 90 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 84 c0 75 23 f6 43 01 08 48 8b 54 24 08 0f 84 2d f3 ff ff 90 <0f> 0b 90 e9 24 f3 ff ff e8 55 26 fd 08 90 0f 0b 90 eb c1 89 d9 80
RSP: 0018:ffffc9000156e7f8 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88804128802c RCX: dffffc0000000000
RDX: ffffc9000156e920 RSI: 0000000000000000 RDI: 0000000000148c48
RBP: 0000000000148c48 R08: ffff88803fffd9b0 R09: 00000000000095f5
R10: dffffc0000000000 R11: ffffed100fffb449 R12: ffffc9000156e920
R13: 1ffff920002add20 R14: 0000000000148c48 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88809b080000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007facf51fc504 CR3: 000000001b54e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x314/0x370
 alloc_pages_mpol+0x232/0x4a0
 alloc_pages_noprof+0xa9/0x190
 folio_alloc_noprof+0x1e/0x30
 filemap_alloc_folio_noprof+0x107/0x470
 __filemap_get_folio_mpol+0x3fc/0xb00
 bdev_getblk+0x1f7/0x6e0
 ext4_xattr_block_set+0x1d6b/0x2ab0
 ext4_expand_extra_isize_ea+0x12da/0x1ea0
 __ext4_expand_extra_isize+0x308/0x400
 __ext4_mark_inode_dirty+0x45c/0x730
 ext4_dirty_inode+0xcb/0x110
 __mark_inode_dirty+0x39d/0x1470
 sync_lazytime+0x13b/0x2d0
 iput+0x230/0xe80
 __dentry_kill+0x198/0x5d0
 shrink_kill+0xa9/0x2c0
 shrink_dentry_list+0x2e0/0x5e0
 prune_dcache_sb+0x10e/0x170
 super_cache_scan+0x365/0x4a0
 do_shrink_slab+0x6d2/0x1160
 shrink_slab+0x7ef/0x10d0
 shrink_one+0x2d9/0x720
 shrink_node+0x3134/0x3a20
 kswapd+0x1688/0x2d50
 kthread+0x389/0x480
 ret_from_fork+0x507/0xb90
 ret_from_fork_asm+0x11/0x20
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 UID: 0 PID: 87 Comm: kswapd1 Not tainted 7.0.0-rc1 #1 PREEMPT(full) 
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 vpanic+0x41f/0xa20
 panic+0xb9/0xc0
 __warn+0x317/0x500
 __report_bug+0x28d/0x500
 report_bug+0x16a/0x220
 handle_bug+0x98/0x200
 exc_invalid_op+0x1a/0x50
 asm_exc_invalid_op+0x1a/0x20
RIP: 0010:__alloc_pages_slowpath+0xd1e/0xd50
Code: 8b 1c 25 08 00 ba 90 48 83 c3 2c 48 89 d8 48 c1 e8 03 0f b6 04 08 84 c0 75 23 f6 43 01 08 48 8b 54 24 08 0f 84 2d f3 ff ff 90 <0f> 0b 90 e9 24 f3 ff ff e8 55 26 fd 08 90 0f 0b 90 eb c1 89 d9 80
RSP: 0018:ffffc9000156e7f8 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffff88804128802c RCX: dffffc0000000000
RDX: ffffc9000156e920 RSI: 0000000000000000 RDI: 0000000000148c48
RBP: 0000000000148c48 R08: ffff88803fffd9b0 R09: 00000000000095f5
R10: dffffc0000000000 R11: ffffed100fffb449 R12: ffffc9000156e920
R13: 1ffff920002add20 R14: 0000000000148c48 R15: 0000000000000000
 __alloc_frozen_pages_noprof+0x314/0x370
 alloc_pages_mpol+0x232/0x4a0
 alloc_pages_noprof+0xa9/0x190
 folio_alloc_noprof+0x1e/0x30
 filemap_alloc_folio_noprof+0x107/0x470
 __filemap_get_folio_mpol+0x3fc/0xb00
 bdev_getblk+0x1f7/0x6e0
 ext4_xattr_block_set+0x1d6b/0x2ab0
 ext4_expand_extra_isize_ea+0x12da/0x1ea0
 __ext4_expand_extra_isize+0x308/0x400
 __ext4_mark_inode_dirty+0x45c/0x730
 ext4_dirty_inode+0xcb/0x110
 __mark_inode_dirty+0x39d/0x1470
 sync_lazytime+0x13b/0x2d0
 iput+0x230/0xe80
 __dentry_kill+0x198/0x5d0
 shrink_kill+0xa9/0x2c0
 shrink_dentry_list+0x2e0/0x5e0
 prune_dcache_sb+0x10e/0x170
 super_cache_scan+0x365/0x4a0
 do_shrink_slab+0x6d2/0x1160
 shrink_slab+0x7ef/0x10d0
 shrink_one+0x2d9/0x720
 shrink_node+0x3134/0x3a20
 kswapd+0x1688/0x2d50
 kthread+0x389/0x480
 ret_from_fork+0x507/0xb90
 ret_from_fork_asm+0x11/0x20
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

