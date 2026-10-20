Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F2960A2613
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=EeJgI8GH
Received: by kanga.kvack.org (Postfix)
	id 7EC686B0146; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E636B0148; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B9A6B0149; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27E486B0140
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A06B1C08AB
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:53 +0000 (UTC)
X-FDA: 85342321386.15.1C9A73D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7896E140009
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EeJgI8GH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484751;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GXUuCKtgp0cGhSwy/ojXyLE/iLRzYAr1n22ymcMALbs=;
	b=bMWBSySUXA9F5nvkq9rz9UyYF/7GE1i/Z23aSie7m9/zONHlxXovPa+IQw/IHhKEKWeS4p
	Ova8cUudOhFvZs9DRsXt51EeqzgsrdC12A7wG69nR4/DZLVmG9+6Ojs6cIP/1qoL3SPlmz
	XgO/Wo9De4ND3RBU1DJ20c7+pfyQkJs=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EeJgI8GH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf26.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484751;
	b=VhjpdVmlOsDwZR1Ck0dt15v2FrThd+OZ/cizYxShOX8kMomRfLyL0WVPIOCA4e/pdQGXxP
	ZSx/z0R12h7HymDDxL8/wW4VK21F5AwoPvSCeTupDhJoHCO8NkHozxZwxMzrsHP5W6pv1K
	NoXjVxBRu+snXKbLESTKLSHD+5NgLxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E4A044505;
	Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484750;
	b=TcIxXtWwOjio96UiorJH93fjTUpLmlxXeqz8+ltdPcbDJQekFQAsP/auZlMZhTjHtxDl
	 ih8u6klhrMu0HFShD4nj97Bb6LpiM0pyVCggWxx5esbuQEZpb+OaUD2M2xrDZcSJx7/pX
	 o9rOFy0vXzmnzVHSz3ik2CH+GSUF0KIIzZS3ZdAjf+8dI1YS/2Z3JO6V+JhQs+Gfv+AqS
	 TiDSUKn1fe9at++Yk45kFYtVgQv9Sl93DB9Pbc2MxHjISlIOhiWjDntyb66x4wP9DO37+
	 jbwtZvkFjGS+BbJrFUZVGzv28C+CN+wMqOk3G0WRlud00F2GjZ+Zr2R2wQO2/gSMvDg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484750;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=GXUuCKtgp0cGhSwy/ojXyLE/iLRzYAr1n22ymcMALbs=;
	b=HBUnig8m8NmyvY8yhag2FxPCPVZfWJBpLe6ailndH6eRfiagjTBANXOiT5Hqrs8SF1ES
	 zuvYk/OzCGlY55hQgPPb4H5GYZAYlPJa5V7JJiZ8skt7CnhIiNyq6vhBP+4j/Coa5mSul
	 PeJjClbYyVjRbJC8YV+L4lxGjmDC1vgc/YZQ5dWnbCy4v7utD76GOPipeXnwt51V79iLr
	 D1UGgrcvJuhqClJUydoihucWTOyGNRAcuiaxXc71iilH+DL6XHNbfCdJ85jbHklp095FF
	 wVZGNeg2Y35bLS5k+ewHwxrjrZzh+wY/pXYn6q8sO5gd/yWdaGVFVGzP6SzXH06KRzQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AEDEB1F000D0;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484750;
	bh=GXUuCKtgp0cGhSwy/ojXyLE/iLRzYAr1n22ymcMALbs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=EeJgI8GHh0Y5ofvk5Tgq/sWHaTsoI10x4gfhp3RiiafF67bB4GoRtRnSAIdoCD7V+
	 7ozjCMHi1mjIEUYsWz/dNz9MmQrURNyHbvo4FkKDpnLTjXPjyDraqPmxo35kBWIqbA
	 dz3ZWINMXS4Vv6DWlohG28bljCEeNp313vZX9YHAxR/55T9g6831H0V+IYpvKKKbH4
	 PeLew44MQt0s4pPTJqNBLHomzFnNeIEFNnCFUsf8lejcomOzRWFK3tMGupI8Kjm5gy
	 RWk7xs/sLH8jU5qISS1TlmKnHcSIYLLzYJStRPPdmFFOv3EDfto9ZtXAHGXb2oLygq
	 A3tc7gU04MHrQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id EE0E6430FC;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:28 +0800
Subject: [PATCH v4 11/11] drm/tyr: gem: map cached BOs for
 DRM_PANTHOR_BO_WB_MMAP
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-11-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=4490;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=xSP6p7C7nG8SAdUfnGBh8hvRVeMZVo3JIuOGc55Xvp4=;
 b=KXnckEM92ShfUqbTCFUY3Dd+lpU1QiQMa/voimvL5pnPLX5XTsVC3uXypITD/hkM7JWStLlp4
 r0zPeNTI2MPA05n0IG8yhJwaidkg0RXQxHrtMoSaCkA38JoSYZLoQ2/
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Queue-Id: 7896E140009
X-Stat-Signature: oo8zxcamjmo9w8cp88mhtwo7gyanfdtp
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484751-501175
X-HE-Meta: U2FsdGVkX1+iue91YtkosdbQuu2Y8Eetkt3v70Wwagd5wQMO426ngdSMruJxHIzW0i33M32RnGd2cHbmgbbcw3rldo0QLt8o5IlRgPOq/eQMQmiLYrupeqoy7YkbMcpasrkozpeIj9ypzi52tooaV8PPLsgMziDAIO58lzKDPbVpzomFlPGsHARM2Jam92XHZ8UL8LSOHvZFhAtlkfHtlj0joYYQtJ3gTTdPrahvf9h+v8R2WoXwx530DB1BJtdQDaP6G/XTBPGXsNdNfub4EpEVv4qPooeAinsY36vlIGFkx4tfhAheejJxRvRKPJmerL6JLTVCDn6v6PF6LheYR6W0zlQeMJRC9jXgXTRLT49pWglVyNDRuabeWO8toodcAaK8SFaN8mSInMPY7uofX68UJ2Imz/jrL4hX+nVHLnqbFwvIAwvTKCOp75R547ZWH2mDXp/fQWk8tV82ptyAkliNR5CyWoS1UPbDjQQN1VtAn9k8i1tVQWR3Gc7y8/ZBJpqRzjM+ebNTvajq632nWyR2pVNmRxe5IBR+8bnfXwpF7Zu5BmGzXqLjBPHnnzLX6SIBL1MsmD/uSpnuoO9E06TKdtXB4kWuinn5ELvFQGmbAxJEUnbO1VPDMwpDIypa1bLZh9BIZ3bwBJhlZnAb9mA7pmMVNo8XrI81BE3BoeIyMazabbX4EfB3OpJKbIzwaF/Zj/dzo/rJsmdeYeg7XwSUnGcF2KyDztwH8oSC4jZgz2wmKiKkwhJX60jChKan/rZ/jQPqnsPCz2MGxsAXmSBdleHz+2R/F4VVFSM5+QFqPRbaEOxwQS3WZfGmGLhUIunnfDqwRszEMykB/Doy75t6RihmVgQmVAObJXroo+cLZgHuA1PVKiXAcfjlY50i9HN8Sz3HsnUPfbue7o4ViAS2HYGjHt9j/C+fQchB0n+PWiyOmMlyZapP2LATML4bLPGwRVT7NWiDYaqbnLH
 Q2f8jEFW
 QNEsEVunup5irMV4sWLeRxSr++wsXh+pewhHgjCOuYuO7+aW7nY6W4oZZBbu8tB9dfE1927GJkSjD04IS9uld8SU+Tj83KPmmwLLQAt+zGWwA5AzwQFTjxxSe9YEg3X/Ocvn5ngK+HJYYSrjSrrv9xipp0QmxA3IhoZA64q6VTEwZixxH4QfhDsFgiekAD6oo3VKMVhvMyBQAUP9o1N2C7iaXAZCsR6f1SmUBJsKWJGHwOfrYV2GecMTl/ocseCR91LeKAfH5jhFHm6zBOnctYUVUb/RLFjquuj8KA6/63VPA8GlDYZxu53KQI3yhCoEoaAoDmOKuWHQc+8DgO4sIOFFwebtAi1l6xtHxO+X8TBYHeiaI9YNmPycUZ02VeH4jV31phvky5F56e74gGObMhqsX3NqTSXPz3V4elcwnCWDOmbeFhuBjz8GUaNxfrY6hWDYlTQHS8+eW4hVrBf0E+foM9yK7KCuj9kiRv6pjwGKTpyx68QwyLf64n+VVmNYUsNN/7wFu56yuGlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index d4d6a6742b2e1..6f4550d14bb39 100644
--- a/drivers/gpu/drm/tyr/file.rs
+++ b/drivers/gpu/drm/tyr/file.rs
@@ -258,19 +258,32 @@ pub(crate) fn bo_create(
         bocreate: &mut uapi::drm_panthor_bo_create,
         file: &TyrDrmFile,
     ) -> Result<u32> {
-        if bocreate.size == 0
-            || bocreate.pad != 0
-            || bocreate.flags & !uapi::drm_panthor_bo_flags_DRM_PANTHOR_BO_NO_MMAP != 0
-        {
+        if bocreate.size == 0 || bocreate.pad != 0 {
             dev_dbg!(
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
+            dev_dbg!(
+                ddev.as_ref(),
+                "Invalid BO_CREATE flags: {:#x}\n",
                 bocreate.flags
             );
             return Err(EINVAL);
         }
+        if bocreate.flags & no_mmap != 0 && bocreate.flags & wb_mmap != 0 {
+            dev_dbg!(ddev.as_ref(), "BO_CREATE: NO_MMAP conflicts with WB_MMAP\n");
+            return Err(EINVAL);
+        }
 
         if bocreate.exclusive_vm_id != 0 {
             dev_dbg!(ddev.as_ref(), "BO_CREATE: exclusive_vm_id not supported\n");
diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index fad0720ce7123..d3791b62d5a7b 100644
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
@@ -116,7 +120,7 @@ pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice, coherent: bool) -> Result<AR
         ddev,
         4096,
         shmem::ObjectConfig {
-            map_wc: should_map_wc(coherent),
+            map_wc: should_map_wc(coherent, 0),
             parent_resv_obj: None,
         },
         BoCreateArgs { flags: 0 },
@@ -174,7 +178,7 @@ pub(crate) fn new(
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



