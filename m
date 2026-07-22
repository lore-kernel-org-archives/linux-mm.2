Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A727BC44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:08:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6D9276B0096; Wed, 22 Jul 2026 10:08:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6AFEF6B0099; Wed, 22 Jul 2026 10:08:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C6446B009B; Wed, 22 Jul 2026 10:08:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 28E3B6B0096
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:08:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AD9F6160189
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:08:45 +0000 (UTC)
X-FDA: 85016593410.18.24DD027
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf31.hostedemail.com (Postfix) with ESMTP id E75D420002
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:08:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H+FfXVdd;
	spf=pass (imf31.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729324;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=b3yARu6zIPkjRYLYFArLzUNGA0rAwOd58nNqNxGvnf8=;
	b=vlFb6N2iTfrclsRnNjObS/ZVkCJSLJzvEWq1zu2IQqDqq7YcmCW5LW6Bs+DNnUNOFYKAEf
	beYlOuhZzjl7kpOnLFNKM2Qte3w5E6QpwudRoeU3lxuUKW/lP7LIpiYtsUIF65lXCgEYGq
	8qMsuXa4jM4JBO74RtwiW7twtPNtQ5o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=H+FfXVdd;
	spf=pass (imf31.hostedemail.com: domain of shaikhkamal2012@gmail.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=shaikhkamal2012@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729324;
	b=KTglMOWF6Vsr8esC0D7m90LEuvBC04W3CefTQp6WUK22uHyiBcbhF2S78sdkUk9P8L34pU
	hQQkoYnhP5NLuHoMzLwniyB3rycu1IYCTXIEfGTZxSrRWxyxWyP9xamBEnY3ZrZkpqmmbx
	Ibsp5qDF9WjYpK0MaWx5oUZ/h/gjfhA=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2cacb8416a1so92694755ad.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:08:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784729323; x=1785334123; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b3yARu6zIPkjRYLYFArLzUNGA0rAwOd58nNqNxGvnf8=;
        b=H+FfXVddviOPzNJUuJ/L0N7DIMjoeUVBfIH6gmc1Pf42Jejh/l7uTxMafEO2EOGgBj
         bXxjr4cVwP1ep24rh45L6T8PySNccjKoc7UgjB3/8F2Vo72PcGKiDWl3Cj4D6kNECN1b
         iL1XLVnNmZij00O6//NgYqnd+dOzGgmzuKKKnZnzr19GGa5NSt6BWNinCtRCzZsFVbrg
         k6VJtL5P/9XwRiXSTgCAX1QdIi6jEwio/0mXoqoj/913oJ9bucTyR7hkq2R8jKPlNHYl
         q/0YpQwiH9a7s4NN/ZPMkPlRELdc0RfgYGfqq6CZ1TiwrLWWaRRSVJzrwuX7ny7h5BPt
         U0YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784729323; x=1785334123;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b3yARu6zIPkjRYLYFArLzUNGA0rAwOd58nNqNxGvnf8=;
        b=gLj9XeI9r0ZjovF0E9SKSATORJwaUsuLISvGRJwEcOCU5yRsJGff+pkw88Dv6314eL
         yerQUolsNLR/zlAosJtdcsDQNDMTXeYLTFkdiwCKkLKF6+LU/iYaCV2oWMkGaxt8g05l
         FQjGsPbC6Yd06ELf3uX5Rwgt2Yh+jorueYHHFiuDRqgWFrJMUZ/e2iqGV0WYv7Vgqnpy
         1RPIQ6xEMzdaevpYmy1LhT+akFb8ynbspcCwy/+LYv40K432WBF/inV0z4MwQdKgeMnc
         3pU3X7R5eERnLSlWJSGlAR+jEzeiNSvmbQntwAslt7m+u5zWmeR4GpqZPcGYnb441FZI
         i+ew==
X-Forwarded-Encrypted: i=1; AHgh+RpcPxJphIe3de/UdxIbh7I2kJdLLHgq/9fWjbGDMhvOWUjpi9riwx6j+2HMDYnLkDRBc4ex2E5wMQ==@kvack.org
X-Gm-Message-State: AOJu0YxFzwaVa7vnC6bhfy5BiNqdxNOsNaXLS2vqm0kkonhWToyZh7kx
	KY0u2uPiyv1AJjXBEAVPUoNgttdXNacsdgklcBnPZe14+kHl21kTJXjq
X-Gm-Gg: AR+sD11dliVnrhd+MFQWg+IT8TBmjUxyti0KUOPPKKA+gAuTBG840v4JqDCF5HyTK/G
	7wDa/CHpVtNVv169dvfktrHyawefnsxLW2XVxieXpxzV6rhi3zcmXWR4T9VU3iSa8HQTRAd136o
	yxATVJdnVF4vGvKQ2EJLXafwWJSIl5vGUk4SMcjmRTu33/SZ0zg88NC1rYo5hvG9S3VDMR9QSsI
	1xpbzTFKuSPpnKdsHYf4QUF+T4tUQShdL+rbzLt3Hh/0DU3DWcbvYkZ8yZNjYXrnNMy9F9QQMeE
	YBg+KZPoCbRGjL3qGOUfizxWRsUnsQvz29CjUfJTFK3lpmTXNG/awyKYRdYUutcFj0gYdCjeBpE
	r2nvy8qrdPsKdRAu9isJMfCyDAEZBSL/LBzt1JJ8aJHQmbMbPlLO/OIFLXdDTMWo16Dpd68Npn1
	bRGbOqmP1rSHYTQDEGQEhuTPJLSoYbPtk=
X-Received: by 2002:a17:903:380f:b0:2c1:ea95:8297 with SMTP id d9443c01a7336-2cf3483687bmr238643635ad.7.1784729322524;
        Wed, 22 Jul 2026 07:08:42 -0700 (PDT)
Received: from acer-nitro-anv15-41.entro.com ([118.34.230.2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f2e65e6sm16026145ad.38.2026.07.22.07.08.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 07:08:40 -0700 (PDT)
From: "shaikh.kamal" <shaikhkamal2012@gmail.com>
To: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: seanjc@google.com,
	"shaikh.kamal" <shaikhkamal2012@gmail.com>,
	syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com,
	kernel test robot <lkp@intel.com>
Subject: [PATCH v3] mm/mmu_notifier: Add async OOM cleanup via call_srcu()
Date: Wed, 22 Jul 2026 19:38:03 +0530
Message-ID: <20260722140803.11421-1-shaikhkamal2012@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E75D420002
X-Rspamd-Server: rspam01
X-Stat-Signature: 7qy1kw5dyrsqqzszjf5kn8wyyed4j7cb
X-HE-Tag: 1784729323-208219
X-HE-Meta: U2FsdGVkX1/O6slLRTTXyHWIHWPVYHfW9TBJKDAAcJ45VJUU65eLt8uY2si9cUGptQbXdDoLraxs9ZMBnCy7rHLtxqjBLZhkH+/+jxU+IOfXnNBHLiP9Z+92LIzAUeRalyoBb0s1hvxcLP6oQmLmhXAPGNEOAzw4kScgR7ITQ/Y/gZxUd5gjih0aadF5JmA6Sk1RhCjcZPLOqqlfXkNz/17V7aGMf6EHS+Bvc/X/9xm3DWsliPKA7c1cPWFtCwmg1Sp973QYu3lCXCXOewG4HpVVqk6nqqAtukSAyZtV74Z7cMiIS/xDnz1aMnPVKmG+4cld4QTVkHcn4dBmLlSu+GMJEw6+Z4viWtuaMsVigZP5wUYAKb3/lvKwbKzOZe1u8TrL5/nh6ylh4Zq5G2Zj2comAHwaip7r8s4Ffn3KIJb0Q+eibLeX+/5tFbrahncrkhje1WRdJjGQmBn4Nl9bU9zHoz3rPngF33KleAQSlG9F293/SFcxNm9vbZ7DpbWckGmfRLJbUd56aYWn447JxK3fHNcjqAVGByQlzi79R5R7Rf9Z+BeOBEHcXQN6bZTSuZ0WHPi1SWeULm4p3BaTelxTJhSyVjPaf1J4s559Vkrut9mMH3IzyvOkW3Vq1vcxYLNIMoOQASZ3qnIczQ8bWn2gZ8Qsf2xO42NmUm2YU9jTz4gNf9aG1gcYLNsRRPjpzM+ilIRgOX9QbC6hTU3qzb7UvR5FqUTOaxNmElL9z8sqnZs30IcaSNXx9IsmvFjID6XjewYLw4QwQa9yH6lis9PfhTvFln63zrstxgpktdjbTcp35/zdzC+dU5JuO0zU9KEHvJ0xVy8hdJ4v+Ru2oZ3LSv8A8hfhi83Zise8ig5C6pihcqQpcQ7oaXL6USxFUZlCZOGliGE8qYU9r5bZjgsXg3qZmplgY1H0EgT+Q8xFi5AoUwioxM7sGuClz+j75TsY4A17e3x2f4p8ZNG
 5sN1qMnN
 2p5NkNjvFIpuIv4QcMeTXM9yw6iGtvWUFN5jR+13P+pCx+A1sVLFYqIrL8Ien14oSH4V0sMvFUtDLBM0lXFvdjcwjhAlIx/ht4HP5tyqRVKFnVTBSXHLDY8AY4U2HrWe1JV63mAiXDlN7hoHKcWjKlK5D4KTIsN8elMwkTcF4vm4AKCwXmPi+KET3xrRaG8Fz3goZL1ehi8TwdKfjsHGE0Z5sHdVwuaOyPzTTebTggTDVeRL39xiAE8yLTTucDbUlBFPN+513Yemnz872rkBPqszh3PUVbc0wDlMS0urOiGJOmoswMtRoc9XwcEizA7rE6XE+XICtfutliDgU2ssBdtXv6XRYel0KettAV0+ih80V1xIrUQ8BUJX5YrewLsl63bZMUrMn8rjbvwa5t47uQ/d52lIcg3tVIt5YKF0wUqIHK9kdIBQVOkOK2wY+ArCptDGnjeZCof7B91cKpM1d0lOHBmfQ5qVkczY74weF2ARHxKLN8QkHmUFtzqSrAPKRXUaVuELKPEz1HHrv7imibcJoGl+E3C6Y6cMXiLRydVUgZ8WH5dLgasgPzxBREMMvp47mSUP6YgoCQVrdqbRAJPak0K67aSP2iHEF2Af78yKuTeZz6/6PzoBDGkPDivytDlO1CV2PKrOz4Qbz1kLUl+6VslhVZEXHIY+0MoZMe4UbbWcsaMt7KEdB78gCzcEaBruXaNqrVLZOHMSjPie7Echm4Ro1MnAx9al5YYszdRN1IcAVGsMZlhrg6dVEtUPd1K4Q37051A9jrT5J+zMYeM0gAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When an mm undergoes OOM kill, the OOM reaper unmaps memory while
holding the mmap_lock in a non-blocking context set up by
mmu_notifier_invalidate_range_start_nonblock(). MMU notifier
subscribers (notably KVM) acquire sleeping locks in their
invalidate callbacks, which deadlocks on PREEMPT_RT where
spinlock_t is a sleeping rt_mutex:

  BUG: sleeping function called from invalid context at
  kernel/locking/spinlock_rt.c:48
  in_atomic(): 0, irqs_disabled(): 0, non_block: 1, pid: 40,
  name: oom_reaper
  Call Trace:
   rt_spin_lock
   kvm_mmu_notifier_invalidate_range_start
   __mmu_notifier_invalidate_range_start
   zap_vma_for_reaping
   __oom_reap_task_mm

Implement the asynchronous cleanup design proposed by Paolo
Bonzini in v1 review: a new optional after_oom_unregister
callback in struct mmu_notifier_ops, invoked after the SRCU grace
period via call_srcu() so that no readers can still reference the
subscription when cleanup runs.

The flow is:

  1. The OOM reaper calls mmu_notifier_oom_enter() from
     __oom_reap_task_mm(), before the non-blocking VMA zap loop.
  2. mmu_notifier_oom_enter() walks the subscription list and, for
     each subscriber that provides after_oom_unregister, detaches
     the subscription from the active list and schedules a
     call_srcu() callback. The reaper's subsequent invalidations
     therefore never invoke the subscriber's callbacks.
  3. The deferred callback invokes after_oom_unregister once the
     grace period has elapsed and all in-flight readers have
     finished.
  4. Subsystems waiting to free structures referenced by the
     callback can call the new mmu_notifier_barrier() helper, which
     wraps srcu_barrier() to wait for all outstanding callbacks
     scheduled this way.

Paolo's original sketch called synchronize_srcu() from
mmu_notifier_oom_enter() before invoking the callbacks. That
blocks the OOM reaper waiting for a grace period and can deadlock:
the reaper holds mmap_lock while waiting for SRCU readers to
drain, while an in-flight reader can itself be blocked on
mmap_lock. Use call_srcu() instead so the reaper never waits; the
callback runs asynchronously once the grace period elapses, and
mmu_notifier_barrier() provides the synchronization point for
teardown paths that need to wait.

after_oom_unregister is mutually exclusive with alloc_notifier
because allocated notifiers can have additional outstanding
references that the OOM path cannot safely drop.

Update KVM to provide after_oom_unregister, which clears
mn_active_invalidate_count, and to detect via hlist_unhashed() in
kvm_destroy_vm() when its subscription was already detached by the
OOM path; in that case call mmu_notifier_barrier() and drop the mm
reference rather than calling mmu_notifier_unregister().

Tested under virtme-ng with PREEMPT_RT, KASAN, and lockdep
enabled, using a minimal KVM test program (opens /dev/kvm, creates
a VM, registers memory, creates a vCPU, and sleeps) driven through
a CONFIG_DEBUG_VM-only debugfs trigger (not part of this patch)
that invokes __oom_reap_task_mm() on the target task. With the
patch applied, mmu_notifier_oom_enter() detaches the KVM
subscription, the call_srcu() callback runs after the SRCU grace
period, KVM's after_oom_unregister clears
mn_active_invalidate_count, and mmu_notifier_barrier() returns
cleanly in kvm_destroy_vm(), with no KASAN reports, kernel BUGs,
or lockdep splats across 20 stress iterations. The same setup
reproduces the syzbot-reported warning on an unpatched PREEMPT_RT
kernel; it is no longer observed with this patch applied.

If the GFP_ATOMIC allocation in mmu_notifier_oom_enter() fails,
the after_oom_unregister callback for that subscription is
skipped rather than retried, since retrying could sleep and
reintroduce the deadlock this patch fixes. The subscription is
still cleaned up later via the normal unregister path.

Fixes: 52ac8b358b0c ("KVM: Block memslot updates across range_start() and range_end()")
Reported-by: syzbot+c3178b6b512446632bac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c3178b6b512446632bac
Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Link: https://lore.kernel.org/all/CABgObfZQM0Eq1=vzm812D+CAcjOaE1f1QAUqGo5rTzXgLnR9cQ@mail.gmail.com/
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202605031109.uxckW5L3-lkp@intel.com/

Signed-off-by: shaikh.kamal <shaikhkamal2012@gmail.com>
---
Changes in v3:
- Rebase onto v7.2-rc3; v2 was based on stale v7.0 which the
  kernel test robot could not apply to current trees
- Add missing static inline stub for mmu_notifier_oom_enter() in
  the !CONFIG_MMU_NOTIFIER section of include/linux/mmu_notifier.h,
  fixing allnoconfig build failures reported by the kernel test
  robot
- Use kmalloc_obj() per current allocation idiom
- Add Fixes: tag identifying the commit that introduced
  mn_invalidate_lock

Changes in v2:
- Complete redesign per Paolo's v1 review: moved from a
  KVM-internal locking change to a new mm/mmu_notifier
  after_oom_unregister callback with call_srcu() async cleanup
  (hence the subject prefix change from KVM: to mm/)
- Add mmu_notifier_barrier() (srcu_barrier wrapper) for teardown
  synchronization in kvm_destroy_vm()
- Move call site to __oom_reap_task_mm(); use hlist_del_init() to
  keep hlist_unhashed() correct and avoid use-after-free on the
  stack-allocated oom_list head

v2: https://lore.kernel.org/all/20260429222548.25475-1-shaikhkamal2012@gmail.com/
v1: https://lore.kernel.org/all/20260209161527.31978-1-shaikhkamal2012@gmail.com/

 include/linux/mmu_notifier.h |  14 ++++
 mm/mmu_notifier.c            | 122 +++++++++++++++++++++++++++++++++++
 mm/oom_kill.c                |   3 +
 virt/kvm/kvm_main.c          |  27 +++++++-
 4 files changed, 165 insertions(+), 1 deletion(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index a11a44eef521..a1820a487854 100644
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
@@ -424,6 +432,8 @@ bool __mmu_notifier_clear_young(struct mm_struct *mm,
 		unsigned long start, unsigned long end);
 bool __mmu_notifier_test_young(struct mm_struct *mm,
 		unsigned long address);
+void mmu_notifier_oom_enter(struct mm_struct *mm);
+void mmu_notifier_barrier(void);
 extern int __mmu_notifier_invalidate_range_start(struct mmu_notifier_range *r);
 extern void __mmu_notifier_invalidate_range_end(struct mmu_notifier_range *r);
 extern void __mmu_notifier_arch_invalidate_secondary_tlbs(struct mm_struct *mm,
@@ -643,6 +653,10 @@ static inline void mmu_notifier_synchronize(void)
 {
 }
 
+static inline void mmu_notifier_oom_enter(struct mm_struct *mm)
+{
+}
+
 #endif /* CONFIG_MMU_NOTIFIER */
 
 #endif /* _LINUX_MMU_NOTIFIER_H */
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 245b74f39f91..f30bf95f17c7 100644
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
@@ -385,6 +416,84 @@ void __mmu_notifier_release(struct mm_struct *mm)
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
+		cb = kmalloc_obj(*cb, GFP_ATOMIC);
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
+}
+
 /*
  * If no young bitflag is supported by the hardware, ->clear_flush_young can
  * unmap the address and return 1 or 0 depending if the mapping previously
@@ -1144,3 +1253,16 @@ void mmu_notifier_synchronize(void)
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
index 5f372f6e26fa..66adcd03f36a 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -516,6 +516,9 @@ static bool __oom_reap_task_mm(struct mm_struct *mm)
 	bool ret = true;
 	MA_STATE(mas, &mm->mm_mt, ULONG_MAX, ULONG_MAX);
 
+	/* Notify MMU notifiers about the OOM event */
+	mmu_notifier_oom_enter(mm);
+
 	/*
 	 * Tell all users of get_user/copy_from_user etc... that the content
 	 * is no longer stable. No barriers really needed because unmapping
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index e44c20c04961..79a4df8a337a 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -875,6 +875,24 @@ static void kvm_mmu_notifier_release(struct mmu_notifier *mn,
 	srcu_read_unlock(&kvm->srcu, idx);
 }
 
+static void kvm_mmu_notifier_after_oom_unregister(struct mmu_notifier *mn,
+						  struct mm_struct *mm)
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
@@ -882,6 +900,7 @@ static const struct mmu_notifier_ops kvm_mmu_notifier_ops = {
 	.clear_young		= kvm_mmu_notifier_clear_young,
 	.test_young		= kvm_mmu_notifier_test_young,
 	.release		= kvm_mmu_notifier_release,
+	.after_oom_unregister	= kvm_mmu_notifier_after_oom_unregister,
 };
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
@@ -1273,7 +1292,13 @@ static void kvm_destroy_vm(struct kvm *kvm)
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

base-commit: a13c140cc289c0b7b3770bce5b3ad42ab35074aa
-- 
2.43.0


