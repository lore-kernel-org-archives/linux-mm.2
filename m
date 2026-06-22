Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A39CDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:25:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459A96B00A9; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A966B00AC; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347BB6B00AD; Mon, 22 Jun 2026 10:22:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F065C6B00A9
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2E5ED1C46A3
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:01 +0000 (UTC)
X-FDA: 84907762842.27.E5F6364
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9E5ADC000A
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QUp0Wth/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=puPk2Ddefrwi4QR8TAOwiDa4CHnnPF2438al1RR4Mt8=;
	b=jogfeVB/tG5Z/jZ4e0liQrGcz97DNyyhmPGulxjlwWTmTRnIGqPbmSI/nZbUFvy/MLOptS
	WXDx7ZQSJ+oOkY/pt0c1w2a2fbqQQunPV9L4I+JPE6hOwRPoutyCZSzidOZHc9kcVESRPK
	EQAfCpf/mX87RxUbIVtwo2ymkTfafVM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138119;
	b=NQWFgp7oXhoG6zixY78xAW/Z4jXzI3th/nnL/O2rR295ZpwLFn+WKgmLL5qp/NicJH2Rs7
	MZYaBBSAOmjbRp58vbitFFPgLh0YmYdlj/TFiXPMcmXwqzkxSdPN+noeR4ayNpOzdZszAU
	TqbGi8oQWw8ojbctjhAGU8ihNuMui18=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="QUp0Wth/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 48CE9601FF;
	Mon, 22 Jun 2026 14:21:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C651F000E9;
	Mon, 22 Jun 2026 14:21:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138119;
	bh=puPk2Ddefrwi4QR8TAOwiDa4CHnnPF2438al1RR4Mt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUp0Wth/A6Ba7BWOcQyRqcKlJaIBBQZ9A3kJR2XGOeNy4BwwcQ4PRnxleEhv+ETiS
	 M+CA9lxfgv3Q0Be0W04GgplpUwWD33OGOQGybxa1w0reugdqIjRxSRbIY5xgve+xM6
	 bz5mjHWRL5MnqmZw72x653OYYrehlTlXwLeSKT2mA14XEvKEEltNO3uQEAnp+aeqle
	 OzjPdpE9XLYCm3dzvdbFlr8WR2QVQhzAqWbya/YIFc3W7n5VMI2tPE0IVzxm7IAv4F
	 zknN4sWP4Rfi1dy+7OCZ7UXuXjHR5CaJI6VQKBSnYgkXA0mIKnPwbphrLgnIkj08XU
	 QJfrhPNRZurNA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 10/18] mm/damon/core: remove damon_verify_merge_regions_of()
Date: Mon, 22 Jun 2026 07:21:30 -0700
Message-ID: <20260622142139.30269-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: ur7wffha7r1qkz49katayg7pc1m1zy6a
X-Rspamd-Queue-Id: 9E5ADC000A
X-Rspam-User: 
X-HE-Tag: 1782138119-22649
X-HE-Meta: U2FsdGVkX19zjUKYBm0J+NRY5jsGVsSpTpnvRICAb9EB7J09Zve7NbThg6Cd0fqk122NWTHSzjS6tpLyIkD6LbqsuwAvhuJ4ipcrUpqkKMJai34Zkv502ckmdOQUUe8T5ooYroWmHrP0EFae1iPRcFJkzHVGH426aNBApPS3DFXTh6A1LKrHb/EWTdYydNvph7s3MEe/QDNXdzyD8MTgz1O5QqJ2LIapOR2PY7PN/fEVzyVYiQEdSrnzsi0RYBumC2fJZW4x4XlR31P5a9lbF1mfJSGxqbSTFvdg4QDTp1hsdRTe0rz4KEF7eL1cXfMFmueChfohj2BxsJvp52xfjlKYELYXnEEq+IoDnXPnXvxlXeOs1P0V1qGG/S9j7GejSAdOF9eCepu8bqlw0JR5o4AHsC9K4Am9bnxxgs+eyBQVHhxRBRhGlIItPRrJMzpIKCR+9X/B61CCjfTiKKI/nX0KLUlxoaA8fWJc/kbNB4DwWPL4mXiJ+LQPU/I3FrDyH8b/aE2vVbu0WtDdNDCu7Y48DvVzRERqdpj54KeyrZI4FYZzGGatJtr1JYfbqL2fz/z7vqttlMO/jPaqv27cXwU84/3oH+ym6Mk7YPLN83LFubjHp9vH1EMKAu7uAAU60ySLlFFZo2AQZCVAnSSYRl3i7diVTF+UWfdXs1rTh2ryvMQIQoct49a9o+9c+Q3nImV3X1yX/1c/YPoNKeUD1a2tsAMm6q35l7EOuNc/RFDOTIwHPiE2+iKvEvEj3wobvJeUK4XvvqvNSxe8RF2avGHbwy3StDfvFaAB1Q/3cLq/RgnSmOuo3UGGb/d7o790pAKoNvmM7m6+5CcoTi69/si5hWPfuT63oYHZQvgw+wAvYIp7Ue+QpxF4TSjtdwuXh1fn4i8TynjI7c378x9QCw38ycAsoKtnP7HHVQzmMPVl1hWsf9B8/1bmc/KBUURvcMOHKCkBsI41k4lLJ7E
 4Kl59CDS
 W+tV98+iz7yq1loCOu8CJaoMIh2TfhJJAJ52y1I7gBjDqt+v6cDM63NZq5RzASulKp8fNOkZtJZaKrx8l68pGnDl5IIPxoktBo5SwU/rq8q7IVWNvfi3DhSFGgXVl05K8xPdyYQ37A6cva851F+e3en6QDP2xq1Ec0hLnpENudRZVME1Dgzkrn3zCivYqVqp6lfwQW65wy4cIsGrUYTNlAUyHxxym3GxC7p7d5r1UoqCqRPEWbiit7lHC8Uju+C/wu/fUaXlyTkDEFEuRFlnJCPPuGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_verify_merge_regions_of() is only for nr_accesses_bp validation.
But nr_accesses_bp is no more being used for a real purpose.  Remove the
validation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 84052fa009158..80c1b34062312 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3117,20 +3117,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 	damon_destroy_region(r, t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-	WARN_ONCE(r->nr_accesses != r->nr_accesses_bp / 10000,
-			"nr_accesses (%u) != nr_accesses_bp (%u)\n",
-			r->nr_accesses, r->nr_accesses_bp);
-}
-#else
-static void damon_verify_merge_regions_of(struct damon_region *r)
-{
-}
-#endif
-
-
 /*
  * Merge adjacent regions having similar access frequencies
  *
@@ -3144,7 +3130,6 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	struct damon_region *r, *prev = NULL, *next;
 
 	damon_for_each_region_safe(r, next, t) {
-		damon_verify_merge_regions_of(r);
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
 		else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
-- 
2.47.3

