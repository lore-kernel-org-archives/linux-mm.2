Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC60ECD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 00:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DBFA6B0088; Wed, 13 May 2026 20:54:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B3346B008A; Wed, 13 May 2026 20:54:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F1076B008C; Wed, 13 May 2026 20:54:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00EEC6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 20:54:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91F188D49B
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:54:52 +0000 (UTC)
X-FDA: 84764205624.25.7421359
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id DBD6B80003
	for <linux-mm@kvack.org>; Thu, 14 May 2026 00:54:50 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m37dSEKl;
	spf=pass (imf02.hostedemail.com: domain of michael.bommarito@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=michael.bommarito@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778720090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=O0HH69l0JaFi4hHvraUko+G+U6R9D6gJaVlDkjn8xUM=;
	b=CXnrZXtuF9zlApGHVGyDVN9kFIWfALgoo1L7sokgA/DmtIBtQ4Up4oXBrpr9D/Vv9sS1sU
	Vc8V18plL3+vFbQeaC7LVY91bxsKFahxyV6iGkNTv9AVeco+GTd3cgETfN0qBgDMXX1URu
	mJfkkWUv9EGU+nK1rZ/gJulRbuxrNto=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m37dSEKl;
	spf=pass (imf02.hostedemail.com: domain of michael.bommarito@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=michael.bommarito@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778720090; a=rsa-sha256;
	cv=none;
	b=MGDtqAPqhV+dtvdCekjmdlC5GyPX/FvBak8hepSAEj7dmt8coxoG4uNSGsG9ivKCjxHiBY
	GCF1hNYqSRRZCB25guAq0fgzr/apPmaEDCh0SPhCMlN1zANgA7JMQUUuJNTlPnj6jpwhpX
	KQF5okZ7ZRVbrWLIoWVrKfC0Vj/2c50=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-8b6ea7716bfso81387216d6.0
        for <linux-mm@kvack.org>; Wed, 13 May 2026 17:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778720090; x=1779324890; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=O0HH69l0JaFi4hHvraUko+G+U6R9D6gJaVlDkjn8xUM=;
        b=m37dSEKl7128q1ic8RR32yWKosfSp77c2MGLUu/XqPmq5P81k4w0GkDtsDnl/Pe0SZ
         LDqyQLtYYzzj68TQHEJu14WPcJs67Dchvo2ukeEAgmGOBTJXnOdLBoo/4JHyaaNp9Kzd
         jkrJYnML4favvP0QG8IVevgVthAZvJNYfiG2Sp1K1GoBqLQsldJfRHqEUfXWSll/iqT/
         pcG0fYpOD2xB+QZD89elRe4+zS5oJr0YYmKjqBajotZD47CYo6sT0WGl1ZjAPe4+KBuu
         NxQrxM7OhhYjExEOewDDLuZCP3u59/5CD1b5W3q+9E/95nGLEfQ83rLmEYsfoloiAQRr
         3l2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778720090; x=1779324890;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=O0HH69l0JaFi4hHvraUko+G+U6R9D6gJaVlDkjn8xUM=;
        b=qzhix2iSCjeYuBQXUBts7EzCrn00VPwgwpwXomLRRnW00gbl06pm2gBLiaOA9dby43
         rgCJYXilq2DEANZy8/5xM61Bz7m/io83LR8uUjnzuzsqyxVP+A6wjpZNSw8KoXROcILH
         I9GykyNMblfy6O/vy98dj1MJjcc1sgjaa7KRrE8VnCnhRB+mEORQT0JS82zWV/ts1Q5N
         LGHIT0QhK+UB6D0aYnN25TSIBuhH/fU28UjO93PuEfPDcGOGH4o11UwaOTt8Bea76TXQ
         eONxOhCi1KxH+aMGQSfPYkqELsTM3H1akaZ2M9BQK4cZ9egVHfpy2DgeeLxijRM5OOY/
         PPDw==
X-Forwarded-Encrypted: i=1; AFNElJ9mcD9EnqdzcPVJy1AuR1JqFur2Z6PmqyfY5DxjeNaEwhCDPEl9Bv0ATCLGR6PrVP26nkk7W/gqbw==@kvack.org
X-Gm-Message-State: AOJu0YyZOooaF9VZ6u50y2C19SncaPrma9PP+IaIyv0x5fFleJk7x4U8
	eyy0m6Wyv6lWiRk3NLX0n4DQw/9nrpMoGI3FncwCe3+k9hxAqTWbYJE3
X-Gm-Gg: Acq92OHMXdHd5xEZcfWqC503DkChiWmIdGbaH1mIEbSBDTlfg8Fa3hjHbR2nl0FxE5R
	A/txZzHn4ETQ8+DSToyu5m9hruuEJKBVQ3f+sOKYM9bWv7j1GFy5s750Co6tmmTVzhnDVhzLbTf
	pxeodZ1UeGGg+0sBXpe+sy4VBBa8YLQNRZWqgyDY2U4Daf1xlsXdEqgRnx9B+emifc+meHdjamI
	/Rijgm5hX22QHC+O9ugynLUiJ1vvlGjplqcRkHy6IzWsrgKb4+/HcBigAr/oj4IOCHUGiFX4lqk
	FAFQKBAdG2qXsUe4vCB3TbbvkEeFQLQWSB1pmRiA9j1YP0+olNnPH5bdbZCXac/hN/NWInuWfo7
	AjjtrvS6miWzcLTMdxWH9yfr4ReQe1kgpxwmTzeP4yLd6JoOOr9eMCpx1ajVjz9xTQC4eaZiTGi
	Vxynh/8D5lvao25jcNFVXA4TlaCPtp8LR6woJSe1tX87sOX+bZLB3xEpUTuft/hG8mHJPSvzuh2
	At7hGLrRr44zsryHRUKYACmZJaJeKqAkBPah6b8IrZ0pFYYbsXXbQ==
X-Received: by 2002:a0c:f10e:0:b0:8b3:fb6a:d35d with SMTP id 6a1803df08f44-8c7bc917691mr74116826d6.47.1778720089931;
        Wed, 13 May 2026 17:54:49 -0700 (PDT)
Received: from server0.tail6e7dd.ts.net (c-68-48-65-54.hsd1.mi.comcast.net. [68.48.65.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8c908e11929sm10399986d6.14.2026.05.13.17.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 17:54:49 -0700 (PDT)
From: Michael Bommarito <michael.bommarito@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>
Cc: David Carlier <devnexen@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] mm/userfaultfd: fix UFFDIO_COPY retry private/shared VMA panic
Date: Wed, 13 May 2026 20:54:39 -0400
Message-ID: <20260514005440.3361406-1-michael.bommarito@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DBD6B80003
X-Rspam-User: 
X-Stat-Signature: 69zh4sp1ajgy3nez1ut3zwp5x9x7qos6
X-HE-Tag: 1778720090-279524
X-HE-Meta: U2FsdGVkX1+elnhZ6XtFpHluion75pD05bn1wyI4krZp1qN8KO4tT4X2fizRl3BUqTZwR8Bxoeb9ic7lMaxzEZ+S2HpJSbKHXjiz8lFrBk9U0bel+U69FdF/NtCJgmKdsszEQLpqUvrOz1IE7hybtvopAbBGknR8OyQ2EMfbMZqZJiC5xB1JVN/pOBpnLEk0L2HyQgD6ITc79udqVrDIw24Lft4efuH8gnWUjcG3H2uk5obtGNkbstSnr4U0BmXkHfsffJAJLL7JDmVQZe1sRfZNlZNzAoEzD4dxmuCENn+5OhGHotrAf144IYw0ZG+oWwVWZYat7s13+v/frWjGTH4Mu/r9Mgpvtqw9CDCEyQqzpa0ypHVdsTUVPVambv/Xdw1BTr7Vjom462RSbWIOJOxF/IeY7FkC5tF5N8OykkWzRsg+rJ5xwvxbtrK5l44uFyixEqXkAUX03nPHjNu/I8AvvxJ26PoD86PbYBayRTQrPLUNDkf5KPbtO3E1WhZdrOHxPi5kjSaxw1T4OD9pbK99ED4nBrQtGS8ATG7fdD8PuzDX7vYBDw7q8nTpZW8zTwrFRzzqLN/5xkKUJwwazMdDqy9csgf7EBFE8RIADXzES3Jvgf1FNM5VOB0mLEve6QIBZuFMTsGf47C5jt5jBLDakoHCdoYvSuwHP7e4XDJ0ISK083YBI1nH57OwdGPm0CXN+XK+T1UYUbaqjLtUrmdhkAVsu3JSaZvWSBbPrFJ40D69YYVQmGpDKGayBffIkJZWMjBbUwsey9RVGy/Mz9BNtMp4X+sO+/wP+mhjoT1CT74gvxONNArKoLpQ5Cdz7rfqTHY6HZnXhq183eSUDFtCiKfuJxc64vLtSto2KW4Be7tP1mbETe26wDYV6bWXEANUTk5Y+Su3LI9OWzimHPIRZXHd5skm+zfrFTVckg/KZMLXmcpcL9izViHVyfbDfayizBtHjdgwAkfgCSG
 nscgmgk7
 u4TVs01Bdf3Xf5Wl3FCEVkZ0p6KezuCyBUNPGuIeNR5xBx0CnSoWbuClcMUqGrcXz4QkIEMBfo8OdMOvf39A39E5F0LecW23+Jxs9wDppWx4/8jwxeWzinVnCz8cR6rKxaQ3vvoNAzJPIiQ6midyG71bjQzB0lXyVYK7pIsEK7ncJ1s8iHEG+ucSKmUBVd5Mu1q2+ABqWz1YxOb3+SdaCLRJtXb+U/Z1INLqryCVb5szVDCxqCIzRa3OS6aU4uxk74BFBCk0MjyvvMPwChZiKHyFlADKGYM70DqVF1bqEE6yinekpepgt0ncGeXnnc9rLbdqx55gPLhBZQEyP7tRRbddISO7cLGJ6dbsGqgz5EQ39m0mWd0kwK7i6SQpaHFSOJsodC1GH3rj13DmSNXnmpeRkJSJuNRTR+0ehU/B1dE2zarI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

mfill_copy_folio_retry() drops the destination VMA lock before
copy_from_user() and reacquires it afterwards.  Commit 292411fda25b
("mm/userfaultfd: detect VMA type change after copy retry in
mfill_copy_folio_retry()") added a comparison of vma_uffd_ops() across
that window, but the comparison is not tight enough for private/shared
shmem swaps: both private and shared shmem VMAs expose shmem_uffd_ops
through vm_ops, while UFFDIO_COPY into a MAP_PRIVATE file-backed VMA
overrides the effective copy ops to anon_uffd_ops at
mfill_atomic_pte_copy() time.

If the destination is replaced from MAP_PRIVATE shmem to MAP_SHARED
shmem during the retry, vma_uffd_ops() still compares equal across
the window, the override flip is not detected, and the stale
anonymous folio is installed into the new shared shmem VMA.
mfill_atomic_install_pte() sees a folio without page-cache mapping,
calls folio_add_new_anon_rmap(), and __folio_set_anon() reaches
BUG_ON(!anon_vma) because the new shared shmem VMA has no anon_vma.

Reproducer (UML+KASAN, 7.1-rc2-00002-g8d90b09e6741, unprivileged uid
65534 with vm.unprivileged_userfaultfd=1):

  pre-fix:
    PROCESS_UID=65534 EUID=65534
    DST_INITIAL=MAP_PRIVATE_SHMEM addr=0x40041000
    SRC_INITIAL=UFFD_MISSING_ANON addr=0x40042000
    SOURCE_USERFAULT addr=0x40042000 flags=0x0
    DST_REPLACED_WITH_SHARED=ok
    DST_REREGISTERED_AFTER_REMAP=ok
    SOURCE_RESOLVED=ok
    BUG: failure at mm/rmap.c:1468/__folio_set_anon()!
    Kernel panic - not syncing: BUG!

  post-fix:
    DST_UFFDIO_COPY_IOCTL_RET=-1 errno=11 copy=-11
    RETRY_RESULT=-11
    (no BUG / WARN / KASAN signal in dmesg)

The patch introduces a vma_uffd_copy_ops() helper that applies the
MAP_PRIVATE override inline.  mfill_copy_folio_retry() now compares both
the raw vma_uffd_ops() and the effective copy ops across the dropped-lock
window: the raw comparison preserves 292411fda25b's VMA-type replacement
guard, while the effective comparison catches the private/shared shmem
override flip.  The mfill_atomic_pte_copy() call site goes through the
same helper, preserving today's semantics.  Because the override is
applied on both sides, a stable MAP_PRIVATE shmem VMA returns
&anon_uffd_ops on both effective-copy checks and the comparison still
succeeds, so the change does not reintroduce the spurious -EAGAIN that
v5/v6 of 292411fda25b's series triggered on MAP_PRIVATE shmem (see that
series's v6 changelog).

A separate concern from Peter Xu's review of v1 of 292411fda25b's
series -- replacement with a different shmem VMA carrying the same
flags but a different inode -- is out of scope here and is also
unaddressed by 292411fda25b.

Testing.

  - x86_64 UML build with KASAN clean.
  - Reproducer above: pre-fix panics deterministically on the first
    iteration; post-fix returns -EAGAIN with empty dmesg.
  - tools/testing/selftests/mm/uffd-stress {anon,shmem,shmem-private}
    16M / 4 cpus, 4 bounces each, KASAN-silent on stock and patched.
  - tools/testing/selftests/mm/uffd-unit-tests on stock and patched:
    identical pass / skip profile through the events block; both
    hit the same pre-existing UML arch limitation in the
    "poison on anon" case at arch/um/kernel/trap.c:198, unrelated
    to this patch.
  - scripts/checkpatch.pl --strict clean.

Fixes: 292411fda25b ("mm/userfaultfd: detect VMA type change after copy retry in mfill_copy_folio_retry()")

Michael Bommarito (1):
  mm/userfaultfd: validate effective UFFDIO_COPY ops after retry

 mm/userfaultfd.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

--
2.46.0

