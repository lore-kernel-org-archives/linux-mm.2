Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2E59606AB84
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NDs+oIZH
Received: by kanga.kvack.org (Postfix)
	id 0F32F6B05B9; Fri, 20 Nov 2026 08:11:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CB236B05BA; Fri, 20 Nov 2026 08:11:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F22656B05BB; Fri, 20 Nov 2026 08:11:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0B036B05B9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:11:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6CBDD80F82
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:40 +0000 (UTC)
X-FDA: 85455534360.21.6069504
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A4E4340009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:11:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDs+oIZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180298;
	b=JplmIA6Oiucc8Li4A7t2rGSwaftm9xp2zdUGzO8OvNjfJr8CU/4zqd6PmqOmQPEGuBrjfg
	iUuQLKdW9vcVTY7HxWK38FWvK3wlkPCeXUa//SeMO8Khj+XXNC7yu288kh/esp16FU8bK6
	kge+BQsAyRgiuwcNbSSodgfjyi0WqLc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8LHuI22szusf4UXGeTOjgNmIH+GHGJvOcdvuE97yqUQ=;
	b=hejK3O+XD0/f1aB4R+l3hwiZQQIiYviC0vqQ7u7Ci88z0ZN/m8z2cYjn2yo2XDcnSeMJdG
	JRenC0LeSxgwfS6qvbO1CVMybsc1I21qlgMR5i9Am2pVYz54SObc6erRTT0VBAScmn8DlQ
	LxpDdJyfEf/JhFgBy8jPDDGOIENtQMA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NDs+oIZH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3BA3E62BD5;
	Fri, 20 Nov 2026 13:11:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B521F01816;
	Fri, 20 Nov 2026 13:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180297;
	bh=8LHuI22szusf4UXGeTOjgNmIH+GHGJvOcdvuE97yqUQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NDs+oIZH6pf0PIfg3WYotvJXRKhXwKgdAdKkOM3o63no4vgbkOr8fQJNiJLvn4x9w
	 Y8xHVHKl/W0/g3QWBbKuEZktuZ1G2kXWP93D4M2jtyXhATS9GdHTRWWRUp7J1eBsEN
	 AnWwQ8uFhtR6SP3+QlBDIrgfd4yz4C38fUXjRxzk8j6CM0Ohw4g42SPkv/eh3oZGda
	 Aw354dMSTvUg7ngUTKzj3yrdv40bkhMYPZ0cAPkKn+bEqMVvJjE2DKqjIspxcRZNo6
	 Ji+y8VUmybBySINrrslmUIIpmjzdFczXfZcyWXTRinuQ/pxgfn6iqyAA+SMShfz6+j
	 TyUnMbFf/fg/w==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:13 +0100
Subject: [PATCH v6 02/12] rust: xarray: add debug format for `StoreError`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-2-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
In-Reply-To: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1349; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=LDqnnXjwNbemXFH4MwCH5RwEl8ydtzExVZLJ/kvwf9Y=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbESh7mTqcqxVhy5f5lzdMLsct0ZQTSf3nY8
 RDvJtkhN2KJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGxAAKCRD6UCkIqsW9
 0IQ4D/wNtEDI/o8Mtqa7hUmPiYz6corHYXVqjaD2UcDKoLsi3eKQxnHWscWQ2o1qk56f4Esl6xE
 VBNYC+V6DCxVVzcuP/qZKUmQJZH5hhdJNV7OROo4JXX4PiSLGlILBFGR65IuBMoDZrn1SpHsF0s
 XxUp9tmqOxBTN3MSc3zF7cAIg9ifCxpSbXFvcCs2rjHrQBqshUwuszQdmsXs1kGerVLaqTxVIl1
 RSPgGH+01XMFGYFpXu+PqUgP2SFFn2NvncQFOJLj9S7Xv0jGBnS/moeMVEFdlCytiIQFRhulHpT
 bQNFOZkFK2I/G2HlvUTiFew/zImrv5gfQSUdf/b3PNYbQ4+5Gc5oWdn73TRWsfDy7AQzxD0KNNP
 6UIEi8FnUkydR5WT+kjQ+bdY/jjUixxPKJjTVDwNApg1UqVfnJH1l5GPtySLzWPLPz58MGC0qhO
 vQJHAdgOeXvQy9Aipt0/BZlExaozDRnhipQmEGkiE3I8oDGXFuWur4EO+jeOLxd/piIJF2aXYX0
 pBPPN3Ory8jXvmc34aeAaqCPkRe7fT91GGIWWWy0Ma/DRL19mxY7T5AwjbaZHubZ46kwLMJDPf5
 wS36++AH7cUU56sxPv68VUJM+syQ0epZcQ1K+RhPDElgi3XDbh+VbuNiaKTU0uKwx5tTWYuY33Y
 v14rfmLKMFPJxsQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam05
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: A4E4340009
X-Stat-Signature: rzsfpmkw4xbfn39mu71m8iibnxniss3z
X-HE-Tag: 1795180298-314365
X-HE-Meta: U2FsdGVkX1+gAOb9TAwJ3XYJxid4PvEDn/o0fC2P1Zu2tfqzt4Hv3BgBAOE7hFGOtwbw0lp/YDotxucJ1ZX5JUuj3rStJ7sLM98bR/62FVDS++Ih6T6JfQuE5mOSd9AuZzA7L9f34M1EN/YgEHqeBJe2xKgg/cDtPY62cB1OFvtjFFA+qGXxOAyOfdFsZxF8g/QussfzlXhtpI5cYEnHtNYLXzYmWUOigFPr2A13FsPtsuyoi9Ed4OrkghkGCXzV9U59v7lNJIvhxlvyImmv2I1oXK3V1JaC1nyt3csk+gDhLMjY5TeJivXmaYmTdnhotFBlHKlA2R4btmjI+ZHdSFUDRr8+izKnM40ZVKlDNrR2i31GgaWTpTBcL6mkYeDm9KE8fDtTKHOr4IVldDOAYC75X3FwbWQTujGJGTq6/wt5+iKYhxp/3U+JzdaTNhcc1OzUHCfaZzM2d2VlR/9wtNUVyWHIFhfouugAHGZZpsP1B91JzwWAsvhiDKfLhypcNjkDlRV247/9X590KCDb3w3mSG4kjAFr2kvSfvqn1mwHOLfr5c2MHUJLi6ChfbJQ+mWMRz2eO1BU1H/RQ0PGjGpSlq6e2lCkY7tLrd80qfV3WmpBZCDIQM+NOylFJ8vRVJp/4IjETiln7I3WRKMaZk0ahELpbg/jLBAJ/Tf826UR1biloH9+4W8NUa2lNND6P1YtgjA6j0KwWsV03qwLNZ7TLc22mz5uG8SMlQISVYL6vWvmhbbWf36SYV6GmKTUIHIQPzksm2A9JTqnqY6mCVqrMXRq6BDkCBA2iI5EgihST3MhjWInl9bhf0Z4HM4HbGYwMISEtcM7XxM9KLpIu0/tlhWMXVUJp+5/dF3wlEfJtAVjKtXSMU+UwTXNwCkVgKg5PL4QpmHHTRpmcdlqFXBXNy0Uo+YhXAojZsBTRgM0PcbECj+Q1MSvUme+sfmD5PCOHCZMrWwCgXnpuUz
 S8bTiXeI
 wGj029OFg0RLHSvyw2/z0YGKcMB5atZN06hhf+gJrCerQ9o8QcDc6MQh8dYmxFNLujqERGd59voDXes+3xJYiPWb8u8+lOv5gmxdeN9lwswGJ5u8Y1njMqqIA7YBOSOChqBULEEGbKm/23ouRjpRtqV/ItUhAFBF2LwtwBjt4Lik0UKFP13tJ7fkUQ7QueM2NXy7TgVl29gAuPIk8cv5Q4ePypQMvF+zfCDHa9rX4bkOcpjOm2yYs0rxlbhxNAARRTkfkof+QqiuHJSbAJ5nqe4kZntg6ku+ECWtS719irHtcdXLc172jKnqXZp6RtTso/lQ2Axor1tRRcBCbyIvx8gt5zr51iDWcBUNnp5Qx8ESjdq2yqv5oyjNFROXJXZH4XUAUrJjO+qsjAicUT8x72TpuM/8/z+Up82lGat6KKCwJsuOax2+UrV8J4hYg9RKutibNxKWsUyPjevigsLasS66GQn9k8WFaCEAMfRiyOMoxtAATbejQ93nkfFAw0vHE4gzVi3w4yy6ZEX+0gqHaSM9XNE8Zw5uarWCT0yHTbv3J1TwyeYGpHsPUlITQoeydq1moUZtHrS6oZUqw/GP4aWPKnfvA6n09NXu52AgfDJb7k55J/1G/AaiahIev/bXKDia4xBHx7Kt7cb3ZLlL5C2mm1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a `Debug` implementation for `StoreError<T>` to enable better error
reporting and debugging. The implementation only displays the `error`
field and omits the `value` field, as `T` may not implement `Debug`.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 4f4b6bf5750d..19581b9dfe9e 100644
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
@@ -193,6 +194,15 @@ pub struct StoreError<T> {
     pub value: T,
 }
 
+impl<T> fmt::Debug for StoreError<T> {
+    #[inline]
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
2.54.0



