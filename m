Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 49446FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57DC6B00FE; Tue, 28 Apr 2026 16:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2F986B00FF; Tue, 28 Apr 2026 16:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A45936B0100; Tue, 28 Apr 2026 16:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93EB16B00FE
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:48:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5D03E1603EB
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:49 +0000 (UTC)
X-FDA: 84709153578.25.231E88C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B219BA0006
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:48:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEwvk+c8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WfVuu7VhyD06W335FVMUaaQUivlN5wadRMCJaI/415s=;
	b=AnofejC84U2Ve7e63sCCZUqbdspi7Scb5AMdD0LrfaWRIu3ZsIoe+6BKPgg0b37l801Z5L
	51I7X6LTzU7AZnHKFujtaYGASgEZyVuk/syVleFKwBKv41keZ2DBlv2UBUYf3Y5ASo5HNc
	rtjWfqLXFr3QHMogerTMlFbO8vKa//0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409327; a=rsa-sha256;
	cv=none;
	b=uF1lnLdYddzOXsnEzlQRZWiULRlZUEE5R4zVYVLu9D9RgISLq0wVP9MsFJouBsSvMuQi7Y
	9pvSfvvbQDfLSW5eIdGk50q0gJ+7Ofx6W66RxQHRSa+HV+UCY5S14L3Hi4mf8gX1bjxSnF
	HcCNNjtPM57KKq6F6FJ9F2MCyp/sh1Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BEwvk+c8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2470161119;
	Tue, 28 Apr 2026 20:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0401C2BCB3;
	Tue, 28 Apr 2026 20:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409326;
	bh=sZoUbqG9CxBotaWHnOZiPFKTeBgb66YHvpq2HPRKqX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BEwvk+c89LXIHHCN4f4+Pq+EZNnwtnAEh4uQfFVWCsMySqE6CEf3Zyl21hKweLePx
	 QTen65EdzL7a0w0B10gW3pGXeKM1OaZppOW2E1rJi6+9i6Ri394QYTTjA0KbveQ749
	 n+ukaoBLr/8SEUosGjg0ZiD3nTontIjbw+DDyEeQtOe31/UdT5ncNH9cRoagF0E3qN
	 iDIqSxmz37VI8471rn/QiADf1v6JpmoBierHgdYLgEW3Ha5d/9hP2ElN0wZoFspVAE
	 MRZc13pYZLOorECpjjSqnX7REv2Mwxt5BxDR9zjP3yNeukhpr17mQxNJF3vyFpVIg7
	 KcHpVou0RUFCQ==
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
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v3 54/54] selftests/mm: run_vmtests.sh: drop detection and setup of HugeTLB
Date: Tue, 28 Apr 2026 23:42:40 +0300
Message-ID: <20260428204240.1924129-55-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B219BA0006
X-Rspamd-Server: rspam04
X-Stat-Signature: dporuxq4japjntg6j3sx5c7mp3gf86ff
X-HE-Tag: 1777409327-346605
X-HE-Meta: U2FsdGVkX19JWZE7vxbGUKIyh+ZWAs8fyJDT9sjyQBhgt23aOl4uYReiJQVHu7ekSvJ0gwCYEN2mTfHzA+G2K1z+PHwiWN/b2w5+BqEH4p9up0vtxsHQXg9QU3h0Nfsr4jYvFrqTteFKLBZiF1eVQce32Vx4SXBi0zMVej5HShNemXHyLAB0LbezU7TpG4fq++RmKsdrHnI3APpf9DsubohkUrR7C3rKzKcoIcNuP5j+Yl9Vf2bud7+Iax9AwcjB/ANU2rlAd+LfnMecqqNP+DCThQdUVTLsEYy7k89AP8w4Bb0qWY7HpRrBgK02+P1wZLRvjlwkVkgygg2jnNNKqSkNxPN9WIdyceQb1+EPSErStMkkN8zTLZRpQ27SuDetX5uVFBrvptyzkEuX4UdQh/5pbylw7s1IxePbmfBTogSNbk+xw7EsAGRBRvlva3WSFMjWPy/Oz1/U3rFPDGMOb7AII7jmMDnzOjyBfdKvev12twIVMYoVW73kk07k1fYSnhzc/vdxnRiy+uR8QopkOLUl9yEsGaQ+b7qygfkpidEr1VX16KeS7v8rxAkt0BMAgnraNvzZBUnRqlQzl2Y2gwXRb1beRdE6EEbOxrcCo7t5q3tSb6H4mZ76euKn07h02PCru7aXDTb2vnK10wm1uGxaIzIgpDIfkiIRiaMk/eaEBMlK8VCXbaDC9JQpM7ODOg/1WSdDu3THhLzNNM0SLGUJWTthF+CjMA2i4VD3EcZgLTAItTOTnd96ddABK0SlUwTsQ62kF/eoeMhxqBf+iaX2tFDFFmVh5852gg9k79Rp9eKMqFYHTPvaL0iShmHgJg55kHA8/87jfO4NxVbWWjb76oIwxRAunah/Rsll8cizv9cSOCI7Gt3q48imWj8nzjhmclw+Umel0UY+IMVmOHxL3lPgq318rzKNEERppDcNkvrJxLGJo/eba5HvUAQeb+HEJWIY03kfWDpxOSC
 Qi+LJSZg
 5Ra9eLhDUu9K8W5hZ19F98KFNcei5UFlh12AbjNnTQyUUk/eTFuCdqL3X3gIglpwz4Kcx6OKrGj8SMBbUB7IOPSefOZ04U0TJ1nieRbxGhOLvxstJLwjwzoELt4kPvtR8HgY/wd4ax9uFiW3TWcBEaabu7zQCmDbp4ZaJFCvio1QmVLzIPUJD4GOhbho26Gqs6nOctq+umQzM6TwGJsm6r/9KZXeH/LH9ejyaoWzZuy29+PgXHniMieo+c1um9fZWcCdOTIvNxDbENtZY4gotQn9ndA==
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


