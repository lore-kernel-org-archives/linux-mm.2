Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BA72CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8DBA6B00A2; Fri, 22 May 2026 11:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D5DAE6B00A4; Fri, 22 May 2026 11:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BF66B00A7; Fri, 22 May 2026 11:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B588B6B00A2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7E6DC1C1CA8
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:37 +0000 (UTC)
X-FDA: 84795468114.05.EF21340
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id D953920015
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nu6VHVgr;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	b=TRQscxV6t2IoZSaR0k27rmZfi8KRpZ6/0qDa4/XpNzu7jVetF92LVDexZ7k1yd1YgQ4Vv4
	x9LoCWnUuJvceLgx7YzGiLNw8J8E4ZZZ8onmHV34xf94AORggJWFlvV5WxklIGeCI3K3zt
	52GUunWtfxZHYS3MGg4IUzsW3T/aHg8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nu6VHVgr;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464435; a=rsa-sha256;
	cv=none;
	b=dcJ2/t9DUJQX+l1wZpa7LYAAgVLG4McN7fn1FI2sQitbeR4E5Vp/Oc5l3dUDQS3NdnDSCx
	p9T5CtSB62skM/fcl3wYJcMmVNdP12vcAQwhLQcZ7H1uVMfdOJntfZfXLb21Z3Pp1jxh4O
	TVk9JyGEjaFNIzy73TI2hapYeBfAJUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 25AED42BA4;
	Fri, 22 May 2026 15:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35231F0155A;
	Fri, 22 May 2026 15:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464435;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nu6VHVgruu3i1j8InZ3IPJtcExdnKay13YJBkyCUQ48XduMjG2pcmZ9zkw2Vr0fy5
	 a4KkCmYBcV9WIDg30+/K98YB8sPiUuIwG4pnALMEr0Mvq9g8ZHTSZxLYwLv93nv2hK
	 0oPhnfylfUCfivCF6F4ucOp5Dr14CBiYUE6cHHbXldp5xNFXrivwYfmKh7ij5cSMQt
	 rhWU/SmOHjvDnI4naPoyhQQmak5wYbMZeZgzpTILPwda4USVrDM0HraeGCx+UOen/e
	 bBD8tYmINrQQuPRr92HOJZi7qAlMp8A4KVmpwMFOc2ttz9HgXEidQBv4rbgInb9OSJ
	 N1THtg4BC2DZQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 01/14] mm/damon/core: safely handle no region case in damon_set_regions()
Date: Fri, 22 May 2026 08:40:12 -0700
Message-ID: <20260522154026.80546-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D953920015
X-Stat-Signature: simf7q3kcky9u867b8qq33jpfb33bcq8
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779464435-27352
X-HE-Meta: U2FsdGVkX19XEiwJESyS2ki9HJrN19C0gwyzHabu8zYmNTeYZjXHhtjHUwn3ltHS6tQEqhrJDx4YWnM9Ehq5k5gfdNZ46QrblCX2H8aqzkmruL1nX7YPWju0mdXqDs1tH5m/c4gjTroLI/mgVvkVXAb4SfcMkKzzR0kT+NO2Zb2J1RVTLo8QEsPFWUghbh70Orqp+/alcrEm3d56i1ilOI7b0j3XlhLNEKcPmdoLSAncHjhY3EXQW60TL/yU57EtlnSurfnbTj9bsvRhqKz0YqSvi/nNdrEiulVcNAMTggC1KT9gjlg38hsmv5RVDNGyQDp+UEtATmrysNXbtbxV6SJ9cOSulBEb4EgFzOf2qaAM29gfVpxyPGS98itFdch7xQfpXkSiBgMH/2w4QvTIrILkjEdHrUS8sbBVcBKKXOiixQfKQfvphqtrnsxILdqBgMiKwjmx0m7SmXF2QQbPHn6nDzYv75NpwBKHdMbrhvfvD7lkQkyvAGWF4AfjF+22w/6B2hEIplInYYCq5sFNLksgzn7pZSVCQakyN2/YZW0B24dtra5TJsmFjEmkjtN21aJGdR7MUvCbaW1okhiqvflX8K64drmpUFWSfufLpsSjQXiEws51OUmbA9nGKM9KCZ9MXfdiM1s/69InIwCELjXXM2QWNSDrT2fbE3cqEovaEtkGaDe0WDe7vfltoWDoQAUjzmUA2xV2A7SFoS0veWCjZsmC57DSEc0HoV+raPH8HlYq2hNqKQ1FVt2nslPynC60A2pYKnSVn26BV86XJ02Bfe0rpSXBsVWMUdXm3X7/636z7Ts8/5ag12JM1WohRCXfNDLmhmW3kYT+r1qJBoDYib981DzWFb2Rb0V7kgcwgKB4HnLewY1qRrc3QHxsTeiYX/Hop4FvT9RE1TbhWp8NtHalmXWF5TqxlIE4qAovF5YeyZFGvXlDyOJXn4FKYu20XqHSVrhXyr2vFlz
 sG0dnAT0
 AhtCTK+VdP/7Q3qtLCYbOqsUTTt13lyl2mIX2RwIBRsaLn+aLzI9Ox7j8QCP58Vl+DdLFqonGaL/pzC11MTTwTCrIfJ0grWLV6xi3Qk+6X6FoELimqc+AX7hHKxkdDvyQfHhjYXysZW/OV0BPmpOwM0yReQ4P6i6QIy2mAXHzoXzRxYUvefv0yM/r+h/SSTYTDfbaveoK5vgU1sGrChiVy6yFOEpQ5ROs0A7W2Xnl1lZT58M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() calls damon_first_region() regardless of the number
of DAMON regions in a given DAMON target.  damon_first_region()
internally uses list_first_entry(), which clearly documents the list is
expected to be not empty.  Due to the internal implementation of the
macro, damon_set_regions() is safe for now.  But the internal
implementation of the macro can be changed in future.  Refactor the
function to explicitly and safely handle the empty region list case
without depending on the internal implementation.

No behavioral change is intended.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0267faf216b95..40946a7f6f549 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -356,6 +356,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 			damon_destroy_region(r, t);
 	}
 
+	if (!damon_nr_regions(t)) {
+		for (i = 0; i < nr_ranges; i++) {
+			r = damon_new_region(
+					ALIGN_DOWN(ranges[i].start,
+						min_region_sz),
+					ALIGN(ranges[i].end, min_region_sz));
+			if (!r)
+				return -ENOMEM;
+			damon_add_region(r, t);
+		}
+		return 0;
+	}
+
 	r = damon_first_region(t);
 	/* Add new regions or resize existing regions to fit in the ranges */
 	for (i = 0; i < nr_ranges; i++) {
-- 
2.47.3

