Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53072C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 20:19:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD67A6B009A; Wed, 30 Jul 2025 16:19:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADF56B009B; Wed, 30 Jul 2025 16:19:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEABA6B009C; Wed, 30 Jul 2025 16:19:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A76636B009A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:19:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 507B416052F
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:19:05 +0000 (UTC)
X-FDA: 83722045050.05.FFBAB7E
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC58C80009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:19:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IT4Ac7ow;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753906743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tLmYnHCDgXq28T/4pKfxXHqOeGe3wdfElDBfdfPE138=;
	b=XeE8ta1H7una4bKJ/JdWJKBfB1lKojseqyEp5cC5ahosfUme28NgtNo8Fl05CCoInWUblX
	XfJbAYOibn1eCNBHMNAXt6z4NXO9siQbudmp/BwmUWfbwjBdWLmQaSoqMiJskgEk6CT5kT
	DRG4oxzggLTXxUfIEb7pagjxY8NsD0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753906743; a=rsa-sha256;
	cv=none;
	b=NbbESmivOy+KgUArkSZ9ZNJcUtsSx1FLWFH4CYtr4rt+NHi+Q/LOQyqcI1Yb24AGXQXecA
	wqtBvo3CX01LgmnOsj9n5sBi8ZuUyED0aStvw1ZqDU1U2sfSoIBBkgbihToJLlNoWtcspt
	ILok/nSkSVmSUyD5vQexGKltb3XaIjU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IT4Ac7ow;
	spf=pass (imf30.hostedemail.com: domain of dakr@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8251F5C0A23;
	Wed, 30 Jul 2025 20:19:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF478C4CEE3;
	Wed, 30 Jul 2025 20:18:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753906742;
	bh=DcXjq2rfJ+zi5yPib7hAe6FOJllbPaxz58yhERY06OI=;
	h=Date:From:Subject:Cc:To:References:In-Reply-To:From;
	b=IT4Ac7ow31BC8gNnNxnNVAMGyuMvD4bYXd9tSwxtFbZobmWygXm90zc3LzmyBgCTD
	 +o7FmG0vdx8O8n+KpmvZ4pdP5TSP3tN1nLwf9PTmiDQpCegRaTWBSkXz3a7McbK139
	 D4vfpd4p+FFno6p1UsJOVyo/aFKtPeIX3Rf/54ONmFda5ov2qAfqICAIg99jFhImyU
	 XzhbbAXsU8M2zdaIIH+XAOiGsBNh+ayGf2sx0pWGL41GoBwlAoSEGBKBIKkLAYxIW6
	 1eIk08J7R4vft+bMFh6jzvdORdmCfTADmQYv2iRXx51mSDGcwFLPelBYhey/RhhfI/
	 1iPnYimu2U98Q==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 30 Jul 2025 22:18:57 +0200
Message-Id: <DBPO1RQMZDH2.2WFOZO0X4DODN@kernel.org>
From: "Danilo Krummrich" <dakr@kernel.org>
Subject: Re: [PATCH v14 4/4] rust: support large alignments in allocations
Cc: <linux-mm@kvack.org>, <akpm@linux-foundation.org>,
 <linux-kernel@vger.kernel.org>, "Uladzislau Rezki" <urezki@gmail.com>,
 "Alice Ryhl" <aliceryhl@google.com>, "Vlastimil Babka" <vbabka@suse.cz>,
 <rust-for-linux@vger.kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 "Kent Overstreet" <kent.overstreet@linux.dev>,
 <linux-bcachefs@vger.kernel.org>, <bpf@vger.kernel.org>, "Herbert Xu"
 <herbert@gondor.apana.org.au>, "Jann Horn" <jannh@google.com>, "Pedro
 Falcato" <pfalcato@suse.de>
To: "Vitaly Wool" <vitaly.wool@konsulko.se>
References: <20250730191921.352591-1-vitaly.wool@konsulko.se>
 <20250730192101.358943-1-vitaly.wool@konsulko.se>
In-Reply-To: <20250730192101.358943-1-vitaly.wool@konsulko.se>
X-Rspamd-Queue-Id: AC58C80009
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: nhytowqnyh3wu36hma33fzbg571e4ftc
X-HE-Tag: 1753906743-17181
X-HE-Meta: U2FsdGVkX1+g86fzYFs0zE+wv2Nd93VCMUetzGPXmeAkdkw9UhpM+ijM44v1erELIvXtfvNzkrXLJ/4VUriE8S7Ja8xuy7a74XPRSJdwa8alsGNwv+hkHH2M/SIfnP94sYEuojDeHE737QeAWH8xk7BHJ9A53Bv2FvIDHIJpg4HguN63xd5rwjTm0pY8X18xpLZhqh1I3n5LrotQ0E4YVA9MHBvqeCHqDGZnmedFAgnwgEQE3tbBHWW7S2E3L9SYCyyvmLvgubdkeh1mjU9TToRWfdlG7WmHfciAdZJk0P/ngYqyHc1bkgG0VQGhmW1ICznZqxByGT4b4j2T82AZGaHpuwg+pq2W9mMB7wzBrxjXfa3l8JMkmru2ftAMl8HwyCvxAxEhIGOwTAx+WPLTncD6RwBfXXfpMP4Mt1pdaOWb2iSmpW3dx8I8DrUDOUPgWYVSxcCvx2FFF26Q+UYqxZJSHMK9DXipJI8VyA6RVZvvH+DjqfgyAYHCYXVHpMCKGGY1YgU4oaOf/7wL1704oMaWzUbOGZSkFTDtDGwVAa5CNdAigAHwqDQbQ9tHi0nsrwhPh4mjFvC58tuXC81sGG6HU20Ic/hvi24pOBe5Fx1AF6zmDQt0RbaehYwlblrDrbab6jy/lmbTNca1il3sNgK0M4l4yrzN6LgOeof5d28aXcbzhy7CwfZ+9O6HyAGNY1wJXwd04YPzII0dNNrHL1+Ro+DhJEozrQia+A8fGB6t5YGNFP6nQf3JFY54VUoh5kZTGoKpki0w6D46AVUvvQJrErYyIMRZ5+mJDFNGVlIXxNp8HLUuDGvMKXnoJ/dXrboKp7xTmKSY++kmZFGol1x1FfHWO1bn5D9CfLaIWblpY08cIYSHfgdhI8tfpfuNvwyx1yizaZMfLZ78zh5cFBWG0wqUoRxQz9CWgZZS158JgmqNQ+9WyaMRSrybaFpFcLSEVSQTnghFAX0l9QX
 ShFlgE6P
 P98glhME1KxwmmSpcjp+n36lPSDUtb9kujDEdpIGtNaSBFcvitENqpVzKQWD4yXo4giOErqcnQPUxrq8HqV+Qv8Ranqo+eCVPz/uChi5S8prEeaQuhL/gVqFzbUu5On2K99VUXnNZTLt5rqnp+kYyC1MTQ/MdUCS/heJI8AU7/LboeJegjQvGGKFhF7NLslkLezHXlU3wLN9w+ZGXMUcGo7maqcELexjpNs3o7+bmYNYofylcATNU65Gu/3AG2xd742yh2Fj6rMrdFIf1ujumByoZRpCRlyfdpHHaKLRAa/DzqkXs5G48BU0+BOQw6KGR5wvB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 30, 2025 at 9:21 PM CEST, Vitaly Wool wrote:
> diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allo=
cator_test.rs
> index d19c06ef0498..17b27c6e9e37 100644
> --- a/rust/kernel/alloc/allocator_test.rs
> +++ b/rust/kernel/alloc/allocator_test.rs
> @@ -40,6 +40,7 @@ unsafe fn realloc(
>          layout: Layout,
>          old_layout: Layout,
>          flags: Flags,
> +        nid: NumaNode,
>      ) -> Result<NonNull<[u8]>, AllocError> {
>          let src =3D match ptr {
>              Some(src) =3D> {

I think this hunk should be on patch 3.

Also, don't you see a warning when running the rusttest target? I think it =
has
to be _nid, given that the argument is unused.

