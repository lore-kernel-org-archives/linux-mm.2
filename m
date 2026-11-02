Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 798BD60A2617
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 11:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=JMvdJhXm
Received: by kanga.kvack.org (Postfix)
	id 3376D6B05B4; Mon,  2 Nov 2026 06:30:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C17E6B05B5; Mon,  2 Nov 2026 06:30:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188FA6B05B6; Mon,  2 Nov 2026 06:30:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7E216B05B4
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:30:35 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7DDCDA8B38
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:35 +0000 (UTC)
X-FDA: 85389961230.15.C52A87B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9EC12120007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 11:30:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JMvdJhXm;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793619033;
	b=UZmEdUmbYNFLZvnTufpeloNiHGMphXTExvotuHTIhiEnCRvo3TcDajNdXP7ERXHxpijqZw
	WEL4bnyRUhNa/rKUDm50qV/awbQeqt7tY7WzzGsqMWfI182Ldltc8w6CH0MAvonZbfcwYk
	7Y1l0vW4d+g1weuslihhqhAeTQe6qfE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JMvdJhXm;
	spf=pass (imf29.hostedemail.com: domain of yeoreum.yun@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=yeoreum.yun@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793619033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qxe7DUgpOQnByNQP9kafnk+uEbgc4F97wiPdKo+5K+c=;
	b=WkFSMB2qJMNqnUkzaYszyo1RNbzWHF+SxF79nLuDyi9SrSGb5Cs0ELOMS08oXGQ7we1s+t
	L9LmMdsKJzPPOheIQtob3CDqEr7eHZvgXx6KhukSDdreGHeoL7sNp6t6iw3oInCZrW6mSs
	ZTVOFzU6MA1UcQAVIOTf3VnYNAS858Y=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B4A0C2A31;
	Mon,  2 Nov 2026 03:30:29 -0800 (PST)
Received: from e129823.arm.com (e129823.arm.com [10.2.213.3])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E97F23F632;
	Mon,  2 Nov 2026 03:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793619032; bh=B3jeugSVzqHP+LRhjNSV9HdZUg9MhTRTmnnXzBcFB1w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=JMvdJhXme+roww8mpdzFuGI3npOZ5JM3kp7svnIhLxDcBzFTATE9GbvXR/BX4kJwZ
	 spF9xWrKd5lxyn4+L1T2pHzwZc0ZQZZ2vP02nQQN/frIIq4EvIndCmt3etzs0BjXQ0
	 7ACgTd6hOgFfBKc6F1s/RtOpJwVGQWBu97Ii/aTA=
From: Yeoreum Yun <yeoreum.yun@arm.com>
Date: Mon, 02 Nov 2026 11:30:17 +0000
Subject: [PATCH v2 2/4] mm: internal: fix inconsistent in
 folio_pte_batch_flags() for shadow stack
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261102-refactor_gup_fast-v2-2-bc1ac018c834@arm.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
In-Reply-To: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Rik van Riel <riel@surriel.com>, 
 Yuan-Hao Hsu <aa9736195201@gmail.com>, Yeoreum Yun <yeoreum.yun@arm.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2140; i=yeoreum.yun@arm.com;
 h=from:subject:message-id; bh=B3jeugSVzqHP+LRhjNSV9HdZUg9MhTRTmnnXzBcFB1w=;
 b=owEB7QES/pANAwAKAW3Vw9FaxTEzAcsmYgBq6HRRquffmGz1YcLeYyKukCvc2f1kN7MzYOiBv
 rN6edzeH3WJAbMEAAEKAB0WIQQtg+CS3QUzuFh1pJ1t1cPRWsUxMwUCauh0UQAKCRBt1cPRWsUx
 M2VyC/0WDZhM1JkdBWq6zaE7b2OixLBmhhMrkqfWnK2tRpT+gnTHd7okQkDPs5HI9CN8v/Vdksd
 R/jDYg4qGEnhJhwqGqdbaVtEafl8++JcxmvJE3Q8W9c5/XG+NPayAabuwdAeKab2aerLiMgmPVI
 PNx2NcCnExicCxZBB+Sg0eg5N9zcxZckcJ3OPmsjVw9ylCCuQ4VmJUDfRInGtKq2Ib2znRlnFg1
 ao8pDOX0n7ebYRFIYkwt8HeHJuQO4oX3DQ9OasbXTTBPjKdHMavfQpWPFGeT+4DTdlgqK/6dzah
 88J6UwdFosw/qmhN3uhq6TXy9Ke8395uRX60aGRyeUVlCWbb/0y2UWp8j0aTjsBc/aAEimJr2tA
 9G7kGk/jSG2RMcWlpO9Zv8eHeP+rM8xXIaHWzxjIo4/Znj7uhdvG9Qr8aWoM/b4VQv2dkfMdX3F
 xgSoQXp+0HK0ZVmcfKygIzOqt+fm9zxDIrwFM718Zaz3ZNp68rypKYzIErjBd2LQ8Cek8=
X-Developer-Key: i=yeoreum.yun@arm.com; a=openpgp;
 fpr=2D83E092DD0533B85875A49D6DD5C3D15AC53133
X-Rspam-User: 
X-Rspamd-Queue-Id: 9EC12120007
X-Stat-Signature: jihsfq86m83uxbe3s43isbyijt784ffz
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793619033-985589
X-HE-Meta: U2FsdGVkX18wSbT9wN4CsNbW4Z1uE8daX5Tt2EIxJDuWHWMKnbg+7869UgYD3OQtdxHbApMoCTU+a5nO+AjJrbVGyKqE2zX6/90W6DtGdhSkNPg98DJzp15zoGfFXjxDIumb7TdhXSFbLbNIO8bF8ci88jk9QThevZSqPC0IT8XlrF+j5Laaiau7txMez2bfKNEpqh/wpXVP1s8HiRuboSpBqc1J6Kyk9G6XybMgBCGKE4iHal4vGqc3hE2sTDDAEO2YOcyh1w4ZEpIOywzVYvvJtvXIKHp55pPYLuZFJYqtyMutTH2/qqm5PGyR1XBxvppahsWwj4BGAG2LNz5eXxRLTuxYKfYvinfwxVJnzow6+0A7TTFyEPvQYXDJqe7GvS5z1UbH7E2VQB7sZuKnAfXCwP5ikvAxIRRCyYkwsp33W7SDa9H5laWe/5KPB/4/wYG+tu3TFKXt1glv+3ZzlliSAbkFa8IgTcBlFFEnSE16k872MnSLqfaDUWDa1t0AqHxcIuSC024w1uUeLwxGTIvQ/JPMtHkEDC5WvYQBTrJ4fJUZTVZiUUoxGX+Ng0LBsMPnMJw+0D31Yy8wvAKIi2jIRN9CxsMyBD40MKKBeG6bF1dmXG5va3uBGGiPck5ZxKRk1JgefImH5eWDbUYqdfiSEf5cmj9MWOUhV8ZNxCcFjRGbZa1CitTdKS/vuON66wT/2rpe9NsFW3hIMr9SLH0/7yR8E7RmUROcTH23BRE4sA1LqACyl8eUwwIg09XIcl8Un8E+jXYe8vyZuVRfzArP5O952wOPGsS9Twjpa7upwhAZe/VgH/0XdoiPzKOj8lOrjsIjPNY58kcKCuDxj9lnURj99loQvCLtgPjuunWihmaFcHD+/rvQ7owW3yOZyOKE+zH4+tSv8yTCs/RxtLct3IHQWcEA4dB8eM+cbYZnH+ZEaWRypzcUTkYtq4sKsCasIsfpH5YqZ+S5u+H
 IlKOe7GQ
 ArwOLslgKFowqxSCMeIi/NWX1KKnrl7IOFaF03l1GGDV8gOS701/KutBiBN7N1vsAyO53TF89Tk7yp629IOR2dOtGDRoUg84yS+wX311CQpH8pNLrmLBUI4FzkrEx2DT4+My6Bqq2qmiTPz+9mKqEKAF9thaqvszA599XIQ/fLujBJBWq6i2LGJAy/JYDAlusxUuBKyUk5k01rziDVAbAnYkJ/3IjvSYIEpnbw8JgLcjiIBJIeJaUWZA26InR+p5C+mcZkP5v7S3icrgxwpyIZwiSqi8N59sVSW+AiErRpqN3f/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In x86, shadow stack PTE is marked with PAGE_RW=0 and PAGE_DIRTY=1.
If the shadow stack pte entry is consequence with the read-only pte
like PAGE_RW=0 and PAGE_DIRTY=0, folio_pte_batch_flags()
with FPB_RESPECT_WRITE without FPB_RESPECT_DIRTY considers both are
the same.

To address this, save the first pte's writable and compare subsequence
pte's writablity with pte_write() when FPB_RESPECT_WRITE is set
without FPB_RESPECT_DIRTY.

Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
---
 mm/internal.h | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 35016b1afc8bf..b4d0df4c35adf 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -418,7 +418,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 		struct vm_area_struct *vma, pte_t *ptep, pte_t *ptentp,
 		unsigned int max_nr, fpb_t flags)
 {
-	bool any_writable = false, any_young = false, any_dirty = false;
+	bool any_writable = false, any_young = false, any_dirty = false, writable;
 	pte_t expected_pte, pte = *ptentp;
 	unsigned int nr, cur_nr;
 
@@ -438,6 +438,7 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 
 	nr = pte_batch_hint(ptep, pte);
 	expected_pte = __pte_batch_clear_ignored(pte_advance_pfn(pte, nr), flags);
+	writable = !!pte_write(pte);
 	ptep = ptep + nr;
 
 	while (nr < max_nr) {
@@ -446,6 +447,16 @@ static inline unsigned int folio_pte_batch_flags(struct folio *folio,
 		if (!pte_same(__pte_batch_clear_ignored(pte, flags), expected_pte))
 			break;
 
+		/*
+		 * x86 shadow-stack PTEs encode writability as RW=0, DIRTY=1.
+		 * Without FPB_RESPECT_DIRTY, __pte_batch_clear_ignored()
+		 * considers shadow-stack PTE as the same with subsequent
+		 * ordinary read-only PTEs. Therefore, check whether pte writable.
+		 */
+		if (unlikely((flags & (FPB_RESPECT_WRITE | FPB_RESPECT_DIRTY)) == FPB_RESPECT_WRITE &&
+			     writable != !!pte_write(pte)))
+			break;
+
 		if (flags & FPB_MERGE_WRITE)
 			any_writable |= pte_write(pte);
 		if (flags & FPB_MERGE_YOUNG_DIRTY) {

-- 
2.43.0


