Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B955C55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 16:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E7F6B0092; Mon,  3 Aug 2026 12:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE6146B0093; Mon,  3 Aug 2026 12:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD4A96B0095; Mon,  3 Aug 2026 12:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A38D76B0092
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:44:23 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A87A120748
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:23 +0000 (UTC)
X-FDA: 85060531206.20.19726A9
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 25C5910000E
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 16:44:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fVaZOjiw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="QGD/Qwf3";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="eRAF//7c";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WidZld5p;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785775461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ygAzH+FQgLJrgBdhFAHfKQ03vfYuxl+i8XyjFfW9SDo=;
	b=MP+vZtgovLVmgg88P+sCL3+lYJQki0PdD1bYMZACQ5iK+8+f+WK1Sp/LPhmG7W2l5n/C+3
	uYxoq1SVg+CxGR61f1aRPVyUYJg0K+9S2Z6v6vukgT9BOhSleboKw1sg0Zup0qmRPldK+Q
	pAEO1b1k77LhflxyiPTukM24yHZU9tA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785775461;
	b=xnDnBgM+3ikrFYmQYwMZiVFTK0n2pcYKQYJg/LjLnu+MKJgpvfeaKwV2DPCmHp9I++k9Jr
	jIOLd38yfhbOICHivqTYiwLyGUBlbdNrNudWyLfeQwYuIJYVrrEsDeg2l63jRwdYn7zWT5
	1NqP9SVJOJ/c9kLw9jqAQIrth/jhez8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fVaZOjiw;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="QGD/Qwf3";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="eRAF//7c";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=WidZld5p;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E2D5F3FB9;
	Mon,  3 Aug 2026 16:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775454; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygAzH+FQgLJrgBdhFAHfKQ03vfYuxl+i8XyjFfW9SDo=;
	b=fVaZOjiw4tGe5jF9DxPqF1IHf3xZVUT8j+7Jh/SXq8L7ymBs6PTJLAnL4+tv7s0yaEZ+NH
	YSugHilLxwkrEvdmR76hUCZ1NvxUUDyj3r6uNtGNFcaDvcdY+X1LSlHXhgFiHuMS3qevEP
	p2EppnDRsBeL569Y9Bd6fHytSS8/1Xg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775454;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygAzH+FQgLJrgBdhFAHfKQ03vfYuxl+i8XyjFfW9SDo=;
	b=QGD/Qwf3pojJ4A/NOwOvvQ2GmpGoO8Os2O5gMourjcbIPZJUW08FkNErONVX2eVVZ4UWmC
	i2YHuREacuyUCkBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1785775449; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygAzH+FQgLJrgBdhFAHfKQ03vfYuxl+i8XyjFfW9SDo=;
	b=eRAF//7c2hrRZi6Hqw/71YZVfpFa30gEZRxzsYvfPwSj4Nq9HeINTwlhjKCxi2K27cgHvW
	ppE9niHbkpGCZ9sgEQ/CnlNX5zfyfcuzHk+qf2kzjERVfz+I1J3NfV5VksDRE0lOtGgeVi
	kcrn3D6lMVLWc2CX8aQS/X79BbUCxaY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1785775449;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ygAzH+FQgLJrgBdhFAHfKQ03vfYuxl+i8XyjFfW9SDo=;
	b=WidZld5pCyaSuY5KrUcuhomuCxHdCu/rO89ht0SZwK06aFUx2fkO7daLaHjvmADVX/aVr7
	PQnrLsfuzhh7Y4BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 03E7A779C1;
	Mon,  3 Aug 2026 16:44:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id sGJtOVfFcGp/SQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 03 Aug 2026 16:44:07 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 1/6] mm/arm64: constify pte_get*() and contpte get logic
Date: Mon,  3 Aug 2026 17:43:55 +0100
Message-ID: <20260803164400.531199-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260803164400.531199-1-pfalcato@suse.de>
References: <20260803164400.531199-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25C5910000E
X-Stat-Signature: sckgz8m7k4r7udk8jrppr8i5euk87961
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785775460-326328
X-HE-Meta: U2FsdGVkX18oDl68aA/7aI/GK3tJPCJiqfPoqewrIOdhyUAQOmvtaRgqOWWgYx2tUlrn8KbCBDk2TPHwE3RxB1EvGng9raeAeIBYs0A6cyCVgS3Zk+k51WGvHkiojNZMg7CkSz7XLkQkgoaYR0uD3Pi0xtzNYmEkf63o0tr0RUUdZzC3qgxniRZ9gatus8C/WnttFtLBs5SnL2+eONnjiu1FeUmQ4Zb0efavI7kaMjSWb/klFrwJR/EjzBnj5wVWKSDBd+mKDac+wvVhoQKgvC4GCbaHbU3MxY0KsULlIc2zvwYOH0e2qTLLpYBNwotcKs8c7cNMEjFvlP/cuoBVFhCboIH8kTJpnQwmIvFyaXgVTusDLtVV7D5hkIoGOdsMp3xqJ0jQ8GWjfXW/lNEA9CIajUGlNEg24Zwbsfa9gIGrOmkQUT6ljnHLtyj/73WoNZuM5yYgPRH1cQwm1s7S/gNdOFhVnnt5N/WazUNKWFMwVKlq48Hu8648DU14g/HkFHZNWJcKuOEicEsoo8wbNM11GKI71mLzUs4jNdZbFteQqFW+izkB7zHAiuZAEogr98Np/7KEAtOmT0K+RlGxpzFWK5gva1f+zAGHuxMqLBmdan02+WObSHgva0zk0PdiLocZSyAckP6KbYjAJlobSP2Der4mSCg70mQpGeTEr5zp+FGCGyPCGG5cz0htcjA8b6wbjm7D3c4EGpkYSYXh1nq++e46vl+MpVTjd1C1ksKtxsaxm79jEMaf6b5ajdosUJv+m8yf429aBVtr6FfyBJA6OVhJxydJmqq5a0ToG8fXzbyKH2+1dg4EHtt6E+OQPoKM6qr9bDBEGC1JK2jix8lHH02fY934xKCBTuugslDdRSkSamwG3pivZOMFfaQTm1xNMsrkyRboIUFnwHp6I4mbkuMtTQkt92bBzPGbQC6LbT3VfN5qWlpLvWf4+B4XCJ4fE2eoPaeL/dbFLQ9
 z0Btl8Gw
 fY5gjXIS4RcAGpZ2DH1bD5tVu2X/sfUDMG4iOVguY0xqyLBi+9HI9mfPieL9q9m4jy++Hx2G1G4Z74fbfDXZlqBNSw51wcLbrBNR/XMQapdKk+5sfS5i00QhOTpsoQk/ZwTnyz/dCISfq/9x9atJAy3v7XfGrG9htepZniO/ekeyezYbbhzFevvMbs7tPWjstQ+s2c4Y8HGtZPQ+AxPRufaXH5RaApMsW1k7nqZIqTaTrzLe1aZBTJkHQIGyd+vFTPrMhEJNY7SEbdlSbTjdxJQa83MxxQXeIKK3sTh2CEKcYviFIKLaPTXg1WmfSsiwxrM+HnzNYZUA316CuTTllwf7Qf2R3U3K5Q3JExc/7/DzBzFAYyoR9VMRp4ig1EJDVu5eB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

None of the contpte code needs write access to the PTEs.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 arch/arm64/include/asm/pgtable.h | 10 +++++-----
 arch/arm64/mm/contpte.c          | 11 ++++++++---
 2 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a2681d755358..043bc0649cee 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -378,7 +378,7 @@ static inline void __set_pte(pte_t *ptep, pte_t pte)
 	__set_pte_complete(pte);
 }
 
-static inline pte_t __ptep_get(pte_t *ptep)
+static inline pte_t __ptep_get(const pte_t *ptep)
 {
 	return READ_ONCE(*ptep);
 }
@@ -1652,8 +1652,8 @@ extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
 extern void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
-extern pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte);
-extern pte_t contpte_ptep_get_lockless(pte_t *orig_ptep);
+extern pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte);
+extern pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep);
 extern void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte, unsigned int nr);
 extern void contpte_clear_full_ptes(struct mm_struct *mm, unsigned long addr,
@@ -1732,7 +1732,7 @@ static inline unsigned int pte_batch_hint(pte_t *ptep, pte_t pte)
  */
 
 #define ptep_get ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
+static inline pte_t ptep_get(const pte_t *ptep)
 {
 	pte_t pte = __ptep_get(ptep);
 
@@ -1743,7 +1743,7 @@ static inline pte_t ptep_get(pte_t *ptep)
 }
 
 #define ptep_get_lockless ptep_get_lockless
-static inline pte_t ptep_get_lockless(pte_t *ptep)
+static inline pte_t ptep_get_lockless(const pte_t *ptep)
 {
 	pte_t pte = __ptep_get(ptep);
 
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 2de12656b4d8..3a5d6937fb51 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -26,6 +26,11 @@ static inline pte_t *contpte_align_down(pte_t *ptep)
 	return PTR_ALIGN_DOWN(ptep, sizeof(*ptep) * CONT_PTES);
 }
 
+#define contpte_align_down(ptep)                                                       \
+	_Generic((ptep),                                                               \
+		 const pte_t *: (const pte_t *) contpte_align_down((pte_t *) (ptep)),  \
+		 pte_t *: contpte_align_down((pte_t *) ptep))
+
 static inline pte_t *contpte_align_addr_ptep(unsigned long *start,
 					     unsigned long *end, pte_t *ptep,
 					     unsigned int nr)
@@ -310,7 +315,7 @@ void __contpte_try_unfold(struct mm_struct *mm, unsigned long addr,
 }
 EXPORT_SYMBOL_GPL(__contpte_try_unfold);
 
-pte_t contpte_ptep_get(pte_t *ptep, pte_t orig_pte)
+pte_t contpte_ptep_get(const pte_t *ptep, pte_t orig_pte)
 {
 	/*
 	 * Gather access/dirty bits, which may be populated in any of the ptes
@@ -367,7 +372,7 @@ static inline bool contpte_is_consistent(pte_t pte, unsigned long pfn,
 			pgprot_val(prot) == pgprot_val(orig_prot);
 }
 
-pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
+pte_t contpte_ptep_get_lockless(const pte_t *orig_ptep)
 {
 	/*
 	 * The ptep_get_lockless() API requires us to read and return *orig_ptep
@@ -386,10 +391,10 @@ pte_t contpte_ptep_get_lockless(pte_t *orig_ptep)
 	 * because it is not part of a contpte range.
 	 */
 
+	const pte_t *ptep;
 	pgprot_t orig_prot;
 	unsigned long pfn;
 	pte_t orig_pte;
-	pte_t *ptep;
 	pte_t pte;
 	int i;
 
-- 
2.55.0


