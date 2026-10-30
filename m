Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF3B5606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 17:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=broadcom.com header.i=@broadcom.com header.a=rsa-sha256 header.s=google header.b=QbxonJYK
Received: by kanga.kvack.org (Postfix)
	id 042AF6B05B6; Fri, 30 Oct 2026 13:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0DED6B05B7; Fri, 30 Oct 2026 13:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAE3E6B05B8; Fri, 30 Oct 2026 13:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B1D0C6B05B6
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 13:23:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3D9E1A05F3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:37 +0000 (UTC)
X-FDA: 85379964474.08.3AE54C4
Received: from mail-pg1-f225.google.com (mail-pg1-f225.google.com [209.85.215.225])
	by imf28.hostedemail.com (Postfix) with ESMTP id F38DDC0004
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 17:23:34 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=QbxonJYK;
	spf=pass (imf28.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.215.225 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793381015;
	b=KWfRfH21UeP8uUr41lx5J9n+Xak1vkZsteUveTXU0VsqkWGWg6/ww3+m0BrPoTZjR9kJIh
	NL9CLXMXZeOSwY0i639yJE8zIIHbXPzRbWyDEgC62E1qPMLbFHqaJdFNuTQmAW/vYFssIt
	avg8H5AUyC5G7Q1NJ6uQCO3JYh578Q8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=broadcom.com header.s=google header.b=QbxonJYK;
	spf=pass (imf28.hostedemail.com: domain of florian.fainelli@broadcom.com designates 209.85.215.225 as permitted sender) smtp.mailfrom=florian.fainelli@broadcom.com;
	dmarc=pass (policy=reject) header.from=broadcom.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793381015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q/Q9JkBadsgG41NDSYMszyxdI8yHLcwep1flIBRRZUQ=;
	b=yw06+02cPaSEES/ZtCod7clRT8rLeSeAnJXn3ZFsQNzVgy1Smemcwv8PmSKRNliwG9VkQj
	HZc7VPekXOKhfJPIF4XlacSOLl3HoZf74XGOuGrW8R0FY4fUi4eFr9VVzzwNGsxDpBByk5
	34TpLFTjWcjAoylYWz50481a17njUpg=
Received: by mail-pg1-f225.google.com with SMTP id 41be03b00d2f7-cc4aa0246b7so531329a12.3
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381014; x=1793985814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=q/Q9JkBadsgG41NDSYMszyxdI8yHLcwep1flIBRRZUQ=;
        b=ZsnW9Tn9v6SjN0KgUxgY8IZ34GotLr7nhyAllOcyKT1AdTTokT1I4CYXO3p/b0UyJJ
         RHCmfzMLdnh4Ask9WahcZcHUuJd4fl8SZOq4Qk5lWDv+6u515wkXv3bbTq87N0RXe+3I
         s6XBhbeltIe+Q6GEp3SZMJmhefuVwRrm5qYoOZkxhNPBNPSPxW3Bgj22Y5KQ3PhQGAvq
         ijPHlUPP+UVXwbOa47WY9Wjej/l5sUMMV9UbiF1B3nZhFvVCMZYMGg8cW3KwjvUzAZJN
         QTVO1GTCWEtFX2/TuVy3v8DXMLW0lrz6jOysQ58oQhpAtmvRGk/xaq48OvXjmgzqqLOE
         Llmw==
X-Forwarded-Encrypted: i=1; AKwUvBzqTuhwOhRiDKuux2nHU4P5XbR0HVIB9G5QFnK0Gr0be9GJbLTDIqGdfG1WKrz7se9I2M5Q8nt5vA==@kvack.org
X-Gm-Message-State: AFq9FYL1FsYvq1f/FchV1ydWJyiMgjEzl9GjI9/ATJ9XLhHSeOlhAH+1
	X2x3615KOgPr0dXUxFU8ivbiGSMffagS0aAvOHzNulq9zwu1vh8HaSYvsw/WKf6B7aVmdrYNnrZ
	+qLcDRMc0K+7gVEEvZJHBqo/8uTZAHyxvT96kkQGvw5SxItc5QugF9vJ23DKjAF9hieRWWmrrUq
	gPXLcHSvAG2ohslrwNWbwLCr0uQsvGOxSVOeva/3aQKnJlWhfkdEN7cEN9VWcyjkNBMyJUAcKp/
	x6Qh6nOSux2QA==
X-Gm-Gg: AYBFou0gzFQiu/rV9e1FxNyRXSTalJbyQfimHnB0dW8oO8MgEtDK8bujPHNSQounDd9
	vxC4Fwb+Ng7ohAG7mWld/GBata8Ml65FgGRiMyaD49cTzEcMkl8BE+lFbRGhALBJsTUiB5K8Uke
	26KiGikQrJEekvFJJa1G4/FWZAaaplc/l+G2Nt2NsEctEaakKwiYQmFnLrp5hRKapzh2/OJbQyP
	tR4CXHKtARZCgpaIzdNj4C95nh+ncxSbS2YXGBH+zFwCl/lOZr+NwaX5/t+ZtpkeOE921v195Wd
	4BvIGg2sMz9NLlrJogPIbiLtG8uO6u5ZXuX6iHSDwvm5XXsHUq0umG8BaR4Ml8fF7siwUGQyXQH
	l/vPh0RSqN5kyYJcFP27sdu7EL/ILR5e/GSjTCrj/XNLJWoOOw3JGUHuO7jzEXyFea1NuSCtddE
	TfZS1KDXv3rgKTFo/x3+04HvKffJOcfyS/TA3Bn0iP
X-Received: by 2002:a17:90a:fc4b:b0:3ab:b64:5893 with SMTP id 98e67ed59e1d1-3ae8981bf35mr2279788a91.53.1793381013717;
        Fri, 30 Oct 2026 10:23:33 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-13.dlp.protect.broadcom.com. [144.49.247.13])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3ae6e80415bsm4408054a91.3.2026.10.30.10.23.33
        for <linux-mm@kvack.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 30 Oct 2026 10:23:33 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-30c0d568830so1792138eec.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1793381012; x=1793985812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=q/Q9JkBadsgG41NDSYMszyxdI8yHLcwep1flIBRRZUQ=;
        b=QbxonJYKTKdZzMrwWymj/ozxLkfcaBm6i/nvElAJRDCwudI4TLhpe9IYMj+kJq4Da6
         ufuWaekh6YLxmNK7IftLr51Wy3QtkOt85/uXN3zEtO+dLCWm/l+/6sitjUhSgxnUU+Xr
         qpD9fSH9ifvDAiqa2jCI8gR2afh2K8Xcorfxk=
X-Forwarded-Encrypted: i=1; AKwUvBwUV2vmhHfyflGtLlLWHSMZqeC2TOstr6CDS+7OBxWok8lGXmMTmbuDoSupc8ldqO6ox9rdOUSDxA==@kvack.org
X-Received: by 2002:a05:701b:230e:b0:151:2e62:fe4b with SMTP id a92af1059eb24-1ac5bda8579mr3875015c88.23.1793381010375;
        Fri, 30 Oct 2026 10:23:30 -0700 (PDT)
X-Received: by 2002:a05:701b:230e:b0:151:2e62:fe4b with SMTP id a92af1059eb24-1ac5bda8579mr3874956c88.23.1793381009347;
        Fri, 30 Oct 2026 10:23:29 -0700 (PDT)
Received: from stbirv-lnx-1.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1abcf67csm8463406c88.21.2026.10.30.10.23.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 10:23:28 -0700 (PDT)
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
Subject: [PATCH stable 5.15] mm: move 'mmap_min_addr' logic from callers into vm_unmapped_area()
Date: Fri, 30 Oct 2026 10:22:15 -0700
Message-Id: <20261030172216.368052-3-florian.fainelli@broadcom.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261030172216.368052-1-florian.fainelli@broadcom.com>
References: <20261030172216.368052-1-florian.fainelli@broadcom.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e
X-Stat-Signature: 1c6e96rwp1geqawxzmjbrgoi5gt6zxj6
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F38DDC0004
X-Rspam-User: 
X-HE-Tag: 1793381014-30184
X-HE-Meta: U2FsdGVkX19+BWm8MuNT9ezQNMlmr0rwBpYugGkiJchHMvn8avhABpKmJ+zD7NfFOdeqHStg4Ui1weG2+8tqcGht7AESXoIFzCgTCLQPIyTXXDLC08WzEnIG8vkQyUjW0O2rlyFieldWx2O3/NyCIip6uGeCuK/6CImCC8iAojqoZdalvG9RUChMDEQp/KSdZzsHdeFIPAfAtn+OVUAZli5ahfLizPwbteuWFoUUPhgchulqdOSHo2cWGJWHFoaiMJiGPkOrsusXaGHAYyvm5TiQmyhODolh5FsKnsPa1pE29JTd110tj4RTmuI5aTQokmqEMIpNcSnM6KmnXMpy2i2OkWiOo3SIgMEVemS+uOC3W+s01dE3RJXKoaR9Ockr+cE2o5wCIuUSx+ARIOU9/AMJSWVFWrCxHYkQqb29maihXwhbFZAtqYn+cvYcZHhptxpNf81o3RL+eZHfhfh3BAiUDGMiNCL2ih8QNIYw3R1LcuceQkXusjOMwExYTWfseu5ZbPTESfQLx7XHT29e/hpDzmJKa6/17ksRHHibvCVsfuSoW0fQnW8LC0KAvkiuEInXdGmG8eHv0aM/UfSBt6New3J7QfXB31tR2e4bDAsiG7BZi6wXW+BXtOus20ADzAaQDEI+PCAyzAXSuF6PK7WjTdBLaL5XI8RFdlcVnAXfDauT7vIlddQ/PYUNrX48rwZzZhhHX3s5lMWJsohgR9qeD/zZYiTRG9iltNTY/lmToDbTE4VlqnY7mTpBm9wTjwDLPfTDgf99KWuSLHw0o9KY1TzTTqW8bEmDFscePREY8/yakbxi6dSD8514bMS1o38pU8ZA980ZjtVYrAejcuFh6LvP78UC3LpYVxyuKPaCizjsZRpLy41i5LuKR0c5Lt//gkwKQQ3btUK/NAeFtVswlP5B0MVhIXV+dGhHuc0kTJjD26bGv4NULPWthoAq8qnNvFOBoktA+4GHOUY
 xTnIfy0D
 IE2m7Ib3W2CEEWu9n/Wg3lCyyNRn4kDrXb12thTTo5NFnTpiXka0jmpQfJS5cgv6RLA+fEUeCQNGlkY59zPUPcDbHYvFvP85V0Ps/LSK8QBFBD96J+gmfXUciji0mlQb/jw4MSmf/mFadqNM0B29OKkOIAk2Z+NuOFZAAq3ENe2T0wbOvDgnG9m3v312uGr4DZhjt0JmYrbS7v3HAqvQasf1ctTwUc2CmXkPMqqeKSGLD/zDyN1aWCYEa/2o9b3sQRdUEAzonny8GaXg0o7HXkfQPxh511gJfQlrmXbZDPmabG+uRZY8DEHDercKdAldHUknXv3tyzz6b90nSH86cb/fOOUdmVeFq0b6aGtjoLLrRmJIIsOUdrpv+PbObFCzeAzju/dZ2dEJyexmiRgTCe+5j6ASEnlLIjA4zlQoo508G8YCHzHqST8rk0xwA2ucGbZsHUvAFzN2NblOa1231DhNYwdeM07nfg/2i+Ay7C0uzF9XcovuF7w9gGscyzY2/ct0VTUb5eyCIWxJBOMU+5VNH/lJp5wDEDQOTc69seWUFhCJpBxPkI8HIdiBZvoXhDpUw68g87qdwqYaZnBeJ7lu/y/7Emh/p+YCI4834UES9U2WWg7Wr3V8w2q385TfQ8WT0SR2ImZXqQB6sYbl4Ps7TWg==
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
[ Adapted to the rbtree based unmapped_area() and unmapped_area_topdown()
  used before the maple tree conversion: clamp the lower search bound to
  mmap_min_addr there instead of in the maple tree search. ]
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
---
 arch/s390/mm/hugetlbpage.c |  2 +-
 arch/s390/mm/mmap.c        |  2 +-
 fs/hugetlbfs/inode.c       |  2 +-
 mm/mmap.c                  | 18 ++++++++++--------
 4 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/s390/mm/hugetlbpage.c b/arch/s390/mm/hugetlbpage.c
index 8631307d3def..01aaf530ee7a 100644
--- a/arch/s390/mm/hugetlbpage.c
+++ b/arch/s390/mm/hugetlbpage.c
@@ -290,7 +290,7 @@ static unsigned long hugetlb_get_unmapped_area_topdown(struct file *file,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = current->mm->mmap_base;
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index e54f928503c5..1cb7ec9f9e6f 100644
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
index f663657c237f..b41e79f964d2 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -232,7 +232,7 @@ hugetlb_get_unmapped_area_topdown(struct file *file, unsigned long addr,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, current->mm->mmap_base);
 	info.align_mask = PAGE_MASK & ~huge_page_mask(h);
 	info.align_offset = 0;
diff --git a/mm/mmap.c b/mm/mmap.c
index 53fa4f5167dd..2c22f4bee04e 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1917,6 +1917,7 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -1928,9 +1929,9 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 		return -ENOMEM;
 	high_limit = info->high_limit - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check if rbtree root looks promising */
 	if (RB_EMPTY_ROOT(&mm->mm_rb))
@@ -1996,8 +1997,8 @@ static unsigned long unmapped_area(struct vm_unmapped_area_info *info)
 
 found:
 	/* We found a suitable gap. Clip it with the original low_limit. */
-	if (gap_start < info->low_limit)
-		gap_start = info->low_limit;
+	if (gap_start < min_addr)
+		gap_start = min_addr;
 
 	/* Adjust gap address to the desired alignment */
 	gap_start += (info->align_offset - gap_start) & info->align_mask;
@@ -2012,6 +2013,7 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma;
 	unsigned long length, low_limit, high_limit, gap_start, gap_end;
+	unsigned long min_addr = max(info->low_limit, mmap_min_addr);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask;
@@ -2027,9 +2029,9 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 		return -ENOMEM;
 	high_limit = gap_end - length;
 
-	if (info->low_limit > high_limit)
+	if (min_addr > high_limit)
 		return -ENOMEM;
-	low_limit = info->low_limit + length;
+	low_limit = min_addr + length;
 
 	/* Check highest gap, which does not precede any rbtree node */
 	gap_start = mm->highest_vm_end;
@@ -2101,7 +2103,7 @@ static unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	gap_end -= info->length;
 	gap_end -= (gap_end - info->align_offset) & info->align_mask;
 
-	VM_BUG_ON(gap_end < info->low_limit);
+	VM_BUG_ON(gap_end < min_addr);
 	VM_BUG_ON(gap_end < gap_start);
 	return gap_end;
 }
@@ -2208,7 +2210,7 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr,
 
 	info.flags = VM_UNMAPPED_AREA_TOPDOWN;
 	info.length = len;
-	info.low_limit = max(PAGE_SIZE, mmap_min_addr);
+	info.low_limit = PAGE_SIZE;
 	info.high_limit = arch_get_mmap_base(addr, mm->mmap_base);
 	info.align_mask = 0;
 	info.align_offset = 0;

