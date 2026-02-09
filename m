Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC823E81BCB
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D7F46B0088; Mon,  9 Feb 2026 09:07:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A2FE6B008C; Mon,  9 Feb 2026 09:07:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08F4C6B0092; Mon,  9 Feb 2026 09:07:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDAA56B0088
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:07:46 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A2C6E1BFF0
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:46 +0000 (UTC)
X-FDA: 84425096532.30.58F1616
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	by imf07.hostedemail.com (Postfix) with ESMTP id 75CFC40015
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:07:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AJi7ja8u;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770646065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+wgoGxovsVSyj6YfHpfyHHfkx2sD2EPV6RXDKPxlXU=;
	b=60HondhgJKksK8K6nMcRj6Bfta3LahoLonumr9BpVG+IaKKoUzbsznx5eWhPqlsj3XUncT
	E+TmSrZ3PoDqN92dLssKpUE9lCu9BU78Kv9OyWhzTpbfutDqtY51J/dcF7XB5izdFikK1A
	ig1/HfbZIlEHCElSxTRvwIXTOyNjH88=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AJi7ja8u;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.110 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770646065; a=rsa-sha256;
	cv=none;
	b=CgIM/PX/qxHjUmuWTLt4+sCh82HgxO5VZvhgtnc0Z4Y7SPVyIjzbUYLuOBoehOD3kYJUDq
	AkxzYit7lEaQQXdZNjGGfVPg0wWWj1BRrYY+gD+gn27LorQDKIjFon4cRyGC67Sd+H0wMW
	qZw81/0AuYLxi5APQ3rzsFPrN8HBULY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770646061; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=Y+wgoGxovsVSyj6YfHpfyHHfkx2sD2EPV6RXDKPxlXU=;
	b=AJi7ja8uABu+RII4xrVDnhfvpuKG03QWhqET3SHEkZ7c61zpeKp50NsLoCy9nU96iYfgNaki+uYlaDZowlkR+AP1qx5ZvDfhyVEsv0b8AFHDnE78awHOZo8ZMDrlF0X+fPB0UwUBy35jygF5cfhUCtWEq0v0MJJC13vw08p9MQs=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wyt6DkH_1770646059 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 09 Feb 2026 22:07:40 +0800
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
Subject: [PATCH v6 2/5] arm64: mm: factor out the address and ptep alignment into a new helper
Date: Mon,  9 Feb 2026 22:07:25 +0800
Message-ID: <8076d12cb244b2d9e91119b44dc6d5e4ad9c00af.1770645603.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 75CFC40015
X-Rspamd-Server: rspam07
X-Stat-Signature: exemwz7sxc9uku38mpyn74dngtx1j7q5
X-HE-Tag: 1770646064-801832
X-HE-Meta: U2FsdGVkX1+d7mG+1UawrxkC2a2QgZ6x4o9xxnpK7+kdsSF8Do4M9lcKrxoVrpx1rYv3bEQgUVhbxEbqkLklp9Tg5sRDabymD3O+erjxElBSDMCvMBQYlEFai3Q+dSIE61si3TEAQ6xoqKylzzoGvyVuKI8IvtWu67jl/+HhD7C4IF+EmdhSZzvM4xynj2aKSwfeilA7DDX2PBN700/3+8KFaXnDTgV0uIR/TbvhgkTUDy4+5WnUNYeiHqcO+VW5W2UIlME7ffX9qQYehkVayIKoO1WzShBN/le40W3SJukj26UWcBkeku/PWFwc9YgbWTuwbofyn7AdsIhd/eNzmbdwV+RXRjQA8pSlaF8hcVvpUxslDpoO2iQfqjo1gHKhXnh27sqVPoPxf+xgPb8uysfmgs3McksxlaT+EpXphayQUwGSbzY494MLil3B+1WbXUUyVCIjRH11p3++zcNaz5LxS7U5/6E+JLwBYzXpzUH8WrF1QD8csJlcTtbvSk5Wb8q8uUuQYa8eVa/0hwZX9bik0knoQTtvzNK01HVPt8AxP/mqkDONJsTzDpcu7Q4VIZfMUwaW4SZjmmseyBRbP9RkxYKK0KYOZN/BL+ncIXHwCHRSInNbxfi25ylAloWpB81CPoqj9Ql/pi/CrzN93dZiGipWiL2R9YVnz9pIdyPZ/ApVXz3U5gOth/rb3MDn90ibXNs1W+qc+1TkFOYch0hibrO36Q3BgZUgg1AghGhqiqY46trx7zZjgeQL8ifIj4KGf/6CVJu+mamvMPL4eunNDJQF0BXF9d4ZYEUYAT36yD4VXZowusSy7KeDzsfaj969rNTS7m91M1diYbfTj4Ey4oyfgc/GiyX0oldfkK8fXsQyr4HEJlRYWQWmc2q+iXZHvRQ8fCKw4TqPnLjUWZttFUwBxbWHNqjn/5/VhA50r3uBWqM8Ou1f3UvDz7nJft+LwlJPG08mdPWMVIy
 /FLpmMaw
 KZsNtgZhV2Bm7M+MvogAb8PEzY/7iftM9Z8jZ5KPleZUSBfAJ4R4yaAMSl6VzGelzvpG8FaQKoKg/g+GPDlfjCTkZl+wQoIS+j0o+SVBmhi//XDU6gPPm2Hswlmg3sxRt9AvnE1BQPzV1037/JFdgleKRCZouTGoHTnW2H4zY32Fuo6mUQkZ4ASYL4XJ08NiVPs+q+79kr1+XEdqhM72D1OBGoSvHCogPCrbFCeq/YLuAbb6A1gbMoNAHoH2S3DYhZikBDxKhfeWstRqxsysccc6YcTkB7m0iBTj/5kGFWsLRH8xGR8NML6wPb7BZf9YI4chUQjmACMDI/oMDGz0o3qsbTXL4jiF5kzjGKD+AsQMRi1o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the contpte block's address and ptep alignment into a new helper,
and will be reused in the following patch.

No functional changes.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/mm/contpte.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 589bcf878938..e4ddeb46f25d 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -26,6 +26,26 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
 }
 
+static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
+					     unsigned long *end, pte_t *ptep,
+					     unsigned int nr)
+{
+	/*
+	 * Note: caller must ensure these nr PTEs are consecutive (present)
+	 * PTEs that map consecutive pages of the same large folio within a
+	 * single VMA and a single page table.
+	 */
+	if (pte_cont(__ptep_get(ptep + nr - 1)))
+		*end = ALIGN(*end, CONT_PTE_SIZE);
+
+	if (pte_cont(__ptep_get(ptep))) {
+		*start = ALIGN_DOWN(*start, CONT_PTE_SIZE);
+		ptep = contpte_align_down(ptep);
+	}
+
+	return ptep;
+}
+
 static void contpte_try_unfold_partial(struct mm_struct *mm, unsigned long addr,
 					pte_t *ptep, unsigned int nr)
 {
@@ -569,14 +589,7 @@ void contpte_clear_young_dirty_ptes(struct vm_area_struct *vma,
 	unsigned long start = addr;
 	unsigned long end = start + nr * PAGE_SIZE;
 
-	if (pte_cont(__ptep_get(ptep + nr - 1)))
-		end = ALIGN(end, CONT_PTE_SIZE);
-
-	if (pte_cont(__ptep_get(ptep))) {
-		start = ALIGN_DOWN(start, CONT_PTE_SIZE);
-		ptep = contpte_align_down(ptep);
-	}
-
+	ptep = contpte_align_addr_ptep(&start, &end, ptep, nr);
 	__clear_young_dirty_ptes(vma, start, ptep, (end - start) / PAGE_SIZE, flags);
 }
 EXPORT_SYMBOL_GPL(contpte_clear_young_dirty_ptes);
-- 
2.47.3


