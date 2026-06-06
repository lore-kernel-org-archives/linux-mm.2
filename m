Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA6F5CD6E55
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C4306B009B; Fri,  5 Jun 2026 23:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3747D6B009D; Fri,  5 Jun 2026 23:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A05F6B009E; Fri,  5 Jun 2026 23:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 028C76B009B
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3192140364
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:55 +0000 (UTC)
X-FDA: 84848111670.07.C464251
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id A37BE100002
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALVKPqha;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xJrDAWN+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALVKPqha;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xJrDAWN+;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717853;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KR/vS1wU8YZ9Cn0li+AjQl/MlIm/5L0WY4IzBi/9Y3U=;
	b=aCBDdolROfwClbANHC68a6gIMmsPJErjFKb6TObwFbmF2fZMsAGpoRLid3K5F0gZlCi1sg
	a8DSS83bTSfPwinvASKNyi29RnoDix8yLs6tLuEr47/3ysREDyW7oogYcpDhQEiZ5wEhje
	2Xgf10w29l0TKPyyYJbmBIEtZ+d+/mM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALVKPqha;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xJrDAWN+;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ALVKPqha;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=xJrDAWN+;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717853;
	b=A9pa9dDX2GOJqebHbV+sXiL83k7gYNdRCiY/o6l4t8f4uTcozX194mz05D5ujxJVcwaf/v
	eowae1/gq36UrLFICnNo0bgtCPdazjnEyt6+t9F2sN06sdyRQcWBUVsOs2ZPS8ADjv3H5A
	yfcc3rPJrFhQ51cLI9ciqBDykXCMgr8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 055546B372;
	Sat,  6 Jun 2026 03:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KR/vS1wU8YZ9Cn0li+AjQl/MlIm/5L0WY4IzBi/9Y3U=;
	b=ALVKPqhaMIBib2qf0eYqvFVIg+Nr/q5aX1ue7FJ3MazH6zs7U5rXaZUCbGq0z1DosX5t4A
	Jkj9FG71I23T0djwbsf1g8ZlHWIVnPGzQJSPUdy84TSnVggwPqs9IAnudlRS01IUCxG4l+
	OAIJ5l9+idhx72y0fl5r2DNvlWbiP2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KR/vS1wU8YZ9Cn0li+AjQl/MlIm/5L0WY4IzBi/9Y3U=;
	b=xJrDAWN+Ct78ffniZWVhS6NSe/XrBJChDAuyXCZcg2uG8kGQhkZVoNT90uCUmvx+oVCUz4
	4LtsqPOiy+2k/1BA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KR/vS1wU8YZ9Cn0li+AjQl/MlIm/5L0WY4IzBi/9Y3U=;
	b=ALVKPqhaMIBib2qf0eYqvFVIg+Nr/q5aX1ue7FJ3MazH6zs7U5rXaZUCbGq0z1DosX5t4A
	Jkj9FG71I23T0djwbsf1g8ZlHWIVnPGzQJSPUdy84TSnVggwPqs9IAnudlRS01IUCxG4l+
	OAIJ5l9+idhx72y0fl5r2DNvlWbiP2U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KR/vS1wU8YZ9Cn0li+AjQl/MlIm/5L0WY4IzBi/9Y3U=;
	b=xJrDAWN+Ct78ffniZWVhS6NSe/XrBJChDAuyXCZcg2uG8kGQhkZVoNT90uCUmvx+oVCUz4
	4LtsqPOiy+2k/1BA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27384779A9;
	Sat,  6 Jun 2026 03:50:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GH/VBg6ZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:38 +0000
From: Oscar Salvador <osalvador@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Karsten Desler <kdesler@soohrt.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Oscar Salvador <osalvador@suse.de>
Subject: [PATCH 6/8] arch/sparc64: Stop special-casing hugetlb mappings in arch_get_unmapped_area
Date: Sat,  6 Jun 2026 05:50:01 +0200
Message-ID: <20260606035003.529685-7-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A37BE100002
X-Stat-Signature: q4gkbrsxaq1dusk4nzikafa819wxswrf
X-HE-Tag: 1780717853-110553
X-HE-Meta: U2FsdGVkX18AczIToR0OeemsOA/yy0VKDx9JWd4TXe2c8sQEeLwbudjlWHOZ4yrIzg0KaTASBVnhtJzw9wG/Xf5bKu1CNgX0g1GD3Ei74zIGgzthwwCImLByUIgD19Iak5M8JbciOSCwElPcs+Y8C+XmcGbTXDSMzF4cLtJtvqP5S0Md3Nr92ybwzovPno4G8FjObG8727XT9EvWv6L9fhGRjaqe5s6N179fkWBVh8BuzTIrlwClnoIx64PZT80GlGGv79NkE9tIEHKNNv/5FipRPhPjbxySFQDix43+DiSDNKMcWiQ2FHVFM1DtbrvblHYRReVBf4rHYzaqyEI2cWrh/qyDtv1D3PYPBWhh6etXej/hQchvCihHJREG4QfFNn9j0taGaGE/QA8BboYjkyFJuh6YfEZ9+b0cko4uQzEX7lBuy9Rv7Fh7incHq3b8BR0PImnhUBFNSwDgWgl8gzZhJlKOoo1BXAYj5yxF231MzxxQJNJM23rHL5hsQatz3fFDt9jAO/ySHDm+TAm5PLsLu9MM4koj62Ea4SF3KE+6LkBX9g0Q9UPZ70cUKjLCO5tkzCeEdSB3yuVVOaTQ67R9YVziu4JwJ9IRHnooCB0WltP/07YluAQr8ItwXeUBLquUiMkSJEF4bMJgWHSel+tjxxgJluVW9Jz9ED7HhNLGpSjbt+WoKQWeH8ulXIg3ZrwhbcUCIKOqyga78deUYs1htvbG2mHzbLZrwN9zfh4q6X6LoSnN8DDTh8/e/xxVt+LN7HWxIwa2aZf5wY9PepYnC4yn6U2rQnzHPt3iVd+MxLmE+N0v4BNl5soF0cBSacn9QQl7ITnIAmjUSjS3uaw7lYOOgQ7V8VeHWvlhPZ/Bw90M4TI4RI47udDdlvFSuaXIH2JzLy3j36cMjbLt6QmHSPBjl00TzzSpkymm6PGa/yDZryXa8fB9ltL4RkLv0+J87SPH/rNHyipOLs2
 zsRrXqLs
 6xnPUw/GcyjiLe6pwKsobk008U6R6yT4qveyeILuA7+yT3IiSHz/RD5i96ia0muKB1cituob2IILB5k6etSEfETua5GQPn2ZoAtnLu4rVtzgZfBqe/y6zs630EIXzkks8uGz5cxpOImc1WLLVym6xOFNLScyj2v7vsVfwZ9sCPHxjY4WSEOGTSAW4WGN7PprDQJo8rH7gywiNvWQg1TgmFWDYmAm5G0NZCsyBpCs+PtXwRztCy15sZp2otFIBZoqyReIuT9dPj9qXRjQV4SFzqSuNTpLNLC+gMk7lPezSsh2DP98HKFN5Yc8aCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_get_unmapped_area* sets info.align_mask to make room for extra alignment,
so that is added on top of the length we request in unmapped_area{_topdown}.
hugetlb_get_unmapped_area() already adds this extra padding in the 'len'
parameter, and it also masks off the address it gets to properly align it to
the huge_page_size we are using.

So, stop special-casing hugetlb in arch_get_unmapped_area* functions.

Also, there is no need to worry about align_offset because that will be
masked off back in hugetlb_get_unmapped_area().

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/sparc/kernel/sys_sparc_64.c | 25 ++++++-------------------
 1 file changed, 6 insertions(+), 19 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ecefcffcf7b1..6823162befa0 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -30,7 +30,6 @@
 #include <linux/context_tracking.h>
 #include <linux/timex.h>
 #include <linux/uaccess.h>
-#include <linux/hugetlb.h>
 
 #include <asm/utrap.h>
 #include <asm/unistd.h>
@@ -90,8 +89,6 @@ static inline unsigned long COLOR_ALIGN(unsigned long addr,
 
 static unsigned long get_align_mask(struct file *filp, unsigned long flags)
 {
-	if (filp && is_file_hugepages(filp))
-		return huge_page_mask_align(filp);
 	if (filp || (flags & MAP_SHARED))
 		return PAGE_MASK & (SHMLBA - 1);
 
@@ -105,16 +102,12 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	unsigned long task_size = TASK_SIZE;
 	int do_color_align;
 	struct vm_unmapped_area_info info = {};
-	bool file_hugepage = false;
-
-	if (filp && is_file_hugepages(filp))
-		file_hugepage = true;
 
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if (!file_hugepage && (flags & MAP_SHARED) &&
+		if ((flags & MAP_SHARED) &&
 		    ((addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1)))
 			return -EINVAL;
 		return addr;
@@ -126,7 +119,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 		return -ENOMEM;
 
 	do_color_align = 0;
-	if ((filp || (flags & MAP_SHARED)) && !file_hugepage)
+	if ((filp || (flags & MAP_SHARED)))
 		do_color_align = 1;
 
 	if (addr) {
@@ -145,8 +138,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	info.low_limit = TASK_UNMAPPED_BASE;
 	info.high_limit = min(task_size, VA_EXCLUDE_START);
 	info.align_mask = get_align_mask(filp, flags);
-	if (!file_hugepage)
-		info.align_offset = pgoff << PAGE_SHIFT;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
 	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
@@ -170,19 +162,15 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	unsigned long addr = addr0;
 	int do_color_align;
 	struct vm_unmapped_area_info info = {};
-	bool file_hugepage = false;
 
 	/* This should only ever run for 32-bit processes.  */
 	BUG_ON(!test_thread_flag(TIF_32BIT));
 
-	if (filp && is_file_hugepages(filp))
-		file_hugepage = true;
-
 	if (flags & MAP_FIXED) {
 		/* We do not accept a shared mapping if it would violate
 		 * cache aliasing constraints.
 		 */
-		if (!file_hugepage && (flags & MAP_SHARED) &&
+		if ((flags & MAP_SHARED) &&
 		    ((addr - (pgoff << PAGE_SHIFT)) & (SHMLBA - 1)))
 			return -EINVAL;
 		return addr;
@@ -192,7 +180,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 		return -ENOMEM;
 
 	do_color_align = 0;
-	if ((filp || (flags & MAP_SHARED)) && !file_hugepage)
+	if ((filp || (flags & MAP_SHARED)))
 		do_color_align = 1;
 
 	/* requesting a specific address */
@@ -213,8 +201,7 @@ arch_get_unmapped_area_topdown(struct file *filp, const unsigned long addr0,
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = get_align_mask(filp, flags);
-	if (!file_hugepage)
-		info.align_offset = pgoff << PAGE_SHIFT;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
 	/*
-- 
2.35.3


