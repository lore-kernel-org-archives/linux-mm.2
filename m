Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21B4F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527316B02A0; Sat, 18 Apr 2026 07:01:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FF736B02A2; Sat, 18 Apr 2026 07:01:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4150F6B02A3; Sat, 18 Apr 2026 07:01:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EBC96B02A0
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:01:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EF33FE467D
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:17 +0000 (UTC)
X-FDA: 84671384994.30.54AC367
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 53DD6100013
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:01:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mf5ju1QO;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfVuu7VhyD06W335FVMUaaQUivlN5wadRMCJaI/415s=;
	b=GJXmHC7sH1vQlSmFJw/9QVHS1/z3vS5pWWZHPWmtLjIDu65D2iCl1/uA/W/QPAzy4mKrh9
	qB0hhdRzaT4uV3Yml9WZz92A0ZsGjiLen0MfKBJiIb1E+Fjp6+6phshHwb7klJLYOZESVh
	7z7OE+l1kTxvYDZKWCcxJBcFI3rLEbU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mf5ju1QO;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510076; a=rsa-sha256;
	cv=none;
	b=7Uik1fkAzL75Da6AxL/x3XBi2FU5dx6YCklrxlm0wLEvUHKWrxjrzdBK011rN1G0C+juPA
	QKSCkthk/9mO7BjpC4Oq3zPsGuE/F/sQk2pi0DGFZxGK9dp5tyuIJU28IBCtHYqpJEOLLb
	sgOyA+/y4PE/I1a4dIoMIpeiyxRdhcM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D04C460145;
	Sat, 18 Apr 2026 11:01:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF380C2BCB8;
	Sat, 18 Apr 2026 11:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510075;
	bh=sZoUbqG9CxBotaWHnOZiPFKTeBgb66YHvpq2HPRKqX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mf5ju1QOvH3HlyTG4qnP7elvnF+hxKxb0mLQ2SnKDGm7Bf10EWxGXuIloTNlFzz/L
	 OWz0UKvhbcNwUGuLtgxz8m0ZQpKdpTKw+udZhHhT6wB1230Xlpraz1JuIlwECZpa3c
	 QRmCA769jUxCp/PD8zLrAupwbQcKxd8exPDWN1rqw+kNQELjJjvUVRiJrY+d5f4jui
	 vXANZeneevITQ1NLbQxwZ2iL6JhF6Jv37gX9CQja2OpHXW0UWBPP1dcaFNrIpYjiqn
	 qi7B4juBsYd0p4lCB7MUMgfR0qxHHZtp1jcf514dvKte9e5wxhB/cQvbI0JJmUSArV
	 X2wM90vdkgO9Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 53/53] selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
Date: Sat, 18 Apr 2026 13:55:38 +0300
Message-ID: <20260418105539.1261536-54-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gozztmk8hh8h4r91gaffyqetz4he3kzo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 53DD6100013
X-HE-Tag: 1776510076-465803
X-HE-Meta: U2FsdGVkX18RZXnhkHRwbr2foij18Up/x+m89FmWOrD727E2orv1DGcgE0J7734VhSSYcTroMcor6YrM3X95ZcHH3Ow98Zp2qad+EQgRCPZfAMAqaXRnivqQmfCACzMfMv8ZVwm2xvj5O2zNA5qVBoOQBEbHW2lM8Pas1hSea5SJEGhe9XDXCsVe2eJXYXDAaPhqe1phoYAvvH2ZamnN22hXINSPrcKdPk3HVqtNI7dAEpy2iO9OE7xntbhiayZslNDBRt/HynOTBaesPSjZp8MkeabDX1Lo5OKYfbL/F8OezqGl1vovDeoqI+ysee1TJqQr3GgQ8LOeoDZWE5wYC0+oEJR7TZw4FbSZrABDyuw76jFSyzBeGGJI/pAJ68XfAfdoGa3pt8nQbxZsTtus/tZcmiq/UF4Z/xubWtvbJqX2+AeJA+Lr9T1My4rPueVr3VAGQAf4P+S9N0TDXErQ98976CkwP+KMdbCRAtOZ2S9UZJ3tQtztMhg6Czwo+GVCAYC2GjV80HLdm4n+9JuIAYkx06Z3d9CfcI0VH8S3ROt+Fd1rEvUiBKiZ+LGvHN+omrPSssmfdZz/ZM6lk6lBUx9fKZvucyEpGmJnSU6KB47lGGw/xa+JzFtjBL7A23zAfScJDZU7J9BqA5Vz2lFwerczHp3hKcuzEFi+JFRJMtvJhtRQUp/68D8i9R3m1Yz43duyYYxYStk/MXnF+zT3d3W9KIWKx+bJeEAKVvvOFk/ZFLSIseYidV0P7jAn4gNNLPAwyxx50FcOwxFxkhdS8gKbN7AmnZZnKSQP6OKfSxMSuw1U5dNVETY7Vq1W+W0WkP/8m9QCuhoXDJeW2HDjo74OYrQ597fNZGt2fdWKmI4EQAF5pyYPoL5fbsYsB9I2BdkDsrZIbIuB2J1UZKZ57aefZ0DxHruQFwJzeeeTd101a+PgBG3vc27BXhm16TRv07yHJqFKGFWFx1JPvn3
 9vjyAUPl
 apQwS573zwVAF197NOoKl7WGr7VP97IBZHCjRFuz3v8YRRfTHt+T3116rUSCVHlLrjl4xkycZzktFDLXUEergi+wvQAXix6hqoFuX2skYckMmRQ777+r2J9OOXchr9rGmt0rae39SbwueOyXIpVCzIKDVkDwbw+bBtG/Mz7Ruim3th/iv7f6XBxMNLXFcivrA4naGh5Jd8uhoEDRAqrBS+kqw/nc2l2oHLEPM3QZCiKLjd/vujm0OSV5l9B3rQh2Cz635n/m7lTyjmayt1Veqj9kVj2n8lcS/HcGg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

All the tests that use HugeTLB can detect and setup HugeTLB pages on
their own.

Drop detection and setup of HugeTLB from run_vmtests.sh.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/run_vmtests.sh | 128 ++--------------------
 1 file changed, 9 insertions(+), 119 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index b42d19036182..7e0c379e7af4 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -157,60 +157,6 @@ run_gup_matrix() {
     done
 }
 
-# get huge pagesize and freepages from /proc/meminfo
-while read -r name size unit; do
-	if [ "$name" = "HugePages_Free:" ]; then
-		freepgs="$size"
-	fi
-	if [ "$name" = "Hugepagesize:" ]; then
-		hpgsize_KB="$size"
-	fi
-done < /proc/meminfo
-
-# Simple hugetlbfs tests have a hardcoded minimum requirement of
-# huge pages totaling 256MB (262144KB) in size.  The userfaultfd
-# hugetlb test requires a minimum of 2 * nr_cpus huge pages.  Take
-# both of these requirements into account and attempt to increase
-# number of huge pages available.
-nr_cpus=$(nproc)
-uffd_min_KB=$((hpgsize_KB * nr_cpus * 2))
-hugetlb_min_KB=$((256 * 1024))
-if [[ $uffd_min_KB -gt $hugetlb_min_KB ]]; then
-	needmem_KB=$uffd_min_KB
-else
-	needmem_KB=$hugetlb_min_KB
-fi
-
-# set proper nr_hugepages
-if [ -n "$freepgs" ] && [ -n "$hpgsize_KB" ]; then
-	orig_nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	needpgs=$((needmem_KB / hpgsize_KB))
-	tries=2
-	while [ "$tries" -gt 0 ] && [ "$freepgs" -lt "$needpgs" ]; do
-		lackpgs=$((needpgs - freepgs))
-		echo 3 > /proc/sys/vm/drop_caches
-		if ! echo $((lackpgs + orig_nr_hugepgs)) > /proc/sys/vm/nr_hugepages; then
-			echo "Please run this test as root"
-			exit $ksft_skip
-		fi
-		while read -r name size unit; do
-			if [ "$name" = "HugePages_Free:" ]; then
-				freepgs=$size
-			fi
-		done < /proc/meminfo
-		tries=$((tries - 1))
-	done
-	nr_hugepgs=$(cat /proc/sys/vm/nr_hugepages)
-	if [ "$freepgs" -lt "$needpgs" ]; then
-		printf "Not enough huge pages available (%d < %d)\n" \
-		       "$freepgs" "$needpgs"
-	fi
-	HAVE_HUGEPAGES=1
-else
-	echo "no hugetlbfs support in kernel?"
-	HAVE_HUGEPAGES=0
-fi
-
 # filter 64bit architectures
 ARCH64STR="arm64 mips64 parisc64 ppc64 ppc64le riscv64 s390x sparc64 x86_64"
 if [ -z "$ARCH" ]; then
@@ -283,29 +229,13 @@ run_test() {
 echo "TAP version 13" | tap_output
 
 CATEGORY="hugetlb" run_test ./hugetlb-mmap
-
-shmmax=$(cat /proc/sys/kernel/shmmax)
-shmall=$(cat /proc/sys/kernel/shmall)
-echo 268435456 > /proc/sys/kernel/shmmax
-echo 4194304 > /proc/sys/kernel/shmall
 CATEGORY="hugetlb" run_test ./hugetlb-shm
-echo "$shmmax" > /proc/sys/kernel/shmmax
-echo "$shmall" > /proc/sys/kernel/shmall
-
 CATEGORY="hugetlb" run_test ./hugetlb-mremap
 CATEGORY="hugetlb" run_test ./hugetlb-vmemmap
 CATEGORY="hugetlb" run_test ./hugetlb-madvise
 CATEGORY="hugetlb" run_test ./hugetlb_dio
-
-if [ "${HAVE_HUGEPAGES}" = "1" ]; then
-	nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
-	# For this test, we need one and just one huge page
-	echo 1 > /proc/sys/vm/nr_hugepages
-	CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
-	CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
-	# Restore the previous number of huge pages, since further tests rely on it
-	echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
-fi
+CATEGORY="hugetlb" run_test ./hugetlb_fault_after_madv
+CATEGORY="hugetlb" run_test ./hugetlb_madv_vs_map
 
 if test_selected "hugetlb"; then
 	echo "NOTE: These hugetlb tests provide minimal coverage.  Use"	  | tap_prefix
@@ -332,44 +262,12 @@ CATEGORY="gup_test" run_test ./gup_longterm
 CATEGORY="userfaultfd" run_test ./uffd-unit-tests
 uffd_stress_bin=./uffd-stress
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} anon 20 16
-# Hugetlb tests require source and destination huge pages. Pass in almost half
-# the size of the free pages we have, which is used for *each*. An adjustment
-# of (nr_parallel - 1) is done (see nr_parallel in uffd-stress.c) to have some
-# extra hugepages - this is done to prevent the test from failing by racily
-# reserving more hugepages than strictly required.
-# uffd-stress expects a region expressed in MiB, so we adjust
-# half_ufd_size_MB accordingly.
 adjustment=$(( (31 < (nr_cpus - 1)) ? 31 : (nr_cpus - 1) ))
-half_ufd_size_MB=$((((freepgs - adjustment) * hpgsize_KB) / 1024 / 2))
-CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb "$half_ufd_size_MB" 32
-CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private "$half_ufd_size_MB" 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb 128 32
+CATEGORY="userfaultfd" run_test ${uffd_stress_bin} hugetlb-private 128 32
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem 20 16
 CATEGORY="userfaultfd" run_test ${uffd_stress_bin} shmem-private 20 16
-# uffd-wp-mremap requires at least one page of each size.
-have_all_size_hugepgs=true
-declare -A nr_size_hugepgs
-for f in /sys/kernel/mm/hugepages/**/nr_hugepages; do
-	old=$(cat $f)
-	nr_size_hugepgs["$f"]="$old"
-	if [ "$old" == 0 ]; then
-		echo 1 > "$f"
-	fi
-	if [ $(cat "$f") == 0 ]; then
-		have_all_size_hugepgs=false
-		break
-	fi
-done
-if $have_all_size_hugepgs; then
-	CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
-else
-	echo "# SKIP ./uffd-wp-mremap"
-fi
-
-#cleanup
-for f in "${!nr_size_hugepgs[@]}"; do
-	echo "${nr_size_hugepgs["$f"]}" > "$f"
-done
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
+CATEGORY="userfaultfd" run_test ./uffd-wp-mremap
 
 CATEGORY="compaction" run_test ./compaction_test
 
@@ -393,14 +291,11 @@ CATEGORY="mremap" run_test ./mremap_test
 CATEGORY="hugetlb" run_test ./thuge-gen
 CATEGORY="hugetlb" run_test ./charge_reserved_hugetlb.sh -cgroup-v2
 CATEGORY="hugetlb" run_test ./hugetlb_reparenting_test.sh -cgroup-v2
+
 if $RUN_DESTRUCTIVE; then
-nr_hugepages_tmp=$(cat /proc/sys/vm/nr_hugepages)
-enable_soft_offline=$(cat /proc/sys/vm/enable_soft_offline)
-echo 8 > /proc/sys/vm/nr_hugepages
-CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
-echo "$nr_hugepages_tmp" > /proc/sys/vm/nr_hugepages
-echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
-CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
+	CATEGORY="hugetlb" run_test ./hugetlb-soft-offline
+	echo "$enable_soft_offline" > /proc/sys/vm/enable_soft_offline
+	CATEGORY="hugetlb" run_test ./hugetlb-read-hwpoison
 fi
 
 if [ $VADDR64 -ne 0 ]; then
@@ -464,7 +359,6 @@ if [ -x ./protection_keys_64 ]
 then
 	CATEGORY="pkey" run_test ./protection_keys_64
 fi
-echo "$nr_hugepgs" > /proc/sys/vm/nr_hugepages
 
 if [ -x ./soft-dirty ]
 then
@@ -545,10 +439,6 @@ if [ -n "${LOADED_MOD}" ]; then
 	modprobe -r hwpoison_inject > /dev/null 2>&1
 fi
 
-if [ "${HAVE_HUGEPAGES}" = 1 ]; then
-	echo "$orig_nr_hugepgs" > /proc/sys/vm/nr_hugepages
-fi
-
 echo "SUMMARY: PASS=${count_pass} SKIP=${count_skip} FAIL=${count_fail}" | tap_prefix
 echo "1..${count_total}" | tap_output
 
-- 
2.53.0


