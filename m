Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26A31C61DE4
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 04:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5646B00E9; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E9F6B00EC; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39D26B00EE; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9C46B00E9
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 00:34:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E95721A0314
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:30 +0000 (UTC)
X-FDA: 85163927100.11.25D503E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D2B2100004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:34:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=krIhuBi4;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788237269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMsa03+GswfqkWjEdLMDvVsbH1S2RLUAm5b70sXm7PU=;
	b=tfFdUGRpxT4wlLtCAfv4QaRHcwi+Z8yZjwkwJ+nQ2ojED4f0AeS8H/Bu73ziER0x6g99tD
	qW5ku3Ueis82K5WfQ5u24dvXPJfY2qz53QLCQbSY2PNnK1k3SZHohn8EnEZqDFsz8DwuYz
	otcryJ/qotHpQHnrq3l5bg1lIWTno4c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=krIhuBi4;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788237269;
	b=FSM+zMlrO6aSVTebTV5uDXNvRr9vOdxKzmN4DYfq4ztbO9DyyNP9ULMyr3hRAudFh5jKy2
	Y67inz94FnxUcEmEojuD+O0uWmerq6q8tR64TxUKNEvVQw/YS4vuOfCMCR3InHeWxZ4ZR2
	2ZJ797g4rKd60qRrK7Tae54t5WyVNBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D27904015E;
	Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2011F00A3E;
	Tue,  1 Sep 2026 04:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788237267;
	bh=IMsa03+GswfqkWjEdLMDvVsbH1S2RLUAm5b70sXm7PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=krIhuBi4auk0TVj3onlZzLl4XbW0+zYwwjIRfN3q71lQT70yIZldYdwC81VvuBQZt
	 Ik0SnnFw6bGvURZ9NKZr3utvEl927pkVvzdXT0qV+Z/sLpgIptr0Mu8t1fT1hCAL+v
	 PWvwRoMR+St/RwamqEeIDZStd2zaNRV71l967E5eSTuo/SPxqt2lkp1uaDqSOhUCTR
	 7UnUyNxJdYTCo3BCb08ICYuagAQA86FMaZlHMIecHSzkDcPSO57Sol7yZ9mcZPV655
	 Cxr0HZqLsXhfbgxHUzmcVC8YiLbrO+QSPgZDFpmLi9qGCOw2YleCBpyWmbF8HAmngI
	 LgfSZpQ9cWNag==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/17] mm/damon/core: commit preps
Date: Mon, 31 Aug 2026 21:34:02 -0700
Message-ID: <20260901043417.2165-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260901043417.2165-1-sj@kernel.org>
References: <20260901043417.2165-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ay6jjt3dmc5ukpb7xym646mfdcieo9be
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 4D2B2100004
X-Rspam-User: 
X-HE-Tag: 1788237269-477609
X-HE-Meta: U2FsdGVkX192GA6WTZUOP6GTmJLx+WA60fcGenzS6f1I3VS84oOMrRm5JUI1yETk8f86S97s7tS19MAlyatV6jb4ht4TfNbhHej+JDRhV2+HRWob+ATFzYVVthY8jQzhPsrSwyUxvWnuxNUCF5lvGS+s9ATXE3wbr5vRwq+Ep3EbnwMPSCrekz7Vxu89cSRLzDzuhv1meXco4iGlSOtK/9dwow6FSv9jpeOMdenLwq2bV9sFS8/ADsSSxvnGSvu+XRdqntwcMexYE2XQxEDZiilji0A8RrVQYBZO6L9SXHZncL6n6a5AJmiDoGwElpnyaWgD5Fr0Ed3z69D6G+lX3E02EIikspindJSXhbhQ1QSIBT7LAPmWaWbKGW1TobRJHySGHkbJ5NwPAjAOdocgmNr9TVMAPS8g89Suo3QGmpOOti6SMaL/Vesc5SyLgQOPeFhIRr9prkPzf0QLAJrp9CzyZu0JB+WPXU1EfK8/ykSb+5Q7rV3/n2frdHKF3VXZlhdwMSNSCDrQCwJG9BPcSanMHSdzyCw/we+V5fZ7GnmjfYc9Ev1F7i5YH7W9BEZeb6F22CQZcXEyg5YdeFQY7errfGu9gKyFueAqB0/IUCu0mrOyfOvs6cZ4sMVo7jWU0Dua5OiVn8IteOxxU+OibzGSoawv5xaIk6uQ92iGda2es8UopLpL6s+1auJ1yFlwT8blcTYhlLs3H3/SdtPDwQSxvlityJhd8cGnJRrH7S8OdEn+UvwnAey8uKwhXVsMdXlMKIhTmfvH7mpijaEXtsvDUIPg2eZjf5RUBYJtt7Ll2y76Q+sHq2s75neGt/Wubf2jQn9l50cMVXXzNqJamwh3nderhtzHGfii2QXecsjDPwe3iCb7ufpGUxNxT9Gacu9TRUxAIcOX6IlGhMU25SmusQtUeBjIVOU/VXGI96Xnc4Tu1VfAY04scMSUly1X4Urble9c5o6gLQ/TMG5
 6AAkMx8L
 /AVzeaN+mzDjInP7B3YJhesZUfCSO30z5Y+kgGnoSPb6T5CxrWKrqOIine+BnOHCNsGWgu0IBeYkyb/5JRCRCmPKkxtkec8Y633zQym9wn9/aHViH/9VI7xAV9SEUXTMwdwsRAn31V93KwBtN/z3aAj/tnfA5K1VMKNNKG9vsLIQZLXAlgrnVPD6XuOggsWDYpxH9Sa8Rfh2JihUdDW3S4tb9yE7yiLtH+esplCFX2tw8EUA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_probes() is ignoring damon_prep.  Commit the prep actions,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 85774dbca64b8..87ac428358ec0 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -129,11 +129,34 @@ void damon_add_prep(struct damon_probe *p, struct damon_prep *prep)
 	list_add_tail(&prep->list, &p->preps);
 }
 
+static void damon_del_prep(struct damon_prep *p)
+{
+	list_del(&p->list);
+}
+
 static void damon_free_prep(struct damon_prep *p)
 {
 	kfree(p);
 }
 
+static void damon_destroy_prep(struct damon_prep *p)
+{
+	damon_del_prep(p);
+	damon_free_prep(p);
+}
+
+static struct damon_prep *damon_nth_prep(int n, struct damon_probe *p)
+{
+	struct damon_prep *prep;
+	int i = 0;
+
+	damon_for_each_prep(prep, p) {
+		if (i++ == n)
+			return prep;
+	}
+	return NULL;
+}
+
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow)
 {
@@ -1706,6 +1729,36 @@ static int damon_commit_targets(
 	return err;
 }
 
+static void damon_commit_prep(struct damon_prep *dst, struct damon_prep *src)
+{
+	dst->action = src->action;
+}
+
+static int damon_commit_preps(struct damon_probe *dst, struct damon_probe *src)
+{
+	struct damon_prep *dst_prep, *next, *src_prep, *new_prep;
+	int i = 0, j = 0;
+
+	damon_for_each_prep_safe(dst_prep, next, dst) {
+		src_prep = damon_nth_prep(i++, src);
+		if (src_prep)
+			damon_commit_prep(dst_prep, src_prep);
+		else
+			damon_destroy_prep(dst_prep);
+	}
+
+	damon_for_each_prep_safe(src_prep, next, src) {
+		if (j++ < i)
+			continue;
+
+		new_prep = damon_new_prep(src_prep->action);
+		if (!new_prep)
+			return -ENOMEM;
+		damon_add_prep(dst, new_prep);
+	}
+	return 0;
+}
+
 static void damon_commit_filter(struct damon_filter *dst,
 		struct damon_filter *src)
 {
@@ -1764,6 +1817,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
 			dst_probe->weight = src_probe->weight;
+			err = damon_commit_preps(dst_probe, src_probe);
+			if (err)
+				return err;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1781,6 +1837,9 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
 		new_probe->weight = src_probe->weight;
+		err = damon_commit_preps(new_probe, src_probe);
+		if (err)
+			return err;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

