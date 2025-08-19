Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A56CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 10:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D3B88E002E; Tue, 19 Aug 2025 06:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25E648E0001; Tue, 19 Aug 2025 06:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 012D38E002E; Tue, 19 Aug 2025 06:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D35358E0001
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:34:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A9AD5AEF0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:56 +0000 (UTC)
X-FDA: 83793148992.26.E558299
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF8A14000A
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 10:34:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2DY3xdWD;
	spf=pass (imf12.hostedemail.com: domain of 3TVOkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TVOkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755599694; a=rsa-sha256;
	cv=none;
	b=6EZD0L8p2CZSBH1czNEShzNKPxU+/PUDhZv44c/KKUOf4KGGwkHbEFedifchMyYPgcMHl7
	rfsVLKc3wAhI5NznWqn0Sryft5vGeIN+JGAJ8KCRKi12Azfkoxm5nBxFS7R70tc3ND5ve8
	siaJYPyw2uwpM9cnXijNb1zRCR4nWCI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=2DY3xdWD;
	spf=pass (imf12.hostedemail.com: domain of 3TVOkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3TVOkaAkKCNAw74y0DK372AA270.yA8749GJ-886Hwy6.AD2@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755599694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pfxca/vdoEge9OPiAMRUJ8vrOmkvClzZNcHuu539GzA=;
	b=1/k37jzZp8q6KW9hbpGMUEv8m+8WWn9A+yOpxNyo8NgHP8igOfZWWBCZzxm4GzzF/TJloO
	4s+cxTdGg2cN98Ui46qyYQagImmwjpFO17J3aP8NHjwRyPuxmX9HL7r1QAGunaJw2+OV3R
	bcn+H1UJLmGF/YADiWtwZnwpa53iLoE=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0071c1so18701135e9.0
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755599693; x=1756204493; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Pfxca/vdoEge9OPiAMRUJ8vrOmkvClzZNcHuu539GzA=;
        b=2DY3xdWD3PKjPlSqow5K9LuMX5kqJ+AYtcBMpUMHKUTWfyiurEgPAZOIvobkxioDZW
         sCvMkkmCF3BRqJx9ip2iuie0VoxKWKTVcT0atamY7CAbrgJVJjMGpygsN6xb2M34qbv4
         1dJqcSX3kiOkh0fgilpPZtIay38ua2U0yekVtPTNi+cgdElYWWQ7J/fgReqMDKJs57ZN
         2dnEgyebvi9zuxlwF6JR3UT+k0eQ5KmJCB4Gbi3LT0sq5Og5QPWsAKOAQ0EJ3heh3AGW
         Rlydmbv5+x/4ZVGRrKYtH3J8yLaMn+3koQX/L1MyPM0rMNeKx68Ic1oZasi4rKP84a59
         eCHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755599693; x=1756204493;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pfxca/vdoEge9OPiAMRUJ8vrOmkvClzZNcHuu539GzA=;
        b=RmkrS99k/NUER1CeqNAzjU7mOY8gWiMK2IPyMCv5dwQ9tFoN8AdLld6R7YEIJ9VfsZ
         yUWjfmoVfDI4gKzzeuzbQ5v71qHDih5L1kH2X9H3re/Tbos6Vi8bSbA7UXGdiCeBx6V3
         xqQ2zTmApoqjAl0UIG3OuqVGunlF2OFNBWtVqST3XSwmDDQGGUwDooWToavBO3mRreqJ
         d9FR0S9+KvHkuL9FWndKHSQUSP277ZHO77CWvZDldmkKk/6646rV5bO5XOF7L/fxCNay
         2n3WOQmyYeZziOus+azVcoiXHsYx/vr0X+HesmDG9KtAMrQ/ooGsYIDKUuDWay7MHKU2
         1UhA==
X-Forwarded-Encrypted: i=1; AJvYcCXM8fAKWKNXdqV0at+pR6DFNhPKaXMSxAzP4yh98gYAf6Zn77tSDXtCQcdDj15Fnzsy+Vf2HIEsPg==@kvack.org
X-Gm-Message-State: AOJu0YziZPSvFtB6Aq6a4tIRuA46KS6pZ0ylTkCCEtY18IuNqUykYkKB
	UYeljj+SePvsC0z71vOFINGsHcdkM1s+nJJbxtMaWTo0sfj7OC4TQytl63+0YfIybzCQQPuTmHs
	iuJ8C4xqXRBvn4eBNIg==
X-Google-Smtp-Source: AGHT+IE57bom5MOYeyMuvrnfkCdbg5uwjHWFrgxzmpQzVFKeaDq24eHhOQXjlw+2VnC0x+p+7UfkiwxufCL15t8=
X-Received: from wmbee6.prod.google.com ([2002:a05:600c:6406:b0:459:dd4e:4446])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b89:b0:459:df07:6da4 with SMTP id 5b1f17b1804b1-45b43db53f3mr18052995e9.5.1755599693386;
 Tue, 19 Aug 2025 03:34:53 -0700 (PDT)
Date: Tue, 19 Aug 2025 10:34:43 +0000
In-Reply-To: <20250819-maple-tree-v2-0-229b48657bab@google.com>
Mime-Version: 1.0
References: <20250819-maple-tree-v2-0-229b48657bab@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=15522; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=MKxYbHHLM/JS9toYpXewsAShbLKnjFbJwKsiTwhjAmo=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBopFNJW8HjTuKaNTMMaf5soBbGn6cWprflZ3DM3
 g4Wxhas46uJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaKRTSQAKCRAEWL7uWMY5
 RgwaEAClw7fEaNGNDJfFzVq5Z1dWBxpmcNKiiURuKUqrV2bQ31x1M6W0d9kkEWBeEr2qOcN4Vcm
 LEeB8JmUZNrrhPbbRqtauL8i5y8psswkTTQdItN28AXfEBYU1tHsyJDRuGJh1rFls9zNq1V44k6
 FxpBlp4jrf5ds2oFAh4VIs5UlP/UHyfOu5zPhVIk/eB4iPuBsw6NdVwtprLmHcIGX5DQKhwSX8Z
 H+eIYMr44wLWDFgx3otgzrPHQ05IM7OD1ySm+H1NmKMItYqGY+B8VbkRIrA50GgcaHo8QjMZQh0
 bC/nW2WK+1Q6SeGVA0A4ztzb5ATiFvdr5OoTMRioLAeTu0aEsa//jJ0ajg/TSn9F2xbPBmfGzP0
 qfbisVWAmQfuG1fWAllgDJLHrLa9zmkdN1j76ligL9jUg4fIoUQFahpdA2TWXxu7PUASKgIYW8V
 VesBOD0uS4QTJ6sSXIxxV717IZiiRqvTabITo5VSZzXJq/NtOzOCX6H4ui5xI1s9uawnl1X60Bk
 5KNtDrjOtVNvgPk8WvGXuRU6jxjX5hjIxjdd5BcHYYdsAuB5K7VU3xMxCVpoWrq5wcfgrxdPB/N
 HJOCjG+0Mu+f1znCZ3qqAIG30Q1HJi8CoCf7lKIt2IS8VDdeXpE4+d9fD9dovPU1ax+2HQmEwsY ZJuwrp86W+2n+QQ==
X-Mailer: b4 0.14.2
Message-ID: <20250819-maple-tree-v2-2-229b48657bab@google.com>
Subject: [PATCH v2 2/5] rust: maple_tree: add MapleTree
From: Alice Ryhl <aliceryhl@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Andrew Ballance <andrewjballance@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, linux-kernel@vger.kernel.org, 
	maple-tree@lists.infradead.org, rust-for-linux@vger.kernel.org, 
	linux-mm@kvack.org, Alice Ryhl <aliceryhl@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BF8A14000A
X-Stat-Signature: hkownpje7ssh9t53hzs4644msofzoi45
X-Rspam-User: 
X-HE-Tag: 1755599694-385573
X-HE-Meta: U2FsdGVkX1/FQSxukIsGO09DaJRZl2EXp/Mc8wq0z8WqBTuTbGqiqr568ucpxvMBTY8n8j5nq34iXLxeqm8b5bb8Zfaik7sfXWhP8snSLa4woF+rlXAbiOaX9h6YczfFIQLkxHeRQUJdyClSM7SFi8nvviJP9yercJyo3YtRZVXX5fz8u/+IJSVxOC/a+3nfcH0NWgQtI3yAlGpYAcgbo6Tn2mti+izf7pKiuk/jPG6MLYEccPfB0MeNd87XNW0jtiLpr1mP/Grcy2pF7OrvTdpIcVU5+nxwI08IFj043vXoRENUp8dxbX4VFoFvyoKveAwzSXgVjPj2ZRik5NiLCc96chMsX7mQyr/D+9Vvys9rM1zin81gqwQoq6gNJK79nd46Y7M/3ZkSx29EqWAKNhPxolSXVYU9kaFN3aa3VMcz0A1y89d1LLxbkjQ7NYMEGCRBzgGYI8guF4yJKYX0Q7UJv3zJ0xkigjJVL8v41x6dmFuvDKwn8KHdVDAAWQfSBfKmMpzxczwHCA5VAl0NaxBd/Y1tJgEN8rWuYSF9u6awObU/XORr3yQ2HUAXdt0aCdypHhgYPjotrrj5ODjQXWIUw1o8qDBmOUxTN4gokdnxBxDsviPIY9f95GBAMkvyTzL67rWW5q03k+TWj0TQAQGKYwRE1JQcHTzQsVNiXML9zw+souxI5MxTWjCBxKXm0RNjFmEicYdt+bnUEGMz546YpxEZcSRxLilaFwrJbR3HHGoOZfRGi4rn7HBrLHU9twpY2bEAkAia6nKc87/5PfJLF/4D39w38Kt3oSufoyfEX9NX9gDzE0KBRpCShABk5aQIwIme1MVzn+gnZJaXqlUrbpuRx9Q0iQjcAtXfvk/5EDZi1lbvZyhCzkmpq3S3srq49Nh3qEA35YfbW/jgAsO+VEVfAYY7e4Sc6qMSxrrpSQuGJH43R98XaWFyVP4BvEl5F9z+IQICpO+lKs5
 hU3jv4sX
 fA/SQtcBQ33iouU7orqAT4WiSoIeGUDgeA9oy7qSKnBI6W0hFaf73xdyipUqj6c5D2Dc1dMZ+6p2wuGtTZy0nK2gPCvOcd/k+S5AkyQZhIavfjTC2iE+oc4/oml5uC3RxQlaq8HUyavM3sDms5CpiThBmwHBQdT0n9w7He4ZanlTwpqvkaQbMoSTuR4Dl4xb5bawD7W5Vri+IcrdzdgkdGIW1ME3z+MaTPr0GtlB//Y+8wLAxi5ZM0tq7xZpR5EkYfhiwqjo2/wp2YJ+/FhNAvP13uQudCffxHTFzBuE+dsFhhg17Q6obLFYKNP4vB4kRgQepSjvZqO6iitviDNerUmWgOXuUTABp33Yp347DsN12psY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The maple tree will be used in the Tyr driver to allocate and keep track
of GPU allocations created internally (i.e. not by userspace). It will
likely also be used in the Nova driver eventually.

This adds the simplest methods for additional and removal that do not
require any special care with respect to concurrency.

This implementation is based on the RFC by Andrew but with significant
changes to simplify the implementation.

Co-developed-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Andrew Ballance <andrewjballance@gmail.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 MAINTAINERS                |   2 +
 include/linux/maple_tree.h |   3 +
 rust/helpers/helpers.c     |   1 +
 rust/helpers/maple_tree.c  |   8 ++
 rust/kernel/lib.rs         |   1 +
 rust/kernel/maple_tree.rs  | 343 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 358 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fe168477caa45799dfe07de2f54de6d6a1ce0615..26053163fe5aed2fc4b4e39d47062c93b873ac13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16250,7 +16250,9 @@ L:	rust-for-linux@vger.kernel.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	rust/helpers/maple_tree.c
 F:	rust/helpers/mm.c
+F:	rust/kernel/maple_tree.rs
 F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 
diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index 8244679ba1758235e049acbaedee62aae5c0e226..4af6c5e1a6241e24e3e73b1cc1364b8da77b9bf0 100644
--- a/include/linux/maple_tree.h
+++ b/include/linux/maple_tree.h
@@ -481,6 +481,9 @@ struct ma_wr_state {
 #define MA_ERROR(err) \
 		((struct maple_enode *)(((unsigned long)err << 2) | 2UL))
 
+/*
+ * When changing MA_STATE, remember to also change rust/kernel/maple_tree.rs
+ */
 #define MA_STATE(name, mt, first, end)					\
 	struct ma_state name = {					\
 		.tree = mt,						\
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 7cf7fe95e41dd51717050648d6160bebebdf4b26..c5d42e0f7ce6786c1e96f8c0f27710959ca3362b 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -26,6 +26,7 @@
 #include "io.c"
 #include "jump_label.c"
 #include "kunit.c"
+#include "maple_tree.c"
 #include "mm.c"
 #include "mutex.c"
 #include "of.c"
diff --git a/rust/helpers/maple_tree.c b/rust/helpers/maple_tree.c
new file mode 100644
index 0000000000000000000000000000000000000000..1dd9ac84a13feed53c0ed5eec6805517081d0673
--- /dev/null
+++ b/rust/helpers/maple_tree.c
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/maple_tree.h>
+
+void rust_helper_mt_init_flags(struct maple_tree *mt, unsigned int flags)
+{
+	mt_init_flags(mt, flags);
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index ed53169e795c0badf548025a57f946fa18bc73e3..6b0a5689669fa691e366ab3f9d462692c12bd548 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -96,6 +96,7 @@
 #[cfg(CONFIG_KUNIT)]
 pub mod kunit;
 pub mod list;
+pub mod maple_tree;
 pub mod miscdevice;
 pub mod mm;
 #[cfg(CONFIG_NET)]
diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
new file mode 100644
index 0000000000000000000000000000000000000000..ea1bd694213b73108732aecc36da95342aeafe04
--- /dev/null
+++ b/rust/kernel/maple_tree.rs
@@ -0,0 +1,343 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Maple trees.
+//!
+//! C header: [`include/linux/maple_tree.h`](srctree/include/linux/maple_tree.h)
+//!
+//! Reference: <https://docs.kernel.org/core-api/maple_tree.html>
+
+use core::{
+    marker::PhantomData,
+    ops::{Bound, RangeBounds},
+    ptr,
+};
+
+use kernel::{
+    alloc::Flags,
+    error::code::{EEXIST, ENOMEM},
+    error::to_result,
+    prelude::*,
+    types::{ForeignOwnable, Opaque},
+};
+
+/// A maple tree optimized for storing non-overlapping ranges.
+///
+/// # Invariants
+///
+/// Each range in the maple tree owns an instance of `T`.
+#[pin_data(PinnedDrop)]
+#[repr(transparent)]
+pub struct MapleTree<T: ForeignOwnable> {
+    #[pin]
+    tree: Opaque<bindings::maple_tree>,
+    _p: PhantomData<T>,
+}
+
+/// A helper type used for navigating a [`MapleTree`].
+///
+/// # Invariants
+///
+/// For the duration of `'tree`:
+///
+/// * The `ma_state` must reference a valid `MapleTree<T>`.
+/// * The `ma_state` has read/write access to the tree.
+pub struct MaState<'tree, T: ForeignOwnable> {
+    state: bindings::ma_state,
+    _phantom: PhantomData<&'tree mut MapleTree<T>>,
+}
+
+#[inline]
+fn to_maple_range(range: impl RangeBounds<usize>) -> Option<(usize, usize)> {
+    let first = match range.start_bound() {
+        Bound::Included(start) => *start,
+        Bound::Excluded(start) => start.checked_add(1)?,
+        Bound::Unbounded => 0,
+    };
+
+    let last = match range.end_bound() {
+        Bound::Included(end) => *end,
+        Bound::Excluded(end) => end.checked_sub(1)?,
+        Bound::Unbounded => usize::MAX,
+    };
+
+    if last < first {
+        return None;
+    }
+
+    Some((first, last))
+}
+
+impl<T: ForeignOwnable> MapleTree<T> {
+    /// Create a new maple tree.
+    ///
+    /// The tree will use the regular implementation with a higher branching factor.
+    #[inline]
+    pub fn new() -> impl PinInit<Self> {
+        pin_init!(MapleTree {
+            // SAFETY: This initializes a maple tree into a pinned slot. The maple tree will be
+            // destroyed in Drop before the memory location becomes invalid.
+            tree <- Opaque::ffi_init(|slot| unsafe { bindings::mt_init_flags(slot, 0) }),
+            _p: PhantomData,
+        })
+    }
+
+    /// Insert the value at the given index.
+    ///
+    /// If the maple tree already contains a range using the given index, then this call will fail.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// let the_answer = KBox::new(42, GFP_KERNEL)?;
+    ///
+    /// // These calls will succeed.
+    /// tree.insert(100, ten, GFP_KERNEL)?;
+    /// tree.insert(101, twenty, GFP_KERNEL)?;
+    ///
+    /// // This will fail because the index is already in use.
+    /// assert_eq!(
+    ///     tree.insert(100, the_answer, GFP_KERNEL).unwrap_err().cause,
+    ///     InsertErrorKind::Occupied,
+    /// );
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn insert(&self, index: usize, value: T, gfp: Flags) -> Result<(), InsertError<T>> {
+        self.insert_range(index..=index, value, gfp)
+    }
+
+    /// Insert a value to the specified range, failing on overlap.
+    ///
+    /// This accepts the usual types of Rust ranges using the `..` and `..=` syntax for exclusive
+    /// and inclusive ranges respectively. The range must not be empty, and must not overlap with
+    /// any existing range.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    /// let the_answer = KBox::new(42, GFP_KERNEL)?;
+    /// let hundred = KBox::new(100, GFP_KERNEL)?;
+    ///
+    /// // Insert the value 10 at the indices 100 to 499.
+    /// tree.insert_range(100..500, ten, GFP_KERNEL)?;
+    ///
+    /// // Insert the value 20 at the indices 500 to 1000.
+    /// tree.insert_range(500..=1000, twenty, GFP_KERNEL)?;
+    ///
+    /// // This will fail due to overlap with the previous range on index 1000.
+    /// assert_eq!(
+    ///     tree.insert_range(1000..1200, the_answer, GFP_KERNEL).unwrap_err().cause,
+    ///     InsertErrorKind::Occupied,
+    /// );
+    ///
+    /// // When using .. to specify the range, you must be careful to ensure that the range is
+    /// // non-empty.
+    /// assert_eq!(
+    ///     tree.insert_range(72..72, hundred, GFP_KERNEL).unwrap_err().cause,
+    ///     InsertErrorKind::InvalidRequest,
+    /// );
+    /// # Ok::<_, Error>(())
+    /// ```
+    pub fn insert_range<R>(&self, range: R, value: T, gfp: Flags) -> Result<(), InsertError<T>>
+    where
+        R: RangeBounds<usize>,
+    {
+        let Some((first, last)) = to_maple_range(range) else {
+            return Err(InsertError {
+                value,
+                cause: InsertErrorKind::InvalidRequest,
+            });
+        };
+
+        let ptr = T::into_foreign(value);
+
+        // SAFETY: The tree is valid, and we are passing a pointer to an owned instance of `T`.
+        let res = to_result(unsafe {
+            bindings::mtree_insert_range(self.tree.get(), first, last, ptr, gfp.as_raw())
+        });
+
+        if let Err(err) = res {
+            // SAFETY: As `mtree_insert_range` failed, it is safe to take back ownership.
+            let value = unsafe { T::from_foreign(ptr) };
+
+            let cause = if err == ENOMEM {
+                InsertErrorKind::AllocError(kernel::alloc::AllocError)
+            } else if err == EEXIST {
+                InsertErrorKind::Occupied
+            } else {
+                InsertErrorKind::InvalidRequest
+            };
+            Err(InsertError { value, cause })
+        } else {
+            Ok(())
+        }
+    }
+
+    /// Erase the range containing the given index.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{MapleTree, InsertErrorKind};
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    ///
+    /// tree.insert_range(100..500, ten, GFP_KERNEL)?;
+    /// tree.insert(67, twenty, GFP_KERNEL)?;
+    ///
+    /// let twenty = tree.erase(67).unwrap();
+    /// assert_eq!(*twenty, 20);
+    ///
+    /// let ten = tree.erase(275).unwrap();
+    /// assert_eq!(*ten, 10);
+    ///
+    /// // The previous call erased the entire range, not just index 275.
+    /// assert!(tree.erase(127).is_none());
+    /// # Ok::<_, Error>(())
+    /// ```
+    #[inline]
+    pub fn erase(&self, index: usize) -> Option<T> {
+        // SAFETY: `self.tree` contains a valid maple tree.
+        let ret = unsafe { bindings::mtree_erase(self.tree.get(), index) };
+
+        // SAFETY: If the pointer is not null, then we took ownership of a valid instance of `T`
+        // from the tree.
+        unsafe { T::try_from_foreign(ret) }
+    }
+
+    /// Free all `T` instances in this tree.
+    ///
+    /// # Safety
+    ///
+    /// This frees Rust data referenced by the maple tree without removing it from the maple tree.
+    /// The caller must ensure that no reference that remains in the maple tree is used incorrectly
+    /// after this call.
+    unsafe fn free_all_entries(self: Pin<&mut Self>) {
+        // SAFETY: The caller provides exclusive access to the entire maple tree, so we have
+        // exclusive access to the entire maple tree despite not holding the lock.
+        let mut ma_state = unsafe { MaState::new_raw(self.into_ref().get_ref(), 0, usize::MAX) };
+
+        loop {
+            // This uses the raw accessor because we're destroying pointers without removing them
+            // from the maple tree, which is only valid because this is the destructor.
+            let ptr = ma_state.mas_find_raw(usize::MAX);
+            if ptr.is_null() {
+                break;
+            }
+            // SAFETY: By the type invariants, this pointer references a valid value of type `T`.
+            // By the safety requirements, it is okay to free it without removing it from the maple
+            // tree.
+            drop(unsafe { T::from_foreign(ptr) });
+        }
+    }
+}
+
+#[pinned_drop]
+impl<T: ForeignOwnable> PinnedDrop for MapleTree<T> {
+    #[inline]
+    fn drop(mut self: Pin<&mut Self>) {
+        // We only iterate the tree if the Rust value have a destructor.
+        if core::mem::needs_drop::<T>() {
+            // SAFETY: The tree is valid, and other than the below `mtree_destroy` call, it will
+            // not be accessed after this call.
+            unsafe { self.as_mut().free_all_entries() };
+        }
+
+        // SAFETY: The tree is valid, and will not be accessed after this call.
+        unsafe { bindings::mtree_destroy(self.tree.get()) };
+    }
+}
+
+impl<'tree, T: ForeignOwnable> MaState<'tree, T> {
+    /// Initialize a new `MaState` with the given tree.
+    ///
+    /// # Safety
+    ///
+    /// The caller must ensure that this `MaState` has read/write access to the maple tree.
+    #[inline]
+    unsafe fn new_raw(mt: &'tree MapleTree<T>, first: usize, end: usize) -> Self {
+        // INVARIANT:
+        // * Having a reference ensures that the `MapleTree<T>` is valid for `'tree`.
+        // * The caller ensures that we have read/write access.
+        Self {
+            state: bindings::ma_state {
+                tree: mt.tree.get(),
+                index: first,
+                last: end,
+                node: ptr::null_mut(),
+                status: bindings::maple_status_ma_start,
+                min: 0,
+                max: usize::MAX,
+                alloc: ptr::null_mut(),
+                mas_flags: 0,
+                store_type: bindings::store_type_wr_invalid,
+                ..Default::default()
+            },
+            _phantom: PhantomData,
+        }
+    }
+
+    #[inline]
+    fn as_raw(&mut self) -> *mut bindings::ma_state {
+        &raw mut self.state
+    }
+
+    #[inline]
+    fn mas_find_raw(&mut self, max: usize) -> *mut c_void {
+        // SAFETY: By the type invariants, the `ma_state` is active and we have read/write access
+        // to the tree.
+        unsafe { bindings::mas_find(self.as_raw(), max) }
+    }
+}
+
+/// Error type for failure to insert a new value.
+pub struct InsertError<T> {
+    /// The value that could not be inserted.
+    pub value: T,
+    /// The reason for the failure to insert.
+    pub cause: InsertErrorKind,
+}
+
+/// The reason for the failure to insert.
+#[derive(PartialEq, Eq, Copy, Clone)]
+pub enum InsertErrorKind {
+    /// There is already a value in the requested range.
+    Occupied,
+    /// Failure to allocate memory.
+    AllocError(kernel::alloc::AllocError),
+    /// The insertion request was invalid.
+    InvalidRequest,
+}
+
+impl From<InsertErrorKind> for Error {
+    #[inline]
+    fn from(kind: InsertErrorKind) -> Error {
+        match kind {
+            InsertErrorKind::Occupied => EEXIST,
+            InsertErrorKind::AllocError(kernel::alloc::AllocError) => ENOMEM,
+            InsertErrorKind::InvalidRequest => EINVAL,
+        }
+    }
+}
+
+impl<T> From<InsertError<T>> for Error {
+    #[inline]
+    fn from(insert_err: InsertError<T>) -> Error {
+        Error::from(insert_err.cause)
+    }
+}

-- 
2.51.0.rc1.167.g924127e9c0-goog


