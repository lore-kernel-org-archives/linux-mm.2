Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BF48C87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD9166B0089; Sun, 27 Jul 2025 16:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BA26B008A; Sun, 27 Jul 2025 16:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78BA6B0092; Sun, 27 Jul 2025 16:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B7C236B0089
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:23 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7591E80CB5
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:23 +0000 (UTC)
X-FDA: 83711156886.03.71274FE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id C635A1C000D
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdoXJDbI;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647501; a=rsa-sha256;
	cv=none;
	b=CShPA8jy+e5xd3wgX/EdUnAd5QzkUEYrDv2J/11hYeMecZVvk98g4KBVSX6/X2NfY/kpD4
	e+eHRamuJeGv1gB2VHX0Mi2KGYjagg42cYgv1PwqABshmZs5QcSIrt3sqQZEmi6mvCmJH6
	Ye+y5yVmsVWp127TsMXwd/BBRWPjvG0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TdoXJDbI;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hVgJUQN/ALscJHG9+GO4mdYxB5bRwZqFkePjdVht0i8=;
	b=xMAVEeytV498P5D3TmnpRZ5qsgCWC6RLBO/an4QkzNehUhsVsNWvxY5GzN7e4FyCPrnz4A
	gtiZGiMSpuqQ10ZTGKOxXQ1Dn3vimdCIZrLL9tPOYVZHK+CpN6mz9c8P/seg+Fs2WDbUxr
	SN89VXk2W1em7iOSSZTWYEdvhFIdnNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D62B45AAC;
	Sun, 27 Jul 2025 20:18:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E560C4CEF8;
	Sun, 27 Jul 2025 20:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647500;
	bh=tkPbh1vYlIwSvC/vF2tZ2YQvmhDcZ/BAu1gsu6yocrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TdoXJDbIX7Og9uiSKRdjVQhbxJm2D0VZc+QHNI4fHO9garcj1BMAA0j6RLls46a1D
	 /Zs78wbmn2dXP3gDf/ZM2syok3kNJ02+AwBzdtP/BqsOve9qrIdKrnpf5VK/yJLvYF
	 n8eA19tzgNoxBptNdEKBL+2xxjgXU7KhSQWkYpxm3xhFCTsIbStnDQMV40RxQQpK8D
	 POHIG4dJOn14pZmkFmfiVrKGjS5zqOZCNb3RIpJwBnsQAEkgIwGu5RI92b+DDbAjKy
	 Oh+PROfob69zYN+CD/INvzqHFaS6MEczh0mckk1TbVRgCfLk83zasSeicW0XQDGrIc
	 M9rX3/yfAFG2A==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 2/7] mm/damon/core: add eligible_report() ops callback
Date: Sun, 27 Jul 2025 13:18:08 -0700
Message-Id: <20250727201813.53858-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C635A1C000D
X-Stat-Signature: 4dyre3hjsus9b93qjct446z9wfnw4jde
X-HE-Tag: 1753647501-699252
X-HE-Meta: U2FsdGVkX1+c+mp/iBwZvDJnwSjV7GKLngUJtuBXLVPvPf+beupEvntNyDa+T8v6Vg/4hKkLNdA8/WtF8hjB2a8AvjdPU1uUBCYcIwMQLO+GZHsWWcfaEwuvLL/TCGlLkMQZ5mgkx/Qpeu4N6af21Jh/7SMH1rdVJxU1zlAju/LYB6pYCbZawL6Kjyer6sz3KSfZgxF+0ERmpb0dhKWrZ7uYQuQOvjWoZHXK+mqgaD9Wn2HDwgMOTmZLezW9Pc1VHga5VZVPpV+v0U044n5sB8CNGLGHmLB9axRjeKv858rTx0vwynp9iRRt1Ktjrsr1WDv2Xq0T7bH6k07XoHhcJm75VDAN9ZHNRMmr91yyGSu1Lnna49SjmmqNSKTyCjm9dS+eoRherztQ2CCaTPtRW69ylCM3SHdLoBq8iMg+53rRhuzgMgmoqIwPBly4YW6AGItZtK5CTGURdsrIn7j4LFVCoiJzqIZQp24OyIfUQyaJNweKbibZJdIv+xwyux053cksozJOGlCZCOPKSCIZH+JWW6W7+xpJTATHIoOwRDyGWZHjoBar8W0VxQ188BLYA7Pf8alnJeG/6IcVDCS7AmSF7KQm0iJyccvT/cuVAPmPbWrSPqPwdigIIG48h/d0CDindti5yXzDwPVk5Ysw8225qTypFGuRrSFponfQ8cPwFdBgJ+2ToOnVFEAe6g/k86HlMfVBWduWY2ZDNRj0eM3kArPSw83t/oX7PMGMdv+JPtgFVRFqxvtpZ8FaXOmjQ8tZaDSTOMGQtn5daZ7K3En46uXMQxt1Wynyx6WlJG+80QBiEXZk+99Dh57kcK3cvQ2jJX/HMF5WldrjDKNya8AGw1JaU28FUlBeeTqw4Es8xqLHH5Bsk2yQSwJXp7UGUhKqbn746Ldx1b5DHqONRAUB/ghV8SOvp8RzU/UsHDJ2e5nmei4uW7qOesmWyMEwlr05dBOZgDchXwmjRp5
 dbBqTCmB
 TEj2RwaIFHYEyhLFNMZuzbVI0CcSYmNENf5JvFZ7I2V7U1N6Ts1YPEF0BALnUhlzFni73ujB206irxxqZQUYbVtffcRQVWHz+BJwXzUaHBM1ZCIuuHGrbqZ+lwB5qNb6DmDNsS0B/DMFe+5by5cuNow4SAtZsKZeD788q7ujyMNBIezBtA816lb6YnXV0fhhrl3kkG8l1iPn1dHJYpuazaXWWkPyHawJ0xfxv5SlXHmdw7Dk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Not every reported access information will be eligible for all DAMON ops
and targets.  For example, virtual address access reports will not be
eligible for 'padr' ops, or monitoring targets for a process that is
different from the process for the report.  If it is for monitoring
accesses from specific CPUs or write, reports from other CPUs or reads
should be ignored.  Add operations set callback for this report
eligibility checking.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1f7592147d92..f3e5c585b5f1 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -590,6 +590,7 @@ enum damon_ops_id {
  * @update:			Update operations-related data structures.
  * @prepare_access_checks:	Prepare next access check of target regions.
  * @check_accesses:		Check the accesses to target regions.
+ * @eligible_report:		Verify an access report for a target.
  * @get_scheme_score:		Get the score of a region for a scheme.
  * @apply_scheme:		Apply a DAMON-based operation scheme.
  * @target_valid:		Determine if the target is valid.
@@ -617,6 +618,8 @@ enum damon_ops_id {
  * last preparation and update the number of observed accesses of each region.
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
+ * @eligible_report should check if the given access report is eligible to be
+ * used by this operations set for the given target.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -635,6 +638,8 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
+	bool (*eligible_report)(struct damon_access_report *report,
+			struct damon_target *t);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_target *t, struct damon_region *r,
 			struct damos *scheme);
-- 
2.39.5

