Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4DF13CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33ACC6B00A2; Fri,  2 Oct 2026 05:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4DA6B00A4; Fri,  2 Oct 2026 05:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BDB6B00A5; Fri,  2 Oct 2026 05:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E9A3A6B00A2
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84BED1C37BB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:21 +0000 (UTC)
X-FDA: 85277230962.17.79C5A96
Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	by imf12.hostedemail.com (Postfix) with ESMTP id A17B740007
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SCdvevtt;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.146 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ews1tcPU1C/NlntziaPUTeGhdvmErQF+8+JFxNRb0j8=;
	b=4flIIMeTTcvWGoYp3C7crcIgiV9vOtxeufE3eA4bC2a7dHw2yRV4tfaIrJ6xJnZ7uCbTcQ
	4NnSRrKWACkhtuj0N0kXQseuPEDVodiGPW8LcozteXZA+fJpnfliY29LEsnYMqymkPmq4y
	orPq7toERQYu6zs7LHROHEwsj/iu0x4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934979;
	b=0QNqIFBbpifHct9H2l9Z/FhlBWk+bvPh1ytBP6FKIRZEFrNMvzYsYJnD6i9/jSwBVM6Zvi
	8iQcWoC5i8Sr6UG8DN2TAfRK+CLQb2u6Awm2Msw7q3VrUIWcAWVCE3md8nbp4MepQxE+Xp
	086Nop5iQ1Vm37JFxGwF9ONEG5HrzwY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SCdvevtt;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.146 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xqdIzLB/9KznEhopQquMssJDqyXlY4vTk76sJe/wA9s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934978; v=1; x=1791539778;
 b=SCdvevttvzgw/8nriyFT50wVEiiFuaAlmo0i46b4D03U90Hn02Ig8OPvNR2WzzUn5pdOvkr+
 qMYQ0n621IrIf+lASnj6mDbpf5FxTB5Mi2WEa45aa6gGXGTTOUW4To+pf8ZDZAsyHs72wfvRYN1
 /O8zLgAL2uXydSuXZT2UG61Y=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id af85c43b694ca49b;
	Fri, 02 Oct 2026 09:56:18 +0000
X-Mizu-Trace-ID: af85c43b694ca49b
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
Subject: [PATCH v8 07/30] x86: mm: add PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:21 -0700
Message-ID: <20261002095503.3585565-8-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: a7thi94nrze1tssyq3pieqbwmywtiqpr
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A17B740007
X-HE-Tag: 1790934979-264958
X-HE-Meta: U2FsdGVkX18/sIHTZO2wU7ldIkYAihhv1oh2seE8iZaVNQ73C10V5Q0n9naI6srGHAvP5CcWAwYEq1UmOX29PI6JahqEpJGHwNBkSboI2jp7z24n4/olWnenuH5p560ftV9V4reUsbzuX2zjBYlgHUAGlaxC8ZGkvwv3anZHdebaag3B4nOGHg+M/f6vG6IBK2G0HYK38gaa01f1aq+fF+0U0ub9FZWvERh5Z5vn16B4cmZ/kVTnaLo6H4qdp4lI6EJmpTlLTQtdbvsHzuYkbf1mjrmU+BQ3UPXr/z9cnZuDeEogLIvp/R1CIABJsGFsb4bi7pKxm0u2zbxUeZv25dcwoNNDiLhp11gzt7h5UBBLtLM+I3MfnGnJgq8ggnhzUW7wDHtWeqNHrNj6NYbnXR26vQXn6oJ0AtmqA4v86P72oPn/JfhxN4LNUds97dNQ+6UfdgJmR8DNE9cGQBkWY4uMry2I46irqXM40fMZU5+n8/UCqlzBCw+qKr+MdY7urrLK+8TPqcKgnRpfWRNefOkO/NEuuodjUe0BrRGHMRZPce5xtWdNQdCkraoFThcPWIdZ3oE2+rVasggz6QAynkwV0VDP8Sz2Sg3wJpQl0QCrsRQvzFCxISP7xDcv6OlKznLUfG9wiyVgdO8EJULnz7SuhPPQPqQQIAQJDQ27le4hkDkAwI93G5+7ikGMl7A1Q6QUlAIF37rE4/ln459uMC0Oav4N78lqQ+PhUgq3N2IzQk1iwZFuWUdQvgvKOPyeTonm5zfJbYQAJfRX2ME0mUVirbn8a0NrgQaNE5mksITGSqOZ3h5kP5cK3AFBc2iWIOfnPpHqUQRZg0fu5kHmgLK3sZ4BTMVuton60RdTowI9wvBGycM6xMVCDD+5Eu5aLTyrWTs1cmsJE3ARQCIp1d9ONaEUKZLMPX+2ZPwrVcO8e1ctV4Ulbz/GDR1DJBr3ttfwKyQTogb5wB2ikAX
 7cmF9hRy
 4xYGeja2kuztY5y+hI7JQvJsA+vCucSwiWuhc87FaeHi29FiJVP7xcYIiRsQMolClokbGg5KvejELkPPMFO7AvAkogVSxMtD+NRHbhVejoaD0B7xTgJxnQsdDGE8Efxig8GoIl9ptA46vFx95o71NRSElxJIKR/rzIbyFLYuTQTIdMJf8o+HHBvCGX0EfJFd7A6EW/IiFZmOrezdRi5MSwiVwo+3fUuObE+NOdP906dvcmrSueO0gibfJsoJQKtqlsn7P0GTAq6rWSOrmAF3kxNBtEvhpl4uHC7yebceoIXq2zH0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
_PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
not select ARCH_HAS_PMD_SOFTLEAVES; assert that, because an exclusive swap
PMD would otherwise be pmd_present().

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/include/asm/pgtable.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index d551120a7c889..c35dfa6ceda05 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1525,6 +1525,26 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+/* 32-bit aliases this to _PAGE_PSE, making an exclusive swap PMD present. */
+static_assert(_PAGE_SWP_EXCLUSIVE != _PAGE_PSE);
+
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


