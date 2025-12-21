Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E194EE66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50E326B009E; Sun, 21 Dec 2025 03:58:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46ED06B009F; Sun, 21 Dec 2025 03:58:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232516B00A0; Sun, 21 Dec 2025 03:58:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0444A6B009E
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:58:37 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF99A132CE
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:36 +0000 (UTC)
X-FDA: 84242877432.23.8399AE0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 17948120006
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CsHWgI4Y;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766307515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W+AdUf+b21THrtxiV/+wgcurXGaYeTw1hKTQe5EVljM=;
	b=AfyeZdPKLpx8R9C8ge04Wdz0Lr0ykU+bJqsitUPQDju7eidHrCaPx8/HOLageRgjXUqxxB
	ytapH+lA48LIdn6Mrn9uM1P87ltALa52OCQ2nds433Ja/yMjY1qz4q9lvzUMoxb3QOe3Xg
	VSRGtfB9t0oRO3r1etuo+WRDm6FawJM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=CsHWgI4Y;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766307515; a=rsa-sha256;
	cv=none;
	b=XGM1QnbQXPgOry5dZY5jt7x3SvkVZfjhR3ssLGefzaRBs5alvemMvEvw7MaXm3636cQmjx
	M7h6dwiO0SkrNNntxHTJ95qr69h6iwlwCqtqvySnVLwoflN/xhBxKDmexlbeYnqBzG2zE+
	JukhYxcNQDlm/PifIk94ezlQi2oNSqk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766307514;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=W+AdUf+b21THrtxiV/+wgcurXGaYeTw1hKTQe5EVljM=;
	b=CsHWgI4YrSHax+4GsmLZqDLfiPc0QiQclCGrpgHaqoeyKeUlCywjccdUuwAH5wOgArSsVe
	bDQ81JQ4WY5Lnehfq7PkiWkHEKeDuzuIt4YLiw0nnEEAIsHogfsHVaRs63fzbIKxcQwRYy
	Jpr9i7HaC3ILnTZ0KEftWTkwW8XsPZc=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-315-1EQ6i2C-MaCOWXvOsRCSJg-1; Sun,
 21 Dec 2025 03:58:32 -0500
X-MC-Unique: 1EQ6i2C-MaCOWXvOsRCSJg-1
X-Mimecast-MFC-AGG-ID: 1EQ6i2C-MaCOWXvOsRCSJg_1766307511
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4A31E195608D;
	Sun, 21 Dec 2025 08:58:31 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9937030001A2;
	Sun, 21 Dec 2025 08:58:27 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 3/3] selftests/mm/charge_reserved_hugetlb: fix hugetlbfs mount size for large hugepages
Date: Sun, 21 Dec 2025 16:58:10 +0800
Message-ID: <20251221085810.3163919-4-liwang@redhat.com>
In-Reply-To: <20251221085810.3163919-1-liwang@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 17948120006
X-Stat-Signature: 3cqzdju9ihfj5xbgxcjuoi99ijyg67n5
X-HE-Tag: 1766307514-480436
X-HE-Meta: U2FsdGVkX18WvvioiS179GYZBCd27MbnhLSunRmEBkdUpGHptYHe0YHNJNMNDqsdbJsb7NB3qS4+srWuc0fHISfK+rzheyif6kPR9C4tYk9Hnj/eN5jGEeW9ndpW6mCnUZWy8zYqSq0y5b1LuYDtOvTRwCjIkFQUvIWJcqhEgCU1el7gvddQDQV8TjMqNLUFjOkIywJX/+eXWeuUgzPaW9M6olFZiPac/zWdM+0hJes54qZPi2LQc93VfvROeEvPm2pDlX2QLdlJdzboH5/dMTToxXdQlo/epKV5tGjL9D0iEIl13PZZTU3UJiCDkxdegBz7Uh9c1HLCRJp/ydohZtskH6gyNq/tMJTEGmPyBr6pA1fwvfF8vCg6mMIigBenp7PSbnDpUwbNfq2t6SdegbFGwKbNwWk9LyWbzROZ59JZNRUbxNxQyZYuezjo9ANsrjFy8SY36wl19i2J6vMKL8LBftL4fNSNaoi5LhG0PNCX7g4BX++ACDe/SgYJxsT5dYlw3q4t2JcHzD6RRKrk7NdYHHS+d4aBgwaovOSOablLe7lVicG0LRelDOadCvsOtez9LqSzI+JAH3Y1+pY2mAvK+lQBHv5hHCKBvlPcCVMVsS8LyRNemVl+FOSk5phhk4z15zVBlTPw3IDsVydOzQKQ+6aqNDNicpfESdfRkiIRX2lJ4lLsEmk1ZPc6PVe9nLEBVclQZfopvzebWzh9W1hSxj99ARYLDKyYDJIjCCNHZMN1YWVHTWHVQ2X6+DrsXo/Vdtpw//JIXYH/iGTYJuo9kbSdG5ZgSs2YylOQ9cYRB2y7QpCERZacku36AuTDBPfW3wIp5E0UW5AJZxbJKIpOOPqaIDMYyp40tb6gUdxZCDE0CM1HPxdTXMnkuKClT04/dxEX0kWYqkZ49eZTAAgHYxZCYCg8Y9ejE1WeWjxc2DMSKSs0+iQxnYwpgGJACr323SJUqRcnb0SdC32
 if6EVrXe
 /AuqczbNjN2VtBM27x9bMfpj3l1LSjzOf/wfbM9lNtK+ziOPbto88aCn413iLQsFgikJronDLoQ9fWdmxXAT4Rh9l21niF8eJbYEemUMBoZ5t5GuDNBW6fnDeKvYHsHLsR96WhYGP3Bh7z9dPDwGVGfhgfszwfpGggxFwPsypntw6KkeEy2dE8/raVaU/ysYMdbQJNCsIEmL1ZF/0afGY6O5e0Q9wtzyy2kGCC8RI8VjCOx9A9dTFa/4c7oEmD8+EB1nix7JbuYNP0mr6K+XilAUKArob0Kec2J5fk9uLILkSpAa5y/hk8T3/yvcltisvlW2VCKqA2jX5IhJmQrGCkhkm/I0Cb+XGoRlh1Mss6kHDdABPrdMyR64E2Tv0k3GqvQyUTgzmsO3tbrpoxx4urxmMeQ==
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
index 249a5776c074..ac2744dbc0bd 100755
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


