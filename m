Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD9E5C2A09B
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 05:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB066B007B; Fri,  7 Aug 2026 01:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C326B0088; Fri,  7 Aug 2026 01:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3819C6B008A; Fri,  7 Aug 2026 01:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0835D6B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 01:26:12 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46D5A160245
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:26:12 +0000 (UTC)
X-FDA: 85073337384.09.28B4145
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7B46140005
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:26:10 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3cWx1agkbAHoqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3cWx1agkbAHoqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786080370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=T3m0nal8RAOlIDKOwy4iei8tz0r4SQ1BHd4+5WMc7ws=;
	b=VSz/WeymYHJbS4lvXaI4xGfvAkm4zTprkWZozRcQzx3iaGbte06YTgnQZ1GwR2/LPZY5tS
	PpUPwTFVcwQcBaUqMPAfj9rOMDIcEYFsyDeAD96ZpLXwPikfxh/Dkr84oKY5fa1F54usY2
	ZYimpR5XFkQuigs0FdbT2bEmwN1AKSY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786080370;
	b=73WbWijyie8DRWPFTR9th3gRXook8gmEYL7ppZu+eQ1JZH4gH7ZH4wke5uVGXBi73TG6RN
	HeWBGx7J/4LrSiXUveTqmdyid8jXIiuefdxa2WTX2TiqoKGrzEcv4KZnEPXfYlU05276oF
	KmWworLzxygco2bssJjUhCv3FtCAhSE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of 3cWx1agkbAHoqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3cWx1agkbAHoqwxiYjjcpYnngb.emmejcsqcpamlrclr.amk@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4a416619e8dso2181233b6e.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 22:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786080369; x=1786685169;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=T3m0nal8RAOlIDKOwy4iei8tz0r4SQ1BHd4+5WMc7ws=;
        b=mOE0YUn78XtdBvZ7MjlJzYUTmFNx6NaqkTQUhcdjizgilnCicsaiPND22iDYtWPT73
         QoeKTi1pR+oa59GiGlKVodK3iUwjGKep5kidNMgCy12FVvwtKCJ4G8mirxUdp3qptqiH
         uf2q+YWINL97jHA3d/qG99AQDFwtfCgMo/2s72wfOMTvhy+0a2bo96WAoHPz4iFjQ6tD
         1zkLGcVueqNe8wu9I2RsF0/WjlID8VDdli65/kB4TrK/VmrHQQwhgqf7OjV402i3pNZw
         cwtzSnbnOAsEuGO4wtGXpMeFtc0F8GLsnrkkiONGHbYHhr59M8q2XhzF7kiJ7ENioboX
         vIGw==
X-Forwarded-Encrypted: i=1; AHgh+Rpao34tnl9Vf+0tnrGj9VWPVrBqbfer+n3XnVtZtUK10oMn8lp+waVw8Hre+FoYyUORe56QqhJUxg==@kvack.org
X-Gm-Message-State: AOJu0YxCPCWexF8MVxUNR8DStky6DdqmhaMGi1tnyGNweZUCDxjssycS
	EL4hPZHg8bQ8lx6EpkOB1BNnCilYtbcNzBIN7rDPzIUNB46ZqznwCSMXO+NiEpWT4JnljSaz8+l
	yMx9JJAK/YJUEqAfmGjiYBFbu6MdiaOcKrODQAA/AnE4MVj6GUKZz1k5wm0s=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:169f:b0:485:7c46:b866 with SMTP id
 5614622812f47-4afc513e9b0mr6403807b6e.16.1786080369495; Thu, 06 Aug 2026
 22:26:09 -0700 (PDT)
Date: Thu, 06 Aug 2026 22:26:09 -0700
In-Reply-To: <20260806184254.3790858-1-nphamcs@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
Subject: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
From: syzbot ci <syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	chrisl@kernel.org, corbet@lwn.net, david@kernel.org, gourry@gourry.net, 
	hannes@cmpxchg.org, haowenchao22@gmail.com, kasong@tencent.com, 
	kernel-team@meta.com, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, muchun.song@linux.dev, nphamcs@gmail.com, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B46140005
X-Stat-Signature: qb8fhi9bgseo4p5qkruc9dthn6h1h4be
X-Rspam-User: 
X-HE-Tag: 1786080370-756711
X-HE-Meta: U2FsdGVkX1/ETl5761273Nc3FZn8P8Ita2L/bRH9iINgwMfYouoIViv8hAriupcV59WYdtlRULmLkAxUN6XjvgaqOGNFgBeONNXqDFxXd4hVZ7kkH+Q6MyHTnCqARCD9udrGV3DzU9O8eLX4q6OzvCsFA4Oe0MYnQgQSsHSlFIirrIQ1990/j22ekeQmPvw7HeKfwcjiVErfYEgxtSF1VhkbyrnieIbSHxSWfMiKGYJQfeuqbNvtGyU1LdI3HTmvlR3mIzGYq2TbtaLkCtZqwZS7NMl5+/uKsg+jlgYdCX+1kWzggW4EtXJFl2znoowgLo4qMDGx8n0M3bkmo9jKUNof1c33IwsB1zwuqXlsy7O5NqU4NuucVTr2E6k0N3hHTcDv1l3KcoZScDyjUJi2EvsbOc5DuLxV5hvKkFWOBl3Me3GYlXyBzFmsKihl1t1j0AZTdcL1KZXEM1KAakJiRYdQshp6L/YLj9kbpAlpJYYpDx4+Cgz0YIYmus6MoOOA1GP1VydRsVT0lCpQZsVMS0oIfMiUUGhsXEnMS0jPnagYsBuiP7Bah1T5XyA1Dr3z8dOEwJdA2UHpDN8qR340f5l92jUP5xm7a22i8Uzc6GSdzdbk4zqpQdxlDDXRgbMlG+PCzjnFkSzV3Uw4S+MpSv++jSj6cpi5yR+dOrA8HtMRBqeQEal4fddOZyup1zAqDwpVm6wfsYMpBU/kurGMLh4NbXGPYl4OrqUnI7tqJlmiXg/ej8/ZYb/GFkwe4AmV+wfWvre6Zp6FZ3w4MJSyBedLvHGg0vcF+elBZb2Os3FLx56tM7aREKdtWdGwKnmaXZdl+ma2c00tTnJh0avyHNCGE3faXHj+hCY1vWrz+m3ML7vsRuLe6NpJNTQJjXywm17Tpvgnmf1n66JlPar036r9Xmncw2KFU/hyWsW4E+Qc/88VYjnsiVwkITFFto5VIPqaLVCv5mylxWla9kf
 jjgfhSI8
 xNqvQyNbE2bcWLgkUk6Z0haSljsM/e0NI9INQV9Q7Ifsdt6DJgf06Zc8jkwd5i/iNc7d00bPZLmiE8qh5Hjq/3x0lC/VBDzoxsgJbwYmlPzydviyO84+M3qO0q27WYo6VLPCGxnHFb3gzQr4VVTcy6v+nNyv+cZ1K8pc1YfxFV3cO8xO2DEjEX9nJZGfPOKbcra/W4Wp4kEc0xQx9e0YfjpYIQE4jQth0KIw2Yj60A6+tezHoR7Njp+UbmhgaQNHZ/OEib66YyA75VT0M2GfP1zAJTyNpTzJJLeOeOKh0fralbUu4t0OYOz9TQiVYff8PJQhEBsG7xu++yrcImwbV/3JNYyl7TEk3aYvpsFbwr+j5zn6rMgXTtjazn4gyy25Ix9U/5XqMO2xIy8n6TBB8mSDo/W12uwl9lL88KNZW+UzCGVUeXVtCbrvo7+cfZFxu0jddGt1TwyVIrrsh+Cje+YbuFTF2k0ELS2dIWGkY01w7GkAvFWXVdxjn8rHcgEbZ1JVoYAvV/PfSNqy5oyRoNwvjHoE3ehgsfWfMbSBXRjwDKHt9vSf+xjE8A7KnisrlHgAM8vrsR9ivdb+z0Xksf0lnT2PVwtWK6Dj9VCyQ3UTPhwDozlvt4knKg+nggCLXg0xhlUvEWI3UXOssbv0gQb1OtqvQYUnqcAUJ4tqjlZ0w3YB4CrlAniAWzCr6P3mhogMvAZUZbPsI+GOkxq1YjI/x1MnaRVvDHVxWH1qg0RtSa3n0UieDTW1fXlimZLxTtoULg4MJEMv5nOo+PHEtg8rh13wHph2v6Hglyjr0fJJSd1DFTELlAFZWx5XdzwRcRgL/q+AahaWfeqWLEfC4fuRgIshShSA53WnFK/yReEsmYiOjlYiG3OKaqucA5Lw5vt7BPFPgWioKQqN5m/3QuUActLEFfJr6nfd99s8oET3w5OICegGuqxuEKLEBP2tGts3IYDJ7JCnlpHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot ci has tested the following series

[v3] Virtual Swap Space (Swap Table Edition)
https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
* [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
* [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
* [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
* [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
* [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
* [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical swap
* [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vswap entries
* [PATCH v3 08/11] mm, swap: only charge physical swap entries
* [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
* [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical swap clusters
* [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned long

and found the following issue:
KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

Full report is available here:
https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40

***

KASAN: null-ptr-deref Read in swap_entry_backend_has_flag

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      bacc32cc7de65ffff70080a48eb294f89e434d5e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/4f943657-9481-4637-9b1f-9be1bff18f92/config
syz repro: https://ci.syzbot.org/findings/f6c4f1ab-951c-4759-b397-e22c23c3bf32/syz_repro

==================================================================
BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instrumented.h:82 [inline]
BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:147 [inline]
BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:197 [inline]
BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
Read of size 8 at addr 0000000000000000 by task syz.2.20/5818

CPU: 1 UID: 0 PID: 5818 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 __vtable_get mm/vswap.h:147 [inline]
 vswap_to_phys mm/vswap.h:197 [inline]
 swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
 do_swap_page+0x3c0/0x5620 mm/memory.c:4975
 __collapse_huge_page_swapin mm/khugepaged.c:1202 [inline]
 collapse_huge_page mm/khugepaged.c:1325 [inline]
 mthp_collapse mm/khugepaged.c:1524 [inline]
 collapse_scan_pmd mm/khugepaged.c:1786 [inline]
 collapse_single_pmd+0x24c6/0x3da0 mm/khugepaged.c:2803
 madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3237
 madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbcad79e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbcae5c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fbcada25fa0 RCX: 00007fbcad79e019
RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 00007fbcad83500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbcada26038 R14: 00007fbcada25fa0 R15: 00007fff095fa0b8
 </TASK>
==================================================================


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

