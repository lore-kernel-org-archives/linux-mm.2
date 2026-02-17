Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8028CE909A4
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:22:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1D476B0089; Tue, 17 Feb 2026 09:22:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5686B008A; Tue, 17 Feb 2026 09:22:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB70B6B008C; Tue, 17 Feb 2026 09:22:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 98CAE6B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:22:56 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D234D55CDF
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:22:55 +0000 (UTC)
X-FDA: 84454165110.14.49026C0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 141B9C000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:22:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=284Riu4m;
	spf=pass (imf28.hostedemail.com: domain of 3vHmUaQkKCFUx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3vHmUaQkKCFUx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771338174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82Js1rcnoAKTgbxsBEWU8ya5WrRt0JL+YHVGM9jGo+A=;
	b=2O0XCdgQva7Ax0IoqR93n1MoHzzam4/RbrfzuPTdt6VkYTF3PBbMaxxRPHwtXA5vE/wJ1o
	vW3AGit/UWg+7hmsAsHOplvua22HrFHTDUZPVjv3UfjNqEDp0iyMWjklu9gNET80qfDKP+
	mlNqEVqCtxxrFb8AKWVDfJ2m7HuncME=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771338174; a=rsa-sha256;
	cv=none;
	b=3SKadqZygk9PK7tzCTPI40gy6P2Du92ZVlr8VXcN2ice/Ga4bETfJxw5ItBOevPzoMSSoM
	f0ex6IO6kpK2/9Dy16c2dMc2eVzQJ7DkkUgCASV6S35WZfrQ/1ZheC5ntDR1zTL9D4reG4
	ymy0PrIYvDEu+2CNTW3Zm41JchUXQx8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=284Riu4m;
	spf=pass (imf28.hostedemail.com: domain of 3vHmUaQkKCFUx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3vHmUaQkKCFUx85z1EL483BB381.zB985AHK-997Ixz7.BE3@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-482d8e6e13aso29807835e9.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 06:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771338173; x=1771942973; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=82Js1rcnoAKTgbxsBEWU8ya5WrRt0JL+YHVGM9jGo+A=;
        b=284Riu4m56xRhFJkXlSBgkce3O9FzoaWWOrJ+eqgt7lnwbt/BhKthE7q4yKP2jh2ZL
         DpE8FfN4D2YUiZBPig+aTgxLfecUduOFlJ5+ncUw/0rq1XNdIA4MjBmxhCnyr0lpTpGM
         /2aH7a2XCVMyCMO3TzmMkR1LIXZ+h2xjhRzxKPrsqp5Wr1D+AxRBLwyASR2TuGUtnHMx
         A2zo5GfNLy/yhQ9N9+9tYiR9DnsdXLMHccJL5//48Dq7zarEi2BXyqIBE7BTw1l0VNAB
         zsxyh02WB7DDvU9ItCo/EHDjBKrnyebxCWphGim5xNz8gpJBdAt5pBbg1rbCxtMWS+08
         mykQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771338173; x=1771942973;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=82Js1rcnoAKTgbxsBEWU8ya5WrRt0JL+YHVGM9jGo+A=;
        b=eOgrGGiqDvi8NjNGjRI42dhuO0mvEgTSBoxH3M7JxThVySW2yMtbm5R37th/HkRt0Y
         cCA5bd8H3R2jZqHhUUDsZqCFfY+frdReHBcmGHpIoESg4eP0pAu5k73MTJEmMdsdOK8Y
         mlBFL+ruEIrwJ8QClQ0v0AtrXuuaq/cnpujTX+F4YkF47oSSdAQPdwzUf59YNMmSY0Cl
         fLeaXiGHvj67WSyvA/mfD4vvA5+Tid0iunTEuUS8TpvMRVg4l1QewNAcF2s7TdUl651e
         k9fHPbBqet8JFpk4gWRdmUyyR6c1hal5veD3jEB3S9C8d2/D+uEbWMDOgZCQnsnR8XGT
         wDGw==
X-Forwarded-Encrypted: i=1; AJvYcCXNbWB+3kICGlSgEMthtx2NH5Y+Zon0jimWFOGJ7SGl1N31P5s2LlB1V6WQ3Ve8oE9AZVfm/6v9bQ==@kvack.org
X-Gm-Message-State: AOJu0Yz1FHUurs7sgMCH+wO8dT2cjanKkg07t0+mX81MRDCyzMRT8j1f
	QAypyZe7lngrw0LM37ud2DsKwfqplEmuThszL/WP8HQkcsnRtuAdIBwlr4aWLr9ERe9D/TeFzhH
	1teexC3f6vgQ9VUbpqQ==
X-Received: from wmpz8.prod.google.com ([2002:a05:600c:a08:b0:483:248b:3e95])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6096:b0:483:612d:7a9a with SMTP id 5b1f17b1804b1-483737b89a4mr196316545e9.0.1771338172603;
 Tue, 17 Feb 2026 06:22:52 -0800 (PST)
Date: Tue, 17 Feb 2026 14:22:38 +0000
In-Reply-To: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
Mime-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=6670; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=nQm0AngjwMT2UjJFuUZvKHEzTseqZByPMN8Hgm6xrz0=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBplHm5X0xpCMTJgViI69+ZHnDddFhIjmNIbX3+H
 22nzhl4nK+JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaZR5uQAKCRAEWL7uWMY5
 RvfVEACevIXSL/nDzA5yoF/95U0BuALOFRvt2mjZyyKCqmRHKG9aBPN8m+1nL/RiNvc5mBC/Zwk
 Zey/Sl5m6/sD4ByVyYcIK3WFhrQ4qJ56vGXB6kTaEDjvJcrC97c2IQz2CaQoFXaafhth3ZPUhWC
 kRbmr1DB/5f/owITX8pEibPhT9k0seZ5ehsQOhleqwoX2d49V8q5LisgL6pzxJVAgItj53wcUJa
 jEk8+qm9TXYV7lHzkrpUE1PfjjCfTatfBHtupQMxsje6oxHcwnxWG7M4C3YbMAQC28s+j5nepA8
 HIkErf5ecF2gZ2W20F0um9mOe4jlhoOrWn2EmvoV9SfR0xU+7wdq9D61ZpaZN5lPtkaSZXmc0rQ
 ifxWJLTPlfL9eETm8SnFGqZf5OAJN+OX/KXsvbOIImLEJk6PlUwgu5p6RoN9LtfPnMZFwKw77Y/
 ZacwJnRlncRWqto1hLWU+D92I/Klj1QdyQfRI6YPAlnF02qMf/oSIFMA4kJSvuQJvYGpKoRDgIx
 oUFK2uhuuCY5lMhrOK0EuQrHjtSOKOcrS2swG1FsaWVPRzaGEMhn1OdU2+D/jJEBqo0JDW324tb
 1ypvZ/ou6BQrVGMUsgzjHiPjbe65SCrn9sn74AUW458o3QesKzrTDY7ftjtdZdnx5OW+b0Cfx3e R1fE2AJ/jGgNmcw==
X-Mailer: b4 0.14.2
Message-ID: <20260217-binder-vma-check-v1-1-1a2b37f7b762@google.com>
Subject: [PATCH 1/2] rust_binder: check ownership before using vma
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Stat-Signature: 9ii8j8ep5kw1cg4mqu34tih1yx9u37yg
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 141B9C000C
X-HE-Tag: 1771338173-924221
X-HE-Meta: U2FsdGVkX1+sP+bqTYfaDXL70ykXX6bBI/vw2gTgZrow+frBAHnBGcJpwSpcm2ccOchLdlJNosxCkwYEhqSvAaCdiPGX8mqMZ1S0KL+MUjYDJcYtQJozs1bZYqQu9jRGXNKzv11UmjPgccEuBHrAykUEXcanoJyt0ywIgqtGPmKXfrAGf2OVQl0EvnzN4/ZrW6JrCf5nsKXXu2X2C/nlOetmNT3qhsbngvv+nbvnxOJ2T79c/1wjqz42izN2vPpMg5ioHLaWyyOrrKQui+/9deT66Z2C+Vs0itMkrXo+w8e9WPv/p0+cnZOh4OrIoeevcjKFxMnIr2C1iURDEl2+9yeDLne5ElxeDzcmWeFWy0KZhmqnFETLO3Dw3wfb+8zwZU4YzO0uN42TX9Y6tX+geYuewjTkbxa3R5iu2/DNwTtnoxezCuPg7bK17AjUxco+BNi01aqDzHzuKHCTbagmr4KyraDj+Qo3Q0RAtqU1oj6S4fatR3kEircTASPyTU4WCo6esMByGpS+90QQvQnDPxV6xBITRAVCRJrNw8KdRfpNo8R+ugwNbU37R4JjadFAF+JZaTV/vQVH9yRg6kvTwqC+qsjA4sRgbjJ9VXN+66iR6IqrVun0EMJV8fjVa7+xeinb73AZw+PwCMBdqxmabjCFPA7ZXS9my0LYLsbCiVlJ7QuMH4VoOyPsNKLiJOviqTtHPN+xKGIWbn3jqWgXD5wc3hikLm/L6Mgh2n52Kx8qiCAZFLrslsYaUKeTRPXMfvVPpl2/Ag1NZM81lXrjXgCaAySD5+Jb8aFa6BwIzsXDg7cNJOeuzbr5nKhLfB4g5yxLb6Sq5XK5mrMZljp6Pj3p/tHrpPi/0FO0Wu+msmPVATKBPhSwpy15oLgpvLDCoQQwWMfhHQutiPaffW+UeNlJQrN6gjMwa7vByGgpl72vXTmcYIOjnyryaI6Tm6tDaXcGH7vNl0pu5f3SpA5
 kdq6Q3/k
 BvW5KatcCFjaeodoeGQN0Y5yj1CuVSIS30MAyAMwJAxJ/5PtKq9CJqxytHNC6wpP63bUNRnwug72yMEUtJs3DP2IoFfTM7ViSRj8Tt9yRLn6DhumYkukyfD6Q1rjzBxbpnTDcYCo1wSTUchjEYkibDjHLj092htrnrDmTCH0lv31LzWMvRkk4SXc6JeER661672V1NhNgMHgFlPas9pBa+KHxmKf67U4np89xC4+VTbHEJHNK0HgXITWMX9OqmoqkIqYdJEYRKjOKRzFHELpMx/MjXZiRjIKIBmetCUH9MhCIFTAfgVq1o6Ih7KD+iesNh/o+OH4AvdRv4X4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When installing missing pages (or zapping them), Rust Binder will look
up the vma in the mm by address, and then call vm_insert_page (or
zap_page_range_single). However, if the vma is closed and replaced with
a different vma at the same address, this can lead to Rust Binder
installing pages into the wrong vma.

By installing the page into a writable vma, it becomes possible to write
to your own binder pages, which are normally read-only. Although you're
not supposed to be able to write to those pages, the intent behind the
design of Rust Binder is that even if you get that ability, it should not
lead to anything bad. Unfortunately, due to another bug, that is not the
case.

To fix this, I will store a pointer in vm_private_data and check that
the vma returned by vma_lookup() has the right vm_ops and
vm_private_data before trying to use the vma. This should ensure that
Rust Binder will refuse to interact with any other VMA. I will follow up
this patch with more vma abstractions to avoid this unsafe access to
vm_ops and vm_private_data, but for now I'd like to start with the
simplest possible fix.

C Binder performs the same check in a slightly different way: it
provides a vm_ops->close that sets a boolean to true, then checks that
boolean after calling vma_lookup(), but I think this is more fragile
than the solution in this patch. (We probably still want to do both, but
I'll add the vm_ops->close callback with the follow-up vma API changes.)

Cc: stable@vger.kernel.org
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/page_range.rs | 78 +++++++++++++++++++++++++++---------
 1 file changed, 58 insertions(+), 20 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index fdd97112ef5c8b2341e498dc3567b659f05e3fd7..90bab18961443c6e59699cb7345e41e0db80f0dd 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -142,6 +142,27 @@ pub(crate) struct ShrinkablePageRange {
     _pin: PhantomPinned,
 }
 
+// We do not define any ops. For now, used only to check identity of vmas.
+static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
+
+// To ensure that we do not accidentally install pages into or zap pages from the wrong vma, we
+// check its vm_ops and private data before using it.
+fn check_vma(vma: &virt::VmaRef, owner: *const ShrinkablePageRange) -> Option<&virt::VmaMixedMap> {
+    // SAFETY: Just reading the vm_ops pointer of any active vma is safe.
+    let vm_ops = unsafe { (*vma.as_ptr()).vm_ops };
+    if !ptr::eq(vm_ops, &BINDER_VM_OPS) {
+        return None;
+    }
+
+    // SAFETY: Reading the vm_private_data pointer of a binder-owned vma is safe.
+    let vm_private_data = unsafe { (*vma.as_ptr()).vm_private_data };
+    if !ptr::eq(vm_private_data, owner.cast()) {
+        return None;
+    }
+
+    vma.as_mixedmap_vma()
+}
+
 struct Inner {
     /// Array of pages.
     ///
@@ -308,6 +329,16 @@ pub(crate) fn register_with_vma(&self, vma: &virt::VmaNew) -> Result<usize> {
         inner.size = num_pages;
         inner.vma_addr = vma.start();
 
+        // This pointer is only used for comparison - it's not dereferenced.
+        //
+        // SAFETY: We own the vma, and we don't use any methods on VmaNew that rely on
+        // `vm_private_data`.
+        unsafe { (*vma.as_ptr()).vm_private_data = self as *const Self as *mut c_void };
+
+        // SAFETY: We own the vma, and we don't use any methods on VmaNew that rely on
+        // `vm_ops`.
+        unsafe { (*vma.as_ptr()).vm_ops = &BINDER_VM_OPS };
+
         Ok(num_pages)
     }
 
@@ -399,22 +430,24 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
         //
         // Using `mmput_async` avoids this, because then the `mm` cleanup is instead queued to a
         // workqueue.
-        MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?)
-            .mmap_read_lock()
-            .vma_lookup(vma_addr)
-            .ok_or(ESRCH)?
-            .as_mixedmap_vma()
-            .ok_or(ESRCH)?
-            .vm_insert_page(user_page_addr, &new_page)
-            .inspect_err(|err| {
-                pr_warn!(
-                    "Failed to vm_insert_page({}): vma_addr:{} i:{} err:{:?}",
-                    user_page_addr,
-                    vma_addr,
-                    i,
-                    err
-                )
-            })?;
+        check_vma(
+            MmWithUser::into_mmput_async(self.mm.mmget_not_zero().ok_or(ESRCH)?)
+                .mmap_read_lock()
+                .vma_lookup(vma_addr)
+                .ok_or(ESRCH)?,
+            self,
+        )
+        .ok_or(ESRCH)?
+        .vm_insert_page(user_page_addr, &new_page)
+        .inspect_err(|err| {
+            pr_warn!(
+                "Failed to vm_insert_page({}): vma_addr:{} i:{} err:{:?}",
+                user_page_addr,
+                vma_addr,
+                i,
+                err
+            )
+        })?;
 
         let inner = self.lock.lock();
 
@@ -667,12 +700,15 @@ fn drop(self: Pin<&mut Self>) {
     let mmap_read;
     let mm_mutex;
     let vma_addr;
+    let range_ptr;
 
     {
         // CAST: The `list_head` field is first in `PageInfo`.
         let info = item as *mut PageInfo;
         // SAFETY: The `range` field of `PageInfo` is immutable.
-        let range = unsafe { &*((*info).range) };
+        range_ptr = unsafe { (*info).range };
+        // SAFETY: The `range` outlives its `PageInfo` values.
+        let range = unsafe { &*range_ptr };
 
         mm = match range.mm.mmget_not_zero() {
             Some(mm) => MmWithUser::into_mmput_async(mm),
@@ -717,9 +753,11 @@ fn drop(self: Pin<&mut Self>) {
     // SAFETY: The lru lock is locked when this method is called.
     unsafe { bindings::spin_unlock(&raw mut (*lru).lock) };
 
-    if let Some(vma) = mmap_read.vma_lookup(vma_addr) {
-        let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
-        vma.zap_page_range_single(user_page_addr, PAGE_SIZE);
+    if let Some(unchecked_vma) = mmap_read.vma_lookup(vma_addr) {
+        if let Some(vma) = check_vma(unchecked_vma, range_ptr) {
+            let user_page_addr = vma_addr + (page_index << PAGE_SHIFT);
+            vma.zap_page_range_single(user_page_addr, PAGE_SIZE);
+        }
     }
 
     drop(mmap_read);

-- 
2.53.0.273.g2a3d683680-goog


