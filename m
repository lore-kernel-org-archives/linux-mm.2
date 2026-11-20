Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73666606A33F
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 13:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FYU7uep7
Received: by kanga.kvack.org (Postfix)
	id 9F3DF6B05C0; Fri, 20 Nov 2026 08:12:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB826B05C1; Fri, 20 Nov 2026 08:12:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905D06B05C2; Fri, 20 Nov 2026 08:12:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DE8B6B05C0
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:12:08 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8C5C120EBB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:12:07 +0000 (UTC)
X-FDA: 85455535494.22.1B75223
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0EA184000F
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:12:05 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYU7uep7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795180326;
	b=ZoV/dbVne3guqKK7ypErNiqtmC1HgLhQPhmc2Qz+qBWpvU3i+liVxjaFbATpo86KefxBcS
	vIr38MUYqw5EeNjvdRvQVpfmzu6w2ybGrxfsYXilil3kFeX00BcX1dSOlHBaGj3h5HyCmT
	HDo/akH6siIo8w3G5GHN6DZkxX4QK3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795180326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+hP09lZtE6eQ8TbOuLXpxKM/7C1qHWXDDDUTO6VJ3ZM=;
	b=mdwEIf4oLlY8Db5/cz+c/j7dPAm6lMWYQrJllSxPAjpQE3TgOLr66plI/+8wNp8ah1Wd9l
	uv1c+J8L4lkAf+iq6bv+X8QATiNyrLcANcy9XhHePlGas1ZZsm4vNlayg+0Ay/v7ulAl1p
	68If5Yxw0lo8DCRHH2dSPwOsogpWU3I=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FYU7uep7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89343629E5;
	Fri, 20 Nov 2026 13:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA91F00A3E;
	Fri, 20 Nov 2026 13:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795180325;
	bh=+hP09lZtE6eQ8TbOuLXpxKM/7C1qHWXDDDUTO6VJ3ZM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FYU7uep7KTrRdPpP4dAAYQbhPmxrxVcP63ZFjmE7U5GmbWKSjDhQhbPYuaoqGsro7
	 yBEbbhT2ZDFJh7aX1CTohFdxhVbi86QU330Ej7w2l3DMz9Ywl9viuehGnGshAkjod3
	 WQOiUTIILk7KNCrT56pF5jkXWd0Fog40XVf8HbDwwzZjQB/yrLNBNLo6zrf707E+AF
	 9OqgF7t3JCOwPlKlKs5tguq8ckY8Tws0L9Zvuh/8t0J5jsvRLANbRCOXm8WC6hhJ04
	 F30izqoSX0bbp3g0dIgfoUFMKqZrbGSjBP3pAWK5BEQ149Xp/6RrxEfmXLuLC/5wIr
	 HYTwsImapaCBQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Nov 2026 14:10:12 +0100
Subject: [PATCH v6 01/12] rust: xarray: minor formatting fixes
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261120-xarray-entry-send-v6-1-1f69d7385f70@kernel.org>
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
 Daniel Gomez <da.gomez@samsung.com>, 
 "Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2376; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=vu1pWIgWMPl43F9OTIFN+xRMKvVrKE4I7rGleY0rCyk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBrAEbDluzOEiiN89ogWhX6YJrkQn7fHtPhXw8n3
 yNSGBu/+9KJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCawBGwwAKCRD6UCkIqsW9
 0HadEACW15CWVaNz/Lm2ABKKs5xRUk28QKyZlwDp/bl68R/VMljAMo7h3/6/RCpNiCnROhjcS09
 eBTT1gz4+z9d7BEBZaciekVY/QmN4SJXcTgsL6yBQ+BaRo8iSh3boG21d55kG6iu/mryuKXGKM+
 LZGiXVt3NNdUV1ssqOkMde25ozGoHiFkW6Kc2k8WCPPmllBlVR7qCTDY7LHVZGf23RZAFcpeaxX
 p5yCuZWW0gqk6W3jdbBSXLq90liGhfbn4CDLD19jnMhGtt6m56N/u0WVCvAo0vPwhjso8fp+uzr
 PK/5hdVpe701sAOPrzfx1dQsljK22hqfJ3/UN9gQb5PRKL3PaYVqZhEKb9FB+h1+Prfau5BiZ/E
 Otl/pd7RNyEgsw6jwCcZai1xk9zjAU3kXACqxre3z6D5W9zVa1ruIsBXOlOsE9s4sQPl9gvT149
 phoRiz/NEwwe9we0XA2owHRfYByJZeqOy2Ob4DYhZiqIE2eAOIHY4BAFHtE42qGbiboszDEgcwd
 QHfif6NVapxysKPm3RwFEa8gvomBkjw5oRjX9wMtmtRtEcfqeIxyBemRbUcdLt6IMdfn91oo0v9
 xD9i+eiZ5HlYXq+KhzjncTW+wMyWGYyFRQsvF8rGhigKjd5t/HCRqMgXGBvZ/ZGHMgXWBP99xn/
 x3MESYqU7mAj94g==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0EA184000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4hzutbw8fygwdkhwqnseuws93s3mgch3
X-Rspam-User:
X-HE-Tag: 1795180325-450400
X-HE-Meta: U2FsdGVkX1/esB5j1dvHmH/TECUzJmnbWgymWPo53YUDOMFRURjtnf8+rVyAGdFdorthbM+AY3PGndv3Q8P40t9hRF1AcNkdS7i4ao7QzU2NRUdSf7wc9sX+w8T5esUhT9oOw2bIxBcJ1i6vlghlUT8Zk592TjA5pKf0IoQGrKQ/0zQMofBuUMyz1OfRPw0qVYImgNOUPkKLvpLYfBwX+HrmIbidrnaFaQ/S8NkZ/iSwzu/zZ5/Y0PjdCf9N6ORDXrGOfTGf9CnIWwAzWyd2b9t2FYuQMCpNdcj5YHeZGuKXj4oOPnyotG9jkMLGjFWBly5K6vgenecQPKlSojkT4HGQh06KNTM1/0PYMNJd4kjoyAAvxekHUDN3VHiC5X0CTBwl5bqPo8Uhg01jA/2f1pvSZIrGiXEcChZDKHkVEqfDgHJdmFbmrKJ6Rs3esCfJIAeKnOxBTiBMEZidZaRi76rse7dZvZKpY/gf1cXDWKm57p6dibrhBt57FiH5K8KsEcKdUFhG9CeZ+3aB/4EvFrFyge9lUcnNso3D83Qqu/i+Y+u7CjCqcSsaWmE42ZbGcqZuejm1Py57+CB8Hud0NAwClB6e/odXNWEtPKfF63floE4SUYkcnVMiuVUoUvdE7Ecp74nKWTXR0feV0Gi+GfB6aFsc+chrF6O6QaSc59hrMw7gIpRRMgWgVU5rlA5cNLkF4UgWQYZdXDQr5yS6Vd6RW0GpczA3FdKkf9Dfy01HPrGzMjsUaM8pY0swvZZpVI7fhza5TBlpiYp/L9RtPx8YA1vSkYTkLbBiqhD7LENYbodYcOHHbkoddiufIB64Tv3GImRAoG3g0ZrzAntO4JoEzSnjME/o9q3tkdA5jc+XVxSua7h74bdVzVZMM4zAM5AMaYhy1NOZOhgJS41HGyrSv/mBb0Fz1EeTQvTIE0sYNWOm34chbArN2f5ooTScNCQuuc9LilZDZYmHG69
 BUToGOZw
 oC9k6jW9p2p5lGC/SxCSTeNLNwm+gnvjBx5pU10Ofq2O60yVDbtM+FykFmJ5Fir0NTkQH5cuBsAnixL7FMrAzbQs6Y23mkT7KjNEvK1uy4pwqTg7WjiDE9sF9D+CB1JHTSqMgZxIAjuEUQwCh4vtdNwiA2FIUAfGihRTQqEiuoQQmeJObMOCQTl+w0h7LKLNazO/IdSCNrgWSUe1wYRfmjmhoytbdx0SKtyQaz0fZsw/YAQm/xjgsin8TyK0RoUVoOwHez1fYiAvnmJ8Fwi/OUW0q2E5pXaHF1yWQVewSiM2dIRdF6a6mYpUvXqM4CTdw0Bb5EKwFIDI4VeX3HOSjxVlUw+ATNoX4LTxrxPS4K3rqUF+OmZPlXFYa4ZpIVyWTWko6I3S5LrXXUp4/o7KPqYCOrw6IRStgiSG/3pJ4EPDXXLHwuCw6gPaRR/Dr5l8sZbwZ3oMxOKZThVhjWpaB9rYNu+Q2VWKVSuwbr7vh2yKNZSTjc/zE6fzxhZJJIgqmHcqvgcTnLFwZ8CNIfqq5zZ4tzpA7MqSYMEMZy0T/JGruovAqMCGDJCD5P1MdpPJT1WSuMEd7250AoyjUn0I+vy66fio+hKIr1SveemrR5YI4Pisy1mI6FaxzBpf6k2SIyXxbpqQP70s3rbSgPIH5t+zT7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Fix formatting in xarray module to comply with kernel coding
guidelines:

- Update use clauses to use vertical layout with each import on its
  own line.
- Add trailing empty comments to preserve formatting and prevent
  rustfmt from collapsing imports.
- Refer to the kernel crate as `kernel` rather than `crate` in use
  clauses.
- Break long assert_eq! statement in documentation across multiple
  lines for better readability.

Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Tamir Duberstein <tamird@gmail.com>
Acked-by: Tamir Duberstein <tamird@gmail.com>
Reviewed-by: Daniel Gomez <da.gomez@samsung.com>
Acked-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/xarray.rs | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
index 987c9c0c2198..4f4b6bf5750d 100644
--- a/rust/kernel/xarray.rs
+++ b/rust/kernel/xarray.rs
@@ -4,11 +4,20 @@
 //!
 //! C header: [`include/linux/xarray.h`](srctree/include/linux/xarray.h)
 
-use crate::{
+use core::{
+    iter,
+    marker::PhantomData,
+    pin::Pin,
+    ptr::NonNull, //
+};
+use kernel::{
     alloc,
     bindings,
     build_assert::build_assert,
-    error::{Error, Result},
+    error::{
+        Error,
+        Result, //
+    },
     ffi::c_void,
     types::{
         ForeignOwnable,
@@ -16,8 +25,12 @@
         Opaque, //
     }, //
 };
-use core::{iter, marker::PhantomData, pin::Pin, ptr::NonNull};
-use pin_init::{pin_data, pin_init, pinned_drop, PinInit};
+use pin_init::{
+    pin_data,
+    pin_init,
+    pinned_drop,
+    PinInit, //
+};
 
 /// An array which efficiently maps sparse integer indices to owned objects.
 ///
@@ -50,7 +63,10 @@
 /// *guard.get_mut(0).unwrap() = 0xffff;
 /// assert_eq!(guard.get(0).copied(), Some(0xffff));
 ///
-/// assert_eq!(guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(), Some(0xffff));
+/// assert_eq!(
+///     guard.store(0, beef, GFP_KERNEL)?.as_deref().copied(),
+///     Some(0xffff)
+/// );
 /// assert_eq!(guard.get(0).copied(), Some(0xbeef));
 ///
 /// guard.remove(0);

-- 
2.54.0



