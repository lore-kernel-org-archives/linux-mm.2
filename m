Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27DFFFF8861
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 10:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BED86B0088; Mon, 27 Apr 2026 06:58:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 670386B008A; Mon, 27 Apr 2026 06:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585BC6B0093; Mon, 27 Apr 2026 06:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 483056B0088
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 06:58:22 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 06A1F4011C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:58:22 +0000 (UTC)
X-FDA: 84704036844.15.2B79FD4
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id E908340009
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 10:58:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MERY5AmI;
	spf=pass (imf04.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777287499;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wclsbCz45VsM77RlQTKKMaoJPnWAhWJRZZhkjEMod8Q=;
	b=RU23ODB9I3UNEm3yB7K4h4JZKG1QOw89pa3vc98cKjMC4nvSvsmKquvKhvfLJgPJpVmO6k
	SzZVQPhplmY3+L33aZmTcynJn7dDiYz+h9AVw3uG25viGBH0VwIWNkKl+LqdYI/db+JnZF
	vXrqKnORXYZMjFA6EXihKlYzCnCoSq8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=MERY5AmI;
	spf=pass (imf04.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777287499; a=rsa-sha256;
	cv=none;
	b=OmMGgz1m771dMOfuzFVIAaaCMRT94mL4cYHcuqQAOou7GEsOwQoZKpHKSSQ9uEIPMiHqtk
	6yFWgWbk2DM92gULq83rWT2B18ssm0OSm9o2i9cO/ljUmGLYmKl++A5kAp2i9OFLVBC1up
	kKDWresijftJHKVh6XlNBX/TjinpwN8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777287498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wclsbCz45VsM77RlQTKKMaoJPnWAhWJRZZhkjEMod8Q=;
	b=MERY5AmISDbORg8UT5rnTDera9Fq3MOrsiql9omx8HLCRtD+5coGDzFPQGc9O5I3y1Fvlr
	4gxcQMZ3yXKtzinj2FTlZ+2QgiiGQmEOtnavi+BquZKg3oYdEYh+UUNKfGZkW8mmDqf83S
	k3/LkDpBviXCRjYZsJovrn/zvSIe5i4=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-94-gwfItt3BM1i15YiwhLLMoQ-1; Mon, 27 Apr 2026 06:58:17 -0400
X-MC-Unique: gwfItt3BM1i15YiwhLLMoQ-1
X-Mimecast-MFC-AGG-ID: gwfItt3BM1i15YiwhLLMoQ_1777287496
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-50d8e8c47a3so269560451cf.0
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:58:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777287496; x=1777892296;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wclsbCz45VsM77RlQTKKMaoJPnWAhWJRZZhkjEMod8Q=;
        b=IGl62j5axz++6qnjQghcsjh91NkLZcIzTeTHruDVfMECP4yitFbVBgckr0o/TXnh96
         aeq+ey/jF3m8kIVy4NxoKfdtdkR19Ci5DDfozkOWTuPddh4vEPUWE9K5tDlPf05UJ35b
         GSPa9DjPxURovc1bvaa7TM94c90AZMlQOJVp2o6PKikjWXNDHLE5AOCusrCsmCoOuDhM
         66m1NECORSleMX/U7JZQfg1BLt7P9jXIeLb1QbLYkhXT3RQxQZUmi7m/7RaSWIWCQzNd
         ZIzVJc1lJEXsECHPO6VhFvjLp6oAkSau67cniUc/eNsy+su15eB1DCy0CIamhcDmNJ1H
         Ro+w==
X-Gm-Message-State: AOJu0YzgwbjzHAFmYWtzXSxRYtc9CYeWRJHRRGKruGS4sFJ0Xyvyj1Y0
	0zloHENKF7ZZ0xgHZjPFtKlZoa5T8zf1TO8DjUGT4B0lJNfpH34fmHJUAUxlQhH5ifUt3dOmFl+
	6aerP5oMoAVNORhlvbF6UjHFUcxW1903JwrZgteWxt1ILcPkRmh4eMrMOaR6R
X-Gm-Gg: AeBDiesAeruigiLQ2zssC/uLxPBSbgsYykNEmGlhVOSV2Rc0K47nCprJntfyYoc5mR8
	hIa4XhxngNqQwQPk9rsQnQXUvSooV/QQXOvVgrCHTswJGBBWU7x9utHyh6vvZk8e9KiGv/3kfxQ
	DkFyNkPjy7n6aK1RuHKWqVXPMHEPSLEd3R21bXg5Djev/eY9LQUyL7AX6bfT1IBDmRdh/ClnaA1
	9hraQm2Obmd7CR5S3tWSckz/OjZFuJHk7jwS/lFjEsMQRD7Z+jgIOCJ83fjKYDkMzEcF4YgpnQp
	eQmuJn+HOW3+IX9ATftP3LHLhC5T24xzGg0KwyDq2KNzi0REoClRf11L1GHW+Jp8yl+YZIRXYK8
	WYm9sKqNfUCY8ENn58Ukn4K79GkAo6fo3SYfjpOyzxW/eH3phNq2WEE2M4CnVXIzEDTulpp0S5+
	WwP5mdwKaHWMSZu2b9GymKhy1I38YVtdR4GBs=
X-Received: by 2002:ac8:7d56:0:b0:50e:ca38:e219 with SMTP id d75a77b69052e-50eca390557mr474867681cf.45.1777287495887;
        Mon, 27 Apr 2026 03:58:15 -0700 (PDT)
X-Received: by 2002:ac8:7d56:0:b0:50e:ca38:e219 with SMTP id d75a77b69052e-50eca390557mr474867401cf.45.1777287495453;
        Mon, 27 Apr 2026 03:58:15 -0700 (PDT)
Received: from [192.168.10.48] ([151.49.85.67])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e39495192sm263471871cf.27.2026.04.27.03.58.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Apr 2026 03:58:14 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-m68k@lists.linux-m68k.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mm_types: remove references to s390 gmap
Date: Mon, 27 Apr 2026 12:58:10 +0200
Message-ID: <20260427105810.23761-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WLhbMKJY-miH3in11Ds17Fx2ep6nBn5Ymo9npTXEpsY_1777287496
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E908340009
X-Rspam-User: 
X-Stat-Signature: t5w3qfam8pc7dx3hkzne9n3x4unfdje9
X-HE-Tag: 1777287498-360502
X-HE-Meta: U2FsdGVkX19HXRQKRJFfDEq65hHJ4NpNeuYG4tikR/4zLhnzg3fCt/AACrS6w/WvhXSCmzBMtJi54vdZCsmqhS8TSIcOvbosEHkxGOD+cB+TIA6/6jqL4jBAfXjmhCozGholrKxdGRmIfHkQBR0Awi4yfYjj0iFgj/igr3yl1POEDUZ1+LrXTJFzkkJSTfxsg0j5nAUYpBh6XJKxp7HGTtaugQxtAWx+foCg78JvskgEIfNkMHBPhoX9hFFwhVp894J88OTzaSUUJJAU/PUHcuE8hSDkj5BX/+JHn5Xe0dCuYBsGv70LLC5WSlVXWVLXefqq1L5QdJfJeZJgIdR+ZqtzlWJgl+5Uc/LyywCof9aT+0y+oisiW+dVMEIqWaymrzslRHk/zWJKXmr5sgyG8QNQ4owm37nrGn7IeSoDl576T+/17F7aVgQMfBkSFYwUz1lu5KLMqyoZ+flxJ2n/4UJ5h0CV2lYnd7VC49HaUVisUIuHUmNofsHaikLeTdr+YnZINJedukiR0d8Umb4TBiFJZkEQQaE+HjE0FTau4QG0BRZse4ndir6keErexaSgixO5GAXBrkAyWlJ09pC5Ip2PdMzH2MwNkiAj9qp7NNNpSAlMG9u5HCuuBRzCC3PXQ9nZf0M/GWRqItiJOrExzB07O8qJQ8DS/v5ykpnjJZI3TnRE+VNh80ULlnVdDIT1eT8YvAtZ3mJ/WKAZbJK5E/Dl+gGXzHwwuAypFJoK6FegDn8UAx6bzZqZFCHAFukNqRroAbovLb06jHLd91qLUbI+cE9dDfstad5c1TrWlAwxtPSmQjC6yCqXkRICSA2UFuF39b0Cmp2p5cLyGKaNqCM9wFTgdOSonvnLZ7l5IdEtFIIcpqzAyWc3OWMgtV98gtYIxMfaeF/ufXFdONRdT/tWcKxsFZCLso3ActOJrygWVp2i2EQ8P4gvAwfjitxf2O7ONmrHstah+VenEBS
 sC61yCcC
 VX/GtoJrmIQF4tNKFhZlM68IGnDTxlIMHd4FG8Z6vSw3p4ZuT8LtFaSX9jJBW6HibdoGPSKKyevhCteNewX+l8YaIQw3gmNp51J+IUAFavnw55MMCAYgZOo2akWhY5OddMK/GCKBg3w9vOPYD3xFcrtA5Vcd2pFhQ6sgPD1kJleU0u1+firsepIoHDyqdIINZEAX6ITLctAJGWGi9Qqv+yNVIApGc1WIi9JWwIF5CKwj8F9HKpHbWeX/PR7djgksWs9j7PTnDQfkiaZtndfHbvMkK4DhIXQmS8JgNOC7uw9JaPY5+4C9dF1YBPJMsDOCXEUJBHZpH94Ni81db90c0b2y3bQ6Ee+sZBamt6JHx/64/6YTVitiFGLitUH/d3rLpqYFcNjEjCgMmZFsEefkBqm13OQiDnXF4T7ZxUzFElK2wyDnzGDsj1JXJEBuByoBvmum08M5OuUYH9d0vgrPxbj/5fOF7JT+6wcWL9SHjVvOW1xLNwBCev/BZYMaXvj6uu9jWaBstZ8gk8a6gWttCKG6H/gxb6PyzYaR4ZIk4i1sEEQhd/pRLe549Xs3sdsQr6sx8vnTEnwefgV4KiP2QX3MdBabCEn8SchWX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

s390 does not anymore use special struct page for its shadow page tables.
The honor of giving a special meaning to pt_index is now m68k's, so
rename the fields and adjust them for the desired type.

Cc: linux-mm@kvack.org
Cc: linux-m68k@lists.linux-m68k.org
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
	Compile-tested only.

 arch/m68k/mm/motorola.c  |  2 +-
 include/linux/mm_types.h | 11 +++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/m68k/mm/motorola.c b/arch/m68k/mm/motorola.c
index b30aa69a73a6..67e8a2cf4c41 100644
--- a/arch/m68k/mm/motorola.c
+++ b/arch/m68k/mm/motorola.c
@@ -105,7 +105,7 @@ static struct list_head ptable_list[3] = {
 
 #define PD_PTABLE(ptdesc) ((ptable_desc *)&(virt_to_ptdesc((void *)(ptdesc))->pt_list))
 #define PD_PTDESC(ptable) (list_entry(ptable, struct ptdesc, pt_list))
-#define PD_MARKBITS(dp) (*(unsigned int *)&PD_PTDESC(dp)->pt_index)
+#define PD_MARKBITS(dp)   (PD_PTDESC(dp)->pt_markbits)
 
 static const int ptable_shift[3] = {
 	7+2, /* PGD */
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index a308e2c23b82..9e4dbcddaf33 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -550,13 +550,12 @@ FOLIO_MATCH(compound_info, _head_3);
  * struct ptdesc -    Memory descriptor for page tables.
  * @pt_flags: enum pt_flags plus zone/node/section.
  * @pt_rcu_head:      For freeing page table pages.
- * @pt_list:          List of used page tables. Used for s390 gmap shadow pages
- *                    (which are not linked into the user page tables) and x86
- *                    pgds.
+ * @pt_list:          List of used page tables. Used by m68k pointer tables
+ *                    and x86 pgds.
  * @_pt_pad_1:        Padding that aliases with page's compound head.
  * @pmd_huge_pte:     Protected by ptdesc->ptl, used for THPs.
  * @__page_mapping:   Aliases with page->mapping. Unused for page tables.
- * @pt_index:         Used for s390 gmap.
+ * @pt_markbits:      Used for m68k pointer tables.
  * @pt_mm:            Used for x86 pgds.
  * @pt_frag_refcount: For fragmented page table tracking. Powerpc only.
  * @pt_share_count:   Used for HugeTLB PMD page table share count.
@@ -583,7 +582,7 @@ struct ptdesc {
 	unsigned long __page_mapping;
 
 	union {
-		pgoff_t pt_index;
+		unsigned int pt_markbits;
 		struct mm_struct *pt_mm;
 		atomic_t pt_frag_refcount;
 #ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
@@ -612,7 +611,7 @@ TABLE_MATCH(flags, pt_flags);
 TABLE_MATCH(compound_info, pt_list);
 TABLE_MATCH(compound_info, _pt_pad_1);
 TABLE_MATCH(mapping, __page_mapping);
-TABLE_MATCH(__folio_index, pt_index);
+TABLE_MATCH(__folio_index, pt_markbits);
 TABLE_MATCH(rcu_head, pt_rcu_head);
 TABLE_MATCH(page_type, __page_type);
 TABLE_MATCH(_refcount, __page_refcount);
-- 
2.53.0


