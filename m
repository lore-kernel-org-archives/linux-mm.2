Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1875606A335
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yqZdLoZW
Received: by kanga.kvack.org (Postfix)
	id C0C466B07E4; Tue, 27 Oct 2026 12:06:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBC8A6B07F1; Tue, 27 Oct 2026 12:06:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84106B080B; Tue, 27 Oct 2026 12:06:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 80C756B07E4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:06:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 27FF2A86D8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:06:53 +0000 (UTC)
X-FDA: 85368884706.08.7FBE657
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4E68014000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:06:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yqZdLoZW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TppI+6UPKL+8iku51pvieIqLoyMGuox9OFKt53vLtFQ=;
	b=w9sthlO+AsOE+MBqHElyXp3KtEvxxfBDWNv8WG6Y3RgCtdKTeM9Z3zAxENg7aeAbBCBng0
	Vdv/Fl/rLTRqfYmupsn20LhAzAkQYojJr4M8f+c9TUW2EIZyJvSTwxc4I7bbBYjSoNxtNl
	zV1Z0ydyORlhZH88qkbk8Eznfnq41Lc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=yqZdLoZW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of lianux.mm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117211;
	b=6F0hWYumRAiarqcwqzPIVLH98Hfe8rZi4QETnnNmVutA+IyWNwaY7PARKffN5jsTZtGIch
	Z2/Ic9Nx9eNybOBOzIbNYmXn/7TTQWuBF5UwGqta8mQR5WAfsgyP1jHUDwYzd36ohfIVem
	mFbgj6lbwkxmE58Hf7iuA0aD2fDmO3o=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ea0efd636dso35115625ad.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793117210; x=1793722010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TppI+6UPKL+8iku51pvieIqLoyMGuox9OFKt53vLtFQ=;
        b=yqZdLoZWfQ4ia72urzW4WMIh6cPc+GrgafZwV2R42t47zw0wxSYn2dcZzhcxIjIGma
         KNZbj4qDaXeXGp9+gNYwJrFAZAQuFH7hKpjdI4Yv/xyNrvfYxHol9qxJhXTmxiEdNKWD
         2vNtPldYy1QKo7iVgmlpnMPmfyLjf0DdqsE2M/9UTsyIA7JGTOOcAnr2Sja/7EpgG/UJ
         PqN1J0MWa/5fIyRjO07Q5qcXc5ntGdgiRS5Zok9uObWPyhH4SfbKaGTlHwQ+ALRcavQa
         MmRLm5k0krT2/ol/RoSKSV3miKfqFMubxAwhyuIPsg7f61WMjubhKGxP+L8auAlFH531
         55ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793117210; x=1793722010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TppI+6UPKL+8iku51pvieIqLoyMGuox9OFKt53vLtFQ=;
        b=klct3dNX3bgQ5Z6+YnNoQpPrsYjdglm1OuxBmDQwYlBfYj4OWnUhII3RBKCe56Jmuk
         DCBVaoaWzjDDp5IWkgunuXQK/8orrY2OOWV4z8L7XgYMmZuiAOmP98BgbnuYFlsCz/Rg
         cof98sn89pBqz/e80qiSxXgV0ntRZMQQ5np5ixQyeL7s05zu4GEw1dTU93FFnWmLyXT1
         cIUUZYkv/m3UCKEcNatFDhBM1rsHoZnGh96yElLr90DQiCxDKZnpTFqm8GTYRq7xdkRf
         q+EeQSZIjoP73YlDmhzUFWBvAHsRKG3SwXp++Wbm2RtAwB5QW8HNLogd6BfWwhVSBxL1
         kh+Q==
X-Gm-Message-State: AFq9FYIatAuOLc/xAWURtCSHfs6imO/P9Bokdv/pctrChyCxrnLpG9SM
	hp7d7JS0sVkSxTJF/EgZDF4wd0II1K7M6OYP2ar8tKepeqJr51v7x0KjWCD88A==
X-Gm-Gg: AYBFou1rISL++1DKT9xiDqOtHDooPM+e+yM7K6WwG/38VYZnzAZLvYSngbvETOqITUi
	YP5c5slWySivQ0iK8sdhFnVrk8bY+weDlKk2Cm5Ey1/AVpHBsSWFvQjMiuWDbSLblGjyIMgfZ74
	r8WZ3cJf/sq8rfB8KgW/Age1Gr/vu+Oc1fTLyQqr8dGepElpIliGEPFNZKJTo4Zl7QE0/YZR6f1
	DGET6mZ1ZCZwbpPy8V77NAa1QkFoQrbxQySMnu44HV0fqvbnWbVceTZ+K+HVlx4fp/cPffcq+4a
	WKj3yS7bm5WmUiXMyZESHyXO58J7WzLx/4dQoUhua9ZhHaD914TN0obeO+bziRDlUHa/+CTR+vg
	0hM9auVcL2W8RN2XKxL9wZuiiZzHNRUFkQGiAUTmeE7gI7wEeq8CIvBxpvCh84nStU4D5oHkxQP
	n/3vBcNRre7H3c8HlYjn6siAaef/q7oeHyZL9ASL1MzGJBSMu5T1VTH/Da687F2RCTeFJxXggaP
	SRMC8BIzCCDBAhL7Sdh+ajmnKbrofzC/velOATz00P5pfqe4vbPcjqskFnOz1yh0LYOkwNXpJPM
	iwfHAXLQ5hhPMhUdqpOj
X-Received: by 2002:a17:903:1103:b0:2e9:7190:32dc with SMTP id d9443c01a7336-2ea9c68c70emr91918065ad.11.1793117210052;
        Tue, 27 Oct 2026 09:06:50 -0700 (PDT)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eae6b7cdebsm12246305ad.12.2026.10.27.09.06.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 27 Oct 2026 09:06:49 -0700 (PDT)
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
Subject: [RFC PATCH v3 06/18] mm/swap: serialize swap publication before removing swapon mutex
Date: Wed, 28 Oct 2026 00:06:23 +0800
Message-ID: <200266a50e30e916ad425ccbe2b7cede7f227d22.1793106426.git.lianux.mm@gmail.com>
In-Reply-To: <cover.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4E68014000C
X-Stat-Signature: 8ba4dgbidbxemba5yw8c8cgafeiowp94
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793117211-588471
X-HE-Meta: U2FsdGVkX1/MoZp2Xdvbi0QqK41X/zEslWSAUInAj3xKjKIZXCb8UnrjpvYjZxL5TXcLH//lYVvBz+IAZv9h74S38E8UKs7edskKtTttrMWZXqjG6/+dABXKrF4as1fGKV3wVErvKVE5iiixOxeuIZ4lU3r+S1HvMcnP0l+U7ART95SWC/HJ1Uh2jKoxePwan4wbBn7WAJUFm0yZLVJkgr/XgiEq0DUHewakgG/7UGG2x75kCgJ/NK22mDb1pzwFB6+FvvIyu1bVx1pNdC9HffH1ioOpQy/+xWwxfUinmYVmpyB0l/NenQv/Tm8ZHtkbCEj/FWRf0vSCLklpN/i6b+IuOXzVEr4JxWQFN5DvyJpF4tqiUsHU4La78jLj3Cr6lnozqOyvKRbv2pGxzQJYH23WaTwVZuW7ruQpAlANIvlyI434+FCG0d7nrL9GSiqZJ4TGIMo//osu/Vb65J1+2SLTLcieW4W/vmiIaHKGr+lRehka5A5fGHdjz1NtKPyLKB7Ocr/Kk/crVPNjs3t2BIl0k5kvBn22WRWi/1KpqqR6WVWg6lJagdzDbYQz67L3uoe531Ae9UFUVWdp9v5ZM+dGNgLTeSvNFTe/lUSI9tY/LI4iB5R1kRwOrqeMc5Cd8I40kTmxyYVMSyJTddXanKcR4DcdBDddYvhB2tEliZsFvsS8+JriwsmBGUVQbS+jaI53asWU7K2NN3opI3aMyVNnFTZrxiIJ619DuKEeLiVG8MdeY3J9HbH5lTYgLQOzTReQKZTlnFnUu5E9yFCS2myHr0v1JVjP4N9faj5/s2n/YMf4QW/0PliwP+iw6TDcDJupaLzYXKgkY4AeUgrMYxRpr4CrzCOxNY2uSBVle6mYm1FsDvvpLgg2ORORNcTdtcLfBKVg1v3vTcYJuM4HOff9jXbscGJGwC/VGxLk1/q6YfLIbAkYLidhweR6rL4RsB2msCiJlYHrgOATNyw
 pjWsVLat
 by0pY/q/YAZjJKu8wiFGUEemvCeKoPAq52vTSO1CNef10wOowlP0xJpc5V6iBJvyE8sPJS9rOqkwlKssBvLqO1CQQySDs/0zpzDYe7P3Sn2Gl/Rr/l2mGOOfqWSC26BymsIBQ5e1VIF4akOtrHS3qz3MY02uaglyY0/wUnmFQWGoZAIwJp2DRi8aWvB27KP9RafMjSMgp6olkrfbk0FkWJhVCx1/dqvbnT8QPz6RPRm5m2wmaui5lPgxoACaJsTQG0tQSFtgmHlN2F3ShBa1tCsscwPiJOIESRGeWwuNpOSEMqWft43iroAWpI8dOzCbOYcgqsieL0F8V9cYCbu4Ty6oetlYbSGqXxnV1qKN0ZG4Fa9ZDEq6dg1CgvYuYsu00uoY9Na1eiw5lx+DH+ZiLD/4kfUW2nPTi689IC6Dki22fJceJi5gjs/rAMMCQofYp09vwkcyzFqC0QEUjQpMOn0eKSsC421ynTCCJYJwqFdvZI+Lsc+jtxw42/Ci7IBG1uv3S
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
index 4ffde6827d44..4c10e4a2d9b3 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -140,9 +140,6 @@ static inline struct swap_info_struct *__swap_iter(int *i, unsigned long flag)
 
 static struct kmem_cache *swap_table_cachep;
 
-/* Protects si->swap_file for /proc/swaps usage */
-static DEFINE_MUTEX(swapon_mutex);
-
 static DECLARE_WAIT_QUEUE_HEAD(proc_poll_wait);
 /* Activity counter to indicate that a swapon or swapoff has occurred */
 static atomic_t proc_poll_event = ATOMIC_INIT(0);
@@ -3097,9 +3094,9 @@ static int setup_swap_extents(struct swap_info_struct *sis,
  * Mark a fully initialized swap device writable and expose it to the
  * allocator. The caller must have resurrected its percpu ref first.
  */
-static void swap_device_enable(struct swap_info_struct *si)
+static void __swap_device_enable(struct swap_info_struct *si)
 {
-	percpu_down_write(&swapon_rwsem);
+	lockdep_assert_held_write(&swapon_rwsem);
 	spin_lock(&swap_avail_lock);
 	si->flags |= SWP_WRITEOK;
 	spin_unlock(&swap_avail_lock);
@@ -3107,11 +3104,16 @@ static void swap_device_enable(struct swap_info_struct *si)
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
@@ -3275,7 +3277,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	if (!(p->flags & SWP_SOLIDSTATE))
 		atomic_dec(&nr_rotate_swap);
 
-	mutex_lock(&swapon_mutex);
 	percpu_down_write(&swapon_rwsem);
 	spin_lock(&p->lock);
 	drain_mmlist();
@@ -3290,7 +3291,6 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	percpu_up_write(&swapon_rwsem);
 	arch_swap_invalidate_area(p->type);
 	zswap_swapoff(p->type);
-	mutex_unlock(&swapon_mutex);
 	kfree(p->global_cluster);
 	p->global_cluster = NULL;
 	free_swap_cluster_info(cluster_info, maxpages);
@@ -3336,20 +3336,18 @@ static __poll_t swaps_poll(struct file *file, poll_table *wait)
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
@@ -3370,7 +3368,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!(si->flags & SWP_USED) || !(si->swap_file))
 			continue;
 		return si;
 	}
@@ -3380,7 +3378,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 static void swap_stop(struct seq_file *swap, void *v)
 {
-	mutex_unlock(&swapon_mutex);
+	percpu_up_read(&swapon_rwsem);
 }
 
 static int swap_show(struct seq_file *swap, void *v)
@@ -3893,7 +3891,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
-	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
@@ -3905,11 +3902,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
@@ -3919,7 +3919,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(si->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(si->flags & SWP_PAGE_DISCARD) ? "c" : "");
 
-	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 

