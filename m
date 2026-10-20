Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F1FD60A3802
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:25:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YD9ZRw1e
Received: by kanga.kvack.org (Postfix)
	id 06FE86B0139; Tue, 20 Oct 2026 04:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020806B013A; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E517E6B013B; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B95F16B0139
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4083616095D
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
X-FDA: 85342321260.11.7DEDC31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2BB8018000B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YD9ZRw1e;
	spf=pass (imf06.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484748;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jPxyRVxUkD8Td+9QwNyvaWaSg+CRoePkY9b5UHxne8c=;
	b=l29fW1ivzHYT9TKxFsUuzbEG3x3XBKZP/7tjWReavTQT6Qj5DDOxxESeT4YhNKWnldIvAb
	JG1LnA6tJFT/SG3+jzsrtbHVzuustzuJEpjSCTFnpO91ivXCS2YGlLnahO9cJkYFyXWy/8
	3/l6aFjqx9JLNee+a2pMvWcC0TRwQdA=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484748;
	b=EUDEw08hocgVPo41DJZLw5FatiRI63YYBu9h4HLnVLwGvSKULqZXjJpKNMNPibV7JYMhds
	IygpgK5JY3iLI7HCACshmOVAEmL9/08G23xsG3igb4oZP4mCas9gnaVkJ9ejg1G3y58+Uy
	zTVJ/RS5eSRcCGuvB+XP+j8OjiHodas=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YD9ZRw1e;
	spf=pass (imf06.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B65AC60DA4;
	Tue, 20 Oct 2026 08:25:47 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484747;
	b=hTIJtvSRH2k49nX6d+50Tro4sahNt4ZbWf/U/WUggzaqM6eD/WrJbIqTsr9vKGA5gB86
	 JMnRj8E4zDXskzRIBAOVR4xCZwv6m9g8PtGEkkXRwxU8kmfwmNr2NSKjctk3K0dk+bSfb
	 oneP7KxJACLm0g2tujFga0BY8sdiX/WlNSyAASor+bJh8nORDjrWH0H1RKCFIb33y8lV9
	 JBwLS6blfUWhhq7Zqn3u1+wPrsmsB6f1/pWZeX8thokE3l3gK6UBFANVhdwCT4+tmwJlH
	 3luiq/l+dwRnv63qjV0P5QRgIffiSqoTHU5R69iuK32Hxu9F8eCos9JDYup6XYTrA7w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484747;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=jPxyRVxUkD8Td+9QwNyvaWaSg+CRoePkY9b5UHxne8c=;
	b=dKatv3KDTnujupP71/V0C99ssfgpTxF3JbVdauQpPBOCNMxRkSp3Pbt3qBjeQm6yvvGT
	 lHA3j7u3ANXBzZR4KX9t/jPpTBV+1ag/fZMDTclTVoTlUQbIyLKn9ue4BzPMhJ2/LReja
	 olOBfiToR31xqTE5AEaDWKlPLfyT5vcpynDqJLZyo5hg7EevYW7FxAd8l7+Xn0Ei6Qn1Z
	 PQS25D7kLu7OtYWuEXT+dECQHOITTR0GsexOx+ogm2GwefJWLK4IZ/w/nIkHPSB09gUlr
	 sza3PUaBUO98XoeZ/sN4a7mqDEFg7DY7RQlKpKUpj/Uml9tkVWn6r7Zz2LTPkUuF0HA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4562E1F000C7;
	Tue, 20 Oct 2026 08:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484747;
	bh=jPxyRVxUkD8Td+9QwNyvaWaSg+CRoePkY9b5UHxne8c=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=YD9ZRw1edhudz76MTNsrjlEf4hfWQ7z+8WgT/xIwtiZ1qTEz8z5rMMEmhE7vVzxcy
	 rQcNJd8kE9JVl+3MUoQJHpZXi8W7RkRL43FRMc+QRp35wvYeQuQfrqQe9EwMc37AJn
	 Mb2wmSa49WKkaY5OY01Cw5Y0F0QI+URCdsQLbIrADAkrKb5agEVOpjD+87zqtUIN/F
	 6yieJWhW8QwcVg6IG3CCP2oDVugkrQXKr/wBX7lf5pjfopRhRv+WYPgJXCN7Nm3RY/
	 wJrChpQCxPs+mgXTuTrU0Kg3ZljzjCGlyk+fJT1VSX/zzKTU8BL6Xl4fyye/NMU2Ri
	 pQ8AeWx1pYJlA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id AF794430D7;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:20 +0800
Subject: [PATCH v4 03/11] rust: sync: arc: relax `ForeignOwnable` for
 `Arc<T>`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-3-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=1389;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=E65clxOu/qjNbqNDrRBBfaWHB/W/gvw7JStoVkgnAT4=;
 b=9OwCtSZSA8ESXlncgmFEdWkXp304HK2DH1QRwr3SpIWHFMg8uWBiTUZC5Hf5v+z/VV9+TF7dw
 4om5xcnMwqkBO3IoqCJ1E6WR15C8MP4tWxyhVdQb1+sbDG3gpEGztpT
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2BB8018000B
X-Stat-Signature: iwuns5n781npz78ez9htdw4zyswz6w7m
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792484747-197276
X-HE-Meta: U2FsdGVkX1+5vnVY8SzH2AgxVx9YPzB+ABv9LlXYTXhnoiO1ZrtqzsSYKcS/+EPwBsX9iFjJp9a4IXSAfghQHe/e8o396J3+HKwbAXJcNvtDkqoKR6P4Y1QTkeaa94TzIrOxCW68tyHjkv69lP4kHJUNCdZ+jkYRh34GnEY+ceLlwVD31/ZcGXMTb1Gweq0Sqru/f77Uk3+gQAB2a7nkuJByHqd+p0/kP6XcfQag6JSOuW68v1A/AdvDHUXhYHdPtM8QdCX71eLJ3m9UTNGlVhr1RsPeK6t20Rh029MVo7L2wOgHYd+m4iHOAeoevaHGE8jOebKWdP9zdqbbaQxJxWnBCauUzN9Jy97i/AY0UJzb1tGGYQD8eDj99DFz/8VWMA/NKrv2Ii7YR51SB98+UuLiG/TbZ/lX8y+q87KtTU9+VS/9/GYRB8FWs8PGzQ3tl6LsNYsn2E0f3ipzLEPA/IW1w9W//lhCm6HuUbOGI5hqZBF/8JIp/e89E6dTVXQDqRxf6w0VHlHqOTBjnnUnHlvoAmPD1o+fXUm4u73qrUdrqvx4O669Vv8hwsBOo9TEyYyJvoVEio8UOmG0vwhsd8jJK0gm91oDlX0uNPli3nWMZbKyeCLEzAmCTFFjX13QPe3thwDdhaRl7nl+WJHRHXHJNYECksGR3ASSXDhkKzxFM1OWj4SQZ4inWt91NPU80oMa1Xn23v6RfG8rzgZZ1qbkHr4+U2TQ3KUeYdAYhx42aSh1J9Xduc62cK1p1EZ/UtKphuTsX9ddhyycHYZRBxFrzjQvthQSaAry0y3ic87Cq9vQaKTXF6Scn1dr5nqwHvc8ClDopWKGo8XOjCxOmfWQRExwBykEZaFlyOLJgJFq+hTQ40srIPMnCKuA4AaD1ankzpWOm5aPFaljf8tLjheB+c/hZNBNo4mNlRz4e/ZSunnCDd8YCZOKK4XamYXKculph0y+aHA4ju3bLHF
 MjbV1op1
 6cCFGCPnRAH4QXoBM+uYFMvO+RnHFnKIzHJQvP5DggH9F/rShfgl8DhcVsPbpWQ3RbGn5Eqtm5KoibjKbsSp9hm6NQvMfxUtIuuNJXPN4saxZFL/bwdBD6s7TQO4MI0gIxaFFXochZ2UEPLzBlxA4FLyrwi9FJRdnAilKyBsfhEM/qP/uYxK88D0mSCQlAt9zkVe7CsuJtW5gh68mRuqANzuHuSpPPEbHK8/RAGPbx+cWd/zmh+WPOd5pxWzIh5C6hlXdtscO2k2FpQwd5d0isGBX+JQXhpI2qFYbWrJ+rj+8ANSqq+ld6y8fdVw+WEiRbqYBDrKOKAoxMOlN3lPIZ/h6KqHPhadwFS9D6lDxdPLkm/XvJj0ATKjHg/gIjgteM3Ol0TrWse/kn3Pccz6l/1tMfXLC8Fmd6jrCqabflp/Zsnhq8M0MYw5B1ZTagLCXiXFOcW1/rnda382+S0LpwXD1cbCTQNyouoqFq2S7tz0naCja11+iWQsKNsrl7j6PqRVaR/KJVmrqu8bT3HzLLFRBQrJVG98OsBxzEq0uaMjSQynH2SVCOPk4Xw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Alvin Sun <alvin.sun@linux.dev>

Drop the `'static` bound so that refcounted values borrowing from a
driver registration scope can be foreign-owned by the XArray
abstraction.

Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 rust/kernel/sync/arc.rs | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/sync/arc.rs b/rust/kernel/sync/arc.rs
index 8ae0fe6f19ec0..9b582a815f888 100644
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



