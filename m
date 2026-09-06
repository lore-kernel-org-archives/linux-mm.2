Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4722C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 17:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF8C06B0092; Sun,  6 Sep 2026 13:50:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E33636B0096; Sun,  6 Sep 2026 13:50:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CACE46B0098; Sun,  6 Sep 2026 13:50:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3DF26B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 13:50:22 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A07F805A7
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:20 +0000 (UTC)
X-FDA: 85184076600.25.0462531
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0BFED40002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLwmxA+0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788717019;
	b=hiWktLkcaptZPY1ISgx5iX67rMH1xWElaQeTAkKroGNiO+vjCqVMbpeUTPdnvDnUUJHls8
	Hxc+L44+PEWCVQbE8hk0ap3GFxN71DxwA+cpHNqJcTb0P4hdWatSRuD2Aj8T+o/x6o2LR/
	JUhG01CsXl2pbKs7BxKkY1ObhCt+nbQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788717019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2EEU3ekWc3qyXmh8drgRUKtX2xzp7GdjGEtLM6CGh4Y=;
	b=BP41sgwMdSyHc9W9e0GN6tDLTKyakLU1idKBfT9UnU8A1ELUyo210rhzEYFtw8EjN4pesq
	NivSmxUg4bWsN80yx2XkLXdNpFzu5xljSni9MpgihFZQiBg62IO7JXth3svSQewDXp19B/
	E8X5guqoZRjeTFaKDQxTN11SZUvQ3qE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jLwmxA+0;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 536E542DDD;
	Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13C231F00ACA;
	Sun,  6 Sep 2026 17:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788717018;
	bh=2EEU3ekWc3qyXmh8drgRUKtX2xzp7GdjGEtLM6CGh4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jLwmxA+04ye3YGz0VBhemPW2m3i7srO/e5FLayoCNgdSE4uwwsDDD8JzkXkOGMoeO
	 8TkOYEqfSR0i9WcU4+Ec7NplPEQ9Wd4V4hfGzOra9ktb3/aGza9tGfOCGfI9OiTLUs
	 qTqwbHejvllNfb/fSbqG2zT2sYmyqZtmoBS1DGRb8sTFPlpoOyhjwOGehMOogvqjYk
	 mXIkOQkzy4oJFrCSTjvkkMDck24d0iEkmhX4FSzYrakSXFtz3FSFjBGVGf9qXAjW1v
	 EOxPe3WVikiUT65txO7SKZNxgrnfJ7oPTxhWFrTvjbH8SumATtFZrKtsw1JUSJ2y9z
	 m/xjoB9qRk+9g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/5] mm/damon/sysfs: support DAMON_FILTER_TYPE_PGIDLE_SET
Date: Sun,  6 Sep 2026 10:50:06 -0700
Message-ID: <20260906175009.93471-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906175009.93471-1-sj@kernel.org>
References: <20260906175009.93471-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0BFED40002
X-Stat-Signature: qn3t33w1mqjhr4f569y66m1xz6ctmryh
X-HE-Tag: 1788717018-924335
X-HE-Meta: U2FsdGVkX18aJEe3txsSVgiHGP8SpPKN/VijObSGGkoCcTLnITfBwEKHnWEkU5PWUem+6AUjkoDHkOT2Cnv+N8xtUboRKdtXqf0jbwhPcBnxABPJoP3ZzZ1BI7xABN6QHzdbRtVs3g9Clj00yxuWKx1ePetofYGFmJbIYJuq0RKOxFAtz+yux6TyQ0LhL1Hd5vQr8EKHU4YMzbl6TFHJWYaU0OrkICFj3pw5MgST90Tcaf/Z3GCvz47T3OBUjs1AdmbPCwIQqjXYGPDlflepUki2f3hyrw1JhQYT3MFXtGfrb3W8bhnmABQNW+PYROain1bZHxaTdzCnLQ7JSaPqYY/NAPblHpChDLJoKz/5FQkA8cFZe2U0OS+HfhwpN3xD6fKBPdU9xSe3ekEshWVxnl+sVWCE9/BBa7l2g/87RpxqJVtN8n+rkpeQNUkFOqnzom3C9L/fZzqzkxTS4+zkefruKfrMqt8k2O6Bfcq60TYw9AMH7ysXfnaNYhyPumK1pMXnObbgWA+afGPyO+UB2l/Wr4C68TK6uM/qKW0QOmXhitEfdLPzbu3Rm855BQwXjNHKWEHUkFSOpNqpmxYWdhfHce53s1i5U6UQS0jNOO2Ku7O4NGVxHauWeCTk+IFvGowS0s6MpI0PVOrxkk3xDEXThSjQB/+qXz33M0QeYDTtsGzCJAHavra6p7nCNcIKtUZ6/zMo4OVzyiVC3CH4jmHtfzlaLmwEZgJN3Z2HJOwoHM4V5V6LBmihyKDgVGWI14Yo0/TpoG924AtFOP7cMvxLfrWnNLVYbirjJzoCIQOFuFOLFCJO9lEkeD4hmSe6U/GgdbxKQWROAgM3HHterbaOEmWJzToFe5mFXd5OHEs2yZA1m4Q4ozgAXSDnSL3059CJsJKsCyD6Im7WdYGdkEAmkimwoTQjUVfdueZCtDpg+ciZ5iGzAsN84K18yqKh/6yWmH+FFV97NVc/I+j
 XGUip9a5
 qYA1FoPQiH8SM7HyR3Wwwh/NHvY5wHZfp+JasXmj9M13qzVrij0DG/8gbXMAZv1MTlrBK3He2OhvF+d4OrKMqP2Kkx1EF2viuHwbMJJRACzVJdFluf+aNmB2uCt+qnNi0poppwG0AOWjq8zb8YWU8RRHe7WTx5v3WJB7OMJ4/zhHyxRM72PpgQGZQBfrgZ5iDK3Clo7pxRYH526qSLN97zZCTDr3LpXch7SXNuM5346DHRwpQRaXKZJk3U2xHPqe42Xnp198Qd9gUyDLM7jRI9LC9Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON sysfs interface to let users setup
DAMON_FILTER_TYPE_PGIDLE_SET probe filter.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index b576e97cbfdb8..51fa506c879b0 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1001,6 +1001,10 @@ damon_sysfs_filter_type_names[] = {
 		.type = DAMON_FILTER_TYPE_PGIDLE_UNSET,
 		.name = "pgidle_unset",
 	},
+	{
+		.type = DAMON_FILTER_TYPE_PGIDLE_SET,
+		.name = "pgidle_set",
+	},
 };
 
 static ssize_t type_show(struct kobject *kobj,
-- 
2.47.3

