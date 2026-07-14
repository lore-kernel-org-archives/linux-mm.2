Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A225C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:23:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF6666B009E; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA7716B009F; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6F5C6B00A0; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B513E6B009E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:23:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 42CA7A03DF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:54 +0000 (UTC)
X-FDA: 84987298788.21.6BC271B
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	by imf17.hostedemail.com (Postfix) with ESMTP id 46A024000C
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H feikRS";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=fREjrIAb;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031832;
	b=kxxZMCOUJuzaO7Vx0g50WFHU5us+2Hx37wb5TSmdE3Q/3nYDxp7PzcpkJ5/Ua/BTFxfE3R
	EENANVAxDAwTLAU4l4npuLm4wqKkJq5kLDZBwpHpCd355B5G3cQX17bOU0OjqJhXRhD0PN
	ZA5UfObbipJsfKeVtj64VGR0W85ry6U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="H feikRS";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=fREjrIAb;
	spf=pass (imf17.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0g5oskdRgsUXvKNkDRa5faJ7aqOeb+0ELgNs1jz8A+Y=;
	b=shHVbq+2rHvQ/UNCsU13UesFYJhq1Oom+RrJDSBkij+1AVzwQJpj89Y7+9YH6aS479DcHI
	8gdmPGNfIvG8X7woMvnqHgZ51VkkJnt0Ybs4Y4O0G1+cMJrSFHAW2mqIHTqYmEW9E0cfWj
	01gibSbBJ+K7h6FkR5JsScm3KfkBmeE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 374987A00CF;
	Tue, 14 Jul 2026 08:23:51 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Tue, 14 Jul 2026 08:23:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784031831; x=
	1784118231; bh=0g5oskdRgsUXvKNkDRa5faJ7aqOeb+0ELgNs1jz8A+Y=; b=H
	feikRSq/NAyfMt025iRCTPpadEaUfC2Icr1aPhqdRQ7KTT8SeDEptHSw1oAfQFVn
	KfffwSoGjaHKQFJG1SPNYfr8osmRwmuYtjtEuAj75ffoXnixJZm9Y7jnyah2LA25
	0kh+DNPjtS5SgbNNMUHpSERBZmu9GIzS6wG3OL0RO54EGk9BgNbCskvBuNcvvkZE
	QkxCWbY4MoVtbHUA6dAnOTnr+kL8zJPX9/eKQApEH9K8yikF5bQZQIKFLcamHXO0
	s9kzHbI46Qle2Bi/iPhtyIr5/WtAJU2imS0yT64M6beuwvYyroFDlomGh5yMFCWl
	tP9vR/qG27PWmf7Xv5CEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1784031831; x=1784118231; bh=0
	g5oskdRgsUXvKNkDRa5faJ7aqOeb+0ELgNs1jz8A+Y=; b=fREjrIAbdI17ntVKn
	MB8by3SxPUcW3qO+KdLZmEPeeGg/KmqRBtZY2cGUwwodsgX01r2DBhm3Vggp8Xp4
	Nx/TuVnCQ3caFCL3j/F6RJHYYtFxL7gNELaTuw2lrIgxkyOycoI8y3aAqua9BMcV
	5In2SikhPIDHqwBClDyojalCuSbrlTXSvRF/cQOJVZ+34LZZflIShhgrgIRZWN40
	uV/R78R6/2BAjtvJozMVj81zg3PF0uvG2/qLmbzsnufNejX5UiHYYw9nuv0Zc2G0
	mnQmTP1NC6roq364QNHm6zVcAPm1lOiryt2rN3IiJqtgBRakt6qj912NEVZqNP2r
	+nFBQ==
X-ME-Sender: <xms:VipWan-T4oIkmEE6r-RYnazwK1uosYc4Fu7pVMMok0k7wdanYCJJ5w>
    <xme:VipWaom-4uKH2gmRoBmAjhG7P5Bp4JOu4JmbwGCEjP77oKlqz-YNZ6YJcSVM8mwsN
    7Av-nMQLiNDi5DSB4ZlSJO_54wbujBcSjxF_jTzk-N6zgHUaHY8KQ>
X-ME-Received: <xmr:VipWatl-UvnLzBaKQMjcjXNEEI4g2vnjNayF_EaNh47KKQCMy9VjbulQXvL-MA>
X-ME-Proxy-Cause: dmFkZTFBvxovr0fjL2SDlhw64F6oFGvIraiDu6TVCnqgYaAZRHolensvaRSdeNznP8dyQu
    Coman3QLm+Yiv7vIU4gCaDoV3zjPLAT5xMyob2T/RAiyCRcX5nino2GdJfXAIhMAG9Vfbt
    8DmmQq188Z2uGp2nkuYEczpQaZcUln/b+ViESl/1sRXWiXixSkmKZ86RELzVQX1c5DoIyj
    VYLQxCZGhSirPmfYkfg5Z9MFDCczGvA5NVGnQNjEY+/Dc2Z4MeErYRkfr5HJBXVY0/+gwS
    wMHbPHqeV/WaAxudjO5n+4mCCjxtqKMzuTd7bYDWa5SZhntkJG3EmwdwQQDclBgW6W8CDd
    Myk1BCEsjZDtocKPq6SFh76ysa5Z+9HMjeF/GuQroKl+BKIQFyK58Hi1iBuv4PrSsdBoed
    qUKBlvXQLkXzvgPziLsgfGTHmGmaAYjCQitkrzLMJEtaJKPypXwEldF3t7zIQu4Y1iJZYP
    8JdHx+ZsougTMMNwOza4whUv7GUcGNzNVeniMjQ2nZ9bV7QR6oLgFbrAdUOB3q2DJGK6ko
    zjyFXvlBDUY3Dzjs61NkrSzXWUrHB86X9Z7AAS4GNjT7SNVwPl59/T1j+4ANijkQkYvFDr
    dHPg2tBOQ5IC/khlzTXlr1HzV0jz38hy2O+EhVl5dFQ+G65hq3VRfujqMbdQ
X-ME-Proxy: <xmx:VipWaktHJkAeUtY-3ehPTHEiwmneLsjIQotS6AjWgmhehaovG-lL3g>
    <xmx:VipWavKjkYAgFgpOkSsTVPy1W9BeDBe7-Ya_Ni_bBcKY_s7fghEVJg>
    <xmx:VipWahgk2ekyQF3e_pOaqup5HSWggwV5e-FDz82enjE4dFc1_wJxFQ>
    <xmx:VipWajunbTktYq9IirahUkKY51FmLr8wyUmpYNbdz6VzleU4DCVw3A>
    <xmx:VypWaugA_oyUVVqDplVi0s1VjO-1ZohE-PREermaSY2lbZedakUOpWiU>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:23:50 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/5] mm/memory-failure: keep the folio, not the poisoned subpage, locked across split
Date: Tue, 14 Jul 2026 13:23:40 +0100
Message-ID: <20260714122344.351895-2-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714122344.351895-1-kirill@shutemov.name>
References: <20260714122344.351895-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 46A024000C
X-Stat-Signature: 8roncuiuowbzuayo54kznc6q7x8nim8c
X-HE-Tag: 1784031832-607391
X-HE-Meta: U2FsdGVkX199ACy0+25/993gXcY+WI9g5ln7nS9KrsV1vGM3lo0Ln185a0c7Re8NPflaHD6v6qFHleltAhakLVdl5x033S12sZNb2Xb1sSNKmIWgpFDMgbvqaxK2/Z51KkHQTRFDQT5Ybb6l9CWJIHgmdIsAyIvDe1Vvz5md1AQzbgrY5Icup7N/ljv7yik22P4BeP/uCV+OH13xtMIB/4ZQME7HKQl/Vouh+jyBQtI/6amI1jAqci80gjwqUp7CYoYL45Z1jBJXgMg7vdL+omk6hmyRLg9IzogA2wcB3fyS3/HGRIcVMgSkvc0qsKpBlehkeLg/b9UzaPpy1umx4g4x3YL/VHcZQzlw4iRtgxVZ6ovjYwTn9hY74VP9KxPSBKpch31NU7zG1dI8Jsm+XXs4UcjKlFl2rkcxI4+rlkHZ84JsCJJ33b+/NXy3JGDxAJNOuC8UNfs7YrqHdhtb1e1b6GsNHdRyiRRKCfYDwdMQ4ejP+Re+PgNAF4gGJ4CD+NbCMd0lQA0HicnYammSuBDos50r4RgLFLd4+QC8WpVPQbpZvgO+z+3OnV2vJtxisy6xO0ZRWfzHLsjEOIzw0sAWh3u9Q31PsLw2KlFuPovdh+/imU0q4NWPOTsTteR1Tfh52QFec/jaBTbIyxW7sYQTRd7o9r5/oAek9/0b1FTiBr7SvHk9mmzn5EPY6vGFhQ31QBDyoD04aQ3wEAa7ZAl9spjJq3+baUlAO+4OwB7ab35cf0YSOTbtlhAXauEW5CX7DpV3YyxWHPYFOUssGLmVg39o2bLcNUrt9Iql7O1az9kpYia8ClRfQ8WQsOP/REpJSDfEheClgSmrq0ffJ/eph6DUYnveWP/3STRTfF1ozzBiyVX0D1YY2ZtJ/ls7vJGOddEMz2LY7HdmayLp7rvT/5wxKQ4IDbp++ZjTryB8PvxNFpMo3w7Ff/kciYwyVcu5scPsfaVZIxP1Bpr
 0Kc2J51x
 JPLUVFYiZmagMvLVm+YgyTIY71NtMXqjSjMbCIqnePy39MzT3kUoPqyB2FR02yW7qTBy1PbnQxc8ye0yxN1NSeToA3/I7rKi8fVmPAxYLkXf3t0cVEztWJjJOxIccr+nvFa7WyDHMlHa97UYIOpfLjXCJZJBp0KFiot7omYrcByYvdJJkEPuEzg6+ZXq0aE/CGuG7TFSdwEeiUQIBqUMY5dvaVebCFzn7fHO2sw1VHmQJeBDPiv5099i6bo3dUUQDbnZ/d530k9U5kgrU4+fKlG/EINNfHGH+dwSW16nAdiCluWuVIxU7VN32LSxNlHVjx9avTW9JyT7PCSsN/0AtTmInHA7CNsKzHO5ejapNru072q0xXf2bcMJ7BROusF5ZiPsGCs8HXasZ/WLLnCiL9rqnW/BwOYMPkSvi+A7C7lnJXTzKIUdGt4nluFtfBQh2xBP18sEvdEtanrjf+qcg+4b1rp+qXBx0SyfbD75gA7RXcSNgz5SV9fOMlzPc55PrkoPyqyKxqUb6dSO0VdEc+Kcw0jN01QH8pHnKiGDS1OMH9vYrCv5bCP9wMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

try_to_split_thp_page() locked the poisoned page and passed it to
split_huge_page_to_order(), which returns that very page locked to the
caller.  For a tail page that means __folio_split() runs with @lock_at
pointing into the middle of the folio.

__folio_split() dereferences the mapping after the split completes
(shmem_uncharge(), i_mmap_unlock_read()).  The only thing keeping the
inode alive across that is the locked @lock_at folio: while it stays in
the page cache, eviction cannot complete.

But a tail @lock_at can lie beyond EOF -- e.g. part of a shmem THP that
reaches past i_size while the file is being truncated.  The split then
drops it from the page cache yet still returns it locked, so the pin is
gone and a racing final iput() can evict and RCU-free the inode while
__folio_split() is still running:

  BUG: KASAN: slab-use-after-free in __up_read+0x634/0x790
   i_mmap_unlock_read include/linux/fs.h:537 [inline]
   __folio_split+0x732/0x1640 mm/huge_memory.c:4100
   try_to_split_thp_page+0xab/0x390 mm/memory-failure.c:1675
   memory_failure+0x1394/0x26e0 mm/memory-failure.c:2470

  Freed by task 4601:
   shmem_free_in_core_inode+0x54/0xb0 mm/shmem.c:5177
   evict+0x57f/0xac0 fs/inode.c:870

Split the folio as a folio, via split_folio_to_order(), so the head is
the anchor left locked.  The head is piece 0, which the beyond-EOF drop
loop never removes (it starts at folio_next(folio)), so the split always
leaves it in the page cache and the inode stays pinned for the whole of
__folio_split().  memory_failure() and soft offline re-lock the poisoned
subpage's folio themselves after the split, so they do not depend on it
being returned locked.

Reported-by: Hao Zhang <zhanghao1@kylinos.cn>
Closes: https://lore.kernel.org/linux-mm/20260710071344.GA106129@zh-pc
Fixes: baa355fd3314 ("thp: file pages support for split_huge_page()")
Cc: <stable@vger.kernel.org>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory-failure.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..68d42cbed458 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1657,11 +1657,18 @@ static int identify_page_state(unsigned long pfn, struct page *p,
 static int try_to_split_thp_page(struct page *page, unsigned int new_order,
 		bool release)
 {
+	struct folio *folio = page_folio(page);
 	int ret;
 
-	lock_page(page);
-	ret = split_huge_page_to_order(page, new_order);
-	unlock_page(page);
+	/*
+	 * Lock and split at the head, not the poisoned subpage: __folio_split()
+	 * keeps the anchor folio locked and needs it to stay in the page cache
+	 * to pin the inode. A tail beyond EOF would be dropped yet returned
+	 * locked, losing that pin. The caller re-locks @page afterwards.
+	 */
+	folio_lock(folio);
+	ret = split_folio_to_order(folio, new_order);
+	folio_unlock(folio);
 
 	if (ret && release)
 		put_page(page);
-- 
2.54.0


