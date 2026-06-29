Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A32FC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1956B6B00B4; Mon, 29 Jun 2026 10:46:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174746B00B2; Mon, 29 Jun 2026 10:46:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 067BB6B00B2; Mon, 29 Jun 2026 10:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C8D1E6B00B2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:46:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A1FB8916E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:58 +0000 (UTC)
X-FDA: 84933227316.14.F1516B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id B8C142000D
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:46:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K0/N2BCt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744416;
	b=Mlw6GtvPIGw3FgvPGr3L65Dl6bNAxOgIvLt9f3dzxONNa9LjKIWuJFMutVb5lLK+v2gGJY
	M0a8GbExYe3ROTxb1orD/iRv32WesvrbKvJRxPTaX36JHXxl8p497egI/+/LzXvZghRjth
	Y2E6cZZC8r8ItL70jxeS8JvJKhoIg60=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hw2mNTh8gDfPv2FwuER2wc7UZ1afDi5KQ9tStlM/EPA=;
	b=gpOBYQ6Ct2aoKQ3Zu+YrdWol9efgA3m32RtgG0Pkzu56Ya7OtWRweRyouin+HxPp6ClW0c
	MTE9z9T7il4ws4CTc9PphN+EZxcQNO0JkHnr7Uvuq91+1P1GUh6t3eqdSDEJjeIc90IpyQ
	C8bMwjxAJ7gA4cY6lBkXVtByTyuNdN4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="K0/N2BCt";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59EE2600D8;
	Mon, 29 Jun 2026 14:46:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5B11F00AC4;
	Mon, 29 Jun 2026 14:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744416;
	bh=Hw2mNTh8gDfPv2FwuER2wc7UZ1afDi5KQ9tStlM/EPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0/N2BCtJxuKOlwnScHc9AqrmS9zWI3nJlq/U53wGVI9c0U76ma54DipeiFzCgWft
	 HD2OELoLshRkfoSsT1/tPl4Mi3DKsHgRd/SX1sVXS8eegWHKWZHwlkRAZR68wV8r4C
	 a5aQ/VSIybjk4QjwS8ABkoY1iyRAe1BznHPXhL/TfqNq36o77BUoz+0T7sWUW2kcAC
	 O1HT/IW8+ui+wOluMXwWCKBkCRydZiNwKbqUjlwQ4+ROpTSp4LAYj5i2sbvUAe+suv
	 yDHxt3Hs7OFW71FghW3NysrLVLYZe+7IwCtDHkXYq4VnA5qm2DIrS6zdvovGk+khoJ
	 /yKIVs2Aw2JSA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kunwu Chan <chentao@kylinos.cn>,
	SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Wang Lian <lianux.mm@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 3/3] selftests/damon: fix dead code, skipped checks, and broken lookups
Date: Mon, 29 Jun 2026 07:46:46 -0700
Message-ID: <20260629144648.134092-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260629144648.134092-1-sj@kernel.org>
References: <20260629144648.134092-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B8C142000D
X-Rspam-User: 
X-Stat-Signature: wur8mp3gzg35wcz9ziuqyrt499493ky1
X-HE-Tag: 1782744416-511384
X-HE-Meta: U2FsdGVkX18BGxRz3R1cDNx84HzrKu/a2Obc8smMm52dOI8m1f9cFBWNnBp0X7P4IYAmqFy0zgZngQeVsOKG/l/A2EFf+molRRKoLBCOX8CJm9PcQeDBQ6TG3WqXXGrqSCB4grYExGDp1sAPLYj2z+R058DU/HgCuemoxrrzeqnzmnV44nfyP8F2rTZrqXEQoQTStTDBl+AO99K5KDoZYlG6/wkYmvIOvGwp9JxpsrvITLqROjvDAE9P6d9f4Nf1F9VnZAAOkxg4v4fwM/fzVTWr3xlK6lo+2rR3oZLK6zjkvEmhQIfJJUknAtToOhCC9ots4MSCY+bxtsPy4gtAOlbMfB+6Sfsdt0q9oedTasg6k+Y2f+aodNkiNRInaxJGCKKFJUCfRoKLsmVLlJUjeX1lmqguuNTBI3EDKEcsbzZMUrwmIxDMDbjyDKZaE3G+X0giQp5YHrg1H0iwPSSagRusex6SgpxmZKvochNeFiejh4gFQ+g9O4RH7TunwqHxjKi7Iz/fVCsSrSxht8E/qoUTA4ccO0jra5MFFfrsRpPK5eHKrD79zHg0X1ZhgTF/HImbtdNWYzFsoplnsv536ZDiGqh2WMfibTjH9e7CplHfu+2UPSh6BN7RByDkr8rurxZVIuXDDX+tE4afozsX8iYICF4moFTLrSO4Xmy0F6tj2yg06sEhaHEQivIPaNpulvR6DSnBPJFtVW00ikjjrA9wXKKhlBcUQgxQOurEh7fXvsd3mNTFxxwHONfoE2W7jFh2Fzf6ZYBqlMQhjMujhkTHLiMgi2M6eh+NAXw+LUKTmYA3rbS8bd3u/KMxXJwXM7otAHQYyAHA+BH2LJwi59ZAQs2B2560N+q6cSNfyTioXODntlRke8ofWB4Jsmyq5JbPWY9Yoz+AfmY+fwxTcG4lw7d1nTEOOjvI7cnT0hdTXDGt28F7MP1bKRM2rv1esH6DNQmbQg+27FU/Vxe
 M7j3wXS6
 UFco3HC+3eF8x/LpGcDJPsyGbkhirvdfrpxUHnkQtjalXkKKdmVH4Afoq6Jno82NvbfSSPghU+5s1lX9hDdRKc38VEM/jXi5yvyL5oMRZMvShA/9d8sYhySwgF5e29diTY2aVL+tGMVI8DcyZoZkKbaLuPLw1ixlAuR6+7vKyjqrQEjmdI9lSod/CEbhjyDbqcFRmHbtivWjTKvx3CH80VIxicliyF97clpWAQX92jC/1N7D4XBdF1Wy4j3nmd1HvvOEA40N/TAnMFjLTrAYtKb4ygVSz7RNFpH9GNd9qTE/7I1fNNqI2j3k1qFR5bpz+tCOLmN2zwD2AkjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <chentao@kylinos.cn>

'hugeapge_size' in drgn_dump_damon_status.py was a dead elif branch.
$fail_reason in sysfs.sh was undefined, silently emptying the error
message.  'exit' instead of 'exist' in sysfs.sh skipped a file
existence check.  'nohugeapge' in sysfs.py broke an action dict
lookup.

Fix other wrong strings in the same files.

Link: https://lore.kernel.org/20260601032314.424013-4-kunwu.chan@linux.dev
Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: SJ Park <sj@kernel.org>
Cc: Kunwu Chan <chentao@kylinos.cn>
Cc: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/_damon_sysfs.py               | 2 +-
 tools/testing/selftests/damon/damos_apply_interval.py       | 2 +-
 tools/testing/selftests/damon/damos_quota_goal.py           | 2 +-
 tools/testing/selftests/damon/drgn_dump_damon_status.py     | 2 +-
 tools/testing/selftests/damon/sysfs.py                      | 4 ++--
 tools/testing/selftests/damon/sysfs.sh                      | 6 +++---
 .../sysfs_update_schemes_tried_regions_wss_estimation.py    | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/testing/selftests/damon/_damon_sysfs.py b/tools/testing/selftests/damon/_damon_sysfs.py
index 2f6f2699db256..f6127081dfb2e 100644
--- a/tools/testing/selftests/damon/_damon_sysfs.py
+++ b/tools/testing/selftests/damon/_damon_sysfs.py
@@ -837,7 +837,7 @@ class Kdamond:
                 for goal in scheme.quota.goals:
                     err = goal.stage()
                     if err is not None:
-                        print('commit_schemes_quota_goals failed stagign: %s'%
+                        print('commit_schemes_quota_goals failed staging: %s'%
                               err)
                         exit(1)
         return write_file(os.path.join(self.sysfs_dir(), 'state'),
diff --git a/tools/testing/selftests/damon/damos_apply_interval.py b/tools/testing/selftests/damon/damos_apply_interval.py
index f04d43702481c..0f2f36584e48c 100755
--- a/tools/testing/selftests/damon/damos_apply_interval.py
+++ b/tools/testing/selftests/damon/damos_apply_interval.py
@@ -56,7 +56,7 @@ def main():
     # Because the second scheme was having the apply interval that is ten times
     # lower than that of the first scheme, the second scheme should be tried
     # about ten times more frequently than the first scheme.  For possible
-    # timing errors, check if it was at least nine times more freuqnetly tried.
+    # timing errors, check if it was at least nine times more frequently tried.
     ratio = nr_tried_stats[1] / nr_tried_stats[0]
     if ratio < 9:
         print('%d / %d = %f (< 9)' %
diff --git a/tools/testing/selftests/damon/damos_quota_goal.py b/tools/testing/selftests/damon/damos_quota_goal.py
index f76e0412b564c..661e4ba4765ae 100755
--- a/tools/testing/selftests/damon/damos_quota_goal.py
+++ b/tools/testing/selftests/damon/damos_quota_goal.py
@@ -66,7 +66,7 @@ def main():
             # effective quota was already minimum that cannot be more reduced
             if expect_increase is False and last_effective_bytes == 1:
                 continue
-            print('efective bytes not changed: %d' % goal.effective_bytes)
+            print('effective bytes not changed: %d' % goal.effective_bytes)
             exit(1)
 
         increased = last_effective_bytes < goal.effective_bytes
diff --git a/tools/testing/selftests/damon/drgn_dump_damon_status.py b/tools/testing/selftests/damon/drgn_dump_damon_status.py
index 972948e6215f1..26b207e44268d 100755
--- a/tools/testing/selftests/damon/drgn_dump_damon_status.py
+++ b/tools/testing/selftests/damon/drgn_dump_damon_status.py
@@ -163,7 +163,7 @@ def damos_filter_to_dict(damos_filter):
                                int(damos_filter.addr_range.end)]
     elif type_ == 'target':
         dict_['target_idx'] = int(damos_filter.target_idx)
-    elif type_ == 'hugeapge_size':
+    elif type_ == 'hugepage_size':
         dict_['sz_range'] = [int(damos_filter.sz_range.min),
                              int(damos_filter.sz_range.max)]
     return dict_
diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
index aa03a1187489f..99412f0d31f37 100755
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -119,7 +119,7 @@ def assert_access_pattern_committed(pattern, dump):
                 'max_nr_accesses', dump)
     assert_true(dump['min_age_region'] == pattern.age[0], 'min_age_region',
                 dump)
-    assert_true(dump['max_age_region'] == pattern.age[1], 'miaxage_region',
+    assert_true(dump['max_age_region'] == pattern.age[1], 'max_age_region',
                 dump)
 
 def assert_scheme_committed(scheme, dump):
@@ -129,7 +129,7 @@ def assert_scheme_committed(scheme, dump):
             'cold': 1,
             'pageout': 2,
             'hugepage': 3,
-            'nohugeapge': 4,
+            'nohugepage': 4,
             'collapse': 5,
             'lru_prio': 6,
             'lru_deprio': 7,
diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78f4badb5bebb..2eaaa5ae3c5ed 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -3,7 +3,7 @@
 
 source _common.sh
 
-# Kselftest frmework requirement - SKIP code is 4.
+# Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
 ensure_write_succ()
@@ -28,7 +28,7 @@ ensure_write_fail()
 
 	if (echo "$content" > "$file") 2> /dev/null
 	then
-		echo "writing $content to $file succeed ($fail_reason)"
+		echo "writing $content to $file succeeded ($reason)"
 		echo "expected failure because $reason"
 		exit 1
 	fi
@@ -363,7 +363,7 @@ test_context()
 {
 	context_dir=$1
 	ensure_dir "$context_dir" "exist"
-	ensure_file "$context_dir/avail_operations" "exit" 400
+	ensure_file "$context_dir/avail_operations" "exist" 400
 	ensure_file "$context_dir/operations" "exist" 600
 	ensure_file "$context_dir/addr_unit" "exist" 600
 	ensure_file "$context_dir/pause" "exist" 600
diff --git a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
index 35c724a63f6cf..16fdc6e7fc566 100755
--- a/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
+++ b/tools/testing/selftests/damon/sysfs_update_schemes_tried_regions_wss_estimation.py
@@ -7,7 +7,7 @@ import time
 import _damon_sysfs
 
 def pass_wss_estimation(sz_region):
-    # access two regions of given size, 2 seocnds per each region
+    # access two regions of given size, 2 seconds per each region
     proc = subprocess.Popen(
             ['./access_memory', '2', '%d' % sz_region, '2000', 'repeat'])
     kdamonds = _damon_sysfs.Kdamonds([_damon_sysfs.Kdamond(
-- 
2.47.3

