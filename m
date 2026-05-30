Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 85AE9CD6E4A
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 09:10:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0416B0005; Sat, 30 May 2026 05:10:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7486B008A; Sat, 30 May 2026 05:10:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDE186B0092; Sat, 30 May 2026 05:10:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CD4AF6B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:10:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9283DC0303
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:10:32 +0000 (UTC)
X-FDA: 84823515504.23.672700C
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2D317A0006
	for <linux-mm@kvack.org>; Sat, 30 May 2026 09:10:30 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780132230; a=rsa-sha256;
	cv=none;
	b=0p0jekJFKSNY/bWs+AWDxHlshwWNszsh6wSRlu7QvmUjf3tcLp5VH40/nQZioxFYuo4QxA
	RjK81NNhozZC7VMH5QvXzcpfDEZaLomyhgzccWROIyPNtH/npry3KzrofQwDBhydWcOdpS
	5CE3x+zA/byIxNVkBSz5nZe+ytVEPkE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780132230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=94fZOutZRHVll0k9gh0U4uHwTaeLJtJDgaIsJ9plFjA=;
	b=QszYZ823449rXjtk96LygTK5QbbDf+f6eT4DXbfYZqOaoegTUrtRGsmz8416B8Su9dUBB+
	6OfrJXgvogqIbsx5i81G/GKwBR9CmTtwcHlrnzpWRVWs7sqX/Gw1F7/loqSBRhlax9sMsb
	OlEFWw85SClaJkxl83CvBq31tUwBsSo=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gSDw00J9Xz52RpX;
	Sat, 30 May 2026 17:10:24 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl2.zte.com.cn with SMTP id 64U9AJOT052872;
	Sat, 30 May 2026 17:10:19 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Sat, 30 May 2026 17:10:21 +0800 (CST)
X-Zmail-TransId: 2af96a1aa97d777-20e7d
X-Mailer: Zmail v1.0
Message-ID: <20260530171021329670dwn6uVqrmEL6L1A8ib@zte.com.cn>
In-Reply-To: <20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn>
References: 20260530165907829ZSDzDdMc110MnOflRzf9P@zte.com.cn
Date: Sat, 30 May 2026 17:10:21 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>, <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY3IDYvNl0ga3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 64U9AJOT052872
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Sat, 30 May 2026 17:10:24 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A1AA980.000/4gSDw00J9Xz52RpX
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2D317A0006
X-Stat-Signature: o6zrmdut9oxbcg3q6a5on5n5jrp5k8fm
X-HE-Tag: 1780132230-981889
X-HE-Meta: U2FsdGVkX19DtPcOvs/MQNqJxaucThRhxYDmE7P77WY3Tbou2MKTKwpQtNvLpodUsrNA0LBjLJ680OZgqLzYPd85bmg6RdjNg8itBpdNQS5h5KlLS/dHT/gjGdEYaj72V5UXXCEVBk/oSqtI8ByWiZxukBWq1crbDqhQLrIHe1BE2OSMAFniPRlQx4gTJf2NqisNEjQ+wwYuM/C53uHXCGrq+jQbSDHP5PMrybc8c/vTCHdS0eGtJ8JQTz1OTVrfMm5aNRJjbpa9ezBEpeB98R3jjKfr6n4seMBolz8GEmKJLLqvsS4W2+6GpEgH5OvggU13D/jktHLRy90v620VBh8utOvMi2kx+i7+nnwHB0idK/KGXIV1JFZubdfDvl1y6O1PAP1TlWA+4T6+N2TVqne8kh6YP4OMC22U/5C07vWP0/6gX2Smrmabo4uJKmV4RAR0EKSGe4mTeMyP366S0wKVzIqr6k0sXIrlXDThAoptpYxKSiMsNj8zY0JUF9Hk8D3BqGy3XdQE1hhI5y5z5uYUhNWajIwy6z8DKU+NZMMiQq4dOAl8jGyXnIeD6ZmjUwWBgd6Umun2jfJZVy/Pf0/SEDzBa+wId1ogxh4SoJ7j+W//TzlvDhxuAJTsAeHAWcxKZjO2KpgLKK7pbdI1ITlaE3/Otg2dpYevIo5LlAcUx5i8HBB+OQ2gMG6dzRWPTd3IJBHXJ5scP3F0u08ygZWbRLVBnT16GZreR+cwrCwJ+YSKsjpgXadj/rwe8vGSZY+XwPJJjnTJ5+FxNmvmRY5jKSWlmmOu2FlnenEjmgFxKqSbRFnqXelH/dA1Mnv96v18FmyA+eFDneQez2N0WmsL6fgIAkAILPSbl8OjwzDmhGkGHlCywdnk2D+uO3/mtf+cmucbKeEcFWrzmHHgElN9qc2EQD3YHDfRPH9ZF+IfRIuKkDUO2J1u8TTaoOLegEnur9Qanp7htVQzgEG
 c64qqmC4
 HTJTxtjmTJG4MSREt5JMOYYJpi333LUrN9B82s94zJD89/9aRELT9yKjFt1sbTqdnfbxxDq5f9kizDAva0OH0R7jC3mfMUd283wLjrSHOWJDPoEfOBcjHs6X5dVd7maQd53v/Qh4CHpMibuQePZ+tSFRp4XYSbyiuknUzRhucxc3/meMF6yVZ/Z33rQrQoWtG0PpWU34yrNwyb/8oEYahsudg5HDWTjlfjY/UYf6KLWC3+1SgHdDsKMIYBYSUsS/Df4GUdzZxpvapNNPUJqNNZw3J+znaCDGgNlAoeg4mZo/hnWwqOE2g27cE0w==
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
migrating, which is specifically to test an optimization which is
introduced by this patch ("ksm: Optimize rmap_walk_ksm by passing a
suitable address pgoff").

This test can reproduce the issue that Hugh points out at
https://lore.kernel.org/all/02e1b8df-d568-8cbb-b8f6-46d5476d9d75@google.com/

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/testing/selftests/mm/rmap.c    | 97 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c | 47 ++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 +
 3 files changed, 146 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..e548d00762b3 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,101 @@ TEST_F(migrate, ksm)
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
+	void *new_region;
+	int nr_pages = 32;
+	long base_shared, base_sharing;
+	long shared, sharing;
+
+	/* Take baseline before creating our pages */
+	base_shared = ksm_get_pages_shared();
+	base_sharing = ksm_get_pages_sharing();
+	if (base_shared < 0 || base_sharing < 0)
+		return FAIL_ON_CHECK;
+
+	prepare_pages(data, nr_pages);
+
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	old_region = data->region;
+	/*
+	 * Mremap the second half region to the first half location (FIXED).
+	 */
+	new_region = mremap(old_region + data->mapsize / 2, data->mapsize / 2,
+			    data->mapsize / 2, MREMAP_MAYMOVE | MREMAP_FIXED,
+			    old_region);
+	if (new_region == MAP_FAILED) {
+		ksft_print_msg("mremap failed: %s\n", strerror(errno));
+		return FAIL_ON_CHECK;
+	}
+	data->region = new_region;
+	data->mapsize /= 2;	/* mapping is now half of original */
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
+	shared = ksm_get_pages_shared();
+	sharing = ksm_get_pages_sharing();
+	if (shared < 0 || sharing < 0)
+		return FAIL_ON_CHECK;
+
+	if (shared - base_shared != 1 ||
+	    sharing - base_sharing != nr_pages / 2 - 1) {
+		ksft_print_msg("Unexpected KSM counters: shared delta=%ld, sharing delta=%ld\n",
+			       shared - base_shared, sharing - base_sharing);
+		return FAIL_ON_CHECK;
+	}
+
+	return 0;
+}
+
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
index db94564f4431..bfa88937485e 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -648,6 +648,53 @@ long ksm_get_self_merging_pages(void)
 	return strtol(buf, NULL, 10);
 }

+long ksm_get_pages_shared(void)
+{
+	int fd;
+	char buf[10];
+	ssize_t ret;
+	int saved_errno;
+
+	fd = open("/sys/kernel/mm/ksm/pages_shared", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = pread(fd, buf, sizeof(buf) - 1, 0);
+	saved_errno = errno;
+	close(fd);
+	if (ret <= 0) {
+		if (ret == 0)
+			return -ENODATA;	/* unexpected EOF */
+		return -saved_errno;
+	}
+	buf[ret] = 0;
+	return strtol(buf, NULL, 10);
+}
+
+long ksm_get_pages_sharing(void)
+{
+	int fd;
+	char buf[10];
+	ssize_t ret;
+	int saved_errno;
+
+	fd = open("/sys/kernel/mm/ksm/pages_sharing", O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	ret = pread(fd, buf, sizeof(buf) - 1, 0);
+	saved_errno = errno;
+	close(fd);
+	if (ret <= 0) {
+		if (ret == 0)
+			return -ENODATA;
+		return -saved_errno;
+	}
+	buf[ret] = 0;
+	return strtol(buf, NULL, 10);
+}
+
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

