Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E7E0C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBAAA6B008C; Mon, 31 Aug 2026 16:31:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B439D6B0092; Mon, 31 Aug 2026 16:31:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0BC16B0095; Mon, 31 Aug 2026 16:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 744CF6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:31:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 32BFC4024E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:04 +0000 (UTC)
X-FDA: 85162708848.07.1FA6BE9
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8071EA000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:02 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qYqxxa2r;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3hOSVagYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3hOSVagYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788208262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HdPoO1BmhDpKCIht74EVe5TolJMRKRIfbTssD9lBUXc=;
	b=2pfp3g0MwPh2cu0ULxCVTaD2Wezs3UfjCBOZZw80mZIfFCsYbNADelns5grAU/ZsVFCcnc
	jIRK9n6v9cxdZEjkMCOTDvMeyVJMwiaOddab14fGANQRd14UV985UG2Ch0nqjg5EVMDuM9
	wf8SH00xDawbHANZqEzF3rI24H7xeYQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qYqxxa2r;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of 3hOSVagYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=3hOSVagYKCAEtvsfochpphmf.dpnmjovy-nnlwbdl.psh@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788208262;
	b=tacILtC9/FPZ3OKPIuHsS5XNBbsIVDsFsIhCGr87rcHnNx7xze7p+NO+H2IaWTDDxOJy8W
	B777EnKSbNzK7Lh0FkV8rjU5qg22FxfHsNpCaxynrFS069LQLP0TAjr8CBb2e16aFSD/uH
	W5syd/TKtq+rYbygP2U2sSQaljn89P0=
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-385d2703b64so269439a91.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:31:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788208261; x=1788813061; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HdPoO1BmhDpKCIht74EVe5TolJMRKRIfbTssD9lBUXc=;
        b=qYqxxa2rj/+cH9/gUCsuCAefxyQdWVhsoUXIxgDUwj1ZYR/G/bmwGViiAd/XqBR2Nz
         XjlhUz89m0Atf2ZgiIVJBzy1fsYr2bUHtGeK3Wdi6He42cfgUUH/rAVTPYKNEWmxCG9B
         6xSRs0eQ8yc+8Vbvckl5yczeAmpsshWTrwg9FSrvFw3MBqBe9MU2UI/DcFjNKCimrA6z
         VaMEicSqCALY8OQ0PkO4IDnN7q4bzIDHVDMnh4y7hJuVjD3FIatsQSPL4fFESekp5VGm
         aGc+OIGQkWM5Krox+KKzNd0kynUA6CKJmY+5QQHMJtys/UovGqoZGwhE4pmSfLcBV53E
         pGpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788208261; x=1788813061;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:mime-version:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HdPoO1BmhDpKCIht74EVe5TolJMRKRIfbTssD9lBUXc=;
        b=QQ7GwJaiz2Y0da1UrgE7XsDFgmgcDmQhdZJ6A6bP8CVyWVDj1XkUwYQ9Dc1jlKy/YP
         uGpkNCbzSbeYZ7eITfwr3HnBhJDSQKdHVJizNAqDgTewFtSc+o9UzSnuS7pbErz2nmom
         iiDbo5syl7i1IX+y8wFYQI5Dyrrf3pmHMH9B1vXCzpdMhx6b1AgokdLudDDVynyxc7vl
         hbdmOHcr3dPd4kQfzfC7BxbqUscUcT3/XzFYrMLkGYqOVwLsYqXa+OqeOl5QL9Znjb41
         3dgfTbykqAdBlLwhrOguwzQPueXnEoopD0jnzTRsl9cugGh5y7tYjDAjZAIPjo/aowEj
         95dQ==
X-Forwarded-Encrypted: i=1; AKwUvBybwOYBKa8wikKMk+QCTDRpcPlvQzati/VvSQTyGzrJx0m5BIencHLgOR9BX97jdK48nnfyAIFq+w==@kvack.org
X-Gm-Message-State: AFuF++nRftc1/YZPJiEK+CiYtaSjZR4i/ZHvX0tOiyRbmPSJiBP8pYj1
	CpaDFSiWl/A3qixvjhDiXGGH+eUUw/nDkEKMbUl0QQds32UhqmpvjxjDppKuWQnMYY8OOMSakdD
	b+RzhSg==
X-Received: from dlbvv7.prod.google.com ([2002:a05:7022:5f07:b0:140:f5a8:30ec])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:17c6:b0:398:c6e1:dceb
 with SMTP id 98e67ed59e1d1-3990f757be8mr597806a91.9.1788208260811; Mon, 31
 Aug 2026 13:31:00 -0700 (PDT)
Date: Mon, 31 Aug 2026 13:30:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260831203056.838265-1-surenb@google.com>
Subject: [PATCH v7 0/5] mm: Unconditional per-VMA locks and cleanups
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
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 17tjhz786a9bbc5gedzmdszdn466k3be
X-Rspamd-Queue-Id: 8071EA000A
X-HE-Tag: 1788208262-741323
X-HE-Meta: U2FsdGVkX18Z5wz7lKHkZAOkGGJhDXHe+cilpktsLFLkyajmlyk3/4R5S6XQ1GA6CTXl8MNK60J7GxCbWNf5wo4Zf65YMaXsB8y3dXFr12OcOCB44ZBU7LSsvSDKDKdG1ZseTHySwCxZcbGnZadwZl7hbwcJ4Md/2qLeUrlVSNhRe0ZP9hoy6wDT74mHH9F7WoJsI1WMDl7j5FXOKEFMys3ivDhR7aRW5T1hzCKc31/br9X6325KrLAv1q9MeciNtqHHDmn1aYTay/+g8wdRkF7p75NfHuZCKZriNJKlDMKTInObIgkl6JG5LzQ2m2bIopA/L6IhRDs/TgkB5mkGntz0nngDYkxuRsg7jyMh+EcHDxhtghtupaYYFcvczgGeII28T3JaC0mg901TxAv9uUp9TVd7/oS2Yb9OmIEUKp5NW4HjK0+oRN3i8lOfvhculz+rhKbv94XIh1yUyxGY3TYoSD7cY1/7raGykdd6Jcv+LOLvXoA0xJZM3nD16HZa8IEozugo1RDl4wdTMhU4rokD6reeGr6p71WgtOCtjgRyTWM7vV96ZU4WtNh8JU20dO0wN98dYQgRLLu3kWI/zqgyldFn2hyX6fRli7rnli+BUMZFpht5KiMutSmLNB+lja1vygoyshq8TZjVoEnlSUbVD4K8KZS7v/3IGUVcABgyC+BsVevn0fraFPngVR8MM2f5hiJlJg3omsoCybQ8PPeFVJI6HTPJqVnlQSPig/Uq4dwYyCmBwXtclhKAmrdMbDlGnqNzK1gvEnepsizK9fnlDus0tV5HBQ9LHSL7uHYAkUt0jLOxDK1UdFjeXLRt0BSe3r+KeVYElaqj9kGA/oxArNjxEe6823OB0GUu1daCghcByvakGJ6UOnWCpAE+vEH1CvrsOSwynSpA9ZZKpTFvvP9X8yLFj4+qra6LLjs7JDy9zuQsDjenxAxZuFDZVG49SUX/WXzyMPsV/xE
 Loygi/0w
 NFcxU6tZm1nx+iAfi+L2LaSbS2cXArFiPx5bJ706R3UWlrjqfA/S7uWU6p4fDDKc5xVgSka+rQQKuuleL0x/O1sD1C2gd9y1jQlWrcT2Cp1Aw8EG1vsjDvyegHaI6cYYI6kAoTIkq3mANKzaYiBIQh/k/OSnDJX1c5s2lHhpDuV8V7vLzytscCkg9IDyot4MO0f8wP/LCFZ7xR9pVGn1oyy2AJw+CTvYzINzYKb3Wi8L1TBLBGQurGe4/vOGJQTK5Ux25bpf/CeUlq8rL9NlttS0OfCqw8GfgnGzLvcJCkLNXr8t8fv4nBYU38gqHo7bNJ3V6/Yo4iVl6xBUh0mQ2ar0waG9bdlHbI1JK/MzOi5gQ6OpPGUHvCClaj1d9yAz+TQIpl4rmTmgV7ecgGZXzWvmafjqKRM46odSl5zR7d2YhBc4SeWa4Ux5hmlZaM3GMHutFP5vCCfIwjUQoW9xiugY+5VuJYKIdiw4IlwcaBg1JCIaLvfDbR/VOVyZWcxy9t1tVFU0aGFGB+NXvYIAOI6z6S67RLw5cuI/u5eVssd/FflNC5wrjfYrxqmDYcb8has1715wJvSxv+nBt9F2PjMTmgfEiroHSn1s0OV7k7r02qMbjSerWRldZaqOXVVNu1+NbO4PL5zSCG/3LFySS75Pq29fsAdTc/opgraU0vv9LLlTqk6jX7UoaC9jY1ALJSbMxI7NV6Znc6wdcucS8tK8Nl7aip/qEN25dSpViiegbusQC745vLbJglaVM+qXilISO9GYizJlQO4f+dWEt7whg0tvXYfUQK0Piv/PZxsQmjJ3ddU9E/1879roJxXrUqNE0w9dOaIQeujBDsXg3yAIOANCJBp1n6NUpoR4/SvB+21a3JXQqpE2mivml5lUruLEjLYJnHwNS/NPiQexuKzj8NgDwW++Flub7z4FEVxNGGf82Q+QIG5mbFF5VABs5fpXZ
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

Changes since v6 [2]:
- Rebased over mm-unstable
Patch 1:
- Added Reviewed-by, per Lorenzo Stoakes
Patch 2:
- Added Acked-by, per Carlos Llamas
Patch 4:
- Added INVARIANT comment, per Sashiko and Alice Ryhl

Applies cleanly over mm-unstable

[1] https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc=
.intel.com/
[2] https://lore.kernel.org/all/20260813193433.3318288-1-surenb@google.com/

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
 rust/kernel/mm.rs                      | 58 ++++++++++------
 tools/testing/vma/include/dup.h        |  5 +-
 tools/testing/vma/vma_internal.h       |  1 -
 31 files changed, 167 insertions(+), 396 deletions(-)


base-commit: 42d64d4fef83a241c919c8693fdf0a21b2cb6061
--=20
2.55.0.966.g6673acef38-goog


