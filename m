Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7095E63F2A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 04:15:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FFAC6B00D3; Sun, 15 Feb 2026 18:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CDC66B00F3; Sun, 15 Feb 2026 18:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB706B00F7; Sun, 15 Feb 2026 18:52:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0C536B00D3
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:52:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 872511B4F39
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:18 +0000 (UTC)
X-FDA: 84448324716.16.A5C30DB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id D72174000F
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:45:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DTq0574l;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771199116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nm0FPNbpy+qbTtyUELy52X9vTRxN1sCZj+PzyLAXvR4=;
	b=IZoAa/GA6tD2LfyQU5s97E0Cy1dr7qbIuAqM790Wz5ifsvdJZfEA6q2oEeIBYox7u4If2V
	aXhhVGbcPfq40wueslvjRZBJYkVs1nvj6wN2eUHiXDyeDLHg+oqUcc0pwtZr0gCudyq9dQ
	oBFzsWq/mRycp3ElbhX8/OFRNu7yGH4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DTq0574l;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771199116; a=rsa-sha256;
	cv=none;
	b=HeNoqmAvABVJCf4fYRv80AEuQuP/HBjBqwcCGLv23icqBKzw8GzHPY1nFz5gzJOwxWpS5h
	aDXq04A+QWuedRYK3u6JnETaBLduDPvYt9o9N3Sp9hJKlLb3sZAcAqAc791kapzySdzR7x
	41E/KJjFnR5rD3WksBTODQV4W8lrJFU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B1F96013E;
	Sun, 15 Feb 2026 23:45:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BA5C4CEF7;
	Sun, 15 Feb 2026 23:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771199116;
	bh=xknlJKjDgQx2PklWhfpIJtdR7sb0fmRIcoqZtD2O+JQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DTq0574lt4lFIjV5BGtsOf53qYZq/UUXgIQFVYEJnLtavbUVAreck4t93U/I85b4w
	 8rtpG/bqaQF0Cl4uI4mW2ivUpfjqgcqtlad46pfHK2iq2nF9FgWbopKXZmp2MxtF0M
	 qDiMt3QAsZGIJoPl9/85vRHZdH5bY8sRMYw9PJ+YWjXXmuEoB8vPr2h9OxoJWSrK5X
	 LblQ1dOTw+BPdGutBKjuTMjRhVLuvBNJIKxM/Q+PnSQfLKxV2m9GWo8np2086DBB9Q
	 NauJCPEqCnOcEW/PTtC3Jdk0N+EvnM5Uib1/M0iw+/Xc4qvrUCnSTasP9UKa0aCPch
	 dEXJRtvDrsbqQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 16 Feb 2026 00:34:48 +0100
Subject: [PATCH 01/79] block: rnull: adopt new formatting guidelines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260216-rnull-v6-19-rc5-send-v1-1-de9a7af4b469@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1060; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=xknlJKjDgQx2PklWhfpIJtdR7sb0fmRIcoqZtD2O+JQ=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpklgcx+Hel7olsXH4zRoVtUmD4dmhza68hS3aH
 Ic1/VCoziCJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZJYHAAKCRDhuBo+eShj
 d/mQEAC2VIEFmtp53Y73KZqpnd3iisJkJprBqibxgwe4PmVofc2jb+vYmI0M27QBCSy7TZI70qa
 fGabetSqKwfit5BTtDd9i8VWhdIt28z2tBa7lQAQU6gUXN7+h/0OrgZUjrQMYNSiMHEFfjDKRnm
 vabPA9SvNgKI9Nnq8mkj/4DwHLO9QedW9ZuM5LWiGLNx2tYrP6i4d6f17F0u0F3Q/YEXzg7Ad79
 rCfup6mPXjh+Xf0R9Yh17SM491NorZ3/e62rV/U9PgM2mDlpJz52MpGgdcWoecew5g0h1GVb26L
 zFkE5WCDPNOrzhFCo7ezaTdQ1lwwVrBjyYuJZb4tEmPP7qHwjN6Awf73ZPJCjhBN31N9Hfe1l9+
 AvHq3/DZURYUCKi8+421oXhmInZaNb9i7n8dd5vLyZar08vDXomuh6rNdNoUDo5MHhEkI2NvbXs
 zwiWTGN2OytTL79j5+i6BQQQQkYcUR3mpk+wN0LAw3G/kd1FGEicOnVdIs7u25hOO5FvJUSuWKE
 /5IDy8vVRxcU0Bxei4QO7I70wnsJPp8f2XIZhRzeWn75szLBUXWyEoO1QJssJXqH8ztnRr3rdL4
 HSQUvjWibaQyn2e79bqnYQP7AjY51xhJ+EF84ezBywBBDfAj+JSzVpIgtytQanunAnN6dcj1GU/
 jqhUKqDc7YaEwKQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 5hhwdebz19mz7g89hmnruhckqgihgd4c
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D72174000F
X-HE-Tag: 1771199116-973835
X-HE-Meta: U2FsdGVkX1/AU3vNLJu2VsX0eiyFwdSz7gv8aN1fx0x99PlOWZWZUMS6/Cf2P+KLR8l/NTteTKw5OMfAwWWNOUeijd6fBHZaKnGkkRsKLSFu/MFWXibs0FB1RtfRYXzXv0nfLgrgLEQ60S1kW/ZfYbcSIhvWc/9vkfRf5gDsTku7zIPuhmJ0cn7mDUjGgxqELmdvdspNAeBQV211QJ+ny+JgpLAXoPraxphFM9an6F9CTLI/+SKBGtpGOWvls5BhTwMMfTtTcIS1vv3wepPT1XPqNnk/T9cCOAk/2+q/djfJY9Oj/Y6udDA2yJmtzbqcBzLVfhR2/rNC+UUB03u9EmyDJU/TUHKNW9pQI+8mGMArCuE6f6RnjAARHrEX+u9E1eTd0Vg+/7s9FaIlaA2PjigZzogcmsP7Bu1MMozIIOhBay8cPSF6Ddf6g2gswQTzeuZplUOmtWtu+KwJRUoymNEKKMb7rNvVxo9cH2PBGrcNE5QoUqjqUUPyzwuH2e3eQaY4WQ/iAaGtk0IGH+yKZWp6vbn1qWjsn7jIVCya6nC58GjFYQDJHhBevff0HoHWVgsj3x2qJ48uzMmHHFQ7wM+oadHCRHMNqX9XsmlRlCLzPGDL3VWk1REDSk+NvzeEKrAlQVVCtla4SpDXd6r3/K542GAQ8Gso+4/iNyuWvHDbiJjaIQGxMSwOicu+wGcrqprz4cnCe/SfpS/X1RRZb72/PtjphAZOwNIMv54RhLsqi751fGjeEMNwCawRW01kutV2j0mObwr1w3n9g+R4rAFPgRunw2qIynlLJCwk9p78gOsRbXSLzavl0AwG+278zdv1AF0r9nsKlJiXJFxIfq8UNf1YxJ1nKl5bp6k2wJVKmQQQ5U/LF/UqJzGJmnKSPZ3x64Crcqrz6G5Mpx26pKWzpXYZFLhWcDcWAfk0M+XmIe9a08b1gMYEXK8m+Onv3/M/Ku6gm5tYtBi9m5i
 S7Tg6E4D
 1zhGt049ftrtep2VbsvboIfAlICR+b5Vjb/+5+EoYy1tLdQeqIl+DVweSpT93bbPcKJn/ItgDYvTxqICJcNScw2NB4iqvaQ9gtHJ60LWWbocty1bJ5LIb2IjIKG36iXd1e3L7G5HBAPTIUPpMp6sxKF4v98prBi5QCdUBQGxVqHS6jF/g4t0BjbtKsIbUWSjun/miXJQThTYvT+nz+6boa4KiA6We+MmgfPVYiMz5Ujd4x1msFP/IyBqxK2fpLXLw1e/UBhgyH5fv5l5agpLH9pVxXTBsB8mZMEqW++/lDeKSVsuZxoO52Lyt+gbueLpAp6rh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reformat `use` statements to have one item per line as required by the
updated Rust formatting guidelines. Apply a formatting workaround to
ensure `rustfmt` produces the expected output.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index a9d5e575a2c43..2c83b014b05e9 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -10,14 +10,21 @@
         self,
         mq::{
             self,
-            gen_disk::{self, GenDisk},
-            Operations, TagSet,
+            gen_disk::{
+                self,
+                GenDisk, //
+            },
+            Operations,
+            TagSet, //
         },
     },
     error::Result,
     pr_info,
     prelude::*,
-    sync::{aref::ARef, Arc},
+    sync::{
+        aref::ARef,
+        Arc, //
+    },
 };
 use pin_init::PinInit;
 

-- 
2.51.2



