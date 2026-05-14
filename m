Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0992CD4851
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 14:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BBFD6B00AF; Thu, 14 May 2026 10:09:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E6876B00B2; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1726B00AE; Thu, 14 May 2026 10:09:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 172646B00B1
	for <linux-mm@kvack.org>; Thu, 14 May 2026 10:09:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DA9CDA058D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:29 +0000 (UTC)
X-FDA: 84766208058.02.777EE42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 397D31C0014
	for <linux-mm@kvack.org>; Thu, 14 May 2026 14:09:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7v85GB5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778767768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PY2m17mR6GEVETKnp7EPwzD6b5BD0NSOBKIETnOpmo0=;
	b=U/Ka7lxAlYTVBjN+HgotyEFLLDz1rcmKj9e4MsyBRbfbkVCQqkicrXowdKwfswfV+15o0V
	TAUdipaaWjd5A7nVATFTU3trpRwE8wZHWBNk/Hb2J+tLZIeuIk/yRuaKhc7uMMoL4OXev8
	c0mEaOTMoO1gUVxNqn9q7WCZEfVsok4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u7v85GB5;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778767768; a=rsa-sha256;
	cv=none;
	b=gnja4uUzsMQXFacGSe7ciSXWunVwMSzZa1D8an5P6+J7ZJoDhzoLD1ZsVetSZlArl0tT9p
	03S2UhyYAg9UGk4HmS/Jc1U/KgLH/9dazjrtfxWmvHuS+/lFhdfrnkXa4OdTycAoDMJs/L
	XxCQp+mX52Tj0WyYfntz2ZVx8UF5qas=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED0DE4452C;
	Thu, 14 May 2026 14:09:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A624EC2BCB3;
	Thu, 14 May 2026 14:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778767767;
	bh=NHAL5y/oPITnJCCLIJLmLCX0+940gzkr79MzQKjKl28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7v85GB5adthVl0Gzie0AX6da+Fxt8P/DCoN9neudTZb+yxQ/k+RMBSxkQlNUv3w1
	 gxB0tSOZPXZStHkyYJWswniAz1Os2fR7d3ULJmPBNNHJa4vaAqtaX/pgAxnkDLExQm
	 0Ur3FtzZVU6A859QoDLWVJiIXGIM+p/zXjPT22zXvWizh2OhFWPIyQT2K5y3DwWnhu
	 ShlqvtgbxSEDmZc0Pr6wCo1Z9sc/8YRK03ieQA5lvnosV3EDw5VwY+R8wptDPXyTfH
	 4xePfda9d3AiV2TJPPOB7qihIJq+BOrpG2xqs3b9+Qgc/N0gjMqPN5Kj9ssakivPn5
	 5W1kH5HXPvOOw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2.1 26/28] mm/damon/sysfs: setup damon_filter->memcg_id from path
Date: Thu, 14 May 2026 07:08:59 -0700
Message-ID: <20260514140904.119781-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260514140904.119781-1-sj@kernel.org>
References: <20260514140904.119781-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rpejozunhgprqy8yi4nh5bbmmo5saidg
X-Rspamd-Queue-Id: 397D31C0014
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778767768-792443
X-HE-Meta: U2FsdGVkX1+S92+AyoE2IqjgjGl8z2B8NEJ+9Rzxdpx8PuLfUmAOCJPOE+50xJL8/0LFT4ssKzo3xiWsx24X6zZe31Zi14Zd+aw0VYcROUppE891hb5mwkKBj4l5j1kGZCnxLvjZdnLfZV9cpWRvP4RV2R4vd5C9cPn/PkmlW+GndxO8byCi6JLxu8bgEo60MW7YN8fxksguIMZYoeVlRwYjcPTAw5rwdolBjs1AyO2wehbdenn2QLlVM5q6hOzhlwgKvZAXbZ/Nd3Q5MoyVysGDB7zxCHYY9qmafWftYHAF2DPLtHSTtMqimb8vZdPPX4XkG1Du0b5IcK0fB2qZ4I1oRa2oNmChff6OYM10JMF4LJ8hr216D9Mxj5Gz7Y0TsZhLzOyJLQPWcgZeq0DD9ccqVzli4oVxRntrty9bDdbVL1f4GXuKSqm/VW4QxYKH/HLkc0Kj4jVk+dNgI7d4mwp6zIk5sh5dDkCO82Eo48gSb98jrpMGRLadtrxRkXOmMWvlBipCADM82f3JPGMOFwTJvX3fkr8frFvXTViF00R4gfKwAyTPcc9zx04f9jwT2n2HniZXUAV2YMZtiMFQFfKARUuZizfIRfxRVrsGU/tc8yCoscAbh7chfpPLJSYnS8LunA72kG5xVLn8NbrkWPjF67BdGfB6fiucH1LOGdVgRe3eSGJSCgTIyuM3a+jhHE3O70QMbpi/oUqrwgKRS87bp1Ph2gERqbmqtNDIrSGsSxFVsRtaGZ9txgRUYkjRh4B6q5u4oNBdqa+57i4vsu5Y2dP5xZMsHbtDuV09qP2qe3utFDQ8oIrFULhM3NIq69drBcKgRDH6jkgpbjIKbhhahFDcze8KluT/waODTUWoxsSuJCFAhfwSaFfTaDzC3JR96a/zwhPnDsxFoSMH3K8UsD9WXv5C1V2m/pOxj7zmF4Ubeft1dL+rgLLIfPXyGIyS1RR4q3M9sAnjsfg
 qzvPCVVZ
 HDsiHipO88rH9QTgJzrCQwAM2CeWBVD2biOQvoY/36JG0DJMLnSSW+sXaifoogMDFex0/Dreb1ocop4gXxEAl5fGz5VyVdTZsQEXiVyDLU1lai3g7pWeMhgmiwAN/lBv1mUQsVGj6rkorSoxKJDX1TlaF6YvQ0X6Kz1KXZBBZjnMgk5s4SgH17hOt5TQCx/+Zfy7ELPqhxTKiMWFh0BEn9zj/fUtYE8T6w8QzQf6wOUbuu71FvGCMpiXm+tmuDAgMuCJcpGLH0FCSHbIj17gaYHAYdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Find and set the memcg_id for damon_filter from the user-passed memory
cgroup path when updating the DAMON input parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       |  2 +-
 mm/damon/sysfs.c      | 11 +++++++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 3dec0947b93f0..6935cc3ea00ab 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1004,6 +1004,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 32c371c98a884..d74c58874f74c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -143,7 +143,7 @@ static void damon_free_filter(struct damon_filter *f)
 	kfree(f);
 }
 
-static void damon_destroy_filter(struct damon_filter *f)
+void damon_destroy_filter(struct damon_filter *f)
 {
 	damon_del_filter(f);
 	damon_free_filter(f);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2b68e1a7de451..0b7b0ef345cc8 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1927,6 +1927,17 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 					sys_filter->allow);
 			if (!filter)
 				return -ENOMEM;
+			if (filter->type == DAMON_FILTER_TYPE_MEMCG) {
+				int err;
+
+				err = damon_sysfs_memcg_path_to_id(
+						sys_filter->path,
+						&filter->memcg_id);
+				if (err) {
+					damon_destroy_filter(filter);
+					return err;
+				}
+			}
 			damon_add_filter(c, filter);
 		}
 	}
-- 
2.47.3

