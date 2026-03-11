Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14E251049527
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 10:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7086B008C; Wed, 11 Mar 2026 06:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A8A46B0092; Wed, 11 Mar 2026 06:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 349886B0093; Wed, 11 Mar 2026 06:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B9306B008C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 06:19:35 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 96536C27BF
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:34 +0000 (UTC)
X-FDA: 84533385468.22.CC7FD7C
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf11.hostedemail.com (Postfix) with ESMTP id C726C40008
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:19:32 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LMh+0ell
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773224372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5yreLjK2erbVMXiW7KuM89LaFb1/wtMtolE8GC0kxjU=;
	b=0TyvuG6W6KjIK3EaXfaG2+4Nz+20Au8BrVRiVdJ7zRhAVNwrO+I68IS1aedomlx6qf0y8+
	HUwV3fiqwmtCAFmoj3lf2QvVsc8S1H3z3YvBeNbg1Y7BoRLMgp21Xh76nY2vXI8hmZda1G
	NgdbjioAQM0rbFg3cgq1TYDny4yey/U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773224372; a=rsa-sha256;
	cv=none;
	b=Op9perpB4cG4X3Jc5NQcNxgCXBcG6Tl6hs1yti9v9EnREUWhC2ziiKyUu59JDQHWdDKQwH
	zn9UcGuHiF4jCiLVomGxPVMjMJFH0+KIteBuNQYlFdS5ijYwxyYkHl4LoOfieoW+RS4WJh
	TTjjWkbcRYb/qSHoHNKkw6nn9QKGpdM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=LMh+0ell;
	spf=none (imf11.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=5yreLjK2erbVMXiW7KuM89LaFb1/wtMtolE8GC0kxjU=; b=LMh+0elltPbfwMimFH88WYC0r+
	fah3mKQfMhkJHQoysEZ/5O5eMzzfV/Er9Wkt4vnwL3zRxwsEu9kCOVXckWPxRIowK3Z9ZAClA/B4X
	beUvhxI6BfCG3Wb/XAwuynIQbos1Al2XzZrj8TnewjRaz79yTwObeYx3rf0cfV+RGPnkdxrMd+UuZ
	RCCBfB5UoAZs+Q39+ssD4aMmZeEMg57X1mBau4RNBk4m13QrWp/r+GcXJ/qsRH0TNgRe/3frZdqRm
	mFzw7Q9SNUFG/4Z6wCTn0VBUNieHYMDbBh06hA0iV548mVtqHcQ9BkQ3Tu35dG21xqLu51g6YZqim
	jfQJxckQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w0Gex-003hKa-9G; Wed, 11 Mar 2026 10:19:23 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 11 Mar 2026 03:17:48 -0700
Subject: [PATCH v6 2/4] mm: huge_memory: refactor anon_enabled_store() with
 change_anon_orders()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260311-thp_logs-v6-2-421e30d881e0@debian.org>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
In-Reply-To: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=4470; i=leitao@debian.org;
 h=from:subject:message-id; bh=t2LGZ41pcWRU3yvwZ5U6d39fdwdrml2WrYQvffEHhZc=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpsUGZitv6aRdp3z+vgNYyxni53MMg3FfbFI4Qi
 HH5hHhgdcqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabFBmQAKCRA1o5Of/Hh3
 bbVTD/9JwPnc8xhW6wjSWEGZW9FPCmHYyKOIkyhmrooZSH9MOcwFws8CJ1ZYvpGQh8Q4cxfgJSB
 gI/cMYFoMOOBR8UJR9L4DE7ZPKMCMhhbdgkXohP5Jo1XgNBAKII0ApXyiWjcsu1YU++XTQqgCKy
 kAnDxnr5keYydPqw0N7HVOWbcKX0WA5hWXhvyxsMa/T+fRWqH1yAnQ6AbatOkifzY3yumabdFpV
 3HHZ5usiH9n5CO0z1mWbSIekpHh3xguim1k5t5J1xWuQ+qm0ZWLAZVH9SJVqD+d5Jccp17sSGUO
 Bbm0kBi4HakJmoGrM9QgCe7XEos/urbQYez7cDlaNql6WKgTK4C3EimXNiSAlSA57eymaMf9iRk
 J6l2f/vKBxWIUqwzoP5ej+X4MvvL8cUup6jt3fnzc/HpkvjWTaFuuUpzD5tuvwcrDfoB6It0AH2
 JgEGZtq4pTK8W4aL4j70pOillgHv8v7efzJQVakhbi2wi99A7eseGm31PpV/JYZUqiiB7pM2/zs
 DyslufFzXDkGEHJpBDlOr8ON68u5IcBDmIE20r+svoSwPggFluhaFAiXHAnqxrN0IdhvMF5IG6U
 bX/pg/Xyoz3DdzN3KP//Ewk5GvZf/8NI6TiFM73E60Iy6W/yqtBL0llF5NqsfPFnbkmZxNzboIr
 C7OaZzEobKJ+oxg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: cpq7b6abtneorr76dwd9w6n6hn8orbii
X-Rspam-User: 
X-Rspamd-Queue-Id: C726C40008
X-Rspamd-Server: rspam12
X-HE-Tag: 1773224372-861223
X-HE-Meta: U2FsdGVkX19aOeyceQePtrCWrp+j8jSXM+C0FEebvjYwgAjhd0TBp1HR8QNonCTh9tkaiwYdCNbIyTIuhDrq6zfG0IWhaFlkWij4pgyybWjiFu19KavxOIh8AN7An3ldyKowUeCeNqsSjaIw8qHRLgg4QuoequzZbbwF0L0xeIGehN5hTUr/Q+W7PTkVufcHOm0xGhE6MGIz02YYM7SJ+uNtnCePTgsPzhs0BiNZfuCua11EIXET7kwcMpiv6ls6CZnl5JBA3FrKu5WT5LNWmFEWOAxENnkZY3G5DdulHSlsUTUxc6f+tf01+AA2lJvVB8AYyN7/8l6yVj6MZ4RtPS7Aw06EXF4SmQwIcSJLx6uMmg3eZL+i2EBzbciYUS5zf8cqlSkZ0OdjV7RaDGDZRVCGxG5XgTYrXzZQlnFy1G6yrbPyCQPteUPydhxksESu16lYBXnXxZV2IoFNEqLK0HSbLlC1kjLbhhWILAgZ05ZjITwJC64+KvCEcq11fyTXvz3fiS8q40YvQuAFzTIqhga6DyqKkzwFhSfDIXWHcTGCiblW9Lt21aHdU0/gd5IVd6ZBjyAfAa8PZ4A3BwecjGKTl7w9ZLT0LcjsFEYSPN425J9USdVHFiMQNp7AxDyppgCbUMHnB/Ay2Ad2TV+8KBukfd23dloZoWfvTk+kmJ9lsHt96Xlxid5lPMP32fv6RKOB06KsSA5wWzufhEtra+rJPk61vl6s3OZsqQwiZltBsidOIT62Lgnmp9oVMuFKLr28NzAJQxfDZlO88dokMEUtIWdiSZSGPtdRH/VU7YR0ipd6CQmE3pLbv03cJseG+Z7F2vWNY4cRLUZ8M25nnBdbwIWvjlZk0MdDZ86rm9bsTeSx1KvawYSDmqpUnR3LRivokuVdc8KyTnmkzdc02iiJr8t+/4hNeHIAMXsXUMTSlJMOPODUUGpHbvVobhJlhUc2u5e25KEAqsszOlP
 M1kgwDPI
 0BQvDoJCGJGKLgiGyRRfGrAhfHvFFX+/V2HDPqLty1LjQv0Kxwh0nIc58RnTPZ3G4RESAI7/6Jgw4N5FWsVHicmzZkYSxZfrIZQT4bEbXIOUHgiYyMr00vR6zHUTQeXJpW5OUX/siOvvdiZNwCddsRcFiFS2xoJoaTNj7f+ckH7BCIw2Is/PaXJrFJo7rXUaT207Nh1/t+OCnIwAx6NHlHlm4lTrmCgt39y6v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
anon_enabled_store() into a new change_anon_orders() helper that
loops over an orders[] array, setting the bit for the selected mode
and clearing the others.

Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
for the per-order anon THP setting.

Use sysfs_match_string() with the anon_enabled_mode_strings[] table
to replace the if/else chain of sysfs_streq() calls.

The helper uses test_and_set_bit()/test_and_clear_bit() to track
whether the state actually changed, so start_stop_khugepaged() is
only called when needed. When the mode is unchanged,
set_recommended_min_free_kbytes() is called directly to preserve
the watermark recalculation behavior of the original code.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 32 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74adf..f6af90e6cf05d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+enum anon_enabled_mode {
+	ANON_ENABLED_ALWAYS	= 0,
+	ANON_ENABLED_INHERIT	= 1,
+	ANON_ENABLED_MADVISE	= 2,
+	ANON_ENABLED_NEVER	= 3,
+};
+
+static const char * const anon_enabled_mode_strings[] = {
+	[ANON_ENABLED_ALWAYS]	= "always",
+	[ANON_ENABLED_INHERIT]	= "inherit",
+	[ANON_ENABLED_MADVISE]	= "madvise",
+	[ANON_ENABLED_NEVER]	= "never",
+};
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
@@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
 	return sysfs_emit(buf, "%s\n", output);
 }
 
+static bool set_anon_enabled_mode(int order, enum anon_enabled_mode mode)
+{
+	static unsigned long *enabled_orders[] = {
+		&huge_anon_orders_always,
+		&huge_anon_orders_inherit,
+		&huge_anon_orders_madvise,
+	};
+	enum anon_enabled_mode m;
+	bool changed = false;
+
+	spin_lock(&huge_anon_orders_lock);
+	for (m = 0; m < ARRAY_SIZE(enabled_orders); m++) {
+		if (m == mode)
+			changed |= !__test_and_set_bit(order, enabled_orders[m]);
+		else
+			changed |= __test_and_clear_bit(order, enabled_orders[m]);
+	}
+	spin_unlock(&huge_anon_orders_lock);
+
+	return changed;
+}
+
 static ssize_t anon_enabled_store(struct kobject *kobj,
 				  struct kobj_attribute *attr,
 				  const char *buf, size_t count)
 {
 	int order = to_thpsize(kobj)->order;
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_always);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "inherit")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_madvise);
-		set_bit(order, &huge_anon_orders_inherit);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "madvise")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		set_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else if (sysfs_streq(buf, "never")) {
-		spin_lock(&huge_anon_orders_lock);
-		clear_bit(order, &huge_anon_orders_always);
-		clear_bit(order, &huge_anon_orders_inherit);
-		clear_bit(order, &huge_anon_orders_madvise);
-		spin_unlock(&huge_anon_orders_lock);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(anon_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
-		int err;
+	if (set_anon_enabled_mode(order, mode)) {
+		int err = start_stop_khugepaged();
 
-		err = start_stop_khugepaged();
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+
+	return count;
 }
 
 static struct kobj_attribute anon_enabled_attr =

-- 
2.52.0


