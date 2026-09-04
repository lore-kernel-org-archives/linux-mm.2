Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAC74C79F82
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:08:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B17076B009F; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9F606B00A1; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918F96B00A4; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE9C66B009F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:41 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 784841C00B7
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
X-FDA: 85176560322.16.4FFFB0B
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf04.hostedemail.com (Postfix) with ESMTP id E9BB140004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=iAI7MDjK;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tup5QvhrUxBuHbOp/mUBjVWrl1apXEgoVpX9q/lsPY8=;
	b=b4YjDb7JHbVytUiePMLEZA3g32oR1UmL3Bqs3bWfOzCmnUNRJWUqhamDzbO/YgnnotuREh
	U2mb4pGr+xhiE7g3/u0+o9uW/ohSwA+8RHUMyM6TL3D/BdStPMhy/I9qqb0b8BPlZVB+2U
	9VezAqG/h4H89jbAkcH/aLvdYnEg0bU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538060;
	b=fDQQVnXHMeL62VLSUE2X6vbHPVXlJlrG+ukWhQ1FkFFbg5GAnwwOiOF/25bJB1gEzWPNNz
	Uj8+5UWH8d9EWeeHeYSiI5IECKq/F9ORQiMbe3nNdkZHX8VEOaIXuFXq+zx+grp6lHJkqI
	ekrhBZRBnckkPLUKnn4fAQzFy1+UDik=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=iAI7MDjK;
	spf=pass (imf04.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538058;
	bh=Tup5QvhrUxBuHbOp/mUBjVWrl1apXEgoVpX9q/lsPY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iAI7MDjKfQGX3aAx+Rv3MxGlwtRFZ3Q7uJJnX/myA4eyvbhkxvesBifrbSflySDKc
	 qtfTvjE/PtSh/PiLzn6BXZmhyUq08ouLgs4IhSv8U5jkZp5uIbl/bYTIyuGJcBZydY
	 wWIRzX9MxfPtbmjfmk7o3nanb2aBY3kQ+Q2TMgorh4b8Ad+WaZ/XnQ5kWqS072icfc
	 AQCO8nUlCP94jI4O3VTtUWAJadMaOi7OHemMo8/aObgKGDKL2ontawa/yYgUxFZGQd
	 F9xqcYpzfa4XaHL0p9d11yI26EWY8CEGEbfSxYdGbBA+2kRfm9jO6twR58jzAmpgYs
	 L5SAfK70Ou0Ng==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zf19WkzWWX;
	Fri, 04 Sep 2026 12:07:38 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	linux-mm@kvack.org
Subject: [PATCH v22 06/10] lib: inline percpu_counter_tree_items_size with boot-safety sentinel
Date: Fri,  4 Sep 2026 12:07:18 -0400
Message-ID: <20260904160734.23445-7-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: p4jqhsgb3uun6hjgipsz5xytn5frsh1j
X-Rspamd-Queue-Id: E9BB140004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788538059-53821
X-HE-Meta: U2FsdGVkX1/WooSAtHKr+fgRkMB4+acjzuX6WNWHioaD+60Z/H2mq2h5wfSUq6qCIUvoVjpLRnpClcUp2PenVn7V2akyUdWgU6rv+VjNK9tl54MECUbTYKYkEFwJDaNCGOY3kFbgW3sXfERbSQKXPgt/AsPYfvQ3PdWoScAy9oZd2GjtxcbFeHR2hzOIiZZH7Vzjf4PWNh2/+Qnxi29KJe7ZuF6j4nZlLV4XyhqzW6E4g72006M6XJT6j8OEFhWOuAlwqHw0U0GeGvBQeGP8WV1ETyahaP2g2T7sZ8r7jd6ZIdK1pEfSj0A/7jgUZ5LvahSZlzngcts1e0L/VRC1a80X7BuyPHYDVnK8L1pPPjPUrEFslU6EfyFlwIZ/XNdbBq0HF3zi1An/s6OCn/JBxiStDWujNcu64YJM2jMkmrlQ2XmQ4pfcZseVukaz8+R0jXs5ll+S/nMzB9owZmz0X7ivLwGTS7gnJr0L+m0zVeIwrBvlucXuIhiFt+6Mux40ZlSBY756VA/ikgI1/5Au1cPt72hQPyweh1va2MQrurLytbPcX782LI+qUJHBTIxmhgEbULyJpU6q1et4ns+OzGEP1bNcx8fqmfErO2wp68x+R9KxOkj//gWT7/PrmxJD3/3e5uG5CZbD+cgbctLWoZCWcgVtz7y4pRheBhtYtFnT0ZmdM7DgTKLnF3xCBtzTKIjAuVNw1EqQ2tDhbb/gOXmbDWbdtC7vs5bqRz8OFO9TBIRqAWW9xOoFPNhndFTnlnPyAJ+pkrvQBZhKsULzSWB1XB/szNwez5ot8ujR0lVKW9XfLrAYZl2lrwzAGBSaGfIAbNm/24y5/ETfT79+4GwO5reNkAsuEjSVzpzaw57zusM8r6zHZMEGkojsK4sZlN4bIZu8ajgMXhapkAbbHoheXmpXiWvc5DXkCYfSjs0Sb/+cVNyAvM6CuIEyiOtluN+9n0uB53IUGF4LlQb
 RuXYgkm+
 eCMCCyaX0B+bDWDgeSnRJZh2XoMmUqhfPOjo5fK0OvwTRQJ59l4Y52fqoY/2Pgau0ItVEbQo39mdwpmyRqgXJBr2oncHCcMQSmb9NfaFocIObp+D6o0McqCQtGmn2m5Zx2n80FFuWzJZBxs/r3l8ZTgks1NiqXaysoKGdXgT/a7C1FQT8f8bfVpOU+W1xCnZwJMa3/qsPP/lNGcFIuw0dfnYwdlClg7BjI3uTMJ0+ilAvMnngPrRxQgeEPU8UeNpIDc7APG6eem/qD6MoJ+Q13HwvgfXuie+z17JhRxsfBPLOo4kpW/hk7XcoqTB87nKucQZ0UwK2YxqpqjxX53SJjncuyDfbQp69HbIoP8jtGaGQsEa4WgEXn6ycvySWrEv2Zka6+zT1k20SuSckQlrc9+tOo7gSOmS3KMlUe5zbFDytaJAo7IDltwJV+DZGcUV96r4bzLkjuFqIm2Uku/JNGWw/+BlCck6vxvRcDgqEYZGc+GhwiJo6st5o1TeSvBLtwg32Oyi/UHy09Gm+dtu96udMX9gi+dLeHGSvnhhqleL5dCH2orasGdgb3jiNwgvi4mZKHMHcYXSb2C0i0hPjodZiC9aC2ZHdc6dPIRdaUxrIHCeWH750HoZ2DMgVNfs48xKjQe8SsezFYMrMCktapIvZy/2ajIfGnbcNFh+79InIyc4IOxLjvsjYNeTAAd+L9eiAm1JvV+OJwMEZfD6Z4TQOK4BPUfFwJ+420HaWUpJFUh25+W8zMrDb+9qtwtqY6lFVqryOZZ2cRI+/acJkf0dZ647n86DbULIFUGDdHe/oks4GuG7HD72PNrY32V4UN7aUiyg20uRtlHnTiPHAc1YiEx9Bw8eTqRzBwGos8/9ZTxEsWf6ncPIyeiptZER1hF5Dw81O5aiI8vbZZ9llwcLbBkCJgmji7E9xsMaB2CTDcozGAQcAu1/M9cJxab9oOksvmuwKP/TH1HiqhOwYRPhB7MVf
 bBBDiOm+
 4OlTqyGZpx99W34W83w9otAhnNAJXIb4pk05OLmShgkthc15tFK708hwQGuL58LZwgcKqghTxaiDb558doF/oa7fTeSm4weIm09bSf1EIkerIGriTDU2aF+sv0OH/+3NdgS16vU/eRtQxfZ/Cm2ERg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace the out-of-line percpu_counter_tree_items_size() function with a
static inline that loads the __ro_after_init variable
__percpu_counter_tree_items_size directly. This eliminates a function
call on paths that compute mm_struct flexible array layout offsets.

Initialize the variable to SIZE_MAX as a sentinel value, and add a
WARN_ON_ONCE check in the inline accessor to catch any accidental use
before percpu_counter_tree_subsystem_init() sets the real value based on
nr_cpu_ids. An early misuse would produce an absurd offset that triggers
the warning with a stack trace pointing at the offending caller, rather
than silently computing wrong memory offsets.

percpu_counter_tree_subsystem_init() sets the variable to the runtime
value immediately after deriving counter_config from nr_cpu_ids,
before calculate_accuracy_topology(). After boot, __ro_after_init moves
the variable into read-only memory.

On !CONFIG_SMP, the existing inline returning 0 is unchanged and
requires no sentinel.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 include/linux/percpu_counter_tree.h | 19 ++++++++++++++++++-
 lib/percpu_counter_tree.c           | 24 ++++++++----------------
 2 files changed, 26 insertions(+), 17 deletions(-)

diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 3e8a820e2d1d..4095acdc879b 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -101,7 +101,24 @@ struct percpu_counter_tree {
 	} approx_accuracy_range;
 };
 
-size_t percpu_counter_tree_items_size(void);
+extern size_t __percpu_counter_tree_items_size __ro_after_init;
+
+/*
+ * percpu_counter_tree_items_size - Query the size required for counter tree items.
+ *
+ * Query the size of the memory area required to hold the counter tree
+ * items. This depends on the hardware topology and is invariant after
+ * boot.
+ *
+ * Return: Size required to hold tree items.
+ */
+static inline
+size_t percpu_counter_tree_items_size(void)
+{
+	WARN_ON_ONCE(__percpu_counter_tree_items_size == SIZE_MAX);
+	return __percpu_counter_tree_items_size;
+}
+
 int percpu_counter_tree_init_many(struct percpu_counter_tree *counters, struct percpu_counter_tree_level_item *items,
 				  unsigned int nr_counters, unsigned long batch_size, gfp_t gfp_flags);
 int percpu_counter_tree_init(struct percpu_counter_tree *counter, struct percpu_counter_tree_level_item *items,
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index 5c8fc2dcdc16..cfa5b04e05d7 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -653,22 +653,9 @@ void percpu_counter_tree_set(struct percpu_counter_tree *counter, long v)
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_set);
 
-/*
- * percpu_counter_tree_items_size - Query the size required for counter tree items.
- *
- * Query the size of the memory area required to hold the counter tree
- * items. This depends on the hardware topology and is invariant after
- * boot.
- *
- * Return: Size required to hold tree items.
- */
-size_t percpu_counter_tree_items_size(void)
-{
-	if (!nr_cpus_order)
-		return 0;
-	return counter_config->nr_items * sizeof(struct percpu_counter_tree_level_item);
-}
-EXPORT_SYMBOL_GPL(percpu_counter_tree_items_size);
+/* Initialize to SIZE_MAX to catch early boot misuses. */
+size_t __percpu_counter_tree_items_size __ro_after_init = SIZE_MAX;
+EXPORT_SYMBOL_GPL(__percpu_counter_tree_items_size);
 
 static void __init calculate_accuracy_topology(void)
 {
@@ -697,6 +684,11 @@ int __init percpu_counter_tree_subsystem_init(void)
 		return -1;
 	}
 	counter_config = &per_nr_cpu_order_config[nr_cpus_order];
+	if (!nr_cpus_order)
+		__percpu_counter_tree_items_size = 0;
+	else
+		__percpu_counter_tree_items_size = counter_config->nr_items *
+			sizeof(struct percpu_counter_tree_level_item);
 	calculate_accuracy_topology();
 	return 0;
 }
-- 
2.43.0


