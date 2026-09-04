Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83F30C624DE
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C06136B00A1; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD77D6B00A4; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A52406B00A5; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79DC66B00A2
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:42 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3033160133
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
X-FDA: 85176560322.08.BE77B29
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A3B1120012
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=u41Mh3jE;
	spf=pass (imf29.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538060;
	b=lSIIOXaXdP1WVYo1I1BmMRppj70veAQ1Hiisi8/bnsxUigu/8m7eK+ObwQ1pQayNHr9QGj
	Y5ny65ZHnHMBXLwmFfFMdi++ZxdvXT5u6KFPCVrrXOhDEUwrjAiP0CTqWXFh0pTh/ao66i
	g7qP7Cwecm/3c3a+0yXqQ9k1MAT470Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=u41Mh3jE;
	spf=pass (imf29.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f61pjVNcG3vfV4ruWkC/0g9a79TuVBC5x25qutrEOrw=;
	b=2qV1dxOhISjXOq3K6AcRe/0M1lAPkfYmSGX4bMlt8qyfysZouzabqZMblTziXQJ1W0DH1M
	VP+JONxtg5KFZTonY2LS7jGZMqmHORoilX6yCDHQkEY5+0NIc6b3yJkh2/ybKEwDrvK8G+
	V2jE0qu1qgkGup89u/XpzAivdR3jzaU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538058;
	bh=f61pjVNcG3vfV4ruWkC/0g9a79TuVBC5x25qutrEOrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u41Mh3jEJRteYmwrd/a6v5pGZjWY66A+h8ipRzrmzS3bE2DGea24bwVQTv/7LmmnP
	 5jdwHYRjYfuTMJTkWkcdSUiYquVshrj5KNIbsFdDpAGxIm67v3HqzwTYBOlNW5CqeT
	 H+jDSf1VbWmEF1odRRacFujOa1TEP8CVcqMX9gLgN1/oMHHI4YVPxvIDfUQRVHZy8P
	 0wwbWkTGHByec34uO88Kq9m4bj6ORAL74aDmWok6qzSLF1l12ORYa54kCd5TMWDcrp
	 CQ7xLAgUhYcjnxoCAAyV+TBGUp+KNJlfzNEf3HrW+oJuWPW+K+nyM3y5S/RHoigJTS
	 vTrJw3/XHN9wA==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zf2MC5zXNR;
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
Subject: [PATCH v22 07/10] lib/hpcc: Document that accuracy is a property of settled counters
Date: Fri,  4 Sep 2026 12:07:19 -0400
Message-ID: <20260904160734.23445-8-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A3B1120012
X-Stat-Signature: 7b83scg1teyrk5hhemzoedmgr47njwp4
X-Rspam-User: 
X-HE-Tag: 1788538060-348832
X-HE-Meta: U2FsdGVkX18dzsButW76sxpeae74oc7Lv+fVmAUcxeJjuib7VvmwSR22qRgPEEaDHgKuoBZlSeKOmvTA8L32wdMtwKXRVMXsp+Rxuf58NhBPALk/kB2lfPD90WUDoGegqfk8awewHb2Yb1T8bTCK03yyvOvQC/ByNCCrhFosXTmbnioyklZrU2LVLKFzuNuK9e8El958vf5ZW7PhA2yIxsLuTxhYo7lnxQejbsMT29DbJxC2VRrhSQf42qpFJtvcdR9Hg2AmfGHn2D8baDK8ukjv/Sp+MY2PiKypo5I0x369o9JLWYNCHDKZSeJvU5SIcxNRLgFCK6rzJeRhuKMa9KuQbMpJqdZEhEkhBZ3MWrbbePuu7zJWVL4GYfMIaRfgs/IcOolS5aQ0u6vVAqBFAK9Oo59U+yZ0jOsmrwiloQQIrkIj0VB1N2DWV1r1/5SAAMgBNm6Ws3EnOhakD/sL645Xv0JnBcTi0L7aadUpczZ08S7tMh6bNHzaxDDPzD28wx+i1BdbwZJtvV3F5P6qtanG4op0QnVQF86rIDqkWkoomPf5M6DdJpNcfCK4WC5TTDToYQexBcH96acnFG/iP5oeGGg6TBYMwkAZlTu9BS6Z4a+2SU6pj19jqCvyloIG/JrF+4Y1/ppdfrZx9ZK3aXDc1E5NN2Xjv6hKr3ncA+2iFNgV2PWwpO4kJtZxNmNpd/ikv5zTshcT9qVlCUAuXIt5Gbg3XQn8llWHSYz/hH+9BEXwBqxf15b96hs6ls5Lq02+Wrsv1xh85Mrz6UCT16+1PprY3sDBMOa5OMomKdVuO9KqazPyU7/FRYmIX9eFg+oymhdgpYW7Lq2eCOjlcgzLyyt+JOukc1ZQGOTU9DiktvtmhOBjaaA22nvYu/l9rcPe5vzhJ6dfVLESjK0yuaRJukhH1lZB4mH1+jJaac76Z1S6Uq5hfKtxW5Z10HzpDMkWvClovhC6rwpwr44
 1dXApgnq
 mprKVlKFVig7SPZ31NFfwwMBtIwglKWj9qnVzXw0aNVHq4xDtfWDdBbyRkEQCzfYVydCHx3wj+UUEI3j5dPeCVogTxDlwbBQO5myHfGZEa3jiKi15UveHFYMSKUb4l8ouEZG5WcLpElrRj/h7OWKVultJhmy7fKlrK4Q/MUHuGcday8ZiOdenCrJuRzkVY1EPYjLRvIK3eC09ihifbre/Z0rqnNmCGuNVPjNok3xAjXNNGdajizDJUnPwphh0CLUJpjw5+NPc5j1HhbNIIgAj6w1jjXuJGgq3weXVPfsA+/LAfPOxCwK8gXQo1CpLFmrQZnu0TNqBtyoIosGoorz7EZcH8w/h+74oGEXXs/adqAG8Z8/jB1YZpns+wf5QJhK2HRUMnXPMLTODzh4joXCdHGpVVPvUmNHJhD2+D3CD5ssU5tYg8d7Ga2s9ssaFg/r9p9cQTRi0DoT4ZFcSsT7Bh9Nv5/dsU/Pw+bEcukpZfmAqcZe3Z6F2Ww62EUJ1Gm+Ictn5ls+cirMwLL5fxskHPdPEjIBNIwkpXBzNJXSbIxi1wRpux+xXOka5tv+TrEzFLQsWPqarM+PZfkXJ20V8HFq0Y5/tMeCp1aFFOBkKzpATGzGuUrJycib5xCkYsrvOcSGFBQHIn5YmWdlkqtRNL9XEYlqubFKVihRkvd8KnYrZ3zaV+ZGjQGb3E4Hfu4SFb449YwuK891/wZYgbE0SZ6Gk466NzMGf5Q1etnPEcKeGskJxw3/vQeRfs0+9GXtoqujijlfyXCGqCmVJWLcEMmLZepxmHok0s/H4J2Sp3AwLaQs1PY6+90hdBnvuRaC7wFABTWnb1oiJlhCKDs2pgLWsbwJ/7UuEiwu8tbi7XLzCaEWfyIEZ8iuBJv9pMNjj8a9qG0f2tOtmAn5JPfvacOnN7a1vGevzwwmT1gu2unkhgOyzi2waCIEhgwkgPfkO2yz+vXoHKO8zt/sNaxW8zYMnpyaw
 teoX++j1
 EHNP8+zLLhnGmegDzRcvQXBnuHiyr+bvfEAj8J1huUxl6Bcmvt68Q6kXVj5fhnVU0qVhgv7zIQEJyg/HuTjQN41UZavHv6WUqE7uO8xay/UMljh5+VhrGHpW9qWtjNNsU5kF/Q+FVj9TKeZVHPf+qRu9zmszqVZt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Answer a report from Sashiko at:
https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers@efficios.com

This change is documentation only. The bound describes a settled tree;
the two-counter comparisons read their operands independently. No code
change.

I considered and rejected the preempt_disable() proposed by Sashiko and
an alternative dual pre/post counters design.

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
 Documentation/core-api/percpu-counter-tree.rst |  4 ++++
 include/linux/percpu_counter_tree.h            | 10 +++++++---
 lib/percpu_counter_tree.c                      |  6 ++++--
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/Documentation/core-api/percpu-counter-tree.rst b/Documentation/core-api/percpu-counter-tree.rst
index 196da056e7b4..bb13e28bef11 100644
--- a/Documentation/core-api/percpu-counter-tree.rst
+++ b/Documentation/core-api/percpu-counter-tree.rst
@@ -43,6 +43,10 @@ This allows reading an approximated value at the root, which has a
 bounded accuracy (minimum/maximum possible precise sum range) determined
 by the tree topology.
 
+The bounded accuracy is a property of the settled tree. While updates are
+in flight the transient error can exceed it, bounded by the number of
+updaters and their increment size.
+
 Use Cases
 =========
 
diff --git a/include/linux/percpu_counter_tree.h b/include/linux/percpu_counter_tree.h
index 4095acdc879b..d593806b4ab2 100644
--- a/include/linux/percpu_counter_tree.h
+++ b/include/linux/percpu_counter_tree.h
@@ -93,7 +93,8 @@ struct percpu_counter_tree {
 	 * The "under" accuracy is larger than the "over" accuracy because the negative range of a
 	 * two's complement signed integer is one unit larger than the positive range. This delta
 	 * is summed for each tree item, which leads to a significantly larger "under" accuracy range
-	 * compared to the "over" accuracy range.
+	 * compared to the "over" accuracy range. The accuracy range is a bound on a settled counter:
+	 * one with no update in progress.
 	 */
 	struct {
 		unsigned long under;
@@ -169,6 +170,8 @@ long percpu_counter_tree_approximate_sum(struct percpu_counter_tree *counter)
  * slightly larger than the "over" range.
  * Those values are derived from the hardware topology and the counter tree batch size.
  * They are invariant for a given counter tree.
+ * The bounds describe a settled counter: one with no update in progress.
+ * An update in flight between its per-CPU increment and its carry propagation is not covered.
  * Using this function should not be typically required, see the following functions instead:
  * * percpu_counter_tree_approximate_compare(),
  * * percpu_counter_tree_approximate_compare_value(),
@@ -341,8 +344,9 @@ long percpu_counter_tree_precise_sum_positive(struct percpu_counter_tree *counte
  * @precise_min: Minimum possible value for precise sum (output).
  * @precise_max: Maximum possible value for precise sum (output).
  *
- * Calculate the minimum and maximum precise values for a given
- * approximation and (under, over) accuracy range.
+ * Calculate the minimum and maximum precise values for a given approximation
+ * and (under, over) accuracy range. The accuracy range is a bound on a settled
+ * tree: one with no update in progress.
  *
  * The range of the approximation as a function of the precise sum is expressed as:
  *
diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index cfa5b04e05d7..cd71581f56bb 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -483,7 +483,8 @@ int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy
  * answer if the counters are found to be either less than or greater
  * than the other. However, if the approximated comparison returns
  * 0, the counters respective sums are found to be within the two
- * counters accuracy range.
+ * counters accuracy range. The two counters are read independently;
+ * the result is not an atomic snapshot of both.
  *
  * Return:
  * * %0		- Counters @a and @b do not differ by more than the sum of their respective
@@ -532,7 +533,8 @@ EXPORT_SYMBOL_GPL(percpu_counter_tree_approximate_compare_value);
  * As an optimization, it uses the approximate counter comparison
  * to quickly compare counters which are far apart. Only cases where
  * counter sums are within the accuracy range require precise counter
- * sums.
+ * sums. The two counters are read independently; the result is not an
+ * atomic snapshot of both.
  *
  * Return:
  * * %0		- Counters are equal.
-- 
2.43.0


