Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF62F8FA78
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 14:20:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E603F6B008A; Tue, 21 Apr 2026 10:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11806B008C; Tue, 21 Apr 2026 10:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27E56B0092; Tue, 21 Apr 2026 10:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C5FC96B008A
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:20:16 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 745C3140EE6
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:20:16 +0000 (UTC)
X-FDA: 84682772832.23.48FAA37
Received: from mail-43170.protonmail.ch (mail-43170.protonmail.ch [185.70.43.170])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1877216000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:20:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b=bhVsUTjC;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev;
	spf=pass (imf08.hostedemail.com: domain of work@onurozkan.dev designates 185.70.43.170 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776781214; a=rsa-sha256;
	cv=none;
	b=dWyLkxBRGxTl2R56Ze6i1qskkAshDYp+XstMW23WvpehO6q78bnqCJMpspOS/5EIQqjwXb
	DizyJNliaPQT3jV+eOTrzIsy7Z/V9bK/0+MX1AtVQwmZ9xyK5aqzMdySBLMh4yuo9JG3ZN
	wx1C6WBr/2hU1Pgzf02Hii2SmdOPrdI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=onurozkan.dev header.s=protonmail header.b=bhVsUTjC;
	dmarc=pass (policy=quarantine) header.from=onurozkan.dev;
	spf=pass (imf08.hostedemail.com: domain of work@onurozkan.dev designates 185.70.43.170 as permitted sender) smtp.mailfrom=work@onurozkan.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776781214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pC2xjS4E1pQiUh4tsMMIwjbR1MJO5C9qQSohoN0KDzQ=;
	b=0Tvsq6P/X75t8/Dnlho3U/biVemYRwwJjk5BWd+/a0/BLHeSUlWV6E+RkaGOn6nl/0bwVN
	rpHU8PrkzoTayemQyveBNP/V0wRZaPFjGNyO2EyU13aZrdF2GJ1CR0s4O/Y/kI1Y7/a0cP
	xnF+ZJQgYZhb9mpv4Z3vHCuh+luA2fk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=onurozkan.dev;
	s=protonmail; t=1776781204; x=1777040404;
	bh=pC2xjS4E1pQiUh4tsMMIwjbR1MJO5C9qQSohoN0KDzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:From:To:
	 Cc:Date:Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=bhVsUTjCi/gzfIiXMhrdBlq7Ye+h2daQT4StuZ+ZgX5v2sh1LwSAOejNEDrZUhiOp
	 wdUzQpnEMQO1IuQ26Rv0IRJCH+z6e1jvIi/AR1X2YHnYEp0FMmnVy8jG4dMTt04KW4
	 Tk6kVtMIkBPvLKtbIOsiBu6L48st3NKBmJXJm+7tKyzuykKxecNCJHREffxAP5eFPC
	 /r+11U6qJMEg1+rAuqTne+8dpIKAMqxBfIooOqXowbX5WWbAXXJrOG0HSGGpCpgu67
	 QRZlmQEcnDsYdB5DT+Q2+ARFrZMtoG2SUYpQP9iPaPBZ0P1HQNJlyf0/d2I0ohqcIp
	 t3BWG++i2SDNg==
X-Pm-Submission-Id: 4g0PdC6n5Hz2ScQM
From: =?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>
To: Joel Fernandes <joelagnelf@nvidia.com>
Cc: linux-kernel@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	maple-tree@lists.infradead.org,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH RFC] rust: maple_tree: implement Send and Sync for MapleTree
Date: Tue, 21 Apr 2026 17:19:56 +0300
Message-ID: <20260421141957.22512-1-work@onurozkan.dev>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260420201040.1894760-1-joelagnelf@nvidia.com>
References: <20260420201040.1894760-1-joelagnelf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1877216000C
X-Rspamd-Server: rspam12
X-Stat-Signature: o4tcpcfr85uuid5ae7eaxw39crtzqpb5
X-Rspam-User: 
X-HE-Tag: 1776781213-623759
X-HE-Meta: U2FsdGVkX18qiseyn21UkjTwIVcfDIqAG+Kt7Sy23Da7k/f1rooymAMn3ZiMzv7EqxDpi0uw5+Bw+pfsoytepLtbsgnxLJfrFWbd1eXlCjxbh3aUMYlvguB2RXonF0s+/8xgBNQA6Ld1fgvEescNrWLE+xBbHlgkSUTiXVWUqADGuleAkw0DOFQ54x3SyuA+1ReKjvp7Cj6M5Wq91gXzrWbnaq73xNWPcBJk910ByfYzPixTPiFbGCHotWJthUlTXniwvxbVAAWRaG+G1I3AB1fnE655/rEsdovCOO3rlDuKdaJUqZTrVWataeulmbtve3IhUeCe9ShiaX20UIEurZsRawSBGQbZaexJRK4Xvd37buTAbxkLMIjmR3Lz5HGsSH5VPbj2ekf1Xrr+jAWs8xRoD2VV37hDtWUiCPUubL5RYNXJElmmK58dhSxTHMpe6zZRGSDYcrXfB+wTX1FHf/fZTDE4P47t1FDuTjDWl6fad9/Ae0Sn2drpk+RYYiMlgGoMpM24VxspJvOWmhPXGmghHOBjzsAOEKz4W0iVrLZT7p08I9Y5I/4ptSso0URR1NlGDXeTjEo/Qbj5DUN82M4n3Xs6jbBJN3A7uUM+7z3gjwRSIzssu3fhkTIUpCqZskbiepjGg8mQvJwMOck4Vvu8AozI6OdPMlXO0eeICaoH0qbehX313mHrRfz3dUKRdl9ajoeoPRmtmetwy+sd902nZ3Y++sxeMMnny0kaWJKW+RIhjrltz+iS0O+19MIJr39SKbckAqca4ofWcTRx8st3FnCLMHee4kd+srC+b5zuuDcaf5WilzU2Y1uHNuSJ3EoKEPO7d9gsBY8rVpUHmGZnCw393Gh9BYvk/BTBWbYlT6fL6mSFB14TYTvaEC9wqeFfV1s2w+ZLi0yR2LQyv5LMALD6u3vckFmEeQqYwB/+21aswGVYctg6JyFVLxRle5Uy5E95mASNaS6JiyO
 df1dVAjh
 bxJxrMx2euYf8Av4Au2PymPcCjLqZGS5K+kulGzjoyrTcLcG1Stm5gO1tMy7kcKJHSu5f7bU4mSbvGXinrbvFTO4St4SUVOfwKFy6qJrAKObjVr2capTAKH6DKNNaI7xNlnKg3u403hlJ7Xa16cJEKUdV/U4aTfeGq/eoS7Amzf1kKhboTS1VaNIVcJTJh6fAwZDMsk752QDx/51MNV6f4W9KT+KM73tCn/2N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Joel,=0D
=0D
On Mon, 20 Apr 2026 16:10:39 -0400=0D
Joel Fernandes <joelagnelf@nvidia.com> wrote:=0D
=0D
> The C maple_tree struct contains a *mut c_void, which prevents Rust from=
=0D
> auto-deriving Send/Sync.=0D
> =0D
> Following is an example error message when using MapleTree in nova-core's=
 Vmm.=0D
> =0D
> This propagates up causing NovaCore to fail the Send bound required by=0D
> pci::Driver:=0D
> =0D
>   error[E0277]: `*mut c_void` cannot be sent between threads safely=0D
>       --> drivers/gpu/nova-core/driver.rs:77:22=0D
>        |=0D
>   77   | impl pci::Driver for NovaCore {=0D
>        |                      ^^^^^^^^ `*mut c_void` cannot be sent betwe=
en threads safely=0D
>        |=0D
>        =3D help: within `MapleTreeAlloc<()>`, the trait `Send` is not imp=
lemented for `*mut c_void`=0D
>   note: required because it appears within the type `kernel::bindings::ma=
ple_tree`=0D
>   note: required because it appears within the type `Opaque<kernel::bindi=
ngs::maple_tree>`=0D
>   note: required because it appears within the type `MapleTree<()>`=0D
>   note: required because it appears within the type `MapleTreeAlloc<()>`=
=0D
>        =3D note: required for `Box<MapleTreeAlloc<()>, Kmalloc>` to imple=
ment `Send`=0D
>   note: required because it appears within the type `core::pin::Pin<Box<M=
apleTreeAlloc<()>, Kmalloc>>`=0D
>   note: required because it appears within the type `Vmm`=0D
>   note: required because it appears within the type `BarUser`=0D
>   note: required because it appears within the type `Gpu`=0D
>   note: required because it appears within the type `NovaCore`=0D
>   note: required by a bound in `kernel::pci::Driver`=0D
>       --> rust/kernel/pci.rs:294:19=0D
> =0D
> Implement Send and Sync for MapleTree to fix this.=0D
> =0D
> Signed-off-by: Joel Fernandes <joelagnelf@nvidia.com>=0D
> ---=0D
>  rust/kernel/maple_tree.rs | 27 +++++++++++++++++++++------=0D
>  1 file changed, 21 insertions(+), 6 deletions(-)=0D
> =0D
> diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs=0D
> index 265d6396a78a1..1ecf05871e710 100644=0D
> --- a/rust/kernel/maple_tree.rs=0D
> +++ b/rust/kernel/maple_tree.rs=0D
> @@ -16,7 +16,7 @@=0D
>      alloc::Flags,=0D
>      error::to_result,=0D
>      prelude::*,=0D
> -    types::{ForeignOwnable, Opaque},=0D
> +    types::{ForeignOwnable, NotThreadSafe, Opaque},=0D
=0D
We usually prefer vertical formatting e.g.,=0D
=0D
	types::{=0D
		ForeignOwnable,=0D
		NotThreadSafe,=0D
		Opaque, //=0D
	},=0D
=0D
to avoid merge conflicts as much as possible. The rest of the patch makes=0D
sense to me.=0D
=0D
-Onur=0D
=0D
>  };=0D
>  =0D
>  /// A maple tree optimized for storing non-overlapping ranges.=0D
> @@ -240,7 +240,10 @@ pub fn lock(&self) -> MapleGuard<'_, T> {=0D
>          unsafe { bindings::spin_lock(self.ma_lock()) };=0D
>  =0D
>          // INVARIANT: We just took the spinlock.=0D
> -        MapleGuard(self)=0D
> +        MapleGuard {=0D
> +            tree: self,=0D
> +            _not_send: NotThreadSafe,=0D
> +        }=0D
>      }=0D
>  =0D
>      #[inline]=0D
> @@ -302,19 +305,31 @@ fn drop(mut self: Pin<&mut Self>) {=0D
>      }=0D
>  }=0D
>  =0D
> +// SAFETY: `MapleTree<T>` is `Send` iff `T` is `Send`.  All access to th=
e tree=0D
> +// goes through the internal `ma_lock` spinlock or via `&mut MapleTree`.=
=0D
> +unsafe impl<T: ForeignOwnable + Send> Send for MapleTree<T> {}=0D
> +// SAFETY: All shared access through `&MapleTree` either acquires `ma_lo=
ck`.=0D
> +unsafe impl<T: ForeignOwnable + Send> Sync for MapleTree<T> {}=0D
> +=0D
>  /// A reference to a [`MapleTree`] that owns the inner lock.=0D
>  ///=0D
>  /// # Invariants=0D
>  ///=0D
>  /// This guard owns the inner spinlock.=0D
>  #[must_use =3D "if unused, the lock will be immediately unlocked"]=0D
> -pub struct MapleGuard<'tree, T: ForeignOwnable>(&'tree MapleTree<T>);=0D
> +pub struct MapleGuard<'tree, T: ForeignOwnable> {=0D
> +    tree: &'tree MapleTree<T>,=0D
> +    // A held spinlock must be released on the same CPU that acquired it=
.=0D
> +    // Prevent `MapleGuard` from auto-deriving `Send` because `&MapleTre=
e<T>`=0D
> +    // is `Send` due to `MapleTree<T>` being `Sync`.=0D
> +    _not_send: NotThreadSafe,=0D
> +}=0D
>  =0D
>  impl<'tree, T: ForeignOwnable> Drop for MapleGuard<'tree, T> {=0D
>      #[inline]=0D
>      fn drop(&mut self) {=0D
>          // SAFETY: By the type invariants, we hold this spinlock.=0D
> -        unsafe { bindings::spin_unlock(self.0.ma_lock()) };=0D
> +        unsafe { bindings::spin_unlock(self.tree.ma_lock()) };=0D
>      }=0D
>  }=0D
>  =0D
> @@ -323,7 +338,7 @@ impl<'tree, T: ForeignOwnable> MapleGuard<'tree, T> {=
=0D
>      pub fn ma_state(&mut self, first: usize, end: usize) -> MaState<'_, =
T> {=0D
>          // SAFETY: The `MaState` borrows this `MapleGuard`, so it can al=
so borrow the `MapleGuard`s=0D
>          // read/write permissions to the maple tree.=0D
> -        unsafe { MaState::new_raw(self.0, first, end) }=0D
> +        unsafe { MaState::new_raw(self.tree, first, end) }=0D
>      }=0D
>  =0D
>      /// Load the value at the given index.=0D
> @@ -375,7 +390,7 @@ pub fn ma_state(&mut self, first: usize, end: usize) =
-> MaState<'_, T> {=0D
>      #[inline]=0D
>      pub fn load(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {=
=0D
>          // SAFETY: `self.tree` contains a valid maple tree.=0D
> -        let ret =3D unsafe { bindings::mtree_load(self.0.tree.get(), ind=
ex) };=0D
> +        let ret =3D unsafe { bindings::mtree_load(self.tree.tree.get(), =
index) };=0D
>          if ret.is_null() {=0D
>              return None;=0D
>          }=0D
> -- =0D
> 2.34.1=0D
> =0D

