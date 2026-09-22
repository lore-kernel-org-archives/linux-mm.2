Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2760C982FE
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 06:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 765136B0095; Tue, 22 Sep 2026 02:16:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716256B00A5; Tue, 22 Sep 2026 02:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E936B00A6; Tue, 22 Sep 2026 02:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 434C26B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 02:16:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B63380418
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:47 +0000 (UTC)
X-FDA: 85240389654.11.88889B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0E2A4100002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 06:16:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DYnorSFw;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790057805;
	b=jARssEjHJIf2JRNzElzflYHls3i9juIIj0IrCePwVJrgHBsVCl0wlq+g4c8wI88fHrwAT0
	uFO9bceYLpru/zAG6niHVaJAo8310b3gtiRt/DmHiJ5MLSC/z05AXjZ8vkqzgBBne2C0rk
	ChcBh45lY1/CK5sZ/24ztkPGWYahvyE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=DYnorSFw;
	spf=pass (imf05.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790057805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5gp8Yh1jKhlm2AtA4aufkbYryyrf9W2frZ666ZiSRMQ=;
	b=xXutQxwNofbV+Ey6FnWCZPg9kPvbhaPdUvCw5NfjeeeGr3Js3TRZblw91224vSjOPpRPd6
	UXyJdmhN0+2T/jIkL8gMrgo07LH0stceVqTZ+Ic18sMIILAC1nUaNJLCVpfeFD4fit8eG0
	NLmcnVNJ+VYvDM4EwRIPMjp7WncnA7E=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7329A152B;
	Mon, 21 Sep 2026 23:16:40 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3FB443F632;
	Mon, 21 Sep 2026 23:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790057804; bh=JzDwOfDq7AeFzF7O9lfDqkWJ63pkoijMhPDQ15y0zR8=;
	h=From:To:Cc:Subject:Date:From;
	b=DYnorSFwJzWKUOVKOfEXAceBAus9Bn2Z7oVKCObx1wayxTnPlfu9RildUNRHGYZI2
	 GfTIdzLh0OKkjWBKNKgO+GpYNmt8es67/ZVKRBSfjMTGEjHWaBAUYyFDyHINRxuWsY
	 nuobtJnML9vTkixRBIpBD6WwQlhi8hl7NNTLdtno=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V2 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Date: Tue, 22 Sep 2026 11:46:34 +0530
Message-ID: <20260922061638.3967467-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E2A4100002
X-Stat-Signature: osncmym8g7zhtaj3qx7deowestk9m7uh
X-HE-Tag: 1790057804-144984
X-HE-Meta: U2FsdGVkX1/Kpgwxuu0WxJlPEpsRZdVWPLtAawvAqP9RqQhrEt6EcM++cLaH+wrFAeInaejSkKMd+ffCg4G3KU1Hxp7JX4kjCJlWz3apy0vRhniZ3EQYqjNK4odRYbN4oGtexejscH8oKDrmRveOR3lr9YnHEi/dGW/yQmzXbzoemAy7SOvBU3Kbcp/ahU7Gg++nJxXqAaqdxQMNFTIewpRxcfcrtQvytmwOswrJH84vEbeK0DmqKD8kPP6+VybmGQRHbpofGOYkXAmMNUsTPiXejS8xEcpc6n4U2Byr57erArmw7ctbQ1e45TgEu/1hzH7oB7HTMzJhBQ9HAbwb052BtTh+4GOAnoBeQht9sUkCsBaSfXVY8X6pQFMS0ucumvpTPGMS4WgXA8clFlEHwHN7RxneYplJCJ4JNK22EDnUNOWldyl+ShnEObjA8SLMb+352OO6mX0jPqLZuxkEUYFVtp8iDEkZUra1JiMTGt0M01I4E3vLZxAeHRWceP4n5Kmc6oZ/xfMicx+tr7WMh/LwoG9XgPcU4cD2Qgno8QABl23rJcnUlz0yiyUv29bfhlPR83p/FfMFuBlntpUfskk7aIIYCEBz4081Y8A2aokqTVF/bfsJPgSRcnJVn5FnuDNW2X2TQ+RWx52FOXaNObRmeice3oeYRukGGJ416Auu+PIy1L65ZCrBYHVVBsAGHqZvra7nxIN2unC6AHwvVKW+uck4GQP2oJxlgCBOpGhAzUYw1UvJ5bwq8KktcvyLfN9tnb9ioUK48QjNj1K37vy5hwvjiWiJ4IDVUh7AHnAtgbNwIkC1xB+3b11OGvKzgghG5EfD6MFhjMj631FaPRFK0THfDH12DOiOau9khB0uMnRKiKUhMF7N2+wAUEXKxjuVG2o2+NjczyAogDvzku9XrQRKpQfOl2coouImrKLGL8vQJbU6HStDCfFEQa1FMW/NuZsR31pHvRq7VL8
 yYTxyi29
 z8dtFggnABaMHvJ+jtlvW98p6bVmAzOmf6toIK+FcFikI4+5izOOIe1Fhpu68BEjcNjhFnqS5SjPLwyslbLGmVcj883qnDlHS4UMK1H5Wxp9ggMVJV/kfNkjmh2pVMBK9KS2pPbK0Dgvtgge+m1S9z+LVCjw7LZG5CDnYmH0iimuzNsGWGw3MWVdWqg7lS5BXiRIe9Vb+9aW+jhim+moL0RhEk/56hr/xZqfdPCjNpXa3GpwJ9hrkZBYK0xkt2WDeKWsg7eDGEb7eZXD6MoJmb1CE3hz9s5FYxjnZ7iJi7Kdj6T9Xzyj+DLHFhoTzAeNfT+BxSQUux26aMrzZtydYkIg3Khdq4QfSM2iAR7GaSixguqdbu1uEIGRbfkLZ36AU40DY/J/iK99ZKco60Q61QxP50rSgxIT/rtV/aJFtGpoh7Okrys92RMKjMVQmAl/MvJcx/wvHaJ/jqio8znptvBtKe9c+z5xDODxc1REoRQ4UrFSZRjFcFXi55SIElySLl/x9V7I6C4xtmUpH5XXBFukuMpNJMsLWvcZp
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

git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v2)

Changes in V2:

- Rebased on v7.3-rc4 along with all latest dependencies
- Updated commit messages per Ryan
- Added tag from Ryan

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

 arch/arm64/include/asm/pgtable.h |  6 ++--
 arch/arm64/mm/fault.c            |  8 ++---
 arch/arm64/mm/fixmap.c           |  6 ++--
 arch/arm64/mm/hugetlbpage.c      | 10 +++---
 arch/arm64/mm/kasan_init.c       | 18 +++++-----
 arch/arm64/mm/mmu.c              | 60 ++++++++++++++++----------------
 arch/arm64/mm/pageattr.c         |  8 ++---
 arch/arm64/mm/trans_pgd.c        | 14 ++++----
 8 files changed, 66 insertions(+), 64 deletions(-)

-- 
2.43.0


