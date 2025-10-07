Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E724CCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 10:29:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C79F8E0012; Tue,  7 Oct 2025 06:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89F0E8E0005; Tue,  7 Oct 2025 06:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC228E0012; Tue,  7 Oct 2025 06:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCFB8E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 06:29:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 142871A0263
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:29:52 +0000 (UTC)
X-FDA: 83970947424.17.ABFBB5A
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id 849EF14000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 10:29:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759832990; a=rsa-sha256;
	cv=none;
	b=kM4y/Yrw2MGFcUqrmMn3ka9UDP7ahqMcvG1b6Qvvr2+Q0BTOt4ETDlD28hc9zfgim4YEy/
	jEmbrB8OVD/QpUTZkBOqJV0pQquErIw2bXPSfX2ojxTASh/X3vdc5aN2qkD9OjefFTo35f
	tWIWTVAqXfNPXWvjJQ+vW/+0I8ySZTU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759832990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dTsj+hpSU1wAVqD1q79rqGDKIgmnZVsk//OtGQduN90=;
	b=pkopZ4xNpMn7vwwRmkTJns/UiEJy7f0v4N5luWlBYoqVB75vf//49dJIUhEWvoyF7Nbx3W
	2vKoRsdEyMKeJ6KotDxq6bNUs71Z4ld4AKe96rR/qtohuvkFu9tfJhAv7jkz3pNC2KfooI
	tnIKKM2DS2vJ6H6ygBo/fx1+WrOysNc=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4cgsp222dYz5PM34;
	Tue, 07 Oct 2025 18:29:46 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 597ATXmE018488;
	Tue, 7 Oct 2025 18:29:33 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Oct 2025 18:29:35 +0800 (CST)
Date: Tue, 7 Oct 2025 18:29:35 +0800 (CST)
X-Zmail-TransId: 2afb68e4eb8f049-615f1
X-Mailer: Zmail v1.0
Message-ID: <20251007182935207jm31wCIgLpZg5XbXQY64S@zte.com.cn>
In-Reply-To: <20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn>
References: 20251007182504440BJgK8VXRHh8TD7IGSUIY4@zte.com.cn
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>, <akpm@linux-foundation.org>, <david@redhat.com>,
        <tujinjiang@huawei.com>, <shr@devkernel.io>
Cc: <akpm@linux-foundation.org>, <david@redhat.com>, <tujinjiang@huawei.com>,
        <shr@devkernel.io>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        <yang.yang29@zte.com.cn>, <wang.yaxin@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIGxpbnV4LW5leHQgdjIgMi8yXSBzZWxmdGVzdHM6IHVwZGF0ZSBrc20gaW5oZXJpdGF0aW9uIHRlc3RzIGZvciBwcmN0bCBmb3JrL2V4ZWM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 597ATXmE018488
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 07 Oct 2025 18:29:46 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 68E4EB9A.000/4cgsp222dYz5PM34
X-Stat-Signature: 3ti5sxqk7wtf77z67fkipxrk6b1khmof
X-Rspamd-Queue-Id: 849EF14000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759832989-220816
X-HE-Meta: U2FsdGVkX1/DmfExfzcrq8VrCdll3cpigoCsNrY8S+92l+5nR8H0P/83LNUwOoWfuBZ97jdjtn9/FRXHTE7jjWj1qsVRnVXydVTZp9jngIc4RyjUq8y9Gha6+ho8RGavzCkfrvJNfle0VBTudHvqFXGhx2sJ3WSDuRE1AKPgn7HMhT/VZWdmld6KZZGn1hlYLFy/10oKQWSu941QZyr8a9mLbA8Bv8QrZv5pPbIILFfv6QuDa0ZRlsuQlKyGKzgN6HW8R71keiDkr9BcXXfybQMh9sNYayoNxL+RazGj7qU2EtaoLDK85sCDjNw9Q5k8pKKXyLGe0pd6vqbhnBA/cjOgoi+4h2UG9a8d2sVxZ2zbR1S2kh9kEoo0BRd1TwgSKqhESAodSW+hSG2jRpGCS99VZMK1M2tRk6BhoTWUinVTiycG5IgO7yLAlATJtLFEBNCFEHMpAeaZ2Ow9/d5IoKDUpz9eoLSudvlWuqNb103uNKJI9Pm4Vgni0QELL7XYvagZG9FruhnoEYfwFTPCJwD7MIKp3+InSlqdfax67cagD/0maqfqIp6BPDW9drvuuuCn9Hn10bl063DXN6mqpjHH7NVy9s9unB6mJsBhGXSz+iLCzE0n9wQga7HMtDLLAH/EyhCqrwPV/RsMSJnQgi0+FPglApjksOJ6Q2bALpElUnhCqMlE11014VZOMt544U0k1n8SFpopGP3CA7V3lHfQxhvNpLE8hHFzQMfIMt+MJFJZdkdW8YIcSDGhghMUPa5Znza/Ot7RVyRUeThHqF9UN6eFoFwQPeB01vZ5FmsiG8QwTMoTCR8BkOIYk6A+PmK11Dq1FAsylaqei55A9wjQoREpOXt8nfb1gfHfoNN1rgiwKsUncw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

To reproduce the issue mentioned by [1], this add a setting of pages_to_scan
and sleep_millisecs at the start of test_prctl_fork_exec(). The main change
is just raise the scanning frequency of ksmd.

[1] https://lore.kernel.org/all/202510012256278259zrhgATlLA2C510DMD3qI@zte.com.cn/

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 .../selftests/mm/ksm_functional_tests.c       | 57 +++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/mm/ksm_functional_tests.c b/tools/testing/selftests/mm/ksm_functional_tests.c
index ac136f04b8d6..95afa5cfc062 100644
--- a/tools/testing/selftests/mm/ksm_functional_tests.c
+++ b/tools/testing/selftests/mm/ksm_functional_tests.c
@@ -38,6 +38,8 @@ enum ksm_merge_mode {
 };

 static int mem_fd;
+static int pages_to_scan_fd;
+static int sleep_millisecs_fd;
 static int pagemap_fd;
 static size_t pagesize;

@@ -493,6 +495,46 @@ static void test_prctl_fork(void)
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }

+static int start_ksmd_and_set_frequency(char *pages_to_scan, char *sleep_ms)
+{
+	int ksm_fd;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	if (write(ksm_fd, "1", 1) != 1)
+		return -errno;
+
+	if (write(pages_to_scan_fd, pages_to_scan, strlen(pages_to_scan)) <= 0)
+		return -errno;
+
+	if (write(sleep_millisecs_fd, sleep_ms, strlen(sleep_ms)) <= 0)
+		return -errno;
+
+	return 0;
+}
+
+static int stop_ksmd_and_restore_frequency(void)
+{
+	int ksm_fd;
+
+	ksm_fd = open("/sys/kernel/mm/ksm/run", O_RDWR);
+	if (ksm_fd < 0)
+		return -errno;
+
+	if (write(ksm_fd, "2", 1) != 1)
+		return -errno;
+
+	if (write(pages_to_scan_fd, "100", 3) <= 0)
+		return -errno;
+
+	if (write(sleep_millisecs_fd, "20", 2) <= 0)
+		return -errno;
+
+	return 0;
+}
+
 static void test_prctl_fork_exec(void)
 {
 	int ret, status;
@@ -500,6 +542,9 @@ static void test_prctl_fork_exec(void)

 	ksft_print_msg("[RUN] %s\n", __func__);

+	if (start_ksmd_and_set_frequency("2000", "0"))
+		ksft_test_result_fail("set ksmd's scanning frequency failed\n");
+
 	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
 	if (ret < 0 && errno == EINVAL) {
 		ksft_test_result_skip("PR_SET_MEMORY_MERGE not supported\n");
@@ -542,6 +587,11 @@ static void test_prctl_fork_exec(void)
 		return;
 	}

+	if (stop_ksmd_and_restore_frequency()) {
+		ksft_test_result_fail("restore ksmd frequency failed\n");
+		return;
+	}
+
 	ksft_test_result_pass("PR_SET_MEMORY_MERGE value is inherited\n");
 }

@@ -656,6 +706,13 @@ static void init_global_file_handles(void)
 		ksft_exit_skip("open(\"/proc/self/pagemap\") failed\n");
 	if (ksm_get_self_merging_pages() < 0)
 		ksft_exit_skip("accessing \"/proc/self/ksm_merging_pages\") failed\n");
+
+	pages_to_scan_fd = open("/sys/kernel/mm/ksm/pages_to_scan", O_RDWR);
+	if (pages_to_scan_fd < 0)
+		ksft_exit_fail_msg("opening /sys/kernel/mm/ksm/pages_to_scan failed\n");
+	sleep_millisecs_fd = open("/sys/kernel/mm/ksm/sleep_millisecs", O_RDWR);
+	if (sleep_millisecs_fd < 0)
+		ksft_exit_fail_msg("opening /sys/kernel/mm/ksm/sleep_millisecs failed\n");
 }

 int main(int argc, char **argv)
-- 
2.25.1

