Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E74A0CA5FDD
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 21:35:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7536B0088; Fri,  2 Oct 2026 17:35:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8981D6B008A; Fri,  2 Oct 2026 17:35:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 786C66B008C; Fri,  2 Oct 2026 17:35:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 47F8F6B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 17:35:03 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B95AA40870
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:35:02 +0000 (UTC)
X-FDA: 85278991644.23.DD9A51E
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 87B6340007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 21:35:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SaBXNwBl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8ZToiGbI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="T4/ZGIJD";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t2I1h8x8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790976900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v2IxeNoFs1zgMWILLB8hyk9e3lt3hkRC40MEs5rXaCM=;
	b=SVYLtFV6p+Pn0ySMFhl3G0FViziRk2C/i9n9tPUqrT5UAgEHrXj2FCDUtf6FkxcoSGCJhS
	TdRsuUmFgkjoQimpB/DBvKt3uFGrJGzD5LGKQ46+9jiepy/TUkhbUHd0oXkMdTwjBcXHqF
	gBApvwkIudlKt9Ywl1BjOemcyl1MJx8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=SaBXNwBl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8ZToiGbI;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="T4/ZGIJD";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=t2I1h8x8;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790976900;
	b=qOkwc9yMOMdbZ8So7qGaG9XfvsTZ7ZV1SHWJTQtYbp5DMqXun+u1mPrDTinBVgxjRb8Mwr
	7I4RCJsj6s15XaArRsqxqvPHcnSIu8hCNtGw8+apu4bKm6eWLwDi9osNP13mSh8xrg6uP7
	ErcKDsLrrCcmVZby73vkniAsSaaw4E4=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B5AF1FDC5;
	Fri,  2 Oct 2026 21:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790976894; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2IxeNoFs1zgMWILLB8hyk9e3lt3hkRC40MEs5rXaCM=;
	b=SaBXNwBlfIUJUHuegldFFgE1q7izh7yHRUDeReJZ3VUxn6wq7e67gRYAmerczFJMUwGEIQ
	WuTkEONnT/eRhlbJQ/3fnGg07eoyq0wczjH3A2UmrsBODaHOKb6DXzJESWU0/Iydyb4t3i
	jy0ubu0kKjJMn1Vt751JCqnUAGQseLM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790976894;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2IxeNoFs1zgMWILLB8hyk9e3lt3hkRC40MEs5rXaCM=;
	b=8ZToiGbIA8Brm9Tq7WUQVNwkOZoHS0Cq2cLhguKlugVp4vWO2SxuTykhleoNjJoSvVCtFF
	b9tZgFxuClHT8fCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790976890; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2IxeNoFs1zgMWILLB8hyk9e3lt3hkRC40MEs5rXaCM=;
	b=T4/ZGIJDW8b0lkwKpYfa0+yxyMLgOu9NXGBab1JqRHqWcycvDTZ+wP2RC4WOZOHBbskdhY
	Ck9B3tx6veKUyhEq6buPPi0NtxuYCBJUFZEaI30fAsMsjtCXWQh92iRvNPyYohG8KgvQuk
	bbfLs3h2c7Z670reBIrwrN3c1/pT5/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790976890;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v2IxeNoFs1zgMWILLB8hyk9e3lt3hkRC40MEs5rXaCM=;
	b=t2I1h8x8HmPBeCIZzBp9YcUjxn8SbnvMS9NFtxKxqXNpOqAI6k3YpA9Qg7zoCLWUTPMgNx
	3vaij3aWVAfomcAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 14D71139E2;
	Fri,  2 Oct 2026 21:34:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id baj7NHkjwGpDcgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 02 Oct 2026 21:34:50 +0000
Date: Fri, 2 Oct 2026 22:34:48 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-cxl@vger.kernel.org
Subject: Re: Poor memory bandwidth performance between NUMA nodes
Message-ID: <asAjUfNg_80sA6Yn@pedro-suse.tail5790ac.ts.net>
References: <CAAiJnjqz+OB+PmUQBENS8ThnWHSAFK=p3EA7KPsy5UeabQCn-A@mail.gmail.com>
 <ar_rPzLhXRSA0AfS@gourry-fedora-PF4VCD3F>
 <CAAiJnjo86U27YwFNSkQNvqxDyGMZomoqHToH3GqWuzqD2+V0Vg@mail.gmail.com>
 <ar_zftIk5caN-5uV@gourry-fedora-PF4VCD3F>
 <CAAiJnjrjtseaUPo5vyqGZeDAt4ST6eqvaXOCWvdaTUsx2D3v5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAiJnjrjtseaUPo5vyqGZeDAt4ST6eqvaXOCWvdaTUsx2D3v5g@mail.gmail.com>
X-Rspamd-Action: no action
X-Stat-Signature: 7aprfehm93abxwrahfuqubak6itmtywu
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 87B6340007
X-HE-Tag: 1790976900-548257
X-HE-Meta: U2FsdGVkX1/GmI9oX+cz+RedQV+BBQh5EXZNufu+X5r/MwdI4hNUlLJCni1EkqmXBvQTbbd7EY6R35+bRtcIbECOMKwo7tjt/Xdx898Gu91PZeQ+iH85+c8HySe1B+lecHkkCBWEPD35EdZiBnkl+fVafSE6vHJV8aG+EbQMd3bXWGhf+aLRENcEY3EnbCQwuUXsWCO/jstSfZjLdd8wba++XG/LTDilaGKMp/qthXTt1jnNooDdTY0WVr6iE93CpHD/T0+jduGTAeQsQX5apjb3X70HRytszS2SGFlV+ChEqvNlb9CuVkMwiG6FWCr2Sk1LvjeqGAE/NtBH78ZIfMNYghbtIwzUfORP1bjx+XOfPdPUfzfE3BUODFzc9VXwPIOELRiPogrs9EI1NycEvRT/5YFotYdLOwgPeVHOMDlxN7+qC3lezR5w3U3WsipFdD5Wy0BK9APFXMlCDJa7R66ZrxlnVVIZPedDxATpjKGeJM/IetXvUFDddjKJW4hsz4wdTj2mrR/0el2sBeI6Nkh1b0tpbWL3W+wv3GTuCmcS0zhyXibpApRtLFfRjzfE7jHsAwUXIP72NHOEBfm2WOxPzK2woXFLvClYHKupDIehbGKKkSQIaVXmeK4Rs5p1j3f7nijL6b+nlJMyv7NCYuQcKMN+jU7YKJhiSGitwvPdH2VpF6EiRMGrU2cWmf5Xe0D8AIb01sd4a9s5vjH87Bvn9ZkeoKEEAPVncdXbydloDd4ALH9RzRkVnncvKUStZ0a5dAoX6na8b2TXNhw84zatbdWIXySiS1mLY+fF0IKx9lhpvzyAoHiPhAjXWXJnlOe8NBd9XAV3BXhkisWC3/pCOp9vJ8dIuk9JkXhwzQ8z+8IWOQA1ICetqAMYL9EjjFBboYiKYXeusQExQkBWETBqMYG3zcc7BM54IMpx60tMxOdY9CXW67BJ+4lbUdTDjRv8xy3alpDMuPASuzw
 DwOdM6iN
 cSVW3X+Mcz/ltpFyCGWB9Jp7wuluJYqlso6fEAgFa+3j8XCfLZTPD5xaQNQubR7Q/+j4Tr9vAbEIhQt2L9LeI2kmgbcPSkp0waKT0z2puEFIsswttBKMh4cNoBPm1VHYJLl1Yxkca/wKabyIODPMPMptg0jzNOBeB6Hx10C5XYDpW/G2HyuKO7DTi1TsC27iB7Ym/xhxS77g90EfYVDFG9wWVL4AnnLAlj3cJWmzXKvVmOqvnGzNBiCuGhjFZMuyUrJDuVXZQJ+JRT4egP9wYMIiCt53U7j0jVp4F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 02, 2026 at 09:55:32PM +0300, Anton Gavriliuk wrote:
> > I'm unfamiliar with Valkey, but you may want to ask how contended those
> > pages are if they're actually being used during migration time.
> 
> > Do you get this same behavior when migrating the same amount of memory
> > allocated by a toy program? (i.e. known idle pages)
> 
> I don't think that there is any contention.
> There is no processing, etc.
> This is a completely idle test server.
> I just populated 300GB memory by key-value data store.
> 
> Even if I use simple stress-ng instead of Valkey,
> 
> [root@localhost ~]# numactl --cpunodebind=0 --preferred=0 stress-ng
> --vm 1 --vm-bytes 300G --vm-hang 0 &
> [1] 4353
> [root@localhost ~]# stress-ng: info:  [4353] defaulting to a 1 day run
> per stressor
> stress-ng: info:  [4353] dispatching hogs: 1 vm
> stress-ng: info:  [4355] vm: using 300GB per stressor instance (total
> 300GB of 6.43TB available memory)
> 
> 
> [root@localhost ~]# COLUMNS=500 numastat -p 4356 | cat
> 
> Per-node process memory usage (in MBs) for PID 4356 (stress-ng-vm)
>                            Node 0          Node 1          Node 2
>     Node 3           Total
>                   --------------- --------------- ---------------
> --------------- ---------------
> Huge                         0.00            0.00            0.00
>       0.00            0.00
> Heap                         0.06            0.00            0.00
>       0.00            0.06
> Stack                        0.03            0.00            0.00
>       0.00            0.03
> Private                 307201.14            0.74            0.00
>       0.00       307201.88
> ----------------  --------------- --------------- ---------------
> --------------- ---------------
> Total                   307201.23            0.74            0.00
>       0.00       307201.97
> [root@localhost ~]# man migratepages
> [root@localhost ~]# migratepages 4356 0 2
> 
> I see even slower (System PMM Write) than 1.4 GB/s,
> 
> |---------------------------------------||---------------------------------------|
> |--            System DRAM Read Throughput(MB/s):        842.67
>         --|
> |--           System DRAM Write Throughput(MB/s):        851.34
>         --|
> |--             System PMM Read Throughput(MB/s):        785.27
>         --|
> |--            System PMM Write Throughput(MB/s):        804.57
>         --|
> |--                 System Read Throughput(MB/s):       1627.94
>         --|
> |--                System Write Throughput(MB/s):       1655.91
>         --|
> |--               System Memory Throughput(MB/s):       3283.85
>         --|
> |---------------------------------------||---------------------------------------|
> 
> 
> top - 21:49:22 up  4:53,  3 users,  load average: 0.97, 0.78, 0.61
> Tasks: 774 total, 2 running, 772 sleep, 0 d-sleep, 0 stopped, 0 zombie
> %Cpu(s):  0.0 us,  1.8 sy,  0.0 ni, 98.2 id,  0.0 wa,  0.0 hi,  0.0 si,  0.0 st
> MiB Mem : 6839822.+total, 6432377.+free, 422358.2 used,    790.2 buff/cache
> MiB Swap:   8192.0 total,   8192.0 free,      0.0 used. 6417463.+avail Mem
> 
>     PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
>    4507 root      20   0    2644   1764   1644 R  99.8   0.0   2:20.63
> migratepages
>    1592 root      20   0   82184   5056   3932 S   0.3   0.0   0:07.26
> irqbalance
>    4993 root      20   0       0      0      0 I   0.3   0.0   0:00.02
> kworker/50:0-events
>    4999 root      20   0   10916   6080   3772 R   0.3   0.0   0:00.03 top
>       1 root      20   0   25528  15488  10484 S   0.0   0.0   0:02.35 systemd
>       2 root      20   0       0      0      0 S   0.0   0.0   0:00.06 kthreadd
>       3 root      20   0       0      0      0 S   0.0   0.0   0:00.00
> pool_workqueue_release
>       4 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-rcu_gp
>       5 root       0 -20       0      0      0 I   0.0   0.0   0:00.00
> kworker/R-sync_wq
> 
> Samples: 26K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> 21652648047 lost: 0/0 drop: 0/0
> Overhead  Shared Object                      Symbol
>   21.77%  [kernel]                           [k] copy_mc_fragile
>   18.88%  [kernel]                           [k] clear_highpages_kasan_tagged
>   17.81%  [kernel]                           [k] migrate_folio_unmap
>    2.67%  [kernel]                           [k] __folio_alloc_noprof
>    2.09%  [kernel]                           [k] smp_call_function_many_cond
>    1.89%  [kernel]                           [k] try_to_migrate_one
>    1.74%  [kernel]                           [k] folio_migrate_flags
>    1.69%  [kernel]                           [k] page_vma_mapped_walk
>    1.14%  [kernel]                           [k] remove_migration_pte
>    1.01%  [kernel]                           [k] rmqueue_bulk
>    0.88%  [kernel]                           [k] migrate_folio_move
>    0.87%  [kernel]                           [k] __mod_memcg_lruvec_state
> 
> Samples: 111K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> 56222244297
> copy_mc_fragile  /proc/kcore [Percent: local period]
>    0.00 │      cmpl  $0x8,%edx
>         │    ↓ jb    43
>         │      testl $0x7,%esi
>    0.03 │    ↓ je    27
>         │      movl  %esi,%ecx
>         │      andl  $0x7,%ecx
>         │      subl  $0x8,%ecx
>         │      negl  %ecx
>         │      subl  %ecx,%edx
>         │19:   movb  (%rsi),%al
>         │      movb  %al,(%rdi)
>         │      incq  %rsi
>         │      incq  %rdi
>         │      decl  %ecx
>         │    ↑ jne   19
>         │27:   movl  %edx,%ecx
>         │      andl  $0x7,%edx
>         │      shrl  $0x3, %ecx
>    0.02 │    ↓ je    43
>   58.57 │31:   movq  (%rsi),%r8
>   12.21 │      movq  %r8,(%rdi)
>    4.22 │      addq  $0x8,%rsi
>    8.25 │      addq  $0x8,%rdi
>    0.53 │      decl  %ecx
>   16.06 │    ↑ jne   31
>         │43:   andl  %edx,%edx
>    0.02 │    ↓ je    57
>         │      movl  %edx,%ecx
>         │49:   movb  (%rsi),%al
>         │      movb  %al,(%rdi)
>         │      incq  %rsi
>         │      incq  %rdi
>         │      decl  %ecx
>         │    ↑ jne   49
>    0.02 │57:   xorl  %eax,%eax
>    0.06 │    ← retq
>         │      int3
>         │      int3
>         │      int3
>         │      int3
> 
> Samples: 187K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> 84234492777
> clear_highpages_kasan_tagged  /proc/kcore [Percent: local period]
> Percent │      nop
>    0.03 │      subq 0x1a5067c(%rip),%rdi
>    0.01 │      movl %esi,%ecx
>         │      xorl %eax,%eax
>    0.03 │      sarq $0x6, %rdi
>         │      shlq $0xc, %rcx
>    0.03 │      shlq $0xc, %rdi
>    0.03 │      addq 0x1a50675(%rip),%rdi
>   99.72 │      rep  stosb   %al, %es:(%rdi)
>    0.09 │      nop
>    0.06 │    ← retq
>         │      int3
>         │      int3
>         │      int3
>         │      int3
>         │      nop
> 
> Samples: 223K of event 'cpu/cycles/P', 4000 Hz, Event count (approx.):
> 88021056491
> migrate_folio_unmap  /proc/kcore [Percent: local period]
>    0.04 │       movq   %rdi,%rax
>         │       movq   %rcx,%rdi
>         │       movq   %rbx,0x8(%rsp)
>         │       movq   %rcx,%rbx
>    0.04 │       movq   %r12,0x18(%rsp)
>         │       movq   %rsi,%r12
>         │       movq   %rdx,%rsi
>         │       movq   %r13,0x20(%rsp)
>    0.06 │       movq   %rdx,%r13
>         │       movq   %r14,0x28(%rsp)
>         │       movl   %r9d,%r14d
>         │       movq   %r15,0x30(%rsp)
>    0.05 │       movq   %r8,%r15
>         │     → callq  *%rax
>    0.05 │       testq  %rax,%rax
>         │     ↓ je     2e3
>    0.06 │       movq   %rbp,0x10(%rsp)
>    0.04 │       movq   %rax,%rbp
>    0.20 │       movq   %rax,(%r15)
>    0.07 │       movq   $0x0,0x28(%rax)
>   97.01 │       lock
>         │       btsq   $0x0,(%rbx)

...are the struct pages on the pmem node itself?

-- 
Pedro

