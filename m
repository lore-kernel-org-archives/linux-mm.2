Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BB4CC44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 13:52:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B49666B009D; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B21006B00A0; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5E166B00A1; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 78E7D6B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 09:52:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 091341A006F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:43 +0000 (UTC)
X-FDA: 84987522606.02.67C7081
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 71E2A40008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:52:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJRSBpUX;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784037161;
	b=eIwnex+R++wc0yTz6WRyYrMvn+M0OPwQowod+qzK5M1kuo/3pUvBl1P2mrW1dNPUaGuara
	xY231v9jWHs4dXMlZEBLWCoS17ScCw0ZB3pF8Z+DuOYLz6ofS+Qpxaf6Iuf/XkXmvQ4uwE
	cUT6VJ/GLk49U4vA4R87Foow9sIWn7c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EJRSBpUX;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784037161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q9KjTQrAluw9j+QP6j3O8xbCeroVnCVq06v65dUktLw=;
	b=Jq1BTzX1LtvfVnXNqlakIgfTgkSdumQ8veNo7LLFZ030tKZ7lxqYEDtGhWVzsxQbCEQJj8
	Oy22aCLPFIGjqX5rdBcStuqaO+3TbRGKaMYZZo60siY+tx1c3ZE5aJpI/7PMmrxWvdCCGM
	SJ/RMMqrYm2lHabjt2RfOmfDVsHvSd4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0F16060254;
	Tue, 14 Jul 2026 13:52:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7F81F00A3A;
	Tue, 14 Jul 2026 13:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784037160;
	bh=Q9KjTQrAluw9j+QP6j3O8xbCeroVnCVq06v65dUktLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EJRSBpUX3PedikG4AVOL6Hd0tQpz05Ds29mSlPWNdjvO/63ajYDckPbJAg5+6rAn0
	 5nhX5gcm92FNBCgte+EIYl70ZREsaJcu/cWHc4Qk2oy3Vzlijl9mDlWvoEFk5G/6HD
	 zF9cYE6xI0F5EiPxJczCgS4A9S+9jkncDjzqxik864KDlBA2d0WhN4C8XKA23f0hSS
	 9l1FM4ArevpTjdOKCaHRFytdXzeo8Y6A+XPQmdwwfFKT53f66ejq7Qwl4PIDxEiNO3
	 dgjm8Bsdt9lacS9uisrPwpbkxjdse4Thb7+tftSQj+bH9ELKQXULeidbIREkJ8siZW
	 thGBU7ty7t77Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/5] mm/damon/core: avoid infinite kdamond_merge_regions() internal loop
Date: Tue, 14 Jul 2026 06:52:29 -0700
Message-ID: <20260714135236.92699-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714135236.92699-1-sj@kernel.org>
References: <20260714135236.92699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 71E2A40008
X-Stat-Signature: rct3kp87hzkmrjfzaj4h49qasksjyisj
X-HE-Tag: 1784037161-272225
X-HE-Meta: U2FsdGVkX18KnIBS4Pp4LR+ultn8LZ3OnXQ30Iq/BT4VkYBlmiZekPBG+51s7nqDWsCAdpHkA8PQZTq0Ok5dY6Ikaym0o4w+PIoioexlh4qtEWdSzZMuMl1aTVeno/7YXZT6wQwUu1aDaDtZXqXD/bjSrZGGFID55vzrtQg+EEXcbOPWCPksooK5nT3Bd33gALqV2+63ikO9yybjMoBcST+nrN6oZnYi12JlwHkJz/iOLwwx4scaiBBweor2h83cx4j6WqMeuSW58Ja8Jn+n+BFpg7NSNCuIJwl4oujuPiCKJEnRT5cqjmOw8IlhTdm4KNr3zCOzpN8WFliMSpvyp0tE0tddtmLElyGwwG/c7KX9xfGaB3PRJs7UV5N2QilMe/Mr+fEgu99pBYV6GYXH7ebfW6pVnXO2qSsMolMeTglzvR5y+756b07/IdKpST7ZUkat9Fdy9+KwX5dbVBcrKcSjDB8bCaZWsP2X4sFajqcD88KZEwESpCIJgSShTqdQl7qO4+qp4CmFsG1r7VdhjlyQ1gA1g5kDjv8hZ4MQK3RWdkiAyCDPvDrAQ/RidRlOBVE0kXYSZwNz0Fu1NTFfLdtDryp/leypkePJxjl6hdlsycdFjyK3O5zEJX7Jhm2CvGIJHkWiARhpzDQaGIiPKYOZvrAAjTEY/zyFKH9YqwDoziLAGv4Z/eyi6aG/4D9H44t3ndmb8+dctVXXFiXw7jJQsvSABd4PHOpIEiwl6jwi5b5N5/WTpDnE1VOl9I6ffwZxs3gbYOtM/+plaKvMS3m8NyClcsF4Eny18a0dW+PmwyTK4Fvd98k1anfQAmugsToH6ZTEV1vY8w0T4LhfXGRNvrmzUM4Q+wYUVk49gPoH/Kk0+it94vQMV8L09evccYQQUGSnjpNJt8ALLg5ylAG53Yb2sRzi5vfoc7KUtpDmb4pU+YhfZAr7zfSszyI38zBCi3Y6yamightRt4/
 9wl3f/0z
 BoZ35ygZJ2CiHNjl7fYU3sDvYkcPfQkZhuSDrKrIHS/tRDhFGk62HSMLfGZ2w+PlGv0UO+aLEwsuNQanAdJUa8cvSpnk0OONt8RmBLaq7+ANRsH7D++K8JU7IqpTcx4QQBuk+m0V4H+OJbG2Ve5j5tqiivmNrIqRxEMNjasiikulDXQ8sR+b/BbZtt/YUVbv3cqDXqea63SMxrdtTIUG4S95nAGvF7owo4V9Wn8OioSQGnGNx48Xgg6Rz+TOcafy7Wt3vPuzNk90XLaAyv7H4WhlTMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Due to online parameter update like events, the number of DAMON regions
could be higher than the user-set upper limit.  kdamond_merge_regions()
repeats merge regions until the number meets the limit, while doubling
the merge threshold up to the theoretical maximum threshold.  It is
tried only up to the theoretical maximum threshold because even the
aggressive merging can fail from reducing the number of regions under
the user-defined upper limit.  For example, there could be many
user-defined non-contiguous regions that cannot be merged.

The threshold based loop break condition is evaluated by comparing the
threshold for the next merging try against the theoretical maximum
threshold.  If max_thres is larger than UINT_MAX / 2, doubling the
threshold could make it overflow, and bypass the loop break condition.
In the case, if the number of regions cannot be reduced under the upper
limit like explained above, the loop will run infinitely.

Prevent the case by doing the break condition check before doubling the
threshold.  Also, prevent the threshold exceeding the maximum threshold,
as it could overflow and apply the wrong merge threshold.

This issue is unlikely to occur in real world, since having the
max_thres higher than UINT_MAX / 2 require unrealistically large
aggregation intervals compared to the sampling interval.  Also, it
requires an unrealistically large number of uncontiguous regions setup.
Nonetheless, the consequence is bad and the fix is simple.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260709145425.96247-1-sj@kernel.org

Fixes: 310d6c15e910 ("mm/damon/core: merge regions aggressively when max_nr_regions is unmet")
Cc: <stable@vger.kernel.org> # 6.10.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 6c4215cc809ec..603b102ff80f9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3372,7 +3372,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 
 	max_thres = c->attrs.aggr_interval /
 		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
-	do {
+	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
 			damon_merge_regions_of(t, threshold, sz_limit, c,
@@ -3380,9 +3380,14 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 			nr_regions += damon_nr_regions(t);
 		}
 		count_age = false;
-		threshold = max(1, threshold * 2);
-	} while (nr_regions > c->attrs.max_nr_regions &&
-			threshold / 2 < max_thres);
+		if (nr_regions <= c->attrs.max_nr_regions ||
+				max_thres <= threshold)
+			break;
+		if (threshold < max_thres / 2)
+			threshold = max(1, threshold * 2);
+		else
+			threshold = max_thres;
+	}
 }
 
 #ifdef CONFIG_DAMON_DEBUG_SANITY
-- 
2.47.3

