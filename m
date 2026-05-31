Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 474F0CD5BD1
	for <linux-mm@archiver.kernel.org>; Sun, 31 May 2026 09:18:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA5D6B011E; Sun, 31 May 2026 05:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9B666B0120; Sun, 31 May 2026 05:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D92B6B0121; Sun, 31 May 2026 05:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC676B011E
	for <linux-mm@kvack.org>; Sun, 31 May 2026 05:18:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9100F1C1962
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:55 +0000 (UTC)
X-FDA: 84827165430.29.0DC9628
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf20.hostedemail.com (Postfix) with ESMTP id DF1121C0003
	for <linux-mm@kvack.org>; Sun, 31 May 2026 09:18:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/8f+0uD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780219134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8c73Z4hv4/CKJDxP9kzFzTdfkG52gPQ/Jrnw7LzjDMA=;
	b=Bnp8Xl1XVeSL2x7/ENCzU/iKJ6p3tJ1eChar3mGQopb/4OTSk+b9Aal8khZesGCAxGRHRU
	sSJ+Pwt4yb4HUR09MGy0iUkkgENo/sCKtxkwhYzCBYcA8YGN3Q13T/io6daFkx2LFxxzJT
	iLdwrr4E8JeZreQi8wGqa/LilO5t0y4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="d/8f+0uD";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780219134; a=rsa-sha256;
	cv=none;
	b=TIjrUOfWK3yePNfEh82US1n01jgv9E2EEU6Yc9KOXDb5yvuZEkGbuI1gbNr23VgrDpvPug
	kgeNkLUx8mxW0jDud13F7Tafzuo9sLHlWAp7gq/XfN/rVKhimf+PZTGx5QIOrr3iTgGQYo
	abS47UM6Kn/lMr/A+hmMwkRw/NqfxLw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780219132;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8c73Z4hv4/CKJDxP9kzFzTdfkG52gPQ/Jrnw7LzjDMA=;
	b=d/8f+0uDwWbuA3X2xfmvYnMbg88VKE4FnjOauxKjCUiH21hyn6XWVRe28ZzBcULUMhnI95
	MSvEvnYnZ11oH4Y0IjNo3bpC6RfZk7ULP/BMs78ATeJrapyBUy/buk4VDbQOOWI8w6coXx
	ezbTEVjV1c9HKP7hPs0O80h5/e8ODQg=
From: Kunwu Chan <kunwu.chan@linux.dev>
To: sj@kernel.org,
	shuah@kernel.org
Cc: damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Kunwu Chan <kunwu.chan@gmail.com>,
	Wang Lian <lianux.mm@gmail.com>,
	Kunwu Chan <chentao@kylinos.cn>
Subject: [PATCH 5/5] selftests/damon: fix dead code, skipped checks, and broken lookups
Date: Sun, 31 May 2026 17:17:24 +0800
Message-ID: <20260531091724.84381-5-kunwu.chan@linux.dev>
In-Reply-To: <20260531091724.84381-1-kunwu.chan@linux.dev>
References: <20260531085633.48626-1-kunwu.chan@linux.dev>
 <20260531091724.84381-1-kunwu.chan@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: efntg51chjik8hyin7enfir5kig7zyet
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DF1121C0003
X-Rspam-User: 
X-HE-Tag: 1780219133-37720
X-HE-Meta: U2FsdGVkX1/okgrxw6PYX1dS1IIECQAo8QdzVh45M1HGk9DiWEVCaaCxyfN87wD56fFehuquMhy+9vkhqOU+NeCWj2cYYqFnMC5hX8mRndvWCFcKvMdQs8UEpn8e1CgZOtR5kBEsOUEghcsl66yH/Mzvx2/ilYkjcvg26vYsZ4Q96FaAfXx/byK4qfGL93odNVgL/ZnDYpR9XYis4FIHPN627sHjezCFaVWw1kqFjKpdCKvE/UFQLBolpaSmH7CWQpN1/ZZu9KA/zgHz0Vg+Jmo2yLMY6SaoINAVbSvub82O3Ac2XSo0YCN0SqU1WGy4W6PERP+//tx0SaSYucPErghZ+IN3lXxKsmfAO+8XL+d0erkDXumIEusCvr0s74qZL1bhaQIlgLfVhKMuPWqzyj+nNxb7EG4Li+T8jCHR9WYaLSeWj/Nyc68KoXxqlqeYTNdbZNQFzSH6YHeTY2EfrgX6UbA44aKuyeTE+J4CZZhrUy5nF5QDJ9GK0YnzkA/pUqKgncD2la6gIRi9adIkRX56mLpsKc7srsNj5jK/TZxamSr+uy/yk/ul+TzjyHRjlXL5fabFeK/MW+ncDEUMyMBJ0TfGw6pkqLPSHzwVZ2okjwB/0vN2udpjVgzPLSQrCxC/GzPe7pdB52ZrTq57BAhprCt3ZRQthckQPU8c6qgyOY3SBaO5BlwpzqgWtC0Jq3YXqSbS8ZW7nkufX2uiwiswlwboIfN12uvpkNCzOv4e3gzyOHDRO8jNIsclYAid9zVe/EhjKvXBknVnk67L7GACheJk1RL1y3V/9ztx6f8AqHShMmfSwz7e7Nfn6uzncWemaqqT4K1LAWrwX6iTORA8jJPYI6roKQfj0R0gnJ+T4OQREGsX1295eXRDQ6P6l0Tkn2vvkE90tbhka/nVmEW0axwmgMA1CWjkBoEcOMVjWBYgWwGo9EvSQomPx6TL3sT+Zrk/fJspOemM8wU
 44wpqgsM
 i1G/hm2gUT7UGXus0cawcQYv7zkCyc9ujolVs0muaD54BDVyfzrhzgcW20OxQiz5hT5w0VOrmGf+rtebkMpOOyRYP9j6ccWqDzaczD+4JYcIbECubawgP18SoSizunYJaZ8oIUUzREmRgxU4tBQ/925XHL3bV4xidTZhDFD4nuEhJhUsbkRHH25Y5CJThhH8zbKG+WlsOfK/x6+9vcudDx2PLWO1OFoRr5/0+Fiv/Fsvix4zXKodeYSfLvKYKFmkA0chd7XAG/zRaYJkKR47ciAsL4zhc6ff5NhghZJ6cQdbiR1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kunwu Chan <kunwu.chan@gmail.com>

'hugeapge_size' in drgn_dump_damon_status.py was a dead elif branch.
$fail_reason in sysfs.sh was undefined, silently emptying the error
message.  'exit' instead of 'exist' in sysfs.sh skipped a file
existence check.  'nohugeapge' in sysfs.py broke an action dict
lookup.

Fix other wrong strings in the same files.

Co-developed-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Wang Lian <lianux.mm@gmail.com>
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
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
index 006c92a76ebe..c197ab99bcc0 100644
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


