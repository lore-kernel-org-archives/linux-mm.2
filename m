Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8A00606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 14:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=w8h2m4oA
Received: by kanga.kvack.org (Postfix)
	id E8CFF6B05C0; Mon, 23 Nov 2026 09:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E64736B05C1; Mon, 23 Nov 2026 09:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53CB6B05C2; Mon, 23 Nov 2026 09:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B809F6B05C0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:17:09 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E888C08E1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:17:09 +0000 (UTC)
X-FDA: 85466585778.17.2A9D958
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7C0CC8000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 14:17:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=w8h2m4oA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795443427;
	b=04BXMrCqQ/dyid3Zr4b80hJ4V2Cd320V8a+uDA5ssYTTRXFRNZZyaJieUXAZAVhcyTXPCJ
	Zry+hLr2zEjR5782xUAIugApVyjXIQYuFDIE3xNA8Tg+xLoEvUNJJyKKR9fxIvoMly4Y4t
	gOcFBRvEEZBd3hpIg0l9GsRvC1VkM28=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795443427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XBjZy5aXe1k0hsGSbAtSU1DGVkk1NgApIFU82uacohQ=;
	b=MB70Hp71LYAwXqMaA2q7YItCoLtdgcZIFHzefqEwhsXP9FaEQfgcRXpX/x2dPdfeJAZ5FT
	emFZz7DZTU6kbBzNItmTQ8cPYLkJNsqs8XhdcDfQUnYg9wV4SCrTWUb9qHjJzcupvhpecM
	C6KzfFjP8I6bK+pzGEXw/6aJA51xxTU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=w8h2m4oA;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so4075686c88.0
        for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:17:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795443426; x=1796048226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XBjZy5aXe1k0hsGSbAtSU1DGVkk1NgApIFU82uacohQ=;
        b=w8h2m4oArIsthaS52I3/9IgPiV1nrU6hSwzIBx6/lP+3Fszl6qBZkl9t1b5mEiUIXi
         xxXoIxhbB7HI6YR6wOii+NkoWGvxK5LmhrPbr+6eZcYr3AkzOt5pjK0i25X89XSWhSAh
         B6ANJpq1rye7reMVJ+JmtZeroMiad+nj/jtKlrj4ZIPoqq4svLoXdxGvhBmZcr8NZcQg
         VuQeLhJlP8CNY2Zwgh3EPz49A5QfPY5D5om0KVO+VDxVAQWYQEbEkC7bITovKCt2UXF6
         mdm5xwfFCgWHuw/d3X4ZARlA62ALtQj3tBRgh87e0sLw6uilhDtL2R2MzWatjnp9bkSU
         fmTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795443426; x=1796048226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XBjZy5aXe1k0hsGSbAtSU1DGVkk1NgApIFU82uacohQ=;
        b=k2ShyzHy0Wrf4363jygHc/yZaa8AO1kMckC3US5P9iMQdUWcny6DvW+8Qg8O+/LU31
         T2/vx4NqGSj0uEy+1e88ykQoDWzXhpKyjqcglHt3MbDv6/5YN08XT8QkT/o7irLTPe/i
         DK+mzTXFVJvIHP9pmIArKNOg7Zuf9CJXTLz1lMN8PaHDfOwk3ebTBzYr0lhy7DViykPo
         8PZG1z+HPpcemNvJG7oUPi/tKlkFeA7bQ+NH8zbixdQtmr3O2GLRmY5iViRDI0cVuH69
         sWPTbWw3QGDfhF998xrG8DZFvT5CJdM6pPB3chNihsHnpv9jqm9qNPMbeKIYmT1dMJ2D
         wBjg==
X-Gm-Message-State: APuU4Z8ud9AbVRn5pgNqP5h5LUC4ggHrBMcmwvjlXp6nWQ+SZ20ihFRr
	Dszab6j/VQSCfttxXL/I32Sngk9xQFmPbx7YesatcBPZMEHro8akYdQLCmJkBZJg
X-Gm-Gg: AZFdTZf11Pi0VFxE5Z6/N2K2INGS/Un/eMYvYmjlsYXh0WJKAzY8An2LEaGhISx9AOB
	6HtAUKO3QneF406BbgbUHAcLxTLbc3XGniw8aJY/ILurB033Cjy3jvCzPbUWK+VoQguCWluGQMp
	nYaua8RlboGPF4eVNjjrXcymjAIRPeuSQv9Nn2Hta9Er6Nu2ftTNF03qj0JYwD2opErAl6hMdiG
	HmJbJ/FXdq1JrJt2Q7s/nTJZEtSGp8px+5aEDt5e+HYx2gYsAv4T7jy5VwQNKBPDCxC3iF25A5W
	FJgLmormonHq5HBUJ+JHH8fLc/EbuGIs6zlBmjEhKu2UEhrc0awCSYbFccgLx6EWSEHrRDSVdma
	4rvE6ax1Xt2r/W9MxyfmvByRg2L1FDgSw+95PTxia2/YMwPpwrpJ4sEj49UgwIFMC47y+W5psgo
	9+mpNsCHWu6v5T/yTIWWuQEyco5yFUJ7gA6pGAVchezTkvScb7voavGxhgWCnn3MYWSuPOxdMMd
	vxD1H8wLoTjv5vSXglzQQbXGHBryYAoNI6JHKJjVCI7vAu07hgcbVR8Gi+YhhIelKzPegsfXoSl
	HKrCSAXvnNyMHsMKI/koxnDWIKt+iF1nXmqNM9ctkQFqTabIAmOWc6xeFwYRBytSQAwW
X-Received: by 2002:a05:7022:7e82:b0:189:d6bf:7eaa with SMTP id a92af1059eb24-1b56f39c64bmr4473331c88.16.1795443425420;
        Mon, 23 Nov 2026 06:17:05 -0800 (PST)
Received: from localhost.localdomain (vmi2317719.contaboserver.net. [84.247.152.64])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5567ff27bsm31107781c88.6.2026.11.23.06.16.57
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 23 Nov 2026 06:17:05 -0800 (PST)
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
Subject: [PATCH v5 06/19] mm/swap: serialize swap publication before removing swapon mutex
Date: Mon, 23 Nov 2026 22:16:54 +0800
Message-ID: <030796dcb2086484f87e2250d9cf9a04fccf54ab.1795439990.git.lianux.mm@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1795439990.git.lianux.mm@gmail.com>
References: <cover.1795439990.git.lianux.mm@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k6ajiius6ickofm1byuxkix3rf87s5w3
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7C0CC8000D
X-HE-Tag: 1795443427-544176
X-HE-Meta: U2FsdGVkX1+x4kLGl0e57nA0TeLUPHch81TUXEx1d2RdYP3+5LmUFp2Im4NrkhnFUj56IWjZcl6SIAvamf7jkc19YL7x0/JN1QQjMZAZetkmG6mIaRAZUJqF9qsEyxCmHTQkfehkxFW43xKTTCyPfArEKbgFjKaNUkQZCO6HtaQI+0cgoVXd6RJtBklZnlxvAzVAIwuKOy+1egwVqMHpo6MpVO4F2TlNhf9qFi+giKq48uLZWZ5vp6ycpHtNMafwsiy8bTlzjBfPyq7dpeipvkA+FxEkh7b2NmVpmoccYBzG2QmL8+lJTN+m64l45x6VkqnvtrTw4h2TBStG5tDyAX3uIno8jLG47YDBOWpEtv1yedUJBmVEX2u1kzWxh5kQogoIxeg3Wfe2LlvleY95yqiVGO1f0Y1HZd+4r43w78ACweqSmBMHuKp4X7zItEcSsac7y5BsrsAoIpwwEU8JpU5n5QE+oDCm+tKnrraJk/y1ibQSgvw5tmlGHZAjw/r3tQ2L/EewIC06iZ5xdM0QW60wyC5aAa+zXKjlJGC1p81V7/V0CYSG4m86CKbLfTbyGm79W3jtbG4x08L3jXW/vV8N4WW9IjtEbCAUcA1qhrvEAAUQ0L3hIq+h8vFYoWL2VlfT3kM37nFnBhPl5ZZlh64qQHgjEHGVn1wlTCL/k9jOioRoIPlSdgpwl0Yp7v61aUlNrCYreg9JWrWXK97Xkn94DFH2CS5NOlVoGQtN0u0imljTpkj9YnTApjkUDmkgNdemlCOWPV7+a3mjVOle97+bR9HxhdIdeWBv3sA8d9ZtRVoQqeOd5EYSqDu/dF2lpgHdjmg6xMtpG5vJQOF6Hh1x0H94NX4gPyGA9ageIL3cg8qF3WFNT39B4I+kSIiSTlL7B97AIJEtM0aSCQsek6lSNuFTaG+R/o8OY75mjb+KfKr7IkQ8K+oDELpAgldywth2d6ZFShN7BJkdCv7
 QZU5gSkT
 IE3z2YjOCWenfs75vvI+L308PbW3hqk4RkOMaDghLpHki7RtmN0PkWTGKOfQOOFu1/zpaaFgUbLv2xisJyoNCyfuCxA03+3JJTxumMp1xEMuFmA6ojGkfYpkIGt9qGuE1GXPGTvw6Y5PSbdgjuD2riUwaXDD79qv5UR9OLJqQX1fZSSv2Cl3d0iX2gkYLN2Ll5seF1JYPQ59BepMost5ENVFnTCxIj2BTnpiez0nRbMlWPmFCZcMQFTyakVxGyGXINArBryoNAH52pv9Fys3NbWmAovT2dkDPnE4UmPyNZuxc63t2g49a16UMiqf9Z/rhVDv67kTZEXiqMd1eKTAF3xIoKnB+qMPbjlo74VdwMXbLak2iS7GPmeWvLgRXWXZLDYYJpSVtv4fbOHRL6G7FZlXLOhUyiRFH7HvwpNr2TlNC1oNrLlfj3j1a4wlVbEpP7cY3cjxEL7VW8H3GxT6ji+m+5pZuupGRjpZOfgkVBiT0Ubmrvh4NePOgYTcR/FyadpGxNz/yQ+OoXnrP95TLJEraWxN6ub5DipkCSD4j8PX8j3a2jikDB4p8xU0Ps3W4MdwxloaicIBNYUuOSzaLxway6fjdnocYLpxy4dFyhc2in327T4q97qMj5V8fqamESEUwSkgXcvuffKIX0hqEv51vOojvuB3PgXFvHa1mo6L9rHENzrcQSh/mPg==
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
Only expose entries with a published swap_file. Other bits in flags
can already change during device setup, before publication.

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
index 7a97cfd8d009..24f301ef4e3a 100644
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
@@ -3397,20 +3397,18 @@ static __poll_t swaps_poll(struct file *file, poll_table *wait)
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
+	for_each_swap_info(si) {
+		if (!si->swap_file)
 			continue;
 		if (!--l)
 			return si;
@@ -3431,7 +3429,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 	++(*pos);
 	for (; (si = swap_type_to_info(type)); type++) {
-		if (!(si->swap_file))
+		if (!si->swap_file)
 			continue;
 		return si;
 	}
@@ -3441,7 +3439,7 @@ static void *swap_next(struct seq_file *swap, void *v, loff_t *pos)
 
 static void swap_stop(struct seq_file *swap, void *v)
 {
-	mutex_unlock(&swapon_mutex);
+	percpu_up_read(&swapon_rwsem);
 }
 
 static int swap_show(struct seq_file *swap, void *v)
@@ -3954,7 +3952,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		goto free_swap_zswap;
 	}
 
-	mutex_lock(&swapon_mutex);
 	prio = DEF_SWAP_PRIO;
 	if (swap_flags & SWAP_FLAG_PREFER)
 		prio = swap_flags & SWAP_FLAG_PRIO_MASK;
@@ -3966,11 +3963,14 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
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
 
 	pr_info("Adding %luk swap on %s.  Priority:%d extents:%d across:%lluk %s%s%s%s\n",
 		K((unsigned long)si->pages), name->name, si->prio, nr_extents,
@@ -3980,7 +3980,6 @@ SYSCALL_DEFINE2(swapon, const char __user *, specialfile, int, swap_flags)
 		(si->flags & SWP_AREA_DISCARD) ? "s" : "",
 		(si->flags & SWP_PAGE_DISCARD) ? "c" : "");
 
-	mutex_unlock(&swapon_mutex);
 	atomic_inc(&proc_poll_event);
 	wake_up_interruptible(&proc_poll_wait);
 

