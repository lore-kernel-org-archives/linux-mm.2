Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268C0E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 12:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0D06B00D9; Sun, 21 Dec 2025 07:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87B216B00DB; Sun, 21 Dec 2025 07:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77E316B00DC; Sun, 21 Dec 2025 07:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6697E6B00D9
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:27:08 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE4A213BAED
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:27:07 +0000 (UTC)
X-FDA: 84243402894.16.F4055DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 415AE40008
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 12:27:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d1oF61VL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766320026; a=rsa-sha256;
	cv=none;
	b=mpyTKkdRccAitvDWLposFRnuc0yYXbZcO0bwS21NtSOQK2hANrQ+xPgcDJ8UeqhjrsgoZR
	+1GZp3Hkb6X53PYsIrdQUIs59e90DqfUF0kU8etGxwSTayk6HanuaVNQr7ZnsfQ9M/BAMN
	XVFxGJJyVHFb3UEIn8yHgS5PG9hi3q4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d1oF61VL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf27.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766320026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtTN5ZiIMcZwcQ+3hqBNVbiHLsjMQ/2q8VKQEGwo2qM=;
	b=vXXIBKd39pdTQKHt+5/UihWkhY/q59uhSCVvZkUdOQwG7jLHbvYB27EeHT0wtGFrAmfr/T
	66/g9QrHtbps7f54yL0uTgNa7wGGdzIFdXHREa0A0JWkMXFw12h7Pc3WZnIc0HUiwpfi3B
	hGKkLc7F8BqRNlwCV4mYCYQzskHGzx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766320025;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JtTN5ZiIMcZwcQ+3hqBNVbiHLsjMQ/2q8VKQEGwo2qM=;
	b=d1oF61VLhliJ4jYGWDmxLFaVaef//yT305O4o7r+4QgOek0t4PYERzgfG0mpo940440Vpe
	kXoJozQKrYgf385hegl2lHujF7v65RW9VyplkNPAXPg+hkde/ak82Ct6C4jsVG9dSA3bm+
	Mp/pryTYE54ddc9T41Nk+Y/8Is6Czvw=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-187-feTpn7toNdysIRCv0MgK9g-1; Sun,
 21 Dec 2025 07:27:01 -0500
X-MC-Unique: feTpn7toNdysIRCv0MgK9g-1
X-Mimecast-MFC-AGG-ID: feTpn7toNdysIRCv0MgK9g_1766320020
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 238341956094;
	Sun, 21 Dec 2025 12:27:00 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4EE9B19560B4;
	Sun, 21 Dec 2025 12:26:55 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v3 3/3] selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
Date: Sun, 21 Dec 2025 20:26:39 +0800
Message-ID: <20251221122639.3168038-4-liwang@redhat.com>
In-Reply-To: <20251221122639.3168038-1-liwang@redhat.com>
References: <20251221122639.3168038-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: 415AE40008
X-Rspamd-Server: rspam10
X-Stat-Signature: 3gbmquijbd53q9h3gauojos1fb8ups6c
X-HE-Tag: 1766320026-833586
X-HE-Meta: U2FsdGVkX19M3s8owrd7NLypZGKtX0lfmAD7vo+YxUzNY+yCwwVuMrmgEHYLmK6GfvPUMoaQ07thMpnYW/Ntnbnpdp3Pi9tqP4f+u14e0dDtLWIYSbAyJg1BOAbJBIcsadTWH4DE4THl6C7LGevRB1R2O18r8WXjyidHJccmAw6t4dzjNAUxVfc8GdWd9P204FqKKZGoLJD8knzWDGLRLaAyaLjmuHMXoRThny6THuV+fyjXHSa/5SnFgtSpFKs1Jb+ayTo8dNpdPU52xipLJ7SAjZcv7TadwzkXJIrTroVo6DEBchTmOM8rOG2pSDhBPUgw029AW+TGwL1TAa5mXhT5XljrM2QKk3uhOa8W/w3NWXIhNC4xy8VuuRB0lFoOUt7lNsaHrAd8Mcnd6IGfIsLn5wTQa8QgTh/nu4Ly+viAp6KYP0tRt0wMm6qK2AGHOy6MLAmbjr1H3DRHHSkyYWDMhrFpH3sJSMOaEbimhVhu0lfLQjRaVHNLfaAhTutDzXLLm2+j8dOp5AOtwabNl9DK4bMvFT0XWDRqMieAVHKNBnNudr1fWzcR1CQNFMGqJvAKhOSHhtQVpDAFskQc/P0uWl+t9h4ESfX6ikJFn1ryYbYGO8ubcXkE89GIu6umdk8mp+qvKzkLAQcq1Qb0qlX7ebVqC9nbQoMsE8Aqb6PjJ7uu/Y4DGPvmnTuLDfFuq8aFhDiCnxnxIsH3q2+Lpt2xkzca+RRIIrd98R3XNKqKwpgkyi2f9k7RFiR5ZO5oNQ7FLAdk5K5AUAJMmcP+6ZNMlDZWX635yr7089W1VxP8md4qgbKozE4kCAvjcxwHhwJJH3caYYbs5JuQGWOXRtmF4NrW6T0WOj7AMioe1/H3vV8nw5llyfw+k7pLG01YATs1CxiJ1Yg/Isi4vNNpFldNpCJe6s10q/759wqrAqAhJiRdUCN25iiAbps2XGBKq0BxVCeKO2/bi+RMUWF
 X/gKozBK
 2HpheotF0ZKAaW0SmS1yetPZdCwCi3SSaNKFkkxbxTrTaA81zpqAc9lYE0+yJs3aPwmPjVIxYG0q2mj0KFOy2immUA4Dk4FlFxTu7kOFalH8CYPO0Z3PchBhHlB5hN3TeH7EA8J2Fm9TWAUgjQJz2eR16FvrQxsiuofbBucW9qHJLrzWYILlTHivvssH4ZwOaMnqRPsYxS5JTXKf4aovKNzIFY3vsa9pPJnD/XsAJVaRYy49EJVTbEM0KOPX9nIGYOT97voU65EY20OrAPA5F9AYzgPPqBOLNg8Fj1S2iKtJ03Qht7hyzy4lQGIlv13X27GsvNEw5DK6B1A/nJ9fS5azVG0L7CLVMCR52ZHZjT+HMaAlqM854+rH6Vgq8Yemj3aM6PNR+K4uf8JmqQja3ZLBGTw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
unbounded and could hang forever if the expected cgroup file value never
appears (e.g. due to write_to_hugetlbfs in Error mapping).

--- Error log ---
  # uname -r
  6.12.0-xxx.el10.aarch64+64k

  # ls /sys/kernel/mm/hugepages/hugepages-*
  hugepages-16777216kB/  hugepages-2048kB/  hugepages-524288kB/

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
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  # Waiting for hugetlb memory reservation to reach size 2684354560.
  # 0
  ...

Introduce a small helper, wait_for_file_value(), and use it for:
  - waiting for reservation usage to drop to 0,
  - waiting for reservation usage to reach a given size,
  - waiting for fault usage to reach a given size.

This makes the waits consistent and adds a hard timeout (60 tries with
1s sleep) so the test fails instead of stalling indefinitely.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 .../selftests/mm/charge_reserved_hugetlb.sh   | 51 +++++++++++--------
 1 file changed, 30 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index fa6713892d82..447769657634 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -100,7 +100,7 @@ function setup_cgroup() {
   echo writing cgroup limit: "$cgroup_limit"
   echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
 
-  echo writing reseravation limit: "$reservation_limit"
+  echo writing reservation limit: "$reservation_limit"
   echo "$reservation_limit" > \
     $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
 
@@ -112,41 +112,50 @@ function setup_cgroup() {
   fi
 }
 
+function wait_for_file_value() {
+  local path="$1"
+  local expect="$2"
+  local max_tries=60
+
+  if [[ ! -r "$path" ]]; then
+    echo "ERROR: cannot read '$path', missing or permission denied"
+    return 1
+  fi
+
+  for ((i=1; i<=max_tries; i++)); do
+    local cur="$(cat "$path")"
+    if [[ "$cur" == "$expect" ]]; then
+      return 0
+    fi
+    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
+    sleep 1
+  done
+
+  echo "ERROR: timeout waiting for $path to become '$expect'"
+  return 1
+}
+
 function wait_for_hugetlb_memory_to_get_depleted() {
   local cgroup="$1"
   local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
-  # Wait for hugetlbfs memory to get depleted.
-  while [ $(cat $path) != 0 ]; do
-    echo Waiting for hugetlb memory to get depleted.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "0"
 }
 
 function wait_for_hugetlb_memory_to_get_reserved() {
   local cgroup="$1"
   local size="$2"
-
   local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$reservation_usage_file"
-  # Wait for hugetlbfs memory to get written.
-  while [ $(cat $path) != $size ]; do
-    echo Waiting for hugetlb memory reservation to reach size $size.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "$size"
 }
 
 function wait_for_hugetlb_memory_to_get_written() {
   local cgroup="$1"
   local size="$2"
-
   local path="$cgroup_path/$cgroup/hugetlb.${MB}MB.$fault_usage_file"
-  # Wait for hugetlbfs memory to get written.
-  while [ $(cat $path) != $size ]; do
-    echo Waiting for hugetlb memory to reach size $size.
-    cat $path
-    sleep 0.5
-  done
+
+  wait_for_file_value "$path" "$size"
 }
 
 function write_hugetlbfs_and_get_usage() {
-- 
2.49.0


