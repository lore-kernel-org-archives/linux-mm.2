Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 993A5C5DF6D
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 08:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90B656B0092; Wed, 19 Aug 2026 04:36:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BD0F6B0093; Wed, 19 Aug 2026 04:36:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABDB6B0095; Wed, 19 Aug 2026 04:36:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDA16B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 04:36:23 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D4B05C040A
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:36:22 +0000 (UTC)
X-FDA: 85117362204.23.9B78556
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf05.hostedemail.com (Postfix) with ESMTP id 21CEB100005
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 08:36:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aH/wsdJP";
	spf=pass (imf05.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787128581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NjK48y+gInVL/DFMKlcFgreu40jMGHPWay1upkkwKro=;
	b=K+gSoylUNfZlrlZBOnbFVY35PSLAtQ6CYM7H/xmBtWM4fekwvTln7bzoKbpKLmGnXFVrO5
	cWrfnU+tEQyMoachjD+hqQuH0c1vQ3qbjh0b+xIm4EVOWGw2PguivD0ru1y9ITNlsIlNsM
	hvfreRnOURRGd19CCn/VlWxZW1gvHgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787128581;
	b=MEWlUfZmFc939kfHUWEty0OhOcpecDEpll9NL37wDBY8XZE9yHwAal46oAkr0BpA1razaX
	JsFv7kGeDC4JftHTiV4qyQaKfMezUCYSb8DtOGpI0/uADJg6hFCKljwRjO3Po5m06SF3zy
	+ZAx/vNAGL1qYWfNxOtdYzyccT/7Wnk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="aH/wsdJP";
	spf=pass (imf05.hostedemail.com: domain of hemanth.selam@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=hemanth.selam@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ceab75934dso8477035ad.2
        for <linux-mm@kvack.org>; Wed, 19 Aug 2026 01:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787128580; x=1787733380; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NjK48y+gInVL/DFMKlcFgreu40jMGHPWay1upkkwKro=;
        b=aH/wsdJPHH+9eZoTJVN7gDVgmMKLl4gSwsc7nTdp9f+rSLvPYqdnzLaw22kQvJviBz
         2rU/yp+SAFDb5ECGYHRciqGRrwkJtXZ9Jwhtd0SMA+uHJhSfT5bewKtdOQ8Y+U7OJ1wX
         EVA3UyeqGgMGXbvuIc1EZQRgZORQ8LkFY/f4GkyQFmqxHrwm48mBMK/XpRa9g94/lhPC
         62kIENxmhXrH9njgMKZs89rRaX1E89gzmB8N0k71+NtHmUGQI0HRtF2SIGOMGLPWG106
         kJsnZkPgl7wU8c/cjzS41qpK5RENdl3KE4RdqEijh8s3bmjIG0vjkoQ+p/e6M7G1sTSq
         vDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787128580; x=1787733380;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NjK48y+gInVL/DFMKlcFgreu40jMGHPWay1upkkwKro=;
        b=XcgYivGFDuQL+8BJ91LrmJ4NXVIFV1zwac/7bwVv/3P/sSvrFGMmzQPj2ToeWQSTNL
         QFzjbjHEKGP0TL8x9JEfxz8ZxRqStwv+a8xoGZUx55ig6VL8XRd1dxKLYEi/k35NWivS
         icW/Lask0VK7kpXSF8xj6axeLb/kAAG6T5Zw+53MkeNV/5n8gZkATNkJcR8CRdlCa6Lr
         aDewuq2PdfQlh0ZQJdX1yqKnT/FUZ0VNFW7eoOEIKm+D834F8HxI7JcGDw0CyWtL4JEJ
         OD+NMj96bfZdLzsVYJnL4VmAlVJSbYauTQb1J+vVyj0HMxj2eYXjAZIcFgJ9Kv20EwYZ
         Rtxg==
X-Forwarded-Encrypted: i=1; AHgh+RqmnfMaTqzgIE/xbVtrNl+13xvT8S7d9xzStEmuVsIA8eTe3DEJJ6D4jvQOxQBIV4BWBTDwZGm/Pw==@kvack.org
X-Gm-Message-State: AOJu0Yz0SB3cS+SLa9f7mybnSG8f+mXXAnkXCqJdMM2eVhV88VhgqDua
	R9n/fAz8hJnoppaapFUGJYjNRmeB+tSPb4UdFC+iAGkUJzb0/r33eRMQ
X-Gm-Gg: AR+sD12HBqPYwVnBPdVP9RzlvXT6IHDKhcUBr+1+7k6e1FsNEkNQqgrjwpN1cGrBChg
	xmWlBrMH/OftGO7/pZFs8Frno+IukvvK+PDj47FnlIBTT5VSQc3hHrdtHRl5ilYtDMMnoZwSzTi
	5NqkffwFrhg4TJkJaXhnVU8IZ9OVkY6IjF+ckwssMxfKEQlu2+T5CQGdVhAIgd3u/xFPkTU6PWj
	g3zQ/joBYOahxnOiQqn0HlsV9BqwVInpWLNVCJtdFmH4E7b+vBbmrdePVo5AeJgdY/DTGzoti2q
	VhcDx5EMfvUxymyUTqAA6m4wt45gXhcPmZH5cxAoFGMqlcpJqM0V/wxDmfelLjt4AV4eGOXIxXE
	mNqlhNLgZY3rqC7cJ8XrUsq7uVWk50rRRZi1oa4ko9CxXmJIpKSHjXSYpZC3fX1jTg1uYuFypNH
	b8O9CkNQEapWbr3oh5mNG6i5kdRqyF4Z+/zsl0IRXYvJ8O3AeSlHXstiMi2KCNsCyDOxcQyLr+K
	zgsB5GoIIM=
X-Received: by 2002:a17:903:2bce:b0:2d5:ccb7:12c3 with SMTP id d9443c01a7336-2d5fd59f837mr58430075ad.2.1787128579467;
        Wed, 19 Aug 2026 01:36:19 -0700 (PDT)
Received: from volcano9f8e-host.amd.com ([165.204.217.251])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327bf143775sm5089413eec.23.2026.08.19.01.36.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2026 01:36:19 -0700 (PDT)
From: Hemanth Selam <hemanth.selam@gmail.com>
To: Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>
Cc: Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Sebastian Chlad <sebastian.chlad@suse.com>,
	Waiman Long <longman@redhat.com>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hemanth Selam <hemanth.selam@gmail.com>
Subject: [PATCH] selftests/cgroup: set the test plan after the setup checks
Date: Wed, 19 Aug 2026 14:06:00 +0530
Message-ID: <20260819083600.1351711-1-hemanth.selam@gmail.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9rhnz7m55mfbxnjccmbjfh7p6h1rdcxz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 21CEB100005
X-HE-Tag: 1787128580-173396
X-HE-Meta: U2FsdGVkX1/Py6s+QZqkRgahI5tAeMTSeWr9D3j+VQ+Xd0EVdYIew68OXgqBqrDGmZq/BHoj3BoKTbOo86PXuArUYpGbKHM243KfWwUVymPfjrEyTAUj2PgOMWFU4lNm+8MUXAJGcbFOqDLEs+dfQC6vL+OxLY6haJvmIT2OMPJmvMS6gBB/8IhLtLADcLnLIBkepNgFCgYrYC79iGxieC2t/9wNA6HihwYykfok+TdvrC7mj39fw5XAdhWk/XaKwFqv8Z6kOiClpjaCMMAFViz872pXDvO7OPYvbNZreZ5/IKbNBIt3fuPUQIbyu+CZBu8e4EnI7EWTsenP1UpD9ftTaFsK3kVRxoqANM3+JB8iwaHCobLiZLdw2ONBLCJHkUJrzRGT4R/nO1CfxAsYoHqWT8jnzQCEDVF2vFEBzcOQ0LBRxwAlGaQNQD/EOin6F8lm3MGv/CfuwDA6Y/jEeiS4QSktDJkCIXF3qBTWvkeBnZAOVrLRillKU6q7dxy8aVtFiXTlBsSvRLSvDT4FBKR4VkR3NwI77uTDCOXU9i5Dmn1isysQ+MgMJRISwl13JGawBEOj1C+lbXuUFHZc9tM5tEaIUP7CVyQJEptiXd5wPBekHdsNhJvqBgOwyfqxfD0t0p1js3BdNWJTsAOJSyw/SU5qutO7BijYfbgOGZP9k/1NyfvbvikcZeX7uCPMpng3boCjb27DkKFwImO7t+Ot5O0lOfppj70tJFQMowiNSoxIMQ7PUeV+Ok0JVb2qWkOx53iRBoREGGkHAszvk2EcdFkEYfJnVLwwZo2vOPapKPLVC2HItkWgwrZm7KDS2fnd6fSnvoSGBY3EJxFzNzrF36Yjz7WHh8sOhs5XBur+slcbmB41hM3O+5L8kWPCf9UmBb7Hh0MQfVRQF7HFHyMYDEFrvzTICRkini86mcb1bk1xkaDbbf98Q8GpMX+73VgO4el8HbkNUfLT+bW
 RZZGaOR7
 loRm0SfiPAZll23hFNWfaNj1bC9uw1kH9GGgiDf0UC/JLmsmucRF6FCrOzPQzllAur39LL+lms5B3NeZkenilxZMym6cR+TBfLCOLguhHh1YA+H9dGMQlsueMRVIqegjtGyCq831DZgGD+o6UmUdz0yvs7aeRsya+cadKVBdGeNV6eh0NQGVcGULBJZAReWqoWa5hwnzxAA6JnqgZjbSb2aK9TUds8YFz8OyPV4xeljuFZui2pyrQmEsUoigmFLFDAlHn42nqiI/SKdPPqmB4+QkQQ9KWZOEygm5TOYLQM7CGYUQCIa2FIFJhffdZhuDTVPRATaRCnbOgTk/bpUAuIyyJRbqFf7n407Um1ECxytmCSWYMerCXf0P3ix0gjmRWgyP1gJdng4knfGod8+GKPmzXcnKubk7N7X9z5PYeTZmfnF5g+P2tDSUKmOEFJ8yopUZ1XOpcLtQieqsSfdxLLeYZFVEKNoyjyRl8If0cxf3H8K8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The cgroup tests announce their plan before checking whether cgroup v2 is
available, so on a host without it they promise a number of results and
then skip out after the first one:

	TAP version 13
	1..3
	ok 1 # SKIP cgroup v2 isn't mounted
	# Planned tests != run tests (3 != 1)
	# Totals: pass:0 fail:0 xfail:0 xpass:0 skip:1 error:0

ksft_exit_skip() can only emit a well formed "1..0 # SKIP" line while no
plan has been printed, as the comment above it in kselftest.h points out.

Move ksft_set_plan() below the setup checks that can skip, so that a
skipped run reports:

	TAP version 13
	1..0 # SKIP cgroup v2 isn't mounted

Several of the tests skip more than once while setting up, for a missing
or unwritable controller as well, so the plan goes after the last of
them.  test_core joins its two setup paths at the post_v2_setup label and
sets the plan there.

Reporting each planned test as skipped instead would keep the plan where
it is, but the setup failures here mean the whole test cannot run rather
than its individual cases being skipped, which is what "1..0 # SKIP" is
for.

Fixes: 1dc830ee4c15 ("selftests/cgroup: conform test to KTAP format output")
Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
---
 tools/testing/selftests/cgroup/test_core.c       | 2 +-
 tools/testing/selftests/cgroup/test_cpu.c        | 2 +-
 tools/testing/selftests/cgroup/test_cpuset.c     | 2 +-
 tools/testing/selftests/cgroup/test_freezer.c    | 2 +-
 tools/testing/selftests/cgroup/test_kill.c       | 2 +-
 tools/testing/selftests/cgroup/test_kmem.c       | 2 +-
 tools/testing/selftests/cgroup/test_memcontrol.c | 2 +-
 tools/testing/selftests/cgroup/test_pids.c       | 2 +-
 tools/testing/selftests/cgroup/test_zswap.c      | 2 +-
 9 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_core.c b/tools/testing/selftests/cgroup/test_core.c
index 88ca832d4fc1..64f4962a4659 100644
--- a/tools/testing/selftests/cgroup/test_core.c
+++ b/tools/testing/selftests/cgroup/test_core.c
@@ -927,7 +927,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), &nsdelegate)) {
 		if (setup_named_v1_root(root, sizeof(root), CG_NAMED_NAME))
 			ksft_exit_skip("cgroup v2 isn't mounted and could not setup named v1 hierarchy\n");
@@ -940,6 +939,7 @@ int main(int argc, char *argv[])
 			ksft_exit_skip("Failed to set memory controller\n");
 
 post_v2_setup:
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_cpu.c b/tools/testing/selftests/cgroup/test_cpu.c
index 7a40d76b9548..8f96bfd19ab9 100644
--- a/tools/testing/selftests/cgroup/test_cpu.c
+++ b/tools/testing/selftests/cgroup/test_cpu.c
@@ -799,7 +799,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -807,6 +806,7 @@ int main(int argc, char *argv[])
 		if (cg_write(root, "cgroup.subtree_control", "+cpu"))
 			ksft_exit_skip("Failed to set cpu controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_cpuset.c b/tools/testing/selftests/cgroup/test_cpuset.c
index c5cf8b56ceb8..52ed8fba685a 100644
--- a/tools/testing/selftests/cgroup/test_cpuset.c
+++ b/tools/testing/selftests/cgroup/test_cpuset.c
@@ -250,7 +250,6 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -258,6 +257,7 @@ int main(int argc, char *argv[])
 		if (cg_write(root, "cgroup.subtree_control", "+cpuset"))
 			ksft_exit_skip("Failed to set cpuset controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_freezer.c b/tools/testing/selftests/cgroup/test_freezer.c
index 0569e93fa6b0..f28bb02e9783 100644
--- a/tools/testing/selftests/cgroup/test_freezer.c
+++ b/tools/testing/selftests/cgroup/test_freezer.c
@@ -1491,9 +1491,9 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_kill.c b/tools/testing/selftests/cgroup/test_kill.c
index f6cd23a8ecc7..99cafd9dc013 100644
--- a/tools/testing/selftests/cgroup/test_kill.c
+++ b/tools/testing/selftests/cgroup/test_kill.c
@@ -278,9 +278,9 @@ int main(int argc, char *argv[])
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_kmem.c b/tools/testing/selftests/cgroup/test_kmem.c
index 1db0ba1226b9..cb47561b4b44 100644
--- a/tools/testing/selftests/cgroup/test_kmem.c
+++ b/tools/testing/selftests/cgroup/test_kmem.c
@@ -426,7 +426,6 @@ int main(int argc, char **argv)
 	int i;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -441,6 +440,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
index 0ebf796f3cff..3a84d068fbf3 100644
--- a/tools/testing/selftests/cgroup/test_memcontrol.c
+++ b/tools/testing/selftests/cgroup/test_memcontrol.c
@@ -1798,7 +1798,6 @@ int main(int argc, char **argv)
 		page_size = BUF_SIZE;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -1823,6 +1822,7 @@ int main(int argc, char **argv)
 		ksft_exit_skip("Failed to query cgroup mount option\n");
 	has_localevents = proc_status;
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_pids.c b/tools/testing/selftests/cgroup/test_pids.c
index 9a387c815d2c..710109b53dfe 100644
--- a/tools/testing/selftests/cgroup/test_pids.c
+++ b/tools/testing/selftests/cgroup/test_pids.c
@@ -148,7 +148,6 @@ int main(int argc, char **argv)
 	char root[PATH_MAX];
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -163,6 +162,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+pids"))
 			ksft_exit_skip("Failed to set pids controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (int i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index 49b36ee79160..6e7b89315bbf 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -810,7 +810,6 @@ int main(int argc, char **argv)
 		page_size = BUF_SIZE;
 
 	ksft_print_header();
-	ksft_set_plan(ARRAY_SIZE(tests));
 	if (cg_find_unified_root(root, sizeof(root), NULL))
 		ksft_exit_skip("cgroup v2 isn't mounted\n");
 
@@ -827,6 +826,7 @@ int main(int argc, char **argv)
 		if (cg_write(root, "cgroup.subtree_control", "+memory"))
 			ksft_exit_skip("Failed to set memory controller\n");
 
+	ksft_set_plan(ARRAY_SIZE(tests));
 	for (i = 0; i < ARRAY_SIZE(tests); i++) {
 		switch (tests[i].fn(root)) {
 		case KSFT_PASS:
-- 
2.43.7


