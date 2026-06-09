Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23AA5CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26E8C6B0005; Tue,  9 Jun 2026 15:10:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F276B0088; Tue,  9 Jun 2026 15:10:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E5D6B008A; Tue,  9 Jun 2026 15:10:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F16996B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:10:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7E67391423
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:25 +0000 (UTC)
X-FDA: 84861315210.01.310E5A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADE161A0009
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4EdEHZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHY5maGdy9Y0fuMpxRd+GJYueXrmulzdgPUuxeFdpc4=;
	b=rM7jJ7Y9sbnK0ym5rcWL3WEl7FejVdFr/t9U1u2BON3czF3vexBpUWSdlieZWy8rSYnJqG
	uGPuAPBh5meugu54OEt+37PeaZmYjSoBQ2hAO2MI8yrrmNgvMfIc+f+KGutuiGDD26y/Bf
	IFMitpqFahkxLVgufupTMux9J1uzyMs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4EdEHZ+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032223;
	b=Hkz9A5J4rmDEel3JO9NrioV+GUhAwiGHRCeiq50sTsu/7g567YqpcGNhanJN7aSSKn1wf9
	dTnjB/3QkpJzz6dlSMyE88ozCIKpRvOHDNFGOa6KD2pXmnk6n4zkcg68cobaqP6kBiSpFQ
	sSkejYRHbCCtfJA2WexESgS2ZylP/0I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB9554059D;
	Tue,  9 Jun 2026 19:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C511F00893;
	Tue,  9 Jun 2026 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032222;
	bh=iHY5maGdy9Y0fuMpxRd+GJYueXrmulzdgPUuxeFdpc4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I4EdEHZ+4mOmI52HAVmdSd2wciDtFR0/Q+5iTwm0ly5YvhTwazYPxYmIXCZDfXVgG
	 /yWbJXOrQ8VVEfrF56ldHexNv1vKEoGR/BDVNXFAoRcdUFs0hIg33NJWhSorfpLJhj
	 KiHE791tF/dKvrwu49a0YvcEPMDV0g1LLZ69Rgy4nxvZzFtmKsH/BG/5DxmOk8zyjL
	 YtlEV63v70Nv13rR2eBVB5qP8EKyqc9II4cD/gxONQFburypTp7oMl+KJx/nBgyLoP
	 Gcpx/6A/AnoCjUyYM4QxsG50NUdBe46PL8in5Olq8ABlsP/rKX+6L//CUhJwFeu0rI
	 k4QpjPTh30YVg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:22 +0200
Subject: [PATCH v2 43/83] block: rust: add `GenDisk::queue_data`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-43-82c7404542e2@kernel.org>
References: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
In-Reply-To: <20260609-rnull-v6-19-rc5-send-v2-0-82c7404542e2@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Alice Ryhl <aliceryhl@google.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Benno Lossin <lossin@kernel.org>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Boqun Feng <boqun@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Gary Guo <gary@garyguo.net>, 
 Jens Axboe <axboe@kernel.dk>, John Stultz <jstultz@google.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Miguel Ojeda <ojeda@kernel.org>, Stephen Boyd <sboyd@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 rust-for-linux@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1051; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=QdUIpX955IjWtpvoketZafjzxxc6bEWigg7uBvUHVaM=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTbpS7sC8gUW2Adx4HtZ/fpiNOjSfvNGjo6B
 NBvkfxPGy6JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk2wAKCRD6UCkIqsW9
 0GkKD/4jKQPzH7UvTzlymlTkzO6nFr0uD+r+lxJMwBCVa3UJ7O/Hiw74mJ5raWq/ELYiqGwZ17q
 BK1XKroXvE7lo3/W2fjw41bqrmg1v56WWQQfNlCe/w5rXtisEs7WSUsxgwCTsH8MlMbBxAYiVZG
 BIgAp9fMcFefidQZ1rioOGGQK7fWOKhtfN5V26APj4FSH2klG8pNPYv8Qwnn1QRljsT6htLvVtA
 8agBETAJEBn2/gcReU6RDaUgyv5WTdYOjApi8mzoW0qVVEbCIpAAAAbKOQS2rWMdXdg9kq5mYnG
 Tw2PhohLdqYMM8qX1sSrGUawgIxfRckb+2DrR21SUtQ1lCAu64PxoOsK1xd79HwdUVxCeO4FJcv
 uby53gHiQsCDK5U8guolyHcVWzSBlfgq21+1KxTxw+IlDlBA3knAIa5qrr9P3+5XI6mugMLJtyX
 qtx1NZcFEUEgzSOv8x8/9oKtpIIaV5eiaMsrd2jP9evv3IeFMKt6Tfd9297ONwbX8A6l5J+WgHB
 FDG2ITMtxPEO99CIBhv3hFdzJeDlUZfp8VC5npQDoZrc4UyRyEVrzgE/1AWgs+JCqqZw2PPQdgO
 6KXUT/c+OsYDx+LwGjkGzaUQk9zkDIJyJQMTzczdk2TAJAZyLPhBaQec/R0MrXSL/IxGvyOBlzr
 Le8kjM8gfkCjTvQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ADE161A0009
X-Stat-Signature: b6kuzofy6yrnum8wsi31p89wtaig5h8z
X-Rspam-User: 
X-HE-Tag: 1781032223-518637
X-HE-Meta: U2FsdGVkX1+J0SeMV2LyVJxaUE44x+/jBkCyQX5LrwjNbXnokfllfg72veWzFc1+GDspMi347vk09by/IoGW2qiGigflkvYw8oCdYQrXzTa7Mgy49W4/7kadb2824SkgDgEXR+hMeeMg/lN3Oov9kodOblR7FuPpRov6ited/9Eg81X7amko35LeCPc4T+lsqy8zWiXqULkIApGQYQXL2Gx03BcI/hGr8qMOMW0gymQet8m9cWxcFOvUtPkUWOtSkFrVJDQyckS4zS3aW2IbAsDRJhSN6GuOerFcYnKnlllLdkqupTzBSfotIe9BY6vUqwjiCflN12ZciH4QO4AgrM4piPuFHpcDylxcrMTM9GKLtpvX3XRabJKuIYwBSknG0Y7qqpn0zZ7bdl8fL2P9SR6nRnMvz13hJgBfCwAlcB/W1LAe8h4lynEiBYcgX1AvfuLsp9ETej+NSGwPU5FJTdGXG9ADlq6pJTU+8b9VcOyQFHNFWwX9z/RjY6/z0yPf/5yTxufL9/MjRqwE+3cefDQnA6oWDQHhAxb3QdKTtansNAeUwLRU5qWZEXnSf7XC0qIPLxTRjfL1ru+jvkAZp7tuUKqnnQNGP1CLLSN9jhqqltt1kOGbeJOg3YjJqeaE+G9xXhy1tP3Rx0UQUN2CCfky0jWDKS+6DXP0L7HS3ObFFRk+ayvLl+lv/Q3rHzea62OQCSfzJL37Asgb9jCOvRFhrWcMRRASxiHmFzry/PfHqKWjykRE5+Fd3ar+BU8Vin6s2o1PRuAAGHpQRgS3JYiYTeM1qRKJG2gkc4Wh6AQeXSpuGOrL0hPbkzp6tyiCnpQJFctjpQDVqkxeMa4Jcq+FFS7jpVzmfdrhyA5R04ibSEQ8Io8hqF8xFPeOtqucC+THEtceAImsl+OCv7sG+5ZY686UVsRfw14y/3mXwDpzus/r5c1mAensH+6vxC0LHw6Hj2RF2y6/mU3cE3J
 5P7gARH2
 /VH1ozljZPB/ysKornBbV5QWPEqV9ybJXF4w3DyozxFeR/Yf1aQIv2aL/Z/t+Cw76CYsq6UTZznQ5cRkTXRPI2yvfKkMUZFi15XjPQ5c0LHjpRfW25obwYXP+8ESn0g5ubs82OeKbwNGPl2qRtATAUbrySmWgSK5uhDar+ESVnOTn9WyBZYdL9PAz1Zrx3akvVRsFvbiNNjfG460Y41FiEqU05lm8bn/0du6/L7IHhNmjsNMuVvR4pUvV/OpwqGTco3Qe9hd9NSN9Y57/5Td5YMnrM/AHswATmYnD00mFtuJK8j/Gorbh+0cOwuazt+RuViox109RV1xpF/obGqzA+0QKrqhilf5BmG0BXz21m16zHW5aeX3A8W7rdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to borrow the private queue data of the queue a `GenDisk` is
associated with.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 6ba8d88f63a9..49ce5ac4774d 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -260,6 +260,12 @@ pub fn queue(&self) -> &RequestQueue<T> {
         // SAFETY: By type invariant, self is a valid gendisk.
         unsafe { RequestQueue::from_raw((*self.gendisk).queue) }
     }
+
+    /// Get the queue data associated with this [`GenDisk`].
+    pub fn queue_data(&self) -> <T::QueueData as ForeignOwnable>::Borrowed<'_> {
+        // SAFETY: By type invariant, self is a valid gendisk.
+        unsafe { T::QueueData::borrow((*(*self.gendisk).queue).queuedata) }
+    }
 }
 
 // SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a

-- 
2.51.2



