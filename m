Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 288D8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 23:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CBFF6B04D6; Mon,  1 Jun 2026 19:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CB06B04D7; Mon,  1 Jun 2026 19:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 392526B04D8; Mon,  1 Jun 2026 19:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2BB706B04D6
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:55:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C252B1A0787
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:55:21 +0000 (UTC)
X-FDA: 84833002842.25.AD5BFC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 34F6C40009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 23:55:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pm+/kn4u";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780358120;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tdHsEzRwr+voPk8oFzNtX+TuPH7KEPW0L0yreXJhrlk=;
	b=IVHhagHB6TqGeI6G+JX2RXfsmc8gAcfLmY+ZAMxe7/GpT77vAHWqCCwSSBbcgl8Y949OAO
	nyfKdKUuxeyYEnwhsm4Da+YwQSSYcAp4UZxSUApyvjBqFsQgv6ZIBghWGJVIVOZB2lkVyb
	vxtX8YtEo88Gf2baxLpB+nU2FbIXY3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780358120;
	b=kcxTJIzVeyyXYFtzSxNYgR+Sj0b2G/lZK71yVpPdS/hgadqC2oNZtsQ/DKvULNQ2TczqYm
	PTgmVxFI/o7aUa1REfOHUQ1JYAz6JhSb8jewxKg56DVkXGWR1jNpYyyxL85jJwOvPRIM1E
	wB+C0Kg3/nzOwfWVDuyNm1bo/bjOI0M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Pm+/kn4u";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 12F1B40364;
	Mon,  1 Jun 2026 23:55:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9221A1F00893;
	Mon,  1 Jun 2026 23:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780358119;
	bh=tdHsEzRwr+voPk8oFzNtX+TuPH7KEPW0L0yreXJhrlk=;
	h=From:To:Cc:Subject:Date;
	b=Pm+/kn4uS0Y1jqm3UQxmCDW6n3qAUsFWAbtED13ON/J5mccNLTwDAUEF90yoZcjLn
	 IYaOKlb22rMs+ooikXYh+b2/lP/PgUBKwV3b5SChz9ABs4ewe6Lsyacigb1wpAzy7p
	 lC9hbmeo6kyrJaR4Y2wASLAAZGy6oMb/tf9nH1AESkAvCq8Y39cR060lj4CfUgVVhO
	 hSaVXkcaVq8/ftjhxHhWRONA4vea6W62A8NXhGlaGoMnCGBnSwUIz6ajkYzI4GSsF/
	 mV1WzzNmOi3lIaP2GxM3u+cfusBNllkzfYhVaswH0qEBsJJ3bwY0UDBl4BG2YS0LZR
	 awZ81iI6GZdaw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] MAINTAINERS: add testing ABI documents for mm
Date: Mon,  1 Jun 2026 16:55:04 -0700
Message-ID: <20260601235506.85123-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 34F6C40009
X-Rspam-User: 
X-Stat-Signature: fn13ehdn9atbed1xfyhsunx89b7jknt5
X-Rspamd-Server: rspam08
X-HE-Tag: 1780358120-627461
X-HE-Meta: U2FsdGVkX18AHdvSMNlzvbX2hI84KpHMInnvTdkxjKylZafjsILXY83SCTALDkw27LCSIBewlpya8/Lk0pX7q2P1REcrurgan1aR2UcLSJfH3m8Mc/vLCOZcqstRZ1qsRj904z5E14RKo+PXufbKaXmm+CZ2WscvoEuIYnfMBa1aH7uHsM4d1PjemA8k4VHeB+9NKs1RSCHSNCV408kg7KbaV8570Gy3HVg4GWvxhc0VZ7ex4dHdJ641oGKs9hPt28fZz5NHyZte8z1zEdJBj61wF72o31FaFi5zykA0X9KAhC/v+waRm31YwMjZUV47bL5IS4ffQVLCIM9mYFwNTcG/QcC1aV4vW10i1ycDCDsVgESVJYDMZXqH25ZzFyI7bEBN2pddYRFEzShpqNNUULbFy4Il/fevJ0kUxLv9PERykIF2Jg1/DWtTu6EFXgVOmijMbcZI8suDr9VCcTfHG4q6BsbdP5oSbeH9BYUVOs+GoMtXFbmS2muUCb1zIK92GpxHIs6J9WB0vxMPcvvapZnJ92Zj2DYZUKXHqCVy/KU15Q06js9gLVlUVrXTglizF0TvNfvB9AJX38tW3LRU0pLhP/19JF2u48JA3pfA5AF1y4P3VrdxLRo06CxmF5kpgT3nfHYrHM1unJZfNV6h62y8s9x6EY4A60E9ihy8FS01jkJw6uc7jPrXdK2uWeewc1Fn+WYGoy+0Q2wIvDZ6UZHn7lkDyQGkMerqTxRo3QqvZHRkfZhOTDn+ta7GWpG7vghbbMe8YoN21Koah8t1s9jYo87bLD8/fhk0JSEyhz1Z+OCHMMgRU0QReYwNzcImjeWCKww9T7TA1r0ZLpctXgdMIaXe6HO9dRLG/gEFkZXp9ytDzuRbwt2HGFGQkA6jDEIKt4XjWffPF4VQphfM1I+kM3TZp3057e5YAboL5Vft1fH8MUtKZM5UiadRTEcvcjxPTdsrjztvoaPLynb
 j3+9l14t
 GyxpIyX/NEtGu5g7yUKDIm/Lt1jfQYftmxTsQIkNrTk8ZTtcivQV7ZlE87lwsHjf6cSlOTRA42lK5oZNohWGryLRfaBe9aHUgBRfcfpa7ycmMl/nSwzwTvDV6ov7NtIt2iLt6VQiAVblDVRhevt9CsgSvc/hN3BiKhbVuJsWhigzKdfsvy61vyYZ7XfpMOrfUD7uS6qHsd6dN7sESqrw8lKCQaF6LSZdnH8h9+i8uXNolkBefF90YikWc3neGQBxl2WNCNqAF7K22qvSSwcFSYsfJErClcsz6ZCBDhsRrBEjwI0z7uY1qGIryecUp2XrGNumowNd9e/xAshINYK/ut3QtXPsjdskra0kC3s0SQt+XTMmds4cEDxBD6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few mm subsystem entries in MAINTAINERS are missing their testing ABI
documents.  Add those.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from RFC
- rfc: https://lore.kernel.org/20260530011852.90663-1-sj@kernel.org
- clarify it is "testing" ABI.
- Collect A-b and R-b tags from David and Lorenzo, repsectively.
- Drop RFC tag.

 MAINTAINERS | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index e119182a8911d..a31f6f207afd8 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16854,6 +16854,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-ksm
 F:	Documentation/admin-guide/mm/ksm.rst
 F:	Documentation/mm/ksm.rst
 F:	include/linux/ksm.h
@@ -16876,6 +16877,8 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
+F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
 F:	include/linux/mempolicy.h
 F:	include/uapi/linux/mempolicy.h
 F:	include/linux/migrate.h
@@ -16918,6 +16921,10 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-cma
+F:	Documentation/ABI/testing/sysfs-kernel-mm-memory-tiers
+F:	Documentation/ABI/testing/sysfs-kernel-mm-numa
 F:	Documentation/admin-guide/mm/
 F:	Documentation/mm/
 F:	include/linux/cma.h
@@ -17041,6 +17048,7 @@ R:	Barry Song <baohua@kernel.org>
 R:	Youngjun Park <youngjun.park@lge.com>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/ABI/testing/sysfs-kernel-mm-swap
 F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
@@ -17068,6 +17076,7 @@ L:	linux-mm@kvack.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	Documentation/ABI/testing/sysfs-kernel-mm-transparent-hugepage
 F:	Documentation/admin-guide/mm/transhuge.rst
 F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h

base-commit: 974fb429a895792187b0d81090c6099e47b6c3ec
-- 
2.47.3

