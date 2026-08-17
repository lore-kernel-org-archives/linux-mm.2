Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39D6C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 08:06:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AF786B0099; Mon, 17 Aug 2026 04:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 060186B00A0; Mon, 17 Aug 2026 04:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDF5F6B00A1; Mon, 17 Aug 2026 04:06:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAD596B0099
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:06:45 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 52B00140702
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:06:45 +0000 (UTC)
X-FDA: 85110029970.28.4896732
Received: from mta1.migadu.com (out-94.mta1.migadu.com [95.215.58.94])
	by imf21.hostedemail.com (Postfix) with ESMTP id 86F971C0005
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 08:06:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tKs2Kniy;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786954003;
	b=j2Q814bFYYvvUPZuDBvd8OJs+nnG3GUizv6UIP21ox0V7IUA2zDXXK1a+sPsUiPYKhDKB/
	hmzGPB/nZMo47f5spaxEo+DaIvBT7gGZcTCGsk6eB96nj/SZMLXEF33V3WDirORqZd4mpX
	a1Mz8ra54jPsMApgqM5awly/gZmlXJI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tKs2Kniy;
	spf=pass (imf21.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.94 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786954003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z8gv8OCDCPiya7qe2Fko+75URVuHJR+OB/V7rfBUZjI=;
	b=OdjLhA5ewTagRoneDYBkdLiTny4U7I0fkYm7Yaoq0Y/9QDXjNeetjsctuwkH36G2h312sT
	7AERTgwVupuF7Bj0wQPgw1KVx94GI/X0MQAHxsvaNSF0KtU8l4NX/1pAkYChFGLbIdJ4eN
	3Cz2FsMUGOnSbAUUgM4ua+yGEhwfH+s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5yaGSH3BYPo6k782/jrFz5kavJsoRXjePeFuyIykNaE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786954002; v=1; x=1787558802;
 b=tKs2Kniy5Su8wJKGwrH9TnFYixvwBWpqXVHcez/E08gqNSfFVTk8YKVUeomaIpOWw63DGffl
 NmExw1nvdBfuLIcrY4zNQ9aWWzu5Vqok6NjqsKvxxpky3f1ODy6HWu7Z6wEp3Q0idI1mDWnD97U
 W/APF4NSRE52gZtf8QisBglI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.160.239)
	by smtp.migadu.com with ESMTPS id 551a8aada41dd678;
	Mon, 17 Aug 2026 08:06:32 +0000
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] selftests/mm: Drop redundant open() in mprotect_tests()
Date: Mon, 17 Aug 2026 16:06:16 +0800
Message-ID: <20260817080616.52946-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 86F971C0005
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: ktk5h7ku9pb4y6o6f8oanhiod85drsmc
X-HE-Tag: 1786954003-947689
X-HE-Meta: U2FsdGVkX19pnQzHDbUpphnHNNDeX5s9yQuK11rmXPAwgPUkgPWjmCSGay+nzwl9MnwJBBbDOoE4qyZqhWxT0hdfEybGqb7yPHL7Fhtxvyn+kUwy11YtHzZyBrhwnQa6fGGt8Qa3Dfh/ra/Bf0WsWrOJW4pAPQKJ1SFambttSKv6HOSjbp7NUIIjUQqAmcMmM1lVRzQf93cyVxFUrN9jcYqwJHgKQG3pEQ7SLiO3tlQctNdK0Nq5x0fqssIi7MiRLteWLB/piyqTdvF1Gj+3lVedahtQNZkhG+ZjPDOvNq1OXOrKbJomIqDYcdrUKbDKnljXa9HyreTVbEenf0Urtp0YDlkD6T4eWi1DxrVadO4l81OxL3JvQ37U4O5XBDBzpqTqZ4EJfM+A1+KKTzKnCrA7s7m4PX4ADwUhmWBH4FgVNMeOZATr9eovCDo6P2X+JFevHT9FzHvK/lkZC5uF8eoEou/iL+XoniWnpMVqx0YCgErScQNqGqY5+1k5OQt5jKAAXltSvzxwdwjLxYpxzgsEC6Y58viNgKUDpKhhVMY9s84QTnZCkDikyTB9ezA0r166z/qxa/wyCIHITvijiUtYU/wheAoN0bwPri6M8W52ZopahCwHCwHOTxUi8M0deq8PiHyX7hvxoBVaG+WSEIfvNrU5MC5UEYSYgz0uhuYRIuk34j1LR2f4VvZR+PP8DF78htuSzpCkRILroIlOn9k4Sf+GIrU+OFpU18HMNc/xmtCC2dcuBpjAlo//vZKRVGMvuBkekoS80U9+QuohryNMc2SXIipgYKk9shG6q4r3zg5+Vqrleq29sKaLQk9CFggoMgeVX7eREA0sNa97W3nbaqXi49kc2cXpQmSIbnEUhzCEYPRGX54tcTU2fBx7lg/CBrJpPjRamAwgJ0IlD2Pj7scN3TANfd28EE174A+z5kWx4qvseBYXd4/N/7LVtFobiqXIxj6AAbW1YB5
 W9oyyvNF
 Z2+baCLu4SuBB3bF+VZfLr/ZkCv3rwNaseCrZpptYmsQ4axvMrzJvOPpyga5P5NgdiKsQ3748Sx++fkqtobO6DYzBXFfJbAygaquOHFSCGjmBVJ1SJbDBSlHXnIfoITAhArG4uY63MdhuRMpLHRknRJuubb+0tk8OwPBj/m7hySVVXa3yQLUdHL8moA5kucp+VWposH5CKE6qULlwKBSLuFEZ9PCT2diE2GfFsWqXWU7/8UR5035lHBQRkNINOgG/cxKnKpfZAr+oCJ/qFK4hy5LAsA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

Remove duplicate open() for local pagemap_fd in mprotect_tests() that
shadows the global pagemap_fd already opened in main(). The local fd
is never used in the function.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 tools/testing/selftests/mm/pagemap_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/tools/testing/selftests/mm/pagemap_ioctl.c b/tools/testing/selftests/mm/pagemap_ioctl.c
index cfd1987339c1..eadc7159ca5b 100644
--- a/tools/testing/selftests/mm/pagemap_ioctl.c
+++ b/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1332,12 +1332,6 @@ int mprotect_tests(void)
 	int ret;
 	char *mem, *mem2;
 	struct page_region vec;
-	int pagemap_fd = open("/proc/self/pagemap", O_RDONLY);
-
-	if (pagemap_fd < 0) {
-		fprintf(stderr, "open() failed\n");
-		exit(1);
-	}
 
 	/* 1. Map two pages */
 	mem = mmap(0, 2 * page_size, PROT_READ|PROT_WRITE, MAP_PRIVATE | MAP_ANON, -1, 0);
-- 
2.54.0


