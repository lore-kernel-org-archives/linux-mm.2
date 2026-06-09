Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 089F6CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:11:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DC5F6B0095; Tue,  9 Jun 2026 15:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68CC86B0096; Tue,  9 Jun 2026 15:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A2EF6B0098; Tue,  9 Jun 2026 15:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4987A6B0095
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:11:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1F4EC270F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:59 +0000 (UTC)
X-FDA: 84861316638.17.AF9DE12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2D70F4000F
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:10:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyT24jGX;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781032258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z3StJ1SDVAol/xVojKQU2uRTOblocEMLOnL3mqoENfg=;
	b=Mq1aouFFd2idK8t195GOMfmLvfCSW4NBOb3hGf3vV3OQPcYC6mL5u8g42ewxh8OCbueHqO
	varLbkZLDw2S84+iOYOdmyesOJOJYDJdnI2Oi1vrfIJzTnZSvUG7ZyjVsAkemiQCKna8j2
	R2IQjS8gAfqjnWk5TF6naeYmvrkj0aY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781032258;
	b=syazzQXUeP2AKDYe0+pfModuCzBAC9GpLFo7U6W4XUGHEZzuLnjACxCnS9JaN3cOErWKgx
	8djlCTfiToqbCOYejNpnRIdXIqOSOfV+39/blsbKpLgY3qaED9Ukvsuo1HExZMZrNcvNjK
	VTE1Y4gwHHH8VoFh7yHvtUFBD49QYrE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PyT24jGX;
	spf=pass (imf27.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 781A840477;
	Tue,  9 Jun 2026 19:10:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 317391F00893;
	Tue,  9 Jun 2026 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781032257;
	bh=z3StJ1SDVAol/xVojKQU2uRTOblocEMLOnL3mqoENfg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PyT24jGXtIi3d0UF04FVHwiZclVhw/6Ja+SJ0WHyKYnIz34KeUUX8ad3sCHCDHAKI
	 /n1gD3j6hBu41FBHAfylAUdeDpuzs/GQkt+EqsM8aezKqsnqi8i7Zz9H0Q0amI9ghX
	 bZUFwofKeBJuAGg1pJS6stvUEGb+n8sRJGcRs5ZApZw90maEIicpz/WebeBGlZ+Nr/
	 PRM/9VNUd6DluM5kek4MBKALBdIHMyBfBuqBp19OeWGjiJnoA1bUubIuQntNfBLQ5z
	 gpBAQGsEJ5ZlWDqFcTuX4C04foUANCTNaw+daq0g9pVXGwS49d62pEHwJdfWHcSYgO
	 Uy12ml271T44w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 09 Jun 2026 21:07:42 +0200
Subject: [PATCH v2 03/83] block: rnull: adopt new formatting guidelines
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-rnull-v6-19-rc5-send-v2-3-82c7404542e2@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1057; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=4NVXyfJD6Wc3B91hTYpUVWCQ5xmIczODt3j5Z23HY6s=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqKGS3eaUcUB7ex1Rk0/NrKNjqPU45h3WR6lcRF
 3h/f82EGjWJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaihktwAKCRD6UCkIqsW9
 0G5wD/908gLu/c/luttZa3fhus/yQ22Ibyd1bQaE7Go+HRNeE0PP5PijB26fEiwMq+wZapKjfdF
 cD0lxtPlkAJVWuWuZMEQvHzv6J0+ty/3lmAAZH0EYuNh91xn2ME9AtGQe4sqk8YZefRw/t4glgD
 Ok4VQbhmdyOTfo7LVrggMkNcY0hlyGoBf98O3LYmyavBT1HnoY/DxeRyK+iUTWA0bA4IkgSZsNV
 4sbHm2WLjLP2yXmdWfa4BNfU0ASOfzEHa1Yp1EIOPicsDZTrKrmGz1VEDUjpe8+vV8hukWazy00
 Na+XzMEtJ/leSsLYEIaOY9CBnjoWCjH/oHPAXpLuLrd6lOfpXEtg4MSWfkKn9yldpPZzUzidEdW
 uGHTkxc3guVO56mTrk51YkCcsjDa0//MCCEK2VY5ToUCbCUYZdyq9qe1VpUcW3kJp6m83AuLMrf
 881PPqrOdhirescgirjUkUSYVc7V/BpVtpIhrXbB0ll2MD5ve9oMY3mDNkwr/Pj5O82VakOQcfP
 moq5YSm46RG3ISMDFJF5hDRDbzbKrJ852TWNAv4rdk6/TUMKY8frEIdz1goOCaB6afbhDaQ+nhv
 ByCqFxHXnAGfwSm8MMWzExl3veZcnaO4TvvjJJV+4tVPBJdGRsfAppZUQ1x3YZNhN4dNctHK2je
 3oVTGh1mKkqd5dA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2D70F4000F
X-Stat-Signature: m6za4xhcum814yosqtkycdmhcou7uh8i
X-HE-Tag: 1781032258-15871
X-HE-Meta: U2FsdGVkX19heaiOueC47PYfERHh7HkaPWTgSxJw+Jq+jAmscpTSlIc7hIpEw3i/632NFNbvDEmHctm6BzSTcQJIhJAUsfoE0HCYqVPmI5AhBqD4Hh8zdM1PkGF86U1/tYS/uBHSk7+Yl8FA3bMO90q4XswrflxVcYazzZh+vyEwuxpaMah5Qhlgj6lqTS1UlZ2G4skGcK+wVRg0oGo6N+e2qxQmJPTxm7MLLWX7qs3UAAA/sG5fLyd61vrzCMBIB1dGdvfeqTmU2b0K+YGiVw+w0rd4lXkvfIqBctYFj8ICAuFDtqaGjzEUi8j/wcMn2hPFSyyvb8mY6WuSA6KV8YT65EMlz4UHjrK4Hj1daTBB116WWOIhu35hink1f7A2kIyvFrdzqYIrSiRr69vDeNG+7bOIlfk7wSEq2JOhe3uZwH2eMQfU6fZJ4KWmi5pAgtq4oeTm30XAYkqpiECKecsIX/rDafH9JLZ+LYkJKypWSt1KtoRkIpQVwAI9yWN0WmQ4BfC8myZhATOQ9MTuX/CEgIM3DT3EXKTff+nCTL9/JHZLkFJmuopfXE4WeA/6aF6jbSS6mUQJdIC76JolKGxtpR4qKiyhopPr64g5G2lQhRKgRmUfXZO/IKz70GxiOoUS2QRrYLWJp6AECIb2e/pCnKSLwG1eFwBoHJHQ5ob4yt3CSeGPRfUmJ7zEJqXntXg4KdRncjMcHMLofitXN10IiwH3L2O3RtwT5azwgx640oW/WlrbzKCgG9v5CwA7zRh91glSDNx+jhDMXEheRSg/QIxu1CMSA8EOYpQGQxZtyVDRwyNAVhhzjCEkKFOMtBd+zbIRvPcnh6wqnm659a4DrWPfJZHnTsezMtF5i55YwkC53twVWDfzS4jONyqsRfkUIoMVbkL3vnqLZDi3erIdnP0q7Oee0bVpuXF9xCt810nzVANvWBn9uh9+XEndp2pmW/OV4uItef/wSn6
 vuPeiEOe
 duvDsWQIynvzv9w6JQJzztthGjrlbIO6xGfn2gl/X8bkJqYKjf0W31LliXln6fvL7ND2dC12JqUSJA5/00K3LD6UbRffWKz4dGEiM0cSiFFmz1XPeVKjB5GaP5v6o0yzqNv29QHYP1/T+mhLZoEW7+M+W2WgzO7pf1acMjmNiTZTTkShQ3mAzbal1oGD6TpVvmwZclh32uqbuPrEzaps/2/5G4cTUJUBPM0fiikpDv1F9OC2dL9tCzKIBjdN9Ruf4fVEUGioqwPJM/Pu/hwqUPls8g9/DBkWOrCB5Al3R4/53wV8/0A42zP9spISuJ/E4k4JhV0MnH3KBK17Kq7GCGI7ktA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reformat `use` statements to have one item per line as required by the
updated Rust formatting guidelines. Apply a formatting workaround to
ensure `rustfmt` produces the expected output.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/block/rnull/rnull.rs | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
index 0ca8715febe8..d58d2c4c5f63 100644
--- a/drivers/block/rnull/rnull.rs
+++ b/drivers/block/rnull/rnull.rs
@@ -10,12 +10,19 @@
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
     prelude::*,
-    sync::{aref::ARef, Arc},
+    sync::{
+        aref::ARef,
+        Arc, //
+    },
 };
 
 module! {

-- 
2.51.2



