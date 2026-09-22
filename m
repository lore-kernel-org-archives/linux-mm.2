Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 530ABC982F1
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 05:35:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3B86B00AD; Tue, 22 Sep 2026 01:35:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170B26B00AE; Tue, 22 Sep 2026 01:35:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05CEB6B00AF; Tue, 22 Sep 2026 01:35:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D24AB6B00AD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 01:35:09 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5D8CE1403BD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:09 +0000 (UTC)
X-FDA: 85240284738.25.468A425
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1A38420004
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 05:35:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VQS5CPWR;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790055307;
	b=r3XfuIyLvOeGxh0suOK7jtgk+VI0fjqKKIJXFh4wEtoXmk6YNb5vhxDjNV56+40lrfknyT
	Z9FYBfy0TUhlu/PTTd8yLzSALDNxwldbAxzSUGx/0AMOimoaURQ7NPfabndrsFdYDZ7Tlv
	QV+b3wDx7O73s7lg2cPG3Hpow3isB5M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=VQS5CPWR;
	spf=pass (imf13.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790055307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j3/indgfaSaWc6lWBv7sZZH36jWcDt4waMnqUjoKZgQ=;
	b=bqi0h5ObRikoHSCiGN9dsVVMx7Rm0j6r8mwLff9dUxG1l6DKen+q8+EeOltKlfWI9FRFrZ
	+8/6TXWSrCeJrs7UlkM5Kn7LVjUxZMOYArbIHdQKnw4fB9nZlDlI86jbFxImGwmqOfjgoa
	Y5YEL6r3rE2YPksfchytj7q/AfUZbDg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1790055306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j3/indgfaSaWc6lWBv7sZZH36jWcDt4waMnqUjoKZgQ=;
	b=VQS5CPWRqzGS58O82hPZzXW8492UTAchvT4Ny4pzwxjXnEzTb/XEbe5YjFk4Adl9WSdhP/
	1cNoyEPGNxHz3Ej8Lar+4Kunw8DFDdnKryzYF5opBAjC5d9baDoxJGRD01Vrg8AkjcDRmb
	GdkC0qUaBDpLEuzonmayUSm5UXRwtxI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-386-hANfAon3M_S5uvJB1TPFQw-1; Tue, 22 Sep 2026 01:35:05 -0400
X-MC-Unique: hANfAon3M_S5uvJB1TPFQw-1
X-Mimecast-MFC-AGG-ID: hANfAon3M_S5uvJB1TPFQw_1790055304
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5b609be5e96so2237462e87.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 22:35:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790055303; x=1790660103;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j3/indgfaSaWc6lWBv7sZZH36jWcDt4waMnqUjoKZgQ=;
        b=1plXIVKwi/3ZzvgIH9fb0/0rRF8hj27LhmBxmkjCOaISxrvVsK27F8X9i+y+yk71Vv
         QrdSDKXJlr25B8aRAYZGXiAxFQVe32QMVLguKu8RHC6Rj2eHlI6ufFpH4sdC1ULlTzbZ
         6BYCgyn7EDL57k2+hVlXR6SFRkoCtCB9nu0iFLmUq0bx7yi0tVxsM6e3eN3sp/DdPjSQ
         SVScWh/eJiCtorGMgc5jifOKyLzcM5iOawQr3Sb0ae0PjZ4CrNOTa13gAmtiloJHwaHL
         H/V/roRJhny9h6Gdz/S6ADwbgFpYjRqzZXkz8xstrNT8Wn3j2u9cX3QJb2ob6b7pAB27
         /Y3A==
X-Gm-Message-State: AFuF++ljB+88CdiBB1a9mNrpaQwsxYjrQyV0x5ZprEa1B/tqh2ZhCtWD
	Gyp9iWO6xyBy4lSVx7MsyyIn1z3CKMkkpjxG1aWAGSzKYg1V+H6SnXolXXQ/ozd6VATDY/xg7Uh
	TkMvAL51ZWWYeP1QqOC5iREHwHbdgp4JGukPYtt+MNbCHl0wkGoP7mfwnGvthpj+jjFrfQO2lD3
	NzFctX0xjGM3BLJiF7Mga23hMPQsxAXg/WBqZRmA==
X-Gm-Gg: AYBFou1ZJvbOXYz8WZ2V0z8xmO956FLRtEpZLjyV/F39m636HKdlHsDEOb03pyPPLDf
	SAizTyrpU1jUE/o3HaxaKH0kRn389C5dBSWNXvCNEwEF/XZYlu/l/HqgGyJakp5qM5/yG3RqHkG
	XPc6Uu63rfrs2/hQbC6PqxKzVF0O9cJJg3+DyitW/JOGIeGS9gUw1tKcAkT7wALOJppnNlGbFhn
	uwLyVu1beEtHFxv0HMobRjgBWPkP1hiABXrPfVg5K7B/K5mU2s8BEbtZduMPb5W4TazIk9lCAlS
	1nEQEoU00kXIk1CG3jHAz3UiWkEFdnULVWtXDEs0YsA6dfOFTAaPL8IpHo/rlQ/kJwHvkHiBOFt
	kjlR3nhzAbvSNP0huRGAQAy4Z5gphfpE=
X-Received: by 2002:a05:6512:110b:b0:5b6:183b:d215 with SMTP id 2adb3069b0e04-5b8c195af81mr3584660e87.60.1790055303532;
        Mon, 21 Sep 2026 22:35:03 -0700 (PDT)
X-Received: by 2002:a05:6512:110b:b0:5b6:183b:d215 with SMTP id 2adb3069b0e04-5b8c195af81mr3584632e87.60.1790055303030;
        Mon, 21 Sep 2026 22:35:03 -0700 (PDT)
Received: from fedora (89-27-86-246.bb.dnainternet.fi. [89.27.86.246])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d46e0966sm191742e87.55.2026.09.21.22.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 22:35:01 -0700 (PDT)
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
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v14 08/12] mm/hmm: add lazy MMU mode support for migration in HMM pagewalk
Date: Tue, 22 Sep 2026 08:34:17 +0300
Message-ID: <20260922053421.4092027-9-mpenttil@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260922053421.4092027-1-mpenttil@redhat.com>
References: <20260922053421.4092027-1-mpenttil@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KnMgIdKrjFF319Ji9i9YMiEssXl63pF38XASqe0WgxI_1790055304
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A38420004
X-Rspam-User: 
X-Stat-Signature: exomsdimjry51dce7uw1zxt6ja9xshsw
X-HE-Tag: 1790055306-117478
X-HE-Meta: U2FsdGVkX1+cBMGs3K+SgZghitkFKAeQ3qpIQWmZFCnwhMerBxQK20w5t9Jywqz5D26/l2fA7FXuzCxYlB/uCPQUpuaTOkIUjLzZfJ0K2uW6LH+PynZiYnj5A+VT4gHqcoI+Ld5IKbkws2SpKEPfGHJpPTXlAMOUs3EYA2qXj8FEqlgDWhFN9DG9A/Pum02mDuaBBTW4mDGzQF2BYZ3bfXqSboMBfNvc2QIgBzaJOUw8OYeUfjefxjYfyM/MLr6mxjwBJMp470t09UpEJCafh/PwyFJcJpST81jaDoIx/g9W0WpukEflqQgAIUf314M/1OpoFYVdC0KOS865M2bCQz95JpYUY2+5ULn5PtQ5AJ06xo/TC4XkdiKtWTwYIBmSFzX8D74SWFrXsfHchfXhZzvaTfhdipyGFYQxfatxfAiwuP71QhxzV1LhY45W8B2BHbAjev4bjdRTsjwVhlObISP6mSBADcoHsDOPnBqSGfBpNqcrprhGbPbgFNFr/dojC7QMs5zwrlah6Egl1GsF6GhFKVy5e4Cvt3e33ATNM+4FGmx6Tazxisf6btv3JTzYUCkqSeVpSzCFOVr145XYorEwY+MlB9Q+5GOsIzLU3ydThe6O6bGzB2kMmXpB3Mx4zaBS19qkp7O6xsXK6TxQX14cwlzi9xkw2KFvOthEciFPkjs6eLw/y/L8ntnIdnEB5dH4K4FSjwGwStZDdAqfiDOUVudxy6jZOOKJ31MTP8CqdeCapGLkBCxFjt/IVZ6jFF581dSmOJYS6w9nvo6EgKNOg6t2OjDF11jMPp6hcTKXC9tQfkwzxUDA90ScdnX8KsCM7ijCwnpHkyUmz/AzGUQSdo5KltA0nkX0fwTa5J5Ne6uY/V5uCg9dZpFmC0sYPGY45BwSqqnMHDhQxYQWCvypoXx8XdQHOlmgLhGD5DlOWT/LGDniaWvYDPxOuR5Hi6jv7M29IXT8OMiw1vl
 0B+HW0kS
 pNjhlyWFSwJq200gHzpQj86sTeG3IOMCAizGL+aur3qaeW1utgqd8fAwuO26gnWvgXAAiEsLz9KkBI7wKo3M4IXVGQvk8bI8LrU3RH0kSPRyzu05nP/9Y09sz4I2RxQiP4TJyzg4Mv9TP0XDZXMS0XajkVsxZEZZrhiymOOsxopr8DM+ZTmrr5X3Sruq7s/dt0q6g47BFsyKAKTCSGtnMJOZdyByv4TIrGCf7VM6KwCs0o8Yl8XfTwyurkB6JjyM7QOgYAKdqZ1OmIv64EQXzoYc7d+Vvgz/3irF8SWhVALxWo/3aeB6eTTnJhtBFN9StQoq/5SSNMeAZCm3TNV5gq0YcCIRgVI6VjXf3be1x+AyNDeZStJwgiBafq6CLK2Wsap0297RMurydC51gsk+GPRezu9KdICwAlLipc+cQadKrQUVrGHYDZWi5BxYmakw/mi7lw0IrToRJqWwQFHcFLAu555YJICeME5OH6Y25FHjkiW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index a1459bd34c04..a67a23e54551 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -371,6 +371,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 		/* Report error for everything else */
 
 		if (hmm_vma_walk->ptelocked) {
+			lazy_mmu_mode_disable();
 			pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 			hmm_vma_walk->ptelocked = false;
 		} else {
@@ -394,6 +395,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 	    !is_zero_pfn(pte_pfn(pte))) {
 		if (hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0)) {
 			if (hmm_vma_walk->ptelocked) {
+				lazy_mmu_mode_disable();
 				pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 				hmm_vma_walk->ptelocked = false;
 			} else {
@@ -413,6 +415,7 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
 
 fault:
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
@@ -510,6 +513,7 @@ static int migrate_vma_split_folio(struct folio *folio,
 	if (folio != fault_folio)
 		folio_get(folio);
 
+	lazy_mmu_mode_disable();
 	pte_unmap_unlock(ptep, hmm_vma_walk->ptl);
 	hmm_vma_walk->ptelocked = false;
 
@@ -1135,8 +1139,10 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 
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
@@ -1178,6 +1184,7 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 		flush_tlb_range(walk->vma, start, addr);
 
 	if (hmm_vma_walk->ptelocked) {
+		lazy_mmu_mode_disable();
 		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
 		hmm_vma_walk->ptelocked = false;
 	} else {
-- 
2.55.0


