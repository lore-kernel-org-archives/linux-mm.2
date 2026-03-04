Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84C1EB7ED8
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 11:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271CE6B008A; Wed,  4 Mar 2026 06:47:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21FD46B008C; Wed,  4 Mar 2026 06:47:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BD56B0092; Wed,  4 Mar 2026 06:47:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02B716B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 06:47:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 93A4CB9B09
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:47:50 +0000 (UTC)
X-FDA: 84508206300.28.ACA9F41
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf22.hostedemail.com (Postfix) with ESMTP id C912EC000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:47:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=KGH3BDMS;
	spf=pass (imf22.hostedemail.com: domain of r@hev.cc designates 209.85.210.169 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772624868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=OSmAArgo0j03YT7FseLxFhyf5NHLf28jrPvMl7zXPPo=;
	b=Tv2SpOKGYoSDnMaiIsvteqYf8u/L20rsxulXbs73zy+6ySmO/eNiPuOz4m8me1kgTunTv2
	Y9j7o6+yDulGCuFdCP3zoG0KOMDry/IWkmOlmM2edEQw3/WjrVxDb7m15k5kAlR6A/XSiI
	nIsRiJQa0XA8avEdOrJDf2sowA9NkfA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772624868; a=rsa-sha256;
	cv=none;
	b=CnHs1iyDLALCzaUGQ0O7BkejE7XUmFMd3v9PUYFAvh0QL2kWIZgZUSVpkP1iWkVXKcAQnY
	U69cvTLbbyOMryiMaolvtGMpNQuwXAnAUsEx87o/EjnEXbkXMuzIiLseNUwBf2dLK2lB34
	nsp0Zkb1mLitqeLZQx3X3kNggMveybE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=KGH3BDMS;
	spf=pass (imf22.hostedemail.com: domain of r@hev.cc designates 209.85.210.169 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-8297310ce0aso277917b3a.2
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 03:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1772624867; x=1773229667; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=OSmAArgo0j03YT7FseLxFhyf5NHLf28jrPvMl7zXPPo=;
        b=KGH3BDMSRJKOVesXTVS9PcRzRudJqkpNgFVUaYmlEIFqOGWP5OApwPtITAxHUsJPKb
         FoUUO+5L5IolLhzR0XtjuL28KM2eCCVy2eJjwUgKtYf9/qyVeUNdyu/jzIIerSw/tAkl
         MmNXKY/mg0CT2K081bjcMbSlk9oIEJmkN1RjCH4Bu+B2bbSk+c0FmLeSFYo2OfiGgnZN
         CWL64tnFQhjIazHPF9YvG+CVvYvoJuTInLTd4xTcQd9/vLcMz6lFABV/5EZKuWC5BK5x
         HRLAjDSzbs6hFi/a7CCDiEp7ql/5Jzzo1xLAGc6EAXR2q6N3rwZys5GqbxKqEHEmk4vv
         a5Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772624867; x=1773229667;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OSmAArgo0j03YT7FseLxFhyf5NHLf28jrPvMl7zXPPo=;
        b=BZN8LB9LRB73Yg52u/D1TpVwpIrwihJW9nmfYQC+fw8YteAWTH8AARLSxaFxC0R67R
         TlNuqhtUg/9T6RvXuVVkroHJOfBOJQjbuRqfQMr+mdRsuaxEwkurlULYmega7B5kOrHj
         R4rk2OxIdMDcyQYV65msdrop8od2eOwy9rhC8DvNOxVjo2bL5k1gUDTFDWyebihwae17
         zgYNvO6THqDACeDr+923Hbs0cq/tAyG6VLI9qyMUKtgLPXAHIelvNMWifcNyak8egIbv
         2wT8ht3vMt39udq5LI2++MfNyVJGge3g3obklfGxvJxSl0cHS64qxk3FRhARsQQcE1lU
         N0Kw==
X-Forwarded-Encrypted: i=1; AJvYcCXny8hoxa1J04WrvEfOfANRZ7RfFal2GWYPw+UYBZginX3WtUvRtHhvfdyi1I99ZLFexnNAS3LrbQ==@kvack.org
X-Gm-Message-State: AOJu0Yxo6R8qr40xv9XbxYlcLwK/cKvxpudY5ZovFG4MAgby+E2ucsY0
	2OKmuTc17SdzhnBegGrj47yz70SF2gFEMBFMiF75S8Gqrcr/sKKA2Y5VvvZakOT727E=
X-Gm-Gg: ATEYQzx9W4jRNGEa4awJW9d5ilVIwyLUVwc8RRLH9cWRGeic/IE0MzWa8AHtSlhG9wn
	2onqDcxPFWK9kTppXUsyw8eCxAJJn0nAdnb8vWwmGi2WXKMMspI+lGU1BavhnsWGMRQvN6rXpxc
	WWBnFwL/TxS19lngI0aCAxlHx7d/CxsZXuoGn0C8CZceLYAlJvJSdp+Xv00AVWodO5bkYRZ2kvA
	3xBFBNdMtQtJ/MwIL3IkqKBSa0OMx2UGwCV4YjRvgrV7KZpHIVXy8agVP+Vo1wvJpVKi5yIoPjq
	U9fmeMU8xTIIEhybBnT4fOjhKWBkCcuq8lU423Kzu/nU9OKyrjZrzH5aFem3GqkfoJQblX/fQgZ
	KE5XfwrBSDMWa8jf+q5vT8eyN78dXvnJ95qa8kfxszZ1QhalN2suD7Laqc3x5bVrcDms4J6ip2V
	JyCBKHI1kL
X-Received: by 2002:a05:6a20:d527:b0:395:732:2c87 with SMTP id adf61e73a8af0-3982e2475fbmr1405418637.56.1772624867385;
        Wed, 04 Mar 2026 03:47:47 -0800 (PST)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7387271048sm182776a12.27.2026.03.04.03.47.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2026 03:47:47 -0800 (PST)
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
Subject: [PATCH v2] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Wed,  4 Mar 2026 19:47:27 +0800
Message-ID: <20260304114727.384416-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fj7y3bzn15hsqg7bjzwmzcgxx65hk4ah
X-Rspam-User: 
X-Rspamd-Queue-Id: C912EC000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772624868-173944
X-HE-Meta: U2FsdGVkX18lU00T3/9gKHogI5bYcXGL4IfB9XLQ1rj/m3V5O9hZpSq2yotht0r2LYUjbyqSnKOIbs+4BudWh94kDrde79P4CZuDh1Q2AerIj1x3EkbSJYAzfbXTYBlna8f21wn7FAyO5zbg1OKIR0VjKcPBe8BD78WVhiuINohmTBpL64VsNhQlCo64lkccXrDJLXq4aQHSolhurWuetAyOyjMV9DDq52CxYw3zc0CsM/GHhShdIBZ+BRNQHXgZtGiPpouzv3rAY5s9+wbOVhc1hHXXSXbS0Lp3RpVl936QYH3y0E7Hn80SSmo8rVadPRXlWB8QNnXuyF8wEEvJmnr+BrMFxQ2Vg2g0kMEX+uTkdXUFyTtx9ySpMxIo9SZLWpWqhO2q75pOJQbmt2OgpacQndDe0zuWDfBVkwSezw/Inx0Iab1F5WrUileA3/bT6TM83lFqkrbvXsC7vsCzSgidAOtAPKD2i3nepI3Inhox2uPRDsgp3LAUw+B8YKPkRD8pzZfL+SpxubSghmtYU5n4UGKFUcD5bEmvYepnwyc0Yi3G05y5mBzE2Lch2IlXL48xcF7jVaw7+l0RhGbQuJ9WmAlqwclOrih2pNQO8AYeu9sYE0rLf84STnr4yWVkLQlUicaYZ4P2OFtibTKGxIHqU7felpc50/C42Y15lRyFWkXi0dJRxLFQkK07AfK3HPIKwJRk9HTEyA4iRkHtmwlB39mlflSHLmBtpJfJszDsaSsNotXauQgOAsgD1ue+/G3nf6UjDbAEgQswMLb+MN2rF3FaRJF2X6+i/Z1nlKNqP/pd0Mw41BZgb+LOqAHL9qb7HOxVZq8dTDngy6mqw9Sj8HkBn42JPttWdklt2WOSf/UpkNOMO8rfX1qirmjT7qMMA6UblSyPodbJeBTzKSwoTOp48cfZR6Rnt5Fsm6/t1M59WdHno6kOvMqMc/EOB7od3Nqc0WYlr+jNnxE
 J/ZMuJns
 259QpWGhrofiwACSPMYTF6vq7jPpn0Oc/QBBckFy6+OTRpnYWwQ9MneObToNmumAJF4ZLDCR3bG+Wmx2GfhrVUkAFzu7Ouo48p5U/ACemXMZGp3zDeMu4BU9y2vP4PVCPqOZ0RsjsHsUN69qW5T5IJjvXfiMChiwhvkfTNaMPb+ObRkyc8rK0YRxP9XN7b0U4+zAsy2fKMTWr0OdtRegOgeFLWA+ZwV/jz53u8ilF2ZZVZ0Th8DGzHk0nfXO91AnsGt2ILt7/gIVdsSiUc8EBZssm13q+XsQadSiHDpaZ/CpRQ6TbkuJwvBFdcQgmJxobSEvZI5ODWWDfYJrd+1/AtX6jWuey0kx9Kol8UuP6jl+zB2aHg85fEkk/oUbkfzppt9xWciwJI6i9psjtUfl/bto2Qc5aoJ/t52ry9Ueq2hjnhrx3A4kbyI3zSd5p/2kjgkcu/eQmFbGwH4UNThaufyXG1Zy5T1YQNOGnZNHYw7YNty3vHVQz/tU4yV6JRmX4s6tithRZXgdc7RRYqRRuDt1BJpiSmQbtaCIId9/JooVjHabh0VXtLb//bMq6NzmQr9XbmQIP+Ovv1em/QuW0DRoddMTTVLop58n+zbK1dlqG5mM/Ut6g8zxw1RE41A7WTycXkDkZD97VPkE=
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

Signed-off-by: WANG Rui <r@hev.cc>
---
Changes since [v1]:
* Dropped the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
* Moved the alignment logic into a helper align_to_pmd() for clarity.
* Improved the comment explaining why we skip the optimization
  when PMD_SIZE > 32MB.

[v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
---
 fs/binfmt_elf.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fb857faaf0d6..39bad27d8490 100644
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
 
+static inline bool align_to_pmd(const struct elf_phdr *cmd)
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
+			if (align_to_pmd(&cmds[i]) && p_align < PMD_SIZE)
+				p_align = PMD_SIZE;
+
 			alignment = max(alignment, p_align);
 		}
 	}
-- 
2.53.0


