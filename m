Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC4AD74956
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 06:03:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50CAA6B008A; Fri, 19 Dec 2025 01:03:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485676B008C; Fri, 19 Dec 2025 01:03:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3305B6B0092; Fri, 19 Dec 2025 01:03:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 22C706B008A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 01:03:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C051F13AF79
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:11 +0000 (UTC)
X-FDA: 84235177782.04.01EF275
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 783B014000E
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 06:03:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fcM0br6c;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766124190; a=rsa-sha256;
	cv=none;
	b=bIjiI8y5O7XAA4OlGN2aNfnZI6RP08Oc2cXNtjs7WJs0ovlSieEB0DP98GLnST0B1LBaoN
	aZ4k7/kKHwdmgeeiXq/HU2RObgG0AeDxEdZL9Im/QXgXjoLcwES5NzWTHikhAGJ5h4ccIP
	8kuUfj0WLlLZlegGD5VnOTt1cH1Od+o=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=fcM0br6c;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766124190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx0gBasjhco1rzxEYEyLJsADnhZt08xD0/YXyn0KOfU=;
	b=O2cR3lEZQdJw/Vhan+gCTTI1gXxImoS1+IM4U3u+AbfVQtoeSWKNva4cd2r6hooMiPPcPX
	0Doinl28MiYInL3HTk/Rrc5+CVJpaYGmS2zWeEzu5odmd/PgS/elSgk1mYlYqiBy8Y5ucY
	+Z9+Rng8wYogGL9W4sc+82/dYWB4114=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766124186; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=cx0gBasjhco1rzxEYEyLJsADnhZt08xD0/YXyn0KOfU=;
	b=fcM0br6cy9jjFtYVQJu1/GrJIeIy8SBcvTOYSt7GMet7WEjcg2GNaFHp9zYQ7VGyOoMB5641JzWCDW8XThmvzWdtSaHOt0KOTQk8EMEE5h9jQodSWcp4X4XJDdtuDAIrtcwj1lF3sw6uEZ2EkAmGfk9O+LcEE5LOVb9DRZfVCmQ=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WvBV0.._1766124184 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 19 Dec 2025 14:03:05 +0800
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
Subject: [PATCH v3 2/5] arm64: mm: factor out the address and ptep alignment into a new helper
Date: Fri, 19 Dec 2025 14:02:52 +0800
Message-ID: <8606e13617bb8ec302806a6ebdbe5f680e4466a4.1766121341.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
References: <cover.1766121341.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 783B014000E
X-Stat-Signature: 8ssmox58ytkye3k9wet1g9osaogfypra
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766124189-503661
X-HE-Meta: U2FsdGVkX1/QqWK6kzj4O1bJ8g3NxACnlZXJ9QA6L10DCIKryOyPhga1MIMQEvcR2yr7JLSxZP5Iu2VSwXQwNybS47Dpe4MlgwMQD/rplr+IUS8WK2EP8udjeaHAEuYi6FPA0Pr5vYusTN2Qlv8uXQ/F7+CCrdVEvKXNjWsMKX1Wz9MWHspYCTTrwyidqKJLLZ8Q/i3OAAmadk3AmlK8gnCpuY3E4VUsbzXa6zbHYcgMR4Gk96WG609etA+2EmndE2acIGrgNvs0XDn6/ruNaacQaTJtvrr8+8GeULygdtXe355vnhT6rmjDDgpeIpEVjz5I2N+W/FyM3YWHHfnyhpdVoaEygQDfOkwFA/hINxCX5ZzbK7qPlhrfgrh3a7MCzd3H+J6aDfOqGZp9fp13DJNENpnjT65ouEKVQ4mt6L8Tnf3ES8TcS1XAN/4e8xlfSW2qDuScsgGc7GqTZhVSlyyGB10H9c5mF+dDOIsj36AkaJFNmQIHVExkHmcWtWkX9Oyg6E3TpR9jGQy2bJRTuci1Fms9SMbDWJ60za1rgnotWE9qXXlnLBaeDT0/pVOLG8feJgzb1nlZQVROE3lTzm7AhC6zczaOQsj/CtXpsOMfd1G9TAJ/ZPWPKl7eH0HQZehN23W1SqoR7TOIkjWu+fZHVwAE8u3yld5UDo4r9AFSjaM01SLG4a+T9YYbSqUoSKDFAnrNJI+mV58X4EpdPXm684o1cvffCYPODvq/ubzbZ6XTv6+axqqptL6eZF7Dro0nqi7qR69TAxjpAH/czpnTjnbAkzqNlgjGXQj6BClsg7LBLUh/Xrqc0oY3gFzppPE9OZRPlFAGxjn3PUjhzzWx71tx2PruMp70Y0I7uhKkVUMmQzxeVACbJ55oQpasQ4RizOU2DzpvCo9SKUvLA0Z29ZV3RItrYa40Abat/8XgmbGnbNNhmFIiv4tH94H1xRIC2gGwedkpWR3B4KQ
 FVCp8DLP
 OPOi7+S+IfJ/oOyAYWC+MIUW5UeUU7OlzQcw3eNMhEeWR29/gaf/ZNCL91/XgJj4yQYQDhhEamWrwJIsTOLE5nk3O/zsn3tZDFELyDoKzGIhGjhnuiNGqcycqG74fhGS10LCGtbuzyB0Is8qVOZIQsiedET4sCANNV5tsLNr4nuYDcsX293HDYlobgXokkAwFUyXC7CO0D0eFq73K4iV0Oh+njUisdZuNA94r9DZ5d/sEmrFimtFuZ249OHmGbI8ZKe4ot6q682Utf3xKoZPYedQT1Q==
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

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 arch/arm64/mm/contpte.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index c0557945939c..c73e77207584 100644
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


