Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BFD5106FD60
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 00:52:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2EC6B008A; Thu, 12 Mar 2026 20:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870A46B0092; Thu, 12 Mar 2026 20:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752136B0095; Thu, 12 Mar 2026 20:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 622D36B008A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 20:52:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0CDA91A0534
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:52:37 +0000 (UTC)
X-FDA: 84539214354.18.E47E8A8
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf09.hostedemail.com (Postfix) with ESMTP id 45E59140010
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 00:52:35 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=xzRoy7K7;
	spf=pass (imf09.hostedemail.com: domain of r@hev.cc designates 209.85.215.177 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773363155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dGznOHQEDu0JbgYRJJzSYbQuqE+ZUTZUlFHToiIO7T4=;
	b=CAHUr6Oxh8/WOWp750Jaj23MRkR8kbR66rRBiEUMX8i1J7Pr4/iSWr0uh0p6XCFxX6HbGS
	a48arQMaOXDNUWudNoITqwLnwauiOlft6UlUrcAnlz2xoXgodimZDREAuV5PDJGhxDs9h9
	pmAFpYWWtLzjMPNm0qdCa23FyivX1bI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773363155; a=rsa-sha256;
	cv=none;
	b=VNgX+10q7Yn6HMAIP9ZZpq2b+CODV3qPyWQ3WwBhaqAhkVMxCQnjayLaG6hVPCR/iHIIiY
	T8uX/7v1OplDFBQePwqtk/qJ1//rViWW8B+4+fNKmkwjxL2r+JgHiY8n890aSQNK1lWJzN
	Noo6znAC6XZHwSnUTrekjD+cIJ6lDzc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=hev-cc.20230601.gappssmtp.com header.s=20230601 header.b=xzRoy7K7;
	spf=pass (imf09.hostedemail.com: domain of r@hev.cc designates 209.85.215.177 as permitted sender) smtp.mailfrom=r@hev.cc;
	dmarc=none
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-c73bd024a0dso674293a12.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 17:52:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hev-cc.20230601.gappssmtp.com; s=20230601; t=1773363154; x=1773967954; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dGznOHQEDu0JbgYRJJzSYbQuqE+ZUTZUlFHToiIO7T4=;
        b=xzRoy7K7+SPXXVCKlFij2Yvi5+3YbuPz648gJDrwCWA1fZGCEytnsezbIeCoo4Ft6m
         bwhh7ffZJ9GgslYNNv8k/LlM721aDz8CyX/wLBL4Sy4Vz55OlpwahtKGcYeQFq+tMoH5
         LLXqp4iK+xy8473V0ysbbjiZcs/6rUPRdyV/JQmvvTbLBWlI8KsafoqD7q5E2V3ZAS5H
         3ZKMKcVKLoF6bdA54wDjw/OF9ebhe0CKDZt8/gIwws1ZDCulze/bSuEQMpZ00ExDc8TL
         0gNCjPipIpMluwbquCbyWY5P0XYCj7b3s4W/HlgH0hVKin8VLC6fCC1/W6rNAhM56ST2
         XSPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773363154; x=1773967954;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dGznOHQEDu0JbgYRJJzSYbQuqE+ZUTZUlFHToiIO7T4=;
        b=F/rUCNG6kGSFiM3Tht+M7M8oCqQ44WJb3CjGKDHo2E5zfnAaMZBvGxavx3lXe1xHXp
         jYyNLx7I54JHI3mbPkhW3tv3P1bs2197trbHO3HfTBETzTHQH2sOQ7ZGK58YnEqvi6C/
         oat8q+Zv/AKI8Dz28ruZ+ydX9G44oSUIMTHNLvdFArYRC4XdJ6VXMmk74I2mcR5LJW3b
         MagQFlr0+5sy+CP1bm3fnLH+UsN7EzCWgFpi6wCkSSPADxnfTI4Z0ZsPHsM1UHkhZC11
         H6XpcdEusSsVBO1s2xKpg56y5/k/7DyLHkVAYIJ1b0TnjN/aUS6Mu7JBUtZ44aFoWM/r
         psig==
X-Forwarded-Encrypted: i=1; AJvYcCXtxeHgazTkvdPT47+mQbzHzQadkGPdHnZEJ4gj+YHIVS52hAzkYOY25ZwFvMW5T8C3Y+4HTw47UQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5xmCpeSN712kNBdmbtOMvMqJMhbAxukQhXxN9c3qkBIsjb1Vw
	WN0I3RoTqySPCe3tN846727DyiqBHwrjgcKJYhSGyPmHm7Az2hcF8wqITwZdG/Cmx64=
X-Gm-Gg: ATEYQzz/l2vFAr0CxMQ5ivPwWdvj1Mr3HC/h5KbIA5VX/UjEvdoGmGf24TwMZVb6sos
	XSH21kHpje9LvXu8jzOpQaGw6ysPJrq4WwuCO6IZ07Y6MuJ8Ua4mZbsXF5+cjzB+N5/ze86g9OZ
	hvOBOsUbi0X49P1+XpwEzYpHZGvOGg6BgezDr20IRaHDpwGsLitCx0tr1yVB78eDO1TGM8TZotf
	UiBMbV0Qyso+jb/jxMVYnyEiqvF5/uMg8AuLBLq1Ail921YNmHZvOr/wfGMh0lSw4FCpBmeWJRm
	wPNW+Sa5BoF7kvWQR1ksB9TGX7TVxsIN5SsTiQIPgEZwrTFPg+g1mQQ9/PeX4nHkGkPPxr8e9aV
	buGOZDME06qVPozuaqESrZBQZTbXiaUC3XCSoREhOHCioqmRhwK8YGWse4DDpLQkB+aI1dxrtYF
	frxfh1cYyrpQ6pHM4/RpI=
X-Received: by 2002:a05:6a20:3d88:b0:398:7357:bb92 with SMTP id adf61e73a8af0-398ec9e200amr981009637.5.1773363154010;
        Thu, 12 Mar 2026 17:52:34 -0700 (PDT)
Received: from localhost ([2400:8902:e002:de08:5754:7dac:85df:935a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82a1e72cf33sm122827b3a.37.2026.03.12.17.52.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 17:52:33 -0700 (PDT)
From: WANG Rui <r@hev.cc>
To: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Kees Cook <kees@kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	WANG Rui <r@hev.cc>
Subject: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Fri, 13 Mar 2026 08:52:11 +0800
Message-ID: <20260313005211.882831-1-r@hev.cc>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 45E59140010
X-Stat-Signature: swrnb3wemf9kx763do6wugez7fcibdnp
X-Rspam-User: 
X-HE-Tag: 1773363155-365490
X-HE-Meta: U2FsdGVkX1/nYbm0XReJXeFwffbtsa2rMmDN1FmjfPwE8mppMOLx2Wh9xij3ExuHp9KkSBdxiYhgBW/QzAEwLZxdTKy8vbFM3I1vq2Qe8qZt+jn/TCDgP0v/4quYkN9NUWxLMaWmCBqFci8Uptzkif4RFJdpPiuoDqDrYX7BYgkbw9RrF53hDZtWiCRpugxmWbZxuU4E7CqqqFs3uXjJfV4QKe5434Wf0IhfNGCdLuOExmTnTn7Ln/ZqJAYO7JyrVr7SyLNW/1hFfbdX4FVQqISA8B407azqThg98f6jo7ou3rBqNbFT7YEy5Mf7tEmgoLAbzCIty3hoXr/W1CxzSpDUJTf9MREDphFlEfvx+0eImCJHRBoi1hHpNCYjLTVVNShdBdGibWuW1HYH8CI3C7NIMs0o8D6Q8oqYI6fbODdKu2UCdv1mb6AINXO16TuzZWgt7Y9fJqu6jCD8mtlmwNNTSQ6YRCu3cixXnVEaUAp2VSg7DWb5Lz2Emi8tcWxMTjIqgSu0iRZkTT3U+Lllj7TlLJSnSbfD0DB3zYals7j2t5dAZjZlfrm72DtUIF7ryYGvN3gQfuMXAalnnwqbyYHekxmYQkNj6TnEY9/7EGqugbLH8TAUJslhFTPDvM+mtflNMN4kU5mbVBo76ZIYvZxQoD9CZtK7iIG3/c/WyTmNb69fjnYbo/76ESfpnN/AIR5dJL2MKi0U7uZ0WEz031Xs8eCtkipzJwJh5hjzrsyvrbHI3JiaNLR3nkSFqBQ4Kmnz/2aH0ct6S2KckZ2ECZc1bZI1FEE6QF7YwwO/YUqglWFhcsJSPaXsZLBf95XXdP+WzcPiec0p/IvfrTGlCLgTtQAhPUyTsAR8Wr3vXUyeLYYah+64R+zCDYM2b2nCQj96a47TTQaNpnT3VEVLSjTIKG5rsC0kAdVd+YOB/ZuMJO/AoYwpR25weO/+5weTNjbLNE08HhJJF0AqINf
 VPJ72R0r
 OKMx0ZVVyY6ymq1Agnrv//KZe6Ps9tk5k1E6RbqJEcIJJkka8bq7d4XDZGRZ8mPnQeODrbHzaVmwfmLMyB99ICHwl3h4A1mTww9wP3Fo8TplmxvxNDfSgJPnalAmQaRKvzKQgaumUqOfEGEYllgLI+MnqRQRHHxVNkMAhQxr61pAW2pMx+uXZOMg4eEzcIci3EWv2/LBP2qCmaehSGrZePVmt6fveJqCPj1uodI7vyfis1ztld0PdHfbwSqz+yCwEtD7C2LB1AnEy/iqF4jC0YjvrpvnGk1M7RY3wNd3MmAlVwofqUESoa4Aoy/a6gjboGfswPOFG1tbXFlhdMl5OnWvbcj+ErrBW11dse81pb1s9zbWznjUkmGYXr+wVls958UsZEv0n+swOWTpU3SSH+s7JQh3+20PMP21ZxPU6rlGySawmUqz3v2pIhmgBt4tP5qLbcrZuAI2iI9HL5jbjHznVL/Mx+Tulo4gKphPpr6t3FtPc1vdRkM4PrZ/mIqHUkePtp1DI7AYugmj8LyrcSdCNJXBFZlfzQGVCldHSfV+HSEPfheQuuXPJJJWp45GCHBL8eReE8mXnvGW24E+q/w0Z1TlgweTolvEeghOQF3113prXP4PvjceKovnrfw09ZpzWQfDfNw8bsfw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

File-backed mappings can only be collapsed into PMD-sized THP when the
virtual address and file offset are both hugepage-aligned and the
mapping is large enough to cover a huge page.

For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
segments are aligned according to p_align, which is often just the
normal page size.  As a result, large read-only segments that would
otherwise be eligible may fail to get PMD-sized mappings.

Even when a PT_LOAD segment itself is not PMD-aligned, it may still
contain a PMD-aligned subrange.  In that case only that subrange can
be mapped with huge pages, while the unaligned head of the segment
remains mapped with normal pages.

In practice, many executables already have PMD-aligned file offsets
for their text segments, but the virtual address is not aligned due
to the small p_align value.  Aligning the segment to PMD_SIZE in such
cases increases the chance of getting PMD-sized THP mappings.

This matters especially for 2MB huge pages, where many programs have
text segments only slightly larger than a single huge page. If the
start address is not aligned, the leading unaligned region can prevent
the mapping from forming a huge page. For larger huge pages (e.g. 32MB),
the unaligned head region may be close to the huge page size itself,
making the potential performance impact even more significant.

A segment is considered eligible if:

* it is not writable,
* both p_vaddr and p_offset are PMD-aligned,
* its size is at least PMD_SIZE, and
* its existing p_align is smaller than PMD_SIZE.

To avoid excessive virtual address space padding on systems with very
large PMD_SIZE values, this is only applied when PMD_SIZE <= 32MB.

This mainly benefits large text segments of executables by reducing
iTLB pressure.

This only affects ELF executables loaded directly by the kernel ELF
binary loader.  Shared libraries loaded from user space (e.g. by the
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
Changes since [v4]:
* Drop runtime THP mode check, only gate on CONFIG_TRANSPARENT_HUGEPAGE.

Changes since [v3]:
* Fix compilation failure under !CONFIG_TRANSPARENT_HUGEPAGE.
* No functional changes otherwise.

Changes since [v2]:
* Rename align_to_pmd() to should_align_to_pmd().
* Add benchmark results to the commit message.

Changes since [v1]:
* Drop the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
* Move the alignment logic into a helper align_to_pmd() for clarity.
* Improve the comment explaining why we skip the optimization
  when PMD_SIZE > 32MB.

[v4]: https://lore.kernel.org/linux-fsdevel/20260310031138.509730-1-r@hev.cc
[v3]: https://lore.kernel.org/linux-fsdevel/20260310013958.103636-1-r@hev.cc
[v2]: https://lore.kernel.org/linux-fsdevel/20260304114727.384416-1-r@hev.cc
[v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
---
 fs/binfmt_elf.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index fb857faaf0d6..d5f5154079de 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -489,6 +489,32 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
 	return 0;
 }
 
+static inline bool should_align_to_pmd(const struct elf_phdr *cmd)
+{
+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		return false;
+
+	/*
+	 * Avoid excessive virtual address space padding when PMD_SIZE is very
+	 * large, since this function increases PT_LOAD alignment.
+	 * This threshold roughly matches the largest commonly used hugepage
+	 * sizes on current architectures (e.g. x86 2M, arm64 32M with 16K pages).
+	 */
+	if (PMD_SIZE > SZ_32M)
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
@@ -501,6 +527,10 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
 			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;
+
+			if (p_align < PMD_SIZE && should_align_to_pmd(&cmds[i]))
+				p_align = PMD_SIZE;
+
 			alignment = max(alignment, p_align);
 		}
 	}
-- 
2.53.0


