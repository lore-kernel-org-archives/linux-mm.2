Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9053EFED3CD
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 14:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E67236B008C; Fri, 24 Apr 2026 10:01:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0F56B0092; Fri, 24 Apr 2026 10:01:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C435C6B0095; Fri, 24 Apr 2026 10:01:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ABF3B6B008C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 10:01:30 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DEF71401B3
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:29 +0000 (UTC)
X-FDA: 84693611898.23.E605A7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57CBD100010
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:01:27 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g3/mycHd";
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777039287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gq8hMcLQsxKh/kATa1bM8rI+WPiRdld8UzB9IO1M758=;
	b=sWvzGgXGjbhNWPNguy+lZrrJsdTimt0nKgl/mcx+6ENyQniIksdy85fkaGLcsbCFHyjO5j
	I0dWstldGOwcRGD9T8MKhhtAehMOeBQHsWFnw88JJ4NiOHFa2jQTgdV0/mt80PMME67rMe
	jGyl9jOLHZlEJE5XawyRX6BLD+v7TFM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777039287; a=rsa-sha256;
	cv=none;
	b=oXATBAL7IAfUhtpcsGElR19ev07m0muAb+q5wyBSi6plViPeDtSbKltjjztU4OSBg/SUFC
	41D4HlVPLz9YW04hb5RAzVPBykeDbyHygmqWSEmOIo2u1XOJ2zptUHIXpsVGXDjvmHu2NM
	oX+LXdg+lXGmjRDmw11XxrA9rr2fy5U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="g3/mycHd";
	spf=pass (imf05.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 706CF43D4A;
	Fri, 24 Apr 2026 14:01:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93D1CC2BCB5;
	Fri, 24 Apr 2026 14:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777039286;
	bh=OMk8G83SwVj9TZi6pSd7RKvp6NWeeiZOhOo5iK9u9hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g3/mycHdG1w/wHSq1REskac8ra3x8JGBb1lHFVdN7P1hhPz4Y0FiwTGP9U5OFZxIi
	 dYhnt5nfG9T3kn2yS21djgpX2Ka6gViUNDTCqV8LO7TWnxnfM9q4jlg2LxGQNcPlvK
	 Ib2XS1nIVnxGi2NIi9+0gs3M7ijhNPin3sYOoANBE2DQOul5r2n5IaV1r+N0vcLiXr
	 nK3vUQ/xjUNY5n7Kn4nTCwnXXNTci6GmJREghaIm2+UQYMn/YZOo5a/GD5qiOvMTLh
	 TGcGpTLT/bfxLUj6ha8qaheYrBhIZg9m7mMYIpD2urYuIaLP8Hk4kpelirNJPO0Tsx
	 kGLemIdZExQEw==
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
Subject: [RFC 2/7] mm: add page consistency checker header
Date: Fri, 24 Apr 2026 10:00:51 -0400
Message-ID: <20260424140056.2094777-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424140056.2094777-1-sashal@kernel.org>
References: <20260424140056.2094777-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 57CBD100010
X-Rspamd-Server: rspam07
X-Stat-Signature: 3bd8mzcobnmi41jehno731e47jp38zdp
X-Rspam-User: 
X-HE-Tag: 1777039287-752791
X-HE-Meta: U2FsdGVkX18eLjh1cMGBptY7uip7XUkvwhd+u0Taca2lIIHm7jC64N1nJAhFszkjZcL8T6RRi4+jIhRESVOSw2ztPHKGV4+/8zeXfeMHkj/EGrp4Rj74EFlEABYWxDcEhT4QeXikr44x9gFgLWzwN8Yu0bfwQZCZfPAe1ghftIRe3o0O4fAPLVqRXnnUDdUMXjXdXA+lLpIb2j4wb+d8PjCj10h6cBa3pjvFCJkPDQQKyaRCnf2i9sx65Zei7wSPybO55+1JdrQOFRGekpN5cOyqardwYRH/zhlUMYgwdLQJHftnQEGegLta+0L+7yHZawifXrdbbc9JBorhEWZLrrev9vJ0iaBHCYvNiFSq5/x9s9yjTn+WnvemLZGJw2SzqvpbZxlDTPbpZtG8DOgpANcI0+9sWyVV1yZqCfhifvi+gk0pLHkP9mDFN4eD9WxOWyvpVtHOyjsawK/NYYIIV3ZoZWxov28V7nqIaqE59kGhQdOpr/CpmjX6swtKBLiBbf5gdFwn9iaGJ8ZmGBky0aYoKeTE6N5aFJXs+e3sV9M+tialyfNgM6cr73dZW6cEdE2v2z18nBKeAduK+fGljaFc9GhB1SkYG5HR4OEv3ZphCLSYvVTZpeAkoamao2fX0hWwqrguJ87yVk0A6DASBhEo7qWeoN3OyVbVGgO+N76waPeBuIVSwCgteIPU20eU/SG4/ReuMI3dqqWnL+9XI+DTgXOnQeHVD+5/JvWuT9A2mZTXsL2BIdKIjYedkew5na+iQzhklwxMOZNkY77do2NP2v55fGmhwfnDJhLDaErHZ9434HK8nfbTsQpYY2YRWZhthTSAiibdgm0vbD8x8yT60XcH7O4F8wq8kesblie2dlndohfh5cRin22GhUhqYuVW7pbce7smMk2I9MK+8HRxzZb0hPTw8GpMoBEmA5CPWWLoB9d0g4GvvG7NeF36Nw3F8bQEvnNkrXg39d2
 /jbHPQ9+
 IZeTHJi1V+kmt62hYmakrvJ7aUiN30bQbN+F6zobQLV9yfq0QIFL4ACOm7Ujemnt+VHDkBSdHMpwPXHLXyFqZ5OrL98InvuCaehnMeo5Ru5K7OKQYyQZK9sEHTfjDVJsCb9YOsgiuwILKfxAXkNBu5Ph+exRKSQoz1oo1vnyN/S1EFasTHTUsYuEQ0zoPZ3wv7U3mTtwV/KU26wnPcIWPkRkabiIo4HLsc+9ULwaXRtGTyValXI3s9hFOG5LcNHBBNeg8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sasha Levin <sashal@nvidia.com>

Define the interface for CONFIG_DEBUG_PAGE_CONSISTENCY. The API mirrors
the pattern used by page_table_check: inline wrapper functions check a
static key before calling the out-of-line tracking implementation, so
that callers in the allocator hot path only pay for a predicted-not-taken
branch when the feature is built in but not active.

The header is kept separate from the implementation so the hooks in
page_alloc.c can be added without pulling in implementation details.

Based-on-patch-by: Sanif Veeras <sveeras@nvidia.com>
Assisted-by: Claude:claude-opus-4-7 <noreply@anthropic.com>
Signed-off-by: Sasha Levin <sashal@nvidia.com>
---
 include/linux/page_consistency.h | 84 ++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)
 create mode 100644 include/linux/page_consistency.h

diff --git a/include/linux/page_consistency.h b/include/linux/page_consistency.h
new file mode 100644
index 000000000000..f335fa3d6c5d
--- /dev/null
+++ b/include/linux/page_consistency.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Dual-bitmap page consistency checking
+ *
+ * Provides corruption detection for page allocations using complementary
+ * bitmaps where the invariant (primary == ~secondary) must hold.
+ *
+ * Based on NVIDIA safety research.
+ */
+#ifndef _LINUX_PAGE_CONSISTENCY_H
+#define _LINUX_PAGE_CONSISTENCY_H
+
+#include <linux/types.h>
+#include <linux/mm_types.h>
+
+/* Return codes for page consistency checking */
+enum page_consistency_result {
+	PAGE_CONSISTENCY_OK = 0,
+	PAGE_CONSISTENCY_MISMATCH,
+	PAGE_CONSISTENCY_NOT_TRACKED,
+};
+
+#ifdef CONFIG_DEBUG_PAGE_CONSISTENCY
+
+#include <linux/jump_label.h>
+DECLARE_STATIC_KEY_FALSE(page_consistency_enabled);
+
+/* Initialization - called during mm_core_init() */
+void __init page_consistency_init(void);
+
+/* Core tracking functions */
+void __page_consistency_alloc(struct page *page, unsigned int order);
+void __page_consistency_free(struct page *page, unsigned int order);
+
+/* Validation functions */
+enum page_consistency_result page_consistency_check_page(struct page *page);
+enum page_consistency_result page_consistency_validate_all(void);
+
+/**
+ * page_consistency_alloc - Track page allocation
+ * @page: Allocated page
+ * @order: Allocation order
+ *
+ * Called from post_alloc_hook() to track page allocations.
+ * The static key avoids the out-of-line tracking call until initialization.
+ */
+static inline void page_consistency_alloc(struct page *page, unsigned int order)
+{
+	if (static_branch_unlikely(&page_consistency_enabled))
+		__page_consistency_alloc(page, order);
+}
+
+/**
+ * page_consistency_free - Track page free
+ * @page: Page being freed
+ * @order: Free order
+ *
+ * Called from free_pages_prepare() to track page frees.
+ * The static key avoids the out-of-line tracking call until initialization.
+ */
+static inline void page_consistency_free(struct page *page, unsigned int order)
+{
+	if (static_branch_unlikely(&page_consistency_enabled))
+		__page_consistency_free(page, order);
+}
+
+#else /* !CONFIG_DEBUG_PAGE_CONSISTENCY */
+
+static inline void __init page_consistency_init(void) {}
+static inline void page_consistency_alloc(struct page *page, unsigned int order) {}
+static inline void page_consistency_free(struct page *page, unsigned int order) {}
+
+static inline enum page_consistency_result page_consistency_check_page(struct page *page)
+{
+	return PAGE_CONSISTENCY_OK;
+}
+
+static inline enum page_consistency_result page_consistency_validate_all(void)
+{
+	return PAGE_CONSISTENCY_OK;
+}
+
+#endif /* CONFIG_DEBUG_PAGE_CONSISTENCY */
+#endif /* _LINUX_PAGE_CONSISTENCY_H */
-- 
2.53.0


