Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2461CD6E43
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 11:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F4D6B0005; Fri, 29 May 2026 07:17:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0676B0088; Fri, 29 May 2026 07:17:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5E16B008A; Fri, 29 May 2026 07:17:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AF04B6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 07:17:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DF174130D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:17:21 +0000 (UTC)
X-FDA: 84820206282.04.2345DBD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 609F51C0010
	for <linux-mm@kvack.org>; Fri, 29 May 2026 11:17:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cmig+QQR;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780053439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=267QOHGgx7sVtrdH9KP39kxcpDvI7QRg1mO8AKlytqc=;
	b=LKt0qKJ/C02PHqUf7jZ63mSDXIENoS1CW02oCg/ciiFhDABiHECKOr8hRQzlVRv1GknRl3
	gidhXbNbHY/YZrucwVLEUzezq6jizgFwImwQTW7ehgivHXOAArpp9bzVotMfRS8UVIfwMY
	BOqzZsx/N25ZcKfaMPg3eLxTk++pQJ4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cmig+QQR;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780053439; a=rsa-sha256;
	cv=none;
	b=Vu1b28pMGivt0YrWsDxErcwSSMEjQoKBS14NJpz98ZFTZaKxXsGZNGQrNkX4/4UfgtY8/Q
	5N7hTt7xkUVvRNEkc9wSQR9VPm0YAirLsWIoTiHE7fiVy8XJ1a0J4UQPzDgK31c9qP/ifO
	RBU57NXGliaaJIVlsBj6LRuZKE7AeMs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40F072247;
	Fri, 29 May 2026 04:17:13 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 30ED13F905;
	Fri, 29 May 2026 04:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780053438; bh=cx9bkGJ2eDRyMtzNNbeuK1dl0e/7tAqg3VyKX3JjrwQ=;
	h=From:To:Cc:Subject:Date:From;
	b=cmig+QQRNEziskriXoC4pzo9VhXrb3OFQb0apJK+kRtxnbwjtcgcZktmT193CNieV
	 233HUHFvMNrJwFG/lOUU41/ZbqMDIhECIBUhNb4/7jDeCbDbnGLyA22ih+GePPa+Eg
	 Ycwv0YyxmHAIdnPjbSWPowjJt+L/O73CN84pDsuM=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	jgg@ziepe.ca,
	leon@kernel.org,
	david@kernel.org,
	shuah@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	balbirs@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	stable@vger.kernel.org
Subject: [PATCH] fs/proc/task_mmu: do not warn on seeing non-migration pmd entry
Date: Fri, 29 May 2026 11:17:03 +0000
Message-ID: <20260529111704.1078346-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f8ik1f4u171tjbc3w3561ot1osxot36w
X-Rspamd-Queue-Id: 609F51C0010
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780053439-82517
X-HE-Meta: U2FsdGVkX1/t04de+ORl2jAcVE3Z9/PmxqULwgNCrpxQm9Q0eisRS47UG0n3s4qL+7aURh3OIp2cWXPbWSkMOYNMlkf1btrx8WN30PM8ptvTiGkdouJm/hap7kjg78rMcalWNgOnEL5tjxLD/KrWsr8DRISHgx/GGfk3E7/8Ms8gtUcpgnWDlOImtKk2zkckXahXHLd3rysVBy1bxJwIfH1E+y9WiD4wfKVPlkol0Y5gcPzdw4cxcBncpJVWVaKyIE+o9oEmr1HnQ1Ckr5R2KBNb7qOd1fVduXHjObl91OU+X0A8/UlE7yoEH8xR76iShpjNkpPRJqAahQyyDNvn6mNJZ+c634CsJ4umqNte8dgsISe/XnSqwoR8KVwMorHpQZIkENRGQis7TvedtlMyK+NudpCEVQuh54PFQ4EOJhAJ1qjPXTy5o6QgVtRw+OQc01kMLLadiRrSWnnBQZP7kBBPrPvb2/zWKcsVcLtvYBnu7vexdgjCaL9Mbwwl0uXosVrrLbcKpuPAaC6u5NkzNIqOCmb81K3d+1OQ1f3md95MZ3TLr/m2exi+85neJeV13h14qUpxThni21jcHOiNpA0+jkpfAzM6e6giaUN+COKORlZgH38RFAELTZqqTAniRQLoZSAH5oF5UcQbgdjkxS8Dk3KqgoG+v2Vlr9cvY5gZrrGJWGZ5NPr5TRyuqXP3zHRjSLsDF9yzO9NHV1/34KjXYKZ+g+PWBnzx1fu7jga0Qm1/rtJL996DO9toUZIf1L+j5/BRJ5Lm5X/l5n5x3QBVA8Pg8W91NDKRNvGSGyCg1lfCb7yNjpXAM3997SngIciv/+b9g6hzR0GkULDQH2nfR/DjnjQlw3RLfinr0sH1h7LOMg8UbCSutgrT9CaD0xUaP9F69bZ3fW07BcRKsTIRyBdJ7Mz/5lnHXOyccU/96kOyPXEbEGwES36ao6wTj6z92OqEpL0itkVkjuo
 IF0qDSSZ
 +dwbKvxXZSem6kjFQYLbfJidb8rGVWUCISEnTbfDumnfHGrHmqr7kfGdJrd8K78PwOg6yMbEAWNrKCn4ndoBCDzS/JmzczMzIqsPyAXwhdtpXrEV+7Yo8L+F7hCjMGvlRi88KvXVMUtiyWW/RZULV6zed/ynW0qI/7dqLQtA7i3KqWlzszx8Gzc+nEv3lFh/my/qdagrUcU3tRUgeLOPGSUVe/iD4jwV0GZG99NKel7++lQoExQubZm6YKmhDwChCfTMtTRRmCDD8XMIimM3NA9Qz/KrnBoh/pfo8wNYy1sfIw2WuKczNh4yThnAvXibNmYl/BiA/GgckoLDqWQ23bkhv2hSOwUKGssVEgaj0/ps9cjc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

pagemap_pmd_range_thp() warns if a non-present PMD is not a migration
entry. This became false once device-private entries at the PMD level were
added.

One can hit the warning by patching hmm-tests.c with the following:

diff --git a/tools/testing/selftests/mm/hmm-tests.c b/tools/testing/selftests/mm/hmm-tests.c
index e1c8a679a4cf3..7f0a3384f3c5f 100644
--- a/tools/testing/selftests/mm/hmm-tests.c
+++ b/tools/testing/selftests/mm/hmm-tests.c
@@ -209,6 +209,37 @@ static int hmm_dmirror_cmd(int fd,
 	return 0;
 }

+static int hmm_read_self_pagemap(void *addr, unsigned long npages,
+				 unsigned long page_size)
+{
+	const size_t entry_size = sizeof(uint64_t);
+	const off_t offset = ((uintptr_t)addr / page_size) * entry_size;
+	uint64_t *entries;
+	ssize_t nread;
+	int fd;
+
+	entries = malloc(npages * entry_size);
+	if (!entries)
+		return -ENOMEM;
+
+	fd = open("/proc/self/pagemap", O_RDONLY);
+	if (fd < 0) {
+		free(entries);
+		return -errno;
+	}
+
+	nread = pread(fd, entries, npages * entry_size, offset);
+	close(fd);
+	free(entries);
+
+	if (nread < 0)
+		return -errno;
+	if ((size_t)nread != npages * entry_size)
+		return -EIO;
+
+	return 0;
+}
+
 static void hmm_buffer_free(struct hmm_buffer *buffer)
 {
 	if (buffer == NULL)
@@ -2314,6 +2345,10 @@ TEST_F(hmm, migrate_anon_huge_fault)
 	ASSERT_EQ(ret, 0);
 	ASSERT_EQ(buffer->cpages, npages);

+	/* Exercise pagemap on a PMD device-private entry. */
+	ret = hmm_read_self_pagemap(buffer->ptr, npages, self->page_size);
+	ASSERT_EQ(ret, 0);
+
 	/* Check what the device read. */
 	for (i = 0, ptr = buffer->mirror; i < size / sizeof(*ptr); ++i)
 		ASSERT_EQ(ptr[i], i);


Therefore, remove the stale migration-only assertion.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Applies on mm-unstable (404fb4f38e8f).

 fs/proc/task_mmu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1e3a15bf46f4e..58938e62154d9 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2129,7 +2129,6 @@ static int pagemap_pmd_range_thp(pmd_t *pmdp, unsigned long addr,
 			flags |= PM_SOFT_DIRTY;
 		if (pmd_swp_uffd_wp(pmd))
 			flags |= PM_UFFD_WP;
-		VM_WARN_ON_ONCE(!pmd_is_migration_entry(pmd));
 		page = softleaf_to_page(entry);
 	}
 
-- 
2.43.0


