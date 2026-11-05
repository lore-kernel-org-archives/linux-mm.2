Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A197960A2607
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FyiaQi6Y;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=P556lgPy;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=FyiaQi6Y;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=P556lgPy
Received: by kanga.kvack.org (Postfix)
	id 7F8126B05C3; Thu,  5 Nov 2026 12:01:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0136B05C4; Thu,  5 Nov 2026 12:01:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BF086B05C5; Thu,  5 Nov 2026 12:01:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3FE1B6B05C3
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:01:01 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C3F20C0B6B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:01:00 +0000 (UTC)
X-FDA: 85401680280.27.DD7991F
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf04.hostedemail.com (Postfix) with ESMTP id BD08640012
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FyiaQi6Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P556lgPy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FyiaQi6Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P556lgPy;
	spf=pass (imf04.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JKTmXrXjtWa/G4eyzga8yYon7SkQ1CbbiYS7NLaZQSE=;
	b=TFFlQzYataUC/+eczbb8M9oIl6ibzCqEXRTjdI3sRPVtplhDtGCoeqz+1jFZ3fYva5SK/F
	XBfQLxquj73tMwaopts68VWVRiSSY9EzV74k2P9iRigYSQyOHDJ21PH89X5WKUTAHpsm1t
	vT/AUURo7xNN+zS6lsPOqX6XzMuxSEY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FyiaQi6Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P556lgPy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=FyiaQi6Y;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=P556lgPy;
	spf=pass (imf04.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898058;
	b=NJD6G0ohtx3xNq1ObJA9s/xpBA2Zu61NH9c9TAHDA9B2ZVeuJY1+wN6P8WQxcGh9gQJVfS
	pLe+SiW77kKcxyiWzoORRO1FHlwIIy055/GlxzhQg2t4SzEleD3T+DRYoN06VEg3l94LDo
	F1nh9giT0AA8lOsiMbyjb+u5PmZWNII=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A1D701FE8F;
	Thu,  5 Nov 2026 17:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKTmXrXjtWa/G4eyzga8yYon7SkQ1CbbiYS7NLaZQSE=;
	b=FyiaQi6Y22rH29a1RDsHKP1SPcP1S1oFAeAS3xeGQfgeA9N//7ADuXokQdk4OFMCztHkgr
	ODWk2HqyRQocNMJK2K29NCzbfvzJH+R4brhwlcgKg2GP7+R0dcOWewn/PWpaDL3l95hIFQ
	iIB3sgwsZluA/aODCeXlO3pk8d3z+8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKTmXrXjtWa/G4eyzga8yYon7SkQ1CbbiYS7NLaZQSE=;
	b=P556lgPyQn3q30w9Fgf4cK2jzW9bYpuofte4VAKU44wYJhKO96WGioywB7j7jlZ23FQG8X
	hiQJvKfqZkM6zBBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898057; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKTmXrXjtWa/G4eyzga8yYon7SkQ1CbbiYS7NLaZQSE=;
	b=FyiaQi6Y22rH29a1RDsHKP1SPcP1S1oFAeAS3xeGQfgeA9N//7ADuXokQdk4OFMCztHkgr
	ODWk2HqyRQocNMJK2K29NCzbfvzJH+R4brhwlcgKg2GP7+R0dcOWewn/PWpaDL3l95hIFQ
	iIB3sgwsZluA/aODCeXlO3pk8d3z+8g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898057;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JKTmXrXjtWa/G4eyzga8yYon7SkQ1CbbiYS7NLaZQSE=;
	b=P556lgPyQn3q30w9Fgf4cK2jzW9bYpuofte4VAKU44wYJhKO96WGioywB7j7jlZ23FQG8X
	hiQJvKfqZkM6zBBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5A681133F6;
	Thu,  5 Nov 2026 17:00:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T5
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:00:56 +0000
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
Subject: [PATCH v2 4/9] mm/mprotect: add MM_CP_PERM_UPGRADE
Date: Thu,  5 Nov 2026 17:50:01 +0100
Message-ID: <20261105165004.2663799-8-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -12.30
X-Spam-Level: 
X-Stat-Signature: zxgdankftoc4qnwmxzczfpponcfnoh3r
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BD08640012
X-HE-Tag: 1793898058-341640
X-HE-Meta: U2FsdGVkX1+VzqvP4V77xzxOaCAsldwkyhwhdX1/7A21IEffQQLHvbw6DBFqL6Ni4qaIUUJrYc1bnV3a0AjsDVW2lQo0CdKMLSzOhkqLmmjaY8FrJTkuib9CmjkjP7bGBhdY4Y5t3H15mgbATUgukyJcfQ64posyqRXAlKp9yJIWZSOMKKoH6zPUWcvlIWKBi04Oq0booWPgAXxGLq0bsQ68cYqV5OpefhYmaI/om5KYds1USc4Vj2ilVNwZiDE2G+Dq843ZAbBriEKapsG1UK/In9NTSRyLThV1/GnrPnO+upufpujXdkQO1mHkN49Ubmo/oVYcTfUlv3ASYkPxx41bWxsE3Syxj+G3FwPJ5rYlcZuJx330SKcD42wwxTeacfHU2+aPRcHULpcWLyPUdOpq5BshMlvSNm4JciUrhaqdbxmkegtrnsT4xMAP995EOrh1rsJX4gwWwy1d/eJZPLBgJLmRxVEi7qPHur9c6Yh2fQHm0Jzbu8t/v9xzl8h1uLMQ/edacboPvXf5jhY9rAmJulMXfNr5K2lTKZ2Ix6aEB5xE8mmnYM+EKCrfG3tqn5dS8WbcDQ/hh/T6by/MuIBlH1BAF6KIr4MFbKFM/yZoB9Tdf+7Ocfao06BUWEl++SBI9GvYEURPzKu1de+Og1zMMUBzIOhif2ppuHLyxucV7ACOX9n7Ctn+GCVC04RfWOkLfdOcJGlMxfS4dKaQN12uYoqBYRFR2nHx8FR8Y8946dfXu/Pfrw9Sn57BvIfMyfeXMn92qQSEm7WgVe+4EUyFY+zWlyN6GCpEl0V9kGZY84bSLfAOONDwbJy89yE3G/PaduaCu7RAXHyp6Xkfr+82OnQaQe1fgrZUeo2gKBhzfrT60JSdIqp4XE5mc6KEVBn0rbDvbRRkRnA7A8NhOp48ZYRhTqujBmJyBdavE44349f1AWRMad/9TtEX/yySpmlYrbSN30Z2wTnO5aE
 67CZ/+j0
 UMUitTC3xGofD0cBfCBCOuEOc+Nveyyjy/+lxrPzYadnE2BIS+yIDCdcD5QCi5loqa7j+mrrgmV4LkHMhYebEXP5yAySVNI6S6AvewEMQTtfciOfR8nzWy7+YOLOMQr5uNoLzMJ3yWHwOupPSfolTixle+q71IViG/OCNc8hyL53TIcGQDfYZH52rMuLXMp7GaOuWbZ0mt1ANNJodMwCO6S6UcBqmqQvtroVItVjPzIYQOLcBCV4/Ry2yQG7ZRjtc7JgMzvH2LkQO8tEAr9yuVP/TyZ7LSOv745CpXLZ1V0u8lmQLR7NwxutbbCCv4T18/9tgEH7+V2J10Eyjli0cJSt706h65EImbdy9XfZD5CQDgmd9QQv1ME0MIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a change_protection() flag for changes that only add permissions,
keeping the PFN and revoking no access. mprotect() sets it when the new
VMA flags only add read, write or execute permissions. VM_ACCOUNT may be
added as well, as it does not affect the page tables. Any other change,
such as a different protection key, is not considered an upgrade.

This will allow MMU notifier users to perform optimizations, as they
can avoid invalidating PTEs whose permissions can be faulted in.

Signed-off-by: Carlos López <clopez@suse.de>
---
 include/linux/mm.h |  2 ++
 mm/mprotect.c      | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 9f167950926a..dddbd76a2760 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3581,6 +3581,8 @@ int get_cmdline(struct task_struct *task, char *buffer, int buflen);
 #define  MM_CP_UFFD_RWP_RESOLVE            (1UL << 5) /* resolve rwp */
 #define  MM_CP_UFFD_RWP_ALL                (MM_CP_UFFD_RWP | \
 					    MM_CP_UFFD_RWP_RESOLVE)
+/* Whether this change only upgrades/adds permissions */
+#define  MM_CP_PERM_UPGRADE                (1UL << 6)
 
 bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 			     pte_t pte);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 754333698c1e..683131c9c4a0 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -756,6 +756,17 @@ static const struct mm_walk_ops prot_none_walk_ops = {
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
@@ -836,6 +847,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
 	vma_flags_reset_once(vma, &new_vma_flags);
 	if (vma_wants_manual_pte_write_upgrade(vma))
 		mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+	if (vma_flags_is_perm_upgrade(old_vma_flags, new_vma_flags))
+		mm_cp_flags |= MM_CP_PERM_UPGRADE;
 	vma_set_page_prot(vma);
 
 	change_protection(tlb, vma, start, end, mm_cp_flags);
-- 
2.51.0


