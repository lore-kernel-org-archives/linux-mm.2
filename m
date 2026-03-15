Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65198D58B0B
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 03:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564F46B0088; Sat, 14 Mar 2026 23:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F5F6B0089; Sat, 14 Mar 2026 23:47:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F4716B008A; Sat, 14 Mar 2026 23:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2E0126B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 23:47:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B650D5C59C
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 03:47:03 +0000 (UTC)
X-FDA: 84546911526.22.F989F70
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id A6261120002
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 03:47:01 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ECghoyWQ;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773546422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7Nj+C4buAERt/DCqiV+RAaqLwYdsTcea6HrGcK7f60=;
	b=U14HJD1poKSALmdVpmIUtaA/hEXehJdZC9Til81FeLTkQoMF9AK1tvNl1lX2iYGiaqfMP9
	vH2bvk5hGMzIFLWg1gNG1Hx9/16kmWZj9xc/FIh2roJNOliCGIGUQ4EnlKt70xlGNzG+FB
	HIuW7S9C4A2iZ3MfE2VVdmuud4B8QVI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ECghoyWQ;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773546422; a=rsa-sha256;
	cv=none;
	b=HrZTRUtiiWraCikGUvW+isYISeQ6sd6KudGytLaRXbeWtwWvfyffRBkMC+f7cduj6aEoGo
	Hj8WEdmOeyWBLuFK0o3EZSWD8oyxDDNRLSFlnlHy8f54stNvLIhr8/Ll6bcy959UA4uQSc
	LTzK2ZqtBfRSIsOfhouEJRC/lCd3StA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773546419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H7Nj+C4buAERt/DCqiV+RAaqLwYdsTcea6HrGcK7f60=;
	b=ECghoyWQ9JPM54JjuKAsHMky/5Lkp72KV93HMtCD0xvw1ZhnuKuZ3Mofp+qGCm9x2GQ/qM
	qhnSL7bj0+k2shoxtfHntotiKE79LACkFQPjMfcYPr+rXWiE8VD18wvPXz20rGEaNbFAz4
	hf/QKKOrxxp5nGolHKhVOHJAt8gWjdw=
From: Lance Yang <lance.yang@linux.dev>
To: r@hev.cc
Cc: viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	david@kernel.org,
	jack@suse.cz,
	kees@kernel.org,
	willy@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	baolin.wang@linux.alibaba.com,
	usama.arif@linux.dev,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v5] binfmt_elf: Align eligible read-only PT_LOAD segments to PMD_SIZE for THP
Date: Sun, 15 Mar 2026 11:46:47 +0800
Message-ID: <20260315034647.8462-1-lance.yang@linux.dev>
In-Reply-To: <20260313005211.882831-1-r@hev.cc>
References: <20260313005211.882831-1-r@hev.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A6261120002
X-Stat-Signature: 3egawcbxtpjzgijra698nswgnou7kdcu
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773546421-948299
X-HE-Meta: U2FsdGVkX1+UOawkHRiJABA5pr2zTYuJb73N9ZRb6LobMhhZ6ko7E/1XBIR/RgvA84LGLyBQ1XYUztRGgdyUWLcUOEER409pRuOvVZxB7XbVWwrMaz+ghyKesT+vHAp5lVbjP7sEu5yoDEVcC7yITycV1Z5dRzatQ2XB1omR0Ngx8QgRfHZeF4v6xG4Q1ZQQe3VGmTMWu16l08P4xQpLr08n0CwuDWx70tDfzjNc/Y4J/0Ydxs0SCmmDMyOfC0gGms1hudN7eqVbR7soS3kjr+CKA9GQ1He6ZPeifOf0krMdayoY2gpLGiG4g46Sh3wMuhCKG3+sxuFX74SNAwqOyHRDHM4UxW94ZRqLN6l112aLkBejU+Nk8h2S/xpsFnwY+JLxJ/C1PulcCzOp6WW8H5lv8s3QHRJ+NN/uhGEbm8DUEOjd1/OJN++kGFUzyK3pqLU2UW6IzmQyurfRPyfQVU0uP9HSWBC9XZAz2R3J1XDikIXSiqPKPolxSZ7UGarWJguN8hGViZxsZZhOcnJF5lPqVnPFqtUvGHkJSRyZoOVb8ILYJ5b+AYq5/bL+BZruMCAM3lvXZ/geGZkbsJ9H/IadaB7BvnqAU57ORgh+Z26AVN5ClTbCsm/8YOGO1wjWyeh2Ahy7Cd93tKyOu8NVu7kUAw7CxKrMcU1aHryWV9TTA1jLYq597Vi677DTRHHvVPcLDcmD6IgiGtLyYpbMJmtpYiQmswrAzEcskfbN1s9GpX1IZXbBMdcn6fPaQY8Di/st3ikSMWKUQMEuMCNgqTpEJ3zbNA773i39aWt1HJM5AVI8Yo14sX185M7yVvQTc4oyHksb14ebeP9aDkvDaA6fErQL0RbCUmpM9W4azB2VOsHH2vsGgPXI3QtDcAPHeMIO4u0GDh1mRU497ZfhQsv2raPcmW7WYzDBBb8Mk+t8kIQxLBK5YSC5Jchim5s5PARoVydlvK+fnipt67x
 gciwlzIY
 PMUL+oicxGk0Gqoss4zqkQsJKSADcy5fbFEvUn3A0hERWgEp8Eh+2xIY8DygwJBkxGhSf93Dj9iXDjCnXEjmczvZpdOQkRxWexFnBORGbRBMHdX7pampvor5017Dc1DlVWfNlGZsRlOZI6gTJahHL0GemIK5OT1nOsNkxM96iTgM5HoryV3PWfYKIOAGEAh0gPvdakIIpXN+cHYe3OFJQLg1SKJlvQXnB2tFvuOMhYjIOsM2PpwK42yCumX8JSAxdguK9MY+KY+LbUrNrGQvLkhAhNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Rui,

CC Baolin and Usama

It would be better to keep earlier CC list across revisions, especially
for people who have already reviewed or were explicitly include before.
Otherwise, they may simply never see subsequent revisions, and from
their side the discussion just stops there ...

Thanks,
Lance

On Fri, Mar 13, 2026 at 08:52:11AM +0800, WANG Rui wrote:
>File-backed mappings can only be collapsed into PMD-sized THP when the
>virtual address and file offset are both hugepage-aligned and the
>mapping is large enough to cover a huge page.
>
>For ELF executables loaded by the kernel ELF binary loader, PT_LOAD
>segments are aligned according to p_align, which is often just the
>normal page size.  As a result, large read-only segments that would
>otherwise be eligible may fail to get PMD-sized mappings.
>
>Even when a PT_LOAD segment itself is not PMD-aligned, it may still
>contain a PMD-aligned subrange.  In that case only that subrange can
>be mapped with huge pages, while the unaligned head of the segment
>remains mapped with normal pages.
>
>In practice, many executables already have PMD-aligned file offsets
>for their text segments, but the virtual address is not aligned due
>to the small p_align value.  Aligning the segment to PMD_SIZE in such
>cases increases the chance of getting PMD-sized THP mappings.
>
>This matters especially for 2MB huge pages, where many programs have
>text segments only slightly larger than a single huge page. If the
>start address is not aligned, the leading unaligned region can prevent
>the mapping from forming a huge page. For larger huge pages (e.g. 32MB),
>the unaligned head region may be close to the huge page size itself,
>making the potential performance impact even more significant.
>
>A segment is considered eligible if:
>
>* it is not writable,
>* both p_vaddr and p_offset are PMD-aligned,
>* its size is at least PMD_SIZE, and
>* its existing p_align is smaller than PMD_SIZE.
>
>To avoid excessive virtual address space padding on systems with very
>large PMD_SIZE values, this is only applied when PMD_SIZE <= 32MB.
>
>This mainly benefits large text segments of executables by reducing
>iTLB pressure.
>
>This only affects ELF executables loaded directly by the kernel ELF
>binary loader.  Shared libraries loaded from user space (e.g. by the
>dynamic linker) are not affected.
>
>Benchmark
>
>Machine: AMD Ryzen 9 7950X (x86_64)
>Binutils: 2.46
>GCC: 15.2.1 (built with -z,noseparate-code + --enable-host-pie)
>
>Workload: building Linux v7.0-rc1 vmlinux with x86_64_defconfig.
>
>                Without patch        With patch
>instructions    8,246,133,611,932    8,246,025,137,750
>cpu-cycles      8,001,028,142,928    7,565,925,107,502
>itlb-misses     3,672,158,331        26,821,242
>time elapsed    64.66 s              61.97 s
>
>Instructions are basically unchanged. iTLB misses drop from ~3.67B to
>~26M (~99.27% reduction), which results in about a ~5.44% reduction in
>cycles and ~4.18% shorter wall time for this workload.
>
>Signed-off-by: WANG Rui <r@hev.cc>
>---
>Changes since [v4]:
>* Drop runtime THP mode check, only gate on CONFIG_TRANSPARENT_HUGEPAGE.
>
>Changes since [v3]:
>* Fix compilation failure under !CONFIG_TRANSPARENT_HUGEPAGE.
>* No functional changes otherwise.
>
>Changes since [v2]:
>* Rename align_to_pmd() to should_align_to_pmd().
>* Add benchmark results to the commit message.
>
>Changes since [v1]:
>* Drop the Kconfig option CONFIG_ELF_RO_LOAD_THP_ALIGNMENT.
>* Move the alignment logic into a helper align_to_pmd() for clarity.
>* Improve the comment explaining why we skip the optimization
>  when PMD_SIZE > 32MB.
>
>[v4]: https://lore.kernel.org/linux-fsdevel/20260310031138.509730-1-r@hev.cc
>[v3]: https://lore.kernel.org/linux-fsdevel/20260310013958.103636-1-r@hev.cc
>[v2]: https://lore.kernel.org/linux-fsdevel/20260304114727.384416-1-r@hev.cc
>[v1]: https://lore.kernel.org/linux-fsdevel/20260302155046.286650-1-r@hev.cc
>---
> fs/binfmt_elf.c | 30 ++++++++++++++++++++++++++++++
> 1 file changed, 30 insertions(+)
>
>diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>index fb857faaf0d6..d5f5154079de 100644
>--- a/fs/binfmt_elf.c
>+++ b/fs/binfmt_elf.c
>@@ -489,6 +489,32 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
> 	return 0;
> }
> 
>+static inline bool should_align_to_pmd(const struct elf_phdr *cmd)
>+{
>+	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>+		return false;
>+
>+	/*
>+	 * Avoid excessive virtual address space padding when PMD_SIZE is very
>+	 * large, since this function increases PT_LOAD alignment.
>+	 * This threshold roughly matches the largest commonly used hugepage
>+	 * sizes on current architectures (e.g. x86 2M, arm64 32M with 16K pages).
>+	 */
>+	if (PMD_SIZE > SZ_32M)
>+		return false;
>+
>+	if (!IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, PMD_SIZE))
>+		return false;
>+
>+	if (cmd->p_filesz < PMD_SIZE)
>+		return false;
>+
>+	if (cmd->p_flags & PF_W)
>+		return false;
>+
>+	return true;
>+}
>+
> static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
> {
> 	unsigned long alignment = 0;
>@@ -501,6 +527,10 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
> 			/* skip non-power of two alignments as invalid */
> 			if (!is_power_of_2(p_align))
> 				continue;
>+
>+			if (p_align < PMD_SIZE && should_align_to_pmd(&cmds[i]))
>+				p_align = PMD_SIZE;
>+
> 			alignment = max(alignment, p_align);
> 		}
> 	}

