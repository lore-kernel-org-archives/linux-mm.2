Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC210C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 07:33:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3E956B009F; Tue,  7 Jul 2026 03:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEE896B00A2; Tue,  7 Jul 2026 03:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDF146B00A5; Tue,  7 Jul 2026 03:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3BA56B009F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 03:33:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 174E01C7E84
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:33:01 +0000 (UTC)
X-FDA: 84961164162.14.3D2BF14
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id AB7B9100005
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 07:32:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poHAijsq;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783409579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8GAJd0N9i6NLBhWJbkQH3nRVcDA7h5JrXyI/iE+FVA=;
	b=RJjFQQXIofQbZMRuqqOD1XV70Y9FIeZsI4BBufPmMDwgZNDmWMjWZdG6fBc6+G54GHb+EB
	DOzzUkWUUs+0nb2ISS6RfLJ573sq0OsGydR2RDcOoZGChbihIhvNQuVNsGhcNITkqglQvN
	HmEF66DpOu2S13gFAvvkJN9wtbmPAU8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=poHAijsq;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783409579;
	b=zKw9jPRHFM7/jA7cfyjEdCOcxWU6AzQ9InwVFW3SVXA160wivVgKYloABnXxj2ZEoQ1AEe
	XAPJx7N1cG71xIyy0Gz8cJzNL6TqhzG/cprsDkGrAOZ2ACb/1x5TuIUwUiNB0rR7qdkGOX
	BjttSpgTQev2gJxQoS+LKo0kzNe8TDY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783409576;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I8GAJd0N9i6NLBhWJbkQH3nRVcDA7h5JrXyI/iE+FVA=;
	b=poHAijsqCmjyfIDAvI1ecdhA5SwGYt76es0NAdAzxg6c9N32PwF9Xi8xSPBaollCZWKwe9
	+AjbUuOXu7kFPSWz94JfT57SLABx+dBMVzBGGWyTg/NfbbMoUWzg5PoQgI+jsHdqDc6CHl
	HkHuYhxtI1nPWEa2RKIbiBifd2KJSB8=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH 2/7] mm/zswap: add swp_tb_val to zswap_entry and Pointer accessor helpers
Date: Tue,  7 Jul 2026 15:31:59 +0800
Message-ID: <20260707073215.72183-3-baoquan.he@linux.dev>
In-Reply-To: <20260707073215.72183-1-baoquan.he@linux.dev>
References: <20260707073215.72183-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB7B9100005
X-Stat-Signature: o6rwtjbrii9h1ruqpf6s8gfcu7rzchxk
X-HE-Tag: 1783409578-10745
X-HE-Meta: U2FsdGVkX1+NikZsgTAC5c3pAS3RysYDvj5YpgcrAsVdAddFcaxeP2E4+Jx40i0bXvcgYPG9jQfctu1tIldociqWyfClaWXtZaZlGK8d+iP/ublFW4jS57FN22Q+baHfeZdf6tH4TCMApNV7SvEQX0SnCi+n3V1JKXEOnK5/KvYzlYq8h7oNR8pVSJnLbFHUzdIcWzWcxc31DV2G43TR+jc32its+v70e9EzZCTVHJg239nI3yeq/fG28ZJRHFZfBaTHoRCoiefWaxftzKEIkO9qgUXtwKd0KmmN4HWWrDFFM0cDHRDAS19y2RjsYLiI7bPefFUof64D7tNrfTrzA1xLBLQKm1v9KNoEJGxDqtnUe2fCdIbh7uKHhvxYtoDcYqNapjPIgEV0AvwT56ZbSAEHjDIg8X9dVAz+vKjun3szcy95bKnKbBE9zMae89jjVi4RwM08riuisl9guvSfhzuv00enFKMGmLcfhCItqY9cLLYlD4TqzQe7kOvCxPtH/S/70a/P/cglU9RwY4SqtB/9ioKu3LbBdOoRgFX7Q/GNqVkzATwR8bFWOVp+NHlzIevCKKTR6peddN/cjPmDHiWPaD41U40ewJNog/nwxcYEQ1mLxAms03mj1kJasfn+yMxiMPlZ70hEcyXNSy5k3AOSQDi6rGSpyNBd3iFjO19pLoTwNfrUlgaul2sVyJuGxf5a7A3KflifvCGcjX4c2XuVs9wmUgOdnSeNaEu/gA+/FIJS9jluhUbrUrs6Slx/X4kwzR6XZvw/tDei5Yu+WfdjvA/QLIr9k3K/eoJcx9UOZfefM1jg2+YMVkLdILXeaclal4skSpy0xiWMqtn/r/RyyGjaIsIHbnt86g+/T2iz8ZCChvpi7/8KMuWg1gp6oukr7JIbCZeIzuje/1mp19dYJ5AWOb+OIOlIzoIhIIGw1xAoQbi2lh0SxBqLmM8Bwi6S+wRilQKdHUMWZgX
 fnBuMEt1
 CYNCjF9YVvM9zM+Gs1hHh9KuKWSdwAyeFXCHAeZb3IF6AYnWYVwk+G9INbilfNu03CJ0lgQ5DMdUaKtvTwy1bNcVwGokz2TZ6uuo0AabJ6z7cUsp5RgS1L9brzRGdBKpLF0z89RvgEf/LVdq+5pT6Idc/dbDxjDX16f6yfRUFLm0cwqLQ9+orDzhSRs26Iygb2TGSUenZYfE4wU9eGBM2h8/7/ZG1GW3ywq4SIfbWkDfvhVdUWuPxrXRtkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add 'swp_tb_val' to struct zswap_entry to preserve the original swap
table entry value when a Shadow or PFN entry is replaced by a Pointer
entry.

Add accessor helpers that read and modify swap count and flags through
entry->swp_tb_val:
- zswap_swp_tb_get_count(): extract swap count from the saved entry
- zswap_swp_tb_get_flags(): extract flags from the saved entry
- zswap_swp_tb_dup_count(): increment swap count, returns -ENOMEM on overflow
- zswap_swp_tb_put_count(): decrement swap count

The saved swap table entry value uses the Shadow/PFN format, so the
existing __swp_tb_get_count/flags and __swp_tb_mk_count helpers work
directly on swp_tb_val without any format conversion.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 mm/swap.h  | 27 +++++++++++++++++
 mm/zswap.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 114 insertions(+)

diff --git a/mm/swap.h b/mm/swap.h
index 44ab8e1e595b..afe2200bd160 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -210,6 +210,33 @@ static inline void swap_cluster_unlock_irq(struct swap_cluster_info *ci)
 
 extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
 
+#ifdef CONFIG_ZSWAP
+unsigned char zswap_swp_tb_get_count(unsigned long swp_tb);
+unsigned char zswap_swp_tb_get_flags(unsigned long swp_tb);
+int zswap_swp_tb_dup_count(unsigned long swp_tb,
+			   struct swap_cluster_info *ci, unsigned int ci_off);
+void zswap_swp_tb_put_count(unsigned long swp_tb,
+			    struct swap_cluster_info *ci, unsigned int ci_off);
+#else
+static inline unsigned char zswap_swp_tb_get_count(unsigned long swp_tb)
+{
+	return 0;
+}
+static inline unsigned char zswap_swp_tb_get_flags(unsigned long swp_tb)
+{
+	return 0;
+}
+static inline int zswap_swp_tb_dup_count(unsigned long swp_tb,
+					 struct swap_cluster_info *ci,
+					 unsigned int ci_off)
+{
+	return 0;
+}
+static inline void zswap_swp_tb_put_count(unsigned long swp_tb,
+					  struct swap_cluster_info *ci,
+					  unsigned int ci_off) {}
+#endif
+
 /*
  * Below are the core routines for doing swap for a folio.
  * All helpers requires the folio to be locked, and a locked folio
diff --git a/mm/zswap.c b/mm/zswap.c
index 761cd699e0a3..81115ca4d10a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -38,6 +38,7 @@
 #include <linux/zsmalloc.h>
 
 #include "swap.h"
+#include "swap_table.h"
 #include "internal.h"
 
 /*********************************
@@ -182,6 +183,10 @@ static struct shrinker *zswap_shrinker;
  *              writeback logic. The entry is only reclaimed by the writeback
  *              logic if referenced is unset. See comments in the shrinker
  *              section for context.
+ * swp_tb_val - the original swap table entry value saved when this zswap_entry
+ *              replaced a Shadow or PFN entry. It preserves the swap count,
+ *              zero flag, and working set shadow information (SHADOW_VAL)
+ *              that the Shadow entry carried.
  * pool - the zswap_pool the entry's data is in
  * handle - zsmalloc allocation handle that stores the compressed page data
  * objcg - the obj_cgroup that the compressed memory is charged to
@@ -191,6 +196,7 @@ struct zswap_entry {
 	swp_entry_t swpentry;
 	unsigned int length;
 	bool referenced;
+	unsigned long swp_tb_val;
 	struct zswap_pool *pool;
 	unsigned long handle;
 	struct obj_cgroup *objcg;
@@ -1646,6 +1652,87 @@ void zswap_invalidate(swp_entry_t swp)
 		zswap_entry_free(entry);
 }
 
+/*
+ * Read the swap count from a Pointer-type swap table entry. The count
+ * and flags are stored in zswap_entry->swp_tb_val which preserves the
+ * original swap table entry value (Shadow or PFN format).
+ */
+unsigned char zswap_swp_tb_get_count(unsigned long swp_tb)
+{
+	struct zswap_entry *entry = swp_tb_to_pointer(swp_tb);
+
+	return __swp_tb_get_count(entry->swp_tb_val);
+}
+
+/*
+ * Read the flags from a Pointer-type swap table entry.
+ */
+unsigned char zswap_swp_tb_get_flags(unsigned long swp_tb)
+{
+	struct zswap_entry *entry = swp_tb_to_pointer(swp_tb);
+
+	return __swp_tb_get_flags(entry->swp_tb_val);
+}
+
+/*
+ * Increment the swap count of a Pointer-type swap table entry.
+ * The count is stored in zswap_entry->swp_tb_val for counts below
+ * SWP_TB_COUNT_MAX, and overflows into the cluster's extend_table
+ * just like normal Shadow/PFN entries do.  Returns 0 on success,
+ * -ENOMEM if count would overflow and no extend_table is available.
+ */
+int zswap_swp_tb_dup_count(unsigned long swp_tb,
+			   struct swap_cluster_info *ci, unsigned int ci_off)
+{
+	struct zswap_entry *entry = swp_tb_to_pointer(swp_tb);
+	unsigned char count = __swp_tb_get_count(entry->swp_tb_val);
+
+	if (count < SWP_TB_COUNT_MAX) {
+		entry->swp_tb_val = __swp_tb_mk_count(entry->swp_tb_val,
+						      count + 1);
+		return 0;
+	}
+	/* count == MAX, overflow into extend_table */
+	if (!ci->extend_table)
+		return -ENOMEM;
+	count = ci->extend_table[ci_off];
+	if (count == 0)
+		count = SWP_TB_COUNT_MAX;
+	count++;
+	ci->extend_table[ci_off] = count;
+	return 0;
+}
+
+/*
+ * Decrement the swap count of a Pointer-type swap table entry.
+ * Handles both inline count (in swp_tb_val) and overflowed count
+ * (in ci->extend_table), matching the logic used by normal entries.
+ */
+void zswap_swp_tb_put_count(unsigned long swp_tb,
+			    struct swap_cluster_info *ci, unsigned int ci_off)
+{
+	struct zswap_entry *entry = swp_tb_to_pointer(swp_tb);
+	unsigned char count = __swp_tb_get_count(entry->swp_tb_val);
+
+	VM_WARN_ON_ONCE(count == 0);
+
+	if (count == SWP_TB_COUNT_MAX) {
+		count = ci->extend_table[ci_off];
+		/* Overflow starts with SWP_TB_COUNT_MAX */
+		VM_WARN_ON_ONCE(count < SWP_TB_COUNT_MAX);
+		count--;
+		if (count == (SWP_TB_COUNT_MAX - 1)) {
+			ci->extend_table[ci_off] = 0;
+			entry->swp_tb_val = __swp_tb_mk_count(entry->swp_tb_val,
+							      count);
+		} else {
+			ci->extend_table[ci_off] = count;
+		}
+		return;
+	}
+	entry->swp_tb_val = __swp_tb_mk_count(entry->swp_tb_val, count - 1);
+}
+
 int zswap_swapon(int type, unsigned long nr_pages)
 {
 	struct xarray *trees, *tree;
-- 
2.54.0


