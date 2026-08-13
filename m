Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A5FC5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 06:34:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA6B16B03BF; Thu, 13 Aug 2026 02:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE2EC6B03C1; Thu, 13 Aug 2026 02:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA9D96B03C2; Thu, 13 Aug 2026 02:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9026B6B03BF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 02:34:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2060480544
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:12 +0000 (UTC)
X-FDA: 85095281544.08.A543553
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf09.hostedemail.com (Postfix) with ESMTP id 55B93140007
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:34:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ib6zr4RG;
	spf=pass (imf09.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786602850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1LR8qmps1zzw/pTZUafrLgMPeQ5Z2NuLpLtuKWLfIg=;
	b=7Hgs+itybnTsbG/AJTAnwMORb/TrjV1+njjMqAGT3I2JNGUwZITeQfrkPR+X1jGDY8Fgka
	pBA3uMbw/vqEYsSEF+gdrrwlMgBLRhU5vTGipKYYgz0Bn3F9S1b21Fhzp3P6hCtgIwr3dm
	IgDchmtTm/Ph2TVBWg1+sAhcJr5eD5Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786602850;
	b=oBZvRPCXxYLhKWs4CV9PwkvF9IP+zIOuTuEik6FONReCdAtlbCwyILRSkW7yDOAUOYaAYC
	a7Wthf0Gb3gM2rMQAmmA+YJ5qIvtg3/ImcV6T/AssqsxV1rMAEJo2IMM8UJaySsGUE/tdX
	890GoyNgd2PLMOaZoGFwtd7lx9PnkXI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ib6zr4RG;
	spf=pass (imf09.hostedemail.com: domain of thehajime@gmail.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-39266382df6so1724064a91.3
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 23:34:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786602849; x=1787207649; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t1LR8qmps1zzw/pTZUafrLgMPeQ5Z2NuLpLtuKWLfIg=;
        b=Ib6zr4RGvmwUkfai20OYlMsRThwJUrSHMxNxY5BDRDAFuXuhje+VYNL5ahp2UBoIU+
         wApGOpq+Nik7hchqCzQZymBXJErx4yM6qKmmbZ1RQGzNCt4B+Pg+48O5xT290UihdZe1
         StmQ6UIREauHsTYXM9rNdvRQw1toFuHK092v/MWORs5cZErnEelmRush+lHcZuHrmwHU
         y5WjWlsFz2xleJzQyel6fm814HvGpN4e2i8Qao29Kl4UdExzr6ahP4I7D8d2W7H3rEky
         UfBZMiWNnmuHQvSWAHQD4HTdVkHkl34cGZLJoCKIi3DyxzuDk0WjRI3Lqut/A9YlIsjF
         v79w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786602849; x=1787207649;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t1LR8qmps1zzw/pTZUafrLgMPeQ5Z2NuLpLtuKWLfIg=;
        b=B2pg4rhaQHtciMSQUh86jYFwlomB1warBTW3seOhEF+XqFsKQ+Se6iOXRN5zBEmRbt
         P2Insp326yKP2D9qe0rUvTzH3A2GyK67XuUTr5awlhk7qTr79n3NCme8xbkMhkErWnxH
         asVXeBKA2vC7VsC8jN6KWD2Ox/FCtWZZXToSaQd1IEGhk1D3waMRIyCTYl6jIg4qj9z1
         LW+fld8060ona5zqjSTOV2QhKxZPFA/5+4CsO3YdTPVSvPJSA94smPrmQxtDUvSgLyeu
         gKs+fyydUDn7G914HybTjITptiXumUKdlGGtMyeuQKcWf/8FXPNkhqhs1k7KlMuFH9TB
         O1sg==
X-Gm-Message-State: AOJu0YxaSRh4l9J+BZE8CCvx4gIJf6mvy8MaeD8mDaGbYAkxgvKgqPKm
	zj0DhP7pcD96+kNTjHJ+bCm3PN8kxgnIJSbj4OsLK8S0OXnDvM7sVPc2
X-Gm-Gg: AR+sD1131rUD++RFXkE7H0jPmAhMhYMB6SBkJzxXXKW6y86KgaKm9/4phNaxRBsGzTZ
	B9czB3dhuLg9lP181RqQYRpMCKYJ43qolgeFhsz7N/Y1Ow3qkTYS6XMWVb9TopoMvqyLP68WWHe
	MH4FmtrzSgQm8smls2AyG+qCqQHXZva8Z3inaS984hl7Ox5CmeyfSCqEOpONroOZtMS+l87eIT+
	qtfMriJK6a4ZsMpOmogem/rDAn/DRvFyd+5JurTBPfvbMY3iWRcRJi94b7lOGKeYh5xndr/ITRz
	hkG5JcqkQO80NZM1WStOORNX2IlI6U2mHr5ATlcOSxj/bU8YJ1YKYRJeTeGZ+lXfty0TyPrVTa8
	VzATOlNH0NlQh5qZXSadllwLo6oB3x2L4rRnh37O1uVlOUBLbHjIVbnB6kRObOpRI0D8gVa1lt8
	4Exb7S4usO5aKd5d39NKa5VBmQY5RU4aKgtmUTjrQxVNbeK7zlpFIQmW8mcwgJbVtxdS/llZqHO
	FuGq+XhA+OcNEzco1xETdv5s4VgD032WwX9al9BM7k8CqI+rFP9XH1R2gAUOeu/3Q==
X-Received: by 2002:a17:90b:2dc8:b0:38e:e9b:ffa4 with SMTP id 98e67ed59e1d1-3931e0262aemr4531251a91.6.1786602848998;
        Wed, 12 Aug 2026 23:34:08 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3931f44ddf3sm1649259a91.14.2026.08.12.23.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 23:34:08 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 6204315B042D; Thu, 13 Aug 2026 15:34:06 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-mm@kvack.org
Cc: geert@linux-m68k.org,
	daniel@thingy.jp,
	Hajime Tazaki <thehajime@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>
Subject: [RFC PATCH 2/6] mm: nommu: use vma_is_anonymous() to check if vmas are anonymous
Date: Thu, 13 Aug 2026 15:33:57 +0900
Message-ID: <20260813063401.1786548-3-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260813063401.1786548-1-thehajime@gmail.com>
References: <20260813063401.1786548-1-thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 1qxrkn68waq8zon1wqbkc413hrczexg4
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55B93140007
X-HE-Tag: 1786602850-684222
X-HE-Meta: U2FsdGVkX1+BAS4efBssdSuzJ1RrAyC9c6M6JMY8r/7eawSx6Nwqya+lbmCXDJ8bLSRJIDgFE27x3Y4fQSACMPc31gPVK7GOYFUOge3uqRX5oFqN45FRoNpdV77NeEEUQmclAhbqwaYH7xyHLE9DB2FZy8IAD3DoXXCHQG//yqRdqTjxKy3WNAmyys2kL9ZBqIuJ8D6JAQPHBmp4Q5m/GPw3Hm7hQJ3l6f2PsvfY8LEFn0AdArlP6QksAPlqiyHixxh8eGvyihquA4HZMnZWb8azERaoQ3UyPp6935PtBj5H+BRHiW+xivsaSyUDlAKbozLxNO1CmzfKWmh6dfHiPL7O4BLnRGmlZzmH6Nl/3RTEIC08RdIsH/dTIIeTZUZX2mhOhOVVKMrSZqpqh4o6ROKcpl28w/wxJ+5zGYuqzbDrQqF0bEhcQdz7D+ExhJRP4JVwR+NtnWMhTyq886FJz1b8jMO+JkCNveaqaJx9pL4EOamxToVJm7sbeAO11/6rl6crkdgIMvd06ye80X23dAZQDsn+SGJCLYv3rPKyl2TSLODOfurFGnT/jbd2lOyt1AK3ldY/0Nh19vFgMD2X32HKL4JkuvFw2A+kWO6ONRicxBUIZGcASW0Erb0F/GtJJwq0xEgPxrmnEsJLorN+vSRMEN9oIsJUdx1FADDBuLNluu+ou72MM3KCkrjpIjCGGT/J6mX/XZl2RajjQb5VEReqrdZHRYmec3j8//M+YLhLLSM60NIeBYnx2nQOeVChodkHZQnPzR4VHdwpRpbdlkH/QQlILY8iLP1Hr+eCi8fXnRFIEFOENBjpLXgxxu8nO93zw/sdejs4/+uhktk5hjAijXdHZF8Eosc8mLGxJHS41uqolcdKETEM4Sgpv1Hc1gts+ukQ2E15gE7Tl/gNUyd6SMLKGtASCQoLjWJ9g/ly0cDge2eH9AfITq3dzjypLS64t9frevs+datay6B
 oMivSfQh
 K6F65NSmpl0WGie03vbBYHtw7CLUk4Gt8nzz5Yp2fs9OXnD4xtSJmmUeHWg7+iMcJGy1jfuSCsAIkhY9OEh1r36y6ty6ITQ8lOt4pi24aezrHto4C3ylwkgjXDjHBdUJRlYRuLJkU0/aWDFRmjWL+O/uEih4Qv0J8hjgmSkaE/hlWm5DEdLci1TJMNtqYT0+UnraifNHwuR0FzXRn8w4eFyBqCBdDQ3X3YLe7qSVw92qLjyvZzwOB3DSHxUwA8y+BcgezVtffu/MP0SHTuRhvZNcquGV85Oc0v80sn9WJjcOCYwRsGll3UrqYBq+qr2aZ07ei+KTSUzBV09gsKrLDch7JHv5T3gnlEqiRXy3V/b3WzbSHHYYE5HLLmtT6sTJYReQtb8/EZFbRLmeR0cdeBgVH+RcmTpDL1Xq4zo3yKyaIDmH/vk1oGD+veXy+2s/PytaH+jWZ0t3A/VyYqYKrAZ/D8ih7BrGtuH0mIiNKSPa8/miOkLqA1sSarGvurLMy+NkJQ5I6H/PV/cG4ALwg2WLoPWeFuOJbaumB6SboEyca5K0Y3b7Fwi8QN2VTRliZM3XL4CZTR5KEiq64UMh2zVcGOG3mmUDUiel4XAK/chvYmayxe75wgVHTr7thOcvlYjpP4hj+stoRntKmHxQukhaEklzDaOHaDLUOhS2sWveOFqYNRc2tr/a742zERSczxxdt0Q/N1YvP9xW7bkapuMlLzuSX3jJDUnEs7xME2dhWN++AdfCxqSeRnQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Private file mappings (like those from /dev/zero) can have vma->vm_file
set but remain structurally anonymous since they lack vm_ops. Testing
vma->vm_file instead of vma_is_anonymous(vma) might cause mremap to
return a spurious -EINVAL when userspace attempts to shrink these
mappings.

This commit fixes this issue by using vma_is_anonymous() instead of
testing vma->vm_file to address the case of /dev/zero.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org
Closes: https://sashiko.dev/#/patchset/20260710054648.924005-1-thehajime%40gmail.com
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
---
 mm/nommu.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 89444ee2aca6..e40990e15831 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1196,7 +1196,7 @@ unsigned long do_mmap(struct file *file,
 	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
-	if (!vma->vm_file &&
+	if (vma_is_anonymous(vma) &&
 	    (!IS_ENABLED(CONFIG_MMAP_ALLOW_UNINITIALIZED) ||
 	     !(flags & MAP_UNINITIALIZED)))
 		memset((void *)region->vm_start, 0,
@@ -1328,7 +1328,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 
 	/* we're only permitted to split anonymous regions (these should have
 	 * only a single usage on the region) */
-	if (vma->vm_file)
+	if (!vma_is_anonymous(vma))
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
@@ -1484,7 +1484,7 @@ int do_munmap(struct mm_struct *mm, unsigned long start, size_t len, struct list
 	}
 
 	/* we're allowed to split an anonymous VMA but not a file-backed one */
-	if (vma->vm_file) {
+	if (!vma_is_anonymous(vma)) {
 		do {
 			if (start > vma->vm_start)
 				return -EINVAL;
@@ -1617,7 +1617,7 @@ static unsigned long do_mremap(unsigned long addr,
 		/* like do_munmap(), we're allowed to shrink an anonymous VMA but not
 		 * a file-backed one
 		 */
-		if (vma->vm_file)
+		if (!vma_is_anonymous(vma))
 			return (unsigned long) -EINVAL;
 
 		/* vmi_shrink_vma() needs from/to pointers to be removed,
-- 
2.43.0


