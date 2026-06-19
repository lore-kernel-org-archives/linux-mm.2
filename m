Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C55CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:35:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C6076B00A5; Fri, 19 Jun 2026 15:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152606B00A6; Fri, 19 Jun 2026 15:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094FF6B00A7; Fri, 19 Jun 2026 15:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2A866B00A5
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 50572120538
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:50 +0000 (UTC)
X-FDA: 84897664740.24.F2E9043
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B8E8280006
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YfbyDuns;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cGEwdWm1i2XGPdtfoqBvAk2HJiq3M8DXniB/T4RFsYA=;
	b=pyACzexN6VqbO4WhSiCkfNL8GhOAP3h6wIovu82QnxeI+EmCpOeXiNN27cR583qW7NJ53B
	iZ+1MClMTNfXwuiqFnbzfcxMQWtdSrz6C+5Hjy+xJibxoVAHWiVdtbLC5dWB3YVe3Ps5pd
	XZOQqCjSBJJYzlNmss5dpS1Oqo2CV5w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897688;
	b=hF48bzEO1qtXX/ESFM7Ur1SA3NWscVRDJh+90A26d84RPHx9Y7nafxO+qOYjhxsnMKezIh
	rCBh1J1fb0UghsxDSJbV/LNwMPciSp4mexGEz0HlW6wcl2TDZshkQbQxSoP5vrCWdP6X50
	7++MA3PAr3aVeVkQ/h2YmDrRktjzj9c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YfbyDuns;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60090601E1
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB351F00A3E;
	Fri, 19 Jun 2026 19:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897688;
	bh=cGEwdWm1i2XGPdtfoqBvAk2HJiq3M8DXniB/T4RFsYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YfbyDunsJZH2Wt8zzLZmJmrjtSndBIdr0N5RdX4YVDTfxX8QSKEOIAvdW3Bp6rZxW
	 0nx+ze4sL0CfTsd+H+AZMpskxmcm4cHvEhz/zVhuGw1gS9GpdBeTCobzKGzWaQ/Zuf
	 QRqIfR2DV0R4qsPt1iKfeo5llmSstkjqxO/bG4Q0iZ7y4WzWWYww2MNnddW8Qp6dNQ
	 tSGzdU8yqUD0o9N7kW0uVfzFMwG8CiDudVOAfsaSToli8PnSQChhwOIMd2aCUA9mHK
	 VwaoZt4kU+NzN0sYjcqRjlOTPyP+AAzhwdWzlZjoMyYZtfyBJsUAFKCjcm0AOPzEaN
	 GF3AIZTsxd6vw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 13/13] mm/damon: remove damon_region->nr_accesses_bp
Date: Fri, 19 Jun 2026 12:33:58 -0700
Message-ID: <20260619193415.73833-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B8E8280006
X-Rspam-User: 
X-Stat-Signature: k1dazmrrtarwo5hyqnr9hn6u5o6xqsas
X-HE-Tag: 1781897688-104614
X-HE-Meta: U2FsdGVkX19NeMLmB91cDscMG6twlWyrVDSsL6rNVIq51FGC2BJ7JZNDp2trVnot3HZXtXMhodPMcDtQW+SuW7/Pt9zDujNTJiAXUi36SsHiCQ/xtUJNx42/qaj+oh79Sd4hFcJk+vRpl1OdwstkjycUxAryyYNbQDVwePI+deeAKCXjVmGQCXXhJfJfE3HffVDe3DTOnoqqKKm4oCDBAXAOqJ/GKUxbK0RFvQbpBCmckBjb9tW2QWQyg4VAPRqE4InGpJr7nHUVbcmikak3cF9dUGCUC4O0jh4GTarGFkXjctezUPFFGLfprA9qBIcj0/mCY6tfrQZrs6hCr60ZUWNFmC+tf3+mIRs/yFMCJ9aHV5wjz/GIl42+9EfVt5AA5xm7n36Z9EdOXVIOp7w7bhyBmtSwNnR7FfTBtb0hGDa1Qvbh+kKwhhWN9fBQCxF3l/VriurvHOcnaKW+4cGnPArsHekwgT5ZG4qCMyo+kxaYDBtoaIM1g2Y6X293Hi2G410rpaIEbqWsp4B16VCwc6H+1CpXGy1xYpPkZb2wFHJTa7zAv27Hte9N1PMEEKQSQvYxAi5U9O4M8udIxKw5hVrYz4D8pZP6smxJlHOLWs++8tYuRSb8bXR+nW+jlKrxcUV34VYu0ekh7mj2xWWDlY52eSJWEbLe+9eUN8/0VViEhO5L6sMc3sXRBidpNHNngzyQAG73DWQUhAZHmUonN1wxRzvZd8NYhXKbieWo2ir+t5XWRWAhnEkCIjb7BFCJRaNnmS2QvtGs4Zjbci9V8+PLY2h0OvZcrAVo4wONk4nMhvKom4OigGWCfIs08aDIDUWyfL1YoY2emvmXbPpSdM5t3Rod7G4mKMVtKwQ4iENN96jtWKOCKG9gMgwD0sKlbbka1eMzDVRsNktxK4eF3g8KhD6ynBwc5oI0/ayqRGrfJ8xcPm+iM71cBZNwJXPQ3v7V8D8mNxy9kWFi2Hg
 qAKOp/wL
 HcRr9aV5eYzmuGoTY9UrUO5HDUvORvOcsFo6vLFoMM2MtNfV8yRypMSSNoentHcY4XAGVYUf6/P34ong8bdthnhlnsYWOFLTabdvJsncrg8+M+oQ+6aRcNxh6WGy1EGNe/DEhU6hCnQSkSM7q6BS3ztVd54iYhqSbhJBfA2QeGEqJp3e4KQQ+c/PZF9yIpei7pLUPAXcY8u8z3024l9zWV2dO6ZzhDKuQS/Fhpy9tEQ8WrL8gH4lvpNGrGP+yXYEfJeBaOj62I1plyEpLAk8+jCJ5A1YPMtZ8Zlnmm8Zs/q92ZvXv5E1rlpJASXp33F3LGvpUAg0s9pFW+sUIhDfCTdnLwhdctsp9xHkX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No code touches damon_region->nr_accesses_bp field.  Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 16e3e0910526b..cfd653c3e88cd 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -47,8 +47,6 @@ struct damon_size_range {
  * @ar:			The address range of the region.
  * @sampling_addr:	Address of the sample for the next access check.
  * @nr_accesses:	Access frequency of this region.
- * @nr_accesses_bp:	@nr_accesses in basis point (0.01%) that updated for
- *			each sampling interval.
  * @probe_hits:		Number of probe-positive region samples.
  * @list:		List head for siblings.
  * @age:		Age of this region.
@@ -61,13 +59,6 @@ struct damon_size_range {
  * not be done with direct access but with the helper function,
  * damon_update_region_access_rate().
  *
- * @nr_accesses_bp is another representation of @nr_accesses in basis point
- * (1 in 10,000) that updated for every &damon_attrs->sample_interval in a
- * manner similar to moving sum.  By the algorithm, this value becomes
- * @nr_accesses * 10000 for every &struct damon_attrs->aggr_interval.  This can
- * be used when the aggregation interval is too huge and therefore cannot wait
- * for it before getting the access monitoring results.
- *
  * @age is initially zero, increased for each aggregation interval, and reset
  * to zero again if the access frequency is significantly changed.  If two
  * regions are merged into a new region, both @nr_accesses and @age of the new
@@ -77,7 +68,6 @@ struct damon_region {
 	struct damon_addr_range ar;
 	unsigned long sampling_addr;
 	unsigned int nr_accesses;
-	unsigned int nr_accesses_bp;
 	unsigned char probe_hits[DAMON_MAX_PROBES];
 	struct list_head list;
 
-- 
2.47.3

