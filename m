Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8705C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:19:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8A5B6B009F; Thu, 10 Sep 2026 10:19:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A15066B00A0; Thu, 10 Sep 2026 10:19:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DC9C6B00A1; Thu, 10 Sep 2026 10:19:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 638EF6B009F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:19:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1888414053D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:19:00 +0000 (UTC)
X-FDA: 85198059240.15.7847476
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7BF9016000F
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:18:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RiprIrYY;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OatsKQ+AnGs6vyB70H9GTzO9XlSkzqH7qImbPph1GPU=;
	b=QJjrcPjO+oxxHfbp5qJMZpk7yQib/gL62mPMTqfvEWYN/b3Ta0+fbJ+m8cfe7RxlTWfLlg
	6aJyNrbtOtMGyu619ONPzg2R+qI3qvYfFxbSPMSbay0681azNQGgo7SQnEwrVYLnlb4SjJ
	YnkTozbP56rvHlWzSDUnnWHy/4HiHfU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RiprIrYY;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049938;
	b=cOIQhuV65Xx9MQnRbg/4HaHkmF7fg7NFrhQOSDUsv5RpIUUMb9vytbZ9jYZchkW8wpjbvC
	FHVlG4bVy35WgZQV1KT3G9CboOH8s0Z8/ssRaEVqCl6MXPaw8DyEaWDOrBOh4h4w6puYj3
	6M+MHN6IutBwClX/Kb3m2FsqNm/dbNI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88A6C404D3;
	Thu, 10 Sep 2026 14:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D53BD1F000FF;
	Thu, 10 Sep 2026 14:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049937;
	bh=OatsKQ+AnGs6vyB70H9GTzO9XlSkzqH7qImbPph1GPU=;
	h=From:To:Cc:Subject:Date;
	b=RiprIrYYjEpxQQ9oxSoTxYZMyOB5FZLZLreWjtU9UkixReFgZe7cRvj1PaHZaZgNu
	 QE0lpZa/LtRQWPFLl/mkpgmRnOCQe8x+c7fEv/p/0xuoNfOo0F93LeY6+7JpxN2Kpd
	 4BXc30JChzg40UGwzw8Wig+1XsHK5RJOJ3gO/b7DcqwHvOGiirhkF29DSWwnXhZYGN
	 AxQDFZCvMWcjSsSAq7E6OSra9KlJh1z7VehNpyN2gVh5E5qtRWqEU/u6VVmTAiZUTd
	 cfj0r1nZvg+giJegu7Ys1T8Nxb2GeIibTBbxZGAOopnbUrOseoVTneSJS+7XlADkDb
	 cqv3bW3menB3A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] mm/damon: introduce probe_hits_wsum DAMOS core filter
Date: Thu, 10 Sep 2026 07:18:40 -0700
Message-ID: <20260910141849.170896-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7BF9016000F
X-Stat-Signature: 6efth54jyx11h5e8aeo65ctyspeq3trn
X-Rspam-User: 
X-HE-Tag: 1789049938-324674
X-HE-Meta: U2FsdGVkX18qrqPiMLCWXCtQRuFlM3yCp8wXzKfRklaxQsQ47T/YeR7P6mPk20O1G8x7qUgoo3UCZbvZQwyPdRToIO4qEKW0hkRaWBYA/o893ul9KaTHCjOVvyrrENtANXvTl0cdDv65fhFbBnNAjZBarixGeayBvXD1hU4KqnOnO7s8LSGPuMjE3mt7shlffZgoPZE8ApWEKkC0VzeBskOroWnBZN6KrZFVvdV9gPT4lNX2xvBtAkEvflEYbolqzO/fQzjcZUjRkTuzxe1OlqK5TkPWYYq0m6zjYM0yapDuN/KSKziDSCPcmJwqxR+YrDJsJr0nXoy9MrPx1vFxtA/jDxLT6y+5B4UffHGjWXQk3FlwD66h9NW3wTnaBwZTr5dMSOh0HmgYVPO8MHLsyhE3/0JnQNuYccrFY1hLoj48bnodyIqr1we8MDc3/ek52H2diy0DW59U0bA3JM2N5cBgNyYeGSrwdSp5sJPdPsgZGoOMqsqUv35PdqBPYYWEMJd/y1HqKY7tttnT84ySWKUR6hvkDC5B6j+rL1LreFgCSr1RWUjGCVITm45Dw5JT3dKLc9TMWwZJp30Oo4uJNZ0O+oafdKqScIaRCoDqtHYvcBrWeH91D4Jyn+8g3yo/EhbwWWY96VSpjjrAOVhtVkdzrXygiP60InDJ+2qJBEwG+wYwBi8oHzuYl9oZGLjR+bcpjsGYWXF7tb+weIZi+5CXk5DeMswjVg5ubMpmJnjNeXILEgtxSZhviQ4hhWYC0iTXRw9AeI6TqrdbueWf0szG5cHCdqNL541hYitbuIPHHz50QtyDWpoNtXIbHzVkpU0gSRQRxw3gZFbEVTTvvDgl5ZpNbbAriJm2bxWfQwBidFEjqle5p5QFDLkoB9LIFZmN0ZAyvN80gz5jj2OxwjEYlXGUXd3p+R/mzX8MwJnmO8j0bMzJwdBpmie9yDitIHAotYcoYHCdsVYL6+C
 Z99OZSyt
 H/c5FxSYvtCaT1eL0DqGvuwg7eC7Lg1W4vznfra9zeNU+7vUcVmk5nIzYA4BYkIV0ul+sH9tmWPg3/TZiOESl7CzV1XkbT1qeQ2MSWa32G63/b0G52kSrpnDcOkabjFIyY2oFDP2lM18QtDf9rf/bKablQfBGYS/TZSPKMZDR04X7ANyIIbBlx52+3jLqyypIhR8S2/qk1ijOF8hVyZ3gR9JilkgzCis6s4H1PW6W7WY5azLt/A57QHDoO/Dc+6mAVw1atZI7SSZhDq+Kx8vdxI00gZlxLyuzy+fH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON can do flexible data attributes monitoring.  The classical data
access monitoring can also be done using the attributes monitoring.  The
access event is just one of the data attributes that DAMON supports.
Users do monitoring to make some actions based on it.  DAMOS is a
feature for automating that.  However, DAMOS cannot utilize the data
attributes monitoring results.  It is still Data "Access"
Monitoring-based Operation Schemes.  It requires users to set the target
"access" pattern.

DAMOS core filter is effectively the same as the target access pattern.
It is just a more generalized and flexible way of describing the
operation action target region.  Introduce a new DAMOS core filter type,
probe_hits_wsum.  It specifies the filter target based on a range of the
probe hits weighted sum.  Using this, users can apply DAMOS actions to
regions of specific data attributes pattern.

Note that the classic target access pattern still works.  Hence the
target nr_accesses range should still be properly configured.  The new
filter would be used in only data attributes-only mode.  In the mode,
classic access monitoring is just turned off, and therefore nr_accesses
of regions are always zero.  Users could simply set the target
nr_accesses range to include the zero nr_Accesses regions.

Patches Sequence
================

Patch 1 updates the DAMON kernel API for the new filter type.  Patch 2
extends damon_probe_hits_wsum() to do the calculation based on moving
sum.  Patch 3 implements the filter type in the core layer.  Patch 4
refactors DAMON sysfs interface internal data structure for efficient
reuse of data structure for the probe hits weighted sum range user
inputs.  Patch 5 updates DAMON sysfs interface to support the new filter
type.  Patches 6 and 7 update design and usage documents for the new
filter type, respectively.

Changelog
=========

Changes from RFC v2.1
- RFC v2.1: https://lore.kernel.org/20260910040319.147037-1-sj@kernel.org
- Update kernel-doc to clarify probe_hits_wsum is a damos core filter.
- Drop RFC tag.
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260907171218.101430-1-sj@kernel.org
- Rebase to latest mm-new.
Changes from RFC
- RFC: https://lore.kernel.org/20260906210513.106895-1-sj@kernel.org
- Fix kernel-doc typo.
- Use moving sum based weighted sum.
- Fix wrong range saving field names in sysfs.

SJ Park (7):
  mm/damon/api: introduce DAMOS_FILTER_TYPE_PROBE_HITS_WSUM
  mm/damon/core: extend probe_hits_wsum() for moving sum based
    calculation
  mm/damon/core: support probe_hits_wsum damos core filter
  mm/damon/sysfs-schemes: rename sysfs_filter->sz_range to
    range_{min,max}
  mm/damon/sysfs-schemes: support probe_hits_wsum damos core filter
  Docs/mm/damon/design: update for probe_hits_wsum DAMOS core filter
  Docs/admin-guide/mm/damon/usage: update for probe_hits_wsum DAMOS
    filter

 Documentation/admin-guide/mm/damon/usage.rst |  4 +++
 Documentation/mm/damon/design.rst            |  3 ++
 include/linux/damon.h                        | 22 +++++++++-----
 mm/damon/core.c                              | 20 +++++++++++--
 mm/damon/paddr.c                             |  2 +-
 mm/damon/sysfs-schemes.c                     | 30 ++++++++++++++------
 mm/damon/vaddr.c                             |  2 +-
 7 files changed, 63 insertions(+), 20 deletions(-)


base-commit: e63f7a9955d13dbec5df4df19f844e5a0fbc3ce1
-- 
2.47.3

