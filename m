Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028BEC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF5796B0099; Thu,  6 Aug 2026 16:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA6F36B00A0; Thu,  6 Aug 2026 16:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A71026B00A1; Thu,  6 Aug 2026 16:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 757466B0099
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:05:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F3E9A1401E9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:05:54 +0000 (UTC)
X-FDA: 85071925428.12.D9869D8
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf10.hostedemail.com (Postfix) with ESMTP id 573A2C000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:05:53 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ffx40NeW;
	spf=pass (imf10.hostedemail.com: domain of 3H-l0agYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3H-l0agYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mYilKGc1Ozm+Wqc6rMtn6RGepKDO0nOO45ZaajNWpPU=;
	b=oWNnHW+i2LB2QSYdVnFGdWVbNYR9RSXPsPXtk6nJrRVdBlWa9bLld3h2r8exS4sOkSc3Y/
	sTc+UThTemsXr+Ty97gjHIVdvsXSuX6E6ARQew2SPrA2K+I0NMNN2b7PCnbQV7ZmEX+YMY
	E7/Ymky9yh/OWFgBL5A5/qCYvC1rUh8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ffx40NeW;
	spf=pass (imf10.hostedemail.com: domain of 3H-l0agYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3H-l0agYKCCAOQNAJ7CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046753;
	b=ubR8Aa6U8vImdHI4OeWwrEb8RZIbe4VL5SL2N+pZ2WYu/pp+yxvV9/WtSQYyPyoC8iR8Sr
	Vz2VDd1a/L5zRj2I05QgsU8KDaKl+om7uAQyBDOdX8zT0ofR2dbyNdTqwVNQt5TQBQxzOK
	pxDJC3tAtf2nyQmUkGJgfvuOKkqzzFE=
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca7c1e22995so3762204a12.3
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 13:05:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786046752; x=1786651552; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mYilKGc1Ozm+Wqc6rMtn6RGepKDO0nOO45ZaajNWpPU=;
        b=ffx40NeW2YtYX2AjvLl/FrlKQ4xlTkwa+qUdAki/NI61Tv+Yobjbn4Nj8xJjX1WA1W
         dnv0zeJJVv++ZEWjrKk0J7WSeX4TqfDpx81/ylfXHOQXfT0Kmc5armnvYjZFLBJeRzTY
         FiXi+NsqVpv6Jk0X4Eh552fOWvfUjTy4ELCUlGE5/HLHHfBlOeaEm6cWTTgInexuVVc9
         34/YplIUdniJD8XNzvg0lOU3Er2e2TcBhMfeuEBvii531NGKZOZlzWam391vKVlUjgVx
         KhtdNs/Ne3kYiodaPz4v7WWr0PKpvLQGzk7zijEhZ8X1yLdJSBSZuK5uMQzNgAkNB9zY
         WLug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786046752; x=1786651552;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mYilKGc1Ozm+Wqc6rMtn6RGepKDO0nOO45ZaajNWpPU=;
        b=WQmFmc095leONpV0+8rnq9xC8H/KB2//6lt/XLznmfBOiMGYmFvVmLD271y7W+5PEt
         x5gD/+FKJ+U7WJILXHS+XM++9xkULTbQX/i95Rx4jHA1sXpfs0fnYP1t/7xcq4eds/pP
         0nGzg+iKxfrCFR/WxGDBKhwa/wlliDaUTclH+Z+rD8UCU9H0pxRH6RwK+0zv+HTqFMSS
         7tnUDT0JM2DbutyENOtGWotYGPPlO2bKy+ebskupVbvWqYHAch+zob8wbCJFyG8kXTtv
         5lbD6xamwH7Kx6GgnWZOZK03goWrSlRL1yW46KvmemmGyHl4OzeSWEJIv5Zv1pn+DMge
         ot9A==
X-Forwarded-Encrypted: i=1; AHgh+RpuW6FwisCwvEoufxu5NIzxHd6swsRc3BqqmBzHYZTywntKn1M2VNphqOSZUc/PH+xED9swfk2QyA==@kvack.org
X-Gm-Message-State: AOJu0YzK60j4u5wxnthYU6XluMMzUarrgITdhUataBs5LzM1W62e1QhB
	xDI8LTzE05/AE1Zr6ssfpZDqAMHMB9HjTswhYi7JK7eWfxz+KScqzcXkQHGng3WinzCbV0HW0t1
	5fjqf8Q==
X-Received: from dlzz39.prod.google.com ([2002:a05:7022:4a7:b0:13c:fa0e:4693])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:918e:b0:3c4:1c9f:d81
 with SMTP id adf61e73a8af0-3cb85e2b5ffmr16224877637.7.1786046751801; Thu, 06
 Aug 2026 13:05:51 -0700 (PDT)
Date: Thu,  6 Aug 2026 13:05:43 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806200548.3124802-1-surenb@google.com>
Subject: [PATCH v4 0/5] mm: Unconditional per-VMA locks and cleanups
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: r8ehw41uja9imokbfabdcb4ddzihfxii
X-Rspamd-Queue-Id: 573A2C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786046753-693473
X-HE-Meta: U2FsdGVkX1+y+u0zEpk5pgYGmJSzqW4/TCxV1rnBK30ULtf4A0+ZgcPSR/8jkeEh8B5ewjK0gRUOWKTPrODeR15Yb3uM3+mYyrsINngyiKyurpQzL8Pz+aP6dzCSCw3gnPQYEXdjhjZ6XSIzsKOIk2o4yNI0+0G1Z48RzqsL7Rx9ZPmkiIfctEASmdw64+x8dgffDU0JXAFQWMywEAyDCfzSbRlSRYfP8ygxfxzcaO5pAibzIeNCwLrit8Cgyn7U9E6A+OOuNp8Gf7pB/y2u7DEE8qQYziNREOUPxGKxnlqx/z7pt+s7xl7ZUbKCGpD7//gP8R/aKSGsPkuGervEaLY1kQ1BC2+vyfMJQnK9poZW7rLeVL24KrXQmrMgyTKU31HadDoDrVJSPSx394K4QqiYDy08uZ8uRaoKvSk0iBQixCx/GG3gPv0A3PhKGY2EruZtEbe9Lo2I0XQS4dn886VMo9nwIwf/S6BDpIRIOeM3KgUzUWaqur7XbvtcHdBKFjko7fgbgBUekAA6qA+O2VenbRh7ytKfCwk6vtvhIIFa3aXD3a73Wc9+4Rbm56rpSoKOY0pl8CkCEGJwYgZrJAtAm2awZOF1UK9iXuX1+2fRHrIwvGDgA6AeHCryBQsJeoTk5pDlmQvJpLG3VW7Avmlkuus56YHfgIdfg3NsFdkg/AHBmaAGweFQGKaJgASD1N4L461y0hxypZwCSrI1GqIo+Fpj1aJMg7hdexfeCiwvs2WWpIQvbr9l6AXcgwvBV5CDltEr5l1g6xjXZpF7d0aVwPaEaLAiuTArrKb2mh6LqxiJIyRvd1xXgjD2q4QCs6oWyZSxmoFeyiWLKT0l0j1CI6iR6siqSvgFGnpUDZLgZMsci1v42yjb8NjVsJFL/TKev/M592V4rYzxX1AU/oS7OHGqQakwF2X1VusdOrGiaZGLdfY3VZ56rFYnFC5eBZWjPLU4/1dqflbf7je
 G0NwPRmx
 t+J8hJAlL5Y4WQt6uRw9ou5svXNWS+/0DZ0O0u1TTs3kYmZGerjVWggxWui7NgrHQsMfKHLj1Llx8Ti4sZbMx4VLJBb6/20YWwztJ04/AMgEkwrZ6NbGLDGnOANJAI3RZSScrKSRRHEsIasNa8qi/MO9Zd6t3Bq27VaClbe1eb0JIkX/IIO0ShtYl9BHx84r/6Q/IQCdSHBVei1cFDn2HpQmmMMe83iBxszIyG3I0oWZQhlndFbiLzW2bLo6g8QqR/D1bZ/EOvzqJ98TWIWsq2IARRMC3izGSkJqgihBZ5flAttt75pkhSQZ+cyg98GxBBbKduPLZ12gkREvOT3jDGvqpNMH/8FAwGm62kUJt42PP6v1ZuW1YwrjHBmjNeAq26BcbvIdZD6xoxwpnWLL3lOKc1lL89yv/mbBnL3HC3+QHjVpo5yqW0mnaibzRior0sMn3n7mj1nrGNKxLjMmGdKtFoY+0u3PL6RbpyOZ+LASkC7Di6vYxMDXewN1Ihev7Lq8T6hRAP+3JNjXUIj2geRiJTYschaXrf/KrWLNt45OfRCcYe9fZUYleYCSDOB8O4YIvUCt2PFgVhclchfG47rjWep5lnZkpDtD2c8u8nOcntHtMGidZSsU0PR0jw3aS/5Wdf/6GBwtiGz+ATqzysHcah5u0nsn4Z3SFkFjjM0z76amJynfzwvsFHHNZMyMEQKCmYKVe3h9nQDtaO5QGy32ChJ0IT/bnSZzNoHUXvaa/1NhMPp7VCCm4ppkmmHVsYemXWJqL46u/tho5dFsPNi2U67aSu+Hcm1AIysBoxYGsT1ZQtrwiD+AaursYdgBAi1VaaMEJEQLhzpgHouQyNzri3pzzvcjS40DH5J9kgUrBJgbG6d/xh6GnFRiFyF2m/tqb5MQoCQEqycHAdpFzaTojC3fOOQeDIqKo/ZyGu7EavC0Y7JIfoowpUyKkDrMNhjGQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2 version of this patchset [1] was written by Dave Hansen and per his
request, I'm taking over this series.

tl;dr: Make per-VMA locks available in all configs. Simplify some
of the per-VMA lock users now that they can rely on them being
always available.

Binder and networking folks: Your code is the target of the cleanups.
I'm cc'ing you now on v2 because there's emerging consensus on the mm
side that the approach here is sane. I'm not quite sure how this pile
would get merged, but ack/review tags would be appreciated if this
looks good to you.

Longer version:

When working on some x86 shadow stack code, it was a real pain to
avoid causing recursive locking problems with mmap_lock. One way
to avoid those was to avoid mmap_lock and use per-VMA locks instead.
They are great, but they are not available in all configs which
makes them unusable in generic code, or if you want to completely
avoid mmap_lock.

Make per-VMA locks available in all configs. Right now, they are
only available on select architectures when SMP and MMU are enabled.
But all of the primitives that per-VMA locks are built on (RCU, maple
trees, refcounts) work just fine without SMP or MMU.

The only real downside is that making VMAs a wee bit bigger on !MMU
and !SMP builds.

The upside is much cleaner code, lower complexity and less #ifdeffery.

Clean up a binder VMA locking site now that it can rely on per-VMA
locks.

Building on top of universally-available per-VMA locks, introduce a
new helper. Since the new API does not require callers to have a
fallback to mmap_lock, it's much easier to use. Callers can
potentially replace this very common kernel idiom:

	mmap_read_lock(mm);
	vma =3D vma_lookup()
	// fiddle with vma
	mmap_read_unlock(mm);

with:

	vma =3D vma_start_read_unlocked(mm, address);
	// fiddle with vma
	vma_end_read(vma);

Which avoids mmap_lock entirely in the fast path.

Use that new API for another binder site and one in the TCP code.

Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org

Changes from v3 [2]:
Patch 1:
- Restored a comment in Kconfig, per Vlastimil Babka
- Removed extra braces in mm.rs, per Vlastimil Babka
- Removed obsolete comment in mm.rs, per Sashiko
- Updated patch description to explain considerations for !CONFIG_MMU
- Changed stack_map_lock_vma() to keep mmap_lock if !CONFIG_MMU
- Changed bpf_iter_task_vma_new() to bail out if !CONFIG_MMU
- Added !CONFIG_MMU versions of vma_mark_attached(), vma_mark_detached(),
  vma_start_write(), vma_start_write_killable(), vma_assert_attached() and
  vma_assert_write_locked()
Patch 2:
- Move binder_alloc_is_mapped() check to only protect zap_vma_range() and
  make error handling consistent, per Alice Ryhl and Lorenzo Stoakes
Patch 3:
- Added Suggested-by, per Lorenzo Stoakes
- Updated the comments for vma_start_read_unlocked(), per Lorenzo Stoakes
  and Vlastimil Babka
- Updated the patch description, per Vlastimil Babka and Lorenzo Stoakes
Patch 4:
- Updated comments for vma_start_read_unlocked() Rust version to be
  consistent with C, per Lorenzo Stoakes
- Added Reviewed-by and Acked-by, per Alice Ryhl and Lorenzo Stoakes
Patch 5:
- Added a note in the changelog why the mmap_lock fallback removal does
  not affect NOMMU case

Applies cleanly over mm-unstable

[1] https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc=
.intel.com/
[2] https://lore.kernel.org/all/20260802215459.2769283-1-surenb@google.com/

Dave Hansen (5):
  mm: Make per-VMA locks available universally
  binder: Make shrinker rely solely on per-VMA lock
  mm: Add RCU-based VMA lookup helper that waits for writers
  binder: Remove mmap_lock fallback
  tcp: Remove mmap_lock fallback path

 arch/arm/Kconfig                       |  1 -
 arch/arm64/Kconfig                     |  1 -
 arch/loongarch/Kconfig                 |  1 -
 arch/powerpc/platforms/powernv/Kconfig |  1 -
 arch/powerpc/platforms/pseries/Kconfig |  1 -
 arch/riscv/Kconfig                     |  1 -
 arch/s390/Kconfig                      |  1 -
 arch/x86/Kconfig                       |  2 -
 drivers/android/binder/page_range.rs   | 19 +-----
 drivers/android/binder_alloc.c         | 62 +++++++----------
 fs/proc/internal.h                     |  2 -
 fs/proc/task_mmu.c                     | 93 --------------------------
 include/linux/mm.h                     | 12 ----
 include/linux/mm_types.h               |  8 +--
 include/linux/mmap_lock.h              | 89 ++++++++++--------------
 kernel/bpf/stackmap.c                  | 15 ++---
 kernel/bpf/task_iter.c                 |  2 +-
 kernel/fork.c                          |  2 -
 mm/Kconfig                             | 12 ----
 mm/Kconfig.debug                       |  1 -
 mm/debug.c                             |  4 --
 mm/init-mm.c                           |  2 -
 mm/memory.c                            |  2 -
 mm/mmap_lock.c                         | 59 +++++++++-------
 mm/pagewalk.c                          |  2 -
 mm/rmap.c                              |  2 -
 mm/userfaultfd.c                       | 61 ++---------------
 net/ipv4/tcp.c                         | 31 +++------
 rust/kernel/mm.rs                      | 57 ++++++++++------
 tools/testing/vma/include/dup.h        |  5 +-
 tools/testing/vma/vma_internal.h       |  1 -
 31 files changed, 157 insertions(+), 395 deletions(-)


base-commit: bacc32cc7de65ffff70080a48eb294f89e434d5e
--=20
2.55.0.654.g21b8a5bc05-goog


