Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FF4610706CD
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 11:20:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49D436B008A; Sat, 14 Mar 2026 07:19:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B7A6B008C; Sat, 14 Mar 2026 07:19:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F9C6B0092; Sat, 14 Mar 2026 07:19:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B14A6B008A
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 07:19:59 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9FF9E140823
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:19:58 +0000 (UTC)
X-FDA: 84544424076.22.88AA94D
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf27.hostedemail.com (Postfix) with ESMTP id B598840006
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 11:19:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P5qtRJa7;
	spf=pass (imf27.hostedemail.com: domain of 3W0S1aQkKCA4ozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3W0S1aQkKCA4ozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773487196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V83MI+X4cH1kv5YYy8UyAToYkv5v+x2hivsQCcl9ql0=;
	b=k5Sl2f5wJJE2EkahCfbTqRdbSOlQxhel3Kxl0VHHYlViEmrOvgWCSdLuXcJH75Qr7CeT5t
	m68TnLB9u1HqQ0fXOC+Hg+nR/6ZVkFFWd9loKPtqSX5SYPNDJoWNh3nhQjDDONDYTbBUfd
	pLio6UdsSErKurAfTzmv3dGIacv2ZlA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=P5qtRJa7;
	spf=pass (imf27.hostedemail.com: domain of 3W0S1aQkKCA4ozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3W0S1aQkKCA4ozwqs5Cvzu22uzs.q20zw18B-00y9oqy.25u@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773487196; a=rsa-sha256;
	cv=none;
	b=yXnDdz5zYtA05TQiVE2Y6+reKZpmsHd74lllE8fvGEpihy2p/ht2rMsItKb0wJSHTCSPX7
	oyVZ8qQLa9hZVMXUvTywFO6xfxUNkSt/ZWnt0UuCqbI0GS2V2xki99ZZvdTL+6mz0v4RZM
	DJdgn+JrM3yaz6GCWrYOSdI/XLR85kc=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48531e6012bso30444025e9.1
        for <linux-mm@kvack.org>; Sat, 14 Mar 2026 04:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773487195; x=1774091995; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=V83MI+X4cH1kv5YYy8UyAToYkv5v+x2hivsQCcl9ql0=;
        b=P5qtRJa7gyte5HGFeWgFnovUvwTpvIFhNmPOZXbBqxxAKB4s1L+A0L6rDu74+MOAib
         BmV3REmJ+P3hAAmEEAWWExI9XmM4gh7YaQj3cMm1hKzhPffXNwfSRE2KIE0Dm6f5vfAX
         46mClCUIOnI7a9UVuClpBFcXYl43K5kmco5CS0PB3erZfj6oQ8gIIK4jwnEhvI05pFzC
         XXiKfifwetgk9FmmUFTgOE7tyRAzRb5d0562hLO66PYVYJKTVS6a7UtqGHDB63iBwQSp
         vWr2FR9h75iW0taopdWBkuOzVJBkG0U9F1VxYNIL0OHOz82CoPLlWSOQbnlJenMs/PN9
         SnQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773487195; x=1774091995;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V83MI+X4cH1kv5YYy8UyAToYkv5v+x2hivsQCcl9ql0=;
        b=DHE8JwTyWZB47Qd+nOL0pUDWMsJ5+naEtkZqu87pCgF94xN1LXDfqqL3d5XuW/kjMg
         cU8vYCp3uBQw7wkrav4cIFkOrQ6/P77GirY2hJvrSTsFOCJ3b6LOu4mDL84bSxeAa0Ut
         TWC2wQTxoYF9byZ6EfryFmIvJJsahTXL7Nbw5As7NmMWRZbsMyBfDQgn53IKbRvQijJ9
         am6toVj0ah5fgIEY11EtA/89AbYg2YzF3+Qm5F3GBYiZ2TldhusXgKubVVbSevkBzRHZ
         +KcSO5Kt11tlB9HTRytDQiZz3jFGJyWDAXtF8bK1DsKNwuP2K5QJzX3zXL1X80irE7ZG
         1MnA==
X-Forwarded-Encrypted: i=1; AJvYcCVHJ++6nTZbXE8cAuPdU4zKrfcMgjZZInkp9MMoKdXHL8m4IqC+DNX26DgtF7F4uz3qQwdDf/DhKw==@kvack.org
X-Gm-Message-State: AOJu0Yx5Xr35+YqarLHnpj4IPQK86GPjkWCOvU+HlfDDfy8TrpBhQoZn
	JL4DA2wW/viayd1F1p/B0GoRgKzVWmgQmnabaz6/BaDO9X3FVx72TvNw3FlALx4L3yhThhDhW62
	9OfzpJUppGOHdkIDxTw==
X-Received: from wmbe18.prod.google.com ([2002:a05:600c:5912:b0:485:37cb:adc1])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600d:8495:10b0:485:3e00:9451 with SMTP id 5b1f17b1804b1-485566fac49mr79883095e9.17.1773487195026;
 Sat, 14 Mar 2026 04:19:55 -0700 (PDT)
Date: Sat, 14 Mar 2026 11:19:51 +0000
In-Reply-To: <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
Mime-Version: 1.0
References: <CAH5fLgixE9MGXxNEnU5b0EXdgLQoTs5CMv_0OdnfCX3v=coUpw@mail.gmail.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=3874; i=aliceryhl@google.com;
 h=from:subject; bh=5aOrVoN4piYS/Amiu6IhnErIjFSEW8Pg4CtCMBPDDpc=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBptUQvenk57YLJzXb/usVxhPtRc8Xg36U+3nHLl
 FX/2l7d59eJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCabVELwAKCRAEWL7uWMY5
 RheQD/9dEzfyCuMDcej1iovP3Z5C8WazN9d6dzEloO5VxxwuODKRD2AGgleN8Ww0vch93akQD02
 +Q5zuHBihPS7xs7rIfZ1S6UU5LsSmk3mWK6GDvJUvH8PePtBWiL/nbqjJWKXNpzsp/4pBfYU7Yt
 LKatHxCLPO5zKz6niyruLuuHZAAzGQeIrxtdCoI6bd353xRNTSgG2xJlFZAojyen/0K6ui8wOeO
 0kFf9buZXjdjj+4CkiZ2DNetXxMw1Iv0KLqG7RJn27DkMVU8fP/eSRvf25X/wBfUe56ZXYkuzya
 5bRg7HNaq9ZA53KETB0oU3rdz9IyukkM//uxTOKBVqST4XZ05fudzFN5JOepnX0su9GK0N6SRnq
 PzTpmtlsPaSRAh0YOrTyQkI1fOyJWJF1uHQnaaJ8Po6cANVd0ZQ1Ke3sjkpfmj3togZjNRS6yPC
 KnkLltyxIdTqrQAgx7E+DtSFQIrrMjharuEP360I5mjNWCkvaeAf9TVvGoSqKzuIOkaU4xenWXt
 s1rr3EfpmAGfyVUne/0z8QXARf3J/vwweuYV6/jIwkKy/vUi7dJZ4fZWNeMhwaMM75dJaYWRcCk
 +66ukvunUjzKQQP6gyl8BsTjWYTOqT+1MMAlGR5z410gvivD1cvFdKTURaVzBzqqKt9pn3QUzOB MwlJ0IpFzW2PYhQ==
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260314111951.4139029-1-aliceryhl@google.com>
Subject: [PATCH] rust_binder: use AssertSync for BINDER_VM_OPS
From: Alice Ryhl <aliceryhl@google.com>
To: aliceryhl@google.com, gregkh@linuxfoundation.org
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, broonie@kernel.org, 
	dakr@kernel.org, jannh@google.com, linux-mm@kvack.org, lkp@intel.com, 
	llvm@lists.linux.dev, miguel.ojeda.sandonis@gmail.com, nathan@kernel.org, 
	oe-kbuild-all@lists.linux.dev, ojeda@kernel.org, rppt@kernel.org, 
	rust-for-linux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B598840006
X-Stat-Signature: 1j6kbyk477pf89p7rs57taanbdm6fod5
X-Rspam-User: 
X-HE-Tag: 1773487196-394968
X-HE-Meta: U2FsdGVkX1/1YkkqH/IItURWvygjQCgqzdPRkRh9IjvGz/77YG7dlvJnQ1Rbr3d7uJe3JLlhAXoSZLF8dpWrM18vlUVDnrPCc6GMFoQPl3xsMqhdDPHhAcIN/GWqPHGz2hJo7R98hZaeuja32MGCp5SZbcATirWNo0omqooGdNUev2uF/LOdUm7fkMO8Q8WaAMl6wLiIhYA2dwWV/ZAqqho4Q7ETNgrHFoYgDvs7Wn6l1nkAZv84EIDfa7XiasgNwlSz0DBTyDi5ou1hDb94fzilXdTNGzRD+4geYupzsrVy0Mvm3iB+TmLSrEsZRssxYD2gcxUxKlT4MWilyucEWRRqsuQ9UGgoRV1kGk2A0K1siwvZSfZPA/VSe11RPuU+tQ5OtffSQ9xvp64autDA6IZVYt1j/KAzCnU2x7bVq6Xwxuu76mjpGX/rwAndyD/rbUVZDsc9Vj/VUe4kRiV9mhudXIpxv2NGvBxkMhSHzbzxfQZCbPfVkZvSe7YT+gKUxEV15E9zy26uPagfc4kZV/axHFALuUF+804kpXZLQlmc7aI5e++5l1Qh9hTYkn6KnE5uIU9Z7IszBJSKPAgFntLZRhDi5KnmbggId4QaysqtjdGQoXiH1XdSKzjiqz3Db1qFzQK9b821IvUPAayeL6IqMAIhF4P3t4eVG1Qc0E3JsfJScm6fIl202WTECnhU4fAnuM7jUXRfwSl8J+XkMswJ6Lq9iVYLPsuAtzGuM7rvFcUvz1ZRmd/EO3kBbyA1j9bGso9x80WWYmmLhPpIyZogmhDMDbJoPpz98844LVy8YWQ6RbSXnIh1Xm6taYxhrNfPpCOmOh0aYfjxgfsCPbcSmWAq8J/i+JLuB2cd6aWK/C9fRRVVxu01KFA0y5ZSpQrEiBCpjxwZQEKQEaEHQNLYt9FB53gPshRh/DsDAKvyXudqodizaeutGJqcoj2wzjK6OFFXoD8ZwZdtd/D
 mMowke9S
 cvDREWtTvQlv46oDRfDt7LAmWii5ODPi163zvjcSkgXImjzVMbvxPEll/9FQyrdwz2EFcfhJR7G9Y++PV25dzviTgfF0SS+zOKcFWSCHAa/DigngGyy6bVmsVbRqfIQd1nj/rOKMV/VBPNBE6LQfVoq7ZS3b7bsYybzmhoHvRFfAuS2V61rU26KJtaOeEk1CdqBSTjpCENoxGi/nbswLnS6KZ4n9efd4vIlUUYh8+ltTRY0TGW4tu1M2VJNTSzAixjWeWHFU8H1bF4yYdkDFrjaX0UUQ/t3GihQfKsbt6A3JwpUz85hDWRcKTCyrbdvBOwLvXKht9nIYZDD8OyaQbF48Ge51jzpAr+XsQ3v0DxIEFdYhShfgtWJKyNyPi3epcKcQ1P2AHpbnYTwTaTe6+NlXPGxydOB7A0l0BgAHVXlkDq3TucxzsgUc4uEnnQYzAfY7d5E8auojKvQpRtqaq0YCYK0vq0CDG1I4pAswSDj/UuYnk93h2FjWmYXFqY365QZmpVfYZSh9XKhkq+k+fn3lxXBl8LXMOkH5aA2vSvwHCAecc2QccEP73iwVLmjFU8Xy7TT1YGbqQdTFdZ9Wzk307edA/f1dmKBo0q8Gb3z5T+1kZHsQCyI7O5S24c+YDVCtEpJRZ5DflPJzSQ72jvTz7fZtR1Vm5+2C/T07Er127XQIKSILkOx0YsUU2SGzZnko1ZZVneSd97cx5iuAXsy4VI0NJpdM3+5Og
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When declaring an immutable global variable in Rust, the compiler checks
that it looks thread safe, because it is generally safe to access said
global variable. When using C bindings types for these globals, we don't
really want this check, because it is conservative and assumes pointers
are not thread safe.

In the case of BINDER_VM_OPS, this is a challenge when combined with the
patch 'userfaultfd: introduce vm_uffd_ops' [1], which introduces a
pointer field to vm_operations_struct. It previously only held function
pointers, which are considered thread safe.

Rust Binder should not be assuming that vm_operations_struct contains no
pointer fields, so to fix this, use AssertSync (which Rust Binder has
already declared for another similar global of type struct
file_operations with the same problem). This ensures that even if
another commit adds a pointer field to vm_operations_struct, this does
not cause problems.

Fixes: 8ef2c15aeae0 ("rust_binder: check ownership before using vma")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603121235.tpnRxFKO-lkp@intel.com/
Link: https://lore.kernel.org/r/20260306171815.3160826-8-rppt@kernel.org [1]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/page_range.rs       | 8 +++++---
 drivers/android/binder/rust_binder_main.rs | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index 9dfc154e5dd4..b57e0c7ba3f1 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -13,6 +13,8 @@
 //
 // The shrinker will use trylock methods because it locks them in a different order.
 
+use crate::AssertSync;
+
 use core::{
     marker::PhantomPinned,
     mem::{size_of, size_of_val, MaybeUninit},
@@ -143,14 +145,14 @@ pub(crate) struct ShrinkablePageRange {
 }
 
 // We do not define any ops. For now, used only to check identity of vmas.
-static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
+static BINDER_VM_OPS: AssertSync<bindings::vm_operations_struct> = AssertSync(pin_init::zeroed());
 
 // To ensure that we do not accidentally install pages into or zap pages from the wrong vma, we
 // check its vm_ops and private data before using it.
 fn check_vma(vma: &virt::VmaRef, owner: *const ShrinkablePageRange) -> Option<&virt::VmaMixedMap> {
     // SAFETY: Just reading the vm_ops pointer of any active vma is safe.
     let vm_ops = unsafe { (*vma.as_ptr()).vm_ops };
-    if !ptr::eq(vm_ops, &BINDER_VM_OPS) {
+    if !ptr::eq(vm_ops, &BINDER_VM_OPS.0) {
         return None;
     }
 
@@ -342,7 +344,7 @@ pub(crate) fn register_with_vma(&self, vma: &virt::VmaNew) -> Result<usize> {
 
         // SAFETY: We own the vma, and we don't use any methods on VmaNew that rely on
         // `vm_ops`.
-        unsafe { (*vma.as_ptr()).vm_ops = &BINDER_VM_OPS };
+        unsafe { (*vma.as_ptr()).vm_ops = &BINDER_VM_OPS.0 };
 
         Ok(num_pages)
     }
diff --git a/drivers/android/binder/rust_binder_main.rs b/drivers/android/binder/rust_binder_main.rs
index aa5f2a75adb4..014010662df8 100644
--- a/drivers/android/binder/rust_binder_main.rs
+++ b/drivers/android/binder/rust_binder_main.rs
@@ -306,7 +306,7 @@ fn init(_module: &'static kernel::ThisModule) -> Result<Self> {
 /// Makes the inner type Sync.
 #[repr(transparent)]
 pub struct AssertSync<T>(T);
-// SAFETY: Used only to insert `file_operations` into a global, which is safe.
+// SAFETY: Used only to insert C bindings types into globals, which is safe.
 unsafe impl<T> Sync for AssertSync<T> {}
 
 /// File operations that rust_binderfs.c can use.

base-commit: a0b9b0f1433c845bda708753db32befef78e0f1f
-- 
2.53.0.851.ga537e3e6e9-goog


