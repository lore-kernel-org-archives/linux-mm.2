Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C334CD6E75
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEDF46B0096; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A77346B0098; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F3396B009B; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 737636B0096
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1DB28A039D
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:49 +0000 (UTC)
X-FDA: 84848111418.17.334D95B
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2C6B580008
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:47 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HeGGMkjR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CQ7A8D37;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HeGGMkjR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CQ7A8D37;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwiYKTL28ZES39WOcBBLGMzPy8yj5CG2CTO54MD2F7M=;
	b=Ms00xKDBMjF/ZYGvIhlxq+VDbNujBnJtBupfElOTMRckPnIKLjzbVIZz3pgr2fsFEtE6h+
	4Mn1kC5mKsrz4T5sqBCRDsQhVXabpCTuVLNZRKA+HFN7s6jFFirBFf8keuaygDpX26uGDT
	Zz9C/3B0/8o1z6dY7/mJ/POCkh8onkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717847;
	b=QieQ0V+D4Prq2FiinJyW12sWysL3HJ1rqvdIxn3A/vNqIYAw3NmMhGJdPIcJ3jk6r+Hv58
	8akD71pWychKD77I2UQSMD8/r0hpUHs2F5LwIqT4vg3C9ASK8YTFPrhjDf3olmjgnEoj8e
	uEoh9jL+lOFMJg2tWItVKBggMEfLvNs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HeGGMkjR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CQ7A8D37;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=HeGGMkjR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CQ7A8D37;
	spf=pass (imf02.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 13CA96B36B;
	Sat,  6 Jun 2026 03:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwiYKTL28ZES39WOcBBLGMzPy8yj5CG2CTO54MD2F7M=;
	b=HeGGMkjR51HA/4VGh6pfRPBl7OfAW2HlguNYRJIYW5oj5nHwRezEEvxp4YfefGDZMTW8J/
	0jzIPj8O1R4TFHofr/ZtJ6WaXX1QFy4/HhMpW4Sz2cF7gYeQKQZ+zAjf70iiRKlIsfJBj3
	TDyJAYmRKOyjo0YaSY0Cgvs9aNpilzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717838;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwiYKTL28ZES39WOcBBLGMzPy8yj5CG2CTO54MD2F7M=;
	b=CQ7A8D37XEYAdmccBNtNoA7sUjxe/UAr+w+gXOUNopGiauAA0XtG8ZLTkdocmQLpdTgzor
	wbhX8R7Z4++K3ICw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717838; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwiYKTL28ZES39WOcBBLGMzPy8yj5CG2CTO54MD2F7M=;
	b=HeGGMkjR51HA/4VGh6pfRPBl7OfAW2HlguNYRJIYW5oj5nHwRezEEvxp4YfefGDZMTW8J/
	0jzIPj8O1R4TFHofr/ZtJ6WaXX1QFy4/HhMpW4Sz2cF7gYeQKQZ+zAjf70iiRKlIsfJBj3
	TDyJAYmRKOyjo0YaSY0Cgvs9aNpilzw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717838;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rwiYKTL28ZES39WOcBBLGMzPy8yj5CG2CTO54MD2F7M=;
	b=CQ7A8D37XEYAdmccBNtNoA7sUjxe/UAr+w+gXOUNopGiauAA0XtG8ZLTkdocmQLpdTgzor
	wbhX8R7Z4++K3ICw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 32715779A7;
	Sat,  6 Jun 2026 03:50:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kNpyCQ2ZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:37 +0000
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
Subject: [PATCH 5/8] arch/loongarch: Stop special-casing hugetlb in arch_get_unmapped_area_common
Date: Sat,  6 Jun 2026 05:50:00 +0200
Message-ID: <20260606035003.529685-6-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2C6B580008
X-Stat-Signature: eoomzfh746jsutwm8af61bjtkq9jkayr
X-HE-Tag: 1780717847-818178
X-HE-Meta: U2FsdGVkX19K5HRzWgpYvmusGrmNMqevtRC6HPQT+hoJbpiHFhTFHdiPbIDbfhCs2cRKUad4OOjG7OHwAcdFaeIjfpBMyRMVzPWkLKmZBygj+NKCm1jYdMOz0e/LAPijUNd8RiBf9N9bloVYJIEJtlPQdpeL4ux91mGtrhHNg5gaDue1eLdLsQ4YujdtYyb9KiVjF4DDGNSxQ1Bttj5KXTR/wjNStHt9nVvSx8SEvnY4Xjmq0o442KfRpP48v2ys9yiZSxIlmVNKUbQQwIs0mIo7R0W/Q2xWZVp02Qgt3PolWtpdUnjxyCKHvn2zlyVu1HB59mf7FkjLppNRGzBGQbjSSMQqtBwddjenx6+e0PPcz2dqKkPUM7VOw1GjaxrMj9w3dAmqgEIOMlGQnzdjnETbeYouTZYdENiA07cv3fEBDP9u8n+gEjXPXNUPzOfI5m9hLSgAJoMaYZ1VEgi+LswD8QXH0i1kpVAUpSdSZWNpE5EoCdW06hLKxSvg++s9EdWcp8Tb2ImKeLgsyB/oaQWtllHTia+MeQZ0dxLm6uTQyBS+jWNbuuv4x/jkmALkuFFnXPIDROs2sBfClWXwOGC/yjKgHz946z5YDoeguAl0UEAU0k4sNrtpGPEDDt5x513IBTWHJgNKhRdTsgypJZ4KDF+Wiw5Fvzffvq69D1JELErfWtmzU2NxT+Q1w2d0zfFypYQ7pMKBexGcbZ8dJ37g4u7gANSFOdFpI8zV6gzpPVL+hTTtYW/Y50l3QfjVcFcBMZAKINFZwVWe0mdMjLAeMsLmfuGe2/ybMCWfJM8eRMIvnSvEzXQi1kAKu6uzQjZKGyOZT7Ga2B5IX3n3S8GDypF1GiOz4ngXyxSE+yFOSakqx7EX0SXKu2wt52o2kjuypaZkhBXHZHv12Crc8hO8PNJKU6Yzivx7Yi8viPNPDvwdGwqADPm8wc5R7qx2e67kJAsMXVAmHaqOSJT
 rItsi+lj
 dI2ZuQq/XaqsG6T3kYd5aBV/mPrQjLu18El1T1pYozQSFR2DQm0F/uC2eVdUY/aKM/Tw0lIafh9/cqHXDYI6R1IgbqjFe4Mu7XbgjUknxVUOY3g42WstaNjXgzoP0iCP4I8seVRGmjk/QRblBIKpoB2nlnt9SFFUXDSTeVBGJdeXNnO6d4RVIpd+oxHxVkxfwiRGy+2pUVXI+Gv2vDeZSrvksXsOt6XbYHiwI57ZSaD4Gj7/RH2k0nnz12WkSjvr5EB1ow109P+9ON+DmMYpig8ZZIOlKV4PUPvdYZtLdvF6hwy0otQMtZYwE7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_get_unmapped_* sets info.align_mask to make room for extra alignment,
so that is added on top of the length we request in unmapped_area{_topdown}.
hugetlb_get_unmapped_area() already adds this extra padding in the 'len'
parameter, and it masks off the address it gets to properly align it to
the huge_page_size we are using.

Stop special-casing hugetlb in arch_get_unmapped_area_common.
The only caveat is that we might get extra align_mask in case we do coloring,
but that should only make us allocate a larger(ish) gap in unmapped_area{_topdown}.

Signed-off-by: Oscar Salvador <osalvador@suse.de>
---
 arch/loongarch/mm/mmap.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/arch/loongarch/mm/mmap.c b/arch/loongarch/mm/mmap.c
index 1df9e99582cc..8f0af181f902 100644
--- a/arch/loongarch/mm/mmap.c
+++ b/arch/loongarch/mm/mmap.c
@@ -3,7 +3,6 @@
  * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
  */
 #include <linux/export.h>
-#include <linux/hugetlb.h>
 #include <linux/io.h>
 #include <linux/kfence.h>
 #include <linux/memblock.h>
@@ -65,10 +64,7 @@ static unsigned long arch_get_unmapped_area_common(struct file *filp,
 
 	info.length = len;
 	info.align_offset = pgoff << PAGE_SHIFT;
-	if (filp && is_file_hugepages(filp))
-		info.align_mask = huge_page_mask_align(filp);
-	else
-		info.align_mask = do_color_align ? (PAGE_MASK & SHM_ALIGN_MASK) : 0;
+	info.align_mask = do_color_align ? (PAGE_MASK & SHM_ALIGN_MASK) : 0;
 
 	if (dir == DOWN) {
 		info.flags = VM_UNMAPPED_AREA_TOPDOWN;
-- 
2.35.3


