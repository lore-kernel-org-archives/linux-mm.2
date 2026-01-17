Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8187AC9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 02:07:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795F16B008C; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6576B6B0093; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEB06B0098; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6E46B0096
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 21:07:43 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E02C913A546
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:42 +0000 (UTC)
X-FDA: 84339819564.10.0A71210
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 431192000B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 02:07:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="at9hip/N";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768615661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Txetnnwh467MHxBbg8E8iMsLLIibm/agKnmrYQ98EDA=;
	b=NtZf6g1yjOn80rk8SVFkyis8E+O7prBk5c4Yo/JfPXcKeHrvZuGFyNEWAYJNYMG+NOzUDD
	dDNnREXxAhmhSp/dRkJuXVsa/sIjxZOZ2hstZXIEm129hx4P4BkQv8QVXOJOK4wyO0I8cD
	xCipEUya+9++14s90w5Z+8z0rbcw2q0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="at9hip/N";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768615661; a=rsa-sha256;
	cv=none;
	b=bk/No2ycxi4vYORdI1ex7tTqiOlLNoyJcFxgQ1NPwW5zhjuxyWSNiaYsC0MPKZ3TOBBgm2
	y8XcVNJPn1jtBYiaU/6+ar1mKrNlFsqTSSMgeR1pFtjXUWJaOv48pBSi71iwGiPGIs0+B8
	cc5LyzkCu8IRkbBVZe0WkbzgVYyo/rA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 737CB444E8;
	Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E459C19425;
	Sat, 17 Jan 2026 02:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768615660;
	bh=CG7FIKN2uhUYlogFlECFQp/aiQrzKBqLzUq1oqqm9T4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=at9hip/NNgMK8XQXptqszZ0yNlLCCj33sTWAYLEG7gA86bgGbokQZ6kMguug4V2HD
	 0GLqeAdfMX4UfamKQb9liCDGMwge3QZmZ1JKHjfUADAXDmMi36bhwKB8dNgyI/j3gy
	 zjuYz8Keoai8fJLsezHOoK8HnZngvOhHl9gpJS8kllJ0USgEEnJnZvpZARkQrsPTI9
	 +UmhKqb7jXAiReAvDexmQCAVfRI6abg/0SAg86Xtn+xbkA/wYNO5v/LB9ywXymGOWf
	 DbZpGm5YCaZ4ioKXa5CcKDtWxO8WD5nmKK8HisOiLj9SOIvpZggL/3pweYE61B0xew
	 FE/g3vijElxvQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] selftests/damon/wss_estimation: deduplicate failed samples output
Date: Fri, 16 Jan 2026 18:07:28 -0800
Message-ID: <20260117020731.226785-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260117020731.226785-1-sj@kernel.org>
References: <20260117020731.226785-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 431192000B
X-Stat-Signature: jrbnbgn5abh7zeb9t4e89bhrpn6hj9cb
X-HE-Tag: 1768615661-383645
X-HE-Meta: U2FsdGVkX1/PpuyLbkU7MR1QAU+l7LEFQIchRD2l20A89QP9Ndm6n0529K3Kthm3pZ5wV9HkxgCJhq+5EFWSmhiUl8DqE754bXC9olv27pgFEFDw0jEdktG7a5DmHyO9eJjy9G5PtDE8S3C0n111XNztf1qVBNyb0bUcEusiEzGv41BnyERpn7COOdvqPSv5ISZ1ZAVRR6lBPbjP25K36Vl5KpUoiSTMGJj4VGSkaV1h9byA5xQVgRzcd2tYmQVJXpHEcjqilibDqKuO7NArZQFR5fWIaGAN9y4hzU4GOi7+Ck8ab4gleEzUGCGxJ4YGNdk0ONMMYH0WvqK866S/pTS5jDNeWE1fCkZuApkturBfSgoAnEOICyhFo/aamwprI18o9BmLNpKLYo1sL8ysIRpK9hhbiy6Iydt3lpjnYhkrheFqmf2CEevIo8m2u1I1gBNLHhuqjRxxgQikRqE+w4PSDeHMJognIB3HbH8whVwgInALGenobyP9iqF96V3YmI//RYr54SD5P6Mc60kaC1eDTd7IBDArMhEjAPpv8bNEEFg7y4E8NQynumRVsbrUz18sUqpWYeQUBrY9kPfko/FIQaQZdx60qdkqEMXorCO3bh/zSbV1VCijeIgcXxFIEuSObd9xffZk6tLe37jkYTWn6xl9dZ247YhyEgfzKzH8vtbeM0BDPlaIJHgcE3iD8MG7915QuL9zv1v0cD+Bh3510QkllP479vX5KxujGeZ7MwBK7JX7hsvvSO2Act8xmqtK2rXn+K/5LaJTYaHQqBTLfqE3kN/dFHSwIkiSFgLI4kmQKtDOrVMXry3wvfW1DaYA0HoiabtJFoWcVfk7nmBG2HM2BZwc3y4xns98n+m0Lj6yG5WRNntL86kLHaBC59sv7KG/9wEMVpzV7JocLIb5UfQuJ0Cy2o6UbmGuazz6GUk/XmL4OId1DKa2sW7drfYpQelOJQ5uH0m89HT
 beQ/ahmZ
 FWKAq45ZlNwBWrvXb9PImWaMM70ebOeHWyOS4yB3uTzMGYhGEQ8ePnoTjv5UyQWrSj57gxMW0AepZyky+4UIOjs6ZnBjtzVGV+zeBedAVGlJvuyZAq89Qs3peNbIioXy1v7cfsltJ1DTwY/5xYoisWLdhN4qJ6WSuG9mEw6/G1TkOnJ/gKPCAflNPd+nABJtnIlv6dTpuYfwJn8bqo0S5u5tfntXi2k8f6BUNGbzIB7VOduVu3TRu3pfJxwmrUJ3SepIGbMM/bUXWkJxWHPHneV4dQZOATSNeptQf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the test fails, it shows whole sampled working set size
measurements.  The purpose is showing the distribution of the measured
values, to let the tester know if it was just intermittent failure.
Multiple same values on the output are therefore unnecessary.  It was
not a big deal since the test was failing only once in the past.  But
the test can now fail multiple times with increased working set size,
until it passes or the working set size reaches a limit.  Hence the
noisy output can be quite long and annoying.  Print only the
deduplicated distribution information.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 .../sysfs_update_schemes_tried_regions_wss_estimation.py    | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
index cdccb9f0f855..35c724a63f6c 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -53,7 +53,11 @@ def pass_wss_estimation(sz_region):
             print('the error rate is not acceptable (> %f)' %
                     acceptable_error_rate)
             print('samples are as below')
-            print('\n'.join(['%d' % wss for wss in wss_collected]))
+            for idx, wss in enumerate(wss_collected):
+                if idx < len(wss_collected) - 1 and \
+                        wss_collected[idx + 1] == wss:
+                    continue
+                print('%d/%d: %d' % (idx, len(wss_collected), wss))
             return False
     return True
 
-- 
2.47.3

