Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C82A606A331
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W3RPzRlF
Received: by kanga.kvack.org (Postfix)
	id 692276B05B3; Fri, 20 Nov 2026 05:27:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6421D6B05B4; Fri, 20 Nov 2026 05:27:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50ABF6B05B5; Fri, 20 Nov 2026 05:27:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 205FC6B05B3
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:27:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A1CF0C0E57
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:54 +0000 (UTC)
X-FDA: 85455121668.20.022E29E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id E8145C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3RPzRlF;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170473;
	b=YoroCZfpOwTvrJkgDFItYTyrhX3n/hAHycKPctCTq9ras7xGlK0wqJIsJ+SfvABlnTSlEH
	9ZlCTwNmtxoczXcT3Dj3dYn9tZmim3weKme47sekHqD/4XTBTifhkzMtZBPj29peh8ETKI
	DBPEuUhNKYVwrvtw42rY545pbzQnjQY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RzWDhrGM5NrB5lDNzvg/wfHe5aGooBflQp0rDAqcEk8=;
	b=3HuWPp3GR7NHX804ON1MzjKL+objTkFP3/+DoqTQAF96Q/5WS2BeNB76LvCD8SXwwyDads
	sdwDSbFCerqHZMN8KxU2bIJubsfLef5M2gzxQjJJostZc6WfVibJ0y/Az35qITYLArgpub
	S25C9iZyCRRT8H5Q/pH4PmgWmWKPMEU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W3RPzRlF;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7A839625EC;
	Fri, 20 Nov 2026 10:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA741F000C4;
	Fri, 20 Nov 2026 10:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170471;
	bh=RzWDhrGM5NrB5lDNzvg/wfHe5aGooBflQp0rDAqcEk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=W3RPzRlFPXO6zlJeH5iLzcSETs4PmRI5EX9huQyA4P89AbuI7VmsEYla8hMcMkgW6
	 aRy4Jt5UMqTulGWzcTL2Z+LvppZkkLxmeCl/mldMyZaMCWOBbc3lD/yu9pZ60WIuJt
	 J93fRsEHL/fgBF4yVM3Wn6bDVvAtThfKZ+qafusqDdcJdxcekC1ezbX1Kvl0JOzspm
	 obFmeYDj3oepDzWRrqJOCQRp2kKAF/VWQkRVilRJLNvICald/AorqK5zX9zalbcfGj
	 N18c6JM7jhWdcnbVigWwgcpeAS9OjoAPxFrihojE43oPDtrfBppi8F3I2R8tffPo38
	 p/vtlXhAOYEtw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:07 +0100
Subject: [PATCH 08/11] rust: io: add `SysMemLocal`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-8-66f8c4c62822@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=10259;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=Hy/JlmHOtXCp0mfYwa6Fngk34dvnrvGrw3dkESIeGcM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCI+CBxmntfaiYVXg6tR3+BZ1SUbNmb0+0VG
 bXpxEzPJdSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAgiAAKCRD6UCkIqsW9
 0Lr4D/wNe4RU+MOkb+ftCSPKwlQBchBO/QYx/V3eSPzRHomw9HEHAql9/OTATAfdYZ6ZRul6IX6
 SFshT08dhnrMf4JOpOhPO3njCd2z9UQ+QaJfXSISA/nZkDW/xwenjhuXyBQaK3lTccknihcIGf0
 2rZoDtJGeGylX5A/XdCKfqFiGy8tFFl2LjG03ik8c3zp2P6MQbuJiRuD7Q20wHH62Zv5uyCI8D+
 3is8n1DDKYDJek98Z3+tK7x3kz7bFTn30XEltWAwkHZc5d2dyLwH40xvHcmhqgHwHmQ/KKaecoT
 scn3EbiyHYkuWNFGlk/O/wBU9NajokanuY6GKMe3Cep6GXaF8Zacr+fYeEkBB77CGOItKKYmgC5
 cfAjAAZKdNr93MVmAOCforoW2tTI/dnIE2htzOsZf1c9qaJQmu0AaiC6Py5D/DwmHaDfKhOqNZL
 RQofTyZAhuKtgz4kaA/h100SnfrtLYbfp1Yzvd3ZyBpGcBJQJc6fwodY0CcIUsWZ347cc7pgFNY
 BGjI6ZI8WmChkpI99P9jm7EyjyQsDGOSeqJGaolLgI7U7uQwcQbqm45Dfs2U175lj8krgmBoZMX
 G5/ulkIPyH3EHADDmfEbACvqAOZawTvdNJ5uIzdIJWy8YZyE/AUbpgqxynn3Ej6PigoqXGfcVXI
 otksdxnH3y+aWHA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Stat-Signature: 84ho557kzshy33jwxctgsxqjfd4r74wq
X-Rspamd-Queue-Id: E8145C0004
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795170472-442076
X-HE-Meta: U2FsdGVkX19lFx9FJ/pMV+1d5Kexkcg1UeO4zw+sJL6m8rDJIHplenemRH1EfRCje8YAEy5IuVS6pJ3WsYqfdjgc9O62sE0Kt5ab9vSgon5M6CA6RE9yDKoUu0bFc4E4GusekJH+hm4uM7FYovuny1DmdYIeYi91L0WvSRIPp0cIQmgsmHvga08+C1f0h59BRajU5LFN2MqIVVxsTGScG8Twp6A+xhQ/m1dL1xDFczlsxwsBX+WoBXTNxh7PpAilsl92Z6/3GOpaCTfxp/H8bSXF6f4OWKveJgIaxENBr6kXKSbOTPWMoXb7rC6pt3kWUmwxUlsACiDaO/Kct3BBNLPi6LH8T5HihI/rq1nY3kZsiHwhTR9fx3EGrrpBTSED1ssrdKCeh1Ly/+rZa9oBS06XQQuePNdCHGRkQiOTi6k67JaXVOrQf4KYwUSLvRNqwwm1bc0DqBoqofdOvIVkdRG4oaKCm7hwuuw6X9dSlmFuTMPR6gOIjrHtsyEsxaH8MKv1GAyM2pdFTcPA9SOW5gtRVyLjB0e7oekb4nvHIKXY0m+bZO1vrScU5ZYgBbkhTXbHMIOxn2v4lK9mQFDPme8omRznqvRiheUn7tUUj0A+3X0IswwMBhYKq1svQhPcKiXBB41Hb4AO0ixkMDn0Q81DtDyF/IE2HQ3v8P7kef5h33h/8zm8Didw0MYkVwI0r9K76xP+17LZaJpPUsBtxjxYf3mfFNzD8CjtDtE89ZpFyKIamuEaFueWy34V7HeZCv+6eSXOAmR6ydVK6qefPiZII7eWcgIGWTCrxWsAfnlVRzdu4g41z61V20HE0tQBGAWEoDa6P6DKJEEDDGPNGCAvi4OfsJdSiKA2itbT8dEHODR2o53kLptMqzfnwduSqQtPKfT+irNGwmwhB50uvfG/5vhhaImbOEs82XCAomgTMabj7mxRdO0kyXSo72sm0bEXF0xIKNxNJmBAnkJ
 9YKhLvOu
 j4mJpICFdokYxyno4c58vWvC+kJk0VQIgML6wamxCHlWHATIew02rl/fr/+F458SdsZDz40f9011nHuo/9AY+TFybkFtdHWfkCVbHrOS63sHLK/sxoLL3VUwoSIVwIjpTjZsrObwWEMgpwExCcHcSNFjezr+Wy9jwunTOF8hnth74zE+VJMMJS7cwI0OvWY7JB7DsANgqufPyfyG3Zr7PC2f7JQnm85bzhTqYaflOQer8n6cQ2q3YVdfiBQ5TGCssgDplqP72Om9ZbqFuzW9JvG3AeGVcedjBzjnicAMY6iH2sU71+TSTUuo9ZlOpfQlTxer/WLmRRupzz3c/OqHK8Y7xP+z3LRtm4itSaOB2D/YFc6iQc69+T7XSW+V3ab+yKjct9GSvq8PSa0msEnPwGNcD94GLzaPMGFCxdkbX6HM2YJWJHWIf9LCpPkcyotoATSQEO3kAXujisqhr4di8bjci9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A `SysMem` view is `Send` and `Sync`. Thus, it cannot safely represent
memory that is only accessible to the current task, such as a page that is
mapped with a mapping that is local to the current task.

Make `SysMem` and `SysMemBackend` generic over a new marker trait
`SysMemScope`, with the scopes `AnyTask` and `CurrentTask`. `AnyTask` is
the default, so existing users are not affected. Only a `SysMem` of the
scope `AnyTask` is `Send` and `Sync`. All other functionality is shared
between the scopes.

Add the alias `SysMemLocal` for a `SysMem` of the scope `CurrentTask`,
together with the constructor `SysMemLocal::new_local()` and a conversion
from a `SysMem` of the default scope.

Make `SysMem::fill_zero()` and `UserSliceReader::read_sysmem()` available
for a byte view of any scope.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/io.rs      | 142 ++++++++++++++++++++++++++++++++++++++++++-------
 rust/kernel/uaccess.rs |   4 +-
 2 files changed, 125 insertions(+), 21 deletions(-)

diff --git a/rust/kernel/io.rs b/rust/kernel/io.rs
index 33cb5a9fb3a8..1496735c08a2 100644
--- a/rust/kernel/io.rs
+++ b/rust/kernel/io.rs
@@ -1436,11 +1436,41 @@ pub fn relaxed(self) -> RelaxedMmio<'a, T> {
 #[cfg(CONFIG_64BIT)]
 impl_mmio_io_capable!(RelaxedMmioBackend, u64, readq_relaxed, writeq_relaxed);
 
+mod private {
+    pub trait Sealed {}
+}
+
+/// Marker trait for the scopes of a [`SysMem`].
+///
+/// The scope of a [`SysMem`] describes which tasks the view can be used on. See [`AnyTask`] and
+/// [`CurrentTask`].
+pub trait SysMemScope: private::Sealed {}
+
+/// The default [`SysMemScope`]: the view can be used on any task.
+///
+/// A [`SysMem`] of this scope is [`Send`] and [`Sync`] when its target is [`Sync`].
+pub enum AnyTask {}
+
+impl private::Sealed for AnyTask {}
+impl SysMemScope for AnyTask {}
+
+/// A [`SysMemScope`] for a view that can only be used on the task that created it.
+///
+/// This is the scope of a view whose memory is only accessible to the current task, such as a
+/// view that is backed by a mapping that is local to the current task. A [`SysMem`] of this scope,
+/// that is, a [`SysMemLocal`], is neither [`Send`] nor [`Sync`].
+pub enum CurrentTask {}
+
+impl private::Sealed for CurrentTask {}
+impl SysMemScope for CurrentTask {}
+
 /// I/O Backend for system memory.
-pub struct SysMemBackend;
+///
+/// The backend is generic over the [`SysMemScope`] of its views.
+pub struct SysMemBackend<S: SysMemScope = AnyTask>(PhantomData<S>);
 
-impl IoBackend for SysMemBackend {
-    type View<'a, T: ?Sized + KnownSize> = SysMem<'a, T>;
+impl<S: SysMemScope> IoBackend for SysMemBackend<S> {
+    type View<'a, T: ?Sized + KnownSize> = SysMem<'a, T, S>;
 
     #[inline]
     fn as_ptr<'a, T: ?Sized + KnownSize>(view: Self::View<'a, T>) -> *mut T {
@@ -1466,9 +1496,9 @@ unsafe fn project_view<'a, T: ?Sized + KnownSize, U: ?Sized + KnownSize>(
 /// `write_volatile`.
 macro_rules! impl_sysmem_io_capable {
     ($ty:ty) => {
-        impl IoCapable<$ty> for SysMemBackend {
+        impl<S: SysMemScope> IoCapable<$ty> for SysMemBackend<S> {
             #[inline]
-            fn io_read(view: SysMem<'_, $ty>) -> $ty {
+            fn io_read(view: SysMem<'_, $ty, S>) -> $ty {
                 // SAFETY:
                 // - Per type invariant, `ptr` is valid and aligned.
                 // - Using read_volatile() here so that race with hardware is well-defined.
@@ -1480,7 +1510,7 @@ fn io_read(view: SysMem<'_, $ty>) -> $ty {
             }
 
             #[inline]
-            fn io_write(view: SysMem<'_, $ty>, value: $ty) {
+            fn io_write(view: SysMem<'_, $ty, S>, value: $ty) {
                 // SAFETY:
                 // - Per type invariant, `ptr` is valid and aligned.
                 // - Using write_volatile() here so that race with hardware is well-defined.
@@ -1499,7 +1529,7 @@ fn io_write(view: SysMem<'_, $ty>, value: $ty) {
 #[cfg(CONFIG_64BIT)]
 impl_sysmem_io_capable!(u64);
 
-impl IoCopyable for SysMemBackend {
+impl<S: SysMemScope> IoCopyable for SysMemBackend<S> {
     #[inline]
     unsafe fn copy_from_io(view: Self::View<'_, [u8]>, buffer: *mut u8) {
         // SAFETY:
@@ -1562,31 +1592,103 @@ fn copy_write<T: IntoBytes>(view: Self::View<'_, T>, value: T) {
 /// Accesses performed by hardware or by user space are not plain accesses in this sense. Racing
 /// with them is well-defined, but the data observed may be arbitrary.
 ///
+/// A `SysMem` is generic over a [`SysMemScope`], which describes the tasks that the view can be
+/// used on. A view of the default scope [`AnyTask`] can be sent to and shared with other tasks. A
+/// view of the scope [`CurrentTask`], a [`SysMemLocal`], cannot leave the task that created it.
+/// Apart from that, the two are identical.
+///
 /// # Invariants
 ///
 /// - `self.ptr.addr() .. self.ptr.addr() + KnownSize::size(self.ptr)` is valid and aligned kernel
-///   accessible memory region for the lifetime `'a`.
+///   accessible memory region for the lifetime `'a`. For a view of the scope [`CurrentTask`],
+///   this holds on the task that created the view.
 /// - No plain access to that memory region races with an access performed through this view.
-pub struct SysMem<'a, T: ?Sized> {
+pub struct SysMem<'a, T: ?Sized, S: SysMemScope = AnyTask> {
     ptr: *mut T,
-    phantom: PhantomData<&'a ()>,
+    phantom: PhantomData<(&'a (), S)>,
 }
 
-impl<T: ?Sized> Copy for SysMem<'_, T> {}
-impl<T: ?Sized> Clone for SysMem<'_, T> {
+/// A view of a system memory region that can only be used on the task that created it.
+///
+/// This is a [`SysMem`] that is neither [`Send`] nor [`Sync`]. It is used for memory that is only
+/// accessible to the current task, such as a page that is mapped with a mapping that is local to
+/// the current task.
+///
+/// A [`SysMem`] of the default scope converts to a `SysMemLocal` with [`From`].
+///
+/// # Examples
+///
+/// ```
+/// use kernel::io::{
+///     Io,
+///     SysMem,
+///     SysMemLocal, //
+/// };
+///
+/// let mut data = [0u8; 4];
+///
+/// // SAFETY: `data` is valid for the lifetime of `mem`, and it is not accessed in any other way
+/// // while `mem` is alive.
+/// let mem = unsafe { SysMem::new(&raw mut data as *mut [u8]) };
+/// let local = SysMemLocal::from(mem);
+///
+/// local.copy_from_slice(&[1, 2, 3, 4]);
+/// local.fill_zero();
+///
+/// let mut buf = [0xffu8; 4];
+/// local.copy_to_slice(&mut buf);
+/// assert_eq!(buf, [0u8; 4]);
+/// ```
+pub type SysMemLocal<'a, T> = SysMem<'a, T, CurrentTask>;
+
+impl<T: ?Sized, S: SysMemScope> Copy for SysMem<'_, T, S> {}
+impl<T: ?Sized, S: SysMemScope> Clone for SysMem<'_, T, S> {
     #[inline]
     fn clone(&self) -> Self {
         *self
     }
 }
 
-// SAFETY: `SysMem<'_, T>` is conceptually `&T`.
-unsafe impl<T: ?Sized + Sync> Send for SysMem<'_, T> {}
+// SAFETY: `SysMem<'_, T>` is conceptually `&T`. A view of the scope `AnyTask` can be used on any
+// task.
+unsafe impl<T: ?Sized + Sync> Send for SysMem<'_, T, AnyTask> {}
 
-// SAFETY: `SysMem<'_, T>` is conceptually `&T`.
-unsafe impl<T: ?Sized + Sync> Sync for SysMem<'_, T> {}
+// SAFETY: `SysMem<'_, T>` is conceptually `&T`. A view of the scope `AnyTask` can be used on any
+// task.
+unsafe impl<T: ?Sized + Sync> Sync for SysMem<'_, T, AnyTask> {}
 
-impl SysMem<'_, [u8]> {
+impl<'a, T: ?Sized> From<SysMem<'a, T>> for SysMemLocal<'a, T> {
+    #[inline]
+    fn from(value: SysMem<'a, T>) -> Self {
+        // INVARIANT: By the type invariant of `value`, the memory region is valid on all tasks,
+        // and no plain access races with an access through a view of it.
+        Self {
+            ptr: value.ptr,
+            phantom: PhantomData,
+        }
+    }
+}
+
+impl<'a, T: ?Sized> SysMemLocal<'a, T> {
+    /// Create a `SysMemLocal` from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// - `ptr.addr() .. ptr.addr() + KnownSize::size(ptr)` must be valid and aligned kernel
+    ///   accessible memory region on the current task for the lifetime `'a`.
+    /// - No plain access (see [`SysMem`]) to that memory region may race with an access performed
+    ///   through the returned view.
+    #[inline]
+    pub unsafe fn new_local(ptr: *mut T) -> Self {
+        // INVARIANT: Per safety requirement.
+        Self {
+            ptr,
+            phantom: PhantomData,
+        }
+    }
+}
+
+impl<S: SysMemScope> SysMem<'_, [u8], S> {
     /// Writes zeroes to all bytes of the view using byte-wise atomic operations.
     #[inline]
     pub fn fill_zero(self) {
@@ -1614,7 +1716,9 @@ pub unsafe fn new(ptr: *mut T) -> Self {
             phantom: PhantomData,
         }
     }
+}
 
+impl<T: ?Sized, S: SysMemScope> SysMem<'_, T, S> {
     /// Obtain the raw pointer to the memory.
     #[inline]
     pub fn as_ptr(self) -> *mut T {
@@ -1622,8 +1726,8 @@ pub fn as_ptr(self) -> *mut T {
     }
 }
 
-impl<'a, T: ?Sized + KnownSize> IoBase<'a> for SysMem<'a, T> {
-    type Backend = SysMemBackend;
+impl<'a, T: ?Sized + KnownSize, S: SysMemScope> IoBase<'a> for SysMem<'a, T, S> {
+    type Backend = SysMemBackend<S>;
     type Target = T;
 
     #[inline]
diff --git a/rust/kernel/uaccess.rs b/rust/kernel/uaccess.rs
index 313479d80834..6956a7cc519a 100644
--- a/rust/kernel/uaccess.rs
+++ b/rust/kernel/uaccess.rs
@@ -11,7 +11,7 @@
     error::Result,
     ffi::{c_char, c_void},
     fs::file,
-    io::SysMem,
+    io::{SysMem, SysMemScope},
     prelude::*,
     ptr::KnownSize,
     transmute::{AsBytes, FromBytes},
@@ -315,7 +315,7 @@ pub unsafe fn read_raw(&mut self, out: *mut u8, len: usize) -> Result {
     ///     reader.read_sysmem(mem)
     /// }
     /// ```
-    pub fn read_sysmem(&mut self, out: SysMem<'_, [u8]>) -> Result {
+    pub fn read_sysmem<S: SysMemScope>(&mut self, out: SysMem<'_, [u8], S>) -> Result {
         let out = out.as_ptr();
 
         // SAFETY: By the type invariant of `SysMem`, the memory of `out` is valid for writing

-- 
2.54.0



