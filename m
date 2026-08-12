Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37890C5CFC1
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 01:11:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B42046B0096; Tue, 11 Aug 2026 21:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B19426B0098; Tue, 11 Aug 2026 21:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56376B0099; Tue, 11 Aug 2026 21:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2107B6B0096
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 21:11:14 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 98129A0297
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:13 +0000 (UTC)
X-FDA: 85090838826.15.5301143
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf06.hostedemail.com (Postfix) with ESMTP id D5D1F180007
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 01:11:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D8R5hyZT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3Lsh7agYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3Lsh7agYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786497071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0hzY3g44uXowAt0+2JMtC/O3POXajBplXpibjpOAL8=;
	b=lb0eki3JKd5co5eozIlhnReS9ipA3PSpO+GuY6PEGcwkaFM4vP+fFhEmTL/Utq1qMPgT8m
	vX493420NtABG/VnA5HRpg0DWmbkGbNqVUewAhNURyiIDEqbnjG8C1YJ6xhBPn6lsVl7nJ
	yHmP3XASP2yvmLAKk1pBok4f4QVL/2Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=D8R5hyZT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3Lsh7agYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=3Lsh7agYKCAk130nwkpxxpun.lxvurw36-vvt4jlt.x0p@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786497071;
	b=NKT5etDXLxflSRfh885pmmRUHFeebGmyBpOzXMn3fxawPUagYap/K3RNAChChVdYVb8XWv
	3aFPG08jyGI0fU28a8DFCpmegX13X5p9q1F0QtjU0ne0csdB9AhENddUNn+DoR/6DhyD/k
	FXS8cfYCR8F9S0V9YcMVyO80YWcYYeM=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-8484ba00601so557941b3a.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 18:11:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786497070; x=1787101870; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=i0hzY3g44uXowAt0+2JMtC/O3POXajBplXpibjpOAL8=;
        b=D8R5hyZTX8+O4AocDMG6q3LGboe1B0UeCianBhtAySDXs2IdV1+vBLoOrbsLupJoN3
         oN9YHeW8U5cr+nTxD1LqpYiPTwSK35yzujKuMbdEyY/wmCGLOjFA2PduEvsJc7xb8fgO
         YrujcodbYEf4WzR4gNED2tVaQe1RrQbYg0oDL+AL5bvKQ8Ys1DvWDp0qXgrhdNSmeChR
         JnGI7AZ6luNDuPxuzGfsHWCtA3KJ+qIATyjSRJvY8ZY19U+rElu+ikuCpI2ebC7SYQc5
         s7wlldB+XpxfXBRID2f3JiyCc08CB90lb0rzDuAM1KFQX2V/SyU/7eQGtim3zzqpCNlf
         LxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497071; x=1787101871;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i0hzY3g44uXowAt0+2JMtC/O3POXajBplXpibjpOAL8=;
        b=Rb11WBp7lZNLsubeOZaGZkbjt09FLtBGRuMemgAELdeTCFJQiJg7QjyhirTAFBrU8G
         ixPZsPx/9Kvjdus7IRcCQkgoJMo/OtwozUvNMS2dChQ+pUaeDXBBNE2cV45M/fkoXNMl
         8hUbCtb5r20oMSrUk20kuE5XhNsMTR4pY+6k9bI4Q7BZxcIMsfaQWRbayLal7v0A5eSc
         tbH8QPd5+r5x+zL0OQ3g82psFS4AUpsPlpRziuTr8jFCD+ua5i2QhSGYevzL4xYpfX+5
         ciFVW3gEAJJdFjIpfjTQ/+FW99ZfBTbS9SUY4/1MjE+wYTTNs09dx+pXiz6GJ4+CrFv6
         mjLA==
X-Forwarded-Encrypted: i=1; AHgh+RpYe6rBS8hjaP8iTFKGFiOFXkxzb+5jNs0mTITdew+G129JjPR2XpCPs4T2sEEFKIC0xu8vW/AnZQ==@kvack.org
X-Gm-Message-State: AOJu0Yz/+VqCaBt//uOHOOJkOxR64uqkY9Pr1dys6out5TXgz1CU0n1E
	kA0dJiek7TPzWgaOOtZfUI+EPBiPC1c4QBH6RsjZlJMTeNWaV6cWQmXgXADNHGT2fPbcDDwx0R0
	jILoc+A==
X-Received: from dlb8.prod.google.com ([2002:a05:7022:608:b0:141:3f8:cbe2])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a20:e291:b0:3c0:b55a:80ff
 with SMTP id adf61e73a8af0-3cc3f716297mr1026311637.24.1786497070311; Tue, 11
 Aug 2026 18:11:10 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:10:54 -0700
In-Reply-To: <20260812011056.902771-1-surenb@google.com>
Mime-Version: 1.0
References: <20260812011056.902771-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260812011056.902771-5-surenb@google.com>
Subject: [PATCH v5 4/5] binder: Remove mmap_lock fallback
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@redhat.com, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: oiuqnktt1ytgssxy1u41dupmbpqqfbni
X-Rspamd-Queue-Id: D5D1F180007
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786497071-2507
X-HE-Meta: U2FsdGVkX19mhntSwcxV+wnoiGvufxySxatdtVuCNqaFywdpM9auNZpypXLRMQmC2cE/PGtVf8mI2iU3gTRyWwZUdj4dy45pthk1chFpZMkprKmM3XaphbU88l0cXQZEhxeUxStOJbhI6ZP6ulQuCrTI7eSnQaeKyhvlkRwgAyq3kjqTYEyG/5Qa0rEomeP2G9KaJrMjSsqwrEfFXxMSU9r/Z3VSGSq9052StTOTm/PLNKKGTvhfev+bpoqQaPxo8zSJ43SQCRKm8pMVqL8Z2cJX7iUsHyKkkesI5megg0SLNdsmVQbfJPGn4DbpOOw3dmVVby/txa4w04dB3bhbA3NjORMp8cgsPw19XdcVgIcDrKBtzFBYCFoBkCxG45Q056LSGn5Kgq1igKc8GI8nwXrBglzg4v4lqfHmwgTPDvHZ45bceoC+lphQBFBG+gLjt7XzNelpUu46xwp1TpIW4VBb5SeDqIFwcHHK63xLwvb07554UWyefK8qz53bH1KxW8M6QkgAL901YuonlTma7PDc2wnFaM5l5JWUdZ6zlQb9dRTA0nWd6tmovuW1UmE68etUy0Mt/i3DyGCrzn7XZVnZISUJ7mLvz1bDlmfePLE1CZ0pEnNWwbRgZSeKqhSScqDUeBFJHm1/jkxhJ4YN7n4LDCnHSyfrdiLprbHXRw2wAMUNNhlOrj9wfwUfbl7dkpGPtjJJQ7ySi+80lrjwWYFidCAjw1IVKScAJ2pypQSkSUUnBwdG+suHtQjff4cD88KRs+9xuFo3gpmguj3S5jcWiWT/EQOjmMq8QUwrOX73B3gZ6QvAlmPq+CM4Aiz+S1VqlAqV0Vc3jKjoosECKpbn/MgBLBjgok+xRrhZSGzJkbnPmjiF7lSnTa1QcO1+UxXMQJh5fXbUl9CcBIxDT3gG5UXXVBT/CE6SLL2A36Wd5YoaPZGl9e8nqB7x8r2rAQjMj7HRiGM5VILuKjo
 SKJVXGVr
 TPOvoiEjpLxBsZHKdrL+Ukihen6PsJxGvpMU7kaOE06KvmSX/GQfpMdmRGHsKyxm/3UiEC/QHZy4YiJA7hZZIw4UU5i05ZVCFkfRSEZtJPuTrFAKPhN5ycO9x7NmTm7prNY/ZH2HeFSUgMz3T9NFvpTxCYsczU+9J9tW0wftPC6f8+GIKt9eq4lfxhyzo68nA9v5IzLuYp9GP3qnT0zb/tnV2evkSnuBwHBdwOWh4Lv78rYf13yWhNt0vRYaO0bYhNGSlh8O5lNsIHORRKSm9xJLOmsslyKtOAODaqZljOYMGiAx2tDYSYcqr2mGYG9o00DFdNQ6fdi59RXibyjD2lAzB2vfPTeK9qhpNS5Sk1FC+4ZekWjSyk0yLnP5Rqjw1kfoJZ/xUZRJNqZBbe4cbRbOoj65qvy23xwoduc2zvIt8jb72P8m+0/KRm2mf0TEDUT7+D1aXo8rFQeaKG23dX7dWMtJAxhdB3PkEbSaZxKgzRBt2J71Jp4Yn3qn2t4OzGAaZUWkz3HyVgKzUkT+geLwvScbbSbJb9uhdUVd9lqnyCWg7JrIml9RlPuzI3nVcb6Lc3baJ3miOacwMy0O79xkENPuud89OBiXcnmyUxBzwvCyASDb3Hj+im4wvz6WURxHn106HfuUWmaSaxuOoAdUIp4lSrs328Zb3hVib10UXynfB/MJ0hgEppQirS8VywJbEyDN/otnw995l5khaIoCU+/To7D8VMIXFOAJyIEGTNEZ4LUyyJvAXuOo7TKd0UMvqveNWpmVSEGoQn6vGSMeUsOMI5D2igRMgEoxRVn4x5+vzYtvCuESCDQ3H5C/6/iW/ob0SUBQZapQFT9p7cD4VtDfGhzFWdYT1hiLC3Oqxe89LFm07C8oIDKSfTkeQEZuSzym+/Py6G020gwBgBmkA7C9NjOVumn64tKPlWDkHN/kCEBNheYJKfXnfZDC2tSLzvLc6NLk9xSxFnXMqzXB+yhI5
 SfPQWLa2
 pvwx0iezO04=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

Previously, the per-VMA locking could fail in the face of writers
which necessitate a fallback to mmap_lock. The new
vma_start_read_unlocked() will wait for writers instead of failing.

Use the new helper. Wait for writers. Remove the fallback to mmap_lock.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: linux-mm@kvack.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Todd Kjos <tkjos@android.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Carlos Llamas <cmllamas@google.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: David Ahern <dsahern@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
---
 drivers/android/binder/page_range.rs | 19 +++----------------
 drivers/android/binder_alloc.c       | 17 +++++------------
 rust/kernel/mm.rs                    | 27 +++++++++++++++++++++++++++
 3 files changed, 35 insertions(+), 28 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/=
page_range.rs
index e82a5523804f..f7ad88a0d806 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -439,22 +439,9 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<()>=
 {
         // workqueue.
         let mm =3D MmWithUser::into_mmput_async(self.mm.mmget_not_zero().o=
k_or(ESRCH)?);
         {
-            let vma_read;
-            let mmap_read;
-            let vma =3D if let Some(ret) =3D mm.lock_vma_under_rcu(vma_add=
r) {
-                vma_read =3D ret;
-                check_vma(&vma_read, self)
-            } else {
-                mmap_read =3D mm.mmap_read_lock();
-                mmap_read
-                    .vma_lookup(vma_addr)
-                    .and_then(|vma| check_vma(vma, self))
-            };
-
-            match vma {
-                Some(vma) =3D> vma.vm_insert_page(user_page_addr, &new_pag=
e)?,
-                None =3D> return Err(ESRCH),
-            }
+            let vma_read_guard =3D mm.vma_start_read_unlocked(vma_addr).ok=
_or(ESRCH)?;
+            let vma =3D check_vma(&vma_read_guard, self).ok_or(ESRCH)?;
+            vma.vm_insert_page(user_page_addr, &new_page)?;
         }
=20
         let inner =3D self.lock.lock();
diff --git a/drivers/android/binder_alloc.c b/drivers/android/binder_alloc.=
c
index c13a588c37de..efa23f6b8360 100644
--- a/drivers/android/binder_alloc.c
+++ b/drivers/android/binder_alloc.c
@@ -259,21 +259,14 @@ static int binder_page_insert(struct binder_alloc *al=
loc,
 	struct vm_area_struct *vma;
 	int ret =3D -ESRCH;
=20
-	/* attempt per-vma lock first */
-	vma =3D lock_vma_under_rcu(mm, addr);
-	if (vma) {
-		if (binder_alloc_is_mapped(alloc))
-			ret =3D vm_insert_page(vma, addr, page);
-		vma_end_read(vma);
+	vma =3D vma_start_read_unlocked(mm, addr);
+	if (!vma)
 		return ret;
-	}
=20
-	/* fall back to mmap_lock */
-	mmap_read_lock(mm);
-	vma =3D vma_lookup(mm, addr);
-	if (vma && binder_alloc_is_mapped(alloc))
+	if (binder_alloc_is_mapped(alloc))
 		ret =3D vm_insert_page(vma, addr, page);
-	mmap_read_unlock(mm);
+
+	vma_end_read(vma);
=20
 	return ret;
 }
diff --git a/rust/kernel/mm.rs b/rust/kernel/mm.rs
index f4fa54616085..11466fb304df 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -186,6 +186,33 @@ pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> O=
ption<VmaReadGuard<'_>> {
         })
     }
=20
+    /// Find the VMA covering 'address' and read-lock it.
+    ///
+    /// The fast path does not take mmap_lock. Waits for writers to finish=
 if the
+    /// VMA is being modified by taking mmap_lock.
+    /// Use when mmap_lock is not held, otherwise use vma_start_read_locke=
d().
+    /// Nothing prevents VMAs being unmapped/mapped before or after the VM=
A is
+    /// looked up, if a stronger guarantee is required, take an mmap_lock.
+    ///
+    /// Return: If a VMA exists which spans @address, return that VMA, rea=
d-locked.
+    /// If no VMA is mapped there or, very unlikely, a reference count ove=
rflow
+    /// occurred, return NULL.
+    #[inline]
+    pub fn vma_start_read_unlocked(&self, vma_addr: usize) -> Option<VmaRe=
adGuard<'_>> {
+        // SAFETY: We may invoke `vma_start_read_unlocked` because we know=
 this `mm` has non-zero
+        // `mm_users`.
+        let vma =3D unsafe { bindings::vma_start_read_unlocked(self.as_raw=
(), vma_addr) };
+        if vma.is_null() {
+            return None;
+        }
+        Some(VmaReadGuard {
+            // SAFETY: If `vma_start_read_unlocked` returns a non-null ptr=
, then it points at a
+            // valid vma. The vma is stable for as long as the vma read lo=
ck is held.
+            vma: unsafe { VmaRef::from_raw(vma) },
+            _nts: NotThreadSafe,
+        })
+    }
+
     /// Lock the mmap read lock.
     #[inline]
     pub fn mmap_read_lock(&self) -> MmapReadGuard<'_> {
--=20
2.55.0.691.gc56d675ccc-goog


