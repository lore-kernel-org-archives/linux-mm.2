Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2ED3C44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E15C6B00D6; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 768066B00DC; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67C6C6B00D6; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 206EB6B00D9
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87E041602F1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:59 +0000 (UTC)
X-FDA: 84987631638.20.B1AB509
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E39CA80008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNnaRYCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49szHoBkn5sDldjM9+XsvM62mHHlAwosCDD8pFLfc3E=;
	b=pBhpia/9rwD+QObnRQ1IQbJZrtdOpVrjUni8VWLAbZyoXA3aMFf7VoVG2lkZ//3Km+DAW+
	jRG+feB3Ewxg9lMC3uxyAHpUHzT8MArSmhTcg3tw60Tgbpi2eVJj6Usq1uuxD0q3d3bUL+
	GcGahauYhg+deuFcmsoDmWxlGjBKtHM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mNnaRYCq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039758;
	b=BKGbLw+j0r6VTHXTTr9UISIExUho6RSgLnysl2fVee7rYoqTnTTNN9tN0p0dYnF3BI7cEa
	LY1EcS9HTHDv9mivhCdz3dEI+LvPTlH3XEyfzalQTX5ZrpRdCNF9CwgdpBpkbB/7Fz+qcr
	1R+P+U+Zvz9aGyvs5ViEqu6zkTTTTBI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3286543788;
	Tue, 14 Jul 2026 14:35:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B231F00AC4;
	Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039757;
	bh=49szHoBkn5sDldjM9+XsvM62mHHlAwosCDD8pFLfc3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNnaRYCqgE7U6lYS6bSyjxtSvuEsadv2VVJrnzE/7TgdSJqK9gyBH4xG4QwU9BtPl
	 LKCkZV63bfPOyus0+zAJUK9r9sw2nXU51BNTc78xYRBcRw5ji7ZEFa8ffR+BYdIyFy
	 D7RzIfzTazgbFqoXZJ7XyGPNMLNxqohTged/0I02O2VJF20MoiQeMN23cMDi+ysb92
	 BZoKUMId8sOAqF/vpzXp2T6fgtrnY+OVRpIj1qVSn4mYFb6ShghfOgPTbXgsVhvn/T
	 qzbanAbEvoELUGPXyTEz+p8PwO2gOrxO6LfAHUuDc270TYEwi4T8Z7Le91/K5bYgDo
	 kB55s/e5ErRFQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 06/10] mm/damon/core: hide private damos fields
Date: Tue, 14 Jul 2026 07:35:39 -0700
Message-ID: <20260714143544.101305-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E39CA80008
X-Stat-Signature: 5fdkeza1cntmix9dca9hhw4arz9s47uo
X-HE-Tag: 1784039757-825752
X-HE-Meta: U2FsdGVkX19fRduQN5z6wzGDrwmT1pX0wzBBJ5MjH9PNVaMVqF7pVAqqAMTX7QmKUi8vPUSBJ57gp3wYtCwlkq/0VGchdxd/aCjoZ1I3krxM+PMOIOcNOtRYIr6jBnUaQCDkPWINooLYG0Ue4NxTe6iq/QGQpnRNVTgM89Q43zA9uwaQt2IoscrueuOuNQbUt190kaQlRVCX8DGtN81L+sCI9eT+b2/ciMWKODT4oxI//7dmwipT/qE/kRKYK20RqYLB28IYm120770ZgN1X4ZeJYELZzp+zfo2gLdDKBFjadeKWxVyd90pTPL231YA0sWiFnrEwNEp6EyonT0c25Aje7TG6jBV8JUPZev6qnLwUcD0+7WNkdsCaXh1p8BZt1J4Dv+XUHJvVOP4GCofL/Uy9ZZJZITEwehMNGMJKV1dbVdHIGKrXq/mBjnqV5cwIyuB9+xEDwiGQCpSD7iA8x9v8WkquH9hdCb+KkmUCe4AUQQCxmv9rC3d/NPccLATwzEGsb34ySgbPEx3RgUtdKteWDikxZs/YMpwk0BLPx9UdCtouEY22T5Uq+sS3E4HHklYRr/iLrbqM3ZMKOi6UcmNwUZXukUa+ZWjnRiNjQIAmZoxGHk5fuNvo2NrtbYH3WWxzvEprA/Acup9oBPrFBKgRPB7g92HCFj/JPSBWwdHpR8QQhNFHguD0u92aJ6fzK/LbATvsinTsqeRJvNFxa1LGkRz15N8aCDaIK21n/JMdBTzIUzi+u4Tg9GGFJB8Yo94l48/qI0TX44SBEOM/lNjTIOafr7WM+NTaIId9ThERIs5e+CE8BzZ8gr9x+iLKz+6lU4MRiHJvFwR6CDY+G5uiSYrpsLzhfgNDxmjKPikrBjSfU9RU1RDT0QR14AQK/t9ioKckNbBUHb9nvSwZ4BCYk+Ye96MyxDkPUCDaHoZwSBmpYH7W3G2hRCxyM2Ox2CjOb04oGOFXWVxiyQk
 5xodz4Xf
 Q+N2mQTcP08vEsRN4CPMyZh15fOyoEycRJX7QaZHqklQPZsENc4OCe4PtfmkcEUAU3cA31WjHFKQOcOkLPxXOZcmCAvCKC+LFt9TR3awsZE9WAPIZ+LO0qZCvnlB9T/+GZY51mvCIyASFmtx8JED9msl/7wsrxCTpp9Cb1ditGpIoJY9raSP/1eWfirJLjN6biuCqRnW5ar8I5M/04R6/Q2kZpgJS3rvq5Oh9sNzYGR89+wg=
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

