Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C91FFD0049
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020CE6B008C; Sat, 28 Feb 2026 20:33:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23226B0092; Sat, 28 Feb 2026 20:33:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3CFA6B0093; Sat, 28 Feb 2026 20:33:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D3EE76B008C
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:33:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7ACA913AB86
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:33:54 +0000 (UTC)
X-FDA: 84495772788.24.4215166
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id BCB1610000B
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:33:52 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fLMt2QnN;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=34WBdlE6DzKiO0RkIXb4dsDPrvfDM7FgyyAdooyYaVU=;
	b=BMcMcOeMbeKLKSZo0fKUNZGoB3jsQy4JjjFy9yKyltTSydbYXD9O8kD41D/LZx5lsL6HUH
	5HKSGwCz7y4lwWxlDhdCvhR/lTPfm/mrNyrwo7jazhx8RuLFnHa6sS7kSJjZv6GHRMl0/4
	qE+icQC95ZD/eqTrivxfQiusWLgJHoI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328832; a=rsa-sha256;
	cv=none;
	b=CVtFZInNtoeNpED+yWdsixMKOJf7fwSBad5lR+ye1NmGGqo1YXNoBkItGhQmid7ZT/CCYt
	8LDDKyLY8bkVNMesPV1jKh3BCyaPLR4EAQIy5Rz/0A0qBcLJPw4IFRQ02I4fhusAJPJpo3
	u89G2iWZKQPgwfGAVra83k9FiOKynuw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fLMt2QnN;
	spf=pass (imf14.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E48A341B26;
	Sun,  1 Mar 2026 01:33:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1368C19421;
	Sun,  1 Mar 2026 01:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328831;
	bh=xCgUwPogV42OkBJoUqReJ5nIgdvO6C+Voz98jiui1AI=;
	h=From:To:Cc:Subject:Date:From;
	b=fLMt2QnNSnJMiKHYBeAjaM5al+awyjRu0DQCvnyjURPsRNrw1cDayFOHe5w4U/z2W
	 o44N0/QN8wikZvUYt8e0KTcwB1ZKpy1DFpLdmSc7eS8P3JM1gcyhwkD7xPEJBLg6ZU
	 U8PvUsI0mbnvAh7OeCpQMEf/NBSzt1axNmbfMAs5P+G0ooIGbLJVkGzVvbVgRFncTY
	 Tk9sidPRjebKOD5d9R0q814g0B7+KwpnItAhWvziOECwejs5nGx+g5Oyal10BRgmIL
	 HxaTQFbaUylscPr+0jfrhTwHKG6sIBwdJk11FdxJNMQbjZGFJIJmMYis7kZc0ZgCpm
	 MIb/Ojv0aLNMg==
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
Subject: FAILED: Patch "selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs" failed to apply to 6.6-stable tree
Date: Sat, 28 Feb 2026 20:33:49 -0500
Message-ID: <20260301013349.1693131-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: zsgst7e6xhz9x7aqkmq7dqwc3qtpawjz
X-Rspamd-Queue-Id: BCB1610000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1772328832-801279
X-HE-Meta: U2FsdGVkX19w+pn0rmoWTRDNMwfRFTKyVj0fp8ZVXhGzDcAWW2zdZlbGvo5j7zUalkTg7i5nhDDFWIAVozkGufDulGDU+xlwqf1cqQGsZH3Lk1+FFbBZqgdjSpBvdSAUipinm6Nipeh8ROnd7+995chZFt/m7hAUT33CRh7VJr/Q4yGJh5z/hW3rnpNMT6qkX1cTGLj6oEUOTHwOKukz79VFROxk5SJdQd1SZTI7jbVTNUfkhl+LlwlFe4lN8/209Md6VyHb9rqv4V422KaxoZ085h9AYtSCx3qgdCezs5eLxSJ5mOykSOcYvGiHArdzIEmOuK8/5v7WGXxfT1M9k1/jHhcZI3UZVjIyF6t7HAOUlsvquAh8P65xFLPvtBKe1Blq/O3pDzIr+ZjXiSN3n1g6FppzEoZFxj72qD7glCYFGhQ4DsNY0wpCdrrLVeGHn7Usrz4ujr6/qnc3nsQCJyo1jUReid9x0ohHU0dbgvZkXgqIjcUi733uBg3W7rBNKzSlygIXORN4SM+xqNiLwjdDOfVVeOxXZTNg5d7U5eHf5qw9Ne05GSgIjPLxJaqw5ZI4tu79UX/4ddoyffH1KSyY3ZACpDO7MIvsDmlDoj/1J3WpSUqKC77oTq4PFq1GJmZyac777A+oKuBPPSVZrmqtKcK48grllIE2CceAf/8W22M3+IQW5JJKZOovpdiNMudaHBNdVXVCvxHvZen3q95sh3r69TqLvTjz2PdpMhYbTPjwO4oXt67KezDQIDKgFCvqOXR/TtrGphG6sVhmkM/UzZ3izSSWVYTCTHTKpb/2gOu9UxmxowCLwfCPddJYJfZ/9HI6bH3RpfauB0vj/s/zJCQHBVW3AB9YhVH3gtN+343k2jUd290RdJD++uSXwmSkwAXny5hm2UvkiLnI3PzgL3S9z6hIijShagkedSvD+lXtkFYhKiKCKHe1tnUL1JFB80gYkfJz4mh1fbT
 2UNLH18r
 jEQ4om8nceup5Lq2VUn6YVkFG4mM+VXoXQh8h3asYOl/3GGIXC2SiMU64ZrBje6kj/nealWiFkdzJ1AvuWdV+BZm3QKeOJP9uVKkGFZ/7Z5xO22tk9XhZBp1KIweHxKDGlZk02U4msiPMcBCIQssV/6ucorJ418DxkQcT9V720E3BCQYVzXFQ5lqn4wDQQpnBA4K3bYG7U0cQLQdb10SMDvImkbAC6lppmZx4IDIQmTRi9aMOwcOMlZRDZMb+gw6gJmDDdg5A4ODKFr+rwCyVeq75yZs+Dol7lnlkYamWEZ8jutVPo5JiIqbRTcmIvh1fmxNPnmmeXoQqCXxOjaaNXlLVLwEmlvq3J/u4E7RzlSQWjQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.6-stable tree.
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





