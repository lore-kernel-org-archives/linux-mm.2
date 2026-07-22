Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC0DC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 999206B0098; Wed, 22 Jul 2026 10:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970D86B0099; Wed, 22 Jul 2026 10:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8AD436B009D; Wed, 22 Jul 2026 10:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4946B0098
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:29:51 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA2341A0196
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:29:50 +0000 (UTC)
X-FDA: 85016646540.26.C1779E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 286FD1A0006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:29:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LY4eNAqr;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784730589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=esJeQ+cJSuPNZsNqpZn5ORmD35v/TLq1sUVvQsnafD4=;
	b=czGHnK/xGafZx27XIKize9Otlg/IiDe3X7mIgqLjbKF20MWqjBMEQxV7UCtx0+v5NxlGXK
	oZxtSs4POUfonNzagkfxjaYn3OvVeO5NY//dVigjt/V9jh9e6jkaL2JVFHJwW+a2jtzEKH
	9OsUoxqTTzZpHlah1PwKAp8iH6oWZzA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LY4eNAqr;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784730589;
	b=TWvzZ0dLmQXXSzlG1H2e84HIryYf8TlvOpxlf7l9Tzg3RzbIXghx7HgqTNKCwSLw3LWjuw
	BOLdgWeBh9M/Y9K/9Mhp+ZudzkOOTSB50ACCodumJKBUC9XSPScfByAmjj7CHOFbsXBSL8
	KivwKeumwlnMTnAUhaQnNkSb7ttardQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 18DFD1595;
	Wed, 22 Jul 2026 07:29:44 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2591C3F59E;
	Wed, 22 Jul 2026 07:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784730588; bh=Y2eo83WQ5KXIWQ4HG9NgyTmnBmpnXEbXS51MTrxNjeo=;
	h=From:To:Cc:Subject:Date:From;
	b=LY4eNAqrFUtIkbYvUFZ5nAL4UyFumbz1yIdqCVGw5Upbu9b+vxRPcMREjKqhyp1gY
	 4idufJUVCGrnai65nN2cagm/x+5cXN09qdPaTwzqgHdCoY41juiBBxe+XvGFZSzFB9
	 WB5Lr319cDa9ePsfBeTDrpAmbyfApF7V271BuDSs=
From: Dev Jain <dev.jain@arm.com>
To: kees@kernel.org,
	akpm@linux-foundation.org
Cc: Dev Jain <dev.jain@arm.com>,
	gustavoars@kernel.org,
	linux-hardening@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org,
	urezki@gmail.com
Subject: [PATCH] mm/usercopy: harden bounds checking for vmalloc allocations
Date: Wed, 22 Jul 2026 14:29:35 +0000
Message-ID: <20260722142936.3287702-1-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 286FD1A0006
X-Rspamd-Server: rspam01
X-Stat-Signature: 3eztc47rszr3o6w1334pg7gnxcra6wxj
X-HE-Tag: 1784730588-264289
X-HE-Meta: U2FsdGVkX18Qk0OITS+9g9Sna1LmWu8RE248qbSqgVDGbT2Lji733AixB8oqxqjPfyhWdFOdDvk84BSMvJXBAxuwzV0u3+IDG53txXlJrM092cp16tqr36kRJEd7Ydrvs7v80K65swMItGIdeG+5JiPqgSdq4rzQPG3ghs/jmvAZ0u5skfPYXx+QyvCZ42dXqkxhBDOpE1FVM2kRFdljM5aMEjQTG0r3fJDDjmhcqbqk60W/G8XoEKvGY4h9xv+1rESeeyrqNuaiZfmwR8BGdX54dK8zMUXsH0mAWlXcna0zaU89V539ZMUleMfdj4g6cUlSA6Tou7TDqM6xbA9jzlscM93kpL5VWTnkC4GM1fHwpsekT0dlkar770ASlr7FkIs+QFdLGlFosFUCKjZ4EoyobB6JVOHTxziCO8QImbI7uw7JjK3fJ4yJthDqca0bLkPYr5wn6aTQF3DBQ+XBstTNvcAQ6ozui0FT0xCGTl7+l3M+5fKVVXrSHLe6/lBh03sa1HffE2KIL9s9ovwLIX+4eSDglORPh+qIFXGFTSZPWLBYPRtA9BXg73DCu8F4MaZY21t+IJKK/lO9PxXhoY2zqieCW0wnonCGnemeIw7/lvtlZywW9dqEQlu7fzLboPvtXjVfA0j5VIbP0ZCnIeFehdnR0cYeaKtFN/DZ9SYNwgFhMqBV1v1LvxWQ64TUvCsdAWD7vQFZ7EjzeAsHFGWI1M/07KsLEppwDEFgkclqVGHeHO02bQulNbankw7L4J5E+2Nmks+4QXC8f7bWUMNcSdPXF+S0GyD5VjOai7WkuFrBlppabEIRXp6XDGXtQAmY0o/BYqso6di6ILJt43DtYdm2aNzT7LU/YKx72bHNvVfvxdigGOdzhpKKVmTAihU0COYNdbwvECAtOliDl5m8EacC6YppAGi+dvZtVhhAWdKm4VFVR7TT8d3xPqwSMjZGMVEqG73aupgdG0v
 WaBRlDFG
 eJEMCe5zkqZYlNtlV/Cu/pG/5AfayyiubO9zKqxLH5c3zPZDlO/nc21CI/6lqOtuv2iF1krW2TsboD1Q4QHv8WB5VdtUh1prMPnI4kOMGtvybUnhj+5pkle5CeVlFSM5lnimwaTLanxtCsV4/hUQVcohHMz17SVWokmFYLNorccDbrNTS6AHKBZzAmpE0WWEwuSlajuDvDSeNxp9LKhj9PGD/MzjHC7NH16FmptHnd2KHDftXbcClUDnnXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vmalloc allocator stores the actual allocation size inside the
vm_struct structure. We can use this bound in usercopy instead of the
page-aligned va_end to catch usercopy beyond the actual allocation size.

For vmap, the requested_size field is always page-aligned since it maps a
certain number of pages. Same for vm_map_ram (alongwith, not even having
a vm_struct). So the check is only relevant for vmalloc mappings.

Because there are early vm areas registered even before vmalloc_init,
requested_size may be zero. So also check whether the requested_size
is set.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
Applies on mm-new (3d18f3499c48).

 mm/usercopy.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 5de7a518b1b1c..772681aff8477 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -176,10 +176,28 @@ static inline void check_heap_object(const void *ptr, unsigned long n,
 
 	if (is_vmalloc_addr(ptr) && !pagefault_disabled()) {
 		struct vmap_area *area = find_vmap_area(addr);
+		struct vm_struct *vm;
 
 		if (!area)
 			usercopy_abort("vmalloc", "no area", to_user, 0, n);
 
+		vm = area->vm;
+		/*
+		 * Mappings with a vm_struct track the originally requested
+		 * size. Check against that rather than the page-rounded
+		 * vmap_area->va_end so copies cannot reach vmalloc tail
+		 * padding. vmap mappings are always page aligned.
+		 */
+		if (vm && (vm->flags & VM_ALLOC) && vm->requested_size) {
+			unsigned long size = vm->requested_size;
+
+			offset = addr - area->va_start;
+			if (offset > size || n > size - offset)
+				usercopy_abort("vmalloc", NULL, to_user,
+					       offset, n);
+			return;
+		}
+
 		if (n > area->va_end - addr) {
 			offset = addr - area->va_start;
 			usercopy_abort("vmalloc", NULL, to_user, offset, n);
-- 
2.43.0


