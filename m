Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10D0E606A699
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jpOHDK1p
Received: by kanga.kvack.org (Postfix)
	id 2A3E46B05BF; Thu, 26 Nov 2026 06:15:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 254F36B05C0; Thu, 26 Nov 2026 06:15:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 143C76B05C1; Thu, 26 Nov 2026 06:15:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2D706B05BF
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:15:34 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C3518047C
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:34 +0000 (UTC)
X-FDA: 85477014588.27.B27C02E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 819A112000A
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:15:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpOHDK1p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691732;
	b=QL0G9XzKSQM389aQsXzlejBDjoqcYVK66qGM4syydz1Jxg/+t/W7t5YHvcK517obhKJMzY
	myurDS4lFwdt7t5SPJCjROMShV0OPpKynaSlY4YmP8HtUdVfpk46nA5Fuu+IfLviM3OVsN
	xu0bnsKa3H+FG0Cs1yLUdQ67D9h4xOY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zeebKmC4zt9ER//cYViWMCf8JsX3wxI4858CYnYyK4Y=;
	b=n3Z1EfLktLjOAB3/5phQcIAnWHvCcKf+4bKWg3ww1bv85eUS94PGEiKsVf+sd4/o+9b3dn
	AMPe9Xc8AkVZ4GpsGdKU5EKnCrjrPZrkHc6F8ZCDsY3clcr6WBHxO5J/tJ6VmsBvvvm8hN
	LGe0C/jit6qbmDuJf0uaEw9Gromh/kg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jpOHDK1p;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1EC5362207;
	Thu, 26 Nov 2026 11:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09C61F000D2;
	Thu, 26 Nov 2026 11:15:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691731;
	bh=zeebKmC4zt9ER//cYViWMCf8JsX3wxI4858CYnYyK4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jpOHDK1p/+2ScS6pTVO+ve0hzKh3+qSBP1nb5Vo1QtiyTil/tUQdCXZMRsYDRurOy
	 nMF/zy+gS4188OPxfP1dbbUtm+m7Mbb3agYHHWCFSW/9xowa+DkAE83MKuY9hDAkqA
	 ItEVaA3iu0i8LkNX5qaBFoxmSBaMSJa5GjeFeFbHrDP1yDt7Xa8NpovnofVLg6cOXu
	 bNWOrmmtPlvK3xASh9BYQyxFxh9UZ6m9Q/FzKh+Tf+65DDVfs6EAdM5wsnWYU8bmLp
	 xbkIwTMBdgKK2iqJ7731qo0G/kIPc14YdSl9AIEpGPAuz1H6cnQpuM/SzPPuBFjms7
	 Wg91I2Upldwwg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:19 +0200
Subject: [PATCH RFC v2 06/54] x86/mm/pat: don't count kernel image splits
 as direct map splits
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-6-723f1e33c3d8@kernel.org>
References: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
In-Reply-To: <20261126-generic-set-memory-v0-1-v2-0-723f1e33c3d8@kernel.org>
To: linux-mm@kvack.org
Cc: =?utf-8?q?Adrian_Barna=C5=9B?= <abarnas@google.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Borislav Petkov <bp@alien8.de>, Brendan Jackman <brendan.jackman@linux.dev>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, 
 Mike Rapoport <rppt@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>, 
 Paul Walmsley <pjw@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Russell King <linux@armlinux.org.uk>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, linux-arch@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16.1-dev
X-Rspamd-Queue-Id: 819A112000A
X-Stat-Signature: sow3ochmyg7n8sg4h6nx7cjisyxy47k7
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795691732-557841
X-HE-Meta: U2FsdGVkX18GPp7tWfHkFkVX+7MraYAQxuBD470Nc2wUoRP5x6KnO3ZXmA104SZnPGgrilb/cxIjKUoy+WwEUhWZuvYvwgBQfEXvF+2xFtSL0Gu7MUDOmPqE1Zw3WQx2jLtZPTJJ6eYQh1L3dlIn2ARnfNRtR8D1dBQK+2+IXduKpiKNfNdn2RwgB5CGEiNm87RYrEzrKZjMfDNoXI+TV03kzsuNkYrL1JYW2tujz0WmPRCOqBgfX+YY9KrLOQvCMAfpKDxLOxUTzr+YsSyp8dZRbefpO6Y2yk+MDmGHmwLNcIZLNTBSP/F1xfdW5nM4Fkmb6AHsIZKbJQ5Z6CFlusYZdYf3/PBEv9ee1qrS/5thB1FeIqZuPqFBhgCSqlACE9ubPw9Fx2HytTeLICuTF8SrJelWdn/lTgw2KL8roX3OS/dCsRMGsR0dFlTVTwRJvF7SFEkZhGgEnkFh4BTRrd8hdf3E91k2N+8327TMDYciBXN+TRvN1yJsl+7cAcomHh/s9l3U3Rk/2890u8JFz+Q3j5oSYPVrx6nTlDZvNyKSBrDrKkBIAxT2EkmHw31GEe+uaS11RXKRDTGn4nVewuZ0T7FmOT51CTANKnH9O7I0W1wjDyICUXEASWvsdZFe4mbMvFC54zEdHprBh/whf2jkhFaV6ThhJcM7JWD5GhYwO0ONKT4ME5cC/ZmVZ5c63J1TNSdmuL+d8gMOalm+50iL1ktrpO9zvJ/O0xXYt8iUimR5oT7wW8A1RMjusilJjjG0uHV0OI4tw9+dVRaK/9Gte/NZjDYStQ5b94vflJISYJqgfv5cLferEVc3qEYSFwu2Ru+RzX+ZDc9WI9psdle8RtN3huo3xF7EIAd6zQXwOI4KLbfJX1J56osl/DxvQH4TKg9UeiMnQsupKE+hEyF2/zPWmUhhfHDvs2XBVXOuw1HsXkaEEg8CTzZSx/RbXC1Jbv69gy9FCq6rMYd
 PpEb5IOM
 hIoiYYBbr8NXnuPbNTehYWtRlbLUOMB6XNKDB4ZktbZDXzF++h2S2CnCDlRDtSONDP2mFgCTLxd6D2aQwbPxpV/Gowev+ps/9X6aW5V3IMX66Sgoi7bvI69FitNup4SYtFIe8UEskOaBxdk9adQYfXrOCmJWkcXKHhl0AM1eRUdUkL/H1LwYzbAYPRz76UnZqinoXdnCZZOYErdFdU8HLzTFkT2yXVG0DsFiMKuEbWufP7CXkzHQg45sIP7D4a1WMjJfoKpcVb3/SesGARmOc8eh4eQ8tEU6QHvWNA00PT4hH6H47lmiw+OatNCAPJ5x1j5DNJKpnL2o13VCTiVo/5uf86+QQ5xOiKePtZ7JA/IaSg4sNKhmQcIevFAPWIxJoMKF8EtwdLe2ePtPd9xnD1Z0NG5kQ7in4OHQYqloR2U3WUJHhIsAPdd3/XVYhG/w2h7TrSMRo+kC+kDhh37AGhoUoGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The DirectMap lines of /proc/meminfo count only the direct map. The kernel
image mapping is never added to them.

CPA counts a split if virt_addr_valid() accepts the address and its pfn is
mapped in the direct map. On 64-bit virt_addr_valid() accepts the kernel
image mapping too, and its pfns are in the direct map, so the splits of the
kernel image mapping are counted as well.

Such splits can happen when mark_rodata_ro() updates the protections of the
kernel image.

Each split of the kernel image mapping moves 2M from DirectMap2M to
DirectMap4k, although the direct map does not change.

Count splits and collapses only for addresses in the direct map.

Fixes: 8eb5779f6b9c ("x86, mm: use pfn_range_is_mapped() with CPA")
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 2ff37ff1cecd..42f27d60adf3 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -1190,12 +1190,9 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	for (i = 0; i < PTRS_PER_PTE; i++, pfn += pfninc, lpaddr += lpinc)
 		split_set_pte(cpa, pbase + i, pfn, ref_prot, lpaddr, lpinc);
 
-	if (virt_addr_valid(address)) {
-		unsigned long pfn = PFN_DOWN(__pa(address));
-
-		if (pfn_range_is_mapped(pfn, pfn + 1))
-			split_page_count(level);
-	}
+	if (within(address, PAGE_OFFSET,
+		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
+		split_page_count(level);
 
 	/*
 	 * Install the new, split up pagetable.
@@ -1314,7 +1311,8 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 		}
 	}
 
-	if (virt_addr_valid(addr) && pfn_range_is_mapped(pfn, pfn + 1))
+	if (within(addr, PAGE_OFFSET,
+		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
 		collapse_page_count(PG_LEVEL_2M);
 
 	return 1;
@@ -1361,7 +1359,8 @@ static int collapse_pud_page(pud_t *pud, unsigned long addr,
 	list_add(&page_ptdesc(pud_page(*pud))->pt_list, pgtables);
 	set_pud(pud, pfn_pud(pfn, pmd_pgprot(first)));
 
-	if (virt_addr_valid(addr) && pfn_range_is_mapped(pfn, pfn + 1))
+	if (within(addr, PAGE_OFFSET,
+		   PAGE_OFFSET + (max_pfn_mapped << PAGE_SHIFT)))
 		collapse_page_count(PG_LEVEL_1G);
 
 	return 1;

-- 
2.53.0


