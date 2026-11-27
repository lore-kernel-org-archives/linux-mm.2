Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28839606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cImsLGCP
Received: by kanga.kvack.org (Postfix)
	id 107126B05BC; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01A696B05B6; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5E86B05BC; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D0C06B05B6
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3984A1A0514
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
X-FDA: 85482336702.24.4B61FAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9DC10140006
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cImsLGCP;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818449;
	b=V6J7pMoe9pA91QDShXNRZd4dYyJ9BTungVW0m5X3eIlSgHHj1LtebcDs8rn8VZGTLZv/Y7
	f8hJmiTwlDxzmygQi9bZkam1HTXInngNy4e7Rmpr1YqXCKLICIxfLwLlWwbkqzAGpn9zEV
	P9e9bmgNP8W+BG4GRoQB/9AKKBa5Ve0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACRfM9U2ztel2rfr1ksCVqjT/nvZz93T+KydwhCu9s8=;
	b=JqLpCf4mKp8nAqX9wv43S0QmyZDRwlKimP9l5SqLegcPbrsXoT4BfTE6UROM9BrSgxLK3L
	x1G9QUkcPuudzPtpECQPmKSgS3DbQBjN9h6GnpfC3lW/rhnVo/s1xYP9XPnO8mQXqJdgq/
	wS7wrppGL16L8Y0/u3Fznl9qkDouxM4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cImsLGCP;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 90B374529D;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 571A91F000C1;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818448;
	bh=ACRfM9U2ztel2rfr1ksCVqjT/nvZz93T+KydwhCu9s8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cImsLGCPLUklWtjQAlQSVHslpdhQFh5EKqK7zGSJT6JTJA/q2sRpLueYWy4UMiSKD
	 R2bE698uWio9hCwx79zG6DKiDt3ZGQpur6MQcxYCSg4WDFHO4jrfh/qL6xi+npRPOA
	 okpheVbxNtdqv1NuaHm0zazL/5Bk0B0JChNMijA0bKdwXIJIY3xlLfZGd30+zcqn9B
	 Pd3nznDrOJmaGYaGao2Hmm3/L9eFrI5JXKTDjUrY/gXk4EbBhMSmHzEbKWLA6xcSQb
	 zdf1+Qg4zhreG3hfKlI6507dNVr9fXCc8xYtTQywq55O8ZX29wnze2oi7Xn1nOYF1u
	 heknTZPZgM5JQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 4/7] mm/damon/sysfs-schemes: drop redundant and racy zero target_value check
Date: Fri, 27 Nov 2026 14:27:15 -0800
Message-ID: <20261127222719.105510-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9DC10140006
X-Rspam-User:
X-Stat-Signature: whtfrm8zhmdmro1kopmgw8t9k3aqucgu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818449-227070
X-HE-Meta: U2FsdGVkX19GSEFYxaPmHvKEmNQm6bqryFsAq2ppncsADry8knb0A1Qu4vSRYMu4NczjWNHs46nDHCFp9ZmT5sW0qwtbGKoJJ4nQl3Yb1DEYKWnwyUBiUIEtVTOGAw553nOX/YSz6Dr5/A9CeTZrInVnXSLK1ercdzN6zS65X+HhGSeC8iyCxH36IOrdNcyL8Rucp4e10lHyWWe8jFeRmdeZkZAd2lUb1wlRGeMNqnDUmRkMfMLzaZjLMdj4basaEKsPSJalgoyvvv94jea2GDPFyhU09Y9uYvMjeEPjeinLlaXHv+YhFpxZiMx7EdfaSqci2lLVIcREAFQTyvujOKjfRUoWrOwEzfmgUBpYkg2+o6yd+PX5qktECAweWU50Gg51YZBw3zf+FyrsXqvNu4ErCgw6uuS03Y4vvBTM6sU8JIXY2qX+Ni7fUJK0xjgnP29yW13u6m1jEUYloxrb5H8iHU2NDEeTy9XsybhKlQNb3K8Fzl31WnLf4XRkr1efZW/TND2vmG8gmWyPSjFI64cDQJZ+rOLxbu9bf/HKNCh+Kf9ZiDTEF6tRZ8z4IQbjjhaGjWXcK56US32NcTVsmnOC46FcWynHc3fkN7cGWxYskiLxRkCPPBTOQu0esb+5z2Bxmh/O52cvSiwAr1eIS/LjnJ/Odx24jCm8U4aPCqISHrzvtbofuSyvzedfOxRDpi66zlPiITAcPCaXos3gdaz9HkIEE1IaDvgmEUQwpSMudSKPIPf0M9Zw74yYQLTGpDlpS/BkWoXJZHEpsElM9MGuQbz2+H/H+YXDUkA7dEF24KO425l/nnpAQxl3v5pU5YcjZgxDOtgESmlUIsPGlFbtWV5e8CuDgFsmwYgA+QanYL3fsjQPoZO/EbkvSEtY8IdKnKnDxAqDlgf7j5quKIfhE5MOIWYIa8fLP5UA9VXVU37akMJ3yxfwEBzX/AgLiXSemKYEmWbUqp8ogwT
 BHhHw1J2
 62zDCIB3gBStojjH74gSGWD0Is6iB346NYhjLmo7CXRO8wMrzBNIA1aa757j6qbbSJsOF2jM3kr5JyGfA5FQw2mLt7h6xPTZZ75G0FS8UwGc+XVsnP8Z+08tfg2zk7nou1zxD1ozSpc/SCdQ02VPO9i4oS5ZPY8bIi5h4ha88T1baA9WcYtF5qL5DimA6W/QbbfbEYbc1igo+ST+nv9i09GtZ9bDgCdVT0Ow80vRubW8ywNdZB0SwguQRU2v/9l+Ep7Rs9I3PgQ8z0nSs/804ZUCezPWD+dDBJRMiRjkFZGyMGkI7XEdNFfcqMXJytBH9g0CnUEULtKbMhJiHQVkT2x9tO4DBfGxOmdGNRfQ/Q+upUs1FX9WovHlJLweSPajeFycu6mBQqvo2fQp/RCsi4HqBcDtZx3tMB4bfaOD/hgAVgeBIIBhrYCa86iUCfpHHCrF648o3XjUZXtasd6k6LjDZlFBZ4HotFE2JW/yYTQ2RLPIhwdHS7Sp2tq8jvIC5N2qm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface disallowed zero target_value because it could
result in divide-by-zero in damos_quota_store().  Because similar checks
were duplicated to other DAMON API callers, a patch series that starts
with commit 610c4438fb66 ("mm/damon/core: error
damos_commit_quota_goal() for zero target_value") added a same check in
the core layer central parameters, and dropped redundant checks in
DAMON_LRU_SORT and DAMON_SAMPLIE_MTIER.  It forgot to drop that in the
DAMON sysfs interface.

Now the zero target_value check in DAMON sysfs interface is only
redundant.  Further, it has a time-of-check to time-of-use (toctou) race
with target_value_store().  It can confuse readers to believe [1] the
division-by-zero can still happen.  Drop the redundant and racy check.

[1] https://lore.kernel.org/20261021005234.94107-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 750f70f0c31b..b0d07994f6c0 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2917,9 +2917,6 @@ static int damos_sysfs_add_quota_score(
 		struct damos_sysfs_quota_goal *sysfs_goal =
 			sysfs_goals->goals_arr[i];
 
-		if (!sysfs_goal->target_value)
-			continue;
-
 		goal = damos_new_quota_goal(sysfs_goal->metric,
 				sysfs_goal->complement,
 				sysfs_goal->target_value);
-- 
2.47.3

