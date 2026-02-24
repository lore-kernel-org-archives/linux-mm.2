Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0FFF4BB6B
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 17:58:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3906B6B0092; Tue, 24 Feb 2026 12:58:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AAB6B0093; Tue, 24 Feb 2026 12:58:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A916B0095; Tue, 24 Feb 2026 12:58:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E6046B0092
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 12:58:24 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DABA56BA4
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:23 +0000 (UTC)
X-FDA: 84480109686.03.D9C9C2F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F733180004
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 17:58:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771955902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7y0Jc0J+bS+WdBok1GAYL6hNJI8Mijo7uroC0FFQHyE=;
	b=rIKGBoXAHVZDhcaXsbTkH2jjy/pDdyUH79f+n67UScaIyQt3v8E7DvgeHMAZI7PczthNpe
	KCVTLsj5Os6YMfDZs06Er3U5jNNHo4zaLOrOGpCmMVk1+PxEsbYlrMquH5Qp4m3MVYx3Ay
	5XDFcwmFz2CsaEPZVUeFDcLBJ4MTPRQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of cmarinas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771955902; a=rsa-sha256;
	cv=none;
	b=OHf0Tl/E/VW2c9m38RhGQwMCCcbBR+betaYJwz+o4ZpwdahUyrhKLKBNTGL9ERxRoZPOBE
	ikRYtDx5b32R6LiVDSVMMYTn85XyPjMYRKdL7rOqbFKOekR4gNiTSWogYJjRVOz4yfMKYz
	vdBUEE609AaXAN68yZAM0JNCj29Jb74=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DA3B43E59;
	Tue, 24 Feb 2026 17:58:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B619DC19423;
	Tue, 24 Feb 2026 17:58:17 +0000 (UTC)
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
Subject: [PATCH 4/5] x86: shstk: Use the new common vm_mmap_shadow_stack() helper
Date: Tue, 24 Feb 2026 17:57:56 +0000
Message-ID: <20260224175800.2500729-5-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224175800.2500729-1-catalin.marinas@arm.com>
References: <20260224175800.2500729-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: oh4s9xizi3q1fy1x8g6ru7mz4yawb6e5
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F733180004
X-HE-Tag: 1771955901-583446
X-HE-Meta: U2FsdGVkX1/lbCGzeYPG7N0fLGwxo1LFOKi6n7DCi36+JX0iTIV5xN1brpwT9LM9eRWrgd5V7r+jKXX/TuMKzNUOrsNeA7dguJZSJ1x+trdsMd9pjCdwJQOoADMHwn2LAj8KAyHBERhx0zH5924ZHSqJIGcHmGCl5Oll3gYSCMCEqeTmjdIrO16WV8P1GPF9gRWvJ1QOvHua1x6AuiNbxynXxNoPVdPwzG61TvbJJj3p0Ag4s2Gdp2F1e9X3jRNXJrZw3mmmhoXXToBgaE4MdrpJehX2pyZz6rs4M4bF1AEQ2JkAfBgAlCDY73m1OstUzfDPEZd4IDqr7o3bx6ZmdVdx2j1t8lejMlbaHC3S+id1mzBCQQjtv+NCjKqLbMGOElblLVdMsbD5PQ7lFexQObE96B7H0CYPPT0yzpMxbKsicSC9dGXpS07jrWpEQ8nZ9fCWZDJxPaYMTf2OzStyYjRlgjoe6wcm/arRR2VBU7OwcCTzCUVJnP0tRhxKQG4+WYokv3tCNZTH10YMvhcylrZIpyeQoDK63o2cdHjs8ClaYYqnPqfhWHLZJWlmXAU7gsuFwiNFHaoYMh/ht3cW5MnpzjMHjTHIOyFCnzelsoa8KljiN8jflU0ZKMmdlafd5zm0RxDOS2UL2BGDZTVlSIv2drZfEe7J+w4O0d258Tq9SZCQgAoWxXBxmntzJUQc+oUQM7YyJ5vbRSRM2vvk6J8yyfBcCtHqvsJ+uQ2CBJlK9evw5OIKGNqP5IO1yb1oSiYOOsJQjPokL7Lim4uZcSqPdT6ERS0fZJGWIx9M1mqO6xEozRX7NoANaVpjHmWC/42KiZe3+eTsVcAbHOf3tZ6I/Kh1Lpl6AmzCnUrQzvuU2/xiNnRpEeKjLD53jiZd+nIjwtZVENjWnwq0oW3ZcIjEcfalPjuNUE+EbKSWdXo5XlI0gD9CD7AFrbOwkHotDR+kyqg5iLc0b1jRVK6
 f+X8lquy
 xLk5UreyixtUV/mVC5bjVVqX59sLKixxW66cVnK0PiNBNopP6/XhqSf2Ydnk/rzSEc2sFtugL3i8Hw1u+lF1vfkBN2o3P3ZfPoEMUCR0/uV+UNESP5C3MGTnCqpnxTgjkVL3R/A+KBoZHG3clRdXZhwc/ylp0t9oCGqJ7U7oGuHtANDEacCgjbmFxBiViMPl6TUckLziNZE5F4JqagSZuBzoPO17tSiVfFNP5WhgY1BPICqIvVRndcIcLnVlWN+LRVJkazXkT3bO6zs70uHW8Ut4rjS3qo+kbSgwLTdzVpvX1gXh2JzGDNmvNT8/Stb5PgFhrzjsXc+DksA7p06kP4Hlz01Q78cd20HQnOxs3r4GE7PPQHcwBtPNku124TBK4i+J1WFvWPE+p6oRjXX5VhQ8LbT54p7o6rzRALBvgKWgcvpX8rKYyUfou8mb5CrVqod3wXgdkIBORkZ2Ch/QpAX3mFSZWkDt72IFv1AoZU+MHcli343r0IS9teJLRDcjXcQpA4kAiabd3Gt76F6jcw3tMb2SHBIteb6Kr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace part of the x86 alloc_shstk() content with a call to
vm_mmap_shadow_stack().

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
 arch/x86/kernel/shstk.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/shstk.c b/arch/x86/kernel/shstk.c
index 978232b6d48d..9725e7d89b1e 100644
--- a/arch/x86/kernel/shstk.c
+++ b/arch/x86/kernel/shstk.c
@@ -100,17 +100,9 @@ static int create_rstor_token(unsigned long ssp, unsigned long *token_addr)
 static unsigned long alloc_shstk(unsigned long addr, unsigned long size,
 				 unsigned long token_offset, bool set_res_tok)
 {
-	int flags = MAP_ANONYMOUS | MAP_PRIVATE | MAP_ABOVE4G;
-	struct mm_struct *mm = current->mm;
-	unsigned long mapped_addr, unused;
+	unsigned long mapped_addr;
 
-	if (addr)
-		flags |= MAP_FIXED_NOREPLACE;
-
-	mmap_write_lock(mm);
-	mapped_addr = do_mmap(NULL, addr, size, PROT_READ, flags,
-			      VM_SHADOW_STACK | VM_WRITE, 0, &unused, NULL);
-	mmap_write_unlock(mm);
+	mapped_addr = vm_mmap_shadow_stack(addr, size, MAP_ABOVE4G);
 
 	if (!set_res_tok || IS_ERR_VALUE(mapped_addr))
 		goto out;

