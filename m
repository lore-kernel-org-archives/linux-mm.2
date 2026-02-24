Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C3CBE9B24D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC1D6B008A; Tue, 24 Feb 2026 06:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CD86B0095; Tue, 24 Feb 2026 06:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DACA46B0096; Tue, 24 Feb 2026 06:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C83DC6B008A
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:20:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B3928BCB9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:02 +0000 (UTC)
X-FDA: 84479105844.10.A5B9FEE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9B647100003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HdqzLYlm;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h++G14EOXAu7frtr/xiOgmHrxhFukQhtLoK8wJbuqz8=;
	b=KmoKopFOgGQihMlKOoka/T52/debThzQ1lWVl7DykqIhhTdUJJDtK7RY5QdQq16Tvimb99
	1eMBbwPfBYq/P52M19rF8YtFqLv05eXWn/ty1wmACgk3bOugVYDLnGLT+B8G0KpmYduy9M
	nJqRfCZz3TSg4fE+I37zMJxudzLncLs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932000; a=rsa-sha256;
	cv=none;
	b=mQhZzjU0ZdBVffdxktf52GEFjmh8C/VppuxAO3+W7PtMz/ODkHHSQRlE5QsPgV+S6IvikL
	hLAnaJqfRF3LuRb8qbhgdEh6hMktRxrXIoKIkLISrlTUTqb8QVN6vM0gBZvmxQw3R6leHb
	HNeUE2JZUr26RfkgNewr1HqAB4iAeHE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HdqzLYlm;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BE23F41A9C;
	Tue, 24 Feb 2026 11:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58D8BC116D0;
	Tue, 24 Feb 2026 11:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771931999;
	bh=Cv+ro0rgKKTNndu1LXkpKQFAsbhVDrLwsjlr+g88uog=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=HdqzLYlmRb3TVe2hLfyaAeT0QbXfs78M3TRb3E0NDn89wwEK4fRY5WmX/jrbvQDL1
	 5efYY+T10vBU1kIR5uTfVO3tiDrUgzG3MA9Lrwtrwz4HKPEbbPB8bDxQMstX90wLNe
	 7/caSsxNgBpZvhZeSictKOSRKfaRaTFAzeDwXGE31oo+tEmVF9c+kKOlzDasQD/O/g
	 Df5fKMfSAXTsGZ4+ZBGt1VgcrMx5lTp1WYHN1ovyzgjrqrFdWR6h/nW9T9Pwkz4Uzs
	 +Ypjx0M41BhOmxFpplST2zMxs7sA+EpkwwuD0XjHB8jvF8sgOKiS/IjVU2yAdOvgPp
	 l2F1QjiQtEcHA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:18:00 +0100
Subject: [PATCH v16 05/10] rust: aref: update formatting of use statements
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-5-c21afcb118d3@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=753; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Cv+ro0rgKKTNndu1LXkpKQFAsbhVDrLwsjlr+g88uog=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj3SgJinL4mzNCGJB/VLOiKjYIotpZTAeQ5d
 eiujQ/x9mmJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I9wAKCRDhuBo+eShj
 d3ysD/0XSb30S75V7XwmTKiRWjUL3YRT0n+cqNFGirejC2hDTAlc45ifHqn5BqDHPpxlN4259sn
 JL858hlbzJzoatv7LAvF11urCZjNWN6J+hdE6QOW4BHuyJ2yLNgGV676GOzDcToOmfPOKBOgNav
 tClWhpadwI3oyrs+v8v+kuwlOCEl+P2GCkpjQ6T8UsDk36ZDMF37vBtR1JG1J/hUUx0ZWQzewXq
 rUs0v6+QsxeaIe0GKCi4tT5p7avyJU1e7T0WAorLYzLb4jidXod3lnSQxQqZosDciGhCkn2iUpf
 Kp2xH+AWuSEyVLUdMOUp6pAc4hS3QfB05dKeQCbTXd7XTaF98QhLuW9F1R1JDwk5lzrl/n6ifHW
 a4iHIRVLfU6EleuG6f5MBh8/SKyj+faoS9mKgJbkfoD4kW8Hr8YRBrKrsFqsDE/2lKCzUudOupA
 oFpnOowIQqCm7iXRyVGnIxaKDMd+HqJ6KhuH1QJDojEgMZsLHZrpLcQYKAETyk0MOR2xhCmSmpN
 OMxoqfGwnO8Xwzk7fNHWAXezkISwJ6wFPmkG4Wb2vz6E0QPkHEtAjA6pNZwjtmarcSBnlX3axhb
 h1srotfFPhfGHOeu86lBShAiJD4EDSb9IoWPjgEh4imYv7anzzgS1wA5qJtX6rSLm9DxpJHzFfy
 Pqz7QVN5g1wyAIA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: 1qzkth47oazbxxwatnoebimunsypwezk
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B647100003
X-HE-Tag: 1771932000-268798
X-HE-Meta: U2FsdGVkX180HtAKpjTmsBYUweXWuW1ow1Ur5JZAqg2qur1AIk6HVUR0URYfc+dC1nwbinNheisRXlLycqXJUqstLPY2UtiNlQNTFblyRIoxbB2FQezzN4yEzaxyWedoPlQr5V6maztHSaWa4kjun1Q2gNRaWZgVu0vQTjbgV5sB/XLEoSnxxI+A4YiulOG/I5R8HgwqCdF11LCNhawIi47zmWkvPEBAWo8KYrEQJTJ/Q0311rZalrDNR+4uqMoy1cB7rnYAr2nZKZV/FwjKgb5tbP3wTyPhhcK36PdIqRMzUH+dh9IXM8Nk8tWOJdg2+Wv8AV/200YxSn3X28i+ceQTJDl9zdOh1gCsz6NK/bRxF8aLYhWPAPi9VrwB1Fs45USfLT6lF2WevlfpPEgvzslKrc6pwbQtGAZjW4ynMQFyzo6OxuJrCurDi3r04S+F4kjlY4N8szf40PXYIyrY0lyLaV/CU3prlbMFr3BZfeAyBgt2tdCOR1PQwZPWoPaYr6S8YqurHh0LL0l1BDU5t8r/1+ytobwCoDutFKtjJv337MBD2cY+FdnoTLKmFTrxW4oP8B2Kgq/G28K1qiJF4+hifbbm2qqcsHUKoohifU3xSWXcYdfWs86JjYmrUdu4SQNjMKjGyqM/Je4FUDScBhiiGwefSlB+0DlmznQ6AO6Ju/lHB7tVA/fMDV8kpwTjjjNYemTCPmLR6V6kQCkliwmtwS8DEfibu1t8Tw0Q8pn1rMIP9yPUPDXOBJ7NMxtEulJDuEo1Vy9XVRaiH1Mo1GC7KEwxA4UWZ802GI99uXIYOeYkvYvLgqEropRlNiNymw1gZckiyTWiqbUvSCXTbEQ6/siNUl7cvdocwivvMjZkWdJiRKmLhd8ez7whbU5rgxxdKX/XeV2cxywtrHxOWf+TOS/vjMwwe0+XviX2YVqcBHfSwUl0j5SsgZ9qd1fapq9x2yUHvmFGDlnWoPH
 vWX9fNta
 pzK17U8FI51xsDVgcbkHtGL8ZusGymOTv86LYVxqxCLPr492uzC81Sh2m9Vx+L7Ei5pyOTezm7rwZQyW0fKJ94cSJl/kEOyLqDYjO9k2+VP+yGKynV4Je6h5XSSWL85hPDdXGPK41hK6kzM/MBJ+GjLBEtbvwg68cPKN8DKyELXUUZ07T9N+YWRPoG4E+Z98KThBQt3z92yE2F74UkjgMJaD75JRxe1S+Ybucc+tVTVLxnlgbp5FR105ZVsjvXPm5zTPryEtg50CRLmk/il/NfGECstKmOgiPCfxWM1WWLIC0bFvsrEMCBjI/z4mjJF9XPtEs/LczFfVrWPMEEP438SC/sep6MGOP9F5Z+WZQl6woKoo/3pzYsq6OjCZoULX2TTiOToGZP6AoJwNOQuFv9NqERFLkYQnhsn+3aRiEG86G3EfJDbXHJFbpOQ==
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
index 76deab0cb225e..8c23662a7e6a1 100644
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



