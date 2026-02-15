Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFA51E63F21
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 01:10:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C2416B00CD; Sun, 15 Feb 2026 18:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 889EB6B00D3; Sun, 15 Feb 2026 18:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A31A6B00D5; Sun, 15 Feb 2026 18:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5AB6B00CD
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:45:24 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE1E6160AD9
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:23 +0000 (UTC)
X-FDA: 84448324926.17.4A9A61E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1C247C0010
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:21 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rbc0r5Qr;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S5HuTidX/LrJZkAFhVUWojnVkTWowm61rgx0goTfQ2Y=;
	b=Y8z9IXqJoagW8bXo68JuTD1Y0nEVWoukXSrMj9Njf+P6h8kz/spL4fgWJmIXchWEpZtgwt
	aTYhTaBeCnMlOiPbxYGF/E+alPoTAek6mBJ6ayQIGhETLIAM6FKYBeuq0X4VUfzmlBNO7b
	x+/QIt90qdbis2Jr9NwstKDcuhpPIQY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Rbc0r5Qr;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199122; a=rsa-sha256;
	cv=none;
	b=U7ykKG8MS05hdtcYz0H8J59cPHzagzSJKNBv7IU7cxuDL41IcjOE0f/7eWvEqPL7ToEr5+
	yZiLP19zkkSbHi9zvYfiQ/Le0M7HY12YXqnmOsYggxwpibKz5YmN/CalKQJhYjqu3bczz9
	1NTfQW29wJmaJ1GtVVdA1PuLXza3Ub0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55A10419B2;
	Sun, 15 Feb 2026 23:45:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA85AC4CEF7;
	Sun, 15 Feb 2026 23:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199121;
	bh=eIKMKUHsinnjm6IdiHwgx8Cbg+4YOZ96zj8DP30QUB0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Rbc0r5Qrb7qkrPQNiJhEBZ/acLMM0TcAMN3AMncJp2J+dllypKZuVEnbEuLEdtPqe
	 kAkj28y8tQoORj03TgbhgyHxbtBUgTIg7TnDKh9LvzRQRpPa/kOlStL2AJJJcFlh2G
	 OBYUszJXkIqmN6LV7neooRwL0Oia03CB8TCbPZoSyqIrLVnAL/eY7EHgVrRiIj4jFj
	 cDXes+AKBsTL5FZJTBzNzPntyDprzHoOdcJ9oJcx3u1h7FwlVcfCk5dNe6CKebmC9Y
	 2IW7RK0jWDli2Qgl6MzZM65u3Uq9OI4AhCNXhfBwPOJ88Y7umYxeJot8XzSHbXVSXN
	 re0k1O/fG1qBQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:48 +0100
Subject: [PATCH 61/79] block: rust: add `GenDisk::tag_set`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-61-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1761; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=eIKMKUHsinnjm6IdiHwgx8Cbg+4YOZ96zj8DP30QUB0=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhSUpM//34bJGuIqeD4kIISe6J2+Xnz/36Oz
 i3Tue+aVvaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYUgAKCRDhuBo+eShj
 d2ACD/9agCA2MGNXTbdM1QI2Fqe0Uv4YftmLwHQmg3ttOb56ej/wO1bKYAhe0GN0qziAWopJau4
 o0v2t8yrPv+7WU6DIDSmuRZpgPzPnTRuoGFYQZ6Lh411eX8QrJxB2O7q8ifRdC4mFnbjtwDg2C3
 4fPmL3+dZ1q+993ilNfCnY0Z4UlN7HY+SQwoykInhH+N4AE05eaLRn46TUygY45VrAB64SUbfn1
 IajI0wymMUHYBZ+HzBY7g3eGoN0VYsdF+3DrIROzEEKGT1H8civF+vq5l5vOERuM/dNgFUfoL2c
 5CmmyxBVVkScEaqYEKacICSZyO1E3RYo8K6dway2M/RkKEqDTg1Fx66SAJtm40J6Ey9Aw6ItnVe
 EEmVReAdxwoOBGi/lmHD/PFLujWLvXcynBCLOzH2RSh7jhwhFUi3GHsYsExziyRzVJUhwG22D8m
 ld6ezc0wQ4S9YIKtIwU4AGc/KbXTL3kQRQnDff43cWlMCXT7msoIBuOAxCDS4x0QXOUR4/XHONr
 qbxDBnvXoe84HzyMkXKj7Rl7scESnbv0+LU67zAnYhfYYl4i4QRoTDxUuW17OqbwhbFFEyEkH9c
 IcqmDeQr/0HbO7kmpejntQgs1BLHmNyIbwFKOYg/soSqoUP/7EWEhaXufcHs+aRrSCpsmseuSe/
 Z4FtD6NOI8sKr1w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: tserfobnuis9mxd8pxpeq6dq636md9qb
X-Rspamd-Queue-Id: 1C247C0010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771199121-724825
X-HE-Meta: U2FsdGVkX19jymZdYrYu1CR3mjSOQBVRIt7JL8KC5pwZSEKqyRRG0+AkWXRZeOX9GC5M8m4k44rsjdykYMrNZjSat+3XtTq1QtOQR3ZIO+g92S1UTmkCo4Tl6t+HWF9LG705PfRXezhs/oG07XVUW8eF2XevtUGXT4PclgT90FpbJHXqKA7OOL8nDxdDXNcdK77CstNQpi027/g3t7faAoRYwjcnWiSl/iBSi80tyQbXvCGNrMDSkuyTDehIP+rMqrMRyp7JJHeZ5ozhoB/XEfAP15MeLG21kKCoJZhh1kqreSjdF6/pX90Mm4JVYbmdFJCFCYAlDtXRSR7eO+Qw3tkdtNoqxdXI4bWDvprCbrY8FlOkVq6rNXuhVnopl3wv6EUnIEvN4U3DBxQEgaYl2vSdca0hPXBf0xUaiehWyL4t2i4lCDL8KQXEXFdn12fYpIsnMzMYg1HaLfcy5oJirOLUW3zJn+p7bSgXAux8R4JbrdUSPTCOhK0EMqekFRGny18Ore7pczDdaae7RwxyUtd4jZoBOmuA/7UrLjwiBRplVMmk/1+y/EP8YdOqgF07gRI1aki1tOIWKm2Al8rooTxymO5+GguQuL2GH3ogj1AMMSN5Uo5igyKXBUd+wDmVKJdFnZc2oQsLrziexCboYW79YgBoYmqioZ2CE4MBT6Eb9xBOjjxvStzUo8I0YBMui7Z0AoqP7Di//4rar/dRFCuUI5txZmOMRr9/ORNC+vJoInWC660F0O3Hjn80kHJH2iLeWyoP8NGg4vs7qv5qU8TI2OUBtwoy606XD82F8QD6CcnKoVlYy9sgpSLnFekzxYyTxZErMtl9myU8hg3QDRCmKoREoID5yrYZD8NNNZTIdItO6UZyyjhTe/vklUYitpZCGl8ophHPIaCjKIFlakK6u94dIaoQMFmXfLiT8c45zhBNDMCE46l2vZ6zmfb5ZKh2aIGXctn6KMfGE5F
 vxAHDt0v
 s+F9MOtqbTHVUYxd8plGJWXEM+Q3a9m7CSUJjsOrwtZscyQWU7mteARTCx0FX9IznBhu0q3svRsTWzYysrb2RzY70F/ZNyRXrUh343rAyNh53ujiPiXcuIMd0jP0l/DWS8S0XxyOfQLNKvYF3IE385X+gO1iMXxHKZ4bpWuqfVTtMH7FvQgG1xdm0HDkSLIUwACXxrg6ozruBKIiQoW5uSDVXsx3eZayf0zGRYr6gnNrOR2aigbyt89TcD4mBebSQk9EjrUL96HMeVcEgPpll4M7iV+iCJDXm8nQYisfqQQGacu8io88VX6eiUwGhuPC9sU/7UJ8OxZhX3wP3D8R1NFUs3O/Hje0IHyQjeBU72nxp420=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `GenDisk` to obtain a reference to the associated `TagSet`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index c6b9839864012..b5291bc3e051d 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -236,7 +236,7 @@ pub fn build(
         // `__blk_mq_alloc_disk` above.
         let mut disk = UniqueArc::new(
             GenDisk {
-                _tagset: tagset,
+                tag_set: tagset,
                 gendisk,
                 backref: Arc::pin_init(
                     // INVARIANT: We break `GenDiskRef` invariant here, but we restore it below.
@@ -320,7 +320,7 @@ pub(crate) const fn build_vtable() -> &'static bindings::block_device_operations
 ///    `bindings::device_add_disk`.
 ///  - `self.gendisk.queue.queuedata` is initialized by a call to `ForeignOwnable::into_foreign`.
 pub struct GenDisk<T: Operations> {
-    _tagset: Arc<TagSet<T>>,
+    tag_set: Arc<TagSet<T>>,
     gendisk: *mut bindings::gendisk,
     backref: Arc<Revocable<GenDiskRef<T>>>,
 }
@@ -342,6 +342,11 @@ pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
         // SAFETY: By type invariant, self is a valid gendisk.
         unsafe { T::QueueData::borrow((*(*self.gendisk).queue).queuedata) }
     }
+
+    /// Get a reference to the `TagSet` used by this `GenDisk`.
+    pub fn tag_set(&self) -> &Arc<TagSet<T>> {
+        &self.tag_set
+    }
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a

-- 
2.51.2



