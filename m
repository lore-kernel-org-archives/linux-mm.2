Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2583FD0045
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:42:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253816B0005; Sat, 28 Feb 2026 20:42:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2011B6B0089; Sat, 28 Feb 2026 20:42:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10D7E6B008A; Sat, 28 Feb 2026 20:42:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F281E6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:42:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BEA6C8B71B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:42:54 +0000 (UTC)
X-FDA: 84495795468.20.512388D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 06C648000B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:42:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZHCLLI/U";
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772329373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0gn7XubeRvVs4cUcd67uBsgmseNEKJ5CAJ7229keyMA=;
	b=jmI4dFVIRJRF3pBQVt00cQCFxG3swqoNrJH5OjQh/NOT7Vl+/Hc/JEipLPQ3N6BHXDnHiC
	xrZaFOd+lJnw6BuI3wFMDrxIu3GlBQR2bxdrXc32Zdjcd3EzeYNE6JISZeiwSPvFzBunrx
	9jSmBscThbh1eY4rWEE+PAp/pbQU5YA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ZHCLLI/U";
	spf=pass (imf02.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772329373; a=rsa-sha256;
	cv=none;
	b=XIiV9Yn8U7WjAFC9jYn5dNj1VPk+joancxgNEExJqHnXKyCL8y4BUz0qddph+MWMmAxO8s
	eO10EuezTG2B7rbXoWMU9xT+/W4p8YvRWc5FfOcKaKp+YFMl5t58a3BMXzoYgIOKtl7UvQ
	5SQJXoqUfl8D4emo9KmpKpEtMs5qjy4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 099184444F;
	Sun,  1 Mar 2026 01:42:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB3DDC19421;
	Sun,  1 Mar 2026 01:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772329371;
	bh=4GzTjtTNh8taMttT7uCdXqqruh2zLyBcuZ7wkCG6keA=;
	h=From:To:Cc:Subject:Date:From;
	b=ZHCLLI/ULZkUg//ReNcdrbKh9ukp3bUwp/D81avU9m/fjQRr0n3A19N1FJYM85bbS
	 VD65DZAv+Ixahs1QGLJuYpllmpns6isegyhsFsUGastD8sfW0t3nZqtXINk6igGAe5
	 c/x1NUzBVl88U0pJr5ClX4p5PQRinlBP+JByod5Oe4H+Fywhtq3cuaxRcjNPKIxfgv
	 djhQR82KNf4C04WORWX0LfDpZ7xG33qD+ws8+SiaDgKaFH2icNlBvjXQmMFs0UQadQ
	 o25KisOVUl6ljv+VEBV37BOkMlouIoPp+BmLXJyTiho8P4tXBmN6Qvuwc21Dm+z02b
	 yE1i8vyt8tnoQ==
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
Subject: FAILED: Patch "selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs" failed to apply to 6.1-stable tree
Date: Sat, 28 Feb 2026 20:42:49 -0500
Message-ID: <20260301014249.1704776-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 06C648000B
X-Stat-Signature: 44owx5b9qbfinramdw5d3wk54px4cums
X-Rspam-User: 
X-HE-Tag: 1772329372-36728
X-HE-Meta: U2FsdGVkX1+7CqqotN0tFy3jsiqCioR7EUXq/41sxsRiqQnEEaGCqIkNOu07crxgsb6+TiluCsHBnsm04YPnYssAaGT0vSg8yHU+WICvmqLuE6FHi51+GRGcCOl2gaIRxGgyPv0F99Llg6SKEIGAKSaj0B36GoDKDgrhiV6UXrrblOrToGnuRJbYqC4PyHxpuQQgiYRQhy7JAK06Uf0YO1VqMJz57BCjKx+e4qxNnOMF3UA/GDGeOQTG0d1AXUq7o3pvQoSvIh+VPb6pcZItmqAeyHIUmYNpKKKqPmht0EuxFC/lsX9/UaM2+ND3xtIYshiKagh54HnX4JcsZiv4N+J+Lb5jn50CuxB0hlz+APOeJEMpjrAyxw6mKo8rHExaShYuhBo4kJUbZoPlRd+lEwwqSpZztMW7SkH1fY2yXBclPflqt22ysksRA2A6QnH8p/Kv/uAYbRT3/BDS1F0QHoIelfVqmiJ8gzjfYTlnzC9oMDIZWTI/h7LAHZVU6lI3BxxVmAPFE3oIe2KJ5VQsv8Eql3JvOizAeX4P2WqnbhEAHkQIGZ4EstxznyfXlFXmivAgS1+QJkZ/r15CDG1SaVtoIgX+8rv2R4K2r30KipaLu6o6eyvGQfVak0mCzicTIeK8SbT7S9QhzNw7/nGJaYpfzNr2C26XPWFCC0jjVXpGRQiCSpvdKkUWsfZUGpWjIuLaWmMlQO9gazYt5TOsT6ULGwoaDbVlX5ZOiqr+OPNy8O0sWYwJDJQjGlLjdDTiYKv/RgeKjx2votKqn1IqhylCBgK5srDqF4Fx4g8wjRuy551kTaMgLcfzVHcyx0IxcPjVy7a/UTiqXwxL4pCTV6ZhmybkAfPAMQe918OHB9sGhyPpIAfjz05uKN6Akj2H+IOesj37zfRr4aHr2Gf3o1iW1mRgNxHB5TrB/CEk0GquqWiRAZR+FHF6GMc+wSDRF44WM8oOxKIxiYZyUPx
 yzs1oC1v
 qCU489YSOro8Nqunb1jxjwKocuRwtLrlsJLg4gFRLoXWjzv6+0Tm3Gz43Xlpm4p+bIOW81LDjxcztNDbnNZV7wRCO7axiC+LgFcJnj1ZOpNsG92hgy34oBBNEO7HR8JWTeks4nuzqOHBZ2Kl1QWvizXwcVusdfdfOcQn626GJk9TYIg0Igl1U+0oOzeZR1whrGPKjLxeH6CrR0jDGq5nMr7T8gWBsoTSLVYl3WsGSPDZJIbc7Run4NC6aUR8k7neRuUDXr3vjDp8XISUeQ/p0tj+oonZic8mMlI6zud7QQD3BhbbyypS531qXeh8KafZfKwj1l6dDPGO3FSk/gX80sTx4BMgnvpMks+11xcoN6XIKtgs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.1-stable tree.
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





