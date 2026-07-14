Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A87C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30C1E6B0095; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296076B0099; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0749A6B0095; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C211C6B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1F7F0160262
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
X-FDA: 84986116572.27.19F46F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8C665160002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6rhddFD;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7iohU0bRHpxYfrt1uYJsO4LZsUO4rQ7qDj6JMCliOY=;
	b=kCRwu9vx08JL9vSk8WHJ7wqF4v7fDI4uVFouY5Q2xxNdA/B8R3WVlTVYUT4GbrEjTxpTdW
	VNfPCnrTcg1qTYctZgDTkWayYE5ISsYOxypE19EySTikxxmFgwsBb48zs15w7UaY87lFdn
	46bjzG6j/rWgOie86tVMfAQk3h+zSrI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=H6rhddFD;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003684;
	b=KXmrLh1YW9GmrpiYP43VbO4F48v6Sq9wg0Bc26Hj/u99MCPvO9hUtTVbtIJdjx5nN7N7Vn
	RkKwjY/JmtOXrDMATeB5XLxXC0aE8A4VuK/8PbWkcMTMqKsnKdN+TG31Dyx5WTN+ltLbgJ
	bN9QIVqryRSfZeOP3vZY3uBuBokVUow=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DA8F143C80
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1E61F00A3E;
	Tue, 14 Jul 2026 04:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003683;
	bh=t7iohU0bRHpxYfrt1uYJsO4LZsUO4rQ7qDj6JMCliOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6rhddFDBSHl5rXZDmtp+PojItc9qKc77bnnk0cj/InyI6o4pze5UI2MghTcB65W7
	 Et626zfv5Sds66otGHGHRt5PmTkFfJUS5Yr2aRSKHlko/qLJlnI8j2MAW7OwPcBFsd
	 OscnW0Qn61K1JW+fcp8oUOvce76B1W+LS7Q6EDF/q68Bk9fmDzMde4qrYKnmYB0mDz
	 X3SPBBcz5k4vcdIh3c0bog/EVCbAq1YmDQxbGsDAUlqdH67jh7fTQG0JtNkBgSwOgu
	 4IwBMeTzU6C/cVMisbQJ/XtdVOGZwFrQngNC0/rACP2BD9wel8OljuswH2VOcfrN/D
	 1PdyFca7MfXiQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/10] mm/damon/core: hide private damos_quota fields
Date: Mon, 13 Jul 2026 21:34:30 -0700
Message-ID: <20260714043437.95811-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mmbm3dxs33ts97mquu6j1cy4wa7mceja
X-Rspamd-Queue-Id: 8C665160002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784003684-304041
X-HE-Meta: U2FsdGVkX1/BsIG05Iv7sn05kcH02rNV8Smwpf6xtLNZ7A2yTtoYheV1sI6od3T10jGgQ6Gi/lGCsiJBc9jvzaFBhqMrOYbEJErOG7QWoX2zSXWRM/jrGNUBduc6VVNXVLw4SGrFLf1ZKej6sIOEJHPC5G2am9eJpT5kR7MM1SppQlZdor8e/p3LMbbmNTRIg/RvmMGQLZqJ82FnVI1NzWhjATINKtALLjsE4im22DSq0NhKP24Bx19VAv5vQlIRMZjHzfbIY+zmPtJXq1Orj7G6OQajWkejMIHrcD6qdUEWZ/MPRdp6asmNve8QWFIO8/Q/YEAZellTe6naKaIFtA6/rCzH1CKLMUn/qOXv4Cs7/Sj0GVUqiiGi5tLUsgKK2f4pfz5+4Fs9X/CfucDRddpInDmK3p7mifmpc7IDZxwGldAq67f5ECZfLCHGlM3LKj1qVpdiYnGNRyOHbJND+r1pu+UjRpi0Ps/BM6mGBxXmsGZz2m+2MHUzbFBVolgU0Z3t1Z3bDzvH9nZZojta/OHtJQrTCPK1BbK9ADb/W/2G0V1DnjiQiHx8oTmzh7vPeGaNJmuljnGjt4lecf21p/ZgsSqFNDBS5oEP7qEkr+nEaINY+mf049trw9Vd5qlPJxezouf8ASibsyOVWaaJ1yMA6s++73MEL9iOZ2K2cyO/YkLUTGIT0WVAelT3JVPdxS4N379dGcZSjjHDEOuk1NlHS3oGA7dIRLCVshZCgNihjtXSiUDFoilg6pz+CpW+H3vcU23f3sR19mQy0sDT1tQTV18ONgTEwaUZnCuVsSnGGylssW32GMnrPx5P/+ZPIWEIbF+aFCtUFPzTdrYZhJoL5fDQieIMq3hKV/9luH43DWUdwVDM1crC7EfG55DeWCGts1iVyngH+4YFxVY2AUKA9C3ISSfURLkroWEmY4xiuhQCdrBbG69upIQR5U4BgM+kv2eXrRnFY/QMjgy
 v7vWqNJF
 mxXbM8VaQui2Gbr8f8gwbMKrSN9aWmL8YZ1pGKixJzK5VbldpsaYgvhnINqgimqvxpNcWKtxEFI5GjdRazGoqp1/QdSFwgrzPFk8fdUfaQmHEVZMsPogT5DT0xJ1192Ii7IrQ/7MVFNxq3anJzPBlQCo6hBJcl35w8dSjrES/PF1LnLsC3+ffYWMSw+ZWOA8WjVVnsLZIVWSsKgtETyOvW6pqIOItTXoSpDhc1BB0SO6c7XDAOlmBCIEBmu62nPUZPpbjHqclWOQ8Qp6HsUT0pBdZiqyBKcrcRWxKMp5mUIEFHvDEFA0skgTGBABbSWWVOPy6zr6fyvhQYQVDXvtLSpVh5YOsHBQlYQ+DW7ZSmfZ6qsV3OJhFWi4oaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_quota->goals is intended to be used by only the DAMON core layer.
But it is mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d838cc27ee72a..bd024b89adfa3 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -228,7 +228,6 @@ enum damos_quota_goal_tuner {
  * @reset_interval:	Charge reset interval in milliseconds.
  * @ms:			Maximum milliseconds that the scheme can use.
  * @sz:			Maximum bytes of memory that the action can be applied.
- * @goals:		Head of quota tuning goals (&damos_quota_goal) list.
  * @goal_tuner:		Goal-based @esz tuning algorithm to use.
  * @esz:		Effective size quota in bytes.
  * @fail_charge_num:	Failed regions charge rate numerator.
@@ -255,7 +254,7 @@ enum damos_quota_goal_tuner {
  * the scheme's action.  DAMON then compares it against &sz and uses smaller
  * one as the effective quota.
  *
- * If @goals is not empty, DAMON calculates yet another size quota based on the
+ * If goals is not empty, DAMON calculates yet another size quota based on the
  * goals using its internal feedback loop algorithm, for every @reset_interval.
  * Then, if the new size quota is smaller than the effective quota, it uses the
  * new size quota as the effective quota.
@@ -276,7 +275,7 @@ struct damos_quota {
 	unsigned long reset_interval;
 	unsigned long ms;
 	unsigned long sz;
-	struct list_head goals;
+
 	enum damos_quota_goal_tuner goal_tuner;
 	unsigned long esz;
 
@@ -288,6 +287,8 @@ struct damos_quota {
 	unsigned int weight_age;
 
 /* private: */
+	/* Head of quota tuning goals (&damos_quota_goal) list. */
+	struct list_head goals;
 	/* For throughput estimation */
 	unsigned long total_charged_sz;
 	unsigned long total_charged_ns;
-- 
2.47.3

