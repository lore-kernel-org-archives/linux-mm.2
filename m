Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A122AC79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 12:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BD46B009B; Mon,  7 Sep 2026 08:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861C46B009D; Mon,  7 Sep 2026 08:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2526B00A0; Mon,  7 Sep 2026 08:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5B80A6B009B
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:35:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ECCEDA015D
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:35:47 +0000 (UTC)
X-FDA: 85186912734.18.CB88BBA
Received: from mta1.migadu.com (out-80.mta1.migadu.com [95.215.58.80])
	by imf09.hostedemail.com (Postfix) with ESMTP id F39E5140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:35:45 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBQX+QH7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.80 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788784546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JP7nF9i160kxxE3MRxFfbsP0OJMmmpzbYtWlr6yNcaU=;
	b=sQZSml+znJYB/XEAnGKRy8U+2tIgeAPq6Fk8LYwE72kvJT45WwFgwlLzdCcvjksvx3VGui
	eiZ02yAO1rarZZxBMr4LObuVAMEe/B3ldm4LupY9LSh3WDkiDZ/PmzkZ0lPj6aLqklQL+P
	91QJjzyQNuJrUuzJYBAOXIGEwUJOJzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788784546;
	b=cVFOyrNkrEpYdMGyNEGfhkm+XrJtkiCk3yk1iyIBmUTV31a8RcTGX5JVZfksg6qIYrcMhA
	tW6a72OT7dAJAXqHz0HMlBJCbD5n+2QGJeiUpEE9gUt+YrrtZ8bB1yYiudKgp5Z3TIVkNj
	cBYPVitS47lZs12vODNm84M+e6tNyoU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DBQX+QH7;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf09.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.80 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=9Vrwldiu86hCVdvrUFji2IlPOad8eDYhb/cvDGNbV4A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788784544; v=1; x=1789389344;
 b=DBQX+QH7zQpma/UCQFvjTdmmPcxt8V57ttCL0RJyfnc7GqZBlV/UklnADLlT07qcu0D5BzIb
 G+gaT+aRNOH3yy5rQu9F3XgdTJXD6rmcB/Br/0A7H4M3I8P1t2Ow2jyQOHl36VhLBMmCyQJBFJ4
 aE4uLIT+S8SptxUApezlOScE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 83939cb49fa7006e;
	Mon, 07 Sep 2026 12:35:31 +0000
X-Mizu-Trace-ID: 83939cb49fa7006e
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: sj@kernel.org,
	shuah@kernel.org,
	akpm@linux-foundation.org,
	ekffu200098@gmail.com,
	"Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>
Subject: [PATCH] selftests/damon: stop kdamond on error exits of no-op commit test
Date: Mon,  7 Sep 2026 20:34:55 +0800
Message-ID: <20260907123455.67246-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F39E5140008
X-Stat-Signature: io4nue5uctqrto64fmfx6ngyfysh11gm
X-Rspam-User: 
X-HE-Tag: 1788784545-153859
X-HE-Meta: U2FsdGVkX1+uUBoDorxwnRxo5ewicDm0WxcV4JIcr1MtmAO554hENDO4Y90n4JK5Kbgmg7gtkJYidtEbgpysnw+amsjOFT9yK1AsQtYkTkqIxo0zyOM6yKGLmp0k7jm+NbvxQQ754dxtkf36m3bRNp/O3Se2k+PxwZ/PP0L7vpQqAVyXALrxTUwOn0Doqne8fludJicx4YqbLM2wNhjo0Rhxcj0MkXMZJizuB+dmaJzta8a+aa0ebvPxeX0lnIdOlsAfURblBeL5CsNGJ7D2Q/RVhqm35tERFNzBen9f4T7mtcD6ht0Uq8lrvqe/Y+gqbwJnyT+PrrMwLd5av+nqQnkWS23R1bcCRn7UXtXFP18VEPhFwZvkbLKzMTDfFCXzApkJbDmoeskgmFuWRG/q0t8Lzf3GNJj8k/zP953p6kXC4GAUR4Yx+z+RLcRnwrFc/gyRKdEv8zksnXk90E3T1dWgnauhiUZnH6FH8EGN89+KeS1yHQK62MIC0mQf9w6Bv74LxYq+mO15kdCwaemVE/UUA4O0Cy+mRico2PB6Lj54p7OKBabw1zH9VlB4W1a7W9obe1VwuqA1PqpTwjDfCkY7/wWV2c91mkx5t6SqXAaYbq+SkuEx9yUEBVkLmBMbiZr3gMnft20Y6Kc/bwekn51ZAQi3s9YLgDcSo592hLVIlRlbclQ8eznTPYGRYF4ccoLVuEJfu/fbTn9sS/EdoBddD7GZzdHv4FwrD2hUU5KWX6XbcDwpmdZHkM+QELzQHYOw/2wp72d7TN3klTvn1xnM6CmYRpCLXfxlWbBy2zBAh7n8CvEqw+LIuZAuWtYxRzMrjaBsxmsWHd28MbLURPoHaf9Tr1PpApBHm65/CPSH7IXm3lwceY0y6FjsQ9cu8Vn2Pl1pKG1eklKroWV/hqCrDoDOrB3GWOxOl8fhqR2sonpBVOw2ras7UdLFJavqIxZ61lQefgQPy6Jp3LS
 gLIFyytL
 alHujogH67E41AEOmRuINI/UZpRFBl0gdXYxoXKW4lOPZA8AeQll7t5XEg24WR7xYFmdzYICL5rmTJL32y73qG6/xFEm8bdUkMFzO3+5VPIJOV1LFES9Op/I8Siqa8NlkcoNM43UarfaWB+7+bXgoZnpHZZwq2Oha8Np6EcnZIHIch/fFJhuEJ6GhMmH27EyysMza2vEZAnLAg1JruUZWz7OIkLM2V0ZuKToO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>

The sysfs_no_op_commit_break test starts a kdamond via sysfs, but its error
paths (e.g., drgn not installed) exit without stopping it.  The leaked
kdamond then makes subsequent tests, e.g. lru_sort.sh and reclaim.sh, skip
with "Another kdamond is running".

Wrap the post-start logic in try-finally so that kdamonds.stop() is
executed on every exit path.

Fixes: 10725cd2b09a ("selftests/damon: test no-op commit broke DAMON status")
Assisted-by: GLM-5.3 OpenCode
Signed-off-by: Zenghui Yu (Huawei) <zenghui.yu@linux.dev>
---
 .../damon/sysfs_no_op_commit_break.py         | 35 ++++++++++---------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index 2c65cffe6b54..81774ddc55ac 100755
--- a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
+++ b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
@@ -47,26 +47,27 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    before_commit_status, err = \
-        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print('before-commit status dump failed: %s' % err)
-        exit(1)
+    try:
+        before_commit_status, err = \
+            dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+        if err is not None:
+            print('before-commit status dump failed: %s' % err)
+            exit(1)
 
-    kdamonds.kdamonds[0].commit()
+        kdamonds.kdamonds[0].commit()
 
-    after_commit_status, err = \
-        dump_damon_status_dict(kdamonds.kdamonds[0].pid)
-    if err is not None:
-        print('after-commit status dump failed: %s' % err)
-        exit(1)
-
-    if before_commit_status != after_commit_status:
-        print(f'before: {json.dumps(before_commit_status, indent=2)}')
-        print(f'after: {json.dumps(after_commit_status, indent=2)}')
-        exit(1)
+        after_commit_status, err = \
+            dump_damon_status_dict(kdamonds.kdamonds[0].pid)
+        if err is not None:
+            print('after-commit status dump failed: %s' % err)
+            exit(1)
 
-    kdamonds.stop()
+        if before_commit_status != after_commit_status:
+            print(f'before: {json.dumps(before_commit_status, indent=2)}')
+            print(f'after: {json.dumps(after_commit_status, indent=2)}')
+            exit(1)
+    finally:
+        kdamonds.stop()
 
 if __name__ == '__main__':
     main()
-- 
2.53.0


