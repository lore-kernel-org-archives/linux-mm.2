Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326B6CD4F48
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 18:37:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85836B009E; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38346B00A0; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6DBF6B009F; Sat, 16 May 2026 14:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9341A6B0099
	for <linux-mm@kvack.org>; Sat, 16 May 2026 14:37:30 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 57ADC1C02AC
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:30 +0000 (UTC)
X-FDA: 84774141060.26.BF5EB93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7AC5340012
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wh8zUIRu;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778956648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wotxqZ3Oo/gp0BLe9vGPdYiEde6hhircJn36gtW6WBE=;
	b=xivd9qwWVLM2fmXaXP30GGdJp1/E36RJS/MD4mozCDj0PnqKvviPDFgea9fcNa8MTAfdS7
	CLmrTfRJu3HhprHugCmVxINrwFCVgptVnqehwQ5N5b8rcMq6RojlInllz1cEnQ2BbqJzyO
	An5mXNjrHHS3cCaNmq+p+J9qy0dyXZ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778956648; a=rsa-sha256;
	cv=none;
	b=1sS9zXFhONhWND93YWB/9MiwKFbWlS5N4Zy3vw0Dnz2SI3URDUQpWNuXtzreys43wqeOCY
	10W3dSmObhNTy/+YHuSrGmIVJUMRlfhRP4Yw0P4TgTVlpBYVsB+TQPszoWRMvKT3/k9vpm
	NvEKHuucYYNiMto/+aiiyoHicqyfGgM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wh8zUIRu;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A092844566
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:37:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641E4C2BCF5;
	Sat, 16 May 2026 18:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778956646;
	bh=BuHcQxBfKAGy6KrsKoN0hgRqvRDUguIDR5Ybq3/Wp0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh8zUIRuGhg8pd0sj3+VAfQpNbUn7HNJekNiHtL1lC54niNCCHjTurkMpp11z4/47
	 rgqjCfLFBSf9kTnnc/r6DRoCgRvkFl/1i1mkyS7CKvt7HUUbk8evl++70dmWRgjV5i
	 Vi+EYS38qe54lyI+kKbo+SJXKTAcBJbXGSxE1IjEGsG6NTvZ7Pfe13N46MZBgNeBgq
	 PigFlGoXhDgyNrzEvyuDOcGOUgLRkvF0TkVqWesIV8VYXSa80zWWW+0r4QeZYTNCFF
	 JDNUdeC7Rmx7NHDBHJU6cQtBzmUOiNC2JbGJQ9T8dGmF4MUUTU+SL4LE6Tho5FwaTV
	 TX/3LlC4ifWGw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 06/28] mm/damon/core: introduce damon_ops->apply_probes
Date: Sat, 16 May 2026 11:36:47 -0700
Message-ID: <20260516183712.81393-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260516183712.81393-1-sj@kernel.org>
References: <20260516183712.81393-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7AC5340012
X-Stat-Signature: pcwxxz5dxdtpakdtncho11rujzansoyn
X-Rspam-User: 
X-HE-Tag: 1778956648-929964
X-HE-Meta: U2FsdGVkX1/l1BOh948ZKQ4fzLG6F6+eEdx2WQx8Uc9oxC9fu5aXiVKQjdRGm7JIzm98cNNFi8R7w7IlCKT/LSZyZJtaMMraxw2eNI9ZD7H4MYuDElpH14+wyJgr/VUGSUWI9mz3qR5+fhqjcQn3ndOcCSLdyIiVkHdB5nugwzW82lDRc3FvbfeKddwQ5Vrj3TR/q3AlVGQnrCxBYt4Yp5cjy47OKFoH9ppWm2TbrwCaEthL6xkOnPDvcNlT/PQLreZS+Xp851taPyZGZYCiKAV1kSQIJWPRYQZajXTDEpenIIHAHMwxq1o9t40m4K0nqcA7evKBLYvF3XcxXsK6a2s18zfxL0ko1OqAFr9lANhCcpUaPVwZs7IxBykkXGrdJ/F3vAUVzBY04csZ/0FC1pndn/0iJ8Ew/VkJi/ORrj4Vlw5AYNbtxyo9TYpecb/8FPbu7sfB5sXFgJISYoE2yyOwGqpBr2zIiUq7TyYEn58sd5BTafiQCC4yexwmfyCd4/jXhw33M5LdXVvnZY3bAMlATN88FPqQgsGPxpdu1av/e0a+99AltO9autAphgE1cCo41ZSLz7woA0aesYs2YBKhN3Oah5k819cb0xEMxUc5p0d2WnQNJ/rsx/yxGVNAYV70O3LWGYxWQNgkIhF6ZNBLAqgcBXLHvCMOQ7e1vBcdCnBLDkQZJdXvWAtUynAaPK80CRV31mllZSos+u4A/dMvRqyCa09lbCFDkGdTcidxOfppXKSeLWTGH6Qh8hr6CWUqNy7uj4McQAi5PF8kVJ21IKRHQ6uCr4K5m4R0rgz7Ou/n9OC3zphsRleienkKyTjQ5KulzykABJ5E3aKKyh6HLG/kaPA7oqqhTBqFAtA+WcTHLZ8HAqTNTCMn7yirDnba4yzLtTX8pb92+dgVxzCSOqlSyec2ZVoj3ngTR/Qn8v8JvkY9i5opvHqmTlW9D6lY99ZXGCZe5g+suM5
 QsAFAbKk
 sbrvMxL3ddFekmBeaGwAmHi6ESky69By7j713IoxIXZFbHIyqxHVVP+rdJdry//L8Hdirn/aiaTZpIUpfgPI8E8Se70Bxst6IC8NKNOf42jdEDGk18tYv9Gfth+LfAfHgfmhRslROnEEnbLcIxs/QLRNw/IetR9T8mTexcOl2vH/pKA1MvT1DsnaL+WnPM+XypBoTR5xIdgD5uM39ag7bD/OkcXiyQoxx88UkU9fg0EOZ8VZnnryJVXxK9R7ay7VYlYYy6P3vX5gtBWJDUE+qfn2cn4mE9iHJiNdXkrimvC6r5BKc/mzwQHTLOchgVl3TjIo/hAHeINEh7oKwfzTUMq0wVcSQ8cOqoTGa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_operations struct with a new callback, namely apply_probes.
The callback will be invoked for data attributes monitoring.  More
specifically, the callback will apply damon_probe objects to each region
and update the per-region per-probe counters for the number of
encountered probe-positive samples.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 9e70239e5305f..d3b6296700a08 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -621,6 +621,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @apply_probes:		Apply probes for each region.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -647,6 +648,8 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @apply_probes should apply the data attribute probes to each region and
+ * accordingly update the probe hits counter of the region.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -664,6 +667,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
-- 
2.47.3

