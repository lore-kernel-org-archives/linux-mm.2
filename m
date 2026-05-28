Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E42ECD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 18:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 774036B0088; Thu, 28 May 2026 14:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7252D6B008A; Thu, 28 May 2026 14:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613996B008C; Thu, 28 May 2026 14:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6AC6B0088
	for <linux-mm@kvack.org>; Thu, 28 May 2026 14:25:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 068591407AA
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:25:53 +0000 (UTC)
X-FDA: 84817657386.09.E165E76
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf19.hostedemail.com (Postfix) with ESMTP id E50991A0003
	for <linux-mm@kvack.org>; Thu, 28 May 2026 18:25:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=eoofDdSj;
	spf=pass (imf19.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.128.193 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779992751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6+tSeTpyx3CitJbaFuLZe+yBD6WSRrsGEXL8VTDfKLQ=;
	b=BkCqw2e/QeyapybQ9b7hAJY88tw1B23bZGEn7FoXDRpprxR+sSUuD5/3xIKbCXUizVYEAS
	Pc5C9/FdK66XDegcNhmIxNp3VR6N65X1lTWQaIOZMmz5IO310d4wklzdwivTT+AvONi/Sk
	f8KXt6fOW4U7eLm0RxT1iuVArsJwAbU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=berkeley.edu header.s=google header.b=eoofDdSj;
	spf=pass (imf19.hostedemail.com: domain of farhad.alemi@berkeley.edu designates 209.85.128.193 as permitted sender) smtp.mailfrom=farhad.alemi@berkeley.edu;
	dmarc=pass (policy=reject) header.from=berkeley.edu;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779992751; a=rsa-sha256;
	cv=pass;
	b=KggfuLNzUaSDfuvB93fMZQEPRnkw8a4MlcKdz7/TkqCOiAl8t+IRBZ/ejePC/2yXYaq6zA
	B4Dthq5Vl/GvwArlImPIBy2cdF96fSNZETGJuppstuofrXBpuae4nfdzqd9FhnuDZEi4fA
	0QQ3UW0ooa2HUy0JWQ8uC64F2stpVlI=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7dc2b658544so11526727b3.2
        for <linux-mm@kvack.org>; Thu, 28 May 2026 11:25:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779992750; cv=none;
        d=google.com; s=arc-20240605;
        b=irF0HkGE4b8EueambXjhN6rZ68sQUq/L4mNG1QgIMscjN6PitocFDHreQIa8/i56UE
         yd7WALsPr1+UClaVTP0TD7JmB0v9MeKE6e+rbv2Yx46H+8FetjEzQsu5VVSz3CAo/JKr
         PDZNkX5WfFiMbiR36RQg2P6lz03pgqur+RHatVSiRIJEdIgndom3HtxSgJnQHYeBC1cT
         cKiRi1klm4lOpkXoe3oR7o//QGoHiOAszRo70M7ezPh4wMqss/YvP3ffPNKoFtvmA6pe
         d/XoZ81P0HeeB/60sKWLnpqwsX8VATDQf/i71SYUUh4fpsIoPKFVH0+KbyAPgirdfONq
         8MtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=6+tSeTpyx3CitJbaFuLZe+yBD6WSRrsGEXL8VTDfKLQ=;
        fh=ciiugx0e4Y8purRpTKChx03KLgdPApMxdMhUolxjzMM=;
        b=LIaqE3jcNPDv0FHKKTzf6Tk+f2ire8ayCrZSiPAAOtDMzuADcXSPuLKrqhVDiWKid5
         Jg6/qjqPHWU7CSJ4MsnlKEemWn7mJCPYwXVs9JqBO55Q5QZHJXfxZfZO4IQmhxnHSwZH
         zqN9YlYK1/f8K2ZjdxcjnzXQVouP/xuUsKcMOIShgOFLjfyl2ekfbT+8s0pnBoRRdBjV
         2mfS20HMHh5o+cC77TMCxhqC1ZAL40fQvUTvzff+HM3SNNcO8qWwRXkPuGNgGB01cHlV
         KTLGdb6cz/CSvCGJRXYHM3eVXSC3Z1HAsasNjijSfkVhojC81GEUsq7+PN6stRPjWD2y
         hiwQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1779992750; x=1780597550; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6+tSeTpyx3CitJbaFuLZe+yBD6WSRrsGEXL8VTDfKLQ=;
        b=eoofDdSjO5Zcb30TSpeiMG2xYFLkBrinHiTRZsF6ANCcYwJUjMwCZH1WlOz/PduzDy
         T3pZkDpHUc7H/inxnxJaVFj032oN+ZpZVn35IJb0Ka9pF7u+Lf18m9yttftXZuhFQBsI
         KmvtcBWG0esamFSAzvCP2mgZfFKJetH7E3KuIm+aVJS/8LxxFmI8wyLoc4w8hG6VR5zL
         201NejxMPrFEF/8ylTCae2jD2vdrCkSXUKb0P6ImlqFOBD9jvsQmP4ArNR0g0bJ6JExe
         s6KHWdC6zy/CH1pAggAUUJTy+qpw+Cl1b2QeR6JCfsZf9n6oGP94ZNXRCBUxCr0jFrXQ
         63fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779992750; x=1780597550;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+tSeTpyx3CitJbaFuLZe+yBD6WSRrsGEXL8VTDfKLQ=;
        b=fOkP5t1Wld1r8aFn6G4mHxOuiA5xZ54qRMk2c2w0h75/ZkYf5jugX7p76TBaRZMZ1G
         gO4U6xOvKmE/J8T8hYip5gx/6Rn4eb3H9ndJpJ3DSkO5rEOX40G3HvQwfZw3CyzSGA66
         zCj/nyonMWAk8H9OHfhoapRywnyN/UurrOIG3i6DFHGOyhocGXbrAJpKVP6W9TxhzaP9
         lsCe1n2LkrKrncU7mKdQA0gIudP89crZzJpABE9IXvRCYCxUXxMzYPbs5RB/SLs9KUhM
         cZHQehyli/Yv1lLWGcqZ/zem51L+fhpVkbmEVJaI8WeKlN/RB5jhKTNFCz0KB2EykcCQ
         lBrA==
X-Forwarded-Encrypted: i=1; AFNElJ/kDWk/mIwR1v72xPXUDLXT57z4ah+4GYZMqXh5dMLq2jdmoskvnuzDh0Wtp798tj3V8LeEFuNT3g==@kvack.org
X-Gm-Message-State: AOJu0YyZgVdZV6rfCC8r8rI7pMvvYF6tD+QbILM9NTAgNeDSNB2N2pMu
	UIhPtEH3tKZnz/96TKWItla7ervPMGj8js5XihvO4sre2T6efk/GBhhRP4czq6JFtQXHk7shs4/
	+vqpPFEPjIpOu/OrQavIeuAvpgCsxf1nvfTIQqIzz
X-Gm-Gg: Acq92OHeUeefRGXsGPtYUBkHuiGU/OklHbPEhv9vMnb9xLd4zLhSbAq/+JKiMtBd3Dv
	7LuwK7wiOzgrLVURiIIh4yfELWW1URqDfIThujVheURHPitbyonaMqJcKEwHMEisUkiYaVQI/0d
	IL2Cdtq2P2jEly3Sa6Ur+K+ATXhngVzSJlMoNp69FA2fpWcAql9M3kTgSOHAEQCeT7pjL+qg1Gm
	LrZOtUg38B2WcQ4Rsowe3raAlTXFxeN7hzSxT4YpFQv1JF7w6F+6G07oneurQAv19JCysXtO3Yy
	rebEn+tyisX1x/oIyw==
X-Received: by 2002:a05:690c:4d42:b0:7bd:7e01:8d6c with SMTP id
 00721157ae682-7ddc5519b55mr3052497b3.50.1779992748401; Thu, 28 May 2026
 11:25:48 -0700 (PDT)
MIME-Version: 1.0
From: Farhad Alemi <farhad.alemi@berkeley.edu>
Date: Thu, 28 May 2026 11:25:36 -0700
X-Gm-Features: AVHnY4L4xx-nCT3mPulo2KgfwwydXmuW09L-mRPZvEPP12bQX_2VIHsqSp_UQZM
Message-ID: <CA+0ovCgxbZkXa+OU8w3s84R3KNPNxxRfmsNR-udh+afQBbGNmw@mail.gmail.com>
Subject: [BUG] lib/bitmap: divide error in bitmap_fold() when sz argument is 0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yury Norov <yury.norov@gmail.com>, Waiman Long <longman@redhat.com>, 
	David Hildenbrand <david@kernel.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000079ab2e0652e4dbd5"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E50991A0003
X-Stat-Signature: ezt4znkzrb1auy8aazk5xszbpk9r97ok
X-HE-Tag: 1779992750-754217
X-HE-Meta: U2FsdGVkX18WYVLKkXobyfpzAONCC5oV9Bp9kt3DK+2mVvhhyCjBaXMHOTEhbE7sb9C4wm7eYP9VsYCx71nNJrArYzvNZjc2kr0j9wMzkcQT+iQuYFkz0aEAn9QinqnziO17pxmsIPoM8PzNU0LDatwovVrJYZBZJmw1XeQfKtjRphrxVNNupFguM3/szuuECEIP54zkGu8TuVzN1XBRhR4cio5cig+LR2mW5HZ0trUjSzMpAqOYUuWQOdMVU9pimkGeo4NWPm8jcbOvv5sIlepLlIxi3SqvCSYWBAbLNtlRqQ+Mr4w4Zk6REQiZONqTVAzzXaYoUctifyCNqMwjg95/0NSy+7U1SA2D1Gufecuq1bStWbUrxVPn2k2FUCoUGdfov3aENjgo0CEE2B1htg+0fOvZ9GlXkUlZZKjz4OtGNoFI7UqiKf7/SkxUeHl8OtKVBS1lb44tfpDL39f90ubxpWbiwhRaA3jRaMRtqXVOf2W36ZWb9ySjkjjASwZTqDJwkaswVXo9F6HIkv6j0VMW25qfggUxWf+QL6dLTmHoACp11m5Ppvcu2Kh1E6VOjIccb1YsI+Uu1/9kMuACRJPffxDVYdX4MKIaM17kuBy2OWQuXMBWeTIHkyNOPk/GXWspYDCDDD1b/nXMd2Vf9N+anwd0dnCeVMNzXG1WBBCPlcUOMCzRDXP4Aoy5a2vZRMLTRNe2b2qNJH8xm/PpV+fA+sAHGSkVy37Z9RR4k0EPPFdJtqFJAI0SZy1j6Le3sWQWR/37yPsPReL8lAdW04QxpTogSX3ApLBMqdLyyNDf1SPUMcPoK1+xVNo3Shjc/G3pc7Gxerav5Te9FfPPHDXDmCgO5fc9wC/ywazZ0idvKdD4wZRLeie8b8Hzv7+PO1vIUrc2vREqTPkLkTkrvu8C0lPUOZAFn9ydHmqyeJOd2CJsbNYcvrJwkNUt4xpauwjsP346AdKomNWJQW7
 iP7v0EDC
 0FrL1OGRy7w4xm3vaBvEUA7f2lrxfUYT847yUheBlwi7GzxDn5Lv3CwQv0g27eAoYVZx5yHPHIKHKhgLLH39jhWLNQ9NICGd8FwHHWL+WyoSYIEaEtgprCTrYIRA429WL+ArHvnoIIc+7LHlXo3/LZRhTOCZdfQ6s9obmAqwTcm+767RdY1NB8VC3qBXt4q0sTTRZsLJc7GdJR7GI6EUaGOcMhBrun+I8vzeljmjW/TLh/FRPJL9+XIPKVlRoYjGfEJP0jPf+xvIxUnzMrhYb/tFGTXpUkI+WfBMLfw3krPJi3OaaglyE2zoTw5R3qDCN23kIUP78/eIRfcZLzlINemW+Qn2dpm76XPD5XN7ZRTJGIfdOEe8+GYhCQkyNCP0A5VvxtyxDb/42GQoPMnBblyaWwkOhcQOQtk4R8YC/fJMRFInG5lcB3KLlSD4sUhfNxHgOVKooVMN1MAc1j4smYj9M9NXR/2BHyJBK4EccWBtD8OwTYfMYMyk2TSwp6hG8K+BVA5OoUWpneAU7MhjOqewRDoGWSl3xgqeX/2DapSbrHRiFw0jzs4XSFBBrFd4L0KR6/+qsFqrRREtDAET2+amVblcy81SFCsjsBpEZuOfjRUTDRwJF6eBS0oNp398bRnRopPARnxef5SjyNnw7aosAM45000IjKSnWpnBcxjSmuiFV/NPDyjTI3hpQqqejteoTQgll9aWse0qO4eelYL3eWx8TEHubHLTWWmm0a4iFGME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--00000000000079ab2e0652e4dbd5
Content-Type: text/plain; charset="UTF-8"

Hello,

I am reporting a divide-by-zero crash in bitmap_fold() found by syzkaller.

Summary:
bitmap_fold() at lib/bitmap.c divides by its `sz` parameter without
guarding sz != 0:

  void bitmap_fold(unsigned long *dst, const unsigned long *orig,
                   unsigned int sz, unsigned int nbits)
  {
          ...
          for_each_set_bit(oldbit, orig, nbits)
                  set_bit(oldbit % sz, dst);
  }

The call chain in the observed crash is:

  mpol_relative_nodemask()   mm/mempolicy.c
    nodes_fold(tmp, *orig, nodes_weight(*rel))
  __nodes_fold()              include/linux/nodemask.h
    bitmap_fold(dstp->bits, origp->bits, sz, nbits)
  bitmap_fold()               lib/bitmap.c

When `nodes_weight(*rel)` is 0 (i.e. the relative-nodes mask is empty),
the `sz` argument passed to bitmap_fold() is 0, and the
`oldbit % sz` expression executes a divl by zero.

Observed on:
- Linux v6.18.32-dirty (where the bug was originally found), x86_64,
  QEMU Q35
- KASAN enabled; panic_on_warn set
- The only local dirty file in my tree is drivers/tty/serial/serial_core.c,
  containing a local ttyS0 console guard for the fuzzing harness. It is
  unrelated to lib/bitmap, mm/mempolicy, or kernel/cgroup/cpuset.
- The crash fires in a cpu-hotplug kernel thread (Comm: cpuhp/1, PID 21)
  reached via sched_cpu_deactivate -> cpuset_handle_hotplug ->
  cpuset_update_tasks_nodemask -> mpol_rebind_mm -> mpol_rebind_policy
  -> mpol_rebind_nodemask -> mpol_relative_nodemask -> __nodes_fold ->
  bitmap_fold.
- Source inspection of linus/master at commit e8c2f9fdadee
  (v7.1-rc4-754-ge8c2f9fdadee) shows the buggy structure is unchanged:
  bitmap_fold() at lib/bitmap.c:718 still computes `oldbit % sz` with
  no sz != 0 guard; __nodes_fold() at include/linux/nodemask.h:365
  still forwards its sz argument; mpol_relative_nodemask() at
  mm/mempolicy.c:370 still calls nodes_fold(tmp, *orig,
  nodes_weight(*rel)). I have not re-run a reproducer against
  e8c2f9fdadee as no standalone reproducer is available yet.

Impact:
A divide-by-zero in a cpu-hotplug kernel thread context kills the
kernel:

  Oops: divide error: 0000 [#1] SMP KASAN NOPTI
  CPU: 1 UID: 0 PID: 21 Comm: cpuhp/1 Not tainted 6.18.32-dirty #1 PREEMPT(full)
  RIP: 0010:bitmap_fold+0x5e/0xb0 lib/bitmap.c:713

The crash report's code disassembly pins the trapping instruction to
`divl 0x4(%rsp)` (bytes `f7 74 24 04`) with %edx pre-zeroed by the
preceding `xor %edx,%edx` -- i.e. a 32-bit unsigned divide by the
on-stack `sz` value.

Relevant stack:

  bitmap_fold+0x5e/0xb0 lib/bitmap.c:713
  __nodes_fold include/linux/nodemask.h:369 [inline]
  mpol_relative_nodemask mm/mempolicy.c:372 [inline]
  mpol_rebind_nodemask+0x1e9/0x2d0 mm/mempolicy.c:508
  mpol_rebind_policy mm/mempolicy.c:542 [inline]
  mpol_rebind_mm+0x3ab/0x680 mm/mempolicy.c:569
  cpuset_update_tasks_nodemask+0x22e/0x340 kernel/cgroup/cpuset.c:2777
  hotplug_update_tasks kernel/cgroup/cpuset.c:3882 [inline]
  cpuset_hotplug_update_tasks kernel/cgroup/cpuset.c:3985 [inline]
  cpuset_handle_hotplug+0xe52/0x1200 kernel/cgroup/cpuset.c:4089
  cpuset_cpu_inactive kernel/sched/core.c:8377 [inline]
  sched_cpu_deactivate+0x497/0x600 kernel/sched/core.c:8493
  cpuhp_invoke_callback+0x44a/0x860 kernel/cpu.c:195
  cpuhp_thread_fun+0x40f/0x870 kernel/cpu.c:1105
  smpboot_thread_fn+0x546/0xa50 kernel/smpboot.c:160
  kthread+0x73e/0x8c0 kernel/kthread.c:432

Expected behavior:
Either bitmap_fold() should guard against sz == 0 (return early or
WARN+return), or the callers in the nodes_fold / mpol_relative_nodemask
chain should not pass a zero `sz` (e.g. short-circuit the rebind when
the relative nodemask is empty).

Reproducer:
A standalone .syz or C reproducer was not produced for this seed; the
crash fired during broader cpu/cgroup/mempolicy fuzzing. The console
report is attached as crash-report.txt.

Novelty check:
I searched the syzbot dashboard's upstream open, fixed, stable, and
invalid (per-subsystem mempolicy/mm/cgroups) namespaces, the Android
dashboard, and the marc.info linux-mm and linux-kernel archives, for
"bitmap_fold", "mpol_rebind_nodemask" + "divide error", "__nodes_fold"
+ "BUG"/"Oops", and "cpuset_handle_hotplug" + "BUG". I did not find an
exact match. The recent Jinjiang Tu series (mainline commit
3d702678f57e, "mm/mempolicy: fix mpol_rebind_nodemask() for
MPOL_F_NUMA_BALANCING") is a sibling fix in the same function but
addresses wrong-rebind logic under NUMA balancing, not the
divide-by-zero in bitmap_fold().

I appreciate your time and consideration, and I'm grateful for your
work on this subsystem. I'd be glad to test any candidate patches.

Regards,

--00000000000079ab2e0652e4dbd5
Content-Type: text/plain; charset="US-ASCII"; name="crash-report.txt"
Content-Disposition: attachment; filename="crash-report.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_mpptowhs0>
X-Attachment-Id: f_mpptowhs0

T29wczogZGl2aWRlIGVycm9yOiAwMDAwIFsjMV0gU01QIEtBU0FOIE5PUFRJCkNQVTogMSBVSUQ6
IDAgUElEOiAyMSBDb21tOiBjcHVocC8xIE5vdCB0YWludGVkIDYuMTguMzItZGlydHkgIzEgUFJF
RU1QVChmdWxsKSAKSGFyZHdhcmUgbmFtZTogUUVNVSBTdGFuZGFyZCBQQyAoUTM1ICsgSUNIOSwg
MjAwOSksIEJJT1MgMS4xNi4zLWRlYmlhbi0xLjE2LjMtMiAwNC8wMS8yMDE0ClJJUDogMDAxMDpi
aXRtYXBfZm9sZCsweDVlLzB4YjAgbGliL2JpdG1hcC5jOjcxMwpDb2RlOiAzMSBmNiBlOCBhNSA0
ZSAyMCBmZSA0MSA4OSBkYyA0NCA4OSBlYSA0YyA4OSBmNyA0YyA4OSBlNiBlOCA4NCBmMiAwMSAw
MCA0OSA4OSBjNSA0NCAzOSBlYiA3NiAyZCBlOCBmNyBmYyBiOSBmZCA0NCA4OSBlOCAzMSBkMiA8
Zjc+IDc0IDI0IDA0IDg5IGQ1IDg5IGQwIGMxIGU4IDA2IDQ5IDhkIDNjIGM3IGJlIDA4IDAwIDAw
IDAwIGU4IDM5ClJTUDogMDAxODpmZmZmYzkwMDAwMTZmNTIwIEVGTEFHUzogMDAwMTAyNDYKUkFY
OiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAwMDAwMDAwMDA0MCBSQ1g6IGZmZmY4ODgxMDI2
YTAwMDAKUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJTSTogMDAwMDAwMDAwMDAwMDA0MCBSREk6IGZm
ZmY4ODgxMjZmNmYyMTgKUkJQOiBmZmZmYzkwMDAwMTZmNjMwIFIwODogZmZmZmM5MDAwMDE2ZjVh
NyBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKUjEwOiBmZmZmYzkwMDAwMTZmNWEwIFIxMTogZmZmZmY1
MjAwMDAyZGViNSBSMTI6IDAwMDAwMDAwMDAwMDAwNDAKUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIx
NDogZmZmZjg4ODEyNmY2ZjIxOCBSMTU6IGZmZmZjOTAwMDAxNmY1YTAKRlM6ICAwMDAwMDAwMDAw
MDAwMDAwKDAwMDApIEdTOmZmZmY4ODgyYWJjYzQwMDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAw
MDAwMApDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAwMDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCkNS
MjogMDAwMDdmY2Q4YzljNmZlOCBDUjM6IDAwMDAwMDAxOTI3NTgwMDAgQ1I0OiAwMDAwMDAwMDAw
NzUwZWYwClBLUlU6IDU1NTU1NTU0CkNhbGwgVHJhY2U6CiA8VEFTSz4KIF9fbm9kZXNfZm9sZCBp
bmNsdWRlL2xpbnV4L25vZGVtYXNrLmg6MzY5IFtpbmxpbmVdCiBtcG9sX3JlbGF0aXZlX25vZGVt
YXNrIG1tL21lbXBvbGljeS5jOjM3MiBbaW5saW5lXQogbXBvbF9yZWJpbmRfbm9kZW1hc2srMHgx
ZTkvMHgyZDAgbW0vbWVtcG9saWN5LmM6NTA4CiBtcG9sX3JlYmluZF9wb2xpY3kgbW0vbWVtcG9s
aWN5LmM6NTQyIFtpbmxpbmVdCiBtcG9sX3JlYmluZF9tbSsweDNhYi8weDY4MCBtbS9tZW1wb2xp
Y3kuYzo1NjkKIGNwdXNldF91cGRhdGVfdGFza3Nfbm9kZW1hc2srMHgyMmUvMHgzNDAga2VybmVs
L2Nncm91cC9jcHVzZXQuYzoyNzc3CiBob3RwbHVnX3VwZGF0ZV90YXNrcyBrZXJuZWwvY2dyb3Vw
L2NwdXNldC5jOjM4ODIgW2lubGluZV0KIGNwdXNldF9ob3RwbHVnX3VwZGF0ZV90YXNrcyBrZXJu
ZWwvY2dyb3VwL2NwdXNldC5jOjM5ODUgW2lubGluZV0KIGNwdXNldF9oYW5kbGVfaG90cGx1Zysw
eGU1Mi8weDEyMDAga2VybmVsL2Nncm91cC9jcHVzZXQuYzo0MDg5CiBjcHVzZXRfY3B1X2luYWN0
aXZlIGtlcm5lbC9zY2hlZC9jb3JlLmM6ODM3NyBbaW5saW5lXQogc2NoZWRfY3B1X2RlYWN0aXZh
dGUrMHg0OTcvMHg2MDAga2VybmVsL3NjaGVkL2NvcmUuYzo4NDkzCiBjcHVocF9pbnZva2VfY2Fs
bGJhY2srMHg0NGEvMHg4NjAga2VybmVsL2NwdS5jOjE5NQogY3B1aHBfdGhyZWFkX2Z1bisweDQw
Zi8weDg3MCBrZXJuZWwvY3B1LmM6MTEwNQogc21wYm9vdF90aHJlYWRfZm4rMHg1NDYvMHhhNTAg
a2VybmVsL3NtcGJvb3QuYzoxNjAKIGt0aHJlYWQrMHg3M2UvMHg4YzAga2VybmVsL2t0aHJlYWQu
Yzo0MzIKIHJldF9mcm9tX2ZvcmsrMHg0YjQvMHhhMzAgYXJjaC94ODYva2VybmVsL3Byb2Nlc3Mu
YzoxNTgKIHJldF9mcm9tX2ZvcmtfYXNtKzB4MWEvMHgzMCBhcmNoL3g4Ni9lbnRyeS9lbnRyeV82
NC5TOjI0NQogPC9UQVNLPgpNb2R1bGVzIGxpbmtlZCBpbjoKLS0tWyBlbmQgdHJhY2UgMDAwMDAw
MDAwMDAwMDAwMCBdLS0tClJJUDogMDAxMDpiaXRtYXBfZm9sZCsweDVlLzB4YjAgbGliL2JpdG1h
cC5jOjcxMwpDb2RlOiAzMSBmNiBlOCBhNSA0ZSAyMCBmZSA0MSA4OSBkYyA0NCA4OSBlYSA0YyA4
OSBmNyA0YyA4OSBlNiBlOCA4NCBmMiAwMSAwMCA0OSA4OSBjNSA0NCAzOSBlYiA3NiAyZCBlOCBm
NyBmYyBiOSBmZCA0NCA4OSBlOCAzMSBkMiA8Zjc+IDc0IDI0IDA0IDg5IGQ1IDg5IGQwIGMxIGU4
IDA2IDQ5IDhkIDNjIGM3IGJlIDA4IDAwIDAwIDAwIGU4IDM5ClJTUDogMDAxODpmZmZmYzkwMDAw
MTZmNTIwIEVGTEFHUzogMDAwMTAyNDYKUkFYOiAwMDAwMDAwMDAwMDAwMDAwIFJCWDogMDAwMDAw
MDAwMDAwMDA0MCBSQ1g6IGZmZmY4ODgxMDI2YTAwMDAKUkRYOiAwMDAwMDAwMDAwMDAwMDAwIFJT
STogMDAwMDAwMDAwMDAwMDA0MCBSREk6IGZmZmY4ODgxMjZmNmYyMTgKUkJQOiBmZmZmYzkwMDAw
MTZmNjMwIFIwODogZmZmZmM5MDAwMDE2ZjVhNyBSMDk6IDAwMDAwMDAwMDAwMDAwMDAKUjEwOiBm
ZmZmYzkwMDAwMTZmNWEwIFIxMTogZmZmZmY1MjAwMDAyZGViNSBSMTI6IDAwMDAwMDAwMDAwMDAw
NDAKUjEzOiAwMDAwMDAwMDAwMDAwMDAwIFIxNDogZmZmZjg4ODEyNmY2ZjIxOCBSMTU6IGZmZmZj
OTAwMDAxNmY1YTAKRlM6ICAwMDAwMDAwMDAwMDAwMDAwKDAwMDApIEdTOmZmZmY4ODgyYWJjYzQw
MDAoMDAwMCkga25sR1M6MDAwMDAwMDAwMDAwMDAwMApDUzogIDAwMTAgRFM6IDAwMDAgRVM6IDAw
MDAgQ1IwOiAwMDAwMDAwMDgwMDUwMDMzCkNSMjogMDAwMDdmY2Q4YzljNmZlOCBDUjM6IDAwMDAw
MDAxOTI3NTgwMDAgQ1I0OiAwMDAwMDAwMDAwNzUwZWYwClBLUlU6IDU1NTU1NTU0Ci0tLS0tLS0t
LS0tLS0tLS0KQ29kZSBkaXNhc3NlbWJseSAoYmVzdCBndWVzcyk6CiAgIDA6CTMxIGY2ICAgICAg
ICAgICAgICAgIAl4b3IgICAgJWVzaSwlZXNpCiAgIDI6CWU4IGE1IDRlIDIwIGZlICAgICAgIAlj
YWxsICAgMHhmZTIwNGVhYwogICA3Ogk0MSA4OSBkYyAgICAgICAgICAgICAJbW92ICAgICVlYngs
JXIxMmQKICAgYToJNDQgODkgZWEgICAgICAgICAgICAgCW1vdiAgICAlcjEzZCwlZWR4CiAgIGQ6
CTRjIDg5IGY3ICAgICAgICAgICAgIAltb3YgICAgJXIxNCwlcmRpCiAgMTA6CTRjIDg5IGU2ICAg
ICAgICAgICAgIAltb3YgICAgJXIxMiwlcnNpCiAgMTM6CWU4IDg0IGYyIDAxIDAwICAgICAgIAlj
YWxsICAgMHgxZjI5YwogIDE4Ogk0OSA4OSBjNSAgICAgICAgICAgICAJbW92ICAgICVyYXgsJXIx
MwogIDFiOgk0NCAzOSBlYiAgICAgICAgICAgICAJY21wICAgICVyMTNkLCVlYngKICAxZToJNzYg
MmQgICAgICAgICAgICAgICAgCWpiZSAgICAweDRkCiAgMjA6CWU4IGY3IGZjIGI5IGZkICAgICAg
IAljYWxsICAgMHhmZGI5ZmQxYwogIDI1Ogk0NCA4OSBlOCAgICAgICAgICAgICAJbW92ICAgICVy
MTNkLCVlYXgKICAyODoJMzEgZDIgICAgICAgICAgICAgICAgCXhvciAgICAlZWR4LCVlZHgKKiAy
YToJZjcgNzQgMjQgMDQgICAgICAgICAgCWRpdmwgICAweDQoJXJzcCkgPC0tIHRyYXBwaW5nIGlu
c3RydWN0aW9uCiAgMmU6CTg5IGQ1ICAgICAgICAgICAgICAgIAltb3YgICAgJWVkeCwlZWJwCiAg
MzA6CTg5IGQwICAgICAgICAgICAgICAgIAltb3YgICAgJWVkeCwlZWF4CiAgMzI6CWMxIGU4IDA2
ICAgICAgICAgICAgIAlzaHIgICAgJDB4NiwlZWF4CiAgMzU6CTQ5IDhkIDNjIGM3ICAgICAgICAg
IAlsZWEgICAgKCVyMTUsJXJheCw4KSwlcmRpCiAgMzk6CWJlIDA4IDAwIDAwIDAwICAgICAgIAlt
b3YgICAgJDB4OCwlZXNpCiAgM2U6CWU4ICAgICAgICAgICAgICAgICAgIAkuYnl0ZSAweGU4CiAg
M2Y6CTM5ICAgICAgICAgICAgICAgICAgIAkuYnl0ZSAweDM5Cgo8PDw8PDw8PDw8PDw8PDwgdGFp
bCByZXBvcnQgPj4+Pj4+Pj4+Pj4+Pj4+Cgo=
--00000000000079ab2e0652e4dbd5--

