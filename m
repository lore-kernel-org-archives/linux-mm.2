Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECBD606A321
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 11:16:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C6JaML8N
Received: by kanga.kvack.org (Postfix)
	id C92186B05CC; Thu, 26 Nov 2026 06:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C42786B05CE; Thu, 26 Nov 2026 06:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31B46B05CF; Thu, 26 Nov 2026 06:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7E6E66B05CC
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 06:16:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10F9A1C26B7
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:50 +0000 (UTC)
X-FDA: 85477017780.30.F6F41D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 735511C0011
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 11:16:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6JaML8N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795691808;
	b=C8M7Jz6v2tv0oxukn4GV4sJZVycNkqjbM+/jLuZy/tiCfYbiJRVm5maov1t0gJjiRrRu3e
	CRsmVq95Pf6eJo/FscrfrrB3Jnkc+9dDGPZ4gfQnsvuM2/7RSoOhi+jOvO3RkPN4Hj+9JO
	fFqvgdwLBaf29yUQSblwdqOSBf2rO0k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795691808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ia0IpFMuZ2KgIGlhSeCcR6ahLTVFLFvimBCAHBa8K7A=;
	b=L2yK6MuKWB82iPrBlK3tnoWhMl6wKC6Y9iLPvRafhU8p0hZ94Y2NhFU6ElZXQlvXMm64ki
	yEfeR/0adZJJqvd5mdexLCM0RFXTIW746lhDuJJopSIUk1vAJadu6tvzfuk1xVSRIWmbFE
	GSIWdSM2+DErvL5hHlWhGVyQ4EoUHlE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C6JaML8N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0DDCD62BFE;
	Thu, 26 Nov 2026 11:16:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEB7F1F000C0;
	Thu, 26 Nov 2026 11:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795691807;
	bh=ia0IpFMuZ2KgIGlhSeCcR6ahLTVFLFvimBCAHBa8K7A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C6JaML8N2aNTeIzENf2nvr8+aQgkt9RA0b/lUdY93mcchmhUi11+e2a0tScZ3CniC
	 QcRTPjB5Vvm2IKDrI4w2dr9YP7aKd6XiEFEQSWgHsN3oqfBPSbyJh4msiz7bJhFJnY
	 iHdEmk5VqDZ48vtOq9/cNB+6cQtOxm6d8cwlsfOe1vf3GC7TxG6ITRc00G6AjGH+kS
	 B1xDuZEPBtfEFIxDXf4DYfMJfU9pqQnNKwdDbA+opSwvI0DnVrHPn5m+cXAEC5semk
	 KHjBJ98o8aoZmxj2R6CX3JQmkDMDMQuLboY0NzWq2S7adY5QVhdyX0S7Rlpx6YLmpG
	 3SAUQuPMNGeGg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 26 Nov 2026 13:14:27 +0200
Subject: [PATCH RFC v2 14/54] x86/mm/pat: take pgd_lock only around the
 pgd_list walks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261126-generic-set-memory-v0-1-v2-14-723f1e33c3d8@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 735511C0011
X-Rspam-User:
X-Stat-Signature: 8kojpmxdo1i9xxch7yubhrbwq8n5wgsh
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795691808-222771
X-HE-Meta: U2FsdGVkX1/fVsf1F9ZUqJA0QM6OOXpf669YA6/9oaQx6sWjPkWoqXB54JuKobQz/q09Mh8bx6VZTSjnD91OQmJLgJcu16okymhv9dyag+J+f26tYY1Uo31lPVe3V72aWLXMJy9iIXSL3jxXeYXD9uyPiBtHW+i3Ne7WLk+6ryLagxUheAFTf+ezwnB3tHvbuZ0pfI868++Iky91cAvIEXS2Wdl65unpej/N2BPOWlpVZDFSrkkQan8pSe/IsMdbzb4ZCJ2/KG+nX0PMg8SHIlz8paHsKPj8aRPaYVIWYwEZA8usSUQSzDjRPNZK2bPGQJ0dLFRsScNtbBahhgzhqGB9dTLM3ETWGDElb1vcc02TJSXGXFT7Ar7Zn2WnB5VUuEvu/VLQslN/iaDDIkK0lSUjjFuxtdsuFQWC5P1x6xcIsrrnQbj7JpGpSY45iM5HK8TMhyWYZHHy7yZyukSEzvbGs+Z2zhc156nYnPjExl2ZfBZNsbYn/rFYuaNQLAWGEEIWo4K7ZvIgZv6lmiDSJhtgFjZaos/7v3aqcOufN/7YHcmznllmp3Wgp0agEYRGkcSicg71ZzlIFJklQuovuKlF5/gN5Ioy4oTuBXMVu3SR7j9Vlk9JkEvOC7lrFqziBzgGjmWX1JWLV+V6vZ4PF+HlnPTt1R01kTYhXYURN/MNe1Xmy00HIsvXA0BmRKpmrSnQ1knNP50hFfAv+QPnoUnsy865+rSws9VUlpGJMA9Cnyp/ngHKbkrhEPSwe+Q0uLv14JrxX3YOWgOiK5QSgyILXVjoc+jVrxuy45CzP/bDSAJ5SzJHmjg85ImmS6QqKE0hbigZ/fwsieTogm39WdVUlDWMaWpVAo0SwAepmTz66w2o+9b10vWl0Dhk0ScwFOFoYaIp45/SLgikHI6vupv/zjCH8tPh4MsgkGSG+R6WMY+vMbyjRJ9elxq8YrGfKygJN59aBC7pJJrvdBo
 nTawzFtE
 z98jIpZLNXL0JYaF/9U0vuxq/PYvbIxGTg4QrVZG8M+OyVtSn5z6tQdemUa59EPCQMnd9n9wkQ+SLqT2huCVzvKI9ivry8P40tLvQL+cQP1uXqfZyNVjCOn0/FYtvvrltJG9ykyujhCc1R/DTn2FJ+Z+qL3PphXzdo2XUdEAJFI7FA5q/NYdzhru9KV4DJkC3LROl7KrznpEVvzHUk2udv4iw40kQ3qgD8KNrCrK0PTFZv6jjgnj2BekqfiqLDvqY6TnJExn5UPRLTNVuKe6jENJHZw/bGr5s/qk+9yiHcPxGY0LmuRpM/FqwW87vYop9Oa7I9BZWB95sARIvnw+0BIEOiCH0awLRjp6cvaH/YPMJKwHgIDv8iWq6sBkWc0tvZNQJbFZ4Fy4OSoZ313yL3AV0Db98aoF6dM8zQDQi7UOep78IU71Xho2Y7lg9Q/t+az0papKtAFqQ9ZUchYz7JNdmsGNgGr55+P+9KirUiaVDZ6uFfm/zVVQpUG2IhtSpNtpAmP7ak07GjW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CPA takes pgd_lock around the split decision, the update of a large page,
the split and the collapse of large pages.

Everywhere else pgd_lock protects pgd_list. CPA needs it only on 32-bit, to
update the per-pgd copies of the kernel PMD entries when it changes them.

Updates of large pages are serialized by cpa_lock anyway, and the direct
map counters are atomic.

Take pgd_lock only around the pgd_list walks.

Without pgd_lock, should_split_large_page() only checks CPA_REQ_SPLIT
before it calls __should_split_large_page(). Fold it into
__should_split_large_page() and keep the shorter name.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 56 +++++++++++++++++++++-----------------------
 1 file changed, 27 insertions(+), 29 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 8076d29a2931..9dfe69d608b8 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -916,24 +916,29 @@ EXPORT_SYMBOL_GPL(slow_virt_to_phys);
  */
 static void __set_pmd_pte(pte_t *kpte, unsigned long address, pte_t pte)
 {
+	struct ptdesc *ptdesc;
+
+	if (!IS_ENABLED(CONFIG_X86_32)) {
+		set_pte_atomic(kpte, pte);
+		return;
+	}
+
+	guard(spinlock)(&pgd_lock);
+
 	/* change init_mm */
 	set_pte_atomic(kpte, pte);
 
-	if (IS_ENABLED(CONFIG_X86_32)) {
-		struct ptdesc *ptdesc;
-
-		list_for_each_entry(ptdesc, &pgd_list, pt_list) {
-			pgd_t *pgd;
-			p4d_t *p4d;
-			pud_t *pud;
-			pmd_t *pmd;
-
-			pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(address);
-			p4d = p4d_offset(pgd, address);
-			pud = pud_offset(p4d, address);
-			pmd = pmd_offset(pud, address);
-			set_pte_atomic((pte_t *)pmd, pte);
-		}
+	list_for_each_entry(ptdesc, &pgd_list, pt_list) {
+		pgd_t *pgd;
+		p4d_t *p4d;
+		pud_t *pud;
+		pmd_t *pmd;
+
+		pgd = (pgd_t *)ptdesc_address(ptdesc) + pgd_index(address);
+		p4d = p4d_offset(pgd, address);
+		pud = pud_offset(p4d, address);
+		pmd = pmd_offset(pud, address);
+		set_pte_atomic((pte_t *)pmd, pte);
 	}
 }
 
@@ -954,8 +959,8 @@ static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
 	return prot;
 }
 
-static int __should_split_large_page(pte_t *kpte, unsigned long address,
-				     struct cpa_data *cpa)
+static int should_split_large_page(pte_t *kpte, unsigned long address,
+				   struct cpa_data *cpa)
 {
 	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
@@ -963,6 +968,9 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	enum pg_level level;
 	bool nx, rw;
 
+	if (cpa->flags & CPA_REQ_SPLIT)
+		return 1;
+
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up already:
@@ -1101,16 +1109,6 @@ static int __should_split_large_page(pte_t *kpte, unsigned long address,
 	return 0;
 }
 
-static int should_split_large_page(pte_t *kpte, unsigned long address,
-				   struct cpa_data *cpa)
-{
-	if (cpa->flags & CPA_REQ_SPLIT)
-		return 1;
-
-	guard(spinlock)(&pgd_lock);
-	return __should_split_large_page(kpte, address, cpa);
-}
-
 static void split_set_pte(struct cpa_data *cpa, pte_t *pte, unsigned long pfn,
 			  pgprot_t ref_prot, unsigned long address,
 			  unsigned long size)
@@ -1158,7 +1156,6 @@ __split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
 	bool nx, rw;
 	pte_t *tmp;
 
-	guard(spinlock)(&pgd_lock);
 	/*
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
@@ -1304,6 +1301,8 @@ static int collapse_pmd_page(pmd_t *pmd, unsigned long addr,
 			return 0;
 	}
 
+	guard(spinlock)(&pgd_lock);
+
 	old_pmd = *pmd;
 
 	/* Success: set up a large page */
@@ -1404,7 +1403,6 @@ static int collapse_large_pages(unsigned long addr, struct list_head *pgtables)
 
 	addr &= PMD_MASK;
 
-	guard(spinlock)(&pgd_lock);
 	pgd = pgd_offset_k(addr);
 	if (pgd_none(*pgd))
 		return 0;

-- 
2.53.0


