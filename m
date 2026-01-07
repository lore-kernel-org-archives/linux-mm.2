Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6110FD0D142
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 16:48:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D4396B0092; Wed,  7 Jan 2026 11:48:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 657A66B0093; Wed,  7 Jan 2026 11:48:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5632B6B0095; Wed,  7 Jan 2026 11:48:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 435D06B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 11:48:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D99531B26A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:53 +0000 (UTC)
X-FDA: 84305752146.26.5A1969B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 089174000F
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:48:51 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767804532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=bzP4kWim77J9cDILlLn063EiZz4BfhaYj1KeIw4waUw=;
	b=sR2aBLKjWy2u44EgrXpeYjy05xqDmJ8/+mqEfegpO1zfUu6R1akyqJKJF0AjRkRkTOfexV
	pHpAYh7pOn74j9EfmYwzPIhqHw/of/tWOolbaLB0aAHNMa3dyN8vBIwqUnoTmi9hArnUHN
	o9xqUEiXvRMosAGjG7zpg/E+8AOPGNY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767804532; a=rsa-sha256;
	cv=none;
	b=oKJpoAGODTmn8hr45nb7onvWxvKUbHuHhsdzWlimzKTve68qiopgReYCku+JaKu4uTX7wn
	1WSpNS3V5nWwc3xAj/nVqjtzuVRbD1ZeVkRMR52siGbf4xYRZ3vFYR0ywQFSCOM48OYGIC
	sAPTWiQE+UPVYFWwa4STkww44hK6YGE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3409D497;
	Wed,  7 Jan 2026 08:48:44 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C0F2A3F5A1;
	Wed,  7 Jan 2026 08:48:49 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mark Brown <broonie@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2 0/8] Various mm kselftests improvements/fixes
Date: Wed,  7 Jan 2026 16:48:34 +0000
Message-ID: <20260107164842.3289559-1-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: nk53kai4tcgt1nz1kq6dmiib3jazxc6t
X-Rspam-User: 
X-Rspamd-Queue-Id: 089174000F
X-HE-Tag: 1767804531-608605
X-HE-Meta: U2FsdGVkX18+pG6KWandSl/5AZs5nwFpjsyB1xpNByX9o0+kQvr55rfSK6dCnKxnjKl9RgxpTiWUPhrWuGQUwP4Wbsp+Zl2wPe7rNtaA9UkjYM5Sw6nTM1ysIoCc+yFcOcbKxbhFjsLeL5FT6oRs96E+RhElWXQ6fkN5pfhNrjYGeJTdp0fO3yt8lTMFItEUd/jj/AQ57lg3yPyAXyJWosqHpTaPmfJzxTZXtUF68efAbhoBMXYuOVBpeLCEeuDiShmqSOxNFkycSV0j2SfTcwMnFe8Hkr8VoYDC8dhYfFmlMLJ+vwtA2vE0a3ZyHrTRFGIpwTiu3VanB7kStcCdiwG/bz2hpu01Gz6LtPUIL5w9DmbmqvcSto6nlEDkJixlzNjghyP6EneL8tsdIFYmRJz2/rFKH2YrntAxdt+KvN/1RkLDPqE3ci82WSlEBG0qo/3zL62Kz9NnV44kXt48OzFSJZCg2PV+WgVDTRztdXrCCeS4ItSsJ1Gds40tDEIjVfbkC9ZGcmtzcALVrqILX+OXOsxzO/3JvlEK2H9rKPiMNC8P1DMEH66gcCeJjfUHNGPOoqW/nogX82M42zbc8DsQBv0jkdhr5mPTY56GcF0O+MDtNzrLrwbW6qJX42mfOEz06ljUuAn4Mf/Iah2UopiRuo5H6o/ANnmF+DwjrKd2MRdW/MQQQtNAZH7KyqOauRh1K4nIaU52YJaJMojqYA634EOqPlcBg3OVqGFd3hGgGlDiIt9CXiiUtUlxdkfSQNcyeycbgFisrgPtiFn8d2PeH+YViXr/vgmD+5uqitI/tLvdquTaBaDJRE+6KtR7m0aUkj+tDzabbvpXk/RokQDRIY5I55sWkHhQiOlAXfXyXCuJ5N1Xa3QByS/OtqKA+WihI+Jkg4RNzlAX8OflXfp75QXSJG1+RkJ202Ib+3YXmB7cVkOVZaUISH3vZIeswR/B/spjo17PcvR9rvK
 AdV41NPz
 McYAvJcFAfahuqu3I66obljiSYCPjTzqsJEpbfRJ2yRqXx2XCGg81HQ0zlCbgEs4qX+jUVFrCA2PbNXT8imCnksE4/VN2w17N5a9nORvQ7sM4KZXaiee+nSBG9pkxJ3YdDyRTaCLCmqfv76xANEcpHxBVWyW15BTX8F84cOpLDZn0okFAlnOILS8yY1e3dzdwauKZNoRDYT/cDItH0os00fvEvcRkjQdgXVKzJG1vX8zMW+FrRYzGiK5YcCKlKi1PFYuD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various improvements/fixes for the mm kselftests:

- Patch 1-3 extend support for more build configurations: out-of-tree
  $KDIR, cross-compilation, etc.

- Patch 4-6 fix issues related to faulting in pages, introducing a new
  helper for that purpose.

- Patch 7 fixes the value returned by pagemap_ioctl (PASS was always
  returned, which explains why the issue fixed in patch 6 went
  unnoticed).

- Patch 8 improves the exit code of pfnmap.

Net results:
- 1 test no longer fails (patch 6)
- 3 tests are no longer skipped (patch 4)
- More accurate return values for whole suites (patch 7, 8)
- Extra tests are more likely to be built (patch 1-3)

---
v1..v2:
- New patches: 1, 4, 5, 8

v1: https://lore.kernel.org/all/20251216142633.2401447-1-kevin.brodsky@arm.com/
---
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Shuah Khan <shuah@kernel.org>
---
Kevin Brodsky (8):
  selftests/mm: default KDIR to build directory
  selftests/mm: remove flaky header check
  selftests/mm: pass down full CC and CFLAGS to check_config.sh
  selftests/mm: fix usage of FORCE_READ() in cow tests
  selftests/mm: introduce helper to read every page in range
  selftests/mm: fix faulting-in code in pagemap_ioctl test
  selftests/mm: fix exit code in pagemap_ioctl
  selftests/mm: report SKIP in pfnmap if a check fails

 tools/testing/selftests/mm/Makefile           |  8 +-
 tools/testing/selftests/mm/check_config.sh    |  3 +-
 tools/testing/selftests/mm/cow.c              | 16 ++--
 tools/testing/selftests/mm/hugetlb-madvise.c  |  9 +-
 tools/testing/selftests/mm/page_frag/Makefile |  2 +-
 tools/testing/selftests/mm/pagemap_ioctl.c    | 10 +-
 tools/testing/selftests/mm/pfnmap.c           | 95 ++++++++++++-------
 .../selftests/mm/split_huge_page_test.c       |  6 +-
 tools/testing/selftests/mm/vm_util.h          |  6 ++
 9 files changed, 84 insertions(+), 71 deletions(-)


base-commit: 9ace4753a5202b02191d54e9fdf7f9e3d02b85eb
-- 
2.51.2


