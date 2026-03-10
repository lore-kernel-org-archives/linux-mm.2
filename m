Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE6B7FCC9A6
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFAC56B0095; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4F876B0099; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7756F6B009F; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53D116B0095
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:05:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F23F1B7EC9
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:44 +0000 (UTC)
X-FDA: 84528361008.15.E267931
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id ADD4CA0004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:05:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hIfVawCJ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773104742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHwPv6zR+ZZKqcaQtbkA0Lsec+i3y2ii7X/pRVqEd4s=;
	b=M5Z/2gLOVc7/veOzbX6dSTvHZsiVVnnVcyJ7zF/fvQIGATr3tovP7zvzY0Sp1OWOmVn0RM
	s8n4fIfyvoosuKionQJS+1bP0uhI8RQqiqEW1epfn6gOkEKfdC5+6dSayV0S84a4grCuGv
	9nPIX3zbZ+mWM0ECg70kt6+SL1/QoG0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773104742; a=rsa-sha256;
	cv=none;
	b=ojbwBPKuW7HHSgJ2qRkmISd0TtRlOGIg+a1TJIJuJoRIrRsF03oLJz4gBAGQteevROXmY6
	wEWMNyieqI53PlHBT+A3EfC6bf1iXir+tNi5OR1AUlzjBATGpND333S9FMPjHZ9Zm8Mzkd
	qzMHoFQ98BoxpjVTHuixxNZgHnzzneU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hIfVawCJ;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 45E89441BB;
	Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A1CBC2BC9E;
	Tue, 10 Mar 2026 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773104741;
	bh=+HQX6Y6KyyaMrF3l90vkRlVOFR5aGGsrQWEn3/nSaHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hIfVawCJQa9bYg3f7JUHsBC/cPW2bdAnnuZpTLNWgt9P9RklDCFBYGMDfUdzC6G3V
	 5Q6H8vmJ5r/SXhNnueZA+Ey/nacn36kqUhS+83S5h3P0gCKdxYb5zNgPnb8G9s0Ro+
	 hkwLzCze0vumYA5pjIi2s/Jp1bCMlT5Fw2Upw6OuJZ8qVpIftBr96LBsgKqGqQr7GP
	 IvdSJKLYsM8VsSYj1FS9tsTVXKxisFssiekxS3kf4eJTse9g77xFLA50oQn1oeDbfZ
	 +eBa8bJMqIfcoJu5dsafmpwPdSiUn4mfAdE8X/gWSS5tX0s37m241rujWZyOr51eEE
	 Fa/SNDczfXaVQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 09/11] selftests/damon/_damon_sysfs: support goal_tuner setup
Date: Mon,  9 Mar 2026 18:05:25 -0700
Message-ID: <20260310010529.91162-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260310010529.91162-1-sj@kernel.org>
References: <20260310010529.91162-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADD4CA0004
X-Stat-Signature: 1iqi6hdhqeo3ccswqawxwzxepiq7ohxm
X-HE-Tag: 1773104742-289663
X-HE-Meta: U2FsdGVkX1+gbJpuVN2SxY4/TEpeLjjD6y6FH/36eUhZEfUY2H+0NVD9vKnjESvmf6ESEhTjvOfIsaCAa/ML7ND4xwRBooqhidDrnjXQ6bXRDH2eqyggmjKqdT9gvUr03gsHIWh4Qb7s4v2qgY6mrKL+oAI6x7W26XHaDVBxyACdmowsgaOk585zihGwSdkl0jQFZKP3xvkgI2Bi6ATvoGM/geaRul4jlYzj8TDfDzLmt+7Gq5wZNYn8eSbx1tXrDAC0fkixMWdIqxpqWiUvJLr0XPJYUEyaptKF97I/bapVLe2s6Va2bfRRFr0LCkjn6ICVmyhrDsmTfuL6i5yPKsxntpwo3yR4edI1aBZyi2ZKSfK552l8/Z3IftQKyazbUc7/tYerdAMmIaitTYx+qTqRDxaG9AqFqGt1oxG6A+XOtGzdd1xdHgoZYedH3b6Ucv5jA+69QLbzmPc3/9E20QD9NQhIWfRzPKieez6dEe8u013b3idnWhtToLJJbhth4CO1dbox4qUUmbmV68tKXxp9GiRtSoBT7UUcqAdkkef239iSCGXmeqcXFoHRGqqKLu5TWaH6An0IPK9/AOlIHkfh1lsKXQ8XfT27A9PKMFhPPmAqjoHePrdu/188NQEn5IRyjmPD2qGH4wC19FyPeO7GuiSsKoGrb0RE+zOnU/YySBRYdo4CiLyAA7lTampsbbvJImZUKW7Y1H26PVqdjU812iFvyAx8bJmOxnkqc7fws6e1K/at/fWYnRX8XUJNcE1xBQG0xKFqZ7tWzn2vHf1GVy3F2wTu/mMn0xy+oD5QFsPofFdB4agIpdJjkgGch/Gz+tdEzz1fqHeCbn6jpFBcqcm74SU2lLOmEOmk8Y38fxMK3LjZy0/WjA3vqrhjm07kYyNbWApfDNATwqJn1jZm7bs/GRcjyojBWblPGeTOPmw1N1hrso/tSJDZ/Thh6LO5jVTXWnenhlSlZTT
 crbVotae
 1UQ5E
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of goal_tuner setup to the test-purpose DAMON sysfs
interface control helper, _damon_sysfs.py.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 748778b563cd2..2b4df655d9fd0 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -130,15 +130,16 @@ class DamosQuota:
     sz = None                   # size quota, in bytes
     ms = None                   # time quota
     goals = None                # quota goals
+    goal_tuner = None           # quota goal tuner
     reset_interval_ms = None    # quota reset interval
     weight_sz_permil = None
     weight_nr_accesses_permil = None
     weight_age_permil = None
     scheme = None               # owner scheme
 
-    def __init__(self, sz=0, ms=0, goals=None, reset_interval_ms=0,
-                 weight_sz_permil=0, weight_nr_accesses_permil=0,
-                 weight_age_permil=0):
+    def __init__(self, sz=0, ms=0, goals=None, goal_tuner='consist',
+                 reset_interval_ms=0, weight_sz_permil=0,
+                 weight_nr_accesses_permil=0, weight_age_permil=0):
         self.sz = sz
         self.ms = ms
         self.reset_interval_ms = reset_interval_ms
@@ -146,6 +147,7 @@ class DamosQuota:
         self.weight_nr_accesses_permil = weight_nr_accesses_permil
         self.weight_age_permil = weight_age_permil
         self.goals = goals if goals is not None else []
+        self.goal_tuner = goal_tuner
         for idx, goal in enumerate(self.goals):
             goal.idx = idx
             goal.quota = self
@@ -191,6 +193,10 @@ class DamosQuota:
             err = goal.stage()
             if err is not None:
                 return err
+        err = write_file(
+                os.path.join(self.sysfs_dir(), 'goal_tuner'), self.goal_tuner)
+        if err is not None:
+            return err
         return None
 
 class DamosWatermarks:
-- 
2.47.3

