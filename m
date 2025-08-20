Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B88CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 23:29:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC3468E0041; Wed, 20 Aug 2025 19:29:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9B3A8E002F; Wed, 20 Aug 2025 19:29:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD92F8E0041; Wed, 20 Aug 2025 19:29:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7BD8E002F
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 19:29:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3ABDD13433E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:29:32 +0000 (UTC)
X-FDA: 83798729784.23.640A3F2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 76B991C0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 23:29:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vFHtrR7Y;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755732570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O6Xcd5vB4DY0A31Vd4kvcyIgQNYviTUmoU10Ja9ythE=;
	b=efJ1Ne6RiUHisp/Xv/x7FPEE4m9Vyn0mPdRxGgUpAERrC8S1Y+noTS0AXEjS3hl3fNvtNT
	Re+MJDBDX/pwCf8tK1NQpKNE1rD+2M05pekwio+1Cxm44fSP8BDaGGClHeaVqqWSuAjz+v
	Sr99xLDRLTMRnuQebgkWJuBLIVh4F7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755732570; a=rsa-sha256;
	cv=none;
	b=o6ZfDj/1NcpsVbK9xJXoV4MreNF0teoRkGRrv/oXtm/tF5cd7Q1TR6lfsKyejRyU/eqgdR
	Q+6pxFdJcYpK5hiP+XUpS/TgN9BdqP0hX8o9sqoUNqk+8hZ1Zur7ObmgluK14VApKLA/Ia
	MN3VGqhQF6biqZlioefhJrS1eVtH+u8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=vFHtrR7Y;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A1B044E68;
	Wed, 20 Aug 2025 23:29:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6B3C4CEE7;
	Wed, 20 Aug 2025 23:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755732569;
	bh=m2IaG1MY/+xH+rg0uCa+LUQv8zbg5WaY0KTukcGLEDI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=vFHtrR7Y5KroDJGCDi51bt71NRLurSsxOIIDM6sO5c8GU7/Q0AngyIg8cbtiA4CVE
	 fkeVumBm5YkU/2HVuIrhotROZ4hi9PyEoiCUlkFDf/3kgcSvPsp2oefxafa6t/etmc
	 3xtP/tcFRWpZUzFOyqrpnDW3r0USND7XQKXfA3l8=
Date: Wed, 20 Aug 2025 16:29:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Baptiste Lepers <baptiste.lepers@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun
 Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?ISO-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin
 <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Jann Horn
 <jannh@google.com>, linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: mm: Mark VmaNew as transparent
Message-Id: <20250820162927.34201cfb395ec7319b15920a@linux-foundation.org>
In-Reply-To: <20250812132712.61007-1-baptiste.lepers@gmail.com>
References: <20250812132712.61007-1-baptiste.lepers@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 76B991C0007
X-Stat-Signature: hpnibk47xkregsumbsf4d4sfzq5a7un5
X-Rspam-User: 
X-HE-Tag: 1755732570-200601
X-HE-Meta: U2FsdGVkX186A4PYhQLrz2lbqeS7hjzBcXnMTWcPVh+nIk7iSu7R6wAaZ97XQf+tpAmg20VdHiCg7R1syv1Vc5pZ9LdqaTlKwJAgTsg+jzesuAalGI0Y/Jf1lY0u6wKTDW/zFGLNnL+FTgw/0F2il+Ctfz+mHYq+7i5zeo4K+d5Huk+/+PmMBZds6SXxiC7Ahga8X9GHg+pmgx8EIWrYq0ClMvBNPko77txj8pgn9ZegorCH8hNk8eZOMp4ErnWKW5oBhoQTh9AEU1kT//k0kCqa80c0AOhsx6yq1S0YAvTsVvCBq8AALA5ciOgm//3YlUQV8UQ6P8eC/Z9gucwARzHJDvYHGG/vaXAjJN5bKAzhGhMDaewDztSYRQUWuorzIEL/QpQQeT7W+1JvChFzZ4NvsUEqeirKMjuCbCJGlLKR1PUeu53RaTQ4CoZdSxTm5gOTPPtL8pfmJNBIj0D8/t0pfLCl38MGGqxcg8JiYvwt24ZB0Z+eEfiuL0NFOFJ0yZDygItIxc4/F+ahXzrEUaYR1cGuB9MODSZwWZLr3pusglqPsTzz5arFfAi/aIHevBgf3R2DzHcSWCOgsbMi25w2zzuVU/T1XjolEPhn68OjguRKgIrJex7CxsWZyz03TFGeOo3CuQn8PW7j+AqSPKltGbiSATKzYM7KX36rZ7YtD9B9Fyjfx8RVJ1gadhFtP0rD3tJSsMbtVe+Krk30HDGXALHX4LCN50eRAiPXsTVIiVUrp4N+Y9rcXOhdZ0rkUmL1wz9a6G160SuQVThRoZOuOmbqVYkaDLFQEBXVswsacWGfyCEoz3B1x6s+7OWWYWfNU9AYSrdjFtM4aBMJ4fh7T/XMAy+thHo1DaPZkTvNOXwdwx8gF1ie/YCioEgbTO9k4TCdhUe/V2NxVGtIQ11Wz3A/AzUv81hPTHq8uXraqehn4pCnYfaX+kx0KB0HQdo5QumHR3FJhH8tKhl
 PQzfGgL+
 /lBNtv+fOIJId7sXgTYmnPgdb4FIQBFNblzsEo2CMLbYIXmnFDHRw45sBuLTqTdTj+b98TX/O/S/+i+g9zo4OrZSAakuT1x/pI9iA0NftVJweNYgpcnZS4TfV1N5ZotFcjo/6Q38GXsp6orMyxzDK8SpO3+9fGT1QxbAJHogtZSAV7LFG1lAVg09Tv7ZENUTH0ywQegjuz8jNM8JywqzNw09Mz35YEGaCHnchhj4RxgimHTrPzwAyWkKUvNaNSf7d4iF0JAmUy2NgPZqoGD56fqWetNp/R9TDKIBURsxcnB08sUVfPAldv9dyaCf4VyItZ9BKzInlrra9Y7mmOvIxPewALw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 12 Aug 2025 15:26:56 +0200 Baptiste Lepers <baptiste.lepers@gmail.com> wrote:

> Unsafe code in VmaNew's methods assumes that the type has the same
> layout as the inner `bindings::vm_area_struct`. This is not guaranteed by
> the default struct representation in Rust, but requires specifying the
> `transparent` representation.
> 
> ...
>
> +++ b/rust/kernel/mm/virt.rs
> @@ -209,6 +209,7 @@ pub fn vm_insert_page(&self, address: usize, page: &Page) -> Result {
>  ///
>  /// For the duration of 'a, the referenced vma must be undergoing initialization in an
>  /// `f_ops->mmap()` hook.
> +#[repr(transparent)]
>  pub struct VmaNew {
>      vma: VmaRef,
>  }

Alice suggests that I add a cc:stable to this.  But I see nothing in
the changelog which explains why we're proposing a backport.

So please send us a description of the userspace-visible runtime
impact of this flaw and I'll paste it into the changelog, thanks.


