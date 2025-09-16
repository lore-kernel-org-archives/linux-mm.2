Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2CFFCAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 065888E0018; Mon, 15 Sep 2025 23:35:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 015C58E0001; Mon, 15 Sep 2025 23:35:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94BF8E0018; Mon, 15 Sep 2025 23:35:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D58808E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 952C2872AE
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:20 +0000 (UTC)
X-FDA: 83893698000.22.64241FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E297240004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5leU4h2;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pF37WQ3YnPviY8OvWwzVjAjFYLnu3kN+Ilv2NNlENTs=;
	b=M+YSLPY09t05FwHKmdEqiqRV86h4ntmuwYTEDQ4A/wOrY6a8Z0hkwuCU3dDudI0GtzumwE
	SnkXI1KDnPq0LP4wQ2zdodT4iBnVSN4GQpDnsIvIUc7SeikUU+lbHIkL1BU8CjbOMWwd+z
	4ZVrXHr7ctWf3kYSaKREGdLzM+tnSb8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993719; a=rsa-sha256;
	cv=none;
	b=2HpYv09WwV0ScGEhWumFG1kSx295RZ6JuHvCGYGCNH2vAdXuAAeABlIHDUbOOSRrXBDLsB
	3uWU+YBwwcRjLWNIJiz5BajWEO7fZeLUbRLAma1zRW5Mi98vazjWjamZAUKg0pjpQhnMJp
	dFD5VOQnSubvwhOd9cSkPfNIftuCHCQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m5leU4h2;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07AEB443DF;
	Tue, 16 Sep 2025 03:35:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2DA3C4CEF9;
	Tue, 16 Sep 2025 03:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993717;
	bh=9JcNBf3R6YvBmotNSylUCQN1TyYW4gyunQci2uE4WFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5leU4h24iIaQ6mZznhs9PW6jvp8aW8gZKhwvsdZb92V5iSdWE4qTRHkBXPc3DSlN
	 zf8/lD+fNNViNqCKK93TyvvbwHLPBUJF3+Gc3SzYGR1EY/n7VxH2Mkd5qsJseb5d3X
	 cy2kjGjooVQEZx/AMAxwPeysfx1rdiKEvykqzJ8jXW8euso5Q4uuqD+d919dr+HXZ8
	 dvntW0cZb1QExRthOwA6JBaPgI0uwI82JcchB/nd5BYH/Q7AMBkkmACjfcAA48toSF
	 Z/+/OaQ+E2AB0j661UN20M8C9o/mtPmEMy/PF+j5A4Jf60ut8zTIiRKvOmqMet24Tv
	 fBPY6Stm1IdMQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/7] mm/damon/core: implement damon_initialized() function
Date: Mon, 15 Sep 2025 20:35:05 -0700
Message-Id: <20250916033511.116366-2-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uajj9eugm5jfu6tsw47ra9eiahx8m716
X-Rspamd-Queue-Id: E297240004
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757993718-819278
X-HE-Meta: U2FsdGVkX189A1M0Y17sxxMu0CDoqG12F5YfnkhE5r0ge3QIAB45ZRXG1HfkdnwhDDKZvlaEH2MgtHTX687jqJyeGf86xF3aES4HVpbIQo3iODpCAfXAbhV5js0i7WvmKUh+ejv/Ci3SN0elSR5vCj4TFUFNyl+Rhe5IYu0+FWSezGopJ1EJXMLbYj9Y24jpZSs9jUioJBol2/2uQwnQ+ajHVsxoeGDbX84mnSnq/q/YOjppqwVOtenttmY73XLCYU3LBu0X0dLTBPtilsw3NIkCsYRvERUCBKvl4AfjM8+bwpzV8Kc2ydbm8G9bjDytc8wFYX3bbzfZh9EDZSLJqCl/NT7Z81XlRBPZxQIK3VnrY71Gr9dfYoNQzs1hLbKAsAPLkquDGXlgwswYd59GdyrHQWTz/QROQ2WZnPnnTTYjYIKcvy0Ev7hgBa8DuLOyB2cnQEKeYkgV4jtT3RBbRaM+eYx91cVihcV75+9mqzDcGXom5PNeW/VB46cCo8h5j9jZZjny+BSdhjNEx87fEGiR7azXi3ZEDKhVKYmZMfo8sMthuZwMQjPjNBsPzuQp3PIHd1K7rDerhwIO8Fk01XNXgZywbDe+nQ4BbSUA9BIoHD24dL5jNOr+UJYub8lqqaO1Xv/GNTW71X48LHvu7eAMJHWGdcPBynqJwhswmru8WkWKEjB27j8qtjtbzgzwXRSPaITgv7m+poWMwE2nz82Xzq15Og3DH233fJTzYkFr46Lzt0jRdy3NQBZNsvv7zEsqV3xzex6832EkZdMBIizcxLL8Mjnodf2JBxpLeiE/k3AyA2iulwiz2V89PqZdh5J0Y6lbaP/iMq54fblvCxFc4qVES87n3Jcex65yHIKEEMKZhHBJuWWa3XAVEClRibiUUQbKHV3yW3bn52/fPYLYTJcNbprMGvwMtNS4FezU4mxuLoA/abFMZmbSj/5TgdIOijB/looOwirEjda
 D/F6f9FU
 z5/yXXThrsiwOznKRWj44R40lxHmqa3/To16pL+u7aD8O09JslQYu79G18eBsuBh7sQpDeut4pblxz8HMGcxjSt+IcsvuCkIIyNPxsZop/+zELh0/T/8VJroJ2f/RIYMzfWMbPhIF+aSB6/I77VVHRdA+iVKMFi3Zo71MbZgIxq/vFXvL/OsxhZlPdv5amZwflg08hbkdj6tZNg180bWHGYHaDYQGaUPKzzb4AU+UTGHnbMSIRpduiyck4Bl7Q5a6iS1/FTgnv3Atay4QY+iAYwkvBE+le70K8dqlyzYE1wqUZCQwRZP4vCFw8w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If DAMON is tried to be used when it is not yet successfully
initialized, the caller could be crashed.  DAMON core layer is not
providing a reliable way to see if it is successfully initialized and
therefore ready to be used, though.  As a result, DAMON API callers are
implementing their own hacks to see it.  The hacks simply assume DAMON
should be ready on module init time.  It is not reliable as DAMON
initialization can indeed fail if KMEM_CACHE() fails, and difficult to
maintain as those are duplicates.  Implement a core layer API function
for better reliability and maintainability to replace the hacks with
followup commits.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 10 ++++++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index aa7381be388c..cae8c613c5fc 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -938,6 +938,7 @@ static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs
 }
 
 
+bool damon_initialized(void);
 int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive);
 int damon_stop(struct damon_ctx **ctxs, int nr_ctxs);
 bool damon_is_running(struct damon_ctx *ctx);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 775121ae7a9b..93848b4c6944 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2863,6 +2863,16 @@ void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		r->nr_accesses++;
 }
 
+/**
+ * damon_initialized() - Return if DAMON is ready to be used.
+ *
+ * Return: true if DAMON is ready to be used, false otherwise.
+ */
+bool damon_initialized(void)
+{
+	return damon_region_cache != NULL;
+}
+
 static int __init damon_init(void)
 {
 	damon_region_cache = KMEM_CACHE(damon_region, 0);
-- 
2.39.5

