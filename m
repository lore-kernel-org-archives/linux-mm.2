Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CD82CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B0436B008A; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6566B0095; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 108076B008A; Wed, 20 May 2026 02:29:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E74EC6B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7B8911A017A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
X-FDA: 84786820860.13.ADAB997
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DE2E918000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyIpHYnj;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	b=FAdNAKUfA19p33DDXombIoNPMsgyIMCt7Sr789gTxjTdk4qSwC1npeOoFUPYWZI89YUSt4
	Bs6H26A/UBB/nxeOu8J/KSWfZXmzob7PRcw2z2rsfb78g0H4Gj9AsJ5g8d0bDM5Mvbr2L+
	K58nQTcggW4PTu0Qb8otOfY7DlDni4Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SyIpHYnj;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258548; a=rsa-sha256;
	cv=none;
	b=UVLz5xYFZsS3OAwObtMknA+wfNia4F5p144/6Gx9B+mLeWZatzFqSYOuNKdjXjr9d2m4fT
	lpX/QHfOgZIKSFlIgAzhmAPCdINNN4laf5qK6g6MCn29r92B1DwdMrl+pHPX/unUw/2oSN
	XyWtr07gCr6eDpTaOnnEC789VBys2YY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 533B0601F3;
	Wed, 20 May 2026 06:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA59B1F000E9;
	Wed, 20 May 2026 06:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258548;
	bh=5i2WVbg2PjBsmn2NfpjKEh0VGjqNajgL/l9BFto2EhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SyIpHYnjvm5BvCUeqEVymybuuMIUQkaBuEJ8pOnKiKstfFIQQasKUJ8E3+IQRi8EL
	 ++ItVK7QeRL/cDh/3UzevM1WxJc2l/rBxLrfxz+EqaI+WdxrdfF547J7zqN+fM3NM1
	 BOdn2Zo52cOP1D3oobAwUUoe9TpEuPeo0qxzI21COSS/ShGGs56TR7XW1llorDFMqY
	 x+fZedTsTZf763mlRhzkDXMB+DOdOBM6oVxAs4nLW8Mh1ak81EQOHaserdRzql0HWu
	 UhvQpB6DPCM7YfqU/P9R1Q7MsUifJTW7tfFC/wKO5UVinpsoOqYjLg6d7SkP257R0b
	 y02wySKMDj7gw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/14] mm/damon/core: safely handle no region case in damon_set_regions()
Date: Tue, 19 May 2026 23:28:33 -0700
Message-ID: <20260520062858.167011-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DE2E918000B
X-Rspam-User: 
X-Stat-Signature: nbu7bndyp99po6xfbix9acnc9iis8phi
X-HE-Tag: 1779258548-702133
X-HE-Meta: U2FsdGVkX1/GRPgru/SapiuP/Vx3PYsfivbwQZWpGFtFLV+HI30E2t+5dE4tv5fImZrryDgKsDd/5CY/XAqMnqRCVzeVcCMLHh3CqSw0b0QE6eZuck26SlbXqr9qaEci+SAcbL/9eaM89Ta5Mx8szM5YzTe5iawEkhkLXRzkkDioaMAl7BCACpnX4U23YtIXvwG/q3TD2tY0g+jRQP0qRhn9l0184kUqm9C7UgOHrIOcgSS2qsjWUVQYA9vJhfmzOXICYzakOsJIiSrnLigcjmvtGnRS0QF6uExY9UQNe/sLxDsEu3bMtRkKOZaNrkYc2X7RuhvAfriTgEq1B1g6D6KxDzuiwy6HZ6VA7T+X1DhDwB58uMLXk/CESmexyRlMv3ArkxztB4yp8utfgD/Z+w+zbQtbHOD/lisRYTn9FWXw1F7tiI0CN+YstvQpha6eO+x+XVmCRvfSmuDRAbNdbAzgy8DXmCQe6Tj4L/7ZUtxMbNMugPbgH542kdsiyPE3HFB00Sj7VQ6YTa7Q3cAqee5Gvd7nmX8Cnney+2pASTfkPd5l9pmSljLyZn8D2MxUYRxaS+4l+sCXrKnZ8bd3xP2FP8LZvqB2PRMX2U7ciSpJmQMURfcLNAtQ1RSXFtA+3s3mec3dRpHAYdYGdX/iNHZMllpCViSnORQSTTSvneIZs/NvS9B9XgA/VrZ+HpTcqW7kq/49TpHD4Xrq1B0nW1f7vdChlp4KqVM8Of1Dw/u0jxYrtNSq2dHEzOxatmrtvMkqxGpWAr8yo61k+G8Ejzy7ccaTTE8e1SenK7BcdODv0kYsSz0pd4fwD7EE4OPsB0xDwoLVwGd41maqgldMhjjv21Cdgs1e+u2i3aTpjO9E20EQlfiYUy3lMq7QfZDpBfq5aRf13ps5JnvWy8otb/3cSEx0cyu6fOUFCJ5K6S5TAT2Jf1nr1iL5k7pgKrhbnOaCPzdjXd4MoSpob0R
 2rkHJLgn
 le0tobg+wA+hg+x2gXZj+GfByiVP5SuppXJ/3hBWOV9nKMTeGl/Pft3ycqvVlT5lU/XQYo6onv51BxQtF/tCXkRkTm26y9HhLBbyV6y5Cw5c7iVodK+SbiXK1WbtP8Ij7zF25keVNOuy/GSCq39OYDXzKR7xcSQFQbHxSrZKopQ2XW3T1JdXlj2MBDqoaeGiyrMlCziPGyraMnWMtGDLLr5HsoOhPNvqtS6N1eaF2BTnSLHY=
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

