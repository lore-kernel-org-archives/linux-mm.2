Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60EE9606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=ZZzaeK98
Received: by kanga.kvack.org (Postfix)
	id 4391A6B05B7; Fri, 30 Oct 2026 13:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E9F16B05B8; Fri, 30 Oct 2026 13:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FFAD6B05B9; Fri, 30 Oct 2026 13:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3C406B05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:23:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D2751A0824
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:37 +0000 (UTC)
X-FDA: 85379964474.15.03AD505
Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	by imf02.hostedemail.com (Postfix) with ESMTP id 653D280005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=ZZzaeK98;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf02.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.215.227 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793381015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmpmCNUnxZltA0RrJz+fEFjfdRhaWWv/gMnrq/ZBymM=;
	b=EbclPHBOZahBQFEhsIx/2kDkjKBoJ8IJWdqkAEbLbHxqsc3k546h1LW1lW8nfi5RHclRNK
	M/TPlsukTwWKgofl3YGfbt7Nb/bLYizVKoHzjKH7omFkaNSpfAhmDFbuD9+b1mK0YlzATV
	4X6i/TxFxAZ0Xrswv/5vc5Xt1IlVwD0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=ZZzaeK98;
	dmarc=pass (policy=reject) header.from=broadcom.com;
	spf=pass (imf02.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.215.227 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793381015;
	b=vOf7igm+off6m0n1uD+ZGI5N8KdXdjQ+SQWBMNYP14+4SqZlL3J0w3nyTfNGui8KXnM1+a
	5ClYy+fbM0glh9Qer5OdXe33OxlTDo8r2415s4ue4LYeoaRORC9Q+laymBlilf4MB4kN3A
	h+XR/z9MGyQKHuh5S66FU3dwAVOfj7U=
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cd5d2dafeccso584193a12.2
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381014; x=1793985814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zmpmCNUnxZltA0RrJz+fEFjfdRhaWWv/gMnrq/ZBymM=;
        b=IqYnCpr6YGK1Pwkro/04TgjAgD3ZGvATZXXZfhZxlhQqXG95AAiRtm5Hd9g+pwVjFd
         0kHgfqirYxKPM65XDqwQ/Q7yp0B9qpciVIqKVweNBdy5hPw4noEwJRIqo7NJBS6/Hwcf
         6QLtmQakrbfojm00bw8GoE88vUSNrybUejDSvMf+R8AnCTyKPxfActsSfAODFQk8MIV/
         BL0KbrOd4iLt9PlW4DrbnbJ5+uBway1/bfyAi9pxgl3HEd1IzISfrcQB9VbT+QAuJKMj
         pAbuGfftzjtAg4ZB+F9AAsaAl7hsJF5dYTnZCK5frEfHEhajVB+QdGkJW8x+ih5niXhw
         lW3Q==
X-Forwarded-Encrypted: i=1; AKwUvBz8lLlTD19heo3qnsB8QcugqK7fnqz0G36+SoWsxGQt1XhjNl8lSlxuTomk1a4Fgr8uH1Di5cbZEA==@kvack.org
X-Gm-Message-State: AFq9FYLEbjOb6cJbIpdc0ibDv/toNQJkOQOvxjBcUMo6QT6tnej07u2c
	iecI1238J3iZS18iyDOJFDi91XZLCQd+S4YaGrw7QJMYM8I63Sz3KnHgqpYDghF/P0gPgmwiXVK
	f/abFX3mD7VMsboxDNxoL+0w8uiApIoqQkjHtDY+Vo2Es00PO7BUXPPx2LGVgciksQs1cPDlZQZ
	KAtajPqPSmR3NXpuGftRyzMWjDb9lhl26BD6Q+Uf/VkvwN1r+PHm0nXWEjHatlDxtbyZMQuJOYw
	2TfbZOjsHSbiA==
X-Gm-Gg: AYBFou0+4pJQu6/LqYnqnAhDQdjmltC2FazzgHOxDzflWfQx316rJuDkU8wqoDgERLF
	LhJBFg4s0vh3h//v6bwmo5xygjv1Xn+WsHgVpPJPc2i71xnL3IPr3N6eKa8rNl11P+GBR51Wy0p
	W0tUf9bydCxlTJjeO6x4FLbhg7Kz9R7SbRpxYc4n3Tg6QwkXxW8mG79zr3sr/M4pWwWOJWcJuWx
	8fcvLZxtKjJK2FXNT+aFsMii7u8jGFpv5if76ILO7NT0nZtg/RIHskRRQAu45iGM28Guc1KcmgC
	xSAHVpAN76ceVhSBnFiwzCVphmxNZycHJGwFoQN98TyPTAB63bm9R+K2Fb4DB0WSH4JlcnMPIiI
	SczLc13AdnkHNK7EBFmoG3WxPL6o8kIbKRKaJTEFh4wgqXE+GErFYdJTPVytAs1Wx4KNLwPoykC
	ZPchYby9rl5z7CDU6bo6FIhC9uKSzqyWkXR8OU/GTV
X-Received: by 2002:a17:90b:3f84:b0:3ab:b39f:41da with SMTP id 98e67ed59e1d1-3ae89776af6mr2340999a91.11.1793381014220;
        Fri, 30 Oct 2026 10:23:34 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae6e874b16sm4470231a91.6.2026.10.30.10.23.33
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2026 10:23:34 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dl1-f71.google.com with SMTP id a92af1059eb24-1aa0fb7f157so1473439c88.0
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793381012; x=1793985812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zmpmCNUnxZltA0RrJz+fEFjfdRhaWWv/gMnrq/ZBymM=;
        b=ZZzaeK98+I9HZ84WeWC1pZWtkHwNvD9kt0Z54B6LJ/J1BDTr8lLzWmbwqPg3tO28gz
         +TTgsgO3mwbuS9zDVnlOPy+OsKrMdcnZc7RuMmUmc4ZFiU2MzBEV88+gINPL8+FLqNUb
         aiaUhDIdjHFVMmrRIfQ/fDAO32oJbuAZ7IdBA=
X-Forwarded-Encrypted: i=1; AKwUvBy5pKwtHdULqUBnDWfRSNa4xuMWkZACm6eCsca/VeeMYOu9JmLCC7OefIkxENqU6gHmhznOwKnZpA==@kvack.org
X-Received: by 2002:a05:7022:ea46:20b0:144:c128:4c4d with SMTP id a92af1059eb24-1ac5da76f4cmr4112836c88.38.1793381011598;
        Fri, 30 Oct 2026 10:23:31 -0700 (PDT)
X-Received: by 2002:a05:7022:ea46:20b0:144:c128:4c4d with SMTP id a92af1059eb24-1ac5da76f4cmr4112794c88.38.1793381010859;
        Fri, 30 Oct 2026 10:23:30 -0700 (PDT)
Received: from stbirv-lnx-1.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm8463406c88.21.2026.10.30.10.23.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:23:30 -0700 (PDT)
From: Florian Fainelli <florian.fainelli@broadcom.com>
To: stable@vger.kernel.org
Cc: bcm-kernel-feedback-list@broadcom.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Russell King <linux@armlinux.org.uk>,
	Liam Howlett <liam.howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	linux-mm@kvack.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH stable 6.1] mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()
Date: Fri, 30 Oct 2026 10:22:16 -0700
Message-Id: <20261030172216.368052-4-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030172216.368052-1-florian.fainelli@broadcom.com>
References: <20261030172216.368052-1-florian.fainelli@broadcom.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 653D280005
X-Stat-Signature: neubjsbuh8yhms7or4kipqctrftxrknx
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793381015-867342
X-HE-Meta: U2FsdGVkX18RDjHT/yNS4g/MppP/nlnMCEOBx0+COiQ70/hfMtD4GQOKLuaubh98EjGl3uCRt4b+dO4iXBR/vpB0CqLFw5k40n8Y4HoW4xgvOgI1MESEmayQXXGwB8MULt9GjmeBBS779aelNed42Y2H4YBw8QkgSu/hqODWdcbe7MeqYg6OLnAame8Whysdc34xTybNAU4LrItqxa8VOlyS1rFaZnz2vATJAPZifC5VLj96jCSZXbmHAjHZ/Al0Rbs4GDjzDtiSIvxITprz/cZpv0phRw27mzxoqNx/auu6GGnS/+EUpxbxnXxm3ygg2ezeDQO5hYIZDidtVwwal3lIsVItG6T9rcwZTmaD5m+GXMsHM9+2gRPArnegPuu5h4o8wH6Zlw8dqr0YRQIlbXPA02gvsTyh1NvQMyZWOv/zTwoJv6CfEY+mjj+iat4LgIKq3YSZM1+RxFQXOA5qTO+BsNk1g6B6ULbGmQPRAMpV30h695OdVFJi3T3xoMpK6ZSErhyazF8bbH7QPycU5kysf/Oq4hUqiRq4ukQo/7wG257U8HPJORpTOdh0drf/rrlNB+yuDuW91dVEvEYiBv/RGHsEU2b/VRWkrQ7hrsfIxh/64BENDn/WjTLFoWSQLIBXn6Cs+Db6i/nspih7uxIrHcI5JqZyU4HoV6jVYgGJFzHAQgQE/ltMgwWyxQRQrHN966QxIYffqowx1PQ25prP7sUXdJSbxaxNqDUF2Xg++xtnOZlKo9MbTVdCMI4sjFw0reZO7zgzYYCvfpdpw5fNU2Zrc4lfOsNPQyfibVif+ttnAvWW3/VPOQVjSAk+RIt3pho7eJEtAYZMornimtY/ypzS0ZkEYfLqTUPasOIG4x0GCqpyksmivKvEX23/gtntJpbqaJk71dMwevv6yELAQDGpReLFN+JFGZyA/YzMVVe9pmK5AtWUD08XrjYeaR6Kr1h+m5FbinU8NcI
 BJ425YIp
 PnjnS3Ly3YfjCojZvVGjidygWUgNhWUPSIZWZILmXNHTzsUm3tkhsHtsxFYYo6JeSI4sv2mRJ7pyqjVox8aa9a3AGCKj3K73/hcuvJ8FbMTXUutYdFQiShfhem2g4knk4i67Kr8Wn6nfk4h3yHgGxV7ZBBeYBxosGC2/uX2ZjBl8kFbhV+fkEXcLJoECw77eaJ1nc+ApMgOaslEzWsaaeolhrjgeAcuu/yvUSfL7aMsuMaN7d7do6IeYZv6cgesXI0FKRD2wgpKfpQdxb/dMfSbTR2AV/qVIOpi709e7AizXBSqbzuiaj7/oaBV/zhpVOoff97Vsv5M+JNtGCDfUV5GecaFPRA04gOcMqkisfHWT19HAOn9mKxJJAYQIz8am2ZiANGKLO6rJuIeCDhom34/1SsMkHvN78/ti+aQWjO2qE6TkqnfT2opLePAMFNHnf5YakGzQZ7lROATrfZBxFliPWAulOQ/stXy1GY6CRnO5m9buWfZxsRFU+irNynRUnS0m5gyQSRI4dKavA4/E+fKeqvz5kXU4t0J+j3YdDD8gHD1F2rTlbRHl38tMPQ2FsABncEx2zK6HC2RPwy/Ll0siTqrBJUaMYd60LJUc90B/Z5ng+XkvtjZiEnZ/SwDIfiy+RfEyZPk7mJeAxZXcWyPr8kA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6b008640db7355d8de6ac18f74cedd7ccc92684f upstream.

Instead of having callers care about the mmap_min_addr logic for the
lowest valid mapping address (and some of them getting it wrong), just
move the logic into vm_unmapped_area() itself.  One less thing for various
architecture cases (and generic helpers) to worry about.

We should really try to make much more of this be common code, but baby
steps..

Without this, vm_unmapped_area() could return an address below
mmap_min_addr (because some caller forgot about that).  That then causes
the mmap machinery to think it has found a workable address, but then
later security_mmap_addr(addr) is unhappy about it and the mmap() returns
with a nonsensical error (EPERM).

The proper action is to either return ENOMEM (if the virtual address space
is exhausted), or try to find another address (ie do a bottom-up search
for free addresses after the top-down one failed).

See commit 2afc745f3e30 ("mm: ensure get_unmapped_area() returns higher
address than mmap_min_addr"), which fixed this for one call site (the
generic arch_get_unmapped_area_topdown() fallback) but left other cases
alone.

Link: https://lkml.kernel.org/r/20230418214009.1142926-1-Liam.Howlett@oracle.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 arch/s390/mm/hugetlbpage.c |  2 +-
 arch/s390/mm/mmap.c        |  2 +-
 fs/hugetlbfs/inode.c       |  2 +-
 mm/mmap.c                  | 19 +++++++++++++------
 4 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index 33ef6790114a..d646d81ead5b 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -273,7 +273,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = current->mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 3327c47bc181..fc9a7dc26c5e 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -136,7 +136,7 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	if (filp || (flags & MAP_SHARED))
 		info.align_mask = MMAP_ALIGN_MASK << PAGE_SHIFT;
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3faad73c74ab..a7b6a97543b7 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -219,7 +219,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
diff --git a/mm/mmap.c b/mm/mmap.c
index 1eb86aba7de5..17ec4d40edc1 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1598,7 +1598,8 @@ static inline int accountable_mapping(struct file *file, vm_flags_t vm_flags)
  */
 static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap, low_limit;
+	unsigned long length, gap;
+	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
@@ -1609,8 +1610,11 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 		return -ENOMEM;
 
 	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
+	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area(&mas, low_limit, info->high_limit - 1, length))
+	if (mas_empty_area(&mas, low_limit, high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.index;
@@ -1646,7 +1650,8 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
  */
 static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
-	unsigned long length, gap, high_limit, gap_end;
+	unsigned long length, gap, gap_end;
+	unsigned long low_limit, high_limit;
 	struct vm_area_struct *tmp;
 
 	MA_STATE(mas, &current->mm->mm_mt, 0, 0);
@@ -1655,10 +1660,12 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	if (length < info->length)
 		return -ENOMEM;
 
+	low_limit = info->low_limit;
+	if (low_limit < mmap_min_addr)
+		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
 retry:
-	if (mas_empty_area_rev(&mas, info->low_limit, high_limit - 1,
-				length))
+	if (mas_empty_area_rev(&mas, low_limit, high_limit - 1, length))
 		return -ENOMEM;
 
 	gap = mas.last + 1 - info->length;
@@ -1793,7 +1800,7 @@ generic_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;

