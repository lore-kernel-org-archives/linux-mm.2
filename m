Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E46CCE909A6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 54D076B008A; Tue, 17 Feb 2026 09:23:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F8E6B008C; Tue, 17 Feb 2026 09:23:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CF2F6B0092; Tue, 17 Feb 2026 09:23:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 22A826B008A
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:23:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CEED5885E3
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:22:59 +0000 (UTC)
X-FDA: 84454165278.03.60FDF14
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0486F1A000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:22:57 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fqJByDOR;
	spf=pass (imf19.hostedemail.com: domain of 3wHmUaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3wHmUaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771338178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6LeKap7jZK//r6ZxbwvZGHpBK/lawg1BApnHVA3ELvI=;
	b=UK8MkwVJXia+dwp1sj9zxCQ2zsweREq4J+QFlbZzxTE0LlJo9ot/NClDnfcW7AVOMZOr8n
	msC33+iThYcWvPAylP6maEmOKHUibFVttOSmMn0TJxrmwpeZ4nqjKCvbSBqvNJGuFclb5O
	9m6cMCxIiFthUWgv/7aU/7n7CaNeRc4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771338178; a=rsa-sha256;
	cv=none;
	b=pYfOYWpEA16qWpb0ILc70NkFiMlgx6gv2BhaiH6pxn3EdXA4kSrwL8JDeyga71oIV4yfix
	xuvGXPcuhhOPKYWOWf6CWDPC+xRsDMkPirnidiKK9RbE7B0yVYywAuL2J/TPlndywi57Ue
	KlBITee0owD/iysCD6Wv8BH0AfvBh4I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fqJByDOR;
	spf=pass (imf19.hostedemail.com: domain of 3wHmUaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3wHmUaQkKCFk1C935IP8C7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-435add03f12so3128335f8f.3
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 06:22:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771338176; x=1771942976; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6LeKap7jZK//r6ZxbwvZGHpBK/lawg1BApnHVA3ELvI=;
        b=fqJByDORVhioWykd8n/EEcTyjEES4fGC/FCvApYfV2lbs6jamZChMyI/VNe6L9IDVe
         woBeMpTGem+cVfi1hdUFY/9QwLyWS4DApzI0E31VqEdk7Qol8ijOAzM5TPNViBr5JVQ8
         LZ4A0WO5pnsjlk926S9vY3VLlApmlUNFNPhcr7biuCDkgSiNiFxsy5XvfrrpRsiE6Do7
         vlRxTTIPdCnC6vcat9HCV0imocLhQIUgA+Oclt2p9IFJwpZwX86XeB3urqniCYWavJFB
         WLhsl/sEYFI0jgNneB4Cz1eLnizrcE2YGdIcXMSTx65LZYbddXuyBGkVWxwwc43NHgwD
         tCdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771338176; x=1771942976;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6LeKap7jZK//r6ZxbwvZGHpBK/lawg1BApnHVA3ELvI=;
        b=X7qDuZ9M7t8izHD6plXeAfqICu7Cg07lY1KYo6PIhM1kpXKMDBw6YEge4Alqg8bPr/
         c5oIBgqtvluj0BHGPpIH0+uRU6xCXKilfoZLxfZOthUXpxgNBPtHq/b9PjG9wqY1VUQ3
         qKuaWZ1OuXjWaW7RNQsFpP/tBN8PgnE5UHKkzEX6m19N3+GqMd3joBtl9WZjAo54Flv3
         kWdPojzsEdXoGAyYe/4q9TKUuHaO/cQF+HensnXA2vDTKdz0KCqg+PHLJV/4U/GkeI8F
         qkSx57bMSFDqkV/JtOTy0GgRJadjBkapL5hTEbXIA5H9ZDxkiR5aqmbqcg3CQFB2EbiU
         wlyg==
X-Forwarded-Encrypted: i=1; AJvYcCWMoJjJfVbMaD3APtno8goEnFJIcX2pnp6kHF+5vo2DCkw8yXDm1umpFGD+ZHxmKyJ68kwkdTuYhg==@kvack.org
X-Gm-Message-State: AOJu0YxnSx2/n/SE2bVHQux/wdrrFq3zEb9n9pPXG5Ackm7N8NK7o0oi
	A/56KJsY75Oygcg4YZEDfzG05cMzk9ycd2VNih/Cxj6oiaUUndK5NUMVeS62p2BRTWqMmb1ab3P
	k53o3dPwl5QnAUqqIGA==
X-Received: from wrnc10.prod.google.com ([2002:adf:e74a:0:b0:437:6b00:8cbc])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:240e:b0:431:808:2d50 with SMTP id ffacd0b85a97d-4379db24fb0mr20850357f8f.13.1771338176111;
 Tue, 17 Feb 2026 06:22:56 -0800 (PST)
Date: Tue, 17 Feb 2026 14:22:39 +0000
In-Reply-To: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
Mime-Version: 1.0
References: <20260217-binder-vma-check-v1-0-1a2b37f7b762@google.com>
X-Developer-Key: i=aliceryhl@google.com; a=openpgp; fpr=49F6C1FAA74960F43A5B86A1EE7A392FDE96209F
X-Developer-Signature: v=1; a=openpgp-sha256; l=2851; i=aliceryhl@google.com;
 h=from:subject:message-id; bh=Efrfc+ezEwByI/gNWdWXysiNKRrRQRbM6CMnAM/EeeM=;
 b=owEBbQKS/ZANAwAKAQRYvu5YxjlGAcsmYgBplHm5prYIkklTAyDnHpvdtT4ZnH/PWKGUlo9A7
 e0m3cQkth6JAjMEAAEKAB0WIQSDkqKUTWQHCvFIvbIEWL7uWMY5RgUCaZR5uQAKCRAEWL7uWMY5
 RjRCD/9Hw/hm2Xm3vaKkplhmlEb0PY2QkvIEUCwKHyT/1GELqXg87R/lLUOS5SfbeX6FB3MKzyZ
 qMQrby2qSbni8YHedTtzjFZZNS5kKbyOIXtkyiK0htiI4E+oV637qnqGzSqId3M9Sc1FbgYhZmD
 M5ot3f02kV1P9LLybjMEAXBxuEgYKjHv/Cdc1tan0KELqEmRyXF7wneln2hM9GGoXaXeUrk6/EW
 aDQo1JuVycWlZgzXY1bfMUCYbABcHl1xVcVt6+HAfCHpTPleAIvy1xFDoNtMUB//NwUT3ne7AjJ
 XodQxTZxTZZqsD2QSBzk+b6i8yJRFv9EVxBEFHn5N/F5PsPv2/HYU1eXWe6X7oh6UBFkeOHE/g9
 wQ2Xt4wa7HWgQwUYEofVqhJwcadiMbw9NAuB5ghDBrEZoprpr5Gg6zyYq6FbuJU9l5vWTKgarOb
 /5rddyZlLCgqDppocuz5wInoSxvJkpVwSwk10MjRSIyyURCpZtFQ2m2HDTqhYP5pgc8UQ1Ke5Nh
 8XFyDEqHwCRFMaxZ8ZaGWp4OFfAPKVJXkBPqToS90XrexsvF6L9m7Nhq5qSIejoh0JLBvUzILyQ
 XxBk0KpMUnllvaBB7ZXdoilUxvFY1GS5qS29U3uVRQcjiFtOdMyTifisrClGZ3F/2bpSewTI7f3 mliJbE3uEwn0XCg==
X-Mailer: b4 0.14.2
Message-ID: <20260217-binder-vma-check-v1-2-1a2b37f7b762@google.com>
Subject: [PATCH 2/2] rust_binder: avoid reading the written value in offsets array
From: Alice Ryhl <aliceryhl@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Carlos Llamas <cmllamas@google.com>, 
	Jann Horn <jannh@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?q?Bj=C3=B6rn_Roy_Baron?=" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-mm@kvack.org, 
	Alice Ryhl <aliceryhl@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam09
X-Stat-Signature: r1ho7smn5w9cwh9sygq7zix968w37zac
X-Rspamd-Queue-Id: 0486F1A000C
X-Rspam-User: 
X-HE-Tag: 1771338177-600576
X-HE-Meta: U2FsdGVkX181IRgT+3aBEhfowMA3AkXJVgtt+t8/yyx6DlQxtIttHsEcOwDthSJ89P92Y4ubZMiCg1KwuFth1M3f4BL/CU4ZG27an3kunKNLJeb7HAEXtNzDzJNwy9cUtBaIpTukct0oQ4BMw/90jhIFrAetkrmTiNgJG7NAHKT/Dsrmwl8yWHPsMxsfu9QVnXKxKMeXIgzAkxyJnKY3BRci2P1iRepSS3roX4v0+vuRQPtyirkaGKr5xqSZeUF21THNm2gL3H4O0/WFN6j4jrTo2fvKbQiGR8NtppSh0wZfscMw+0Ak63/fDrprNprAGIpLt0T1IzfrvLjl2y+uSNQFLVuUsV6HkVoY3OigyqEdZfmthO/MM042PaqU9V5EVVlcqS8HdgfY1l3slEySzU3JUgZ7yZsbuBB+kUEfx7YEpr+sIIxMJGCMIZABPwDH7TAp6XOTcI/4byybnMMWyeSjRamdJsQiIcrDa7N4PL6+LWB0RVmtPZlFEtckAS3wHO0t6qlWQzleczMgi9gv4BM3aOyyUQod3Hx9JMO5FS03VacEE/htUJNbF+9ks8YPXJ60sqHTxZ3wGGCZvSAuvPepIGqst0Zm/7Pe2O0s1tawNszY45mn9F1+Uhlb44zvWYdnB6reTqWRDwAXQ/6urLbvFXLKGOubunMvXtGt4Eb01p6Lo0qkZ7+pra9tSv+SKQWGlyYbrcXNqSpWUA+HGfj4nl+wSd4bDJRFCfOXS6KV+gd5RVtJDlQohZBqo230usL1YZ3NeAuUgRQMFqIvAfSQ/qaGHUhc5jlQRRdXsgUZCmKcf+O8nrWyF+X81wEdooex2nbohBViYlgMvMEy1q9pfZX9NW39UMXLMiGVZ4aARDcp9R9vA3106icI0hfvoCeT+Qz/ZvrpFahRK2WddvHf6b2FDVKK85SxmhPevkk9ZCayH/tskh0+2kSTDvwlEu9XE2b0838lJCjXtfy
 vEiWhMZg
 Rjqsh9PsBONuwtc6jl7+6TGtUfJhrGUENAnBtqBM9nadIrnuFYOpeD73Reom3/zeUPlW2Gh/JnbxlU1nvdF+Hy/z9zvj1MiDrbHS1No9W48R0E0WahMvV1XQAMEUpqK2abRgJGtPjk6TV1QP7axMI4yHKOVgqyOYnCr3q+YrU3Od0BZJLhSy8bZU1JZ3F5YD3JSw4RJHN+ftW0ODQ2qSK4WwaU6NoksD+azu3k3q6Hv8qnP7HpQqvWM0AOQ8L06er7f17YsVhxYS7yKTPogq51wOhgIrw5SUb2GzDdySvlTOurq0d/bEWTWg5xqqtTn8L2wpDQMRTkBU7UxM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When sending a transaction, its offsets array is first copied into the
target proc's vma, and then the values are read back from there. This is
normally fine because the vma is a read-only mapping, so the target
process cannot change the value under us.

However, if the target process somehow gains the ability to write to its
own vma, it could change the offset before it's read back, causing the
kernel to misinterpret what the sender meant. If the sender happens to
send a payload with a specific shape, this could in the worst case lead
to the receiver being able to privilege escalate into the sender.

The intent is that gaining the ability to change the read-only vma of
your own process should not be exploitable, so remove this TOCTOU read
even though it's unexploitable without another Binder bug.

Cc: stable@vger.kernel.org
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
---
 drivers/android/binder/thread.rs | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/android/binder/thread.rs b/drivers/android/binder/thread.rs
index 1f1709a6a77abc1c865cc9387e7ba7493448c71d..f58ecccf5bb10a4b916d14a38dbb3bdfdda24ff8 100644
--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -1016,12 +1016,9 @@ pub(crate) fn copy_transaction_data(
 
         // Copy offsets if there are any.
         if offsets_size > 0 {
-            {
-                let mut reader =
-                    UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
-                        .reader();
-                alloc.copy_into(&mut reader, aligned_data_size, offsets_size)?;
-            }
+            let mut offsets_reader =
+                UserSlice::new(UserPtr::from_addr(trd_data_ptr.offsets as _), offsets_size)
+                .reader();
 
             let offsets_start = aligned_data_size;
             let offsets_end = aligned_data_size + offsets_size;
@@ -1042,11 +1039,9 @@ pub(crate) fn copy_transaction_data(
                 .step_by(size_of::<u64>())
                 .enumerate()
             {
-                let offset: usize = view
-                    .alloc
-                    .read::<u64>(index_offset)?
-                    .try_into()
-                    .map_err(|_| EINVAL)?;
+                let offset = offsets_reader.read::<u64>()?;
+                view.alloc.write(index_offset, &offset)?;
+                let offset: usize = offset.try_into().map_err(|_| EINVAL)?;
 
                 if offset < end_of_previous_object || !is_aligned(offset, size_of::<u32>()) {
                     pr_warn!("Got transaction with invalid offset.");

-- 
2.53.0.273.g2a3d683680-goog


