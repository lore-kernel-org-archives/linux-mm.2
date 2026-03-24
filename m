Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 422BAF54AD0
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:44:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8ED06B0089; Tue, 24 Mar 2026 11:44:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CA8A6B008A; Tue, 24 Mar 2026 11:44:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0B16B008C; Tue, 24 Mar 2026 11:44:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA9B6B0089
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:44:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F06A31A02BB
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:44:04 +0000 (UTC)
X-FDA: 84581377608.22.468021F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id C229A180009
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:44:02 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UxEstlF5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CF4db070;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UxEstlF5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CF4db070;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kTNPtdZTKpYCvbH42Myxx6vflMzD8rPcSbe5PW/nTvM=;
	b=zpiR7u/zdet3NrAuPD3rgBLzGVmRaRdORl+n1T6w2liGbO6czVQN0iDmoa9LfDaHv+HRHr
	4ILT4D0gq0dP4HkFTk/72pxhntetmUWKRIPvuD1UV+x2nSA8+IVojyZgFdhKeq5zaFqfUx
	3uk35+/1PP9qM35IOunVZOwY++A1lzo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367043; a=rsa-sha256;
	cv=none;
	b=ZDbN4swNCPv+qSOGP09N2hR8SDhFS2qfRqMb8iQcpdIUpndnESQvcD50I52uhGI+eAuaML
	2KUJqRC+I2mu4MmnYeymQJ5MlnSH2jng2RGRBLohzwjgA9IZyEFtkVuAwdg2CUo3yuqT67
	A0oaMxsdnZXRu6MquLeR+lYp8dv/su8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UxEstlF5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CF4db070;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UxEstlF5;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CF4db070;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 44F445BD4A;
	Tue, 24 Mar 2026 15:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774367035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTNPtdZTKpYCvbH42Myxx6vflMzD8rPcSbe5PW/nTvM=;
	b=UxEstlF56vdF9Bm7vLdB/AGzaGNUIOunZpeCJZJJb9zsC3+dDRtJTBoDSL3SL7Eu0+vvnf
	xKXZiXh0K66W7UW9Qb9Bd7iAKp5zY6mraYgZCA7q2RkE++f47/9D1Iu4kEfu7ADGvUkNbQ
	tNi2fCDnhKzsAe4HPzeiT5mCT3J1MvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774367035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTNPtdZTKpYCvbH42Myxx6vflMzD8rPcSbe5PW/nTvM=;
	b=CF4db070sXFUj/v3iw8gxQgmT96F63R7xV8O1KcK83/L4xFg8fRimyZLYd6mNNzOEWNO5r
	JFH03csYN5ea5ICA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774367035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTNPtdZTKpYCvbH42Myxx6vflMzD8rPcSbe5PW/nTvM=;
	b=UxEstlF56vdF9Bm7vLdB/AGzaGNUIOunZpeCJZJJb9zsC3+dDRtJTBoDSL3SL7Eu0+vvnf
	xKXZiXh0K66W7UW9Qb9Bd7iAKp5zY6mraYgZCA7q2RkE++f47/9D1Iu4kEfu7ADGvUkNbQ
	tNi2fCDnhKzsAe4HPzeiT5mCT3J1MvE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774367035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kTNPtdZTKpYCvbH42Myxx6vflMzD8rPcSbe5PW/nTvM=;
	b=CF4db070sXFUj/v3iw8gxQgmT96F63R7xV8O1KcK83/L4xFg8fRimyZLYd6mNNzOEWNO5r
	JFH03csYN5ea5ICA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 72BDB43EF7;
	Tue, 24 Mar 2026 15:43:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QMi2GDqxwmnUNgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Mar 2026 15:43:54 +0000
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
Subject: [PATCH v2 1/2] mm/mprotect: move softleaf code out of the main function
Date: Tue, 24 Mar 2026 15:43:41 +0000
Message-ID: <20260324154342.156640-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324154342.156640-1-pfalcato@suse.de>
References: <20260324154342.156640-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C229A180009
X-Stat-Signature: ixopbzyqwbceo8fna4bayescqjaywiru
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774367042-498899
X-HE-Meta: U2FsdGVkX18ssbupNcej/uAdBFOAF830mkzx3uKFFZ1llgWX+0bRkNGhvkeu/HIXe2hb1NUGf3U213RtgMvNwL1zjJKRjlo2td2xYuf/v4S3vSmEX0ht5FPrEwTs/4IgQj83gyei13R4E+Q/qP0mnn+D69GCG6ZbnRdqhylH8dnZjKxd/NUH4Aqga4KRiv11j+/2MhHE7vOL18DseBpQWF+p2EAxxFmux9rxpWSXH5i4icYtTySRpsYEIqC0FMNM6e6IIHajAS5HFvJyNLYG4rJ1VZIQh9jJMeO4kKgMy3hAzTozxsV4XMR/JaoqBjksEKUJkRdAMQqyvrpqbHgaYv++qi7Ew1MmduwYE0rPlpzpqhbUxvXOF8FhTgr6zpnQCA9tx8JR9slH7gPUfJVrYPajUjC2UUeOcHMI4AtaFhEP3qH2DTWXYsH7ZoWQdRiUTWhluhy62IBnVauw5iMqqvZZNTAMl8cO7C5cfHSjsqKUDczblE2kgBfQMOWwPE9BTCFec4HhvE5PBKSjQY4zTANUid11twY5Er34cC3gkIufiiO2RKHH8Bp/nIlzJSOi/CjbrYr1c9viWvBNuSl0crhpyy6Jhq9NAqWqKApIoun+g8ai0NFLk7/0+9S+smj8B8T7CSR/OqXD3bXh7d9elxXKNT4V9NuM13/Jf+sqegNnwcA82xCD1TB2x/lK6XXGsD9WjXs4NlrvIkvNzEl1P8UeHKI1Yu64G9qHOCFDGQ2X9EKj1i6l9K8+BgroPooa1QuEjfKX4CHqnqqZEJu72eLKl6vw0q9GIUlvug040RG/2e5alb+DTZ5M4DyvFQshjrljDtnGOptURdlvJPJpIslc94aK1bs5+LWC6ZEs/fbWT6hrYntDU56dBMlLdzrG5+vyqW3RRdbhiQW5M2hij25qy6d8FRx8Fr5uac47Y+ND4J0/fPy2hWc946aNCyjqiVoxca+FgG+y2+1ZyPh
 CkrKAD0N
 FYHeT5CFMvm9WpEyyj5vbIAs88I3tsx6uMVH9LrCkgXIqYqNo6i7ACHY2tponszh5vouhpH2kg/itnKp6Sqrs+LCRhixt+cA3iDRgf1qgg0TrtHOANhKQTM1fjaxRb59vqPouHrRpa3WerKUqp80fkgucvpW+RwGLCNsgaoF/DIKiZNDAo92gexuueL7vEcZq7afM+2R7z4XWV5bUWQS9K+7Q3KLaE5yaOKIvodlFwwqi/fP43+QDsSq9jcNvFu/Ajwn5oSCfu5yIXMAgn/zSIzrb47HwmDlzHYGJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move softleaf change_pte_range code into a separate function. This makes
the change_pte_range() function a good bit smaller, and lessens cognitive
load when reading through the function.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 129 +++++++++++++++++++++++++++-----------------------
 1 file changed, 69 insertions(+), 60 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9681f055b9fc..2eaf862e5734 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -211,6 +211,74 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
 	commit_anon_folio_batch(vma, folio, page, addr, ptep, oldpte, ptent, nr_ptes, tlb);
 }
 
+static long change_softleaf_pte(struct vm_area_struct *vma,
+	unsigned long addr, pte_t *pte, pte_t oldpte, unsigned long cp_flags)
+{
+	const bool uffd_wp = cp_flags & MM_CP_UFFD_WP;
+	const bool uffd_wp_resolve = cp_flags & MM_CP_UFFD_WP_RESOLVE;
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
+		return 0;
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
@@ -317,66 +385,7 @@ static long change_pte_range(struct mmu_gather *tlb,
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
+			pages += change_softleaf_pte(vma, addr, pte, oldpte, cp_flags);
 		}
 	} while (pte += nr_ptes, addr += nr_ptes * PAGE_SIZE, addr != end);
 	lazy_mmu_mode_disable();
-- 
2.53.0


