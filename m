Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E967C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1EC6B00A3; Fri,  4 Sep 2026 12:07:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BA866B00A4; Fri,  4 Sep 2026 12:07:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CF996B00A5; Fri,  4 Sep 2026 12:07:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B2036B00A3
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C6AA21A0140
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
X-FDA: 85176560322.23.F6855E6
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf16.hostedemail.com (Postfix) with ESMTP id 45BDE180014
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wCfgFlTr;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538060;
	b=UXSxp4kB0Id563Sg2RWRSK7UvoKqN2RLYZ4jsDcomzGuBR1DPqHKTNDRzQHJNAp5wPbPJl
	ZboFwQKAFGtYrHUJeDXe0MgFdcZXvKIIfPw1lsZVmuiZgU/0iRUzrJmCZlLOqFEYOWSEbG
	kBQWAVisWukBeepEOaqFvUrGGVJ5ekg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wCfgFlTr;
	spf=pass (imf16.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GFrBGotQmUFPk7Hx6MxhQ//71RXmwImDPFS9Iw0UAsM=;
	b=AOvk9MsUaGFZdQDKwZKYmiwKLu+6hK3FqR96V9h7glae9fsChIskTuWg9HulQslpvHMW1K
	usPCKj3TQijDonR6w/tDbZS+IKmHyXzEZnqelFgAvM3RcMB3Jz9VWofKrCZ0nkUIE7yXZz
	ATLaxjahWDPqHT8HxgyFq7pKvXl87Nk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538058;
	bh=GFrBGotQmUFPk7Hx6MxhQ//71RXmwImDPFS9Iw0UAsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wCfgFlTrbJPjdAcgG+nlLqQIYCEOi18LXYFjG4sdjtoD9r3ycBDcKFXnBwxiB6yDm
	 nRi+nE7vTEVoXinUKEwDsB9WQXjs3xyUsf6soQ27ieg8+U0j7NYvcq2aAuE6TlZMbd
	 yi73XpBkuXv1qliojg9bKREXw/3UdcB2bmNKiDZA33cQ+bFnxD4R0wzgg8Xa1n741e
	 dQ/EBC2e2YlP7Nb29YGFNQCpu1X5qbexT6KPbH5o+1OXCia+8RBvEWpJkuTE0CjtdS
	 1IomSsc/kAtjEavizxiiwtA9TJjL09xwGfhdoq5+/5LPeDj6KjQuQxyuwrkAomm0E5
	 9H0/jjaWhbosQ==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zf4svrzWWY;
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
Subject: [PATCH v22 09/10] lib/hpcc: Introduce wrapped delta helper
Date: Fri,  4 Sep 2026 12:07:21 -0400
Message-ID: <20260904160734.23445-10-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ixysrq9kgubejacyunixz1yci3f3gg5p
X-Rspamd-Queue-Id: 45BDE180014
X-Rspamd-Server: rspam06
X-HE-Tag: 1788538060-678281
X-HE-Meta: U2FsdGVkX19sz6+5tz1ywvY+sXzQ0PPTMvOvE964DZ5l9lrY9Z1c0/25eV+q/HskulXKk05lH306T3KYpjhWCjxfgV4rZedFUKSAyuL22GnF49sx/EtKlBg9gE/X8sY7AE+ITD2FvKs32Renarg/dvJbmvY7xGqpMWIvlkLTksrM5NFj2fCAgTNMG2ozeI2nANuCJVRxM8QvP7gAr5xhnCOykdIs/TC4iqTCN4D6CQTLQO8JeJAoFBvxAUWV6w4mzIo+OpMZx1/VYDUc7MPJxT0sqwXscnBolREaR072iciHp2sGXt4c7276IlmS3t4rz6gXm5pmY9WajNeC5sx+gCohozIAaoU5sZ9Xt6sC4ucsBh8gkQR9jCW8yPeu+5dJT4DBbvhdadBOEPmy77reMBUyTUVYO+3gflgykXEP8egSIfrXGfRqBw9ErM0PvtgVkwLqSHDlq/1VWOd8cVPKTydDt+nZ9XegUPhQXtwVSkXXY6oN7dCzDz4/nVx4Cvgfl0UW1eXAtDLXxxxpA+AOFZk24NpVEV6BIaxjpuIbTX5T3IkNMgSxE25l0boY12lVNQpaadXGqWeQk46mJArNcV36mMXG2yeZLTiwlyKFAsEZC4HRMItgZR3QOuRUSLDOZVpBqIlnYGQvfhD+oFZZcVdPBR6sGDkArFu6u+QL61i7QOn8dw81cKlxxAFxjfnqgst5ueAoTUQ6295lzmuUk5INw2XS1bCJ1I4hjqPBzxEUF6vE1PUuwUJ2z8tBr3NRcCKBtx87d4XmYWfJttNXfITLkEOP2zAvp5EACTSjldri4CE5bFPAfGVz/Jc92MXzp/Cb6dBD0Yn4l6he6jNIQAZihWTJkvnShH+vH1G8jjOVexgMV6RP31bEbjnyuQ5zxkY3Xj19mRZvVPUyXmSToi687UPmchWy89+xLtWSUJMLxGTeS08jOMpe5D/3XNiLBBRIa04qsk3Ar/zg0c8
 Kb8BSc+9
 4POmYZfDGaK9VNmo8WofUmkH32fpHvz5k3IcuV+W6NdK4fWgz6PySub/pNJ4jA29dgVQB79Gv9ae5XUfpkaCUe7DVRAJP6/UM+N0Xo4TSOF4XVPs3Ma5TZ+vE/qVaMPWfU+oEtWvtvFclOhdS57l/tufKPqCiT6TAYeZvAFMrgFdGJLNb1tFAsXHAuGfGbS1lRn8+hSHrpwn2eYCuPYOAbWh5ZFKlfHm60brK5sPZnMs34M9X8t6/8IDLrbiTQMAk1hZ6oaoIGc3DTxjqGnfOGWLx1U8/bVaEx2nnvkzFIf45mTYJ39NMkwNJz0CMA/eGiazDd5+yAfLzRqhzHvpBFqXm3Yr8LwRogj1uyFWeTycFi7n/7SyjyPSQnaaivdVJ792oihVfBqlZk5D/b7Z8ijE/tYjQmv+FuyT0DBEy34Cq9VML2yoeKi1rGGvqiXjSl/HGiKaznLqrV9Lu59vghxuslAxx10EROxpGrjs9I0x6UIR7ygG5Smkps/v4EjCJ60G07nz+YiMtzpWn+8IqWnKwBoyttpjhRI3ezzNz+z0+HaBjUjjpntRog+A9bFXmklYdz5u+5XCtR1iUO9m9MCjf58hrf2LrAGeqF2xZDkW1+eeMCJIZuE4j10f68Dplpis0ARVGCnShec9utCBYgGu39Jjg9kb+BqB6u27disAkVdNv9cvz6vC8imQjm24KVJClrEnpYbO2B1Wgd9H3JJ8O7zeDTzHCeXe/Wr3MleSY03+CHtw6yBjFPqllS6GB40+KzX7FpBd1LMwDLWXPc2URd7bhGIsMSaPL6TImyK1lU+rMVd0YC8QGuNmJ4VvVPsjIudR87WkJaVjyVfRW8O/DdRZvQMgK1n8PS/btpunJcvy1ifn8tqOWxXxExxd4yb0g4XSd5hoBYoZo27v+v6NxjdDIw8DZcooSs5ZO+MVcyfZvcj6/alxiVaBrGSY6XuZDtUBoD7F4/ALTb/aVtIP4uzXR
 f24+0kcw
 5w9WQLBXlgueEKB40pq9De5yEYS5p3tNqPK1eve4Pcc2dcMOAfHQfgWPpJdA7wn0hxGjS8FjkBmNldaA2wHVHVJkxuQyZ8i43GBkuGTbumYr6XcsK/OUmbIyVTL0kNiDANSVuRgpUhyjASR3zTOw/lehH2jjRUGb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Answer a report from Sashiko at:
https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers@efficios.com

Document that the comparison between counters is on the wrapped
difference. It is valid only when the two counters differ by less than
LONG_MAX, and results are undefined beyond that.

Introduce a wrapped_delta() static inline helper to perform this
subtraction on unsigned types, which define the subtraction across
overflow, and use it in the comparison API.

I've reflowed some kdocs comments that were around the addition of new
sentences about wrapped difference.

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
 .../core-api/percpu-counter-tree.rst          |  3 +
 lib/percpu_counter_tree.c                     | 81 ++++++++++++-------
 2 files changed, 55 insertions(+), 29 deletions(-)

diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
index bb13e28bef11..878cbd85304c 100644
--- a/Documentation/core-api/percpu-counter-tree.rst
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -72,6 +72,9 @@ a set. A first pass compares the approximated values, and then a second
 pass only needs the precise sum for counter trees which are within the
 possible precise sum range of the counter tree chosen by the first pass.
 
+Because the comparison is on the wrapped difference, it is not transitive:
+ordering is undefined over a set of counters spanning more than LONG_MAX.
+
 Functions and structures
 ========================
 
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index a8351c53d062..26bfe183a882 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -457,6 +457,17 @@ long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_sum);
 
+/*
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when the two counters differ by less than LONG_MAX, and results are
+ * undefined beyond that.
+ */
+static inline
+long wrapped_delta(long a, long b)
+{
+	return (long)((unsigned long)a - (unsigned long)b);
+}
+
 /*
  * Each counter's approximation lies within [precise - under, precise + over]:
  *
@@ -504,13 +515,15 @@ int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy
  * @a: First counter to compare.
  * @b: Second counter to compare.
  *
- * Evaluate an approximate comparison of two counter trees.
- * This approximation comparison is fast, and provides an accurate
- * answer if the counters are found to be either less than or greater
- * than the other. However, if the approximated comparison returns
- * 0, the counters respective sums are found to be within the two
- * counters accuracy range. The two counters are read independently;
- * the result is not an atomic snapshot of both.
+ * Evaluate an approximate comparison of two counter trees. This approximation
+ * comparison is fast, and provides an accurate answer if the counters are
+ * found to be either less than or greater than the other. However, if the
+ * approximated comparison returns 0, the counters respective sums are found to
+ * be within the two counters accuracy range. The two counters are read
+ * independently; the result is not an atomic snapshot of both.
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when the two counters differ by less than LONG_MAX, and results are
+ * undefined beyond that.
  *
  * Return:
  * * %0		- Counters @a and @b do not differ by more than the sum of their respective
@@ -521,7 +534,8 @@ int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy
 int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
 {
 	/* See the range geometry above compare_delta(). */
-	return compare_delta(percpu_counter_tree_approximate_sum(a) - percpu_counter_tree_approximate_sum(b),
+	return compare_delta(wrapped_delta(percpu_counter_tree_approximate_sum(a),
+					   percpu_counter_tree_approximate_sum(b)),
 			     a->approx_accuracy_range.over + b->approx_accuracy_range.under,
 			     a->approx_accuracy_range.under + b->approx_accuracy_range.over);
 }
@@ -537,6 +551,9 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare);
  * answer if the counter is found to be either less than or greater
  * than the value. However, if the approximated comparison returns
  * 0, the value is within the counter accuracy range.
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when @v and the counter differ by less than LONG_MAX, and results are
+ * undefined beyond that.
  *
  * Return:
  * * %0		- The value @v is within the accuracy range of the counter.
@@ -545,7 +562,7 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare);
  */
 int percpu_counter_tree_approximate_compare_value(struct percpu_counter_tree *counter, long v)
 {
-	return compare_delta(v - percpu_counter_tree_approximate_sum(counter),
+	return compare_delta(wrapped_delta(v, percpu_counter_tree_approximate_sum(counter)),
 			     counter->approx_accuracy_range.under,
 			     counter->approx_accuracy_range.over);
 }
@@ -556,12 +573,14 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare_value);
  * @a: First counter to compare.
  * @b: Second counter to compare.
  *
- * Evaluate a precise comparison of two counter trees.
- * As an optimization, it uses the approximate counter comparison
- * to quickly compare counters which are far apart. Only cases where
- * counter sums are within the accuracy range require precise counter
- * sums. The two counters are read independently; the result is not an
- * atomic snapshot of both.
+ * Evaluate a precise comparison of two counter trees. As an optimization, it
+ * uses the approximate counter comparison to quickly compare counters which
+ * are far apart. Only cases where counter sums are within the accuracy range
+ * require precise counter sums. The two counters are read independently; the
+ * result is not an atomic snapshot of both.
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when the two counters differ by less than LONG_MAX, and results are
+ * undefined beyond that.
  *
  * Return:
  * * %0		- Counters are equal.
@@ -573,7 +592,7 @@ int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct pe
 	long count_a = percpu_counter_tree_approximate_sum(a),
 	     count_b = percpu_counter_tree_approximate_sum(b);
 	unsigned long accuracy_a, accuracy_b;
-	long delta = count_a - count_b;
+	long delta = wrapped_delta(count_a, count_b);
 	int res;
 
 	/* See the range geometry above compare_delta(). */
@@ -597,7 +616,7 @@ int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct pe
 	}
 	if (accuracy_b < accuracy_a) {
 		count_a = percpu_counter_tree_precise_sum(a);
-		res = compare_delta(count_a - count_b,
+		res = compare_delta(wrapped_delta(count_a, count_b),
 				    b->approx_accuracy_range.under,
 				    b->approx_accuracy_range.over);
 		if (res)
@@ -606,7 +625,7 @@ int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct pe
 		count_b = percpu_counter_tree_precise_sum(b);
 	} else {
 		count_b = percpu_counter_tree_precise_sum(b);
-		res = compare_delta(count_a - count_b,
+		res = compare_delta(wrapped_delta(count_a, count_b),
 				    a->approx_accuracy_range.over,
 				    a->approx_accuracy_range.under);
 		if (res)
@@ -614,9 +633,10 @@ int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct pe
 		/* Precise sum of second counter is required. */
 		count_a = percpu_counter_tree_precise_sum(a);
 	}
-	if (count_a - count_b < 0)
+	delta = wrapped_delta(count_a, count_b);
+	if (delta < 0)
 		return -1;
-	if (count_a - count_b > 0)
+	if (delta > 0)
 		return 1;
 	return 0;
 }
@@ -627,11 +647,13 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare);
  * @counter: Counter to compare.
  * @v: Value to compare.
  *
- * Evaluate a precise comparison of a counter tree against a given value.
- * As an optimization, it uses the approximate counter comparison
- * to quickly identify whether the counter and value are far apart.
- * Only cases where the value is within the counter accuracy range
- * require a precise counter sum.
+ * Evaluate a precise comparison of a counter tree against a given value. As
+ * an optimization, it uses the approximate counter comparison to quickly
+ * identify whether the counter and value are far apart. Only cases where the
+ * value is within the counter accuracy range require a precise counter sum.
+ * The comparison between counters is on the wrapped difference. It is valid
+ * only when @v and the counter differ by less than LONG_MAX, and results are
+ * undefined beyond that.
  *
  * Return:
  * * %0		- The value @v is equal to the counter.
@@ -640,10 +662,10 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_compare);
  */
 int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counter, long v)
 {
-	long count = percpu_counter_tree_approximate_sum(counter);
+	long count = percpu_counter_tree_approximate_sum(counter), delta;
 	int res;
 
-	res = compare_delta(v - count,
+	res = compare_delta(wrapped_delta(v, count),
 			    counter->approx_accuracy_range.under,
 			    counter->approx_accuracy_range.over);
 	/* The values are distanced enough for an accurate approximated comparison. */
@@ -652,9 +674,10 @@ int percpu_counter_tree_precise_compare_value(struct percpu_counter_tree *counte
 
 	/* Precise sum is required. */
 	count = percpu_counter_tree_precise_sum(counter);
-	if (v - count < 0)
+	delta = wrapped_delta(v, count);
+	if (delta < 0)
 		return -1;
-	if (v - count > 0)
+	if (delta > 0)
 		return 1;
 	return 0;
 }
-- 
2.43.0


