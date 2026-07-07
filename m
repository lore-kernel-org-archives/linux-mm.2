Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53F31C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 12:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31F7A6B009E; Tue,  7 Jul 2026 08:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D0986B009F; Tue,  7 Jul 2026 08:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19AB86B00A0; Tue,  7 Jul 2026 08:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7E1B6B009E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 08:11:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5AC1F403FD
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:47 +0000 (UTC)
X-FDA: 84961866654.15.F1F11D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 71C724000A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 12:11:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cbIDQqJA;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783426305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=StZ5pwSjJvQJQ08vSJxzLNH2+TxNH3/JjgTAf3W+27Y=;
	b=wDr4Bv6xMXx6ZcX0y0WbbVY/ZePELCy43c0ce7zHvcm7bIdnIysveETbsl05m7YqT8sC5H
	uwxcE6bInD2rvFs6cQoQR91tsHCaTMhdH3YAy80l16U1Lsv/DQolW6eadjk1mfdusi6b8e
	JEFOIxidTQabIwVjzQk7zO08LAq+Bos=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cbIDQqJA;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783426305;
	b=iBk6BriJPSGncYVtqGKHUpD9U9b1z4Kizy2by9H3YgxV50/B2Bo/NfSAysebNpEGGUexeF
	93kex5LhZeSsMV6EGVRfEkYmT6QZGUqjqz5eLxVUHgwyJU8lG0YLqgdnCBMYiZNF96fXE/
	0ENZHmlT40AY470f/4u2k2uKmQWIqck=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0E7131A00;
	Tue,  7 Jul 2026 05:11:40 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 1BC523F7B4;
	Tue,  7 Jul 2026 05:11:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783426304; bh=o7VwJh7uSVaoe4ejn5xYBJ0uFGWhULPUCA9+6098DIw=;
	h=From:To:Cc:Subject:Date:From;
	b=cbIDQqJAPUtiB+qhOVOe3tJ1PNzbhZ0euJHBipCjwhbt/zKVz3VBdoYOsEkcvsVvq
	 3OBF4jp/vkO8GaZKBcZhGFaEJ/u9Ye5VLnC2a817ao4bA4cQnocG4ZI9K+gqyUfCZw
	 dGUjIy+u+2xT2jV7bHbbdnO1pL3PMyigoFhdchis=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 0/5] mm/rmap: Refactor try_to_unmap_one
Date: Tue,  7 Jul 2026 12:11:18 +0000
Message-ID: <20260707121128.373192-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 71C724000A
X-Stat-Signature: pj1tosp3ru387hec3uueq7dohc87imxw
X-HE-Tag: 1783426305-257734
X-HE-Meta: U2FsdGVkX1/cCLedvTSBvjI1gALRYMIXJH7pfNGhXiVSa7zCrej5tnpeBJ0DjXKe/S/SIFmggkgxf455qH4JhsYycIlEH6Wo/+esYHBXv+JZvIiNuKm8i/TOvifkhWBy+sMyAK1cxbvcHWQEh/nvq14P/u+AnRaK3PSivmF8as2YFZ6I/0tH40IBAADZvefpx6Vzd5UT5SC688jO/1NeDmP+tY97CirwN0MZVoHVpiFM6FXT5YSE50LJ2Q47Zzer+Rq47nY5WK+/K9eJadKjkTflYu8dY88PMGHB4zaocXFTIgGlLVQ5QRwpeyQZQY7vdgs3WfdByVkCFY0lgZ6MYx9LftfMxI40iPgvn8mdCKHsfw+vM7Px/RA51fmcAibLdX7EE1rGNDU3Qfw2TFg4V587e8Z6Q+OekSnZEsuH5JdPoZljBYS87/hATsnWKk2YtGXysonTqPo6ZO+rq4fnT/FOl98LWgeqEehWPJRczhcmiiGZMDMjYOkGFH7gxXeBtr2oravRFxCmsJHlUmze0ecl0QBosJEF6a/TyPT6BoHrth43L3UX9yhnZgqP1Q5thz++yON1OQiOhYMOOKDC/mjo/yYEmKBpTzDQTpOTxbNrb8vG4Ua3uAToEpqnPfPlGx+EJfAngGlkHvNbw2KAGrwfrTIhb30SxSeQyEY9AT0D00ngVnx0RWXzCM/OloxBAQq/Q9UFhaiy9b6qb64JdSFWJN1ptjNlChinPGlwoRhIWHzrihZ6zZJQrQlUwx65RQ6F/UpB9t4loH8tbVgOXezxUCoRm7/GENC//TPnN20fl2x0/M5t+BeA4ypIyOfnHPXdbxRdO7dzeJJi4mUNb+E6Td09OCXJECX5te45NP84xZ1TXVLh8uxqf8iOnDo5skivJuTmnb3VMOkPIPiul9mlPA7FCXS2BBfZN15U4vYEHldg4qyvP50dflK6+BG/tdgPMWI0o6FNRbP9yTO
 zKWdVUS+
 dxij0Fb8T38CNYAHrMmqhqP5Pg9svseCnjK08cBvjwGBrqR3ZIU/n3gx1jDQ8aSjZgfMzubAocMp6rmV4TbIrDcE6h4OJvJw7DiN2RgHxI/4KNV/uhSx6LkV95DLoT4g29TtK5Z40qCNGUbZ5uD+opKEg/aUKUozWbZ/3k47kFhMfljQO38a1MSJKrTyyLsSLpTczE0QTeEjmrsWe5rfgLUa6V1l++XfAJc85+a3jm0brogaDrWq8pE0jowxtiTLXwWWqviTHRQIQGylV95WcV5Gj1371pn4nqWPROGTtH9NFMpVQer958RXzok6u0YpyZGis
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for batching anonymous large folio unmapping to optimize it,
refactor try_to_unmap_one. This series refactors hugetlb, anon-lazyfree
and anon-swapbacked logic into their own functions, significantly
reducing the length of the huge try_to_unmap_one.

---
Split out from
https://lore.kernel.org/all/20260526063635.61721-1-dev.jain@arm.com/

mm-selftests pass on arm64, built on arm64 and x86.

Dev Jain (5):
  mm/rmap: convert page -> folio for hwpoison checks
  mm/rmap: Add try_to_unmap_hugetlb_one
  mm/rmap: refactor some code around lazyfree folio unmapping
  mm/rmap: refactor anon swapbacked folio unmap in try_to_unmap_one
  mm/rmap: add anon folio unmap dispatcher function

 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 425 +++++++++++++++++++++++-----------------
 2 files changed, 244 insertions(+), 182 deletions(-)

-- 
2.43.0


