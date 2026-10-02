Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CEF7CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 759736B0096; Fri,  2 Oct 2026 05:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E24D6B0098; Fri,  2 Oct 2026 05:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D2CA6B0099; Fri,  2 Oct 2026 05:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 341866B0096
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:55:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A93B4A064B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:55:54 +0000 (UTC)
X-FDA: 85277229828.24.1F9F0F3
Received: from mta0.migadu.com (out-215.mta0.migadu.com [91.218.175.215])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7EFEC0002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:55:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v5WfznAb;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kg7RATEU3iTV967eFclOCt5OEfbQzumxKJdXP7l2Uxg=;
	b=U+W7PqitRaqVk3B5z2bETsORwGOa/zllyV3z9p/QFMnPFaax1bVvBdepL2RM3X5CRePU6p
	VbfiSBseWy6D2jmnEaETKjYMWQWV+PA7fbg3NO3rT5Vxp/ZeAzkZOQ0tQezHBj1tvAtxzS
	RJN/nE4sz0XZhfT0sVXsfuXoonbLEKY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=v5WfznAb;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.215 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934953;
	b=iAjZLfv+kdCa/Ge+x0/TWsg/OlsNCGtuwZee6B6Diftmn2/Zo3qms8OVd11F4UdHV4gkGT
	aBsb2zVp3AzYvsOR5731rwXuyqZpYpH3iaY9usGrqWRLJOwYhJgc0Zr+i2JLaLbTtm4fFW
	XMfbprtwqyMGh20467y+mmcNiXgqw54=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pbTbkeINEId7JS6AnzSLx3O1ncG52KDn9IhrFLfOFTg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934951; v=1; x=1791539751;
 b=v5WfznAbhAes7HSxgjxVB9oJXmKscMBH41tsKUgnkOB2td9u3AxnomXR4jsFDLnRSswAweOe
 x83gbdD5oEpLPzTjaFGndfk4hsgXKyYgvuf1kvIc+hDpLvY0zlv8800vy87H9rra/fHI3iAWVt/
 0xS9L8li52R6R/Z8VPibC1DA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id f75483ed85d9eab5;
	Fri, 02 Oct 2026 09:55:51 +0000
X-Mizu-Trace-ID: f75483ed85d9eab5
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
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
	Usama Arif <usama.arif@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v8 02/30] arm64: mm: add PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:16 -0700
Message-ID: <20261002095503.3585565-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C7EFEC0002
X-Rspam-User: 
X-Stat-Signature: nfpn1zspb76w1d6bisff1j5epdf34km9
X-HE-Tag: 1790934952-151499
X-HE-Meta: U2FsdGVkX1+3OuUa4fYE3tF/wk6trQZf/GyLL9UTpg1Mo1nlV0Uw3uEKusImvUDTRiE2874EbhMwNBiVKyL/5YvIdoqToGX1x7HrONWbe84AQlqE6r7HN5GkM2QkmJeHBu+wEuvjyj0eI4udu5OYETWKNnpPf45cMfQrgybnsMg/sndBAZrFElNzFcr9fXkZEvh2F6nrrwydKim8nA0ya4IUgYZhiNAlrMqu3RYHYwXNy6IohxDNcVfrGdbnx7pAbdoPKvgUKtg2PB/PmGCg1M4/2Kso1uOshtUJkIT/KF1ialrMlYhZU23Y57ulEeeVZhfFC0Ys0mbQuZYXiMG+Z25/NWVkS2oIoIb7+qT88/XbUXz56smYqedXtIbYbXP/N6co3kXMSg8g1FWutYgydm/mQJ7Wxr3IsDV7Q3CwF18YvWt8EnIbt1XO3bLiPw8V44DN7ldjR0xRO7MPwx02pXyXvUL3gYQnz5c9Z8AV2SN1IB1B9jIIHpzj5sT0nAHAkGAGiO7qOEgKpLapsxPd5qZTS1ka1dt/vtZ71M4EtU9PTvpSE6FF6W3CiHsqLIapP7VfkBf4jDmjepsYYjQvGnyQCL+GsM/ZhjRJl1JkQYyXdlhHnJVClpVyYLHJq/1ebyNVTGcF4I/4Y/ah9GDviZgToeM3EdEA3FUi1yJFasSRXaBqlpu55JUeCEy+PsvJTq0lWHT2tBXkpNB3cEohvty6hxHL9b8tGh4l+SXvlZw7hehdJrIBlcv8cKEC8ObfjaJR3GhsRFLRqRpKuoV61zG6bqhMQ6hWCNAsYP4oKKkkV+32LOQwkkxR1h5egZKANUzNPeJW0fpylRn9gYVSjXYIKmGsWV7FLJE3aDd3IsW/cx8svGbkQlerBHLTnO4nxtxHo0R9/bk3Quwhfrgt268mkXHKLBGnKtVoO1r5QRzkjn9XCN90y0eBRPpaXVfsrGEJl5yku9WbVVNBl8S
 bqTx61Wu
 gJT6P9qBh4SbEesY0p942q1IvZYcefRnQd2GTkmFm+JMAkxwazx0jznC9FLtIuASkQK/paNYHsnH3vfydLd9BPJFYFJXVrCIPc2P2rHqf9Al+hIBVvDxxqlyC87rnBYyPsYgO9ve3si7bj2EDPKlEXeiXiBHoFyxopt9C7jLCTSgO3AXlw0Osy9bXJ+O5/65GfQHMd2v4xX6I5UxP04dCoGm13IOlTQqSXAKCDEK9103t7ltNXJ4ALXtUPKY05qY5I2u5vhMvXj2k0mXIA0nV7vJg6O98W+u260fGLHqJAIH/6vM2Bo0t0iruut7xMACYeKj5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse PTE_SWP_EXCLUSIVE.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b4..d3f53a601aed3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -599,6 +599,12 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_swp_clear_uffd(pmd) \
 				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_clear_exclusive(pmd) \
+				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
+#endif
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
-- 
2.53.0-Meta


