Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E769CD6E75
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2D3A6B009D; Fri,  5 Jun 2026 23:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DD8C6B009E; Fri,  5 Jun 2026 23:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3576B009F; Fri,  5 Jun 2026 23:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7F3D76B009D
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:51:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 180E1C1991
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:51:01 +0000 (UTC)
X-FDA: 84848111922.09.C6771ED
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FA7F40004
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gseG4dB3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OMOV4Lui;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=edv1iVWr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3V7xnSAU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=23nljHwZN8InoElJ8nnzrgWbXOooBuedRgi6MNI+VtE=;
	b=Hsxvq+cjV0ywKa7kp9DfxE0HODNaUwvkmAqnOQ4DrYfUtlt4EEq793VHGYjKw+Q88jT4Oy
	yqGIOJiruINu0LECqa1gbqwf8XzpmTb9SltOzP7Ic1MKV+iWlGTer9zdyOx7pBwyOH0xYH
	c+8wdCZtOVXJkMk+OvQC0qIj3fYDaJ8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=gseG4dB3;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=OMOV4Lui;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=edv1iVWr;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3V7xnSAU;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717859;
	b=dGhGJspZpntVwYZsNn+gsUUwslbTD8E8/QnP5MIJFx3rmQaVTrNfjIwsqHFABJk5o6RXPm
	nHQgJoCycPoVxPXjJUqlu0WEPuglBFKYrni+fRv7fjKBi6tghk4J5ThjcUAB0XtPYckuQO
	FTn3GP5R8sAqFv9OM/waPMYAk0KePKA=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id F17946B473;
	Sat,  6 Jun 2026 03:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717840; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23nljHwZN8InoElJ8nnzrgWbXOooBuedRgi6MNI+VtE=;
	b=gseG4dB36reexuERC5kjThl1hLPfxICMguSm57v08kDn3GSJsgjXn6aO+VPL7vw53gkpYI
	EhS7+X9BFc3bYLPTrY73vPfOJW+c5AV4xAwg8sKRzaHKqjZgZPY9XKsokW6T+NqiPyRyvL
	Cm7+3p7WvIhAVxS0LELiHxBl5EKeaJ0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717840;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23nljHwZN8InoElJ8nnzrgWbXOooBuedRgi6MNI+VtE=;
	b=OMOV4LuifaUsuyOe1mNSMBIQgGbBzJNjw3OxTW5Bm1LlXjbGDzu3FaGH3MQVfDzgCnuKv9
	SSAcCj0BaI6NicCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717839; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23nljHwZN8InoElJ8nnzrgWbXOooBuedRgi6MNI+VtE=;
	b=edv1iVWrollF3PtT0lW0v1Ni2xwoABffKHquNwFGE+Qrzu0GqAcqX/pHcPgjkGoyvof0eg
	r/lNmuS34ARydgHq8oDW4PjlwiOqnY7ENzLyDaKtHyu57xDt9Xut1KHYW8rsmDx7tRCox8
	ERkS8stUr5DQS8lLAS1/7uNSZn+PWhc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717839;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=23nljHwZN8InoElJ8nnzrgWbXOooBuedRgi6MNI+VtE=;
	b=3V7xnSAUiH82Mm7d2IpaEP7HgCdLnkRs1iZbF6lRIDlwXchCcFU2sKIgd7sDcjFLSkgDh9
	O9y4lfHCLSXuLWBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 19530779A7;
	Sat,  6 Jun 2026 03:50:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6LZiAw+ZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:39 +0000
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
Subject: [PATCH 7/8] arch/sparc32: Rip out hugetlb from sys_sparc_32.c
Date: Sat,  6 Jun 2026 05:50:02 +0200
Message-ID: <20260606035003.529685-8-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 1FA7F40004
X-Rspam-User: 
X-Stat-Signature: mi5t8ta9xb9szq4m3o1ktg7kfjpqya9h
X-Rspamd-Server: rspam09
X-HE-Tag: 1780717858-646646
X-HE-Meta: U2FsdGVkX18YSg3yhQh8qtExINEXD9InI/m3sslxwREsQLlz3zydnaUbxmRh+MR+9Xvkiz3/OqUMTWXQzaQvrdpgGhAWllU4KxRnwE3JdBlomMYe6yR6ml+llyasyqADhXhTQ1a94ZzZhWucLkdqHswJG1zxZcxovaBRY5WK50EDYFEGeQn9Qkc7UW8PK1wgo2LUumrPOYgqWEmDRlgaujzA8tBd+rhAd5lb/7BfaL8DIcKAcbjKEl2bXG/M/1x7bdc9FbdzVc7VOTFpQld46gdLgkJOCqokwIULy2KJacsK5S59ys3iBdJsPy9eMXBYKtDmNzkm3gXdvNlkNCKAAdnHJoERACOBbe3Biy6ndiZS5eL9Ma7EJAp34VSZggZEKtDPpKHZbyfqHhl7WfnRElYRAcenGWjigHrH8sIKYbaqWiOgdTMfVRVYIC1aPCy+u90B8BIbAgUNQSEMb43Zzi5Sa0yoUy5FE31sZ8LxNL+gS1M0BS4//jtXlTLZWwOPYxfFpVfL+WTOuV8KeE4ZK59w+g8QixkKS2UZoHcc1lXSOijMme8BiiGwf4atLSP/sGeRNbr0r9cmsZL1SuQwailh1hlnd9TSTvtv+MPjt1IEp8BbnZHIx8MJypMMy5n2z32ng01nWh9ybVduzAXeyYAnghHtFJyou86O9uwbfNPCyUPb+y3p6slOdrEXzUinLVNBpgBvUK/bLYlGmYkuT/LvQDlZtodHw2aVoF6N9kQkuc4vMJsfNTV6d2gjPf53bIJie8XtSSMk+thIv6PLmWf7l4DEePugWoYfUCQT7bw3Z0hPh02x1kraFC8GHdhRooGoNlKaDDizwSXtLW9QiJBiZRzOWUHWykURt+Y33HmQKeER25A0988RnkfsXTOFCku+TNLGFMsmiZMejGdvnwUVORVyjgqQMbLw8ikh83SFQTAGs0afKmVcLCF4DR311NTbQttXY5mTq/xkUzI
 Co1uaXSD
 g7EoYUXz406p0vkgg4BPvMX6wTRaTlwsums3gdT0qhn9emF672Kv34py4OGsV5IH6u71J70sRlkYZyI+0clASRFscB9fLrsRiMTcuOrGU1iZKKyf/rtfAI4LQAx82ojgAp3IM7hvmH7pBV4rt2kICiKzzhcfTutn8J5tkeqampFzSWxKSolTj3o6yjzOfNHrG+Qr+5uNRUq+OS5vK4yR6JLnQiLBZ3FpDBGLhLxJ0kkzQFRgIuN9uLAF4EVLj+qv30+dDHZMP1lW5oA2Ckd5hTgiIAMmkDwnrY6OYm5ahhGheLhjnPQhgt0f8Wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ARCH_SUPPORTS_HUGETLBFS is only select for sparc64, so rip out hugetlb-special-casing
from sys_sparc_32.c.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/sparc/kernel/sys_sparc_32.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_32.c b/arch/sparc/kernel/sys_sparc_32.c
index fb31bc0c5b48..960f719b2257 100644
--- a/arch/sparc/kernel/sys_sparc_32.c
+++ b/arch/sparc/kernel/sys_sparc_32.c
@@ -23,7 +23,6 @@
 #include <linux/utsname.h>
 #include <linux/smp.h>
 #include <linux/ipc.h>
-#include <linux/hugetlb.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -43,16 +42,12 @@ SYSCALL_DEFINE0(getpagesize)
 unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsigned long len, unsigned long pgoff, unsigned long flags, vm_flags_t vm_flags)
 {
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
@@ -67,13 +62,8 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	info.length = len;
 	info.low_limit = addr;
 	info.high_limit = TASK_SIZE;
-	if (!file_hugepage) {
-		info.align_mask = (flags & MAP_SHARED) ?
-			(PAGE_MASK & (SHMLBA - 1)) : 0;
-		info.align_offset = pgoff << PAGE_SHIFT;
-	} else {
-		info.align_mask = huge_page_mask_align(filp);
-	}
+	info.align_mask = (flags & MAP_SHARED) ? (PAGE_MASK & (SHMLBA - 1)) : 0;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	return vm_unmapped_area(&info);
 }
 
-- 
2.35.3


