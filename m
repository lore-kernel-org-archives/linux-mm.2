Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 608E4CD13CF
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800CD8E001C; Wed, 12 Nov 2025 10:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73C628E0002; Wed, 12 Nov 2025 10:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B4C8E001C; Wed, 12 Nov 2025 10:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4240C8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:46 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 090F814052D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:46 +0000 (UTC)
X-FDA: 84102372732.26.382E4C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 442451C000D
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPituJcF;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cO/foAkB/68zSvBI1xEq6NGsOvJ7lPY59mZlpmM/OuM=;
	b=lehB1V9V2uLrSf5G2zvds9s6fDueC/wNlA7l+svE5wocVhw/hclipLaNX5dCXkB7ajg+Dh
	JNzsTMJBteq/OdNO4R24AIgGvhUiA4GMWSuKbXAYLlssMntJdMNPrGZp1hNxfedXgq9EZ2
	njAo9UaUN/xIlJioYFvDPRsCR51RIJw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962164; a=rsa-sha256;
	cv=none;
	b=cFT0IOClzFGQSv4oKwwhSaynDD71Om22f7ja0JP+qsOXUiNygOLXKYMhQVLhap1haFZ6FC
	rNhzf1GqLKmn0RaPkOluA03+u7J6hkwfSsn3/3zEbkBZdosG28BHdAgqDnFzutXQ2p6SB+
	bR1XcVB+vZ1iRpce0Z5a6zLauVB2lsQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KPituJcF;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EB7943C3C;
	Wed, 12 Nov 2025 15:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7079AC4CEF5;
	Wed, 12 Nov 2025 15:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962163;
	bh=ipqbHpurnSVvOIPX2qXsTqde4IbogP7c/9c05Brr93w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KPituJcFNSjD5P+6aPcagVN3PDZTIuLo6Chdee4DGXczD42xk/RYHpsFtOpSMPV2w
	 igC1fhqrXpXvYjeAZ5uX6tawwU1Vpm82tNw4zXOBvLP2r+j/kgv6VWOMuBZ37HH3j6
	 +HHSzHW56t9Af4AeL/NraNZ0QcK2yjWO6ORCouO+o8mlaW6wGjKnR2LEVF4E9Z/DK1
	 fv1fk43sm+4Fr6bzIw0/eWUO3rLsKpB7m+awnK52NgUfEoN1HmY3d+uYx6ndW57SlW
	 c/bHxyfZRAQvrKG5+Ya/V3B4kfOmCZ1jwG30ay6XjiegnhPYtlPmA8KbhaFKOm8xpv
	 eqEYcsuEhq7wQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 7/9] selftests/damon/sysfs.py: merge DAMON status dumping into commitment assertion
Date: Wed, 12 Nov 2025 07:41:10 -0800
Message-ID: <20251112154114.66053-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7hdn853swrhbjuyeyntdjbn5tturonak
X-Rspam-User: 
X-Rspamd-Queue-Id: 442451C000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1762962164-820763
X-HE-Meta: U2FsdGVkX18ZNsIM0kC2YYRHtbZ8mX8bzWIjfjkt00ywPiAzkCtswP69kqhm2ia9DFiztbSsIM/oUNteVQgfUQ/7rzTiW1F99jx1sWd8DiaL+Y5qUnJQ7wtr7142J/qbBa+E0m/XQ/jVD3q06AZJtGAX2WOmFKSPFlT5KTNZOMcS8sZNYcZihWA6SnGWJNBzmAoxZDE17zSFsfbNqkvG2FRV2LjDP3n6TB2VGo+ek1PXKRt9eOeHIst/8pYOoB+o79cIoJH7AMzXaMzLS53tCwEiJQ8LpaR8Z/t+KJaM2ks0+U3CE3LHGZL0OEPH4rfuAyxoo6D1DQDgTV03LD7cmx5FpILIrhaU5AwAksPmX3ut6XSW2epsRZC+7V8adVP3W68lt1NQ83d4MUfUxhvKQ4lUs7mBDRp7HtvO45HzuNtO7B8IOXsw0mSZ/rzeaNbG7KOJ8ZtV69NAFB2wVL+/kOFeFiDO95jDPX/XShq4c49rYwJBXOVN6b9ujAUP/SKxY8siUK0m2pIdAJZt0LwGjXUx6e//BxVuqnOVJsKu8EpdDdTRapMO+c0dsyblLOQDzxWLptXUSgYahKbZopXZuP9THe1hchk+lDp9Abi4GnfOIFbE4V9kwn6kyQZPUNSPcxo7BArfwIef8jCNCTMGAjXxzQrtk8cChzqSQ8AfF8+L98+1fgUZDeVep4hECQvoG/6DqOP5Xi9Q0/JdVf6G62JhnSbUbUs+HOyvG9PyvzT6LWwSQPPOLONdqarimnIkbPO/bNWJJOUppN4WC5nK7JTrBwfaV3gOWnJjqHd/S+i/X+8fb0BAlMIP58/mbWOgFC1YXhYfMt6IruWXygGJ+V9dbTrdIPjvSxBUCxCJgl4ulVtcagDQ9KZH5RgWHAdte2XAhKmxup2m3ygbobPUr9gb73oqUBEgbIK9NgJfQwF50a8xSO9xeJxEFQ13j8x6AtJdUrS2b6BWJfeSLjh
 avxvnGEK
 2ZF8lhSXhznoyojgryy6LbmFIgabCN8cT8OWWV8l9/wK5zzIhU32oVPw0NLFMeLil9tncf00e3bIru6N4Z+QBnyF48Pzhro8ewsdDXeKtW5Yb5C2pik7pzS6ZjepkACWkN6PP1ttKDlXP4e5NJKbYq92Dw6q67K3R6pnQKjNvv0ap2iJ+byYOcQ/Wfr4yBjNg8hzMP6scRT+GPLwBGFhsfTsQxTIK7OiGNGsfcOhbpP3oYtk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For each test case, sysfs.py makes changes to DAMON, dumps DAMON
internal status and asserts the expectation is met.  The dumping part
should be the same for all cases, so it is duplicated for each test
case.  Which means it is easy to make mistakes.  Actually a few of those
duplicates are not turning DAMON off in case of the dumping failure.  It
makes following selftests that need to turn DAMON on fails with -EBUSY.
Merge the status dumping into commitment assertion with proper dumping
failure handling, to deduplicate and avoid the unnecessary following
tests failures.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 43 ++++++++------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index b4c5ef5c4d69..9cca71eb0325 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -185,7 +185,15 @@ def assert_ctx_committed(ctx, dump):
     assert_monitoring_targets_committed(ctx.targets, dump['adaptive_targets'])
     assert_schemes_committed(ctx.schemes, dump['schemes'])
 
-def assert_ctxs_committed(ctxs, dump):
+def assert_ctxs_committed(kdamonds):
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        kdamonds.stop()
+        exit(1)
+
+    ctxs = kdamonds.kdamonds[0].contexts
+    dump = status['contexts']
     assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])
@@ -202,13 +210,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        kdamonds.stop()
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     context = _damon_sysfs.DamonCtx(
             monitoring_attrs=_damon_sysfs.DamonAttrs(
@@ -256,12 +258,7 @@ def main():
     kdamonds.kdamonds[0].contexts = [context]
     kdamonds.kdamonds[0].commit()
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     # test online commitment of minimum context.
     context = _damon_sysfs.DamonCtx()
@@ -270,12 +267,7 @@ def main():
     kdamonds.kdamonds[0].contexts = [context]
     kdamonds.kdamonds[0].commit()
 
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        exit(1)
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+    assert_ctxs_committed(kdamonds)
 
     kdamonds.stop()
 
@@ -303,17 +295,8 @@ def main():
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
     kdamonds.kdamonds[0].commit()
-
-    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print(err)
-        kdamonds.stop()
-        exit(1)
-
     del kdamonds.kdamonds[0].contexts[0].targets[1]
-
-    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
-
+    assert_ctxs_committed(kdamonds)
     kdamonds.stop()
 
 if __name__ == '__main__':
-- 
2.47.3

