Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CCDCCA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC60F6B0088; Mon, 12 Oct 2026 13:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77B86B0092; Mon, 12 Oct 2026 13:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8D216B0098; Mon, 12 Oct 2026 13:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2C66B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:59:15 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 23DE01412EC
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:59:15 +0000 (UTC)
X-FDA: 85314735870.21.BFC62CC
Received: from out203-205-221-202.mail.qq.com (out203-205-221-202.mail.qq.com [203.205.221.202])
	by imf23.hostedemail.com (Postfix) with ESMTP id B134A140004
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:59:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=S3hvgmwS;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf23.hostedemail.com: domain of yangguikun19@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=yangguikun19@qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791827953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vb9xf+bFbWYuM9Qbr8kFLGqDXPLZaUyz9lafyBs3s/8=;
	b=Uvpi0mNIEK6E6AB+ECThjqRDjYXWfNYviYbSJRYcSpabi7Iz4hP13GrzeaGv5hN+BQbxgO
	bDteEWYCG//ICypauUPMn5mmJrQRzAHdUl9OIwnt8hwiennXzeEsLq6i8oQiU9iTf7aOMY
	qE/JKVL5VkhkJQG0Eu3CiZoU1CUPSb4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=S3hvgmwS;
	dmarc=pass (policy=quarantine) header.from=qq.com;
	spf=pass (imf23.hostedemail.com: domain of yangguikun19@qq.com designates 203.205.221.202 as permitted sender) smtp.mailfrom=yangguikun19@qq.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791827953;
	b=hoSGTa6aA2Wa5LOgd/QDjprImWIyrlvt2B6KR85uOH5PWbyqIMLd5oLdV2ZkSzpy4ZR1yR
	Qw7Bksu2lFM9XhUf9FAVRBgSDF6SmlNK1UQQhEIBgSxnLtJndajwaypsUTO9AUZHkXNy3e
	KP2IWNIOPuWjRvKSX4s3+3sD334lIRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1791827948; bh=Vb9xf+bFbWYuM9Qbr8kFLGqDXPLZaUyz9lafyBs3s/8=;
	h=From:To:Cc:Subject:Date;
	b=S3hvgmwSlzyBYODdhorNGnkEISdKcJ+J+mqujPVnxOSI1Ky5RGlqbdSROvIn5QbQp
	 VMvwhqmtjWhwpe3pTw5g2/IgLypN2aRTFv+IYtVATVScGGrD9NZQ2+s6uGwg5WevoG
	 gWTsvY9sKfR7h43XjzD9/GAYRio/RLj1mOcynbj0=
Received: from [172.18.4.77] ([111.31.227.58])
	by newxmesmtplogicsvrszb51-0.qq.com (NewEsmtp) with SMTP
	id EC585A57; Tue, 13 Oct 2026 01:59:05 +0800
X-QQ-mid: xmsmtpt1791827945t9hdi589f
Message-ID: <tencent_295112A919DFDA23354E71A63251A93E6C08@qq.com>
X-QQ-XMAILINFO: NCmjBvJFq6XNqj4DblHVVDXoac4Uxc/x9u8Dz0+CXN/DvRQeClrRfP3ye5+GmM
	 gCs22Tji6+MhaBqhhp80Iwk0yS+b0yqPpwYda+q+X9IykS8Ev6Rsy0mdlB8bS1d/froD+TKNGu9+
	 P3emcxK1EKkI3SAV/3lKG75aLqItOfLNY1SBOMb2fYCA1bhJ19GC0Wj0FAaFmlw7ldJGz+z0Yglv
	 1K8XshRInS6D4gXn4n5+xzziyNlAMPbCViM+A6KMQWMhV0Z1HzeD8tRw46SJYf9TYW+ZHBk2QpFP
	 5+Vg0QvTjZlFFwKkZ5p0ekagxWfPWFr1JuRAdN5dJChata4J2kxAQaeayBQBqGDE5ySSgMzRstjB
	 HhDRvduu2ln9KEh5awIjY9tvyEGyz7pTRsbjQs1NvA75qSXG0kHjy4FouzT5UEaaOnnkxno9qaRC
	 GxqCkjVEC8zK35xLMFCqQ6SVTrcpA9lySuJkwnBHxmx1C1DzUE90/5r2yR9SpYDmki1Fh3FY60Zg
	 D9Y8c3xQh/O9ud4xwpF7ipjufV4PKWczF1tcxZQOXfNNlCtsQiZNoIOSi9oeTCk0uPq8jZ+P+mZs
	 qzAMA6qqCwjY6XzfIttdtkVpm0UJBl4DyIUS8veDSR5iFqo/hsLJQ3awJfxhLev7BjnV9ijM4Emg
	 PytF7uFFg2wcdDxI4bdbz5yEeXAtypDlbiwswdn6edu276v4WRQ1lcpRLInxstVvYH+U+p5RbkkR
	 fOcM0m4JaZBT1K5flddtPIoyMEADRNiytZCcJbm1Ut7/vzqWkxni9/OJROqOxD6VFQkRaG0S0BIo
	 DAvZsOdgEz57LpVLlySg6OYprzR98uNeT2TggjviVYdrGxxIlUE/2O0h/egwz3QnrTfHzpZgzQVg
	 PFkdIrcgo6NXO46x35mExzrkmh4GQd1IapE121WibsLZpTdjYCmzTLTQKeUhrnGl0GMXWU5KpAa0
	 8sJ7Npichug0LGAlOnR3N7bun+/EZfKVM1kIE+FRbiS6L6IcYhkV75kI+JP2IVbdBZeP5vyoNqpX
	 eEOtRSmWv41+FlZi09IMrkDaOVx+OLxqah9+Yk/rkLgVQ81DllW6RVTOw62jo=
X-QQ-XMRINFO: NyFYKkN4Ny6FuXrnB5Ye7Aabb3ujjtK+gg==
From: 1sh1ro <yangguikun19@qq.com>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Thomas Gleixner <tglx@kernel.org>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Alexander Potapenko <glider@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [BUG] KASAN: wild-memory-access in handle_edge_irq while a CPU is in identify_cpu() during early boot
Date: Tue, 13 Oct 2026 01:59:04 +0800
X-OQ-MSGID: <20261013015904.44144-kasan-early-boot@yangguikun19.qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Stat-Signature: max9pxefbutttjx9w7srx3styhub787x
X-Rspam-User: 
X-Rspamd-Queue-Id: B134A140004
X-Rspamd-Server: rspam08
X-HE-Tag: 1791827951-972500
X-HE-Meta: U2FsdGVkX1+FcGaRS1DEiMFvMeoi1XpuyvmqMbPeLZGUYUVs/TLes2sKhqfx4hLuqjBYnz+/nBerugLAnS5tbOGLBtwij9brq7hP+NLwNzsLWptO46LIpq1OLbSOy1UG+l7UWS3fQ7bZwVgMymSkUMIKhFNT6BBgymArIEwBbHhw5Ayi6/o09uXj9Fz2uUtb7Bqp6d/aibvnB1LhzHZAhz6kTt8sVV0JtjNltU1tIEuNceS8Gu6dKMTryfEKgIlUJeBjJ00h3/MRLjxBtBL4KXnNw94pWdJcYUgVQ+mR6z0iYL8NpclDRSzQQF/XNfrlu9nN2pz3IeZO3j/9TF5/XRsEuwjo3Bpha0FlEYTQ62lp0o9EnVXVgo/yGuZT8HMt5rLMtcAaJNrKik9kIOijP+mc0S0KhvS0FH+pcZZydMNKXstoZfQD+7mX7IcneW0C6v7huio2U+YCMNVU2kZgnsSD0ZjxBcVxx6Fblvj1PdA8u7cpxKB2Wdc+ffTt2w4pwyaTiuOSqykOR4/Hmgz5j6SagLsni/EGOIwl1VDSvwqpKUIOEkv5H9c/UIPG0ZSMIUt8TiPDTvwas7/uWXNWoA7K90PXhmV4UOFSecBbfUrF9Gyg8dVyg2cuefJOSPAlabBqhej6nfvjXKBp7QR57wkpHT9Yc8MTCIbFlfsnTdS6nGF0IYnDuWRuBAK3Z6HwMZBQU7nNO3txidkDRgt4OLsBy//wjeRyviFJjTlnpf7VbcjjMQzZJGmwRAaBm1uuF4ru+Eyyr6TZv5vwVsQ/oSWQZfyNFCZYTLscsEK9rZbtzKS4F4XTzItlWv4Hww5LeGUy5ZHvUgX0aLGZD/d/TGyfQkI8BUa893H1ch8XQJzn7i3itmR1L7To9dwCTU5DfbW9n/nPA26mMxiVS/pOf/eC3cVH9WedTOqJlBW11b4uVjxOjibxorkG4qij+j2T0yT0j5lym1Wpgqzsrje
 kui6BQEu
 45A7S309mRJSm7cw1cv3HnXF2GJjhiwSNrHAxB5OpvahusZtdzHqzahgGtg7ugXBDSGOS35JOC9yMl/4q1GEaaJIxJvbah9qMzTyqdOUlxsSpBmxWCDGOiOe7B7vEmNwEGr23cJ5o86kprwyufiwcYrNtgMzagNV8iZMQpaGQind+sNYzXHv21+ngKlsL5A9K27Zq3lZO86te2+L+gomWh7shSU/fgWcKt56Bbd1saEDRlCTrgp9MPPy+QR9TN3kmMY4744IT2h918wDXW8utgWEcCqEpt6Gpplgbj6p35X6fgNnNB7Zkw0zhg/KkJCJRpiOn04lwcVgMJz5aJNT5qT2fNE9kNm13zuCWwUC2wUr1mm6XCYY2hsbTxylXyGxjliZTTP999iU3R7UNnN5zRzyM3FLNJXpQ2fRb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrey, Thomas,

fuzzing with syzkaller on KASAN kernels I hit a wild-memory-access report that
fires at early boot, while a CPU is running identify_cpu() and an edge IRQ
arrives.  With panic_on_warn=1 (the syzkaller/syzbot default) this panics the
booting kernel, i.e. it makes fuzzing VMs fail to start.  I have two
occurrences on two different kernels, and the address forensics suggest this
may be a KASAN-side issue rather than memory corruption -- I would appreciate
your opinion on which it is.

Occurrence 1 -- 7.2.0-rc5

BUG: KASAN: wild-memory-access in do_raw_spin_lock+0x11c/0x270
Write of size 4 at addr ff110000158860a8 by task swapper/0/0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc5 #1 PREEMPT(full)
Call Trace:
 <IRQ>
 kasan_check_range+0x39/0x1c0
 do_raw_spin_lock+0x11c/0x270
 handle_edge_irq+0x2e/0x990
 __common_interrupt+0xd1/0x2f0
 common_interrupt+0xf0/0x110
 </IRQ>
 <TASK>
 asm_common_interrupt+0x26/0x40
RIP: 0010:get_cpu_cap+0x12f/0xc10
 identify_cpu+0x2f9/0x1e30 common.c:-1
 arch_cpu_finalize_init+0x58/0x3b0
 start_kernel+0x373/0x4d0
 x86_64_start_reservations+0x18/0x30
 </TASK>

Occurrence 2 -- 7.3.0-rc5 (same bug, cpu_detect() is the renamed get_cpu_cap())

BUG: KASAN: wild-memory-access in _raw_spin_lock+0x71/0xe0
Write of size 4 at addr ff110000010ca8a8 by task swapper/0/0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.3.0-rc5 #2 PREEMPT(lazy)
Call Trace:
 <IRQ>
 kasan_check_range+0x39/0x1c0
 _raw_spin_lock+0x71/0xe0
 handle_edge_irq+0x2e/0x980
 __common_interrupt+0x7c/0x190
 common_interrupt+0xb8/0xd0
 </IRQ>
 <TASK>
 asm_common_interrupt+0x26/0x40
RIP: 0010:cpu_detect+0x20a/0x470
 identify_cpu+0x2df/0x1750 common.c:-1
 arch_cpu_finalize_init+0x25/0x3c0
 start_kernel+0x39c/0x490
 </TASK>

Why I suspect the shadow rather than memory corruption (7.2-rc5 case)

* page_offset_base is ff11000000000000 (5-level paging), so the address is
  physical 0x158860a8 = 360 MB.  /proc/iomem shows System RAM there, and it is
  immediately past the kernel image:

      01000000-0b33fec7 : Kernel code
      0b400000-0dafbfff : Kernel rodata
      0dc00000-1036a4ff : Kernel data
      1352a000-15577fff : Kernel bss
      0x158860a8        <- just past the image, early-boot allocation area

  /proc/kpageflags for that PFN (0x15886) reports SLAB, so it is a legitimate
  early slab page (most likely the irq_desc itself).
* The report contains no "The buggy address belongs to the object at ..." /
  "belongs to the cache ..." section -- KASAN could not resolve the address to
  any object, which is what the shadow looks like when it is not in a valid
  state for that region (early boot / embedded percpu / init shadow).
* It fires exactly while a CPU is in identify_cpu(), i.e. the earliest boot
  phase, and it is timing dependent: it is rare (0 hits in 30+30 clean boots
  under light load; the fuzzer saw it about 3 times in two weeks, i.e. under
  load), which points at a race rather than a deterministic bad pointer.

Environment

* syzkaller-style x86-64 kernels, KASAN_GENERIC + KASAN_INLINE (the 7.2 build
  also has KASAN_VMALLOC + DEBUG_VM; the 7.3 build has neither but does have
  RANDOMIZE_MEMORY), QEMU/KVM, 1-2 vCPUs, syzkaller's cmdline
  (numa=fake=2, page_owner=on, rcupdate.rcu_expedited=1, ...).

Reproducing

Boot the KASAN kernel with panic_on_warn=1 (or 0, and watch dmesg) with 1
vCPU, syzkaller-style cmdline, and repeat: it shows up every few tens of
boots, more often when the host is loaded.

Question

Is this a known limitation of KASAN for that early-boot region (shadow not yet
valid / embedded percpu / init memory), i.e. a false positive, or is the lock
access genuinely wild?  If it is a false positive, is there a supported way to
have early-boot code not trip it (we currently work around it by booting the
fuzzing VMs with panic_on_warn=0, which loses real warnings)?  Any pointer to
how to dump the shadow state for that address would also help me narrow it
down.

Thanks,
1sh1ro


