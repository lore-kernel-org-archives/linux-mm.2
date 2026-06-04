Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27D6FCD6E75
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:13:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AD0F6B00A7; Thu,  4 Jun 2026 16:13:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884586B00A9; Thu,  4 Jun 2026 16:13:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79A7E6B00AA; Thu,  4 Jun 2026 16:13:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69BEC6B00A7
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:13:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 380401C0A23
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:47 +0000 (UTC)
X-FDA: 84843330894.08.43D5138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8AFF120010
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:13:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkUM5l+n;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ae09fXAF8LItvvmTTJY28TqpTPDPI0l185oWGkC0Czc=;
	b=PbdkUcEol9XbZxSJEI5wdTjstebgWzGhjE3MoQ1AIpAInpXFgOLXdthUhwaUgdTq4JB+5/
	r3Tee+stale+GWtZpSJ4sB7W5/GDjgJdqKpdxBwTZkZsNhVYWj5KDRIz4EPGy2xCU+YQ9E
	pQci4dgxquIo4vnBFkiXGY10XSQbpEA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VkUM5l+n;
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604025;
	b=KjRjyX5nkYFBzjkzmiXP4dhg4MNgzOMMZjCgV4gOZkBFT+fJ1zu4vFy91yjsvvx1bJo41o
	eFcaR2EwS2KcHD/8TBCe+fNSLHF1BgFXcjx0AifzLBzENuUGemXg5/AuGFXjeeqcLyb1fu
	/6uVQV+wAHZv9w74ARUhtrnEGblmuvQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F247F60103;
	Thu,  4 Jun 2026 20:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F4AD1F00898;
	Thu,  4 Jun 2026 20:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604024;
	bh=ae09fXAF8LItvvmTTJY28TqpTPDPI0l185oWGkC0Czc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VkUM5l+n76eAck1/5L8AuHjDCJQ3zxzdGbIdQNsGNkp9tgvla8OKmviv9XxvDfYxh
	 T5CXiuhoOdul1geAz+UtttAtacasQmLMt+dkZ5upH0R+SLnVIpNgsESP8vA5lskv2e
	 2eBuAPxWq7RvriIrOBlOS/tkItqOMwkcqthsWouvOY3aTbe8W7fmY79L/SQfGO5PvH
	 x3TwFW7uWZC5lmZvv9zPCkT/Jz+dklERyIEaoUevYb6HL61n9X++xzKiYJ6N7oOvaW
	 SnNqXruCFaiUzzbufT/a7XLIAx71EwVG4L6EJ5BrJMPgAbd3pWQowvHnrQlrVyNZaf
	 aaQMqqE8DhqCw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:19 +0200
Subject: [PATCH v17 07/10] rust: Add missing SAFETY documentation for
 `ARef` example
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-7-7b4c3d2930b9@kernel.org>
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
 Andreas Hindborg <a.hindborg@kernel.org>, driver-core@lists.linux.dev, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1543; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=5/8RAK1i9EEm+Mr/ISUqH0yYzAzf/u+vK09Vq8P7sDc=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvsYbmmhUSA1BFXpd4LxLHnLV9ib9fde7UdH
 17um7HAPqGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb7AAKCRD6UCkIqsW9
 0Nt5EACgOkQIjNes+0YwsSd6rxBD9/YOWxQW20hXwPtAoLhwpn9RDoSA+h4PnOESKPOVrLhGp0Q
 6nSJOo2SKyh4+tb4v+lBXt6nuxEXrO7wpnde2auyMfZz635i27etmDlT/litVdyj0fSGXksN3NU
 oiyshGS1QUb8aHjU+kneBTLgmTBDnsJpS0ZlmB1Z4WUSNySQyXwFBfwMKfd9RBFG2M3Hny10mYK
 J6tGLqG2IivsvXrJ0IAvzvy9hKmvFdeSr/joWbzooS1g7zHZQ0mRDaZBZecMAicHVmk9w7D7/ZU
 cYZ1rVnvZ57bH0MzQrNsigGiRaBVDDoxi2TCGz9xjcIBueLMvIB/LcVTuxc123pQr2cZS8FBsQw
 kDHh1pYRSgAz/5VjCSdNSYCUj4u/isGJptd5igW2nIB62BWy2GG5bCJ3rFJW5srwVKjnG4LA99E
 YnqqS+eO4npLOjXAJPhZDAIJsXWRFKFOktzb8KVF2raNweS5bB13ZZqG6zk8tKJQ4nr99xNBt+x
 4LXjcKQLat/vBvT0r+sOGoTSqyYVlFU+fkky0pdmtCXHib7JSaML7g2b5cGgB6nKrIGZPJcsM17
 fG8VC8R/HCyJwRk/mISYKNh/sCTlIPi6mIi6d+TAC4q1mH4JQR93mRCahJTE/AG72ip4nEwjfHy
 MQA6YfVG5t59F1A==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8AFF120010
X-Stat-Signature: 3uz8cue37j3zgopjbwqxtbd6i3ycd768
X-Rspam-User: 
X-HE-Tag: 1780604025-311783
X-HE-Meta: U2FsdGVkX1+nKabYA7rgu7lFMUQ6LvEUWemdInrFG0X1LAS2crrqzntdf5XgTnB+VcgsDZxdBODEfLS5c0kr6GFcsffu6UujbXyi54SO+6GGX6hnGuJe5la0HMlRJoBihSOEceFL2QkIOfMW5LHqr5aZ/GZLKocVMJWcj2bfKbUrO0jW3BTfgUOe6yJpY/OeU1g9WKbvQxOkBSu/9Ni/qqbEwCLpL/qldyAYO+IluqA6zy8KTmNSdUMapEvgwMVkBWw0pSJj7vKKE/xnEy5IbgN3XyCYHY8INN6J5qs7kRwlPQkb5kea3wwVm/FyvO1qJA57/C/q6AKRH6r2QWactvi9Opg/QR3ZutXpT3xc2759ygY0iT1edtIHZlNA/BOJQXFpCav/daORlmWviKpHeqFd2LyuDC42EKXaEHqRwTy8cMZNJbYyxcohbxtjnaYo6HEweWxJV5KYonqeWa/kIWPSWEh9/hAYieWLeN9FJ9QGhX0B+DiSHnKbV/VdCI56/PBK1X+lD/78oNuQUJRIfUwczFFy0oMNhFfQqaA4ZSHRWGJsfJqBs2MKHP5WwUpHter5xaoN3alXU7L4yHkBM0/7MdhVTzYdaVX5m5qNXfaKUr5STArp+KYoa8ReEoJhiZzhhPys5BhwUu2FPOlkHjbqnHx47Cdn/9sIoiTaRvffjzJLznMJHIbiq21X0pdqkZMBo0GqIAW2GJs/xBJ8aSFAg73pO3grKZ84+QNeIlRlbg7Rq0RHS5Aw2OLyIgKCPZMYmWVUYePbdE3TyJSVrY0D92/eWakimUzWRIouAe+Z7Ue2/AMMlDftrJFVUC8sZRhDYzsG4A266E29Q2FMeVRTeEAnOPxunJinY/zYCMaAhEDDsZBvboU+lq9ybfmwi7XVrpD7KQlA5r9tOONu4xQ8KvOlziYHD9k0Vz78aMapf8q7cVErpxFmghrYRKmOqrnDlP2cOYwLiHZOAtz
 wM36wN8P
 DL9rzjjW96PrveOMX8NrwtRtlQhQ7GzHBzHLGu0AxOSaBDbay0WlN8nmtQYDN2DffdhFJNNplZtDXAmpO/2eVOybn5McVY43zWWINyZ8yOnRL1GohuoRR6FUwAAuUyZ+W2ZvZHspmA0zEiB66Qx+30Qvnh0uZCr0l/7kkE7Cyynde5+bThWIOecYJU7r0mmHgMyDNPWLlHsPMKBSLW/Z+UjqC29thgnG3CN2apMbc5Nvvl6zMRF30WSTXKLDqm4iXKIxB64bp7pRAPaz36qbeehoNlouQwS7X4MaB93v4d+biZRU4qQzPUIWCNxSKe2Bt9rn5uaDq4E+jI4Q8pEoWaESdcw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oliver Mangold <oliver.mangold@pm.me>

SAFETY comment in rustdoc example was just 'TODO'. Fixed.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/sync/aref.rs | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 2d656f672b97..7491382bcf29 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -137,7 +137,9 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// struct Empty {}
     ///
-    /// # // SAFETY: TODO.
+    /// // SAFETY: The `RefCounted` implementation for `Empty` does not count references and never
+    /// // frees the underlying object. Thus we can act as owning an increment on the refcount for
+    /// // the object that we pass to the newly created `ARef`.
     /// unsafe impl RefCounted for Empty {
     ///     fn inc_ref(&self) {}
     ///     unsafe fn dec_ref(_obj: NonNull<Self>) {}
@@ -145,7 +147,7 @@ pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
     ///
     /// let mut data = Empty {};
     /// let ptr = NonNull::<Empty>::new(&mut data).unwrap();
-    /// # // SAFETY: TODO.
+    /// // SAFETY: We keep `data` around longer than the `ARef`.
     /// let data_ref: ARef<Empty> = unsafe { ARef::from_raw(ptr) };
     /// let raw_ptr: NonNull<Empty> = ARef::into_raw(data_ref);
     ///

-- 
2.51.2



