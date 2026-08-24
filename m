Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB32C61CE2
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 11:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E0CA6B0096; Mon, 24 Aug 2026 07:20:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5903B6B00AA; Mon, 24 Aug 2026 07:20:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 431DC6B00AB; Mon, 24 Aug 2026 07:20:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 171316B0096
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 07:20:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D3BE140475
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:26 +0000 (UTC)
X-FDA: 85135919652.01.FC990FB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C03E180005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 11:20:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9EW113i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787570424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gsf4C31WIGEdvjURLO6bh8+KS225jhHsASFOIqCjPTM=;
	b=wZRa5/TmU6xfgxPs67wjDRAsCp9XxJz0Omdw1guCiwj1a3eGEc++ZsjIiB8TrofPQr9CdO
	6Wge0TGOuEO9PF7ZnFQqjHa9z3O1g44EzG+tLhEaNg69SVE6EDE3Kb8WCIrM6COQK6/4C3
	+VyrNeeKwLRc9gRL6ArkzrZXmqo7ImE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T9EW113i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787570424;
	b=xiry8Vdn4in4ea/ExvPif6RuOqv9wBngW5AVhUU+Ob6j7sKHQYTWBGxd1ZDtZa6yml2jwa
	8713WD1Mm/dfzpS8tMdbbwcONJGacYl7yesBHeh9cbvij8hEXQh2F5t3Lzfgj82N4Xxigm
	nPMZ6cBjlg6N0xDMCoPhXqicAJFv2eY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F94B40B58;
	Mon, 24 Aug 2026 11:20:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56B1E1F000E9;
	Mon, 24 Aug 2026 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787570424;
	bh=gsf4C31WIGEdvjURLO6bh8+KS225jhHsASFOIqCjPTM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T9EW113i0F7o9cpyn0NKMrr4qzmRV5ZF8U/NZoyuc8hneKIS+m7cpuDvzSVgPWLv3
	 UZ/T59ijq/leurmQCv1iHl0cmEuk1NIzbIWD6fJx8EeAGt6U1JI1XyOxMxA5DDGolk
	 cgOQmWmEn9qSTztT73EmE54JnIvSFMBXxz1qP+EiXrnNjG8t7VS3q0HgSuto+OVHb5
	 K1G1+3cT4C6dI3/1VVHMRa7YVVcSo8rBEa8pYN4f07pLSh1dQdd8A+63hq+JoW803b
	 2R0aVMMZrfm+rKheifoo5O0r8MXv+DayvLLCFDSDOnBonW+N25ZJmtopKH8uu/+ZSn
	 N3LkyVXe2gdQA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Mon, 24 Aug 2026 13:18:00 +0200
Subject: [PATCH v20 8/8] rust: page: add `from_raw()`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260824-unique-ref-v20-8-490735672187@kernel.org>
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
 linux-usb@vger.kernel.org, Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1324; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=wkOYacmcCbns70mMJJNOqXe3g11b+kHYA0S0dbdXM7c=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqjCiGqEXZYrPpUe2ITj4yrNHK12u5/qghuV8op
 wHiEF9/CzyJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCaowohgAKCRD6UCkIqsW9
 0FasEACY3/FKckvX+qb6nS6iG9Xov+RkCghkBwWrcp/pKjcC9tE3uc6u5dni0Jlv0phoXM9ZRCq
 4Oiskvu/fzDYM3OpBsN5yPrYo5z4pHMgQ1iyZ/E4PT2Qt3U5csMyACtNOfzK20rc5GW+JFzxdSm
 GIwUm1bZmMmmNMMZRB+8ErW6F9CbksrWSHSDwxAJMAQE9ePY1NSP3y5e06cyaZzR5dJmIbd8Qhr
 iaKt2yKFZKa4w9XJTygaZ1X1ufWNpW0NaoqexhZ0Gw1ms6cMuvFEjI4/N/xLlD5YPdiEhExs0NT
 qqL2XTiWvEQ6MqT3NkIe0DeoXtWwmA/KXc72ctatlG4NwhOrqjPanKOBFztt2qMEGDM8l4FIZlL
 DpzZe+X6qPhXJBkNVuMQxBhztKCpOjbSfd32N6Lj/sZX6MIrzjOvvAX/lkZodnyZAqNctVA6OEx
 cEtPjNHNN86XW5r6RbLvk/5f2Xz9Ma85CmnI7b9PMULgpQ4y9DKOXgxQqXwyqph6gf4Hpz0DZ5N
 3Vci9dlrdolAiJLda0B0TkW4nnyv76G3i538Khhkr6C/u8tAJfA7Bb6K/GM3QJew6tJBXduGUdx
 YYs+T2vtUZz9CkjJrbvnHCPMJFQMH9cbMvEkos3w8s+D6i03ispYF0phnZ+cSWLIoLItRLQxpFZ
 cqeuQ7JvqxT38Fg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: C03E180005
X-Stat-Signature: n7cutff67yc5prrf4www4cd19ssjxhm7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787570424-100333
X-HE-Meta: U2FsdGVkX1+1OWLvPiRCwThpGmklvBxVtz+xf2hLEHbMYOkGSo7NslyWNmXh7RGOIF6AX+c3fCqfpvOu0vzlFGQSEEaI+a16WL5dalgwTz3x/i457SKL0YCj19gQkq0+tvn9S4qAOjj4/0llvNVekGXHPEc0o10Uvucimhfhd80VSSZa2Q0y4Nj5z/M02T+MbVhNbg0/fk6rOvQYW1SvsRBwW/HqH9+kyfNFGMlRNe61Y3iCEovEsiYZzLza2ejCBGWivWThuPBeKprR20cVP806Ja+5gdAw69kjK8zRTQ9il6dld8r4S+1C4L0p8ao1INR+rqxxwzP3b8ByxfuSe4heG77CfcpQk0ogKNNQNigarANETXIslsj0kI1M7Nbc+0NNqbBB9CcAVXaUX84YPa48IqcBNTlN0uZ+WMMg3QwvNokw3opfLNvb9YdRTeXxhSWDm89FkZxRJOC9XFQDg/fVE24oTg6zfYUAz3PjXXhsbBztKv23r4xZmcTasUcbqf+sl+Lypk7wm22LcNcV7KgTmScw0Z+NqBTbxQPRxTv2jEZvaxo/pQzTHMFULU7dpCHrRIAEkxOlltddDqSmAqVgc/2JCDMP0q5BpZd1Q9YwUagdwpM8kAOa9N10pOThPMmVsLtlxaQ+zqi20Lsy6AQGHhmAL1Mm8iw/uyj7Mr4Ohnw5i9+Qeh3viVnx5ucAqaJaKBl1WLdHBj3hYjvhHlADKPbYnUVTyzru0tXMaKvXlcCzp0NIiNBV6JFWg/nquFLnsRQrXklUfK/Hk2BsEmguQHf6nRDRtNSljgUyXDw6FzblEusI7NewV0/S7bODHQjYzQ0kWsne6ox06Y3qlOqOzXgIbwaLT3XyWqg2yuTRpeLD3kVX7nIikq+2laJj3oOoqacJ5PKL3UsWXU25nBqOKgq47G6mXyTi3AYwWwuYhVQuNTmQW3D1HRGTPT04EJ1OuvHDAtAUW2/MQh9
 wuMulzlY
 PVtM2b26LdsJej+dHScU/BmhcdvrGjHZ8jrML11WTBZUYVN9tsfhcSFTMImKgfGqvmy41upvw3lK+fmo3YbixryK6UTpMFkW0JkthX/Z7sK7Dn+x2b6wTnzcTCW0tUwD8h35hvXq9y4r5Qw47llbf1BvqjDq21XFrrcDwagsnQ0Qe3LxhtmVryIJcblPijPwKyIgnJgoTJ6FI+QdpacLU4fN/AfVMaRIUEqwpTEsDOd2/NT6pIkwvhv+izpfZvpU5fncZIhUdFzgQx7nPYNATz+G2o0u1fTxojBKOlJK2bjcu5/0+k1i+iUauCZdkjNo/lgx+N1EtMLzsi1oHtnddGHF7TFA/WhHNsm1T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Andreas Hindborg <a.hindborg@samsung.com>

Add a method to `Page` that allows construction of an instance from `struct
page` pointer.

Signed-off-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
---
 rust/kernel/page.rs | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index e807ffe3cfef..32dd030c8315 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -144,6 +144,20 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page` from a raw `struct page` pointer.
+    ///
+    /// # Safety
+    ///
+    /// `ptr` must be convertible to a shared reference with a lifetime of `'a`.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // INVARIANT: By the function safety requirements, `ptr` refers to a valid `struct page`, so
+        // the returned reference upholds the type invariant of `Page`.
+        // SAFETY: By function safety requirements, `ptr` is not null and is convertible to a shared
+        // reference.
+        unsafe { &*ptr.cast() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.51.2



