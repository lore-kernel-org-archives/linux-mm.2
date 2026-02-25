Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EAEFD376A
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 16:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2826B00B0; Wed, 25 Feb 2026 11:14:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09E126B00B1; Wed, 25 Feb 2026 11:14:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CC46B00B2; Wed, 25 Feb 2026 11:14:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFC846B00B0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:14:27 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9357A1C826
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:27 +0000 (UTC)
X-FDA: 84483476574.15.76D6B8C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2BCBF40008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 16:14:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772036066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhF9JQ5a7vxqdrgHZnk9Ef5pQxzlWB++LyVTZrEjwQM=;
	b=MeethnF4BRmT4gp1rAFErlK7ibVsZKdCuKZSytVsx2vmMtXWZZx2xEeKo/PK2LMArkgi87
	nW6tb4GkJyBPzC1M85RgrObb8QQOmKliuMxZaEPxDyKismclujtujdPC82pMk3o+9DcPCZ
	GaSwFxXkBt6ebzcrHc2ekWlJPytiiwQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772036066; a=rsa-sha256;
	cv=none;
	b=7TXXTcQZ3LmIfglyrp2rirLI+Y8ICKTCR58jE6A0lgCvovo3emLStRFbU3nF0EmG1ZUYZ1
	AS7e7/ieE9ZLESKx48kRuSOe0LGpwi/B6IH99EH7i1mn9Pn7Du83Ju871YsW+dZCPO8R5c
	MPSuzigESuTSTqYAKhaD9sfMddgJcps=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none);
	spf=pass (imf11.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5076600AE;
	Wed, 25 Feb 2026 16:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1798CC19425;
	Wed, 25 Feb 2026 16:14:21 +0000 (UTC)
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
Subject: [PATCH v2 4/5] x86: shstk: Use the new common vm_mmap_shadow_stack() helper
Date: Wed, 25 Feb 2026 16:14:01 +0000
Message-ID: <20260225161404.3157851-5-catalin.marinas@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260225161404.3157851-1-catalin.marinas@arm.com>
References: <20260225161404.3157851-1-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 7aamgwqkeumhi7ofoj4n1he8izi8h9a4
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2BCBF40008
X-HE-Tag: 1772036066-706251
X-HE-Meta: U2FsdGVkX1/Mo7Hr8QcqNsOlJKNvZulrWAiDMXQh9v/MRxUJfBXoiBUylegC6BRDliL2ds8hlrgsI9hrV/4QAHGVE/db4s3k2vQSuvdmPUVzKhCg/0pIAgOYorkGNlSuWarBGtE9PYd77sPIdZ7jFUjl1OLDvCAcnjJ9Thy1V8ejgs6tDSmA2iGPrVZNxxR3vw2akREpmA+eZDQoio1N8sOfUU2PYWr3TRl7h5xUbovyuWvyLNxxpIN78bVOHN+nctlB8shRNrFoSB7Ig83DqTKDWwg9rX+RmgDdTo0PlDg5tlkRh3hR+od768orjn9bE2W8i2Pj5BGaWvgnZxj2bsf09H/Bxgwd3Fwy9Gb9iMI3a7VlDGvjyN2kHDTX4zzmsXQjCQDAdvFBZ2G25xAZ2e09nh7owlPKDPLXZNkUw86qrbReXpnbe/boG0GPhOlUQoINaisVoJEzBPdsr7kjQMgml+iwpQHJXMdtEFpkabxCT3DNGu2cW/dLBhHgmd+vOgH8HvzjDUIzVtYOmHw+MUAdFLhD5mCQmrVaw9iUJ31eqnpVm5Lc9WpFWZYjU8xLF3Vp+/jG6aEtiV7cJObbzvBr9iljLtm/B9VqdENYNL7mgejW1IbN7vAoe1CfqJ6ts/gBsFAhXF1zFzmSSccgSMGWFnWtYK8v9uIyMU2HHAGYga6NxPowjxm3sthYboV93sZPeNl5G3ZqJzUGCX5zb5YEd0Hn8kQSa8RMqk6Oennd0P1Qopya9bpHjKgNhmOnev5P9bE18nmJuW9v0J3PHTX4Qzz91XTQXi9EVU+NB1DTDSWSvnMIKcsNxE++8cuU0CvZ2mL/UEBRPp5Ka4fSpERRbz308NVCoa4DTW9tkvzl9zeC9qvrov5G3aB2v0LHJjfEeF/VVKH83Y7DwK8z/eTTbMp++8ThF1xnVHHUIXTc2rXRuUIBQIh0CIQTyOVr+fmPeAmkUWoA4969gDV
 oJnrJsY5
 gmkEek2hkeApo3nycoy7VQpxtV2lmIM+BpiiADymcuQhSRAiAJdu6wgzggXDjLRHecLzxjXL4rtyVlYEk9QHIH09Muhb0oxn4DET5Uxy4YOmzPgx7fe+gLzRYrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace part of the x86 alloc_shstk() content with a call to
vm_mmap_shadow_stack(). There is no functional change.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Tested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
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

