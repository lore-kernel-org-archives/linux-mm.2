Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 753A5D49C71
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 08:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46646B0005; Fri, 30 Jan 2026 03:15:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFD416B0089; Fri, 30 Jan 2026 03:15:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B54526B008A; Fri, 30 Jan 2026 03:15:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A2CDC6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 03:15:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 203E41A046B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:15:50 +0000 (UTC)
X-FDA: 84387921660.13.9B11361
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf16.hostedemail.com (Postfix) with ESMTP id 66C18180006
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:15:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3s2h8aQkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3s2h8aQkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769760948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=qjZJFidfuPaGPPsT9xGXhj3/F6iB36JosaLjL7mn+G4=;
	b=Vgr/hkf0X+f/Q5m2d7ThcDo0lbpGnV4OfewHN7rzz/VCdRE+64ce22X83t1g9bMs7Vasb6
	wTJZSuWeYvKHEG/orn14huXkPSJpLGXDSV+esbZA8x0HOIU9ifW4UFhAKuf816UsCJYlmP
	1qtPk8IZyuSn3B7xPOkE0YG37eu5YdI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf16.hostedemail.com: domain of 3s2h8aQkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3s2h8aQkbAMg6CDyozzs5o33wr.u22uzs86s5q217s17.q20@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769760948; a=rsa-sha256;
	cv=none;
	b=UsELwwH9cYc/hoHO4nGkHB/hZJ5yCleGFc1tbmHXsLOnz8SDWrI01f8aGUJlsGXNInwf82
	+KBiNXmtvKeGd5/MSCN7jH9+OUHKJmk8tgKSBntBCg44RdmymGRi7Qle2FbJzG070ZvM2t
	xpLEE5aQL6w84Mpw28mbaS41dMfL6G8=
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6630ee9fb15so2587888eaf.0
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:15:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769760947; x=1770365747;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qjZJFidfuPaGPPsT9xGXhj3/F6iB36JosaLjL7mn+G4=;
        b=Kin8jWBYTn9nBBllfZUvoQd3OK86JyH7MPzl3se1htKpLArR1eupJ74mJW1amW7BfT
         p9FEV/CUrYEyJh4a6w6K7OB94nPJ6toLQl8zmvV1iJj4I1777xemG5NRMeNvONZBiAUD
         eiZAmlHjeH4pg3hv0pkmlLgpR8ZNVRaUiG4hLfVQXejDbofrrjGcyWJfUYzkdM6fw/c1
         SPRdf6OadlnwfqbElmilVukvk9kx/8nSIDT6AIg+LSlPfwA6sF4aeqNTgKEd3c6Q2EAs
         ZwczKlzY9NoRqJw0i7VPfxsYCl6jYPZlHEIiTd1mlJ8d+rS7iUfpc0IFKJIQasNo58QA
         JuSw==
X-Forwarded-Encrypted: i=1; AJvYcCUm9+uyq/LqrxL0matLgPNLVx9sC1EUY0JvZINDDu1eSf+oxQyydii2HamF/8FdNdN+rw1WdfUDzg==@kvack.org
X-Gm-Message-State: AOJu0Yz4Q1d9e7WfLmhoZb4qDrFe2Ks7mWeNlpr/9S5xisy5hzAC4Tn0
	5KAg5A7mxLzc6wzysIf+81t+9B1b5HpJqkPmKfhrPiqiu8ziCrnJF6R9aXzhgb/5i8zKjUYxE4u
	JyMFVufCqLm6aqKE81/il7BJMLkP5rlhv/vbhdW1ASQvxhVviuIltYxHhaFw=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f05:b0:663:23a:caf4 with SMTP id
 006d021491bc7-6630f0317cfmr888270eaf.2.1769760947492; Fri, 30 Jan 2026
 00:15:47 -0800 (PST)
Date: Fri, 30 Jan 2026 00:15:47 -0800
In-Reply-To: <20260130034818.472804-1-ziy@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697c68b3.a70a0220.9914.0032.GAE@google.com>
Subject: [syzbot ci] Re: Separate compound page from folio
From: syzbot ci <syzbot+ci7f632827e1b1c91b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, axboe@kernel.dk, 
	balbirs@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	david@kernel.org, dev.jain@arm.com, hannes@cmpxchg.org, 
	io-uring@vger.kernel.org, jackmanb@google.com, jgg@nvidia.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mhocko@suse.com, 
	muchun.song@linux.dev, npache@redhat.com, osalvador@suse.de, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, vbabka@suse.cz, willy@infradead.org, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 66C18180006
X-Stat-Signature: q4zzu5ebu1rbee6d85hkhyxeq34gg3hw
X-Rspam-User: 
X-HE-Tag: 1769760948-772329
X-HE-Meta: U2FsdGVkX18E+lKio8ckXljh/RjRHqrNxmdPpnfB10wayZ3kF4UizCv6jYvymwK7bpCpBnZHrYRPXh2sRsL+/VeAz6S4nCMRb8TGGKcWUiP/CWgR6VygKl/Q2SOgaYjuBJXcZZHBc0R4kRovUqqiDEFikIWFBpWnqzA/yPZffLujhbciIAVQXV1Wfa3Ccbc+YvDCSjm2LmK7PwcPvMS0ueGf3AVQFvAjmSnesOEx9EjGe8TxtuxEWmtoYeBmiMNi7LsZE7dFwu7E5Hd3shJ2G9kawwAQfzSt03KKyfkPEDu1PTYnQqIqVYNRW19A2cA+Lg/M6LJtgEyjvRP+djhekHfe9sPZRczMHT66+VkOOlrjQcTvaNRPEGnKUgfZUOQ1TMSYMoMvc1oH7lTX5TiYY3xib3K8WJkEWHY1S140I/+pgG+YOf+EtEzb3f1wcPJ/73wb14nHWa5gh4eZEps/iAOItlG+3wjipf4nwuawGg2Q2jVRpO/m93iQKHBKP2Ysb7+5YLOsY83gsmuHbYKRN7np5gpecI2ffeg8we//qmXdaFrmpKOyP+Enc/0gC756AjUNGK4Or1xMdeR5NwkdvOCX5km9w1BOhxjAR0qUCVz5qgJUbXw7iCkE1Yrr9KxqUBJDRiSx71nokLRn7w1+owVy8n/0eqbOcWRY/86baiDtOURZk7BLWMCF/TQs+6tVOgg+QmmjuNe9mRD24ELhPQ2FffC94wisLQsI1L5xVFnGP2ZcnOuXgUZkE+QxVBXj4n7a53qxg3jH3znIQ46gmsgKo1on8CgF+5BxsteqWUpzRLjYLLnrIFLTcawOzoc8M1XP4oz6S9kixTviszIYcjlovSIsvqgr6UltBGy4Hr8dz4TG8iV+we2KEeNkgIpiJgm9FtyAP6xK7AL8ZIKCtGN3sTMWEXE9IHFYgzWZd4rT6FZA1UnkCiVbo281kg8cL/BaHySZNha0Ioofafn
 dguvlDyo
 0q0ZQf2BLcr2sSubyqtWQV3BGX/Fs5VrdKtDD20j0cY0jQELhH23L7Um5YatIbCMuXIkX0QzgYOxYWmo44l6u53VxF1Dba2P+Dx2QK8QPD6Uxz4UOgUSq+Qhd6TA8x6imt+9JlwlP4H98rBNKAFJl64vdzcNn/Kc53sTUG6dtyK7k1zXz4hmPprCrVpXempJqBeS3Q8nOCBiWWty0Yodzww5XWOWZxztYj3gyRyd9H6qIm2W9hJvk8ge/KMMFMf9mfPH2Kyc0ncu0ZViNCBYHxwPgqYmNNeGHhTGPm4Q4kWVOuIi7ZVbpq6aare2RK4LclTCV4c6tcG5Y0PxpPZVSvwBf5ZzwXYnbMYM6B71+kOHWT3Xf2PZ9BKwvFQi01Xd6CmF15BfGsgjfu5fXKdXc0vEkkGWTMXMqhN0hryJD/R4Wb2KupItGd0Chb+1y9Bd13DDXJaLvq9bPqH1g+9IhyMYfO0M8gLYCZbVj9J2fvllVGRoRzBscmoFKpIvWI9wF72TEPhG4uUhltA9IqdqXRJemP+pGSxtxuNaO3wxPXmR2o6Czp7JvkRHLke5orvmX5/D3mzR90s4iZcHxbCJavKmoY2AIElM+tIWTBu8SxqcxsTJKR9kU51Ix5BwwKdfGTyeFCnRk0HMy1C/G1GudnLjDiDL2rDBccVEqtuIijI5UusPWkj/RAeYX/AVhwrEmGhOw+mxSfBUM0sm4Ielf4gMB0v9b0NQMZp0P/eFfiHmjBECZxe1MyAFdL5uRUw/mV3pdU0XIo15WAD43upCodDytPJDXYWtOByE2CSnjz9HF7hUq9g6JaGiV/ytl4QAU7x9QFYZ7gDvgi+ngMIzeRF2xI2KgR9KVlOc0IyCWxDKE8NJNgmaLNVYFFiEoyBwzXnybfvwzW55PY0ZHWu9Mof0gyxyuOS3RGZDRMy1glE8RkncSr841Wv5ske2CvTCpjZbujysdayt4zEagNwhDSZnjOmjh
 /etf+IEq
 f/tHcxIqqEp+fN2MOIKYSaW+HGFPJInj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] Separate compound page from folio
https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com
* [RFC PATCH 1/5] io_uring: allocate folio in io_mem_alloc_compound() and function rename
* [RFC PATCH 2/5] mm/huge_memory: use page_rmappable_folio() to convert after-split folios
* [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid deferred_list handling
* [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compound_order()
* [RFC PATCH 5/5] mm: code separation for compound page and folio

and found the following issue:
WARNING in __folio_large_mapcount_sanity_checks

Full report is available here:
https://ci.syzbot.org/series/f64f0297-d388-4cfa-b3be-f05819d0ce34

***

WARNING in __folio_large_mapcount_sanity_checks

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      0241748f8b68fc2bf637f4901b9d7ca660d177ca
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/76dc5ea6-0ff5-410b-8b1f-72e5607a704e/config
C repro:   https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc02851/c_repro
syz repro: https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc02851/syz_repro

------------[ cut here ]------------
diff > folio_large_nr_pages(folio)
WARNING: ./include/linux/rmap.h:148 at __folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linux/rmap.h:148, CPU#1: syz.0.17/5988
Modules linked in:
CPU: 1 UID: 0 PID: 5988 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linux/rmap.h:148
Code: 5f 5d e9 4a 4e 64 09 cc e8 84 d8 aa ff 90 0f 0b 90 e9 82 fc ff ff e8 76 d8 aa ff 90 0f 0b 90 e9 8f fc ff ff e8 68 d8 aa ff 90 <0f> 0b 90 e9 b8 fc ff ff e8 5a d8 aa ff 90 0f 0b 90 e9 f2 fc ff ff
RSP: 0018:ffffc900040e72f8 EFLAGS: 00010293
RAX: ffffffff8217c0f8 RBX: ffffea0006ef5c00 RCX: ffff888105fdba80
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffea0006ef5c07 R09: 1ffffd4000ddeb80
R10: dffffc0000000000 R11: fffff94000ddeb81 R12: 0000000000000001
R13: 0000000000000000 R14: 1ffffd4000ddeb8f R15: ffffea0006ef5c78
FS:  00005555867b3500(0000) GS:ffff8882a9923000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000000c0 CR3: 0000000103ab0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 folio_add_return_large_mapcount include/linux/rmap.h:184 [inline]
 __folio_add_rmap mm/rmap.c:1377 [inline]
 __folio_add_file_rmap mm/rmap.c:1696 [inline]
 folio_add_file_rmap_ptes+0x4c2/0xe60 mm/rmap.c:1722
 insert_page_into_pte_locked+0x5ab/0x910 mm/memory.c:2378
 insert_page+0x186/0x2d0 mm/memory.c:2398
 packet_mmap+0x360/0x530 net/packet/af_packet.c:4622
 vfs_mmap include/linux/fs.h:2053 [inline]
 mmap_file mm/internal.h:167 [inline]
 __mmap_new_file_vma mm/vma.c:2468 [inline]
 __mmap_new_vma mm/vma.c:2532 [inline]
 __mmap_region mm/vma.c:2759 [inline]
 mmap_region+0x18fe/0x2240 mm/vma.c:2837
 do_mmap+0xc39/0x10c0 mm/mmap.c:559
 vm_mmap_pgoff+0x2c9/0x4f0 mm/util.c:581
 ksys_mmap_pgoff+0x51e/0x760 mm/mmap.c:605
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5d7399acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe9f3eea78 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
RAX: ffffffffffffffda RBX: 00007f5d73c15fa0 RCX: 00007f5d7399acb9
RDX: 0000000000000002 RSI: 0000000000030000 RDI: 0000200000000000
RBP: 00007f5d73a08bf7 R08: 0000000000000003 R09: 0000000000000000
R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5d73c15fac R14: 00007f5d73c15fa0 R15: 00007f5d73c15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

