Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE0C606A332
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=T2HkiMbw
Received: by kanga.kvack.org (Postfix)
	id 0986C6B00EF; Mon, 16 Nov 2026 20:28:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 049516B05B0; Mon, 16 Nov 2026 20:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2886B05B1; Mon, 16 Nov 2026 20:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CCBF96B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:28:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53106140284
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:09 +0000 (UTC)
X-FDA: 85442875098.13.6284FFF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 17C40C0007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:28:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=T2HkiMbw;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794878887;
	b=Q8gd+GEN3VlJdSdoB5NRu8I4puSTYLvpd5nNdJNrYPcHUclvbNaGtohCX5V3+PSXNppSFN
	a4bA6oKvfETmClCEX/rbNGXE5m7HGF1nYqraKGa8l5k3izVXe1nae7Ifl1tS+Fxe0jCw/2
	RxkNe7pYz0yzA00cHPb9MSRG+2uqHrI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=T2HkiMbw;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794878887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=QmAbNwXwVHKYRGMSj8CZoXUjCMLaxZm0XCmxx04BOWQ=;
	b=DMbXdsVwAdehB+RerQw0R3uv8oCUGKSBQb8CfKN31LoZAQx9xfaRPMClCd6/3xy53OmFFv
	KACpSibcY5ib+T/h2xdsOJ4N/2vV3p/fJsyv2hR6uNini9S2j75T9SDx0zGpIWyyPuk6ZC
	GL7DWFwhvFG4lsi1a9uGfwbbIVdlxys=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A729E1684;
	Mon, 16 Nov 2026 17:28:02 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DC4EB3F673;
	Mon, 16 Nov 2026 17:28:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794878885; bh=KzMaiatZ60aUw4I9YCheBFeaBAMkbjLBB/ZnXewLexQ=;
	h=From:To:Cc:Subject:Date:From;
	b=T2HkiMbw3Cp/t7RF62dARcK9xmXS5m0gMnCJVLQslW/+zARqeAZagU8k58OmxAi1v
	 n1zP+IAiqaYZEjNGgtoj+gkRg/Ot5Z9qbojXgvQzOTQ4ZZHEZ8iK8DjQMNIKBHGy8o
	 CPMuhjhVbRdpLjbmtgq1VRhxZFJwBZPCSYItCols=
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Linu Cherian <linu.cherian@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V5 0/4] arm64/mm: Convert pgtable READ_ONCE() as pxdp_get()
Date: Tue, 17 Nov 2026 06:57:54 +0530
Message-ID: <20261117012758.3814093-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17C40C0007
X-Stat-Signature: xe7rccfx85ng5cxqni63qk4i6zkw9rjz
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794878886-736895
X-HE-Meta: U2FsdGVkX1+g2Oj7R99SqTSNrC3huRxau+gCGEIDSkPs0Oqqc9tcbWCy3uUa0jbONXBBYKqbfO1eaeXWqFWK5zUbx8AwgnaMEAnvAer6FkF3MNvZwOWRwds/bHVasH3MMyXCLjjR6iU4D7H7vZn5ocX4tz5/V/ThPjj1xugd2TnSnq/ePp13gL7iig7IxtGYQgpbCmmex8olLMfbMYlD8fBseFxogYXM27Th1XZiLpORDVt1UQdF53y7dCUyRlOEaSBtpqQ6c8NiU/GY850oBRe+BX1YjINKwMzfPlL7/JX9lVrI4MrDd7NBeyrQKu8EId5YyO30exSPwwvo8kJS1YsAIhnQTroXAWNPm/jsiVvnfhZmLKi9anxyqfRo9F5PzPzGlC/PaGWsDH9NOwPz3F8/QcDQMCvaHxQZWI3QYPvrc3Y1f9DRya2TQzbUKtUjRLCoz5FYsuUnB/OW7cRM3Ff75hS281l02GAqs0ix9yx7jSY1Tb1KR1wvLjLKXVvAS/PcV+c20iVr4EhsZsZt8Y9OBB5Kg1jyu9vYc1SxionWuTlpLlJ+Av8d4XrM+6n/iErKq6yKJbrxiNo+NbH3fCI2ndJIyXgEnLsj+p7LXZev65iV+MDe2UGC+WOkxPW6mKO4rSdzys3gd7BeOg+yY1AD5VODSBwXvyjX6+yuUh8AOmz2yf88+q8N5eSyhgjcVLl0DonTeVaClFSYTnfv8l7a/0XinW+E3i8vVPatC+V04+ujnA5S9qCNI/XRFzeS94SkgjyARqlbZOIvYJIp3x7ahs9IZduwDNEpU9lKeGp0CpaIba4vrCVpLJDcd3JaBybLTzjsxGirlCYF/O1ZBVpxqj/a3BZfS+yclpAmPZlwju6zcPXazGzfozQYmMdL9g1+zWRWPEv/Iy0IWHfBHCItGPCnt5487OKKAQZyZAZcVCzT1WtQJYrMY8gjzdWyloHtnMDNiL5/meGZjJQ
 yZsb0e5D
 I5gc+wiR4QNEBNU6QSGiOyIcnlbLCIazrU6er7PzceNVmfIdrtRekLXqbGZKfZeVjYksXdpWnGY+Tq0mBhWGJ90mUUFioVucazh4KPiRMN+LqYPG0591znL92iu/QiTRZNl1fwTkMbYgSI4p40eHWEXl/REzCRAIfzyzl3G5MIxuqAFcr6LFYKJn2QgOsy3A1ggMMqVHLCG1mU9D597AeKn8D0ct8uh1Xh2vQ+pDYK8IfcRr7tO3zJg+5wpL8HRsx/h/Ob/hml1VUBAhfPtos2+z4gdRvpYgU2WwnIl0e3Hd9YV4d52uebYUPkhhX4X2JIxBpKHgYl5uGRuoDslI+su+E4/lGsPPbkHyH1vBnghNbKjRpVwsO066ApfUMRASSC+j+xZN6ljtNJNUAAAlUjzwPWMLkD1UE/dqbuoTxacDi7KVh3XPYRGSjDKFjuDP+5XzCcBWVyK6YZZMWggaXYr4NcdN+jWHJBV8hQmkL2x/PHSI0JRgi3hUIYX2YF+HyLi9L4zEUhQpXkUb3yzFbv4H1i3G/tNu2naqP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
V1 series. There are no functional changes here, and besides mm kselftests
do not show any regression.

https://lore.kernel.org/linux-mm/20260729122452.3797443-1-anshuman.khandual@arm.com/

This series applies on v7.4-rc3 and have been hosted below for reference.

git@git.gitlab.arm.com:linux-arm/linux-anshuman.git (arm64_pxdp_get_v5)

Changes in V5:

- Dropped previous code movement into C due to Sashiko reported KASAN problems
- Reverted back to V3 series but with const arguments in pxdp_get() overrides
- Updated commit messages as required

Changes in V4:

https://lore.kernel.org/all/20261105043403.3326445-1-anshuman.khandual@arm.com/

- Dropped pxdp_get() platform overrides per Catalin
- Moved pmdp_test_and_clear_young() and [pud|p4d]_offset[_phys]()
  helpers inside arch/arm64/mm/mmu.c
- Updated all commit messages as required

Changes in V3:

https://lore.kernel.org/all/20260924062214.1635078-1-anshuman.khandual@arm.com/

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


