Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649AFC3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC066B0099; Wed, 14 Oct 2026 13:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B3D56B009B; Wed, 14 Oct 2026 13:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C9046B009D; Wed, 14 Oct 2026 13:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0F12E6B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 98D29406BF
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:11:59 +0000 (UTC)
X-FDA: 85321874358.03.219C3B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 87B104000C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:11:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B52EDJpw;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997917;
	b=m9ja20P6SwOpBeMZ1e35iHFpKUwbK9p3rszbObarTYBCsGWk6NZj6MT+gLNmO3X2Y/pLqm
	qLBbD+TJLttK64AxIbrWGSeROzNIoZQ9RV9ljJeqoyhXFFDQYmdbuYyXTuMEGxujihcg8o
	bDsfQRKkeFf955jw6gmok2kWJFyyAdc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B52EDJpw;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z72p5BWjexN9LWvGlQWUign7ZbWPllv7B7iJ/RtJe8Y=;
	b=jvXGWCHVXlvzUIR1/LzhTLBlfEqxM0TnoOZGDLtzPRGXeFr4d7UULO4bQDWnhenWwRsRe6
	eiabL24CHWFed8/qjLbrR0bBg0FsIBG6KtwBNejjBPgUcQggg474tSVjCX9ZFESWiQCHer
	c/9m8gkyX6fiMbh858BkOTTkCLjhOGo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB69641FB0;
	Wed, 14 Oct 2026 17:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E7A1F000C6;
	Wed, 14 Oct 2026 17:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997916;
	bh=z72p5BWjexN9LWvGlQWUign7ZbWPllv7B7iJ/RtJe8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B52EDJpwUQlIverE2mDwtvzbVCyO9Er0uohM31HsB7Gqk99ZhYLH0+qKEuRU60S93
	 t0QE/EWqGNBh6mOEroq3S0FX301arOCcsi3moCuCypL0g8zRqdArHS4TvZFM7IhbUN
	 vgU4xalfs+tIbSITSnkU/tMqf4xxnnpqHaWY4QcezNNADkcbbr1msOWRo//1POvxzS
	 mMJYJeciuJlwSlZboZerZMcN1ySUs1KEQGBTRFrPOFH6FQWZYWk4CLetV1eiY1Jaw1
	 TaKgwAUY406FpoFwvaMWE5Oo1JJfeCqMRQlhLkK7eEs70TgIobW/uw3mEoOrUwYTVD
	 PVP5moQCBHOJQ==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.ams.internal (Postfix) with ESMTP id 712B91980047;
	Wed, 14 Oct 2026 13:11:52 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Wed, 14 Oct 2026 13:11:53 -0400
X-ME-Sender: <xms:17fPahIPYFdyIrN7LiLk-eKQcYobcsgv5zFJNrOSv8-_GeLeWDmMWw>
    <xme:17fPapFVTUvCwfxdU1OEMLp4MOepX7eYJg17vjAp3oT8lM0Q3dXxkpd2zGOjbR0Ua
    WhUwYvq8ujxfBuUWwnKEI0YUBtPGX7zlI0TwC8OqZP0xcMRZOacOPwq>
X-ME-Received: <xmr:17fPav1QW-1YD5zSYe9gDn0ljcunV45CK0H3nF_7tbdH7FYs8JRBtzSRiBk>
X-ME-Proxy-Cause: dmFkZTFAhxxCN9RZF7RgZjl+zblwyI5MNEPViosmoopuImm91zea8n//qrkhNFSUiWcXrp
    MH3eAot5Fj3DZ6VPT64I9vPg0QCUCtDiiTqiv8NQX359J2cSSSZjsC/tyd/Imi5LGIf6hL
    s8CbCEIaBNMBcUHGn/aH82L6PPlafquguz3Z2sEDXsDmuHj2yqTheZQ+fxDOXfR22hlOrP
    qRQ5NbmvpkXKG3iXKhgkLsRulP4SRlPxiR6IgNv5RFr6apIBiGIzyDvrozd15QkLVz/8fH
    sBuTJDigvLKTgofLjjaL63tWUe5PXp+yZe8Mz9HWr0e1U2Y281/CsnjjHOQDfmMGadQRUg
    pAZG9CX41VOb+dJ7FUXXLIWv28rqw53/CzYO0t4sG9QhTxVFYR7ioojtod96QdmPsLI6S+
    /yuC6DKHFAkkVo1dm797f+79GKuHHw5iyVgTb/UmL/ZFNGwo9WYeLO9J+AcZ55ozmMlUhW
    xBN2srExtcBdm5VyGPBPjjtZsoiRcFm2GKOVMrJlY78vOa+AWJwGqo280gfIZTskIvc28W
    +ec1xjiTqckyFHLrns+4PIMArZRsorFUr9Q8+7Y7+H3JWuQSHTsBL0qICydbwE0j2s7OF8
    mjTBv+VGbKDJ43IPl6QVeufSKSjksxivx1MXKIvxZkvECUejjHXIYQVkNxhA
X-ME-Proxy: <xmx:17fPaoyihkzWq1B6K2j1BgVfJajthRRaRKei7bmP3J8-W0dCEJFZ9w>
    <xmx:17fPamiwLNlYH8VxoJ4P86oNsyJ1X6GR4xzTCD_TCttDoTaldSj0NQ>
    <xmx:17fPavwnjQs2UTPn5ZWeA3_k_F-HKhczu8Se7_2kWudNcGY1C8Xb0A>
    <xmx:17fPasyN9WvpbHg8ucSS1fvQMumZcwyXhLAHjGts3Ogbf_K1Kmc-Fg>
    <xmx:2LfPaho_HZev6AXWwURszDmLuKs_iuMDWo-RGYrigyNRyDlKvmw9F32y>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:11:51 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 1/9] mm/khugepaged: drop redundant mm_struct pin in madvise_collapse()
Date: Wed, 14 Oct 2026 18:11:34 +0100
Message-ID: <20261014171145.3292736-2-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87B104000C
X-Stat-Signature: 61qocyyu8cc7urmt4gnuomfjihaqw5xg
X-HE-Tag: 1791997917-111039
X-HE-Meta: U2FsdGVkX18AjNnEoCTOmgTHljtSOoYFyC2GtCMu9l9paaW4TSZG3WcFao3W6vvBb3yn1v5LZzWyidUFv4WN/SVqXuqgsinFhbJ19yBGE5jZYDHAJurCx4iirXL8/TpGaZ9rwqhvlDUnRM/SgS4+5NShhhIIbYvMt+Zq21PGu5afCfY3Wvw4BPa4HwVNGY1M6mrpAACmtc/JcPHFH62pgjl8aHbsAk00ViZJi8EuQmt8LiJPBI5WcpbrAWVsPZDpYwdVzVN4T2acbce5OSdSZSAx4zuhF1htNKC2McyyUxwCaQ1Zro53MQBcNFyPQt/WD3nPH/fPni7z8T6nWQW+XJhu8A57mbrhu/m7Gs3clKmr0Y9uWWK001ALu02bC3F6y2fT52CmA4aYnnhT1zqt6cVr5/mmzBc2hxTyVWjdLx1MIYn43j+ak0LOMHnfK79xcn0UYNp4h4+rtONGbKNLVB5PgpDoRDqtXpjyOBM1+YKGZ83RFquZVeIGEEjLdoAufFlkRWenx8a4LoL40YrhphglXYLURAEJ9DKuLaFAXAJ0mcWsJrKOrzQgjppNDAtFoOkdGWGk/HDbb5dcSTdHO2oQl6Uir9UDvgGVPlvXTsSmjVz2/hcuUz/D7QRLR/akn4SAP4o7CDTzmxYUvnuzdIHKEr2S8SAxWhi0Bg1N5vFJIfUbzQhYN97tgNmuxdfO6HXHP9/gDPRUE8KxUxMCbGgsUvVpzVcID8rNh6VkQge86r57Vychle926qH9v41qsIpS3gGE0K/Lo36G5gyV2MdVjHmvbNagV//u171q0jqyxvWbEH9qjB8RvU/e9AyMVZTG1ogALhMM6INhWWpZmlIlzpR6p2TGa3pT+R1bqKJ3XZpv0372W2/N8Rzvqxg+QnEy3qj8a9j8dusoO87Hv6n9EpT5i9vqSRX1gcv5iPiDhY7IHAjCZA8XlXQoFyAEgJ+O/RXpxGpEs2+f7Hx
 Qtz5jpOO
 sC/6+bjs4dJteN+8F1aPRTlZDf6WuyGPNcDOnux35IDzoz3MLKhs8ukwQ0GFVT8xbsJbmkLxAxqrtw3D3hA6LESFiH19Dq9v3n6FxGsYVZsFCd8oqLptMAJtoJFug7/ep7QyCoKzK5eqjRVDkvIilPf0cAhxOQ8YyZPFIQz73C+lYEicZmB4RTMMLgXbxiMcojeT7Cp1lpEOw/8Fe57DKHIdcReeQEZa2r6qb8xc15AZZroZpOlqDU+u85trpszJ/hNjz8llqLY0xhn2A8/xSGzOqnH6HOO91ZKRcclQeofMLS/WfwOVIFaerxiQkTMYquPFTi6U5j8Wsba814QNiyCdChKKoW5I3N20h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_collapse() holds an mmgrab() reference across its work. It is
redundant. Every caller already holds mm_users:

 - madvise(2) works on current->mm, which lives as long as the task is in
   the syscall;
 - process_madvise(2) reaches a remote mm through mm_access(), which takes
   an mm_users reference and holds it until the syscall returns;
 - io_uring passes current->mm;
 - DAMON takes one with get_task_mm() and drops it after the call.

Drop the mmgrab()/mmdrop() pair.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e13d233b9967..75c876acf527 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -3229,7 +3229,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc->is_khugepaged = false;
 	cc->progress = 0;
 
-	mmgrab(mm);
 	lru_add_drain_all();
 
 	for (addr = hstart; addr < hend; addr += HPAGE_PMD_SIZE) {
@@ -3285,7 +3284,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	}
 out_nolock:
 	mmap_assert_locked(mm);
-	mmdrop(mm);
 	kfree(cc);
 
 	return thps == ((hend - hstart) >> HPAGE_PMD_SHIFT) ? 0
-- 
2.54.0


