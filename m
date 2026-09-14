Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C6BC88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19EC16B0098; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E1E46B009B; Mon, 14 Sep 2026 10:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBCFB6B009B; Mon, 14 Sep 2026 10:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C1F9F6B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:20:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ED84212015F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:03 +0000 (UTC)
X-FDA: 85212577086.27.C4AA861
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 349B4100009
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:20:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NO20yQc6;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789395602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1oWEcWOiJS4U7UoQkNpC5ifxai4TnwShrWzXzWihbqc=;
	b=b+UooJ5PFhDQO1906Luxawjy/XWI0kcGjByFvIKZdTh2Uns3NB5g8mqVs8vBGmZwcOWygi
	2UZ/jYbJa6HYJCJJ2jeR3QmOcIu9z4XNQLqm2VhGbw4Tuy1vnJ1ugLfsILbYoMrWGIcELN
	4pW22tPvRmwk55g6lE+EGk0w0wOlsgM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789395602;
	b=EZJB/3ShRnyYzrjO6cwkkhATEbBdxx4O+vYolMbz1uTbxZWijL+4Re5QS8GjE+tdTMHfFm
	r8FuWdygbGrLO0Y3qCLy/J4r+7RjCEHfAayvQ+FWLWUgpcQ6qXKAY3jkiRcwkarIoq8pBY
	IEv8RUilA1tdbTw1y4YGjJ46Uema7Kk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NO20yQc6;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 60AC243D5E;
	Mon, 14 Sep 2026 14:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2811F00898;
	Mon, 14 Sep 2026 14:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789395601;
	bh=1oWEcWOiJS4U7UoQkNpC5ifxai4TnwShrWzXzWihbqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NO20yQc61hDX4N6lEy0ZsVRFihbtdYpFcBa0+s2k1rLQM8gvTKtjszXCbeuDDTz15
	 76VDqJeJFu2flLbl5M6wRt2uYT6yE8r1Gw+GzCyEiUJ35E8kO2r7FD7Eby8HCqK+mg
	 ZJk9EKrPkgBUPLi6JvDaST2ejDcelGSk2FqJH1oKMIatw0pH8CQnD925cmRy6xSrbW
	 Hx8/7t+ZogRMXXmgXMDApbAD2otaf3Ot0U5pVNhdDx7tQOvQTh+PftyYC1ZklqoLzi
	 xq8AO1fYBApaNkjQlyQz8JHhj7ppcX6PpOYaip//+GOsz0R7YNRUbFJzHY83BJnO0x
	 fguS+r5Extt5Q==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Zenghui Yu (Huawei)" <zenghui.yu@linux.dev>,
	SJ Park <sj@kernel.org>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/6] selftests/damon: stop kdamond on error exits of no-op commit test
Date: Mon, 14 Sep 2026 07:19:46 -0700
Message-ID: <20260914141952.91465-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260914141952.91465-1-sj@kernel.org>
References: <20260914141952.91465-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xaqb3ty3hma8bo4i7tewhdkmradpqr9t
X-Rspam-User: 
X-Rspamd-Queue-Id: 349B4100009
X-Rspamd-Server: rspam03
X-HE-Tag: 1789395602-24664
X-HE-Meta: U2FsdGVkX18eHs5MDckIVly2MlhLHvyUSigZYyfTWT+NKkS9SXERRqE3EymDYRmeAkQ6njKmz8yJcgOAnrTaApUTl/iijIc1bWzQ1Er8xByBf6ShLAn/Ch4gZFXurGC4J8VThOp9Ji8OfoYmBPL/paSGFluYDm+uLsv+jgWBo1/NEtTyJkSPfeNHslpHMK4TIZ+nJ2HBZSEDdgF7ahd9eZ38vSqSx4UXaAOW16S7/2W0F5eh1JWA54yeYo8LNcLYdPWrhtXlgiz1/MF9OQUqU0mGBvvs3WHc0aARGAmvZ5qT+rW+P22SO3HyP3BU2pvbfyvhHYzxObbJB1Q166Xfx/8bXG9O1GZG/wxNgPbOX6KUdrb56Q9E7+AQ3/FSFEoSeQq2gyhBkt4TJDyC2fE4R8LHHCl4oty8y9k72Lls8yUAzdB/+Zm+lIt87SNnz3moqIPKJeV4qbCIIKfWWp1BOqSgOcGnzQ/fDhjQseHLf7Cn0LiHdFVjhB7zei17UO0YMcwuKTpX2tHDUUeKqOrafxC9HtfX1ixNe2arJiiK48bOW/XHjBCeeePiH4wgZtI8i/uM1o/q/OW1lXSUyYHPn5eBDJSLZhkecCEN3lB06fBGx9nxU1I0yG7l119rofu5d6KsrNNgpU3BNBFCY1g9TEY31Nh/X2pexn2jol+0GTXzRTksnMhX+GPypAFrjmTw9Us2aWu6HHniNdjaufYkEL48Qjw9JasyywkR29DwXbSPSGKShHSG5aKfM5dscorFgKIECvmxd5/Syjgp5K7QJgLUSLNFlEE7ghxDEMymvkFmwSX6zJH9ehzTooT/5Sm10QcEvXpdUlxl76fie4nPoojD6Qmh0psKsVRyWKLCj7e9i3AJqOpIMsuQMrYSAFPEBCWlaOgDueRToqr/ylwB03jzTPr8x8bmNCF09qc0lynayJ31aB760oDCSrGQZLQutlut/7iyuNr0WK/fdUu
 +xgt1tKQ
 ipbZi0zYocR1XVZMH4hiQMyg5Pr5hMKR0kHOO5OYT44IV722WE25BPs+36u7u9GuHyOFX28ADAsNytNrwPtbHdkYRAGTUdjAhaiEwBcGJti7So8abwP+sTia39NTQd94wwVHN1ieQ0ZT0f0MQ3Zs91/zKNIjrcOO2QkhkQrCNhOrPnjWtCD0kjWRgFCV7SP0PEFhjESPhoHcMZIOThCt2yfE0G2jlzB6ExZUpINk/hWZMFKU=
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
Reviewed-by: SJ Park <sj@kernel.org>
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from v1
- v1: https://lore.kernel.org/20260907123455.67246-1-zenghui.yu@linux.dev
- Collect R-b: from SJ.
- Rebase to latest mm-new.

 .../damon/sysfs_no_op_commit_break.py         | 35 ++++++++++---------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/testing/selftests/damon/sysfs_no_op_commit_break.py b/tools/testing/selftests/damon/sysfs_no_op_commit_break.py
index 2c65cffe6b545..81774ddc55ac4 100755
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
2.47.3

