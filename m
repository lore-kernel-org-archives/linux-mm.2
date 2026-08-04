Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94FA9C55822
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:05:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE0D96B0099; Tue,  4 Aug 2026 10:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9796B00A0; Tue,  4 Aug 2026 10:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF63C6B00A3; Tue,  4 Aug 2026 10:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6D56B0099
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:05:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0BDCA801D3
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:05:39 +0000 (UTC)
X-FDA: 85063759998.23.5713115
Received: from mail-oi1-f207.google.com (mail-oi1-f207.google.com [209.85.167.207])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4615520013
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 14:05:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3sPFxagkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3sPFxagkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785852337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=5+IMiqt7NNQBBUcZ5PLqgEP++0/ZmGbns9xvHW7NRr4=;
	b=p7tKo/yAPiTaZg4BHq2vTwifEkATbxEYTdweUyNgX0ffJ6NTM0QAd7mJbXkVy8KCep7DNx
	UU70+wPgRX5Bx84y27mImwA6kCJhU2sg0aqpTS5GDrELANtnRPTBTpgyNAgsd7JokeaKoT
	+cU4pNT+yLJHgy+ZqH0bZowTcpoqRWw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf03.hostedemail.com: domain of 3sPFxagkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.167.207 as permitted sender) smtp.mailfrom=3sPFxagkbALUntufVggZmVkkdY.bjjbgZpnZmXjioZio.Xjh@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785852337;
	b=klXUyTNqLO4V1JL3KKthy/1IliMjcOzpCtaapRBd0JjxMB3vYkdngmB910k4klTlEFbfe7
	uGCdrpMyV9YEwuvvelBLogxgUH6hzAAMmI1yDVekRQ9P56ax5WBL8PlyTGM3mctBk+vU7O
	Y86tvvwtnWQ5I72xZdbTpz2q15Il6VM=
Received: by mail-oi1-f207.google.com with SMTP id 5614622812f47-4a49f09233fso801547b6e.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 07:05:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785852336; x=1786457136;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5+IMiqt7NNQBBUcZ5PLqgEP++0/ZmGbns9xvHW7NRr4=;
        b=BHGssn8IAyZujnKlfchS1K7MZHsYB1K1A+zTrmFoMIoTzj895fD7VNIga/x+KQwUAJ
         ZqsZ4agFEx5QLqvWud0IzaOjTuT8xA5FKO23TE0Ky4iF2sC8W2DX8gbMAvd/o2/kvOB6
         FBqVjaIIRIQyqjYSbPLiU3P7uGDP+q9MJslPYLBt/HxSlgCRZt84AI2/f4PZSbz/dRYw
         hCvlLohk3A1B1SHd7b8liR0zX324f3zo9KF/P4pjBydJR7ydOOlqbSjzhB4+bBHX2D5S
         Xx6vuEXodnosS6AVZlfxpeFqX33+iOfvUEkzXwGW76MJp4/PxnfAvkEFMeENAZd8AMFe
         FERw==
X-Forwarded-Encrypted: i=1; AHgh+RpvY8mDZTTxP5fH3jum3UOhRA+32fEg9xJ8xky7CjQZhSNKrN0BSri0EvTfQmcO9VQtXCpPAIlrwQ==@kvack.org
X-Gm-Message-State: AOJu0YyQBxHddzat0UYXBAvmEImBb8fAwYnHYSBp1jCzwcjEGte2YgbC
	GtKr2Kvk1D9mcQp2CJz4h8Ypk1U0WcnXgom3gDP6ZQZEDXt3j/5e3b2VDH1TeH0GxbCmewTI1gn
	NRpoKE65EotpKV1i2AIfP76HDvR6uf3mXEetGyGBBSwlaSU9GwchLYl7WLCg=
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3510:b0:4a4:989:bb1f with SMTP id
 5614622812f47-4af98935a91mr4488309b6e.9.1785852336225; Tue, 04 Aug 2026
 07:05:36 -0700 (PDT)
Date: Tue, 04 Aug 2026 07:05:36 -0700
In-Reply-To: <000000000000ac2392061f7a501b@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a71f1b0.40259c87.584f4.04b8.GAE@google.com>
Subject: Re: [syzbot] [mm?] kernel panic: System is deadlocked on memory (2)
From: syzbot <syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, mhocko@suse.com, rientjes@google.com, 
	shakeel.butt@linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 14ajwdpqfb5mimh3gqwpzsfgs19dsu61
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4615520013
X-Rspam-User: 
X-HE-Tag: 1785852337-246277
X-HE-Meta: U2FsdGVkX19zvh78ceScHLzUtenQYLie9OWTPbAttVT7fanQ44YiC5oPSFguebmLdfFr7j+HdjUTUaDIVWRJaYoTyZ8P8uDvogtjTV2Oj+RL1fDsgiVRn3nQROsRWaH90usOZyE6EnBEQTT0Efxw2sjPmRVWyXJN2xR0chrsCbFLBAmZJCksKPvOSVrn7evCm4e/c1LM8M2czzFlsiuNx2Un52kuiOhlLz2ZWqJB/uimZckmD0zaobdMn/fA8iAGXZ66GNo7Gv8QkC66eUVF76hV2r6qKq7SD4lGGHPL7d0srHcqqAJp/uJApCAkefOrmuHA5go/cUAjBEFt9b78HMkyE5z17wueMs4h61vNPORBHLUO3hibd4MixmfZV18wMk1VE1KHOz47x8FC9+02IzCq9R8TdsxLykZQoz/z3c7DMdomdUf9GJMJgJ8kuOtuxiWf4hniJrxEUPsFXUYrcTc5mfhBD6AjG11vC/6G1a1iRB71OfMdLzaSPxBG68JsbSkuuaYROJBuaizvgPIpOwxnQ6IOZVqZ0SaAvaVim8hBra720opjiAQmD3D632UsjHObYuCoYQPmecv7RzO6phQeCJ33ro9wNHMb/ztfrJ4YSaqQ8z58J39e1uAetnY6DinzWRMTRmJh3S3jvVZMWuj/Zz+VbNZMO0lLif+0wzGKNqHd9kHUfW+/HKEo6e6K8mrC4fvkRJpcDRAobU4pEtE+OrTOamrtHcgWouAu7a78JHXmNUfCBH42PJy2PaV9m+r2m3doXFb701tG9q+UEIV4KQnKsksclCWBD9e+PsueoOpu2b8QEpwMuXPIFZHIKvnNyVZjwtMEMSMgQ+zbLXEZG2SZU7fMYbKaPgSTDVhz2sKgwpiDr4GvzJ/d18N2cp+t8e0BseVHCzf6wbfRIR7xtzHu3DAia2IjLCfRJjYuVTh0h66+8me/YeppQp3HLi7SrjQY0EVGuQvKr/2
 LRL3uNWk
 VmluTi6ao+CqNuIBfUVtj1wegJFJ5jl01gwh8/ONJskikqeXVi1gLx0mXKw9owHGTbl/ue3NU3YdQeriwCO7gNUF9gH4brw9FVUB6KbLwUcnkOT2aAUQfg0zijyRTK72xGI2UhTpdvx3HpdHJTIbYBwl0Et+3B6RXSfEJmdQee8mIL/niS7bksXxm41du+61btAbiFxBGcCw/nAIChJC9CTGFeBjDIHyNb39n4baEKp05ByeXiu9yKlgDM2MipEjMZ0afNoUshGgORa/g3tqLJPsFURjoVoQGpT2j3AUn/Xbm/p33xe6OJ2l+nKeoQkPIosLo2a0pfrbevAjQCoTS93tQDOTb2PDwAnXzG8wmNv+MbmSkhH/+DpD/G054D5o20M1QLPC+Wc88HHU8n3lzYsoG77h8EPJ3ILUWEmGQbje6tYYciM/1ZgU8I5EIBSaetbq+AlL9zuCzxZS9DM3rI2CzYfY7Xerl57g6GZqfqk4X/nUeUAaKszHDuc79aHVdfpAN0GiwjrSpmIs9OACj6DaWfX7+ap9W1neN+NhymzkqPijQhuiB3+DaC2kw+uYdEX+xtewEd8WB04ovjwlehdYN0DNdgOpdxXZAcL3X4PmeWaNMYd3w36Erxh9xY6H5fv0+Ygv3kvjVjPty2MMUfHI9gDAI1nh/lYnYncBgwpn6q/nXNStF6LaptQPyicMMuQvA1JMx8lPK8/2jhiq3d4udqPWJnOrcQGWDCqS5syT8UVStr2tYT8Sqy/xTfyW5HHwTibQ5rqc4F02BUXSg18FPRHCGz1+VRgpEBdElj6Y/jeF49LtZXs3VbgzJS6tXQV4304AMHYP0q2HsYp0oglCjSN0QJaxHczD3qabrg6hnp/hPHUazxlnGK3pPePlu7pY92hbGUzXBrSUxF1ch3hIc4zOebBDDtnq4m36PMp2yD+QAmUZdT7EUW2Ikprj03mVoeqg6WfiLPMl/Onj28U1hJQ/6
 cHpl4jqA
 +6QfMyTe26rpVFBNpQPEmKB9r/6PpyINLrf6/07B6lyfrJ6GiOZYrChP/EDDrUACbP9Nawo+aVeuEw+ss/rKNENFCAz02cWbIPIH2wFxT3L5LI+DEP0n2xsP1ea+pJogwb6sogXlpFCd+E8yHygONuxJT3n0JN9v+VLlWVh6UWLT3qtrIC5JJMoC8zoBxnwIWZAoRwjg6zdwev9uWURU75yAvpsEgpCiFiumIyJSKsfsyyWS+F9NYw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    848acc8ffe1b Merge tag 'fsverity-for-linus' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1559b649580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=145fa60d73086782
dashboard link: https://syzkaller.appspot.com/bug?extid=c61d6962d0b7e698439e
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1531be32580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15938bb9580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-848acc8f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/6fb497cc0c8d/vmlinux-848acc8f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/663ccee34982/bzImage-848acc8f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c61d6962d0b7e698439e@syzkaller.appspotmail.com

kmalloc-96              1483KB       1500KB
kmem_cache_node          219KB        220KB
kmem_cache               181KB        226KB
Out of memory and no killable processes...
Kernel panic - not syncing: System is deadlocked on memory
CPU: 0 UID: 0 PID: 5149 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
 vpanic+0x552/0x970 kernel/panic.c:651
 panic+0xd1/0xe0 kernel/panic.c:788
 out_of_memory.cold+0xa2/0x170 mm/oom_kill.c:1166
 __alloc_pages_may_oom mm/page_alloc.c:4116 [inline]
 __alloc_pages_slowpath mm/page_alloc.c:4967 [inline]
 __alloc_frozen_pages_noprof+0x24c2/0x2dc0 mm/page_alloc.c:5317
 alloc_pages_mpol+0x1fb/0x540 mm/mempolicy.c:2490
 alloc_pages_noprof mm/mempolicy.c:2581 [inline]
 folio_alloc_noprof+0x22/0x250 mm/mempolicy.c:2591
 filemap_alloc_folio_noprof.part.0+0x377/0x450 mm/filemap.c:1013
 filemap_alloc_folio_noprof mm/filemap.c:2027 [inline]
 __filemap_get_folio_mpol+0x653/0x1320 mm/filemap.c:2012
 __filemap_get_folio include/linux/pagemap.h:761 [inline]
 filemap_fault+0x879/0x3130 mm/filemap.c:3592
 __do_fault+0x10b/0x440 mm/memory.c:5425
 do_read_fault mm/memory.c:5860 [inline]
 do_fault+0xa99/0x1750 mm/memory.c:5994
 do_pte_missing mm/memory.c:4566 [inline]
 handle_pte_fault mm/memory.c:6379 [inline]
 __handle_mm_fault+0x187d/0x2a00 mm/memory.c:6517
 handle_mm_fault+0x37b/0xa30 mm/memory.c:6686
 do_user_addr_fault+0x5a3/0x12f0 arch/x86/mm/fault.c:1343
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6f/0xd0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
RIP: 0033:0x7f72d08a7407
Code: Unable to access opcode bytes at 0x7f72d08a73dd.
RSP: 002b:00007ffff9fa8a10 EFLAGS: 00010202
RAX: 0000000000000000 RBX: 00007f72d1003880 RCX: 00007f72d08a7407
RDX: 0000000000000008 RSI: 00007ffff9fa8b70 RDI: 000000000000000b
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000bb8 R11: 0000000000000202 R12: 0000000000000000
R13: 0000558259d38100 R14: 0000000000000001 R15: 00007ffff9fa8c60
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

