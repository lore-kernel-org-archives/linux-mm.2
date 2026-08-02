Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CABA9C55177
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13DE96B0095; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EEA96B0098; Sun,  2 Aug 2026 12:26:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003B96B0099; Sun,  2 Aug 2026 12:26:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D235A6B0095
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:43 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 56D7E804D3
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
X-FDA: 85056857886.30.280BBE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id BF0D640008
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OCxkL/p+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u3Yai1oWYsB5IJ1T8UFXb8F9ZG0QK/4CFjudJQO8wtI=;
	b=UgPq0CShRM9VvJGCBh9v1lBcn1J8mRjq16EKw9RWg3TI2hQCCUVf6cxC023X+yYhqSXyES
	G0bS4VwQR1v7OrPmpusWNlh8OsVlpN4IhakrpzDVj/8bJ98W/a+zgCbXn8D1zdPGLMm8w+
	2iFmceO6fDVpgY6XrhsAlAJL3c4ZU4Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="OCxkL/p+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688001;
	b=CL9JazkkfoMhGUTsqR4wusSKIVrtoAY5gHr3Vh23gnKdlaTz9qV1Dwq99Vs0ZjFLC0Ss3q
	N3Pye8xzY3WwKh6rHWi7joSVigAPbgg8W6HEk+mnd0haIq55QS/f7hinkPaZ5jl+TxmnNo
	HZBerTrP6OrHChyvRPPXfbflqef+8yQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5C48560DD8;
	Sun,  2 Aug 2026 16:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7841F00A3A;
	Sun,  2 Aug 2026 16:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688001;
	bh=u3Yai1oWYsB5IJ1T8UFXb8F9ZG0QK/4CFjudJQO8wtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCxkL/p+39Bi9iTZV0NqYw2G6YyiSqoQ5a0QvVf2YzJYLXd7z66X1o8vR+uygnJOX
	 t+Mdv4nmbfTaf4kOf2GMcVYF5kwgK/85UucUwmPbvlsSoHSGv4LeAVmgNi1qR/YfjH
	 cYtxRmJk4DNfbk1AUHLA5v9oBcCuRhl1eq22EFv8SWoHB1ho95Ei6AVuqpQyJ66bgm
	 uK2OdcXhUr2o9gFbECJpC9Ovd1O3MaL67hQUygvSPpfClq+kVb7YZelkPD9OhGUbqf
	 F3tJ5D5lkwnU0oaw2aB79xrxpVyngzDkF7syF6nDk6wnjdaNvLuN/WmsFiMNzjPw4f
	 G7sshIzQWpK6Q==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 2/9] mm/damon/core: initialize damos_quota_goal->last_psi_total
Date: Sun,  2 Aug 2026 09:26:23 -0700
Message-ID: <20260802162631.90304-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BF0D640008
X-Rspam-User: 
X-Stat-Signature: x1iuuikysp4e5i38pd1tyme4h3iop5bf
X-HE-Tag: 1785688001-272975
X-HE-Meta: U2FsdGVkX19UhhFOmckLrJ59Yu+LyyPQnZJLLDl6Dozqo00BuIhbuk/8NcUMWEnXI/IrFmAlFlq+sesgYM6a/rZc4DVEFRCMPMMOpdwfD5S88gXOt4GgPN9L4iAWPFCBx+DYNlZbuYV2vHq1FLSqnSBVOWa6V+3SzzDVtUFGHOzrVXTZ97tFShTKsbq1SW42aMMErFcC6eUt3O8acdTg7l3UDH14d162aq6INOjm5hzNR92vcC944Oc3YDg5MZf62cY5EJDtodppihsMJzzJ+6FZVUIGj6nQPDeRvDRBZAz0lPLU/yRh/UMTMqdZxcBwVBEwQogVTKzpzjvfLE60zCtBfCnVVerqPV1ojasTAn7l2FRiIc9HLNwGAKEgtZIXb22Al2fDdpehiFuKbbvU68GY8DhsNutaw1V78cugI3Sul109oBPjJIpr3Rv6vN2ACu0owpurmJmYnsfOuAhZHXwAFb6ah4ro1ssXbTTZxnPXtW+LS/GULCOVo2xvKClWU2kjQ4bsHA2b6CdHx1nEAL5EL3kDqIXzJQr1epAr3vYu0HV0AS2eXWSpPcjt+3YHwnEa2VvgUDeFmvw9vykbp9YgbdO+BTPV5LZIkFimmZ7nQzxqF2sNBL0j3kPC+tskjT/WRStsrIizy8rTU4BS2Eb0pI5Wcn9iNSKmDqHUFoXmUuHZckoK2uYyRRrL4U95uo2sip0ZpQ6RQqoyZIXU1YGMR0oM2nuF4XyFYOVngZ2/QIXpQ+uTHzrTNFDg2HX2sgIqAQUgW2AWldUmCn9bujPGhG6KbjkdqoRQYT1vuq09KsxscalDaVuZvHnH6UkVWk3tnW1WyAtlUWP/bOMVeIPxCWV3uWq0GjjsVz2I3fp/uc49gpFKk3Qc0VmvoL9yICwa/9AiNQO63LE+F2WSjLu1buOuXolowb1RrzU8iGmVALblutZJYUot6UCaPLjHAfmQtXHty35VMBLPdUG
 B7UMRGIj
 VPCjdGRW3g3TFce1VT0UBEA0rEA40Ee0V8dbhPIlKvzF0gSwtd+EEGkI6YOgDXrULiLAC+8NBcPv4yXvsPF9dbE2tNe3xvErP2HOpn+SuMU3pJP7NSUS9t/BI2f9biKGh+In4gMWmlRVX/4ujzpxeW89p+BhTdjiETU/F50VLI98vwUjEq8Eb1/micLoN3an7AZIGoDAvDFLI2IolgDM7v4d0+vaISKEt6r3ymtlHn1lxZfK4AU45uPxB8X9q5eK5xiJsAieb6aPNU6gvsqm3rz+00Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When DAMOS_QUOTA_SOME_MEM_PSI_US metric damos quota goal is set, the PSI
delta for the feedback loop is calculated using
damos_quota_goal->last_psi_total.  It is not initialized at the
beginning.  So the first iteration of the feedback loop uses the
uninitialized value and makes an unexpected starting point quota.
Initialize the value at the beginning of kdamond.

The user impact would be trivial because the issue impacts only the
initial iteration of the feedback loop.  The feedback loop also has an
internal cap of the quota adjustment.  The wrong adjustment will soon be
corrected over a few iterations.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718005316.89585-1-sj@kernel.org

Fixes: 2dbb60f789cb ("mm/damon/core: implement PSI metric DAMOS quota goal")
Cc: <stable@vger.kernel.org> # 6.9.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index e2900d0c984c9..3bdbf4fbf7147 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3728,6 +3728,17 @@ static int kdamond_wait_activation(struct damon_ctx *ctx)
 	return -EBUSY;
 }
 
+static void damos_init_quota_goal_last_psi(struct damos *s)
+{
+	struct damos_quota_goal *goal;
+
+	damos_for_each_quota_goal(goal, &s->quota) {
+		if (goal->metric != DAMOS_QUOTA_SOME_MEM_PSI_US)
+			continue;
+		goal->last_psi_total = damos_get_some_mem_psi_total();
+	}
+}
+
 static void kdamond_init_ctx(struct damon_ctx *ctx)
 {
 	unsigned long sample_interval = ctx->attrs.sample_interval ?
@@ -3744,6 +3755,7 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	damon_for_each_scheme(scheme, ctx) {
 		damos_set_next_apply_sis(scheme, ctx);
 		damos_set_filters_default_reject(scheme);
+		damos_init_quota_goal_last_psi(scheme);
 	}
 }
 
-- 
2.47.3

