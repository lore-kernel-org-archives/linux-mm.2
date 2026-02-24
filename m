Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62372F4BB6B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:58:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C55FC6B0088; Tue, 24 Feb 2026 12:58:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BECA16B0093; Tue, 24 Feb 2026 12:58:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE806B0095; Tue, 24 Feb 2026 12:58:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95EAB6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:27 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 585FC160274
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:27 +0000 (UTC)
X-FDA: 84480109854.11.ECE7601
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B2935180006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955905; a=rsa-sha256;
	cv=none;
	b=S6IoduMZpmFMkJRkCBK2BRtCOO0824k59rGBSIZsGJuMpQQMz5AJiU+6DOOXfHZ+1wOZWU
	dVw9zpOrSii+452UiTw5k4rZHyF1f0qrzWAD1FCtEQ1/xZ+SgvPRjmtpJVZjoXNDbo6uPD
	aIczQMtjQF0YB2cNY5aYlIO9bY4eW/k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf24.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GpIT185sCtpiWe7UQSE7TdalinJh0M9JALKV4zJSBSU=;
	b=DzrndJW9GzfvVKuHWi5ZuMgsEuk3L+U4QgI//ViDrFjB/bzABoXdECjKDHqmpuwwPIuXrF
	K4yCxwqDmjWl8fLGXOhmYyZNdNsfuPutB02wTKfblNVnlQFOfVQW5bdkxErLuYvXX75a6K
	DZLDzuHTIb3qdankErayaPtfGMBU9QU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E653F44553;
	Tue, 24 Feb 2026 17:58:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AC5C19425;
	Tue, 24 Feb 2026 17:58:21 +0000 (UTC)
From: Catalin Marinas <catalin.marinas@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Deepak Gupta <debug@rivosinc.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Will Deacon <will@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] mm: Do not map the shadow stack as THP
Date: Tue, 24 Feb 2026 17:57:57 +0000
Message-ID: <20260224175800.2500729-6-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224175800.2500729-1-catalin.marinas@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B2935180006
X-Stat-Signature: duobfb6w1fjdwjwewn7c87d1ruxyshut
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771955905-307086
X-HE-Meta: U2FsdGVkX18BNFAvqPrLZ5ILG+Nr24gSlW1R1+8t2MOAv6/7M9k389maXynaTrkSZpsgL/dz370OnBNnKa4anFnxFfIZs76XsjQxIO8bdrzRHBr5NZ7qnelpU4iTrh0x8h2m7VghuSnd6PosjIt/kfXoViNlnQeDu7oMEcRikstZudYBI52Vc2w4uloDPulGPsoKUozEUukdXkpOc5/ol8hpIAV3yjYk0CEPsP9dITPOGlwwNOkNNivwWDX5lcrUTihLTXeVvlS/LmzsXIfCcrd1GwLocyBFwRcSig+ZtcF5tUfRndcq4e+WOum1zAGFaTC6Eg49n5DE+C3PzVlJlFhx617OkUGt8swOxQP92QZ2ktDwcUuToZF+Jdb31PALsVWM2cEoG7ej62wowwPbMSKUR1TeK3Dp1Z5xB/YHrzZ6SUx59u0sUocjrmNyjZ6QhDgYg/Ek/EfJ9fEFMo6oYWDiUdnfE5J176Nw7BKqUFA7y3XrjqPnxmsHSW9HeKC1hsoQGR8wnTjRpcGbwqgMC7pEwpJXxQGBWBKl77qTFjpbDgqh2WlY0MN3jOYTvYAKsNSu6H/viawTYrMjdJD1AcullYQ3XkDkC/LjTpczlgQRt654HMmUQ/DRqM/fVW+rkyUz3iEff3YWRfrlmAAKlhYgD9oxCdisUj2RrM70ihqweZUpwvBYlDTR/5pWpNhEVunTNRgf1we0pjCUk8WYIPSjezFCXRJMYHxRR5XJBUrD1Y/JjVqqCqZficmiOkTChUuGHHGebcK70uApi164bAUSn6XMbAIgHUy1fde+jB5o5ATWOa/2Xz5XARYaJxgfQ+QxXYk7BpOpV/En9v7egiXMoYcGUGoZ4mq9sjAWJ3uqDLq3TDjjCV/VQHxopQ7l17F3nVFeCdJ1bxfH+eCVxcaSfAsV294371jrIdMwsVDIHA1rgMQxXbVKBPn9qwpNrICZx31dsTlH/9rXqw0
 p6HmnNhR
 rRSYbHsPo4hynG1tIRGMkARCRwNxse1NbubWP5piqeTD6yxSCLfmoRNDWnbvXGKEVQw/2g0rLIvcE9RjVzi5Pu5fQwtS48IjyOLsdCjpEstiomcSDNdmr3bd29Y4+ufe3a8eEADWNP9KdsdhY2ezhZrU+NOMHzo4HtBUsQjcONikl0glOF+L8yBn4/A2blB5foHbo0S7hDrE8a9VW4BCx12MIM671pZsH0ApU2iab0tAD1zwnB1B3nqx5qA5790SKy1olr3WpXlUpOz6hiFHuSqWbjtIhyE2XfbbWptVsJgqypl9F7PY5X6r4WfNqBkqi59pVm8F5p/TCUXlNdzYM2WR2guQSKB0CAWC/8OK0ZkNd9O4NzGNpioWz36ZRPfBxCU8kDhIASe7cMU2ZJ3uoegIILwjcBHvAFqMf4ZWWMeadCFNj0SbhO7+9uheZRuD6ZmGl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The default shadow stack size allocated on first prctl() for the main
thread or subsequently on clone() is either half of RLIMIT_STACK or half
of a thread's stack size (for arm64). Both of these are likely to be
suitable for a THP allocation and the kernel is more aggressive in
creating such mappings. However, it does not make much sense to use a
huge page. It didn't make sense for the normal stacks either, see commit
c4608d1bf7c6 ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE").

Force VM_NOHUGEPAGE when allocating/mapping the shadow stack. As per
commit 7190b3c8bd2b ("mm: mmap: map MAP_STACK to VM_NOHUGEPAGE only if
THP is enabled"), only pass this flag if TRANSPARENT_HUGEPAGE is enabled
as not to confuse CRIU tools.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
---
 mm/util.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/util.c b/mm/util.c
index 2592291948f0..9f33c6de6082 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -629,14 +629,18 @@ unsigned long vm_mmap_shadow_stack(unsigned long addr, unsigned long len,
 {
 	struct mm_struct *mm = current->mm;
 	unsigned long ret, unused;
+	vm_flags_t vm_flags = VM_SHADOW_STACK;
 
 	flags |= MAP_ANONYMOUS | MAP_PRIVATE;
 	if (addr)
 		flags |= MAP_FIXED_NOREPLACE;
 
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
+		vm_flags |= VM_NOHUGEPAGE;
+
 	mmap_write_lock(mm);
 	ret = do_mmap(NULL, addr, len, PROT_READ | PROT_WRITE, flags,
-		      VM_SHADOW_STACK, 0, &unused, NULL);
+		      vm_flags, 0, &unused, NULL);
 	mmap_write_unlock(mm);
 
 	return ret;

