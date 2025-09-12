Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740B5CAC587
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 02:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA1E16B0012; Thu, 11 Sep 2025 22:39:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C532E6B0022; Thu, 11 Sep 2025 22:39:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80816B0023; Thu, 11 Sep 2025 22:39:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EC496B0012
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 22:39:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 45EFA140618
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:58 +0000 (UTC)
X-FDA: 83879043276.27.95FAF19
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id B1E76C0005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:39:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gWP+WhWq;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757644796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IKkUH8eqHSbRrPC/yqn6JI+WIlNfRwd287k0stUFNgU=;
	b=E3jtMoEoRd9A3r0oo5Y2ZoauPINiExQNTSohzXOnbZXxucYQGD8RIf1xKpkTQJ2fuHjbTz
	BXWZgyamo+9iSAjf83u/sFSOu2nntAP9i5lqTSPPvTuMcycri3HJwtASAlpVZDMnXtUl0n
	J/eGqPe30RsrGt3UZVOO4MXDUuPHiDM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gWP+WhWq;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757644796; a=rsa-sha256;
	cv=none;
	b=Xhck3YIEOEowYNM9/cVM/ZLP9SdEzxDMlPDkCEWwdcGBa42uuMT2u0ukhd1ta3k5b/3dxe
	msYvHGOJR5vZlL6IebU6qIo9MNzj/vVMhlVzdMyxdN7TZNkFWFQUsvqORd4dTPq/Kbrkj2
	gUXCgSTZKj0gKJ3i1Gx5ITGMxaoI65k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B1226024C;
	Fri, 12 Sep 2025 02:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B90A3C4AF09;
	Fri, 12 Sep 2025 02:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757644795;
	bh=AfFc3OpSjbhPeNbz+Yb9iOakhYwHCt/NFSR70/mcjZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWP+WhWquO1WX/W82rEURByg7atdHpB5ysqv89RaQhsnxbQvxZStdufL/uh1AoBZu
	 vpCPX9mYSki8cWAg92PU0HBLGnpBT+PpOiEw76eKNpifgDBK1S8oxx+qBZEoHFbVV2
	 ILgkJTv48hnheIbuLKsm6tthD5Q5wO/swgwyNB0GYv5n0tTgMnavb/bY9PagPYmmj7
	 XU332+wz2ZApEFqPxkVu2iOsU7V5sidMbjGVUvwxCGFZOKS04OHojuSfhr67nyHIgR
	 72nIMdLxnC/XsTafgc6MQV86p9xZYKqbi43D/G01ckF9f7eRMLaZDMl0uqv+2wcugw
	 p5ZN6U3uoaYpg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/7] mm/damon/reclaim: use damon_initialized()
Date: Thu, 11 Sep 2025 19:39:42 -0700
Message-Id: <20250912023946.62337-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250912023946.62337-1-sj@kernel.org>
References: <20250912023946.62337-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B1E76C0005
X-Stat-Signature: p7wnxyo5b7z3tyxsm3ynroa8x8zrrni3
X-HE-Tag: 1757644796-317160
X-HE-Meta: U2FsdGVkX19QOYpTa1jt8Rtt+YvVRK6M/bemzlOJ9RbGJS0PiSDIhpiFGoRMUv9U1LUkIbLofbdeyZho7x2kjQUV18LRmdLcq0RwyD74HTN2tS4qwG1bW1gqfVfLWsnJHz+LyaOgI6FrZZooGvFrw0WuMHN2SyKL8pGLK0ClXpUk1dnrn1p5hkg9sNIf+O77w/epNdYm6vI6GX8a6EQBW25JP7XUVREqZAcndqI+6pxid76lGB9fdPVn2RuMzUclv1AftTtsh4MvrGbAGLDix0do8NsnN8niVE9AorhmLGd6hRwtcE8hGbk869BouchPZhAwuuNWApYRDdqycmej2Yd3WBUDQPOMJaNWPGCw21pVw8RMgqquk6UawdoLgGMSfOslHsgs5zdXOAId9FHZMDWgnzhBK5Pb6N5JWeESMBpR7J9ql9uTvbryk3LbyS2wCXpABj5Ipy2j+skYm2dqO5z/Hd3zUUd3GEqIJZmQiY0rVTwGo2HwBf3XHkDdkpOfhljrLuVjK9cvEMESL81dhFACJpPs0jh/cYk5pNqqfcF3pgJtAMbXtfkE/v96ra4UYxbukL3Ida6DmM50NTqJehX66sx6sV2OnD3WXs4FxsTsZe8oomJpLa+kBlZy1Qgx5Qf8gJrE6vT/8g6pz5xlEWWSgW0YAGga5im624Uw0Qu3ptpN02QkCFyJpr6bV8FtnvSSrImHor4M4sW5/1NU7VLoeuBUjSft59GMFCE+s/UoVKyIuh3rlnhKYVvjIQVXcSouBEPxY22C6MJv2kNmuSxpKR8zRhtfKMhCP69oPnM8OiykVpltNGLJcYQQc2J4EFVeHJJ8NUVEqo+MgsvlFULomfuyj44vLBasiS5jpg93IIHYj45qp2X+Zs1P2Rw6Wsgj6Nb6iRxe4rcW2QLs+4r3LHq3u3vHUCfAI+quelqfi39cN6qBoXgvIdb54zAyCPDH9WFZMDYGJyn9jyb
 2bGSEsUm
 I+5upAQGznAskXAddwJYPYGA3/X58hH2j1Mmzb/UoonbknGnD/itJFQwI1jVsCKl7T/p0I0y6SUWe0kBX3AdvCsaRYqPIpn8ZHQ107QJSPypVRTduP93EB6Nk60Tde9l//DROuiRlXcA6ZV/qE3em5QrnaRx5h3QDaDnd7OQwR0sCepY9NqjTSAmgL6060pbgCRbbX/QN1llhriAiqdeLCaAYtEAUT8Zx59qMdjWVB6B//T0=
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

