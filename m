Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 134C5D38FEB
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF956B0088; Wed, 14 Jan 2026 11:43:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 785C46B0089; Wed, 14 Jan 2026 11:43:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B346B008A; Wed, 14 Jan 2026 11:43:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 530AC6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C770C1ADFF6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:03 +0000 (UTC)
X-FDA: 84331139046.08.954DCD7
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id D9F121C0010
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hgGI6agn;
	spf=pass (imf20.hostedemail.com: domain of dvyukov@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768408982; a=rsa-sha256;
	cv=none;
	b=5lZi9SblVrJcz1tcmjcsUuKfaC+5joOJ3XPInlCvuOXKCfG0RQRNHPmmxi+ki5gh/+jhuB
	0fA3rXRy+mQLhVoVoMa1HEu1V+DmjnRsp6u7zfaxXxJuEJeUIzCx+CX4vDHEBh5rvzw9TY
	k50ZEXJIzgoRtDN2GC6Sknl7EBPeid8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=hgGI6agn;
	spf=pass (imf20.hostedemail.com: domain of dvyukov@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dvyukov@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768408982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hyga6UwPxM24vKU5/IaISzXVkfv7qgVIk+gV0jQM3nw=;
	b=DhvSuNIZc8MpKeOJ15WUmaaVf7zLeqAis2TuCNIflj/ReS9luIQifS/w4Dl/l7hXX9RSnt
	DMCXOcjPi7T4R+58BUOaHQobibGza9jFfH/jgcgoD7IZnvr9uUZZHkD9dR1ul6RO7mP4Xn
	RSYBQ1GQbu0ug50i7R6sLo2PNYdVQyQ=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59b685d2b79so8635680e87.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768408980; x=1769013780; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Hyga6UwPxM24vKU5/IaISzXVkfv7qgVIk+gV0jQM3nw=;
        b=hgGI6agnceCl6euGVB+RQov9oe76MWad7POcHlZG5Fm4UwH7CftnONtV54CWpF6GU5
         QxZMs1GhEqAsvrxqAHoXmisBg8OlawXSpFFKG+F4jN5Gn7M1mPafxxvTHkUXuUvigZUT
         PdpZ99r8Dem0OdoL1SsU6aY6CiakMshzx3XdiBUtUBisAHKRrLZGNnGqi8mTEZvc4h/N
         oHFJp/VkmzKSWRxunkcCtUnOgtRfrlrsa4mZf+CISOd6bV3/Hr9Jvg+E1+NtIZValzy4
         tTCecDndPpw/2sZSKuf1Y2BxZEGlQ1msvYEoB9dUFowHgXyh6FQeiynOd4WDp3sJS9W0
         jMXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768408980; x=1769013780;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hyga6UwPxM24vKU5/IaISzXVkfv7qgVIk+gV0jQM3nw=;
        b=nFj04U0g5yftcBGtLK+mSqMQAItGeR/RMKGcuYkk/8ckw2NYJRfyy6hhdfOUMt0kuq
         z8H0w5m9svu4pZ1OodkCKsTXrdsXvWsvGCFXNrRwasWS+xbk+zCMhosMGPsIyR0V/5LS
         iCmNyycUs+VQRAz2bHaCIpDywIypFnBadPu1T2A5bLK7uTsF4mmebtvVlcnkNSVvNjAA
         k8OUsgYk7awrkrnzZxUoHgeU3833wn3h+G5Oq3ra/6ycJOyHM6dPvHo2nZKnfGsFXdBv
         ijFGRuXWtrSn+9s5zZ6EjLbIrAIpEBfNcCSikF4z3+gGf/n2i30TNgno/oiMyuydPXyM
         pzNg==
X-Forwarded-Encrypted: i=1; AJvYcCWDvfsf5Pb+8pY/VZU7tHYh85wvtWl9sNkdCbBmGdf0urg1ZHFsqf8rgc+lRzoRk+cs6zazouIsfQ==@kvack.org
X-Gm-Message-State: AOJu0Yz4PMeiBBaa2g1R3SLyOjGinfpZ1mBC35beNoMaztypnaFw0+3g
	E4zenf8j54nTAFgQuAJiTip2nBzNeWs+BdkKr4yhVpEaomOgJpbkWsZEcNeIVA7IZFL5MB1l1sr
	GeaCKikgfhZkS8LawXDUpYM/1Pf5pbCgETiv4KKAz
X-Gm-Gg: AY/fxX6vSgYOkSvUGRIzRYk+nSYoebVFTII5TiufkU+kRLljf3ilBF0hhKeBOKDQLhB
	yMUsMyMhrx082NsusEnCyY6QbsBBeqJ4oecMeToY2fvuHq3IckIBJJwZ6AekSAg5E0X2AVfmghO
	zK8heLEql+bgkIzcSWd3oCeEmwugf5lcv75aWtty2x/h7mOjHujL3kH6FrL1HPL//cIYhQFLEzh
	vyxNxziSWrjrhzYEosU/T1NwSKtZNC6QMzAKFCPdTZFKp2lHXSkBk3TCc/lKa0q+vbgZm6OTtA6
	nnh0POqiInT/QRF6WL+p7MRu/hIY
X-Received: by 2002:a05:651c:1502:b0:383:5c1e:bf00 with SMTP id
 38308e7fff4ca-3836066b07cmr10129691fa.14.1768408979200; Wed, 14 Jan 2026
 08:42:59 -0800 (PST)
MIME-Version: 1.0
References: <6967c517.050a0220.150504.0007.GAE@google.com>
In-Reply-To: <6967c517.050a0220.150504.0007.GAE@google.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Wed, 14 Jan 2026 17:42:47 +0100
X-Gm-Features: AZwV_QgxKNPoiXuSYnRpaTJ5CcOamXfdwriqdqH_KAJXf7MGF23Sc2L26Vz6mGk
Message-ID: <CACT4Y+aFaijS_CvzTnHB+ecg5nzYW1-MWPSp-Ad_0ax85=DvCQ@mail.gmail.com>
Subject: Re: [syzbot] [mm?] KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
To: syzbot <syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D9F121C0010
X-Stat-Signature: j8ozkherffzd13f5d51n6geim66637wb
X-Rspam-User: 
X-HE-Tag: 1768408981-157504
X-HE-Meta: U2FsdGVkX1/aWXEQxoP4rNb1vczn69Kv66mD0ZvWvOGdptfWMtCPrB7s7ro9iD42HMY7YqgtOPuk7on1zvRaYgDYgXyHH8AEkEZUQ/7oOql3aBS1IOa/p3Jv36ietF80xxY711chrXOYAnCwY7UkHiFDj3OIRe35XccvAixhQ1HQfy+DJ12GZUOS0Vkn7GEwA7gG6VOvFsD5uf8vJ0BtTQHFQKgfs47OGc4CHIK8sOi2c+BYqJvEpmeaYNdP/KjKhVoT45vyUgzh3SBT8hLwzz2Xjv5LC03zZW/W7pKLDOoXJlWFEnXNoq+CZRzOsQdur9WYs1uSzRPI942udNfIoIt5zBqf5/0vnKMb1Tpm78reSypmQuAWCoJt/mEe1x903tA+ZnXYgci71QQTMA4gXXOCXu1MOOlPGM0GOvuAD/MLSnIXrQJg++A7PPVdbucXBoWu+rZ7D0pL+CSaqo9SsJcga01AycFvyu8k3GHH1PH9rp6Tk4pY1PFRf6us5nL0eSsU1Wb5UZSw+tdeRlhHgLs04CMFElHdBaQ4srOdF3PhBSFyO/J8brpLNhFX69zr7+3i0ekGzqXThjrpEiR7tzWsmyVWxfkScddiDOEDSiWwXrQkA3Our0vJmWTDllZsOO2uKA/KkUgoDx8bdF/fZFAF+OzuoFFB8tYehtkboQz9RxQ2zyfEw7i5d6dYzhUAtgrNtbsUgSjX+/r0rW/T8c+MAZ43X7nzypJ/KCiBmKWuRyq98iW38avaGfP9lP/tVEypZWkNbkHkOaZxNMNmH6tmcPdSFU5I8xyLDAc9/tRf86Jk57cVEYL70dHZf8qSHx+JMKKw46Ed68g4B0ffVBwq0mUyCHgTJae8sqA3ePR37H7lrFpgpeAOGdxGNXMTFilhXlPz8EoGMyyP38LNVOLBuQESmFc3cbqfQe3M34Q5KuXDf1+99ik8N49ycoEBQh4G/8/v8r5LkWpUEGZ
 aQdQO1oN
 Chpsqp9LMrxXPs/VWOdN7B0DRB2WtNTuUM1EcAhYa8m0fTOCDTWKlkWWM6NO2e//eBXXni2ECWlScmwAdxVCyaQd054OOPifUEzmizDPAHphrQzodpk3W5wkd5sKfH+l75WTWFvJsxHKuzIcFgxdECSzXJTkZkQpjWt7zVIBz/6R9Qwlef+oTU+HxZaS1vHdH2Ruq0PhkUlmWyjJivKGofepZ3SzaswM4I1utJxDnbQSzeo+Obrrg5sAHgKFZ5lCTIXf5PkKT/YJMhmzUE9Fg153TMXgzEJe4SIALFRegX/QDVkNWKwXsdLFw/97AOMESAO8LLnWL7VvJ6nRu/7j7k0zGqAtLdaoSleFlQBBrQqLzjOyWWRhpmspq8ba9knXfGS7JYuELJiaiKbxoXEirrXYRadEn219/8J/7YPzElfmW4A3iKa4ob8Nd9a+x2xsbtwIajrCutwpUA4OgANgmu9F1b1m+8NKeAHlFKs8hyDdIP4XmeGOEVF4KbVsf3Qmj00KGRXgqSXXr9kr+d61Btd3KvlbttlgU/Fe2sAJG6R/El054J/v3M5C3QXQbhPRKt9O5txA3E/1mbKpYSaZ01ejE2ITUBAjCBm+VEcKJgTsqypXJXedzMhRQ+sjKlUt7dWbpiKaUcqtmTdVLOj/zkRIvRjt1Y/bPjFBDTv4VyguYwrT9CxkffVWAoLyOS6kclKPHtyWjq3a7ZfMVkXzOFc8MWMMeWf4B9dtvOChgQrs+BcWlai/bko5Ls7pA3+HoWNIa8wywMPCLy9Q3hLgK1hol585RsHyKxQFzR3xlJ+NFyPvN508kkGzd4qlwlJCNUjly/zxmXrr8rncH7c0TIuNq4msqYlmywOLqqk5RX/OrmnKxlJ2RdICmwb1W/XfTj4MPiMhtYomhGSjfXEzkrGuuGGu69PlQRoix22rswkbRz0BvxPA4oSYNXIP4Qtz+Z0fWL7xLR92xXNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 14 Jan 2026 at 17:32, syzbot
<syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    cfd4039213e7 Merge tag 'io_uring-6.19-20251208' of git://g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=1554d992580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c3201432211be40f
> dashboard link: https://syzkaller.appspot.com/bug?extid=f5d897f5194d92aa1769
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/9f556ae6e3c4/disk-cfd40392.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/efcf53c1d459/vmlinux-cfd40392.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/858f42961336/bzImage-cfd40392.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+f5d897f5194d92aa1769@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KCSAN: data-race in __anon_vma_prepare / __vmf_anon_prepare
>
> write to 0xffff88811c751e80 of 8 bytes by task 13471 on cpu 1:
>  __anon_vma_prepare+0x172/0x2f0 mm/rmap.c:212
>  __vmf_anon_prepare+0x91/0x100 mm/memory.c:3673
>  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
>  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
>  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
>  do_user_addr_fault+0x3fe/0x1080 arch/x86/mm/fault.c:1387
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x62/0xa0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
>  fault_in_readable+0xad/0x170 mm/gup.c:-1
>  fault_in_iov_iter_readable+0x129/0x210 lib/iov_iter.c:106
>  generic_perform_write+0x3cf/0x490 mm/filemap.c:4363
>  shmem_file_write_iter+0xc5/0xf0 mm/shmem.c:3490
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x52a/0x960 fs/read_write.c:686
>  ksys_pwrite64 fs/read_write.c:793 [inline]
>  __do_sys_pwrite64 fs/read_write.c:801 [inline]
>  __se_sys_pwrite64 fs/read_write.c:798 [inline]
>  __x64_sys_pwrite64+0xfd/0x150 fs/read_write.c:798
>  x64_sys_call+0x9f7/0x3000 arch/x86/include/generated/asm/syscalls_64.h:19
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd8/0x2a0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> read to 0xffff88811c751e80 of 8 bytes by task 13473 on cpu 0:
>  __vmf_anon_prepare+0x26/0x100 mm/memory.c:3667
>  hugetlb_no_page+0x1c4/0x10d0 mm/hugetlb.c:5782
>  hugetlb_fault+0x4cf/0xce0 mm/hugetlb.c:-1
>  handle_mm_fault+0x1894/0x2c60 mm/memory.c:6578
>  faultin_page mm/gup.c:1126 [inline]
>  __get_user_pages+0x1024/0x1ed0 mm/gup.c:1428
>  populate_vma_page_range mm/gup.c:1860 [inline]
>  __mm_populate+0x243/0x3a0 mm/gup.c:1963
>  mm_populate include/linux/mm.h:3701 [inline]
>  vm_mmap_pgoff+0x232/0x2e0 mm/util.c:586
>  ksys_mmap_pgoff+0x268/0x310 mm/mmap.c:604
>  x64_sys_call+0x16bb/0x3000 arch/x86/include/generated/asm/syscalls_64.h:10
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xd8/0x2a0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> value changed: 0x0000000000000000 -> 0xffff888104ecca28
>
> Reported by Kernel Concurrency Sanitizer on:
> CPU: 0 UID: 0 PID: 13473 Comm: syz.2.3219 Tainted: G        W           syzkaller #0 PREEMPT(voluntary)
> Tainted: [W]=WARN
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
> ==================================================================

Hi Harry,

I see you've been debugging:
KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
https://lore.kernel.org/all/694e3dc6.050a0220.35954c.0066.GAE@google.com/T/

Can that bug be caused by this data race?
Below is an explanation by Gemini LLM as to why this race is harmful.
Obviously take it with a grain of salt, but with my limited mm
knowledge it does not look immediately wrong (re rmap invariant).

However, now digging into details I see that this Lorenzo's patch
also marked as fixing "KASAN: slab-use-after-free Read in
folio_remove_rmap_ptes":

mm/vma: fix anon_vma UAF on mremap() faulted, unfaulted merge
https://lore.kernel.org/all/b7930ad2b1503a657e29fe928eb33061d7eadf5b.1767638272.git.lorenzo.stoakes@oracle.com/T/

So perhaps the race is still benign (or points to another issue?)

Here is what LLM said about the race:
-----

The bug report is actionable and points to a harmful data race in the Linux
kernel's memory management subsystem, specifically in the handling of
anonymous `hugetlb` mappings.

**Analysis:**

1.  **Race Location:** The data race occurs on the `vma->anon_vma` field
       of a `struct vm_area_struct`.
    *   **Writer:** Task 13471 executes `__anon_vma_prepare` in `mm/rmap.c`.
        This function initializes the `anon_vma` for a VMA. It holds
        `mm->page_table_lock` and writes to `vma->anon_vma` (line 211 in the
        viewed source, corresponding to the report's `mm/rmap.c:212` area).
    *   **Reader:** Task 13473 executes `__vmf_anon_prepare` in `mm/memory.c`.
        This function is an optimization wrapper that checks if
        `vma->anon_vma` is already set (line 3666/3667) to avoid the overhead
        of `__anon_vma_prepare`. This check is performed **without** holding
        `mm->page_table_lock`.

2.  **Consistency:** The report is consistent. Both tasks are handling
`hugetlb` page faults (`hugetlb_no_page` -> `__vmf_anon_prepare`).
The writer stack shows it proceeded into `__anon_vma_prepare` (implying
`vma->anon_vma` was NULL initially), while the reader stack shows it
reading `vma->anon_vma`. The value change `0x0000000000000000 ->
0xffff888104ecca28` confirms initialization from NULL to a pointer.

3.  **Harmfulness (Why it is not benign):**
    *   In `__anon_vma_prepare`, the code currently initializes
    `vma->anon_vma` **before** linking the VMA to the `anon_vma`
    structure via `anon_vma_chain_link`.
    *   ```c
        vma->anon_vma = anon_vma;
        anon_vma_chain_link(vma, avc, anon_vma);
        ```
    *   Because the reader (`__vmf_anon_prepare`) checks `vma->anon_vma`
    locklessly, it can see the non-NULL value before `anon_vma_chain_link`
    has completed (due to compiler/CPU reordering or simple preemption
    between the two statements).
    *   If the reader proceeds, it assumes the `anon_vma` is fully ready.
    It then maps a page and sets `folio->mapping = anon_vma`.
    *   However, if `anon_vma_chain_link` hasn't finished, the `anon_vma`
    (specifically its interval tree) does not yet contain the entry for
    this `vma`.
    *   This breaks the reverse mapping (rmap) invariant. If the kernel
    subsequently tries to unmap or migrate this page (finding it via
    `folio->mapping`), `rmap_walk` will fail to find the VMA in the
    `anon_vma`'s interval tree. This can lead to pages being effectively
    pinned, migration failures, or in worst-case scenarios (like memory
    corruption handling or specific reclaim paths), logical errors where
    a page is assumed unmapped when it is not.

4.  **Fix:** The fix requires enforcing ordering. `vma->anon_vma` should
be set **after** `anon_vma_chain_link` is complete, and `smp_store_release`
/ `smp_load_acquire` (or equivalent barriers) should be used to ensure the
reader observes the fully initialized state.

