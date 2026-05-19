Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBE78CD4F5B
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 14:18:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42D6D6B009E; Tue, 19 May 2026 10:18:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DE5D6B009F; Tue, 19 May 2026 10:18:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31C076B00A0; Tue, 19 May 2026 10:18:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E1D46B009E
	for <linux-mm@kvack.org>; Tue, 19 May 2026 10:18:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B1A27C188B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:18:17 +0000 (UTC)
X-FDA: 84784374234.25.0CDACAD
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf12.hostedemail.com (Postfix) with ESMTP id 47DE84000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 14:18:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779200295; a=rsa-sha256;
	cv=none;
	b=go+lv+iFAJDnHvYX6LWMNi5257+rVrDVRaXur5wfTDUoD6HwAiDm4j9QYJl5PTVZeu0BuO
	cfK1tclOzGKbIE7UvKRfokEETrTpht/jec17fbyRFdJWK28cN68oj6GD1s8CBwg4piPZAt
	hnB8kCQO37y5YYcJdvGI7kPSWc1kHBA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779200295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDqKiZsbhGc0iulp05C+EbmF8iZnbs2KOC3O4DpkYto=;
	b=rOgLca7xyyA+pR+UrZCkvVCLdryb3aAWTnYl0/pUNfM3InFbyOhRy64b60Xrg7RYYryIKz
	00E3LACD5lun0hFpcsZv27yxF5Y6chT3XG0Qsx7EJE4ZHNJrEWObATi6a01aT3a7ZOB8xW
	LKX9DaRErkKaboTz588Ob71QAK9Q9q8=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gKcG4614Yz4x6Cw;
	Tue, 19 May 2026 22:18:04 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl1.zte.com.cn with SMTP id 64JEI1ch062919;
	Tue, 19 May 2026 22:18:01 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 19 May 2026 22:18:05 +0800 (CST)
X-Zmail-TransId: 2afb6a0c711d7d0-f5d4d
X-Mailer: Zmail v1.0
Message-ID: <20260519221805076ac4m_iQchFDe37JqE1wW1@zte.com.cn>
In-Reply-To: <20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn>
References: 20260519220536792dMIKRMurt3vZ5lXC5pwh8@zte.com.cn
Date: Tue, 19 May 2026 22:18:05 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <ljs@kernel.org>, <hughd@google.com>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <michel@lespinasse.org>,
        <corbet@lwn.net>, <wang.yaxin@zte.com.cn>, <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY1IDUvNV0ga3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64JEI1ch062919
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Tue, 19 May 2026 22:18:04 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0C711C.000/4gKcG4614Yz4x6Cw
X-Stat-Signature: hh447brewqtsz5axaxg49hqw7y7qykj4
X-Rspam-User: 
X-Rspamd-Queue-Id: 47DE84000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1779200295-189708
X-HE-Meta: U2FsdGVkX1/xRv8ZJ1pM2FnAIoD4Yze+C0Pm3ADcFvkJluptdL/FzeYIjQ6m70mpUOGPAtvRUQy8VNkPUM3Al/2nJtXC7FDD8llyJkU42wpFXBUwPEAfVD/BfgxeTpXz4j2nyHG5b64epxv0J3g+XmowrGRJdJqfkpvWYZm15+O3yCKxXSAGWDZtPTexS3Ow/lwg9HQ5rwSKWpEr87TKlLF7BU51ksNqMF9EIJfb6pXdZ4P2GoQvaqKckGSI18sgBz/ECMFym/YrFBkKZhovwRRzfCr/8DJW7jB6dYXlxdcYmpWu+UmxOHRhaadWLfnxEaMFicOcNnbIno7zV5FAvhm5nkMuOVmX8vj56C33411SnF9+cBZlEiYE9NpupP5qquqwH5FaVbHF91O5L4frVGPMa/hcZEw1mjXebt3Z6hbgMrK+od2Tqlm/zpMbMYXxKG3aXBKq5UoS7QvM4qLwTKkokyodwNsvEgSuLklhoFUTA1vvE/Go2ZwyF73olDrHH9yn2RM2jkV5wdD361WTCtTdl761nmcGhAou56Mvfyi/CyVlprZPOG3Qfwn7gTsgzp0kCElZGY2Ub8oTqMWtbPH7WiTaY4qGow05uu2Q/DR/hRTFdrIZXly6TfJJ821FT1sJzONpOr461CabMlJiVwCc9bWwr5gRZpBVo3Cjd+ukfNBHbs5IjXMlBcJO4v8eIJfRi5CLl8WEWf78BXB6Ar/QpGzUpzxY0z9y5P+K2QtcV3Zupcxl944bOu5LkigbA5Kh49sOQEGATz0MBAwacqeXujfpS7x/UvERDZYkL4pv/24Pf9WSYbVLHmL9B2X71Z7Z1ZR2OS58soUB1FoTblmFIfy1AY93j4q4sL6zPLYtvFasZv1AGzQqx2f7arE60pZ8jTBVFhbzeXA0AGLKrhhZ1nFBZYIMCOPr9ePIQOh07TCKJWXmcgSRSYWQFrAXcTddjl7FEZKMMetQP+i
 MFIE3rNE
 LCPC2UcVxKvB8H8ukURA+48bXXJj2No8/xuEp4LH0/5Lhh8P4T7WqnIEy5ddBn9BnHIbb4S+E7ugy41V50lngXGJn8s106m8Jgx5LqKL2umJfwjlfJkA9S2IBPrWUeykaCvqUqsGl35TLyRNdRhu+65HXioqYSp5YBEQUUXj+0/qnlwKAR0yk+hYjDy00Zz9XjrxkwvCoL/6QBWVJkwjZbvp25xpSwPpepM84kU43Z5cE8x1Mk2JR/Fz0sQVRkTYW+FSxUWinVfprmKFvZ35r7RVyNv48CMqcjaVAPXuIIuaZi7JrT0bFGOXMWg==
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

We add the calling of mremap() and then trigger KSM to merge pages before
migrating, , which is specailly to test a optimization which is introduced
by this patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address
range").

This test can reproduce the issue that Hugh points out at
https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/testing/selftests/mm/rmap.c    | 76 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c | 38 ++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 +
 3 files changed, 116 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..f3eb693872ac 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,80 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }

+static void prepare_pages(struct global_data *data, int nr_pages)
+{
+	/* Allocate exactly pages for the test */
+	data->mapsize = nr_pages * getpagesize();
+	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (data->region == MAP_FAILED)
+		ksft_exit_fail_perror("mmap failed");
+
+	/* Fill all pages with identical content to encourage KSM merging */
+	memset(data->region, 0x77, data->mapsize);
+}
+
+static int mremap_merge_and_migrate(struct global_data *data)
+{
+	int ret;
+	void *old_region;
+	int nr_pages = 32;
+
+	prepare_pages(data, nr_pages);
+
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	old_region = data->region;
+	/*
+	 * Mremap the second harf region to the first harf location (FIXED).
+	 */
+	data->region = mremap(old_region + data->mapsize / 2, data->mapsize / 2,
+			      data->mapsize / 2, MREMAP_MAYMOVE | MREMAP_FIXED, old_region);
+	if (data->region == MAP_FAILED) {
+		ksft_print_msg("mremap failed: %s\n", strerror(errno));
+		return FAIL_ON_CHECK;
+	}
+
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	/* Attempt to migrate the merged KSM page */
+	ret = try_to_move_page(data->region);
+	if (ret != 0) {
+		ksft_print_msg("migration of KSM page after mremap failed\n");
+		return FAIL_ON_CHECK;
+	}
+
+	/* Ensure ksmd scan two turns at least to update ksm counters */
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	if (ksm_get_pages_shared() != 1 ||
+	    ksm_get_pages_sharing() != nr_pages / 2 - 1)
+		return FAIL_ON_CHECK;
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
+	ASSERT_EQ(mremap_merge_and_migrate(data), 0);
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

