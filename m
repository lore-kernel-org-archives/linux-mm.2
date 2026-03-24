Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E39FBF54ACE
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ACDF6B008A; Tue, 24 Mar 2026 11:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55E1A6B008C; Tue, 24 Mar 2026 11:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474406B0092; Tue, 24 Mar 2026 11:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3697B6B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:44:11 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0EA941A02CD
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:44:11 +0000 (UTC)
X-FDA: 84581377902.11.F0D597C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf28.hostedemail.com (Postfix) with ESMTP id D1D59C0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:44:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V1WhEkWc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JFbqxGSe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NE0HPANI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hKLOksps;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774367049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hXvQifaGZb+FBFXUSPZxP9DOLUBRewc3OEREji2KlYo=;
	b=avsEBty77i7CPRfg4ysObzkxjKxp95NLelsVEN6EeNR3W6MBbIuBEZGxWbXiJyFQebOac8
	xIQU6e49D+KhnMOSmb8bZp9Ewsz+xqMqHRI0KKhbI8rOniNyEHlVDe2Tm8v8H0xCuiHELX
	oZHAMvAklgdyA2OCi8pcooA9+Z2AsTQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=V1WhEkWc;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JFbqxGSe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NE0HPANI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hKLOksps;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774367049; a=rsa-sha256;
	cv=none;
	b=8IUsFLpVLzzcLnW1kSYortHX1aNUxOSflgV8sfeKhN1vg4AturnOp/37hqz4ZnBZrs9Q7u
	JlflgNc5oCEqNEMiAmkHC9jSWALrUGbcT88PJenxbVGk7jt/6okkO6XTTDFsVIUMwZr7a7
	XMT/aDtD35CqiTz+ninFeYFh8mZvvEQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2F3D55BD53;
	Tue, 24 Mar 2026 15:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774367037; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXvQifaGZb+FBFXUSPZxP9DOLUBRewc3OEREji2KlYo=;
	b=V1WhEkWcz8mKBQSQ0Vncn1mFQeVv5C+RqWsIzMSenal6c76cnS1AApeMxswpoP1vgni8Vo
	ydOTNiP10BGRx+6moRpjUF+GWAzgFtHHOn/rP81KQccsKfu0PZKV8ut3I1cS53AqPacZf3
	w0sF2uqH72PFRYihdnXSI4GN4qElNII=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774367037;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXvQifaGZb+FBFXUSPZxP9DOLUBRewc3OEREji2KlYo=;
	b=JFbqxGSeuAJyjoHvWr4/NBqbCfq6eODPya7wohNBpS8I/3ZekRrvoDB2tZUDMzmAFaZje1
	RQPpx4j5SZD5gZDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774367036; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXvQifaGZb+FBFXUSPZxP9DOLUBRewc3OEREji2KlYo=;
	b=NE0HPANIaJZz+ZWdbmFPMMnqRr2wz91rgEFEVe7D9MP6qypP0hNPtS0fwY0sg5inBBhn36
	B2EoTaYDCryHyRO4A+IDWTpyfGMIAMC+6kpEcYW8/nWMeyxfl9n71Z+uJLTM5Bape/jVSt
	Zm0xBSI4h2TyVuXJHPHxn7PA2nG9le4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774367036;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hXvQifaGZb+FBFXUSPZxP9DOLUBRewc3OEREji2KlYo=;
	b=hKLOkspsi0DrbIpnk9LaF1jaOJtwTHvDvAf0/I3QvJs2bBj8hnydR9oFcEaibzqvYpsuNG
	oAfF5ptICRWTleCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 5DBEA43EF5;
	Tue, 24 Mar 2026 15:43:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UNSaEzuxwmnUNgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Mar 2026 15:43:55 +0000
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
Subject: [PATCH v2 2/2] mm/mprotect: special-case small folios when applying write permissions
Date: Tue, 24 Mar 2026 15:43:42 +0000
Message-ID: <20260324154342.156640-3-pfalcato@suse.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324154342.156640-1-pfalcato@suse.de>
References: <20260324154342.156640-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D1D59C0005
X-Stat-Signature: 3a59phmdiskykn3gad348mumidr1pncm
X-Rspamd-Server: rspam06
X-HE-Tag: 1774367048-59938
X-HE-Meta: U2FsdGVkX1+8hgOghUw7PHeAdwBSQ0D+tM8oaP9DV+hhXDi6Chx8RsgeAtnxeTR7s/4oOKvnviSpMq2H+cpJ7E2U5vLyAY7Ezr+K/YycTAij59DUoNV0G46xt1ymah5EKYWKKHA6wqp6NbMhzZCI6frkLW3pxy6c8s1yAuDeKzUSG0CxRCNcgjkxsWx5nDKZXiwK/f935WgHzvkexQwOAG+mekqJgtgecNFVW2h4tmSELwizIeOlUaSUzTL3eXtdcJQNTACaoybGtcL+t4dFdKewh8ZHWQgOScDuA+OaDn+PWwVVCUvwHlL3zUqiFnZs4qE/J/Je41kGFxr+JJz3eEVjJS0wDZcRaHcdZj/ZTHFoh9T94GmmC/Lx7v+Qwp+Ydpmn4N785VAAXkqMw/FFmakj7+OWVB9OwbV2ruERlJ8xOL1oeh39QDy9hlQk5n5v1/DD7HgSPjgg/sxHm9E7QsX14jUP6chwKBZgDC/CLSZG/Xc9k5u2abR2TS2ntN2rwXVLT6ituAmxIVnJx+M79Wcy1+BGWyI0gRoTag/dqv0w43++GZUqBWiz+AGEW78uW6bRf4In/yaDzSoBX5uVsN+bfizuX8UXYt1FBboHbkpaJTNFCBLDrE1RQJx5OFqk3IDn8VYLZHPm7fTaA7XVvdkZpHINsjUnuC7i5XTu5NlHSwpiLlSI5lQFD7HomQDBeFZ0/Lopemfbg48D64xy4UMVkG5Xv357ZYw0Xr2QyUwzzGcwxJuOrOjEkbulSMTFMxFM3OlZMycZobvvUbNcc2YeMlJHVG89bw48cQm/YITFlM6/fCyV6FtlQl96cgV4vp570Kf5nl7Xqx5UTnkLnXePzKPHXGr2MwHHHkPx41TC4pv7ylOkrRGpWMlpbV8wDpt1IyROM4s/RaMTIb3e3JHo3N8OWLHFw8UqtisUdJB5m9dcPl3CccAD5c9qpHVUAvgccycAyJemK6whdlt
 K2N+CVuU
 t1lJPkbcOmrlRo38GtDi20rOKlys7oOpfVUAqUyGRSDMJuynPvdteIKdrxmzVUVHj92MlnXkINDqamrRN+wA2/dFlUjzXJBvQWmabJUxYepamd1kNUqzwPvKs86tf2GIoi3T5B8CAq/r+iRtM3k53DREC3dMqN/ySRiE+pw4E2fRLLK822jok1KnVKzkj4m6CVv2ubw39BpU4DMdX1D2vVMoPt9yLhM7TBKfX0a88uH2cedE3Ho/2MeD1GMbuqFivL30qbTAMPrR83CGr3Ay5dTV5dgAQ/bjKqHsB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The common order-0 case is important enough to want its own branch, and
avoids the hairy, large loop logic that the CPU does not seem to handle
particularly well.

While at it, encourage the compiler to inline batch PTE logic and resolve
constant branches by adding __always_inline strategically.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/mprotect.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2eaf862e5734..2fda26107066 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
 	return can_change_shared_pte_writable(vma, pte);
 }
 
-static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
+static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 				    pte_t pte, int max_nr_ptes, fpb_t flags)
 {
 	/* No underlying folio, so cannot batch */
@@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
 }
 
 /* Set nr_ptes number of ptes, starting from idx */
-static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
-		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
-		int idx, bool set_write, struct mmu_gather *tlb)
+static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
+		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
+		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
 {
 	/*
 	 * Advance the position in the batch by idx; note that if idx > 0,
@@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
  * pte of the batch. Therefore, we must individually check all pages and
  * retrieve sub-batches.
  */
-static void commit_anon_folio_batch(struct vm_area_struct *vma,
+static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
 		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
 		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
 {
@@ -177,6 +177,13 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
 	int sub_batch_idx = 0;
 	int len;
 
+	/* Optimize for the common order-0 case. */
+	if (likely(nr_ptes == 1)) {
+		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
+				       0, PageAnonExclusive(first_page), tlb);
+		return;
+	}
+
 	while (nr_ptes) {
 		expected_anon_exclusive = PageAnonExclusive(first_page + sub_batch_idx);
 		len = page_anon_exclusive_sub_batch(sub_batch_idx, nr_ptes,
-- 
2.53.0


