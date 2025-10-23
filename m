Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11E37CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 10:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4135C8E000E; Thu, 23 Oct 2025 06:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C4038E0002; Thu, 23 Oct 2025 06:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300F38E000E; Thu, 23 Oct 2025 06:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFDC8E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:31:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A08F0C0AE8
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:31:39 +0000 (UTC)
X-FDA: 84029012718.21.28208E9
Received: from fhigh-b2-smtp.messagingengine.com (fhigh-b2-smtp.messagingengine.com [202.12.124.153])
	by imf16.hostedemail.com (Postfix) with ESMTP id B126F18000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 10:31:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h y0pkaY";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=YjL9jDYI;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761215497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kU4wHUg441bPx7RT7b8et5JEMZCrtmo8GUTzuMPpBo4=;
	b=NMtxvS+orNZjuPxD0hjoUawZ8r5dxNmJ4mcVg3DJ5uSCdT02nY/bEEoYNW7yiqSJ5ZRvTP
	mlgk3fynmuBldgD/kCXow+vbi8TnhRfywTYxD+rgnmOIoqjLMi70nwyxTGy7rwcE1zAbG5
	pvpZGNBG1J3XoJcgZyib4vMn8RbEIy4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="h y0pkaY";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=YjL9jDYI;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761215497; a=rsa-sha256;
	cv=none;
	b=PZM6KEbQ/8I9N8Qrafa4vUDzs8Q5SVZyXMzDr4AO0/sGK7B5IXfa98h11P9H3Mi9apYEn4
	9a7JpAlXhFJdIaobQ8ZaCiqlUGLu0tv+FbrsXQ8K6DGOpoPLWpg5tlKqopnYlec/mKinJ0
	rpEdCxVWvkKAMkN8u/TVEVNpGqhMVaI=
Received: from phl-compute-08.internal (phl-compute-08.internal [10.202.2.48])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 884357A0178;
	Thu, 23 Oct 2025 06:31:36 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-08.internal (MEProxy); Thu, 23 Oct 2025 06:31:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1761215496; x=
	1761301896; bh=kU4wHUg441bPx7RT7b8et5JEMZCrtmo8GUTzuMPpBo4=; b=h
	y0pkaY9LCmODejm50cF3ckusmXBnosXXyTuEOWjZyzFxQCl++b5Ni6JS9HdvdLua
	QIyz47qJkQ9nGmHpswgvd2yQEnLgtHiZkPP1QkknC7XcFtdrjdU8YsyTAiujU9Pa
	XdxzMiZX8dBv1pff1i300YtGUG2I9gNQ5AEua3vqLC8PTLUMyb0nAveAIyX8f6Jq
	PlgiUta531F1nfW/PQLinAMtMQJl8H2yhvZjI+D3iKpHIcT7esWoQcFX0dE6TJLW
	ngENJpo836glZB2M+q3oJ5q2XwpQRcnmdP0jbwfYI2ps66ditNniNJ/xMcc24zU0
	tc/DnW1UhLSY4iUpCyoJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1761215496; x=1761301896; bh=kU4wHUg441bPx7RT7b8et5JEMZCrtmo8GUT
	zuMPpBo4=; b=YjL9jDYIvucpP1jQifzOwIaVbO8pcRg8oC/0YrnlVuWoZhbPnLl
	AZ0WVB0I4XLYeiDdZ6QX+j6yrN+3lH1gynyOe4veJJw7BxutOA7G48aoZEVKHavw
	9rUqaUjuFHlC3jHdRtQQ9uRJax45NhVbf2uJwrSyXvvBySLzxjTpMLfrNPSIYOaV
	8GO9E9n+9Pd1d7/ZZii3QoraKDTq/A0CjRMXFI5O1WXUHg0s/jj6NZDajxMFhT5Y
	L4SX00Or6Kl8eaAHnJSxXGYIRs3ZsGLyOE35jrq1wJXkP/21cA2lW/B1fglR718B
	7GjvN1FoNugmBtNa8n0m94QiI6CPba0ezzQ==
X-ME-Sender: <xms:BwT6aLr6ZjKli_l3OG0rYx0kcXY5Q1tbqTbTf8ljrbLBNo7g0rMN-w>
    <xme:BwT6aG-OZQhCPhEFvB3L0k5oqlmZxVKPysSP0TV6llYTDQA5arQFRHMMJ6E0Ciyjt
    AIdqRZD8TzfN8lcOhCZb5hh6w21YoNk0SPthuyoedJCBEKuaDvZcjs>
X-ME-Received: <xmr:BwT6aM1juPwWSEV2S1e-QCC40U92flMlTTL6iidALSlZoQdhR7nnREnN1ixWuQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddugeeivdefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedv
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepuggrvhhiugesrhgvughhrghtrd
    gtohhmpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhr
    ghdprhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtoh
    epthhorhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphht
    thhopehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsg
    hrrghunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdr
    tgiipdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoh
    eplhhinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:BwT6aBlU5LVBjWGWy44QP_07ndzR-KZiCFt8CQObXxH5rC0YCGC-Lg>
    <xmx:BwT6aB3i9xBDIBjK9AqEBqkIRcQQNTxiVtm9EuIU6KABWbSLQQIo7w>
    <xmx:BwT6aIgb2qLFera_KuKiOxBA-rjlXqevd3q5vwnZeEy2e4Oipj1vrQ>
    <xmx:BwT6aHUsuHGTenP2WCDU33LJydvMcHD6uuFsqWHUqVPMXqVsKEgvmA>
    <xmx:CAT6aIuPqRNc6SAmLW6J7xAKggsIg2Iu4awBfINmTMO51JBGFNIiNPgG>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Oct 2025 06:31:34 -0400 (EDT)
Date: Thu, 23 Oct 2025 11:31:32 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: David Hildenbrand <david@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
Message-ID: <hb54gc3iezwzpe2j6ssgqtwcnba4pnnffzlh3eb46preujhnoa@272dqbjakaiy>
References: <20251017141536.577466-1-kirill@shutemov.name>
 <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcdfb58c-5ba7-4015-9446-09d98449f022@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: B126F18000A
X-Rspamd-Server: rspam03
X-Stat-Signature: pwmo953hipr93kg9fecto9znd51odceb
X-HE-Tag: 1761215497-193207
X-HE-Meta: U2FsdGVkX190iQBa7ne2RKbr1ZD5BMsNTVTrHHU1Ya9khWcgcZskKuiDD+zEYKs08PCov1CKwLEyrJ8G9u9L3lD4VvjepqGSxCgt304eqdJWIR4HMqD1SD/f7jgFGefRe/+NIPQXVMWueHk+0X++gHPb3Nu+My8IDikH5KrgfDRtBggdWu0hyilp7MgtDRUXpY4WmVh2z8Oq/7IP+urxntQUyKjnlnlh18/E+u3ynA/SrfsXT18vnHgXX1Hb4I1SpWRsWI/D5A+MzC+3lxlwwQ5+6K6PFPGbq/AJ0DcitfLPkcjYhiCP26SsHAHNDxWj0qg7oZo+Zp0m+AikhIiai4+UhJ04EN7i0g7Unue5q+RW+P39v5STo9w13IykzeZ+ErTTH4EOSWJjjYj09zXNW0beogpw9amGlguf4HMXL+roxJBNkqaoDovD9rUkSDyJwUzIkWzeHlydXc9Iw5axxepsniI9cQ1RA8xkIu+0LNiapCTm3DuvwhFHAz/fZI9KA/GIvw4ohImD8yRWPH/xEMdCNsSiCdkeRez8SudpXFS7S9L9GERW+wxjxnrKHkO03QYF8U7MhAkTA94r5Y/pOYTxxsx3koxmNDHFRGeU+LvjSab2lUeSx/IYyebqluxpIiRJFd6VqlC15TW2Mp6is6B1rU9GGShj/udRmB95jMrxeusWDIG3KbInVs7Xw8L24up8+3ZCr4vl2Tqv+0eHxeAj+nbom3931yueafFrONWS4YBsLFwa2cPG5EIYGy2KJ5/ECJ2Y9FN1q+mbEHTEsfC1GlJAMys6cIUSL19xwnIlkhq5Y8nwp3uCF7szxCNJjulVbuw3mZm1dCd/awCbaQ9tbHa3IWVhiSzVWKYIaTUb+pj5UTxfm8LL7EDVUXAP1gzJEyU18Pd37RgbU1kiSVQC0GkABzoEfTlcT2JSdv7rgR3zKrAyl35jTBrP/4TbauggwY5R4OjgfYgtEXY
 WxXMpK1L
 7POtHRIVqOL6RI/9h/WXftUrK5v1T8RJEaqZlK/6QhfrUjQ4MkB260h1rP3xETlzJg0jRLe+FzrZs9ja+L4d/ZRdvXsBDYKLr73Kxv0IlmoOUx8e7lD7dkwRvnxCcWhRe5N+3CiPfYXGqsQhTUvf+5v4Y5mFLqMUFj6xWd0OdhZOuwrERI8yTGeaxn+rbD2n9wQt3cY6KoLr3HjjGH3IwfgTfMMR37cSXBLEbnegzXbXGDVLHyAI5gQONavHTRMq+vz7pqLoLXqcd9nHitJaPW/ixDJE0+GFWaR/ZEaXipgALtAPhRKIUIfMbQgUHX9IlE0qcPu+EiyLJ9r0jNcGcYOf+hxkHnEWMfI7xa6kFI8K3RB6d5ksPpKCCegO5viRyQfwPD62F9LEJuZBIpTQVjJtUnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 07:28:27PM +0200, David Hildenbrand wrote:
> "garbage" as in pointing at something without a direct map, something that's
> protected differently (MTE? weird CoCo protection?) or even worse MMIO with
> undesired read-effects.

Pedro already points to the problem with missing direct mapping.
_nofault() copy should help with this.

Can direct mapping ever be converted to MMIO? It can be converted to DMA
buffer (which is fine), but MMIO? I have not seen it even in virtualized
environments.

I cannot say for all CoCo protections, but TDX guest shared<->private
should be fine.

I am not sure about MTE. Is there a way to bypass MTE check for a load?
And how does it deal with stray reads from load_unaligned_zeropad()?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

