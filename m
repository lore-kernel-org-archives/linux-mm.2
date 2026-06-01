Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DD1ECD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 03:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3C186B0209; Sun, 31 May 2026 23:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BED736B020B; Sun, 31 May 2026 23:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2A6E6B020C; Sun, 31 May 2026 23:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A25C56B0209
	for <linux-mm@kvack.org>; Sun, 31 May 2026 23:24:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A5141204D5
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:37 +0000 (UTC)
X-FDA: 84829901394.20.F520D4F
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf17.hostedemail.com (Postfix) with ESMTP id AC7A440009
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 03:24:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HgE+EHcj;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780284275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpJqpbF9ApLNylCyq0RsExKHsHO66f1ta9bSPuMNQvg=;
	b=BEqBwB3GS5n+Rdp9cImJqnulPXy86wGS+yHROFbXK6LjTMLNXODe+hJr3owK7cZn39EvpG
	9NllMMKm6TB1h5YuSWvQT21fAad3pMeBiHiQZPHgGuO4N0JUX3td+OMWqSyGY6pCinifYD
	NFyDdfE8fdO06OMBoM+22skzWGeKo0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780284275; a=rsa-sha256;
	cv=none;
	b=O3EwWUeXgY9iql6SYLAtvPr3QfEIEUw6V+RQbQ9YCU3Od9Ea5yBg0OapjKevr7JCw3Lod4
	vhkRZem3QZuC6tAJIMUwUzU/HoAoEEX6b9URBa0a5KCvyWBCRkXVS5GhriLTTHi7wdouOx
	sOSh4/71m1PqtN09D+XlVaY8IaBdNuY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HgE+EHcj;
	spf=pass (imf17.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780284274;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BpJqpbF9ApLNylCyq0RsExKHsHO66f1ta9bSPuMNQvg=;
	b=HgE+EHcjd9c4DxL4XphF3dM/ndwLGCizdi8lItx1SrPwXrYb0ojr3vggiEfDPROoDdjIo4
	h9ZewjJ0EUXsA7PB3zHQzti+N9cdyjcDxfE3dCbdsZBJdxempVZFSvLWXRV7xMKgerXYuz
	b+WxxGyyG/VOzV3D6+urxj1qmMuLJq4=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <chentao@kylinos.cn>,
	Wang Lian <lianux.mm@gmail.com>
Subject: [PATCH v2 3/3] selftests/damon: fix dead code, skipped checks, and broken lookups
Date: Mon,  1 Jun 2026 11:23:14 +0800
Message-ID: <20260601032314.424013-4-kunwu.chan@linux.dev>
In-Reply-To: <20260601032314.424013-1-kunwu.chan@linux.dev>
References: <20260601032314.424013-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AC7A440009
X-Stat-Signature: mbha6zazp3pbdksk99ga7wru7umqa9us
X-Rspamd-Server: rspam06
X-HE-Tag: 1780284275-332267
X-HE-Meta: U2FsdGVkX19g71GOTA1PAw/KfjK0f6KM7COciF6JzcKWak3IR1wdbTp+A9Wu9oWFAhQi6QvaIFo0mfA4Y70kU1gVvMyZ2oLn16RmL5CyGHLsGpcdtPc2p5/gUOAlhBFu7uXGfTQSH02E44wEjdLh9OqmUq9bla827nO8jC4j5+hKqUBX+PbQO3ioghiJf58tr//OQWNelLXXlGS6eBtjJ9E8jAOTmePws09rybttbgsKt9G35RsTBRQYkD+cZcbhaSKqZcdRsTvujbacjnGQzmF+KTj5gV+jZyLm/MEtPjvcwiWoFmuDD/XqvMjBeju41Wvh/gWgTN0zPtH/aHs3MNcmVx74TvqsFbEHcmhojlA8kTnQ9BUftnNLFK9WUVcpTnGm7332SNwR0EVZOmJPIyHVE8GFyN4kyl96kTfeSi9tICJ/FI5bHiXu0j/KlybREBcMx95EvPmrpejVVIJGB7jpwitL7sAA7Dr54Jg2KeYcov5mYv1wwaHguTn6164AlKZ3bZWwhbyBnyFPYGO4ag/gzya0eHSQj0uCICoMP/Ds3QdaheGCiATwUUmrvD+tidOiqrJNXUxIoPwPiiaDpHeCVgK6RDa4kRhg4W4hX2aEDqixAY8goS6Or3YtIZpQ4unA29aLQ3wbvfqan1sioFDAXdUzdyp8Y3lhz07KeOnBPzGcDLn+1fl5Q3nRO65hTjDJIwqisU7iO9r5WyEcoqurGWgQXuZBs2CMpr8UNy1kwvAOwXTO3KVe406ZTEUi61tD+2u6pr85ks2QfohCNZMufsWPWciPQPSirgHXXnm/79pyuoHaF/E2hz8THMsC8criIr3A6WNGtCgTeHaoayF6eAlYbcgQmd+pE1u+RF62XyuEDX5HlpnqzDYV9sf96s9xXGAM+gKh5Zzuo7vo/ahMTovjOiQPXLlisztmIxAEQnSgSxK0PYlLLx0VvENAX6tfXwBmKjqqmxoI6xl
 BMM7wdKY
 ivSuBPc/nvv4LHMHEUsXVFNa+2ikwG06BaY21k4c+qRpj84OQpdxxPxlp01Hf3V65VD70bJmXHO7DlowizO+9yp3TwMAVShFbATjl6i4cMuueFzWWy93sn/wlhI4wMe6vfT9Lm5jKIBBAS4IzscM4g3B138Tm1oAHLXjGekdzPELHQ3bFNssMeF0ivV0R1Mg9kuXWR2739AouX6n9NVdhyS8ofLpzmcTwT3RvHOrXUrVrJ16JJWNQ5hFcBiQpowDbzhGqP7TIH3PmrFYafN5R8o2MkUAUi0HUMd8icrvupNcA44eovBo9LlIOwUAFJq2GlF0u
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

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: SeongJae Park <sj@kernel.org>
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
index 2f6f2699db25..f6127081dfb2 100644
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
index f04d43702481..0f2f36584e48 100755
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
index f76e0412b564..661e4ba4765a 100755
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
index 972948e6215f..26b207e44268 100755
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
index aa03a1187489..99412f0d31f3 100755
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
index 78f4badb5beb..2eaaa5ae3c5e 100755
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
index 35c724a63f6c..16fdc6e7fc56 100755
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
2.43.0


