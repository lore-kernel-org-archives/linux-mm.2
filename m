Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35C83CA0EC0
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 08:41:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBA626B0137; Mon, 11 Aug 2025 04:41:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6B0C6B0138; Mon, 11 Aug 2025 04:41:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81096B0139; Mon, 11 Aug 2025 04:41:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A87CB6B0137
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 04:41:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64E6DBAEBC
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:48 +0000 (UTC)
X-FDA: 83763833496.01.41F08E5
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [80.241.56.152])
	by imf29.hostedemail.com (Postfix) with ESMTP id BD5CF120015
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 08:41:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=aVMV4hxq;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf29.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754901707; a=rsa-sha256;
	cv=none;
	b=LcN/O8QGbHIngW/YgP4A8Wkt1FAwtsnLYGSz1e0R6TdAfyuFKU3/mLp7bc4bsVRY2fAjIX
	aR97RejpKw/QKiELOLzS3hl9PzPSACVfXhUizsdobhy+yICBn2/0H0w31cBPtrJ6B2fawS
	VUx2DBn01EAGXyGLjjjLotaeXMP3tkU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=aVMV4hxq;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com;
	spf=pass (imf29.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.152 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754901707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lUZ7WtmWLoytrmXItECRu19QRh1MV13CnCf09RIJKKo=;
	b=LTHb3XcW8irPZ7UxPmTKcZNrmAIroODojI9GIReJXgXZ3XKr5gIY2xe608RSPzFRw7QTaj
	PUxCIDbmYRkynUG8BG+sCC41URfq18pXXLCf84e22tWCqizEG3dAXATOnYNlGIrUaZST8u
	rJFG7Lu2tXiGK9V4QptMhJ0Q7qvM4Ac=
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4c0p5g2QKhz9scy;
	Mon, 11 Aug 2025 10:41:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754901703;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lUZ7WtmWLoytrmXItECRu19QRh1MV13CnCf09RIJKKo=;
	b=aVMV4hxqdrJ/w+Dhi3PQB0knp6EQFRpSo46schhnfElLbE6CjEZAeIvK1ehHDvD/0Tic/g
	nZ8STAmYaMDg8sHjCeULTE+X+ojQAsEZ2k11AAnZARh2HV7LgBmmo/5xPQqNgtQsqI1cxy
	29IuW6kPcxqNtoiZY9yQQX8PWTJrgoU4Wks1105sIeTCJV8OhDqjkHZQTtN5uvigIReOnL
	gIvUQhDY4ZK+AaYuMiY5lKSHjS/1ZiGmeEYIUXKcJkIOwwi0iYjniCtFfLIpST8VBuRYi2
	daUNip6xcW6NheFZoPEPMLLcEvccs6jfiepEL2kZX+TVy3O8gKpHrgGPbPn8PA==
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
	linux-mm@kvack.org,
	willy@infradead.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH v3 2/5] mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
Date: Mon, 11 Aug 2025 10:41:10 +0200
Message-ID: <20250811084113.647267-3-kernel@pankajraghav.com>
In-Reply-To: <20250811084113.647267-1-kernel@pankajraghav.com>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BD5CF120015
X-Stat-Signature: jj38dyjc87bdtde6dzsydyi61rqwh5mk
X-HE-Tag: 1754901706-905105
X-HE-Meta: U2FsdGVkX18QDk+OqxND/JA/DfacJqsF4339oXF/AGt19Uljum2ZPiKt2lrHdslzpcQyqqI8hxEs89Q7spZuca8YRaTFHQGh3m/i6aYCPzNM4Y93a5VlN5Vslp7N16nYZwBEjr12PQwVNBq+1a+Iwbu1LkThc4wxFWF70fbI8YrYulqPsANn+BzXzVtDM9Ys8SgM8XHuZNeJ3nc2XW/u6o6SnRhobvopV0j/AWXOGS3fpQlnxI42XM6biwcV0F7FgZYN/eKJI807G3QGbRbIQLULeQ3Dpiapd4dfJ1FM86h8GES3NkpaVAe1MMdcAy1icjwWjUO5BiIF1rohPsvu5HbSYkZhV8eTI3AiOzPxsX7ID9oj5KBPIWsrt41ayE/G6uv9It/xv87EtEUPx7VKp/Flm30s7eMehyJ3Ap3ytswNxwhcE13ZitZUnM2lK/73tEdU/nIWWIF1Qi0Kb/9+bw1zRheBclDc4a2M2gj7GfTpw2JS6fv6NVbx0ZaphKQ89anKW0cVa4IFFZCE0fnfaO04jZiTWkGBUGIwXi6HBslHPhzXZcXHrU8hcwTvR5A50vuZHTj2pPiU5RtfKy4p4iwwoBcO/cgR/nAkTBe2KxRr6aY9y2h0YT2isjgSBGntQUO8retn64R1OyFyJtz4fOAYsRsTeP8GVDLJLRO69qGcg2Sb5x5XUukZ70XFIRgEjUg83PPMn7pga629o1WEKl7NmXKZUG20fWtBn4Ner/nEFj/e1Gv5UN2nfrz5E3BtOHObizfVyLEKTW3WWa/km0nmGgXKzDduBIUawRnZO5BGufQLBYl4fu5ePcBAUjMxY40ETjn6ZyoiTV+5Eb1aVMht0wfpV1WEv8FRSdS2WcMFWNvUu2kqKYNV9aCnYDEtmavSfC0iPnl3WDNxtTsWsr8/Fr1j5Z2VJIMqP7FWU0DAn0fS0BbrC9EQqGI4pVWzgUZmOidw9KgS7diYId2
 xZOB4Grg
 gTjrP661tTUMZLzvGepKlxL6aEvn1xvz+NJCG6SXdsf/o+Y48yj1zW4elC1GFPdzcs0sXKPXOwCXJbLlRKNn3OTzeZr6LcsPCM64Td6PIiUegZj5SITJXeqd98AJyC76L+CV/
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


