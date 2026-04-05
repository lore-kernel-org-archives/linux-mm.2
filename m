Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC495E9D80D
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 21:32:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6F1B6B0088; Sun,  5 Apr 2026 17:32:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1FDF6B0089; Sun,  5 Apr 2026 17:32:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35E66B008A; Sun,  5 Apr 2026 17:32:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE8456B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 17:32:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3F6B01B557B
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:32:03 +0000 (UTC)
X-FDA: 84625800126.18.A674C96
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf06.hostedemail.com (Postfix) with ESMTP id 820AD180004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 21:32:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mj0ITPIW;
	spf=pass (imf06.hostedemail.com: domain of create0818@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775424721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fTm8Ymb+Z1XqMTFD8Vp9OWwDvEBHALKL1c3yKJxhXAE=;
	b=ZfxVwwIdwz7i2fWnNY30b+wz6CPiBiOuU5xQK5/Vy1owlxR3Pb6s+0HEPhb2JJf0RYLk8/
	kytZi5OO+5RjtCaHNhc56usazZWoXi/LAXlGfbeefojEcVtvYgxw0QZpH8p7ayIkL3zRbz
	Qx5w0UOAZFDwWVq5dC1epVgi+SIHH0I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775424721; a=rsa-sha256;
	cv=none;
	b=opMxPBqcK/ywdph7ZrHr2tTLE/ndJbe65fSxvTR9pwi8iHjmAbxmReuxbXsJQtXkyoTQH9
	xsQFxEbCyY6Y5MFK3NyRUkdnX7Z8d8AKfXRHWo9OExJAo7jjImNHivIpQs7nOIQL1HNylD
	91hmSD3uJW9IEU39MHxoJ0R+2KFiwmg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mj0ITPIW;
	spf=pass (imf06.hostedemail.com: domain of create0818@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=create0818@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=fT
	m8Ymb+Z1XqMTFD8Vp9OWwDvEBHALKL1c3yKJxhXAE=; b=mj0ITPIWmn/Oo/KYTd
	BB06VyFwUBQSIie+Djgp6+w0psQewnDP+VYPP2J/uAIoNPqQ2QEEAUbA1v+138B5
	feQoSFc7z5qyqWcZkJpmqVeKhRRx/c7UPurwy2W79bgVQ0dU1kFNBQsSMvrkEz2q
	W+I2JdkVfYsbFjbmw7tKnT3JE=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-4 (Coremail) with SMTP id _____wCn_iy01NJpqzIwDg--.39331S2;
	Mon, 06 Apr 2026 05:31:34 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	CaoRuichuang <create0818@163.com>
Subject: [PATCH] selftests: mm: stop relying on killall in charge_reserved_hugetlb
Date: Mon,  6 Apr 2026 05:31:26 +0800
Message-Id: <20260405213126.1161-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCn_iy01NJpqzIwDg--.39331S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxCrWDWr1xGFWDXr4rKw4xCrg_yoW5Zr1rp3
	4xK3Z8Gryrtr9rJr4kGF4UZrn7Gw4kXFyIqF4Fkr97Zr13GwsrKF1j9Fy7XrWxurWaqrWf
	uw4Fvw4v93WUAaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0p_zuWDUUUUU=
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6BdxqmnS1Lce3gAA38
X-Rspamd-Server: rspam12
X-Stat-Signature: khfe5csq8grwmfg3qwk7ajkkmtcbxh4k
X-Rspamd-Queue-Id: 820AD180004
X-Rspam-User: 
X-HE-Tag: 1775424720-850901
X-HE-Meta: U2FsdGVkX1+H6lGDVCh3bgqqSOy9OFLU7f+z40snSDxL9B+ymdciIHdhGOrR42g1/JYIcTSU7fcaKpKr6k/NSBIMvKEKAdUHmMe7fVoiXi17NrCza9xnnhRDTDDsJ4ZRgM3tesP83yDwNFvSvFadlD77vC2wcOJj2snHccClkTnpJXyMzrp0z3MIctiwH1i2c0qzpjz2pKH1m7fbXlfMd2e+JnphsQ85cPDHXnugF2t5PNQiHpc4A5xbmYT09L0/7CIXMSMlZxgAwfSeKM8CIJ51oek1YNBXz8ruihNJm10hQS1qU94/hXxunCRqw77njra9udyAzVmEeiYEpfubEAsp7XaeY20QgSbHqj4syjnvgO6VB9FARu+ySHR9xxuXSgNO59qkVCFmnM4aeE2H4KO2zm6UyCVcU3jivb7ZMqBYLiVBft8OmFkX+BO7ddX3cagxXM0aUIfht2WzFNX1tHX6YCAYf/+nWdJpvV6g7BXJSRAhOMTNgAKspTrzOXNQK3YXWCuJTyBSQ/jVbLS1c4AX3z3DJs0kHIx84UB0rEyf827woQ+qXSbFUEYjfj1cEmtZt50vtNj1McrRZw7+SBA7xDwrNqMB8dDd0vMjIkGUOQBl93lB0gpmqPBHjQBFjN6j6gVjnChO5/4bzN81DRHBLuk6poJEGBLAkgslonxuyBskCcc8ZErFuNPNALWGhwTzCxzepBg9J4zoyTp3oSkye0O5c2Ey4GXwlX+vxRkYWM2u/O1JltK2pDkkvqTi9YQhvSO3N/q54f52LxrD8IZ+Ol9BpIbN43wPOTkDSi3whAlhexjuTBr5QaYaDMRNzbFnRgEulzA3DpEpZ+sRk9L/aZ7pjXNZnxiUY24+bVzbGFdg9ARBG01IqPGHDOLI0PWdTVafeex/MwtTjRw5jzyWlyL/lMoVWmDUIBXHljTCTlDuvF8dMPwrsWtpCc/rnJPdOyG0ksZDVn5/f0G
 af1N/l/2
 d4nxSdQxaIgQO5yPpmwH9KuOeo34+T9PcoqcYm34/NrR8BbHnm7Btsp8oRohfqK4dCrNl8llkdLYKSo93/yosM4al9EDAjzfpFAU33/+q/nvGWQgd2bZuDSbDTnInDeHOY1mcFrb8XJhUPUJkNoyS4IQOr7kr65uBNS6L+EPvaJOT8Acuf+a75H4VYdK3Me27QKtY5rO/w9/r3CQ3FF+Fg4MKh0plyMeDTobGJN1zKCTnSiOj27OrhegCWKGZY/g097lAk7Kc1hwIYa2bBRE06kls6K8aEWSn78vPoP45ejoTLMqgPfZNPfaFmxjRqCFmFzNhfE22kpDGJaGnFy+2Sw89oJo7Xg+fB+0QatUI/ohRdtjAIJTc3NMlSiW4FDfnwuU0P/mng480h75JoUOubJCbRd69TsV/zGyn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

charge_reserved_hugetlb.sh tears down background writers with
killall -2 --wait write_to_hugetlbfs. That depends on killall from
psmisc, which is not installed on minimal Ubuntu images, so the test
fails in cleanup with "killall: command not found".

Track the writer PIDs we start ourselves and signal them directly
during cleanup instead. Make write_hugetlb_memory.sh exec
write_to_hugetlbfs so the recorded PID names the long-lived test
process, and redirect async output straight to the temporary log file
instead of going through a tee pipeline.

Signed-off-by: CaoRuichuang <create0818@163.com>
---
 .../selftests/mm/charge_reserved_hugetlb.sh   | 25 +++++++++++++++----
 .../selftests/mm/write_hugetlb_memory.sh      |  2 +-
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 447769657..757df4878 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -44,6 +44,8 @@ else
 fi
 export cgroup_path
 
+write_pids=()
+
 function cleanup() {
   if [[ $cgroup2 ]]; then
     echo $$ >$cgroup_path/cgroup.procs
@@ -193,10 +195,12 @@ function write_hugetlbfs_and_get_usage() {
     [[ "$private" == "-r" ]] && [[ "$expect_failure" != 1 ]]; then
 
     bash write_hugetlb_memory.sh "$size" "$populate" "$write" \
-      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" 2>&1 | tee $output &
+      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" \
+      >"$output" 2>&1 &
 
     local write_result=$?
     local write_pid=$!
+    write_pids+=("$write_pid")
 
     until grep -q -i "DONE" $output; do
       echo waiting for DONE signal.
@@ -261,10 +265,21 @@ function write_hugetlbfs_and_get_usage() {
 function cleanup_hugetlb_memory() {
   set +e
   local cgroup="$1"
-  if [[ "$(pgrep -f write_to_hugetlbfs)" != "" ]]; then
-    echo killing write_to_hugetlbfs
-    killall -2 --wait write_to_hugetlbfs
-    wait_for_hugetlb_memory_to_get_depleted $cgroup
+  local write_pid
+
+  if (( ${#write_pids[@]} )); then
+    for write_pid in "${write_pids[@]}"; do
+      if kill -0 "$write_pid" 2>/dev/null; then
+        echo killing write_to_hugetlbfs pid "$write_pid"
+        kill -2 "$write_pid"
+        wait "$write_pid"
+      fi
+    done
+    write_pids=()
+
+    if [[ -n "$cgroup" ]]; then
+      wait_for_hugetlb_memory_to_get_depleted "$cgroup"
+    fi
   fi
   set -e
 
diff --git a/tools/testing/selftests/mm/write_hugetlb_memory.sh b/tools/testing/selftests/mm/write_hugetlb_memory.sh
index 3d2d2eb9d..49164bbfc 100755
--- a/tools/testing/selftests/mm/write_hugetlb_memory.sh
+++ b/tools/testing/selftests/mm/write_hugetlb_memory.sh
@@ -19,5 +19,5 @@ echo $$ > ${cgroup_path:-/dev/cgroup/memory}/"$cgroup"/cgroup.procs
 echo "Method is $method"
 
 set +e
-./write_to_hugetlbfs -p "$path" -s "$size" "$write" "$populate" -m "$method" \
+exec ./write_to_hugetlbfs -p "$path" -s "$size" "$write" "$populate" -m "$method" \
       "$private" "$want_sleep" "$reserve"
-- 
2.39.5 (Apple Git-154)


