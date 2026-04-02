Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BA2D6AAE7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 15:57:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3950C6B008C; Thu,  2 Apr 2026 11:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36D7F6B0092; Thu,  2 Apr 2026 11:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAB36B0093; Thu,  2 Apr 2026 11:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 160636B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 11:57:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BCCB65AECE
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:48 +0000 (UTC)
X-FDA: 84614071416.15.C063174
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id EE95480011
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aC2bcxa5;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775145466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juEemSrozHlgPKsuE+Oaww+nHeEra2t4pR68tFDv/GE=;
	b=CW8+2+6jS9CrkVv4uliBLT23LZLOIIx/Fl0LEa6qqDGB1yu63XoCX0GS3radREle8uU0Ya
	Sd0AeaPxTXeaKC6FasrYBR9OBGR00DtoyQd2qmezygKy3z9nt/8L0r+QUHNQ4KSuL51ZtG
	7zEIdIBV7Wnc57I1O14/jOUQTuLygXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775145466; a=rsa-sha256;
	cv=none;
	b=Ja82F0QQFdS52JTzS6YrxusTobRg8jk40fseU3P+Aro8H33hTDiLBVXg5d0SepXrttZNSM
	l04+ucU+tj6VySJ+G5gRZlx9EAHO5W+aYGPYHoG0mMWGhjAqHL3/GbiToo6pnDQWa4ksZu
	n9FB2DZ/lC+SSnxb9Iea+Lt6j2q7RQM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aC2bcxa5;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 66BAA6013F;
	Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 170F9C19424;
	Thu,  2 Apr 2026 15:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775145466;
	bh=Q3isgEbinPNEQMQQYyM5HlICe6RXhN4FkLMXIpHyJiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC2bcxa5QiwLtC2G74omcGwVCNKpRnr1wSBOZh+XXEYCii/OaHhldSCH2PGINeL3/
	 o5h8jOcdc1PfTqFzUFSFx3QoMvVPiEIN+p0/QsWA2l0XfwlO/jEK5uwrXgr3XlMBln
	 dXClDBM7KYuBtPoGCEv0q7tEu+lN9PZEDqFJPxWOXErS8sDhOn9bgKK+B6rFtjkC92
	 /v2U+JHI+iJpgBWtF299ZFhca/GL3IuYalnnmQxKU97+MzWXY3iSVPvc+8XkT8PDYS
	 agzOWHDlriZ6w2d9GpKnUWG6rhwq6lf0ZDvBVXIJMXRi3tSm+r9hvmCYi6flRZGHQg
	 XxIWSOdO1pcQA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon: add synchronous commit for commit_inputs
Date: Thu,  2 Apr 2026 08:57:30 -0700
Message-ID: <20260402155733.77050-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402155733.77050-1-sj@kernel.org>
References: <20260402155733.77050-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: 6xefim54e7j15e175btsmwkociwjro4b
X-Rspamd-Queue-Id: EE95480011
X-Rspam-User: 
X-HE-Tag: 1775145466-173135
X-HE-Meta: U2FsdGVkX19GCiqPmvZ+l3oYzLeEZbZHau7qQ6f3ND9vuh6cLXUEM3wXg/r8nkjpzGDY74iO7J+MyAnO/qKaYXwWwMxuq6epopc50CAT4llulQmxB06ecPFq3hEx80Su3gKoqo0NxPWzs92puJ2NUL3Ng6EIMiwBv8q9EJorpI2nWA32aDnp9uvzPZwRP2svxB+ZaQ2GRd7MXkqNYlCAPmi1EFKBkwh7ETqBuUU8kHFWTrm5MmQJKnb3Ov2f516nyKC3l+Y12CI8ijkFVWgs//xR1MhW5sya2MpHmgkLDB9FCQpQngwzpsJgTTjwXMq2N0nZ4r4nY+8bmA4zhDIxAO1afqdcAp7RcesOaBYjfoo5m9rDTY93wkHY5iQ4cxlCwFtibfprF8GnMeS/58ExFKoVB/rbarUjCW7UlBfGW18LdG5cHLnR0gXjpRorh+226iwDk+ChKlOFPYEv5SMGMzW9xBpMOkfxFD/s3sJs2qMgsGngl0SEsbyJ3Uvyd7nMBdm65rH5izm5zbMDahe9lXAZU1iZIAIbCO/aATAWOfOBi6jRXtHtE1ezo2+HmIJVm85R8KDeIbKfvvu0SymYSSTqsYKPVGRwCw/3J+/JNxQfo2w6gMdexixopJlSibgMamKrSEQgUPr6ZxA1jMdlBJ34dbwgcJq3N0TJTyLyoXCrhTvYA8stfvxPkqbuYjfZT/Yl8nWK9cxcJPv3tOkHIosCdtNDuLDnq9rFAy5wuGDfe2139hwXVRovK7YMWKMDSeI9uA6omiIb8T23Wg1iM9iFs+NbhtwzmbS8YnT2Chz6zc0Cy6sOTtA0BDljAeiSRhzQDU7uH3O+I4gbFvfOgX/VSmRqdwKvRGyYl4iH7JJqvvA5GbPHnHzQOiAhldt1UlAdvGD1CPMPDFeTTufJ0amDKaRVgtmIyNwVQ09z7MN5pY2aqKHIV84cQS2ZEK/8tayvU3i0lltrjElmPD2
 5j9MC2h/
 Txl0jihMIlgmLK65hjQbiibn4uND6SZ/tLVDVWDi+zGwYpCdUq0UfuSgdZDk7qjqMbm70n/SHmEyAgxSJgqAOfxdpoYVjC/+H3RLTYaOLcoC5FFGw9Z8W+kiAKujffTZi2urDaRDuW0/n6sLFGg+F/q2y3ibyVDF/R/IZB99u06UfdYQwOPn/XimtWy7RuFhNRkK/w9QVcKGpxzB0lLyzBXFMrdHPhNsM/k+FOcdXgmdvjNUs0xR9GVS3O2tNpBye9+C7YJdcOQ7XW1OQCRelGosV4jeIPw5Tlp3c73qjDY3tCMY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Liew Rui Yan <aethernet65535@gmail.com>

Problem
=======
Writing invalid parameters to sysfs followed by 'commit_inputs=Y' fails
silently (no error returned to shell), because the validation happens
asynchronously in the kdamond.

Solution
========
To fix this, the commit_inputs_store() callback now uses damon_call() to
synchronously commit parameters in the kdamond thread's safe context.
This ensures that validation errors are returned immediately to
userspace, following the pattern used by DAMON_SYSFS.

Changes
=======
1. Added commit_inputs_store() and commit_inputs_fn() to commit
   synchronously.
2. Removed handle_commit_inputs().

This change is motivated from another discussion [1].

[1] https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com

Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
Changes from v2
(https://lore.kernelorg/20260329075415.36775-1-aethernet65535@gmail.com)
- Rebase to latest mm-new.
Changes from v1:
- Restore the KERNEL_PARAM_OPS_FL_NOARG flag to keep the compatibility.
- Link to V1: https://lore.kernel.org/20260328084524.5451-1-aethernet65535@gmail.com
Changes from RFC-v6
- Removed unnecessary assignment (repeat) in commit_inputs_store().
- Change the return value; if an error occurs, return the error code.
- Removed the RFC tag.
- Link to RFC-v6: https://lore.kernel.org/20260327062558.66392-1-aethernet65535@gmail.com
Changes from RFC-v5:
- Removed unnecessary assignment (data) in commit_inputs_store().
- Return -EINVAL instead of -EBUSY when 'commit_inputs' is triggered
  while kdamond is not running.
- Link to RFC-v5: https://lore.kernel.org/20260325013939.18167-1-aethernet65535@gmail.com
Changes from RFC-v4:
- Rename the 'yes' variable in commit_inputs_store() to the more
  understandable 'commit_inputs_request'.
- Return -EBUSY instead of -EINVAL when 'commit_inputs' is triggered
  while kdamond is not running.
- Link to RFC-v4: https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com
Changes from RFC-v3:
- Added checks for 'ctx' and 'damon_is_running()' to prevent NULL
  pointer dereference during early boot. (Found by Sashiko.dev)
- Removed handle_commit_inputs() and its associated polling logic as
  they have become dead code after moving to the synchronous damon_call()
  approach.
- Ensure the 'commit_inputs' is properly updated.
Link to RFC-v3: https://lore.kernel.org/20260322231522.32700-1-aethernet65535@gmail.com
Changes from RFC-v2:
- Removed damon_validate_attrs(), now using damon_commit_ctx() for
  synchronous validation in the kdamond context.
- Following DAMON_SYSFS pattern for synchronous commit via damon_call().
- Link to RFC-v2: https://lore.kernel.org/20260321140926.22163-1-aethernet65535@gmail.com
Changes from RFC-v1:
- Remove question from commit message area.
- Added synchronous validation for DAMON_RECLAIM.
- Rename damon_valid_attrs() -> damon_validate_attrs().
- Exported a new function damon_validate_attrs() and declared it in
  damon.h.
- Link to RFC-v1: https://lore.kernel.org/20260321002642.22712-1-aethernet65535@gmail.com

 mm/damon/lru_sort.c | 46 ++++++++++++++++++++++++++++++++++++++-------
 mm/damon/reclaim.c  | 46 ++++++++++++++++++++++++++++++++++++++-------
 2 files changed, 78 insertions(+), 14 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 554559d72976..641af42cc2d1 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * the re-reading, DAMON_LRU_SORT will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Desired active to [in]active memory ratio in bp (1/10,000).
@@ -349,18 +348,51 @@ static int damon_lru_sort_apply_parameters(void)
 	return err;
 }
 
-static int damon_lru_sort_handle_commit_inputs(void)
+static int damon_lru_sort_commit_inputs_fn(void *arg)
 {
+	return damon_lru_sort_apply_parameters();
+}
+
+static int damon_lru_sort_commit_inputs_store(const char *val,
+					      const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_lru_sort_commit_inputs_fn,
+	};
+
+	if (!val) {
+		commit_inputs_request = true;
+	} else {
+		err = kstrtobool(val, &commit_inputs_request);
+		if (err)
+			return err;
+	}
 
-	if (!commit_inputs)
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_lru_sort_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() if ctx is not initialized to avoid
+	 * NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return err ? err : control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = damon_lru_sort_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_lru_sort_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -374,7 +406,7 @@ static int damon_lru_sort_damon_call_fn(void *arg)
 			damon_lru_sort_cold_stat = s->stat;
 	}
 
-	return damon_lru_sort_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 86da14778658..4fc4a54b5e54 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -39,7 +39,6 @@ static bool enabled __read_mostly;
  * re-reading, DAMON_RECLAIM will be disabled.
  */
 static bool commit_inputs __read_mostly;
-module_param(commit_inputs, bool, 0600);
 
 /*
  * Time threshold for cold memory regions identification in microseconds.
@@ -255,18 +254,51 @@ static int damon_reclaim_apply_parameters(void)
 	return err;
 }
 
-static int damon_reclaim_handle_commit_inputs(void)
+static int damon_reclaim_commit_inputs_fn(void *arg)
 {
+	return damon_reclaim_apply_parameters();
+}
+
+static int damon_reclaim_commit_inputs_store(const char *val,
+					     const struct kernel_param *kp)
+{
+	bool commit_inputs_request;
 	int err;
+	struct damon_call_control control = {
+		.fn = damon_reclaim_commit_inputs_fn,
+	};
 
-	if (!commit_inputs)
+	if (!val) {
+		commit_inputs_request = true;
+	} else {
+		err = kstrtobool(val, &commit_inputs_request);
+		if (err)
+			return err;
+	}
+
+	if (!commit_inputs_request)
 		return 0;
 
-	err = damon_reclaim_apply_parameters();
-	commit_inputs = false;
-	return err;
+	/*
+	 * Skip damon_call() if ctx is not initialized to avoid
+	 * NULL pointer dereference.
+	 */
+	if (!ctx)
+		return -EINVAL;
+
+	err = damon_call(ctx, &control);
+
+	return err ? err : control.return_code;
 }
 
+static const struct kernel_param_ops commit_inputs_param_ops = {
+	.flags = KERNEL_PARAM_OPS_FL_NOARG,
+	.set = damon_reclaim_commit_inputs_store,
+	.get = param_get_bool,
+};
+
+module_param_cb(commit_inputs, &commit_inputs_param_ops, &commit_inputs, 0600);
+
 static int damon_reclaim_damon_call_fn(void *arg)
 {
 	struct damon_ctx *c = arg;
@@ -276,7 +308,7 @@ static int damon_reclaim_damon_call_fn(void *arg)
 	damon_for_each_scheme(s, c)
 		damon_reclaim_stat = s->stat;
 
-	return damon_reclaim_handle_commit_inputs();
+	return 0;
 }
 
 static struct damon_call_control call_control = {
-- 
2.47.3

