Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 896A7C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 12:12:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E73E6B007B; Fri,  8 Aug 2025 08:12:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2984A6B008A; Fri,  8 Aug 2025 08:12:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D4FE6B009A; Fri,  8 Aug 2025 08:12:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 112D46B007B
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 08:12:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B90BEB639D
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:19 +0000 (UTC)
X-FDA: 83753477598.16.9EC191A
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0155940006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 12:12:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=JoSi9Q3J;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf17.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754655138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUZ7WtmWLoytrmXItECRu19QRh1MV13CnCf09RIJKKo=;
	b=Eh+zKuv38RaTwi0ciSolMENLjrBtrf+ihPh+HT4G/hyBipbrBVbFmxG7SB6R7qnj2rnNPu
	mSCM/xKFTA9YQyLh+5lZCjDHZyySYN9KNlmIVOYrUdCsGIOw/dB1GFh8a+whBpNdAL58/5
	wlFCqKaROt0dns8U55zhnUeizSxCF8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754655138; a=rsa-sha256;
	cv=none;
	b=659Jj3p7MzeGH8wqkkpyCa5f8zZW1ObhMA2RcWoFpQxrAFrApKQe/IzcPH8v/KioGi5hUo
	SgKhcAkDqPyJTFqMYh8uYnkhqPTbbIJ5AYmOKTKLsB8Wel6J68CQJrIeOwj8ShHBVgtRmQ
	baOaHXZ2YgaKhmrB4CLh6ZioArALtwo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=JoSi9Q3J;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf17.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.151 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
Received: from smtp202.mailbox.org (smtp202.mailbox.org [10.196.197.202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4bz2vy5Vnsz9tKX;
	Fri,  8 Aug 2025 14:12:14 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754655134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lUZ7WtmWLoytrmXItECRu19QRh1MV13CnCf09RIJKKo=;
	b=JoSi9Q3JxxnkC076NeRBpep92TSYR+k4FGMsQeKkFhAwRA7uW/FSMye6KknS49iyFbK+1k
	VsBFupxh6QBDFDeWG4yb7PGwz6i3bTcWdOpVsvs+1JrjcAZSkFbMi2V9jOPVw4zQfUWXix
	zV/lPe0wK2trTobCNS+0XAmsp59FdfXd6RuwwxhiEa1KSqkbZXVsCjykyCCep1KLVRDNqR
	EXumP7weBN1r/2YJTxrxLUjllm1ox0lGdZpNJZtjn7DfnEPxW6e4kKrFqGq5JmpEst9V8U
	AGV3PiXvByicwPX+QK5kIIEoi8ycvdgLgy8j/0lmIOWHB/Fj2T6S6JfkvJ70Yw==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Mike Rapoport <rppt@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Michal Hocko <mhocko@suse.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Nico Pache <npache@redhat.com>,
	Dev Jain <dev.jain@arm.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org,
	willy@infradead.org,
	linux-mm@kvack.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v2 2/5] mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
Date: Fri,  8 Aug 2025 14:11:38 +0200
Message-ID: <20250808121141.624469-3-kernel@pankajraghav.com>
In-Reply-To: <20250808121141.624469-1-kernel@pankajraghav.com>
References: <20250808121141.624469-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0155940006
X-Stat-Signature: 4soskb9obes48oij5xstmyt61uf1dx7f
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754655137-508495
X-HE-Meta: U2FsdGVkX1+7wCA/sth3vyc7PSPX5EkD88V0AfFJ8D1WoZ3l83AvdK26LKaM74U52+F1CXqImpwO8dGr3BrNvZYOXzhVXQqg+e1egQX6wdqTQxKDq8wqAI9zvwWC89Hnr9NSMg3Qw+MyX40y3jDnIr7TnsCZ5Uvi4LO0WBJzh5SSyRoGrbeY48IRJ/q/I0vlFt1HXI821KpID3ahSqJNh8Gz4N46FO4edpuTiNJ+9cccXgyv3RHTf9Nn4i1fbmqmQm9jg0Zr7p5TBMIn68S7kANA/63x+BFGcan4oKCZuOgZnsbUKkFFKXcHI4Oqlwd8/abShWb9s+K60KRnGQ6f169VHsLyLkmszfBAzr1MCOevCv3pWdRlzDv4RanEDjRM+sSFQvAm0W9bVNOSn9nza2s/UKZ782HxgD+YqTQO9rOyvtNGKPAR/xXXjaR8u26e1L9VEK1LSc3/ERn1mhyO2i7X763oNjpiif03+EdrM3EgVWhisKCKYq15SAXRiz0di1NxB/82WiFNxAMNSOVbWwlNCSYo4yxITOyOTUknzH3urt6sP4CHEQxkOa1GCdc141ZDDBD8VLTVs5US31H9dUx1b2vN6etvrmF9Gq75htrAdyJpm9ebCfRBbhh47SHYuFrdkcYRjy3ZaGHFQbK7hQvUFxtx4lYpJTCTDPhyQg+tZEOewolKquNsrnUHQ53tKoVSlwkk74h8dtw56yVrUaYSTGZFYlnMEKFZIU8VOH+ilU+tKbaGGiMG202cde4xiaS17t2NajHO1j0FejCB2w6FX7OWE2/+hMU1O23Nuyoct6zvLT3h5CYsCmgiuKhi0m5EJDmfTmFQ3BmuXkdccqelLRp+UQ9QElP0+T05lTfg1Z/CFVUZAAkcwH1VMmJjKCYnrCZuUuNJije6EXOvYuA5npfuiNuOEdVXoX914C8356kZfQEGXgOTODQ+Q2x+cUDCiAamx/4zQgET9OU
 lB6SWm0A
 ABHq8w1EVYvT66Vfdjo6a7xM6/wVuCJ74dMOk3LZI40AQ+d4soeMjw3+gCuhD9sbJ3tA2RJGSAAtklvq9uz5RiGig5OrQZ+BI+p6nY4xGacKbMYfYh09+eTKHFfUl+6GjCGTpyvIc8uJd6QtF9O9VlnFS6bQ/GWRRR96zPZOfN5Ndqj2qZcyUuKxomNRl+j1o0uoDX9AicHsqtgw7G+ygObORJQvyAQE49yPjosl56fXvSQEOHxBYXN2ZypWqlqRlj8ipDGoGA3eLBmHaBkn43QFKuEVwQuZNqZ/M6lUetMPvYta+vcqBggRh4EOCMe1H/7yRdbUWeEMRASOzUo+6q7du/eSA5iFeLL1TJceWXMKa4bv+ZZwDDfDbgw0r6Cq+getKLqLq6YMeKKO83vz89VJ2/9sHdO/pmllA20S0XianrMMn/GPyMWBQ1F2ZqEedD0xlHxXpYjxXchyJe06dqYle4+LBwcVP8Xn2pkv0nN7tWWFKGCZn95ok3ApbfdlSu2pj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pankaj Raghav <p.raghav@samsung.com>

As all the helper functions has been renamed from *_page to *_folio,
rename the MM flag from MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO.

No functional changes.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Suggested-by: David Hildenbrand <david@redhat.com>
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/mm_types.h | 2 +-
 mm/huge_memory.c         | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 3ed763e7ec6f..cf94df4955c7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1758,7 +1758,7 @@ enum {
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
 #define MMF_OOM_SKIP		21	/* mm is of no interest for the OOM killer */
 #define MMF_UNSTABLE		22	/* mm is unstable for copy_from_user */
-#define MMF_HUGE_ZERO_PAGE	23      /* mm has ever used the global huge zero page */
+#define MMF_HUGE_ZERO_FOLIO	23      /* mm has ever used the global huge zero folio */
 #define MMF_DISABLE_THP		24	/* disable THP for all VMAs */
 #define MMF_DISABLE_THP_MASK	(1 << MMF_DISABLE_THP)
 #define MMF_OOM_REAP_QUEUED	25	/* mm was queued for oom_reaper */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 6625514f622b..ff06dee213eb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -248,13 +248,13 @@ static void put_huge_zero_folio(void)
 
 struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 {
-	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
+	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		return READ_ONCE(huge_zero_folio);
 
 	if (!get_huge_zero_folio())
 		return NULL;
 
-	if (test_and_set_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
+	if (test_and_set_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		put_huge_zero_folio();
 
 	return READ_ONCE(huge_zero_folio);
@@ -262,7 +262,7 @@ struct folio *mm_get_huge_zero_folio(struct mm_struct *mm)
 
 void mm_put_huge_zero_folio(struct mm_struct *mm)
 {
-	if (test_bit(MMF_HUGE_ZERO_PAGE, &mm->flags))
+	if (test_bit(MMF_HUGE_ZERO_FOLIO, &mm->flags))
 		put_huge_zero_folio();
 }
 
-- 
2.49.0


