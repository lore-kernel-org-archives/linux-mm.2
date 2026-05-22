Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D31BCD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 03:02:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A47186B0093; Thu, 21 May 2026 23:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F71A6B0096; Thu, 21 May 2026 23:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9341D6B0098; Thu, 21 May 2026 23:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 81F7A6B0093
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:02:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3845DA098E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:02:42 +0000 (UTC)
X-FDA: 84793558164.22.5127ACF
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf12.hostedemail.com (Postfix) with ESMTP id 750FE40002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 03:02:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779418959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cDqKiZsbhGc0iulp05C+EbmF8iZnbs2KOC3O4DpkYto=;
	b=1xs8aGzf5yZVJapFiHFIIiJcuSZXfiSjlAEgg7Ld0XcN1D6orn4Dg6FS4reV8ExMApr96B
	r3J6QhXCtXkBZW1Qq6JCKa8NlL+CxWQo7kn9L8Q//ril3mT2IrHGtBj3Tpn8KgtAsl6+m2
	P2tSS53AKFX5wzXB/htfRSshT3HDb2Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf12.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779418959; a=rsa-sha256;
	cv=none;
	b=dxdgwa1gf6+eiW48KNZP9lK6hs8g5WQRvDP7gabJw+aXU2eb+u2VZjZ2+w4pOnJ2w5ffR8
	nHxKm++W/OiAxvn2GXOSY3vY/M+tDgEbWPpXVO+RWEZEmub8BREfnMeIbh5C/n7Gztxr8u
	NNEs+x+MLq6B9ov0JBB/B/5L9E3At4I=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gM97G26m8z4xNtZ;
	Fri, 22 May 2026 11:02:34 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 64M32NX7039363;
	Fri, 22 May 2026 11:02:24 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 22 May 2026 11:02:25 +0800 (CST)
X-Zmail-TransId: 2afa6a0fc741c42-3818d
X-Mailer: Zmail v1.0
Message-ID: <202605221102251615sSZpzKPatH1ieTk7pInS@zte.com.cn>
In-Reply-To: <20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn>
References: 20260522105234715fKI7KSsjC5XpEVMwoV6rI@zte.com.cn
Date: Fri, 22 May 2026 11:02:25 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <xu.xin16@zte.com.cn>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <corbet@lwn.net>
Subject: =?UTF-8?B?W1BBVENIIHY2IDYvNl0ga3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 64M32NX7039363
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Fri, 22 May 2026 11:02:34 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A0FC74A.000/4gM97G26m8z4xNtZ
X-Stat-Signature: twhjqgsudaxushrzr3wzdzygfkrutugr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 750FE40002
X-Rspam-User: 
X-HE-Tag: 1779418958-89509
X-HE-Meta: U2FsdGVkX19lAV2XQrS7Kg3zkEPl3bBvEqf/Rp4YXn4QkiSkkN4VNuvAWzk/E6Z+PCGJGma0k/GUs1agDpsb8u9ErRszNcoE2OZIlFcZx9cQ7UU9swyMTYUoCE6UYr880Jr4EGGzu61/noAj7cqyZGd3mc+3Z1s3btU7Iue4UID7Axtg+bTN6Y9lpLODEggCu6b6VlLPv5TH6J+o48gVVIC2V0bmFnU7YVw+RoA2QxKis485beDgKK6bV5z0wyG/jyPhFfiXtBpN1Tvp/97NTmFDfq6tehJOam7TlyPG9Fdj/MoxcLoa7cpNuK/Q+B67yt5Gb8l1wRq1+EM8kpf8lQVCLQ0WWpIwNDnAPZAHxNd3A9LRfffgq6D4rHlD/A8y5sX16TsnTW5/2F+gA5U0nyKAkpzuwoB4PDNmn9f2gvZfEY5OYbeBa+qcrH+fMU0zBwx6c9qNKdkzPg1qyn4+NZvt5e0aAxa5KG9t6gtZF0trkl0ttytTuce/FEL+I80F9ex6XKiz++4VoYfMUCEP+Tt3CNmfHUBtGCHYjgJYA8eyvdFrCm5tic9zzI2Co+TaFi4L+SiZeSNC2miOk0maodk7YvM93xR0sxLC0XMUGohG5vlHI6OY8YBtt0lSmj04G9l690d6yQS0HFoQMdfw3JdJEMtqcW+Ad2IhQ94FSovk3K39CYonUh/klmN5N5URXeLCt2cztd925mXyYbwCanSr2ulWNZvlgfMznzo8eBnQxqjnqNP9rYBWmTX+ChnJ9j8iDeqmScVAxF1NmyUiLLZbxEuFIDS8W5QFKE7gVHp1XYrx9kllG2Pnpyr48QOAsVawe6dkjsY0dTZChzzBROG4z7Rrb0ACoZL3EZp3XPc6hG+URU9zaO0FwNoa3uswlPn6DoBf2TsWNKkeZn7xgSInaNxvMDdmvGhb82dnAOTr9+vv3tD3DYuts28KkiKt9ea5HBPbn/clYNVCguQ
 RDzP7tu8
 yifZ8pvLTgjn3ypPZc2dAclcQa4qy3ahGFBTaWMPHbNqayv17L+pAsDDWTZ/dnieLc+KbuNr3Dytu6Z/NZ15LX1Knemdb9dsaWN+BtpwZV47EsoEDh6/T5wxuyQrMI2E5xnOpXxZXaq77BQrSfGptrOPwVDqISDC4MVBqUZrPadrP5ENWOFKHC0eJA+qNO4VI84bKdFBqf/tmZWhm4nQKPJ+OcZEDo1YpJFOZbWvYeUtt1L0LLvFplShh4h0hA7JxMWUiMvK8jyi1JkiS+1mp2HSrcP3uY6uMdOTIz/VMxHpINy81kafghPwVHA==
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

