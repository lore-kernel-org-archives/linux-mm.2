Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD982C88E63
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 17:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65B486B00A9; Sun, 13 Sep 2026 13:17:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6338B6B00AA; Sun, 13 Sep 2026 13:17:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 571756B00AB; Sun, 13 Sep 2026 13:17:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2CB2D6B00A9
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 13:17:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7C5651C2D7C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:18 +0000 (UTC)
X-FDA: 85209394956.28.13E087E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D8E3140003
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQjBiGLP;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789319836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Af0P/XKXdgAAzkHEeahdC79McKW/w8Lwx3TN8N0HP1Q=;
	b=osOdCJnyACHeB/h/zCzbEfiocv8Lz4ehkKdUt3GUTIsYUJGoS4CI6Yz6b61/eAxRNbFyEc
	bJZm0Ohd9FdhS2ehNHX4rwsLVBySmQ4AV6Pht1WjdME2m2IzF1S7aQtbSZiH/4Gp3ICS2c
	UyMSBi7GqDjgYxSMwAAhvYyTb25m1hM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789319836;
	b=EP82WoneNhGamp3Culjf+Qy1pMBWQnMIefDR+WwSKCeD1J/W4V35XI3h8en2bDyHHjOUw6
	+X/ICB6/EjWObgheDrnAiAA/W+fIHqOzO4l81OEWcyQVG0fsJdHg4lVdioz3RpcXPGe8qx
	jCGKt/B2yh5IWMnKHWACqDOjJjlgi00=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jQjBiGLP;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2C41E437E8;
	Sun, 13 Sep 2026 17:17:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFFB1F0089B;
	Sun, 13 Sep 2026 17:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789319836;
	bh=Af0P/XKXdgAAzkHEeahdC79McKW/w8Lwx3TN8N0HP1Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQjBiGLPWEvT7nWrogYH8mpKAIP66m2WtYqxhrebNUTe7XEeut+RvP0LoZp5EFyZ+
	 ZZhH+ilUbK3eVLqxzuUX6tidBcAbd/GhIY+1dUGldEVL3suAkq/yQg7EMJRHvye7y+
	 3wy68lbNFrITT5HzMPwjJeuSd0TCy5Xs8ob/LQ91PeSSM+y4kb0O6NP8yN1KycTAnk
	 nN2lKSF6pyntZEHu/OhG/vKSILHt42lCxIdQxryBStGzWE8+na+afloRquZIUi7pRt
	 fQlvkS0nia4PflJPcUfOag6Qs7PfDoWPZOt776ioSL2vbO/9XAwn+lRDOnwVa2Lddq
	 NrdcaFohSG4DQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 4/8] mm/damon/core: disallow max < min damos filter range arguments commit
Date: Sun, 13 Sep 2026 10:17:01 -0700
Message-ID: <20260913171706.103052-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260913171706.103052-1-sj@kernel.org>
References: <20260913171706.103052-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f5up44mqsgz9fb6yda95juy8f5484gcs
X-Rspam-User: 
X-Rspamd-Queue-Id: D8E3140003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789319836-398036
X-HE-Meta: U2FsdGVkX1/M7YlzywJO11JVMNA3Wi0e6fMgRi1jus2jmgBFaAnwWL1rJwRMOpbENwqdcsf/05l+7//cF7i3+ODmnzv1L32PWKhgpi+dtUQxZJ6EWx1Tej/X8RnuKLSJ/ziBK1RTqpNIAz3jfHpQUPJtno7HmvTQYaQEvL/HHjiB5TQpjm/1OPdrjph531fgiRZtsFwSPe0GiBb5l9F8Etbu+jjxWv8J3D7xl5Ff/ll2E6oopFkdMTmoS/NaOi992K9xn3NgR942Jxwb/WwojUcJumiBEOx/GwNREdTIkhwYiTQk4JPw/63F17Id7vaV3XtqMWv30BXC2UzKgenwnJqCWLSY782N/NFY70aY0HFwPUgf85zgKizY+R+4nSnXK8hgeaIT9DP3pabtdHRZ2eweZjgygRR+hu2TH/gVsdsCGm6np7ooWhxoQ8XNXBLnQIFkxaJRcSit9rNaWbQC7tsELnwa7/dlRvgN5wGHOzG34pBQoLBAz7mjPOIGl2hchMmyBrd+QaSsSWKNqLWj0JKdNXUqyN3Yk1n0dG74Y77YAIPq/rVp8fhnKM7KY36YKX/Ou3lNoFkPTnvqN5pC+9VTM50fF6eN5xinKBr//sCTh4ON9d/mJ8hvOh69QmR//fIFMd/rph0JMoAd6IvCSI006vq44YQZnM3i052/uPLAsf+S5jVoiujQ17PPywjL9EYaS6XO3ZGcTeinitE9oPqbMCy6d3UFB5dvgjS6HnyGatYM2MYcEBHemOXbrswiPq9/MjsnE03f/ujo723NJsEytctT2PwESOpseNmgiugLMkpsqy0PkCmTl3NBufKWXfIl8RyJe1bBjdf3hZVHCVcCMPxhKvj+ir2OwVAFGfWaYz4MA8ng17eK4WAX+E4/Ta9hVh9o+Pc1iOLQBt0g6neufeUh91qM2conLGwtY007kabewcaJItpbVCmjeoaZyG0rqUnO6tRK0ybJp0R
 MA6Ifqeq
 rpPp+7fMIwpZzo7zL4+IW6UjaqtRTKTNotVrgZ20sp6Ji9kefwW23svXxEVYIrAz9EhwAV00LZdp7KbI5LsWZdVFcPN9jBuhvBusz77EbSOEWDSwJH+Aj5QNwtrHgCQ5bLiT+62DWwLMeYSsNGmOrGoYz2DgbcTeLSvH6WJx902DIDhoRhrHmWtZtU/uJ2WntqU3FBuBB10VR+8lpPrH+m6OJIEtnLwmW3JUiQbecxp9oAj0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter_arg() receives range arguments for a few types of
DAMOS filters.  It allows any range including max < min range.  It is
fine for the logic, but makes no sense to support it.  Actually DAMON
sysfs interface is doing the validation on its own.  To avoid duplicated
validations in multiple DAMON API callers, it would be better to do the
validation in the core layer.  Add a validation of the given range.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ea7d8d5a4abf6..5212bfb8f85f2 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1325,15 +1325,21 @@ static int damos_commit_filter_arg(
 		dst->memcg_id = src->memcg_id;
 		break;
 	case DAMOS_FILTER_TYPE_ADDR:
+		if (src->addr_range.end < src->addr_range.start)
+			return -EINVAL;
 		dst->addr_range = src->addr_range;
 		break;
 	case DAMOS_FILTER_TYPE_TARGET:
 		dst->target_idx = src->target_idx;
 		break;
 	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		if (src->sz_range.max < src->sz_range.min)
+			return -EINVAL;
 		dst->sz_range = src->sz_range;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
+		if (src->range_max < src->range_min)
+			return -EINVAL;
 		dst->range_min = src->range_min;
 		dst->range_max = src->range_max;
 		break;
-- 
2.47.3

