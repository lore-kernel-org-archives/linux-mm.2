Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B14CCD8CAE
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 04:47:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D12A6B0088; Tue,  9 Jun 2026 00:47:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8819F6B008A; Tue,  9 Jun 2026 00:47:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7705A6B008C; Tue,  9 Jun 2026 00:47:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 670336B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 00:47:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0CABB1C1E6F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:47:58 +0000 (UTC)
X-FDA: 84859141836.11.95C226B
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf22.hostedemail.com (Postfix) with ESMTP id 942E7C0004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:47:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780980474;
	b=SKVmXpqcpkQT8DPRm1LlThmqR5ekTDPiHzNngMszrlvielsqLI6m805eVJKIvWl0+NduTv
	QtrBaRTwVmMQZt6LTPBBP3A7ft5qi9wIy1E+oEJe2TlczLM2TqfJUwApyePIE6rxZ6dIUd
	gwLnQPdUvKG/Y6G2v2rSfZf+geKnoyg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780980474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mcA4z4sPIERWVCFJBUaNxZQI4z6SpIaCNucnNxAZ8Tk=;
	b=2V2vDkpXSpSxleailhtWNQz9VBCRz+KilIHTr+57OIoOrhX874aqUjZKxBM6imLseMoKqA
	vrGaZQ+IhA3ZbP5sX9HJS1ynRXFE5PEnVKanDJbpPyKlmUA1NZeMG7n7eNncUNQsKiN5yi
	2lFnjXXkab2Ra0yaN24z5847w8mLUY0=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gZGcL2Bt2z52SGf;
	Tue, 09 Jun 2026 12:47:46 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 6594liEV037684;
	Tue, 9 Jun 2026 12:47:44 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Tue, 9 Jun 2026 12:47:46 +0800 (CST)
X-Zmail-TransId: 2afa6a279af26d4-1351d
X-Mailer: Zmail v1.0
Message-ID: <20260609124746153K8Y8tYI_4pNVKogGMdglR@zte.com.cn>
In-Reply-To: <20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn>
References: 20260609123931349fw0hnPPf7UBWQT0P7Ej2L@zte.com.cn
Date: Tue, 9 Jun 2026 12:47:46 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <ljs@kernel.org>
Subject: =?UTF-8?B?W1BBVENIIHY4IDMvM10ga3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6594liEV037684
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Tue, 09 Jun 2026 12:47:46 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A279AF2.000/4gZGcL2Bt2z52SGf
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 942E7C0004
X-Rspam-User: 
X-Stat-Signature: bfywytsafo6ms83sdsoyqhqpp7ja4swn
X-HE-Tag: 1780980474-507114
X-HE-Meta: U2FsdGVkX19IgENkF6+Grkof/tJfxEz3bMeLm4mvFHdNsY3HA5v8I4InCNy2ngmgYlG+DE4Yb/h7Cy1T8GaWB/XoCxh8vovp8tSZGs2b6X/djCc59zoarFlZ42eS0XrUo65E4xgXf2rKhrTmee6IVc50p5TbxQFma6NDG3U94sqiZTXkYXEvzDbOXQ/W3KsPDqjTIz6lSrATspnoboHCfou7wO7RHVhBOpvwrVcjSAxGmbbJh4QTGFtWmsmkq3LDHJCTWU876XuDEYfLqhYLAeIwma+i6C7bAqlSqV6vOlXDONP4iIPbu/0lW/Joabs7IMB4wGbH86ZKRKxvRynYqqsJB7258UYsOguW+qz3JcJc3A+pNKt8WjzKb22vD/MgHIoucnXMkQ9jM3CWr41EpZwI0TFGBxjx/4c5qjEkVm9qiFcOKVdJauGY9FvwK3QfbU+y2So28bnhxTTHTA//tGwiPZ4uh5HGrctTeFHjwA5xK+SnoHj5fI1S0Zc59HHw3a6IniSUZYCFXvkEmUHLy/x1X6iwx2KBYsxWKVM181vPHUXWOO5kx6RY/xUSgp781sI88cgp/0NCv5raXjWf70HASbFkkwQbMMhSzrr5ZdNKy8LK9bmoMAeblnvNyxbit9T2Sn1YG0htDbs358q9wFiEVurnpKCjP4x5cJ3tpygQZBn3oxWGW3QbdCyBlx15w2X18s3cMdOVKPihAVCznSk5Q4m58Dbzy/K3lA6CRfANZZfQcWHZEV1AMxCmeGsUnfZIPyGxlWjFPszgdVk+dTkubNS4ahElSCiu/QC6ZnsL9rwU4UFnFmX9B8Y+pi5qpkA3AtQD0ZCjm4PAyNFzfjjEtjSWL9PxlVZWTDykAhSIEc8eOlHaT5lAbq3jh+n7G647Abt3mXZSJInfwiAKANVUcj7eqypxM+6SiJctPIUytWPHcZmgnqsPc+KLCwQOPmZp//zjosSZqp7SqIL
 1p2cvYCy
 +U1rZUkPst3fEzTufUgrpKcrUP/CVyuYjA97DWVzLsmHf01ONdA7aleDKGFEM+p/36wCNHGAd7DfojqQIes3mx8DclbvQoDw0kehtg7TTcG1FJArOYtm6gWoM6Ch3Q8HZXLgjMwHye6HW+KSxQ4Ep6EWmlWz8l/R2dxdDPWKJ7NO3vKS7zHiM+7b49wZh9esH3ik1FWa12W6PZ5QQWIz6ynoPM2omRsKxh3/TW6fn07k6llaiXTaawzcIJSw5q5GrlqWptQs/b+hbOIU82PyjXdq2XDE8nLVdT5FEMQpKiOpZmjbLkWLXoXVkgw==
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
 tools/testing/selftests/mm/rmap.c | 86 +++++++++++++++++++++++++++++++
 1 file changed, 86 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..1cdc4beb48c2 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,90 @@ TEST_F(migrate, ksm)
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
+	long merging_pages;
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
+	merging_pages = ksm_get_self_merging_pages();
+	printf("merging_pages:%ld\n", merging_pages);
+	if (merging_pages != nr_pages / 2) {
+		ksft_print_msg("Unexpected KSM counters: ksm_merging_pages=%ld,expected=%d\n",
+			       merging_pages, nr_pages / 2);
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
-- 
2.25.1

