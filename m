Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D18DAC87FCA
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 13:23:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39DCD6B0092; Sat, 26 Jul 2025 09:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375D46B0093; Sat, 26 Jul 2025 09:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28BFB6B0095; Sat, 26 Jul 2025 09:23:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 168E26B0092
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:23:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D596EBCEF1
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:44 +0000 (UTC)
X-FDA: 83706483168.29.21F5B9A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id DC48514000C
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zS3+KnMQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 33daEaAkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33daEaAkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753536223; a=rsa-sha256;
	cv=none;
	b=6TmlI4JnxtuvIY/YZEeoAADWAoXBHattV7N2xqJaQpGahXipT2M78aQRg8Ry8ejdxtahyy
	MZscnbgZCRUCYjHJCfRUELGstnQhp1A/080/JAPhVosoAMQFMS4bs+1XvFuYi3cRg4TSxN
	r81YX+blJN6Fvtdf4dd9Z5TrMsKY8Cc=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zS3+KnMQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 33daEaAkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=33daEaAkKCOgKVSMObiRVQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--aliceryhl.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753536223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kgwHbCr2ZvmYKCAvZ6Jo8foujNnaH3MRKvB5fhzEjBk=;
	b=OrKpWx21sVApRx105+AY7s2wFkTRkKLmTbOADm4BBhgRn7F7fF/RcsuVCVhLEpkKghuWb/
	d4pfLP3tXj+B9G9KHxzjIlRsxJKen3U6rqYH3w6MSQsCkZ51P6x7R7sEeJ/DIrasreR/lc
	J06XEfOq8aMMjBGlR5R6tVKj/4bUmvk=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-451d2037f1eso17933145e9.0
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753536221; x=1754141021; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kgwHbCr2ZvmYKCAvZ6Jo8foujNnaH3MRKvB5fhzEjBk=;
        b=zS3+KnMQmQJ2NZxNTqyw2lbNIkTNn6r8KjrSS7eQPcZAauApb8kFGpacb96+8krW16
         Ln7FioaEBoyP5v7oELjG1FIEZSPh1xxHbHBczKdIEkx9Kn7n8/IcJgmI2wFiGIN8/Xj5
         4uWc9FKjYGKt/VQa087K3DzsR2DzTstxx4Ib8cehOk0eUWvWRrlw1hTdt4BIE5PRNphV
         AXc9Wr8kL+mBHmCMC8JuCvIc/CoODjPKQSjfM8JdppWBO1o0qXyUaRhoQyy77SZaPiZq
         0IpgRGFKSnpx7S4r+UqstBNx432Vn24VJucg7mIjtk/9pgYl1GZWZ0ct/+OhBF2f/pke
         vnhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753536221; x=1754141021;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kgwHbCr2ZvmYKCAvZ6Jo8foujNnaH3MRKvB5fhzEjBk=;
        b=dWNvgHjZ41TNX21LiVfmFNbwfoE7XcGVrj+Q9OW6uP23+vG4O1JoaJF7LGPC4rTmpu
         6+8pEBPaWIMSbYPWlpSZ0IZaORyr7fLeTJ+lvtZXMkuQNJAvk4FLil2MDNLNdnyg+OqM
         mGZY0yvO3jfZy7IKY6Hn4P/aov0JydwQv5w0MZQqpXVRCeBwz0oOnbICfyc5EE2EC57N
         Vh+jlW401zzXo+Rbc3xS+Q+8Whvf1trEpfno8v3J9r0SsLZUrCz9K0naH9mPIy8SSKP8
         Fx/Hua20bXGf4uWKB46YwLnKiJQiqfVdIs5gt/JPuC+WvqfsU3iiMdiQgsaQ5DqoE0Bs
         bY0g==
X-Forwarded-Encrypted: i=1; AJvYcCUbEkNNCUNFluwepoJvxbaZKh4P7VAyVl3w84FXajWeWEmKirKWLTUwzfGUKDIndGLJyIB1ZnMNZw==@kvack.org
X-Gm-Message-State: AOJu0YxVMN5NEac2Z7Zcj5SOeC0yHaoYimuoq21D6dnnUWqnxtIlSY5t
	I27zT9L/THSoYa0Fu5StUPJTYAtUilLnVBX60eNltqnYN7JYG3Ng496uoAMbrXcp+XJHjgIJjTv
	mRdICU3IDSBEUgxP8Hg==
X-Google-Smtp-Source: AGHT+IHK0oinGXcTRpIRR9GkmcUt0z0luOQdU/wKAKEP5Mdo9w8BMXUuDfOXSr1dZ2NTcmmdHQ/ztKHyo4udlFU=
X-Received: from wmsd5.prod.google.com ([2002:a05:600c:3ac5:b0:456:134a:a210])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:548a:b0:450:d30e:ff96 with SMTP id 5b1f17b1804b1-4587631c069mr50085215e9.0.1753536221362;
 Sat, 26 Jul 2025 06:23:41 -0700 (PDT)
Date: Sat, 26 Jul 2025 13:23:24 +0000
In-Reply-To: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
Mime-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=6486; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=XDv7xqVzGr3tjiLDY2GZay8L0P/ScjmmwU5AHWOuiak=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBohNbXyRmF2zytMMMrm4rFmcdjquo0alEVhk3Vl
 CXdwtTdF7iJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaITW1wAKCRAEWL7uWMY5
 RhWDD/9l1MeQpBGr+HV7JMdLIjd2i9o0iNLwnnm6xX7E0mrEmHWsUQ5bRH0W+p/8tudSkN9xG0o
 PTt0cR7RIw42ZpHN3ewphysCo5tvFzedmCj+Mxz6r64n7QQvm46pl3bksPmndh+E3pMGnNABAr+
 9nY3OJkCOCjZK9X0Fu/hRgntpDkqMfs2Ux9LkDUtAf125aDF931odgruaYhLUZD9Le6lyjeFC5R
 vydFnAf0zHh+03ZkMMM/SR0WKJmwN5NytueHgJa1A1qxgkefT6K37nVGklV/UvrE0E8ESoVbeqM
 xP1vbvwjUZcWtafW3oOzZTXAeslkFn0AEV8Hc9+HWWoO9esbZrL8KG6+zTsrIuXE2z2RtNbWr0r
 hM+ViSO2TX+ZbZXFIkxErX2QrpETKvcNp6VpWVoi2Cy7oTwoMvV+Yuhustg88E9k8BnEqTLzVWT
 HzuxHgOJHIPMP6J5pGq99NS7CA90Jz/S6LNabFVKICycYiWoFeYktvnmwSND0UAUvcmCCqSVnFM
 3QUo53DympxOQ0nk48KweRmq31fKIabyZKncDdq2/nYJ8n1AHNCItDDgTt1XL0s0MgC0ohN2Ew5
 AmBdjifFMO443CQjeqSsc1Cbu8e8D4lKI1T0JC7a6xloZHxBzpsjznPz+qada3iRteJq4rWPwAT NBEBElt7effAZPQ==
X-Mailer: b4 0.14.2
Message-ID: <20250726-maple-tree-v1-3-27a3da7cb8e5@google.com>
Subject: [PATCH 3/3] rust: maple_tree: add MapleTreeAlloc
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC48514000C
X-Stat-Signature: z5gp88ynoo6rezn9pgp6cikqh9f878w3
X-Rspam-User: 
X-HE-Tag: 1753536222-70970
X-HE-Meta: U2FsdGVkX1/P4hLm+Bfk2v26N4YOPGDZeSNZwB1/4zTSfXXeR+otbL1oahxi/NqYB1LaQRB6+ngo8fpYRl6KmX52EY2lQ8dHTgYfbnghdM3H3yPuud8ArCJnAfhwQyOQ0UIkk7W+kWw1lsnnS3IuJOiSiXzFTY45VDSZZoYuj0vSiI4osURHkwL6Aldl8etrkFvhBSgu4c+VS5UInjJppgz80VE60X4fFFbshyiqf6bnFxzjVz8Zmr4ojg579aBdDEfH+yX4Vhvzej2BFxP3bp4umnfFFA9OTEtyeEUmajiF5pGucJC5GKAgrGiZ+ZdZVFdo03/+L/GylzvKyQiiHkl071uwnx2qf88UVF1bP+B9OV2EOI16SaygfF/SLe7Mm1vYyOQ5fqGVE4aX8ElrQMgnVaDTO5+0d9byeye+tRdHK9ZlfFp6cF5DuDxVKQNyMV5Q15vn9YTeVhwkBBEtrvZmmS821XAHEmL6MqmdsPxq7rchfzgj/5yScKv+B6bKXv5tJ8okRpOSNW+K0rs1lonTOxhgFidaUoEgex8s5duHQ+fGLc5Zu1b4izi2nRVqgNCv7VEUW5vnfmWdp7EQ/B6mMRfFCCJVUs5PquDb5h5R2aAODOZyqO4YHP+Sx8q6t9STrhq7N9WLYijHmBuSvNhreMYkU9yjK00KySohFnsVPBaUYYfa3ztlm0n0sxeYHFQ7GBZTuT//Vz8r9Fby6Tu2RCMoldi3XzwtyAHU9RmY/4HSVCGWNe+Ccv8YWHJAX/6NGywXPfh9YqH0d1EIW/XCk0E1jC1gGD5vIvqj1/KcR5rCbjlt28IPjYJ0uABYaR95A1oBmFQJLz9aRjqtdRdipBHupO7vEyvReCSw4ZN62o33HYj4lbpzCFhNwaJH7pfixnDLSBxEQnFW4KpzKqRHt8t7hmFBpKVHPFBhb8pT0l5uLAsMJcumJiTPzMFYXea9fOD1iFI+8AQ5t5B
 3ZLV6qHm
 pu7YhYpeILkuzoZnRVfY0MPV5HQxUwB0ubaZnEVKO2LJGAVFMU5m07+wIdOsiWUdDFmhVhN0wG+QspBmn6nonkkU5gAKF5Hs7ZvrflImrwNtZv20oXho7zRWrK08i6rnTbCTH15c/KnTReCGQTpr6hMLNu6YRFDk8wLVbE00UjgzX3nSdlvZFBmwPn7ugLxe15rnssfOoZnyzWREcTZS3aAqTg83N5u/vryabm5dx4TwRPSEM5qy34lCUCHcIgQPdHeWY8tDaoN/amQEWgfOKaRAaiN6Kbpund1fAw8d4nPnwPu5Arx3RieXmieT/Yb/DLjDKLIqKJgwhCw77JlYtFsftGRXEr3xD+oCuM9sKGxbHp0qRCDdBWliaAOF6I/mvkhINjlSwGD19ouk3e9142/LkRE6JnXukXrjPLX9UnV7MGQvmaaFvhGEOFlalpi3IuXQrNNTi45NBGn1Md4Q0fItdaiehEVLu7StNqG9MavSQ8gnsSzyyHWryvAhSzx9jMuRDsjyC/ss9PpT+S18A2PCg0xxDx4z/xUl7WmPclsTk0vierv2aXN4fwMVYvmmeCq7hxJbom7Mos+ZrvtdhigkrrQZW0POKwdmmcxELobPWK8c7pcG2kXDq8SbVmT7bmV8v9p6PDWFD3Jm1ZpYUIkQSItwEfSUZV3Btx7nG1BVrl/WRuOAEDbNKLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To support allocation trees, we introduce a new type MapleTreeAlloc for
the case where the tree is created using MT_FLAGS_ALLOC_RANGE. To ensure
that you can only call mtree_alloc_range on an allocation tree, we
restrict thta method to the new MapleTreeAlloc type. However, all
methods on MapleTree remain accessible to MapleTreeAlloc as allocation
trees can use the other methods without issues.

Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/maple_tree.rs | 158 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 158 insertions(+)

diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
index c7ef504a9c78065b3d5752b4f5337fb6277182d1..8c025d2c395b6d57f1fb16214b4e87d4e7942d6f 100644
--- a/rust/kernel/maple_tree.rs
+++ b/rust/kernel/maple_tree.rs
@@ -32,6 +32,26 @@ pub struct MapleTree<T: ForeignOwnable> {
     _p: PhantomData<T>,
 }
 
+/// A maple tree with `MT_FLAGS_ALLOC_RANGE` set.
+///
+/// All methods on [`MapleTree`] are also accessible on this type.
+#[pin_data]
+#[repr(transparent)]
+pub struct MapleTreeAlloc<T: ForeignOwnable> {
+    #[pin]
+    tree: MapleTree<T>,
+}
+
+// Make MapleTree methods usable on MapleTreeAlloc.
+impl<T: ForeignOwnable> core::ops::Deref for MapleTreeAlloc<T> {
+    type Target = MapleTree<T>;
+
+    #[inline]
+    fn deref(&self) -> &MapleTree<T> {
+        &self.tree
+    }
+}
+
 #[inline]
 fn to_maple_range(range: impl RangeBounds<usize>) -> Option<(usize, usize)> {
     let first = match range.start_bound() {
@@ -342,6 +362,107 @@ pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
     }
 }
 
+impl<T: ForeignOwnable> MapleTreeAlloc<T> {
+    /// Create a new allocation tree.
+    pub fn new() -> impl PinInit<Self> {
+        let tree = pin_init!(MapleTree {
+            // SAFETY: This initializes a maple tree into a pinned slot. The maple tree will be
+            // destroyed in Drop before the memory location becomes invalid.
+            tree <- Opaque::ffi_init(|slot| unsafe {
+                bindings::mt_init_flags(slot, bindings::MT_FLAGS_ALLOC_RANGE)
+            }),
+            _p: PhantomData,
+        });
+
+        pin_init!(MapleTreeAlloc { tree <- tree })
+    }
+
+    /// Insert an entry with the given size somewhere in the given range.
+    ///
+    /// The maple tree will search for a location in the given range where there is space to insert
+    /// the new range. If there is not enough available space, then an error will be returned.
+    ///
+    /// The index of the new range is returned.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTreeAlloc, AllocErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTreeAlloc::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// let thirty = KBox::new(30, GFP_KERNEL)?;
+    /// let hundred = KBox::new(100, GFP_KERNEL)?;
+    ///
+    /// // Allocate three ranges.
+    /// let idx1 = tree.alloc_range(100, ten, ..1000, GFP_KERNEL)?;
+    /// let idx2 = tree.alloc_range(100, twenty, ..1000, GFP_KERNEL)?;
+    /// let idx3 = tree.alloc_range(100, thirty, ..1000, GFP_KERNEL)?;
+    ///
+    /// assert_eq!(idx1, 0);
+    /// assert_eq!(idx2, 100);
+    /// assert_eq!(idx3, 200);
+    ///
+    /// // This will fail because the remaining space is too small.
+    /// assert_eq!(
+    ///     tree.alloc_range(800, hundred, ..1000, GFP_KERNEL).unwrap_err().cause,
+    ///     AllocErrorKind::Busy,
+    /// );
+    /// # Ok::<_, Error>(())
+    /// ```
+    pub fn alloc_range<R>(
+        &self,
+        size: usize,
+        value: T,
+        range: R,
+        gfp: Flags,
+    ) -> Result<usize, AllocError<T>>
+    where
+        R: RangeBounds<usize>,
+    {
+        let Some((min, max)) = to_maple_range(range) else {
+            return Err(AllocError {
+                value,
+                cause: AllocErrorKind::InvalidRequest,
+            });
+        };
+
+        let ptr = T::into_foreign(value);
+        let mut index = 0;
+
+        // SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
+        let res = to_result(unsafe {
+            bindings::mtree_alloc_range(
+                self.tree.tree.get(),
+                &mut index,
+                ptr,
+                size,
+                min,
+                max,
+                gfp.as_raw(),
+            )
+        });
+
+        if let Err(err) = res {
+            // SAFETY: As `mtree_alloc_range` failed, it is safe to take back ownership.
+            let value = unsafe { T::from_foreign(ptr) };
+
+            let cause = if err == ENOMEM {
+                AllocErrorKind::Nomem
+            } else if err == EBUSY {
+                AllocErrorKind::Busy
+            } else {
+                AllocErrorKind::InvalidRequest
+            };
+            Err(AllocError { value, cause })
+        } else {
+            Ok(index)
+        }
+    }
+}
+
 /// Error type for failure to insert a new value.
 pub struct InsertError<T> {
     /// The value that could not be inserted.
@@ -378,3 +499,40 @@ fn from(insert_err: InsertError<T>) -> Error {
         Error::from(insert_err.cause)
     }
 }
+
+/// Error type for failure to insert a new value.
+pub struct AllocError<T> {
+    /// The value that could not be inserted.
+    pub value: T,
+    /// The reason for the failure to insert.
+    pub cause: AllocErrorKind,
+}
+
+/// The reason for the failure to insert.
+#[derive(PartialEq, Eq, Copy, Clone)]
+pub enum AllocErrorKind {
+    /// There is not enough space for the requested allocation.
+    Busy,
+    /// Failure to allocate memory.
+    Nomem,
+    /// The insertion request was invalid.
+    InvalidRequest,
+}
+
+impl From<AllocErrorKind> for Error {
+    #[inline]
+    fn from(kind: AllocErrorKind) -> Error {
+        match kind {
+            AllocErrorKind::Busy => EBUSY,
+            AllocErrorKind::Nomem => ENOMEM,
+            AllocErrorKind::InvalidRequest => EINVAL,
+        }
+    }
+}
+
+impl<T> From<AllocError<T>> for Error {
+    #[inline]
+    fn from(insert_err: AllocError<T>) -> Error {
+        Error::from(insert_err.cause)
+    }
+}

-- 
2.50.1.470.g6ba607880d-goog


