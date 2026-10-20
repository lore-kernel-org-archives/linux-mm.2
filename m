Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE28F60A380D
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LbINRPiW
Received: by kanga.kvack.org (Postfix)
	id 00B8D6B013A; Tue, 20 Oct 2026 04:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F154C6B013E; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D40666B013C; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AD49B6B013B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2BFF3408F4
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
X-FDA: 85342321302.24.4E74EDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E6C5180004
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbINRPiW;
	spf=pass (imf16.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484749;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eN4JBX5Yi3bsMUckUX9jCNXAb+0k7j4yV01QcPouoZA=;
	b=IQpFzf+fbcZShzXheiwFiQYNhmpnsd2gqpslpP9ftmAW8I6bL8oupcI8YySkEpHJwIRYsC
	lydjLOV91paXxOXfNTtbQlVN5xGpkkc5TU1UVqOvzLoIZsT+gZWBk/xHXnGBJpntuZMUxR
	8fbTw3LXjxFTNHXpz3h7Oa9sjB/27Kg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484749;
	b=WoZ6nwXwmgBZ0Wb/TMi0jNYYKqZRxfKDXkDJbKQx8vhys3zQAidY8L3ysBBWYWfES7nZv6
	x5ns0dcyc8urDAhDALI/b9SxrOwCLKZD70QL25aCf28fFw7HIV/vN0sL3PrSUmaRgGgDZl
	t199WtZlKde22bOu1odTlf/12FnJ+M8=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LbINRPiW;
	spf=pass (imf16.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3D5C343E58;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484748;
	b=QQ0CEUHSVT0A6fnnSDsep7+A/v69VbvPnV3joARpB5GY2eW0py9boq82qzSbbGAl+/SN
	 RxCWGId29C45QUHTKTaGclaSNsx42uVGF7MiXltInVHv1jMoMJhNvLRmUIdlmmMPPD+q9
	 Qzi0Y7nqZhBBWSkSN+6UyzAFTXHhf5kfG7NyIhl+uWad7T18yM8WQ8yGrZqjSnuzFKi0W
	 Uxr0sNJyrFZl9kIk8HN533Ht7PBY9nQ65NZBpbv+6PGDhtcWKzVZj+dYn8CTuZJsSCw7e
	 JsSOce+BReOuJsS2fqCrg+Yrk2hKDHpVxwKKa2vgUjlkEul6RTKm9l62PSPImtCc7Aw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484748;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=eN4JBX5Yi3bsMUckUX9jCNXAb+0k7j4yV01QcPouoZA=;
	b=fDy7plA0OASev705iOhSQQv470CpsFQndgDsoXBgUqk2vrbM3Kse0LmqE0q+2YEQ7uQH
	 7rBds3jbk1KfkDleuMgp5uU3C23EkFSmu7KGl4vNjLVrx9mUrwPhAKc46vrDjPCoSHM+b
	 jXRqdcFLAUMCUwBHxO7eXUp1rBOFS4fu0+2FmdSHvrkYtIVnpRMaCaJ8+x1lVQNrbHm01
	 +VRjmHF86wTikYRazg22Nrn2zSPuTU3wTPIY8GZeYHjWMFEZ+JqAXQV9O8qsEn+XYZghy
	 O3vB1/5VXE2Dq12aPm8upRt9nwY5F0XpVZHq5LoY9lzACb+L8VrvXBOGNANkREBb2+Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7190B1F000CA;
	Tue, 20 Oct 2026 08:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484748;
	bh=eN4JBX5Yi3bsMUckUX9jCNXAb+0k7j4yV01QcPouoZA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LbINRPiWNRT4+LzE3Xuy0a0LNe87uvyK1l/Ed/MmFZK80+il9Ia7twW6DTG+OIYy0
	 Xv6Ut1vv4wySM3ZGOSDyX0wQpLBzrWIQ5VLRdRZwojqGiZ4pmA0DESOHobOSly2ZlE
	 34X0yZMUV8gkFUpiaUWWg9G8eWh0v4vWsX+WwJM3aaEenLHrjNx6/kHasmRylqQ+t3
	 VxqiuFceSOdnsl5bIeVyc0B3cLd8M3fDFSpflCvQ402tWdUzBX6tiacb78dnBcFhhU
	 jC8Mvu6y5NrYssQIH7NEq0QYBUd4HoVQTG+Ew/mT2XZN9U+xo8XgCC/BTYzU+gh1HQ
	 g/YBI+eDanH8w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C7FAF430E7;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:23 +0800
Subject: [PATCH v4 06/11] drm/tyr: add BO creation and lookup helpers
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-6-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=2048;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=NWIPbx+eohkv3FNLcTsYqaXCTEHpzUO212X/sd33Vuo=;
 b=3ajd9tKpWFuQQjti0zd8w3s07U2VeQ8WgEY97UG0waNHuy7WkKZ2mqeaEaCdFJ4AX3To52G4t
 3p42+nfl4aICwEEhmKAqKCBpVcMI9C/JJ1KK3WdWi9Vnx2G06rTvChT
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0E6C5180004
X-Stat-Signature: paqcpuwczr74oxgmyzc69n94xaonymmx
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792484748-510646
X-HE-Meta: U2FsdGVkX1+sUYq4U2qPHu/4jPvLuQXdhdKW+GG9a0McKATsCN4obTb0ggCbA6scJs1FR2gTNPOzhsBY7Xzngy+3bdEXyiO8FeHtHXbPPvIIJLYnWGAi4LntLnJ/0op4X2QbMF9d96Ef9bk2bWh3f6Yd/4NXTanWJziFiNwIigFefO9W4vTxr1W1q1yFtw39KC7+XhRclhq7DvfscWuXruMx3VUpwSyQCa7fYdNLVj2QMGHtFCdCSfuwbCoKK4Kn3NQSdh0EQto/UtIu/UqLwEPJsBGyved1/W06F4Ug+SHtnJ5lVEPxkvwN8TMiI5DHKw6R5rykMs6Lf1hkHPohVfpcrMznMmToq/gvEhh7Zp0+mPI8EVS99afr6c3vH0AZ2gt9AhmQTGwOLIMTWSlF9LoncstwkAXnfvgiwpphSlFPcP1F5SqeowZtO2Y/FWpdqpGbrH97R7I8xxxBEYTwGStNWAhWgRcSjJ5BEnl98lqlcrpdWx9580c8NvgthcbE/QeZ1gd07wmuEJNGesa5nspdSgqkZNlIHiOnVrbo6ILJ57xVCVG6sBS2hFtPvUdmDu17Lnxp0pjkNiToEVhRFmRr9CXiIzuTBbn2c5Xu7Z5b69TvoDlJqzX/1AITBPAcS6N9Ztx+5OdlTqWCQB63ETafWS5TiXvDU1nBV9rm/RZ6aBgbVfls0bb7f7y5cKUAtKGC5q51ffXOD9r4dAwxU9/DfBgyKbI/XyK+8Sa7nKK/kGujL/HwrysLdslDMvQ7kqjSf3E056RCPni2XXKSDHtQT1etwDJ71kJjIjnm9R2kBwkla7aRdXVI1A0/j8DjNo4aZZSTRkyK7hXU89IC9/STF0R7Z3miCvd6nKu0Slvc5iyZyUEqNFx4z7/0afWleJaUpIIrH61wg1Le2dpX/86mUjPSeiSCsxjx1lDAMJVNT1CICzo4fsE+yerrsoql+P/pMabVJ3q933Xjtuc
 54MuJFNY
 E3kpPJHrnkiUl/v6GhVIYAxmt6Q5kM/TWsQeYfIJvlon9VgjavQMOiSkU2/08iLgCHb/Of8u+hFts0aIyxWMkvRUNEZFmxA837TBQKkmDO8qIGsqdUy3nycsPH99oCO8CunnLK//trZGuCFm3O+jFlDdzORq23ODUGdMfXMT81aji5pjxf7/ZQZyd4R6xy3ae8DjLEDZPbuJqRXGFk92+Eh1fBLwL8XDhJnZcJXzqm82Y0mHARu0yJsgVlHb4EoL+X4hsuBKdPDuQtwwDRvhjZYhWh+R66HmJfs1BAhqAVVTaJXpGYI+PCZA0vdfqFRfVBOmyRovLTdUs2dk/EtZl0dR2Q7+PXfLrII+dKUojkMYJ1zWH+fBRg7dJOk4xWszvmvKEYfG3ySAxZg4wEZR2QMfBzyhp0fC7Ko8+O1ydjMRTKpRuDoFp/q2w87Rq8fzWipZcYmo/C3PNRghiRcoHhZtvAInfg8wSFlbh2dqPEQTnB+7wmvd9jVTTslY99V4X2lcm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

Add helpers for the BO ioctls: new_object() creates a GEM object with
the size aligned up to PAGE_SIZE, and lookup_handle() resolves a handle
for a DRM file.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
---
 drivers/gpu/drm/tyr/gem.rs | 31 ++++++++++++++++++++++++++++++-
 1 file changed, 30 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 3bf3787f5c3fd..0e0989a48678f 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -9,8 +9,10 @@
 use kernel::{
     drm::gem::{
         self,
-        shmem, //
+        shmem,
+        BaseObject, //
     },
+    page::PAGE_SIZE,
     prelude::*,
     sync::{
         aref::ARef,
@@ -23,6 +25,7 @@
         TyrDrmDevice,
         TyrDrmDriver, //
     },
+    file::TyrDrmFile,
     vm::{
         Vm,
         VmMapFlags, //
@@ -53,6 +56,32 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 /// Type alias for Tyr GEM buffer objects.
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
+/// Create a new GEM buffer object.
+#[expect(dead_code)]
+pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result<ARef<Bo>> {
+    if size == 0 {
+        return Err(EINVAL);
+    }
+
+    let aligned_size = size.checked_next_multiple_of(PAGE_SIZE).ok_or(EINVAL)?;
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
+#[expect(dead_code)]
+pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>> {
+    Bo::lookup_handle(file, handle)
+}
+
 /// Creates a dummy GEM object to serve as the root of a GPUVM.
 pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> Result<ARef<Bo>> {
     let bo = Bo::new(

-- 
2.43.0



