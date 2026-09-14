Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37EAC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667976B0095; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 636176B009E; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43D356B009F; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1EDA56B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:23:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 710AFA0052
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:38 +0000 (UTC)
X-FDA: 85212586116.17.3070A1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id C5D11C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EWiER/3E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAIupWOiZk1Nz5VeipyYWCDtbEHKa9N+XsP7giaox3I=;
	b=IQ+Qw8EEnH/+UtAOHKKUB7gDELdT86JqGwboiiPSP2H2ZgRdmvjArZ8F0wNBJofeFfzYhM
	7wPMCJhbG69FCAsKnDNomPVFZZkqzrVz+i2av1i58rQjADdSXpy72a9xKPHrbl22rI+mQ6
	EnZjhGGIkPLuWusc5m09G/XlDKPWG/E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395816;
	b=Hlr4gxR9nwN7gOFWd63KJN+L3UJcTXRZaRI6rphFq/UOxxyaEya/VD2koz/+uXoqv4qoMB
	crGJn0Fovg+hJAKSR0LJ7vQNJvaM9Qfemv3F4av0Vnbr2YQKg+36htVZ116u4NwDf4d921
	lG6s5ga0sH8fwAu73UkrZDd7Qet5Lx4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EWiER/3E";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 20E0343D73;
	Mon, 14 Sep 2026 14:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53A51F0089A;
	Mon, 14 Sep 2026 14:23:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395816;
	bh=hAIupWOiZk1Nz5VeipyYWCDtbEHKa9N+XsP7giaox3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWiER/3EXkZMh6IAzLZjB+BC/ivAJZlgAEj08Ubqs/oGEkB+6gGa10ONspOW69cgr
	 1+whmqS2j6DxXT7A6LGbsSEBERXZKTNqFgIizHC/CyIEu9s7WDorYvcPVvP5Sd6F2P
	 ZvSMv0i2EB1eVijnxMuFm35cRWfagKjChMTuveUgjODV/3e+b/1rHCvbiDbbtCRVln
	 8isMkJPRoCOFB8gGBaIwWOC8XU9r9Swz+o8bgp9yLHdy3XkyiFXsTF7fv+VFdB2tKI
	 UkBvzVtKKq++R82set9MAvGhXimbPcfsJO9/xnMmV0PVX9Z+a7XqeUfSIwf3gNCoP5
	 VC13OV35TpWag==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/8] mm/damon/sysfs-schemes: read sysfs_filter->sz_range only once
Date: Mon, 14 Sep 2026 07:23:19 -0700
Message-ID: <20260914142327.92510-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914142327.92510-1-sj@kernel.org>
References: <20260914142327.92510-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C5D11C0002
X-Stat-Signature: qs87inz45dc3uj5b86y17b5gmre34rwg
X-HE-Tag: 1789395816-668755
X-HE-Meta: U2FsdGVkX1+VBiHj+GS5inC0/3Dd+42/pRYzcVQDN+uywlgtNk6rqRo54wLb6PR6CgfAKDQup+yLzDiJcfW/mvjQyVjElEXfGuuay4nnnleTo2hdwlTNsnvM8oCsWg7riKembqKCxHx7jeh69YUnsWSlpLr2CgBwTcSjxXuZOo93L1MAQy6UJNvYhfTN/Vbh+WEK/YvvZffpAmiWcUDTAJuxSqIVgTHQRh5IUqmOkuHea4MezNmMX6FwN7f4iy8OpWXP7kqY+/XsP2ycy0YD8UKk28ZaVn2aZJSUKK7OQrg/oLwWdqZPNPmalFnMXZAfPgz7f6tnpN25EEAN5BucGrF8gxm2omHp5nRmt1vcPWlR+oX7ArnBNIY/JgCrA2c5MpMmvTg1ZNQlCTAjyXV26cVlLAuJwlK3V8pI9DT5G/ad4PTIvYpt6UqJ7lIxcvPAnxTjgGsrWOi2Im+j7QBTOKvXXSNuUY6t6bfnp5G4LQO3YpZR5FvkHID7c62C9VAlGubspM8JpPFajEPHj8lTcJXGeo2VadyayKhmqW3Kcs85FbCEZGkbMX3mtYEYhuNvQUbsrAFlzt8JBWrmc+qKvvDM1oFFCzQKjZWh3N6Oj/73tJOu8yEu5gQEW9CmhztXKU7U0ORK0ccwBlmB/FzFdC1v47tCThegByWwl1IvOWbFo+n8THD/251soUJmZwoaOUiEoX5miuYiEaC7+o8YdF7d/Duf2ilzGA8ya0YLnPMF1dCwtahM4Z0cU1HwZEGLUuSnAahu7QFrQJ+Pauwpfr7p5gPFytX0KxizhicEGrF8ndJHqTahclrPw1l/2ilenO3f6ZpnNMBNzvWx7+NcCauIqnqciIxZ+8M/nQ+k+RwSp/kTD6AvTtGhoIplO/+6QDP+dZ6Ymq5uJmqhpa6hEP0HGkgsFVT2tVb3m2qWvbsDV5nsMvqdL1CzrilzeIMmRvqoRoHou5wreWNRCRQ
 P58yIfbE
 dSrs2r++7/cwbw6zs8e/1VdbtAbctsZwGQfDuA837gFI6TCTI2H9iSfafSGroy0ki2d8X8AkGt1K24PDsqyhwpjAQYUZSChzQjT049HMB5rHBCLY/6FaQYTXiX5S5rA/G1ihC6qQUjECjDvHRWvPcJShyCbihqHqAv3O286533QZpfpuG9vvNEPLS/VYffAMqhN06LmV3ys4dMhOy9RoOVt/nSI1FC/CNRqwZcWTHgERsr/S3gPLOVLH0fcf6OEsMZLJ62eQYUbSzN5J1EwVk08omlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface reads the user-provided size range arguments for
hugepage_size type DAMOS filter twice.  Once for validation, and once
again for assignments to the variable that will be passed to the core
layer.  If the user updates the arguments in parallel, an invalid size
range could be passed to the core layer.  Avoid it by doing the
assignments first, and then validating the assigned variables before
passing those to the core layer.

User impact of the bug should be trivial.  From the core layer's
perspective, the invalid size range is not really invalid.  It just
works as having a weird size range.  No critical issues such as a crash
or a leak could happen.  And sane users ain't do such parallel arguments
update anyway.  If they do, such racy behavior is arguably somewhat
expected and deserved.  That said, there is no reason to keep such
races.

Fixes: ea1f204ba29a ("mm/damon/sysfs-schemes: add files for setting damos_filter->sz_range")
Cc: <stable@vger.kernel.org> # 6.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 3c1c1cb387fec..8c8ab82c8facc 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2840,13 +2840,12 @@ static int damon_sysfs_add_scheme_filters(struct damos *scheme,
 		} else if (filter->type == DAMOS_FILTER_TYPE_TARGET) {
 			filter->target_idx = sysfs_filter->target_idx;
 		} else if (filter->type == DAMOS_FILTER_TYPE_HUGEPAGE_SIZE) {
-			if (sysfs_filter->range_min >
-					sysfs_filter->range_max) {
+			filter->sz_range.min = sysfs_filter->range_min;
+			filter->sz_range.max = sysfs_filter->range_max;
+			if (filter->range_min > filter->range_max) {
 				damos_destroy_filter(filter);
 				return -EINVAL;
 			}
-			filter->sz_range.min = sysfs_filter->range_min;
-			filter->sz_range.max = sysfs_filter->range_max;
 		} else if (filter->type == DAMOS_FILTER_TYPE_PROBE_HITS_WSUM) {
 			filter->range_min = sysfs_filter->range_min;
 			filter->range_max = sysfs_filter->range_max;
-- 
2.47.3

