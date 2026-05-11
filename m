Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C1DCD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 14:05:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28BAC6B00C7; Mon, 11 May 2026 10:05:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23CB46B00CB; Mon, 11 May 2026 10:05:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 179EB6B00CC; Mon, 11 May 2026 10:05:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 063E16B00C7
	for <linux-mm@kvack.org>; Mon, 11 May 2026 10:05:57 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8DF96120167
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:56 +0000 (UTC)
X-FDA: 84755312712.05.1134E03
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 917774000F
	for <linux-mm@kvack.org>; Mon, 11 May 2026 14:05:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFn6rc26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778508354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZC4r38RDJedpfkVWmxeFcuvQv0qCmJ9k9gsjGbbNczQ=;
	b=RZPBLz4IdPUIIClhdiQf3rjeBOf5bgD4CMu1nJ8psbo7JopwwzhALMWkMXAP0fbf0lBe1z
	x04neMlVG2qf54q2RH/JuhtTeUHTWOZGDZ/5ZXKbvdg4bFJlWG4Y7dXgVXhHi7gX6R4RPw
	3OBGDIYM1555N1Ycrg36chorWMmgrGs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778508354; a=rsa-sha256;
	cv=none;
	b=43t+Rh+d/DI+Hm+HDTub3tXVBZbxG21/5035JhSl/9eGYH6h+L50Vqc0Q+Klo1SzIB2V1e
	8x+9LKUa0rVULllZOAoiK/yIzjdzzKHHFk56rIrWiyA5Gapfqus4UQOjzOlajVULHPwaGV
	9/a0puzOkBzJedWr2QVBdd/kwGFoWvw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jFn6rc26;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4C4140564;
	Mon, 11 May 2026 14:05:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2174AC2BCB0;
	Mon, 11 May 2026 14:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778508353;
	bh=/pOfZWbC9cprP4CiwJVpUWxqpXHz/aiDjfQglaSBebg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jFn6rc26M9OimLWckkvKk1AgDXLVRQ8KuE9cyARG9LjU74GLBScBL5ialIQnbM93F
	 woMLS+u4RhxAlTgupssA1sorXxYcum1WHRotK0UyqZjoAHHLvfS5PwOCqEMfqH2g8r
	 Cq6VkdIkThwjJBi6COurSnGP5bgL8ouiUkmuGTHsbRH4o4xgsR3kjwiycdRBvsBiO2
	 EqB5/uXejMTMhTCiE4a8cj5wkeQVQTyhoqboCovHIJmID6kpbkjYI8zq+oCBt75XsQ
	 4FAMUU+RPV64+1jg9eyDe2vR8+R3iYSWTAGj2PrJYzw8WeYR7XTO71JWBIFUgLxaAI
	 9DNXm86BpBjXA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 11 May 2026 16:05:31 +0200
Subject: [PATCH 3/8] mm/bootmem_info: stop using PG_private
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-bootmem_info_prep-v1-3-3fb0be6fc688@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
In-Reply-To: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
To: "David S. Miller" <davem@davemloft.net>, 
 Andreas Larsson <andreas@gaisler.com>, Mike Rapoport <rppt@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-s390@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 917774000F
X-Stat-Signature: 4ipy7nro5s4teeoqnd1sa4z9gxdehkpm
X-Rspam-User: 
X-HE-Tag: 1778508354-472638
X-HE-Meta: U2FsdGVkX1+tsIIbU86rv5ee91sd48KNFUdF4ewA2l/DdcZs2e6Sy6PX+m9jZwdPrs0et7RBrKgPwCnuv46igIvdWloCkMofMaZII1FZ3iNOgNKXeDjs82pRQ5PitJo9Hsg/D5ZY+LE8KLZ5sJydHu0ogzkOG9rsspWQE28ksiaQzB1zVl1ck3y0Npcvt+JwDh6K7PPXOX17ghOTLAvi+9JC4CKpNcSGdHjM2GvlxbmFR8gVXwARz2i53JSUk/1OZe6FTGLRIPBFU/bIaBeaj0GoJs5pQlReo6pxtBzuF+744E6LBtFz8zuQ2MF8qMclIS5TBa4mZEMkY4Cvn9R+GPy20LkfoKEr+YaPttKo2ARX7GTsfGvG+FNpZCwPZW7MdQdMJmNluqOLwHayga3xSKnpzoFi4N+ziZ+dROcbCgZN3P7rFA8QKoYTvmHIZqxK5T/ctyUjSRkPN7/nq4l9eQJfOKIwUS+FW8Apx9HJ9sYAyOb1ebo1DuDIC2QoH63FDXHtJBvEM+8CQcbxeoRoOf8mDwE3hBkLCxxIPeXltQjsl7412hyE25LtBXXgp6Riayjyegm0MAvwqWVtOKn8Po2evuO0YAO4DGqjdmhy0zggfPQubhty/HettONXn+tRDIVqGhwkiosZIw0386yzwy83FIQ6nUmd4waGJOclUTTZu2Y+4qd1gMVpuQkWR84VdDXMknz7LJ/LhUqotCyzwz/2Bh6BX4dveQuBVjfoSGqntOuaXro0iN7LmxtVMp0rV1ZJOP8fd6yXh9Alj9E1aq0uBf+UToV9qj+wt8PaVz+oRYXJThxno+G2kLCud/ywZL5nBFHma73ZLrk4MIFx45NwRgk4ar814NUF1dVkBj6ppUhi7tMDVXe+h09GFM2pEeFrNQf1ugPTpIBqHBj0xMzi513siDGVkplc+/iQJvRJwzDU4bbO/jJcdbEqt+xcRs9/PcjA81rUIMWPg7b
 op+o/Os/
 BNLK1WInrZBQgXlPp9chIcBAO8O4eFW36ras3pR9ZzzZ1vAtHctszGAw7mGqIyklJQhI7c8z/cfnTWZau7Ss/IDXvYxspT5bR5XuE4GjtK3QAz/Alzl69AEklrakzVFy6qXliRGUrU91/eI6S6aDxXgOSSc7Xs2nvaYb01VAiBCYVO2f9+dYCoZvSHedIx+q0e0CJosB2jCNhgvq6FZZiH54VmiHz9HlAFyHLtqQ1xe5enBhod6L+BU3mJF78626bTHKaKQopSePHhC7T/clsWZmjFgpQTEn1mCyijvds5mNj48A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Nobody checks PG_private for these pages, and we can happily use
set_page_private() without setting PG_private. So let's just stop
setting/clearing PG_private.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index a0a1ecdec8d0..6e2aaab3dca9 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -19,7 +19,6 @@ void get_page_bootmem(unsigned long info, struct page *page,
 {
 	BUG_ON(type > 0xf);
 	BUG_ON(info > (ULONG_MAX >> 4));
-	SetPagePrivate(page);
 	set_page_private(page, info << 4 | type);
 	page_ref_inc(page);
 }
@@ -32,7 +31,6 @@ void put_page_bootmem(struct page *page)
 	       type > MEMORY_HOTPLUG_MAX_BOOTMEM_TYPE);
 
 	if (page_ref_dec_return(page) == 1) {
-		ClearPagePrivate(page);
 		set_page_private(page, 0);
 		kmemleak_free_part_phys(PFN_PHYS(page_to_pfn(page)), PAGE_SIZE);
 		free_reserved_page(page);

-- 
2.43.0


