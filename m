Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EB67606F881
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ASjfoLYK;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AG6NBTHW;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ASjfoLYK;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AG6NBTHW
Received: by kanga.kvack.org (Postfix)
	id 3A3EA6B05B5; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E1E6B05B6; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5A46B05B7; Thu, 12 Nov 2026 09:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF87B6B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:25:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 46094A821D
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:35 +0000 (UTC)
X-FDA: 85426690230.03.EB15545
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id 17CDA160010
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:25:32 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ASjfoLYK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AG6NBTHW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ASjfoLYK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AG6NBTHW;
	spf=pass (imf08.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794493533;
	b=pVwLNXlIOTddwCxtUV64pUWH87vN9KozdE0BD9s4FZ9W7KRj0bJvhjE5wmBj0kVgioM+SC
	gnHfSwJNO3r5/4HjEDBTgT6PAzxo46a5C4ZzsZJAuN2a4p9Vg6QVJfGdUo47mN8qKdGrf4
	gUIPm4GvIF/PsMH9eMSSr1lB7i+4TY0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ASjfoLYK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AG6NBTHW;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ASjfoLYK;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AG6NBTHW;
	spf=pass (imf08.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794493533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rarWhYCLUgWlwnaEceP0km2CWzz/RwE1HqqRhAgWRRk=;
	b=tXvpdMuQ5ikafhQFaa/wzX0H70ZHGXrfAlIP+wQ2PD4YwuiH8Ti7Bg4jxecCFKG3wgjO6c
	+5ADKjkr7z29U/VloBAAq9x4GdqyoZ0u8XvxOi+7ZDQrwAeMpuQclWNe+jIyIuj6bb9JWi
	i3zSmPiIR6RjaweYLlq7h6avu9TPuyQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CE1611F7B9;
	Thu, 12 Nov 2026 14:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rarWhYCLUgWlwnaEceP0km2CWzz/RwE1HqqRhAgWRRk=;
	b=ASjfoLYKq8P16CL79W5QgBRozDfCvHzn/EUBfLPNx8F2lufVQ5iB2IBGuN+qYl0e/ALTYZ
	++i8EkuIRmnFo1YSjCzMaT2/UQ2P1nmDuzcP9scj0NkDxymYz5MIt89/Ilm6QhCrABS8/7
	KKyONF65hOwS0bjJ+rN7kS8QSfff9A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rarWhYCLUgWlwnaEceP0km2CWzz/RwE1HqqRhAgWRRk=;
	b=AG6NBTHWRnF6+79ulbExDm0U1UIZBd1in7IoAWxmZUPNiBDjAmbSNt3HovhqSlrQXcHaIe
	fuxhOHi8BiaCzqAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794493531; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rarWhYCLUgWlwnaEceP0km2CWzz/RwE1HqqRhAgWRRk=;
	b=ASjfoLYKq8P16CL79W5QgBRozDfCvHzn/EUBfLPNx8F2lufVQ5iB2IBGuN+qYl0e/ALTYZ
	++i8EkuIRmnFo1YSjCzMaT2/UQ2P1nmDuzcP9scj0NkDxymYz5MIt89/Ilm6QhCrABS8/7
	KKyONF65hOwS0bjJ+rN7kS8QSfff9A8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794493531;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rarWhYCLUgWlwnaEceP0km2CWzz/RwE1HqqRhAgWRRk=;
	b=AG6NBTHWRnF6+79ulbExDm0U1UIZBd1in7IoAWxmZUPNiBDjAmbSNt3HovhqSlrQXcHaIe
	fuxhOHi8BiaCzqAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A294E134F4;
	Thu, 12 Nov 2026 14:25:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id w9GzDFnM9WoAPwAAD6G6ig:T2
	(envelope-from <clopez@suse.de>); Thu, 12 Nov 2026 14:25:30 +0000
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
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Feiner <pfeiner@google.com>
Subject: [PATCH v3 1/9] mm: fix eager write-bit restore for write-notified shared mappings
Date: Thu, 12 Nov 2026 15:20:30 +0100
Message-ID: <20261112142039.907090-3-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261112142039.907090-2-clopez@suse.de>
References: <20261112142039.907090-2-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Score: -12.30
X-Spam-Level: 
X-Stat-Signature: 7yr6dzz414it7brmug3wp3cn9obs4ggs
X-Rspamd-Queue-Id: 17CDA160010
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794493532-553719
X-HE-Meta: U2FsdGVkX192/zqJT/ETQNhJFtV/uynZZf4Va1oF0K/cweNJbD8Fyt5jo+zxdVkyCY6enJjYwh3ICkpZj0oi7eLlioA5a5+JT1tCXU0wjQoToESJcRLwXGrs9nYFTvl+/DNRXoRIXgbkx0hVWxaOLFL4LtfUZ+pMu0PfX6TYhaZknczrnzFogIKXeb4oPqyeE7nYGCiz5iNRrc5ZosvISj6SzKib+LeAD/qqDERJmNEJyorZn/m+2c9Zhv7MffJcrP3KeedvtpCCBRVvBDrjr/bzagx0v+iEscKzKJ1R2sibICVwrJay1KInCZjQaeZzFaidGfLmJskCb/FNotyVCatCYkpiStJKOnwLV3+/9nzFHHRDEVNJApxOh4pO5muwYGZkeLzZt8EsmGLk59EUSuAKtaENaJY6Igx++ySkEcFFoe2uoHFqVpgdjd9T1Imir3b0jrHOqeDR9Q7tw7I+G2eeI6HRR6pjwopdvoymFy54zqf5a1LGChykJBWBlbBW2TUt4IM1KLea6X6bIhQPXkMz+IQFLnwv8+hMi1MCverIMZ5Oi35xMhnJcEKAyQVXy+Kkwzhq8UamWYJYxjEoRudWmxXlaNCEqB11feLF6n1BgU4Jj/VGzW51+kip3HPLUVpPVRWAZJFtM1sjYxcMWbFAhy5znoF/yi/eEuJDGUaHP3CxH9BB7eQbxvUhSFNQyuUrdMiQv2qgY7yXQxUk3lfqCKKOWM7u39y1PiI7X41aNhMJLVFuFqGMqglFP6Ga+ltajRZPeXOE5PxWOwm2wpESjNtPYW2kN1FDBjuKpBohKpsjkqlj5tqCQKDKJkSXuFV+OGMujRa95WSnVm3juRYpADJL7CgAQkaWSLc04Vk3o8ZF7U1zkTNZGnVJ705ZX57fjroxVXY8zYaW6VSEPsH1qaVNFJW2PXRNPzxKqBGMjCrNARPdGnnSdv1dhNWzLoNbWM03D7Vgl4jZx0n
 Bgf2j1EE
 Tlwu5WpQrk5BwIFdVR3Nq5GeAr5MoSc4owzfTO75N8UqD6RvTf0S3LxnvIPTgVd4tObynu644IXmmaX1AhrtEWn9sy5COBBtgflERA+T3EWKbsQq7KfrvoX5ld6E5+BiNXiFQ0e+YmeR9+tr2zpmkNcoCQyIYFaFEgLB5QNZAkdTMm4dkODa8CZrCgu8frUA1+/C/P39Ky0MV4rD37phP4jvp+dtROyqzNkDRjxIvY+6tt3AIW3TwvcuXcr2hnxN1fz/ecPMPjmTfaaPCTEFM0SdawFj+LQ3F5Xna9iXvytNV8TtqTShObZEJ4C4xPhlhUDRL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_protection() applies vma->vm_page_prot, which lacks the write bit
for CoW and write-notified mappings. Callers set
MM_CP_TRY_CHANGE_WRITABLE when vma_wants_manual_pte_write_upgrade()
returns true, so that entries that can be written without a fault, such
as dirty PTEs in a shared mapping, are made writable right away.

For shared mappings, that function passes vma->vm_page_prot to
vma_wants_writenotify(). Once writenotify is enabled, this protection
lacks the write bit, while the vma_pgprot_modify() result it is compared
against adds it back. The two never match, so vma_wants_writenotify()
returns false before checking for soft-dirty, uffd-wp and writeback.

As a result, write-notified shmem mappings never get
MM_CP_TRY_CHANGE_WRITABLE. For example, commit 931298e103c2
("mm/userfaultfd: rely on vma->vm_page_prot in uffd_wp_range()") made
uffd-wp unprotect set the flag so that dirty shmem PTEs become writable
again, but this never takes effect. Unprotecting N dirty shmem pages
still leads to N faults that only set the write bit.

This dates back to the commit in the Fixes tag, which moved the
equivalent check in mprotect_fixup() before vma_set_page_prot().

Fix this by passing the protection recomputed from the VMA flags, as
vma_set_page_prot() does.

Note: this only affects performance, as the next write fault restores
the write bit anyway.

Fixes: 64e455079e1b ("mm: softdirty: enable write notifications on VMAs after VM_SOFTDIRTY cleared")
Signed-off-by: Carlos López <clopez@suse.de>
---
 mm/vma.h | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/mm/vma.h b/mm/vma.h
index 3fc3b47a954b..e83700e248e4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -589,6 +589,14 @@ int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	      unsigned long addr, int new_below);
 #endif
 
+#ifdef CONFIG_MMU
+static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
+{
+	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
+
+	return pgprot_modify(oldprot, prot);
+}
+
 static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma)
 {
 	/*
@@ -596,19 +604,16 @@ static inline bool vma_wants_manual_pte_write_upgrade(struct vm_area_struct *vma
 	 * if we can't do that automatically for all PTEs in a mapping. For
 	 * private mappings, that's always the case when we have write
 	 * permissions as we properly have to handle COW.
+	 *
+	 * vma->vm_page_prot lacks the write bit if writenotify is already
+	 * enabled, so pass it with the bits restored, as vma_set_page_prot()
+	 * does.
 	 */
 	if (vma->vm_flags & VM_SHARED)
-		return vma_wants_writenotify(vma, vma->vm_page_prot);
+		return vma_wants_writenotify(vma,
+		       vma_pgprot_modify(vma->vm_page_prot, vma->flags));
 	return !!(vma->vm_flags & VM_WRITE);
 }
-
-#ifdef CONFIG_MMU
-static inline pgprot_t vma_pgprot_modify(pgprot_t oldprot, vma_flags_t vma_flags)
-{
-	const pgprot_t prot = vma_flags_to_page_prot(vma_flags);
-
-	return pgprot_modify(oldprot, prot);
-}
 #endif
 
 static inline struct vm_area_struct *vma_prev_limit(struct vma_iterator *vmi,
-- 
2.51.0


