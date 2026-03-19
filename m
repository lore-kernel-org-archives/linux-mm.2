Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BC371091904
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5EAD6B057A; Thu, 19 Mar 2026 14:31:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E36646B057B; Thu, 19 Mar 2026 14:31:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25866B057C; Thu, 19 Mar 2026 14:31:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C32A36B057A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:31:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AF59C2361
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:26 +0000 (UTC)
X-FDA: 84563655372.22.E6FC7AE
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2003840014
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:31:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1yLuBo1u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FNsKTwXF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1yLuBo1u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FNsKTwXF;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773945084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4EDCTugoDpsygL/2msKaEtTb3dy6BTNe9WE3o1d0jk=;
	b=LzuGzI6x/RxVsly19vLwhxoYJKT51CwdpN4M3E+13GWLGbvrgPxiq4ig1mu9+9r6ZivcDu
	xl8Vkn/ekuxiUmBgVqpHKHjzNLdndtC/4e3TfxFBFRmF6ATaJHztjGFrpGAqn1eYQZpJSf
	fF6tDCQAddmyvoV5AYjSFDEwv/abqlo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1yLuBo1u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FNsKTwXF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=1yLuBo1u;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=FNsKTwXF;
	spf=pass (imf12.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773945084; a=rsa-sha256;
	cv=none;
	b=HzBiyzZ7fbuElLQ1u1y6wkUpZLCmORDArDCS1fzY25Qj9A1e84/+ygnDeK1VnJEoPX3nBO
	G9wvIQNBrw6mDmSZbAI/bmvCi4LXux55YXArJTphmXdSjjbNhNFE2cYLRQXq0A+WxfGImx
	dtAAj7AOfPqdwvpsAQHSj15939PbEWA=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 5D4954D214;
	Thu, 19 Mar 2026 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4EDCTugoDpsygL/2msKaEtTb3dy6BTNe9WE3o1d0jk=;
	b=1yLuBo1uPsF7z6th72+dt19GsYUozcSNQDwQVvNoEUIO8xlkCQjkp4RfxmrQrL6tkawFkZ
	AbNhIEKyfDz+iyh/bBt1sqYI6gIeH05abz4Fj/osp0e56aU6fU7rX7nOZA7IaaUy75NGLv
	WVuGhHCKjYx1IRqIB/h+KfVVMkRPQuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4EDCTugoDpsygL/2msKaEtTb3dy6BTNe9WE3o1d0jk=;
	b=FNsKTwXFm1HxfV7fsG9TwBtg5wzBro/64pwQoXbQJMxkCYqM2xBbjAlw8C1Sl35kwD1QpK
	rhazKeGrVL87ZmAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1773945082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4EDCTugoDpsygL/2msKaEtTb3dy6BTNe9WE3o1d0jk=;
	b=1yLuBo1uPsF7z6th72+dt19GsYUozcSNQDwQVvNoEUIO8xlkCQjkp4RfxmrQrL6tkawFkZ
	AbNhIEKyfDz+iyh/bBt1sqYI6gIeH05abz4Fj/osp0e56aU6fU7rX7nOZA7IaaUy75NGLv
	WVuGhHCKjYx1IRqIB/h+KfVVMkRPQuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1773945082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I4EDCTugoDpsygL/2msKaEtTb3dy6BTNe9WE3o1d0jk=;
	b=FNsKTwXFm1HxfV7fsG9TwBtg5wzBro/64pwQoXbQJMxkCYqM2xBbjAlw8C1Sl35kwD1QpK
	rhazKeGrVL87ZmAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B5294273B;
	Thu, 19 Mar 2026 18:31:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6EKSGvlAvGmbdgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Mar 2026 18:31:21 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Luke Yang <luyang@redhat.com>,
	jhladky@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] mm/mprotect: move softleaf code out of the main function
Date: Thu, 19 Mar 2026 18:31:06 +0000
Message-ID: <20260319183108.1105090-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260319183108.1105090-1-pfalcato@suse.de>
References: <20260319183108.1105090-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2003840014
X-Stat-Signature: sx9fxtsqtx6wn4w5f7f55zct9s7dtfwo
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773945083-373314
X-HE-Meta: U2FsdGVkX1/eiXCVZOdpqkUv4qoo9msinaWNVzKd9Cik6ovdCANdXxz2ENENpQSaR33J2wBNznW7YtwScQpuKZ5J3y1Y1sGewuwLh3VC11SrNe1/CKUcMgyqlFcvipxkfwycUqN0DArj8geVB6S+xTZWm6KIVR1hEhkSkL2XO2LfF7ZwxYeYQpa4RhehK9mLIZj8I3iBhyKwvaPCXwBQYqv2dlgPa9JrcF5oWxvSqBdxIrC2qSqwNgfYDdpsC/Lcm+kmwsrn3a4TBdkkT12Pun4dr2UkVjODbKeYee7x/u4PAIi/gb8ecsPCIMQ0EJE0QyUH9ta8co30iCiP7np1q/02uzgxzk8f+LwaUwiCpwzVlQx5sNlvRxlgBrWb9B7+h2yxxqTy8om/qRjpRAKmidEyo6tL8LUjdpf/wXjX6tPx21agt7GugDyjuFK85+PEnw0VC0Et6LINsSpZ/kx8cIBCP+6j8OJr/BKvLieg1n6FSq8SfNx0lFOXW0usFmKhbAtDueM3paXzGDoRag0rY3jBF2tuN9Q+zxbnHmBVim7CgG2jUxDN8XiG2zXAQJEbMdTXdoY76N+I+2S07AwPVyIFG7tEw0S8ttw0Uqz+wxsbyB+U5PbJazyVHgHdve8YWzTyB1sir77Sz1ok/kmDINLVZ4UGIz07S3FC9jt9KC9V4iIXza/+Jhz54nvX115XSKmhWw235DhDrvUUKsbSnIxPd07wqRaT7zx7CxeMDWNz5EfTfn/HIDUJXj7JKzAxxUAXmfYNAgWFD0j1ESBWEJnnsF6KZMzyyJfrW7mCaygndStNVb3zLRjew2jDuFSLbUFsI7FOAXxa98qzhQ9nfw6WMcag9d3d/bX1d/XdZb+w4aNdnOPDvE9RO2COTfe0RB7ll3Vj6Hu750tHKnlF2S5Fhx5bg71AU+QAp8aio/IT/pNlyhemgy37Rvcqq17/bRPOxDuY/qEDRSv8COn
 MzRBvqYO
 x3sbaDEoQWfaOjAa6E+w694dkqikLf4xdbm8r9XPK/k8LJ+e/nIF4ai6SYtUi9gSbwzzoZBjASvpnNmB26KsnnLNmRJfyAFXwjpxlxn4VeLBSXg8U/UHs/31HGbMf56Sy7bQxvZmwutnRjOdAbSZ0Eeshjtst0ydR2XjA+Ba+G/nuvdukfngSgojRxxYKIJ40yES35rnBSt0zzTcp05GkJMcwkm2CkpsI7nKW2UlXAX3opYHMVJWHpLiSveljsI09yc8T6u0bSUrB/9odwv4gixzxq6EiPqx9XesI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move softleaf change_pte_range code into a separate function. This makes
the change_pte_range() function (or where it inlines) a good bit
smaller. Plus it lessens cognitive load when reading through the
function.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 128 +++++++++++++++++++++++++++-----------------------
 1 file changed, 68 insertions(+), 60 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 1bd0d4aa07c2..8d4fa38a8a26 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -211,6 +211,73 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
+static noinline long change_pte_softleaf(struct vm_area_struct *vma,
+	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
+{
+	bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
+	softleaf_t entry = softleaf_from_pte(oldpte);
+	pte_t newpte;
+
+	if (softleaf_is_migration_write(entry)) {
+		const struct folio *folio = softleaf_to_folio(entry);
+
+		/*
+		 * A protection check is difficult so
+		 * just be safe and disable write
+		 */
+		if (folio_test_anon(folio))
+			entry = make_readable_exclusive_migration_entry(
+					     swp_offset(entry));
+		else
+			entry = make_readable_migration_entry(swp_offset(entry));
+		newpte = swp_entry_to_pte(entry);
+		if (pte_swp_soft_dirty(oldpte))
+			newpte = pte_swp_mksoft_dirty(newpte);
+	} else if (softleaf_is_device_private_write(entry)) {
+		/*
+		 * We do not preserve soft-dirtiness. See
+		 * copy_nonpresent_pte() for explanation.
+		 */
+		entry = make_readable_device_private_entry(
+					swp_offset(entry));
+		newpte = swp_entry_to_pte(entry);
+		if (pte_swp_uffd_wp(oldpte))
+			newpte = pte_swp_mkuffd_wp(newpte);
+	} else if (softleaf_is_marker(entry)) {
+		/*
+		 * Ignore error swap entries unconditionally,
+		 * because any access should sigbus/sigsegv
+		 * anyway.
+		 */
+		if (softleaf_is_poison_marker(entry) ||
+		    softleaf_is_guard_marker(entry))
+			return 0;
+		/*
+		 * If this is uffd-wp pte marker and we'd like
+		 * to unprotect it, drop it; the next page
+		 * fault will trigger without uffd trapping.
+		 */
+		if (uffd_wp_resolve) {
+			pte_clear(vma->vm_mm, addr, pte);
+			return 1;
+		}
+	} else {
+		newpte = oldpte;
+	}
+
+	if (uffd_wp)
+		newpte = pte_swp_mkuffd_wp(newpte);
+	else if (uffd_wp_resolve)
+		newpte = pte_swp_clear_uffd_wp(newpte);
+
+	if (!pte_same(oldpte, newpte)) {
+		set_pte_at(vma->vm_mm, addr, pte, newpte);
+		return 1;
+	}
+	return 0;
+}
+
 static long change_pte_range(struct mmu_gather *tlb,
 		struct vm_area_struct *vma, pmd_t *pmd, unsigned long addr,
 		unsigned long end, pgprot_t newprot, unsigned long cp_flags)
@@ -317,66 +384,7 @@ static long change_pte_range(struct mmu_gather *tlb,
 				pages++;
 			}
 		} else  {
-			softleaf_t entry = softleaf_from_pte(oldpte);
-			pte_t newpte;
-
-			if (softleaf_is_migration_write(entry)) {
-				const struct folio *folio = softleaf_to_folio(entry);
-
-				/*
-				 * A protection check is difficult so
-				 * just be safe and disable write
-				 */
-				if (folio_test_anon(folio))
-					entry = make_readable_exclusive_migration_entry(
-							     swp_offset(entry));
-				else
-					entry = make_readable_migration_entry(swp_offset(entry));
-				newpte = swp_entry_to_pte(entry);
-				if (pte_swp_soft_dirty(oldpte))
-					newpte = pte_swp_mksoft_dirty(newpte);
-			} else if (softleaf_is_device_private_write(entry)) {
-				/*
-				 * We do not preserve soft-dirtiness. See
-				 * copy_nonpresent_pte() for explanation.
-				 */
-				entry = make_readable_device_private_entry(
-							swp_offset(entry));
-				newpte = swp_entry_to_pte(entry);
-				if (pte_swp_uffd_wp(oldpte))
-					newpte = pte_swp_mkuffd_wp(newpte);
-			} else if (softleaf_is_marker(entry)) {
-				/*
-				 * Ignore error swap entries unconditionally,
-				 * because any access should sigbus/sigsegv
-				 * anyway.
-				 */
-				if (softleaf_is_poison_marker(entry) ||
-				    softleaf_is_guard_marker(entry))
-					continue;
-				/*
-				 * If this is uffd-wp pte marker and we'd like
-				 * to unprotect it, drop it; the next page
-				 * fault will trigger without uffd trapping.
-				 */
-				if (uffd_wp_resolve) {
-					pte_clear(vma->vm_mm, addr, pte);
-					pages++;
-				}
-				continue;
-			} else {
-				newpte = oldpte;
-			}
-
-			if (uffd_wp)
-				newpte = pte_swp_mkuffd_wp(newpte);
-			else if (uffd_wp_resolve)
-				newpte = pte_swp_clear_uffd_wp(newpte);
-
-			if (!pte_same(oldpte, newpte)) {
-				set_pte_at(vma->vm_mm, addr, pte, newpte);
-				pages++;
-			}
+			pages += change_pte_softleaf(vma, addr, pte, oldpte, cp_flags);
 		}
 	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
 	lazy_mmu_mode_disable();
-- 
2.53.0


