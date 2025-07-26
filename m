Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4CB8C83F17
	for <linux-mm@archiver.kernel.org>; Sat, 26 Jul 2025 13:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CEA26B0089; Sat, 26 Jul 2025 09:23:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 858506B008A; Sat, 26 Jul 2025 09:23:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F5D6B008C; Sat, 26 Jul 2025 09:23:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5F8876B0089
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 09:23:42 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1458280A68
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:42 +0000 (UTC)
X-FDA: 83706483084.22.4B3D761
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf16.hostedemail.com (Postfix) with ESMTP id 16A3418000E
	for <linux-mm@kvack.org>; Sat, 26 Jul 2025 13:23:39 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cY5H7bRf;
	spf=pass (imf16.hostedemail.com: domain of 32taEaAkKCOUHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32taEaAkKCOUHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753536220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mOgrqjxNs+ME3TRVLi3Dz5HUWyMBAvnljc5iO01PwNw=;
	b=KDcFsohaYiqJgEqMLkPg64GJStmDST5Yj8s9/VZGIvnW2o7hmT+5Ha5+6E+q1qf0QhRi7Y
	iTY7gmgeLxgt5u9nlLLOjZ2MYOt+6Jk+RHT9NTgqpZ8FvWWMP8pmfl809mXHLaAxjc/3OP
	fAzRaa/J6v2vvbPhbunTfgL60KIRhmk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753536220; a=rsa-sha256;
	cv=none;
	b=Vit5VG5K+hPwvjjMZGLmQcGjsbhlVVDtyB1IJjAmblAMHXngXGDqG93+6VtyHS8vvT/FoT
	dQpXtxxDHq2lkCEg0P2mbwxgGq7AfOGZFwurjPbtOeX8Zf3eP5hrCmjUYW+qrsgExaQUNn
	zsh2AcHwsnlnyNmPHom7iV7ufMCAXZk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cY5H7bRf;
	spf=pass (imf16.hostedemail.com: domain of 32taEaAkKCOUHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=32taEaAkKCOUHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4560b81ff9eso17582165e9.1
        for <linux-mm@kvack.org>; Sat, 26 Jul 2025 06:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753536219; x=1754141019; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mOgrqjxNs+ME3TRVLi3Dz5HUWyMBAvnljc5iO01PwNw=;
        b=cY5H7bRfVey3sq/IkOYuN7If+qw/o0HpF3EvIYAFnKLRDRe6AnwdB/YtEn4/qJnq/I
         vmb2hsCItfYMBtwhmTqx1RAJU/zP6yGleEAvs7ZFQJP++GKF/DJALOxMbgvG8Iv0biqp
         xTHk3nZ/PEKzueJpP+w3F4F5jrtPH9xrDVY0lD2MDLjEfoaDC50VE9+kKLvjqb/NOXDi
         8r/QkIxlyQldkS1ORMDaFPzNjlfkk1dhyPytruvUB/uBcVBOoRjTOSD64+ek9KKwVuW/
         BTfafF2n4BgggQ1QSjINRzY4LqgJxgigRS65ZhL2Yc1ZSOnqEoTrT5we9KDcKLuuoDjT
         Plyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753536219; x=1754141019;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mOgrqjxNs+ME3TRVLi3Dz5HUWyMBAvnljc5iO01PwNw=;
        b=k6WbqqzXrQxhb128vFoO98yyXOGKI/ceCXPaVrRwUh30Vh3+yYFLGZxKrt56R5o6iJ
         0lv93ulA76MPIV9X58/vm/LOngu7vtWa/gO4lEe1XcIhgjn2jA3M4VkPTiIxs6eXbFy/
         uFepvudCcgODRZDSyT890S//pkx+AHR74XuZ0uSqUaa95LViSfdW3bOr2pAL7QrmB50U
         afTQifKAgPC1evF6wQigbEDiWVop/n3phwMfP2Pb87PM9m+fwynfTrgUPIpw6tmhdOGe
         PhQ6kfcsLRk2XgOaBFeYctWyr3E9PF32MyW78O5me1PQgkC3jHPy+iOucvMIZdy3qUuG
         i1Hw==
X-Forwarded-Encrypted: i=1; AJvYcCWT/mvvx5N1LDD72UaT+eZt5qR7mgcRHm0W3c4wAKltT3aju1AX5unu0AUQEvHYZef1AM/BHVQi5Q==@kvack.org
X-Gm-Message-State: AOJu0YxEAu/62qssWgFAuyNe5IiQEtM5yhj6K3alL2z5CkaSgeSR4/77
	oFO/81rcVdIz8XZcZ92kwbc5bQRZg6Mgo38IzUomvwd+q6LDRyM1r38P/F/NX3e50istE5qZfVB
	llM32rfIFtEF/wD7ssw==
X-Google-Smtp-Source: AGHT+IFW+sosLpBC3hAiy/WbKUPwUhqAUUKGCza0DLkkmUdeskkFQ5j/yn0WWMqf/jLDp+Yh/wNPw6HRQCEhSGo=
X-Received: from wmbes24.prod.google.com ([2002:a05:600c:8118:b0:456:fa0:e0ba])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6286:b0:43d:42b:e186 with SMTP id 5b1f17b1804b1-45876306fd4mr48948825e9.8.1753536218717;
 Sat, 26 Jul 2025 06:23:38 -0700 (PDT)
Date: Sat, 26 Jul 2025 13:23:22 +0000
In-Reply-To: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
Mime-Version: 1.0
References: <20250726-maple-tree-v1-0-27a3da7cb8e5@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=12995; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=/s6gfSpqDdCSnaheBqpAoG2Dm6F494kNwuGs999ee7s=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBohNbXJfFTN7BatwxcEg0q0vZgUlLfKhZS3re5w
 Zc/eUhAeP2JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaITW1wAKCRAEWL7uWMY5
 RlVNEACPzUnzhOS4na+O8N6i5c+BFIkyyxJuzR2ikLHXluax6sslQTsBpePSiTe2cjrm6LIjhMa
 IBhIuaJKDH9mtzjopgVrLUlwySZRed8M/8vUak2xUk/wLHWz6pORFNT/XbJx7QdQlINwSSpgcUN
 pg+yiYb1uRVc5o7NarNfz6VlLsGbx8G/D9YwpeWrep9FchHbUdyIJDHqT4BL9tI5g61hotn8aS/
 b7sgqPvFY5oJUPzEqQV3gYmBIDNyZB7Vucy/3xJgZsWZSGeLdPr/jY5ltfDMZFS0C7PhPJarJsE
 MP606QlWXLE4TgvXXvOHYSGum3fsFhL4dKixVe/gOmUrL9S5YjJEok2CzGYutbNQGELaE02DwKU
 BDB9aVH+m8Vx5tvjDaXo6dgvinaCzJoMZaExg5B+katfcfXIzLsgrDvBvTYEkoY9F3AsCY5ohv0
 TqlFbYjU1GWxHMDTkoLyyeHLIYZ3oWvhfSmwgXhu3wOLaII7ZpMU7Eni8TNeIPCsxpsptMwaBYM
 9ATsyKeifVlWeO+75VOFuIHVpSiuHXZb8tOmsK57zcWdw8ukoCI3SuHJ2y3YYaFZd8dD5Cvt7J+
 HY3jPwm2YSOlIaAvOfUAKnUs7PP9GDbaIhxlY5lj7+vGs0Viqy4UIZRjLVCd/oxFrTsftS9eHi9 0+ocYIZa205uVfQ==
X-Mailer: b4 0.14.2
Message-ID: <20250726-maple-tree-v1-1-27a3da7cb8e5@google.com>
Subject: [PATCH 1/3] rust: maple_tree: add MapleTree
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
X-Rspamd-Queue-Id: 16A3418000E
X-Stat-Signature: oz373k141g9b3qbzy7h3bjo9yqid6kza
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753536219-14654
X-HE-Meta: U2FsdGVkX1/DF6dimaPcyZZXFUnDikyDLUz4hMEhS2+ORWwN0lOJTpjCl56jMnSzJjPt+SUqKrIH896hrtahTjbdY741wjT/0UqZRVsFAaBXEt6kYFwVOZQCyn+c+TcDyGXJwGoY4crEwuAWLyIiS5nFpFxxiL+fxFx0PYVAfJ2wcq3k//0YQ3Q/pYX8lQ07bOjFiH9bdnTQCN20sEMb/H/MRYCrSi+aYSqdwHOaCTq9w3plsw5KaTmODpCSQukWe2T+i8vujd79iOJ1AYCzLK6ZYZHFNpALNeXwUua3avPxu5f4V1WSPxQ0IEF8SzZTizFuHJPT9CePIrvS0W9JG/KsBPz4VnzIxZDeYuKP5sDv0rgBH/Y//ij6C3dDyj8mWZtr5O3VJL2YVPFAPeBVeMixN82851+vOSSIr6ayWTKhMbtCupD1xgFu8vctQDPdEgKHkhIKp48LlgrUbbCaClamAJuHC29DbStPBVBfX+H98vI5dQc7+I9K4WyKoSBMyIltjmLcyczGKvw99d/CynYa8JAkS960mQ2JgmvdUYf59ZGnvCZKpf/jDYnuPQgn3owaAvwvP9dBtvzuJEFFXloPhlRQv6rVP7QX6HRCH2LmcpAM5K1uzOFBgCJo74P3Z1jr0YLad1kPSFw1R5BLhiNv9ypn7K8zZloyB8mt2jJ/BLz7SmJNU7iuW6NGhhhJO4A1KBfo//yn2v/jS5YDk5qzewCytvq5+OdfObUuL8m0DZxw7kEVxlm6SDR/tUlbGOcU9VHvBusk2xvvzCls045b7QYh7SefOUAEvRfVAK1YTOOvYLsVVYTlRGmYVNskENlfOmctBMC5X0CfCwan+kZ63BRWqqY6huxwNEa2ng3kSQDSLJ36RkP5yYRzu5k8Jv+Yg/L3Q2fBvzYHY5T3SLJBaaQ44wNELM8XMqgqFfmmTIhnCnVwpi3EWBkHJ6MISfdSAyTk0GXEnqqZcIl
 9otXNqYS
 HZFa7JfQHV3uBFchJ5ymx7sBfqvMBSGECyBy2ovo2nGM1/7cIjnI9T9VAXkpb03TzT8Bfmrg3onD1rI2ubXaMrl7RzpaRf4nP5KC/R9ReKAZS5wHfazwpHP4R4C7bXvloUZGIul8Q5qagKM41aHMtCHKOxBExjVnAkXulZ/GbOi7tydjQtncViv/EoD0uCuFnkNQVFJQCg7U6p255NaJQO1f2bDjCNpdO9iilQ1LiD43/m8OMDtFDFE9eHzjeu2nm3dBbcsWqulwh5UII0ODImU+w5ZWLEDurD9qj1Y342aSSBp3SOVDjbXToFQb7dzVDr44QOWmAtW9VHBVY2F9cznQcNY3hWXA71244H4r56947awAZ88ObYQpGY8rXVA/BM9HLaRX81rTFDY6FEgllfsO33xCX7re5N8+s8byArTSJEUjgjqZRCvq3iEP64mDRT+CtZOTBZvoANciQ4c7S0LE+ds75YBZ25AIKCKwqIidow0kHnWWcsv/zAXViXxhr+qS8L7jHCbtN31SVm3LmKiFx48nIBEAnYEO0KfgpWpEbMnoHCYP+bhzwpXE9WwkIPxydaixD2Hze3PiaFT6OkaInGJ9q2J+qRcKswzPt94gGg4skcHvhWxx6vTFrny9cVZOkWbEvpmP/LvIlAdCi/HuOeNflQRnqcmZthYV3nNH1bBnLKuXe/H2FHpqganmpyGaJqSLgMdv8XDzWPJ4toWqetm3azGRvKRCq5h1qBi41MivhXK5LxHgPKwhVv8VUNDU4SXKiUlNRS4zY7iieM/CxWbYrCh27xWUs9hHxs3lOVU0exdv+FyXRdFEZbAkRGPxK
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
 MAINTAINERS               |   2 +
 rust/helpers/helpers.c    |   1 +
 rust/helpers/maple_tree.c |  14 +++
 rust/kernel/lib.rs        |   1 +
 rust/kernel/maple_tree.rs | 286 ++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 304 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index dd810da5261b5d664ef9750f66ec022412e8014b..b7e7308ce07c050239c14c4f3a0fd89bdd8e8796 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -15956,7 +15956,9 @@ L:	rust-for-linux@vger.kernel.org
 S:	Maintained
 W:	http://www.linux-mm.org
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
+F:	rust/helpers/maple_tree.c
 F:	rust/helpers/mm.c
+F:	rust/kernel/maple_tree.rs
 F:	rust/kernel/mm.rs
 F:	rust/kernel/mm/
 
diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 0683fffdbde25b89d285e3b0d8e6d8f7f5fd7474..ed7888a2661ad91f0fb78023311b3a266d30615c 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -26,6 +26,7 @@
 #include "io.c"
 #include "jump_label.c"
 #include "kunit.c"
+#include "maple_tree.c"
 #include "mm.c"
 #include "mutex.c"
 #include "page.c"
diff --git a/rust/helpers/maple_tree.c b/rust/helpers/maple_tree.c
new file mode 100644
index 0000000000000000000000000000000000000000..119665846e8e8b018f8dc791a22fe20ace8e9c2c
--- /dev/null
+++ b/rust/helpers/maple_tree.c
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/maple_tree.h>
+
+void rust_helper_mt_init_flags(struct maple_tree *mt, unsigned int flags)
+{
+	mt_init_flags(mt, flags);
+}
+
+struct ma_state rust_helper_MA_STATE(struct maple_tree *mt, unsigned long start, unsigned long end)
+{
+	MA_STATE(mas, mt, start, end);
+	return mas;
+}
diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 11a6461e98daab597e1eb2b513c5123686a1bb73..6cc152090a2f1986781800897ad48947c2d02e40 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -88,6 +88,7 @@
 #[cfg(CONFIG_KUNIT)]
 pub mod kunit;
 pub mod list;
+pub mod maple_tree;
 pub mod miscdevice;
 pub mod mm;
 #[cfg(CONFIG_NET)]
diff --git a/rust/kernel/maple_tree.rs b/rust/kernel/maple_tree.rs
new file mode 100644
index 0000000000000000000000000000000000000000..0f26c173eedc7c79bb8e2b56fe85e8a266b3ae0c
--- /dev/null
+++ b/rust/kernel/maple_tree.rs
@@ -0,0 +1,286 @@
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
+                InsertErrorKind::Nomem
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
+        // SAFETY: The pointer references a valid maple tree.
+        let ma_state = unsafe { Opaque::new(bindings::MA_STATE(self.tree.get(), 0, usize::MAX)) };
+
+        loop {
+            // SAFETY: The maple tree is valid. This call to `free_all_entries` has exclusive
+            // access to the maple tree, so no further synchronization is required.
+            let ptr = unsafe { bindings::mas_find(ma_state.get(), usize::MAX) };
+            if ptr.is_null() {
+                break;
+            }
+            // SAFETY: By the type invariants, this pointer references a valid value of type `T`.
+            // By the safety requirements, it is okay to free it without removing it from the maple
+            // tree.
+            unsafe { drop(T::from_foreign(ptr)) };
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
+    Nomem,
+    /// The insertion request was invalid.
+    InvalidRequest,
+}
+
+impl From<InsertErrorKind> for Error {
+    #[inline]
+    fn from(kind: InsertErrorKind) -> Error {
+        match kind {
+            InsertErrorKind::Occupied => EEXIST,
+            InsertErrorKind::Nomem => ENOMEM,
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
2.50.1.470.g6ba607880d-goog


