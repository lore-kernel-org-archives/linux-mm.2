Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1FF6C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:44:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AB176B00A1; Mon, 14 Sep 2026 07:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 783916B00A2; Mon, 14 Sep 2026 07:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64BE56B00A3; Mon, 14 Sep 2026 07:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 418F06B00A1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:44:07 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9D22640328
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:06 +0000 (UTC)
X-FDA: 85212184092.30.59E535F
Received: from mta0.migadu.com (out-143.mta0.migadu.com [91.218.175.143])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1123180002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:04 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ONt0a/jw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386244;
	b=v/B7BcVE7rRZ4uyiJ8QoyUIxaa6QqmOtubKnSS2nhBnc9sYxmDAEDKUL8ncKlw1HS6Et6B
	xGPLt/qxi9ftSPm1YPNhxaogVziAzG0oalE0VB3BbpVPmqjlxcA3eTGDMS5FAYHkdokBbZ
	rvzjp+u06COfg1bwlr4I/68RxzYybko=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ONt0a/jw";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.143 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ysj8Nz0TxgJizntpD+sQRniXfRCVS9A1XjJ8jJcXck=;
	b=f242dSLXA8ZX7ab+7F8IHrpfBysa5bHf5hyxIGLvXALTuV09f5v5Xc6i8mUT10AWnK7lIN
	o6u1JrgxOwrQeJw/eddPIvlNQ2riInjWNQO+7G9f7gC7hAZFDSDMmeMOWSw7/iDTFqo4a/
	tcn5MW+GyjP3BMNtJoskIn08lj4xUUg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m3zofWqXNwwubO6EsHPEBwbDlkXPNebnA/BZT3Zr5yk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386243; v=1; x=1789991043;
 b=ONt0a/jw7tfJdUHOv6+2nLmRjfU0MWIU7IIKQLtddo5S6i9iYku/450AMUHftEs8PwfwR3Qs
 t7U+iQPx0ysvxdr7Xat267zTuybuJGd0kzybqbqXS6Q29lSUU7xLnsKCrxXvbv8GyuJb1L4HU2P
 5LieswihxSkgK85tRp2Hzrmc=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 91b9be05c6e28011;
	Mon, 14 Sep 2026 11:44:03 +0000
X-Mizu-Trace-ID: 91b9be05c6e28011
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
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Subject: [PATCH v7 07/29] x86: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:41:59 -0700
Message-ID: <20260914114320.12988-8-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C1123180002
X-Stat-Signature: jwyjek9wasrmhjr1u6kxz641urs3w9kk
X-HE-Tag: 1789386244-966256
X-HE-Meta: U2FsdGVkX18+q+eOUazYxIf3LScMWbkMZQLGvk0Jrnv6vWr5zJXo/3Hp09H6hTl4xGSwiNA3F++Y3DyWw2NaEzjZg7NbIlMv8fe47ZhflhT6HkCIH1V7ryB4X/ndf5N1m+oyazFNNYQcDNgaD7ZMJeugkFdBZi/lrwFLVDljhGqgXedefhD386mX9Tj8u0/1dlm5USq64BdwTXlR6L4AdaG+ABIRYBK98CcmZrV4/ce5OQVNnOIuhiJuY9o++NtEI8lnm8fddTWRLmrKp0OxpRAlSRTEeDoKPKIWx/OwRqBxdNGXckfnG3/A7sisAjfPHB44Iaj6RiEzVYiPi0F3YuCodC+FcKERxS4ORQ/8gGJOAVI/tibwuJM+nk9qCk3VFuCm+Vlg5nRUFL63gUJ1mFe/1ay7MKfHCGiehQx+AyKNPNB+FqlvJwpNzfzbclBoz2uG62J/tObjR7QjomD1Er3oBfvURRsQSr9EUF44hNoC98dgwhU2ntq+DJKjo+08bKue0wPTZ8WE172jusBvaQ8dCnhKtIcWhXxZpXN0HZDb6w+EW8/3BKF6aloP6yKjxwcDhDQYrM/kJrLjif0WLw/EtVWx2geCBwLEZe6bI0+VSp5ZSroEEy4xOqCGAgRa0DgZOEvGej/rpTuyC33irM+WlS1HdcyI58GtlOWhZFxxLKdzFf/B/zPyrnld+Ls7WBTvh1zoQJ+94Xs8A24/weuIZRXnmMiNd+c2elsViUsBIqpmU+FAWq+o/s2/4XZkNKPIqnvXMbI8T9d+QOnARJ0fMErnBNVVG5kJLDFo+7WkB4AteiOdmOlbvKu3zj7bfNGfJRS+oKOQGzJIUNwFPYquVvY+WWU6VLr5NazKkXmx41/6pCAze0QzuNRxH8i9E4ja+5qNFcf70ZuTNpx804Vdy9sJcppI9LOeDwUm6MUKXS+l+SGX5BW8XLa+9DaNigSFzwC8TUgl0BDKNt/
 faSOFW2y
 cJhT3cf/gIzhz0pgEo/C50iJBaMGPJRcr/ZIzExtob1fSbA0vcgcGbYp4whFusaYoD5BDeajc/sjpj+zKadxxudHL43MhR6aqmsxuLW19P1qpVz/ERec3vZRQq6fXHH8i11G+RAV5EtrHTMLm+bKL+SPEOc0ShOYAgTP5LfnlLhjEdbejVvIhE90W/jOsBOHm/U+p9HypuUtkO2Rv0pb6JltRDV7pUfw4a3hIcz1fS1Bjn14vhtar3U915E2u8tRwyiwqNS9DOLBy/xji/gzw9+bbkXE9VkALE92YUBHGtj0h8HI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
_PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
not select ARCH_HAS_PMD_SOFTLEAVES.

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/x86/include/asm/pgtable.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d551120a7c889..a2d1cd03cba23 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1525,6 +1525,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
-- 
2.53.0-Meta


