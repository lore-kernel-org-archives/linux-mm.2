Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21CA2FEEF2D
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 12:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C096B00A0; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1605B6B009F; Tue,  7 Apr 2026 08:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D306B0098; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BE2C66B009D
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 08:04:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 781D01407B7
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:57 +0000 (UTC)
X-FDA: 84631628634.24.57BC16F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7414280002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 12:04:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWJ1LMFY;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775563495;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ULEUdMhZUNEEvbwDENCIaL+h1U+S+7UIKhUunTXnq68=;
	b=GMFueT52OGTGBT/2nZXa+j3D8CQlY8dBrrVQ9jWZ6l3EdTm4CzjJd2+vqBKD45rN6NsXrj
	rBvVvlBjLgb3ERp1445XxOJ4qcP8zDVBd6X4BIu0lAkEXHffiJs7fPBLiw2pKAL7k8i0S+
	BjhJxX7cWyw9qmV5m054/g5hen30It4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qWJ1LMFY;
	spf=pass (imf30.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775563495; a=rsa-sha256;
	cv=none;
	b=vHtIlHtcsEzcSqwzcl/a9dLXjdL3wRYLd5Y0HpLE65mUD/l3O5mnsVKY8BFp+qqYOQHzHf
	0A9YIA4x20YP8wol7R6/yYYAVhUL+MgLmCs6yYN+ioj414f/sEUC/ZHiQcW4/U1ZGDv7kq
	8ceuAz2Zgb2pjGKkooh4e+l1aHeOKVM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E672A446C7;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C78A5C19421;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775563491;
	bh=fUTYYzcNXoeJphxrjwgg8eyMN86yT/tICs/nPUgAkC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=qWJ1LMFYZ6n+2nYUGNOi1Uh1fdr/G5AbnDlcMoyL7Htq5FWbeD/PqHKgWvkWRVA5T
	 jv+7H3T1Mf+7Gk8KmnSUFXNOfs7s/0Pdi8y/V2IQWD8RwDXoLgXfGfDDr6hNYuQRym
	 VEl/85SAssFRwwEvu3QY23oKQ6tw6amcH+XeVZxyCF7cjmO675HL3X4oMrZiwop+mI
	 uY7hpRH+AJDlb17xjtfRGj2x4jjBIcK+yk0pLgXcyPzcbUmyBYW8yRq9yaQMXNrZY6
	 LuGp3XeZMe74kikzHn+twcQk+u+lSHEXNUZw1IF/Ix/FtX5PEdkKEVcWkKNjRtrILH
	 PmnnUmUV0TYrw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC561FEEF31;
	Tue,  7 Apr 2026 12:04:51 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 07 Apr 2026 19:57:38 +0800
Subject: [PATCH v4 09/14] mm/mglru: use the common routine for
 dirty/writeback reactivation
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260407-mglru-reclaim-v4-9-98cf3dc69519@tencent.com>
References: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
In-Reply-To: <20260407-mglru-reclaim-v4-0-98cf3dc69519@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
 Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
 Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, 
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.1
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775563488; l=2942;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=nPwwx1WfwADmlvFLW7DWeULDk+8fNcH1ArJSvQdlFwE=;
 b=fmysAzwJH+E/zuRFCACBe/2/eQ+jx4Dmnzi7FbSNE/l5AQUI7sbEVw+fARwBg0RnuNWroLWCx
 DnIJMDdPyNhBfuETpf/5zmxodAP5SDoKX1SwBM7QGv39CPvhQyxyCXb
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Queue-Id: 7414280002
X-Stat-Signature: hrudahxmet9qtzqu6pxjuhrykef5ci3g
X-Rspamd-Server: rspam06
X-HE-Tag: 1775563495-378532
X-HE-Meta: U2FsdGVkX1/SQwzkeU8/zor60HQKhmd3V4w8NStMTkOxywe+2olbKkVwD/hB9KCIgb058S8rC6JCWjNFODRIIq7wF8CxLRR58LR/lfjLE8jH0W8qf8urP1Ky94L3S68gJaZmJYbJxhph3w7yPz8vGoPgtwu4ZUi/dswflf1E0r5A0N/hot83MX3nSNwlfkQqdIzYNwvVRfmc9rNOn4r324i/TRh2ftZkDa82jQ2Ipq15UFzsSRqWmoGJRBdCFxYdhjlZTaZd81wbWx+ngqN/t8hyO1VhJquEKx5VkTNnozFhvxF/aczWZUYO+JX9zV5qiOOvPGFYA4QR+xamH5oUJ6jddhQiktNbzq24e7d6mqu/pyLP/ei8TNeBMMoJleVI2WFGE6GK0tSKB/vEL7RtBPPy9hUFzZefbILnTCv6KQwXnHzf0KMw/HEp/1rfrJK6TUAjTz9KwMvaqqXghpdXSWjojafnoSkPoIvcMB8CZctKapllVx6FEg8zzlRQBfwTyw9Tlgnj7ua7t/KwpQ9nMsktCz3JDgI9ZUxfV8hvOpT+ruIJxyYaZslaZ2l05r5v7qbffDeaDtkpINjAt0+vZAlkXIkiR+5w1sxybvyTVr0yIYw6WNnDwxeBk5jzwWsfXqtSn6bj1RsF4g6iEAgqsJpVmrAKYy1/b6u6sfwJYmijZZ/qg9+SZEVHeBLd4QDnVncF1CYF7dfJ52HPN/oJSnUGesgrEQ7iD9nPUYYUG+USYOe2enSwxJNR3VhGQoDWg2TviCpdiUShBuR368st6eAgIIxJAbismjA/j8BW4bmewqYRLvKmdSu68oHt+jVANfO+mdHBoRtTKapHFnEJuI/yfkonexhNeTzGbEW2eghk+aa3KkIHfdL2n4Z3HSFU6jGboD0pfk1cbzFTdRqFbzTm5BC558FCx9i8Mhh1ZJHxVzGCwHpNxCCC74080vh8r1p/UPK98v0msdM/UVu
 7pRmHKh1
 H0aWaMeyfswGcQyd85Z4WFvKayTrfzEzTqJAg4boNg4DCPaHB3Ye+bxOTpj13emd/Lvz5FRFpeLyAfIyh9bFVNdJ2lJlaj/z+5jDePh7F18CzwinALPK2WjlF+MwrdHCiJvETuXoIABNLfifsSG1I7/vKzALBxn2qZ2hGjVnduy8CV1ilbkjl3Kc7dtQEOD0Z+em5yYoKQFi4tlQAM85UBP4UZJSUrVjvHo6rgiby2e6zwYVSoLDtOnDT35fSIaStBgUnv19UZEdRsZRct+dOXu+rA6gCpdMD9wSDZyNCuWNSd7MnXIaGLEy7vuQeluEcXc2/NflvCyxuByoGam68wo7HIdBEdOy7q4I6zAat4x6aijAurVIZtRXhMbJMp4X02fatOdAFn9n+hcGhOQabIrJv86BKwJBJLqU0GhGhyPCaNZvlwY3Z3xDntTmRXtm6ccQw4NDh9u71+zn8R1TCWfYshQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Currently MGLRU will move the dirty writeback folios to the second
oldest gen instead of reactivate them like the classical LRU. This
might help to reduce the LRU contention as it skipped the isolation.
But as a result we will see these folios at the LRU tail more frequently
leading to inefficient reclaim.

Besides, the dirty / writeback check after isolation in
shrink_folio_list is more accurate and covers more cases. So instead,
just drop the special handling for dirty writeback, use the common
routine and re-activate it like the classical LRU.

This should in theory improve the scan efficiency. These folios will be
rotated back to LRU tail once writeback is done so there is no risk of
hotness inversion. And now each reclaim loop will have a higher
success rate. This also prepares for unifying the writeback and
throttling mechanism with classical LRU, we keep these folios far from
tail so detecting the tail batch will have a similar pattern with
classical LRU.

The micro optimization that avoids LRU contention by skipping the
isolation is gone, which should be fine. Compared to IO and writeback
cost, the isolation overhead is trivial.

And using the common routine also keeps the folio's referenced bits,
which could improve metrics in the long term. Also no more need to clean
reclaim bit as the common routine will make use of it.

Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/vmscan.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index b60cb579c15c..2a722ebec4d8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4578,7 +4578,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		       int tier_idx)
 {
 	bool success;
-	bool dirty, writeback;
 	int gen = folio_lru_gen(folio);
 	int type = folio_is_file_lru(folio);
 	int zone = folio_zonenum(folio);
@@ -4628,21 +4627,6 @@ static bool sort_folio(struct lruvec *lruvec, struct folio *folio, struct scan_c
 		return true;
 	}
 
-	dirty = folio_test_dirty(folio);
-	writeback = folio_test_writeback(folio);
-	if (type == LRU_GEN_FILE && dirty) {
-		sc->nr.file_taken += delta;
-		if (!writeback)
-			sc->nr.unqueued_dirty += delta;
-	}
-
-	/* waiting for writeback */
-	if (writeback || (type == LRU_GEN_FILE && dirty)) {
-		gen = folio_inc_gen(lruvec, folio, true);
-		list_move(&folio->lru, &lrugen->folios[gen][type][zone]);
-		return true;
-	}
-
 	return false;
 }
 
@@ -4664,9 +4648,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
 	if (!folio_test_referenced(folio))
 		set_mask_bits(&folio->flags.f, LRU_REFS_MASK, 0);
 
-	/* for shrink_folio_list() */
-	folio_clear_reclaim(folio);
-
 	success = lru_gen_del_folio(lruvec, folio, true);
 	VM_WARN_ON_ONCE_FOLIO(!success, folio);
 

-- 
2.53.0



