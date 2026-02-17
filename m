Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF2A8E6816B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 13:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43E86B0005; Tue, 17 Feb 2026 08:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1DC6B0089; Tue, 17 Feb 2026 08:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3B06B008A; Tue, 17 Feb 2026 08:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7CF06B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:00:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A7B4564E4
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:00:38 +0000 (UTC)
X-FDA: 84453957756.14.4792B7D
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id EF3DEC000C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:00:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L7yoJjBa;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771333236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4hQ/54nXt77VYVXs4XfMX29eXF0oqY1wB0KVxPzS48=;
	b=LR/qtV5WgSmx11OssBuxT3XJGjx7HnBEW6NNV9JdFFK6o8MIeArRDXHpGYJcAvs69oGyax
	xL9zYMq6/Epm3tm1kVkYVbFLZGqISoHTBKGkx70F3iavtZ8SVPP/o1+Q8IUsTUndmLPBdW
	Rkjl9k71OEICupl7T4kCZOzGrQfOaL8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=L7yoJjBa;
	spf=none (imf28.hostedemail.com: domain of peterz@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771333236; a=rsa-sha256;
	cv=none;
	b=FQbrOS5kQVJXa1YXjKcBV5H+euhwKVbtvsT8HJN6VttbxsVlZaiDpTE+lJiYoqtGPu1m1L
	IkEfIACaovfYDrzPLkSHa7xKKHIImutvMkQ6OFfAyGeYnRjd+76/TGLz1LANsi8vxrxs/+
	TRdMKs9N/guLwGa/LApFBVlJ9Hs9Cq0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N4hQ/54nXt77VYVXs4XfMX29eXF0oqY1wB0KVxPzS48=; b=L7yoJjBaA7IKrtmrvdGGkXYCXo
	DImo47qGhyqKHzrHBQdVk1afo5uhPHTX7OPHlh+LYKKk0P9H9voCxZKMEb88rf4CWKZipQm5ccMgQ
	kZq/6OQFYpCePnCJXUII1r/lkweniuOTUosb7Kog5O2sIKhnOXBokB+WQjt9yAN2elbjejvzHc4eu
	sMMxz7ZP5jITLkm920X6I0mkQmJ9S1wwgeqEGbtZ9mkKauQ1+9Ji4/lZeZG0CCZWMdrgOom7u0rcp
	HfMfwwP1+W+Pmm6PC6y3V9YVTpU3dUjdzW6+t5whYoctkcb30aqC7C40RxwjRIYlwWET2xVQrJsx3
	3Jgy4Osg==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsKgp-00000004RlM-0ElZ;
	Tue, 17 Feb 2026 13:00:31 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 9AB3F30315A; Tue, 17 Feb 2026 14:00:24 +0100 (CET)
Date: Tue, 17 Feb 2026 14:00:24 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>, Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Message-ID: <20260217130024.GP1395416@noisy.programming.kicks-ass.net>
References: <aY9PBfx3RRV7rXZ5@tardis.local>
 <20260217091348.GT1395266@noisy.programming.kicks-ass.net>
 <aZQ19FEeGgigdwz9@google.com>
 <20260217094515.GV1395266@noisy.programming.kicks-ass.net>
 <aZQ8lJJ-U_8j03Z4@google.com>
 <20260217102557.GX1395266@noisy.programming.kicks-ass.net>
 <aZRHJ7pSzOHruPA2@google.com>
 <20260217110911.GY1395266@noisy.programming.kicks-ass.net>
 <aZRWOIPThLfIZ1Ph@google.com>
 <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217120920.GZ1395266@noisy.programming.kicks-ass.net>
X-Stat-Signature: 5chr9sairzx6fyofaqb57qbbrttdkdtb
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: EF3DEC000C
X-HE-Tag: 1771333235-727794
X-HE-Meta: U2FsdGVkX1/w0c0JHbE20FlGP+5qetbrqklzK5NRg7V8BMeUmd/Kde4SUHwOOkjryg31a7M4jU5jhIdswMKM538U9hbbvggMOi34eZdD8qQFMMnPouSrivEgu9yLsRu+PMT8Tu8IbyOtj3q9HNJO4svr3g/Pnq0rgvQGcGmkB/0JDsPUHpFKqD3aZRZjbNCaemkwZXBJECGM3/I5J3v8+grSdggoryKBX7oCqqFp9B/J3b8LS6M+mPeattXBoXvyVwbBBoI5XrE0ObH6MWEMMgv/EZbaeyiH5RxtdIuXiO5mNO2IiqVL1wgJoO7req/WKtXa0e/6WyOurdbuYFa4Za6kMoIyiQDfkiYqBIyCqMPr1kBVFB/z8L1pptI1tM3Fdlla+b4qAH8BigEpc5iuswgG6smU805Y0WsJGSTtZA65pM3/bdPridNenPOzmu2z/50vZvknZIqZePZ1jn54q0WlWD/KxvATgOduPQ7xJEgz7E2JMnvnksynmZnoUE94McRjGu62IrLeiA6zUXrvoivrDyNmunK6Qk+ibJofHZh2zOuiUInrLHh02lGGqGJlN41mu8PHyFJj1ydoIAub9YSeZMTWDJ30awznJcU+RQIR1n03i8SIFVotaFxjw79yBcmNotgdYiyYAbSc3A2oPjiaVESUZza+GfJuJzb5/G7HEFXE/gwimQ8MiRy/li96akMzzYfUc6B4pXYLZZKvPQYt6F2mGSdED8x1KBEYa5ujAwWdkhMhUw0W4lxreBdGfoRo2T+lgdJFFqBkIlB39U3PAeKkwMru4UfbMOLIkX8jtwavbbv8xpd2BNOPbq872ix7DhiB9ys6DkoBqZzigDtjm3PbFHsgLPtZ2ZQsFlRpwbj1b+A7FGRMWo9iTOrBDLfaABxMSXSblcnvj4zyY+p9eb8tRplAyM6/Z3LMlaeSZOUymt+4x41tFG8unqzwGNXd6FoqRjETHv10W5q
 yKSy7u7z
 EGUAbpxemHTz3e3c6S4B38mOh0wjJjXsLYQgJJbFQG6iiFDseUg7t9sLVGPsT311sszVDbiOgl94z/gbeICcpyulrQmVCIiZDvnWmDT5QLY2xWlGGtKTUr4HMHJYYwkCOPcOg/kqTHsX58HGu18rI+Y3vl1G6XKHVvTrw7e9lzf3LQ9TdoLj0WPreOjmfHhUFJ2iibo2he8w88uPCxoQieNQxNEhP9+YwFytik3c8qV2CVQvocN2bjW+hqi7w0HGGpRMu4ZxOzrKLfZ4G0oRiz/w/5QkZqYhfHuIt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 01:09:20PM +0100, Peter Zijlstra wrote:
> On Tue, Feb 17, 2026 at 11:51:20AM +0000, Alice Ryhl wrote:
> 
> > In my experience with dealing with `struct page` that is mapped into a
> > vma, you need memcpy because the struct might be split across two
> > different pages in the vma. The pages are adjacent in userspace's
> > address space, but not necessarily adjacent from the kernel's POV.
> > 
> > So you might end up with something that looks like this:
> > 
> > struct foo val;
> > void *ptr1 = kmap_local_page(p1);
> > void *ptr2 = kmap_local_page(p2);
> > memcpy(ptr1 + offset, val, PAGE_SIZE - offset);
> > memcpy(ptr2, val + offset, sizeof(struct foo) - (PAGE_SIZE - offset));
> > kunmap_local(ptr2);
> > kunmap_local(ptr1);
> 
>   barrier();
> 
> > if (is_valid(&val)) {
> >     // use val
> > }
> > 
> > This exact thing happens in Binder. It has to be a memcpy.
> 
> Sure, but then stick that one barrier() in and you're good.

Anyway, I don't think something like the below is an unreasonable patch.

It ensures all accesses to the ptr obtained from kmap_local_*() and
released by kunmap_local() stays inside those two.

---
diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-internal.h
index 0574c21ca45d..2fe71b715a46 100644
--- a/include/linux/highmem-internal.h
+++ b/include/linux/highmem-internal.h
@@ -185,31 +185,42 @@ static inline void kunmap(const struct page *page)
 
 static inline void *kmap_local_page(const struct page *page)
 {
-	return page_address(page);
+	void *addr = page_address(page);
+	barrier();
+	return addr;
 }
 
 static inline void *kmap_local_page_try_from_panic(const struct page *page)
 {
-	return page_address(page);
+	void *addr = page_address(page);
+	barrier();
+	return addr;
 }
 
 static inline void *kmap_local_folio(const struct folio *folio, size_t offset)
 {
-	return folio_address(folio) + offset;
+	void *addr = folio_address(folio) + offset;
+	barrier();
+	return addr;
 }
 
 static inline void *kmap_local_page_prot(const struct page *page, pgprot_t prot)
 {
-	return kmap_local_page(page);
+	void *addr = kmap_local_page(page);
+	barrier();
+	return addr;
 }
 
 static inline void *kmap_local_pfn(unsigned long pfn)
 {
-	return kmap_local_page(pfn_to_page(pfn));
+	void *addr = kmap_local_page(pfn_to_page(pfn));
+	barrier();
+	return addr;
 }
 
 static inline void __kunmap_local(const void *addr)
 {
+	barrier();
 #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
 	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
 #endif

