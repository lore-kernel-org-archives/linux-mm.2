Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94090606D812
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AtWih/Q5;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/1ksPkT9;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=AtWih/Q5;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=/1ksPkT9
Received: by kanga.kvack.org (Postfix)
	id BC9596B05BF; Thu,  5 Nov 2026 12:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B79866B05C0; Thu,  5 Nov 2026 12:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67E86B05C1; Thu,  5 Nov 2026 12:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 874346B05BF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:00:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 27452140B5C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:57 +0000 (UTC)
X-FDA: 85401680154.01.1D0A80A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8D8BBA0015
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:00:54 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AtWih/Q5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/1ksPkT9";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AtWih/Q5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/1ksPkT9";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLnVsJjCToHG/C28VTmqNBcIFpk1g6vauHuX2+bvyeo=;
	b=d3Et8IC1YD/dzIM8OnjmxsPGwYmIxltP/uBc3H1aPhjy2JhDenJtSs2rqNmTtb4paq7ect
	sblvbm2odkRdGKgPeQcR7nba5LBmx7do2hNJFptPZlIBlyXpq3AGkynksW1Nk0DUDD1J09
	KaLLqCjRnSSSOLU6yalbL+kOsaJ8clA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898055;
	b=gYcfVHAKgpHNCvSEK67XDiqvoW8FPH4B7WyZlT62FwvTs2n+PS8ZEOuVKQ5gZabjWjbtpl
	9sGrwBA8tEeHTqdRq7p2YHojoHrcS+qA6AiCRNqi0UoX8szAKQXAdgTcnWDz6WAAmiGwhL
	LvBI5kD3/6+8IdttmZbedLvUQx+3j2U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AtWih/Q5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/1ksPkT9";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="AtWih/Q5";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="/1ksPkT9";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf25.hostedemail.com: domain of clopez@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=clopez@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 32F211FB3F;
	Thu,  5 Nov 2026 17:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLnVsJjCToHG/C28VTmqNBcIFpk1g6vauHuX2+bvyeo=;
	b=AtWih/Q5UNeIcyR295m20gTBxLNQQlEW/6jV44r/WyqnpGBlFrxfzrmeI4eK5R/FG9mP8B
	5UwO65a5cCQ1VzYek0nbWAcmTzFXkXz50rqaQTjIh5y0Ds3XEVC9sq3K8x0IZsLdslgQ+1
	YvtRNvhR6Xxc9QjvOip6VNdLyvZvEFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLnVsJjCToHG/C28VTmqNBcIFpk1g6vauHuX2+bvyeo=;
	b=/1ksPkT9jyto6rEIVfPDgN8Dim3k3Ljbfr+TqqyZUZIMXx716QVdLySR0RyEa8lGTYD3/4
	QsAvYC5IPlJGx8Aw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793898053; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLnVsJjCToHG/C28VTmqNBcIFpk1g6vauHuX2+bvyeo=;
	b=AtWih/Q5UNeIcyR295m20gTBxLNQQlEW/6jV44r/WyqnpGBlFrxfzrmeI4eK5R/FG9mP8B
	5UwO65a5cCQ1VzYek0nbWAcmTzFXkXz50rqaQTjIh5y0Ds3XEVC9sq3K8x0IZsLdslgQ+1
	YvtRNvhR6Xxc9QjvOip6VNdLyvZvEFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793898053;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wLnVsJjCToHG/C28VTmqNBcIFpk1g6vauHuX2+bvyeo=;
	b=/1ksPkT9jyto6rEIVfPDgN8Dim3k3Ljbfr+TqqyZUZIMXx716QVdLySR0RyEa8lGTYD3/4
	QsAvYC5IPlJGx8Aw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C24CE134F6;
	Thu,  5 Nov 2026 17:00:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id HMEkC0K27GqWRwAAD6G6ig:T2
	(envelope-from <clopez@suse.de>); Thu, 05 Nov 2026 17:00:51 +0000
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
Subject: [PATCH v2 1/9] mm: fix eager write-bit restore for write-notified shared mappings
Date: Thu,  5 Nov 2026 17:49:58 +0100
Message-ID: <20261105165004.2663799-5-clopez@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20261105165004.2663799-4-clopez@suse.de>
References: <20261105165004.2663799-4-clopez@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spam-Score: -12.51
X-Spam-Level: 
X-Stat-Signature: 78pnjepdzc91xyh59iqs95yyzdodt6d8
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8D8BBA0015
X-HE-Tag: 1793898054-828261
X-HE-Meta: U2FsdGVkX1/xX5Q83UyKetzurjDSvSZRhjvP8md2Uzwxp3qq3CG4k/qJus2y8T3r998HTKB+4zPlUnFk3cb0ud9losJfRFbr5FSIaNax5UYI9CTHt/QbSJqbSrmt1uaKP1fAUWHABScLS5Jccy5LpfGiAppjw3hqNMA5Kb5vQaBTedNelmOjWJI88Ih1ha9YkCq++YX2sdU2i/UKporden0T0eq/ZFOHpFCdGLgxXoCVP2SAHSeHMLxep195aImSyx6ZjgW0Uo/z83iLUS4fjQteqXMnvYntDCxC/yKlXUHR/UOtEDTFWknDlZCQibh4XCG0wv8K9/AOf5m6QVVxQPldTw09e18vPDwWWoeLjD1VGDNoPl2UhVmLR+w4n/yWA2Au3iZGh84nnXAN8Hbe6CcDMGeqiZwWhcvmXqbx+XFq0xsIC6bOrtQce3fsO7TO1FN69k/IP+Y1f4LPy5U3Jq6qNzfoxeSFm1k321n5hSo3uqwHurz9L5LxkEGOxy/YyZ8EFw3qJ3Gp3LVoaYUCJrxlzn9qRJ92At/n82cXCaCYc9bwBE3yJ4Ck1YYSRsxYRl83HBkRiSL1RpBeT2RkJH8j6iRHRp9Mdb+J3vu0cG73q3JYUCwGT7qfWCzGuMCYXc0PlC3Dn6XTfRhgkRmpuLiiB/wsnYo7b2aBo4Is7vEaksnY5/OG/bQIo+F+NUit7PSv2Hfcc/T4LvAR8VfggPQeW7G7mPJeXvNBp8fKKNpwmnzu6FVZa9XARxgHx1cW5yyQ2a331dVdIYRcnqSE+Kxzk0J1gCrWWMPjpIIdLhdErJIgesDnuMcJQ5mDMR/fMUc3f1e1N7zPvGGB/dsBetTUvLo9AHA4OhGXgq2fmu/+kx7TnwX9Ta7BwcYYba7zvA2Pjed3CKzrFWxieC21n4YD0tCQS0oxo/9dOSq8rjXufUARU5/NSXvDGSy1aAONtpLs/Vpy8sJTJ9pi+fL
 5KBJDgSs
 +mnhbQIblq790KMWdHDBvRNOMzBSw2teGx3w/KI2lbEkwFc802SYeXt0iTdTyX1FW4cgdD67JyH5Jyuq4m0A4k6BD9B3P9fB6iylPOXU/a1eHrH46zA9RUZPYc/KESHlZ6roIPkFyWtMkYX00Oj37OPP/QaFfYBIcVzLsmCBJ98TgN8xP4P+oH3+2LXGcQlEC7vTpV6E4TfMu2tyW+dG+I0bHW11ufr5q5obqxEzDQITpKLmBE4MZNTiY6SsjlfThhsqxZtc8GMZxHd2E1eqW/gGiu4kbFJ2HSkxQx+QFpESokUWQ5Dc6qwH7p7GhBiZ27lbP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_protection() applies vma->vm_page_prot, which lacks
the write bit for CoW and write-notified mappings. To avoid
needless write faults, callers set MM_CP_TRY_CHANGE_WRITABLE when
vma_wants_manual_pte_write_upgrade() returns true, so that entries that
can be written without a fault, such as dirty PTEs in a shared mapping,
are made writable right away.

For shared mappings, that function passes vma->vm_page_prot to
vma_wants_writenotify(). Once writenotify is enabled, this protection
lacks the write bit, while the vma_pgprot_modify() result it is compared
against adds it back. The two never match, so vma_wants_writenotify()
returns false before checking for soft-dirty, uffd-wp and writeback.

As a result, write-notified shmem mappings never get
MM_CP_TRY_CHANGE_WRITABLE, and their dirty PTEs stay read-only after a
protection change. For example, commit 931298e103c2 ("mm/userfaultfd:
rely on vma->vm_page_prot in uffd_wp_range()") made uffd-wp unprotect
set MM_CP_TRY_CHANGE_WRITABLE so that dirty shmem PTEs become writable
again, but this never takes effect. Unprotecting N dirty shmem pages
still leads to N faults that only set the write bit.

This dates back to the commit in the Fixes tag, which moved the
equivalent check in mprotect_fixup() before vma_set_page_prot().

Fix this by passing the protection recomputed from the VMA flags, as
vma_set_page_prot() does. Note that this is a performance-only fix, as
the write bit is restored on the next page fault anyway.

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


