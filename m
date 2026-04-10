Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E06EF36BB8
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 06:45:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546A86B0005; Fri, 10 Apr 2026 02:45:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F7AF6B0089; Fri, 10 Apr 2026 02:45:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFA76B008A; Fri, 10 Apr 2026 02:45:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 280B16B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 02:45:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B323313AC06
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:45:46 +0000 (UTC)
X-FDA: 84641710692.21.5E2CC00
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	by imf26.hostedemail.com (Postfix) with ESMTP id D701414000C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:45:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3l5zYaQkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3l5zYaQkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775803544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=qA3Bgec08hHe18kFcoPSxtNLaAedK6oXug7a4v0vhyU=;
	b=B519VK44KiZf+xY/KhDXQ7Gf+w2l4ogAIF/nsy1ShlKOX5e1wISY/K4l5tSEybruPbYxjW
	XaXDIiHT/NM9j62lvZjnlRk909YvDPHjuoOKbmEak5K5nVBZk6+ZRSNGyPzp+SVsBtXZfn
	qDKgnWGgZUD6ASmWK4Pn9Ob4Lz4c9+M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775803544; a=rsa-sha256;
	cv=none;
	b=x2MUAURlkBWPJQx3gEBjW68xadPpGgswJqu9fRXCe1RZoHTx6SMR1hU9zA53/YIP89f6EV
	FryO7xyxpayZmKL3dUkNf1r2/873Nzx9PvJKOKlvtsAhR8vJeukICAN2gEZ7CVmPQivqED
	0oYs0yVpFL8nf6X0OaBCiAuUDWgrRj0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf26.hostedemail.com: domain of 3l5zYaQkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.71 as permitted sender) smtp.mailfrom=3l5zYaQkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7dbe0e914adso2398263a34.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 23:45:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775803544; x=1776408344;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qA3Bgec08hHe18kFcoPSxtNLaAedK6oXug7a4v0vhyU=;
        b=HNSi5baqKM2LYz631OFAEY++cWfUZlysr002+EY/E2zmQCjuAjnnqo0mQOc1HhcWE2
         wJYux/I6SvtcYnVAd37yTT2+Pkv7pAjdBGAfgawQf4keKTk09+tS5DD9yBGFhKovfT8O
         Ez80/5e4S/RnAzbjI69U32VMn1v4uA3MvDcwwdXevOcU7kTmEsR/KLmajwbs9OM3ekfg
         /4tmep4m+utCNhfRNaqP7T7VXoT9eV3skUlqIgktPOq5k/pldreZlcVi2hHUD2Jshlkm
         iDz1nOLcBvdmsyW/7cS1j9vBAANB0SM4la/3vnhg1Gx27EHxp+EgdshfMrDKve4Yv2Fd
         VLiA==
X-Forwarded-Encrypted: i=1; AJvYcCVYNPiBZqbcx8V0HT4QCev3AQLIZMViyYFuBYj0D/Qn9NCxd0Ou+VmWVzbuwkswxJaLERFCrqrYMg==@kvack.org
X-Gm-Message-State: AOJu0YytrmF0g3hLDS5FiY/PAGV4+8aymgkxB9kK2+H87k5u4bZtT9MT
	fUwwSau+as4eGr32cU/jx2hbNeZKpxXVffTK/4IyhUHjwcj2ELwzmB7PA7aaUDQT9ZpPKf9vhWR
	nXgVfRd54pSdJPPopa2HF3L0YrVdKuwfIZWrp0BdfEw9CnepfRzoAamIjiWU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2015:b0:682:52b9:e779 with SMTP id
 006d021491bc7-68be90cdf17mr1051890eaf.64.1775803543859; Thu, 09 Apr 2026
 23:45:43 -0700 (PDT)
Date: Thu, 09 Apr 2026 23:45:43 -0700
In-Reply-To: <20260409234158.837786-1-jane.chu@oracle.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69d89c97.050a0220.3030df.0026.GAE@google.com>
Subject: [syzbot ci] Re: hugetlb: normalize exported interfaces to use
 base-page indices
From: syzbot ci <syzbot+ci1ddebc06ab8137f5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, corbet@lwn.net, 
	david@kernel.org, hughd@google.com, jane.chu@oracle.com, 
	liam.howlett@oracle.com, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, muchun.song@linux.dev, osalvador@suse.de, peterx@redhat.com, 
	rppt@kernel.org, skhan@linuxfoundation.org, surenb@google.com, 
	vbabka@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D701414000C
X-Stat-Signature: b87wwro77aa96c9i43ht8z3cpwrbnucq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775803544-96272
X-HE-Meta: U2FsdGVkX1/epJ5H8nqBWEJyvT/lZBaHMPdBWoDR/RwyYEzP6xBAT6g9c4btjo1yN595z10A/to9e2h/u6u8Bs8W9lIpMhpmpSR+DYPpNMqb9QyHv3n9t2IEnRddIolm4AYl8nNzvyLwdHS7Bo60W0rIh5iTr7GL/ve19bMTjMvBdyhv96U2YvcCspvGFykSPOaumhryi79WnJxdJ+76X7WXQjmGdL0PPzp4my7nmmC0BgyQwgwqqFgJgB5hjYasMyaDWRiOdkVEEh8JCx5oY8JjeaNkAsDXI/flMpUTY0JT0v+0Vvg+WIJl/ugy8Z4y6qeqAjsBeT9kOE+jE3SfjX76Xdph/qZ8YjRTIqCVuxq60sut62KcXXBSRrXcchn/sxiWaDg51td4Acc2qYDZYa8yWqAU7T2FnjYckwdz8FBfVDRQh6asLYGVJb5uSYIjfZXBBKV+ymirhGXZtjh5Yb8T2DIN2T/fOdkmHZMmti9E20oVAVc+kw95Rs6FIW3J6qp2v/6ConsGQlW7hMFhzIFJyd6y5tMgZv8+/GGiTWsJf3JOythjr9csmrthyzhGhcWi7vJ4oDYbpuRuyR5vgzFsK5AHHkOhlEKCG55XRYF4pRniWQY6xMlWARMxZzrgDKye4bwKv4WMeo/OAPjAvKMhm02yJUk4kk9GGxF3uOjBACHZFu6DFVIkQSPIIw+sjy4KnUH1oXrTeibofX9433BBvvJkUYLuArIckPq2U/+Td/8Wpcg2tPTk+pjM5DrscVnHs0TmIhfBnnzLVa6vTOXlfMX9NCVEPy7KfMbJWXJFNhvJEexbM5kb3Ih8T58b8yKhKkBZAJnKLePlnw88BEGMyEW3RtVkFjteopMdhb9/NiQt/BDkaucfkxHh9vsFf/6CVi1iKjs2GGco+eu2pKT6OjZNDnnLbeL3MR4rJc8cMM51+lkMZA83tl7eWtb0QolGRKMHdA+1oqFNTJR
 Pk2qBb4V
 bcpKdItudjH9dYDE/RGXreLR3+FtMJBzpZrrwwv9kWVIVyIlJI/156HbEfy5JfRJ63wAwWg18O/mmHys/qztEXXRT9Pr3s4eDCdo26CVVs/ZKaOm7k8nwZSc/PembRG24LNZw1qjBV3OtZ9oT5+rkc29ncwLZ7AW6/25vuou8ukU0rVQ5Lk9YRf2lfCqzw8iLpxk3sQqnw7kMgLMA7LlclGkv6slAj1Y5T9ILNVug3jypN+dcf2zNtAko+/TOzbJPbUY7axhZafQs4xtLqmicTgJWFZSA17AmJyMEBP25txeHnX1AbZNcZbAUm2MSpXc7RdQ/h9RHIVMxVS0rKgdUVXltqwuIn/VSX6UJbKXlrjW0UPPsNQDymCQo4NamRTPoJDXvz9g3Xt3xzcsEmNlwVle2BiTLXj1TcKhrQ6u5jIhKDxMbVtpsVH7DOVtmM5uvHC3Kqed/qPw6J66/jx7Cvc5VuK8P6AvCeipeqdNr0HoQTfAaWFmL0R8/etskUaIz3jB80wQlVjSL/Tl1apxSuQuL9ThxSZnpFuSlzpPFzHBW4BBVzzp9rJjZLrqIVFr3f1FHSgfaIX481SJqI1K7A+nffgzEMzqDSNAndehxnkkd/FcxW0+ujUr0Bfrmn+S0I1FzQpay2db5uA0o3qIGcssDWeRk2hmCZ2DfZfHrks2+WKygET+K41r60qlpr3LaLhx4uuLh3K3C0i3C7BKaA5VdlXwkD/s48xW8UNG2BUSy0DA4KO2ku9hjjk0+VORsjBlTV3IX3wTaMAXl7KY6FHbXmrx62/AQrZuzZOPoumpqYHl4uZz4DhBbwxhv68p2rQyrFOmpSJP5Apu3Ctbhv0yIQMAZ2nvUKbucJOwN9ps0JsDzFbcYpBYFRzTmZV2lzKR/KHmri/7l1Qvo8ObVWptSIRRaLFQ78LUI0CatZOgjL39lFym8Lk4Q/SsDvnZPzOPLv03LeWEOZ0mmvQu5MKVI33VI
 jaYRBC+u
 vVKL1ebmNsGxsizXUAEAbkqpiv5lZy1R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] hugetlb: normalize exported interfaces to use base-page indices
https://lore.kernel.org/all/20260409234158.837786-1-jane.chu@oracle.com
* [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index conversion
* [PATCH 2/6] hugetlb: remove the hugetlb_linear_page_index() helper
* [PATCH 3/6] hugetlb: make hugetlb_fault_mutex_hash() take PAGE_SIZE index
* [PATCH 4/6] hugetlb: drop vma_hugecache_offset() in favor of linear_page_index()
* [PATCH 5/6] hugetlb: make hugetlb_add_to_page_cache() use PAGE_SIZE-based index
* [PATCH 6/6] hugetlb: pass hugetlb reservation ranges in base-page indices

and found the following issue:
WARNING: bad unlock balance in hugetlb_no_page

Full report is available here:
https://ci.syzbot.org/series/95c5ba82-0135-4026-b7c7-b0819e1ca4d6

***

WARNING: bad unlock balance in hugetlb_no_page

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      06a6cfb92448a97ef429a7fbd395a20a9d388acc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cefe8576-3c99-42d3-9b51-1e70d62a64a7/config
syz repro: https://ci.syzbot.org/findings/3a14cc12-14a8-4fac-9614-ae7ae2555e58/syz_repro

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.0.17/5971 is trying to release lock (&hugetlb_fault_mutex_table[i]) at:
[<ffffffff8229b876>] hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
[<ffffffff8229b876>] hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
but there are no more locks to release!

other info that might help us debug this:
2 locks held by syz.0.17/5971:
 #0: ffff88816b85fb88 (vm_lock){++++}-{0:0}, at: lock_vma_under_rcu+0x1d1/0x500 mm/mmap_lock.c:310
 #1: ffff88816079e338 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: hugetlb_fault+0x317/0x1440 mm/hugetlb.c:5991

stack backtrace:
CPU: 0 UID: 0 PID: 5971 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5298
 __lock_release kernel/locking/lockdep.c:5537 [inline]
 lock_release+0x248/0x3d0 kernel/locking/lockdep.c:5889
 __mutex_unlock_slowpath+0xd3/0x7d0 kernel/locking/mutex.c:938
 hugetlb_handle_userfault mm/hugetlb.c:5686 [inline]
 hugetlb_no_page+0x1986/0x1da0 mm/hugetlb.c:5770
 hugetlb_fault+0x67f/0x1440 mm/hugetlb.c:-1
 handle_mm_fault+0x2007/0x3170 mm/memory.c:6716
 do_user_addr_fault+0xa73/0x1340 arch/x86/mm/fault.c:1334
 handle_page_fault arch/x86/mm/fault.c:1474 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1527
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0033:0x7fa742251964
Code: 41 89 00 31 c0 c3 b9 40 00 00 00 bf 40 00 00 00 eb bc 0f 1f 40 00 48 89 7c 24 f8 48 89 74 24 f0 48 8b 7c 24 f8 4c 8b 44 24 f0 <8b> 4f 50 8b 47 58 4c 01 c1 41 8b 34 00 8b 11 21 d6 89 f0 8d 72 01
RSP: 002b:00007fa7431fd018 EFLAGS: 00010212
RAX: 00007fa742251950 RBX: 00007fa742615fa0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000400000
RBP: 00007fa742432c91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000400000 R11: 0000000000000000 R12: 0000000000000000
R13: 00007fa742616038 R14: 00007fa742615fa0 R15: 00007ffe952c6908
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

