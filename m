Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF3260A261C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cGww4jVD
Received: by kanga.kvack.org (Postfix)
	id 356B66B0145; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E066B0147; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DA06B0146; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB2AC6B0140
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E0D5140873
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:53 +0000 (UTC)
X-FDA: 85342321386.12.274E1D4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5EA2EC0003
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGww4jVD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484751;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X1v+rBe06/PEaYZD/NoqJbiVA1RXIelDes9+w3NiFbM=;
	b=gS4oRD1f9jGamK3hrtaeuoiwp7DjkE9mFguwrXiQf3hCLjp9xBJP/kIQyGZ9S0XmyibyVg
	r3QZr//gJuKolT6r43OimwVuNb7M7cyfp9CmvyOpiD+/0jRVT9R4PKoyuYOyWXb2+KS+GY
	EgxQsDGfedupwCmOkniwCoz5NwmN5Uk=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cGww4jVD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf22.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484751;
	b=eH3BYkSRAbWnb5on2SyxLH1WhED0PqAs8/9l2bfVVlcchZVe3uPMWnvXS5Ku4MGSZNcmCv
	uKYKAOdfAZf0L7bfBXuFgsfuy8HhXHCpCRlV8KNJSAmbEkKIGZZlRGBOpifZTcytLkRCjo
	FAeeLCPLYcYG/L+XL7hK1Cb/eCNvJxY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9851043CAA;
	Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484750;
	b=QU5tw2ZTpdYSOuuQbQC6Ryj+B+tW8NEnEeyKKVNG3+p/q9DtNuNLyn0D+tLScnjGJbuY
	 YM5TGkDRrZTyarD9XlW5mhcp6HKNzaKug3IEHiKILUlu2CvDDsK5VfLmFBaQhTIUlum3+
	 9Kr4RioXA39kH06FYhPtCExzNf+cHRSbG43y/6WdjRS9sEDz5qhLgG5tCSO56hawIj3ZX
	 Nfz7YjObatNdrP8yzfXxG/8gIhpEYDPMhmXhnlJUQI0VQJXly6CUlQcwq16+u0qHjdVEz
	 wldTwLr9UFYubVg7NPMGFDQudK1DhDhCG80Ym2hh0Ies42eTtBwCaZvWLPw3CMPRLlQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484750;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=X1v+rBe06/PEaYZD/NoqJbiVA1RXIelDes9+w3NiFbM=;
	b=Fd2eKisK4pXxZA+p5w0MvvxLQieAoZihU2TdxzQag91B8iDtpC2HKzqeWXlP9KR1p0K3
	 q5fjDe7NQjuDLThscpzQ8P+1zHzsL0OKox8BY4WQj/cioPJqr88DRRkbhRsB5A05F/QoD
	 dtkyIgKj5pdrglLFr7r301oPrEqZQQBWzjgq3dyHwQAByg6QMmZUj5ErNwEcCoNRN1Fvy
	 Hff/ItyPrTiTgudnHFsxVWajekx9aLy53LiTjbOazkP9vLBEC20ovLZwClVL5OI3JWthB
	 3DlzS3KjM23iaFlVt6ZTXHowdd0thno0dcHOxXJiBDeTCLxyHe5IqinKSbOUq5N3idw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 049441F000CC;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484750;
	bh=X1v+rBe06/PEaYZD/NoqJbiVA1RXIelDes9+w3NiFbM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cGww4jVDufxY8Obe5EXR3b4LbHqJ9gALrFQrnZxF0SVvhuzsrWfAHkuTujM8pFvUg
	 ol8e2FPUCjuoqFIaqdE2qwNDCHxuh32NmdGbv37ROseVk7sCrfVjJOtvN4awBw+I53
	 apCls2xnNNnxfML65dU9d6DotekIYYuFSX090jXERX+x7l4rLdTFsD7e4MBw/FZPwU
	 W+Awv72zJq4UKNSbh/WsWtQNxfMbdhgHP7CVJaB6n1nJ76pEPScuc3/1byfcoeP2Nw
	 HvnbuXT4G6DoIprie9AHJbwYf2aud92MIGU3KOfp7e2JQn4rvM12COqUFo3dTLy/5K
	 ohhG27u+q649g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D08CC430EB;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:24 +0800
Subject: [PATCH v4 07/11] drm/tyr: add VM-related ioctls
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-7-704de77da223@kylinos.cn>
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
In-Reply-To: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=20563;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=xtgTQLaSxoLDsy/gVs3afH5fofCLPiC58hbLzUeV3/U=;
 b=IT3g/L6fo0r7npG8GTqi3KoIxn7Xmpk6dv7SbJoRzSDtqhkioWeEUdBKCh7khFlNPmMuJDzhi
 YuahFo/C3OLD1fSj/rjCNSqrqxuqZIL4pe0GiFMmVQZ/M+v4WwLl2bC
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5EA2EC0003
X-Stat-Signature: z7rnwu7ipsmpf6q96uzg7bmbnzhc9z3m
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484751-530105
X-HE-Meta: U2FsdGVkX1+FmWYH1jooqeqEELsw+s6sM9VPNyayLHJQBltzwmBxMUws201qslpHDkY+NM+c/qTvPUJ9B9R/YbFSOeVRvZP8OMcIxH6rgdJlTUI3mjeoN1bWEplsRc8ugo7fGwRcJIgSpzdqkM2/qNHAnIIcnsUCfw6Bqw72JN8E0YU9fIi/7Hbk5nca75L0alAJLHCXDi/K+WB0fUz++yk+sqoFO+/XFv9d5TdRJQ7sXdUu9MPAxiRRN6vmdZqwMMsn3cj4niO8sgKbZPB0dES9HvAuVeBidOj3V1KhF/E6WRP08G+TXlGQxD1fXB3Zy1+tmVnVg3UWe+mPyzc+5Z1Vmmuma6yh6QwF3gSiZYbToMrpvjzBLZm5eDzJCwjyrEu2/BWO3CSQmcRQgZdLiDWQd1Ul7/J+cKmBdyepb+5pB8IkXfiLTZaMWd1Q8hUe/3bZyVU0Wu+MH7QM0iEuwjwEgBNeoAj9w+YYnJRmUxr4awCJO4uAkf7O0dJwpgTBDVJOUo6ZUI9IGuXo6KO6rSSiQ7HZAcpEkhOzNbvDDhi8rxazGKw4Ixfse9+3m4TZ+JJKbbherrTwosR9tNnFflQ/aVxkHBYj4lAuPu+54PDr9SCNwfAQDw2Ank8Re1ecBwuQvxK/pWKNKYuubxeld5ZBnxk0BzrbHmxJATJtpXUPKrmL68b4al0piuDDIAedK7lf3T9gzdGg8zoC/aFiSz2lkhBRmG8OxSq1sVneEIfTGneM/BhNojFWzBmCPSFaW6xYV3fH9SXW/dQnyihAuYU4pbWyq+ZPiPehN+Nv4d1nLXAcy24uazTFwwco/HiBMHgtug/NRaIriISFgtuiwFDH5sJ30Q9rRsAsoZ7XRN0FCa13W9rjQATkpwSuB19Dw6VIFEPeo5O6hpBZmd3KI3fr5H1YUaZSnj9L/g8HAlC4kAMeAF8UebYe5bg5EZClcG+U9a2rl2QORfwC8xP
 BU6RJIgS
 iQeJHLexhUtUMmgAaWO7apd1HE40KNJUl323k/X+DisXYXIMjzFdokXT/Pgildub9D69kTGe56R1hakmMhsxwJ/TZa7csOIiO8gBwR1cwbaJi8D6nsJAfyu6RZPR6/3b3u3KoPfOiVyN03wZ56VGRsxwNDv5J7IeU83jdzoXDkodkEumUKf6EMBs/hv695PQZQjS6rhTueCFNcd669h3GsPuFPXM1pylQgfeOHRYlinZXhx12sNR7WZ7NJopx8HZJteLd+6PIF9mw6orfpw5jxEpdf+zkgohbM9ragJCkUlTkeFm3l1Wc3grnYfv30sbvOYxrKu1V4bLFJ3FTyEvbjixI0i2CK5fM9LKWjj6wbT5TD9qBL1SxyREWLdnjUrx6T53MhORJIBFHR9BoHKR2IGkb3dTW2gY53E8H7NGVffgRs1PSb7SREp98405+RMmF9xZ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

Implement VM_CREATE, VM_DESTROY, VM_BIND and VM_GET_STATE. VM_CREATE
hands the new VM to the per-file pool and, on insertion failure, the
caller tears it down, so an aborted creation never leaks a VM.
VM_DESTROY removes the VM from the pool and kills it, even if in-flight
jobs still hold references (matching panthor: such jobs are expected
to fault). VM_BIND runs synchronously for now.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs |  12 +-
 drivers/gpu/drm/tyr/file.rs   | 320 ++++++++++++++++++++++++++++++++++++++++--
 drivers/gpu/drm/tyr/gem.rs    |   1 -
 drivers/gpu/drm/tyr/vm.rs     |  67 ++++++++-
 4 files changed, 381 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index e2b6d63491b91..c0f17bc4ce2c9 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -33,7 +33,7 @@
         Mutex, //
     },
     time,
-    types::CovariantForLt, //
+    types::ForLt, //
 };
 
 use crate::{
@@ -74,6 +74,9 @@ pub(crate) struct TyrDrmRegistrationData<'drm> {
     /// Firmware sections.
     pub(crate) fw: Firmware<'drm>,
 
+    /// Memory management unit for address space slots.
+    pub(crate) mmu: Arc<Mmu<'drm>>,
+
     #[pin]
     clks: Mutex<Clocks>,
 
@@ -172,6 +175,7 @@ fn probe<'bound>(
                     pin_init!(TyrDrmRegistrationData {
                         pdev,
                         fw: firmware,
+                        mmu,
                         clks <- new_mutex!(Clocks {
                             core: core_clk,
                             stacks: stacks_clk,
@@ -210,7 +214,7 @@ fn drop(self: Pin<&mut Self>) {}
 impl drm::Driver for TyrDrmDriver {
     type Data = ();
     type RegistrationData<'drm> = TyrDrmRegistrationData<'drm>;
-    type File = CovariantForLt!(TyrDrmFileData);
+    type File = ForLt!(TyrDrmFileData<'_>);
     type Object = Bo;
     type ParentDevice<Ctx: DeviceContext> = platform::Device<Ctx>;
 
@@ -219,6 +223,10 @@ impl drm::Driver for TyrDrmDriver {
 
     kernel::declare_drm_ioctls! {
         (PANTHOR_DEV_QUERY, drm_panthor_dev_query, ioctl::RENDER_ALLOW, TyrDrmFileData::dev_query),
+        (PANTHOR_VM_CREATE, drm_panthor_vm_create, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_create),
+        (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
+        (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
+        (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
     }
 }
 
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 933a365cb016e..22a74b4abf3de 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -1,39 +1,64 @@
 // SPDX-License-Identifier: GPL-2.0 or MIT
 
+use core::mem::offset_of;
+
 use kernel::{
     drm::{
         self,
+        gem::BaseObject,
         Registered, //
     },
     prelude::*,
-    uaccess::UserSlice,
+    sizes::SizeConstants,
+    transmute::FromBytes,
+    uaccess::{
+        UserSlice,
+        UserSliceReader, //
+    },
     uapi, //
 };
 
-use crate::driver::{
-    TyrDrmDevice,
-    TyrDrmDriver,
-    TyrDrmRegistrationData, //
+use crate::{
+    driver::{
+        TyrDrmDevice,
+        TyrDrmDriver,
+        TyrDrmRegistrationData, //
+    },
+    vm::{
+        UserVaRequest,
+        Vm,
+        VmBindOpType,
+        VmMapFlags,
+        VmPool, //
+    }, //
 };
 
 #[pin_data]
-pub(crate) struct TyrDrmFileData {}
+pub(crate) struct TyrDrmFileData<'a> {
+    reg: &'a TyrDrmRegistrationData<'a>,
+
+    #[pin]
+    vm_pool: VmPool<'a>,
+}
 
 /// Convenience type alias for our DRM `File` type.
 pub(crate) type TyrDrmFile = drm::file::File<TyrDrmDriver>;
 
-impl drm::file::DriverFile<'_> for TyrDrmFileData {
+impl<'a> drm::file::DriverFile<'a> for TyrDrmFileData<'a> {
     type Driver = TyrDrmDriver;
 
     fn open(
         _device: &TyrDrmDevice<Registered>,
-        _reg_data: &TyrDrmRegistrationData<'_>,
+        reg_data: &'a TyrDrmRegistrationData<'a>,
     ) -> impl PinInit<Self, Error> {
-        Ok(Self {})
+        try_pin_init!(Self {
+            reg: reg_data,
+            vm_pool <- VmPool::new(reg_data.pdev.as_ref()),
+        })
     }
 }
 
-impl TyrDrmFileData {
+impl TyrDrmFileData<'_> {
     pub(crate) fn dev_query(
         _ddev: &TyrDrmDevice<Registered>,
         reg_data: &TyrDrmRegistrationData<'_>,
@@ -65,4 +90,279 @@ pub(crate) fn dev_query(
             }
         }
     }
+
+    pub(crate) fn vm_create(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmcreate: &mut uapi::drm_panthor_vm_create,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        if vmcreate.flags != 0 {
+            dev_dbg!(
+                ddev.as_ref(),
+                "Invalid VM create flags: {:#x}\n",
+                vmcreate.flags
+            );
+            return Err(EINVAL);
+        }
+
+        let ret: Result<u32, Error> = file.inner_with(|pfile| {
+            let vm = Vm::new_for_user(
+                pfile.reg.pdev.as_ref(),
+                ddev,
+                pfile.reg.mmu.as_arc_borrow(),
+                &pfile.reg.gpu_info,
+                UserVaRequest::from_uapi(vmcreate.user_va_range),
+            )?;
+            let user_va_range = vm.layout.user.end;
+            let id = pfile.vm_pool.add(vm).map_err(|e| {
+                e.vm.kill();
+                e.error
+            })?;
+            vmcreate.user_va_range = user_va_range;
+            vmcreate.id = id;
+
+            Ok(0)
+        });
+        ret
+    }
+
+    pub(crate) fn vm_destroy(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmdestroy: &mut uapi::drm_panthor_vm_destroy,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        if vmdestroy.pad != 0 {
+            dev_dbg!(
+                ddev.as_ref(),
+                "Invalid VM destroy pad: {:#x}\n",
+                vmdestroy.pad
+            );
+            return Err(EINVAL);
+        }
+
+        let ret: Result<u32, Error> = file.inner_with(|pfile| {
+            pfile.vm_pool.remove(vmdestroy.id)?;
+            Ok(0)
+        });
+        ret
+    }
+
+    pub(crate) fn vm_bind(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmbind: &mut uapi::drm_panthor_vm_bind,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        let async_flag = uapi::drm_panthor_vm_bind_flags_DRM_PANTHOR_VM_BIND_ASYNC;
+
+        if vmbind.flags & !async_flag != 0 {
+            dev_dbg!(
+                ddev.as_ref(),
+                "Invalid VM_BIND flags: {:#x}\n",
+                vmbind.flags
+            );
+            return Err(EINVAL);
+        }
+
+        if vmbind.flags & async_flag != 0 {
+            dev_dbg!(ddev.as_ref(), "Async VM_BIND not supported\n");
+            return Err(EOPNOTSUPP);
+        }
+
+        let count = vmbind.ops.count as usize;
+        if count == 0 {
+            return Ok(0);
+        }
+
+        // Accept any stride that covers the trailing `syncs` array
+        // descriptor, so userspace built against older headers works.
+        static_assert!(
+            size_of::<VmBindOp>()
+                == offset_of!(uapi::drm_panthor_vm_bind_op, syncs)
+                    + size_of::<uapi::drm_panthor_obj_array>()
+        );
+        let min_size = offset_of!(uapi::drm_panthor_vm_bind_op, syncs)
+            + size_of::<uapi::drm_panthor_obj_array>();
+        if min_size > vmbind.ops.stride as usize {
+            dev_dbg!(
+                ddev.as_ref(),
+                "Invalid VM_BIND op stride {} (expected at least {})\n",
+                vmbind.ops.stride,
+                size_of::<VmBindOp>()
+            );
+            return Err(EINVAL);
+        }
+        let stride = vmbind.ops.stride as usize;
+
+        let total_len = stride.checked_mul(count).ok_or_else(|| {
+            dev_dbg!(ddev.as_ref(), "VM_BIND ops length overflow\n");
+            EINVAL
+        })?;
+        let mut reader =
+            UserSlice::new(UserPtr::from_addr(vmbind.ops.array as usize), total_len).reader();
+        let mut ops = KVec::new();
+        for _ in 0..count {
+            ops.push(reader.read::<VmBindOp>()?, GFP_KERNEL)?;
+            read_padding_zero(&mut reader, stride - size_of::<VmBindOp>())?;
+        }
+
+        let ret: Result<u32, Error> = file.inner_with(|pfile| {
+            let vm = pfile.vm_pool.get(vmbind.vm_id).ok_or_else(|| {
+                dev_dbg!(ddev.as_ref(), "Invalid VM_BIND vm_id: {}\n", vmbind.vm_id);
+                EINVAL
+            })?;
+
+            for (i, op) in ops.iter().enumerate() {
+                if let Err(e) = vm_bind_exec_op(&vm, file, op) {
+                    dev_dbg!(ddev.as_ref(), "VM_BIND op {} failed: {:?}\n", i, e);
+                    vmbind.ops.count = i as u32;
+                    return Err(e);
+                }
+            }
+
+            Ok(0)
+        });
+        ret
+    }
+
+    pub(crate) fn vm_get_state(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        vmgetstate: &mut uapi::drm_panthor_vm_get_state,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        file.inner_with(|pfile| {
+            let vm = pfile.vm_pool.get(vmgetstate.vm_id).ok_or_else(|| {
+                dev_dbg!(
+                    ddev.as_ref(),
+                    "Invalid VM_GET_STATE vm_id: {}\n",
+                    vmgetstate.vm_id
+                );
+                EINVAL
+            })?;
+            vmgetstate.state = if vm.is_unusable() {
+                uapi::drm_panthor_vm_state_DRM_PANTHOR_VM_STATE_UNUSABLE
+            } else {
+                uapi::drm_panthor_vm_state_DRM_PANTHOR_VM_STATE_USABLE
+            };
+            Ok(0)
+        })
+    }
+}
+
+fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> Result {
+    if op.size == 0 {
+        return Ok(());
+    }
+
+    if op.syncs.count != 0 {
+        dev_dbg!(vm.dev(), "VM_BIND op syncs not supported\n");
+        return Err(EINVAL);
+    }
+
+    let end = match op.va.checked_add(op.size) {
+        Some(end) => end,
+        None => {
+            dev_dbg!(vm.dev(), "VM_BIND op VA range overflow\n");
+            return Err(EINVAL);
+        }
+    };
+    if op.va < vm.layout.user.start || end > vm.layout.user.end {
+        dev_dbg!(
+            vm.dev(),
+            "VM_BIND op VA range {:#x}..{:#x} outside user range\n",
+            op.va,
+            end
+        );
+        return Err(EINVAL);
+    }
+
+    if (op.va | op.size | op.bo_offset) & (u64::SZ_4K - 1) != 0 {
+        dev_dbg!(vm.dev(), "VM_BIND op not GPU-page-aligned\n");
+        return Err(EINVAL);
+    }
+
+    match VmBindOpType::try_from(op.flags) {
+        Ok(VmBindOpType::Map) => {
+            // Once the VM is unusable only MAP ops are rejected; UNMAP
+            // stays available for cleanup (see the UAPI docs).
+            if vm.is_unusable() {
+                dev_err!(vm.dev(), "VM_BIND map op on unusable VM\n");
+                return Err(EINVAL);
+            }
+
+            let map_flags = match VmMapFlags::try_from(op.flags & !VmBindOpType::MASK) {
+                Ok(flags) => flags,
+                Err(_) => {
+                    dev_dbg!(vm.dev(), "VM_BIND op invalid map flags {:#x}\n", op.flags);
+                    return Err(EINVAL);
+                }
+            };
+            let bo = crate::gem::lookup_handle(file, op.bo_handle).map_err(|_| {
+                dev_dbg!(vm.dev(), "VM_BIND op invalid BO handle {}\n", op.bo_handle);
+                EINVAL
+            })?;
+            // Validate the BO window before mapping.
+            let bo_size = bo.size() as u64;
+            if op.size > bo_size || op.bo_offset > bo_size - op.size {
+                dev_dbg!(vm.dev(), "VM_BIND op BO range out of bounds\n");
+                return Err(EINVAL);
+            }
+            vm.map_bo_range(&bo, op.bo_offset, op.size, op.va, map_flags)
+        }
+        Ok(VmBindOpType::Unmap) => {
+            // Unmap must not carry map-specific flags or BO references.
+            if op.flags & !VmBindOpType::MASK != 0 || op.bo_handle != 0 || op.bo_offset != 0 {
+                dev_dbg!(
+                    vm.dev(),
+                    "VM_BIND UNMAP carries flags/BO refs: flags={:#x} bo_handle={} bo_offset={}\n",
+                    op.flags,
+                    op.bo_handle,
+                    op.bo_offset
+                );
+                return Err(EINVAL);
+            }
+            vm.unmap_range(op.va, op.size)
+        }
+        Err(_) => {
+            dev_dbg!(
+                vm.dev(),
+                "VM_BIND op type {:#x} not supported\n",
+                op.flags & VmBindOpType::MASK
+            );
+            Err(EINVAL)
+        }
+    }
+}
+
+/// Reads `len` bytes of array padding, rejecting any nonzero byte with `E2BIG`.
+fn read_padding_zero(reader: &mut UserSliceReader, len: usize) -> Result {
+    let mut buf = [0u8; 64];
+    let mut remaining = len;
+    while remaining > 0 {
+        let chunk = remaining.min(buf.len());
+        reader.read_slice(&mut buf[..chunk])?;
+        if buf[..chunk].iter().any(|&b| b != 0) {
+            return Err(E2BIG);
+        }
+        remaining -= chunk;
+    }
+    Ok(())
 }
+
+#[repr(transparent)]
+struct VmBindOp(uapi::drm_panthor_vm_bind_op);
+
+impl core::ops::Deref for VmBindOp {
+    type Target = uapi::drm_panthor_vm_bind_op;
+
+    fn deref(&self) -> &Self::Target {
+        &self.0
+    }
+}
+
+// SAFETY: `VmBindOp` contains only integers, so any bit pattern is valid;
+// the `#[repr(transparent)]` wrapper has the same layout as the UAPI struct.
+unsafe impl FromBytes for VmBindOp {}
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 0e0989a48678f..60f6363995a5a 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -77,7 +77,6 @@ pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result
 }
 
 /// Look up a GEM object by handle for a DRM file.
-#[expect(dead_code)]
 pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>> {
     Bo::lookup_handle(file, handle)
 }
diff --git a/drivers/gpu/drm/tyr/vm.rs b/drivers/gpu/drm/tyr/vm.rs
index adbf8edcd5c6f..597e35f864f64 100644
--- a/drivers/gpu/drm/tyr/vm.rs
+++ b/drivers/gpu/drm/tyr/vm.rs
@@ -53,6 +53,11 @@
     },
     sync::{
         aref::ARef,
+        atomic::{
+            Acquire,
+            Atomic,
+            Release, //
+        },
         Arc,
         ArcBorrow,
         Mutex, //
@@ -172,7 +177,6 @@ pub(crate) enum UserVaRequest {
 
 impl UserVaRequest {
     /// UAPI boundary normalization: `0` -> [`Auto`](Self::Auto).
-    #[expect(dead_code)]
     pub(crate) fn from_uapi(v: u64) -> Self {
         match NonZeroU64::new(v) {
             Some(size) => Self::Fixed(size),
@@ -181,6 +185,38 @@ pub(crate) fn from_uapi(v: u64) -> Self {
     }
 }
 
+/// Operation type, packed into the top nibble of
+/// `drm_panthor_vm_bind_op::flags`.
+#[derive(Debug, Clone, Copy, PartialEq, Eq)]
+pub(crate) enum VmBindOpType {
+    /// Map a BO range into the VM.
+    Map,
+    /// Unmap a VA range.
+    Unmap,
+}
+
+impl VmBindOpType {
+    /// Bits occupied by the op type in `drm_panthor_vm_bind_op::flags`.
+    pub(crate) const MASK: u32 =
+        uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MASK as u32;
+}
+
+impl TryFrom<u32> for VmBindOpType {
+    type Error = Error;
+
+    fn try_from(flags: u32) -> Result<Self, Self::Error> {
+        const MAP: u32 = uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_MAP as u32;
+        const UNMAP: u32 =
+            uapi::drm_panthor_vm_bind_op_flags_DRM_PANTHOR_VM_BIND_OP_TYPE_UNMAP as u32;
+
+        match flags & Self::MASK {
+            MAP => Ok(Self::Map),
+            UNMAP => Ok(Self::Unmap),
+            _ => Err(EINVAL),
+        }
+    }
+}
+
 /// Final user/kernel VA layout for a VM.
 pub(crate) struct VmLayout {
     /// Full GPU VA range covered by this VM.
@@ -425,6 +461,8 @@ pub(crate) struct Vm<'drm> {
     gpuvm: ARef<GpuVm<GpuVmData<'drm>>>,
     /// VA layout for this VM.
     pub(crate) layout: VmLayout,
+    /// Whether the VM is unusable.
+    unusable: Atomic<bool>,
 }
 
 impl<'drm> Vm<'drm> {
@@ -446,7 +484,6 @@ pub(crate) fn new_for_fw(
     }
 
     /// Creates a user VM, splitting the GPU VA range per `user_va`.
-    #[expect(dead_code)]
     pub(crate) fn new_for_user(
         dev: &'drm Device<Bound>,
         ddev: &TyrDrmDevice,
@@ -513,6 +550,7 @@ fn new_internal(
                 gpuvm,
                 gpuvm_unique <- new_mutex!(gpuvm_unique),
                 layout,
+                unusable: Atomic::new(false),
             }),
             GFP_KERNEL,
         )?;
@@ -543,6 +581,7 @@ fn deactivate(&self) -> Result {
 
     /// Kills the VM by deactivating it and unmapping all regions.
     pub(crate) fn kill(&self) {
+        self.mark_unusable();
         let _ = self.deactivate();
         let _ = self
             .unmap_range(
@@ -554,6 +593,15 @@ pub(crate) fn kill(&self) {
             });
     }
 
+    /// Marks the VM unusable.
+    fn mark_unusable(&self) {
+        self.unusable.store(true, Release);
+    }
+
+    pub(crate) fn is_unusable(&self) -> bool {
+        self.unusable.load(Acquire)
+    }
+
     /// Executes a virtual memory operation.
     ///
     /// This handles both map and unmap operations by coordinating between the
@@ -665,6 +713,17 @@ pub(crate) fn map_bo_range(
         };
         let result = {
             let mut gpuvm_unique = self.gpuvm_unique.lock();
+            // Check under the GPUVM lock, which the kill path also takes to
+            // unmap, so this serializes against a concurrent teardown.
+            if self.is_unusable() {
+                dev_err!(
+                    self.dev,
+                    "Failed to map VA {:#x}..{:#x}: VM is unusable\n",
+                    req.region.start,
+                    req.region.end
+                );
+                return Err(EINVAL);
+            }
             self.exec_op(gpuvm_unique.as_mut().get_mut(), req, &mut resources)
         };
         // We flush the defer cleanup list now. Things will be different in
@@ -1107,7 +1166,6 @@ pub(crate) struct AddError<'drm> {
 
 impl<'drm> VmPool<'drm> {
     /// Creates a new [`VmPool`].
-    #[expect(dead_code)]
     pub(crate) fn new(dev: &'drm Device<Bound>) -> impl PinInit<Self> {
         let ids = IdPool::new();
         pin_init!(Self {
@@ -1123,7 +1181,6 @@ pub(crate) fn new(dev: &'drm Device<Bound>) -> impl PinInit<Self> {
     /// returned in an [`AddError`] so the caller owns the teardown.
     // TODO: allocate IDs with the XArray directly (once it grows range
     // allocation, the equivalent of C's `XA_LIMIT`) and drop the IdPool.
-    #[expect(dead_code)]
     pub(crate) fn add(&self, vm: Arc<Vm<'drm>>) -> Result<u32, AddError<'drm>> {
         let id = (|| {
             let mut ids = self.ids.lock();
@@ -1173,7 +1230,6 @@ pub(crate) fn add(&self, vm: Arc<Vm<'drm>>) -> Result<u32, AddError<'drm>> {
     }
 
     /// Removes and kills the VM with the given ID.
-    #[expect(dead_code)]
     pub(crate) fn remove(&self, id: u32) -> Result<()> {
         let mut vms = self.vms.lock();
         let vm = match vms.remove(id as usize) {
@@ -1190,7 +1246,6 @@ pub(crate) fn remove(&self, id: u32) -> Result<()> {
     }
 
     /// Gets a shared reference to the VM with the given ID.
-    #[expect(dead_code)]
     pub(crate) fn get(&self, id: u32) -> Option<Arc<Vm<'drm>>> {
         let vms = self.vms.lock();
         let borrow = vms.get(id as usize)?;

-- 
2.43.0



