Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8EFEB26E0
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 16:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 751F26B0095; Tue, 10 Feb 2026 11:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705696B0096; Tue, 10 Feb 2026 11:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632256B0098; Tue, 10 Feb 2026 11:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52CC36B0095
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 11:46:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 01EEE16063D
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:46:17 +0000 (UTC)
X-FDA: 84429124836.30.F54562F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3261E180013
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 16:46:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eSbhl9ly;
	spf=pass (imf06.hostedemail.com: domain of da.gomez@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770741976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I913gbapPDuhWnZXfQWc5CIsT1ntb1P03InGPaBhXU0=;
	b=2RLGnyIqUKTbz3le/30XbJJ2NnaflZtzv/F8DiQ+QnqHga7UH1BObmovap22ETgGGqmCX8
	KmUVtEpbc6djuFWApW6k8BrWEOPOfUpoNWkAtEIbuasS/RNDiSBaQJE2VuGrPll2f4P7r+
	KQt1fR7/7M/6+6xKd96VpEY1upbuARY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eSbhl9ly;
	spf=pass (imf06.hostedemail.com: domain of da.gomez@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=da.gomez@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770741976; a=rsa-sha256;
	cv=none;
	b=vxZQ1q7gjHvEqpFAvJs6CAa2LsdcUQ0mgUS992Lq3WC7iolv8j1Yj/P+h8/216VurcZLJo
	cQgm30HYJ5U5vzo547GlT82WMjJcXKhu8iJ30H4m0oh+e41FYJYDDne1xJocHBHLpzkEZA
	E7hQ9BgF5/DX0yv4HKxFTtnxSpn8VzE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A994419BB;
	Tue, 10 Feb 2026 16:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E50ECC4AF0E;
	Tue, 10 Feb 2026 16:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770741975;
	bh=okQlxFXHr0GfUR5XxlHMtgJeovD4r1bYBEfmdHEJlfk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eSbhl9ly8KVez1VkctsxefkJpbufNq4t6g9QBlIUUa8AYzca9bgSc8WbWFFQj2QaU
	 3uv11VUaQcGvMpAa3QM3XpgE0nCej6ypvl45zNfN2OOqSNU4M0cXFXqnZklv0dgMtZ
	 7vy2lz0Rnc/bNmD1o5ku35WIn1OHhgS8zjO7qeq41M690SRe03XaxUZ1PwoMQqh7OH
	 N9XZBRQ1MU0hXn61L7FoEdhGaBtdfhtSJl3IEBTMamz4IclH18uFExmxXI/GnlI+If
	 V+WLnW/4G1A8rcOd3Errr40Bp5O0RFvZ9/lMVP1lLwMcytrj3MEnsDfAMXDuOH/Az7
	 EAqzhhaSVr2lA==
Date: Tue, 10 Feb 2026 17:46:09 +0100
From: Daniel Gomez <da.gomez@kernel.org>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Tamir Duberstein <tamird@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
	=?utf-8?B?QmrDtnJu?= Roy Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
	Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH v3 03/12] rust: xarray: add `contains_index` method
Message-ID: <aYtW-Hg-ItQI7v9-@macos>
References: <20260209-xarray-entry-send-v3-0-f777c65b8ae2@kernel.org>
 <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209-xarray-entry-send-v3-3-f777c65b8ae2@kernel.org>
X-Stat-Signature: e4gfhoyiubuazroipoo99n4fojz7jjt3
X-Rspamd-Queue-Id: 3261E180013
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770741976-701264
X-HE-Meta: U2FsdGVkX1+WKczR9tCljl9TODspzE9kQqPsgLsMCqQ1V/qiaZeYV60rFEJQkC4mIaN6ro1aev9J//dzbn26SHB3HAVsDCVVXlzyursBXn1aVmq+LxwknLAJDdLtYWXKMblyF1rnSSxrJp6trFS69zraEtVo1AoKaBI6/4VnB0AI1EWJno0npsYWFDPj2gHopANvICisL3mYIwUC2AspKzOUchIu8qpR8ovnV1dAv8Lco6U1ekSN3Uplsma0pue1o6uhTqQJfOjhOuwOj/v5QXenHy5IrV1Il2D7cP146F1uZ5PoVMbu+a9N/8PcoUU8OLydTjHJAFslgGix2xkFFzGU5t1IWfSswmczmjx6IfpVoS/eNKrp8rHFjN7n7jbq7sJGWyIGLPqjBLs8czhfGQr8I5tZal1gTsv0aWjixiPEmvtCByoso5QOWK1g2cNEQlQpWVA1kiFpCQ1HApH602lF/hwJ90bsUrh3arxZ6LWWzw7e2uOypNlyZJlp3sH8cl4QqvDSkVCDMvEEP1mEStnm9OWQc0kyoLuqQYq+GpaE/1KK1N0iAvuAt9Yubm1N6ydZp0ZHh/CVd5JkBNP5S8b9vSgCzh3mV5+PxWRNGuIb/3qqGjtrazrGijeGoSXYBpDNgD5rpnlZ+qAIFvUssFDhieAqM7N6Y711JoFZuvn3FayjNq69MDP08HdaqXHaRjd3wGFlkhRytlkVNbkXOe7kKUVXuTrG92rigFB1VIa+r1P1vgctFFOqUSRSoUEHVCkX1a/433BTUtbClc4Y/6AVpbMtn+ViwU+Z60cknPNpDhxe0uMMxBHql5EKjtSlcCcnMqwkjIGBbiIOdKyRR9plVLi9n020EL0OVV+DNLCKxqRYSCA7SMKZjxYODX8Kspz/qW+TCzt+9x3sG0rg/O0zRyVjFY6yX0eeSIIi48XNBa91l40rCOWV40hA7Q9LXdn7SiRXjjXorNH3fyY
 1USgrxmv
 zRe7eRjPu2inUSdhatABWOZNcfQjUWAasMUoHz1AcCv8wTOitKAloxggD+jPnau6X8aO1Odn+P4+1DQmC8uo9A+qtAaVQejJlRqzMT8feuZtb7B501LMG9GtdltNzEwiWAnDWKAqtkqaYSFTBXjilNzRKijVt9vOgVt8Ib+2fjkPoOoF8AxMjpH1cf/jD0dxrBJqBY/XMSEQli0ig05KnVBwI6vIJoqGH3dp6kbva2RvCh9syvauaqeuFe1+2/zrlqqWrh9CkmA7vfrZGQey3YlQ6stkd/LTVnVWLB3Oqf+l2qyQb15ymniXLhUJ2+zWYi5Wbg0OEGVjwi16O21UZ+UXvwrQ7OaPFgRNfEr8JE33E7+oEfmkttlaKLx7BNFJOVN0TbL3xQuefdDmRLeBgORzHMxGhWMXnyGkG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-09 15:38, Andreas Hindborg wrote:
> Add a convenience method `contains_index` to check whether an element
> exists at a given index in the XArray. This method provides a more
> ergonomic API compared to calling `get` and checking for `Some`.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/kernel/xarray.rs | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/rust/kernel/xarray.rs b/rust/kernel/xarray.rs
> index d9762c6bef19c..ede48b5e1dba3 100644
> --- a/rust/kernel/xarray.rs
> +++ b/rust/kernel/xarray.rs
> @@ -218,6 +218,27 @@ fn load<F, U>(&self, index: usize, f: F) -> Option<U>
>          Some(f(ptr))
>      }
>  
> +    /// Checks if the XArray contains an element at the specified index.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```
> +    /// # use kernel::{alloc::{flags::GFP_KERNEL, kbox::KBox}, xarray::{AllocKind, XArray}};
> +    /// let xa = KBox::pin_init(XArray::new(AllocKind::Alloc), GFP_KERNEL)?;

Side comment: I'd also update the examples to the new coding style. And it'd
probably be cleaner in the first commit.

> +    ///
> +    /// let mut guard = xa.lock();
> +    /// assert_eq!(guard.contains_index(42), false);
> +    ///
> +    /// guard.store(42, KBox::new(0u32, GFP_KERNEL)?, GFP_KERNEL)?;
> +    ///
> +    /// assert_eq!(guard.contains_index(42), true);
> +    ///
> +    /// # Ok::<(), kernel::error::Error>(())
> +    /// ```
> +    pub fn contains_index(&self, index: usize) -> bool {

Nit. The method name may imply there's a contains_*() variant. I'd rename it to
contains() so we are consistent with the rest of the API.

Reviewed-by: Daniel Gomez <da.gomez@samsung.com>

