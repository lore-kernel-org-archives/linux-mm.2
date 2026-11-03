Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17A01606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 06:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=PAq6fX1Z
Received: by kanga.kvack.org (Postfix)
	id 563976B05BA; Tue,  3 Nov 2026 01:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5399C6B05BB; Tue,  3 Nov 2026 01:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42AD76B05BC; Tue,  3 Nov 2026 01:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 243166B05BA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:17:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C01DA1A04D1
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:15 +0000 (UTC)
X-FDA: 85392800430.18.B838475
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9230040002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 06:17:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PAq6fX1Z;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793686633;
	b=rn3lB3pzQWVFW0cxw8WV5NlofxO0dTYuE16nt9g+GXlTXjsOIvlCxe30EOtnSXOiHwV/0b
	0loSs9Iu4lE3q9YBl6Se5Ksmnsoj9ioAkkHLk95ZlbGprQFopKGt6sGH3qRh8mJYjlDBwv
	ox4/nySbkDG3eR1G3VYnMWfx7ES0y0g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=PAq6fX1Z;
	spf=pass (imf01.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793686633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gobpz7G2pF8eCW6Qy4GETlwPpa8+u249lV/gCTCXtkw=;
	b=rap2lHxAfcbcBFMuHWtmN12qzdUV1Od3wkCQPw5h4r6r472ippM4c+Ov3qlj2BMSVqI4De
	pSmXPrO4bb8V8b+dmcL8iIbVlm0zmHoj0ChPe2ZnViUwyJ8urrWK8VXSfXCu5mRg+c5e7q
	rZd+mpgY4eMjKokOEUbZMsybzd/9pNc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793686632;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gobpz7G2pF8eCW6Qy4GETlwPpa8+u249lV/gCTCXtkw=;
	b=PAq6fX1ZT9P1QemYQ7f1P5H3YjOpYDdFzLSp/mESvdWAiX/whUt2PfLB/4ScC46ACtrjfH
	t45bqr1MrJz8RfY79S99sAi2rP9MrpwwHJy5RRyxWTp7LZcu6ivhQx20VHYV01cxUdB7uQ
	AP79uowFPq6PIxIrtKoudXmVLvU15/Y=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-532-rpYpgM9LMLSgA0ipcWqqCw-1; Tue, 03 Nov 2026 01:17:11 -0500
X-MC-Unique: rpYpgM9LMLSgA0ipcWqqCw-1
X-Mimecast-MFC-AGG-ID: rpYpgM9LMLSgA0ipcWqqCw_1793686630
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-5bcf6b5224cso1923078e87.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 22:17:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793686630; x=1794291430;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gobpz7G2pF8eCW6Qy4GETlwPpa8+u249lV/gCTCXtkw=;
        b=iAd6II8ZyVwE+DLnwwInUpKJR9WLPXORD2g/dg1O388A9iAT2H+ee0GdusRWUp1rrR
         QkXl4csyE9NNrTVsflv1xMaEb+JfrnNRpkKjCq8u/Dwb4XIhFoARMiZeWYY1I8ajKcvg
         k5duO0l7iIgiVVDuR5HoPCtY6+Svniv33ETtRMjcu3zW9LgaToTKTOv8krw8P/v23dU9
         lIyYIHzx1Tgxodw3FvyfEjMJoiYiuh0JIGUI/V4PdGPbHhFvYvdRHSMkc6cUzzTnWQdV
         8nME3HQdU1olrCMBSvKofV0rU/5vZeaZE3iqzmM9sStphgVJy4KgsZHuYYikpeOiPn15
         NAHg==
X-Gm-Message-State: APuU4Z9Xuy2Hn3pj9Kvos8GDpOL0fYkniX9wKc13fjR5q9e2Yhbmp/Jh
	YAdSaf9+fh4SJijTi+loS2p3r6BlZ+6kJWnYFLlqSMN7H34OM2Lx6i8xNjgpCWyzMt186qj6N4I
	d14St3SSE6z4ZBetYn5zlaRrwVyp6qea9oqDPs1qYG74XWAMhTI+nHUu1kjRJC42JkEcEOFOi3o
	XKFTKdymrijP16a5YDMHr7oxQSUNhpKXi/VNCGPQ==
X-Gm-Gg: AYBFou3Uv4Olzfng7sNpz1BIYelIFKC9DT1TpE131AMEN53RwQja/Rmr1ikoROs1cre
	UTJDeolTeqMlvcJDH8bdvgzTQujTMXEypWzsCz+sUtUkZ6q9L4/Ex/sw4sAkteZK/vSw5nr0ngh
	shWlzUhKutkk1aF4u576+W9e+6z/Rj6v3kldD6BBUZ+OQxZ8kIhebvyYc14txc1GPnJUj9cMcXS
	ptDN76EwML34ofSlLb6TqPLQM4qr3mqFhg+x54an9nRBeSA+GKp+b1qjDapyu3nB7cLDWPZT/sq
	s0YZOFX+KzSe4Uu7Qd7A4HyuLaBwn14OJg8dnOVLRDegmCkcdnZZ0L6gie/UMInD8ss/n3q1Y4S
	MvwTMzQjqpe6RKJqSglMIjIXFoxfRFJ/bBxetfUTtJTY+iJztDEq2F4vg0ntCgsaGmSb2+g==
X-Received: by 2002:a05:6512:3f13:b0:5be:5dfc:864f with SMTP id 2adb3069b0e04-5bfd9599012mr3965236e87.50.1793686629781;
        Mon, 02 Nov 2026 22:17:09 -0800 (PST)
X-Received: by 2002:a05:6512:3f13:b0:5be:5dfc:864f with SMTP id 2adb3069b0e04-5bfd9599012mr3965125e87.50.1793686621536;
        Mon, 02 Nov 2026 22:17:01 -0800 (PST)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bfe073e0f9sm1964634e87.54.2026.11.02.22.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 22:17:01 -0800 (PST)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH v17 07/12] mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
Date: Tue,  3 Nov 2026 08:16:24 +0200
Message-ID: <20261103061629.972669-8-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103061629.972669-1-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: YvkMeiHBudCvL6hCUCvPGtLAWy_myd0XZ29GRG0BLEQ_1793686630
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9230040002
X-Stat-Signature: jar1nsiyx6zey3yq38w7g513oy8tbb1f
X-Rspam-User: 
X-HE-Tag: 1793686633-961455
X-HE-Meta: U2FsdGVkX1/MvOtC67O0sBSmpLfUSu5t1B/oh/t7Nfrr4toxD0DbsO2lUsqPiNH4CkwqO1rTKFd+OjaVKrw25In/xeEz8TZp/gjGr04YAWQ2quVldJUJj74lo/T00aSZzwfEV3x84pMHBmflQpFMjEQ6iTep553/9g/zMdzRn2z41x+4tzdbi2tAWgYq4c7sKwL1rsSLCMP4/vwlTznn05fxGk/meAgi7nBnBRL2qsYLzRDeEECQ3RK5E7ofP1qXGJD7fO3uJt4SXaXwy97tfb1iFK/4/zaaNcyOCaSgxpew3vQckZCwvhYV+CD2AeePXtlf9cFMDnL+X5ZZIvtkE3RtqlSKH1ep49zBh00W9DM6yV3UUE1eOdxmMLzmkChF5tQLjtKXM55329jdeA1p4DQ3MlB9IfR+onlIkPZQfGD5g8p4vcZI72EnYvIHgKeYXzAWoW9GPSaXXZllpRstGw561nS/Dx5KrQMI5joHxjjDfscuC6NEBS6IoXK//Sf+zLj+oJq4d2IA+l7nS+/qswBs1hpTm9bl2BC8tCPb5R7eG3Ln93ZYEFCsE6Q1YhyuxzP+gHewsgcvlxkK72t/TlDwGKb04UxuoVKhEpscBn1+v0o7HHx4/K6TxNu2pQZtgaUqdIB+lJYEZ+PrFIHivTGXhNV0LV70qG7q6SGXndCauu/VSPKI9ByJ58CJYKmNM+VOWz5hCFa8MxzwrHveOk3gSz9oZnObwGcY85FwxIGo255XV9PTnXOj+iGpwUl3hEtbe6p4PP+TfbPrkPKyjawrkuB6NuqYzJrNACEs8FiPByuIEwrEoSAAnsUdgcnDpKGn7MFq1bXtxQLMeuVpUAccsJFcUhaidr7wrb4c3kRKtKiZ69+DaGwJPZ3TDLN/2TobdtApQUY/wkmu5XHmau4hGg8V9ydlBX6GsJP4J5wGfSlc8WvgyYewKY3fhYC3Z1nBMdv8vzt1vY4Nnbz
 111XqDdh
 V0864zNopDUYEQ69s5EeTbxPz6rEOLEr8+U+0Y4YjVKH/MAdgW6wVd+FLKnGb2q/kU4cOkShLCCii6uWQ9cTeNG3eSdCJ+xsweBp+tE1cm8aTZP0s1oeCbj0uoiSC5WO6zoLkplwE64WiiXS9v8A59/s1Cx6/te0Fa2mPilji5+xxf2C/9oceas1KYLbFMSnWdMWUr9RPrf2nTioHYUDEhkyHGlBgM+PHGM3oKT75JIwcUokVr6Cc7I7o00NqEEOte0U8nOv80IS6gFsqWaJxNQeoq69fnUkBp1gB1HSq5NdVrA/SIbuX9tk0c0udOz1JlEPtKtjngUmFsw+0AUz/Ng+FOGEoKHHZkoaBlhOqeHs1PBLQJUK+I+CQkoFCwqsJOJRScq/Y02z1skLBoaTbmrSYThwzmdwRwcKd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Mika Penttilä <mpenttil@redhat.com>

Add calls to lazy_mmu_mode_enable() and lazy_mmu_mode_disable()
while doing migration.

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Suggested-by: Alistair Popple <apopple@nvidia.com>
Signed-off-by: Mika Penttilä <mpenttil@redhat.com>
---
 mm/hmm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/hmm.c b/mm/hmm.c
index cbde004fd778..690b73908f34 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -377,6 +377,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		/* Report error for everything else */
 
 		if (hmm_vma_walk->ptelocked) {
+			lazy_mmu_mode_disable();
 			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 			hmm_vma_walk->ptelocked = false;
 		} else {
@@ -400,6 +401,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			if (hmm_vma_walk->ptelocked) {
+				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 				hmm_vma_walk->ptelocked = false;
 			} else {
@@ -419,6 +421,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 fault:
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
@@ -548,6 +551,7 @@ static int migrate_vma_split_folio(struct folio *folio,
 	if (folio != fault_folio)
 		folio_get(folio);
 
+	lazy_mmu_mode_disable();
 	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 	hmm_vma_walk->ptelocked = false;
 
@@ -1159,8 +1163,10 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 
 	if (minfo) {
 		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
-		if (ptep)
+		if (ptep) {
+			lazy_mmu_mode_enable();
 			hmm_vma_walk->ptelocked = true;
+		}
 	} else {
 		ptep = pte_offset_map(pmdp, addr);
 	}
@@ -1205,6 +1211,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
-- 
2.55.0


