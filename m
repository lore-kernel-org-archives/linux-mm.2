Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5331CCD6E55
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 03:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD6DF6B0098; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16B46B009D; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F826B0099; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82CB86B0098
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:50:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3938B163A65
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:49 +0000 (UTC)
X-FDA: 84848111418.21.254B4FC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 16A52140008
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 03:50:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q4ztDXPB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5S0NlQBz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q4ztDXPB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5S0NlQBz;
	spf=pass (imf23.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780717847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BDlgH9aSqIdzXSD7JG6derrdSKWB6MQxgYZfJ4EGB8s=;
	b=O1s1U1Dt2wcBKLdc4OxfgqqN43TxrOlckCBWmdJzKy34SqshFOdH4kI3/T/FQMqqXtnY8y
	ucFaCvEP2ZUXwXDZAPDBCGiF88nm3Ft2ykZDe80tWtL4cphxirEysLJwFUV8vuFycwZMSY
	fPR1x5TjiKG7E9JzX487U8l3xjvyMMQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q4ztDXPB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5S0NlQBz;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Q4ztDXPB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=5S0NlQBz;
	spf=pass (imf23.hostedemail.com: domain of osalvador@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=osalvador@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780717847;
	b=AJ7zUlz8rk/3HlGIKEDvPCxqx3ouPaJejDS3dGJlvU3kIBghDlMCXcWXvTtjdJ1sRtso7n
	Yu2DNnSzdBXZVDhfX2hvYMJbdyS9R1e8ACWrLNqGEuAhAoTEFrJnvhXynFTIP1dgmd4pdb
	XK/oD6EWFCUludk/uEoTvfj/qKSRpik=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1FFE375BDE;
	Sat,  6 Jun 2026 03:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDlgH9aSqIdzXSD7JG6derrdSKWB6MQxgYZfJ4EGB8s=;
	b=Q4ztDXPBLcaHYm+L8qXSkEdcrF4igvm0r/R9k2NEGWyW4A4L+mktn5MEcPMbhm+0pv+EXf
	pYtPP/3HW2KUEHMsWCT09G8aYwlrckI92Yep2KJz5+D+dBjXC3KU9sgZcDWQxHou2hBeVb
	dnd6o9/zXQ6IjeVVTdARwiku+ZMeF34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDlgH9aSqIdzXSD7JG6derrdSKWB6MQxgYZfJ4EGB8s=;
	b=5S0NlQBzmndHRXaN6jPO4w46liqMQu85bz8rBTtDcHCmDj4jdmvKuiFW+WQXKpJ2KzxbMo
	1TxGecZIdQ+ihpAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1780717837; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDlgH9aSqIdzXSD7JG6derrdSKWB6MQxgYZfJ4EGB8s=;
	b=Q4ztDXPBLcaHYm+L8qXSkEdcrF4igvm0r/R9k2NEGWyW4A4L+mktn5MEcPMbhm+0pv+EXf
	pYtPP/3HW2KUEHMsWCT09G8aYwlrckI92Yep2KJz5+D+dBjXC3KU9sgZcDWQxHou2hBeVb
	dnd6o9/zXQ6IjeVVTdARwiku+ZMeF34=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1780717837;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BDlgH9aSqIdzXSD7JG6derrdSKWB6MQxgYZfJ4EGB8s=;
	b=5S0NlQBzmndHRXaN6jPO4w46liqMQu85bz8rBTtDcHCmDj4jdmvKuiFW+WQXKpJ2KzxbMo
	1TxGecZIdQ+ihpAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3B4FF779A9;
	Sat,  6 Jun 2026 03:50:36 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AHmPCwyZI2poQwAAD6G6ig
	(envelope-from <osalvador@suse.de>); Sat, 06 Jun 2026 03:50:36 +0000
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
Subject: [PATCH 4/8] arch/s390: Stop special-casing hugetlb mappings in arch_get_unmapped_area
Date: Sat,  6 Jun 2026 05:49:59 +0200
Message-ID: <20260606035003.529685-5-osalvador@suse.de>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260606035003.529685-1-osalvador@suse.de>
References: <20260606035003.529685-1-osalvador@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16A52140008
X-Stat-Signature: kwij7ofcbadz6c7ajzckx8a9nxogy4zz
X-Rspam-User: 
X-HE-Tag: 1780717846-642935
X-HE-Meta: U2FsdGVkX1+ZLH7YP7g77mAhwTw9hwmoJHgtzkbVth35wm7vGNQXjpejsBWpOducWGem/wOx6J16hrxYuwSoW5Sftd8e8LDPnsf9Q0wViUCh30pRl1y/HaOqkBKfQl0a+Xmt4PhHgZ9qP0f06NzAdKzefo6VUSJ9i10aizf7+HS1NH+W6vSg8NvDfDt8/SgoFxYKcSEGMqRIBmN1//iAjiRekocPgqWOSp0vckDz+EevWCai/72FwISEIeQIDvfSgnd+H9RGMwaxTM1gWoreQVrE5S0d/5ww5qit8u+kFmeg4OtVutKo5NMqEAp0dOxj84875Y+92QdWUAPek4wYK2pKLLpXXYWZVtaktlbWk2MDZXLuXhliW30d04LLVuM/Dwui3b/ayIiRGqmYpaK0W6UNOtsKJCUAuHOq6BayQcoC1Ov9ZVaa440lUwZ35TEQXQ1KhAqdIp7RMCYejkkJuouc0Axsc7JONlANpUoF3p5fAiqEcXi2++iQ9PO5ZHTW3R1pLl2BqIRR2UaeDQPJLrsVYni5wg2UGf94p2nbOf+zsDA1O9dEpSiefbqch/fQKGpGibfHJwNRh6ViMaybKq4Mm9j02pzWKM4ytVXXMguv62msPh9sTdfL81mOF79QISapG2S7rlLuCbF2NBRsUYBh7bykhe747uSRFvoxGwdEO1ETtIBemKBrcc+bpyaYW04ZSBwX6A5GdRZwAUlDWpswg2+lDvqI8Vgmxv7FdOqb2+eTsi1+V9y8urA80F+3rJXPFy4l+v0coMH4DF/ZpBHuVfeTaQZ3c5wL0rDrJqrb4XkNl3lW7U4zilpnj6eSZoQyx/OriRFG8EcfqfYWSN/LVZglDgO8u4a+cX8epRaJCP4R5DMKVxfzMF9zeL22CYja8oYL/wtNYBt0/SU3Eqb7Jt38/bbnrDB3t3A1CHW1nZWHNeKPahTZdKn142x9yuV/e3h1P92gG5NlTtZ
 JVXpVvsL
 kM3y2rU3hArClzG+mG1lD29ohjlNA875iwh8q2UPhNsm0xUrZH0YWQLJ6cxwUNuMayKNv4SSu+U7/E67pjsA/SHbWXppq6oGqp9t8u8C2BtEW6WQXLyRDlTtUg+GLveoMDZ5jdFx/eK53nyPBl1aN29caXbd2LtY6T6E7Ao6SNEisQ/BB8xb9gd7kjiHGavDMSya/dxoLHKwIXiWEzlj+oGIdiF4IdukimVv/giXtmxX44ngp60dymeYJ3vaS2z+bNUOQStkaVQPXcROEm8oqamwanZzg87346USVI4IJyN6Kmrs0dUta9EMe4g==
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
 arch/s390/mm/mmap.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/arch/s390/mm/mmap.c b/arch/s390/mm/mmap.c
index 2a222a7e14f4..46c29738c5ef 100644
--- a/arch/s390/mm/mmap.c
+++ b/arch/s390/mm/mmap.c
@@ -16,7 +16,6 @@
 #include <linux/sched/mm.h>
 #include <linux/random.h>
 #include <linux/security.h>
-#include <linux/hugetlb.h>
 #include <asm/elf.h>
 
 static unsigned long stack_maxrandom_size(void)
@@ -66,8 +65,6 @@ static inline unsigned long mmap_base(unsigned long rnd,
 
 static int get_align_mask(struct file *filp, unsigned long flags)
 {
-	if (filp && is_file_hugepages(filp))
-		return huge_page_mask_align(filp);
 	if (!(current->flags & PF_RANDOMIZE))
 		return 0;
 	if (filp || (flags & MAP_SHARED))
@@ -101,8 +98,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr,
 	info.low_limit = mm->mmap_base;
 	info.high_limit = TASK_SIZE;
 	info.align_mask = get_align_mask(filp, flags);
-	if (!(filp && is_file_hugepages(filp)))
-		info.align_offset = pgoff << PAGE_SHIFT;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 	if (offset_in_page(addr))
 		return addr;
@@ -140,8 +136,7 @@ unsigned long arch_get_unmapped_area_topdown(struct file *filp, unsigned long ad
 	info.low_limit = PAGE_SIZE;
 	info.high_limit = mm->mmap_base;
 	info.align_mask = get_align_mask(filp, flags);
-	if (!(filp && is_file_hugepages(filp)))
-		info.align_offset = pgoff << PAGE_SHIFT;
+	info.align_offset = pgoff << PAGE_SHIFT;
 	addr = vm_unmapped_area(&info);
 
 	/*
-- 
2.35.3


