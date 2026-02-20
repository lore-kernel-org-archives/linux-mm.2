Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17068C55178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EC836B0089; Fri, 20 Feb 2026 04:51:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 599EF6B008A; Fri, 20 Feb 2026 04:51:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C64B6B008C; Fri, 20 Feb 2026 04:51:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35B276B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:51:54 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 64108BD8A5
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:53 +0000 (UTC)
X-FDA: 84464368506.19.1902DCE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id CFF2EC0004
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:51:51 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oSMnR2VB;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Zfvy7nM/NrHVVX1PT+lkagG6YqHQTr0oHEXLQMyTIs=;
	b=QVd9Odxvh7WqPjpPGnfZqmpVglcitmKg93Pqk0s43ZkCn0vJXoDvVqNu5J3LBq0+Vri8Mt
	3bGdsOLNkqDLysbfNyK7Nc1QuDk0A0jhiuEt1VOhOtC/S+dyxzaLYWH6ArEp6Ox77yfJyb
	D3+xec/rCJCkimZgc6exgCwZ2c3NslM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oSMnR2VB;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581111; a=rsa-sha256;
	cv=none;
	b=Fi9HWkiNez62DBu5IUZkoqhNCPbU+agobRo2snIXJbH0sI319JkQPNCyUdHEIcd9PFNd4s
	AHfXFFrgUNf4ibKbGT74YHAtLt9wH+njzV9Nu6yq1f6wbLhss0zdce/Wb6acoC+2+r9Oqm
	+MVuwEkkKA8Xj2FDiEvQ6f56n6IxQvE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB3D260054;
	Fri, 20 Feb 2026 09:51:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E18C116D0;
	Fri, 20 Feb 2026 09:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581110;
	bh=PBOESvJWRqEQ2bmBI+MqZdyLdwyA7OsD4YPXBLOYQLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=oSMnR2VBFiYF7mSjxjkfNVi7njkjNf3PLhFrBmpcM9d4pWK/GXd5fkMSWFUZ6VD2x
	 5eWFNCJJkIsdUzWD77f02RYiEeD4v6skYIt2XW4ao3NA2rgWmQjg+wQhZGtGTM0+Zj
	 QiUHPRguHu8S8fyOflkwjbIMsLyOrB/J3XN0Hx2jcXaSuNOpyqtRqMaEsgaUkyYUeX
	 KxMtJKZRfO/w92vTqQMucveSOe8zWyt3q17hU4n7gBLOq3rKrBHkil4p0WmBHZZPXk
	 G1/C+VImEEajDd/Cp9FfpLnahW7HziI4vghEkK4AbpaRBMnwIhHj6tE38PTOuLCsH6
	 mzUUw11uwWtqQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:13 +0100
Subject: [PATCH v15 4/9] rust: aref: update formatting of use statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-4-893ed86b06cc@kernel.org>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=753; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=PBOESvJWRqEQ2bmBI+MqZdyLdwyA7OsD4YPXBLOYQLU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6hzPFPu7KGUd6cRx7n7GKtIx6VHoVNewyV0
 EXg0W57W8CJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZguoQAKCRDhuBo+eShj
 dxM1EACnIHiAlYn9gPgqZulCKlNlf50uQDXyF9B5lqzxCB4xzKIk29CViLlfREtNEQpmiNQ6TtS
 hzd1FYLf8u5dAvd4QayeNLUYTUptXcQrByNp2EdNsAhuMhgCPbvxv+5XzO7Yb4c2iwvxXZ/GV3F
 Ez583A3k+mRd7YqWWpEj4RFpnKFo5uIsu+8LJckCpHdVp+QBP16CQHoJpF/FjhcEYaulQ62G4kF
 NkTJmahq5F85IlPLQZ9bZfLgDII15NQvFGJDbj6tOPcVDVLOZrSpdw9wHnDj5K7h4UE2FTUpyZ8
 sl8Hk5h+JXj/1GqZbQyHuxIM2mJq3l3W8UusstI+ftPaYNK+cRNg5aEEWt/uP7WYBqUR2R+rFez
 NF32cG5Xgq9fKisyoiE0H808A3G9U4UA8GIZlqilG16eM24JIQWAw/cbRleD8D7YDiPtRb6id5R
 yRJBMLPT83Cz61htPmBosbIHLJX7srwu8C40hy8wXT8NeJvJKVYf2HY8q1ViVS9uaHBWecAHYjJ
 qa0FaiULDIt0mIIUOHhDKnldiiopsOPUz3D+Fz0tJhlLaaw602DiBfp+t8ghomDp+O6GNvrZA5m
 yzaE5kR1WUPNuPs0iFLB5ez3KpIEebt3HS7YpUVYt1xLlkOuC4mg364/IymHXlngTS1mnkrgVVf
 wmnQL4v1G3QBseQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: CFF2EC0004
X-Stat-Signature: qa585tm6ptqd17zde6pzxoraiyxzu885
X-HE-Tag: 1771581111-288512
X-HE-Meta: U2FsdGVkX1+butnAR0/oIft3MCWWyYdbqr2NBDXbsAXE1RvHDuACv8EvzyqRsLHWEJzaUD3zao3aPXuH47FKcR+zutULjrz9ylax0qGPEWXHQ+DLd7ei0ff3RkpoL1JoMdUwCh8l2qaLEZQ1xARYbws2V76O2ItAhqRTscQ99GuIdlz4YpZL6cBJITVWj4FIP8Vp6yoHfFcd+aizUsijOawM9FUrbZKrqfxTQ+pfkNgWWSNEUseo88CSaJ+R75pGCOKkJsEbRZUokhL7vTFV6AhNqBuHVxQESYhJehdungB1EE8mDcsc+6CZfMbqKqrSKzMBCisVUQ4WSEcDhTcMuuouDk7OcGio/8gndZNJF+R9eIv0fmmMg6pGl785f+VOD9k8hg1YxHelYfElZg0/zrz11Jsn5M7sH4mBOrbFAS5CGBR0YW4OpIYiDZJeVkfwzaBGj8lxsjJU2iR5DxG9p+dfMgjnW6iZ9ejSU6yRXaVwoMrsmMRHAZ9AOR2STuVA5tT5EO6R7iYoha2qM2Nf2TvL7Iop9iKkC2OYNac2iHb07sfxK798q58qYuyvx3aiVaMbSgQdnTpcsWnWH0fwWKVReM3el1V0FiWDFza/m8prPGpw/E6roQi15cmqzUY8r5wLKISi6TxHeLeVA/D1NkvS8zuuAs0aGIzwM3cg3J25p4zfjeTV3IxJV/XsqcFNJpajovyb+hzhB+YPe7kNgjXfV3kVMcEvEIXfqXU6HSlEeX/jLch2lqbyq78rUp+/vsNEi5V2y5AAbMy5LPZjvxqSm+5BXG8bIoVoNbOCB3J4i74bIBqZW+25wr8ghB/s0/XR++eWvdSzzYVIpCtVC54tyNssN/+fgh7oTLSWMbhyy8uGJuD9B/eJmSEO4nrkex1Js0WHzlNQ17UGHfNUw9dhIUP0D18Dcft+jYB/IjLA1AUqsL9ifl6WHllsVcoKAyt3grE8g2MLnFFgXnA
 PLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update formatting if use statements in preparation for next commit.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index efe16a7fdfa5d..3c63c9a5fb9be 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -17,7 +17,12 @@
 //! [`Arc`]: crate::sync::Arc
 //! [`Arc<T>`]: crate::sync::Arc
 
-use core::{marker::PhantomData, mem::ManuallyDrop, ops::Deref, ptr::NonNull};
+use core::{
+    marker::PhantomData,
+    mem::ManuallyDrop,
+    ops::Deref,
+    ptr::NonNull, //
+};
 
 /// Types that are internally reference counted.
 ///

-- 
2.51.2



