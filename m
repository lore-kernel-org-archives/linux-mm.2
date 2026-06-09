Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8DE2CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362D56B00C0; Tue,  9 Jun 2026 15:12:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 333FE6B00C2; Tue,  9 Jun 2026 15:12:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24A196B00C3; Tue,  9 Jun 2026 15:12:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12C1F6B00C0
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:40 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C700040779
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:39 +0000 (UTC)
X-FDA: 84861320838.16.E88DD9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1AF4716000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSLqirSm;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHThiWRFl6eX+o7HfToI0BveZqoyq24Iln96WP9m9/Q=;
	b=lxbSr2ZwaCs1umfaDPqD4orb8ZzQ8pa+vWIt7rf25NI9ZtjhkddZ0aDWzip7LEXkD+uTwN
	zVhuNegYybrJanCQhXNACw1TP/JiYB3yCm3W/h4CTx8SguWvlc0AZCFO3dobVkCcVDRano
	fi2GnyIaiOpwJswCvCTX9rApvds8g80=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032358;
	b=MMoCx64EW8gynQiGmoua2PsHON5hRT/pwTZs9j5JM3GiMotXajHCiraRD/fo/UQr9r/VQo
	8H+FjthUvD1mvuv793rDfd32wKaraHzDbMUjZP4I8PAyap/qd2kXdBet2w2Zzoo2/iJTug
	/8oceND0eThzs4Dkb78ffLPfq4LcEYg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hSLqirSm;
	spf=pass (imf08.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B8248602D5;
	Tue,  9 Jun 2026 19:12:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DC361F00893;
	Tue,  9 Jun 2026 19:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032357;
	bh=SHThiWRFl6eX+o7HfToI0BveZqoyq24Iln96WP9m9/Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=hSLqirSmMdfe7JHeDMJEbaGk2xH+r8zJCJzvpqX2KhAAr9i8+gTGMZyAN1O1wjZFC
	 87zQtjSJAnw4CigqubVw8wKx94QKtNmMrfN5c7at91IeS592SC+4RIGtymDHm1YwCa
	 YLJUWRbTanGImSCTPh9eGyzpeIrCOd2UbjnURp/RndyphhSh+uuhENiu2XosWeNgGW
	 CdVJAtOFqRqSx44VleaAHHBq96ylbwR33okKwYWrDDhCCpyXGW8l/aCJ10fBnnoNeF
	 gDyNOm1J8ES8pByB/3zTYzR5n0qqCLrmYO2IeqK/tGMJ6+8bvXHby5oTUt8Hb2HC8z
	 /PO7x6UNlMlnw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:31 +0200
Subject: [PATCH v2 52/83] block: rust: add `TagSet::flags`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-52-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1127; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=OGr4o32gLgytplFNTefSvmBphLU6/cXTR/X1CTCtpbs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTjD/SsS15S2X0k9iUPabdH4odGbYwDe1N6N
 6f6Z6npMbGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk4wAKCRD6UCkIqsW9
 0BqjEACmNfk+sSeVLWEKg7qqrjEhETKAJdKa0iscz0fFFu5BCZYtskqN1Pe+gzH4+dxsr0nPBZp
 wFoG2ahBVLl1ZFM6xUD5wlUwnvbCqawttYwP9tRmHVlVHeDArVaWUnXcapkxPDUNo+RWr3nsPSQ
 TM3hKexhjGLQDNoOtZwP6z4n4J58mZ0FeHYSZgx6TOD3SOMpR0vOLZ8+opSfcFQDXnoo9T9xkHk
 EqbddpiRIe17zJHcW1XA6kUthmI2JZab72b+IjuBR/NQqr+cg5oRSFafIj0EjDD/IdeVQ+DRqNd
 8vUgnW+2fAyuIbgxeq+/bnuy+Yp0MsopvmFj9siA3Kpr1l8LgSJ6Qw6D9AbQ0CnL1Hrg3DgGDVH
 fF4DCvpOb7/bEaKGo6OQ5hsY8kPb13y1q0p4XM94MvgobrunqFlJNuWulMDtz6cBJewScWUyKoc
 9c4dGEBHCEJokswtZYoAvoQJDhfOQGzI/5k1jUwapW44qpjVhWS4OlRZD8qPJKoa0iI8dm+m5Vl
 S3+RawjqCptgUdxVWG0VUXAaEpWzQ+ddyLGHOK4WV1kP77VB6GlWEprAoNoj4fhj7s1SciGYsa3
 cv85EOjJFomaU8MELbJfwoihhJgdcgv8QPmNTICa+Zinnxx9Zir+POqXejgqcP07lZVrtdQPIi9
 vu2Y6Bmvw6jKhQQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 1AF4716000F
X-Rspam-User: 
X-Stat-Signature: y3iadpefgkuum7rgfmkhyzke8pz6wjsr
X-Rspamd-Server: rspam08
X-HE-Tag: 1781032357-111313
X-HE-Meta: U2FsdGVkX1/MrBcUFiJdizqxFotdupfUHytghqSuFhXSisyKeR46bt9qEdbYGfbRP0NVEyvpREgsQUH9zHQCgypUuDbjrvoYd+rhTapxcBhOMA6DoP8KgvCTk74K0p1b5/L71QpqLTVYwwoeST0xkyQziMp7ZaOzgfOJ3kZl+C8gsrazRAwR3CZqg2JstBLIruhEkkx/jbpTgMJsTrojT4A2Qi/8rQ9ezUYs3QDzOknvhRKEBjT6qk8wKWstvTWAA9Nf8qW1frDTNfd9e/RZvRHA9EndHHrHZLDr15oiqayVlQ24wh95LAyM/2by0wbWksiTpIalz/BoLz2ZtXO/Wi+IwTRTjiZKq2qGMzzLeH2c4QmhBgEWq7e30NunYfuiSjIlJmNlkiQvdfAkrFcrc1zOg+7Z40ONRMS2Jf0tkAO+0oXCSCbWe4Opq0Gdy8uzQawjaTG18uXLS5bRHYg4NaWX4HG3i8XvTRvk3Cg3YY8ol7h9LkTkIJwcac7h8qCpcTZ4lkbPWwbl5KkUVijELdBtckGezReUvRxmPd3IO6jbi03TpOgwqXRkgNvJWCgrDUo9oNVjVCRSGi5+nq12c++afrIrlSuwgoyYxhLCkJjypKpo13jerC92L+luaBlVnbaGxDMHDNx53RjYguDu3HMxaP1aF5KmanIc6Mo9X7Pw36yuA3/ZzrVdbp0qZQlTGIFzdKBKcp+Q6pGxx5G504bIBt2auMvhDnNwf6o7anE5+QTWjvxW+FLd4CmMj5pSwsUWIVvUkvRHWWSJkc12V6ibkH23xwLBuggkDlkOQVvF93bxUjmgACvK4EQeZjhiD/xhwsBnPuCyNNqpMhplvi0ARL8LfcSviEoN3Ol4mSh+Oudm9t6moov/pP97suswoef9Tg/jwwhtoq6DwG7Bk/2RYdfO+EyI18Fn81CiYBwUbpOSsigEANhQXzybb6GGlE3UzA/Nk+mr0oKpN3h
 cWc8lrSl
 J0P+lXwwb7Hm1NX75yXUQd74XRDrzedwRw77davekWuBd7J9RrsmiVQ4M79w8H/HloGLmrnGq5qi9k+FYtgAVU4YEQr2oKnaSTtfHLR1Oh2gp8483VxItXYwi1mOIgbap6DNvuGRfVjk7pvYvIySfEU6g5fI16Xr6zCyNppKALczqyjBJFxDB8aHwwiKe877SlmQnd/zSV3ZinecDFLrS4xOc4qZvnydX8h3rqeJFlgEP/x9sfQ7ck3wWNYxMvVIy3XZu6yWycfdz1fKQzcpeeH97aUeHCRE2FyjMUPQ9YVVoEGqmoDUYNOCh7wuCyUF2HkI3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a way for block device drivers to query the flags that a `TagSet`
was configured with. This is needed so drivers can inspect properties
such as whether the tag set uses blocking queues.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/tag_set.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index 5359e60fb5a5..157c47f64334 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -107,6 +107,15 @@ pub fn new(
     pub(crate) fn raw_tag_set(&self) -> *mut bindings::blk_mq_tag_set {
         self.inner.get()
     }
+
+    /// Return the [`Flags`] that this tag set was configured with.
+    pub fn flags(&self) -> Flags {
+        let this = self.raw_tag_set();
+        // SAFETY: By type invariant, `this` points to a valid and initialized
+        // `blk_mq_tag_set`.
+        let flags_raw = unsafe { (*this).flags };
+        Flags::try_from(flags_raw).expect("Expected valid flags from C struct")
+    }
 }
 
 #[pinned_drop]

-- 
2.51.2



