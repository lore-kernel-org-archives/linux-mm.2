Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C03606A325
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 02:17:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lsEJJf8g
Received: by kanga.kvack.org (Postfix)
	id 988586B06C7; Thu, 19 Nov 2026 21:17:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9392D6B06CC; Thu, 19 Nov 2026 21:17:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827E06B06FC; Thu, 19 Nov 2026 21:17:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 55CFE6B06C7
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 21:17:38 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6941160C34
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:17:37 +0000 (UTC)
X-FDA: 85453886154.12.EE7BC90
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0D1E6C0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 02:17:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lsEJJf8g;
	spf=pass (imf22.hostedemail.com: domain of yusq77@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=yusq77@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795141056;
	b=lR3ZEUkQutKKxo5/5H6Avj75LwfM8sT5beYVJ3ZTmgXyQAa7Ot1Okjmmq6OLPyWd1vFKQe
	H76Yxnf59RMO8QQWAzmZrKRewMXGnjrZN3ZF4wBn17sGogSDqCmb1sEW4nYwqq58jaqEIT
	sJz0PYFDmGB8efqLkam5j3ExvMI1bIM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795141056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Qrne1U4Gq2URgk+EKe+uNj5xFft/8oosPyNbOoW67yY=;
	b=wn5UbwkQ8pgind60XiUDzSNJtswAOsvbSTGXdl6DmmN+xziche1A1+Ui1twm1ZEj90sfy9
	fMiAqAs+kdVg0pA7JV3IcPLEPQqYghgMOM0w+8cY2pTmeaXwws4lF4flzHK/6qsqnzD+eL
	5qBh7/9CLwgvRY2ItwygDj0UprG9JZY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=lsEJJf8g;
	spf=pass (imf22.hostedemail.com: domain of yusq77@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=yusq77@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3b41e5a1719so117867a91.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 18:17:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795141055; x=1795745855; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Qrne1U4Gq2URgk+EKe+uNj5xFft/8oosPyNbOoW67yY=;
        b=lsEJJf8gvHkoYMJIIjvKcr+PmTB9ul3eOxPpD085n6u+Edz9QFQlUmkyawmTA5GxNC
         8W9W1caipqfrt86RQz2Yk4+nOVkqY7PT9GQm81xOuh+8rPgvXfO1gwyzxFm2wvozjp6y
         TlH2hazyZDmLY3aTnhXghCiTkM/1/jmr9jHjnI30VdVDJF76/gaxK/oJ3woK/6elW56K
         IcXUuU7wH8W/UQRSMKRBhOTnCnv4lIaUkSj75qiBocaxvRt3PH1j5npXkBMHKlEjr0aM
         Lih5sjFP6ym+GfDbXnEyInK1fFKinpc2bah3LpCZP4Qyr79IO+bJfFnDcAI6ZSgWtk57
         Gb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795141055; x=1795745855;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qrne1U4Gq2URgk+EKe+uNj5xFft/8oosPyNbOoW67yY=;
        b=rnl+ambCYnQomwZ+y0fE+/9PO2Ncxyltp7/1gzbKes4pvefDmvJ2SuPHBsEZKrjRC1
         4jQBqW9b3h0zgmUa/uo13AZc5DWxsjhiDnkvjRl2aWn2XhXSUTHQTXxKTlQ4gGn9OmTU
         BMEV0Sdc8z0pS820JIFyii3YpDpnwwpfB76bAx1S3yMKcSeyuDxdlZu2n4nNT6t7wxOI
         r7A+izpYy3YaxLZTw0ElG22o90zRmCp1aIu7LfoZ+Zjo4VejBnvrFlv/D5Xc0N7vh1AD
         g+FsRE/UisqUpC+/w+DzFJbys55ccRyYM8GWVgEhRMDaiA/b8ER7aHAse8VRCaKKRNl2
         Qbng==
X-Forwarded-Encrypted: i=1; AL+hErFfn3U0/L15hHnGfKx0wQehWPQW+x3Vxkx35ZoLIDepSQ/mZheXhV2MQ5gpFUR6fThfAyqbvCMAHw==@kvack.org
X-Gm-Message-State: APuU4Z+hddXcbIqh3K+CCWdCtAQS99luCa4d4Cbs0AmFz0YKhfruOAfy
	BvYjTTatxnQEWpL/iKAZv4LxynoGIDxs7er71EDEJ2o/2GxiSiy8sm4v
X-Gm-Gg: AZFdTZcED/b/4+tqhgnf5Gz4uzl9RnTvdNQgGer/9rPV6UCxK+u3NbGi1/w36u/4Kig
	QWIuGQUcokimilsQ2HfwCb/SqPP8x6U5uzr0Q6zZwbq2GboBkor4y/GWSXQfTVNFEpUIGV8yMYU
	+p0WFJJZNOPqjLEC+mx5qcEyuwYjPSZNVgC7M06K8qYT17LWsN/Pbp6HufhvuZRGScFgTWUZ1By
	TR2OLK1GcBk/J4zA7ThI80WvvG6+uP9hN5IXFIxMWKphwYtPUY9RJXQBQZPrzXhQEz91Gz4i+zm
	hdPBOgYjDD5hb9+87MHErJLbGM+vgzHI3Fu00WEmhk9WImOWtCiMM46jJWexmUPpv16Yrtjem/X
	Am6YWFvPYlkwwJOx3hZ50CrtzdGOi9kWaG00MtvNluql7u1S/2wt6cEFkAzVeajUHuAt6evUUg3
	zJgU1fTMdrIrkBw1jFyS8IcKAOia0BLd54kIB5tdXvasSs/WA5gkLhkLkNrvqPWpCdfQKCNQDeY
	PeTZ5/Z2y5T8m12CdFYJb9bnIuU3Agh55Tj/W/SjJ/amf3YMtZQEgE+TWpJveMuVxRYjJdkiQZ6
	C2aFuvCjt1YjjaChydNZkopYhD8jexQWs3b3JXDIZWHBTAXm4sHiEFKMvEA=
X-Received: by 2002:a17:90b:2c84:b0:3a5:c08:4c41 with SMTP id 98e67ed59e1d1-3b41c98a138mr1104076a91.50.1795141054397;
        Thu, 19 Nov 2026 18:17:34 -0800 (PST)
Received: from ysq-QiTianM428-A376 ([111.201.209.250])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41cfbaf2bsm708563a91.2.2026.11.19.18.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2026 18:17:33 -0800 (PST)
From: Franklin-Qi <yusq77@gmail.com>
To: Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: rust-for-linux@vger.kernel.org,
	linux-mm@kvack.org,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Georgios Androutsopoulos <georgeandrout13@gmail.com>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	stable@vger.kernel.org,
	Franklin-Qi <yusq77@gmail.com>
Subject: [PATCH] rust: alloc: reject offline NUMA nodes in allocator
Date: Fri, 20 Nov 2026 10:16:29 +0800
Message-ID: <20261120021633.12274-1-yusq77@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Stat-Signature: i6ydt1t5358gxs48zyhn6itb7zqfk7tu
X-Rspamd-Queue-Id: 0D1E6C0003
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795141055-879849
X-HE-Meta: U2FsdGVkX19C/rp+KTGDfba7UInrsWicLVg8q+q6dmvysQnuUFGI9g5PDxGnxMu7WvA0VI+24Nvgyc19mwJIZYR5kfKOg1X689/c/IXjhfe0ZvEncnIhX3UNE9x31ONh8IywceCfKakep8kdBXzndyv+pBZt6F2R+o5T957EYf86nclo6zrn/lVCEzbkzCm+DSoLsUYMT2iOdHFKvZNSWNYe3U+rpy5yKjM8N+A901nSrkOPS3qHWcOQqjI3av3oTtabI5y9DF+oWB9ceAIXeYqVKZKaSbb+HR6fe4EipvHsXstwfiGu/o62BLcUG6FxcHqx3FH2KeHNnfIR0DiDuW77EQahH+QWCle6fcU7LcWsB4M1wNvQTzKTk7/oOXi/TI/0TJbt7D22YNsByBq701Eteap9Z+ehs9E0tqcFa7MG6nooMHzFGiQ3uaRqVKocnzSJaWPFhn4isClLZfh5FKrYuIw8JdE4d7KvKljoRussMkXnteqIxHgOw7EqWaVFT+jvvp+y8W0kWg+EO/GSf9SdsFrASQiG7d0EfWhBKPSW8vEyi28wVig68Tt7xEGyrncvNTMv/9ZxY2N2BPdvImfuNXRhYSCRlxkeHxNiCZEXeAu85XRTth471Oq+JQ61kmns/e3hXzg0dvp9qb64pFcLjmJgUqka5Uoq72TryVWTHTAh24y60jBFvCzXANSThJTatrujGPb5CExwDooIUzI71hzjWrNS6JACwABzBEdwJqssxIGY5niEE+ehA/MKZ47I+2e/cNYEY62caPVqXOumsoTp2mMGjb0BS8zV508cJNwKtVFGOZNBL+nNtRPiHJhfY6XfuGT9Cemj73eON++iLoGVdXPHsrIdq8bVW9krmoCs3u5AAb7pemrfEcNN4k0c0V6ufknOScH06pl2XSEG9xbrf+2PkFYmuWl6oAzNbIluThmlzdrhRsBB7v6LODMWkOKQal/JHkr2UbY
 sdarMt5V
 W9ouTOJLTF7Xk5lFjUm7MWiL4UFnT/8UFyiOD1nAotWbrINvYuqBOjgTJcZAgqpn50egV1ot5PJr1E7dEoIpc8wbUNK8wuIZ6X9+GUV/OHY8p+QvqJy+e7XOCHhFmYDpFADW3hATqek4vo8xiJVW5rLAUDk4YlRRDt2vFuYv3ehgUKQbM0E1Nqe7HriKWDWOFd99Ks57I9nmrlsQG44KTbiJvy/1ARiQnQ6C+h9h0ir+fKu0JsBM3K6p9D2j2+/hdpgjqqOPfgqnrtzx3XKhtJmU3UIzBNDvgOY0TpA1ux6NVkJgynqMegUL3Fj3fKikEXIbklqaMZhqtdiGDlSq7ZNppuHrAqpj57Z6nu5MmQJFdQqz6lt41bmfou3uCetGPAeMuVecV3Yv27wYU59GxPXmkXpxkbmhMNCJG2NBtfr6n7FFxaQ8+jFvvmYNm1nIoeVZ7TrCUd2rg0lYb6SvuMl/IVUV6v3GX1ZiTr0RnS6dAx3pkzfdshxZxpgl5ITbxnnAIX5kYvy/kNvCMNOHImDegr7TbpLP0+WGM5K9SS7rT3JnRPqSRnU9BfWLr17dOroIDJNuZ1TBCO0MuiXRm/uDk9rBQSeYDBhw+nDMLr/1xV9rW96PL3KDtQKnhUKoWueDT8afyiTio+XvdqL9bGEuL1A2R1z/MCEapqc4QWOY/azc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

NumaNode::new() only checks that the id is in [0, MAX_NUMNODES). Safe
Allocator APIs can still forward an offline node into
k[v]realloc_node_align(), which may dereference NODE_DATA(nid) == NULL
and panic (GPF).

Reject offline nodes at the shared ReallocFunc boundary for nonzero
allocations. Leave NUMA_NO_NODE and zero-sized free/realloc paths
unchanged. A residual hotplug TOCTOU remains if a node goes offline
after the check; this matches practical C usage for rejecting
statically missing nodes from safe Rust.

Fixes: 7760b6421b6c ("rust: add support for NUMA ids in allocations")
Cc: stable@vger.kernel.org
Reported-by: Georgios Androutsopoulos <georgeandrout13@gmail.com>
Closes: https://github.com/Rust-for-Linux/linux/issues/1263

Signed-off-by: Franklin-Qi <yusq77@gmail.com>
---
 rust/helpers/mm.c              |  6 ++++++
 rust/kernel/alloc/allocator.rs | 18 ++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
index b5540997b..b61e54e16 100644
--- a/rust/helpers/mm.c
+++ b/rust/helpers/mm.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 #include <linux/mm.h>
+#include <linux/nodemask.h>
 #include <linux/sched/mm.h>
 
 __rust_helper void rust_helper_mmgrab(struct mm_struct *mm)
@@ -38,6 +39,11 @@ __rust_helper void rust_helper_mmap_read_unlock(struct mm_struct *mm)
 	mmap_read_unlock(mm);
 }
 
+__rust_helper bool rust_helper_node_online(int nid)
+{
+	return node_online(nid);
+}
+
 __rust_helper struct vm_area_struct *
 rust_helper_vma_lookup(struct mm_struct *mm, unsigned long addr)
 {
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index cd4203f27..15e17f598 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -101,6 +101,23 @@ unsafe fn call(
         nid: NumaNode,
     ) -> Result<NonNull<[u8]>, AllocError> {
         let size = layout.size();
+
+        // `NumaNode::new` validates the ID range, not whether the node is online.
+        // The C allocation paths require an online node for nonzero allocations.
+        // Keep `NUMA_NO_NODE` and zero-sized deallocations unchanged.
+        //
+        // Residual TOCTOU remains if a node goes offline after this check and
+        // before the allocator runs; that matches practical C usage for rejecting
+        // statically missing/offline nodes from safe Rust.
+        if size != 0 && nid != NumaNode::NO_NODE {
+            // SAFETY: The helper only reads the kernel's online-node mask. `nid`
+            // is either `NUMA_NO_NODE` (excluded above) or a value in
+            // `[0, MAX_NUMNODES)` from `NumaNode::new`.
+            if !unsafe { bindings::node_online(nid.0) } {
+                return Err(AllocError);
+            }
+        }
+
         let ptr = match ptr {
             Some(ptr) => {
                 if old_layout.size() == 0 {
@@ -116,6 +133,7 @@ unsafe fn call(
         // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc` and thus only requires that
         //   `ptr` is NULL or valid.
         // - `ptr` is either NULL or valid by the safety requirements of this function.
+        // - For nonzero allocations with a specific node, `nid` was checked online above.
         //
         // GUARANTEE:
         // - `self.0` is one of `krealloc`, `vrealloc`, `kvrealloc`.
-- 
2.55.0


