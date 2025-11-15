Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36306CEB2C7
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 09:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92D4E8E000A; Sat, 15 Nov 2025 04:40:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9054E8E0005; Sat, 15 Nov 2025 04:40:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81B688E000A; Sat, 15 Nov 2025 04:40:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7030E8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 04:40:20 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0F5F212EC0B
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:40:20 +0000 (UTC)
X-FDA: 84112345800.10.77C7804
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 88D51100003
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 09:40:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnACPYRG;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763199618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHB08IvKUjp6VSgzon31v8zdn+VKIBB5Ms0B5usaIp0=;
	b=01B0P3YY4q9QaKVlO0bEQ4Kvrd6EEKLIDGUDi75xmlEwKYMIRgz9Kh5dxBGKmVcRk48+z+
	vQgyR9Nrw0XERtqG+pQaRS+7QhVHbz+yWeyEM4McGXcN+EbFejXKzccZLZMapnL5xLFd8N
	zkolrSkvQxlftXadeTu2p8ekN2h05KE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jnACPYRG;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763199618; a=rsa-sha256;
	cv=none;
	b=Sdp8YioS3fYFFtBAsNJlxI7dZtEFFYmcyLw16MvLgRGGtY42TVBuxjhuqoF+MTrB8tJ+Ui
	c+tx383olSsI1yVbe5IiB7Stl388SpPINeBzPJG7wDx6rSAjrZVlpmMhorH9s6ISYHI72A
	jAo5YA7sVm8qC+Cv6Op/pLU4X8iQ8tw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0605B60052;
	Sat, 15 Nov 2025 09:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59544C19423;
	Sat, 15 Nov 2025 09:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763199617;
	bh=Ftwq9aXcMX9LHqwm1OwdhNRh26BPiUZtjHSBKYdzc7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jnACPYRGa0Ckp5lRrrDfhH+1W1avXDf7QG3tmJb6TLgF0IHMUoQub3f+z+duHfIlw
	 b3gL1NefLvwN1CxaW6GeiptTvPo9pITddyzIcyre1y2CFr4GcAJmOefxYcb/zUT3tg
	 kVQGBlQPZveH0FwA0jWK4VvlubuTgK2pR247Qzd8X8RW0TQLJwWsqFY0G09jrAjqCA
	 xxhfGO91qX5kNCEkcPzb/pZiqnWDaZmCBSktt7qH7Uv67WM4xSL0FUal1b5JBMO98w
	 7S3RIA2pWrvzpC5HIR57S71tJf5pGjYLJ5MbgFnNzdru+jx7kYJxJu+mt8a7TlLnr+
	 3W6qQcwJ5i53w==
Date: Sat, 15 Nov 2025 11:40:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com,
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca,
	ebiggers@google.com, graf@amazon.com, kees@kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 10/13] kho: Update FDT dynamically for subtree
 addition/removal
Message-ID: <aRhKeXM5iAswD7oe@kernel.org>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
 <20251114190002.3311679-11-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251114190002.3311679-11-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 88D51100003
X-Stat-Signature: sfcm59tf7nw8pekchwrektr5k4nz1nf3
X-Rspam-User: 
X-HE-Tag: 1763199618-747409
X-HE-Meta: U2FsdGVkX1+K9ElE1cI1/YZQvd6GaQAX3ytKoAsN895qaYXEcanPjIq9BkH+iB5kog02iUKyFC9Yy+eg/qVd0Y1I0xWUv5h+f9tSqwo3ISMZrb7p9TLwM7ndqMnsumZmBc/0emHLTk9HvKpA2jiLNZANro1NlgCXJZyyfYiZqTAe1madWH6RgtB2jy6rAyfpyGifETrUhJ5b0WqnwEYBYsSEvEY3SdFWct6hHbaeZ0akPKeGScOR+GWm/iUkG3wof1b5X0IOsQpnwNreg7ma16/wWKNrpxAl09VZHisa32tE58xgRgdJV4bewuSrj1vxXl433HO4+Quuar6dgIGg6rZLmg/bmIYWVaAbT80W5XwR7nCHiSQA4eUPGfs8FaJV6obtMqQOYAyk9R6TQ2p+7bbj95Re5Jwpf7CRk1PTb1u1xW66YYOGVegVDHfLEHMNMUVxjmh7dU98wYQwHp3gl1zxZVdvVn+hFuGPN7KaZDmvfZzaSPxXx4uNj1HMmABI8CTR+C9Ss12xjoNWWW3kQ5uD+cFxGRibuhyKqXLOEzrYNE32fKO/T0nuXDpi7KA4yiinaj/0dAvz4rXal9tppSKawazhL297hxZY/HTEhg/NzxnILIx03yOwBBZbsp6OTEUr3R9UTLIORV/nwJ2jEenevooZNQjmnV3qToTPhz7frPi4k7qAnq0duSWCWn5+0F1kYR3CK+XFaEFD0riHwOcvVE18MrsJa/9fX2RVAzFhL9rrTdiJCP9UEzqJHXkBxjaxS+vITSYqhrbUXRfCwA0KD97LqQ0F8BTXp5vZSwOBURvOkP5iu5bYt2ADSt1ub1Kt3QqLiuRokQFw8AzGS2uGjy0oTEdenO7bKWwKGPArhc4tcYzUh+ilWU16N83oPEpjbaBJodz5jzZBDHePciLlJ4s2z1z6Ax7NHaQJ+pIUUMvWJlc747YENjjxNa9xgiIX/TB/KMKw/mUA1wK
 IhhiEi0w
 ibtSsiJnrHTcw0XL2n3NYEJy9v42BHQL+Gx8DYAiqYFHRDcm/kmtLocAd7jBI35W61biKFxyVXEkWZ0QDY+5PARgEdE7jnKixra2zheo7/3cwjbBxwe5B6VQL++1m6OxJEdAIVf/H+z8U32RaV8xWmYXvMMHhciWQHszediFKLYEZwyAS8rZfcg1IIhc31hpEzdCa0Ay4FyB3l+52nxi1T35HOI1rIkVqgX1wcWtfCcsNMXMN+hoLxhxVCzQlpOv8w00G2iLEo3y4Bb8H1uqYA2BrFN1w/VNeSMQn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 01:59:59PM -0500, Pasha Tatashin wrote:
> -	struct kho_sub_fdt *sub_fdt;
> +	phys_addr_t phys = virt_to_phys(fdt);
> +	void *root_fdt = kho_out.fdt;
> +	int err = -ENOMEM;
> +	int off, fdt_err;
>  
> -	sub_fdt = kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> -	if (!sub_fdt)
> -		return -ENOMEM;
> +	guard(mutex)(&kho_out.lock);
> +
> +	fdt_err = fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
> +	if (fdt_err < 0)
> +		return err;
>  
> -	INIT_LIST_HEAD(&sub_fdt->l);
> -	sub_fdt->name = name;
> -	sub_fdt->fdt = fdt;
> +	off = fdt_add_subnode(root_fdt, 0, name);

Why not
	fdt_err = fdt_add_subnode()

as I asked in v1 review?

> +	if (off < 0) {
> +		if (off == -FDT_ERR_EXISTS)
> +			err = -EEXIST;
> +		goto out_pack;
> +	}

-- 
Sincerely yours,
Mike.

