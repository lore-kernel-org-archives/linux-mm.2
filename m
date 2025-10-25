Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0120CCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 11:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA598E0146; Sat, 25 Oct 2025 07:48:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2518E0135; Sat, 25 Oct 2025 07:48:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F188E0146; Sat, 25 Oct 2025 07:48:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6A7DF8E0135
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 07:48:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3FBA140114
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:48:48 +0000 (UTC)
X-FDA: 84036464736.23.225E867
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf09.hostedemail.com (Postfix) with ESMTP id B8DCA14000C
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:48:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Pe7e09Yo;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf09.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761392927; a=rsa-sha256;
	cv=none;
	b=kNp6MQO/ZuuveAAITPmMjCzLiWPntCwtEfkb1jSJUh7lXIh10Bx55J2FyDBJ3zDM5tE82l
	dxig3NkW//f67Jz96fLpWNnJ/F5E1F6P5nkMnJEOqYNHsn4tqFjKCQhlnTea6DGqw8+9Wc
	5a6NbIF8aEkpdqiYPggANT3YjRqUKHs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=Pe7e09Yo;
	dmarc=pass (policy=none) header.from=alien8.de;
	spf=pass (imf09.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761392927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fXUt4RhE9O4TW7ib83ixqHYYEv1RZkDc63T93cQXQfg=;
	b=hw0mKjTMdyxnPB5MEjLnZxTTo8iU/b4Q51BiOWxUjg5yzZBT39HNK6x0HG0AyRVbnSuByq
	eyqUcRq4+wDHY5+zwpIQ++QKALabPV9rwCV9UTXZumuX0dpTU6SRCxz9sOMvCpLgoPlVZH
	jSCbau1mW3SECMropWZDpmDNEQpt2/E=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 608C040E01FA;
	Sat, 25 Oct 2025 11:48:43 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id GCanCPmvqytz; Sat, 25 Oct 2025 11:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1761392916; bh=fXUt4RhE9O4TW7ib83ixqHYYEv1RZkDc63T93cQXQfg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Pe7e09YozzO9P2wUfc0UwGYzIHiFg7UD0eesrJRAkWy6tQmVHB82ZeA2JevnW/oA9
	 eKEYWZsN/7/ukeId6nuvC1UDNYOdjOif94deQWNPXgQ9hX+6jCcKQla5kDm5c12Vra
	 5jOCzacmW6RYgKj2V9SqUS+Qwx6kTyBWRNFLkaSjnU75iezliaENyQ/gcGgZmEGYHO
	 cj9Zfj1lQWVMV93Fg74UlpWdm+xB2b3+eFyZMa0vSFOI+JoHN8KkqKDSV7kPytqj/3
	 RgZWMn1UQGie4bla5B5FtPCgueQ+kQOer3yFrameuF7DbRlFYQHIf5c5Nu86+GZE7h
	 ExAf/lQ9Y2o0AkMUpJ3K2LPbJauKJxa5n9znivnzsprmQUXhwi2DXqgR0nHRoL9qAJ
	 DWBKYGDAp8k0+TGv2CERgx5fW0yQ/UVH/SwTAmxW/JZPW5qWF2h+OfewG9LmvG6dwM
	 3WwNen8OfShTzXTdePZe55RyUs/Exv93shD+W+Q7cMUeImGh01Vb+Nnx87Bm8R6y87
	 ExvW66cuIJVg35Y3kzYNJYh+RzapU5YW+k2nD44ZPTOZc+Uh5OnU0Qg6OngflOFaSR
	 l6AUEjU8H7mogaKjNlW1BIJybYXRIQ931ZwboW3kdOXW1VZPNiou/reTtByhl2dU1A
	 kMf7DXJaWizUzuQ1H01n0UW8=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id CF52C40E01AB;
	Sat, 25 Oct 2025 11:48:08 +0000 (UTC)
Date: Sat, 25 Oct 2025 13:48:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org,
	dave.hansen@linux.intel.com, mingo@redhat.com, tglx@linutronix.de,
	akpm@linux-foundation.org, david@redhat.com, derkling@google.com,
	junaids@google.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com,
	rppt@kernel.org, vbabka@suse.cz, x86@kernel.org,
	yosry.ahmed@linux.dev
Subject: Re: [PATCH 03/21] x86/mm: factor out phys_pgd_init()
Message-ID: <20251025114801.GWaPy48dhlZ_EVoqKi@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-3-2d861768041f@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B8DCA14000C
X-Stat-Signature: upfaixuc8k47hant1no9dioeoz451344
X-HE-Tag: 1761392926-861823
X-HE-Meta: U2FsdGVkX18tUj/CUGXaNIzhcBaGL8WTeSmNDXT0uFvNDIlUZMNWZAcwjQRQsgtO7TuWP50/2GO0UU2ZZ2EYdkDFkEGlz0uXS0bPH8yJ4xy6uWXHXIfbNfTIXTc1Io/x7BItZtCWv1tbwb4+yTedpbHELyZRWFk/HABKn6d1XhVL72Q/IJy0jhrwFlELm6eWONWOnZtY4OtbxSYNsTaXbnKndwu5QdMZSRN3N8fPBUO3ePStLeuru8DNDR5kpYVbs5sWqeyc9R7p8PgwJJcJDkJn/yGuRHAdrZhFG20uU9XF3uw7fNbehZngJCJEGUP9JAN3ATf4IQG/2vzhQfU2ZjxViidYl2gLl5/kGLvhw4SFvILmW4tFxoQLYPeG85lT+X03FlRNYNrZ/VPM5ECWFMtwoP7Vq/8Vc2zELgNszHGOGo6D5LPBU0n+jn9ppXPMb+kRH6xYgFWqDJra8mfcv58j0GvtZN/vyOadDk5mkdrUf3v7ezQRN2oDv6vthTzsW2FB/eK1cIDGyQrjc6qD+A1NHq9Mnv+wjZd1PJoALKHHWBp4SYasjSpsCXPXpW6zqok0wSHHKOszlijnWDmLmdUBevb44PjJGKBq+77omQ7V1U+A2aYQxgTy7Klpn1JbZo1T9jJc7bQLAh/FZj3hjFlAnkHBcOtknmRAoZYwx5VUQCIaJ8mBEIHung2eSGjGnq9OgXGf00dFtolUFAqAKERxEJj+ZnjZ6NGjFvUd5zjLMvufD0DUy8xvrbGeW2l8PUYA+Oz3zbzZvFtNM5PCSI8wsICxZldGuquRhA5j6EEhTjHnDXSvJEm8nwgjzrreAjD0w+Wa9zS+4Ii/PEEqyfxfE+IBZc1taboG0W/L4crTWuNR0xIbQqBeD7XtX5CFpub3NsZ5JfApJBoMpe+Ta4Xp2WyN2zCD/3P91lwdS0AhLmGlCevEh3s9q3SQ9GHtl2DBJtI/Vv6jeWv+r3w
 9vL5/crD
 mxKdK6kQN1Ez4WZIeRZCq8rOm9DMz6tofL+SJ4hwM/Qsy2spZmSM55pfIdgdInK1zkB1fxX/3mQKBEoRp224kjNaDeQ4SD/W6q9eo6IX70Ac7FnrJNeNn9ZLaiyt97W32bo0Nf3g2Cpr4oTBe8sdYcqKJoufiblcBtFZOwyMFT3bB7wOaceY12nSFHCDxh7b5Q/7TmFku7FG8j16d2nl5YqU68+GHF8ZTeqnusdetlnhpSUf5JpM88IFUfH9K4swBFtVsQmed0GO9eamnKGPRowvy2VmcEsaPDh1UXOe2ShKL/Ovunl2MEuHvMQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 02:59:38PM +0000, Brendan Jackman wrote:
> +static unsigned long __meminit
> +__kernel_physical_mapping_init(unsigned long paddr_start,
> +			       unsigned long paddr_end,
> +			       unsigned long page_size_mask,
> +			       pgprot_t prot, bool init)
> +{
> +	bool pgd_changed;

I have to say, that pgd_changed is yuck but I don't have a better idea and
this has happened a long time ago anyway.

How about you have the caller pass in false:

	bool pgd_changed = false;

and then callee sets it to true when it does so?

> +	unsigned long paddr_last;

The tip-tree preferred ordering of variable declarations at the
beginning of a function is reverse fir tree order::

	struct long_struct_name *descriptive_name;
	unsigned long foo, bar;
	unsigned int tmp;
	int ret;

The above is faster to parse than the reverse ordering::

	int ret;
	unsigned int tmp;
	unsigned long foo, bar;
	struct long_struct_name *descriptive_name;

And even more so than random ordering::

	unsigned long foo, bar;
	int ret;
	struct long_struct_name *descriptive_name;
	unsigned int tmp;

> +
> +	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
> +				   prot, init, &pgd_changed);
> +	if (pgd_changed)
> +		sync_global_pgds((unsigned long)__va(paddr_start),
> +				 (unsigned long)__va(paddr_end) - 1);
> +
> +	return paddr_last;
> +}
>  
>  /*
>   * Create page table mapping for the physical memory for specific physical
> 
> -- 
> 2.50.1
> 

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

