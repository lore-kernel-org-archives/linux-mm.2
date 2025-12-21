Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBA3E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C486B00D7; Sun, 21 Dec 2025 07:27:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1C566B00D9; Sun, 21 Dec 2025 07:27:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49DD6B00DA; Sun, 21 Dec 2025 07:27:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BD7886B00D7
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:27:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8AF22BB898
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:27:03 +0000 (UTC)
X-FDA: 84243402726.11.C7590E6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id C553B100003
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:27:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kj7Dqfs0;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320021; a=rsa-sha256;
	cv=none;
	b=2lKqnFiB55ho9BI0/CkJqohogbbAeBN6dJCgOxrMDqTcMmIQWdTCZiz6ztvSKritjjne6E
	TkCwow9pvNi0nIfTyzsOI9hsoIxWRMHF4UWF228+uTrtTvetinExk/F6rA3d3D4om0mpVZ
	hLC8uqBahQxgSms+GeBBRVJ9AJSCkAo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Kj7Dqfs0;
	spf=pass (imf14.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zzPxgBwMBIOV5Pem2xEekXV9hInqKLJADfIWievTtPI=;
	b=eGfXWJUivcgfsaKkWkFoGC20W6bCIqbdrYXg/yCrfQicyT1ktJqP1nA68UpeyeP8beXU3A
	PfkLzXxRN6zNueOpXX4KXQvgsH/BlFdVTFeAe5fO5/bRgmZtPyUatr4PW1vleMWeFFAgV2
	DmH8bxNbH2iXCcJsUF8G/9OYWNToIIA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766320021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zzPxgBwMBIOV5Pem2xEekXV9hInqKLJADfIWievTtPI=;
	b=Kj7Dqfs006PD4dds6qtvFmbcsEEXY1n+j7eZOv1fTDf1yhI/wz/MezzFVepj/0WNPI1DPp
	4hriHGEdYzVtBFA7EUvc54E8KoV+VNYpdvkeZdjEn4RKuXCXwi4Z2TC1909/tz7paov57W
	uw2JhXtiT1aJQRLuUGaqL1y2lzxpnPQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-ji7ZnnHKOGe1JeQVEFtGFw-1; Sun,
 21 Dec 2025 07:26:57 -0500
X-MC-Unique: ji7ZnnHKOGe1JeQVEFtGFw-1
X-Mimecast-MFC-AGG-ID: ji7ZnnHKOGe1JeQVEFtGFw_1766320016
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B83F41800343;
	Sun, 21 Dec 2025 12:26:55 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CCA319560B4;
	Sun, 21 Dec 2025 12:26:51 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v3 2/3] selftests/mm/charge_reserved_hugetlb: drop mount size for hugetlbfs
Date: Sun, 21 Dec 2025 20:26:38 +0800
Message-ID: <20251221122639.3168038-3-liwang@redhat.com>
In-Reply-To: <20251221122639.3168038-1-liwang@redhat.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: C553B100003
X-Rspamd-Server: rspam04
X-Stat-Signature: k7akf4jppxpkfsy8r9yp36xoztukpka5
X-HE-Tag: 1766320021-729309
X-HE-Meta: U2FsdGVkX181qeCt2velKS4BFCa5+9/EeqyGy+ePvhdZiGEdY29VRvub+OAwVQe5h7/HHSy82Byn3uAe8kQ01yMK7BNHjVbhTyuoD6M1CyOOPEo+fG/YTbfFU1k9+z5YgdCj8uA8+bIlMjwxrS5vOK5X+AhFI3cKih1b6IzbXFWIbjGWiSQbS6may+26+5LheercNaMGCuPjfuHzDBNeyqrFTPGMLykGjp4+NfzTqE0TsDVOin3AjbC31CKYl4VXHOxH+gZvfUSZQzubYQKnWCfGb+Tq+t6cdNlZ8FMOeAsuzZCVfAfrXef/v6O72y3uX77kQFigo3TfuJWmShRxRNPaVwAjW/byheY/lVjfX7bGhOlq99SeRwXp4r948PufIAGvtX/Fr4a104D7IVJ9Kz4fFCSoEm3kgwnP++dXzncmjoDKhmRNpKtxh0TTIchSZiCcwYUCBgrGwgImZLjroQTFr8stIf5byXlauTXUPz7Z+SpCx5FmrR7AbLa0RQ7dk2iatkL7vb4/NUE968oheHzwchva8/SlrsdoQMC/nzvtUpcZshb0qcI+4KWHGo36OAW3clnO/2KuzY3h051ys4o9Wp1g3ZmyB5CrciZitDqtoBrquIZqkhcoH+uUH4d4cOSCfrJmfvhHNd9N4Q4T5zvRIQvPjiZ4YBQq0Dp9W2sB+iCDSWG7+NTXy/FMVXr4h1xjWMC6IDSvpW7aDhqtsO6yQK8gjbyxKft8TJprkieHTHgbGpwIwkNRx2L+tg0PrMOkpqRc7Qu2txNmbjRqcVeOGv+nJaGUZaBpGQlcz3+HfgUZNwHdPOBdsYWhFSE9e8sDb7ilJtJ0QsaEZuPPDECuPGs12zMQybrPVgnLJBrl0WJ8W+SUQUl9cYkc8bCKFAQ5Smj9+BWPHLpCjA0mVgX0tURvbqDlrl/Rr/1JZEDT593TVi3yeykY/entFQXkpRIWg026wYl9Al/W1A+
 /CXFttjT
 UDC6QOvQmiNdtCzHHUg9DpGxQXDUWs7iD3Igo60MjF+XY/H6J8dfUKYdQ2/RvouPxVTFMW5ARfGJEJvpoRLLOMy2XkYXaf00GZW9x4UvX3tx9AyVzJvtsnjRD05fvrQ327kOZbSZvpGwpeQcKJCmXbLd4yuWw7AhW4yKw1qI/XanhDV7CegwPdhYjlkmsb5cjEcvG5D58uZqoW0PG6fFBZlHR3JqXiCxWmN1z736Q6Uizuy4rqzdXxGWaAAiBnDK9glYg6+7+o6p/yTATRc2FyvKF7vw8/9+DS4o26YKGwNyYGJ/7o05IEG2XXMpDMOTz/xoi0FjJIgOIWNXBkY8pC35qnw3hR/HRUdyeRUozvWt9Q2xhJglO3+o5LVrgK13mv4sXttEA9vYeEAVSh7xFw3NvYg==
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
with zero capacity (often visible as size=0 in mount output).

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

Drop the mount args with 'size=256M', so the filesystem capacity is sufficient
regardless of HugeTLB page size.

Fixes: 29750f71a9 ("hugetlb_cgroup: add hugetlb_cgroup reservation tests")
Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index e1fe16bcbbe8..fa6713892d82 100755
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
2.49.0


