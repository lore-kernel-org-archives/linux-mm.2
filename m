Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABC8AC624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 23B8D6B0299; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13ED66B029E; Tue,  1 Sep 2026 12:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0066B6B029D; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B21886B029B
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2C7ABC0461
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:22 +0000 (UTC)
X-FDA: 85165678164.12.9884E0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1C07B100011
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IDvXcKZF;
	spf=pass (imf14.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278960;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jf8go+UrLuJip5w4eQmH55l15Z4tah5pQHNegJk+g0=;
	b=UDLBOO6rZU+msrGIWa8LQY8vTX1MaNhk5VG4bbyJVGQSHvS9ItrQVnRbnPpeWoZyoIDUv8
	Be85ySNfSkHvXAh/ag/wZJJu4Asy8Yi06f5nO2uCG3sZ0O4wBl1TXnFZkN25uugrpSgzK9
	dl+sLL8p1E9DJWHWv95cEQd0pU3oiXg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278960;
	b=xn2k/mhBorfv73eS9CaDaimTVYqHGZB5Cbij4YyUS1Q4Dlv4K2ESPg0HAzT1XD652z2QRM
	CYJDAZf85et9vbqSvm3M38qpMNVhukxng9mJX7RiWVUspSQb5bUPe4Q3CaU4FQeUBP4D9d
	CBTqbC7UymkDyCCOLI2wsW7LcJ5DeTE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IDvXcKZF;
	spf=pass (imf14.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CA083435CF;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 98C79C2BD01;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=HasbAbiscgkB/JlAaddXUmrmL9X8xBNF+D/Mcih0n8o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IDvXcKZFF+vOqq/a8se+Fwjyyj4ZeLXSgNdmjkYAZwbXFaXOraDptqSv4a4vAnn3f
	 6o3MM8H5Kdg+mlZngaSM1nNzpdcngSqgPVlwMqSELFnSZORwGJOvo1a1w1BlScVFUg
	 G2hyzPoEVIUzT0rvy8C2RDxDERdaoWADKxXLpue1dsc6X9AJXwKn9uTy3CJxGONBj1
	 vLKkgsdNQ5xhbCrJ0jN6sc/m0AaNtoDyMbZt3/aRqRwDYwWqzV/umUQz9B2ZkdxkfB
	 NDaXnsHJxweTIqJ99ckAyMiOmmLT4vNWKPc+bHaa+0mHQZfWejQSFPcWB3zxC2FUyZ
	 6V8mPS1T2fpFg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85208C624D8;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:05 +0800
Subject: [PATCH 6/9] drm/tyr: add BO creation and lookup helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-6-e0fdbf8bd108@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=1841;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=abNwTjK9PrYCz2ItiXXIoKFGbxiH33YuD8UYsvPqLiI=;
 b=Uex/3W0EyxB0gcIL8eWYA/sjQXzaCiLpc+HrvugLg0hsDIo+bbu6Hon1FX9UroXbEfvMh/VHJ
 pQSLU4FgRc6BySPUkPs/8YHeEOfNFFzyRJi0GtpBOWJGbhyaWeskyvR
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: ai38qaf7y8hddmprudej1wb4hc5ycqpx
X-Rspamd-Queue-Id: 1C07B100011
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788278959-60758
X-HE-Meta: U2FsdGVkX1/XSVllbadYja4wqTAhhue1VQ58tjYGkf6oIQJeGIYSmnBGFbnNnF6MzpejTgZe2c1vXdfe7VawlE5G3HT6Q+uBeExFi8GndWg/2HzE+3ZGtJcj7oLS+7LbY0HYrB/wgXCHLGeNdD66jW15JEUXCcnif/p8wYU+yzc5OtWwgbSPE+G+tACENvQnAN+ZG6ABHCguTx4Izu7P0Nt5Bxrtv91lkTBYlIWyeXTFwHL0TXZHin2ViqUxLkg4LwNBfijMVB9Qb+sXGZr/ftWX481ywsQfnLnna957H38NhrOc4AK5JdF4X1Sl9oJHPFsOvP1JuGSdpAqRgSE8DA7tiqwFuVMRNrAJVEWYC+IOGu1pyQ+1dUfWSZgtDFBLMmotAzG2cHkDuKJ1bwZIpG3MEpagWUjX8zx9qAHBR4jYHRxhTmFeJLZ5v4zGb/YyG5veGWr3vhX/S7nV5dG63iY++TC4SpwPrqjoiisoI3xjRWRlNcEbeeaSs2B23L9uQ/NaB31u3LzLDwYphichEdolZqtOJpQI5aSpzTi3qFL3eRyMZEJz/sWP3ybpwl9KiKcyiypcjI4RbwoaS6o3JoWXORbfy4vyPRZSQg5859osmiD/4spAjMztyp8xDeaLRi+/V66gJay8x+1X8cFSuBUiCfdMU7V+FkF5MVRA1vDvYDWUFCgunhPSlIja1NM0Iy4bjKeg+JaLJqIjs6isOf8SpWTUGlWUOb86KwSToaGtM+UOC84HoahDCwyqcfW2PcWdIBWZQReZaLtgWOIDRZc94IW3otHPR/t8y89Vi8F1j+q2lpNKsQ6jorqSWS4Z28XmFHt/QpcsWBwEk338tTiP03D0OaAKAH1G+I4aQKiIgjSTeP+kgwS/ZuqrPnB8AfHYuWEMu4giMUWUpKKYsTb69qN6HT26g4FD79vZq/qH8G/cA1Kyps83uGtdCDruMJ/hGegLt6V5c6lcwWI
 TRBfGaWv
 ghNIjk7AXULq1g2SbxSRfOV5Wu2ijs05QuABDVA/1JrwTrsWA9U9E5C6uouyvUa3dB9EkppN8f2Qn5kBWrOJ0vI8GgV/CChvKjIG6XEH+9C2qwZasKnj67iRKPl3TUfuWnyHG4pIFdhJiu48Cho3wNs62g2MvUnSWDehZttCqw7Kvsuf8TmR9R/8YBGntfpllYazWPwsu3VdYUTveYoNwHSHCWrfHiKorOaRXZXYemqytQtSv/3HNUl1Ze8K2ebmgckwy+wc6XNzIjXOPGjxf3NKebDDqHPvx8G/vSAoaqiKsYrlyEDfdWisKglqHG5pWdP0VRVu3mBiwgf9qUqF6twU3HYWKno1Y/BHacuQ3SJtiuBihJDjZG4fbowyjVbzTboNA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Add the new_object() and lookup_handle() helpers.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 drivers/gpu/drm/tyr/gem.rs | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 3bf3787f5c3fd..be1affe80db1a 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -9,9 +9,11 @@
 use kernel::{
     drm::gem::{
         self,
-        shmem, //
+        shmem,
+        BaseObject, //
     },
     prelude::*,
+    sizes::SZ_4K,
     sync::{
         aref::ARef,
         Arc, //
@@ -23,6 +25,7 @@
         TyrDrmDevice,
         TyrDrmDriver, //
     },
+    file::TyrDrmFile,
     vm::{
         Vm,
         VmMapFlags, //
@@ -53,6 +56,30 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 /// Type alias for Tyr GEM buffer objects.
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
+/// Create a new GEM buffer object.
+pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result<ARef<Bo>> {
+    if size == 0 {
+        return Err(EINVAL);
+    }
+
+    let aligned_size = size.checked_next_multiple_of(SZ_4K).ok_or(EINVAL)?;
+
+    Bo::new(
+        ddev,
+        aligned_size,
+        shmem::ObjectConfig {
+            map_wc: true,
+            parent_resv_obj: None,
+        },
+        BoCreateArgs { flags },
+    )
+}
+
+/// Look up a GEM object by handle for a DRM file.
+pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>> {
+    Bo::lookup_handle(file, handle)
+}
+
 /// Creates a dummy GEM object to serve as the root of a GPUVM.
 pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> Result<ARef<Bo>> {
     let bo = Bo::new(

-- 
2.43.0



