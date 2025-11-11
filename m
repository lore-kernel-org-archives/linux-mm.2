Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83BA9CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 14:55:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664338E0005; Tue, 11 Nov 2025 09:55:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 614F28E0002; Tue, 11 Nov 2025 09:55:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503738E0005; Tue, 11 Nov 2025 09:55:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3878A8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 09:55:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DFC371605F5
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:55:45 +0000 (UTC)
X-FDA: 84098625450.01.6F71979
Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4B7791C0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 14:55:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=YqnJDfgW;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762872944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvaesmOa4FL0oqNE6Jjuc2W41XHSmQDSTtdVBn3gwyk=;
	b=v/+8zhH502HzFLwzecRpy/bDE6EA+Fpso2VP+8552EboxONATiFJ/N7l/zN488YcMEuyHN
	b1wqfun051igizTlKyizScklf49J3cz+WjPls1tu0RmJX8+ySqJxk91BL5ulBMlKY5DvgU
	7y5SlVpHcg+58k4QV5BthUzDRTSIF6Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=alien8.de header.s=alien8 header.b=YqnJDfgW;
	spf=pass (imf21.hostedemail.com: domain of bp@alien8.de designates 65.109.113.108 as permitted sender) smtp.mailfrom=bp@alien8.de;
	dmarc=pass (policy=none) header.from=alien8.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762872944; a=rsa-sha256;
	cv=none;
	b=ZMFS2NPVcpSZeCWxBFBXrKJNKroMkEsPu2APzuQgb5cCHqx0BQ4oIaNcBQNYDSl5b7gyJM
	S9aQcs5woMNoRUP6A+pw9uTFgZcNPikamUffiDddwsEEqZggW6DbSWKmSqBpsAFL5HlAMl
	BG4ivqlz2r11S8KAxHlL3CO5ey8+xk8=
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 499A440E01CD;
	Tue, 11 Nov 2025 14:55:39 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id tMmmeYl0meH3; Tue, 11 Nov 2025 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1762872935; bh=gvaesmOa4FL0oqNE6Jjuc2W41XHSmQDSTtdVBn3gwyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YqnJDfgWmmm4+pdX93nY6U8tsFaahs3v4rYfl4buKyG10uFC3lKtz423FJ262vWsX
	 FqM4lih1cyrfG4QCdQZUBQh3QhJh7fgkRzZuk7v6DZ2Wptp55l723CQVIuSoIUO4qn
	 3xaTgphDcDnjuZYMEOWWbBRDFaNG2qql1svczVUoT1NpQz9jYNAeLboaFjYarhJ+2q
	 QWh9J8Oty2/1JubETP0icZR23/940OCcxcq8VW8pQnPwd5XuCOT3Hx61QXGKqOtl34
	 u1p/Mkx4iT4lOvFv+6LtSTriU2g3gAkZvLNqyFb0JSlai5411gS6dZPt2IIdupgf+q
	 HWTvATKDrqumxcqngSOHbDwtY92/14YPjv0MO8s/NGkb2Lf7Fl0Kc+AegtNQSS+ile
	 nWZdb6suadmWtiP6FmWMG0UNdHjDmKqNq9ho1rnLykzc8C8mqafD2jFsi7xE6Xie2C
	 nruE/H1DW32bUV8+rPfgsw4K3N0IacmMjgSTJxKlNM1qKb6rwRHQxJojfyG4JsunHY
	 658U+xq6/+ej2G96X84LTfqX6Mz2ISi8i04sPCKPLHK/mHfW1WMoTPaKPYvnaXH5BW
	 Ux1PPw3wModikDTW7nJ6WjJJ40GIrpxxcArxB7unlhItBWX4zIhzzDqFnU5a3rjajn
	 kLOHxA6twlsm47fwL2detOKQ=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id D251B40E00DA;
	Tue, 11 Nov 2025 14:55:07 +0000 (UTC)
Date: Tue, 11 Nov 2025 15:55:01 +0100
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
Subject: Re: [PATCH 04/21] x86/mm/asi: set up asi_nonsensitive_pgd
Message-ID: <20251111145501.GXaRNORRWGIYQ7yFmH@fat_crate.local>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20250924-b4-asi-page-alloc-v1-4-2d861768041f@google.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4B7791C0007
X-Stat-Signature: f9rwdfee17dn1ypbu3scrd9zre6yqh5f
X-Rspam-User: 
X-HE-Tag: 1762872943-205581
X-HE-Meta: U2FsdGVkX1+kI6VC3Ylmt6hOmRq+tThmknJaR5CJH1eR6DXSO0LS+3ejMe3Z5aAcF+LSFeraAV0uBvmJfpLDDP75tJRt959izNyAtxDAWI0ONGcUUYN59rBOw1iEeCABuiS5i8kh5yim4IGS/kruTRbepRd11Zhokccl1jVJzMjTr7O79f6B+dHLj8dm4bxoSI8jNQ4q2dGOxP5M/S9BUnBTr0nmownsmNNuj4iqzM89bCzunLmIlWbvBzY3y6kPiXRwGnEFL+666C7lIX7mvr00/EqbKEZ7M2d4OO7YcCtsU8iniucJqIJ7F8o+IdFPzmFXZROUJ5IecHexOakRJO9vcQHCGF7xr6mrgXrWT2teudbkabVQJe+9oFFQxDZMivORmi3X9B+1e7G0ZH9yuzL8yVv0xsvBMyN6I4hgXXtiYcm+4EgMMOEvp3ZnW1DYcK7y94J/fE1jkG+8KTiOEvgRBiwhdHLMlWevjSbYSZLGQsIO9tQpiS40RTw+S2rfSLOHBtJ/kMjHw/2JFi0hupB8kG8YX/q4c5HwlsQrj1cWm3XPnYixdB+CcTUVaXiLJDEjwUUMDvF8J7IaA3zgySVSdzT6KLEDmxZr5CRdYgNQf8BIe7sf7KeUWU/auSVbtCzTN5fFI9hV1HZsCFFREDA9Akmoim09a3rT/zP9p63Q70F0UumIaVY5pUE3k4dQpadlRwuxf0CxI9qn5aBE6NJsg6YwiWHLToh+uY/PwbLYLr8T0zMrSVURW5YwISw6x4CI4OpbAIPc/Z38+GuhgbQHAVh6pOCxAqvjezCjr+5Jj50ai9od6GrTmiJA/YBrJv3BAZndZnaGeV4GSMmEKbDo137MIWiLsMJACXHHgVf3mtbuGUx81Iej8yj0QSQ61RnVACBbB5C61WJxtvNnUrIYXj3wazAdkxbga8HjnE14xNDmPwIDvXj2f/Iw6cjYRCQIzAUD5LTzYYOw/Tx
 URy1l4HB
 FmwnKQmrYjuExTVFzJxPnqRjuPSfxgVXZf9riXRF83kldsZPOK1sRyZ8xifyovlGNoj8YXPcYeJbJRDSWhGX9B/qBr8EebTnjxYNlJzFF9FBP7sJN3op8mAbXgCWo9RUkr51qJtDMkNIzhVAAQco/27/pRLkEyH4oc88XGCTnBKIy6rtQ5Fh1hzsnkTk5jdVd7JPMm8V2MRHJw5WKCtlxPVcAK3g7qPmFgYXn3e4cLxk3bx/051xgzmKK7DKxdT1BT1mtVCuuKbySpJYsQt5UXb9fLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 02:59:39PM +0000, Brendan Jackman wrote:
> @@ -797,6 +800,24 @@ __kernel_physical_mapping_init(unsigned long paddr_start,
>  
>  	paddr_last = phys_pgd_init(init_mm.pgd, paddr_start, paddr_end, page_size_mask,
>  				   prot, init, &pgd_changed);
> +
> +	/*
> +	 * Set up ASI's unrestricted physmap. This needs to mapped at minimum 2M
> +	 * size so that regions can be mapped and unmapped at pageblock
> +	 * granularity without requiring allocations.
> +	 */
> +	if (asi_nonsensitive_pgd) {
> +		/*
> +		 * Since most memory is expected to end up sensitive, start with
> +		 * everything unmapped in this pagetable.
> +		 */
> +		pgprot_t prot_np = __pgprot(pgprot_val(prot) & ~_PAGE_PRESENT);
> +
> +		VM_BUG_ON((PAGE_SHIFT + pageblock_order) < page_level_shift(PG_LEVEL_2M));
> +		phys_pgd_init(asi_nonsensitive_pgd, paddr_start, paddr_end, 1 << PG_LEVEL_2M,
> +			      prot_np, init, NULL);
> +	}

This looks weird: so you have some other function - asi_init() - which *must*
run before this one so that the pgd is allocated. But then you check it here
and in order to do such a "distributed" init, you export it too.

Instead, I'd simply add a function call here - asi_init_physmap() or whatever
- which is defined in asi.c and gets *only* called from here. And that
function returns the pgd or NULL. And then you use phys_pgd_init() on it.

Also, looking at kernel_map_pages_in_pgd() - and you mentioned set_memory.c
already - and if I squint my eyes hard enough, it does look like a bunch of
redundancy between there and init_64.c. But that's nasty code so unifying that
would be a hard task.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette

