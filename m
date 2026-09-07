Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E298C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EBFE6B00A0; Mon,  7 Sep 2026 12:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275046B00A6; Mon,  7 Sep 2026 12:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA8A36B00A0; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6B926B00A1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24D91801FB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:21 +0000 (UTC)
X-FDA: 85187549202.25.6B13D4E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22A3CC0005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lftWQdYS;
	spf=pass (imf10.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799699;
	b=NYXw09tG9cIaHTWSLYSAfpIWePFopn/EtXv44NyeVLq3383ObIDdbJZUhUm5QTtCdpKuXa
	BHjFJv+YUtD5us2HryfcqIZ1nK4u2G930H1LDTrljNa0o7nAYldGV/WtDJ0gX68E09mrMN
	UGtRcniMna6xGlp89m63Zonzp1UstjU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799699;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZpT4Xc3WwyJyVoYgybQetdt7yKNW5HpDh9jSCR3dm7M=;
	b=L40YEb4ZmDqetD0F1x21pwwMSeUb1I6s23aSUPjClvBKY4JF2hsJ/xYIgvkv5QQemSCfma
	0YOH5D38wnPtyZugnoxhRtOPE3kUw+vZZBapm5JRkWBEkVjlTVAAxXT6Fw3eJ1iIIVI3Jq
	sidPt1p62aNIams1FhkFpjxJojwIfBk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lftWQdYS;
	spf=pass (imf10.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4551844583;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 250BFC2BD04;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799696;
	bh=tG9MtH7XTUY6M2vbhj4/1uyraDN80MRt2bwRHxYGjQk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=lftWQdYS1I7JvcQrH2iixLIRO7UvxgVLB6XL+m0pWayJI2YqamxAu+onABVAk4Djj
	 WnCQM+a3z8N7MNQ2md3VzEG2XC4OoEIIB4AyWE5YO2OSNoWC6GYS/sRDY2apZs6n8V
	 X9rL59/g3YRWTXERLkF7h88+8pfytVxyet4ytUmY58OlkBisHzOTcR+ijvBaiFd7RJ
	 y+O4qh1QKd9yrDO8Y0Psuy8c2t/A1lusdQnyAoq65ob3lqZUl/RimPS3PzKSej4M+q
	 DWIEY6Asfb24ER3CS+j3wPUDYXxeNQ6RWgkwkEPqCi5FS6J02auzz//j66DkSKWSZm
	 SMd+kZvieJm6g==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12460C79FA1;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:56 +0800
Subject: [PATCH v2 9/9] drm/tyr: add BO-related ioctls
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-9-88bea777df67@kylinos.cn>
References: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
In-Reply-To: <20260908-tyr-ioctls-v2-0-88bea777df67@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=4712;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=xnfV+DL8ObyMU6ybdjvxrzU2shgkBW1Lv77J/eSf2Rw=;
 b=8tq66fA+IKBrwmpTmb2HoubKsKAR0nqE1yXq2iF9mNzf398J98tq2fBNP53ZJ5PWj2hVJivjn
 baSuZar3upOAmohyGmYlLZqBhgl6FVxKhqaNA22vyS5Fp9Taia2ottq
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 22A3CC0005
X-Stat-Signature: tjs9pou68m6jkspu8dgb5ytge8woywud
X-HE-Tag: 1788799698-133999
X-HE-Meta: U2FsdGVkX18IDcCnK63j0Aca2mA06dVz9n3vXRCa1fhlZp45trh5I5hJj8OhVISZRpVvWupUv7I2vS+RIw6mQe1R8EPtgZj3JeRLPEueV8ZntBLmz/r+rbOTvGlxQbxk4+fLD7E7HgUgVTj2GqgLRCDnuGLGn9vM8QKU+6VoHCylC1n91qCKDzCnJBnDEw9WI5RuUnCpRMAIYIbS0KPJAHuR1gWzlKBszTLldGO7f2apK0hV+5dURkZS19yxqCk7W9jKGXt3iUXqdUI7AtUIeKfeoBjP91icydi8aLrWrjaiY+zG2ECEOVogtBM83ddIoolBS/hqtmlgsIjhMVWlomK4O6F1UI5y0PG+7s8jNltsSz2+0vx3JEPBNGyPyGYOslMUbRiQg7CnfmdwZyImO8p8qfdI5yehZHQbjyhR4pk4ubG1fBmzgQWP9v18/kqoZnV4lxwfgZmEUTiGCrvL3gP9pLI9kTCILHfwAr0SPfqqxFu7LAFnbP20zxuosCaa24TbpXtP/JsCDUbzdRpSaraWjt8+E0MzvZMOWyt5SA4XMYB8yrWMRTbsGBDVgzkYZMi9MrEHHRGyL4w3PT738yu1eS6oh1WVtknw1csDq3yTFwFVCxSQws6qjsrfFxCUZE1ZxYVs4hh6J/jjJv7hPIceHYOdpLHTr0ryTJHa6pJ9CaJ3YAOY5s+LG1qnnx8IDnoosu2Zf6h4S2RZyngeSOPMIhEGY9FwR7NmckBtGhwTfnRVCOvzvFRfH0lpc38TQLA1pQw4ypAL2Oh1l03WQMSKhFTjGtVl3zgHA90SG26BsP+hIUSYsaDi49CE28D19VcuPUbvSKFU5BQ7pSxS4XN5wKi2+vzHsON4w0tUpWM7SmEFRqgj3W4czgG/XFhDBoNfyMVmL6l5YyakF1XjmfjvvoX10Vv6vyTGSOKWW5fR2fOzDdpNNRtL8YuVLvwKGX/LIBYn5OueXk3tUhz
 Jc3Rh31L
 4lFgQyfI809hsTMxQlnNAXmzcQEHo3eCwLvEKCwCEATsIZomYc5QSJW0WgHx1qaY6zEcM6BRG6JCOGKVoCuunEV8hmUwAvapZYr67aUd0O5CeTCT3+yUCH167mMsTtM4SB5HVhu8bxVNVivybdMEv1ZrKPxy4aO1jxprPi0ijzGPR93LuWz3O8lISHtI2XVeWuxna/HGc9UqDudm9KzzfW4ghJXCiSwZ6nmeDVZJW3R5z1ZDr4NakqKKADbeJ8+dSCC5quavrm1yRWRJoOaDeXkgHpfAefYXF0mK4QsGMhHCtpPhiZnquj4QIqMvyR1c6Pr2UDQu5pPBNPlbgoaSBW2owmZzJ2ZCgFz04j1CzjMZRprHcT+pcTbe2NvD3VDKJiWXTx2MySXoYcr4LE2joejTngsLhYkje/1UPFv5hq/bPQJq93eshtROW5lNyOzbtF3TP/aUu8ytpV18IsHKQWKSK7x3T8CBENWeQ
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
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
---
 drivers/gpu/drm/tyr/driver.rs |  2 ++
 drivers/gpu/drm/tyr/file.rs   | 70 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/gem.rs    |  7 +++++
 3 files changed, 79 insertions(+)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index 5757956470afd..06e0feae289c2 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -223,6 +223,8 @@ impl drm::Driver for TyrDrmDriver {
         (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
         (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
         (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
+        (PANTHOR_BO_CREATE, drm_panthor_bo_create, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_create),
+        (PANTHOR_BO_MMAP_OFFSET, drm_panthor_bo_mmap_offset, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_mmap_offset),
     }
 }
 
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index dceaae6fb9717..ec6b53c586d02 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -238,6 +238,76 @@ pub(crate) fn vm_get_state(
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
index e5030b645527d..27273636c09c9 100644
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

-- 
2.43.0



