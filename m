Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 123E6FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 22:26:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A93406B0088; Wed, 29 Apr 2026 18:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A441B6B008A; Wed, 29 Apr 2026 18:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933BC6B008C; Wed, 29 Apr 2026 18:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F06A6B0088
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 18:26:19 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1FAD01C0094
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:26:19 +0000 (UTC)
X-FDA: 84713028078.23.865F8FE
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3D00B1C0015
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 22:26:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=THspf8mQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777501577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
	b=u76Qsqhl6WgPMzAJNwVW6xTsfnjW6xMZp21gHWDnaUmrmFD1vZzRggi9f9x557NC1yPnrB
	b8XZNbPwN4zrUGoAQinSLrMNGWttJlQWMIs1zAXJK9/yAdWXdCIoghYscLW/zgkxrguIWf
	mwk8D+9GQgM3Pv74po+NPNkAnq00lrg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777501577; a=rsa-sha256;
	cv=none;
	b=uOLKGeZemP0mkZU1lTR2CYwKGHuniwB/4QF3bctFftIR25F/OpOCaxbDY8rKPSUoA89Pai
	SGGzS0KF3x66DOYgG00myVTWULIfWfGCz4MUMVzheMhh7sp1kH1Dlsix+cIPqB4Euokb6i
	n4CYThmFIrqpJd8B1mwfXmLL9RuurEs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=THspf8mQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2b941cd869cso1527925ad.1
        for <linux-mm@kvack.org>; Wed, 29 Apr 2026 15:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777501576; x=1778106376; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
        b=THspf8mQ5J26BdJDIWROSe3szyvxvifAjxwEWcsykvOkEQbRDJTmiijLJdXhDa1gEw
         FQCUCuhiDyxGReiM15qju6VCMKXnSvKbI9s4CEyN7GJbllI1B7oLFeFzxcvlCJV0zU0i
         sdaV4yDv1YJyKvDxijl/0bljJ55X13c6AufZ2HNO/YLbkUL0AChJI9KFchw/9JbB45R/
         X8Ynicsk6yYgJGfBdBNt6xOjRgDy7IrtyCg6BwFe6ITbuE1u5HFMUCi+FMK/IfPiwTs4
         OCKgWMIiUpOMpqdYC7wO5FODqB8CR8QGJgwRvqEtBAny1SSfhKxxPNnjsClt5k6GwOcB
         u5AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777501576; x=1778106376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
        b=hopVMsVh8THkL9n8K5x8oi8szoFhcOjqMHYRw7+ukZrc0m0RwK7uD1J9wP0YL1AyOo
         r+sVmDrnEcGYsCQNrNK7lal5YFGKKNcqE/KjfdBfQ9/cv4HTbDxycGV9LfQcRTYbHeT8
         /jt49M/DPMdf2Ax6OAsHcN+M8Csls2TRSpLmGNHxbLjCMvvxOhSLR19AvxSVsbL3wXwh
         fQIXEUp4Yrt62+mP+ln5cOjRvn2XSuY/bH0zr/5cQxPi5wa9GukDd8jxmT3GquZc0uPA
         TSKBH7P5DMI/gy/nfzN6xr1YfJ0jIa3iiFJRs30ABIG1Ih09ZrqOXqOkUIdA5g5QtGjx
         5oWg==
X-Forwarded-Encrypted: i=1; AFNElJ/E12c4zaZ/sp8/z2AFjJkIqOkCZtb7NHyK235A8IFVFqNdG7TUOxj0A/C4ax7IGOW/QWPaM5T4+g==@kvack.org
X-Gm-Message-State: AOJu0YwUy4GRc0gSAMBBiK3jLZgWZDpgl4ISrKeqLdNQGt2pt70AWj0o
	0N6kngYG68ODJ8ByKv8LDP5ZgvtrNgBEdAfpgwog6L/Yva+f62b0josl+QhSceGX
X-Gm-Gg: AeBDiesagMRvNJAHDkNQZBWoKB8XenU+AVTjetaNCjD+vI/ZrIjrheW9src+lSzlVDQ
	F0utJwgkOSD9rAow9izaIsSmVabdMwWpVqo7ymxMwTq3vuY1K0I3rdauDN5hMGLgglxm4F+qvun
	VlOvRpkKWROB0/L8BYTlK25usP1590Aaf6Cw2/LFE2thuYAz4JFyqhFf/6rvg03eBveDRPm5rDm
	dmolc+KEzEKjo7nKMR9viD39gAsuCHeCp/LXqdNuZSW0wOze3uOI1YVIGl2jxioqrGCR2ighavj
	bwHMyA2pSUgICK1JrsJvaCcovNcpBpn3dPyrZcUZEZQDM+wLJEdaC3GWwFZV0c5wQSnPfifo4To
	5LG514mFhYZgxm0F+uSg/ablLyxYEIZIZwJIuEFgth2elJFv5Z3+7t8HkTzGMQlPBNdyOeGPThA
	182D768raVWUCsXDbCzyi0RgUGjtPPBbC3O1Fy55FBr+DaD/OzuNZSzUhZQ+zf3Xg=
X-Received: by 2002:a17:903:1a2c:b0:2b0:c90f:449d with SMTP id d9443c01a7336-2b9a24be0c0mr2628045ad.19.1777501575708;
        Wed, 29 Apr 2026 15:26:15 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([116.73.138.1])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b988798368sm32399365ad.26.2026.04.29.15.26.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 15:26:15 -0700 (PDT)
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
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>
Subject: [PATCH v2 1/1] mm/mmu_notifier: Add async OOM cleanup via call_srcu()
Date: Thu, 30 Apr 2026 03:55:48 +0530
Message-ID: <20260429222548.25475-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <ac08V4TaM2yh9SY1@google.com>
References: <ac08V4TaM2yh9SY1@google.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3D00B1C0015
X-Rspamd-Server: rspam04
X-Stat-Signature: 5cjo6d1w643ym6hpuoqhmdnqe1i7yfib
X-HE-Tag: 1777501577-284746
X-HE-Meta: U2FsdGVkX1/MyMCq/yGPK5M/UKFUxxO0r9CC1hyRweOCwq/Y9O7GYvZKgV4cmvduioNuATZiLeG0QhCj/SohA+DxzO/VPZvM8cIZnNBuNQF+VumHJCZ5hYsXFVrbkNx2s6ZkBeWSX/egwJ+Rs5ip587+WUYgk5UuQDTIQcOQ7WPW5R0YOqS7mpfpSQof1jEt89H/R83OUkINOJKBsiUMHpFxeUG2Ddv/aWOUKTscnYruC4HsE3mQE4kN8ozUaK1AykS76dU6/KdCwjA9SuXoiGgM2e2L9WKVxFSImS+uK6MoD93XVtx8psEDHPFODRZvtTF2NnWe7h78MrO312y/GcmWnLcV7GfSmR538inFZwTgPDlWOs+WYOtQwAUsG5QtTedmor9BYgVCwX/9PHIqlimSGpIXkpOuKkCgxd4XMxd1rbUc6jlmssAv8AGhr8cWNoRyZP7GhSllSl/zC2WrNCLIdhLOhnTwLM1pY2s+jbk1ui1V5KwYAm8vhFGofAoMBdtrPZFOlbdQb0aEETNCpSmSi1OnnGFyBN9FQWnYHB/DfU4fDhVkVeLWYBZvEIiWUBWuRdK59LGw1RcXmoBLYwxAVPENt+o1PrgsMa2eO5BD1FcmPdcELQoztjzXcgqU1F2/TzIp9BY9Ua08mPmRvqZUr7oSPl6LRUXy1OO4hFgRwFbGiWxyx7Wm2HXPxBP42kukt8Ywgkabq7WDCpaZl3AYT53o+zgzxluN/opXJjRCorsPS/eE9Vr/kRuvmVKyvF2OUcuBOuLcuIJ09mIhbxcArqO9cq597tTubzeTuaJ4NXOxQHoTakL+2B7OBzBdACnH2aSNG5IEAUEhCI6jp/XMo/99PMJFF4KyqtZtxUvqgQI5EkLvPwFdQpUO2ZmoDRAzgoNE1a7kdQN9y5BqEI+gh3AdD8SJlOI+qptL20lKu8H21QlzY9onD3wwvDMn33LaOx+7kpBTsxtpQRZ
 nI6rYfXr
 40rIHpgGe9pw847Cf09fr1ni6VvZk6dYrhLGnpZGgwK/cfxrsWFrx/0ZYkNbj6/0IQ9mFRSLQptiw56TXQwk1EfNwNym1CxPTy3DKCkxZ7myF9olPnEZBMr6U1ADema60kqD4E3a1VpI14D04HpxKzYtMLVPp3SP1IcVyiiUekEJsGxFS6cIo0iDkxoumsBMWiJ+EumcpMaLtM057VIu/TwOiUdofo+U5tjAx8rcWsaIzlgO61UG7gnBkefnXDn4QZ4OAmRPEmai3g9/K25SHVAJToCeu15D/fyzkDFewCeQCpAdPAh19eACOVMeHHNWFm4i2UMmJbRUdYqvGTjLpKTEUU2LLBR9nlQXuUOaH0VfKha/+u3Yez8gs3Ne6Ejq/BqPLVzlsUk17WnipthCx24xMGphbsHCqASS1jwYP15vDiDX4iBlfFJVTwV2XWwt2rJCSnCWBW54sAhLSMYjPtbKjeMHQrx55dY2U+3WJZncgRSrK+mXWLVGTuQbu4sIUQP5JZV2fuDfopsvzJtnE+gtHVSbh+nKrAn5Uw8cpWMGtfiJoQhulCAmCcyNsrcZ27mFUK8mkb2U2CEs4ESQQXlkhzZRzcdR1PGNjxbbQOyHm75mpCDyLFN3bM1RVIUNwf682kjNbURnhs50zjzOM93YRd+uDc+L+Pvjn8zPXqlRIB0WHnmMZ81A4dZe7Yv2Uw/m8TzuSi7B11n8MUna80v09Wey96S/OLr1LGmuRsTe4uHa2evRhpPDg65TV8Js2DgyH
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


