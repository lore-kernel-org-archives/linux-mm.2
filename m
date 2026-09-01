Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCF8C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 08:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F48D6B00CD; Tue,  1 Sep 2026 04:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4BB6B00CE; Tue,  1 Sep 2026 04:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4937E6B00D0; Tue,  1 Sep 2026 04:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27A7E6B00CD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 04:57:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8ABAD8037B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:57:48 +0000 (UTC)
X-FDA: 85164590616.12.2022E6F
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id D555B1A0003
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 08:57:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FAP146J+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788253066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g6gNF1L2W2DbFnprEAmekbeKiRyxpCj5ws+3FN1RDWk=;
	b=KuenvaconM/82fiHJqT754r5o0hOitfyqdQTJjHgI80wVJAeTyBS28Gt0LtURqUmAmhq00
	wf2+l2ReY+HAQJu8MkNAMgdUUF7siWguv2X2/owtpeHxl8wsOSH+8W3BRVaUh/UAs3sanL
	3SMz9IC+B0l5z2yv6vOmk/Bc+b4u3sQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FAP146J+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788253066;
	b=MADGNMuO9XsuDjmNHePOL38HJQWF0lZReyrmJL579opZxp8CPWDLK5bF7QVGyKNvm+EZla
	01nB+YctcV1STpJ0clcQb8MHK6Lrc8cH/205bioWvPSG6bRZc6+doxS1jok3sgcnmxzgNf
	XaFh3ZEAjScGtgBGXgerXEMX3mAd81U=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso51731015e9.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 01:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788253065; x=1788857865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g6gNF1L2W2DbFnprEAmekbeKiRyxpCj5ws+3FN1RDWk=;
        b=FAP146J+aOsYsLimwMnwB0xh+tvRICLUduWvhXFhe5mWBwGX92jLA4iCZApeLtKAci
         m/PwazjWI3YKhbcbun2HliRIvMOcFIW1MJfz6HDIFSqFDxtd2mRXIIeS0S3AYA0rbFe6
         u/KS/dTjNm9LYGYBTg8YN5lTe7wpDecfVHYcQtpAFkkmkSldd5q7QMlDPx2W9DT+b61k
         MI9Rmto6ZyiJLW12yYh3Rr5WM9szZHVe4+fa8yP3GpxPZr/DAXhryPIkwE3Ka6lKyIKR
         xk6GLPiiIdi/o89MoyNPEe49qiegRE2mnMAlZBt2BpMzkRy4gNbAAuI7MTV2wAvwoxN6
         dxrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788253065; x=1788857865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g6gNF1L2W2DbFnprEAmekbeKiRyxpCj5ws+3FN1RDWk=;
        b=WBvY0TJy3F9EGmwBcQU9dZBHBjGbDQtVAn7WMWHCZ72hv0T15QQeJU1b6/6NREfqy+
         wZiLIOmL91i2J7dH2W3WOebdrH39ZOqENXLIcJsaHRAOOZWK9u41AgE9l0CKJF41gb6z
         SBIvjn2LPcOoXfclZ6uahYbxvDnvxTV22+NHgsUTZgitnEFJ88mxtMFGj3D2S7WTXeVF
         +k3CLIP1wvLmp8Sv5LNcp5QCCe0OcJlggybM5A/J62ShkQdp+pTc6jjxVITGPVAXW1dX
         fI75WRX1vyOU0oewoVoiTb5/mGJJg1EX/vsmdMnSilhiSmgJz5DwjnP8XWsaI6X8Cj1g
         +eIA==
X-Forwarded-Encrypted: i=1; AHgh+RrtH3R9MVnPjhVHd3JTjC92BNnxV1K1bCIkHe1NQXMESxWgpwlc4aHLrkgdV2JELy6nmCDOeDCzYg==@kvack.org
X-Gm-Message-State: AFuF++mYG1cyvpXJE9x9XyotXg5lusr+Tyfm9Pd1SfQe7kvyzPJN769d
	rLC+aMLVXHTcXAF5dbwwEc9lYlfO/SgIKS9eA61eJMOMKBtj7PdNahy4
X-Gm-Gg: AR+sD10V3/TyfammmWDL206DiJtxvLzGu2q6r71LYu8D986zDnJlHPaS913WUyn8pYe
	V0GOWKUnjxMZ68Y13EtwZqW+MZGE5NM1rNVRyiIkoHMeCQ2/KPQ3vR6arQqD+1mvxjtb3v1UwxC
	GT7k8lRWRyVrvBbD//a5ha+/OcNopNaV4oBlY8hDD+8UbveJum41+uiJliTCd2RSoVd9NUvMmhA
	TEWxlKeksOm208kFXWn+UV4MZc311IDs3a/8b4t3iDNKdUyBWeJ7CkGHfWaMovS0XOQrGmA/sS0
	fl+mGveo7jnmu12ukA5+C7yViyzTMxUoFksZ4aObpppruSOj8STPRGmGOa8W2k5TCIFwmYHpqvh
	SSXLlJwxZF0W7cN/xPB4xLsppHn17hpgcsDvSPF+V+7VvhQxGpZoD8ccxq05B2pjKBH4/+0IrCL
	gNWpqdFxe+hkdGz7Cwr3YXbjX/qI44WVUE21uP1b322SlWaqXPpzl6KZNdAeQ1+pjaUrOHQOz6H
	/aDmmZaOXciQMs0HenCHelX6EPD0JFR40TqB/fMVZN/bAkaJC6UrsRH2o8uEEqBPir9CVpgNBDs
	o95vJnNFrc4vly4Sb3kBiUG29wSmAEPzJTtZR4zSDuzeYN1MJC6On7tdYScaD2x5h+g=
X-Received: by 2002:a05:600c:4f8b:b0:49a:2c4b:403f with SMTP id 5b1f17b1804b1-49b91c46494mr428394385e9.13.1788253065376;
        Tue, 01 Sep 2026 01:57:45 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a16a-7801-fd8c-4b37-36b4-e53a.310.pool.telefonica.de. [2a02:3100:a16a:7801:fd8c:4b37:36b4:e53a])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdd73f7a4sm45023365e9.12.2026.09.01.01.57.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 01 Sep 2026 01:57:44 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Russell King <linux@armlinux.org.uk>,
	linux-arm-kernel@lists.infradead.org
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] ARM: mm: align hugetlb mappings to the huge page size
Date: Tue,  1 Sep 2026 10:57:40 +0200
Message-Id: <20260901085740.66283-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D555B1A0003
X-Stat-Signature: fkkcd4wtrfc843w1ab6rj9iekgwucx44
X-Rspam-User: 
X-HE-Tag: 1788253066-642145
X-HE-Meta: U2FsdGVkX1/RiiQeSlDpCFEpYBt0Qe1Pnv7vndz0tUxdwB+8rGPa0oxxPw02HPnmn0j/eGW73OuktXs5EDlAzbqVvBCJiDfzwKSW4zwvxU/Wge0s4XN1oncds6k3mVxUxnDLE7jAEZ05dGyTpVdF+l4KgdZNq8ZJgN5oFLaHbY30jmF3axG2hpi2fm+ejvK60uO5boXHJnRGAGNsb3z9Ekk8JQ2Aku8d/BHJGRj7PC1U0o+GL8ebzBfrWOqrou+B0+k15RsD34TJi4cPiDEeuSDYJR4xA6Io52OTrPeb7J+nUtO0lqiDoz3ADkW7FzhDKX2zOiSieryrHHxo0LjrHfocNIbKud2rJ0YJR8a1vSJmbTUBpFqLnS4+9tO7L0wmIqTh9C7yHhshPE7KexJHkDsmIn9+7nSIn4rxB476affW75G/s2GDJpsAdLxy6N+x5Nub4KQbqzPibwlH1ePmtmn9JZU2C5k0iFS6vjpRyz/SYBnoXVVXEAxS4xTnY3+gDLHZokPa3JW7L0yClB1B36dTc6NhxFGEFkgNDOtzpa04nW4oVdTnYdDmjXdZwDDo6ho85yveNS/B1S+tpiJ6TH2kxdzpL3zxZWC/Mfn/vvjYPM41c2UKhHxCWZ7B+ZtFFII5LUNqGPCgrjT0kE0NDlV4VAGmZfzm59bSJVdBuRzv//1wFHxSuzWnhONq1ztBw1wHPqW1dXsi1f9SfplQgX1vlhxNFezn3JNTDAaQNSOVRSncJnlrN+SA1t6FjsQTq0vIdxm5pdQLemtkAQwMzeU3SpodQtT5HY8KfVuTltXTvbMJ6llk80Jy7YfZjTpXifuZ5PMTOB5/7pvMOm+IHRLCOUVK6OMyTTk6voxNYJg0QtOONEhT97rjwr8zqojIAaqjOHFCj9sF79BwVo8KUnD9R0EkZKQGuUt4RkyvOyGbc0bqOvdFv+irH7fFFyEzLne1EHxO0j3SSeaIhtq
 WPC2NT/N
 snzXYPT6XJgZxHmepJBdv2cgOnJzFuUc5jJVaSFJlDtepw2lQJQnUPkTR6Xse/tiqszY0lrrz5h/MJPlM7SO911ztc6J43k8YLaIf/LbnGvg9oTfGphE369sugP1Eppj1iDtm7DUKAL3a+Q6UbGt/QG6Wb5cZ61kxTV37qpVVc59VDTeTb7QK300lHVfOEgCR8On+VCtIzIE8hZIUbxQ8WDEiXLwi9GTls3ITr4vo4wICY/96ECQiErxJXSnS0ea4dPk5TyWJEWE7ZobBe/+fI++7R+D7aZT1axbyQKWn0PuEAm4/w8hOmsuBsqa9Dh5/S+G7v+LMLSCVH3SppJ42St4MMnUCM5p6Nu/X9bbpjBOIFxm276c4t4ye72rcrO9XOtB1RP7REZM2/OPvRomFRUxcfgXcg9hqHKWZROKMoNuJIlEe2JIWtGVuzRN0sIenkqvn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mmap(MAP_HUGETLB) on 32-bit Arm can return an address which is not
aligned to the huge page size. In a QEMU virt guest, unmapping the VMA
then hits the alignment check in __unmap_hugepage_range():

  kernel BUG at mm/hugetlb.c:5213!
  Internal error: Oops - BUG: 0 [#1] SMP ARM
  PC is at __unmap_hugepage_range+0x540/0x584
  LR is at __zap_vma_range+0x13a0/0x1410

Commit 7bd3f1e1a9ae ("mm: make hugetlb mappings go through
mm_get_unmapped_area_vmflags") made hugetlb mappings use the
architecture's arch_get_unmapped_area(). The generic implementations
handle hugetlb alignment, but the Arm implementations only account for
the optional SHMLBA cache-colouring constraint. A 4 KiB-page kernel can
therefore align the mapping to 4 KiB or 16 KiB instead of the required
2 MiB.

Set the alignment mask from the file's hstate for hugetlb mappings in
both Arm implementations. Huge-page alignment also satisfies the
SHMLBA constraint.

Fixes: 7bd3f1e1a9ae ("mm: make hugetlb mappings go through mm_get_unmapped_area_vmflags")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
Tested an LPAE multi_v7_defconfig kernel on QEMU virt with
-cpu max,aarch64=off and -cpu cortex-a15, using both the default and
legacy VA layouts. The LTP hugemmap01/04/05/06, hugefork01/02,
hugeshmat01, hugeshmget01, and hugefallocate01 tests gave 16 TPASS and
no failures on either CPU model.

Also tested on a Raspberry Pi 400. The unpatched kernel returned a
misaligned address and became unresponsive while touching the mapping.
The patched kernel returned an aligned address, touched the full mapping,
and unmapped it cleanly.

 arch/arm/mm/mmap.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mm/mmap.c b/arch/arm/mm/mmap.c
index 3dbb383c26d54..dbb3f07a77852 100644
--- a/arch/arm/mm/mmap.c
+++ b/arch/arm/mm/mmap.c
@@ -11,6 +11,7 @@
 #include <linux/io.h>
 #include <linux/personality.h>
 #include <linux/random.h>
+#include <linux/hugetlb.h>
 #include <asm/cachetype.h>
 
 #define COLOUR_ALIGN(addr,pgoff)		\
@@ -72,7 +73,10 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.length = len;
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
-	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
@@ -123,7 +127,10 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.length = len;
 	info.low_limit = FIRST_USER_ADDRESS;
 	info.high_limit = mm->mmap_base;
-	info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	if (filp && is_file_hugepages(filp))
+		info.align_mask = huge_page_mask_align(filp);
+	else
+		info.align_mask = do_align ? (PAGE_MASK & (SHMLBA - 1)) : 0;
 	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
base-commit: abdf623ddb75b24659018d3952d8f61937306ae5
-- 
2.53.0

