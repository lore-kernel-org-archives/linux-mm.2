Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58B4FC55178
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66CB6B0089; Fri, 20 Feb 2026 04:52:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33DA6B009E; Fri, 20 Feb 2026 04:52:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4A596B00A0; Fri, 20 Feb 2026 04:52:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9359D6B0089
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4B70813C152
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:49 +0000 (UTC)
X-FDA: 84464370858.22.28322F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4A023140003
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Pa9f/rFM";
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581167;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ntJYUYqYp3Gn7FI7pRL2pZqwu0nCn58LEkukXjOhJQ8=;
	b=cKrTDk4lLKWyieplFRrOz2ilOebs3PkZyQohvE31QKaACRYXdqU4t5tHRaTYg+2hWtn//9
	sh4WjphLI8yfylL0TFqmP3tpoXg9QslC6Sr3r8rBgtBnoX8hLpYxq+Ux4c6zo+o267yHss
	g0ELKcA4QpJvP/IxvTbj6lURxVCS0hs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581167; a=rsa-sha256;
	cv=none;
	b=ESHQzkeg4LSbLiNxyiE26EsGwGQBnUDXMgIoymziU2Fk/QSpBSsGs2PwFIo8fC3yFMnyqc
	PdhyNdE5fPYdIKENUP7a7KIv+WkZFrYJRVkDa49he/3kqpOOg6+O+6VXgrbMPS0S5skmdA
	n8Wel+axsJtGC4yQGaSDf+Ya6MLpQE4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Pa9f/rFM";
	spf=pass (imf26.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 290984377F;
	Fri, 20 Feb 2026 09:52:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952BDC116C6;
	Fri, 20 Feb 2026 09:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581166;
	bh=4kJUgBgTj0V7kRaDlo9MltCBPjRgIT4dj8eMOKXfB5o=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=Pa9f/rFMzl4E/wPD8ciUx13iCfAgUF6vmSFXaR6Ks+u5bb5DAJXeMviiLdxh2MJv8
	 8+qc5hza/6VMGw4cPNgIQtSvcyxAvv/XWpRWhKCTzzjefbOVYgl2Bn+9VGuU00cEAc
	 jTvBr1iVHBszyNOkPQO3sX9uTj+4qv9eIpWpokFIoB5BYxSyamUEEtpnqHSLtYolX3
	 imBdySgeUu1FiifVSkCzKnQQ5D89I3lmT78VRrlGo0C4YvUidrWgNYFLXT3STRDR1B
	 TCUlRIjeq31xVyq9aJ1FHRa6M6evLAQpUau+Rs7uGaiXXLTqvstat9/ewV25hDKnY2
	 FyieTCY2HPk1g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:18 +0100
Subject: [PATCH v15 9/9] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-9-893ed86b06cc@kernel.org>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
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
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1098; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=4kJUgBgTj0V7kRaDlo9MltCBPjRgIT4dj8eMOKXfB5o=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6mLFWJC4FUrb2akl8BDN0BW5kYHddNAH8R6
 ePI4Cw2p8aJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZgupgAKCRDhuBo+eShj
 d4hjD/9a6KYUv/3QDTCUbU4jBZySYMrlWTE3KyUKD7sMA5hI7Q0Tt6utA8LOxT6+fWgt78T6dsP
 YLaKTrcMsbBbF9ZlaZrHl8lklZikAR4xxXgnPSPGr59l/ggK4Mo7kCUQdgwUuC8ahkpgb3RVcUP
 l5OhLwF21W8lWV0hEx409t8Kzk3WeW2aOLHrkVtgPaBMUoTkJvPAEdi/M7QMEd7KvTGtBEN10Sd
 uhQioHELdqQTvuoGD/2Nklb8dMjHCDjnPf6DJyD7DydQTfEn2hjA6jQdq7K8J00MQuP/InZd1qU
 EMO1sfL3nqfaUHKHOpGHjKARDrvThnL2r030YD0tcCw2YZMWv5umGNAlyGF1CNCEDVa59lBEGmW
 owSPtNvf3UrEKKpr7iymtNmm91VsmBBLGJ8Zwg5nZHvn44w2XR5sr6sXo0Qe5IlG+RZQPG7y+cX
 rB+YoFcD82kVzVU3ZT/1RJWC2PZPOs34ie+0a+iU/I3k5swQfcovtHfPX+UM5RXMZmUiFZJmvKU
 FWReMNdU9IC65rTvBqhTBOmM6OZJu8DGdagZs9ZIcaXPj84ZEtd+dYi7mQlLkTxwBnCjC0nwacH
 JuKEKkSC25+lzZDp9QXvecJqUf1eC1gnMOjlYogawynT0QOSpqelvJDq1GJeBuRYH3wCvocTQ8u
 WWDeedFFS03kT+w==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: w37qwqy4befjbxpzsn61sjn5hxoo7ki7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4A023140003
X-HE-Tag: 1771581167-444179
X-HE-Meta: U2FsdGVkX18DZhGLpgVHJ7B4991RPzXMJYS4HZqc6LA+0FCFoqZz21YFZB5L3LBSI1Uw4BvR4ONVw7IPFmPn4JymNP4Mx2V1F/e+6LT7CZUg09saqhd8maXCHOsU0+D3FrIl3w5FUJ/4V3B94j2gSRUzI8v5UyRLNKGHgEXpZDmyOXeK/20BlHkyk1e2uuYHiyv03a/E5aFmm90OvkFy4wLi3+aq7sRIY3SUtpbSe2VsxD/p8CsDAPdTzCY2/WdprdeTMtmZYzXH5ySh2qFOjIbExMnQO/sNw3CFvSgV2h12MewlSUne20aaSKCYdlLQDN8SoQojGE1WOg7wgsUdEf+NFN9DYNMLEOzmsVYyYSMgjuTt+B3JpJMy7QI2Icma7kMgZgsGI3iIddCWkkxVq0wvRkXvjEa9U4rqOhsP7s7vtoiDHOsOlQyl/WzBEegFN+z4OhaGGwNWGarpYuT4RZXd2Z01g3o+jAJaPe5M1o9wk8nADlS7+AJjSPEURhMyE5DZGQW03KDPPSKg8c1B/MXqYEdpa2iRhSoQP0bkmzLb1MPnXA0LdCoSc72YiH+L+ZkNQ/2WyWmh3IOtyUECIdboSNj1/XVdIScZgVrnQmmk63mnu/jy6UT2niKQWdL+6naSAdxZTyEC5lAEcnIHwDUVx+K3h1tTUaKBemC6SO8pNi+kIUmIfnZ42KtXApxPWPyeI8WWfz3yXZSpT3fwgPO6oYpebOjwZa+SXC9dLEEDEH51t2djvuG0NF4AEt+hynLUXaW7axGcKs9jEHwJKEQnB4ePe+PEWGXmVxxE1zpX4eGVb8Qy79gVRK2Voy9trekf7NLFKpmM3PkqkaHtM1rtB37Oiic1iMTrcftGxOylYfgFh2ot1T/sUGMyGSqdY9KmVaHzufPSRhYt4XgjgI0zSbpTWIhwHpyMAO0T+EsRD9svOc3OTiizBvX2CyOCDYz7zbaAqXnz3WeX/A2
 PCuhO8Mf
 HyATUdN22463zOKXBqCLO4mn5Jf+VLyE7juxoiq4tE2ts6wfIRI+HxJilrD3JfsrnOvA3yCNtPi9JGwdatVohyBWzAY7YmQV6Vc0ZEVJmGzfoyAaIdxAwWG8/d558BsZBWV5BMrcasFyF/XX2PE2Bi5wGHWD64/kY5GXHQqrOHe/53/4vYXuQTHjd/iWSpkGdyhTULAX3M/3g2wqBUFceRghOzUBtBQ/n1BdAL0kCPT1ez/HEd3p9KdKSu+/ZY28z7QriRgqIRkUK/eVRUcvD4oDDi5TfX49O8QNTAZ3u0fQPBloRfKHDqe1LhWV2ntnaSsuxZRC2pLW0t5Bz+jdZyH5vBq/t86inNRzYs5xN+FjmjU8=
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
index 4591b7b01c3d2..803f3e3d76b22 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -191,6 +191,17 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be valid for use as a reference for the duration of `'a`.
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // SAFETY: By function safety requirements, ptr is not null and is
+        // valid for use as a reference.
+        unsafe { &*Opaque::cast_from(ptr).cast::<Self>() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



