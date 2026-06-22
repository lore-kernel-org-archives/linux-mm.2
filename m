Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2215FCDB470
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 04:06:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6FDB6B008A; Mon, 22 Jun 2026 00:06:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47416B008C; Mon, 22 Jun 2026 00:06:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90EF76B0092; Mon, 22 Jun 2026 00:06:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C1206B008A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 00:06:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8657B140582
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:06:54 +0000 (UTC)
X-FDA: 84906212748.09.4A0F4A8
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf03.hostedemail.com (Postfix) with ESMTP id 557B020002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 04:06:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U+k2BeK5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782101212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ifihl8QoiBoywP+aXJrYFC3QhTRNuzfTpuEgOqKFH8M=;
	b=G+3HZpjlED5OrZ0tPrdeNmbJooE+xoT/+pEBk4SJSBfnA2jVndPqgqPK+Buxx01/WaMsfi
	P084jG9AQzjd/kkDGUtcHUiP4JQ+ji0b9e/uosxvioUMbg1tJzdgyGESDd+dSiIqbB6SQP
	PG844Zp2WCQqD8Y4z2t18+LB13uW+KQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782101212;
	b=vHDLEa2D1uCKMJ5EkGSwkmwPxyhJjUUK8epdaWotQymONoVlwIbOWzYiA9DTdC9r3uiGOe
	GEQG+eC9XrIP6hFSU+4TFg3jhnSTRBY+ZLDuN6cJXpDdJTWH4eNFQWboeimnwr39Z84W+Z
	+TS+QPx+k1ugBOkGC/p9MjN28eSWkTo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=U+k2BeK5;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782101210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ifihl8QoiBoywP+aXJrYFC3QhTRNuzfTpuEgOqKFH8M=;
	b=U+k2BeK53z2j05swHRT0lacq0ZTVsZXyAyHCLZNDF76tNliwPGXmpiDoHZSwTAZAVNO1bW
	D0heyFxlfRNySZ2eTObHrN21BX8AQCwBl+WBAUkcc4UCehXoqyuJU7Kdwf8tJzpvbifLz7
	HteD2STjYo7LJnqoMTdXNA1BRgkU+dM=
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
Subject: [PATCH v3 1/7] list: Add mutable iterator variants
Date: Mon, 22 Jun 2026 12:05:31 +0800
Message-ID: <20260622040533.29824-2-kaitao.cheng@linux.dev>
In-Reply-To: <20260622040533.29824-1-kaitao.cheng@linux.dev>
References: <20260622040533.29824-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 557B020002
X-Rspam-User: 
X-Stat-Signature: pbz31n87a8uidaiixmk45uzgjdsa4h7i
X-HE-Tag: 1782101212-29735
X-HE-Meta: U2FsdGVkX1/Wv8d9UQMLNu357vO4AfjQfq3M1uzAGAUBZND5+erjn9hbzF2t7JbhqNFl5upl/ojPRUtfHyuEhJM9OOmVXkdPmjZg6Ww5EhRmLanpccaojxJ3l2zjtw3voF3ZKhDDzxxub/ovLTjX0cUC8tH8y99gHQgmqKz3CtoQfWEKTcazZQf2pMAbHjzbdGsaO4fIz9gDkYbetZFB9/OUQu2YjaURNo35fde48okxQGDYHD4YoYIcnd+DrY/paU1KG/dCwpdnAdixHqn5Dyjifs1Q/5u+iqSI8Z2rjJmXl2O/6Zb3RSmSi0QMt9DNtAyLQxRm01zb8WU2JpIgV9MX5K+4Eas6PKIT2T1SpHmLpWQQUHb6843pgF/VqUGaBxMcK37p02uqWQ6wQJdkCZO0+RwtyraI5OSCk+81P6B+myshoWnSqhKwFDDt+cvBoOq6Pabu/lexA9LM/+IKgP82hypZQJtoe4btmGrD8J7O1PjeTlfTbQljwQh3WRbA1ZIlvC8Eyin1349/BKPWyY7o2NSjxfOrEn/LZM1Xa/vK7eGL4NLaCb43sRhhsyvCJEQmp2JtRa6hjlamNCCuSGk+BGXHUjPCaZsnRA0+BGIote/p9T//ldk7nRQSesnGHrPtFl2FYu/RXN/HGlZLc3n2OfF4oBM8Wz5tq+/j61XFwKf7h7OFCLQVWPISh1YCfgVrh8IVIVvNV4Tr7SnjToKIyO+R0JHIQ0Agbydk20+KjzlVXOhZumX879gQf0o+O/+YXZ0N8Y1u+0+lEcuTN8uoTzZhvztz5c7bS0+e8YEwJvttUdPPq7hC4U4bGLPJqECbOnzxqDenTZka9tLxCp+qbYpJ/tlpgMtBU988hvxyQTpEH9VUMIrCiwQ88UYv7OK5XD51NBK3fBENtUgkoeyOqrCF/o/y4TfayXTGTgMb46ZAUThGbN/mHOSUFyV5XKPaBhJHkWoht4xrO3R
 OCmFIofa
 mdi7PDT2zzuBL5W2j7tX0xDvsLHSjMChzFYASuacY6j04tD6i39uvCb5Yn+Qe1ew5bcbQu/Or/JGWUI4ZXLzo9WAZiUym8MdZF3h35oCETBzeVOHcUTDsKRZ7c9dDnEFghGtdT+7PtIti3shv33aIQwRyaWr1K/mJ1svsbbZBsWpwIMNGSLXYzy0754cl87qJaiouWUGSU+M5hic=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

The list_for_each*_safe() helpers are used when the loop body may
remove the current entry.  Their API exposes the temporary cursor at
every call site, even though most users only need it for the iterator
implementation and never reference it in the loop body.

Add *_mutable() variants for list and hlist iteration.  The new helpers
support both forms: callers may keep passing an explicit temporary cursor
when they need to inspect or reset it, or omit it and let the helper use
a unique internal cursor.

This makes call sites that only mutate the list through the current entry
less noisy, while keeping the existing *_safe() helpers available for
compatibility.

Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 include/linux/list.h | 269 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 231 insertions(+), 38 deletions(-)

diff --git a/include/linux/list.h b/include/linux/list.h
index 09d979976b3b..1081def7cea9 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -7,6 +7,7 @@
 #include <linux/stddef.h>
 #include <linux/poison.h>
 #include <linux/const.h>
+#include <linux/args.h>
 
 #include <asm/barrier.h>
 
@@ -763,28 +764,72 @@ static inline void list_splice_tail_init(struct list_head *list,
 #define list_for_each_prev(pos, head) \
 	for (pos = (head)->prev; !list_is_head(pos, (head)); pos = pos->prev)
 
-/**
- * list_for_each_safe - iterate over a list safe against removal of list entry
- * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
+/*
+ * list_for_each_safe is an old interface, use list_for_each_mutable instead.
  */
 #define list_for_each_safe(pos, n, head) \
 	for (pos = (head)->next, n = pos->next; \
 	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->next)
 
+#define __list_for_each_mutable_internal(pos, tmp, head)		\
+	for (typeof(pos) tmp = (pos = (head)->next)->next;		\
+	     !list_is_head(pos, (head));				\
+	     pos = tmp, tmp = pos->next)
+
+#define __list_for_each_mutable1(pos, head)				\
+	__list_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
+
+#define __list_for_each_mutable2(pos, next, head)			\
+	list_for_each_safe(pos, next, head)
+
 /**
- * list_for_each_prev_safe - iterate over a list backwards safe against removal of list entry
+ * list_for_each_mutable - iterate over a list safe against entry removal
  * @pos:	the &struct list_head to use as a loop cursor.
- * @n:		another &struct list_head to use as temporary storage
- * @head:	the head for your list.
+ * @...:	either (head) or (next, head)
+ *
+ * next:	another &struct list_head to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * head:	the head for your list.
+ */
+#define list_for_each_mutable(pos, ...)					\
+	CONCATENATE(__list_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
+		(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_prev_safe is an old interface, use list_for_each_prev_mutable instead.
  */
 #define list_for_each_prev_safe(pos, n, head) \
 	for (pos = (head)->prev, n = pos->prev; \
 	     !list_is_head(pos, (head)); \
 	     pos = n, n = pos->prev)
 
+#define __list_for_each_prev_mutable_internal(pos, tmp, head)		\
+	for (typeof(pos) tmp = (pos = (head)->prev)->prev;		\
+	     !list_is_head(pos, (head));				\
+	     pos = tmp, tmp = pos->prev)
+
+#define __list_for_each_prev_mutable1(pos, head)			\
+	__list_for_each_prev_mutable_internal(pos, __UNIQUE_ID(prev), head)
+
+#define __list_for_each_prev_mutable2(pos, prev, head)			\
+	list_for_each_prev_safe(pos, prev, head)
+
+/**
+ * list_for_each_prev_mutable - iterate over a list backwards safe against entry removal
+ * @pos:	the &struct list_head to use as a loop cursor.
+ * @...:	either (head) or (prev, head)
+ *
+ * prev:	another &struct list_head to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * head:	the head for your list.
+ */
+#define list_for_each_prev_mutable(pos, ...)				\
+	CONCATENATE(__list_for_each_prev_mutable, COUNT_ARGS(__VA_ARGS__)) \
+		(pos, __VA_ARGS__)
+
 /**
  * list_count_nodes - count nodes in the list
  * @head:	the head for your list.
@@ -895,12 +940,8 @@ static inline size_t list_count_nodes(struct list_head *head)
 	for (; !list_entry_is_head(pos, head, member);			\
 	     pos = list_prev_entry(pos, member))
 
-/**
- * list_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+/*
+ * list_for_each_entry_safe is an old interface, use list_for_each_entry_mutable instead.
  */
 #define list_for_each_entry_safe(pos, n, head, member)			\
 	for (pos = list_first_entry(head, typeof(*pos), member),	\
@@ -908,15 +949,36 @@ static inline size_t list_count_nodes(struct list_head *head)
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_next_entry(n, member))
 
+#define __list_for_each_entry_mutable_internal(pos, tmp, head, member)	\
+	for (typeof(pos) tmp = list_next_entry(pos =			\
+		list_first_entry(head, typeof(*pos), member), member);	\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_next_entry(tmp, member))
+
+#define __list_for_each_entry_mutable2(pos, head, member)		\
+	__list_for_each_entry_mutable_internal(pos, __UNIQUE_ID(next), head, member)
+
+#define __list_for_each_entry_mutable3(pos, next, head, member)		\
+	list_for_each_entry_safe(pos, next, head, member)
+
 /**
- * list_for_each_entry_safe_continue - continue list iteration safe against removal
+ * list_for_each_entry_mutable - iterate over a list safe against entry removal
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+ * @...:	either (head, member) or (next, head, member)
  *
- * Iterate over list of given type, continuing after current point,
- * safe against removal of list entry.
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ */
+#define list_for_each_entry_mutable(pos, ...)				\
+	CONCATENATE(__list_for_each_entry_mutable, COUNT_ARGS(__VA_ARGS__)) \
+		(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_entry_safe_continue is an old interface,
+ * use list_for_each_entry_mutable_continue instead.
  */
 #define list_for_each_entry_safe_continue(pos, n, head, member) 		\
 	for (pos = list_next_entry(pos, member), 				\
@@ -924,30 +986,79 @@ static inline size_t list_count_nodes(struct list_head *head)
 	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
+#define __list_for_each_entry_mutable_continue_internal(pos, tmp, head, member) \
+	for (typeof(pos) tmp = list_next_entry(pos =			\
+		list_next_entry(pos, member), member);			\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_next_entry(tmp, member))
+
+#define __list_for_each_entry_mutable_continue2(pos, head, member)	\
+	__list_for_each_entry_mutable_continue_internal(pos,		\
+		__UNIQUE_ID(next), head, member)
+
+#define __list_for_each_entry_mutable_continue3(pos, next, head, member) \
+	list_for_each_entry_safe_continue(pos, next, head, member)
+
 /**
- * list_for_each_entry_safe_from - iterate over list from current point safe against removal
+ * list_for_each_entry_mutable_continue - continue list iteration safe against removal
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+ * @...:	either (head, member) or (next, head, member)
  *
- * Iterate over list of given type from current point, safe against
- * removal of list entry.
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type, continuing after current point,
+ * safe against removal of list entry.
+ */
+#define list_for_each_entry_mutable_continue(pos, ...)			\
+	CONCATENATE(__list_for_each_entry_mutable_continue,		\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_entry_safe_from is an old interface,
+ * use list_for_each_entry_mutable_from instead.
  */
 #define list_for_each_entry_safe_from(pos, n, head, member) 			\
 	for (n = list_next_entry(pos, member);					\
 	     !list_entry_is_head(pos, head, member);				\
 	     pos = n, n = list_next_entry(n, member))
 
+#define __list_for_each_entry_mutable_from_internal(pos, tmp, head, member) \
+	for (typeof(pos) tmp = list_next_entry(pos, member);		\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_next_entry(tmp, member))
+
+#define __list_for_each_entry_mutable_from2(pos, head, member)		\
+	__list_for_each_entry_mutable_from_internal(pos,		\
+		__UNIQUE_ID(next), head, member)
+
+#define __list_for_each_entry_mutable_from3(pos, next, head, member)	\
+	list_for_each_entry_safe_from(pos, next, head, member)
+
 /**
- * list_for_each_entry_safe_reverse - iterate backwards over list safe against removal
+ * list_for_each_entry_mutable_from - iterate over list from current point safe against removal
  * @pos:	the type * to use as a loop cursor.
- * @n:		another type * to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the list_head within the struct.
+ * @...:	either (head, member) or (next, head, member)
  *
- * Iterate backwards over list of given type, safe against removal
- * of list entry.
+ * next:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ *
+ * Iterate over list of given type from current point, safe against
+ * removal of list entry.
+ */
+#define list_for_each_entry_mutable_from(pos, ...)			\
+	CONCATENATE(__list_for_each_entry_mutable_from,			\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
+/*
+ * list_for_each_entry_safe_reverse is an old interface,
+ * use list_for_each_entry_mutable_reverse instead.
  */
 #define list_for_each_entry_safe_reverse(pos, n, head, member)		\
 	for (pos = list_last_entry(head, typeof(*pos), member),		\
@@ -955,6 +1066,37 @@ static inline size_t list_count_nodes(struct list_head *head)
 	     !list_entry_is_head(pos, head, member); 			\
 	     pos = n, n = list_prev_entry(n, member))
 
+#define __list_for_each_entry_mutable_reverse_internal(pos, tmp, head, member) \
+	for (typeof(pos) tmp = list_prev_entry(pos =			\
+		list_last_entry(head, typeof(*pos), member), member);	\
+	     !list_entry_is_head(pos, head, member);			\
+	     pos = tmp, tmp = list_prev_entry(tmp, member))
+
+#define __list_for_each_entry_mutable_reverse2(pos, head, member)	\
+	__list_for_each_entry_mutable_reverse_internal(pos,		\
+		__UNIQUE_ID(prev), head, member)
+
+#define __list_for_each_entry_mutable_reverse3(pos, prev, head, member)	\
+	list_for_each_entry_safe_reverse(pos, prev, head, member)
+
+/**
+ * list_for_each_entry_mutable_reverse - iterate backwards over list safe against removal
+ * @pos:	the type * to use as a loop cursor.
+ * @...:	either (head, member) or (prev, head, member)
+ *
+ * prev:	another type * to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your list.
+ * member:	the name of the list_head within the struct.
+ *
+ * Iterate backwards over list of given type, safe against removal
+ * of list entry.
+ */
+#define list_for_each_entry_mutable_reverse(pos, ...)			\
+	CONCATENATE(__list_for_each_entry_mutable_reverse,		\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
 /**
  * list_safe_reset_next - reset a stale list_for_each_entry_safe loop
  * @pos:	the loop cursor used in the list_for_each_entry_safe loop
@@ -1189,6 +1331,31 @@ static inline void hlist_splice_init(struct hlist_head *from,
 	for (pos = (head)->first; pos && ({ n = pos->next; 1; }); \
 	     pos = n)
 
+#define __hlist_for_each_mutable_internal(pos, tmp, head)		\
+	for (typeof(pos) tmp = (pos = (head)->first) ? pos->next : NULL; \
+	     pos;							\
+	     pos = tmp, tmp = pos ? pos->next : NULL)
+
+#define __hlist_for_each_mutable1(pos, head)				\
+	__hlist_for_each_mutable_internal(pos, __UNIQUE_ID(next), head)
+
+#define __hlist_for_each_mutable2(pos, next, head)			\
+	hlist_for_each_safe(pos, next, head)
+
+/**
+ * hlist_for_each_mutable - iterate over a hlist safe against entry removal
+ * @pos:	the &struct hlist_node to use as a loop cursor.
+ * @...:	either (head) or (next, head)
+ *
+ * next:	another &struct hlist_node to use as optional temporary storage.
+ *		The temporary cursor is internal unless explicitly supplied by
+ *		the caller.
+ * head:	the head for your hlist.
+ */
+#define hlist_for_each_mutable(pos, ...)				\
+	CONCATENATE(__hlist_for_each_mutable, COUNT_ARGS(__VA_ARGS__))	\
+		(pos, __VA_ARGS__)
+
 #define hlist_entry_safe(ptr, type, member) \
 	({ typeof(ptr) ____ptr = (ptr); \
 	   ____ptr ? hlist_entry(____ptr, type, member) : NULL; \
@@ -1224,18 +1391,44 @@ static inline void hlist_splice_init(struct hlist_head *from,
 	for (; pos;							\
 	     pos = hlist_entry_safe((pos)->member.next, typeof(*(pos)), member))
 
-/**
- * hlist_for_each_entry_safe - iterate over list of given type safe against removal of list entry
- * @pos:	the type * to use as a loop cursor.
- * @n:		a &struct hlist_node to use as temporary storage
- * @head:	the head for your list.
- * @member:	the name of the hlist_node within the struct.
+/*
+ * hlist_for_each_entry_safe is an old interface, use hlist_for_each_entry_mutable instead.
  */
 #define hlist_for_each_entry_safe(pos, n, head, member) 		\
 	for (pos = hlist_entry_safe((head)->first, typeof(*pos), member);\
 	     pos && ({ n = pos->member.next; 1; });			\
 	     pos = hlist_entry_safe(n, typeof(*pos), member))
 
+#define __hlist_for_each_entry_mutable_internal(pos, tmp, head, member)	\
+	for (struct hlist_node *tmp = (pos =				\
+		hlist_entry_safe((head)->first, typeof(*pos), member)) ? \
+		pos->member.next : NULL;				\
+	     pos;							\
+	     pos = hlist_entry_safe((tmp), typeof(*pos), member),	\
+		tmp = pos ? pos->member.next : NULL)
+
+#define __hlist_for_each_entry_mutable2(pos, head, member)		\
+	__hlist_for_each_entry_mutable_internal(pos,			\
+		__UNIQUE_ID(next), head, member)
+
+#define __hlist_for_each_entry_mutable3(pos, next, head, member)	\
+	hlist_for_each_entry_safe(pos, next, head, member)
+
+/**
+ * hlist_for_each_entry_mutable - iterate over hlist safe against entry removal
+ * @pos:	the type * to use as a loop cursor.
+ * @...:	either (head, member) or (next, head, member)
+ *
+ * next:	a &struct hlist_node to use as optional temporary storage. The
+ *		temporary cursor is internal unless explicitly supplied by the
+ *		caller.
+ * head:	the head for your hlist.
+ * member:	the name of the hlist_node within the struct.
+ */
+#define hlist_for_each_entry_mutable(pos, ...)				\
+	CONCATENATE(__hlist_for_each_entry_mutable,			\
+		COUNT_ARGS(__VA_ARGS__))(pos, __VA_ARGS__)
+
 /**
  * hlist_count_nodes - count nodes in the hlist
  * @head:	the head for your hlist.
-- 
2.43.0


