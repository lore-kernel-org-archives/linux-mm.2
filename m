Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09479CD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 13:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBC526B0088; Wed, 17 Jun 2026 09:56:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C452B6B008C; Wed, 17 Jun 2026 09:56:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5D636B0092; Wed, 17 Jun 2026 09:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB266B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 09:56:25 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E6F3B120430
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:24 +0000 (UTC)
X-FDA: 84889554288.04.5048360
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43C2A120009
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 13:56:23 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cyaCzHfc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781704583;
	b=Fwu7/r11Lm7DrlsEMEKNF2GpFfTbX3pUPo05aqP/2IF/O9F6UvUUSHsrKD3O49nz70Mu5h
	XZ+Yp6yDmRxHruEKVP6o6citqSBQHJgOwzwwQapBZlp5VrViHSttTN1JYifUIKA5HSPq5n
	sJB6w1G+0B20H9XN3gCfq8vUQU4rijU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cyaCzHfc;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781704583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=304b+5TS5ljtcCjsmfNo5OTxh/l/vWic2mRv4DwMcZo=;
	b=KELiDkBVfN2+jryX18j8nFFPb/V9U3S23GKEkyURWtt3Vz99UAheYStm4UUxgSvKbAGpQX
	rhenF3Ygyp2ULv3n/A45AAnzhEjHRdPXqtfbcW7v+ga+vEFn9604qaquGVOpdpMaf7aAt3
	8f7umkcTTx66uu3Qe/cPaEyDBSjP5tQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BC7440336;
	Wed, 17 Jun 2026 13:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07B221F00A3A;
	Wed, 17 Jun 2026 13:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781704582;
	bh=304b+5TS5ljtcCjsmfNo5OTxh/l/vWic2mRv4DwMcZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cyaCzHfccCxiNdLe9RwuNDoWcG9TM+7UWaC6wYL0c1SFkbRS4UyuJQy2Cs3jMTC1s
	 TAOZdr6l0aQ9pIklCP/5b0Dk4l14FOUV88uanExxYm3tCcuset00oZTlFHz9cVXjhA
	 PZQ+kIdT6QFyng+u2uMXcrMbK35KJrAJd8U+7/3t+bJal1MmgCAs+s3A2ls5t38QXj
	 UHnfuD+x+RmSpKJ2Lf6soL/VRP67qh0usSCddqbYs/C7KQS9I0xiR80w+feDAjeL6Y
	 goad0Y8ab9+bTfRRBBYqlvwj7GJ7eHNUPz6Kf9fyPtLCU3c0YWaO7ZR1R/++wMtw7q
	 9Jz7zyVfPAuaA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 1/2] mm/damon/sysfs-schemes: fix dir put orders in access_pattern_add_dirs()
Date: Wed, 17 Jun 2026 06:55:48 -0700
Message-ID: <20260617135551.86013-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260617135551.86013-1-sj@kernel.org>
References: <20260617135551.86013-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 43C2A120009
X-Stat-Signature: nwsog67ndkt7z96skm8k44un34psc9wo
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781704583-751566
X-HE-Meta: U2FsdGVkX1/x7N/JJr0eZZ5VciSYpfDEJGgxzLchVBfY/3eG8Nx/JlAYMlfDwS3kDjvcV5MqOJYnKLb+WzNoH8YjRJSCQxKO56q87E3nuPY4Aots+JQFFTPgzOZGDWs2mOSoLx2qkR1FR6EOdHb2E+2GPCRg06Ofec0sLJjVAxukjuMEyTLqzy+JtuLPfGNCbIYOE17oBfyIlmpKMNh10aFMegWV7VLMV0QoNmW33gxwAGskDCSVVItEUkOX3+f101r012lvdsSKlqQYqSnt/wrz3dJOCmNeBQTPoS7YP6kTohxMKqav0EGml3JO+6P3a0lo5vowb1HEbexxQtfHLJWi5hNpjLBmjDTU8Ym58QyDc8ZA/XPxKaZVDKqQygHakBh4tCCuTCEtkpvxLXFvHQr4kKh2gtug596/o6gxonGnWaLipdT5ssYpnTNGc0++v1kc+s1Sdc1Mcfa0QL4pH7CpjEOtgm0x5rDl97XE4WJU8WL3rMULd2z69H5QYQoRQ+Ls50v8tQa/Kejbvk8MAE4Y9jwIugo7bym5LkfDiZ78PKwpr6/1C/Pr+fzF4y/s/VS3rHeUgUzwqezqz4qBXCymc3aRTzHXxrDFYKEjpYRWQZYsKthcDCMkTlCRpOhvMq6rjrOjLC6zDMBCWOUw+rOE7MZ0/FKSFpx92Lb42LB3xM3NNf4OXPZGHvxhRoC1jCiTuTtBePpGvG1/faf7FgyQ6UXwi9uEPV+WmTmK9IuEfAlerg3MDlzMk8j0baHUUTscm2YLT7qJ5li7Q5pfxMK0u5NEdkQE1uzM5ZO1Pok2QSUBmXC4APm4/a5ZoROGivXX8CQ4tPJLO2QnPe7mv8WXYv/wKZLTk3kQ2WaWIntl4OlfLchsJ8IXRZD0cwui6WQPaamEzLVeP3FyXJqL2Dk8k8f/YlHosPcQqTJaOfz2hXDBoeC1s7qouZUpPyB+4Z5Wpff7n31Pnb8o+KS
 zMa9Mx8R
 9yCRjSLnhg6I4dm89yMkqTvS0rJFV3vsrufstgGLE3Dm4p5lnNMw7IkOITX84ItgMMzUrZEwmQCN4kX4UCAEZgfOIayEaJUIlxGjlfDtgeA//aLwqX0qsziwh4sYwHL3WXgNZtvUCWluJ0xXT6VEZcNqHu+ZFBvEpnQLd6Cn6kyixeindMDiCh9FA4SlnPt9eqkjigZXgp/BYtyeszTwj9bzKT+4WNg+PRfR6DG9ExmyR80iMViZDQLjGDkha3cD2PApiyMP5CeD7mVJuHlBx0XLU+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In access_pattern_add_dirs(), error handling path puts references
starting from setup failed directories.  If the failure happpened from
the initial allication in the setup functions, uninitialized memory
dereference happen.  The allocation failures will not commonly happen,
but the consequence is quite bad.  Fix the wrong reference put orders.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260617060005.86852-1-sj@kernel.org

Fixes: 7e84b1f8212a ("mm/damon/sysfs: support DAMON-based Operation Schemes")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 329cfd0bbe9f3..7c00aa78b2f50 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -1993,22 +1993,19 @@ static int damon_sysfs_access_pattern_add_dirs(
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->sz, "sz");
 	if (err)
-		goto put_sz_out;
+		return err;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->nr_accesses, "nr_accesses");
 	if (err)
-		goto put_nr_accesses_sz_out;
+		goto put_sz_out;
 
 	err = damon_sysfs_access_pattern_add_range_dir(access_pattern,
 			&access_pattern->age, "age");
 	if (err)
-		goto put_age_nr_accesses_sz_out;
+		goto put_nr_accesses_sz_out;
 	return 0;
 
-put_age_nr_accesses_sz_out:
-	kobject_put(&access_pattern->age->kobj);
-	access_pattern->age = NULL;
 put_nr_accesses_sz_out:
 	kobject_put(&access_pattern->nr_accesses->kobj);
 	access_pattern->nr_accesses = NULL;
-- 
2.47.3

