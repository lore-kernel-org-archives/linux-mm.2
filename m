Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5639EC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 07:48:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 560736B00AC; Sat, 29 Aug 2026 03:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 510126B00AD; Sat, 29 Aug 2026 03:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426516B00AE; Sat, 29 Aug 2026 03:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3B86B00AC
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:48:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 91D4114065B
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:39 +0000 (UTC)
X-FDA: 85153529958.26.10FFD35
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBF7240002
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 07:48:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GhWeuMMW;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787989717;
	b=XT8jfAcnOH8f9RTCYizpffHBN28ckxRgDh3fqmnJcKxaCIqufVbCAqdaxsmD8ICZrKTblc
	5C+4bttklHA+UdCMau/Rh/zl5DGIgpGPLClGi84GzSSdIwMn5dMnpqh8e0dOna1kNFUGPw
	J437TLJM3nIMXNCvZVrTfMBN8HqIVIg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GhWeuMMW;
	spf=pass (imf01.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787989717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K0brm21TE9GssWqZ74Js94Ds6AVGqAHayV0XzsofN18=;
	b=PadlIaOZIGlwIeL3pLqKkS3K8Ri7IMP28CJQEr7kEny7BZ12pLhT4bygSCaydMxMhe0lE/
	OKjYWjLlfvuv/7wlIprWyrlKwyKWBJAG67m1UOvF/8zW/rhZ4hM8AUfVKlx0mKNwmVwIQn
	ZIzAeqgRSz4AYWiUJzIFja+xrOJPHtw=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c9aea40d799so1020579a12.0
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 00:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787989717; x=1788594517; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K0brm21TE9GssWqZ74Js94Ds6AVGqAHayV0XzsofN18=;
        b=GhWeuMMWbf8eqZCp3vWr2JqpE6KSpCDakoMSVAEXRIzaEfuVbUSe/bD1YtcaRwejNp
         /OInRlyhUP2+sHiXmCeyGcLuD70+khtDlegcGXR0CziEa8qocymrrLBkKU4qw/5Dd1V4
         MPBpZFfS1Zed6IA90WPuYjNDDzHYSi81UHdf0K/YohP5OaAMjwr8LicmX07GKPPLgrnC
         hxOdTk9BL4tUgEFGvZGINrGWJ8uYSQgVy2aN2As5XC9tQ7hLdKOiVkXiEkiTugbkYQfK
         oJZkpDo8TJntjsw5eFJEbooqnNjkNAdH+QvYL7hXPhHvbnSoVmCrFkT/CrevUmIBkOXX
         lv0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787989717; x=1788594517;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K0brm21TE9GssWqZ74Js94Ds6AVGqAHayV0XzsofN18=;
        b=IfzUHY7Rg8oCvfXSVHOcKsv9PkQoHy8CuW5K0mUyqMevYUmnLWVfmyiOMANLczo2HV
         1/J9+n8bYwGA7FfVpjF5fZ2XcwFO3fcEiXEPes/RuTJYCMmuCKrbFYzgkfcO9w0ZxD0v
         Uw0rAaFj4wkpYW0rzNnVBnrnWKsDd9S5wmmXVjhNGfhiYwkW5wQJNT4tur/L5Yajaoee
         rJorB9CUP5jnlOhC3IB5mZc1fuZ9F2b83CL8/BYNDrLA8Vgmxx6l5ESOeXHxs7fftK/X
         cg+qSOREl1jKhET2cOhn/q+11Q2O0osn2JhL+HVXCqgVee4zd67d7GYjrR8W/rGWM0If
         M6vA==
X-Gm-Message-State: AFuF++kfLz1IQvq6vleelv3IQSDzhcKq3Am9olDocsaPPtVBYV2KLPP5
	4QzTU1/pIPmkwWeFROCsflvqXyU9mgLHiFDh9usermi1GgZbH/XyCHVTuo4gBg==
X-Gm-Gg: AYBFou0vWxiQXbG6kQEqHLm15RGrBZQ/Ka071Zrt4XGNoaAqczu0GDqRq+3bxJ14Uxo
	qjurxFSmrV1jjW0OnY/WlhpbCdpCC2/utbTk7bbexArzQqvsRjiVBuHhwhJz7anWf4Y9uH3kpeF
	CNmurnVVjmQqLBYk9hJSEAZHbSfhTrstwgle2Nh8BFVl/3u4LdqcXGHZ2woM84/Hl/0a9FwaBE6
	iMAae3FebDezx4J3djH8xuqinccYJhMMBTKO0XgpHk3QhWicuyFru5QDLywGOvp1WtDyOyHYjl8
	4mE3DV9q9iqPfli8fOS3QS1BtolxmyA0zlCbKomRBIFuPVneXLKkg2NNaKjWoXvzgFmnAE5JeMx
	3M0PyRK+eTvhpGZKZQ9m/7XvHbeRKELn/diQFrmRNalzkUucufsN98MOzIrlWXYgjSjHUrOCi7d
	9FFT3WGHfRyKXyOFntt5FSGHDDJ0gg9MVlJlf6qhCqduE+77Pf1F+Oykw161OwaoQtzo90M+YL5
	A+x1eWjatErrUoUvc4GPma4I6h3
X-Received: by 2002:a17:90b:37cc:b0:366:10f1:3d91 with SMTP id 98e67ed59e1d1-396d0d92d0amr23218510a91.1.1787989716688;
        Sat, 29 Aug 2026 00:48:36 -0700 (PDT)
Received: from localhost.localdomain (vmi2317720.contaboserver.net. [84.247.152.65])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396ddca5bfbsm6256974a91.17.2026.08.29.00.48.32
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 29 Aug 2026 00:48:36 -0700 (PDT)
From: "Lian Wang (ProcessMission)" <lianux.mm@gmail.com>
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
	Kunwu Chan <kunwu.chan@linux.dev>
Subject: [RESEND RFC PATCH v2 12/13] mm/swap: drop swap active plist
Date: Sat, 29 Aug 2026 15:48:28 +0800
Message-ID: <20260829-swap-pcp-priq-v2-resend-12-68d3d925578c@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
References: <20260829-swap-pcp-priq-v2-resend-0-68d3d925578c@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CBF7240002
X-Stat-Signature: qhgsx34d6pe8c3jh4yyjc48jmx9qhd4o
X-HE-Tag: 1787989717-571023
X-HE-Meta: U2FsdGVkX18XBJo/+lW7mBEuvkR3KlA3C5PduXxbj3QHZpdP+RzuopC5BoUujrey8xJItzMc4rFN1TrCXAQQaUhlvtD9DDGHUbSAYdlk32oubv7b7Fp6TfwJgTLuExJldVOLwkT/OnALgIa+SP9Vq2CkBNqTKyvy9Jk45/VcCWD9Sn6v89wgRIG7cMUM/z8U+LYXZTnESYCjnvPk/+2VJf0PG6/lT20X4RZL+3Vu3+quAYzXBVL3Zd5SitXGnc95JA0u9Prlxk0UoM3yjIvFRxJYPrJt9uQuqH0xyD9mfxJK09/D3YHJ+sDupdeOrizmogTVKx6252waaLENM6+ffq8YK2RnEsnQRk9wuNydaBtqsNlr7Lsk5JDlHOnWGwY4PO1LV4z6lFNPCipXuQFVQXNAqWnOU40pOh9J20xd8NVScb7oer3CsADSeMuAMQbmszaaKKksrYSQs2xAzL61x819xgchiR2WVzUxVUyxIVdmOTNOKyZxPJ14UY/u4Gsj4Z0mgQoISTT4btVVfeQK96nQYzfu+iuJkM3m1D3k+eOp4IGzjEgY3tX6KuUsR3N6BXCY+vDOWtJVcRpVeNipfXd8PzWuLRg/sq7IHXZknPF/aWEepu9A+P3dXsFaF5MmonAmEb+ZbM5vtlySjBGamNZux9Y7V7qOVFI13p6JLWsZF1L7wScpuUWF08rohOec5E36JruUklS7VzNEeWMWNCUHWF72F2zBnf6S1VkBkpOvec9kyfIAXtNaJqjRDlrUBOfPd5XRsCn2VC7K+gQexliOUmwZjXwbZI35P+76B8GrgQd8HeCnFTIRkEmPshCOzo0KdOw416HWAqh32URj0+n5v8cs4tS/DeI8uY/49lzi8jHt1IxzSgGL9w4Ci5HIehvciUEISY3cvVOLcggeR4AKE6HlnSj6UIrh/AdVmuaHCibJIv8GoAiAwQ7cUb2fUJbeHLVoBPA4XAfjzHF
 /OFSReWQ
 9Ews13mKS7B5FbekFaxok0QZ5TtEtRpqVrAW8Urk4HldrZaqH0xWIy34pt8stHFuTuMA3HxMuZqn7OJ4mCQtIwMZ7E7PPCIdrsGzz1JeLmchyTmVd8LHW+2JSJRue/3WFzVxQyZuecy8uPWHV9NikivF/dPLX7m4gSaXtF+nok4tYbQvM+YvM8UCZlc/XFDL4VLfBH2OJI5DMmzrTIH/baYJ50ld15FLk0c5VaQfSLUTNVGiDywmqRqn5I+GtW5Fhc7sXBxYfKm4TwYYD3a8EZowShOZBj2m/G23HSvQLDy4loMUP0PxBH2iW9S0UAaTjKNY+pel52Pt+NBqgf6fnDXaVaALQDd41U0xzhwIa33UQm1cBglLD6R2gC4jtgS0nOvCc4jWYggic0b/Zo9JmWHfXjwk4NI/6qaJkTWkY6Z6sm9JPE6PWpGz5+9tbZ8Kcx+gTAbETIsIKP5veIPW43tPfNAX0P6uKOPkh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The swap_active_head plist tracked all writable swap devices, ordered
by priority.  Now that every consumer that needed priority ordering
has moved to the priority queue, the remaining users only need to
find any writable device.

Remove swap_active_head, the associated plist_node from
swap_info_struct, and migrate the remaining plist operations.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang (ProcessMission) <lianux.mm@gmail.com>
Tested-by: Kunwu Chan <kunwu.chan@linux.dev>
---
 include/linux/swap.h |  1 -
 mm/swapfile.c        | 27 +++++----------------------
 2 files changed, 5 insertions(+), 23 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 0c8c1ebcab9c..9d86db144b94 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -267,7 +267,6 @@ struct swap_info_struct {
 	struct percpu_ref users;	/* indicate and keep swap device valid. */
 	unsigned long	flags;		/* SWP_USED etc: see above */
 	signed short	prio;		/* swap priority of this type */
-	struct plist_node list;		/* entry in swap_active_head */
 	signed char	type;		/* strange name for an index */
 	unsigned int	max;		/* size of this swap device */
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index cb27f2e246f0..0acb1f31df8c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -41,7 +41,6 @@
 #include <linux/completion.h>
 #include <linux/suspend.h>
 #include <linux/zswap.h>
-#include <linux/plist.h>
 
 #include <asm/tlbflush.h>
 #include <linux/leafops.h>
@@ -90,12 +89,6 @@ bool swap_migration_ad_supported;
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
@@ -3262,7 +3255,6 @@ static void __swap_device_enable(struct swap_info_struct *si)
 	spin_unlock(&swap_queue_update_lock);
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
-	plist_add(&si->list, &swap_active_head);
 	add_to_avail_list(si);
 }
 
@@ -3282,9 +3274,8 @@ static int swap_device_disable(struct address_space *mapping,
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
@@ -3309,7 +3300,6 @@ static int swap_device_disable(struct address_space *mapping,
 	spin_lock(&swap_queue_update_lock);
 	si->flags &= ~SWP_WRITEOK;
 	spin_unlock(&swap_queue_update_lock);
-	plist_del(&si->list, &swap_active_head);
 	total_swap_pages -= si->pages;
 	atomic_long_sub(si->pages, &nr_swap_pages);
 
@@ -3641,7 +3631,6 @@ static struct swap_info_struct *alloc_swap_info(void)
 		 */
 	}
 	p->swap_extent_root = RB_ROOT;
-	plist_node_init(&p->list, 0);
 	p->flags = SWP_USED;
 	percpu_up_write(&swapon_rwsem);
 	if (defer) {
@@ -4050,12 +4039,7 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -4176,7 +4160,7 @@ int swap_dup_entry_direct(swp_entry_t entry)
 #if defined(CONFIG_MEMCG) && defined(CONFIG_BLK_CGROUP)
 static bool __has_usable_swap(void)
 {
-	return !plist_head_empty(&swap_active_head);
+	return READ_ONCE(total_swap_pages) > 0;
 }
 
 void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
@@ -4200,9 +4184,8 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 		return;
 
 	percpu_down_read(&swapon_rwsem);
-	plist_for_each_entry(si, &swap_active_head, list) {
-		if ((si->flags & SWP_WRITEOK) &&
-		    !(atomic_long_read(&si->inuse_pages) &
+	for_each_avail_swap(si) {
+		if (!(atomic_long_read(&si->inuse_pages) &
 		      SWAP_USAGE_OFFLIST_BIT) && si->bdev) {
 			blkcg_schedule_throttle(si->bdev->bd_disk, true);
 			break;
-- 
2.55.0


