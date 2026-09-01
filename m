Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B200AC61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3470E6B029E; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229216B029D; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F06B6B0299; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C5ED76B0295
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4B3EAC044B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:22 +0000 (UTC)
X-FDA: 85165678164.27.7A53733
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 47A1240014
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:20 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rox7nyIJ;
	spf=pass (imf11.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278960;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qK943s7k/aC2sCeE3LHlCfCs47MtiCGtkJU9xGNGJlg=;
	b=mzubuKrSkK2itA7EEi/0JPcvZ6SaB60WQOpVMsrKOlu719PdZ7IlwXIoTChZHYFuTgYxE5
	36J2tJrdiIU0H2l4s8pvbTdVTsOAszcdIGjsdCAms6FHbZkGp5cUFC61K3+eMqBxEIqBzS
	WM+195Y38pFZi+JHxNXSVtUI3OG7iig=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rox7nyIJ;
	spf=pass (imf11.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278960;
	b=d6Ui7HiuJ/4SoLia3IaaozKtaLIKubyFQCv7QpE+ChPTDrZ9kDPU0836s+zgGn1bRb1KMc
	h1osW0CdwIewGJCNyt7BQUW5bqtfuMCr1S2ZV6J0ESkT123qzDUTdhlxdNVycstpguR9S3
	iDUBfvdPhdQZK8cbK19LtwDDg2AX4vc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F01D8435EF;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CDFBEC4AF0D;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=2rDFcVDpVSOb7E7Q6WZ1n2yT0y1382pLRES1c4DMPSY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Rox7nyIJz4XYUKSbtGWvHgHM43zJWFsnI5A216rQQkesWjf+9JviSQjRNYUoy4Dlt
	 ZJXTqE2isLzWICxOQqtkaBCGlz+GbFVgDL18u8VpYRUqeNvFDMSW8w4mqmuco+vBTr
	 9++A3jT/Orx2icuW+LOZ6Q8MqYYZW2LKmDiXwbln3EH5lH8rR64tgY1HzL7J+HlSVJ
	 A1i2dVGlUgQB8cR/aKPN7eyYpcKHd3UlQURhbBU/B6IsSC1fWvUm9Cssjt/RzU7zSA
	 uCWFLVjocFcvu6JnlZhqbGR2RhRMwXwlcQ//Kc28P//55lt7a6Uw/v9QfUfj64klry
	 sh0UtKR46IHHQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9F5FC624D3;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:08 +0800
Subject: [PATCH 9/9] drm/tyr: add BO-related ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-9-e0fdbf8bd108@kylinos.cn>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
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
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=4674;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=GB09PX+9tSC0xXDoB/KYTwCpkupIwMi/t6ujGhWMHCY=;
 b=3u5QXxhXzE8PTncHj0Olzvwbk36Gnj+5vmGi8iSqdmGh8w7HtluwATOet3QKkFSy3LnDcQ8F/
 ROMIFgAhZvfDBDlBA2bDnpKNn+XvzEDEHkHdnZeJP4HolUp8mxXyTEf
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: gyuak5iu36hfn8czyb88r8rro6ei6nfi
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 47A1240014
X-Rspam-User: 
X-HE-Tag: 1788278960-152395
X-HE-Meta: U2FsdGVkX1+icgouNwP4ajbjSq4KjLFU7b1hr304EA6SX0A5Dg+Xi0Rw1uuzsICpeD6W1KBNUKq6uxk0TIj6E3n8OFcTK/E3d0pcbJarp0eDZr67rdm0fmMMVLmHD5bYoE+WQUHHl7UqqgJAxwq9jCNnyXGgPxnALx6a0zrXToZSomFeG/Ip2XLzLWMj/baBaoFMEA8WFcU7oZt2jsQiO67b180fCq1A704yZIUhyQhSvm1zuDq1cFLNPdRBakhlsg8pIbLrNZtu1lBk0ka/iSd7IPkHw63rQif2df9Wq3VT2JC4ZxmlK+3g8I0wtankCi9bnwl1Aiv+RSzgI8VG9grFWKOYeQlwbOlR1dt5V0CTtdLMArERbEZW4YhYlYS6MiiFRGD4ntc7HMfOpMOFrBBbAiOtEL99c80/5DPq6hXvka2YQKkQ/tQlhcmd3XWyrULqP7vZYcNaD6mGoFB4/HjhMliNlV6i8IaHagZG68ttoTQoCmmkzTY/oT/eMP8sMsyEdQYVFvOqYugMY5r3OESKyeaYHNCC7EQtY9Iww5aW3QUdIBD80tT+iEPHY1nUjY7DUt3Lx6yxKL+bvUsxKrR4GgkJGdKnFa8IgpouK/L72jb3g11vUQWeTvaPNrnCO+T/k6Lb5kvXIGmHxI7vTc/QpCmHFfC5V8Q86EMJAXKoc79rlFOANqOkqWKaGuhvH+wRmSrWbk8nfEYdnBKLjwpCbyfTgG1Bf2gOFK/Hk2qbz6AX7pTte1Gf14eTQIIc4aVFQnoQ6kYywJ6WiO6HBMT7mrvNPTMzXgr4YOracKza40DAmnVm0TwaW2mlTuEbRlaCFb7jf95FiTYqJwSBtJDK7rTe4/TJysvFq+qTLiXnWCoLpDmqqrQcmWvNgB8/wXSWtNFGTgTj1gjG5HkbTMx0nqhZOR1jN5hO2tcE+Bxk7Y8/UgGdvDMB6l9+uOYn1JvffXP2I5I1Max3kSw
 Eu4looFQ
 +fs+fDiIwmAsl6Z3QaPuQB0xvrM9yCGkevpJ+THwZhC3FI3WBw+Qte5RPcxsATXTKHS0TPaItynezo/BQKQBojLfathn3TE83GSI4wqcqcah/FD8+8eURZxL3FUPGZm+2BaftllhkH0qhPkMST4j78Ek/uEdgdde/9SPuRP8VSORlmRXTrPSFi2tUAsUIzHJHY1izVR8ZddFNsKWtOVRy1Zh8NYfn4s/dUIfaq64eAici6KD7FrT4LlGQZ/6MewLMfYEE6jjsGH20g6dcyImBAOKCRxGaXDWcrjP7aPtnjvB2tcldCvNw1K6sUhC8KBalHvxjoRQLVCMOuwMqvD2Zd9jlvqlKBxxjuELkut187qjY+Xt3bCzPqrWuypfuPywoQmk4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Expose buffer creation and BO mmap offset retrieval.

- BO_CREATE page-aligns the size and returns a handle with
  write-combined mapping.
- BO_MMAP_OFFSET provides the offset for the DRM generic mmap
  path, rejecting NO_MMAP objects and non-zero pad.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs |  2 ++
 drivers/gpu/drm/tyr/file.rs   | 70 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/gem.rs    |  7 +++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index b3145526ada06..fc8d11c9ba1ca 100644
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
index 157bc40e1cac4..16abf2968299c 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -252,6 +252,76 @@ pub(crate) fn vm_get_state(
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
+            || bocreate.exclusive_vm_id != 0
+        {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid BO_CREATE params: size={}, pad={}, flags={:#x}, exclusive_vm_id={}\n",
+                bocreate.size,
+                bocreate.pad,
+                bocreate.flags,
+                bocreate.exclusive_vm_id
+            );
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
+        if bo.create_flags() & uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0 {
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
index d9ddcb287f52b..f404139f54f32 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -38,6 +38,13 @@ pub(crate) struct BoData {
     flags: u32,
 }
 
+impl BoData {
+    /// Returns the flags the BO was created with.
+    pub(crate) fn create_flags(&self) -> u32 {
+        self.flags
+    }
+}
+
 /// Provides a way to pass arguments when creating BoData
 /// as required by the gem::DriverObject trait.
 pub(crate) struct BoCreateArgs {

-- 
2.43.0



