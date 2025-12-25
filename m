Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D22D5E784B7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FC16B0095; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A63706B008A; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5566B0096; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E09C6B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A9F4C1632
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:52 +0000 (UTC)
X-FDA: 84256415544.05.6DEC3BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5D4F520010
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QnKOlKKP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766629850; a=rsa-sha256;
	cv=none;
	b=yNKB6m+S5UUMbr3Ack1RAIm99OGT66oYIypar8WD/WNicCz84cYp6nXxMbrd0ocvnKlc68
	1DGdkJ50Yuo6o+/z0igv1EzHRUWXRvYPUevbiRmDD3f/pJc2+MvQyArHhfuC/M8b9YrtiS
	T0poKkV94NsmBHEDHrZZWik64dJlmMg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QnKOlKKP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766629850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ToDv/1V3ozykzNjVh+P5Amg9sv4YVN/KDNTBQZDo/Pk=;
	b=4pn6CbjFoyDBBU/RJ3G43U7phcgLc6qiaLRQEvDgKyLKzRE2V0LR7ioS54/9YLrfYybia+
	v6/JiQ5QYDQy9/nwvA/cIwihkdhnZowBA5HZ1CAEAzFjGr1uwBGdMxjGUBLFWwAQsU3mn9
	7ByxOLYXuqs6U9Uh+VAE0t4evTlGBvc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8874A44376;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C8F5C19422;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766629849;
	bh=eAX9UEANbnhjK8d5CURObQKfqWquwN6z8606mMzlq4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnKOlKKPM/iXDA0ZpwIGk0cmg3wxuxetRyiKSYiUvLjRqQ1nPgtsBsSSnC17hv0HL
	 J+I9BF2EmigRhUqjDIoHO8sMY1R3TZGdK1/PeDFL6M3hmKKyQymrvDRXmdq2tyt/rg
	 +CVgPId/WRYPM1M+97LwmgRF9O8IbaosT5lCq6/ZKwCpLJQfjtulVf7pu+nie3e1es
	 VzgTQ26eoW7tbkbpAvtiv3isgZTUaFKmC8mYttzgip3DFLG1iZxmvsHXsoFTy+klS8
	 Xom+krn1o2Z9orbIIMg6AW5qwK9Wte89CX2mA7ewghLhwh7yAdRaxdM5PIZllA1ruZ
	 Neg9rtHU60SxA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/4] mm/damon/sysfs-scheme: cleanup quotas subdirs on scheme dir setup failure
Date: Wed, 24 Dec 2025 18:30:36 -0800
Message-ID: <20251225023043.18579-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225023043.18579-1-sj@kernel.org>
References: <20251225023043.18579-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5D4F520010
X-Rspamd-Server: rspam03
X-Stat-Signature: 7k5qf544qnks9hb43d4fpnpqgxf7k78a
X-Rspam-User: 
X-HE-Tag: 1766629850-11512
X-HE-Meta: U2FsdGVkX18eRuMaVHIuAIZhNCU52hJ6yTb8HNmtYCu5p1M0jGJdz5yY4QcYj/6k+TqLWPQXekdR1vI3JAaR7lxfFnpZoPrjDESboo9EbyB8AUaaZLuQJwxYuu8fV7XmTuWRN3m5EWKOOLg9XhJDHd2SQhlDhoLf7e561hkchPZy+mI/PRae2xNqmXTtNhwEPqerM8vLceIxaBS/K/JGtZvHK+/szdOlXHAT7ZOjXkTDhSsaCppQ9SIBvsy9fMroZP5/RhrsLWPGER+KKZhsindMiKsxVHtK2p2rf6s4HNbHynpfzhPXnlFi0sxOLDlkqAXTcGE7gXRyXpCaCSZVNyezJA1J/IaESTeqzP5nBAnzWuKjdtOoIyoUTilrivwBDpUM49FAL0kflBZvRGVBnov4HiW35XmEOoA6d1p2QoS1yOoOH6Ub+d4gIv488chUOgW0J6HzzQrfwCm3bpWhzjzk0OLRIa8d6Foc1axLwvKTVxeYc5vkhYV/BeeL69whYok4YwVdznwGDBx4joo6oX/FzgkfuhiLDJNDKr+JvhxE2B/h6GBU4UTvDAK/wAB2+qNkRxWB2v3LpZM7BdtmhLN2UrgjQMmAAFJB+Zk5qSQp3cQRgPVG9z9au/dQCdG+JmoVT9ps+DVrilIwJmO+/4PmmoQ0cvYd0cmX5QqNhW6b6PO/yF1JqExKcSk6+U1PLB7ZrtxmH6Mhyf8Tb3NmyRgOqQUWSqMTAr+6dDgvSRxmmWhmu8THtaheSJBJvdvfX+nOOrIFekZV5brgrAb2e/nGInjYUKJirM0VPRmxPZmhd0UBReM2yaIZGMrxkw9IDG43+9fyT5ZO1ivT8RqK53ww1MhMP148vDIPQb5FBtNHszZhKJg2XlejgG5SxWcySIlA1qfxkQuEPZWy2ACqMgdQ9XZsIfOW5O51s3KlSNmzHy0xmfRWM0Cw+CylJyngGYnJOBkTZanv5zRiahF
 0zh/Opyp
 Aw96D4UNMoUlmY3zcuLH9+mQVXbrdJe3mrFVLtID6tFXp6r4vV00iNxD/DTMLrE0//2chwkNGSj3t4emOFP+XHRNn1hKdHWSWJmQQAWtHvxdN7SXiEld2tJ9lMV2v1dEKK2lE9KSrzD3VDPaNxxRLqpfHIl7QJdow463tG0Phqkwn47RGE8s7Q6iemPsz7EozgN7RLvIZESTwqe0uJmgnIrCULERWsrSozPeL2xobbTwUMgE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
quotas/ directory, subdirectories of quotas/ directory are not cleaned
up. As a result, DAMON sysfs interface is nearly broken until the system
reboots, and the memory for the unremoved directory is leaked.

Cleanup the directories under such failures.

Fixes: 1b32234ab087 ("mm/damon/sysfs: support DAMOS watermarks")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index e198234f0763..7f14e0d3e7a0 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2199,7 +2199,7 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 		goto put_dests_out;
 	err = damon_sysfs_scheme_set_watermarks(scheme);
 	if (err)
-		goto put_quotas_access_pattern_out;
+		goto rmdir_put_quotas_access_pattern_out;
 	err = damos_sysfs_set_filter_dirs(scheme);
 	if (err)
 		goto put_watermarks_quotas_access_pattern_out;
@@ -2224,7 +2224,8 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 put_watermarks_quotas_access_pattern_out:
 	kobject_put(&scheme->watermarks->kobj);
 	scheme->watermarks = NULL;
-put_quotas_access_pattern_out:
+rmdir_put_quotas_access_pattern_out:
+	damon_sysfs_quotas_rm_dirs(scheme->quotas);
 	kobject_put(&scheme->quotas->kobj);
 	scheme->quotas = NULL;
 put_dests_out:
-- 
2.47.3

