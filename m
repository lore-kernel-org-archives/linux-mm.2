Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61FFE668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 11:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3CC6B008C; Sat, 20 Dec 2025 06:17:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5521A6B0092; Sat, 20 Dec 2025 06:17:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426A36B0093; Sat, 20 Dec 2025 06:17:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 323206B008C
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:17:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00BAA8B2DD
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:17:19 +0000 (UTC)
X-FDA: 84239598240.03.3191D4B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 389DB1C000A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:17:18 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X+JhSh+g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766229438; a=rsa-sha256;
	cv=none;
	b=B/wVAhdTw09vVTxdVuZx8Tyg6hOUdbuG3hQJMqdSsalPhrZyMOEJwOMV+fjQfqKI2ZKrie
	+sc2CYCiNx7RGgmh9/H7qGrJkmnIJ3jTY5Ce5hHPjdoiJf3wei5e55+yHalmaXKMyqQNzm
	903+sKupkBSSezzYdUbwoike9x/q2jk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=X+JhSh+g;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766229438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AeYBXDIL9p75os/GitpdF41KNLUSWbRtlTHaY5hYAc0=;
	b=cj2PFATaxhiNdDUG9pGMZzgxif9y5ru1HctHs9mhbYm5pKni0Yrwcp8WbvMZD/8mXAIlkR
	h8kYg998a0LcCsww8LUo2tjDnjht2Urk823VwTQCzu6ByKj2EKMd013bcR1i605ngaZ3aJ
	dQTFZuSstPbuXWj9dl0YNWBX5VNPJrI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766229437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeYBXDIL9p75os/GitpdF41KNLUSWbRtlTHaY5hYAc0=;
	b=X+JhSh+gqQu59bzbBVCrDna0p6AqXoI2zbDaxGUKH8l5H1H78qAPVohyQlf3eYbxaG2KCm
	n2izhIzi+OuiW14hVDWjbsfymv5TbHc2QHJKgR7wfY8KqRF1SCd8TxCvvU7IP8Qcku97ef
	T8jOkk2YPu4RM6Hm19zdVqvj3XaBTdU=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-690-Sm7oz34fNhKy_ydVLDNVhg-1; Sat,
 20 Dec 2025 06:17:11 -0500
X-MC-Unique: Sm7oz34fNhKy_ydVLDNVhg-1
X-Mimecast-MFC-AGG-ID: Sm7oz34fNhKy_ydVLDNVhg_1766229430
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 72A18195DE56;
	Sat, 20 Dec 2025 11:17:10 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 02FA9180066C;
	Sat, 20 Dec 2025 11:17:06 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 3/3] selftests/mm/charge_reserved_hugetlb: fix hugetlbfs mount size for large hugepages
Date: Sat, 20 Dec 2025 19:16:45 +0800
Message-ID: <20251220111645.2246009-4-liwang@redhat.com>
In-Reply-To: <20251220111645.2246009-1-liwang@redhat.com>
References: <20251220111645.2246009-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 389DB1C000A
X-Rspamd-Server: rspam03
X-Stat-Signature: d3u7rxdhj3k5gbdwxpt7yxis7ufri8b6
X-Rspam-User: 
X-HE-Tag: 1766229438-167428
X-HE-Meta: U2FsdGVkX18YaWASmzqLKoKjOAsLaTcyyBYEQNKGVSsu0AcULPpPQGlajJKrwumHLGhogv8Xi2LWJRRPL/lsqKy32MoJrsAASGv1NJyzUQzydRhsvM7ao0mNlEISX7Rytezlb1V2g4y7wSkDCeNAes5OxSX1METjqYo5XMYR40rfA64DZYXOzgIYuyrvYU4wu6DvgxU1iyw0OuK8cYcWERoBlnR0xOYT++ZBAwxggw1s+5jlx1MsIYUz4Bm3vj+KVN7Xx7/VorRUxq/CHVsHF4bOhHQul37Pg42lbxt4FJmZH0iKL+hnAS7CBDr2oQUT9FQFVdTVC+LEQ4MrGmoq12Sx+mcxfAdFi7K1tvOvyc2h/fC32885qYeouDMyjoUrBOItsk5PW4Nj5yk6p94m33n8BRQemFlfbchWDsQhnKigA/WU36X7DL5oyW5HRPBeAQR/KJK1Bw+4qs+xuC8d8B2tXfIqB8wRej0+6JHXUooEBqoDoGXhkvN6Qbv1jiN6W95Jio4d00IYe2ObHAbDlVGAOV8h8QdlHD1jtPIEvBX9sdf2dVDQ75BF9R6jDGRAlbNAAqGUDk4yUQsArQ9U/jRCWgog1nfdVRYYzErhg8qCmVAMLv2Z7w5w+RJtbkKsjd7LHhSI+TnCEebwdEDLjlKXfXKVolPQz3gyOp9QTpxj2JsYB6WBpB82+6PymbVW5gFMjvjLr3ah5TufHaF1Lto8LJMIHCZSYytf/UIRyNS4Uxh9WhjD3cTn/SxAxa/4IXbDCBknSqdpEsBIqRDzoYybpf2vQ5KkoRwotDCSKndmgqEM2sgjAfM8meZjf5vkd5lNfZm7OYTtRBjXRkFVn3N2ustaLUGYl2gfXwP+AHr4JEodZsU7/JVIlyRzd1aQ/PbW96jcgg1cYJFKRhP1tVJbH9gZ+v1o1XJP4IuRcgj1oiZxTvaBzLQ6cAUU3z/tYEOnoPHZdsMxWKjBYel
 GG9Nek/b
 4zeIL0uu3EI+BJLf9MucUqWpPbbqpnu8Z9vFkGzLvIp0tP3t5q6HHcEckgHwtkp6cywPwjwj/0s3ab6TgTZNhHBYxDLudBcMPz87syf4YXkYJi5T4P2E9rGqhO2itgGlq1Sbcw+MASXUQGcLHuUYVzaGUoutEshl9p24Nq0HVXUbT0hjj53K+083Faz46ReQ/AvlUytq+/BybxJtcua39ThSephNaHK6p+6vmPLJG8Y/lPrvb6J3zkGQtYmjcHpHNTz+q8RpdJNVyQ8a8jPiIuVd4uTZdQ7xOVZOUm32u+1MyE9tzhiqhirYNzA1zj0AEGTTM28lPslIBM3mSdMyqv0w2tAjwFQwj86EcIvWuI/mncjzlnK25Cgtl29SanmNvXOEMlLsyIu6Ipqi6LuK9XRDbnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

charge_reserved_hugetlb.sh mounts a hugetlbfs instance at /mnt/huge with
a fixed size of 256M. On systems with large base hugepages (e.g. 512MB),
this is smaller than a single hugepage, so the hugetlbfs mount ends up
with effectively zero capacity (often visible as size=0 in mount output).

As a result, write_to_hugetlbfs fails with ENOMEM and the test can hang
waiting for progress.

--- Error log ---
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

Mount hugetlbfs with size=${size}, the number of bytes the test will
reserve/write, so the filesystem capacity is sufficient regardless of
HugeTLB page size.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 6aa4ce66922c..9deb3dc2cbce 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -295,7 +295,7 @@ function run_test() {
   setup_cgroup "hugetlb_cgroup_test" "$cgroup_limit" "$reservation_limit"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M,size=${size} none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test" "$size" "$populate" \
     "$write" "/mnt/huge/test" "$method" "$private" "$expect_failure" \
@@ -349,7 +349,7 @@ function run_multiple_cgroup_test() {
   setup_cgroup "hugetlb_cgroup_test2" "$cgroup_limit2" "$reservation_limit2"
 
   mkdir -p /mnt/huge
-  mount -t hugetlbfs -o pagesize=${MB}M,size=256M none /mnt/huge
+  mount -t hugetlbfs -o pagesize=${MB}M,size=${size} none /mnt/huge
 
   write_hugetlbfs_and_get_usage "hugetlb_cgroup_test1" "$size1" \
     "$populate1" "$write1" "/mnt/huge/test1" "$method" "$private" \
-- 
2.49.0


