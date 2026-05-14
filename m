Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E875CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F33B56B0096; Thu, 14 May 2026 10:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBEB86B009D; Thu, 14 May 2026 10:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AA46B0096; Thu, 14 May 2026 10:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 962EA6B0096
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C42E91C04BD
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:22 +0000 (UTC)
X-FDA: 84766207764.21.33DDCCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id EA9F74000E
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APmAy3P3;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/RmMzGsPEN+DDqEiu+I0131qTGpfnpemsypj0s7iC5c=;
	b=3XQWSOST1S3DqaIusSYCFMc8n1In6c4fqjny8I0d5OamiiQwEXWmbwJ869WQKj2YLMq7yx
	Wi6W1bFZqoKuoCFYXhtf+maHwYggy/KXm+vONdqfwsxT2ghMUSjcOY0N9SgFES653xGME/
	JFsjzbDKQJCuqeUJ7w6VJkbi2EFHNEg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=APmAy3P3;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767761; a=rsa-sha256;
	cv=none;
	b=Za0YR5iyu7Dfsi5kPFrvGJ22d680aKO1MPpUyNtk9eXknHoX/QCMKVPMzcrUOLp18vQu1s
	5Bs40naLWKWv4xcX6T8fnx3CB9nGhP0/ESqTEyP9PG1NT+h7HBWkeKDYXY4XmCotb6I3LN
	anXTre6Twk6H1LPizYIYQXiB0Fa1Rh0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1522744444;
	Thu, 14 May 2026 14:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C46CBC2BCB3;
	Thu, 14 May 2026 14:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767760;
	bh=sqTfJo5eyZfIgPieldGgPDsesotOxkPfGODr6Semhvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=APmAy3P3zBWWFCtHrCjRInzPQ1wTdfZiuTcr4UgvclDr3G/3mLnO+A8yEQpSfp+Ln
	 aVSCANxtL7H/yq1Cpn8hD4qSvJwdYArBsVTmlP4pDQP1ROZ+T5zNoehnpJN2nYW678
	 6CidkqI4pJpO9JEOzFgdUJpmuChQQKHhXf5H4T9tBp/pSb27XThlF28DfQZrLl9ucE
	 HPMG545QEjaH9tVeBDwR5ojKnM0LNjudL47QTwh05ZF5lmKl1zBAuKDg1gGDTE0dgR
	 YlX2PDw1vAKRY+Asr5W+LREqIWXX6peVO4ruvKeLQVMccS33zyECscvz2KeFkk/U2L
	 oUk73SfHPQ0/A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 05/28] mm/damon/core: introduce damon_region->probe_hits
Date: Thu, 14 May 2026 07:08:38 -0700
Message-ID: <20260514140904.119781-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6ids6dn5ww8rft776byan6xnburr65w8
X-Rspamd-Queue-Id: EA9F74000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778767760-943957
X-HE-Meta: U2FsdGVkX1/hGCRlwsRKk3gA873PTngNhO43nAGbpo52zXZABqv6nJ/+ZfH1qE58oUVlHzOzwQ4CcK9bwGrnDvSLIb+ynLQEQlodJUL4aDotGL8Z8zeVUq/R+wRaA96duLc9iUJkGhvTlqF30qGRkjXK9UfXATfg/OgWeaA2i/ViXyiX0qsIJIlAqQm59XLSPgDUiPXwEO5jMLkjpY+ZJceUJbmXBGDBeQzfcTrhSJPUA7lYdt2q/pa9EBUI2XP23FBYoakYzmUKekS8bHI9aF+mCd2YZ8WkDgAX+Zc22Ag6Xx2ehTyexi3plDl+Ow0n8An2vHdykdI2uBz9U/uQ9C4xD8HMf54t5SitFb7E3BFbA9EAKueBl3EGhiyFyNsYQ/J9CApxPw6FXB4aEEsJmEc28Y653YwqyE2lHWbxw0llBYANEMP2bIQd6wRpdzPv6QlcAztQplHF/IyxaC1phFtdKAoNcfhua9Ql1h1ElRWYa977SD6Nk7YPtFb57OX1BkLaQ3Au1IOL144ODvanL5ZuCI7BkPsCqaLzqPzZyaFAvKEKLcS8z0+d16rO01h2bQQlDh4z3nvbNCEsGozsI+eV3u8oUhwPLo0R6oIHM+GIBB+5k8GUYBEnNwQ/S/kTFxqIfI39kj98TvuNDmD5TqSpy9K1X0chq9NC2bHh2cDZZJeDT56+AyYPx6TeyaSQicTZcjX4K9+yk9ByT6Gwz2tB8sgYA9bGRvwr3W0W3tIlgZsTj6Gp+FBnJQk41/MGLGWALsbPmL3ejNQaSjKwyszNArMM6/ZCKw1+9HuL/17pwE9acIh8oJOhLMOAU999AEf7XPTh+VqwUE7hxp+h6k1Nyb04psdRQm8Rxr4K3BEcx98Ujx218MPJyOP3EHdga9BEN+0mcd+PlacaXRWdwMJ21lam7sh1CfR6jcjASqtWUU8kNyK84zZhiyc0FEjg+OQru1AQ5GwdSOY6BDH
 P+VQ8cEn
 Pe1M/ch7GJP00sa2C2zpHveOV9NETSOvAur/IGM0JloGWlkqAp1hF2FWWZC4zdQxFEDbkvApdHw+GwHVeohVbuaARzVZ0VAu6Z09gqJRUY732gxYZlwvXuCV16HNX8Nmv5nPu5/go5Hr7Btfdd+uEqvkUJp7iUmGcPmDmXXT9Gixe5YwzAaMjbpuAPH35yq204b6pgOmb9u21k2ZgpNcusO5TaTBhaRmtte8gzj0ooYzn3UgNuh3Cwjqf8cJKKmgnS8HzqOhUqmod7jm68F/a/GxWWYoiLoDIj7MIlZrklmRwRs5vTls645qR4XbWMfcO5N0L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an array for the per-region per-probe positive samples count.  For
simple and efficient implementation, add a limit to the number of data
probes and set the array to support only the limited number of counters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 ++++
 mm/damon/core.c       | 3 +++
 2 files changed, 7 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 95b2c508a63ea..19b780bfab051 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -17,6 +17,8 @@
 
 /* Minimal region size.  Every damon_region is aligned by this. */
 #define DAMON_MIN_REGION_SZ	PAGE_SIZE
+/* Maximum number of monitoring probes. */
+#define DAMON_MAX_PROBES	(4)
 /* Max priority score for DAMON-based operation schemes */
 #define DAMOS_MAX_SCORE		(99)
 
@@ -47,6 +49,7 @@ struct damon_size_range {
  * @nr_accesses:	Access frequency of this region.
  * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
  *			each sampling interval.
+ * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
  *
@@ -75,6 +78,7 @@ struct damon_region {
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
 	unsigned int nr_accesses_bp;
+	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
 	unsigned int age;
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 240cae1420c12..72acdeb8c478e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -229,6 +229,7 @@ static void damon_verify_new_region(unsigned long start, unsigned long end)
 struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 {
 	struct damon_region *region;
+	int i;
 
 	damon_verify_new_region(start, end);
 	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
@@ -239,6 +240,8 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.end = end;
 	region->nr_accesses = 0;
 	region->nr_accesses_bp = 0;
+	for (i = 0; i < DAMON_MAX_PROBES; i++)
+		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
-- 
2.47.3

