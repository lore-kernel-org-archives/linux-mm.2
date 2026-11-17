Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD243606A323
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 07:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=RpKDwRah
Received: by kanga.kvack.org (Postfix)
	id A6A9C6B05C5; Tue, 17 Nov 2026 02:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1B4E6B05C6; Tue, 17 Nov 2026 02:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 958CF6B05C7; Tue, 17 Nov 2026 02:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65CCF6B05C5
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 02:07:11 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D02F040343
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:10 +0000 (UTC)
X-FDA: 85443729420.18.D3CEF34
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F0A2180005
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RpKDwRah;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794899229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=In5XHn8tUjmrwGSxql+VVDMlJ1U6WaHJPkyrd9YfyY8=;
	b=jy+sI8kDWu99VUpmeobPdKQL24K7GG8rds1o2mTlFdg9lJdvMPlDRfb05Mh/eiSkbKLLgF
	/0/L/ezz3hktoPiya4FCNZCERdiwcu5EGbP9R8jsbvrH+XbDjfkM3a3tYD7Lzvc/EEMtGf
	wNtvw7RYpErAeVxWrFNSIXJVw9Z7/4k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RpKDwRah;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794899229;
	b=mEcg6JPrQJdTDlPROkhsv0J+UosGfGnrVt7TsmbC7GjT6p9eK1d11mvVjZcYrAuWiYfTKe
	np0uc/N8R5zfRiDsm0Zj/zrrfoJKr7nBfYKScj2MbX2lYUOTX32bK5+Mb4QanPpFvH/9qI
	55Rz/orpLlTJtfO8t0ctVow31TJqJEs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9E27B1688;
	Mon, 16 Nov 2026 23:07:05 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D40553F882;
	Mon, 16 Nov 2026 23:07:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794899228; bh=rSvlSIXr+wDtZe2exxPGHZkrukV+OXQGNowh+BkvXcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpKDwRahiZsvs5NYiVXBle9NMAptxzASgBjrEsOtbv2j12uijayfCF8G5LzpedR6X
	 hwxBix7JkHGWE3238+qyf56bAhlEGeiko/kQ4tw6tnrP1PKUvJptKHjfjgWmc8S52H
	 2qj6Vz1wFEM15r2AnKiOZOlMBY5d5KgPcdly8+B8=
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
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	kasan-dev@googlegroups.com
Subject: [PATCH V3 12/14] arm64/mm: Relax KASAN shadow alignment for FEAT_D128
Date: Tue, 17 Nov 2026 12:36:11 +0530
Message-ID: <20261117070613.1183243-13-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261117070613.1183243-1-anshuman.khandual@arm.com>
References: <20261117070613.1183243-1-anshuman.khandual@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3F0A2180005
X-Rspam-User: 
X-Stat-Signature: 58jtggz3x4etbyejr3kpoyxq819m8spw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794899229-627088
X-HE-Meta: U2FsdGVkX1+/jeiuYod88biIo0nWXrj+OsSnhz8AIeaQk0GONQQWLGOSw0yWLRK+DyfUKzqNJ8XdLZ5GLE2JzaEkk0FWn3ixzH12EUwSPIT/3WoFmJRxMftABc7MKIm5U44+vU4XM98ksglxvrO11rFQ4PlxSj79nb4pC2r9IJQauc9/CicyDB3slT311384DHPKSncXrNAqfjB84RCYrXGq7CL8+l7LB1AFWknjIb9lFvVNBy8xc42ztVFlRaf3N8W3GI5TNmHY1aXZYnzqlSh0LiWK5LksyBmP7qw7AXnXz0pUgL8bs3ITB/oAg5txDHBHJJJwlk4lQN9kYC+8PiskykfDS19ZMa8mhKa7DNbUU+MFucW+aExICuNu7CZ3TGsBGJiMiXCuSpfFCVJEI3e/L/lq/TtIqtk6AH3xMMncpAaIGpV7HidRaZ3Dq2fRvK6AEF5YJYUjYI9OeoOrhk6b2obkm9F9B9R6vZrOkXTOrr06W66bNijgQ1jNRKQvpiO+aNnvXWUQB0xONGDBSb0mU1IsF8xKwEfMhpZAHNrAcGwoVL3xFOBB8PpVlUKsSbsw5BZe3ZvX94bAayoP0ZSGDAMw6zjdfnG3KUeU2TYokqEvwAy8BFoPUwtd6k5RyMEbfTWv060ijcPSaqFo21uFIys50dTXCY+n8sMoc5XfYENUslV1dlY27PUEpI4E6slvNYfRsBYJRFmMtaizj56Kbf5U5wqdksEG2r9q1hVXyqiSk9s92KkfZhjqPHy7wsEdWhbD0Xq5vWJgzZgqeQg2vdoL0l8uF6H+S8KCN7+JHPuqnJSOzK2fE6YTxMf5PrgiRU2fU734cKLL9q/hlbhgVjinsISwh8uDYjFIyavIp0o5l8ad1P4WQe+GSqaKIqhmxy6Ktv7Me0hVqtE138nVz1nYi5HdG220VXIegpWhObCPj83fkpMpA+E6iliTgLBkCsS+hsFQ8PQvW+P
 k1ihQjF0
 9JQTngvn3xQaEsFuwNxcH2nrrhsYxsnu7SkV3ep8FOlP182+9QE4qIkpnbnhD7Xk8/QjnwL3bHFxLo/9hpJZdp7Tx6OKYwo5c1n3oMsTbt8IEMAgr7cAlAvR8sI6sT5MKLrTDeYaBhC57VR1CtDRlXx3lCE6VYXcGG99HK9ZZQf2YNICfciA5C7UoWBoGyGmtLhDwn56UFtkVLS2XAYtbOrMQ66qAE388gw7gX6P81gucz6u25cX7LoGm364yl6q5Py2NTkgn5D6a7EF9apYr7qTA+78Kg3HfbUl26QU4u7kf9UDfRIPFuY7jyZtVc+DJv8VwAZ7+oY/WhorZftgyRgzLsKDEwb04XBzftz1/DWXPUgvBAX/P4NSyjw8W58vbNqb/rSfCzr8ABIpQEwYDloMyaQ5egHqI+sz0Dds33YhEuI/E/vGz8x8sYk9mnBcFYm70l8P9fR2jQM+qvYuMMrhExb4903qTW2HiA+CRUoxN8evxziN9Xxjoh4R9eYHJuiKPv4kWsP7OXYC9+CKK5xbjCnlLZquTerQhv/z5ZggqVj7jGl9zPtsOxeD1PO1OSazpmemdw4fngs382n0Pbs/1EqKKlQovZejA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

D128 reduces the number of descriptors in each translation table, causing
some VA size and page granule combinations that use two page table levels
with D64 to now require three levels.

For three-level page tables, the PUD level is folded while the PMD level
remains a real translation level. Hence, PUD_SIZE represents a root-level
span. With D128, some configurations have a KASAN shadow region smaller
than this span, making it impossible for both KASAN shadow boundaries to
satisfy the existing PUD_SIZE alignment requirement.

The KASAN initialization code on arm64 already supports shadow boundaries
which are not root-level aligned, by installing or cloning the next-level
table as required.

Similarly for three level D128 page tables, relax SHADOW_ALIGN to PMD_SIZE,
which corresponds to the first non-folded level below the root level. Keep
the existing alignment requirements unchanged for all other configurations.

Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: kasan-dev@googlegroups.com
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/mm/kasan_init.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/kasan_init.c b/arch/arm64/mm/kasan_init.c
index f61f5bc09467c..e12abea6ad156 100644
--- a/arch/arm64/mm/kasan_init.c
+++ b/arch/arm64/mm/kasan_init.c
@@ -178,7 +178,9 @@ static void __init kasan_pgd_populate(unsigned long addr, unsigned long end,
 	} while (pgdp++, addr = next, addr != end);
 }
 
-#if defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS > 4
+#if defined(CONFIG_ARM64_D128) && CONFIG_PGTABLE_LEVELS == 3
+#define SHADOW_ALIGN	PMD_SIZE
+#elif defined(CONFIG_ARM64_64K_PAGES) || CONFIG_PGTABLE_LEVELS > 4
 #define SHADOW_ALIGN	P4D_SIZE
 #else
 #define SHADOW_ALIGN	PUD_SIZE
-- 
2.43.0


