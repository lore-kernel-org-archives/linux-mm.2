Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2D5E60A261E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=QWHkATMX
Received: by kanga.kvack.org (Postfix)
	id AD03B6B0807; Tue, 27 Oct 2026 12:05:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80CB6B0809; Tue, 27 Oct 2026 12:05:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F596B080A; Tue, 27 Oct 2026 12:05:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7C26B0807
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:05:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8FDFA40A81
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:05:44 +0000 (UTC)
X-FDA: 85368881808.04.5AE45BD
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf16.hostedemail.com (Postfix) with ESMTP id D12F618000E
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:05:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QWHkATMX;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117142;
	b=K1EEJmqqIG5nDzpfZ1IJaHxC7Mdo1+WWxz2ZWfHv23FJkojFqPZxUWDhzCFswR6tzQKFt9
	2Oev9YWspaGC/abBv3dgJYpBbPwaZV6/9OPCCzEqiejM6TdjEKiyt8tor5Vu0CHTjqs+Na
	zO9Cz09hOIgzul5knKmqceOIlD2juiY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=QWHkATMX;
	spf=pass (imf16.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gimspkvzpv0L0LYJWO8vCB44gcFGH0Ui/jyvcrmF/LU=;
	b=yMZt4O4vNqIJ+i2glrN/o1cfePTqdq16/+H4Ok4HjQWvm2xr+xkC0AYgNd5tvASBUrEU0G
	DeuVOxRShMdevR91wQCxWaGNoVPbqUDs6bbVbTvJwpY6AAOB0UrfnlmnEkLSz7/+HPfOiR
	kKA/4bNmxMLOy4qajjosUyXfhm9dwcA=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3a4b3ac8fb7so53183a91.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117142; x=1793721942; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Gimspkvzpv0L0LYJWO8vCB44gcFGH0Ui/jyvcrmF/LU=;
        b=QWHkATMXkJb7lefVNzqXwC10yx4uDeVObwFaNVoF/4DCVKCHH6w/KUhyAE92cSKf5/
         iimsr3kWlqjeDUxN+8Kk48Jn6p3lURmx2ODLw00dvq+7GqWoAAFLzoRxXhKxiMELYPUP
         lAqH657PJZjhyBCSc5mC/DncYdvrhTRTZLKu4MJ8uMNXAZCf5C4sUsUrBDMTyMHKn/ND
         nuaom/L7tMpn1xGsKjD+RKmeiOq34Fvz2NTaV6QlHQwRUK6xTZB72Hd8cAxxfmQXFQuG
         xvKppJmYuCYwmN+iyNsaO1eUtr+g/muDwQPD4Sl9OKz3Ku5jYzq092Ah6pwyZbcBzTzJ
         VX8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117142; x=1793721942;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Gimspkvzpv0L0LYJWO8vCB44gcFGH0Ui/jyvcrmF/LU=;
        b=LQfA9b03LpGHRymUvkbWcZDrFSVeKHhhEySO96gegG1xyvFYTVNXGbvXchJwFq4h+t
         dMUIwBpGgU1wHTI4c8M5zGDPmWz6St1l2wvZ6l4xKHRJVGUBKWh6mFXKNIhdOaOB5Uqr
         x1j/j1l7PW63vv+5rANJrebT9Yire9kucznx2TB691b0bsdcNn/lhvgBXJPS3hOJaMVd
         XK+rAhCzQ4tABcdbX3I26jVFYaFKXZDU1AgVPCXrURromrOkUqzN6sVIdz3jycxOU8GE
         pP1+LkV62fZVMGsRt9vp25n7bsEgjn2P6jGrf6jT385kfrxF4Mk4qryio3USK6A7U9j4
         l96A==
X-Gm-Message-State: AFq9FYLiWaD8HieQXgvx/tPVgFmVqdxCCLizx8JvupXsNpYNF7wRKzhC
	Mn9uIjFy5qqEEzgvr0gdMEf/gTTvkndPSSs4+XDxmfYk6l6T36lbffkkOWnFgw==
X-Gm-Gg: AYBFou1J+fKLj9thWmnvf9IKbLV86uE7kUubvHHKhcyeuKWiOE8JSph+Fc6JmZLjboO
	zSMVHDh0N8kf2ONhNwlKLoXvXPU1scJrg9MJfo14CJIPfIX5TI91Nq9QdZkm0a6CdMIDSvqkhul
	BspXI77qEHdG9o8iSywj2wZUry5e41V9LkBukEGn69CugHRBCRJldwXeIidh2CjtqgJ6lWphFDs
	ppP8/oqABzD0BCzkrqZOCngq1Bfypk+u24AmSa3isIIdKRXOnL+CL+sETHPo+CN9glKwXhg7f7+
	+lvIxC6f9yQ/yfe5c71qjObbESaMVajDIq/1aYkXPXS1y41Q3VlZfeGjLSnDXP5GlgRnPbOp2xX
	aO8mwDd9SXOoGg7xf8LVd1fanbCGLGG+10BKntkd8T4s/sUdSPZSzPVR+BevYOG/wrCBg/9JIgq
	ZQ+R1C14VQv3HLsPlpsWGXPxuhWua9Rcu0hbrRLAn7O0fDbj+qdpYlSRRnzxGuVAVNe9ruJl/fF
	wnAx6uGgpNpmnYeZe7HG9VwpRG2sP0cluO+dsE8FEWMTuaKi2ZQI9HFn07dZdFnrbZonydaYd20
	DaldvIWoyQPWF2K+8tv4
X-Received: by 2002:a17:90b:4fc2:b0:3ac:9a5e:9ce7 with SMTP id 98e67ed59e1d1-3adeae70fc6mr8364278a91.49.1793117141630;
        Tue, 27 Oct 2026 09:05:41 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ae40472ed9sm4449271a91.16.2026.10.27.09.05.30
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:05:40 -0700 (PDT)
From: Lian Wang <lianux.mm@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	linjh22s@gmail.com,
	kunwu.chan@linux.dev,
	kees@kernel.org,
	gustavoars@kernel.org,
	tglx@kernel.org,
	linux-hardening@vger.kernel.org
Subject: [RFC PATCH v3 04/18] mm/swap: introduce swap device iteration helper
Date: Wed, 28 Oct 2026 00:05:13 +0800
Message-ID: <f2d75ba96189520fe66a99ea9c7c0d9894b8ec22.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bx1nq813kx5dir6z453o1sj8ntub6eni
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D12F618000E
X-Rspam-User: 
X-HE-Tag: 1793117142-43709
X-HE-Meta: U2FsdGVkX18Xuao5R+mWUA2uxWw2q+ne9MuckioIgEUNuEsn5GWCia2+mu8W8rVHko051OiGuyDp4WLdzVD7WMNwfDe0jfXXfiQG68pw0ICoCkDou5wYcB/NG9JPb7plYpVzBrZj7EBhdu+TwLN18MLgpI218e87RlQ1C1tkokWeIObFeyZlzI7725A84lmepyLj1TZ5uoq33NFD2tv9pjPbHi+BoCvOGGJQT0CYLO/98cIXpF6WNU9RAUYh+zy12SjIGwDDOu5TC8sFuS5oemqBA1eYFlErnEAyU6pyWoiU17jnTmwHl/sPo98LxaL9ALFddK8WZF3X7wBlH4lz+7H1NkpLkPaKyL5xYzisxZzJmZMoL1QOoW8NFsUfAFk6SZ0wch0VL8OPdeQUYRJfSzKMuiGORmJJBuIi+Qberw7rjmBlOaNZ+K6OIcGHn8+vXKS/8mM5dCMI2OB9UiKvfKvdrXtn2iBu2rIcRka4Tav71ivZ8PScthQvpsQsSvKtQQO3XgZb7NPuQjL4kwDhX7ZvcgCfe6KYOFGvHO2UgsZThsZcTwrAbzT9aOrxR3TjRlPC1iCymRgr/CSelsgNn8C/mfp+ZoSN/q2QngnHc25GPFJ4IT7CzDbB/srsQxymBLThNo+8CkIqzrP5bzEwvgqgwC9Bbt7jt7raGBv/8VQwFDKGcFBxNRyS72Rn/LZh/nIxsZ11PpozE2oxWx0jUESaNqs2FrPX2t7jnR9nRv26Cl13T1Iv3TtCHWWegGfrJrjKrdRIQP9Q8mGLJ5nVMlm1ocLwmQLdEMCp9XOup3rzgbCQEYz7ozrwV7SjQRMbvFzMoInYdCN00SrCJCHQdtHwxNXbiLe1KoUBH4mr2EmVW31Sr+7ol8y5vw/kt02jB2GqpS0T07QVYYsldx2ZcW/9toSLnJGutM//ABdWbPoJ7Y5mgcEAtoq3ZBfYBKkv8lbQO7uVpX2k7qq0YlZ
 GhZWmzbs
 p3lIpFsmGAw7yhcLLQXMcP6SfMKrFoBhq1fhCZCB04UA0L0flBAB7cuV0/QDkne27FtApSCZQTc/vuxeOJSgcWi/YzW7zQ1t85nUdM41fXTyqD531WoMZi6XtLpCoUGPFHv7KdSHqEo60f/JZjXMRDCjQ9zoux+c1T8JkKuZD9n90aruNXRFeTDFFkZq0DvifcoODZ2hjjnaCKnZUHZS6GUa8jA0hrUBLrnaWyID7IeeBkbj00WJ8aM4KT05q3QqyUGcPRv4T6tJFUBk/oSVBkZORUQqpFVaycuAv/w3Sv1tljqaTFGdBLSbdJ9JAwqkskGnLTg74xY7FwtndHYisoDhjuNiWdNf9kl0L8eJXkum0MMWBo9TotR97AFVQkq+kX9vO6fOETQLyUn67V8i5v6XOGGGQUuDWCjPYmE+tKLFRRmiJ9KGVQ20h2W9u1cWirQzZELN4zRy/J4ERIcAJVTAAAuWxFsuIJlfxvhV8cAcveiaNPJkhGlNNtNK6Onw0DCSd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

There are many users that access the swap info array just to iterate
through the swap devices to find usable ones. Introduce a generic helper
for this to prepare for dropping the lock convention.

Also slightly adjust __swap_type_to_info to allow access of swapped off
devices by moving the sanity check into its only current caller, and this
way makes more sense too: the only caller is __swap_entry_to_info, where
we should never see an entry referring to a dead device.

Signed-off-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Lian Wang <lianux.mm@gmail.com>
---
 mm/swap.h     | 12 ++++----
 mm/swapfile.c | 77 +++++++++++++++++++++++++++++++--------------------
 2 files changed, 53 insertions(+), 36 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index d5bf21f517dc..d46d09b8c21f 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -107,16 +107,16 @@ static inline unsigned int swp_cluster_offset(swp_entry_t entry)
  */
 static inline struct swap_info_struct *__swap_type_to_info(int type)
 {
-	struct swap_info_struct *si;
-
-	si = READ_ONCE(swap_info[type]); /* rcu_dereference() */
-	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
-	return si;
+	return READ_ONCE(swap_info[type]); /* rcu_dereference() */
 }
 
 static inline struct swap_info_struct *__swap_entry_to_info(swp_entry_t entry)
 {
-	return __swap_type_to_info(swp_type(entry));
+	struct swap_info_struct *si;
+
+	si = __swap_type_to_info(swp_type(entry)); /* rcu_dereference() */
+	VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swapoff */
+	return si;
 }
 
 static inline struct swap_cluster_info *__swap_offset_to_cluster(
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4adcfbbb3730..b72f4fc3e811 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -106,6 +106,34 @@ static DEFINE_SPINLOCK(swap_avail_lock);
 
 struct swap_info_struct *swap_info[MAX_SWAPFILES];
 
+static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
+{
+	lockdep_assert_held(&swap_lock);
+	while (*i < nr_swapfiles) {
+		struct swap_info_struct *si = __swap_type_to_info(*i);
+
+		VM_WARN_ON(!si);
+		(*i)++;
+		if (flag && !((si->flags & flag) == flag))
+			continue;
+		return si;
+	}
+	return NULL;
+}
+
+#define __for_each_swap(si, flag)			\
+	for (int __i = 0; ((si) = __swap_iter(&__i, flag));)
+
+/*
+ * for_each_swap - iterate through all allocated and inuse swap devices
+ * @si: the iterator
+ *
+ * Context: The caller must hold swap_lock. The lock may be dropped during
+ * the loop body but must be re-acquired before the next iteration.
+ */
+#define for_each_swap(si) __for_each_swap(si, SWP_USED)
+#define for_each_avail_swap(si) __for_each_swap(si, SWP_USED | SWP_WRITEOK)
+
 static struct kmem_cache *swap_table_cachep;
 
 /* Protects si->swap_file for /proc/swaps usage */
@@ -2229,26 +2257,18 @@ void swap_free_hibernation_slot(swp_entry_t entry)
 
 static int __find_hibernation_swap_type(dev_t device, sector_t offset)
 {
-	int type;
-
-	lockdep_assert_held(&swap_lock);
+	struct swap_info_struct *si;
 
 	if (!device)
 		return -EINVAL;
 
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-
-		if (device == sis->bdev->bd_dev) {
-			struct swap_extent *se = first_se(sis);
-
-			if (se->start_block == offset)
-				return type;
+	for_each_avail_swap(si) {
+		if (device == si->bdev->bd_dev) {
+			if (first_se(si)->start_block == offset)
+				return si->type;
 		}
 	}
+
 	return -ENODEV;
 }
 
@@ -2415,16 +2435,13 @@ int find_hibernation_swap_type(dev_t device, sector_t offset)
 
 int find_first_swap(dev_t *device)
 {
-	int type, ret = -ENODEV;
+	int ret = -ENODEV;
+	struct swap_info_struct *si;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *sis = swap_info[type];
-
-		if (!(sis->flags & SWP_WRITEOK))
-			continue;
-		*device = sis->bdev->bd_dev;
-		ret = type;
+	for_each_avail_swap(si) {
+		*device = si->bdev->bd_dev;
+		ret = si->type;
 		break;
 	}
 	spin_unlock(&swap_lock);
@@ -2931,12 +2948,14 @@ success:
  */
 static void drain_mmlist(void)
 {
+	struct swap_info_struct *si;
 	struct list_head *p, *next;
-	unsigned int type;
 
-	for (type = 0; type < nr_swapfiles; type++)
-		if (swap_usage_in_pages(swap_info[type]))
+	for_each_swap(si) {
+		if (swap_usage_in_pages(si))
 			return;
+	}
+
 	spin_lock(&mmlist_lock);
 	list_for_each_safe(p, next, &init_mm.mmlist)
 		list_del_init(p);
@@ -3931,14 +3950,12 @@ out:
 
 void si_swapinfo(struct sysinfo *val)
 {
-	unsigned int type;
+	struct swap_info_struct *si;
 	unsigned long nr_to_be_unused = 0;
 
 	spin_lock(&swap_lock);
-	for (type = 0; type < nr_swapfiles; type++) {
-		struct swap_info_struct *si = swap_info[type];
-
-		if ((si->flags & SWP_USED) && !(si->flags & SWP_WRITEOK))
+	for_each_swap(si) {
+		if (!(si->flags & SWP_WRITEOK))
 			nr_to_be_unused += swap_usage_in_pages(si);
 	}
 	val->freeswap = atomic_long_read(&nr_swap_pages) + nr_to_be_unused;

