Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587F4FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 02:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C7626B0005; Sat, 28 Feb 2026 21:01:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 974DB6B0089; Sat, 28 Feb 2026 21:01:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 880BC6B008A; Sat, 28 Feb 2026 21:01:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 774C86B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 21:01:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1C61B1A038B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 02:01:23 +0000 (UTC)
X-FDA: 84495842046.10.A508927
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4D2A1180008
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 02:01:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXnp+zrl;
	spf=pass (imf06.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772330481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yil17JTU4WotYeV3qKnXEumDqxMMFovN9BmpcfHKvlw=;
	b=qAzrdKLHso2ryRq0oQLuxNOMmsZmk2N6ixikcwIMWIwpd6ZIgFIXeiRPE7bf0sGmNB3DMx
	hJXj33GJOZoSTowTU5L+rGoc2MWQ9z4F7X8z3I7PyYiOxPj31e9/WNKIj3dEBJ1dVLynmj
	DtbocbbiD2LKFCkjeuS1pCvdOMXrFdE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qXnp+zrl;
	spf=pass (imf06.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772330481; a=rsa-sha256;
	cv=none;
	b=2QzhMx5NvCAg+MarmuIpeFlTCd19+l4CRi0cFYKuGmPua0sxpL+Skow5Rux3fizZS2ADgL
	JfX/HMy2fqm3WqhBhS5TemOImSv4+6kqNhB7eGgc9LBXqRBWKwDa/ENQ5HVaMeprRqYzTy
	ivOvEigxtFUN0Jot4n+mZucSosF8t7A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BDC1440C6;
	Sun,  1 Mar 2026 02:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C454C19424;
	Sun,  1 Mar 2026 02:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772330480;
	bh=hZkPE5CNYOyIS3Bm8o17c+JUNwunD0H7xdisOEU6l3g=;
	h=From:To:Cc:Subject:Date:From;
	b=qXnp+zrl4QCHXk1Fb81p5jf+RilL3eQT7ozDs5GdG1kJSqJxhLkRNkHMkzpDnsBh/
	 o5C7dsjp1xyB78YxCKqKlzbiz3QOdRTSgru1qP2aJlD1Wmy3+lXYhPt62MGrxZzpe9
	 /avbdgJ8Tb+b9lRpFutiz2KjW+ke5PIXrzijVi1i5dcZYykM9hivuPOGEQXrTbqxmY
	 vm1vx6flQg57Gkz3Z7SYjTIh0X+5vQiKGznMOazSBGvH58/sKlcD/LPJXlvyQSIc+5
	 JCt6XvUlM6TsY1+2TWa6uor78xq89HZxYs8C8www3RN55fKeN5645k/pcq03HEt6VI
	 7eVUBNI01NArA==
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
Subject: FAILED: Patch "selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs" failed to apply to 5.10-stable tree
Date: Sat, 28 Feb 2026 21:01:17 -0500
Message-ID: <20260301020118.1728520-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4D2A1180008
X-Stat-Signature: u7dpywryfny1iem73arqdbd83grcipra
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772330481-438601
X-HE-Meta: U2FsdGVkX1/IZOXr8TNM5wNxkrfyLWFzGFA5QIPX4CA9KxVYLSpN+x6fSYaxfr6gqfe4LYOKj/6gy6AN9mxrznA+vbejh3k1ivpaGxH0omhIvN8ROs31agldH6DCbxEbm6+/AGC4ql0kMnvtk9KgMeni5bUIm6OTfhzSXUNLBxOVGjsN/tp8nZ+6NIPwbeM4t+LtipQI/Po5U3B556CHnM86pU49o3oSr+9YZ7vS6SrxW9lj4qJfbydPtD1MueP620HTZC0JZb8WN5e4ZBMmwZyzrtBMXq6LKvWqp63DyQ9MLIu96WmU6ZsWB67MCQoxq7ncGRSc1Omwim7xngu5Rokin90i9NBkGV1gnCypEJs2AOEMrO+2XulmPghzPvhZWab9PQpVtgLjq1xwCUXs7tecFMR6b+WehnIdutwT07MhVYR9R21an4ut623vWbvC5apQ13HuIM2DpjJ5l5qPDnDxAU3xghcu6ciwDZk4wYgLqzW9tMTJmcOK0/bFMn+lYWPdBkZ07T5C+p0eG1nwJLdYLDGZDrd2LynosnfOmjvRLy+v03ZyduBc/wr0bsd7KQaH1Ed3g9OVZKc8Ydl2oKil/hLbF/SGkdP9b4bb7oYkRGb/43cDztR3D977aQdRWKkMtrTtJcVCwWV2VwCSpbqPOhX0LnHSG6CBXYcvdSFnKxfcsm84uOwluRdsEaPPG0u4YImwuHhUmTQNeYWJyxzpbJ4oBjsD54poxOpKnI6yUyaPrqRxQjbU2qgFL9XT10Nt8gVzyZ6lqWT0BJ9RsIGHqSKjMnkGSLBmDO9/pXDjwUf6V6c1CiwaJOwbVlpDvjdULuuDGp1ZuoRgIvM/CSt1hfhaOME6RjzGianbjhCEsDdvdGo5ZYycLK5Kv93vC1/s9apNpc/nZ0Vzjjb6Zw7MaNMQ9JIGcs7U/F+T9nees1VfZzKSB+n6MgNBs1xAlShMrPd1Moj2+5k/qSs
 c1aj5SAE
 Uk3lFG5MP7CFi1sbhrUs9gBGF69uhoshorsG9Pxp7xzveaLfM2dhEBSFxqsk5csbVheLNuKGVQu3N0NmwB7DN+5P04mtwKBFxSLdBupk2CpFWrBPIRIsO7oFsEE2/0x4c8Kcp8LDk7cngQS7gxObzjoVZWCteMQDhH7wicGISwM/SHQXCwljjW0fpK3FK4TnvLOkh7qfx+dSE742uvYvCZrcPURUIA93cMzBB6lf8bWqKPiXuFiQ9u80WFVOx0/N7uy3ZYIKLOQyZmy/cTufDpFJXb8yKDwQDq4h/laENx4XQx7C+qLm5LjdMH5+/Sn6uz5ktMi1YIx5RBOb4zv5ut7XmCJ53ReYj+0iGoHYnQZ5ubwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 5.10-stable tree.
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





