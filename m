Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1E43FCC9CC
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 06:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 167ED6B0089; Tue, 10 Mar 2026 02:29:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 115AB6B008A; Tue, 10 Mar 2026 02:29:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03E946B008C; Tue, 10 Mar 2026 02:29:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7F646B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 02:29:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 905331C609
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:29:08 +0000 (UTC)
X-FDA: 84529175976.16.0D69463
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11B06C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 06:29:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3MrqvaQkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3MrqvaQkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773124147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=rh1FFgXJWrBr2+Z9D9TX5buPNtwittF7cccRXqbBfsk=;
	b=6iP8KxaV4LPUgRf7gf/WCRJlqBZcjudacJ3VEv97G7oJb4bdIUC+sC/6wnXXYkLlZsK/ip
	D0VKPvvCy/0iuQ343/a5ZpUmYWRPJfcdDqPpuu0f1rUldeoaxEtXdR2pEoPlfw93uFt/69
	CDyDGQiFhfXoCopHzeGajq2daPfNa2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773124147; a=rsa-sha256;
	cv=none;
	b=uaYuHTWhcJcjBAet6zQ49L8oAUSef+7aj4lJHU5jpjdmeg1CjrfYL2hAicaCKuqzevIdzJ
	2wRpUabQ5vE1xWmt7df59DS7sauwre1UpfE0lcoDGbjurxBha/DI+gCe91qnQxVoTSdalH
	0KxuFUnigY5GZgCUC8eDADXTvgQfTAk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3MrqvaQkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.69 as permitted sender) smtp.mailfrom=3MrqvaQkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bbfa324fbso5453148eaf.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 23:29:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773124146; x=1773728946;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rh1FFgXJWrBr2+Z9D9TX5buPNtwittF7cccRXqbBfsk=;
        b=MUcvcBQbxgPQzvbc0nZdY/JuL3HtXMO/mAUdQBxxgtct2c6ky/qcBHfRoZtP2f3iRm
         0bRSGDbjDAlpObUz3wUTG3cI1WzHKHMuO0GcIHVVm7notljEeo2NVDWz6qTyqOIOs3FP
         ANvvo30FOB1jGRM/1cMDEtakopWyXcf760sCEvDhW+knKawUciw+Dr/ih0m3lgszkeSt
         2tPP0LIUTeTyd/X7LxMjrQSyy2RrRpAkjxnrY8+cb7EGioihoUDf3iiK2xAXzajh27GD
         OHT8/oJ2SZLU0GmlMppOtiUyKRM/oTV4sC6hz+RVgz88jEACQaS4AMKpfL7+7w/yRvY+
         v6IQ==
X-Forwarded-Encrypted: i=1; AJvYcCUOQ7wZtCVbnPz+LxiMvCcxdsh8ujRZClWtaEwBK5IM8kiqWg/L0sOcZrzNidQoFFrtO7HmgCUD0g==@kvack.org
X-Gm-Message-State: AOJu0YxBhgN1wQItMuBJasyBh9AgPduNaxIs8hiVj7i2AfBNOtvrEudf
	KeRMyty4212EZsnTPFGoDdridHjCtAWcE+pRPxhvP6JoGN5nryzotbKKQZFRyIPoU0A+k9Ld6W0
	zrzt7MPxKXResrqsEV5nLBmuLHH/GufcPG2wNzgeckDFz6WCr2I/iU9YAxGU=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca1:b0:67b:b89e:22af with SMTP id
 006d021491bc7-67bb89e23dbmr2349238eaf.51.1773124146144; Mon, 09 Mar 2026
 23:29:06 -0700 (PDT)
Date: Mon, 09 Mar 2026 23:29:06 -0700
In-Reply-To: <aa-1-Y3v3D1hzPvL@hyeyoo>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69afba32.a00a0220.d013.0002.GAE@google.com>
Subject: Re: [syzbot] [mm?] [f2fs?] [exfat?] memory leak in __kfree_rcu_sheaf
From: syzbot <syzbot+cae7809e9dc1459e4e63@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, catalin.marinas@arm.com, chao@kernel.org, 
	hao.li@linux.dev, harry.yoo@oracle.com, jaegeuk@kernel.org, jannh@google.com, 
	liam.howlett@oracle.com, linkinjeon@kernel.org, 
	linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lorenzo.stoakes@oracle.com, 
	pfalcato@suse.de, sj1557.seo@samsung.com, syzkaller-bugs@googlegroups.com, 
	vbabka@kernel.org, vbabka@suse.cz, wangqing7171@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 11B06C0005
X-Stat-Signature: 75nqmgk65nzjxgingf1f7q1kgxgpfwrk
X-HE-Tag: 1773124146-915836
X-HE-Meta: U2FsdGVkX18hgqCX3FYx0D0HbMOIICWHfMlf/y8OYHgSEcur9wsXllCoEKKTH3ox104Dn4PHD70ymcgoC9TMa95U6xOHWrYWW7yKH3/SZEjkgRCnNKtri2Iih52ahvL3MhkfI/WTkK01h9QiLpMx6eXzJw+p0jFdfulsin5BEXxJYPvNBqv+Aq0AqXj1q5w1bRIbz7D3RrCGrtL/mSqvSYHAnpw09SbXHCXTUkXjWPruc5lWw3FdmbKNUZGGCd/x6nijsI+ICx/noxZPYBu4GqHG8ypQcgzOK0PU+dFqmahQJH7BOUgMEDIgfjLM0686Z/ngCq5TKYfM/452/q1PZtT/VPu2xT9URJw5VuGISV4bOWWh7iSHBheG8JuATin4T04dYakT+c6v5/hOKzj7FcLRnR3OMb7mPyL8dTsMxmx6uObf2EFzq0Qv9d9LpeasVZVkvU8NS0AXFXnFW3JqZ7me2TQMGxKzW7v5a6VpsLVZPtAXdsmdfIzm8INn+5p/AsKruNYcwedoWslUHDjY6ycPDRNWTeSnp19/U2RBIFovaEAj7D+94y3cGx63BqnjBPy1ezPYZFTazRWTLlM5S61SoLUayHaX98YRfAAshhAZw54yPMWP2SXpMtJ7SMD8jJwSKH658TA4X5T9T+vY5yjJ3sLWu1OI1sGcnv+3NKO22i3ELqn5kWB+aGq5x3nmJ1iU/uGTMI3WtM6znik6Eqa8BukFL0fpsGel6CuWUqtpzHKMI0DYAy5xOEzEj7jZlXhp2Y5kzndp5DlL6AcD3AYPplps336ilwc5GFfdCd+ddTBwEgNDVomFNBka951HowaJL4Lnl50PdbdaSS8Vza39wBjnTImu4WliWz8uoWE4VNCmLQtw5S2R2dBy9ZIUqvaXL6lybZhgHWSWqZmgpNyJ1sRySqKF34xKF//DnFBdWfFPPU4tAJHzeSrKFzowjBAyB4Nt2fyCBtpfxPY
 5H1K2pKm
 IRwXaSI0VcZVLp3X21a6MrReyJ4qq44klXDfE5anm5m3P/ZnGs9UGSH53fK7wIfIKt/1MoRLCWtIuJEFb2mMnJRQjXpHMXBQlhmmh7wppr6Jm5GF6ieU/tVHRGjdGG6EZvQ5IXwklKpQ5rRk/bglMr63mqd7SeXEIxiEKmpcOULkf1hE1aI6D5SeQWL/ji4BMcCf2wy05p/hx/2j6xfrKPDzQlY4X2DyClC43nBo0zOT4u4Wik7n3oEU/QNZl/EWMcwq8vDSh2HsLKCYLEwN+6rcmr9QWsYPJzfAc+x7/e0sZSdOff1z9Q8M1VO3rceWw25859pi1JJpK8FVcJ/ql8qib1ZLhwJ6dh9UNAsru4U6r4Qw78OPCL/YxpZS7uUOd/AldBw62Bcl3tYTqscwYBNy2EWbED57xTRtf0igmJu/EpOo8Ni5AQKpOSS1uJHcHildu97PTxZUGa7qoPBym00zpnktRO0/ucDyB0sWs01hTYiochHRfK2QZeUecIxAgsT+7I1IfqQaAOdwqBFnIAALvt25+uf24wMMD/lwj32sUoNDW2mOONWsTUhKKPpcml03H1bGWr8bo39cc82IiDmf9P7Isqf4gEsrRmeK/5q+saxcVCsmu5wxZ6dvVK6hJRH7BK/R5QnT6FisdVEaKEh7ihN1gdwqg4mng
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
memory leak in copy_process

BUG: memory leak
unreferenced object 0xffff888101799d80 (size 184):
  comm "kthreadd", pid 2, jiffies 4294948049
  hex dump (first 32 bytes):
    01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    0a 21 00 00 00 00 00 00 58 78 fd 01 81 88 ff ff  .!......Xx......
  backtrace (crc e9f8bd9):
    kmemleak_alloc_recursive include/linux/kmemleak.h:45 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    kmem_cache_alloc_noprof+0x372/0x480 mm/slub.c:4881
    alloc_pid+0xe4/0x850 kernel/pid.c:189
    copy_process+0x1a97/0x28c0 kernel/fork.c:2239
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810b0d7b40 (size 184):
  comm "kthreadd", pid 2, jiffies 4294948049
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc ddb1bc35):
    kmemleak_alloc_recursive include/linux/kmemleak.h:45 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    kmem_cache_alloc_noprof+0x372/0x480 mm/slub.c:4881
    prepare_creds+0x22/0x600 kernel/cred.c:185
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x28c0 kernel/fork.c:2084
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

BUG: memory leak
unreferenced object 0xffff88810b91e4a0 (size 32):
  comm "kthreadd", pid 2, jiffies 4294948049
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    f8 6e 0a 00 81 88 ff ff 00 00 00 00 00 00 00 00  .n..............
  backtrace (crc 13ba6aa5):
    kmemleak_alloc_recursive include/linux/kmemleak.h:45 [inline]
    slab_post_alloc_hook mm/slub.c:4552 [inline]
    slab_alloc_node mm/slub.c:4874 [inline]
    __do_kmalloc_node mm/slub.c:5267 [inline]
    __kmalloc_noprof+0x3bd/0x560 mm/slub.c:5280
    kmalloc_noprof include/linux/slab.h:954 [inline]
    kzalloc_noprof include/linux/slab.h:1188 [inline]
    lsm_blob_alloc+0x4d/0x80 security/security.c:192
    lsm_cred_alloc security/security.c:209 [inline]
    security_prepare_creds+0x2d/0x290 security/security.c:2763
    prepare_creds+0x395/0x600 kernel/cred.c:215
    copy_creds+0x44/0x290 kernel/cred.c:286
    copy_process+0x7a7/0x28c0 kernel/fork.c:2084
    kernel_clone+0xac/0x6e0 kernel/fork.c:2654
    kernel_thread+0x80/0xb0 kernel/fork.c:2715
    create_kthread kernel/kthread.c:459 [inline]
    kthreadd+0x186/0x250 kernel/kthread.c:817
    ret_from_fork+0x23c/0x4b0 arch/x86/kernel/process.c:158
    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

connection error: failed to recv *flatrpc.ExecutorMessageRawT: EOF


Tested on:

commit:         1f318b96 Linux 7.0-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1224694a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=2c6ad6fefffa76b1
dashboard link: https://syzkaller.appspot.com/bug?extid=cae7809e9dc1459e4e63
compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
patch:          https://syzkaller.appspot.com/x/patch.diff?x=110faf5a580000


