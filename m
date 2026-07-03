Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1CFBC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 11:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 449396B00B4; Fri,  3 Jul 2026 07:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FA486B00B5; Fri,  3 Jul 2026 07:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBE76B00B6; Fri,  3 Jul 2026 07:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082286B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 07:42:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 68463140495
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:27 +0000 (UTC)
X-FDA: 84947277534.05.9666511
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5C0B240006
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 11:42:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tU7XRuHL;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783078945;
	b=5vmmKmLNaj9LOa6480ENXGkDn6rfimOWujxImWiV2mNMvKf0DF/WrvRCmWtYwTuG6iXGVd
	zFKfPY68zNKcIAdIhf61SfEp95l6HulycbQDdyjRqNufrwQpqEqdXKDcZu6Nq05dfxJscg
	xFTkhtn4JAgLqgbWw4w4PcosoWGKzL8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783078945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9HuOiOpXWxzQFq7LM08YqEZVME2FhpwkWkeqQztWEGM=;
	b=X13ZmxgezYAwpKcJ+49tDACEShbmuCghMmVClOgGNS7A9LLgzptVt+zFhMSkpYMwG1ozZT
	R/r/h4HS1bC45btegdyxz2Hnwx+bNn7p5GGP6ouZT334oudUGU9Y48QKlE3sXFJPjZHls2
	A7sV7n46pmUiDC+xl67ae4zTJaSvOcY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tU7XRuHL;
	spf=pass (imf12.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 85C691F91;
	Fri,  3 Jul 2026 04:42:19 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 9D32C3F673;
	Fri,  3 Jul 2026 04:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783078943; bh=gjAG24FmQiHMD3ERiShpuM0M9pe6oRmukL9/yTrH5G4=;
	h=From:To:Cc:Subject:Date:From;
	b=tU7XRuHLJ8qyLSmm0z3GT/NObLP7sbopONklJMUamJbe4XQiIsNTvQhhwaMeM5nvW
	 UfcASUHl08SMUxPmqsVcp+LGj79dgKL8jhPQuukkEy0RhyyW6gwnpfScCLO6l9KK/M
	 JJVfz/sfLE7mngUB217h6HcadLLuV+4raCBnC6cM=
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
	apopple@nvidia.com,
	rcampbell@nvidia.com,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	ak@linux.intel.com,
	nao.horiguchi@gmail.com,
	mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com,
	pfalcato@suse.de,
	tglx@kernel.org,
	dave.hansen@intel.com,
	jpoimboe@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
Date: Fri,  3 Jul 2026 11:41:53 +0000
Message-ID: <20260703114202.365553-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5C0B240006
X-Stat-Signature: a8y89hurzx9nrsshmaytd5u6izkfwfpq
X-Rspam-User: 
X-HE-Tag: 1783078945-701359
X-HE-Meta: U2FsdGVkX1/TdZCz3eAqfxPkOw0/1iVG+CtFGOvy+0CgoCMLPtsNrVRsNnlwJTkga6qZrb7d/8eg1lqSKY87PqIIBPKtkHQA8iYhN77I34v7EcjdfZyMuvXkJ93/NkJAP2MsvY/8SnpYJYbcjad3hrIKU9JaqtzxxjrLUSPk+7XMImm8g4evkCT1ZGfb98TjIHlc5jFqb+kRdRT94mCpB9I3gpm368io09I/fYfgb79LesJ5Uw3F4AImScyuwUysiVqiC+niGF3iR5RN7PIDgUKxxWzL/VkdlbBVn3ArYdzfwXraTEew2PFWfJDU34ntOIJB/ImyOsFQr4K0jiV7BqchH049ZyWSIxT0he/Sn3c/hIKh/vqjiMJhHO8gcjtlULEE8pq0JzkUDluvyHjv62OGG7aoCYvpnn7db3ZxcIF5OIfT0v1rwRskiEwvsOG/2fS1+ewm5jHi2FdTAZVbUx/LrsBqC4+z3n0OpFYrcZgrtzSEFxc25kZn51vWFMwkPN56F3g6IAo+LAsVkGGDmitjSQINVVMG2Q4vGRWO0hie1cfnqexOhVQe0mHzR6yS6KJ1Qp6UQec+NWCbZrDeuc9/fIup1bDAphvNa4jYCpn9iLer+pvZKcw3r2Cdsno7h5czBm2kiCVkrg2zSOM+9AEY6tEhCupHKNsqzz5m4q4wuELgv9c0+1/7NVZfOGF60w2vo1jv9A7pABHGu2Xqj9BgHGsi48qRWhyM3pko9OukYEnjEqyk2TyzeMHQd564oTCZZM3Z2pkxrJsNiAitUkdWTNY4vwx0NNWM8U7IqM7uwYVGIq9VO51PXa6vVRyTXr/ZWKfge1udWu0H9ClJdYTdHdDta71X1F1b6Q5TF7VUC4RADEIUFDCb1grzppmAmkTdsj5zaZEe4zSLsqyt9PLgat5W1o1wpwh2IHfxyG7PhFKh9//Ji7X9XQYKLHpfTvQKgeYYUduOjtlr+F6
 Z9BAVrk6
 hv8g3xX42E2QrXzoQN+HcwtfEIAP4V4wy1ktEfazD88tU3UhP8BM8iHAzO/OpOHTuuOwAJ4jGDxlBaIekO1gy5BlGVXLvnYvTY2qwghA6P3phb1mBQHT+CElFToCIt515kUbqYV4XIEAmA+BaPJo0MyVDyPdVnYW+OSXxElQbrOmHkyuWHYfWEgJ5r4BjBb8BVvvPNSsyaUY+QiXGKZZmuJwunU40iFgK6wokW0l/Q+RW5w+DznPpmOhbP6KESUOIj8lE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are various places which use ptep_get() to get the pte entry
corresponding to a hugetlb folio. Some arches (like s390) have special
handling to compute the pteval, so they provide huge_ptep_get(). Use this
helper consistently.

Additionally, some code paths may provide huge_ptep_get with an unaligned
address. This is a problem on arm64 (I checked other arches and it looks
fine for them), which is fixed in patch 1. The fix is made to be
backport-friendly: the cleaner fix would be to perhaps pass the hstate
to huge_ptep_get() - that is wider churn and we can do that later.

---
v2->v3:
 - Place comment at appropriate place in patches 2 and 3
 - Modify indentation in patch 2, patch 6

v1->v2:
 - Add patch 1
 - Mention s390 in cover letter

Dev Jain (6):
  arm64: make huge_ptep_get handled unaligned addresses
  mm/rmap: use huge_ptep_get() in try_to_unmap_one()
  mm/rmap: use huge_ptep_get() in try_to_migrate_one()
  mm/migrate: use huge_ptep_get() in remove_migration_pte()
  mm/page_vma_mapped: use huge_ptep_get() for hugetlb
  mm/mprotect: use huge_ptep_get() for hugetlb

 arch/arm64/mm/hugetlbpage.c |  2 +-
 include/linux/hugetlb.h     |  2 ++
 mm/migrate.c                |  6 +++++-
 mm/mprotect.c               | 12 +++++++++---
 mm/page_vma_mapped.c        |  8 +++++++-
 mm/rmap.c                   | 32 ++++++++++++++++++++------------
 6 files changed, 44 insertions(+), 18 deletions(-)

-- 
2.43.0


