Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07735C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:01:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E13DD6B0005; Mon, 13 Jul 2026 01:01:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEAC06B0088; Mon, 13 Jul 2026 01:01:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D26A26B008A; Mon, 13 Jul 2026 01:01:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B0F8D6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:01:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0B4D3120A97
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:08 +0000 (UTC)
X-FDA: 84982554216.28.A9C3513
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2274D140009
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:05 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=agt6Kmhk;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/wg4NwuokG7aKarDThnCCrUPfmFQ4fLWLc1g7Jr2/KM=;
	b=t5LoxKoqs/z/40iGuAhX844CA854vikM0ctMwKOSMGFVzaNlga7cilwJrQ8qsmx6IWzhwJ
	VHnR5v6SCw9y3KDVfLjBS6/Z2HunA8dcbY305DGG3PTMqPCldNnZUsfLiz/GCB+GoImAbT
	zrkZWyG+nVM44D4n9AQJO56wh4Nvmwk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=agt6Kmhk;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918866;
	b=24fop6ZEmRKBOwxqJXQhF4ltBOnqpRfeakIK4iuZY/8Ohf6hjaYHMBlAb7Lv3sUBuoC5T4
	aVR5qWsHgs3mU6AxdmtkcSQtHklZ9I5BuLhYUgBDMBhLuiUbIEQ5rdqUKwceoAFo3zOxQv
	xrKo/ZfdA5OhaO6TsACssDhM7Yuk0fY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B7959497;
	Sun, 12 Jul 2026 22:01:00 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B29AF3F93E;
	Sun, 12 Jul 2026 22:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783918865; bh=CPHFu/HOUKfGUBhv1RIN/ECa0WyCmUkHetizFU3uUJ4=;
	h=From:To:Cc:Subject:Date:From;
	b=agt6Kmhk10EuC+oLXQPFGu2ZK+BpREh3mJTtgNRzoZJ61TeDXZHENPIXPihq5fZEB
	 F5osFeXgTPcyImTqXgC9XWC31TDBsDIUN60pWc55Z7CWAozc2pa35AmReWYzUH/cfL
	 bYdHo5HtSyeRL7HgrZ5tXlVOSm2shXf95LGTyAuY=
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
Subject: [PATCH v3 0/5] mm/rmap: Refactor try_to_unmap_one
Date: Mon, 13 Jul 2026 05:00:43 +0000
Message-ID: <20260713050050.1017741-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2274D140009
X-Stat-Signature: gopn9wxs4zkfx19q4denhtchx419cweq
X-HE-Tag: 1783918865-432514
X-HE-Meta: U2FsdGVkX1/meJFp9A33Ha/LfNPQ6Gaba7rf54HmklBDNEyagP6AlTBKI3V8u6QPY7rnY/sudxGpf8DOVZqLvMyg9wFcAI8puaJ1RadPWDEdeUXE5In+LLvyBS5ODBw9CM9vDq2dRWcB0TU80wmEonYbce4bS8jXYFoIuTx5IsMU57qRXbfArN2kdwA5gx4iez8IuclxN037njIuyd8NBMFPNhSDAI1SUcElQWzuEQuCITlliVk5GX4afl/UZ+nOzv4IVhttp3TYDU0z7feTDMsnnvoZZ1+Iu5l2N3DfiGQRR7X+ICdDLguglGpKl8n50hqj7L+2xjwncXx3keu8tZXH8YWMfgn6kWmzqFwCB4K0KuF8crwMfRkiwh00r028PefwlRAzm2LzuPjIT6wrb61sC2NEou9KUMxp/tSJFUa/5gBY51Glv0KoqaaJkxdwdiakSSpSHYm99Kn0bdAghng7zTgQeHDQqbSHGbSNXqq+Q1+39WysTKV8rz9DjBhe82VXb/lCiK4lm4oWuEBRrCOxoORU2XSChy+75PI4g4st6a0TfDtzIJ+kinKjdD1RqI1y7/Igd/YAaNZ8Az3H9u/L/mJqh26YUdI9OoP0DqCSBW7+ZNhxy+VZ58ytUf0gTeHyWmWXiw7HoF58y23p4d9qEZ2awUPRTgDAroRcfpG88XGKxImDK2EstU9w82vco5EyQm2gUsWDIFiG/tkpAfIScjv/Pyu9HXHItF1n0TA1L5onPp8uJwVFhfFdUISZSV4Ou0xwWoJ5XGX5rVb70YIWo0dugqd27TjbQgoTJRlGBmhBmgP39p1OjWKmiAsr1hPRtreWuCF3qNa6daJruCzjuJYzOgMNo7bqHjcf1RMZ4KRePUEsRJsZxQUOgDsYzS3LLvqu+CSLZpzbU843T49VIbOfdsko8f3AwNDlgHpCBItFmrdGRylPCIF04N5OmtV6PVTwEkAjQNfUWh6
 GllnQOM8
 Ji0SpatPXfWkXNX+7m89N6irtxXd14lHEVI5Z6gnHjyzQDJxPDFLQsEqA3rL18Jp1wQjC2NKRobls7IpwuzHUYrJH7qZrbukOukiOFDR3hvp8Cxw1xkDVcqCXgn1uRWfNRl40Vu993kkcraTbT8dZ/FTvrtTWhkpZqYyXkQ8KiyM75Wvd5+wDD+EH6Mz+f1CCRH6X1To+PiQetT01ReArMjDJcFboYT48ozb/auBXTV1ObOApEg8z/AvHPoneU/4HbPHvat1rfHYtGhhVCDMkFkXI/PPsMhY04HeDeN4dfQ2/E38yNrG5Cc2LBq+jKr8GwZSy
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

v2->v3:
 - Patch 2: fix comment to say that TTU_HWPOISON can be true for small
   folios only in try_to_unmap_one, since hugetlb bits are now refactored
   away
 - Patch 5: Directly do if (WARN_ON_ONCE())
 - Rebase on latest mm-unstable to resolve conflicts with 30c83145c5b3
   ("mm: rename uffd-wp PTE accessors to uffd")

v1->v2:
 - constify ttu flags in try_to_unmap_hugetlb_one, move const variables up
 - Assert address passed to try_to_unmap_hugetlb_one equals pvmw.address
 - Patch 3: code and comment polishing, do the stat update in the function
 - Remove unnecessary inline hints, remove set_swp_pte_at, instead have
   swp_pte_prepare + set_ptes. Rename subpage -> page. constify
   anon_exclusive.
 - Do pte restoration in caller

Dev Jain (5):
  mm/rmap: convert page -> folio for hwpoison checks
  mm/rmap: Add try_to_unmap_hugetlb_one
  mm/rmap: refactor some code around lazyfree folio unmapping
  mm/rmap: refactor anon folio unmap in try_to_unmap_one
  mm/rmap: add anon folio unmap dispatcher

 include/linux/hugetlb.h |   1 +
 mm/rmap.c               | 415 ++++++++++++++++++++++------------------
 2 files changed, 232 insertions(+), 184 deletions(-)

-- 
2.43.0


