Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2B8606A331
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 16:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CCq0VVyu
Received: by kanga.kvack.org (Postfix)
	id 4C0586B05C1; Wed, 18 Nov 2026 11:20:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498D66B05C2; Wed, 18 Nov 2026 11:20:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 387F86B05C3; Wed, 18 Nov 2026 11:20:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C9BF06B05C1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:20:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 264D81207EA
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:20:11 +0000 (UTC)
X-FDA: 85448751822.14.62F6580
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4CB83C000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:20:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCq0VVyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795018809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uCzsAHfG2GG1TKcmv3qtbUoyTJ0D8//If2TmNeNJT/E=;
	b=U2X55IfTn2dtiOmuGyj1hAVgmMKInlo3m4IaE2xQxUG2hDsP+cH3U1+xcAN7UIwv8QvJbg
	bIp8q/CvtlcQuETqAyq29ZnVx88lNH52sSmlLfqiVak/GXqx9CTzYohDFO1e8YWEApHe0O
	rffx9TfKVYJOZ034AdXeCf14DZjFHTk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CCq0VVyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795018809;
	b=6PMALEgEgX0Mxjlexy1hANgEqHidia4j0LqoWYaaEk+/x835QHeTZF5z4rcJNAuZZkcpc4
	Q1XjxnMHxVLvWBxvEkKQSuVeJgWitfMd0vv5KTsaHitROiL0xUMeId4d++JnIhXVbIBdyA
	onD0O5eSRSrTl2SsYMNYjkdCpL5tdAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 910B440569;
	Wed, 18 Nov 2026 16:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71D51F000C4;
	Wed, 18 Nov 2026 16:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795018808;
	bh=uCzsAHfG2GG1TKcmv3qtbUoyTJ0D8//If2TmNeNJT/E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CCq0VVyuaZC7TMMPGtFzx0XVDuzrN8oYqqSdjQTubBqqPg+5uDqo5Vwidu0OEUGzD
	 ts5syafrdMKiinQ2d2noDr3exdiuqZMWz2WAYaNPlU85FgzKEGUK4viWJOCjh7x0VC
	 XYTQf7PMrTUPe6CGhmxKTl8SpxHfqJbF6Q79bgxTYDpZlUimNLJAMX188K+HxRfU3Q
	 sayQpTC4FAuiZw3qULX7l5u7jerfC4G0XinvfREsVpnsjaWFiF2b+h4S24tikYJ/zD
	 JdnoUbq3FxrHbX4e/ubU/0O25yU5IHGQ3+9DnHI0JCqZkuIoxkGfKeN3LZ4ITBgzQi
	 4vd/6RUa/1nfQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 18 Nov 2026 17:18:18 +0100
Subject: [PATCH v22 2/6] rust: page: add `from_raw()`
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-page-ownable-v22-2-d63ff73f4075@kernel.org>
References: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
In-Reply-To: <20261118-page-ownable-v22-0-d63ff73f4075@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Uladzislau Rezki <urezki@gmail.com>, 
 David Hildenbrand <david@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Mike Rapoport <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Wilcox <willy@infradead.org>, Danilo Krummrich <dakr@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>
Cc: Igor B <igor.b@beldev.am>, Vitaly Wool <vitaly.wool@konsulko.se>, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2376; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=RFqpoS61oPhlsX7JmfJMDZ9W0OPZutOP01Pks9DxGDc=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBq/c/vZPk3whkK9euDvasPgkdkOb+N5sydCBf+X
 HvnG8ly1TqJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCav3P7wAKCRD6UCkIqsW9
 0L3mD/970WoLXCH+ipc7bu6Yv3qRN/TjkLpw4TjzbqY2hfJtejMwLbE/1/X4JQGysFX62f6IGsj
 KWjwkH+aaAsuCsWoYzh4UMz/e7mXUY8MRpuZ6YdvRv331JZGTgoupTq+1H9v8ae3lzsZjIhNm+E
 7ktho8mokfg0LCOivC6/blw4UbCZFlL98QK7sDSojzcaNQ7skfMa7OCTFnvyZPbFdKGyk73hfMv
 caIu8D4pwKa+AK8cMcr1E5DSttZ9R79kO1HdZHmXd2NjH+D5B2oaDjGLzssLAM+gSNS/HaFfU0l
 2PMGeFqqKSE3JOCPXQc6Mn4rW6dl5hfy7qiyGn8ohj+QeD2iMsmlyIDSKIbTJBZyGBpstHVhJOJ
 MhMmQI1Z23RgMMUZeqmZLYi+OVfGlQtz0W4Dgo9tYd7FeOLKIDRiuTIus3NHJXbVrU50S7Z3oFB
 QH2EZxq7dcCff6ZhG3Lxaa08r5jEPYpYIHjxeSAZyYfQAkwExjwT/+wazrf9sKsaKy79QuzEjlX
 bHiaEfTzY5Brx/Cl0+ZbfN169iARltNqCc3UMj2CzPh1eZaVgQ6ZHM8lzC7RfusGbCPL/HN6GZi
 DkbTfBEMXx1QpkoAKN+YnPFa0GHO/KztcvnsAOW2ipjjqX6MkxZCoS5IbI7+VQdPCtB+w/exme8
 VTjCniRarKb9oSA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 4CB83C000E
X-Stat-Signature: x7eyccztwboo7weoz3j9cnso8hdmscw5
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795018809-968341
X-HE-Meta: U2FsdGVkX1/9CKNC4qYAo4TqEK7jmmOUex9H58T8EA0l/RwYJV554Q5Xe7dsi3/EmpnN/qBVV9IA/bn2l3FTAulQzE47Z0Mbg6d+is6pMzkDK3/T6F1rx8wGvjlXxg2YxOTNbYLUnZmBOzv9bzfwFlXjkRmOcWUfw6D6LkPGO3cFVmy0cN9SsHRLFBJNclQ9VYq4oCu933QXXOS8C+agfmmcmx1pQICZZOZZPtz2/O2C9rzA4w1nnNjrN4f+/4F3YN5PpBuhGXsUmTb8nQrW16qeAzHU8OcfPGmrQSz65BdbsodhmC9FJ18r0oyAQQ0ctnc3EmQav330UePEl+QI5vk7vkvN7/yC5FIgIp1fTKq9xHKKNns7oELy6YQOpvrFalvVNF5igCSA9jMXBbHeotHXIMVlqB6EIKFt4h1eazn/jUqy3br0+N8DxKS7dp9gJXDYRlE9j1rP+U0e12NNTdzWXfEYf8LbwVARuucLe9bmXMqtGhHDbRg5uOWSS7MNmPIOLRcjNDUPpS8SeONsq+EEYDvA9HIWdQtKIa6tC5n5geXCP/UfNq14G7iGxifbyOV9xqyCyNXzMANixyNUwF3S9Rpl+LZjeEfVoAk7eysEwpkej37MQMOBH2VX6VD9KP5UBt7MpNWnS4/nnZVYWZHUrPld/gH5Pe+UbpiBb3Og/8nAz5Xvkxi8xgYVbVLnNW+0TAvoP6xYfvq2qZ9LCDd4DLBo7AE4WAhONfrzUSVpiib6JJdfrwkjzPWiHmvleRtB4E0MWgsmbtMjcWOqmSpsISkp/EQGtIJEKGd2tYAkZLqGmpomTnSUC9bbd7tAqMtiB2XFiR8OpsBJT/f7ztDkugjnT2Xv22rS9Xtr7zhSYdJ1gFi9KIpbm2qo/XIPQVAJgQ/G0NkMz/3cSKp5W1SHP8xorqAN+scgS5QU7O19qSd4x4vb2sdlTbaD0ikZ7+BoLUq1x/5xtVFVfAZ
 zmdf6BhB
 4B9lUrc7lxh6CeE78KxFHnU7HDthJc5lMPVHNodIzq2VR/s9qtipehcqaZzXLOL5EfRI75jjfVree/VNlU+4uZXTMPMwwY469XdsgUn1BvkidLt/aYybki/847BDW8zGONuMZ7qHQNK/4boh2UjYBSpLiuWUSyRAD7eNohSgmFkEI/dNWdXCkEIUkZf0Gn254S48NhgTYCaAB7N4tA0QyJOoD3h1JzwmSdfeOtxf5Y/7AMMHFt4jg2/LPKK5/VSGjjFUScOm/p9XG/0crrP0QKLDGRolqqodwOtIGGJcFw53aiKD8zw+EnWEWFSCTo4LKlczaw00WxaGA0khrmxtOb4YEWUyWeuB4lyICA6LIe66/IdMZBdhaEimo2qoDAgMJCDxMX/Cz1czME8WKp3+ZRbIg9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a method to `Page` that allows construction of a reference from a
`struct page` pointer.

The method is available for all page kinds. The caller selects the page
kind and must ensure that the invariants of that kind hold for the page.

A `&Page<RefCounted>` can be converted to an `ARef<Page>`. Thus, for
`Page<RefCounted>`, the page must be managed by the page reference count
and taking additional references to it must be permitted. This is not the
case for all pages, for instance pages owned by the slab allocator. Such
pages can be referenced as `Page<Base>`.

Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/page.rs | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
index b2a17c86e7de..2ceeac0237d5 100644
--- a/rust/kernel/page.rs
+++ b/rust/kernel/page.rs
@@ -217,6 +217,30 @@ pub fn nid(&self) -> i32 {
         unsafe { bindings::page_to_nid(self.as_ptr()) }
     }
 
+    /// Create a `&Page<Kind>` from a raw `struct page` pointer.
+    ///
+    /// It is up to the caller to select the correct [`PageKind`] for the page.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that, for the duration of `'a`:
+    /// - `ptr` is convertible to a shared reference.
+    /// - The invariants of `Kind` hold for the page pointed to by `ptr`, see the documentation of
+    ///   the [`PageKind`] types.
+    ///
+    /// Note that the invariants of [`RefCounted`] do not hold for all pages. For instance, pages
+    /// owned by the slab allocator are not managed by the page reference count. Use [`Base`] for
+    /// pages where nothing is known beyond their validity.
+    #[inline]
+    pub unsafe fn from_raw<'a>(ptr: *const bindings::page) -> &'a Self {
+        // INVARIANT: By the function safety requirements, `ptr` refers to a valid `struct page`
+        // for which the invariants of `Kind` hold, so the returned reference upholds the type
+        // invariants of `Page<Kind>`.
+        // SAFETY: By function safety requirements, `ptr` is not null and is convertible to a shared
+        // reference.
+        unsafe { &*ptr.cast() }
+    }
+
     /// Runs a piece of code with this page mapped to an address.
     ///
     /// The page is unmapped when this call returns.

-- 
2.54.0



