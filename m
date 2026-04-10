Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A8B8F44874
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D45756B00BE; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5AC36B00BC; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E88E6B00BE; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 817406B00B5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:20:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 05A631405B0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:50 +0000 (UTC)
X-FDA: 84642857502.10.EAE25B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4913A180008
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3TTDrut;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775830849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5sVcF7zaH37u0tWHP3HtY1xH4X9u8i3KYqKvRqlaJEQ=;
	b=78KyXEy6bWaJ5RJk4NkXIXUkyJ/ZHQ9ygkSsW4SceU6ud9miOkI4OzHJVjoDyM3IaQ2zLO
	eEFasLyaJJGLCY8xld1qnm+SVztjlU0ASF0728mlYPNp5dtid+X1OS7WIZAEHi9rPlDUk+
	h+TBXFnuhKmU5IrZjThdzG77tEAjOyQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775830849; a=rsa-sha256;
	cv=none;
	b=b+gJDEXNdGbinsm05HuPwdGbEtdsroD6Vpew0VnSCxDTFyAR+Jq3Ga2APzdCQRYDmRcnDg
	OZM+gb9gopjtmi8CHHMYc0Ozlwm4wE+nReMCuIvIV2BLrviW+3NXLeDUAGaVxziL6Ef004
	A1Hm2sWHvztg6SLv279PR1eMUCnxmBM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H3TTDrut;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 69BF5445ED
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CB63C2BC87;
	Fri, 10 Apr 2026 14:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775830848;
	bh=EIRB4p0R7OQMpXCAySjtmt5LRqO984ojhpZfxIiXyb0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H3TTDrut21lQwelyoOsxr4x9Ax6qMNVkHfGGpdRnFUGPFmaIeguWdPUSjxh3us7jF
	 aITW0Gui7ZsPNc4f84EOsoepH14JiYzKza7bHKoXqdQ/W7G0TfFgScJjAuk+fRnhDb
	 Ke2k+LJrPwX+kLRZya44tN8KsWzp8ADaawjCxQg1APcDsl8Ukjw2ddsU2k/YRY4nCg
	 wvJ5mgEaS/HhCf8D1LXRSEp7D7lu2dxF+yXMMgAekt3k9v9cJUuC5sWcsjs1W9h5M3
	 JXNQL5LxFXUEnSg8PLKLTip+zjdDMoM9UtWmVzXjDk6sHv7cesXqo0GJ+b3v/5uFuS
	 /+HeFpCEwxEnw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5 09/11] selftests/damon/_damon_sysfs: support failed region quota charge ratio
Date: Fri, 10 Apr 2026 07:20:30 -0700
Message-ID: <20260410142034.83798-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410142034.83798-1-sj@kernel.org>
References: <20260410142034.83798-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: c86efo7bd4tubeqnyzkq9gummuigz7do
X-Rspamd-Queue-Id: 4913A180008
X-Rspam-User: 
X-HE-Tag: 1775830849-498397
X-HE-Meta: U2FsdGVkX1+jl6C3Pa71uAjJyREsNDMjaNOAO/w9QMl/Iook7C70oiR/8wZnS02n1oKTX894yWWre3EmDtaUPQ/4PekbwJ89zvTJwyApgLSKX0IdKuD+psQpva0eudrfZU/z4rLEqIvYvT2XSMqFAbb+QzNHbJtmtXUk7vupk+d8TEDNa7rUgr5xoRq4X9439e0r26domckSQRpSk8DgomaHKSgW9BZ1ohSeCdEcUjCGY+ODNovCySlDqNOWg/FKD7XNaA8H/dQXGzt8JmimfbHb2Q100d+gCpOBjDEiSSNq5gvaDKyxwpx5hBQmmvuR2QNTPqlAqqLdjemv8UQt4s1UfKYiLAScNOjVLB8EadfZmI3rlPchQNhWs+W34hntHAfeyW+z8g4XAPB9+fnqYNyWpD4E0KmdT5sC4CdL7MVSo23BZdzuQqJJZCefADoMnukM0AoGlpodV7+Bbmu730Y4hl11zL2m7pN7kJ5NsAvfTW0drarKlKQYx0UKJZcjhUJlWnWI2Y4DzV3uDFZooaJNX/kUMPUYFSB9QpS9xApad/ba2/UQVY5onhnxLkQx0kAt3VfEY4rqbF/ZaA+BKPgi2cCmSYgySfq0+RdjbPIHBzGNMOfKPeNR97tnnsTJYOn1QusLY4liEPWBgKK5lNCrZhJhDLQ8ANwDH7I4JnzJNQ7nBb+mZL+vMuCj+sKB9HzRRYFXMk0+DKZXkzKhO4Bt7LFKOacTAPb8BYdvZcX2K5WdTOI1E1Ltp7dq0XDmqgPX6AfRR8H9DG/LDVOd2WRGASw35qJ5DBgLknCQV4ETXd+zKyFtJcPkfsYzq5DK9y4Q5NKjEb2wq8u4oZ+ToIHpaE4RFu7y1+SpELdBHd6sZcRWyFPmKE2sg5rq/cyGpF0jZqKmqjDHfX7srfHQIvHxVFOHPdn5sN5BhzdQhaT2NkwZASbWnPzJ6AjxxgaqRvh39Y6HVoRCeVGP46M
 YujBHQlc
 Sgl3Hh+oIgN8XpZmFW3Sci66fhPednc+nDANSjRdcjvugbtDbs6FeuB+J13BpwhFG2ef2oAjqMMb1EF2zDFh3seFmv0SHKYIC/KMZW+l+mzSaDhNiqCXW9GdGTMMTklnG/1fJz9W4n1zA3MAxpL21gmH5JSoD7KGYShB4odZ9IwYmTi3tUk6wWj585hVSeWIk70npm2jWM0fvymgQQ+lX4Ny9jqSszUrAhmf3UTrJlRFDUzfVzSuE+ACo5oe93NYthxQEBabGqFWTFnNYjPMa28VaIe9yHxnVwq9NsrSd740D5DZM+zNWfwuqosJtkpwbDF1fqOi1ez4fi8seylh3cR8h2qKkXdT7OhbglsxotJmQNe11w7EiIpMYXw==
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

