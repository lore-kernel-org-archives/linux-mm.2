Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 536B4CD3426
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 12:52:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6E16B0092; Sun,  3 May 2026 08:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B87C16B0093; Sun,  3 May 2026 08:52:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC5466B0095; Sun,  3 May 2026 08:52:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E44E6B0092
	for <linux-mm@kvack.org>; Sun,  3 May 2026 08:52:01 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44FD11C06FB
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:52:01 +0000 (UTC)
X-FDA: 84726096042.15.C70BE93
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id A5F1010000A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 12:51:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777812719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hPvs3ZjVHMrpbqTipkAKNTxujShUB8DclDIc4rJtWTU=;
	b=6vsHqS5LNzW24OfqBRZEYoKvRHjNbJj/vNITJtqnHE3VcG63aDDaYnb2HExN9wvQwSrlzl
	qtknfmJPVxdxzm0Bn//ZvI/drwyNHQxszgAEiUT6/XQkYyC8cZxF0gexna3TseG2XvBoi1
	7ExO1vGNkZWTwFPHYVEF2W3RRD2Wwb4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777812719; a=rsa-sha256;
	cv=none;
	b=CRJI6dv/C8usODiGkYIM1wGb27n59c6fZIlcdpI7wHNMYviYGl3G3vWFjQntlWrySBWF81
	N4Zk1RfPYRjMkGjzUJ+h5wqe4GPHdSR9JodqeVUlN6KsQwT6JtXd/76biFKwnCDKZnPAxI
	ZGVtwwD1Qebw/UFAg/jKJ6xqvWlYPOA=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4g7l625Tvnz5BNRf;
	Sun, 03 May 2026 20:51:54 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 643Cpoo4020031;
	Sun, 3 May 2026 20:51:50 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Sun, 3 May 2026 20:51:53 +0800 (CST)
X-Zmail-TransId: 2afc69f744e99ac-4e67f
X-Mailer: Zmail v1.0
Message-ID: <20260503205153715oK1yza2bba5lfAl3QwiPx@zte.com.cn>
In-Reply-To: <20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn>
References: 20260503203538194jFwVGloy43M1F3sQGaFt7@zte.com.cn
Date: Sun, 3 May 2026 20:51:53 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <ljs@kernel.org>, <akpm@linux-foundation.org>,
        <xu.xin16@zte.com.cn>
Cc: <hughd@google.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <michel@lespinasse.org>
Subject: =?UTF-8?B?W1BBVENIIHY0IDUvNV0ga3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 643Cpoo4020031
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Sun, 03 May 2026 20:51:54 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69F744EA.002/4g7l625Tvnz5BNRf
X-Stat-Signature: d8n43rz96xu7bqn4cmg3dsdy35nrc1w5
X-Rspamd-Queue-Id: A5F1010000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777812717-495886
X-HE-Meta: U2FsdGVkX1+KNDDClpLnFykAB6yEu9zWiT0swlxBdBDFdH+36yL6a5DSqPXURK8YSKndkwd3MeyW2fJE7Hhl3SmWs35RVhJBs8+4MZMQCW37MoUq/rDsHOFti3SDhcQq7ewLLXoK7dKidS3DPepYmVNuo7/Uj2x3nzlbAeX1jt409g2bBBy0YFjoJoxn4Q8u7f4KwWky+xN62KHEBbktRjBFHgs9ta+5jOFJMLf3FRbGIc5vgF+f884Lfr6PP+hDqle1SjX01JFKXL9mnQ9agqK62+KbZ2uekMndJgh/BC/xk0fLi1gIouN247thQtQU4TdbSQAyG8EzsH3iIpfPXpzVULpdlFCPByjdm+LJmcDgZXgQv5VtMr6EovhAszKOodoJndqnUd5sChW0a+xFlcyrNjc+7JpQAkticjcqqbBWaxthO1FVuMA/dAtOVvWoEO12+Yul6XzAV1Tk/A5iquSowbwmM+6it+tU8v6kUgImz9H+BL/VQe/CK4k4+leKypyHfR/SyJb4DDvtVyQICfHIWxOdDntlwOeRj9toYeAaO/MqEZ7qrwzc7O4bJK0dnY8KSscGE8OpXGrDZleRoC2WDWIDATPype/Kbvl1vdQXEMG+jM8HaNcXkTMsBkxQnUEz7aWnRezSTvc3J2llb1kH83m4nq/jsJgt8Bnv+1W3AJPl8K2neYQwRXj/76VUkw7IyFASudF5kTrbbBz6yIzpelbw3KGnMHniSpkCDj6TOZysq+AYP2l/fZlA0s1PDYtvy5R1Bl1UTVgLfm67jU6nDjK0gxxn7XpnJKrdEPL75NcHSuIOzy8iYeSS0GO756mL3b9u1nRHmf0gBkBIsadWVzTJy1rrZRA4pMTqxwvki3Pq2kesiQUdBtG3poosC+ulAHYdNw4BpBOhtaleLzXZk5ATfOuZvU0FUxqNdrL5/GWB36sNcIKpaISZqb/ZqhUMOLhbIDgJmnRmu62
 UmJ5YIGY
 yg8v5w309qfyPmn6khDUhMJtuUFAEvHxNptBwZIFvjRrcNY84eJFJXFEjxTE57zWx7jglvNnUYekGx3XhNGk3jWk3WbKbVx7wAS5cLukHddo1cyOV0+8PHgldJL9Duw7U6Ildd+uJJObRCSuGxglJ06l7f2AFl4g95FsIwK3TqtD+9Gn8gs6/VTjCkmESO0ptSSFJQppr7yg1OV3TMNwW6a0YRrPlS6AiEyZC+KLuQHIgqZheked6np0CfHyqek1mDLgyx9CY1S3xJrlKHUfIBloq/CVVJs2DL/AR/oUpRHvTYrHWsIVsD783YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>
The existing tools/testing/selftests/mm/rmap.c has already one testcase
for ksm_rmap_walk in TEST_F(migrate, ksm), which takes use of migration
of page from one NUMA node to another NUMA node. However, it just lacks
the scenario of mremapped VMAs.

There are one worker process and several checker processes, and in worker,
we add the calling of mremap() and then trigger KSM to merge pages before
migrating, , which is specailly to test a optimization which is introduced
by this patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address
range"). In other checker processes, we just trigger KSM to merge pages
from each child process and check their PFN.

This test can reproduce the issue that Hugh points out at
https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/testing/selftests/mm/rmap.c    | 79 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 +
 3 files changed, 119 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..fced1f6304ac 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,83 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }

+static void prepare_two_pages(struct global_data *data)
+{
+	/* Allocate exactly 2 pages for the test */
+	data->mapsize = 2 * getpagesize();
+	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (data->region == MAP_FAILED)
+		ksft_exit_fail_perror("mmap failed");
+
+	/* Fill both pages with identical content to encourage KSM merging */
+	memset(data->region, 0x77, data->mapsize);
+}
+
+static int mremap_merge_and_migrate(struct global_data *data)
+{
+	int ret, pagemap_fd;
+	void *old_region = data->region;
+	unsigned long page_sz = getpagesize();
+
+	/*
+	 * Mremap the second page to the first page's location (FIXED).
+	 * This effectively overwrites the first page, leaving the second page
+	 * unmapped. The physical page originally at the second page is now
+	 * mapped at the first page's virtual address.
+	 */
+	data->region = mremap(old_region + page_sz, page_sz, page_sz,
+			      MREMAP_MAYMOVE | MREMAP_FIXED, old_region);
+	if (data->region == MAP_FAILED) {
+		ksft_print_msg("mremap failed: %s\n", strerror(errno));
+		return FAIL_ON_CHECK;
+	}
+
+	/* Ensure KSM is active and wait for merging */
+	if (ksm_start() < 0) {
+		ksft_print_msg("KSM start failed\n");
+		return FAIL_ON_CHECK;
+	}
+
+	/* Attempt to migrate the merged KSM page */
+	ret = try_to_move_page(data->region);
+	if (ret != 0) {
+		ksft_print_msg("migration of KSM page after mremap failed\n");
+		return FAIL_ON_CHECK;
+	}
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd == -1)
+		return FAIL_ON_WORK;
+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
+
+	return 0;
+}
+
+TEST_F(migrate, ksm_and_mremap)
+{
+	struct global_data *data = &self->data;
+	int ret;
+
+	/* Skip if KSM is not available */
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
+
+	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+	if (ret < 0 && errno == EINVAL)
+		SKIP(return, "PR_SET_MEMORY_MERGE not supported");
+	else if (ret)
+		ksft_exit_fail_perror("PR_SET_MEMORY_MERGE=1 failed");
+
+	/* Assign the three callbacks required by propagate_children */
+	data->do_prepare = prepare_two_pages;
+	data->do_work = mremap_merge_and_migrate;
+	data->do_check = has_same_pfn;
+
+	/* Run the test in a process tree to stress rmap locking */
+	propagate_children(_metadata, data);
+}
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index db94564f4431..a33a4069de7c 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -648,6 +648,44 @@ long ksm_get_self_merging_pages(void)
 	return strtol(buf, NULL, 10);
 }

+long ksm_get_pages_shared(void)
+{
+	int ksm_pages_shared_fd;
+	char buf[10];
+	ssize_t ret;
+
+	ksm_pages_shared_fd = open("/sys/kernel/mm/ksm/pages_shared", O_RDONLY);
+	if (ksm_pages_shared_fd < 0)
+		return -errno;
+
+	ret = pread(ksm_pages_shared_fd, buf, sizeof(buf) - 1, 0);
+	close(ksm_pages_shared_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
+long ksm_get_pages_sharing(void)
+{
+	int ksm_pages_sharing_fd;
+	char buf[10];
+	ssize_t ret;
+
+	ksm_pages_sharing_fd = open("/sys/kernel/mm/ksm/pages_sharing", O_RDONLY);
+	if (ksm_pages_sharing_fd < 0)
+		return -errno;
+
+	ret = pread(ksm_pages_sharing_fd, buf, sizeof(buf) - 1, 0);
+	close(ksm_pages_sharing_fd);
+	if (ret <= 0)
+		return -errno;
+	buf[ret] = 0;
+
+	return strtol(buf, NULL, 10);
+}
+
 long ksm_get_full_scans(void)
 {
 	int ksm_full_scans_fd;
diff --git a/tools/testing/selftests/mm/vm_util.h b/tools/testing/selftests/mm/vm_util.h
index 1a07305ceff4..3b40727c3f1f 100644
--- a/tools/testing/selftests/mm/vm_util.h
+++ b/tools/testing/selftests/mm/vm_util.h
@@ -151,6 +151,8 @@ void *sys_mremap(void *old_address, unsigned long old_size,

 long ksm_get_self_zero_pages(void);
 long ksm_get_self_merging_pages(void);
+long ksm_get_pages_shared(void);
+long ksm_get_pages_sharing(void);
 long ksm_get_full_scans(void);
 int ksm_use_zero_pages(void);
 int ksm_start(void);
-- 
2.25.1

