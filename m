Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B4AE9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64CBB6B008A; Tue, 24 Feb 2026 06:19:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60DB76B008C; Tue, 24 Feb 2026 06:19:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53B876B0092; Tue, 24 Feb 2026 06:19:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 435616B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:19:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A9921C59C
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:24 +0000 (UTC)
X-FDA: 84479104248.18.C18CEE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 58A914000B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:19:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tFUvOs9g;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771931962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5aZqG+XzA0WoFTpGQ1p7yFKK0VBKoEgP4d+7uOYB7xg=;
	b=Ccai92SldJpGerwzCrN3QB0C8tlvhPvxVYfrmzvQzh9r2LO1LPJE/shAR4fZh9AfVU3RF9
	JSKJPoNRbf+i3biIj+FYfAFA6FY1hmTlf9v9Jm2bN4ive2LgxdkkR7UyE4yAWEcNKzTTZv
	G1Q30ZybzbSpTdby6GLevTC8s7N108M=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tFUvOs9g;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771931962; a=rsa-sha256;
	cv=none;
	b=WrW7bL6vIxvLSi9+16ijuU4O7DATOcGi/xCw0h1Fie7raF2Micmkze1IlP/CTcqA8NVFZ2
	tM7YFTRqMpF2H5hbXxLzDXGYjW4Q/eWr727eTd2momF2fDz6Yk+AZKnJSCEYbxsE0hWCUa
	+tcvkr8HNCSgSJxIwsKCgdC/jN+GmdE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5BD66183D;
	Tue, 24 Feb 2026 11:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3475C2BCB2;
	Tue, 24 Feb 2026 11:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771931961;
	bh=fnHuKwO7YKsiBEzcJ4WSpUwI9pJ1E1um3MRGk7ZK9EA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=tFUvOs9gyzy7Ba7ekjjypN2kAfFvNhFK6Ym27l7W170CaSEHNkLV7YYAlGJ5DY17V
	 owZdqMEDEr5KFkPWDencHzpnD6natiZrnAmC/FLAi4Z9Lz9zfRJbd1sxhstw3Hl1qy
	 u3TmQQtb1p0mU4qoPVMfcuGSdi/6NzTWthDZ8/25H8RJLWbJ/6pT30wRAygqhzSOXc
	 POq8PYVHC3gY7LnkY5G1YFdreQr6i4ir+kQ0NPvmhP8liRwLK0+oaicE1UhUTsYKpW
	 VCO6Y+I1ha5MuldT5BNfYVtKlVWFlcwhaRF0Ial+V7749Z0vgjvOQ47+NKhdP80WIe
	 oTCMnGg6JKtEQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:17:59 +0100
Subject: [PATCH v16 04/10] rust: Add missing SAFETY documentation for
 `ARef` example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-4-c21afcb118d3@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1545; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=hSYEjFGzugCDI1W/rekaqf2DA13xvb84HHFFaBF1/aI=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj39reO0a7D2MQbsv0XqEQumCgi03QYrtHI/
 ZYn1cQw0UOJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I9wAKCRDhuBo+eShj
 d918D/0dNadTGYW4J53gaqBX2Pq2oWBZGwS79C0CdceTypFO5fLqCVqxcqXPCooqVOZ11C6YMVf
 nMG3oUX/TxD3GSgCMT32HQCYprMppcd53Pt4ne9SNDH001yDQwxMLHtNTKcpRyRCyvPkSn61Ot7
 vx4Rx/e7RRI1FkWXDubxT9H0137dXGskODt5t9Asv4KyYOrxv3ulMIDkJLQowoKQOF5s92uqIoJ
 xNbZr7Cbui2WcPA3z4Dv8hBkHETBbOiI9ZWyX/vzBhf9FVBTLhRq15q63fsDd2YSOhGsYcE0Kaw
 cxbfsyFqBCEmYKLrPq0/LCZBV2szgX041hacce/RW4TaXwcLNA8OqKFfDi4nyc9aWdzP0ZDo52u
 Y3S3xvgTa0o/JNmM0+RHewjsPyAuXGTZ9qDhKv4T0ZBVi3WBBJRL8tMGAz4NNmBm2xCWAeGh5JN
 JLBXN0Mzj+uh0wtXz1/YIW41PFoS8isp3E0P6XlRIQOe1/Bh6TvPXSeAk5mKDYpSyP8aQRAOoqM
 aIbdQNjcoDaMVPrUz6IKm/FAi9LvWEI55GbXkoXGV+VkvL5MamXv9diHQKLqnMGH8yQ2QuG9zaK
 PpvAvvEKSA2iT7kc50MybsG6wBDt9DwvNXXuJgSCkdHVO8ISQKjqIjAonQP04V0i/0C64vwIodc
 nSi+sCMbQh0moHA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 58A914000B
X-Stat-Signature: nywbtu8f6byce9e8m74ekuq8qqug9df8
X-HE-Tag: 1771931962-590164
X-HE-Meta: U2FsdGVkX1+by0EbsSkxlJttDPTuCuuILt9WI3U2ERIuOW/14aMl7Rn2ctifDmo1aom/7J5MG71GM+kimetxSQHdXQCFMk0vpuVZfwGu/Zj7V2D/mMVfui+7g0S6KA7ul2ywwQ/VR0FtPavcZX2kjl17lOdfVIBcaIKjBkC3aRObot4pwfzVabAiOsivjPqlIX/HsALY+nwixeuJ4f3OKELR03HdAkQZ52onmIBB/O8lDK990iOZKM7hGCQOzabCKPuHQswNdtW+C2VVgTlqWNEXPNW8d/i+wV+WoTDTX7arwGrDQpIMeBNPNcPfaL9howDijZCp6ZlKD9jN6mQGxG3Qv5HBAUyBU2zQmn02tHCSuI4PBMFB770KN4O58ybdpe4CDJL+13f/kOvgY2L1Tyz4S2Fq8RLh5IHcSzqX9XMQt+5J+Te3bEIFqChS4T5LnmPiL/O1ksP2v3PQ41giFDShx71wU2GCdZBxU1dyNtezMWAqMX6D73lfKcYib3Al/xX7HsPy/DXYfzCvnJLCYKJud4R8yym0sX3jpOJpPsxxs/jq/TaH56azCmgfZVdE5fCCVIsjnEkcCNWBQadObXuc9qlx7lNmKcgl0O0f8d8lBbcfKVkXyZRkLDUeNyTpNYLo68SvSKw6MpzBLDX6zc1c8wVMv2/DXmT34cjkIq5J7Z7tve8CQvEWxFGv6bDBEMNEkhAqf5ijpib7F0R/TCjZRH/Pg3Eig9Kkyy4SOuPOIuyW2RH5H7j7z3Nf0kfdatTwgDCHhHdUZSdfK01rWwdQGcsOkTbPg9vDspMc9vByWtaLWCAzswNSdtP2SKMLJLPZmoTY0DcyYe6hvJopKMVjr/4e1X80Sz3gcq31/RNyofdByepJTX0q+DvBvYm9LHy5HcGbvMxCCjulhD8XuZTVB98xXVbrJK4UKzJtyTZM3oa00zrMu9uElQQrc2i1oKgFy6hRoVxTgcLXYhq
 Msx5fn/E
 2TjDVryiSs3jaV0rQv5z3QCIWinALTROW+L0vB0jkNPhmVmJDERf9u6SOoeY81C5PUM8vuDkv2st8x6d6E5wz90msZYsaW7NHTEmjuZF06tKOCSKUzU5Z0ylo7aVoLtC2gVy0w9G7pCDUIHjbHVHCMyPvs8blTre2bhJMu6tlE5j1K2YcwdlzoMqcw9gST7tB+HHkHUfhQjOggfMBxpZbIwLJv9tFNsiyFeEZNPc/gi51gVbAHdslfugBvgqTRKHURiAu8OZSZfNsWl5WKTXJo8p0q8gF2effp7srUYTDje21XNh0yNO549w2ZXa0O8ZOKOAvw6VvQSjWUMqvmfxTCLZKR6kDnNXFxniaX8JvofnwSC23cBEdGENxEQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oliver Mangold <oliver.mangold@pm.me>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 61caddfd89619..76deab0cb225e 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -134,7 +134,9 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// struct Empty {}
     ///
-    /// # // SAFETY: TODO.
+    /// // SAFETY: The `RefCounted` implementation for `Empty` does not count references and never
+    /// // frees the underlying object. Thus we can act as owning an increment on the refcount for
+    /// // the object that we pass to the newly created `ARef`.
     /// unsafe impl RefCounted for Empty {
     ///     fn inc_ref(&self) {}
     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
@@ -142,7 +144,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// let mut data = Empty {};
     /// let ptr = NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
+    /// // SAFETY: We keep `data` around longer than the `ARef`.
     /// let data_ref: ARef<Empty> = unsafe { ARef::from_raw(ptr) };
     /// let raw_ptr: NonNull<Empty> = ARef::into_raw(data_ref);
     ///

-- 
2.51.2



