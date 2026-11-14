Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE7F8606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:52:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Nj4OHJKx
Received: by kanga.kvack.org (Postfix)
	id 1EA0D6B05C5; Sat, 14 Nov 2026 09:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19A6C6B05C6; Sat, 14 Nov 2026 09:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B6E6B05C7; Sat, 14 Nov 2026 09:52:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D64136B05C5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:52:01 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 642F5C044F
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:52:01 +0000 (UTC)
X-FDA: 85434014442.24.4869AB1
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf31.hostedemail.com (Postfix) with ESMTP id 9456220004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:51:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Nj4OHJKx;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GioUseZHzqH/AOOE2IX8pcEfvZptyLPBBSCPC7A9cg=;
	b=UR1Fj3ckKQKxpeKPQrxvn+cMEYD9Lr4RhxtZ65lJQ7AXQJs7ydT6ieJqHAaUcb5OzhZXBz
	n7319LgGUE0R35W6x4S6dxa73HZihgDDrE4oj2j19TO7r54zSB0AMQolBd/JTjlYniCreg
	9WvMusKUvcc0WfTcDKfOL4II2jfVaho=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667919;
	b=KsmFDsY+W3eKoLWDcoi9zqTK24v4W/aR/mAFTnxuBK+pI6jSaCmTSpIvgqjSPM4TSN0Kbr
	hyPNk5djfUQcujOQ+hy+XDbOlQeIZ1H3k67pxxBBSuwQRLkDF69B0qbFB9pK80d1rVkpf4
	AUJyTY4MbYxOUhgClk5NzkDCTmR7OlI=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Nj4OHJKx;
	spf=pass (imf31.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cdd9e925075so985389a12.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:51:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667918; x=1795272718; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0GioUseZHzqH/AOOE2IX8pcEfvZptyLPBBSCPC7A9cg=;
        b=Nj4OHJKx3Ht6Kzh0ga7y2amEQH+LXk1ZcLRkgIfx6Ybr58dtz7/5I6FQxccxa8FVle
         e139Jc20WqdGdKikeefhBT6+Ygl2kPjUho9/lAoK/9fI77W8/7v2VBmjOByWIagnQ9y+
         TyBUUL8tLKTZgyaToHLOgziOAlMfxMQwpgk/mBEzM1fxreob8FoR9WH5M3WNWWaKnf9v
         bwfGwF5IYwXRObgoSqQPNspJN6hVTvK47N2OUq+iCzGZWhI9iKx4/WaS4j8XkA0PN5p6
         NACYt8/AeNIH4Sf7o5PgYY4590Te1GSdY974FrMsfFtnr6NwV6doOp0pSNXjAGUNrooE
         SVXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667918; x=1795272718;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0GioUseZHzqH/AOOE2IX8pcEfvZptyLPBBSCPC7A9cg=;
        b=ttAAIMrmH/KNaSH8CGiXXbSOYN8qjcC9w5Z+BQ4jV7gMeDFQ2wR/EZ6GFLcOyglh1A
         LB7Dvg98ciS10UQSt5X4GoMNUefsIq5a+nIBQXMFqGgjG6m9VhITaCVsPHN2pkfZFKqq
         a8gjcOJfrc/3lDXnXASWAOVijOf25c3b8j5UfHSlDO6DOyBLaboYBd77/5rxSwz1SUnp
         gENayYRntkCnCrLxBMCiKPj27WANNtBwQHMmP0eBlhnAE7kGun1XcMYoonsQN0UjM940
         c6/8DBvt76bxZhC2Hy9k1N8UyBNyIJqRLlECf1Ckvnr8q1RG9mEatly/m117eprlFYzN
         n7FQ==
X-Gm-Message-State: APuU4Z/qIyRKwxSMONV5HDLuIt3icMPK2qgSR0VfTbo6jCyvtT6qN8cC
	+24QBPb3h3MTBEKRBkmeUike/T/UAZrs68ZGb9+MDQviX8GVaaFONiuTJh5EAQ==
X-Gm-Gg: AYBFou0tgn3Dkrzn7ooHxnvGQ54kp62zcsqocBeQjwNLKtb7yp4Np8ZgGuRbDdmI97b
	wtq1STuU6Ltj7f7XGME92ld+jahetTSX5beYz2cdFaoVgEl1odogLyBEfM+JgWgOgKMqKMpa8OV
	1+FSQSnEUvya2duiUFe33J8CV55tbQXpWsneSa1SBj+B+ThjMkKjrmoOxLRaKt57jSKF1soS6Vm
	nuluQSjBord4ejm5kl/jXidBGzdLFRYuQfwgN/2ZeAjA/8TRKrPuY2+j9DAa+f5PcK3Ab6QxFbu
	b7bBtKefoL2fl5+HOdrVf/MLa9H02GRCUwBP2FQ79b3sVhaU9ENWnVhauAAYg737FwcWWeuV6X3
	qSmszU4cSMSK7hpWwlISSGaRletVjGGoY92pzus0Au8CWT7edcD7hwTMrdjYzijZ2xDPeRWKB6B
	M1aR7qSfksls6qAhaEFTXqf7ALNl3PHMzKbxe2GJCK80rd7ncdp+zDjlWj+P0drwMKgZtsS+l7z
	DXDDCB4WtW7h5mZONNED23ibgMYyYvbOGWFVkSkgCY96UDt+cjBA4JUUrNAjGdD4tgaRsGRERfK
	gB+yRtT3rgbSB3Xt3XlBHskC71jV7EWXyGK3xnM+qo6XJ6zdbMk8eEtEzI60FkMqs4oC
X-Received: by 2002:a05:6300:6cc1:10b0:3f9:797f:3869 with SMTP id adf61e73a8af0-3f9797f51e7mr916044637.47.1794667918330;
        Sat, 14 Nov 2026 06:51:58 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cddc160bfabsm2392057a12.4.2026.11.14.06.51.51
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:51:58 -0800 (PST)
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
Subject: [RFC PATCH v4 13/18] mm/swap: drop swap active plist
Date: Sat, 14 Nov 2026 22:51:44 +0800
Message-ID: <9ccd81f6f036eb1c3e50d396b44b5e43cff77d2a.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n83eet6atyqmxwirsqjkmtrq6wgmwxx5
X-Rspamd-Queue-Id: 9456220004
X-Rspam-User: 
X-HE-Tag: 1794667919-645175
X-HE-Meta: U2FsdGVkX18PgOFheFJIUuzxqi4Ct4pE4aXgwmxHGujkvrZ1m1ldsAv/pBXou7MtIBuRjwG/BUxrhUS+TjnNa020PGDH+yHJVOwI9YuVhGsSVRSktsmc3UJx75wV4ebKWXM+ag4XLThcTpFwGWa5yCq3FZrIzLFZSlOSNuHMdjZzGK9T5zj8zAdDX9OB48/aCtJXC07BqnmZB9Fxf/HQM6b+cWU1IrrgdMolK7quRw4Ey4pf7SLk8EV7t86iIPYt+0lMB1Yiv39TFnHX9QNnochSqKo1tbiSv9jpxnKfyTPZ/x1ZqU2YE7Uq5CtLTPubi6gBseSRcUNKDXtO01msOaa+olS3gY2pHWgscFrigQppboF9fUU0Zalu1FJaDVIwx8L+bSKG8sttpSSiz28rFWv7WJ5Jz420g4CmJsqrl+YT8gBm42pEpRbMweMJTKceTZlPTkwLSEzIei9vn1pfKECJVud+w6yDCBYtty7inSzrGbKVYokZIvdudvFdIgSMl3028sRqbrVTIm1uwXz2qX/oATAKlmMhT4tb62+0Q4OaLSIKQkD1ResV8A2iWBaI6CiU1YiVmGGZaPnoeeIIadq2rNf6Uhp/oLwNa1gDBss+DJTkxVTXlX5VPEZIGZvlfKRavNoPM9EPlRTSRT/StxUqcf6HD/33qUYG4aHR8Qy1PgK4s5YTh3EHimAApuqUNhBxSinBWO9Ljj/ElOyrYwKcHc18ydouZmxeBEP79V7mvJoPcpVUy4mLr9TuuFR9F2oonWZMfka3SX3+v/cViccnr+Br/CIxDtitML4IMMk1WwwBtxFTtfckgR0fy3TIYOYeWsTjrSjXfb5x4KizlSU+THoNkAQi2VMxWNK8qxc5aL/wdlpe1yCuArQ2tsE1gGCDcUfH2YiRee3GuXXvq+OeShNJbAKStopUOM8PVlhFo0GMvQ53L7rdYOA79hjhEcBhUW8Ke3CYSdSFEsb
 y3TMPTZe
 ewjlitC8gUOZnXrIgBesMGE3Gk0wtEP+VDiqS1J+TIoFJjsYe1aLUmUwlyUMYwZVo16cMlN3vRZYoSCgsyHhxjs7j/l9SHVpEJDdFWX1Qwubq2Yoo9ag44JRT8kYb6wdi7DN4qRsFZ4TN00aZuvAkPADKIQ89r5X6gWrn0kZcAJ7ggZjj8/i0x+Y6/U181uNrQYC3lMsEkHGFe0JOllOdpQkk9bRoxp65x2xJhwYf14h3ewrGruLxCPdUMs2L4SS8d78c9mTpvcIosmxpGJR3q6yHufFH9uma2Sp6GAMX9+5JhvkIcrmHYTZdgnt3BktjfpnDL51ueAaL1tRv9XMJRaDP+G9jPa3ExoOhLrcjtToymQX08Wz4bDzQVyR5Cg2EGRA3eGwfbzNZAAx5pQN6gprvSscK9+OzjN7f4euBBSU45Bmgm/8sN+i7ea712JrIt5N9dUsGAOnOy6UmMzAmlfssh5bccA8sYPWS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Remove swap_active_head and the associated plist_node. Device identity
lookups can use the writable swap_info iterator without ordering.

Keep priority ordering for the block-cgroup swap throttle target by
walking the priority queue under the topology reader. Choose the first
unmasked, writable, non-offlist device with a backing block device.
Check OFFLIST as well as the pointer tag because full transitions can
temporarily leave an unmasked entry, and keep the explicit WRITEOK
check. The disable transition already publishes its mask before
releasing the topology writer.

This read-only lookup does not consume per-CPU allocation quotas or
change retry cursors. It avoids making the throttle disk depend on
swapon's swap-type assignment order when devices have different
priorities.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 60 +++++++++++++++++++++++---------------------
 2 files changed, 32 insertions(+), 29 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index d31f3f023d36..ce8a800751ca 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -263,7 +263,6 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* array, one entry per cluster */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6b2dbaf33cb6..bd098114ee4b 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -42,7 +42,6 @@
 #include <linux/completion.h>
 #include <linux/suspend.h>
 #include <linux/zswap.h>
-#include <linux/plist.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -91,12 +90,6 @@ bool swap_migration_ad_supported;
 static const char Bad_file[] = "Bad swap file entry ";
 static const char Bad_offset[] = "Bad swap offset entry ";
 
-/*
- * all active swap_info_structs
- * protected with swapon_rwsem, and ordered by priority.
- */
-static PLIST_HEAD(swap_active_head);
-
 static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 {
 	lockdep_assert_held(&swapon_rwsem);
@@ -3535,7 +3528,6 @@ static void __swap_device_enable(struct swap_info_struct *si)
 	spin_unlock(&si->lock);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
-	plist_add(&si->list, &swap_active_head);
 	add_to_avail_list(si);
 }
 
@@ -3555,9 +3547,8 @@ static int swap_device_disable(struct address_space *mapping,
 	int err = -EINVAL;
 
 	percpu_down_write(&swapon_rwsem);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if ((si->flags & SWP_WRITEOK) &&
-		    si->swap_file->f_mapping == mapping) {
+	for_each_avail_swap(si) {
+		if (si->swap_file->f_mapping == mapping) {
 			err = 0;
 			break;
 		}
@@ -3583,8 +3574,6 @@ static int swap_device_disable(struct address_space *mapping,
 	spin_lock(&si->lock);
 	del_from_avail_list(si, true);
 	spin_unlock(&si->lock);
-
-	plist_del(&si->list, &swap_active_head);
 	total_swap_pages -= si->pages;
 	atomic_long_sub(si->pages, &nr_swap_pages);
 
@@ -3913,7 +3902,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 		 */
 	}
 	p->swap_extent_root = RB_ROOT;
-	plist_node_init(&p->list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4323,12 +4311,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
 
-	/*
-	 * The plist prio is negated because plist ordering is
-	 * low-to-high, while swap ordering is high-to-low
-	 */
 	si->prio = prio;
-	si->list.prio = -si->prio;
 
 	/*
 	 * Publish swap_file before making the percpu ref live, then add the device
@@ -4454,7 +4437,33 @@ int swap_dup_entry_direct(swp_entry_t entry)
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static bool __has_usable_swap(void)
 {
-	return !plist_head_empty(&swap_active_head);
+	return READ_ONCE(total_swap_pages) > 0;
+}
+
+static struct swap_info_struct *swap_queue_first_usable_bdev(void)
+{
+	struct swap_prio_ring *ring;
+	struct swap_info_struct *si;
+	unsigned int ring_idx, dev_idx;
+
+	lockdep_assert_held(&swapon_rwsem);
+	for (ring_idx = 0; ring_idx < swap_queue_len; ring_idx++) {
+		ring = swap_queue[ring_idx];
+		for (dev_idx = 0; dev_idx < ring->size; dev_idx++) {
+			si = READ_ONCE(ring->dev[dev_idx]);
+			if (swap_device_masked(si))
+				continue;
+			si = swap_device_unmask_ptr(si);
+			if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+				continue;
+			if (atomic_long_read(&si->inuse_pages) &
+			    SWAP_USAGE_OFFLIST_BIT)
+				continue;
+			if (si->bdev)
+				return si;
+		}
+	}
+	return NULL;
 }
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
@@ -4478,14 +4487,9 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	percpu_down_read(&swapon_rwsem);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if ((si->flags & SWP_WRITEOK) &&
-		    !(atomic_long_read(&si->inuse_pages) &
-		      SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
-			blkcg_schedule_throttle(si->bdev->bd_disk, true);
-			break;
-		}
-	}
+	si = swap_queue_first_usable_bdev();
+	if (si)
+		blkcg_schedule_throttle(si->bdev->bd_disk, true);
 	percpu_up_read(&swapon_rwsem);
 }
 #endif

