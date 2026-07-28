Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50DD9C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04586B0095; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B65D66B0098; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2AC6B0099; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4286B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD536402B4
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
X-FDA: 85037054676.17.75F1B4C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 35AF240005
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjFRzyjd;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RY+XUIrZiXuiiU/vLhDSc4ARUS4lqpakXQtTFBEewHU=;
	b=PrOEoWP/rKEpavXmB9O08ak2i/SHvEIySny2OUkFVYt8W8vcdOocLmd9UK19SVZ7Y2wb9+
	vh0NfaNw3tQc3SqZk5gMHmeMdl05aTm9yoFDNjW+YdyxUE6EvdedOgt9EdZpfnO/+a63gZ
	Yrf7z/6wz3DlpFiftV/xtoZEb9LwzQw=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bjFRzyjd;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216497;
	b=zzciMneiJfNMC89XLUW0u8PUiDz3E+XnQlRx9LOvHMPzJNnLmS586XtVz2XtEk4Fglie58
	5RL1MOjM994GAh6moziJ5CxG2HbOV3AuzqIMACB4lxKj3fCwv9bjsNWjWhPtkG6AaFyGmg
	OTdVk9wcYjV63XlrfkEw1PCx9R+DTEE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5966243EC7;
	Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 193F21F00A3E;
	Tue, 28 Jul 2026 05:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216496;
	bh=RY+XUIrZiXuiiU/vLhDSc4ARUS4lqpakXQtTFBEewHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bjFRzyjdG5LHd5EUvFIoWNyN4kpPMaYO/ictZ42J3ZPo0TO1vRPw0Yqew/ntKVxOX
	 LvzObgtO+Zde+G93ldx7g/NRy2kBAhuz+PqC86HvXR6zHUNTxClVg+6v3Wq0VVQj5Z
	 ugyEAd5vsITgYsUnNJ/sn/s4ZpSjskb8JlX5lRvmOpHtuEe5h06urBHgZ707ysJDKL
	 F/MopnTA3ocJnG1V20vhexwkNusWFMJwVLFOSq5p+6yhH+IWVt5316SuGLglC+emMd
	 PoUNugxLt/HRZR03iK8U6ywXRobEi8/gv1jYtHg6KkgQDsXqLrESZabqbetnUB16AF
	 fKBp0p1JoNHyw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/10] mm/damon/core: use damon_nr_samples_per_aggr() for max merge threshold
Date: Mon, 27 Jul 2026 22:28:00 -0700
Message-ID: <20260728052811.192712-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 35AF240005
X-Stat-Signature: mww94wg6ieu7d9qctgstw4a7wpzj1pap
X-HE-Tag: 1785216497-162374
X-HE-Meta: U2FsdGVkX1//Qcf+IOF0iiF4X99Y9GV81VPZQhNlJtizYefUzv6SdLSv1GwZH272Qsr0Y3HwSRmL7xf1FwaVCMUsKvYsHaE2S3o9KCuHRpaAVqZcuwTDuhpOpI3t1Hjzgb+y4I2+y+679cRtAn/yGJnD4dvISydupBINqHyYeBl9CCUhZBBsl6jncASoCpJF2XEZSkAM3rPaVov1VzQ1thWbtoWdQRvVBHJh+V1FSlqx31YJe4ENVYrujAUy+SfNUfnZT3BBaX5zNXCe63FxcHTUMvgmsdCqk2qsv1L4nnytZMZC3neIEuuiE60D9vGmVPFtaDlH+D5zGAW2vmNbeXdcZhs9RxnqwbvCE+eNOYp2UfaG0oO2uDf5Slia19g/UolsJ6Y6JOU0YVEXqnIdZPj75Iax5vpvKFJ9p9bvDm8cTttRNf3AUG2A6pQH9HStth8igxb8qJlCu2ftYlhcwxWKw9DQw0MQuo1k9Jzr6xfGrmD4zbY6CJZ+M/Eteqv+GLfvi9HbzDhiBU73m4Mq7zd1d1CXpoWFkHygDI2zK2qiTtw+8vbS2CzyGcC+cJPGlmgpicbxnHIKx5SJAIs0VUHOUnSX5WoUGQgAk+O+X5CjUhm+IYKDdpolqYXtXhkx2fI7GnOHIIxQb4JXUXEMeLi16v25LllFz8URnE4kSycXLUHgkU/QPpPeB7lvijcQ2BDCLUiJq6F4LTOjmf/S90Ytty2Z2YPzhjAPhNQ1ptJOi+sYZyhip2hBxzRSFhA3vhrabp1hnja/yEsgrGiXZaQ3F/HlK+Mc8xlSIj5YcNnvEGSyD5Ph0wRha1opsPxceRyPVWxOxAxhUcKG1UYAX/ZOUynIZSJTfIWV8BIhGc7OXmCDxlu3yCyvJpxz2DIlVq/dWj9QEQWsPO9810zd2YLM9XtfwM/X+3mQUFUmt7wrufg/MpDAb0yv1NyN3DmyxJUXyxKA5CIITr0L+sA
 Nqs3Kz30
 9Zl9QViQu4bLRnFE9xSRVSHli2jUyt9dV4q6eexDCnkVVFuMAk3ctsjzGjuEFcdW7iJitV8vm/CDftGmBopTIhCvEJ3avvoFb0fQK/CTOoU0LBeqlQk6nZCSso1sTV56Ka0PSZd4s/FRa+GILawA3aS9QLGK5PlpVvKYQn8rmDwV9/M7/xg8HKE7Y2TRx3E0uGsh+KOoOjFTqrMTGd9fGRucXuz5eeXS3XOnKMMs8zvJRaBfvo7rIg7uS18/ahUGXXi87+5+dWD56Y/+IxqhiUp3qCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kdamond_merge_regions() open-codes max region merge threshold
calculation.  What it does is fundamentally the same as
damon_nr_samples_per_aggr() but missing a few corner cases.  The
unhandled corner cases should be rare and make only a negligible level
of monitoring results degradation.  But having the inconsistency could
increase future maintenance burden.  Use the dedicated function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f7c9b94b6436b..4169268d94416 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3470,8 +3470,7 @@ static void kdamond_merge_regions(struct damon_ctx *c, unsigned int threshold,
 	unsigned int max_thres;
 	bool count_age = true;
 
-	max_thres = c->attrs.aggr_interval /
-		(c->attrs.sample_interval ?  c->attrs.sample_interval : 1);
+	max_thres = damon_nr_samples_per_aggr(&c->attrs);
 	while (true) {
 		nr_regions = 0;
 		damon_for_each_target(t, c) {
-- 
2.47.3

