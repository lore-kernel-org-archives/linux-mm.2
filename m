Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C82CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 08:35:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772968E0013; Tue,  2 Sep 2025 04:35:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722F98E0005; Tue,  2 Sep 2025 04:35:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EA4B8E0013; Tue,  2 Sep 2025 04:35:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9728E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 04:35:28 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0232B1DF395
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:27 +0000 (UTC)
X-FDA: 83843651136.03.15A616E
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id F1A29160004
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:35:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yyGMU4o7;
	spf=pass (imf08.hostedemail.com: domain of 3TKy2aAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TKy2aAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756802126; a=rsa-sha256;
	cv=none;
	b=1lTiEfUqruhIv/011LpEAvM/yuG1mIVIOZn+BoGcvu501DiiIymlNPi4uueNsXT2YK/XVi
	TQjVkXQZdrwhHoknUODVNmr3OjN4dFGLLjuyt7J6hvWccEhDqfHlMj1xaLYQy/wlwXAqB3
	sVmai9epG0nhqOswkULzvCMYCbSjL+c=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yyGMU4o7;
	spf=pass (imf08.hostedemail.com: domain of 3TKy2aAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3TKy2aAkKCMsr2ztv8Fy2x55x2v.t532z4BE-331Crt1.58x@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756802126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6IknaUGSNpWDYBqLgrpS5f057vYmeQH2aMiOoUU0cY=;
	b=YBO5mVClZ1yAGjIZQfxlpvBlAyQXqkzlfCXdFaQOnGlL+I5g2PiflHQuqtI5Sokqld4uri
	Mp6CziYMnAKl+WFp+N/xnRyA/fAuB/dK4eLeMHD+9/dR7+LDmWK1y6iRyZNxRhILxOm6Sj
	P6sPiODpPjdh6JG1p4JbS9ZDMyFGzl8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45b96c2f4ccso3254625e9.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 01:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756802124; x=1757406924; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=p6IknaUGSNpWDYBqLgrpS5f057vYmeQH2aMiOoUU0cY=;
        b=yyGMU4o7VoxqnHfGkJu+YoRn6OyAaWvJMLSoKTq+1wsowvLgaf6I/8lfy/1Lc0ydfe
         sIR2QE0CgwOeZZAUnmQ76ETidFZfCQ+t/flTg4RvspJ1pwADt77V+vlOJmgk69+zXJqC
         J7VAOsBUBmxq65Ht2lEXHUnLS4o1d9E9B999VODsJkj8Hdn6DZQhyG7ppvn0zeGMpah7
         lzzwnajqI+E5vPKP+WyEuN9WLdWqd2bi/EXoa81FQpvBpd4SJBxHNboIUkSOH0NTZcca
         m8Tv8XI8nmE/1w27BzPe28Wo3vdD27GxTROj0g9Rjq8KR6SxyPFSN8RItqAYiS2NZEA7
         GVbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756802124; x=1757406924;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p6IknaUGSNpWDYBqLgrpS5f057vYmeQH2aMiOoUU0cY=;
        b=bnM0geTuVzauZ74kgSC72V2IawUSvH/+Y252OQ+BIN6pTleVl3hpYksRaOUnqDvyf7
         W+Wv2qzKTe1AN6BXRUVw+VwGTsC4H/7L3FdSRuyaDMaZZrE4Kr5GyzsgIoNWnLWicwer
         jNuZoMCy1Lgz1i4mEXsnJTHV9oc5DuxMpzVmJiNGvRfZstl+6ZnvtoT8BPyZVkS1LsQ9
         2w/fGojosNE3/b+ZsdsFSD2tiakZGqiINF4+SEvU3tiHYk4jbeDhXRhg3AarnsTKZNFM
         E+mpYrS96luUbkf7kA1CEhSKOD0dnNgxvOJw3rrJpNhkU+qVWjiybEygmsxHEGSGXI7q
         yamA==
X-Forwarded-Encrypted: i=1; AJvYcCX1c0kQdNipTqoI3p35cimnffhXkchCajVkvGs0Tl/fttjx4CSLytavz8/a2nfFmbso8yjhBR5lYw==@kvack.org
X-Gm-Message-State: AOJu0YxHKN2HlyHka17lBZi8Sx2hoMZtlNJMBVv4K+NjYd4wWzB4SAJJ
	yofiPcFbtPFJJNRkdIFnUOlt7YUUSIxGJOVpqa/d5iQNNjEhHN445mm/IobOSGMNianR+A+6Qs2
	KQ9S9HIQDG78bQOa7FQ==
X-Google-Smtp-Source: AGHT+IGYbHyJ9GAqNLshEvU+n8ntrU34uDmin8xaf3GjY/SbM9BkTgPMVRDnOWGVZmjOnqa+VFEFoo0JEzit4dc=
X-Received: from wmth8.prod.google.com ([2002:a05:600c:8b68:b0:45a:2855:e836])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6383:b0:45b:880a:8fd3 with SMTP id 5b1f17b1804b1-45b880a91a7mr74193275e9.7.1756802124681;
 Tue, 02 Sep 2025 01:35:24 -0700 (PDT)
Date: Tue, 02 Sep 2025 08:35:11 +0000
In-Reply-To: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
Mime-Version: 1.0
References: <20250902-maple-tree-v3-0-fb5c8958fb1e@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=16139; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=wjtWPgW/UysnPZ4giaD8bZKnCDWu3P89mJEt/I/Q07Y=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBotqxKN0FxiILltf6yXjPY90o9PJQMY3QVkcD70
 Dgf5mpb0eiJAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaLasSgAKCRAEWL7uWMY5
 Rs61D/wJjsHil7kWhGoA2OFOzsK0cP6byAnxg1h3XJnDsMTqNsayDvw4177EVpydO7JqqLkC4Jv
 mDsAXXc8XPVFqdXpFINGu0cAFbcxC7RfTe+BsAva680Qcv91Mv6Nd4gsVPaYf+UKMTgm2Hw8G1/
 kM292bfeB0axxxkJOP8b1TsEG4GRvu6hcMWI5socituE/COTp/NzVpDUso7sdzdESTDzHh1DskK
 TrzfM/IdOHFZQuPxnxeZehyO9n8zkygLTnTjtA8mOXh53jZujwm43YrZvbvhgcQuAfJhJURH+//
 TpjzCM3Pc8EUG474jgT5z2iXbuTdJiAYQbmmcK9JgewxKE8gCiwoOuIgFIOYsGMgZjyZQq4dbHB
 xE0762W1atTPYvQBnWag8QKdWansaqhWeRs31SlA+hnmOpJ3qE+ZDF75BqZ4tLy1Kz34sqFX66q
 so8t6RXwe1dFKpcgQPDsa+jtY1UAqo4a33GCgzf4VPYUl+o4M+tO+OeJkM+Dla+zvK2uuXOh687
 o8e+u6esZ0uYzKPdHtjb67pB/2Y7G8b4XfweYHETp3lnVQTmtPsZ84R4k7wyoACqTAc/WJFcCYR
 3xfOrSQYOVB1aGUs3w6nztiPrgRCXx+yhMFSej14plJHNEfz3BbVfWamWAyAu2XDdW0KEeTxeN+ 9QgArwKMcOd6YhA==
X-Mailer: b4 0.14.2
Message-ID: <20250902-maple-tree-v3-1-fb5c8958fb1e@google.com>
Subject: [PATCH v3 1/3] rust: maple_tree: add MapleTree
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
X-Rspamd-Queue-Id: F1A29160004
X-Stat-Signature: 5hk3ox6pgnu1qrwdaar1tz6fndukpzuj
X-Rspam-User: 
X-HE-Tag: 1756802125-144634
X-HE-Meta: U2FsdGVkX1+66y7fDyIxZJjoajp2zolyi5Ea2b2aCOMuHNjiL+eAv9X+WzV0+W49hg1fwwr97wB+5qImJMdiVr8e8uoLf9V87r9jOLmBrrhJPu/7/BP5e1yi2tC72eJL1lz644wknggD+fCqFgzN5XNJiTvFCxNJAJsh/syRA2kEp9yHRHQL224knJHzmk0cnhCOwCkF/4gb1cO2t9KEoGM3Lte85OeewOjJz9s3l+ppdox1O500Oct9Oc+Kth069GckjA6x+PFYh2rZkc1ay0VoxMCH5Q/HBAj0/6I95NAtZxy+BsR0dOPVC+1DGvFgQrFq8oqhzJ4Iy2Fnp5QCF1CdTNe9jqhnV7MeXCJoYm3OEkRvn9FHGZBAbM9VwuAa0WGkNkaejMyPD2NSUgj5er3i9MQZoHsMp3f+6Vg8ubTXimzt9yO8kU9Xf6UUQ+mzoBxna1uAaU9ZQHpBPMzhCtF8H7TytKj7DjlcLAxx2440yVV0TX7enzfaeC+4KMp8Mai0xgMcLudQ53GhPIF+qrjleOj6uuMngXWLXcphbfBklCEa9AUKqo/9Fe+uCbM5FVBzAws5U4COfIYj16RPluCwGw57paIO38DgmQ4F9YMnfclbmnRbmg1/qrZmm5aRCn1ejtDjnpaecnPH+ybkRvS3heCdpLJWqrw1UcyGo2P30CEt3BaqX4kw+OX5PrDmcpzlvl0oJG37Qnz2woYMwOygKfENYzQC1qYSoPvhW2sEOUnm/JCauHUr4kM4RnaJyL37dMdJ2qqlOMAAo3ZgVbSKqt0CDkSafokwbrMxcFZGj6ggF6yLxUFw6cc4HRQEFVQJoIudpJZDdWgW/P7TjT/G1D5PdpS5NojZIr1bNuuCVwLSIPWr0HzXRaTrlNziW2RERIB80DmMZMY8Dz+FXc4r8iuZPYaHZGNSasU7Czk4Mf8j5BqsuDljtAu7sZeZDwilhJWG0Tcdkq8ZXub
 hXKw+DQl
 zVlwpJ70p8DpbFN6zOXEEP16vD5y9mGhLSaKn3hKdADHGrlP4SqCZ0uqVPgYPhyKeUrYH9QnQRUw/h3oIGz+ex/DjHh3ymaKxm30B//EbpRg297DKj9yexwY3v3SOIUPFe/4osQDRPuGWfOMlfaApHmb+evMh9AjcX0s3Ry9w2rTVErbipUxSQK1Lmyz7zqdeYfoL9HCeTcmiFgHdC/mZCni3fUVJ5xaruBCvAMUlUQerRzsM9Fs/9eYRsKkzhppDwL624y4FDSNUE1XOXg8fRAcwtWSLNkf3Vktfex5WYoYRsX9dtFUuTU6jf3/2yJsPSl9a1g93b2RzPNb6n03qM3ghkd6yoL2BRYi+4JH8eAgttxSJ1/x8YN+JXPg+CRn6O9elFoKXa5jtDgNbH4G07I6tuvV7uILU9XaHL47uHEqAIxul+V3+gNH0QV4bqLtImYw3xruDnflabBzLTeYQtnyVWrmyX0Zzuzy7DbFaROHO2T676S16XWGU5oRz1pIZ8ct9VFHTVh6vqmsbjB7eARYP2Vx++k90oUiYf0mkl1eBAoURd0/O5WVyFl/rJ/fWj8INlkB6Uiv+KqzI4IJIbpzi5juFxxdSa1bUE/b1vAddWg/0C1LrmbtoqbAAcllMPUP63BxBWesjhaP7hN+3xUuRMRqj1IwF91LJl1AqBNcSGt17x1NAIp/DU81dEBVSWpiGqYYvAy2IobWeW6x5SalI29n0mVk0ruIectC9h/YfkQauaqI6B10/rl11eforiSNEolk9FmnfTcuOuUu2fFTwZGvSHjxDTI/9zlW3WsXVcylBwJZ0OywE8Z5fGz44mbaTgi2ZUkuy4eZ1h2MRaf8w341qo5GPJzLR75WLrBEhiCou8mA48FDC+kesOY5ZDaVrPiyhZzKFMd0=
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
 MAINTAINERS                |   4 +
 include/linux/maple_tree.h |   3 +
 rust/helpers/helpers.c     |   1 +
 rust/helpers/maple_tree.c  |   8 ++
 rust/kernel/lib.rs         |   1 +
 rust/kernel/maple_tree.rs  | 350 +++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 367 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index fed6cd812d796a08cebc0c1fd540c8901d1bf448..c076f034562dd3d6b3679e8c2cd390adb312d483 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14672,6 +14672,8 @@ F:	net/mctp/
 
 MAPLE TREE
 M:	Liam R. Howlett <Liam.Howlett@oracle.com>
+R:	Alice Ryhl <aliceryhl@google.com>
+R:	Andrew Ballance <andrewjballance@gmail.com>
 L:	maple-tree@lists.infradead.org
 L:	linux-mm@kvack.org
 S:	Supported
@@ -14680,6 +14682,8 @@ F:	include/linux/maple_tree.h
 F:	include/trace/events/maple_tree.h
 F:	lib/maple_tree.c
 F:	lib/test_maple_tree.c
+F:	rust/helpers/maple_tree.c
+F:	rust/kernel/maple_tree.rs
 F:	tools/testing/radix-tree/maple.c
 F:	tools/testing/shared/linux/maple_tree.h
 
diff --git a/include/linux/maple_tree.h b/include/linux/maple_tree.h
index bafe143b1f783202e27b32567fffee4149e8e266..879cd5f24be49548d5fd9d6b19bf069e33c334a1 100644
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
index 0000000000000000000000000000000000000000..92930b408e9683b6615080a53800f1a393c5f31e
--- /dev/null
+++ b/rust/kernel/maple_tree.rs
@@ -0,0 +1,350 @@
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
+    /// The tree will use the regular implementation with a higher branching factor, rather than
+    /// the allocation tree.
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
+    /// # Errors
+    ///
+    /// If the maple tree already contains a range using the given index, then this call will
+    /// return an [`InsertError`] with the [`Occupied`] kind. It may also fail if memory
+    /// allocation fails.
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{InsertErrorKind, MapleTree};
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
+    /// # Errors
+    ///
+    /// If the maple tree already contains an overlapping range, then this call will return an
+    /// [`InsertError`] with the [`Occupied`] kind. It may also fail if memory allocation fails
+    /// or if the requested range is invalid (e.g. empty).
+    ///
+    /// # Examples
+    ///
+    /// ```
+    /// use kernel::maple_tree::{InsertErrorKind, MapleTree};
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
+    /// use kernel::maple_tree::MapleTree;
+    ///
+    /// let tree = KBox::pin_init(MapleTree::<KBox<i32>>::new(), GFP_KERNEL)?;
+    ///
+    /// let ten = KBox::new(10, GFP_KERNEL)?;
+    /// let twenty = KBox::new(20, GFP_KERNEL)?;
+    ///
+    /// tree.insert_range(100..500, ten, GFP_KERNEL)?;
+    /// tree.insert(67, twenty, GFP_KERNEL)?;
+    ///
+    /// assert_eq!(tree.erase(67).map(|v| *v), Some(20));
+    /// assert_eq!(tree.erase(275).map(|v| *v), Some(10));
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
+    /// This frees Rust data referenced by the maple tree without removing it from the maple tree,
+    /// leaving it in an invalid state. The caller must ensure that this invalid state cannot be
+    /// observed by the end-user.
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
+        // We only iterate the tree if the Rust value has a destructor.
+        if core::mem::needs_drop::<T>() {
+            // SAFETY: Other than the below `mtree_destroy` call, the tree will not be accessed
+            // after this call.
+            unsafe { self.as_mut().free_all_entries() };
+        }
+
+        // SAFETY: The tree is valid, and will not be accessed after this call.
+        unsafe { bindings::mtree_destroy(self.tree.get()) };
+    }
+}
+
+/// A helper type used for navigating a [`MapleTree`].
+///
+/// # Invariants
+///
+/// For the duration of `'tree`:
+///
+/// * The `ma_state` references a valid `MapleTree<T>`.
+/// * The `ma_state` has read/write access to the tree.
+pub struct MaState<'tree, T: ForeignOwnable> {
+    state: bindings::ma_state,
+    _phantom: PhantomData<&'tree mut MapleTree<T>>,
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
+#[derive(PartialEq, Eq, Copy, Clone, Debug)]
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
2.51.0.338.gd7d06c2dae-goog


