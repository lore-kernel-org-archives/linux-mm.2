Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7983EC5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE8B6B0880; Mon, 17 Aug 2026 22:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7D746B0884; Mon, 17 Aug 2026 22:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C95956B0892; Mon, 17 Aug 2026 22:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A854F6B0880
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:07:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 211E880937
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:07:10 +0000 (UTC)
X-FDA: 85112752620.03.CBAD9FF
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3B2BF140009
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:07:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K6i98u2M;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787018828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B644okUDm2DMJVNSvynKKl1Dx1fxHI+pke8x/2dBvEQ=;
	b=fr3u7SiTaDNkUAAWRDlfJWDXixjygNbE+Xzpb1mbramKYxW29sOptXkcXzUCWHDj0I5cuZ
	uqQeSPvGCiuTrUDdo2P4/1Tz4SyohxlipwFBGoGDd1rZgkxOYz7B7a3mBMAvn/nIBpN6C7
	6AlVpgqxl1uMyCxxTv71O9nZjfoyL04=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=K6i98u2M;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf26.hostedemail.com: domain of dayou5941@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=dayou5941@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787018828;
	b=D2ZZmKsl8/R5PQ8TS5GPyRCUIHyZLDJEbeVVAzwHJdp3wVudnvonM9g3GsbPZnZkHMYH0R
	S4lvEevOuWVQZNAKqyP8Z9yyhJhTisxLiy0Z/NlUL55asGHQPrRbZEkfk6RyLBjPqEYy4q
	jzDFwr8VVv4Kk+VoxE2jTclaulMSknA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=B6
	44okUDm2DMJVNSvynKKl1Dx1fxHI+pke8x/2dBvEQ=; b=K6i98u2MXth5BbPKZr
	n49+CWGQp5aMApCQtRICDo/6mJbV4tiM+Jx1xZqYYQTqyVUAZOVJFpVAAet0eBAQ
	5+1Dv6s3mTJRk6yLPO7vGvM0Z09poRQdK0ustN6M81z5Fbjq6bChzEZoG4lp9/S4
	bgvycgEnagA6EwPJ5yIiRBqTg=
Received: from localhost.localdomain (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgCn2Ns8voNq82tgMw--.11657S2;
	Tue, 18 Aug 2026 10:06:54 +0800 (CST)
From: dayou5941@163.com
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Li Youhong <liyouhong@kylinos.cn>
Subject: [PATCH v2] mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Tue, 18 Aug 2026 10:06:50 +0800
Message-Id: <20260818020650.2844354-1-dayou5941@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgCn2Ns8voNq82tgMw--.11657S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cry5Zw1kXrWxCw4rAFykAFb_yoW8Kw45pF
	1rG3s8XrWUJr1xur13XFZ5Ar1rtrW3Xr17JFy3Gws3JFn0qw10gas7Ja4IqFyrJryUJr18
	Z3W8Aa4Y9F4UJFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UGg4DUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5gd103ivzuiqqrwthudrp/xtbC3QA76WqDvkBsEwAA3n
X-Stat-Signature: i816fa3qxs9gdzzjei1ngb7cgzsaouax
X-Rspamd-Queue-Id: 3B2BF140009
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787018826-786250
X-HE-Meta: U2FsdGVkX1/8a55HqXPOF6F68yAzllfWAReEn8nIYpVZIlu52vugojviMaLBRE3xNWoV7L1+NTIZJPTwKUdagllZtbzbTn1hD0bUfmUiriio8DPxY71Y88qCgXuR3Hw+Du6Q6ujpK6FGW/4ThQha7dNEJDP+zywGe1fcMKTS9TsqPX29HUOWTiVSLVRPSIfzxMjTfuifU8QpvUiD1wTRgvX7qdxF7q378ZwwDUoNFmf+DB49pSLIL5G8cpziuBKOrA53Fw7zkVWAkXxgNfJHskY3Xvmv5GUMzA0fxBZIeOO4wcIoW51wuy3t4pZml7r4yZWwYIXJKmRBjtpL6k7Q2WjAvWx0eeC4OSrM0LxrTkxxMeWmM+U8Fl95AI42j8uoeaq5hzfG4x6rUTh2xw8YEML92+xJUuk71QZ6HTfcgEe2Ee0QBI+0h+Q9QD3mzyj81cb0qTHdkrjfLXMl+gWSqEaxkKXZXlm2zhKvYXaGsWOzm3C60wVtnVyIk+Y1fedEdNXc18XMOo5eKXlEDxg2DP5vEzTPXon1DBaJBx++91za6GDieEDhRN27WmNbUvkj80+i7ZpqoYuzb2b8L/ohfj/PmD3zJs5TFcc9usgWxL1pce2NzClaiUh9P50+OkzMMSxTnkEzb8wNCajAfupcoYiBAPP5grjYDuWcfL3IFVaWngUwvIKF9V0lFvzseXHJb/jpFVw50I6kvpHNRaFRaeE0wvwsKwN5IU2behXhVYWx/zAht82Rkl3auiCoa+Ri0IP08onD2CF7gnxpeJXRN5s3v9awhxU1vJG0AUTfubqFu3VL/jU8Uf0ieeLiD0uFOz0phjCtcc2WUEZVPXC4y/+jR0WHwZDL1VfaBr4ELVv2KIUbK8BwvMiEtRiCOHxddgMyubMHguqiuEGT91jmLdcFSVYxuqgrXwevp9gydXXeEd/McdXhalNnST3iOy8btFsIoJ9BlqQmJZV+/Uh
 n9JFzy9h
 KCKs/SMKZKkImlcMIIBncUGcfpmSsWGtRseJtorAaBGs47UY2vL8zFlPIIWDGWG1jNh8nUMLHX8eQ5mmkr5I94IBz7hPrUQP16x+aa50YF5oDMEBP2W6oLU42VUeLlcXQ0nqUg+FpYvKqO9QGMSMdMhNFlfqQDV62i5OsZm3XHcc/DtVq8ZcfDfR5GSVbh+WgWWsTQwn6Y1vJzdNNemZ11GGzt6lr6f7ENekiUNNSGjlE/zlPbaZfNyyV1KbO1v92N1+oLJvvCrByzrjG7CdUt55iEd2yzSxPMdu0rMQAQ6z3uxRqknJ6D6OGf3FyCgQWqY5fzlev2i/cFXZcX4OKynVlLQH9E9FSad1vIZXKKXoxuJ/0VLPk3YS8y/JbXHX7s0zWis3fw9R4kr4gpJH9YXE0sXPhBaK7akbUjggqpXXtsDE1Y6R60awKCa2qUB8fS76Bm4/2MNyEzC3Rv+Or5u+E8I+ol4YaytmB0Y+2Zrr4UUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li Youhong <liyouhong@kylinos.cn>

The putback loop is duplicated in damon_migrate_folio_list() and on the
invalid-nid path of damon_migrate_pages().  Factor it into a small helper
for readability.  No functional change.

Signed-off-by: Li Youhong <liyouhong@kylinos.cn>
---
v2:
- Restore the removed "struct folio *folio" local variable to fix build error.
- Use get_maintainer.pl to include linux-mm@kvack.org, linux-kernel@vger.kernel.org and relevant DAMON maintainers.
  v1: https://lore.kernel.org/all/20260817063458.351063-1-dayou5941@163.com/

---
 mm/damon/ops-common.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 0bcad6b1e5b9..ae101689612b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -329,6 +329,19 @@ static unsigned int __damon_migrate_folio_list(
 	return nr_succeeded;
 }
 
+static void damon_putback_folio_list(struct list_head *folio_list)
+{
+	struct folio *folio;
+
+	while (!list_empty(folio_list)) {
+		folio = lru_to_folio(folio_list);
+		list_del(&folio->lru);
+		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
+				folio_is_file_lru(folio));
+		folio_putback_lru(folio);
+	}
+}
+
 static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 						struct pglist_data *pgdat,
 						int target_nid)
@@ -372,13 +385,7 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 
 	list_splice(&ret_folios, folio_list);
 
-	while (!list_empty(folio_list)) {
-		folio = lru_to_folio(folio_list);
-		list_del(&folio->lru);
-		node_stat_sub_folio(folio, NR_ISOLATED_ANON +
-				folio_is_file_lru(folio));
-		folio_putback_lru(folio);
-	}
+	damon_putback_folio_list(folio_list);
 
 	return nr_migrated;
 }
@@ -395,14 +402,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
 			!node_state(target_nid, N_MEMORY)) {
-		while (!list_empty(folio_list)) {
-			struct folio *folio = lru_to_folio(folio_list);
-
-			list_del(&folio->lru);
-			node_stat_sub_folio(folio, NR_ISOLATED_ANON +
-					folio_is_file_lru(folio));
-			folio_putback_lru(folio);
-		}
+		damon_putback_folio_list(folio_list);
 		return nr_migrated;
 	}
 
-- 
2.25.1


