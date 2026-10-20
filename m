Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0CFB260A3820
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KqTv+ULb
Received: by kanga.kvack.org (Postfix)
	id 63C746B013D; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59F916B0142; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CA916B0140; Tue, 20 Oct 2026 04:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F39FE6B013D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DF7B1C42E9
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:52 +0000 (UTC)
X-FDA: 85342321344.01.7DC0117
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 54B941A000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqTv+ULb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484750;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KqRn1n5iORX+7EiqCp1P4Y8MwIEiz+RAzWKAWH8qI0I=;
	b=X0BF0fBtLr4quM6PjthLxbkMjSRgWnwNtHzewXdyATfvUpcZUDpGgps9lETDbtmjIW6Apl
	qC66ZnNvb+SHOMoa3Dlry3zA85LuFT4g9jE2WgCQl1DTI8AxCLZbif9ea2paG4j0+5Sxgj
	GVkFf9qBnhEa1wKVYCpUSFXbfj1MhfY=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KqTv+ULb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484750;
	b=qUtRxIELubPUZG3QXKl4nitk0Exj8yxNURWn4B5fg5Q22DNlMvsVh4SKiTB0eZd2v9BOVx
	kOskqjV2gCCQsl9w/j+hyUFuhHRMZynIjtlcMoKDPPRDYbSojvMSpIcV97Rpdjr45ASfFT
	ve/S+Af/pVcfIM1bUgf0Ejw5N9ff6pc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B85E44815;
	Tue, 20 Oct 2026 08:25:49 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484749;
	b=fYhJ2e7N9xjNk2kZLDdM+R/d6h+D5u4tp/fw78bWJ1JeBbWmUKtbnad3ryVqRgdVZo04
	 nAhKSogmzhkp6oCb1zA/cmUxdegyOx0kHnMes+5SqxNtwFEJ3nNNc0RKZcjN7QeokhVpe
	 HkyRyTdHym3WmlnFI4PJc/4zg7dwvZcIZrzrOOFNufIHPC4ygcNZFC9qktejXoZH5QT57
	 3/7mTrXQ0ub+UWjmEuqnnwxBr+mSggHQD287ZQaS3wCF2SZrWMoKW+A/SSFlPNkGybtcw
	 HhFTrs+NqYfzDGAhqOlzHlYht+WDBCkxNkk7Jti1GhH8i2kLHy2ynYq54VK1Gc1AI5A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484749;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=KqRn1n5iORX+7EiqCp1P4Y8MwIEiz+RAzWKAWH8qI0I=;
	b=ZzE0L5HhCA4AW8cgbaGiMqySEw4dLwF8+xPE65ayS5tXOdEb5xF/pCC0+H4Vxxfscrab
	 r59kZc4drC+b3B3MYC8SEaehgkkYtFwFAVUQIIRMLN/wd+v7j9uA72Nb20vTPF4BBDUZ0
	 A+x8i9zwIJ9bw0IjUmdXSaxfE9dWO0WsZxqtQXy2fIs75cHa8tmo1dpFRBsyW+12CPuUr
	 fS4hilIzPocXLnBUgA3g6+gAHAakcJnzNv81BGgK9Emc/2xmEO4/x4EPaIxYYdh0oDnKA
	 ufd2IKnWNobBuNmLbQ+Yc4U73cFc0lmBHWtERlsqEgty943HvGcUraXzKTKzMgE8B9w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0A44C1F000CD;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484749;
	bh=KqRn1n5iORX+7EiqCp1P4Y8MwIEiz+RAzWKAWH8qI0I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KqTv+ULbYH+nbvMaNbO/lzPrEjm1NPnJFUBfc0obhL54Os4lr2i67o7iM9KBGcnXj
	 6iP59DpFpoKeEJnYMW3UgSifmTMr3/VhAlV7eXwHEBgf5USz6IZdO52gPAeeYRRf/Z
	 6N2ofku10uKxyBpXVyJEkZ7F+YEk+oTJ8XH6qf+7kvGw/PX4O11hT669d3g+RySLBV
	 5zygcaKfUK3fFzwTQVEJ71Dmmu9pfcAkYSUtKrzA+fKcTFJ5bWGfYOlZyRDH7MsSMy
	 3hOGr83WddE4i60uTKPzoFulBUe6eLZkjuVUQTSWRi2EFrd/CWrxCmDeezl/EW7fgW
	 DNf9IdNbFGJrQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id D8419430EF;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:25 +0800
Subject: [PATCH v4 08/11] drm/tyr: add BO-related ioctls
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-8-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=5835;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=pPJLhN0cYhR6VLbdNYY1nEjJlXnDPH5ZSxoTT9flAXo=;
 b=4+bx5X5R13d+0MIbrPuiXx1LMwCdGrOJ+z7MxGsNiqAAJ8ZGr+AnZU3sfr7SO4qTlr2knh1FU
 4o9YpH3Vox0DP8PAiCLlMKJh35BKTRYhWnGWPHHU/GotEfMl7DnccCX
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 54B941A000B
X-Stat-Signature: i6kawbbdm4ssuktxkjhqgmtf74ysbxrc
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484750-898827
X-HE-Meta: U2FsdGVkX18qZWE55RS9FwPTYHrleWRnbR8W8gvCSq5mcoV5AgVupYEx+W+hSI2ZQ1FFVFpSKFIErx7ygNiG2Z9cK0akjxyn0w3FyeGOiap3Px+KThNhKjGNLV76yqfOdDfmmNED+B5gx2sgp+0mbb9TAj5rN3tssORVpLpvRki64Ne2Ju0B22g+n0IYc4J7o+r+4IbLDSFK9SjyF9ELEnoEPXwCKghhsRsxznAV5ZTDwOywN8j/ygJE1c520vagqBAZO41I3btn8j+g8kB3FqePic9X9t6Un+zceZ0cewy28uL5XKRzcZxot80NeMg79L/5xiQhBkd1tlkomvzsJX6Ty+Yt7QGTM/HpU3lSViQdPiZHKduRQELf0gD/QlOxBEjRNWBkl7c7I6Bubfci9LdapZRE2jzsIBv6ZzbDFs4awpgQPTX/97lS7Ao539OgA7rsowsQTz55qJHvZtq6k+Fsbmx5pkOSjzE9AXDOSGYMiv05sYNV6sZVxPaMkjF2k5xrU8I5zFohR6xQmRM6amja5xffF8v7/SLwuuE14mff2gGNgP9vvvT85P8L/jze/81f2lPjvk5NDWLulbKDoxbUsKwkmTbnV4mq2L47EzJaOf4j7f02M+hnQZBhKIpZdenylz6Awr6w8t9+REqQnI9th5eVKQGp2POWIgGpWWuXI8VtpbkzP3ofVWJydyXnZLEB+XN34tYma6aSxXsgRtwlkdvVYvjAPgVq8TdGNJswJUJ3uA7Ge2lr2GZ+ooBOSjBif9AYH7a4Bvzbs/blxqzRMnNErETnp1/7xL52rkCOhjyUZzfepoFXCzhWHJvPpE5Kb+sddC5OyBrMJWSIhN/Ryl8VoneU/9pbabksWWQLfyhTFSKVXzscKQ54crYQL44rXv7mgrC9bljy8JD3W6d8aXvx1eRYyDD8DBVh3ibklZEh0p9db4+Gf6BIjUH20N5O1814Osih7CMLYFv
 RtrAxaHk
 USYrXDGqvx0owDvKMsgT1nEsq4+IQj6p0faB2umbmbnLOp23ijqk9aQw+QYgOlLpx1zfUEaOd/ZfkkHHbaAFBpy09uVuX+p9mK/C5G2E3gexw53hyio+ghvK4LeTU8O5EqXH7bRwNk8RkVjkZyLG3/fb58k6A53gzpyisAdmRchd1VRXUad/jMoPquey9ngmBtq6jT41XwHZrKQVuXVGcTGmy8cUVQArQd+T+pzlSoYjFrfA2cs/Cb2dtQKHZ8E4NAmvXbqrosooEB2qYCn8uFe+7JQy3aGgC+l5TIkk7vDp1K5LSzofCRviGgF/tNy6q/Becw65Gw/pmdCsReiUKjkjPmGUMgF084ciY296jBo/njrLr1qVsk+TDChYnwlF4tPjM2zCKSuCUPlCg3M46qkijLBMJpy2oTK5bi4n3V/rg/jtz8A4XnQrVgHnxtPRdzbkr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

Implement BO_CREATE and BO_MMAP_OFFSET so userspace can allocate GPU
buffers and obtain a DRM mmap offset for the generic mmap path.
BO_CREATE page-aligns the requested size; BO_MMAP_OFFSET rejects
NO_MMAP objects, which must never be CPU-mapped.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/driver.rs |  2 ++
 drivers/gpu/drm/tyr/file.rs   | 73 +++++++++++++++++++++++++++++++++++++++++++
 drivers/gpu/drm/tyr/gem.rs    | 18 +++++++++--
 3 files changed, 90 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tyr/driver.rs b/drivers/gpu/drm/tyr/driver.rs
index c0f17bc4ce2c9..f4f31b24180b4 100644
--- a/drivers/gpu/drm/tyr/driver.rs
+++ b/drivers/gpu/drm/tyr/driver.rs
@@ -227,6 +227,8 @@ impl drm::Driver for TyrDrmDriver {
         (PANTHOR_VM_DESTROY, drm_panthor_vm_destroy, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_destroy),
         (PANTHOR_VM_BIND, drm_panthor_vm_bind, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_bind),
         (PANTHOR_VM_GET_STATE, drm_panthor_vm_get_state, ioctl::RENDER_ALLOW, TyrDrmFileData::vm_get_state),
+        (PANTHOR_BO_CREATE, drm_panthor_bo_create, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_create),
+        (PANTHOR_BO_MMAP_OFFSET, drm_panthor_bo_mmap_offset, ioctl::RENDER_ALLOW, TyrDrmFileData::bo_mmap_offset),
     }
 }
 
diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 22a74b4abf3de..9ffb42f0d8851 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -250,6 +250,79 @@ pub(crate) fn vm_get_state(
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
+            dev_dbg!(
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
+            dev_dbg!(ddev.as_ref(), "BO_CREATE: exclusive_vm_id not supported\n");
+            return Err(EINVAL);
+        }
+
+        let size = usize::try_from(bocreate.size).map_err(|_| {
+            dev_dbg!(
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
+            dev_dbg!(
+                ddev.as_ref(),
+                "BO mmap offset pad not zero: {}\n",
+                bommap.pad
+            );
+            return Err(EINVAL);
+        }
+
+        let bo = crate::gem::lookup_handle(file, bommap.handle).inspect_err(|_| {
+            dev_dbg!(ddev.as_ref(), "Invalid BO mmap handle: {}\n", bommap.handle);
+        })?;
+        if bo.flags() & uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0 {
+            dev_dbg!(ddev.as_ref(), "BO mmap offset on NO_MMAP object\n");
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
index 60f6363995a5a..14f3e182b98e2 100644
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
@@ -65,7 +71,7 @@ pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result
 
     let aligned_size = size.checked_next_multiple_of(PAGE_SIZE).ok_or(EINVAL)?;
 
-    Bo::new(
+    let bo = Bo::new(
         ddev,
         aligned_size,
         shmem::ObjectConfig {
@@ -73,7 +79,13 @@ pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result
             parent_resv_obj: None,
         },
         BoCreateArgs { flags },
-    )
+    )?;
+
+    // SAFETY: `ddev` is bound for the duration of this call.
+    let dev = unsafe { ddev.as_ref().as_ref().as_bound() };
+    bo.sg_table(dev)?;
+
+    Ok(bo)
 }
 
 /// Look up a GEM object by handle for a DRM file.

-- 
2.43.0



