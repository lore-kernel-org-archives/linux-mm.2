Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 305D3F30283
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 21:00:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974BA6B00DB; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 956A76B00DF; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AFAD6B00E0; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4CC5E6B00DF
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 17:00:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 20EF51D6A4
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:29 +0000 (UTC)
X-FDA: 84549515778.30.94CA168
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6BF771C0005
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0QI5i7o;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773608427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wt9zZl8x41QYNd+HY/AadpE4LhwKY8jzEPrlFy8nMO8=;
	b=CF8UawL8CQlhWg0IkWLvqhmnWSBMlGKcZi0V96caY1TQKDurpoibYpdkgMIap/AB7r/0gM
	b5Ol1OgtfyCxzLGVzvQVUvrvnAFSUQGqkjiT6mG6t/081hAT0uCmP3fSWeCAZNnOjwVmYt
	VrtydqLPlBbaTHlXAI8yAhdTQPjYcVg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u0QI5i7o;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773608427; a=rsa-sha256;
	cv=none;
	b=HqpTaAXbG4fb7wbIzMmQzgNTa3EL+Nouth52ES3Dfqg8pqKihMaebaGERrpVJWmOV3P9Zx
	CvUcZTgihll3WJQj9HKvUyroHC0lCIqK/pUZWZuyR8Dsg8yZtNJpgCZXXZS06pNBa/Srr/
	SBpbH7hSWRQCuINkAlU5OmUTB7nvUxI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB1D04444F
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB63C19421;
	Sun, 15 Mar 2026 21:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773608425;
	bh=FkncVS2Azn3cp8UsK6No3qAma6g06Iasldq/cgtIdxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u0QI5i7okhqAuIuYc+m4ZHOfluiK16mEvCAMEVk6y7bf9Et5R2oufxpLOHO3aH2C4
	 7CQlyof6w4qpYd6u1hStj6eOvzYvr0cFTsCPW8D5kILIhpYIwEibhBe2hSgy+L3S5J
	 1rlnJ6FhBdfkOfXs9oCyElr8Bb6PMBWXY3LkKnNUd3MFJcYMyIowX116pfPT0NxtMT
	 arbLxE99eeSc6KS1aRrPmeUhZBcGATb/peeCxZA8nRFqCLBM+8qwta9JD9ooPhgzeH
	 JYg6jrr2wA7XD7biLr21QIft+Ew62TmVBmlDUlTa2K/0GhaOir9uDmue40n5Kz6h3J
	 E2pSmsHnzVYtw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sun, 15 Mar 2026 14:00:09 -0700
Message-ID: <20260315210012.94846-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260315210012.94846-1-sj@kernel.org>
References: <20260315210012.94846-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sbsoyppenwru9dmejcwy95faycgigu54
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BF771C0005
X-HE-Tag: 1773608427-388667
X-HE-Meta: U2FsdGVkX1/x7o5lrChY2ZEVXc6dkQGCBcR+zAqFfhhlYZ9Mge/Rv6f0CXHRdVrdlceE08C9bAMrcGzHDCOKPHoyCUz3TcESRZWdBU/ryxY7MEfdSoM7ZLzeII+mksGnzuyFGIJRVSfQuD908YiIiuw8sWz0dB3gOjX4mYog47X0HRTxaW+wTqBsz/FDF0QgDIPV3oUC3llaacqmgMV3uqAevhMF9hPxODJVaPRM41DFx30LMGdz/7cG2oAgVWMTDCJ79Drfj2bCjDYxTfV36QldJyXtc0VG3N3K+eQneWU6KHJdAtYgElwzWyJlT9ceBFtnd+zsc/f+LVMAE17eMUZ5P45dyxB6cKfRsD/1eNsSniL6qZ6dJfJnO1dOwVy5MSRn3NEnWWMweq56MS8uQUgoIi0cf8XC4KZxs5ytSs6ztTyG8fe/soJBnf+Vnp/zvYdvADlsgBAr0hvuJlbu1ySnxSXJqHyzHE7UULPHL1RSn1dWfYB7IaqEfN/dED4ymuzWoSkHvQSx3pYdJYotBsJJTZxkrkPBQlGVKRHCIvgNrbBRqCRFrBoxgpeUQQ276+eO8bSMGlP3ShfRo/dgnGd83bP1clBibd7Lh1aR8iDXF2Bmh3A4YipWbUsRk1BhpQC3jlDuD3I8h2/Y1QPQ+RDTqINh+Emq08FWxGC43/DmrOhjWwOX06rWD6elgWq+w3B4pkjKXyAfnsGfMrarrI/Oh33bEmVZptVu+Uk4jkWs+HJ/AY/qcbcJDudanNBUrkqR/ANjGyGvVNAOkQsJqosgvlrGkCtTXO3xnbt6DOz0ZIXDyPtlYdYMl1Y6LfDzPeaD2LC5LyW5KhK7k0JXQMTQqNBDAdASieCLDrccGj10lw9wooeTpIlupoYDlx0p7dB87W0+XkzWo6p/WOLsI+0uLAvUEY/zqQ6rOsjmq1tSJbYRAOs+RxfzPU/seTXYW8Dl6Iunq85rtEL51xd
 A5Ha18YY
 wiM83UPEvuvHSXt3iwNaVVSZaz0uIYRkAz5ibp65y3/YcvrJiNWXUzUEyQAYD3XBlAHu0a15w3NBQ2yPO01sIS42EDdq1un0TOzYzWNd6XogwIb6QlkVcl1kW/psZRHqYBJShrnPHcf56HIW/U7iBy0GwG9jmV9Ygx3j1JNrzl5cKFz2dB1YVJA0WtER89C+XmS2w8PwFhdA9P7Pn9rpEfJ+pUlMmRJVS9T2DTZfPZ6VAVJIgIcAP1ld4wia+/4MO1NqZz8AzQ2Mxfy2cG0rfnlgNk6X2yFPAm5EjHkgcCquufZ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sysfs.py test commits DAMON parameters, dump the internal DAMON
state, and show if the parameters are committed as expected using the
dumped state.  While the dumping is ongoing, DAMON is alive.  It can
make internal changes including addition and removal of regions.  It can
therefore make a race that can result in false test results.  Pause
DAMON execution during the state dumping to avoid such races.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.py | 27 ++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index e6d34ba05893f..a1a29f1a7c27b 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -193,18 +193,44 @@ def assert_ctx_committed(ctx, dump):
     assert_true(dump['pause'] == ctx.pause, 'pause', dump)
 
 def assert_ctxs_committed(kdamonds):
+    paused_for_dump = False
+    if kdamonds.kdamonds[0].contexts[0].pause is False:
+        kdamonds.kdamonds[0].contexts[0].pause = True
+        err = kdamonds.kdamonds[0].commit()
+        if err is not None:
+            print('pause fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)
+        paused_for_dump = True
+
     status, err = dump_damon_status_dict(kdamonds.kdamonds[0].pid)
     if err is not None:
         print(err)
         kdamonds.stop()
         exit(1)
 
+    if paused_for_dump:
+        # resume
+        kdamonds.kdamonds[0].contexts[0].pause = False
+        err = kdamonds.kdamonds[0].commit()
+        if err is not None:
+            print('resume fail (%s)' % err)
+            kdamonds.stop()
+            exit(1)
+
+        # restore for comparison
+        kdamonds.kdamonds[0].contexts[0].pause = True
+
     ctxs = kdamonds.kdamonds[0].contexts
     dump = status['contexts']
     assert_true(len(ctxs) == len(dump), 'ctxs length', dump)
     for idx, ctx in enumerate(ctxs):
         assert_ctx_committed(ctx, dump[idx])
 
+    if paused_for_dump:
+        # restore for the caller
+        kdamonds.kdamonds[0].contexts[0].pause = False
+
 def main():
     kdamonds = _damon_sysfs.Kdamonds(
             [_damon_sysfs.Kdamond(
@@ -302,6 +328,7 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
     kdamonds.kdamonds[0].contexts[0].targets[1].obsolete = True
+    kdamonds.kdamonds[0].contexts[0].pause = True
     kdamonds.kdamonds[0].commit()
     del kdamonds.kdamonds[0].contexts[0].targets[1]
     assert_ctxs_committed(kdamonds)
-- 
2.47.3

