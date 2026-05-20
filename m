Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3507CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 418856B009B; Wed, 20 May 2026 02:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 354436B009D; Wed, 20 May 2026 02:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A73B6B009E; Wed, 20 May 2026 02:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7CD46B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C414516021E
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:12 +0000 (UTC)
X-FDA: 84786820944.20.213EDA9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 179B140005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="blhZA/UH";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258551;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aYW2M5njFjCEQHIQ96ZTAgTiOW4IgJkF16+H3Etztlw=;
	b=pq95tE2hqmb8i2isJQqTXRhjjIbosplLpqcij96om+goFZesfD4gvnV1EEIBTiLeqWgxoi
	O3Pb/zKdEWjPsQqGJzscsJeIuJUPptyyk44HVKSjlvS2j5VCl32PQeZFS2ZtEU4I2aYF/r
	gG35QLSFo21R4zrdjX+KM8KhnS287qs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="blhZA/UH";
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258551; a=rsa-sha256;
	cv=none;
	b=1dW3cUf7TPSVNJZIM+1zBnZfQ8VaZfHjwPvwL5grU5Bvs4dpIlb+cmU3yXVrgp3/+BaB7H
	ym58W5AybLc8rf/EFxxSOOlFZpzuypWk4j/M46ib5JAI5qjNCC2L+Mb7omNu/SdyPdPZao
	Swi0+tCZZoIxrX3kwz5JBsLr7y8c+Q8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B738660210;
	Wed, 20 May 2026 06:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4217B1F00897;
	Wed, 20 May 2026 06:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258550;
	bh=aYW2M5njFjCEQHIQ96ZTAgTiOW4IgJkF16+H3Etztlw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=blhZA/UHUql9L31Ecqg4e2HfnW817burhArAW9gQ71ugq/krO+fEoTqn+hLfMSfC5
	 3VPXnPY0eckIIvFijgoaAsf/x/UXQCQVoiPScrnD+v8k1Qa0sbb9S0g4JwprszQH6o
	 9u3vprjEskZlYJL03unY07qCGZLAjJf5rH2bohGhza3Wn2nzaXcp5HyheNP6ePyDUI
	 obw9DDDPbrlU/UpHF/T8wiN+FcyWWd5UOCjcuetjDB2Q2KS5RSdLZHhKwGLRGJoCNI
	 tTy+HAc/XZpdDyWBAXFtUlqHFoeb+NgJuRmTkUgMN2eVtZa3npQkwteUwzk+C36D60
	 WR16KRDZj+zbA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/14] mm/damon/core: add kdamond_call() debug_sanity check
Date: Tue, 19 May 2026 23:28:40 -0700
Message-ID: <20260520062858.167011-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cn9cqrmt5ix1kuatu9etfxd5roqof13a
X-Rspamd-Queue-Id: 179B140005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779258550-768277
X-HE-Meta: U2FsdGVkX183+3RUkjl6eYPUuHx0GiZNNJxqAtL0aoRFRcq0dYeIx9g/HsjVBYrEMUF8wnbbIHYBZJm3K3DPQS6Bf7lMd3Mxdch8YbAJokrpytHpRX6xLXOz6VCdoaL9pptY8kS5ArE6MI1Am7l9WzoBVFYjno76Xrv8I6BfZx8/W1G1xB35I+5Oi6UpIwM4I++08Zg2zdiwh4S3YbSxq3O3Sx3hXzq7WPRP35n525UoPckcmwF7PI8K6FicCLUs/setzMPwOrrLHXWJpHF02vlMfB116q67LbII3Ue4EzL5UQvCMrj4U+EunGJd/BHWiCKzpmQuNk/SFJVTivnOTMT/yrbTb70raxdnSR7B9h0bkWwGRJ8F1R0b0q6oe5cgJLmaEVaAfDGwzAAjGPBX0epREDgfPg3bGw89ABUrDruPLzFos6Mgkvwnipsmb0rjsZGjJijUOvt80CthgfMnciu7yE7uv6F28iJ4R9t8cH+83/2/AF3pD+aNJGDEnzjJGJcNQ4QQ7exBo5gyjo9WUh0nbrrcyi+74oaOLJ30EGjiIiv9nfMoLOcLJlgRq5ajWNRQP/ucCMvmbjXtVcwuNgyTDOX+uj0RCa38Stfyj5RparKX034n7oY67gjfOsL/xGMAfsRhmLq/TxibMSOytM0m81TMHZevFak6ZG75BUuXPuXZ6HFgLIFT2WSyauZrqExf8l1W4q2RNZsbdW3xy7P0rHMdPI6Fx5Ze+Ql7F6zqdcVv+nrz6NkZu2ka2qN8PcV6nvpDU8emHhLkb7RuYoUldPdLLsPlHe/2Rxcdevdie5A5iiPBngEnvaqtrKiCmQtUGATUcPyxEH8lFGt9s1Z5NovwsrUW+ynGIAQpBJItWw/ZMZW7CVfn3GYstKHVwFVFq/Dj+4uroqGySSUyGxfPxbp6OBeXJh5Yv2H/fstVenjmNQUU6hyhdfjY8odYAH7Nn9PLODSngsC2wVU
 OMsuaJdO
 90JgQ3hdFbbIJFJqcsNmMiLisSmLGk6783qv8TSr5HC30m871Hyx/qXEDZDZ1zLoNyk0CTILPhJy1q7yVnX7tVOVzGuxiviWbbzWB9Abn1vXKBLa6uAdrBfKCGmoI3ld3YrUb0tHsn6NvKZKBv3nEX4BBbA9FeH97Enbdjggf7+TDELwd3JyDq3vxJskxruSwTnQ/1QIo4RMjjNs9bWXAW1UtiYxI2CpkjDsX9Eu5PEaE5uDuIV6kDCdtEBrxy0oElbe6qM2IEXeaokdrw9YmPdbxFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_call() is the place where DAMON API callers are allowed to
access the DAMON context's public internal state including the
monitoring results. Hence it is important to ensure it is called with
the expected DAMON context state.  Do the check under
DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 8a9202937781c..22327a23c7e57 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3331,6 +3331,37 @@ static void kdamond_usleep(unsigned long usecs)
 		usleep_range_idle(usecs, usecs + 1);
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+
+	damon_for_each_target(t, c) {
+		struct damon_region *prev_r = NULL;
+		unsigned int nr_regions = 0;
+
+		damon_for_each_region(r, t) {
+			WARN_ONCE(r->ar.start <= r->ar.end,
+					"region start (%lu) <= end (%lu)\n",
+					r->ar.start, r->ar.end);
+			WARN_ONCE(prev_r && prev_r->ar.end > r->ar.start,
+					"region overlap (%lu > %lu)\n",
+					prev_r->ar.end, r->ar.start);
+			prev_r = r;
+			nr_regions++;
+		}
+		WARN_ONCE(damon_nr_regions(t) != nr_regions,
+				"nr_regions mismatch: %u != %u\n",
+				damon_nr_regions(t), nr_regions);
+	}
+}
+#else
+static void damon_verify_ctx(struct damon_ctx *c)
+{
+}
+#endif
+
 /*
  * kdamond_call() - handle damon_call_control objects.
  * @ctx:	The &struct damon_ctx of the kdamond.
@@ -3346,6 +3377,8 @@ static void kdamond_call(struct damon_ctx *ctx, bool cancel)
 	struct damon_call_control *control, *next;
 	LIST_HEAD(controls);
 
+	damon_verify_ctx(ctx);
+
 	mutex_lock(&ctx->call_controls_lock);
 	list_splice_tail_init(&ctx->call_controls, &controls);
 	mutex_unlock(&ctx->call_controls_lock);
-- 
2.47.3

