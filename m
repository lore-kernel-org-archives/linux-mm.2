Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 011C3CAC581
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 03:44:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 408638E0007; Mon,  8 Sep 2025 23:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB178E0001; Mon,  8 Sep 2025 23:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CE978E0007; Mon,  8 Sep 2025 23:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAB98E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:44:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBA1FB7FC7
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:44:00 +0000 (UTC)
X-FDA: 83868318240.11.BFCD2A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4A556A0006
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:43:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=odGA46Dc;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757389439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Idy7BcMf1uwCpk+e/KI0D0vit9fu5y6Rnw4Av82UaLw=;
	b=PWjrs7hIfUFBtkb/KTWqZfHeIugK/z0TJWrJp474i29KkAFKntTUfOD2ughqakZqtZmKqt
	xbO5m+uPFNVeveMdaI5819F2CkqptRnv+VLOUv37/4WI1NKQfig599SQBRcvR2zDYoIbe1
	mOI4SXKTjVf8EbwLj6iSkvpdyxziuGY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757389439; a=rsa-sha256;
	cv=none;
	b=f0qLR3sQ0pmUQC3Yx7egoGtHINdutKQk9kGZAofsxCQ7+2Sapi4lVxDATAE/Wx2BX/aro2
	utH4RGsPNYnV+oGOOudld+P6EDdLdbApqVjY122hB3PNa8An1HC/ZuZLPJL+AJEzvw584/
	xTeIZ4mMIW0PYP59TOIMlKBRxcHP6pI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=odGA46Dc;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C930A4068E;
	Tue,  9 Sep 2025 03:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D75FC4CEF5;
	Tue,  9 Sep 2025 03:43:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757389437;
	bh=L/Lbz2KLcan2N2kPl5aMa9m0ysN8kEIr/AYdtyuJa+E=;
	h=From:To:Cc:Subject:Date:From;
	b=odGA46Dcm3MWSP95DuGe/5RlQEgtLVssOUaGdx3ubKvbhCCpStwmfZpn4bg7+XzS9
	 itnFZVga+XIkG/VtdWc5YXzrSfeE0Es6u0ctSercDmA4BBLG83vx0F+66lvSKpzaex
	 lDH5YVDxg5FPnbhDU+RmyfZdmknFNL2meOUgMYs/bbIaZmQer3+YW43VDLLtcQrVGM
	 fE9fwiPWIzZEPksTqWzEeOCtS06z6z/WuYjzyDjBWWm73zt7JcyvYzo53ua8OKBgYY
	 35B6B45v6/uIieQ0nKZkxwpLORJDnN1nQooy6TrxjnJjBH/FjHKuq5jKkQSwRABiC8
	 cvrC+bIaGG9kg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: reset age if nr_accesses changes between non-zero and zero
Date: Mon,  8 Sep 2025 20:43:53 -0700
Message-Id: <20250909034353.7064-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4A556A0006
X-Stat-Signature: j3x18wh9sofxk8m96rkff79imfke7j7r
X-Rspam-User: 
X-HE-Tag: 1757389439-191070
X-HE-Meta: U2FsdGVkX1/leLw0qEcD3ZZvww9hbEKuliSO6ENJqhjWFqSxRHjhx3bDb+sTWc55CDOVAmceLC1b0aYNegWI5cKEKucEALHweAyKndmDcdJReyou5z/mQ+qge1OyxmKubVs9pWaaTG33sWar6oWVyZ1UOtmx+gwCE07m2k0PDUD07UJFM4drX1/odZIohcD6EGHdNaQi7k8QzNlenZMmYgaQ3fsrHTnttc5Da/HEjLd7azuEM+oKsCocFKHaRAO+elv33KlOXk3aB2h+DWpQEwDXI2YiBT9kMXU22mRmQW2Kc87cthdOML+noVlzT2dj6dV4Lo3Y8M4dyLCHg7mcKMxR5fMSKekce0PiDzZR2ZvMLoILrkRVmOGmWYylzvpe4RtjKl0Pwp0jqECfarpfWGnDbUaLB1ADGwL/PQtghXO6X2ssEwhayb7U4k+JUEQF/4fDoxjwhYxDg3aQwW9RYlCAu0zvPJqndn6a43ijJKEv48nBXZ8HzSEWjMqk7BQ0GWyNKjWUGindtQ98lX8UfCTYk3FDspVF+79QhLKH3HrL41hNowNS46S/NnmSyMYKW8hjnTv88jxGi/w3qiVBrh7V8VO2BvEoZ13Q31BDve9XFBtt6A0PlPCgOOdtAQcTMHJ1KhKEPuoERQL1MXi1DISd637KAmVxGEN8TVXc0vbeJZR5qVWXZXZIh5Ewc75MugTAOQlrTWWzRg1los6crZ9FBGwiPnu34Ntlqv6ilzW1Vul5Kz/SG7K5Tb+mrMdNpfajZclV0MS9tcthuRZ6QxTNwWQrVdntXIVjJa0tphWfcaPLmDqLSqoUWVm72d4bhPtZ9TkD66Aab3mSZOzT90V1lu4xu6te09fCrzJKuwtUYZ4nuOYcvnTyZLNdXhCrED4jKIE78Io1yH4vpvrXufpVa7vr2FB3UXkzgWE58q8yaOlxoiCELSmfNzWLNSjusGnwhoK88O8EETV1eN4
 lPIonljM
 e1TBPwbhl2xRy4VwtoEorplS7tmFBhtTvygR6HC1ym1jjfOWCDMr5NsDXHll0ObQHE2b8KOsh1uJFe2tNJK6G2gLbIDe/pyMmIjNZv24dc2EBOZOn+1mmpzgBREmUSd0AzrRAqO1fLe4FqZLQDi9svASktGs6h8tuV/4Ll2eIDmbNHywYTgH9c6Cgk1DjarAmMJ1rEZ5CT3SPmnUMeM448IKLvgH2qH9RPPX6tdVOeltJz3Glz4HO6uj2FboCcdMBm85EVVQJy/i9+I6uvjy1c8txJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON resets the age of a region if its nr_accesses value has
significantly changed. Specifically, the threshold is calculated as 20%
of largest nr_accesses of the current snapshot.  This means that regions
changing the nr_accesses from zero to small non-zero value or from a
small non-zero value to zero will keep the age.  Since many users treat
zero nr_accesses regions special, this can be confusing.  Kernel code
including DAMOS' regions priority calculation and DAMON_STAT's idle time
calculation also treat zero nr_accesses regions special.  Make it
unconfusing by resetting the age when the nr_accesses changes between
zero and a non-zero value.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index be5942435d78..996647caca02 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2261,6 +2261,9 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 	damon_for_each_region_safe(r, next, t) {
 		if (abs(r->nr_accesses - r->last_nr_accesses) > thres)
 			r->age = 0;
+		else if ((!r->nr_accesses && r->last_nr_accesses) ||
+				(r->nr_accesses && !r->last_nr_accesses))
+			r->age = 0;
 		else
 			r->age++;
 

base-commit: 580b0ae8069448252cfea72b75ba5b0857c128e0
-- 
2.39.5

