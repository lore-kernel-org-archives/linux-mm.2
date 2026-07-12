Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 544A3C44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 16:54:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 282BA6B008C; Sun, 12 Jul 2026 12:54:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 233386B0092; Sun, 12 Jul 2026 12:54:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 149CE6B0093; Sun, 12 Jul 2026 12:54:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E56756B008C
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 12:54:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87BD7A0923
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:54:45 +0000 (UTC)
X-FDA: 84980723730.19.CE05D93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 16B80A0009
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 16:54:43 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YA5LLlgi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783875284;
	b=WR032efxU3E1Ut5ZNeV+KhEs3zLo77HbwuhC28+eWd0lr/hotCnkyBBD14Uz4StLgg0N+Y
	PY/RlXyLkES2Q5IJyVswVSYWVpGq5rX9tFL0SYnA21B6ifgXolKmROT+oFbwkK729DSD4r
	fa3k6xsYXrDZudMUr3ZaXuAGLQGF4mQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YA5LLlgi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783875284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8xnGzHVEhJzHmaj8zqg2Ec1CH067snxS1T5Ejp1k8Wo=;
	b=R/Ga4QDps286s0q/fK/laTYFQPPXB7jvN6a5LCcTSzPc1xYgxfyVdcT6ZmSJsRSu9Huror
	S/HiODgVKCJMJ3tvukwcDAtcmJYog0KVf3gCPDHtQ06rUxnbUrFlEhxtg/XxWNQIzRQm/P
	Ufq/Z8ZJPPhuXdLJD03Nz10eXapYQZU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 66E396004E;
	Sun, 12 Jul 2026 16:54:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8AB1F000E9;
	Sun, 12 Jul 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783875283;
	bh=8xnGzHVEhJzHmaj8zqg2Ec1CH067snxS1T5Ejp1k8Wo=;
	h=From:To:Cc:Subject:Date;
	b=YA5LLlgiAG2b39oDhfv1a+J8X+VkVbiTa/cHAGwNCuP2QLWhqnoop/z6ghtSG9Iug
	 p0tu/I0XAT1DnC8BV1uj0hNiQSTnsBqBrZaIR2cqNUlovy/+IiPEEa1866YGFLjTpo
	 51e8GWlPN5qoaKG4edMAxodxPgM6j7khzSwQpoHq80WbKxItFMVEpY3JA+bIFM2wJh
	 bKG0N9r8y7IeQNfwjHTDjZr1x9YsPxjJznBRzOPThBmUfHI4hroqMrIaZECwuMJLKr
	 em3Wd5vANQku8XZ2qCVcJp6OaXMD3qqxxRJoorDmHZGQ4zhEt4brhTSzbXC3uSrXyc
	 7etC0DI8d4l6Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: skip aging from repeated aggressive merging
Date: Sun, 12 Jul 2026 09:54:30 -0700
Message-ID: <20260712165432.87609-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 16B80A0009
X-Rspam-User: 
X-Stat-Signature: eh7mfakzbmaf45dwo698nfh1gc4xswz3
X-Rspamd-Server: rspam03
X-HE-Tag: 1783875283-879914
X-HE-Meta: U2FsdGVkX18OQFsPla80tQPRQPSRbx7DdSjuyOXdHKKdRAkN53RRz92XaIoWF3L2REC7L7cY66TmtcuxZWqqSwxblZ2H2FVLKQ6IXmbIiNTEm7gdVBJJ5H6erYfOcqD3Di8Dz6jfUssiemZ9O0KmJiaQ2xlBVTJvTT5V6E3nBzWMbDW7y0CaYBx+I/W1VcrwCkyvSDGHpqqEGGQyXftHAvsgUG/VdvBcwrrWaYuGD/sq5zUYWWPUgTuEukhz0zp3SkKWpMLczQMVTXETZBc9PjWIpnhcEffYMybPDhat/vbq1ZNFLw6hXvfYrgRIg6AZ30ngMZnoDU7iX4g/znWNhvWh6LCcb3eC8sGzIW6eIwK2oe9gHH+M942vDOanoP0hhu+Vv/lQDHXAQ0Uqt5DiT72NfhrOsdMmi6zMBG89yzHcn5GmfYZFGETtPMLF2sYi5H+tqH/vog4s/keCOWB8IkT6fS2/7YoW6jTtWc+xL48bpNhfAybHk/yRnzvYP0iSHjqvDXJOLDNxOUvNR7GqvOcahhKXB0x/+eKJHjhOtRgEbV2VUr4bpRTHkIf+fzqPI2q8sRPhYYkGYU/+gZv/0HKhz2UtTKTZyNT2i/sN7iE/JAtSCskTmU9y+wVjP0/CB4nGwWgfbYIKry/XfUASGK1sfWLsOj6nggfowbcDZHF/hWbLL2xFNHo6wRxIva8R9zDOmJgA8LHJk9qdf5zKyOLo35lXD0I5wZi7FMELFxsT6diZTPUTb73U8BPLh0YsQC8faJtpE3Hl4YlxuVtdmajiEDC7W3iyLLMw07mt6rQ7yn5aj45cx8aX/FBs6SykYMAbsbR4i4fgjEfc+fdjsRWAtbTzcrn5LL4B7e04EWSlF6pNXgfQpLpSxLEXafRgd2xKnIJjNC5YYVwlmJdM3YMED+JZLeWVEezmApK6JJaMiH/UauoSUT1gzRFzXcqU/Fn5CeRsF0Ddhz/X/Mi
 0LBUKTOG
 AMzY/PaYQmNtea79wg5fxu5y5rM07KQxPoCxCEUNd9wUAwbCc/2TvQ9F0emSpsRgnfOUYpuPB69MopbEKuPSJumC+0cJ5r2DTXUxYc8tTqu+T7usLdKuLKCwrEG6sfqDY3RjVbbyXRr4HagxTfzyXxjWDYmEIxZvlHYcaG5HsCjM/WP1XdUuo1Vn+5EbscL4hcOkusnjikE/0iPowBs/FNMtNW5vFm8dgs7yA0yC/r+nwGGk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The number of DAMON regions could temporarily exceed the user-defined
maximum number of regions limit for corner cases.  For example, users
could lower the limit via runtime parameters update.  For such a case,
kdamond_merge_regions() repeats merging regions in the case doubling the
merge threshold.  The repeated merge operation could update the age of
regions multiple times.  This corrupts the monitoring results.  Fix the
issue by asking the merge operation to skip aging for the corner case.

The user impact is degradation of the monitoring quality.  The impact
should be mild, since the degradation is only temporal, and it is not
common to happen in realistic setups.

The issue was discovered [1,2] by Sashiko.

[1] https://lore.kernel.org/20260621203548.10718-1-sj@kernel.org
[2] https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org

Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Cc: <stable@vger.kernel.org> # 6.10
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC
- RFC: https://lore.kernel.org/20260711171537.75278-1-sj@kernel.org
- Drop RFC tag.

 mm/damon/core.c             | 21 +++++++++++++--------
 mm/damon/tests/core-kunit.h |  2 +-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 806a67d02a6e9..6c4215cc809ec 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3308,7 +3308,7 @@ static unsigned int damon_merge_score(struct damon_region *r, bool last,
  * sz_limit	size upper limit of each region
  */
 static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
-		unsigned long sz_limit, struct damon_ctx *ctx)
+		unsigned long sz_limit, struct damon_ctx *ctx, bool count_age)
 {
 	struct damon_region *r, *prev = NULL, *next;
 	bool use_probe_hits = damon_has_probe_weights(ctx);
@@ -3319,12 +3319,14 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
 		score = damon_merge_score(r, false, ctx, use_probe_hits);
 		last_score = damon_merge_score(r, true, ctx, use_probe_hits);
 
-		if (abs_diff(score, last_score) > thres)
-			r->age = 0;
-		else if ((score == 0) != (last_score == 0))
-			r->age = 0;
-		else
-			r->age++;
+		if (count_age) {
+			if (abs_diff(score, last_score) > thres)
+				r->age = 0;
+			else if ((score == 0) != (last_score == 0))
+				r->age = 0;
+			else
+				r->age++;
+		}
 
 		if (!prev)
 			goto set_prev_continue;
@@ -3366,15 +3368,18 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	struct damon_target *t;
 	unsigned int nr_regions;
 	unsigned int max_thres;
+	bool count_age = true;
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
 	do {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-			damon_merge_regions_of(t, threshold, sz_limit, c);
+			damon_merge_regions_of(t, threshold, sz_limit, c,
+					count_age);
 			nr_regions += damon_nr_regions(t);
 		}
+		count_age = false;
 		threshold = max(1, threshold * 2);
 	} while (nr_regions > c->attrs.max_nr_regions &&
 			threshold / 2 < max_thres);
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 6ad73559dd8ea..68d30648c612e 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -257,7 +257,7 @@ static void damon_test_merge_regions_of(struct kunit *test)
 		damon_add_region(r, t);
 	}
 
-	damon_merge_regions_of(t, 9, 9999, ctx);
+	damon_merge_regions_of(t, 9, 9999, ctx, true);
 	/* 0-112, 114-130, 130-156, 156-170, 170-230, 230-10170 */
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 6u);
 	for (i = 0; i < 6; i++) {

base-commit: 96e4e82548418bcd5b3518d3b4efed1f5631772e
-- 
2.47.3

