Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52449CCA470
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 05:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF198E0006; Mon,  6 Oct 2025 01:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3789C8E0002; Mon,  6 Oct 2025 01:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28EA98E0006; Mon,  6 Oct 2025 01:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 105418E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 01:52:24 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A21D81DFF0A
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 05:52:23 +0000 (UTC)
X-FDA: 83966619366.14.C6BAAE3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id A95744000E
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 05:52:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759729942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=uahKAYRORPpd/MUcYlF5WIbYBpbd0kqP+eKR6J7JCvY=;
	b=5wRu6SYeYUvft0TtDszs/Y/TW5ubXXnl1WgIX1v6TamNADxkPcOfToJshfPei7vdyZSBui
	dIRXEchDfdxk+MSGfunD1CxUR8v2PAI6tiKA+UZozKGX+ZAG4Mmu8CsdVH8EH9/slTGnuZ
	vb2CyxuLMjLb/6JcfTZCAxh0wrI1I98=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759729942; a=rsa-sha256;
	cv=none;
	b=XmnYu77dgNKSON0ZT8ljVGnpmJXsqE3DO0416tfBaZLetM0lFXO/n2fmis8SRbjhlwU8wB
	XeOLGz03jys4meI/p8QA+hKeHifTBSxAtLzfoi0bZes+j/f1v4MJTU7Rk1Ce76YBDy2uRH
	In00KVLtRefMAaB18hhyWEr8Nf++cUE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8086C1424;
	Sun,  5 Oct 2025 22:52:12 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8B84B3F59E;
	Sun,  5 Oct 2025 22:52:19 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/dirty: Replace READ_ONCE() with pudp_get()
Date: Mon,  6 Oct 2025 06:52:14 +0100
Message-Id: <20251006055214.1845342-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A95744000E
X-Rspamd-Server: rspam05
X-Stat-Signature: y7iiqrw3uzaymfenifoxgxcrz16gucqu
X-Rspam-User: 
X-HE-Tag: 1759729941-482030
X-HE-Meta: U2FsdGVkX1/e/76h8yicpJYabREVaFVF8ccplTij4BL+jpx+Kl7BwPC2yL+KqGfYFM8rI1+bo7JzJq/NDPp8qnZkJIq7bguihj9gdV+wYPSAFDqlwVfXGwAnSzMUyAF3iRIpKIHu7llW9dngpeajZ7nX8d8ADFsUFq+9AjMqkrSZkYBg5ZR6d9bhFgvRozmO1F8M7hVcnc8/DLBWNtLWaCUgcEUxfSXTMcXh9KB0zzq8oIEnpIjDbOVEIqSlZWq3FI8xtEdy8Bigy8tMM9nBiXcF49B8ts/6QhqQgt1rLvHJIstTJacljRQoqQr7Agi1yMWKyxobGHvK8/+c6fV/NqOAdUjwFPECxLwB1+MNeqUobhDUbVhHF8XHV2gtfTd5qNLdnLR6aZKf50oagIPh0ErD6OoQ7Ed0hMIlhyCnQ0xkNwDz6RXyuTEfw30bMnWEvDS2oH9bWz338fzJFfVs9aV0awx19ka7CCf+TLLiT1RQl87X5tVDei23cC9hCTnRMbdM9YBALSUGK3i/1mvnvWoSI91knanQ3HMbg5ZJgpc83PMo4rRKVvTKqWyOQwrQb8K0qccY7yUN6IZ/H5RxLQgNr3/WO+ia3lplnBhANorBDSJjFd12oxmJ5dNgsCFqZfQXAwQrEMuCdzmWKZCbdijroRYciHnvpiLZR/kCsMRK1C6030v8KYDKbDVODEMZf4jfCk/VrFM8XJk/kzwVMQDl3bWau00pqdJ3q/N8g54jhAz0DsiYfRkgJpCkRFYWesA4BMKUE7yZESL0hS4YhPIgJ82lAK1o5eUB0zSiL0tqDx6FxHlyIrid6+SrNnLbuOW8NanqEcRDe5/Qvmu6IO3BThlfeR1r7ux8ARUp0K+ziQJjWMnyWWDPfdA2XLPQzlszkwUeyn5NBYY5Ovun0/UQBNYbhaosk2ZPxRaony/qMsTwOOv4f4ivqrmC2uIabUxXuqpVdac7WPXM7y5
 PtTjR20G
 zoi5ulLmjmzixY8pFuEiMp26vxs0Y5RJ3Xj0xV/1LshppQAsHq32gskwWFo/4CmfAitQxXgJKyYASVzbN1p9l7XackRXnAhov0evABqsYM3U+JJPGx8Rlnqofetze1OG9NJkVJKEKeVi8PMhlNtu7T8HyNF8szmNvJj3vqXTyyAXFukECvoNSJiZ5/RL7Un9e5f91g9wXLSuQShvUyRLmzoR7BxpxlwFyrOpMf6YrNMc+uVp8TbG5XqUj1gVDz2RYoAfsQEBEou69ei572zfaVIedI0zv4V2fGhzmeEZK8GUwa9uXycxVdeFdWaADX1TSbi6GB94lpexP+Kn1XZ/Qt/jXK5WPxX2dFbFfeg4WK9P4RdCBW5aFY4Vk5ozhQkIRwgjy/6WK5e3CNE5ca1gBbSqiIQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with a standard page table accessor i.e pudp_get() that
anyways defaults into READ_ONCE() in cases where platform does not override

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 mm/mapping_dirty_helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
index c193de6cb23a..737c407f4081 100644
--- a/mm/mapping_dirty_helpers.c
+++ b/mm/mapping_dirty_helpers.c
@@ -149,7 +149,7 @@ static int wp_clean_pud_entry(pud_t *pud, unsigned long addr, unsigned long end,
 			      struct mm_walk *walk)
 {
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
-	pud_t pudval = READ_ONCE(*pud);
+	pud_t pudval = pudp_get(pud);
 
 	/* Do not split a huge pud */
 	if (pud_trans_huge(pudval)) {
-- 
2.30.2


