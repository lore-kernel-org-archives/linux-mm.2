Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9451C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:08:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A17036B00B1; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F8E6B00B2; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F1856B00B3; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 400DD6B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 990BB140340
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
X-FDA: 84935247138.28.461A67C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 13A20A0008
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVIJXHC6;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792508;
	b=RcjD26ol7qV1er4ezua53G1Lp2oxSwno0g4oocIoLtN8VS5Y6qBH8xp381CKtQw1jQ7q8R
	t+e3Z+AEQl2oS8XS67Qfp6P17mCFtuC3kAcLf2OrgzQ/L0tqhc7jFxKypsggFE2lOHWvkz
	jwEMDG3JI8i6mLzI7faCGM7AHXLRlgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yfQjprzOnvA7X4Lkapy5NoOzGVbkDSS1TbGnomzln1o=;
	b=bcoKIxSqsLvkWOyN77q7FUV4xtpVDqk/Y1169ctP9rovUNSgzOclHmlAnfdAwUSDabocEQ
	QQiPJQwuV+h+LDgNGHTel5HyuQ/42tkIil8medY31F36oMIse1YSHJXekiqNs0PTx1ODpD
	B8UaBkYWX3EaDNaozfk20Jjv4hBSvVk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVIJXHC6;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DE688600C3;
	Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FC3C1F00A3F;
	Tue, 30 Jun 2026 04:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792507;
	bh=yfQjprzOnvA7X4Lkapy5NoOzGVbkDSS1TbGnomzln1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VVIJXHC6Vw8ORLDT4fJrVGyc2qkVlERLV2YH2Kgk/RQlxH+MtrdW87rGGwXS6u3oP
	 3QIJiiP2d0KalJALBdTKmZp1w7KHmGiN9LSwS7cjmv5ju+JDtIc7yzcGc7bnh1D9D2
	 X0fwfz3h5eEJXPayNGdIdTBhyLi4OXWutBz8wWpjeuuozWskWK7Jbyzq58QaV/k7HJ
	 URUvNiF0/Tx/+n2N0tZukiKLp9LMBQhtI4/s+bRxZD7MTeIoeMCvFd52AgomfV3Wbw
	 VpOxaP8/rZ2Xa2hm8VxujKCKYCoiinduFE91DZd9vtomwdzlt039/yEXr8SXsPVu53
	 Ptt4PDGgZ5j8A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/18] mm/damon/core: remove damon_verify_reset_aggregated()
Date: Mon, 29 Jun 2026 21:08:02 -0700
Message-ID: <20260630040812.149729-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13A20A0008
X-Stat-Signature: 91fope4dnp7gxywdw7pjii6bq9cjbuj7
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782792507-66054
X-HE-Meta: U2FsdGVkX1/9shrNf2qK68DgyBSZ0OF7zuqZjn7Is/a6SoEWDL1cHugIGnylKXHegedDudkRscLf85pUsK+9PEJegvb97XMJcQlOSeTpd9boPbsDxoyhOf9g3PwbPBaPX8ZX+YFTnGYEkHuwev94WsMMqXwqHmhVT98/C+fEEma5SlaG0qcRmrI7dhQ/KANqplBFHqY28wvKa8CZOQAmyvCKKB1f45cF9BQrcKkD3SAJDYMiANH6Y81pfgmJmtrmlrhVFAf0ejOEIJFbmAo1hCOWfA8gPGCSbPoo1kLBOprqoMb/zgI/umQccQ/Qtt2UpLyWe3luc44eRhuW82qU2H0DV5Gq2cUllE4YFdU00CDVwDOgfZhGDugHvyKSWm59wve7PWIip64Wyc0wkCa9KVP6l/+zlV0cWA4LG1b+UEMkG/oteI1GulwELTk4EdiqXLaBx0WNkQ40p04JcRR6D8PbRzpZXb1yM7C1BOuPclqq+X3Y6TSk2xhedbO3+mY0z3Hhk++J1Cd5PMlT2RuABlcR3vvA9jFAoS8EvFeU3DgiKOd5jaAeqWqvGpFRo6LMK51d5T+onO84r16MOZ2CU4lSalqj0RFos5Ik+Qx5SdKKHEwX40siXynwliUBG4W3SUXMxY3KFbSJX4MUa4zqG+wKs2ZUIpEPeCDl2ncKK/sFrXQsN1Aje/kmXk/AbN3UO7065m4L0XLt2RHhWLhrg8wmBLoXLCP+4/K7rI10wZNjKLFrWqJuK7fxQSWZHTut6V336QgxqKPbo4tq55n5KE4rHtpJe3qmY/kYTTSmn87L+GbB347F/xu9vztJMagg3/fsKIdZGYsmCpRoaEZSzdzdj3TQnZc2CD3OtmU+8BfYnpKUPETjGsMxKEqERuh8Ab1FWrCOPIZaaYzlahuKEWl3rzHTGKBo3VTi2Wy/uqQ/13efeCjDLR9gVKjkKzaf9vev6GAsh0zZiEZ1ZnH
 1ZI6lo/4
 OLIeMvI+uHWtMVVAhZ7dUDF91zHFCW6jW3t0QC8vBRvz6vFPyzks/XO5l5ji6tvsfgciCu37ydvwUSN43wU6g/qUXmYCoYVWWFVXac/GAlc26NDI/7mHohd/U8MBhHYSulg/+XW3Mxa0d4FXq+iup1OFOwYBpa1amEqyyUdXMktAvL0QuUK2z2e9ImwpNnr7mruYsdNMMxUXij/SdB+zAiPTTG11Bb5T4/UkQe3DnOi4ueVNe3PRWIpcpibSMsTbzXRkqW+tkK4SkAzZkUu/zLLKCyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_accesses_bp is no longer being used in real use cases.  Remove its
validation function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 634708475c01b..bfef6a8556c8d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2006,23 +2006,6 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
 	return 0;
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-	WARN_ONCE(r->nr_accesses_bp != r->last_nr_accesses * 10000,
-			"nr_accesses_bp %u last_nr_accesses %u sis %lu %lu\n",
-			r->nr_accesses_bp, r->last_nr_accesses,
-			c->passed_sample_intervals, c->next_aggregation_sis);
-}
-#else
-static void damon_verify_reset_aggregated(struct damon_region *r,
-		struct damon_ctx *c)
-{
-}
-#endif
-
-
 /*
  * Reset the aggregated monitoring results ('nr_accesses' of each region).
  */
@@ -2051,7 +2034,6 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 			r->nr_accesses = 0;
 			for (i = 0; i < DAMON_MAX_PROBES; i++)
 				r->probe_hits[i] = 0;
-			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
 	}
-- 
2.47.3

