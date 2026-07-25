Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D55CBC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 05:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1636B007B; Sat, 25 Jul 2026 01:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9526B6B0088; Sat, 25 Jul 2026 01:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 867F46B008A; Sat, 25 Jul 2026 01:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58E706B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 01:04:03 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C747340265
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:04:02 +0000 (UTC)
X-FDA: 85026107124.16.8B095A3
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf05.hostedemail.com (Postfix) with ESMTP id 25410100009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:04:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3wENkagkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3wENkagkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784955841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=Q5yLx/7epMatkM14jxB6RPWceg+tmwlfXFxGPVUJWcg=;
	b=avEeq4riDD416L4a/RVIdOEi40R11+7uJvf9HEPZ/7ICa/pkCGAylEdJRDB0jXZwBeBWLi
	PiXCYs9ts2o1URzPqKKgSAX97qB072QCNqV6GCWCA3cqvVhb6IXKF+JVnbN072qKVxh4fj
	rD9wAFiLcXkBRf04pUi7ctQmZJjsLPE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf05.hostedemail.com: domain of 3wENkagkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3wENkagkbADMhnoZPaaTgPeeXS.VddVaTjhTgRdciTci.Rdb@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784955841;
	b=GCWvo2EegzGQ4nDaGM+DolOTkMQGAs5wlkyDb1qLGPDmqFCyCXCScnAUUz4TSfzpHGoVQ9
	10dHKHzywIAcQzfFiK/gZd8SCy2LHmUJaFP4My8PbC868bIbu5cTZqUM5X5r/0h113oHjh
	oN3KXwqtKV8D4/8UoYfGEqxymbcFLqA=
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e6b5976d74so1298383a34.3
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784955840; x=1785560640;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Q5yLx/7epMatkM14jxB6RPWceg+tmwlfXFxGPVUJWcg=;
        b=e68Hkh+R7HUG4JxKhvlaZ0WBhui/I0n67Cld25nQCpN+sl0qzq//Gjx+xWuTqHOYmd
         MWZyOHXZKYYHXbnOyMv9DBkPjdMBRGF3VUycIjsh2rhb6Qvor/Bv/C3GWNGLWo7FTA70
         AlLsOV2P2HIa8A77GADRaZ0jnh8wDoraYnOIBqd3DpXJCFHiZWMmM5UgvcjozjnqjKbT
         LJtIdOTvIwZlYee4XSsCi3xNZUlRGaT0f7fzDycrXMdUXiY4xsb7fPrCywVzpCtXHqET
         kfHD+pIWm/l4Tjadxf0QrDKFhTGv8jL0Int11nLR6u80K4vHIH6rxecuJ65Up5hR8gdd
         Hdzg==
X-Forwarded-Encrypted: i=1; AHgh+RoqkqvxEhJqcWmxSpT83b3Efv4vRGMfdZUkZzkkXxuzN4bYDYudWzpXDRBrINls2LDA+V3IbQy9yw==@kvack.org
X-Gm-Message-State: AOJu0YwUlrWXKbrjhTNLjj8rfTf1ZxPPrYy88OEKRqMIZdlJzWNUgUs5
	LzOeJsNaNlg4LNN1VBt4LrrvLQo6ldkHi+/UVJlKg9Ar0O3ny184NkvJstCUTsKuIa6rhHDavzG
	f4WyWMRDgMn/I1Q0CvvK+t5lSXrZ2SF2etTMouU+fxLGVsOCuTD1LCDt4jLo=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:118d:b0:496:10e6:f76e with SMTP id
 5614622812f47-4ab6a04a45fmr1158979b6e.4.1784955840293; Fri, 24 Jul 2026
 22:04:00 -0700 (PDT)
Date: Fri, 24 Jul 2026 22:04:00 -0700
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6443c0.70955b6c.323240.0013.GAE@google.com>
Subject: [syzbot ci] Re: Use generic_file_read_iter() in hugetlbfs
From: syzbot ci <syzbot+cibabc01dbab7e054c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, christian@brauner.io, david@kernel.org, 
	jack@suse.cz, jane.chu@oracle.com, jiaqiyan@google.com, linmiaohe@huawei.com, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	nao.horiguchi@gmail.com, naoya.horiguchi@nec.com, osalvador@suse.de, 
	stable@vger.kernel.org, usama.arif@linux.dev, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 25410100009
X-Rspam-User: 
X-Stat-Signature: b5bgj8y4pstqdgsde8ci88wbk98ikg4n
X-HE-Tag: 1784955841-158139
X-HE-Meta: U2FsdGVkX1/X6XYWn9JcCO/Oy2Fu8KmUbpyxrgbfbaDGncJLrk3Nb2nOQrUFs0GWBC8RYi5mfyvoE+jy94HSHZvFHt2vjTquaEHLLUlRzjrsBNwrrfWrqLI+pkHFyrXSsO4Nm4UTBQ+4duSvoMuXBWNiQ8rhoj5I7ddeVdgWSMpuD/N3szq0H0vTcZQXxWZsk8HgG0wSXAFJSwY8si0ERIGd+uTSVHMKDCco6RqDEnqOZEE9pLiu4rPHvdzQknsWmNQpjdY2doCg7/WUFYc0gj+FlqwMqp7dhb9x8oMZ0iXYZ10cewjtxdOifqu0GFhY/QKfU74XXAX3hvULw/qmKUil5/K1kzmuW/tkc6ai0VwQSRWmCcer/OrHbvevQxAZ3Mx1jQouasrA8Pg42jNUTfwhn2ZiI51BC6RQomWiDAPlIvfgVeRkeRANiKpv8kZjbQmcr2lxT3cuoa2mX7S2whrf94MLdTZJF/a5pKi6PYrg8kBrjOnNOHmfAf0YZCZxpAx5Sy61AzEyr9pQ0UWkNKvbzN+6zKo7/Nh1bkrz3SG9aYfI9xxblFuV30PMRUaCaL0AD23yTaYHdK5+9V4KDbrl2C44+Puw3YwaON1zftZQiA9BRLTrZfaU5H8XLiVrTuUQBq0ZLlq4A1TUdAdZKtgHylu9I1rP/NNwaNBL0mlp+cgVEirwrb0WWpNDfWPYb4qNUDNFg0LV/6+Li2EoKOQf5K/bQP+CWOC7EB49xpXQE5KMO62z59Cqf1/omaTE0DoYovbN1odUPl9jLNb8gHUeQAB2234saAIVwP1Is/7ykKieHfX6OL1BFjxxLEN3q6NvzQvug37im1bL1DvbDVhMEB1pOpgaxE9IaAi3XYzJckiOKXS7zkxFJV780jyAqes+Hyj1SR/RwgFkiIfS1axCf+zaYgafmmPwE0GvW6PZiDUpmlVakSt2628X/hOArNWf/5Zjd7I2Mck7UAl
 /xMNCA14
 j+YJoAdWnfxb2S5ik7g1KCdMXVIikaQblIwAcFiFJ2wZYkGneoeCIbjNPSNx/A5UQYxl1Ls7E2jVZoh/VmPLdvmFgdnKySXiLdbMTZTZwhAO3W/3WbNv0+ND03cXZprGlaXT3B43qZ/j7HleH8JzPrbFtkJIkwzVqu058kdo33RBbIXKojAvkVPhWqnlN7LOmhDr658Y5P1OjN5rXNwPA35ClHi2kH/FRSQ6JxE6RirFkDcPtV7S/Km6tbVswS/kymmyVFdWVk2YRj2y9r9vHEL906DFEUDwd+W8xXN/ppyEH2yocJ4ybQ04d8/WvenIjgZNelraOTTnezsegMC4o+x+a5Yk5nc/qu5mkHp/h8rLNWpAOfmPJkuLnRnEDf1nruW4exr0NH9LsN0jUOuvAaRJIBybQczVB/khOm/tdMUIOwsdDcYvERuehCHdxM9FikIJK2mMM3k+oVdlYzTdRoLpIbzQ/kuOA2qoXIvPlCmDi3e6iMqBItwpqOkBieg1bvn5FwJN+vjbTiqtJvsi4bdjV2l3godb5Dge6rp4vHljMhyqupyVo1jpGk06K/l+i2hbFfU4aChSShCxopRx9L3EeHbPfYaTxeLjdNDODiDorTArfMuP8haCy0VG2xpXopHz/qV3hxGLGyH1tnWjPg+5PHFJGTwpN/CrCDykNIxfjrTzBVWHITMpB8ZV+0bVPudS3uOEvoO9uKpAl0cPMJXQ5fsea71PVFj6utxHMRvFQzG3lm8fC2hUdKi4QXWlszgyIUk4wPxgWIUryMmRhxqR+QWIqs7heudejQ7zUq7NRCz//pWJr6410hq4YiW0EbS8ERP3TgatHK1fRKFa5Apx2so1GuBSlr/e9inGJAwx7+UGZ9LWq/ytE7Yh5EZPUp61VhVV24/fQiF4xNJnJI7TLnk8qdvaXReyqjexs+j4aNnhIFHOW76gVANTXTFijRGhzxUGLE1gsiQ8FErMHcA0BreGu
 rXJVfETF
 vOGFhKZn/xggG1GE3N4Srd6bywXO5iQM5ck99ceblyyZ9hlBpgmygBfl1jWhIIFvxdSQbi2ecRQa1wlcgsiTfw0EfjqUrsCD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v4] Use generic_file_read_iter() in hugetlbfs
https://lore.kernel.org/all/20260723143034.175661-1-willy@infradead.org
* [PATCH v4 01/14] memory-failure: Fix hardware poison check in unpoison_memory() again
* [PATCH v4 02/14] memory-failure: Test the page is hwpoison before taking the mutex
* [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
* [PATCH v4 04/14] hugetlb: Mark some function arguments as const
* [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
* [PATCH v4 06/14] memory-failure: Remove raw_hwp_list_head()
* [PATCH v4 07/14] hugetlb: Use the has_hwpoisoned flag
* [PATCH v4 08/14] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in_hugepage()
* [PATCH v4 09/14] mm: Check individual hugetlb pages for poison
* [PATCH v4 10/14] filemap: Add hwpoison handling to filemap_read()
* [PATCH v4 11/14] filemap: Remove checks in mapping_set_folio_order_range()
* [PATCH v4 12/14] hugetlb: Set mapping folio order
* [PATCH v4 13/14] filemap: Add support for authoritative mappings
* [PATCH v4 14/14] hugetlb: replace hugetlbfs_read_iter() with generic_file_read_iter()

and found the following issues:
* WARNING in bio_add_page
* general protection fault in create_empty_buffers

Full report is available here:
https://ci.syzbot.org/series/4b3a4f52-06f4-4a41-872f-dde0771be8ef

***

WARNING in bio_add_page

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bb071828-9749-428c-a78c-fc39b0b5caf2/config
syz repro: https://ci.syzbot.org/findings/38d53450-b153-4f47-8474-be250791ea91/syz_repro

------------[ cut here ]------------
len == 0
WARNING: block/bio.c:1052 at bio_add_page+0x516/0x700 block/bio.c:1052, CPU#0: udevd/5630
Modules linked in:
CPU: 0 UID: 0 PID: 5630 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:bio_add_page+0x516/0x700 block/bio.c:1052
Code: 31 ed 44 89 e8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 86 5e 17 fd 90 0f 0b 90 eb db e8 7b 5e 17 fd 90 <0f> 0b 90 eb d0 e8 70 5e 17 fd 90 0f 0b 90 e9 76 fe ff ff e8 62 5e
RSP: 0018:ffffc9000487f0f8 EFLAGS: 00010293
RAX: ffffffff84af2445 RBX: 0000000000000000 RCX: ffff8881108d0000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 1ffff110228761e2 R08: ffff8881143b0f7f R09: 1ffff110228761ef
R10: dffffc0000000000 R11: ffffed10228761f0 R12: ffff8881143b0f14
R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007faeac7ccc80(0000) GS:ffff88818d945000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000295e815ae000 CR3: 0000000114e0e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bio_add_folio+0x64/0x90 block/bio.c:1107
 do_mpage_readpage+0xd8c/0x1b40 fs/mpage.c:294
 mpage_readahead+0x3e7/0x800 fs/mpage.c:370
 read_pages+0x193/0x5a0 mm/readahead.c:174
 page_cache_ra_unbounded+0x679/0x8f0 mm/readahead.c:315
 do_page_cache_ra mm/readahead.c:348 [inline]
 force_page_cache_ra+0x26c/0x2e0 mm/readahead.c:378
 filemap_get_pages+0x4d9/0x1ef0 mm/filemap.c:2708
 filemap_read+0x422/0x1630 mm/filemap.c:2841
 blkdev_read_iter+0x2f1/0x420 block/fops.c:830
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7faeac316b6a
Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffd8d811da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007faeac316b6a
RDX: 0000000000000400 RSI: 0000557e6b670e18 RDI: 0000000000000009
RBP: 0000000000000400 R08: 0000557e6b670df0 R09: 0000000000000008
R10: 0000000000000051 R11: 0000000000000246 R12: 0000557e6b670df0
R13: 0000557e6b670e08 R14: 0000557e6b66e128 R15: 0000557e6b66e0d0
 </TASK>


***

general protection fault in create_empty_buffers

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/bb071828-9749-428c-a78c-fc39b0b5caf2/config
syz repro: https://ci.syzbot.org/findings/2406d176-ea76-40a8-b6bc-41d3e6326388/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5932 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:create_empty_buffers+0x48/0x520 fs/buffer.c:1672
Code: 00 00 00 00 fc ff df e8 96 dc 69 ff 48 89 df 4c 89 e6 ba 40 8c 40 00 e8 e6 bc ff ff 49 89 c4 48 89 04 24 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 09 bc d7 ff 4d 09 3c 24 49 83 c4
RSP: 0018:ffffc900034bf570 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffffea0005ceb100 RCX: 0000000000000046
RDX: 0000000000000002 RSI: ffffffff8e4b7f70 RDI: ffff888172cdbb80
RBP: ffffc900034bf6f0 R08: ffffffff825c6656 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8eb5a120 R12: 0000000000000000
R13: 1ffffd4000b9d620 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007fd3c0fc7c80(0000) GS:ffff8882a8f45000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00005567a5ebae48 CR3: 000000017395c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 block_read_full_folio+0x116/0x810 fs/buffer.c:2381
 filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2512
 filemap_update_page mm/filemap.c:2599 [inline]
 filemap_get_pages+0x1742/0x1ef0 mm/filemap.c:2731
 filemap_read+0x422/0x1630 mm/filemap.c:2841
 blkdev_read_iter+0x2f1/0x420 block/fops.c:830
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd3c0b16b6a
Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffcab174708 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd3c0b16b6a
RDX: 0000000000000400 RSI: 000055c883b6c638 RDI: 0000000000000009
RBP: 0000000000000400 R08: 000055c883b6c610 R09: 0000000000000008
R10: 0000000000000051 R11: 0000000000000246 R12: 000055c883b6c610
R13: 000055c883b6c628 R14: 000055c883b60b48 R15: 000055c883b60af0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:create_empty_buffers+0x48/0x520 fs/buffer.c:1672
Code: 00 00 00 00 fc ff df e8 96 dc 69 ff 48 89 df 4c 89 e6 ba 40 8c 40 00 e8 e6 bc ff ff 49 89 c4 48 89 04 24 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 09 bc d7 ff 4d 09 3c 24 49 83 c4
RSP: 0018:ffffc900034bf570 EFLAGS: 00010246

RAX: 0000000000000000 RBX: ffffea0005ceb100 RCX: 0000000000000046
RDX: 0000000000000002 RSI: ffffffff8e4b7f70 RDI: ffff888172cdbb80
RBP: ffffc900034bf6f0 R08: ffffffff825c6656 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8eb5a120 R12: 0000000000000000
R13: 1ffffd4000b9d620 R14: dffffc0000000000 R15: 0000000000000000
FS:  00007fd3c0fc7c80(0000) GS:ffff8882a8f45000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30763fff CR3: 000000017395c000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 6 bytes skipped:
   0:	df e8                	fucomip %st(0),%st
   2:	96                   	xchg   %eax,%esi
   3:	dc 69 ff             	fsubrl -0x1(%rcx)
   6:	48 89 df             	mov    %rbx,%rdi
   9:	4c 89 e6             	mov    %r12,%rsi
   c:	ba 40 8c 40 00       	mov    $0x408c40,%edx
  11:	e8 e6 bc ff ff       	call   0xffffbcfc
  16:	49 89 c4             	mov    %rax,%r12
  19:	48 89 04 24          	mov    %rax,(%rsp)
  1d:	4c 89 e0             	mov    %r12,%rax
  20:	48 c1 e8 03          	shr    $0x3,%rax
* 24:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1) <-- trapping instruction
  29:	74 08                	je     0x33
  2b:	4c 89 e7             	mov    %r12,%rdi
  2e:	e8 09 bc d7 ff       	call   0xffd7bc3c
  33:	4d 09 3c 24          	or     %r15,(%r12)
  37:	49                   	rex.WB
  38:	83                   	.byte 0x83
  39:	c4                   	.byte 0xc4


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

