Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69DB2C43602
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 223E16B00A3; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9B56B00A6; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D506B00A5; Sun,  5 Jul 2026 16:57:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA5906B00A5
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:57:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CF9E401B1
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
X-FDA: 84955934994.27.4300B8E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C1982120002
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lc3t1gDN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cq/lZgoqO37AZM/wd+VdC9Z5R6uQckVYXcY7Ow/7PI8=;
	b=jZXLgX35cbiCICb42lx7NgbAGvwrq6o+pTdTUKXZaKxz1W4+lI+SoKMBfW414Rbw5u/b1I
	Z3tRysEGCC1BAnVZCGcYf42kzpVBCaCeckpJtHl1NiRor5DreTcRHVOnFNVH5OAX9npE9o
	tUYIvEeOV8MKukJQEKBD7X9Wp8KP0es=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lc3t1gDN;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285075;
	b=RwPRdda7yNRfohNlcmB5Dfqc1ziTsqU9LI8RIqlNfS1nbARHTjbnM9pYNeNS5sd7Vrwbxn
	REqbQxOWDa+TVScUqaK07OhMFibhyvtsnyBorF766XutE/czls1N/R673MFTtldEMg+dJG
	+YjDWL7B/TWOHzhCCPrhv+ef1MSEZiE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 674A2600FC;
	Sun,  5 Jul 2026 20:57:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF001F00A3F;
	Sun,  5 Jul 2026 20:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285075;
	bh=cq/lZgoqO37AZM/wd+VdC9Z5R6uQckVYXcY7Ow/7PI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lc3t1gDNtfXoYZS3W+1hV7V78KeIb0Oo+qj2NIguCzvYm//NsMT0Y42liJ+hLlsnj
	 uW2Etkq33qYqrHkfAp85/Zi1ubHF7Qkdlk6u3shlrtVWBE/stJQdOWZ+az7s79rXz7
	 U5kakfVjN7LTvr2gaRKo+HkGzgHZ4peB3Bf/PoxQPRsVfUtH+gJUo/7SvyatbnBnwr
	 vizacExzYAYxTabWIMKBmgMxq7m99fwM6Q9Lveb3mfyhAXkdTvkpEnt4PtH0BTeZKL
	 zff+52ALIdIroPCCxTYiqh0Iv9I1z0pUnudjCy6SW6STw5so8/g24jnnq5YB220beM
	 j5+Lad2ZjYM2w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/16] mm/damon/core: implement damon_probe_hits_wsum()
Date: Sun,  5 Jul 2026 13:57:27 -0700
Message-ID: <20260705205743.98656-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C1982120002
X-Stat-Signature: fu37g5birwzaah3xa5o1g1ri4jdqrfwb
X-HE-Tag: 1783285075-333657
X-HE-Meta: U2FsdGVkX1/nfMBzy5vg8TPF1aUmy50RkZM3MUYJOWvgELGOvreIqFXXhPo4Hjsy64H3IjrgplSZB6i4w7aLMfpDhEmCIMH8sq5dNfgm4DhOWZplar6Yl6G2VoOiiO+9IVhvzr0Se21XoYGNeo5Ge7A1gE18hDZbx52a4+j6F8Vcz4WRSkbLy+Hyqj6WiKihCL/rsEtTFYM0DPl+BjyA6RQ2kjTvRGDgubTqqC3fkOaC8HeQ6PV2LDUsuZq0pkrQjLV27zut0pop2o/JoKroFdWyMNHEg/B7+a8bsdt1UyR/Wxa3OlAXQppNeCwYuXR7XT2Ki+OO73Bcx3y+1mP7xGGTBx1BRSXR9UqUKKIS1Qs6P6v4VjjkK+Ag7D3IPbECAGJWGxv0jKaM4WvX4v1jFCluPv8DTC0qEaLvIlhhBrYk+cSBhfqkUdaqbMvJ23nCQGryovUBYwtDyr7qZLgbr00Ut6jd4v0auQiKqty6CxY+9Ut45Kht8Z224kGOkTc/g8BCjWXbBZCb3vZOn2iI5vMd+3YK0nsax5cDIqaFxY4xPhDfbsWTc1eZm+aJVc7mXV0ppP1iTPVy8EE/jte1a66L+7up4xytkbpK0OKP/2suPgGuJEGv6nPMftNGpjWXnSbzYklH4U/FS+FffXoIERhhWM0kLnNf+EPOhbkLzM25tVv/KMJiYjJZBByeOhFHrJonduN4UXO5TsCSUE1h6DlEjPiuwvYO0QQzVW8EGtdxuTQN/FcmtP3/Jfd0tEeqK0g3uVTp2ejudG0JBVZEzaOQ5aw7Gd5hb1qJ2b8Dew9Isb/yip9/3q6YUPbMs0VHmucvHTB1UMVTX5TBotjvQT6bvBrhux/8WAWpA4Wo9add2czFVmCMLF9bVkXTkI62+3qi7AMA1T6T6NdGsZbpH/wUovsnDt/SLigmG02hWNsj0/NG6K7OQHsn3tBM/44KORgXqgUweGf82l42LEe
 3lq8Lp6g
 H2EDDRmawyyq/ptrGT7l2l62Reodu9urgJOSQ2v6FJKNOjOOOXl6Y96Q38S/uRl0WtPxaImZWo33ijaGzU6GUW93tPuCTvwv1QGd2xkxcIFMFDooDwdJ4iaNtOzlUa48dr6IE0kxXkhf52vlFAO5znRY/LS7cp9p8/fDvvyLxe3zM2SU5Cm5a6txsnlDcXFIijTEVPLRP2ERmTUbclopfm+8yTZZgNp9Ctl23Ykw8fR4F6gzHj2NaNKVnv9BuljTO8CwCrgJ9HcdiWO3Uw0kJU5U5LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When damon_probe->weight is set, the weighted sum of probe hits will be
useful.  It will be useful for not only the users but also DAMON
internal logics like regions merging.  Implement a function for
calculating it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 62caa67a3c40c..c43986a3aa16c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1011,6 +1011,8 @@ unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
 		struct damon_ctx *ctx);
 unsigned char damon_probe_hits_mvsum(int probe_idx, struct damon_region *r,
 		struct damon_ctx *ctx);
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index e42f512d87a11..d7d1e27d767eb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -390,6 +390,30 @@ static bool damon_is_last_region(struct damon_region *r,
 	return list_is_last(&r->list, &t->regions_list);
 }
 
+/**
+ * damon_probe_hits_wsum() - Returns probe hits weighted sum of a region.
+ * @r:		region to get the weigted sum of.
+ * @last:	if the request is for last-window agggregated probe hits.
+ * @ctx:	context of &r.
+ *
+ * Return: the weighted sum of probe hits of the region.
+ */
+unsigned int damon_probe_hits_wsum(struct damon_region *r, bool last,
+		struct damon_ctx *ctx)
+{
+	struct damon_probe *probe;
+	unsigned int sum = 0;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx) {
+		if (last)
+			sum += r->last_probe_hits[i++] * probe->weight;
+		else
+			sum += r->probe_hits[i++] * probe->weight;
+	}
+	return sum;
+}
+
 /*
  * Check whether a region is intersecting an address range
  *
-- 
2.47.3

