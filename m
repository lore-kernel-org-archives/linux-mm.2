Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC57C624D5
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 510A26B0290; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E6FB6B028E; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 361CD6B0292; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16FC36B028E
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:09:21 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 784261A0468
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:20 +0000 (UTC)
X-FDA: 85165678080.02.75D12FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66389C0008
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:09:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cU3Cnl1/";
	spf=pass (imf10.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788278958;
	b=4tB8HCL74H3l5kK7d4Dh+W6bHTjYgAzid2fSezOcgvBRiy4rWv0QkfxcfNmo6lBb+DMi3J
	CtdK6UKUfQKIueMkIJBK3CBXGYAYBVkbHstjNbTtRPuFgquCXwRXsdMDpu7DEsMBtNvj11
	j+cPc/YuXzqGjgyHSfbSpY0GDSvq51I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788278958;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hczcGYP1OVbgg1LlZo2FVOGOXbr1KaONKxYKnTcQM1A=;
	b=5kpXeyDuzvmZ4WcZBFVpP1M5360TSpTHQnfCOebxmrV9thBvJu2UQg6vZ5lPZSgPbmBrM9
	Gz/mx2smRuHeQ9bdag5YStqByjX6c9llPls3b0iUu4848ZL0UgEamRAlO3iSNduvdC8OJW
	h/faE0p8MyjUIiRvRiDAbZAcK+zn8D0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="cU3Cnl1/";
	spf=pass (imf10.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD3D8435B4;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 72EBDC2BD04;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788278956;
	bh=zA9tgWKf4SBtTBAhJRzDALR4sj2TbJPjvzc1j0kLi+0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=cU3Cnl1/XCHcPDdhbKsQkf8GKY7v5T2PGtfYkY15wwAgVlsUwjuwf8UHtvcLZoGrG
	 do4N21kgV/k8mi+Wj6+GuNQC/oCEsDZjBoW12KcptuskpQ5kTzPXWwgFffzF4DQNIO
	 thGQFCK6baOliEawFl1G8wR2yZ+SUkAW/dL1tKw0sdF5+nYuLyeKxCfRLPSwk3RoNP
	 RMJHZtU26V2LljAZTejFiCmkQAoReIlgEmMylujcu+gxJuwScyZQbTmrsiUDjJCkw7
	 ZpuunTc9CAL/2h7eQyXEN+MURonSafxnbjjoAK9ToK9cnnW06rnSY2S/SkaZpKixSm
	 6/QXbxuc54kiA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 545D1C624D3;
	Tue,  1 Sep 2026 16:09:16 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Wed, 02 Sep 2026 00:09:02 +0800
Subject: [PATCH 3/9] rust: sync: arc: relax `ForeignOwnable` for `Arc<T>`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-tyr-ioctls-v1-3-e0fdbf8bd108@kylinos.cn>
References: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
In-Reply-To: <20260902-tyr-ioctls-v1-0-e0fdbf8bd108@kylinos.cn>
To: rust-for-linux@vger.kernel.org
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 Ke Sun <sunke@kylinos.cn>, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788278954; l=1287;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=VpFApDEE0ShMOm5bITUkvBMmnsmsJS6eNADKklXNSp4=;
 b=uHDTxFGNUx1spLlyFI1jfXtWSsQ4Kct+pqNbd2CyQ94I8hDhvntBrOhaGdYAsbGexhRYLJ6WZ
 8/XubxirktGCH9ARwXTL8UZSFEUKMVeukuaBmnBA2/hj0TMY6/ZHIWS
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 66389C0008
X-Stat-Signature: wpg7udghnrpu69h6fw3z41b7qoorz44n
X-HE-Tag: 1788278958-260661
X-HE-Meta: U2FsdGVkX1+UilU4+5jZOkumj8OKyV3EFN9RvtyZy9zUnF9SgiRfoR/OWeO/rOFZ2H1qnl1PtQY3LqxdaVSNHaLGpgcIndPtU6c46guJtDhNG+2s+eYmXvs6nd6bBdQ3nqnNP6XKLq7V37pkn905U2X2yOCkHfAUf4r3wRQMuCkZ84Gd5KKrTohdh5HrBEXoKIE+rnv9mOJeGOL1LLhGB7gKVWpAIzwTxLl0mO/8F2WwDddYyKhBtDaYEHtXImePEXjcNXLEN0MgEwM12RLWiQceppWqA4wjbAclU8B5BVIbxg7QKeCuMR/EjB0YJPC5cXYJHxfMLo8qOTrzf1ULnFR9YsZOakrR36ctt68GMlIL/xrc1CjQQYxFDMAQ+R2RvstpRAutu4YMtHweWz81ADj1+9p2r0zSZ4YJ84AgWAWh8MIz81n2nWctgcNhAupBTbRuBWilkRm0hRhUBcGcjuzM3eFKARtH55fXNM30oGmXM2EBF8hniEZggZ1CxH0mjFoJ3a+y4fsTkgvv3hPLTcmBQlxLyzVEnVa9W7CnkegrVdECbP+ixvkUj1KQLR8rIW7RjLG+eE99s1j31UleIO1JnKu+v25xHR70fCX0wnRng3P9ea+eMAYWswOFnAQYUEd+Hi+bx1Cv741pp5kJyx1r4wZOur+KFpxMOLDTHXH/eWGi12LfldcyBVuFZotJgPkSB49U1EmDSYeogX1S6gFPYPqLTQZgJPKTdtd0cIcyizfBObt4knwDRyvUA8k+v1t6rY/oRGcR2KyYlAzLXO9o3egxEWmnVJOtxvGwz2igFu0jOs/XPLY88B4EurvH0i+LJyGsSffb1YkQ0iAz/CiqR7uazOxiczPSZRMgyV4v8Vz9DaZlpT/JnoDgTwMrW6ak0ze9ayr0hsiOo9PuDA0ez7KdmxV123sathKJXN/RIKUO9XW1+ObYNR244ss8Z9KaGipfUHsOzxS1ZSl
 xC4SPbic
 +lEoDwQ3V2M+3QdkWhy3hU0YVFEJPIxhz3/bNavFDK4UjlfiL0z+nKcngtlwy2y4b5pNd9zRtfmoteDE3uqvZ3cCCMnMZd+dN46rJknu7Jucskeg/HBUqApDpt3Q6ko17KssPiZdyA2mpH+62kZ6EVoJFf7Jg66qhBaa9Lrs3XF7m0O2OMBkoiLHCDkrSTR2js19ssW7PyO4RtiproGt+2EuubjteYNtAO/mPgwNsQAKkXrjl97Izx1SNlNJujW9KAUMfrGqyEudbnKhXn7v1RDwlS43V6eXF/gh5hxDEGWOE47t30YVTaIXCGuJKzunWeNKYZsuGlsQG+ivbEJ2smc8wC2buQOovwfhv5QoIRq361jtRTNqqpk6R54fWAKQ6W/0u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alvin Sun <alvin.sun@linux.dev>

Drop the `'static` bound so that refcounted values borrowing from a
driver registration scope can be foreign-owned by the XArray
abstraction.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/sync/arc.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 5ac4961b7cd20..cd6faba84ffcb 100644
--- a/rust/kernel/sync/arc.rs
+++ b/rust/kernel/sync/arc.rs
@@ -363,11 +363,17 @@ pub fn into_unique_or_drop(this: Self) -> Option<Pin<UniqueArc<T>>> {
 
 // SAFETY: The pointer returned by `into_foreign` was originally allocated as an
 // `KBox<ArcInner<T>>`, so that type is what determines the alignment.
-unsafe impl<T: 'static> ForeignOwnable for Arc<T> {
+unsafe impl<T> ForeignOwnable for Arc<T> {
     const FOREIGN_ALIGN: usize = <KBox<ArcInner<T>> as ForeignOwnable>::FOREIGN_ALIGN;
 
-    type Borrowed<'a> = ArcBorrow<'a, T>;
-    type BorrowedMut<'a> = Self::Borrowed<'a>;
+    type Borrowed<'a>
+        = ArcBorrow<'a, T>
+    where
+        T: 'a;
+    type BorrowedMut<'a>
+        = Self::Borrowed<'a>
+    where
+        T: 'a;
 
     fn into_foreign(self) -> *mut c_void {
         ManuallyDrop::new(self).ptr.as_ptr().cast()

-- 
2.43.0



