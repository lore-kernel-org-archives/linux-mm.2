Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A71CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 08:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078CA8E0014; Tue, 30 Sep 2025 04:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029248E0002; Tue, 30 Sep 2025 04:34:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E59E88E0014; Tue, 30 Sep 2025 04:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7F608E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 04:34:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95282160452
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:34:33 +0000 (UTC)
X-FDA: 83945255226.03.B5183F4
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3F935180015
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 08:34:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="mrLA/ulE";
	spf=pass (imf24.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759221272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oJNprfTnzFv5j3p9LJM1lYVBmez2CLiJJObfY5Wzdn8=;
	b=joqi7GkvuXPjDHx94rDYKQtwjFOseRu5jJCa9jBlq+pZvtHfFs+02dN8Y6yo6phTJLis6A
	IIi3xG5CX7KgkjQ/ZnBJ6oCEiRZzKyqaWfblxUwloIDwVsWY20el9JyYzLZW8m2Xx92dPS
	ujE9uf4gqSZoIxfK6lZ2Ux7JY/DGHvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759221272; a=rsa-sha256;
	cv=none;
	b=cdLd4WAwkC/7q7Il6U9GMudn0nJz56KiDb7blgwrSc09Oz9tzTwDLJ2FmwnSoAFPwOcbeR
	mgkpkWW0bvwea0EqAAjFXU9kZpGHkLFPk9BtUeF/X199ArqSvlqvThhU8sUtGjOs8qpWNX
	vdlS+CH/5cvT2Krv/jqD+IuYVmf8R3k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="mrLA/ulE";
	spf=pass (imf24.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=oJ
	NprfTnzFv5j3p9LJM1lYVBmez2CLiJJObfY5Wzdn8=; b=mrLA/ulEE/SybplfoZ
	V2zyco/irOXroNPBHhvIRLEV8CIpqPOkAdN6fZs/FoLTDknPXdjPjRh7qb5xhFb8
	GKZbc9gwWaClSMpafBhxB2Tc72NvFtHKYk+8nm+ODmuVGsYYJmh74oQPbNJvNU3P
	kA+BHDcVnuD9Ulfr3n25ueUr4=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wD3fz78ldtoiyG8BA--.62130S2;
	Tue, 30 Sep 2025 16:34:05 +0800 (CST)
From: ranxiaokai627@163.com
To: vbabka@suse.cz,
	akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	harry.yoo@oracle.com,
	ast@kernel.org
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH] slab: Fix using this_cpu_ptr() in preemptible context
Date: Tue, 30 Sep 2025 08:34:02 +0000
Message-ID: <20250930083402.782927-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3fz78ldtoiyG8BA--.62130S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ZryDZrWDurW5Wr13GFWrAFb_yoW5Jry3pF
	Z0g34DJrs5Jr1qyw45tr4Igr15uay5W3y8GryIgw1SqFs0vwnrJasrAFy7WF15uFy8Ja1U
	CF4vga4Yqw48WaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0pRHv3UUUUUU=
X-Originating-IP: [117.176.243.111]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbBEgHYTGjbks5yFAAAsO
X-Stat-Signature: wdcpar7bzsbni69b69useky4oiin5mbw
X-Rspamd-Queue-Id: 3F935180015
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759221270-305377
X-HE-Meta: U2FsdGVkX1//38Q4R1HHJdKAnvzWosylyo+RuPXwoICfV+CAt/0R77Mh9nvuDCc/TKwf1tUET3oY3IuuB3BfxY/dN/Z16vYq3S1qnL5TjPDPTzb28EaYQEbDWrROjkCcRi0gkSGDfhxvyiBC222rIq4eAW2DNSPpa4zVFuR44sFIvumzKs3sLi8TLAcSL6WfYPNj4DHOjDS8D6sjulPZxu21oXRRP5KTt90Ylck8In8pkVvcOXImlwjBbmisUI/7q6JvBcmcwo668LhPiRae/NRmq6A9nybw6jmny4dfsVob8ARq0d0aY3azs5LfPVnRALpu2M0BPWoW8gU2Bi1ykRLgKx3NC8++8PhwRb5aVO5Yypn+sf0pEw8ZOOnZE7zx3RyzpV2iT3i8mtwufbuMHcu6ewuMnNnPwCQKwSVMvpF/M51bICFbjjQrbKZ53TIrJEOR6shNxFm9LwhYkmChTkaokF1Yvew3qpPLkfCQHtTbi4U/qrlrPf1QqiOM77QyM5kvliRDsPqHbSON+spj1kDpv1bkxAHGozTzm/bf47S3wWDlphsc9R4KAkk6BolJQuTARKKesmUT0oyBqd10Uj4mnIVHHL9ffxUXQj5hhw7s23OGN6eFJ+5OMV7i1XF3EdkX0SFcYxAcmhFrt9wn8Z/SkQkXIoFPWSUN3r1EmsV4b6MMIOwei+go70Xfl2vuopY5Dicxe9B4N2OVA6Y7x9FYrq0nZxwwO1V7tBj3EMCup634L/ULwK3iM/3g8UfdbTtMphl6HRj8Kgm6HlsP8HH4sbq82XbCOl9nLZcjI/qB2Yu56XVfv2uSUN2a3efvmetiEOQzKi3snVM494p5TfUyWtNhIAzahHwC+6HFwyt9TxYtShnoRN5d8SscLvFOzfvwFlqYo1zPfZUnK+JFkZu33S6DpPI0fRpkusIvcLsJcBo6Hg78ixqD0P7goG+vIbCDZekl2Gro91bt4kM
 LZZzgQsX
 g4NlsLylegFB8lNbEb2zmAjddm6QeqnB9d7UkJ+e1IVL3j45JrPAh9sfuO7ubW1zZV99+g2Vz/7N0c3GWvQcacuWKQT27R2PK7gvhhdbsztN3SBiQLyh48BR0/LT0/eq+NJNgFwGLg4Qeh2Z04dYShi0DC9Y+RZ/8vzV7ZCQQl60V+fv7wui7zrWX+MY+zeGvA3d00dpyvJ7ioOXNuzZUXT5g+fqr/N0Rq6+NnKpFKiJuStIItAzC4LSNSfdDkCQzlgrnq3MGTN/LddwuExiYqQavrOJInHyu1fYrZd9SWFdDM+FmCeOWVBNALSunIIbLu53qpY5+jYppKPiKum0A7cULFCI+pVrPR/K5m5s6XyRG8pM+nbShVDU1TxEDM/ek2OOaNxZ6wiRN3IyX9+W5ly0jclJiLQ1AfsYKQdMFTG2DbBiY07kFccQAgDKD96rDz72A
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

defer_free() maybe called in preemptible context, this will
trigger the below warning message:

BUG: using smp_processor_id() in preemptible [00000000] code: swapper/0/1
caller is defer_free+0x1b/0x60
Call Trace:
 <TASK>
 dump_stack_lvl+0xac/0xc0
 check_preemption_disabled+0xbe/0xe0
 defer_free+0x1b/0x60
 kfree_nolock+0x1eb/0x2b0
 alloc_slab_obj_exts+0x356/0x390
 __alloc_tagging_slab_alloc_hook+0xa0/0x300
 __kmalloc_cache_noprof+0x1c4/0x5c0
 __set_page_owner+0x10d/0x1c0
 post_alloc_hook+0x84/0xf0
 get_page_from_freelist+0x73b/0x1380
 __alloc_frozen_pages_noprof+0x110/0x2c0
 alloc_pages_mpol+0x44/0x140
 alloc_slab_page+0xac/0x150
 allocate_slab+0x78/0x3a0
 ___slab_alloc+0x76b/0xed0
 __slab_alloc.constprop.0+0x5a/0xb0
 __kmalloc_noprof+0x3dc/0x6d0
 __list_lru_init+0x6c/0x210
 alloc_super+0x3b6/0x470
 sget_fc+0x5f/0x3a0
 get_tree_nodev+0x27/0x90
 vfs_get_tree+0x26/0xc0
 vfs_kern_mount.part.0+0xb6/0x140
 kern_mount+0x24/0x40
 init_pipe_fs+0x4f/0x70
 do_one_initcall+0x62/0x2e0
 kernel_init_freeable+0x25b/0x4b0
 kernel_init+0x1a/0x1c0
 ret_from_fork+0x290/0x2e0
 ret_from_fork_asm+0x11/0x20
</TASK>

Replace this_cpu_ptr with raw_cpu_ptr to eliminate
the above warning message.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 1433f5b988f7..67c57f1b5a86 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6432,7 +6432,7 @@ static void free_deferred_objects(struct irq_work *work)
 
 static void defer_free(struct kmem_cache *s, void *head)
 {
-	struct defer_free *df = this_cpu_ptr(&defer_free_objects);
+	struct defer_free *df = raw_cpu_ptr(&defer_free_objects);
 
 	if (llist_add(head + s->offset, &df->objects))
 		irq_work_queue(&df->work);
@@ -6440,7 +6440,7 @@ static void defer_free(struct kmem_cache *s, void *head)
 
 static void defer_deactivate_slab(struct slab *slab, void *flush_freelist)
 {
-	struct defer_free *df = this_cpu_ptr(&defer_free_objects);
+	struct defer_free *df = raw_cpu_ptr(&defer_free_objects);
 
 	slab->flush_freelist = flush_freelist;
 	if (llist_add(&slab->llnode, &df->slabs))
-- 
2.25.1



