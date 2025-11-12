Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B0FCCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3BA3E8E0014; Wed, 12 Nov 2025 10:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36A3A8E0002; Wed, 12 Nov 2025 10:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259978E0014; Wed, 12 Nov 2025 10:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F7E18E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F2E713B346
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:15 +0000 (UTC)
X-FDA: 84102371430.22.D3D8765
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 072A718000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rg+Iy5FU;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJqVhfur55PHVL7B8oF3JesRY7YM4/jOO7TyOinsK7A=;
	b=DJkf5lqj2nEivxGHZdJ/CvuWbT6WCAfb3p3S/ETZ9eQyViU4M99V/5TfP9WU7lwUDzMVB0
	bS3Ke6FmL0N+qOgfoT8Rve7tNU3FCY7i54k8t541dzYkpIyYFI6yFDb8LbEbedsVwd56Mx
	22FmZVEqdMebITDx8sq9i9s3ee0SsN8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962134; a=rsa-sha256;
	cv=none;
	b=v4TGgrSYM4KWUPQElvwWcZDbkI65AUOFpsvLvKvdrTK9U69j2zObu/bl9iQ+wMmmSMedmq
	GylXulXv4r37vzhhWbvIKEJRu4u/25Lv3FIr3tZLIN02ZYQzHLDin8W9mLc+f+CeBaliEw
	HrsR8EDNnDeGLVaTe/YeNU1Zmy+V6Bk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rg+Iy5FU;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7421360236;
	Wed, 12 Nov 2025 15:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70B9C113D0;
	Wed, 12 Nov 2025 15:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962133;
	bh=Ydpo3xsumi/0AU0ywoSi8MHefmYKBp2O+zycDWbAlqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rg+Iy5FUuR0ooXsRWmZ7hGatyVWmvp72qpBrqVWMcmB/BuD7VDSM+iqFRVTPiczNx
	 5U2G+YmR+esLUWkDZF0qWemYZXgEnh5ngPcocxe1UnXxc/yK+9gCaQkKbv8KA6KR0c
	 mq3RaDiWMH2WnEcKJxhqk3qFLKWbLn++cjQK7fF1FWAxUqjPC/pZrbIiouTc+2C6cD
	 +6X0a1lHaESDqKqwA6n0jxZ3qb0+SDXEla6TyFJthCovxImSHbJ6+l5gZ6thQH3hZi
	 hYZ0FWZrB3AgEuhyh8NJDbqStNejmwBULgg8U10Np7m5eR505QXSMQ/iRnj7mdrPUM
	 JqN0EnmuyfyXQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/9] mm/damon: rename damos->filters to damos->core_filters
Date: Wed, 12 Nov 2025 07:41:05 -0800
Message-ID: <20251112154114.66053-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 072A718000C
X-Stat-Signature: zs61o5gco5bacy6tzuhpqxixuige7pzk
X-Rspam-User: 
X-HE-Tag: 1762962133-114079
X-HE-Meta: U2FsdGVkX1882XGpLW3NZ5Iiws8+nEUXOydVh4KyvKKmNp96CGZKKiqN32h1EI+FOV0+Dq05fhdhOdLKK6EySK/W/GM1AOW0sY+JxVn51KY3X9JT+e9XidInSfpKWuDT47m0sUrjoz5aB0i/LaybOT6z2dWUKMRm0sxx+DKyF9Q6Akl5LOmpGOMBx77HwKnrixx7k7Epzb2pWdjXOTg1+cndY/yPKvhWB1kJ4ZN0nm5WSw8DNG3skdtNP7KOO860/y/cGwNGYOGpdfv9DeiiOObIEUA1g+7mnD72Nl1BUFWq0Tz+rIj2OkpmwPG5f7LtiXmBISO2dsuqKr11kMDieAD4g8K2NfkX9e7I9b9qFW5pLYWkfFa5tPjt5tURrq79MsNb1eLnaj/m8cf18hZLW7CT/l7O+U8Cex2kWM+CWSXSr7ZAtlCE7B8rXtKGXQyONZvXSCj117vak3sK6FM6+ZTvei72187nI2ORWleyg2eJW/YWMBKvNDPQrdOUyi9tMv6UShxIgRqLEEZmrjI9EGCbBMR2LhgnML7YBtC+SXjM1veba7Ywdv3OcJhJp2OG5JbWCI06cCsmjNnMBiWpB/gQdN8g/l2UJG+7PoB/Jcnfj782XLXbhMAnqn87AkOrPl24R5aHUVZQdueCEG9rEiDpmAS0Hzh9KunyoeufXHTvCI21j2X7HZu7c7f5iiAgt9tYnQfZjAlH/K7jF8fiWLHTunIqVjqi0q35C3hXp+GsTk7OFimjPbJtMhVhjSewhnseicp7Jh3rAGsHhX0bMqACInTWf0BX/QETwfr3TXxieYvrXCjdqkQ9coIqT+HoE38bLE/GklqSOnyKein7BfJWwcYIlWnFtZ2r6HHavt60717+VHpsy4Ls+JuhAHbRVEhF+rYpFDCfE2aI7Bqtxom3CZCsdpDb6FoGiNOuz+QnUdnSjZhRqUXAN8NZDwJXhSvjZSJZ14Pis64FQEE
 smg/pCiU
 IklBwOVMqIE2lcQEoMYVz8M+XST8TKLyNmJlrOYQqeOaqhpHJSwn5IH9lb70z1Cgon1nOVYjB7kNkRJa+05MosJLiv3HJlw+kA+FqT1JnrodB+v6RTPpCSvVtXKb+0XMXg2MjezJ+6fbwf5xiTr38V6IIWytpXZKQjUlOL1XBiygsNF/8wydfayZB5yy3WicKUGnXKQ4b/0JLL8QA429pp+Ynvd360Tqi6HSJ1xQpak24z+T1pN/YH4GXu6klJ5OrJcVj+YduywxqguoTSx++h/m7Yg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filters that are handled by the ops layer are linked to
damos->ops_filters.  Owing to the ops_ prefix on the name, it is easy to
understand it is for ops layer handled filters.  The other types of
filters, which are handled by the core layer, are linked to
damos->filters.  Because of the name, it is easy to confuse the list is
there for not only core layer handled ones but all filters.  Avoid such
confusions by renaming the field to core_filters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h                                  | 10 +++++-----
 mm/damon/core.c                                        |  6 +++---
 mm/damon/tests/core-kunit.h                            |  4 ++--
 .../testing/selftests/damon/drgn_dump_damon_status.py  |  8 ++++----
 tools/testing/selftests/damon/sysfs.py                 |  2 +-
 5 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6e3db165fe60..3813373a9200 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -492,7 +492,7 @@ struct damos_migrate_dests {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @migrate_dests:	Destination nodes if @action is "migrate_{hot,cold}".
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
- * @filters:		Additional set of &struct damos_filter for &action.
+ * @core_filters:	Additional set of &struct damos_filter for &action.
  * @ops_filters:	ops layer handling &struct damos_filter objects list.
  * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
@@ -518,7 +518,7 @@ struct damos_migrate_dests {
  *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
- * &filters
+ * &core_filters
  *
  * The minimum entity that @action can be applied depends on the underlying
  * &struct damon_operations.  Since it may not be aligned with the core layer
@@ -562,7 +562,7 @@ struct damos {
 			struct damos_migrate_dests migrate_dests;
 		};
 	};
-	struct list_head filters;
+	struct list_head core_filters;
 	struct list_head ops_filters;
 	void *last_applied;
 	struct damos_stat stat;
@@ -872,10 +872,10 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
 
 #define damos_for_each_core_filter(f, scheme) \
-	list_for_each_entry(f, &(scheme)->filters, list)
+	list_for_each_entry(f, &(scheme)->core_filters, list)
 
 #define damos_for_each_core_filter_safe(f, next, scheme) \
-	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
+	list_for_each_entry_safe(f, next, &(scheme)->core_filters, list)
 
 #define damos_for_each_ops_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->ops_filters, list)
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d4cb11ced13f..aedb315b075a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -306,7 +306,7 @@ void damos_add_filter(struct damos *s, struct damos_filter *f)
 	if (damos_filter_for_ops(f->type))
 		list_add_tail(&f->list, &s->ops_filters);
 	else
-		list_add_tail(&f->list, &s->filters);
+		list_add_tail(&f->list, &s->core_filters);
 }
 
 static void damos_del_filter(struct damos_filter *f)
@@ -397,7 +397,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 	 */
 	scheme->next_apply_sis = 0;
 	scheme->walk_completed = false;
-	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 	scheme->stat = (struct damos_stat){};
 	INIT_LIST_HEAD(&scheme->list);
@@ -995,7 +995,7 @@ static void damos_set_filters_default_reject(struct damos *s)
 		s->core_filters_default_reject = false;
 	else
 		s->core_filters_default_reject =
-			damos_filters_default_reject(&s->filters);
+			damos_filters_default_reject(&s->core_filters);
 	s->ops_filters_default_reject =
 		damos_filters_default_reject(&s->ops_filters);
 }
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0d2d8cda8631..4380d0312d24 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -876,7 +876,7 @@ static void damos_test_commit_filter(struct kunit *test)
 static void damos_test_help_initailize_scheme(struct damos *scheme)
 {
 	INIT_LIST_HEAD(&scheme->quota.goals);
-	INIT_LIST_HEAD(&scheme->filters);
+	INIT_LIST_HEAD(&scheme->core_filters);
 	INIT_LIST_HEAD(&scheme->ops_filters);
 }
 
@@ -1140,7 +1140,7 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	struct damos scheme;
 	struct damos_filter *target_filter, *anon_filter;
 
-	INIT_LIST_HEAD(&scheme.filters);
+	INIT_LIST_HEAD(&scheme.core_filters);
 	INIT_LIST_HEAD(&scheme.ops_filters);
 
 	damos_set_filters_default_reject(&scheme);
diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index cb4fdbe68acb..5374d18d1fa8 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -175,11 +175,11 @@ def scheme_to_dict(scheme):
         ['target_nid', int],
         ['migrate_dests', damos_migrate_dests_to_dict],
         ])
-    filters = []
+    core_filters = []
     for f in list_for_each_entry(
-            'struct damos_filter', scheme.filters.address_of_(), 'list'):
-        filters.append(damos_filter_to_dict(f))
-    dict_['filters'] = filters
+            'struct damos_filter', scheme.core_filters.address_of_(), 'list'):
+        core_filters.append(damos_filter_to_dict(f))
+    dict_['core_filters'] = core_filters
     ops_filters = []
     for f in list_for_each_entry(
             'struct damos_filter', scheme.ops_filters.address_of_(), 'list'):
diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index b34aea0a6775..b4c5ef5c4d69 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -132,7 +132,7 @@ def assert_scheme_committed(scheme, dump):
     assert_watermarks_committed(scheme.watermarks, dump['wmarks'])
     # TODO: test filters directory
     for idx, f in enumerate(scheme.core_filters.filters):
-        assert_filter_committed(f, dump['filters'][idx])
+        assert_filter_committed(f, dump['core_filters'][idx])
     for idx, f in enumerate(scheme.ops_filters.filters):
         assert_filter_committed(f, dump['ops_filters'][idx])
 
-- 
2.47.3

