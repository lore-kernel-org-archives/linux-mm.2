Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BE5C44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 16:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25076B00AA; Tue, 21 Jul 2026 12:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FC616B00AC; Tue, 21 Jul 2026 12:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 912236B00AD; Tue, 21 Jul 2026 12:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 615436B00AA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 12:24:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC501120212
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:52 +0000 (UTC)
X-FDA: 85013307624.27.2CF7479
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 302F5160011
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:24:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJmSLh0p;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784651091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ttX//dzrhR9sMSF/SSGtobxX0kA46zEbXIpY5XaZ9N4=;
	b=Y40xEEsns92nROpkBtRWeLaXakM0I48t779xc28bdcOG8UkBpRihNDFLUtfYUO7nXAswoe
	7hdoOcRQg0tPeLXhWf60YNCuAg9tLegC5IL53LDhKhPTw4CgZxvBa3l5ABdSNI5cN/iWm4
	nl+RAGiOdIiw42KEmK/IwpvyrDzfvs0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJmSLh0p;
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784651091;
	b=l17++HVI0BfOPEsgS3tvlXGjuLYUvDc7dXU2vT+x4JRWB2mdJn+0bwD45xwc56VAI7UHtj
	fuXcXrFI3XAgLo+WcEh1q/CUkrU9l/i+dosR+DQUVMF8Fl3EiMUnNrMEudcep2qvXnX6qv
	UnCCjC6U+PVCZJZ5T01tFynTxDPRvq8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5845041AC5;
	Tue, 21 Jul 2026 16:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDC241F00A3D;
	Tue, 21 Jul 2026 16:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784651090;
	bh=ttX//dzrhR9sMSF/SSGtobxX0kA46zEbXIpY5XaZ9N4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gJmSLh0p2zdn+TUWP5ffCXLjps1IY4pdY2MSOyC8/W+aqm3nsNU1U4iTihlhrvBfa
	 Q+mS6sw0lO9mOetPMFTsC9dtXtC+igugk3tV3KUzXcEwQ3X4QI6fHv+juQ4w7aGN0T
	 6Px8rlP17Ve+8eSsv4CW4eS0U4mcadHN/jXWfIC0dyhff3ZJLuUNrRa6uIJZHrAFd0
	 nO6yCipEiqmY+g1A97wEKDQ84Iad1bsmvztr7/jT6rGQyglKtI15OsZ1wyr0KZv5tg
	 s6ZFygHv5zMyo254wbSw+EqReu5y/kry5UxoS4XSbiqQL4PE3YknAVR4TX4v4odaNL
	 L75H13AxOl1Jg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 21 Jul 2026 19:23:33 +0300
Subject: [PATCH RFC 10/18] x86/mm/pat: move the large page size calculation
 to should_split_large_page
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260721-generic-set-memory-v0-1-v1-10-2c1fc62306b3@kernel.org>
References: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
In-Reply-To: <20260721-generic-set-memory-v0-1-v1-0-2c1fc62306b3@kernel.org>
To: linux-mm@kvack.org
Cc: Albert Ou <aou@eecs.berkeley.edu>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 Brendan Jackman <jackmanb@google.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 David Hildenbrand <david@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Ingo Molnar <mingo@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Kevin Brodsky <kevin.brodsky@arm.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-riscv@lists.infradead.org, loongarch@lists.linux.dev, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: 302F5160011
X-Rspam-User: 
X-Stat-Signature: y43cbogirrygzz5jzyaaspbrdhczqjpr
X-Rspamd-Server: rspam04
X-HE-Tag: 1784651091-943360
X-HE-Meta: U2FsdGVkX1/Q7SkKAydtWmx/byMh+CBRuwXv/8bqjIyfAiXqCz8NQba3CebuDlzDJyLoqVNPEpTcMJKJ7qX61KFT38Imw/dgFNsVwPJsSuzOpYD3mokXOCP9S6Mkaxho6eARfelmgKtT+Y9XGSc19x6Q1tMQN288gZHCfuVti0vCtr46EzRJRqYoLwCvZD8JazYH8MNhxEQk8usNqIoEvWhF5geDalUb1DM0+kFT+EpHLzxgpGuRYpSw/sS/Y7A/6YqRQucLja7VZaserb7f83c7dc8yj+GLEWaTCiGa6A5kAEXMqPQv7Zeho9sln0QMerj5bD6LxhbqrV/sHGJrQiTerfXIT7ui3Sw735jT1IKLb4KPk0rTKVffugzvvtpePH0ryOIyBcSJaHjyQD2KDDRvbb1I6PlSZa5hBgjZ+MT9pL86kVcEf9BwpQs7Wc+ISrbLPLNhFxbr4Y21flyn4+wm5LW2RZYzW2GUdkScUYQBumgkj0pzFJUq+EiRceaPu3BD7+L77RCHwTGIS1oO+I6M8c4e63rnQ0b+Ca9uVdeuKT/vGu8at35Zoa4a0BwNM4j2ic+Z71hJPoCP6If2L+yyZfIsKVdNVn6XmilSYB9RLwH/bSi2m6c26tfETxMMQWNPFKmkbxO2SDPA6FSJGkIZ2s++bq1nmBEfJYKOjETvzjDT2VFZEdvtCyL8P4KRyVuD1Bt5UVIrTEMYXn/z3SEv+CCRR4oGYuZykDdfTVY823lGzgh+UG5vosF+YKFBq007k08cNyzLyectD78uSYlnplcgyYXaG9uERRFo3zdFY6q27S/cZE1IElxJhR+U7VNa2CWgsix4osBV5s/03N2qWb6+Ujc3ijNoq86+b3+vz4Fk6kFESaXXtqv4mxEDbYSJMcBQq2rQLVoBzai2RGbumdJn6wsfHig8mfOMcyHZuwY5M0CwlUW+efM3sNf1UwwsDSiWEDQU9KmlPrI
 VuvHGGqH
 fxI8UFltG3V0Wln7EDqmpLiDcE8d/QYW35j84eiQ0FaZvYMUnPkgo6y1oO9bwNm1nUJBabkHJy1pTzpJx6inT9K5CdXf/rB0EAqyVbaKoR5m109nA95d5sBNFsY/ao6ehihD19DwHzKFEsOcFG+zKhEgauXleLq06sySeE8R7uVL9DnOcgz0jqeOdzSfvYtvz4DA6o32dj0ZP+nmCudrwKkzf8Tl47tLi816EF07E8f1Zz5NfRy+U15nkItkpklw7tV+GpDHieNcsQIi+AzaqkDoootDuLNM1hhL/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The calculation of large page size and mask and the update to
cpa->numpages use generic helpers and can be reused by common code.

The upcoming changes that will make should_split_large_page() available
in common code and __should_split_large_page() will become the basis of x86
specific implementation.

In preparation to moving core parts of change_page_attr() to common
code, move the generic calculations from __should_split_large_page() to
should_split_large_page().

No functional change intended.

Assisted-by: Copilot:claude-opus-4.8
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 34 +++++++++++++++++++++-------------
 1 file changed, 21 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index ef206ba6e254..56676d4cf510 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -58,6 +58,8 @@ struct cpa_data {
  */
 struct cpa_split_data {
 	unsigned long	address;
+	unsigned long	psize;
+	unsigned long	pmask;
 	pte_t		*kpte;
 	struct ptdesc	*ptdesc;
 	enum pgtable_level level;
@@ -884,10 +886,12 @@ static pgprot_t pgprot_clear_protnone_bits(pgprot_t prot)
 static int __should_split_large_page(struct cpa_data *cpa,
 				     struct cpa_split_data *sd)
 {
-	unsigned long numpages, pmask, psize, lpaddr, pfn, old_pfn;
 	pgprot_t old_prot, new_prot, req_prot, chk_prot;
+	unsigned long numpages, lpaddr, pfn, old_pfn;
 	enum pgtable_level level = sd->level;
 	unsigned long address = sd->address;
+	unsigned long psize = sd->psize;
+	unsigned long pmask = sd->pmask;
 	pte_t *kpte = sd->kpte;
 	bool nx = sd->nx;
 	bool rw = sd->rw;
@@ -908,18 +912,6 @@ static int __should_split_large_page(struct cpa_data *cpa,
 		return -EINVAL;
 	}
 
-	psize = pgtable_level_size(level);
-	pmask = pgtable_level_mask(level);
-
-	/*
-	 * Calculate the number of pages, which fit into this large
-	 * page starting at address:
-	 */
-	lpaddr = (address + psize) & pmask;
-	numpages = (lpaddr - address) >> PAGE_SHIFT;
-	if (numpages < cpa->numpages)
-		cpa->numpages = numpages;
-
 	/*
 	 * We are safe now. Check whether the new pgprot is the same:
 	 * Convert protection attributes to 4k-format, as cpa->mask* are set
@@ -1026,9 +1018,25 @@ static int __should_split_large_page(struct cpa_data *cpa,
 static int should_split_large_page(struct cpa_data *cpa,
 				   struct cpa_split_data *sd)
 {
+	enum pgtable_level level = sd->level;
+	unsigned long address = sd->address;
+	unsigned long numpages, lpaddr;
+
 	if (cpa->force_split)
 		return 1;
 
+	sd->psize = pgtable_level_size(level);
+	sd->pmask = pgtable_level_mask(level);
+
+	/*
+	 * Calculate the number of pages, which fit into this large
+	 * page starting at address:
+	 */
+	lpaddr = (address + sd->psize) & sd->pmask;
+	numpages = (lpaddr - address) >> PAGE_SHIFT;
+	if (numpages < cpa->numpages)
+		cpa->numpages = numpages;
+
 	return __should_split_large_page(cpa, sd);
 }
 

-- 
2.53.0


