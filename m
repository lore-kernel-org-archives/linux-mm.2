Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A7FD74958
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45656B0093; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C5486B0095; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872ED6B0096; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 779F26B0093
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:03:15 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44630B8A49
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:15 +0000 (UTC)
X-FDA: 84235177950.23.5AC2803
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf28.hostedemail.com (Postfix) with ESMTP id 44DABC0010
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tqZYMdtp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124193; a=rsa-sha256;
	cv=none;
	b=2+PZ1RD23FDe8ODicM6bw6waKUAvdgzCQJvTODsvuE8fEDdNISr0DE3m8GfAb8+cYBphv6
	xp0sO8hdi+yg5qph3FNQJC6iUCz9efAHpk+1tSWNKIUCAhUIsZ/MTeh4ZJcTvATracDiam
	oej4CPCcd/Id5rFAnQ4Y+PHv5BuVa7E=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=tqZYMdtp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L8grYI0Jwq9L4Vxa84m+Wpr8ZQOY0j4j8t2HLaHt6zk=;
	b=1+7CDmhZJ65r4wPHfk6mtGM8NigstuXAexrLZ6HGJEMEk2J1EZfLzxErslXxxBYiKuKFvG
	A+2rRKmeZ/CctRiWGxeb7TgaLZwIsILlnDrI2jeUHXZz+Rmcoi2CGOvBlsR/TkzjDsdWxe
	END7MGN71mqFOr9rPtglSnojQYcDOGQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766124190; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=L8grYI0Jwq9L4Vxa84m+Wpr8ZQOY0j4j8t2HLaHt6zk=;
	b=tqZYMdtpLxkeXYs2gMXoloo5V4EoOotfAxpNSbLT+JjFbo5YPlPSZg1gOyX8QH/sum0svtD8ImgbTPvksGNJs2Dy90HYlVfRHUU/9QtOGsvRCXLHeGDYNZSLfdR1MzAH5+/3joC1IxlQNXR+BnpUzYL5ZZ9vTIT14dtHCgqKdQU=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvBZ2Kv_1766124189 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 14:03:09 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org
Cc: lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 5/5] mm: rmap: support batched unmapping for file large folios
Date: Fri, 19 Dec 2025 14:02:55 +0800
Message-ID: <cb6ca508c6800a1feef5ce31f96aa1e55ddd6c97.1766121341.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 44DABC0010
X-Rspamd-Server: rspam10
X-Stat-Signature: 7sarq8q9gw61gco7g8utarbpobe67ak4
X-HE-Tag: 1766124192-972906
X-HE-Meta: U2FsdGVkX181LwHtj/aFf+SfGlQn5KBBeWYaQgeD0rduHreQVzO1Jnu8jUhQ8ekuhsj4m6Cqxr5YH771AK9CySEG5k7qSew0hs4fPbVXPq0tHTAzpTkKqiuaj/DZe3sHQ7PgteqMhIpPIk5TuItNcLj42Ta0MzDLGcS54YDjvvuj3QmnhNlFDj2FQ4ecLcoy2cv3O2hzqRxjcKvsEZoCo1nO5SEeWdPvlPARzwQ4zkOkk29GaVYzO8mSb7jGGiqszWaiV1pLP0UWwI4LKO/pp7bP91YRQZafj/u6T7mzGHEllHau+2o6nCgRDopJXeRFgcoJHb1MJGiRJA6PJcIy6CpT+QO/ve4mz9ur6ofhT8rCEEboryme3UUBC895j8C8eZ7/j4+8I/yogOWFasxH+vQHETkIJQQxsCBuzWqTbpgaYbIaoIdJnGUc6+mRvdfXFw6vECs0q0Ol6hlOI+q1AZkX7sCJCMBpxY/z+z+gluDjBNpEoM9tfBM5xblhXohZuPIDstLZMa2pZ7NbVEDnYQe5VCQP47yv/UlvaSRc/n0ok8tGcGAu71Ze2pcP7uLb+H+BNRslBYUU2Dpg/55HtaskU6KD4hbq1OSpbK7oZJjdA37ZfWXjLjZCYGUEXXik/9eRIdnY5xhGfRryN0/40NQWDfvkYcfWnmRPXSDZrruNFfd6Yt/XfXRXJKYWusa4pxOOPePmYAa4ACrqKVuU9U+bPWcLrfAKyqAg3J/wxjERxlJitV1QPvsQVq01/IoUjQpPs8zIj8U1SbtONCfvGvqYonUqJF7jjaE5DPvI2R6rBRHu32doTyZZDDdWZMPLq4vBF2RR6flxEwwFyHEDK/Szsc7NHc4aeBDL9T6K2L/VsMud6OISqwNziAyXYsVdpLFeu0Gen6FNocSc5DfCDI4Qlls3ysyhnnH1YEC7wKtZoFo/Ts0P2uBXE4M0MI4RLhGn9/YiJAKwnPXWlM8
 GkcdyiV/
 XiXo3qEBwi/8vj7+vSEhE8FzDGjJJGCyHCEjG2iu/vPVld0RasxA8NVacBWskOQV3z2dmowIopIcapH+iZclrH2DfmPedld4cTGISD6184hJrQlGKV7CGqJwkETljnPGsFPZJdP5RsWtQ+hUd1l64m8N1rtrofb7y8NH/I6Eb12cEYGye/z+ozqS+jpBak2GLkAAxZ6xfNdtQHeqTAz5EbVGN1Zdv3x+e8gdj+g6CKVwXEziCGEIxqmnwcwVOyG0wo3qCelrBpSsx6cmmfP3h4OzWFaQ2Pno8MtudrtgP4WUnpQk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Similar to folio_referenced_one(), we can apply batched unmapping for file
large folios to optimize the performance of file folios reclamation.

Barry previously implemented batched unmapping for lazyfree anonymous large
folios[1] and did not further optimize anonymous large folios or file-backed
large folios at that stage. As for file-backed large folios, the batched
unmapping support is relatively straightforward, as we only need to clear
the consecutive (present) PTE entries for file-backed large folios.

Performance testing:
Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
75% performance improvement on my Arm64 32-core server (and 50%+ improvement
on my X86 machine) with this patch.

W/o patch:
real    0m1.018s
user    0m0.000s
sys     0m1.018s

W/ patch:
real	0m0.249s
user	0m0.000s
sys	0m0.249s

[1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
Acked-by: Barry Song <baohua@kernel.org>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index a0fc05f5966f..7482121d4e92 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1862,9 +1862,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
 	end_addr = pmd_addr_end(addr, vma->vm_end);
 	max_nr = (end_addr - addr) >> PAGE_SHIFT;
 
-	/* We only support lazyfree batching for now ... */
-	if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
+	/* We only support lazyfree or file folios batching for now ... */
+	if (folio_test_anon(folio) && folio_test_swapbacked(folio))
 		return 1;
+
 	if (pte_unused(pte))
 		return 1;
 
@@ -2230,7 +2231,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 *
 			 * See Documentation/mm/mmu_notifier.rst
 			 */
-			dec_mm_counter(mm, mm_counter_file(folio));
+			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
 discard:
 		if (unlikely(folio_test_hugetlb(folio))) {
-- 
2.47.3


