Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212C8CA6019
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 13:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1693C6B0093; Fri,  9 Oct 2026 09:50:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC036B0095; Fri,  9 Oct 2026 09:50:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED5A06B0096; Fri,  9 Oct 2026 09:50:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C04136B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 09:50:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 25A09A03A5
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:50:07 +0000 (UTC)
X-FDA: 85303221654.29.33557D9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 82C48A000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 13:50:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=idEqz+PT;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791553805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BvoaN2WowxsRE7K+3VcTpzbAyQjGWsLbE5vPj3uvImw=;
	b=OQhgp2toGAFNk2fxB7iANYLG8gcmFLDYYiBeehKofuHxe6HlxW8PBLKb7VG1BI3OC1ySkY
	VtQWyOXqFV+C14S62TCSYmob67WoBbrYRLxjA54swttJjXe0Z+mA6ZW6P98iDtZ9r6qNsF
	kxHdCptVbzfa/W2IL/isC6bjcS0w0Yg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=idEqz+PT;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791553805;
	b=2pXsMMK0TcO8XoAGCioK68B1ynlcy1dhdmv/MuBKEDsA0mtQp8dF+sBOSD6iM25gbHbz8x
	Ymf5qtrciXRLnwKnyp70qoyM3+CJWH+a1LKTy9jVF7tuX9j9X+Ye1GejtH9+M3aNW5eiwe
	5Ee/Hvpayt7BeKcp59GfflMMSG33UEE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1DB0360DC1;
	Fri,  9 Oct 2026 13:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC9F1F00893;
	Fri,  9 Oct 2026 13:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791553804;
	bh=BvoaN2WowxsRE7K+3VcTpzbAyQjGWsLbE5vPj3uvImw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=idEqz+PTh3o4YFh33xybLTkBPxha8umZ33l48sRfAN04sktAgU2LJDqKHnXMYRi1f
	 IIbml+KWNQIQjrc/LA8nd3XDx0trVFs8viE2VRzVerLAQFlmU43WMHX02xIh9B186T
	 vVUv09XNJXZm4F1qnK1pm7NW2Sl+XgMC6yzRMZNpSXc2NcjEgyhdu9dMGOlPBGUE8q
	 Ttk03fI8jNRcEe3LWpEfGsaBisTUHwC5BrdnVPi0nz7oswQnp3KsHd2iLFkHjrVt8I
	 Q+kdHQD17/hjxpnsfBIgCh7zGz/YgGmj6Y57mO7qm6ZEHRlbZpAUhOPz0sjLNxFyFV
	 jr0EBV8h4bSRA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: damon@lists.linux.dev,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y v3 1/2] mm/damon/core: do non-safe region walk on kdamond_apply_schemes()
Date: Fri,  9 Oct 2026 06:49:48 -0700
Message-ID: <20261009134949.11507-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261009134949.11507-1-sj@kernel.org>
References: <2026092948-moonrise-persecute-3597@gregkh>
 <20261009134949.11507-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 82C48A000B
X-Stat-Signature: mcjj669qgdmoh7z1q97fejtsapr479od
X-HE-Tag: 1791553805-593282
X-HE-Meta: U2FsdGVkX1+L+voW+ovj6dk/Vu22MRisoMqByR/SQHf6KXXCreTvwXrbPm89J0Obt4XCaler5egtfvD9LtSFhjCU0vYbtxWCmDuKR/NFjwrWKWnJCRnTp2jRewZRrBijOBsN+a/6+rTP3r6m4pyFpBmiTfYezjbKfen+fLrylEOaDKqzPW8t6D90Ae8mGk8BCBw2hiyf1qltd7AluwtY8H0Eim0ssaxNNgcgVyquoWhCPyxX/RcdoXhnKC6kKX2M8koL8mO+qLxDHYlD57m0f7ESFMErmhe0nW7ZTSuX2YI4GTmghjVQxCM1WMT0fx66tPBjuIZZ9Pj8dMOuiQALHNdovu7yPv/+iOF1BVBCMcV1mnEkLT1tpDYlvO6ot8xlbRCmxh6Ko1+GEtb7ySImjAK9tPV+mDccFdBlfgJymMOb3fW8UtNda6RHT9j5jjg2Pl+4Byr7J9QA7C04OQxvGi/VFfOXrxZqhcB/fGKGse3yYEEbevMWBLVuuvAcKvpauvOyVF8/xIlgdR7f/ZIvsVA8TMD2szona/iqFR97ZB+F289ecz1r9BjnmyErhjvSTfsyN/Im3KqjZkokKQn2J/vEeXSzhHoEdysAPM1FU5geHCGWXeWfhFQJpVP7otEu3WtvIBdYUrkgvUc9il7ejY4fnVq3TLywwm3AB6cE1vuNerONmNdMTESEw3vX14RHHbyWRAVNnO/bc4RS5j40AN7Pb1sQXiHl5nhvhNmKIigyrSV/PxB+6AiYE4DVIfTXWbL6aZ99LBokirBJIm/PtSjvZOVqyOM9aD0Sz96O57FiwW8meF3Hax1h+o6g9zaE+nffAjVYj0LjW/cJkdGRK0BmtoI5Z7HgaH52+scA5xnrQsfx6oCAUjdWfrB6JRjDrA0M1fV/frd9xd8QnIY3hoKFPokmsjbXAmdRHWyihpYU2nYMUyjmOgHTKg6fZrFLR6NbbJz3ndX3ACXF9Ep
 gCpTUua0
 +HC+ioqSCrJ4lmLnJ9MSv5G7/XLnaNHTzNDVFCe+pKTWbjAn0MUWExne+sInElDtBK+eVzwSCcV/tCWFg49xC2zrt56fiwgN1TTZoYu0+3zpLYa8iac0YBC379lKze9Eyx+L8HaQqe9EZ6lb5tfb6KbMO9SCWEw/Ky1eMdFkXhQeE657X0mRx8aJ6pFWidHRxo2DOv/3Rf0Ci5DHnT4rrpYArEfd/PPdRe0BrHPejQ9tAP+NEkL9UbyKmBdAkPctryJD94++mpFUKSQVepcwoaxXbPtKO/cAAbRubBTnsSEZE+EocmO0k6Uv9ASB6rfnWJeREp7ryAMSqupeaeAlvwV7nOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

kdamond_apply_schemes() is using damon_for_each_region_safe(), which is
safe for deallocation of the region inside the loop.  However, the loop
internal logic does not deallocate regions.  Hence it is only wasting the
next pointer.  Also, it causes a problem.

When an address filter is applied, and there is a region that intersects
with the filter, the filter splits the region on the filter boundary.  The
intention is to let DAMOS apply action to only filtered-in address ranges.
However, it is using damon_for_each_region_safe(), which sets the next
region before the execution of the iteration.  Hence, the region that
split and now will be next to the previous region, is simply ignored.  As
a result, DAMOS applies the action to target regions bit slower than
expected, when the address filter is used.  Shouldn't be a big problem but
definitely better to be fixed.  damos_skip_charged_region() was working
around the issue using a double pointer hack.

Use damon_for_each_region(), which is safe for this use case.  And drop
the work around in damos_skip_charged_region().

Link: https://lkml.kernel.org/r/20260227170623.95384-3-sj@kernel.org
Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 1745ccbd2907db2bdaa843e4abccde4fdaccbe5d)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index fe91b296f4c6..c86cac855b9b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -871,16 +871,17 @@ static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
  * This function checks if a given region should be skipped or not for the
  * reason.  If only the starting part of the region has previously charged,
  * this function splits the region into two so that the second one covers the
- * area that not charged in the previous charge widnow and saves the second
- * region in *rp and returns false, so that the caller can apply DAMON action
- * to the second one.
+ * area that not charged in the previous charge widnow, and return true.  The
+ * caller can see the second one on the next iteration of the region walk.
+ * Note that this means the caller should use damon_for_each_region() instead
+ * of damon_for_each_region_safe().  If damon_for_each_region_safe() is used,
+ * the second region will just be ignored.
  *
- * Return: true if the region should be entirely skipped, false otherwise.
+ * Return: true if the region should be skipped, false otherwise.
  */
 static bool damos_skip_charged_region(struct damon_target *t,
-		struct damon_region **rp, struct damos *s)
+		struct damon_region *r, struct damos *s)
 {
-	struct damon_region *r = *rp;
 	struct damos_quota *quota = &s->quota;
 	unsigned long sz_to_skip;
 
@@ -907,8 +908,7 @@ static bool damos_skip_charged_region(struct damon_target *t,
 				sz_to_skip = DAMON_MIN_REGION;
 			}
 			damon_split_region_at(t, r, sz_to_skip);
-			r = damon_next_region(r);
-			*rp = r;
+			return true;
 		}
 		quota->charge_target_from = NULL;
 		quota->charge_addr_from = 0;
@@ -1045,7 +1045,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 		if (quota->esz && quota->charged_sz >= quota->esz)
 			continue;
 
-		if (damos_skip_charged_region(t, &r, s))
+		if (damos_skip_charged_region(t, r, s))
 			continue;
 
 		if (!damos_valid_target(c, t, r, s))
@@ -1134,7 +1134,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 static void kdamond_apply_schemes(struct damon_ctx *c)
 {
 	struct damon_target *t;
-	struct damon_region *r, *next_r;
+	struct damon_region *r;
 	struct damos *s;
 	unsigned long sample_interval = c->attrs.sample_interval ?
 		c->attrs.sample_interval : 1;
@@ -1156,7 +1156,7 @@ static void kdamond_apply_schemes(struct damon_ctx *c)
 		return;
 
 	damon_for_each_target(t, c) {
-		damon_for_each_region_safe(r, next_r, t)
+		damon_for_each_region(r, t)
 			damon_do_apply_schemes(c, t, r);
 	}
 
-- 
2.47.3

