Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E48CFFB5173
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 01:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD5BA6B009D; Mon,  6 Apr 2026 21:05:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87426B009F; Mon,  6 Apr 2026 21:05:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9D476B00A0; Mon,  6 Apr 2026 21:05:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 971B36B009D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 21:05:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 576FFBA1E2
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:47 +0000 (UTC)
X-FDA: 84629967534.01.4F4636C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 76E5980002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FDwj2FTa;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FDwj2FTa;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775523945; a=rsa-sha256;
	cv=none;
	b=Wcs3LxK7qpi6tqYVamhX3jXHyT/glnVspQNKRawSPLz1A3bFQvE/Ly3qXPRqK2ojhciSjd
	kSkbW9MpGgw4uzLJiBe4nRDxmSNEYrZagLu7v3NIS84jE8Sdv1WTbDOA1yMDIPsEwER/LW
	neCsuP9D3dgGqINJjHQ/AIzm0De1m6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775523945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0QO0HMgZR6Q1HucKxNFx50+mXtq1QtftwQyXEIAQyxA=;
	b=i//HqQfCCDBggB9cXHeUITEPKJWeio320GeVBZtZ7/NirQmTluC/nC+5SSj6he5bM+ZtqF
	7GjhdijXZVid0JooKqMMoSW3PTV5Pt9ssePZXgALmW5usuQeazOLYa+Lr2+k3i04u+UDIG
	96ul3Gv51Dw34DuSLJK+DowWQC8RPm8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7846B446F8
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 01:05:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08754C19421;
	Tue,  7 Apr 2026 01:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775523944;
	bh=6J24o91UAsIJGEgFo2jYtnFEeYvJuiRUU82+7XJIPqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FDwj2FTacxl0kPuumeqvG7CuFJL1N/GOrzdwTpAV0y7ENCUyXq+huiFhSdO2rQv9W
	 YX57PY4xHgxYPi/2WbkX2UE7moPsQSF4r1dzErgfzjZhGc9Xr5WXZajGldx1g6kokb
	 dw0ZoFjNgDxG+pVnMdLPxYhv071lHdMU1pz1FcTXg+YO3eG3tnze44Yc6WZti5ca0H
	 WrU7mzF/+Sa6qAL31Y4LYLLKFpWmYnmdzoEfpEDmt027UKrd4NhKuEWFfILOUAojA1
	 vkrd2wRMnSn9YfE/T4walOiiYQaVkyLJ1kH34op1yuA5QLM4jlqQkJQ7kedl+KfHht
	 nU/sWnqvM4ewg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 10/10] selftests/damon/sysfs.py: test failed region quota charge ratio
Date: Mon,  6 Apr 2026 18:05:32 -0700
Message-ID: <20260407010536.83603-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260407010536.83603-1-sj@kernel.org>
References: <20260407010536.83603-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 76E5980002
X-Stat-Signature: u3gzxb4okmrzso8rbjyxbq6okwu6x3n7
X-Rspam-User: 
X-HE-Tag: 1775523945-974593
X-HE-Meta: U2FsdGVkX18beIotGrXwg2yZFEllzs5tlUiiKA8+oMoy+2Gl0I9CGYunHyg6pw5wzOjeEUxpUcZHDLp6S5MW51wlMMFgjn+dg6o/Yvf2oxPK7u0vT77zMaXMgh7bqkUgdCQBuBraC+0oSQdZforKZI08peK9VQ6NvOaNCRezMC0RJplK3rcTH1t6Ej4fXpRvuQVKfZ0ZVXPDPQj37SPTujAHjakwSDLVyB9kFXo/EpKy+ae2nHXV0cKJtuk0MHwL27/WnsA5FXyiMGc6MGUbeSlaAd5iaQganTWxMg/mIbIzsUMQLcIprh2EGDvJJx5nIHo35NVXn1Ygy7hWxHjM0+upDzZQILfMmsN9qajdxKt7dyEgVEpTWTTcF/HZSc7JIRfSt3Ky5sEh6Nk5xuXOhUFkv+8R0MClGkXAs782633L614euvGys7IF8XYdbw5PziAvPsFwxdZcNKZGcwVrqq3Hof8tB40RQy8pjChzgkQWQJBv8gZ4VqQWMbtl2oApSOi2Q7JhWaT6mLk7yeQBB0N2tY6Ort0jTf+8ec6+9iQ606VPWNXs2rs6ghZYgqCApU4UTaod9NOig9K+G0KyL5zWjH1mVjNGZyNIlmyp/1g3GN86IlfnkqgX35U8v8rxKqAu1tg/J/P7PgTGAO1J2TQ16+BlRVhiRZarDdriXmPoigVU72A99+l1cJpOm1ZaFbOADXPnnGasRgzZ1H1spGicUYgWGxgaxpVpwFW2YJXQAYqtXuhYInuGO883UrHUZyfmZ7hnxmxOQrJ9kv/5wBQqKg2SzjUV1SByHBKCiAFlx4WPKRVwMsvKXJ+o/aaNzZTF2FoDuSSNhs+A4iQOzqYXDJtneUnaWGBtzq+/8ZarcC2nY7DtIQzSg6E5MSbrM1H7c0fZnpiE0y3YUHtPYpeTCULumiltThPtsSnKFK5jxStQGYo3m762bBSPS4xBM9rd/YoYf5Uu/kN0hov
 ODXHZJrS
 HSirVHQVM1H6EN70fW3UPgwF1gcdRpR61d2a/U2LVgZCMkPswLx10zC/2uhQ6mFcM0BhP1Q2V3rKzoNq2epeHLDaDgtuenrOZ6dUnsRte61adekwmYZH9V6P+Pw6JkrmBIQhFLqLLV+jiGV0QJ14xRXGIO/5ao5ATDzs7rLQy7iFpjGsvQ8mhp5FAxFihcOeB0eXVG0VUVB1NrqQSWycGTIxF34QmZP1iId6gxPKqasJMoZSe1wMH+Ltw+IXPhVTk4PaDSbvzsmuVAyWYHVEvYF5u54Txcqvcu/6sl3OTdxajB5g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend sysfs.py DAMON selftest to setup DAMOS action failed region quota
charge ratio and assert the setup is made into DAMON internal state.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index b8d6e0f8fd906..d8d4717128898 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -73,6 +73,10 @@ def assert_quota_committed(quota, dump):
             }
     assert_true(dump['goal_tuner'] == tuner_val[quota.goal_tuner],
                 'goal_tuner', dump)
+    assert_true(dump['fail_charge_num'] == quota.fail_charge_num,
+                'fail_charge_num', dump)
+    assert_true(dump['fail_charge_denom'] == quota.fail_charge_denom,
+                'fail_charge_denom', dump)
     assert_true(dump['weight_sz'] == quota.weight_sz_permil, 'weight_sz', dump)
     assert_true(dump['weight_nr_accesses'] == quota.weight_nr_accesses_permil,
                 'weight_nr_accesses', dump)
@@ -277,6 +281,8 @@ def main():
                         nid=1)],
                     goal_tuner='temporal',
                     reset_interval_ms=1500,
+                    fail_charge_num=1,
+                    fail_charge_denom=4096,
                     weight_sz_permil=20,
                     weight_nr_accesses_permil=200,
                     weight_age_permil=1000),
-- 
2.47.3

