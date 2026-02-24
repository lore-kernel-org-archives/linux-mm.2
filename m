Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDFCE9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 683716B00A1; Tue, 24 Feb 2026 06:20:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6515B6B00A3; Tue, 24 Feb 2026 06:20:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553C36B00A4; Tue, 24 Feb 2026 06:20:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 432376B00A1
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:20:46 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F9521B697A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:46 +0000 (UTC)
X-FDA: 84479107692.14.5EE6536
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E5191C000A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnD6iV9K;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4u4o0bhAzT/6IE+4NGyydXr8k+gqg/ucPdWyjv2dqg=;
	b=CUlFr8gR09NuGWBZ4SFEAAq2mi/8nRl2AB/CWmJr21UxPsOBuAhUtYMMhV3asHTM0LryEL
	LjYmmJqYNs/pLb4niBh4s1Atf0G2CMQ9VnjdIuqE2fY1QHNpzaa8DhiaHdPEUTbbC4DHA8
	X3D2yFu1jXWgKfrTgfwmBZy4DKKMGWA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FnD6iV9K;
	spf=pass (imf20.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932044; a=rsa-sha256;
	cv=none;
	b=tWSxOwB1n3D2APU38AWrduTUU9kQbAHDHKi5FWNgAfilP7vxO653eMjY2/HFb9W9AzMDHq
	YokSbiEk53agg8NZbzm09AMBz2RkG5g3iVGIgrSqvpuQE+ECR3ejNbdB6sZgmFuxUp+yVK
	k8PN38EqC53e9VEMTGWtund5ffYzq/w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DA3306132D;
	Tue, 24 Feb 2026 11:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8595C2BC86;
	Tue, 24 Feb 2026 11:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771932043;
	bh=jLcwJmCU6NuD58W2dvDRqr7xKpNKXDGKLW9pDqZ3mBg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=FnD6iV9K9NZ7mJJSAL00XOjIPTg6UsieDGlm3jaXgSc4Rc9rMU8mCbbe0Ub0QU04s
	 j+XA7mBrzuVEuqRfQI92KsNlua/cpKJgCXIE8vr6AZo0jhnoNhVLUoWlWaAfplH4CX
	 T5sAiTOh3WoLzwRvaEg5Hlr+AzFOgVnxNtBg8DyOwJeF38TDShZKCUIt4HUXRybDpW
	 R/l7zwbU3DLkv6fDnzGUcBYSBRH3Eu5wt2beNLcG/kisJ4dWaJfnvuLRpJeRdFTgfv
	 ylStit7gCo0yNJCiejtjQZi34htmpdrmCKcOiapJ3ywb88WPPGD50uHtZIJnTb+Acb
	 HTH87pF60sZqQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:17:56 +0100
Subject: [PATCH v16 01/10] rust: alloc: add `KBox::into_nonnull`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-1-c21afcb118d3@kernel.org>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
In-Reply-To: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
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
 Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1062; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=jLcwJmCU6NuD58W2dvDRqr7xKpNKXDGKLW9pDqZ3mBg=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj0TV4DAv2lVFJSr3recsWpK7mpdMvf0fOO4
 GsqOYqcl7SJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I9AAKCRDhuBo+eShj
 dxXvD/4uTFSqjCY3iWHRTIEAh2NylxI+XqsaQVjNHfa55ZJJLgTNfYUvcse4RyQozv7pvyVWd9X
 RTV+xLwmBnbBtZhV/uwmF8F2kvjU113KJpO3sMatO2yNc358Ve7JZhap3nzmvf689b+moR9KW8U
 8ifp9shwqd9GxSnUqYmJQww4ytW7n6vmrS9fdCG0VpncaoHbclEqKrb8kHlDpPWubp6c+Qu+ywV
 ZSm0AOEF5voLr6yFpDRkglqwU7L54LiXgfITkIb6UbNJrDRXOO57QGjUnybgV9oIPGKKkwQwRZQ
 uZX42y2zKXJNwE7e0PtSQh/G9iJSeO6OlIl3XlsH9/nwxhmAe99bikE2XWCyvXsybp6xdn8BHKc
 r54RW+VeOtJ8HA3/xoWs07B2k0WCCDEs5APzVEAOAAzVtB0PabBsu+U6ama860OueMRxHOILlcZ
 +Xf+pOsN30kSX9dsaxnpoC6hcm2hPWPJL/HaytSlHURknmIo6ZknstZlgrOJ6sPfuOgZPJ9KatI
 nzNP0Z3U5LkY0BatvObNNaHXd8Ke66SruMP3igQJaaJm0DeDpUNWuOdkv9+3giycXGQXpdPIHCt
 lQVZzP3lDsyullj2okwbZRVi01SEBePzKduMTuRLyTs6JjpW7tCsxzzCAC0M5H7le096T5lOwCQ
 cYxZVgcHcuck6nQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: g864toaxrc76hzrzmzpemqj3rg9xrsdk
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 5E5191C000A
X-HE-Tag: 1771932044-297484
X-HE-Meta: U2FsdGVkX1/iUmrDPBp51pruEaeVWw+95GecLHrX9Ur8dmV0trE2Owhrf9v1ZihiToLFLM0EFIpBGnmTyzHxu+iLvj8etKN6NSIie1NXE519nnMXcQGts6DN04pay4Vu9qlPBxGWuYWEBHRNdK54p28fX1iMdfRfTAYkWiZVtM4+lxiMcE3PLyC/7lLLjCPJ34+0XINP8UcY1SCCpMSMAkkjkzbTfbRawKx1knF/GWiGyQexqz6rAhRaNCxosMiykHFyrT/+S64hZf4oTufeFP2pb1hc7kx/gEKvUreflkjv6AAs/oW0zVDIHts0LRIqV9SWH2Vh2ymmqafcVq/XixKQ+SVE+BgzIQ3IpoJ4ie5E4pBZR3JPpwGlF/Ah1BNsB7O8cgiMB/0QPEmhwzQ5ChjUHk9ctKcnqGZEMIzf1OViVMdUbUdlmm1jz4j2xivfmfIndX7BS9mYm0USEOO5OaKR747kMffLM5a3h+phv/UWtaLE7cGA0ejV0xQk1++MNrZXyjgajAZGXC0fL4usYNU7RwiiqBlpcLBjUXEIJTUqWWHvoYGlG3odTt+OH2T0kBPIEAJtm4zA0TQo+JJFVFntSjMFLJ4J5q0Ck687AGcw4X4W9wnc4U4bdfEHh79AUOtjiigSsbsj5NN1cPIKxO44z1xa4yKFbr3MhRXJJaSxWSwXwPxZmJE9yV8QnpNOGIkuJzextOl9K/RnnBSXuPRNyYVla2XuN1SGww6oWHiiQcU1OxmC/j8wWfVfPNqeV2EiLpBqyNc4i4/LLI5LnH8iqj4dQd5JBBpztBkReyIUsd8y8cQeGwjQ32io3MIVCpIb1hATDr88UAOPjz4lWTGvQAZzAd/thi+hFHX+zaOOKCq/95Rf4UXXoQ+dUhzJWgTCcAqogwa9hw+kOXBwlHSj9z7Jsxo1W8pgbawsUGhLQI5VpPG84Y91jxFZmiISkp4p6Ku4pelUulr/WoB
 du6+Zpvt
 W94s2iJrkqXWyRqkftDTBFbu/pUt1ZPh4ko0VbjTu08ZyeWOjXp2krHm5ewO0EY7QVp7uEHfgWlgvWVYP42DO0UjKOTJGx41N565XlmWMvPoK3J+P5z0O++v/9h+u/OyuxKIHM2HQ5emJYKRFaOjxpbssETOTTGsKzy5zI+2BVqGZ1ESeLDTA1uTlC6SLAH7tQDR1ueR3GG5wjToHdkqLt1RHnasEtiS45wXvhuIm1bkAJcPDM7Hyym+HmPu0j4sQR9SzNZRcCOUPtVtYjp4gLHnX1D+YfyV+gim+4BlGtX+sC7TJLERZbHxoomtqMwA9W9Yz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
is a convenience wrapper around `Self::into_raw` for callers that need
a `NonNull` pointer rather than a raw pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/alloc/kbox.rs | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index 622b3529edfcb..e6efdd572aeea 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -213,6 +213,14 @@ pub fn leak<'a>(b: Self) -> &'a mut T {
         // which points to an initialized instance of `T`.
         unsafe { &mut *Box::into_raw(b) }
     }
+
+    /// Consumes the `Box<T,A>` and returns a `NonNull<T>`.
+    ///
+    /// Like [`Self::into_raw`], but returns a `NonNull`.
+    pub fn into_nonnull(b: Self) -> NonNull<T> {
+        // SAFETY: `KBox::into_raw` returns a valid pointer.
+        unsafe { NonNull::new_unchecked(Self::into_raw(b)) }
+    }
 }
 
 impl<T, A> Box<MaybeUninit<T>, A>

-- 
2.51.2



