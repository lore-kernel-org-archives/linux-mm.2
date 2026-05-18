Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587B1CD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:42:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D405A6B00CD; Mon, 18 May 2026 19:41:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C51196B00CA; Mon, 18 May 2026 19:41:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3F76B00CC; Mon, 18 May 2026 19:41:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BB506B00CA
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:41:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 56E291C09C6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:34 +0000 (UTC)
X-FDA: 84782164908.11.D113A85
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8CA7D1C0008
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:41:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sv28qGD1;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779147692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BTrtNtCOj3D//4FgnaNNO33wGXG1bQRXbp3Ucf0svCM=;
	b=pSVF4yL2ShuOq9zYWSk2j2l9A54r52hqC/Pv1pnz7IR2l/ZOF3osH13kc7VZj7Ht6nmdhV
	GvFuKD01I2UpGXXXCSehFJ5gAw0tEJ+iFq5t0MLen1mXePpOB/sfaVLy1FPpNlSBfe6YhX
	thRwfJLGWzjmNifa+cQDvTXGoOJgimE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779147692; a=rsa-sha256;
	cv=none;
	b=KCpgRMQGyA2unVMguEyOpVtRyW12Weg2ewBdMaEUHIKUNJNmMJH27Zug+iq5TIhjt1/k0v
	CCjLHw1Pi2UWAAAFrkwaQ6TagYhboCCi6nvj3BjfGfJ2bt0ckZjAhDF/71I0hvSWOA/Ndv
	Kg979ZGpN0rvn4LMSKgsIof0wZNzcH8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sv28qGD1;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 400ED44002;
	Mon, 18 May 2026 23:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE061C2BCB7;
	Mon, 18 May 2026 23:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779147692;
	bh=6FCGqtqPK1Y1yCXdyueYRDbO5bOOUBp7eJYagnQ/2uA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sv28qGD1fBC1oWwlOv+NYk3ZPwvyCCq+0pmn0h12YcRr9a6RTz4X7Fuf7CrZVMx5M
	 1v7Qd/Zxj7SlJxxCeo1l35krA2BFOocZ2pHjLterqnyfw+8OCWwjGxJ0LI+XSAyoT8
	 Y7ynJDO/U8VSNu8e741JTrvfAOo+BDGxP/l1MThFLPl58R4PGgKebYDC+e13eUm5DU
	 89XBTH2i4eTFRKMApT+F/CaDzBd/t0jvvs0TgC4T+M+5Re1CvDCPR5cLiAJNeniBhC
	 FzJup3NIpnrZAphhx7RoloYSOLXCacq904GFuApJ5zZbtIjpuGXGTy8UQ9sU+Ok5D1
	 Ip06a09ta9vWQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 22/28] mm/damon/core: introduce DAMON_FILTER_TYPE_MEMCG
Date: Mon, 18 May 2026 16:41:10 -0700
Message-ID: <20260518234119.97569-23-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518234119.97569-1-sj@kernel.org>
References: <20260518234119.97569-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8CA7D1C0008
X-Rspam-User: 
X-Stat-Signature: djj13wip13q3uw4tcag57ee5c9n53ood
X-HE-Tag: 1779147692-170816
X-HE-Meta: U2FsdGVkX1/5yXgXK3ID6f1b38HiKz66UfgqvaMVpQ+N/fgg+YJCSsHkL2QhjiG+NWUcCVtonx5esTutiqNskVRramIkD280WtUgUHgWqBS57SgR8Ha0SsaJrHjRaPmCFjV3YSwbVUV7eVmJI0cXlQudAynZEyPSUUYaOUcmcyoPMidZxqXZU5jr45aKWc3oo40MexTWBCCUZoipYD4yUHiaedJAUqIVSA1R39Z0ArXyfYMl4VDtmNMBdEAfqklU6h3AKXay6bQRZs+K0nk9JbQ/SuuE0AJW/g2hIgEfOaGxVdyIxgIW58AuaFm2F/X3rFuectvBSsJfcLshonfyKGP/kpkDC4r5QoeYPpQpTBHF4Ce9uffjrJlVjOXUpSPy/4V8zIrsYSu4cjrTDGEyttf6nWIYUhgJuc3V0WWKOenm5hn2q2uK43G1bTc/UNFuphJ5WhxP24xiJO5rNB70uYTUf35xYXZSNQQlVSvjpOYad0A24/REAoNFrgd5nwdblUmdH7Vt2ZsTKIJcT9nd5WQjdBPj3kNfv5hekfCzuICh7YGQ2n7El6rn5CQhMa+qhzrlzqcg35ke/brEIiE2J+vAwIIzXT7cYqYe95naDWnZNeLQg8T0gUK63/P7bav6+2MUOSfUH5EPx9X2jvX0r+rDNKYeXmhkm3h9A0vuX32i+N9CncoKj84FdQXQ4kQSPM2qal2pLZSBL8t5T1Eu30STPPKdBOtxyPCVEg3iIigKUT2pHShkRLr01l+pJOgBOZ+HhZ95pq9Tmp1aA2e+9bwHI5gEuNPjPxaj+p1JB8p56RgfjE3X5y3ZlrgHVQbi7v7YYYdwmKP1ZqjNyfU1D7f/rqq4Yzh5K4rFjCE3DLYU6SDAMr74TnqogeUgY//52ocieF0ioSBeT+H9U0LZ6kLowkvZM/1udosQCzwf9RHGnI2jfMnro1lO0gErTPZMPKu/mxHRyx1dU0XeoUS
 4s73u6cp
 zLhUIU5RWMqxK7ZZ7N9Jx6lkC1MleLDp18wE3ofrMOAo+moDCL0TVEMtzkoYVaj5fzYvnyHqp1lhg6l52oqQAp3fKnlh00OtxwNgzGIbnLGCMUhDV0VKv9BKy+6xaXzxyJVT9HsNEuf8przCnMX7TxPD5uF0B0nCh/RGYkXX9TGEXm9mNPlY/XMAZYuE8jqj8UwaCMThAAA30VS8NWno+HE4gnWsy5xgafAXsfAa+rD+Uy6qZBkEUr5aftP0L7umN6sgVUZ9FFIJeRenosoZJtEyX7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Belonging memory cgoup is another data attribute that can be useful to
monitor.  Introduce a new DAMON filter type, namely
DAMON_FILTER_TYPE_MEMCG, for monitoring of this attribute.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  6 ++++++
 mm/damon/core.c       | 14 ++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1fb271a35e98f..6a54c601889bd 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -742,9 +742,11 @@ struct damon_intervals_goal {
  * enum damon_filter_type - Type of &struct damon_filter
  *
  * @DAMON_FILTER_TYPE_ANON:	Anonymous pages.
+ * @DAMON_FILTER_TYPE_MEMCG:	Specific memcg's pages.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
+	DAMON_FILTER_TYPE_MEMCG,
 };
 
 /**
@@ -753,12 +755,16 @@ enum damon_filter_type {
  * @type:	Type of the region.
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
+ * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
  * @list:	Siblings list.
  */
 struct damon_filter {
 	enum damon_filter_type type;
 	bool matching;
 	bool allow;
+	union {
+		u64 memcg_id;
+	};
 	struct list_head list;
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5ba7ad4df4351..4fc90b0bdac88 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1433,6 +1433,13 @@ static void damon_commit_filter(struct damon_filter *dst,
 	dst->type = src->type;
 	dst->matching = src->matching;
 	dst->allow = src->allow;
+	switch (dst->type) {
+	case DAMON_FILTER_TYPE_MEMCG:
+		dst->memcg_id = src->memcg_id;
+		break;
+	default:
+		break;
+	}
 }
 
 static int damon_commit_filters(struct damon_probe *dst,
@@ -1457,6 +1464,13 @@ static int damon_commit_filters(struct damon_probe *dst,
 				src_filter->matching, src_filter->allow);
 		if (!new_filter)
 			return -ENOMEM;
+		switch (src_filter->type) {
+		case DAMON_FILTER_TYPE_MEMCG:
+			new_filter->memcg_id = src_filter->memcg_id;
+			break;
+		default:
+			break;
+		}
 		damon_add_filter(dst, new_filter);
 	}
 	return 0;
-- 
2.47.3

