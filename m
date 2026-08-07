Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F728C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 07:21:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5934D6B007B; Fri,  7 Aug 2026 03:21:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543A86B0088; Fri,  7 Aug 2026 03:21:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40C5E6B008A; Fri,  7 Aug 2026 03:21:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8C06B007B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 03:21:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9026C1A0377
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:21:48 +0000 (UTC)
X-FDA: 85073628696.11.C8CFFCC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id A1C19160009
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:21:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HNRCUnbF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786087306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6knPXuawpByGmHYtyjqi3P0YpFZD/HtTUFoZPvYRqx8=;
	b=vBlESSpck95CNB/bNrh0xcC7kpEf0AdXBdw5o8orpS8w4RYqXkVApUMn1xoHbW5SwpCZGW
	t4VFejgtZyyhZ95rciNdU/MFLN+058MIQbkj0nPQhDk+LPJe5VW3vlOsTOD64jPwBIxULH
	CIcvc/n91wLPjsNp23LqBGIDaQF4/Og=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HNRCUnbF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786087306;
	b=S3L/WKYdHTagQY6rLMW5Wj7SOOEHHfGiQNVECF6+yOhv/eS+JrI8LPStypEZRKw66hyswi
	gbdNuOp5k/zaHwnY/KzgeWJBlZST07AritIL86jkvm4T26hTwR24ID2SELF+QUxRtzB14O
	0H5/umkYtFEuMej/9PJgn6QK9Ch9Vvw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1999940322
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1FB51F000E9
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 07:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786087305;
	bh=6knPXuawpByGmHYtyjqi3P0YpFZD/HtTUFoZPvYRqx8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=HNRCUnbFaam/k5LgBTYP/e6dtJ7kDEWtYzOhDewwe8Er1hfweJSQYSRyo6dzVkgJQ
	 eRnrcNOVLNuuVWsQ1aqV5NJ0uAIEDfHGGh+d3ylc39ThDzBeTR0teEYM8wCIJp+SV6
	 zQ1xH5NBr/Pcs6NuIT1ZoteqSlS8sATsjlD5a+zsl7d/W6wsJjx9AR5C8YfpXVixTq
	 IYg/kMlenwslbTydnxz5YRtD1jbi6IgpmhtBeYK8h+1oG+UKtsZYeO8kDpPCmJ1w4n
	 HEXdAMYl6Yio7PLL4ivbbqGxn1hCEXhwMQm8OjUD620gFi38aNjmn+FMP0NRD9VCHm
	 OSJOF8KAVMxjQ==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-8143daf89c7so31437677b3.1
        for <linux-mm@kvack.org>; Fri, 07 Aug 2026 00:21:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ror2wuLUSMlk22ftENw/nPjfC1J3MOezQMR4dLid1e4y3wcfG9xsaS2FwA+8cYSrLqurkcvzh3oUg==@kvack.org
X-Gm-Message-State: AOJu0YxLIDWiNj7Jvt2by/9VPyDpgb/StUDQ+N7i++pbDNUoMan5vEGY
	yy+SoNKWztpxNETi4cwvp4TYPud3QVBNTwjTXOf10QMwgbWxXYC5Tb4itz+jzyXmXAH86Z7RuxK
	5qQMwslA3XVHAOuZLQTKOsaYiyuraE5TwtmMUrcXZGw==
X-Received: by 2002:a05:690c:b98:b0:820:b24:27c7 with SMTP id
 00721157ae682-82258a8f2e6mr43057887b3.14.1786087304379; Fri, 07 Aug 2026
 00:21:44 -0700 (PDT)
MIME-Version: 1.0
References: <20260806184254.3790858-1-nphamcs@gmail.com> <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
In-Reply-To: <6a756c71.01d0871a.3a0d52.003a.GAE@google.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 7 Aug 2026 00:21:33 -0700
X-Gmail-Original-Message-ID: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
X-Gm-Features: AUfX_mztVbvHM-WKo6lxh0LLm1G5XKwrWW650OzZbqB3e06Q5YutiaN72WNICvM
Message-ID: <CACePvbVKpkyV7KpUoiYPTUN0MgEcRUzZL71qTL5ePyjHTA3Kbg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Virtual Swap Space (Swap Table Edition)
To: Nhat Pham <nphamcs@gmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baoquan.he@linux.dev, cgroups@vger.kernel.org, chengming.zhou@linux.dev, 
	corbet@lwn.net, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	haowenchao22@gmail.com, kasong@tencent.com, kernel-team@meta.com, 
	liam@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, ljs@kernel.org, mhocko@kernel.org, muchun.song@linux.dev, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, shakeel.butt@linux.dev, shikemeng@huaweicloud.com, 
	surenb@google.com, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: i6gi5e4w43auiinwoydjq7d631jf839q
X-Rspamd-Queue-Id: A1C19160009
X-HE-Tag: 1786087306-697506
X-HE-Meta: U2FsdGVkX18y7ioouA2UwM9XslshW3E9UpA6jwzbkGEy7tLo7au8mEbXOLLjIaOQ0nID46qylR70xWGQeIaofjZTbRk5JJEvKBIGxxUxkadayeTk0iFHCsy0qpHd0TCZeIVvUNLPZFblG3UhxgTX99cZbXpsLrZdpLJMWvpNgrKf8ImLoejNjaDMrc155D5bROtdaawk+HGQJEA8TZomZJQz8HYIJ+7XlTgnOXG0tzf8m8S4PIiyJS/B0IRQI25FDUWviC4mVJedakFRRsxhKKcXzo0yfF3sL1mFlY1vq45oi8goCu0EKcX3+HxR6kLuJKrigNaHS291/FouVZ5ujCA/zEqPiO4GeJ/iFebnbmQxx9GuhBANHKvl3W16YxKZUMfY4w4GJkK9xNOSvHOcYXIJ8LljqHcfs8gjT+ZcifniR49iW7kqRPR3Ilw7VDXKT7H90iKFWqaljBSUmkgAILKOeltUrcWURswG9W8vSA/JXD0pkKkZZDZvQgkdwM88rR6qfcJOF/cWjKZswjKBV4xjbgsyobrW0ebTtn7iFRWn4SNQ0mp81ULIMPWPsUgnm/YArSA/owQ/pkjASUmBX085tg1LRt7KvXBKZEvLGR2a4co4P1QlEy9lyTBFvzZzY9EIcNGIu6800Ax0yHFW8NbWk9UjohYc8nOULDgV4lu3CyvHnbjIcKyK2WCa9fBg0FiD8uHb1Y4FkLEaB+bvRkfSqqJDQ+3h/Gc9epPp7tAcwwxi+rOrF4V1AaQlEwkHV69OGjencIcWz6p/15H268Itmcnt++zFcX/gNm8Dc5f3URKDTsESFqswJ49qM78+sq8QbrJDzBycaJT4CPHJbJGsNL5J4f0u9PZZ2UxzwoLIvpgeSaHMD/JLbJO/qJ5vSgqxzVRTsyiQzwSJNzxaSmgboauzwGlw/hkIhZDvMi41FHM7w8yXHu9hA/1GumAF4vi9Ch8bkb5B/MYSmSR
 MVcBEQjF
 wMDZtvUJN7XikkzwRhDMynK/0KIHusaAa4JsduOsg+7ZuF2K1XJAoC5LxOVkBvM6JrsBGw+iozX8f99N0UgDXvZvKJpMFYjlFCNlmotTiUEeRznQsFBbmmW9A9TA7NFJsmC+SwxNNCcU2f6DKMjqFwjruiZrmY3nguBR3a7zxmMZRn3WmUzUCf5jDnetMU/idVt4/0ii0iqyO1uWsOKpsb2myokBud9FCyZoQSeNRTRYFbuFE5dMwIYiiUdICdFCWrKcJk34HhCUEl4G5VTdUIBGWYkKeqdr7ERv/No257i/oXxWmJIGVVltXUfiUCP2qO2FLrJqtFJbrLJqUVLYfoXnJtzRO51V43vpx9RBe19FJQ7mEFg6n/PEs27NOpQseUlwj7BdpkWa9INeOvg1fKoP3XG7LhDvzO8IW2STnZleO88Daf9sLFmDQmZCE82xz87oyFQmj7f0JNsdlVRqyJIvGlBRT2E/2D2DvQD3aMMY2XiUPJGhERuHdQSjzxKVze/Kirx1xnpJrLw+H/psAkCChZ/bVQEKnvFZznf9GfL6glb22Fa9WFaiTxSBeeRXYqvea
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On Thu, Aug 6, 2026 at 10:26=E2=80=AFPM syzbot ci
<syzbot+cif942a042aaa8793c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Virtual Swap Space (Swap Table Edition)
> https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
> * [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
> * [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
> * [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
> * [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
> * [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
> * [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical s=
wap
> * [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vs=
wap entries
> * [PATCH v3 08/11] mm, swap: only charge physical swap entries
> * [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
> * [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical sw=
ap clusters
> * [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned=
 long
>
> and found the following issue:
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> Full report is available here:
> https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40

Please take a look at the syzbot report and let us know what you think.

Chris

>
> ***
>
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      bacc32cc7de65ffff70080a48eb294f89e434d5e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/4f943657-9481-4637-9b1f-9be1bff18=
f92/config
> syz repro: https://ci.syzbot.org/findings/f6c4f1ab-951c-4759-b397-e22c23c=
3bf32/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instru=
mented.h:82 [inline]
> BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomi=
c-instrumented.h:3188 [inline]
> BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:147 [inline]
> BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:197 [inline]
> BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xfe/0x220 mm/v=
swap.h:441
> Read of size 8 at addr 0000000000000000 by task syz.2.20/5818
>
> CPU: 1 UID: 0 PID: 5818 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:82 [inline]
>  atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline=
]
>  __vtable_get mm/vswap.h:147 [inline]
>  vswap_to_phys mm/vswap.h:197 [inline]
>  swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
>  do_swap_page+0x3c0/0x5620 mm/memory.c:4975
>  __collapse_huge_page_swapin mm/khugepaged.c:1202 [inline]
>  collapse_huge_page mm/khugepaged.c:1325 [inline]
>  mthp_collapse mm/khugepaged.c:1524 [inline]
>  collapse_scan_pmd mm/khugepaged.c:1786 [inline]
>  collapse_single_pmd+0x24c6/0x3da0 mm/khugepaged.c:2803
>  madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3237
>  madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
>  madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbcad79e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbcae5c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fbcada25fa0 RCX: 00007fbcad79e019
> RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007fbcad83500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbcada26038 R14: 00007fbcada25fa0 R15: 00007fff095fa0b8
>  </TASK>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.

