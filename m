Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2DB8606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 19:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78FA6B084C; Tue, 24 Nov 2026 14:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29B46B084D; Tue, 24 Nov 2026 14:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F5C6B084E; Tue, 24 Nov 2026 14:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 844AC6B084C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 14:15:50 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 690A51A0B33
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:15:47 +0000 (UTC)
X-FDA: 85470967134.12.0AF34B6
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9231C40012
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:15:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3YOIFawkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3YOIFawkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795547745;
	b=DsFhf0G4qg+oVTKCqi2C+bC0jE1jcnH3OPP7rP9thxMUIs873soq/+qgiTJ1ftItYGAvAA
	37kgECsJ9zMMiUk2ajR3uJpr0zHdxMnDC1/ME8S8TMFzijC5bRhMlUNGoaAFFOr63uclxR
	1VjfxhUAMIHsWw6e2ooRQ1DKX8OrSLQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795547745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=iVaX5nAlkBKMSj8rUpfeIOl3ibSmoRV5kmxp9WpM+9Y=;
	b=JEEVKNbPbO4Ctifr/XzyevPCRQWCbTAHDMDbrR94Zh3KPNPjpbHe96LF98f4vSsR4YE94D
	8GHNadSmn5mmYbvhClfLCbryuoc5VQnaSuOBOLy52qqNGgzLdAKqUhU3EPls/YX7t22Is9
	qBnLvN0z2gjCc9h8y0RVEJTIKQhs0ys=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=appspotmail.com (policy=none);
	spf=pass (imf27.hostedemail.com: domain of 3YOIFawkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.198 as permitted sender) smtp.mailfrom=3YOIFawkbAJsNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cbf700ddccso3593582b6e.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:15:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795547745; x=1796152545;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iVaX5nAlkBKMSj8rUpfeIOl3ibSmoRV5kmxp9WpM+9Y=;
        b=06716ajdaDTKzUEGnh9GfgafqDSh/jXpCZK6JZGIiZRijuvsj6bQLN3QLfiWsQDzHt
         ay0seef/kBLKdIkXnLvAjXAxqJS4ok1+d73f6VLjtNxR+pLE05mWSPKgUmBpaTIHAK33
         sqvLA5MmY4ihRkkHZVgkQfwySsRwRV/BV5w+TQhDrtRdFcj8S/9kdhNYORMkf+jOefza
         YwufjWS9ubyo18vdltbay85FEC5bptdNYmxQyefXHJvdoJLwfeOezNtwdvR7UGH0mqQV
         Z5Rvo1mqvyi23NGQLTgJhC7fmxYLiCjVjDU7Zfw2BwA1Ehu4gyuFy+osTGM7qnxC1Ukl
         Ijxw==
X-Forwarded-Encrypted: i=1; AL+hErEgeSYk6YgMGE4igZkvLiBLLm/2a7ZaVjZsJNU+5+74yhzD93KEcqOqVvV91AwWvwITaj2rNI5S3A==@kvack.org
X-Gm-Message-State: APuU4Z8mzmepO5PlwDXjZ+UICSBOxwSyhdBCFzufoq8Q1HMyS+sCzokM
	ezhmIHRUU4iX5Pv98o4CjcL2RsrPGVBgQobRMWxXk58wElgx+3iFnKIzaNHSS7STYd+3s0cKXRd
	Hg2Zwwsz00rx+ukZYe9s6+gY7E2PXni9fyEwkTH4IHOL7+1f+eEZdKGpiAjI=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4488:b0:4d6:90f3:74ad with SMTP id
 5614622812f47-57a0b644678mr16259886b6e.45.1795547744778; Tue, 24 Nov 2026
 11:15:44 -0800 (PST)
Date: Tue, 24 Nov 2026 11:15:44 -0800
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b05e260.e1ffc79a.44bf.0000.GAE@google.com>
Subject: [syzbot ci] Re: mm: GUP dirty + ->release_folio() fixes
From: syzbot ci <syzbot+ci6dc3bd0a53405de7@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, david@kernel.org, 
	dev.jain@arm.com, hannes@cmpxchg.org, jack@suse.cz, jhubbard@nvidia.com, 
	kas@kernel.org, kasong@tencent.com, lance.yang@linux.dev, liam@infradead.org, 
	linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nfs@vger.kernel.org, 
	ljs@kernel.org, mhocko@kernel.org, mhocko@suse.com, nico.pache@linux.dev, 
	peterx@redhat.com, pfalcato@suse.de, qi.zheng@linux.dev, rppt@kernel.org, 
	ryan.roberts@arm.com, shakeel.butt@linux.dev, stable@vger.kernel.org, 
	surenb@google.com, usama.arif@linux.dev, vbabka@kernel.org, 
	weixugc@google.com, willy@infradead.org, yuanchu@google.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 9231C40012
X-Stat-Signature: 8jabpm9hf6izmizp99bgudt7f13bqxdt
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795547745-362214
X-HE-Meta: U2FsdGVkX19do2rr8tWWvf6S+MPsFlzL9bcaPCj/1Ufbc0pziPlG3nXh/kwbS7AXq0a0w6XkEg/t24hWwwANRlYjXP0H3ce4CYgOleb4z3zhW5muVsdAcImpk6Y59XzKaELlh4Ynit+JIxzejoPcgB6Pyny+8oWUEeW6lSjUYq3tLPjuwa+aLPKWTmdg3JLztWyRlwsF0PUgFs+Fx2VG5jGc9DRg57tNB52exGmUOwO8MJbyOgcZyCY3/Ys92NK+Z6vAsYI2VvXglR0xl8XlotcyqCE5su9B4bgSdTM5q3TIiksIZsaLUvaqRqwxujHz54AHXTc+sSi93mu4NR1UKE/OselPh4qJKv9c+fH2rDnMLntc9Iu3GctMQZ8I1e64Abl7H5krg6/JBtjCvfZTMc4xoqoCmPsewhaLZkabcw3WEzO4q5u6VjzwResHr3vgj1Cz99/xC524ZKfAvNGXqdQo9L2fX8ssfGyJlyjIc4PMbMMT++Am7SJk3yl7pYLFsETpo/1f157QbBpBvPoObi3UjJEt1+KBKBE45OE5A7KKekWXNd4c8A2i3lazMxE0KTN1KuKuscX7EGLTjwZ5foadr3iKASY6lajAYtCDJPBy0d+TqfOsMl5waNEvrncI4ijta1Oqm/AJii/C1xqIKLAzn8alw09AAI82qBxc53gEjeJ3b3OvCCLX+fYJj1SDE97KjQqE10NjgDPRDZGzUcSbPxlfgDgysRvytWKViktIpH2AqIsXu48yubJXA9PJ+Z9w+GxLzntsfPOqitVNLwTehgc2KHewlkLWMFGESKl+Sk6DT5IXEO9QEy9+G8dk0niykEBJ9g3CC6ZGBk8GdWZaaWDAeKnZ28QwfRT4mUFeJzbYqm4FZ+cmkZp8KjJxH2ZebDDNh1o6HLWFfLnANHS7cnpiF2+n4Y2+ore4P385+wwPCkE0OKmjBlvwbFmtI1877ifLUtLvdCZldmR
 Lenracuc
 u7Az9gHb9bV3wmNWTSzpM2FsOrXOL9QKmo3cXOL7o3kDBPuc7jy3POGHC2P/xdeNxKU7doFhhhNmjH6OFX+zi6IBqDDJJJRGr2Kg+HsXoM8LjOfwbSNmi3M7fwg2ZItHayfMUyJ6zr4tEUk9+bsh+vRaAJ/jHBLshr5AlHYeZaeYRfwNf2b0Ak2zLiiCyn1IRE6uWlBFJ40BnymoyUZAk0/7Eq5/AOgKW72ztDKO6zSBWTjoHNXllaQl7jim53BksPfXQKuagUSl3uQlVtVZP7N8TKaYXBKQOyWmqZRqV5R/Dd0knM3dEyDRTa/mTJHmGeWAE3WSP9HW1mvXxwZMM1tnnDI078cbhZwi43ef19YLvd5BSNBc8CbVSZlUy2XutcQ3s9YmcYxC8TJhV6ldEA5loWjC1wl+TReqAjWoaxpotQxU2rapc0NJWGn8DUr41Jw8jPxfnDX6Mjt6SEj6bu6Wo+YWntz/KX7Q/6ZLXtB8a62HkQz6LZn7fVpZb1UWTU+4KgV1Hy+obr7q1FnTXAXKbr+YqnwEK+UdzmERk1eIgXi7d0jkp4aFSqsu2AduGeHZoOr6pRlGnLhpvAq77JE6ei71x4VkNloPsSkL8zIil3vbb9JGWvVZkoXy8FH/Aib33rfynREuBvKHepeGNCQV3LV4nOLviOw/08sbk7eQHLo5hsH/6bCQeiPnMknTLgCm9m+y34L09aYdmXsZsxxhIuOMDInIwrR81lCIqGa85xmGIOTlb7HjHQGyryhIYowI6KNcbYKDFli9pHdDKsvB3Z9iq386BHF8d1pz/SH22Ha8YgqpWhykGwn7p8tvONnQ8Eh/VrWwufxDLMM+5Hwoe3S0sUT6VLmGNJGk6rfjRS7qAK3UixNZwsbAInU2roWyszsFFbKcMrlikCiwIs1uT2c9p0Nvs4kA7bEbKOSuZ4t+EX4q9PXbqbZbeD//TNZBVE2M/Yautj5YC4MEeiqU8BT4O
 c+27Xlwa
 j32EQw0tDiC/X5R+cTqTZ98ij6fs+hQGj6H1CQG8Y/ytwV1Re4XGRjuCMSLITsMM5r+jFdPtDgVPVi1Qz8fdAQJAsYZyvvAAc75OXCKEm27u8b1ePaDjrrDHrVJqbP/OEYNDrkfrzlA7fXwdQ/cYBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

syzbot ci has tested the following series

[v1] mm: GUP dirty + ->release_folio() fixes
https://lore.kernel.org/all/20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de
* [PATCH RFC 1/5] mm/khugepaged: fix filemap_release_folio() interaction with GUP dirty
* [PATCH RFC 2/5] mm/huge_memory: fix filemap_release_folio() interaction with GUP dirty
* [PATCH RFC 3/5] mm/vmscan: avoid releasing FS metadata for !FOLL_PIN gup folios
* [PATCH RFC 4/5] mm/vmscan: be more careful when releasing FS metadata if buffer_heads_over_limit
* [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned folios

and found the following issue:
WARNING in filemap_release_folio

Full report is available here:
https://ci.syzbot.org/series/852fc6fd-04c3-494d-a18d-4072753d5c47

***

WARNING in filemap_release_folio

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      bb7a206a3ffb0992b3600205b7cf2bcbd228d339
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/789b8ec7-0fce-48b1-bd3f-130fad443c68/config
syz repro: https://ci.syzbot.org/findings/b27d3479-eda0-470a-a735-8bde8b489eea/syz_repro

 __do_sys_exit_group kernel/exit.c:1134 [inline]
 __se_sys_exit_group kernel/exit.c:1132 [inline]
 __x64_sys_exit_group+0x3f/0x40 kernel/exit.c:1132
 x64_sys_call+0x18c6/0x18d0 arch/x86/include/generated/asm/syscalls_64.h:232
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
1
WARNING: mm/filemap.c:4574 at filemap_release_folio+0x579/0x6a0 mm/filemap.c:4574, CPU#1: syz.0.32/5940
Modules linked in:
CPU: 1 UID: 0 PID: 5940 Comm: syz.0.32 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:filemap_release_folio+0x579/0x6a0 mm/filemap.c:4574
Code: 89 df 48 83 c4 10 5b 41 5c 41 5d 41 5e 41 5f 5d e9 2c 88 58 00 e8 47 76 b7 ff 48 89 df 48 c7 c6 a0 82 39 8c e8 e8 74 16 ff 90 <0f> 0b 90 e9 00 fc ff ff e8 2a 76 b7 ff 48 89 df e8 a2 26 00 00 41
RSP: 0000:ffffc90003486d78 EFLAGS: 00010246
RAX: d29da7cf2dd17300 RBX: ffffea0006c30400 RCX: 0000000000000046
RDX: 0000000000000000 RSI: ffffffff8e935905 RDI: ffff8881720f1e00
RBP: dffffc0000000000 R08: ffffffff9014c6eb R09: 1ffffffff20298dd
R10: dffffc0000000000 R11: fffffbfff20298de R12: 0000000000000001
R13: ffffea0006c30408 R14: 1ffffd4000d86080 R15: 1ffffd4000d86081
FS:  00007f9243ca06c0(0000) GS:ffff8882a7801000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb8ff871a20 CR3: 000000016d7f6000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 collapse_file mm/khugepaged.c:2426 [inline]
 collapse_pmd+0x389d/0x6bd0 mm/khugepaged.c:2869
 collapse_single_pmd+0x1c74/0x36b0 mm/khugepaged.c:2921
 madvise_collapse+0x3e7/0x920 mm/khugepaged.c:3313
 madvise_vma_behavior+0xffe/0x4cb0 mm/madvise.c:1390
 madvise_walk_vmas+0x57d/0xb70 mm/madvise.c:1742
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1937
 do_madvise+0x327/0x3a0 mm/madvise.c:2035
 __do_sys_madvise mm/madvise.c:2044 [inline]
 __se_sys_madvise mm/madvise.c:2042 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2042
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f9242da8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f9243ca0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f9243026180 RCX: 00007f9242da8fd9
RDX: 0000000000000019 RSI: 000000000060005f RDI: 0000200000000000
RBP: 00007f9242e37fed R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f9243026218 R14: 00007f9243026180 R15: 00007fff1d17f228
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

