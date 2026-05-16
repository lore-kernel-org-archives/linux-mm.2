Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FE0CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BA06B00AD; Sat, 16 May 2026 14:37:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29D26B00AE; Sat, 16 May 2026 14:37:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B126D6B00AF; Sat, 16 May 2026 14:37:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF116B00AD
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 656BB8CD9D
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:37 +0000 (UTC)
X-FDA: 84774141354.04.1DE4D4B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F3142000A
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o3DBAiVJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956655; a=rsa-sha256;
	cv=none;
	b=hMy1SDoikvex5vW9SXkscCZJjsslZm3Fb1825JMk7SFRIepaNxO6P9PHEkFFysMqH3pW3F
	czTNYZLPV5zNktvhVnh/cLByVZJaDhrIA3Z2N4eH9XbU7E8n9zvIGrQTjIwfpCIerlVOFD
	sZr2gxc8Qavm5kKjddErZI+88wLkr2w=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o3DBAiVJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956655;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFMSskkJ33vIbq2W/Qp96OveRDKZO/s8mUVkuDuV0zI=;
	b=fle8fzY1YJSxIQt7nbJ7Ra5/tIGsXGzUua4VmbYp9QAVJR7GVud3dXoYMAP9bPJD9cQZI4
	B6fDyqwaggjhdBBQQVm/3ooyO8uYQZbCle2IrDY3P79rLYYs+sYekF4zYoGlq60RXQOJ10
	9W0EuhTE2Xf5lRzblGjcrpIsE8gzckA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C778443D9B;
	Sat, 16 May 2026 18:37:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE5CC2BCC7;
	Sat, 16 May 2026 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956654;
	bh=Ee2xBoGCN0q1MWtaUMmJevs875atGOk3HcGVOqqc1ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o3DBAiVJ3MOyg5p0ljt6P9bUyfyf8BBFbPeh3n5Hz8RWm6bVS8C8H4CN3aImIdGLu
	 Ng9P99XpRtd/lXcJ/cnoA4kAL3KfJ4jiNmTsJ5rY56oaBM7uhuVE5W1Ied2qEvE3bk
	 vJL5cazGQqPsXauaqrlwIfjModk646fKHHu5XMhXKOVdmon7XbfOmWuFnbZpN2pdKD
	 qYfFl+G0V0MMAGymoj9JnCGhK0MkS6J8WhNx1iR7A+32rw0oY4vs8lovEw2B6CIH3D
	 RDEodlKbeKiWmqqnRktIL7jb4GmQ6e1V8KacGiAzUNzBAQfmn+pNT38cV8w/4JrEHm
	 tNyY90IBq7zbA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 26/28] mm/damon/sysfs: setup damon_filter->memcg_id from path
Date: Sat, 16 May 2026 11:37:07 -0700
Message-ID: <20260516183712.81393-27-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: w6qaipc55ka8nnhyype55e6nbiobjjai
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F3142000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1778956655-354372
X-HE-Meta: U2FsdGVkX196v6kThdUUQkgJTsnariqiAaKEJGckYwTdvLrMZwYYXG6T7CK5yTGFl+GTg5Uqa/RJadn+/x9vH4EnxPyA7aGJQLjfRm+ISYugiwhH2xcmFwZGXH/dutDFkBtz/rYX89Va0Nki25DUfuIehWBUFmyZZNBvLR2dxlQOsqxD+EKd2NWWWUZMk85xTAdXW2hVWf+nUT2smdWye5v0Flc7ErUUb/I9rv/i6AkACqmWOUSScCg8AFVEsqxJTIxlV/HA+NAb8r9fANVUnBQzMvI/YqRDPX7bo5fvjE3HkNISgdpPOf9Saq49+12vsnFDwDySKMsqFbuqEjNmBWU7llAKzPuXWnIXpjfRVHQs7hZ+L8E+KsWc2Es4CCuQ1yJGYrNWUKw6kDN7YVoj0Rgx1xTHf9LoKwmDMnRdncOl0LAFM1VeIusaz8SAWF5Mk/YsiysB+kWE0ilx4Vfrw0E2vueAg/MevqTOJCv6RFqeah5hLcc5wWi+2S9Pm5MsEoj2kDciDca8KR2oVpx7uo3acRhne/Xx90VhQSqaEPduwc5eVmju/ZkpKx3HxQRybT/Whgo1wIYaV5aYTIuHAI26X6O7wUzr5t1uNWMY4Y96KYXXOhl3BxXi4bwkDEnrq9AHbWFdho2MIhfzGa2HuzbmGfC70ycl70J9ChuR881BQ+/RXvjYc0YPFJy4wRgU1Ncgoknz5wGasy3+xSZiOZwU2iztDPfln+21JbQQuPR4R0TVE49fQZg96TaXq599pDwcrJ7PpMqT4eACbYwmm4Jz8K51NWiRRbmN1Q+cxczMyqCPVJa3p+6DaRaJGBVu0omlaGscGZTWjBXj8eyUGaHmAhooO+uw0LRFwZWREJAan2JeGKo+slBaHliSmcWrvRmBYTaZQuYXW4+jvsRakK41/XFtZAEOAGlXLehXf1QUc0k/rL7egBWpgmXJh4ux7/pC+yilOXzJTxTBwGZ
 l/O6pHfR
 OCFx70T2MjaCgDs5InsuPmSbbK5SH+gjGel5TMZcDmhuepBKmky0vVEakz+Hg7AAARdkT6ojkWrKRtFEnqwM9cc1pagew77UO05L6z5kEvIxDNuAQapmpRL0ZIAD21WvjUF01JxPFShqOUHZ7VhnH4hQiqugFGUMcidZu6smpiMzzButm0Gy0FTaOkdF6rXH1I0JeT2rpMnZzgPnL06DR/TOHZ9shkGpH/cTAhsMDi1N4P/mTybMwXF1jIg==
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
index 56a76781fde22..cd0c352a777dc 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -976,6 +976,7 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 struct damon_filter *damon_new_filter(enum damon_filter_type type,
 		bool matching, bool allow);
 void damon_add_filter(struct damon_probe *probe, struct damon_filter *f);
+void damon_destroy_filter(struct damon_filter *f);
 
 struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 332d13d9f8603..b8fe4320c3da8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -139,7 +139,7 @@ static void damon_free_filter(struct damon_filter *f)
 	kfree(f);
 }
 
-static void damon_destroy_filter(struct damon_filter *f)
+void damon_destroy_filter(struct damon_filter *f)
 {
 	damon_del_filter(f);
 	damon_free_filter(f);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 2df1d670ee77d..8f927e3dba827 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1897,6 +1897,17 @@ static int damon_sysfs_set_probes(struct damon_ctx *ctx,
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

