Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B582FFCC9AF
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 03:12:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2474F6B008A; Mon,  9 Mar 2026 23:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F1576B008C; Mon,  9 Mar 2026 23:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C37D6B0092; Mon,  9 Mar 2026 23:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F070D6B008A
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:12:43 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B21F6160466
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:43 +0000 (UTC)
X-FDA: 84528681006.05.BB45C01
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB02A140008
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 03:12:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=tBoW9kkN;
	spf=pass (imf23.hostedemail.com: domain of r@hev.cc designates 209.85.210.175 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773112361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PGbxRmtnq4j2JJLS66I6xJ9tyvKo4E5pO4kbP3Ck6zI=;
	b=bj+FCwo2zkeR6RX1coxmelOuoeG9F7ZFAFIBz/ZDFEC2H9nh4xQHJmMrCfmjYZy6C4U2jd
	SVuZzNT4emUOZgbHbU3AB6kEFFUtS+l0iu4zF28dQGz97DtCNzE6tXhe80JzgjnpCxNOzo
	AeEkrvV6L5uSqDQrMpQYt9B5/6qc+uA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773112361; a=rsa-sha256;
	cv=none;
	b=00rIVzTtndPpOK8teshxlm6XaTrWasALz+pGXYoQeKweIAZ5yhnHIC0rclzE+yYWHyX5td
	T1bsZ8EYtSsPQeaB4zAG8O3d5PSwnE1mQm5mpPSlWuq7rjfmgNaegaXe2eGVuK6tcvzyzY
	Jxql8mGdwnzpGhINDBAjEFq7AS9NNxY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=tBoW9kkN;
	spf=pass (imf23.hostedemail.com: domain of r@hev.cc designates 209.85.210.175 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-82748257f5fso6817900b3a.1
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 20:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773112361; x=1773717161; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PGbxRmtnq4j2JJLS66I6xJ9tyvKo4E5pO4kbP3Ck6zI=;
        b=tBoW9kkN77uHPp8E5FcE0LyQaXC9OpDIOjwF3jGvtZLWFbHHkjBUh9dl37hpqf6n0B
         YjZ5mzbu3aL5Dq/ms8Ofa+hdUKt4NxzUeVgMg8/ni9EP2MQ1Sj5mWACf/vP/HZ5P9yf7
         /I7XysuYwjO8wDjFbQ8v2yidZ5Gy44PkHDwr6R9HolOmW1jUt3kw79KBP7x8PPlh/dVS
         MOC1ZuB3F/rgrU525sQ7TlnMKAd3IlCeZ05bjtkuGMPWrXRTUJBdl9GWjq44IWk5NXnw
         PmPOW96F4o3HLAc1j6hpQ6sqNdkTBuFuCmRJSnyQ1OpBDLgakPQzxYwzxgmNAXUONr5g
         0XWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773112361; x=1773717161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PGbxRmtnq4j2JJLS66I6xJ9tyvKo4E5pO4kbP3Ck6zI=;
        b=gn2cgV62wb4NPkuA6dW8fm++PGpVVDxyLYXR4UURx3wdBcI1Vx6pD6R8ug/GHBRfoO
         OX/yuFoyJR70/hPPXC4IlNsjOW0v4s0pawL/1axmC1EVFqYPpVlYO35DpRtc0JfuJ02f
         qu7/LMesU3g+czggWeG7xxrp3BY2eiP5y0iiLQJlDPtZBkAZhsXYznwYjrA3tIfVOdvv
         wbhIPo8DEBuVd9fcLRGoKpOQIbFPP7xxLBThM4NwqwAoalAdWQQBoQ1pMy9v0NNnV9Yn
         dqF/wv/llVK/isntuJJSg7HZlnZRVCPxkzHAcftbhkf38mfhZaY2PjUVsbMcmSzDfmsV
         aE4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVsQmTE7uokQeLmj50pNL1n45sT2g2vM0ZHHbXNVT+mpUArts21dsh2rc9YmrrL67SXImOjI84nEA==@kvack.org
X-Gm-Message-State: AOJu0YwpCNhn/xG4qdBVVTKLi+DGJj10JB53LPC3glsvRckDhtu110v+
	oQd/HB5qkGQR7pGj1/ZSZQTqYsA+mEK6Actb3aw/t/bAeZZbz/57JAEEF+T5oTq4RgU=
X-Gm-Gg: ATEYQzxXHO8Wx+Yfp/etI9dSs7Ldn/xTgHefC00PV9rzvLFQ0mZYgvHHHAtH9vvScD+
	qsn6U+c8YjetFJiRCTYBlEo60O93LsqrTIJCSi6Mq4Oh2faQItaOMHSao7msg3Yo3wOtYkkjcQC
	AlP7HdAdi6bhbtGv3GyKaOGd+Yh9m7MNbmaXFLDLRULN3eyIOiwuptcdPc051LvurFo59pkSo4e
	95fbk95n401xPiPV0TUBgv2KGrOXNS7/8ic9LNvZ/nKoo645Ko1UagnQwLWBdFaZLJM7KyQcJRG
	QxFyUrUgNifh/3bsD3GxLxHtNmdBGTrmWb2v81u9Iy8/htJJhvELaMeBbaTJNCIVGkZ7rxEbUxJ
	HpF4TnqT/zyQH06xxytbUnb6wmZSxCJv2uQI8INJkEyEsjfIq9hHLFe63X+nTSjNhO2rr8D4oYj
	sI7aSzDPAz
X-Received: by 2002:a05:6a00:9517:b0:829:cbc0:f0c1 with SMTP id d2e1a72fcca58-829e3fe0536mr1540396b3a.18.1773112360560;
        Mon, 09 Mar 2026 20:12:40 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-829a465c872sm14213691b3a.19.2026.03.09.20.12.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Mar 2026 20:12:40 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Wilcox <willy@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v4 2/2] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Tue, 10 Mar 2026 11:11:38 +0800
Message-ID: <20260310031138.509730-3-r@hev.cc>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260310031138.509730-1-r@hev.cc>
References: <20260310031138.509730-1-r@hev.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 3ct4oin5dgobem7no8xmuf5pxbpkz4zd
X-Rspamd-Queue-Id: CB02A140008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773112361-753000
X-HE-Meta: U2FsdGVkX1+7vRK3h1DYGdyS+w5DhMhd9zFovknm0VE+C7bRwjMCGwwOWAbQwYQBn8JAuSyrlTQULCZiq/sdCNKFwSBnRtgllqmeOHn7psMp2eWMzzb0k1yQ+pfPlwAlaTnwtwRTUYD/QI/Y2PUzeBgZbWviLN1SvyiIENLn0AywEAuGbJTfVMnv8SWfNr/1vF6muTD4oroSUqzyLHaPG4CzaKzPXvJ03XgRIYczOw5s63cqlEsw130HcQc/4ce5Bqu0NyUsHE2ScVmXIgVilXNoH5N96tEUWVBQVbFV87ObGz3TTKE/WD3cL54gtkmiQVLdL4U4V/PZoJrK4ZggG+8BIKPNJkYZXC3bDl8hHPQDAhysZH6pEGLO0YkBC9/ojaUJ8Prbz2Sskf/gV40Kgs5zRTy75M0GCzfuBHEuFVvoAvwJsqXk7bd11mxV97DMsTCFKc3Yfdk98NROWJ10bLK6jIUY+FNTCOM6uzg22P0aORkPxV+ZWK0bXHPO0nYhFoXb876+ytzO9F57q4O+/F0tWq4TA77gwpspGaiteQ7j4ff8yYrVBdQC8jYF9SqDpNKT8JfdHviUkS1hvGziRfvPl81tfyUhUw92YihATQl6pQ0S5BF9vka94ILFvIyVwSZQ4jNTiKzAk2mSVQ0E/Nm73sn6k+g5x8B8UzxxoeAc3WgPgukc8VpiD7jwy9r7c8SJ/jzV9IJ+5usdiZB7o1V1tzJMtCWdCWxymjRwzGqey02qMgPKjJhgVaB4J8S0Lxw9knTc28c34etGNwtMxYU11FgcVIhYnA6MxnAljfz4hf6i/SkCoRxwU33L57yCN0DpwJZCoQfyNwbbA++BvMGizbOedIWScYHRZeIVpnAdkj00sSObznT0j+Hrpiv0U3PTfD/MnWOQBZ+0oouE3r6ksRvWzAPxTW1M05jzrtf7K+M8r9Qnm5oq1k93/huUOYJ5utLe//Bvr5QhEIY
 iZT5Hfzh
 WMmntNzjtOmc0uq26ipDB8PJcrZWquPsDzFexyhU0kvMbiO3pr51zvDim9l+HZo/xT+TyYk7lLhVwg0XLnGV96Ow6Q6W8zle3ClYkC7UNEXWK/0ZJclApBapgMsTGCmnIDMfj6vT2u06SS5ZTT4hXN4BbylL7F0QoUeZgU/YwR35fW00OWqb1CZYL05yJkKRtg5zY1JZ0auE9boZb/dnz2TvoCaeweVyS6rrk24uTqpLCzNGuav4ciLfU3+qnRHJDj95yHmpv0kaOnYsj3IeicLZ5bLRO+lfmXnOWR83rKSFEf7vyNtSUUCDj7dMPj9OZT9q9n7W84BbnQTuyRuLfxal7/fAhU7ZntLCk7qFd2o54XVPac2hI5JYtQFr3Vp6zJ+R33CO5m0pw4cNPohoHz4MALffR/P7DvBGPj98P4d8dXrANjRzHEMDeMoFkZUjvdaTGeac0sVlMF2iqtMcofm9X7qFLLGWGIl7oL/1WXBN/8w2pr4SDkUet+vQAeqzbXEMv7WU2Q8PhErTl30DtxYsb6RkEcwX3gZBn7cediBpljaKtxOJM8jBfQCv9jIQm++ZymyO4R+GQzYG40zP8p7ZG3H5Xb2xrz7E6+A+E2k1ik9KhuKfTjZKdew==
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


