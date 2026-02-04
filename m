Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DB95E9538D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:58:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F6F6B0005; Wed,  4 Feb 2026 06:58:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6756B00A3; Wed,  4 Feb 2026 06:58:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06FC6B00A4; Wed,  4 Feb 2026 06:58:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0F6D6B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:58:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DD1C1BD70
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:16 +0000 (UTC)
X-FDA: 84406626192.01.600CD42
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id A5E76A000B
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESN8nuz2;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9Zfvy7nM/NrHVVX1PT+lkagG6YqHQTr0oHEXLQMyTIs=;
	b=K1KQd1kZacTlL5X9oMTiOF67Movy94k5T7C1RKmbLO+tR9uXdNfkC/GvrQRZkmGYOj311K
	xKflG2qp692WOa49SVpqqXMa9zDZ7fvkMsHKTRmu4C6uKAaFbUjEFxVI7v4jNGFWdjSeaK
	8+EBizeAQrHmYSa8T4tXL7lddi9zW3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206294; a=rsa-sha256;
	cv=none;
	b=m7DVrajlVZsTaNAm91FIdIASWfUD8QB5UYNiHmQx4re8QSJ2RP0UiHDRpDNvpw36zZ3A/t
	ZCS8ZoP01Lkmo/cxm53bJ6UnPBab07Xa8QE9KdzzGB+rVtHyQa4+LWYX9FULUIJp/xqSDU
	LZWCcPv0PGsKTm5sixnOW3hMJ3vIp1U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ESN8nuz2;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 300A7600C4;
	Wed,  4 Feb 2026 11:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E78FEC2BCB1;
	Wed,  4 Feb 2026 11:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206293;
	bh=PBOESvJWRqEQ2bmBI+MqZdyLdwyA7OsD4YPXBLOYQLU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ESN8nuz2S87uQ84h21rrTo5WOEHsLs4F/sXyU5GGND+4N+g6BhMrcVYsicUjk8cGD
	 xHqIhAIoD+Qe6eEWHfC6tcbLJYTrWASs3XNZ9GL5g8G7HkJEd/9MeXdDlkgEyncwBp
	 xViltxhwMzKVxH9JWNNVCZiHwfpczGFiJlypHFhpSTKrxqW9W85Elz/RSLB8oe87JR
	 K2yZTbj8s16zLvUCpu5x4utzXyoLKz0dDcQKoT+fEKIDoPHD2QS62uUBvaN8+yXKbr
	 ssOC/AuvsbiwhuzTNktYS7JzTL7cTfH2eIy7TJN1Ynv+wCm3HsXSEs3RKnFIcq5wfx
	 hzWtW6SDAGX2g==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:48 +0100
Subject: [PATCH v14 4/9] rust: aref: update formatting of use statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-4-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
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
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=753; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=PBOESvJWRqEQ2bmBI+MqZdyLdwyA7OsD4YPXBLOYQLU=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQC8WXId3BB6udifTdGRxtPZJjj8e9hx+zAu
 QOTwRyR6O+JAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0AgAKCRDhuBo+eShj
 d52WD/9JR/g98fdUOY2A8g+rGpmdLfgzdygQocbFPvSVXyFv38q6LeptynGRXH328+Llt9FMs7W
 W2Yyp39eVHkhsA2sBR+RmPm0kLhpQyTlCas32QiZ3BVU0HAS+NeoBelq6HB5MpyCIBG5hNt69lI
 YMymMT9+vQZB7AC1uaReCxdkqSDFxmT+vIZ4589KpZWzbHR4M6JY6XAd57pdg1k1tYuzYInaS/o
 Gr7kW3zIy9YG3zEpodF1SmwQWaf///Uzfi2SZRvn0dq0HcEpzpd4mSF1VuJ1796efe/UpjBFDoz
 YXaGCJTZwHy9B+sFzu82whCwF3hi8cPX2I67pGhDU4vkQf4u9sqX7uHYf2pz7/SY5dbqEF2gi0C
 QOcESpEP05JCslZh3vtiZybsPtBB3KF/fj3nOisEL0YBmhgfK9hcAjkzuS5NX1VnclZPiFtSEtd
 aZi8BWjWrIk/xl90Dv/dtp2EQpiFJc6RGeXXkUJDRwNeeIDCbtcyIQrHTT//IwlK+ab8RpATME5
 GScNPXhVoGC2dPGlmtZ79a4nn5XS2smcQfmrUySufpWh8FpTCnjZrOt/fWdUlobSnPHfXe643ws
 KYu8SkPindocqSr854POQ9gNtOXnfk8cjiAszpDKMwENo5OhLW60YELBH9dPsw4iG3BiKQ346bx
 7t8YyWd6wkWbBeA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: A5E76A000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 7yua17ji9y6sxoh533q8qsq94oyc9mqn
X-HE-Tag: 1770206294-127106
X-HE-Meta: U2FsdGVkX1+baN03Yq7ccFMBab0ZK8EAlRGZRUAXamnN05VEtD7nAZqD+0OarAYkMCf0XzFkO2LJAJR39WNClBNyxgJgv4V3SlMNNB9GHAK2+M9mV3yqH5SvZzwV72zfWX7VLGubWHvv8dkYkxQaIguPWr4Mcjmm3/xr1aNINMnBlsybNPXXz/9Bsr1/t854Q/iCo3w5FMQTc1pa+X+pfu+1hzuFrvu70VWKbp8k6/s1KdLSvURU8OIL9jDEM1MRRe9fNocLperaXI8mOD//t+vtEF1NCYszctoNdYmBjbCm8T/rqDTfvCa+p3fF6LqvGuYMwvkdngY+4qtMBBZbfU0SEEUy9aLmo9Ucn5LcMXL/JFvFD7aJWYe+P9Qra/JX28iE2mbdmepje/VcIxGYWPr3iPRoCfGFHe+PPp4zahEJdBhEY75XNMJ6QvZaUocCiJCzH/URsrMczR21iSW9ENXORkDEsSsrpMZdxEsHOx/Goz2JqqvAvvJ+XjHuGOLntfYzl7OH7oHJgyNR5pvgFjnE/jFFrglIc5aiX2GyFAMJpBZNlbhaWlgE8DVtHCDXCulZZOQVoRRjYT3qhVjnxiSZ/1PeCt4TVcLtju2Yj8w9M56f9pzZdNh3B7W1+RSsEv/o1CFlBljGL733L8inN0ONk7jChH7I41UcgaoRTxh4VssZOqNJ8h3lOgtvIJRtbCY8Vv5G45PCuoWooIzPY2sa/V8EtaIo6I39DNPCopuFHxJGG1N8NTLuqKGNj+n6bgnqAKHc6pRctx7DjhzYoZ/9cHFRGmwA9Nd5xCYSM+Iaxj7Ue6O9nyOKnoCzwiIF23DG/5L9F254lDApOR08vdcX/d6RRWiqKk13hMxe9pm6Zvmy3xdSFoExtRZ9zQCo8jfaeM3s+YB8ZBS987lcPQ+1NZiF/cvGbKgm0hfJKRyNlIkyGQL8G5ajjRAqXqTugI4l0/rvGYFMKtyCqsu
 UN6jyrct
 ehDQcgTuVapXRb/xWsSg7sYIgZkUA8ekE1Yxv8GfachyTPsZh3ETQFkVOxTVSmfp/ZQBIRfAkt2y5/gvchyrb54ob0kuV54TQn0N56o+CRygPrhknaLbEbrs4IryZ9/K6U3pw5hTLXsMm5BquMrz73dgBvaKe+xbpRMu8KKfgOWa7ZcWx/oz59PUARLF3nT6r4l5dVzemzJidRJ/Kb59P/FWNc139VA+EmvXBByH96wpyisfZVPEjUPmoYzt9wUOnM3OOmxuCd6fMdlzvC4j5DdauGi4f1s8FrNPm/4v943yGrVex4IGQSVg0eA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index efe16a7fdfa5d..3c63c9a5fb9be 100644
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



