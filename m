Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7535C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 14:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE2396B009E; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB9646B00D9; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BB06B009E; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A0D4A6B00C0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:19:23 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1678D403B3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:23 +0000 (UTC)
X-FDA: 84958559406.14.BE9E314
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7F6B21C0008
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GOzn+ND9;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783347561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VcWww5ifvnRODUdttj+GVq6VBSGXV/EsAHhoPI+HZt4=;
	b=G/pw36BhZP2cgpk2eDtnSwbtSHgEvQ70ytz9Ju0LXIeTFXAbNXNJuXr5vFNbN2+1NfvhFX
	ouMqEZtsAcVORTejr4YlO3iJ8FrA/hK+obZSv3hLsv6PDNWUHNp+eSF0CdiENOhQdfDekY
	zzvWGXdUVq/T50GcK6g+XX4sam2qhFg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GOzn+ND9;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783347561;
	b=LeZvQUwixa6BL5+HSOHQEU9bh9Q2kWKKOK3J913p+4NQU9Wl4Hr3QX+BoUOL3QZ2uBw/HO
	ocFIKsHjr7atqcUC8kV5Oy2Zi9QJ1fNjDR6Z74bF1/Sn17wFdwIXyo1sA9WQkXJLDCUR2m
	suseVj4A1kdwjXDSI2+Q+l0dHUzOOHA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 23316600FC;
	Mon,  6 Jul 2026 14:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A80641F00A3A;
	Mon,  6 Jul 2026 14:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783347560;
	bh=VcWww5ifvnRODUdttj+GVq6VBSGXV/EsAHhoPI+HZt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOzn+ND9YBjb6bLwwltmgdYGJIebzuoGqSANOwAAPWczWJzio769cUd6gzWaLkYRn
	 Tv9pInA4WNSBzAck/t8eNKChZ+5sfPHe10R4yK04537wtBB69PqtAqOZiv3Smpyguw
	 zm+vGIOhhKWf9Djx7mZcQL7loz9Orv4AmNXlWIMdAyzdgaf+OSS8jlwmVuRy1EOP7n
	 nYDGa2kLggB2KkeLRNt6VHj5HfzeJ+QIvfkm7L6kmUoZI5j9/kaGl7ISlA2IRNv35i
	 JNBmjbBxHepBUzk5elZ2YJ2QgVsDhLksoa3Sg4t+KoqauP8vr7blBWchXHPLdVzJrr
	 IkEmE790OaRxw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 01/16] mm/damon/core: introduce damon_probe->weight
Date: Mon,  6 Jul 2026 07:18:55 -0700
Message-ID: <20260706141912.88445-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260706141912.88445-1-sj@kernel.org>
References: <20260706141912.88445-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F6B21C0008
X-Stat-Signature: 6rd1a4keug9pwqz6sxru7ee4zt87aztj
X-HE-Tag: 1783347561-960214
X-HE-Meta: U2FsdGVkX18s6Kqa/jVUBAtZMUtROde1O8FtQ7ogJXBw1+yVhHZpWLkXntKve6z6jlqzukhfwFrmuGQg3H+fDDpdfSiPzZHuP7LVCkNEnbR8VQWXQv6bBa8IgUaTt77V2PUCC1uR7XoT3pwUvQieDOXS6EngsjhkA/T8+S2Z4KubWLdP1TX5blH7eZOtM5ULDKXuc5cuZhdhQgR8dhaqyXGEwlm5QqGuwKlDpZJ3M5BPAP8WvbFsSW6UJ2+3m0q87KlDFLxwtLfvSWdeh10zYj10ZRWBcWBy0OFUE+8bjDLD+gHStbO9OKsOIHImhs7Q7kiIT6vvG3R0dr6G3t5hNai14oJ1Drk9ucOZJZu7daTFYTf5khq8ZxtEO2cOKe0ral1dp3dPbCae9mxAb9CoqAE/9KKR1Vhs25Ze6eK6f9IV9rzcbMIVwbDIRBMrIYVSmkTWVI2YPQkzvS/vnBOQ6SNvXtZBIG9C6BZCUj8fM4/YT9C3fpT2sWAaZKIIZ4caqumQwvYCc1FN390g61tETaq1fzy2kuPcWtHCuAC3kcTuUOjynsjFYs7BTTV83ifGOLwErDMFVYYTjnXZLMajntQLlZzA9zP9q6qSAza29WN9eE8ax1Zb3QLEEu/cxaOuIWeLf0puhDTtsIAdaaXaIFn6JvNvVA/nj0j1mW5A5CTa5772yBfciN+1fKF4UkzGhDlPlu1atxSwBJLfCVRT6AW9/Q3Iru/qBhv6rHM8bxI/V9EWaWbXU0oW4vufM9a6PPT3TLiAsUHK1RfHlK0mjTTtAYIGumUT0Mbr52fomvp7TlcdBZpAstWm70akZAJcGe/FO8zEcGkOkOvx+iaO7BfsBmFnoeBhcqegQvG+8BanN/fZU5Nrr5ivwmDEvqemeXduRCtwpoF4sElu+TzHerkV/3vv0m7IYJe+GtxYKvzGx20bAQ7KL7y6o481JBVZAIk/RJbwo2budCrLbC/
 fx/ajW9b
 0u/s88ypvkW/Hcj1tDlsbML47VGjAe7m0bRjdtXbvlOMQyfky2WSMzkokVqav/0xFOKtCEIBCs3qDlA6oC4eu91fv+nDzS2FF8/CaD7IARwKj1kVMK2WJ+B+Gfnm62fueAk1rp+QjnZHC3toAZ458yylZWeXglNyzuG7odmfaALeshMhp3h3nj0vKgZZ5kd6vXob+kaPpXdl1uioNy92uYi/ME5kjH8UGgPh6hbqZdjJLWYDO8LZfwBVU8+aQy5Aj72+9RNolvuZ09Ouknz15D3A+sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new field, weight to damon_probe struct.  The field is used to
specify the degree of the API caller's interest to the data attribute
of the probe.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 19b7e839bde0b..7d0a920fe4b83 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -760,10 +760,12 @@ struct damon_filter {
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @weight:	Relative priority of the attribute for this probe.
  * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	unsigned int weight;
 	struct list_head filters;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 390e00b3685ef..ca5c3f3e45fc6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -166,6 +166,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	p->weight = 0;
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -1641,6 +1642,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	damon_for_each_probe_safe(dst_probe, next, dst) {
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
+			dst_probe->weight = src_probe->weight;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1657,6 +1659,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		if (!new_probe)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
+		new_probe->weight = src_probe->weight;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

