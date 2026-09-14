Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B38C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 19:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68F346B0088; Mon, 14 Sep 2026 15:17:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F316B008C; Mon, 14 Sep 2026 15:17:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E66C6B0092; Mon, 14 Sep 2026 15:17:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 12CC76B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 15:17:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AF53A497E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:17:39 +0000 (UTC)
X-FDA: 85213327038.12.B04B915
Received: from mail-oo2-f6.google.com (mail-oo2-f6.google.com [74.125.231.134])
	by imf20.hostedemail.com (Postfix) with ESMTP id C826F1C0003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 19:17:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3UEioagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.134 as permitted sender) smtp.mailfrom=3UEioagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789413457;
	b=8otIPNfdM3tHAq5DJ7uXTF1IJ8ALZKwptDucWCL+8fOoizP8ln4AOvpfgYSqOzADnRJ7Np
	COLT+q4ByGPBPFnZlUl7VnabyeF9u3gHz3R0H5S7jDRxbsi42JwRKrkx3nAeXyJ/QJQohX
	O99cjraQXn9Zb/VUVnIa3FQWgtN8ib4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3UEioagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 74.125.231.134 as permitted sender) smtp.mailfrom=3UEioagkbAN0RXYJ9KKDQ9OOHC.FNNFKDTRDQBNMSDMS.BNL@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789413457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=ekHSujZ932WooFHmacuU20SolwiHbECmUQMmL2g+luU=;
	b=NW0/Nch/S58b+6OquSEHbYc8OZNQahdmwcjBmWu4sYi6bx6o8VAKNKnftgYxXpBQtGj1Bg
	5ZHuV7OUC4uUISQrOVr4yocraX5Lb6gcVZgBadMvGaMidRJtVj9hbtKps3tAg6bdSfLLsg
	qkCyZ5R/S8bgo95BGCobuwnEhllaSyg=
Received: by mail-oo2-f6.google.com with SMTP id 006d021491bc7-6aafac56856so1238468eaf.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:17:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789413457; x=1790018257;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ekHSujZ932WooFHmacuU20SolwiHbECmUQMmL2g+luU=;
        b=HMmAtFXUexXI7fQGzX27pPewdh5AFhesSmeJcBGbiHIi7bS6dd/9N456OSALgERNZd
         2PH1WQkzkywygg2qOh3ZrlQJ2lC9/JG/7COQc5be9s8ROFPADFSQK6GHgFmCBki3kK7N
         hf7X4XQfWZSGxEmWEEw9u46Lcr4wKvaFRGHk+cHsccO7TX0VUD+XphehYeIPtIHXyR65
         tYD2N7uB/6QMpSyQPSDoviLRYn7iJTv9rGQ47N/sUzpWdMNK2xDNltdL9y0ShFmZ8qyS
         Fzw/XwUGpvVVRLqABCeSSG8WmhGROY9+0p15VXHcNN5/oOqyG/V0a2aSC40w0hIrdS57
         JDsA==
X-Forwarded-Encrypted: i=1; AKwUvBxsJkEHWGkGNWysZOclqnoiJBho0/y28x3jcBCjIE83kOpu3YqlkxYXKwWZoQsd1t4dIeX0irAxyQ==@kvack.org
X-Gm-Message-State: AFuF++kc4LBEYo7npWyv7F2zhhWovYd8TJxZIX2HogswwDrWuVK3NBPc
	xBhZEhIDQA8SQ2OY3cLYct7XVQFjUajql2pmcwpnZWxe11HDeECw6aVo1Tltd5qbd+RjB4uFLvo
	UnkifFyxVVRvOHmOX1WkheJmZz39BUZiKB7c72Mxc+9rFIcbmoUSsj3daoDY=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:221f:b0:6a1:77ce:1b09 with SMTP id
 006d021491bc7-6c53ee55e0cmr3296277eaf.6.1789413456943; Mon, 14 Sep 2026
 12:17:36 -0700 (PDT)
Date: Mon, 14 Sep 2026 12:17:36 -0700
In-Reply-To: <6a1b9770.fd5edf16.2e7427.0008.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa84850.f81106d8.2ab401.0053.GAE@google.com>
Subject: Re: [syzbot] [ntfs3?] possible deadlock in page_cache_ra_order
From: syzbot <syzbot+8bd419f88e25ab12cb75@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, almaz.alexandrovich@paragon-software.com, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ntfs3@lists.linux.dev, syzkaller-bugs@googlegroups.com, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C826F1C0003
X-Rspam-User: 
X-Stat-Signature: moycuwzfe8di6nynfxg1s839z5mebjzz
X-HE-Tag: 1789413457-719884
X-HE-Meta: U2FsdGVkX19wtywb19NTsp1O7Qy39y6ImuHlbqOBffdrsrqXMyw+XzZycjeeAPoFyD0XoQc8ij0Gzh6Kw83MKB7vlNVSbkFPOsgAvAtG5BS+z3wF09R4pR8e1N2n92ZQLQTZ4VBLucvUEqbHbdOOmd0k1WBQsXJ8EutQ+w9RvknEBBQ+hFC0ny4wWCfSbnA847uzwtqk3M+9M70Dou/Fw3hBz0baTCn7Vnzha37QZINWQ1IZ0k1uVmIy9Oj27cjIwmo5EIXZ7Bd2Nb6R/O2rTIU3nG3qwLfV8/wzqUGQ2zgw2G+vYS6x5sf2yqebu4qyM8NpRoQDZySfZxdvBRnUCOl60gCBA4+uJv84hNeo1DleR1+ytfoPUnqNKxUViTzJ9Ond1zW8ucswtNyOhiR9TTzyLk11aBLH2rIgM39hWjatMc2c9mpNAN92gvgUuMPn8VuWYSdOkoyCH+RI3oUBzag49WR83OUNDZ/dgqHB07Auw1B/y5Cne38u5te48xzLjuVlmdp9I6LxgVt+cFo6LdllaGzBP6pl8lAZUFSrUQ3jn/PsqIWaGEq57AZZJgY39ghNe6i7BTD3rDy1pVocd+UapWy+8wT0XLU+a5sQIe7crCPWwPpsuuE6d5ySPUZeNIn0LYlj9eXEDQy1+SLHSKQOz8GwWvNM0y5N/OezuFrH3bgFNNeL31YG74d5mLNzc6vHslWOsSPhNzSHxmhyrt5etQ+xuLOurWt+mV1iS28c3RbrVLk1WyniC17h3Gp+5blOpq++T9JHaQg1UhOoiGF3kPJQI9LqAgf896zL4eW/B05bbMiwIpVYrTrFWIW2ryxaHNPdJLRWGYLYpp1zPq+x5NItHaYIi/ftvO5DH5s95QgaYmjZ2JRaU2uaLByEf8TPewIippwwGKSQ+8Ax4ru6x1Ghk4ajIQ1vl9oXh53zaupZr1p/Uq8Z8RHMfrj/IDTHEui7Rhg1cqxVK61
 8j1dnMF/
 /eTeYIc+vq7rovAE5uY0SjNqf8oM50EO4XmGnNw10kd2S8bgltHmLf5WLDF/ikwZTC2w6E/gHngY4Yg//DaFYcbAtvrA1O8aD1KBOgarh2zTnMCDguxmkeFnEiUgxGpt55HYBw6Wg8UA7q7AN4/yXJI/zBn6+ZqBqo4AJtEF+JvIEs8c6K6MLUWL4Y6DREd6OCRVlej+EcymkSr6CCSEmLjFrkZkkCsWKlqpcMkXQaeRbmEcnBx520Y+vKHT3Fk9bblXI0vl0/7+/cA03vI8Wb6BO+OkQwdU5CQESaKYuEzHdUL/tnGb/lWoSQPfdc1CSicZspPmlPJ93iuN50J5bV5grsQGoxuTktvpo8S15Hh2Kh8VoLm5JaEWhbcYcxgqAYpHdzWXbc+mA7ZFl4ho0ULKnVq55A9eQJA1By55kiWG2RM/0yZaTQoREKfFysDTX1s1W5SIfxX2/f0b+o9ckpPXrXuFBVKHaWoIoKHVzc++w1nOFjOo1mCDTlyoYq1hdm/4s+0Ph5UXG6AsmJIUembUaAblxvMt8ygXIwPgz3C8PEYK4+jezDR1iEdFQ4ion612Q1VEQoNJmdJ0X/zWoZZEZtyn3Ornue58RCycsPAV9mQAVviiCDLvlOzlXm7XcNUlPWCDuG149dTbfMtIjOAH53aIKMbKXhqn9DJoQwQMInmzsfP4G1M5hvzXyC+Wb+Tbjd/oyTOLwK2sd72IuIKV/veYTxRzOkzmzKFWH4qYZu7o7QxUgFOJOaJehF1YHA9AjLxrS6q+oo1yoyQrCWJT5YDJgInWpQULkI2UggZvSeU5C9bYPx+MUjYOIvG/DaTSZrnCDUW211CiST3vfxwRbSevtLrflyD2w3nOpeJQxLz4JAm4CyOvO4jWA4NNIrMybWhebeqZaGL0mJ0Aa2aHOPX/Xr0xz0G7VQq3saPuhM6ACXfnKIOESJwaTu//VyEVyPXWBWiAF6oBTi/hzahJ3FGcI
 YrN6rUIJ
 EbmjxY/wC9j+SYc8UuTKgsinWEZZut/MYt0WyjzKvbr6sG5MU97RYnwcUifCKDFwfZDkAfVKBTlm/fTEf0TAufAp9pfeRRTrnWEw2GJ2Gr61N+SEpiosdomFQ7lblcIiIRyLTzXg1vJFxMWUnyAdS9CJIpfA95T7RCdyZu9AXig2QcpSE5kN4H4U8BgoFo1B/ZgywcefjAjEFrARRJsIfKdLFSncV0TLzic/zYlzH7Pr3fD3sGopSIEnjcRK/J66IbH+fis8w5IiGK1KEWBAjnsIJ1ZEUzK0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    704340f1cd0d Merge tag 'x86_urgent_for_7.3-rc4' of git://g..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=14118df9580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b454dc6b1b7acd30
dashboard link: https://syzkaller.appspot.com/bug?extid=8bd419f88e25ab12cb75
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154788c9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=134788c9580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/a1f812f889ad/disk-704340f1.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/8aa4ccae83ac/vmlinux-704340f1.xz
kernel image: https://storage.googleapis.com/syzbot-assets/8f86a50bf181/bzImage-704340f1.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/54fd657ced87/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8bd419f88e25ab12cb75@syzkaller.appspotmail.com

ntfs3(loop1): ino=1f, mi_enum_attr
ntfs3(loop1): Mark volume as dirty due to NTFS errors
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.1.68/6182 is trying to acquire lock:
ffff88803364abd0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
ffff88803364abd0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: do_page_cache_ra mm/readahead.c:347 [inline]
ffff88803364abd0 (mapping.invalidate_lock#3){.+.+}-{4:4}, at: page_cache_ra_order+0x2b1/0x4a0 mm/readahead.c:558

but task is already holding lock:
ffff88803364aee0 (&ni->ni_lock/5){+.+.}-{4:4}, at: ni_lock fs/ntfs3/ntfs_fs.h:1247 [inline]
ffff88803364aee0 (&ni->ni_lock/5){+.+.}-{4:4}, at: ntfs_readdir+0x717/0xf70 fs/ntfs3/dir.c:541

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&ni->ni_lock/5){+.+.}-{4:4}:
       __mutex_lock_common kernel/locking/rtmutex_api.c:561 [inline]
       mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:580
       ni_lock fs/ntfs3/ntfs_fs.h:1247 [inline]
       attr_data_get_block+0x1cd/0x2c0 fs/ntfs3/attrib.c:976
       ntfs_iomap_begin+0x4f0/0xf30 fs/ntfs3/inode.c:978
       iomap_iter_next include/linux/iomap.h:382 [inline]
       ntfs_iomap_next+0x5b6/0x880 fs/ntfs3/inode.c:2319
       iomap_iter+0xe2/0xec0 fs/iomap/iter.c:122
       iomap_readahead+0xa4a/0xe80 fs/iomap/buffered-io.c:751
       ntfs_readahead+0x193/0x210 fs/ntfs3/inode.c:880
       read_pages+0x193/0x5a0 mm/readahead.c:174
       page_cache_ra_unbounded+0x679/0x8f0 mm/readahead.c:315
       do_page_cache_ra mm/readahead.c:348 [inline]
       page_cache_ra_order+0x2c1/0x4a0 mm/readahead.c:558
       filemap_get_pages+0x493/0x1e80 mm/filemap.c:2714
       filemap_read+0x429/0x11e0 mm/filemap.c:2824
       __kernel_read+0x4d3/0x970 fs/read_write.c:532
       integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
       ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
       ima_calc_file_hash+0x45d/0x8a0 security/integrity/ima/ima_crypto.c:280
       ima_collect_measurement+0x521/0xa10 security/integrity/ima/ima_api.c:300
       process_measurement+0x1282/0x1c20 security/integrity/ima/ima_main.c:425
       ima_file_check+0xe1/0x130 security/integrity/ima/ima_main.c:685
       security_file_post_open+0xb3/0x260 security/security.c:2755
       do_open fs/namei.c:4839 [inline]
       path_openat+0x148a/0x1d60 fs/namei.c:5000
       do_file_open+0x23e/0x4a0 fs/namei.c:5029
       do_sys_openat2+0x115/0x200 fs/open.c:1417
       do_sys_open fs/open.c:1423 [inline]
       __do_sys_openat fs/open.c:1439 [inline]
       __se_sys_openat fs/open.c:1434 [inline]
       __x64_sys_openat+0x138/0x170 fs/open.c:1434
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #0 (mapping.invalidate_lock#3){.+.+}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3209 [inline]
       check_prevs_add kernel/locking/lockdep.c:3328 [inline]
       validate_chain kernel/locking/lockdep.c:3952 [inline]
       __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
       lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
       down_read+0x97/0x200 kernel/locking/rwsem.c:1574
       filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
       do_page_cache_ra mm/readahead.c:347 [inline]
       page_cache_ra_order+0x2b1/0x4a0 mm/readahead.c:558
       do_sync_mmap_readahead+0x4d6/0x7c0 mm/filemap.c:3443
       filemap_fault+0x7e2/0x13c0 mm/filemap.c:3597
       __do_fault+0x138/0x2a0 mm/memory.c:5565
       do_shared_fault mm/memory.c:6064 [inline]
       do_fault mm/memory.c:6138 [inline]
       do_pte_missing+0x659/0x28f0 mm/memory.c:4700
       handle_pte_fault mm/memory.c:6558 [inline]
       __handle_mm_fault mm/memory.c:6707 [inline]
       handle_mm_fault+0xf64/0x28c0 mm/memory.c:6876
       do_user_addr_fault+0x746/0x1340 arch/x86/mm/fault.c:1394
       handle_page_fault arch/x86/mm/fault.c:1483 [inline]
       exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
       asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
       stac arch/x86/include/asm/smap.h:-1 [inline]
       filldir+0x29f/0x630 fs/readdir.c:286
       dir_emit include/linux/fs.h:3607 [inline]
       ntfs_dir_emit fs/ntfs3/dir.c:388 [inline]
       ntfs_read_hdr+0x8a7/0xc10 fs/ntfs3/dir.c:429
       ntfs_readdir+0x9ab/0xf70 fs/ntfs3/dir.c:589
       iterate_dir+0x2f1/0x4e0 fs/readdir.c:110
       __do_sys_getdents fs/readdir.c:319 [inline]
       __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
       do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
       do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&ni->ni_lock/5);
                               lock(mapping.invalidate_lock#3);
                               lock(&ni->ni_lock/5);
  rlock(mapping.invalidate_lock#3);

 *** DEADLOCK ***

locks held by syz.1.68/6182: 3, last CPU#0:
 #0: ffff88803c3c2328 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x252/0x320 fs/file.c:1259
 #1: ffff88803364b1a8 (&type->i_mutex_dir_key#8){++++}-{4:4}, at: iterate_dir+0x215/0x4e0 fs/readdir.c:103
 #2: ffff88803364aee0 (&ni->ni_lock/5){+.+.}-{4:4}, at: ni_lock fs/ntfs3/ntfs_fs.h:1247 [inline]
 #2: ffff88803364aee0 (&ni->ni_lock/5){+.+.}-{4:4}, at: ntfs_readdir+0x717/0xf70 fs/ntfs3/dir.c:541

stack backtrace:
CPU: 0 UID: 0 PID: 6182 Comm: syz.1.68 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/24/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
 check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
 check_prev_add kernel/locking/lockdep.c:3209 [inline]
 check_prevs_add kernel/locking/lockdep.c:3328 [inline]
 validate_chain kernel/locking/lockdep.c:3952 [inline]
 __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
 lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
 down_read+0x97/0x200 kernel/locking/rwsem.c:1574
 filemap_invalidate_lock_shared include/linux/fs.h:1089 [inline]
 do_page_cache_ra mm/readahead.c:347 [inline]
 page_cache_ra_order+0x2b1/0x4a0 mm/readahead.c:558
 do_sync_mmap_readahead+0x4d6/0x7c0 mm/filemap.c:3443
 filemap_fault+0x7e2/0x13c0 mm/filemap.c:3597
 __do_fault+0x138/0x2a0 mm/memory.c:5565
 do_shared_fault mm/memory.c:6064 [inline]
 do_fault mm/memory.c:6138 [inline]
 do_pte_missing+0x659/0x28f0 mm/memory.c:4700
 handle_pte_fault mm/memory.c:6558 [inline]
 __handle_mm_fault mm/memory.c:6707 [inline]
 handle_mm_fault+0xf64/0x28c0 mm/memory.c:6876
 do_user_addr_fault+0x746/0x1340 arch/x86/mm/fault.c:1394
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0010:filldir+0x29f/0x630 fs/readdir.c:288
Code: df 49 29 ef 48 b8 00 f0 ff ff ff 7f 00 00 49 39 c7 4c 0f 47 f8 bf 07 00 00 00 44 89 f6 e8 e9 35 7f ff 0f 01 cb 48 8b 44 24 20 <49> 89 47 08 48 bd 00 00 00 00 00 fc ff df 48 8b 44 24 40 48 89 03
RSP: 0018:ffffc90004cf7ab0 EFLAGS: 00050293
RAX: 00000000000009e8 RBX: 0000200000002050 RCX: ffff888026543e80
RDX: 0000000000000000 RSI: 0000000000000005 RDI: 0000000000000007
RBP: 0000000000000020 R08: 0000000000000000 R09: 0000000000000000
R10: dffffc0000000000 R11: ffffed1004ca87d1 R12: ffff88803ae8a000
R13: 0000000000000005 R14: 0000000000000005 R15: 0000200000002030
 dir_emit include/linux/fs.h:3607 [inline]
 ntfs_dir_emit fs/ntfs3/dir.c:388 [inline]
 ntfs_read_hdr+0x8a7/0xc10 fs/ntfs3/dir.c:429
 ntfs_readdir+0x9ab/0xf70 fs/ntfs3/dir.c:589
 iterate_dir+0x2f1/0x4e0 fs/readdir.c:110
 __do_sys_getdents fs/readdir.c:319 [inline]
 __se_sys_getdents+0xf1/0x270 fs/readdir.c:304
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe25947e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe258a9c028 EFLAGS: 00000246 ORIG_RAX: 000000000000004e
RAX: ffffffffffffffda RBX: 00007fe259706180 RCX: 00007fe25947e159
RDX: 0000000020002078 RSI: 0000200000001fc0 RDI: 0000000000000007
RBP: 00007fe25951503b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe259706218 R14: 00007fe259706180 R15: 00007ffeaad84d78
 </TASK>
ntfs3(loop1): ino=1f, mi_enum_attr
----------------
Code disassembly (best guess):
   0:	df 49 29             	fisttps 0x29(%rcx)
   3:	ef                   	out    %eax,(%dx)
   4:	48 b8 00 f0 ff ff ff 	movabs $0x7ffffffff000,%rax
   b:	7f 00 00
   e:	49 39 c7             	cmp    %rax,%r15
  11:	4c 0f 47 f8          	cmova  %rax,%r15
  15:	bf 07 00 00 00       	mov    $0x7,%edi
  1a:	44 89 f6             	mov    %r14d,%esi
  1d:	e8 e9 35 7f ff       	call   0xff7f360b
  22:	0f 01 cb             	stac
  25:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
* 2a:	49 89 47 08          	mov    %rax,0x8(%r15) <-- trapping instruction
  2e:	48 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%rbp
  35:	fc ff df
  38:	48 8b 44 24 40       	mov    0x40(%rsp),%rax
  3d:	48 89 03             	mov    %rax,(%rbx)


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

