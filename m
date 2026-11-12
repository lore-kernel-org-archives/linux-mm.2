Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04FEB60703AC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A8656B05B9; Thu, 12 Nov 2026 09:25:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 181A76B05BA; Thu, 12 Nov 2026 09:25:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06EE76B05BB; Thu, 12 Nov 2026 09:25:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D74F96B05B9
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 608ED1205E2
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:41 +0000 (UTC)
X-FDA: 85426690482.08.447E6A6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3DA8A120004
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493539;
	b=in8HgvOF+5pXpZojTLhs08sbIYTCjZ7HzozcSTbJwT+e28R5I0yngKGcL3robMtJBvxIhN
	6urPZEVgz1ntFQEHrYYwr1ngV39IAXyjqnTsY6zn655wT6l7GlCHnuYCr4jSQhJnG34sbX
	GvIt/nf6818a+6akpQ7o+VECjn6Xy0w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of clopez@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Z3xrZBlTc/FTOQz95usYjN2adGsAVepEaeJcyS2OQCY=;
	b=ZX56pQygWoTnJS1UhSz+rxKtV1Eswy9AUWoUBgsCmx8ofUjeV5rLh1P8v1IWkMc5z54abh
	V9+2fB183whjMj2DR8MlZ3IbtgJIwNjFY3mWn7X0Qcpn+yJiApSq4WOyJ1O5GX4AhiKZoW
	QZNNrqDHixvhdlK5ePDqQvKeJHns/Uw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1465B21E0A;
	Thu, 12 Nov 2026 14:25:38 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id CB15213432;
	Thu, 12 Nov 2026 14:25:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T6
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:36 +0000
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
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH v3 5/9] mm/mprotect: add MM_CP_PERM_UPGRADE
Date: Thu, 12 Nov 2026 15:20:34 +0100
Message-ID: <20261112142039.907090-7-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Stat-Signature: 6zrs46esme3yc9f6q66hh4kjn1m43fub
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3DA8A120004
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794493538-652344
X-HE-Meta: U2FsdGVkX18j7ejccXx7mfqa1+Jz+ng3fXHm2z9QlSmLyI5ccstug3/xq5iuG3yrjeMtA6pxrYgxihP3vkWdzSEkYDlMIWKsCJPfiN86L1Lb6mEqXmmoAlHLaglWV0eGOm6cnOxFCzF8kKxDpp5GUKGYg7GOqv4dN5UQZJIkj1vfllOIM7AFxMwm2rL9lC9+xYqGdXqsyCTMs7naKzltCL+oD0NOlYXpoF+7HHPA293GQgCmMiVaA9az0QDMrI3+v7HAlIbOBJ7ThdyLWZ3f3g1um4TWC2wbNfwUoE597j4U5YMRy0cegEi2yaGfPnT8wOE6h87/1XkBiS9gQodpMr2jSq9gnDrDWUJNvKf87EbKgkiVFGKqBHeepBFDea1LRIpxI6E8weKd80kUVxtnXkPZfHk30wwdOR8WOfCSkZGGj0NePfQAJbB6CXpQKM4iIWFrUif/0pkrzrX0YTpU/40DBZuxMWj3lcVqHpOP7wCgcUJq80sBfhZM6WGM+NcfXX4loVkk6yCZIymSN6FL9D+5Sw3HDOEJQYbJxOHgaJT/NLLyCZmVOsJdtgQrgBcN+Qcy1CwXTOptmwJeUzW4YV38CSWNOHQR6u8xsyN6Yp4eglRGAufk48o5I6EIZ0meswy3a4Pala2xEsUr7cAwdtP8uCyYBUdQHgnJs5tWF1wY+3e5ZE5LK8SUU+JEs8pXBKy+siJ0u3v9ohnbJME11IXQ0Z3GosytWBeNmy29GDyFFNC4EYGjvrHqAZGRdCTMOL+iqqK5JkAfCvUG4Cd5HfaMVSDRoklRAedlM3iw5ynpKfZuId0JgKtpYrKSgdUmnCZ3Pi+vHzcIhZzLuBwD2DVtcH/EAvyhIZy+J2G+TNUXKyhGyr7nqpMD6Ibqf42hu3NnLxB4zP1CHBFc0zG42y2IZRVxQ6x4EXdy/PO4AcAc06KLdinPgOxmOgF0uBPGAnxq4vQw5QfEvnfxotm
 N1/iacnp
 OAsVIrCSNzRbjStN57Tea2ElvtitrlNyGk0JFqzST207uNXWot354wrNgPakpBTnmI3n84pxMFYh7RUdMT1lCry3XxdFfnVq66M9VE8nHg1uOMcAT9xNYRZe1YxEaJe5pkQ6rEO57vGkbpBkOo91hNGH9gWcHR1opvMm3gw4maY63+qKoRETvoJq6Eoi7CzlAyYzKPc+AArxUdXV2Jcf4YsNGUqIxVWG/9qKhLz6cRd56xJk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a change_protection() flag for changes that only add permissions,
so that MMU notifier users can keep their mappings and fault in the new
permissions later. mprotect() sets it when the new VMA flags only add
read, write or execute permissions, or VM_ACCOUNT, which does not affect
the page tables. Any other change, such as a different protection key,
is not an upgrade.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6af3b7008f1a..001829a61405 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3585,6 +3585,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
+/* Whether this change only upgrades/adds permissions */
+#define  MM_CP_PERM_UPGRADE                (1UL << 6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 84bcfe0281d3..8c0fcd10f5a3 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -767,6 +767,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
 	.walk_lock		= PGWALK_WRLOCK,
 };
 
+static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
+				      vma_flags_t new_vma_flags)
+{
+	vm_flags_t old = vma_flags_to_legacy(old_vma_flags);
+	vm_flags_t new = vma_flags_to_legacy(new_vma_flags);
+	/* VM_ACCOUNT does not affect page tables */
+	vm_flags_t mask = VM_READ | VM_WRITE | VM_EXEC | VM_ACCOUNT;
+
+	return new == (old | (new & mask));
+}
+
 int
 mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	       struct vm_area_struct *vma, struct vm_area_struct **pprev,
@@ -847,6 +858,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	vma_overwrite_flags(vma, new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+	if (vma_flags_is_perm_upgrade(old_vma_flags, new_vma_flags))
+		mm_cp_flags |= MM_CP_PERM_UPGRADE;
 	vma_set_page_prot(vma);
 
 	change_protection(tlb, vma, start, end, mm_cp_flags);
-- 
2.51.0


