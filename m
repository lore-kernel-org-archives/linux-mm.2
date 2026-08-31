Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C30FC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 14:26:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C445E6B0095; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDE96B0096; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B09A16B0099; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83D616B0096
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 10:26:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0478340166
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:26 +0000 (UTC)
X-FDA: 85161790014.18.6410CBE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 66C7E14000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxBtxJIO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788186385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+x+8VzAIyEFRtjjppXXd0Fa0HpYfRCyX/dog/XxHT84=;
	b=VnNKssFvSaZc5/vh9P99j9zrcKXiTfhnGVhZa+asiK6i50IMaSln3bYr9XJVjdraMvW+js
	Wu824kQN/fhi5X4eSNTrs6Lh7EaeLEUV/vNzx1/Mfaw1zvzaelWiuFGgMSyKjVX4KuNk4A
	jjjzI1NMww7E3LZVBdzsN+MEhPR6QIU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxBtxJIO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788186385;
	b=CXjyv3GTXXPYfykh3oKgpPxH1mYWo8Vko9PO7eBX2NxoGueo0FqvDHGDtxVqSfx4Mak0jw
	1HBYZ+3nH0Ho4TGJo/4byq65Os2dRrpDcS+/nN0O+PvVcLbjH1bGsv1w2e3UZWDOifbk85
	8D3z+wSw9LciSNst/+NN+Am1FwMSUww=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0890760120;
	Mon, 31 Aug 2026 14:26:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875591F00A3E;
	Mon, 31 Aug 2026 14:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788186384;
	bh=+x+8VzAIyEFRtjjppXXd0Fa0HpYfRCyX/dog/XxHT84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bxBtxJIO003RZUnygIKZ3OXt7NF5DiVsifsOtcqU97JTvnoq/g5TI693DWnBLJa7A
	 E0FKTpCHFsU5xOUHCOjccOYZgan1zMZo4q1B+Se9DZhFiBRcQ/SMjqz0IdGU9jeItq
	 82aUnOVfFkFjag3u1oF4GHzTc1zb7PfkuD3MI5BKOnzy+DpKgTQ9oODbMgmxU+jf32
	 x7Y8wQ9eqA/STpjnWIalK/UIW1h8lFksVA93fYyKTMWjyJ3kXDfn2KiGsau2Avlq4S
	 n+QwiTDN68KSS1lTtYy5NOZls55eMVxiVhbpr12wprl2tIgEl1CleCn02PF9q7lypo
	 +pafQn6JFqaIA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Youhong <liyouhong@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/ops-common: factor out damon_putback_folio_list()
Date: Mon, 31 Aug 2026 07:26:05 -0700
Message-ID: <20260831142611.77572-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831142611.77572-1-sj@kernel.org>
References: <20260831142611.77572-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7k1exwndn5comqhuy85f9gn3nyz46i5z
X-Rspamd-Queue-Id: 66C7E14000C
X-HE-Tag: 1788186385-71176
X-HE-Meta: U2FsdGVkX19waoByR8ETiAj5FXmBu7+9qrP/P7KMsgs9UD9aOn29xD9BRXW3Hlalb/sIpO2habH9PbmYkgmL01oUwhzgMTH9s9kzIOM02+dxXHhz8xYwwDL9DK0mwGXxrG1X9iHKDb8NAwNEAJTRIaai3741ApEoxd86E5MnFIX5QZsJF10tAmd/vQvaqJW0etpK+5bAeFtXOuqKAkH2gcSEpMk7OAlrSXhbP7Md5WZQ5jTyKagYwyGXwdGVhYIcv2uLZlbDDfxk+zJ1ecA0rV0GkAezW2VR82b5pMINbDf8thLwhLnnWcQcHgLdsHXuwpwY8QItkoGp8io8L6f+xPyA9plI15ybIVElHV/+8YjdDG5hqBViqBBVZo1mbIepJ5GGdc7hADaqQVqaQRnQPiJqnBaWpwO/v89Pv+4WllqBVgk5l91165ldGrWFxHDklEgTm9PRn082VQiu4KvjMw6KghKIC+fRrC5Sn8OYkhzuX+lJgok6Sz3BQxvJEvIa+4MOfCiIG9G8J7LYZ16IZiCgoOdHtNq4phxc5NXXC2yBesXLImjfcGW/MHK03N49bP5FvQub1zhDypLmVz+jTlm9m/RYWL7kCWqUCmcKxw8j8NmxTH5ZgecjBiLP6cnJj6zhEHodVvl9IXG6PJskmfK7hbQhRPnvXPDMLXTKWMPxJX+BknbLq6I5FpjJAke6nyJLCLKH7BdwZfrJUFp8kkFgpor372k3ekis+gpWvj85dxWa8+jwKaZRY4N0u+K2JrRpUwu/D9AT+NKoiHHQ/WwNkBW9OPqjejstSzY845vEi/tLRhjtF7vlRzjnbKwBWgB5226qgOlEipOIcGlUkHa4LOsfL9djcEpUIkGrZUeUzeKt+Txraw2eB+/Ug7bDO8XA8nSwU6Tk1I14tiE/ZakTAVz1q8zZbD5uY7Q1W5v5wI7afWdIiVmAOqR0K6T3pWzMCvjL0xdDeOuBOzC
 +TN+DZcK
 ec0RTJjfeFgKJp78APp1ueK42jkUYQRihQnE9yeUqBKQ6zmFu9NXTnBXpTn+o7UJTDE50JLbEg3WdXLn334We0BQRZjl5dCZeQ/kkonWEzWQ4mqrxuCf5FVie/LRWU6TSYiNL41pZHKrBpaM9zLUjyVKy6gQr644kfbFlnotD1eXcHNYeFf+R21kpPxupMOJcMCPLaheR3056c/8O2WGAdJrNnurzvwqa1NFUz7PM+xQWvNY6P6Zjms0kQRANCzUvss3tEMa/9jMwPH+clFDp6/ogsV/aPxPM4hurZEuoot9B9p0=
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
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260818020650.2844354-1-dayou5941@163.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 mm/damon/ops-common.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index fbda70d8ea4d0..7a2e40bc7baed 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -330,6 +330,19 @@ static unsigned int __damon_migrate_folio_list(
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
@@ -371,13 +384,7 @@ static unsigned int damon_migrate_folio_list(struct list_head *folio_list,
 
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
@@ -394,14 +401,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 
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
2.47.3

