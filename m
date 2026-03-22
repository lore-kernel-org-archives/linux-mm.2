Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5387FC72A9
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 15:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE536B009B; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFE726B008A; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868F66B0098; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 666106B008A
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 11:57:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 370B91B8925
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:42 +0000 (UTC)
X-FDA: 84574154364.25.BE65E50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id A56804000C
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHJ2sj23;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774195060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mB4UoVanGjJ0b6Z/rtgw22+7a2ViKkbvDoer3Kj9isQ=;
	b=nkfjUMjEfCd8FvSDjxPL8zYB2+JAomePxMSxTD+Cmb7rhF2yD4d8rrP/X+VD+EtiExXJMA
	jTDVx7p/i3LtN7ObpIGqxsqj6BrPU6gSqW9FzEJ4ihXLmGukXTI9+PepEEDPc6fkItxIUD
	DRBIa6z3vtfE7tIshFG4uB2owgr0CME=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZHJ2sj23;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774195060; a=rsa-sha256;
	cv=none;
	b=e4wtJD7MNvfUhZ1DdFvXNU9dXPShe1fLmAQZITlHx0IpM7udjBSKkmphnpwU7mtlPqmMJN
	gCxItYGm2RAM1huHP5R4cQgqovYZmHCBNuxBY1SqqprDuc0CiqrtLHQ2em8Z6lXTEZdORk
	0Q2vF67+JKIhYeLg03ecoXpAokC9jCs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36B666012B
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 15:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E5EC2BC9E;
	Sun, 22 Mar 2026 15:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774195059;
	bh=TJXeffpmshBn5e3s77gk9ewA/YmV5afqYkZ0L4RsmNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZHJ2sj23DigXs7UNnB8scp4b1R5teRP/kfsRblrOXT7t1dgqcFt5alC5ubkPWIj4c
	 1sXN65f6+trlmBlZPz6r3+vsWsif5v4IZZYk8dB1FrdWpUEaiBfQTjxnhzANzUcZJP
	 0o9oVNsYVYpCYuRYJE5Ma5VSF4zVp42KoVIAM8gVr36aUdt8p02IaiOgpRZuPVx/oq
	 3g+otQEoBe5QZR2jDxEUN811UKlSXt/mW4UImEf0j5PWVkoUumF1b2F9cHoPzNYi0Z
	 bIl5ukJdyDPjmeA1WK2EFQWXz8uNJJq/BIo2YtN1h7ADYrZGcL93LQTTxFKCqHln88
	 6rSxrr2ZhZ+Cw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v4 07/10] selftests/damon/_damon_sysfs: support pause file staging
Date: Sun, 22 Mar 2026 08:57:21 -0700
Message-ID: <20260322155728.81434-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322155728.81434-1-sj@kernel.org>
References: <20260322155728.81434-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A56804000C
X-Stat-Signature: wzxjmoqn6ixzo7xcioxb5a9h9bbf97et
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1774195060-617750
X-HE-Meta: U2FsdGVkX1+RvwRaaVGlp8uKvaaIdXbt7KNfGhOKR15SCxrUYKllkC1vi3TSKvNDk0YDGDiio5S2hWWU0aIKt5639bAWikcvy8s8MMKukyoi8JzvR94x/gRcTMcj97VaH/NjTb1D1ng1nertGUrLKqpU9bXneUA4Aqp82iy1Q07TBRIVfrK2uPpVGmbyhaaymhTbCUHA4K5IA+oFbvfdi2XLw5ycIXlwKe2JOhFzVJyFxbM+gCDb/3IhSORb0eyIPmxyZ7JxLpv8NzLXIUAlnhFXNoMWCiBarBTnRDv1UyS7xIuP3PoqZsoh+Sz2HDlOkutv2XnUKS9f/r2IC10MADQO1tu5y9yip9OBvMuHm8vY/bPUjnOIATSbgak5rUHf6pXqT0VDjJqC/moXprNunbvWrxZ7yL7DFnAgmlDrb4lRD6T+G6UsItDiVJlDachFwMx4oLlH6Kk81DEjVEmpoqOMJ+d0e8aPl8FrcsphJE0TtuOpkT3p4MwReyiP+0A3AFDfhr7OZiJkQKke3oJ2QPlJYoeDD8Tx+YOMTEg5q+aTARuIEZZtYoM2Zr1SnkK8lTlblwIP+gUjFelmlCymcoCFs896q1MzBUz3J23mbuowTnmQoB4gR1v8LEA7tgWbUXssytaCk7G5c6NKirL5ZlN9A+A5ACKaIFN47qZOnExGZUXIGEo1AV07hcUfDQPP23dpAIizX3RWZMsZs/c9SgXuWM3az5Tf2k6Oy8ObUBMzSZxLmyk16jrSGO4q84CtjNZo/KrJnXyb+Sdm49u1UKzv41s5L5cAoGISE7cYo+EilQUNa3MIp765Dx+0m2Is/Tvldq0MWwEaDVPCawXKzaXYnJsumAk2MuqEjqyNxalwy5VgaXll0MvYQ7Fn+rLVEktvqmhu77NF++3Rg6cRf3kXib6CooyFIr8ToH/A/R3BXykQ9TVX4+R3mEDNr0BUjDdYD7Y6B+H/BcC1N03
 gIAV0EZ8
 5S7AAyWwkONvMMzXC8XaAQ03K+9XjaYJ6Tg//rs/KqmPKA/DGliLwPgxz7OclOE3i9A7AvZVm+ZB6Ig1uLR92JpnfzjSBNRFXLGzrWEDQvn9J8ZR046/OkEbMAkuw9iP9ToDY9JSvaV4dD8j5R2nynLsDn80dWJNrrBOI7ZCzOCulYAjFSEZyM9r7rSgunqtn8TgC0eQy1HU27d44fADfVKXm8Q4wXSq2OWbYSMTuIej7TL1W7VNVvY+SI1HnGOFiMkDVyBTYz5QBN1Aycbv8pG0daGcdS50mcrVSc8EdqP1t69zt8UJnbxixIoczqH6alYSSBpMjnzUXpRnXkLFR2uJ+hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON test-purpose sysfs interface control Python module, _damon_sysfs,
is not supporting the newly added pause file.  Add the support of the
file, for future test and use of the feature.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2b4df655d9fd0..120b96ecbd741 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -604,10 +604,11 @@ class DamonCtx:
     targets = None
     schemes = None
     kdamond = None
+    pause = None
     idx = None
 
     def __init__(self, ops='paddr', monitoring_attrs=DamonAttrs(), targets=[],
-            schemes=[]):
+            schemes=[], pause=False):
         self.ops = ops
         self.monitoring_attrs = monitoring_attrs
         self.monitoring_attrs.context = self
@@ -622,6 +623,8 @@ class DamonCtx:
             scheme.idx = idx
             scheme.context = self
 
+        self.pause=pause
+
     def sysfs_dir(self):
         return os.path.join(self.kdamond.sysfs_dir(), 'contexts',
                 '%d' % self.idx)
@@ -662,6 +665,11 @@ class DamonCtx:
             err = scheme.stage()
             if err is not None:
                 return err
+
+        err = write_file(os.path.join(self.sysfs_dir(), 'pause'), self.pause)
+        if err is not None:
+            return err
+
         return None
 
 class Kdamond:
-- 
2.47.3

