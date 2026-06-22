Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BC60CD98F6
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391B66B0093; Mon, 22 Jun 2026 00:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3420C6B0096; Mon, 22 Jun 2026 00:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BC4A6B0098; Mon, 22 Jun 2026 00:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D38536B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:07:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3BF2A14054E
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:07:08 +0000 (UTC)
X-FDA: 84906213336.17.69DA4AE
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 77F15C0004
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:07:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RKNYTOPI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782101226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vFaoYZTJfRDH9hDuVHVBgZkR1flChQcp5jR5STw0K2M=;
	b=poAIJPOYSAFkl3zi5qluRyA2K1gKjXyHDRIYw9LXemI5JIH/f/CEPyMihZhhBOcISxrLvw
	cT0EpXCMRJ9ai+Sk3BtmpenWq6knNvdsmcxS1FFk+3V8zsV18jRhtWrVLXBwCjZhunrakW
	+IduZxoDAhlawVmQ0+DIVGLmH6T5c1o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782101226;
	b=qpVph08BQRw/wLWbvpftMIMRNtnFTizPt5pz/lnkL+uJxQera55u/OQUqHmKw8bIdYSSfT
	qJuciRuC/T/2uCO2/lRb9/WQXt5jWnyudbeWnQQNnnDXk0TMDP31ufamqyuF+lAYRW5vDW
	If0m0+3I6My1cQ09ZxVvJQuWZ9kkCfQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RKNYTOPI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782101224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vFaoYZTJfRDH9hDuVHVBgZkR1flChQcp5jR5STw0K2M=;
	b=RKNYTOPII31SLlFemAcWqWE/TeS/HQJl7crveXc7GdzZz5I+TjbXRbbkZaQSvN3TmVtVYT
	nSSDvsZk7jNyt6B/E4YmD4cYyLjd5RE2oOf/Hiy1FZ2NcIRHyitOaBZNUaYo6dvHseOLCi
	TzRgynUCXY7wguiC8GKfv0LXaYiHBGc=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Tejun Heo <tj@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Paul Moore <paul@paul-moore.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>
Cc: David Howells <dhowells@redhat.com>,
	Simona Vetter <simona.vetter@ffwll.ch>,
	Randy Dunlap <rdunlap@infradead.org>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Philipp Stanner <phasta@kernel.org>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-ntfs-dev@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	audit@vger.kernel.org,
	bpf@vger.kernel.org,
	netdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	live-patching@vger.kernel.org,
	linux-modules@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	sched-ext@lists.linux.dev,
	linux-mm@kvack.org,
	virtualization@lists.linux.dev,
	damon@lists.linux.dev,
	llvm@lists.linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v3 2/7] llist: Add mutable iterator variants
Date: Mon, 22 Jun 2026 12:05:32 +0800
Message-ID: <20260622040533.29824-3-kaitao.cheng@linux.dev>
In-Reply-To: <20260622040533.29824-1-kaitao.cheng@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 77F15C0004
X-Rspam-User: 
X-Stat-Signature: jwztmsmbkd3xmo136s6bwjqjow9qyidx
X-HE-Tag: 1782101226-53345
X-HE-Meta: U2FsdGVkX1/L5juDLKUrE/rjWPPxsIIwilY2oxMRrGDhUkMJ+q//nLjD1IaNKfh6uQU9KpSB6DEKSxAm+0izRddbheuwSyyVc8RvWNSvVaPVWVzxJ+ZbHhkdGVsBiiU8tssMMdwyHxeQQ6Qo7XvxmSSWxaAUkOwinBB/p0+MCJx2hfvY6LgQKIUQHphGNqGAhlaeW3+fZN3FFbNt9Eqfts1ulTTpkGzoIyCuotNxkFrXPEcgrpnUPFKL3Fz4vF2brMgFFEtpwlkw3pSW5B7l5g+bzsAtZFGkhjZT2EuyqWKLW6N5izyUr7i8gEfWRLHqpDbC39GSi+SloxTbC1vWRQVBpUazFbzMtyUZHGxvpdzOOSNyVmnscgwwDsm7ZNL96URuudYY1mVI7hoM9K5x5ftGArE6uHUaR52DBBK0yNBkfU6JM0BmCpdj/G042fls9FRcrXZyNQo46yvKf9wBnC1KFS+61S/TYjdv1IMXYAuITXW0YD54YxICXZTEPL9VdYH8qioWyFYN3EIAH4fU2+Ra4bIl8StqCe2UwtDn9W6AvAlGp67rMHN2A2ANgc2pR7vHw2NA3xNbMiMJuYLj0JXs2kQqWwV/S7kYD5xEDlNn0nSjaRejGNabBdvVN5kiX+YFNsJbaAmtc9OX6OyYamJIbHT/+tzsIm87Oi18S6kEturcQ84t04tj2WOTaAxsVPMeA3F7t9Fkl0f7sYAnrsm7oSLdI591f/pEziyegB8LvZVj5PcM97Ne9q1arJ/ljN4BOhcRu5qBFk5FxGhn+lt5Ry9qXxNFQRpCy1iF46qpcH4jCo1a36uW1Ttk+R5diOgByI+1l664ma9euddgT0QMCL0QGcpcInwHWSHLs+AxyoO463Zn4n36OL/+rwiVcrl8r669sTPJarnn/6n+FDIKQQqVZndNRWpyA75/NIy/uGkfVqklravuV3jw2sU+RXQrfupJl0G3RGRoW4H
 rYzdwyWZ
 BdCQJOkYS1cBXSGOKOUIQMRXzwEsjQqCyBtevYUbItsnY67Fv3pb1Ehb+jn2tktnGweeNvyCn1uJpXbLeuhD7WvMIBsP0tURbLnV0FhUsli4MZFEGz2Uy7f6kDWQrwiF6sZk4Szh5P8CDA/LBzgK7ATdNjt5UX8vTK7tt3FDR5eTeWZUKU8MoGEmacgYRtAUso5iXvdhyH3GrD4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

llist_for_each_safe() and llist_for_each_entry_safe() require callers to
provide a temporary cursor even when the cursor is only needed by the
iterator itself.  This makes call sites noisier than necessary for the
common case where the loop body may remove the current entry but does
not otherwise inspect the saved next pointer.

Add llist_for_each_mutable() and llist_for_each_entry_mutable() variants
that support both forms.  Callers may omit the temporary cursor and let
the helper create an internal unique cursor, or keep passing an explicit
cursor when the loop needs to inspect or reset it.

Keep the existing safe helpers as compatibility wrappers so current users
continue to build unchanged while new code can use the shorter mutable
form.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/llist.h | 81 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 65 insertions(+), 16 deletions(-)

diff --git a/include/linux/llist.h b/include/linux/llist.h
index 8846b7709669..1c6f12411d5e 100644
--- a/include/linux/llist.h
+++ b/include/linux/llist.h
@@ -49,6 +49,7 @@
  */
 
 #include <linux/atomic.h>
+#include <linux/args.h>
 #include <linux/container_of.h>
 #include <linux/stddef.h>
 #include <linux/types.h>
@@ -143,12 +144,33 @@ static inline bool llist_on_list(const struct llist_node *node)
 #define llist_for_each(pos, node)			\
 	for ((pos) = (node); pos; (pos) = (pos)->next)
 
+/*
+ * llist_for_each_safe is an old interface, use llist_for_each_mutable instead.
+ */
+#define llist_for_each_safe(pos, n, node)			\
+	for ((pos) = (node); (pos) && ((n) = (pos)->next, true); (pos) = (n))
+
+#define __llist_for_each_mutable_internal(pos, tmp, node)		\
+	for (typeof(pos) tmp = ((pos) = (node)) ? (pos)->next : NULL;	\
+	     (pos);							\
+	     (pos) = tmp, tmp = (pos) ? (pos)->next : NULL)
+
+#define __llist_for_each_mutable1(pos, node)				\
+	__llist_for_each_mutable_internal(pos, __UNIQUE_ID(next), node)
+
+#define __llist_for_each_mutable2(pos, next, node)			\
+	llist_for_each_safe(pos, next, node)
+
 /**
- * llist_for_each_safe - iterate over some deleted entries of a lock-less list
- *			 safe against removal of list entry
+ * llist_for_each_mutable - iterate over some deleted entries of a lock-less list
+ *			    safe against removal of list entry
  * @pos:	the &struct llist_node to use as a loop cursor
- * @n:		another &struct llist_node to use as temporary storage
- * @node:	the first entry of deleted list entries
+ * @...:	either (node) or (next, node)
+ *
+ * next:	another &struct llist_node to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * node:	the first entry of deleted list entries
  *
  * In general, some entries of the lock-less list can be traversed
  * safely only after being deleted from list, so start with an entry
@@ -159,8 +181,9 @@ static inline bool llist_on_list(const struct llist_node *node)
  * you want to traverse from the oldest to the newest, you must
  * reverse the order by yourself before traversing.
  */
-#define llist_for_each_safe(pos, n, node)			\
-	for ((pos) = (node); (pos) && ((n) = (pos)->next, true); (pos) = (n))
+#define llist_for_each_mutable(pos, ...)				\
+	CONCATENATE(__llist_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
+		(pos, __VA_ARGS__)
 
 /**
  * llist_for_each_entry - iterate over some deleted entries of lock-less list of given type
@@ -182,13 +205,41 @@ static inline bool llist_on_list(const struct llist_node *node)
 	     member_address_is_nonnull(pos, member);			\
 	     (pos) = llist_entry((pos)->member.next, typeof(*(pos)), member))
 
+/*
+ * llist_for_each_entry_safe is an old interface, use llist_for_each_entry_mutable instead.
+ */
+#define llist_for_each_entry_safe(pos, n, node, member)			       \
+	for (pos = llist_entry((node), typeof(*pos), member);		       \
+	     member_address_is_nonnull(pos, member) &&			       \
+	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
+	     pos = n)
+
+#define __llist_for_each_entry_mutable_internal(pos, tmp, node, member)	\
+	for (typeof(pos) tmp = ((pos) = llist_entry((node), typeof(*pos), member), \
+		member_address_is_nonnull(pos, member) ?			\
+		llist_entry((pos)->member.next, typeof(*pos), member) : NULL);	\
+	     member_address_is_nonnull(pos, member);				\
+	     (pos) = tmp, tmp = member_address_is_nonnull(pos, member) ?	\
+		llist_entry((pos)->member.next, typeof(*pos), member) : NULL)
+
+#define __llist_for_each_entry_mutable2(pos, node, member)			\
+	__llist_for_each_entry_mutable_internal(pos, __UNIQUE_ID(next), node, member)
+
+#define __llist_for_each_entry_mutable3(pos, next, node, member)		\
+	llist_for_each_entry_safe(pos, next, node, member)
+
 /**
- * llist_for_each_entry_safe - iterate over some deleted entries of lock-less list of given type
- *			       safe against removal of list entry
+ * llist_for_each_entry_mutable - iterate over some deleted entries of
+ *				  lock-less list of given type safe against
+ *				  removal of list entry
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @node:	the first entry of deleted list entries.
- * @member:	the name of the llist_node with the struct.
+ * @...:	either (node, member) or (next, node, member)
+ *
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * node:	the first entry of deleted list entries.
+ * member:	the name of the llist_node with the struct.
  *
  * In general, some entries of the lock-less list can be traversed
  * safely only after being removed from list, so start with an entry
@@ -199,11 +250,9 @@ static inline bool llist_on_list(const struct llist_node *node)
  * you want to traverse from the oldest to the newest, you must
  * reverse the order by yourself before traversing.
  */
-#define llist_for_each_entry_safe(pos, n, node, member)			       \
-	for (pos = llist_entry((node), typeof(*pos), member);		       \
-	     member_address_is_nonnull(pos, member) &&			       \
-	        (n = llist_entry(pos->member.next, typeof(*n), member), true); \
-	     pos = n)
+#define llist_for_each_entry_mutable(pos, ...)				\
+	CONCATENATE(__llist_for_each_entry_mutable,			\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
 
 /**
  * llist_empty - tests whether a lock-less list is empty
-- 
2.43.0


