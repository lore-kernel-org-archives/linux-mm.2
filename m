Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17969CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 758136B00F9; Tue,  9 Jun 2026 15:15:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 730066B00FB; Tue,  9 Jun 2026 15:15:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F7C46B00FC; Tue,  9 Jun 2026 15:15:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DD556B00F9
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:15:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 184891C2794
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:24 +0000 (UTC)
X-FDA: 84861327768.21.0DFD188
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 503D34000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:15:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnGNp+U7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DZGnmBi8mHh4p9y0/gnRSVsorGqqRp78wd3TOoNIUWI=;
	b=Jaw62RyJsy/WXi1quSjzI7NS7cVvbWfcbtYCYob6PLQzF8TZ9YUSLUgaLFz31fQ9iaH5mr
	cSIkd0nhTC51m4T0na/0sQ0z/jy5scUqM1XsbuXK+8NaeELfH+YVpRuwFNNkmenVqQkkjH
	HXjckrAWTJoRXH5e+OGSl5u+Z5MAd1s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lnGNp+U7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032522;
	b=WO3ARe0FzsXns3WRqE6XaDut2AxPoQYW+hNJc11GCEU9NSvPxW+9nALizHTr7RiE2AwslB
	ojpIs1Wwm8fqvGVIqL6UMvCvsJxQCWcXenn02m6IkwctaurOMgBx9MGYal+pOrXjLWdr2a
	4IOauagg7E2luwRVX/wDUXr/uHUA42A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D20EF602CC;
	Tue,  9 Jun 2026 19:15:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C9A1F00893;
	Tue,  9 Jun 2026 19:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032521;
	bh=DZGnmBi8mHh4p9y0/gnRSVsorGqqRp78wd3TOoNIUWI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lnGNp+U7lAm5TT7NragGdHyHIpj5W/ggjDukYYZfxoLkmwB/zHaT09MQy68txK4dP
	 RXCl0hNOempY7pxNynN6Su//rED5AGL4Cd0Tc5n1yLrm5xHFJRN1SHv89LAX8ubz7a
	 1qCZWTesGzjQf/0kVeaDe0Aus51szcX4jATCD1gTxNbx0+LIzY5eLHxn+h74dlQamx
	 ZuvDLtY4kQLwBQScw9NMu49hlkOoJpeNtQxL/0Ow4P505SyOmmGPdpgiJL4talvB+D
	 seoV3GintN5UCwVYOP+EzaHkep7a+IFnFChahUdWddmZZqbcw0a/G8BiexrddvdLf7
	 WWpKSQYu59U9A==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:36 +0200
Subject: [PATCH v2 57/83] block: rust: add accessors to `TagSet`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-57-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1789; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=DgqXpos7C80lClbWnsjqwY/+BJEIchncSKiJddAVFzY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGToQokKIiIK5c0rRnI8tRT1EM+BSmSLw36zh
 gEkP49VKD6JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk6AAKCRD6UCkIqsW9
 0KkYEAC5XUOUpCMv00hmZWvvpzfwCR6OoLx2WY3L4hGfe1HPjTDBH+Rs7HujdMlbqnVGEam8I7a
 MCW9s9FDf9sKjmX+T+bNrONZsuyPKQ8baL+2xE2zZcH8lsBd2aWU16gagSgfRKiNAUQGq+EcTwz
 /2IjccxOcK6fS4L9NIdKbQLqrBf9TSAL1+/HJg6m8Obl8BkqIxvFsPRS9+cJGrbjfvtMJ1CdakM
 SqH8o8A043MXmCjUlEpayeJyIpzhjXn2EUoEegAHXO9wM0F9ADFDzjA1ykrWwUi9kiGSr2WOX9I
 KH+dqr6K3zDHu4bzRrnyeAaY8oCJMM6wTrCW80OEePgqvhraTsKTf7KEYFLNQR0r/ZsW9FtI8vq
 yS7OWDzyWFIiDQmlB+ZtVp5jpw7PFgpqug+os3nbKsFhXEvYMavRRMgCkeqsQx2zQma6bJhHd6s
 +F/e/jgQxhqe0kqQIIp0FaZ/UhI4pV3F+PHRrXmmVqPJSTqGNplMi+ubYnfa4jh3yRE0S/R7q5m
 QfFU+95OZf6/SwiSA5EunitjI/O+1lNqwmDfwl9YFXZ4Fo86iiIksafQGeixEJPI3+wCYVRySv2
 MoNQipcDq+e5qSu/cjpAQgZ/xpSiYaqJHSOV8dvnY0N6fd0KwScumMCub7RwiWN0nZR43g2GSKv
 Yovc8yWTHPWru5g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: yo9bjk3cew34ch9gkinfh7sbf9z9puqf
X-Rspamd-Queue-Id: 503D34000E
X-HE-Tag: 1781032522-748741
X-HE-Meta: U2FsdGVkX1/isUaGdqXWZWT5KPyLDV4AIU87wrVDLX5GGq30tE1OkPGb2PWpEDxt12K4MqKEioJiPpUH2TArA7r/oQOzTA4zrqdxK1AZhRKKxAyAVHT0nRQqkBFvNmYcg0+XIfgFpSTqnGI7TIxYeU3VG4djNgSJ2EIn6Jd/MWSVM0Y6bSLz8NL5/AUa8AhZKmK0XPDWc2xwO8fUsnCXYxhigrKL6HRBRxGgibLI8aJUY5sMLmX0pVOBEGuCWiNw85q8oEqaPDo77pbP//DFgQRovBTdM1/5J2TGIha6v9cwg/PJFNfG1ZCYeGkuJ2d/HJ82+AyzSJnC7DaldLZoYGuOQNwMChhD58F7gjBKDgcHOwUvfu9kFKbQFqyQ8UqFdxC3F6/Toiat5/tcbNdVYb0A6RWzZq484hrc8cTZ8DQkdxEyz92VQMe4ORWBEdrYBqiMt5z4HCtylRrvh3dC0H5nY5+7eXZ+laij36sZemGqS24YOwuaRyYExLF/mAdoZqMXwdaDJqJGXDVTqYuJpo/2ey1oe9c+hiBYV70RBsIdLj2XpBwbX/W8eAKRxgEOsDvWCtTz1duRlbhLrYhJJrOzWNNx4h8/MCjvcdG17HPP30ULNGGc1XA4SKfgyHnM2U/gfz3oJNf18UghGDthZ8r5IdugpXVD2yLYPh8LnARExnx+LzZz6l9Ju48O4srNq83GXvlCxQuP/jCRfERLM4YbUSys0C6af7ARpFVOA606nSPEe+23g+cuncGWT8Nys896wwzQn5mx/RVd5r51dl3IO3gV4TmFVNJ3TMqUai54AQOj9hngUmzP7nW332AOBILCIny9gYPwxYK/vmmkB+z9H8dA3eMjynEdOKNAn7xW4T82G5XwP5A8HB0zGObln8lA7IhT7e6eElOPD/KsPJ3jlUCAn6CtPUpIIYBE9GIA70nnsiaDkkHDVHXj31ul1JgJW0dCdUIoh9o5Ivc
 clxcRkam
 1DI6zf1lUYk3QbgVsSJKBCnfKC8pO7TAPSPIIHnRv7q+n17v3Fy/iIUq+UNaCYqOukvUjpYNHSr2MLZ1GRi2QOAOf9cTqhCAASxMIGVOar1SUIvZzTViHNwV/CKLqJilrpPAx19xfkDdC7WSCcX/AAp5GZvjWjcoBpM+Xm7ttb1HkLeFI7O9hI6CI1+Iy7NyWLnPtb5feR9+B5WVkIl5/0/gBneOj+NkJzgRpYnBrEVMW4UvgxuM53ahKqZ1daoaYILVV7cbS+nrDWy71bHHu/npGfa7trU5f6qMM0mHeHA6AwmXBYYByV9x6Qva/tSfTDBse
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add `hw_queue_count()` to query the number of hardware queues and
`data()` to borrow the private tag set data associated with a `TagSet`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/tag_set.rs | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index e62dfd267fd9..858c1b952b00 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -4,8 +4,6 @@
 //!
 //! C header: [`include/linux/blk-mq.h`](srctree/include/linux/blk-mq.h)
 
-use core::pin::Pin;
-
 use crate::{
     alloc::NumaNode,
     bindings,
@@ -26,7 +24,8 @@
 };
 use core::{
     convert::TryInto,
-    marker::PhantomData, //
+    marker::PhantomData,
+    pin::Pin, //
 };
 use pin_init::{
     pin_data,
@@ -164,6 +163,22 @@ pub fn update_maps(self: Pin<&mut Self>, mut cb: impl FnMut(QueueMap)) -> Result
 
         Ok(())
     }
+
+    /// Return the number of hardware queues for this tag set.
+    pub fn hw_queue_count(&self) -> u32 {
+        // SAFETY: By type invariant, `self.inner` is valid.
+        unsafe { (*self.inner.get()).nr_hw_queues }
+    }
+
+    /// Borrow the [`T::TagSetData`] associated with this tag set.
+    pub fn data(&self) -> <T::TagSetData as ForeignOwnable>::Borrowed<'_> {
+        // SAFETY: By type invariant, `self.inner` is valid.
+        let ptr = unsafe { (*self.inner.get()).driver_data };
+
+        // SAFETY: `ptr` was created by `into_foreign` during initialization and the target is not
+        // converted back with `from_foreign` while `&self` is live.
+        unsafe { T::TagSetData::borrow(ptr) }
+    }
 }
 
 #[pinned_drop]

-- 
2.51.2



