Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F15BCC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E7246B00A1; Mon, 14 Sep 2026 08:31:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF836B00A2; Mon, 14 Sep 2026 08:31:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCA66B00A3; Mon, 14 Sep 2026 08:31:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E15906B00A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 416C81403E3
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:10 +0000 (UTC)
X-FDA: 85212302700.07.1D3A135
Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4ADB320004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kNgl2V05;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ysj8Nz0TxgJizntpD+sQRniXfRCVS9A1XjJ8jJcXck=;
	b=6M7MngnpZ6l3Ovqm+5/wg2mB8Rd9GSbzJsCmYCrXLTz990XvNMOaW4T5HKUC11boZHEDe8
	TbR6ouWzewyEvYSa8bPnE6ZuChXXujTvUpWnsBveMoSzfEup7WduQZFuOh4mo2GgQNIIcu
	jgzoC+EuVNKnYxHDWvRdnmBbUpHpK0I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389068;
	b=M2TKA4k7BaBy40chLTOwHXiHudlUdlA6P10Mw6R2ulgxmEPRqr03v6cyU0gYFEF4TUWA/I
	GTFtudvxdnauiUsEIKw94ndtIiJvfYlYiwFlqjwEMgxVDDdfmxWV9+wnvD3DIWc8vuDi+E
	dM+ldkT1WdAgUUokxbWBnkJP/1ldlTE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kNgl2V05;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m3zofWqXNwwubO6EsHPEBwbDlkXPNebnA/BZT3Zr5yk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389067; v=1; x=1789993867;
 b=kNgl2V05Uht0hkwX4LIWWYrhCsbxBc5pvGo7DYJnj8pZrMHrFjI9PeUoIQkSB8W6cKqfdq9K
 Y6MVI4mOtKwmcxOtaaGk30lpJDKer0dX1L7eu9NVHllYdvUhJoJ4D8WZdO8mZf8kk+VwPvhRUsG
 aE7fYrQXpOfrVmiuQFabyLs0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 10864e0dc6d3f851;
	Mon, 14 Sep 2026 12:31:06 +0000
X-Mizu-Trace-ID: 10864e0dc6d3f851
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Subject: [RESEND v7 07/29] x86: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:57 -0700
Message-ID: <20260914122950.3283997-8-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: m7dpbr61qxmxwgx1hyhutdr3tz4bixsz
X-Rspamd-Queue-Id: 4ADB320004
X-HE-Tag: 1789389068-322336
X-HE-Meta: U2FsdGVkX19ekXM7F/MhaSBuiA5xoYFqkf15ElX/lgMc/3BvIgCDNmcKb3orj1D/WP7EQ2adtT9BZ8HQ5aXAGS/SrBked7b3SaNLR315rpFiQN31VXUzDDyYMgkn4KqooWQKTaRrrV3unjMfhjcB+HQ77XkvBcLCa20bnUykjRcJg3ge1CR5nuzo8stBI7QUpUWOYS2WgSTs1PnqWnsh6cgXNtV5n9vPi/O1k5cxkVQ/ghwKDS3i7spBJiS2OBvjaSSVbcVvJtND0ftcUH+Tb1q7Jvrna7x3Zdotu/bhtVj0CG2STeCapSKfV8WIdp/YSbabx82rV/yXbJY/S855wsth0YtBzltxPuM4uI50fAF5AGoyCjUjVnnOVYut8gy8Ubq70MeWoXEQuXGJbzlFqG1LgBwEQB+u/um3a7jKclOwzPse0Gv/je+dt1DmiYAl5x4w6yfQTiL0Yv3nsvgB4swuhpqfzpbPLy5xPLNEwfKIuR9Nq7bDyu9qqtQa1mYb4j6lV8AYbeQ1Q4daswgHWM7x1KMosUt5YvBAYztCv9RcFBI7RKj2W2ZVOGzd67tPU2UWklFwD8tXQCwOJwBhJgavd0BtnasXZgHFAYrOP6DD+SoMgO7FNu4msGhP7NDHOUL9veOBKJCRtYg8xq4lN4S0saHbNFvYDCrJxZbiwej84tFMFeUYtVvlBtmSvFOKpweiX3BGJMLXMCrh/zWEcyufVSPpN2u0r0VjxIeD15nVRmg9rRlGL8tuEiVVd0ojTL3TV1ZkFpv2jhB1GIwsu0qQgBGcKpWyIpFmH6Yze9kdkhHX7ksKvYT3PxE0hGfBBZ/GG3EmP9vftRMglsz/h2LjspgQ/eQLBPWIsnXWfSANN9YMgZmmM2tpJeRkd5isV1ME6f+0ahUsvMhqcbLK1QW6UkObKE3E/QeJvjEsSPCNmTLv1JnoITa9FKoMAUV6AGesIJWT3UJAWyRUTmu
 P/IrG9Fo
 6Oh2X9cgkcgzMvuWBYrl0/+2WPNdAa5DdpLwet6/jLQlvlLlP1t9fEF581bKs/AfsMYWR2dSmAWSkZJLCIaJ+7/l+DBHG54ZJ6Q14P7cuhF26+3dz/fBsfumJjr9TTi8J3b1XneVSd2cSpSae+3JPBrMaZjGs9ZhXCuRYtFxLjSWaT34srIzpauRYWnw+8mK//8T5fpa/S9GTWCA01VdYvfxL9EjCu4VW2S4DNrCqBzbLIHOBg27Mfvi6DUeNP68E4v16w/yyMdGWj0/qUM+9CJFydBRcSs+pADJvNWMofPxToPg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
_PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
not select ARCH_HAS_PMD_SOFTLEAVES.

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/x86/include/asm/pgtable.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d551120a7c889..a2d1cd03cba23 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1525,6 +1525,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
-- 
2.53.0-Meta


