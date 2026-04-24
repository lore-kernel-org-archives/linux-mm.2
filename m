Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6630FED3CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BAC6B008A; Fri, 24 Apr 2026 10:01:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD366B008C; Fri, 24 Apr 2026 10:01:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6E756B0092; Fri, 24 Apr 2026 10:01:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 901B56B008A
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD616401CB
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:27 +0000 (UTC)
X-FDA: 84693611814.28.A7FCB81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8C9E718002B
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4LFlvWX;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RO6qDge3MPXwzRJiRtDLpDEoiPA2crfPdsMVGpyGTu0=;
	b=Rb079AoBlLogJQ5/ykg1/KKXpk3Y+TZQVHBfGfSKBADMerIVylnj0e+1WB3e/1b2YiGxa8
	/p2OmB9aMRHVlIdu3x+mpRtkWLZvbB4a9xroKhH8CwZxrAw2h043HRGr6/z9fMyIx4+q5m
	bSTScaFsDJaELfQP2YOg25J8UYRZ6XQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=N4LFlvWX;
	spf=pass (imf24.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039285; a=rsa-sha256;
	cv=none;
	b=lrawRZyIo8TayFMrwCm+PmmtFDDsplLTD+EOMvz8kqFAq7EgXOTDa3MaRZc5JQp8DQjcGE
	8bTTeduT2twnRh9WRlBUlhRSX4t09Cinb/tn/dx5TV0M7kg4gpnc6gQXJNzwdqlCgq9nrq
	jMXzPpP/sPmr+4TFuj/u8HtEkvmsfMU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 73EB341B16;
	Fri, 24 Apr 2026 14:01:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927D0C2BCB2;
	Fri, 24 Apr 2026 14:01:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039284;
	bh=jn2J3yA0J0jkmQB7t5ls5b/AEhdqnAVp7d4GDg/Z45k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N4LFlvWXRa+nC2LrxZiweANVn2sW/mtDJtn9Hc8U2IyjZIgSy4LNgQs+IcGbxKtKB
	 SQXc/kEvUje04JOPH7+CFjBAkhuNvJ1+mJpMKSbR3Ape53qEz2rSthY8WkOHr+x/AD
	 NerivrUMmvutjugXmGXWN2xhWSt5Eg1Z+HGbi1TwI2Sj41+fdZ0AVNy+sVEUVCKVPG
	 tLwhV6Z90OosV7D6kFMR/VPDcZwTKg+fgxFgCAHVlS42dHsnn/IJeYntXseH2xsUih
	 orNQgIAhSM/STtN+hJVaSrAZAogD0kKuva7+i6hCEbPLvJar+PoD4pQMRXPnUSHvQp
	 ApS4f2wWVf0jQ==
From: Sasha Levin <sashal@kernel.org>
To: akpm@linux-foundation.org,
	david@kernel.org,
	corbet@lwn.net
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	skhan@linuxfoundation.org,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sasha Levin <sashal@nvidia.com>,
	Sanif Veeras <sveeras@nvidia.com>,
	"Claude:claude-opus-4-7" <noreply@anthropic.com>
Subject: [RFC 1/7] mm: add generic dual-bitmap consistency primitives
Date: Fri, 24 Apr 2026 10:00:50 -0400
Message-ID: <20260424140056.2094777-2-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8C9E718002B
X-Stat-Signature: pgsaqdi6n5nwsyxickqojmbe3fawrfr7
X-Rspam-User: 
X-HE-Tag: 1777039285-428932
X-HE-Meta: U2FsdGVkX1+4CkvmT8oWZ+65Nv5WFxIlmYAlJCfJCajYPWsry3tiXkvzuzKCJJCQyxS4w0z1SoOiq1xUk/SV4i1u9rSA7H+RerR4D4HQU1vpQ5lGy0ht/3M6q8SK4LkIFvkATxzQe6rIcbjP8eMUaxXAFXzv0jf7k83kYxkLtOYjroL7UbCDYa+/Bri/IU92X20JQ37n/c4gfLrmzGW8bwj7zXF0OS0C37/YTmTLRBKNQ0RSAiyPPnESLs04ShO7CVy/gXdi0nOTu1YWsG87LTuO/p8oI5cAIDX4i7FyhVLS1pgyCyN2rxEZmhkfNeaSmgwCUmMWmBHHJ5jwCjxXv+8QmJ3llsOzrWKeIg8YIxUJG/q9xQC2YkvN2OJ/YZmQPaW8WcYwZr1D5GaD9BvVDvFZsUtF6T5qaQjILxD5jrVVDAhptw2o7lNFm7VxB7EqqKirI/VCw4KXb5YWxWlInlI7vHmxCffObwkA6IQnj04Zi6gEs9sExF2YT13WXEUO8/IkyPM1Rvz6O3n7gf6q0l16vLsyhG2wbiuZAFuaRZHUD20bHw3XKnorao5RZzISIrRvY+fO32F2f5RJJyZhT9K3ahaMpsYxNFCsBa+xyqFOvZXeIJSK3cgvpHk9hzOLbPtJhmdwSjQqPCZtJHJh5lBDtoTEdaDExFCAbLwoJvC99JwlAvCAslXf1+UQdwQtz6XcutUszU0W5ajY+WwMvNoSXNl8CbDxT7LR1iRZPqyYoH4Y0iRmzxyrDBxpkTT9+yAteHSZk73pNDhEyGuZFQBQHkbnZq/ESb01MGehrm688s1NWJN29/nlQTa3pBSLbjktM01LwP5r1FLLfPeoRsTQhCR5+75Ebm3lUSCmPlWIdfZFN5wjR/E+VRr4OVMAFnVKVXcj8vwvwn81H/U8Zt6HJI+owFs3sOJAYwTtH11tLrOVRyw5eYoVFBmi7AOiawfPPDTgVftTPU1TzOi
 ilhj9EsC
 rMBTDJT5apQDiywkaYeKDEJoA4ZE96yn/arTfNGokwmd/R+au42x9fYvgysLIf0zSpsVH43DRNz4rvVn2k2cd6uXGc0wK7+7uX3Fk+M+STtZzWh0fPvabTVJp8nJtTb5WTBo3AlPYJkxpifMrXFmLXAd856HLhGghET3h3Jsa6r4MjpCL8/yb0AMrNWOny2xCrPhpErxRM7XFjAAyw/6HLJ1rpdaKEmcL6trB3wJa+tGOy8p2F94OOfOBs0Oa/VMneJ+tgtt/zqF61K8wLuIPrsAeXuFdbVHLWGyKushRYWNJDcFWIMTFxcCx69g9nIyY8ciDTjltDSvXvFHOGSZPXvlhXa4shw2rJOKB/7xVasncXy3thgtFzPOUnQ2tRmXs6U7w/IRfninH8zZOaPxws5kr9yygOuP5Wj6ShOzqZXAf4saspMNx++7UPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

Add a header-only library implementing a pair-of-complementary-bitmaps
integrity primitive: maintain two bitmaps where primary[i] == !secondary[i]
for every bit i, and detect corruption by checking that invariant.

The motivation (silent metadata corruption that KASAN/KFENCE cannot see,
plus the functional-safety argument for wanting this in the kernel) is
described in the cover letter; this patch only introduces the building
block.

The primary bitmap uses 1 for "allocated" and 0 for "free"; the secondary
uses the opposite convention. dual_bitmap_set() and dual_bitmap_clear()
update both bitmaps and return the previous primary bit so callers can
distinguish a real state transition from a double-alloc or double-free.
dual_bitmap_validate() walks every word and returns the number of words
that fail the invariant.

Concurrency note: set and clear perform two independent atomic bit
operations against the primary and secondary bitmaps, so the invariant
is transiently violated between those two ops. A concurrent reader can
observe an inconsistent pair on a healthy kernel. The validation
helpers absorb this by retrying a small number of times with cpu_relax()
and, after the retries, issuing an smp_rmb() and re-reading. Real
corruption is persistent and survives the retries; transient races
resolve within a few cpu_relax() loops. This keeps the update path
lock-free at the cost of a bounded false-positive probability under
extreme write rates, which is acceptable for a fail-stop integrity
check.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 MAINTAINERS                 |  10 ++
 include/linux/dual_bitmap.h | 216 ++++++++++++++++++++++++++++++++++++
 2 files changed, 226 insertions(+)
 create mode 100644 include/linux/dual_bitmap.h

diff --git a/MAINTAINERS b/MAINTAINERS
index d1cc0e12fe1f..81b1f44215b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -19972,6 +19972,16 @@ F:	mm/page-writeback.c
 F:	mm/readahead.c
 F:	mm/truncate.c
 
+PAGE CONSISTENCY CHECKER
+M:	Sasha Levin <sashal@kernel.org>
+L:	linux-mm@kvack.org
+S:	Maintained
+F:	Documentation/mm/page_consistency.rst
+F:	include/linux/dual_bitmap.h
+F:	include/linux/page_consistency.h
+F:	mm/page_consistency.c
+F:	mm/page_consistency_test.c
+
 PAGE POOL
 M:	Jesper Dangaard Brouer <hawk@kernel.org>
 M:	Ilias Apalodimas <ilias.apalodimas@linaro.org>
diff --git a/include/linux/dual_bitmap.h b/include/linux/dual_bitmap.h
new file mode 100644
index 000000000000..136822267be1
--- /dev/null
+++ b/include/linux/dual_bitmap.h
@@ -0,0 +1,216 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Dual-bitmap consistency primitives
+ *
+ * Provides a generic library for maintaining dual bitmaps with the invariant
+ * that (primary == ~secondary). This pattern is useful for detecting
+ * single-bit memory corruption in bitmap-based data structures.
+ *
+ * Based on NVIDIA safety research.
+ */
+#ifndef _LINUX_DUAL_BITMAP_H
+#define _LINUX_DUAL_BITMAP_H
+
+#include <linux/types.h>
+#include <linux/bitops.h>
+#include <linux/bitmap.h>
+#include <linux/bug.h>
+#include <asm/barrier.h>
+#include <linux/processor.h>
+
+/* Number of retries for transient inconsistencies from concurrent updates */
+#define DUAL_BITMAP_RETRY_COUNT 3
+
+/* Bitmap indices */
+enum dual_bitmap_index {
+	DUAL_BITMAP_PRIMARY = 0,	/* 0=free, 1=allocated */
+	DUAL_BITMAP_SECONDARY = 1,	/* 0=allocated, 1=free (complement) */
+	DUAL_BITMAP_COUNT = 2
+};
+
+/**
+ * struct dual_bitmap - Dual bitmap structure
+ * @bitmap: Array of two bitmap pointers [PRIMARY, SECONDARY]
+ * @nbits: Number of bits in each bitmap
+ */
+struct dual_bitmap {
+	unsigned long *bitmap[DUAL_BITMAP_COUNT];
+	unsigned int nbits;
+};
+
+/**
+ * dual_bitmap_consistent_word - Check if a word pair maintains the invariant
+ * @primary: Primary bitmap word
+ * @secondary: Secondary bitmap word
+ *
+ * Returns true if primary == ~secondary
+ */
+static inline bool dual_bitmap_consistent_word(unsigned long primary,
+					       unsigned long secondary)
+{
+	return primary == ~secondary;
+}
+
+/**
+ * dual_bitmap_set - Set bit in dual bitmap (mark as allocated)
+ * @db: Dual bitmap structure
+ * @bit: Bit position to set
+ *
+ * Sets bit in primary and clears corresponding bit in secondary.
+ * Returns the old value of the primary bit (true if was already set).
+ */
+static inline bool dual_bitmap_set(struct dual_bitmap *db, unsigned long bit)
+{
+	bool was_set;
+
+	if (WARN_ON_ONCE(bit >= db->nbits))
+		return false;
+
+	was_set = test_and_set_bit(bit, db->bitmap[DUAL_BITMAP_PRIMARY]);
+	test_and_clear_bit(bit, db->bitmap[DUAL_BITMAP_SECONDARY]);
+
+	return was_set;
+}
+
+/**
+ * dual_bitmap_clear - Clear bit in dual bitmap (mark as free)
+ * @db: Dual bitmap structure
+ * @bit: Bit position to clear
+ *
+ * Clears bit in primary and sets corresponding bit in secondary.
+ * Returns the old value of the primary bit (true if was set).
+ */
+static inline bool dual_bitmap_clear(struct dual_bitmap *db, unsigned long bit)
+{
+	bool was_set;
+
+	if (WARN_ON_ONCE(bit >= db->nbits))
+		return false;
+
+	was_set = test_and_clear_bit(bit, db->bitmap[DUAL_BITMAP_PRIMARY]);
+	test_and_set_bit(bit, db->bitmap[DUAL_BITMAP_SECONDARY]);
+
+	return was_set;
+}
+
+/**
+ * dual_bitmap_test - Test if bit is set in primary bitmap
+ * @db: Dual bitmap structure
+ * @bit: Bit position to test
+ *
+ * Returns true if bit is set in primary (allocated), false if clear (free).
+ */
+static inline bool dual_bitmap_test(const struct dual_bitmap *db,
+				    unsigned long bit)
+{
+	if (WARN_ON_ONCE(bit >= db->nbits))
+		return false;
+
+	return test_bit(bit, db->bitmap[DUAL_BITMAP_PRIMARY]);
+}
+
+/**
+ * dual_bitmap_consistent - Check consistency of a single bit
+ * @db: Dual bitmap structure
+ * @bit: Bit position to check
+ *
+ * Returns true if the bit values are consistent (primary != secondary).
+ * Uses retry logic to handle transient inconsistencies from concurrent
+ * updates - real corruption persists while races resolve quickly.
+ */
+static inline bool dual_bitmap_consistent(const struct dual_bitmap *db,
+					  unsigned long bit)
+{
+	int retries = DUAL_BITMAP_RETRY_COUNT;
+
+	if (WARN_ON_ONCE(bit >= db->nbits))
+		return false;
+
+	do {
+		bool primary = test_bit(bit, db->bitmap[DUAL_BITMAP_PRIMARY]);
+		bool secondary = test_bit(bit, db->bitmap[DUAL_BITMAP_SECONDARY]);
+
+		if (primary != secondary)
+			return true;  /* Consistent */
+
+		/* Inconsistent - could be transient race, retry */
+		cpu_relax();
+	} while (--retries > 0);
+
+	/*
+	 * Inconsistent after retries. Issue a read barrier and check
+	 * one last time to rule out stale/reordered reads.
+	 *
+	 * Note: the two test_bit() calls are still non-atomic w.r.t.
+	 * each other, so a concurrent set/clear between them can cause
+	 * a transient false positive. This is acceptable because real
+	 * corruption is persistent and will be caught on the next check.
+	 */
+	smp_rmb();
+	return test_bit(bit, db->bitmap[DUAL_BITMAP_PRIMARY]) !=
+	       test_bit(bit, db->bitmap[DUAL_BITMAP_SECONDARY]);
+}
+
+/**
+ * dual_bitmap_validate - Validate entire dual bitmap
+ * @db: Dual bitmap structure
+ *
+ * Checks that the invariant (primary == ~secondary) holds for all words.
+ * Uses retry logic to handle transient inconsistencies from concurrent
+ * updates - real corruption persists while races resolve quickly.
+ * Returns the number of inconsistent words found (0 = all consistent).
+ *
+ * Note: this is a cold-path diagnostic function kept inline for
+ * header-only library simplicity. It should not be called in hot paths.
+ */
+static inline unsigned long dual_bitmap_validate(const struct dual_bitmap *db)
+{
+	unsigned int words = BITS_TO_LONGS(db->nbits);
+	unsigned long violations = 0;
+	unsigned int i;
+
+	for (i = 0; i < words; i++) {
+		unsigned long primary, secondary;
+		int retries = DUAL_BITMAP_RETRY_COUNT;
+
+		do {
+			primary = READ_ONCE(db->bitmap[DUAL_BITMAP_PRIMARY][i]);
+			secondary = READ_ONCE(db->bitmap[DUAL_BITMAP_SECONDARY][i]);
+
+			if (dual_bitmap_consistent_word(primary, secondary))
+				break;  /* Consistent, move to next word */
+
+			cpu_relax();
+		} while (--retries > 0);
+
+		if (retries == 0) {
+			/*
+			 * Inconsistent after retries. Issue a read
+			 * barrier and re-read to rule out stale/reordered
+			 * memory views before declaring corruption.
+			 */
+			smp_rmb();
+			primary = READ_ONCE(db->bitmap[DUAL_BITMAP_PRIMARY][i]);
+			secondary = READ_ONCE(db->bitmap[DUAL_BITMAP_SECONDARY][i]);
+			if (!dual_bitmap_consistent_word(primary, secondary))
+				violations++;
+		}
+	}
+
+	return violations;
+}
+
+/**
+ * dual_bitmap_init - Initialize dual bitmap to empty state
+ * @db: Dual bitmap structure
+ *
+ * Sets primary to all zeros (nothing allocated) and secondary to all ones.
+ * The bitmaps must already be allocated before calling this.
+ */
+static inline void dual_bitmap_init(struct dual_bitmap *db)
+{
+	bitmap_zero(db->bitmap[DUAL_BITMAP_PRIMARY], db->nbits);
+	bitmap_fill(db->bitmap[DUAL_BITMAP_SECONDARY], db->nbits);
+}
+
+#endif /* _LINUX_DUAL_BITMAP_H */
-- 
2.53.0


