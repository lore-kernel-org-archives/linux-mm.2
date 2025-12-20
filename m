Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 674CFE668AF
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 11:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9BC6B008A; Sat, 20 Dec 2025 06:17:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7A0E6B008C; Sat, 20 Dec 2025 06:17:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8A046B0092; Sat, 20 Dec 2025 06:17:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AAD996B008A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 06:17:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 45EC613B1FF
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:17:14 +0000 (UTC)
X-FDA: 84239597988.25.C1E1635
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id 830C140005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 11:17:12 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S12TpyY+;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766229432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MoEkhGDkCRG45o46/v13ZWZW2kUp5bUq6J0F6pVCYGY=;
	b=NJNSfkNqQ5Lok5O9RcEzGxIFAyA3JPXVSjidGP37RCiu/SNYL6aSY6F729k+5NGWUBPfCu
	jmCbbsBEQGQcgPwTX7FdiIGyp7Sswn0m5bl9S5sLKq/pJ0ltDNPBIDfCgU6DidsuUh9fA/
	5YV3rnylHGG8ejiLVk2oJpnhV8Izap0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766229432; a=rsa-sha256;
	cv=none;
	b=i/TQblU34LlrinIarGVTPd2PleEvbPECMTzwuyi1tNg7VAO5BqF4GLQrwvKyBhSlJcGLB3
	9plfhn7MO0Bp6OX+HEgn6Hfi16rt50uaZsy2gmxO/wgsCTPoEcVJlAsacAk7xfwIXatfcg
	TKsaRConzVenhxnLbqYgVAsITrwcFmA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=S12TpyY+;
	spf=pass (imf07.hostedemail.com: domain of liwang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766229431;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MoEkhGDkCRG45o46/v13ZWZW2kUp5bUq6J0F6pVCYGY=;
	b=S12TpyY+e1fm3TCjMj8RXPYEKV5M7YXnfWEuDVZGZm04XNW1xycnoZPrOduE3vHEnX+3tX
	XsWRa5fkoq9huZ9++jtxj0u95UIve7eBNee+i6Y3AaLvSba6pSqfPpc97q57CCdKUymeIT
	itfCE1+f4DGiDAtJRYeQluU+Vsah1wM=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-299-SCxEloExNByrp4qCAn0xiQ-1; Sat,
 20 Dec 2025 06:17:07 -0500
X-MC-Unique: SCxEloExNByrp4qCAn0xiQ-1
X-Mimecast-MFC-AGG-ID: SCxEloExNByrp4qCAn0xiQ_1766229426
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 5406B1956054;
	Sat, 20 Dec 2025 11:17:06 +0000 (UTC)
Received: from dell-per7425-02.rhts.eng.pek2.redhat.com (dell-per7425-02.rhts.eng.pek2.redhat.com [10.73.116.18])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8C80A180035A;
	Sat, 20 Dec 2025 11:17:02 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: linux-kselftest@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 2/3] selftests/mm/charge_reserved_hugetlb.sh: add waits with timeout helper
Date: Sat, 20 Dec 2025 19:16:44 +0800
Message-ID: <20251220111645.2246009-3-liwang@redhat.com>
In-Reply-To: <20251220111645.2246009-1-liwang@redhat.com>
References: <20251220111645.2246009-1-liwang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Stat-Signature: 611beigm84rd7nbtbo5ki374sxkkmsa3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 830C140005
X-Rspam-User: 
X-HE-Tag: 1766229432-834871
X-HE-Meta: U2FsdGVkX193Hl2x5OVAApvsPaJ9pCDhlZTNS9BvRJ/sG2zB/GAul+jv0Z/3Jz+9YvXsHVXrHlnwoqSjMi64f8jrIaHpXLbS8g/gB0o9vW64UqINp0Gvj5GMEwdlEHAxI12gup2nHnVgjh0QE4G62lfilS0wSckEJtsxBOU/5sksE/xbdUunCzwSCGApTHWNKWZ/aC1iLoeEk462Ye0FOl9emChFL4vrFTAIoxRpDolS3jGxhcJnY+8Gh1HekLVdbr8FZRSCbKBP+qnKkjr7uTSMwfjLqCeX0VzDGBx+qzDtoRCkC71MVZfmYWKcN5T6hS9GwIS8zlZkJnEMpxon5Uqgd1hPCQbCgz9UQ/9J69l20qcONqkIJ/sOoj/muN23svokEiArgXUAgDG+zq47O+bxuxSU1vt/3pDa3jovAR63xgUKyOyt1EMKHMrtHudkCwrjF8noUHY6GNiRePsxuVz+OvYoR4NyhaqX7CXkCoBUDxZVZBwk5DlO4JmCt9+pqVAKi2ej5JxOObeJH8xRHwHKVZgXccDAaebSv8/5tCfqFgVa5QWOYZ/xWkVm7/HNzAdnSVBGNFE2IkEdFzFMfvMOuPMfo4x+PImOJVODx8iIEcuzITzq+ZpBrPmGs1QA03oyHBjtNPrJ7MgILXydx1JE1X3FN8IkuT9zoGQXKKTCIZctTpLMqm8SwWNQnIVY5biX5NBTerUOuCHgOhGUuVPs0k8miFJZuXB6Yuj+Ng5oXMYJ3qLWJ0fz9o863oSAgfGo7jNGsiyQ2SenPHy39MZ3WNK5oWrCjs65IHMKHBLlcAFWqO0NL1iDbv898cMkK/gmmQdFUdpmcq+w4qpgE5qJqrJwMUQQ9khnzMUyQ2/6Cq3kuXp6zzE1brn+dlzOCHIVhF/2f/jpQVDAjRCDFK73n4Nr9mqizioxDfWej2jnf6zd7cFyoTZrG69/ogVyGgGRI+254h5ZmK6xAMM
 6fnOJvWV
 jf2jDk9ke/zlrYX/2uNNjHmQUDNNDVdZoZ9RcRC3AdFZuhWjALtIXUt6EYReT2x+71oYIjy1p8SnMwFo/4+vZkc3sJiFoekNbJOFBxbnSa3NBuoL2W9NcClnOqCmndtOCKijtN3/vaUXj2N1WwbVtfiop1ztQR/pPP/cTYNPXBwabxr3qAGbWlSfj1vSdMa2hs52ECHEGAhSae49vkDjjfmLtYQEgtvEnnMH8jf4TaXd+j/z4UiYbaK9Dz/MpLTVolj6PRha/FqUgFjrTxXDL1UhOln7CJA7jEOKOL3P59PHbzAQD7nADlXC7b/nUIo2pG9btrcUhpALIzl+Q0tQiR2rYfFq6khGVrDpxpk062hY8hfRfYG2XAf5/1KfUITqh7TPTzhh9RKHe1MwCNkMUJ7Z+8g==
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
 .../selftests/mm/charge_reserved_hugetlb.sh   | 45 ++++++++++---------
 1 file changed, 25 insertions(+), 20 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index e1fe16bcbbe8..6aa4ce66922c 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
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


