Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64DD6C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 04:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 110C26B009F; Tue, 14 Jul 2026 00:34:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C166B0099; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA2656B009E; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4F486B0099
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 00:34:48 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C27980237
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:48 +0000 (UTC)
X-FDA: 84986116656.02.3F38561
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id A27FD40002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o17T4qOh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784003686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VsJ4wwCCUmuJy3/ZXQ2uE1d89EPU2Gxwaw+AywiLsUE=;
	b=HGSClBLu5tjhm/GlBAPyTXikBXMXWgO8nTRYEUKBvLxVeIVL1Qi5+1omNFFYYPcMwxbvuA
	gx6Gop2kDTqmaEcgQYxzsqyA1olmpJ3b+YQf2b800Q/fzJhXWAKiYG9PnDvhKnYTwVaAKE
	xa1ghuiikOCTeNo/Hia1gtQXX15/Dh8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=o17T4qOh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784003686;
	b=P1DrKUR20RIwSk4XXAeg9WMlrf7Ko2lsVZ3tXM3J5gH8zY1eURLripbHRTLeGfEErwRVG/
	ao6eBJkGHspjjOXG4AYaVxhQWB4VMK88fbslhR8We/X/6lqOV31MLau+/9ktFo9V2UZuiC
	PUt7Oa4SrvdLIZ3SSLZtqa49h4eWOK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0FD3A43CAF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C88CC1F00A3D;
	Tue, 14 Jul 2026 04:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784003684;
	bh=VsJ4wwCCUmuJy3/ZXQ2uE1d89EPU2Gxwaw+AywiLsUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o17T4qOhIETSz8POalLLjC1zKtxmiS27JkUXNPf8ba0nExsmyGUyAHpfooPZGMjRj
	 RRCOs9tYtBIoYJemdeqsLsuAsQheONHisBDQV+WbKZO6TqmjZU/2kHbY7XwUJ+N+VM
	 8wblpwJkK5qYJ1rG4qq+SMX1JksMSz43AZ/bbnNcf6Lx8HNFg+pQTT9Js7lMysSuRW
	 +N1zbH+PzTAFj7xi1y+NjCYkG/r2b1oRJTM54fQaAq2iZ5C0e1KpnKK0zgfqpbog2I
	 uAhXpHy7KMQUn5aXMmbgHBcnhNA5X2rIMxCzg6LexDYb+yY/mptiZV0R2hGy7wisBq
	 N2TocSceqTWPw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/10] mm/damon/core: hide private damon_probe fields
Date: Mon, 13 Jul 2026 21:34:34 -0700
Message-ID: <20260714043437.95811-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260714043437.95811-1-sj@kernel.org>
References: <20260714043437.95811-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A27FD40002
X-Stat-Signature: sgnqbbb9afg8qni4ybf8jkrnf4j7ke16
X-Rspam-User: 
X-HE-Tag: 1784003686-697416
X-HE-Meta: U2FsdGVkX1/JQDUXQLHD4SCLwjn79vvNEzT7XVr8iQOOROXEbOv33pHKi0o+YZlTuo9+5s6NPLN7NDPwptbFCSrgF6Cfn6jYLSzrmEJ72qckMGH7d5pyFwQd761iPatbfPgfk8v2W8xNLZX3XsPuVA5lKZFsTqHeSVfxEltvMMSKN83d/QjXm7H7fWYUZzrFwZIjc4xAPSVTgfWQPjV/w9VxNmeXAYzzEHfsRfj3VSbOkPqJcQmw9BVPNT4xgsdV8tciAd/V/Dm94LI1hckSQe8unNQH4Fg1ImWomsI2VyrWMZqypioztmfCEBxiUnc7QEeJwo95cQ6N67O9eqZ22toV9+TljtgFoPocxyLOmFjmFIeJHAI/d5KxP176v44p/bcqEYsqSu0Sb73uCcV3wee5i9JVb/1wrz+ciHxzTW3hrwYI9bozz8AcCEG4p/Qkwvr2uypFowGAIsgzJQol+7pOAi9S0KkGEO/NWJEzu4MorwX6i9IVhLwtJtu9HfbJCF8QpBeED+hI1Fo/OCXDfSXSOl4XB/LeYnIuXZn3VlMeBvrzsOhf+2MDdkYzYqPHHoI9WP9U8gYXq4XB+06ShoijzvQJ38xXeHUuTWjjcWfTq12KdYvXCeuYurZbGHZwurf0fNqKe3cnuo3tGS9IOOCHz1jnLtrU83IoYfc3cwX/JVz8foDl/SsmNYuhO33uFgU6ma/mO6LRPmINwSQIOo4+fEBYgtlwZhEh2cjI536lyuvUcyBg1hLh2zQHFsuHKKeAEc7M2QV9JjQjZTp6oS49B1d1SM+SfMhwFNqtOp4y+2uKqdvRdeU3bxLhJgWe3866S3SKzQNE/8ORLWHF7depBDz5MB79x+vzzLh5Su9GNlM0418FeOjnhqv/Dk1LUXM0S1NA7qP/w5ztVtVocHrHrXrfvjhebCjJf81FxQ2KXrstHF8opIcimMEhijDn4CSQYKXrPx/udkV8gLF
 736zIGVl
 b4PZ958z5ZotRO7oW/b0tzzQkiaSBtpavrDzhNA0XJWqbIWdHFLbHKOorkua3/iSqeos5PnTDBSzdBcj1SLvkYfH/Kd7+XvMtzoOLKE0ehVpPmxRz20k/frG/KD/JN3KeqSNC2c4H8aOns2o0YzbRIaaELEGIW7xehdueH9EmxQRLXu+fpGn+rkVado90S0Vr0huvBk3lLW94ywBPla8y+oozsUHc23lrG2emhoDDBDc2o5ThDHVlk9WRYlip/h76yMsbmcbE0v4siPER2YuTMmsJNeg8/bVNhyfTjGaag6HX5wZPcNnn2HiN55NITu7c2FScQc8hyNhl2t6BI/2oP8+AvjoYwUyJpuha
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

'filters' and 'list' fields of damon_probe are intended to be used by
only the DAMON core layer.  However, those are mistakenly not marked as
private.  Mark as private.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 6c3c7c75b6ca3..537e59bfd7072 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -775,12 +775,13 @@ struct damon_filter {
  * struct damon_probe - Data region attribute probe.
  *
  * @weight:	Relative priority of the attribute for this probe.
- * @filters:	Filters for assessing if a given region is for this probe.
- * @list:	Siblings list.
  */
 struct damon_probe {
 	unsigned int weight;
+/* private: */
+	/* Filters for assessing if a given region is for this probe. */
 	struct list_head filters;
+	/* Siblings list. */
 	struct list_head list;
 };
 
-- 
2.47.3

