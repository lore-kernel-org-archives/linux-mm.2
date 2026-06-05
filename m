Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8E9CD6E79
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 12:49:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D95B6B0088; Fri,  5 Jun 2026 08:49:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B16A6B008A; Fri,  5 Jun 2026 08:49:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7726B008C; Fri,  5 Jun 2026 08:49:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7C76B0088
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:49:38 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D0C06140BBE
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:49:37 +0000 (UTC)
X-FDA: 84845840394.09.C175326
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 13D0840008
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 12:49:35 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LU0JWvzU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780663776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HDtMLF8guH4ne88IjSb6K49/Xx+Louz/o/nOF0oGjaU=;
	b=1Oa+NVUQnb+urU83gOmFWoNgZgFr0Or2ibkS/2R+BRv9SkUcN6uTtVsQGo9v2ZD2epoUKD
	l5M6NoP1ftPk8lzbACA+RizPE23NRxHwbyZ/i3mm9KX5aM+hNZD0FsOcXbrCdVuRbg9h5a
	o7GzI77pAmu42u21LsERc3RKAnE5d20=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LU0JWvzU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780663776;
	b=DrqtKS6xyAxnpGyKNO5lipW1z+gQGVqxrkSLFmhrADIqIpB4RzLmEyB8GRBGR41oHFyOfX
	6b1oXBNuBnYGSVvkaEH5YQFqepgEFGGXtiF9g1VOt/qek2eooHzC+gjE82lt8S2yegOWdW
	vDXG8gZGA1re2fvhKt3P0o/LXl9qJwk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 60FAC601F9;
	Fri,  5 Jun 2026 12:49:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A69D61F00898;
	Fri,  5 Jun 2026 12:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780663775;
	bh=HDtMLF8guH4ne88IjSb6K49/Xx+Louz/o/nOF0oGjaU=;
	h=From:Subject:Date:To:Cc;
	b=LU0JWvzUQfXqvTgu9Gidfm/Q8P40MuVCsx+Z4PJm8xb3w+3YeKSANL5PVhk4CASDs
	 5r5LnUo6KMuHkZvCzyPLIRNBo4ak01UFKd7/r5ws8Dy+HO4a5hcam03ua5u7d/dKPz
	 0c46XfTee1PBXFc+4ON02DrqjXuq3ku7cYDNBB5KjubnklieJ6zWWNeJBUoZShl4pT
	 WpGoubM6JtGAirxu5t058eaVcT6NOWq+Ad/SUma7bdD+bH5jk1wHeLjVVasmpdIblb
	 MPtHdVMcgsj7SFDc6PDhUiMOGpmXOe0D4nN4tmOswx1qKa49w1Z/8HIYP7elI3Fva0
	 saqi+wm/UX8VQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH v2 0/2] rust: pages that cannot be racy
Date: Fri, 05 Jun 2026 14:49:13 +0200
Message-Id: <20260605-page-additions-v2-0-03f04c8fdbbf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAMnFImoC/3WOQW6DMBBFr4JmnUG2A7hmlXtEWRh7nIyaQGKD1
 Qpx97pk002X72vm/b9CosiUoK9WiJQ58TQWUIcK3M2OV0L2hUEJ1QklW3zaklnveS6XCQd37ET
 TkQnBQ3l6Rgr8tQvPlzdHei3FO79DGGwidNPjwXNfZV1LjE7B375SL1QrjqLFZeTXQlikqExwv
 tNtMGT6LDX86m+c5il+7/Oz3P3/Lc0SBTYfSmsjrBlcc/qkONK9nuIVLtu2/QDGna/SDAEAAA=
 =
X-Change-ID: 20260215-page-additions-bc36046e9ffd
To: Alice Ryhl <aliceryhl@google.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Boqun Feng <boqun@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Boqun Feng <boqun@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3079; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=p9uJWucfNKJgIkL5qVSUlbNGwi9u5AIxwCQJDK4aSMs=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIsXNN3kQ4knaub6xUG+ElnSKxnSKJo6LdsZ83
 ikZ3bcDN5KJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiLFzQAKCRD6UCkIqsW9
 0ERFEACsFIAwTdYH0V3Ocmb2DOYetCkTMJ8jHliFnGTeTkRTr57x7fBztphSykWMZLHhWfdCZEt
 OT1EKcdxLbiPojOrqoZCtBMcBq8KWb0cfnttdDLEZJQEHtmHh90zhEBpR24tcf9YHq6nEaCWdMp
 +n8e+WrDonNPrrQubPfijdDywMZOe1tPIwW+lcGCKyHTXLvmYEBqQopaZg+m19adOR01nal5CIk
 gOfQFeragzEYlIbC2uK149tm4h+UpFQAdGMnIv5Qs0IrKdvp7uqhX39N+C/3i8PRSYUt+uA59+Q
 0lrR59JXv8iJAaOVbmTUTX4frko7J9TadybLK2ss4JykGGOEgCpJVYUL1UE/PxDERFL4+8tr689
 hNV8YxiHPFBhcaXkcK/YJ9wP2G6yHGUdPCKQfr1dFwqk1YWbsI9n/ea3o42J5aeag/hO8Y2tWKP
 yNpaaOWZLvtzlrRQk2F+zp+fl0eSvqVJT1FuAoeZ8KrGX7UytvfExfDB1f3YbH8hlTGBdeinQni
 RD747Ta++MfKmXiCTts8su3wZai4H/37wFLOZNm0GAEvgOvrkANT4jTg0Sy9U7FSCo0OJtlnMuB
 VChUb5aPMao3QwTI7nau0jSxA3BupIZzGt0YI1HS/GTW7UlZGNJxHyA6uUstO1CxF/o6UHO5coa
 w5eF6U6S9BhyIGA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 13D0840008
X-Rspam-User: 
X-Stat-Signature: eoua1mcgwni8m4i45ugniccp3rryikpq
X-Rspamd-Server: rspam09
X-HE-Tag: 1780663775-446381
X-HE-Meta: U2FsdGVkX19HHtEd/aFkNzSetcju2oX20pIexR+IHpmIYRkdGxCb3m5PUGSkB2OMUvSVDUy0ZI6Up0j4cZbOQWycQtcgq5TyQEsvB8V2VDlFdgi/Yj0dxk5bk8hjrvkzgJB8ZrmfHY0N3/51thAzEzlnTzWr/qdjLJX9iXMT1ExZNflmU3j31n3GuyMrcyd/hDvO2MX4yAqCR8no3Df++l/zSh2ZUiwhDkEgn1G+TWNBjxpfq82H4pymEEzQPCj5yFrIlHx6UH7arVdykZCsHAXHzsyxD1azvtjX3vzjXjw344Xwn8e6nKlcKrxMCXUeYhav6woSodFF8/WRbDPulGdYDKpiu9MUAHTukGvX4+1kYm572SGiwR3suJUyYIG6gPyrhFOqp0HR6SJN3QcQNQoRhlJJMCKYUqQAU4MiY8z9RG19u9L1qgRLtVMOO9N6wZKDcEvnKui1ww93O1ug/RuDdCsQrjvcM4owUG4qyHilhiQCQ12Mso0LfhEd7zHQuFI5FCU9S0Zyjgv+OgMV+b/xQbfKazljbZFPrwdmi1aLneDnjEISEY8M5jwYBiHnvLjOpcUO8JTRmXhEZP4zVYwBhrTXq5sJZksobgawd74oHazylsj8VLAUsRWqQIDYw/CPCkwcJf/iHN9YloufBXPGoj1x2gY2r/MruqC12E10w+/9H3E3wGliGQBESUOhM4aCMRNQ0Oas4zXBKmnSwYqTzuwpOPCATMWTl0KPrj45FWpiI5ibPevSrc6P7vEzZv+1Ly6v1gdcFxkyQqO81jh8QkBmhgDiiHNlTvQz9VRqdOpIcARCwpraL8hjE9wU0ekamWN34abJzzOuPwOuYqEXdRhxOCmVRV9ivz9IDHAgaM9gSctLvSNX1nI98ED5EeHnmmclYrWo+07X58qKXpFDHzGLWQ1ugZ3nYW9ooQ5lBlqnp8DK9R9spNuRaTgsp/d07GWvqVhxg4vpkM9
 Y7aP2jEX
 N8Vh/Y7SOqVgZgt7bw2HrfJLJs/bA5/VMvxDMBonaa/+cPEoE9udkDhoHkAxnKD+b5Ep3DSek6IuYdByK3NSVbbj0jNv73aZTp71RZXMZ6nqbVK+jNQoFXWjQBLgKm7OwT/NKtfy1FyOQ8HXA6ehjyL0v2HuPpCGEtJm2sqjbbLZ1eR5of4UgMhFCkApxzPDRyCLLDQe9qY3o7J4VbFxfyOEM6XpNwNZAMlqiZqQFfSkY71oy+m2s+o65N7gbpTaEOFSC/Ok+SWSRRu5tIaK5WWJ09BPQ5MW/bnU4CsdPSeFlfNHVnab1+m/CCZ4C+/2hW3K5WKxjTAHz1MzU/WheeAAN8udVCy3bpiOAdxSRDX2hKz/aFCIq14Ob80c9AnuJUwQ/CFSDMzYtwlymVDvMVzybWR4FvIpVrgn+yH6T8Q6/GmJ1GA4IIlHTk/wUrbhgf4BVWPnER9KDfNlCR81dNsumoFAZFLadk53Hm72QXAAt8tMLuEj7ekcRLw7STniteelXgR+VSSMxZb4lF/8ndAcszlTjgERoAK0X5QcQVrHFNm9LY6F9XYHiLKcZZn9K+ckGo7xbuaYpF/LuIDyj8t2zsi4X+wjnL0zIXXNO96Lqod0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some drivers might want to use pages for data storage in the same way
one would use an array of u8. The current page cannot be used for this
purpose, as it provides no guarantees for how it is accessed.

This series adds a newtype around `Page` with an additional invariant
that the data of the page does not incur races. This makes it possible
to treat the page as a regular array and even obtain a slice into the
page.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
Changes in v2:
- Reimplement `Page::alloc_page()` in terms of `SafePage::alloc_page()`
  to drop the duplicated raw allocation helper (Alice).
- Reword the `SafePage` invariant to spell out the standard Rust
  aliasing rules that apply to its data (Alice, Miguel).
- Replace the `# Arguments` list in `copy_to_page` with a prose
  description, matching the prevailing style of the kernel crate
  (Miguel).
- Expand the `copy_to_page` doctest to populate the source page,
  assert that the copy succeeds and produced the expected bytes, and
  demonstrate the out-of-bounds error path (Miguel).
- Reword the SAFETY justification in `copy_to_page` from "no other
  writes" to "no writes" on the source side, since this call only
  reads from `src` (Miguel).
- Rebase on v7.1-rc2.
- Link to v1: https://msgid.link/20260215-page-additions-v1-0-4827790a9bc4@kernel.org

To: Alice Ryhl <aliceryhl@google.com>
To: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>
To: Miguel Ojeda <ojeda@kernel.org>
To: Boqun Feng <boqun@kernel.org>
To: Gary Guo <gary@garyguo.net>
To: Björn Roy Baron <bjorn3_gh@protonmail.com>
To: Benno Lossin <lossin@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
To: Trevor Gross <tmgross@umich.edu>
To: Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org
Cc: rust-for-linux@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

---
Andreas Hindborg (2):
      rust: page: add `SafePage` for race-free page access
      rust: page: add method to copy data between safe pages

 rust/kernel/page.rs | 121 +++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 110 insertions(+), 11 deletions(-)
---
base-commit: 9e0898f1c0f134c6bad146ca8578f73c3e40ac0a
change-id: 20260215-page-additions-bc36046e9ffd
prerequisite-change-id: 20250305-unique-ref-29fcd675f9e9:v17
prerequisite-patch-id: 6c6a7fdd56627293ec3bba61c495f16a0858700c
prerequisite-patch-id: c1958590235ee32d6ddb31ea168105bd9cf248f2
prerequisite-patch-id: c5a4b231dc8adf37e93ebdce308dacbe6a244bf3
prerequisite-patch-id: 541dba7938ba874f8d17fee05a36b1cd9fa2c4d7
prerequisite-patch-id: 3668fd640e4c411bae0c8ea9d986c3fa5d3c9e82
prerequisite-patch-id: da1274864841e267697be9529a50531126c64872
prerequisite-patch-id: c1463b6578e94b56d2bad41f6e614b5286fb1db3
prerequisite-patch-id: a31185fe1abbf553377d6d695c5d206eebc84358
prerequisite-patch-id: 4f392b5736e55a354ec3022644389f89b52fda42
prerequisite-patch-id: b6388ff0ebdd54610010d72a5398842a3c668bbf

Best regards,
--  
Andreas Hindborg <a.hindborg@kernel.org>



