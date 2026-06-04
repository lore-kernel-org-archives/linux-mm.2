Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C95C6CD6E77
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 20:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4CB6B00AF; Thu,  4 Jun 2026 16:14:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CD06B00B0; Thu,  4 Jun 2026 16:14:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292DF6B00B1; Thu,  4 Jun 2026 16:14:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 190EA6B00AF
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 16:14:38 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3FC9161FF8
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:37 +0000 (UTC)
X-FDA: 84843332994.12.06910C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0EE1C1A000B
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 20:14:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Koul0/fk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780604076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G3TVjSgjK9G7CyHxcZcbdJi1JuXhkhXf1eJMpalGwTo=;
	b=Ka2swWuf1tZFRlgjnGUmJBGM14kmhtrlLY0fuBtJHGQoOyHdhEnYGETpYQgD5fWKATXF0K
	NvYqAJ1kL+3rSsx5BvZzWaV94gwvqzXu3yecyS+aYyf0EN5ziYHRrsYxzk2C0HBhPoFLEx
	2lbPfcc6b7I0nr0LIZxAFF4/LRQ0n9I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Koul0/fk";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780604076;
	b=gqn4uH0aehDFRT78WrS8eZuwLpWTB6Jgs73KVhCzAlEP3VVglJ55smeFYjGbTqAWIvlLkr
	8iItmHRKH4+USgsVp6E5uLv4eFtd637LOKkdwlXy7doEBTdF7XmLmBIQjBNfpMd3uk5EY5
	frrDirHw9HSzsEPK3R5HgW9O/aLboA8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5DACB41780;
	Thu,  4 Jun 2026 20:14:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1AB1F00899;
	Thu,  4 Jun 2026 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780604075;
	bh=G3TVjSgjK9G7CyHxcZcbdJi1JuXhkhXf1eJMpalGwTo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Koul0/fk1we1IaCTJ09OH1HS+PPhIUtV9DSBqsN9ivuoz0s/UmIQ2Q6kp6W8Z4/mu
	 ZF/Yxkjr4/r0P88xOyitn3hyuyev9JS+RNCrRgXiJu6OF2AVGzhu6IrA0HGDgZIPm/
	 4ClHjq1YDnPgBSpqrZJoqyanInFwWw7lbRXjOM7Nq/TN87cur4wSynpuOfJ6gJ0y9v
	 s0NWv/VGyf9weS7al6hGSQv05pLvqg0uYB5M0n8n0KrVAa7vJJ1Te6vUe1WfIm0dft
	 qxH6Gf/rEVZR2M6y4v/mPV2BgbRKXbCiXxY8/Q7JHtDuKZkxM9WnnuapYMrS8/RtVZ
	 o7mhUs79w09Xg==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 04 Jun 2026 22:11:13 +0200
Subject: [PATCH v17 01/10] rust: alloc: add `KBox::into_non_null`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260604-unique-ref-v17-1-7b4c3d2930b9@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1078; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=HIU6Nmu7iABl9KtQIYtvgtPsm8T0d+RqMDFg+vb7EbI=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqIdvnvaCfCPZprFYoyr5bjX3TfukME5Od6oPB9
 tR7l/9inKGJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaiHb5wAKCRD6UCkIqsW9
 0LVHD/9orCNW9km7eoo7svZph7kf2oFSscnDuSfnZbnknSzXSrxvmhwExeDA1cSgUg7ATS13m3M
 xpd+u7kmEAhHJpaerkAELxtghRA4/yE0MhmVrNvWeQpIHOya0srATnagWFriXahuqmMwDkzpWGf
 GT4mFbiGz+DAiE6iSQm7E3tvl785uUxtjXKpgqHSZT0HMbqOT0UxX4cztFf+i2cKC3D40Of5EDy
 BjE0KgRHNh66eYXVBnI1tjYOrOLbVNwfNdvhCpwo+PI38AbWVAU7qJCTO+yCPRsIVrcW+W3CM3x
 +tRe3sIbQORfl6dsfv+Noz/08sOpItUKm6c94Fn2bYYJ7VI9xbe6qrTQnXzmvuD2F3e0ArAOvIE
 2INo1C1b2Ky8odRfgPR6tvPP9k+FpeidXIm5n5kNm/yprJ76UETTS32XGwcO3fVDoFmGtPjq9fW
 nzxKp0nXHmqq8BrQf+RLIRYWnRjzpmB4XuhAfAAsTK3B6ib0x0oX0nFWUPk8+GOrnEfDhlNh9ep
 CsuBUXl5x3yrcyq7mCOBEYNuzZwxHLJtTsO1ycz90dn42DAfEfAw8HA7pI7dZ4zPXoRetBRsoUw
 F8ELxr+1c3uiHRADNWr0nN7b23n92tdEiOAINa+JakitVe3c9j3MS5jLOQCb6KBQfuu8bstQ0De
 BtJ6FehLCTXpwLQ==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 0EE1C1A000B
X-Rspam-User: 
X-Stat-Signature: 5swqx533wmdgjoyzueg5jm6fizdnbjug
X-Rspamd-Server: rspam09
X-HE-Tag: 1780604075-749879
X-HE-Meta: U2FsdGVkX1/BGcQOrUunLz8LNp/8C412HgDaopX2uccP/PkNfuqXLUikqmnAeAMeUjNoQk3PrUGz3qAeW+QjdJsC3xfaERFZqongRi5qXe5GGSpQk9kkY3vrr43aR0Kq7h8cmFa7uRjxRyOjNfiHn8UnD3bIgmHIf+aphKlNBmLfQFBHKbasKNK+u7ljEUP4iq8l82tWX6B+yBGFDD3opfo1QgN59jp1BnEyntDxacQim1XR5AovQX5iOFCKyEYX4K1WPu8NDM1JJ6tcOz+caO9kAY90IU5l93EuYfqVkdPxhG2er/sBNlOGNC82G8+Ejo8s7OPUH/oH8yQ+G83A5a/JebvV7oL0ciObWxo7sPEUpBO6naYuoQSX7bjbORrpL+z0gS+N2gGdcsq51E6QtXnPgsdqZhDWOnGkXwB+ia5aSp9wcs9FsWLD8l1sLuuvRkVPzxQ6LyfjYgly8hXYBI1R/P3+XP6sMcHn0PNGr+c0dCM/gz4v47jo6+N0D7/uzT7h01jVq0IN5epN2ArCw4ZH+d+kWT47NjCFpaSxIIjWXVvXL5tqgz5GCdpYKt9iY5Eq9yUPH4Uk9zslknaeYgjX+oAB+VIeyf9a9dqO9PC8Ih4WGc1NUf4bu3nNb4myK6yw9GeIaYZ3AV44OgdrYNZc7a+kiqvZpv6pVm+k5IthNiBb1ip9QyM/zFagOtt8coiU57oE2Kt0eQ8+iW3pq/jBPIYthF/Zf1SrRsXrcUAYdjv3R1jXfwjlwtvwTfCoLUsdtEvADj9lt54VXL1Q7+iiX34zDRks8FR3Py5kKBcpU04LsTheZyIOfnzBxSDGx7a1SYxE9WiRSimookeP6fdrmwtGTFzrM9xvSjfvRFSqnZxCVT1QKLXR/tC8MW10GEnWs9NyyvJDjcC2Z+6eLfCt8VWjjZS1CReKFZMRL4tm0ysTpiTWzETPv8GuPWg083SyAMaiQQ02H2HwrYF
 ks4jwkga
 tt8Was8xkJeuZXicbvZps2oghEQvnWVdV1f1/bkfTSfizupIu0h8gIolarHGmjrgtbIT80ZHfsDxibsODVjKnKhpuPw22JcH1s0jiYQqlIcmoLsjLKc7/9LVCvh0HPqsaNFvNnHCAJB459EnzzBYxKZ6h8dcFeujVJ+wKE6U5ggl8B78JzJkLd2MYEhUOKubcchrAlmWSuQ8x2JMXfI05Lk14uQWc9EXGlhE4lU6nOU1UX/qiQRPxt5BE5kryHjkpyK0J24hgh0TZcDMisFlxQg+v2GaGIyfyVpWmTrLmP+IOGPZT46HaSDF+oHyfqvD5rLBBHzFNn/hom14=
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
---
 rust/kernel/alloc/kbox.rs | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/rust/kernel/alloc/kbox.rs b/rust/kernel/alloc/kbox.rs
index bd6da02c7ab8..6fab67704294 100644
--- a/rust/kernel/alloc/kbox.rs
+++ b/rust/kernel/alloc/kbox.rs
@@ -188,6 +188,15 @@ pub fn leak<'a>(b: Self) -> &'a mut T {
         // which points to an initialized instance of `T`.
         unsafe { &mut *Box::into_raw(b) }
     }
+
+    /// Consumes the `Box<T,A>` and returns a `NonNull<T>`.
+    ///
+    /// Like [`Self::into_raw`], but returns a `NonNull`.
+    #[inline]
+    pub fn into_non_null(b: Self) -> NonNull<T> {
+        // SAFETY: `KBox::into_raw` returns a valid pointer.
+        unsafe { NonNull::new_unchecked(Self::into_raw(b)) }
+    }
 }
 
 impl<T, A> Box<MaybeUninit<T>, A>

-- 
2.51.2



