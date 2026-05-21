Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD5CCD5BAC
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7236B00C3; Thu, 21 May 2026 10:34:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598976B00C4; Thu, 21 May 2026 10:34:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4180F6B00C6; Thu, 21 May 2026 10:34:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2109F6B00C4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6CD4120651
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
X-FDA: 84791673162.29.A267C86
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C82B12000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IS64a2PH;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwOzNgtGbmRdNv9xvtTz1sguHFhxD3l9rWcheeXYL1w=;
	b=wxwi81Enx1YqZQN6cKr5pMCl37CH9hj7jJ3ejFLWmAmFfqrO5hzChDQAZ625VwN0b0Dq3P
	pV9C3Rp3iApPUVV3hko2C7WkxyyohWop57xZcIGBJjhAVBXzqa1qpp5NwS6d/E/MD+i5+o
	poxJB8bGmhdCJt8US07zlZa6TLDPLwo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374080; a=rsa-sha256;
	cv=none;
	b=inF3lEINo4119RvqyZD6kyNp87CYsCIDPBPUyxQjxUeWRI1KxFl9gYa5E8KolGp28HZRYw
	cHQLz+mikuVRgSRtboFp1LoVgzbWqZcIHqJLCiIKn8Yc/zwaccT2BkUErltCuXsuS3lHa1
	OgoH3M4ijyiZ8+dODzOJ13NLMaFdoz4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IS64a2PH;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D452E60212;
	Thu, 21 May 2026 14:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 669551F00A3B;
	Thu, 21 May 2026 14:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374079;
	bh=NwOzNgtGbmRdNv9xvtTz1sguHFhxD3l9rWcheeXYL1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IS64a2PH6/REiXHI6VNWirE2NqkzSzWCIc4tb38kavuiH/RK+OTzAUFs9X47En1pW
	 yss1y5NSvZ2aY9tVyugrwCUaqEJXgncShSlYeAjr89Num+YAtjAI3Tu3QSr7fVu4tU
	 LqlFycjyRjV/LN9pgJUBq2RFCr7GvXJsToq/+YiOdEE6waCeQ7yHGxjUotCSptL/St
	 Vx/Oan14SPL1BAIBxQxuQ1Jmib3P0zydUZRp6+abIUMyL/iUSk/v6XNjrFmee6cZ2x
	 SejYA7L8VWeZfe08W/kCipDCvMnNOkbcmiV8m2rlteX4DwXd0myXgfgtd5zW8MXsdl
	 Pc0R2JMLoc4+g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 06/14] mm/damon/core: hide damon_insert_region()
Date: Thu, 21 May 2026 07:34:16 -0700
Message-ID: <20260521143428.83157-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C82B12000C
X-Stat-Signature: nakfneieh3z3o4hrnsicpx3hp7yffqng
X-Rspamd-Server: rspam06
X-HE-Tag: 1779374080-336809
X-HE-Meta: U2FsdGVkX187HgpO6gMEH+F0DmATjhElDlhA3FFmtZFTWA0cP0+CUA6fmm46aI64fV43i9+bZT4caY/dKjrEzupEtDEB7RK4ipGX5pgrsU+gXW6aYpwArE2ywcihfazoSGRn467CTvHRoOsaQ24YmAZFignPMAeH9AkvHWJrrAI+w65KCqYUNstKKWHnJ3vtnoL3NcHu7NcT4X2gSr/4RDywt3slakS3Q36xyKzeRauftTUXJ1oz6gauGNu0K0VH/2/KB/J733UDmJtqPeNVSnFsXX2drRdjahpzFwllt5HLQsOthxNRGbL8hVg/hWh5LPdNLSWsMb/peIu1MZUw39/Al1nmbRzTtSbytj+v1jewckv7IQGwdWGjJ4TxGWUic0bV8uDSmUDBpcQYm8TxqfVrZq+uHCVLqu9Fc4zq//Xc+oJ4pOpgQRJr/HN+R1I+9axk1kdlv2tCWi8J/wQbzZXplD5RkqJgLuu6AOjxofzngZ5fE8lCjM9tqFbQLjlH5SxLvgUlIlMHqBZuB0NmT2aytkEQTvlElWRZdMJVb1uyxvbeEUGzR8SAkwLnnCtG4IktszQKvW63P9gDmRZE37gWTnYDbmzskYV+qRRwvP3Uf4G7VqL7ORMd7kiKb+wmLKKYKporxuvQ4hybRDmSQn7djkwgIuksz0OouQG8OzAD9cY1RVB0TyGzCSBydpMMdhE/JnIR1rVvA1CL3yHd9K2W65GN4MG1LCczmOgAVrfaoJbc9pbvi0qHFVfCl7V7Xa4D+FKn3wHkpc3alQhq/Xv6l5/aiY2bUP4PKUSbaF7n2nO900Y4VE1L2WtqXSc3RGORg/em4M1mQotP2/PIPI/QG67kNZNzsJS0KWJw30FoFLk5/g2jNlmKdPFUmuNnkseU5hVkbv7L6cmx2bMFBAXV/X20wbKFdsLfuyXhFyA1ps0I6njir6imTjjtLUjQnxPzcee4FE37rLi178P
 xc6wsiQ8
 F+eJ4RITLayk/KZrQVNZ5h5N/8aT9uX63iQ5k0P665mLx0vl8snSjn7fzPIOjlztYIcZHgrxR6NecNf1VKDMM7VqKMCsY2wWThjw9mUZzYJfFqeLTTXPmzk1++dPlbZGsRNwKDOsQKVimeAuZbJodG8WP+SQX9JcpL7CeQr/R2wUYuHDnrWdnBCyHfwDmbXOkO9b7wwIoDCdAYjRZ/RD6zwYN2oT0XJMS3Fr88k8b3J1NAZcMKKrBt3M6rCqypZ0iHzFz2F115Z48A49JfKXhyOXFDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_insert_region() is being used by only DAMON core, but exposed to
DAMON API callers.  Exposing something that is not really being used by
others will only increase the maintenance cost.  Hide it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 11 -----------
 mm/damon/core.c       | 11 +++++++++++
 2 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b9370c1779cba..3acca7deb1693 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,17 +1013,6 @@ void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
 
-/*
- * Add a region between two other regions
- */
-static inline void damon_insert_region(struct damon_region *r,
-		struct damon_region *prev, struct damon_region *next,
-		struct damon_target *t)
-{
-	__list_add(&r->list, &prev->list, &next->list);
-	t->nr_regions++;
-}
-
 void damon_destroy_region(struct damon_region *r, struct damon_target *t);
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7d1de6ff54eba..53b4bdd27b39d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -256,6 +256,17 @@ static void damon_add_region(struct damon_region *r, struct damon_target *t)
 	t->nr_regions++;
 }
 
+/*
+ * Add a region between two other regions
+ */
+static inline void damon_insert_region(struct damon_region *r,
+		struct damon_region *prev, struct damon_region *next,
+		struct damon_target *t)
+{
+	__list_add(&r->list, &prev->list, &next->list);
+	t->nr_regions++;
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_del_region(struct damon_target *t)
 {
-- 
2.47.3

