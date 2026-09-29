Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BCD0CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5248F6B00A9; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47FF06B00AD; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20CAC6B00A9; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD5986B00A4
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6C5901603BE
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:02 +0000 (UTC)
X-FDA: 85265184564.27.BB8964D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 60D2140006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GW5e4ZRZ;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOxFDfQ/X4mEGDRGrNbdjL9/SQN0s48Rghn5haLoLME=;
	b=0tphOkByyQqoi25noT/evMpg55LxM0tvqWeypnJ3DQ+pwm2RDe+AmDzJbGBZSwCLfYS//t
	kEpPFhgUyqta1yzY5pztDL2CAoEnAQqYj00qIphkcrKS/7PpLtswEB/8dqX2HL8/j6UbN5
	tmpb4hP4duKkZ0Qnz7hVS9Y+C421ZJ8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GW5e4ZRZ;
	spf=pass (imf01.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648160;
	b=x07BFUnjLLwxNmEAAHUq9INigaEgLONK79QXxEOuXyY8cxbC1GmXR7YnD/NGIXAasUXfyp
	Q3ZMlIQ8Df+ttoqGguv6PHI1aHTd4O+kaj5ZZnIYDhD9oyXH0I9MXdjAkOgMUYkHcnenvW
	7K92HGc7HaypfX3P7USi3YueecssphM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE7D3447DA;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EA58C4AF18;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=W/AaOByb0ZTUlKCwLRKY5gaI4wmhuJvBnRlvrkC5dNM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=GW5e4ZRZxpV6+Yt0Y9wxxDfWbAQwuIWLhbfC/5TzVGXf0bu+YO3TW4LcFvx/ItoDs
	 U5bXgdtRuZ1pi3WnKmdgIwJY7aRi35Evi08YlzJsC7t46L0x7o77nUKrMFzMGN0/6+
	 L/YGECupT4tuXxiGsaL8yZVJ3y1L4tNydKyI8W0ADZmZ540nHz/a3VL2XN8jK1789r
	 NXcTITcwy7PA67Wcutg9xX2oUWE2Woe5kdOB9L7qMY912h+A7ZFwP/RnCI4NMfHjvc
	 u0Vf+v4MUAqIqJgA7WrWK8puEUuTpIfOl3UQE4ODfGqNaAUrrbtLew2YEUWxSDvKtK
	 IBpeY6GloTzVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8977CCA5FA1;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:15:58 +0800
Subject: [PATCH v3 08/11] drm/tyr: add BO-related ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-8-26955fb111d5@kylinos.cn>
References: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
In-Reply-To: <20260929-tyr-ioctls-v3-0-26955fb111d5@kylinos.cn>
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
 Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=5096;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=PlK+MxKXv+uhIAuBuHRp75Wl3o6aaKjURRncsDRMpHo=;
 b=n5VNlm2++jrqcG5a4rYP2Zu4UicnY1E8VmGRXS3FAGNb8UlrQIUNasgHQO3TafAEBfumO89/K
 mdlZ8edUXRAAvczQ3JuZCeiJIfrR7lidf+Rs0l6gol/pg2P4pxfLgbT
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60D2140006
X-Stat-Signature: smr3m3kagy83myaj7ny4psnm6fpy8hx6
X-Rspam-User: 
X-HE-Tag: 1790648160-440962
X-HE-Meta: U2FsdGVkX1+5kStCVyUqUvDDKwsInEcHw8ERkpfhtuLNM96DxHAolmY28AsJAB5giiUtveUAFh1wY4XJ4Qfs52353xxSv4n2JspROZGdWBLFQszvEzfhAa4jTsrzNOrBnenxT9cqhjElidJgu9BPYZ7jakZRjfn+aXXqecL8oXFENzA387TpTEyuRIvjG7BgG7uiZkSaacnp1n1BQho5UsvndAw504rxiINte82/rBZLu8HscaBYvhuWrIZGBwKc2jxjrFcyMBuFWNXaR7bMV4IcnHMS/hQQbBY8NzIZeJtyRJ6HsRREMSQ0yw9KR/RqXrxmrSJGVDbLcmi2t8LAM75t0x/X7NsUiV803wPGxrhIfLLHO8Q2y0W+CpDySJ0Uy9RSezDcbYdw8BaGZMlerQai2VaXIvdsSHZJTaMlkTB4cXLnwjwg2MHPGmMjc4FotJmboyRaWfa+EqOxP82IzSYUquPfIvBC8tTQdZ8wv6d7cS4LA5pAht469t/CD1vBt8QPqcVnC7/ByMBLQGnvzhLxn9n6xo5sgcKsVn8i3iw9YO6yDjgPSlT6MWrRBd0BmVOWgGl46v2zPZfkOjAbGZyKr5fIE/7X6teeXxkWGMxg9ayX8C2G+yjSWpvz91GrUP5d/jK1m5uiO6ZJfuXFfAe9AqdAy07nAxjpF1nAfRXokpyna0loNR9Hm2jtWepUOy6putVrz8JpGEVlzZO/ip+6ms1NhNHdYimkYVco3h+/Cop2HCIbAVJpBl6H3Ue87y5mh2/G7ylWNG6D8BonQ7qryxdJXudZX37/dG6F+fklHjgKOqa3wM93Us/6Y0aYItQbWLWGCq/y9yc6mfq8qHwpZsuTCv6ZY5qUu+GszVtTw5UWJzZMyX75YmMiRE7gt2WFaNqizKWXilsZE7DE6ftpLH9hpPxI/bcVZ4q6GTjNxrLd08Ypoyb6hgwBSqa21Eg+Frvoaslf/XEDeG7
 voVNP2pX
 yKOGxGQ01HBAtYLTpyt6eDGt177ZifTGV0s6y+Q1T1ggR2+gB10XNR2YoZX+lc/MWAzJyZNx+BiorwHBWf9Ozq6IRiHeYAWDPi7iNtmiaueCTM48vDfByveIrLUmB8WmjiS6eyH9GWPQvzocOyiYYNdpn9QrRWDsJhEUO7sKJWBX/IlNVAr8rrK9bPn2jdLW84x30aGYWn0bs4/hJep3IAi+6RYBykKuWHFG0lFvPKeABXfzRHYSJj4cBnpieQ+bg8qCLZS4P0lTzU5G7xT+Kgz5Zw90fRF6XiliaGUzyR7lr6ZXK/pTrC+AUBE6XEPq6Vnm8quOdmuWym6EF+qqduJjJsq+FAxbljN/rtwdNOPpHGF9GgduvnEPEC3M2JjWSM8aJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Implement BO_CREATE and BO_MMAP_OFFSET so userspace can allocate GPU
buffers and obtain a DRM mmap offset for the generic mmap path.
BO_CREATE page-aligns the requested size; BO_MMAP_OFFSET rejects
NO_MMAP objects, which must never be CPU-mapped.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs |  2 ++
 drivers/gpu/drm/tyr/file.rs   | 73 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/gem.rs    |  8 ++++-
 3 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index 9a7f147935e29..8baf88aee96ad 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -224,6 +224,8 @@ impl drm::Driver for TyrDrmDriver {
         (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
         (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
         (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
+        (PANTHOR_BO_CREATE, drm_panthor_bo_create, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_create),
+        (PANTHOR_BO_MMAP_OFFSET, drm_panthor_bo_mmap_offset, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_mmap_offset),
     }
 }
 
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 2c037b136406c..e98eb0a46877f 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -248,6 +248,79 @@ pub(crate) fn vm_get_state(
             Ok(0)
         })
     }
+
+    pub(crate) fn bo_create(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        bocreate: &mut uapi::drm_panthor_bo_create,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        if bocreate.size == 0
+            || bocreate.pad != 0
+            || bocreate.flags & !uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0
+        {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid BO_CREATE params: size={}, pad={}, flags={:#x}\n",
+                bocreate.size,
+                bocreate.pad,
+                bocreate.flags
+            );
+            return Err(EINVAL);
+        }
+
+        if bocreate.exclusive_vm_id != 0 {
+            dev_err!(ddev.as_ref(), "BO_CREATE: exclusive_vm_id not supported\n");
+            return Err(EINVAL);
+        }
+
+        let size = usize::try_from(bocreate.size).map_err(|_| {
+            dev_err!(
+                ddev.as_ref(),
+                "BO_CREATE size {:#x} too large\n",
+                bocreate.size
+            );
+            EINVAL
+        })?;
+        let bo = crate::gem::new_object(ddev, size, bocreate.flags)?;
+        bocreate.handle = bo.create_handle(file)?;
+        bocreate.size = bo.size() as u64;
+
+        Ok(0)
+    }
+
+    pub(crate) fn bo_mmap_offset(
+        ddev: &TyrDrmDevice<Registered>,
+        _reg_data: &TyrDrmRegistrationData<'_>,
+        bommap: &mut uapi::drm_panthor_bo_mmap_offset,
+        file: &TyrDrmFile,
+    ) -> Result<u32> {
+        if bommap.pad != 0 {
+            dev_err!(
+                ddev.as_ref(),
+                "BO mmap offset pad not zero: {}\n",
+                bommap.pad
+            );
+            return Err(EINVAL);
+        }
+
+        let bo = crate::gem::lookup_handle(file, bommap.handle).inspect_err(|_| {
+            dev_err!(ddev.as_ref(), "Invalid BO mmap handle: {}\n", bommap.handle);
+        })?;
+        if bo.flags() & uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0 {
+            dev_err!(ddev.as_ref(), "BO mmap offset on NO_MMAP object\n");
+            return Err(EPERM);
+        }
+        bommap.offset = bo.create_mmap_offset().inspect_err(|_| {
+            dev_err!(
+                ddev.as_ref(),
+                "Failed to create mmap offset for handle {}\n",
+                bommap.handle
+            );
+        })?;
+
+        Ok(0)
+    }
 }
 
 fn vm_bind_exec_op(vm: &Vm<'_>, file: &TyrDrmFile, op: &VmBindOp) -> Result {
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 60f6363995a5a..22a04c0b8a812 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -38,6 +38,13 @@ pub(crate) struct BoData {
     flags: u32,
 }
 
+impl BoData {
+    /// Returns the flags the BO was created with.
+    pub(crate) fn flags(&self) -> u32 {
+        self.flags
+    }
+}
+
 /// Provides a way to pass arguments when creating BoData
 /// as required by the gem::DriverObject trait.
 pub(crate) struct BoCreateArgs {
@@ -57,7 +64,6 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
 /// Create a new GEM buffer object.
-#[expect(dead_code)]
 pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result<ARef<Bo>> {
     if size == 0 {
         return Err(EINVAL);

-- 
2.43.0



