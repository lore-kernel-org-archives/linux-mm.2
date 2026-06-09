Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C59CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:12:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F876B00C4; Tue,  9 Jun 2026 15:12:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557436B00C6; Tue,  9 Jun 2026 15:12:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46DE66B00C7; Tue,  9 Jun 2026 15:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35E876B00C4
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:12:51 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9B4EC275F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:50 +0000 (UTC)
X-FDA: 84861321300.06.A0974DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 307E6A000E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:12:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cV+8i+U4;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032369;
	b=p4uUeSqY2a7Gey3dkHD1vkA9snrKi64v++BNDHjCI48c6GOuYHZn8qCB1rwQ+jFcOk5lpN
	3KxAqB97XugIhV2/XMRNT1Lt3iXAFg2T+PJOvD6wObAsf6pEMXgqbxhywas5L+02f9npIA
	Shp/dCZ0PhC+3y1myxe6vzuHG1kW6kQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cV+8i+U4;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E4zTF3buoXlpdVNSPu+eDYHPwLwVvZ/+F/dMjwaTG3c=;
	b=onT8FiT+LazgTxYktCmr59fib4fH4HZ+CrPPlwl5IeKpZ9HccBxtWXyg5c1EPpHoZZ+y/j
	LkWqHmGi8fuDWHHpjucStsLn0Gtq9oM/tiieQD6Vjx4MXdsOEzLaFdN7Ruh7RKIzdic7e6
	OI1/jgfkCzyMnQEUsFJ4isdB3pgAWp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C3681602C4;
	Tue,  9 Jun 2026 19:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE171F00893;
	Tue,  9 Jun 2026 19:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032368;
	bh=E4zTF3buoXlpdVNSPu+eDYHPwLwVvZ/+F/dMjwaTG3c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=cV+8i+U43n6XAVH0qKkpGqpEw8THPoG5GDx+77Vr2ca87tK5ut2BVqSJULdHo1hL2
	 p141gWkNxfeG+5Mp+0//5KGEv9Ew8Es2Wg2t0JcC0kWYLoBPXxGylq46Rbn++CsN2C
	 rxRVwg2gLrybVWOZzFw/p1pquEa8GbekwyeJNuK0ZRP/FSAmbjb+yCzjvUogsJBlQt
	 z8ObVLIcZlAamjFkoxSImz5RQ0HosmKZe56bJZwHqpKYXNk+zUVqyNknLi1wepHEnA
	 5nY9UbuI1j5int48wYdOuU0RwIBC1XMNTg7FIYdFlvDav+85pC0rfutBWdBWXAsGBz
	 eF1kGp0QexmlA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:54 +0200
Subject: [PATCH v2 75/83] block: rust: add `Request::requeue`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-75-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1374; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=scALI3Of9papCU7IjOqZJ1u1Kulf0qIwjxsjg5iYtNw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGT47losJJyzKx25dxqwhmsAjiaceinSmISuB
 74LtHjCMIuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk+AAKCRD6UCkIqsW9
 0LVCD/0f5aMN4ivKJwIUmvoBpEA1oTSTTcWwTQ16DMSlB5Da4QnuLb8vhomM9pCloc5XmQfBJVe
 qfLrZ5PEe94IN8vCQ9jUEmNPGg8kZai0Z2UmGyu3saUkwWfk35EPalRebaU3bFakJe6Zux3Qn+C
 BCA1441jxGPWzc5hT1zAYwETUK1gDEEKvXgWWZYByEBtyvtkSwHkbMw9Abc21zj4l2Whif5mdt/
 p2E7/Ua4A4a8xt8TzoI6cUe0EtH4VjqAlhBpMl1OSy2GPdt4BKGdA74sZFsePhuN0+m36iX32Fr
 l9ulhIZ06xNRCWeDAZQuGVHa6IFUBTv+ttHLvkmOAygMpix6R6KEY1jCEij+OgWFeMuIQ3cLYiY
 Q1+XFRy6t5fRHV2U8l3jB8bwJ9e4oqpOGWtxMthi/JNx1k06WvYkvrZtgb815J39s/qrSB79ek0
 NdQxosr1F95TF2BCXp5PJ+6+r1rS3EWQXxkXrY0X4s5Ohqnb1+mP4veGTa3jC3Dwo1XEGnbdoKd
 yZBgHkUrRaDXNEalYdKUMv1k5ht0gKKOD2EDZxuSqjhtc4hkixpQ9DzFIFEL7GnPLf2zObrUTFt
 l/FDNHE0kaVd9ziq2D0/SxRMg19xpq/cFQjhPzccSgFYHbvH+z4wESovJwNK3B9azUnXASAq91T
 jXMzYewRKtk7MLw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 307E6A000E
X-Rspam-User: 
X-Stat-Signature: m8k1pci3xowfaasji3yanghrj68t37bu
X-HE-Tag: 1781032369-563298
X-HE-Meta: U2FsdGVkX19U3YrUonEm5C4aKffbg/OYNZe6wREaAqdRQpsUvsix0Trid5l3lbSGSTkUOEvakN1LdUP+GEazWoBrgaRS/zY1FBajQO+LIYW+958ZBvkVW7QI24WCrviH4ZnjNLqNnfVg+SGjw0nHdFOw6YIhhfqlpGYsmlBbaxSD0hobrX6uANsFT8RVkriGAU8LLPv0fbdEvYyXaZ8Ua5S0KqRl8usKmByqKrQN/NGdclzshR/P99MvoNQpMTlIZFjnT+rxoXdonS6/IHJuP7BtfZfmsewXLBPNHRSC15yJZQsfNv/LlpR5UyGFSh3mHKJ7cPpM4pCGMXe00bqp3IRSAJE9EVzx7IXgiV5mQsmBJel2pnw/qZb0ZsgnJI+Q792iJSaREVqqXHeAYpGkodspCz5k5pbwrvz2pF7U+g8v6KGZMR1DsdOqPk3fdej9uaCIgbzmVDeSz0l+3NBwVnxwk5Aq0yHzmP0lOMzQ/m3xya0oEKao2CuuknXiLOvv79kG04zYYwSRpyrj0Boh+9oUqxKQ2dsf875TUvtixqG/AMkgUqj34ggmdkzAgq3NcyrBq+/e3lxerfTW8yC7hvv3xJ0tsUth54WEjaXGGe1K7wdnQZ2sPlbv5f++aZ4Es97mKOvueWD/KdzS3GxJFgUIW5e96yhWm+z6DWSFMYnIM3P0iN+lZ0Y+QMGgugu+mg3BBNGjC4prsS20OXQCfWqm2QkjC5Tz1TksTaSaUr9WJ449dnCudLRywqARYA3C9xBnNsA4EwfNNP2iqS4VkntSC48YSlVHlGPi253Yf1yY//ARVO4QHiO8o2xll4TQgvzWaBVixeZtY/EeEZYX3iMJm6NFBJX0LUlXcaSqgcyD75lcrNA3yVzWX6pS995J26rraNC04IsIwqaW9f+6JjYBj72PtJtnAiZ4xdwrpFSScgXLfVsO/jpaZ7NkqYD+aiHkjeeujMHPS/P6nMy
 i1F42mMN
 hCYTp7fri0qYnHZP8DuD6yUPIEgVl8DvJ9yU3d5V6eXWt5F/fwDw0qg6MKV2fDWDRRwGll0r1Cl/gpTSB7dBfZZRLu7WSH7t/TGilHTlM0IcwbNM0wf87XNaoe24FujSPnKcdMSGzNAUIB/KoKc22gh6UGHQxdiaB7IX4LTY+sc6nC9HoXMkpf1ki3nC9XmY71OPbfZMr5vzuX5W3HkZLDigk5MDT0GoNOANjnLxNpNG7JOknzwaWNK8a+UB1teBWykSMVDnUWgsVFycV6jPx3ETJwUBsXY4EEBTwXsjd8vN4FBsg4oNCRiVuRPKTLC/yvDGq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method on `Request` to requeue the request with the block layer.
Drivers can use this method to send a request back to the block layer
without processing the request.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 54b5202567f8..bf6d58139ab4 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -100,6 +100,18 @@ pub(crate) unsafe fn from_raw(ptr: *mut bindings::request) -> Owned<Self> {
         // SAFETY: By function safety requirements, `ptr` is valid for use as an `IdleRequest`.
         unsafe { Owned::from_raw(NonNull::<Self>::new_unchecked(ptr.cast())) }
     }
+
+    /// Requeue this request at the block layer.
+    ///
+    /// If `kick_requeue_list` is true, this method will schedule processing of
+    /// the requeue list on a workqueue.
+    pub fn requeue(self: Owned<Self>, kick_requeue_list: bool) {
+        let ptr = self.0 .0.get();
+        core::mem::forget(self);
+
+        // SAFETY: By type invariant, the wrapped request is valid.
+        unsafe { bindings::blk_mq_requeue_request(ptr, kick_requeue_list) };
+    }
 }
 
 impl<T: Operations> Ownable for IdleRequest<T> {

-- 
2.51.2



