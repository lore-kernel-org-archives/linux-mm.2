Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54D1CCD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 948FE6B00A4; Thu,  4 Jun 2026 16:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920656B00A7; Thu,  4 Jun 2026 16:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8370A6B00A8; Thu,  4 Jun 2026 16:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 711B66B00A4
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:13:37 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16A7BC024F
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:37 +0000 (UTC)
X-FDA: 84843330474.09.5ED82A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 42AB9A0002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMaDa3T3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NPcZxJix8R8ASgeYRVdWoUpgDuVO0mdlMhZYBbXxkJg=;
	b=G5YImoVwqMbmw2v5s15qpXu5YZz9L/GKWJP5cHkcrZ1xvrRoRA1QHRCVQ15Sr5C7BzNluq
	2H1SN0Z9Zin9e0NsucxAlTNTHGdDt4/JNmA5RbTUEv0n/H78UVymoWekDd4NkGXzp/upLo
	RLE2MCsxxPrY/6nSgouFpu0hGkem62E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NMaDa3T3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604015;
	b=r/eniSjxxqhD4f3dGR6HGl+5PBEmzm2UOmIc7ko2/JDc9+N+H2p5Gkw2+g/+WrJGCfP2EB
	0tE0lTRoa5lAWBTp+oo9C8HW56/fvaoCXSTjTZIYprwDWYiylCsAqkvmWNsu63+dhdb6nB
	H3NOehobpNgl1zPAaJbXql24KJAO/mo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FFEA432F2;
	Thu,  4 Jun 2026 20:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EDF1F00893;
	Thu,  4 Jun 2026 20:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604014;
	bh=NPcZxJix8R8ASgeYRVdWoUpgDuVO0mdlMhZYBbXxkJg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NMaDa3T3vyLRFmymA/V52rXGwDjbP7qMQN4Wc6U9T7dNibSv9rS4yWTPxKF0xFzfN
	 dFZOd0Y8wfML/F5N2JdyfxqQMOrT524BxyBbUKRKu4/typQSBoh7ZOcQC5MdBLbD5r
	 C9zJAYfKCjEVkzTKSipsvwoebejBXmrm2+xD/6QwEn4TFfc2wN8StX1Sz9WdD8podp
	 spMPdFZLO9/8wFf7L+vHYI9bVVvTww+5hLMn9V3TZzZQohZXAxPSqm0SM6NfrnEkOK
	 pX49PkQ8gXFAS4hFTKiK9du8Dtl/oCH7bqwbLMSjbXowqz9mGLhnspH9Kps2IJKiI9
	 ZKCEb3I8LC1ew==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:20 +0200
Subject: [PATCH v17 08/10] rust: aref: update formatting of use statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-8-7b4c3d2930b9@kernel.org>
References: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
In-Reply-To: <20260604-unique-ref-v17-0-7b4c3d2930b9@kernel.org>
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
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Uladzislau Rezki <urezki@gmail.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, 
 Igor Korotin <igor.korotin@linux.dev>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Boqun Feng <boqun@kernel.org>, 
 Igor Korotin <igor.korotin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=751; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=l5c0q5tDqBvfUKptiUH9ujhgGaCW4zeIf26teZmhjjI=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvtLrwkUygT4paQMSlPzGAJcExHlfQf51liz
 OCOSDABPJiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb7QAKCRD6UCkIqsW9
 0J6WD/0Z8lBgQ1MuPW0rDHqnrcon/KFXZUwq3cjDwyiCbtTXQiqqqEQxzoFn4yoVsgCmwPqmeOm
 Cx8DTKkFZa72O2fudXulQnzc7oh1qvTtZL2jIN9XCKwsrlO7B397BRIbW6DZDciF5UEjT2f2RKq
 5zYNXCH8IfEgUZMKL78lTl39Rcp6XKKbUoW5PEVlEm73+SKiXHxwzFfJDkH9jcjGprTlztQ0T/4
 DBj4iiOWhCKUfv8pxas1yPG0xsvkuhy2jH2bpT51pe1X9kWG7qV62tbl60SpN/1r4D6NS08pgtE
 /jtE3A+Q+2Ai7gLh+sEwFFLBptTVRkjy+rFiBivZDSkpYmEh4Z3a+FqILoLdN/dcb0zMcUra4a4
 vdzb2MagQbOIERyflkW4Apz1YcbHDkL/895OLyzPFZKeEu6BACgcnvSr7JOca+rn3dccghtl9vs
 5lbeD662E/jwmvKHa9r6/35yJ0BcM4EZcPeAFvpbHFJjgNA2CYXmZLjWWEuw3bS7+DPTVPSN1s9
 kZ8uc2TYKagptlINpzFfIOqH2ojTx4awhCIuHNDv2K7rqJve7fI+WZewsteU15iOq9AfRec34+u
 Tdpn/pMgwdni2r7UW1vly0W0TNj1enYARL7mXpTRJR0J0On5QpNOeJfBJypkxp5AS6MB1G61dMu
 wuM844VmxxYXIDA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 42AB9A0002
X-Stat-Signature: dsryo8imxard935d89dt7fw3xmp4b1qu
X-Rspam-User: 
X-HE-Tag: 1780604015-848727
X-HE-Meta: U2FsdGVkX19O8o+td32A+6fxNJBQko7F2KYp/g5NhIuFTw8nBy0/h9wkQTJ/G5sASma2WGvkvRzrkF4TAXGyDj4tOg8GcQ9+ZSgxVZhTsXiD9wQITAJSNIauxydFxNk842cwg3mx/XUncLTVEuqZi1RUvD8LzxzzJIqzRrkPllK7HpP/l/dCMk2AlNZjEp8OqC28NTPMSXg/y/7gE8RGzy8mmeJlccJkkN6ssFJxjBSoiHTZTC3zD176U41DdkUzp7p+8X1Gk/O4cC6lf9mIsa0SBqcdmQ0EPO44uu+omk472B2PmB/uzOBbJ8gW0DwZInAaMr+b/PTVrjH9rcKgOPPjO0unnTeKwSzsPuCPNnW1zGgqvMJzwY0zJo/PWA+h4jB5P8lNWKYT1ABFAKPy0BtXCSLgNPxKHv249RcJDltpfa7pjYB4lZLRuRax/l6dYkEIo1S1xZfesxhvffHf7nIAb5/lzqQ1cFIBTukw6FAA+/k9KoaD7EM7BMW0mm5WNGpWWScMNkn67G1pxoiy7LNB8gWwpflEwNSwffuTacCunspAFHw2IT3p6ATiJDdaDsY8XaG01bSJhfphvPwX1GSEMNooIfkaTy1ww54ZY1Tv84DUn4OMk4fVVP+mh7JDV4lm66SAysx0SWfHDskhIJqZC5P2C4leBGhkRrGOVimZgHJX6HxiM6++nmSvDQ9NYv60PJmRSdQPJWAb1r7FsNaE/+vgR48AEt5TsGRCKcGFCY6cNzRk4mIrUtCifCczQNJYj/NgLiEm2dkRws8lQ0U1DVHn2M1ImeBNOmU1Oj1kZEcUGDguqn3NH6mPq4L4vMRpsXpY8CdVN/IFOPxFQUWEA6uQMGWJe0+ECzGwtdj41GZRNhE9HXClmRq6iW88auUslwAYfgi/b0QEmrC43lkHkdd2IuDorluvAfT2o2J20OFhs0Ec9XY4oGt7qk+UwQXvOGKNd/Z8pAryHkv
 zCLNGyNy
 jsXoKngjwn/GWrZtmFVeldnWQNPM8zngy9OTdeGAHQtmz5VOZHK4WIwrJqoPjzu493aazAXokrvr9tqRI64XpYo0H/tBY77e/umhWq77T60iMJVJTatbP+fICF32NrBg5qQBeDNSpnXT/CkflMNvfheTRdGGuZsYb5GIDSIJtCfRDf2NiARXXlQ0d0gOvUS62cozA4X10O+pBN2Y5fngaJh27QnFgJecdlR/pPwfsLHL8WdjoCHyStNkdnazXc0bU+30cFBGWj7kD12mXMndNLulRLDlD4d6GNmNV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update formatting if use statements in preparation for next commit.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 7491382bcf29..818c84fa923a 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -17,7 +17,12 @@
 //! [`Arc`]: crate::sync::Arc
 //! [`Arc<T>`]: crate::sync::Arc
 
-use core::{marker::PhantomData, mem::ManuallyDrop, ops::Deref, ptr::NonNull};
+use core::{
+    marker::PhantomData,
+    mem::ManuallyDrop,
+    ops::Deref,
+    ptr::NonNull, //
+};
 
 /// Types that are internally reference counted.
 ///

-- 
2.51.2



