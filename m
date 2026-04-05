Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D5B3E9D80D
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 19:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F4C6B0005; Sun,  5 Apr 2026 15:50:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 250A36B0088; Sun,  5 Apr 2026 15:50:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 166236B0089; Sun,  5 Apr 2026 15:50:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 036526B0005
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 15:50:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 69CE251F36
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:50:01 +0000 (UTC)
X-FDA: 84625543002.11.5DFC6F1
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id A6F30C0003
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:49:58 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=daTTzxKX;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of create0818@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=create0818@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775418599;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a1v6SBEW7jZZiNgfw9iPh4ktsxTNNEqcra3qAv6zZ9U=;
	b=OQ6j03GVM2hq9hxoJ7Z/5YS89R6FvNO/S8XFKau1d0CQTC7N1TmMmCFNrRxKqwhNw9L6dR
	9LxFAU+5Fm07eBeKt/fSEd+TCgBNWQ6/I+eBVRMXl/lHL4e+h0wpAsw/Caamio2Ap26gaL
	6M+FwhEoAbXEiiIyuKYEzvIyswI1ZIY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775418599; a=rsa-sha256;
	cv=none;
	b=yp4shgxoU8k6nIpKrC99xeOEEL1yWQlHb5RAWWSqVDW4r0n6/HdmGcYTEGn7JVQ/7Pm1yC
	tJimUrnIjHHTKoHRDc0CIKoTjqsO/6U3QDSAL3zzd0mPSu77IZ2MxB4gOw1s341+PXvglj
	+Yor+rmbGcqz82UPpIAQ2cPBsf+zwl4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=daTTzxKX;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of create0818@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=create0818@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=a1
	v6SBEW7jZZiNgfw9iPh4ktsxTNNEqcra3qAv6zZ9U=; b=daTTzxKXaJaZ33L8LJ
	p343hehtYXZw8BfAG/r56ypsZ27oQbHk5UNt7CD0K9VcLsoVnBRAqFGGRlhzqakM
	l3ztCe7lemnr1YFI4+S9sDWZTxqSWG7MpvTmTJZt1x1f0ujkeOg06KOf76Yh7U21
	NAXV9SefEH8Dv7si2VIYFpEqA=
Received: from localhost.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgCHMbAUvNJpqEGECA--.186S2;
	Mon, 06 Apr 2026 03:46:33 +0800 (CST)
From: CaoRuichuang <create0818@163.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	CaoRuichuang <create0818@163.com>
Subject: [PATCH] selftests: mm: capture write_hugetlb_memory.sh exit status
Date: Mon,  6 Apr 2026 03:46:23 +0800
Message-Id: <20260405194623.84218-1-create0818@163.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgCHMbAUvNJpqEGECA--.186S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7Cw13GF4xKrWkZFWktr1DJrb_yoW8AF1kp3
	4fKFn0kryvyFZrJr4kJF4UZr4DuF4SvrW2qFW8t3y7ur13Gw42gF1jgFy7Zr4furWfJ3yf
	ZF4jv3WkC3WDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRR6wJUUUUU=
X-Originating-IP: [39.156.194.234]
X-CM-SenderInfo: pfuht3jhqyimi6rwjhhfrp/xtbC6BlEfWnSvBknIQAA3Q
X-Rspamd-Queue-Id: A6F30C0003
X-Stat-Signature: gzs1gmiytjw38n9m54wjx55tn7ygchpg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775418598-969187
X-HE-Meta: U2FsdGVkX199qOxqWzDIEpxTfeG4X23FhE68k3U71maCxKxD4MvdW5yTk18rHwiGb9pujUURUps95/gFmMXUaG0gKSzA0/xke+rQOt5paMQhc2f9H6O3Dduj+iIkAI1/mV8O8emxg99CSgoI+bmGBpHG4NerbIf+uy6iDVw9qteohZKe8FwGbif/OCRMv/799CBqTalW+T8GGbNzQvYHEqMYpzo5um524WarIeUQSQo8/fe5rUE3bJYurcbx5iLSiFfyWY7q6hi1MK+3OWuuIm9D1TuKd+j8PRouf/UJr3KQSrpujXNgEcWy6KowyvHDM3NWPcudRX9gbxWsP+uZmUXL5m+qZAeJtde58pQsXsF+SOWQlk5tlI9wm8ll0HbHep/zaNKMpnzT+zCVxn54rH6IfzzIm66kaVt393PTXuf1wumiNAtGhFRy67/Nab1mH0lbl2ZPsDm2Zj551qhXpXcBgbhGpguYklbSMUGjf072wM48HaYvVlmzT1qX2/pZQz5uRcLJYlrKycjyz1lUeDs/0nZ8wzvBpqUfwqEEj8u2gDJvCuD1YNtywqZlTEPRv5xnWhAgzmXu0gYNCH4bFKAhNpMyL4lL4XW/r3ag+6fPUS/Vhlzburx1wfddRWXiMMFl4va9i1dB4NkkPzXiGUStbxLeo65PFJYXa5zjUBWCDG2FHs0t6549AxQ5hoNLPynrXn679NpEJH3mz5a6BsQSc3TlxEhsnZeci66+zScYvKLJj8XBzexAXW616UnA5gW9NvhWqlPrK0RYs1dk/pIgFdoynyACE8DEqj4DB+cUiKGznk7SXPUh2RRxCHeCEnrYFzlkD/dvwmjPpyQIb1cY7W2UECzwN6O3uL4B8yyKEFKi7DSNlWjUbCDyHKEtSKfwH5Tlq1SeIh5LFdtfDEIEdOScpzMFmqEzaDi47azo7sXHGJ93AUO/rLUSheuEpoM7xsH/W6rYnCUVAiS
 sJH9XLf4
 bHg/Ky7Uxg0VXrMqO/Lls5oTt+gCQ2LFBPXv42byCeztJ401M9n7K8rgCR5yYKm2Ctzmyg9SzCe3aY2VECMZ0h2agxY44RkWMPuUMZfNtNlXiI1X1ZNk8T2wFBa/4/EMcBRAnJwQ1KvEt03x5PRzcbEza5fs9vhm87CvdMQG58T6+hcarir537SDwO0Ec2XX8erVXGSNxwTEsgsy9X9xjJ+8uS1Ie9Yx75gpfIA6/fAktk+wfDrv/siNhRkoJzB0+OKDGTBBZLKMr4nmQERJW3OOrqS7wff4K+U1EGKe/4HF5mOFn8pB75EMB3/JNbyIodOP0EEjV7gyRnk+Gj8MpG0SLLgwiz30eaI52u8/YQQmBzZFEBtwODqf2o5c8kTYZmLzF3+KGloiw3SdV/HOmqokY8z23YobfYxXq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

charge_reserved_hugetlb.sh backgrounds write_hugetlb_memory.sh and immediately stores $? in write_result.

That only records whether the background job was started successfully, not whether write_hugetlb_memory.sh itself later failed. As a result, the test can miss reservation failure and OOM-kill outcomes that are inferred from the writer exit status.

Redirect the writer output straight to the temporary log file and wait for the background process before inspecting write_result, so the test records the actual exit status.

Signed-off-by: CaoRuichuang <create0818@163.com>
---
 tools/testing/selftests/mm/charge_reserved_hugetlb.sh | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
index 447769657..2f52ad7c8 100755
--- a/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
+++ b/tools/testing/selftests/mm/charge_reserved_hugetlb.sh
@@ -193,9 +193,9 @@ function write_hugetlbfs_and_get_usage() {
     [[ "$private" == "-r" ]] && [[ "$expect_failure" != 1 ]]; then
 
     bash write_hugetlb_memory.sh "$size" "$populate" "$write" \
-      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" 2>&1 | tee $output &
+      "$cgroup" "$path" "$method" "$private" "-l" "$reserve" \
+      >"$output" 2>&1 &
 
-    local write_result=$?
     local write_pid=$!
 
     until grep -q -i "DONE" $output; do
@@ -223,6 +223,8 @@ function write_hugetlbfs_and_get_usage() {
       sleep 0.5
     fi
 
+    wait "$write_pid"
+    local write_result=$?
     echo write_result is $write_result
   else
     bash write_hugetlb_memory.sh "$size" "$populate" "$write" \
-- 
2.39.5 (Apple Git-154)


