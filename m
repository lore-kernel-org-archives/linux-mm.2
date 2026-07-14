Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9924BC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:15:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B678A6B0092; Tue, 14 Jul 2026 04:15:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B180C6B0093; Tue, 14 Jul 2026 04:15:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DFE46B0095; Tue, 14 Jul 2026 04:15:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6F2CA6B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:15:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F013C1402BA
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:47 +0000 (UTC)
X-FDA: 84986673534.16.E10BCCF
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37B88A0009
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l2a7irxS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784016946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5f2zwwfkcjVdLU+tnkGLj6NeYVD1qAWbI5zgmwCL7z4=;
	b=cZoc63rqh+DGSxDm8qE0komAKQ9hJzv1H0fJboAzYlnYI+Z9XtsG8P1reEBrBFM0eewn/O
	xEZhZ4AIVerj8JuUGGEFYR0j56hVw6R0g6WN/hVEPCv+VsXVF/DvkhAYozna78AWmNvoQm
	OkkhVUhvR56eGc7qBSOX96G2nZPSef4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=l2a7irxS;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784016946;
	b=UvhkUyIotQTOz9R693IBkWut0G8i7gC1lmw2Bp8ivJ81h9T1wnX6rKuUNTzsgd0LFjJcmS
	MwAWjMQQ4gINVT9NW/aZ/UrPRy+O13OBGTkgtB4OZW4exP8dtKBsYzcz2cYuwY1ciWGgz8
	6okltwq7FSF7MfjRg4TGZXfjj1EltCM=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38511175ad3so3216919a91.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784016945; x=1784621745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5f2zwwfkcjVdLU+tnkGLj6NeYVD1qAWbI5zgmwCL7z4=;
        b=l2a7irxSeUYQl2/fpDTupZBln7w1unNgG3+kA0n4ECHllxoXr66FPrg0DOp1MRQUJS
         UUj18tsdb0oh+lq3eBG01pWRB3dnERvkqkCA1aRmqbmuCBcdAeO7LoGnYhsdYE4xbOZM
         suHNqvWdTVivzmk70iyT8OqbPh91/b/L+pBQjt1TVA/L1GcH3un/rb8TjGWkrHzr57fB
         pXqiQgnyM5A1um8lAlm0mXj8GG7LlMznutFo+kYRcDL16RGFi3SB5bC/3Brp0N4060gD
         ZbfiOLJu11cwazjQnve3zkOMNVdQOcZ95Pdo3b+gnKpbfVhxguO84I61w7LTZ0bGLHCr
         BBWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784016945; x=1784621745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5f2zwwfkcjVdLU+tnkGLj6NeYVD1qAWbI5zgmwCL7z4=;
        b=NXxeWYHOkMuJTgHNuNDbTK7QFYK4ZvWYYdroIUpQ3r71MXjXNxZSrH0ST7lkE4Zdvw
         tWoHod2brgOf6rM/QNLSpedOyK8kPoWgeC8915cQOwQ6/8bvwWLZeZjcvLdWmlffMFha
         duc1yC5GBvCzPGIYIfhcq73aO42PN5cDLt7457+FkFThMc8N4dOVopXzk58UdgGuCYSp
         fLxR9HJ/NlHkJm1ZWYP7wgWj4rCn3mca4DLHKm+o6A1ngtflnj8FxY85z+8SpbZ2ivSK
         uTpJ8/yg3xIqMkZl1rKFne3SaLxrIyruoy1tp/dOaX+SftXOdiENTjJ+CnWs7gpHjlGA
         TbrQ==
X-Gm-Message-State: AOJu0YyhJykdwdM5luxS4Dxo6R9MvMj0apeVybRhADlkBH+wd9Rtbrac
	8TI3cLImYR4dw6ufrAsOczl5UUj+ZP+HrngRtMHngy85usDqaDYlBR4S
X-Gm-Gg: AfdE7ckRHIMbkUMuRxIKGjFv8okiRbvZ90Mhli5DPq3R8jgFLa3krP4blhmuI57WTu6
	MYUyN6c68IXTr07GHYEHwtwKqcVac1JBgqO3z+lae0tBhE2uRMuBA1oyC91p8bGb1GgMa8DvIbO
	NNJA+wqn8sPp9t3rx5Eieh2OvIptHzwG5fKAP37xLWFp3IBlwmCN5R14zP1UXhGJ9WuQq0ZBbct
	UJEwQNNEd2T2MCuOYy0i5xcDu+UZP1GtMo1Ke5jtHImXoxO1XAKFzP+1zATg241YrazBNtPVVVL
	eT5ExcV+sqzlsPuo95Mg4w7EplEPZVWZksi4I93OAbB0RVUAcT+9jcPKqkcS596ZDu6cYvLL6f5
	7/FYN9DOXo+ScTauIehs2fOJeCXx3f8vYnwqk3s8/WvNHVLt+sqAcQzTbp1VV35ew6LctI28nsP
	G8XxmxfyyksdsW905LeSJ88o2dHEoSjzyHwdX+docHrAk/hEHq2ao=
X-Received: by 2002:a17:90b:4a90:b0:37f:d262:1e0a with SMTP id 98e67ed59e1d1-38e1ae9fc51mr1541369a91.12.1784016944718;
        Tue, 14 Jul 2026 01:15:44 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e17443f4fsm1091008a91.11.2026.07.14.01.15.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 14 Jul 2026 01:15:44 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] mm/zswap: Fix global shrinker when memory cgroup is disabled
Date: Tue, 14 Jul 2026 16:15:09 +0800
Message-Id: <20260714081510.16895-2-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
In-Reply-To: <20260714081510.16895-1-jiahao.kernel@gmail.com>
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 37B88A0009
X-Stat-Signature: xe1m3rk1jbrp519rbmjrfwrgg3g5cd63
X-Rspam-User: 
X-HE-Tag: 1784016946-339469
X-HE-Meta: U2FsdGVkX18+GvcWoiiKxl3/vgxmrPq/GNoisCR0g04ynd5OaZYE2xhkcDrp1yaEEDbLbOd/Lxqrj7TaTzcWW+jFKuFZKMfuOeegipWqpbo/QBMhHEcjBBDS1gq0ttotytopZabwr6JtbEH6b/3zn+fRT6awkAIfFIdilQe3oUu6yuGzl3bn4A/HpYeDyANumn28G2drUtWxBHmRZinfI/RdG3DTyNwG2VbEcVivYRw0hUQrkJ41gQlE4JAmy9IQ16LJjj6s22NFWU/Cmd15yHWkd9lJhhXpLz4kv57TkA5YkUcKaAPSS9iXL6JPWDDRLxcQq9Oz/sUZUOfcW0xgyFndDxQJifAYWySb8pyknVxOL9YXLb4nf3372+conUcwz3jlu0JR2+7ekauaLWjgSF1zhNiJ+9ugaOutLctK5HWjFVRgBSZzHQQnUTnTpegOShQPsKBL0SVTQI5vy2qxHc60NJpBxG3dwS5tfmDSGIa3z1O4SW1A9ephicWqX7R5fzXL5Ahn9kOp1D3WrrmQveP+HExEuR9/VYr8BI6aW7NxYl1TajnWOCM7N8MPbKYw5CoQxT6e/vXtugDyFMsM5bdLUVLx/HEEtCADsbwIoyUiOpWNWlc4g7KTH7gppKNt+QQL4dSkX/opUPoPdfe7OSNEGE2kmdxoTzNfpF0qXQvfGjkvWDsV0RNrk8NOW/+ipKOSzkcHsT1/o0mONiJUhZTaUAxymk5bIZUbUsMw42bTJNQdRaJGn6bsalpoPyOXsQ3cURqdUcSGWbW7EeDT59RbIJl1h4UB/7pEvDl+sWpPkL0pDATGSiOILoGWxyPQpzo0g/x0pgHQKembGCcfgbNmGR1qaSRtQIYM+uaRG81/QYFEPBNJy/QuNyzSdBnH93tzY78hSBA+CO73kjWziSHlCB2v2qMPdmNs7pPM4vdrwOmKM1YhWzQmIC3/7Qn/IG3w9ttgFGyM0UJijKx
 4sky/9aW
 yTyr48OZSOza9pq7RgIYjm9XHSrxnYoEQvavAuUxw8/9TKpF4fIV0jShY7xHW8oM4hM43gkyxcYdVG9LAg1+8H8epPePxjjibMeOEsSuc0IbQZZlDhv3k3qBtmjofWujdzMkmpJJHP0/owGVCIGwaDqFHqPAgEJgUHzRASMwwoUzoUR8r69+JHH3WEjY2DeQYtoiBFuzeAH6jxXMWUrZJPOiG391PkrWoOnvyUS3JxoqcJn1wUlcBBPn2990NcXWa+hbt1BQf+B1uwx49nMti6NXHUeIolf0oLdsZy5sMulx1TOycmbuRPSdK5Tc0fZKnXSImie/8QaFjyhXfwFD78NO2vahEnFdYeHEfeScRA4A5EYhAe7eO6I3y8xpU9Vm88zZgrvHlqyDyohqnO4EcEZKUZvIvWYPmha3LwG5DaLyUhVhJhl3D481hbTt0e66q8uJcrl74C2ieKyyLr0Mm+l4AdQv0NgbXb8VqToGx1eldGCTNr4BAyUZ0zNKn3vgVYRziKch6YLO60OjPpCmL5/7Oug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

When memory cgroup is disabled, mem_cgroup_iter() always returns NULL.
Therefore, the global shrinker shrink_worker() always takes the !memcg
branch. After MAX_RECLAIM_RETRIES empty walks, the worker simply gives up,
so it fails to write back anything.

Therefore, when memory cgroup is disabled, fall through with the !memcg
branch and shrink the root memcg directly.

With memcg disabled, shrink_memcg() only returns -ENOENT when the root
LRU is empty, which means the total pages are already below thr. The
loop then safely bails out via the zswap_total_pages() <= thr check.
For any other return value from shrink_memcg(), the loop is guaranteed
to terminate, either after MAX_RECLAIM_RETRIES failures or once the
threshold is met.

Fixes: a65b0e7607cc ("zswap: make shrinking memcg-aware")
Cc: stable@vger.kernel.org
Suggested-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
Reported-by: Yosry Ahmed <yosry@kernel.org>
Closes: https://lore.kernel.org/all/CAO9r8zPVzMKFbCixxD-qgtRrkFxWVrHiZZeLc=eyTPKPVQgX4g@mail.gmail.com
Signed-off-by: Hao Jia <jiahao1@lixiang.com>
---
 mm/zswap.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index b5a17ea20237..3d697a1a5365 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1356,11 +1356,12 @@ static void shrink_worker(struct work_struct *w)
 		} while (memcg && !mem_cgroup_tryget_online(memcg));
 		spin_unlock(&zswap_shrink_lock);
 
-		if (!memcg) {
-			/*
-			 * Continue shrinking without incrementing failures if
-			 * we found candidate memcgs in the last tree walk.
-			 */
+		/*
+		 * A NULL memcg ends a full hierarchy pass (except when memcg is
+		 * disabled, where it is always NULL: fall through to the root LRU).
+		 * Count a failure only if the last pass found no candidates.
+		 */
+		if (!memcg && !mem_cgroup_disabled()) {
 			if (!attempts && ++failures == MAX_RECLAIM_RETRIES)
 				break;
 
-- 
2.34.1


