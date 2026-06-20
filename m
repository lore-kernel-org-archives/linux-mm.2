Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B11DCD98E4
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8841C6B009F; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85BB86B00A0; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74A556B00A1; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 325C56B009F
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A09BB163C94
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:10 +0000 (UTC)
X-FDA: 84900961740.02.5C98AB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1789740011
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTtfTXie;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yfz/vcTh4OReLW+aHL+DnaWiXdgfMAGg8KOhU15bMGg=;
	b=kK9wcSNdkS48iaEhsSw8wP5Xrf+QJM+ZrvtRyGL605l6fXUh5IxwzzgswT0/lpgLF9dojZ
	PGd5HaadPchb04nxJOmw5YE0gz8pZxOTgnjgtQnAFaIzFxuCZi/fKtjO1Lt1SLyJX39Xut
	L1v6ckS108EmddgCfv+xaX6AquvdlWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976189;
	b=L55BJwnr6L6UbZF6psZiZqnSPAf7Rq3fXt63WtmjBoPMRKMwmc2negrYQIhnHNPpFvMjw+
	1f3aXORWunJlWfNFdznUWsQQcVT8ucrw2Fk0/XbPvY1YhgSLIu5IOv3LHCqvYAP92p4+jM
	cxZ5XGhFibxGu0PrM3oBkZWT386M2/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gTtfTXie;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFAAD601E3;
	Sat, 20 Jun 2026 17:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA651F00A3E;
	Sat, 20 Jun 2026 17:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976188;
	bh=Yfz/vcTh4OReLW+aHL+DnaWiXdgfMAGg8KOhU15bMGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTtfTXie4rpOXmDrW7lYvFVx5Ab/UE496E6cBNmBB1TnJIAonQ+ryJd5HhtirwLWa
	 IUZ1Esp4iSqssik3vgktZIj9o+iUTp++faa+XPzj0OQP6RBV6GkkmyTFKvIWAGdnIC
	 pfxXn8gSY9DHzC1hjw7C2z0wFI5Fl0Pxslybcz//GKcuvvYYwXWBYrQHSM+53qgCvi
	 I2A7ZWPa1uLdawkKxOzFBHFelUW+Fpw7J0u1ZCRlwoj8NcU1yksLI9vyo10mtivNn4
	 j7cY0y22vlUARD8B9TzcK1N7VHmQo49jqGJ3P63RFmmPRUtau4JJv6O3Geps2AP3V5
	 oNDIEkaSF6a4w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 11/13] mm/damon/core: remove nr_accesses_bp setups and updates
Date: Sat, 20 Jun 2026 10:22:41 -0700
Message-ID: <20260620172244.90953-12-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1789740011
X-Stat-Signature: 58no136sd3pipj7kyscn6uqtfp35kdwz
X-HE-Tag: 1781976188-965893
X-HE-Meta: U2FsdGVkX1+SjkXhA20Aetr4BNMnvbJuPIJaT78gklc+N3fWBOljtI51aFp5mcLfygU0m80EB7rjjrH+eGggNomoXTbciJ1anCUnafT0oAu13dSv5i14z0V3VJEbfgUG+GBc99xB5g9amGQtODKLfK0aFV4jHU/KWXznPp+6z2oeKNiZTem+nueKm/B7kN4clKDdouQSUX6dGSVsmqDrt9z8rY5brrW3yFJ6k7XGs/gHA3wb6E+FbSmiKdZF7F8FaTDUxEZb6t6Gi7ZLmBky7yDegT4Wx2Ra3vArNWFduHDygOeZ9diwcFfT+8VorKYm4+nodWe0OuByzbbP4C289Y6+UzeNfDMX2gpUSD28hhVZUbJ3YoNi1ttmVjtJpNEzNBk4sTZgGu6VrkIeY+eRfSXxil4wW2p9sKuZbQGMdmsrMANWjVZrYrVqrmoDpGScDGUkWaaH6qCy/wqxvDlWgsqnMHvWyHP71cUl/ZA3UsSoAg5gn+S39iK4Mm/Y05bhRYSKZuBJdgW4rkuv3soNtxLOOqOEt7k406uLJsCAKLpAxp8PuXUnLwqaS4ygYJifxGvLJKPVuTn+EZnSSyaIfpZdmZdjbM4XWDJVnCmF5osEcnSnhMIYhKMvx9hgGIxgokrhEe6wayXTof1XmcPotngz+YSoLrhfgg8mHrxfFWCS/gKZIovlRB8+b1x8g+sj0mdtaDnb0CcIR9H1nyPnInPzjGr8CU58CSQ4Y9aZDR2dCbIpOINazPiC+L1Dpj/ef2i2RpRRn2Hwq+qFxFkJIyPjvn4n+kH/lL90xT9vHTAEbioTVqtSMBtTUNO60oCZfByxiaAB7vMPHIrrWA8HmSsJY+LwvHjs2K3+MZxtWYArvYDDBQbVinKStMtFsFnjYp/FdodiDqg4rxop2hN9KflK3g8QfMxhr8a2K//3P0Etc0v3GY+CAQSDdqPGUjfTJEkyad9LTvbPoqyrliV
 Vc0aVZyQ
 MEe0i7LKuKImV29R072nzCk5rKFQGsfN+SAc+Hr6hd1wlQiYizWikRJ84grSQyYC2LQvT6zn2/fP9dXu02L8hF0ZdKoA3xM0YEcqFyC2mLJBmZba73lLO6tSxmDGr931+4vtDv+ZOsluDeJW+MsdwevQeE94Wub7lZRGJMicaQTDOyyJkXzOf/UgollsezPPxhsUFwyoLY+mjugxWZT/o29J4wcGcsAylO20qxS0RL6YPWgh7KR4Q0Qs7mfKVVbv+vP6baqZFMk/C8rPYWvTtY/HwYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core sets and updates nr_accesses_bp in multiple places.  It
explains how delicate it is.  The field is no more being used for any
real purpose, and replaced by a simpler function.  Remove the setups and
updates.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6db157ee25129..471b58e8e31b9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -296,7 +296,6 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	region->nr_accesses_bp = 0;
 	for (i = 0; i < DAMON_MAX_PROBES; i++)
 		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
@@ -871,7 +870,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
 	if (!aggregating) {
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
-		r->nr_accesses_bp = r->nr_accesses * 10000;
 	} else {
 		/*
 		 * if this is called in the middle of the aggregation, reset
@@ -881,7 +879,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		 */
 		r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->last_nr_accesses, old_attrs, new_attrs);
-		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
 	}
 	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
@@ -3098,7 +3095,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
-	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	/* todo: do this for only installed probes */
@@ -3210,7 +3206,6 @@ static void damon_split_region_at(struct damon_target *t,
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
-	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
@@ -3779,18 +3774,6 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs)
 {
-	unsigned int len_window = 1;
-
-	/*
-	 * sample_interval can be zero, but cannot be larger than
-	 * aggr_interval, owing to validation of damon_set_attrs().
-	 */
-	if (attrs->sample_interval)
-		len_window = damon_max_nr_accesses(attrs);
-	r->nr_accesses_bp = damon_moving_sum(r->nr_accesses_bp,
-			r->last_nr_accesses * 10000, len_window,
-			accessed ? 10000 : 0);
-
 	if (accessed)
 		r->nr_accesses++;
 }
-- 
2.47.3

