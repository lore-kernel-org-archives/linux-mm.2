Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B99CD8CB2
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2529A6B012A; Tue,  9 Jun 2026 15:17:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A116B012C; Tue,  9 Jun 2026 15:17:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 167D66B012D; Tue,  9 Jun 2026 15:17:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02C336B012A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:17:48 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C5D971C150C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:47 +0000 (UTC)
X-FDA: 84861333774.05.D6F6AD6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id EA0A7A0018
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:17:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ef6/ao6J";
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhhiPZN9dpoZ4xyJGnlIqf2UGsG9mC/RzPjjGnQZ8J8=;
	b=eH8gp7T/9A54bfmRZeVvD3T+g9+CGv5ZJxn0d12zXKLobsjNMrcbkKQQEziUv2zoUUKtAu
	AJLOwJMKXbQg7zt5cTZnqnoqMQYzZLAm0gXwLmKGHbYC5kBUye9tO2WAkXEZQOMFeUWA8X
	WSigO4qYt6591OPr2ZoOOrUqU9jyKk4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032665;
	b=fCZ6ecj9PmrzSi++sHiBWy+9ejc7HUdqr1Qx+BM5Rhs4c8v7YNxOyigYw/U0DkdN/9zY81
	fNjJqeQ7B/ZXnSnSw4yzv6gScxnffsOYOC9m5VKC9zw2PHr1cU7GPnPcsg4m1CGbxtLhQi
	V2CSeoShOI1TA5qQrKudhHzqziLLE0w=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Ef6/ao6J";
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 698326024D;
	Tue,  9 Jun 2026 19:17:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C80781F00899;
	Tue,  9 Jun 2026 19:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032665;
	bh=yhhiPZN9dpoZ4xyJGnlIqf2UGsG9mC/RzPjjGnQZ8J8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Ef6/ao6J/2x2P2Q0Ul+w5+fI3fcDAeHUvj8joaMLKxAOVfCBVdPNot/Dls8xWkw8p
	 v+JkUcacIS0nQQkJ/g5mHuqZ6LTZavpNlH7Vq7SckIE2cKU70qtoKIoJSOBQsKxLX6
	 EsGwOEGpGG8IWiJH4xnBt5uAgSQDGPmrzm5TAyXHdJ3csKbYVR2KJyH8LD8yeOaKMB
	 eO/8GZHy0QdHegguUdWDWs0DcCD1TiXd+Mfco4iYtoI3Z/sXFZ+TpLtsba4Tbw3+7V
	 cjGLu+gU5awGymhS6I9SChG4YS4j6jqfuQPBSnfW4CFpyz81vaDHIOJ0LNmGEUMY9a
	 NQ0qZYbWXBpcw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:08:15 +0200
Subject: [PATCH v2 36/83] block: rust: implement `Sync` for `GenDisk`.
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-36-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1041; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=6A74Jcx8EHUn7wYuZ9sgvdf2Nhmf1F3bFtPD29rpOao=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGTVV4QA6fjC6s5QJaM+DuAAdyzosiERGRI2a
 nDPiCvCHpqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihk1QAKCRD6UCkIqsW9
 0ONmD/4z/u7pdgX5Wmx6bwNyWB7SgoBcZbYO0GePl/pxDjGYrsXBAKCaR+jIq7gru/rtRnshdS/
 S0P4TMMhpGCOhEBoc5NpThiIJBzW3N3u/kL4X9FOxsEs7jdy1tCyUPZrlxWzi5QVbSowIVdo/Mb
 WVTCRroH4sw+/02YE2fKpBLUhNyzc0GRG5Qu0DdFMrHxJRDsOK0EAFlRvzJ2gb4E16xFBJv8rFg
 0qEcfUc+f/5FKhLO8QHeS1qOSPQFC9/AANVaJr8MdbO1NY8BTnLXMf+yuyjr0VdynNTDtInejC5
 7+OsySI1f8LWISEwii89pTJ+aey3e9JTXUB44v56mcrUrAA5HwbIxe0QrEZePJWfllIIBUVXK8j
 SRmyAz1KO6c7xMEgiKtdNeB+3wpH44dMtkiOUIQKUD2Gbt6pJD2T3iBhMv8+hOJlZQHsEOj2LbV
 GXOrsB75EiLe9qmROJ3RTxojwEA/O3HyReIJhIveUu/5JJSEqTEmUkDMtoexgHbVnK2hD5UGOmM
 3TquGBebSsc0PsF7c4v/tR71vnCbhOIcchnkbWsyk3DDItKVKIToZQ7sC3FVAHezHNxEdZS44r3
 oCQ0x6gzZjYl3a6jO0cPAREwRMDet2vkSIgEqB09MIEIXMHeUl5DGM50Sll8XyZGhVhrIUNr4Nq
 XxKWA13bCrjnvFw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: EA0A7A0018
X-Rspam-User: 
X-Stat-Signature: z4rc7kkg5iedwydd3rq5hqhzzihnirne
X-Rspamd-Server: rspam08
X-HE-Tag: 1781032665-803167
X-HE-Meta: U2FsdGVkX19JohW+IAF7aFV6pTYNm62H9JrH3NIqqA4za5NWbyi/k5I95hogxltNC0SVWA5Nfi1xgkEHmYu3b5cMd8+l0FLM8KDVmb2dNtkcGr717cgn8JCC8zTMRj6bWeAVhruttHvJeGcCIh+52x0wQNV3ucMfW41qPqGcNVpyRbTKjxE/OFUbaFgqDdIYoHeTZBV0uvp6eFP60r7QwRp0UKHSjL3lQlwYtez35/FLHF+S6pkt0VElCmKe9QZAKEMc6QkKXmfB03IiKNeUcj571OB2vnA77SUyy9e77zBb32zvHpVL1Q8Cm8qH5WP+i5eVnFwKG3wlz6kosRIQXHeHTO/xx3el+dVJGy0vFdUXj8fdYkwGq3jYA9r7Vn894MrWzO3/kLfFStWWdQzZqtJIMECtvFbC25gG7ZAmzWA4XjwWgMOBBisy18mPiZttO/NFnvDYgzebOp2DwfVposy2WTWgYMytgOq1QHHi1aBuy5XnZy6X+RUK53ac0zvMYflIv/ql3WGkA7gRz8gTey3UbDHclRaAK5wyOXOgaSCyEJpSlDyrwijsALTv05gac2cXiuMREqU4e0TgsS89oO3aZGuBegc/Eaytdh+jCJsTZylKAYOavRr3RxZrtzGrmKwZlVn7mlf42h79egwSk2QA3ZsB/s0iGm4vJdrrpLfa37KbHDe4hrNCznPW/vdYwbQrxSIuBtlCPJr1B6zFkKbR4WySPoUsLAiVJiOeAMAOCrjyBiamLVi8SitYEVaJW6fyabSzdeDXpjsYiREXUQujTG8OnoMvwV11AGJTx2UkBD0PEIqZRXscnJnNtCJnG5zxvHRWmGLzU4TTYWPliRzhQ98FUGhWSEFb7bARLIMC0Ai+g4l30LDsYXjMmGnUmPQQkqGxG0ANiY4N2rIdgurnKYx8xICTxjSTItUAIbCUpwhJ7EVRA2a16FpgnG7dc6GP8yqFqX1JAYCjs9i
 lsAlWg89
 Lm8/qNbQ+43cbGVaXGMUGNpye0WWoYPoITcKIV7aTMu+0K+XAzDMIJbVAJK/1iQ1U8CwilIJvXIQg7KhvNoxipYYW/TVIfjio7dPn96rvBlGd/UKpdgOO0Q8LIyhoOlY17+hh9j1PWwqyPksO2lBKnAlxfAtL3YOtsUuXGFxNyiet1SQB8LlAUxZ97oec4zOiFPgcrkDGgU/wJ32/xWsBtCsWRWzTEkdnIQGq6+OLMddiyTV5CtfLJ9ujnHLG3LndZzukH/pOrIsJ9l5fbaFO2zLWORa7ScHDZ3lLHL4lTQGiVTnwZZ+/SNTPA3VCI8Xw6yt0/YwyYg6p6JYmdeGXvZIpT0QSFqIeHLldZAPBw2mq2XSB7CmIvAIUzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`GenDisk` is a pointer to a `struct gendisk`. It is safe to reference this
struct from multiple threads.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/gen_disk.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/block/mq/gen_disk.rs b/rust/kernel/block/mq/gen_disk.rs
index 2b204b0ed49a..94af85fe1716 100644
--- a/rust/kernel/block/mq/gen_disk.rs
+++ b/rust/kernel/block/mq/gen_disk.rs
@@ -234,6 +234,17 @@ unsafe impl<T> Send for GenDisk<T>
 {
 }
 
+// SAFETY: `GenDisk` is an owned pointer to a `struct gendisk` and an `Arc` to a `TagSet`. It is
+// safe to reference these from multiple threads if the `Arc` and the `gendisk` private data is
+// `Sync`.
+unsafe impl<T> Sync for GenDisk<T>
+where
+    T: Operations,
+    T::QueueData: Sync,
+    Arc<TagSet<T>>: Sync,
+{
+}
+
 impl<T: Operations> Drop for GenDisk<T> {
     fn drop(&mut self) {
         // SAFETY: By type invariant of `Self`, `self.gendisk` points to a valid

-- 
2.51.2



