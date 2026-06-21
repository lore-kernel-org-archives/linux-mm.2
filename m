Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62CCCD98F2
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 21:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1824A6B008A; Sun, 21 Jun 2026 17:42:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4236B008C; Sun, 21 Jun 2026 17:42:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6A26B0092; Sun, 21 Jun 2026 17:42:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BCE876B008A
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 17:42:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2CED3404E0
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:46 +0000 (UTC)
X-FDA: 84905244732.30.B141943
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9BF79140002
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:42:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZGpNdrg;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782078164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjSOxWy3PSIxUzStq8QVNZF0VBLkNihghY1tHfnbiPk=;
	b=incOEOVqRo8jTl1FgmoVgeC+GBchrW1r+iQmkbW17JKCmIycg+yQYueHVdNSjQavD/efyU
	NvkgPc8vnNhmwsxMg2kBF+fYAqy9VhI/rPxZ0G1fMdRuYFgf13QVeNAPD5iOxypqgTYVMw
	B3sI/V6EPuzVmGOOdbUCNYr2jxz5Jss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782078164;
	b=er/70JSIirgge5sKawWph8zAejmslJfjAGlr3+sEHOj40M52cppUKBVrxWScqQlWchvsOD
	wWG3WBAfVRaOz5Qx8+M4USQKRUlaI3R6Ru1A6mMhU8z0AOWEarYTQVoeUW6HBBCfXg71xY
	4zm47B/5eOOc8gkNLMPzQ7OPlUKSHis=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MZGpNdrg;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32B446001A;
	Sun, 21 Jun 2026 21:42:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FD11F00A3D;
	Sun, 21 Jun 2026 21:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782078163;
	bh=fjSOxWy3PSIxUzStq8QVNZF0VBLkNihghY1tHfnbiPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MZGpNdrgIMU2RMIZP+UzifZQc3BwsiTl0OCfN0IEQQppQ6OVYcRa5t/yIf3h7Vq86
	 DpKFiSjPxcvnhwbKNevow0an6AY44T1YKu/ObY/Tr+iK6rNWPRJuW986Mnq6OGCL9h
	 5lBUHzMWbH3kPtLLVIY0ZDBFO4zf16fTmNIKStpzuOT/bIhedWgjifuRA+/ux9Tgeg
	 DFSyYa1fZjjFcdxbP6DIufbc7+uHPOcjpeJtaswNoiGZbP9jBz3E+flvpOJfhCzI04
	 Oyaeg+zU6jQscrr3JSbdsqNa3dQb5blC5nULYm7jMi45gBhctNUBWQzqWc1KJ30vTV
	 f1SkXWI+1OUJA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/3] mm/damon: add damon_region->last_probe_hits
Date: Sun, 21 Jun 2026 14:42:28 -0700
Message-ID: <20260621214231.13449-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621214231.13449-1-sj@kernel.org>
References: <20260621214231.13449-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: n83f7tjngpuooyqbcskynj8k5qg3fo4o
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BF79140002
X-HE-Tag: 1782078164-312005
X-HE-Meta: U2FsdGVkX1/etuoi1k6Z6t4Bf7pq5v/kkykrQ17XD8f8Rnk06rqODJZAWzREZP1+TYpSFdzZDaY0TD3ojvcIM6usn/GLww0xXk4oBRzuiQe6IoJQs2FSjW2l9qDHDVs7IEbstsHPurMdw1tBmugltg21tYYYKmm5LYGuRgMDUd3MQqx7vP5T6z3jpzP/j0nzPsX4PYERg/dNUsbwiKP2wcGQk85TEbdREbz1ov8wnAUFka5LzZ3U/9GIzrf7OYifRMHLcFrkrtTeVJo44UlyANrknOkIs41dFxmcKqxBS4ECcLmWl09ud88rF8fY2d1ms5+6cvAUzkXQ1E8RS9AZuzK23ZFm7/PXd4FavHPqMBLR69D1Evv35WEaoGhWzZRmh26K/3aQjQGxjvO2ugExXz7PvrWLexS8p4JtFOmce7ZXlF5eY4sVhU3db+LtMP6R2TgQWI3XmW7odE7n8Wg+5MiWpyj2x7pQ41AvB/8vXpVDYIakhdfzZM1SA6mWQ2U3yC0Dgd7WRRDXoIX17vEmHU5Ma7KnMk/YX9mDz6Pl6c0eOvBiAfiw3PD0ufFe6wD6VSuWYAEV7WEs9q4JMqbdarza+tM526Vj56s2c5jvXbBRolLZ7pZSNUjg9sRGtA6L+cJiEPC5DKAnUK6qGck1TiLc9clzfLPZlwOUmCJlUf5HQ9U6rgiJeBlLcHaw0HUhMO4M6wCvEp87gdzQY4c5HdkJ3qfC5XqvXq8DSva1yNNxhaoUgxXlHru+vgxy1GmB3O0kl2y3vrT3ewCJfG3FLigmCTWoa+S9OuHubalU2FunepD+mM5ljlBEYxR0E8zwCECyYeQjfZdWoa6BvMjHFfC8XvY/qCw4UYAMDPG9U9bNjd/ayI73zjQgRKfdjLjpogL+X6qLLNjywvZ0SuX1WlPScTTlZWuKE2XlERL9Jnmq4VuxKM4v9g7SQq+wLbA4kaDwx9teyDVuNOnfFZg
 aF3J/5Cz
 Z0GiHOe9mM47fVJEp5IqT6pU9wGo1dYD2RfQ94XQpcgtCaC5XQEb7ZGP5uvCpnFcdNXKGUGPM7E8b0L3Ke/P+s3Tqe3kKMxMEJowKik+i26vyLEipXZiMHkNWB+LoEqtx+mMSBhseLNiwJEKfegtugyC6UgFeJ5+Sy/hijlZBdSCRlJq4ZvOkXWJJi389uBxE8BACW4se53zsc4W/UE/QQEaCTqSJc1nDWkcQ6lUNb/KfBEfFVykXSOIHmTJSvjaabN0J17AdHMqv+M76L4ZQICjC7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new damon_region filed, last_probe_hits.  Maintain fully accumulated
probe_hits values from the last aggregation interval in the field.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 +-
 mm/damon/core.c       | 10 ++++++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index fc3d467dc2e34..f0dd45ca788f5 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -70,10 +70,10 @@ struct damon_region {
 	unsigned int nr_accesses;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
-
 	unsigned int age;
 /* private: Internal value for age calculation. */
 	unsigned int last_nr_accesses;
+	unsigned char last_probe_hits[DAMON_MAX_PROBES];
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 4f7954b383d18..e84f2f1b07cc6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -304,8 +304,10 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	for (i = 0; i < DAMON_MAX_PROBES; i++)
+	for (i = 0; i < DAMON_MAX_PROBES; i++) {
 		region->probe_hits[i] = 0;
+		region->last_probe_hits[i] = 0;
+	}
 	INIT_LIST_HEAD(&region->list);
 
 	region->age = 0;
@@ -2024,8 +2026,10 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 					damon_nr_regions(t), nr_probes);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
-			for (i = 0; i < DAMON_MAX_PROBES; i++)
+			for (i = 0; i < DAMON_MAX_PROBES; i++) {
+				r->last_probe_hits[i] = r->probe_hits[i];
 				r->probe_hits[i] = 0;
+			}
 		}
 		ti++;
 	}
@@ -3216,6 +3220,8 @@ static void damon_split_region_at(struct damon_target *t,
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
+	memcpy(new->last_probe_hits, r->last_probe_hits,
+			sizeof(r->last_probe_hits));
 
 	damon_insert_region(new, r, damon_next_region(r), t);
 }
-- 
2.47.3

