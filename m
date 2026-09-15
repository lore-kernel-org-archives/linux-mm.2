Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE624C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 07:13:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC2986B0088; Tue, 15 Sep 2026 03:13:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DB16B008C; Tue, 15 Sep 2026 03:13:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B13C76B0092; Tue, 15 Sep 2026 03:13:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1116B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 03:13:35 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1FEC5120357
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:13:35 +0000 (UTC)
X-FDA: 85215131190.18.ABE08AA
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6A634120004
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:13:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JH+F0eXx;
	spf=pass (imf29.hostedemail.com: domain of orgads@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=orgads@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789456413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3/q6Adnz7lpVRwZWpJQefNRmiB7gYNF+Y1dkZ8i2uhk=;
	b=KaWBVpm7AT2c7ZErx18KsrwDxxoOd6E/mjdAYwA68BEQMEUggw/oZSemX0lSevyJ6/vAVu
	nKnJMZvXzNJvqX4Q70kpP15jpNHKCGJZqkPlDcDEv5cW+WrCWlaKE1pKZOd0wauK2b2R+w
	Olc7hNppfxCZ+kR8ol7Rv4GO+wSzSn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789456413;
	b=PWzQdA14RAUVk/oNlc5bG5PR33dZeAaD12nM04mX0InJEqOwqTDvRljZdQXbxyaVkgajeL
	NJu6UviSR6MpfvN3y7HT85LeHathQUcIb5+BN10MZ+RgIrc8fp7MO6lPPTAcwCHsnCK0Ih
	XIVXpl9RvAdLPyW5d0FVgcyS70aHwkk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JH+F0eXx;
	spf=pass (imf29.hostedemail.com: domain of orgads@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=orgads@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-49e717c9841so16714125e9.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 00:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789456412; x=1790061212; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3/q6Adnz7lpVRwZWpJQefNRmiB7gYNF+Y1dkZ8i2uhk=;
        b=JH+F0eXx+ZKXvjICYKhz5Hj7FRdBf/ndQwjLOWeuY3MRXLIQb3BlC49oCV6E2Pr3fG
         02ggDB5nYX36YWRbuoe35jIV9rZ3p8XSaQoh6oERqdflLsH9doRIJULLcsGZOn4kvxY+
         KkRSjtz2AS6SJcVt2zMQf9oOvjkUMs41v0nv/R/Ejv1bEDNowU0Z2WYt8CQsRyKYlIf9
         SYP1KbVeeBErUiCflLu0hYkrPPtdsJ8uHdvhyuBzsNXopVSoUvOOSSTi22wuoDYetvBz
         zdbbHR8a7Zk44SpNMTSr3d/TNuj78gtFeq1Qe3saBxdEcUpiUVgDRyV11NjO9TWD2wVW
         fbZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789456412; x=1790061212;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3/q6Adnz7lpVRwZWpJQefNRmiB7gYNF+Y1dkZ8i2uhk=;
        b=EVW6vv63od5L1+KZnyEGMHw8BC2gqwo6mHcGOicZlNKr/g2WV1gC5piV6tjh/ypqzZ
         /7Ls1Es3sN1w+Xsv6doTl7Mx+/IWKxZSesADC4IjfVy3dlnVwByvkhhhVgBQfj6eNwIX
         LEiWuccl7/nZr4LKuhr3BfLXLQBegykIZ1m/8ag2YepaKtxcr0wknIShlrwmwr/YTNK6
         pYgdQt4JvPGPQBuJy10YEUfao5dnIH3sbn1PUCzQx5vcYxisNBBxvbtVleR4j5vq4TgG
         PHVU/DYmBADRDrOfPzYm52KAa0JlzK/g2/Oik5uCDAyrXPGGYmCEkGFr95pYfHO21VVN
         0gcw==
X-Forwarded-Encrypted: i=1; AKwUvByiqP0kdfvl3LHFNqRLWgw/cuz9/PBX+4JphIUFM9fVTYiZRnchflZ300drHg5OxgByrsg0u6Ehsw==@kvack.org
X-Gm-Message-State: AFuF++kr98VSCdQukaCtZxZ97OS/JLWYOr6e5aRiazChLOZufwqP9xjg
	T+mFKi8H4jAQKu6ztBgDTQSsYgSOyfIFMjuEWwTceN4S+Wl9OYpxvO2y
X-Gm-Gg: AYBFou1/pkpLnSIfYEhqNLK1vtnWhZzoS974xqIQiTWqQOLltyk8j1TpDZQIV3uB0vI
	a4HSDSUYxWgd+brQf38szK3SllguiLodFmCVlLyEuTlCqztJDSD6p/zLBv5cWIa42CU2QL+UkbK
	tgn8iv1Jv1AoUTxrRAEzwbsjf48sjDN95WzN4A+AivYlWvT7B36o/ziWt5gv/YQFwx9ln+q2f/P
	TYlqwmqBSkjdnziVFh6ENe0+itYr6ecbHI09mRCCHC5mwgMRBYkXzu97GQWJ4rXIPsKQLdtqt0o
	gAx9Gqy4SXDZ/B4vHMaRVJBtIUrmIzozIE5gb3TXHukEzP6jewCsuEwxksajG61D5mpA5y4x3XC
	SoBGpeOR/5AsejV6EM2KXjELRC/jBwAVdAfVDokljzJ1NVhKSuY080qnsj9rxVeRg87s1+IjDgG
	yWDB5AO9Qwnb7UTynguWXdtEXxmGJkImp47N+hOcq1vCOnrZxvlqZ9/J0e5F1sQl0btV81tpBFW
	LwnTpfjzjguppsFyqA3Hs8+yIwUC0tM6wPWA0ilTgZm0KIh1sd8Sbgvs42y7vbrfENH1mA0mVwB
	ymZc+cUYKLEAkwnMEg==
X-Received: by 2002:a05:600c:3586:b0:49e:747e:c00e with SMTP id 5b1f17b1804b1-49e7a64e729mr82091545e9.9.1789456411633;
        Tue, 15 Sep 2026 00:13:31 -0700 (PDT)
Received: from center.jhjvjihww5qejoy14qwv1cc4td.frax.internal.cloudapp.net ([131.189.143.225])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7ef735cesm42941345e9.6.2026.09.15.00.13.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 00:13:31 -0700 (PDT)
From: Orgad Shaneh <orgads@gmail.com>
To: tsbogend@alpha.franken.de
Cc: linux-mips@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	osalvador@suse.de,
	stable@vger.kernel.org
Subject: [PATCH 1/2] MIPS: mm: align hugetlb mappings in arch_get_unmapped_area()
Date: Tue, 15 Sep 2026 07:13:24 +0000
Message-ID: <20260915071329.15125-1-orgads@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 33h76wkwrn97oszkcy16yrbodxegsj3z
X-Rspamd-Queue-Id: 6A634120004
X-HE-Tag: 1789456413-565549
X-HE-Meta: U2FsdGVkX1+tL7WmvIN8x9xnjG6TEEGlbseVbqy7QQSYkUnRuMJ1xkt24IrbQZeODyyJZ0I70S7CJpYMv1RRQlPvQrced4K47a8hIiAKKPMAPaOosUtwmT3PHJCXRz+Ez+gMpRmmgUM+pjH9IQpmSTDQBDiBAT/dXZMtTEZEikyqAk7vvHGfbqTUxn8RZ8D2QPy81Qf+3xTqj2qpFJ3hFJZwDZYDd+MWrc6LlC22jLY2xL/QeNCzvibTszuEJOtgk4Yn306+eiNu1NPZcOmKSotJEADDCWdN/XxXHZiKIYNXroA5rnYt9GhTwaCwKdq3IaU3kkCf5+S+77DhVZ1+I32pwusz0+a1ph6x222t4enBOXMMcIE0ETpJFfx5PgJBJdwVYkx0lcmBTUyEbAc9meB+CukCDG1wiJkq0zWgIWGQsoBdqf7jKTZuCA0y6QZhRP3lnFmE0kZvg2vfI5RpZL0YlVWhrsTOqeLSEjCQ+jsigs1qYe8EA8WV2IVzo+j4f3jGywrn84RiJy5bNNC/Krf4FKap9REX+s/4/URkegTJpLIw0ZtM5H43mDGWjH3Jzi7QdW1b5r1Q6W/sAcvRJyyIHocWUV9hFeTkJB5zoaUONV9cQdNgh9PDJrv1AkcvD4Q7sciyRTkA/+saY3GxYZknKABdzmpcE3vyJ2vjqJgOAjMhoZ9PmYyeE1UbxGTS02KNQBfADbF1LCmEi8EqcwSUDzOCLA8KPJa8Q9sRzNicOt0A6shS6x0YWLER2wqp9/grs7zVXQ0TVkhKxFP7gB4nSE+mLItRQdJ1+yoZ4SXOuwPBLHkZSL0Br/2MgG2J7lsbvx0EOxAHkfEbsbmb2STDKG5WqIB2aNLIluWCRwU3BQzS+XbwoawlZmLVcJQIZaW/Wr9eTVWeHgrEKb5LK0OIVpykYY+8fcKgNGUum5C6Cha6gst+b7Q3NHLn0v39ZzSv56JnGgkP5PbkR9e
 f/vOTszT
 PdIEUxYW0ldNojZMO333qSX2QeJZV+lW+MaQlknPNL7CsDHNa832o2h5J8lAeOGy9ixR0iaVIl1AET5NBCpsIPXDUBBsAFIGKbnyvEvY+D3Gv/KioFTfs28Bc86Xv8XJ8/HwoMGfZPWkXSjfx8pBiVj+kAVNQmVMRxIVnE80cl3xAuk1B8MFYqegN+nv1eyhmqQS2HtxJpsm2RKiP4JvtcJOmRARCfH/ScHHS3O7VdGaxwYpnYX6CtwyLgWsqT9YU0JEYJP4Mu8JGvyYlpTkJ2kDAfJZuPKyuUXgqansyEIG3aEvo3mVEPwOcGJpl+ivfE3daAGJAyEK9AfmBMAo9/TBz/vBPtbV+F+TNs5t4NMcPLsdAkYmLOtqkZK4qCiQuhLpBlmVYFhS2+PoyGkQgnQQY8Mu7F3ItCD77Wa1kLNtqVnhth6eEp/f9MKSPVkGbz6Z4QALMudxdRorZfHQs6toRVHwRUXS9Troa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since hugetlb mappings were made to go through the architecture's
arch_get_unmapped_area{,_topdown}(), every architecture that implements
those has to align hugetlb files itself. The generic implementation and
loongarch do it with huge_page_mask_align(); MIPS was left out.

A non-MAP_FIXED mmap() of a hugetlbfs file therefore returns an address
that is only SHMLBA aligned, and the kernel then installs 2 MB PMDs for
a VMA that starts in the middle of a PMD. The consequences on an
Octeon (CN63XX) board running a process that links libhugetlbfs with
HUGETLB_ELFMAP=R and HUGETLB_MORECORE=yes, all within a minute of
start: the neighbouring 4 KB page table is clobbered, the TLB ends up
with overlapping entries ("Caught Machine Check exception - caused by
multiple matching entries in the TLB"), process exit trips
BUG_ON(start & ~huge_page_mask(h)) in __unmap_hugepage_range(), and
freed pages leak into unrelated kernel structures (oopses in the irq
maple tree, in pte_offset_map, ...).

Do what loongarch does in commit 3109d5ff484b ("LoongArch: Set hugetlb
mmap base address aligned with pmd size"): when the file is a hugetlb
file, use its page mask as the search alignment instead of the cache
colour mask.

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Cc: stable@vger.kernel.org # 6.13+
Assisted-by: Claude:claude-opus-5
Signed-off-by: Orgad Shaneh <orgads@gmail.com>
---
diff --git a/arch/mips/mm/mmap.c b/arch/mips/mm/mmap.c
--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -9,6 +9,7 @@
 #include <linux/compiler.h>
 #include <linux/elf-randomize.h>
 #include <linux/errno.h>
+#include <linux/hugetlb.h>
 #include <linux/mm.h>
 #include <linux/mman.h>
 #include <linux/export.h>
@@ -72,8 +73,11 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 	}
 
 	info.length = len;
-	info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_color_align ? (PAGE_MASK & shm_align_mask) : 0;
 
 	if (dir == DOWN) {
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-- 
2.47.0

