Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1000606A321
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 16:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BhJ2oXyA
Received: by kanga.kvack.org (Postfix)
	id 7F23D6B05B1; Fri, 30 Oct 2026 12:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA126B05B2; Fri, 30 Oct 2026 12:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 707476B05B3; Fri, 30 Oct 2026 12:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48F656B05B1
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 12:08:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAEAF12069D
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:08:42 +0000 (UTC)
X-FDA: 85379775684.18.10A7AD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0EABD180005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 16:08:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhJ2oXyA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793376521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7M36fcQ3fgDKhbFyLRo8oIBbRY5mTb+mo+VuAVFbz8=;
	b=eSbJ6OVz4Mzg6FrcbgkvrHPmmqY53Kao08gbWbDcYjnCfE/LIOY4um7O+axBSKsNSghP9o
	WzA3mMzmxG3kyYEvYxoT8SGtXD+9kpj7x3A3fqP32G6TH7lDwV9eb1eDjAJ3SFzhLAWscI
	7sk6Q1R9r6GR1BVG4WU+4Mj82kAfQRw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BhJ2oXyA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793376521;
	b=lSDofu5RXddHtqL/wgqnojcIsOKEJgjxzWTBTCoQSTM8DjdTMUs4ACOgkTbA2PPMFdpwiZ
	ItWB0DGkD5Ffr8BLVflPCIy/82eti9j+5g2WTF9iIg0j2RGa32NHkwTtNlUTjjkKrGrldr
	5taxNpT4H1tnC8M8e1Yve2R3nrxXvQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 655FE60252;
	Fri, 30 Oct 2026 16:08:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9893F1F00A18;
	Fri, 30 Oct 2026 16:08:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793376520;
	bh=B7M36fcQ3fgDKhbFyLRo8oIBbRY5mTb+mo+VuAVFbz8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BhJ2oXyAmZN/AGUg0X8PAjQXM1kXzV9nmSfvwTUVCvH4HygdxUZyqfZ5QqSyFdgrX
	 OAioE1eCK1onMCQksys6oEUKv47D+fl2re7DFwBy1I7rNgP7gKK1PxqoujBzkY4ftG
	 z3SOaElVgtJwDbJfuCaBDkE+O8Apabv8tYW3nzok6ERnMeD29cne3NI9d6u7so/nDe
	 2GzVtJoht/3Gjp63Kvt0ONqj1FA3Rpy9/dqIlbEO42arb+KmsVXPixNWgcjjt5TebY
	 TgrMI7y2YbyqhVmqv/w1sGfDG+s8OCaAiwDHSIShs24JNsLUEnmoycMRxnmBltrpe7
	 ikHSA4b7dPQLQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 30 Oct 2026 17:08:03 +0100
Subject: [PATCH v4 1/2] rust: add a wrapper for the `nr_online_nodes` C
 function
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261030-cpu-helpers-v4-1-a8d840d34837@kernel.org>
References: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
In-Reply-To: <20261030-cpu-helpers-v4-0-a8d840d34837@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Thomas Gleixner <tglx@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Yury Norov <yury.norov@gmail.com>, Yury Norov <ynorov@nvidia.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1807; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=L2Apa6fRdkKA6Qf4luN+t9ccKqeXT4gN3AhxJlmxkcs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq5MDo3m0VI4RP1vtYFekrfZOq4iBiYZfRxzHra
 5aocTKkkoKJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCauTA6AAKCRD6UCkIqsW9
 0P9SD/4qnonfZiKqDZRPZSqqzFuurdhTBxv3lsWOkInLZXTCJmRYuir8wEDDIIY04Job3pyUjcv
 AB9AbRBrEcO4ywwhqzAM0Y9cLmY5yyv2hlnpFPZcOB3QygY9g9MqRuedS3bNMq0VD2O8JfzInVL
 WQcuM4CB5/lhhdEll+EtPbbh1LTUAeQ5El3vcAEzT/AfNBzNSXTNPVFz7zPTJid5NLJQhKhGSwh
 HGNUlA36n04SFMJ1iRRqwj/djo669f5XStQ4L5Z/hQSnE4pUrAoJsNuxgvFbYTdxLAK5/64faYu
 nbPLBvdU4ybr/AQP+qjeiAFYHcYegSYO6XUDyvC30XNbWFdYUv2VzQRlGDMzx838llSs9jRBgLO
 8n9m9LvvFyPigoRaN2hG1KHqkH3IUgUuIBdrxGVexbiI2r+88ahPHSSynG67JwT3wqithBF3GW5
 iIu3vdvq4aWXjS/+7EA/gI05bCNRFircBGKgvOHh3zGpdqBrRUT1BLPGoxHf0Tx+1nqaTvjhYpl
 RLE6CtE5anMB4hySPbLEBJ+8q+oBzsylXg9x/AHzOjzilPT8M1CbjQO7wCzGENaKsGgeXGq6wmC
 ps9ehWaoCnijv7NCJ092LdRampSS/OgRWJ1s6V625wn0/UyNSE+XpZiMaLfIz0Abaddc3fY7TfW
 lGJBMWpVqIDm32A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 0EABD180005
X-Stat-Signature: h3bfga5fdrbo69mmhe31o8tqnb8n48eb
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793376520-391356
X-HE-Meta: U2FsdGVkX1+heOpQ6FbaAAR4mLCEBXJ3G9zYlKjPlA1obqOg9ZXuSikUI3ug+c51882yuXfstULwOlGASEm3GgJAMXgcis0NmQEUBJArTD3E5fyCdSDfNyou205GxGt2qp9gGIUh5j/OrGg2YC8OI1fBXQVY6yYyJmf+BnVAZXeEflwoIoM7jc+Mw5xe1J7gCR9saltoFBvhnCBLGAF0AHmouPLTvb+omDj2OeKbK/H3Jwv26saTda/hucTNfyooTVfHIFQiugEfVasQfmS572VgxJh5VwJmzHf7CI2KpAfFkrfHStbybcS3m4pgMPRl23bb+WD7Ag1jVNr2uoOJNUwRPpgcZncbFWmeiFdRudf7XQ9pJ7uDdGWmo94pCQ0PXmrRD5Brtx+ScksNSSzFFPNhDx5A7eag0Zyqmrd7d4OGRNzylROJbysDtaqzRb1St2ERU06CZv1bUSzVXTsyiDnGdaG/94qjXbUpcbnOhCRkRESVQeep7O1AJ+dgYsUdvyL+US8e5BGQ5wTLIdh7DNOQgdIqteDHd8VvzXZ57d3fcsYcek5LVx3fKzpwhEqjSkmlM3yJsAcBfmmPHdZMcWgac1YSZP6otcYH3LO0A9DNRfwwDLiVL/r3mTgwj+/Gt5vsiNgz7bkkqu2GISvM5v3O5aIUA1c3R+xyOOhdFuju6k85lWjPJm8CK9O9DrD4+po10SYRQu/+bD1/lwDYyRETtqZ618aM+FOTauk8dbbenKOlcKRkexQw+pLURVEuor1fZtJX5wyCHqc9yKvYSsFsfT0HHJkxxlQN9Ng6AuNOttZN51ets8/my68aGcJuuVwx4dNXprb1CL0XlA5lo6Gg8uM+jRjMsTbEwyiXVrrsYXqReZCfE3PYSZD2p1AXOey5nN6uLY1qnkgmVscXrs6Yg0GFn3RsGdh3XW3CiDEIAoe391wUMELeS9DMhrQecTS+jzX+zQ6e9mGh7+h
 JEBd4rpU
 cBFApUXjtG3+4jv1C+T0YLPWcpA+XBSoZbtCnQjixvnLow1TzYrwiYPElQWsSAzyGuxlYFIdnxs1j9T/B8O3vfuU7/sSX6eQ239gmakS2+NL3UdzBe4uhPpqVyt5j4n7f6zay1rKQS2M/Q74XP9vrmq8ihc6bMNcCjKxnoVOiMxwEJ81zNPfE/RPrMvULQYR0GLXZywEU5v0D2Z9XCijPpQv+oXHzhP1UdCoVcF9xwwT6sdXhbLUSGGzr3nsSqSiIVXUt73/1YwAFXbjzFiKLy7Rw6eIyn9i2PFtnsDY7ICu8xhnB6BU326R9QG6ruWEXivutmt/ENKgwI/0/kn2eXT5pERuG518xL37ihhR8XKd4/NbX2H602AaOwIwd5VJQzT8oheCwVrbYD3u1mzIfsgH6/7byVZaDnlaVOkOmCW22JLtF8BiGLXmopq/xPlGsD3Id
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This function returns the number of online NUMA nodes.

The wrapper is needed by the Rust null block driver.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Yury Norov <ynorov@nvidia.com>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/lib.rs  |  1 +
 rust/kernel/numa.rs | 29 +++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 4d5c96ddc49c..a7b1c9cf454f 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -105,6 +105,7 @@
 #[cfg(CONFIG_NET)]
 pub mod net;
 pub mod num;
+pub mod numa;
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
diff --git a/rust/kernel/numa.rs b/rust/kernel/numa.rs
new file mode 100644
index 000000000000..164e622d325f
--- /dev/null
+++ b/rust/kernel/numa.rs
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! NUMA topology utilities.
+//!
+//! C header: [`include/linux/nodemask.h`](srctree/include/linux/nodemask.h)
+
+use crate::bindings;
+#[cfg(CONFIG_NUMA)]
+use crate::sync::atomic::{
+    Atomic,
+    Relaxed, //
+};
+
+/// Returns the number of online NUMA nodes.
+#[inline]
+pub fn num_online_nodes() -> u32 {
+    #[cfg(CONFIG_NUMA)]
+    {
+        // SAFETY: `nr_online_nodes` is a global variable that is valid for the lifetime of the
+        // kernel. The C side updates it with plain writes during node hotplug and reads it with
+        // plain reads. A relaxed load is the Rust equivalent of `READ_ONCE()`, which is the best
+        // we can do on the reader side.
+        unsafe { Atomic::from_ptr(&raw mut bindings::nr_online_nodes) }.load(Relaxed)
+    }
+    #[cfg(not(CONFIG_NUMA))]
+    {
+        bindings::nr_online_nodes
+    }
+}

-- 
2.54.0



