Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 654B9C5DF81
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:19:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62D6A6B009F; Mon, 24 Aug 2026 07:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DDE46B00A0; Mon, 24 Aug 2026 07:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A4B46B00A1; Mon, 24 Aug 2026 07:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 23B336B009F
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:19:31 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFA5DC04AE
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:19:30 +0000 (UTC)
X-FDA: 85135917300.02.3A06E05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id D887BC0004
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:19:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pt9mYJzd;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JfWIbwT4//CafJUB37oPZ4gAJDTQRPaodJm/XlS444=;
	b=pOwyo2mgiePMgL/zqktyaD7k9ktsK8efFtoh0KfxUJedXWdgLkChIaZIGlloLTEGKfeGZu
	B06+1s6T8+sizAL73Mq8CWUvjBuV5zrJLVsjIkW+fzhlIDN2ucBPbsvXt+hldGcLDa8ZeW
	IkgVrzWd1YbFkvuHHdNH2X2s5LldV0U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570369;
	b=i9W+zrnMw8BmCLr69rLHOIkDB/7ly6H65ui9QbEBvs/oBMw+92DoU4H0mnSCRJvV1EG+KP
	dGuiCXRuIMjl5XVSmWDWqWiMaUdfKJBnAYyXe5t4rF2Ph92Fjy+C4QjlR9rHJGbaxVzurB
	Qg+2vcrL7LE7PBlaE3NDeqkwN6M82lo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Pt9mYJzd;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4BB6542A86;
	Mon, 24 Aug 2026 11:19:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A601F00A3D;
	Mon, 24 Aug 2026 11:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787570367;
	bh=9JfWIbwT4//CafJUB37oPZ4gAJDTQRPaodJm/XlS444=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Pt9mYJzdHdzl4fQzAVrswSnLK1ugEdizF+iDaboQyRXVOzra9ZiPlB/Z3pAX+gRQ7
	 FlvuxDHz487tjiESkDMKQq+qrWU6tUF5KyEJ5N5EoOqXeSYHfees5b2NvdTeY4JzGg
	 2ASC/szsGCPUbmXMcnP1YJhN9Voj39B3hlLhHUJuupoWLcKTtNJUxQo7g4As96pJBw
	 cU5Waqa/ZJ9kBvahCcv4atl/fAiNgenV8MSkoIvfJkZNk75BrLcCFbWc0jAzm+P9bx
	 VoTqsK9exzJ0Pevfe9KOF4zMp5ZeZG/LPDRC+HadCNWknQmgUdkQPzSBjTKZCbzQD8
	 BIsVt7vDKq/Pw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 24 Aug 2026 13:17:53 +0200
Subject: [PATCH v20 1/8] rust: alloc: add `KBox::into_non_null`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260824-unique-ref-v20-1-490735672187@kernel.org>
References: <20260824-unique-ref-v20-0-490735672187@kernel.org>
In-Reply-To: <20260824-unique-ref-v20-0-490735672187@kernel.org>
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
 Ira Weiny <iweiny@kernel.org>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 linux-usb@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1170; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=Bz9Y+wuriC6USNq9dghH0Oc0RgRceIN5mLKgknmkXjY=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqjCiANjOTA/QLk0NbdgT+Aipy/VQqpA4/e4r1P
 uWaXDqaFq+JAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaowogAAKCRD6UCkIqsW9
 0LcUD/9JlybCkRh5vp32gkmPMvQSq6QcOhJid/ktAibn3taPc2bE2UpUDNFbJn/mQH7ZVtCu1ZM
 Tuys8Ev6iAI3y5ohAEMU7v9qE67FroO23PPZqT3Fo/KhIAFQYpdvy5BC5GdaHEnW0RLQr/WpR5C
 lrzj4oZaLV/RfEkuTqzwgr/RcT/tNk6g95wN+JCT/GX28fo0bksGHfkal2ewedoOfK4REnj/6W6
 897sw2bg+rKaHODMYi3mNwWJ/nk6crdtLhMpFjaV1m5I+m7PAKhrFK/J859fg6GceYm6Qk2qIuv
 h2xNuhsDtW6kBHqkN2FjJQSDvsjUozwkUmr3GbpsjE99tnoN0+LzFcKD8TafAZyBQESTkAD83t/
 Dpo3yEG6fZUHtdq29nvUu1TDnotfGPxdUDGLtKAlpvVnxGvfaC3OnEkGrsNgugffVt7ObVl+d3E
 UZtUeA30SEzENwbdDvDLd3/SDxlBkY+vOTcv+Cxo5ZRLKr1gTMiLc+NWBFRyZWbLjboFrSDWOJf
 GEkBbnGOC23EJMljiV9hbphKVdr8Vh1b5XdRjMkVjl9g0HiMYMlzPRxgYyFn6SIwNxvKiFnlwoA
 JyBfok+kTwA5TiP6zAWy+d8Xo7+N/0qPbS+AwCN2XkIrv8K/hLcpPQrIUYclplEKXVyQwS9CoHV
 AblCyvWtJHkb08Q==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: 5dpbbq4a8mn7kx1oozj4db4qy4zxyns7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D887BC0004
X-HE-Tag: 1787570368-273520
X-HE-Meta: U2FsdGVkX18G8NmlS/HVPzk5aZpkFa9kxwMC84RxpE11gPJ5xP04LCr+eP32OU3qgN25+oYJY2r18JOyM5om7eUaCcbk8k5xapAJEo7FuR54czhjRucWe5eGtKmixwkKZOIXMhSZK8YrPR28sb7XVF3oiFKKNQaUgOBRvBF3f+YT5SmAhKkuDIY0Jf+fjnxf/MmA4x4zSkSdMJJH3WNvjvY+JTjF8q3C0qKp565Yz/8spNfkj4o0ayti2XJzVW2YRXFDoVe3Vv4WPBxNTdPpMUpKoTIk9gp1BwR7C6kE8guI8u5gG3zf0IirctT8Dkt5etSi4qgAUkvbNAfMqDiF6MKFrU7nJuA8ydYkIZtU80WsK0oLUQCrSaG65tbYechCc6PO8+FRdaGBtmlYJxfbYD1qciwUOoeBKnHZd5X1s06NjZEd/EhUCB/JBAT497yBck8AerU8yxUUiXy/c9EkyuMFoSyY47PR/L3Wn1zUBerguGNzNekzptNRGi5pGH31fZMg7p4kd8dxLgNmsZD20uAa5d3jUKsYSzm2V79709j1ns1vj51jwP6YdNbKnh3jfg4aBLoG5Fq9pMTHq34+Hi1QFialiaLLQRdW196gzfwJS+z4P4zERr4n6GbtkyLsyJrB4gtICUexAZEl3HoA+6t2xwoz9y6dDmDM8N8HWq6f2TG5sKFdpkN0V5KMNAKvHZACrDMfxu7ZXPZ/Sn/ukpsoIFc0x/V4IU1jXLm5R6e4PSMVtvsFVKq/bqL9SvyIC1ZGWmmPbw5gMOiFU1L/PUzgXvlVRNAULh1KU+OL/4DfLp+yUSEBQmCJ+y0iGm3TTepX1amFrBfti1MPQcMgH6+Nn8+wfS78eg/2YzYwV3Wmh0TwV+bLskCrztdNnWTfKmeR0KcfkUgag1DWswT1pBaqumYmEDDhmzkhfPtgVXS9gqA7JL7jgdN4qWSXhkuWv1UjWnzlVj5Np6CrgNA
 d3hpFaS7
 pJkPFtG3qJpZwvtUyAWVaAQjv0fq6E1ZJFBTflAzmGYlz/Ou5MtElKrN/87CgimaUi8Xi9Lw6ERJ/sqm6D4orebFLMP7uTOje7jxc5BWtjmb4TlCteGCc4p4IIO9DOnYZ5hOOOEEJL05AKJhNTbjMObRZj4l8Oaxlbq3IT6msfId0UXWGb2NV0sVbjcQ62KzZv1TkZQ4Kij8f3gzhf3AyGeq0g4YbTid8qyadAD6dTl+6NpG4C7HIjtQbj5ZfmHCaGOxBe3f9gPUUcGMRm4Sb4uG6NFGMDte4Q3rfm+JkDOGg06NsojCCNkWO+sdjWVSB0YsYnj2dv89VciFlKMR1UnHcpuJHf0djnMLP+a2GNLlP05A6/vm5UOdCphJ0X5EbJAY/lgZUrvqK2BOw6RXh1NFR6ViZlNoC8e9o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a method to consume a `Box<T, A>` and return a `NonNull<T>`. This
is a convenience wrapper around `Self::into_raw` for callers that need
a `NonNull` pointer rather than a raw pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
---
 rust/kernel/alloc/kbox.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index 35d1e015848dd..e6c637bbe2009 100644
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



