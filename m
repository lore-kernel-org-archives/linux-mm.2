Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 520FD606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jdzf7kP1
Received: by kanga.kvack.org (Postfix)
	id 5CFA96B05BF; Fri, 20 Nov 2026 05:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559B56B05C0; Fri, 20 Nov 2026 05:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 448FE6B05C1; Fri, 20 Nov 2026 05:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19CD56B05BF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96EA6160EBE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:35 +0000 (UTC)
X-FDA: 85455123390.13.CCCA85A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id CF374180002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:33 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jdzf7kP1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170513;
	b=Dh0LOUJYbFR7/VTPjFvDgJHyRCqPab5xnUQqmgbt21sYDEJlh4oHfF7ik1/kqgcyDHM+Na
	oVlphuzkDcHA9jzsw1ISNCEFn7CZlYl6PSWfFXlgDd4dh7fQbfYSVgNzrNZuEXT6BYZ52B
	dQItnFVlurBI463opDhMrBx4lJAHSFM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rBLyy8yIWs7igApO2EIce+czdiY6vYX188Cradx6Qoc=;
	b=4DuA0pLC72vfLAML/WRRK52xff6PRf2NHb01Bm2UGKspjTO8jbjDgDlt2knCek5eVzFPJC
	KC2JEHNrfQ0QXaeGZF+KyVUCCKPcrmGeVBcWOl5X0c+6Otww/zdo4Pw4hkrunCGIv7P07u
	+bFTFiYv5sgXOif4uQjizJQK4o5f+q8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jdzf7kP1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C91D62710;
	Fri, 20 Nov 2026 10:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517F81F00ADE;
	Fri, 20 Nov 2026 10:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170512;
	bh=rBLyy8yIWs7igApO2EIce+czdiY6vYX188Cradx6Qoc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jdzf7kP18P89AhI5FqPZU2Eu+JFmD6PUkUTX4HzGAiP0a868cfL/NsNzeb0PotnA5
	 +h/mGa/sADisw9xNoTkrsH3ISbgmlL8tqeG8T/wmb+LJNwejmrOk2BTjYVM2R8rQ2V
	 OsVOi2Z3THNYNjHeBMDIxRzcBLGGVnPKOkr+DNvCr6Jlwv08fMMv+lw38PlmrVXPCi
	 lJ3WwH8DKzN0mkIWfR/vJZANbEAcp7qGrDxjbIb1EqBFQgLdl2F2mQ7/UWi5PpgMW4
	 BsF5L0GmCvdFZZzuIi3NvvPoxrASAP01g7QmH1tkA2EPS+g+/uGY/rdUyGxSe8kXMY
	 Ml0zOMPfm2zcg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:08 +0100
Subject: [PATCH 09/11] rust: page: add `Page::with_page_as_sysmem_local`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-9-66f8c4c62822@kernel.org>
References: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
In-Reply-To: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6313; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Pp912Hpst4UEXsVK2CKEGwo1oxgZi8R2rnnTjQvDyoA=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCJ7AdUaY6xLJpeqXzITlzXG3r0yvC2GtUG1
 xtiZOi/m3mJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAgiQAKCRD6UCkIqsW9
 0HLDEACjH6w0dhSioz0cwNL8k77aa9fTdw3uSbiJWfLc50rRLz9V4uIMtbybohoSr2dJMRTclM8
 Ejkjlluk3t3nuKcTZ9sHXt7NnflUas4if0fngSbKZsKbxVoLc43EB60uplIICy59PttPPQ00ujX
 2AH3xClkXxiJGlTwhvtsqEik2+zuKJT27DhNTlolHIXlpXsklkwQqBPavEZd6VQNVXEvf9e/Cul
 IGV6FCs7mjax1vhhjMg+TvbcvnohIQvCVtr7SJuwfu8kfIf8DHRDA1r4WAUVPUTI+5B/UXKNiYL
 7JeNlICW5p7AVCVI99nmrr4dg7npPbwaku6M9YIhq4L+DsYASMepqDsqlwpfBjF/Jn1seaGuypk
 i4GEDa4WsQ88HXldXHIeVXIm3uixQcgnkAmO6zoHknRUEfiAVo14UiM9MhdMsPAfeuOf4jopTBj
 uyKBN0cQO2qBH1BVF4QKvnw3ZA0rJO15h5osD+I1Q76dy3+gbw7pViYPs6nIXthHR5nEHYiV7Tz
 mtE3oVQUZL3ApX7zc+HFXvnpvDL0IVi+vBCRTx3cFOacdFAsa8VjKStFni21qjILLcjY6AcE6dz
 AAYeKnV1fXLiIu/CY0yS9d6VtsoSud3vlVC5g94mRJDvTf+s6IDbFJYsHutEmV5+6p3cEkDNWJU
 2xrtgBlHAnA+99Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Stat-Signature: nys45mnaob4i57sxhj9mzr1xy1c8b1f5
X-Rspamd-Queue-Id: CF374180002
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795170513-112440
X-HE-Meta: U2FsdGVkX18MZidCDfpeaCiHi8bTpxs0HvV4arIUcSobPZXbn2xe+Co48odCTxYkJTIhzcAOSDI5NmYhNcaHn7eXK1upDfpjVz4rS9YxRKjOaLCRZU+s7Xf8ZLdYyQfQGlrjyfgRqeBtYDCR7qdrge5009cAWBRtY7Bg84QI5ZXnmrc3J1AVmbXb1IuJuYxP6bNqL0KufztQQvj6GvVXDRH5Iw4QMTfBg6V8MR/k136dRB+AXej0GTLsTuLGAs3Tw2feh6vmB5viB8KHZ7Dsm9sr7ghKNUgWvs+wxGaLph/+SSHZq9gS2IDUgfbaDvD10vm0W4+Iqnb/caI+jKL1DIIayUsMBdkTtHgqF53fS/urlSndDoK3RKO+5Rjkrmy5gakzu3S2q1YIYDTCyl7iER7rd8yn+yi2xYvcG6OBp7hwnG2ARBkrq2uRInLZ1Egv7wdfO2GPf9v5bsBeGA+qw0cMLZgKGheBVE8C4aKqmSavX6CYFfV+XYgxFqjz4KYalVhtXEytk6N3/myhCKfArWnq4KLfRX6z8cbc0n18ICjU613jK6nmiGepdiWtuoD1B53YOZ9kANolUJjkxAar6H8qPpFDfE5c3JsjIzmk7wP+/tShYjmcmr8yUdfJm5eCk5OxAdDX6pQZZj8bs3oQHIEdY+ZPiHDu7kDiruMto6wK0JE4rSFuzzFhwKUqn3rU2WuXXPe6i4K4Ir6bjF6eWinI5Q4g2Br5NoiuyQ1yEuZSkWqg4cG6rySnolj/Z3FknD0I/OfFKDmaMjXWY8zHk482vJe7ueQf3LwKporDG9DIv95xzIvgoRp0cQ/t6gXQ5BPSx8a5KoDWm0L7AwAPYN9MVVFJtbki6pHQKConvouhucWAovdgsPrT3nDbdYZZ7Adjst2H7kVkSkV2IIM44IkCFIoHyKcpvkQ7IRBlRprrirPZC3F4v+OZsPnkdzkwXvJnA1NEFzvSRuU7j6x
 daBUSSbq
 MPS6FI7JMjNLrGktrQPfVQZovHvgE7K6JznepVlGey5rBGeCfcVAf13XaRJwY9aAs2zZ0hwGf2pXg6o5vOt9osNvER+VT9h5dYXp+q2KeLmPWNazNG1Ur2AhjS3XHM92RtoO2ApLKgd9Qkr3Sl0+qs50+EM1B1gKzepDRcFETDgQzDacEgVgV6C3KY4ZZGm83PPDLViUzott3YplHi6YguxXSJTSoY00QjTWHFVtIxXXSQy1b2eh32qOmHQsQi+lHPA3vTHMK9Zv9LXxhBC0c95YZOxkjIv1qE99WsKLeKC4L9d5okjerinqdxNOuwxvdXaJsFwglqRvDRAGpFY9DYYog7kp3vqjdbFUrV5Qb2+3vyj56A9XlditXC4tts6kszVn3QNfkCvjdTGa1jFw+W24J9/4hfMWogI7gj+44bgD+zmGMBWf0Uo1omaEIOu0T5S5gHNupgtcLORGz2FOJ+AC6nP5MBHCkaOqqO5U6KiDiUyxKyGQGG/8TUrVQoaJRLdo3ffr2KoU5rvNBQaPpU3nrn1edB4d0oF44soYZX72t1Ug=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The data of a `Page<Shared>` is initialized and is not referenced by Rust
references, so it can be accessed safely with byte-wise atomic operations.
The existing accessors of `Page` are available for all page kinds and are
thus unsafe: a write can alias a slice obtained from a `Page<Exclusive>`.

Add the safe method `Page::with_page_as_sysmem_local()` for
`Page<Shared>`. It maps a range of the page and passes it to a closure as
a `SysMemLocal` view. The view is not `Send`, since the mapping that backs
it can be local to the current task.

A `Page<Exclusive>` does not dereference to a `Page<Shared>`, so the
method is not available for it.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 89 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 85 insertions(+), 4 deletions(-)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 85c710fa3dfd..7fa037f5938b 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -20,7 +20,8 @@
         Io,
         IoCopyable,
         SysMem,
-        SysMemBackend, //
+        SysMemBackend,
+        SysMemLocal, //
     },
     sync::aref::{
         self,
@@ -132,6 +133,8 @@ impl PageKind for Base {}
 ///
 /// The data of a [`Page<Shared>`] can be accessed concurrently by other parties, such as user
 /// space, devices or other kernel code. Thus, no Rust reference to the data of the page exists.
+/// The data is accessed with volatile or byte-wise atomic operations through a [`SysMemLocal`],
+/// see [`Page::with_page_as_sysmem_local`].
 ///
 /// A [`Page<RefCounted>`] and a [`Page<Frozen>`] dereference to a [`Page<Shared>`]. A page that
 /// is managed by other means can be referenced as a [`Page<Shared>`] with [`Page::from_raw`].
@@ -374,13 +377,14 @@ fn with_pointer_into_page<T>(
     /// Runs a piece of code with a range of this page mapped as a [`SysMem`] view.
     ///
     /// If `f` is called, then it is called with a view of the `len` bytes of the page that start
-    /// at `offset`. Accesses through the view are volatile or byte-wise atomic, so the view is
-    /// suitable for a page whose data is subject to concurrent writes by hardware or user space.
-    /// The view is valid for the duration of the call to `f`.
+    /// at `offset`. The view is valid for the duration of the call to `f`.
     ///
     /// If `offset` and `len` refer to a region outside of this page, then this method returns
     /// [`EINVAL`] and does not call `f`.
     ///
+    /// This is the building block for the accessors of [`Page`]. Use
+    /// [`Page::with_page_as_sysmem_local`] for safe access to the data of a [`Page<Shared>`].
+    ///
     /// # Safety
     ///
     /// * Callers must ensure that no plain access to the mapped range races with an access
@@ -658,6 +662,83 @@ pub unsafe fn copy_from_user_slice_raw(
     }
 }
 
+impl Page<Shared> {
+    /// Runs a piece of code with a range of this page mapped as a [`SysMemLocal`] view.
+    ///
+    /// If `f` is called, then it is called with a view of the `len` bytes of the page that start
+    /// at `offset`. Accesses through the view are volatile or byte-wise atomic, so the view is
+    /// suitable for a page whose data is subject to concurrent accesses by hardware, by user space
+    /// or by other kernel code. When an access races with a write, the data observed may be
+    /// arbitrary. The view is valid for the duration of the call to `f`.
+    ///
+    /// The view is not [`Send`], as it can be backed by a mapping that is local to the current
+    /// task.
+    ///
+    /// If `offset` and `len` refer to a region outside of this page, then this method returns
+    /// [`EINVAL`] and does not call `f`.
+    ///
+    /// This method is not available for a [`Page<Exclusive>`], as writing through the view would
+    /// violate the aliasing rules for the slices returned by [`Page::as_slice`] and
+    /// [`Page::as_mut_slice`].
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::{
+    ///     io::Io,
+    ///     page::Page, //
+    /// };
+    ///
+    /// let page = Page::alloc_page(GFP_KERNEL)?;
+    /// let mut buf = [0xffu8; 4];
+    ///
+    /// page.with_page_as_sysmem_local(8, 4, |view| {
+    ///     view.copy_to_slice(&mut buf);
+    ///     assert_eq!(buf, [0u8; 4]);
+    ///
+    ///     view.copy_from_slice(&[1, 2, 3, 4]);
+    ///     view.copy_to_slice(&mut buf);
+    ///     assert_eq!(buf, [1, 2, 3, 4]);
+    ///
+    ///     view.fill_zero();
+    ///     view.copy_to_slice(&mut buf);
+    ///     assert_eq!(buf, [0u8; 4]);
+    ///     Ok(())
+    /// })?;
+    /// # Ok::<(), Error>(())
+    /// ```
+    ///
+    /// Copy data from user space to a page:
+    ///
+    /// ```
+    /// use kernel::{
+    ///     page::Page,
+    ///     uaccess::UserSliceReader, //
+    /// };
+    ///
+    /// fn copy_to_page(page: &Page, reader: &mut UserSliceReader, len: usize) -> Result {
+    ///     page.with_page_as_sysmem_local(0, len, |view| reader.read_sysmem(view))
+    /// }
+    /// ```
+    pub fn with_page_as_sysmem_local<T>(
+        &self,
+        offset: usize,
+        len: usize,
+        f: impl FnOnce(SysMemLocal<'_, [u8]>) -> Result<T>,
+    ) -> Result<T> {
+        let f = move |mem: SysMem<'_, [u8]>| f(SysMemLocal::from(mem));
+
+        // SAFETY:
+        // - By the type invariant of `Page<Shared>`, no plain access to the data of the page races
+        //   with another access, and no Rust reference to the data of the page exists.
+        // - Safe code can only write initialized bytes through a `SysMemLocal`.
+        // - `f` converts the view to a `SysMemLocal` before it is used. A `SysMemLocal` is not
+        //   `Send` and it cannot outlive the call to `f`, so the view is only used on the current
+        //   task.
+        unsafe { self.with_page_as_sysmem(offset, len, f) }
+    }
+}
+
 // SAFETY: By the type invariant, a `Page<RefCounted>` is managed by the page reference count.
 // Incrementing it via `get_page()` keeps the page alive at least until a matching `put_page()`,
 // which frees the page when the count reaches zero.

-- 
2.54.0



