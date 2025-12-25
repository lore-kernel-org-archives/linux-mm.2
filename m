Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 888C1E784B7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 02:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CABA6B008C; Wed, 24 Dec 2025 21:30:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A7F6B0096; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B57BA6B008C; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6918F6B0093
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 21:30:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2649F1A051F
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:52 +0000 (UTC)
X-FDA: 84256415544.25.08BF73D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8B1F340004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:30:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cRWk/C6B";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766629850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=miSsJV4mLAsyaj2RF+XzVxGW6JPBJJWCb8IAHXanyuo=;
	b=SyVjKn5OoTzlVNSvFJcGwWWE/e/MI+VLoJpbmBSBgjswwD0IeVOe5yV5C+4txPmkyzbWrw
	oJDiuzjceoXrc8oUA//zhikWK05TFhjqp+jstOWUkIA9s69zOHxiPg7aGomAm+gCKH152b
	H9CK0CbBgPzce5SlWM5EC2FUwYBugs0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cRWk/C6B";
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766629850; a=rsa-sha256;
	cv=none;
	b=JSXKJZMiZanGsFaHPwGuK72dr4ayMLv3zWAJhVebJ1QSVgkssk8/7B3bLZBkp2VEUR8MgK
	a6fm58BpLXw4EYP6fC+X65rr9B9wk0lZQDIIRUBSI/XI9hHAR6u0/TuRD5KcT4D+k5iGy+
	1A7Vez2SdOnhz1cKbFmzXz3W6J/eP78=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCC9244324;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84BB6C116D0;
	Thu, 25 Dec 2025 02:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766629849;
	bh=Sx0CCPkN1ZKSx9TC6izh6KVTqV3LFSqvwNdLWbM+vgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cRWk/C6BM9l8y9MbU7j9gAiyc2ySgM/NtdR6845qDKPmniln4UXdTR8njdowCh4ul
	 1CJGNmOkJ0pJUhEYrlWgt3BcpL50u2tgAhzR3gahZtafU2sDQ8luDSj0tUpjLPLCur
	 2H9nJPleBXgUQOnrdPFlQgt82kVj5cfKYKKbdSh1FrJbWPtlFwWB5mIFc6X1Ze2IGe
	 X3zMlccmkKtz0acpwiqgQ1SUb0xjCM+867p6oZjrHi7XvFDkzoyokYWS4SMDapq0n7
	 syFda+EOT3rM+Dva8HDBypBVicEWurJLKYeUrsFsn0uJTXBxv0lqD6CcT9lCK+qSn5
	 ofxMjZNTvr2Pg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 18 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/4] mm/damon/sysfs-scheme: cleanup access_pattern subdirs on scheme dir setup failure
Date: Wed, 24 Dec 2025 18:30:37 -0800
Message-ID: <20251225023043.18579-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225023043.18579-1-sj@kernel.org>
References: <20251225023043.18579-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Stat-Signature: a3wbth5jm8admr8pdcyxr6e5ki6zmif8
X-Rspam-User: 
X-Rspamd-Queue-Id: 8B1F340004
X-HE-Tag: 1766629850-266119
X-HE-Meta: U2FsdGVkX1+s4d9P1/c1Df9ZZUpRYdxjEU1NU8tkqkJYNI8ZE+gdrYZHUKLDyU1MQaYRjECTMq6YP9WwmQXhx/5QWybyigbV5yLIGRGKawkYZIsv6ARQFkEfSKquvmRZBLYlCu8qxGiZq5Elhx/BZ/8v6mfZmJVSIMS/EZSzs+zsEmcljHJE306vfs/UOqMOuh2XzRC4K1KKDOzyjvp9W4nNDROksGLuNhQNV9nbOuP7QL40j1itoKnnmJS5dYsuLLYrXK8pR6ZT83op+Bvub8Y3HGVad3/eg6egUK7gKctDrgKdHEmo1JobWglVqSmjQijb1bx0UD+gSlayujo5DD+ZqdzGBsEX653MytdMbamYUzVxZRI11kE4Uq3dWuezmaeksjKd3u8IzmBTUX4DXCmnipcDe/F02YmZ6BBXFA8ZaRJ6Y3ELaZbxm2DcoCKTjsUerVZfhNi9CXuJWyBvJBw8JgH1I76a9OrRjRVLJikf1EcKFZp5nrCkysrhQ+WVNH2Ds/vAM3oK+2YXkqlOBGRHVBZS5Wabd/vxZ2d5gz9U78Ikz56dR4z2K8HgKd7sQqnn3zUxj+RWO8LES4KjxyME6hhvql3q2MVdIVoPSL3p1UIvcUDiLC4RRue2H3KEXD1A73mMX6cq6c2pIXSYxJ32185ceA1DnZnFuvQUb2Vuyh9Qx7cvVcq1jRX2FBPKQLAHxjgH5SceIxL/6OHbQBp8iHGfPam/TIiOZa73xnnAMVhwXt3pUeUJqrABXNUexSDfW0mb7XlDMFl37sV/xgysKaIvfRW1tRPrRrhYn0gqlUR5HL9VWZVEzHKNjlkOPUkKmfBsl7qhk/REcbvivUVwcPMgSN98XC3uoZ4e49lqYGqPiDy1y9tB0v64GLz5YO6o9DrDWfv8SlGz7x4N82nhJXdnsiPTm2c+g8SxytJTSWd0YrYNmh8zI+0QZIelw3j1vnDHkbAngDyfjJy
 NSnJsZpy
 XvcGY5MrNIMBwlf4DQ+p3/2pDrB6z/1dzUGssQsaL2gZGTn6sLlm48ZTud+SjfeC4Q9vqGHtbyvdpSAxgmar6Vrrh3tabp7OXDVqptRiUpUOeTUfEnTEe8PRy8KCnO6kITESJY/OuCJGtKZ00+U8ZrjC7e162/JJvsUIWlpfTCouMMSE6ni0LEjk8uUy1cWDDvjlqJXS6mqlXWVvQ9jmY2m5E3ucJNvpsfjav0EJjZUES+st6kWyWb4m5Vz4tEYbFq8PKSeDFtIjzi+JAl98aZbxCQA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a DAMOS-scheme DAMON sysfs directory setup fails after setup of
access_pattern/ directory, subdirectories of access_pattern/ directory
are not cleaned up. As a result, DAMON sysfs interface is nearly broken
until the system reboots, and the memory for the unremoved directory is
leaked.

Cleanup the directories under such failures.

Fixes: 9bbb820a5bd5 ("mm/damon/sysfs: support DAMOS quotas")
Cc: <stable@vger.kernel.org> # 5.18.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index 7f14e0d3e7a0..19bc2288cd68 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -2193,7 +2193,7 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 		return err;
 	err = damos_sysfs_set_dests(scheme);
 	if (err)
-		goto put_access_pattern_out;
+		goto rmdir_put_access_pattern_out;
 	err = damon_sysfs_scheme_set_quotas(scheme);
 	if (err)
 		goto put_dests_out;
@@ -2231,7 +2231,8 @@ static int damon_sysfs_scheme_add_dirs(struct damon_sysfs_scheme *scheme)
 put_dests_out:
 	kobject_put(&scheme->dests->kobj);
 	scheme->dests = NULL;
-put_access_pattern_out:
+rmdir_put_access_pattern_out:
+	damon_sysfs_access_pattern_rm_dirs(scheme->access_pattern);
 	kobject_put(&scheme->access_pattern->kobj);
 	scheme->access_pattern = NULL;
 	return err;
-- 
2.47.3

