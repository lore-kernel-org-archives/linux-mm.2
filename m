Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6331A60A2626
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HknpIIqB
Received: by kanga.kvack.org (Postfix)
	id 79D6C6B0137; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773E96B0139; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68A066B013A; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3620F6B0137
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AECBC120909
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:49 +0000 (UTC)
X-FDA: 85342321218.19.D3C0BFC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A3A45C0006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HknpIIqB;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484747;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8M0oh2AqgxAI6ZpQRJJhghp96GjY8sQQ1ghn1+UQZnU=;
	b=HZs6ftsj06S3vpiZUpQp+Or7qUj8F/DCGcetxMXoa6meaqM5Nm/3LuUUpcBaY0OJHpI3O0
	wkLwbtoqQ9HyNXwBF/JAKVxoT5EIBvnRlYJ1/XgzuSfCgUTFZu7Svc1BCYdnDSkhnhWVyb
	VLbwiTdhnYJ0oS6aRRWrTAvTPctZPWw=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HknpIIqB;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484747;
	b=ZlsrrEHw8H1A85vQ3BWCFz0DBxdNDFdcxLL9VEW+i3oSYlHhla9C3kM5TEUUpK2Fr77Eym
	kTbDddPqUBiN21kO9w9mcANRI3DoUeaf2Pkzwlh8iyurb++SBFDIXJgecZTmPO1Zu3DGHh
	qiqWTRlBLFAiCzP8NA9nWK/wcEd99oY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 30CA8601F9;
	Tue, 20 Oct 2026 08:25:47 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484746;
	b=FgPoTl+yeNRRHhK72O8ELkfEEdU10jb7xOM0QNRZtes2bT1qZKT4nk19hMfZ2gPKsP5C
	 Nm8W2ZBgMy+U+rgyVXoLdKcgW94+l95qrSOiCUffk7r+j2cmj2POggcwnGzF+ad2jRGl1
	 ZZl/dTmEVJ+/3ARlV0RQ0Gr0l/lGypWKGIwIYn+r/EkqDHfPCqO5z1RlNlFyGN38GCQxQ
	 U0AmeFRe89h9a6d47BaMCQTqEuWerFr89FGQoGf6Nsu7aKPsPpoDuAx+HkAjHf7rRMusK
	 bAaJ5+UBJAN75j0zpLoIqqYE/EYY9a5Yq3qLKiRKbDUTfHMNEkKEmw3ZDDkZMZl7TMA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484746;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=8M0oh2AqgxAI6ZpQRJJhghp96GjY8sQQ1ghn1+UQZnU=;
	b=q/rIZtmngc2brjlffBD1+sxNgNPvZUf/Uk/lw2b8rsC5cZ5AbqGGia8eFVQ3Sl3msIEn
	 R32cfgQ1rPoCpi6NNhzrONWGs5Q0QAwFoLtTdZySnuWJqk5MSf1PsnmnrVGjjaT3NsWzp
	 qtsysX8lC78Dna5GuSX9na5MJwg2DsCJmenfKMc9GUN0UiuM4VJBDdDDvBnQKjJhpvpNK
	 fU42mIcwI5EndAZA/qp/jrhlj3EiIjErgcnorRdOvXoOpQRxVbzD8lLYS38Gml529f6qh
	 jPl6fn5YVsxPwkN+BwMjB0oYycpdev0Pxm9B7WJmPJZDVTt1nbf3X79lg8C0F+36Zrw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 45D0A1F000C8;
	Tue, 20 Oct 2026 08:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484746;
	bh=8M0oh2AqgxAI6ZpQRJJhghp96GjY8sQQ1ghn1+UQZnU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HknpIIqBWVG4RDDAWPFpeRRZGI105BMcDt/QIyAV3htiFcIUqAU8Ri2roNpFry+6f
	 +kOv38KMHhCeBugMGAoYx80IeABD8tTwrDsIq33IGF0ys4V7aymNlRctRl+0nAsALZ
	 OHG8osUMufjdJjYWE8UA/9TnvxqE73TuGWXRIEH50rHZ+5VRAB6E9wEIJFrnRkN25c
	 H45MBY6CfEyCZgtzfukiSv0D5/6fNhQ0bkaYUhfNr1Ivo3SZE8manAWF3xFC61B7UJ
	 LmJs9bFUtTPKI/C3vauUl4lgQv+ar0Nb7pplNlpPpvGrKykypckpFqPe/4YPb9UPCZ
	 yUivwQHc+kJrw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9FFEE430CC;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:18 +0800
Subject: [PATCH v4 01/11] rust: sizes: add SZ_4G constant
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261020-tyr-ioctls-v4-1-704de77da223@kylinos.cn>
References: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
In-Reply-To: <20261020-tyr-ioctls-v4-0-704de77da223@kylinos.cn>
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
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lyude Paul <lyude@redhat.com>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Sami Tolvanen <samitolvanen@google.com>, rust-for-linux@vger.kernel.org, 
 linux-mm@kvack.org, dri-devel@lists.freedesktop.org, 
 driver-core@lists.linux.dev, Ke Sun <sunke@kylinos.cn>, 
 linux-kernel@vger.kernel.org, Alvin Sun <alvin.sun@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=1808;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=5K5ZDtbb0No9pS3iRwCaB/ZkoyNuv4RA97gE66KsHmQ=;
 b=S7kNtOQT98eXxrrMvt4CgYx9CRvn9LdTut3eQA05YkIP763ffVSnG4AhPDuBiTBCVr5svmTSQ
 ijyrtnGRtN+ClGSgrmja1W8xjNWmpTDLmdDgZdMd8avLa/I2O501p7K
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3A45C0006
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: fgiyqjwdwbp7q38eo4eb4hpzhwgdf74z
X-HE-Tag: 1792484747-25807
X-HE-Meta: U2FsdGVkX1+FM8nrOaGkStesVDFlIUd9jbcZobMl0ZEIMS1knVykXA8h4tYfTHbdr6y4ZOEC0IQurFaIw2Yc1EqtyLqBzGoPXWf9vpJPTo7sXsZfUByucQfmqTSjVBqaiXYT425kj2q/UU/FkRr9HvzqKwnYvk5AvLnnlg5sTBPCJ46dPvdfksOrpzJuB+xdX+FFxsRife6gVLKVaeiv6Jns0FWJC1zZoSrMvEU38EwCGaGBEuoYeVBeOwzfBUgOOiKUm+5Tjrq4kuAs5G0eev5F02QsfzLiKwdiffxZbhuFLxJ8vKm5Gb3ropliMLmmgbHuFRj7pbA9rhcbdwtprFxJxbEnMd2Gn5RAeMtgGhOM4DSk6J+fqvieyuRJZCxfvbFFtyBcW6mKAmaPGn3N1cJs9mws0SAMoKl6Y8aTWq1qBGny9g8rg9zd3/Mr2Iob0jXH+ugOKwKZS8jBOJZTSSVDemCaMG6Zq+p1y2oWkjHLeuTQfTVoDSNtJJh8z45KxMYsWHWwc0wwl0mW5vgDea7WR33+O7kCiHx4c8Rx4VmVni4zpAn9ysvMs4xoTGppZcNVtCzVXyobBS6W5LVzKwVTbB7Qi2LEjNXSqmC8awN5bUgzgvbO+Eptf0X/Im7EWAEZhjpvq9oSwaziC5D35eg5QQu66xpy9+hz+2gvhhGYqJIA+GHY8u2cLbeXZLrfegOAu6EVYBA3cUEKPxH/gkRYHJeZIPAuNQ50vRSsDJg6O6yG9ZKn16Vheyeq5bA45zt45buRdfJmf+8ozCjv4VQRx5IFybPQuX5xFfoEZ1ITbjVhcmyWjIL6R5ibF+kEsZbe5GCnw48tzoaAA7Z3eUo47+Wn0GYBBI67JFIabc/6IPD7WlfPAa4My8sVGy3Jdumsf3Pn0jZK/ySePBKZb10Am2vuU1S1Xcb3nw21Nq45wuhFASwexMTSprlMHUjh9O3editgMzTt0dBhUKG
 Oi1Wqp1f
 gMBPMp5HEyfZE6GxHVW2O+LkmJraz5SRQEAAro6/f+gBhZ8mnwt2sJ8qp7XrSvjdRjIshuTFpnyfBO+rDvx636ieCIrAeNpSn8GCkK+46VNxRtsdZYYGad7yoMVfAU4TZEe6cJFgKBXX+Hz/gHaF7J2E4SdzmLIWHPXkygv0USFLBIuynGNJUfz+eWrLerMhhBE+DNWdSCYBciz3sqiMdMFi/IUyu9kkFKIV0nru50lPo2yQ5qjNiOAy5gw/DUYJUvpDPNS0KDNo9PBEksmKmhOTIAkxfHlCS3NL5NS53kcvY2eGCSFF/HfI3zKHkIe83Vk88ruYzamh+yhTfbWHVmta+L1e6zsb6vn/NN7QoLgw1eaOKZQ2XuZrcXxhSs2rMq/BgR+ImHlnjWydST4wMhYDlrFKyy5moRIMxisrHFh78ZF5TDmLsvaZNyUVWLPAJJf7qWIWxY2wLfYKO76IJ89XdaIyj63ofut10qd7IlD+RbGDpN0TnZFn5lUWco+bkFv0JBFMxcd1ttXWskqOQn27yj2kQxNcqve7P40rOzvFmzzJFhqrNVbOu9Vusz9KhyZ1YGZk7E+mxEcP9meaxG2uDVYqlwp2L4DBCqtSP8CMjZm97qx/S6SVE+JuQ8HrCZM2W4i6h6SLUn3bQYqT502akSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

SZ_4G is used by Tyr when splitting the GPU VA range into
user and kernel regions. Add a LargeSizeConstants trait, implemented
for u64 since SizeConstants only covers sizes that fit in a u32.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/bindings/bindings_helper.h |  1 +
 rust/kernel/sizes.rs            | 12 ++++++++++++
 2 files changed, 13 insertions(+)

diff --git a/rust/bindings/bindings_helper.h b/rust/bindings/bindings_helper.h
index 930e63290cdd4..ee99f470ae5f4 100644
--- a/rust/bindings/bindings_helper.h
+++ b/rust/bindings/bindings_helper.h
@@ -116,6 +116,7 @@ const size_t RUST_CONST_HELPER_ARCH_SLAB_MINALIGN = ARCH_SLAB_MINALIGN;
 const size_t RUST_CONST_HELPER_ARCH_KMALLOC_MINALIGN = ARCH_KMALLOC_MINALIGN;
 const size_t RUST_CONST_HELPER_PAGE_SIZE = PAGE_SIZE;
 const size_t RUST_CONST_HELPER_GENLMSG_DEFAULT_SIZE = GENLMSG_DEFAULT_SIZE;
+const unsigned long long RUST_CONST_HELPER_SZ_4G = SZ_4G;
 const gfp_t RUST_CONST_HELPER_GFP_ATOMIC = GFP_ATOMIC;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL = GFP_KERNEL;
 const gfp_t RUST_CONST_HELPER_GFP_KERNEL_ACCOUNT = GFP_KERNEL_ACCOUNT;
diff --git a/rust/kernel/sizes.rs b/rust/kernel/sizes.rs
index 521b2b38bfe77..0acc8733d2368 100644
--- a/rust/kernel/sizes.rs
+++ b/rust/kernel/sizes.rs
@@ -132,3 +132,15 @@ impl SizeConstants for $first {
 }
 
 define_sizes!(u32, u64, usize);
+
+/// Large size constants (≥ 4 GiB).
+///
+/// Only implemented for [`u64`].
+pub trait LargeSizeConstants {
+    /// `0x1_0000_0000`.
+    const SZ_4G: Self;
+}
+
+impl LargeSizeConstants for u64 {
+    const SZ_4G: Self = bindings::SZ_4G;
+}

-- 
2.43.0



