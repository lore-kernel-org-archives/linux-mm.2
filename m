Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B841CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78A538E0013; Wed, 12 Nov 2025 10:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73A9C8E0002; Wed, 12 Nov 2025 10:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629BC8E0013; Wed, 12 Nov 2025 10:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0F28E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:10 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEE711A0573
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:09 +0000 (UTC)
X-FDA: 84102371178.21.149E57C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5D5384000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R37Sx87/";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qmd5pLCXiY5TZRrtHuIC7PxKw2zPFS7Xe/7+jvfACA8=;
	b=RizWTjLk7+TqjECMYVQWoH3witrluykyS1axtTNoyDHXKFH31JA6Pawlb3A6hhcPjWyyhp
	uwt3bLCBniJRcp/gdQTbmEi86WXcvSJo7zu81mkG/kdo/IdL0tLxhyuNfKBu6JmH3yYTXG
	TWsG8abgUjDSZy2h4PVnnlNCwnQL24A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962128; a=rsa-sha256;
	cv=none;
	b=oAdd06qiJGYjtf6oUm8RrK/mmnG6iatsgwUdnSzucq1wHXfeYCBh4FMtTU0jCXgl1xXb49
	rsxSmgsGKD9opifT7Ty2ep9G0HKt1Uv390rqwxddxXz7ZGv+gOATBeLS9cw+v8Jhc0qeoU
	pZFPMKgKEXewWAeqWQfCWNzc/MNMAHk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R37Sx87/";
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B5AC40C47;
	Wed, 12 Nov 2025 15:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B4EC19423;
	Wed, 12 Nov 2025 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962127;
	bh=NiZ7ea35pME1fM3maEI5aXEnDEDvdt1SSghBc/AiFyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R37Sx87/i8ZHQBhoTFE3dFsIlhXKSfafQa9RFcrnozAwKjGlQ6I43Gj+nu9r3YpI1
	 wZJuXfNsCUjC5eZyWKbnO5syAAPhPOKJabI09QgxpnHGorsMMlgnyOKVbdwhnUS63I
	 ONJdbjKKxW3SWgYr6p9SSeI/5zfJWBN355f90Acup8ovlYRmnS3yayYk1LT5pXP8Br
	 Ewgc0WKL3TTUXbHtqcJb+uioWEM+TVWg4aBVN9oCiR4ovVv3IWjz/JkFd/EUnK9hTp
	 P0UCtkGfo2OiALXDr5eMNuDw4caLVt5Mn+NZCCPvg8I5x+7XgkLkOQWt2Q8Nt25VSP
	 mc6lX1AxKFFuw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	llvm@lists.linux.dev
Subject: [PATCH 1/9] mm/damon: rename damos core filter helpers to have word core
Date: Wed, 12 Nov 2025 07:41:04 -0800
Message-ID: <20251112154114.66053-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D5384000A
X-Stat-Signature: pj6idyxscuq165neyy8t33dh7xyt8r37
X-Rspam-User: 
X-HE-Tag: 1762962128-609273
X-HE-Meta: U2FsdGVkX19Hk1fbsbHib0cxF+1AIunkhG+SHYULmYVXgoFpyzWhr4VlcM+LybLIff2UPv1YXi7kPKJxX8Df4FvhEIkQr82bbRks34Xyw4ufAl12nfH7Jyhqke9wQ4Ga3QnFpPN6A8OyR/yIfGqnld820OX8C0SUlK3UwFMzI24lEfzUuoLxCmtwP+meeZSMkkwkEUbNOhBzVtSFgml+R768ztCC9Gt7I4+RkV4l5U1Z9tXRE2SyvRPJM8CVFqS0oOOntvkDLfjHqq726CtFGL2i0I0TMaV7MYDUGN6x4goxra+YklYIJp9vy9Lf9xa6WQI+HWAHcA2w4cFs7YeFdRV8nX7rlgecBNGwqYXKcXS0dX9AV45FzKYzbq8E+C6uw+N3khfIz8A5ofTMuhNXeNU64OHyf7KOM5lU8tNQ/h2J26ICSzcdlrUG64n0UGHuX+cJALer7cSMXAJQfBR/d5jv0A/IozgdpnWV7pyhotqswRHmIna80vMUJihGZohjM/eHl116O7r26+LLvXtN85CDkdtU0IpP69dC/1NzWO27IOQdhGjjIgZBAc6L4lj8TOe4lUv7uui8U46tiQQHq0PCwFCGg+/k8RLNElzO+4+om+AK6xTD4pcH29k9H3GRwVGCrniTdXWYC+mo+W7qeXupEgfpH1a+/2rlhIh99uI2SG4QWy2K0hJHzBvbjdUH6SeKjOq46C97F1GymhjWaKKDKIsNr+Lfr5mznnUVP0glv3G6mGUTxgrtGLCkrmZxB4/Gi2LSgVi/nydOSn7IuKWBpJQKZL1TY3YvTHNhy5tcSb8loBTxQ346MqBvbsxp8uX4sAM1ZW4x/0EuvFVVO7b3lnzN0aGYgd8ubZ48yNe/BwY67jtm327UHYKQU/pfVUcOLqTTNaDvnyDwON6g+e1wwcbgnSmNk6WyCFzQIHdTWTqo4fTWA2zTuJAH1AwtqGL3NwkrUwJXiqHmIoB
 4Z7HyK5k
 1/vC4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS filters handled by the core layer are called core filters, while
those handled by the ops layer are called ops filters.  They share the
same type but are managed in different places since core filters are
evaluated before the ops filters.  They also have different helper
functions that depend on their managed places.

The helper functions for ops filters have '_ops_' keyword on their name,
so it is easy to know they are for ops filters.  Meanwhile, the helper
functions for core filters are not having the 'core' keyword on their
name.  This makes it easy to be mistakenly used for ops filters.
Actually there was such a bug.

To avoid future mistakes from similar confusions, rename DAMOS core
filters helper functions to have a keyword 'core' on their names.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .clang-format         |  4 ++--
 include/linux/damon.h |  4 ++--
 mm/damon/core.c       | 14 +++++++-------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/.clang-format b/.clang-format
index f371a13b4d19..748efbe791ad 100644
--- a/.clang-format
+++ b/.clang-format
@@ -140,8 +140,8 @@ ForEachMacros:
   - 'damon_for_each_scheme_safe'
   - 'damon_for_each_target'
   - 'damon_for_each_target_safe'
-  - 'damos_for_each_filter'
-  - 'damos_for_each_filter_safe'
+  - 'damos_for_each_core_filter'
+  - 'damos_for_each_core_filter_safe'
   - 'damos_for_each_ops_filter'
   - 'damos_for_each_ops_filter_safe'
   - 'damos_for_each_quota_goal'
diff --git a/include/linux/damon.h b/include/linux/damon.h
index f3566b978cdf..6e3db165fe60 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -871,10 +871,10 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 #define damos_for_each_quota_goal_safe(goal, next, quota) \
 	list_for_each_entry_safe(goal, next, &(quota)->goals, list)
 
-#define damos_for_each_filter(f, scheme) \
+#define damos_for_each_core_filter(f, scheme) \
 	list_for_each_entry(f, &(scheme)->filters, list)
 
-#define damos_for_each_filter_safe(f, next, scheme) \
+#define damos_for_each_core_filter_safe(f, next, scheme) \
 	list_for_each_entry_safe(f, next, &(scheme)->filters, list)
 
 #define damos_for_each_ops_filter(f, scheme) \
diff --git a/mm/damon/core.c b/mm/damon/core.c
index a14cc73c2cab..d4cb11ced13f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -450,7 +450,7 @@ void damon_destroy_scheme(struct damos *s)
 	damos_for_each_quota_goal_safe(g, g_next, &s->quota)
 		damos_destroy_quota_goal(g);
 
-	damos_for_each_filter_safe(f, next, s)
+	damos_for_each_core_filter_safe(f, next, s)
 		damos_destroy_filter(f);
 
 	damos_for_each_ops_filter_safe(f, next, s)
@@ -864,12 +864,12 @@ static int damos_commit_quota(struct damos_quota *dst, struct damos_quota *src)
 	return 0;
 }
 
-static struct damos_filter *damos_nth_filter(int n, struct damos *s)
+static struct damos_filter *damos_nth_core_filter(int n, struct damos *s)
 {
 	struct damos_filter *filter;
 	int i = 0;
 
-	damos_for_each_filter(filter, s) {
+	damos_for_each_core_filter(filter, s) {
 		if (i++ == n)
 			return filter;
 	}
@@ -923,15 +923,15 @@ static int damos_commit_core_filters(struct damos *dst, struct damos *src)
 	struct damos_filter *dst_filter, *next, *src_filter, *new_filter;
 	int i = 0, j = 0;
 
-	damos_for_each_filter_safe(dst_filter, next, dst) {
-		src_filter = damos_nth_filter(i++, src);
+	damos_for_each_core_filter_safe(dst_filter, next, dst) {
+		src_filter = damos_nth_core_filter(i++, src);
 		if (src_filter)
 			damos_commit_filter(dst_filter, src_filter);
 		else
 			damos_destroy_filter(dst_filter);
 	}
 
-	damos_for_each_filter_safe(src_filter, next, src) {
+	damos_for_each_core_filter_safe(src_filter, next, src) {
 		if (j++ < i)
 			continue;
 
@@ -1767,7 +1767,7 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 	struct damos_filter *filter;
 
 	s->core_filters_allowed = false;
-	damos_for_each_filter(filter, s) {
+	damos_for_each_core_filter(filter, s) {
 		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
-- 
2.47.3

