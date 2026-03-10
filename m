Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 793C3FCC9A5
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 01:40:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D776D6B0005; Mon,  9 Mar 2026 21:40:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25556B0088; Mon,  9 Mar 2026 21:40:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFD156B0089; Mon,  9 Mar 2026 21:40:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B08D96B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 21:40:37 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5CFC01B7EB2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:40:37 +0000 (UTC)
X-FDA: 84528448914.19.54F96D9
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7D7CC80004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 01:40:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=LXEH18Kd;
	spf=pass (imf30.hostedemail.com: domain of r@hev.cc designates 209.85.214.177 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773106835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=a7694XZeCof+FdxT7qTthMncnpG5NN0vfJefAJSmmkg=;
	b=tTxpOz9XQq19b86J9FvVE5ODG4JE/HdxUZTMd3HkItPoJUaAxZW6x+rhWHbXQr4lPDQc6a
	cYY2S0kbWUoUhMjjHzHhTg+9CPnS5p5dxud2VuXuqECxnRRg/wnOnkj9Q68rondwoyWLRm
	2Jt85Eq3NGdX1NpZpQgrpKaIoPAr43Q=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=LXEH18Kd;
	spf=pass (imf30.hostedemail.com: domain of r@hev.cc designates 209.85.214.177 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773106835; a=rsa-sha256;
	cv=none;
	b=SHj9Mgh8akG2CpSwNZQNy7koOme/RKi4kseE9Df8+E687T3+m91QayeFPWQPr6HAoSOXL6
	bXhPgz3gM7Z6angLc0FRq1qR9oZ0jvtnNlNNnt+x68achULBmUQtt16h8tm0a9vTJ3rBDY
	oxizNH6Y/6wiBGpXSG1X5bp9wQhED1g=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2ae5636ab04so89627095ad.3
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 18:40:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773106834; x=1773711634; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a7694XZeCof+FdxT7qTthMncnpG5NN0vfJefAJSmmkg=;
        b=LXEH18KdKY1ubYMkrPK26yxd29J315q3it3021rDVE3tn2/xVY30a3pFZmO/ZNRQZq
         KH1I7LmH1hKDEJb1fzSyYoYTCzp8Gc3B/C04OXYEHIdbsyk8oVWmMYO1EsVlnaw0sUn8
         Lay0bA0k3CA/tqBvmVZDP6cWtjoPm8DruEbNXyr5pbLC40MzHuPSKhBxOhEC9VFRZs6G
         +Zc9THtht+GTm9zXizL3cE5+PM2nefwS/w73GC19LGbplC4enTvBp5jXlQ7OJIhQejxH
         uSl250IsTY+LyzX3TbUuN+sxAMP5oBNOwd4zXRoCuiWVKgED73y6u3BwVZ2//MCXi49T
         Z48Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773106834; x=1773711634;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a7694XZeCof+FdxT7qTthMncnpG5NN0vfJefAJSmmkg=;
        b=D5bePuZ7vZdHnNIgCQLzBZE5teMKdZkXJ93tHjQqCjceJredZLkRbFG/kytePc5Ddl
         xdkw7xdqZaX2BDjoX38SuFCq5tOI+Kr07VqI9wkd6JR57wzNGHmX9IINdw2JprQ8Acyn
         1Oq8O19avSWY1m+ITcDNdqQ97LczlFfBMsTaj5OCxiMmtMYg2B7jISfn6dCqzrD99Vij
         3WEfot8i9evE+zlmoPviUJLJGxl8kEV4GHV+RgMx+88CB+huXrAxudqXGwlu/IxvG2HX
         /F172F41g01pmHUDI2TY8RkpU4HYYJU4Ide3DQey8gQJH1lkBsGwCfc0GyL9u3GNs5yh
         cnTA==
X-Forwarded-Encrypted: i=1; AJvYcCVpaFGBZkG2/hXaE1nf5OgwK5/6n2sRsOfSZhGI1n/t49ctjDYMOQhwgpFxVZZYOgsfEGj+JXMJcw==@kvack.org
X-Gm-Message-State: AOJu0Yw0Yt1iSyLTPeUu7FnXbyMUbwNf59pURiwzwFiD3wB0KKST8DMC
	cHd3vc1TQVc2RodrzwYMPWr2Ie/wYwR4yx4iIcL/YFZjAQzEKdwW8xEZOYekwIv8UIA=
X-Gm-Gg: ATEYQzw9K9HzXsf2NXYylf5Nlmx1Paj0QDn7cR/Iu0q0rwbz5+IUg7ljVEJU6LWOMt3
	V5bEAWSLWy0GEOASpSO/iec+DEXaJIS6r/Ipj/ZBZvBr1v4tFiNANwbkXc1XxC4lxmx/pHK50Yy
	+gJqsinEAzKNINHf+l1n7RgMnxSO6n1kKLpZHwOkfipRw0qf+RLL+o8fYnU8k46UVPyVqxll7Cq
	5NerjH3LhT9mX9mQA4mxaKL80aWfIS9qQPasyV5hGMjiCYxoOocLVX/bsHWI59VyBJRtBKCiEBF
	IyoapRS8nD/YpVvGxCYAXUNLNIWKyXYzWoX7o3De+NKRB0FRm+RrBomibknYUblE9hgMvy1z3bl
	FsIZJMtywHbPk2chizgTDgI1Jj/pqz8kWt928Zrs+WXo0qh878ZK9grfx3DJAEB6+gAN28c9Ulj
	0xi7j36Xfz
X-Received: by 2002:a17:903:1968:b0:2ae:8062:8362 with SMTP id d9443c01a7336-2ae82266d9fmr126325985ad.0.1773106834233;
        Mon, 09 Mar 2026 18:40:34 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aea3d26565sm6966515ad.2.2026.03.09.18.40.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 18:40:33 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v3] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Tue, 10 Mar 2026 09:39:58 +0800
Message-ID: <20260310013958.103636-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7D7CC80004
X-Stat-Signature: pj3hyecam1qxjf1hsotzjro8gnfd4eiw
X-Rspam-User: 
X-HE-Tag: 1773106835-535790
X-HE-Meta: U2FsdGVkX18BjMxjNrRvBpiGrxs7BZwnBl6CbHdUEWLnnpuvABSbT12TghB/2c1ri4beMIpVYB4XPsi12ncmZ7NCL9ycEL1c2U3ZaQtvdcz8qdhE2L4RW8agNMgwrZAaRTbAqg7shbsMn9X9rNDCPZDeODgPduAoBktKjXtxnBcKLJWs8q7oc0gLIEl/ns2MgpedChQwcvJyaUeW9KLeXtC8LCfpu9eIrbJaptTjQMdWDkiR3qNYciSx15hOBZLZZZenjFTNuDIMjXfkLsEllYBR2OqZ0KeU73wgJOuatTLAaSBHZh5A4tUtNez3upxf6HdClfIk4/BbYlGi/avY2vhoUnwDf8NZrugInzHsDrULGeZ0rwBxpIaMXID7S0g0VgAU0RIOb0vTOhqafRvhF5SK08x2wFGyzRLjZYNsUmUzVcNOaK6EM9f2enkrSElmXrY3jW5GKe0LryEqJpcPrRy9evc6z901PqqlDSXtil6ksEWkTBL/RspdG9uFFUOlTdvRUU+C6zXjD4mZ9vIueyFRxPGIXQmfFPOasOtpLA4k54GgNyNDtwDxlZvFW8V1ig4uOhg/811Ibc+cwLVjuLWLSIpojIXy9Vv61eyhZZ/1oDFCY7FzhGcYdJzN0xgLtseIl1/gpqKxACzqGSN/gjQOKYtd6WNBLK8wNkmTHsRMERusIsGt3DJ83SQIbcCjAOR4M2V/0GDRCqRCjL1jz7efliuP26454onEDSz8ZchUURQtTpQR2HHUHSbWhtxOWwNQtKkdo6MTkdnJ95Wx4KvLvZ1Tii6veQg5T3tcrRBfRVsskVjGl09h9r4MTBmgUcscBgwiKPLn+J4YBjH2ecjxj7RpRR3xwnK3F8g0/NwvxD/RJk8e/gpLOuECzzizJUG/w32U0l/TbscR+y+PzOoiY0tLQvtSYKNvsO59OPi5JEU9RnMfnioH7vVjDm6+3niF8DRwukNIrixyRff
 /zTbxp6R
 x7DMtcnCav+8gdJycrhotyneE6kF3gO3crik9Ixcm8cDEywtXzqlUyZMrviDwc2TCmeu+geBBlDwcsg9JZu6f3N89FtDLexK4G7NGZj70FuKt2DMfGCylnF/GcjCSms1YE3La0V/+w3ZdnIv3pmnmOb/vQZUWnuVtoDHvtDB8M91dRrIyZjIMXJBl/fD11tzyjnSL/aj/MfqzadqEpBGd/RjBUO8gnxpNIMmHbZPnexOfBXOrzkDLnAa5borJX4Tv8qHmhJVYsaKxFuRGhyzYNyXiVe6AEV6iFXM/EPeA+ADWCZE5mZnFQAHPs4sNPdl0FLosk5hDcuyvc9xqNx9CTD/24dMqxpLzpixFu37IBztSzV2ybcPKP4eNtWDQGvCzfjApOfMhAJCiDoFbdu+6xCqSBsUrU0EGm0U4BNHj2fU31TDGHLS10z3lL2MgzGOSDzad2EcUUVCe70bHXWXjzEcgtWGs43NFkq/XPTtgLFoDnyAHhKHLUfM2Ofl+Hdb88jHF+nfi6X9/Uzj9ziK1O6JgII4tcCRrbcJGHCmfutm+WQdfjG/u4/0r571LTxl4SsHhpQtZTfyH+d5jydoBXIKDyJ18ZjLRyHg5wIiuCIFa4JydytsDP/OKknopjpbQs7k2WBPfwyke7fU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When Transparent Huge Pages (THP) are enabled in "always" mode,
file-backed read-only mappings can be backed by PMD-sized huge pages
if they meet the alignment and size requirements.

For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
segments are normally aligned according to p_align, which is often
only page-sized. As a result, large read-only segments that are
otherwise eligible may fail to be mapped using PMD-sized THP.

A segment is considered eligible if:

* THP is in "always" mode,
* it is not writable,
* both p_vaddr and p_offset are PMD-aligned,
* its file size is at least PMD_SIZE, and
* its existing p_align is smaller than PMD_SIZE.

To avoid excessive address space padding on systems with very large
PMD_SIZE values, this optimization is applied only when PMD_SIZE <= 32MB,
since requiring larger alignments would be unreasonable, especially on
32-bit systems with a much more limited virtual address space.

This increases the likelihood that large text segments of ELF
executables are backed by PMD-sized THP, reducing TLB pressure and
improving performance for large binaries.

This only affects ELF executables loaded directly by the kernel
binary loader. Shared libraries loaded by user space (e.g. via the
dynamic linker) are not affected.

Benchmark

Machine: AMD Ryzen 9 7950X (x86_64)
Binutils: 2.46
GCC: 15.2.1 (built with -z,noseparate-code + --enable-host-pie)

Workload: building Linux v7.0-rc1 vmlinux with x86_64_defconfig.

                Without patch        With patch
instructions    8,246,133,611,932    8,246,025,137,750
cpu-cycles      8,001,028,142,928    7,565,925,107,502
itlb-misses     3,672,158,331        26,821,242
time elapsed    64.66 s              61.97 s

Instructions are basically unchanged. iTLB misses drop from ~3.67B to
~26M (~99.27% reduction), which results in about a ~5.44% reduction in
cycles and ~4.18% shorter wall time for this workload.

Signed-off-by: WANG Rui <r@hev.cc>
---
Changes since [v2]:
* Renamed align_to_pmd() to should_align_to_pmd().
* Added benchmark results to the commit message.

Changes since [v1]:
* Dropped the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
* Moved the alignment logic into a helper align_to_pmd() for clarity.
* Improved the comment explaining why we skip the optimization
  when PMD_SIZE > 32MB.

[v2]: https://lore.kernel.org/linux-fsdevel/20260304114727.384416-1-r@hev.cc
[v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
---
 fs/binfmt_elf.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fb857faaf0d6..a0d679c31ede 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -28,6 +28,7 @@
 #include <linux/highuid.h>
 #include <linux/compiler.h>
 #include <linux/highmem.h>
+#include <linux/huge_mm.h>
 #include <linux/hugetlb.h>
 #include <linux/pagemap.h>
 #include <linux/vmalloc.h>
@@ -489,6 +490,30 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
 	return 0;
 }
 
+static inline bool should_align_to_pmd(const struct elf_phdr *cmd)
+{
+	/*
+	 * Avoid excessive virtual address space padding when PMD_SIZE is very
+	 * large (e.g. some 64K base-page configurations).
+	 */
+	if (PMD_SIZE > SZ_32M)
+		return false;
+
+	if (!hugepage_global_always())
+		return false;
+
+	if (!IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, PMD_SIZE))
+		return false;
+
+	if (cmd->p_filesz < PMD_SIZE)
+		return false;
+
+	if (cmd->p_flags & PF_W)
+		return false;
+
+	return true;
+}
+
 static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
 {
 	unsigned long alignment = 0;
@@ -501,6 +526,10 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
 			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;
+
+			if (should_align_to_pmd(&cmds[i]) && p_align < PMD_SIZE)
+				p_align = PMD_SIZE;
+
 			alignment = max(alignment, p_align);
 		}
 	}
-- 
2.53.0


