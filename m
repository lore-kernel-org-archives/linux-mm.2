Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70ECD606A335
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 07:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=kGnzMWBf
Received: by kanga.kvack.org (Postfix)
	id 629E76B05B0; Sun,  8 Nov 2026 02:28:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA616B05B1; Sun,  8 Nov 2026 02:28:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFB46B05B2; Sun,  8 Nov 2026 02:28:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5696B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:28:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D0A21A0461
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:28:00 +0000 (UTC)
X-FDA: 85411122720.19.3D224EF
Received: from mta1.migadu.com (out-37.mta1.migadu.com [95.215.58.37])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9ACD8C0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 07:27:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGnzMWBf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794122879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=as9n+dNBfp1o44qNiI4p9jEq0z77VwxPRRD44uR3xLY=;
	b=J5hXB2YaL5d8d8gu7c3DRF/rLAiVIkfRTViWTaxMbFLGFjeZrhMqOB8yk/TDeit3ggGbVR
	JHRNq11RQWCmNs/rS5+L1Uxq/C3xFnT0QBbZ191iXda78y2DqO6DMvcDfMM3dbMNRb6pMX
	N6oCqXKTv2TVyJ2Du7uUOwaBNaaSKgg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794122879;
	b=3z2ts9gfwFajx9+Gh+CSHxiHErTsZ1er2i/n9Nj9Hdu8zdi1Di830uAKEkFonXmHlh0v8p
	ZnyLVAovROgN7l5LKRPy2E+WIsUzE4p4VTuUpjVYmsHxU9Ai0aVFlRl8ljDSSNYuH8GAIZ
	c8D/2Y9XnIYo858XlZkMEvwKKggoZxw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kGnzMWBf;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.37 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4elqSwc3DAM5howwrqEHgu/Vk/FDsIcZJHWFPI3k6NI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794122876; v=1; x=1794727676;
 b=kGnzMWBfJQp2yk7gP3ByV94Oo30xQFkPnUMzpcRgIJvdiUTW9kyykkDH+8oZRtl+Tyn+HjvV
 VeWkGBNVcS9QrhAD29IxJSX59Jok/a4o84XAcwElVSYYeLsp1ZF3NOXosZIkUiArfW0aJGHc1z6
 LZyHphbVB6KgHSawy6iZBj7k=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 7e7fadc3522c9a21;
	Sun, 08 Nov 2026 07:27:56 +0000
X-Mizu-Trace-ID: 7e7fadc3522c9a21
X-Migadu-Flow: FLOW_OUT
From: Zenghui Yu <zenghui.yu@linux.dev>
To: linux-kselftest@vger.kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	hao.ge@linux.dev,
	abhishekbapat@google.com,
	brauner@kernel.org,
	aniketgattani@google.com,
	peterz@infradead.org,
	thehajime@gmail.com,
	Zenghui Yu <zenghui.yu@linux.dev>
Subject: [PATCH] selftests: Add missing generated files to .gitignore
Date: Sun,  8 Nov 2026 15:27:35 +0800
Message-ID: <20261108072735.36842-1-zenghui.yu@linux.dev>
X-Mailer: git-send-email 2.56.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d4eden8fuetooz3ji58xut8sfpp39jej
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9ACD8C0003
X-HE-Tag: 1794122878-993189
X-HE-Meta: U2FsdGVkX1+TCRuf1veVt9Zhvm8e7BzB3WkOtpjQgSxludINWBS46qYpIgAxYtnJX5LIW4grh/NV53P+ySGCEW+mwj/J0Way5pGBArS2E/YvzR/vFF0LmaJ2bHAbRhsIxmuaWtPXCAS9WGYGczd2debQnJxrpqp7z/dxx5jzh2VTKIJUitR62CLTn72VveoASS67oh5PTZrZJcBxp43ooue0iloO7VntUbSlJ8TqNgBLDFfOpUzDg6oNEYUCPbTJFXKB0T3oPsrBruV2B22Pm0WKoJ1rVErM2gynBbXzdRDubC3y8EmlVAtlCg75L/dijF6uDo2ZvKaO2AkGbxykGV9i7XiL6Pc1A/2H3/IWNWh6wJzRRymLCe3272Xl9uyQqfHpH+gx7QOYIRHWBQhwUJH3xW1Y/F/bqGhWa77JWX/XzGKnw/511PmQXQ/Z8i4d2s4IgJwjYYzRD/Dlj8Gj8DrDlk9TKwYS1XHJ2rE4PumACEXorYaYo7sDyjGWJU3e4qi5tTMWYsZCYJX6bSF8dwzO4FOpomVdHhs7V1RtrF+gW/3Eri8MG4gqNrB2TwP/ooiRU/bR3ldggAe0cQwiHJjlMzrKdfzTGnxtllJkfWzPZ6zS/oeNS30tORYUZB1labU5GKEOodAzE1Y/dUOnRXvRAARFEOUd7YLNrWbF4J6wNaa3FWsGFcs0rQdTHk8WnM1UhIOtnF0Jga40CHLV72FMYd4P/afIhkM+l+z93WQFCVqaAgntdlVYaOmRQUcNagjIDHZdgwR4R1CHl2SzG2oq3HrBPKvE4fqTPdpRBfajw57+tr/bP0eYSjeiz3VWDmrh69n61hF1v9Z+72xlsgiN8T0Abrj0axm0W79XseZV1TP7DTkAZUur9b0Cv1OkrzXL7a4z5i5aJSs2Ao33FMlXaU5dKSd71ftmZBLC5/Kg8G8sIJHP+Ig1X6MD5lxKixTbCTx/zhPHnkWJRM7
 i70npAEB
 A1snOrUElOeWjP6grb7kxf3CceW/CCzACkMisTQsn0MPKFle7mJ4Kos/sO0En2KBN96Vy2/3igKAbdnPfsamflWcb6WUAFF99iw9lEpvEM1KJyK1sFdgJ6h1RH3adnqZnsZsKzG2DednOVHCT5maQ7uwjARGHUcka9U0ncY42bV1wihGQAuy+VjKQB58vdaXAbO+HN+GqGwJK7N86/fAKkpdLtiL6jUnQjiza
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add .gitignore entries for test binaries that are generated during
a build but leave git status dirty, and add the missing .gitignore
files for the alloc_tag and nommu directories.

Signed-off-by: Zenghui Yu <zenghui.yu@linux.dev>
---

These are all trivial one-liner changes, so I have folded them into a
single patch. Please let me know if you would prefer it to be split.

 tools/testing/selftests/alloc_tag/.gitignore  | 2 ++
 tools/testing/selftests/coredump/.gitignore   | 2 ++
 tools/testing/selftests/exec/.gitignore       | 4 ++++
 tools/testing/selftests/membarrier/.gitignore | 1 +
 tools/testing/selftests/nommu/.gitignore      | 3 +++
 5 files changed, 12 insertions(+)
 create mode 100644 tools/testing/selftests/alloc_tag/.gitignore
 create mode 100644 tools/testing/selftests/nommu/.gitignore

diff --git a/tools/testing/selftests/alloc_tag/.gitignore b/tools/testing/selftests/alloc_tag/.gitignore
new file mode 100644
index 000000000000..30fa3b6712c0
--- /dev/null
+++ b/tools/testing/selftests/alloc_tag/.gitignore
@@ -0,0 +1,2 @@
+# SPDX-License-Identifier: GPL-2.0-only
+allocinfo_ioctl_test
diff --git a/tools/testing/selftests/coredump/.gitignore b/tools/testing/selftests/coredump/.gitignore
index e32f6e9006f6..6a9460c4450f 100644
--- a/tools/testing/selftests/coredump/.gitignore
+++ b/tools/testing/selftests/coredump/.gitignore
@@ -4,3 +4,5 @@ coredump_socket_test
 coredump_socket_protocol_test
 coredump_signal_test
 coredump_worker_test
+coredump_notify_signal_helper
+coredump_notify_signal_test
diff --git a/tools/testing/selftests/exec/.gitignore b/tools/testing/selftests/exec/.gitignore
index e42ecd4c908d..d39df26e5cf9 100644
--- a/tools/testing/selftests/exec/.gitignore
+++ b/tools/testing/selftests/exec/.gitignore
@@ -28,5 +28,9 @@ binfmt_transparent_interp
 binfmt_misc_loader
 binfmt_loader_payload
 binfmt_loader_payload_static
+binfmt_bind_interp
+binfmt_misc_delim
+binfmt_misc_disabled
+binfmt_misc_selfpin
 *.bpf.o
 vmlinux.h
diff --git a/tools/testing/selftests/membarrier/.gitignore b/tools/testing/selftests/membarrier/.gitignore
index f2fbba178601..031920478205 100644
--- a/tools/testing/selftests/membarrier/.gitignore
+++ b/tools/testing/selftests/membarrier/.gitignore
@@ -1,3 +1,4 @@
 # SPDX-License-Identifier: GPL-2.0-only
 membarrier_test_multi_thread
 membarrier_test_single_thread
+membarrier_rseq_stress
diff --git a/tools/testing/selftests/nommu/.gitignore b/tools/testing/selftests/nommu/.gitignore
new file mode 100644
index 000000000000..37da7c4765cd
--- /dev/null
+++ b/tools/testing/selftests/nommu/.gitignore
@@ -0,0 +1,3 @@
+# SPDX-License-Identifier: GPL-2.0-only
+nommu_mmap_test
+nommu_mremap_test
-- 
2.56.0


