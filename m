Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9321C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EE6F6B05A8; Thu, 13 Aug 2026 15:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A7156B05A9; Thu, 13 Aug 2026 15:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BE696B05AA; Thu, 13 Aug 2026 15:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC43F6B05A8
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:34:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 85F26160157
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:40 +0000 (UTC)
X-FDA: 85097248320.11.57F40B8
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by imf16.hostedemail.com (Postfix) with ESMTP id D08D4180009
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="KLK/ernj";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3TRx-agYKCNgMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3TRx-agYKCNgMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=myMALrPmiftJzuMGzKXuNexYM0KxETCacC1JofGVCac=;
	b=Z8CrHrATPzpfXRbXn4ul8dmseyXEouV8OQwe+5jhlYRGZoa1nS5cvy0wURBq8J0CfUVu0a
	3yyV0WM5JQbGkAUNlbZqGfLTriXZt058Y0Yky9AghFJjiADkdYNr66Or63Dv20hA3vN+O1
	r/QMjwqlkKriCEoLQ8CBxZxOpCRGV6Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="KLK/ernj";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3TRx-agYKCNgMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 209.85.216.71 as permitted sender) smtp.mailfrom=3TRx-agYKCNgMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649678;
	b=ckyxW7MvBD8EJHoZM2zYCH7SOGM37tSJ9skso2PXsKDQbjrNweaTApH0g7IHAXXMoIlMx+
	N47APS7VIR3uO+JMQjqqUF648qgTRYYIx+fCcjL/lfiUGU47+aMwBIjNguXTHhos709H3s
	DnJW7fc5EZtRl8QKOAIZL/zCfxrXaUE=
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-392cf18db8eso280023a91.3
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649678; x=1787254478; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=myMALrPmiftJzuMGzKXuNexYM0KxETCacC1JofGVCac=;
        b=KLK/ernjkzFEdGfQlVCySh5f9HF7jUnO4JaqBBs/i7jQIlTaU7dGdnPU9RagK+UQRX
         0u8fENuS34VQsefXu3J84FbPy8qxTau8TFvp4gmgPMHmTXR02scQyq/jZW2llCRfy1QA
         tPXLaIszB/fhhrshDDaoc/0L0c9lRWHFBkP3HY5wGOOwpOWDiKI5lltHR86+vwuBAZri
         7TLKgZPANc9XWiaQair+jdAHHdkFDmfhLeIU4wkb0pl6MptrFkzSFsYYZTL46eUO3fTy
         aEZiMrh4zWypxB1LpAM91cpA+iVycKSrx+vVrQsABI2aeOQjlRjZV4K9tmtF8YnkPwwZ
         qbNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649678; x=1787254478;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=myMALrPmiftJzuMGzKXuNexYM0KxETCacC1JofGVCac=;
        b=Ct30DEoIOqF2iPYxgt8FuY6VEB/v0DHFtanK3rOHwATP6tA/lfhek0lZAyRv+3nVcs
         A8rCqvhc0MG4FSjQo00RvbtLZkzLDl2jD5Y83maw1OkHLWJyt5ORD2PkvmgKLUvWRBcZ
         AZMdwJVh2hUj7iAAcFlPv/unVt0rtc3YmLYqJa7DteYki/tz6DQphmtkn5I816Iv92Tc
         riAvDEXzxjjMdp160BoacPAItjpsWLLzJmShVPjGu1bhWKKpfssaKieSrQ9XlFMKWBSA
         Qn0FtBouWeMDG5whMbqKJ0ruPWXM11JNwPGTZKFuOfWRnwWBlDprhB8pM/dSDYdVYI4I
         nSOQ==
X-Forwarded-Encrypted: i=1; AHgh+RpM+d8FMCzfXte4ypLPlFF6Pu6QH08jX8wzYJq//xDV4fCJcTm5OG69JSu8KFyBe/OhirOz8AFhVQ==@kvack.org
X-Gm-Message-State: AOJu0YwMmkl7VFxH1SzbeMwGyHnGLwfj9TFyajHWyzqQLHvcXp/Qii6s
	EFtCt/i2RW0CiVApcdpkFcam0Vz9uZsgeS1jW6Kk6N3OQ/q94EElDDk4xCfURG8uqDST1wD9lYQ
	S+Ewfdw==
X-Received: from dybvt10.prod.google.com ([2002:a05:7301:78ca:b0:313:d014:d248])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4b90:b0:37f:e177:f58
 with SMTP id 98e67ed59e1d1-3933b874ba2mr305120a91.9.1786649677316; Thu, 13
 Aug 2026 12:34:37 -0700 (PDT)
Date: Thu, 13 Aug 2026 12:34:28 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260813193433.3318288-1-surenb@google.com>
Subject: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
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
X-Rspamd-Queue-Id: D08D4180009
X-Rspamd-Server: rspam07
X-Stat-Signature: kmqu5i8qz9fbco47fiy1z116q1fc1gd6
X-HE-Tag: 1786649678-690205
X-HE-Meta: U2FsdGVkX19syGnabq4/cWjolZigsbprggAUl6BaFKSt6DhWK4S7bRKynnLpXzvmDwTfi+SxhnyApeqTZZqIKrBov7pLi2ovN950gyS7Wn3vUJAC4fTq2Dtsn5PLK9aGYumEeqc5fd7mamyn3p4fPwZGS7qsq8OpPbElL10mnSmKDedp8Cekt+Oa6h89TNm5Ig4SG+ZW+4CMlbq6ExOkad9Da1Lxd3GulH0v3k5bfNaMOribhDedUeZU0mFmA9W0zXtViNoG6vy9BoWwMWmfftUImHnGXsNNKyiYfZk2RWwkR4Fb5xYbxRf0RPgaXjJxt9zgkD4oWHOy77UuspgJtlxEpTWma6LPfRfKJ/9fAlp3efwSLzyoQxcFUK61P89A0QGc1Jv2XoGLK3hrZHyi6UwXqbKO5Rit3H22MsxBgUkq09C6k2XT5RiLgfn133BFA/qAkceNgWnPAw7RXw0po4bomtct5NWuoLXw2zEUGNsY/gDxYofNoDqz8qBL7EPgShhxwTt2iK4olJHYbSgC0M679jfu8ufp9QFxh4Oj+EkT93SEGUqHf8jlLPwSxMdHSMG9JlMH6yyS+MiqYZrEO8wpgY+AxvSVM6XfNgBx3/CtLIQsvytvS+IS343nbuxGvfoFew2Hez+y6IrVt7MiUZ+AKf9QBa4OhZ9HU6nfqwIVgKdGagxBmGjuACR5WmU0mHo4wRv09nuCXTYwEv3PYcI8g332r8PTb5w/McrudBLLtx+KZ+VsPcpvMULCAApBQLbWEqKXBUV6omLkDcFwGBsTs7JeF9Ryf851YoTq0kmZHPT3kp35nVO9QTpps4Pkqrzf53Xi5CTLGis2u9NaEK78/vJ69eDfUVyIwK0Dzi+NoR9Aq5ujBepUjPF4QvZHdIn0j4AysbFV//U8XQAU8b/YuCH+dJ9cPqmvgcHcRvwTDJoqzq6MzslLVaDDJ2OCJVFhjkXFXkACDH8tDsl
 TYgy4kbW
 8OZwROZvENpuMoc/AS9wXWwAUIMAshXTYH0htY0NjaOGjEV79GsWebWrgPR+UbIGumJVFx1Cqn4wwOxq1K2WpfjgAKQsFwbdJGh5ZUkW+6Cvxmmvxg5Dlh4T242F/tbdsKur4XZnmJ6C7/JGqEoiE2Ghu76BNlRGuW1YGySRUIPe9e0eAH1+cWSlwWGCqqHZ2M9NQMm6uMFFprXIUVzin906pbB+1owTmvxmc0gkumxhuCfbdhXJKxD/vEAytvij7h6h4LhtYBHyPGWXPMpHaIGAOfHmWQmBr7Hd2nl851OM6W0V0L/AGdy/NdXZYxherO49r0QepEKk4d9g+kNbO+ONiktKyiJ4c3CcDpuxNiLL9I34t6N7zxNpOjZTvBHEuRH6nHHr6OEVqthYz6KtZd4qlYU1fWuyWEb3cdgDpVvT9mjjYk66zzCAXcIBR5x2xstzFbq8PEU/3bzT3CZiQACaAdc/JS2YEnOuHrSBeQztfS1qwF7Rv9Jpn0xvAxfNCYWHULgb6jtRmicBlSk9O9JK5Ff/PkNtl6/ZQ8Pfcmwni7M3io3/+j16Af/2xMaWBvBnfn/tjk7YZwHuNPKdHc19eYq+Aj9u0+nXA/7s0ehXkST71KwN0GL3uiIYW84VoizEpvDyPvr16mmpx7fcFCqlQ2RjtReOsrgijx9NVynmoUIpLk6BKuVb7cOrufElCR+W29jrgOa3pMV7KqeRSh7dc0wrA0QzUbVkZ4ADeo12mxOathu6tu1cJ/QfJm6hoLzxWAMKRXNnMkVDK5QF780GjgrOuVY71+xCrLwcZga9k3xPo7Cg1937tqX1jHWIjQSLON4oUdZ4DkiiixoKQGckTULu7iNHgfgyQkjv4DVd4qPHpgwVsL6yXuU87tMVyJ8KH8bZQ22JJw0Yt3kq9uqCplsrBN/+A8PZnfONrr4ZoNtFFxWQ7hx365haATvArOEdE
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

Changes since v5 [2]:
Patch 2:
- Removed dead code, per  Alice Ryhl
- Rebased over mm-unstable

Applies cleanly over mm-unstable

[1] https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc=
.intel.com/
[2] https://lore.kernel.org/all/20260812011056.902771-1-surenb@google.com/

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
 drivers/android/binder_alloc.c         | 63 +++++++----------
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
 31 files changed, 166 insertions(+), 396 deletions(-)


base-commit: f9ca2fa9ef7e9b39ec79a0596929d1a1f8704c5f
--=20
2.55.0.691.gc56d675ccc-goog


