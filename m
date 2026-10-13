Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD844CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 00:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C6DF6B008A; Mon, 12 Oct 2026 20:27:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37BA36B008C; Mon, 12 Oct 2026 20:27:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268266B0095; Mon, 12 Oct 2026 20:27:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4BB56B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:27:09 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6E2A9A8FDD
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:09 +0000 (UTC)
X-FDA: 85315713378.05.019FBCE
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf31.hostedemail.com (Postfix) with ESMTP id BBD2720006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791851228;
	b=YKLLqKUTs71rYsaOP1Wb3d3QWnY2mhE0AN1ro+WggbGbjcRhRpxLFPwR3rWO6K9r8Jdb+H
	1NrECk6Fhppy7GQ/msukqvR0U/3to130DP1yXvXkjmGPS3jF4TYv+/JNV6HapRzwl3OdGP
	DPmcyEQkkqN3sDwc82z7Z8ZzYb4L0Jg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=none;
	spf=pass (imf31.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791851228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vKsQrWYFwE5Mbf2zpGkAELyRgNFYJ9IlLnZ2RBrVkiM=;
	b=WSKERPScnbLIQpDO5qON3rUEh+egick6aX/OctbmU5obzmru5DmJT2WKwCsttXXm685dL0
	HMT+dqdGSQsmfKOf4Yr77FLnHVeUv9Q+6tz1EW9Jq5IDNDQ2jvRksy+xMRT+MwHYEmaOy2
	e2vhDyM/6wyp6pLZbDpgNq0xhRl1SIY=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGQMC-00GgqH-5y;
	Mon, 12 Oct 2026 20:27:04 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1 1/3] ida: clear the bit of a bitmap that ida_alloc_range() failed to store
Date: Mon, 12 Oct 2026 20:27:01 -0400
Message-ID: <20261013002703.773923-2-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013002703.773923-1-nickolai@csail.mit.edu>
References: <20261013002703.773923-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: BBD2720006
X-Stat-Signature: rmxek9qqbuumu6amru7gfnnf8feqm15e
X-HE-Tag: 1791851227-391957
X-HE-Meta: U2FsdGVkX18/OEtBdJgUIQN9SDIgIAZUkmvVY07tfCR4LV+tM/rHjhxf43SZxt4aLLM0QffM6kWXilukr0gxMWWxlv0j4A9tmtOjujwNmvCa949LH2mtMjwvHjnCuX+Oyqo8MsJF+RdClRBAr+opWOS3gqf7vNI4wMmQXUOuC/3n0RxMjVS24a0NOKQu6rVCkoxYOO26DPU0naIJgOlGuvlhAWvLEqamuYEDlfrOfaNCulPPMAlLN5DAe4/KVkJKWq2SxiwuHWfTnsVq3TJSpZwiAF9P939o6p7ppCL7owdSeXDj7z+Oq2PPkdjUPcsIRs5VsL1Lb+eoPHetna/wYXao70gfm42rwsoxJSU6p8NYI0G/8t91otEYucKLcnYaeHVgRqL8dwMJ/F+PWYkgRQ20RNJGcGYOTpb0KC6uAHyULMyg015WKwmpy5ya+HILfW9Yj3ZlyOyUYn9IY3zcrCYPvb5onXoVFA6dawzJjV7RVNGBNfiVPMdEBeuibti4rhetxbikWJslnlNi/Kq6s/3aRUf470IKgAONBisa096VdgS8P3rlmlPRLpqLeHjpbsd1T1/c6OoYrlhTshF8Lo4DEcPLvzgik329ihcWnKK0hgdqF+qxk7zNK+ybr/VS1g8Enbm6ErqjD2wnpCC7W9kgrcn5dunL18+59h+gpBXvqCpP7SyYasMz8pVUWhptOoIDgG6GvW8XS6m+xqQ7NLEY1vArb3iGWYfYLkgAmqw3gsE5+vL5WpECd8wNq0ICWk7efpnY8ubV9kEgzdQEAiDdyNoTF7Fxj/RFrSoGNcMhdrhfL0LXhp8DmpYYq0oWJsU072Bm3PQQFi9qEFzZPBIzgn48dEeFoID5VrZt5SJjE2tVDZ3VuAi1bDXJ30otJPjroyXJO2z8T/cmY8MHKF52G9sHofbah/VkZuDib6ri9yXroxHHx4KFk/bI0enAPh8bDO+xfCFPwSjmbCV
 jTnfO8Op
 SYVQNaX4NlO7oGPlB/nOWC7w6ClZBgeCZrXRg81U41zY4/JdT0qXUrfSsMy72xJw0hXFwgebx/j2xNPOCDsrpKSHdwnOPOWgdAhCnHlIoBGVkjDjnZ5mKFTAvI6qnsBUUXfTnE9LX/iApU9ZFoXEJ5Hte2/WgwpCkRGW0iFOlUUIKGEEPFek6qocvMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ida_alloc_range() sets the requested bit in a new bitmap before it calls
xas_store().  When the store fails because xas_alloc() could not get a
node with GFP_NOWAIT, nothing is stored, but the bit stays set.  If the
bitmap is the one preallocated at the "alloc:" label, the retry after
xas_nomem() reuses it.  The lock was dropped in between, and if another
allocation stored a value entry for that chunk meanwhile, the retry
converts the value entry into the bitmap by writing word 0 only, so a
stale bit at position 64 or above survives into the stored bitmap.

The result is an ID which is marked as allocated but which nobody owns.
The retrying caller gets the next free ID instead of the one it asked
for, an exact-ID caller (ida_alloc_range(ida, id, id, gfp)) gets -ENOSPC
for an ID that nobody holds, and the bitmap of that chunk never becomes
empty, so ida_free() can never free it.

Clear the bit again when the store fails; it was never visible.

This was found while formally verifying ida_alloc_range() against the
kernel binary.  Add ida_check_retry_stale() to the
tools/testing/radix-tree harness: it runs a second allocation from the
node cache callback, which fires in the window where xas_nomem() has
dropped the lock.  Without the fix the caller gets ID 1101 instead of
1100 and the IDA is not empty after both IDs have been freed.

Fixes: f32f004cddf8 ("ida: Convert to XArray")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 lib/idr.c                           |  2 ++
 tools/testing/radix-tree/idr-test.c | 53 +++++++++++++++++++++++++++++
 tools/testing/radix-tree/test.h     |  4 +++
 3 files changed, 59 insertions(+)

diff --git a/lib/idr.c b/lib/idr.c
index 69bee5369670..f298660f5c80 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -450,6 +450,8 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 			__set_bit(bit, bitmap->bitmap);
 		}
 		xas_store(&xas, bitmap);
+		if (xas_error(&xas) && !xa_is_value(bitmap))
+			__clear_bit(bit, bitmap->bitmap);
 	}
 out:
 	xas_unlock_irqrestore(&xas, flags);
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 945144e98507..f1e0be0e09ec 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -470,6 +470,58 @@ void ida_check_nomem(void)
 	IDA_BUG_ON(&ida, !ida_is_empty(&ida));
 }
 
+/*
+ * Run a second allocation on the same IDA while ida_alloc_range() has
+ * dropped the lock in xas_nomem() to allocate a node.  In userspace every
+ * GFP_NOWAIT allocation fails, so an allocation in a chunk which has no
+ * node yet fails its first store and retries; the node cache callback runs
+ * before xas_nomem() allocates, with the lock dropped.
+ */
+static struct ida *window_ida;
+static unsigned int window_min;
+static int window_id;
+
+static void ida_window_alloc(void *unused)
+{
+	kmem_cache_set_callback(radix_tree_node_cachep, NULL);
+	kmem_cache_set_non_kernel(radix_tree_node_cachep, 1);
+	window_id = ida_alloc_min(window_ida, window_min, GFP_KERNEL);
+	kmem_cache_set_non_kernel(radix_tree_node_cachep, 0);
+}
+
+static int ida_alloc_window(struct ida *ida, unsigned int min,
+			    unsigned int max, unsigned int other)
+{
+	int id;
+
+	window_ida = ida;
+	window_min = other;
+	window_id = -1;
+	kmem_cache_set_callback(radix_tree_node_cachep, ida_window_alloc);
+	id = ida_alloc_range(ida, min, max, GFP_KERNEL);
+	kmem_cache_set_callback(radix_tree_node_cachep, NULL);
+	IDA_BUG_ON(ida, window_id != other);
+
+	return id;
+}
+
+/*
+ * A bit set in a bitmap whose store failed must not be stored by the retry
+ * once another allocation has put a value entry in that chunk.
+ */
+void ida_check_retry_stale(void)
+{
+	DEFINE_IDA(ida);
+	unsigned int min = IDA_BITMAP_BITS + BITS_PER_LONG + 12;
+	int id;
+
+	id = ida_alloc_window(&ida, min, ~0, IDA_BITMAP_BITS + 5);
+	IDA_BUG_ON(&ida, id != min);
+	ida_free(&ida, IDA_BITMAP_BITS + 5);
+	ida_free(&ida, id);
+	IDA_BUG_ON(&ida, !ida_is_empty(&ida));
+}
+
 /*
  * Check handling of conversions between exceptional entries and full bitmaps.
  */
@@ -541,6 +593,7 @@ void user_ida_checks(void)
 	radix_tree_cpu_dead(1);
 
 	ida_check_nomem();
+	ida_check_retry_stale();
 	ida_check_conv_user();
 	ida_check_random();
 	ida_alloc_free_test();
diff --git a/tools/testing/radix-tree/test.h b/tools/testing/radix-tree/test.h
index 7ef7067e942c..8ca50a58e138 100644
--- a/tools/testing/radix-tree/test.h
+++ b/tools/testing/radix-tree/test.h
@@ -48,6 +48,10 @@ void tree_verify_min_height(struct radix_tree_root *root, int maxindex);
 void verify_tag_consistency(struct radix_tree_root *root, unsigned int tag);
 
 extern int nr_allocated;
+extern struct kmem_cache *radix_tree_node_cachep;
+void kmem_cache_set_callback(struct kmem_cache *cachep,
+			     void (*callback)(void *));
+void kmem_cache_set_non_kernel(struct kmem_cache *cachep, unsigned int val);
 
 /* Normally private parts of lib/radix-tree.c */
 struct radix_tree_node *entry_to_node(void *ptr);
-- 
2.53.0


