Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29056C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 16:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A5276B00A4; Fri,  4 Sep 2026 12:07:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8559E6B00A5; Fri,  4 Sep 2026 12:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C4B6B00A6; Fri,  4 Sep 2026 12:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3216B00A4
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 12:07:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBE93A0101
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:41 +0000 (UTC)
X-FDA: 85176560322.29.AF7E00A
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2FCE840009
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 16:07:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=ZtArIxs3;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788538060;
	b=VQ2tsurGHbJHmmnTcbjBeD1O4O7H3tL2Pn1MlGxiS6gkn4uwPldViE0p0ykgOjMxU7RQO6
	23GQ02oxk3GjW3Zao4zwyWp1KnexYYVOZFr2cQIVoovdjyyJwsmzamqjtmS6xcsu3gW9cH
	RqQLOR52wN7V11K4VUUd8k8Z4wbLNBU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=ZtArIxs3;
	spf=pass (imf01.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788538060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lradUNjQ28/3mgjgcohJ5akUg3r+w3Kdj2J+iydSJdo=;
	b=M4OnxZilI8SjRGL5bFN3T3P6jD9YSRWb2lPy6/P8qG99XyQZwhOsvhqx2rfbJVPNP0OnNI
	w8bimr2+hIhU/DA4f60hpMD4EYGi+LFV6fQP+3g2WbY5r52Q+68SbYI4Jyws8ORhASR9p5
	PnVZ+XjGDwKleNYUUZ2kSx04Gryfgoo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788538058;
	bh=lradUNjQ28/3mgjgcohJ5akUg3r+w3Kdj2J+iydSJdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZtArIxs36rzznKd2FiPR6bsMWG98lM6zzCRxyDLG0UFs6hz+gDG/jeNe3GW19Sreg
	 HfM5ADbXr7bwXq270tGwlDUvKC3sSf0adM1lTlD3PduSl08LkU2cLfBYiHLcqJpz7S
	 7Ksoy6hLprKYuabeX9dOqjX3xZGKcBhI0mcQImgvwYzcqhtCqSeSIqWVZrjYmIAsJU
	 So9KxR6oWF7scAXrAS7z51ONPjnWNpw284SGIYcTXHalDngJ0s2XiiRgMAs639pUKJ
	 tsM/fIiZNoo2ll2Kam2AW6MvqA+gJJFggCiX/0hKpBr26Ju3rzuc0gJnP8CXGxxnfX
	 Ur2hOcWYKlyNg==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hc1Zf3dnqzXNS;
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
Subject: [PATCH v22 08/10] lib/hpcc: Clarify accuracy range documentation
Date: Fri,  4 Sep 2026 12:07:20 -0400
Message-ID: <20260904160734.23445-9-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
References: <20260904160734.23445-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: w7mayus8siy7z7fyuziuyp3y8dusbme5
X-Rspamd-Queue-Id: 2FCE840009
X-Rspamd-Server: rspam06
X-HE-Tag: 1788538060-438409
X-HE-Meta: U2FsdGVkX187rnXQE8KqVrYWEgt5TQxxV1YHjaG942yIppA5UYX74b19YQSua04wmPzx9ZkmlPQtlKixvtuYBZA1d8fSkbpnVmi3vJIRS2oL/wN4rE3Y1ODMRW3G6tvZ6n/QCjjg7M8z0upm6YcKM+KvcVrHH/nLWqfjCCwVN9AleqoHlYIc8d07pIdsksYiLAK8ilIxslVYdI5W96o3FCbxS/WG+7yivHiPe8HS/CtG4oq4tOSZne42YPNYxdUcHahpeCOs2qzZRl/x7v0atee/jrmmPeVV1UU3/3hT76nF9FhRlB7RZu6uCywgo4V2xZuKQsEgwW9pMnAmoIOCyNSjCYq3z8rFAkqkQoNWV114Y7eux0T25BoJTUniOWkVWatxJQD1GU0+kCeQcLBOB36Ztt//6GDPuxtD64uHNSMCnv3ay5dR5WRYNqNLKG7DOYpxyLLaAN5Ckq/LKPKYiQ9WsRTI8yIiHzbgyG7fO935HF/RFNwlr7GqaqjYh5+csIRAFB5MqeED90y4irNxX2Q8i/XVKSJ9EulvxAVG788krvvYJkEb55giIdRK2qYWFOcDIG+gQQcbT2mrGxVw29QL3N0VeA7qq48Sn0UZTfDgpSmH6E2qx6WTvHTWyigMTGhRb5NZIaqiwAQJs9Q+ClEQaUibGvde1KvtbwbjEdIAiZvCqOX3vZgNQTI6brn/5WHlS3ol4oWogtluTlMTfbwndlJ1kLZu9kpFyEBg3Dgse4F1NBFF9Aj06LEZv4ZRJD+CQd0RvoWyNGRH4T/XB1Zxf3m4CKroEIH8fVgHdUqTa8GQYDwoo26yZG4FcHE9wmBHQrr3Bn6sQwKc7T8XeyOGHBPCNvDtkhU2EGPZfkxAsWZu1MJlGhLRcqHi6DXPxdaSOPJIIWz25rLhmxqqRegZTdDNKw//tj2QVIn6lbIZDS+cMKjJ5mpsL7uWesQwQRMZCchTl400VESe59i
 TaE+9f9E
 s/NLo0kyUuZDy04HpmVwLumIWD8GkrFspiDVpAVwQHRjSvXB3oeNxARmevd0WHWka7L9Z0I2cfFmryep7FW58hIKcFeuJMihKojT7daBm8PcsVGgmoXI6ub5WXysZTxMGElF5s97FxJzmtwv2ExVBh8uUC0TeGnYUWjAy1tV4/tET9brr0RL92wpteaLQXFty5f51183maMSFi4f2VXUlFd2/ncNGbwMl6EMn2vCezIpapB5VqlHcLpetdyDxG+ATSIQ0eopUfUDzfyUGYLOXwnjjmQyRJH7kPM26BNtDCt7RztsdwsUZn+0AgW4YQZhyZLhROTbk1ExMKGsgNM/ZfoHNcHjg3J+mNgSqxxaC8i3QlH8qSDSfJsBJg9Adrlg/5a02uVj2w2HBWtsAGlZaVaRqh5mbr0M+BA1tco143Ds5p7xLrQzera/aD7+qK/Qe3C2SJAM5Bzt42xBuddMRJbw+5oSWp/+zg/IhKsscwofwJXcGofNagALdX3W1B7J9eDI9s9mqMsH3DiNmVY1HaraM/uV01SqByxTf6mLXvZPeS5E9LJBuQ7DtbUwmIXrq7TfcqKCDON/5NYCBPOU1Gmz0NvtEJUTP/8UtWd+yprM0YuzRMLWsrW8hbf0u/QIbc2hYqOeg+QErKH1Qbbzv7/Qdg3YK77dXHLEdfX90CJ6s1Xr6wa2GP+WS4cR4sRtDe7pi5TEzZeDXJ+wrptVDDn2bQkHyo312ALBmFA9rVANnSf19x/P+YNk2dfG9PJ744PjHSYV9N+VC09KZnxnZrbBlB27E1EodWJWxIWi9g3qOafe/gyOxOeIC0RGdRHoIQBRwNGjkwRHxT6EHfyy4Ip/Yo9wLlHL4GPTxS4xJSw1AHBMOiAPXRaAPnHG2JLy04e/FDXqCS2APR12uW4TBaKGfuFA0zIyoryVpCyCQ024nyIcBLfbLkntW79PbJVTlYce8cPMjSDkf05zm18zdEXnMZJP2
 WLAFUiMz
 MsuM1xgg4mH8VNgIjoadX30tbXp53TgY7AViQU2KX5fI6f8inzgGGD+UX3wJ/gLxGBWjYWuVWPMduVpWuDTTP68OVf8W1bh6olzZVopDuKtHYfgm144BE17Tt6fX7+KyoqmDjZnK+E9GjSyymJLEvA9ZX6+4+v4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Answer a report from Sashiko at:
https://sashiko.dev/#/patchset/20260901182857.26690-1-mathieu.desnoyers@efficios.com

Note that both Sashiko and Claude got it wrong with respect to what was
going on there. I took out pen and paper to draw the range situation,
and presented the result to Claude through ascii art, which solved the
matter. Having two LLMs misguided by the code, I decided to add a visual
representation of the approximation ranges to compare_delta() so anyone
reviewing this code won't fall into the same traps.

This change is documentation only.

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
 lib/percpu_counter_tree.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/lib/percpu_counter_tree.c b/lib/percpu_counter_tree.c
index cd71581f56bb..a8351c53d062 100644
--- a/lib/percpu_counter_tree.c
+++ b/lib/percpu_counter_tree.c
@@ -457,6 +457,32 @@ long percpu_counter_tree_precise_sum(struct percpu_counter_tree *counter)
 }
 EXPORT_SYMBOL_GPL(percpu_counter_tree_precise_sum);
 
+/*
+ * Each counter's approximation lies within [precise - under, precise + over]:
+ *
+ *                  approx_a range
+ *            <-----------+----------->
+ *          under_a       |       over_a
+ *                    precise_a
+ *                        |                          approx_b range
+ *                        |                    <-----------+----------->
+ *                        |                  under_b       |       over_b
+ *                        |                            precise_b
+ *                        |                                |
+ *                        |<------------ gap ------------->|
+ *  ----------------------+--------------------------------+-------------> values
+ *
+ * The two ranges are disjoint, and the comparison can return a definitive
+ * answer, only once the gap exceeds the two facing half-widths:
+ *
+ *   a below b:  gap > over_a + under_b   (a's upper edge, b's lower edge)
+ *   a above b:  gap > under_a + over_b   (a's lower edge, b's upper edge)
+ *
+ * When comparing against a plain value, the value has zero width, so the
+ * margins reduce to that single counter's under and over.
+ *
+ * accuracy_neg is used when delta < 0, and accuracy_pos is used when delta >= 0.
+ */
 static
 int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy_pos)
 {
@@ -494,6 +520,7 @@ int compare_delta(long delta, unsigned long accuracy_neg, unsigned long accuracy
  */
 int percpu_counter_tree_approximate_compare(struct percpu_counter_tree *a, struct percpu_counter_tree *b)
 {
+	/* See the range geometry above compare_delta(). */
 	return compare_delta(percpu_counter_tree_approximate_sum(a) - percpu_counter_tree_approximate_sum(b),
 			     a->approx_accuracy_range.over + b->approx_accuracy_range.under,
 			     a->approx_accuracy_range.under + b->approx_accuracy_range.over);
@@ -549,6 +576,7 @@ int percpu_counter_tree_precise_compare(struct percpu_counter_tree *a, struct pe
 	long delta = count_a - count_b;
 	int res;
 
+	/* See the range geometry above compare_delta(). */
 	res = compare_delta(delta,
 			    a->approx_accuracy_range.over + b->approx_accuracy_range.under,
 			    a->approx_accuracy_range.under + b->approx_accuracy_range.over);
-- 
2.43.0


