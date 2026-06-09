Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB50CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F7C26B00B4; Tue,  9 Jun 2026 15:12:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF6A6B00B6; Tue,  9 Jun 2026 15:12:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E5506B00B7; Tue,  9 Jun 2026 15:12:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADF06B00B4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:07 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D2222C2758
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:06 +0000 (UTC)
X-FDA: 84861319452.15.6AB6451
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1B78BC0008
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:04 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWh84ZQZ;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+YoDlaRXxHkBdL9A3Iy3eyhP/tykMNVFwls11O+PbGw=;
	b=ANTHptvY2LPkiEJMz9kQlHNQplWzI5V+pwLkrYms5Y4MA1itzPfv66ngygXYUNYEjxnen6
	5PyRt0yVq104zVZwnH8K62j+cAOxzQscpvTjWllI3uXg9nRLg/1RhLlPG3NtfqMNEaTq5h
	L3JoL1OuWAHthHEJTgV72ohqE6Rr4E4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KWh84ZQZ;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032325;
	b=cuvI9V1uuzF8AqlbtojDtTFoT8KOplpoU6X4nrCqEO2t+OjD7vJPf8iFkbO3CA9sqa0/cU
	sb3AcYBqOIEZmZiJQPfDERyKyMDdUJ/vYZNCwaHwm9yqtrzuaeNElO47a2kuT8UmMv9TNu
	JwAcTSg4qU8gaWUcoj3WYGvomSfzUmQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5048602D3;
	Tue,  9 Jun 2026 19:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC0C1F00893;
	Tue,  9 Jun 2026 19:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032324;
	bh=+YoDlaRXxHkBdL9A3Iy3eyhP/tykMNVFwls11O+PbGw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KWh84ZQZbd6+abJoZIFIxRUn4c5TrwdxMM/86SAfgZTUh6LojigcMZcS5+SAofC+j
	 43O9jA6Q0PVLSoLmT5cekTXpstMmziu34IY4oicvKtd4/I28lKCaBG4zG1eWiBasq8
	 ZmXp24Rb7GmggbZSBZPaT217AwW0dz5zs8OnOgZ+OV6xFD11SFStdpDWVzIkolj5Op
	 y557TTH3PeayehmmC7aY6efh5NWG00BEEznzp3sEYMtY2EK27SPUMGD97Z8DfGPlO5
	 V1XXt3jl+BFVTR/wq5KnKladB0fOdbR9OpNv51kuH3rMDxygWm+MUVtecbA37wwcJj
	 4KGuinCXguuQw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:44 +0200
Subject: [PATCH v2 65/83] block: rust: add `GenDisk::tag_set`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-65-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1759; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=W0O2CczxZDQEXRc15dJETKMQ+dkKiMZR7U8tm411g7s=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTvQ1j9ShlTi9k2Sxb2Wf0dabZIrqUisKav9
 O2siS1ba22JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk7wAKCRD6UCkIqsW9
 0FeWD/9yDXxLKGaEABjjYFcFzRClbH4obCRuAURGM/QGNN9G68bjR5xvZgZBY2ro33xcNTNJAJL
 40PULazu/7YNQvvPEommrLYYtyhDfbp/IgLzBIOTzp6jwSAfSHAIivLG98wyH/amIbR1vH8yCql
 SBDdg/alHTtXGCU0q2i+pbsClfWDluhNWB7x4H4UG8+LC5nW6Jud2OXoy3VYZcluv7qanvjUJUg
 itVhIUBCc0CsZakZ3bAicLz9qx324CAigGnYNBC0XecSxh0jmsIopTMS5Vn3bSQjY8ffpVWI+zz
 +3K99Hgnhv6uX1VODIAC7V7dp13ZPw9pq1/w8tFFhXa83i42bKeqH4EMDwtArYia/r5UN+8Hxru
 W/jUOiqtMyP+/6yvN2WWEGIDkCP90nS/ITnMdwqplALX6quStpjIrtpEWHDcJvqGupxXlRnmxoS
 vxlRuEN9Hci+7AlgG121BQDKaTq/6gR9fZfOpOSa3pO37+JcWv3qNI9wGHa6QY8xtYDF3RWWaAs
 jOM6ahj8m58s1GqtrBlSzSyFs1JhsSdZoWOgQ1VHhOxANpkNHBqTIuyuEzo9Krvs74mm5LO5KEG
 jM8F3FHT/n5ck6W8SkIAJahMQV/vvVUYxBdGI6n1+VJuZqib6n1gmfGQWb74cml/ePNiQby0wb8
 g+x3smGKALfVxkw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 1B78BC0008
X-Stat-Signature: 4rcyzy9egnux3hu39oghii99oy669ews
X-Rspam-User: 
X-HE-Tag: 1781032324-110969
X-HE-Meta: U2FsdGVkX1/GThDvOqnn5gETUFy9xig4IcdZPLgw40c6PrfZoPaWkaP7e9ft1CLb84gCsNmBO/rBGhW/MoHU4wGJCXwyvE1VzAqJr91EhXdtdyOV0rF9oDQt6Bx2BhNsQ9X60g1Y1g5KVsn2+IaoM4/JK1DlNIhBiaJPOW336N1m3rtnzDdwHS6staaWg9TIqQvlUkPeqVz8AYatTOVVc4fptvZbNITEwKXiBRtnp7PxGZlyiK/JpTWUX/usSWbgBhJxbdZi8EZVlt98Flp4x9KgLiCdnC0wGTawFdGqMFyoWMtibPGIul2tPX8TtmM8ffXkaVuE4wEhJtq4QPkurz1u9tvXbzHg4U2NAC8Zgu06xXCzSdqEK7jywTknUCizm2s0IMSdKGoF8yOR6O7xAPMfjRCLU3nLCCg3nJ4888Svp+wSvDD2dP6WpkcAl0F7CUzoVe5D3U2IXFzNFZWRX9r0DryN64iaVjwmgTOYK3bztfpIIVyv/KBBizx4Co3KmHpO4wXHmRUuLDCkFOAuG/AgeTLaR+vgOWJAWm1rZVnMXXbbWcaCw2GXt1QTwSGhbSd1okK9EKogt3rzynXlwluUk6kXrk7BULGoSR44FoROfcf1eel920s40lNTdP8NiARHvHTsXjPxZFlFyn9v/wKpKfNaaZ2/Un9jbUSkGEQr9c1tnJfncK1PLjLjd0GWbtLkX3CNbeQGC62e9qjvNwPG244EtUToHxs5gwmwg03KOO4a8mk6yBpm8/1LxGpMKEV/7LmctyIy9uHVhB9P87LQgDC1ZxhdKPwl636RGWiFBR+LXqgSvEmilcJf+g7xD/KvAm5A6p82sFe8MfhBtpUUEwfN0ix8r27RclvTcqDIiMFjCxdLJXfER7SjTiAsUPiCJS542TQ1fdv0HF4gHHZzLvX2SNkd3iqZsnuinNlPWn7Gps/4ZnDkz0yvENlTJLNjA+cHaZiDuK5tvMc
 7X3B9oAS
 xxv0YNTAgCsepv37da1gm7nprEgy8owOUt0T24r1qlWEyjxJlT5MAW5SaxiEAh95iDyaHwVGsybvYPh2+epD5nbcWwXYD45OMlgBtWlPl6xxDkBCFo8r/dGGRqR4j+KZhSpw1lznaroKIpBl2FnQLmFkwqrdaoukF4fVCNqjjUGUxg8wcKA42Ddc/jKYZCgDk+btWj6KbIV/N28/bBqgZTuu169R4PFzDdS4juZCFB3+r6Cr2mDR/g6ICpLAxMAUAwmtpvNFKqCNANDuZXsmVYi1AmAo+9qJfiSCzXM+EPXfjdIdWWrzJhYUjBdctZ7MAKLJ/5p3GATo0gZ6ZEOuzJwvcbDeSibSOBYYUp/OyO0qrZgO4Zdaq8hqzZQ==
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
index 5367ca92b7aa..a50ba7b605d7 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -257,7 +257,7 @@ pub fn build(
         // `__blk_mq_alloc_disk` above.
         let mut disk = UniqueArc::new(
             GenDisk {
-                _tagset: tagset,
+                tag_set: tagset,
                 gendisk,
                 backref: Arc::pin_init(
                     // INVARIANT: We break `GenDiskRef` invariant here, but we restore it below.
@@ -341,7 +341,7 @@ pub(crate) const fn build_vtable() -> &'static bindings::block_device_operations
 ///    `bindings::device_add_disk`.
 ///  - `self.gendisk.queue.queuedata` is initialized by a call to `ForeignOwnable::into_foreign`.
 pub struct GenDisk<T: Operations> {
-    _tagset: Arc<TagSet<T>>,
+    tag_set: Arc<TagSet<T>>,
     gendisk: *mut bindings::gendisk,
     backref: Arc<Revocable<GenDiskRef<T>>>,
 }
@@ -363,6 +363,11 @@ pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
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



