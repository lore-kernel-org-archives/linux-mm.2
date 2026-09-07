Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A424C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:55:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F126B008C; Mon,  7 Sep 2026 12:55:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF1D6B009B; Mon,  7 Sep 2026 12:55:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606866B00AB; Mon,  7 Sep 2026 12:55:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 403826B008C
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:55:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5A851601E7
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:55:43 +0000 (UTC)
X-FDA: 85187567766.05.90A4FB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5891D40008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:55:42 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+FKirZH;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788800142;
	b=O/jQS0vvihJV+VSMnXgBk5Zgn7LxhQH+OMTgnN3xd6TY3mDiWkiRkQuXubfO0QahS1Hvj+
	UGIV9CRfxKwilBMxxLEP91KnKA4awphuXxiy/jYbBgIQL0AufDdCSCZcgoKM33KRnb+6g1
	88m+FMvmQWwK1oMfkuLOkbJWkTXfEeU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=N+bAn4jc0lwjR+rXbNhNnyvVby3zOE1/1ScvrFn1ygk=;
	b=y1ZqubH5MSGs2E56tInWwa39P78InFQ+wfqmpktzOlMbOQUQDcXbyQCKg5IVyGSRxzKEE3
	4zsdjRkaI6SaOmatPUUf42ayK2aZllGGFbPPsxBFcOa/aAO9noUGDre3DzliUz4Q9GRplb
	LF7VpUFxv70uduGtK8S53XdfoBrDFMs=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+FKirZH;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D1506601DB;
	Mon,  7 Sep 2026 16:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5473A1F00A3A;
	Mon,  7 Sep 2026 16:55:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788800141;
	bh=N+bAn4jc0lwjR+rXbNhNnyvVby3zOE1/1ScvrFn1ygk=;
	h=From:To:Cc:Subject:Date;
	b=B+FKirZHnhXaavgSwlgh6O9b9B0hJnwriFmFM2u4845ZZmM/movYOcM09H9Wl6MFL
	 csJ6UUcG+bOOhgsIhY8SlLCYRCD3ya4Ex0wI/VSTE2DBJSFVhCZwvPtMfxXh+Gvwl0
	 yim7Hi1eLE53ja8GQ7txd0Yie3Hot86JxoXI1J3A6zFXfeLpxVJ4WU5WmzxRK+VIvD
	 hQC3uQUv5hH2z/SRKmoZz20elCNe93iqE8WT+sbrqoIkXXj+9fBtfSKPDO2yebbaj1
	 shgPJFw7cC1NBW6JvmSy7lhzCr2ZpOBry+jK6lCJB9g/kNGOUPTorDa+0vcVoIUyvq
	 FHjfmjB+H++vA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: reset invalid quota->charge_target_from
Date: Mon,  7 Sep 2026 09:55:27 -0700
Message-ID: <20260907165529.98874-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5891D40008
X-Stat-Signature: 4w16t698d94dikmp41uzm5rwzzgihnt5
X-HE-Tag: 1788800142-506012
X-HE-Meta: U2FsdGVkX1+ULDByQY22X+CSmcM1ecfzhbrk7GspoJpjHeTX6y10WF149IqjwXJVDopI/hX6fnsnGvLGjvxlqkn4emapeuntgTxFuZ/Vu4iJr7JmgvtTM4Suj4/QIp5LVNvDsd7XM0IUBCmk8FbPxNoE7xX2FE2VT8DNQULF7lsTNkVyBoQbzc0RUdbO274lvwMEmZzhyEMJj/cijHO5P1enKf336+IE4ynGexiinr5Hg8vCZhWRnM4j/+7wBHeTCUrcST57V3AqNx9LQNzFUEanLppynM++iv33JUjSUAI8lDiQNn8mjm7LPF+iEcMAWi7xIOdXlN0QBIbH+4n0ngGEmCDOg1RPET6fM7D1ZMgm+9ywhbb7H68UnzyecITwRcZgRnRWSKmMnH8Np/1vho9+HrPmGGetn6b4Sj0mTUg1jEjx8csHNT7ZCXL5RpB0DOZyzT6zfdEGNTMW44Lxfpy+igcpecGEL2WXBPwPPIDaWq16oBYHlr9+iURdfl0jMimqcYlWILxekR8PZxhNY1/LPzR8kMAfpEnvW5VWHKgeR/NMDs8LxZH6RzIOU5+Bzm636r9pRsGoej6OtD27Vv/zFCZTT8GOhOG48gSyXQncovmvJmKoVZVzo035GaMlBEccxe4CJb59HuUsR9XbOgzlhUEXPv8KVGkKLotYy2CziJTkFEcLw9yzyMdfrcceEOA3JsTVquxWpfuaVsao1sMNHyWMYjehiEXGFkGjruojjPTpiGsvML/HdqGzP7rQGa66vZiLiZxWoyHKqSadMLKaMtweZoN+FbV8J23zjenk7LB+agepeAQk4Ddox6PPy7dJ51v+sYPPTCGc0Cs15ZN7SimDVGHtjF1phwFz4JxtYyk5eDCGEOnktB3v5xbz4YTbSmC8FE+C0cf5P2SaO3iotnhi5nPt6bc6uWP/6LZb6uBZ8k/B99GQ69NguhXBgdXw63mELo5rugoqagK
 Vk7o0mV1
 Rh20ZhC4Wtu/MD/TQSawzuJAkxMRYSXbOtxasUlAg/dMbOfVY1/XzDoiXwj/o4KVRZ9PqH/NPSrPhCR+dQu2/wa2tKE8NydIJ2iSGIMBL2YkKFqktYtPTDgBpl0+qvbiIJ04gVhis+/IyEAMaorB9cLpIlYvOmfH7Gpc+E6fDgO7uNWyox+3R4JbIS02550ktIcpTq7XoKOWQnyfW3Zj/IAURtVjQIjSElHSRzEtfG3zyCBTyU+3hT4MqwOlbLRHc8GQEmDXut6SSNAFkzUEC+IqNzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMOS can suddenly stop working if a target process that quota just
fully charged in it is terminated.  Fix by catching and processing the
corner case.

When DAMOS quota is fully charged, the target and the region to continue
applying the action in the next round is saved in
damos_quota->charge_{target,addr}_from.  In the next round, DAMOS
iterates targets and regions from the beginning.  It skips applying the
action to the regions until it visits and skips the saved target/region.

Virtual address space targets become invalid if the process is
terminated.  Trying to apply the scheme to invalid target is just a
waste of time.  Hence commit 6e4930e33329 ("mm/damon/core: fix wasteful
CPU calls by skipping non-existent targets") made the logic to skip
invalid targets.  However, it does skip before the charged target/region
skipping/updating.

Let's suppose the user runs DAMOS for multiple virtual address spaces
with a quota.  The quota exceeded in the middle of a virtual address
space.  And the process of the address space is terminated.  Then the
charge_target_from points to the invalid target.  The pointer update
logic is skipped for the invalid target, so the charge_target_from is
never updated.  DAMOS action to every target/region is skipped.  From
the user's perspective, it would look like suddenly DAMOS has stopped
working.

No critical leak or crash can happen.  The user could reinstall the
scheme.  But this makes use of DAMOS under certain setups quite
unreliable.

Catch the corner case and reset the pointer in damos_adjust_quota(),
which is called for adjustment of the quota for every round.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260830064708.40CA61F000E9@smtp.kernel.org

Changes from RFC v1
- RFC v1: https://lore.kernel.org/20260906183654.95634-1-sj@kernel.org
- Drop RFC tag.

Fixes: 6e4930e33329 ("mm/damon/core: fix wasteful CPU calls by skipping non-existent targets")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index ce8c6f99106ed..2c58be9edbde4 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3283,6 +3283,22 @@ static void damos_trace_esz(struct damon_ctx *c, struct damos *s,
 	trace_damos_esz(cidx, sidx, quota->esz);
 }
 
+static void damos_reset_invalid_charge_target_from(struct damos_quota *quota,
+		struct damon_ctx *c)
+{
+	struct damon_target *t;
+
+	t = quota->charge_target_from;
+	if (!t)
+		return;
+	if (!c->ops.target_valid)
+		return;
+	if (c->ops.target_valid(t))
+		return;
+	quota->charge_target_from = NULL;
+	quota->charge_addr_from = 0;
+}
+
 static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 {
 	struct damos_quota *quota = &s->quota;
@@ -3318,6 +3334,8 @@ static void damos_adjust_quota(struct damon_ctx *c, struct damos *s)
 			damos_trace_esz(c, s, quota);
 	}
 
+	damos_reset_invalid_charge_target_from(quota, c);
+
 	if (!c->ops.get_scheme_score)
 		return;
 

base-commit: 6ce2570ad1f1f4195c8d8b1a460fec2fc276dd65
-- 
2.47.3

