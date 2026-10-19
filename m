Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D788CCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 09:09:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F186B0184; Mon, 19 Oct 2026 05:09:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FE06B0186; Mon, 19 Oct 2026 05:09:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 465C66B0187; Mon, 19 Oct 2026 05:09:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1254B6B0184
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 05:09:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A1ABB1405CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:09:08 +0000 (UTC)
X-FDA: 85338801576.10.EE816D3
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf03.hostedemail.com (Postfix) with ESMTP id 99A9820006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:09:06 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HqbYwhrH;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792400946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MY99aGpYyrbJvUgE+53njDtXSNtzDrVyeLA7CiNpfcY=;
	b=EnrwmYl3dACa4XYtQeeKG/WH4eeBG44SjFBKA/iqUy1TE5f1jevYvAS7WBpnDVerY13tHC
	j+ARK3c+fo93Ox2GKRlnWs891pVOzilXg9pQ/LW47rxapCkm3JXW7GL2XSHNqcxzWnXMj3
	J/8CX1KFJ+47arZ4voe0lPb0O+5/O1E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792400946;
	b=aEeIt/FHsYFpTLbD0DHG+UtmFB63YSAOchQSrQD3GqDgzA+PbEKJPPiPg2c9o/TYAaGaeD
	rXAKwqwJS85LSlEohgnR/0fo5opYUDitXglvvp5koFBFt1pQiAlOQe2VeTJLZy5bfzo+1U
	LyxZzDnuSbMQNLv/M2sFcQJzfl/Cvrs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HqbYwhrH;
	spf=pass (imf03.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2e977109392so7665555ad.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 02:09:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792400945; x=1793005745; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MY99aGpYyrbJvUgE+53njDtXSNtzDrVyeLA7CiNpfcY=;
        b=HqbYwhrHGnSDlwyVTvooTX6iRaLhgUWz68Qs66z3Z+9tVc+w/KiJvz/UEDBVY0Zxqw
         eFyY8IHphgtIRnWOUkU06LpbilU1iC67zGm8d9E8M4xLeOQc9SHaDK6ekvsEaR3QhYPX
         X/7XMyVRBtnxtMTxOsgnZbeLJugh+sw++P4JKtMInWwB5RvJ9BDsTPEZ+N4zOJHmNq2O
         0K7mNdGwuUzXvBbGBlcIB7ZqdHMuhktktJYE/Hrqx/fFk0+eAQP4HRto02VyhMqVszWK
         M1P1eLNputxkcCBRHPTARnclkjQLFOZ4dT0ZLXzm5IolgV3ODRM36SCK/qJhI80LNXfW
         aHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400945; x=1793005745;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MY99aGpYyrbJvUgE+53njDtXSNtzDrVyeLA7CiNpfcY=;
        b=SurMyrL/3gghqPucp8EB4fHBfUCOsKN/JJStk8fMkZA+rT4XG7XbdLqQ1N5H2Pwir5
         MbQyKLQ7MiSb0y1+ZAQLKr/ZXHwrLZxh1tFVZ6G/NKxshZXgHOYohIIwljAUoHUKRkw/
         ZC/t8f55tPRgiu3RbxTGV19E0xpmGcWO9rf9lovJNIZybdjph9/js9C/4cWQJho35kMx
         FDaMRFrrqEQTqkPU8CApQiRCHujz+8xyD9vX7S1pPvNF+cNUDMDeUywf3xG4ucgM3znH
         NXc6C9Zv+nJZ+VbSinyEDw1WmzvmkG7DYJABBVevP42uXyW4i4UuILLQTEkQt8jW7+dq
         IJjw==
X-Forwarded-Encrypted: i=1; AKwUvBwvSJpgYO0K7K2PT0EV9CmKdJBjLFan4vHK2Twb1E8ikOzkGbmyRNMNt/+KsFgghPoxKp4ffV7SQQ==@kvack.org
X-Gm-Message-State: AFq9FYL/xLkOs0AgfPSFM1wBjxBdehCb+2yXpJpj5OCF9xtKGCOjwBix
	PZaHa+uOp3twJhqlg8jGUocTv7TrQ0Np3Z0/4VKz36Dc1jxFT11Y/2H7p906QleZ5BI=
X-Gm-Gg: AYBFou22arkrvGzBw5c8Sp3hvKrDpTEIao37ek76qe48QR5dxPLAuwMCMlZr69r7Vtx
	ZCaB+Hz08dhjzUpIVn0gdBs1HkYRCpKMkTgR5FxGpaZ0s1mOHQ7tkX1rgloPaSxvfMFVLPxWU8f
	m5F3GgcXORdVFT8xBryWy35eWif86ebv1THlXs90DSrTXBLX1WcVu249bx7Tx5VThQF20/LiQYb
	VK/bCGRFGUYi6OZtP/pDwrpY7eDH4tIn/zOvSaxRIUwlSwQ1vfWplPViegIH2XoLjotTim26OAW
	n/Lw43pMJ9hgPlRIFgzMUg5E3oMli2vgvoNTLKZpX0IrE06/ILf8uQiq54PD7qXiUBQ0iISeSDK
	bJRMZrLuiPrdzN3ICN6CJf1oHQtXeA2IHop37OepoZqbYr9GtyjBG+MRVAh5N0L0eKqGq6IV7Ho
	KN/a92UFkc3OY0/N9PW6txkcUAQQRups2Gi7uJ1wFL3ZIsP/l/uVzEnf4vlBDIQRd6sheX1wwSM
	X1g9dFOK0BdoaXsOdQ=
X-Received: by 2002:a17:902:ccd2:b0:2e8:1d5c:f6f9 with SMTP id d9443c01a7336-2e9a6f51258mr61061775ad.46.1792400945396;
        Mon, 19 Oct 2026 02:09:05 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2e97e305f1dsm36707595ad.0.2026.10.19.02.08.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 02:09:04 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 4/4] mm/hugetlb_vmemmap: remove hugetlb_vmemmap_optimize_bootmem_folios()
Date: Mon, 19 Oct 2026 17:08:30 +0800
Message-ID: <20261019090830.1917657-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019090830.1917657-1-songmuchun@bytedance.com>
References: <20261019090830.1917657-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 99A9820006
X-Stat-Signature: m1iby7jqfftq7s9bo74q4e6ybuyd8eea
X-Rspamd-Server: rspam05
X-HE-Tag: 1792400946-204003
X-HE-Meta: U2FsdGVkX1+3ow0oUqT824nMgmE4EUhsuMzjXnuXk/wlF+rykNppJjqoEamIZrRiIbtwQEJphVaTMiCI4kD9uENkOigGdynM1VJW73h0/1BiKLggQ2xMi+9p7L6a/ZDk+0toT2vVXS7mRXDfrCupNDaOc07LwrUoVzFymrZ1xiXBPvoTLrmi8pGEbfkn+oWpoxDk7JwM1tJ+3ahOiQSdNFIHznyP49LkJBgCG4xQR22hCVwbZbEPe4euvyxmw5LHsXTgDh1EMqHx4DZVhphyX6FgUqnuBk2mT7I17AgNsZ5JX90ycEqdp983TJmQDWqAYK8dWgQlTg0cBAHNOWzFROpFv3o87yRjYjMUnUcL4Fijl0ESkfIrrgQMjwKa/KqPisn8VVzbP/hdEO0vOFCcCKmJBEULHQKXMT1U/tyK7L8gKbEDAbI5mFB3v5TAJODzxA39cpRcckwR9RUZaSJdBBnkNbctSW6UZXleomyFe0QkjfmVjqyJVsKoA02Fr4Po8nrG4Wa0HmQks0zXZ/TpiMxSTeAe7ujysurjXG0CuBTgebZT5oOzqan88275D9KlHiY4FCke1h4Ni6k9/CIg11obtOvpidky8BZNAtg4Sq3iUw6tukLFC9FcWBpyFDUhHw1JkkHzYMVehWTPtoweAD8ZFjKGZqqwj3bOeuuwzaStAd6KPQtBA5Fo5BamKvaEZ3+1mYNuBkzkxvU8Co+r8beLf9Ad25mgOrYK0R8zWKhDGWjfq/0b4ewc1S/lxKnaj9TOAo+oOdAimJJ4IB/259yuaZDed4Xl2tebqGjGaE3OJVKW1dS6IODocb0BE5JtK/lLYQ6fAczT6vq4T+Roj/y8PeQI5zvWeQVZcBKo8Kbc/toKA+BN3O9QEIZTSk7oOf8q1FLd8MkeDeLelQ7tbdukuBTsF9H6rZDGt5FCrlYfZ2h6pC/N03wGX/BDqDzm+und267R07VmW1tEMvg
 0xUhMjfy
 nLQAk9UOXZfz98fD6vDQy1am+DBHhAoKGDKZg7ZP67molNqeyOnbVjUt5Bl9V+Y6GOQHubqWuS8UTz++KZacjlw+icp3udw84AWaUXddseo1wxrHduqQGIxMZDK8DCxNakO9CqJH73SRhpqjsSQt3Jj21jt3CsMLl65BnT0rsyvFMNitstpGbc0XMpFrvzpGzp63lU67rozXJm3bgNF/mYCJpaSt5mfYntnX7Hzj+E02U2ePGQfJac9P7EL1MKVR2LN1ULHy7zdg2ebWYLB+lEPk5OKlFZISh36bEeiGPl8c/gjBYJNuIMhrvkQ+Q091s7ajqys3hHyjgo8tOIYPQUW3L0ikq9FzxbeBdr2SnPUu+M4i/4sC7v20pxlETW3NMeV8wefNxOHs7Z494W/3WkeSvWduGkOvfq9Y32VD+JGj0dYjP8kDK1UQzJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With vmemmap_wrprotect_hvo() removed, the bootmem wrapper no longer
performs any bootmem-specific work.

Call hugetlb_vmemmap_optimize_folios() directly for bootmem folios and
remove the redundant wrapper.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb.c         |  2 +-
 mm/hugetlb_vmemmap.c | 29 ++++-------------------------
 mm/hugetlb_vmemmap.h |  6 ------
 3 files changed, 5 insertions(+), 32 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index b37d7d0db7fc..64a21b7e820f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3297,7 +3297,7 @@ static void __init prep_and_add_bootmem_folios(struct hstate *h,
 	struct folio *folio, *tmp_f;
 
 	/* Send list for bulk vmemmap optimization processing */
-	hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
+	hugetlb_vmemmap_optimize_folios(h, folio_list);
 
 	list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
 		if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 3d72346c2ca2..236e1db9517b 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -588,19 +588,16 @@ static int hugetlb_vmemmap_split_folio(const struct hstate *h, struct folio *fol
 	return vmemmap_remap_split(vmemmap_start, vmemmap_end);
 }
 
-static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
-					      struct list_head *folio_list,
-					      bool boot)
+void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
 {
 	struct folio *folio;
-	int nr_to_optimize;
+	unsigned long nr_to_optimize = 0;
 	LIST_HEAD(vmemmap_pages);
 	unsigned long flags = VMEMMAP_REMAP_NO_TLB_FLUSH;
 
 	if (list_empty(folio_list))
 		return;
 
-	nr_to_optimize = 0;
 	list_for_each_entry(folio, folio_list, lru) {
 		int ret;
 
@@ -608,7 +605,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		 * Bootmem gigantic folios may already be marked optimized when
 		 * their vmemmap layout was prepared earlier, so skip them here.
 		 */
-		if (boot && folio_test_hugetlb_vmemmap_optimized(folio))
+		if (folio_test_hugetlb_vmemmap_optimized(folio))
 			continue;
 
 		nr_to_optimize++;
@@ -626,14 +623,7 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 	}
 
 	if (!nr_to_optimize)
-		/*
-		 * All pre-HVO folios, nothing left to do. It's ok if
-		 * there is a mix of pre-HVO and not yet HVO-ed folios
-		 * here, as __hugetlb_vmemmap_optimize_folio() will
-		 * skip any folios that already have the optimized flag
-		 * set, see vmemmap_should_optimize_folio().
-		 */
-		goto out;
+		return;
 
 	flush_tlb_all();
 
@@ -658,21 +648,10 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 		}
 	}
 
-out:
 	flush_tlb_all();
 	free_vmemmap_page_list(&vmemmap_pages);
 }
 
-void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list)
-{
-	__hugetlb_vmemmap_optimize_folios(h, folio_list, false);
-}
-
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list)
-{
-	__hugetlb_vmemmap_optimize_folios(h, folio_list, true);
-}
-
 void __init hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 	if (!READ_ONCE(vmemmap_optimize_enabled))
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 464192e32dec..d717d0d10960 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -24,7 +24,6 @@ long hugetlb_vmemmap_restore_folios(const struct hstate *h,
 					struct list_head *non_hvo_folios);
 void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
 void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
-void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
 void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order);
 
 static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
@@ -66,11 +65,6 @@ static inline void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list
 {
 }
 
-static inline void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h,
-						struct list_head *folio_list)
-{
-}
-
 static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
 {
 	return 0;
-- 
2.54.0


