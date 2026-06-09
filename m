Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E683CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:16:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02E186B00C3; Tue,  9 Jun 2026 15:16:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 005316B010C; Tue,  9 Jun 2026 15:16:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8AC56B00C3; Tue,  9 Jun 2026 15:16:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D502E6B00C3
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:16:24 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08880C273D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:24 +0000 (UTC)
X-FDA: 84861330288.12.95B958C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 47E01100004
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oErhkH5/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+XDXLChurzP2r5iP0BK/Xmgv4b9xTF7r8tpuv8eUXo=;
	b=nNWih7dGpYAWVwZn42H2F8DwPlAgQ+TBZSP5fAV8ZH7ycP6L5GIdSAb0YqJ5lJ+UHg3gwI
	Z5/YoPefTcrF2b48hbJCjWtIBlf331NRX4o2n03gRPU76bjAnyyb0ndkSxFNvHauGNXm9g
	aaUnW1VG347fF8gJAUEoeENrC+bSazs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="oErhkH5/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032582;
	b=wkHCOhseGXncfI3oPoy/Si4NGUaY8f+FZwoRKsPPMVSPVTn4ToewP49MVQqIGzFKb8kj7o
	ChzdTZL9E4oI7v0fMHlArq4IAZMsgnJ+sI+opi+5IvGq7atAs4Ji9JiUHjrl9f6sSWh1id
	kGU69G9SFVpqn/A7LlYowt65SQ/poTU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D15A1602D6;
	Tue,  9 Jun 2026 19:16:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7FA1F00898;
	Tue,  9 Jun 2026 19:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032581;
	bh=e+XDXLChurzP2r5iP0BK/Xmgv4b9xTF7r8tpuv8eUXo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oErhkH5/RvsU0pYxaGvsH8J04eqib3UlDmfBu006mx+qHGpOK7zmrbYXnd8jITMuF
	 pc81Wo2vAhP5ShprAawD0YzrZr87uu5PIeaaLzwRLlCVGDDSBs9TH2ljfGejE9QFLo
	 1njvvfMDcPJU8TCJTTuhAe7mvxLaofUY6xXDExPkk+GqRIHJMnXa4IJQ2I64+mQ72l
	 k+yiINMEiMIk1sgMwmop7aLKxDLB8ovJCfSPMlRtQWXqeB9LZRg9L+e3S6ekcNJT2b
	 QutGQosDKhYG0taub6tEw+i183GSKcSUN19YbgznxPNE29KMY1fZzL4VKNXx8/NsZX
	 +JGLZ8fby/Z0Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:52 +0200
Subject: [PATCH v2 13/83] block: rust: add `command` getter to `Request`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-13-82c7404542e2@kernel.org>
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
 rust-for-linux@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1258; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=JgJ/K9nxltyXzGsFxBuvnKQJ52RCZyxIiod6jnOKKd4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTAUkk0LcDHa3vjJ0+TBKsyJketYcEgtB4lQ
 W0HgArxGNuJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkwAAKCRD6UCkIqsW9
 0IBMD/9LTXBuBuAUnixSWlmlKgnI0lwXtwNfEAaUVoVY0DQ7Lsr+Hb5gWYPkTVBCmyKN8FWHT9j
 o4tQWP+BaptnALclsraBmmGiV7+m6J2mJZtJFRJosJIaDUkJ99PN0+Nw5GxTUl/vAcoKJiM82hD
 Femk99RwRCgWkb9zu3RpDebOw2ZP3ssLMoxeKASj7yTQpV0bBaiuWMCfQTYBhnOebVQd96l9URP
 sPHS1MuQeUcebhigYWJn2EfeIke8EljTgjcQvQf1Kf+lkqWvM5TRf44GXxQZT1mZPjtsBwrBwKu
 tfWGwgloAAj6FQjS/nZqrJfmV+gjIOEwQosq3LNCAkwFhxW572m/UN47kUc0dvq5qDSnrI8J3JM
 yuLJODtcJjkUvj5ewwqZpcYa16o+/bS6jo1rEG/EU7Neoni+FE+5qw0Cf8TU70WqqoVMdimrQ74
 eR1SmgLCp1Q4/dXLKctTGI5wSOB/MxtUw+ecU75dVlvSjGQpwDOx727LR2bhbBRg7TJy/KFw9lC
 iTRExSEHadwSnr1F9vreBiS2LyvcUVkNiQp0w3s/lNHw3hYtCiCUD3NNPyWUp3WzvJ/6HBm9rtW
 +3oIR8BySUbSN40gULMBY64GsLjcYE39eEbdR606WEgnuNvqhOvfals2ZGW2mmHiEPNV7wEivcG
 GGuPyYMYUFbkwUQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 47E01100004
X-Stat-Signature: ac58c8ppagkfqqsuiuwjwc6amb4y77zj
X-Rspam-User: 
X-HE-Tag: 1781032582-367992
X-HE-Meta: U2FsdGVkX1+UqIvrfUFJIGYaig5AqfxYNxYOPrMrIHjdWSmUpMRZpSmZlC4UptNv7EZeFboIlpg740hEstiybzo47MfjmC6cE0CySEEzGfmP11HQ3l58CR1cExEWOzp8xRjfbYyX4XQTTZXsGkaK3bRXY1VugvY8vjYXrIhrOy2XfHb+e3ePqECLlXyaIVGo5k464pu71d5CQ269NFjK81c6ZpwQUnoSymC+6vUjG2AkOlp8UE/5Jp0yDwKMo+G/K3cil6j5YQ7o4MC+i2vpkL54O81UUG5EaXAj4Fwcm0gRJUh4+RKwkif9E97K855fTA9zLA243cjw81AqYny3ORAc/HqB1ZNgvrk4BIzcHOa1lq7Sby1tm3hdfth4VWo5I/ocFfNRPCCHf4FpI71oYcw87nBeADCmLPbhBetphjRcMSzDDHJ0RoWTASQmYfVIWuCSctmADjNCZp7FbE1Oon2ZvvH6CjtlJ96WaD4TmaYKN6/hYp6M8r9IfCzHT1klVJOTF4JyFgKoRL7yEQEYMyxfeInG1wAlESplWyjwW5GvXv3Ko5XUwDEhC11yrQfUfgfBq5Es09vvm3TxWTq3dDboSyWOZW85tvZILBykg2Dl2No/Y9wtKoR6oyjIzqQ9JT/n8nGQTiXWwvcS3V2viApKi2+rXoAKv9B5It5/76k+lG7uzlPiKWVaiMJOCUKBWyPvd0R3x9AgXIfuQoI7/PE/HV7ComjlpRjCLw8xVw2icEw0JqROR8O8ifwK1bM4NGmNj4LINXU15uNQCqodpy6x5XhyMZjlcxONxuh+Y686gEfQQBKgeoOp2az2a3t6u+Iac1jBMo8t5tEW/0yYAWftnGEFFS348FlnWSSHtxDrgZtvUqHNkG1BersejN31WdhPJyjAW1FPhWNoGRMqe3qVvOjActtQ+9pL65vVhvF4VyJED6qnszYBMa5nzrXOyspTMtyAJR1nGgkZPgg
 nAgaD8mf
 NRF3buYwiVWe9PTS2k4ODTvdk/ZobcQ25PCt8bGXXFqLMWqQcmp8DJ3OWOvWeVHgAdBGdXHyXrUiOqTldwMF5kGFwamB768vtlmBvvHnBf3tBt5Mx3ThNHL8AKvcJs5M+3iI43DJMlEtSbD0u+r4vCqgI0PEND8OnUNQqLb9Tns8cpEaNvOD2tyJtG7q7dxwxG3K8yIfcWYaGGDB+IfPyjTJbYkaq79c+u1u7OO4I9bJSzJ/KpoT7tm05wUk4Xu+eDyDBpwQyjnY9IbYwL0QytlcG/CWjTBCAFe35IRjAzAkg97DKxdhLzhouDnduufYMSIpidng+ruiLNQxpqgTE9HLr2DmRATLF7Xw1oIOdnUY1+lH8nTMnalMKWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add a method to extract the command operation code from a request. The
command is obtained by masking the lower bits of `cmd_flags` as defined by
`REQ_OP_BITS`. This allows Rust block drivers to determine the type of
operation being requested.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index 98e54f0586d1..19bdf17de166 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -116,6 +116,13 @@ pub(crate) unsafe fn aref_from_raw(ptr: *mut bindings::request) -> ARef<Self> {
         unsafe { ARef::from_raw(NonNull::new_unchecked(ptr.cast())) }
     }
 
+    /// Get the command identifier for the request
+    pub fn command(&self) -> u32 {
+        use core::ops::BitAnd;
+        // SAFETY: By C API contract and type invariant, `cmd_flags` is valid for read
+        unsafe { (*self.0.get()).cmd_flags }.bitand((1u32 << bindings::REQ_OP_BITS) - 1)
+    }
+
     /// Complete the request by scheduling `Operations::complete` for
     /// execution.
     ///

-- 
2.51.2



