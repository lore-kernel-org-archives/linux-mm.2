Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8DC19606A332
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 02:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=PLDr99jG
Received: by kanga.kvack.org (Postfix)
	id B362C6B05B3; Mon,  2 Nov 2026 21:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB8EE6B05B6; Mon,  2 Nov 2026 21:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98E2E6B05B3; Mon,  2 Nov 2026 21:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 621526B05B3
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 21:07:49 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5E82120197
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:48 +0000 (UTC)
X-FDA: 85392171816.13.5A3C85B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 196A4100005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 02:07:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PLDr99jG;
	spf=pass (imf05.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793671667;
	b=n0tYvOTI1iKV8nKerKerVPYdB0PMxzGZksYIoQl2PM3MWzQUj7spv1l+JYM1oQqQAmFDiN
	qEXpXHRAji0rF5zxIvbDAWlOu3nWMU0/1BZ5vqbb0kDGwuAya07wjYuJ6aZl25OzKSRV/1
	exgwuT8Fe+kF9AELWr01yXh7Yw0AKYw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=PLDr99jG;
	spf=pass (imf05.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793671667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZFi2mAWq4lB8sfvhCBMvmbDAWZypjFWJ5S9ABz2IMQ=;
	b=8oTnYJ6GPTJRmltWgLjPY5n9KsUU3LOreGcbqP4GL7yGlR+MPROFkI0C3R/rgSl114ikSZ
	lcTL48HbLB2Ik/SdpBF8AqpraOT69XcGsv0ib67cIzkXgex8oTjq6exhRm9XUMIJKOb2NY
	poQxDMzq5uhKUz0ijmf4Afapq+sGeXk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=UZFi2mAWq4lB8sfvhCBMvmbDAWZypjFWJ5S9ABz2IMQ=; b=PLDr99jGAHpZOPhy+SMGmYcYQc
	9qGVEjN70Wa7zfgxRDMiqCJLtSwU2mGacYQG7JTRIKjtooQhX1+kxk71XIgshMOnbNrIMmlSI8UBS
	xE2Sgj1RgcQ77yAZZ+2wLc1YrtzB8zcjyC3CJ0G5ddTBML2n9d1eIiHj4HYWXybdPO4R2SwlQ3zqT
	28gyvsUtpir+7LPw/+aYSd+nSeSz6u36d2RzRw9nVBMfhI2c2ytYodwG7vkYkBdhdL5bUh7jA9TU5
	CV0BiovbsHohoYKYdthwMNDblTVBpTwuUZDkVpNwqMZXSgWZAIYfKHquY/Pz2K1Xu/x2wtMwp6HBY
	07WMVa9w==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xO3w9-00000000qwc-3pSM;
	Tue, 03 Nov 2026 02:07:46 +0000
From: "Liam R. Howlett (Google)" <liam@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	maple-tree@lists.infradead.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Chris Mason <mason@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	"Liam R. Howlett (Google)" <liam@infradead.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 3/3] maple_tree: Update internal warning and bug_on code
Date: Mon,  2 Nov 2026 21:07:24 -0500
Message-ID: <20261103020724.2614498-4-liam@infradead.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261103020724.2614498-1-liam@infradead.org>
References: <20261103020724.2614498-1-liam@infradead.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 196A4100005
X-Stat-Signature: j1g63y3gy5u3n77wsi9bk6fur8ttuft3
X-Rspam-User: 
X-HE-Tag: 1793671666-751386
X-HE-Meta: U2FsdGVkX18TSA6wb6l9ivxrIt1sT42/byYUkzqDVnZcKkQIijgw1fgsHFIkDO4FQKmmGV2Mx0/JtnM1pw60vJYvTTP4Gjx9vAnJaqm3knInU9+/BRzA2nca/NTVfU8ICGXH4y6t6nl1iPLcJE8rRI3ln5AvgV0frYcV00i9+5U2i2Rt6Tyk7TpzQZcCOOYOkdAfFsD9ztBk9sSjXDxRa4JtQlzIdB39aT+5YTxZRwrQpoLD9DI5JVJvXfIQAFPO3CgnpNQTZZ5fBsVwd6S28DGj0FUDacw6PGq0qZlEztSp/qY/CA1FRe1A6hkTPmFD1APZntFFKgHy0fH3c2ZNVvdOGsRBhI5Dl+FUXrgKpEc0cgHhq9UHiBC5h0Jogikaj0uoVos05M8rmWo9RR1RvEicYW6q8e/IbcWQfhWRfjgY2zdj7bVbcDVImgEXJx+7PMuKYLMhZDCDqokAO1mS9HfMDwo/nRCu4P0pIspaMmhaPlmpBpSptOzogDh68EsditU6mfnYI985SiQKVzU6bEPkTWFtTzoJRzZXvxsEWw/KxxT+hmpZgUqkwLj1wgGPsqYVE1IG3bwHatmwd5OGRaxadxtoYoJTKRcZGoE74EjIR9i3Sam0cx6yG5oMgIJhqsbCsaXkdW5KgQua2e2asCByf0ugHtcNkr1EeMcaLeLZccaJ3l69UDP4Bh6A42tq8F+/R1Qb9IC+67OCjbNePXRC/OSb38oFuay7gVeG/PxLDpXp8a+zKLWPr3I6idKtGUwWa1Y/sJpis3LxYFw0fgXY6uxeTqFfSmBERe4CcokW3hnHGIW7DahFm3rYczY7DX83DTU9Sej6igS6DPxXxkKWmLvGF544QFei23VG+WTA5LOjM4pRHrIEvVn/UdqvvYEvj7WxrcY2g8MpzgAVKOK3ZJrFzXfrIZyqQLdpZF5hYxw/j7B4wnXj/JYPXrXHFWj1KWdnds+PJowPdEm
 BXT0YCGR
 RwoDGVhn8qXoWcyfSo1YfFj3JkjkV+2T0XRP+RibPGOgVp9rui1vV88LRt3q05c/fJOk+hQ105/P0KBzBSlF27ksDcSLiU3pVBG+Q/BgslxVkMoPfkfDwRTx9FXmrNEyFZAgLB2/8IrmUPvPGelrYex6wDcBv4Cb9Iu+yVyACR91GVHjhEEh3Xaozww7NoH1P2hFkynAHOE5hAiJOMnhEsWuO5RyL0jdgxwmzWHBPDXvfKJbKR6V7z0ZDyUnWmbRQngT0HC6hKSyTl6SAW76smnQ+WfwJDfYYDA0g4GXOCvg6uyzCqpQrGNxCTA27fnyaiRm2PBkMNyLnyVzAmv8RP2W23U1GMMfSRMwHRNWkgS1dBkpRUWK2vEHMQA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When CONFIG_DEBUG_MAPLE_TREE is set, call WARN_ON() once per site after
the custom information is dumped about the tree.  Without using the
kernel's WARN_ON calls, syzbot will not catch issues detected by this
code.  The BUG_ON variants now stop instead of dumping and continuing.

Update the non-debug code to call WARN_ON_ONCE() as well.

The userspace tests asserted on dump_stack() but only print on
WARN_ON(), so make WARN() fatal in maple-shared.h and have the maple
test exit with the result of maple_tree_seed().

Cc: <stable@vger.kernel.org>
Reported-by: Lorenzo Stoakes <ljs@kernel.org>
Fixes: f0a1f866aba1 ("maple_tree: add debug BUG_ON and WARN_ON variants")
Signed-off-by: Liam R. Howlett (Google) <liam@infradead.org>
---
 include/linux/maple_tree.h          | 48 ++++++++++++++---------------
 tools/testing/radix-tree/maple.c    | 13 +++++---
 tools/testing/shared/maple-shared.h | 33 ++++++++++++++++++++
 3 files changed, 66 insertions(+), 28 deletions(-)

diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index e30e57f5f3df9..3a9751c6689fc 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -680,7 +680,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -696,7 +696,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -713,7 +713,7 @@ void mt_cache_shrink(void);
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
+		BUG_ON(1);						\
 	} else {							\
 		atomic_inc(&maple_tree_tests_passed);			\
 	}								\
@@ -722,16 +722,16 @@ void mt_cache_shrink(void);
 #define MT_WARN_ON(__tree, __x)  ({					\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (__ONCE_LITE_IF(ret)) {				\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mt_dump(__tree, mt_dump_hex);				\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -739,17 +739,17 @@ void mt_cache_shrink(void);
 #define MAS_WARN_ON(__mas, __x) ({					\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (__ONCE_LITE_IF(ret)) {				\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mas_dump(__mas);					\
 		mt_dump((__mas)->tree, mt_dump_hex);			\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -757,18 +757,18 @@ void mt_cache_shrink(void);
 #define MAS_WR_WARN_ON(__wrmas, __x) ({					\
 	int ret = !!(__x);						\
 	atomic_inc(&maple_tree_tests_run);				\
-	if (ret) {							\
-		pr_info("WARN at %s:%d (%u)\n",				\
-		__func__, __LINE__, __x);				\
+	if (!ret) {							\
+		atomic_inc(&maple_tree_tests_passed);			\
+	} else if (__ONCE_LITE_IF(ret)) {				\
+		pr_info("WARN at %s:%d\n",				\
+		__func__, __LINE__);					\
 		mas_wr_dump(__wrmas);					\
 		mas_dump((__wrmas)->mas);				\
 		mt_dump((__wrmas)->mas->tree, mt_dump_hex);		\
 		pr_info("Pass: %u Run:%u\n",				\
 			atomic_read(&maple_tree_tests_passed),		\
 			atomic_read(&maple_tree_tests_run));		\
-		dump_stack();						\
-	} else {							\
-		atomic_inc(&maple_tree_tests_passed);			\
+		WARN_ON(1);						\
 	}								\
 	unlikely(ret);							\
 })
@@ -776,9 +776,9 @@ void mt_cache_shrink(void);
 #define MT_BUG_ON(__tree, __x)		BUG_ON(__x)
 #define MAS_BUG_ON(__mas, __x)		BUG_ON(__x)
 #define MAS_WR_BUG_ON(__mas, __x)	BUG_ON(__x)
-#define MT_WARN_ON(__tree, __x)		WARN_ON(__x)
-#define MAS_WARN_ON(__mas, __x)		WARN_ON(__x)
-#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON(__x)
+#define MT_WARN_ON(__tree, __x)		WARN_ON_ONCE(__x)
+#define MAS_WARN_ON(__mas, __x)		WARN_ON_ONCE(__x)
+#define MAS_WR_WARN_ON(__mas, __x)	WARN_ON_ONCE(__x)
 #endif /* CONFIG_DEBUG_MAPLE_TREE */
 
 /**
diff --git a/tools/testing/radix-tree/maple.c b/tools/testing/radix-tree/maple.c
index bfe4b8626c429..846c67e20e82a 100644
--- a/tools/testing/radix-tree/maple.c
+++ b/tools/testing/radix-tree/maple.c
@@ -36502,22 +36502,27 @@ static void regression_tests(void)
 	test_spanning_store_regression();
 }
 
-void maple_tree_tests(void)
+int maple_tree_tests(void)
 {
+	int ret;
+
 #if !defined(BENCH)
 	regression_tests();
 	farmer_tests();
 #endif
-	maple_tree_seed();
+	ret = maple_tree_seed();
 	maple_tree_harvest();
+	return ret;
 }
 
 int __weak main(void)
 {
+	int ret;
+
 	maple_tree_init();
-	maple_tree_tests();
+	ret = maple_tree_tests();
 	rcu_barrier();
 	if (nr_allocated)
 		printf("nr_allocated = %d\n", nr_allocated);
-	return 0;
+	return ret ? EXIT_FAILURE : EXIT_SUCCESS;
 }
diff --git a/tools/testing/shared/maple-shared.h b/tools/testing/shared/maple-shared.h
index 2a1e9a8594a28..5f827709773a0 100644
--- a/tools/testing/shared/maple-shared.h
+++ b/tools/testing/shared/maple-shared.h
@@ -8,6 +8,7 @@
 #include "shared.h"
 #include <stdlib.h>
 #include <time.h>
+#include <assert.h>
 #include "linux/init.h"
 
 void maple_rcu_cb(struct rcu_head *head);
@@ -20,5 +21,37 @@ do {                                            \
     call_rcu(&((_p_struct)->_memb), rcu_cb);    \
 } while(0);
 
+/* Make WARN() fatal */
+#undef WARN
+#undef WARN_ON
+#undef WARN_ONCE
+#undef WARN_ON_ONCE
+#define WARN(condition, format...) ({				\
+	int __ret_warn_on = !!(condition);			\
+	if (unlikely(__ret_warn_on)) {				\
+		__WARN_printf(format);				\
+		assert(0);					\
+	}							\
+	unlikely(__ret_warn_on);				\
+})
+#define WARN_ON(condition)					\
+	WARN(condition, "assertion failed at %s:%d\n", __FILE__, __LINE__)
+#define WARN_ONCE(condition, format...)	WARN(condition, format)
+#define WARN_ON_ONCE(condition)		WARN_ON(condition)
+
+/* Once state for the debug macros */
+#ifndef __ONCE_LITE_IF
+#define __ONCE_LITE_IF(condition)				\
+	({							\
+		static bool __already_done;			\
+		bool __ret_once = false;			\
+								\
+		if ((condition) && !__already_done) {		\
+			__already_done = true;			\
+			__ret_once = true;			\
+		}						\
+		__ret_once;					\
+	})
+#endif
 
 #endif /* __MAPLE_SHARED_H__ */
-- 
2.47.3


