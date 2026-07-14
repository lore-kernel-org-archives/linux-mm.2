Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFEEC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 14:36:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 016866B00CF; Tue, 14 Jul 2026 10:36:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2EB56B00D3; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E450E6B00D6; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B83D36B00CF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:35:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 73D77160351
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:58 +0000 (UTC)
X-FDA: 84987631596.08.CACC647
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DF19318000A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZcUt+/VJ";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784039756;
	b=RQegCl8kcza8oUnIkQ28pciHcSwWdSczB5/92mKq6jqzxua8OmFeNB0NFbzjOQu3HvTe1K
	DSOlSU3MFPg8sgFFBJiFCNKe3R3i2y04cJ8rdRogRzzNxmJ+tMgSeFaosjG2v3YG2tkZl0
	doxzNygdizoQ7fDLoTGzKIre7voubC4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZcUt+/VJ";
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784039756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0BZxDJkFvulRjFQmRcUYV8xQhtaa1R3auddZnH6jsbQ=;
	b=3efrdF5H8L6/74kmZNmMZOddxLP+hzKsNfZFRnsS0rGR92pidA1YoG5EGCUPElrQUvuf+H
	x9Q/yYJXTpKdhR4IO9sQG+HxP9u+dVlv2JRi4+hKO5z4PkeLU0o6zdNh0mj0CHwVKXhdL8
	UP1T6ersdexVJ1uvCFgn9E8p0cmrP5Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3EA7043552;
	Tue, 14 Jul 2026 14:35:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2B61F00A3F;
	Tue, 14 Jul 2026 14:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784039756;
	bh=0BZxDJkFvulRjFQmRcUYV8xQhtaa1R3auddZnH6jsbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZcUt+/VJ6EFj791Y85ZWUIaN/TtFMaBjSqNrKxGBZ2RFMCvoXiFbqPTSQx/zBXGfP
	 FPQXGyGYFEYIcNEIKIX0f/Vu8XzUZl6mBdUcLkv0hw8ykxH4ISTxBEP/1Hbl0nm8uw
	 BKJM0EfS9z+7MHCanvB0Eo+cyrgbcPXzbLvuSCdAGpxxBhjgfK6hyDeCWUrG3TlVH1
	 mPlvfa1qSvJyM6VpFxs4+4c3/KR8aHtEdhYEfHk8VMQfSEC5RU75tIHxIwEMmi6utG
	 yJxZ/qpKznAJccN/t/SprI3hpJLXH92yAv+6jDdkbVRzGjDx1oN3Bz71ch4Ug9BEiI
	 A7KDvRIE6fU2w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 03/10] mm/damon/core: hide private damos_quota_goal fields
Date: Tue, 14 Jul 2026 07:35:36 -0700
Message-ID: <20260714143544.101305-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714143544.101305-1-sj@kernel.org>
References: <20260714143544.101305-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF19318000A
X-Stat-Signature: q53d7u7nsk949zur1u9tkr5ufygoe3w4
X-HE-Tag: 1784039756-613601
X-HE-Meta: U2FsdGVkX1/PDV33FiFVbbatuUeXxpsjgK6AJ3ds5w1Vy6h5r6BpOMZ3MKLQQsvbfAiDPJmmVhXG/5HVb6Si3houUFrNxlEHPUfyfUNPxr+ueToMNda7Q+37noWvxwKtcBxyn+Ae2qQnSbwHIM5iy3hIydN7HzLr7uqAxVFvEu5jX0fhBMXXiTY2gNBF2D+cepGBIbUCfjI4IhA/I/SePeMeGLdfQAneo+9fQMcS+gFHQNJvy5YP77YOH5C0TBwrDwDQXyEPYYpodSv2BFgj04JpvqmFvHLrIAwAfv7KHuhrdFelfCBZDg6e6+pf1qo0KuD5InkQnY1JOaM2fy7zzdFwKA5HcVA/13CnZl3HmxRZvRabQ+aPgVseBL4S2c15RMCj394Qkv3liEle/m8zQp6XAhaD5ylrtCyRO2TLt0weMR143PBtoYV5zt4T0G5wCgFnV6pwHXxOJ0hlxMZ5wRjyxtK7Y7MRXquGm24GEKvGAPV4wWyK+wUmOwPZ+/Tdtt5VEqf2h6ga7q7qUEkXreVs0cwruOZfgUD6VUys6+Nr8NJf1q3/oDSz2WznweBxHEHV+Lu7tzaJgwq2N+lQLFCMfotCVqRsHnQJN4jIEZnrMwCU65oHn05l8UvJwKub4h6ayYT/bkkZKc1Buh3Ho5z+c7InJ9YJ5Y0X7O9aEB4iga59DSt1UqHQnai0InVe9T62Azvn7N4VRpRoayDgvJECcG6lNNQb0MHanf3mM0FgzwNGEAHK6ANGRFO+Sf533sTxoGPuZldLgEjEYSQqlKSzaE1RMfgbPvujQ1oSCABY/+hsDExzOxOsii9h3h3X9lGl0zuEwkgci9UoeD58xJhtu39IHZTWqbt0vjcMvKdOu2moiW270jHVqgfcBymSA+qxTPZXUmaOijUiq2SqK0VU9CtY/ot/zgan8RX5Oq7rC38NqvMG9bbO4AEM7Gya7VTNHIaK44hLV1Y+Byn
 youyrMHG
 oXyJ7C8IArJBIvuMWthjfgKIdayEGWnq0UNrasMIhaVAOLHtxPYhvBTQFbsGuMHZAs3afKEkq1bnQxGQksOFjgzZAz/l39u1eusJRQRvNvrRg5F31pmoBebjO4V8k/2hxJxTmkkM/Ozr2Hj0K6fJpOoDK3hMKgwWB7q5uoW2TMwcC33ZzFmO+Qtgna0VQbHLpzPYL+LoAIFsOdz4+K9NTFbqX4HoIE8ZWmjZzKGjv3S2eHQ02UerSWRvy1tJg+drBLG5Y9dR2c4rJSwRHRM3Z2QAzoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'last_psi_total' and 'list' of damos_quota_goal are intended to be used
by only the DAMON core layer.  Those are mistakenly not marked as
private, though.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6e160557a0014..d838cc27ee72a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -175,10 +175,8 @@ enum damos_quota_goal_metric {
  * @metric:		Metric to be used for representing the goal.
  * @target_value:	Target value of @metric to achieve with the tuning.
  * @current_value:	Current value of @metric.
- * @last_psi_total:	Last measured total PSI
  * @nid:		Node id.
  * @memcg_id:		Memcg id.
- * @list:		List head for siblings.
  *
  * Data structure for getting the current score of the quota tuning goal.  The
  * score is calculated by how close @current_value and @target_value are.  Then
@@ -201,12 +199,17 @@ struct damos_quota_goal {
 	unsigned long current_value;
 	/* metric-dependent fields */
 	union {
-		u64 last_psi_total;
 		struct {
 			int nid;
 			u64 memcg_id;
 		};
+/* private: */
+		/* Last measured total PSI */
+		u64 last_psi_total;
+
 	};
+/* private: */
+	/* List head for siblings. */
 	struct list_head list;
 };
 
-- 
2.47.3

