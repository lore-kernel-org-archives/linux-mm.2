Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C947606A331
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=YJZbGCTi
Received: by kanga.kvack.org (Postfix)
	id 142446B05BB; Tue, 17 Nov 2026 02:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 119BE6B05BC; Tue, 17 Nov 2026 02:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056BC6B05BD; Tue, 17 Nov 2026 02:06:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BA0D66B05BB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:06:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEC041A036F
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:44 +0000 (UTC)
X-FDA: 85443728328.20.6326DB5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6B0D7C0008
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:06:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YJZbGCTi;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899203;
	b=xqJLvCxkxxZ1GxmyfKQ49koETZNBLzBEAeeBgjKzHMG9FA10vGKA+OXU7hHFhLZGA1VA9v
	j5dMZQGB6zTpNeVHFSHGs2oZ7kI0FDW9eBpO9pCJsrqNvfHkdlbm/RlqBHuNlbHP6iBkBq
	gCGMlch9f1dK/iThrlP35T6vWvMt+48=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=YJZbGCTi;
	spf=pass (imf10.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fwD0hDfcc92kFulqgZu2fazrryJJ+jqrlv2x46MWAcY=;
	b=rA+L2Pxwr5VT7qq0ZibLzWshO57J26RMwi0vYnlRbwk3gPLRCrxXFtXPFhtk5N9C1QFI2v
	566Ab73ky4ZI8dn61Cwb3YJigkOzrxCgsCoqVfgeEVB5+JLdjJRNVzKLr+7jfqJyWNtTdD
	CWC/DgkWNQtpoeOGjNeJmYJbH0dNjiw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0547A1476;
	Mon, 16 Nov 2026 23:06:39 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BC7B3F763;
	Mon, 16 Nov 2026 23:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899201; bh=yC9GXzENjJXOH1CTrLMyqmXybb56e7XRWoU2chaI4Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YJZbGCTiaza4+J6dPT6sY5RGknZNH3VGE6ywRMul+CMVUbZZ4eEq2GKeZa+UFBSbB
	 o/qcSOJeyt86zlE1xaHPJF+y1DvtwocqSnPsKBVFiFU8rO3EZmkAmOJsemMGEADWXi
	 xZLZDQoeueKVMlpUTcASr7kg9SSrSe6zPD3nFNOg=
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
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH V3 05/14] arm64/mm: Override read-write accessors for vm_page_prot
Date: Tue, 17 Nov 2026 12:36:04 +0530
Message-ID: <20261117070613.1183243-6-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6B0D7C0008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: rstahmjgjx7jqbpedusronn4tjb83h14
X-Rspam-User: 
X-HE-Tag: 1794899203-288181
X-HE-Meta: U2FsdGVkX1/h8Zm6ajMy7FQe+3vt4tLCJiwltfvgL5ystCK//a6c+muiHCaxH3pNO2kk7L0lYEWlI+nNvFu5XglJEK06APbrsTKp1MwWT+s+vGzx602q0ac0gPibFzIV8sFNczG7udO4E29bey9zltGFAblZN4JpEOghlFArmbd5MaKLRCmyEDFDO5qmqYL5fLXdOcGR2uz6yg6IjBQsqDC7pDbQn6jiqEmaGM5hw4NLpD5Def5jpkgwmkppksPlGqXMA3aR8vZsGwX1Lr/5gH3stkWV0Fbd5unE3VCI2ShYqjnZDbHXhCd1bN1IAZjs0DZL1vKDRNE4qJLP2fkY6Mz2olqglRtCBYqqe/1UOzb0U15ytK3bN+km3TU9lbqMTVs/DwYU5cpMYBv3BDKdmyBav2GGAEQNAkkxeogr1QZk+DQddluHzuB3yNL3JHipW33EqW9EewXYNSYYOP2eChu69jbdmfun9pEW/QbhJCIHFSPKobaXxIEzxtpK+sHDn762HzKQmaEOqPzA163U3dzCIBc/N/vTFU3JE5DXhnu9I2kcM4PDMxAHSToJBaxlIRQuq2MxuhDlLLkrjL7QhpdJRDsOW6x4ELpXb+MQ6KQnWJ2jf5cnOFKY0qGi7cZncnKKFiXV7oCX+FDed3056jrkaLxQOUDbR0MRr/qhCbtY9gR3Ll7xzN6S33pzM0b7cWXFdUdGzoM8HZYKByEs47bt+/VuuozSC/tSoLMV09PGx8NAuzcavh4wX7S9cu0Lh46ENqxWpvQkk2OQpffV5aSEX/xNBXZLKf6zWoUXPduvKEbXeVaYu2VQCt25ct1W345aKoiporaHyrD1qVZxgDMJ2Zw1pPkXqocpElVji7wBmAYsLgPTvwF8gdbHDr50bmGp8rGIPUHC/LIGIA2LbxPWeLiJEeUNkBQeF5ir9pY/B6tJofKopNOwfRiX/P+XY7T0iZc4N5dOd0e0f0y
 1+w8Vv71
 qTs7IM6ClcB8davllRo6+JwxJusCPYJxDq44Pdyt/Dd+rsEr1+0hCK7c7bzAPv1zN6yQsQgP47VnhRAgXmyRKRwkOAdXTK06ran7yC4sRV39+FWhl/t5N3/ClKKctl2p/zuNAiy5g2p7yS7E0uLuOHPSITh2yM+5ptJjZYVBMvRUSLok69jKTNkzVXyOkzG62K05aOXW5w+mNV2QbJfhrUxK6Qz5JDcX/V9UvYA5g0+k6cIHmyRNApKcpkRxJWuXre5pMMH4WrPG2O7dg6zbvMR1NKJuyAgZ4RMivKDW2jFrIN5MSvC5Vxcc6vn3h4xcOihTLdjfGUdM4nKWIdFT64L1VcyyCW0WcwQ7H/1xW3kxDhXFrkCl5Qh85y0llDY+NT14OC5kJf0A7R8o2NEsm/fPhDy1g/rNNoLmmBv6ibIxfdSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Override pgprot_[read|write]() accessors using ptval_[get|set]() providing
required single copy atomic operation for vma->vm_page_prot.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V3:

- Add const pgprot_t * in pgprot_read()

 arch/arm64/include/asm/pgtable.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index d3a50d35fd017..737e1e42f1ec0 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -122,6 +122,18 @@ static inline pgd_t pgdp_get(const pgd_t *pgdp)
 	return ptval_get(*pgdp);
 }
 
+#define pgprot_read pgprot_read
+static inline pgprot_t pgprot_read(const pgprot_t *prot)
+{
+	return ptval_get(*prot);
+}
+
+#define pgprot_write pgprot_write
+static inline void pgprot_write(pgprot_t *prot, pgprot_t val)
+{
+	ptval_set(*prot, val);
+}
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
-- 
2.43.0


