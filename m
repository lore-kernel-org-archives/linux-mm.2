Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F6B8C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 03:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 910C46B00A4; Mon,  3 Aug 2026 23:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1836B00A5; Mon,  3 Aug 2026 23:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7893E6B00A6; Mon,  3 Aug 2026 23:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 454CC6B00A4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:56:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C94A81A01C1
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:26 +0000 (UTC)
X-FDA: 85062224772.13.837CA9E
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1D3251C0007
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 03:56:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dBvqeBng;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785815785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7mhQWWJoMKDun63XH5Agr7zXFay3hqxZE0Eint2vdW0=;
	b=tN/5nXJWuKIV7UNyEgaqpmDaEV4iFXlOIlUBpKyQDuK83VMdQBrPSQmCOOG4m3wKov4mZ4
	tZESeOgxcwMq4FXkT/dDvu6sxwjO+sVlAE+AB8dS+FXMHr7pEgHPJoQekUytX8OEXy7P5i
	8XedLKNnVxqDYoF3hyQ6sbLKpJV2FAo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dBvqeBng;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf21.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785815785;
	b=1hkkQxeZpjRcOSzS12lgPKczOr7TJadBh6vzTitw1ZJJ/KzumjCfKLf5qECJcuFDbAvK9K
	S11yPWplI/qLAqhm89AMvKDuaGmggI5pWgfaiokmdBCoJ0hQs5XRm3lMn5NRDJSbRCfAs9
	NnPYc0GhtjS5+af0ABLIYgCkZtPPYRk=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cf452def93so4643715ad.1
        for <linux-mm@kvack.org>; Mon, 03 Aug 2026 20:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785815784; x=1786420584; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7mhQWWJoMKDun63XH5Agr7zXFay3hqxZE0Eint2vdW0=;
        b=dBvqeBngryG15nsVw9YM41+TrdoA7ClZ3N/z9iFYr6KhfB+nZmGcqGO0WCxnuvxwdy
         /pmIUBMqAmZzyWrW0Ofu760Rfa+sAknMomypaZsDFbmTRoBZrbGrO2qnWjT/rDWJO3Aa
         LgO8TsAQM1p7p7J/BHMIDS/aX3Q7ZFD92Rqkokg6bQoNUlIqNJ6ASA0d2m/XLSosbHTf
         6QRt5SuQmUXHP7q8VCzao92djf08p9ywLmjQy9SgKzTiFdtoTlqU2VxLtr7xnWmKXSbr
         ip9CNam6ZVGjNBj7JvPq1R6PW45qfWTFR7UKmBu5WD1WeVnKdpQ25zDGcShQvP317utP
         f9PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785815784; x=1786420584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7mhQWWJoMKDun63XH5Agr7zXFay3hqxZE0Eint2vdW0=;
        b=SPsT49tw6ZF21eB5EmG6rjJWIUCmaUNOg3LpSCkqIgltYwBrXOLEi60uLTR8Z7i39o
         lxzZv+n4NqXleFx2ChJyR0sXaLpAfVUL/t3I+RX+DBuAdTwIJDuP+yymjMkz1I/0sXTp
         MyKnIm/Sw9kmzpe0mzkhYXBrh4UOpiHVcdpXfcXRKHGqlZCvD3oa9jnQ6mk79kOQdZSO
         QGdUWD0itjvme/h0G2I3ecAv+9ioybFe4c0aHSBsv3h3qqBma/x9Ha/iZOlLOf/dc+UX
         Mv7oDPm1Xfa4K/ay36I9CYNq4eYuYKt0s4tXr3Utneht2gYIrjJnkWxjLBorSxnj6MtH
         zLPQ==
X-Forwarded-Encrypted: i=1; AHgh+RoULLiAXRq42xBC4HCc2Mkj3rH7Y1/L3bFdKBQUyu6xxibHkMIo4TYk45xqNNOWGRMLhGuAKpBbtQ==@kvack.org
X-Gm-Message-State: AOJu0YxI4Ja4tkiHJ3ziAgPEpz9Xwc6g/Hs9Pps2NWPzhmPw2czlTwYo
	fsg0WaI3IEa1Ykh2oFQ/sGHQi3O1oBWwgvfYu829FznaORHWgdzg/+56jc2P8QUpfQY=
X-Gm-Gg: AR+sD11StTqlibpVRuS3AMWjRo2VVB1b5OrgX9+AJYpvWkbTufyaR/056hVYzlrOxNL
	43NlM/GO6yKzoWZXOw1JSQfhtImtnvFN9SnE+ODuldaJG36Ho1bEOCPAtw6kcGqimkBip+OWB92
	6LoychwsOvz10VxbSJFq/hYczbRipPEKIHr4fPR4Ygyv93AKUj5cA/BPeWeIya/U+LWQ7pVD4yt
	AkNR3KnrnUKnWqYw/xbDS4DpAlHzz+FSNoxMgYRNe+Fu16yrDFltQacAKjfbB3hnhD/nMSfxsSG
	EH8fRGnvROG2eUe+q0TmHs+ko357JWaj6R0DKJRu9jynWaBwjgWjLCOkyM1eSnyxHJbKCibNu8R
	KdzR0qeIwSzy9zA7VkkA32ZVJu0pNehZC2SRfPdNgYnaLaiRICLvFyJ/iXM/pnrP46Kgg6C+GcF
	RxAFGZRQs/pppM2NSmQXGQ4bWT5DMN/UfYRa/QnbrA+sVywn6BZBs/4Wh/Xwhe/YzXfJj5ietne
	o+Qq1Mx
X-Received: by 2002:a17:903:3d0d:b0:2c9:97a7:3283 with SMTP id d9443c01a7336-2d08ab6ce8fmr19535515ad.23.1785815783938;
        Mon, 03 Aug 2026 20:56:23 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae99af1sm46313695ad.33.2026.08.03.20.56.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2026 20:56:23 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v3 09/17] mm/sparse: initialize memory sections earlier
Date: Tue,  4 Aug 2026 11:55:27 +0800
Message-ID: <20260804035535.2846016-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260804035535.2846016-1-songmuchun@bytedance.com>
References: <20260804035535.2846016-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rejia9ia9948ch3xqfxre1u8bhx1iztq
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1D3251C0007
X-Rspam-User: 
X-HE-Tag: 1785815784-433826
X-HE-Meta: U2FsdGVkX1+ZVSQ8vFaNfWQM8Ki9tG/s4nXm+F4rDq7wWNhQtYh48LFLXgmNfSzit4sw3VY4s5O+0XlmJvfarfMujsSId6NgOibDY3sDrOUst05agttBl3lc4qNnJ0nbfxA5of0Niu+MzTgewUIvmoG09IWzuZ51XziHhCoTkMoNMyFWa6iT0rKan4M3gYJBSOOIghONwMyUHLwo04myE8C+PZNmm2dR2empkyNaFt5wt6cZZfW63i4X1VQuiCdhdiy63Fw8EaV+50fnDtWGIOLnHSiNGibPcw7QcFTL8s6JgYbxmCj2B0MxvbGKWCCIk2AzOnAa57PR+GGHWpUhiucgJFeYFPhly0nzfBfPz7ui63pCqGptrBeL8HSz+wFBrByndTvUdBBjHtrB5fJq2MJZAoyP5UZ4RSdPJFclTHANIIOSimbX2sKMeS2p/J0GyOKVga6MNo9QdwdTITRDbnCntD6faXzYyuj2sPnVATIsG6K2lZSLqOudSWrKDJtjulChg5z2VFmO+O2VzSEC5sk/xXChSQTTInv2GmwarNAp5YHc+GmJMKFh9Bkfgh3r6ozUKqRd5UpVvuOg9IoDUjLRDchBdpjVuqLTC5cYZFA3r5zQivIU2pwZfu0D/owJNYmoQnby58U9p5JFBtb0iQdqRVk2QeFwbvc3SWtgsjo9sxhVPkzm6sS2q99CbUHUlfnU9b6ViKGSt6YVMpdOK/nsWuyntPeAX78+nww8K7vZdivXE6jklLAMNZGb3DLTDsjGAL8P5FXIlgw1A3UOxZNg1FKwF600TAFi0/ZqtruP782JN8yaYlJq/OK5sdRwTHWuPXPEWuDrLafzwWUAbXlf5ua1udxVDH/UfwXBhP4iKgjSm2R3uEkoTTzK4wDrLf0dOSkWmJSTO9yix30n/pLMNftEfqIszAaJFkBbajEvIM6CKkWx055KbgOsbfyY97SaH+wbXwR/KXta5t8
 /FqJMFAf
 lcHn/8/QRTmMKJpp0OJY+HjXJxHEgkZjgGjeX8B2XkQI9QePtapoWCmeWB4vRneqOh6mH3uKM/QiyM2iXshXiHGzKO7b5UyEGS/HBBQavjhzfy1K8FNcFlBuZ6vgwyiLdulgjQyOBBhWq10Mkbxf5avvQ5Jmjzv3CCjqf1ifuzgzHJjtczUp0w+TzVPNSrs/07gq1tT2gGhSTl/6kwJrdmiT5yZb7vtN1IWeRLQmuVovqg5ck5mvuY1vTY4MvCXF1KtqFtgS/iIcRygEsVVDLcxu4/j+htlEr9M2q7pRCObF4yb7549F9+fsXhgD9lDVD3Xc6e2fwsWL18osKI3lUwkFfZ5EvrqDNPU/1xwjcKX5sPwL0MY3inxUsD2qS0kF9ZO+INSCOLbqhDYY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Upcoming HugeTLB bootmem changes need sparsemem section metadata before
the HugeTLB bootmem allocation path runs. The memory sections are
initialized from sparse_init(), which is called too late for that setup.

Move the code that initializes sparsemem section metadata for memblock
ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
bootmem setup. Rename the helper to sparse_sections_init() so the new
caller describes the sparsemem-specific initialization step.

This is a preparatory change.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Rename the helper to sparse_sections_init() to describe the section
  metadata initialization (suggested by Mike Rapoport)
- Fix the !SPARSEMEM stub name so SPARSEMEM=n builds compile
  (reported by Sashiko)
---
 mm/mm_init.c |  1 +
 mm/sparse.c  | 10 ++--------
 mm/sparse.h  |  2 ++
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index c37fcbe9a319..1855ad3373aa 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2634,6 +2634,7 @@ void __init mm_core_init_early(void)
 {
 	kho_memory_init_early();
 
+	sparse_sections_init();
 	free_area_init();
 
 	hugetlb_cma_reserve();
diff --git a/mm/sparse.c b/mm/sparse.c
index 24555a32a5d9..d4641aa70497 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -191,12 +191,8 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
 	}
 }
 
-/*
- * Mark all memblocks as present using memory_present().
- * This is a convenience function that is useful to mark all of the systems
- * memory as present during initialization.
- */
-static void __init memblocks_present(void)
+/* Initialize memory section metadata for all system memory. */
+void __init sparse_sections_init(void)
 {
 	unsigned long start, end;
 	int i, nid;
@@ -332,8 +328,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	memblocks_present();
-
 	if (compound_info_has_mask()) {
 		VM_WARN_ON_ONCE(!IS_ALIGNED((unsigned long) pfn_to_page(0),
 				    MAX_FOLIO_VMEMMAP_ALIGN));
diff --git a/mm/sparse.h b/mm/sparse.h
index f8f852f9f8a2..16b9bd3070aa 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -59,6 +59,7 @@ static inline bool vmemmap_optimizable_order(unsigned int order)
  */
 #ifdef CONFIG_SPARSEMEM
 void sparse_init(void);
+void sparse_sections_init(void);
 int sparse_index_init(unsigned long section_nr, int nid);
 
 static inline void sparse_init_one_section(struct mem_section *ms,
@@ -98,6 +99,7 @@ static inline bool section_vmemmap_optimizable(const struct mem_section *section
 }
 #else
 static inline void sparse_init(void) {}
+static inline void sparse_sections_init(void) {}
 #endif /* CONFIG_SPARSEMEM */
 
 /*
-- 
2.54.0


