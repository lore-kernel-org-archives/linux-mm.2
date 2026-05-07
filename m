Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC012CD3445
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 23:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 194086B00E4; Thu,  7 May 2026 19:32:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13EB16B00E6; Thu,  7 May 2026 19:32:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 054396B00E7; Thu,  7 May 2026 19:32:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E7FE16B00E4
	for <linux-mm@kvack.org>; Thu,  7 May 2026 19:32:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8168716069B
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:32:57 +0000 (UTC)
X-FDA: 84742226394.29.4598739
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7FA90C0007
	for <linux-mm@kvack.org>; Thu,  7 May 2026 23:32:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Mo9N+WCi;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf28.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778196775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0UlbuoJOpWJO9LmwFxWlvdYkZE8HSkEeJJElxb5VGTI=;
	b=sIslJquUuacKNFSkT1TdHHioyvEU1a5YO632+KGfUVh1ZWTBTIJXwg+mmkPqkyTWD+T1SN
	mdQhKFpXBCwIMDxMd3dlaOXCBrK5Y8CSmMSmD/ggqhbGIJumLOcG4RWqGUEWwFylJebNFs
	fnPEWgDNmDlRjK1uCJCyVZzIVDd9iJc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1778196775; a=rsa-sha256;
	cv=pass;
	b=s7DUC6ro/oNk3ctDuOT4tsKCJSE9t/Wa0ztoD4PI7LEyx/UkU9VoLqeIzT1L1hbDmN6rKl
	9EPo8xTBKfqdzQzc0Q47K5sBoZkZBjwXj5Aa5xmvljDtAZe1WE93tQPk9SQcXp7a5FrJiQ
	C4wnBwjomiEoUmsjXe/1AWeDFf04pJ4=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=Mo9N+WCi;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1");
	spf=pass (imf28.hostedemail.com: domain of deborah.brouwer@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=deborah.brouwer@collabora.com
ARC-Seal: i=1; a=rsa-sha256; t=1778196765; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=WvVL8phvZR0VPyplkOLu1nEXMtdUkgnEhpQPjC5spVZn/6nDERtv48C1rvhvyqlRd3+EzGt0KSbrWQpXxuso/SWzRAlFPpgkY/ZiNNnbbg//TJjSeBi6NLvaV7aYmMy+nqqrEqYmztEsQODGeVoxRm5MG9RydjCTh5hd5YMirAY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1778196765; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=0UlbuoJOpWJO9LmwFxWlvdYkZE8HSkEeJJElxb5VGTI=; 
	b=UV9nwN9GM94DEbqxsbxCaCZl74HAqDElQ+ehxtLRy7KEo4oqhKndGVsPQVfBL6PBSeMJZP/+VaPBSoO69mSSuMeX3b4TM7RJ8TOKkMj4IYmQY3jq1S5q2SI0jYi78FMQEmikDmAoX+rYzSYSKavlZJKjtgFkuVnMo84sQofUOsc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=deborah.brouwer@collabora.com;
	dmarc=pass header.from=<deborah.brouwer@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1778196765;
	s=zohomail; d=collabora.com; i=deborah.brouwer@collabora.com;
	h=From:From:Date:Date:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Message-Id:References:In-Reply-To:To:To:Cc:Cc:Reply-To;
	bh=0UlbuoJOpWJO9LmwFxWlvdYkZE8HSkEeJJElxb5VGTI=;
	b=Mo9N+WCiIoOjoBPFky7Izz246sxFrA8lQrxNvNENPIUNntltUV4IgZD9mkbI+CWH
	nvNQE3y+KEB37MV9CARgm1O5ro/WquMFlIfpJ0xrW2AwsCbvd2DkljM/vf/tLpDxYXG
	HkLqN8KTmmsgYGOvZnGV441xRbgVpJfHaNgO7N+U=
Received: by mx.zohomail.com with SMTPS id 1778196764054628.3617629136472;
	Thu, 7 May 2026 16:32:44 -0700 (PDT)
From: Deborah Brouwer <deborah.brouwer@collabora.com>
Date: Thu, 07 May 2026 16:32:39 -0700
Subject: [PATCH 1/7] mm: rust: add pgprot_noncached helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260507-tyr-mmap-v1-1-eec048a23c25@collabora.com>
References: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
In-Reply-To: <20260507-tyr-mmap-v1-0-eec048a23c25@collabora.com>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Daniel Almeida <daniel.almeida@collabora.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 boris.brezillon@collabora.com, beata.michalska@arm.com, lyude@redhat.com, 
 acourbot@nvidia.com, work@onurozkan.dev, alvin.sun@linux.dev, 
 Laura Nao <laura.nao@collabora.com>, 
 Deborah Brouwer <deborah.brouwer@collabora.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1098;
 i=deborah.brouwer@collabora.com; h=from:subject:message-id;
 bh=+mpm0JxqkEncuLxmzYLQSpzrEq2zrX8fexEElroeW4A=;
 b=owGbwMvMwCVWuULzOU9c7WvG02pJDJl/FSW9vF/HnN1WZlhpk7f97HIBMxevOFbuL0JvXTe1H
 Dkbef94RykLgxgXg6yYIstZe6Me8ar3Rrrz/zfDzGFlAhnCwMUpABP55MLwz85R6pV83PpVbp0W
 T5vurtpksyJEVq6Be/EjTctmm9llQYwM6z1lFy3JOfMiPa/6VfSZLyc6pI32fr664IHvvpkOu2W
 r2AA=
X-Developer-Key: i=deborah.brouwer@collabora.com; a=openpgp;
 fpr=CD3F328C177AEF322D9FFF8379A829E70C5E7DEB
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7FA90C0007
X-Stat-Signature: 1htbdueshn6a4njzewsbcyypxj1nnxuz
X-Rspam-User: 
X-HE-Tag: 1778196775-92158
X-HE-Meta: U2FsdGVkX1+fjT3I6yLiBJy88bCjAmm9pMQ30Gt5ucX6MPWaTLxgE9D25DnahmL8V57+W32NsJzadO0jTa0kV66iJjKyg+W2TH+5bUdra4a6K1tjU0sfuaiLWp21/PRbJpSkKEfAENzUdD87yKZEpjZW9YBp4tHsr/Nc3gj4CTXeOxvh+CZSNEjwPS5S0ZWiMgN4UB7iftyWBqlg9NZzTp8v8r3gimwwJuXJTVfhpx5GHbmk7RFuCijXlIBP3o+4Its8dBAaM63qtN073k4Mwn7lMapKmg2g+bT9mtV2jMuTszFj9K56UqVxxlJku5dzsXBbSQSrFq5eViNaaDynEBmy/XjKebhtyXz6vV3YT9aJVZ4Fs3suEbo4sl+UNAKSkodNC2fvWwsof1VHWjc9dCbpDLhTM67eFL0TdH4KRdncSOClrh0gARM36Tzkz72bVr6HSPklNBMiz62z23KzLHkYGLdW2GIG8iOaV9A/KrK6QnKpZEtTHbr7lxPnmz5VtoFddwtpALiYY7Lx1iH4zXhMLNllZptBiY6cwjAz/4zzxc/6PhIJ+dbggK7iIYk1nY3xAhK9LyOPAySP8PpuC0YwcFnBfII2wH7IsTgx7SdnzwDRnaohAEOOiniJRAVK9LWAGiE1rrlyJ2DjwqZSQIfhJDBP3IbxBc1JdeitKZ12EfZVZFl1dRswI2IrvX5ARM/k+KUUNV+KlpDirU4VI3p4M4FXYnXYclUXlUxhMr5J12PxVpXAyWR+VOrjdSBU7APyiaselauNJHoJMR7bPTK8wsc5xa6l5NPwUQS1bcwgR+GFT7dhLysWrq2d1RW9aexI99XlzFhBd/NTndoS+L+ggWLstfgPas7kVnyXvu+pBoopYHllzV0swc2u7BEHa+qBywVSH+XfE3mvpv9Dm+K+cRQcpkBtHeaTAn5e7trai2Xqty0F0rPd9v7xI5dLnKy7+zL7TSs6uORdybR
 9reYktQx
 RdGMhIi+AI9liFLURbKv4l+m3ozD1TG1PQY9EtU/E3DGr6RCXVXA1WETyiEjoJictfo70S5mUco84lLhdMrcanNScArOS0raU6klbHRkIIUysUuz7HtucG0QgeALLkYTcAhracbo9BXeVO2q6gQDLUQv4nZ7+dRdp+TSG+8M+EuYchEZ72ZhPZkxrrVioPzcgZxaf0skjwDu4Aq4gwfED6uWPcJBZqeIL0vq1U0Jk/uTNpGtshX7TtLgAmriEXUo/+fYIgqeoWM3SkGw4X+SrFkHZDVP4bwYNVtyIZw1jFpEq9A6YXXp1PpK+46uGbVycBS9Thc1Rkkf+5HrB0AmKXqAfeP03rRDlKMqAU51xN7ewjn1+iHv/+U7PUDlSaS1ANkfYLV38990ukkwwGZmTniQe/+t+SFw3PnbhZP7P7sEUBJ0R9/BH9/qtpxGHPSRf44I1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Daniel Almeida <daniel.almeida@collabora.com>

Expose pgprot_noncached() to Rust code through a small helper wrapper.

Rust drivers that insert raw PFN mappings into userspace MMIO VMAs need
to derive an appropriate non-cached pgprot before calling helpers such
as vmf_insert_pfn_prot(). pgprot_noncached() is currently inaccessible
from Rust because it is provided through C helpers/macros rather than a
normal exported symbol.

Add a Rust helper wrapper so Rust MMIO mmap paths can construct
non-cached page protections for device mappings.

Signed-off-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Deborah Brouwer <deborah.brouwer@collabora.com>
---
 rust/helpers/mm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/rust/helpers/mm.c b/rust/helpers/mm.c
index b5540997bd20..22194d3196d2 100644
--- a/rust/helpers/mm.c
+++ b/rust/helpers/mm.c
@@ -48,3 +48,8 @@ __rust_helper void rust_helper_vma_end_read(struct vm_area_struct *vma)
 {
 	vma_end_read(vma);
 }
+
+__rust_helper pgprot_t rust_helper_pgprot_noncached(pgprot_t prot)
+{
+	return pgprot_noncached(prot);
+}

-- 
2.53.0


