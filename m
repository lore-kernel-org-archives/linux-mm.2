Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64E96D73EBB
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:41:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC926B008A; Sat, 31 Jan 2026 14:41:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BC336B008C; Sat, 31 Jan 2026 14:41:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370936B0092; Sat, 31 Jan 2026 14:41:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 17A006B008C
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:41:54 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0FB31B153D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:41:53 +0000 (UTC)
X-FDA: 84393279306.30.6A19597
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2A2D780006
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:41:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IcmDKHtK;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769888512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=212hM4rz02pSlHj7C46MSSXma4JsXBAvpVss4e1Othw=;
	b=Dhv4cdbYy0yKdAoG3D0Vzv8aVuvl9ygfTXjxUUTiaoTLVbysyPlqorV80BNY3MyB6Av75s
	83Ue/coqYt3v4gao2zv9Plob1d/VZRWsAtr3Q5LPVrIIoFzyJB/hv5yfh9XcD0L9g5K+Yk
	JgCQYggGVqrMx0awAfWTyDoueS8Zq0Y=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IcmDKHtK;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769888512; a=rsa-sha256;
	cv=none;
	b=avRJG5olF6tRF/K6QrblsP+FFyu66L8bMpnupN3cf2pLd5j+eIDXaPFEedt9Avo6TtlIL8
	NWkeaSTeOqH236wnU6wpGZgXzFjFxxKS9HMw3lh/2joswOWxw4CBxc0y2Ci9NcrOR46qmz
	m0a4BM8ABVKFiulqoYXaayoeLulDdOY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 33C7560200;
	Sat, 31 Jan 2026 19:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62C8C19425;
	Sat, 31 Jan 2026 19:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769888510;
	bh=Pe0qzMcuMwlXKVIKMPhsj3X5ayzudFrg7BH3yoaNzyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IcmDKHtK0qqXshgt7YIaKdfLJSGPcsq6RQRB8pNlmzynsOtG/463k4we4baYjGvXb
	 e4ZZu4v+fciSAhJGo3CJ/EMz7Hzc/THCpTeaZuprn9QqhSd0udTZromt3GLiBT+dzS
	 rPvPz1EGAvVS21gedkDBzQHR7z0ccDL3ktYiQuCtHe0lBhFF1LZS0tYtTIvGHQWieb
	 +mi/LpRFSZzf91mttdPuTDf9RTNNz0XjzZIODmdqXJPl0AzxKmkmegnGywfIb6q2dA
	 nK+MLR5UczCuTctfyTHP09EtolVrLV5X+X7xSP1FKNdjztOgG5bqTLh7IjhWMl9qt4
	 CU4ush5tR587A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/core: set quota-score histogram with core filters
Date: Sat, 31 Jan 2026 11:41:42 -0800
Message-ID: <20260131194145.66286-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260131194145.66286-1-sj@kernel.org>
References: <20260131194145.66286-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2A2D780006
X-Stat-Signature: 9jzzy1pco3wtc4eez8wtzoqb6so35cch
X-Rspam-User: 
X-HE-Tag: 1769888512-878523
X-HE-Meta: U2FsdGVkX1+Or9W+cdPUgIIjQ9hDTp7CqyaIKg42rEueOIdLTASjxKmQXI08MgOLjn3eAeApDQIf3fuyyRmDfr3xdjcNknry2QXOoiOg1B4fGNLdulgXiYs2RDemhGTeNiCyzJ2WDxd7UBOC+2XtUTopqTOK8nWYzElpEIWLbivGF8DK1SX7vt3V86K0ynw44uPvz1sT9oyMnx0XDOD6I83pMSEP9f4B7o9HNO88shtSEMfyKKDBsRFDVgJzgQQBCk46xHQcOfWpg401nwfdd2N2w796MmS0UZejFgIGhe7GLg12OxLIsYZNK3jbR1YjzK/wkeixzqzswpfP1g+br4TMQX/EQ2hbqfUpoqnei2rXHqaajyu/tyww9Apehqrw2qM1gTwI7Q72VY4Ak4DHZC28qxYIlvCozyrSYKa9z/Dt8ZRYb8+rqMOwMJuowN4Hwdgbx3YzWtzjBQb3uBvMOpeWlA1R7+0JfjP/Xgbasmj4oyePZ3D51tBOQCIXpIPPNm0suW6naQ+7Wa+/S1dSAweyEbJ53AkCkQvINjerXtOpsZoHcXMDB5PlTZz54f/y22+oECJPSGK1LcV3R0T6ufD6MlQqXAM6MQ1ONypVNQOq74z0o91qV0cnvElhk34Zw3tanTahn2fByGsJEh5+S2GCOg4A5f7d9eUoclhexi0VtVDLiaKbRIEJbdGzGSHTZotH8+5BrG9jGGvryTXm1uh1nQjXxC8LUqx0MzPMOkGPSe6C5lh85GsT46R9p4fW2QuHsD7ekpu1xGzWwNbtwSuR86F4rYYfC3ROzoVNtB14iFDmFzvBAsIvMINueDpNNNxH/XynqXwCJp2boxGHVlqeIGQxxod1Ko8X16vVmc0IZDbMCTMofKFqQ9DwcsnrxKP3Cyr/+JWDX4CBYdHMT275cjQBROE0IBDDkMvyl4nZRXNRMTfgoMa9eRAL0wkFa5Wra7fm58F9ZFXTU/S
 B5FtkkJc
 2iKkKfGF4kcv1i22L2/T25g5CnflA0X/RUDuIKGrARFinzOmlw4FKxDYDithmZjIXtz3xnr0Y0+IgNoPvkPRSXdu67VsLKsPfLpiIrT3kLKVIwcCTmRoWfdIRdecQ2Fehh/517VWrbCmCBUjf0P2+FGd4mdGVUX83xNUpqZ4/uYd6Zgk5gooELs1jMl+ae9y12e86WG1fqB7d8G4H3jWsJx6kq3FWUPezXEdF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The histogram for under-quota region prioritization [1] is made for all
regions that are eligible for the DAMOS target access pattern.  When
there are DAMOS filters, the prioritization-threshold access temperature
that generated from the histogram could be inaccurate.

For example, suppose there are three regions.  Each region is 1 GiB.
The access temperature of the regions are 100, 50, and 0.  And a DAMOS
scheme that targeting _any_ access temperature with quota 2 GiB is
being used.  The histogram will look like below:

    temperature	size of regions having >=temperature temperature
    0		3 GiB
    50		2 GiB
    100		1 GiB

Based on the histogram and the quota (2 GiB), DAMOS applies the action
to only the regions having >=50 temperature.  This is all good.

Let's suppose the region of temperature 50 is excluded by a DAMOS
filter.  Regardless of the filter, DAMOS will try to apply the action on
only regions having >=50 temperature.  Because the region of temperature
50 is filtered out, the action is applied to only the region of
temperature 100.  Worse yet, suppose the filter is excluding regions of
temperature 50 and 100.  Then no action is really applied to any region,
while the region of temperature 0 is there.

People used to work around this by utilizing multiple contexts, instead
of the core layer DAMOS filters.  For example, DAMON-based memory
tiering approaches including the quota auto-tuning based one [2] are
using a DAMON context per NUMA node.  If the above explained issue is
effectively alleviated, those can be configured again to run with single
context and DAMOS filters for applying the promotion and demotion to
only specific NUMA nodes.

Alleviate the problem by checking core DAMOS filters when generating the
histogram.  The reason to check only core filters is the overhead.
While core filters are usually for coarse-grained filtering (e.g.,
target/address filters for process, NUMA, zone level filtering),
operation layer filters are usually for fine-grained filtering (e.g.,
for anon page).  Doing this for operation layer filters would cause
significant overhead.  There is no known use case that is affected by
the operation layer filters-distorted histogram problem, though.  Do
this for only core filters for now.  We will revisit this for operation
layer filters in future.  We might be able to apply a sort of sampling
based operation layer filtering.

After this fix is applied, for the first case that there is a DAMOS
filter excluding the region of temperature 50, the histogram will be
like below:

    temperature	size of regions having >=temperature temperature
    0		2 GiB
    100		1 GiB

And DAMOS will set the temperature threshold as 0, allowing both regions
of temperatures 0 and 100 be applied.

For the second case that there is a DAMOS filter excluding the regions
of temperature 50 and 100, the histogram will be like below:

    temperature	size of regions having >=temperature temperature
    0		1 GiB

And DAMOS will set the temperature threshold as 0, allowing the region
of temperature 0 be applied.

[1] 'Prioritization' section of Documentation/mm/damon/design.rst
[2] commit 0e1c773b501f ("mm/damon/core: introduce damos quota goal
    metrics for memory node utilization")

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5e2724a4f285e..bda4218188314 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2309,6 +2309,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
+			if (damos_core_filter_out(c, t, r, s))
+				continue;
 			score = c->ops.get_scheme_score(c, t, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
-- 
2.47.3

