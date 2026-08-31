Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37B1FC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 20:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6126B0099; Mon, 31 Aug 2026 16:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19616B009B; Mon, 31 Aug 2026 16:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0A86B009D; Mon, 31 Aug 2026 16:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78EA16B0099
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 16:31:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C648D140236
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:14 +0000 (UTC)
X-FDA: 85162709268.08.BA3E1EA
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E79C18000A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 20:31:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RPYQScth;
	spf=pass (imf06.hostedemail.com: domain of 3j-SVagYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3j-SVagYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788208273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMb1BIWAt7k71K1WS7NJDkr5bMmZbsfs3e75iDz3R4U=;
	b=ub1vRdRzXhORcJqJrPalQ82Dj98UfDuNb4Czmtz7ZSWl9GQfW42/KTtmqIFzfMgFIlD+NK
	PvUU8duxz8VA+psrFf9enyKxG4ii6y9LcLEpCaodTnXy9UtQv1/yCgnIEFRG5JCDhwRup+
	kVCbQPVIIRKw/2Ty7ZHe3yA0SWPs5tM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788208273;
	b=pFZ3vjSPS+bfYqGzjcgCf6Q7EQGEvESK5K1oSNU80+/pauwK+IV7mvxGTV5uhjBQ9xg0Fr
	zmrttIUNAF//DOXVN8EoO7LeFoZifz3WhFuZFny8b6Vfu6wkbAVaCG0G4nFTadbqJNSp9d
	LHw61dWzFUNYhpmMksb2uy3PggXWrz0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RPYQScth;
	spf=pass (imf06.hostedemail.com: domain of 3j-SVagYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3j-SVagYKCAw463qzns00sxq.o0yxuz69-yyw7mow.03s@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39906175917so232688a91.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 13:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788208272; x=1788813072; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=fMb1BIWAt7k71K1WS7NJDkr5bMmZbsfs3e75iDz3R4U=;
        b=RPYQScthqrM7jlO7qSRkrRy3Rejmsr4f3wiEq9JU7H3WiLFhjx0Ny9064ae53cbvpo
         ofv0fwYJmQMt7rHK93Ri1m+jG5Yx5Jl+VIaPyVMKHViZ7Dl3hJ4SUuYOER+v+ddScyIj
         RGi2gn9Sex0tEO3hxgmcKCPyzp4N2pn1GdIsfN6ZF00ahV82gg+Q1pyx7m3oS/TQXYBX
         DDgbLPRlrjOaBR7XX1Pavd+GlTvBP6TfqsPVUASMTU9zCLc0wOQ9oqgiGjKgNufB4xuE
         ljFpLTcHKdk8ZlNdDsEecDYIB+pncTl9nG/8iyY8qU+TqnO8EPgSUnQukO0ywwNEf6pc
         92hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788208272; x=1788813072;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fMb1BIWAt7k71K1WS7NJDkr5bMmZbsfs3e75iDz3R4U=;
        b=VVYKBoloZX/EVujSbV2kLxEwqJWm+zMChx/sVH2mVVy0y9oivTqpCRiy3zW8v9uBcF
         /ekQJISNEc2ZDuxOpeRcrf805gmj4jot1IbJ/nOCEcqG7JVE72C3yx+oT5lv+cywR6Ae
         0xlN2/mv+XiD2H15Eppo+XSQTaAA/XdruBmKE9Lz/Rcav9BlV3qcvCNt/AWF46Mc78LL
         bkVyci+VuKTBsCL8N90JtvMe0r1xF8oh4hGy8Qrta+m2U3n8j76srsQHOBZ1z8l27fLl
         YejgkoBgb5LfWoSJ5TlZWObl8lrKFEJMdc7eSW0X5/6j0XZWOn2BLxNUsBCO5J1YkPLD
         FzSQ==
X-Forwarded-Encrypted: i=1; AKwUvBzQnhssDbXskvI0MhpkCrqfoDdN+f8BnrtxiqK82e9U+o51Wll0fcoXG2G7jLMv4rQmfOi91+s/+A==@kvack.org
X-Gm-Message-State: AFuF++mQIr6eCg1eU6D3qN1953qvXiS52DzehglfG1kufDhf0Cumtmfq
	59AEtkvqk9hwIyjlnfRxX4EyhVd79sOMN5rSSIs3+J7TLQuJDK3posmJpVmHBQkSFSr3QsDmBrO
	8CxFtzQ==
X-Received: from dlak6.prod.google.com ([2002:a05:701b:2906:b0:141:5987:7f07])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3c8a:b0:38e:524:8797
 with SMTP id 98e67ed59e1d1-396d10076e9mr43087877a91.13.1788208271612; Mon, 31
 Aug 2026 13:31:11 -0700 (PDT)
Date: Mon, 31 Aug 2026 13:30:55 -0700
In-Reply-To: <20260831203056.838265-1-surenb@google.com>
Mime-Version: 1.0
References: <20260831203056.838265-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.966.g6673acef38-goog
Message-ID: <20260831203056.838265-5-surenb@google.com>
Subject: [PATCH v7 4/5] binder: Remove mmap_lock fallback
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
X-Stat-Signature: amqe3r143ng9deiz5cdi4r7sc56w9twq
X-Rspamd-Queue-Id: 0E79C18000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788208272-344382
X-HE-Meta: U2FsdGVkX1+MVrY9nrepen+me/CxaL9xlGqa9WgMlLFAM6FiSQsNwtxx/OnoM8XoQ9+YeRVEOkCZXKuRLKvnXGF7g3PapxBIHiCgkYkz0zyR9ilcDyLLPGrwtZ2M2MaSPYhxG+ehicI8F9LSIUNsg+RF4Q/2Z36Cet8bbMUeO2tKAsbs+7Xlor7QgV9U5682oxBgyWxVT2BopSMa/on4xnqXLCyj+O0tPwdpzTIURmGeRBhloVG7Xk1l+ipTeQY7b3OcuHR4jNSXJY6XxNAqJvC/cqk3tMgS1NNWa0o53ME68WY+a8pGyLJUNyO6RQXkf362aQ8DrdHRJDkhk2EvgWjTztDSuCedCnH6wlJUpaNsSx2PCALhBiOYoywntY14X0nZdXNQTLCBEF7Sa86Wmg0pgzg2XAN9fwwHvVHXdrRx5+QP/WVPiagaII+QU+8UnNAT5q9IeUXzVlImWZO2wTF903iW4FIOVn84FFu8RM9E+VSHQ+1pfBBxLCpuRD+gFOvQKFT8/Nlj9s9RDsYsiq4SsryCc50e38SFKRyuE6l2+mVqX54vQGL6yWQl1Nq2VoYCObJOGiH2LJZxKY/dhMc5b0aO82spJznJHOPMAlLR7mOgwGwwdc7wFa68g1zGbuujsaasi4q95RJj8O7bIast9+DK03YXUTu0ldubAWx0R4JraA2krTAp/iYuB4UTYvfKIVRdCTduLEqukVmnhriNSGS9aIqAxfyBApvfHfJdwmY4gnt92Es9ePT2foIT/ZiXYv03etNwz2u+6FTimCVnV7XaTInhem7nFhCq5GNMIy+gCr6iBt//GeowAy058V8+SeRGVrHJKgiWFaxTyOw8jCsgs4Als2ECvbOAJ9dOtpLTy+zRiZvQv2pJs840POTaWYE2jhjLI5+RPvpIpkwCW++6WMH1ffqYxjQuwpw+N2j7mkxcIfzVNA5qyi776sYOcSkOCXDzmSuT5W1
 3a99KpaP
 spZBHJpKcI59IZxejvgWvhOaMfxSQDPFwEKH2Tq1PQLnM5/jJSdxWdi12NeTuKODx/E0goTPnnx7XpVsWB/uc7Bf4EhmrlJpvjei4Hqjn1rfksjfm/FDs4cdMRSqpe0hOTkz1bedEgdnYMCUVOf93ukE1JxFh8vH952Een5W+VxUPCX7QaO6N7XLHgPibirUbifkRO0Qg0gvlMrE/f2l6qzGSMxmzatCKQQsIYrF9wQetMnNGmkhfBth+iDF49JDJ3L8h+396kRGtD0LMA2zST4GFR4MzfkkdM+MffbJrjHfTrp+IrwfsmncjEsIxDBh0YcrPEA1L7thjGLS87xvhQfrYqs7rTEcYRExhRfWrM4tlKn9XGxXw2jX4SC5wWkB1Y7RxcYu7yh1PP8pHHkAwQmM0P0DMLO+0HnB5B2zojfn48RcCEk7F0TYsNpBwfCcdh15zA07nKucJN6HTyh4CPlvDgBYZFD7dZBBTvHGq70oTz6oaMrLdJ97o3sRNZrMZSHxqqtmKGZePyedAhK3p1MzUETkF8yd3AGCytt4lIoidPtEcPpBXGg4Xu7uBLo1eC6T7M7Lt6T/8GyJG+9qROK7MsYq3pyF3Gn1wEnLxLEaCbTM2s2KADsJ7LHDCrWxa8wlAwE7a+JVN+y2uauz7gdAiBlu2b90C0LxyCMTvlVAm9zxw/aEemF/tvME0u+NbWrilonisYOeQ6qNOm/Pu3XqrcGRxOmOGR/nSIixyNYDxAViGHSWIPtNTQxrSIDIUatRVoHjO7/sdoWPqKznFyXH53amJ6iwxiSsXmsgrDROFFpelcWiRvOj88zNOYYlkaOQsyD1eUXcxrfq67zBVaisT4k7rvKPhUuXpSwNaNsNZGrxXtkbm8lM+SyrbtsUySVAXjTh3NeFFi6O5mQ2+Tu21JBk65dhyB1xYyPUu4tI2rNuz1G340Gn3mvb22KkJ0sMyoMiDjNKRqgPbrjNwFYmlA4ZA
 A0Tzehzm
 DgARXHJ2ADU=
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
 rust/kernel/mm.rs                    | 28 ++++++++++++++++++++++++++++
 3 files changed, 36 insertions(+), 28 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/=
page_range.rs
index 52ffbf3504e7..71febd3d5b07 100644
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
index fcb744088e77..d6eae0aa7085 100644
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
index f4fa54616085..58bc1793fdaf 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -186,6 +186,34 @@ pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> O=
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
+        // INVARIANT: We just acquired the VMA read lock.
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
2.55.0.966.g6673acef38-goog


