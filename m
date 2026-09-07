Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C68C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA9F6B00A1; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5AAC6B00A5; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87A46B00A3; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 916346B009F
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:48:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 16DA9140171
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:21 +0000 (UTC)
X-FDA: 85187549202.23.D7F89CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1C988C0007
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:48:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KLmJC3S6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799699;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DfEr0aIVioXmboiTfiVkLvLBdip/sDfqm0dmXwfuXTU=;
	b=5C3ErQKKQJwHurt4DqMu3E6ldmBXznyqTVLvaBnFnoapC9BUm3OcRbd+x4k2bAM0hhiisv
	epJxcLSaME2fHN94GQC5DUUQsCpbb7KW5RnsPMvdS0zqIb9iiL0qxGoWB2D0xACjTGMl5Y
	UT12MCjXsjB5YRDGA0byn0h6Uwc0aoo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KLmJC3S6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799699;
	b=nPj1HQK+USUggPNU1QWfm25213h7scIvb+oveqnjPOluc4zsW1LIgUH0SLiwNvdNno8C5T
	JtNEVk29AQDvPIZfw3diGRad3SbbBGF+fZyf4WqQadjEGEpPtPzdmwMZDiNhqUOLVIMoci
	h07Ny0JLwK6SPm77KhC4lACjeQAsWq0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 182D9444EA;
	Mon,  7 Sep 2026 16:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ECFD4C2BCF4;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788799696;
	bh=BDSd5Sx099D86mwm18rAhbuJSuhw4ecU8Mnmm/h9BFA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=KLmJC3S6WLkI6fhAbR7L7TT+9DfgvWGJP5xTfCUwRBbmJP1FVbj88Mb1Hi0TkvRdy
	 znl+7zN2+dWI/HcxPgoIJz+txQjcPimA4fBkegIOQk0i6w8hsqisROH9QZkZoNbDpV
	 kQJvjLG5vaQQgsigD2eAH0WyosKQgghUXb36QovyW9/HpYhPVm0YuBBPgrvJpeGe/T
	 FCDWrruGEGjZvlR9lUtNxX05SaqBKfTvfgFm+Q4NdrRq10g8uOazYTAGnwBa+0198y
	 Z6Wo+2M6iN3Bw3VMg4S9Eu6hNHSNZxfjdCB9iaQX7jlF14PlYqGMhn8E0NoxJGj7FT
	 vvidE1bUQYLJw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8ECEC79FA7;
	Mon,  7 Sep 2026 16:48:15 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 08 Sep 2026 00:47:54 +0800
Subject: [PATCH v2 7/9] drm/tyr: refactor new_dummy_object to use
 new_object
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-tyr-ioctls-v2-7-88bea777df67@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788799692; l=1566;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=evnUd0qm9ZwiYuhFDEcZYkjsD1f1+LG9OpRwEzX78ag=;
 b=DG8IaoiUFgNeMQe7P8OtUnLRSOFxuZi3gspovlvUFIJefp+Si1hZwHIZBN0xcP6q2w1y7skod
 SU6JBf12LKxAx8UhwZQ7btB/EOoS7CSkSoQ2zk9aUU0lIOE7Va2JyiU
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Stat-Signature: nhjm45b9npwitsyfw94cb33ipyguzano
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1C988C0007
X-Rspam-User: 
X-HE-Tag: 1788799698-144277
X-HE-Meta: U2FsdGVkX18gpxkSWr/C0Z5mCjV5qIteLQhqc3356DLjqK6owK+vdNZEXBcInmcLh+rroZN1WvWRoygrXeGPsL/6aR703afa5PfTiO5jpm8KwA4/NB1oaFDkEXHPaMouSB22Tj5hOagkP5qwQ3ZyU0Z95//rsix4YoKg7+J/VLW3LoCZkzfa6ufKmUPB1Trm951xwOCly2Q6D2G1NCO5pDgb8FiaFpvLOat3So9onSGygt3rJRlyUi0OKH5fsFrBCbnb+VIRQMXXFxD8UrVJuNWal27Qh4dLJUkUI51yW9qhU/lm1Box/wGJqd1cjHqnf83osdFALiLjqzY+h3OaKwauDBhwFfLH/ShJwNpS8Jzk7iPiVv9zkyYX0MdSnwfe0rEcdn+EptH//vMhEbPgTRJj9TndeRUcy2xz72HTdvL0ES4IzIcw1vZbJocwGE7y5et63yIQZqc9RUA8YZlm+loK0++27yjA2Tgep1CjYanwju6YvgmbKrUrB5srv4y4b2UCuL0gMhqEJai/gDUiInVO7qlj3jYqr5u28qcD4jTTv/DmJu/Bx1KrjcWETzVog5TXU36vCyZhhjJBAjjqz1gIB6NvSkcAQ7o+jEA1r3tDf9RbbvNxTKyOqw2tL607xg8KV58xbt844/V5SLidv5nIGNAAxJd0ay+6V4Jkqko/8zgwGfN5qojsfIkLC+l/txOr/sg5yajNruIo3hRvJ4UFyBhm0VajMCCI5WbZFLFnBnkI7WijaBnpGC9HCZYF3CHea0XwkgBiHh112W/9PT6K3ERja9ehbbhEBDX9nrUkS/nTPikuHVpKeH7PHY80S7onHLKnZIWnwlksmxmi7RaGnnmIukAyI52h+lW+ytF4r+oHHaol9j62kwVfX34EHPpsDp2jvH60dJkiO+x/UxsVld8xucz2J9JUSAdMdugo4BOM3IvKSXnNLOSXWzik4Jn62O6NNEJpRpwVqKD
 rZkr9kO7
 Ox5dDWEnbYsWRcmN2jYsHY8ihf2th7VkbhhHP3/l/rhs5ytlwfu+yp+6cyfnUqPoi5VYmB8WcjHrPk8wI3T25RhKtocrBIA0NCal+/3y7db4N0lhMuqIQX+AiQGN7p+PUqnA9uNAO++c3V2lLm8ADD1Q4vNDBT78O5EJtw0tLxAa8A55CFrpgeroqYO+zBxI6XC36VQIOWVSGOZMAvFk9AFyfTqh0lnYFH6TY4P+RcsvV+RL2K7Q9GI8iVLFo6XH7cYB3koUzVvtGWCcD4hFaHulj5b7pLwtyrFOdSGIli7M7XwY0xsUT4GsRN5mRKL1+k3xNllAKNziPDWkINqqeugBpX2Wp3rX2Tz9iJ8jOu+D3i8P7G6GgsCtc4YRwPX6HZT76J1c7JQwG6DnOgZclgJT9PhxiCGgq/VrLVzgxeo7T+5GDjV4GPp39d1M/jrRsom5vNcJJid/pxivWDt7Dl+UiiOQKvxS0BUtQAyRJsY3AmwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

new_dummy_object() duplicated the BO creation code that new_object()
now provides; call new_object() instead.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
---
 drivers/gpu/drm/tyr/gem.rs | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/tyr/gem.rs b/drivers/gpu/drm/tyr/gem.rs
index 0e0989a48678f..2523d05de5527 100644
--- a/drivers/gpu/drm/tyr/gem.rs
+++ b/drivers/gpu/drm/tyr/gem.rs
@@ -57,7 +57,6 @@ fn new(_dev: &TyrDrmDevice, _size: usize, args: BoCreateArgs) -> impl PinInit<Se
 pub(crate) type Bo = gem::shmem::Object<BoData>;
 
 /// Create a new GEM buffer object.
-#[expect(dead_code)]
 pub(crate) fn new_object(ddev: &TyrDrmDevice, size: usize, flags: u32) -> Result<ARef<Bo>> {
     if size == 0 {
         return Err(EINVAL);
@@ -84,17 +83,8 @@ pub(crate) fn lookup_handle(file: &TyrDrmFile, handle: u32) -> Result<ARef<Bo>>
 
 /// Creates a dummy GEM object to serve as the root of a GPUVM.
 pub(crate) fn new_dummy_object(ddev: &TyrDrmDevice) -> Result<ARef<Bo>> {
-    let bo = Bo::new(
-        ddev,
-        4096,
-        shmem::ObjectConfig {
-            map_wc: true,
-            parent_resv_obj: None,
-        },
-        BoCreateArgs { flags: 0 },
-    )?;
-
-    Ok(bo)
+    // FIXME: use a Rust resv-object abstraction once available, rather than a real BO.
+    new_object(ddev, PAGE_SIZE, 0)
 }
 
 /// Specifies how to choose a GPU virtual address for a [`KernelBo`].

-- 
2.43.0



