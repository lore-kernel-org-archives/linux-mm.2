Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA004C55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D3C06B008A; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97CBF6B0088; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 891E46B008A; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6772D6B007B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE04B140370
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:06 +0000 (UTC)
X-FDA: 85053403932.20.1720977
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 57E5040006
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:05 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JqZJuyL+;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ccJR9KUzvn7k6BzhoDEjN3sQrL1C2MxY/yOiNOzvC90=;
	b=HeiO6vlBVU0zoO0r2bbUIPFu4n0w4aR8ke+KaavjRkrzTzupjYxSyn4NoJjErSJsvuDO9d
	KscgKdWSqwts3msZa8KzqkvPX3KmVsVnX6Ny2ljc94n4ISD6wly2EvPEBppSSpLiT1iDYw
	dXQ+BWo4a6dzguh5Ou8pL8f4XGWCiuE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JqZJuyL+;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605765;
	b=e43nxajup9VYEMW/JQDd6odORPwGaED4c1D0PmxqUTBw2tuFeG4nlCYqD9pccurDB7+vFA
	xOiG1F9noYvN9fjjy44W2J+cvYHcFrPsngiHp+Yk3e8TlX3yCUggoMl+GznEZj22EUmF5R
	FKsvEH5R/wSu7jAfXNNbP+Lk18rxMSg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E64FA60A9E;
	Sat,  1 Aug 2026 17:36:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2D21F00ACA;
	Sat,  1 Aug 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605764;
	bh=ccJR9KUzvn7k6BzhoDEjN3sQrL1C2MxY/yOiNOzvC90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JqZJuyL+6d1IhKbNi3w6gCesrHj9Klcy91QoQIT3Yfypuou1ns/P3r9cPTwoBnKIV
	 UUBjUbqYoAyh2tbixCqhvMuXxpChVokzSU1CCrquXVF3A4jx5FYg6eN9e4cXC3Vry9
	 qahhEhLizN95D1WMm9bve9Lt4DCQFkCKjdjzI4uJJoR6lHTrXiHAT/Px6f6pUGUcso
	 7Wg9gv4kXybbp3KEgKqkIBcCzvCiCeD4WocPdrWGwWrjPhapXPzQcEEwrzoqKIXcKr
	 YIsG53J1BNDLdEBw3Nqekbid0SncAlf0EQmhHeMmdz0dFM8QgahAYOkCKbxIb7r3uX
	 AQd5+b4cgEABw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/9] mm/damon/core: skip applying scheme if region split for quota fails
Date: Sat,  1 Aug 2026 10:35:44 -0700
Message-ID: <20260801173554.94710-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57E5040006
X-Stat-Signature: fiqb1c6iph14gb7ex94cg9ihoyi5hft7
X-HE-Tag: 1785605765-156190
X-HE-Meta: U2FsdGVkX188pqKM7NCTOROi4KNKMlnvDGWhot9y4JHrfuP9eNgHg/NkphgDDcImscrfPna9yvGgklmU4+Pea/QbvXW5YHRgdDponyVaIZgtlCb4lAgc+gQkU6tGQirsQQduOGrae6CLb82rJSJ3m0dz/QxdN7WE4GXV9bJ6y0JyuRhrv92fWVwYC/TBbXfquZgnMZ6EOFtpec/4waJv1G9shsvNvNXbFInp7S24PmTjfyUwXY5DlDcp8usbXrLLykClNRgg9AuQ7TT8utyCaRKRnPHFr8QfR+w7r2i+WNDFtGU8dr2tPdxKQ2cTzJWnKME6A/7Z4/1KxVOaJMTWs5lEIAaSOA6+1zpyqdVp2ApJkXBN/I0aNdfb1kDJVVyJUmO1Hhg+gU6vUFlIAf2eRPNOMhJM+/qjtbTZNGIBwuGi76909c07b3U4Gha3n6aSHQ79v6ifclaOJm0D/QvnIX7CUrBEhvzB/bimLd8ZXMQJ/AFfItGC85lRIa6gPtPlC8feVR5bgd0a1yGSc0j79stB8V/j4DWrICRkOxtofDh3dKjzjc8VIoCbgecEoNYrNBonelm4JT1rkkFCsPDglc0DohypLIfu2CmeuL6/eBB0lfoy+d8ysy3RmrjrRQ1MBU2rKRbI/giwN60q8rwhhx0rVx0A5m1udzg0D6Wazuts3L40616+tqGyRqjxx8u3xaRvpJPoepjttj18n9CVZz4eQgIiuzs8bkOj3NA7YFblzUcVTlt5ao8wzk9V/uRHqBzW+blXMk6f6dnHGTKTDlEe2Wsjkzovf0In9rqWjm0Q1hO13RJQjhiom44q5ee7Xk34ZzFFF4n7V+/rLBJE9Esp1wkebp6dinNY07J7KjrgMYe8c997HpBV8p5PLbWR5QOcWImF3X51ZOZwgLmTiRnTLtvEjOGjcBOsRh/UE/v/eJHZ8Ez2U2yuu5/ikDEwnDPzMSvg19WvTxoC5wQ
 n9itwrw4
 M+vYvGooIpoPmzMpRab2x0Ml1ZJSAWjyqrFcbSjiwSsBYCBy4MjTnFKqgkTlF5e42mKMY8PtO2YwJNV7oYAbuTPEpLWmjQsRMG4HHXOZbnGm+Q3C1RgURnOcLvNkgNXIrL26UZn8oPSDRnINf1JRS5iFU9QjfA8Y+2dJr8MlAELSU1lKYVupcN0hBjKtIC5whC3Py+ALUVM8+akdrqGvwLHM2GQaFSMd+kdYQTnaYAZIvM+k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_apply_scheme() splits a region and apply the action to the
subregion if it is needed for not violating the quota.  The split
operation (damon_split_region_at()) could fail for allocation failure.
In the case, the quota could be violated.  From the user's perspective,
DAMOS becomes more aggressive than expected under the extreme situation.
Handle the failure.

The user impact is not critical.  The failure of damon_split_region_at()
is unlikely since it is arguably too small to fail.  Also DAMOS being
aggressive is limited to the single region.  Users can set
min_nr_regions to set the maximum size of each region.  If it is
reasonably set, the transient overhead shouldn't be critical.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org

Fixes: 2b8a248d5873 ("mm/damon/schemes: implement size quota for schemes application speed control")
Cc: <stable@vger.kernel.org> # 5.16.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 644daf5a16560..e2900d0c984c9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2613,7 +2613,8 @@ static void damos_apply_scheme(struct damon_ctx *c, struct damon_target *t,
 					c->min_region_sz);
 			if (!sz)
 				goto update_stat;
-			damon_split_region_at(t, r, sz);
+			if (damon_split_region_at(t, r, sz))
+				goto update_stat;
 		}
 		if (damos_core_filter_out(c, t, r, s))
 			return;
-- 
2.47.3

