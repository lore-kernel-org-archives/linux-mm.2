Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EBE4CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D8EC86B0095; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D65D26B0096; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06E36B0098; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85446B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 762021A0195
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:11 +0000 (UTC)
X-FDA: 84786820902.16.DD7125B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id D89334000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qc9Ddbcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8O4uifXR5w5lAJd+zyIhegR4CRBgoI+b5mk8ksj5iE=;
	b=pF2E2wXlP+R403pwf7NRQk9Is1p3K44MBdf3CH+L1SjjoORRLVbJgHUzShRHRXedXdCPSp
	7paUQE5P+RWL7L2h4I9yCCmU7Lce6137jyjx9QBKWwww83kcBWYrTclqdOGmkVY+oN6+6H
	q0nP70TpaGufxCXPu7aJnGJADm9m1cI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258549; a=rsa-sha256;
	cv=none;
	b=Y/SsvyKNbligbP18MK3H694Kokxkhfx0krNf8++dqCrwAPTlAD8rIMheS/GgEXk12mGcID
	NdnoPPXmZyw6JmSSOyTpjR2jwVIDRcpsfQ6PR/OhQpd332iUcuiKn/0W5euQCjd4DOWhuM
	3Fh+hks38aoXt7XrC8h7MTx87syNvKw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qc9Ddbcs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DA1A40330;
	Wed, 20 May 2026 06:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEF7A1F00894;
	Wed, 20 May 2026 06:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258549;
	bh=S8O4uifXR5w5lAJd+zyIhegR4CRBgoI+b5mk8ksj5iE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qc9DdbcsA86X1lN8rdsck8Ith9VhH7qaQDrLc9XUNLiDXWTpfyl0nWSdoY8JQasIZ
	 Kvea/sdvegWG33X/AQRCGyfO4H7AIvL3w4qUTLTakt4pvhhwqFo+MUl/qDQE+Ed0Pu
	 moZRf9SSlCFoUNLobHS6Z7wc3mNtyGXzKbO7tYfoCfe+fvvL2drL2WckEIeKezDIyl
	 zgJD4JEBFST0Y7EJegat5eFxdjh165yxdTp79stShqyAMO9ZUpEB4KlTv59PrO5lWm
	 ZlvQnySiUpTSCQFnkbfweQloZg7CRtyLlUmrxJDF+XMzLVcMh8O6+yXszgJ57959e3
	 J1+KPoID96d3A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 04/14] mm/damon/tests/vaddr-kunit: replace damon_add_region() with damon_set_regions()
Date: Tue, 19 May 2026 23:28:36 -0700
Message-ID: <20260520062858.167011-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D89334000A
X-Stat-Signature: zhg9xge4ey4ow3f3csqzpocc4cguc5nz
X-Rspam-User: 
X-HE-Tag: 1779258549-253407
X-HE-Meta: U2FsdGVkX19aB67hTRiCYnB/JVrZoSOBVarOHdtkgWkn8CwF0PdYhGLoyqzsH0ZhmY46EzfPMTbayZp3OVB49oBIrYIaZSKW9BF1sxYE3RYYhxtPWv1B5p/que8FIbVjbS3JUQBmcJVhuWjBLwCEz3Qwl98kjyEBuJJcQRwROj0coEJBgHV/yQHljoEcNmZXAY4jmkV79pBarNRzjMTrf/IIaYpJYi4raIp4GayvB2HKBWkWZoh7R69QRVwgQcMq+vGwHMJRl6c7Iq/PwAzLAtV4o37qC+EfrpsYsQNA5L/Sc8mHx+0Mf9mgk8+riZgeAgdGWoM3IO9rra2b36T0WDHOcOh+gt5f6wZOcyvvOHJkRruSf1SafWCLx7D6aD9aWiPJWzGZt+dBFSK5fmk/dve+KIhAceKWcLn2pORCL+HSEHqrsM+C2RlGKokWX/OOGm0ldIo2CD4Rzpyof2RsUeT5toXO6ZjqkuFFFxibKJAUAtHpswYdeP340CpDoxek0cdhlzkeq1jA/wWVjopDh9jJVgN95yApnAdl4XVyZl/J2y10w4Jqd0zOChCzqyWv+4mHDKN76iLwJdUGp3t3iAwnV4MgOIOHSPcoYzCcBS3Tu65ZgxfRLId4Kk9NH/5sXNBQL28TK5SGk99x315QXuu2c1TxLhMxKGhXzjomoNuLfc1B9Xcy/UNgEGkmcuT6ZThIzr85L9VXHloXzKbGRPyofu2kl2uo0asIpNROcGEEVGAgP/psyshQL8UOeihSj2JwPdyTspEo4XekUWs87xL1Xx2ZLU7BRlSpfvE7UDAlpfwQp87/enZqDsWog/cpwv+LCATgW6sRlTYWw22hpU1T4D1pH3zgjwtfUekUe0Z0UmDQ6YI/4+3fCYriuFMnTIyjE6Wr2vOF4JWBStNh4sls/2Bl9txv2EE6RT8Fx8RGo+rSUu1IBrBNHjp3Wa6ENr7Wp6QwyOPiY5R43gW
 uf03sXSF
 bi3wmcTqQgXgA01w/xjcrbOab7ysHq/Fvsb9EFVP4h+yPJXksxDbUnQaqkTs8tcP1rtqQyglEqj+G+iKUBf/u6f0P+3Ie8HjtMMhIbR8BjpI6VeJNdavaM/61CVu5B6dICJb8stpc1nm0PDBk9kYfIFzzagKX+a6YsndjsRX3aqijQ+wsdxbQmVFScaOzmdXjAOdXZaaQV7xcEQb6/Aykse7cdzFtfKulG2tSCNlfIU6VWgMssBATVMjggBQUxvDJMy0dZvh0chtTATUeeqIF49Orig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address operation set (vaddr) unit tests is using
damon_add_region() for setup of DAMON monitoring target region
boundaries setup.  But, damon_set_regions() is designed for exactly the
purpose.  All other DAMON API callers use the function for the purpose.
Replace damon_add_region() usage in the unit tests with
damon_set_regions(), for unifying the use case and reducing the
maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index 98e734d77d517..23be9c3be75fa 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -132,20 +132,24 @@ static void damon_do_test_apply_three_regions(struct kunit *test,
 				unsigned long *expected, int nr_expected)
 {
 	struct damon_target *t;
+	struct damon_addr_range *ranges;
 	struct damon_region *r;
 	int i;
 
 	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "target alloc fail");
+
+	ranges = kmalloc_array(nr_regions / 2, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges) {
+		damon_destroy_target(t, NULL);
+		kunit_skip(test, "ranges alloc fail");
+	}
 	for (i = 0; i < nr_regions / 2; i++) {
-		r = damon_new_region(regions[i * 2], regions[i * 2 + 1]);
-		if (!r) {
-			damon_destroy_target(t, NULL);
-			kunit_skip(test, "region alloc fail");
-		}
-		damon_add_region(r, t);
+		ranges[i].start = regions[i * 2];
+		ranges[i].end = regions[i * 2 + 1];
 	}
+	damon_set_regions(t, ranges, nr_regions / 2, DAMON_MIN_REGION_SZ);
 
 	damon_set_regions(t, three_regions, 3, DAMON_MIN_REGION_SZ);
 
-- 
2.47.3

