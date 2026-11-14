Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60C42606A329
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yOuR5Huh
Received: by kanga.kvack.org (Postfix)
	id 2F7016B05BA; Sat, 14 Nov 2026 09:50:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8086B05BB; Sat, 14 Nov 2026 09:50:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170116B05BC; Sat, 14 Nov 2026 09:50:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A808B6B05BA
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 09:50:12 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A225140430
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:12 +0000 (UTC)
X-FDA: 85434009864.19.353A38D
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 462E640007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 14:50:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yOuR5Huh;
	spf=pass (imf11.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794667810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61DsEOxba8skZR4p3LqyMSQOqgKdFaCOdElEjJjoWTU=;
	b=2dspbeN/+iRbgrVJFyijnca7byJ8OlMiHFL7HWbM21n7gwuKpz5cr8C34A+iLszSmL4ai/
	YmlW1n/O+hDiOVr288BxNE8PehSNfs5CqNL1P4jPxFb9AdXxbht9PMqyvzL23Qd9t7trUD
	xqv/ZGSnzEHmZIqJNgKnh1vBmXlqxbM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794667810;
	b=CJk/n8Xee/00L5SCHQRaaAYwNg24L00LJU4dxSryetMBUGNblHPjzYIZnT74KMlD8XyUPh
	u8ebOvHKsqZwpVSM5fD4CzyWJD/urmHp8vezcmHSmAZ1MOadDeykO/jmlSEKjcNeA+GirZ
	/PrgpVCejL2pAx91LYxJw2Q7uFc+oSk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yOuR5Huh;
	spf=pass (imf11.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ed2bfe3252so7063255ad.3
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 06:50:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794667809; x=1795272609; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=61DsEOxba8skZR4p3LqyMSQOqgKdFaCOdElEjJjoWTU=;
        b=yOuR5HuhrOlz4Tx4hCf/UndqBKOKw3gkqFqo1Wpgxi+NJfmBQPSU2kuqTYaTwRz2H3
         fLMqLadDB/I+yiFUAV2C39eSgCL9Cm/P0RmIO6CGv2gCf7ddTNyDVtShAKwCvB/bKON9
         5nb8TkZsoX/LqSMoD/rBDJkL9zt9Z0M9dxyOseyJFlr1eh/sp5DWLjnyfjmubcKuJkbC
         H2FBW+6kznpx/QrC5z4tbKuJtSj7w6kDlGS9yUiYPeFrUYHWjt/j1SLcwnZFfz4Et3lP
         L9jKOaLu9mkiVF0q6pAPFFyq/PEbc3nbk6jRb1R7qEL+9YMx4nWyE+PO7JJssUhmtDiK
         0JOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794667809; x=1795272609;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=61DsEOxba8skZR4p3LqyMSQOqgKdFaCOdElEjJjoWTU=;
        b=apmxMVFHAcmSieeayJ7s5sGAEOvW0rZbHd6OUZENqnUm/DitjGa86JnzYFru/ioQlZ
         FHsuwsykdBgO2puP/+xLge7bNp42DXtm9wyFt0GvJRRfPFDvpY/1nkCBIltdfBQZ7qDd
         8WMOpIIpUgctvjkfsa5O0NyS2rdGQ+SXVCt/8YH+SISOmFjAYvLx+eOs0iNVJggQ4DRs
         lA/1jvfEUDF98NXRS7/GIflOloNqAe3PbQlx0PHE4Vs4j33wGHFRyBXTLDhuV6/k/eSi
         /o//DbjAw/Fs8vJ90EC5QS2u32GEeCgAqQxabi6UavfF9kp7sP4ZauEchMXs2CljTM8F
         hofQ==
X-Gm-Message-State: APuU4Z+AEU6T2CAT29k3onGRsRPfIX4DRbEAJAMguhn/XNKwO08tOBlv
	wsCbkqzRuIlpERMddEOMNAj8OQ/thnaRFVfNOsgop2ZNThaV08novUaluaQnag==
X-Gm-Gg: AYBFou14Aykg07z3s605/Zn+mliwNco0DFCL9IVBpIP8o72v0e9oAeVOCrbKla1JR2u
	DdC6/NIFEhgPUOokAl2/sCg6Z7eF/qRQBPNZgYMNtz02DirrJwut1kZk+vcT7fodRJ+iTAHxIDQ
	rR1KGATyy900hcDQgAEORSN834UEEEXBLWIoUYIL2nJKnANiSieHHj2STHKqRBev4eK3nKWEF2F
	yRodqfM8pTG+7fyAkZ6GVwFJEKD6HMR0HyCyfELosa/JbGpgdf0/QomSQT+ND0l7bkZ2/+CE6iZ
	q1Y4+ACkXn0BKj6/4AQ2fIWNxmBAkk41wqJv7VC65CJiSFbgc4YkqQRvcMI0wmut03XeNVt0f6k
	9XuRf4+cbUJAtvYcaPptCxjkeo3+kcwKsvtF0KPu5zBgoiayxf1FyQoiXO3rexbRx23gw6CPkXw
	Ri3NWl8vhLnnjCSG8sV6YFifa6DH56+RwYP96ceLe1hQngAnsv8ujoZ63ImXL3XUGZ6SW34uvvv
	0+YBEpieu9EH4WU3sSloG+RWIJ4KWkDlW7pdkWKHJ/2pdRxxXn6q6XL6S0kc+b5Ik7BzIsgbXD0
	qAeEHa4mFHZrPP4faZ0j+S0bVgHEchSLqsk9e1BDBA8RFF3hvjY9hLqGLrCk2VBNCCub+l4FjW2
	VlHRdmtKE6SQ/cQ==
X-Received: by 2002:a17:903:1904:b0:2e9:61bf:6587 with SMTP id d9443c01a7336-2ee0df758b3mr57253215ad.49.1794667809095;
        Sat, 14 Nov 2026 06:50:09 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ee0fa3ee33sm20913015ad.76.2026.11.14.06.49.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 14 Nov 2026 06:50:08 -0800 (PST)
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
Subject: [RFC PATCH v4 06/18] mm/swap: serialize swap publication before removing swapon mutex
Date: Sat, 14 Nov 2026 22:49:54 +0800
Message-ID: <ed10255256780c856689549e65654f8b01d40c2e.1794666741.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 63ccjpad7ftyezb5ibrj7x6j6z5bmye7
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 462E640007
X-Rspam-User: 
X-HE-Tag: 1794667810-244636
X-HE-Meta: U2FsdGVkX19hNGf7cBXq9Pfc/KDI8QWz83R1BlA8VIvFOp1/ljBg1Bt87mEBgigxvKSBkU2p+ZTig1cCTwtZ7mUb45abFBqR/xEzJalpiW72FsIuZumhjIn4xDMTDh0cj7Cd3jGiKsUc+2niiphx73DsibVZfbiXS5A8clIaKKLKu69hhiS/LU0I3KB8zAuSlKedqn3V9HtkXzbxB1c1GqnbLTvH+YB1vD65DxJNftJ71Fmi+vFPkOMl/DnqWZPvZqyMZYvrR+b36yqJ9m00WuHRslI2mcgtkB3qawz8KQWZQWfHMLot5hl5NOfaQx8K1e2LqhRHsaW2VOHIqUv26SATyQkamaa5bFqSXAOorn/dWuWL6OSlz5DNn3FqXyRC/a61pNaZQ6jPwyNeN7cS53wpd1IEdw1BmjcE2n3iDxRUq/2onPQz5kIcmeEiJIMk+VUedrBM899FHyD8rwcWhhi8iEAgj9DQTyhfQCqXyTMvEpD0OoyGb6h27xHJLd5q9ydaChRVwuzZQALGohsCw3ZQLCvzR8irYxc+UV+39T/6juocQE7rXIBnQXDZ9UVuJV03+AuEnJvsZVYstWbeJS1mwOa9+nwi1b/34TKzseweUZiblSa4q0ygZ3QxKKv7dd4iN88dked2/s3f50ejBgt/c5SlM05TWCmNIHwZNb2E5v2naOXCU7T/beu2PL9kCKQWYiXDgibQA9kCwQccVQCy76ZraVa5v5kdhu9uGkTtAwBj2wV0ep2Cc/ChQGu/2+nYRUTnHm0OCDGFF+RfcTUt5GpFdI7J1eIj/5ibsx/6T3QywGK/lXTkBN1DHxfO5FnsIAm95mfWjAmhm7qwZJFM1VhGPt31zlMPm4K3cqSkPbrFOAXVt7dWlgwpMsJXsYVLX3T1q861Yc2ZLM2DhWv2ZVBcL2kCOfZP6fAgcpvEAzv0dIZxzJwF054k42W6qeJhz+DAmNsSy9hqhjd
 0o30nFkD
 KeOcUL1mDWw5inwlG0KObmkhC2aIk9ZfZN6uIEEg4sLpB/ZRGX2XoJH+QQdLsB6DD6sPHXP/8ISUJsjN+IbUtp+BgHpHhjl7nmcFzxsLW8fEgJLTSEct6yzfVLZph3alEyhY0BNm/beYKbQ6cpo0tDge7g0YtqW5h4nHlSijUTrI4w2pAMS7sDlQW+uJiLpdULc8VvElPKSuxvKOSbwFyHYUA3gN/Rmxaa2PnfRon8/9KfOmLA16st3PnRYfiQ17LgHHqumW4ov7JOuljYfameBJVqpatbIWbhEc53ZpNFvNwRXgp5/DE+HYay+sLrsZUeC3hToqWibkmh+0rMh3n2LnfSBHHe8d0XmZnp4bF13fblpPrEQ9PG87DtuXwMMiYUzajOMSdYGjcy5UNC31/RG7DeVO9qLtYkwoNKBGUiS1KpIdjWHQubRpQXevGwapuHbdBTm96NOCRL87Z1rtLpi3u96ipJzFUM6r4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

Move publication of swap_file, resurrection of the device reference and
the writable transition into one swapon_rwsem writer section. Split out
a writer-held enable helper so initial publication can share this
section, while failed swapoff can use the locking wrapper.

With file publication and teardown serialized by the writer, remove
swapon_mutex and use a topology reader across /proc/swaps iteration.
Keep the SWP_USED filter when advancing the swap_info array.

The publication boundary excludes proc readers from partially published
state and gives the lockless live-reference users initialized device
metadata before the device becomes an allocation candidate.

Signed-off-by: Kairui Song <kasong@tencent.com>
Co-developed-by: Lian Wang <lianux.mm@gmail.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swapfile.c | 39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index ae8421e18448..277a5c749987 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -139,9 +139,6 @@ static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 
 static struct kmem_cache *swap_table_cachep;
 
-/* Protects si->swap_file for /proc/swaps usage */
-static DEFINE_MUTEX(swapon_mutex);
-
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
@@ -3161,9 +3158,9 @@ static int setup_swap_extents(struct swap_info_struct *sis,
  * Mark a fully initialized swap device writable and expose it to the
  * allocator. The caller must have resurrected its percpu ref first.
  */
-static void swap_device_enable(struct swap_info_struct *si)
+static void __swap_device_enable(struct swap_info_struct *si)
 {
-	percpu_down_write(&swapon_rwsem);
+	lockdep_assert_held_write(&swapon_rwsem);
 	spin_lock(&si->lock);
 	spin_lock(&swap_avail_lock);
 	si->flags |= SWP_WRITEOK;
@@ -3173,11 +3170,16 @@ static void swap_device_enable(struct swap_info_struct *si)
 	atomic_long_add(si->pages, &nr_swap_pages);
 	total_swap_pages += si->pages;
 	plist_add(&si->list, &swap_active_head);
-	percpu_up_write(&swapon_rwsem);
-
 	add_to_avail_list(si);
 }
 
+static void swap_device_enable(struct swap_info_struct *si)
+{
+	percpu_down_write(&swapon_rwsem);
+	__swap_device_enable(si);
+	percpu_up_write(&swapon_rwsem);
+}
+
 static int swap_device_disable(struct address_space *mapping,
 			       struct swap_info_struct **swap_info)
 {
@@ -3340,7 +3342,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
-	mutex_lock(&swapon_mutex);
 	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
@@ -3355,7 +3356,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
-	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3401,20 +3401,18 @@ static __poll_t swaps_poll(struct file *file, poll_table *wait)
 	return EPOLLIN | EPOLLRDNORM;
 }
 
-/* iterator */
 static void *swap_start(struct seq_file *swap, loff_t *pos)
 {
 	struct swap_info_struct *si;
-	int type;
 	loff_t l = *pos;
 
-	mutex_lock(&swapon_mutex);
+	percpu_down_read(&swapon_rwsem);
 
 	if (!l)
 		return SEQ_START_TOKEN;
 
-	for (type = 0; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+	for_each_swap(si) {
+		if (!si->swap_file)
 			continue;
 		if (!--l)
 			return si;
@@ -3435,7 +3433,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->flags & SWP_USED) || !(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3445,7 +3443,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 static void swap_stop(struct seq_file *swap, void *v)
 {
-	mutex_unlock(&swapon_mutex);
+	percpu_up_read(&swapon_rwsem);
 }
 
 static int swap_show(struct seq_file *swap, void *v)
@@ -3958,7 +3956,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
-	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
@@ -3970,11 +3967,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 	si->prio = prio;
 	si->list.prio = -si->prio;
 	si->avail_list.prio = -si->prio;
+	/* Publish the file, live reference and writable state together. */
+	percpu_down_write(&swapon_rwsem);
 	si->swap_file = swap_file;
 
-	/* Sets SWP_WRITEOK, resurrect the percpu ref, expose the swap device */
+	/* Make the reference live before exposing the writable device. */
 	percpu_ref_resurrect(&si->users);
-	swap_device_enable(si);
+	__swap_device_enable(si);
+	percpu_up_write(&swapon_rwsem);
 
 	pr_info("Adding %uk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K(si->pages), name->name, si->prio, nr_extents,
@@ -3984,7 +3984,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(si->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(si->flags & SWP_PAGE_DISCARD) ? "c" : "");
 
-	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 

