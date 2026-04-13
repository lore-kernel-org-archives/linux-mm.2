Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95775F531D1
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 21:16:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5CD86B0089; Mon, 13 Apr 2026 17:16:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0096B0093; Mon, 13 Apr 2026 17:16:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86EE6B0095; Mon, 13 Apr 2026 17:16:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 931306B0089
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 17:16:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A74F8AFE9
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:16:13 +0000 (UTC)
X-FDA: 84654790626.02.364C748
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf23.hostedemail.com (Postfix) with ESMTP id 71173140003
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 21:16:11 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rHacAEFF;
	spf=pass (imf23.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776114971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=J6XYsoy0hgti9UjRylPOMBsVgDXd9AkuOGfbur3GU+c=;
	b=6MW96dEo8anIo9+s1vYv86HtwVx2kF3ok/y40MWvuUnzoSjWxUu6/Yh7B3w0LqTGlqpOAE
	+CmS33ihlDZsFD/P3c+ui4r+TM/Qp+O9TI8bZcaurudK4zbVGj/efK1dtXA4gqa6GTFmia
	26JW8j8kekRK18ZvoRWJlkbwUQN10Fc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rHacAEFF;
	spf=pass (imf23.hostedemail.com: domain of nueralspacetech@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=nueralspacetech@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776114971; a=rsa-sha256;
	cv=none;
	b=U4vw8HnNv7WmzKWacfb87vfGbLVqDXhUr5uSEWHXX/GcjUL+TmTYeQXMe01F6DPDtGu83t
	pLG0xGoCwdtjs9fahr3bmWVEmd+bqCGAj3BbN+2bsil1zgtQILrBM30wfY57w8+9Tf6w4a
	QArYSpREjehi179rfy6C7Xu0FFNsvGA=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-82f1dcd5886so1659298b3a.2
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776114970; x=1776719770; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=J6XYsoy0hgti9UjRylPOMBsVgDXd9AkuOGfbur3GU+c=;
        b=rHacAEFFQUq9FxrgYOsHSrZKFxwdUOQrhCET4ZgoGg2mfCdURxHuH41FiHj5dY5RzL
         nGPtIGyt4ihLpNpULB6N9FrXVPhPf9xk9Bg9Jo+MV1xMFIogQr9WnVy3uy0CErw25vsE
         3iWzA1/jDu+ZrO0yLWtnttMTy+GATAB7rYc+IwJI+RThfynUTp46dF120qBo+Rrgy7ru
         bqTpmSJNpbl4vQfzG4qmsKZxzfR0BiFdzMt9njpQaXIy577UB/Joigxl0cC0/GNOPH6S
         kgaIgDFncyGgxB966OJoFA69/J8nqe7aMjMqWRFAdVRsUnP+BA2gzTO5mB9zS1hy89Hk
         4Jig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776114970; x=1776719770;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J6XYsoy0hgti9UjRylPOMBsVgDXd9AkuOGfbur3GU+c=;
        b=It669IzfjJnPWnBR+dRJvkw+70PToEVJjbFTv1uEekhP9JcJK5cQTGeNkPWt1NkSgx
         /x5nYvgdO6kB+QHRvEvlxYdryOltZdTzWiqCp61pUsbBMw0ePT858oiYUCULF9lX6v5U
         /1Y7xFh0P3z5fmA2juSqtx1GIZ2JHHowzXN827BnNygygLRzOEN1bpsAX8H2ZvmGDpdg
         qTRYinJyWADf/9bqY3Gi+d9e8NDRlEnq6RC0/UsXP2NKFjGzGw0lui86wA9mITFb2AJ8
         HSeshjqcE63I3Zq4SqytUOydbdnnOfGEAVhkhtjHP4q927AODnM1b/TnJlGcPPvXvTXa
         fNFA==
X-Forwarded-Encrypted: i=1; AFNElJ+Ja4l/dDIzyUn/s/HoU/TrKtPv1TubNv4aKdhwb2qtdL1X7JcVZ0awzHd2Ix1of1g/9lyaIALiJg==@kvack.org
X-Gm-Message-State: AOJu0Yzsty3c/ktb5pHS3tzEVwJmetdtJkOxjKiE6To+gRXOqhbUBT2Z
	m/PK5egQJNkwn7ej2KplP1KZay6AVaK1qtq5E5srW6aq9xaC6xsCS1MU
X-Gm-Gg: AeBDietLloSPseeDYNZbOfsGTsAibaVjSE/TsFyS3mX1TyaA5KW5+kCqEQ0jAXXB5og
	JE+42v0xQZQr5OFPkB1HyF3lp3zpgxzn3ChJnsQoeR5OBE+MV74LIUyRjLujqZ0VRdnO/aNLZ1y
	tkCcT7iQ/GfuljwjrKy14kTTfp38IQAuLzD6h/7sjorMSzWZTcojoE92+ikBFBJWYSscFesNrt1
	i1MqWKzxPXgOecBt/eMxGqghy0lguKEAo9xscUWcrYK7vlQaeYAVt52hUQvvn2KDO+vFtJVG6s0
	TLAg50HnCmmfsvaBdsYfPbpE6bZnHSvxWhT6Yf+0rO1lCuhGibOMK0opUbg+vwdek4vMgQ31FAR
	2EW4pBAinKhWyzhFv0gFYVefOrC9CMESBraX3wu2KvccS6Er7i1R8fnOQKx++jrijCeQFoXeidY
	yDpaqSf71BmvqgOQxZZJDi4Si9ETDRBDtkt22+m6/Z8ruO
X-Received: by 2002:a05:6a00:278d:b0:82f:250b:9f1b with SMTP id d2e1a72fcca58-82f250ba2bcmr8529329b3a.23.1776114970028;
        Mon, 13 Apr 2026 14:16:10 -0700 (PDT)
Received: from tech-Alienware-m15-R6.. ([122.171.18.84])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c30ee32sm12822124b3a.7.2026.04.13.14.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 14:16:09 -0700 (PDT)
From: Sunny Patel <nueralspacetech@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Sunny Patel <nueralspacetech@gmail.com>,
	stable@vger.kernel.org
Subject: [PATCH] mm/migrate_device: fix double unlock
Date: Tue, 14 Apr 2026 02:45:49 +0530
Message-ID: <20260413211559.20969-1-nueralspacetech@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 71173140003
X-Stat-Signature: kao6w9apxfhcgy1we3mfdozzi444e5hp
X-Rspamd-Server: rspam06
X-HE-Tag: 1776114971-518134
X-HE-Meta: U2FsdGVkX18JctcxOnyFIMn1hAUPdJKIu7vrhVxIu9nQZtMpUIzBkj60ezmYZgAik6SOZwmjQmmU1+kMvLno4OnnEzVA5O1MsJaN1IhD7Dz4vb2o39gFfuwYcDJK3rs2yDljxgMx9EY1nH48j6lTcY0a9FTPaYnM1whJel8N3OKKWfperf1fqREv27mg8zDb+PqxJJua69gSgTiU2m7pPxYeilfF93VppegkeZHqT+9Ir6AhtId+Uzr1nL32i52WXdYKF9+0QJ64E0Y7xLsKp0njaDytl8fC27PvponJceeqLoHdRh4hjifbQ9VfwTuiCyTcz7LUjxlLVYrEKjHkRHuoeieeBpnghcl4/R1gY0gU+Hurq9y+UnCpeUrSZAH7gOUr8EJlbYud4nFVN8gEbG6TjEY5pBwOe/qWoLBt39ab1/8LNTK7H9QOAhEYEKRDqS9e2MJdL3bC6pAwKuR8Bc0PkXdFXFbMQXdodpCK5ZIBd+42VNarhyvw6w3H6ETyp3lfrDk1IRnXfKusLkEDLz1/X05bC0m2LkxjTYmk3CkllS9RZ4Y6MPhs+Xttj7uFLebqQBsVA/RUwQFb5/Cj3LUcA+Y3rpWppbVEak6cerg1pPFk0/OpBkdcD6qaKKi1qtjys+uYwNJmjB5ZE3UN6hM8pTRxbnG+IkGZxsVZWycf+STUW2/GKadRYoJIPAQ67odTalcLeGir+CdGWFpuQRRk3TaqgagBsjWdm2QZgrfcu2Ty6hhaa6eZsbj9jOkw3vah3fvX8d9S8QoGQWCzVglioL5RTVkT6/K68SnhiWR0MD6GZQQUZ30GnMNxC9hZZx8urz65Uon9nArRGoODeGRU3KazrziV/LhgeHZO/7ghZPVRzcsNpAEnzHJ8FCMRTghclUMt2Fe9Xif7ER28rmpsOQrhqkgBwRN4ykJMaWjEcRPWfBl9PN2wVtGgmQ/h3QrH5ivD/U44ipFwyK5
 Zk2JlbEe
 zI/qeCag3FbW/4hgCWXVpCn4arkbK0bWhdtFKAfxBuurlaZq1Tq1w5N6ntR2MFNYwmKk3FEgcSRW9EvnzRl0Rcli+0tRCzNkUOR05gk16VEhMen8rgQAPdDpTjdaMu0h+nk4bd/LsbAjEDLll34IKB7ZMsOhpVfRVlBV8To69TNqupYYPUMk/VkrIXFuxXKVrccKATZ2AFittcoF9q5JEq1kxdqQHcXVKCLjr4sc5nsPEFxzxoGcwVde0Ll3N0WbKAWIErYVXvbxkuAWBr8uPj2lSt6PiBSgiFC9T77cEH7Jb5OuWAPpOW4P8kJwfbyf2pGwhqMH2nWknTHevCLRG4bjXVJBa266yVZ8Scm9JvITyGZNiE5hJMk8rgmpwKkDdhPkRya3Rkeeas0JuxKDMI2RPfF7yGtqHErS+k8S2qd1eTO1hsnEIh3dcWsuywa5E9MiroNN9SljjrPuTt+lEkoAuWniE7fSZc+5AUKsB2DpdTyRDNDUEHIWU4J1lOkxX/Tpo2qo0dYkJwVzZ3o3JWzqzBpfBhrWdKLn+R5f8qH7zBBU9m3RUJX9tQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

migrate_vma_collect_huge_pmd() calls spin_unlock(ptl) after
softleaf_entry_wait_on_locked(), which already releases the ptl.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")

Cc: stable@vger.kernel.org

Signed-off-by: Sunny Patel <nueralspacetech@gmail.com>
---
 mm/migrate_device.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/migrate_device.c b/mm/migrate_device.c
index 8079676c8f1f..7eb2f87ea39d 100644
--- a/mm/migrate_device.c
+++ b/mm/migrate_device.c
@@ -177,7 +177,6 @@ static int migrate_vma_collect_huge_pmd(pmd_t *pmdp, unsigned long start,
 
 		if (softleaf_is_migration(entry)) {
 			softleaf_entry_wait_on_locked(entry, ptl);
-			spin_unlock(ptl);
 			return -EAGAIN;
 		}
 
-- 
2.43.0


