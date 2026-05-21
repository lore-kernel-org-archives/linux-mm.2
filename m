Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2670CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:34:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 614876B00C0; Thu, 21 May 2026 10:34:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 598F46B00C3; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFDE6B00C1; Thu, 21 May 2026 10:34:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2B786B00BF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:40 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C6ACA1C1A57
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:40 +0000 (UTC)
X-FDA: 84791673120.05.553AE49
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2E1001C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:39 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQJ0siWs;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374079; a=rsa-sha256;
	cv=none;
	b=mtHoa2y9eAnx+EZWpi7iYQBZUCxRutcwE6miWlDfn9DL0obLA6i1zm3B9NxKJSQRysLxBb
	vQxe42pT5AwJ+T9HmNedgOYLgtlVSzyy1/TqyjnMrKHvBAMeai5QULvWZk+XGSAfT4WGJR
	bxWigDyFaIsvMb7HWl/sA6hjhA2d07c=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RQJ0siWs;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	b=MO0PDiNJvCdSdqE8lLWzCf3FfIp1sEvkFKh7GD1pN2zCOU0bFaCiPl+xGp+qNJaqeDa5bp
	o4hJhQTKbR6wxyw9MtvtToxYxoEqUIDeW1Z1+OSi7rNqpsR9LvMvPMZFF+RnljzZAX8AYF
	Efv7s82bz0EHLfkWgz79Y1LKDS/RwIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BC3FF60122
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 554841F00A3C;
	Thu, 21 May 2026 14:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374078;
	bh=CRNoWJlEPylYeAv7EKMrmhsVza1n4tj76p/bqvx4fJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQJ0siWssrYWvg/DGI5+vQwOu7nENn2+wcgZV/fjpbB4EuWj7PszjrEKwKbU3ibkT
	 /bvopnQnWIleF5nL8HOX0wGPRdtLSo0Vw05get+n+DV6yA9blh8EAIeBX2hXh8jGxw
	 P/Xi2iu9sgB0QpTZYh1ci1g6TD36vQD+bgR4l4Jol5dNKr4bDXLhbStD3lUGtGozMk
	 aCKFQ6LiqlYE3BA3j55pXTcmPmkikxvTfJzoq9hzX4vDk5DdImd+IO/w6FcSQZpK05
	 bHp+C1uYYFKRVasUmlTn9z2WPo73H73W+ASKXakuNWieK9buVSsw4+383suNdFwWFo
	 BdtXduN5bN1tA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 03/14] samples/damon/mtier: replace damon_add_region() with damon_set_regions()
Date: Thu, 21 May 2026 07:34:13 -0700
Message-ID: <20260521143428.83157-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E1001C0007
X-Rspamd-Server: rspam03
X-Stat-Signature: ch4suu8ux5jro1tuyqws695bhqqsrqzk
X-HE-Tag: 1779374079-779672
X-HE-Meta: U2FsdGVkX19QmAm0sARxFG38tB5gGBgFjWESSkP5X+zbcB9AAIJ31Xwt4ifd3RbqS1wTlK2xLTBUwDKWc8f0KkJ5OtQB0+9skCYGMmWkTgGa5xf9816+milCJ3ZTPWFpeowb+zI+QxpbI+ac6ofk6Msfyz3hD0gYjsWylcIOmUehESPA7HsYFJFyd6Cp4q8lUSp54dCAP7UwRPfV8FA9SLarV2iylopngNrklyhSWCbpNPrneJ4ZTeZj7NfW9nEq4CnA8wlTFRC+8LrLBH1ApxclE9WeTMHT3ge9YnyYD33Pl6hWdsdPJv82E1GenmfzrucrAfc/AD4YX7Z7/BhYY/wvJru32eRpOjzVMvR0jfpn47euRMUIANLNKC+KGuTmOgp4zbNfxdu0aNVBA3ogJXqh2/+30efkIjLaiFqW9B2px0RSh8lq7X/UnWoouap3CzmZgHRz7tSPemhor78+Sr2Q+jvbWYEG7D0V+s18oWzPH/7SpyMSzigCoPKgYaEGKJWfjijqGwHjjugBzLjUacI2Gp1nh7KjI8SXdYZ49Edb39GoWmN3WFNbr+s8P/2AuSknr6Hzn9AlNai3eqo4TJ10bUzlw/hxuuqPt3hjlEZzzbBDUK3KooKhb+ccFb3NgrErm3lGnbW2xu0twbBx/jtEN4dr8cqxwysXDgj3Br+5iQDpGey8Bvm+yjNqI6pzrcSQjrwHs6wHsVdQKpfuaVJFhhMmnRXj+Xufc9hB9lpfylkSlPnooy9SKdCucU7zVcmCdBdly8/QdUxtvjwlpp1R6FMb5RJEdx23MxI1CfAeBqgGBUlbAfAPUnknkYQjd7k4oOU1lO/ZNm6y6nEUKdKboBUzj24fYzu3eelrcqHa7hDqdEX4o3QukFe9DPlh+ETPCJgbK4OzJFpVFzfVXp2IMCIFQHNVL+yF8Ps1dP9mi2qkaKBCX963tEirsFHacMUT3kzvSDxqd9jZt6/
 w+Kd2Ujv
 x83/r68ZVEsOU9PyFATPuALqHaS9Jf+xwbN8anuJorG26zbluurftJuJXcJ4sf6jd8yGqyMLH5ni73avBnzr3HcjEuONo8VZWSXl+tRQ2do9z5leD9ts02lBhFFVJcojImbFGnLaSlTsUpdvTz3Auw2Ywzul0QltdyWgCzl1b4YuRyCEZLXIaQwe7maLPRMSBQ3uIfg/Rfgv19UfyFWUNAewOfojjUG5TIgF4sEHX5CNtTAnJnVAlGCWmhVKI1mOHHbRit0t7VxaBbA4HGubGVDXPS4WFs7CvBKDpfbTpji1U4CoDUddHelbuXeKfpcBpZFo30K45+AYepwiq+fs58C7QMdJucdaxgj9R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mtier DAMON sample module and DAMON virtual address operation set
(vaddr) unit tests are using damon_add_region() for setup of DAMON
monitoring target region boundaries setup.  But, damon_set_regions() is
designed for exactly the purpose.  All other DAMON API callers use the
function for the purpose.  Replace damon_add_region() usage in mtier
sample module with damon_set_regions(), for unifying the use case and
reducing the maintenance cost.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 samples/damon/mtier.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d935..eb1143de8df17 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -75,11 +75,11 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
-	struct damon_region *region;
 	struct damos *scheme;
 	struct damos_quota_goal *quota_goal;
 	struct damos_filter *filter;
 	struct region_range addr;
+	struct damon_addr_range range;
 	int ret;
 
 	ctx = damon_new_ctx();
@@ -120,10 +120,12 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 		addr.end = promote ? node1_end_addr : node0_end_addr;
 	}
 
-	region = damon_new_region(addr.start, addr.end);
-	if (!region)
+	range.start = addr.start;
+	range.end = addr.end;
+
+	ret = damon_set_regions(target, &range, 1, DAMON_MIN_REGION_SZ);
+	if (ret)
 		goto free_out;
-	damon_add_region(region, target);
 
 	scheme = damon_new_scheme(
 			/* access pattern */
-- 
2.47.3

