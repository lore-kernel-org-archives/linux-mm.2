Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A034DC44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03AF36B00A3; Fri, 10 Jul 2026 09:47:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013396B00A4; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45B76B00A6; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AC2DD6B00A3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4405BC1C27
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:07 +0000 (UTC)
X-FDA: 84972993294.08.98577BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6E9B140008
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgN3vABS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wWo/baeB/+xecwr1CR8NpXyICuKLRcYoU7QPq7PEYE0=;
	b=EOaKHy7iB83GMbjyVLWokSIEXGirUtBm838WIhcycnnh/Wm+1LE6+E2C/f7Wy6g4DJrLcp
	ara6RVu3QAwKi2jgqExxZ8ybHgKk0dMTRb7ZBVky0M88k4NA8AXqeCGltlGIqMGvoASk9l
	1coAc3eXaQhuHPrnje6si1BBlMC9PfY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MgN3vABS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691225;
	b=q+bmd0fWwezJ4+yfvxOZw4MDEGQbP/jleUMUjtYKPrYJv6fM3RJSkutgk09tBN+mNFAYkb
	NhhRpt2NDgrQGNE7NM3wmnFXHyD11BUYsME54K6QQgckEsGNwLz6f/UK8KpeaJPje+R6pc
	ie/8oXOtH+dZUcqkKfTMR9O00zYoRMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0820443C4F;
	Fri, 10 Jul 2026 13:47:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CA11F00ACF;
	Fri, 10 Jul 2026 13:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691224;
	bh=wWo/baeB/+xecwr1CR8NpXyICuKLRcYoU7QPq7PEYE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MgN3vABS6/mROQHiY2SVPzVsZ58e2dAD9UmVZhgwnBiVd6yNeZ6APcel/2iNfy8rX
	 7VCsY/C2KJAOQs56Kt07iLDIbC2uS/R697jBaRjJs43AQY5NXgLpPNHgFtFkGBuWZa
	 u6A87pmd4g4zp7AymKHIE1+ukoMvbAGob9rKSd5kt4Ju1Y2/cIFyiMvs+PvfBXzHcU
	 al2IhbgS9/7lt/6MkZNoAQd7UUs1uHhMER3ntmQ6aD45X6Id+uavfUWpMyNFWKtbqs
	 q/oJL0a14vEHt7F+2evpj+IRnmBV65NBthOF8mJXEnTr8VlgDnpiBU9OWkabm6HBjI
	 xQk+zazV/9/CA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 14/19] mm/damon/core: get merge threshold from probe hits when weights are set
Date: Fri, 10 Jul 2026 06:46:43 -0700
Message-ID: <20260710134651.18084-15-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A6E9B140008
X-Stat-Signature: wwku3f4atc9skdpkc9wjhgpmmznp9fba
X-Rspam-User: 
X-HE-Tag: 1783691225-298063
X-HE-Meta: U2FsdGVkX18PmLQ1opkm9uc0T60iQvYgDoOCyjVLoth9gd3UxHgH5E633SSwlGASuiJcF57XE7RpC3EgICsHS3U85sW5MXBegIu56QCVk8r2//voejZdxFRl3hB1AHLleWqF4/WXsw/ZxAkOfK7a7kf7OShNfLMTxhVoqYYktY1S/tASI7knP4zca3YvzzmmBgI7xL+GQXlkZgMGepCepJ5VTgFxv7nQ+ZwCnhYcaAeuunLQGDh1GOxCUhtHhvKQDpmexdU3CGJOy7birbTvYYZcuLfN77csinve8JcegwSmaPXpwrs6bEM/5mTzAEHpIUH5QFlRWImDlw+hT+Yzgc9A+5DjTK/bInfdGU5egvBxe6Q718yPzyDzbBdy3C+wP5bK2P2Zn60yIPOR9cbmZMLtllfvtFesysu9O4fYsRdPAPtz1p0lFcgRywKSNux86TQZVy1Qu8oUNAq4Dn2QnsQ1TeJ/ZJtZz7itao2GRnQrnmiqnRWUiJOBO2kPpOhIebGPz5/mDGy493ZeGBX9UHm7gAInvm1Ccj+3muHpNtCbR00CJmOSD+YSUpm0eQRGWE7fO74UX5HeFTxBg9BleWWMULhCdqzjhICbQEdXnvO89TRlcAqemuI+zCcJHO6fH4byYdNODc/cnZ2umjtPQAmKTgUrDfgZZL5p4T3WMejD1U+ZpqTiTxJHFmvQLodQGbmNdG7CnvyfFe1j9KLAbUi/XUVnkODV9Y6i7DPpyAcuJIlnxR4+LJi0ni/blkchd3Rkx6xMVEpAHLizYiw6v6fLr3ZsXCQZtfO9Dg6cgy7Vffk3QvdHhVrxiWmh8L+/1zQZ8vIavA5VEp9kel0+ar0LceGvVSSCAAIbSADFaR2xetUWT1T2ZOF0RBZIXRR9XfZ6axyooiDy2RGWC3otgWrZ9ajLqNy6m5QFTqpX0lX5kZM/dKwXym2+hWSYKhQS7kOBd1gN/2x/s+kOtSb
 qSUGCoWj
 EGslWGV+N9rJ12DSkoXK0OYPgZHe4S58Bb47Wz+q5ebhdnMpTAONHyIQuK7dKK6zVINz/6N9NwAU/PWSIMiEefnfoFJg3MTtZicotTzYhAP39WRfByNNszsRj9scGoaW9NHHeqEbyMemwo3ohTGA4p5csZ5H5LRQD+46f1Athe4Q6oQmOCT+GxvFaGCVWogO3O3/RzXTd7zPqf03qldcOIAI4t3UnLelWtgxa6llSjzh5C7w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merges regions based on their probe
hits weighted sum.  But the merge threshold is calculated based on the
access frequency.  Update it to retrieve the maximum probe hits weighted
sum in the snapshot from apply_probes() ops callback, and generate the
threshold based on it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f7782c69037da..91964336ce31e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3763,7 +3763,8 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
-		unsigned int max_merge_score = 0;
+		unsigned int max_merge_score = 0, max_wsum;
+		bool get_max_wsum;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3776,9 +3777,18 @@ static int kdamond_fn(void *data)
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
 			max_merge_score = ctx->ops.check_accesses(ctx);
-		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx, access_check_disabled,
-					false);
+		if (ctx->ops.apply_probes) {
+			if (time_after_eq(ctx->passed_sample_intervals,
+						next_aggregation_sis) &&
+					access_check_disabled)
+				get_max_wsum = true;
+			else
+				get_max_wsum = false;
+			max_wsum = ctx->ops.apply_probes(ctx,
+					access_check_disabled, get_max_wsum);
+			if (get_max_wsum)
+				max_merge_score = max_wsum;
+		}
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

