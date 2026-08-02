Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EDE1C55162
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 21:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52F086B0098; Sun,  2 Aug 2026 17:55:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5068C6B0099; Sun,  2 Aug 2026 17:55:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F6366B009B; Sun,  2 Aug 2026 17:55:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C6FD6B0098
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 17:55:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8064D1C0F5B
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:15 +0000 (UTC)
X-FDA: 85057685790.19.AB6A2C3
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com [209.85.215.200])
	by imf06.hostedemail.com (Postfix) with ESMTP id B5DB9180007
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 21:55:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S9k3BHDn;
	spf=pass (imf06.hostedemail.com: domain of 3wLxvagYKCFMDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3wLxvagYKCFMDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785707713;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xyBuTBv3WW28OhNQPFgbAciWJmDFVPYFH/JX2U0eD1I=;
	b=5hM9gy6a3xMXtw3TpoN7/YM2mIoGW32wd3m4e6WuWvBIhokKDJMx4X2iM1S8pzjOjSQXm2
	k9JE0J3G/RfWBao9GQ9nG5VRUF1UOKSX+hpK4LTysCcjIvYO9QDZHJJUq17ZM8FUB7KxGv
	i03JOVU5kxsI5PqPOM7Fgyrmza7jCMA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785707713;
	b=uHVuynwrSB6/iS81nLBvbctHDCI2zxgYMD5AW2VifOz9ew97k5PfvMwL5KqB3nfhZNNy+N
	R0ggxirvE2hcgDQQ57sb1QTEcVuidEwiIHV0YNn/Ul+oNjtVmO6GUDG0PRQf4TztDZ/QYI
	WCZrVDMn1jLhVJ60cPsrvAEmO/pJqBQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S9k3BHDn;
	spf=pass (imf06.hostedemail.com: domain of 3wLxvagYKCFMDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com designates 209.85.215.200 as permitted sender) smtp.mailfrom=3wLxvagYKCFMDFCz8w19916z.x97638FI-775Gvx5.9C1@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-ca860baea9fso7088985a12.2
        for <linux-mm@kvack.org>; Sun, 02 Aug 2026 14:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785707713; x=1786312513; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=xyBuTBv3WW28OhNQPFgbAciWJmDFVPYFH/JX2U0eD1I=;
        b=S9k3BHDnPVSWJuVmJbZEy3A9UM3AEMcQUVkaE/f3Dy4/nD61DWQUCZObt2h4cg1DO2
         9eQGykGpdQfdNq6hlyH/sbD+fvU5ovaozfNrSFh3JnrBpu0FkwSwQZ9F8nEnKEj3I9z9
         NP1eTe2N5bMiipQubC0x88HojvoVn1WqpdQcGLdFZxT47K1nNu+2wyZ0hoyEH3enU8np
         f15pV5n+6LRPYTXFecwUCeuyc0zy94GPGZ/+CBp4n0UB6+AqTJbsSttksVsfJXpfkAX4
         RP5zmlu23uFB+IXlh0uktrz+Mtz1Gnj2aJACWR3hM1tpBVXqwUkxcMnG6LK1EUnqgb5E
         JpVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785707713; x=1786312513;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xyBuTBv3WW28OhNQPFgbAciWJmDFVPYFH/JX2U0eD1I=;
        b=TOwe9L9FEnJdtCbZDLb1v4Pz2HJB9yYSoFSDY2vpkicCGRmjM96mjJEhFoU4gkEUN9
         i7YaSGjoHH1zCj5N5u9lxMsErJkdU/aCbI1YOgi6MTFmvBYHjzgsz+B9FcyzK22TAFwu
         0kgr5DHKbTmQkoszwWsydKVu2Uhq1tt9aDEuHsPMJdys3V1YEPNIV5ZUc5FC8m0kwCUf
         vlo0o2xUM7vOCej3e4SDaLaOL7iO+MpHv2Wm2K5K6Vtl6X0xuuqiICn5de2r8N3C8lED
         rLYkR7kRZPxVAk+QpWJU9jGL82V04M5oc9bkCcrV81Uobr62qsYY8veApxdV6ejGE28L
         4Aiw==
X-Forwarded-Encrypted: i=1; AHgh+Rr8OIE6THqz183sfU/EtHhDXa5HgKjvU4l9HKyzvRF7mlZ3a/j2qsMa0HxugVbnCTIPC8ofCBviIA==@kvack.org
X-Gm-Message-State: AOJu0YyqL/Q6ZMbGolh2YDIZKDMAkZGNp6cDEsnz9lsZ/WeZ5Ml60RlV
	PkojXFfvzFwZ+u/8HMiH8biKRZSVurZsCviR/DBVnMVpSkpyZKD4svyZSIrn+DbdMcec0Js1E1p
	yhAUMHg==
X-Received: from dled7-n2.prod.google.com ([2002:a05:701b:42c7:20b0:13b:962e:3bc8])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a21:505:b0:3c3:9a32:70b6
 with SMTP id adf61e73a8af0-3c92a85f682mr8949124637.44.1785707712418; Sun, 02
 Aug 2026 14:55:12 -0700 (PDT)
Date: Sun,  2 Aug 2026 14:54:58 -0700
In-Reply-To: <20260802215459.2769283-1-surenb@google.com>
Mime-Version: 1.0
References: <20260802215459.2769283-1-surenb@google.com>
X-Mailer: git-send-email 2.55.0.508.g3f0d502094-goog
Message-ID: <20260802215459.2769283-5-surenb@google.com>
Subject: [PATCH v3 4/5] binder: Remove mmap_lock fallback
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B5DB9180007
X-Stat-Signature: ikag56bsr5o77egwq15powumrp5dmhjm
X-Rspam-User: 
X-HE-Tag: 1785707713-274040
X-HE-Meta: U2FsdGVkX1+e0zbmAh6s1iIfSMbaAIiizl3RxvIjprLpEr1kdZvRUlp6PnWqd/oCtGFE8i4phk09cpcn6PSZBWyM8e8FXm/21GnJ8vB0st3lBh7JadTRGVlJ1M3IpxKZLfZJ9OzyC8r6SkFFKrqD2V5PQt2VSZXR2XwNfvCSeep2WHGUIPspuw8k0rGb5FgwoA1LY5rel3WSq9v1rf7TBJE81dNpbkZYA74zv6vwkUzJZ+5zWH3JqQ50ZL774RKPkmxUvw1yERPKG8aqoo+7AgOIv2P7KrVRMmXNGS6+PVV9YY/8KTrOJC1AQ5bCDdSjCe4d2mLdwQ5oSgUM0b+o8/ZYmD0nCbK7kzdTFY4sqgYFVeJcMQ2LpWTXpEl+pto/X0NAhklM06TNFbo8nwgjJ4BB+7eczC9z1SB+0nQjL+JvW+OdKi7FVRs1vQ5XcQ1gYnve31jMABLbOD47ahmyj63lj1fhODcWJh9RjGe/Rxy+IiQll/8EElnXOJtiS73E7IKtHiO/oJtClzQHbiYIYQSVNa5SX9ii/mRmZXLwQ9hO4teLMe9Uu0dImuFWbZIkf+V2sPLbpVDUo6F+SErlZtQU5iCQ0dPr6bncKKi9BMJi+4LBKsZzvt2zq6gAGsKQb62NZG05G/Wb+hH0N1WX+vN14iV6gJOJpU+a6ATg6I/YqiIWle62N+dJH22W5opNWg4wkVG6dsMJOyaJEMB+zM7WIOg/z2kuxzTUC+OUGMzVhfkmB/UdUbkNgCcs09E0gduHEVzePPbcMIicW99knB55u1HARWWROGkalWM7c8u1OXtyP1uBoZMe6Tj5ePfeX33r4opwnYn5O6kPG1VYMP0xSFYBEEhFDX1jc9iVczx5DNUqiZO6z7Ph5CpBLjzttIYI1NkDYoCGcBOKmtouVTZmemuaoRyO8FibAbBHDWCdTRB2/zWgrR1O1sjJSOInicokdFfJwe4SXd3xwng
 DlF7cGMK
 Jx+flxzFE/SPo6E5FANQQhDv1hU3INnZvuD2mxqH1ynPSHQyxUfJYlu51TFFTE1liRqji340ir50FWeDiZItOCqXnWFtSFyLpATMBb85ugtEvElDc/irljfR5c/TWTz0prXRx65cYs44O6fcjUZ6c4Sc3pCjdtXH9Ttz9XlBxCWNyD7Ef538GKKNUv7IOIPkh5bTC8M1DN+/FmoI3Vvrnd1NBsTsRrMni9i34hX7u6sbgiS3yDruMjwkVI7D8HRnLeXeDOVULIAuwB/GyBoXmv5xS18OL/mmlKFAG1UcWiIbi+G+cqWIdAQ158Q178LVhOV+b+KEz/NPtX5uqk6A/agCAKummu1tD732LAQ9D4q2QWPn0QjGqBQF+ty+990ZDtHyxHG0PObdfm8KQOyxMmFj5oB94uarkSqGYjIkOZ0PUVjDYJlz3Q1nxflpXxsUUJl5n0qtVN3OWo04f1NLEorbEmv7rAUbo7WGc/Ia+cUpqzUKqFLmQpDj3WLIAi1/9L65fnb79gwLEynowc4rm52RHcNZArSU1Occr8loyT2eWAI2F1xjteE0w3hW4X8aGDqg5BGspRfhXWIsiQVeBHRFfmVmqTI7EB9zHkZotZAB88eeZ8QrbcvAArolOPUWFIt5lfjZ8iAdqHXJClSWfK1GQG2kFkGBgKLD1fcBkCGXy2/QFKew3gtfrTY7sReArXwVRHg3F7W3xcPCTS+kViGzCR+87taIl+s1IpZtV4iiRs7z1/O+gdhS5SXqVA3bZgBggomNTvAqJa2Cz83YiggusX+UHwXBjN9TQvqBn1Tn7lUqnW15zVcuvL9TIaE6h0OyOqU32qXzPZQPXE+e4TzLC21R1iGOdf5FmAwUoOYbo3hHhF3spbC9J8ljOFRBF85CNPWwoY1M/4R1oOPtu5zxRChsTKmb37uQenEfUg35E+81FGiu3VLgX2BB3Xw1VUp9rLkb+myYXUh9MfQISEeAhImPx
 ljq+MYU8
 xvSSrFJ34V8=
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
 rust/kernel/mm.rs                    | 18 ++++++++++++++++++
 3 files changed, 26 insertions(+), 28 deletions(-)

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
index 84104ba04e30..519dcded19b2 100644
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
index 2633e704c83d..877fad68be9c 100644
--- a/rust/kernel/mm.rs
+++ b/rust/kernel/mm.rs
@@ -190,6 +190,24 @@ pub fn lock_vma_under_rcu(&self, vma_addr: usize) -> O=
ption<VmaReadGuard<'_>> {
         }
     }
=20
+    /// Find the VMA covering 'address' and lock it for reading. Waits for=
 writers to finish if the
+    /// VMA is being modified.
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
2.55.0.508.g3f0d502094-goog


