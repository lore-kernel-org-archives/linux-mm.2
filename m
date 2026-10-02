Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BF39CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B8D56B009F; Fri,  2 Oct 2026 05:56:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 842206B00A0; Fri,  2 Oct 2026 05:56:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 730F36B00A1; Fri,  2 Oct 2026 05:56:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CCB06B009F
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E4835C06CE
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:11 +0000 (UTC)
X-FDA: 85277230542.08.E912775
Received: from mta0.migadu.com (out-243.mta0.migadu.com [91.218.175.243])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0CAEBC0004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ldF7jujy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VzRv3CmS/dR4ipw8hh/GB4dWxM8Jc8SZRrU4SpnzLoc=;
	b=e0w/ynlMwddkknlrjQg/HPfLy+rqpYQJyAv0RYggvPvkxU/uKWvFxiNSKeoLJVGE76NutP
	d6P2HSRq0z7t6LrxcH8qDzjxan0KJfEMffq5P5bapdn6g5H/MdaWwhIQyBhNwpoC4Kp1QV
	q/YX4Nh9kWQjThHovD6L/HMKLFYnUj8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ldF7jujy;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.243 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934970;
	b=aSIBtFQYuF3UQPk5SPEPIOrGI2owd3jngRq/m0stUjUe1AzNwl0yHh6dmBDvkhJ+t3lTbF
	iYqziSJCuRZAvxmLAaQA2ZKo/fO1ND6iGZKeYocr/41T449iNSz7sQSIzMJmYfehe90vtN
	jOssHi/HtXvLbxGOI6+1sf5D8C9JVlE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xkb7MkR54E2nqz4EqcW/yiNvszHDEep7fC71s6pB1co=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934968; v=1; x=1791539768;
 b=ldF7jujy+tNQlgdzV/0j+2j8b3wZb0fioLzR9g3DUezGUnQsYICe+RDMXd+Sp4smJD5+UJGZ
 NZ3d6IVyNeD7lVqHDZf9b3FTp6ODs0sRiRwa8V/2m7LEFgMSzz8KF+Yj3E/pyJHOQn647+wxMX9
 G/NDYlXIDLL0qJCcXlI12/c8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 13f9800596f01563;
	Fri, 02 Oct 2026 09:56:08 +0000
X-Mizu-Trace-ID: 13f9800596f01563
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
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Subject: [PATCH v8 05/30] riscv: mm: add PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:19 -0700
Message-ID: <20261002095503.3585565-6-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: qwfpepwjp4tu94rojnjbr5ph4ac4pqqr
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CAEBC0004
X-HE-Tag: 1790934969-743001
X-HE-Meta: U2FsdGVkX18xtLEiRGwbusZhTeAEOGVEUQuWgW4qa/J6gEaMwPa25VTfpDxH85Owa1VIPJgUCCy2VAAoQIgEEYvoqa4BwjdFCTbDmnVakS/dfg+NRuM4EgWtkNOojn757r+pxBTOluLlYsfzMjyPqMvuYp8OiOEj9f7n4+L/9vqr++BiI3BAx0lMVbVCGtKwrs8ER6ugGwRMb+u+0JgYUmowXCrk435tiGPz9Ys9/jDcoLgrDH7ktRzyQpe0kKg3lNpkQ6D9UX0DCsLRDef64lQFhdXzDw+mpbSZb09dV0iSSBNYXcFGxxqDzY72d0iCX+SoLVGdE7LXGUNrxCHidbSdxtMmp3IcymD98l6moc75jQkZpb8i/g/uaJhUVT/vNrnd5uKm49/qEhOqTkA+bDjGBu8ZNpxEwHFRVzj4sCkLRp3gpk5o3JvQRoZb74oUtD07SvrirCbE6cKeyqPUbmDADJ5vFJ4jvOsIV/QHgKhqKTp824FAVqiDk4Il7cVGYViszV03mTNJ2R66knUPnVa/nIqdfuaH4L+4IZ3noTum+tE4fMRBjM0LG4ZmTQirW3UnDRzSr6tEbmSKD55GJ2G1Z8X9U+mvxjd1U7ubTQe74kKBP5ADT2C7Q6S0UmMGrfMLR6vjBiuJC6AC9Di/G/xbri20XB3YGNplgcGQhmXhzxOL5iHyBmdYqbLDMKTw5mWmCOFgBhkILu0FrPpRIIQgZ400Mm2Tnm6P4HzrjZ9leFtRtBiqv/K7LJdwssEJc/xojNcLXRWu6UNQ6Ub3RxYrcq/twBRW2Xujh4DAOB9akGRJessQHH+G0L+/8havwITR4Ftlde8byrNO7XiQ+G4MNSpdq/nOBUslKd9DA3UCxX7il8Fr4y7JXWu8681u1LGTD9hcXKhbTqZeX+zV9C7LKVFRn0jSEhukOhD/KcPVHv7yl9U/aForvSRh0sJt7VDzQ9I1RBv8yNW/mo3
 VjbPChHX
 FmAk3I4RSClaIxyKWCG9c7AWQeue2jbvB+gD/a0QSsgOCZbAnme1NG0autKl1t7bvuntgjQ2Mb9yg+Euk4dFBDxrMHc1dVlP+ZU0MPSSqp6PUX+771ifJSSynKbDzAQOtPYIq/wVp2kCTRiQH4MRfOEA/fprDkLLSmy87Nkp3rPyWYe86IX0MUlA1Z+vlrvV+hiZ06vioAG7QlZ0cAkZ5n8kGF+/kGvDEHOXkjqYOIi2oVh2WKiKw7a2Hwfj5+46zLWgvpgLegMLL7ePkFAFty5Nf6uWoWYJglkiO11yxOEos8PS83uWnRycKKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

riscv encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse _PAGE_SWP_EXCLUSIVE.

Cc: Paul Walmsley <pjw@kernel.org>
Cc: Palmer Dabbelt <palmer@dabbelt.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/riscv/include/asm/pgtable.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index d48f90140841e..b644db16bda94 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -1219,6 +1219,21 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pte_swp_exclusive(pmd_pte(pmd));
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)));
+}
+
 #define __pmd_to_swp_entry(pmd) ((swp_entry_t) { pmd_val(pmd) })
 #define __swp_entry_to_pmd(swp) __pmd((swp).val)
 #endif /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
-- 
2.53.0-Meta


