Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FF25F0180A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 07:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7ED16B0089; Fri,  6 Mar 2026 02:59:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60AE6B008A; Fri,  6 Mar 2026 02:59:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6C156B008C; Fri,  6 Mar 2026 02:59:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6FBB6B0089
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:59:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D0E88B847
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:34 +0000 (UTC)
X-FDA: 84514888668.05.3965C25
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 744D81C0003
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=cY0mPFUu;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf20.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772783972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tACXMiPwwIjQ2HHSPAlpz5qHApNq0epbCchekjDNTPc=;
	b=4sbfCUQc8RnLA+huD6rcaOv2+r9UVFpOBOECJTUtrXuXlEKDGRb+KigJpUuNk8g0tv2v01
	WkN9lkwopqYdCOOz4gpo5XqheI7gnj6k3FxqeSxpZKSW2Q1j+r5JYCfJ7aBl99fuWrdSz5
	Egs/Wr922PSVwljR4Ub3gLcPdF3sVLI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=cY0mPFUu;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf20.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772783972; a=rsa-sha256;
	cv=none;
	b=UYsCQ4v4QFqIPQ5t4ng4UT0wtjd4b5j+I/7Jvi9ugNISkKoAIgO6R0MBVwxj05uMCKytpx
	QOBJ5bdxQVrrc3WZda0DugxkBNFv0rOQDwuB/09VcDg203Z6tg537G/6R9ywe/+X8oCmSD
	wcjW3DVUFQeRoYF6HHGL+6Msqj/jOUI=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-358d80f60ccso4365614a91.3
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 23:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1772783971; x=1773388771; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tACXMiPwwIjQ2HHSPAlpz5qHApNq0epbCchekjDNTPc=;
        b=cY0mPFUu7WyUz7LjHZmcxVSnfFGFOhR+lHifoAQB9gpmH2Fejtn/e4KvqTmF8l52A/
         rvqs8aWAi0pvAhtroZtQaGC508sjqsjBgBUWP1EbP2BWv7+UTdQpd56jBB1zzSWofWAV
         viyZ3cW1Sv7qRB8RKyQKYqWU5Rijln6AKuPprqPt24lHYaw+PWRzl5QjSr1GzfHyNT1L
         EiRddm9x2axPfqlYdLZGKOJsRLc0nKhHshgnK4f0EOyLfk6V8vvfEx7pmiicsPbytqS0
         XSNEm5+Wx2dWz4H6UmHhU2AHQJam2/pKl0ShbUNPcMXtIzRFinDBQobzhiDx2e3C6JaL
         39XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772783971; x=1773388771;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tACXMiPwwIjQ2HHSPAlpz5qHApNq0epbCchekjDNTPc=;
        b=P4OOr9ibea9yTq1dBzWt/YgPluSuCUnzzdUy9Sm290aB4E1scXSxvpwPVODeExQBLw
         k64eSVgFXfIsW7E2v/aODtUDtN+K3tWkN0O49myWAYq7AoQNJ35zrE5FThBGzK4tOMGs
         RXXJDvjGOKoF2WNSwSAxWRv+h3l3gmbntiBAdk3b96O1ZVpZKzHhTouzqOGp60pLMbDB
         FGJux8/v6GZL3L6vsJ/K7Bibqx1pe2s+MUd+4NzFIJmKNa5eSzkWp+WARi9E0ef3tfh8
         +7LGQ3jVMJ90+Uqm3wDWfq0+hp6fcRkYzGtLLEn68wDKXYLxlYmH2tPV7gU7PE2KWpHB
         vA4g==
X-Forwarded-Encrypted: i=1; AJvYcCWzhevtxpynzOkvC/u2AFUAjgJFgo39qU6GkpcRdidF4m/bQ3ypRU21YGLWgJtK+W5wbNIf38t6Fg==@kvack.org
X-Gm-Message-State: AOJu0YxOpligkyXNsrMmfyXEgGEouAckweW0BKX532OrhhAvE8dM7U9H
	BaTJ9g8SkIvRVYSg+GFo6DcAKLkjE9ZxXMzuFC0zZ2apVE7VT3CsMPUuUYmF92jzz8Y=
X-Gm-Gg: ATEYQzzDl9gpKPOFwh6VA4NQad9X83QWfZFw/E4f7wU/qdd33o9xkv7At6eLx7r39uK
	y1h1feZQG6zfSCQ7SjsZF1KU+DMfb3pEp7m2N89cpJmS9hbFlnvlpVWEwKwfH3hLEYvdtHvc2E5
	3xgsrD47aJl3kuBjRdnvgV/RAgKolcuQn0RalYA6eYDVL0ssxTMZ0G2z4LL9mF2Qc3c6NLTjNVQ
	xiGPjdF4RS+Ifsrlr2/7bDFGFT3jphpLL3gHZqk5y1MSVIkzfnv0U5Xw9MwNxyIsVe4CFDY3Z71
	zRwgeiQGmbReOUOF3tDry2WTFZUIYK/yxR6pbcqp/nCX2F55GeCSo3mudvJgNubUVfdR4KxQwxP
	1+i87F/CbVhP8scTLLuesuDS4IwA/2+PF4qsSh0XnsKQCb1bZcOu1sLmyxPVEr/ddyEn3XmSzNZ
	7kp/qrSiFnwZumOJoFORdw96eB57ChFrw6RV5s0w==
X-Received: by 2002:a17:90b:384d:b0:359:9083:3661 with SMTP id 98e67ed59e1d1-359be2c9bf2mr1229924a91.15.1772783971285;
        Thu, 05 Mar 2026 23:59:31 -0800 (PST)
Received: from localhost.localdomain ([147.136.157.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bbaa0d83sm804787a91.0.2026.03.05.23.59.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 23:59:30 -0800 (PST)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH 1/3] mm: shrinker: introduce new function get_shrinker_id()
Date: Fri,  6 Mar 2026 15:57:54 +0800
Message-ID: <20260306075757.198887-2-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260306075757.198887-1-haifeng.xu@shopee.com>
References: <20260306075757.198887-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 744D81C0003
X-Stat-Signature: j4ky61pisapd86wqrg3du78dxw9tp9jq
X-Rspam-User: 
X-HE-Tag: 1772783972-855743
X-HE-Meta: U2FsdGVkX19Aqzw7xukIkMpwOYMmabmeyfCQ1P87Xp/H0frgCDnMkqP7rKpTYk8VYJ/w+dpcBSmW7RagwGbQdpNBb0FPfL2pr6azICid6XnhPRaxKvUZsTgepD7AVMDaVf+IIpsSjceAxOX97sfLWqirlIkiPH+L9UbFLxelvcI06SmUECx4QSeRunC885cBZ2qIi4ECqT16Fk1DZclxjFY631U3ebP2Nb1DeUQe4FTJpBczIcek/QJ5d+s8RLGf/FKEG5wZjk6SwrVCo0k0FRoPY7yVXa78V4brRtHX6MHOpOaO+q+NchSHwqSydEURvENf22XB6GthFV8y7RFyjKDFdkgEJOkkjZNaMznqd+P05vKYUMh4noLFFjM3+qD126CAlTdN2nkN53l/ZiaVf1y80aY/y05fnCBXHZGHRPy/u5BuTHV7WQIsVq7rYXbfd5ewjs4FgFr16Qqga5HDSP8K8xSqcif0CV/1oYIU9WS3P4FrrX64gGfgMgcR/6vHOqZ/1+PaMhVM2M29QNAbXIBhPgYdgX7TIsz+VXRJ/ptb4ED+sWjD9qpqJtmF4MVB2RJ8sUpcFw8oImCKyYFe2w6a32KIteIIdN2Qn0zsiD8ULfE6ngcCLttYU9wShBtnHAdk8WrkWKijYsZ/l/xn8ZaJ07j6RjzgpmAkTGWYZ2BctsxlxUEgCX+hs7eXSLy3Wfajvs9h5dpdj0CqpLe+QluyufKiGQGf5mRKKdf1+S6sXtdH2nZVLIwwpepxptMJ0ejmGQ6RUB6Tm0UfTG/Ybnuy8d2XfUTwcviMLjVSlY4Xe3CawBhr9GUcTnIuTcD/PyTt3+gu464/mAV1J2MN1QbvoCXgFOYsIblUVkB34izHd77GdL9arQ+7EAH6vIixLusN6oCD6ynwZ4HBgn3JkI67XVHJSDocrZE+EftMjAiwfCLH2Bj/pD05tg1LIiV7Hjxcx5OSbTlNWdMGGvg
 fssQ5Gk+
 1TxEiuwbvu7NsUznltcJiE6Dx1MWEt26tMQ8KvB5k7cIW38gRvNueArVP8ri4HQ7sO5+fDbPqx6i5FQY3L1PUQ2bxmMNZ3484x0UOFhm54MBSohrNSYH+p7PqaQMIy9fi+ScleQq1zqOQ4sNQ+9Iat0m3A/QWxBeWkX1SF7sRHQy9/1iwilZDqb4utHWTaX9B/Qg7NFsgpbfeIWL4sbuDdjiVeh4Nvw+E8lDIJrMcEzfQQKLaHBUPcntNSzWdmD4OwQQ4A7EuC+4H+hhZr29LN8QVb7HPWySbtxwfCfgRnCrzyElcpxXEokXnKDocPylfup5S20ypBOBsT0tlm29QutLWRm8l9f6LXbitqN6khlAxpfR6FjI46V64X6EIsFLYn1ke
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use get_shrinker_id() to retrieve the id of shrinker. No functional change.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 mm/shrinker.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7b61fc0ee78f..f0c6dfa026b0 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -193,6 +193,11 @@ static inline int calc_shrinker_id(int index, int offset)
 	return index * SHRINKER_UNIT_BITS + offset;
 }
 
+static inline int get_shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
+{
+	return shrinker->id;
+}
+
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id)
 {
 	if (shrinker_id >= 0 && memcg && !mem_cgroup_is_root(memcg)) {
@@ -255,11 +260,13 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
+	int id;
 
 	rcu_read_lock();
+	id = get_shrinker_id(memcg, shrinker);
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
+	unit = info->unit[shrinker_id_to_index(id)];
+	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(id)], 0);
 	rcu_read_unlock();
 
 	return nr_deferred;
@@ -271,12 +278,14 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
+	int id;
 
 	rcu_read_lock();
+	id = get_shrinker_id(memcg, shrinker);
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
+	unit = info->unit[shrinker_id_to_index(id)];
 	nr_deferred =
-		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
+		atomic_long_add_return(nr, &unit->nr_deferred[shrinker_id_to_offset(id)]);
 	rcu_read_unlock();
 
 	return nr_deferred;
-- 
2.43.0


