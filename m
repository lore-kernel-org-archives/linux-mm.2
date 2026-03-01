Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2574FD004A
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DD86B0089; Sat, 28 Feb 2026 20:22:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF2F6B008A; Sat, 28 Feb 2026 20:22:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02C66B008C; Sat, 28 Feb 2026 20:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1D1E6B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:22:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9692D1A0371
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:22:36 +0000 (UTC)
X-FDA: 84495744312.26.B3A33FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id D8C831C0004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:22:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oCEOz5Ln;
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VJvE//agnmeh9R1ow2wuvX1TrZGMKcPDzFXq3k5dnyA=;
	b=d9eLppaQ+ccNbPTig3Dd52HV4Da7RSDtJkg+QOE+NVEF6srP0aUsVOIExRAXWCCaSySlZM
	9CqeWriDkDsAfOXld2QWUaPaSSlZPnk2B6pIOjtxN3KZfmYIDNnHSeGDTffDbhrw7MwN+D
	FXqQk3czBQBBqki/14X1/MsRO8vaHCw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328155; a=rsa-sha256;
	cv=none;
	b=ck+Hbi0ogIfY8CwvZ/5A6EgO6USDdaQJkz41/eATWZOSOfYYxhXQAApsyPbEcu9Saw39o3
	mRQG3Kcpt8UVoF6dnKt71Fp9bcjxQ6eKPK+5zUso4x/QA3jo21fzf1Gx43qudG01T0pB3K
	+PwXsQXHjB4Uvy8CJ/hwiHmEaOxgLF4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oCEOz5Ln;
	spf=pass (imf18.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1129743E70;
	Sun,  1 Mar 2026 01:22:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04150C19421;
	Sun,  1 Mar 2026 01:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328153;
	bh=8nmf1XPoQwDkOgcMfdXNuncBF8STkmFSbCPHKAsrm0g=;
	h=From:To:Cc:Subject:Date:From;
	b=oCEOz5LnHCrXZCNrcbNGzg7UgPh7o5pImKWwL7M/xHanbBv6HDOcrNFUjik/+e9jv
	 n5EpuVbMDl+OLORgS0iQ9Jr/0EHhMciW71JVQPgYsjQ8wr53hNoTr6b6WQWJHKZOFW
	 J3uAp3N+KQ/EN4iLn9bCkzmaMHQbZP8GDVrexvkV3qPjOmOcfWN4eNAOxDUOLVCE/4
	 nbve//lhmVzsTAMjAV6YLanW81vsq8F/YbbyMPE6QrY1CX4KgDXvg0BUMVzjJeIwIa
	 ydNaUXz9TR5U3aBR/SpB2lBg1ds7p0jo/Q5Tsz50+2IwsAYuWLomoCJFy+NtQtE6J6
	 HhmHLRxVogzkw==
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
Subject: FAILED: Patch "selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:22:31 -0500
Message-ID: <20260301012231.1678949-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7c4bc4o5zcri48mwtoekp9mjrmh9xreo
X-Rspamd-Queue-Id: D8C831C0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1772328154-251490
X-HE-Meta: U2FsdGVkX18IY6yJC0JUN1hyhaebt+u4aMlZp5sffgXQpPEsK3q6/pGYd9qzsccgul+cnGvEBeZNMO6oFpyLFzPy/5ClgJW1VxsJbx1hpq9J4OyDmJgNbCsq3R+MDssFJUbrwPzgh3cWHIX0wYftQCbIzHt+nzt5Nnqxryj/zgzB/RZLRFao9GaxkCKjo+ubCKQk69EUtPP7kmj2B4iZecuvyfjVNk45J0098JENAvuwyG35yPA8qQ405ECIM/astaWr6OAOdY1jELgpd7cKPUNLjPN0daPfiiDuq1I/0ar51qCrulkNMU0eF97t4k7NXDAoQV8hE3VHl2FSFLAvCD9Hf4TuOhLn27a7XV+S4EBksIXg+D1ps2rTcuMybdu+SZtOI/dZtbJSE5JWRItLFz46YU1IaNwlDlw+KLtdXBqP5XM0hL3KnPWUKzIQDFLy/OBFUpjFGK3EXTV520tWu8H04j09GEGDkhoZVmajYJZ6cdm9VGTj9bAqDci8aQ/kQH+6HKkoHhGeMXrbankfJQggPjkssp653HWFKXjl/1yezaTBTbTHogc+wfGy6S6po82fKd4Rr0lgHclUZ2qiASXkpQu92vN/InarrQDoSXznOhkWUjCHGwaXyid6rDlnINxahVnz+j7RJ3w18AWNYgv/nXVv59i0IoLdG6xkgB3tM24C4LbRWbkcCftJlJY1hTVWKaKtH8yy1fFH7av8zrdiTSMvdKHznrkflZBswOta0QMWeY4BGiJQZsrx4ZA3RvGTWHXZfCRuDK/lERCRh/MXFSdob+4NsaTfm4p1e6C8aJoBVSUcXzq8STuhXc64NoCgZ7Q3ciPmhaxYxObP1VxdHeuhNMsblBNrTRxHG4laXXS9Ire7QqmIvLZU4nETAmJE9BcO7mhIytUV28eaWhpsWkDNvsw7iK6HZlZ8yFJgstHw4zQoM84fAMydZCGaH3i+JDf69K8AiE9A8jj
 Q9O5B0Yw
 GdBVtJn7s67u+AHRvSUanuAGkudE/rtH21aLkQ22zHDSwc8mq6OBXGFozIVn3LKsbc2yu+1ujK/OEhvCS/bk8OJ9GKrZj9/ljqxW0MJOJPRP3gjRkDY096XOCqKuca0ilthYEKL22MzIRyh1Lf8c8+Ve+NqM3dT/XPITDeZkPmM5zd2ttrISD1OnIZh4RtjI8dtMeMoD5pHSU+7sBIhyD3fq4qF2I9AqhJEGNiOpIH/lUzyaMxg6+LW0qnGJGyYQi6o51rvq91/niIG0Ou66icIBJbk3PAqOsDoPt9MGmxevHij95CDeh8153zIajxKu/wB/2RqZv/eUOsFUseRjAG8eaIv/biceNFtVbiMj5XqLcZiA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
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





