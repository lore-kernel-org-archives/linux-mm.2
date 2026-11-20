Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BB5E60A2605
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 10:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NGbWhYsJ
Received: by kanga.kvack.org (Postfix)
	id 7070B6B05B4; Fri, 20 Nov 2026 05:28:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B7C96B05B5; Fri, 20 Nov 2026 05:28:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 559996B05B6; Fri, 20 Nov 2026 05:28:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2CBB36B05B4
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 05:28:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A153BA0E9E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:28:01 +0000 (UTC)
X-FDA: 85455121962.06.F5C2B28
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id E47511C0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 10:27:59 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGbWhYsJ;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795170480;
	b=OimzA/+Zx+e+TTbjIFlCWkTWfRxm9TnyHC80Cqz2fx4x23Nn3+IzREsqrq6cUWNCz/imUR
	260jmmEyHljno3HggTBmbyPupw42OwifIk0P5+9vZHb6DTLi3wZqOaFDHMumm6dPFKdlYr
	h39HUL9fQYLDGzNuWEO0JGhbMW1fC+Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795170480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BJJGZ2hR7KrC6FO1SD1oNY+HbmJucVU7dix749FAVQw=;
	b=TbI04t1iRhV6nE7LmRnY48ADtDfo2UZJ/YIVdYHkSTKS+YzRXFjdLOM8lGgq5W7W5Ejfyh
	CfCMT13JDN4AU87gmUaJboQZqXJDB1ShcEnwGiTS+HmzLk/XnvJ9MQQzZVETqIMO5oRMei
	2nUQmEVaw0ldMS6HiaMMoillrDPiPFc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NGbWhYsJ;
	spf=pass (imf18.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F51561B65;
	Fri, 20 Nov 2026 10:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2A571F000C6;
	Fri, 20 Nov 2026 10:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795170478;
	bh=BJJGZ2hR7KrC6FO1SD1oNY+HbmJucVU7dix749FAVQw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NGbWhYsJrys+xYxSXvAyaDvOTFqbMpAWP+I+omasdxQ13kQRFhtxlBqM3H5vqF1aQ
	 28MpaiKZFLNZZCOutfV/1/P34TdO94NRk7XJHz0suq5i6mePQFwnZsi+0IkmQ/RI7W
	 TqOpftIOsuKtNM6hxLhWxIlofQnx7GNksuP76dFZSZ7bPiPJfd5K0Gbp2I/Nmg/lt0
	 rgEwqHlWOWnw14Loo+8rU7rQ73Nv4grYHTaEXaY4zVYPI04rdpBDXykMHz8JPFynSr
	 HYhQVoUrDiLF0jr3tWcXvpHRMBnyG3Sf5zBrFpEynDwh57R42umdP4KdcFGXfo8Oqv
	 DmokSAqpk/GQA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 11:27:09 +0100
Subject: [PATCH 10/11] rust_binder: access page data through `SysMemLocal`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-page-shared-v1-10-66f8c4c62822@kernel.org>
References: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
In-Reply-To: <20261120-page-shared-v1-0-66f8c4c62822@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Mark Rutland <mark.rutland@arm.com>, Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, driver-core@lists.linux.dev, 
 Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3090; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=qHAg/nVGaoHxsvrd6qBHGWy3BAkPVAIkJJLohHw0Kts=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrACCKShU+ukfTHKYqoYkqcKlnnZ2g88oZQPIL3
 XyA7duY9eOJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawAgigAKCRD6UCkIqsW9
 0F4dEACOLzzfXceL7SEsh0TjwL2M7VwnvYPswzzZCiLzMfOHwSSdC1xnyUxYjDpJW0fdNnbJ/LS
 MreZUWOtychDXEmg3fK++XrCq6KAMuIVsk0a2OYibqKPr5Beqv0P2XNotiDNLHc1MBPSAYVtFZT
 slOkdIOzk4GjNEC3AyEVXOAfpLOvXb2J+agcCgNp4ENB2SIbO45ovvmkVRHCnbIVr6LO9jVIJUo
 mI1CPFQGqzq0WmgP2jn2JsmgKPKJFFSXobQzgu/d1Cf1O7wo3uPJqeLVfJvpWKC7zFgRpEW1fqi
 MgZ41VsmJ2CbqH39zvrB/Da9QApGneMLz27PrBz86QZp/Z6SMUfCvWFYOjygqRKpNayX+Wvo1rk
 Utq9k55Jmv9MmV5b7dxSSi8//8N7qKDo9rZoOVDhGSzliht17thJbQbpm45X/IeUhgPzeAcePJO
 pFKlOVG6ziFkYLJH/ch3weiN6O98LgPFJ3ZSai6sXWxOrhfZvCW/otLgVcjGQWqH1U644iuw4Of
 H7q5tgDCkIWJwCbuPb/J6CdOn1CATUP00pP9BF/VQb52Uf6D4uS0eCxoj2WKHXDNIaC5FULDlxM
 VNkE+ogcZzKa9TQdU03cW+4Q3mz7bSk4EyhxTw+MI2qAoJoVNVuCiGnNIlw9XYv6z/2esH9rRx4
 cbPHn6elffFlkqw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User:
X-Stat-Signature: k9yenx5rzsdjcff8gdiugg7y5kyxt4zc
X-Rspamd-Queue-Id: E47511C0004
X-Rspamd-Server: rspam02
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795170479-623532
X-HE-Meta: U2FsdGVkX19et0NBJyW2KkiBH6wh9hobIc1nd/KNv5yv6o/SgOVlmY1sPW0125DDO1Y3K/TEci5NImaW2ycQymgwOG0G0Hq1I3yAp9wSzV8PW7U//+7e5pGncJl/tEhJ1onpfZt8CO+A5ahm4EYQFpPyKVb2d+TD8HeK10J9Iu5IOxfnJk5qg+Zz7H5bYBa29fqOcaO3uOaP6VVfj+PcwL6W6Nqzs1afJjU8/GBBchNaLLylqgCZLCdPXgL90jeFCoVabBr6+3FUSSXyrLvi9xFmrpq5+LmffOZ+DyMvRkEIqubd/3niTeieC+dB/UuYBdRtnEZUCiTl2XjtjUcC7Qgcc8Qe7nmCBkb7bCWOQnFkYzHbk2JCNYXhEbXDAiZgwyArLWMBK5OKv/0FcbRTws0zZiHNEjaCfkOlJNzLnU6+/pM1FV2znWg7ubZawM214/Vw8/o/0yUO67DObODape5YtRQeritLkRtMV5tiP79vmsGNpKrxphGhcBko8GOivM7XqpPtcr1sPjrFlIRk8ol75czQsACvmriAqFQhuzafeda9QHW6ZW06QBlFf4OE1DvSu99K70AB2/qhKv8SjZ0sGPTrIVXbiYsgrYTcefkD1bQDq4owUc+45Ng9xINBOLixW5r3/fBp3DUsM+hHB69O7C+liOp+HRQToZE7Hktsk5NxdlrJ4rwr26GiUfFhO3w+rOBir8hHxM8peN16XccrQde5u4IPH0Krc7k7oMnsYJQICn3vBkoE2TfifUmpblQFwcciGvB3WQmK9kFr76V1czsUNVO4ONfbyqJDg9I2f1W0WNrz/amadTci3BaMf9HjoHQj2w2w2XSgLFi8d4xg3iR8FZ3n5VYtiuFwl7FMDSoeVid1o6mEKh5kY5rqpfvlS73bGGnG5IkaSLh43UJBihgsBJ+tuh6fgck4QxxglDvyMwNhUZo/3LSG103GcXeUb+qnE+nOYgIzVkQ
 xVU0NYwn
 7BsmLw1LcBVcqCWzLhdmztp6RSlg0DAa6v+M4EyRvcsI2XSpB9SzhIAhYpTwK/PjiBpS4qOki0TZ5D6QWDD5Tqg4t+Cu9y1xY/ZEdL9fVfpc3OshE3UE6lZnN0BvqhsGd6FF95YZo4qi02Cj8m3u1eCKWRklPvbnVxv4BHCyMMH3c1SPG5N1YhPcO4megOrFQICKg8ckBGHLngzPUI3TO9UK4IRcAcHQij/ty13Z52yhZ1VcqAASDjoRqP3aM+B7Ak2CFKyJv76wyNNohQqXvsAOts7j2elQNFHzsEr3wFzyG0799sILN9ufZo8HWZkFjnJx5t97dcC2BtzzTad9hVo671lvDau8q7NLvDmYkoE7Ui+JDw6FVd6ug5chjbuvR+UkUob3xnNxPddqNvaHdqT5csTAwtRaM89rzd8BBdHhc9ZPJYQzLmCB1Cr0Jt55vzk0G2t1btqPKL5l7da4DdmYOrDbNL3N9bAlhnrVbmB6/a3zkGvXdgDyn8ovGqFTV+wSbZHM6GQzCIWo7uMMb1iQyS/bNbwPS75XxckGw7vUKrQI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The pages of a binder page range are `Page<RefCounted>` pages, which
dereference to `Page<Shared>`. Thus, their data can be accessed through
the safe `Page::with_page_as_sysmem_local()`.

Use the view in `ShrinkablePageRange::copy_from_user_slice()` and
`ShrinkablePageRange::fill_zero()`. This removes the reliance on the
safety requirements of `Page::copy_from_user_slice_raw()` and
`Page::fill_zero_raw()` in these functions.

`ShrinkablePageRange::read()` and `ShrinkablePageRange::write()` copy to
and from raw pointers, so they keep using the raw accessors.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 drivers/android/binder/page_range.rs | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
index bddc4538745e..2d360c32202e 100644
--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -538,14 +538,12 @@ pub(crate) unsafe fn copy_from_user_slice(
         offset: usize,
         size: usize,
     ) -> Result {
-        // SAFETY: `self.iterate` has the same safety requirements as `copy_from_user_slice`. The
-        // pages of this range are `Page<RefCounted>` pages, and this driver never creates a
-        // reference to their data, so no reference to the data that is written exists.
-        unsafe {
-            self.iterate(offset, size, |page, offset, to_copy| {
-                page.copy_from_user_slice_raw(reader, offset, to_copy)
-            })
-        }
+        let copy = |page: &Page, offset: usize, to_copy: usize| {
+            page.with_page_as_sysmem_local(offset, to_copy, |view| reader.read_sysmem(view))
+        };
+
+        // SAFETY: `self.iterate` has the same safety requirements as `copy_from_user_slice`.
+        unsafe { self.iterate(offset, size, copy) }
     }
 
     /// Copy from this page range into kernel space.
@@ -605,14 +603,15 @@ pub(crate) unsafe fn write<T: ?Sized>(&self, offset: usize, obj: &T) -> Result {
     ///
     /// All pages touched by this operation must be in use for the duration of this call.
     pub(crate) unsafe fn fill_zero(&self, offset: usize, size: usize) -> Result {
-        // SAFETY: `self.iterate` has the same safety requirements as `fill_zero`. The pages of
-        // this range are `Page<RefCounted>` pages, and this driver never creates a reference to
-        // their data, so no reference to the data that is written exists.
-        unsafe {
-            self.iterate(offset, size, |page, offset, len| {
-                page.fill_zero_raw(offset, len)
+        let fill = |page: &Page, offset: usize, len: usize| {
+            page.with_page_as_sysmem_local(offset, len, |view| {
+                view.fill_zero();
+                Ok(())
             })
-        }
+        };
+
+        // SAFETY: `self.iterate` has the same safety requirements as `fill_zero`.
+        unsafe { self.iterate(offset, size, fill) }
     }
 }
 

-- 
2.54.0



