Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 582F1C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 19:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CC3E6B05AD; Thu, 13 Aug 2026 15:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A43C6B05AF; Thu, 13 Aug 2026 15:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E86F76B05B0; Thu, 13 Aug 2026 15:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1D4326B05AD
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 15:34:52 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1CE1FA0187
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:52 +0000 (UTC)
X-FDA: 85097248824.28.6577E6E
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf09.hostedemail.com (Postfix) with ESMTP id 58AE7140010
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 19:34:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oG9KqpL6;
	spf=pass (imf09.hostedemail.com: domain of 3WRx-agYKCOQYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3WRx-agYKCOQYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786649690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qCaRRVvjGSC4kAtkk2EEVd2d10nX9bq42OPxaiCJ5Jg=;
	b=kkZ5kr6jVoLrLRoV8UhxNgOYswWnoC8fjXsj78l7wKgeekf0bqEjGn+2qsZEet1gIY/CWH
	tfuighKGo5sMSn6KtatMRR31jeIRrZvkrsVUr053kAmui5H9/kaxAAxfvWDFY444XJ/vwc
	lRRRrWxl7X+lmsrQ/OOLgO9Stgw0NVY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786649690;
	b=XTOHBiojuFnv/uOIJmWkf2US/dDJvTy7Gkjdo89cK32nK3F+PCUpLMGxk7OnaIwB2wZgo9
	rLD65oAD2d/m1ettFNvSQZfHl2zZJajLUPkcnC+ovW4RrnAEylK0xZopSsVwqcs2E5SWFZ
	1EZU9XdgbKnkYt8ZEg53RGfWl7D/1r4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oG9KqpL6;
	spf=pass (imf09.hostedemail.com: domain of 3WRx-agYKCOQYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=3WRx-agYKCOQYaXKTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e25e4b41cso222917a91.0
        for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786649689; x=1787254489; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qCaRRVvjGSC4kAtkk2EEVd2d10nX9bq42OPxaiCJ5Jg=;
        b=oG9KqpL6BJW7Y2r2qW+O0Tkah6MpYihSSs3SP4aQM+AFQNzCpltL/3VpJHnjL6r6HK
         1crKxpqK1K/mcYVU9m5Reky0CJ+DmHKhHGxb61MNDdsiiXLYzIPzyHZJNjQagjVAmf5f
         NF+RCMCEdxio8r4wp+QmqkmhIiCuAofALbPSxM/igcDU7U+jDemWA9Vg1x7WD3mObf8V
         dAutIiA8B0W+YmGiTIBewDaUMUXUDTV3T/9JNLS9uo0VAQJs3a0lM4hoptiJRsOSL6k5
         /QraEFSr5y3F+HxvCKcqJDKYpTtn8ReO9VRCECJn9sfP6yn5p/FTMXf+vHObDR9VO6+7
         nQPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786649689; x=1787254489;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qCaRRVvjGSC4kAtkk2EEVd2d10nX9bq42OPxaiCJ5Jg=;
        b=XmlZkhhK7d3AXVl1fj40PTYnKYUkGqHk3Raod3kAJqG8I1J6kyfI6zdg49fFdRkn4g
         DJVZL6ANMnFyoJgsd9Io/iwcwXut4NiQ86lMN60DowU/ES/cAPbwVK/8E51ya8hnpFDA
         x/2aOOnozn6mqEKdSbehrxd4nZeLqQAsJs7tjmSP1ogIT4+9btCq40rLXxtyBpFDiTzs
         SxXW8alxkVWHREJu8FK/iRZW5Esqf1QCtJEurN5ijybM2mknsFXyUXSxSUGCmTeslbDc
         UemalqTVSMaQY2FBgLrI3LblbyaYq1N6WetZxHyasgIdd9YYOPQBn0vac275riPUdvEy
         hW1Q==
X-Forwarded-Encrypted: i=1; AHgh+Rp/v9jUiZcG7aynPOlgAbQjwqdUIBOrFZMhtqmwBDF23UZ8tC16CPx4i6iF7/J9Edxjah8PjlPsTQ==@kvack.org
X-Gm-Message-State: AOJu0Yyot+i4wLGKBIE3dhiL4xAqwdHk4cRPZzvOqtPkUtLGP783gdHB
	rZaT9m4gPT3oQB00jN+f3vW5YgJLu59tCB72opihJr/LRaTQgbv/+Y+gaSlUgqRV+3CHScJqYSv
	OupksqQ==
X-Received: from dlbqk7.prod.google.com ([2002:a05:7022:ec87:b0:13d:314a:1ffa])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4ac8:b0:38e:11ba:992c
 with SMTP id 98e67ed59e1d1-3933e5d22acmr228908a91.12.1786649689046; Thu, 13
 Aug 2026 12:34:49 -0700 (PDT)
Date: Thu, 13 Aug 2026 12:34:32 -0700
In-Reply-To: <20260813193433.3318288-1-surenb@google.com>
Mime-Version: 1.0
References: <20260813193433.3318288-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.691.gc56d675ccc-goog
Message-ID: <20260813193433.3318288-5-surenb@google.com>
Subject: [PATCH v6 4/5] binder: Remove mmap_lock fallback
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
X-Rspam-User: 
X-Stat-Signature: fktrsds3rtjbsgfxgarux9154ksuit7k
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 58AE7140010
X-HE-Tag: 1786649690-881079
X-HE-Meta: U2FsdGVkX192IE1A6ptO3E+kwyU+8cY+43pZeiWOyQIsSS97wc4qWZy7a/pC+a0OzPXQ6Eap+n90y3BIEdQN/KZ2Iyq3oJoFMnnt3xPOx2dxXe7AKNuNikwi72jASBDgU3PLZTv+jJrsGh/DuX+9AbGCZzRQsLbqLMlISiVmBNrsKEsreKRXFMPWqyhpfZZPTxNET4dvTho3Q3VXpFoO679Xvk91lUUlsUIm6g6g2aUrlSdNqxzWJ45sl21IYU8y4ArN6ZLz7fM7dXG2z7/abCZXcMx48fwBp7OWgO2LEfOo3vkjhA0wZHagXlMrRtIy3Nd4jK2Cj8WvJbcfAj0FkEB59N/M/acxscNEny+JvBvOgJX2vSv4vyGJAT5elDDbar8Z9KiIqveqPz5h3wx5MWX+xwbT2KMPDRtatrY6kEvaXZlryoThmaHFyOOkJ3khNe03R2E9eYLvyKoEtXF+pPUs1XB7CTAvgFeEWicwu+gNRyUZBWq1exoZJt8CfPfj+GdGDOPHpxza+KvWRGIxAAh3X3U3+W6F1B4+6EdpWZ4GnuykYMvwcdv3BphUZlpF4/wrPUBWzRP3svV4m/EFJVZOU5GuUdeH/HAOZZ1fk45/tbMO+fOY72Fe+xneaY6a5PnSov1oldFaUUsSy2p4zPNkZ115K5hjbCHUCmPYqGNKQiYFhaP1urFWdkWKL+PrW++hQIpUDbNMAEARTOKHApDltaJAQtBZYiNpn89765D0/LrFX+xOGeAnMj6sQa3mETr75TRbv3F0mMF/5Ma9F9aL32r/oq1PBVmvp+3ayh3RQS7jeLglDJBMaktQt8pizjdKFW5XWxzUE7UX6Hm6YkJKOpvSt2dKlFIybRYcSKZOPyqp7dnrGMT5qdbhp9FFM+03vWxfzhTEDwAH+K+1mGRFV0L2UAJa4naLepRjltYrC0u1ijyc79wtQWw0g5G92doNIOMYRb9teOgl8Uq
 rasMBb2+
 ikwrHbWiCgQ9dVjd0qqw2VjvKIHyzyCCE6b6EbBWOIjG7XasuArXQj69mkWxubV3pKeCRul5b4LvugaGgsYQX/HCnNvlSbYcAVkLVi81Pq/zWRndldYN/sBg4NcsUWE0npf8wouO1EuvQT3VE2F/Sa4fA4kk+8apN3Wm3CONylhnRX5NN4Y54ylXC5Rm8Z+W38n4Jtst1dA9QW7lDLvLyH/zVpYi7wTVl+Boj1VTbPpJ0AdPS17twA8twdcXpjRJ+lM2p9HdkOgPgaWksVq5RJcmKTcyWkSN9so6GnxJthZ5VGWNbBuTJ6tN23hxt9IcqWep6Q5CIeH05SNOhQQKTSRAZGQ4zi9tDPRDe6HX3B6fSXSE2+vneIlQHz5qHqpU90j5F9du/PQMCEnxCdiGmP3KArTwkfPnb/W5Bf5njVhUHNe9R6xbFP42W79UI+1qmRwIWAjFMcnqHyO4gk7C3tOV6WeUuLUhTgC/h1dF5nQfC0pmQBaTdUGkSlxIX39uHXeOjpoE59KcN2S491NcMin1qjlJ7Etbp+K75PAn1ASxxhGEm7tNyLJPD1MWa6qBmEOBaoxRCnrQLoxzcdqkDKWwCK/RspuYIWAemvyXffLZo6CV8873i2FzyGF3SiUeTsGU6FccIJd3JHUmLDfY/zPvpnrHXjzGxnOAGVSFK9jC0uqGTnNl800tw+sfJwTsItgU7Bd6tikRiUFFaumyjvmCClMPlRshxN+iV9yxC+HRgUKUO+reGJj/3ChE9lsSvKnaAkCQzM9bcsUsmuZxyBJwmZnd/tIhR8NMMbkB2yeWtDUnmOZW7pwOcQ5jcfJSd+2H7wYkuDg7U1DbyOfNFZA6rWUfaHDWFN7TaGznadzy9tz2hkPY7xPDdG/oqE/03gAyWt1hZvY/erACpmvf+Q3edkLsTRdFla2L27PtAbrFFjmUH9CrBoKnjiN2lLzcz4kXxYUeKnvac73oF+DTXbl76y9Gz
 mZq+bEGK
 vaKpr/nRDok=
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


