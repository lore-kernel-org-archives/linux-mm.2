Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C5FEFF886F
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:49:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FB96B0088; Thu, 30 Apr 2026 00:49:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B993C6B008A; Thu, 30 Apr 2026 00:49:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A60A36B008C; Thu, 30 Apr 2026 00:49:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8FF446B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:49:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58069120491
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:49:16 +0000 (UTC)
X-FDA: 84713993112.07.463DAB0
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7E93B40005
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:49:14 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cwv48zTQ;
	spf=pass (imf27.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777524554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
	b=yGpsUD5kBh9M37sjBkn2axBWUW1iyLYdocZDxv2TyOoJGQ7L9KUFiaMXqCJhSXiSZU++SO
	zzdiLu6T6g8Gse0KupCGWBtCRGAMvzYQCagnaGNAkFjwuYCxr5ZyPXgnk9o2dxnqxLfOoQ
	rf4w7D+cmj2jPkVCgHyqq/tqWjqE1AA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777524554; a=rsa-sha256;
	cv=none;
	b=WSrVhvBd/YstlCCewqWcIYbFaExwhOaUwq1HHHxSW8ULl11GlanH7hxzSC4Kx/60dvYsQy
	Y7l2yFMHDy1QgJGopooBYxTNLY6dJfy3mdaTw4v7i0pHXmBKKUcThQrF4psLDawYUnUFMJ
	AMP6hX5iq1Q17gvFXmpjrau5MBOqZPo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cwv48zTQ;
	spf=pass (imf27.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c7961d7bc09so171283a12.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 21:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777524553; x=1778129353; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
        b=cwv48zTQY36WqqePPBS3I7Ra1FbB6oeE4yxUH7ZMasWsBti6twvIuEjdyxN+XBbDIm
         inyNTc+MbZwAT06WrfM9HvckPs3Hm8yVPSMHK1EAjAvXFZdtyqItfBg/TDlVwecPam/L
         KmlshUUw03sUkC1iTlJL+oAFvn4w+Hdcxc6qNxEyeltQTSFzCGRuijTevqkgf9Rz+pnr
         kNneypktePk079QFJ/wO281HY14cqdH+phK5SnglPnfjQB8oaSHMqzyM/CIe8GJ2Js5B
         /saGRkBBaLgRGGBRflzz1q1YOR1PVCSr0CJ7GeKN6KTArFiitPVsoCuCpamXKJkP8Fpb
         Bk9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777524553; x=1778129353;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
        b=KjQSYNQGO4RgknT8baR56QEow/9WEB3rSPmXvb8buTFnA5SfL+VRNkViGTKEYro/v/
         5WvbxpBO6U800ocIGmKSjrkjcvFrUeY88zc1mWEiuQlE4kOgiezQ5jToLEfsAViV7CLg
         /EYmrmAfteW0q+FGa7sCB+TNViPHBYb4C76F6/wQMYB+0FkIyzMOfRqjlJcrditDQ/fv
         vj+tOGFnNA5PIc5ejL3eVL/IMhXl4vsegMngBD0TQSbXhyT5/aquIjty68BN9L8EXXLU
         phoGMasO7Px3XtOoLnYRXFNLox0PBgS3FguSGorvSfY4i1CUCNkIE0CUqEqebDQWZSex
         I1Iw==
X-Forwarded-Encrypted: i=1; AFNElJ+GJmnsIFA6W2ZQh03yU2ChWYhXYTRHo4LPaAe/q9yzNIY28Nq9/BaVPhuJkYgXktPDW7ehfBOUgw==@kvack.org
X-Gm-Message-State: AOJu0YyhFJq9AS0lvRAL5eCURQILoWE/PTkWVmDn6f9qqTuq4GO46nw+
	JXegVRIyPyFPvxB41t1EKsR8IX0ljFVREJAtE/4gr60ykjAiXgTKek9h
X-Gm-Gg: AeBDiesrAz7Jl0UF5+8L6uK+YsPg8lDA6yTJKBUzmXg3A7STCjecL4wcqAiiiy2m2Wf
	awUOStHNuzzh2MHsiGj8TwKsf62hE89rcfINe0U3FADaJ9XK2kwObpnVGzCNyCCfhXUnlj8ywjP
	NaF8ZQhNItIFELPQJxW29yKBx0/jIJIN9stnmUVJyW5XAI2xfZcBrjXzR4Uf6Yh+7vgcQSTBI9D
	C1pxXzurtUfIirJG7AMKuUUTwZ3vMr6eRVUGJhxNjg3fy5PVpyxBJjal3FRuVPVYW7c1wFXCrNY
	T8MMRQT6zCC+wRFWs28JKr1ocWex8NAPMIH/tw/oECkzhgxF5WIqY7Hf7BBzysNp8V6qIzd3Yog
	Ddsf8Lh/qujwI6i4Eqi8+KAYOzicShIS/C8SVhnmraeLhnE94nKNPUuetr6IZh/FI7hIIrsfIxt
	GeBDKf6Y7fTEHRVKswwhhmwiDeTrjW0Zm23bE0/7xHbRMluZ/jb3g=
X-Received: by 2002:a17:903:24e:b0:2ae:5eee:7a5 with SMTP id d9443c01a7336-2b9a231de9dmr12418275ad.12.1777524553154;
        Wed, 29 Apr 2026 21:49:13 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([27.4.92.188])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9887a4ba0sm37547795ad.32.2026.04.29.21.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 21:49:12 -0700 (PDT)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: pbonzini@redhat.com,
	skhan@linuxfoundation.org,
	me@brighamcampbell.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>,
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Subject: [PATCH v2 1/1] mm/mmu_notifier: Add async OOM cleanup via call_srcu()
Date: Thu, 30 Apr 2026 10:18:54 +0530
Message-ID: <20260430044854.11132-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E93B40005
X-Stat-Signature: rqmcwacfswbirbtx8m9qmofs4oyedjkw
X-Rspam-User: 
X-HE-Tag: 1777524554-846907
X-HE-Meta: U2FsdGVkX1/4O36SEMv6erEWqJJujXtBysnfQKuTDWl8/wPdM/osd6rqRLVo1NB8M7fG5WpyjOzzntNrOgIfLZOmDa1cWhhyveXMPMfjijtebHuIPsCiErC9lKbqYyvwmj9rcZkUbnWwQJxt8eZ9KH7WfKhY3Q3Hpg7cgTFY/Ijed7vSkC1iAUr0RoCERrUHKRsBmylgI+iBZoCmoi6m8sYRi27I7OGjs7XbIFpjTD5hDCP2rzQqJvrrZVqO7SvBjZWFDeMICEqBhPtZl0mXEMfpnDA4vo2rHPZ8Mlikr/1RG9OzIVB47Us/N1EaptodkDV74rvr2thdRyUOLaKNbIirOibHHbYRBNBJ3FswPDYuoKx0COwTLqWrzuLcBqluxQGQzDIjayhMe5Ubd8t3Gu2LoKpsv1EmOLhM5RAGy0Ab8+N50fisx9WhOjELK9aeFm7uD8V2NetVjIIxEyNol17XZB9P8mgBymFG39fP5nR4IGVSQQcLfGUCYo5X89ebwBQTmy5ZlUEId8I2+EetsmJRHNVnRevHScpZSoEAgax7DtYPJXlhYeiN5lQdQsnOzFdrtM80auhUGLR1r9heaao4vTTgupH2x9/miUy+stIPPUjZebR1/hcLyoN+FFNMLs4mW/WO4TzeMmwwPn0FyTtBvDsCQhmdJlrDr0JDwoWRhEAtofOs67KzSpZeDbXLSBpmg/UQdVE4ixxCyVa0G48BPxyzq6neVDm5l1POLR+f0WfN7TZFLhNtmPkZFuFqLE09na8GqzXyhn8iFx0DLQV0ZazsEXSjQzhRSudtQ1Rm0HaZCGI3oAZ4KcEXloKlAPzChMSr4wklDvNYHQgbPt+5kxjIN0fmlQgTh6zyUP1lNzLuKw5jf9up/URkEYUmggbq3Y9HKi8kO+gGRnT4ete1ad/286a+yJg5XKO5NtHY/YzL9KLx6Dl0sBablFeUn7r6ea53qaM244issWD
 gneoEIzt
 X1YzsGSnq0/PoZZB/E4DI6Hsvcjx7Rm41nNFwVqWJpWITSSYmGky7JNwe08dtTHxQGffnb9/pFZZvEoxVF1CqBkXZ5iBVKWD80/5gW3JyVo/I10ScOjwwn5eSc39ZygTl9yRjFOnMX8SsXJKPZxZvNB5vRWuqOd8UB4Ccbu2v9pWA4EvkISIV/yOUs7umRUBynDJ5SiCPZe3vEsqCZGU1gUUK/NRzEz9oj7zvfwac7XxdeZHCbCgxkI0OxhHBMaR/2u58VL4xgjlEcpilVZF/+bvyVmCOYZXkWWy9bug0wz22D8Yw08F80pOo2IdvwD7uqTzLf8Y6WeEztkd5Dy6EjvRhU7ldS3vbKHxScuQtKodcHtWo0eq053+Ir3wr62AG2MtY5G+VMFfEWY69lZgCd5Td63xXqNg3bMagccRGszS4FdZlHEWiS4ey+eKO/lEIf7aMUQtzoaBZsDYAZ21FaWjG/eUc7IwRa0zl/fdojtiyfA8JBhGLH2v12VkK/Ai4s+ihgHUMgc9B9ZThInSkusbFOXRF8tpMiVqag0y+Vu4I1KRcMyhgC7iECIEjnXtpsMeqpCLAXTFXwmG9KxhdNkyqltqUv/e3gLYWMq1Dk0XeCd0TnpoXKntqavb4RQa1h17OZTzcM++ssPm5PThjeo7CvwpJFP+txjg6JD3FWUcgykpWHXupPssFVtVbD0GMzRIO753hKAPUH4LxRKCuzjmfqCoVAEBbfX0XUYrVC+n+gI5DOXQM2b/LvhsJjKQYFWqd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an mm undergoes OOM kill, the OOM reaper unmaps memory while
holding the mmap_lock. MMU notifier subscribers (notably KVM) need
to be informed so they can tear down their secondary mappings. The
current synchronous unregister path can deadlock on PREEMPT_RT
because synchronize_srcu() is called from contexts that cannot
safely sleep.

This patch implements the asynchronous cleanup design proposed by
Paolo Bonzini in v1 review: a new optional after_oom_unregister
callback in struct mmu_notifier_ops, invoked after the SRCU grace
period via call_srcu() so that no readers can still reference the
subscription when cleanup runs.

The flow is:

  1. The OOM reaper calls mmu_notifier_oom_enter() from
     __oom_reap_task_mm().
  2. mmu_notifier_oom_enter() walks the subscription list and, for
     each subscriber that provides after_oom_unregister, detaches
     the subscription from the active list and schedules a
     call_srcu() callback.
  3. The deferred callback invokes after_oom_unregister once the
     grace period has elapsed and all in-flight readers have
     finished.
  4. Subsystems waiting to free structures referenced by the
     callback can call the new mmu_notifier_barrier() helper, which
     wraps srcu_barrier() to wait for all outstanding callbacks
     scheduled this way.

after_oom_unregister is mutually exclusive with alloc_notifier
because allocated notifiers can have additional outstanding
references that the OOM path cannot safely drop.

KVM is updated to provide after_oom_unregister, which clears
mn_active_invalidate_count, and to detect via hlist_unhashed() in
kvm_destroy_vm() when its subscription was already detached by the
OOM path; in that case it calls mmu_notifier_barrier() and drops
the mm reference rather than calling mmu_notifier_unregister().

Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/all/20260209161527.31978-1-shaikhkamal2012@gmail.com/

Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>
---
 include/linux/mmu_notifier.h |  10 +++
 mm/mmu_notifier.c            | 123 +++++++++++++++++++++++++++++++++++
 mm/oom_kill.c                |   3 +
 virt/kvm/kvm_main.c          |  27 +++++++-
 4 files changed, 162 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index 07a2bbaf86e9..0ccd590f55d3 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
@@ -88,6 +88,14 @@ struct mmu_notifier_ops {
 	void (*release)(struct mmu_notifier *subscription,
 			struct mm_struct *mm);

+	/*
+	 * Any mmu notifier that defines this is automatically unregistered
+	 * when its mm is the subject of an OOM kill.  after_oom_unregister()
+	 * is invoked after all other outstanding callbacks have terminated.
+	 */
+	void (*after_oom_unregister)(struct mmu_notifier *subscription,
+				     struct mm_struct *mm);
+
 	/*
 	 * clear_flush_young is called after the VM is
 	 * test-and-clearing the young/accessed bitflag in the
@@ -375,6 +383,8 @@ mmu_interval_check_retry(struct mmu_interval_notifier *interval_sub,

 extern void __mmu_notifier_subscriptions_destroy(struct mm_struct *mm);
 extern void __mmu_notifier_release(struct mm_struct *mm);
+void mmu_notifier_oom_enter(struct mm_struct *mm);
+extern void mmu_notifier_barrier(void);
 extern int __mmu_notifier_clear_flush_young(struct mm_struct *mm,
 					  unsigned long start,
 					  unsigned long end);
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index a6cdf3674bdc..b8fa58fe6b7d 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -49,6 +49,37 @@ struct mmu_notifier_subscriptions {
 	struct hlist_head deferred_list;
 };

+/*
+ * Callback structure for asynchronous OOM cleanup.
+ * Used with call_srcu() to defer after_oom_unregister callbacks
+ * until after SRCU grace period completes.
+ */
+struct mmu_notifier_oom_callback {
+	struct rcu_head rcu;
+	struct mmu_notifier *subscription;
+	struct mm_struct *mm;
+};
+
+/*
+ * Callback function invoked after SRCU grace period.
+ * Safely calls after_oom_unregister once all readers have finished.
+ */
+static void mmu_notifier_oom_callback_fn(struct rcu_head *rcu)
+{
+	struct mmu_notifier_oom_callback *cb =
+		container_of(rcu, struct mmu_notifier_oom_callback, rcu);
+
+	/* Safe - all SRCU readers have finished */
+	cb->subscription->ops->after_oom_unregister(cb->subscription, cb->mm);
+
+	/* Release mm reference taken when callback was scheduled */
+	WARN_ON_ONCE(atomic_read(&cb->mm->mm_count) <= 0);
+	mmdrop(cb->mm);
+
+	/* Free callback structure */
+	kfree(cb);
+}
+
 /*
  * This is a collision-retry read-side/write-side 'lock', a lot like a
  * seqcount, however this allows multiple write-sides to hold it at
@@ -359,6 +390,85 @@ void __mmu_notifier_release(struct mm_struct *mm)
 		mn_hlist_release(subscriptions, mm);
 }

+void mmu_notifier_oom_enter(struct mm_struct *mm)
+{
+	struct mmu_notifier_subscriptions *subscriptions =
+						mm->notifier_subscriptions;
+	struct mmu_notifier *subscription;
+	struct hlist_node *tmp;
+	HLIST_HEAD(oom_list);
+	int id;
+
+	if (!subscriptions)
+		return;
+
+	id = srcu_read_lock(&srcu);
+
+	/*
+	 * Prevent further calls to the MMU notifier, except for
+	 * release and after_oom_unregister.
+	 */
+	spin_lock(&subscriptions->lock);
+	hlist_for_each_entry_safe(subscription, tmp,
+				  &subscriptions->list, hlist) {
+		if (!subscription->ops->after_oom_unregister)
+			continue;
+
+		/*
+		 * after_oom_unregister and alloc_notifier are incompatible,
+		 * because there could be other references to allocated
+		 * notifiers.
+		 */
+		if (WARN_ON(subscription->ops->alloc_notifier))
+			continue;
+
+		hlist_del_init_rcu(&subscription->hlist);
+		hlist_add_head(&subscription->hlist, &oom_list);
+	}
+	spin_unlock(&subscriptions->lock);
+	hlist_for_each_entry(subscription, &oom_list, hlist)
+		if (subscription->ops->release)
+			subscription->ops->release(subscription, mm);
+
+	srcu_read_unlock(&srcu, id);
+
+	if (hlist_empty(&oom_list))
+		return;
+
+	hlist_for_each_entry_safe(subscription, tmp,
+				  &oom_list, hlist) {
+		struct mmu_notifier_oom_callback *cb;
+		/*
+		 * Remove from stack-based oom_list and reset hlist to unhashed state.
+		 * This sets subscription->hlist.pprev = NULL, so future callers of
+		 * mmu_notifier_unregister() (e.g. kvm_destroy_vm) will see
+		 * hlist_unhashed() == true and take the safe path, avoiding
+		 * use-after-free on the stack-allocated oom_list head.
+		 */
+		hlist_del_init(&subscription->hlist);
+
+		/*
+		 * GFP_ATOMIC failure is exceedingly rare. We cannot sleep
+		 * here (would reintroduce the deadlock this patch fixes)
+		 * and cannot call after_oom_unregister synchronously
+		 * without first waiting for SRCU readers. The subscriber
+		 * will not receive after_oom_unregister but cleanup will
+		 * eventually happen via the unregister path.
+		 */
+		cb = kmalloc(sizeof(*cb), GFP_ATOMIC);
+		if (!cb)
+			continue;
+
+		cb->subscription = subscription;
+		cb->mm = mm;
+		mmgrab(mm);
+
+		/* Schedule callback - returns immediately */
+		call_srcu(&srcu, &cb->rcu, mmu_notifier_oom_callback_fn);
+	}
+
+}
+
 /*
  * If no young bitflag is supported by the hardware, ->clear_flush_young can
  * unmap the address and return 1 or 0 depending if the mapping previously
@@ -1096,3 +1206,16 @@ void mmu_notifier_synchronize(void)
 	synchronize_srcu(&srcu);
 }
 EXPORT_SYMBOL_GPL(mmu_notifier_synchronize);
+
+/**
+ * mmu_notifier_barrier - Wait for all pending MMU notifier callbacks
+ *
+ * Waits for all call_srcu() callbacks scheduled by mmu_notifier_oom_enter()
+ * to complete. Used by subsystems during cleanup to prevent use-after-free
+ * when destroying structures accessed by the callbacks.
+ */
+void mmu_notifier_barrier(void)
+{
+	srcu_barrier(&srcu);
+}
+EXPORT_SYMBOL_GPL(mmu_notifier_barrier);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5c6c95c169ee..029e041afc57 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -519,6 +519,9 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	bool ret = true;
 	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);

+	/* Notify MMU notifiers about the OOM event */
+	mmu_notifier_oom_enter(mm);
+
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
 	 * is no longer stable. No barriers really needed because unmapping
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1bc1da66b4b0..a2df83d3b413 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -885,6 +885,24 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }

+static void kvm_mmu_notifier_after_oom_unregister(struct mmu_notifier *mn,
+					struct mm_struct *mm)
+{
+	struct kvm *kvm;
+
+	kvm = mmu_notifier_to_kvm(mn);
+
+	/*
+	 * At this point the unregister has completed and all other callbacks
+	 * have terminated. Clean up any unbalanced invalidation counts.
+	 */
+	WARN_ON(rcuwait_active(&kvm->mn_memslots_update_rcuwait));
+	if (kvm->mn_active_invalidate_count)
+		kvm->mn_active_invalidate_count = 0;
+	else
+		WARN_ON(kvm->mmu_invalidate_in_progress);
+}
+
 static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.invalidate_range_start	= kvm_mmu_notifier_invalidate_range_start,
 	.invalidate_range_end	= kvm_mmu_notifier_invalidate_range_end,
@@ -892,6 +910,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.clear_young		= kvm_mmu_notifier_clear_young,
 	.test_young		= kvm_mmu_notifier_test_young,
 	.release		= kvm_mmu_notifier_release,
+	.after_oom_unregister	= kvm_mmu_notifier_after_oom_unregister,
 };

 static int kvm_init_mmu_notifier(struct kvm *kvm)
@@ -1280,7 +1299,13 @@ static void kvm_destroy_vm(struct kvm *kvm)
 		kvm->buses[i] = NULL;
 	}
 	kvm_coalesced_mmio_free(kvm);
-	mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+	if (hlist_unhashed(&kvm->mmu_notifier.hlist)) {
+		/* Subscription removed by OOM. Wait for async callback. */
+		mmu_notifier_barrier();
+		mmdrop(kvm->mm);
+	} else {
+		mmu_notifier_unregister(&kvm->mmu_notifier, kvm->mm);
+	}
 	/*
 	 * At this point, pending calls to invalidate_range_start()
 	 * have completed but no more MMU notifiers will run, so
--
2.43.0


