Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFD75C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 05:14:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B086B0088; Sun, 30 Aug 2026 01:14:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC1E6B008A; Sun, 30 Aug 2026 01:14:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA006B008C; Sun, 30 Aug 2026 01:14:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2564F6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 01:14:13 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A63B640274
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:12 +0000 (UTC)
X-FDA: 85156769544.23.F564F70
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id B99B514000B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:14:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=PZsmYzGZ;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf26.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.171 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788066850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hnvYqsxNp8b49/rBowWqUXaz80+meTKicT7aB9r1cG0=;
	b=KlTA9g4ggIIhpCefYqu3Z/6j/p7NXxjJPLQMlfldq6eVSwALEfezsQnLy3ticHg34r4Lsa
	xo+NEWnvpsn3ofMUH1fsIaVz0iVYH/yAxy0Y84s2Jq5EFOkgOJUOncazdWe43+izmxDxru
	I1OQrx2QwuOPi6qP1Qm29u/nakmUTE8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788066850;
	b=RRlybdWhC4hGgye8lXrIDWvEOy+r1p7eNB5SvWL+gBQ85gFKuZ5JDylAoW5X0Bin+XLXav
	nu+hWvx6vw1X60wArbVqEh69q1erDk2pHfia0WDFVtEyp9DwzZix9p2KPmOmy15Az3JHqc
	RRHgbzD7xRC1jzMPonuBr6Dx1TFA4yc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=crusoe.ai header.s=google header.b=PZsmYzGZ;
	dmarc=pass (policy=quarantine) header.from=crusoe.ai;
	spf=pass (imf26.hostedemail.com: domain of kiyer@crusoe.ai designates 209.85.214.171 as permitted sender) smtp.mailfrom=kiyer@crusoe.ai
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2d91518a63fso932105ad.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 22:14:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=crusoe.ai; s=google; t=1788066849; x=1788671649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hnvYqsxNp8b49/rBowWqUXaz80+meTKicT7aB9r1cG0=;
        b=PZsmYzGZupyQk01Gqh9Hj/pfz9Hi7y9T7kdUMAa+9wEnEE2lie7HGiz1YgjPwItF9O
         BCXhygD86DAHoOfJPAtknibE7PyWJEe06pdC7cobVMSm3yswpWRLxNWjgWd8Zxcsxn9Z
         ykyQEFXyskNIoxY3nKd9O2LH/grlBojtxeY0rWL5BaCmBLFgdyaj39xhMZdls6Bh9PwM
         aosNPzy3OvE1h5kh/Uz0Iuj0L0/c+pXFQbX1GDgMmyd/NRwnI6i/isWMD7CrFkzZoYyk
         GLUI7wQIeHzBzRV9M+MAsixwfERccTt4CpT8H8ahgkE0n7oTW180KCHw78+TgD9Coyj5
         3nMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788066849; x=1788671649;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hnvYqsxNp8b49/rBowWqUXaz80+meTKicT7aB9r1cG0=;
        b=ZGjHxS59GHLejRssMqTdbqJixhBDnF7lEaXuArmwnUgydtssr1fKj7bIuCVZSeB+Up
         zcUerkRDqSgRT+jjVkwFIVyggsW8rYnTPQYX1eBk7KGqnyzCPSvYdfDi8Sq/G4Se3wTB
         fXj+A1ya9HuFxBj8igmz6yG094qqYyw5xro5bd2rTOtAtT98KEeIde4R0qqK3hwgnYFw
         RODCEZ7q4TlWCQINhEChaeuaj7p2zqTu8auN03FkjDuTREHf+EO9oqWP1UGaEbn3gpIJ
         QVL6whp9oqsYIjfvT7E7lvSEcNueJm79D5HLWBG1k2tXZPesBKgDI1W2hrYUpY/WHr1Y
         R5Xg==
X-Forwarded-Encrypted: i=1; AKwUvBx7fcJLLrqD7pGYJ8YgQILs+PtjcmPIJgjcqBCEhr8AM8sEWvXMixreolhGPuIFot6avZZEB17eLA==@kvack.org
X-Gm-Message-State: AFuF++nZVIMZcEalLpMn6lNYoRdHqGf0miGRhYoueceA/cKjQ5CVgYzF
	dSjTh+Ltp4+0RyUNXOURdUGHVyMgn3MyADh1VDlzzFYKjiDBy0UJfGtgGG4MOWD+jJnBIdxQuHv
	XLfyYWj+37g==
X-Gm-Gg: AR+sD13pm28ImUvW3lkaBtMuQPYHzcli+yWbDP8+ZNhbwhSobAn2IzyN9B2F1rFL27v
	GG0zMayw+RR1uQXPH4zuq8F1yFNQjoL87JZTCJJr6Px/LBpzSLe0qvoZ+vpbJj3CE1wruDgD+pQ
	fXwqv4K1uGz3ry1Z6Zk4/LmNzBqDi3+jSFR/teu03D3KCr6/BQByHeKb6/AZEVx4icQCM5cysUs
	TPp4tpfBxRHBznKuIO6IxOcBGF8g0Rs0uQUx8uM5fYBSwo2DRVRIB0Ir9HCO+jVRQ0h57O7ZaJW
	CUY4uoou6YVo5ynLNXIVflxVwH7ypKUnp+wBctpehONP+LV3Xaw7Qzn+O7U1/6yX9SdUjDSK1kW
	9tyMH6oFZtSbvsrnrlZ26+hDlPhT7SfQvLdguB8ljNnaU88GmvNhPJHDxxOIAblCrX+uUxeIGXi
	e0TGHvxy3zjkF49WKPNCUT72LKu1h+RjHuuSiCzcmcbQZkdxmndVDvY9dPb1aPHo1DayU5RzkCL
	06r1bmHF1EI1mDZvvtpEsKblp8UyzOmRm0=
X-Received: by 2002:a17:902:ce88:b0:2c9:c952:6e9 with SMTP id d9443c01a7336-2d74dca2281mr279592645ad.2.1788066849370;
        Sat, 29 Aug 2026 22:14:09 -0700 (PDT)
Received: from MBP-Krishna-Iyer.civet-hops.ts.net ([2601:645:c68a:b830:d101:1d:112c:715e])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3286fa37fa5sm22595810eec.29.2026.08.29.22.14.08
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 22:14:09 -0700 (PDT)
From: Krishna Iyer <kiyer@crusoe.ai>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Krishna Iyer <kiyer@crusoe.ai>
Subject: [PATCH 0/6] mm/damon: support access monitoring of hugetlb-backed memory
Date: Sat, 29 Aug 2026 22:14:01 -0700
Message-ID: <20260830051407.50008-1-kiyer@crusoe.ai>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B99B514000B
X-Stat-Signature: 16rz4aqgtxfoggzoc95469hqwxenqwnt
X-Rspam-User: 
X-HE-Tag: 1788066850-321816
X-HE-Meta: U2FsdGVkX1+mGN9cPkkPX9Ymgvu+bkJxQHnZNKNdnuf3u/8NrJfT9Ip1UeTu0mqqwToQF9/TWnGlId/D9EECLimcLBI+zVE82IeLC4SsN3twfQYu4ec5gqnqMP63/26FqKguu+bnNsvplk5vChUY1Uu/Qyr4US/8tTGgQITdDMp1F/5ThRZVBKK+pD+JxVVWzuouBAfWNtsaaoH5SBNU9LQ/XoQ0DjF7OlHVs9KIYwepi76DCPsARugkFZkNs32XdNc9VgytEUNQuzqZ/vn/yU0f4+Wdu8snvOCwmbRq7HEg4Wk9DWJee4BbPqH2VPuMVLVUZCwtT6tZ/bGc24ZCiifbZ1Aj77/fvVBAO4jTk57/7Oi+7iVblWxn0A1KccJrFkf8bVzg6wlHxMa+6GpYfVf2g3fsnZWPD1yJHAGcZn+l5qXaNx6JFqEq2gEdYgaptncVIncQYlat4Xzugh63w1Xg/sWRg4vJM2mjJPiX0m6aZzYDwZFhGO6WVlJfMZT35ZhDFkkEB9IZvThVO1CxzZUfQjDTrKWGtXAOpHCiz87jwFzTmtvivZrxEEiabjlgY0yCjzjTaq5LhAOaOHi87CiSuMRfg6jNlrzIdTb4iXZ8RK97UpLIDXjhsoUoEOhXrkhRew2L6ogmFKwk3EVEGZIul8lEcrmh76xINIgqoMhCoLHn12XUesWjJzjsrMfNWsmgR/bTvsxEqWY0B/FdEWaGnOCaR1h6stux7qh4ujApvsnm4WsbGCXSHPUR8U4N9+hPg04h1rzWZevQIqE8IID3DsRyVqpogqEmH1ljjBdgzk3aXpob/mlc6+zOy3E858euu/a1GuUSAvrV2gkFyiO3gudv0KXUbcZyKr/7/uq6pEaKhithTPuptG6ovo5fZ6bXjzvdkqi7TAnCQtghR2JH0sxVsybdvJJIpDwXYIPOMfMXrBqWDadhEnah8Xa7Mbg6s8j+YEvEzuzjSPV
 CT3nYswG
 SJAe6IN3IfSq3QRpGZwRTONSl5AGeBN+QR+Qs/4Q1AH3MKuaqQTxE9REZ6rgiLzuUH5oOsplF6Lti435CjKYiZhaeWQP6A4UzXCb4udVQZRQhgJn0wACwBJZVhgJwTbeirCo/eScSytoj5yDYbI8UoJ206HDpC9z4UIrQM0cbtjoYXJ1KuaPWbix/oe4MbWC5AraPiJIOl/cxQBoYDF+lz+EtkQaLYX0QjBauE+2JC6nKloA8weYdXKyA43cymrIiXcYOlTfmr+nMHuY+uGBW/O7bkvYYGk37s4MIhIjfj31s3trS4yBnIfTPqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On virtualization hosts, most system memory is often backed by
hugetlbfs.  On our production hosts, for example, ~95% of RAM is 1 GiB
hugetlb pages backing guest memory.  DAMON's physical address space
monitoring cannot produce a useful access signal for such memory, for
two layered reasons.

First, it is blind to hugetlb folios.  Every access check starts at
damon_get_folio(), which rejects folios that are not on the LRU lists,
and hugetlb folios are managed outside of the LRU by design.  As a
result, all hugetlb-backed memory is silently reported as never
accessed.

Second, even once hugetlb folios are visible, access-bit-based sampling
under-reports hot memory.  DAMON deliberately clears accessed bits
without TLB flushes to keep the overhead low, so accesses served from
cached translations do not walk the page tables and never re-set the
bit.  With 1 GiB mappings, translations effectively never leave the
TLBs, pinning the observed access rate to the TLB-refill rate: a
saturating guest is indistinguishable from a nearly idle one.

Patches 1-3 address the visibility problem.  The first patch moves
damon_hugetlb_mkold() from vaddr to ops-common as a preparation.  The
second patch teaches the folio mkold/young rmap walkers to handle
hugetlb folios, aging the huge PTE and notifying secondary MMUs across
the whole huge page size; the secondary MMU notification is what
surfaces guest-side (e.g., KVM/EPT) accessed bits.  The third patch
adds damon_get_folio_incl_hugetlb() and uses it from the paddr
monitoring primitives only.  DAMOS action appliers such as
DAMON_RECLAIM and DAMON_LRU_SORT keep the LRU-only lookup and are
behaviorally unchanged.

Patches 4-6 address the intensity problem with a new default-off
monitoring context option, 'aging_flush'.  When set, access bit
clearing for monitoring uses the flushing primitives
(mmu_notifier_clear_flush_young() and TLB-flushing PTE/PMD/hugetlb
aging) so that the next access is guaranteed to re-set the accessed
bit.  The option is exposed via the DAMON sysfs interface (patch 5) and
as a DAMON_STAT module parameter (patch 6).  With the option unset, the
behavior is identical to before this series.

Evaluation on an Intel EPT host running a 944 GiB guest with an 842 GiB
in-guest memory workload (masim):

  configuration          estimated access rate    idle -> load
                         idle -> load (GB/s)      separation
  stock                  0.08 -> 0.21             none (guest memory
                                                  invisible)
  patches 1-3            1.70 -> 1.96             1.2x
  full series, flush on  1.21 -> 5.34             4.4x

With aging_flush set, the estimated hot footprint covers ~82% of the
actual working set size, compared to ~40% without flushing, where the
signal mostly reflects the ambient TLB-refill rate rather than guest
accesses.  kdamond CPU consumption stays approximately 0%, and the
worst-case flush overhead measured is below 0.1%, which is acceptable
for hosts that opt in.

Per Documentation/process/generated-content.rst, this series was
developed with the assistance of an AI coding assistant (Anthropic
Claude, via Claude Code).  The assistant helped draft the code and
changelogs, and performed the rebase of the series from its original
6.17-based development tree onto mm-new, including merge conflict
resolution against recent DAMON changes.  All changes were reviewed by
the human submitter, who takes full responsibility for the
contribution.

The series as posted here was regression-tested on its base commit
with a full x86_64 kernel build (no new W=1 warnings in mm/damon), the
DAMON kunit suite (41/41 passing) and the DAMON selftests (15/15
passing) on a kernel booted with virtme-ng.  Functional validation
(the evaluation above, ftrace verification that the flag switches the
notifier variants, and enable/disable stress testing) was performed by
the submitter on production-like hosts running the 6.17-based backport
of this series.

Krishna Iyer (6):
  mm/damon: move damon_hugetlb_mkold() from vaddr to ops-common
  mm/damon/ops-common: handle hugetlb folios in folio mkold/young rmap
    walkers
  mm/damon/paddr: support hugetlb folios in access monitoring
  mm/damon: support flush-assisted access bit clearing for monitoring
  mm/damon/sysfs: support aging_flush
  mm/damon/stat: support aging_flush

 include/linux/damon.h |   2 +
 mm/damon/core.c       |   2 +
 mm/damon/ops-common.c | 154 ++++++++++++++++++++++++++++++++++++------
 mm/damon/ops-common.h |  18 ++++-
 mm/damon/paddr.c      |  11 +--
 mm/damon/stat.c       |   6 ++
 mm/damon/sysfs.c      |  29 ++++++++
 mm/damon/vaddr.c      |  46 +++----------
 8 files changed, 203 insertions(+), 65 deletions(-)


base-commit: d2aad7fdcda7ae8a726926f2d6de7fe9e8ee7563
-- 
2.54.0


