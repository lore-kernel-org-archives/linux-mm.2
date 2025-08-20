Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CE09CA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:08:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3209C8E0043; Wed, 20 Aug 2025 05:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D19A8E003E; Wed, 20 Aug 2025 05:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BF058E0043; Wed, 20 Aug 2025 05:07:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05E8A8E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:51 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7B35834D8
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:50 +0000 (UTC)
X-FDA: 83796558300.30.505A8F7
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C4BD180007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eDWwwc0Y;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680869; a=rsa-sha256;
	cv=none;
	b=0rsFCFTQfuwmng76Dtp3jZw3GC6fEwFEa7JZc6zJvK3zssVit0Ztguyd5ojjOag/kA3t7S
	MH+eZuTrRsOzcTwgvoLI8ztq5rkSABIWEodKcA515nN3itfHlu9LaPFiZxS8qlMkrl1x5l
	jCyGEnEsi9GwZQ7yZ4kXM8VrZmjpFsw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eDWwwc0Y;
	spf=pass (imf06.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjISQWqO9y1RYDSZTblYyeGwhEoGNvkdz3hoHgtvBm0=;
	b=c6xHurvAv8OD8US2DdPdeOHfwj7o4bJ/q7zEO5v+Iw1hiku3wszTj4ed6u8PoBC2CkEWmz
	3x4sfgBdHCTbBxmBH/l9FD8SywRDaU9dmBJTTDjN0r9UiLWNl5RGg5eohoAT+FSgqmTzsv
	mfevqfsscU/wmZsEoS1pA9BEyEG3qus=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680863; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=EjISQWqO9y1RYDSZTblYyeGwhEoGNvkdz3hoHgtvBm0=;
	b=eDWwwc0Y9ODZ1cQfgcKhueuOazvdOE7ix5maBqTHoNTfNKt8CXo/YBYNjnfPnEyttzrY/yNs3eOyi5idIH4cYLk+SiqqsdWULGOfA+KJQDet7UkRjXfccc+AdrlY0+qKfoKvQyoZFa1vHoCsA7lc2+x64fsdQ6QshFYooz5dTfE=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBICuO_1755680862 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:42 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 07/11] mm: khugepaged: skip large folios that don't need to be collapsed
Date: Wed, 20 Aug 2025 17:07:18 +0800
Message-ID: <27aa3e9657958cf17d0f42a725155c05b21806e5.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7C4BD180007
X-Stat-Signature: i9pmxy358ro13i7geskdkandh9pk98ha
X-Rspam-User: 
X-HE-Tag: 1755680868-894446
X-HE-Meta: U2FsdGVkX1/KkwlfW8j+6wjYLCilz5U6rP9SGnIDWrBlagMKgmXI9uqYvRHZdSFX+oaV7xRl7rM8Yb1dLSRlfqSC2/WRLTbp0Td90P8Ntl15wM04myYvW3+JoHKB33CZltys7g4n8n3ppW57xKFkjcwibsGp2rgMJ1uedPOXcIN8E7AAmEUXF5dcBowcl5NRy4/daQIB/XxFZ7hH3voNuZENaNR4wAlB2vtH3f020dqVHVdsgx3E6F8iMhA9mndJmhAlCfsjHFe1QBpUHGxgHCmubyTnqEC81J1xZfYelywhxGSIP/chlR76z4JIOey9LeMHGBb3oON3qZm2sAwy3WP3A5uNL8Saa1ANVIv5QLVAEGg5SEGA41pUJOrZ5AA6ITrFU3dX0HW5jrC24YfnvTgZ1elNBq6sFNRxtRZ5TmpMyuxOk9gChcmq25nIJhTJHdWrFQQytbBvlZcBmALV8vW7WIMiHpmZpgbM05K/0KACYEVMsOESHrpKTiVfVvPOlf6sZeOLM62ECHni5ju96Z09gf8y0aOLf1Up8Pn5kz2ZZdaG4ZD9JQu/MQTnf2uMu1T8Gub5lcpfd6WaijJ6jBYoOPK8ReGJswumEwLEFi/POtN5cNIpckmU4kKbu6c8vC+clXVN87iNOo9G8R+Vtc5hoESbVHD3bB88L+Ja1Zwg+wYzf0BRdyOXIVFWelKS5pWriNDYEEjvgUFna5mTwCi2QHDeiTzU4skSx6BIyHQmfStgZQe9Sn7PzcFd6Sd7VoIStp/EOkcc14QRWRKPEZ5JFg56Ag0vg75bFegWH+JK5jcRUFNl8ubHB83Z1UNvoBET0lLaHjfhyCNdKqQU9rspZju+QCRbTs5wzdCP7+i6XKg9uUfSR5czQ6fUyGBp+FenlqGOm7FtQK/u0aqMxMrw/8SCeer41f3/cxchbJ/UtoRR+4CHwkU5fa9kgjk2+Q7hPbV6JhO7uu8IdIo
 kweIywC6
 TJuIxhrTkXF463VM0fMVSIr0/b90owopxmc+HueppxmUV9lwufE87RoCSKRKw79dMuv3RV0MTkuT2D/V0hv+ATLxxYFB+bKQtp2IMHCz8rKK8H67jw8l/MmJzN8fH9remfpSgicdPtlbSwzNB3CR10wuVSFL3W/xtQ3YPFydQiHPXYbXUtEL7ETIbkb1yyzpj9eo7zoEkZqkhV1HGSx4O0QOcQl4Pg4QZoUWM19pLUDQz6NlvnvbaxgQX7fto5KYWzayqW9uALTZyVtokcruI5BjpeD8B3T1mfmjT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a VMA has already created a mapping of large folios after a successful
mTHP collapse, we can skip those folios that exceed the 'highest_enabled_order'
when scanning the VMA range again, as they can no longer be collapsed further.
This helps prevent wasting CPU cycles.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index d5ae2e6c4107..c25b68b13402 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2537,6 +2537,7 @@ static int collapse_scan_file(struct mm_struct *mm, struct vm_area_struct *vma,
 	struct folio *folio = NULL;
 	struct address_space *mapping = file->f_mapping;
 	XA_STATE(xas, &mapping->i_pages, start);
+	unsigned int highest_enabled_order;
 	int present, swap, nr_pages;
 	unsigned long enabled_orders;
 	int node = NUMA_NO_NODE;
@@ -2556,6 +2557,7 @@ static int collapse_scan_file(struct mm_struct *mm, struct vm_area_struct *vma,
 	else
 		enabled_orders = BIT(HPAGE_PMD_ORDER);
 	is_pmd_only = (enabled_orders == (1 << HPAGE_PMD_ORDER));
+	highest_enabled_order = highest_order(enabled_orders);
 
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
@@ -2631,8 +2633,11 @@ static int collapse_scan_file(struct mm_struct *mm, struct vm_area_struct *vma,
 		/*
 		 * If there are folios present, keep track of it in the bitmap
 		 * for file/shmem mTHP collapse.
+		 * Skip those folios whose order has already exceeded the
+		 * 'highest_enabled_order', meaning they cannot be collapsed
+		 * into larger order folios.
 		 */
-		if (!is_pmd_only) {
+		if (!is_pmd_only && folio_order(folio) < highest_enabled_order) {
 			pgoff_t pgoff = max_t(pgoff_t, start, folio->index) - start;
 
 			nr_pages = min_t(int, HPAGE_PMD_NR - pgoff, nr_pages);
-- 
2.43.5


