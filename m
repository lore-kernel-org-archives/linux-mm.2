Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A1D7CD1297
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:50:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94C3C8E0008; Wed, 12 Nov 2025 10:50:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 924508E0002; Wed, 12 Nov 2025 10:50:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 860D58E0008; Wed, 12 Nov 2025 10:50:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9968E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:50:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BE3B12DED1
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:50:11 +0000 (UTC)
X-FDA: 84102391422.23.2FF528B
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4B6C52000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:50:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3sKwUaQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3sKwUaQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=3zTsXzAL2O8FBHRHQuZTZdGfLgKf82AqMuTf8WBrX6k=;
	b=3ImnZsOJWbmCD1sp0PmZglFmrSsd358x/NESdc+P0d8fzM5FHiS6IiDSARoIRrsvssaFf5
	CQci45d6A7FNuweGEKXqcO8gKnfn4g0rK/Z0cXGzT3cw6DN/FRNnQ5dTwvWBmxDu+l4b/v
	T/rokn0ynYFJAoPf5r38OEaVSj/3GFk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3sKwUaQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.198 as permitted sender) smtp.mailfrom=3sKwUaQkbAKsdjkVLWWPcLaaTO.RZZRWPfdPcNZYePYe.NZX@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962609; a=rsa-sha256;
	cv=none;
	b=4oXQLJvwoIi1xy9I7xISUIwB0vK2JoNj6ZxbSAbGtrYZO136n3TydtMpjNAK2w057/7X8L
	qK+9XGY6wLoMFbxSzVLtcTWCM4hRFS4r/M8aJ02ATFhliqhNTjlkF87GaLQ9NtkuelGacA
	5HP/TIAb/JLYMHzh2dT5qqGBY+Dwv7k=
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-433199c7fb4so8927145ab.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 07:50:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762962608; x=1763567408;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3zTsXzAL2O8FBHRHQuZTZdGfLgKf82AqMuTf8WBrX6k=;
        b=GkfzGoSE9VNl+neBkVFO6k8JZfqzW//UhLyMaTTy6RyFaLf192N98orxWk/5qu/11z
         wrzrJt2+/CokTp04XiFm9OSgoUj0ajj3m7V1gHjP0U6EeM1kxhvJFiQSAP9YyGh+SWPO
         zyQvGGamDEFV/dEmzg2jnRf1o2cT6lFefI4Bw0n2E5uQyeppvBcSF33a3tuRrRB55Oql
         ZqjwjwHwlqC2rWdYgF6o5SWUSvn9Vy5vpMgG+8NYmlHW+CAhtiqxnrlki0tEilbgqdzM
         Ayki3tay3r/EfvlXQc8y6QZvpeSOzmOcOH4VANo5nMZXErlVklgWjGU88XEZXFuT/UoM
         q2LA==
X-Forwarded-Encrypted: i=1; AJvYcCX+FopdZ3wyLP1n/yCtGiUwGtDYETjhfm0FtoCrdbsgjw7EYA6ifDZmZn8MjXCopaUvguUcRfiWnw==@kvack.org
X-Gm-Message-State: AOJu0YzHDMNMndmnxPWVeac8TXOrKBTJaRJVMS3lDZTbeYcBd6aDivdF
	/1AVx+v/5omKzwqmB8qGqh7NluBcknnpXxFshcwjhjZcwnXMTwwPyGc68CkcDh1XESWd0rkNnnf
	NPpI/r0i4QHkwU3KP3LK2QPdvzCIT6GPq8DsOOVUTgKCG59LJ9DBAy6rUBYc=
X-Google-Smtp-Source: AGHT+IHmXHfyTAC7o3gX451a5IIahr28v38z8/NoQnIggiwkPwHCChNJsSaHf6XMCJZzy1ZplwASB2f9wVZN0PHDzjagie+boMEe
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3521:b0:433:481d:fd61 with SMTP id
 e9e14a558f8ab-43473d92995mr43099555ab.18.1762962608328; Wed, 12 Nov 2025
 07:50:08 -0800 (PST)
Date: Wed, 12 Nov 2025 07:50:08 -0800
In-Reply-To: <cover.1762945505.git.ojaswin@linux.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6914acb0.050a0220.3565dc.0004.GAE@google.com>
Subject: [syzbot ci] Re: xfs: single block atomic writes for buffered IO
From: syzbot ci <syzbot+cie14707853a77f22b@syzkaller.appspotmail.com>
To: axboe@kernel.dk, brauner@kernel.org, dchinner@redhat.com, 
	djwong@kernel.org, hch@lst.de, jack@suse.cz, john.g.garry@oracle.com, 
	linux-block@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-xfs@vger.kernel.org, martin.petersen@oracle.com, nilay@linux.ibm.com, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, rostedt@goodmis.org, 
	tytso@mit.edu, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4B6C52000C
X-Stat-Signature: pycdopbyy3hdhwnhqccmadjn34u3xtzk
X-Rspam-User: 
X-HE-Tag: 1762962609-911295
X-HE-Meta: U2FsdGVkX18UuDarkF8JO0mcCpCgOGTXeyGeWy8f51q85BArmUwjxbxlHjSaLWwikYMtTHT4BroAe8PwVdv7fuu9ctTRBhIjSI1swGMqfhWTtOzY9A9VGk9dbWFYmjwCTJo3eFSXGsG6VVSOJRTRDQdM5qI7xvAfDLqUE/USIsLvz+vaicb7gN2NqBBDsQcwXF4fZUB3agS7EA5jdgYUQNEfF6NQtZpWLV1cKWpWxZfN6aX/0txuQojS89FoyeojGhPkNHp+lS7l9D7Zr9km6P77Go95JaPLXTN1IAFfwX0DWVbMQRZW1EoFY0Wj26Hzjn7TSuqn2gywpaA3KzHY/SEqKPpKOgMH0vCCNdovMp/SpAyavmzyckLeulyFTNctSlv86YsjYyl/zQpUtw6C6DOcM7Yd2cYRJayWdzrib4eUEmn8T4YDWslN1CRcGmXQ+f890QJotWSdsT7Pbe0kz0BDsqGTeQ17XEZEN5kbW+Dr5aDY+2YyYCAdJrhix21Z25ItpxHUCxlKWRvqAVRgcJDWm7SEPNPADVvkhcD44zlULirTT5s02VLg++oOev3ussyDMIpfUi5DiqzqhkvsSaBYDLz2jIUAczUGpeYRcSRsoJgfxRvdvcBXEYNVHMHCgcEz2WxhkH1ka2axdWg7nSwAR4TNP16tXJju+zG+YhJOIHxoEUhr3houGtsx+kqH10AflcchsxnP0EPJC67kvWgdVbrNDsBTd3DJcVrz0NarLtfowWdQJ/Fy/iiXR08xBbEfA/YqqGCJbCA4etTmIYFa7pwZx9QXXezBLdIN0viCigueKAl0eLmAyyX9XJoiP78Ul0ViC0KPWdvuv7CR5vXqwigmk6ANmbY6dJ69TPnkYPnWaLgTDZYDaWnTttI6LB9fENxGWqYJgtl3X9hw+FgMW2gYcwNUQctiYk8t1unWyiDssqXMhFw3G7NWZgLizKQsGhs9u/culCkQdkm
 LfsAwz6G
 K8JsGsRrcR/D+5H6Xqo1yzsxtbieKw5ylYK49UJb+Pz4Q+69V/Q7RC0RkMNow7gH0Eug3sGCL0iNGpW2KrCSDkD0ckcFZeh/DL6ilxX36i0nVJjpios4JiT4K9NH6IlwujoEJZcUxzoVHlpWQ3Vfglwv5ncx2kXBBTJKcjNVn4NWUT6OiYY+RJkhOoUYxqMscgXKJSxevnbI3e//GQG3gjQFamVp0ZEBoJXwk428AD0fg6+52Swu/4W2PWOfozDHnYh/6bwyjkSghN28Zrb1LJCj391Sr8RvIM2asG7F6+j+KFLS/Jjqnhkzk/ia42hI27c5jNkOtA374iF1cIK4JNlWPCI5Fh18gb9Hy2lBJJj+C3oY3O4nVapdxPrePJUhZcU3vZHMw/plgNpgeClyKnDsEZggtSibggMLtOoWHH136AhHPRfXKEMOf1D0sw7lFHvXcUyD8PnNV76dCUzqSYduWXJlbdTf62HZgqfCis21YlK6QDAS/hT3vhB8AnOuJ5/yXN3+tjKXS9xYWkBxaqUMY//kR+tibHodfLsHaY3v0jPWLM075uzKFKU7xTJ9iwsZJTfD0B7YlF3VAPhj/8/lgidkQDx8iNzIjfkTyxsIzcqya4EBC1cyy67e7rbUX2x0gwQXr75lD9RmCKl52R6ty+sc0p0uAK9SuqLVLw1FkZnzjkhBriSJfk/GIJmqbY3z+OD8B8KmSf9L74HLSJlNo7duLEoWehio5B++cz8R/Zn/6b5jfEq+tjKBZc3LS0C9ifeAsuFPo0qaD4VY8Qs9mYTFYuPfjJYlyxVlQpzXz/psKs6fBKBXws0aJz/+f/htcRzXahqHvMOuBJdDHvLIx+SgxjQSjEul069nV7MWAVliGHMusoZtBFMYFG7jGzKoK4xSt+EKmVho4mOaN7fz1Kge8kc9sKJ6TxxUl56kX1+8yVNxAmiqhVD6TX1NgzmGtTEXbDItS161uqCbXdENAwGlA
 eSCXSMye
 Y5VC9xJ0Zk/EZW7sGYCKW/G/W3lwoJuhoYK2SDu8l8leVG7eXHJxPlSBBU1jeUZYcCpBAdfklZbw3sFoYZp1bQnUHhqXOFVzwJ5N25kT+Uw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] xfs: single block atomic writes for buffered IO
https://lore.kernel.org/all/cover.1762945505.git.ojaswin@linux.ibm.com
* [RFC PATCH 1/8] fs: Rename STATX{_ATTR}_WRITE_ATOMIC -> STATX{_ATTR}_WRITE_ATOMIC_DIO
* [RFC PATCH 2/8] mm: Add PG_atomic
* [RFC PATCH 3/8] fs: Add initial buffered atomic write support info to statx
* [RFC PATCH 4/8] iomap: buffered atomic write support
* [RFC PATCH 5/8] iomap: pin pages for RWF_ATOMIC buffered write
* [RFC PATCH 6/8] xfs: Report atomic write min and max for buf io as well
* [RFC PATCH 7/8] iomap: Add bs<ps buffered atomic writes support
* [RFC PATCH 8/8] xfs: Lift the bs == ps restriction for HW buffered atomic writes

and found the following issue:
KASAN: slab-out-of-bounds Read in __bitmap_clear

Full report is available here:
https://ci.syzbot.org/series/430a088a-50e2-46d3-87ff-a1f0fa67b66c

***

KASAN: slab-out-of-bounds Read in __bitmap_clear

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      ab40c92c74c6b0c611c89516794502b3a3173966
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/02d3e137-5d7e-4c95-8f32-43b8663d95df/config
C repro:   https://ci.syzbot.org/findings/92a3582f-40a6-4936-8fcd-dc55c447a432/c_repro
syz repro: https://ci.syzbot.org/findings/92a3582f-40a6-4936-8fcd-dc55c447a432/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in __bitmap_clear+0x155/0x180 lib/bitmap.c:395
Read of size 8 at addr ffff88816ced7cd0 by task kworker/0:1/10

CPU: 0 UID: 0 PID: 10 Comm: kworker/0:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: xfs-conv/loop0 xfs_end_io
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 __bitmap_clear+0x155/0x180 lib/bitmap.c:395
 bitmap_clear include/linux/bitmap.h:496 [inline]
 ifs_clear_range_atomic fs/iomap/buffered-io.c:241 [inline]
 iomap_clear_range_atomic+0x25c/0x630 fs/iomap/buffered-io.c:268
 iomap_finish_folio_write+0x2f0/0x410 fs/iomap/buffered-io.c:1971
 iomap_finish_ioend_buffered+0x223/0x5e0 fs/iomap/ioend.c:58
 iomap_finish_ioends+0x116/0x2b0 fs/iomap/ioend.c:295
 xfs_end_ioend+0x50b/0x690 fs/xfs/xfs_aops.c:168
 xfs_end_io+0x253/0x2d0 fs/xfs/xfs_aops.c:205
 process_one_work+0x94a/0x15d0 kernel/workqueue.c:3267
 process_scheduled_works kernel/workqueue.c:3350 [inline]
 worker_thread+0x9b0/0xee0 kernel/workqueue.c:3431
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Allocated by task 5952:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 poison_kmalloc_redzone mm/kasan/common.c:397 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:414
 kasan_kmalloc include/linux/kasan.h:262 [inline]
 __do_kmalloc_node mm/slub.c:5672 [inline]
 __kmalloc_noprof+0x41d/0x800 mm/slub.c:5684
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 ifs_alloc+0x1e4/0x530 fs/iomap/buffered-io.c:356
 iomap_writeback_folio+0x81c/0x26a0 fs/iomap/buffered-io.c:2084
 iomap_writepages+0x162/0x2d0 fs/iomap/buffered-io.c:2168
 xfs_vm_writepages+0x28a/0x300 fs/xfs/xfs_aops.c:701
 do_writepages+0x32e/0x550 mm/page-writeback.c:2598
 filemap_writeback mm/filemap.c:387 [inline]
 filemap_fdatawrite_range mm/filemap.c:412 [inline]
 file_write_and_wait_range+0x23e/0x340 mm/filemap.c:786
 xfs_file_fsync+0x195/0x800 fs/xfs/xfs_file.c:137
 generic_write_sync include/linux/fs.h:2639 [inline]
 xfs_file_buffered_write+0x723/0x8a0 fs/xfs/xfs_file.c:1015
 do_iter_readv_writev+0x623/0x8c0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
 do_pwritev fs/read_write.c:1153 [inline]
 __do_sys_pwritev2 fs/read_write.c:1211 [inline]
 __se_sys_pwritev2+0x179/0x290 fs/read_write.c:1202
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88816ced7c80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 0 bytes to the right of
 allocated 80-byte region [ffff88816ced7c80, ffff88816ced7cd0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16ced7
flags: 0x57ff00000000000(node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff888100041280 dead000000000100 dead000000000122
raw: 0000000000000000 0000000080200020 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 1, tgid 1 (swapper/0), ts 12041529441, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
 prep_new_page mm/page_alloc.c:1859 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3920
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5209
 alloc_slab_page mm/slub.c:3086 [inline]
 allocate_slab+0x71/0x350 mm/slub.c:3257
 new_slab mm/slub.c:3311 [inline]
 ___slab_alloc+0xf56/0x1990 mm/slub.c:4671
 __slab_alloc+0x65/0x100 mm/slub.c:4794
 __slab_alloc_node mm/slub.c:4870 [inline]
 slab_alloc_node mm/slub.c:5266 [inline]
 __kmalloc_cache_node_noprof+0x4b7/0x6f0 mm/slub.c:5799
 kmalloc_node_noprof include/linux/slab.h:983 [inline]
 alloc_node_nr_active kernel/workqueue.c:4908 [inline]
 __alloc_workqueue+0x6a9/0x1b80 kernel/workqueue.c:5762
 alloc_workqueue_noprof+0xd4/0x210 kernel/workqueue.c:5822
 nbd_dev_add+0x4f1/0xae0 drivers/block/nbd.c:1961
 nbd_init+0x168/0x1f0 drivers/block/nbd.c:2691
 do_one_initcall+0x25a/0x860 init/main.c:1378
 do_initcall_level+0x104/0x190 init/main.c:1440
 do_initcalls+0x59/0xa0 init/main.c:1456
 kernel_init_freeable+0x334/0x4b0 init/main.c:1688
 kernel_init+0x1d/0x1d0 init/main.c:1578
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88816ced7b80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
 ffff88816ced7c00: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>ffff88816ced7c80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
                                                 ^
 ffff88816ced7d00: fa fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
 ffff88816ced7d80: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

