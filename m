Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10B70606A33C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 13:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Llrk+tFS
Received: by kanga.kvack.org (Postfix)
	id 69DF46B05B3; Sat, 21 Nov 2026 08:12:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 627506B05B4; Sat, 21 Nov 2026 08:12:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5159F6B05B7; Sat, 21 Nov 2026 08:12:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2396A6B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 08:12:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A23DA7F97
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:29 +0000 (UTC)
X-FDA: 85459165218.24.C8652E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id F30F920002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:12:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Llrk+tFS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795266748;
	b=b/lFB6gYwxMZMmDIHsyltsCbh89MdYrnIAujgq5ROWp3v/mwm67KnE3/5zMREu9QF0oF/a
	n4JPaVYK0WivF2uzSgBcua9V6M/QDDUpJJju2dB9wo4vJjJZ/E1P6nv0/2ZkknpmWxX2D1
	LEyqbo1ELMRPAYKmMfa8pT6dlML+hKY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795266748;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aUInXzI86QP6XpSIJdjuc+h3UvYC3aBfWl+Dnv2U0Sg=;
	b=AJaMZmVMlhZAa768APYbwECAvD7GGqG0NZEmZ0seiLmGix3SXNwAew9gOZSYKtZuADjWeD
	bRokPqwLMaIYSHSVeEGhHLU5Ka6xQVEsvMICMvBxjnQhbkGCLxDh3IpDg6zzSNwltNOJl1
	LDpRU/XDb+G154vm6Khm4OYRuF7wrNE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Llrk+tFS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4007045AA5;
	Sat, 21 Nov 2026 13:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A401F000D0;
	Sat, 21 Nov 2026 13:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795266747;
	bh=aUInXzI86QP6XpSIJdjuc+h3UvYC3aBfWl+Dnv2U0Sg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Llrk+tFSr3xP2MdtlmslXpezU3EZ2AF8OK1Crd6dP28Bl297cNs5BAcSQM19zP7Zo
	 4TryAogzYTq6hIGbrnp/l/E7UxaVThzXQEk0jdBlV6LDcvYItMffMtLoBNm5S0Qe3a
	 2d5f1Na0MoUjra2Ox4kZJXBK/Q4uaNALX3VnyIcwMdoyItDDT0Wq2tcfdYyMr2EPHG
	 bTSNc40zg0URZt/BJctkeLdnJRzagrtoPUtXvKMQ6El+FSNIuWkw9JUmt6fOZ/fkur
	 nTzP95wTOEQepXChR+PDsvf6+Bd1iC0HcRGhohOAEoGClXR0ZSf+6+INMkPWAIW3IE
	 zhsdbiROBiDMg==
Message-ID: <sashiko-outbox-227049@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 09/12] rust: mm: sheaf: allow use of C initialized
 static caches
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andreas Hindborg" <a.hindborg@kernel.org>, "Tamir Duberstein" <tamird@kernel.org>, "Miguel
 Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun@kernel.org>, "Gary Guo" <gary@garyguo.net>,
 =?utf-8?b?QmrDtnJuIFJveSBCYXJvbg==?= <bjorn3_gh@protonmail.com>, "Benno
 Lossin" <lossin@kernel.org>, "Alice Ryhl" <aliceryhl@google.com>, "Trevor
 Gross" <tmgross@umich.edu>, "Danilo Krummrich" <dakr@kernel.org>, "Daniel
 Almeida" <daniel.almeida@collabora.com>, "Alexandre Courbot" <acourbot@nvidia.com>,
 =?utf-8?b?T251ciDDlnprYW4=?= <work@onurozkan.dev>, "Matthew Wilcox" <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org
In-Reply-To: <20261120-xarray-entry-send-v6-9-1f69d7385f70@kernel.org>
References: <20261120-xarray-entry-send-v6-0-1f69d7385f70@kernel.org>
 <20261120-xarray-entry-send-v6-9-1f69d7385f70@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 13:12:25 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F30F920002
X-Stat-Signature: owfn4mdg3guaqan7tcd49j7uyffzd3fs
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795266747-898551
X-HE-Meta: U2FsdGVkX19cT6fErnHLeG6H95tIPVJ+tUvgcntXIg/EHh7gLHdlZMN4jBLT/i9z8MHhDrMQWnWD6YgafGd3Eq4WOIqU07gPDgNFTOVuKACp+E6FkFqkMS9pJPLmXXX8JpJcU/h/9Jisp028KOusE85n1xV6/NupY5/H0JMWF/8GC80rXmDwpafKATniB5i5o9G5cN31LGpBztSQPjTtrfBL1l3rqgbwzIYYlF4rI+HXsuYb1B98yXjOMAPRph8Xn4J0tu3MnQHNSJ5AE0AXaNOVuAEzh6n39+iZMJR5QYjGj7cSuKodDVbFxssW3QIdmvPdJLI6gTJLYb+B29bTdgdBvorYi2XhAUcbXddi0wIyyrDnmsHJ8nExdkJwmVeJy4yi2M9GGbFFnj3JK1Vhym42pucMfm1pfHi1PLqxNF0L1poqD8+gK4ZXAJeLUCGxnH5Obm+YZve9n4lHvOs8Tz5zkY/gJfSGCW6xHV05blQUgSH88RtlEbecvxraLK/k4stqenXXWvatqFbZ/pt8rBW0reGOXKgS7nHkQfQ6arp0aVvGghwvWIotoyYQ3TlmxmgXo88e3J1T8RQYP8sP+tTdh9vzpBAz4vXIKxRWPPZiFGP+VhsKgsnpEknJc+sLtwFAFo0pQmUTfCHFTyPp9oSGAi1V6HPLVxVFVfEPy+I/sL8ocIn4geyNcl4xNx7XuIrhGyYZ6j6dgDNssv5PtJmkkxX4gb2FjbNTQbC/QQJIA0o2HnclRZVBQEsQwKEG6JHNp1X3SW84mVVeWlYALKchFnOKT1A6vGpOfQb0DxMgq4zcopGonN0qlj4xM8H4SWNgeTdAdlvKLL3ft6uP6TzWsacIuinMw/L2q7D5+ybpYtwugULbGRlD0+MmjAemBch1L5WlJ5COakWkGz0h4MIhe3dbv7SrHPO6t8GBz+nL4mTROFhxAw+h10PoBZiQps+DxasK1lXq0Z6gCsI
 Cp07+/Yr
 4zt7b1qHLOK9+QZhOE9raAdVaRvO22cwJfWkPW7nGQz5uV1GMXsnT0jFLXQUsyKwp8rJq/oF/+yWRC+DqFWtBoOre8bNO9AATJPv6ytKFjG7FJLxAW75G13DIWMG9zOo9SwoB5tqo7Eb9LA6QBIs4KurpsVIdqn1Z6BAT2lVSSk13LA29rr7jMCzB48JnPO//hgFoVmCFvbc55Vrok9mU0hTVngIU4SR1/bzsOxtGvzLLipVq84u9Nbxo0qkFhMGsg8kUok44t2X+VPW8EBfSbfPbBOg6P4P7nN0E/ycx94R26LO6p88vUYpwyRYZvqqGsXkRqG12tucFdyMiPeKWKDo/ZiLrD38ut+TvRvZFQFMdl0UHH/3XIrue8nuiJnb8TLW/70SYFloPReim5ljbFNDT6bjYI7RP7DzAs1uLFRMsLqArHYZP5vPrzMEDNF5EuXZqMvE7rSWVa7m+sqRXPIVB8yvWrfNxMzlJ7qCSdeIxyXTCO7PRv1uslErprlTejeUEM3TfDnrhy2i+sklAGHjUnU/T/8AlvtXOJFRq8ZkGCiR1dGgx0bJgaQKLlr1PQlme0vA66CGDPgrPHZJOVv8BhzLIQoqIPdKqV+BaiEWRa92PsOu0Dos5l2yMgqxpTs5HOSdXyAnJ5hO8nXZ1IuqxaTBRXMInVEPbxNiFWRIhSg/pBwYdUKQ+aJ/QEuk0X3uoO9e+Zijy9NtMP/A/3KDcLAkpx3++1TtwI2ZREs0pqaJ7IsYiDobnyNTnHRYHsMLhITukCAFBToCV45pDROTL4q8K5ViUpPXFDApEus8SMZk2GT1XZQN1XR5Soh4ZAnkn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [Low] rust: mm: sheaf: missing #[inline] on small helpers and
  C-binding wrappers
- [Low] rust: mm: sheaf: non-vertical crate import formatting
- [Low] rust: mm: sheaf: SBox erases cache mode, allowing into_ptr() on
  dynamic caches
- [Low] rust: mm: sheaf: missing INVARIANT comments and raw pointer in
  CacheRef::Static
--

commit c03ff5cdfb00d1a6cfd826320ab8e9750410636a
Author: Andreas Hindborg <a.hindborg@kernel.org>

rust: mm: sheaf: allow use of C initialized static caches

This commit extends the Rust sheaf abstraction to support C-initialized
static slab caches alongside reference-counted dynamic caches, adding raw
pointer conversion helpers for SBox and exporting the underlying C sheaf
functions.

In rust/kernel/mm/sheaf.rs at line 95 (crate imports):

[Severity: Low]
Could the crate import block use the kernel vertical import style, placing
Arc and ArcBorrow on separate lines?

In rust/kernel/mm/sheaf.rs at lines 172, 616, and 717 (KMemCache::sheaf,
CacheRef, and SBox::static_from_ptr):

[Severity: Low]
CacheRef documents an # Invariants section requiring CacheRef::Static to
hold a NonNull pointer to a valid KMemCache<T> with 'static lifetime,
derived from a &'static KMemCache<T> reference, and CacheRef::as_raw()
relies on this invariant in its SAFETY comment. However, neither
KMemCache::sheaf() nor SBox::static_from_ptr() includes an // INVARIANT:
comment when constructing CacheRef::Static, and SBox::static_from_ptr()
constructs CacheRef::Static by casting a raw *mut bindings::kmem_cache
pointer rather than taking a &'static KMemCache<T>. Could both construction
sites document how the CacheRef invariant holds, and could
SBox::static_from_ptr() accept &'static KMemCache<T> directly?

In rust/kernel/mm/sheaf.rs at lines 197, 548, 628, 694, and 717
(KMemCache::from_raw, Sheaf::refill, CacheRef::clone, SBox::into_ptr, and
SBox::static_from_ptr):

[Severity: Low]
Could KMemCache::from_raw(), Sheaf::refill(), CacheRef::clone(),
SBox::into_ptr(), and SBox::static_from_ptr() be marked with #[inline] to
match the other small helpers and C-binding wrappers in this module and
enable cross-crate inlining?

In rust/kernel/mm/sheaf.rs at lines 667 and 694 (SBox and SBox::into_ptr):

[Severity: Low]
Should SBox carry the Static or Dynamic mode parameter A (or encode the
cache reference type via A) so into_ptr() is only callable on static-cache
allocations?

Because Sheaf::alloc() erases A into a runtime CacheRef<T> enum inside
SBox<T>, SBox::into_ptr() is exposed as a safe method on allocations from a
DynamicSheaf as well. Calling into_ptr() on a dynamic allocation triggers
the debug_assert!() in builds with CONFIG_RUST_DEBUG_ASSERTIONS=3Dy (which =
is
not mentioned in a # Panics doc section and contradicts the doc comment
saying it leaks a reference), and permanently leaks an
Arc<KMemCacheHandle<T>> reference in non-debug builds so the underlying
kmem_cache is never destroyed.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120-xarray-ent=
ry-send-v6-0-1f69d7385f70@kernel.org?part=3D9

