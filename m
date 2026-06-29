Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC40C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:44:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BA1C6B0095; Mon, 29 Jun 2026 05:44:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892246B0096; Mon, 29 Jun 2026 05:44:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A97C6B0098; Mon, 29 Jun 2026 05:44:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4B68C6B0095
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:44:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BBFC2167FD9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:44:47 +0000 (UTC)
X-FDA: 84932465814.25.BEA5DA1
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5525C40006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:44:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782726285;
	b=UNC0hGIaKpYu7O40oVwMXRrwTjXPM2OCnmbaR4Nju+R+Xdx9zRinliqq5rjY48z1DpflRI
	Xx50EzNL4yk8pzopiTTGpDR3i0kwbHUarxHBMfRzfQORprpoI9QxmIpBPqKHb8XtbiHVpK
	k9r4p8e2mhY2GNZUTLE7KeJKU12LXJ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782726285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UwtxwemDajAeai3mxpzcdDpaEeTQwwfbfS2Z36cZOqo=;
	b=mrtWSOrWOZTieT8sKA75lbvQNK/BUaccTPgq7KkkrVmvWGNBaDY2ED7sOb3xbTg4cfOnGX
	riHgSEKqpA2u9ErT7bnoLWsQUN1Ovi5wPAF5QRSjJ4Rx9SDBrJ6u7VUD5tlrAcVqeSFFWe
	5JjmPLiLVQDCNXFBPJdoMv+G43L8isI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf11.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gphFl1LjPz5B103;
	Mon, 29 Jun 2026 17:44:43 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 65T9iLAf076225;
	Mon, 29 Jun 2026 17:44:21 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 29 Jun 2026 17:44:24 +0800 (CST)
X-Zmail-TransId: 2afc6a423e78cf7-e9416
X-Mailer: Zmail v1.0
Message-ID: <20260629174424441L3NDvwfAQv74N4ZLs1PRA@zte.com.cn>
In-Reply-To: <20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn>
References: 20260629174111989hvHNpXBxy36GgPPhOoPi1@zte.com.cn
Date: Mon, 29 Jun 2026 17:44:24 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHYxMCAzLzNdIGtzbTogYWRkIG1yZW1hcCBzZWxmdGVzdHMgZm9yIGtzbV9ybWFwX3dhbGs=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65T9iLAf076225
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 29 Jun 2026 17:44:43 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A423E8B.000/4gphFl1LjPz5B103
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5525C40006
X-Stat-Signature: dm1p9wu7nrhohx3r5f3ammqukh9xxmx9
X-HE-Tag: 1782726285-345379
X-HE-Meta: U2FsdGVkX1/99OghFmczcMoCvOoUjgX2eU4jZlbqpfZKG7M+oQAUS4ncXDdxsM21LLeXgTYEyEKDNxucTX/dlk6wkyLZlejvWQ2GRFfAwbUUP/1h0YaoI592n+UkA4fNHbo87ahxzQdycx+53PjIoLcjjcksKcOCJHYTXDk8hEkCnMC/4kXwfzkvW+0e6dFnUZGUjNxojJHfEn4R65HMijrREo5Xoo3j70YEJvR+0vgeHou0GT3SV2hyWjU2cKScctSIfetWYO5++wM7IEKhXHof3LE0aGqqLvQ4wQCGVToKe11V792ZvdhryBnsrn0iYudfgjGKpy48KHMvYIgKIiXenl1C9L1FA5qkLOSQiFCcF8bFDCoJBca+nNut9+LuRTtzPdecSB3vAeTkA8jR8cP6pVkyB2EOUYEHHduxaXIhyvWJaMpGpfKRUgmjYHoawpJ92F91+81d+WBo7zaVx5gZeXDqcoS0F0mfD2m82H5TKwVWhVjs6Y1pOz06ApQsEos4pVt3YabzUBe/e0IDBSm+DQ4ybJ+QsulrAsSkSzp/8cIwYDY+KIjvGT+tdvpvsFL44MlLCuQHfA7NTy9ZnOCcT+U0iHGyXh3KHyqnkyDJtRJ6WbzZvKzkJZrgjIHNPCM+pRsSxPfBJ7HqOa5puqpv91Xlhe0ScHJ9KR3P/QJbT4JRazT3bRTa1WPa88cfQ5JgdTxSbRK3L0pyXN6rlhmGHiMuIufR136cL0xnWFGZayW+GI999AgW/NO5pYFC7MYMXTFUfyPW9PNM2PH1TJndA5+1tOL3+z7nCB9Mt+l4UrAyhmOzj2PqkvOG8hy6BvTVN6650JSwBcjsXeGKT3m3Ge9XN7+IYJcI9H7kcShI4ur8WNPFm+x7V21cKLgcD1yaxvuk3Iq5Wjhy3vhpLBq/KE6fiH6zheijr4MLKeop35oKHBTZIQCq9ukp/Dg6yziW+Op0Ln9HsM8BCJb
 u3H80Dat
 uuo31hDBeoAoiR1294RFGlJXamqXm1UCMtalTQo54vRgzhWAV7Xrq/ZHlFb4Ih2nIM0dO2HxLrWM5ghNM5ixxmaayFnBkBs5wpRCcf8iF5jR2U+ObyVI7aac50+REy7oglDPLc4Ak9A5vAyksuORc2mco7psNegPU4qWzXiheBcFqr2FVLpZ0QJoAxnBDKyMtAQoqu4vHvHVodN76s2fx4MYYvr911XHlfYgCESHkqEpW9ZvpW1+/LqjLjw1x4nsChX9FVm7UkcEKWQKa8GspgbgQrZzqpp7ViGcldbE77uCSWKVnvaMHhwefMw==
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
 tools/testing/selftests/mm/rmap.c | 107 ++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..ad731bdff4fa 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,111 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }

+/*
+ * Check if All PFNs of the region are the same to the input pfn.
+ *
+ * @pagemap_fd: file descriptor of /proc/pid/pagemap.
+ * @region: the start address of the associated region.
+ * @nr_pages: the number of pages that the region contains.
+ * @pfn: the referenced PFN.
+ */
+static bool merged_to_pfn(int pagemap_fd, void *region, int nr_pages,
+		unsigned long pfn)
+{
+	int i;
+
+	for (i = 0; i < nr_pages; i++)
+		if (pagemap_get_pfn(pagemap_fd, region + i * getpagesize()) != pfn)
+			return false;
+
+	return true;
+}
+
+static int mremap_merge_and_migrate(struct global_data *data)
+{
+	int ret, pagemap_fd;
+	void *old_region;
+	void *new_region;
+	int nr_pages = 32;
+	unsigned long old_pfn;
+
+	/* Allocate exactly pages for the test */
+	data->mapsize = nr_pages * getpagesize();
+	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (data->region == MAP_FAILED)
+		ksft_exit_fail_perror("mmap failed");
+	memset(data->region, 0x77, data->mapsize);
+
+	/*
+	 * Mremap the second half region to the first half location (FIXED).
+	 */
+	old_region = data->region;
+	new_region = mremap(old_region + data->mapsize / 2, data->mapsize / 2,
+			    data->mapsize / 2, MREMAP_MAYMOVE | MREMAP_FIXED,
+			    old_region);
+	if (new_region == MAP_FAILED) {
+		ksft_print_msg("mremap failed: %s\n", strerror(errno));
+		return FAIL_ON_CHECK;
+	}
+	data->region = new_region;
+	data->mapsize /= 2;
+
+	/* madvise MADV_MERGABLE and merge these pages */
+	madvise(data->region, data->mapsize, MADV_MERGEABLE);
+	if (ksm_start() < 0)
+		return FAIL_ON_WORK;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd == -1)
+		return FAIL_ON_CHECK;
+
+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
+	if (*data->expected_pfn == -1ul)
+		return FAIL_ON_CHECK;
+	old_pfn = *data->expected_pfn;
+
+	/* Before migrating, check if All pages's PFN are the same */
+	if (!merged_to_pfn(pagemap_fd, data->region, nr_pages / 2,
+		 *data->expected_pfn)) {
+		ksft_print_msg("After KSM merging, PFNs are not the same\n");
+		return FAIL_ON_CHECK;
+	}
+
+	/* Attempt to migrate the merged KSM page */
+	ret = try_to_move_page(data->region);
+	if (ret) {
+		ksft_print_msg("migration of KSM page after mremap failed\n");
+		return FAIL_ON_CHECK;
+	}
+
+	/* After migrating, check if all PFN aren't the old */
+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
+	if (*data->expected_pfn == -1ul || *data->expected_pfn == old_pfn)
+		return FAIL_ON_CHECK;
+
+	if (*data->expected_pfn == old_pfn ||
+		!merged_to_pfn(pagemap_fd, data->region, nr_pages / 2,
+		*data->expected_pfn)) {
+		ksft_print_msg("Bug migration: still old PFN or PFNs are not expected\n");
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
+
+	/* Skip if KSM is not available */
+	if (ksm_stop() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/run\" failed");
+	if (ksm_get_full_scans() < 0)
+		SKIP(return, "accessing \"/sys/kernel/mm/ksm/full_scan\" failed");
+
+	ASSERT_EQ(mremap_merge_and_migrate(data), 0);
+}
+
 TEST_HARNESS_MAIN
-- 
2.25.1

