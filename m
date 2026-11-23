Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB77606A335
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a/PNMkW3
Received: by kanga.kvack.org (Postfix)
	id B5CC26B05CF; Mon, 23 Nov 2026 09:19:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B348C6B05D0; Mon, 23 Nov 2026 09:19:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4AD96B05D1; Mon, 23 Nov 2026 09:19:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 780B16B05CF
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:19:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0329E1607BD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:25 +0000 (UTC)
X-FDA: 85466591532.07.988119D
Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 379571C0005
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:19:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="a/PNMkW3";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443564;
	b=2SoSpA9y2lH+YjCoMBaG1KcU9fTIbJaptqGRtHNcKlFhSG1hvNycgYfoW4Ya6zvOIo2uPJ
	2L6klFtuVhY59MKhJrdNzHUopV16MsQF9K985EYfwyQDU/L06UDaer+xCrjKfsRW419O2c
	orka/UDxGEavEn2Hy/H9ipyGTURZ5GA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AWoQ0K2b19xOIDahw7K8oHg1peK86ncFA9KLsX9V9fY=;
	b=dWu2t610S3nWBxFbzM/9wEGmdGrUQIeYvjeute8oK60H9EAH8NrUyCxuFk6dq2/fHZypkX
	t7qXKQ3fEBGPl+vHhLbbyw2WgIsD3SDtkMa3FajStHQVGJ5QhDzC/0E2MJhe55GxPsaWRk
	MZDHdSiAxRNgPtDfL15KFPW2PFun59o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="a/PNMkW3";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.43 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-1b3acec6677so4682539c88.1
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443563; x=1796048363; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AWoQ0K2b19xOIDahw7K8oHg1peK86ncFA9KLsX9V9fY=;
        b=a/PNMkW3PL7ClzDv+DqcWSjviqkIvaZD7+rTSlcTXgaD/7oE8qzB4FtMDNeeEHtQY2
         ThZ3Te0YeEqlVm7QZs/mfDQzIgtJ3cxZjhUWCtctA/YG/rvcMMArnLaxaddzLwc6Ooy+
         22HYDBWen+W5Suznwjz2iOKMb8pl8cuZlTyUAA7x8r8fLPzPHFRHRuzWZ5DG4rlQuM5H
         C98wgbt+s5Dfp+wgvMqv1AA0yuB9KeerLpCMjYi6zKvAne7+ET/1L3pQhQJSwsjLDrN2
         rAUkkSbSYBDBt/Hh57z9jOJF3l8eT9koVUu+ChRM8pggtJUFyOXTZ2t5pQUXfz3WrIkG
         +g1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443563; x=1796048363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=AWoQ0K2b19xOIDahw7K8oHg1peK86ncFA9KLsX9V9fY=;
        b=qhDchuHGF+pN9xJe0N6Y8AIFuDjXBUod8QNt7tHi+zcb8Af6OD2dV8xQFr+OTl9AnU
         4m4RCrJ5LlnXyUx/7meGVd9tIgJRAz1Yr1NiTSg/BCQ2WyRo637guKVJxBsQqFi5zYac
         Xf++igwnLW4Yn3bzyE+sHSYgYK7oULylqb8kkRnzgSEWEKotcpb8mFNzmdl1Jx7qXNOf
         Lk9ZYtNPG0IH8bYvQJluk1zDK2kgYKl2SYpTUDNLJSb8sQZNx/uYSr48vE2UwF3AzhO/
         p5p4dRyekxmcZkd/koVHamnZ0V2pgrjYN0+FO8m3IwjfPwuIVSYrq7ti3ufSXJsiueQG
         AA1w==
X-Gm-Message-State: APuU4Z8gF8YIAgIA0mcR8TGhm9bi2npZT0hk5A4JvngxgBVUqPtOLR19
	3EjngOTy78UIeCwJwdkMdIgKoNTqzFaKSKAehAma70Omawf06RjyaZsQ/8slasaQ
X-Gm-Gg: AZFdTZfUzHoAAgl8GQsnQ/OHzb6EVINPPElm/tOgvUzOzays2EE7C9z1L//IuFdASiu
	dQaAHPTtaLC2AreQqLQs1sE+5/gqJEKAexkLJe2SUEJ260cZFCnDmF1TYxhX5p7Ia1/h0ZC4kiM
	n4i/3gn2tIVhmpN15n4QU0syO+xbkGoXzgOEDzXOX6Y/IXrP4SFT8k/Xo5rLe9XnSUY8awEwj43
	hob+B7mCCB3lCocub4u0iVt2HpOk4PKAC5PsppmkilsSMhayivphHCEgOuGUrRy0LsTaM2NvxSE
	CF4h4BZb69CoouQLdZBOZeFdDHI43SnLXWm52I2ym/6/HIzw2nMZ7lgwQG93HHJHJ/9vSIxTDCn
	V1GSOKxdfLyQitUef6DDQVDJsIpVEd25l14RqHigg8GFJnEVVuTrdcE0GUlbUavE8ZoVwwQ1rGv
	gg+Rhw7/qf1Y8j3827pGzmfg2TVh/1ZUDgPazV8Rv3Ug7jVZZX+9/vY6t7qB8PE9Zkw5VbhxLy/
	n+UYRk5JrWo4ePkvfvAEMmmI9FtL9tehQysaKMM/FUVX86UpqBx2vomF3qYl4qOoKEjDti3z1Zx
	J78+GCN9oUr98GKNT2HjaEpwyHE/iXaakp1e7hEfL1Wfp/dPJ9mys1JxlXVm3cygf+dO
X-Received: by 2002:a05:7022:299:20b0:1b5:7c7b:c1f3 with SMTP id a92af1059eb24-1b57c7bc2a9mr256829c88.15.1795443562761;
        Mon, 23 Nov 2026 06:19:22 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b556847fdasm32516063c88.13.2026.11.23.06.19.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:19:22 -0800 (PST)
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
Subject: [PATCH v5 14/19] mm/swap: drop swap active plist
Date: Mon, 23 Nov 2026 22:19:11 +0800
Message-ID: <31eee155bb6d4100e78a071cc101b6afd48feb17.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: owhaq4nrgagmez644nseywscxzkxcgnp
X-Rspamd-Queue-Id: 379571C0005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795443564-513158
X-HE-Meta: U2FsdGVkX19bEwQ273zj8yxjPjx6by/ubmTX11KKJ/GaYo6NS1AgsflIqbV31bUF+6fA1lRdwQhWHQGSuug271ZQ1na23vhjSXFsazReaSSbDW8kpRVvFOm2BRSBIYwk42XpC5fG6P4IXlo8Icv/iB/Go6tCCMZ+jnlat8YVetMxJRKB1cSFmOYTcnVeBsvJZlnJKF60BVlMmpkfsORSIswknxxMvZl3D08Fo20KFFi9UKTCwaf9DcfhUpQ7DauWwK79sHJbPerfgdLlU3ll5QrTCQxLfwKsblhKsgwHsFL/twJEgr+K/7QzxjUpaWBx8I1otUmoRFW7Ag9lSEzb8eJGzbP65ukU3MEyKLcT2tYKUsGi5xb0fv3UgqwQyDglrnoeCXvCQ3XgyvzachwW6MyyvXIp0lvObOcoe+U/lC9j++podvmD7DG3NwIVJROxinDFrbphvla1ryRnLgJTs3f/htNifICrwQ7Zjj+uihkQ6prgWaD7EXSMIll0jhN/hBdVo9a4hx+9A5HiRQUmfU2zoS754QVb7Ss09R6jRzS40RLo0Pf11AkyNUkZ6WFGqO8W8HWdFdeF1pzT2ivV7dDuiqCdvi+40iP3jSWNLxym0k7HkHRCUm/EEAKp7fdVjQdeMX0iecgkEN2LQ+1F6BXhDFKSEKkqA/Ijm9ZFWUkQrXyv/6t/3E+7J7zJfbZyOYbSkYZmTnNH0qkwhG8wmcVS9gULJqzwxjnmLtX9tpiDAow1yoPGAWu3aq//FZ/R05+//nZMzpq4jyK8V3IigBHj7PiQ5nHSQ2CeaY52UekyxrTngDI4M0a3fNr95/5ft5089QYjtM7X7oMA+d6gcMWpF4AALj5l6l8yWxDku6Jtf8b9aIgC3wWrvFgM70KDjECBLtY4RlCbK1GQbcIZczUo2r7X5IseYGVdfwd8e2TNdFaWZy7Td3MidMEQDN6YuF3PDyt0yteGzcYDE/C
 tA4K3gYz
 i/k3xoDTMKoxekVsJakYA/Tb+SQt+RICjiGGVI0+SdiGA9qfzYwdG7wEjET4VVQzJ0rRBctzIBKhlQ66KdmBucgliCti3hjVQhaXpBIL6cZ/oOJKlQYYWhK49/hAKcvOK0R5/1e93kYRhM1nDfSdM741oPUk7fmGcTBfuobcev2cv2QdwT9Q3ImcKvQ3i7Vq3yZamdlS45YB459V6BWEKtgRwJsyhlEXAwE9bs3t03E2L13eeGZbq540BEwvkw8Xi247Ztng1jeErL+FnPk3OP6pFhJBUt0J0cSzC40ltQBd8FdwUT035oyso7uJi++YWxTE8onTuFd2V59nUkDAOIHpRQLc6HxYrnpoZhH/OJwRJCRfb2wj3P73xK349wpYGp4iO0I7dVdmBIhaP0Wlmlbv0qXzIk4lMUkV7X5vwlck4JE3SLPGyTyRvhKp7doShbPSAOTZVkABKMRf33aHXdpSpYSMwqwRF6hNzrq+9RgkOR3EGbIaoX52PDzYYZQfTKELirG/tzJkDPN6oSqgDnNpP48wbUXXtnJ5FqIg5zmEd4C1CwR0avPJkjAR7jrK6fp7GrroeLPNcAqCOddGe9bobwJy2DOtfKdyk3E0wK5RL9HddqERbdWCkqQfG0yIcJdGLJsgvqu1+n4lMlbrRfBa0yz6FfICRteomW7T33k6RcedDPiSWrD5xCA==
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
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
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
index d28dd10c92cc..7d932035c961 100644
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
@@ -3533,7 +3526,6 @@ static void __swap_device_enable(struct swap_info_struct *si)
 	spin_unlock(&si->lock);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
-	plist_add(&si->list, &swap_active_head);
 	add_to_avail_list(si);
 }
 
@@ -3553,9 +3545,8 @@ static int swap_device_disable(struct address_space *mapping,
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
@@ -3581,8 +3572,6 @@ static int swap_device_disable(struct address_space *mapping,
 	spin_lock(&si->lock);
 	del_from_avail_list(si, true);
 	spin_unlock(&si->lock);
-
-	plist_del(&si->list, &swap_active_head);
 	total_swap_pages -= si->pages;
 	atomic_long_sub(si->pages, &nr_swap_pages);
 
@@ -3907,7 +3896,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 		 */
 	}
 	p->swap_extent_root = RB_ROOT;
-	plist_node_init(&p->list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4317,12 +4305,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -4450,7 +4433,33 @@ int swap_dup_entry_direct(swp_entry_t entry)
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
@@ -4474,14 +4483,9 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
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

