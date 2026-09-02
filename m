Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 192FBC61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 13:28:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 136296B00AA; Wed,  2 Sep 2026 09:28:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E0EC6B00AD; Wed,  2 Sep 2026 09:28:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F385F6B00AF; Wed,  2 Sep 2026 09:28:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CCFA96B00AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 09:28:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5D99012020A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:26 +0000 (UTC)
X-FDA: 85168901412.22.9E68622
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88AEF1C0005
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:28:24 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdHOrsfn;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788355704;
	b=S1vmeLOshIy20jRvsjBEhQkXZgfqLN9G8yCNw5YeVqEbm6idQ6vfzLhOwLQ7du+IlnrJ7g
	R6X8VIw21MH40lMt7xsOmPsbKoFXWmNjYv/CqbNDEUXWDdKscOH0pEhu4WLmO6z4Oj3Wbi
	o6Ak8qZtGNWa9nMyTXmA4NXZDuvz6b4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OdHOrsfn;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788355704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geBhGzf9cUnk3yzaHjFsAOOWlmrxzTwK75Z/iOmcQgA=;
	b=HmMneGDeaRZr9T/Ee3pLsdztxCoSZ94xOSc954K8C7JPbIwk64fLak2KXg8weUn0sBE0ap
	6Xm4MBrUd98/o39PdM/INatMzEzS7mINf+rTy5dQyG6NghxqQVcpJqFtxM7eCa1W+dhFNI
	ogb9QHDLo4ig3cf7akHTCoSpk/4xLdU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D010840487;
	Wed,  2 Sep 2026 13:28:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 168B31F000E9;
	Wed,  2 Sep 2026 13:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788355703;
	bh=geBhGzf9cUnk3yzaHjFsAOOWlmrxzTwK75Z/iOmcQgA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OdHOrsfnpLKRwrNRRHiRk90GY8/Q3wL1/wflXxZVpvaAM6Hm9CvoKx8HPLNiRyzPP
	 xFx7ULxE8b7uJVlcBi/1EZ81OOfCTA+UqUKocZhmJ/ELEGQlDIbyJAIpPPn1uHW1S6
	 fKa9rB1h8oYtP1fW5xSMrjF/A7lmVp8PHG2ks/v4DZZ8HTCnRf51lOC/rN75tevE23
	 t4Ji4k96NdJ4oeZQQiPu8NKYUYmf8vUu3oPmOqhaENd5daDHQrbiZ6Jjym89mZdiWo
	 PBumOsJthuIobny1/oJZdWoK4UWyfjewkehCd2wPuM9vevmmx/IOldCZINdUySKK66
	 f1UxjVQp6z1bg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 02 Sep 2026 15:25:58 +0200
Subject: [PATCH v5 02/12] rust: xarray: add debug format for `StoreError`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-xarray-entry-send-v5-2-d18adae40708@kernel.org>
References: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
In-Reply-To: <20260902-xarray-entry-send-v5-0-d18adae40708@kernel.org>
To: Tamir Duberstein <tamird@kernel.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Matthew Wilcox <willy@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
 Daniel Gomez <da.gomez@samsung.com>, Tamir Duberstein <tamird@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1348; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=9B4p2CL9qctopDIxo+KXlNZsHJI+dVZmzPAUpOedsMA=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqmCQaCGpAFW6/BSWw+xrp731q7NFnlJ0hRz0Gh
 uySzsBhGKeJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCapgkGgAKCRD6UCkIqsW9
 0Jq9EACwI4S5rCSSyPKySNKDNJdjwO/Du5ue1uvV7K+mHum1BdqTjcpM9OJd9L1enaG52oAnr4b
 me3nVmab/3UMApxgHkQ7X34jM2Fd7PBu7EFCD+hgfplYwC4v9Vqc/FnU6b19ecj/tgh/Nzv7k75
 ON/4yE1cVBLgt3rCu8yD+2A0MkbAGEqb8/3/MYz1KVOwXwjcWV3nAiXxEDYbmUUqZh/Uaivl0BG
 h+kgD8VSKUAtJNV9tjVHpvgQ8nU0u1MprjrpvtQeOhPUXd7eYnFEp5YG2gAabRCW9KJbJ0feLiu
 6TLohZTDaUYjwdZP+qsxX9P+xxilpfiQeSuSch+Az9ZnTWJH5Bybuk67Kp70EK0SeAfuA93sDXn
 OqPqirC8XkzdLX3J2ebc+di2QN9JkeGr4aWQAXdV8Om4wJ1+jTHa3Hk1qjDsw9/FzIdiqjMJMtv
 iDq8kyIrN/ACCUTu1ZPcMuCIiGSGFQ5BcOdpQkcSWg3uMsViX7CA2yF5hfJ3/qNMeunGMaDvLVb
 MfjAW2PKwLz2lsY/yFdhzN2bteOhXq8F9uWr0OR1EYDN9oudTJ8TtnPFeF0TSXb3oZioYZvHCZn
 4YONbdXaN4DizDc6Qw6GZwVZHH1WPXsCVOqXyyGacyEZzp0Bc63Jez4DFSi5Qo+Hf4R0UxVm/VF
 EH2M9JViuxyJAMA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: 3irqp1jbqs8bjx4q4a1gag41ctq5rtmm
X-Rspamd-Queue-Id: 88AEF1C0005
X-Rspamd-Server: rspam06
X-HE-Tag: 1788355704-588117
X-HE-Meta: U2FsdGVkX19fKlEXLYEzFRBUo7yzuaRNl8eYUH8gOF9p9AT6jIuqVNVM5l8sikeGACJ/Fdf65RzPnextjvUah3l3Yhbu56O0nWZpZJfX62gRQ0blABuO+Pt9hKL9faBudmoUcZPGgqZcfi+cw2GEyMCKtsQ45Kw7RV+TTBSQ9A0zfnrBr23FizStNa/KSkoeX8O7MXNNvHA+MKZanlhogM6WOxGaTGjhoLe+m/9BR7AoCIHvxYbm6ZWG1QNpTPvhMEfWqxHAh04tjXA4YezFdVVumoulDSIYA92+OG7qUEH3+KCSzY79zTYZ6+4hdmdzFHtWmaX30rxOoMxoKfs92a39+LHLrntpHZ7QvRWRlawl88BAftgNu6eds95ADwAUmFfageCyCrRdMKUyoWmNJem+tq+CEI2R6DKybf5BaIqMvUgjxUNyeiHlbpgmpIEqoSkqh0WGuqcE89mkDr5r/dIFOOBhU5qhdz0zTYkxZ7v+OYPAcHqbIT26KkWT7kr/ZquyHRxL6ds+2qBu3BbI8sbfBSUA0cC15536neUwKBsy5dlcyptPJOogI7r3unKeoq72EA0mE4ydH/DtHjrHxjnh5ciBSaxwCEXcl2eZ3QgwqzDEonEIx1kU3+jo09INSwLNMY9LbBxPHdqyiKji4sltW08vObzdAU8pW0W/HRAh9tKh1Tvma82IyNcQyvpxj/CvelTXXTPfCA8X0YCp8iWJJsQrrbrMrXTIkUBsC2+glSC9r9IACO0HXavdY5iWSNbREv7BqjzsjlwRpGqxcJErQ9azCXX/zDvLsBHuq3thPkCOG3lqFTKS0E8Mpwy3ZefMCrUDiSc82bx7LgLgggNum6GGTrLNi4C1dKhsqZhDKEc70UObKABywJaNJaStOdvOQoSq29R6tWRRtcMjCXqaS4uE4SJ6Wa06miUt8Go8KugcQhYAYbsMxHtdMrITwKwhbUWyLbd3Fy0xquS
 2t7+8oK0
 c5axDcIHgzAivCSDjvPBwLv634rIDONuzMscF1AGjQH2KPaVju9RLQbZBc6CfxlfaEUaFGQgH8vN0wlNj9uHYOR+u3rn058WtyuTVICpebPJPaPhRBr5t1BmkDgQb2eNE36Te34ou2/l/gdaAEqESD3ma7c+YOuOPgKeOCjQbSJ1kRayBx0TGC3ehmO7Amcfkf2Xbdf09b2NXVBv8qnmxb615UtqKodhACMGPTU8z1R9CbvG5OSwvB4twjYdTVYl8x0qAHnr5R/aPip4mN0L71TdKHLyoQPd8uROBzTFis1D7PiPNS8hX79cxCV2z5kkRo14aq0hHKJWZeM7F6Fj+NygBbRyfASjWap+1j/bG9mgN/Q0qahEufaGG43muiYk1ejopoSjm/4KxoLRDuZ+hLP3eTFTBMi+pJ9qEM28cKJvWzgpF7xG93+3EFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a `Debug` implementation for `StoreError<T>` to enable better error
reporting and debugging. The implementation only displays the `error`
field and omits the `value` field, as `T` may not implement `Debug`.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 02f93ae1f92d..4335caab8cca 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -19,6 +19,7 @@
         Result, //
     },
     ffi::c_void,
+    fmt,
     types::{
         ForeignOwnable,
         NotThreadSafe,
@@ -193,6 +194,14 @@ pub struct StoreError<T> {
     pub value: T,
 }
 
+impl<T> fmt::Debug for StoreError<T> {
+    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
+        f.debug_struct("StoreError")
+            .field("error", &self.error)
+            .finish()
+    }
+}
+
 impl<T> From<StoreError<T>> for Error {
     #[inline]
     fn from(value: StoreError<T>) -> Self {

-- 
2.51.2



