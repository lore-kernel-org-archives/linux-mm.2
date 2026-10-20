Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12DD4606A320
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 08:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=aDQ4lOB4
Received: by kanga.kvack.org (Postfix)
	id 21E006B0148; Tue, 20 Oct 2026 04:25:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CEF06B0149; Tue, 20 Oct 2026 04:25:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BDFA6B014A; Tue, 20 Oct 2026 04:25:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D2F6E6B0148
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:25:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A8F514086B
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:54 +0000 (UTC)
X-FDA: 85342321428.14.9711454
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 490ED100006
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 08:25:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDQ4lOB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792484752;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eipZCh/aZVOWGyKk+tem6Pf9Se2oB9+JhA06IxGI1NU=;
	b=TDQaYwqGVgFdYO4fbEnPEc/G9lcvDLXxb2i1Fu+tdRASPVxj+2od6mFHrIYJuZ/aR8zBr1
	VPayOdOHfkjd9zmQYHn59HE70gd3h3QBs2io19Nc9ISfIVT1ywhyFJyzIbM5tny/ARfVcs
	UDlmOP6Ug3LxWgIV42LDYLU0NGR4UxE=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDQ4lOB4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+sunke.kylinos.cn@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+sunke.kylinos.cn@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792484752;
	b=U1C128j6QdusBLocLCGb5lFIGYx8FPGygWx+76g5stBFy/KB7q/niU0dR5O9WIAOZHviul
	fSL4uTTKent18zv9KDX6YhpDz1b4Kl5SRQRVgMcKuAKN9kB+GuIycW5m2sf7ZHIuX/XmVx
	/a+6lHjAaBug2VltfPPA9kAHtrdCp+w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C8024447AA;
	Tue, 20 Oct 2026 08:25:50 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792484750;
	b=RSuHTXSzWN0sQcP5o9TJj14ZeCGDKdl7WxeKqR9nT360e2n1X26qla3qblAWVkTfnjBF
	 AyrFjUNZrZF4CcRcHaXQ/ygUwgN5UEz7tLL4b39IQcq5MEKdbheF4cZGYBKVhdMazWn2M
	 zXDZrMvyaArLMHnyAuyDBKMugqfMUiDnGRDUGCFRZYRDPIfkjrM9Uh8JMsGn+U9UXGj6g
	 JX3+0MsEUoW23JPzBf7uL0sG1kv6c2B/iwqDIg1zeQa9u9He/Ev2Yvm1gls1PWg2MDl7i
	 3NCIUbkLglebXwr6s5Wrqc2/SM5HhCvjTpUpp3Z4XvhpVlQFH8fpXIHtpAoXMMs6CGg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792484750;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=eipZCh/aZVOWGyKk+tem6Pf9Se2oB9+JhA06IxGI1NU=;
	b=j4ireNCZnalx+Ak3deDrHdFV+ASseu5Mh6oIHNGMec9lhXL3dST04NWuQ9b4+bpmaoAw
	 Q3HH7R0iURJ6LmsQhEOVMQW8YmrCJRL+IkX1pHEbgSUF3gHQ5xnGVIQZb1zNL5An2XDus
	 +0WjcNEXRofRtmUyCknwG4lV162oSZSFgVex1lfmvtX6NRqCUk2EnrC3s0Ih8GRVCeklw
	 9ePyVy9N+5lbq6adkV0rFXOUuRzJuDJX0Z8Q96KnS8zXXOqWnaHESk1huCyX4aBnlmIJi
	 aSE8/OK0ZSu7Qo8nfMcDBtch3KYsWKBSQ0t7iNFnorci4dMmiIulZPYMlMkRq1+LQXQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7DE641F000C7;
	Tue, 20 Oct 2026 08:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792484750;
	bh=eipZCh/aZVOWGyKk+tem6Pf9Se2oB9+JhA06IxGI1NU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=aDQ4lOB4hjajqMG4r0KB58/c2bd0ffmQDsBuKIcBqqrz2a3xB2QsxjlRmz85Fifiu
	 tmYj1B8WBaseUZIn14EJW2vmDqXunJifI53uwj2Exk+t2s9SjxuWTq6mo9O9DPuZQV
	 BW58tEU00WZfkNWgghHwevjnZ1AJPaYfwFwSWIOiS4JO1Z+V2xfLHhl9CheUZgSLzC
	 /OLqQ7QeEnOmQkoUT7hBapXMmKXTLG4t1yUoT2lgu4llEIFrIjHr1mB7cg9mh1SmTv
	 XTcCBYZitlrjBT9sTcNdvIx5QXiFbCv/bxIhepprdPFpunMKE/gv7tY2tvcDQamSHG
	 fevkbnEBxxbwg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DF14F430F4;
	Tue, 20 Oct 2026 08:25:45 +0000 (UTC)
From: Ke Sun via B4 Relay <devnull+sunke.kylinos.cn@kernel.org>
Date: Tue, 20 Oct 2026 16:25:26 +0800
Subject: [PATCH v4 09/11] rust: device: expose the device DMA attribute
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261020-tyr-ioctls-v4-9-704de77da223@kylinos.cn>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792484721; l=1995;
 i=sunke@kylinos.cn; s=20260317; h=from:subject:message-id;
 bh=mEXxKt/y8TdcnvMGSXY8Zt74eqKKEsHMFWEDUBLN0a0=;
 b=rGNNKJ6DXMUQnJb0hmAg2jlqt22qnLX6QZ7JwuDJy+nw0lj1DqU61HmQ1QPLBKyQQAh3msXN9
 aWB1Ggq6SgIAzjWPDh4emO2EBENlEk9L3pzTJn9O96ZOU46+bf8S+dh
X-Developer-Key: i=sunke@kylinos.cn; a=ed25519;
 pk=CHcwQp8GSoj25V/L1ZWNSQjWp9eSIb0s9LKr0Nm3WuE=
X-Endpoint-Received: by B4 Relay for sunke@kylinos.cn/20260317 with
 auth_id=950
X-Original-From: Ke Sun <sunke@kylinos.cn>
Reply-To: sunke@kylinos.cn
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 490ED100006
X-Stat-Signature: 9qdwcio3marh9umxsdppa5a9r6me6p6g
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792484752-689922
X-HE-Meta: U2FsdGVkX1/vpPhcFQyEVWLWC27AQ0QvoizKmgomm8w9ob/1041EQy74vNWSfp35mGSHJJ2Bne9vAjxXuLHpUGm/W96xIQGE3hhAMH8py/vpXvIkyS/61h/FyJ7QiX5Qo2nH+ylI2B6o8F9yNFYljc3/Zd7B/wkHUfCLU91EGe/wITlp2DKVeIzQrrxdkXqm5l7LUpARrPzHYMgvWWESYieI/Pb2T1CLaAqodkRPQ+21/bIEdXeNRPc4TSK0smOcRa1OR5Yl4IlU/9zX/X4EzLzjqPQLdJ5FcnCOk7GpG3a6xOXeAfs+CKy7yUdLZrFtVd56h2BBlHGz4MLlt4UScGMgeQVeawdriUv10AeTTfv+KE9MIZOEgYb8wvj10G9+zvJ+iEBQ1lc5vZB1OrX/IJvvJFZNMQZOPpn7SGX3n0WglfBJv3eYkfaahaOal/WKHB1higQCAn0ztG89FjOxKxyu8dgzQ6PKKVuTyNFPdx7gBnOmlu8srlroC9w+YZtDz3iXMVZvTQjmrTzoSUJUpdizNc2XDTFxuTNMoZ2PcUWTijh7Ky1Lr+Co5TTkVVJsluEfssNdgHWCCJqunaAZ7IhK9uv6qtdeJcgQWAqbqajMxkoybXZqw6pWPclGFNcbOE3u8m8xzkwS0tBacEJKQBYnFDQd2HXJopvHsv/xZncR2JQgsX0iRjKmvKjd20g0c+pLnf+KEdcOw6aU0NEeLZy/X+H3yiGZ5aOvkuDDGxp/cfmBHPJ3FiGhtImu0QHOKQO9MP5EpB+P8uUj50b0WNJhOLP61qaTcUms0i8VeHdyXO2d4D5ih/GfX9j5t+Stpnw5CcBDWLY4/juZFFot4n43KR/TNTp+uymwWO0P4Pq3JRAX+IPkJ/O3094SNFHvh0khGAy8iD1M3V80DplR+cBkWLhtXRmumeclyILE39TpiJGXXL8ybYTXUInTU3HLBJExA6uNwAqRzKpX+JA
 aElTQMyn
 u/J2W+1soKheyh30HCJRh0ocHDEICWzVPRn70Jvr5zkTM1nGR+kp3MjsupzX2iWFoxgKATWCeOIyxi2pP7QxBY8BesiJ1ZMBGeifiFClBocmC4DHPBxlf1nmhgaSeW/G/fowb9zMlJZbyp7x6v2zzi49jcwA2PWfprN0MboSv9dDrujBuOC9gEPGVhodhEBmnHOuIaQzuQ3AK8SaprqU8qbvCTt40ALkWCktYyK8Ki00QkS/Onr8H2WzBTr0htGI5a1Lr2cw493qO8QvuvTUNlBPOskj8crQVonlIaCqg3e/yCNLwJqeBrrrllZz7HYWj6N0l1KTKPw1R1CYGqWIYIWn54EyblZgbu9uLBqGy/RMtm2S6+vrXVrOkGfryWVL5Q8LS2yxC+Zpxd2TjWdHrnZ1c1zqVYQKWiwFdmXTs6LDT38K++vvn+uMiVqrANAaaCYwbCNZrTY5eYQvWE+7IB/3aXwgC4m17GVV4e+LVZHT+7hgt0vqgJd0GhJnb41/LCHvY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Sami Tolvanen <samitolvanen@google.com>

A driver may need to know whether its device is DMA-coherent, but
rust/kernel exposes no accessor for the attribute today.

Add a transparent DmaAttr wrapper around device_get_dma_attr(), so all
three attribute values (unset, non-coherent, coherent) are covered, and
an is_coherent() accessor for the boolean case.

Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
[ Replace dma_coherent() with a DmaAttr wrapper covering all three
  attribute values. - Alvin ]
Co-developed-by: Alvin Sun <alvin.sun@linux.dev>
Signed-off-by: Alvin Sun <alvin.sun@linux.dev>
---
 rust/kernel/device.rs | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/rust/kernel/device.rs b/rust/kernel/device.rs
index 2291d85b6849e..d5bbebdf620df 100644
--- a/rust/kernel/device.rs
+++ b/rust/kernel/device.rs
@@ -260,6 +260,30 @@ pub unsafe fn drvdata_borrow<T>(&self) -> Pin<&T> {
     }
 }
 
+/// The DMA attribute of a device, as reported by firmware. A transparent
+/// wrapper around the kernel's `enum dev_dma_attr`, covering all its states.
+#[repr(transparent)]
+pub struct DmaAttr(bindings::dev_dma_attr);
+
+impl DmaAttr {
+    /// This wraps `device_get_dma_attr()` and only returns `true` for the
+    /// `DEV_DMA_COHERENT` attribute; no attribute or `DEV_DMA_NON_COHERENT` is non-coherent.
+    #[inline]
+    pub fn is_coherent(&self) -> bool {
+        self.0 == bindings::dev_dma_attr_DEV_DMA_COHERENT
+    }
+}
+
+impl Device<Bound> {
+    /// Returns the DMA attribute of the device as reported by firmware.
+    #[inline]
+    pub fn dma_attr(&self) -> DmaAttr {
+        // SAFETY: By the type invariants, `self.as_raw()` is a valid pointer
+        // to a `struct device`.
+        unsafe { DmaAttr(bindings::device_get_dma_attr(self.as_raw())) }
+    }
+}
+
 impl<Ctx: DeviceContext> Device<Ctx> {
     /// Obtain the raw `struct device *`.
     pub(crate) fn as_raw(&self) -> *mut bindings::device {

-- 
2.43.0



