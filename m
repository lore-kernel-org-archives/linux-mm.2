Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFB59C43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 21:27:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 719826B0005; Fri, 26 Jun 2026 17:27:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0006B008A; Fri, 26 Jun 2026 17:27:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608CC6B0092; Fri, 26 Jun 2026 17:27:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37D286B0005
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 17:27:14 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8E49B1C6639
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:27:13 +0000 (UTC)
X-FDA: 84923349546.24.B40F517
Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id DA9BD120007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 21:27:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lAVLLKfN;
	spf=pass (imf29.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782509231;
	b=Om4L499WzwIRkWfGS0QifHKdkjNgvfPbtjrtIeG/tsoUpFydPPGvF6nRR58v6ANbtTNPWE
	pxuiaVE1ORB66GHlMuThR+/b1V3Aqf5pRtVLfK8hKrqdWRs7bHJ214O5d3X+2TsPtHP3Bt
	OhqBySIq4QhvpS9f3Hr67RUdSMi+VmQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782509231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5ANKtTi3WQ+Pt+De4BIcKbzPHYx1XgOjTrTXFWr/ENc=;
	b=VaepbHGa0prmvX3xTJ8q8dzfq8oDl79+u2giEmOjUiil26s7brYe/qUqyicZoyz3CquV0z
	4arq+13u3pQM/c8/NkVRY7SW/I5BptJgdAXL+UfdXHmlBtWdAIWNanmKKnVfnLo4zihvAI
	6jq3iOOmLR8pH5kLWMWhvJPrTOgws7c=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=lAVLLKfN;
	spf=pass (imf29.hostedemail.com: domain of sanan.hasanou@gmail.com designates 209.85.221.170 as permitted sender) smtp.mailfrom=sanan.hasanou@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5ab02fb66easo40622e0c.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782509231; x=1783114031; darn=kvack.org;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5ANKtTi3WQ+Pt+De4BIcKbzPHYx1XgOjTrTXFWr/ENc=;
        b=lAVLLKfNM9Jw8i8Rsfkk0raNVD5H78RGSVFsoHXXru7XRPXS9MHc5P0sx/k/in2jUt
         YNm2mRn3H0Kxs4F+NPiD2BxgFvGPnag2W02qazD1uB/1wPVa/iau0Hl+FyObzqpe5rNq
         vemK/i8kHM/egaWcENDpPH7KzG6Dsr6IQMw/b/ya7I7c+QWiVnAMClqxZQ9K3ZJfEQ+V
         hjlQktGnbJLIrB/blANbW2eU0ftln0Pt5OOcQmMDe5FAgXsDsW3FJXx1IObcs5CSO881
         AsAYP+c2r8uiT/FkRRwST4mAmp2M3X9mwyZQgpX2EdmY6ICcz02tisqY2zpKHphoQ+f8
         kt9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782509231; x=1783114031;
        h=from:mime-version:content-transfer-encoding:content-type:cc:to
         :subject:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=5ANKtTi3WQ+Pt+De4BIcKbzPHYx1XgOjTrTXFWr/ENc=;
        b=So+Tv23vTIeh2MwmvSr+ddDcL0Gjs3rV8v5jB/xBcxYnzMx/wf8FGU2HphdGTjje25
         HlBoeb+eb4tw141+tq7JYv1kONbk98P3HvzrIm47IBUYCoLcLyI374zRYKWCT9mJThlb
         qXMK4wZ3WzSP24Foor/9c5dtxlkI5ih3QDyB0LjrAMsBuyy0PdcGTYBZm2FKL2M4Sdm9
         8e6Q/VteYr3IU6yYythLMUxBRAVEYcKAHrUDJY6RWaAQIAagR3enODNBNzAFwQb/K+Hb
         ZxZJSIDqKjmdzVXpyDMQmVREiKO2y0kpD1mdHL3lb+Gx76erqZJZ7P89FPDIPU167A3/
         7cHQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqkf06Bny9eDGg378fQqfWQeM5N3LY+y8xlj+h5lLvjqhqU8R8tEZUoyCBkpyDoTylYmKuPkVBhMA==@kvack.org
X-Gm-Message-State: AOJu0Ywu9OeyV452Fb1kqUGeI6qkx8sGLvFV5AFjYqgP+ZjIlRaaF/pI
	dmHm9psl4kde1SRHKU55qR50273Eg2oRcr3Mgn78sIjJ3CL4AuEO5Ux0
X-Gm-Gg: AfdE7cnpJFH+bP0+u2XO7TJ16p+H2jwoAndGNWBya4TOIvg9d8bpBTGZmTZZePptj7Q
	XVPuWngii5QAgmJpeTnAB68dhmIXfNl7aBHsevL0MV0DWVwonj/wTg84oMziSyyTufROwjR6+0w
	KRWXPcpbqiQ23SQeMqwuvjVIGEi2aGF5CoFVtthXGt4e2DUDHeJyLPl+p4kSqcG3PP/xNTFWR6H
	gGUhySA9NYoYxXibmj4joKoMBtK0hg8Ohl042uhtNLoOZdQFH0nsB5ZaEmojF1nqtpoJo/y1Viu
	hz5rZD3iLBnpy5somxzdCtPYJOuGZzswA/Hy8BlcYeWtYDEtjcYn6OwNDFSuCT3OWllr6SiGXkK
	bZ6t9GrQBgesm8G084gi9iSi5PtJMlo6ZjJYRxWtdr+wybsWUvZT0qc5vdg/UNzEv89NEyH/qD4
	5sHrV8RqJLfbabArSVWb81qxF9kP1h9eCc61Y8Qxe0PhxttxEY791NOCR3sxTJT8GhFFnNLMa/6
	q4t902R11hmK5z+8wFap24=
X-Received: by 2002:ac5:c7cd:0:b0:56f:8cf9:33c8 with SMTP id 71dfb90a1353d-5bd69d7efbcmr1211421e0c.2.1782509230862;
        Fri, 26 Jun 2026 14:27:10 -0700 (PDT)
Received: from [192.168.10.115] ([132.170.207.48])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5bd790c4949sm1844279e0c.15.2026.06.26.14.27.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 14:27:09 -0700 (PDT)
Message-ID: <6a3eeead.7fb353d3.354599.b0b0@mx.google.com>
Date: Fri, 26 Jun 2026 14:27:09 -0700 (PDT)
Subject: WARNING in usb_free_urb
To: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: syzkaller@googlegroups.com, contact@pgazz.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: sanan.hasanou@gmail.com
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DA9BD120007
X-Stat-Signature: aysk9nftgctxuiwjbdnernhdhnjposq9
X-HE-Tag: 1782509231-231455
X-HE-Meta: U2FsdGVkX1/GVKS0LpzyoM3O1wQzCLlvIkZAX9oJRdGobQJk/j2NFEtYh2L4jVf4pXhh0kDS1UUTQ+c4FsJD9IhkleDwJIQCs+BHUwGtp4SH7BXZbJcWqFWATYRlgHqt4NeVlEfsSN0lxYShEJZVfwYTQNJ7pGIScZgPDWuafN9FcpCCjvluTrNXYZXzyAcLUbgDgg9m0VEsfiK1WkEguXRJslW7m1YcKPpyOhcwl5ArfNRKAMutb9xstByNAeSLuU7ChF8f3Epa6TGkfPSMJpl/DMniKz49JfpBKFWyVvZZJmx1a3sipaEllDzM+awI6Ms1MDxFzNm715ut6wWXHqQhREu3bJaoVinIgHH/hyrGjqKZtDGSx6SKvtg5g7yBii49LF1kPUqrv9UXh+/XsKLHCbOk6qpooePyMw94w/Ou/PDz2pmEMCoZvLLJyAjB/MewXFB1l+NpZNrXjw3Xnfuqa6VFQAxFIlBCHL3DlNYBE4cdvTiG3dJiGptyltgCANERY66hc2TlaPWV7An15YzxrYCIDiPlaQmF9FYoqQcjiLepD20x2wwSJf57LWeYx09HwrR8hS0rsgDP7UlDlb5+pRoCd4RmTJrOaNrkbe0Xcvpph7tu0J42o2sn8QxpllspTQdVjcJ6Kid56vUyjiqsJ7E5cN6NIE7Nz21p4sF8mGLPkYAKwNOu2XC3/Sqr2CMa0ZEml2odTKvUPc44ofDvB5Dq3143n16o9uW3T+habzTCIVmivSCODUktnAqKxL2BvM4MowWrNcXE2JqE9x6mrL1Xp0n3c7KUIW9WVLEN4hsjdxKbcYpfmTYBiX73rSSugdPpwKd1295eFLOs6jJxrwhh5MFaU+vNqOG77chCTmHLABGtQjvzW6VskkpMk7oX5Vl1QI7HwkdT4zJ+l8csPYx2xFXY8A5yc1+ojPr26xAmwbSqV3EZIw2HImzoPK0nhCjCQFewPq0Bdp5
 Zc66vU7T
 9dvM8YzOW9pMkQNJlzPxlDHEYLAc1LdrjyYU8/kIUif5SNLLfx7uLIPCDxZUINkC2p5G9sfb0nNUHIi2wcMKP+DSLo6VxL5Xguw7klhP7Rd3gniRaPTRievkfM0AmliTfWjXHyK829YHNJKpWScHiKbUCaGpxV+twwE0GhgqhS/xP2UDpYMyGeCBFL7qPAhCtJNW1eg+WmNK14qTmDkMDL7oG2chmoINP7zkE+5O8gF58G1GlixT+1up8unpBSoLeTEgmkCA2Y0kes8oaIbwVrob+t1JqZITQtV/b9N8IQoRdmGZlol1zGjVgteddFBiV2e28jUxSy3wRJ1Y2bCTmIYXx4kF1TRgKy3b0fFQ/taOf9RyNQeTprctBDKfJHIYQp+SqqQa/0EuwHPwUDK8hQAjw2/DEQ4lyJnkX8s1cRfr3YJGs4GXWPiRw4jOIfI93zLiTc2bVa26IFzyNkjBw1/HA9Au4CWYy/8Pwe6z/koO6wOyqB6DCHS9ODw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Good day, dear maintainers,

We found a bug using a modified version of syzkaller.

Kernel Branch: 7.0-rc1
Kernel Config: <https://drive.google.com/open?id=1zJHAs5GUroGFBkxAlzfDaWAd_NVPZTfJ>
Unfortunately, we don't have any reproducer for this bug yet.
Thank you!

Best regards,
Sanan Hasanov

179683 pages reserved
0 pages cma reserved
Memory cgroup min protection 0kB -- low protection 0kB
------------[ cut here ]------------
!PageLargeKmalloc(page)
WARNING: mm/slub.c:6352 at free_large_kmalloc+0xb3/0x160 mm/slub.c:6352, CPU#1: kworker/1:4/12317
Modules linked in:
CPU: 1 UID: 0 PID: 12317 Comm: kworker/1:4 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events request_module_async
RIP: 0010:free_large_kmalloc+0xb3/0x160 mm/slub.c:6352
Code: 25 00 00 00 ff 3d 00 00 00 f8 0f 85 a6 00 00 00 c7 43 30 ff ff ff ff 48 89 df 44 89 f6 e8 45 d9 fc ff 5b 41 5e 41 5f 5d c3 90 <0f> 0b 90 48 89 df 48 c7 c6 b7 4c 72 8d e8 cb e8 08 ff eb e4 90 0f
RSP: 0018:ffffc900028e76f8 EFLAGS: 00010287
RAX: 00000000f0000000 RBX: ffffea00019a5c00 RCX: ffff888067550001
RDX: 0000000000000000 RSI: ffff888066970000 RDI: ffffea00019a5c00
RBP: ffffc900028e7710 R08: ffff888049c40603 R09: 1ffff110093880c0
R10: dffffc0000000000 R11: ffffed10093880c1 R12: ffff888066970000
R13: ffffffff870bc0f1 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ef136000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fba7e4bf008 CR3: 000000005776b000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 kfree+0xae/0x630 mm/slub.c:6437
 urb_destroy drivers/usb/core/urb.c:25 [inline]
 kref_put include/linux/kref.h:65 [inline]
 usb_free_urb+0xd1/0x120 drivers/usb/core/urb.c:96
 em28xx_uninit_usb_xfer+0x165/0x310 drivers/media/usb/em28xx/em28xx-core.c:833
 em28xx_alloc_urbs+0xf2a/0x1130 drivers/media/usb/em28xx/em28xx-core.c:-1
 em28xx_dvb_init+0x2b0/0x4a20 drivers/media/usb/em28xx/em28xx-dvb.c:-1
 em28xx_init_extension+0x121/0x1d0 drivers/media/usb/em28xx/em28xx-core.c:1117
 request_module_async+0x5e/0x80 drivers/media/usb/em28xx/em28xx-cards.c:3457
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xae1/0x1800 kernel/workqueue.c:3358
 worker_thread+0xa0f/0xf70 kernel/workqueue.c:3439
 kthread+0x37d/0x470 kernel/kthread.c:467
 ret_from_fork+0x507/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:245
 </TASK>

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

Modules linked in:
CPU: 1 UID: 0 PID: 12317 Comm: kworker/1:4 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events request_module_async
RIP: 0010:free_large_kmalloc+0xb3/0x160
Code: 25 00 00 00 ff 3d 00 00 00 f8 0f 85 a6 00 00 00 c7 43 30 ff ff ff ff 48 89 df 44 89 f6 e8 45 d9 fc ff 5b 41 5e 41 5f 5d c3 90 <0f> 0b 90 48 89 df 48 c7 c6 b7 4c 72 8d e8 cb e8 08 ff eb e4 90 0f
RSP: 0018:ffffc900028e76f8 EFLAGS: 00010287
RAX: 00000000f0000000 RBX: ffffea00019a5c00 RCX: ffff888067550001
RDX: 0000000000000000 RSI: ffff888066970000 RDI: ffffea00019a5c00
RBP: ffffc900028e7710 R08: ffff888049c40603 R09: 1ffff110093880c0
R10: dffffc0000000000 R11: ffffed10093880c1 R12: ffff888066970000
R13: ffffffff870bc0f1 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ef136000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fba7e4bf008 CR3: 000000005776b000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 kfree+0xae/0x630
 usb_free_urb+0xd1/0x120
 em28xx_uninit_usb_xfer+0x165/0x310
 em28xx_alloc_urbs+0xf2a/0x1130
 em28xx_dvb_init+0x2b0/0x4a20
 em28xx_init_extension+0x121/0x1d0
 request_module_async+0x5e/0x80
 process_scheduled_works+0xae1/0x1800
 worker_thread+0xa0f/0xf70
 kthread+0x37d/0x470
 ret_from_fork+0x507/0xb90
 ret_from_fork_asm+0x11/0x20
 </TASK>
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 1 UID: 0 PID: 12317 Comm: kworker/1:4 Tainted: G             L      7.0.0-rc1 #1 PREEMPT(full) 
Tainted: [L]=SOFTLOCKUP
Hardware name: QEMU Ubuntu 24.04 PC v2 (i440FX + PIIX, arch_caps fix, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events request_module_async
Call Trace:
 <TASK>
 __dump_stack+0x21/0x30
 dump_stack_lvl+0x2b/0x150
 dump_stack+0x19/0x20
 vpanic+0x53e/0xa20
 panic+0xb9/0xc0
 __warn+0x320/0x500
 __report_bug+0x28d/0x500
 report_bug+0x175/0x220
 handle_bug+0x9c/0x200
 exc_invalid_op+0x1f/0x50
 asm_exc_invalid_op+0x1f/0x30
RIP: 0010:free_large_kmalloc+0xb3/0x160
Code: 25 00 00 00 ff 3d 00 00 00 f8 0f 85 a6 00 00 00 c7 43 30 ff ff ff ff 48 89 df 44 89 f6 e8 45 d9 fc ff 5b 41 5e 41 5f 5d c3 90 <0f> 0b 90 48 89 df 48 c7 c6 b7 4c 72 8d e8 cb e8 08 ff eb e4 90 0f
RSP: 0018:ffffc900028e76f8 EFLAGS: 00010287
RAX: 00000000f0000000 RBX: ffffea00019a5c00 RCX: ffff888067550001
RDX: 0000000000000000 RSI: ffff888066970000 RDI: ffffea00019a5c00
RBP: ffffc900028e7710 R08: ffff888049c40603 R09: 1ffff110093880c0
R10: dffffc0000000000 R11: ffffed10093880c1 R12: ffff888066970000
R13: ffffffff870bc0f1 R14: 0000000000000000 R15: dffffc0000000000
 kfree+0xae/0x630
 usb_free_urb+0xd1/0x120
 em28xx_uninit_usb_xfer+0x165/0x310
 em28xx_alloc_urbs+0xf2a/0x1130
 em28xx_dvb_init+0x2b0/0x4a20
 em28xx_init_extension+0x121/0x1d0
 request_module_async+0x5e/0x80
 process_scheduled_works+0xae1/0x1800
 worker_thread+0xa0f/0xf70
 kthread+0x37d/0x470
 ret_from_fork+0x507/0xb90
 ret_from_fork_asm+0x11/0x20
 </TASK>
Kernel Offset: disabled
Rebooting in 86400 seconds..

<<<<<<<<<<<<<<< tail report >>>>>>>>>>>>>>>

