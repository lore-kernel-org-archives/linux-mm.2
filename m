Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784D3C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 06:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CEE6B00A3; Thu,  3 Sep 2026 02:07:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21D506B00A4; Thu,  3 Sep 2026 02:07:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 133E36B00A5; Thu,  3 Sep 2026 02:07:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E99296B00A3
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 02:07:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81DDB40460
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:04 +0000 (UTC)
X-FDA: 85171417968.18.EDEB68C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id A8F2820004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:07:02 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F7O3rR7i;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788415623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eONfvIqMAd/VlbmVkZVlpsHZzjL1b4ai/JrNL/ORkps=;
	b=Mykdy4ITgWP+I+mSvD20lP1vKU0cqgSvtKgCMoM2HlW8Hwj4wvE2sirprHF72cWY0dpRxg
	d4zemxt8YGsHRHItUX2b0X8lrZwtKuyuPkX8e1IFRYzwH5oD/pKlsd3cbNKnuDs8G70NWo
	oD2wvrrza/Kcn/F8aQYQ5/bRGB2wJzo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788415623;
	b=fJMDJ09hsftFTtca5eE6bST1KVALpuPpNQM42xs3XEk9t5bhHXVNmv72oxeb5L4Tnoe+pb
	0IvRB5Jfe6twtXtussDt2dH2sIAvYFK2c5ojvPAEjGfN5b3Aw07JR2aWSuemMiMzoRlyfK
	tef/n5FLR43HJcfKhTxUS0y1A8CoFJQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=F7O3rR7i;
	spf=pass (imf31.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 251071596;
	Wed,  2 Sep 2026 23:06:58 -0700 (PDT)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2ADF93F673;
	Wed,  2 Sep 2026 23:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788415621; bh=OKX3pM6qPR5VwfjZ2I5q4WvBQf//Z/2s1Np9M3JJ/8s=;
	h=From:To:Cc:Subject:Date:From;
	b=F7O3rR7i0pqlWDozf/2IUt/ocHu0IMjyjDgb81pOXi74+CU/741Fi0vprY0V679yy
	 DdoQq86W98uQah//jiMjAmhsAFzzYyvjs0YrptVhAbTfdk1bD8KBenREHbLrjL2ERm
	 N1wc0qnGl8BhdfpI9DsVVQ+oFOgepqy7qfFT1jSw=
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
Subject: [PATCH 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Date: Thu,  3 Sep 2026 11:36:53 +0530
Message-ID: <20260903060657.2717457-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A8F2820004
X-Stat-Signature: txkphernft4i7pcxinbkywh35p5rnisk
X-HE-Tag: 1788415622-774109
X-HE-Meta: U2FsdGVkX18Z2qzh8cLEWEkMjlFKfPU4MBOeeiRVAckX3TR6fEtg8tNjvXPQbH6UkHa2Xebgh96oHnqnhS/r4zYzq0RCbsn4igBQuFodw1jMyDk6ZGb9mAFfDqGUDdWz9SalXcjIXv0Mjq8v7tnFBFUIi/KDlq7twV801ua20ah/I4WPBF+fgShMatZ/181HF6M7nINlqrTeJAUzMmXy/M9LuX86Y7XZI7NmW/skVbExiJtwJghT8ckgWwFsI42K8zWdk1LxbT8B00KkclQ7u0cRN5AitR2LfRb6MZ8qQzVpBeqpmttMeNJlNiEHvdIY0F/oOUj5UuTUquyQ805XbPX13q790WUthOpBR/5cR8MBE/M3aW+X64IEE9eEUMWkz0dV/3kEI4FVShLxCf3y2d5Yr/l+ZXcSIz11ouMRv2492wdpfPCSfpx0QapLmWdrhui3RLSVvgrKRPQ0sjnM2yhSFVIqhqdp4bpIwcKcmr8rkDE1sDwr6B7z7sunu7IkvQwSXg60FpkcGHTCvSIz2whe7/MF+wS9+LlblX7jnEcSeWUeO3iYWXuaWP6wWBwxpXEEirPutxmxmYeoUOTRWjbM22DAzcHd2eSkENw7fhBg3Fnh78FdJF3t6uFfq7NpV5LRXO4UX/20vQnFNVEQqkSzAQ6f4CPb9ui9X+hm1HQ/opI49e2qWt52lHj79M9sbgOiMYXF+bABQxgnh46uIvvE5Uqjj3XCvdzkPqjuTmSq/WwEsJHjZiln5CST4D/ThFDVa3D7R1zpwC9bONYAZn2UsMQVGnWZpEsvbWKFuawTGRl0VRmvLujq4HHPf2SUOIkPUDSFyC4zZyuC9fA/Adn+rEysLXr5q+tHODpEh2q2ARqriCUIvyY46Dm8qzKb0MAqee4CN9YNw7ZWQHehDui6reQyaU60ApppxGB6wXDKe6KBTbS9CZdzBIF9PRAQzVYmfB7sJqDPB1yg3tZ
 vDsTQnaj
 BUVsD37qoW8xkd3WAYIRX+soOXFuBuENGInMNH0LSH/Ukdotvv3S448Nexdxu5C3OfMb0hllgZCXFRbHZjNdfkF2KCWO2suTIraT5xBAeBVplb77B8FERnvv4NUUwatg+A2Qed9dU5F8o1UyfC6KysTjUsfUo9c1+Izl5W4azlfJ9720FlZKOmDmeyKwlUDz42BNHyFaBhVojpFwmwQq8qqTgdZVFU6O14+N1+RJLZA+mR9pzwZRJkHn0Enh5XnhddCSvdDamrWcDmxBrcBrLwyMTOQqqTkc1mznagWlVVXsEK3VZ8jlGeSpIDmP55G6z1BrjZ2YN060AFoA+2Xk0ApY4fQ7q0J8WXvbgVM3bA4eLhv9RKvMPQYKzC8BG7mPX6qZWTnopa/bKoGeHt7TrnEXzmbhG/a5m+0ImtBFOYDaMVcGGmzA5iqNtXRd2ASQGyipOvr5rOgux7WHrEXL1lSwloFAvln4umqdOYyheo/A9Zg+wFwcj2SSFHR0jhCrdOp9G9jNl8kSWZmsjTrwPZ0giTtqov0u4Ztlv
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
current D64 translation.

This is similar to generic MM, where all atomic accesses have already been
converted from READ_ONCE() into pgtable level specific accessors.

These are preparatory patches for D128 enablement, although standing their
own for D64 translation as well. These patches are split from earlier D128
V1 series. There are no functional changes here, and besides mm kselftests
do not show any regression.

https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/

This series applies on v3.7-rc1 but after applying the following patches
related to pgtable entry print standardization posted earlier.

https://lore.kernel.org/linux-mm/20260831054331.625505-1-anshuman.khandual@arm.com/

https://lore.kernel.org/linux-mm/20260901065454.1906343-1-anshuman.khandual@arm.com/

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
  arm64/mm: Convert READ_ONCE() as pmdp_get() while accessing PMD
  arm64/mm: Convert READ_ONCE() as pudp_get() while accessing PUD
  arm64/mm: Convert READ_ONCE() as p4dp_get() while accessing P4D
  arm64/mm: Convert READ_ONCE() as pgdp_get() while accessing PGD

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


