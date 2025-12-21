Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A00E66886
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 08:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE916B0096; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8826B0099; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDF7C6B009D; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A60526B0099
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 03:58:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3C3E6C0DEC
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:32 +0000 (UTC)
X-FDA: 84242877264.03.8687C78
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D7F012000A
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 08:58:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ymi7lwBG;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766307510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6/7wJJeFOZi0ARhhFuFmVb2GsSZEaXM1i3/zzQ9Lsw=;
	b=AOPRJoXFEaVubFH3+yxT8f/WNBcYM6WKShIhUL/p8K78a2+oSQi51FDTmh1Ie8PbwxJ54d
	qzv+hmJv78xeL+6Zcv9HzA3v/boXr3b4ORuSBKhTGMA6LrqJ81K6C44AZVcZQkjTRGbGxf
	cPbNNCYUZ4IuMEKezGxOSQmrxwZPRKs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Ymi7lwBG;
	spf=pass (imf29.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766307510; a=rsa-sha256;
	cv=none;
	b=cheF3yLdGOL/+rRYpdLv3v/pG4GrvxoikXH2iAn0PkW3THIpklp36JceA4V417Gam+LlCS
	7tJSbMcSXImFNOo0+N020LfMCUq4qgv1pQa7zxmz2tTElpvs/nt+B94HJq/0tGSdKUK+7b
	AqUQHCm/PbRQGpkbU+nJLhADoo9H8Fw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766307510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z6/7wJJeFOZi0ARhhFuFmVb2GsSZEaXM1i3/zzQ9Lsw=;
	b=Ymi7lwBG3W/gEVU/m8HZorRzKhuo+yfvAR7xH4IE6j3MZ/UF0OsYXgBi/ySLQuLQxPBNel
	OavYwUlJEz4lwFTX4ijA1Z/bUPQz2iwYrMP0idcmMW8I2Ogx9QJyu+szF0fvVKkJCl+1DC
	wJ+gXraDGFQ9uzJFbe/NkuKSO/vBFaw=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-247-XdSYRLp9PqaEPDPiX0EGSg-1; Sun,
 21 Dec 2025 03:58:28 -0500
X-MC-Unique: XdSYRLp9PqaEPDPiX0EGSg-1
X-Mimecast-MFC-AGG-ID: XdSYRLp9PqaEPDPiX0EGSg_1766307506
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CFB1D1800637;
	Sun, 21 Dec 2025 08:58:26 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 28FFF30001A2;
	Sun, 21 Dec 2025 08:58:22 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH v2 2/3] selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
Date: Sun, 21 Dec 2025 16:58:09 +0800
Message-ID: <20251221085810.3163919-3-liwang@redhat.com>
In-Reply-To: <20251221085810.3163919-1-liwang@redhat.com>
References: <20251221085810.3163919-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Stat-Signature: 37ib7iem7by7hqnci97q9ojj45hiupbt
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8D7F012000A
X-HE-Tag: 1766307510-993392
X-HE-Meta: U2FsdGVkX184lEEu6Ge6RXUJH/XLHzR5hMREW9HMbhFwrM5lOQL53pSjYJJ58NJbxZiF/0f1xmAPG3/53JANF2V9jkWLXMh+xLMUQ70YdemLJbNac+hnwMNi+z64/BjPuPLVZ4vulp12IVoBX6LrvNQ9Wr/hvNTbB3sRFDpPAf/T6roQhnqNuPQM6DCUBdZKxG8hg6NEX7746jdfI2Fn5CKwRzarDxBqmhmL+0aN0GDZZOWIjUZSaQj6UKzhKHFYchU9x3VBid5nsedJH8HRJTdrJ3zPIXC/d+3Yx0fsR9obkOiUK4wXF+NEk5s4Y9VdE+4HFG+SR9ukUKJ7K2OppuNq9dqLZz1hKsHYPyw4lHtOpzYxi6WpgThk1GNSR8HnAKEmTIXUCrCj4hRKgyCQMNcBj3BBFpqldqvePn8e8g5hyfqS53yH8JOerOzPxWZTOXnLMI7c43zhZKBt1IOIlmP+LtQpnuKxmUIaeY8qe+59dX9U8YTmcDki7yz0qC67kTB5fnj30tfwu0Bysrg4yZesR9HAQOg90mwfmERLDoJMzfdxMSoDEPLtor0QrSHCcOfiQKI6IjcDkPbYCjJkEsEgz+79jrlMTGVhk3JkJ9CozgrkealKq+Y41skEsCFUVPDG/5hyyBjgYEn6g/3Ov4Rb9aWIEeeOsWuvPRI4ZHqW+nYiw8U6sNQhaG9+6Z9yXZIF5aOLk4ZzCDm8/NvNvuutSb1bhVsWAleOZQHJKMv4FGtgz0d3BfRI838ZDhQjpoIcG5uFhdCxNngmt8VmIoKrXSqcmeAEHJtynLiGcX0l1Zj3b6xUHkTbeS6FgElUhcsk/NDWpIWepHWLf+qbh+8NUJBrrNpoLukSmLkbt0JyL261osGy4yWn1w5z7LZYciQvrTZbwPVCNsQwG9kLCznyePYrHnATEw51sCLbN3eoE5+MerKC45yr03dRzGOE3W7zpnzSakQ+rJo61B2
 JhdkVSnz
 m00R8lM2VLqk/Fz6CPBDF1H4C1DiNvcs36IeJraU5B5nS8qZE9+TQmqRgIGuT0unqjjdHMASezAGP2XGuGiaJgwSMGfOMDVVFHyz0/8YcVyFnYGPxTlM1YvGkK2ZF3KYZY6Cd7LMAv72XJjRJf9YKtnSxtBO30AcPNj+idkwWEScSl6pYGs5Oumj3fcIxVEinGkmCI0md6/oLXsLdnG4obpsc5bgLXuSejCX40bbAkHlM4SUnIitn3IKcP9HzDEWzd6OkgMuA5sGEnK0vwte8kuNuPFgylv5dKmHUJ3R08TT4AQSGz5IP9112rWE854yiTiUIyg/yQhnYrqB7BMwlweJA2e7JZN5EwQpTXwmd1SacP07k7sR+Vfbw8Ly3Jojr7ggqg8dPHTach2KsSA4Q1mt6ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb cgroup usage wait loops in charge_reserved_hugetlb.sh were
unbounded and could hang forever if the expected cgroup file value never
appears (e.g. due to bugs, timing issues, or unexpected behavior).

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

This makes the waits consistent and adds a hard timeout (120 tries with
0.5s sleep) so the test fails instead of stalling indefinitely.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Waiman Long <longman@redhat.com>
---
 .../selftests/mm/charge_reserved_hugetlb.sh   | 47 ++++++++++---------
 1 file changed, 26 insertions(+), 21 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index e1fe16bcbbe8..249a5776c074 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -100,7 +100,7 @@ function setup_cgroup() {
   echo writing cgroup limit: "$cgroup_limit"
   echo "$cgroup_limit" >$cgroup_path/$name/hugetlb.${MB}MB.$fault_limit_file
 
-  echo writing reseravation limit: "$reservation_limit"
+  echo writing reservation limit: "$reservation_limit"
   echo "$reservation_limit" > \
     $cgroup_path/$name/hugetlb.${MB}MB.$reservation_limit_file
 
@@ -112,41 +112,46 @@ function setup_cgroup() {
   fi
 }
 
+function wait_for_file_value() {
+  local path="$1"
+  local expect="$2"
+  local max_tries="120"
+
+  local i cur
+  for ((i=1; i<=max_tries; i++)); do
+    cur="$(cat "$path")"
+    if [[ "$cur" == "$expect" ]]; then
+      return 0
+    fi
+    echo "Waiting for $path to become '$expect' (current: '$cur') (try $i/$max_tries)"
+    sleep 0.5
+  done
+
+  echo "ERROR: timeout waiting for $path to become '$expect' (last: '$cur')"
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


