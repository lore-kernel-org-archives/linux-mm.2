Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEC2E8FDA1
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 06:08:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B55F6B008A; Fri, 26 Dec 2025 01:08:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2352A6B008C; Fri, 26 Dec 2025 01:08:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F0B6B0092; Fri, 26 Dec 2025 01:08:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC60A6B008A
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 01:08:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9B4561397D2
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:16 +0000 (UTC)
X-FDA: 84260592192.01.DDAA2A1
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F91E1C0005
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 06:08:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hDCCA19W;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766729295; a=rsa-sha256;
	cv=none;
	b=zdlZaCpbFQOMIdwK693L202/Op2vuXwcgFVhsPh7h8iwWDDuzu+4bsYi95ujwmfBHz/CBt
	eSHQ9tK9z/i/0S6HQHM5V1IXw+eV6sCmRo4jkg6U0inh1s3zPQPfgWNH9y75/1YU4b8882
	DqN9yuhbTRtEVYB760pczvBgl0q+vTc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=hDCCA19W;
	spf=pass (imf20.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766729295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JywGC+fWFsSUoZkJQiSUCEBjm2Uqo8gCk+8TA46l7nE=;
	b=lxwjSf8A+YFUj3Swv2YjJ9dJeDLrPqlPJuHqekTnLGyvMT+V/ASzdwmDSYfBVLyc4vRz9n
	E7AA2qloF1Awo2esqlwLW6HWm6iF4FTjFBw6PPK0IRuYOcp8J5E29sXsyOCCPRpQebXe4w
	mI336akWrd6AGUFIZuRUkPohvfiTi9I=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766729290; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=JywGC+fWFsSUoZkJQiSUCEBjm2Uqo8gCk+8TA46l7nE=;
	b=hDCCA19WdxT8/1e2jqInSOzKAAAHgsVVURDsItUuaIfDbrRMSXx5GQyRnjfNKvbmMp3Liz9EN+Vzi8143/1eDSXes/P6rC8B4ckQ9nE4iAuTrINv+iiH14WhJL6lWg1u8d42D1Di2rLe+TJyKRPrPBoupWobtJczmtLpYwMJSIA=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvgbztF_1766729288 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 26 Dec 2025 14:08:08 +0800
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
Subject: [PATCH v5 2/5] arm64: mm: factor out the address and ptep alignment into a new helper
Date: Fri, 26 Dec 2025 14:07:56 +0800
Message-ID: <70499ea05beb23fe386b3d4423249a817cec17d4.1766631066.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F91E1C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: 75f6azbq6f64ttr6d74o9ei44w46ecan
X-HE-Tag: 1766729294-103913
X-HE-Meta: U2FsdGVkX1/VgoQSL+a1pNAM9JY0o+m9ZiyqidsUOqP9TdL4JnigzHImSkJgN988T+aCc9l3Ysmi8/CELC5Dmj2eskQBC/R0LcK79Rumnv4RSVrQUnQDNMNX12EjolI3vL1q4Wo5/jJuRD4bdOTLD/VQhji2hL+TMlVVZgDSohJJT7wFg54i0KpNyJYeYiu1k+yRgGqI61ofkbCzBiL9DDw8PLV+NNAZjs3AcpOj06wwAcDxAUv5XdwVbjU7tEFK0X/aLD7YZY8Qpeu/YXfhUVwkeB98JDlFguHkYo/gf4Omlr/hiwL8+XVt/s0zAhjnBLjgvCpoFy9CgIyQfY4SSUIybbD+70SSaRjVCn0nY4G5Lsf53FRYfmP9thFlxuIC41sfPVsHP5LFD2zNK0JHOVaEjJI22J6IIozg50VI2beLyyBy+XdS6cX5R636a+Sr0V8b8jfC7kFkFgctTf/PP+g4ZOArGW8dFKROcFIa2+ERc6ugJd2hd3RAajE4W1/yurnK1ye5lvwKIvPO6taB/AL90mCM17SJhEgvep2w1ylXIib0OYTk2XtRULpFEm3KAn6uvEQ/d1DiQ8PJqvThkzOKlH1R71HCHgLK0fuKYIl6wiDWZgzju0rVQ4Ioo8nZw5p2QgIrKi2tKgvrYOs3fBieWwbJVlWhFpbwxslfcJF01cKK/j8j6Nxg+OTZDezIIjqqgVkCgJne6FIhxl/99SA1jpttfGZgk46Pjn0BFFyvenbAIpaTLgm/8BUi3tMkiKP0Ign5tD4MJlAjyEhGfiF+psGfW9EiAbW1F8y6dUwkqREGM8zbw/xXddmxiWJ0LlbUxa4bZC9jGZdm9qIxmf1EPnapJpqhY8T4pbX+0jW6fshYwZjbqwTCcmD0WQmiDU8U/PXvA3BPq68ooaQzCdxEXQVe6TFEMUuBuzaCMLjMahTxB39330deiEDVKBDcnpSIWxNgib8Kph1ip8c
 PKYRYWCc
 K8LKf+cVUfcQcTuEV+qA567AS/C6RmzrmqBIanOy3hnXVkzrVegmAVHnPb0coTZM5C8ufddwcP/tzrb64H0C8geCiwTSJd5UsZo0eCAL+SzunDsmWbRbsRFjfRar3fpo3rXW/R+uu63d7NZbN03KnF4ih68Rm4SlYX4El64OIrTvVESac+FsQCQ16N7QPOZE2q1H0tNf8H8jgbsxFXJpQXQu/kMBYe93IuuXYTDl+nIseN69kwKa3Hx/Du9nr1WBf1LxqOs8vcSDq9X/SdfX26Fe1lOprCcmkZhKRT+H6L7k2/VrtBwmkrWgU7OpHtAen9x1bXxpwA2eivbQnhPzRfTDNSA==
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


