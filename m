Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FA06C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34FE6B00B5; Fri,  3 Jul 2026 12:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADDF36B00B6; Fri,  3 Jul 2026 12:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F64D6B00B7; Fri,  3 Jul 2026 12:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E4BC6B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:56:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED6061C7230
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:56:21 +0000 (UTC)
X-FDA: 84948068562.27.0CB275C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 65B8580005
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:56:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvhY5qHn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783097780;
	b=JWrorELvRaGiFL/2YB/gvvTYI1lqb03zjn7cgC6lo0KXVchH422FKKv29/WDLFSPJpWGoQ
	3xJdd5rLau532RrgtB2QruH9eTghmUwCR2KwT8HF7+fKoHIHhJg2E27bQBBzqtzGdzo6WO
	hVkzSWJm0PjZbRT/GN+RfGjd4KzsjS4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783097780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=d8Fu0LoPjMdgfenH4nsnTkiBTDtpH+E6tfmdEIE/iDI=;
	b=SD5AAuv96+kH9KD1Jujp248fhGja92YhCpQMDuXT4xeUatLaJ89JqGrzXUMj5sYnu9Q/o7
	4EPvm+4fhLlTIAyCcKpp72JIhcr8iJ2P2sMGZs2UUgX/3Zm39bcYuKALXInzSc+Ig8INVg
	Bk+Ni7hhophYvYYM6Pbk85zcqWwBzdA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DvhY5qHn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E5F641AB7;
	Fri,  3 Jul 2026 16:56:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D1131F000E9;
	Fri,  3 Jul 2026 16:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783097779;
	bh=d8Fu0LoPjMdgfenH4nsnTkiBTDtpH+E6tfmdEIE/iDI=;
	h=From:To:Cc:Subject:Date;
	b=DvhY5qHnFGn2Dni7hV6Z6DToBHEQ4RtbpWP13BQ1U+IJOykwuBw7AdajTzI0l+UUb
	 oVykTxPjHdTjMwgax1sNUoGgNU47w4Id/dTWMFaQLl40+naxIuBxrsvvREKiUPBJY+
	 y9UX3d4y7WM7QYahilmTc/nLZAau3lOqEyTzVmhP+sWwREnY9ad5rTyshJT3rPhWOx
	 w9SnrBeq+mYy0TOYv34Jmz44cKLP3FAf/xwZMO4enfLgnKZ4zHRwr52FHse2tBZ1K+
	 SxakAADI6IWOAmRD6SSNXdUIHsmXLJe3Ax0VW5OKmibwPmZQ9m3R3zeNP+/pZpI9Ip
	 3U7kn2biOOcqg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 19 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: disallow overlapping input ranges for damon_set_regions()
Date: Fri,  3 Jul 2026 09:56:08 -0700
Message-ID: <20260703165610.92894-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65B8580005
X-Stat-Signature: dfkae4u5z59jyst5q4yxocfwpeo8m8jz
X-Rspam-User: 
X-HE-Tag: 1783097780-993377
X-HE-Meta: U2FsdGVkX1+bs+65pb8NxzTxqTI+HgqFeduP1/ilprWveI5q6Mt3WyqrvqMn+so9F8AKPw0AtK5UGOEzwPk/xEmG/EOy0Gz2lrhzUC4SX9t70ZtxX5C9cy9DG+R8Q+1XYZ6olZ1phuoRgqJCoahFoyDZIG6Hl0EAcWinkW+JNC+fINxH/xLsN3xM3Zv1PY6HpjVNjuF3utYcbuY3+lr0glRUUokSNiA7JcnPL+SknGrzYOm8yEIMWV0L7NNiYYO+wT/QBFguV3yyqHZsfO91EICrf/O3GBN3hmESKVwG4uJHfZESVdpHgfZVj4r07Sb10yEly3P98D/PukiyYVNzBcolZQ5WM2P/ViMCJd06zxkA1VlBWVCUFcBDyMdF+C6BevcAoQG9/z8moeFCHRU45q+EHgQ7fjC6D+nej0ZcUW9LjyVLZ1OL0o4usCitc+0+3YXa80lyvx/fD5VQmPoMGJ+e2zw4lpfUgapwqd/UithC3PRyNJxAywgjkbFRxI05IIhlUaLZerPIb3NMVdwmKHSQ6uOl+EXlGwR1AelTr4nQ2r+ME92Iq/qp41pQWqeTsEw4zSLZ18M1HHu9RXdVGN1ej8nZZQoOYH4ODlcwlr0g1AMenou8C1KZtJGU96ths0p2EfxIEQq8BFdxQMD8Qw/oEya/82gB8mMFlALtVdcVkgvO7sW8njMFnkxsw2F41hUHuGyGCeHY37NxwaLNhVkNCo2uengYPo4kHaG1D4EK7b1IFXzJWpJcqqFFakp1e/jMK/F1C1sQHvnY04gGOWFI2pK8J/lEDbrV/qQVY2TyHSD0M30ly17+7S2cWa1IMTYlstiGG6Hf/pv4MIlBA5IsY08ZR1ltPpOslWPqtcNJx6eURBbF9VFm3i7aQwUgLPV7AxkwCKrr66h/T1Y1X7WmLRahMBIbq2jyoyTxa/EEVptUFQkp/vW0yo86nrqiTv1NckZNR3MfrAvdjuA
 1JtVHCgl
 j+XA0/RHsmy5O8CqUThRbFrSW3a/8O8g5IU60f+4h6sNnUi2AK4BqsmGRydGNrJFvvzXQFO/Vauq6WZSYCKYMkCgsSmA43HLVFhG7BQJlVicGR2uB1UnGi0MjeQTtO1WjfpAPFaQlI/UX8ums/zGSB9e4pNt2sXM968ibh32OLhxu8XHaPpfxhClzo+R749rkeq4mATCKqI4ggQCDONe2OnpDsRGcnoi6aAXQ824rio8v7OSjoZ6qITqRXxNJmPDdgRALtFwoRX8WsNwEMDM81ZeBfYrWO43KGDTuVadChdtxwRLlvOfuCDIbE25vvtD2S3w0QnAnkj/JBoty5sHr2kV+6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() assumes the input ranges are sorted by the address
and don't overlap each other.  Hence the assumption was initially to be
explicitly validated.  But commit 97d482f4592f ("mm/damon/sysfs: reuse
damon_set_regions() for regions setting") has mistakenly removed the
validation.

This can make DAMON behave in unexpected ways.  At the best, the
monitoring results snapshot will just look weird since there will be
overlapping regions.  DAMOS will also work weirdly, applying the same
action multiple times for overlapping regions, and make DAMOS quota
weird. More seriously, depending on the setup and regions updates
sequence, negative size regions can be made.  It will trigger
WARN_ONCE() if the kernel is built with CONFIG_DAMON_DEBUG_SANITY=y.
Depending on the monitoring results, the negative size region can
further trigger division by zero in damon_merge_two_regions().

Note that some of the consequences including the WARN_ONCE() and the
divide by zero depend on commits that were introduced after the root
cause commit 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions()
for regions setting").

Fix the problems by checking the assumption and returning an error if
the input ranges don't meet the assumption.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260630041806.151124-1-sj@kernel.org

Fixes: 97d482f4592f ("mm/damon/sysfs: reuse damon_set_regions() for regions setting")
Cc: <stable@vger.kernel.org> # 5.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v1.1
- RFC v1.1: https://lore.kernel.org/20260702170326.87255-1-sj@kernel.org
- Drop RFC tag.
- rebase to latest mm-new.
Changes from RFC v1
- RFC v1: https://lore.keernel.org/20260701034921.99179-1-sj@kernel.org
- Move consequences divergence note to body of the commit message.
- Rebase to the latest mm-new.

 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index c6fc35be633b3..b2fc15a3804ff 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -418,12 +418,19 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 {
 	struct damon_region *r, *next;
 	unsigned int i;
+	unsigned long last_end;
 	int err;
 
 	for (i = 0; i < nr_ranges; i++) {
-		if (ALIGN_DOWN(ranges[i].start, min_region_sz) >=
-				ALIGN(ranges[i].end, min_region_sz))
+		unsigned long start, end;
+
+		start = ALIGN_DOWN(ranges[i].start, min_region_sz);
+		end = ALIGN(ranges[i].end, min_region_sz);
+		if (start >= end)
+			return -EINVAL;
+		if (i > 0 && last_end > start)
 			return -EINVAL;
+		last_end = end;
 	}
 
 	/* Remove regions which are not in the new ranges */

base-commit: af0487ccfb044dd7d9418c06c6718af630e16311
-- 
2.47.3

