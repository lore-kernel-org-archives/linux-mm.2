Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B857DCD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2BB076B00B2; Thu,  4 Jun 2026 16:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 293106B00B3; Thu,  4 Jun 2026 16:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A9376B00B4; Thu,  4 Jun 2026 16:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 094016B00B2
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:14:58 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C8C6F1C116E
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:57 +0000 (UTC)
X-FDA: 84843333834.23.3434B68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D878240012
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emyi1bE3;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604096;
	b=ZdK5u3F8APYoTVnPqAcz8lKWzGWL6bQtVt3LGN2qUR3yNPnX2YfS6y9JdfsVPOMroUfNFq
	vcjAf1n9HVkJtGS4Hkd0cpNNWbsVq/niUN7BXr41CQf9RMA4r1uLtI0XwktkBQQtwYjJx7
	wi8iXZfM3W/yOfUfHE19EFmacvy7r64=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=emyi1bE3;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604096;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4H8eqNZN4/mIO1u313XVeuHkqdUneIpioBG/gGEBMQ=;
	b=oaBTYDUJ1BParexA7Mrl362PfjmY2EiGqnfptT5csfFMVgwMVBbjg5J/jOw02M014y97yw
	t9AYpXgpoBZL3Szxam2nwn578VXOuaN++dI12hRd9+qlc7CHgOzoJpaf0XomGfxpuv+qPO
	/DVSMYH0I7PtVkQGs8MwiwZxuUdaEt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 29A3D419A5;
	Thu,  4 Jun 2026 20:14:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946FA1F00898;
	Thu,  4 Jun 2026 20:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604095;
	bh=t4H8eqNZN4/mIO1u313XVeuHkqdUneIpioBG/gGEBMQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=emyi1bE3lT84UiMs0H/e5sWLBpipKD8aP4rx9nCFc5ww2rHWzTrNroixBU1R1eW3k
	 VvDyq+Y9/EKTN5YutDxaS2ya7aaz09ocK8otk3HD4GePbWSC8Nq3UzR3jpHPJsKnlW
	 D+G1ixqQ2oKb5RLaZIvJKK62Ge4aMEzL6NR04y47K5UJ14jmX8IhLAu4hN5UEpcV0p
	 QeUQfwkvgeuV7wWv1oUW5AiTbIKO9lPOEnLAnAOPOPK8bI7//XDk5clHDilppzR/TY
	 GZxIkL2upvxl1wSbQAKqhnKfs+Sb4dtPjK9uSDcEaZPvRLUc9O84wyUuh3WcYXZw+B
	 dXBq+GQKoz+hA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:22 +0200
Subject: [PATCH v17 10/10] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-10-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1098; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=MTxQNyPl556p/37N9iYrjSR5gCSkwSCTZpMY90B8pEY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvvpNub7j04mvxMdRLdPaAd/MQZCqnEQ9G7x
 6NHPMMF+bKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb7wAKCRD6UCkIqsW9
 0MI+D/0QPO+RBFAbjZRXC9pKgYwjFXnKxpO8ZzAKgdud2wdZcrmS6XnxjFCuPYPaFQ93AhOYZJa
 4HV8ITv5TB34RklZib+C1ex0+Q7HyqZjU22svIR16LfDNFX/PzVeBvcMhmc1WvMZxfKE72VeYMD
 lG1FuQHv/rWnofDymriWJ1qTmmIh7KcWTZTBWOBoRgKjjYMflJitin0NXq39YIxXu1MqcEGW20v
 ceF6r4JVyWfA1qLVdGeuXR56Z/tP/9demSf0WEz4n/JNfPwSO2fQGqgHU5Wl5QkOeyepnUg4nCf
 V7AX9lwpje33yM15jdHfXun61mNZa7LYV/QZyVny/IV39nPfxrEMJMFFzFZhx3H9v6+wmG7Rl7h
 cOtjeMyzfmUxEJ95Tx/gR6H9Lv9v03K0ZTh/L5YdaCZvaNDy0gi0KOnWUL1eP93qbY2kiyZmE5f
 t+Xfj7TX4TebKhIwyEuO/uBVPqXJyZTHt2mkjJ2wP+OAjZlc3btrRL3brJE0UGHxHzedtn8XHk8
 TyidsBvAMRGQ+VtyZO8Vi+OXdrfsKfO4XV4jyBjM1uPFGEafgzam59BvvN/aO0sZQB62OEFCXKc
 SQoUbEQRjie1O1BooUeWFUAPW1OpcbGv5nlsQmCDSxE49cATUzyJjv+bd3ihJjA8yLKgc8vmC5j
 m2qAWViBmLjYVlA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: D878240012
X-Stat-Signature: uwwe83n7g6f78z4ns84bfxtmbci77t58
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780604095-253163
X-HE-Meta: U2FsdGVkX18U5onUkslN5v+hOAfMPRarHBoTjwhTZlI5Y2AHL1yGlbJ5bXqqsjNTCmpmWYwrRQhDD47nwnLi9wsWp27s6dxezxDS353FBnMhmM8bfGRlDT1bqTw6z1oJDao3/PJtzhEYqLES2DW8WZ4+Xq3pHPYPWTinQ/0zSWj1L+HWhWu8HXUiPvwYnUPmpR6ISDJWjDwFbpICXXYRwZbEGnD9n5vDniarclT2yCv8OEjCcRZ+wxjZNv/dSAnJwWznXK9b5Lu8jGxBUZMkMtOdNWJldabfHEJTm78otmhjCmZ8unkDr1wKgNbZFtgZYZhUB5EIGPzmhsftXVyarTqTUnGBF6YBV7YntLFs1+voe74OFumf3KQrT8iFAYd/IYUyIN2AGXxpmKMkdUwb02aosBigRts8eWTu3V/8x4OIxOOcsD5JHvnKZV05tets2+Izx++DoOB7QaXHW6ccKoH8kBn9DKEIETrc3rpBp4LGlDW0BCf9xBYAIPr9jFW70VO3hwpTVwTtsxlAYKJzhZMu3XAVKuLWaYRNghMVwPG2TldftpaJiy0iA1zSbpdQA0b7jRqQmNLxZEsjJZz14jMSId5eTDtiCpp9lI5cEQ7Ue3uzr7YAFr16mydCvhnVJhqUCGI0aR4e420rfbYIfd+HWEbFpPREMIeBUI0lRkqg0P1lbEstRQDJW8dWzQ2sqC9Gh1Cv7wb02srkNAOFssx8dBQJmqlUQ0nO9O4bZMXORc6+erueRJ2rxIvEn4iGKx6ycOav0kqhg1BqkJv+gG00jzc2uhNE2qpI2ocAYULLGy8HrIJV4MKeFXZldgYKyQK8T26roVxEOkmxYHQMN95IPLtIAfTzUwXzWu20zNX7q3MktjNRSelIgXOgTIMgEkinyeVB1aDg5MtdPl5OXy0AIIgluo73pmhhbds4Cmu5djzKuhoxYR8cY96FUIzJyIW3T2CiB0oaxEZkK6g
 jXw/ThzV
 6VPJTz/bax1gW2bMT6IT7rqV9XxBUWOoA3gh/aDUByABxwK8eEME2onEEuPfh3uUH96hrjzaqBveCJI+or7Hqy4bcZRiFq6gwGh6sh1cdWFtQM0rZj9fZlzBR/tqAwzSI2n/30kCwviVohz+gYMTQJsMvpZ91CyGIN5kurBk6N75Uag3iIkbDoppdT9oNndjp8mWaSbVeuj9alMb+fj07Cw93Fz7xMwdxcmIpQ6tOYI0sfJMRREETCUdxqYubZj+fOHbzUIi+VtJ+zYUtNMkNPqUphNvhDyhFp2RgduaKgH3Jb1ethUSqqWf/X0WbjAaQc7gj9S+9fdnqowA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/page.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index 844c75e54134..d56ae597f692 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -214,6 +214,18 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be convertible to a shared reference with a lifetime of `'a`.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // SAFETY: By function safety requirements, `ptr` is not null and is convertible to a shared
+        // reference.
+        unsafe { &*ptr.cast() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



