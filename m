Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0442F31E22
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 14:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CBF76B0099; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 107186B009D; Thu,  9 Apr 2026 10:22:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F11BA6B009E; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D875A6B0099
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 10:22:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5F5D5C283D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:04 +0000 (UTC)
X-FDA: 84639231768.14.2C3E941
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id B495C40009
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lm5DwTkB;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775744522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=Oh1Ea6K+vjK3wTqHFtbfuqNh1bDA7si7HoATm8YlhmEB0NpS7kuFuIxIEa6nm+5EEuqn/8
	3LbfHKPRIL6jKHnGhTtW4ClfKntqqv7loSa7XLqg8Aj3CUiB4lixpxDjHPtAMuZTLsCPJF
	U5WzoTF20s5lHbwpDNbPysiM5eJL4m4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775744522; a=rsa-sha256;
	cv=none;
	b=Nsef5Mn8pcWe8V8aWBb60LPAB9EmcWDwDOAqhN0MKlwn46+ym0dvVM99zbmmZCGZwbSdM4
	mTyETpDp80Uqh3jv0iQc8Fs5Fv/oGYYDo41VZCc0IcI8JsUzbvRoOC6XqfnHBqwz7VJ8Yi
	fjO2yWrVW9IBrXy8XY4fPOAv6k7B6OE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lm5DwTkB;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED05B4452B
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9743BC4AF0C;
	Thu,  9 Apr 2026 14:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775744521;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lm5DwTkBgFBzKQYfPE6Add3IYFy3KBou/Z3K1gwtBLA5e3NIJlZ8YKlM5dSZXAWLw
	 p0ar57O/b3CHFdhDSiz9Tohz0IB/g0MaSJ/ZZy40+yyvca/7E0aMAVS+dVzTrRBs6S
	 U6Uqr7nX1bE/4nvVloKHOiZgJfVuvUL4AvpPUa0eL1qLhTS+nVt4CCWaG934vvFFu8
	 QK3OSAV1LqKeVNvPmgxgsyYacrJvD4bTlX0TtHec9OFHo3r7UJ1Orpu6wfwGuVQHBU
	 OVlshGb0ntCSs3wyBuOpbrp76y6japs5uRpJbOfc7XbdLYbMkLR+sxe5CkzBNBakGA
	 LHddvzFUJiu+w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 09/11] selftests/damon/_damon_sysfs: support failed region quota charge ratio
Date: Thu,  9 Apr 2026 07:21:44 -0700
Message-ID: <20260409142148.60652-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409142148.60652-1-sj@kernel.org>
References: <20260409142148.60652-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B495C40009
X-Stat-Signature: owuhsjtsf4re847cipnfs9y8t4yqu3kx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775744522-336324
X-HE-Meta: U2FsdGVkX1+UCrzjVuyclmfZ6GeN667fpE3Nr9qgXb2JJqczZ67NnpJoeuppyo3J88hXvm1A+2e9jDDj3G77fPDu5WqLw71S41L346wOFfr+/vvkpyXVP30enZBq0qAezZ/o1eFZHIELVjbxzc1LXEXRQkE9obBshQDM+oK9MiPlobP9EQOlgaN5c+z2uWoxTcCdSantM7PyfxLQTK7A7PympEvNCAeXgiGKLblDGvI/Xp9neV5cpWw/X5hfKsx70s3cMvyVteXvleD22gM2YqujbsqZIjrNbVsMJtoCdDjFpbnmxxbkM/driEarz28DEWIZ+H9ivSmgaG+F51PZSWVwhn1zR8qVo8MVS4yj8gUK140uXUzNMD8Jc02iqdjYDOo3LCnpOxcscUjlmGGs9LsKgRcxkSYPKrVTq9E+j7jfPz1JKJo0z7IjdItRFss2LjXHiUONv/xM9pz+1x7eq9IJIuhN9LP2zymuak+6bw5lF5/OKNWTli+SkJ21ogY10oESaumkXPdWzuzh+sCwoBVq/f0v7WWylYewhBQommMKQtBBgwL2EOdbfqbewR+rmLFuH4PCNnycJXTa6K8u3nznISbT4GaNFPhfjKT//SN99AQPStdiC+t2Mkf7cB6pMlFS3//hFjti2pbi1fWm4Fhco8JYHdGIiWNwVgdysG+nFuc6a6khR4cyATHvIJ8UQfIN6iWHa99pQG4CF6if5zsct8g3jL/fncOkj+4GiDcCYOEQfOroSuileSkPU7A2HpMT/P7cdSUneD+7Awm8clHtSlyS51LYs77juzC0gdAOm7vqsQRlcAFgdvTCxwY3gx8vdaYgDjipKAiFrzG9r5FmvaOQxOhQS5Re56yWmTCtW+CG3n9r31etevSNZU0wJMKC1E7Uh8Fege2WZL1L6uPtU/m/1n4U/k+Sq6X5kkdTHOijlTKh4n/5+KiluWrrosQNNZUvlll0+RsL+b8
 plg0ZpI5
 dlP5LzJYFy2Wzz0PwPCQH5E0WjS2LhXCyWn1xcERiU2tSDnj9wu1Ga6GZPDp3of1m6YtvcfW3CI1fKJYNm+TZjCsuYAcRXjtZtdaHElxbyRumg6d1A5V6nhAoN0rUAeH6O2I+5MUXcKmAyOEaL9L+9nJYcbaJ4V3cyDxvo9y+CBVo1p0mXHLRIiSYvp9y+/60iik3Ybd+PkVEDEw6ioKyR2l/YbotMztBrddcgmj3s8Zall+FPJEFHDm9Jv4dSxOD069HjrT3khETn0zzgKjJcrCJWE/DRf51GbzoQ9vDb9jt6kc3FqFd1U/AJbp9fvilFqhYaKG2rff3iLaI4BgidZEJl/9/s9JzDj25ps3OdzcjEpPJx4Ct75jECg==
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

