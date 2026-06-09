Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE1BCD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:13:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F5B6B00D1; Tue,  9 Jun 2026 15:13:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7966B00D2; Tue,  9 Jun 2026 15:13:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD556B00D3; Tue,  9 Jun 2026 15:13:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE5E6B00D1
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:13:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BA4A940752
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:41 +0000 (UTC)
X-FDA: 84861323442.10.2646773
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0E5B74000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:13:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eV4PtLBl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UznLXv+yDoXlv0q3+7o1af2gG6KRdEpR67pAYXvOmSw=;
	b=5uJ99CCGSnvnHq96ewtseenK8OKg8zw6TJoe8+rSyDCgduK/N4kgCzbr9cgePM8ILZWfVw
	qGr4JNhO9qz4CreUwP99x8HPj/XpMt86vvmRVFUgI4HNS7hEkcAfU6UpzmYDkZtxtCpG0+
	gEBq2u8b5O0eDo8WQ50UHLUh0NgXI5A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eV4PtLBl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032420;
	b=1Guon5iDqwAYXi5tfjZiF0eTt0bJ5tA6TDHtgWEzcm7JfxaHaReDhxadXfh+MojgJbGHFs
	CztOZyrL4HNNVeUSOJ2kKwJo8X4LX7Ibe16dHRH+NX55qLkfFfiL4EL3tVptAdLHq2ftFn
	8KxAlPf3+ad5B3A63a4YEHrdQ+/wHZI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E9CF602CA;
	Tue,  9 Jun 2026 19:13:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16D241F00898;
	Tue,  9 Jun 2026 19:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032419;
	bh=UznLXv+yDoXlv0q3+7o1af2gG6KRdEpR67pAYXvOmSw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=eV4PtLBlcmIv0Rs9zY+RH0AQ1KpL1zwypAt5Izt++/RuDL53D/zlqHzbUx3BjTbH4
	 Rwez+JUusnq6LFb1LdHpyHaDhTmIrSSTVvGikutOfjjEzfOP1dPerlzCtMPtBTmxRA
	 Evy2QrFrR7hKO3WPo3IdfJjp8PV6lS6LVgHS3ujbFx5Tpqqt0sALERzM3pGrQdzjrt
	 6oprQDgRaavUxEPY1tVPAPVMc9G6C/+9oeXr8FKTKiqFtmLhRESG55UtwjXTXgvJcd
	 JmgcrTXETRxfnZpM7qU2qItMwIT2F3KGiQjv+5mfAIl6l+pzqY6LcC2cpBEXwgjOmZ
	 SsxmY8pzAd0VA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:03 +0200
Subject: [PATCH v2 24/83] block: rust: add `NoDefaultScheduler` flag for
 `TagSet`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-24-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1046; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=QkTc+Yc4D89ONNykWVRFoz8tGJV4akO/AW521uoK1/4=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTK0UzZL4I383mSkVK2Rk14L1Tqwr6Iq1PY8
 mxrWR8hc9yJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihkygAKCRD6UCkIqsW9
 0KW1D/4zp50ASbhhUmvVy8hfrATcAApjnZ/OtWhyYLIBc0YBryID6W/1ii1xw60AQJCUxU6QH1U
 u+AKjeUPAVylMVse+ivWCG1wwLfFXBir86ERXb7sYtoT6e4ZrX5+2FgtU7If/0jW6PeDE+snU1M
 /Q3XLlMSNDjqNWE+RNDRg8Q+CsI0dJZthUz052XvCHTCV2XU66tblMnZg6Rdd2Gsx4z5hFxQ6qh
 sCjRq21uw0CVTV9/NNaC3r9WOH5c2kfq9l/yurslB3I712ZQjr/Ou9YLI8Dwm78of+YmaKS1/8x
 HF3L9PKpielTT/sp1K1nYGTGv0tIjEQk/SKwJDgGI87P08y5Npo0vBZDcXGAZKqlHwvrcDgXtQl
 Y8Ulc62/bstRDtqz3S6t1471dWYgZf268gPoK/il2sEwIg3xq7x7MC03Czd6WV1yK/UKJ5DbFlo
 Xf/tWC1jUbUQCQOXOqRRDmCHzGjI8lsdfvEvNglhey478SygvWqeshKVPz4KEpVTP2MLPhZrmPD
 twIUqTwCDS3AcW0gXF7i/Ceu/Xq3rPxCc3oO+xVYGzG2ysuJfEzfiVUP5GpgHzd8NfxkZPd/2o3
 22JPrke71+Ss9WHskK1ZzucpQX52QsE0xgCunb6v9fbaTVVxZjVKIQTOameD2U0M9Z9xoxG9XC5
 1zlZ9whoVdLOkiQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0E5B74000B
X-Stat-Signature: 6cadd7kn4eq5qizjt1ngsb54dgnmbofd
X-HE-Tag: 1781032419-270563
X-HE-Meta: U2FsdGVkX1+f6aXuAbv9vcKSbJQgw6jOLaMHjM4YoqSES3ylCDSeLEQ5+KMZozo5th5Rw63zfxxqFkFhd53zqrU9xY5Qtz/8GQcsdWMRa4TdeNXMyZXV/SD+JT0qW78V+h/ZYgp8E7eMQbnDUG0fOFV/AydQ1gsFRBx9W2IbCJkLrYIcM/cCLDWFtkDp/gtUALX2cpf/vB2W3UTYdwBOFAgN6FCKk1j5yvIIVrd3EjCHpaT+U7W14qbGnTiWzQltCNpOz18/iZRS6+ZzEgMx7z18mDIhxo02Iaq/0GW8Er3/81JyI6MaI6qMMH/aLzuLTcTtk+LKd1tYXoacEVL0jph+fH6o8e5FKaBvUP+wbekbVbsmHhqiROYxCmToA/N0GVqqgcYISKlKLkKwpp5QeCpWfYzn//sIiCrH3D7pPyl5PsqaSPeZSFCdSYW9g62CJzJV3k/v7islTkhMy4hlHfdz8cU0lkSBNQ1AmTWh+kzpc+QKFOo9Qwf61c/0a04nC6vJ6B7jYZy7fcXxCKSoPHAeYcgUwIkgFIPT2S09EJOoL6V9VqVFYUaXdxpnRYaRu/vMo2reNmWzDwhmUdurX40u3yZgGLcCOm3SJ66173c5UTWDSbMFOXWkV60/CA/v+mBw9BYkA+28y3yxJ8shBsigm+yVWPG0uOsONwiZb8tkDIsgaT20GXcEbEqMZFqh4uPkcT8B7/uvq93RXm4C2HDU+ALANG7No6/Jxg9a/kee8PmEL3ujCP4eiPCJ3x6CfhkHZ5NPsqzE8g+ePTlYi5bPmgI0swHPRr9O1sMEIf6lv7wjtg66OHVo2HtFwKi5Xg++saIG6J4IOHccudkWZG1HpSw/n3DmkL/rNcd25CRtkZzis3t/cW3VkpkzQpl743cNCETCgOdZDqwmqCzso2cnpBexG0pmqU0r6wqf9DeVWGVXv/LvvZxyD1D/NwG3jQqsKFWMEWdtwXJ5DU/
 uDLeyhYi
 AtnoQL7pJ/0m1lrFgKh0kz0rHjG+vQYHCC68aGSWBcsCiuadUrLHZfCSqVkKhxNGINX5XiBilzf+vuX8llqozr6HQlJLVkj8gN5CZOqJ7cf2317C/Z8suQTJUu4Rk95F5EvNnPGXd7Djf4BnzfZe+JrymrQxhv4yrq8kIfN5J2VfjtGEvvyjmqkjMrvYHELqzh8CewI/m0iDVZaUoTSGGbb653mMLHnuQ3Gfhch00+WnpAUupCB+llm98OflwOD6FxfjTrFzS9PwPLjGCL9npV6hGXguxSOLIwYtyEHjz5qIGvSHlS8j8NnXuC3z5OHiMCdMp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a flag that maps to the BLK_MQ_F_NO_SCHED_BY_DEFAULT. This flag selects
the 'none' scheduler during queue registration in case of a single hwq or
shared hwqs instead of 'mq-deadline'.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/tag_set/flags.rs | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/rust/kernel/block/mq/tag_set/flags.rs b/rust/kernel/block/mq/tag_set/flags.rs
index b7eaccd200a2..2561d7090c49 100644
--- a/rust/kernel/block/mq/tag_set/flags.rs
+++ b/rust/kernel/block/mq/tag_set/flags.rs
@@ -17,5 +17,9 @@ pub enum Flag {
         /// processing IO. When this flag is not set, IO is processed in atomic
         /// context. When this flag is set, IO is processed in process context.
         Blocking = bindings::BLK_MQ_F_BLOCKING,
+
+        /// Select 'none' during queue registration in case of a single hwq or shared
+        /// hwqs instead of 'mq-deadline'.
+        NoDefaultScheduler = bindings::BLK_MQ_F_NO_SCHED_BY_DEFAULT,
     }
 }

-- 
2.51.2



