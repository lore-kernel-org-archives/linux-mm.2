Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2CDECD6E75
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76686B0092; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C27086B0093; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3DDC6B0096; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C49D6B0092
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F25B8D4CF
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:43 +0000 (UTC)
X-FDA: 84848111166.14.67FE4A4
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2DD75C0004
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PKsog34T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XQSlqUll;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PKsog34T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XQSlqUll;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7KYi+xJrKG6IlHxcjmqGNj5lOE1J1MuLSqZzzDJwbQ=;
	b=yFaZQxKGSpyD4AlYZRb7ZaeRsFtqjS1rLfyKghjE3heJN3DNYM0Q2xaeprUxNpyMCrO5uL
	HQ59mHbz59T4YGXBekfkK3LLqTty8ammW4khcMZmmOvzrxgH+EFyvAtuHwXMrYvfIhR2mi
	oVTMhW4GZcXfAL0+8jm+NNfcKmsNkcU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PKsog34T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XQSlqUll;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=PKsog34T;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=XQSlqUll;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717841;
	b=UUhzm7eOPOLy2UzVvv3f7x1HJtIjekdI7RHGgSMOHizCJNEj5Lpg4H0QBxxuU3fafQN+ll
	bpJCKYt7L0UYhsWXqs1gyuBZEJYja1vGhVk0DdEw03YKTbV7v/IINZUH142JVIJ+3bnyAF
	leYu5+zswODe1tOSDh4KmNABgfbZxdU=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27D186B36A;
	Sat,  6 Jun 2026 03:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7KYi+xJrKG6IlHxcjmqGNj5lOE1J1MuLSqZzzDJwbQ=;
	b=PKsog34TpY2vp0upg/yQgvVTmVOGXS+D4/iaIGKgE1ksMzqcbrIue9Oh79IhCPlsPHv0g3
	/O7W0VKLKv8pauzrGt6GCaiuHZmrzPi2P+4zql/2zb2DId9M0aj5Dcmrymp8e2lzQyvUeO
	/fw+Efuko7/0eMv2dtuV9+jSjyVO2f0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7KYi+xJrKG6IlHxcjmqGNj5lOE1J1MuLSqZzzDJwbQ=;
	b=XQSlqUllUSQSO/gq0Gc9HAvCbFtmVBChS5wVdogZmusrYW3SVHR/MUt5TrVAmTgNk41tGM
	nTaHdfNGEqXfEjDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717836; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7KYi+xJrKG6IlHxcjmqGNj5lOE1J1MuLSqZzzDJwbQ=;
	b=PKsog34TpY2vp0upg/yQgvVTmVOGXS+D4/iaIGKgE1ksMzqcbrIue9Oh79IhCPlsPHv0g3
	/O7W0VKLKv8pauzrGt6GCaiuHZmrzPi2P+4zql/2zb2DId9M0aj5Dcmrymp8e2lzQyvUeO
	/fw+Efuko7/0eMv2dtuV9+jSjyVO2f0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717836;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d7KYi+xJrKG6IlHxcjmqGNj5lOE1J1MuLSqZzzDJwbQ=;
	b=XQSlqUllUSQSO/gq0Gc9HAvCbFtmVBChS5wVdogZmusrYW3SVHR/MUt5TrVAmTgNk41tGM
	nTaHdfNGEqXfEjDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4316E779A7;
	Sat,  6 Jun 2026 03:50:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id MMt0DQuZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:35 +0000
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
Subject: [PATCH 3/8] arch/x86: Stop special-casing hugetlb mappings in arch_get_unmapped_area
Date: Sat,  6 Jun 2026 05:49:58 +0200
Message-ID: <20260606035003.529685-4-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ty4ikc14d55cdcfj3mood87xbwsmchox
X-Rspamd-Queue-Id: 2DD75C0004
X-HE-Tag: 1780717841-868164
X-HE-Meta: U2FsdGVkX19P251xWKQKizKxQqbxPMDHXFTYSLYpeaGsdwWIztTYD57/0eeP5AgXV9k1oYp9u5q+FbVyJgqdRVhA7Cy2XhZrjQEjda90QtMOnxKsBIo5KXPzy/3zUQ+R+6vqVG2tFAeppg349lYALyisXvXg6lsedF8dzrFpS9IHW2wHn9lore21c8uhvZLM0fiT7pXTQ3E5P1h0pmEIKDF+2+ZqIGoYCtuiwhOQjJRIG45LZ1Orq3Xhp7vHeUJTfFGIJsNsH53ICnRrHRwzJWudJx3RhVuF8IVIfwidWOAOvfr0QU+buyPFI4zqrupK76SscWdWwvLBOvNEWNqhUXTvBK/snxpgbswYeyZa9U0IURQN2RMJJ0rSP/AJ2emVZuSah76AV7qFY8e5bqz4HVYhK6cpr4RRyE0yDnK3ttPkXwejR4HwkVC2Zx0lVkIGLhU0Fcdo8WwHTkLO9wy5nD6A4/Dl9FqYi/lU/USCFZEJnuLvbVPNWsuQK1Eq6zYfMZp/DMKAqW5X3iqKNdiqWlY0HKFufNhbTF7CjuUAkXawnUZH8xUnxMH+7ZLooC4HxjS8Nbx/yZ/bZVB7ozWcqwbKTB3VRP3XAR3heSh7Rns1MSSFZoEvtKPFD5g9dFHMQBVdP9RbLKE8wMke2usQx/nzN7Ra6oKDLDObgECqJWCO9QUKUHu0a3k9qXpAt1M0YAHm5urbx8bnGob4nMKjaD0ehX49KQsd3QbuTq4Geu9sBF8bVVTWSEBJ4dPo2lhaU8TEYSdS9cFdH2eGFKBCmiyO4Dt6rHtVk7gq0Hd/1r/KSq1LjnVG7QjV/Frg8sb99ZuTILIqur3H8WsaQl9I3886H+n5/VgiBtVhonfr0GYjhl+/q1t8giA28HYrJ9q0VM7oF3dObbg4eV7raZrz/44ZcGUlXwS5aOVw1XgyOG55P0zq7XpisgRF/qK8tFeQH81IlnZf0b4W5EcEWyz
 MznAUpnn
 6Z/2Cu69dCPAec6aA7B1lxdk6Pl01dbAT3lBenyUeVcHI082NkXggrekSJyf3S+R1n3dijGMMCOeJDXzJUOGb953+ICN4WAmVgMtG2GoTIY4AUq6TaRgH4CYbCvqweYsfC7nrOd6BGrSM33d91JSJG9Y2x7HyvIF6XApzblTojjj1vq5NhUEgCiUPaV4qSImGdDE3hYD0eKOMPiVtFpOrqL2Jj4n1ime5X00s+8mN/8a4DcOsMzgG2hdnK9ILyfOXihkKiqm0R49Wc4Ym876l6aCHv/N2HUD3WsDHTQR5Ub7VPVZ5y88Me4HueA==
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

Also, there is no need to worry about align_offset and start_gap because
the former will be masked off back in hugetlb_get_unmapped_area() and
the latter only applies to mappings created via vm_mmap_shadow_stack() which
do not involve hugetlb.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/x86/kernel/sys_x86_64.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/sys_x86_64.c b/arch/x86/kernel/sys_x86_64.c
index 776ae6fa7f2d..1cf2dafd223b 100644
--- a/arch/x86/kernel/sys_x86_64.c
+++ b/arch/x86/kernel/sys_x86_64.c
@@ -18,7 +18,6 @@
 #include <linux/random.h>
 #include <linux/uaccess.h>
 #include <linux/elf.h>
-#include <linux/hugetlb.h>
 
 #include <asm/elf.h>
 #include <asm/ia32.h>
@@ -28,8 +27,6 @@
  */
 static unsigned long get_align_mask(struct file *filp)
 {
-	if (filp && is_file_hugepages(filp))
-		return huge_page_mask_align(filp);
 	/* handle 32- and 64-bit case with a single conditional */
 	if (va_align.flags < 0 || !(va_align.flags & (2 - mmap_is_ia32())))
 		return 0;
@@ -151,10 +148,8 @@ arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len,
 	info.length = len;
 	info.low_limit = begin;
 	info.high_limit = end;
-	if (!(filp && is_file_hugepages(filp))) {
-		info.align_offset = pgoff << PAGE_SHIFT;
-		info.start_gap = stack_guard_placement(vm_flags);
-	}
+	info.align_offset = pgoff << PAGE_SHIFT;
+	info.start_gap = stack_guard_placement(vm_flags);
 	if (filp) {
 		info.align_mask = get_align_mask(filp);
 		info.align_offset += get_align_bits();
@@ -205,10 +200,8 @@ arch_get_unmapped_area_topdown(struct file *filp, unsigned long addr0,
 		info.low_limit = PAGE_SIZE;
 
 	info.high_limit = get_mmap_base(0);
-	if (!(filp && is_file_hugepages(filp))) {
-		info.start_gap = stack_guard_placement(vm_flags);
-		info.align_offset = pgoff << PAGE_SHIFT;
-	}
+	info.start_gap = stack_guard_placement(vm_flags);
+	info.align_offset = pgoff << PAGE_SHIFT;
 
 	/*
 	 * If hint address is above DEFAULT_MAP_WINDOW, look for unmapped area
-- 
2.35.3


