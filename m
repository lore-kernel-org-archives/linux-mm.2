Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD64DF3ED59
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890836B009D; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F34A6B00A0; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CF356B009E; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 42F296B009D
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E12E913BC86
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:32 +0000 (UTC)
X-FDA: 84646860984.07.68694D2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68FF8C0007
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a+1h9UwE;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=x022O0rJ5wejuPusQD99WqjniBvjAM/j6A6a/pxREET7SHLUTG9Cx8FAE8qqubCNyQy+SU
	JHuWrNIXkfrW0q28ttOofeRnAqf8jKDx12+/pHtWUvYb6s43SWiBPhWNpiO6+BdyzXQkLE
	v+qX0qUJ7NCXMstd8F0YHbw4q9gCJYc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a+1h9UwE;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926171; a=rsa-sha256;
	cv=none;
	b=Elf9h5k8+BImzpU28EtEtrdK11bx0/hNTTNad34oocv5UqquQR4k6exNX4zPjyHYU6mRsM
	fH+FtNpEWEDr6cdt77CEuhJODwnV6V5Tez+ZCG7AXPTQg/RA7DIkaDmwUlywGT5mscsdOi
	sjkrPrfT1M3NtV/EJwZU+qGbPrwJv28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE9DD6132F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50473C2BC87;
	Sat, 11 Apr 2026 16:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926170;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a+1h9UwEZaZS/LPsNopIbxUopaZwtYXF5cy6VF5yz/Pgd2MDcvXnWiuJ4RC2iarxy
	 msyBKMzITR7W4HjhpBDCgS+m9coNH5OrpkjFpLdYaBgogX0+jSFYWKHEC6dHxpCyct
	 xxOf0zvTjF4Owsd2/u++FG/pjc18Saq763HqQbf0ErieyrnBGx+SmmtaShumWFFAbZ
	 Zpy9K4QwX8nBqUEBGsLKsPc5pyZy1s2SlYlmr5oikfLXyVOhIUBS+AkYwIWEASPB7X
	 2eRX6NuJcbBk3vznlwN7/85hWDz3B5lwbv6YEorLlaVgRhQJdB70najlGv+gcQAcSE
	 xw5+nP8jKn/aA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 09/11] selftests/damon/_damon_sysfs: support failed region quota charge ratio
Date: Sat, 11 Apr 2026 09:49:02 -0700
Message-ID: <20260411164908.77189-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 68FF8C0007
X-Stat-Signature: fjdsnnjr7899o57b6d7czfbi3ji19x13
X-Rspam-User: 
X-HE-Tag: 1775926171-30954
X-HE-Meta: U2FsdGVkX19AwpKJO6CUMkS/bOzccMfaexfdc95+peEfdazz55kV5R4bJ+cnom/FaVeTPHeoINtvgqYR81Yac9U8e04JIS2VvJfuzfUesw6XoJAqY6BTu2X/kHY+fCWY1QKYasZk6AnEzq+x2XoT2BEY4Mn3I0OqDiZ1s/nRhcCe1FlEhi6Vb5PJ1UplT5ytgxqgJ0N5JACpNCffjzdD0UjI5DOO3XIRn/wHV61IMSHwKydokte1dOuR9d7aOXTsIim5FWd0eEy4Sq37Sqfeu2mZh7lqWabcawV4cc1ifNgatLT9YdDGpIrlX94ciiy8vovYObdHaJMhuYaRM1O29By1i555OwojvyOqH55EE1LkfaTSRP96Ht3edYqjEhY13IyyTcpFfyh0/f+bOpYqKDXmpQSTGxkWQgzfDC7IBXw3RXqg/c2YfnFtC6m1IhQBvXNkKWUdgzCInOeUbkwgLWYwr8KsyOR8lmWSANZ2S72bXuiw19Sl2/xADf07Xj4P9GUqpSYWPMpWtM9BmjKeORn2nGFdhAFUFA7ybMFp3z6Or7mNPcP45mxRqC6LuCAuZ359IF2+RCdW2rycUeKBCU2DGQd1321p4wsEMINvNOF5OaWDwNP3aSbIRvvks8TJGJuYZ5ByvwqpUExBdOStwStx3gNNeMQklvyA7vShKr+jVF34VYMvugGGEJaL/s0tlGp1Z5rm8fF/0lvAYdGRG47mG1lTtv/c4ZEGxDlBAVtXonYI/zKyBBzH51RANuqmSbm/h5KxWfjZb032G0JplD3IxS2ywv8jOEN1I/sBM748E3eb6ajpFUsCx3vbc3mgU7a3FwRCXRmqBYC7TP/lErsHDFI5KClGFEqGz8nAzccfqUMauLzI6Sh8NdswSYNdY2owErY6R/ywy1GGtcPxys4rcfs9xiELvhI2918BTfOAKI1pJKevxSVwJL5HTfnrYuR5YHJFlL4rRQyINIZ
 uR1+HR6H
 +bWe3vT1U1jhxVbXRB8GsvdSov5Jb+s1VONG4KtLi5YlO4UK8sU72tHPwQE0taM1C4qScq3nxXunzN8uaWxva+wIzanPvPJMj+/3ZoaS3R82pvv619UdaGKys43IjcyKO0/eInM2bpjCGy0kB4QtfYHHLEJxoj9utgmTQ9LbqXPRPCd7qc6ocI8KJ0xF0IdQI5P4KyiQUAbV1Qp7Pzq5VfMYZxwBjYXpUkoPv+yjV3K3gFBGJWExsfwRscdzlIG1zodsQufmHwwEBO1Gbm3En12InxwOrNZYx6wRPGweMvoCXWDaSnfnYBhDQPdbuj34liS20oJZ/CIXe8d0cQTt9jdVFGaOmfz01T8ZATU39/B2/tXV5q1WF3mhtrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend _damon_sysfs.py for DAMOS action failed regions quota charge
ratio setup, so that we can add kselftest for the new feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 21 +++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 120b96ecbd741..8b12cc0484405 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -132,14 +132,17 @@ class DamosQuota:
     goals = None                # quota goals
     goal_tuner = None           # quota goal tuner
     reset_interval_ms = None    # quota reset interval
+    fail_charge_num = None
+    fail_charge_denom = None
     weight_sz_permil = None
     weight_nr_accesses_permil = None
     weight_age_permil = None
     scheme = None               # owner scheme
 
     def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
-                 reset_interval_ms=0, weight_sz_permil=0,
-                 weight_nr_accesses_permil=0, weight_age_permil=0):
+                 reset_interval_ms=0, fail_charge_num=0, fail_charge_denom=0,
+                 weight_sz_permil=0, weight_nr_accesses_permil=0,
+                 weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
@@ -151,6 +154,8 @@ class DamosQuota:
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
             goal.quota = self
+        self.fail_charge_num = fail_charge_num
+        self.fail_charge_denom = fail_charge_denom
 
     def sysfs_dir(self):
         return os.path.join(self.scheme.sysfs_dir(), 'quotas')
@@ -197,6 +202,18 @@ class DamosQuota:
                 os.path.join(self.sysfs_dir(), 'goal_tuner'), self.goal_tuner)
         if err is not None:
             return err
+
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'fail_charge_num'),
+                self.fail_charge_num)
+        if err is not None:
+            return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'fail_charge_denom'),
+                self.fail_charge_denom)
+        if err is not None:
+            return err
+
         return None
 
 class DamosWatermarks:
-- 
2.47.3

