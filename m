Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47B14C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 145206B00A2; Mon,  7 Sep 2026 12:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0790E6B00A4; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D22D86B00A2; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5C466B00A0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 28D9E1201C6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:21 +0000 (UTC)
X-FDA: 85187549202.24.C3A2F66
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 18D9C14000F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KAMGLi5G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799699;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+glEgPUaMq/IVUolJi4og9sx3JSPGF6OV2zZoaC1lTw=;
	b=JAsplcryWOQU2xJnuLd2LtKdZ15GEcL1CmsfTqlNyNY34zEN3g0nuV4sI56+hneWNDPIro
	/HHHOBBi2R9RVJazK2Gl89wRtebGB8y2RLyGyV9ueZr8xvAIjejlofXhxIZpGl7D6STAiD
	JhikUqptB8+Tolv3wW5IrbM6JU090HU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KAMGLi5G;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799699;
	b=2pckK01WrZx5beDo/17H1mfcWEhSmggl1do4NmnRFo1rHwIi13R7WeaYslSs29tfLswIDq
	kN+FSph0Q7Zv0bhM9L61Uea73suHUsVAKL3P6NY8MwMn2gcwH2JH9WlspAVc+OR3uft7HU
	tpqqND4Xq5+UvRhRnZe1rk/hH14Scek=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0668E44247;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D9352C2BCFC;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799695;
	bh=4fCA01lVKFUQcPLwCosahsFm/a/A5bH2c66xJdLxhxw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KAMGLi5GgpROMAvah1Ucb+Y+IL21IvaDpdJiE8Ul+O2TxxHOIRdxT/O/wCPc5k/I9
	 TSqJbTGwuvG4tc4EEKCrhNi1xR/ekQ7i6l83cwWkaiXbsbU6lnwNTtf85pXrb+zcuR
	 ZKCrEEJKcsWrZDNCqRem1AeTi+IjrHOpW+W7xvY5SrQhPoM+o86gDnjdH1f5Qof78n
	 4bXtEfP+UY+/FufAXd2FbQVsID1H80OF22owjPCXXf437vJYjXvRnwaKzUomZkPlB+
	 XgcI7Y/TKyezCP0J8Z5s5yCyI2vb3zcmDCpNS24XKzLstVjv82gRgV5hwpjf7Vtyqt
	 CsjM4IcUJHdog==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C04BBC79F99;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:53 +0800
Subject: [PATCH v2 6/9] drm/tyr: add BO creation and lookup helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-6-88bea777df67@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=1988;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=ZYb1XxhHAj4Uxqn92uytJJHTXG1ZVMUU2ITsdjHTgjA=;
 b=Ac0h3eZ7WiN1yioRZwUbNwv6tjKWJCM+VnK1K8IkRgMNU6aUq+XgAgFZy+Qae5/H0qO+9UORF
 Z5pYeSYrTAECeTmOw1OTsHafHEvs60gsXpXcADXZD4HADEuTUpyXsfK
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f3taiib5o4ap5pfwy8irouupaoxzawhr
X-Rspamd-Queue-Id: 18D9C14000F
X-HE-Tag: 1788799698-812113
X-HE-Meta: U2FsdGVkX1+YhkzpIzuVRc/g/YBMZrsfCEznaJ+Rye0wbYGQF8T9Dvqt+iI8kQ5pG5eZb2XJSFJqnMdiEZl20c8BB1S3HF+wTl2lQQxilGK2CTozC3ieYWLFRJwabDuG/CZuL12HVxpOta4nWW3tmK8UIJXVL/UoSDa1zj4bat/IPJUEA574nP+gNRusaweqB3tnlEYEDjZYXX8El724GaeKIKdSsgIssg5ddBb8FFlNscFe60rCueN5IBdp8R0Pnew0Me/jH1sAeK7FSTWuRj5w4mJxeMsGyT02xAKlLY1O5FBaJpoedhtOeX5rpYbzThcW3Er51XIP31LcDfPF9k0jynE4bJHRAUcBWdT3vKvUDUmv9Gk6DLjJxooiCQF5u93fO/Gp2nq0lyaJFNy19NE950+zOXh5QLpjN4PtI3k6NHwtGb/8BwxU9UKAKxjIHvvI6v7EOiICfdMfg+gcwMt1EHX7dVJA78rAlB21hZ0TfC84Jpcm6K+Pz5f1Q7NYQcmFyyAfF35jtR5p/TVTnm2xIzD9RaCx0UuKIW2MFa5T+dLhkL25RzwsBZ2LOwsGUM8IgfABI1VwteHmNPctXXQCeyz+SLnS/w8HE43f3wd/7YmuXDNebQVp84vdPyCPySl9gsKnTYU+dbZKYTOQ0MdDKO5y8mB7Rn5rFn/rpYYfU3nFibKTK/N8LQaWJsXDiFNc+pQLr1i3u7AN3Dsi+2grEKs2rZQzkYktLXsXFRT5nOM+wYdBOBGfdxqeeygEf2CDTsYSXzGTQB0ME02UMEgZh0v6+VgzQMYlnd8Fg64Ecth4aPQU29jo1II10I8uywgwpb1O8Qwoc1fA8uJYG25LfJmSLvpcsLVapfHmql3vYAoCF6pGK1hY//VHHnIqX04zARltNvte1gOyWpDH/FpBeivJ868FFTFhDf5gRtu8JB/u/vzsNj3DIbo4L5v9uf5l9yw3xvYPd6LbnHa
 /Gcuvtlf
 meWWNQFUqVd+UFPpZebMbKAxFvf0wqOWNxD+ypUayktMXae7KjBa/u4EGa64zHjVTGgEZKAaC10VHTt7A7eU99xZZWxTXIRfonGOpxpvm0H5rOgiR3gXlwp2x9k4vO+Xba3BAQWQ28oP4VA3FFSIkXqqiM6u/f67HZ4FxSkYmkOmu0esfRVWQVidEsOaP2G9fhOgxGzsgiDtKCD25VqJeuw9Ntex8swA05ec5u8delxW6cZu6KfWG1pIeBhFb4yYQ0k4fl2roWfVhTD2c3Zqc/9IoPjwHxxQ+05u0gzYaVziQy0nXRjFTq8U8eEidpXmADRfTFRVoeTKYcVEqI0AlGS6J5oQoypMgJhL9hCEzvkveHoM+cfuFaTwO3RV/oEqQAG1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Add helpers for the BO ioctls: new_object() creates a GEM object with
the size aligned up to PAGE_SIZE, and lookup_handle() resolves a handle
for a DRM file.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
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



