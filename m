Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C18A6E9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:20:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3037B6B009D; Tue, 24 Feb 2026 06:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CE2D6B009F; Tue, 24 Feb 2026 06:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C6B56B00A0; Tue, 24 Feb 2026 06:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 062C56B009D
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:20:27 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C73BA1A055B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:26 +0000 (UTC)
X-FDA: 84479106852.18.30C6B88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20DDF40006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEbr9SH4;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2fSMlQoIFoT2xdhXFxbon7gYUvUSeDaognlIwj/F26c=;
	b=V14X3PAFvp8LNUOkLII2skBLteaTi8IdWYcXf4h1V5UfejyHPifjK1h7G/9gv8oH2JKjHP
	gL3xvpaW0BJDiqV/rsBGFnxUUnm4vMkVz8KjOKv+KOlsCnUuyBxD9Lcq4feKNTBe8OrVXQ
	ZNnuhBT0NpLfybCf3a69tCQ45Mh1Gw8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lEbr9SH4;
	spf=pass (imf04.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932025; a=rsa-sha256;
	cv=none;
	b=l/lJFCt3og+U0RzfuF/+AnJQayLZLKTfiz83ce8swprMtGq157LObO4fUcTEJKz12zfmho
	4HAEAH5tQKnfRH8mAf66Bgew1r/laquLOWgXwRSflaAmfenHEDbYIHa6cLnCtC3eobQBAn
	Vqwf+mpeB37NfYKYN/FqGMF+VbG/Zfc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97C966132E;
	Tue, 24 Feb 2026 11:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953B3C116D0;
	Tue, 24 Feb 2026 11:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771932024;
	bh=u+CxE4WAb4lLYs646rqUMrYESFoSfCpkJ/yBahV7oWU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=lEbr9SH4g+vkYJTX1S89jMNlf3p84ZRU/v6+jnkKrqULJxEJdYlaFLJCqESxXcBdB
	 95iKFGtV5tH/t/0vNO+wxU1aDpsO11zqlfymtcsNTA4YvmO9YR5aYjFFMj7Ln8loPY
	 rEgIKnAaxeg9kAjJlVwUqwUS0bEBBgWhB6fED96nwJgySVJezf35zzy0HLBtD08lQt
	 18In2j581km/tx1LLr/t4qqKAv5qEGQ1bpe2ctkMSNIPvMoiyy72CIAU4GrmCyvsRy
	 yWMO3Jz5aMRBD1stVUIxNLV6DUau4VBUlFtdK8KkiaW/QzOk4ZH4TKPq+YaDfDzI1w
	 ytRWw5P2ZZ/YQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:18:05 +0100
Subject: [PATCH v16 10/10] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-10-c21afcb118d3@kernel.org>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
In-Reply-To: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1083; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=u+CxE4WAb4lLYs646rqUMrYESFoSfCpkJ/yBahV7oWU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj8LE4iboDu3XEQEDgUJPpBWv16iN6jxTcXc
 nc4VDozC1yJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I/AAKCRDhuBo+eShj
 d3r2EAC9HrXGAN5UQmY4yPBtdIt+D/gH6jEj9h2dHBDQcF6dzQMjKgBxItt5MpEuDUUqRp1qYP8
 If2k0oZc8AYRDlxYq2p6mzw5+29obQYMI48OgM8Bfv5ZCxLkp/LfqJO/xM/TppNhuO+krTmAShb
 MCl0orP42ytvBWvpv+kpvZvNudBNTHqwxzk6KIC8d6Z0OqxgLrm2FYAfzdgre0WjeIRPhoj4yo5
 Lc22cKyp/OyVtDzKciBOk7U3Dqo2qa5QbrgWdeR4srzD5HlhiRGErLc4geoJYKik0cT7Tuh+l9I
 ByT2s8DzyaJBwaWEzC9klxmxn8O+D6hrUFWbBSV0Km6LY1IblkmwNJOI+yHbB1vpCLe2+Ducl0f
 3oav38GaY3BIWHZOz3/fU9i4RQoyFKsucZoj7GdL+0I29K5W+fIDEiVtPXb5VwLlS9uuOGZmLCf
 TArqmlPzTFT4FzZY5BIgFAJJ55D0M0j7VpIUm/zpXbEyRF5BXnMPHjxGxEQcMZVtJBDrNt+mGkP
 o6hstg9wsEObY5kFIUXlLbrqXnAEXEOA8z96T7KvE4sHClZAEUouSvzlF/evoKDuxwBvArbB0tN
 c+9pkL/JWcpGsrJzdlXjerAmFT8ic9gqMnxpaPOlQ7WQTf6RGMqRo+mJ5SnYrtDuJPHdl3QqHwe
 fXaCMyhvccgrgVg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 20DDF40006
X-Rspamd-Server: rspam02
X-Stat-Signature: pqupbo9su9yro8tdpf6nnzz8nrprtnnf
X-HE-Tag: 1771932024-883462
X-HE-Meta: U2FsdGVkX19XEggRWd1QvMdIDL5cmBDawrKs2zIOEaeZV8Ttm1IQHDnYs0pDxlhh5uY0DY4b9+QAUpcKEIUUYPVfFGdwIt+/7VvalxqBTeEkxZp763eXEQtEPWyaxr5ytrUipnwnNeCaERYGKLAwDEaiz19XcuEIMDxuJomie7zOIQPQZR8cOmmEh7pWruS4Aq9XrcsPCj4Ar/QCUw9t0n4+Vk6+6aVss5yTYTe3X83lx9665Xet0YBD/taYTVtbThFnNrw5unqQXTUheSHlQx3OZaa2uUBZQwn5awlQu06wPF3HmXJz/K+lVvTOEsV5PyOd96RzTbs1Y9Y5wZBhcUDyP4k+QN/E/hFy/5tp8qtXUjxso9u+nIQFuVdXt9KCGHzKb1WBolOWoqFl2UnnqTchB51ZrymsQnh6W5ONt86L1yyhXVjSD9iSnDBeXx7lh/JBrxcBH/cxY5hATSHWuqXR7YKb+Cl8WHRqhum3kpwawgfFHK2AHfvX3xS1gjhfTvlsM6TelhoxH4etKW0Julh+OT7DBz7S/6GtrGuYhxCB28mWMUlHsO3t37DBZ0HrPFOvN0JMkC04Wr2dTbzFz3bmih9d+fIsdJeWCAzGxdyztMId+VhAqKJgATPxy4BktsTHk7qCnvkaWlQtUPyRLrV7/ag8wRtZDZ4NZltNHUPfD16iyAU7lCb3KZnqespZkdEFDXjwJZgqrquwnl0CN5Yj/AEoOgZhAmkPY7OWDsDyoWSGNbZwBLAQn/4Ce7I8mlASa8KB2b59y7tatcqe6Jrz1en9Rxm9aT38bqyM+3KxGe/CI4XUS2dszbZSU4+v9fJpxIHGjnIk0Gqc4eB0SAj4UzNhvEc9XRovYbWE5PWWkzutYeS6QUV9pCzJfo50z6hMihnMW+e9CYSzQHrhFaNVA/JZJ0Elxt5GEMh3XSwMLeUMthCJt0ZuIDlksA8K0ZnRWS6bWTnWsAYy/dU
 xwAxYyQK
 s4nHI9mSLYhqaIBb9H+qvHw5f2XjzY/ryxiwnghs4e6sTjRz04htBuJmRXvpBKLLh6N93rQxudQ3cpNUXATNruCMw1zcEcbbFvDz2u1MUTXJfMZLJwsYAkojhfjgB16W7xoQ1Jcp8CYmmwpgPwqjY+VWI9joJQaogHPIGd6CEtGPNYHFzCtUUrHamzpEuC6KVlUhPWR27/s6es90bFZ1wsxiHxoUotxJzKByIQbFOudRs4YdIfB9ZXqScK1dYcmqBQd7HjIAcyTOPp/K89nYYNfxdduMhPOKF3ZMSZXuSjzCOpgMdIH+qWNw5U8mZTBK95J/SnpVB1DCIQEM3ZDOCKoMsRYsMp+IJ4LDEjPohAk6dM88=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
---
 rust/kernel/page.rs | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index e21f02ae47b72..96f1ec125f043 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -192,6 +192,17 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be convertible to a shared reference with a lifetime of `'a`.
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // SAFETY: By function safety requirements, `ptr` is not null and is convertible to a shared
+        // reference.
+        unsafe { &*ptr.cast() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



