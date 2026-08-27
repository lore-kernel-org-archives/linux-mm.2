Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2628C61DC6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 01:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11D16B0088; Wed, 26 Aug 2026 21:05:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2946B008C; Wed, 26 Aug 2026 21:05:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B3F06B0092; Wed, 26 Aug 2026 21:05:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 692196B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 21:05:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D267FA0268
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:05:49 +0000 (UTC)
X-FDA: 85145257218.12.926682F
Received: from sender6-op-o11.zoho.com (sender6-op-o11.zoho.com [165.173.180.11])
	by imf17.hostedemail.com (Postfix) with ESMTP id E5F4040003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:05:47 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DWEXHiJs;
	spf=pass (imf17.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787792748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2WO3BY8DIwFx+wgH7vWUtD3dKtC272CjNsPfBc4W8Ys=;
	b=wVNEA6L9fdSH2RHMPyKIuQ1Sa6IwAan3xurXQD4wIHOAiRdsS3+TMQBHw3IBdeOYumgv2w
	rnTZSgc5XLhjyzVtR5MX/zYhNeele2RNi118azMDp1fdlxC7iTzhf3fy40ewjWyfrBQjbJ
	gBzYLgr7g/1WanbD9zItwoWcBlyLkpw=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787792748;
	b=SbaNvLv14PlDds7jeJCgh5OgzvK016WAHaItSjw93Wmi7OGiR3ak4CkEM196FQxE4Z/b0N
	dNruNlTapwhg1MSWjVkd8O8Jzvd70FbQDuoy6a0KgiY1MyJUSnoB0XELYTKgM8P+5lDJf/
	jkW8Gzu8fupOj2h6yOjYfQeKOebUhA4=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=DWEXHiJs;
	spf=pass (imf17.hostedemail.com: domain of daniel.almeida@collabora.com designates 165.173.180.11 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1787792677; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=iNv68hOXy8S7ZcQaEJoc5roSJ9+oQzwD43B7H7tZCEd2Lhrp/NcDgIQzVvyGnXNvV+9dUAULJp2z+T1bYEjZyhjMhxPFvaAU8DZ64ZH576vIecbOCMSxYvBQkNvbYkSd2z1pZaFfd6CmraInq3mo+762kHbRvp6l+fQMjTZLESA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1787792677; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=2WO3BY8DIwFx+wgH7vWUtD3dKtC272CjNsPfBc4W8Ys=; 
	b=ZA0VstXJ1yIzmby+vrc/i04yTI4D5759dPp/hkdA+nhi9lCyMSzSSqOxWNv/Fi3Aa00tnk7N6KtrUi1vvxd2L76Os9V/qFaOp/MxBcUqXO7EwweriqHxqvMAts9HFOEIty/Y7CJp+HBF73T+RSQbCGl7mkE/jXumtHHRMIH/91Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1787792677;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:To:To:Reply-To;
	bh=2WO3BY8DIwFx+wgH7vWUtD3dKtC272CjNsPfBc4W8Ys=;
	b=DWEXHiJsGxIzW/OzDZQ7aLFj7sBantDs0M8/OuLcYZn2yPI5XKi2YEHpPsQjnSp6
	ivA3rA1j2CEVU4tsWR9EKyz9j5IcVtbHyIlvkPEc9Km5A4qruykgNlVt2Nb2uOOloQo
	UIU2vTF09fVE6Lv6e/k6ZWUC8u3dc7lUx7tw3Kh4=
Received: by mx.zohomail.com with SMTPS id 1787792674559445.2342580425427;
	Wed, 26 Aug 2026 18:04:34 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v4 05/11] rust: xarray: simplify `Guard::load`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20260604-xarray-entry-send-v4-5-965f6028790e@kernel.org>
Date: Wed, 26 Aug 2026 22:04:15 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Benno Lossin <lossin@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Danilo Krummrich <dakr@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tamir Duberstein <tamird@kernel.org>,
 Boqun Feng <boqun@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>,
 Daniel Gomez <da.gomez@kernel.org>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <4F8ADE4F-057E-48FB-9C7F-838EE4B0314E@collabora.com>
References: <20260604-xarray-entry-send-v4-0-965f6028790e@kernel.org>
 <20260604-xarray-entry-send-v4-5-965f6028790e@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E5F4040003
X-Stat-Signature: krgamcqddjexjgjattc5moe9bdokmmw5
X-HE-Tag: 1787792747-777752
X-HE-Meta: U2FsdGVkX1/xdVhx05xHmgej4qouHAhYtXqx4QoLgAzHzp7C6PkH6XDQElcONhJ2UOH8ryajNt/FBSm+gnklCouCdxbb/wBiVLDtVukfADexj1IkBTmBRQueKhR/liywpcjEnRQ1vyrxiWBq2/bjsN6/5jZc++I2B9hNqZIAC6b8slG077Q4y7HZU3AlgnxySFAE7OH0WjmlPpj8kwtXnEPyuRBXapxdgr8KvrugIDgDRhKCBx9PCEJisTtz9vJppqv/OUWtFiK/JJYz/0Lbm743YKffPWnfwoxsfyFIGHTfR+F/K/T0yOac2y2QZ+exT1/tYh0a15VrIyx1+a4deaAn2PWO/LfwNn9lvVnrOozZQWEJ8vMc+xfCji+2NRw08EiEBjpc91ZocuCA9K+HXTAu47GSFCWhN+Dv+k68k7tHFgFeJ7y+BTQu2/gM5CnuZJrj06p/tXCKATVYK90J9EJeV33X4mdQQ5XidPeMCQbrMnMk6EwANDMbwt3LNbB9Dj5Rn9sZ4u9qRtLRfrqvr3CZYI7PKIdY5B+tiQInQ/pOtHI/ppRFWjaRDVeexE90EkWl7RZWGnGQIA1th1hCe3TFpjnZ5hCJhnCS1hnf8RdmkpuYRgbCkcXv5UuY8U0XosQM9brzOHOzwXps7qWIyzbGJbd4LhmkoZxp0f9W7KqZFO4pjvH4kMiMUpv7MLXKvUY7n2aJU+GcgScvZ/bsa+E0eCMETkEdXH6qcXk/T4rBqx0eevyqSFpe8mMq57+mgn+6P866GF72WqEehwsu+3heeLozxvAEZ4IxJ3QHhD0cHJKIAt8lINc67TrugBGEE1ZPmokACnDarS3JDV4eiN182EWY8rlsk8yX1Ehx7PQnbS31bzE71lIAzK34orovOgleJauf5QiMsG8lnyEdM+geMXvMMXKS3v3+QqQXLaB+G9IOS772a7ybml/VcRBHZWABmm0GFu1wI/zCLFv
 z+xcZAiF
 42kI9gRDK6LFvlBJfUBJJ2DYIBL4AfvzFcNb0/8c4/bvKeRsiIlPUCNVw8RMdUX/v2b7DrPH1zNF491HqZsAs0R8M25ZNeBs36q6QBHhh5j6WWGEZ9cHTgLXUHOGMYaSfYBn5Ro6G1E2FHhuyE+0gpkEHQkcIj0UxjEQLtozrkQvCeLV2KmzqxudgALwdtAACFh9ce+Vhi3Dr8aofqj0ByNZYZS4hB95r2gMJVu7J70dbB5C/hOGVAMAJdDiJcBSKXdHCvrg8mKEW5FAw0hiBGyDmhIP8nwDYEF4CpkS+d8D2dhtaMefv+deR+IzwzQsSJze368usUkpe+hVkb0ZidJK/N5XuBV4CcjNVTpqfMZG5E6/nLryvlA6PXho2mDucGqkLGuARe92tTNnKmIwvWsLV79BwDSCtT4xrNAVwvIIC+5BtMrX9HLuRRNyv3Rx9c3pdymxHF8EJmHmb51XRZbwA95ztjo8c5FpWggo80L27pN94vRfAlsFQ0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On 4 Jun 2026, at 16:58, Andreas Hindborg <a.hindborg@kernel.org> wrote:
> 
> Simplify the implementation by removing the closure-based API from
> `Guard::load` in favor of returning `Option<NonNull<c_void>>` directly.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
> rust/kernel/xarray.rs | 23 +++++++++--------------
> 1 file changed, 9 insertions(+), 14 deletions(-)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index 05e6dc1ffe69..7da57c778669 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -212,28 +212,23 @@ fn from(value: StoreError<T>) -> Self {
> }
> 
> impl<'a, T: ForeignOwnable> Guard<'a, T> {
> -    fn load<F, U>(&self, index: usize, f: F) -> Option<U>
> -    where
> -        F: FnOnce(NonNull<c_void>) -> U,
> -    {
> -        let mut state = XArrayState::new(self, index);
> -        Some(f(state.load()?))
> +    fn load(&self, index: usize) -> Option<NonNull<c_void>> {
> +        XArrayState::new(self, index).load()
>     }
> 
>     /// Provides a reference to the element at the given index.
>     pub fn get(&self, index: usize) -> Option<T::Borrowed<'_>> {
> -        self.load(index, |ptr| {
> -            // SAFETY: `ptr` came from `T::into_foreign`.
> -            unsafe { T::borrow(ptr.as_ptr()) }
> -        })
> +        let ptr = self.load(index)?;
> +        // SAFETY: `ptr` came from `T::into_foreign`.
> +        Some(unsafe { T::borrow(ptr.as_ptr()) })
>     }
> 
>     /// Provides a mutable reference to the element at the given index.
>     pub fn get_mut(&mut self, index: usize) -> Option<T::BorrowedMut<'_>> {
> -        self.load(index, |ptr| {
> -            // SAFETY: `ptr` came from `T::into_foreign`.
> -            unsafe { T::borrow_mut(ptr.as_ptr()) }
> -        })
> +        let ptr = self.load(index)?;
> +
> +        // SAFETY: `ptr` came from `T::into_foreign`.
> +        Some(unsafe { T::borrow_mut(ptr.as_ptr()) })
>     }
> 
>     /// Removes and returns the element at the given index.
> 
> -- 
> 2.51.2
> 
> 
> 

Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>


