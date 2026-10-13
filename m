Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB066CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 00:27:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685D86B008C; Mon, 12 Oct 2026 20:27:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9306B0092; Mon, 12 Oct 2026 20:27:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B2416B0095; Mon, 12 Oct 2026 20:27:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D39E6B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:27:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C464A0C40
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:10 +0000 (UTC)
X-FDA: 85315713420.16.3292A3C
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf28.hostedemail.com (Postfix) with ESMTP id 0E8DDC0006
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:27:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791851229;
	b=tYhQPXIkB532ZfUbEhIWRoUKU92U7YytmUW8tlSLYnOV/ABJGFbnP23FhrjDtxd+VrUXx2
	rxEt3P9ojqbiwBbpAggszwrNYg9WDdQ3gG9VN15Obiryl4ncpSHREqwbCaW3Aq6Se7gu8Y
	Y1285rDJYK8eaUmOjmdzvOS+H+MbDyk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	spf=pass (imf28.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu;
	dmarc=pass (policy=none) header.from=mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791851229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dDOzcDGaalTM5WE9tF4beTCCpOehQc62hsVGjItGl5M=;
	b=XXwFz6K6XRGfygo8le0b4kzk/urCyxjZ1xxVT5PGOEBXzL6DwcC4cpf2XB6lPHyC/e1waV
	4rs2EyXCPyqjQQ/JVC9d7pb0Mt0Iln3DVvrpS2g5WeInpOulEjxw45JNEdr2IoFgTyjqV2
	/xFwKV395/vbK9KPzHk0cvyz9eXvc4M=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xGQMC-00GgqH-Be;
	Mon, 12 Oct 2026 20:27:04 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1 3/3] ida: free the preallocated node on the ida_alloc_range() failure paths
Date: Mon, 12 Oct 2026 20:27:03 -0400
Message-ID: <20261013002703.773923-4-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013002703.773923-1-nickolai@csail.mit.edu>
References: <20261013002703.773923-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E8DDC0006
X-Stat-Signature: qdaq9zehkrcp33soknbx4jdh4q7ngpc8
X-HE-Tag: 1791851228-980999
X-HE-Meta: U2FsdGVkX18GfxTRSRRibiunMj6Jdikb8GDJy5f19sRxalZI5qUKMmBq3UskH3zV9DVTaG1ALWPexC5a66+rKKAsZnJwkZhKvUq8BPizjGg7KxYYdsh9JNEmjOb/vIXKIZRTyaTZCGffeJvguM9iOBJtlqmscBWJQV5NS7+ljGY2k7qcjMZ8x2ieHJ7kZ/arVnyxpy9J4Sq7kgAY5N5nTcZt/zRgM0cyk3cbltoCvW686+2aLOZoJAaIu4job3Taf6ZeMjEN0N3aIUu4bSum3MevNbD5qoXvtimCiLqmTde9OmAmu63aqAcu2JB4WyQoCj5/vORK7HW5UAblQbR6W78VvCQ9tb8jluV0qEkJDdgUnUjUxLm7lO5dC8YSYKBOD0RX1r1GS4q4Xl/uAZs/UMZVBxGwf5v9O6tNOMVQFuNSTaHtEPEz+GmUvBuaWEzsodJXqbGQJ8YcMQscqXzcEK6bbUjRyXxNbEOKq22PvfQ3oiB1jn5OGMv+rH5asSPWLZo3av0RMHMmWn/08blBwaVgxEvXbSaH276yVaqsqwFUhtkBkG8tmAjliv969eDxk/ssT1ukTMOhXf2O+Swqjd6iBcAF8FspqwrhaQL4rzabG4whQsgv+pOAo/ETs/Xgib1p3yKlvHuYeWO+TzQd+nFjPvkgp5mOsvSXq5ihBFfnM65qK6xNuAAluYFTMPpk8QfOKW1+7N3qVbjzKyE47gMD1IbfOHg+wn5elw2T+MdvQ+VpMom9WO6KkxZU2CmQXe4iB3ijI/fdxzT3Sju5b0WrOQijZxZ/qQ+ODwbYnN1tN5ppeQUrVZ1GjtStMdDYXR6RebDe+uZQnr18lQB3Kw2FI/0ySj1wEkd6+QfU5cTON7eqOl8ppLHndgKJEfgSiXqGymqgLCmfTf2eyEN1f6hI+zmoYKa6W9U3BcXFmuYheDT3O1j3GlXknGsKZ6dRua3pURqXgElxDghpTu8
 rB+C0sVi
 v9q3e4qCnHft0WKUDqaYsN7gOtJyibvMGrFe4pNJLF9Nn7hfqgNjRjcJxJqc4upH0MwOZ2/y5BvOM88Hsc26HX0+wm8ZGaHGk/P7PZFBDVVtCRS1YvuyWRZYmccxLVnudKBYlQX/kjOpRnPM5ctnr/j0vOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When xas_store() in ida_alloc_range() fails for want of a node,
xas_nomem() allocates one into xas.xa_alloc and the function retries.
The retry either consumes that node in xas_store() or, if it reaches
"out:" without needing it, returns it through xas_nomem(), which calls
xas_destroy() when the state is not -ENOMEM.  Two exits do neither:

 - "nospc:", when the retry finds no free ID in [min, max] any more.
   The failed round stored nothing, so this means that another
   allocation took the IDs while the lock was dropped in xas_nomem();
   exact-ID callers, ida_alloc_range(ida, id, id, gfp), are the usual
   way to get there.

 - The -ENOMEM return at "alloc:", when the retry needs a bitmap and
   both the GFP_NOWAIT and the gfp allocation of it fail.

Each occurrence leaks a struct xa_node (576 bytes) from the
radix_tree_node cache.

Call xas_destroy() on both exits.  It is called with the lock dropped,
as xas_nomem() itself does, and it is a no-op when nothing was
preallocated.

This was found while formally verifying ida_alloc_range() against the
kernel binary.  Add ida_check_retry_nospc() to the
tools/testing/radix-tree harness: an exact-ID allocation whose first
store fails loses its ID to an allocation made in the window where
xas_nomem() has dropped the lock, for an ID in a value entry and for one
in a bitmap.  Without the fix the harness counts one node still
allocated after the IDA has been emptied.

Fixes: f32f004cddf8 ("ida: Convert to XArray")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---
 lib/idr.c                           |  5 ++++-
 tools/testing/radix-tree/idr-test.c | 24 ++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/lib/idr.c b/lib/idr.c
index 86c572e60f75..468a9b7adb14 100644
--- a/lib/idr.c
+++ b/lib/idr.c
@@ -473,13 +473,16 @@ int ida_alloc_range(struct ida *ida, unsigned int min, unsigned int max,
 alloc:
 	xas_unlock_irqrestore(&xas, flags);
 	alloc = kzalloc_obj(*bitmap, gfp);
-	if (!alloc)
+	if (!alloc) {
+		xas_destroy(&xas);
 		return -ENOMEM;
+	}
 	xas_set(&xas, min / IDA_BITMAP_BITS);
 	bit = min % IDA_BITMAP_BITS;
 	goto retry;
 nospc:
 	xas_unlock_irqrestore(&xas, flags);
+	xas_destroy(&xas);
 	kfree(alloc);
 	return -ENOSPC;
 }
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index f1e0be0e09ec..4b862f2080cf 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -522,6 +522,29 @@ void ida_check_retry_stale(void)
 	IDA_BUG_ON(&ida, !ida_is_empty(&ida));
 }
 
+/*
+ * The node preallocated by xas_nomem() must be freed when the retry finds
+ * that another allocation took the only ID in range, whether that ID lives
+ * in a value entry or in a bitmap.
+ */
+void ida_check_retry_nospc(void)
+{
+	DEFINE_IDA(ida);
+	unsigned int ids[] = { IDA_BITMAP_BITS + 5, IDA_BITMAP_BITS + 63 };
+	int allocated, i, id;
+
+	rcu_barrier();
+	allocated = nr_allocated;
+	for (i = 0; i < ARRAY_SIZE(ids); i++) {
+		id = ida_alloc_window(&ida, ids[i], ids[i], ids[i]);
+		IDA_BUG_ON(&ida, id != -ENOSPC);
+		ida_free(&ida, ids[i]);
+		IDA_BUG_ON(&ida, !ida_is_empty(&ida));
+		rcu_barrier();
+		IDA_BUG_ON(&ida, nr_allocated != allocated);
+	}
+}
+
 /*
  * Check handling of conversions between exceptional entries and full bitmaps.
  */
@@ -594,6 +617,7 @@ void user_ida_checks(void)
 
 	ida_check_nomem();
 	ida_check_retry_stale();
+	ida_check_retry_nospc();
 	ida_check_conv_user();
 	ida_check_random();
 	ida_alloc_free_test();
-- 
2.53.0


