Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C3C9E9A049
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8D4A6B0089; Wed, 18 Feb 2026 06:53:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2C4E6B008A; Wed, 18 Feb 2026 06:53:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF96C6B008C; Wed, 18 Feb 2026 06:53:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF986B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:53:48 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D1E485538
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:53:48 +0000 (UTC)
X-FDA: 84457418136.30.1256A37
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6C22B12000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:53:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yVfBT4Jo;
	spf=pass (imf29.hostedemail.com: domain of 3SKiVaQkKCEMfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3SKiVaQkKCEMfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771415626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=POlj+5b3FeGUDIy0t6zTY3NKGZo0gnMVI1S8/pn9WM8=;
	b=BNJHi+FNtVQNb4ARyx/nqZS8Z7pOJzHoCCoPYYlt37cu6Xea7j5TQqL0+xLjfxHLL3NSHR
	jTJPtOqRjsC49SjdhaP5OIXvAMZ2dKRdlGSJRWboL7pnK32SG+5d1wnud+CeMeB+5g3Tkk
	/bvZTl9Ry/edHSH754H1REf+PhlyyFY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yVfBT4Jo;
	spf=pass (imf29.hostedemail.com: domain of 3SKiVaQkKCEMfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3SKiVaQkKCEMfqnhjw3mqlttlqj.htrqnsz2-rrp0fhp.twl@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771415626; a=rsa-sha256;
	cv=none;
	b=eZKLRKxya3y1AZT5Ymu8xJlAQ4i3VsK3FtfhWum+TlRN27dxUlg+nEyBwhFIAj3+3gJ0zf
	0mhcxn8gDJX8+P3nFw0le4judBL6O7AwXJ0SRLE6ShY5D77nA+fgGWouZtq4fuNzBQufPs
	DkQqE7S6oqlRqGygdSROBGONOTvHh6M=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6593d768a99so5571599a12.0
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771415625; x=1772020425; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=POlj+5b3FeGUDIy0t6zTY3NKGZo0gnMVI1S8/pn9WM8=;
        b=yVfBT4JoFfVbzuKbuQhlNpgfTOfzoNgdkF/bEuMMdOLenXIei0p6YqJR7vJ929NhPb
         0XND5qH+ZOU2awrP6aXL0IKAy4bHw2JuVnonc82Jiy1y3zi9I5psZvfzazRnyIZi6PJE
         pei1SADlAKKtEDUejWYJomCF0MCpVxGNZUDpRZrQYu0vVd+teFzEcxoZA6qwh7ymrkFF
         pQU9LzbLeUQ2Uh90SLKaAWFxDieS20faP7YDvfZIvirX+cbKQS6c120xFO/vq4RxTAnl
         6lOue6ladcN53z2X1BhUoWoOARcGPTToIxQ0ZQSb+aaemHzik8qnl1ER9f0v/ZVjeZ0w
         qf4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771415625; x=1772020425;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=POlj+5b3FeGUDIy0t6zTY3NKGZo0gnMVI1S8/pn9WM8=;
        b=Lpgv+nxW4aZwwZ6FTIIJFyJLh7PpjfW8pacDhcuXycljTutMjRx9cShhsZSZJWVVKJ
         iMudK0HzULIIqeZLUPOsjUo+bvrPHXR8jT1TErmjDQp6KKP8FC0yW78AJHxLKSftzOlb
         8d9CZDnYK1gIQ3GySRsjqBkrGdUTEWxzr3kC7dVmd4vDgF25x+rIaR82QfrtjPnhc/3j
         0Ld0A6tOg3VsVaJ0xL7DI6AvWktkdqdMOGqkabXu3jl8UnNS2xGTAUsdT9L5FA1l96po
         pqIxnsKWyGZt0fssu82QGUdIWnrYDnHOehc1e0OXlYmlMloSBpASxWbGHHadDXbsaC6v
         Z09w==
X-Forwarded-Encrypted: i=1; AJvYcCUGkaf5L744eNtni9q/ArYTb+dKc9FwoLfADJsRfesZgIiu3lMJ3eclkN7BYw9Ou9qQz4zYly8fnA==@kvack.org
X-Gm-Message-State: AOJu0Yx77iqq3QmPZweJp9VihkXGeRZuhNkIG/eIg1Lvs9WqDEdsnngX
	cqXT6CNJzjOVOisE5gMg2qAIDQeoLvIPg9x3sRoiDcxqMNyXOktwWV2KnDUbDP0g0QVUiH/NLjn
	zd6VDn9X1n9XK5yiLXw==
X-Received: from edsl24.prod.google.com ([2002:aa7:d958:0:b0:63c:6537:43ec])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:1470:b0:65c:63f0:a92 with SMTP id 4fb4d7f45d1cf-65c63f00e8bmr2549835a12.23.1771415624762;
 Wed, 18 Feb 2026 03:53:44 -0800 (PST)
Date: Wed, 18 Feb 2026 11:53:26 +0000
In-Reply-To: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
Mime-Version: 1.0
References: <20260218-binder-vma-check-v2-0-60f9d695a990@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=7238; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=AHwJyjos7iEyMW0S0TgaVF/r84EvhJvZEX/erTcBJg4=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBplahFgui5qXvwywJz5fy38GnQcd/vmShYSKX2R
 yDlD1BgEXaJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaZWoRQAKCRAEWL7uWMY5
 RkFCD/0cX5qG36V764Q3IeYDdRES05yduGLy7SvLEGQd4l/JdSZoLzFgO6SSAR5zFlF8ZOMRdc2
 4rPFkme+mMC6uClTNzue0xVeSm9cTFaZJgIWzbDN3I9AgnTqurQQE0UQXwlAc37fTjdzkbDahX2
 RB+p1PFmbZOYbuscdcuc+37de7FBlCxdZWjQu9Am2bUWbQ71W6HPWj4uPHAPuXrXVo2z4s0GE7n
 7RdmBazBHK37jQRMUJwG9xtJjLI9GdhZ2LWy271qayls0aW9lZ9waRqh4ATzgqBJlNf0IXS5bnu
 uiWurWiMzaeaDWp+f9P8wsdGKMZmt30ReZcD9EYD9pc2bxbi8ooIO3YKMVgavTwYaJQhQZaFiMI
 fsSIqu3WtFBW7a2fNzFyA0M5c7NfXMuI76Nh/Prj29sgyEV6xX+rFWTUzFfdLyqIWjFJp7fa4s4
 LXz1MqduYOEexBAUjviuPo+W6cuOyf6DDqRkO7zg5ktcWKlgK3yUW1ALLBM0tWDTPTjTcuqqxWY
 S7Kj4DUpja9OAzmTdYdwY49wYMgogqLg5XAxCE37XMmkqvXd0vU1m2/6M5mIZHUQ9/0d2OB0hKb
 /sOH45UxQ1+blp3ajGC2hJb7/VGFzTadtC9cAt70WDoIM4dQh2syJDESamrt7CMTceNn5HRpYka nedUIkmOKe2rrkA==
X-Mailer: b4 0.14.2
Message-ID: <20260218-binder-vma-check-v2-1-60f9d695a990@google.com>
Subject: [PATCH v2 1/2] rust_binder: check ownership before using vma
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
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C22B12000B
X-Stat-Signature: dyzoct7x78xagdrwo6fb1tcshyt5skhx
X-HE-Tag: 1771415626-382205
X-HE-Meta: U2FsdGVkX19VRQyxyOgH2viZNsxWAxdm0JBvFBshDn4ss0q+M/DljFK1lXstgUlhz0wm2eT95ijdCxgdjzQCHr5eABYLSZiPKyG1eKG30ydv1i+V09fn1VxyKAoDZtr1NqZUJpFMPLZYJhRXe4U+uYmhEpdlsgJ5fYS5ificKpuHDR8MB3Ti+qS18ujejw0FT56x3Jo/aO4wdPHRyAv4s8/Plnap8kXkTYBVc5ddMnx5BBHVRQgpN2anR9b+FsHUMXIa+nQMa48rmqNg9Bb0wwB9Chpvjg3A1cy2WSbxNLi5cpEOHMSPZIU4/LIR1esYMPdGRaETOFiBTBIPsVmhBuUbK0uo9DndteK90FuY4iYmfbAP9YHLh0U5qfoXvsT39NxDPVt3fMVInUPkbLrxcmAcYzItGE28/RzocqIF5RaKmKtKP7M0hHov5FV4kKf2Czk+u7EmtGi76R16/tDNQzF/1yf90yBVS1qI0aCsGgLQUSqxiCagrbUhLew5acJe2ki5I3oLb8cm7WYsBCmdVTX0xMkel1PdZTw6PayatBhufePooQluBjj2Rir2YCWrf7hnz8FCmDi4gEyCBug7xLGmHNxAmQIWKUWQVXHuNSnb+H+/u0zIVzc7n3mLyA1coi/8CiAQkO3DKp69QJCyeBWzKmmEeKfigXMdxIrmPmD2Szz+D7SGz+JmQHuGRQNohTBwED0qvs2tiRMi1O4F6Zn5Rs/R5yZElHo5JVSTEzZGUGd5OnDJICe6dVN1SU3NQRlT0YriHiIVzU7fcL0udxXnIJZTUyVpsyKXdJ8aKbQ9BKpfdp0OyhxoGGDYdKxSgorGyzndXGmruKdtjslLkaBdKH3mBuzYGIEK+O1TtHOyvN5DLLviWVcjHhIK+3/sqs7Tx1J23q16aeH192TZaw1+ZvPccGwUYO8BuDjgjYFL/iv4rxAST9NuwDJo1JPL+NU4wADTnqvq/FD+AEb
 1SmzsgbA
 cspN1UMWg3v0Fh3u6zxTU3kg1JH+UmJiuf4t4h/tbsY5p+keTQfYPgb04A0naZWhZUaTqWIvLeSLK6giktPLPVrS28mwuj0mgx8am/Im+MlgBI0FiF/VL4VAa6RbwtuPomoUB4mAQ2TXHneOruPSehrAywzh12OIwNRXkMYLQ3Lsc7/i+bLmsDMQMaHMz/qoCkO69imbkFn5NbPVld1/5x+g6WlHIWB4ldLlM+g++4sNEy4B0oFLm7JGVrebMWJZoHMREPoTO3Yj2V+k+IyvmU6M9eHXnT+xr2Uxae8ryCGB3FLJRZAY6TxpM7Duvd3LMewtDu4sgFTDtJScJgCAL9hyquEHtZsYEPtBBXBkkcstj1bgsgHS3sDvH38heyj9scc5x+GnhrvHne3uiDk4eWoEeNqwtDkVtbWUUWEkjAzy4xe6cgNgOVxyrlb8Gb3eiKvix90kQyHdxvaaQN+4/7Eob3sZGgbokzH2mWY8YgLmuEghgAcM5ZOlWtlkZtXnAbDJ64d0c4el7OGeuRodePd3OKbD46Kz7l3xZpgx7psvZnhtA7tfaBAK1PDjazqFS73FmsBuO+DyQ0VVuiGgskxVfUxBuz5s3h0hyFd4urMpYLEK2POHGb+sJ8Hjel12vK9n4DGa2j3McLMs=
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

To fix this, store a pointer in vm_private_data and check that the vma
returned by vma_lookup() has the right vm_ops and vm_private_data before
trying to use the vma. This should ensure that Rust Binder will refuse
to interact with any other VMA. The plan is to introduce more vma
abstractions to avoid this unsafe access to vm_ops and vm_private_data,
but for now let's start with the simplest possible fix.

C Binder performs the same check in a slightly different way: it
provides a vm_ops->close that sets a boolean to true, then checks that
boolean after calling vma_lookup(), but this is more fragile
than the solution in this patch. (We probably still want to do both, but
the vm_ops->close callback will be added later as part of the follow-up
vma API changes.)

It's still possible to remap the vma so that pages appear in the right
vma, but at the wrong offset, but this is a separate issue and will be
fixed when Rust Binder gets a vm_ops->close callback.

Cc: stable@vger.kernel.org
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: Jann Horn <jannh@google.com>
Reviewed-by: Jann Horn <jannh@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/page_range.rs | 83 +++++++++++++++++++++++++++---------
 1 file changed, 63 insertions(+), 20 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index fdd97112ef5c8b2341e498dc3567b659f05e3fd7..67aae783e8b8b7cf60ecf7e711d5f6f6f5d1dbe3 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -142,6 +142,30 @@ pub(crate) struct ShrinkablePageRange {
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
+    // The ShrinkablePageRange is only dropped when the Process is dropped, which only happens once
+    // the file's ->release handler is invoked, which means the ShrinkablePageRange outlives any
+    // VMA associated with it, so there can't be any false positives due to pointer reuse here.
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
@@ -308,6 +332,18 @@ pub(crate) fn register_with_vma(&self, vma: &virt::VmaNew) -> Result<usize> {
         inner.size = num_pages;
         inner.vma_addr = vma.start();
 
+        // This pointer is only used for comparison - it's not dereferenced.
+        //
+        // SAFETY: We own the vma, and we don't use any methods on VmaNew that rely on
+        // `vm_private_data`.
+        unsafe {
+            (*vma.as_ptr()).vm_private_data = ptr::from_ref(self).cast_mut().cast::<c_void>()
+        };
+
+        // SAFETY: We own the vma, and we don't use any methods on VmaNew that rely on
+        // `vm_ops`.
+        unsafe { (*vma.as_ptr()).vm_ops = &BINDER_VM_OPS };
+
         Ok(num_pages)
     }
 
@@ -399,22 +435,24 @@ unsafe fn use_page_slow(&self, i: usize) -> Result<()> {
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
 
@@ -667,12 +705,15 @@ fn drop(self: Pin<&mut Self>) {
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
@@ -717,9 +758,11 @@ fn drop(self: Pin<&mut Self>) {
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
2.53.0.310.g728cabbaf7-goog


