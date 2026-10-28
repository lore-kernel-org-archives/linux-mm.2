Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E05606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 22:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEBB96B00EF; Wed, 28 Oct 2026 18:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9C876B05B1; Wed, 28 Oct 2026 18:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2596B05B2; Wed, 28 Oct 2026 18:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6CAC66B00EF
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 18:52:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF9EC1A026E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:52:25 +0000 (UTC)
X-FDA: 85373535450.24.A5D4338
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4196C1C0004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 22:52:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3p3ziagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3p3ziagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793227944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=xPA3khvwP2kQRrXhz1fOmmCIHEg7u7/AhyEuOBJrjVQ=;
	b=G+tEvY/ii6LJ2HR+PbYiQQyQkHWMPXGjf4lmT48YIGOg6olTTJfEVrWI6tWxRXR2LPTSYQ
	+fYVqhENCEKNoGnkyNpBN14ZA88+VZaThVTJb6SfLNVZzj+lRaTrggEcXbrwlDSS6zxXCy
	rGT4HoJROhO5fnHueuYnedEWldYMR7A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793227944;
	b=dyxp5YACViWGcnUKFSJPaH7uIRnxpJeQcHM79M4pp+eZtatRCsdwJ4GdtLkK7F+PCHkOKW
	2EpvB8WjJ1//2OVvOv2OcPDQQdHozaMCGgXyCSgLpKsd/u9XAgi6DNOjRcbQnLGHLOw2RG
	sO4/NA5n2iw8ZYJsVpymuxJheABTKU8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of 3p3ziagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.197 as permitted sender) smtp.mailfrom=3p3ziagkbAIg4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4e778acdbc6so2166289b6e.3
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:52:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793227943; x=1793832743;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xPA3khvwP2kQRrXhz1fOmmCIHEg7u7/AhyEuOBJrjVQ=;
        b=KPHQpEPQOvzcfIsbYT8PgemNnk3fObytUXMGR0QPhJ0jWElnOmRE3Ohuo6NE2ZzZ0J
         SBTdI0Owk/QCrdNeaeECqksHBByoOLhME8S5ANfzcCyZP0STjtUZMaN9eYUdnPV49MJQ
         ufjdgC2au5WkW5bpQCykIumXGtRp0K49XkEwv5/y27m2oxl2XmtImc401RdFHuBgL/Wr
         1rbQsHi9j19iUNneag5J/sza14SeXTpkvGyrzGuXh4feUNfqRJtqQBRNe6NNL5I/t30u
         qIKndHy6xLnRvCmvcNbU5Mm1ZYcgu0jeZeCtHMduNBcVYcBKFvTBu+qNw+4679hk7CuM
         BHMw==
X-Forwarded-Encrypted: i=1; AKwUvByqRT5GKk+QGS0reH82sPz6w21KRjy69394iW6CxYCVQsmt5RaojfRoA779TQEFHD0PUtIW4wUKpA==@kvack.org
X-Gm-Message-State: AFq9FYLsT+RrYTJqjteEEF0waLZta/KzmmnmdswYf0npFXsFGEf1v0Zh
	aMLalnOPOtWrSbAodvvcCpmWLfW1RhkUUvDUg3dWVZOhDjQSnBnOp3yJC7XoGLH/nwO/M8AqSvU
	sdLr0g1Dqb+DnanjVBSsohsuqQd2s20bIB2RoIcWhEFh9j1Xzlb/pvT6I02g=
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:e84:b0:54c:7bef:90d6 with SMTP id
 5614622812f47-5639fa6d1abmr2277627b6e.4.1793227943403; Wed, 28 Oct 2026
 15:52:23 -0700 (PDT)
Date: Wed, 28 Oct 2026 15:52:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae27ca7.5451848c.f7707.0002.GAE@google.com>
Subject: [syzbot] [mm?] BUG: Bad page state in hugetlb_no_page
From: syzbot <syzbot+d06e9fe6d6a7b537fe49@syzkaller.appspotmail.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4196C1C0004
X-Stat-Signature: wx4n5qwk3gucqq4onyrp18oqjfrfr9tt
X-Rspam-User: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793227944-469992
X-HE-Meta: U2FsdGVkX1/8iqU0T0lL5Zzeg20evoHzTRxYSzTCQ/MdeI6lXEA4vxXWMoepmyxjS/mt/srl/jfVbu3B3vbbMbF+ezHrrKRdWFx/DIc7KUkycFB5gpzRVvCN36ICUswMAeCJnPoJGhMF7Zh30TcyijbwNfSBMDvBr+aXad4BY2d37lHyjIU6cC608bQPBtA5EIOl8qlPAgI0zVUlgHRKnuQRCtph23p2fXtAa4QdTM8lCNvulcUR+DVNY/xjABs4CXZrKW6I8NxDlWdEB8Dg2NFf7PvFH0lm5LmL7Hko+cFbF8OLwwscOzlwLpIR3ZCcl52U9aOl1npF+qtmgOnf6Rkrm6ZZC3xMw6iPGRakwuG1CZGGYvcYp1urnE3/S4VKQQBkp8WQ16tIq73KzgUaJX9vxN/q9wan5UPGwybvUpz3Ft1txlTUk0b6ksEj9MEMQKIn7MSf06sbN2f0i7oBdAqRoTSCvzYa/0PLdceMxbeVz3gt6juD1tfWRXwg2lXDMlSrzzaJb//hJE6ADayj0HjRCx3u9QIVey4jZtKr7SfnXmGenOXLBHzzf+3mffgQWrsw+U8psJRfJp4WFP/wB8WtjNQIi7D+tu48jUrUwy0WeR0GVAP5kIuuIKB/PXntH+kGKpo29aYI5PA/AMG7d03AM63LX1kllgqOfSpIKLmYhUkx3nBQok4Xy+1clWKOTF9ULfytuK5cxWd4ikOXXC6dDpUoBOJN7nQkFgIFqiQT7Tx2nwhKthBV3ChT24XNB0yiLvMpgSyg7xxylQ13di6llwDgr0ck5/f5UUjg15K+VHQYUfjaNBGC0Djx1kdmdSVAT7GkHdpmF8tu7dEqNATr0W6WTwnumc3K08cTLlDYnm2Vyv8oM1t36MgVqkay4B6tTqyILAj4dlwqPmCLwOFjDXo8iUS62S4Ul0roS/pHYwFHHf1CFEdP06dUtgXqORCL+YmCbu1BwQFaQhR
 VR/pPczd
 4GJn7YcmsYtE2wT4CrEj5HfCZLJd12sX9QqKAWzv3y7B6fAvwn3D7AsCEG+vRYUN5M7Xrl8fMktWxQ4YhGnKh2dZ3YJrGmgrsqxDdX195J9VkVwl3YdWkaqhodQW7/y2gDESNsYvVGPgyV/QGP/GyLOxtrQYoYwD54oaJ8b8d07cIlEj04roAcvAOOcVccJ5Q99ZCp6g3axgokMif2COaRFwql3d42QWZEOt4N/sgrghbM5ADN7ySDs7ArO9ey3SkY6AvSdaFXkW9vpom6hCMOFe01HnvnTknONMEVsBfi/jW9vhc1mTIXbChziHLMOUkPKmLBT3GCpjQsf+R0ajyeupsXTiQKOHhUtoMsEi7dRzBjiCFBnye9yHZh5l/nJlvZPTRgK4bfYgkYVU/B5HKLGC/jdaJEav7Jil5psnRIcxVeqegwMv+pCDpPU12lSDvUGVWi7BXnsrMGJBzYEQXQsfIvnbwH7itiza4HDLUsovDX74t5Elmx3HJ1NPgNdg5kGKwrgp8EUKcO9bvg08sxpd/dk4CdYyAENpptW2DzV7qPTBSF260IIJIrdzvxEYSGB+PtPxsJgD3HA98/QLBmYqAr8Gj6LBWMPf1iIqQhCCKfDVyZtNUpfgLstiL3njD51HOIvECXT96+p6HfFAuCpujWo0j2W4Cqmt2hSe5wpvvyr3yWZW2Lm2AioYpyx4MjkfcyfRzMe/H67UJXG8ccTu5M+feKrUqGxn3Si5t7aILBQhXprsS/yR2VZ/iftHmj20z/z1LnEkvwQHIfgsERs1MJ44j6EMMgX9tkKFiDJ1+XISYmXh09k8n/eqGGvTzBKOvLLbr7tHEZH5Hu+AbfyzIvQnDS0j9UW9yZei5E4Pd0vHF6R2moJDHRwW92wtVUe+tstY2zReI+6++jf4njHJe2bikXHpF4v2AbQVmE0ysqpz5Elf70H7awRqx7G5bSzlkcAxzhVnDpQbAnIJyf1njBG5H
 IjIOx3Ah
 hW1q9YpYezW5UksCXGth1CVOZEcoXeHGRkw2KiR4XuMTp017K1JH3wpQU0Ufe7mM5fnmeLo6LGykU/VT9ugLUW0kwhsBosc/ESilq3LO88dwGpm84pMU7vwmxh+QsO29z1g7Xp4lF94568/lNEqcDz2XYT7bozIoeUkYB42zhFwGNaT+M6X+8hXhuBI7w0mAW8ovxF6y6uw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

syzbot found the following issue on:

HEAD commit:    d135ab453a74 Merge tag 'backlight-next-7.4' of git://git.k..
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
console output: https://syzkaller.appspot.com/x/log.txt?x=13ecd97f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c87c97847f0654ee
dashboard link: https://syzkaller.appspot.com/bug?extid=d06e9fe6d6a7b537fe49
compiler:       Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1544ad31580000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+d06e9fe6d6a7b537fe49@syzkaller.appspotmail.com

BUG: Bad page state in process syz-executor125  pfn:60600
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x200000a00 pfn:0x60600
head: order:0 mapcount:0 entire_mapcount:1 nr_pages_mapped:0 pincount:0
flags: 0xfff00000000058(uptodate|dirty|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000058 dead000000000100 dead000000000122 0000000000000000
raw: 0000000200000a00 0000000000000002 00000000ffffffff 0000000000000000
head: 00fff00000000058 dead000000000100 dead000000000122 0000000000000000
head: 0000000200000a00 0000000000000002 00000000ffffffff 0000000000000000
head: 00fff00000000000 0000000000000000 00000000ffffffff 0000000000000000
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: PAGE_FLAGS_CHECK_AT_FREE flag(s) set
page_owner tracks the page as allocated
page last allocated via order 9, migratetype Movable, gfp_mask 0x146cca(GFP_HIGHUSER_MOVABLE|__GFP_NOWARN|__GFP_RETRY_MAYFAIL|__GFP_COMP), pid 5964, tgid 5962 (syz-executor125), ts 99736440450
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1854
 prep_new_page mm/page_alloc.c:1862 [inline]
 get_page_from_freelist+0x220f/0x2280 mm/page_alloc.c:3933
 __alloc_frozen_pages_noprof+0x1fc/0x400 mm/page_alloc.c:5429
 alloc_buddy_frozen_folio mm/hugetlb.c:1811 [inline]
 only_alloc_fresh_hugetlb_folio+0x135/0x450 mm/hugetlb.c:1852
 alloc_fresh_hugetlb_folio mm/hugetlb.c:1871 [inline]
 alloc_surplus_hugetlb_folio+0xb9/0x350 mm/hugetlb.c:2103
 alloc_buddy_hugetlb_folio mm/hugetlb.c:2183 [inline]
 hugetlb_alloc_folio+0x568/0xb00 mm/hugetlb.c:2899
 alloc_hugetlb_folio+0x57c/0x900 mm/hugetlb.c:3067
 hugetlb_no_page+0xea5/0x16f0 mm/hugetlb.c:5875
 hugetlb_fault+0x776/0x1440 mm/hugetlb.c:-1
 handle_mm_fault+0x24fc/0x3750 mm/memory.c:6844
 do_user_addr_fault+0xb35/0x1480 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
page last free pid 5968 tgid 5962 ts 99714065632 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1401 [inline]
 __free_frozen_pages+0xc97/0xd90 mm/page_alloc.c:2952
 update_and_free_hugetlb_folio+0x17c/0x280 mm/hugetlb.c:1568
 folios_put_refs+0x73d/0xb30 mm/folio.c:1020
 free_pages_and_swap_cache+0x41e/0x490 mm/swap_state.c:647
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:397 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:404
 tlb_finish_mmu+0xf4/0x220 mm/mmu_gather.c:529
 zap_vma_range_batched+0x4b0/0x5a0 mm/memory.c:2321
 madvise_dontneed_single_vma mm/madvise.c:873 [inline]
 madvise_dontneed_free mm/madvise.c:964 [inline]
 madvise_vma_behavior+0x2361/0x43b0 mm/madvise.c:1375
 madvise_walk_vmas+0x924/0xb00 mm/madvise.c:1692
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1921
 do_madvise+0x327/0x3a0 mm/madvise.c:2019
 __do_sys_madvise mm/madvise.c:2028 [inline]
 __se_sys_madvise mm/madvise.c:2026 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2026
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
Modules linked in:
CPU: 1 UID: 0 PID: 5970 Comm: syz-executor125 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/07/2026
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 bad_page+0xdc/0x120 mm/page_alloc.c:630
 free_page_is_bad mm/page_alloc.c:1065 [inline]
 __free_pages_prepare mm/page_alloc.c:1392 [inline]
 __free_frozen_pages+0xd3b/0xd90 mm/page_alloc.c:2952
 update_and_free_hugetlb_folio+0x17c/0x280 mm/hugetlb.c:1568
 folios_put_refs+0x73d/0xb30 mm/folio.c:1020
 free_pages_and_swap_cache+0x41e/0x490 mm/swap_state.c:647
 __tlb_batch_free_encoded_pages mm/mmu_gather.c:138 [inline]
 tlb_batch_pages_flush mm/mmu_gather.c:151 [inline]
 tlb_flush_mmu_free mm/mmu_gather.c:397 [inline]
 tlb_flush_mmu+0x6d3/0xa30 mm/mmu_gather.c:404
 tlb_finish_mmu+0xf4/0x220 mm/mmu_gather.c:529
 zap_vma_range_batched+0x4b0/0x5a0 mm/memory.c:2321
 madvise_dontneed_single_vma mm/madvise.c:873 [inline]
 madvise_dontneed_free mm/madvise.c:964 [inline]
 madvise_vma_behavior+0x2361/0x43b0 mm/madvise.c:1375
 madvise_walk_vmas+0x924/0xb00 mm/madvise.c:1692
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1921
 do_madvise+0x327/0x3a0 mm/madvise.c:2019
 __do_sys_madvise mm/madvise.c:2028 [inline]
 __se_sys_madvise mm/madvise.c:2026 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2026
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6a83c0bd37
Code: 8b 54 24 78 64 48 2b 14 25 28 00 00 00 75 0a 48 81 c4 88 00 00 00 5b 5d c3 e8 05 0d 00 00 0f 1f 44 00 00 b8 1c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 d0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6a803d0178 EFLAGS: 00000202 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 0000200000000000 RCX: 00007f6a83c0bd37
RDX: 0000000000000004 RSI: 0000000000c00000 RDI: 0000200000000000
RBP: 0000000000000003 R08: 1999999999999999 R09: 0000000000000000
R10: 00007f6a83c85220 R11: 0000000000000202 R12: ffffffffffffffd0
R13: 0000000000000000 R14: 00007ffe29fa7790 R15: 00007ffe29fa7878
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

