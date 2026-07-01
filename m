Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 778E2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:48:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E33856B00B8; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3226B00B9; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF91C6B00BA; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABA036B00B8
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:48:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 50EF61C723A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:27 +0000 (UTC)
X-FDA: 84940488654.09.2A75DD4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id AD54B80016
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTrbqQ0j;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782917305;
	b=Tm/ShXnm9/jY+9Kp/IJ1C7KdBQZqekchKLQ3TjzMFtmKr/jSQ5Oxa2kFb57GxDidMfu3Ay
	TIFBDTWtc8SMqnJW25PylFiWEo/lMhhvMt7NLIXLuPvx97icSMkANvhTyYXvocm56p14OF
	N5TfQlq9WloRYGppb3PuVRGRMNN4/Bg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782917305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkKbN8JT013PFC22cFEAzBpDHHTSG1t3VeAW4U+gBVo=;
	b=iuWEeZWJ81WYqVlavrZQ2JZKpLSQ7IKZOM5lGuT6/3RL8g73lJHVuXBIVZAeHa3dGgoZA0
	S3hnzf6yLM6P8pNNtusUkQJNuArUfhaZmkzyga8FFajLoQeuo6IALa8wbPW3feXkjEf1jY
	keIqTX4Oq29UVPuSAWMIwfHrI8f+XlQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lTrbqQ0j;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 41863601DE;
	Wed,  1 Jul 2026 14:48:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6D0A1F00A3A;
	Wed,  1 Jul 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782917305;
	bh=QkKbN8JT013PFC22cFEAzBpDHHTSG1t3VeAW4U+gBVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lTrbqQ0jrniuvVaZzyOK3vdvPOT3SRcyfKFnltmDJns3tib9ZjPxDn37q76QCETH/
	 jAaO3CcN/ZtyhOlO/WoN9lC7yI2whBEGhXWMqLNQLi5GrmsKU5FYLZ8fsi0IgBhlMg
	 oGDUesv4iD0ixBlDnHqil4ba7XN7MWeRhR85NellhG6BqDfRgYFtoVJyJMwpB7hZ52
	 JmWZfG1IxUqx3wpHo0EZszqiYvPdLlTwk1f5USSNshL3LmVNOisGyr2dbT8ol92UYA
	 grgIrquocVLpzvfSbtTLEOAtkRi+gi9qrnOe1w0GeWB7BSW8fSyj8dQ+piwcfIxqyl
	 nK8JAr2jjhKCg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/8] mm/damon/core: safely validate src on damon_commit_ctx()
Date: Wed,  1 Jul 2026 07:48:03 -0700
Message-ID: <20260701144815.113325-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260701144815.113325-1-sj@kernel.org>
References: <20260701144815.113325-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD54B80016
X-Stat-Signature: mjwa93fn7jwsccrtbgi1s5oxi9fkdu8m
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782917305-446338
X-HE-Meta: U2FsdGVkX19hEl+peHoTK6oeVBSTHbSmTwXHp45QEGCEKoyeiaFvwBF7zpAPfjQx9HDRd+VvUKGxSDHjdqdGwKqvZL3RoMSUcKXtJniltjimCUHatW8Te7FEI5dDRd5Exb6FQyVHB54TEisk7ZuWc8yK/hqES0mqoD+OHxp+PpfycS7neIyxgszRlqrXNjXx0rbNJ+d6AmWQhvr1SthfkfR8L+ASMsXABhTKgX06K8YYP2KvKgQXgvXtC9qmaJUjDs/hfHqaFKV3XDZHGf979U4YhsHpSOn8Kbko+WsBXDU2m4lkSc23wxDI9AgwHgGY4rmdFKOwmkdIygt7WFl8cZmdukrxgtgeuixumJ2/WL8hENNxkaKjcisINpLOqk4bCvh8OBejVwFkPCO6+QPDTbpCvcp0AWzeSkTwkEngdcScL/TJMCamQvuU6F+HATzzLwGfLxBc8IFtIKGLEOqlmctFxZpynN0SqrGMH05XJWoX0BfLGTsYB5n4n6+IbbbhjghrI8NnwoAPc2wAiK03DnpSmvJ4VFhsPtQu1kbWH/6R3Hp0IKkBzElc3V31ij7L0BWDXzU1fRu/V2dizT/+eSjiL/1V0nVXhNNOgTLsaiy03RAqThGYapEQmcAIHtWPelQovdn0X5b7s4CMP15NGAA7bYqt+1WeAoOkRZNpNMADWqBezUir87yF0hXHU4vcIy1eRCiLZ4Fac0WYdX9lv4dAK6x0bswHh5E00Q7qag6HF5Lfn8/e6g55rApZX8PQC1Hxq/CxwL6hihIFjMI1/2m3aaMCQgpM2S0QLSX6+jB51TlA8VK3dpstwuo7GIzBUlIgxUCtKVedqUcaa2HOCJ/hrTYwCgLXpUcg0ZhgeoPMpn+08zpT8aTSER/XNuR1074447EJWLlfCzzp6y7XaoVtSKRUz61zJ1sErYwDSQ9tZdJw55hoHCwuca0oK33wPofGnQfOdVMdaSNCey9
 5Knvxcwx
 4Ao+CoWPm1BII9gY0M4nIlEj2nJQmmx2AfkUE/2bs3Ic9qTl20qtWActGOcg//QgyRuxFJNPXaTBezuNGZxRfat5xhaUQsRZ/qVCU7a8QxaSQMr73qkH0rCJkjyldMY5CrfRE9B5c5scEOu9AErc0DRV3ioAWKAAICaC38D7/CjRYS2qJnUl96pLbUThjfYeMWJ/1R+oHXWTj/rP6PYrn3o+jFZw2hMZEdmfC7PTukvBMa4ap+VZtU2D8fYGTexu3r1EoXljtMseagM+4jj8ZePlEMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_ctx() does its holistic parameter set validation while
applying the new parameter in the set one by one.  If it finds a
parameter is invalid, because some invalid parameters may already be
committed (it is called "commit" but not atomic and irreversable), it
stops the running DAMON context.

The callers of the function therefore have to validate the parameters
before calling it.  Because the function already embeds holistic
validation, DAMON_SYSFS reuses it in a safe way.  It creates a
test-purpose context that is not running but mimics the running one, and
calls damon_commit_ctx() against the test purpose context.  If it
succeeds, the parameters are considered valid, and a real
damon_commit_ctx() call against the running context is made with those.

Other callers such as DAMON_RECLAIM and DAMON_LRU_SORT do not expose
full parameters to users.  For efficiency, they validate only the known
set of parameters.  The efficiency gain is arguably small and doubtful,
though.  Meanwhile the maintenance overhead of the multiple different
validations is clearly high.  We actually found and fixed a few bugs in
the class.

Update damon_commit_ctx() to embed DAMON_SYSFS' safe and holistic
validation approach.  Callers can simply call damon_commit_ctx() without
worrying if their parameters are invalid.

Note that damon_commit_ctx() can still cause an unexpected stop of the
running context, if internal memory allocation fails.  It is arguably
unlikely since those internal allocations are too small to fail, but
theoretically possible.  It should also be better addressed, but not
necessarily a blocker of this small and incremental improvement effort.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 61 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 871c6f5257c9e..62c27002219cd 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1664,20 +1664,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	return 0;
 }
 
-/**
- * damon_commit_ctx() - Commit parameters of a DAMON context to another.
- * @dst:	The commit destination DAMON context.
- * @src:	The commit source DAMON context.
- *
- * This function copies user-specified parameters from @src to @dst and update
- * the internal status and results accordingly.  Users should use this function
- * for context-level parameters update of running context, instead of manual
- * in-place updates.
- *
- * This function should be called from parameters-update safe context, like
- * damon_call().
- */
-int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+static int __damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 {
 	int err;
 	struct damos *scheme;
@@ -1732,6 +1719,52 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	return 0;
 }
 
+static struct damon_ctx *damon_new_test_ctx(struct damon_ctx *dst)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_ctx();
+	if (!test_ctx)
+		return NULL;
+	err = __damon_commit_ctx(test_ctx, dst);
+	if (err) {
+		damon_destroy_ctx(test_ctx);
+		return NULL;
+	}
+	return test_ctx;
+}
+
+/**
+ * damon_commit_ctx() - Commit parameters of a DAMON context to another.
+ * @dst:	The commit destination DAMON context.
+ * @src:	The commit source DAMON context.
+ *
+ * This function copies user-specified parameters from @src to @dst and update
+ * the internal status and results accordingly.  Users should use this function
+ * for context-level parameters update of running context, instead of manual
+ * in-place updates.
+ *
+ * This function should be called from parameters-update safe context, like
+ * damon_call().
+ */
+int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
+{
+	struct damon_ctx *test_ctx;
+	int err;
+
+	test_ctx = damon_new_test_ctx(dst);
+	if (!test_ctx)
+		return -ENOMEM;
+	err = __damon_commit_ctx(test_ctx, dst);
+	if (err)
+		goto out;
+	err = __damon_commit_ctx(dst, src);
+out:
+	damon_destroy_ctx(test_ctx);
+	return err;
+}
+
 /**
  * damon_nr_running_ctxs() - Return number of currently running contexts.
  */
-- 
2.47.3

