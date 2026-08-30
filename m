Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD1BC61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 11:47:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF9AC6B008C; Sun, 30 Aug 2026 07:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C83DC6B0092; Sun, 30 Aug 2026 07:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B73356B0095; Sun, 30 Aug 2026 07:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BEB16B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:47:52 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0DB571402C0
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:47:52 +0000 (UTC)
X-FDA: 85157761584.08.E747C3F
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf19.hostedemail.com (Postfix) with ESMTP id 40C681A0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 11:47:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OV74n5fW;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788090470;
	b=Syxxj15zPGkETBLUZbACE5rPSw12s0CDVbh0wNxFb15atnP3Gr8MrOOOjbunpnDkF0+bdE
	tisS18u2I2/kJY1knNUvCCWvsBZZd1Jn4pxwoJTL+5TDVObn5h4YfKzYLqFdMJvtQIU2PG
	RZzF+t07tc1A2QvBRUTKkVuGqvkyFZQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OV74n5fW;
	spf=pass (imf19.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788090470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wo0HLGDj3y3Y33U9g+Ukt7jsaJQ99Obk41w4N/1Rf1c=;
	b=qOMsO6gWCkQhhasTrFBKNy+PnG5xidLr/P8LqSZFk/a4lTT376l6sgEJcm6gn+xl0mupMu
	jJuNJgv22F1mJyn8ea79Pncw+j9nIPY15Huq2qWUncogyvjvQjLmctVlIQnodp3DuuszxU
	CpX5YjNyJwi6DHICd4F2cSH4qu9g+QU=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-848643382fcso2719495b3a.1
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 04:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788090469; x=1788695269; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wo0HLGDj3y3Y33U9g+Ukt7jsaJQ99Obk41w4N/1Rf1c=;
        b=OV74n5fWKG0vuLSSbIHq9/506UQhQrTUYVWorjsp9O8o3++OPIELFt0zL9NHolsfu3
         vFEJdsv+GcHMRlfpklKtsrfP9ICiNCXh71Du6qOxtXwDE+2itvldZnPJtD2pdgIfcI1y
         nxFkTwnwuRvoZYAnV4Oi+BwSSocDSxAaymZUyL6kBk9ci/EvV3oFW8psSO5c6hUKHdvS
         e2XJq0FUdQJG0neGulrlLcuuFBbDD3TYpNx+mDgoSWEmio1paHQNYtQekkjejLf9EV3E
         W3NjFSYWc6VXKWfOfmE18ZTuVf4z6aNXqm/PcTIsf9KxnXZ79vat0VgW+Czl3gVALsNG
         x/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788090469; x=1788695269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=wo0HLGDj3y3Y33U9g+Ukt7jsaJQ99Obk41w4N/1Rf1c=;
        b=n3DJidRraacRUIThT/vLdl1CrAUky8qOruH+DHcQvcbQ4Km57keoTXu9GfrLtezD2b
         gmXBUlLGfHnH7GsPZs5CzWhsNkwHBDjCS75NkAPNNOSXVctzT4aHcAxwn5nae9DIvtbw
         d/kA1VcmO8Ii0CJSka9oovtbBLRvI8lcSkkRN73DGVyfItvt/ACtH5uhSL9lTlYYh/rc
         KyOHFXDwcxnEaE90K0IX3c1W1Hytdb/lDDQ9UWUSlH42Js8ccT49im9wNGSwFFqTnlOJ
         llf3WUVBey5kk5zc5J2hB1uF4s79GNoMxRLIXeq4/JMb7jGbOTpV7AB9QwLm9thMtIop
         BUhg==
X-Forwarded-Encrypted: i=1; AHgh+RrUfAsF5zxpS5/yznkKz2fAufw4BaurrMQFtrSSb1FHE177M8Z5lGSEtLuvIQEeQE1Y9p2ZzRLptA==@kvack.org
X-Gm-Message-State: AFuF++nB0mzZat6TE0wrBjmDl97Lmpb8QCVD5rs92v/JZncbHAeKtu5R
	XsjI2QA6MUVIyFd9ZJQ+ibKiUFG5y0VLmGh/HMJz7f50HsJLdmOgNPmR
X-Gm-Gg: AR+sD11k4IbDPAJvUYcpC4e0f/MeoADYL9wcWdpeHJ9hglqdYn30Yo11H3cqTaLfOuY
	ceds6Uo6bHqsQxITEyjnf0xtbUOr6Pihs+kkTmjwwiZu/wtwFsZxc4rmM0rEiaWu9fZf2ZfPAbv
	4xEV+tnp5dbCiEnrmCvB8s5KRmqwkxcRR9lEmgIyq1/c7GF3+vprC1Cy124NsTZHzXUbV84BSq4
	kWTkpRcLSmgYJmlRD1Z3E7zOPh4jQehOB/yMFfyoKYYMbCCwZp7W0YNdwtEBIh2cj7Wvktp6LaJ
	vPJVwOHU6aw27LQ9wpimgvuxTIj5FB8FEXnnJHYgvfIZ0fUhU87ipdbh6OzVBaUTIHoNa03/ck+
	tYWn3IbdlpJ2sDJGtp6hzgO92pT/FbADY41dn4g4wDabklqOpcs2/gQHXEmEYdbYBJ8Xz1lftCJ
	ANGlKS/D9q8RsKoNhIa5GgjAfHDLVFg0gW+NY/RnDklskckHykGGlrcY9B72Th0B+v6Xxuo/Ju+
	DYOTQ3A3wlUfev2f8225pcg/+dXQt7n966w1A==
X-Received: by 2002:a05:6a00:14c1:b0:848:8619:c149 with SMTP id d2e1a72fcca58-8562868db75mr29260125b3a.2.1788090469003;
        Sun, 30 Aug 2026 04:47:49 -0700 (PDT)
Received: from NV-J4GCB44.nvidia.com ([2409:8929:a7b:121:d0e3:2a32:8ea7:5ade])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-856a397c0a7sm2395264b3a.49.2026.08.30.04.47.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 04:47:47 -0700 (PDT)
From: Jianyue Wu <wujianyue000@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>,
	Chris Li <chrisl@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v4 1/3] mm/zswap: release retired pools via queue_rcu_work() instead of synchronize_rcu()
Date: Sun, 30 Aug 2026 19:47:29 +0800
Message-ID: <20260830114731.8322-2-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260830114731.8322-1-wujianyue000@gmail.com>
References: <20260830114731.8322-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 40C681A0003
X-Stat-Signature: rw78mkrrmqga7ck69xt83gnbtbkxcoqh
X-HE-Tag: 1788090470-197530
X-HE-Meta: U2FsdGVkX19Ld4L9KVWJl/yRwNegQaX/0K7ii0vspAc6GmrQ0jm0LP46bO3zm1G6nGrrSmuXTiRlmdAzOE6nkWbu1tvhbStM+rIqKLLTjWqKZYK0im0AX2UBZ23B8JuDw3ioQvLyFM2M6WX6RA+Rtx8JzByH35jdIcyzqE9AOc2dJqPfAoVW7FZ/uzeFZS8/M5+NPSv3g+zvgsXujYgYHDLg3EfOV/MSHzaoj4I7mFPPwX9Sr4dSwrTYaOP4SwRrkYIlFKLXWj7eLHBb3wxBX+2hAe+qksreUg/sGrMczXs9yvuixdydH+IIOCjTtmmMugoj0Ztxg1iE7V9IcwORZQHGiB4IaTrrNKQJXq5w9j2rQFcXt8MQSFXAwDc6nk1jCx8NlHn8mzKdkxT/Zajougc8/ZG1L8G4/zmNa+FOUJKz59gJrpDL6cgpn/pffLmGoniiOx936uBaNV6bJoI2y48eAS+ktv6jwnIXXjeu24dHzot/qToWjbXoupbRFRFLzFuVtodTYQgvEIOy1PRVWP9raDYpemfsYApNYlK8Ziwpqx8x55/UeHdE68ZAUebLtcEiD+7gc+XfCIpWKTkM3Ph2v7PPvZ+5ZwjQuZ+aM2m9oXpoPhlTmhgNpn+Ugt6XOfMtTd502aBQi/HnE7Cc272178qw92er+zKSATzuqCiJfLviRBjY8vx1+ywmQaz0ENLkOJPk/LNo0vCA6p1+VtW41uEAP35kwB2CPjOdhK4Z27to7H97u+fqFzeZBWCrMb1cwNyHR68Uj/iXmAVlTzOMPfh3Rq3o4PH7Uwc0eDnRGh/lixWPUSmD1rD1XEE+rBVRWvQKvGGJv2STtbu5K3M39JP4QNBpWAlHAh6Z1DQO49wN0/VvbyUxVjF4j+9r4xSnEhfRF9jMV19guzYNsZ6u4Cw2IUrivyF4TneY9qsyTOgRpfIHiN9/3wb2pcGCUGDf1uycJ4z2sVfKunu
 zr2OUQLB
 0zHPIkXuY7GDROF+hl59m6T/qV5MPBNI33IxloAGKG88LS6do7ItTVyZIcRwlUxHk01feqdKjSB2/FJAz5S8iXyEsF11uISq53r7qkZTjaW6ogy4bx37HGykqzulos2OvNIzN/Bpv7wv1FGclH4xrugn+A9mLef+MqS2LzBixkQMbcMl3ZN//iimpXleWlEiyyL02pQl3i7oC+YSUZc1Gr9jb+mzEginfZDg1CyDcgJ958awockiF2cgfxf2ooRSbXQxVnQCV0xSSPX4pt3wGP3E1jvxMHKa305r3u2wEKHUvjUohJrMpqXssJ4oQPu54lbZV4KrRtsDH6dbVRFOD6EY39LRp7DcSQklTizwaFZD3WPU18H78H6jPbO8ZnCDVfGTieWBpXllbKvGTxJ+/hkC0rDrHYKFYGH9tEdve9LXyAeDAJ17mG2MpFOH3v3JP4gJqYGxbQFx67oRAGk/JeVRVPNrYV6aBWCNE48vP5mrf36PgxgYMtNlVYYeNyjQnQQe9eXFH5W/6Ax0=
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
---
 mm/zswap.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 37f34e406c8e..0bb30e58950a 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -155,7 +155,7 @@ struct zswap_pool {
 	struct crypto_acomp_ctx __percpu *acomp_ctx;
 	struct percpu_ref ref;
 	struct list_head list;
-	struct work_struct release_work;
+	struct rcu_work release_work;
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
+					       typeof(*pool), release_work);
 
 	/* nobody should have been able to get a ref... */
 	WARN_ON(!percpu_ref_is_zero(&pool->ref));
@@ -406,8 +404,8 @@ static void __zswap_pool_empty(struct percpu_ref *ref)
 
 	list_del_rcu(&pool->list);
 
-	INIT_WORK(&pool->release_work, __zswap_pool_release);
-	schedule_work(&pool->release_work);
+	INIT_RCU_WORK(&pool->release_work, __zswap_pool_release);
+	queue_rcu_work(system_percpu_wq, &pool->release_work);
 
 	spin_unlock_bh(&zswap_pools_lock);
 }
-- 
2.43.0


