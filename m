Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73B2FCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:16:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91C366B00A5; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DD936B00AA; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 606656B00AB; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0F8456B00AA
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:16:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8ABED1203A6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:02 +0000 (UTC)
X-FDA: 85265184564.29.38310D2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 941F2180003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:16:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ky48MWZx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ttZT3yYl1+SuHKU8Ceeqd00aagiEG4TqYNOLpdN1iQ=;
	b=NFOHg8s5nQBrXps5nBrB3hHzi6LEW8G02BiW8aIPrQr8StDisBs1o33U3RaatCnhp+P9mB
	zzcm+cO2ZG3PdRKvXVvxVxngOO2Yi7I3H2SnZm0F/LYPYC8277RAqokzhdjqA5zsLkdSCn
	1H5o9GXTVWtHzmF49JH3MMma4EHknvA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ky48MWZx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648160;
	b=bHgTkh4og950nu9XAl53kyxvndhAQcSTj3Nz5BXTYDg/2pIxHJTAj4kjyE2bn2Je+Va7xn
	8KuvkQwCBCwR1xFdAoyWJDI1TK9NzjR36HSpkwrmQezaFDVl5y/P+tWS19HqH/GB/jb4mP
	2Duum2lKojntTqjPMizD5tvKGG7K/vc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04C8E447F7;
	Tue, 29 Sep 2026 02:15:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D78F3C4AF12;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790648156;
	bh=kgJIJiorfmegbLQpmMw87fy8GcE4P8Xu+wJwCGKZGyA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=ky48MWZx0sll4Wkkayz0XBpT+fy9x9ItAkkj6H1ZMKSHUpJ/D26bYtCDcxckEEO1v
	 r1ZgkANtangIpoTh8Ts2zFFPapi3i1w9nMnlVRM0z8zU5TEm/6VituobzEFMXk6pm9
	 Pe7tvUCSTkBRoVwVq4WMV/Pwzn1j9XJNMyXUPy7VDOgdJTnW7LeDVZOq2wVk5rgjZO
	 +eNboxW3M2VqRv97MWI63HVWFc2NxtjPNvFGMQlEIVgKsRvFRRK9xiqlvMgwp+ljFs
	 qYiyIlHiQ93a4soMB3Mn/qEw2AZEz5LNjvfMHiurf8OQzyvxEsVm5t2QkAZWmrNuCu
	 FTK1duwc6FqaA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C50BCCA5FAD;
	Tue, 29 Sep 2026 02:15:56 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 29 Sep 2026 10:16:01 +0800
Subject: [PATCH v3 11/11] drm/tyr: gem: map cached BOs for
 DRM_PANTHOR_BO_WB_MMAP
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260929-tyr-ioctls-v3-11-26955fb111d5@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790648153; l=4490;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=g7NGH5IK+aKtnhOkcQHFTWmHIOxfBCihbd0P5WoqQL0=;
 b=3TYcDisu+8tPh0DWXNRfpV5bBe9WRoBYxN9JY4oYTdWJov6P7C+AhjOGumle2IqoLRv1/fWqp
 NZbE20qeANwD0kgYkAYQ5k5+Da55KLb3OBdWAViztwHGvzRBpjBMc9R
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: 8qp77qqqjzeyasdnm3bhou49ko9ft8ry
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 941F2180003
X-HE-Tag: 1790648160-165572
X-HE-Meta: U2FsdGVkX19YGndjErKbKONfsGk0YQLykd7teO9aFBYgwrek8Mhs/6IL0XW+sLjy2h6XF42Fe3rScmMx/GWiFmrIElF0f0xdNSGfXrusiWjI+Uc/daOlt8alANeB79Mf5CRQaWCLAXZKbEryxe/XUeaM3hR80j7Mqrd5YIuJLSdg96CM3Z9AHj5EurBVXnMGWBhGL/mngIVzV8UkjbJ/UmV5ia+7l7jn7mPfuQEbBCgvrgzxpVJwCLPFXCg5R0lCxG5PXpcHWuA935MKBbAFxNCpU4AG1MbzBnyAqj5/nh3MwhMC6zTw60PDlTRO0Li4t4yDy/JmZWNJBbWmRH9QTnqoKGp7fdH5BObIn1fiwB7wc8UKfQQ05gkF5BNLw+U5z4WDpa/9H3bgbFu0kH8kWZ1FXZ6ozPfO+YDSLWKHgGdjAUPzlbL7j6qyuH8b6OCz5O73F6IiY00vyV/HgH9n/mG6zAcFhxNexEzGJLBZEdEK077Ver0VHpY1yxUgjos5Rq8i4iLMjBuqO5cCVPin0DOk2TR4dNuR6x7uritUuvKhRZvI+9oSnZrmcHVG+nF4jolhVukba6BUE0KK8I8b/2GJm3i3K1RW1XDgaOmY00A12QNylVBzXaZjN3b+XyKhniqaoIhmumx1iqtbW+8cXPzDOM3FBvP1xNu8q3GWGbRewERl8vPcI0XDApOJqrj2hAncNxF2Zs4vdmxcnYA9h7uvYkOB2qhwa29ehf1XpsCKqPQA72xnxN/PCRBQQglWR3YvHoi+6EfBFjH77ZuHH91Qnl/DAEITPQUfX5Hp+kiUhE2rO2x8beUOf9haExBG7/Sb3vstSF8ExDHjR6VQ2MCs83yUkrVkpeRUl//euanu7ocfgiXC++rqV7Y9soZBzloJ+J/UaHtOjKopxl/tewYaPx+KunIO6jZWGh9Vam0BVrC1emxkAM+QI/zcxw3BoJnsMmLTYAB4j5J5IYj
 hNriZo28
 JAcRonj5jCm+CQVgNHcekG8CTym/xa5mXgnazD5dY6wPml0sXT9raC9DxIOwGZNzECmz1cZgCbm+JwWudX/3C19oXI8eAZyGBvmgZ3OdKe7MJ4ocL4VqgxBvoFDwpNskqx9R5jKQ+E1e2XJpy6Tl/yRYHLQMHDgwWtmKiAeN7nJ6Uw/WWm66VVqkWh1RLij5r5dEitk+0uE/YZPcWCombKlzD4JDE2fvttmRI1QuzRFGgwrW+ka4w/i8cbZwQVbEcwSE/wqzxZS/W7FyNYI1gV3s4Lf6kVU7gXOAgmMPsxnJgQSRSxbxDwHkOJ62N0Dra6h8v2vj4W69FcQGxWI2MAL3raFAg9er2P+JOIURjnaEV21FrCN/fVlxLb2WRMFbidwrfDst1IF8sWn0Oe294zCfqrLwswSEIeQ4i1NpaGlCzVb9yclV/tHdNuEpIsMSLdY9J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Sami Tolvanen <samitolvanen@google.com>

Userspace may request a cacheable CPU mapping for a buffer it accesses
frequently. Accept DRM_PANTHOR_BO_WB_MMAP in bo_create and map the
buffer cached when the flag is set. Coherent devices already map
cached. NO_MMAP and WB_MMAP together are rejected with EINVAL.

On non-coherent platforms userspace owns the CPU cache maintenance
around GPU access to these buffers.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
[ Split the BO_CREATE validation and add the WB_MMAP flag checks
  from the original. - Alvin ]
Co-developed-by: Alvin Sun <alvin.sun@linux.dev>
Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/file.rs | 25 +++++++++++++++++++------
 drivers/gpu/drm/tyr/gem.rs  | 18 +++++++++++-------
 2 files changed, 30 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/tyr/file.rs b/drivers/gpu/drm/tyr/file.rs
index 526eb1d53de42..9ed16c5a8099a 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -256,19 +256,32 @@ pub(crate) fn bo_create(
         bocreate: &mut uapi::drm_panthor_bo_create,
         file: &TyrDrmFile,
     ) -> Result<u32> {
-        if bocreate.size == 0
-            || bocreate.pad != 0
-            || bocreate.flags & !uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0
-        {
+        if bocreate.size == 0 || bocreate.pad != 0 {
             dev_err!(
                 ddev.as_ref(),
-                "Invalid BO_CREATE params: size={}, pad={}, flags={:#x}\n",
+                "Invalid BO_CREATE params: size={}, pad={}\n",
                 bocreate.size,
-                bocreate.pad,
+                bocreate.pad
+            );
+            return Err(EINVAL);
+        }
+
+        let no_mmap = uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP;
+        let wb_mmap = uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_WB_MMAP;
+        let valid_flags = no_mmap | wb_mmap;
+
+        if bocreate.flags & !valid_flags != 0 {
+            dev_err!(
+                ddev.as_ref(),
+                "Invalid BO_CREATE flags: {:#x}\n",
                 bocreate.flags
             );
             return Err(EINVAL);
         }
+        if bocreate.flags & no_mmap != 0 && bocreate.flags & wb_mmap != 0 {
+            dev_err!(ddev.as_ref(), "BO_CREATE: NO_MMAP conflicts with WB_MMAP\n");
+            return Err(EINVAL);
+        }
 
         if bocreate.exclusive_vm_id != 0 {
             dev_err!(ddev.as_ref(), "BO_CREATE: exclusive_vm_id not supported\n");
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 95e5537e7174b..21b59690d1fc1 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -17,7 +17,8 @@
     sync::{
         aref::ARef,
         Arc, //
-    }, //
+    },
+    uapi, //
 };
 
 use crate::{
@@ -63,13 +64,16 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 /// Type alias for Tyr GEM buffer objects.
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
-/// Returns whether a BO should be mapped write-combine given the device's
-/// DMA coherence.
-pub(crate) fn should_map_wc(coherent: bool) -> bool {
+/// Returns whether a BO should be mapped write-combine.
+pub(crate) fn should_map_wc(coherent: bool, flags: u32) -> bool {
     if coherent {
         return false;
     }
 
+    if flags & uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_WB_MMAP != 0 {
+        return false;
+    }
+
     true
 }
 
@@ -86,7 +90,7 @@ pub(crate) fn new_object(
 
     let aligned_size = size.checked_next_multiple_of(PAGE_SIZE).ok_or(EINVAL)?;
 
-    let map_wc = should_map_wc(coherent);
+    let map_wc = should_map_wc(coherent, flags);
     let bo = Bo::new(
         ddev,
         aligned_size,
@@ -118,7 +122,7 @@ pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice, coherent: bool) -> Result<AR
         ddev,
         4096,
         shmem::ObjectConfig {
-            map_wc: should_map_wc(coherent),
+            map_wc: should_map_wc(coherent, 0),
             parent_resv_obj: None,
         },
         BoCreateArgs { flags: 0 },
@@ -176,7 +180,7 @@ pub(crate) fn new(
             ddev,
             bo_size,
             shmem::ObjectConfig {
-                map_wc: should_map_wc(coherent),
+                map_wc: should_map_wc(coherent, 0),
                 parent_resv_obj: None,
             },
             BoCreateArgs { flags: 0 },

-- 
2.43.0



