Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA11DE63F2E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8B286B00C8; Sun, 15 Feb 2026 18:44:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6C9C6B00CA; Sun, 15 Feb 2026 18:44:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A28C6B00CC; Sun, 15 Feb 2026 18:44:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 909E76B00C8
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:44:35 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0B5678CAF0
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:34 +0000 (UTC)
X-FDA: 84448322868.27.2E37F85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 49E1940006
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:44:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R/HS3paD";
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TCPQATGP2FomjRRbDjorcOMNdA3mbqUcddqPX+EU4lw=;
	b=gk4u8O4M+SlHXUVau4OW3tQXha/X+bCiXQuVDcKgzZdssk2FNM7QJFn2+JEGlsJjw0EezW
	TiKluCxKPNRgCNnsF3Q33fxzezb+AXBm9RmAU2+f3rxRt3yfCfHo2HHMOW+U9T2i1t7mGV
	TU255S2te4uV1qW+ySxLyjLj3t0cBGA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="R/HS3paD";
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199072; a=rsa-sha256;
	cv=none;
	b=omxpAUmthJTAqMAnf0IutbWQIoAgXpWj8khDemTwKyrnf6uta2c4T2Un9S5MwEULAeLjB1
	69pKCG0zIjO57IKo3LRdmoeWwy5CXS18qutZ4ntGmG4k3J4Go+gWLbnZgSBcr9d6fGhirc
	1oSVVzKAtCFIqxipnkWJ7BtC4UjUbsc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E27A36013F;
	Sun, 15 Feb 2026 23:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22AEEC4CEF7;
	Sun, 15 Feb 2026 23:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199071;
	bh=lMkix+l7YL3LsaeozijpZ70ut/nAoZ1bvzW7x8MaTVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=R/HS3paDi2eXXvgNc/RC2Gh15brVOf29/uOZWoin9FCssxNtw01OqyYUNZtHcBJnj
	 N0ZIuR24Dz0MDafAvoLvM7OlIkk0Kops5y1M6Rmj6+6JC8Adf6tU2Kx/OzF6EHyg6v
	 Q6lHBxRHdswAmozCKwNl1Yk6Wbl6EY4Yn17UR2P/HNwSChN8JzVddKHggptzdBx6p4
	 4NY1+fg2SOBwc7lHzoeOPKS6gOXuw5RkwFyDC4Kx2UZVzhHBws6oL1f8YmtXRwo3iK
	 XmPknUyi/LfsuSAYI/GuKk4my1XcGX701xHJ04UM6tTXm3OOSImI5IWoJURQyYw+xG
	 lXMdkNnBwpCeA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:39 +0100
Subject: [PATCH 52/79] block: rust: add accessors to `TagSet`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-52-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1945; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=lMkix+l7YL3LsaeozijpZ70ut/nAoZ1bvzW7x8MaTVg=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhKcY5nY1KWMizzxuSEORA04SamyEuwDQMar
 kiUG9Zee1mJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYSgAKCRDhuBo+eShj
 d5v7EACQiUbG3DpCSqYweozV15pPocS41T8Gc3taZE4wwex28+Dgu0T+ZjyUxhoI5rWG47Sorzl
 iHOhY9a567WS4In+gqDkVx3HHfzg9GpiDdtrIganFB4y381gFo4nL+x09xDr73iF8BLhdWP2HL5
 l7aqqNKU+bIB4oSyL6CsqxHkIKhhFJubVmGr1E1GZxO5yD0CCWtObhTK0MPuq30Ty88uXYjhdCQ
 QMXWnqTQkCmIzfEftgpvlqABMGH+3i0fSf2UZsQ7gWrJsbpkFGYoh4PdropXXPs8GG5uuiDIoLe
 xOp8sxKLgd+xFCVDprQNmGyxwGoiNvFmCwpuilkzI2MvCkvYyvN5db+EHfHKGnJ/uc9lqx7pUL6
 hqemjwBzYaKc25c9JD1MuvLdnzQ/On3Tsrb7EC5Wfn92fZ+IbOW89ZpE5XEKlrwwzwWRbNl3Gj0
 PfJ8nwjnFhPIRv4RsUH034uZpgtMjpqmi35EtgYTNrJxX6jCkj0EzZZLP91tbWYkyL2jMNnJ9g6
 m9/gqpSyPokz0MhvpfXKFNwJ6Z+JM6hd5c4iFirSSUhEv3oxuWfRb4nsbcbOTci4ApNGfJls5wr
 H2R5Vx9SJYZTnGs/tqcRpAeDm+eAlG7T2Kmu978bkDJFsrIGzKj1enxr3EXEK7AizS3QKkgTrdh
 7OuWjn0T4XL2IYw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: scce7i6bt7a6eqe46aogmq77owhr5f58
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49E1940006
X-HE-Tag: 1771199072-964093
X-HE-Meta: U2FsdGVkX1/3LVmrOEjN/Lm7JLfpDh1f6t9lThPWIFXC7wSQgD+NMm+4JuzE4yJQ4x+9oWomIfsMv+MBppB/1gpF4O3hAOmLDpOAFCh0MNs6MMkvFIx0tCIAFML467pH/axlXhSxu8oELCdAVNleu5wsDNYOC6VBz8CCvN2NaIOmx17i1zdSZTAQT/ChLP2BZRWys3lCwPKz2zWKIht7/VEWL0bQinaZTkEGaaxpf5klCp4wjcO04xzboy3uPcDmhsnMlSaiANZ4GSps7NvXjb8VL+GGNuCFLPXvK2nXMXMOpBESZfVQsFDPYGkwowp5N7mZ4EhUFiXkLGk50sDuAnWUVboOYdL3jMdNgLQYIp1FtuBGL7NFPHnW70xxDBpspcm8pybCCkXke3PySW5Uk4IjY/wfyzqritNMmbGd9II65Ew/gpJPn6iwzFa83lYT7dbmM6cBiPWbALfMSIQfonwfS5c//ZFUZIgaTRL1MSSOx82weOF1+oz0ZSXs3WmVFrf9akK4Plp51gJK4AipKAkgWIAsaVA8uqIioiXxvjB5Xw8dJMpfzqYOTgruguxwuPHkd4fdqX4R+ikKTgp87enWPJa1GmHHyt/8C3Ex7QkHjeYfLTtQH7roIkAVKbLzbtVUwqyhADBtCRHNj47jhnlfq69PeL9Z4vwdLysWB+4mjBmOXWIKdYu00Gh6l3mHyxV/1MRBR50vby0IZDBL8SqhWY+AOzljv59+AV8Q5CMQrBZACbBx2BPhXM9x2kYeVGNkmBlXLUGqwpOS627kpYF1KBCbDgK5aTZD2Q7ny0RIngBIe46jH0qpVhsSj6wA4n853dBEXPhlsu0N/T28gGLfXvXODpqZVmwsFA1MKyLaLZ2Cprw1lnuNC+dawmJqJ5PAfYlWUhdWY/Uos12VcAmTG30t5c4CCctGZvhjI5ewzBXrLB9jifOuzfRB1qyOi7splnJKhnAIk1ZehyB
 UJJTAgST
 +IhQ+cGn1Z9WZSZJ0/IsZRjrwgYF7DTyaoRwA0znJtqJWx+/I4nPEq0WmedMY3n1DgKES0zC0hXqq1W/a13/InQRbiykcTIM8AunxgX57DhHnIfbNDtdwH54QUisBAjHX+C6keBbfjFnG3U/YesszkLSlsG9KgIPqpPgewTnguTPSOyQ7tLwzW6uapoY6RXmbmff7gWVAUOphSpA4j575u7SfGE1lFoEgSrKI77x3UVNYdsu5ANVM8fWh1HAgEc1XzzOihy8PxVk66WOQVHyP43m32vm+P2VECk7kcdmodogK2XGsLuSeNLu77/f/dgK/RsC3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
 rust/kernel/block/mq/tag_set.rs | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index e6edc5bc39312..4d00979a83dbd 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -4,8 +4,6 @@
 //!
 //! C header: [`include/linux/blk-mq.h`](srctree/include/linux/blk-mq.h)
 
-use core::pin::Pin;
-
 use crate::{
     bindings,
     block::mq::{operations::OperationsVTable, request::RequestDataWrapper, Operations},
@@ -13,7 +11,7 @@
     try_pin_init,
     types::{ForeignOwnable, Opaque},
 };
-use core::{convert::TryInto, marker::PhantomData};
+use core::{convert::TryInto, marker::PhantomData, pin::Pin};
 use pin_init::{pin_data, pinned_drop, PinInit};
 
 mod flags;
@@ -137,6 +135,22 @@ pub fn update_maps(self: Pin<&mut Self>, mut cb: impl FnMut(QueueMap)) -> Result
 
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



