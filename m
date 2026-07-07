Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32116C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F0E56B00A2; Tue,  7 Jul 2026 00:39:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250056B00A3; Tue,  7 Jul 2026 00:39:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9126B00A4; Tue,  7 Jul 2026 00:39:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DE9C26B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:39:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DD941C1844
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:08 +0000 (UTC)
X-FDA: 84960725976.28.6B2BE03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE91B100004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvvPYXoH;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y2nS4ty/xjd06Q+OF1q+BaFHGwsWJWpLHsAguRnNOTk=;
	b=ebOvavpQ+gjEUQuDTTBbiG4bWgWogpq3PcIZ1AQRJlHktqFcZnXoQFGRFF6v0jzhiYZfpl
	RtwrslepfFsEQZCkKQgdpmadKW2Xg5onl3QkqpwMfbG6HZTtY5bd8kpZ+T0ubq0/lLUx+l
	LCh2XTdI+RtMg3u/Vz9604EyKXr+14U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WvvPYXoH;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399146;
	b=rWrnpVtv2xJ0Nq6HTHOpawzhhQ5DtJi7fG1hbiYFg6db9HCs2zAgBOBZtHQvDspC4mFDEG
	uIRx+NLVXJJ+Vz5SwfQkGuj8j0XUdNJD2MfFK/Ha2PfPfAhsdEYULQsbJPvYC/5I/9hhd3
	vrR0KSsrTzAbhILw5Rybx8D3RLbDRPU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 75EDA618A7;
	Tue,  7 Jul 2026 04:39:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0EC21F00A3A;
	Tue,  7 Jul 2026 04:39:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399146;
	bh=y2nS4ty/xjd06Q+OF1q+BaFHGwsWJWpLHsAguRnNOTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvvPYXoHwGLaMwU/YDDfvMgJnz2YbmwsK/bjmEGclsQa3iY3bRjKfo8TVWQcGUfQK
	 N7ftzC8QZfaV6/L9blemJObEPZhrfA1q2ipR1eXVGAAoDFvUFi1PZFD4hnHSQqhKdG
	 P6mYRbYmdg9iP8WC/iBRgG3auxwurNIkaDTvqC1lhRu76TJWEUW85Cx/YDnOy8HP2x
	 kMk5eXyui20Ml2kjj6hU8nEfBVn5jxe0Wz0D7qrjVymBXASvjcvJJ9RDscO073r5gW
	 aKwKRorR89NeWU7fztVXfV1/S2QZy+yU6tV7w0E4uLobm+00wyuwwUrBK56t7j9wOP
	 /Bw2NYGGrjURw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/6] mm/damon/core: s/nr_accesses_for_new_attrs/nr_samples_for_new_attrs/
Date: Mon,  6 Jul 2026 21:38:24 -0700
Message-ID: <20260707043828.97900-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707043828.97900-1-sj@kernel.org>
References: <20260707043828.97900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rod8a3qnddm7jmqm9fts7kx8xswe3rc8
X-Rspamd-Queue-Id: CE91B100004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783399146-871941
X-HE-Meta: U2FsdGVkX18wmSa/+FxlTgdZ3QLwGQwwjv6SSJHm6Pqq5w4s3guyERhR4pA0XVEA0EEtS5pXwCtI0T+OvM06YsjXMwc/07H72HKYhX2xdrnuCHE8rBJraX+IcES2ser6rp/occzkUpkYjjQ/ZSO5fbryHBj52M4GC5w7jxOan5eWYczu7mMpuxJJG2BwB7CELTbwki5s0p2//YiKJubRAkLvwIalYj2RoJSgo7gfgvjVFNEx5UK+WDMV64angKAHMXi8TFTunNDQwxOQuTovcgxbpBIaJrGvn+l+QlppdKXy0sLV0YGgSt4znaLnOE+4FIQQ7yCZbqFOkeMrIFm7ufa+hi7Z4piRNHRLiAU43VJJO+zUkJL0Ip9HFSwXkOjyr9boGCy+FHtWKBizIqKvl4u71rDwMQruTT6uf8QTbpUz/uZAVOfgmjFUlLgIeoRsYEhRjev22RLN4IE4rpEuCeoCdDMBbUl6nMwqEl44IJn41/f9xoDxYw76GmaiCUQnK4TGOGXgfXjrsYpOY0fmLIaLCpvUpHqbsq86zT7R5pxUGJX8NLkM74hk3ABgDAfWYKs3Gpx/U2QZEX62J9Ci/K3R4JySmQB0LANuNk73ldMSGXAD+4hr2uRs3E6BWdskd4bj56yZO7hHxZHh3P4zlkD9ipqPpDofkk5b2pHX7Ya1gb1tDAJ4slm5k+oHzVILgHQxi1UwFAN2q00iBRDrkRX1krX8Vd96RymiYXrtq7RtL7k9tNJNYmMhoTAjIHOzTJvL3DtnHJ1uf8TbhQLcuPUyJqazO38OwwAH4n1YkBhAPp0sNdU3Bz5evzMK4kVNNz1e+NG6ClBH6nFSdOThkjm2y7b/rPLrHTtEidI7zQGSe1q5s9n2s/Inw1mFUjU95QXADyTsMXmRO1N1sXYVDYg1vI7xE4NTL31eXzqS+d5Dq7GiMO93IZKjZfGdnXCxkPQyIYpYgHe/NKLI96U
 zdiyJxm/
 J7uPtJ3UZqXlJZnXXhIWWCz3lIyO2wjj9M+8oEnPnbPpqQQA6CrdYSvY52kfL+uz06QR5O3rAxgH2WWpt8tHVC3NhKbaLWgNAAm/UGyAgITUqNa52uWlgAMFP7Iw7dIB9QEmumYM7YmYtprqVWuZ3ZNznaVgZDEPqGPvtjWR6Y0tZq4CQiiEegO9C8kRvPdFO1SlUpXyWuXnYu+nOhWSochw2oS0I/GQmQcvQexCltjBXOCodpIFsvgMuFlQyq55Y1D3CgBx7GOV4Y/J7yj05vUs9vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_nr_accesses_for_new_attrs() can be used for not only nr_accesses
but also any positive sample count, like probe_hits.  Rename to be able
to be used for such general uses without confusion.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 718268df27fa7..cda318806b65b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -890,7 +890,7 @@ static unsigned int damon_sample_count_to_bp(
 	return mult_frac(count, 10000, damon_nr_samples_per_aggr(attrs));
 }
 
-static unsigned int damon_nr_accesses_for_new_attrs(unsigned int nr_accesses,
+static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr_accesses,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs)
 {
 	return damon_sample_bp_to_count(
@@ -902,10 +902,10 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
-	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
-		r->nr_accesses = damon_nr_accesses_for_new_attrs(
+		r->nr_accesses = damon_nr_samples_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
 	else
 		/*
-- 
2.47.3

