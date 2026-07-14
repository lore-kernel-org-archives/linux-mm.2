Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4570C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F5F26B0093; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E2926B0096; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA8E6B0098; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D8C246B0093
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:47 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D10BDC0245
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
X-FDA: 84986116572.16.B6B2182
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2F681100002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kaVBoUoC;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003685;
	b=vey6V5DydrSqQpZj1/VyV5NMBGOYmb0Qw/jkrAGQbtii1aBt4HMJhpyx+Me8QQknC1f0gz
	gQJYnRllfLBc2EQ7w9t7hkcyIA/zwQc3DsbGN2ZwbDxhhhTYVJHso57qf9s8W71mCXNBIn
	MLzTHtpWEdOxJ6CfvyDCDMg7exFr7lo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kaVBoUoC;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49szHoBkn5sDldjM9+XsvM62mHHlAwosCDD8pFLfc3E=;
	b=ErxmZYVxpCrcDYrEKxZkl1C3BSP0LfR60aAvSUT5nt1s25mvdG/EQfYr2kGOdNKX//YjFW
	cNFzbZNavo2KAYaFUBL4fmAK7ZPeFOZgUJL1Tfw6l2VKvnKPRMK5dveOA9OPXfxGYtVY5k
	onSPIX5MZHELeXUWChqg6svw+wfqhJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7681B43CA1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37DAD1F000E9;
	Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003684;
	bh=49szHoBkn5sDldjM9+XsvM62mHHlAwosCDD8pFLfc3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kaVBoUoCqWg+Mqb/X8nZ2sMIr7T/XyFXoWfzFHELqs8PSGQv/gAQHhVgtKu9omyNP
	 tOqK0ABBELOZiDOh0A87I4MGPhQcCJfqiBsazz7OmcDQ/wy8yzyuS+IziZ2RI0Imji
	 LuP/k2lj9mQn63BQ6p+O9CnRvo4ALAEO+Do0bH2vfa3Tes3RzzKm4+UES5yvQO7W93
	 vBXyN0TlWcAQqvxYfAkQBNVSvdXWYMgI6U/aWxmpWKnXWZ4NOt6HWRff9nAsjk2LBH
	 7JFBIr7RSpUKSVVGMvl30BNBjgsMtq32d/pWTdx4yigXf6c0gQ8P7tRU+/6LAavKgn
	 IyQkbRNpTNqoQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 06/10] mm/damon/core: hide private damos fields
Date: Mon, 13 Jul 2026 21:34:32 -0700
Message-ID: <20260714043437.95811-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F681100002
X-Stat-Signature: 1m6ku9k839pycnb7r5ypjrmrmq6o8u1b
X-HE-Tag: 1784003685-429751
X-HE-Meta: U2FsdGVkX19yUkyuLaQtBWSzd+RuzBM7V0VjSW76+PN+89KzHK72ei0yGvSGfFowsEIlfyOm8oAqosX2rFb1iBajLZBQyntFuiNakN+5n6z6dLcJJZTuK3HqnxBgvCYxGGA8mHle15S3AEQ0U9Vwnd7gRHI8BRfadkWvC8g/TT0p5EBk/oAm/lJQe60XY4U/ANhz9xwEsFwzo785R0Hk254Aro/ihkQeF5hqoes6FJjwwjMdS2DGj7CSuCbGrLTzQZ8nudh9yA4hSNm7Cs9D1QFADCLjN0Kg8LVx4IQ9d0/TeBotWXzHt++8p7pAtqlqsUL+ifzTBoPvgw8RlmhUpYymrsGXpKQa1Znd5Vmxf62Mw8eLKSIyNtDLOhToBUYyspBtBdmFt0CkzmaS3noqDonjNRdpfCaA58WOEHKi0vez8MhS+uqLb8wUIEfbndiccoxbQcN3JaGXvoxBEqN2cTRY13KR8crgV5Gj1jM+++3Rxiz1CVEimaGskg7MH4sDQIqpq5vuiWnbNJA5HRpgFhgxZ0T6xhSYyJFwVeBWcEDru5Y6nbhj9npCdyJIKrOwtIkPo2Q/rZIK30OwIwVjBPNzsx2rQMd+velWCEGx7ap8sDoTz7lZIR580ZLIaSd8bJS0Rx11GTDGGjeF9nd7v3x60GW9OP+hMNMtWPW/faozm6Gl4sRCx1cLexhF4UzzsMFEf7k6mWNytaoUfkzfyXMsSmNwQeFBBFCKxsq+3M1qMMRItW5snXXFEMsi5fuGUQFi/Zw8X2iGMiWhgTyywbbWRkpX+gXTYAhz/9e4VDXc5A1J/gxsFkmL4/lpzZouzimVTiWOL15JfkevO2Az7v6VMYqoWUAAXlT7DiNElBbw//hbJZmRXQlW2vqZk6uwA2tkarhe9jB6RiQV2wh/hiLU190kP4/7YvwUukQ3Q1ZandSw/YKxspNCSZc5yjCl4pZouaCn7sr1l0K52Kr
 JIrnqfqq
 niJDRBoDiPBZnyNp35RAmiWbrMiau/HOH91ocCAWePDJ+OnJ2kzSk1OekMnaufy6/FDIqigrPP/Qhcx2dICqplx/iyqWlbkdD5652t+6GLSag/tc6uzjUsNkEIxpmsK76urlQX6Zper+fvfk5hVOdd2UuKhdc3oMQ87QjxpG2f9Vef+mB3uVyaco/9yMz0Uk6KUvctCcli5VySHzIJgFxC7pV25co2sJCjrQCD2xJbsgAGppr1m7waLH1wGiaxlz5wS6JQZCEh/WppEAUYh3Ks7hoZkA+gLIR5q4gSgNk39Ns0lA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'core_filters', 'ops_filters', 'last_applied' and 'list' fields of damos
are intended to be used by only the DAMON core layer.  However, those
are mistakenly not marked as private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 52 ++++++++++++++++++++++---------------------
 1 file changed, 27 insertions(+), 25 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 15517be3e4960..907d65f03d083 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -522,12 +522,8 @@ struct damos_migrate_dests {
  * @wmarks:		Watermarks for automated (in)activation of this scheme.
  * @migrate_dests:	Destination nodes if @action is "migrate_{hot,cold}".
  * @target_nid:		Destination node if @action is "migrate_{hot,cold}".
- * @core_filters:	Additional set of &struct damos_filter for &action.
- * @ops_filters:	ops layer handling &struct damos_filter objects list.
- * @last_applied:	Last @action applied ops-managing entity.
  * @stat:		Statistics of this scheme.
  * @max_nr_snapshots:	Upper limit of nr_snapshots stat.
- * @list:		List head for siblings.
  *
  * For each @apply_interval_us, DAMON finds regions which fit in the
  * &pattern and applies &action to those. To avoid consuming too much
@@ -549,16 +545,7 @@ struct damos_migrate_dests {
  *
  * Before applying the &action to a memory region, &struct damon_operations
  * implementation could check pages of the region and skip &action to respect
- * &core_filters
- *
- * The minimum entity that @action can be applied depends on the underlying
- * &struct damon_operations.  Since it may not be aligned with the core layer
- * abstract, namely &struct damon_region, &struct damon_operations could apply
- * @action to same entity multiple times.  Large folios that underlying on
- * multiple &struct damon region objects could be such examples.  The &struct
- * damon_operations can use @last_applied to avoid that.  DAMOS core logic
- * unsets @last_applied when each regions walking for applying the scheme is
- * finished.
+ * &struct damos_filter.
  *
  * After applying the &action to each region, &stat is updated.
  *
@@ -569,6 +556,16 @@ struct damos {
 	struct damos_access_pattern pattern;
 	enum damos_action action;
 	unsigned long apply_interval_us;
+	struct damos_quota quota;
+	struct damos_watermarks wmarks;
+	union {
+		struct {
+			int target_nid;
+			struct damos_migrate_dests migrate_dests;
+		};
+	};
+	struct damos_stat stat;
+	unsigned long max_nr_snapshots;
 /* private: internal use only */
 	/*
 	 * number of sample intervals that should be passed before applying
@@ -585,20 +582,25 @@ struct damos {
 	/* whether to reject core/ops filters umatched regions */
 	bool core_filters_default_reject;
 	bool ops_filters_default_reject;
-/* public: */
-	struct damos_quota quota;
-	struct damos_watermarks wmarks;
-	union {
-		struct {
-			int target_nid;
-			struct damos_migrate_dests migrate_dests;
-		};
-	};
+	/* Additional set of &struct damos_filter for &action. */
 	struct list_head core_filters;
+	/* ops layer handling &struct damos_filter objects list. */
 	struct list_head ops_filters;
+	/*
+	 * Last @action applied ops-managing entity.
+	 *
+	 * The minimum entity that @action can be applied depends on the
+	 * underlying &struct damon_operations.  Since it may not be aligned
+	 * with the core layer abstract, namely &struct damon_region, &struct
+	 * damon_operations could apply @action to same entity multiple times.
+	 * Large folios that underlying on multiple &struct damon region
+	 * objects could be such examples.  The &struct damon_operations can
+	 * use @last_applied to avoid that.  DAMOS core logic unsets
+	 * @last_applied when each regions walking for applying the scheme is
+	 * finished.
+	 */
 	void *last_applied;
-	struct damos_stat stat;
-	unsigned long max_nr_snapshots;
+	/* List head for siblings. */
 	struct list_head list;
 };
 
-- 
2.47.3

