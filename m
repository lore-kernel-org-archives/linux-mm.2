Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D30CCAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 04:25:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748498E0006; Wed,  1 Oct 2025 00:25:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71F908E0002; Wed,  1 Oct 2025 00:25:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65CC38E0006; Wed,  1 Oct 2025 00:25:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5314F8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 00:25:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D3B791A0689
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:25:13 +0000 (UTC)
X-FDA: 83948255706.10.50FD341
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F6A6140007
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 04:25:12 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759292712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=z7oFzYvy9aFCNZhgEm/RfOu9uiydoa9PKFq6hDaYedE=;
	b=tlHs7g3ki90e+MNRJ4wt3+JgdIPl/onJvtCdGsl4OsFI3ZpWAQncFVA24yYY47Z7Bqi4RU
	OKbaiAwwtm9EdSNvKLWlfW9T9o7z4NO0xA9v46VoUiiHc9RJGYHwj6tmrD4r87dEsFuCy9
	CWx92UaFXrXqGyFMcxGfPHiBlCFsFjY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759292712; a=rsa-sha256;
	cv=none;
	b=G8I9lKHeMHzXwZ4ziB48fR02UHcdtvnBPW+Y5lmil95ZWWBKziQCScn/i2CPjeZsK1Zf2W
	fU44s1sGQGU7oHqqSLwenwkBULyq8IDr11v1bE9m9t1M40ESmqNNz8Yjwp9T21G0NnQAHr
	LynDXKt7MzdSj5mnzyzQHM33F3M7jH0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1CCC616F2;
	Tue, 30 Sep 2025 21:25:03 -0700 (PDT)
Received: from ergosum.cambridge.arm.com (ergosum.cambridge.arm.com [10.1.196.45])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id B4C903F66E;
	Tue, 30 Sep 2025 21:25:09 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-mm@kvack.org
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	SeongJae Park <sj@kernel.org>
Subject: [PATCH V2] mm/ptdump: Replace READ_ONCE() with standard page table accessors
Date: Wed,  1 Oct 2025 05:25:02 +0100
Message-Id: <20251001042502.1400726-1-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4F6A6140007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: occp9osjf5ny5m3sayg1ubxnjgmcyqci
X-HE-Tag: 1759292712-326619
X-HE-Meta: U2FsdGVkX19WoUOak88j+tP8xlP5tZiJCXQwva/YpoFTGYWyzw9Qg7CiMGF8+SNckA0XVpw5t7mfvU8GWFYLY3iQzCQJrxQCAdgCdOvXWluY6vsnLWZXbQjfSrpsgiBmkrjdjfiEuSwkw3TnVz/bCBiMlRy4ulfft7h5ZjigRAxrF2e1MGDL4HLAO8x0THKEBbTCGDaqlSx7Z+VJUVzHFRxlQChGRpGtY8FR/GEvRnSTwDmPDrHcbBdmzmoSzPaM8IHcksupox1+pgGPzqBTuR+qW8yR+TXlLe0EF0XuGBO3xR9e9KjFgSZ1XJZFBYKARjZxuiHR9aTGBUrlTPn0vx9Y4s6PdayQS+VHp7vdyd136t6uuGHkPvn/XagZff+UiWVMCw1vcRWKP5IKOm0E3VHRNqDDQhZHe04l7lnndhW252jrOMSP1ZZaXecjktfjSc7uS6F2Wmzta/Q/pgSFCTbDH6ixi2I3iJlL64w0mzCQrXDmupgV6VCsEhnmTP92+rnRrBZvMxoLacaOTv8XE6LTvxls4/+2NGfuHl5P4J+DjV6ut0RVFhU6Exmsm48J6Q1qIPWnFXnfALyNPV5WuPOwfqGAoXCr8lh8au0Ylf7o2T9M85MfrN6Nuoiemr5yBwi7+xV6ktTgLZoLXhzV11ilKUkNIc8V4qfoeYdKNsujUkVFO36i6frPHP6Pg3cCvgRJWLAlaDTDCohKd0UwY+BEZdvZ1qIaH+ni3Qd71ebp8MAaKwbq+5kyXR7/f/R+t4J9uGASBLSTQfFdec7YLkp/6HDWOPwAdt2G2HmVxoqSSzN1sGWc4yg4vm8oJn2AyQPueiqunMtQJmW4HMA+5BUqOObtaUEdRdt9YN+YHYka0jf8oAISkvCrHodhtA/lIZuZkxmz0+WXHdSrN+cKTMxPFwJLdP+i/wwOmdjPtdk/YCzSSRv6atASmQwqzdwmM1r1D7ENQTi08jDQfqh
 UArY7Lf7
 1sYxWDn/LlSQ9FlXGXatdzjGd8ZPft1WraFfhbGwmStgL5gOVVRvAInbDpmFbZnum/1vU3dJ8WXVO3tzULA34UUxMvsUK4BZGQO5dkdk5S8mOledeCnLofapbhbDMq7WN0+pxBDTPRlrulGFfTAbpo95ThD0BNcYE0I/mfefw/U0yGXaf0HPFR6Ygdi9aFBR9DHtln+RLycoTp2smLR41Rh/6R4wD5bFhRG4cw0hiiCuPj1QX9gAz3zr4Tt0R6Lq7kSHXaDN5Gc/k+8mmpbSznmlol/MXyDmLJDo1AqQnG1ubERvoZiUFflBcxU9Xp+59lSFQaN6qaHDi/TLZNnopGHIFYhR43HWosha6QffNzbw/paGjChiJHUW06Gqk0WQZlAZvn0lqWZFguOcfMjLWC/jsfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace READ_ONCE() with standard page table accessors i.e pxdp_get() which
anyways default into READ_ONCE() in cases where platform does not override.
Also convert ptep_get_lockless() into ptep_get() as well.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Reviewed-by: Dev Jain <dev.jain@arm.com>
Acked-by: Lance Yang <lance.yang@linux.dev>
Acked-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
Changes in V2:

- Replaced ptep_get_lockless() with ptep_get() per David

Changes in V1:

https://lore.kernel.org/all/20250930025246.1143340-1-anshuman.khandual@arm.com/

 mm/ptdump.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/ptdump.c b/mm/ptdump.c
index b600c7f864b8..973020000096 100644
--- a/mm/ptdump.c
+++ b/mm/ptdump.c
@@ -31,7 +31,7 @@ static int ptdump_pgd_entry(pgd_t *pgd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pgd_t val = READ_ONCE(*pgd);
+	pgd_t val = pgdp_get(pgd);
 
 #if CONFIG_PGTABLE_LEVELS > 4 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -54,7 +54,7 @@ static int ptdump_p4d_entry(p4d_t *p4d, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	p4d_t val = READ_ONCE(*p4d);
+	p4d_t val = p4dp_get(p4d);
 
 #if CONFIG_PGTABLE_LEVELS > 3 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -77,7 +77,7 @@ static int ptdump_pud_entry(pud_t *pud, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pud_t val = READ_ONCE(*pud);
+	pud_t val = pudp_get(pud);
 
 #if CONFIG_PGTABLE_LEVELS > 2 && \
 		(defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS))
@@ -100,7 +100,7 @@ static int ptdump_pmd_entry(pmd_t *pmd, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pmd_t val = READ_ONCE(*pmd);
+	pmd_t val = pmdp_get(pmd);
 
 #if defined(CONFIG_KASAN_GENERIC) || defined(CONFIG_KASAN_SW_TAGS)
 	if (pmd_page(val) == virt_to_page(lm_alias(kasan_early_shadow_pte)))
@@ -121,7 +121,7 @@ static int ptdump_pte_entry(pte_t *pte, unsigned long addr,
 			    unsigned long next, struct mm_walk *walk)
 {
 	struct ptdump_state *st = walk->private;
-	pte_t val = ptep_get_lockless(pte);
+	pte_t val = ptep_get(pte);
 
 	if (st->effective_prot_pte)
 		st->effective_prot_pte(st, val);
-- 
2.30.2


