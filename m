Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD794C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:14:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 699E46B0095; Mon,  4 Aug 2025 08:14:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A1D6B0096; Mon,  4 Aug 2025 08:14:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 511D26B0098; Mon,  4 Aug 2025 08:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3FFB16B0095
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:14:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F207C1345A8
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:26 +0000 (UTC)
X-FDA: 83738967732.20.F528C81
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 3227BC001A
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:14:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=hqpyJBmN;
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754309665; a=rsa-sha256;
	cv=none;
	b=7tacoQK65OBR8hFw7UjYi9OnmrojvkL0Rxam0LAtNhKGV7xGi+sgJRR2HXIFBoIhtBaQo4
	fnXbU2kJTHU3PcLrJWipQ3ewn4GhVebyfU3jFyzR2UnHNIMqR1Gl2O5Hyd7I1nM0VoyEuS
	HAaFnwm9J1+jiriW7mtjDd1Wj6Q0EnY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=pankajraghav.com header.s=MBO0001 header.b=hqpyJBmN;
	spf=pass (imf10.hostedemail.com: domain of kernel@pankajraghav.com designates 80.241.56.172 as permitted sender) smtp.mailfrom=kernel@pankajraghav.com;
	dmarc=pass (policy=quarantine) header.from=pankajraghav.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754309665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X5VaNFZHQ+UIZ3WR6R9OAhvW0u/boKe4vv5xZzerPYI=;
	b=mIZBMkpGuj6PvZp40B6GPvSqc+Gs0qI2bU4r92hTX/JWVOoZC2LI0A3qupTTapHW8toFlA
	fFQihC5Eu0mZyomqKHOEuIzdNTqMATmraYkaZmCjJFbd+lNvHK6yngNoWxCLseuXukoqPG
	4N1MZynW6se1XhYB+7iPx3M+4vMIJrA=
Received: from smtp202.mailbox.org (smtp202.mailbox.org [IPv6:2001:67c:2050:b231:465::202])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4bwb8F6Hrsz9t1l;
	Mon,  4 Aug 2025 14:14:21 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pankajraghav.com;
	s=MBO0001; t=1754309661;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5VaNFZHQ+UIZ3WR6R9OAhvW0u/boKe4vv5xZzerPYI=;
	b=hqpyJBmN5S+9+tFYA5ZZm0p8MUaJIBmETy/KUwmZ87TCwxxfGTJEGKZwZnpigomTBopqAr
	kGrWMPK7osRRCFCZE7FC1x+cmC2MGBpPHt2lT1Kpaiq24X1PRkvxKR+ya9aQVI6Pw1eGcA
	MU2FYXdz1BJf1I8Er/H00byiePvy/1G996TwXZubjOcc85Iqo3U4mYQhMIOx8vPOYxz7F4
	eRXVRNCWaB7V7yaxi0DGd5pH9tZsRcvNhlirWHp/8sGhRnAGPzrM2C7ca4p9ftpzFAevua
	hPzZXE0zPMNNMDCCZ6RRKE7apaJOQJRVY9Q4igA87V3Z046Aau8NZK2WdVcNJg==
From: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Borislav Petkov <bp@alien8.de>,
	Ingo Molnar <mingo@redhat.com>,
	"H . Peter Anvin" <hpa@zytor.com>,
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
	x86@kernel.org,
	linux-block@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-fsdevel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>,
	mcgrof@kernel.org,
	gost.dev@samsung.com,
	kernel@pankajraghav.com,
	hch@lst.de,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: [PATCH 2/5] mm: rename MMF_HUGE_ZERO_PAGE to MMF_HUGE_ZERO_FOLIO
Date: Mon,  4 Aug 2025 14:13:53 +0200
Message-ID: <20250804121356.572917-3-kernel@pankajraghav.com>
In-Reply-To: <20250804121356.572917-1-kernel@pankajraghav.com>
References: <20250804121356.572917-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3227BC001A
X-Stat-Signature: mne5t5th1g85xz9s59o8a1m7x46k58yx
X-HE-Tag: 1754309664-324389
X-HE-Meta: U2FsdGVkX18Kgb1+G9CJez6mAiGrG9ZSEzeiHN4KTAyllRGSzTc4rt4D6/o06XBeDQrAgaaGpmRI+gxFgzv04DKiekzkfesRBJF04EpHaAEeDNMA0W/769Ye8BLtgq15fZ0umLHO+Z//t8cSA2kGYlJxcBGsbheW2Q4C8prc/CIza2pZZfT3fS1KcnUOCFivonHc3tWK48wO6KPJt/NrVpslWk1RLRkAbpAoI8lOeyJfl4SNleTBvgYWSk81mEBxkD7MlKnJ6l5RV7WW7gZRk6dHyT9sgWPCTG+W1hbvttUJDhjHseespwbZ4jfbUWU70Uslyb/MnO84zKcIfj20qF/hwGJ+2ZictvDbLvYpree+MH9M6MtMlp6O6dsPoQivB8zObdO4bosUcZ6ZQ6p3CP18P+YM3iL3D/Zt8Ao3mqze9tJvEf6sIba+vg/4Zbw+VtqmJblUauXpnNqgEiaMBtItdFITl0/HLxXT7f+WsHoUNB4Rdz29W3wieuf0HF5+tjRzZD/sI3QzxTSWwVDsWdTG8FvGD3qhRjiEbfNRRTzS4l+vBeK329g/QHiE4mle0xFOpAqwa4C+gJN7RiT/Fu2Gerdu1TWouIfvDqUaPzJa50bGPTVD/IngDGJRKvuOtLCldWfrdr5SLsPpGYfmRizxr7nv816A13h/Vt6rLaZcNWJG5FMdx2uqsyI9x9GtNQSqYY/RiLwfTyFE41X0YO7H6Y3FDZJrWyk++aQ9Ve84nxDQEivR2/X9M8/sXbG2fcayN+zxStHdO7oTWT9TnRH3rDXCkcKM1UGLecYdUkk9oGk2LNkmjpy3wEyfm4Q9nJkvN2f+A6Ue0g2qFYc910J3JaAaqPCu46IwcL8bnpCKQhXvexa0xVtsRx+CdnWChbrijo4q5LYHcE7KAI9x9iIbzbGsRPaSZ1mPa7vW+ZmsF7svvG+jcszx4CkWMB0y/oBmzdQ0GqXQhZ0hOzR
 E9FOXXij
 Y+rQBPkakCji6QRN6sx89po6dMO+3vHp7lMEjffBkLF+fKdSC/OiIiovRWQHdtV04cMo2LkD1WbDdG6Rbowkf7kPUvIFOhgehkciCXBb6DHD1sG8P9WUbATOGWN7Ul+ZuYl6EAt+5Fujc1asWhxUwPKumA8+ncQ0xS4Fgr23vXwEf2y2B9uw22nfuQzU19+/wp15r5u9mn/G93ifsj1/6Ie23nnZcOdB1xqS8ruxz5gNMns4f5jiiU2Raa9iEjbMU2gOi6X+bwvnkHZgik1jIpdEnI0iCNAIRrI7gWqOXA1w7pHedOE7hkeWf89fSsmwtIKrOKV/WbPuCQ+gmpsnuYON9w0uBljr55et+uLfAWB6ppQThCAiLVQTvlS5MmH9+0fPdLKX/C8Xvz1BZ1gxyNBU5nlLBuK4Ojimow2zKJLuSX/AKIelpiP30oyJ3o5sN0KaE8TtPaekp5zWYs7ZJXr0fP+exgrSIV+tvhs38N48/1pI=
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

Suggested-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
---
 include/linux/mm_types.h | 2 +-
 mm/huge_memory.c         | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 1ec273b06691..2ad5eaddfcce 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1753,7 +1753,7 @@ enum {
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


