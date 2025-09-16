Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50149CAC597
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3808E001A; Mon, 15 Sep 2025 23:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BB8B8E0001; Mon, 15 Sep 2025 23:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1478E001A; Mon, 15 Sep 2025 23:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BAB68E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:23 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B65B411AEA9
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:22 +0000 (UTC)
X-FDA: 83893698084.30.0FE458F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 10342140004
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iCaLOGwZ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKkUH8eqHSbRrPC/yqn6JI+WIlNfRwd287k0stUFNgU=;
	b=k+7X0R0pw8u8q9R8cevgfcuVLIS2j4jGnrXBw5ZeOqKsuJUgEb3idpdRe/Dqthtdsjk0Ct
	f0JOOPtoqXZv0h6gFURDvkQKo9HOlhbzzFOW2OjUmFyCqu+D632y8r+jnVnee2eeF+aYIc
	VUsgp37T08CsPamK6m5Gf9pnY9l/aRI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iCaLOGwZ;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993721; a=rsa-sha256;
	cv=none;
	b=RRLFb/5dR1vZnx8znTdV3oSqLWjLnJoYwGhOE8V2Yu+IBwjBsm48x+1GwxJXzD8fYrAZZ2
	/T93pvQWmbD+hA52u31yP0C50DmGVIS/AdLSHuNxOg+6r0L/BT59FZbxrS4Sg1laiOrL3P
	ed8YX15yMUD0bjugrPtqtSlT0hOYhTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2AC2444B27;
	Tue, 16 Sep 2025 03:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE366C4CEEB;
	Tue, 16 Sep 2025 03:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993720;
	bh=AfFc3OpSjbhPeNbz+Yb9iOakhYwHCt/NFSR70/mcjZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCaLOGwZMAAJUlm+iZk8xywaYfHX/rCIdKmJ0AenkSvV/KiDRTAceiXlRsY9M6iVV
	 T8LNEoolqh6ge7VDc6/k7bzJi3vckF6xt/TBebnEU5PvB2Oty5fJzrOVZju5FXG2Km
	 BVVtijmUVBPg8wgA1z3ID0USW3grfC7+XHZXTjAuB7xMGKRG2E5BjK9PF78HnlIuKF
	 6pRTFaxvX10IxERc8GeQi30SaP5AvT7BH0twMDd9Dg3fxuT0SlLv+htgCIuBJn+Ewb
	 fcbVv1jlhhS+GqB7Po4dt8YdoOHZ/nk1euOotZUHBPBCJAC9lCsJepc+s4YRrzeNow
	 GR/ShJkmHhW9A==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/7] mm/damon/reclaim: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:07 -0700
Message-Id: <20250916033511.116366-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 10342140004
X-Stat-Signature: hng353ohzmq7kgwswgeae1xz8hhxgu54
X-HE-Tag: 1757993720-536797
X-HE-Meta: U2FsdGVkX19Z2EH4un2pJL1EbQWiFXnW6l1wMePS9zFVObTosTWcHaEgmXsCymZmQinKjqK+nZkSlVA4FELK469I0GDOJx3eEy4VRPApKRSh+LzfPjq8ySE4hXczCp7I/mp3Aps8w7aa5ySeY8xnd3iScfwksXhO6SJknXYaz17/mtg13I8rfstgAWt5Fuk4MHDMo2PUG/ByZaTIeQJ52BWwaXO5MVogW2nvA4R8hbvPP2UkqKV8Ci4ISydVhpGJDpcwuW9lQMI+Y5JMrs9EXaiTY8HZsGDIZ7Vl+GJYOeffVJJsZWTOvi5HIyFWg6mzlR1nAifIcMSmdrDEFGH8PaIS5u4nBZjMvr7Xqm3se+JDTb9VArRwxlBh5IRYYwwfqvGqZsVd0XNIVKjMgWWw7rh639+yx3prjciWp9sGcu6ByAveZOHg7bqAA31ILTtYlWJr9taHkXRKBcM9HPT5zNciKdniseKHGSipVVBBM81o0lY6Lnpl/oHp85TSsRadeOIAV5wA7t54+EtYBzT6qT5rGB/lI5A44C1qlvtcNn+Sr3nC2pTO5Qg3BcAJ77m3ibQNxJ9V3gTaqIDOoyEWj32niQmPUSGWgiSaOCEBbuL49VdO08IJ3CuT39AzslzzMM65uElKWa3ul95wdEkJfoNAUoVKn7pHVpWy5Felc9FOyMIMe3Jhgq2BVjbTaYgF/7oTXqh4oThxnSSu5b2Jy6zNv7RmaP+rfUafg8YyxzBnILQL6/tuCnfibMhaSyq3BbeTuQToKWaB+rsiwifMKh+fMaSgv2+iqpKMiZPTFNUUGcExWFhdWF49L4UhMbUdi5GtH5Sb1+Atc+6oqB1ZMaDgyuxUZ5Eczu9ctRVWnNpEwhyngJehsR1WfF+NIE3szzJ1Hk8g6pdCpFcDK47y3k2/ocfMNyE23hE46Vyc7kJBef4oBK9oaU7InoNNXNHTegiE0nDVi59T+NfdpJg
 g6eDIP2m
 jE/kX+Wn89Dc5FA139wUCLYETvkBrUc9izlytnKRCyMIyEx34SgcHeIP4ft/tBfY80eyRc/Lfnfkz78xfdmv4nyvSOZtuQYCcqtO18VGTe+N6P6fbFXu8lBqIyzGGpsNQXyxQGfAquitRHvnuREr0BTOz97UlBtgG9wmGPURx3QNyRSdBoY7dEBksQnTqZJ410x0Vb0T8erugFsU3lFJ6ik63FitkoMecMHdCqFVUNjqGsYmOrZmhbTQ7SEM1Ow7oh2gwMer/aRaq8Ga9eN6vUrmFRDLjqI+hLQftmnITgnxzZUSeb/F9wyn9PvusacgfoOEZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_RECLAIM is assuming DAMON is ready to use in module_init time, and
uses its own hack to see if it is the time.  Use damon_initialized(),
which is a way for seeing if DAMON is ready to be used that is more
reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 590f9d6c55ef..7ba3d0f9a19a 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -349,7 +349,7 @@ static int damon_reclaim_enabled_store(const char *val,
 		return 0;
 
 	/* Called before init function.  The function will handle this. */
-	if (!ctx)
+	if (!damon_initialized())
 		goto set_param_out;
 
 	err = damon_reclaim_turn(enable);
@@ -372,8 +372,13 @@ MODULE_PARM_DESC(enabled,
 
 static int __init damon_reclaim_init(void)
 {
-	int err = damon_modules_new_paddr_ctx_target(&ctx, &target);
+	int err;
 
+	if (!damon_initialized()) {
+		err = -ENOMEM;
+		goto out;
+	}
+	err = damon_modules_new_paddr_ctx_target(&ctx, &target);
 	if (err)
 		goto out;
 
-- 
2.39.5

