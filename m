Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07ECCCD98CC
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 13:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9316B009D; Thu, 11 Jun 2026 09:22:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1156B009E; Thu, 11 Jun 2026 09:22:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FEDB6B009F; Thu, 11 Jun 2026 09:22:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 310CD6B009D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 09:22:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E29431C35EE
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:22:48 +0000 (UTC)
X-FDA: 84867696816.25.89900C6
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf26.hostedemail.com (Postfix) with ESMTP id 69C6A140007
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:22:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781184166;
	b=0F52yseR2pWR1gpIo7+OJxGDiLd8WfUNKhKfp1AJQBRpiiHdeKyBnVrFGH9TuZJCLcvCoU
	wjCnh3ix9URpjrxFy6nuLc4Qp42IqCF9YbY+ZoxgoXNLidHBotdNtKUbeJWmFgVhDigVjs
	dxYnLQx/iLxlAQ4mMCPFZIkQWb/3Dek=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf26.hostedemail.com: domain of xu.xin16@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781184166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KmY6JJ9shmdNsxLIXtxp1sgq1LMJvFzLbcrV86myDn4=;
	b=B72LGIi9dr/G2pgm8v29Ze3Xdrik311dhj0wLlX2hztp2cjWI6vTUy+/bGyLzXIcsyjt06
	k5BHI0zuKbrSIc8iotUZA3ifyVfnN8Yjjs8ZxVPdrXOrXuQwzVRaYmH4mooKy8idGe/n/j
	tKFSWyrcJT5Zj5QF4vacAa2t4f0XFSs=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4gbjxS1wR1z4x69t;
	Thu, 11 Jun 2026 21:22:36 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 65BDMWrc002095;
	Thu, 11 Jun 2026 21:22:32 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Thu, 11 Jun 2026 21:22:35 +0800 (CST)
X-Zmail-TransId: 2afc6a2ab69b5c4-823ad
X-Mailer: Zmail v1.0
Message-ID: <202606112122356956c-u4WhFlRWs4-OJ4TAsu@zte.com.cn>
In-Reply-To: <20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn>
References: 20260611211311025VA1q1gTA-X5NMF0aZjnvh@zte.com.cn
Date: Thu, 11 Jun 2026 21:22:35 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <akpm@linux-foundation.org>
Cc: <david@kernel.org>, <chengming.zhou@linux.dev>, <hughd@google.com>,
        <wang.yaxin@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <ljs@kernel.org>,
        <xu.xin16@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY5IDMvM10ga3NtOiBhZGQgbXJlbWFwIHNlbGZ0ZXN0cyBmb3Iga3NtX3JtYXBfd2Fsaw==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 65BDMWrc002095
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Thu, 11 Jun 2026 21:22:36 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A2AB69C.000/4gbjxS1wR1z4x69t
X-Rspamd-Queue-Id: 69C6A140007
X-Stat-Signature: 6otut3u8bprbqtg3hyox5g4e7j1xga7u
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781184165-86811
X-HE-Meta: U2FsdGVkX18viig3qJ/9EP65zAiaeVi3XBsqepTdO0LGYmRfGPGJ+S1GSCLJzPyixoPaBmDuS62gILICgziV2o7IB8siuMUovGcmQWG2hIbaV2nyfuMjA6VqqwWR8kuWGPADJP3EIw+TqwlcgmdWMZxQ095zVvm7vuEZb2ufjGX1Z+oTHCHyxDbmxpw2TLiupo31R/SITIHnwxMOUAZLYrQFNn3KcHBVYMwyl2GUmK1XOpyLCDnqeOugme1A5xVcRn4nGasluucqajvqQpmW0eAXRGBK4hhRT4iXCUxTL3oCScR+4jHh5nDW0bj3MOJQph/3QdWIC1onjbbRUfGssx9RnQwKXhPTKI3StnUruIBAp/ADFkm3yS5ejH8lBLd8bIIbDqP3YaOtS8FIDWhfd1BZzmiuiewViqRlQsYDDdnKkQPMuQHj0vuqRocKvUiDBxJKLiZ/49J+1CsUbDRxAarboSTf6ugsdC/RZm6fB/foz9GaOe8YPsbsCVrceHuqD9hq5n/o26m97vnadg7raNA36OfidWz3ZGzjAIH7lF2JnODGIT5O1Rs10twZfenEqmaYnBhYe3IuZ2BCxqoU/FqzRv+zAOc8LaQOTtBzKIOFE1V0WmXiNONny7ez1vBDj5NLWmQ9UQ+rf6Zo2ZZ68NUoNTxw2fvRCZtgfibzoaJrY9WhF3CestpsCXBwNDnWTW7JMTRoKyvD1joPTHmx77AKcKDiA1eVzBHczi6RZOwj6BI5ovpq+BqfoIxm7usPPQ5Y4ZFg2+E+JBouTySz1zDXM7sf98HDEwd+WNH4cqy64yFXOwAVa+GDlCYXa19br6lsLBO692SlUEHI8VwgCkbrhA79XunrYmNBhB+6ALvUX3Q7+/U/XFdB5dgV9RR8W0Ff2cdpRvKY7epTLFj8NCLEd0FzChvj2DCLLzBhwqKBuAGJSWMsO8iDABVtqb/HqbKcUZFLqwjmJg8OwwD
 JxlEFETd
 xbl1rZRrVaC7pXGYTkII4YIijfiZjbRkUaUkql4XvWhkuljDkzn6PzhvG8FyhImiWPj87Kj6bZ8PL+RRjR7e6HdPss0cpLRfZV1fFAoWi0qJ1l/NZNnMIQ7S0ZM4KFLa+wnfuMiHJx7pI2cOkmzaZz/zWEbTodmYxnH6k4QI315XptaYTzqkh/uTvKI/bCGSuKrCCqDyeHeB1DgSzPF5MLitjKg9aaGHxmrwJ1cLkC8+ShsPmNG3kP0gWY6FXRl1I2dsK1zLLraDUyJPWZ9u1aORQZgZnWx9cwQzhhylEFaFdjDPXOKlxkgHDKA==
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
 tools/testing/selftests/mm/rmap.c | 90 +++++++++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/tools/testing/selftests/mm/rmap.c b/tools/testing/selftests/mm/rmap.c
index 53f2058b0ef2..375bcb1fe1ab 100644
--- a/tools/testing/selftests/mm/rmap.c
+++ b/tools/testing/selftests/mm/rmap.c
@@ -430,4 +430,94 @@ TEST_F(migrate, ksm)
 	propagate_children(_metadata, data);
 }

+static int mremap_merge_and_migrate(struct global_data *data)
+{
+	int ret, i, pagemap_fd;
+	void *old_region;
+	void *new_region;
+	int nr_pages = 32;
+	int page_size = getpagesize();
+	unsigned long old_pfn;
+
+	/* Allocate exactly pages for the test */
+	data->mapsize = nr_pages * page_size;
+	data->region = mmap(NULL, data->mapsize, PROT_READ | PROT_WRITE,
+			    MAP_PRIVATE | MAP_ANON, -1, 0);
+	if (data->region == MAP_FAILED)
+		ksft_exit_fail_perror("mmap failed");
+	memset(data->region, 0x77, data->mapsize);
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
+	data->mapsize /= 2;
+
+	/* Trigger KSM to merge these pages */
+	if (ksm_start() < 0)
+		return FAIL_ON_CHECK;
+
+	pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
+	if (pagemap_fd == -1)
+		return FAIL_ON_WORK;
+
+	/* Before migrating, check if All pages's PFN are the same */
+	*data->expected_pfn = pagemap_get_pfn(pagemap_fd, data->region);
+	for (i = 1; i < nr_pages / 2; i++) {
+		if (pagemap_get_pfn(pagemap_fd, data->region + i * page_size)
+			!= *data->expected_pfn) {
+			ksft_print_msg("PFN is not expected\n");
+			return FAIL_ON_CHECK;
+		}
+	}
+	old_pfn = *data->expected_pfn;
+
+	/* Attempt to migrate the merged KSM page */
+	ret = try_to_move_page(data->region);
+	if (ret != 0) {
+		ksft_print_msg("migration of KSM page after mremap failed\n");
+		return FAIL_ON_CHECK;
+	}
+
+	/* After migrating, check if all PFN aren't the old */
+	for (i = 1; i < nr_pages / 2; i++) {
+		if (pagemap_get_pfn(pagemap_fd, data->region + i * page_size)
+			== old_pfn) {
+			ksft_print_msg("Bug migration: still old PFN\n");
+			return FAIL_ON_CHECK;
+		}
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

