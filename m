Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBEF7E909A5
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 13:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072DE6B0089; Tue, 17 Feb 2026 08:54:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051206B008A; Tue, 17 Feb 2026 08:54:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95416B008C; Tue, 17 Feb 2026 08:54:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D70F16B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 08:54:38 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9609A55202
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:54:38 +0000 (UTC)
X-FDA: 84454093836.03.3094AB4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id EDB05C000D
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 13:54:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uqzRAMb0;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771336477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pti9jsHZdJat+kUdxpWFulNFOQxkQdNfqbuOxdLkJT4=;
	b=7KuJcKptLnGV9dyqaWAH3PWgcecfcxT3BAkoF/y1REHp8QIaIR0trR9JLjPnI6ToKei+50
	GfoUYkciILGCZrdu83G1FJ4t4siegwsnUlPP+CKIjXvyHVuYQtIyDN5q1ZPErkjET4eF58
	zTlobUXhU0gESjCyFucjBI+kgu4KxUI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uqzRAMb0;
	spf=pass (imf10.hostedemail.com: domain of dakr@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771336477; a=rsa-sha256;
	cv=none;
	b=U3Kt824vjLjPnxe7t/YZP5Aucon92ZOalQcBw0kMFvdy9rfhLuMIzX/+uOOc38d35yDqgd
	6XvKOyprDVE0+GSG/8OiUpuOrjaYwrKn9uJbjGgfQyv9C5oFDm7ke3xUg5pYkj0SyXm52m
	ro2pjcdUR5f/XPjWM4YmxA5DFiDfhfQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 42A7B6133B;
	Tue, 17 Feb 2026 13:54:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F8DC4CEF7;
	Tue, 17 Feb 2026 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771336476;
	bh=99T2HooY6pHq1rrH01nYWNcwZJswC2L6NO6HuF4Ryf8=;
	h=Date:Subject:Cc:To:From:References:In-Reply-To:From;
	b=uqzRAMb0BCJaq8960HcWza0oi2vVJBkyDMIUkKR0iuckj0mSutDZyRt10QQP8QTE8
	 q822EpYMoJXD5F1hl9OKJb3qCA850FkbAgiTX8tkXuIdbH/NGHn8HZot7aXF6SmeaB
	 wHQ2P0FhUo3Eh/MANiYYI1Oblw8XOaUOJWIAfDzqXv6Q32soh1Uwx/Efg0alJHvV6N
	 9Mk+cz/gVFaY9/NHIhHZO79R3XmVmxwtB1RaLhkUy0IKyXyAjX6ocV+3es+/tCU7if
	 FESBLLhCi7o+oA6OvxwgOLSGq3sELl6n/g9DbNgfZ6xUVUs+Ijw/+vSOEqND4QMGRF
	 a2CHJesmz5ZgA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 17 Feb 2026 14:54:30 +0100
Message-Id: <DGHADGXGWS45.1A6EHNMKM4SRH@kernel.org>
Subject: Re: [PATCH v2] rust: page: add byte-wise atomic memory copy methods
Cc: "Alice Ryhl" <aliceryhl@google.com>, "Boqun Feng" <boqun@kernel.org>,
 "Greg KH" <gregkh@linuxfoundation.org>, "Andreas Hindborg"
 <a.hindborg@kernel.org>, "Lorenzo Stoakes" <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, "Miguel Ojeda"
 <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>, "Gary Guo"
 <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Benno Lossin" <lossin@kernel.org>, "Trevor
 Gross" <tmgross@umich.edu>, "Will Deacon" <will@kernel.org>, "Mark Rutland"
 <mark.rutland@arm.com>, <linux-mm@kvack.org>,
 <rust-for-linux@vger.kernel.org>, <linux-kernel@vger.kernel.org>
To: "Peter Zijlstra" <peterz@infradead.org>
From: "Danilo Krummrich" <dakr@kernel.org>
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
 <20260217130024.GP1395416@noisy.programming.kicks-ass.net>
In-Reply-To: <20260217130024.GP1395416@noisy.programming.kicks-ass.net>
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: EDB05C000D
X-Stat-Signature: rq6us9doyt6sdnwp594o7b4hdkemgkgn
X-HE-Tag: 1771336476-178989
X-HE-Meta: U2FsdGVkX1+J6G4ZKX0ddIVh38Mq8W4IsOOXZxRPw0bcQ+BGXDLjyDKrJczjle9KbQSMg7rjGRzHGqArb4jV0d8MgppNRfOpPx28TNacFD2VY+HYIkpSH5dHmMWCU5vciNWmWZTrymmmub6j/LDStaRQkIDyxDQhyVnnaMwkoowniikgv5fknLF2TsWHhQdUIXVSq9gX400PGew5W5pV73W/zbifA+exHm0AhJBSbLYgHkqHOKR3YeV+oq3lbb8r8MsN4FgtQrs0Rf8y+L3DLyVfrtmrU3yJ+3K5luRZpEjsdeqzKyTJ+qkryt+Rrh5mpDLA4FOz1SlwhGj/oqGBZID8pYn2s1ggSu7IsogLw691fAEM3pHIg6aOUWhIa/gZOxCUnt1NaT9MBzLZj5SLDH7kxOHHdT7zUNnjgD5wwaMMZ2gflfzkLkEvCq2u60vtKneR38G9xY+tWcZOcUpk4NlBAckGrqSV1drw0F2WKQXKcmkCS7kYs1sOUJvZYPhVwMHu+Cf8kKNNTTylybqA+nz3ZyyaNV7l7LCrEZ7c9yGFdpfmp+4YobJXI5n2ch7EPwlREgySCohcMc509Het+b74uuUy7shqtAWLKIquY4oB4YAo3V6/fYU8w4aQ36IO0G552lJ/KPvxS1z3sEZwH0DWXqtYxoEqzUtIWLXt/ph6BCU2It15dHK6y2A6ZB2bD2Ilw/E3UZ0zwvPnbzsIOwRmyh/fR+TxRCp9583z2FVAJIaySZCeiJLWze+CE1CLXvc85eM+iCKrIyt32UiELjVXyJPO6qxfN5wN0SR7/oXuu7zvHRbLTcxlq3XwRxc2QolPu8Fl/GrW8ajr9fXm8v34OL1i8iVjt1W5maebD4ZmRYDqxBd8HpTntF9Bcaq0mCfx2QmbCgLI6BJsPEiTh+ASmU0d9YK/lZsl8So0eJDOh2EZNEKr7WKKSqrWQfxJdz+edcFKSWdvbIPXdpl
 tH2ISkNh
 rd1DTFr+TOVlwbpBw1lwNAexu/K1NXieIUVN/9Zlt0/dNEqOwvQ3zAXqfM5R9I13Is/9WlU91ZaofUbBFlRJ+taf+jMlGaPbf7VdfPaR3T7wK5FVKGwh4YtDeWV/zcngLFsq4m3XfhUcCXVGomeY2Fj8A6mCZgbUxegj+ZTIMnKYLNTaD3qMQgxy/ZRxGQheLBHsqE3UFFvZmjKxMvuBF6whw48SCxBW5lkDGk4xhhPqWenYxQ14w3zH2K2ReV6v8200JK7Z+EydMVkfZpaxCTAaLN20GtjJFiezsKTlXdQZbzjzpID3J+/onODiytZXIqlpN8/Y/x0qr1GqppdpOc+c1smNqgPSVMV3R+jaYhF18AthlQn6q7EIhFA+uHwyfYw9t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Feb 17, 2026 at 2:00 PM CET, Peter Zijlstra wrote:
> Anyway, I don't think something like the below is an unreasonable patch.
>
> It ensures all accesses to the ptr obtained from kmap_local_*() and
> released by kunmap_local() stays inside those two.

I'd argue that not ensuring this is a feature, as I don't see why we would =
want
to ensure this if !CONFIG_HIGHMEM.

I think this is not about not escaping a critical scope, but about ensuring=
 to
read exactly once.

> ---
> diff --git a/include/linux/highmem-internal.h b/include/linux/highmem-int=
ernal.h
> index 0574c21ca45d..2fe71b715a46 100644
> --- a/include/linux/highmem-internal.h
> +++ b/include/linux/highmem-internal.h
> @@ -185,31 +185,42 @@ static inline void kunmap(const struct page *page)
> =20
>  static inline void *kmap_local_page(const struct page *page)
>  {
> -	return page_address(page);
> +	void *addr =3D page_address(page);
> +	barrier();
> +	return addr;
>  }
> =20
>  static inline void *kmap_local_page_try_from_panic(const struct page *pa=
ge)
>  {
> -	return page_address(page);
> +	void *addr =3D page_address(page);
> +	barrier();
> +	return addr;
>  }
> =20
>  static inline void *kmap_local_folio(const struct folio *folio, size_t o=
ffset)
>  {
> -	return folio_address(folio) + offset;
> +	void *addr =3D folio_address(folio) + offset;
> +	barrier();
> +	return addr;
>  }
> =20
>  static inline void *kmap_local_page_prot(const struct page *page, pgprot=
_t prot)
>  {
> -	return kmap_local_page(page);
> +	void *addr =3D kmap_local_page(page);
> +	barrier();
> +	return addr;
>  }
> =20
>  static inline void *kmap_local_pfn(unsigned long pfn)
>  {
> -	return kmap_local_page(pfn_to_page(pfn));
> +	void *addr =3D kmap_local_page(pfn_to_page(pfn));
> +	barrier();
> +	return addr;
>  }
> =20
>  static inline void __kunmap_local(const void *addr)
>  {
> +	barrier();
>  #ifdef ARCH_HAS_FLUSH_ON_KUNMAP
>  	kunmap_flush_on_unmap(PTR_ALIGN_DOWN(addr, PAGE_SIZE));
>  #endif


