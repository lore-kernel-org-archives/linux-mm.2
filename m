Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13CD7CAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:35:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAF898E0001; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B696F8E001D; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00DE8E0001; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8BCBC8E001D
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:35:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 584841DF9F7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:25 +0000 (UTC)
X-FDA: 83893698210.09.25C9878
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id AD699140007
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:35:23 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dhCRJQQ8;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757993723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hswk5wq1NIfeFANemacMU0Qvk8VNAPgCDoUzECt/HlI=;
	b=eWUQUnKh45zcu0f4G6sqUYmLxFPGKf6PmK5YsZsDSdAv31ClPuw3dbtzXdcPkdX16OwofH
	kz2iWY1Q46Vs9biJ+85E+cifduM9d0XD5Ij9vmUAUAYmjlP+eUSeEztXJ7XVrwV0AT39rL
	qJ+bPkzbrVq2jQJxrIDPPzQF7djCPLM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dhCRJQQ8;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757993723; a=rsa-sha256;
	cv=none;
	b=bYTZmK2H0aNYAhSiVSHiY40OzBfOkyYpG3dWZO4GPuw5J3+wdxlVdi8c2pdNTv8cS4F8/2
	qRGeqsTDfXnBIVGtRJ3dk60Qe+DSnM/3pb76GuHu0mTHDcbf+EdYTvgBuDPaisb7/L5PoM
	7kmJlojYoAs7+wCOh+04ZUcyS9DLf5k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70EC644B14;
	Tue, 16 Sep 2025 03:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2818AC4CEF7;
	Tue, 16 Sep 2025 03:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757993723;
	bh=8oAmMgNUvcFWbF3KtriZccsEdzvp1RE+WJ1o1RTAqkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dhCRJQQ8QgGNEa5PQd5V6Jv0j+x3drr4a3j4gjBXGWjf0xXYigd/519UPcQLOemOs
	 V7ogujCxEc0LWVFzUMthyyjjM9Rbi4Dr5o7lHKFGQGGm+ZQDsG6PTRyGx4gNaFnF49
	 F4nQqtJZdmEwSNsNnyoUeH5VAfcS9+ZyKzrxkYXhdKmZ5HPR2XqUXn7VqQx91HF+3D
	 zicoTmUybUf1DPFOHe33KO7Nyag6zAy/JUgBeH+RAxcSK1Z0e0UIBOS0NBMSVZsb4o
	 ksfkyMu9Gw0NIFaYu9Yo9Ju5P6eQxgqE8bfWmYpycY4cUlTtAZM/eaKAwakH7z1YCQ
	 79hF+rrolVA5w==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] samples/damon/prcl: use damon_initialized()
Date: Mon, 15 Sep 2025 20:35:10 -0700
Message-Id: <20250916033511.116366-7-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916033511.116366-1-sj@kernel.org>
References: <20250916033511.116366-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AD699140007
X-Stat-Signature: h5xoka5mkiz9dyrmti34tfg75wab7cfr
X-HE-Tag: 1757993723-299730
X-HE-Meta: U2FsdGVkX19LN5121bt0cWTQEPG76X7fJc2CJUerlOsNAnxcKnFmJP0UlgzJxc9c1LxwbCtZ/v5YNK/LfATSROwCaU3klj19z1GEisqLnJ4gMk3cI8NSm24oA6Zde9WPml5OKn8AHPbO3VKRgAZWpcFA5soLh5zMFmdo6fMDBgQh7DhM3l1zkKt3e2NFroT0d7gbrd1orMKummD2DR0I+vh2QJzX7rd0ZSA3OUQKD6sAZQJbBdg2wULm0ERrKarOq9w17XhrfjhcIo2y8DsUmIqLoorT9SUmB7SqbPkJ8mxdgmGHCM3wDdibtYqNWY3OesSIYt8on/mrnbsZjEXdL8ckrIj2h4Xp9rmZKH8UWwCai5osVc/emLqkzkX63T8I6qq+r2v5gYRQ3I8298jM4bd+aoHCK9p57ynBHc+oZQ8nJ7IVDxvm+gYqeQPFoCAV7fp0GIrBicRQTWhhF4MWR4tpdDjYG6l5iSXjfgW3m+qSO3CcYIHwKPuZ4qZdQw/if4qbmUTy3cyjPAlOna9FP1iamqUPeTZoWeWzkBxYcVEg26+q5zZQ7uVFY9zhUyg/LtSuyZqqvBDrdyhMwUFugSsfAGO5peG7Wj3cruoEuq/OHGa9rPkQS1g0xYVDXSTB4Ue/XfjY7OjmCyWdGokB65UgXJIBNKCtQYaNTRI2ZhKGDtlB2eHrdLdpAtGcRtN5z1Rror6kNp6OGQcUxfy9I6brhC2TIPtBmriWOYjb7QOZfu0MCvm3gEA1SuOZquZkY43uhmE4ADf/l3xgMOxKduJviIvY2sywnQszjqXjKp3HbFLi2qd6aNuTCWyoQhkIJAtKZgmsf/XYTpHmcL1rWv/YuHHsj4yey3z0YR0MnDKsgA4cp6qFiEfLOBDX2WxNF3p3oSjzxeymrh4G3FsrjdBTCDMKQwrLYjG49/dyxqvTI5gmp1Ci3XX8hXHH4rmKBmNqwGvATnrRSjwc6Lz
 wmgD+gui
 aVgNcIbruzooltWHsm4biKlCycph7y+o6FGxA/wElJ512STE8c6I/i53ycLvsatwGHk3PZTmzEHLBfuSbdDMCbvcOU01zIF6MJBFT3OmFYrQ38mUbWX+BTrz3lehX8uVmDhLY010AXf4u28+6mkFJA6P2+uyXWJ7JYuHJmT/PxrmOFQV/R8hEz3tNL8h9xMMdmNR9oyE+hFLG1wHqrd1pw7svCP5gsAgIaJii/luADFXaluqyYEtnAlfpL5KiZ3dEtH+bKztJKjwCY1phd20SqRAhtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sample_prcl is assuming DAMON is ready to use in module_init time,
and uses its own hack to see if it is the time.  Use
damon_initialized(), which is a way for seeing if DAMON is ready to be
used that is more reliable and better to maintain instead of the hack.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/prcl.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/samples/damon/prcl.c b/samples/damon/prcl.c
index 0226652f94d5..b7c50f2656ce 100644
--- a/samples/damon/prcl.c
+++ b/samples/damon/prcl.c
@@ -122,8 +122,6 @@ static void damon_sample_prcl_stop(void)
 	}
 }
 
-static bool init_called;
-
 static int damon_sample_prcl_enable_store(
 		const char *val, const struct kernel_param *kp)
 {
@@ -137,7 +135,7 @@ static int damon_sample_prcl_enable_store(
 	if (enabled == is_enabled)
 		return 0;
 
-	if (!init_called)
+	if (!damon_initialized())
 		return 0;
 
 	if (enabled) {
@@ -154,7 +152,12 @@ static int __init damon_sample_prcl_init(void)
 {
 	int err = 0;
 
-	init_called = true;
+	if (!damon_initialized()) {
+		if (enabled)
+			enabled = false;
+		return -ENOMEM;
+	}
+
 	if (enabled) {
 		err = damon_sample_prcl_start();
 		if (err)
-- 
2.39.5

