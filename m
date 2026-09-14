Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5EFC4C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D466D6B009F; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC92C6B00A0; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AACCC6B00A1; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE0B6B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:45:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0E79F12011B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:59 +0000 (UTC)
X-FDA: 85212639918.25.0A597BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6FF00C000B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X7c2Qz36;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	b=aJPtbAQ02CwZKXezFDxJaMqdC9dSaRoqovgKdzo/EJuwBiVPnGVZOqne+NnsRSVCVccDLB
	Qgo088UST6j0kfcm5OU9rLjHWPjKCJnnD95x71V1N5pKM743BTzdl5KVjH+lH5SuAeRLyv
	bVMf5kkkZQQQosaSkmMS3KDs2cF8zFk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=X7c2Qz36;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397097;
	b=mz1A2338SYShik/E7uxqBHsaHgxPM+VsV6BDabwFXb+mshnHaEVXTGgu9D6dOBCnIk40PF
	hi2dhrBs9Htp5fJkojUiosb0KQNifKYCLXhQyi+zaUdRs+geM7e2wTzKd32Q089a5Sfqi9
	Ak6WlmU9HDS3WMU3XQiF6tyLNpik7Pg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C338043C43
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CF4A1F00898;
	Mon, 14 Sep 2026 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789397096;
	bh=WKHC2ohfBCTfxJBQb1w+ZA1oqxl4Tap4PnGbWDCoJ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X7c2Qz36NUgvIzawLbL+0tKSDFObpIvoXFWFaPLtr+oyXmr11JU1czou0VO/s+43Z
	 Cjs1+YPJ3oK1KLQIwltKv4wuWvZK/PRjyx/r9mJE2JkEeJoDkd1YXmIuBUfw5jzfuC
	 k19BbUOni6ei726Sviqeba/Vf/XCgTsIi0UNi9tvrMYD4kHS8PSsUQiUD5IUlLf87h
	 Rpi6MIzp259mxca/HTW+QdEgFXks/qiidM3Nnk+for8RKBt7dcHEkjHuzZpnmc2sgC
	 Yr1F3BBJdUK6FtKWp0P85blro/Bj2ilbs6QN7QVNJz+gw+B4BVQkd+sReX0f1K1JNV
	 oeP1FgH4QQIxA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 1/8] mm/damon/api: introduce DAMON_FILTER_TYPE_HUGEPAGE_SIZE
Date: Mon, 14 Sep 2026 07:44:38 -0700
Message-ID: <20260914144448.93732-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914144448.93732-1-sj@kernel.org>
References: <20260914144448.93732-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6FF00C000B
X-Stat-Signature: 5qzcnkegacrai1iyzwsfk3m49ax1zt5i
X-Rspam-User: 
X-HE-Tag: 1789397097-755325
X-HE-Meta: U2FsdGVkX19arpFx5yfz7ePt2GFP/AIecK9bDZxbf/nXkzgdN4mbMAH6Qi6h45xTHVMQRs5TtuOdUFFd35b37hWkwII5uGXvRStCFJldNrfK9q9c52bb5j8Q0+RTBWLar0LC3YOEAPgE5v2Bt3IZvM+kt1E0Nux1XJzQ6xuR4ObrLf8BYXbh8OkCzHBM3BZ60Ip7wRN0GQwdUXTUn6v+Fa6Vy5pieJ77Wu1bU4ogmrXcj+zHgsIykgPagg0RME8Z18h08u3hePNnwjvL3VVUDs+yK5lpxg0kxoQidNv1keATxkA8mozFyb3UTmkpMDmtT0IjvX1Dq/KPcjgN7AdKqH/kt4ac31rmPQ5ofg4adUgu8hcU2IYm11ZXByleliPd2FPa4MOnxRvXmZ4cr/OYX59PF1e2jGzkc5TKTEJElK0138HdBaSC/LEUK+wwb495B4cJso/zcUwgE8bdVRSw/F+qB/fqDEh/tJOADe9NzO4JMB7kSIp25WoLlGyigBJgSUxrew+tGmNIeAfREshWdQEtOxRzfQyXwsso444wlP7+qKRJXSKFxkSMz/DQx3RRyxLHHvToPQyb8wbLz0FzwCa2+bfdWpke3wgk44XA7xKhY5s86xGYe9m/4myUy6P7fA8cH6pcTAsn93yTao9/FS8LRYlgO67IUUwGgnFGNDv9ArXi5cXV80HNwWopjaZBCXDH1r3gleM++mQCZvlwCJX4GOKnidatfXq+MD/MON+tCmkX2rBdp4huPlItnyxSqSveHdFHNaWjgnyrCLFEyImdfMrLcNu3PIW5dbJaFim5Z1Tc8seUWet/hvacUTNCdOc1uq+XA+tVEqAPACOgGY+XJN0Vpt63m6BnEJvXS9300a8F4aSI2N+JOPYXm6kHjpYjpJj4OK5Bv4VV9+4uJ+QCQ73aHQsybGuAf5oxvjT/QUE+YV9A1vXE9a49GJIjCvnTr7nREOj5hPvdxog
 3PVk2Ekt
 u++2wxlOFe7ob1ZUoQar/XLcA5qT2/AeFCbkihKb3IUeX19URY3h1gG/E/INr8uZgh1urUo77h1H5B0ZL/wSns+Ja9UENvBSlwYRyS5EX9wJdIjYH2zPLjzuOvytolpPz1K8spwgZC5Z2NDhfH8glqzXN0gpoVR7xxSRnKlFrJcaBrLhBm02feCQfO2RxCWLWTFKwN/4/wXMLebJEDsSQ4lRvEjLY1p22EZV1zsttn4ob6gRRxUYEL3x0R6hr3tJmuVLWkOpQfWCQl8hjeuuV6Eg+AWZPS+N7E2nsmbR/4mH4DQvGp5OuPLbpfW0msULbpOcWcE9rJQ0O6EvQfdLAYGXayDsup2jMdXA9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new data attribute probe filter type, hugepage_size.  It
will work for memory that is backed by a hugepage of a given size range.
Add a new damon_filter_type enum DAMON_FILTER_TYPE_HUGEPAGE_SIZE to
identify the type.  Add two new fields in the damon_filter struct for
saving the size range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 4be7d1df8e71f..bbb190b474015 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -783,12 +783,14 @@ struct damon_prep {
  * @DAMON_FILTER_TYPE_MEMCG:		Specific memcg's pages.
  * @DAMON_FILTER_TYPE_PGIDLE_UNSET:	Pgidle is unset.
  * @DAMON_FILTER_TYPE_PGIDLE_SET:	Pgidle is set.
+ * @DAMON_FILTER_TYPE_HUGEPAGE_SIZE:	Page is part of a hugepage.
  */
 enum damon_filter_type {
 	DAMON_FILTER_TYPE_ANON,
 	DAMON_FILTER_TYPE_MEMCG,
 	DAMON_FILTER_TYPE_PGIDLE_UNSET,
 	DAMON_FILTER_TYPE_PGIDLE_SET,
+	DAMON_FILTER_TYPE_HUGEPAGE_SIZE,
 };
 
 /**
@@ -798,6 +800,8 @@ enum damon_filter_type {
  * @matching:	Whether this filter is for the type-matching ones.
  * @allow:	Whether the @type-@matching ones should pass this filter.
  * @memcg_id:	Memcg id of the question if @type is DAMON_FILTER_MEMCG.
+ * @range_min:	Minimum value of range arguments.
+ * @range_max:	Maximum value of range arguments.
  */
 struct damon_filter {
 	enum damon_filter_type type;
@@ -805,6 +809,10 @@ struct damon_filter {
 	bool allow;
 	union {
 		u64 memcg_id;
+		struct {
+			unsigned long range_min;
+			unsigned long range_max;
+		};
 	};
 /* private: */
 	/* Siblings list. */
-- 
2.47.3

