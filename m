Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1788C60A5BDD
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RadUXxFz;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IZqtonmx;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=RadUXxFz;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=IZqtonmx
Received: by kanga.kvack.org (Postfix)
	id 9E52D6B05B6; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997026B05B7; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8865E6B05B8; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 589196B05B6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E86AB405CA
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:37 +0000 (UTC)
X-FDA: 85426690314.17.1E5D96E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id EF652120010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RadUXxFz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IZqtonmx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RadUXxFz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IZqtonmx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6YWUCSXWqyL1xWG0ifotpOzssQneDskvG8p1+21PIR4=;
	b=tJIlNQTz+P51Vi6U4ODCUQuOpK+e1iIZ8jM2CBjp3kImfS4PCf9QO4exxlEI66O7/hE5Jb
	769emltc85Jk56p6uk2pKywHOQhH5OS3FzO48klwn0QlZ0dC+VI1jEeA1HQgYHSIYgLaK3
	4P9ya4EieeqMaRG0VrXHqpTIaFoF13A=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RadUXxFz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IZqtonmx;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=RadUXxFz;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IZqtonmx;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf29.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493536;
	b=1BfCzqoM0OsM5UVvxng6OwoaE+7mgogANFlLOmK45MFV6QZxITfDqexkiAp4GvgMIW4bFw
	KDGW2XhMQThgRZ4cSt+pEtJzhFm3V5lGWeKR2Gtg0rnb6lBg4DftKDPycmofK+FG+LMXC0
	kUCkFH+0Mwmevwxc+DfE4AeF8sj4xgI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DE15D21DEF;
	Thu, 12 Nov 2026 14:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YWUCSXWqyL1xWG0ifotpOzssQneDskvG8p1+21PIR4=;
	b=RadUXxFzw0HyqoD8lqQh5wbYPJz0ASHGDzXSkyZjXl/V+5m7xPx/svoXkDxCJvmpgcwy6R
	gI+U7ML0T4axp66JIE6EPZvAsEW4OzonyXlgJn1F1X0YiVzkUBo84xFjNM/d7Kjwzt6Xwz
	WX2ZFxX5ly2jUooq9uoQ8aPZVPyk32g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YWUCSXWqyL1xWG0ifotpOzssQneDskvG8p1+21PIR4=;
	b=IZqtonmxFwZVkMHUyVhmFt3xNKcjxQ46cGK7RNQYrb12IKUPSvBmH5ZgzZzE9SJQtdvKLL
	+FjBiBzVnR3Sc4AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YWUCSXWqyL1xWG0ifotpOzssQneDskvG8p1+21PIR4=;
	b=RadUXxFzw0HyqoD8lqQh5wbYPJz0ASHGDzXSkyZjXl/V+5m7xPx/svoXkDxCJvmpgcwy6R
	gI+U7ML0T4axp66JIE6EPZvAsEW4OzonyXlgJn1F1X0YiVzkUBo84xFjNM/d7Kjwzt6Xwz
	WX2ZFxX5ly2jUooq9uoQ8aPZVPyk32g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6YWUCSXWqyL1xWG0ifotpOzssQneDskvG8p1+21PIR4=;
	b=IZqtonmxFwZVkMHUyVhmFt3xNKcjxQ46cGK7RNQYrb12IKUPSvBmH5ZgzZzE9SJQtdvKLL
	+FjBiBzVnR3Sc4AA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4D6DA13432;
	Thu, 12 Nov 2026 14:25:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T4
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:33 +0000
From: =?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-s390@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	peterx@redhat.com,
	ljs@kernel.org,
	imbrenda@linux.ibm.com,
	borntraeger@linux.ibm.com,
	frankja@linux.ibm.com,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH v3 3/9] mm/huge_memory: honor MM_CP_TRY_CHANGE_WRITABLE in change_huge_pud()
Date: Thu, 12 Nov 2026 15:20:32 +0100
Message-ID: <20261112142039.907090-5-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -16.30
X-Spam-Level: 
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: EF652120010
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4jr7tmoccr5q5mzyn7zod97fr5wkd7i1
X-HE-Tag: 1794493535-684374
X-HE-Meta: U2FsdGVkX1+FiHVuSoE6QQRoInmiLWzTbn5fEszPnUPMuMV0IQY4bM9GWtfuldFsU1JksIbZMhe9iG+s3HKEkTjmuVoEG62j7zGA9DMjlOxR2nVEGkDvHfaAK1xabBSPMXE1B6IVVOc5RkMGbhgeWCSgK/5t1EV9mNOgI/zyd1lX4Gt2hX3DhWdF4Y5Tlhpi9NsZicnwBtK5yaQd0AoKQcMZfmY9Vn9kKQi0dUmQ2kfUILLufhQXfBJ+rhAJQihyBvDnxkvKyadCO8TgNMnSwZFBBsoRWGMFJK6hyjcppTnbzGdDXPPtGtqD35ariWS9GV9DnU3LXbEae684nukKYiFzXrhI4pfrvETMsgzgR3ccetuajAdjcs54VgXIUSIkGD+MEHm22ZOcHrGl7smbFcAhYLyA/zypEwzCqVuTansv31/X+9F9OYwsY9OfnY8zCV2ZqfdwutcbapE/K/SC9mzeMwFSQgSVsETTrKyD4sD+E12fJQg1BujMjwL5CdyIIzed3nn05SQcoeCMEtP8UhuKn/UdvmMG4h4+ZLk7nLAgh6AgS4jM3uJaTX40lnz6NcYJ86SSn/1UyL3cLNyuNctipiyTAb3KTW2UyeA8KW4Doxuadw1B2VKrKuJwH1cMBdKK41fSbC3g5Oe4b27331EV/rde8/YS1kjX4CLdXh06900WstUFzIdsL9RYS7r54HTKGcqPnsZDCKJwrPOgUlcKeq++XeQqmWmjUb9j38BVQI/LhtrCNwl/pLOsTl+yudOIrR4QyXpXOiV4CwQ+TLS5U/CzqQZ7y+bnXnj68jYqCgfKgH02A4Z/BRNIm5josOZvmILra1DhY7HUkpqfVoTbeFZeTn9HlSLI36jr/yT1n9HwTBYv6z6SEiev2OhB7Py6OhAHS+AKgo7eHzbdVQ6hifnB0xXzF6gdH8aBDbO6Q6JOXPXBe/ZoZGEJIh/L+35WL4yDVXh/McStpOs
 b5MPKtG0
 hxuZYgsMcihdVP06wYd467z7aJQOqoIiNug3JquORPacKGfJitmMNJKYmZuSZsrH93tG6XEFUTv04tYMuBpm1Tl6bXHdp3po9CV+A+xWnNh+Ixg1Dx7zyt5AqPEcJuk1XtbqhM39GCNgS/ix9MGUa2xkE8ubX4Rl2uGG3kr/y0sw81Y+wCOFlz9RZf5S0+0bmGIFXNXoJQNGtkOonyS9koMMzSEOjPPWZMAU3cFl/4ENHoKoEt90mGDcTj1bv/8Uj+SbwzKGKx8YNSwc1Rtu2ylFDN3QgX7e+Y6GigXBQry94lmzEjyb/ajY+doNM5J4tuPdFxUUoN0WcSlSNku/z/bQc0e8wkCdCz+tA76tEES2VPJceuyk/pmdO8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_protection() applies vma->vm_page_prot, which lacks the write bit
for CoW and write-notified mappings. MM_CP_TRY_CHANGE_WRITABLE makes
entries writable again if a write fault would only set the write bit.

However, change_huge_pud() ignores the flag. For example, device DAX
mappings are write-notified once soft-dirty tracking is armed through
/proc/pid/clear_refs, and a protection change then leaves dirty PUDs
read-only, so the next write to each of them faults.

Fix this by adding can_change_pud_writable(), based on
can_change_pmd_writable(). It omits the NUMA and uffd-wp checks, as
change_huge_pud() bails out on those changes.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/pgtable.h |  5 +++++
 mm/huge_memory.c        | 28 +++++++++++++++++++++++++++-
 2 files changed, 32 insertions(+), 1 deletion(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..943d7e95f426 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1866,6 +1866,11 @@ static inline int pmd_soft_dirty(pmd_t pmd)
 	return 0;
 }
 
+static inline int pud_soft_dirty(pud_t pud)
+{
+	return 0;
+}
+
 static inline pte_t pte_mksoft_dirty(pte_t pte)
 {
 	return pte;
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index eb913acb03b7..080b718eb7de 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2833,6 +2833,29 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	return ret;
 }
 
+#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
+static inline bool can_change_pud_writable(struct vm_area_struct *vma,
+					   unsigned long addr, pud_t pud)
+{
+	struct page *page;
+
+	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+		return false;
+
+	/* Do we need write faults for softdirty tracking? */
+	if (vma_soft_dirty_enabled(vma) && !pud_soft_dirty(pud))
+		return false;
+
+	if (!(vma->vm_flags & VM_SHARED)) {
+		/* See can_change_pte_writable(). */
+		page = vm_normal_page_pud(vma, addr, pud);
+		return page && PageAnon(page) && PageAnonExclusive(page);
+	}
+
+	/* See can_change_pte_writable(). */
+	return pud_dirty(pud);
+}
+
 /*
  * Returns:
  *
@@ -2840,7 +2863,6 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
  * - 1: if pud can be skipped
  * - HPAGE_PUD_NR: if pud was successfully processed
  */
-#ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		    pud_t *pudp, unsigned long addr, pgprot_t newprot,
 		    unsigned long cp_flags)
@@ -2872,6 +2894,10 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	 */
 	oldpud = pudp_invalidate(vma, addr, pudp);
 	entry = pud_modify(oldpud, newprot);
+	/* See change_pte_range(). */
+	if ((cp_flags & MM_CP_TRY_CHANGE_WRITABLE) && !pud_write(entry) &&
+	    can_change_pud_writable(vma, addr, entry))
+		entry = pud_mkwrite(entry);
 	set_pud_at(mm, addr, pudp, entry);
 	tlb_flush_pud_range(tlb, addr, HPAGE_PUD_SIZE);
 
-- 
2.51.0


