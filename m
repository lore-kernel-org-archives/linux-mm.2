Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB7C6FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 14:36:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C4286B0093; Thu, 30 Apr 2026 10:36:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 174A16B0095; Thu, 30 Apr 2026 10:36:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 063AF6B0096; Thu, 30 Apr 2026 10:36:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E9DF16B0093
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 10:36:31 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13E1C104B03
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:17:23 +0000 (UTC)
X-FDA: 84715424766.27.2D37A5C
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf18.hostedemail.com (Postfix) with ESMTP id C32891C0007
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:17:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VkinYHhK;
	spf=pass (imf18.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
	b=IAjipfPN/jqZr1j8pVl1EzeQliYuWMfSh+AFx/yytMORKp9il6QWxPXaSAHyZCmmD/Plmg
	qN/xyRxM5VjOZOjYV6TQ2jLZrb8eNW5Y8sJpUwF9PMyy5eYIsMnNMR4lHmj9URnan/6li1
	Ma2ECUWRty5dZeL8g86HT8f70jh+X14=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VkinYHhK;
	spf=pass (imf18.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558640; a=rsa-sha256;
	cv=none;
	b=msh6TXFoMFelAS1grVLiDYBhWMc0XbQJhieTeODs8Bu+Zf+eJCQXc0UiFad6Xn4bRdAI80
	213GvstVd8ffGfYt2rwZUAlL1Fx40xHNzVx4fo0kNhwgtwGJqJSLTUZRZPTAnaszpfwVBH
	UQywPhRubayx/30Y0qpibvTK9XTjMT0=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-356337f058aso613595a91.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777558639; x=1778163439; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
        b=VkinYHhKlMnnXBLzCsrmvaeXX0UulIs8ORl/NR1PLK6bHFla2RA4kKqQnbK+QYdWH5
         nS9wkATMKsGf6J8s3C25f9Sdlw2oxTWGSHOt1OdgDnJG6yqu2PnYJ5VE8P2+FtF3HEH9
         LQ8SDKmyvvi6bcrJ3eFKOwj7XqTDmt7AbY7OwPnFSm7rys2RVZb2WWDwrbzd8flQxQsz
         NLPrvG0ukSNZzxLkAzC0qjRmoXmybMQ18ChidmoyAOGTdtTtrZx0HC/cr2FkSpb4g29n
         dL/bLYHSo08Z45LQSesbt+tqLaHfFxAK2Kj4R5y3CrcLMofdHF17WvX3Fc7kmUcY+TOX
         gSIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777558639; x=1778163439;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HnGB2EwUnXNoeP6sM/wyCp0a9lWSmlC/c3BKgkuVX08=;
        b=lSkTF7dY118ltTOpEiO/PPwe8lXSMLmMV0WmC44r1D6sapgmQbH/dllhqDOKdfTrrN
         ze1O+BfmPzNlv63rWHwSc9Y4r+gH8EmdiYcDtt41waw8VMEfADtf5QeV+394ecPWIYcp
         BMzZdWgTd+FIuAVT38yQTdnnnfQpZ0ufjWlczKcMvmV/DrhhgLcJVP6UHtdWcHNe+yqG
         WlcJtjlUvpRMhuYtTGfft6Wze5ogbhSiIPc7byUnWlWhRgUC8heEw6fPYi4VIKLNW026
         TJ794kVfcFvzvUY57igWkEW5DMuMtKwj+yAuvRYVy7JSNAtW1oszwiXAuGC33WFe1JNz
         6rqg==
X-Forwarded-Encrypted: i=1; AFNElJ8I29B4gZu1rsleWIrrQnJfuLGanpi+zZckQtuKG+ujTtxXVCYGMdPJ5VZHPq5a3jsZytDrRgZpgA==@kvack.org
X-Gm-Message-State: AOJu0YwAd2mzONQPx6bqchqVp/wdEVLGwgEECMFnzUbQbqK8JvswjYJt
	u/npw08qPzzHpT3KF1BdpkKxy2jfzCkOvpHse0wyXN6XLOi+3b8U1Eay
X-Gm-Gg: AeBDietUBndENbTXTT4pD2baGotSl/fwiCDeHK705wf3solFzXOWOLGet6BV9ScI4GD
	xZB6mSerc/AZDhnG0qEUECHq2Dv73QcU41p79I5HB8xNYbpm+9H8h/oX65al/LGdu3KbkYm1D0B
	kV3oIb4nR45orJ+PNmpoWn77dzqpfhNIow+qbO1Q1OwLpgoduuk/tX0WV2nQfRAGuA6NuuF3swI
	ocr3GsgtmbUhknuhzylJDutNQphZ91Iv76cGG6saPd1zAkxVvuFC1DtmupYuMwUF59CnhfAeH0Y
	kOd6YximSMO3b40JEEZyKoFRA2Ok3iZRHnyhc1tyGFHwBg4xN7q6GHlNO+I7ly9mJshMQSOoeOh
	7RoH3zPBzhAk37+ZcAX2pwsigOXvxTdO62sYdOJOiXFeMdHwmyUf2ToeISEv0OUgrulzEyD0y/+
	DrjRjFTVlXnUNmIBYRzllRR8QnmzhS7plUGUFm2mKq713NOV/wjY8=
X-Received: by 2002:a17:90b:2804:b0:362:e7e5:a20a with SMTP id 98e67ed59e1d1-364c2f23636mr3137181a91.4.1777558639123;
        Thu, 30 Apr 2026 07:17:19 -0700 (PDT)
Received: from acer-nitro-anv15-41.. ([27.4.92.188])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-364a1213600sm2316777a91.3.2026.04.30.07.17.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 07:17:18 -0700 (PDT)
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
Date: Thu, 30 Apr 2026 19:47:01 +0530
Message-ID: <20260430141701.10859-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com>
References: <CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pc9186541kwn48iicdecjbze594y34fp
X-Rspamd-Queue-Id: C32891C0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777558640-520777
X-HE-Meta: U2FsdGVkX18paebSilYyuEGsDW/Kw1k3S78RkpR2Z4Mdg7FrocW6l1dTuOlkMo6iz0SSfXOV7XXWGLzdlgssF1yU3suYO//+AmAIiwDwPOaYE1gSy6GZ8gbr5WO5XtEC8bDlnEAt6cLH5Cd5YgkGeU8v2q4pk5iGpMssEQ0zjlyprGUV9FNFTqDTJos2/6KpQg5LhdGGh4hw5e+L3iz/OYum3VVU0Lxl23qKHIruWtBVtpzcEqv9ZOWnqKDGvYdSG3Nb50TQUKwsjyoRwZmLHJcCgRW3WmJVZGT/ggbigSdV9dYrO5AtdJ5Fj55Y2SHEUreulgxEWgvB5Xv0YYOP1VCPwY22YUpDGdyGfzqpYyWgEC5KFH2SDa8ovwGOtqSJU0LTGJmmmmxa4R7iU0SG61wP2Sz/BcDbmTeaKMhDrsCWd8H0wIvygbuac1Zi2dnXuLzV+enqa3Dbw9KswuL3EO4mNrEQLs5yCa1gbWcKdiEw8I1viyjnlgF2xuAlSxVKp11QbGHeJZRjYIvNW720JF9UZO3Ic1fuzoOcigfPsF0ttCRGBwI6GmVogwBYQleM2NTl7L3XR9RMr5uuK60ycL5n4P1GmgYcJSb+YnkOCAQaM9OW3M1s/ENDcq+iX16a/gblDT9nNqPFS/Q607/asXNcD/h9Wqrw1kzrsLcJXDpv599r9iG/B7oqgrtWZLcNRdaOB9SCzg/Bx56Dh95E52i1LefSkKKcEjeJ2GjdBxHOFx8zUGjSYacglB/49r4RsDSyvQGkPSPDCV/ODQzJz0ojfRf9yU9s8KdYjdqPumSAp63kjce6GDkeUXAVa23nzuMwr875m9S1r850GT5SZuTGJM8tAk2BMb94P83AJz1juLSMZfgAhEKnwr3f5/G6gDKLwFjTxNY27qm9YdiyFqjvMqmHi/AoNUMOZlG6Qcoey2Je8YcZVl+VPe56/JsFOY7N9oCR0BswKkchsVy
 131jhZtn
 Ssarib+Kjbsx+QqA5LQ07c3StLisU4UszS1hKn5FFbf1nZybmwQaboyJFJ106qAk45e5biqDZ5mRB7pNKvuVnBkuqO2U2hc3tLchmsMKXjUC46zBamaitkUlinD6dq8uzEDeM80WA+zssf2DjmEt/bLip/f7wu/pzREWx1OMkT6pGoNOMfsF4FceM+nlh0F6avgWngZiPkx8VDQuDgAUH7hOLdhA90idnZxl8xvVn06eIzdArOOLcqzMgukuuScM7d3fJuPHcG1ymza2YgOlrLupQ8+G1+aFyDFpsRh1wWU4dJdWLSuIdD9soKCNj9/PRt62VQ9qXlVivY+gxiJ5TBiUPpYljqH5v+vTxTeG1FzljagMInHXUaddnUdC/NlbglxWBjJ729pmH7bhotx8rTKQTJkyrXxiasIhDFK4eIaa1lBsgV+l7ATiQ2fAH6an7uLB+PcewzDOe0ELKq2dcFyEoDgQz3kbTM1+cseTAGgDTda7v8ENSo6ba7UDpyIxhh89AwiKuvI3VKwnhR1+WfsCqQJTqFWjEHeoXz7eoNS3RoYKVbmWNH3r0/yEjiIVTRK5Z8waoJ3VIcfeBJAZdA4ZQbLV8yibOLie7/mjqRG5pbn3B2xhuBNjsUGQCbNRHxgydoEbxmSndtUiAjLyZT2oABJZL25nBrn4kQ7uPSqZCUnOyKFbYSlhN9Gca7sn7XuJbnrg1AkwDdzyD5KIjJOEIoOSyrBzvqfG23zn8Ne9WIiTf6B+c9uWee6h3xuIphEvE
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


