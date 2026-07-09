Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C78E8C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5936B008C; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67E646B0093; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BFE56B0092; Thu,  9 Jul 2026 10:06:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08AF56B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:07 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 123EDC09B5
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
X-FDA: 84969412374.11.C1C9D88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F37D18000D
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:05 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2sUUfq0;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YmfZTk/ZQOqnVMZqrheWjYkpxjXzlgMLoos2A38U/W4=;
	b=R7zZXPsm5Uz1oskyoU5VGEmPU6ouQjJMyOB+d/xgd267Rwm6lODDYVS+1ALY87bkvmqbBg
	kfohFF1WrxWjGZw5DxeFhCeS5ehOnU25AKNK/+J3Iy9MFimG1kZS8gfepl8SnRskFWunyh
	uEvVxJG46xsfwTxNA/u9UZSDWD/mkLQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M2sUUfq0;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605965;
	b=I+UK1pi7ZzUvieVEmlCEF7PyXRGRtAEg1xxdCvIPUNbh4ktsscuecA35ewNgALWDR3zSLy
	Ou1EHKGW17zyECWO0KiDRpgmZ4W9gdEbz9oJB5NTvP96PXcbTjIvEh5Tkhz5AYJ5dL8qah
	FGVFMbN5t6iEw805G8zbaUtakXMJ1fo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F12F42B63;
	Thu,  9 Jul 2026 14:06:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B6241F00ACA;
	Thu,  9 Jul 2026 14:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605964;
	bh=YmfZTk/ZQOqnVMZqrheWjYkpxjXzlgMLoos2A38U/W4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M2sUUfq0G7lu48A89v/C5h4pW3ee3Phxf40ZnZ2L4mSF1bR9j5witgW4MHnbMTlME
	 8XwGfeZHD88nz6OFMtrnTLbFC/BMfpOziO11doGr+FLSt0+Il9v5newdhiiSpR+jfH
	 DOzRqW2OVt8hNQK+ZbyvbccaPMMjIqBnvvgJSiroNWORk58GG57sVb54Agu88kXamb
	 LlC/qUuTiBuvvFXpdcpfuABBx1loprpGY1hDiqiNRiIXOUx1/iRXw4IrQ26htunVD3
	 1k6uYjkOljbUzBWYfK/icxxebvbNr1wlLrQ1NSJwV47P0WeyFqQ1rJsyLmZwffyvsl
	 eaqwwSNXsG5bg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 01/19] mm/damon/core: introduce damon_probe->weight
Date: Thu,  9 Jul 2026 07:05:39 -0700
Message-ID: <20260709140600.90950-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F37D18000D
X-Stat-Signature: 7sa18tfwhsbeuco7wobnwc4jmc6atken
X-HE-Tag: 1783605965-772255
X-HE-Meta: U2FsdGVkX1+k9oQme2eUXlb8WR8Rz+4akFQiAvSaQGuoHRSiXujtC0MitxiFYHD5I/11xJBJ5I/BJndZdcINy9vXzFAzbbli+tqU0ZeY2E3QeUaY2bJ5lsRFx1n2ftDrwAoIUp3sA3eMXOUArYmGsyezqV2vx0pzAzGvz2Cli+4n/Qht4M/DVyFu4cCmtJSHuWKPSW2ch0MIedq6sHPWQluyYBaUFyOQapnRZSVg6porGGAhNOHburC+87oX3PKs1d0dnTUjrzvAJloEUqLhjLTSXhusSQh3LcJi7qcLCxj7+jT0XzEB0tDewLNXJUxtZtCeoYSxETVeJZdak2lpYp4KIuQOs+8rD2Sdin6ylvxYSthz74nQ4dFg1pfL8MolAIkpnoNyI4ZVgYm+KGiENZu01U0NzTxg6h3CSG9xI0ArLREAzMdpvhenZBJtywu5ik0l/p443IgUkBr8SIWeq3JRul62znVXjGEQo5iXaUcNsxhEZSQqdQvr5M2WbDtWkUd5F4pRdYROb8Nc9icMbQxhCXPzcXCaNOVNSL+80F4bGDcpzReMkfLkfdW6g9PrS1WaypgIP0STNEXYCb8wge2E1f7Sfmsea7tPSgUtHf2hYSoEnFZHNrOgckQpf8w6jzSZdQpbYrVTkKMmNl+tftNHeo7odUaDxCixL4i5hEebjpcrHb5CcNcUAmnOKYNp3XMrpe3vPbQ1hzqm+HUJ3texvxMTn5p8LfMRwFdVTu2NNEM+i0WHH21ngcl59mrfhrExBIeq0A/qzfiRE2BmnLqhpNPXHuzFb47M7N/iSfA+BEVtaMIAUZIV+gV5SkFeEvNOCM4yL8SLh5BFhMVyO7cEGLxxs4GdnFO8jfdgoPqITWAaqsHw6PDBHtPMk96otH/loN3UxKtzG/Z+RKcHPHIsN3ovQCZPplvXcz6yD183b6V2YVC+V2AEV1PxgKVMCrsiCPN7U076y5G3FH9
 9y02/Wzz
 FHsD2coUXb60RLOaYU7kejUf6niXHeig3E/yDCUKHWKNAlw5WKtAwVo6LHukTqcBX0fwxDv8LQuAKrx0staFZ/Sm7Spc5nbtGEaTWcg0jDb52opWPIvBEylBdbFTiy/BQWkNXJvCFo64FBC1O2iNCkp5eiyOyan8hv0BVyh0suMdz42XT1lyeGWoGCXv+e60n+oRVnSIaXJhNK7aNtnpmcRQIkJduryAkUmoOKV7NzQUTm4eTLeClt8phU+ww4cUB1BnSSErYNCHqdN6O32U6xQ2e6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a new field, weight to damon_probe struct.  The field is used to
specify the degree of the API caller's interest to the data attribute
of the probe.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 2 ++
 mm/damon/core.c       | 3 +++
 2 files changed, 5 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 63f596957c1f1..d8251c83e6e55 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -760,10 +760,12 @@ struct damon_filter {
 /**
  * struct damon_probe - Data region attribute probe.
  *
+ * @weight:	Relative priority of the attribute for this probe.
  * @filters:	Filters for assessing if a given region is for this probe.
  * @list:	Siblings list.
  */
 struct damon_probe {
+	unsigned int weight;
 	struct list_head filters;
 	struct list_head list;
 };
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 11473aa1f70f4..327398fa4ee56 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -166,6 +166,7 @@ struct damon_probe *damon_new_probe(void)
 	p = kmalloc_obj(*p);
 	if (!p)
 		return NULL;
+	p->weight = 0;
 	INIT_LIST_HEAD(&p->filters);
 	INIT_LIST_HEAD(&p->list);
 	return p;
@@ -1658,6 +1659,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 	damon_for_each_probe_safe(dst_probe, next, dst) {
 		src_probe = damon_nth_probe(i++, src);
 		if (src_probe) {
+			dst_probe->weight = src_probe->weight;
 			err = damon_commit_filters(dst_probe, src_probe);
 			if (err)
 				return err;
@@ -1674,6 +1676,7 @@ static int damon_commit_probes(struct damon_ctx *dst, struct damon_ctx *src)
 		if (!new_probe)
 			return -ENOMEM;
 		damon_add_probe(dst, new_probe);
+		new_probe->weight = src_probe->weight;
 		err = damon_commit_filters(new_probe, src_probe);
 		if (err)
 			return err;
-- 
2.47.3

