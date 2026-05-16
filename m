Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C86CD4F3C
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3268B6B0096; Sat, 16 May 2026 18:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 288D26B0098; Sat, 16 May 2026 18:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 100136B0099; Sat, 16 May 2026 18:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E95436B0096
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 87264160D08
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:55 +0000 (UTC)
X-FDA: 84774739350.22.9A18881
Received: from mail-yw1-f193.google.com (mail-yw1-f193.google.com [209.85.128.193])
	by imf17.hostedemail.com (Postfix) with ESMTP id A804A40003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IswD+TOw;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3Y0N12DjU34jWmR+sp/CB6uBhGDGyyP5fTNvBo/oDgw=;
	b=kkmPrjkxsjSiC7962Iy2JkUAalzEJLaJQ1QKtit0q9Kog43TMD4n5kgn4I2qDTO/ubROj2
	6hKCM2Enp2fmpczUUVExSbJtdG4L0YfunHIBxYSi2BFDSXxtPl6VopLDuorNDOED4PDeL/
	GekFG9/nLVGJn3uYIZbtWU8hQ3ma1t4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IswD+TOw;
	spf=pass (imf17.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.193 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970893; a=rsa-sha256;
	cv=none;
	b=KkcuExnKp4UHaPFq45SNLJ4Gb0qkQu+ph9ZntBwi/d7wfHf0tao4ndQWW1i+CWh5b2PStY
	vNeBFLSWsb5kHpxU4dHlP2hCKZn/UrGxuYXBIhay0DDF6np9M+aqClQtCVzkF3FV92ROGw
	6dBMyT7HvlBMMIGAEnBUY5Ewu/HVsl4=
Received: by mail-yw1-f193.google.com with SMTP id 00721157ae682-7c5d8f45465so4893087b3.1
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970893; x=1779575693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Y0N12DjU34jWmR+sp/CB6uBhGDGyyP5fTNvBo/oDgw=;
        b=IswD+TOwLRIdkRCDrLfdtbAR6daLFxY2V3rIaIK9rdm1MwNXRhszOoeAz529B8px0R
         ZD6CI3OGIAjRBrYdlcSdBqWVg6iC7dyZWxzA88WdJvULzhTxx9xC6VMaVP/tOmtGlSO5
         pe06xaFdRDnHSyo25cmVlN8uKc5bqdOjEFaL8cJDacONcwT5QVoeBZIbfr04shZw+h9E
         jnVPuqUxyfknv4vUCfgyiVmJkU1tuE64X58lPItvcoZmKuxmpE5vblsYYrHjuA8ip28F
         wDO2SbDdTCuDFQAJnUgahLG4SkHg3W+/KsNOAoSPPYBqLmEssAbdeOY2RXSLnjfTyWFi
         Njeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970893; x=1779575693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3Y0N12DjU34jWmR+sp/CB6uBhGDGyyP5fTNvBo/oDgw=;
        b=amJ0ou+JHoaOoAuiuMtY/bDEzgb6Avq3Bw+ZOttchUgVNgZcwMo5GqbY01iCNCPI+g
         ehw1e8pAWTszMWKPCs/nhq66fTiKlsjsZzLDLGF+GLi/GSl6H9eZDyAseuIPvkHQCDUj
         Stq64VMnIB+YNjweIksCuIfpMLdKZrvZM56aQQRBInFT/eUbfoeG0Z7KPP+/P+EgSsAQ
         U/W0CzodBJTCg6ZW6wZ0QDgL8wXxsU0DkuYWF7OLr7AQugOmAb5/+uIzOW4uGAqZwht8
         bmO8spUwTCxmCgN3KJqijVI83eFbQhJwCNuI9fBOnzIE7fi9j/DEYW+ETOoAiVTVo+uC
         sQ3g==
X-Forwarded-Encrypted: i=1; AFNElJ/9cF3zU3DDl45go37pFEtB6R/g2Wtz1fxuPM9epFRDPDCLpCtE6TO9+WtG/FTMHw6dYJJUEV7Gvw==@kvack.org
X-Gm-Message-State: AOJu0YzP4N8dnz3+NyuKHnflsy1sCexdJPs+41iIwOAhgb1eILxD5Avu
	Uq0/sVPPmqiOk8hZYLo85CrP4jBpt2BNPsl/RDaP9B6WomzEKXFlCAM=
X-Gm-Gg: Acq92OEI35qO626rq06ePW2Sy0f12EXJQ3Kz5RQqigvFSy8AaDEpFtma/Sf8PnPUX/5
	AgucXJ5/t4/2bNzBGhYLKBKq25Wwep0AJcUHmFaZy+A5eySKkWSNpnirHPZ9NQgMzuvU8ZoEx3d
	Y/dgDKUACyhwbaVkTk/CMBNec8QSJIqcWq2qm3F5+tVtKS59kueOyNB4YiZtlvC1TLAtFBTxwke
	CqT3+DLzDC3JpvZaDBAFV6FpTcU/HqN2F2k6H+2ihnuQdvxGv7y2G3iEESoAKt9RWHTnG75XzeQ
	k2Abc+zucLd76JHXkhtgfR2rjCkyKBaAqTbzRxmHOwK+t+P5eF2sMjrVbXLJRe0ZYjmNMiCMHSA
	H4U/L7GpQ8cY7p1UBaNiNK6gLCkwpG2yYDmvR4DiQfBpcTFuZGClNNLICHxyO01usMZbIS+pFab
	B7NzvPcaEE+wo/jCMJTR9zw2nM/Vj/UmNIgh/AU4Usa7r1E3HKqE/aCMz4r//cZZjcYn20rfaMw
	w==
X-Received: by 2002:a05:690c:3482:b0:7b2:6b19:df2b with SMTP id 00721157ae682-7c95af50b29mr102598357b3.17.1778970892689;
        Sat, 16 May 2026 15:34:52 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc991c9b64sm819827b3.1.2026.05.16.15.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:52 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	bharata@amd.com
Subject: [RFC PATCH 5/7] mm/damon: add sysfs binding and dispatch hookup for paddr_ibs operations
Date: Sat, 16 May 2026 15:34:30 -0700
Message-ID: <20260516223439.4033-6-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: im5c7539goguze6m9g3k919qgips8k93
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A804A40003
X-Rspam-User: 
X-HE-Tag: 1778970893-292067
X-HE-Meta: U2FsdGVkX1/sWDOOWSSrKizLhPsPd9b8ce0dU2I4NBfQd7TzBRr9yMpL8xffIQtuX4QRlD0zdqBqRc21HxHs5UIJ+3HGR5AeY2pJX0Wv79BqDd14e0GsEB9iWzsQwvZmBgP5RaABa6UgUbUjJZhj4Umcw6yrIJvqhlYYJAbfQ6C8oLkExmJosioagCiWZlHA8KU/u5c3Q+dlfZUdsBy0ftj7hymXHjiSSsdiTZVwxgs3JwsaIVZEzcmzKokhQ6pHPruKWXeDoB33JqnclHOuNE7ftgLJ88EsYKQL7zNYBofWGPTRqnFLShCl+dXmWbBZEB5eC7W+vXrx/ZNcAAfO9TqvbMmZB6t+9t9aNF76vsOWteikSNtL1igoUlgYeSN6a996vC8rZaCRf0oRTDxpa/jer2HWZA/6xtqnkG0YZ0+ke4YyLgUEjJS2ODD4rSE1eL+19vSyBc1NOgdIvn9+3BBFnsfetQRcEWMxMxaEFyIvaIuZ2gJnuTWI6dwNsV0Zp2/6u0dwobAkyADOFLFtGDzOER23pqFpXJaiFwIgYKrr2+WRpZNkp/PleTu3UJhEwFh7XawEqt4d5WpjM1Ei0gnPH/EfbDJYJnXs20AuJu6gPbhlG9EemkdEWcwEwQXJmhValmXZ5con2kmYUnqL0s+Rp6x/6Q3SVt842epyucmHwVAxkntB+wIqK1BRq7m775hauoML2OHw+264lHdcEfrjB7tY7ucQTD+kpd9c2mmizL62AZbnhzWtpxuRqIMWxcbnZbuwiPzjrvKwo4mxSzgQE5tGREIZTVGA6pw/StljbtoJLL79zQuiLx+1Ut8Zl8Q5sFWElSj7DegAqXan5XTmAmN9HQSLQfeJulikgmvdTacE+8KOKtGnmleA9rNbaMjDevWGuD35g08LW4d3alNIkJpysFsfXCLHj8kJfUjTHAMwLFxdz5YvquowGEIlLez/FY1urKQ4QfCjiGt
 EgAQh3hP
 s3mRawtu8zjyUMhTUUMaBoPdvY52c0zVKrMbVjlkFrfvzb/zLFqrfD89cQZSYIAviZmUPHVtDhaczHw8T5Fs2+Gm7wdgOOX3khl/DNCoWkM7pLNG0y7pNDfRvinhIKIB5+pTU2PR5TljTVccgsB1y8y3ug9qya6o5yUZxtzBz4RgtCeuBWOlmPdZPUSLvXmlYpNXAaUrRaj7GzPwO4Jm0TQNEQhLsuUzzEoiNAj2yp7Xzl7GbJdCJDNW7GwNmfOByTbALGga8iHLZsz5eiTCJ3YlQMFDy6SHJ3RG22HzfMr/z4K3frNkbc784bUHzCEnvST7gJzJlfF8RdyLOoUbckg4dGhkKRMHNlJ2BqWUOvE7x4JaFhyrVYwDVrQvqY5/+ieDoA8515hQ9j4dzd7LXHfuAdguPvQPokpvywXrjj6wCZjIrEZqEoE7DtibMIwyaudd6c/A+E0Zchoorw9uRmYyBoWrISsuLMNQGXLrLKPw7mE68BsTPxCT3ykYtLN5/IZjwtP1ix9QD8tFmwZ++VE1BVoYmIjGqZnyeYOXl3U2kSTlUzXoisA9nvTJwk+dGav0DlDcprwDsIK0sXHnidqr13ZOmKkt84aANKwa+1UzMguWEHsdUmxub6GybDMDk7F9+9XxIeny4/HT2pOcu+hK/qQBpT45Uav/9jqAURo/iT460iFZAHM4GdG5InSP8elw1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_ops_id enum to include DAMON_OPS_PADDR_IBS and add the
corresponding 'paddr_ibs' name to the sysfs ops_names array so users
can select AMD IBS-based PA-mode monitoring via
/sys/kernel/mm/damon/admin/kdamonds/<N>/contexts/<N>/operations.

Route ops that report accesses through the hardware-sampling ring
(currently only DAMON_OPS_PADDR_IBS) through the existing
kdamond_check_reported_accesses() drain path used for page-fault
reports.  A small helper damon_ops_is_hw_hotness() centralises the
classification so any future paddr-family backend that also reports
through the ring just adds a case here.

This routing is bound to ops.id rather than to a separate per-context
flag.  A flag in damon_sample_control would have to be set by the ops
.init callback after damon_select_ops() and would then need to be
preserved by damon_commit_sample_control() across sysfs commits;
deriving from ops.id avoids both pitfalls.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 13 ++++++++++++-
 mm/damon/sysfs.c      | 12 +++++++++---
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 35cc3d42fcba8..16da528845d03 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -669,12 +669,14 @@ struct damos {
  * @DAMON_OPS_FVADDR:	Monitoring operations for only fixed ranges of virtual
  *			address spaces
  * @DAMON_OPS_PADDR:	Monitoring operations for the physical address space
+ * @DAMON_OPS_PADDR_IBS:	AMD IBS-based PA-mode monitoring
  * @NR_DAMON_OPS:	Number of monitoring operations implementations
  */
 enum damon_ops_id {
 	DAMON_OPS_VADDR,
 	DAMON_OPS_FVADDR,
 	DAMON_OPS_PADDR,
+	DAMON_OPS_PADDR_IBS,
 	NR_DAMON_OPS,
 };
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 03f9c671e8bc9..2aa031cbc70b7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -73,6 +73,16 @@ static bool __damon_is_registered_ops(enum damon_ops_id id)
 	return true;
 }
 
+/*
+ * Returns true if the given ops id reports access samples through the
+ * hardware-sampling ring-buffer drain path (rather than its own
+ * .check_accesses callback).
+ */
+static bool damon_ops_is_hw_hotness(enum damon_ops_id id)
+{
+	return id == DAMON_OPS_PADDR_IBS;
+}
+
 /**
  * damon_is_registered_ops() - Check if a given damon_operations is registered.
  * @id:	Id of the damon_operations to check if registered.
@@ -4048,7 +4058,8 @@ static int kdamond_fn(void *data)
 		ctx->passed_sample_intervals++;
 
 		/* todo: make these non-exclusive */
-		if (ctx->sample_control.primitives_enabled.page_fault)
+		if (ctx->sample_control.primitives_enabled.page_fault ||
+		    damon_ops_is_hw_hotness(ctx->ops.id))
 			max_nr_accesses = kdamond_check_reported_accesses(ctx);
 		else if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index fc7256e522a69..261ccf0c61846 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1388,6 +1388,10 @@ static const struct damon_sysfs_ops_name damon_sysfs_ops_names[] = {
 		.ops_id = DAMON_OPS_PADDR,
 		.name = "paddr",
 	},
+	{
+		.ops_id = DAMON_OPS_PADDR_IBS,
+		.name = "paddr_ibs",
+	},
 };
 
 struct damon_sysfs_context {
@@ -2023,7 +2027,8 @@ static int damon_sysfs_add_targets(struct damon_ctx *ctx,
 	int i, err;
 
 	/* Multiple physical address space monitoring targets makes no sense */
-	if (ctx->ops.id == DAMON_OPS_PADDR && sysfs_targets->nr > 1)
+	if ((ctx->ops.id == DAMON_OPS_PADDR ||
+	     ctx->ops.id == DAMON_OPS_PADDR_IBS) && sysfs_targets->nr > 1)
 		return -EINVAL;
 
 	for (i = 0; i < sysfs_targets->nr; i++) {
@@ -2072,8 +2077,9 @@ static int damon_sysfs_apply_inputs(struct damon_ctx *ctx,
 	if (err)
 		return err;
 	ctx->addr_unit = sys_ctx->addr_unit;
-	/* addr_unit is respected by only DAMON_OPS_PADDR */
-	if (sys_ctx->ops_id == DAMON_OPS_PADDR)
+	/* addr_unit is respected by only paddr-family ops */
+	if (sys_ctx->ops_id == DAMON_OPS_PADDR ||
+	    sys_ctx->ops_id == DAMON_OPS_PADDR_IBS)
 		ctx->min_region_sz = max(
 				DAMON_MIN_REGION_SZ / sys_ctx->addr_unit, 1);
 	ctx->pause = sys_ctx->pause;
-- 
2.43.0


