Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B9B2CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:58:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6158E010D; Tue, 14 Oct 2025 08:58:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E8B8E000D; Tue, 14 Oct 2025 08:58:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2D458E010D; Tue, 14 Oct 2025 08:58:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 905428E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:58:31 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1821416090E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:58:31 +0000 (UTC)
X-FDA: 83996723622.19.3DB98B8
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	by imf30.hostedemail.com (Postfix) with ESMTP id 009CC80008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:58:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="f XEDl3t";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Nb22c+Sx;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760446709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u6LKml2pyPSTZcevZ804GiM8rOEYpqXLcQSqWC6v/9E=;
	b=KEVE1PxojE8mHlflNCfvhtChO5O7ChahqjI9Yam9pJ+zvs8LboIOeKaBq2Hsfm/Dm4nOUB
	E5o8aV0ovkBXhM1NX75oRlzUIlWUS00fwieK7zYqFYRAq+MTSx6cb3rmJxT3j3GJgpzD+k
	Uiq5YGUvDDnV+1cMvMj3ylg+DvUkTPk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="f XEDl3t";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=Nb22c+Sx;
	spf=pass (imf30.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.153 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760446709; a=rsa-sha256;
	cv=none;
	b=nO6kefHpiobeZUXJUGnyQCEAid4KqWr6j2tOgER8TUooKXjn1odQ7ApDE0N8pMYOHDC1wn
	mxapBDeeov5OAYSRB6ksEABdG4mQ2zVcQ28YPRmrLgr5iLBxs3qHjWM5oM4ozrBFtnjs0u
	PSLwQlZFs7kF/WAQT2izbM5aNJo2ZJ4=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 3D75F14000EE;
	Tue, 14 Oct 2025 08:58:28 -0400 (EDT)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Tue, 14 Oct 2025 08:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1760446708; x=
	1760533108; bh=u6LKml2pyPSTZcevZ804GiM8rOEYpqXLcQSqWC6v/9E=; b=f
	XEDl3t4bZjYkKGTfqhLQZhK8NQDLKPVQHpJ2wy6BbqnfG/SCz99JC5BwzLOhd5At
	w7kHsQQgFDgos7dxM88z0/WQvUzDp7BdePP6QVKuiKbOQIFNZmG8bJCLZJn98eRF
	W3356NbDYS7HKSKQIzqMmyqKrHnKfwPmdpmnCe24YU/a/bRfrBZnTHiO5lkMeGZD
	uXndhDOI0iABQTafifiS6/nl7a2PemA1ILx/hnvzion3rglkGxaQI0DJP/+HCeV4
	fhScVKh2ildfRXK8NgoAWnwiWqiMVwT6Sjc0cCtakR0DnuE1MF0AcoKcVz+xPg9b
	b1v26fNFPF1n3H7HAXVYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760446708; x=1760533108; bh=u6LKml2pyPSTZcevZ804GiM8rOEYpqXLcQS
	qWC6v/9E=; b=Nb22c+SxdaKSYH9ixEJgpwaugop+xr5ctxUOY7zGhPaZYiyBwQR
	/JQ39TggLma1Mfwq+E8vC/k/rIjfxtD7aPn+i1sgAODL2PZHcHk42Se8FejN4TtZ
	2iJkozyuNnb2789M/7N8Ej9PF6WOLuDG7ONatzvzbgSpHs8hvaM4Z3vMeMYN0Lrh
	ij8jVSADPz8EeIYJxq5HDH5ikqJ+t9vebo1AROnTHl7EC3h9QfLEsRdcE6LYt2kl
	qVSDUmlWiGrmk5RO3aO8+isCxII+fJfArTc03j5cnrnzbQvYyU2fDKaiHNIo/Vv8
	5DLHeA7SJ8Qr3TfJj6B/rV24Wf3S23NJeRQ==
X-ME-Sender: <xms:80juaMBemFHcTGYWEWBRdrhfCX4KkzrI-YYoNV4nJL1RFeok4cviFQ>
    <xme:80juaBnZdaw1Fs-JrXtfkEOhn2Ixv40eRUPhbg8MhL0MiZD7DHcYcNnYPdeAmD94R
    Sr9u_xfex0rWRKj_dQQoeCe_KZPNEiBkPYzc4QplRDM2jIMNjKO3LU>
X-ME-Received: <xmr:80juaKO9Y3zHinhRZ-bgVEG74xdNTlXRBBzlEHQ1yXev4YOfXM1aB9sfKIJVqg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvddtheelucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopedu
    tddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhorhhvrghlughssehlihhnuh
    igqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopeifihhllhihsehinhhfrhgr
    uggvrggurdhorhhgpdhrtghpthhtohepmhgtghhrohhfsehkvghrnhgvlhdrohhrghdprh
    gtphhtthhopehlihhnuhigqdhmmheskhhvrggtkhdrohhrghdprhgtphhtthhopehlihhn
    uhigqdhfshguvghvvghlsehvghgvrhdrkhgvrhhnvghlrdhorhhg
X-ME-Proxy: <xmx:80juaO-nHpgJkVNsquld8r3lxO1G96Efhi65ggThZHK4JvNjl765gA>
    <xmx:80juaMGjAva8TAsdeuDNsS6mpwHmATExQ098GQkJwerdOeh5_6TtTg>
    <xmx:80juaNgvnTSbk64WWN3N4I2QNTu99f__3agVO7FQKYTGvFRryZmXOQ>
    <xmx:80juaBsxhJQzcXenGXzp5na5rL0cG0F0jhA0BT_Cgr5TvKmg6H8wLQ>
    <xmx:9EjuaEkBtEB7lnMzcQjuAsmUsXX0qQCy8VBBEcWUPXjklRP9h6dmEtVt>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Oct 2025 08:58:27 -0400 (EDT)
Date: Tue, 14 Oct 2025 13:58:25 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Linux-MM <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org
Subject: Re: Optimizing small reads
Message-ID: <wfneq47jscotsqb2hhwpjfp2hqz4d7yyw643yagqnqvh74opvx@5fnmgowterq5>
References: <ik7rut5k6vqpaxatj5q2kowmwd6gchl3iik6xjdokkj5ppy2em@ymsji226hrwp>
 <CAHk-=wghPWAJkt+4ZfDzGB03hT1DNz5_oHnGL3K1D-KaAC3gpw@mail.gmail.com>
 <CAHk-=wi42ad9s1fUg7cC3XkVwjWFakPp53z9P0_xj87pr+AbqA@mail.gmail.com>
 <nhrb37zzltn5hi3h5phwprtmkj2z2wb4gchvp725bwcnsgvjyf@eohezc2gouwr>
 <CAHk-=wi1rrcijcD0i7V7JD6bLL-yKHUX-hcxtLx=BUd34phdug@mail.gmail.com>
 <qasdw5uxymstppbxvqrfs5nquf2rqczmzu5yhbvn6brqm5w6sw@ax6o4q2xkh3t>
 <CAHk-=wg0r_xsB0RQ+35WPHwPb9b9drJEfGL-hByBZRmPbSy0rQ@mail.gmail.com>
 <jzpbwmoygmjsltnqfdgnq4p75tg74bdamq3hne7t32mof4m5xo@lcw3afbr4daf>
 <dz7pcqi5ytmb35r6kojuetdipjp7xdjlnyzcu5qb6d4cdo6vq5@3b62gfzcxszo>
 <CAHk-=wgrZL7pLPW9GjUagoGOoOeDAVnyGJCn+6J5x-9+Dtbx-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgrZL7pLPW9GjUagoGOoOeDAVnyGJCn+6J5x-9+Dtbx-A@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 009CC80008
X-Stat-Signature: mptdu37kwabkxftc4tf3z5tuait4kqs9
X-Rspam-User: 
X-HE-Tag: 1760446708-145224
X-HE-Meta: U2FsdGVkX19jAqNasAoMX6HtkDXek8tM+b272fhKgdUw0Kh3QFgQqFqPtkLW+yMcGGjA4RPSqZEjdRmry8mfmHPiw5AVpnKLkuvfWr+8UMDsDhkhqTnljwZyW3P/9MPwXxbGPz3jnYDfSVbk+n4ATyXqWj1p1yrA25NAC3y6HiQsYDGr6yFw8NvIcs5Khe2ui62f8CIey3sHTpwXIwKe39QoEhw+IiGCDJlxz6BCZjAIRCPW5LyGa76i3y1C/yoWPUP6BN37G6iMlysgLlj0LWWnt6DjL78qM8boAfKJc4ofKbTNVMI1O2IH+JldAtqTgfwJndksc99jw/Z8jhav3kxf1c8AFknFpwIY22t2+s4a0W9ZcYd5JtMliAxsc2RCtZ/5Df45UJfCryP+jgG0ob4DaRQ/TjwBQTk8nq/FbtXFhG03iXtPQPzUjHxpOuMr5Pa7ULqKqsFe2By8yqJzVHKLLdWOo7O0O6v1f/CQa4XtEuHeGmf9APXuy2lhMT73X2saHIuFyaILMw3/UAFbeKXFFjgZZ5kr2FO1PzE0fnGzGmWctcxe0hcy949zI2Nq/+0mVcD4g39jo864kR6zlyV1X0nIRbBpLvuKcXdd8rIBy8aJWlHSiKwnPZs0F2tf9HDGHWR/EWhv3KO2KkbE2HO8zBKZY50oUMAi8Eh652IFDfpxyDn+Yv4iZeftS2Z5kVNKJj0+RHH/B3nxTaZV/nwJNMJWAidmmjBTAOz4Fdq/+0CYIT45/XbGDOX1mBB6KFwXHp5MpzJZW+IPalQX3Ewr67YfcbSxQ3HGMqutb3mka7wj2ksFnp620F/Mn6z4gYphzBDx3gm8gyv+RbaTc7RqLojl8kcHfwsOwOKV/BIRqWHg3h4DxSMary9hfl/TPbhxtNPBfMHF5+bfAjbtyXoMXTm5cM/7gHI/RvGvHxMZmycVbdPIj97Bk9Gs/INH7Zb9uP/k7Za6i5w4O3B
 MhYqmX/F
 NnclleZ4qh9CYQTUzIYW/6svSsT3HTgPGPmqMCJxybthdh5UJPyDJKS4UGr1R1YFbmoHCf5uCN6X1TuCLtjjfGLSGTOSaSlaxn8S2QkD/BOkm/lxsK2jIfTvprqwtPViXFetYvadKrTz0bxKnNYZFLh5Gl4C0S2KWlhJ86/xm+Bqrwqk63jYz3nuxZdMbcHkRcmLDTDh8uCjYv5hogZmkNmYHSrpD2tKamQSfAv7X/0aTGfGtDh3Pb+PhbvrBSlU2BdZbhJOipJL0GdgkcLloDqLxUz7AxL8IPi9OCCb1wRBhx5DI5J1G/4Y1YG2AopGW5C8CH2wTvnwT8NThg2Em3w5hhrjDq0c99yonQim9SdIJStIntWe2WxoYQOFaKj5olE6Sfbc8p68xb+hhOi8gj/V67w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 09:19:47AM -0700, Linus Torvalds wrote:
>  - both filemap_read_slow and filemap_read_fast would be 'noinline' so
> that they don't share a stack frame

clang-19 actually does pretty good job re-using stack space without
additional function call.

noinline:

../mm/filemap.c:2883:filemap_read	32	static
../mm/filemap.c:2714:filemap_read_fast	392	static
../mm/filemap.c:2763:filemap_read_slow	408	static

no modifiers:

../mm/filemap.c:2883:filemap_read	456	static

And if we increase buffer size to 1k Clang uninlines it:

../mm/filemap.c:2870:9:filemap_read	32	static
../mm/filemap.c:2714:13:filemap_read_fast	1168	static
../mm/filemap.c:2750:16:filemap_read_slow	384	static

gcc-14, on other hand, doesn't want to inline these functions, even with
'inline' specified. And '__always_inline' doesn't look good.

no modifiers / inline:

../mm/filemap.c:2883:9:filemap_read	32	static
../mm/filemap.c:2714:13:filemap_read_fast	400	static
../mm/filemap.c:2763:16:filemap_read_slow	384	static

__always_inline:

../mm/filemap.c:2883:9:filemap_read	696	static

There's room for improvement for GCC.

I am inclined leave it without modifiers. It gives reasonable result for
both compilers.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

