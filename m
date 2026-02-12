Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F89EE3695
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 15:42:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873D56B0089; Thu, 12 Feb 2026 10:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 821916B008A; Thu, 12 Feb 2026 10:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7028A6B008C; Thu, 12 Feb 2026 10:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5BDC36B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 10:42:02 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E8C97C09B3
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:42:01 +0000 (UTC)
X-FDA: 84436220442.14.B0EE7C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A06320014
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:41:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9OxGuWy;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770910920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QIJrTJxxiDxr6zNVWDHd2vL2tYL/qzJggdXLJ8XcVoQ=;
	b=pFV29IGEvGUmww3NV3LClG7dXSEkRsGKXAQYXAUjfsbCtlc8wJwlObV+L/UfAm3n8qZLO9
	lIK4KokP3wiPIkKpnh3vokQ3NqKXHZDBFMmhLFNPjSs5iejcI1XZYiuG3gfvx3zwZaMgJe
	PUMfKl0pW+vUTEMTaf5m/JUX6f7CUuc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T9OxGuWy;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770910920; a=rsa-sha256;
	cv=none;
	b=po2E+50rooUDfbggt5/y8RltMVh31OYJPSYyN164SiEBcRjkcu8P/YREhTSbnqlZWcNO3V
	tmLdyflxKF9Mh4YOIVdEVPNCTtVKnSDCRwgy1YfH8g8ZbeEM08L3V9oURLNoNdRFQhlhhY
	q4jJQjmntRjDmuY7Xem5zQwl4PGNGC0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D324443C6;
	Thu, 12 Feb 2026 15:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEA3EC4CEF7;
	Thu, 12 Feb 2026 15:41:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770910919;
	bh=lPmdnddKRkpLgqLzVEUhIh9YWowTDlxwVWyDcl8i5K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9OxGuWyesVcuJd2eMzY7c/ltmDEBn811L79sxhQmFlCdwbL3+bKNZ+lInI8hSory
	 9cbaE1rAIqlN7hfgiZMoiRcxUgZ6HlY+xZEVw1bHHLakl5Pz2+aJh7jCnK0Us524rB
	 PC9xbdevqUVriwNg4hYIBqbUxQmrnUGYQzvzDivViwceHFjVtHYiLKMFG6WdEC/ZDU
	 e3SFExn6Nph+DwDlLgcVqEZLXhS9kvbnbP+RHKGXFh9PF4lfbA+h2FnBc9V3Jn/Qj1
	 CBc8es2omLl0gezCP1yrnwUgWc4vyuJtfjTN8alDKsY8QGzpW6BEoM/Xl1iOPnE79V
	 X7i2qWzAilymA==
From: SeongJae Park <sj@kernel.org>
To: gutierrez.asier@huawei-partners.com
Cc: SeongJae Park <sj@kernel.org>,
	artem.kuzin@huawei.com,
	stepanov.anatoly@huawei.com,
	wangkefeng.wang@huawei.com,
	yanquanmin1@huawei.com,
	zuoze1@huawei.com,
	damon@lists.linux.dev,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon: remove unused code
Date: Thu, 12 Feb 2026 07:41:56 -0800
Message-ID: <20260212154157.75372-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260212094326.906497-1-gutierrez.asier@huawei-partners.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: to8h5bryg55tdtkaamfz7i55ggx8kxua
X-Rspamd-Queue-Id: 2A06320014
X-Rspam-User: 
X-HE-Tag: 1770910919-923546
X-HE-Meta: U2FsdGVkX18YtLczsmKj4jUT/FIJJQZro9q/jFU/dVobk4yf/2u15sJzWqx5obClSHxve5Nyg5BizR7JV4kNIF9TtgIRPHYLV1QfQWJzA7UcifOAd4rH/C/IW8JqalLm2B83ANsXw4zGUuwzOahRmZLL963vu6y+LhVulQUkgpYqoIP1AAC0OA8MbIXsMt0enOL5/CwIWz9esBHzdYgZ98ivktALKPuyclVAeMAsXzFfAmi/rxXKPk75Z/E517zLAEVg7DGCh9zIBFPMHgYHbNKKBC2+5dVWYBYAlZedWvNeBEJRcpy6hBKpsNR93YETSVFhXJGP8W6oFRcfPf1tD7le+xf5UD+bi6g3UrJua/ZrZRkYfZA4V9FDmqi21wZxM8syK6dUGPRYc7edLCklFemNEM5ampkwtIkIm+H8ZcDXjT+EelpxcARIgforGpLtWMHAgdGpgZwr2kCMjBvfcQ0ponvs4hqolJQk4AVF/okfrt6nU3gaMHnynf8Ay7ZtPk9fCnQIF319MRf+YpDC+B9Tt2/4LnGb+bpcf/WUVuMGddPydicBWsw2mDzvU/5yVWDB8bRpq3TamxgtM9jNSVFIcI1eMYu0AJFE9HmpB08ZOynvSMtavGsqV8oCJfkrHT6u9pmKApJzCImVPd7dAs6mhnD12SA51xoi7hoIrsvWNusj3noD7XG2de8TwdvyeDQTwye8Taab+BVXC32IKY9yY8sIgyveqDK6mCzi/mD5Rt5F+pr4F0XY488Glk2bi8snPoMBwGSWqviBzRv8q5nYkEa6lbYcu1gKsIPWts4WFsnDdKLGyMfwytFywQ6N/+ukiDyPtmWYpOSzzxf8ChP6wRoxfoYURrVAhdWLnf6TeeteK9lf1tdKNqK+K2L2dS5INX7Q5neAdg8pt12Pdn0wvDnYv62xhvH0Rt6rdAiM4OEXOZ2k4oZpM0HTcPHpkCveIUspmoeYL1jMn10
 Ad6KMCld
 +wcBVWWSNdnjLMpeK5xGObXEoTRj/472RLKXe5nvennBvSpkUQanBcwaDr5LOj0am1XXQh6F9qrPysfnPpiXuWmUyqrwg9lzaWU6SzA5D8BhxZ87WnjS76E4hdeIYkCji/SB/71tj7tjAaCEAaQ3oQd8ACsmhZPDnV1ZdT9eBfCHLSWy0sDODhmolYRjMDYsi88dNMFCx2y3afnUUfnQxGDKDBGqwylCrPiQM0PGvkBpVh9Kb3hkDxj74gmNBF15R1IdwRF9YuFjT+F9RISxLV4YlyWsOzoRetKFOnjG1jkqEdIdx7HNe41j5gpojIiOseN0mNSeSin7FwMrrA72GkzDKO+DsygR2+VewUF3LcI2UcQ+qx/70XNXLdn88ShgdEE2zBakwFyVmEY8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 12 Feb 2026 09:43:26 +0000 <gutierrez.asier@huawei-partners.com> wrote:

> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
> 
> damon_target is not used by get_scheme_score operations, nor with
> virtual neither with physical addresses.

Good finding, thank you for this patch, Asier!

The subject seems bit ambiguous, though.  What about "remove unused target
param of get_scheme_score()" ?

> 
> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Other than the subject,

Reviewed-by: SeongJae Park <sj@kernel.org>

Also, DAMON patches are recommended to use mm-new as thier baseline [1] unless
there are other reasons to not to do so.  But I found 'git am' of this patch on
the mm-new fails.  It works on the master of mm.git, which is a commit of
Linus' tree, though.  So, maybe this patch is not using mm-new as the baseline?
Please consider using mm-new as the baseline next time, or specify why you use
choose different tree as the baseline.

Assuming you are ok to the subject change (let me know if you are not), I'm
attaching a new version of this patch that has changed the subject with my
suggestion, and manually resolved the conflicts on mm-new, for Andrew's
convenience.  I also applied that to my tree (damon/next), and I will repost it
if Andrew miss this (as we are in the middle of merge window, maintainers could
miss many things).

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]
======= >8 =======
From e09d66bb116604c9dc5b22540641e991d977ea6b Mon Sep 17 00:00:00 2001
From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
Date: Thu, 12 Feb 2026 09:43:26 +0000
Subject: [PATCH] mm/damon/: remove unused target param of get_scheme_score()

damon_target is not used by get_scheme_score operations, nor with
virtual neither with physical addresses.

Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>

Link: https://patch.msgid.link/20260212094326.906497-1-gutierrez.asier@huawei-partners.com
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  3 +--
 mm/damon/core.c       | 10 +++++-----
 mm/damon/paddr.c      |  3 +--
 mm/damon/vaddr.c      |  3 +--
 4 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index a4fea23da8576..9a88cf8d152d8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -647,8 +647,7 @@ struct damon_operations {
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
-			struct damon_target *t, struct damon_region *r,
-			struct damos *scheme);
+			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme, unsigned long *sz_filter_passed);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5e2724a4f285e..925908415a041 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1679,15 +1679,15 @@ static bool __damos_valid_target(struct damon_region *r, struct damos *s)
 		r->age <= s->pattern.max_age_region;
 }
 
-static bool damos_valid_target(struct damon_ctx *c, struct damon_target *t,
-		struct damon_region *r, struct damos *s)
+static bool damos_valid_target(struct damon_ctx *c, struct damon_region *r,
+		struct damos *s)
 {
 	bool ret = __damos_valid_target(r, s);
 
 	if (!ret || !s->quota.esz || !c->ops.get_scheme_score)
 		return ret;
 
-	return c->ops.get_scheme_score(c, t, r, s) >= s->quota.min_score;
+	return c->ops.get_scheme_score(c, r, s) >= s->quota.min_score;
 }
 
 /*
@@ -2011,7 +2011,7 @@ static void damon_do_apply_schemes(struct damon_ctx *c,
 				s->max_nr_snapshots <= s->stat.nr_snapshots)
 			continue;
 
-		if (damos_valid_target(c, t, r, s))
+		if (damos_valid_target(c, r, s))
 			damos_apply_scheme(c, t, r, s);
 
 		if (damon_is_last_region(r, t))
@@ -2309,7 +2309,7 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 		damon_for_each_region(r, t) {
 			if (!__damos_valid_target(r, s))
 				continue;
-			score = c->ops.get_scheme_score(c, t, r, s);
+			score = c->ops.get_scheme_score(c, r, s);
 			c->regions_score_histogram[score] +=
 				damon_sz_region(r);
 			if (score > max_score)
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 9bfe488268407..5cdcc5037cbc1 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -343,8 +343,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 }
 
 static int damon_pa_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 83ab3d8c37920..4e3430d4191d1 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -986,8 +986,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 }
 
 static int damon_va_scheme_score(struct damon_ctx *context,
-		struct damon_target *t, struct damon_region *r,
-		struct damos *scheme)
+		struct damon_region *r, struct damos *scheme)
 {
 
 	switch (scheme->action) {
-- 
2.47.3


