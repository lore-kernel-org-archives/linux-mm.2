Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC96FCC9AD
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:13:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C06A6B0088; Mon,  9 Mar 2026 23:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B186B0092; Mon,  9 Mar 2026 23:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170F06B0093; Mon,  9 Mar 2026 23:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 067676B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:13:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 701F3140427
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:03 +0000 (UTC)
X-FDA: 84528681846.08.2963A8B
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id AE204140012
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:13:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="lq/+BTba";
	spf=pass (imf09.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IJuSJm3X4xhlOG3+qvokrBOrPsbIME05pWUjl43X0aE=;
	b=47v1Gca0WyB2sfiVITdJbU7npXZbdosJCijRZsrvylZvLD5BMP3NAzm2+TKDYc8IPDXHB8
	Ue3fd4o3yYAisAjPHoADO8hDcsmIyvUFP10yfyduys+iiI9mwczzsIrv5eUP1fqD9MWR7s
	WiQfROTql7VawQCBD06GVxZy0lsLjBE=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b="lq/+BTba";
	spf=pass (imf09.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.54 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112381; a=rsa-sha256;
	cv=none;
	b=iMTyFbfeV8CHsGzyJcijmap5gpYjxvM7bne80hKoJJDpJzGeHnynZShs52j7BTefJpo/in
	TYFLM+s8kdJq4jrsqOez4490X6q7Oi+U959kwQzWP0s2bk66dc7jmd2Ohm2csthWUVwgzs
	W6ObCgFjT7zjSG6F06vQvLS9XoXEQIE=
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-35983877dc5so4019383a91.2
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1773112380; x=1773717180; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IJuSJm3X4xhlOG3+qvokrBOrPsbIME05pWUjl43X0aE=;
        b=lq/+BTbacmXsCmIwueBgKF5brE5Wz8d6uHuVtTzCLaUTUsGB+SvfzQI9i9pNcdJ+D2
         bpwbPCIiGR4TXyc5Fb3c66/M9+Dm7xoyLxQcoUhqww5WJqw/rgNXUt7BuM9Hh/Zi2/Ms
         0vRsX3o7LZQG/TUex6p37iGhjctTmHQRPzBxfxEmj9JBol+R++G1i+4NhY8JnI7/ZWHW
         P1hQqMRTFKlePhAzH9MToGKRxlO7tT57Hd+kW9CN2AfsQX1NX5Qem1zGsMWNoFPa3U2y
         tqOGnihup2iAjFw2YgrmObA6UflM5XhvOX+z1gzJv5yjudXMcQnGZgEd3Be3t/TLwWzg
         oMNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112380; x=1773717180;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IJuSJm3X4xhlOG3+qvokrBOrPsbIME05pWUjl43X0aE=;
        b=lqbe7Sxn2JAnKQ5dfYH2Jb1wN1cwn16Gfqg9o+gKTXl4wVTxRm+1fbJ6x8mCKPRAGL
         CBShuAQHUHsDlHVejn5f7rIJMFBhqRTHBjoA7XNSHgteAtmBh9oOU+hhNY4ju/PfIWj/
         0giAGWWSY56u5jNIvxDI0j621xPOIZB39IQ5oC7gitZoow4YkrI+sQsL7zEkqa/jo3QY
         s72dlNTL4MldXsI08+K3bFQoOSjVfFvAYG95FB6uRH7/y9B6VF3iQwllpkt6fW/mQdri
         859ZV3Xk2qVdE+AGat2cxtMBGYnfDAnV25ufWqpHBarY1xnq/7cDTV6k1GZshQxPAwSB
         I+5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKheYJ2g3hmgMnc7QYVHhmrWLP1c7qNyyACU3EU1gFqzfh96OIeBT6nxkJGnnsG/J4bt/nG30rVg==@kvack.org
X-Gm-Message-State: AOJu0YyLcO94/HbzCYssu3SeuzXBn8CEScI1ihROk19AuNvCjdeHOzgE
	Zy6dpPh5EzyvY1rKkVwBzAL31dZUX575VBh7N0mJsxFXRu8bjokeptmgA/9RwnIIJik=
X-Gm-Gg: ATEYQzwNxQhlEpaPhxuk3+E0dtzkhrUy0ZCour8wJdKhS+Qxm3Y1DjqO7XWO+XVxYFo
	LYePqb9GP2/btkXtLe1Sh2hh2dxwB+nvx7qa5ICxdb8LYM6D58+kw5Ex0naMQYVTeOoNzd10fcD
	LODrQpH94yLZMXWLGDOvBBQPnU64uz9KjfizLCJ9IaR5lanPtD83xYAj5m4ZQy1/Km9ilIqv+GA
	nw903kqMIuOHjt8XVupLpvAHcoPcYFDi8K54RcDjq22FVOt6f7AF7RKb5SiDYltNhT0E2w/ZDgw
	QgV5Ih8Mjsx0ZFNS1bvkk/Q/NgqMnI6K8UfNKc98jIoKrbINjPEmXWL1VWTb9JnGByNxdmG5qdj
	SY/0/wxKAc0Q0Ym2mQANM1XyI0cxayu0pY9dLjQGWb5YeLg9TEgRNd4jNgRN2Eku/89fNScAOaf
	RKmDAFZqBNGdAGSafqVgrviiddtfBIwx9ePl3niQ==
X-Received: by 2002:a17:90b:288f:b0:358:db7b:f686 with SMTP id 98e67ed59e1d1-359be30b2e3mr11977416a91.26.1773112380605;
        Mon, 09 Mar 2026 20:13:00 -0700 (PDT)
Received: from localhost.localdomain ([147.136.157.0])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bcc28f0fsm5169284a91.13.2026.03.09.20.12.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:13:00 -0700 (PDT)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH V2 1/4] mm: shrinker: add one more parameter in shrinker_id()
Date: Tue, 10 Mar 2026 11:12:47 +0800
Message-ID: <20260310031250.289851-2-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260310031250.289851-1-haifeng.xu@shopee.com>
References: <20260310031250.289851-1-haifeng.xu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE204140012
X-Rspamd-Server: rspam07
X-Stat-Signature: 4icu3eub17effebseo73zsxawrkgtjxr
X-Rspam-User: 
X-HE-Tag: 1773112381-5918
X-HE-Meta: U2FsdGVkX18ytM+ttQ1UFPY5DAdWi1nkyHZvt16SGkQwKL7ylJBS15hERaTnuzCypjrKq+FoMU1jfqPZoFqP6ydB76yGUbWvqKZL9JzPYhN0NrCk/Z3qu/K1hJoz0w66sT/RB3Lchbf1DlXbdLrtZBuH7ZTKhOFmJYmiu/hMdAHidwLaA5nySd01N/OQWx6+osskRXM1T+MDIGTwMca1TRohm/7QwcnRPTCCEubcA8ugnUvJhFY9Em00OkTw6rRPZz63oKGc5oN4TkcYolrVmyJAClL+4qs1kyo3its0jMsv8qXl+1BzGva4E+r8bbVxT982orTzwKmlzh6bcZItVBbqEbjWH+NqOrp22m3NtSLNPb7yCkhsSpreF1mv6XmMVecsSiJu2r0nbVNuMSFdHLKAxbXS80qUrukOrxWUKg85o2cVPHLKW7YNKTWRFuAlp7QJ0Cx1AYxRrYP9hGiULVC+cCFsm3BZDVX94TZDESUFrqMgg/EEAXJIx3Lkuj8YqZa2o2Eca/zHKMyFFe82LapX4FXgbGLKuput2Mc6uZV6liY3z8TpYi3KdkHSgpg8/I5Mp01zwCrK3wYIk47tB4/XyTCBCPZmswEseQLZvDAUzhYxR90mfQ4m9BpIq2mgW2tjDS0gxmA+lpg9jhAUWWPFl+jxkIPDeh0wUpUzy24Ekxe++m3aEP5DwEkntG0gyO6FYRLlTREj4R9LJMCchKkzv1ahxA4wjB4qxOvL/5+WiGbr/TK6V3hU8mxEcIbhBEp2fQRsQJuIcVDFnXcG73oIBKMchbo0tlZoJVvWdHo2iB1YTRA0rqsoubyZCrg3uS/792ZKbY9k6UwgkN9wRiVa7qx7ZLJ5Q41jn5BMVE3GJ34jPgaIiJImap7gZVPBWnI5mYlx7JbY+ViQ/byzGhFIw1KIQ69c42oFgvGo8XX3YzuJJ/LTUiQirdjoY4YTibyFWrh48TF/FdwDugw
 /mDYTrZY
 njc8Qs4Ae0UC/bTrh/w9Wkjpz0YPSn/KYWb8oxpPgkXOnwOx7KliqkdCSGwRmDtt7xPp60I1ek+N/Olte7vE9Wjp/0VnBeDdMfm56gUrSnb74BwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a parameter points to target memory cgroup in shrinker_id().
The following patch will use it to decide the id of shrinker.
No functional change here.

Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
---
 include/linux/memcontrol.h |  4 ++--
 mm/huge_memory.c           |  4 ++--
 mm/shrinker.c              | 12 ++++++++----
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 70b685a85bf4..a583dbc0adcc 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1634,7 +1634,7 @@ void free_shrinker_info(struct mem_cgroup *memcg);
 void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int shrinker_id);
 void reparent_shrinker_deferred(struct mem_cgroup *memcg);
 
-static inline int shrinker_id(struct shrinker *shrinker)
+static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
 {
 	return shrinker->id;
 }
@@ -1670,7 +1670,7 @@ static inline void set_shrinker_bit(struct mem_cgroup *memcg,
 {
 }
 
-static inline int shrinker_id(struct shrinker *shrinker)
+static inline int shrinker_id(struct mem_cgroup *memcg, struct shrinker *shrinker)
 {
 	return -1;
 }
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 8e2746ea74ad..6050f8d71587 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4353,7 +4353,7 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		ds_queue->split_queue_len++;
 		if (memcg)
 			set_shrinker_bit(memcg, folio_nid(folio),
-					 shrinker_id(deferred_split_shrinker));
+					 shrinker_id(memcg, deferred_split_shrinker));
 	}
 	split_queue_unlock_irqrestore(ds_queue, flags);
 }
@@ -4509,7 +4509,7 @@ void reparent_deferred_split_queue(struct mem_cgroup *memcg)
 	ds_queue->split_queue_len = 0;
 
 	for_each_node(nid)
-		set_shrinker_bit(parent, nid, shrinker_id(deferred_split_shrinker));
+		set_shrinker_bit(parent, nid, shrinker_id(parent, deferred_split_shrinker));
 
 unlock:
 	spin_unlock(&parent_ds_queue->split_queue_lock);
diff --git a/mm/shrinker.c b/mm/shrinker.c
index 7b61fc0ee78f..61dbb6afae52 100644
--- a/mm/shrinker.c
+++ b/mm/shrinker.c
@@ -255,11 +255,13 @@ static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
+	int id;
 
 	rcu_read_lock();
+	id = shrinker_id(memcg, shrinker);
 	info = rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
-	unit = info->unit[shrinker_id_to_index(shrinker->id)];
-	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], 0);
+	unit = info->unit[shrinker_id_to_index(id)];
+	nr_deferred = atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(id)], 0);
 	rcu_read_unlock();
 
 	return nr_deferred;
@@ -271,12 +273,14 @@ static long add_nr_deferred_memcg(long nr, int nid, struct shrinker *shrinker,
 	struct shrinker_info *info;
 	struct shrinker_info_unit *unit;
 	long nr_deferred;
+	int id;
 
 	rcu_read_lock();
+	id = shrinker_id(memcg, shrinker);
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


