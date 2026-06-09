Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA80ACD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:16:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EC1B6B0107; Tue,  9 Jun 2026 15:16:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C3F16B0108; Tue,  9 Jun 2026 15:16:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B30A6B0109; Tue,  9 Jun 2026 15:16:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3F46B0107
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:16:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABB71165009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:07 +0000 (UTC)
X-FDA: 84861329574.18.D6011F5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC691A0018
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:16:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jw3H/Q3g";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3lgi4BvnuP8dvWHNylWqJ5utFJtojJuMjE3Nz2Xk8c=;
	b=c7cU8vAhq/TDg2ZwKWHpj5htX3tWqgE1PN7Ro05IiwauO0bzoDmq/RvtqeL/0vVbIFIlR7
	m2BA4OPhGLGuDDtqXcqV5b22kGOsOmuiaf86+ZEQpEVHvfUU/LzkilUEgu6Htyu4bqxPGu
	uGAXnJhPp+iGSQBsu63yZ17AhjeSdG8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jw3H/Q3g";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032565;
	b=TuzduuxsVtoQMP+xjXFR7/GSCaaLdkK6T+Wld72P245FcXB7D/PwvXl6VIZUxhDUEnylv+
	bjnk+QPvCmlo2BiPcDQ/4MTiz6QCs7dFGm1nlHfxEVsqOSxjsa2LNjYWRap6hbrXsbxRmr
	xj6H8AoZsBe5LW2oOIR+LlZQV3gPKtg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2987243E31;
	Tue,  9 Jun 2026 19:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3CC1F0089A;
	Tue,  9 Jun 2026 19:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032565;
	bh=G3lgi4BvnuP8dvWHNylWqJ5utFJtojJuMjE3Nz2Xk8c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jw3H/Q3g3yHtjPIAShUuvFoegF8tqdbx/yiX64UeAWL7gLz2R6aeB/6bcgMAFYfX+
	 qdr4L1CerL0er728ZHZ4Vr6lsEleYCtd3dnM1gVcuPNSHRNCKoJDUGyhJOPl29r8Wr
	 1Oil0uJnHHH+WNKeCm+hmTHJVTv4dLZnonRPThd6ol3KUnHqnD/ZzgZeIZ1k2pGy/O
	 yRgp4CsOogjtHlhnDlBLw7GnctxuUYzeFbRPQxvLoZCdzkSLN4TI855YFEqxLge1F/
	 SLFwSDUDMLgj8nG8tj09nSbVLo7TTTl65FtYZyDwBUa1kUk0ivIFg+ayFQh/AHQ5HO
	 Plw+Zl29cAUAA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:33 +0200
Subject: [PATCH v2 54/83] block: rust: add `map_queues` support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-54-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3830; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=1/oGMHKJngamxy/YHU0uRCSEeVu7aFtuzPGZ9TvHG3k=;
 b=kA0DAAoB+lApCKrFvdAByyZiAGooZOWj3cCG2U8+E3n3Tx3zuIx6/yQjgqJBN0irwutd75dDd
 okCMwQAAQoAHRYhBFeK2cjZZnYmKsBqhvpQKQiqxb3QBQJqKGTlAAoJEPpQKQiqxb3Ql6oQAIXd
 9lWv1cDgGI7fP3R1gNts3WYj4RA+OhgzhbTerMr1sIBoD0a6gKcGvV0+p6o1sVFZN1iqIka++11
 pSozYjaes478Tbr6cJMx3Q+rvpZfWhuSWzT0kIO3Gx858LHrufA6VpiyzQEMqYfdKM4N8YYZ3kn
 I31DkpEe0tsQ1kphWJ5OeqzzVSLqLmmNhwTtLMVQoLlIiv9L+btIHGNvOyL1FLNxqt5KFnpsg2Q
 FDbbKUSUEC2poyjuCxLGx7X96fCyCoodylGu1pGpedoVJrJx5zxgYLhrbqTYvxsX7S9hO6cuXnj
 wdXrYDMIay2dzq4IEv2RxfIgInhaYr5oQfYZginSxw6xpMlFUOAkpv58qPy1sdd8obSwM/JkwSY
 JfC3oi7LqjzLVuwSoJPMZL/TLG1j5h9/wYTeeJhnws+FmdbuaD8lAQhyqt24+0N285pOEaupAY8
 1aplUuy556oWZH0R36MfNMevlodFy7+Na0Bu8SZr6YrBc6lJmkCcF0LJzEnd4VEDKyIID99DLza
 WO+RHsJnYLWflvvnRqoX7Sv/98qPDWQ7pqmdO4e/wtVyr2MGTw2IiC+piaHEhJqv0ToWuXfNiSe
 ieHwW6vuyMEuinefgYAI8anN6jcQgvPRUEWxdNiltSWXqYW5lDP++LXCzr/ITiruskuIJ5FnOMU
 e+Sce
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: hw1sck5rbiqtxpayngbcczgws4r67u1d
X-Rspamd-Queue-Id: CC691A0018
X-HE-Tag: 1781032565-555940
X-HE-Meta: U2FsdGVkX1+6SAXcT7COM0S0fUK8TGwQWyfqUcCtjaBhr9h9So/4x8y3Q0EcnMxQPHZWDe3/eurWohgpDJP/fF9d6Ef1hYxRUGAYlMHc+XQMEu8UC2Vc7V0/2cCR1AwiQIoKK8a66qjOUOq2Kkp/AVte3pim7TdWUQE+3Z0AnwXZSbzsVnaJKVH6iQ39HBoB3X/mhL8h/0lzq0lfwR2xt97MCQA+4Do8dLxQn1CXora+lTOBqM94dnd+79WToCZds+tGbYR6gaNj4mYLAVMFYZln+0j4RaLaPmtJtbNzQHQBgrdgisTkcMxDhqic1AmOUoRsIGJWW+U4aKGv0i3pQNSRmoQiie/HVdxQfv6nO9jk3vy6ivOGvlnIoSeUIUrXJvkCltwnB9imqifvJtJgx+tDeIdoMYWmbfOSSKF+My5FnmLuMpucPlPcSg2hK8mtloyHA0YDA1wzEYfUeDppMW9xp97DLC8+UBRnxcqImttfJAuYQvfHO2pbfARZPMRPG+xnBd6fd5O69SJi1vo+C9xH3lfxw95G/nDIJgpx8N/smKVkYmpg3Z5O2svbADOwSk0Rb0uxrAOO2iFN/EaODp9U9xxDANSPBDNlCZK1VMeS9HncQ5KiGC9SvLwwkMqLrw9a3OtaiQi3oslV57zAMRoQY5tcgxdmS2V9fFEMNo6z6xRMgVEV2z3pKkq58QnKq/4PKZXF883q1n5EQ1ai6vDM5DcFvrVT3sUCNJFxgGjec9rcIQpuw0VTIT0LwC8WRIeZReaNECSMMk6bA3JmmCWG1spKdqMKfklnJFwCwqqwxqgRkhHqO2D3SvFBHxYNAWi+iQm3qo1/9EJDj4+3ZAbi17RwAWxAFEv2HFjrB1PBC1rn+bw2lj+auCHCnxveVNtkyGItCwPviK3M+9YN32fNeQ74Rtt53krzb+UxrQC411MK2ra5dlEhOpzXTvuN0p8g54031U5wUfL6LzS
 +q7ehZrV
 hATTbyGuYgUlozzENrNoUJERhcwdDoXqvaIfypQI7htMxd52KEAPlmUU5YOZcxieM0dMRjEI7CdXc+mDl0zjShfXr1KddONAJx23ziVF4lciOHjXN8VS8DTW7SALvJbtSwEiA+K+RNQ/RGQdjVjR4RYaMU9vQwD7g2SR/tNHTBhJ3/pyu0iw5DcSoQCeUMSLDMvjCtTrfgFekx0Jza7fF/NgvyyuvTvzPDlCp8/qWdJxFt3usFXDLw0AzQZuNt4QCMI9w4TO7verof/pgk2bHqtRj4MFbdI4RkObOM79w+hqG+9bwftiwzX79XioMhKj+a6yQtpAQpLlHoZYr4j8Sma4YsZ3nKP8tnqe2L0Mhx16dsekmz9cHbsL1TEMsGw7bfEZHj3D8Uwb2/mg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add support for the `map_queues` callback to the Rust block layer
bindings. This callback allows drivers to customize the mapping between
CPUs and hardware queues.

The callback receives a mutable reference to the `TagSet`, and drivers
can use the `TagSet::update_maps` method to configure the mappings for
each queue type.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/operations.rs | 29 +++++++++++++++++++++++++++--
 rust/kernel/block/mq/tag_set.rs    | 13 +++++++++++++
 2 files changed, 40 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
index 71d4192d627f..8a418bf0f3ba 100644
--- a/rust/kernel/block/mq/operations.rs
+++ b/rust/kernel/block/mq/operations.rs
@@ -12,7 +12,8 @@
             gen_disk::GenDiskRef,
             request::RequestDataWrapper,
             IdleRequest,
-            Request, //
+            Request,
+            TagSet, //
         },
     },
     error::{
@@ -126,6 +127,11 @@ fn report_zones(
     ) -> Result<u32> {
         Err(ENOTSUPP)
     }
+
+    /// Called by the kernel to map submission queues to CPU cores.
+    fn map_queues(_tag_set: &TagSet<Self>) {
+        build_error!(crate::error::VTABLE_DEFAULT_ERROR)
+    }
 }
 
 /// A vtable for blk-mq to interact with a block device driver.
@@ -418,6 +424,21 @@ impl<T: Operations> OperationsVTable<T> {
         })
     }
 
+    /// This function is called by the C kernel. A pointer to this function is
+    /// installed in the `blk_mq_ops` vtable for the driver.
+    ///
+    /// # Safety
+    ///
+    /// This function may only be called by blk-mq C infrastructure. `tag_set`
+    /// must be a pointer to a valid and initialized `TagSet<T>`. The pointee
+    /// must be valid for use as a reference at least the duration of this call.
+    unsafe extern "C" fn map_queues_callback(tag_set: *mut bindings::blk_mq_tag_set) {
+        // SAFETY: The safety requirements of this function satiesfies the
+        // requirements of `TagSet::from_ptr`.
+        let tag_set = unsafe { TagSet::from_ptr(tag_set) };
+        T::map_queues(tag_set);
+    }
+
     const VTABLE: bindings::blk_mq_ops = bindings::blk_mq_ops {
         queue_rq: Some(Self::queue_rq_callback),
         queue_rqs: None,
@@ -439,7 +460,11 @@ impl<T: Operations> OperationsVTable<T> {
         exit_request: Some(Self::exit_request_callback),
         cleanup_rq: None,
         busy: None,
-        map_queues: None,
+        map_queues: if T::HAS_MAP_QUEUES {
+            Some(Self::map_queues_callback)
+        } else {
+            None
+        },
         #[cfg(CONFIG_BLK_DEBUG_FS)]
         show_rq: None,
     };
diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
index 157c47f64334..d3e93ad98b6e 100644
--- a/rust/kernel/block/mq/tag_set.rs
+++ b/rust/kernel/block/mq/tag_set.rs
@@ -116,6 +116,19 @@ pub fn flags(&self) -> Flags {
         let flags_raw = unsafe { (*this).flags };
         Flags::try_from(flags_raw).expect("Expected valid flags from C struct")
     }
+
+    /// Create a `TagSet<T>` from a raw pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be a pointer to a valid and initialized `TagSet<T>`. There
+    /// may be no other mutable references to the tag set. The pointee must be
+    /// live and valid at least for the duration of the returned lifetime `'a`.
+    pub(crate) unsafe fn from_ptr<'a>(ptr: *mut bindings::blk_mq_tag_set) -> &'a Self {
+        // SAFETY: By the safety requirements of this function, `ptr` is valid
+        // for use as a reference for the duration of `'a`.
+        unsafe { &*(ptr.cast::<Self>()) }
+    }
 }
 
 #[pinned_drop]

-- 
2.51.2



