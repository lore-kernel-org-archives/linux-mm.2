Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DFCC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 07:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1A116B008A; Sun,  6 Sep 2026 03:47:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9F46B008C; Sun,  6 Sep 2026 03:47:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B8DD6B0092; Sun,  6 Sep 2026 03:47:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66C8F6B008A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 03:47:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03C8CA45B3
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:31 +0000 (UTC)
X-FDA: 85182557544.13.BD728EA
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id 162C340002
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 07:47:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pF0kDvJj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788680850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cfzhdafKOPcmowjGTCbLXY0Cj8hfEc5olvSFaFljUsg=;
	b=aFMLEBfIRZ/Qdrjf7kEBWLS9+cltOu9BJp2xwUMsFE96EI1YgOP44OalebbsGiHrqYMCPZ
	0rz0qE+Sd06QSQubkbvnHx/riy+PTQTTdUEyji+R124Y6pJKbdA9daNJv/2c6jel3Ck9On
	a5eF1inYj63Sdp1IfOMXTb5UFivdL/E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pF0kDvJj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788680850;
	b=fC1ZNrKgn5/mjA2Mkaz3zi68M4NJRNwYM0Ab1jclHEYr6uoiwzh3zJHAFoKzRIi8G6R2iE
	5slWtCCkVVFy6zZRMTMwlNRWSMxgxUotzkgzl4CttUuXAtnTXq2t4gRu38Y9q3pkl8BnV2
	tUTySEhuG5jHH9Jde0TMwBg9xMeBtB8=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38e58034d05so1985214a91.2
        for <linux-mm@kvack.org>; Sun, 06 Sep 2026 00:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788680849; x=1789285649; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cfzhdafKOPcmowjGTCbLXY0Cj8hfEc5olvSFaFljUsg=;
        b=pF0kDvJjVQlEc77aTpPyKtpoJfy95izmjRMFBZGyT+VFyinNGW/f/9PctznhVK7pTx
         dkpnt/O1EFeULqNGnkUSjShv1DW990YvjmePm5so02xOSN2KRCjpmsAGMiU0Z5fv4Xn0
         dCnXO4IdAUHwH3rHilJmnLcVWz8PkTYKHigr8I1uiEPFFA79RoAZnA5y7I0Db1UyjVDX
         8VsWgcRYUfbZycjuZqTtaBtxo0pyXL1ZBzHnd3EYCpE+UpSPj/46Cv0/mDX+SKHWbKms
         G124SpwwNofrI3Ja38VXexGErRxF60iqqCbXDTDZjBpEAgC2xBC7lcM73tnGeU/O9lXy
         bFBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788680849; x=1789285649;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cfzhdafKOPcmowjGTCbLXY0Cj8hfEc5olvSFaFljUsg=;
        b=e6G61GM/q5cJ5rmaz5vv1VC5xu6bi0GVY1zm/bh5q2Wc8kplGZpGBNNOjkye3jhj6d
         5fDHAguSdPtwTqIyg3bkAUrVhrRx2oezKMvpGxtr+xa/i02Z31GTc3jp1VMe9wCupL7O
         WgWDwqYUAxFOnKDRzaZ4nphpyZJlcCsX1qtrYLpCrWc0GDXDUFQLsnW6m9YsKhQhSlsy
         HCdeeCbqA2GS1BLLNThbkFldq4Jwbq0HPkCiLzRfr3jQC8zXCPdaSgmg9KdjqyScnRm9
         m0gV1VVSjL1NtIBimbRqsLHyq3/3JLh5fLdJeYyMu400ccO1iXTGN1UNp+D4WD4YxEMe
         LnPA==
X-Forwarded-Encrypted: i=1; AKwUvBz6/v90/NpMMqNuW9b/WKCE8koQRQtoLcko6RlxPsm+S1Ggp4Ng1f5+yf76gNxMuXWHnW79mQoEIg==@kvack.org
X-Gm-Message-State: AFuF++lRgJDoYUJTnyUUs/VSQrSa85mVi66IpM+IPcJQUrZVrqbjRKCb
	Ki8ZHBFIcp5MGYnTpF+hnS2J1SBs6j+p+GVPUiN+sX37n+zwUFDeb8Xj
X-Gm-Gg: AYBFou3wwITlDAOqeEHjZmYK/xR5NLsp/MQs2YiGiCYmC8dRpaGBAolYdA7ZJ3h3Zll
	8GoUyMXtE3p98ZIijZODKX64Nr492E43jsxTFk52xPBZu38rZ++PnDEazVQ+AE2zQr9wIZDS2+9
	1hS8YGud1ISVXWwyCukXLLccLT/dO5C3qqz6NocSaGb8i0abFm927hd+v4nJIVG8FWmYbWyWj5K
	BgEall0DIprh69N84npkmSvW5ur+3FTecipbw5QHBIlT7SKESkmvV+ElG722fPH5i9IbblpkEcY
	kfhRIKTaZ0mzMA9VvCAoxElW8OTxoF3vnaF1h2o1TqMD1BQL94/Fdr85PWoZgwCS2HogQqpt6Gy
	JrYM/mSM49TgSmHIUWXOzRwXCjaSdJDcYaI7E5xWAcV3cjx2WZuuNEKxTxYQUtIyZgVbApQgXAC
	kaQgAconma3y+S3LhgCs4tju7cpK9T5nMJpZ4i2LEc4o7kzmj2eMfBcLGixpjZMSuSDoxKHn2LS
	jNtNwg6BkjsIEQWEZiwFSwIxr5GekMxYp90cKI=
X-Received: by 2002:a17:90b:4fc5:b0:398:9be6:f996 with SMTP id 98e67ed59e1d1-39b262cee58mr28681622a91.21.1788680848803;
        Sun, 06 Sep 2026 00:47:28 -0700 (PDT)
Received: from NV-J4GCB44.localdomain ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08d0d7e8sm21138905a91.16.2026.09.06.00.47.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 00:47:28 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
Date: Sun, 06 Sep 2026 15:47:17 +0800
Subject: [PATCH v6 1/3] mm/zswap: release retired pools via
 queue_rcu_work() instead of synchronize_rcu()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-shrink_zswap_entry_v6-v6-1-ac4cf61565fb@gmail.com>
References: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
In-Reply-To: <20260906-shrink_zswap_entry_v6-v6-0-ac4cf61565fb@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jianyue Wu <wujianyue000@gmail.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openssh-sha256; t=1788680840; l=2137;
 i=wujianyue000@gmail.com; s=id_ed25519; h=from:subject:message-id;
 bh=WwjbCGbpKx3pybwGrUA8/VZT5w49m4g/k61kb6kkG0c=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgW51Zh3v9nG0Wlld2Ti8ylp1TnO7yB
 H+z9CbXty/WEAQAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMYNV8pIDrz+M/tSuqNBmingl1zVngKIT7QYZIxy2wkQbA4+uO1BijhHckb3wo/z69o0S4pYyv9
 Nlj2JS8UmdAg=
X-Developer-Key: i=wujianyue000@gmail.com; a=openssh;
 fpr=SHA256:gVWBPJbHGWlCIw+V8F63Ff0k21S7AB5+rZt8+huemvg
X-Stat-Signature: nfaom4d9ypjfd71x4cqpnyx5mureca44
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 162C340002
X-Rspam-User: 
X-HE-Tag: 1788680849-931647
X-HE-Meta: U2FsdGVkX1/Dxu7aVKPPtFjL5f9NGxwfen5u2UfUDqtCdYVO2l+12uRH9X4ufqSlfM+zrDrINgMn//tyDwXSdu3X1+kj806Zfpoz3kcGOFv9cpImC8t94O/HaMvTVpGkuWt/OJuPnNeGbits8G+ElkP7ZfCDshXNbjy77Z0bLm6RrwFCM8XPCcOFb3mrnLbcBBBy0qtgTVXZBZ74dJ+e/sRSGGP83WHvvEubMeSRUdKJU6Geviu9r1+cHLr6ff1IXOo9MpQh3Md3P/ExyOOf4ccsCW9lGd/Jd8kLEL8X8OqyFSxGKbzI7NB6ih0gfjNNJoPvLbt6ShZNYGzb6UEnOpPDK460t6H07W9KupxRk422rdDyYCUXTf1JWfcPzOV1eEZe/dTmwkpxzVhzyi95z+vjdPFFtbFVBaDcFUctNsfr392S+bwfc4VT+hIi4RJGKFOWlj1g18g8x/gknx1JtLOfoB6hhe8pRswIYGV8lDRv2m661TQP8RmmaRsNi5UEztOnXCjjX4sD1R3ZsWfXtEKv9Nfq8eM7oQ4GfpbO6qlW8JG0i6rmHxLNNcdC68kBZv675L/SpBfO6nCJdHgUZb2aaz6GDI4hEej5BUnjZDzyE0M4cp+P9pI390j6T512huRzIxVD/XmNBJG/jtXJ24oCeEok6RysNavVQLtbYtEeEk/8I9V0CFh2Riz0Jspo10843E+cUXNhF25axoVDU5yItDIg4QxUDXOvvzBLWlOYCg2NM4O1iPjlFlRPdIG11s/T9Q1F9DhOh+A+oWcamyC27t8M+6xvWPPXlerqj5W+8PxMl+hQGivCP3okseEY3GRuGqX6oz+MkBTS2lnS376v1VnF/oNsJ+OUXMbXq8N4zdCMEeZq3BDtIz5zZHO7tfNd6mFxKkQL/FUA5ymD7UwYKhrJXo4vDo45yQLoMolykGtjXqzljnCb76z++31P4NLn84tqbNZQy3bj5ze
 xt0dsfnu
 uXboRqsu1HVinLX6oOBXRDjgdI39PJLu17eMB+Y+++V/AYZP/k7zPvMOiVzEn3aWKq8zd1BdTja4dAXhF3bTintYkAT5RbIGOiYH95w9YjPxrKcDkLbVRp0pk6WpLsv2njTFAPLpiCT7mI2cc44zJCgZiDtHkk+QwRV0GjJmfCoyys23SySYb+5UxP3lQdFS808B4kadwSgQnUM16t7zdIYpxCykBggETgB8TDvjc0wc0yGSlQ44+kCTyLwrE9tNK7lgY51H1NooUqA2ZUp/A2eK1M+qgr0MJx5fzJRazuSG29xFRhJRyxVDKIZawEW763T/RSaxim2d2fEPaeEnSYYCc54Kbzo87muvTejhCDhECxKiteR0uGeUXFQ/NqYiRNa1wuCyktlrO6+AC3iri5vhZfaThz6sapC+ADb29+WM0In8VNgg//YhByv/Pvh+yAudXkkcI7ipXzYUUuO48NzTez/VZIIwDTUKzNVnt3Z10ITqHRrcOSOz/GJeoY2icYWpVg78AvPD/4FQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a pool's last reference is dropped, __zswap_pool_empty() removes it
from the pool list and schedules __zswap_pool_release(), which calls
synchronize_rcu() to wait for readers before tearing the pool down.

synchronize_rcu() is a synchronous, potentially long wait.  Replace it
with queue_rcu_work(): __zswap_pool_empty() hands the pool to
queue_rcu_work(), which waits for a grace period asynchronously and then
runs __zswap_pool_release() from a worker for the sleepable teardown
(__zswap_pool_empty() can run in atomic context and must not block).
The grace-period guarantee is unchanged; the retirement path just no
longer blocks on it.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---
 mm/zswap.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f3ae3c81e48e..e456e5080531 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -155,7 +155,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
-	struct work_struct release_work;
+	struct rcu_work release_rwork;
 	struct hlist_node node;
 	char tfm_name[CRYPTO_MAX_ALG_NAME];
 };
@@ -379,10 +379,8 @@ static void zswap_pool_destroy(struct zswap_pool *pool)
 
 static void __zswap_pool_release(struct work_struct *work)
 {
-	struct zswap_pool *pool = container_of(work, typeof(*pool),
-						release_work);
-
-	synchronize_rcu();
+	struct zswap_pool *pool = container_of(to_rcu_work(work),
+					       typeof(*pool), release_rwork);
 
 	/* nobody should have been able to get a ref... */
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
@@ -406,8 +404,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	list_del_rcu(&pool->list);
 
-	INIT_WORK(&pool->release_work, __zswap_pool_release);
-	schedule_work(&pool->release_work);
+	INIT_RCU_WORK(&pool->release_rwork, __zswap_pool_release);
+	queue_rcu_work(system_percpu_wq, &pool->release_rwork);
 
 	spin_unlock_bh(&zswap_pools_lock);
 }

-- 
2.43.0


