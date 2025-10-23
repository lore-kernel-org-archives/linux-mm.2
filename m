Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B63CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 628048E001E; Wed, 22 Oct 2025 21:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D8348E001D; Wed, 22 Oct 2025 21:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479198E001E; Wed, 22 Oct 2025 21:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3217C8E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:25:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 01F8C13BF7F
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:48 +0000 (UTC)
X-FDA: 84027637218.23.F8D299F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6EC7080018
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:25:47 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PEC19Zx5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761182747; a=rsa-sha256;
	cv=none;
	b=TNwJa8dRqWaQL/SlUp4lFN0KT0RfgG7TjuhfCiUyURRKh5emD7uIMiwJtSrAwlcomKKodP
	p75+kCBIzLObjqJXDkdwx+wIednekku4PsVxdEWrqnqnjw+rGy8Ihev8uOFh8ipQP2WpAV
	hQJYjE5uIvJDY4cxArjssJsUtNg8Euc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PEC19Zx5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761182747;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZdvapTStLn3r64HXvMiHpMTOtrAIVsZPEi105Cn0dL4=;
	b=SVwccq3aJi7AjxH9EyFfNp4CXrJE48YOEbJPBg8nEKo0moy+q0+kxCU1wyv743wUD6raAV
	LIS22L4dqDQn8jyED5nQxkbwiDV+UNkJG1TgQFR3bNolGIfOOi614OFM8ddXCfQJWgyv6y
	bi64V1Ac+xnwsZ9jbxWr/Znlpw/XWXs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED69E6156C;
	Thu, 23 Oct 2025 01:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E9DEC4CEF5;
	Thu, 23 Oct 2025 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761182746;
	bh=mizIUChAFsqpIHY6nU9Fx3Ot5p8OeQz4ge3WLnGs1IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PEC19Zx5pg5krCxzuGcALpzBIgJ6qxXP6/2C8Uf6glMamZ7D9BRYKj115ySio1fuf
	 L5wRsksk56d3RlbZEr/CGXziGLKEIglLy1r8XJz7BPIog3T9em2X7ycXDpkxA75XcX
	 TuG1/kuGVN1WH6pJZHLeRAMwoa5mMed1mKlhtRW1c67mhQXzS6Wyslzg7phVLJtTpa
	 FgVPQOwv8MTGvJYESIoeMPgl4vgVkE668l/Kptr7SZlfRsqGFhVA1yKwZLhRTO9wli
	 HDkQvHDkgF67ccEGcxs/hDFYlGZ9qbeAsYTDc9m+pxhLsG9msCwHGOlgGaXVNpQKJ4
	 E8BTvG3MYgalw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 9/9] selftests/damon/sysfs: add obsolete_target test
Date: Wed, 22 Oct 2025 18:25:33 -0700
Message-ID: <20251023012535.69625-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251023012535.69625-1-sj@kernel.org>
References: <20251023012535.69625-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6EC7080018
X-Stat-Signature: p38z9hy3p136t3tfsc1e1d43qaddwrhn
X-HE-Tag: 1761182747-646071
X-HE-Meta: U2FsdGVkX1+qI7wa1850IN2BgcW3uEGp7EXZsO32Vj+SMYb+OAlkNzhyXNwMPmWhzPiCO/LYoYL0UxxChivpmw5++/l72D70a10B5IxiJM80JphMjzYF9edIv12Bv0WUfHoyoW7K61NYQ2+H7CgYKosjVhPg7o22SNWCZK+i06EWGqVkAOSu6FDEYlOjdegRDk6lpXkVrI67WNtg2RhdhlODHsvCrDowA1yn5mRsfRHQ8LiUfymcg1Z7uRM5SBvXqybXz1HFizUxagERnpPsj7/4cx6E8YccmJlG1rLyGiZAs/j0xU/qkU1lRCYvx1iGFIMeKdBu2rO4AUr68MXB+XHm6dObWcHJ7CsSmHboyzpKvK+4YEBQFYlzDnumFH3V4n3B7td9SuLu4G1lMdj6uLVJczAaCMCgf/ZicQGwTjnNpDOcs+Ua42rZBFv5YVP49+KHXWqzF1BRi5LN3ps2Ct64FQpXWpDswHr+ic7X5PydpJMyGanaAGKZRBP49+3Shz5qmEqIftcIXxIAu6imZPB7wzH9SJdRcjhDm8CzvvNjJLRNGzOgsEOiLLz4g17kpJ4KxArg/GJb78DuW8SBPSsx+adqLSEsLMVkoZ+fxjpvc/VBYxxblkGatU8n077IQ0uangxpb5CvPILdnn7c0bjhAE6zRwf/lUMN8IyugUm9uSB052L7DA97eCt7EUo7D/bQGghkhLTvVSKc+1qvei03pUtziFeZmX56RuKP+0qZAFjv3DWFr1inn0s7Ze4nRwNPwn9sIzTwSiTBWZM9e5j9Y8ssVFwmAyux2h6DMm23EjnD7EK599Djqalq11ag66uMxFWYkNoDaB/e/meqAWoLrs55G17RY3qnARvB+bSGKC+BLohGLrMhiAxVCGf1t2RwUPRoHRpOVkbgNBPL1a3F36QimaSkaEkIMJYKz2LxkRwdO4no483D30amlSDH9JQU5hdU2jmv8cR0xCI
 IsaO4f+Q
 rX7tgq9YgRCYwMZiiO5wrLggL4y5q/Dvm08DFR+iJen5rtWmSX1WdCSIPjpdpNQAQp3jMROmYVmToAdWgzocYsFCofoR0VhTaSq89Pdv0nKbsG2Wub3/x+x6E2ECon2svQWpkMSf5i3c9RFEzjF/X8YMIojSoe6gRlk+k46BWdTlMmlblTnwvJsgtriC1hLZOe4HAWcHyURdTl6UdhLUCdzvc9qenvX9rF50NDkVh1dq3oVrCFpjlgflVa+yp9hbBHcHMmXwhRCVNZ0G2+B8zr9cV5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A new DAMON sysfs file for pin-point target removal, namely
obsolete_target, has been added.  Add a test for the functionality.  It
starts DAMON with three monitoring target processes, mark one in the
middle as obsolete, commit it, and confirm the internal DAMON status is
updated to remove the target in the middle.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 37 ++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index fd8d3698326e..b34aea0a6775 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -279,5 +279,42 @@ def main():
 
     kdamonds.stop()
 
+    # test obsolete_target.
+    proc1 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    proc2 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    proc3 = subprocess.Popen(['sh'], stdout=subprocess.PIPE,
+                             stderr=subprocess.PIPE)
+    kdamonds = _damon_sysfs.Kdamonds(
+            [_damon_sysfs.Kdamond(
+                contexts=[_damon_sysfs.DamonCtx(
+                    ops='vaddr',
+                    targets=[
+                        _damon_sysfs.DamonTarget(pid=proc1.pid),
+                        _damon_sysfs.DamonTarget(pid=proc2.pid),
+                        _damon_sysfs.DamonTarget(pid=proc3.pid),
+                        ],
+                    schemes=[_damon_sysfs.Damos()],
+                    )])])
+    err = kdamonds.start()
+    if err is not None:
+        print('kdamond start failed: %s' % err)
+        exit(1)
+    kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].commit()
+
+    status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+    if err is not None:
+        print(err)
+        kdamonds.stop()
+        exit(1)
+
+    del kdamonds.kdamonds[0].contexts[0].targets[1]
+
+    assert_ctxs_committed(kdamonds.kdamonds[0].contexts, status['contexts'])
+
+    kdamonds.stop()
+
 if __name__ == '__main__':
     main()
-- 
2.47.3

