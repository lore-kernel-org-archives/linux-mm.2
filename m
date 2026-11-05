Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E105606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=NlLCPM3F
Received: by kanga.kvack.org (Postfix)
	id D17EC6B05B2; Thu,  5 Nov 2026 09:02:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEF1C6B05B3; Thu,  5 Nov 2026 09:02:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB63C6B05B4; Thu,  5 Nov 2026 09:02:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 864AF6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 09:02:22 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0496BA0A2E
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:21 +0000 (UTC)
X-FDA: 85401230124.18.FC8D434
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA220140019
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:02:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=NlLCPM3F;
	spf=pass (imf26.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793887339;
	b=ON+l8jcyukRIIm8PyKWlz2j74DFhi268du7Ymd4F6a7/0EMKnND/xHnZUL+RHa27nAQNWg
	EIp+Exka7YDXcCY/fALEuEXrgsiYKUyccjvDClTgQBVY+ouZztKWpWUCnjH18/fDDUydbs
	dLx6EUOU+v85Cuqy56HDIw7AbnZuAN0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=NlLCPM3F;
	spf=pass (imf26.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793887339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0d6VE8Xxg+YHeBUs9f6ShKNxSqy9UVeoYr+QVUfLKo=;
	b=QLT9vRrC/VGuEV/RobQcR9hvYUvYfLaffnUoxBsKzUT5ZT3w5oJU0X/zmFsJ3S7m3YXFNu
	4JeF/uSlQZNFfFmA0P3g9VjdM0QNx0/oaKAMmRqL6BvgXwVfafQJvP4fWhQTaJ5idkUTcI
	1HcbJ8QuoCYOjuhjBNVG0SL1CGcb6Dw=
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-8b33a08df33so1906887b3.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 06:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1793887339; x=1794492139; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P0d6VE8Xxg+YHeBUs9f6ShKNxSqy9UVeoYr+QVUfLKo=;
        b=NlLCPM3FlG8krLUgXrSiZkzF3zy75pdkXlXnXrwli1hRk6E/aCtiOhbdbHsFGsnsvC
         QfQfZNN/59dn/ZZRM0DFIvvHZGWjjtxnjHY/tYZMMB0EmZfn+1Coe123O/lQphUtv9Xc
         ZpPeLq0J7u6Wm9p+UDp9eb/2ppzVExchqhvNg0DHyRuLlIlw6dtW+GBL8wkRyj+PcQ3t
         KnfFRWQ4LyuUUFJqAW1UyP0zjqn32uxkD7fOclYYFJqK/za2IuBl1zJo5mE/JVn1GxLY
         +FVYRu+Gtk3QGUzp/NOdLOexHYnHuUpHNcBUQ5861AfWOsmjKlsMESAxDtCTLnoVkcXI
         j4VA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793887339; x=1794492139;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P0d6VE8Xxg+YHeBUs9f6ShKNxSqy9UVeoYr+QVUfLKo=;
        b=EPxJ+wENIJlbNGeg5fz9HPaqsIvJTPRViWveYFzQrvpqLsGvCr75njbxW/aA3BIYEZ
         eBa7F3wc8FBog5uUxfwtTMZwfwoXthl435IqEO6/y/JBR5eZQZFo6mi9DtTRtN0wT5pr
         3TzcU680yuuyuaeJ3DoeqmBbknbhWorZHlRMoCDlEMNto1di4AmbjK27MY9889zMz11y
         v3EurYvQElDwuf0X217C98YTR39Vypwj2n5kWJ1YhOUO7K8Nv/Zk28excM8z8ZTE3MHd
         q6yiFbap5sfbQz9LrlnsuvrsDaqbLSlDTikNnaGQjE2KKWE9zKdeYau4csafsML/sa5+
         o69Q==
X-Forwarded-Encrypted: i=1; AKwUvBxtvS2XqTq+hkZOQzWPMrfwVM11+cBi7hjbSzYpRz/vCMpoRovQmMh9TLzenjKfbDkrRxUDp+f0Kg==@kvack.org
X-Gm-Message-State: APuU4Z/2+m9Z2XpLAsE31pljajhD4ObsbN4aJNQGNztHN9g2pfKzxrvD
	sL+2B0DlmYmhmhz5KH2Iuj9bUSPeZ5ymX0TcY/TCqI/n1ubeXnPCTFovAvBkBrkaKqE=
X-Gm-Gg: AYBFou0NJUR34mbvb+gjyrd0xmJlvHfYQhFycdsk59t0sGk6K28xWiG6NC46A/5oK8z
	bXXDRnXM5O0lejaFjaDHwrO/armTzB4SC2P9L+gDBUqgp9yoeotPGIzMlBymHt8o4vlxeNUVxpt
	P6197+AjWuOCMBL+7y+ir+AferdPi4clvmvXEZKT4CbgEnGavWAiCsNyc2/HSZ3x90jn5gIhrCT
	/RXVav9VPKIkeeg8JdD2k27rHQ1dQVSyFaq90+x4adZifabsZSFIDMuzuRZh8ctJhnmSI3jK0wT
	I8UIePweZEnZHOC+VBPNWXlG2t2J6YUvz1IGWps6ZjKF6oQl45zXnQTZcBHffg8da0oYnee5Jan
	Uszwx6e9XBbVZKoVgU4i6n1HJUDb/4jUT5CLEX1o+L3AP1i3hRuuJnqDBYRITk1q7OXyVk/LOJr
	yM+fDOEJG1WhIoKzjc6A3mCrv/sz5gGil/nM6HqPihZ9zBX4kR+4Sq8zmKECSN65KMLvMehJt8Q
	T53O/+eIziLUSNtG/mw1b6TR0kQTPun+BGfqb1pGH1LvWPQ61mR/tGy+ymfItnNBr9FIjjxwGDz
	LVC14dA/R+VR+tFveZhgEPm5HW0zBZLPElZ5stWs881eOQ==
X-Received: by 2002:a05:690c:c707:b0:8a9:a1e9:2665 with SMTP id 00721157ae682-8b328db920emr14100817b3.6.1793887338563;
        Thu, 05 Nov 2026 06:02:18 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.249])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b30992b0aasm40722867b3.17.2026.11.05.06.02.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 06:02:18 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Thu, 05 Nov 2026 14:02:03 +0000
Subject: [PATCH v3 1/5] mm/mremap: fix hugetlb reservation leak on partial
 move
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-b4-mremap-pre-split-v3-1-f8789de76849@toxicpanda.com>
References: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
In-Reply-To: <20261105-b4-mremap-pre-split-v3-0-f8789de76849@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1793887333; l=3823;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=i9R2QfX6Wwas4a5Gy/St+nxvaWI6sgILJM0qO/Y58VA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QO4SLiPWQwytHUwF7H4RiAPHLp7yvnFj+vHoSzp4vwTgR//weZYFHjhEWL9ovyefJ/rHcQWYYKC
 vydARvmD1Wg0=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Stat-Signature: x5t5bykxgym7o1gfgotx9csrey6cqt3y
X-Rspamd-Queue-Id: BA220140019
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793887339-451105
X-HE-Meta: U2FsdGVkX19lK/4Mh6Sl2jOlNSlyjuRg1tisaVjcN7FAlIDD+CI5byA8+9oWcghs+WlbqIn59w05uSsffvtvB4T1t26rE2xyFZS0kI1MevoD4ogPEtMibU5Z7blklYUFIIeB8wfKOkWWQ88bGSGJJfZfOTov2QurOVu/JCjvBaN8iU0WXGOdwu0RlnsHZycQ8YTKHAO9M7tFU/P8UHVKdwiEoe5HJ7iYG03Xp35NrzIc9MYb+fSrD0B5Km0dbdvxgtLlpijjn4ahqVMIOvECIrdx1B9emMH8tbEcwLMfhBkbUjwFEdVBcOpK3MrUXLhp+nRtqh4nIufDyZRpIiYqQhiwE9HClgAUYzxG4Mll8XNk40rRObF5P/BWf3KeGT1XoAvacBaLTlCRiX05kx0GlkyHX1KrD/dZtcXfZFH44eeRxZai63Ha055r8OZlEq1bb7wyi0CiF4iGIPmUBYdC6sfwQypgBAHAHb0715KrE8Z8o+ssUMMJubVKlQWYb8CwmP++zcgnQcbSkq81ZdUiHy47G9JuR/kGZ1Pau9dFr9Y6+S5nfvKOj/KMLqUWogTBjJfMrQXe3BLlyupCmhj2HNb32guMR8AzHp5Zz+afcQoduK7sN+N/MtPWin2VmQ9qK5W9XBcGK4JUVCl5tVeqm3/AN1qpgvFSXg6GokoIqrE51msDtsxKMfWt56hb9kyDY6a6+0TNhObfuB1TyeDCFvSww1Q614iYpWw3YBBbJUUU6Dbt/URFCjwE7et3MEnL5DUnawef6JWgiZlMdFVALeE1KNWtocELndjMJr31U5gscHRqGBEu1JCP2sq7pScuGUlTI2x4NsJOHnT5OOXHHY15IKej4UOz4wK8q5EvOCXhvBgm+2eXxS+OCYAeMK3oQsSzT3T0OQhk0TFl+2bSm2eR2KaIJCl5TyTeg/IdYhLLb1pLOjjv91UHDda1fR0ZpIFRR/OVpdrE4KjjeB5
 pe4ZYg7c
 mdyybON6OU9aDGY7HdXlcs9YsAlVhThYOEnsPyeSzkniUT0xdVXzpkHPlFqGCilXvzWFYWkzTotVrLSsdUNS3JALbKo84khFYyYKEPoHzwppbCsWNDJl7NqVx0Sz4kUfpCnnjndtL6Nppqv4Snu0PdpZN6njc1DJTRugSIXgwv+0k2tr9MNobNIzA793vxDC6l7oxS8NtjNm0z09O6aVpYfjr3EGTl94hUufTijvzak6W3iOlX04i9sxmQStoB4YXaBS9MXySHFW6lM/86PThg10dAUgIAz/hjcoCHhMkYNB8uRMk9dqBoAzCEyHxCWem22Vca1sQMkSSvUXfx16ar9VPWDuFTu3zt4tNLlHVZVBOf8AHu73WIOH2MH65fj/sjfqj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Moving a part of a private hugetlb mapping with mremap() leaks the huge
page reservations of the parts that stay. They are not returned when the
mapping is unmapped, when the process exits or when the pool is resized.

fixup_hugetlb_reservations() takes the reservation map away from the old
VMA while that VMA still spans its whole range, because the moved part is
only split off by the unmap at the end of the move. hugetlb_vm_op_close()
then finds no map in the parts that remain and returns nothing for them:

    mmap() of 4 pages, MAP_PRIVATE | MAP_HUGETLB    HugePages_Rsvd: 4
    mremap() of the second page to a new address    HugePages_Rsvd: 4
    munmap() of all of it                           HugePages_Rsvd: 3

The source is unmapped in this case, so the number of VMAs ends up where it
did before and the check against sysctl_max_map_count stays as it is.

Fix by splitting a hugetlb VMA in prep_move_vma() before a part of it is
moved, as commit 597e4b9ab48a ("mm/mremap: fix locked_vm leak by splitting
VMA for MREMAP_DONTUNMAP") does for an mlock()'d VMA. A backport needs that
commit, which is tagged for stable itself.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: <stable@vger.kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 mm/mremap.c | 27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 0d06d7f37f19..5926ecdb31e9 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1038,7 +1038,7 @@ static void vrm_stat_account(struct vma_remap_struct *vrm,
 }
 
 static bool __check_map_count_against_split(struct mm_struct *mm,
-					    bool pre_split,
+					    bool source_stays,
 					    bool before_unmaps)
 {
 	const int sys_map_count = get_sysctl_max_map_count();
@@ -1092,14 +1092,14 @@ static bool __check_map_count_against_split(struct mm_struct *mm,
 	 */
 	map_count += 2;
 
-	/* If pre-split, the -1 observed above doesn't apply. */
-	if (pre_split)
+	/* If the split off source stays, the -1 observed above doesn't apply. */
+	if (source_stays)
 		map_count++;
 
 	return map_count <= sys_map_count;
 }
 
-static bool needs_pre_split(struct vma_remap_struct *vrm)
+static bool split_source_stays(struct vma_remap_struct *vrm)
 {
 	/*
 	 * An MREMAP_DONTUNMAP of a mlock()'d VMA needs to unlock the
@@ -1109,11 +1109,23 @@ static bool needs_pre_split(struct vma_remap_struct *vrm)
 		vma_test(vrm->vma, VMA_LOCKED_BIT);
 }
 
+static bool needs_pre_split(struct vma_remap_struct *vrm)
+{
+	/*
+	 * fixup_hugetlb_reservations() takes the reservations away from the
+	 * source VMA.  The parts of it that do not move have to keep theirs.
+	 */
+	if (vma_is_hugetlb(vrm->vma))
+		return true;
+
+	return split_source_stays(vrm);
+}
+
 /* Do we violate the map count limit if we split VMAs when moving the VMA? */
 static bool check_map_count_against_split(struct vma_remap_struct *vrm)
 {
 	return __check_map_count_against_split(current->mm,
-		needs_pre_split(vrm), /*before_unmaps=*/false);
+		split_source_stays(vrm), /*before_unmaps=*/false);
 }
 
 /* Do we violate the map count limit if we split VMAs prior to early unmaps? */
@@ -1162,10 +1174,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	if (err)
 		return err;
 
-	/*
-	 * To account mlock()'d pages correctly in the MREMAP_DONTUNMAP
-	 * case perform any split ahead of time for an mlock()'d VMA.
-	 */
+	/* Perform any split ahead of time if the source VMA has to be distinct. */
 	if (needs_pre_split(vrm)) {
 		VMA_ITERATOR(vmi, vma->vm_mm, old_addr);
 

-- 
2.55.0


