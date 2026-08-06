Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D32C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 20:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE3C56B00A5; Thu,  6 Aug 2026 16:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94EE6B00A6; Thu,  6 Aug 2026 16:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 983806B00A7; Thu,  6 Aug 2026 16:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8396B00A5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:06:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EE88C1201FB
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:02 +0000 (UTC)
X-FDA: 85071925764.04.58E8A4E
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf03.hostedemail.com (Postfix) with ESMTP id 39CFC20010
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 20:06:01 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VK1nJY/S";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3J-l0agYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3J-l0agYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786046761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qo+gPZDCnzT8MahhMkr4ixbPoS7BupzxB9Ai/ylfWm8=;
	b=e9X3ls+heI0LJMSfAghjEdjn78WX6Mag7Qwwx1a6xmQS2AaB6ILfr8F6IOj5iDwkZjionh
	Ye+guj36IxJd1r0HSKPNjmOhf2Lod3i5G0DRZ0mKD017mf7uZZO+FK4PAI47L5VYEDoBQZ
	Vw1pTg9TfHiTkPTZ6xpIViMiy+bF9nc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="VK1nJY/S";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3J-l0agYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3J-l0agYKCCgWYVIRFKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--surenb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786046761;
	b=2anL9Ujkevb0epMSaJ5Dz5uFCDTB5KQisKS4DT03rFRSD2B5yW6UU+7w6nr3eGI+AKD+30
	dr90+PMa0yqjO5I8wVczvszolpQPE9pP5T6wtrLYKscwPpq8bVfDyeHwtMr7xMMEKJzrFb
	LaMTpIM1E0SpWPK5Pz5MJydbUkipdHg=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cb5bdd8450dso1673165a12.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 13:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786046760; x=1786651560; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qo+gPZDCnzT8MahhMkr4ixbPoS7BupzxB9Ai/ylfWm8=;
        b=VK1nJY/SjuTUrGF9efdigoDcC6qSM7C7nSuINfYG3qEv5omFAK54y4RyDez/W7SoNa
         JfvtIm/eansaGAY4PXXF7lF9HEMawOgPL1d57anRBT0Z75xLNKVReh0xW302bLgUR5aw
         ypb48Ncfk5M49mCFEuSdlFQh3yvny7PGwvWM8hqR7ckiY4LSSBhLs3TFV/BUIYSKnVhc
         UwdzUsuMO47hdflxnEzE83Ewtr4roAdg08OpD+WGhWE2xE7dZnKZdgDRcKZgGZCl8oEU
         p4Wjz9row829+9EpJu5Ci+VPRhORV+3jnNX8vb4TUatg2hleHwP8XaNS1QhHjF7DDkI/
         MvXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786046760; x=1786651560;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qo+gPZDCnzT8MahhMkr4ixbPoS7BupzxB9Ai/ylfWm8=;
        b=loU7uQhOypA3MEMqNZe/PYIWF1YBy56YRTclILdlRvpPIfHy2foZ/ZPR2RlVc5Eu2V
         9yplzZWYDCe/Pn3vGU32R/eL2mIkGHz78MQFAr67APr93t0SjuH9YO10Xh1TtBdy42BJ
         56+LEjJFSmOPc88v63y9AUvQkVGvR+WHJ4YjBgtk/c8KJv59e1jpLwQ1Rhw8kLQRFfQ6
         AUXbnGmNcGDHzx6rpB12MbQ8cMoygD87ZpZZP1fCpArZ4LB5NLIi+9GPo5BsqdS2VUx+
         ljRbumD9lIVc8yAzNiDm25UuoBQyNAeAtfU2euxvUUGvCTrn+xtgkPjVYOpfDPs4/kZU
         LDFQ==
X-Forwarded-Encrypted: i=1; AHgh+RoFF1eYOD/OJNW+CmwkSO+HF28kzZtspNf/wQxOmOvCvNqYLiIzj6KkGJ42IJZReetFvHUCpavHwg==@kvack.org
X-Gm-Message-State: AOJu0YzThA7bIu88odIDH4z0hsKigop1FgYRfra/n8ltp/NyZLUSkHP1
	DSPhgloCz/G7+Pkx1P5LCa9I8jb57BvwGYwbbGk0zEEpLTnk4T6c4Tds08zBZ85PDvDYvDZe4uX
	QJ9F37w==
X-Received: from dybqh4.prod.google.com ([2002:a05:7301:6244:b0:30c:83f3:7370])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:6daa:b0:3c4:3672:ba6
 with SMTP id adf61e73a8af0-3cbadc15329mr4732449637.22.1786046759808; Thu, 06
 Aug 2026 13:05:59 -0700 (PDT)
Date: Thu,  6 Aug 2026 13:05:47 -0700
In-Reply-To: <20260806200548.3124802-1-surenb@google.com>
Mime-Version: 1.0
References: <20260806200548.3124802-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260806200548.3124802-5-surenb@google.com>
Subject: [PATCH v4 4/5] binder: Remove mmap_lock fallback
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: dave.hansen@linux.intel.com, Liam.Howlett@oracle.com, ljs@kernel.org, 
	david@kernel.org, willy@infradead.org, shakeel.butt@linux.dev, 
	vbabka@kernel.org, jannh@google.com, aliceryhl@google.com, arve@android.com, 
	cmllamas@google.com, christian@brauner.io, tkjos@android.com, 
	dsahern@kernel.org, davem@davemloft.net, gregkh@linuxfoundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	surenb@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 39CFC20010
X-Stat-Signature: nq7cc8rsswybk57c9m6at7rqj9ubz4us
X-Rspam-User: 
X-HE-Tag: 1786046761-697107
X-HE-Meta: U2FsdGVkX18Ta7w1J2ovJtJJwaSo9tuLHY3kHBeaHCFau1I+m8rFBjuYDAUxCD8tXJf2NfVd6VQPiyXxymQadU0Y1klYLu9hmziwVHKQdWDyTzmaokBVE1nkE0uiHzEWdyEFY5jWusKcJtk0qcZkhQ0MDMSos6ZlZ5xQvOihp45sLHOIdGs6CWAajeFX8ohZwVoJm2qQqmXEryIOLRc9X6JUNgHCpdkUZtDuiMd2k+HGcAP6maDXhdkSYPziwV/JnL3TNH7RbLqxnq/ifpq66FU0QIlLawt9koz1Yz5/DFNHzpszre+oLyfgd3IG7PXt7IQws6rURMShXJq/P/EDlwVqYMKnADQAZFT0JDSUKEi+VrkMbtqhK/Su4jcFSN7kyuPZHA2BAk7EVZcEHXJXIhnYgea46IrMBS4wHapjH41zq11PRW3v0yv+ByT5t3dsSaJc+YctgcgphWibn/WiqhoTahDjWZJfDgggE/Ecp+IEMWTgAzAIQedYaLrvoiPApk7XXMKqpqJM+uW2Off5VKQox4rtPGDs7tSZlrKIQyv2jb3EMb2Ue1SJPtOQARWGUyqlr002XZhMkX+++MKO4JsaP7b/RbwYzyTpE6U/E3PVlaB8gUpxN5yUp9NhsD0zrVWdNDSsj1bgQXnUxS4RnlEXNoTkj7cRMRdi79wHH1T9gQ8+wQzsvWluEPlzPEK73Gwbu2D0tuz7zQ0lJ97PdcHmB7Det3l9YklO4hn4otzk1HhCiJyGhDi9Cf0vB5WQfygVk/Hb1gpBIbWmnqUhkmTWSe1h+4h+bTo6N1tH1r6MbM3GRdS7d58Eyn9i6W/a68TBt6xZMDXIDWk0PKRFYdBFrCp2xUdv4Huxe595Z1BbWkp5YL2GSDl2P/yH8w28iI3GMHGBEiDfIOxZqhhKkcuFHs+k8dKVTAVzyNuRJbHbzSPWx/uRngWPpwJvV22NrmAQYVqbzRnA8A+zrWo
 XUVTy8UA
 sLHj8sLLEo/L6dNfpm2qW53YQSBnp9jjphnbSZkfYLD/WFROxejs3a0ujI5p4bBh8ZzjPNdUsiEaa7rgM0N6QyNbFsw/6iTMOV+RZwvqtE/oxgZLmTkP4I7YeK1WyesW4rr4bkykdw6Ojj2k9ghkYmPRyeoAAySSEpAe6ZmaJ3jJ81OYlxU9z9gUEEyoocA5IyuRBnJdjT+FGWNQVbRdZG0dQO76/TmK2ps8Y7qnrFr2Ge7c1FRBXo3Q07NjeuUg6KQSp8XK7RRpbglOcaWhImzzRcNc/mku5Xn+oTCReQhp2nYkKt7MO3+97pzFco/7spmj70sUZpjKfZS1d87iArLpfUrVVNdxkxyFPQrNHO4ZMSMNFwOMvrbZzctpK28htFkZ60ONGu5lbEuHNBi1G5aUOc7VUAGdcXF7YIjpqbFTCBeCzT0gpufwfibe1jeswYLbm61kYcHZm5hysufaD6gZ1LFaxHfxlHVMUZ/x3YRYpT0+UshzCCwn0i9axJRKNWg9RzBU/5dZe6pxWpK3ME/ft4ZEFQ5DGCSkziXer7bWcALzKkymRDjuPump+12rgOCjj8dDfbteIQ69fSIwPLaaOYo5D5jDMgxVFhj/Kd6JTfZTe2fLmvVBQXFr25cpsns60AmSCp6dMSyzT2UdfI6sO5wYOjvMIrtiwIAARNQz4sdgVG/xdgVS6dYdzNbe1xJaLzx0VKQHS8PSCsm75X0Wquf7n3MRWwdJzUg9hVgM2WNRNbKfJHlP9HKmncD4z8a6bz97jdw3K579f64fFm3w5PPQXrSRNAsKy6ndaMSZDFgVEvkX9HJN9YPei0IuS3vUDxFGGZyhBm2fUqd1W6iZV+1k/fYRdVZz5/MWTsYZjY4RE1Qi2RqV30YXEKMQd+ysH1Dt3/DnkjtYTa6Unu3SVt0H0E8/YbqSunEtHqhKdJe9+QNoVh8r0xvuCjG+uLyrnE9z5KZmzuXEvN4j+4WJiEo2X
 RLWQP99R
 LlB5CXmWAKM=
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
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
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
2.55.0.654.g21b8a5bc05-goog


