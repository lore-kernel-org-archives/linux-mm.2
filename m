Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BDB7C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 09:02:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FFB6B00A2; Thu, 10 Sep 2026 05:02:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 420D16B00A3; Thu, 10 Sep 2026 05:02:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 310206B00A4; Thu, 10 Sep 2026 05:02:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 04E886B00A2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:02:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 197BA120455
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:02:37 +0000 (UTC)
X-FDA: 85197261954.18.67B3711
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 41A7980006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 09:02:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If5M6sRe;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789030955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bi6HQbpS7WbVT11MZapyDiTA6f2yGohKV5fr13xqRJc=;
	b=CYVgz8XilsTPOmHlfTTHeDTgJPjoDXpkwpdyTk8Hnkk8T97eyUenDl30/aRLX/xwQJ7SZI
	BE5Q8BUT5PiYqZOAdp7Xnnzmv4KjOHeI0yv3h41MhYfeIN0+nynQwvzxhLRGpsAhrme7fn
	AHoMLugr0izGf2FkEFelwi7YA76hq9o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=If5M6sRe;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789030955;
	b=NrYBHKxRbc13hx3daENeJP1WCQ/WvyHbSzisY1LPLwHRb3CnehcRno+g1F0ZZDMPJ3I4fl
	kQud+AHszGIYqNF9Ue201edGBCWGMx66NMdWCTzCBIrXpS2++uhNnaTqRb2ezgpF4Rp0ns
	KKl12jyAEPrLpS8d7uF3AStNofqeZ8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C5DF41231;
	Thu, 10 Sep 2026 09:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4011F00893;
	Thu, 10 Sep 2026 09:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789030954;
	bh=bi6HQbpS7WbVT11MZapyDiTA6f2yGohKV5fr13xqRJc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=If5M6sReucxfAa8nllZsBD5rzyKL9ELmN7J++KhzVHXMFwuo+ywIXweYK0qHvKt73
	 1DlZC6yieZdrctVpoPbK8xAnJ01MqKDgn8JNOrREKfLrtY3kuk1QD0WFmmwZvIkpKc
	 cjwQhwi6gfGiK1mJpr70MGacbhPTAkvMJSrfODwcnkW7h00u9xgR6Tozex936pATmf
	 Y/e3g5Q+e44jwwElZlmy2drakal4M8C3ZYhzWEtU1LZSzTfNXyLU3yRFX7wXmiz5xW
	 ThtO/NXMID8mQwyR1hAETqMn3NvdBwCEMEnIpbQLdGFzMn0iPU5Qgbppp1CAYsoqRp
	 rYXsEVBqyS45Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 10 Sep 2026 11:00:05 +0200
Subject: [PATCH v21 1/9] rust: alloc: add `KBox::into_non_null`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-unique-ref-v21-1-e83257373062@kernel.org>
References: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
In-Reply-To: <20260910-unique-ref-v21-0-e83257373062@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Leon Romanovsky <leon@kernel.org>, 
 Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin@linux.dev>, Viresh Kumar <vireshk@kernel.org>, 
 Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>, Ira Weiny <iweiny@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, 
 =?utf-8?q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1188; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=WHW93VvrHeXgOCjNosfBMI4vPnTOHHkUoJXKjGlJMdY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqonGhYtutHmW3K5/iWt2PtNR0EOOEvKOh8GOE3
 cAXhRn6VpqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaqJxoQAKCRD6UCkIqsW9
 0PiAEAC1ZaUVBOkvlRXYa1uoG7fv8BkX7iuoYs3OUE6Xs7RBS7CbugsVYpLdGgml2yB5Xo/AfF1
 lOrJHP03TKEIawI0QIjvbDUNXrYGXND3iwPfW4oW9EKyBDMM7aQlMGM2ptkYJDcGzux3kw7pAqx
 zYjptUpVSESYUlKv7c6+bSMK1AeydAw1bt04eyJrzPRMgus+QTTFKWMkFU2w4n/A2Vybuz6QDSb
 +gMpzM9B3XcB5EYFx92khT1NMRiQsSRHxCc54Ro6JbS9nA7SFf4X1SRG2ZwFwEYJQw4+P2eXu/B
 kn8z2qUOFN7+DY5TEDT7kwV+OE7FFgKaMjSOLZh48VmeDrw9fYdtqIKT7xIuy1KqplTIuTjsNpb
 Iy++9Nqzy8yEHUWDqdzclvjSepDS5DSFpG5VMDldAC4AENbijZpOJVJwq41LMojHASK+t1NsF2T
 t6P+wfaQTuumBObShygOAi7WRMKfgFIBmoMisdn0c5sE+W1UPIzdRH53GVM7b8aY6Q+rsRPEu32
 rNoYVKX1ZCSGlH/Cai+CxLnb58kRzvOkj9jCMjG804rAMG2AgG+ExQoP1ymqRN4D8kik1NLlEy3
 5yp5HL4qYcm91XRinv0cXg5icrFwfKuSpkpNl0UuMdJs9OSwTJV3P5cjHJpDbgZcd/sKdO+4yNt
 KzVWbdwXn+Hi8TQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41A7980006
X-Stat-Signature: w6zf555h65kh4b44ihwwfnrbua1p4who
X-Rspam-User: 
X-HE-Tag: 1789030955-953406
X-HE-Meta: U2FsdGVkX1/nx35lReFmePNPNJyOrvaqsfvCWrX1ofL7b5H92qJ8n2/B0tvm2zFCrewMPRw2UzGzaWdN713kdj2hR6YYOBQIRBiUpHV1eBi8EoUMZBjcJakpq51QiV2Pl8a8qjiKd10f7Xh5D5/lJFCG48lAxHQz/6kXBgiF1hYN+esSR0twx4w42dcwiKvy/aHWg9ZrGrP8bgq5hg7Uuaf+/c4oGgX/RDIcTkaxAC83khg3Uiv8qAvyQsWG9bvFGBN3i7oj/YIkrdDce6bvK4lylk5d2O7q4qZip8uutn3gWoU9ClUInS8otbIlQYo3risoXdApsYTfvOUVe6xXVdWNEHOfw2YoY8tJoG5kHWrKvtLDAW7v7nZO3AXj3wPTRBN0P7FI4GfQG06gIJQdshFmMV5Aw2qmIJhTFqzsPMwFOL6nfvCte2nwqsFrdHxeeojmz8+BUfDhsYLPisT8Yj85t7BGc2QGRj0UPE9hxoFaaf5vR5wtpapbMfXQtmfylKJ7uV0R95CqMUHQ/OF39haPvncy0Su2KyRWR8fnXfDXX5BE6e2G4vg1Y4X+scEWZz4vO/DmLjR1sQHjnyuC1a2IlLq6EadkWqOFkOD7cHd7WJwKIXbKzIKP/CkDVwryVEtsaoqAAYroI8hVrtdfKtcJraDTwCyJAR0zecatOp1JH/STOGARrBKDoTSujoomCVUy7sTaOOHxWstTy9fteEg1450C+YlYCjPZMbyPN5lXLJo95xc7wzpHeIS6jregSiU/283iIXuOsTT6hl4mBP7uRMWjplsaSj0Z7VAwtNlbOf2TFLGgHMvKPnCEf4g7g2IPJqTeDdzoFhQJ+R7oU6k2XvqtT8Lppd5nbhAuR3U35v/isd70aqJBO7sirYIxGzxtBWez7UT0F3YFtA4sB0B9sTe6GUi9wnaHmQzqNyMpfsMNdSTFeqsgkvxvSEovZeLVCpvyQHMKSgI3+RC
 qIvVFiVQ
 SUkoLAZ/HsYuCs5jW3pq7cGDhktVnNANeXncRka3wXPS3gmFSaN7XlIIHAe8ZZr1WwlRmetZKsCZBbm5tAzjyvb75cAItv/dkLt4aJsz9in+yImRwpbp3HvRR4PN9QlagEK9U76L/u5GWkGs1Dlx07YawxZBEaXsLcUfYHuZkpgcsESJ8gJcqTOOyutIn3y/JQTFVaTQtKOly5zrMBR5KG5h00Q7FPHTZc5pALhHwo7p314RSTm2kICAnAsASadbiYtaC5d0FfFLpFcWaw+oS/FcGr8lNXsjh3hEASGq/cgxlaNsg1PMVRBq0KFedYJVTvWMRwXQ6FaVLfJkIcpj+/jgUMK4WkuNJq5+zG8VN8Wo3k40zZw2TMODCbfqeKXq0/HqIawLP/8eMSq3n0p03SdhNPS3KApExmdGd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
is a convenience wrapper around `Self::into_raw` for callers that need
a `NonNull` pointer rather than a raw pointer.

Assisted-by: LLM
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 rust/kernel/alloc/kbox.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index c63d6acdbb6f9..27c31120c3854 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -211,6 +211,15 @@ pub fn leak<'a>(b: Self) -> &'a mut T {
         // which points to an initialized instance of `T`.
         unsafe { &mut *Box::into_raw(b) }
     }
+
+    /// Consumes the `Box<T, A>` and returns a `NonNull<T>`.
+    ///
+    /// Like [`Self::into_raw`], but returns a `NonNull`.
+    #[inline]
+    pub fn into_non_null(b: Self) -> NonNull<T> {
+        // SAFETY: `Box::into_raw` returns a valid pointer.
+        unsafe { NonNull::new_unchecked(Self::into_raw(b)) }
+    }
 }
 
 impl<T, A> Box<MaybeUninit<T>, A>

-- 
2.51.2



