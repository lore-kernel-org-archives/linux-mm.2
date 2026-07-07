Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E6CC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 21:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A43E26B009F; Tue,  7 Jul 2026 17:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1BBF6B00A0; Tue,  7 Jul 2026 17:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958156B00A1; Tue,  7 Jul 2026 17:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6976B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 17:32:31 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D00DA405BE
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:32:30 +0000 (UTC)
X-FDA: 84963279660.12.B407D97
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id 28BDE180004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:32:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3bHBNagkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3bHBNagkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783459949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=CcAmkyIYzqbWxUmxnwuS6djFxqJOxca0P9ZAUz5a2Yk=;
	b=5akdZazhJlcJ5mBig8ZqWb8sN39GdGhqGODUDZnTqernQdKYhRdbWX7jGCPJAacAoqVyhC
	l+JoMI3mI5O9Tx4gvf8DOKciFi1OaZxMGH4mw6UpY63A4sOdZ23XzH+yRPsyevi7GyenFc
	HxY3WOx/LA7nEf/QN+/JT41OYjMqRco=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of 3bHBNagkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3bHBNagkbANsPVWH7IIBO7MMFA.DLLDIBRPBO9LKQBKQ.9LJ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783459949;
	b=qROx0Vx3aTJlAzVqVRXsN8aS3IfkyOXzHQAm/1r/KCL35mxtEnlvLCQR0/O8VIUleDiCN2
	hnrf18QK0e4Nzq3DPm1ucIs2QD5j0uQv/4odo5yXsFcdnH5CZRXqEVB12HNzogydkR8mw6
	QW4WzNJLS5gWQPzQ8mi7RZ9fJXHA8Bc=
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-495f7693e7dso54883b6e.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 14:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459948; x=1784064748;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CcAmkyIYzqbWxUmxnwuS6djFxqJOxca0P9ZAUz5a2Yk=;
        b=PVIq9dbE/hVSJnUOjqk8Xxo+MZE5xvDJ6/sMojQxQTsIabZpxmUt4ddOp/eTkSrpO+
         Xk8qr0dUpmCmdH3EsPfIMFk2yt9WOmvuTnJhN6R85zMSeeR+hkEOonYfCz9lp5rc2bzd
         xoDpXSQaCgRziCgDHtFblePTApCsYAYiGx56folUAIt5Ax97LL9G/c7SQmDnigSMxFCr
         +y1wjSSLseUSdCmR/m8la+ZOicroR99YFd7g1a9lSBX7YMW/rAz5+SZYNUbYIGl6RaO8
         RgCv2iKFgOoolu9iPcSp7+oJYJ15XbEhnbKXiPrf7oj342rZg4h77CZRHZ3HhdPw5//R
         ZdNw==
X-Forwarded-Encrypted: i=1; AFNElJ/FSE62GQ8FQe0Oeqd3UU9cXS2JhSu1hytMnTET5D/f2f9EQbPBTKJsjYws4g0SZ+rJ6sK4/xWITg==@kvack.org
X-Gm-Message-State: AOJu0YysbLOGjFNpTIF5QmgQZjgwBk9YOXQdjYX9IZDHyAHulR84KUJ7
	eZE6suKi+jpol0QDLD6R/TokkEoTbpA90jggJLIrM+K1XzKtLC+4fsvqsvnPNfSNYUBtwPthPBU
	NsKRlX/UaFEcT4KAbm1xlA0HALdyfCt+NGUcAuB3jAFqaxwF35SuJceMdzt0=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f92:b0:497:9dec:13f4 with SMTP id
 5614622812f47-4a078131fd0mr2831666b6e.4.1783459948284; Tue, 07 Jul 2026
 14:32:28 -0700 (PDT)
Date: Tue, 07 Jul 2026 14:32:28 -0700
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4d706c.c76b52dc.34afef.0011.GAE@google.com>
Subject: [syzbot ci] Re: mm: store zswap entries in swap table (Pointer entry)
From: syzbot ci <syzbot+ci8a06015641ba192f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baohua@kernel.org, baoquan.he@linux.dev, 
	chengming.zhou@linux.dev, chrisl@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	nphamcs@gmail.com, shikemeng@huaweicloud.com, yosry@kernel.org, 
	youngjun.park@lge.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 28BDE180004
X-Stat-Signature: 6j4qpd8ttekqiixon4s4tjdqxtduhm4a
X-Rspam-User: 
X-HE-Tag: 1783459948-572074
X-HE-Meta: U2FsdGVkX18eruOR8UjRFTcS5DA7cG2IosrsE8IdMUqzVdZwPFuhERYz6Ro5p6Mv5f5oNCnu87msWco8ubuxtc8xknOM0p0jt1CKIUf32Um+anI7VnKuf3Ikhb1/rk4feGq2znqMH5jyZlNINBxzKN/LGiNUyJoVEOPX+TyoY4DjoXLx9qYxVrKfCiDiAhS/4dnKYRMgQu6NlQe8c3lQ/2V6ZEwfLvRniSWNGzD/uyC7Ik1c6dmAcJJtd6J5xDPi5kXR+goSmLFfFJ+RNxASKHrIXU+idf4wx1vuFjnCk/aZf7cdfyr2zZMy5Ioj8x+dWd6A+ypWThLHE42KVvAFtX7+e66GXaLCT1nY0W3o+e95e9ux+JnSZFrFZYGfStONYxXctGR6aJl/bUkXKxNmjALocc0XBSEDTfxUaiD0kMmg1AGuUkQg4iOQ/FwIr+SGp/RnSDgibp27kPeuv1et30jY+rVjDD37LFaBh/aDMxlJoYUKc9XgGNW4/1GpmJgJ5qf/IQJ0fu+gjSUVW/dqA1/E9cnO7YIyW6oD7Byi0UWL2nOSF/IkX6m+JnCZrzUyt9hxUG78LqVYz3i5Ig38Gf2aGaLgviRjINmYtOZPL08zE3RfmxySYpF9PnAlyPcByttYseoEMHeUD/0ji0sYsLe5Gf1elKEAeCKqWD7olZEwySxGj6s2CcB7BMy1Xo1suDQeQPZ85put2WPolmma+Vpk7G8lTHgAO8n7872buIKkcel9ivElmzXSANimlBMydRfe8wJEJ/etocq4z7RB6XDcWjKIy3NdEW7b+NE5XNj3l8FSMlrscgjbSJd2gXDeFrojdrUN8RNlNTgUXsN0jMUvSB+EfqfUSGQb7/h6HPeVT3LMiEBnmJHbigU/yqEKQT4q70/p9SDH6w6rGRSijEHdCR7splZWZmWbesE0pwP6b0o1zlhdq5z5EyszL3M81DhfYukWby69AUVvifB
 vD1I0Fbs
 Ken+q7mb9v4eOqRAknAyzXyUyoZ6B40Oo1RwMtGSIToDZtcqdkfF6HlkJquG8I8K8ABk38TYFDXECqZsYJeIvJuKaPajDjc0ykV3kB0k+UbmDhXTGr6att4XvpLABNelC14suZa18pH/ytH1eC/T7QcH498uRgGude+cPdgDNxTX1DOJOTAJvl+N9RifbGl36vVhT3py7A+2OJBEzJaL/DikN/GiHDyUPsETQ5H2ZYTxOh9+KYqqWdq+b9dor9E6Q755SN/46aAaUBpxVlUGc4QrDb1NebmGiKIzDiXxx/LlKaKznyfm3F3t/TMgN3AarQxxcI8JhMcFuv95UgnVSbQMUO4RJHWW4C+Oa+tQPE14rIsjyPYkQiJycyV1fOc/Z6IXJy39jhnfBZbqElnUG78fzfQ/6MFJLQYqRRepJRo3dHEKMGyuOI7k8AhAJPtpk3PAzXKL+oAaCJ4/OeNsuQfOtiNom3ed6uOolCW2pdCN5wsTfgBVD7dpzySaZmbyUOIxJz0Z0iboX2j9XdfOaIeZ7G6g3hfOoYPp/l5GxkCVONnT8eoahw0lqYqYAqqhVuA/IdOveUWh12LoV7/yL1f+FQonHSDG+Edu2j5gcpPtcD8r7kGxLkNEtwDkEJl5PMrvdfqXHRje8/eHsm7Xgka2r93aHsO+tVwhmEul4yEHXLkKqLlM8gxbaOxsO1OK6z+6RhwYU2EE4T/tbbRC1IjzHT1k+RBjOdlXEStHxp/037KZvWbT3y+DNxUZDthnh0VqITKLeWnLX8teKf5S6oEzp5s+8ELD6y6aSpMutJp5HCig0ythIH1BVlFROXhdYlK6wsGajndCca7Ishv1AbaCQnS24xnWqLGJM6QhHH4yixeQ3rCQbmjiiGrA2l6CDAYZT+h0KTJvos8o8YAR5urkhFqei7HvDASamKotko6dDNtEbysnC65Zy0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: store zswap entries in swap table (Pointer entry)
https://lore.kernel.org/all/20260707073215.72183-1-baoquan.he@linux.dev
* [RFC PATCH 1/7] mm/swap_table: add Pointer type support for zswap entry storage
* [RFC PATCH 2/7] mm/zswap: add swp_tb_val to zswap_entry and Pointer accessor helpers
* [RFC PATCH 3/7] mm/swap_state: do zswap conversion in __swap_cache_do_del_folio
* [RFC PATCH 4/7] mm/zswap, mm/swap_state: handle Pointer entries in add_folio path
* [RFC PATCH 5/7] mm/swapfile: handle Pointer entries in count/dup/put paths
* [RFC PATCH 6/7] mm/zswap, mm/swap_state: migrate zswap to use swap_table for entry indexing
* [RFC PATCH 7/7] mm/zswap, mm/swap_state: replace xarray indexing with swap table lookups

and found the following issue:
WARNING in __swap_cache_do_del_folio

Full report is available here:
https://ci.syzbot.org/series/1a9cfadb-ed85-48c1-b1b3-a3c12ea99471

***

WARNING in __swap_cache_do_del_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      01bc0932614c2d3c35e732f54d249b5897d94307
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/65f10583-d539-4b33-8ba9-494d42eb9593/config
syz repro: https://ci.syzbot.org/findings/3673912c-5490-4f26-ba24-276021c43d9b/syz_repro

------------[ cut here ]------------
!swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) != folio
WARNING: mm/swap_state.c:327 at __swap_cache_do_del_folio+0x6ef/0xdf0 mm/swap_state.c:326, CPU#1: syz.2.63/6057
Modules linked in:
CPU: 1 UID: 0 PID: 6057 Comm: syz.2.63 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__swap_cache_do_del_folio+0x6ef/0xdf0 mm/swap_state.c:326
Code: ff c9 48 09 c1 4c 21 f9 48 39 4c 24 08 0f 85 8c 02 00 00 e8 73 9a 9b ff 49 bf 00 00 00 00 00 fc ff df eb 3d e8 62 9a 9b ff 90 <0f> 0b 90 41 89 ed 41 83 e5 01 31 ff 4c 89 ee e8 2d 9f 9b ff 31 ff
RSP: 0018:ffffc90003ea6690 EFLAGS: 00010093
RAX: ffffffff822acdb9 RBX: 000000000000001f RCX: ffff88816d7d9e00
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffea0006be5f08
RBP: 00000000006be5f2 R08: ffff88801c7d20ff R09: 1ffff110038fa41f
R10: dffffc0000000000 R11: ffffed10038fa420 R12: 0000000000000000
R13: 0000000006be5f00 R14: 0000000000000002 R15: dffffc0000000000
FS:  00007fef4622c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000280 CR3: 0000000176c44000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __swap_cache_del_folio+0xd5/0x170 mm/swap_state.c:377
 __remove_mapping+0xabb/0xe20 mm/vmscan.c:736
 shrink_folio_list+0x2b42/0x5350 mm/vmscan.c:1489
 reclaim_folio_list+0x100/0x430 mm/vmscan.c:2163
 reclaim_pages+0x2f1/0x530 mm/vmscan.c:2196
 madvise_cold_or_pageout_pte_range+0x1c1e/0x22e0 mm/madvise.c:562
 walk_pmd_range mm/pagewalk.c:148 [inline]
 walk_pud_range mm/pagewalk.c:239 [inline]
 walk_p4d_range mm/pagewalk.c:280 [inline]
 walk_pgd_range+0x100f/0x1e40 mm/pagewalk.c:321
 __walk_page_range+0x16d/0x720 mm/pagewalk.c:429
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:733
 madvise_pageout_page_range mm/madvise.c:621 [inline]
 madvise_pageout mm/madvise.c:646 [inline]
 madvise_vma_behavior+0x2922/0x4340 mm/madvise.c:1357
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fef4539ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fef4622c028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fef45616180 RCX: 00007fef4539ce59
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fef45432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fef45616218 R14: 00007fef45616180 R15: 00007ffcd47ce068
 </TASK>


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

