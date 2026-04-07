Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E576FB519C
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08496B0089; Tue,  7 Apr 2026 02:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF076B008A; Tue,  7 Apr 2026 02:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F51C6B008C; Tue,  7 Apr 2026 02:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC876B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:08:19 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1BB9816069E
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:08:19 +0000 (UTC)
X-FDA: 84630729918.15.598B875
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id D71D416000B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:08:15 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775542097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Ldgc5ZUxvTyJEIsbPisBl6xI+nZx/J37uWnuInfg5O0=;
	b=5rD8xIKO+xxIPfZWO3yc1hXMlLkzA1uXtZ/6yN2eVv/2Qp8eB9gQqFcYEa9BD7w5IYMDuT
	Ad6xuXXD/uynstX8G7UmDRY/McqXcS7wTNGTZw9X3hJqs2KhlQFjP3tAYQGObuaCEW4hjY
	yO3y4uLSNj+Tn0wXoA7qTkgEYIZnO60=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775542097; a=rsa-sha256;
	cv=none;
	b=5Sx5vWErnk1LMB6a+tIp8qMwrHa5B6eF1WgJX/tLIFPBP3xnkD8Wq39k06MGVxttxEHgxB
	jM/uoz7qxAaXSige0Cbok66vd+vejufxDM8kDnBf0dNa6LZeC1vTjmQP62AcR/1WxxVP5c
	Zk3ipBk5YH8rMdAOrsXfjenA/Z3Anps=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fqbNC54Qnz5B0v2;
	Tue, 07 Apr 2026 14:08:11 +0800 (CST)
Received: from xaxapp02.zte.com.cn ([10.88.97.241])
	by mse-fl1.zte.com.cn with SMTP id 637683ZL016315;
	Tue, 7 Apr 2026 14:08:04 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 7 Apr 2026 14:08:05 +0800 (CST)
X-Zmail-TransId: 2af969d49f45bde-1244c
X-Mailer: Zmail v1.0
Message-ID: <20260407140805858ViqJKFhfmYSfq0FynsaEY@zte.com.cn>
Date: Tue, 7 Apr 2026 14:08:05 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <hughd@google.com>, <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <michel@lespinasse.org>, <ljs@kernel.org>, <chengming.zhou@linux.dev>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?a3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 637683ZL016315
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Tue, 07 Apr 2026 14:08:12 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D49F4B.000/4fqbNC54Qnz5B0v2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D71D416000B
X-Stat-Signature: bari7i6xktoj16m49cwnbkkyi4m571cw
X-Rspam-User: 
X-HE-Tag: 1775542095-282257
X-HE-Meta: U2FsdGVkX18Y2KibSXMGgu1P2osOnPONircIGP47vfMFi4iD106feo+Kk9ApYziMbvJf/9dXKecM6eU2SpxSxPirxkSEinKZz7mKX76D3eycJJtBtOZ/10+vYjneLyvuOBYneVxRO6MZVWf8GElEwVJ176S3b2Hsdnm70NBC6IACAyCCszfbG9VT+neD9yapAXizwdAQ5VRX5PHVNQ3dow2gioBVDP47JfcDwg29XTFI4CXP3tyRg5Lan60yAx4vZJg7+SGCESM0UMOo4ckwEMzNHu0I1VCYc96PeMcieSzchE6CXl5q9DgLu+Rzp9pbEGz5lR2kK7Rynk+2xFjl3vdksMDIUr59QJO4KhTuyZkR2ZzIklyIBVvsa3YtQTPIYkXYogKMRd8DOe4oADLhYgSTEqaWqp+nHMkIHgQJ7pYT12fhwD2srOjaPT7c2xRilkj0fbGasuZHeu33SoYeD2yD9BmQmwgG3hDb9RLU1iqTR+ib2W+HAiBIbjYTMyouzrfYu3BEjd2FGr2i6Yw5Ex9mbv9sk737L63sBtnm66Tzq2tALxtyrK2aX6huVhGiiC25/GSHeunpWNUZ6xntz2U28EOzZXrt/QVE5DTBy/4TgUQ4oog+lpl+GFHlWMzQ4K82lT6DQwSBu0xzKynYMnNPUNosF0Jr3K/PIfvz8+36Nxb2RxD7/mRza7LAq3mHnqQUWSfHFk2ovjYQszTM9Cvw5HXJKRTuO+L3eFlSepDW/ykc4fwo1lD9c6+PwsoiQQ60JEk3k1ZAi3XR9Fn5fSNIBjNHAI6gxqfeBqI4ahfwaCUheWasuK6pJVBVhGKA5UHT968EsqMChgEvBHF0By3psXPjXzRZJ8oodQWYtt6N2KgpJYdJysO4G7rBajcxotbnsTHpxcpD8gks3etv6zvXDa/5q0L74zQWFimoXiT0T5fYa0d7BLFD+/saq7lMW0b7FKg/gblBZGi7tsO
 5z4qMgOr
 JCox6g+DOt1zoc3f2YXSZthefb6R8yF2m0SSZ1g6EPzye3S0vg42VhsTEXBRQ8Nzt4joju+D5NoY/+pz22c/bK66kZCbbkAJ5jQ0SJkDLG+z+n4smKEdqPMkI9rS0XaZjYinde/M2QaVQ/SiLNc8u8i4zaLxSaLjEGLJ8FPF74ETF6UgY6ku0NlyfbWvelWltYGEyLLmo3pmwS1erhbaus0qCdf1fPBXQVyZno/tkl+yfo8uRrS9DGxU9hR7PPMpJSaGmonM4dMGgpvFBleBZI1M6mskSUocKWv+M
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
the senario of mremapped VMAs.

Before migrating, we add the calling of mremap() to address mapped with KSM
pages, which is specailly to test a optimization which is introduced by this
patch ("ksm: Optimize rmap_walk_ksm by passing a suitable address range")
https://lore.kernel.org/all/20260212193045556CbzCX8p9gDu73tQ2nvHEI@zte.com.cn/

Result:
TAP version 13
1..5
ok 1 migrate.anon
ok 2 migrate.shm
ok 3 migrate.file # SKIP Failed in worker
ok 4 migrate.ksm
ok 5 migrate.ksm_and_mremap

Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 tools/testing/selftests/mm/rmap.c    | 69 ++++++++++++++++++++++++++++
 tools/testing/selftests/mm/vm_util.c | 38 +++++++++++++++
 tools/testing/selftests/mm/vm_util.h |  2 +
 3 files changed, 109 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..65470def2bf1 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,73 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }

+/* To test if ksm page can be migrated when it's mremapped */
+int merge_mremap_and_migrate(struct global_data *data)
+{
+	int ret = 0;
+	/* Allocate range and set the same data */
+	data->mapsize = 3*getpagesize();
+	data->region = mmap(NULL, data->mapsize, PROT_READ|PROT_WRITE,
+			   MAP_PRIVATE|MAP_ANON, -1, 0);
+	if (data->region == MAP_FAILED)
+		ksft_exit_fail_perror("mmap failed");
+
+	memset(data->region, 0x77, data->mapsize);
+
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	/* 1  2 expected */
+	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (2 expected)\n",
+		ksm_get_pages_shared(), ksm_get_pages_sharing());
+
+	/*
+	 * Mremap the second pagesize address range into the third pagesize
+	 * address.
+	 */
+	data->region = mremap(data->region + getpagesize(), getpagesize(), getpagesize(),
+			 MREMAP_MAYMOVE|MREMAP_FIXED, data->region + 2*getpagesize());
+
+	if (data->region == MAP_FAILED)
+		return FAIL_ON_CHECK;
+
+	/* Check if we can migrate this region successfully */
+	ret = try_to_move_page(data->region);
+	if (ret != 0)
+		return ret;
+
+	/* Wait ksm scan two turns at least */
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	/* 1  1 expected */
+	ksft_print_msg("Shared: %ld (1 expected) Sharing: %ld (1 expected)\n",
+		ksm_get_pages_shared(), ksm_get_pages_sharing());
+
+	return 0;
+}
+
+TEST_F(migrate, ksm_and_mremap)
+{
+	int ret;
+	struct global_data *data = &self->data;
+
+	/* prepare KSM interface setting */
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\") failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\") failed");
+
+	ret = prctl(PR_SET_MEMORY_MERGE, 1, 0, 0, 0);
+	if (ret < 0 && errno == EINVAL)
+		SKIP(return, "PR_SET_MEMORY_MERGE not supported");
+	else if (ret)
+		ksft_exit_fail_perror("PR_SET_MEMORY_MERGE=1 failed");
+
+	/* Start to merge same pages and mremap one of the three page area,
+	 * and test if ksm page can be migrated when it's mremapped */
+	ASSERT_EQ(merge_mremap_and_migrate(data), 0);
+}
+
+
 TEST_HARNESS_MAIN
diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 9428f4d7bf55..47402b771ef8 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -646,6 +646,44 @@ long ksm_get_self_merging_pages(void)
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
index e9c4e24769c1..b0dd190f83e4 100644
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

