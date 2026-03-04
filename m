Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68777EDEC04
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 04:41:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62516B0098; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B52F46B0093; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3AC6B0099; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 816406B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 23:41:32 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4267216040C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:32 +0000 (UTC)
X-FDA: 84507132024.06.C2C1291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id A02C480009
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jOANUg29;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772599290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PHwPv6zR+ZZKqcaQtbkA0Lsec+i3y2ii7X/pRVqEd4s=;
	b=ydl6RojaN7WdX5wSbokWOHbBwYIbegKPwIxDUId4J70RYyylX5SJSEAlkILOWmlrbi5uwS
	ytxT/6skqhRYc4CenU2zFyFlpJbBCBVmtP54prTi6zwfYZbw3XBMAvS0fww5bYAj728Jwf
	Lzg/HkaTfau+95dideh3ZuJjNChY7GA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772599290; a=rsa-sha256;
	cv=none;
	b=L/TFyTqgm62MFvWqsRMfsh4R2EgADcs1SL2aoSF47GMZjBpDtYz2MnHb4U0ZcuynK+6Ibl
	H1X4Wkw0LK6ziSuhEWhqrd9Yn4U7GI7qNK1EN+lMOu4+BUz6nEZFXOpyhu97xVUU9WUouC
	hJERj5OJFSjKOV2LeBsa9/cZY9OUNXc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jOANUg29;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 37D306057A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:41:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5FACC19423;
	Wed,  4 Mar 2026 04:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772599289;
	bh=+HQX6Y6KyyaMrF3l90vkRlVOFR5aGGsrQWEn3/nSaHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jOANUg29JEMAPQXfb4thilzOeD36TUkrZ81dBj5gH2D+LNQbIVWdhnWG5NHTwV0pZ
	 gG5GLW/GaATT0afiYCs/w1glhlFTps9RK/5ybhSFNVvFX0V5NViHW/ctN2HDu/Z2Aq
	 mtpPZ4/4ZZpbdqEi0YG/gxt3qLkkXLk4g+I6ehv1K+oeAGE55FuFmZnvH7/IxWptKF
	 G0C+VJ6uqiqehkVxHiXaUMwNJnLv5OF+d0cFcHtqjAwx6ZtX3d4NO946bS5hQDgall
	 mQYiEqdUxGwqtcN0JhOJlh4FYTk7WjklMh//kBC8zIx+bv9x73r2wIPIJ3BNRN85mZ
	 ZGAOB8wTvryUQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 08/10] selftests/damon/_damon_sysfs: support goal_tuner setup
Date: Tue,  3 Mar 2026 20:41:17 -0800
Message-ID: <20260304044122.79394-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304044122.79394-1-sj@kernel.org>
References: <20260304044122.79394-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nhq9zomhieuayy5xnwznns8ydfnu3qam
X-Rspam-User: 
X-Rspamd-Queue-Id: A02C480009
X-Rspamd-Server: rspam12
X-HE-Tag: 1772599290-586227
X-HE-Meta: U2FsdGVkX1+dneqNZI1293BP4y7y0OQZilxrN3qHMg/gD7dHTbeBu9ocErWhpTRtg+MJU/OQVYcdenIttVVuTbqXj1x6GbhlDFtcqgQWAq9cTiY2/pE0vRR8o2cX6rYYAt/VWtRININ/k0vOuMVEzQIadd19L5DkbsZD5hh7zu5+CLd08OS8z9korRxaGq9ntvQmAdcdyHWNoW4vlTCdVPWvvJC4tddsQiURt4VAPb0xX45St/CUtRZlFgRKDezxgaZPuG4y7PThulQvPDh8VuYxEsFjBRM8RpufzIenQWSXnwtp6lkClK7a/IY1cEjk8OElYqe2CAhbJqaNGfWpoZM47UIJEGL7aYUlPjcpHm4X4shgekq9SkURBohRs7hj6X7lkL+4I8gKXwrf6bpiCloImF/cPoG6vL7QWKSE9l6E0o9lR2RVM/oLPEGNGyt2u6g7WBSQvrt8i4PCp1jUnv5jWYLJQV5D4ntKpayDOXofH5BpmU/z89AH8WpluwkRKzwtu/xSvscZ8UOuzbJXDrdmH5fiwPey32kSA9UbYBKyZC8DK6DU0esmO1mXcS/JS5d0qTcA1M7lrT7/KnU5whqI1iO5/HZDNL7H5FQYpQNPeAl7lCnCLQieWzEeEznA+Y0LUxIIPNylPR8WUYJbZybHS+gNkvGmkb7c3pp/9AGDJ3Q3IRBlwREy9Ex50GsLdanI3igT+SqlNWflOvGPiJGcJH3xvzDwuemlBUeVY1wxAG4I8UIjSlEgXN/Y80PQdDGKv1XD1l2M1gX8CRTBipfciDOW+RZQbIZNH+YKeRo4Pz8SVNjN5CyuTQE8AIoqnBrOAZp/ew5GX/73D4qu73StrWBcwAF9Cu9me9iaiVWtVDDDjgkgGT/sSC0YsFB2sBmSGKeA1CxWG22mOypKT+s69JoxG4x4vYNL6ETIHIFIMBSA94kgtZ2NokhZ8Gx64hwJlAlkVDnTBJ30+B6
 RJZXmyxt
 aUmu/7aoNTSuETASkRU/YsXMVkQ1+BwVOwROAVi7K6AVmDGcvKgZZX6dGkR5/Z+bP39NeXmJ/LhDCJlLSjju4Jfcs13N9g5QCQwnaSCJzk7ANvMepFI6FlGuarLnW65U+MixHJj3+8Q95x8zpir6QSCJvcrAw7HkKiipi/7Zg+MhTwvOeIBDsk9SFmK0EHOFcl8G71MovdJnfbDb42MT3BazAMaMpILrFxGy6tlDiCN7qFX0d6aLaWEaOhYmHE83G78brrMYH4mErHssHEJNr7DfgOm17T2DahPLRBNh0QPcFVtb/JRwjUv6RO+Lc9KnDPwqJ1m2Bw4WRNg0qYUSF92KurANUIDMOlz1c5xFnU5fKHTT3qSYRKCgDCw==
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

