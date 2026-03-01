Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A938FFD0072
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 17:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B186B009F; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3C16B00A3; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756326B00A5; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC616B00A4
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 12:43:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CFCC213B912
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:34 +0000 (UTC)
X-FDA: 84498216348.26.EABDFA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C95C1C0008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 17:43:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lO29yu2E;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772387013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q96gGoQlF7U98hvpGvjCFYsnd7QkE1j3lim2Nmlz+5M=;
	b=0hjlndOo/dj9J9qzQkMNB4iENNuYiYJKTFhiEFSE5PCe8DCwJoBWFlqz+05ROZckvrt+EU
	7YFK++CmuuTyHsdXpmNTj473bHWsSxicCcdWY00goecTEb1AFzAyb0p0MHVUfxdJZyAq5d
	r0zB9hfoU1I+3gClm4ah2PcQxfGSC80=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lO29yu2E;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772387013; a=rsa-sha256;
	cv=none;
	b=tUwn3b9AHr4xGefr4rDO3j4G0sxVaKcgB1Ifbcn2p6qj9cb0ybgEYJpoQKbRzd1jcBPm26
	zalgpz8Pb1UYtgWRqxYM11gocfaBqAB5M1B2YY6EKcPAq/KKmZhGiY1nG7hHtMotLxcZEt
	SmrLjAaNY9+x37nIaJJj0i52Iq/GG9E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 16FCF44499;
	Sun,  1 Mar 2026 17:43:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC9CC2BCB2;
	Sun,  1 Mar 2026 17:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772387012;
	bh=h0Fe5csr3sldzD6TLO83VPiRoEMNSXNoD5pNU6aZzIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lO29yu2ESlUHUzzR1nxvpCUFW3x9kKowPe+dexg3bbPFDyTPyO1qAg5OlX63GVDZJ
	 6QX+67cOGEcsKE/cM/xng61jC257qS2nQr8mAcDiSo3rGdV4S64yuB/TfZAlsG1t/6
	 FRUxCmpee3sP7q1l8PPnjz88byam8eUUxpahEtKo3v1BNgexzauiThP7xbWlE2Cyig
	 TiapquwJwPYGpazfGQ2LUtRaJ8UwgkQRoqb7YVE3sNU1I2oAUh0tfz0Iytyl2Zqs53
	 66WyiSxAO/9BFrtpN3hcC/7Y2MFNIJQgeYLLTun6fIU+C5SS8Lb3kpWJy3sfXZxHIR
	 GOb29K2ZilHng==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 03/10] mm/damon/core: add damon_del_region() debug_sanity check
Date: Sun,  1 Mar 2026 09:43:18 -0800
Message-ID: <20260301174327.76849-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260301174327.76849-1-sj@kernel.org>
References: <20260301174327.76849-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2C95C1C0008
X-Stat-Signature: nmr58kmuk9fzbex8h86u5nr8nu7yoekx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772387012-46874
X-HE-Meta: U2FsdGVkX1/NfcatyUA6FhvwHHWKOcwYecTJiwE1bmkjhIZOEJrpcN2l1rbfR80ozRI+brVprfcYR8WTf95dVsjOIucpiVHQyddikKHC94v8PozyNSjZTcH6hCoZCoJmxRjEKaeLnpANnJHJgVZw7T8ScNt8VSBwKOTowp1KI7NjA4V7Q9s68l2FrelyEyD2uyFDwdAcr+oZSQQkkm16m39YfLgtHyAf/bkOa80Dy3YD6n8goj9olxeVROjS3l3ontqXllw11jyQihQ/9BHIydTnE7dfuCl1NF1aLZlctjw+tA6CPJdXN/4nqCN8QtXMMydFISLd5o/cPJjrV4LzyIcLuY7aC5OGNz69lhC0vFxs/o9zucCuPAAbNeoFKC0htry8fIAczV8Rw1fsH91zyMx6X4VI2Iw+IH/NVpc/pkl8L3YyoWBoSQzWbnkcydNrfxX+PtxmY27Km20LPb/Jm3TbH9cQ8ypa+/1Pfn/JUIJ00vk2BLf1rdVgT0xTJUeLBzdcCXPZmlYcXdFF9AjovxWe5yxIEFYUtIYU/wTbbnJX+SNUUvG4l5NDVlsXT+0kxJSwscl7zhwFATTronZBfH3iSt2ziR2vG7Z6VJ6Zfz0dlGgMkmKNcyd/p05kWBifmF5Qu2f83nZFZhIZaaLNGYJZCyVoK1EtiQNbK6mLmHZuwzqokIK/pjkI5bGWU4F2ZeKN549yo8hRBTD4m8SYnxyfP9rtBbxG+PQsyF/C8eWQyxco6vbOOu4DL7DR/dBpVnDgwpqRBWqkEEWYkn2nh0QRROG2fVOkvmjUMJtTdh8DnxhzDfnR5GiPZ/UozfyD0gjYCWbT39rLmbQxaB13Cp4Vy3Q/lC6GCwxshSNCSIoLhUZgBjaf/93ZGFIPj1PHkwPNfya3T3XsLRuQihuHC4qLIQsvayd1XSuE1+DqzXkEVWU28n+wrzG3gMVF12g0fHje57PIE+tJTjYYs0/
 T4R8XmWb
 FYll0fWPb6noJfzzXVSAH6WhCcM207h6w20o1pQfE5Yv0G+JmHAfkEw6bWKZTYw/ur9BScajI7n1Hjhn4DYge1eCmHNvAcl4OiJEctzlUMJVLXI5EEB4xgOLlFwoypTnFzPDwc+GSBmBqc4ThKFLN+U2VknBIGrVUSdNUmnlT9YdMl0vOpRO8cygXpPdBoZ0vJusRWiDKiE2uhaWyas3z8ChUl8hzDzyT5YNydo6Vu/xE+NzufnaSgpy5Hi3vzt0g1w9xxNw/1OsnG8j0VyCa25qLnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_del_region() should be called for targets that have one or more
regions.  Add a sanity check for that under CONFIG_DAMON_DEBUG_SANITY.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0c1353164ec81..92eac5eb96026 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -152,8 +152,21 @@ void damon_add_region(struct damon_region *r, struct damon_target *t)
 	t->nr_regions++;
 }
 
+#ifdef CONFIG_DAMON_DEBUG_SANITY
+static void damon_verify_del_region(struct damon_target *t)
+{
+	WARN_ONCE(t->nr_regions == 0, "t->nr_regions == 0\n");
+}
+#else
+static void damon_verify_del_region(struct damon_target *t)
+{
+}
+#endif
+
 static void damon_del_region(struct damon_region *r, struct damon_target *t)
 {
+	damon_verify_del_region(t);
+
 	list_del(&r->list);
 	t->nr_regions--;
 }
-- 
2.47.3

