Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E71FC61DE2
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 07:25:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 817AA6B0088; Sun, 30 Aug 2026 03:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9626B008A; Sun, 30 Aug 2026 03:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B8016B008C; Sun, 30 Aug 2026 03:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3B28B6B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:25:53 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 899F412027F
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:25:52 +0000 (UTC)
X-FDA: 85157101344.14.B02BFE6
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id D6ADD1C0003
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 07:25:50 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HW2OpT/f";
	spf=pass (imf21.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788074750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Hcmzw/bzGZXuqmnVsevrBZ8607zbsdAVZ+LLgOu15kE=;
	b=AnAVxFOres64IxOHLG3u4UzKCdT0Sgq8Tg0Bh0EhFXv6oqrb8p7uKC7mrkj4FdTLE14kXO
	JJNTsA8BdDifQ1OQ6fgw0i2aGdJnvaaVOExmqwOM8i+MmuYKkKcw7t8qTKMGbyTfHKplDn
	Ma8oXkR3Z8j+gLt1Zjxl9XLr72RdGeA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788074750;
	b=JBRGdyvXvJv5l2vW2MY9L4MRrqgXCftXYzjxvxOLH0rog0cFQZGYu7c89oe3yBFLIGOXzh
	e9qkuHQdBSOHzM6OzaqEuqmXFL26TAEg7AS6smN+suzAVV/Xs6BYOJ1IdjjJvINicD2i8h
	JylUKeh/XfS3SNWABrbbbFvKw6ijluo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HW2OpT/f";
	spf=pass (imf21.hostedemail.com: domain of imv4bel@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=imv4bel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc1e1ff659bso2100453a12.0
        for <linux-mm@kvack.org>; Sun, 30 Aug 2026 00:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788074750; x=1788679550; darn=kvack.org;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Hcmzw/bzGZXuqmnVsevrBZ8607zbsdAVZ+LLgOu15kE=;
        b=HW2OpT/f7tw3lB8QVB0RXcXKfB/b2b6kdppxu9E3rry+Q4xgt9089vG+HZsnMEgxww
         7Et2t6YAHmxqGQww0pKhU4u6iJElYzt1VGd5loZVzGtr2VTZlUCLtZ/amn+WY45CNkIJ
         7+IVQ7VXMqdTU9xR44+7S8/xVMyqcFGSIsbX7tr1/LY/LSawveerva7GDC2X9IKriKhx
         55xuz0UYp4cEAEqR8OBUjdZpgsDwY1m1E5MLgGfPxR3k1bAkL7JaSn4cU6I4OnVF3Hpe
         i+I/tJV5muzgSwuG8FoL836gdP55xqyEG8Cw6cqD32d1J05njZ0w0DXTLg7WUQsOJrqu
         nXBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788074750; x=1788679550;
        h=content-disposition:content-type:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Hcmzw/bzGZXuqmnVsevrBZ8607zbsdAVZ+LLgOu15kE=;
        b=aMHrn41BO3I08YPTG8HmmLvwZPB0IEaDPns4uCKpgd7dZnLyUfkjj8H7fxB2lAFDi2
         u2Qe8y12HXFemlRM//HgZE87Bxg5Q8Mi1UeJ33bMyUMX/QFfRZKwWtrUPF77qGsyMU4q
         4JOuCpmYpAXd9LOyIPQyn8VsSncpmWBTv6B8cEUXmo6+IQgHDLhbH0F/vCmkZwYp7Yca
         8iTh9Aa1RWXYjnzqKKtUXzjZtNi/m5VgOhHwmZ/M2CyTeY7NDR7lqL0KqXcllc4g1TM7
         /ysX+0Sl2bUSHsVKGR4/QtjTqN4vRGuCz32NTcabyP93B1UBbO0zHrA3FWbqeYHCbMpq
         yTJQ==
X-Forwarded-Encrypted: i=1; AKwUvByTyA+poV+1MB5f65svZQQe9Erxzw62PW3jEYSUaNX9ilmW1ik5igz68KeO0YOOadamguGb5GlWlw==@kvack.org
X-Gm-Message-State: AFuF++lTH0zwd/taUHp+AxkKLBzMGwwbguZBFJONQXXNEKcutYzDNuvR
	WI6smcns2Cxhu/kNwGc+yS9rBLknIZHvC+7TnhEKYYc8sQcPZpzoc39M
X-Gm-Gg: AYBFou1LiiT0vcL3VYFfCZVRuFpKjqWTSKHe6fxR91LKP6MMAq7fj6jDhxQXOc/J/9J
	uUk+zfob/ILYIaI5/yHHa1W3NwyyHKnc5y6SyY7QmucO592QJ/H79JtM+UpxhsbMprKvUeuYofa
	WhBgIffq6gMAiO/chL6EKojTSRzuMsY+EEDGSWnVb/EjVsLFQqygEBt8K7MENE4U5W33pT7+zLD
	HzVVqjv6hFMne68TaPNJp53jx4n507r1vSa2eOMgKwuVPkyRrKB/LrlI/sfqMOOD2n+b/oZ0Z/r
	bO1smHarFwYgnV5V5XBdKOMYNjbyZwvE47A+E6C7FfBYUDjxp1c2fj1XsiAgPDJkfzPWDId43Qa
	dmMdx8lTNooUwuVBAAdamKpercxGazbfTH4ZVundC1ywQGSUjOGCQSVS8mUA9Usf9jzAkxHvLm/
	nB8mMbiwszM4ygZ8wQLPphe5t7AwpYi9sEQRZPiHjNayEk4U5KzB4TM3RLNe/cR5G0rGMgFp2y9
	XYqBIU=
X-Received: by 2002:a17:90b:2fcc:b0:398:9be9:ab8f with SMTP id 98e67ed59e1d1-3989be9aca2mr16397639a91.20.1788074749551;
        Sun, 30 Aug 2026 00:25:49 -0700 (PDT)
Received: from v4bel ([58.123.110.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396dda7835dsm10440159a91.5.2026.08.30.00.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Aug 2026 00:25:49 -0700 (PDT)
Date: Sun, 30 Aug 2026 16:25:45 +0900
From: Hyunwoo Kim <imv4bel@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, imv4bel@gmail.com
Subject: [PATCH] mm/slab: take n->list_lock for the list_add() in
 __refill_objects_node()
Message-ID: <apPa-cGLcyt90l-E@v4bel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: ru6t546xywp598t4jbzq6r58rtscsemu
X-Rspamd-Queue-Id: D6ADD1C0003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788074750-626459
X-HE-Meta: U2FsdGVkX18RNUzCK+8fbyK5Wukx+5QmYSXHGe1UKgAELGc7pfcU1yE88Amk2G87BpVHybrVEaTd95SqJQNh9ilnbXVJc5I8AO/Fsze9Quvz3o24JSTKqbUx5pFzIZfHFJu6QRZMQnFSUjvuzm1vicKHF6vyTLsfhruWFXT6v74/4EpkcexkA8iZCo7FRp6fMOwc/D0LIg/8Hi7kGJXJJl+rNQMWfRDgEW5TU+kpKtZ96gk6BGfyYxzC/sg0Zi+6K6nNYm5oRFNXR+DM7Vhg1cjCkSDYoWwdgh1LBAP1JxoKGClb5Fte76R8n3P/iiPiU6ll2M7dy88b2XDUT3YwywTPniKYc5aaWPObNT4OQXOUZiUVZzD2+tSZRN5LYhC7uwRCRXSX630Zx6YQoETwHWU/cdUIHbege94j985BLi0EGLfh5EpjgKstn4jDeqK70NXDwECKxfbGkZxjtN5kEn5MuZqoReU23lkzv/0Hbr4QAk88ljukHToIgQEDFV88zvfryU7be1OnBrfHCTKkMfg0QGMwsLRW63aPrumCOycOPwsWHwyIKuCxwmxXglP+DX+gCda8qdlag25Fwr4mp038xhCLY5cRizO1j5BtrfSQ9XKffdfSt6HZHwFOuZyGiT1t879icEQKt5Vdz1y9l30xTZ+AHeRA6LQzFrCSE9Pj9LvH/osF1IyN820V8iILdtgCkKHL3iIm94X4XBPBg8Gm+dk7aqvLg/GJryzlk68wzvSjjHWHK2hVLQdbxyrKjBWzKrHMxlkwm6LVJ8Jtf0dkivZCx7QOChory7MDqMNwbu2ZmL3M6/tpTxsp2KUxY/Lv1pYNDneb92EtJCRaZJ6A6uMrT/tYmyl9O3rtfnLSWjWdtU/ojiqvWEmxRi/RJmc9JEUhFh4uiGX7TOQvJzqxMOqX6DfKi97W327juuTGYxlnBKmv9SQMADTcOezgJBY1dPcn8SxmixVSapZ
 raqBq3XT
 qV0YK7NRU+qNeKNmtQjVi3EvcQZ05pzs7yMIIZo3pVYo8BAxVF2A/a5LSOURMZf4gU3QD2Zsx2sErYOUpxZEGoiqBvE6Jgf5eRDapg3EglD2R+N9rdeVBy5i949ie9z4Wev1htqGFFN9RgCrxK+aehU0ionn5Dhde2v5Ngxsvpw40nlZ+C1WvEU6KTzIwe+iJKOh3dyI+f3LuxiXNKNJTuZWvCBgKafEycEMhl0j0RUiL7q/bdbMSB/aJcYS8gD1MQdXdF8cG+Bqv4Xm1lOsEUJSpBnlpRzdFga/oDfrnm8rOZ3pzx2kioRd0f/gWPvdBd/HYWuEr3C5Jd0f1GrP9cYMBfRTEUGtpIjQKscBiuLlKrMme4eAFDFNNgbQh662IK97L4pAeKqbBs/y5t4WxEF8etbYROJ7O3lHgs8wMDEgO3iGgn5/ow8y3MhaSbCN878f4jOJU4D894O/4mgsMXlYNB/RiiAdL4FJmw4AHXEUOCxJPE+mMUVRVr1D1u/s5oyYGyiSAnXtn98gDs7u8y681eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In __refill_objects_node(), the list_add(&slab->slab_list, &pc.slabs) that
follows a successful __slab_try_return_freelist() is done without
n->list_lock.

__slab_try_return_freelist() only succeeds while slab->freelist is NULL. The
slab we are refilling from is taken off pc.slabs by the list_del() at the
top of the loop, so at that point it is on no list.

If another CPU frees an object of that slab, __slab_free() sees the slab as
full and puts it back on n->partial. If a third CPU then takes that object
in get_from_partial_node(), the freelist becomes NULL again.

A slab that sits on n->partial with a NULL freelist only exists while
get_from_partial_node() holds n->list_lock, between its cmpxchg and its
remove_partial().

A list_add() in that window overwrites slab_list to point into pc.slabs.
The list_del() in remove_partial() then follows the overwritten links, so it
unlinks the slab from pc.slabs and poisons slab_list while leaving the
n->partial side alone. n->partial is left pointing at the poisoned slab.

           CPU0                        CPU1                  CPU2

  __refill_objects_node()
    get_partial_node_bulk()   // n->partial to pc.slabs
    list_del()                // on no list now
    get_freelist_nofreeze()   // freelist = NULL
                              __slab_free()
                                add_partial()
                                // back on n->partial
	                        // freelist is not NULL

                                                    get_from_partial_node()
                                                      lock
                                                      cmpxchg
                                                      // freelist = NULL
    __slab_try_return_freelist()
    list_add(&pc.slabs)       // overwrites slab_list
                                                      remove_partial()
                                                        list_del()
                                                        // off pc.slabs
                                                        // slab_list = POISON

panic log:

  list_add corruption. next->prev should be prev
  (ffff888100000248), but was dead000000000122.
  (next=ffffea000416e410).
  kernel BUG at lib/list_debug.c:29!
  Oops: invalid opcode: 0000 [#1] SMP NOPTI
  CPU: 1 UID: 65534 PID: 144 Comm: poc Not tainted
  7.2.0-16172-gcf72cbb39da8-dirty #1 PREEMPT(lazy)
  RIP: 0010:__list_add_valid_or_report+0x80/0xd0
  ...
  Call Trace:
   alloc_from_new_slab+0x183/0x300
   ___slab_alloc+0x31c/0x890
   __kmalloc_noprof+0x3d4/0x800
   lsm_blob_alloc+0x2d/0x50
   security_msg_msg_alloc+0x26/0x90
   load_msg+0x1aa/0x210
   do_msgsnd+0x91/0x800
   do_syscall_64+0x109/0x5d0
   entry_SYSCALL_64_after_hwframe+0x77/0x7f
  ...
  Kernel panic - not syncing: Fatal exception

Do the list_add() under n->list_lock. Reattaching the freelist stays outside
the lock. Once it succeeds the freelist is no longer NULL, so __slab_free()
cannot put the slab back, and by the time the lock is taken remove_partial()
has finished and the slab is on no list.

The lock is held until the block below that returns the remaining slabs to
the partial list. That block already took the same lock on this path, so no
lock/unlock pair is added.

The unlock is keyed on having taken the lock instead of on pc.slabs being
empty. With CONFIG_DEBUG_LIST or CONFIG_LIST_HARDENED, __list_add() returns
without linking anything if its check fails, which would leave pc.slabs
empty.

Fixes: ba7425312607 ("mm, slab: add an optimistic __slab_try_return_freelist()")
Cc: stable@vger.kernel.org
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
---
 mm/slub.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index f9b56cb439e709..4f6d1a03a8ee46 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -7260,6 +7260,7 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 	struct slab *slab, *slab2;
 	unsigned int refilled = 0;
 	unsigned long flags;
+	bool locked = false;
 	void *object;
 
 	pc.flags = gfp;
@@ -7297,7 +7298,10 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			void *tail;
 
 			if (__slab_try_return_freelist(s, slab, head, count)) {
+				/* get_from_partial_node() may be mid-removal of the slab */
+				spin_lock_irqsave(&n->list_lock, flags);
 				list_add(&slab->slab_list, &pc.slabs);
+				locked = true;
 				break;
 			}
 
@@ -7312,9 +7316,12 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
 			break;
 	}
 
-	if (!list_empty(&pc.slabs)) {
+	if (!locked && !list_empty(&pc.slabs)) {
 		spin_lock_irqsave(&n->list_lock, flags);
+		locked = true;
+	}
 
+	if (locked) {
 		list_for_each_entry(slab, &pc.slabs, slab_list)
 			set_node_partial_state(n, slab);
 
-- 
2.43.0


