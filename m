Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58CE9D3942D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4D4D6B008A; Thu,  2 Apr 2026 10:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23D96B008C; Thu,  2 Apr 2026 10:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13606B0092; Thu,  2 Apr 2026 10:16:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9FA546B008A
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:16:58 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 341D81B8871
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:16:58 +0000 (UTC)
X-FDA: 84613817316.26.DA488DB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf30.hostedemail.com (Postfix) with ESMTP id E22588000C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:16:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775139416; a=rsa-sha256;
	cv=none;
	b=NcsjDH8gmmhBIXpRwKr7+q/ZTvZGNd8UGelTtB6bavw+oSjdOsSoZ7sJ+lz71AGBdlD4E0
	53Hc1mqOdAWX1Mb1Y7LsNzTQ8jzOtQR8znKr/+fByrcilg1Onp754dohkLX38gC+KNKf0j
	QOWphSH6nmnGPfGZcB/oSV3vdNwRRPg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf30.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775139416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6X+36g3MeC1tUwUW7QnL/pf+ug1+J1JcuGdYP6hLz+g=;
	b=ZkcqUMMXbXGOrsp45486ksAxrkBxJH1duYozz2xMqT1blrbZgyjOIdjsfBlc4T59Qxth7v
	4e7dvKk8IcxXUM6Ph5vPbxVQjxJKcRlJsRsSIQIsYzW/+VIUjFZeJ3S+NltdMYB/q6BuaR
	ofyJ3KYvDnF4LgW204+OZem4oFF6iFQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id EC3D64D348;
	Thu,  2 Apr 2026 14:16:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 250154A0B1;
	Thu,  2 Apr 2026 14:16:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eGWzBU96zmlQDQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 02 Apr 2026 14:16:47 +0000
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
Subject: [PATCH v3 1/2] mm/mprotect: move softleaf code out of the main function
Date: Thu,  2 Apr 2026 15:16:27 +0100
Message-ID: <20260402141628.3367596-2-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260402141628.3367596-1-pfalcato@suse.de>
References: <20260402141628.3367596-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: umojc6xz97xya1zpzkuk94xmhsnau5b5
X-Rspamd-Queue-Id: E22588000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775139415-939450
X-HE-Meta: U2FsdGVkX1+q5nicLxuf0Z59uHdvUJB7/ViihwAN+ZF459wUxopzPixzUpEtgMtoANHx2lv2v/zsroO4a6L5X2bM0IwAWlSN0ngGgXLh8kb5OBrmMIBe2U+4ThBFZ/+lE8jhsV4dGcbXLzIzJwrOhf2IKl+EQ4pg0xigtMmhdTW4EvlNhq6Bo88uEo8QdvTCHMkkVUMTfuEkcvedpdcBpNwVS1LIXnBjDdGpW1w54hPvuRoLfmSHEgq45hD0tTwxZ1k4jscbj2Mw8Og0lZBe5uiyyI/A7lnOvg1VrIrU5NSb7CV93k3qOsr+l3NrDVmDRzOZYMmkrT33+eTGmJSWSVOUSvjikQCwi/zSFWzsSyKey2NNhDvNOnnJ6dvzlCiiqsA8FPI9/O0IiR3WR4uuSPDxX/y4tBkxPFvHuNeUxrpAuThKUsQpTzsLp1QutbBeZmB1MELt36z8nBcDewq+SVq1ZQ+e+r2zhlvTZdJDIkx+gEnQOrzfBGKFaEce6k/eL9a1CdtoPKEoIzxvcUozz1oPMHeNNlz6fpL0l5QCN3Ch/qQjKbQbH17UjWDHlQTnkZxDEqCx7KU5C/F8ZwD/V7N8skwq8hFUKDo1ADx9hI8EcAruTcd9rUY192G0Izmzj2Dk+R0n/uMufp//smCcFoCevh3yq1T4W2CIm2f5LfI5rNUlZcoDlak9QM8L9l+noLEN/kwqITg1OWw7zz2IJCu5ETxA6w+a66jJgVwPPSrp3VaMilccJrm/55gxOts2v+O8A0maL/5QUZohQwzP0/Rb7uC1bnQH1oIMQ8moW+bFUimJw8Fiwa2OIDLprHaahjSa68GcppvqDmvz03el4eqlKzckQZWcN37A7vbcBlmg8rn2/FvKnnCn3PshZNIt03mVJ/lKRRjSONHeb70V6iWhtgQ/px3I5GLiJYS4dGpJglk0zJe7hZ+6yiU06eZORUDTR9UU8fSCZVN+I9I
 yEJZW9CW
 7xGjbIaOAVpv6u0xnVVwtqIX69dKRymxxVeIHl5Fpbmk+5WCTzZ+V0zez2xI9Qy60qbRtSEn3kayHWXxB5hwR86RfcVoUjZlTSy8YzVGTn6P5FTJVaC/EJysJsrit95CjHfRPpE9N6Sy5wZY8XTvqKJeEU7a+RF/Xxh+XYtugrjNzh/Q=
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
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Luke Yang <luyang@redhat.com>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 127 ++++++++++++++++++++++++++------------------------
 1 file changed, 67 insertions(+), 60 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 9681f055b9fc..5929ce792c7b 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -211,6 +211,72 @@ static void set_write_prot_commit_flush_ptes(struct vm_area_struct *vma,
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
+			entry = make_readable_exclusive_migration_entry(swp_offset(entry));
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
+		entry = make_readable_device_private_entry(swp_offset(entry));
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
@@ -317,66 +383,7 @@ static long change_pte_range(struct mmu_gather *tlb,
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


