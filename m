Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 754F5C98314
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 06:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D156B0088; Thu, 24 Sep 2026 02:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34D416B008A; Thu, 24 Sep 2026 02:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262676B008C; Thu, 24 Sep 2026 02:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 086EF6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 02:17:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E297160275
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:17:24 +0000 (UTC)
X-FDA: 85247648808.16.42BADD4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6CC8D1C0007
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 06:17:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ux0yMa20;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790230643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dq6iKB7XuGLS2dYWQ+BSXdf1EQXXxd6p2s4tq3qcm3s=;
	b=DvmBxY/Nhf4YPQ4nXxEKe3l5jvHWhNqgvkpjdw8b7MV1WjlQXVo7gUIZD1fUGpx8FiRCiW
	29E7m3gyq4TojHbVy4xoevsKOd8PMSSc2OgU1MIBcMqX1VzUvev3UA8gAxqL7d+39PtxcI
	oyi8O5s4/uGEthmX9uGw/qSgeGB8cc8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Ux0yMa20;
	spf=pass (imf18.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790230643;
	b=Bq83nUwysepHEYLGeUbdwOnLqlogSYd1IhT3V3p3S3MfRENWoswY4NXBS0BB/e7rQy4sHT
	BzA39y0oopMQJcDpxSczcK+Qlf+gRf8Rpia4tHzWodJhWNa35m9PJxsZPwrCPzRrCdt0cd
	ZWnmmDwHkZle9cKpu2ZA1LejBKGukVk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BCD251516;
	Wed, 23 Sep 2026 23:17:17 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 80A633F86C;
	Wed, 23 Sep 2026 23:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790230641; bh=AFiGAJeNuge1xk0RxTH5cvykdnaiOpoKLFWNCrc5VLc=;
	h=From:To:Cc:Subject:Date:From;
	b=Ux0yMa20xD/2pizKV+EUg6uTTPx9s4FJxxgcbNMmPvekPo8B4aJR9MXoHhH+t2L7W
	 NK4M5t4d13cM+E9F+DNYFh2L09/ftfynSZIxWir6VEM9KcibMaNbHJ/abC9ABx5AkV
	 r62BXL2nyMMp10fBan0L+9IZ45bY3zvaBpC/Ue0I=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH V3 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Date: Thu, 24 Sep 2026 11:47:12 +0530
Message-ID: <20260924061716.1634555-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6CC8D1C0007
X-Stat-Signature: p7zb8k8y89qskepib9zrhe8aqda7rru5
X-HE-Tag: 1790230642-703025
X-HE-Meta: U2FsdGVkX18k0ydKD10VE7q2QkBZPFByDQb8s3hoRRp9oaR7OxOIzY8YosQQudTQ/db16exhbc/obeNcH1JiR8auggpE1UveXqBXpp0SDGM13meQkycwWPHSS3m4dNak/pQqH5hzjCIZe/Um0Y8MPr+idp5j8Ac7TfYjXG6ajeyMQs1CBXpty4slPdil1k5dK9ASEpCdzVDIqj+3dhYlmSbw9MA0aROUj9ANxAx9ciSkhIP0bNwboi/4nvGg0jLHfG1NjMRlscANqf3yQaAZvKAzO9LQtIyMTqciHlcgg6/V0yOkV5LfyEiELVIYxqE1rCayA4YK8CyFB0b9RkRICucFMCUCGLy3BH4l5r1u/WUWixJPGbYmMEWO3YgD92Ir7NC+rcJv14vqu/sZFb532+KULDDwkWQ3mncbTPL3Tti3l0ENrr+hIQ+8VR14+JZO8CNM6qcpwXdskZeyVr7GeIRoGQ+sGMggySXCwejsRADmRByER1xz1TG3cWP8LTrOZiyHKII/Uqq9eNcSsFp7ZLTUF/4rhP0ruWpiUVAZ6dTbp6GeD5O+Al1tN0qC7ylsQwwYpA9scsZ6ru1zwu0XoXL/U8bBLKzx0wEnbmhgTHW12BAZekggGQ75+wF2/y7oYG+ClBYrsdwUlTdOFUwiVn45u11I9yhwdtxpE9sgOjkBeqGo7zrJMRyEgVWplozKJAJHgGPOnZSkwDTpWbTkysnZHUe5SHHmq5CsDXrWD0vUf/qRwnZcUVCh1Jsw0jn14MVs7o/+R+0Y+DlNtk+ODUCYYFqg6oFhJXVtJsjwY/UaYfEEhc6qiU/RJKQtaPi9QyZ7gmYVc+egdtnE9CSfPhzUlH3zrqU4MiGHM7LngO82qS+t0NBj/F5dIp4aev5/R/+Oamxugc+73ycJzRQCPUpeJ0Hx4k3bNUFGhN+cIpjUtRHdGPozD6uLTdGGlP4PWu94iIqVmO0xYOpaTGW
 1DXakn9R
 tQYy4WNjnogkPn9lJmezP1JK+GbG2nXnE+oqOML/nefhOM9ixJDMdjr7TzZysFF6TqTWnDL4QgWhaSKxWQMjd0zYxVS7SG8+f6knnoh0BpXTqzwWG6yCO6NrSgitS7xCVl6AZPwQS2ztCqy/ek67h/ym1MytulwqBnMGrykyihK2jfKgdFtgt5fH4ECgQnKSCq7cq6dMFTP+/DlCsS40Eajpb+yBu1ZSZz0hCUcxrOo/9CniPNMuShL99lv17r3zZU77uQYeOQMoTNgRjPOSyZs4QNKQ1zI+kEhgPi1y2dd3c3nYzDVy1VvxXGb9wvCSwfjxRH4Kpft+nCFdvJYfRFP33gC2RxyO0ChUVBdx783tLDh4yHyIHYVZW7AsQW5EEaPlWQShVrrOXwXJvayqrUJVwxIrjwuQvg9HIFkySCg5WeMh0lDv9x/itlesTfCmhU7QVgl++w8iKvKpd8UUEKK/bYxagDTeYwNO1+EMZEpuVO9cACsqFS+uuWyDT+U7mvbkDGXGgPf0IRfL/HlnAL4qOKI9+6JPbq93f
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Route READ_ONCE() accesses on pgtable entries via level specific generic MM
pxdp_get() helpers which platforms could then override when required. These
accessors on arm64, will help in ensuring page table accesses are performed
in an atomic manner while reading 128 bit page table entries later. But for
now they just default to READ_ONCE(), thus preserving existing behaviour on
current D64 translation a well.

This is similar to generic MM where all atomic accesses have already been
converted from READ_ONCE() into pgtable level specific accessors.

These are preparatory patches for D128 enablement, although standing their
own for D64 translation as well. These patches are split from earlier D128
V1 series. There are no functional changes here and besides mm kselftests
do not show any regression.

https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/

This series applies on v7.3-rc4 but after applying the following patches on
pgtable entry print standardization posted earlier.

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

https://lore.kernel.org/linux-mm/20260916044933.2689426-1-anshuman.khandual@arm.com/

These patches have been hosted here as well.

git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v3)

Changes in V3:

- Added overrides for pxdp_get() and replaced remaining READ_ONCE()
- Updated all commit messages as required
- Dropped previous tags

Changes in V2:

https://lore.kernel.org/all/20260922061638.3967467-1-anshuman.khandual@arm.com/

- Rebased on v7.3-rc4 along with all latest dependencies
- Updated commit messages per Ryan
- Added tags from Ryan

Changes in V1:

https://lore.kernel.org/all/20260903060657.2717457-1-anshuman.khandual@arm.com/

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Linu Cherian <linu.cherian@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org

Anshuman Khandual (4):
  arm64/mm: Use pmdp_get() for PMD accesses
  arm64/mm: Use pudp_get() for PUD accesses
  arm64/mm: Use p4dp_get() for P4D accesses
  arm64/mm: Use pgdp_get() for PGD accesses

 arch/arm64/include/asm/pgtable.h | 40 +++++++++++++++++----
 arch/arm64/mm/fault.c            |  8 ++---
 arch/arm64/mm/fixmap.c           |  6 ++--
 arch/arm64/mm/hugetlbpage.c      | 10 +++---
 arch/arm64/mm/kasan_init.c       | 18 +++++-----
 arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
 arch/arm64/mm/pageattr.c         |  8 ++---
 arch/arm64/mm/trans_pgd.c        | 14 ++++----
 8 files changed, 95 insertions(+), 69 deletions(-)

-- 
2.43.0


