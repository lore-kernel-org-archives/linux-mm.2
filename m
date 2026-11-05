Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1376606D830
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DdUxBCDe
Received: by kanga.kvack.org (Postfix)
	id 119726B05DF; Thu,  5 Nov 2026 13:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F9BC6B05E0; Thu,  5 Nov 2026 13:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87626B05E1; Thu,  5 Nov 2026 13:42:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C67DC6B05DF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:12 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6975380BEA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:12 +0000 (UTC)
X-FDA: 85401935304.07.4D87F2B
Received: from mta1.migadu.com (out-120.mta1.migadu.com [95.215.58.120])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8C12D140008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DdUxBCDe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.120 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XqXD/2lRDAC3Cnm8xmgp9dv4WWL3d1GwgU0I0vWe+J0=;
	b=GX3kGAzw+HbWf3//wimpN9wE0oHcHaejZHODo2KYVMSI3VlZTpCT8b6FHfu7E0Epcz/3eq
	5Vqusqsce/VV8UsNigE/UpJ6g25JRI6dON4Bn1U4uVdQbLKA0WzLd7tia1TftM3PKu/VWS
	B/t/wPy5b5KTCsYhyblUyCdfE8Qdzcw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DdUxBCDe;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.120 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904130;
	b=O8T/SEpOSy/6ml8B5Npmqhrqk0aI9qjv1tl3xR/DZstGstSMA1B2eJzlSbXCx92YOD4w0D
	d+hTMKpudirPTISkMfXePRUhV7pEeoC6HonN4KPakctbJAloRQgjowFMSyc1UX0ndtmTKo
	N6h/ueihtz6QQxAEt8peuZbBGXiWM5Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Oac/ikxAEitIxX3vkVIXGNQJ0CtOZchotmEuyKH1+mQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904129; v=1; x=1794508929;
 b=DdUxBCDeUA0lDuFuQozci7cp7RXvJFszP+waC3nslSx79HXclOQ+fDjPgLmLQo40t+aQrjOa
 ZwiH2vLu5DFLnzLgBuC0tHGvj4TTG8JoSv6SuZf8KY9xfM5gtsKyjdzzqUhoIOI64lvsrixQPed
 xzVdIm2iFs9yFDNdJNIr/B5M=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 049b5ed1b8e5d6a9;
	Thu, 05 Nov 2026 18:42:09 +0000
X-Mizu-Trace-ID: 049b5ed1b8e5d6a9
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 26/32] mm/khugepaged: treat PMD swap entries as mapped THPs
Date: Thu,  5 Nov 2026 10:39:10 -0800
Message-ID: <20261105183940.2236717-27-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8C12D140008
X-Stat-Signature: rrbs6eke7h8dnwihsdzidqrw914bbx4k
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904130-568433
X-HE-Meta: U2FsdGVkX18ZcU7u6bcIoNmxac4p5ogbgDoduFswiNfHlXvQPrOXH6+E2HHiF8xqJDMVzzFLFNlUPmTdJrD0O6l5/QB6955665FyT0wlCopCphHvSPFyn3EE2qSUCFro0zHFbyem5oELT4k71CUaZdCaseKJr/42tHqJa4pMMqzl6n/ljXJq9gZRtiYfM0FdSFbvFR5jLYg4wmgkbVaWOEJiOzk8ffFj2W+/6vU1mRj7hW2u3yPEFBwpAK90ZJ6gM/iJKFxK4rj35Yd3MitJUD9scR09ytO8bWC3oBfXL9/2FInMWC14e42JO0savABkYVNpc0klTRCnUep97nh9YoK0AkbDJGmIdSbQVzEyrRElerTPD5AoUTK5GNsT9HS8BkyECwEA3pCJhwG/H6QpKC9uu8ZXORSlXFodl0RoKqpVnH1gIv1zf4pSgfm88f4+tCQp5vCRN6Xz7tykkMH1BOYyiEhwGGTdkpV3i+dKT+lPHdVVtbgZulJd3YW+XeWIyTRk96JajIdf5P3obX/3BZs+L3iVmhBkbg5Z+IHwymK++QcmpbsTXoliPNYKrAO4OipmCF7Wzp76b3TDJrcW1OnHG+YT7u3uZo6OtQj1e5dP+UHyGfqIgqJU7tNfo0cnhUw0hzVDB9tk8Y+5ucVPVaKrDq/aJB/AGqsZWO9rTJAkJE9RxGp0eKy5s5pElZpyW7/Waos/IENEmmeBMIp+HIivk1WJRxmcV3exedf3gTLQV1sqvHbBOwXLhHFmN1+twlH/RBu+RH8GHk6Sv7ubNlwPpd1BVzvufJY3P6TC/nv4c8yXQUcVMiyESJ9WUO4jnwauHMh61+wTtjFWyW5IvBvver8bxZgbn/YUo7MMdT0Lsrp+K1RYJQhoo4rZlC/2oMlclxnaQOZmzYHOBB6RVjLmo96DlzfsP/WKtxmlfJ3laCp7ZIHXb70fdAq5DAwgYR6gwBrNo2Te0hyR0UT
 rwBT6ktC
 BQkcaCvkI4D/dTUQ2PkYvHNorW5sWenlxtQuMW8a2SpmB8xWSuWV7IXZBKZi+Ou8EthlykpxBsQw/zDUONW8oe2zjOHV/U62jQE0s9vTnFKy1J0RJXB9VShu1SwagIzOqMALmjEhqUzgFS0qOgo76N7+Qm7gm3E6y3YBr/xKxzWqW/1CBeSKTMqjcZ8xrMD0OKxjgI4U1MazZDJDELadCc7JxWI6gHc1JSfeBPIfTNNysdxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

check_pmd_state() would report a PMD swap entry as SCAN_NO_PTE_TABLE - it
is not present and, on x86, is also pmd_bad(). The range is already a THP;
it just happens to be on disk.

Return SCAN_PMD_MAPPED next to the existing migration-entry case and before
the pmd_present() and pmd_bad() tests.

This does change MADV_COLLAPSE. Today a swapped-out THP is HPAGE_PMD_NR PTE
swap entries and MADV_COLLAPSE, which ignores khugepaged_max_ptes_swap,
swaps them all in. With a PMD swap entry it reports SCAN_PMD_MAPPED, which
madvise_collapse() counts as success, so the call returns 0 without making
the range resident. It still faults back in as a whole THP on first touch;
only the point at which the I/O happens moves.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/khugepaged.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index da91762f6358f..b900037bb43c4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1065,6 +1065,12 @@ static inline enum scan_result check_pmd_state(pmd_t *pmd)
 	 */
 	if (pmd_is_migration_entry(pmde))
 		return SCAN_PMD_MAPPED;
+	/*
+	 * A PMD-mapped THP that has been swapped out is still a THP from
+	 * khugepaged's perspective; treat it like a present huge PMD.
+	 */
+	if (pmd_is_swap_entry(pmde))
+		return SCAN_PMD_MAPPED;
 	if (!pmd_present(pmde))
 		return SCAN_NO_PTE_TABLE;
 	if (pmd_trans_huge(pmde))
-- 
2.53.0-Meta


