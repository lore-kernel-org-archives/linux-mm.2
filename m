Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2569FD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01AE46B0089; Sat, 28 Feb 2026 20:51:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB5266B008A; Sat, 28 Feb 2026 20:51:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFF976B008C; Sat, 28 Feb 2026 20:51:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE9216B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:51:24 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A862140361
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:51:24 +0000 (UTC)
X-FDA: 84495816888.22.D15193C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E7BA340007
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:51:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TsbMkB0/";
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xuHzCQ32whDVHGqzqbEj53Oth1pIr3Bd6yC7brU9gC8=;
	b=MoybK+tqtyq8oUIldd8pwlv6h3BAiCpoFrlIZ/eYGiI2Q2/u9lej0ywRJ5cTla4rnesJj1
	fm2nKryMgZrPa6+Zpn3QmCRd1ytM6nEcmZ7CGjeFPlIskYEj0AhNZWTz2JY8M8PXzkVote
	bAqM+YhVF51RZOMrTwWcRp+7lFA1I1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329882; a=rsa-sha256;
	cv=none;
	b=G4n3777O8TkeXBeMaAPTA9LirTOnTOaDJbMHuEDh2EDurJeRhUxV0KE+spbevrdxKk4Wxb
	h0wvsJ3xnTExU1HHM5t4OKnYHHHUqAEpMmIeD43XJJ0eI2QqmnQkydFCXk28ABcCC4S0JR
	4VaSg7YhKnFErWJhKx4Gv2ppYLa9Uh0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="TsbMkB0/";
	spf=pass (imf11.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52BAF6012A;
	Sun,  1 Mar 2026 01:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1714DC19421;
	Sun,  1 Mar 2026 01:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329882;
	bh=mOv9TmzW4EzgZxb7ueMc9wjwZ3QQD5/AONsSGNpFwdk=;
	h=From:To:Cc:Subject:Date:From;
	b=TsbMkB0/I4ehqS9VvETUbluDIw/2VgyRpwEWjyWVu4AV+5z7sCMJM5Hif4PlE5yp8
	 af88wp3NQtj+0hCWZpetaALNQPlR6Gt4eAPjFvl8L70UwFH3HjnDr3eaQKS3+vcLw0
	 wmRiPd/QTc4zB7EdbxWPSToBwH2L/jwaxklY8sfycXb4W3Fz02ESbZVGMhYaQUoH/y
	 hA1+4z/Pg1rBV/IT8oZCm1Y0RkfGIpj/A2Y6+X7YfCGGmi50YFMl+cbEumexKpf3kX
	 5LYgXxkaEqIwqilSaRnp9XmlsQQjaF+0pm8HO6Hzm2640LZUqw334aUwFYNXTX/YDp
	 R7Q61vaAQ+3aA==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	liwang@redhat.com
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: FAILED: Patch "selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs" failed to apply to 5.15-stable tree
Date: Sat, 28 Feb 2026 20:51:19 -0500
Message-ID: <20260301015119.1717595-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7BA340007
X-Stat-Signature: dqdp45abastrkphr89194uneorqkt78b
X-HE-Tag: 1772329882-89986
X-HE-Meta: U2FsdGVkX1/H9kuTmkWxJ6rj0qubN7+igATk4Abz3bwPLKcdXoUp6iITFMmp9viIJoIUrv6U8V+jLXjlZaL3WvjBjvx5wzW1U+Q4vqFveQTif48MarnugVgzhAdFIrzYTwHlRt0fRHumpfI1gdpJEkwtSKM7rZt3so6yU7aT7NPy60W6JaeNL0nOrrv5MBhvvpjiRiCB+biqCAxF8/JjSs2u2nii1WIJLiD2FYg5vLS76ZzUp+GXsHQmSWgLYsMk3CkkipCU0FPJsZV3yF+V3fS/+u9xBKQb02OMoYwNPZhZyO4VyBjrhOOW0KL9nxgLN58PZbf5kVgGkgUaveAl1ssBQaJb8wrEKLcg3BCpakxKUUh2N2i6/qoM1oEji2A6K4w4QA87edN9M/lc5RQZnWnIXb4vO8wgSIRoESWXPnGsp56qVU7KwmPtyG8ArZ3St6sQDZTleO8rZzSLYDmaol4ngQMNuQF1Pmi9pel7YxfeaYltPl2vjNJz4P2zWgKSSOPZxdPa7st439urAX6QKMSLEPeNoERizDnTBiUzxPIAhXKfOasz82jP0F3mMU7PidQOzSVM6K4Q2JPaPzZdBBMKF2sM1EYNeW1E6WV6DtuFJuRUvOTkP+rKmWeaKDpKoyTj85mfQ3QDcTWbHwt6nlx29ZCIrxQ+KF3ifIAD8qFi2nyG+Rm7VTfKhfPumJsGdvcu31CUqEPF5fZA4sZAnIQCnI7+o1CP7xMQrstsn+Ucj++Sxmzr9y/Ww55bnN+x0EvkU2jvuaufNOsOVTDRhDA1DW9swuIP5Sup/+WHKvp39viTYBaBqp4sis80TOT01iRIMtbcdYtE2nlABUxSO23r9b/KrLUq6H+NCZ6e0w/yrzJIHGPmvyr+U3t4eoJrU4Rw5qie1J2LFr8VgLcE83SOYeVWAco6lKkXSDYqAAsBIpooqFVBRXemVmnrRjIq6C1/0SJyghRHQPVedL5
 ksDCf7jb
 ABsqLQkD5gecnXD6Tbnz194H2YCSL1Adf9XIQaIowlKQal0IfcPpndqVPSAC5YklPHUJciYtPbXYdFR8XwO2a3g45ak8YFmIaa9n74XTu3RJMTZJ7J2gy5Az4NYewK//BmXAg1R12HUk2lhiWy4mmusVX/vOt/6wumJiCRMEA4Wn+daJE3yGE1lzjqJhGY9bgELw8oqyYr2OQufI1BFmSYcmqCl7yQZvR6Ct1rPWRjpHfAfyf4+Wce7vwKjnBwfb7FwCrX5waXR3/5QNY8kom/fubjBrgCmNOXah66zoEyaXvjoOIMZ92AhtejC5lM+qwutSmf55Uz4OVz9XCZE3HZBa9UEada/S3zXXcuxhQCe/5Kuc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 1aa1dd9cc595917882fb6db67725442956f79607 Mon Sep 17 00:00:00 2001
From: Li Wang <liwang@redhat.com>
Date: Sun, 21 Dec 2025 20:26:38 +0800
Subject: [PATCH] selftests/mm/charge_reserved_hugetlb: drop mount size for
 hugetlbfs

charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with a
fixed size of 256M.  On systems with large base hugepages (e.g.  512MB),
this is smaller than a single hugepage, so the hugetlbfs mount ends up
with zero capacity (often visible as size=0 in mount output).

As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
waiting for progress.

=== Error log ===
  # uname -r
  6.12.0-xxx.el10.aarch64+64k

  #./charge_reserved_hugetlb.sh -cgroup-v2
  # -----------------------------------------
  ...
  # nr hugepages = 10
  # writing cgroup limit: 5368709120
  # writing reseravation limit: 5368709120
  ...
  # write_to_hugetlbfs: Error mapping the file: Cannot allocate memory
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  ...

  # mount |grep /mnt/huge
  none on /mnt/huge type hugetlbfs (rw,relatime,seclabel,pagesize=512M,size=0)

  # grep -i huge /proc/meminfo
  ...
  HugePages_Total:      10
  HugePages_Free:       10
  HugePages_Rsvd:        0
  HugePages_Surp:        0
  Hugepagesize:     524288 kB
  Hugetlb:         5242880 kB

Drop the mount args with 'size=256M', so the filesystem capacity is sufficient
regardless of HugeTLB page size.

Link: https://lkml.kernel.org/r/20251221122639.3168038-3-liwang@redhat.com
Fixes: 29750f71a9b4 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Li Wang <liwang@redhat.com>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Acked-by: Waiman Long <longman@redhat.com>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index e1fe16bcbbe88..fa6713892d82d 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -290,7 +290,7 @@ function run_test() {
   setup_cgroup "hugetlb_cgroup_test" "$cgroup_limit" "$reservation_limit"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test" "$size" "$populate" \
     "$write" "/mnt/huge/test" "$method" "$private" "$expect_failure" \
@@ -344,7 +344,7 @@ function run_multiple_cgroup_test() {
   setup_cgroup "hugetlb_cgroup_test2" "$cgroup_limit2" "$reservation_limit2"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test1" "$size1" \
     "$populate1" "$write1" "/mnt/huge/test1" "$method" "$private" \
-- 
2.51.0





