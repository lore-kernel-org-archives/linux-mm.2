Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C57AE606A337
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u2tLRwkV
Received: by kanga.kvack.org (Postfix)
	id DCF1B6B05C3; Sat, 14 Nov 2026 09:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7FC56B05C4; Sat, 14 Nov 2026 09:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6EC86B05C5; Sat, 14 Nov 2026 09:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B0B66B05C3
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:51:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 31840160418
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:51:27 +0000 (UTC)
X-FDA: 85434013014.16.A4CC439
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id 54665C0004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:51:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=u2tLRwkV;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667885;
	b=xpl/d3rnSm4EunUGZPeoaVnPbaL2nvPCsYb8X1cHFAaA8mI7XdmmU7oZtqoDzAcApezyQO
	2YH2S97XyicEkHcOpv6g1/uAvqiCMbot5b599YYxh9wWHbobHd9nA1JRRrm1JdWkjVaIwR
	g+YXj4jg02rX9TjS3DxHIe+E1IzHPZ4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=u2tLRwkV;
	spf=pass (imf28.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UJ5F+HaNH4ZBPeQoxzjH5cK/wA3ysLS4ghrprv5+TaM=;
	b=XBscRJPXli5V9V8bNW7Q2Uu/QoLkanefEivRSTkGgECAbpH3gpzs0ksBaFJD73WGR6yqiS
	gh4LP47VLjX6ESADCIOv1o3kVolNrH6JTxjWLeamPCinNoLP9xiHfLG/Zr0AG89Tgqxxpf
	yAg5ureIAyp4OdswmNFKbGYScOheIBk=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ed06b725fdso20527675ad.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667884; x=1795272684; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UJ5F+HaNH4ZBPeQoxzjH5cK/wA3ysLS4ghrprv5+TaM=;
        b=u2tLRwkVOK2i3/D2dmN0I5fnYqm5E0t/qsUr0ti55tYHHEujCqD373oYeMAVTVJZsT
         EXdeEzW2iOxoGMvoD5zwkz2EQa16skgCtSTZRgWrg5kI1C97UyUykaxWFnR7Nz8GKBdl
         nVdpo9VH/syQEPo1zijSFhBISUE8AOLmyweRGox1HGCNrNdgqU4gkG8zORg+07tytx2l
         3QB29nJel4xvZ3bFmcQ6ELYntVlTOWvGbfyp0gLXFS2DLrbvPQWZg857w4L/LsnsT0vb
         1EIqf5WUSYt1MnjZfX4KBu3ulS0Qz0Vi/og5uRADFxZWYWQyTEGsSfhxv3/INu/ETJ8D
         eZOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667884; x=1795272684;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UJ5F+HaNH4ZBPeQoxzjH5cK/wA3ysLS4ghrprv5+TaM=;
        b=ZNqT5cMHLQ2Tp+3CvYIa/um7F/rlsPoFMq/+I8I/jmERDtKdnUOLc/wbZraC9QCE/k
         N2q/BPFU3OQz8RSp8l4suJfpWA/bK6Pbg1z8fLrqc7o4axBYuJiMaKgV4EhQKyOSkAx3
         bmXV+4Mo+od73FWcBYI/dmshtILSnLS28AbJOMSeR+twBXMuXEqwZLDM/glIx5WoPbGI
         aDe2hAT4HIO7pgLF+4+//bbRGSM0IPRdunsE1UzTIypGgupZWhJCUSBkI6qC7mLjJ0W+
         hNgHybdKZByHbTSadmhYf/nB7BhpDFuHBN89okdwNsLBoAVP6hZM8NPN5u2C7FuLFZ6I
         BVTQ==
X-Gm-Message-State: APuU4Z/An++5ajgyO5od0SMEYtsJeU2pMxlUZr9e9cnZt1dpoFK2VVZ8
	Z5E1eRTVm73Lze97P3okVFLnu/WLPE9dOlCtoHDUaqG+/HExs9z11EM+aYQhjw==
X-Gm-Gg: AYBFou1u5Jc6nUzi+S8CTg7slN8ewyjnmyec0Mu/3cpYmPCR0/jm6BT42hlmJVDycbM
	QMTAH8wDaI69AzOloABl8zb9AwWS0wRXmIHmJ7CV81RSYhZHXOy/vyNO+RLSUqKkiv7gMgMNYbS
	EgEE8mS73dcErJ3ChOZhZQ4sJlhsQ5iGJcQz4p+IY7OOXb5c8mLKYk6wSEfz7J+bed3XuR8qw4J
	qVJ899155pcZA0r52I3pJX6pulI83TAJEj9BppM9wtr/bb2Gs361ZF53OLh8lIEsG0OpZs6wbfD
	u7MAOIPZwTX7AsHtyTCyNWO1TT38xN7MtZNJZhKTvH6e1bj6HBuaz19ZiqO3hHSrnktfpSpQl+M
	TcqKLA6fdzKsa5Gn9/E92k4Grycr1uEygqUv9MUHC4xEqUg9m00tSDtVaxASkxIWuD2eyWU9hjU
	srn0XYKiLP/UJfq1TMALCcM43XXRcyZqj6lq88HvxzahjLO7I6OYvPciOjjK/O3RfX2ya9XSRX8
	6s+GLtAyjS6XHQhv+2e2dRJcBZ/AP+D6ayIZV1EBFrgtGrHYei5GlnHP3bbyZJLkojjNJ5QX4rQ
	QP7Z3O5LsSDgbmUCr/6i1xLFg762ysaVAnXTi319FM4tBJ4QZq9bHtzeoj648I/oJ6rS
X-Received: by 2002:a17:903:15c8:b0:2e2:d3ef:125 with SMTP id d9443c01a7336-2ee0d9fcecbmr38203785ad.5.1794667884113;
        Sat, 14 Nov 2026 06:51:24 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0f874871sm21105465ad.54.2026.11.14.06.51.17
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:51:23 -0800 (PST)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Jihan LIN <linjh22s@gmail.com>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v4 11/18] mm/swap: remove available list
Date: Sat, 14 Nov 2026 22:51:14 +0800
Message-ID: <3bb9571ebf783db7a86a0ee2e7b00883c1de850b.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3xgioynoiwzne75s7hwj3j4wu8k4e478
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54665C0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794667885-797892
X-HE-Meta: U2FsdGVkX1+YQk50/JC6Q/Rxiqtx/kagxDy5N+X9a9Qu8B8uO+BcvXgmndzHbdlajRavv3QoSLl0z+zSefCRkC+pYP5LqZ8CqXXPzzXeVKjOQqErBtZg8hC3A82gtTUWfuncRb6jgYMhj+AFLEFFjx4qMWxTjHsMLjDHgnRNBDNe0tfawP9s89rn9gB/iFQYseaau8ZFHnGU6oiU7M1eH2jETtno/6JH5qVyyV6ag+AbaamzOmUbalUXAzx3ZLfoIAcpsb6gDFTuEG4CNbUNyvzQsMCRfM5zlznwo+dZ5OQczQ3eRQW0WksqRjZAD2LxIwh1XJAnLVXHAmoRQE7LWXUqOF72q0zS/F+deZLXFMush6oDboO38cNEdTcuvRUaZ+DiIb8bdKTVVAjZzJ9jzawZ8TYL8Mn0jyDXHSF2DLxLbW4lKAx7My5uQscwZ+M1j2/GoSVCRX4Fqo6XNo2yXw1XQ6vRvOUNx6Qu0/YW3EuHBmVPDpgl+d4deRM1uT2liw6hiTXPBv9wSoxTTkgiFBIp2arx/peROmtAxJLOofGHiio595Zi/AIkqG8HjZci2iwguzN6anYunl5YhvjAxBc0ZMxY+eWseAUUCMVDPsFFt/b/MiaIRHP7+935JusL5zyFfUe7pLJT9X27yBhSvp+MtzvCtLxRvzlx92D6cbDkMV6Tw95IJX4BKTDEjCxhkutBMbtTwtmlNAVEfFBuiAd+BhmpAwGRmnVMoL7ByOMCHMcuM0d+XiOgSNEgFHP2kcsDAcyEz9kCbiZpYjToDxfCZBqAHk3OorfkXnP0TkkKaXZ/AjEaiSGQVD+h6oqm3hXkzZw8Xa8yZ2ZGYAO4fVf+Zh1eyorPG71jkavTZrYtJ8zApWU/pHuHg+dGZyHf3W4Q3QgcRP35B8LdZeTKT5zzv47dJPoKZ0NLOdVrhybJ85XancNQYrWdVfRWkQlHGup9LBJ2ViC2X9L4Wo2
 XG+juXOK
 cKG3jZZSHAKL49jFbsrM7+xkKjvQQ2wkQKjP07PA0FG4TIADPC0xY3W8X5c9bV3sdC++vYr0S20ZHp/wT5p25s2yX79ggOefTOiwpWvivpMUh7lUziCfyV+2ILnQ/2CgqAhQ4M1QwUGSbpyCpYAeSpSOfu9UYxqRIY74uXAEABEA1087UV3PMjYq+Zwj42L5HKlnq2xqZAXWf3TlqvwFJaOGyGk+e/n5PIkSdaEQlHvnMII4tx6yA1LqF1yh/6DYue2QLynCke4PUUmyVO/fttGrj33P9yj7uUYSkzShoMDO3uk5lw/W18jNkNq1NVz+KywQe3XuzrNc3ENufRGpOINAew1UxtiWA+VuUeWtor0hx6JlX7USpRaqeYqI7BZ+tVEKIBLiYloheEBp2ZyqtGaSA6h7iwbowZyFu/OqMQSSO/7QuPzUAPqlzxNX7qa/LerhWez00ZB5N6Ox5iH5AS+jsUkwBlQSrEo/r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

The allocator now selects devices from the priority queue. Move the
remaining block-cgroup throttle traversal from swap_avail_head to
swap_active_head under swapon_rwsem. Check SWP_WRITEOK, the off-list
state and the backing block device to retain priority-ordered target
selection.

Remove swap_avail_head, swap_avail_lock, the per-device avail_list field
and their maintenance now that no consumer needs the available plist.
Queue masking and the embedded availability state remain serialized by
swap_queue_update_lock.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 33 ++++++---------------------------
 2 files changed, 6 insertions(+), 28 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 6f32de173fb9..d31f3f023d36 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -289,7 +289,6 @@ struct swap_info_struct {
 	struct work_struct discard_work; /* discard worker */
 	struct work_struct reclaim_work; /* reclaim worker */
 	struct list_head discard_clusters; /* discard clusters list */
-	struct plist_node avail_list;   /* entry in swap_avail_head */
 	const struct swap_ops *ops;
 };
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 21d27da95898..5c5e449e9da3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -96,21 +96,6 @@ static const char Bad_offset[] = "Bad swap offset entry ";
  */
 static PLIST_HEAD(swap_active_head);
 
-/*
- * all available (active, not full) swap_info_structs
- * protected with swap_avail_lock, ordered by priority.
- * This is used by folio_alloc_swap() instead of swap_active_head
- * because swap_active_head includes all swap_info_structs,
- * but folio_alloc_swap() doesn't need to look at full ones.
- * This uses its own lock instead of swapon_rwsem because when a
- * swap_info_struct changes between not-full/full, it needs to
- * add/remove itself to/from this list, but the swap_info_struct->lock
- * is held and the locking order requires swapon_rwsem to be taken
- * before any swap_info_struct->lock.
- */
-static PLIST_HEAD(swap_avail_head);
-static DEFINE_SPINLOCK(swap_avail_lock);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -1713,7 +1698,6 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 {
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1736,10 +1720,8 @@ static void del_from_avail_list(struct swap_info_struct *si, bool swapoff)
 	}
 
 	swap_queue_mask(si);
-	plist_del(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /* SWAP_USAGE_OFFLIST_BIT can only be cleared by this helper. */
@@ -1748,7 +1730,6 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	long val;
 	unsigned long pages;
 
-	spin_lock(&swap_avail_lock);
 	spin_lock(&swap_queue_update_lock);
 
 	/*
@@ -1779,10 +1760,8 @@ static void add_to_avail_list(struct swap_info_struct *si)
 	}
 
 	swap_queue_unmask(si);
-	plist_add(&si->avail_list, &swap_avail_head);
 skip:
 	spin_unlock(&swap_queue_update_lock);
-	spin_unlock(&swap_avail_lock);
 }
 
 /*
@@ -3910,7 +3889,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 	}
 	p->swap_extent_root = RB_ROOT;
 	plist_node_init(&p->list, 0);
-	plist_node_init(&p->avail_list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4326,7 +4304,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	 */
 	si->prio = prio;
 	si->list.prio = -si->prio;
-	si->avail_list.prio = -si->prio;
 
 	/*
 	 * Publish swap_file before making the percpu ref live, then add the device
@@ -4475,14 +4452,16 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 	if (current->throttle_disk)
 		return;
 
-	spin_lock(&swap_avail_lock);
-	plist_for_each_entry(si, &swap_avail_head, avail_list) {
-		if (si->bdev) {
+	percpu_down_read(&swapon_rwsem);
+	plist_for_each_entry(si, &swap_active_head, list) {
+		if ((si->flags & SWP_WRITEOK) &&
+		    !(atomic_long_read(&si->inuse_pages) &
+		      SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
 		}
 	}
-	spin_unlock(&swap_avail_lock);
+	percpu_up_read(&swapon_rwsem);
 }
 #endif
 

