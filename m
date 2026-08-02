Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D39C55174
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:55:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E4C6B008A; Sun,  2 Aug 2026 17:55:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DFEE6B0092; Sun,  2 Aug 2026 17:55:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D05C6B0093; Sun,  2 Aug 2026 17:55:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 100B56B008A
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:55:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9515E1A059B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:06 +0000 (UTC)
X-FDA: 85057685412.05.F237466
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf31.hostedemail.com (Postfix) with ESMTP id E2E2220007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:04 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GD3Hxjgg;
	spf=pass (imf31.hostedemail.com: domain of 3t7xvagYKCEo463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3t7xvagYKCEo463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=cmKFkPc8uWOvZ02aIzcS8pqwykgpBkJTCfqehw1k6ls=;
	b=TTMWkfVrA8ZNZhWnf1dtGkAN5gNzZH8JilYsY2AJFl7324EqFUrL/BWbC9OoyFbzc0pZSu
	Ou+JbgyHiEY3xlzQFCZOJDrJjoB8ttQswaGUEKX8XTIUh1DtFCFIgoZlXSYujWu7oLQZ+m
	hSoN5qSy5eUZC6gQy0PySM8ECWnU59s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GD3Hxjgg;
	spf=pass (imf31.hostedemail.com: domain of 3t7xvagYKCEo463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3t7xvagYKCEo463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707704;
	b=43YKP2j17CwGv4C6QFn4NgH3t0mfbvjI9mQMuruols8B8EtQV3mVqs8Y9zje27YVtxyK2k
	NYHuWilg7lrp6eASABHLp1dD4CukLeexw9qBzyCJZxLaL5k9GykiOs7gfoJvNrmERcrRX8
	InT8ikHRgpSaxcB9H26cuq9L+goMYKU=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cb5cc1e139bso1743843a12.3
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 14:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785707704; x=1786312504; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cmKFkPc8uWOvZ02aIzcS8pqwykgpBkJTCfqehw1k6ls=;
        b=GD3Hxjgg3KsLgC5pXemzeiEd/lhON/LWuGiiqD2I6kvNbaPAPt3elElX22ZPJRJPyR
         xevej8uFPDRqMOrTzEkKAyirSPeOlcs54HK8DedgFCA7QMgPFahAfJNNUf96e/GFynEF
         9HTB8NkiUAgvog6UXlwRcY02VCSxpJrZUd06xtN5AWl6pJT2RNW3NpCK3hr5/Fk5KRyF
         I9URZVbWO7a8SaJSncPUIXdPG0OgdopVwRcdnEHb1cjVVRWSFlbikmsdXiCugcd7NVoa
         nbEhMCkFsKuk9cfGllyzFzkXECJXLyPNle3gM4DkNYVsC2JRr+cHEdHXFk5HQ0ILLFCn
         8vNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785707704; x=1786312504;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cmKFkPc8uWOvZ02aIzcS8pqwykgpBkJTCfqehw1k6ls=;
        b=PtyG3L0ZtT03tKeeqHS+alNb4l1qAUqO4oEqivUeUfgXRzFqdCPqTctPmvQvnqyMQT
         6ELKZdb3aQ0iL3JaDyBJtSSxA5IRdi4AlHAvoEtIjSBDgV7asRzPC75mS3ybcJ+BqaMI
         G/0G+Y58Ku2XeRHkh5MAfsiPBNP5q3KpNSy2XIL5xkXuxSIcuXKS5w3NbIiE8gm5qZHb
         U4RedIvTL8pfATEMqI0xZ/iLFPGLDhtnvy/4Yw6xH9rq09VEq2JLrQ5fuKXdcM5Rtevn
         0DPie5MJWiFPAMLZjNlmmpn4+va+hW5FyDS6kr1R9XtU/tFZBWrlLn8PDJXgSBk/XUqD
         mdKw==
X-Forwarded-Encrypted: i=1; AHgh+RqwxDmvvEJPGTbuC7+TGCJPllL1BlcOw6m3FERUdZoRixIeNY2c72i4U6B8AF0tOOcd0T8nqNJggg==@kvack.org
X-Gm-Message-State: AOJu0YzzyqmwOM0FLeTa6IcSLwI6trv/InhNg19wqpXmqdVsoP5FulSf
	De3g2k7uuSkE8rXkyUq2vFB6WQkJEvOZV7V1djcDtWCajAXWz4eT2LQGSmnAuIRwJ4rbr6aIW6R
	hD/nKrA==
X-Received: from dlbvv7.prod.google.com ([2002:a05:7022:5f07:b0:139:fea6:ad4])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:310c:b0:3c0:9c19:65a0
 with SMTP id adf61e73a8af0-3c92a95b9damr7174685637.72.1785707703486; Sun, 02
 Aug 2026 14:55:03 -0700 (PDT)
Date: Sun,  2 Aug 2026 14:54:54 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260802215459.2769283-1-surenb@google.com>
Subject: [PATCH v3 0/5] mm: Unconditional per-VMA locks and cleanups
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E2E2220007
X-Stat-Signature: 78a9dio88caqj1ing5ck3j5s8osi5piy
X-HE-Tag: 1785707704-965142
X-HE-Meta: U2FsdGVkX1+k2i+TX/XrgOn4jS8KMj+6YPDHxK3FGBt0vvmgw0Fq/Xydm9ltJko47n4vciTeTjIG8v/TQeUmm2DT829gLK2GgqBkXeM5jfQ9LsVSyZRYbn6CLIPqscvd0lHdKUQRHu4DwpXEucAoRx1njMzMgSfNZkCo9nsXCSm3XpJBPyrzm8llFiRO5v+/15kQd7R++Aiziro5z9/SrCwuZt6V9dl2VMyy/Xaq7EfASbeCT8Nvf4mVvG/ZInKsPzxYQkjPms07Nx2weWRANcPzb/LGjAVAtMbUEoOMaxfsbeQPEUyhVDc/v7R0f875uLnWsJcuGax5zYL8kjWva9UqoFbwhFAxAbqOV6rQToluxR521RqZptWEhI/Yh0FSLhhqQbmGlxIWLvE195Pj9m1ITwL0PyG976bMA3zWh8cCdAQis1ZUj8oUjQ3t0om/RCQMtK/+bhIV+nt3H8b2Iiya8NVm6BOlo4PcJS4ckhPC6Qz436VVBOqH/kGqjWqLp+FgEkGOFG0kABipCDVaX/3N5Hug0TE9C8xiZg3T5LaRf0vf4ws4UFbXdKrql/KOI9SkY8Xs0E1ZGdL2fRjZI0TfupU+Am2jXxSGF6iLU5xlzigkuB/bch9QIweHf6cgRuyVazWikxEmGsv+T8VEWLpIzERMDooBbXZ6wF2OoQCbaQD3J1eT070YdEwSXpYdffD22XdJNlIFEccSWtBMPPWcpdVuCe720oNG8W5OJJuOVpt6kc42Pr+uF29HuSRcjDwcX/68JC1AzIcnz3gl2wSjbA9WT+oqPLsd0lI+qrq+PQCVNFx1g5FDM5BhDAwrPNXw+o8FpxUBP43pT+ITMyCIZ+mXxnboL4INbp4qMw624rBzgq38vSVDylOj3+Ea0WhW8zUd5IEqqeMWYqnPnklKwChfqEajBAz2D7wXw5UYvjJuBDcy65L+JfuCCl4Yld3mZvtz76qt2xG35Fk
 sVvc5Zs4
 qZiTYtsLxnkzmJXSRcPKjC+hk3DNDT/WkJs5r9teOJjx3UcEtmcGme4ui4cFWXW0qB8b6okrL+vW4tyFLooW68erFhA7LajNv5ornailgXeKgMwSPV+/Ao+h/82LyUYbyQsK0UKe2lnD4nq1MCHxsPngghp9nR/c2RQN6ucBSffXEfY19CagsYeuLSQ4VJQLKcmxTFjlx9PnSF1Grm5QqIcAS6FTQAfRuh3iKZEGs5/GDS81HSZFUMGW9FWvtTE2GuGh+Fq8M+ULmkvzr7yoBh6nkKgnEnrVW+CpUIZE4hDdbCu0Jj+l7xlrxTovsjWCiwjHdgnRdRIHin8Lp2iYSzDvnCFwEZa7piKbJYEo8f0bgVgz4oLH0xvzPviJxLINvVVY/fZ40h/oc2r91QuFc3rNg/0s51deT27bicGbIyO8PPcl3jp5OOtah3xd8KuFPZOWo4uNNRm0JCu5I5lJctoGK9W+BsOYGeLDRxkh+LwaSXebO+dKIo2mHCQZAcpKJEQ8a4XH8MwbWiqjmeW3GTA256OFH5B127nG7jMTDK8l/V3oc4+LR0viLCvUx7Gwd7b62EAqiNXiMyHBYvChnUZRpqMrSvff34XNQNR0ZDOFcBVR7cnfeO1ekrnHGW88c1ZvLcmW2dOIyZ5f3l9+mU7f4Wn6pPINbr1XOfT3fqQ6N2TEMjHdEPWmW2x5uy+R7OTXyP8y2rbIrpZmMls3KKSgkbSyRHbB5U6NL22TolC4cmrojzA9m8uQ/W3STIbtrTYWb3A/w/xev+KI3N/FDYjZHJ5qroGK9LsfRxN+z2oHfXvKoXBUwAoHs9/vmEvRXL3X+JeVzpoJqDLwADAD1uia/PlDt3Jc7jvoNg9V67SWkYHdHqO0H99+f0mhfWmZNIcOQNUkShkCNIovOJZvT3tgDpz2SiHphEk/FfAiE+tvje9f9totgmwWk/+UeATqAHjmU
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

Changes from v2 [1]:
Patch 1
- Removed new CONFIG_PER_VMA_LOCK usage in kernel/bpf/stackmap.c
- Modified lock_vma_under_rcu Rust implementation, per Alice Ryhl
Patch 2
- Added binder_alloc_is_mapped() check to allow page freeing if the vma is
unmapped, per Alice Ryhl and Carlos Llamas
- Removed earlier Reviewed-by's and Acked-by's
Patch 3
- Modified comments for vma_start_read_locked_nested(),
vma_start_read_locked() and uffd_lock_vma(), per Vlastimil Babka
- Updated vma_start_read_unlocked() to call vma_lookup(), per Dave Hansen
- Added a check for VMA to be valid before calling
vma_start_read_locked(), per Vlastimil Babka
- Replaced guard with mmap_read_lock/mmap_read_unlock
- Modified the comment to indicate mmap_locking is temporary,
per Vlastimil Babka
Patch 4
- Removed earlier Reviewed-by's and Acked-by's
- Added Rust version of vma_start_read_unlocked() and used it in Rust
version of the binder driver, per Alice Ryhl
Patch 5
- Replaced lock_vma_under_rcu_wait() with vma_start_read_unlocked() in the
changelog, per Vlastimil Babka

Applies cleanly over mm-unstable

[1] https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc=
.intel.com/

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
 drivers/android/binder_alloc.c         | 46 ++++++-------
 fs/proc/internal.h                     |  2 -
 fs/proc/task_mmu.c                     | 93 --------------------------
 include/linux/mm.h                     | 12 ----
 include/linux/mm_types.h               |  8 +--
 include/linux/mmap_lock.h              | 65 +++---------------
 kernel/bpf/stackmap.c                  | 16 +----
 kernel/bpf/task_iter.c                 |  5 --
 kernel/fork.c                          |  2 -
 mm/Kconfig                             | 13 ----
 mm/Kconfig.debug                       |  1 -
 mm/debug.c                             |  4 --
 mm/init-mm.c                           |  2 -
 mm/memory.c                            |  2 -
 mm/mmap_lock.c                         | 53 ++++++++-------
 mm/pagewalk.c                          |  2 -
 mm/rmap.c                              |  2 -
 mm/userfaultfd.c                       | 61 ++---------------
 net/ipv4/tcp.c                         | 31 +++------
 rust/kernel/mm.rs                      | 38 +++++++----
 tools/testing/vma/include/dup.h        |  5 +-
 tools/testing/vma/vma_internal.h       |  1 -
 31 files changed, 106 insertions(+), 386 deletions(-)


base-commit: 94f9b3980dd446b56acf1dfed649e9b32a9f3813
--=20
2.55.0.508.g3f0d502094-goog


