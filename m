Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 118FDC44508
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 19:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7556B6B00AB; Wed, 21 Jan 2026 14:11:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 703306B00AC; Wed, 21 Jan 2026 14:11:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E58D6B00AD; Wed, 21 Jan 2026 14:11:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3F66B00AB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:11:10 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DDC4ABD4CD
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:11:09 +0000 (UTC)
X-FDA: 84356913858.14.60A7A45
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id D8805C000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 19:11:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JYp4XiuJ;
	spf=pass (imf22.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769022668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SdZRkQhKinw2Zzq19HysXvpWY3I1Lr5Ul0XP6wR89Go=;
	b=roQs652PH+XdL91VsNbMp2C2oIlSHt2/Tdpf+hZdmaCOxm9WUgubwj7xUED7j/DQrGkhK3
	D7C9ep3tSyQelIlL7n60xtMmX0lTuczLKkgjaJ98uNwZMI8tG1Y52AwaRpb5FC87TIJ0Qo
	cXeUkVj/UH6wLl/+ZMxDugUXneMsaeM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JYp4XiuJ;
	spf=pass (imf22.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769022668; a=rsa-sha256;
	cv=none;
	b=l90gJ35IULhw7hVt7uskYjvP/vh2d3jQn/0zW1k/sb+cdTKr+72X9m4LskwjWb8JRGZmhK
	tPH4vZWBjrGQ7DtnaoMnu4EoUXegiNWh8fAGAJTfXMd6Zv35KAd7TR71RXslGWAVpbAXFn
	gqJ1JdYCIT/4GXMK0ZcARdwLm1GiPG4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1769022667;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=SdZRkQhKinw2Zzq19HysXvpWY3I1Lr5Ul0XP6wR89Go=;
	b=JYp4XiuJEmFTJwullkuqz72UfXK8RRosxvYGjFBoER1VKdjSo8nWNzEN9cHPI+yvzqvfEI
	uIIIzK0u8NZ4rPF5FV8b4d0pYzkogaqeTTIysDrr1OyY03j9yJl9zvQVw7+P90ADaGb73k
	LS8721BxfMsAe5RUgtAZzokOU99Q7UI=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-277-XN4vaPV7PW6RxpaJHQxHwg-1; Wed,
 21 Jan 2026 14:11:03 -0500
X-MC-Unique: XN4vaPV7PW6RxpaJHQxHwg-1
X-Mimecast-MFC-AGG-ID: XN4vaPV7PW6RxpaJHQxHwg_1769022662
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 956081956096;
	Wed, 21 Jan 2026 19:11:01 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.89.197])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3C42919560A2;
	Wed, 21 Jan 2026 19:10:59 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH] mm/mm_init: Don't call cond_resched() in deferred_init_memmap_chunk() if rcu_preempt_depth() set
Date: Wed, 21 Jan 2026 14:10:36 -0500
Message-ID: <20260121191036.461389-1-longman@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspam-User: 
X-Rspamd-Queue-Id: D8805C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: rzre8ofc97fduh1zgeq43ozeoqq3dex5
X-HE-Tag: 1769022667-472743
X-HE-Meta: U2FsdGVkX19EOoqp45PC/oxEAjkmcV3AF7x1W0x/+1fMZN7ntMH6FvBKswB0TQYXfuiDdjA2LAyzeFilwc1EcAXjbb+b0yN05bGnRQucEDsz28knOtdnLiA/bPMZHjX/x2mrTeyx7ld/pKdA16UgtEimByGkyv7Dt9whCev/YM9hbf3O/J0JQLQ0q6rYa40ZuOP2Hj8lsjmhlKt3ERP16+pAgw9sn+8l3nu7ip1fnL0h9MB7LNhGXJfTXZP9ikW5u8rXKnD8NtLWEN0i0ZsvlCNxybJq/xzmC2XMZ8+f7vqZVyn5gVfp1stI7g4VZCpkgCDCl/N8xrPg71uAQyINWIJveiaLl2RCi04SEe3IW9WVNWEPN78PBwC8g0hxCR6mQMAZj2mDHFU7F0MxfmUuXFpAHgqEEFP4+Dh/jNqHqob2yvklFf8ZBBrphTMZqFKDPmb1F7jJBUAwEfTCEkKwUXuAB00hqZLOCP0YF6nttB5mbIbw+F8IhAYAATrFufi2qS2H2XDg29Lk9n3wPyR3Mf0/O3zv6HAffutEbDPqB5aIXonrWceWF0ak9A4q87tLVv//aMn+yvJZ4H+5PLn8ayuREZ7TZTfOk8mp6KOjvId4fhyLwxbvO6OTraIPsp90c0Wy8coac+UhTd88bikKi16CRQu6v7q27SrQUwleft87UUMsT53Ar2VZi3Jphz2/hGyITFgBDs7Nft1Qgc2dsFisi28Jv8Kc5D3E1/YNj0yOlyt9TFtX7nexTgf8ouNqrVb3+3YLnDv/VeY4HBb/AtiIZ4o4zY8bMT4NVb8gKRBR4CLeC/hNAX+3GTvsDJ/awb9FhyTJ3A/2q51W3LCSYbxaJy4CVz5bkcLIY5DvaGbxums8xrWsRLWKagYMmhnb8XRXjCEIG7DUV4e9pq3xyM5fPgAntJEk6Q9JUBcoAMzjVcQ+tVSuMse1PBjjokc6wA5hQUCuGm8POu4ZNUQ
 y7B5nBKF
 D4IVb26Cr9FZerBj/mNsx81+qpbK8vxU+HZU2mGzY9mzFUJOo6CCBDgBdCIj+Te4EYCw9hjGMSwDAuU/mAG6n35qcaMHw95pflqp4mOmpP50CeYCF2RHfEMAbuepNbDbDrpIQSa5yJcOCLbuf1W9MfnElIO+ZF6RW+Isk26a1IHsW7vz1uY685OPSDt8vFLiHWauOv7xsjBhfZbhveN/Vpyej4GNg9/ViOtcZIo7MV9E4EFnZw6hjZFqU0f/CzQ0IcstEK/JHRxEowSWLrm3FUgusdnesqthjSw6at5e6KTVA6ZAhrKrmMyGOxl1928qVuQMkqw7FS4eflC/fetLyqsqYd4O5saVas3J6T4Mx5cnO+fgJnbQQDSc7I42DX5bG7vKo3sjJFVPXpZl95O91p3ExRtrqr3l+UU1dpb3BY5xHUHQ99Zef8CLbnoVKddnK8k4w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk()
in deferred_grow_zone()") made deferred_grow_zone() call
deferred_init_memmap_chunk() within a pgdat_resize_lock() critical
section with irqs disabled. It did check for irqs_disabled() in
deferred_init_memmap_chunk() to avoid calling cond_resched(). For a
PREEMPT_RT kernel build, however, spin_lock_irqsave() does not disable
interrupt but rcu_read_lock() is called. This leads to the following
bug report.

  BUG: sleeping function called from invalid context at mm/mm_init.c:2091
  in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 1, name: swapper/0
  preempt_count: 0, expected: 0
  RCU nest depth: 1, expected: 0
  3 locks held by swapper/0/1:
   #0: ffff80008471b7a0 (sched_domains_mutex){+.+.}-{4:4}, at: sched_domains_mutex_lock+0x28/0x40
   #1: ffff003bdfffef48 (&pgdat->node_size_lock){+.+.}-{3:3}, at: deferred_grow_zone+0x140/0x278
   #2: ffff800084acf600 (rcu_read_lock){....}-{1:3}, at: rt_spin_lock+0x1b4/0x408
  CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Tainted: G        W           6.19.0-rc6-test #1 PREEMPT_{RT,(full)
}
  Tainted: [W]=WARN
  Call trace:
   show_stack+0x20/0x38 (C)
   dump_stack_lvl+0xdc/0xf8
   dump_stack+0x1c/0x28
   __might_resched+0x384/0x530
   deferred_init_memmap_chunk+0x560/0x688
   deferred_grow_zone+0x190/0x278
   _deferred_grow_zone+0x18/0x30
   get_page_from_freelist+0x780/0xf78
   __alloc_frozen_pages_noprof+0x1dc/0x348
   alloc_slab_page+0x30/0x110
   allocate_slab+0x98/0x2a0
   new_slab+0x4c/0x80
   ___slab_alloc+0x5a4/0x770
   __slab_alloc.constprop.0+0x88/0x1e0
   __kmalloc_node_noprof+0x2c0/0x598
   __sdt_alloc+0x3b8/0x728
   build_sched_domains+0xe0/0x1260
   sched_init_domains+0x14c/0x1c8
   sched_init_smp+0x9c/0x1d0
   kernel_init_freeable+0x218/0x358
   kernel_init+0x28/0x208
   ret_from_fork+0x10/0x20

Fix it by checking rcu_preempt_depth() as well to prevent calling
cond_resched(). Note that CONFIG_PREEMPT_RCU should always be enabled
in a PREEMPT_RT kernel.

Fixes: 3acb913c9d5b ("mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()")
Signed-off-by: Waiman Long <longman@redhat.com>
---
 mm/mm_init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index fc2a6f1e518f..4d6b6dac6f58 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -2085,7 +2085,12 @@ deferred_init_memmap_chunk(unsigned long start_pfn, unsigned long end_pfn,
 
 			spfn = chunk_end;
 
-			if (irqs_disabled())
+			/*
+			 * pgdat_resize_lock() only disables irqs in non-RT
+			 * kernels but calls rcu_read_lock() in a PREEMPT_RT
+			 * kernel.
+			 */
+			if (irqs_disabled() || rcu_preempt_depth())
 				touch_nmi_watchdog();
 			else
 				cond_resched();
-- 
2.52.0


