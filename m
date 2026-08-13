Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BA43C5AD5A
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 00:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCE376B0346; Wed, 12 Aug 2026 20:08:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7FEE6B0347; Wed, 12 Aug 2026 20:08:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A953B6B0348; Wed, 12 Aug 2026 20:08:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64E176B0346
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 20:08:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C9FE01C15C7
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:08:35 +0000 (UTC)
X-FDA: 85094309790.06.C2838CC
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf30.hostedemail.com (Postfix) with ESMTP id 32E1D80008
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 00:08:34 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3AQt9agkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3AQt9agkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786579714;
	b=4CJAZyLXKc4yYgCNr0ZF3j9XIwatazTF0INrH5CZoibtd1DEs2FiZ3lZRO0VMgy0kliEzI
	+osVYGvPd1O/4uoUIhDuxfQN3Z/666fjxha+DGagZ4I+v4ctw0ECOteFxUxzke3FEVoQqU
	V/v0JEFap4t+Qp654zI2uhUi4eqM4vs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf30.hostedemail.com: domain of 3AQt9agkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3AQt9agkbAGYWcdOEPPIVETTMH.KSSKPIYWIVGSRXIRX.GSQ@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786579714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=nAsYF9a9FJf+Yo3PGknHKkTdDoMZSB9c/ZuwIGLEBEI=;
	b=Nn5kdYlalAn5KeMV819kY+qzw7tdjGHeAgWqCGm+J3FdcnXcrFEt7g2WR0HOPaH/M4+SvS
	aQWWuKlKcQwpvVLU3WdiPVpHchL+8CvV1+d8vglCEfj9Uf8jPc6v5KqLP8JpLBHTu7xq29
	fBdsDdPhnmXjcxM3+DwO6pxbgAC9BGg=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6b0597e2448so1364516eaf.1
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:08:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786579713; x=1787184513;
        h=content-type:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nAsYF9a9FJf+Yo3PGknHKkTdDoMZSB9c/ZuwIGLEBEI=;
        b=PqjP9uc0olxQ84cxVppGri8qsKZacDzwKf3xRlp8SdToJU19Bv02QQRhe392T+LzNi
         TeELzucAn/yw7XUyRvc3VDhfQZOD+SjhDgT/L9GMolbKDgGtjN/ihgMNxO/hzC4oqfxB
         NWV7478dM5yvDrSStrT30+JG7/n5g8SNKgooSEDKnl1slH32hqsBH8DmGh99hBq/Mjdw
         oyxrixt+kfpLU6yre0M6KQCQMZpj9bbrK8KKOYpzlHTVbR4gEp4Ng5+7IoxULQEWYwdP
         jU2bF4tb5ibl+X0ehPfWCCsZyTYMoIFR4X6Qd5fGjqRudn3UZVQoVWI6Qc64i+Y8s4+H
         S4Jg==
X-Forwarded-Encrypted: i=1; AHgh+RoOhDFn3tsKAM8UJ+djB764G2y3/B81RU7RXenr5tDwDjuRohlMJOfU4MWcQBcp8a6NVZVT+1ghjA==@kvack.org
X-Gm-Message-State: AOJu0Yz8LYhDRF9JIfqlOkZNZP00rC6BEDdfsvUxYlswGYgy1/ufoQhQ
	oCXHLUn0l7wGJkMN4tLKg93JOgg+9FXdH/WwsqCxopkXtXOHkQnkERJPiiO0yumDjk0AXgGmzFp
	qPiZwM5fhZEQK2yI42pdudGdYa4cznq2E7+r8fuTAGMfJrF7UQlljczLe9u4=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:190f:b0:6aa:fe65:4cd1 with SMTP id
 006d021491bc7-6b0c468c7c5mr2130688eaf.36.1786579713322; Wed, 12 Aug 2026
 17:08:33 -0700 (PDT)
Date: Wed, 12 Aug 2026 17:08:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7d0b01.3668565d.e8814.0017.GAE@google.com>
Subject: [syzbot] [mm?] BUG: Bad page state in corrupted
From: syzbot <syzbot+237bbeed8dfe0699b7f5@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, hannes@cmpxchg.org, jackmanb@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	surenb@google.com, syzkaller-bugs@googlegroups.com, vbabka@kernel.org, 
	ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 32E1D80008
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: zn41a89nz1x9qgbebr1ihduhsbhu63fk
X-HE-Tag: 1786579714-847151
X-HE-Meta: U2FsdGVkX19jsWgbiZB6DxEXbMZVnvGCxXCsyy88glsRpgAHpxF8mHp8ak/TSnuJRf7Uirz99eLA9v5KbDk7Qol+EJjG6YPqgqcCUm2rpDbKUQnBclG/gdPFIWoXiSg7kPnkUH/3egli7sU58IDoL+SHHRc0Tzp2n8v2kWUOg6wg2T1f2WkF6RCBs6GsCuNmnYV0iCyqCbU8yh/lOMEBcI1DvSOcJ88zJaVpjhiSQAb7I4HydxNpmF2lzwLBrCJFZBSGUYD4px0zT1oQQIdqqDLeDz1isn+QvrSb24laFD+Si5e07FWq5TuXy/ebHywEStWA4oHqen8+YxOvDH1Fy4bth9USbyIKJO0aRhE31vMA1i6vcj18+1qf3SdHCO2rGFroY7gKYLYAjCPYDYo0OAcXRzZoCHmT+SdR0ih7ZJgJszKmjaVHTPqhmGuqSOBQEDTc2XmeB4X0gpX2BS6XAxUlziDAirSazRVqD+or68u+uvOfxswJVftz/EFjxmj3KDR9Ye/ervIAmRtq3Azb/lX4wQH9jBNi0QgjtX2X5EOe/TyveaZcbbZxrLyKdhEp/lV0gtSMamWyzmtf34Q724OFQLS8QPzJiC2TyY9g5OCm3TNnyWbAs9gW7ZMr7g201wbYueIS1NTAEyKUoLAR28HiYiq7ivgb8R+fxUrjBblNGTV++cwiJtcYWZGFbyMqIpsZgUkymwIKmcLOE0/KU7R/GS/7SQyvFgat2pZ6m99+0Q/ZGUg9nae79Q9KxcffJ+kf3PcX8hZ5SeO5Md/GrDG0XzV1G+K4oSeKDWw7HSjD25drKHAHBCak5UhZEZU2B8KvZU0Jsb6yakik/P5EQPAwt547zN8pcr/WM9pd93/XfHiPJR68NMFQuQmzokoyokhAWYCPt7CVy503DvEC/4C1SQYxAiarduXh0FxnSG2rfwaurVBNHLVSt5dan/xdD1gscmi2b3NDhEgBj9+
 snnlTlvE
 B8mFtmOv57MEdmbwy5JE5DLbBCJPFBIIIbiV4Z5JIcjsNu6Jd8XBoVdSiXXd0gkNI1lIs+ebzbLJf7EpLvItUGqGYBAoYG3f0a0VAHB5C8kCPH8CkoJN/ElOpCXsLRY++Xcb3SLLr4M+7Q9o6e89nQwU4axMXAiYgMz93EYJu4ZFDbC/Qd649k/tjjjUD4Azl9SFV+dr+R90XIZr5rZl2irfyvepHDerSiOiiKsOiw0LsQnjWWHOUl89UWKQNFTMqpGSgSlltyrCP8dMIJICmgqOy9W2bfiPsB5GX24Ybhd8NytAGz1/t0gKEUacP8G0kJURhyBfeixPBmw6SKe6VH6qHgLkbfNs8Qdwn5xR8Eq2L99jfb/VtUz8gUCdsRZVqxlezmi7dDqp2ARv2u3KpbpJ/20yV/xV8rjFNfCkhXI/ggc+4TBlYyr1fufRsKDdRbwVPhs2Fb/ufiXLk0DLQNAIxgO6mk8V5CFyWfD/F0F5VjHB3wXfjA4Ru8SW7x43I3vgnyWMxeVP9pjxmu2c9yseRPL72DWSTCwPpZVAkC2TWkKd7l9dbBl1cAdj/kwjr1CIWMjb1nu2KQ0EaCjW2yTPbI3q04pG4TNmQjlSsMorw6ocNkmlCNmJqz2OmxFcd/3nQL20sTJI9aGsUik8sE1QcIyCRIW1OTchCTyHGQZcV9c6DLzmUVO9BKYLDXUSAbK0zcFMeWhXGvU+Tpv4tvHkON2PFdLVnSvvJPLOTqPZ2BOyW8rfE6g/EMKj93t9ZYtnZ3YuJpvIpjDAM4/gkJU/3GLt3mFCcaraidTMT1YZ75Fey8kpIN34hJPL8Z5hrRyVUb5OETgJgw4g918S3ljI/8H9h8sG1u7AhF8ekbPaOS6O03tF/C8SErXiX2P/CugqdjDkBOADgbfeujprPo4rmfhaYelh+4IUAzQy+MwA8Zx+unHGExvV8EJ/ZS1DmEFZOxchCeO9lrafWojhqf9ce2lUv
 JzA0q0yR
 XR3/4RNXNWzVlWLd00Vw4+LVQl8/joySy4DvuySz94J8qvTBh3PmFxf+B8nvYs9dTXjkgc39qNFiqpgi7Suv6cDPwV+INT5gJ2dQCZHtd8zmed1hYGEyMfHg4Eeov+842TShUqYym4/UIP9Bghf+IghjkOn30eeSLWo+pI/8LxpbmHBIVGOyTxHmuPo8Wh6CExIK+rmwKlET6A/MoVxDMGgQ1tN18Leotbm+ZN/hBPsdSEW88dfdinUXr879BcgC0Amx2ad9axeFc7O3hhljPuNLs6aMOgJEvpGLDgPxXJtnjCkZzxqdNHSQcxIyPER/qLBJQDsBDTQQu/MLA+4lbC7BGXkqH3muvQjmvOzcgcSnmYawSEe0fvHpQu/9j4Dkt2JKTtCG6sqgyiqPY9DRTPJTsffic7GJZ++qD3z7nZqgDEmjlAQUpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    ba5cc80fd326 Merge branch 'for-next/core' into for-kernelci
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=14db42c6580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ccf4bea59f67007
dashboard link: https://syzkaller.appspot.com/bug?extid=237bbeed8dfe0699b7f5
compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1690bfb9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17fc0149580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/959ad5f4e730/disk-ba5cc80f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/0787d25f251e/vmlinux-ba5cc80f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/2e85c36fabac/Image-ba5cc80f.gz.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+237bbeed8dfe0699b7f5@syzkaller.appspotmail.com

BUG: Bad page state in process syz-executor210  pfn:112724
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000d2724480 pfn:0x112724
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 05ffc00000000000 dead000000000040 ffff0000c30e0000 0000000000000000
raw: ffff0000d2724480 3fffffffffffffff 00000000ffffffff 0000000000000000
page dumped because: page_pool leak
Modules linked in:
CPU: 1 UID: 0 PID: 4718 Comm: syz-executor210 Not tainted syzkaller #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/02/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 bad_page+0x194/0x1d0 mm/page_alloc.c:643
 free_page_is_bad mm/page_alloc.c:1078 [inline]
 __free_pages_prepare mm/page_alloc.c:1397 [inline]
 __free_frozen_pages+0xb68/0xbb8 mm/page_alloc.c:2950
 free_frozen_pages+0x14/0x20 mm/page_alloc.c:2988
 page_frag_free+0x18c/0x1e0 mm/page_frag_cache.c:169
 __xdp_return+0x200/0x738 net/core/xdp.c:448
 bpf_xdp_shrink_data+0x288/0x348 net/core/filter.c:4294
 bpf_xdp_frags_shrink_tail+0x1c0/0x424 net/core/filter.c:4318
 ____bpf_xdp_adjust_tail net/core/filter.c:4340 [inline]
 bpf_xdp_adjust_tail+0x198/0x1dc net/core/filter.c:4333
 bpf_prog_5d7dc57dfd7f985a+0x38/0x58
 bpf_dispatcher_xdp_func+0x30/0x44 net/core/filter.c:12027
 __bpf_prog_run include/linux/filter.h:724 [inline]
 bpf_prog_run_xdp include/net/xdp.h:696 [inline]
 bpf_prog_run_generic_xdp+0x4a4/0x11e0 net/core/dev.c:5498
 netif_receive_generic_xdp net/core/dev.c:5614 [inline]
 do_xdp_generic+0x97c/0x11e0 net/core/dev.c:5676
 tun_get_user+0x1e24/0x364c drivers/net/tun.c:1874
 tun_chr_write_iter+0xfc/0x168 drivers/net/tun.c:2001
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x51c/0xa0c fs/read_write.c:687
 ksys_write+0x12c/0x228 fs/read_write.c:739
 __do_sys_write fs/read_write.c:750 [inline]
 __se_sys_write fs/read_write.c:747 [inline]
 __arm64_sys_write+0x84/0x98 fs/read_write.c:747
 __invoke_syscall arch/arm64/kernel/syscall.c:35 [inline]
 invoke_syscall+0x98/0x244 arch/arm64/kernel/syscall.c:49
 el0_svc_common+0xec/0x23c arch/arm64/kernel/syscall.c:121
 do_el0_svc+0x4c/0x5c arch/arm64/kernel/syscall.c:140
 el0_svc+0x64/0x260 arch/arm64/kernel/entry-common.c:738
 el0t_64_sync_handler+0x48/0x148 arch/arm64/kernel/entry-common.c:757
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:590
BUG: Bad page state in process syz-executor210  pfn:113883
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff0000d3883c00 pfn:0x113883
flags: 0x5ffc00000000000(node=0|zone=2|lastcpupid=0x7ff)
raw: 05ffc00000000000 dead000000000040 ffff0000c30e0000 0000000000000000
raw: ffff0000d3883c00 0000000000000001 00000000ffffffff 0000000000000000
page dumped because: page_pool leak
Modules linked in:
CPU: 1 UID: 0 PID: 4718 Comm: syz-executor210 Tainted: G    B               syzkaller #0 PREEMPT 
Tainted: [B]=BAD_PAGE
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/02/2026
Call trace:
 show_stack+0x2c/0x3c arch/arm64/kernel/stacktrace.c:499 (C)
 __dump_stack+0x30/0x40 lib/dump_stack.c:94
 dump_stack_lvl+0xd8/0x12c lib/dump_stack.c:120
 dump_stack+0x1c/0x28 lib/dump_stack.c:129
 bad_page+0x194/0x1d0 mm/page_alloc.c:643


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

