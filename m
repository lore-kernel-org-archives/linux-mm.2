Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93EBEE6B46
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0ADCD6B0089; Fri,  6 Feb 2026 14:27:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0866D6B0092; Fri,  6 Feb 2026 14:27:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED3716B0093; Fri,  6 Feb 2026 14:27:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DAD326B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:27:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C851C17AB
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:27:14 +0000 (UTC)
X-FDA: 84415015188.12.F5724B8
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FE3A100005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:27:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3j0CGaQkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3j0CGaQkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=lMlmgZvJ78/+6x3mT23T9oN35acHzRya1yuoCdwhq+Q=;
	b=I2J+lNAlJPqxfirIq/Wj5IQY2vXA8FfU/rCG12/3Z/cxlCHDobgr5Fvtft3KZsTZ+85ooV
	eoIQ0iKDCGdb5PxkWcW2xPPRIgJFdPnHO9f069IZT/COkFJkUEJ9uyysIGSpSlzpcjpwNz
	U1ksomHNuLQwXywWb2x0T8Q7ZHN4r/I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406032; a=rsa-sha256;
	cv=none;
	b=8BxHXHCJOsUKMPqgyqRHiH93iudY0caASuSQuwY2EFGoSeUZK153XSMP52O4LNRL8d3pom
	1U2IRAFtEBCoFKP/Y4oUmm+427vqKKtqxQ4Fx+fe59vjLbnp3FSNTtRGuqQ9P8dUGyZ0OW
	RhewcRp6U7FteBb/kalwMVMmkkDob2E=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of 3j0CGaQkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.160.71 as permitted sender) smtp.mailfrom=3j0CGaQkbAHwx34pfqqjwfuuni.lttlqjzxjwhtsyjsy.htr@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-3fda122aeafso7888951fac.0
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:27:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770406031; x=1771010831;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lMlmgZvJ78/+6x3mT23T9oN35acHzRya1yuoCdwhq+Q=;
        b=Ae2KBwhd5VjRCcC9xhtG80dqhN5EGfOybACNp+41QAjUj5RXs0Nj1mQtRyHGoyuIEN
         kLAQfo5yOEk2F70lG9qofGOSxv0sC5XWyeQB52fsnSI3QnuoeCu8HtJdPy4tfsLMYleJ
         0wKzB1y2fkuIUT0JWRdWeZr5x9GOwJvzfonLvrFbCjvO9SX+zmFIuLvWehsuKFUVfEau
         4jVcn5RxnBWa/dzYRkUy7r4lQN+Kg/3E2+aZ3SVEgSpm+KijOkaRYx02/+oZoJBCBQZm
         Jt3RjXr/zTS3BJiIBmSV0Rz2eciP79WIB6TeWmSMDwipUq4MfBHalWpiKDw+WdtI2pki
         TdDA==
X-Forwarded-Encrypted: i=1; AJvYcCWLC4BTERRI+ukJo/L5OcsahlMhhJlxoGRwyqOnZh5hfG3CXN6tXshyzp8C7wDWF8OssV1Yjeq6YA==@kvack.org
X-Gm-Message-State: AOJu0YzBarit6U1fxE2kQfmvKMMt3o4A4dQCaJGNiWE0q88T5ODuiBDy
	BgdyIpeRJu1Dqh1jeWGOHVgA8ppctDo/mUogfRO6iaIIUP6+u/ST2HEI9OJZPKmE0m/q8hF1yam
	2ADOBLfzl8PzY6WwipJqDSpSfF24Kxcw6iaWoz6F7qcxvElpQW18JuAgQhj8=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4a8a:b0:662:faec:7d59 with SMTP id
 006d021491bc7-66d0ac43704mr1257033eaf.37.1770406031685; Fri, 06 Feb 2026
 11:27:11 -0800 (PST)
Date: Fri, 06 Feb 2026 11:27:11 -0800
In-Reply-To: <20260206135648.38164-1-dev.jain@arm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6986408f.050a0220.3b3015.0045.GAE@google.com>
Subject: [syzbot ci] Re: mm: map maximum pages possible in finish_fault
From: syzbot ci <syzbot+ci580f4a2417fa7843@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, anshuman.khandual@arm.com, david@kernel.org, 
	dev.jain@arm.com, kirill@shutemov.name, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	mhocko@suse.com, rppt@kernel.org, ryan.roberts@arm.com, surenb@google.com, 
	vbabka@suse.cz, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9FE3A100005
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: chh47kjs65ts96e8rkt7uzbr1u46qoe5
X-HE-Tag: 1770406032-928231
X-HE-Meta: U2FsdGVkX1/9L9gsFYUecdZIPmR7cVxpKIDyD8++oIfI2wuIAC4dExnX4Yb/dKkBiWaV9qW4aG/g9cs9KrlwqsUlztpFgo9gKSTrpGw6pNsj0AEzTRZ0TR2P7oYWFJlGU8v3E3+etr4Vimi45QOoXWlD1HEL7bjmkYa+52gVZUmC1MnlMKvFbEwJ9ig7idKH+57bpuMBGdnZkeJGm9umskIT3sWUFz4udYlIarnL16Rtf5NgQX8p+a+ns+5/jgeIWIJ9Kpo0NZJWCB3gZ7J3p6ckW+2VHd5kZd6jutgy+H41qO7OREIHVHxyEITVklQDeBJ9GuPQbSoESxNOLQt6xSn+NeeMctOkgKpuYWDwDJSFtFxhW9e4T6kVxOnoHlnhsCA52SJ/bnKUBMnPozXXByPsN1qt/jkm6R34iaGLRYcP+l6o00YkG86TNV08zszgP4QGxbtXSwLCUbrpFFhlCPZFr/zK/haXHwiehFDJZH53Zz1sxSNsM3208ijhX7Eb+kxAuOAGm5RyrvbCeHg9N0k8MKqIm4JUNgBWNLHFDx84voSnBIotn5JYCtXng3lC3aZoXbaUhkxDZilZ41Fs5gac0uMYzvCkRZw/wLsCvxaIollzzBoPjrb2N7g/Q4Vv9f3vlUziRaafsIFJtpm6+0frpyUu60gfA09txk0bPQqKBVasi4LAbsdqscl52ffLsFua3nPkBZMkISLjY/RaQpv1oEFyWSKkjAoRhTbxYpXs8DiKGsmbIZf2XdQH4pxeojIIBivqhFlykftq/A/jsz6Va2XaoW4j84D4IH9V9Cgh7vHXcS72GG7V7Ig2nvzt457CnYqcJMjtRRXRjRuimCKv9OKOyo5HLASNluwrmSOCybycRgCxMhE1G44XPQdBrPKF8lKnVeYVOkHM37GElUQvyt71By7RFDHWH+OKnhxt/BlX9zbIX+srm+/FDgOqqdk7Ydg8Kjk40LZu6DA
 pxN7p0QH
 Oyu82pE0JlNRX9jjhB78/QXavRvQ7AMOp9hLiaraawBm0GgHXBuH87b+WQsb4PR9Kegkcqavd/ZnmRIz1frjlZ6qRfVc2OEkKNJxx+WI3PyzGqSqTWnAoE/wwAedgFwjoPAwyWq4W7MaEmEOvP1fr4KI7F/AUfIqicx7e32ExavjQQk4x/P471FIGqdli1bFRiwp02j4MXvvaWsmVYFbtpNcM9CBmmlH5d9OC4dzQp9MW2sp8iXV9eofwHqzprRnyLQaSQU6TIaxbJ//kMCcns8qqGChtSlxDWid9WwbO+7U9E0FFLRf0fGj2EUelRcviCBj0mD8+9QaO3ulasIPq4oNheE/jrJjkgHZ0fLt8jpBvVthxdfvqympfdQzAn1LVixNv02zOorNI7rOiQGqclnTkEqbj4oCWkF4L3ySIdaCU6/1I0PGR8aeOubV8psxpany6oz+2AwaoZkMbYkHJs3tjpfcGdnHmdsFVLP3edFUXhr/ZA0/0KVZaK2Pm9JP+599d6yp5YM7TR7CeRqM5qTatpPVHhCtkztixZK/cwZFhMcc0LgUt6pDqD+EmlsbDKFPHyVX17BLG+7vcUC0k+/y0SMOpbf25Hxo0rhB0KOgXwbBVzubrVUyvelrlYd9pgRGvN1LJyqe1XtIPV5iV7WL0ZofuziqApZSPiHp3aGX2fBSS3l2sMe+YDc5aHH5CQmg5N8FG4D7uP5FBTNfSE3XrnjVNMM7bxFuYBOZbwC7/JcOkGeQ6FrAIe3S56dfoWeKzExATblwHthXRQ6O6Dq5vtmkhIiOsWqssk0GydRpPAR+/II5W7vHgR3dGzyEupkZ22OXuIu43E25ekuuxmtSFRjfTfxGkjAW1fNEIsidTBDzdaEB4rV8ooEc8Les1zS1MU8Vg+Z84uG1VlqUQiUSJMiiNVKA4hd8kOlvWtG5ZboV407bDOwmcxIAJlIpwO1tXoSx6oIqtU16f60/uQXJIzDXi
 tqM/DswZ
 aSuprCZd5mxcJAxjdYYfSdVhZI0duv6daogQZYDW+ns1HKrZifZTD9aIgIyg38mpvHTRXP0tOOKanwoFAdQ9zJR+6qg+qlES0TPBpw/qPTCAax/ev+Yvbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v1] mm: map maximum pages possible in finish_fault
https://lore.kernel.org/all/20260206135648.38164-1-dev.jain@arm.com
* [PATCH] mm: map maximum pages possible in finish_fault

and found the following issue:
WARNING in folio_add_file_rmap_ptes

Full report is available here:
https://ci.syzbot.org/series/72be5e3b-2ee7-4758-9574-5c09e110d6d0

***

WARNING in folio_add_file_rmap_ptes

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      7235a985b8126d891dbd4e7f20546ff3002b6363
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/7bf34a11-2b89-440d-9047-d9a8b7d52cbc/config
C repro:   https://ci.syzbot.org/findings/b307b537-ffd9-403f-b188-852c8f39be62/c_repro
syz repro: https://ci.syzbot.org/findings/b307b537-ffd9-403f-b188-852c8f39be62/syz_repro

------------[ cut here ]------------
nr_pages <= 0
WARNING: ./include/linux/rmap.h:349 at __folio_rmap_sanity_checks include/linux/rmap.h:349 [inline], CPU#0: syz.0.17/5977
WARNING: ./include/linux/rmap.h:349 at __folio_add_rmap mm/rmap.c:1350 [inline], CPU#0: syz.0.17/5977
WARNING: ./include/linux/rmap.h:349 at __folio_add_file_rmap mm/rmap.c:1696 [inline], CPU#0: syz.0.17/5977
WARNING: ./include/linux/rmap.h:349 at folio_add_file_rmap_ptes+0x98a/0xe60 mm/rmap.c:1722, CPU#0: syz.0.17/5977
Modules linked in:
CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__folio_rmap_sanity_checks include/linux/rmap.h:349 [inline]
RIP: 0010:__folio_add_rmap mm/rmap.c:1350 [inline]
RIP: 0010:__folio_add_file_rmap mm/rmap.c:1696 [inline]
RIP: 0010:folio_add_file_rmap_ptes+0x98a/0xe60 mm/rmap.c:1722
Code: 0b 90 e9 4c f7 ff ff e8 84 d1 ab ff 48 89 df 48 c7 c6 e0 44 9a 8b e8 d5 3e 11 ff 90 0f 0b 90 e9 9d f7 ff ff e8 67 d1 ab ff 90 <0f> 0b 90 e9 b2 f7 ff ff e8 59 d1 ab ff 49 ff cf e9 ea f7 ff ff e8
RSP: 0018:ffffc90003f675f0 EFLAGS: 00010293
RAX: ffffffff8216c889 RBX: ffffea000412fa00 RCX: ffff8881170c3a80
RDX: 0000000000000000 RSI: 00000000fb412000 RDI: 0000000000000001
RBP: 00000000fb412000 R08: f888304bee000000 R09: 1ffffd4000825f46
R10: dffffc0000000000 R11: fffff94000825f47 R12: dffffc0000000000
R13: ffffea000412fa30 R14: ffffea000412fa00 R15: 0000000000104be8
FS:  0000555589649500(0000) GS:ffff88818e324000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000040 CR3: 0000000114846000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 set_pte_range+0x538/0x8a0 mm/memory.c:5526
 finish_fault+0xec7/0x1290 mm/memory.c:5668
 do_read_fault mm/memory.c:5808 [inline]
 do_fault mm/memory.c:5938 [inline]
 do_pte_missing+0x216f/0x3210 mm/memory.c:4479
 handle_pte_fault mm/memory.c:6322 [inline]
 __handle_mm_fault mm/memory.c:6460 [inline]
 handle_mm_fault+0x1b8c/0x32b0 mm/memory.c:6629
 do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1387
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
RIP: 0010:rep_movs_alternative+0x51/0x90 arch/x86/lib/copy_user_64.S:81
Code: 84 00 00 00 00 00 0f 1f 00 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 08 83 e9 08 74 db 83 f9 08 73 e8 eb c5 eb 05 c3 cc cc cc cc <48> 8b 06 48 89 07 48 8d 47 08 48 83 e0 f8 48 29 f8 48 01 c7 48 01
RSP: 0018:ffffc90003f67cf8 EFLAGS: 00010202
RAX: 00007ffffffff001 RBX: 0000000000000050 RCX: 0000000000000050
RDX: 0000000000000001 RSI: 0000200000000040 RDI: ffffc90003f67d60
RBP: ffffc90003f67eb8 R08: ffffc90003f67daf R09: 1ffff920007ecfb5
R10: dffffc0000000000 R11: fffff520007ecfb6 R12: dffffc0000000000
R13: 0000000000000050 R14: ffffc90003f67d60 R15: 0000200000000040
 copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
 raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
 _inline_copy_from_user include/linux/uaccess.h:185 [inline]
 _copy_from_user+0x7a/0xb0 lib/usercopy.c:18
 copy_from_user include/linux/uaccess.h:223 [inline]
 copy_from_bpfptr_offset include/linux/bpfptr.h:53 [inline]
 copy_from_bpfptr include/linux/bpfptr.h:59 [inline]
 __sys_bpf+0x229/0x920 kernel/bpf/syscall.c:6137
 __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4fb5d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe24ca9848 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f4fb6015fa0 RCX: 00007f4fb5d9acb9
RDX: 0000000000000050 RSI: 0000200000000040 RDI: 0000000000000000
RBP: 00007f4fb5e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4fb6015fac R14: 00007f4fb6015fa0 R15: 00007f4fb6015fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	84 00                	test   %al,(%rax)
   2:	00 00                	add    %al,(%rax)
   4:	00 00                	add    %al,(%rax)
   6:	0f 1f 00             	nopl   (%rax)
   9:	48 8b 06             	mov    (%rsi),%rax
   c:	48 89 07             	mov    %rax,(%rdi)
   f:	48 83 c6 08          	add    $0x8,%rsi
  13:	48 83 c7 08          	add    $0x8,%rdi
  17:	83 e9 08             	sub    $0x8,%ecx
  1a:	74 db                	je     0xfffffff7
  1c:	83 f9 08             	cmp    $0x8,%ecx
  1f:	73 e8                	jae    0x9
  21:	eb c5                	jmp    0xffffffe8
  23:	eb 05                	jmp    0x2a
  25:	c3                   	ret
  26:	cc                   	int3
  27:	cc                   	int3
  28:	cc                   	int3
  29:	cc                   	int3
* 2a:	48 8b 06             	mov    (%rsi),%rax <-- trapping instruction
  2d:	48 89 07             	mov    %rax,(%rdi)
  30:	48 8d 47 08          	lea    0x8(%rdi),%rax
  34:	48 83 e0 f8          	and    $0xfffffffffffffff8,%rax
  38:	48 29 f8             	sub    %rdi,%rax
  3b:	48 01 c7             	add    %rax,%rdi
  3e:	48                   	rex.W
  3f:	01                   	.byte 0x1


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

