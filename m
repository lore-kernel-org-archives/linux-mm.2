Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D603C5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15B96B007B; Tue, 11 Aug 2026 21:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC6D16B0088; Tue, 11 Aug 2026 21:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDC6B6B008A; Tue, 11 Aug 2026 21:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95D4B6B007B
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:11:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8CC511202B5
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:02 +0000 (UTC)
X-FDA: 85090838364.07.F617427
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf02.hostedemail.com (Postfix) with ESMTP id E6F6580002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uuwrgwlT;
	spf=pass (imf02.hostedemail.com: domain of 3I8h7agYKCPwwyvirfksskpi.gsqpmry1-qqozego.svk@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3I8h7agYKCPwwyvirfksskpi.gsqpmry1-qqozego.svk@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786497060;
	b=1XUbf7Bmt8AAjibU0xxKQMKz48d7cYHRwiRaArNJ6Muqwx/cy7c4UVEwSrMVWso082vQEC
	fuqOc5iEDjGtZP/efMiAvY1kaxVgsMbxAHuHtm9iC2GUtq3CpqNePnPg+swq6Uk4rjfFgV
	Zq61jSlkfg+i2qX0Czw/FFpQppDiiGk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uuwrgwlT;
	spf=pass (imf02.hostedemail.com: domain of 3I8h7agYKCPwwyvirfksskpi.gsqpmry1-qqozego.svk@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3I8h7agYKCPwwyvirfksskpi.gsqpmry1-qqozego.svk@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786497060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ymmox5ngHEOJixoUwvIF+857zRrBcDTQSn1VqCUgM4A=;
	b=22hb+vCyCX1FGNo/n/lFAdVX/5Jdn3uNgJzo3nuOgDAF1Nfo9FHz4X8oo3DUflUSnkmWh9
	EygzfK9Cjh79dFbLdSoCiB/kX/aVOoF1K9Wx7Av47MGg5oxzmmyvpDBY6Hlpg/9p61aeCa
	c4Y964I1mIQdgtcRlkVWC4f9aA1TEl0=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38fa7b09921so763362a91.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786497060; x=1787101860; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ymmox5ngHEOJixoUwvIF+857zRrBcDTQSn1VqCUgM4A=;
        b=uuwrgwlTLieLRUd18MruF76SBqOiAUGIqEN35e9yYuVqgC7hBSg1BpvINetW5hsX8m
         V8iXdBWrcrUonoiWnCwNcU87KYYLcarAHd3YPV9yjkCddc2O3vl3mIYwFZE/MzHkz5N5
         HNGp1AYogsXJh510PgYlEvroA2soHcSLLxrG9GYlEwtn9nwao6Pr38VP0Yc5okncGXo4
         6sqPUI5MVOPGbbOFHp2dnrLL8lw0Kg2le7ACjexQe7x7IUXOOFgRM8z12EPVORDx9z2H
         Ccy6DhuwRg0EL92xsuZ4o3/VN0R70bWkFdm5HIv3KZM8A1T9ubRiAeX7C1tliu/zS8Jv
         zlDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497060; x=1787101860;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ymmox5ngHEOJixoUwvIF+857zRrBcDTQSn1VqCUgM4A=;
        b=eZdY2Rm5PXWIkKwHIQO+m+sjDlV0OAQvA92HDz1j4JBFBpEH7nGOc7oxBi+XjgPKXt
         /dcwCEGTrpt81++Z1cnw+VDThP9pie5yLVZOXomh7T8/pocHamCvy/gr5ox7AM3tRQzu
         6mMvNsWpO0XQ1SIAnC2qKopruPdiKzCb1MBHT6EkPQSH/g6rLElcdgskmVB5SwbNPUtB
         /gDEr5+joZdsRO/tRJYLwQq8Hh9UxY4CYmuWNS3RdGSJZTUS8fd3dPoNj2YIKiCgwfZZ
         qQQnB7pTDmLs0EYXgnM5ErjAH2km7vf+E2dFjtJHgqWfRgZiPezXKOxsq85kviLaLl5x
         E8/Q==
X-Forwarded-Encrypted: i=1; AHgh+RqrTK7eg5hIUCl7kBqq1aNuFjmoVXfJZpctcfELOHjLsEm1W3TKj7KeRySfj9oc1G8YDkazUdTLEw==@kvack.org
X-Gm-Message-State: AOJu0YzGaBmtPZ6GVfbFhzBt4851H1Zvpwpf9F+hVnl8pIC1oUwwZtZ/
	ro7tEc/yZoomv6I48pI2iQQ6P6ZvjLbFgTQy7MV13E2bTic+9n6RncOdhPsZhQhHXZ+hTx/HCdZ
	dfFtdfQ==
X-Received: from dlbro11.prod.google.com ([2002:a05:7022:158b:b0:140:ef7c:eac])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5847:b0:381:6c5:3f63
 with SMTP id 98e67ed59e1d1-393011f39e1mr1328797a91.6.1786497059420; Tue, 11
 Aug 2026 18:10:59 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:10:50 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260812011056.902771-1-surenb@google.com>
Subject: [PATCH v5 0/5] mm: Unconditional per-VMA locks and cleanups
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E6F6580002
X-Stat-Signature: 7af33qewritwsbb39m8coqx8wzbzt53n
X-HE-Tag: 1786497060-943681
X-HE-Meta: U2FsdGVkX19qFetnGFSFho7zr+lXZLlj3pEMG7PJEPmfUipB90LNNOL5O4Ox7t8os7NPiHv2Wg53zk8scAcl4Z47ytvv7PpgyH4iHM79lEN+9B5cMDUI5QRPStMvE7dJqm+u9b6YUs2dvNG3sYqGBMZVToW1jOsymZAYXs21vebywxGvsJmpdexv5hz61N+ffs4+3l4FHQbq1NCqlo3P60va8prlOUDMzGZejsrJ9rJTMzkBnYme2dD/I+N4a4Z4p9EWAFrDx9HAS62gNpQk0I3l64QqtVuQrMdCujW5+/iKPRUDfGCn5fWTT8gqcIArL7+CwQpWTe8wLzXRBXtj2QiWFsVr5amHLAZtscetDOFCSHAmuGz3Yf9QiBwQcBqlI+ZG3YGORflZnVksV0zpfjnSvRl/zDT0XOpRB1XzqGruRtpJDYJ+vPDK5zw/HIz8tcfWalRDW+omA6x8ntmYJg/WfFtRcpgnd82y8jQ6A1V/N7/9krmImZy4Z0CIoW03dD/dnpkScPHlyBu+SmSl8xpxRy+3OBnxqINLZWib3c1tkH4vtedqwq2OJ1lmIGHz3lz5N/gUMv69jWrcs6YK2yMiYocQ/sMq7Av6CdHZBD4KT5jSRUTry+9H8hL/ezK+fTK0BD/kxt+f0UjTVkF8+kX/ba6ae4a9CGZR5RWD9eVnJp5pHwK1XeJ3PbuHq9fYoLK3MxHUFEoCbZeVDopPP6Yi2fr80eN3EiGjcDq7k4Br1L1vpN6msRmchfPCmtJBco+Rjj1xhjWcJH/5vQWhB3pLyVPy4ogEa++ACcsrF1WzKfbksIfDJIBfxy9DmhVd+OBQ6c79QvxcOh1hvW/EIdD/okdXbSBn3bHm7bjoYH3+vqlsoa9sHo2THM47/mhGE5+JDMG3UwoWNR1Jlx7nB9YHtm2by7cZqTii1h/cbyO6JUOkISpwKYukBMbrg1+DuV+gHrlc75T5AJ+ndzE
 Znw0cZoc
 yLSOPU5IGJ3bQcZsOK7fh8Maun5oY/lyJ3600dXI83/cO9kmpcxPxUNYdPCNGJf6eiJLodD9GqaQ/XRFP36UggVFQSGnAmDZqi2H6mmf8Ovrs+g6Dm80g+8dNzkKTxAd4WkPySXQUfwGVb5o+ufq/m1BZWb/FxnqO2g56pel1p9TitJyM/oyicwDMs+H5LP1YCVvPuvReA8V0R1EO8B73y+mMu7KHzWmEJvMIDgs6WY3fmrnnyB6v9aughlAFrh0w2/QK3biWLP8CmIUJnRLIOdzpNn0Jxf5ORY6YlvxbpJri89chGQjzC0n5XO2sBLuTa7Xo93UYaiAEBXZ/YDcHws2d3rylROQNO7V4vsBZkTGEMbTiE/pbirsnyI7ShTXVnwIFb5uh3+AOuhap2nOoqrgGahNFGqMq8L4opVWFHkAE/baLOuoNwcbuBaVanHIi0o3zNyL+Ejh3avSk3lquS7oiuh6bgyjwsEyTpcAjjTsrdrSLFWs32z7ba3zgM68ou+o1ILay3hZoxS5WLgfR7GJEcguK6NdCMSPAb6VtUDGZvawbwN76iPuEwOAS8y0tNG6N/HfZA9waLfpEY9ftHpZs7b8oARk+2+ucEMjTVXAiyPjv+1V/TQL0skbBqSYvV8PEekZEjI62ixYKpWax0uNmI1v9fjb6Ovcu9SOpK6tYvSER5rNiT418dqIUCY3KV9w4RcfmTVyOrdyAIC+oIuVUn5bmMHKtWgNKrkyCSmDOne9wv+pBa647t3PZHIcfHUt+He6g80L5gaWVAoo02msm3yyYJv72iM+vSvrTnVJrm0dxV/l7ZQ6vrLmPwr9dO4drYigOAGb1r6lmXzid7Y0xyD8bdlKB7a6RMqc5pxxegg6WDLSwgOMW9Cd4PYVtYO8IJJMbkz+qT/8ZIKZNI7axFpfJUbMjtbjNgjDWIN3kL6/sMeliK3rcu0gAR3ZCnSeh
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

Changes from v4 [2]:
Patch 1:
- Changed vma_assert_locked() NOMMU implementation to assert ma->vm_mm is
  locked, per Sashiko
- Amended patch 1 changelog to include vma_start_read_locked() and
  lock_vma_under_rcu in NOMMU considerations section, per Lorenzo Stoakes
- Changed comments for stack_map_lock_vma(), per Matthew Wilcox
- Added early exit in lock_vma_under_rcu() for !CONFIG_MMU,
  per Lorenzo Stoakes
Patch 2:
- Updated changelog to explain the extra change making missing VMA
  handling consistent, per Carlos Llamas
Patch 3:
- Rewrote changelog to better represent the changes in the patch,
  per Matthew Wilcox
Patch 5:
- Fixed vma_start_read_unlocked() function name in the changelog,
  per Matthew Wilcox
All patches
- Added Acked-by and Reviewed-by, per Vlastimil Babka, Lorenzo Stoakes and
  Alice Ryhl
- Rebased over mm-unstable, per Lorenzo Stoakes

Applies cleanly over mm-unstable

[1] https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc=
.intel.com/
[2] https://lore.kernel.org/all/20260806200548.3124802-1-surenb@google.com/

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
 fs/proc/task_mmu.c                     | 93 -------------------------
 include/linux/mm.h                     | 12 ----
 include/linux/mm_types.h               |  8 +--
 include/linux/mmap_lock.h              | 94 +++++++++++---------------
 kernel/bpf/stackmap.c                  | 17 ++---
 kernel/bpf/task_iter.c                 |  2 +-
 kernel/fork.c                          |  2 -
 mm/Kconfig                             | 12 ----
 mm/Kconfig.debug                       |  1 -
 mm/debug.c                             |  4 --
 mm/init-mm.c                           |  2 -
 mm/memory.c                            |  2 -
 mm/mmap_lock.c                         | 61 ++++++++++-------
 mm/pagewalk.c                          |  2 -
 mm/rmap.c                              |  2 -
 mm/userfaultfd.c                       | 61 ++---------------
 net/ipv4/tcp.c                         | 31 +++------
 rust/kernel/mm.rs                      | 57 ++++++++++------
 tools/testing/vma/include/dup.h        |  5 +-
 tools/testing/vma/vma_internal.h       |  1 -
 31 files changed, 166 insertions(+), 395 deletions(-)


base-commit: 1029098ee3275ea5b78e329ce132262affa2f8cc
--=20
2.55.0.691.gc56d675ccc-goog


