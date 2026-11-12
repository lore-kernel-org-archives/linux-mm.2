Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38EE1606A327
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r4AZbjvV
Received: by kanga.kvack.org (Postfix)
	id 549CF6B00EF; Thu, 12 Nov 2026 04:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA266B05B0; Thu, 12 Nov 2026 04:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 437B06B05BD; Thu, 12 Nov 2026 04:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EBA66B00EF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:48:19 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9C1ED160482
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:48:18 +0000 (UTC)
X-FDA: 85425991476.07.20052B1
Received: from mta1.migadu.com (out-76.mta1.migadu.com [95.215.58.76])
	by imf28.hostedemail.com (Postfix) with ESMTP id 52D3BC0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:48:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r4AZbjvV;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794476896;
	b=DlXU7D3ShkdTpcuY4cWJsXslcdpIiG8ZwEmHdsjYxd7nTGlEpJBEcNMgnD8nijIqacVyfE
	Z9v4YwQz5vzDUE9wPhXajlrDx3OJAJ7oqET1UHAtXiW1c9jscnL8AD18FdjVyh4Po2LMbe
	Rgtqr44PbJlpVHZIken4kLqyqB9PaO4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r4AZbjvV;
	spf=pass (imf28.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.76 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794476896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wkrWrfCSO0Aw1I2CW8QTg9DVaeNot/5RTAx8jWCHJxs=;
	b=eGbIT28P+5r9W/nxQ1DhZD9yedDEDnBh+8I5W3bek3NcF5GfFtsylud3glK1vfGc5RhrzX
	rNb4K+omD/m8iF1FCIWlPewwwjcZiEQTPmlmTwUgxcLUUL2vC5yr8mtYXBMwnaPuA4Yaq8
	f5MjUlNfugXE2Pji/tZzhwARhiymDyc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wkrWrfCSO0Aw1I2CW8QTg9DVaeNot/5RTAx8jWCHJxs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794476894; v=1; x=1795081694;
 b=r4AZbjvV0E9i2FBpqS64xupVfHp/F/l06JO8qkcXV577W0kkdOo6TNNY//SLge2/zM/C0YtF
 QxS2IykLrBmb634GozuZly3e4Juq9ckdpsA53AgsOJ4fIUrR26RBeJq8EuuOdGivwVIFVRV228U
 bbP4P5qSaqopx7tYtpx286Zk=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ae0cc7bf42fa743d;
	Thu, 12 Nov 2026 09:48:14 +0000
X-Mizu-Trace-ID: ae0cc7bf42fa743d
X-Migadu-Flow: FLOW_OUT
Message-ID: <fc81dd0f-4bc7-4064-97de-3b1af8c529b7@linux.dev>
Date: Thu, 12 Nov 2026 17:49:45 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Hao Ge <hao.ge@linux.dev>
Subject: Re: [BUG] alloc_tag: GPF in __pgalloc_tag_sub() during hibernation
 snapshot, page tag ref points into .orc_unwind_ip
To: Konstantin Yagola <master@spicebrains.com>
Cc: linux-mm@kvack.org, "Rafael J. Wysocki" <rafael@kernel.org>,
 linux-pm@vger.kernel.org, Suren Baghdasaryan <surenb@google.com>
References: <CAPy+2=yCzFKxPgzgKw7uCfwpd0BqWk_Mf+DSBY=ydTr_pdHr9g@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CAPy+2=yCzFKxPgzgKw7uCfwpd0BqWk_Mf+DSBY=ydTr_pdHr9g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oupchbjhkirhjjk14t8cnyqow73hx71j
X-Rspamd-Queue-Id: 52D3BC0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794476896-530391
X-HE-Meta: U2FsdGVkX1/T6YNFww7HHuiMNmYlHCJdHDS86ryOVexUC/cEvTGuQJsAY/dKONFj9pyeNg9SB2tvv+JqdSb+8CgH6rOEW3sEkPZU81w+9GrF7veCY3gAgdV+72lfzmWqnxG6Yf7RuIYxfv+UfIsBpJ/mCXZRtaJJtM9zqvo9AvxdDBD8TKWSktK0tex8QCt1TfOKta09kDI1eaqwe67FADo2n8v04DmCtalEEtJ4rUOiX75bMJXIS4HwiJ7zNa4Dz4lOyBq6+2uxbidFpVcgbaecjV1wq+fG5FQSjWnalPwaH9om83Zo0TCVr/qWzNafsPJ/WPQ3niFapFCI+N3tJF9WNS3FXiGhCSg5onSo2Ry+kcbEQWUSm8sI9R0MPW3zcv4USfsLF1DwfZnFhs5nR70XYzEXfcblM6DILvmdvgIXtU200+gZpRVxuRySkbATnMhuAElQKfhKEq6cqY7/0Y7mprLY8Jm9VJLWbiMigu73pTEgxyFzWIKp1wWQvx5NJc/+npFNR6YGh7dMbPJorshP7p787N1OIy0TWxWGtjTg+3bVFu02q4pDcioY0oqa+Rlge0cNXC7Z1p8db6aYucCrzQidtYKdzsNUxGuvGfJ7Ka+wZutp1/VX7RxtBKYtbRP1kMUucFkCRHFGTwPQ6jmL3eiDIDdtKp96FDg5ztq9whrDK0Un56ddEhttO1lYXeG/xGXZ0ZFIscwSe14L5e7AXHcQcHss+oPKloGg42HbVnNorJBe4JRL8Iv6EtDelCGN8Dq7QXz1QQQ1/WWnlHMIOY9HrTTw5wsRCp0TY2hU6PP51s2k+7TKp8dxPSUtV1dvtBcrGxXm7clotufUAEe852BnqKTAUcTNjUmJbMp5vtzlmhfvRr7o12a9pe/qSvmP698huua4Z9eYJaFjD7dpvJyupQN8TuqUFwzHiGnm8FdCZ9sId82ijGz9maeVboVElEfHSDQILg07/GU
 nS3XRKor
 aAtQj0wlWKVTdlRXnawORXCrXnONOFV5PQYBN+oRGPxDdoXTCCYQocq8ucVhGmYGwlD7MzDGfArzfs8YzOAp5pxQ4mnVdlD57MPE5ubrEculZnIlsLKMaMK+HJL3I+BELDfM7rxaTPBxhCo6ZhXU4EQ0JGXSe09xnyuCbMb6ZP4ee7yJBWhATd9VNAIf8xXo2iqa1+GfGyppoQ0836fP7QfXYHI5H1lWCVazV743xBO/8g0+/ljXOr2Z3vu0W9qcEIZCv+pY20vDpF5ClSIetrBowgPAdPt0u4vKEA4oXo7qWffIWi5CK/TAXiYAmTOKbuMXiV8xEYxGw/uqTVOs84YJmiUJ5JJCi7AJ3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Konstantin

On 2026/11/9 16:45, Konstantin Yagola wrote:
> Hi,
>
> my laptop sometimes fails to hibernate: the screen goes dark, the fans
> keep spinning and only a forced power-off helps. It happened twice this
> week on 7.3. Both times pstore caught the same crash: a GPF in
> __pgalloc_tag_sub() while hibernate_preallocate_memory() reclaims
> memory for the image. Both times it was the second or third hibernation
> of the same boot, after successful S4 resumes. It is not every time:
> one boot went through six hibernate/resume cycles without a problem.
>
> Taint first, honestly: P (nvidia), O (openrazer) and S (CPU undervolt
> via MSR). I know S makes any report suspicious, so here is why I think
> this is a software bug and not random corruption:
>
>  - RCX is fe20d545fe20d545 in BOTH crashes, byte for byte, across two
>    different boots with different KASLR offsets;
>  - RDX (the codetag pointer taken from the page) minus the KASLR
>    offset is the same in both crashes: 0xffffffff835ac1f0;
>  - in vmlinux of this build that address is inside .orc_unwind_ip,
>    not an alloc_tag. The faulting code is
>
>        mov  rcx, [rdx+0x20]    ; tag->counters
>        add  gs:[rcx], rax      ; <-- GPF
>
>    so "counters" is just ORC table bytes read as a percpu pointer.
>
> So a page's tag reference ends up as a valid, KASLR-adjusted kernel
> pointer to the wrong place. My guess is that page tag refs get out of
> sync with the tags across a hibernate/resume cycle, but I have not
> verified that.
>
> Setup: Razer Blade 16 (RZ09-0483, BIOS 2.03), i9-13950HX, 32 GB RAM,
> NixOS, kernel 7.3.0 (nixpkgs build, CONFIG_MEM_ALLOC_PROFILING=y,
> ..._ENABLED_BY_DEFAULT=y, not compressed, no _DEBUG), hibernation to a
> 48 GB swapfile on btrfs inside dm-crypt, /sys/power/disk = platform.

Thanks for the excellent report and especially for the disassembly work;
Sorry for the delayed reply.

Based on your configuration, we are using page_ext mode: the codetag pointer
is stored in page_ext. page_ext is allocated via the page allocator as well.

From your disassembly analysis above, we can see the issue is triggered because
the address stored in a page_ext has been overwritten.

Where those 8 bytes live page_ext (normal pages from the buddy, GFP_ZERO'd at early
boot, before any driver loads),  layout as below:

+---------------+---------------+-------------+-------------+
|     ref(pfn1)  | ref(pfn2)      |       ...          | ref(pfn k)  |
+---------------+---------------+-------------+-------------+
|   &tag_a        | &tag_b         |                     |  &tag_k     |
+---------------+---------------+-------------+-------------+

I'm wondering whether an out-of-bounds write from an adjacent page might have clobbered it.
Are there any other clues available? Could you share where I can get the matching vmlinux,
kernel config and dmesg?

Thanks
Best Regards
Hao

>
> Workaround: sysctl.vm.mem_profiling=never on the command line. I cannot
> reproduce this on an untainted kernel: it happens about once a week,
> and with the workaround I will not see it at all. If there is something
> cheaper to collect (a debug option, a printk, a check right after
> resume), I am happy to run it.
>
> Crash 1 (2026-11-09), assembled from pstore:
>
> Oops: general protection fault, probably for non-canonical address
> 0xfe20646ff042c545: 0000 [#1] SMP NOPTI
> CPU: 3 UID: 0 PID: 458460 Comm: systemd-sleep Tainted: P S         O
>     7.3.0 #1-NixOS PREEMPT(lazy)
> Tainted: [P]=PROPRIETARY_MODULE, [S]=CPU_OUT_OF_SPEC, [O]=OOT_MODULE
> Hardware name: Razer Blade 16 - RZ09-0483/SO690, BIOS 2.03 06/04/2024
> RIP: 0010:__pgalloc_tag_sub+0xcc/0x170
> Code: e8 79 f4 08 00 48 85 c0 74 eb 48 03 05 9d 09 d2 01 48 8b 10 48
> 89 c3 48 85 d2 74 1b 44 89 f0 48 8b 4a 20 48 c1 e0 0c 48 f7 d8 <65> 48
> 01 01 48 8b 42 20 65 48 ff 48 08 48 c7 c7 00 19 c3 ac e8 fb
> RSP: 0018:ffffcfcdc517b4d8 EFLAGS: 00010287
> RAX: fffffffffffff000 RBX: ffff8f220292fbc0 RCX: fe20d545fe20d545
> RDX: ffffffffac3ac1f0 RSI: 0000000000000001 RDI: 0000000002bafbc0
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: ffff8f299ed9d260 R11: 0000000000000000 R12: fffff39ed5d7de00
> R13: 0000000000000000 R14: 0000000000000001 R15: ffffcfcdc517b5e8
> Call Trace:
> <TASK>
> free_unref_folios+0x18f/0x830
> shrink_folio_list+0x63e/0x1090
> evict_folios+0x154/0x5f0
> try_to_shrink_lruvec+0x132/0x260
> shrink_one+0xc0/0x1a0
> shrink_node+0xb9e/0xdd0
> do_try_to_free_pages+0xbf/0x480
> try_to_free_pages+0xf6/0x1f0
> __alloc_frozen_pages_noprof+0xa00/0x18d0
> alloc_pages_mpol+0xbc/0x180
> alloc_pages_noprof+0x3b/0x90
> alloc_image_page+0x2d/0xb0
> preallocate_image_memory+0x30/0x64
> hibernate_preallocate_memory+0x257/0x391
> hibernation_snapshot+0x9c/0x4c0
> hibernate.cold+0x10d/0x495
> state_store+0xc3/0xd0
> kernfs_fop_write_iter+0x18a/0x230
> vfs_write+0x25d/0x470
> ksys_write+0x73/0xf0
> do_syscall_64+0x114/0x5c0
> entry_SYSCALL_64_after_hwframe+0x77/0x7f
> </TASK>
> Kernel panic - not syncing: Fatal exception
> Kernel Offset: 0x28e00000 from 0xffffffff81000000
>
> Earlier in that boot: "ACPI: PM: Waking up from system sleep state S4"
> at 28492 s, crash at 83620 s.
>
> Crash 2 (2026-11-07): same RIP, same RCX, RDX ffffffffbc1ac1f0 with
> Kernel Offset 0x38c00000 (same address after subtracting it), but this
> time in kswapd0, 7 s after "PM: hibernation: hibernation entry". Two
> successful S4 resumes earlier in that boot (121257 s, 192472 s).
>
> Full pstore dumps and the vmlinux of this build are available if
> useful.
>
> Thanks, KY.

