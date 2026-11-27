Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F4004606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:31:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7dnWdgd
Received: by kanga.kvack.org (Postfix)
	id C10626B05B0; Fri, 27 Nov 2026 15:31:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1256B05B1; Fri, 27 Nov 2026 15:31:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6116B05B2; Fri, 27 Nov 2026 15:31:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2503C6B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:31:28 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84E6A1A0493
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:31:27 +0000 (UTC)
X-FDA: 85482044214.15.D9618A2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E869A4000A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:31:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7dnWdgd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795811486;
	b=i7oTjyIecV0IKmeBC2CZzb8WNIrUqvZxOe4ezRI0HmZwpIGnZ8UWVU+ozqixCjWuPld1Ou
	7VRRhYu6KTThsTYvIBYR2F/ef7xxv8b0h2qzj7w0zARol4jBPJBN29sAzjJn5q/hbixDnI
	ktmpqYiX87BCGkrkUD5QF7yoaKjGVJE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795811486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VpkQKOzSD2hgUO4KXQobYy7a0rOKz3nk4brF7xC2xAQ=;
	b=smVl4lVazYEGP9cpXRDjyZ/dBr2/hiS2fQj3JxvultjFWQRadyOuK+emHE9rysOy9KUsw0
	5aLolAs1dpq+HcPJzSTxk8jzriv7JY64/tATcSIDmQSU3qJt7SmoUDuvXL5o1HmQAvtfRx
	4Vptsdo8wGFdQ9FgCXSMFa5Sf8fOxKw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7dnWdgd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A71B0408BF;
	Fri, 27 Nov 2026 20:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560001F0089A;
	Fri, 27 Nov 2026 20:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795811484;
	bh=VpkQKOzSD2hgUO4KXQobYy7a0rOKz3nk4brF7xC2xAQ=;
	h=From:To:Cc:Subject:Date;
	b=j7dnWdgd1Bl978lwebtZPQyWWpCjWe4dn2z5kOXLbAhoYwmWar4ixKKTe4jexlLAh
	 QyQyRF2UZZc92Ec9XmcuYf2aDQeZhDr5HuD7CewMKoqOKep4sRwhzmmHvMd0jcdiKv
	 JJPXAq+vqNcyB8Z2m7K98KF6swgJH3Fy+jK6eozFp9pWsaFmDWy7bWYWEPXwE7UrPN
	 sENk991PPEwDFDmRbbdRJOM1LzfJ+JSNDCYShqsbjJ8xbH1cXp8oxzezQ3k6f6nODJ
	 ZdYSVRcqw7eos0aZbERE8b5icph7/rEHXo/Md+QANDZv7br4Vb2DG9d0M9RzrdCmTq
	 YIeJ7EYdNUlaw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [PATCH mm-hotfixes-unstable] mm/damon/core: cleanup damos->walk_completed in damos_walk_cancel()
Date: Fri, 27 Nov 2026 12:31:15 -0800
Message-ID: <20261127203116.92895-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E869A4000A
X-Stat-Signature: cn47o9jzozm13fr8113sfs6qncffxah7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795811485-51336
X-HE-Meta: U2FsdGVkX1//PnXhtC3gnUsZsivCzfFDY2esa/igOxMRcgn6n+DwAXT1Yuh8+aJYbDrm14CTKnSncYudxzmnbcJFdTLdFOz/org9j02XdBib8L2AxeFWExw+9TCmoNem95ffcVthuNSjTBPUGX7pPiHeRY2TTfyFaax37C/+kBiKoH6SIsvNUiORXJvL2bJabof5dHrrvV/5lGgafOaDmLL48jZlApjwLM1ova+ZnXgjkXpB/BFjItkOhy3L/8Yf6exfTnZbpr5CT6YvT27i+BwL17DzdTT7ZP20WLhkf8Tw/fo8f7563Bskn9waf+Cn2aKo+dregAmfRKq53JFU9vTgXcfIzip8AEE6DG0bZeb/jtdyDAl+v0TuPKM/51Bq5Hi98ooml4NkUQ1QwuX1UdmuSgZp/IcxATVsu+/UmXhJ3HBingxNgqyqQE4HWQ/Lf7feUC3HgmIzO5eN591eiQBCQwXuHyyO/bekdgvTdg+3Q1mrpNDQ21ZVDR8ZSQYz0xlsKE07KhVWqnwN/MDWf9gUSnAeJbKQQWdENnKllq/skzQvEMMVkv/CVWBf2GzUrD9u+g4tmuJ8TlYokoB1owTemGoIh4r4c0J8d8V+WUcbaT4ZE1npX8ROfAbrvw/ul0iHVqlfsO0sMLkg2hv+Om3os6BsOaUIryod2UBgRmjadEChTOUNCrPMhRRl7Xp18UpaTtATqomtY6lLt2o5x6AH4EWRhOvBfamdxwfMi4Ha+nZyTwYtWTUKKkWGsKE47cN7S8CUyKEA8A7N+RKV27GYV4xdMdyuJ9g7Xrvfrd21qnSbAEQHhKGcFJTGamN2r2CjEE0sdBJXW4MGOX+1rsvyHZhzugi60z4NEa++WgASNacpW4UXYYw+0OzOGDqlchejgJ/hEdXsceaHY6WkXl9lAZHHyqFznp1qOim8U0HpZ5WDKZpgeTdnRk4JcL9j31hh7SEhOaXg4sbQbfc
 tnQBZA1R
 FDLfOGuE5aEv58kd4DMlCGeq3L11lJax4dhA0t0gdIdPONkRvQ3uLGCpdPGJXBt8H8MmFxkltw9jLSrUf+Ih4++Ql3K0VlgNiaGc/NevBuu8wBqP3MlihFggU3sNV/JrReErcaMbsRuNkJRPvhpOPreYzmUVsPHARVWB8WGMe4xPLF1W/nXfmOff2N7V0BnCptrahsilN5+kwNCPAU2EKisk+P88l2jc6xPY8W7D1kIm3cbq9u/mat0BBq3wPtpXJXGfd1IqQcCxkgbSWAb9LfOZFB/EstHM++QYdGx95ZrGAH/+2aG0VyQM+wPWCY9dOP/LGMKZYevWVb+SvwPhPb7Llsjq5kpYAbK695zkXFCy3ELAuugR+Mqcc2dSY6c/qORj0p0eaSrcc0v7R3tr2tNsZvsFOqMU77s3mLssp683zYqxdGuPYYGIQyf07e94M74FkQ/XVmLfcBZA47M5juyDQ4UG/EEWCFQyOH6q1Q7VY6dgEiuDTBR9s/m2H5cB2cCnjhC/VC8kOm/9D7wVNLqfPoc931nRCVVrcvnXVrBaA3W2JEt/Wn+A17g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMOS walk could be unexpectedly only partially performed.  It can
happen when there are multiple schemes and the walk is requested after
the previous walk is canceled.

The expectation of DAMOS walk for a setup that has multiple schemes is
that it will walk for one snapshot for all schemes.  To know if the walk
for the one snapshot of a given scheme is done, each damos struct has
the walk_completed field.  It is set when the walk for the given scheme
is completed.  The walk skips schemes having the field set.  It is reset
for all schemes when all the schemes get it set.

damos_walk_cancel() cancels all existing walks.  But it does not reset
the walk_completed field.  damos_walk_cancel() can be called at any
kdamond loop iteration.  For example, due to DAMON context pause or
DAMOS watermarks-caused deactivation.  It means that the function can be
called while only some of the schemes completed their walks.  And users
could request another walk after the canceled walk.  In the case,
because some of the schemes still have walk_completed fields set, the
walk for them is skipped.  As a result, DAMOS walk based user operations
such as update_schemes_tried_bytes kdamond command could show incomplete
output.

Fix by unsetting the fields of all schemes in damos_walk_cancel().

The user impact is not critical.  No crash or leak happens.  Only DAMOS
based monitoring results retrieval could work unexpectedly, under the
certain setup and the race.  Given the best effort nature of DAMON, such
occasional monitoring quality degradation would be not critical.

The issue has found from the Sashiko bug database.

Closes: https://sashiko.dev/#/bug/linux-228a4c52-0545-4c1f-90ce-41114d8272e9
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Cc: <stable@vger.kernel.org> # 6.14.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20261122224054.79767-1-sj@kernel.org
- Rebase to the latest mm-new.
- Drop RFC tag.

 mm/damon/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 0e6b361f97ea..a6aac382f296 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2702,6 +2702,7 @@ static void damos_walk_complete(struct damon_ctx *ctx, struct damos *s)
 static void damos_walk_cancel(struct damon_ctx *ctx)
 {
 	struct damos_walk_control *control;
+	struct damos *s;
 
 	mutex_lock(&ctx->walk_control_lock);
 	control = ctx->walk_control;
@@ -2709,6 +2710,9 @@ static void damos_walk_cancel(struct damon_ctx *ctx)
 
 	if (!control)
 		return;
+
+	damon_for_each_scheme(s, ctx)
+		s->walk_completed = false;
 	control->canceled = true;
 	complete(&control->completion);
 	mutex_lock(&ctx->walk_control_lock);

base-commit: daba53bdc1a54c453c2f4ced54a1cd52416c3f87
-- 
2.47.3

