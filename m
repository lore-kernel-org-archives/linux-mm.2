Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67366E63F2D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:10:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E41BF6B010F; Sun, 15 Feb 2026 18:57:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E29786B011C; Sun, 15 Feb 2026 18:57:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D59776B0123; Sun, 15 Feb 2026 18:57:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CAB576B011C
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:56:16 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC462BA54C
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:13 +0000 (UTC)
X-FDA: 84448327026.24.C6F1E8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E5CC54000A
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:46:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cn925NUd;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PFoUshVV5PgxBr9gH69/fhJ7tjBJv/Jq4ZP1AY/KeSg=;
	b=uuOVhLmWgz7t+TdLMISylWga9NoBvTjBUlfBRsIdwmTK2BAz/jTM47nOa60Pg+D2FZGaz5
	86UOyOw1zeppW9QgiwJ9g6IM5hU0NSVSJs4LiFUEuyHsBUa+2mRjZc7scP3tgg3bFJ5x4L
	7IZV8g0j+DgqLzg+q5pfCbHmAEpidls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199172; a=rsa-sha256;
	cv=none;
	b=t/b9yXvAjkTd2Dha3bA6GnZMA26zZwDXqdWYWJOCbYGExcv6p9dZMiFZ4nOYwMoAhx+hfG
	7hO6NSlOyvKlZEhQHAtisaLap7aTs8GZEdlbEy71v/NsTQkiWMNmDmAI9cX/sS071212Bb
	qgU753hkdZ/w6kztcTb5Fi/Ugh9BIp4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cn925NUd;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0CE2943928;
	Sun, 15 Feb 2026 23:46:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E806C4CEF7;
	Sun, 15 Feb 2026 23:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199170;
	bh=09c7uzZkxTyVrHNvjFvmG71WyMeEUT6Jt3cM3tUyoBs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=cn925NUdJj4OBEmpfeVpbTqvDSZsJTqZer9GL5rgWPDKXUNrKh7N7CvEZ/8q7ZlB/
	 JR6Ub+cilzPA0SEV5a66KNxM4O0/p4Il22WIzHeHBk7zGxciQfy3Z8sB8iVgBF2vXx
	 ZbpfOUVueW4pb8ZnXQ4kk91lkCS5qV2wNGWQCOr1uL6xf6/SdglBx+UKcX8lr4kYZY
	 sX0dY0R+f9p48b3UPwm9bD3Ed2cWgsK0BSQfpqcd52jnd7Mz06lcT7GAHEOmF3KRuq
	 6JwAXz9P/u3kKRE0PAiNqbZhhUyrumt/IzZAimFLzxBHLnY5tsD4nCQciQchOdNp3u
	 Jbs4h+OBc2xgQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:35:55 +0100
Subject: [PATCH 68/79] block: rust: add a debug assert for refcounts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-68-de9a7af4b469@kernel.org>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
To: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
 Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 FUJITA Tomonori <fujita.tomonori@gmail.com>, 
 Frederic Weisbecker <frederic@kernel.org>, Lyude Paul <lyude@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 John Stultz <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1216; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=09c7uzZkxTyVrHNvjFvmG71WyMeEUT6Jt3cM3tUyoBs=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklhZFlZdiDql4cqam8az2bqXKyXBUh/nt996f
 hHOmyZjco2JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYWQAKCRDhuBo+eShj
 d+g1D/9Tp63vqvjenlUu+5ZJU1lZ+9dfMcKfq9m3hw47N4hrC9Z4Q6onk654vGOU2FPLlpUNy8O
 KFHhFrvdjxRcIbLPUsQOFHJGFib9kBLRrM6/JaRWlH5iq6m5ETg0Q5R+WGViG44b169vc4/YW1N
 JzNKqKwWBx66ko26VSg8maFMMAErumOt7G10lKzpSzcp4cOGXui6ZkKmiQDqJrWSaZQKDbZg1yy
 8bhhfuK5uo9d+cDLVDb5Ea1EcGG0W+wP+9g/YDAfR0qF4qjcwLPL9vChJRJXchgei9i5rx7gFth
 2xSBY+ot3E1dHVntP9S+ghLoduNyau62Rd9Cc31zYM8heVQM3/HPOed2K4c+KF/TRpoKjvxgHFb
 YIPbvfyMA6a5YpVqIygvX8iSCGULk5WoA6CP1LzQE6zSK6zEhZPj0vc/zviKoEe8uxcHUScNFqc
 z+BsrGzv5O2m7ZbGzZgin6qvb5UV/3nqjB/EwntF6hW5J3xMTu6O0f0rw2PdEAVdCVjzYXBCFuj
 L3ExONihceAiCdO20rH5z/EFwxqcNDWF2fqaXXOR1SB2Z+ZWciJYmnJJV4zgMpJiFQPQKFGPQi4
 ICC96uXCC3tdqBoeeBBLLXLPkSwXL+phd4rQNh8+oV2xj7+yqiB/5R6yXRUf04+giFNXYDLK2j5
 jxL++PfGAvuA3vg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: E5CC54000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: stu3kjugps54k1ukkckmemd6nznhmaez
X-HE-Tag: 1771199171-832044
X-HE-Meta: U2FsdGVkX19vPG0wMoTzKRNVdn7DkcTM/Gd6GHEBWHcTh9xp8w2bJAWyVRCcu4QmptMcsIPu60LT/iW3LDsSn83+VLg1+EEG75caZmA5uWyCQUw5aiVZE6yD//PWlYOohOlvSHfi1yyu6C8E0NmPV8RvDLwFj3c8oiV0oXcq7TRhe9nrJde4FCqbgbH+kCrL4eMYnfA3CtdHo7b2yIQSjNCSEI1/UU7GxZWLeSy3T3R5uhXXjbSQ8HmmIOCGyFXdZT4HBFUJecMsVZ76hj5TKEH0Lt4ES+tz1/nhjzEtJQEk53zqb3SCLzcYhPO9ScMaDTAnAnoAKIin2h5PQoeZVUJJDYAqYKkWU1QIvsvO63pQpCv9nJTQshOaCkcr9RZxTEQD8Ve/doqOX33ivDDazegMkwYUaIny8ph7Jue5IWup+5DZNHprSRCdsJWyeWVkWumYJzfjJ7RhIbH/fNyTqd/FLLN1eDlEEkWUBZops4CAdCUQa6/OmZLX5CG2RQWjotfaGoPM60gRuJC1pBa6L1kl+YoQZp3qbfTFPY2zO7Lh0IbmY7RutIScLNLcwIbVgnzSEhF8ldZbDzpwNzAnRnauis/RbVuQB0AKoa41rCTzCxpgiMxs36PnPLhCx5QlVjHBInA6oD1fIQROsENnz+f8hfB/UYChhJSyqjv3l3A0JpK5LOdNMFOH7t1QKZDBc7n5ElnD0rNszxjJRJ0/qZfiynd2ZUR2cgmEvsTsA81XwAjXkiyMWsn25oFzr6mhA2a1NpTyzSq11csumhZYhgHJ1ERChwMIg/5xt2LvUDWoPjkqO1DRiCCZ6GpYcW3kFipguypd5gULhqlI0Z/xCnci7TPuc3iJKmIM3KyjfB0wfwrUal9vNJrlc4qpotafK+M5kJt8BbIDiEUHlt93wIKKUjLboK+it/+NO3N1RcN80cQMXUAFtm8lZgFk+ZtdPcIr192E507fzSbHx8L
 wW50uEI4
 ipg6oTP8AirBOzW4Q6WfS1Olt9/BiWhE+h8TYLoI9LzoHsBV6LjJHnjIMrKi6SHtehRJmb5vtlXdABRK1e8sl92jtcDlw/5RKuvdn0k189q1GfL825Smx6u+hFT9dM9nRVFj16Xw2JauyGppQaWrv08VT9vK0Kl4S5nMNigaNFvEsPG3xes41aj6535wUgK+IGjK2e1IyavNHVI4TO0BI5tyBfV2ltuksgy5+lKt8erG9WUIJH3Wc1/zv2L3TrcLwz66m3OotQBybJrsWX3ITibQT39XuOX8R/1eXcIX53H9Up64V5r7NxbrQnNJ/m0+TmHlI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a debug assertion in `ARef<Request>::dismiss` to verify that the
request refcount is at least two when an `ARef<Request>` exists. This
helps catch reference counting bugs during development.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/block/mq/request.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/block/mq/request.rs b/rust/kernel/block/mq/request.rs
index e22af7ea77bbc..9a05bce39c64b 100644
--- a/rust/kernel/block/mq/request.rs
+++ b/rust/kernel/block/mq/request.rs
@@ -579,6 +579,17 @@ pub fn dismiss(mut self) {
         // SAFETY: `inner` is valid for reads and writes, is properly aligned and nonnull. We have
         // exclusive access to `inner` and we do not access `inner` after this call.
         unsafe { core::ptr::drop_in_place(inner) };
+
+        debug_assert!(
+            self.inner
+                .wrapper_ref()
+                .refcount()
+                .as_atomic()
+                .load(ordering::Relaxed)
+                >= 2,
+            "Request refcount must be at least two when an ARef<Request> exist"
+        );
+
         core::mem::forget(self);
     }
 }

-- 
2.51.2



