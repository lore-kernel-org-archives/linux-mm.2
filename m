Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18350F44868
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72ADD6B00A7; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4FB6B00AA; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 554716B00AB; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3674D6B00A7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E24F313B2C4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:47 +0000 (UTC)
X-FDA: 84642857334.18.F63B365
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2DA5D1C0009
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sa7P2pgv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cxt9IDxRb75gGGPW+7DNrHtgJDHeEKMMLPz0bioXCX0=;
	b=PNnH/0FyhcfNgOe1rG8Kd69TNDexegn+82AMDAK16CMSvICO19VO/+k46SLXpiFxTVKgTk
	akgPMzaO67lMgDZNtCupg/O08P+2gqu+j9pHXIkOWS1rz4XUDdpUJ7dH9o7Khw6BWFwkRx
	4DukubrlhDsKP+yuIi3dYrD0kaUUJuI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sa7P2pgv;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830846; a=rsa-sha256;
	cv=none;
	b=4fjiw/mqViORNRGVkoDc2Z5q1mbHJcGw7lrGXg7nXMFCV+LXIeVTZ6SWdClhXA0so96pYi
	A1bg2I3OPUK6MfYQAqvmShPLia5r65qmNphzyEmIdcxFotEMzPyamUWbMDDgAIZGkJs/vW
	y77Nm7bhtzTpHaxwdhZ7CNfvcMnyQb8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4197C41885;
	Fri, 10 Apr 2026 14:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF127C2BC9E;
	Fri, 10 Apr 2026 14:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830845;
	bh=bRUkpmCPpf8L/6LaFfwvBKwm/4LpPOhSu9Y0BbXCNpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sa7P2pgvXdb/wIm55UTCQrMbVgTdHxtDQvPCc3KJj3Kaex7BTU/5OTffm/cf+kKJ3
	 6UUSzoRawh2Sciton9d5REsSD23HKgqL9W5PeTijYYQYT/Gdad4P5sddsA2X2YHgUq
	 7g6ga826N6x3PqZr2hssvcQMol8Gaqw0Zs1Htx5jDUN5tb90j+WowH1weW5ZyXa8h7
	 Kk67PHk9CslS1FL4LgLbILpMGut2jH14n9l5EpKDEwzqxs5otNppknE/vhxq2fcwCD
	 xw20L5IERd7a+O1uN/U8V0aTpIh9cOg8w97pGG+KKB13tVioa3dyBF2ICCEBqKZV/v
	 Ni5VUIrrfPCNA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 02/11] mm/damon/core: merge quota-sliced regions back
Date: Fri, 10 Apr 2026 07:20:23 -0700
Message-ID: <20260410142034.83798-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2DA5D1C0009
X-Stat-Signature: nfn91x1977aazw3kqjjrsmcbp11oai7h
X-Rspamd-Server: rspam06
X-HE-Tag: 1775830845-529002
X-HE-Meta: U2FsdGVkX1/JsOfXCR5KirEPlVSFiIFh1Jz0LWvu2IuQTITG5NXvwiDYltFc092b3rQPsmwoNjfrWbBW+4HmxuUXOV9LQXMWma9SHJMfLr1ijfvSOSIhRFOhQqtAHgQ+Cw/JsAccNqVO562B5xA60eBh3QMda0so8gB5aRfmsMry63zTXaEpPuAOOT4ZkVituKT0H7F42RS4MaRdUVIHKQ3KLAiHWcYW9EAvNNNX6cp8ViYLTP0s2HznUIX40ceKSVhob6uIP9d50hOC/+rdFSZjlJcJIX4UB4AobVwmZO/BtQtkVVLWU30xRGP5Ea62L5l+2VFxRlVLO3PBHmIug4udoH/pFNdFqr6p7JieaPVbqBK0AgyuzfBF1a4ddEONwI8UkpaSOYNVMyPTmYbcpUFvZ1tqko0sgbcjpi9w6Ct5H5+qFlJ69XNYR2wbNUEVr8JVGJ8EPOboPazQz6MBy3Afe3uyz4ocVOdNm49g+uZIUvbI9lpmMxnVzuH0vpibybYPVGIpw2CWulgYEWXKMas0nmPtl29tX5cJlFvg7UNvl5+kMryPjv8NS5hqCOlSPvU4YEKevdpnfb6Xi/nudmkJxiYdDFrKQnRt7M06QsKQUG3yQ8XW+B/TTiKvk8hxydevs+fr0RLR8SOxvQAtDiEfDUEPfkX8exhOiC3T/ocAltcL9BeeLRuOqffZ7TWJFt8KO6Xguv523iY+dWnc0+sIMfVLQ/BG6q/kPGx2h7E9LIki0qdJTNelwA1cSN0TOA4DdBRqtBvKctAqlSZmFcPePJKOs37HBB41mzxzER402HKBp1Dg85qw/5XUNKzBI09BBM+0taLouqtCnKB3ilGriBu1NuuchWNBd52UoEDraNqwlCTvamgxf7wrACGjXdQcEf/5mR645Kqqvf0TBHGICiRRAMidXNmWo7RlVCO8MF+CNY1S09Uj7VcCUgu/nBQNYBXuoS874Fv6wz4
 ZN0w84i1
 CjD5PoG0fm2v+oRs+MVOgJDaVBq1YRIrERmOQo6xEXX51XuEYSdNIOuAY3Zl3dSdgt0R6xFbCPAxlkrtuUtA3WpA52N2/pTITovobcZO0p5XHtogX4ohTOkNGwp0ZQYX/lF73ORZ4MT+a5t3qp6fxyIzgU8t0mUAz+KtiUbPsP6P1O45LX9FISFe4WZGVXjIOEL+26T7xr2SmZJo/IZ79tEoxhqKEW4svaue6/pZrN2mSGcg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() could split the given region if applying the
scheme's action to the entire region can result in violating the
quota-set upper limit.  Keeping regions that are created by such split
operations is unnecessary overhead.

The overhead would be negligible in the common case because such split
operations could happen only up to the number of installed schemes per
scheme apply interval.  The following commit could make the impact
larger, though.  The following commit will allow the action-failed
region to be charged in a different ratio.  If both the ratio and the
remaining quota is quite small, and the action is nearly always failing,
a high number of split operations could be made.

Remove the unnecessary overhead by merging the sliced regions back, as
soon as the schemes handling for the slices are done, and there is no
reason to keep the sliced regions.

The sliced regions may need to be kept if no scheme action is applied to
the slice due to the quota being fully charged.  That is, the 'age'
field of a region is reset when a DAMOS action is applied to the region.
If no DAMOS action is applied to the sliced region, the region keeps the
age information.  If it is merged into the original region, the age
information is lost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 39 +++++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c7d05d2385fe8..b0f673efc53c8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2159,6 +2159,40 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 	}
 }
 
+static void damos_apply_target(struct damon_ctx *c, struct damon_target *t)
+{
+	struct damon_region *r, *orig_region = NULL;
+	unsigned long orig_end_addr;
+
+	damon_for_each_region(r, t) {
+		/*
+		 * damon_do_apply_schemes() could split the region for the
+		 * quota.  Keeping the new slices is an overhead.  Merge back
+		 * the slices into the original region if there is no reason to
+		 * keep those.
+		 */
+		if (!orig_region || orig_end_addr <= r->ar.start) {
+			orig_region = r;
+			orig_end_addr = r->ar.end;
+		}
+		damon_do_apply_schemes(c, t, r);
+		if (r == orig_region)
+			continue;
+		/*
+		 * If no scheme was applied to the sliced region, the age of
+		 * the slice ain't be reset.  Don't merge that back.
+		 * Otherwise, the monitored information of the region is lost.
+		 */
+		if (r->age) {
+			orig_region = NULL;
+			continue;
+		}
+		orig_region->ar.end = r->ar.end;
+		damon_destroy_region(r, t);
+		r = orig_region;
+	}
+}
+
 /*
  * damon_feed_loop_next_input() - get next input to achieve a target score.
  * @last_input	The last input.
@@ -2528,7 +2562,6 @@ static void damos_trace_stat(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r;
 	struct damos *s;
 	bool has_schemes_to_apply = false;
 
@@ -2551,9 +2584,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 	damon_for_each_target(t, c) {
 		if (c->ops.target_valid && c->ops.target_valid(t) == false)
 			continue;
-
-		damon_for_each_region(r, t)
-			damon_do_apply_schemes(c, t, r);
+		damos_apply_target(c, t);
 	}
 
 	damon_for_each_scheme(s, c) {
-- 
2.47.3

