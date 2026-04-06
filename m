Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DD5F46C45
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FEFE6B00FD; Mon,  6 Apr 2026 10:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6EA6B00FF; Mon,  6 Apr 2026 10:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814226B0100; Mon,  6 Apr 2026 10:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 717346B00FD
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:22:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5843156EDA
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:55 +0000 (UTC)
X-FDA: 84628347510.15.14D9959
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9832DC0011
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:22:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3Kk9RhU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfVuu7VhyD06W335FVMUaaQUivlN5wadRMCJaI/415s=;
	b=eAkNaFUv1PXxOEXKb8WLu/m5hNVjT2zo/4v59D+6TrZiTChlhhsrtDDEVrAQ5ZC1uskaho
	PPbC4RCVgPLyvYNnfhw3z3WiGoIehNk2SjBBUOwlv8MCZbenLnDRZv3/hB33LR2j5U0Byr
	8PbcYenGqbWxADVYeuqDXVrKf8qRdEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485373; a=rsa-sha256;
	cv=none;
	b=k1S27wl4YHtdR0Cz+DUGIX7myr2g+JE7MMNUI3IuguHzMVbfUx5UOLtji2JeDTWReBEcYB
	UupHX1tEzTeTBmev/alsoNARNPZK/0KsOgP4KyUUkKQ4HGEH6fhOEEccNEzznGt4LUeo2f
	ggzct8Lr4HnKqYFDUTfaFwqBr29Q1is=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J3Kk9RhU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A0526012A;
	Mon,  6 Apr 2026 14:22:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9317DC2BC9E;
	Mon,  6 Apr 2026 14:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485372;
	bh=sZoUbqG9CxBotaWHnOZiPFKTeBgb66YHvpq2HPRKqX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J3Kk9RhUvfGMtcs9qRAEkmrUVJwm0etJxgkg2wBysazgb8bchQM9eu35eExUkxx+P
	 DyZrrIUpNMpM3TE4RYHQ5Ns0uzyWv/Uu2xLiMwusvOKTZinc/D4EYJhFR+ziSNtw4e
	 z47lvoJg7Ju160XRVuqJRW2BOYcfNZGpQEJjYaa/bLZNaCTFIAeEtQG5Cfr9KHs5ZB
	 PoU4dRg6WAXzIipNh+3SwGvQJ8txQkVrV/ffHoS+NlspiNoqpWXNbgpyur1X8xPsu3
	 WPwdkcHeUIjTTYmJCW9QbhkNLORuIRfCjtEDvYp1toBXDuab4g5jYWjJOTnJjj2IiD
	 V58SeHdkyVOJw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 53/53] selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
Date: Mon,  6 Apr 2026 17:17:35 +0300
Message-ID: <20260406141735.2179309-54-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9832DC0011
X-Stat-Signature: 5o7337saktr86hj1heddbuczds4u677w
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775485373-782802
X-HE-Meta: U2FsdGVkX1/P6pFbR0YADqnci8G1lms5LgnRZ+eDNnssG3fDlAf/Fr1U7c+QvJDaHaGHXc7aElchVpfNEpWimhPN9w5gBr6R9YINDtBxCk5kxFfenaHSU7JctV4uKnrjOMv6a7nugWSpDjAOIUaETpCE1WZmLf8RmQ/y48p7ZJdKLgwmF2xyfkMkbq950RzMW11jsOA06os764i1SfAOABkOBt+pq3K6MUTcUuwmnubhpHT9uf4ZeuEws01HnfizFic8fEyljbj72OHDABSFnjGy7TppjvFPeRSiIqOLzAviu7gq7u3BRPGxxnlAQbkwsnOO7pYeFdbmyQFvGDF7hkXc8BPYVNNCwMg7YW3zs4Y4/GEh/V0qhqlWIiWDeK1NqaIRrQcJvyCSLjiMNu81WR5QP/ziHmONUikQjy/KlWpEgEzuFPY5MdtXzv3zVd4qfNz6bbEqTJVikIAWQulGc6yOzO0/+wCMaDtd7SaA+rhM7iL++jaOFF5xsvl1Y1Yfo1m5PnS57WTfD/5lWbIWuT4YZA3iaoUhrjyTRrIV7yP+JAPmKRmYZJfUEQ+ToAulRrt7KNA39Bi+RJjcddHfvffrogMgdsvx/gwsXV7CBUqxNHPpTIjdX8C/L6jmmfU5TcIQI+ScyUS0rNv71eN90bc5jOgsuG4Ej3DzyIvR254yUybT+1BI/XnK69JeOOychTbL5RdvmAG0DreomeikjPvSOFfw6DNLPLqS1gdicPkMiy0qrW63NrWQdHo4uA+uMZw3Qn4L/2ZvxkceIjNT+ZMhKMRyoynvf6+RY5NEkIsRiulQc7FWeKBcNEqqh6REegvB/kYAxOGVg5enZVrTMdJPKk7/tmdY8bRJ989gY17qaM/NzTVHMEkap/USgXk3EmnZMqui6qB/mRZL6ddAUiF/n/Z5uXIVt26tyjZJ8Hxz/FR9BF2ZMe4Bn0gMo+V6zb+IQCgGh0u+2rp3eVd
 vOMa4DJM
 MyiCh4xD2TYndXmQEsZk69pYUHWnoijzWSVqGfiHApCDbaW9gdFFAu9rrXzBrfXIw8sIbZB4VvYgVqcMg6WN0aZTDqBCJUHM02T7RpNAUjAQeoLeyYdiEIB/86S8XBlTijVG/I+AHaMsluZn1y94bpfarA1yuiPtM1VllhZRgjmu6z3jyUxD6dEu3dv9Pl07aPxEsVf6dJUm8CJCkxIVFvQyct6s+KCOX7cfFHYVsTuNCUGVkiPJgQOV3gZReVMrg7C7WTrfck/0rGfwe5GPI2BIDvZ/OcSF3X9qh
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


