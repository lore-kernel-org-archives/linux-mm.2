Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43655CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317ED6B0101; Thu, 25 Jun 2026 07:30:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8346B0102; Thu, 25 Jun 2026 07:30:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD4E6B0103; Thu, 25 Jun 2026 07:30:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDE646B0101
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:30:13 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7C5211A0629
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:13 +0000 (UTC)
X-FDA: 84918216306.18.F0CEE62
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id B170A140011
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:30:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JtzjQqEt;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387012;
	b=uu93hxzFezJTe7+ZY9drO59lBC1uPiiIkwQPb9c8daJrSlSKzoz5DW6G4LfVC72ylZjdwe
	PxL7t7PyeghAc/D8gWPitDevA5/XG+7IoXP/oXA5xk+FrZyCkrey04YTajYGTgq1cMcK5K
	pCnVsb5WYVR0BZv4ixpIFieBCbqp2MY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=f329FOXWQpF7PN+IzbqHXeKvwGQCEyhHtjg/996QMuA=;
	b=KksHyl3LfUnw/IX1y5KpbU/oyTfwYdk3EsrsSnB6C33SXlYg2IE3iGjFnhV+yBmFtrlfrB
	67zd3SnJLdAdhQBifxBQbZLerKu3pghtgCt75o0RUrSNQDjXKLwYmxBREo16kOId44nkpj
	fTKw1oPi3sobcA3WVWPhlYmxlDhIXpU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JtzjQqEt;
	spf=pass (imf09.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DDEDF2BCE;
	Thu, 25 Jun 2026 04:30:05 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BDAAF3F62B;
	Thu, 25 Jun 2026 04:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782387010; bh=38+Ad+oZs4A/nrJgkGJGbrc6pvh9jrw/K1S2RXNPdck=;
	h=From:To:Cc:Subject:Date:From;
	b=JtzjQqEt8q8QEYWUdWZ7UueseUsevApx9kmYONKhbO/zw2X1LV3YbrfxQJsr9d2U/
	 GK2QksPLqhLotifcKqRse0Ljlk/E1WJ4/jNhcAMo/BOkuPmAENbtOiFiIXVIUkuWsF
	 5ZgsIIw2nGbuqSKMuXozwhWyw22DZ5Wp8l4kbN0w=
From: Dev Jain <dev.jain@arm.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	david@kernel.org,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	kas@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rcampbell@nvidia.com,
	apopple@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	mel@csn.ul.ie,
	nao.horiguchi@gmail.com,
	ak@linux.intel.com,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	dave.hansen@intel.com,
	tglx@kernel.org,
	jpoimboe@kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH 0/5] Fix incorrect access of hugetlb pte entries
Date: Thu, 25 Jun 2026 11:29:49 +0000
Message-ID: <20260625112955.3254283-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4jercn3589uid3pfsymfcysn6mjxpzqb
X-Rspam-User: 
X-Rspamd-Queue-Id: B170A140011
X-Rspamd-Server: rspam02
X-HE-Tag: 1782387011-454479
X-HE-Meta: U2FsdGVkX1/x2G2eOJcsfN8MbKydaU2Veu5zthSw/q1fpiMATA/PPDzXzj0TJw6J72L6v9kS1LJjvTgmmQ/SY/hPbb07f4Tr8aGVSJPcYGHeNs3HLyBaymIqGSuhrpq06vg2x3eEJVbTvgZrvgC2C/6vOq06MXUFPT/+UBMp4dC77Yjve9o61X4uW+54CxsY4fTdJ5agjq95E7NCiV3lu4FI0q4alq7pmC7MyPDEBIalQ4LH2k6tHFwDJ1jLoXYDVra9nndd5YiWSIhPutXqzI8oKF5gWSwkxIKEhBfiuQ2gcPa/nE7fEWFo9okR5V7iDT/2d/hL0dfq+Ol7FGnR6ENhyiCMCB0GMcry+UcYbm9qsp0vZaKfLiyRWN9ePibP50hIEMfrnIQb7hru7vVdD25+DSEo4DSLNvvPUXIBnogKgvs6SvSL4HzQTh5oZ+mcQ3+ZwKZaVgZMu5Wq7RAu73VbRTLtG1ngbffbB7+ly5TkMcEh4z22ys5ew1ByT7fOEo9M8DI6HSgcKxHDL90/C7YeHZYQfNwCvfwYcfGWZBNZmfkdUzEVJk5cPVUbZBo88AdF/tYQK8wZ7OyNdyY+WsnfDug4jDjC4QcT1nyDxyYHjTxaBIPgDAQUfP8oxHP0SHALWE2GFQ8AvZlUh622hEJAvLmrHvoCuHsyteC8aTmLvZ3ahWJYaxXN4dIZyTyVS70VbHbM5/DraajiTYlV15Llxf2w2P+AOqE4uVHjaL26GS6kaM8oxHFYWo1iReJ4FCKoSW9Nm7evY3PpwjcEf0dkavw3VrJ3fqw+Wswmn+ZexVenIk4K7Jh3eMDYhEbTFJeDRPDFHoiAjANanO5fuKAfZnPf7vNugNJwWtWT8M2Yz//jVkXH9wOBVpxy+ThD7CrYx6PQJZ2jIeV5xMWIRqq7x0Yk1EalWCrfaBc2ozf18tocfdHohGc96rONuoVHsEhtRQzJ4BQafYNXav3
 qmXtOj7m
 L66O9Yq5g6fDlic0dzp1/vxUwqNVtzP2Brsmeq6glBj2iYZH+2xNnBskpJRapsRDGB055OKuP5LRbsuGRd7HKlJSFgmdR2be2eLqNYsnhSEan0gFMZaVxs5rMNq1EQJnBVv41OeSAcnMOixHY84Kgh88ye4CAFz7MKLEAiIxSMi3y551+LPuvcLCGHertpzVI5Ejui6pJnsDbo0v0xp6gQ4tA3Vdzg2J3XLnIwBOZRT+tMzRaXikmrPAch2Nfo981OmCg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are various places which use ptep_get() to get the pte entry
corresponding to a hugetlb folio. Some arches have special handling
to compute the pteval, so they provide huge_ptep_get(). Use this
helper consistently.

Dev Jain (5):
  mm/rmap: use huge_ptep_get() in try_to_unmap_one()
  mm/rmap: use huge_ptep_get() in try_to_migrate_one()
  mm/migrate: use huge_ptep_get() in remove_migration_pte()
  mm/page_vma_mapped: use huge_ptep_get() for hugetlb
  mm/mprotect: use huge_ptep_get() for hugetlb

 include/linux/hugetlb.h |  3 +++
 mm/migrate.c            |  6 +++++-
 mm/mprotect.c           |  8 +++++++-
 mm/page_vma_mapped.c    |  8 +++++++-
 mm/rmap.c               | 32 ++++++++++++++++++++------------
 5 files changed, 42 insertions(+), 15 deletions(-)

-- 
2.43.0


