Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A17CD5BAC
	for <linux-mm@archiver.kernel.org>; Sat, 23 May 2026 12:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D16016B0099; Sat, 23 May 2026 08:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9FE56B009B; Sat, 23 May 2026 08:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B67D76B009D; Sat, 23 May 2026 08:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2FCF6B0099
	for <linux-mm@kvack.org>; Sat, 23 May 2026 08:11:16 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6977B93041
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:16 +0000 (UTC)
X-FDA: 84798569352.15.AA5F815
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C92D140007
	for <linux-mm@kvack.org>; Sat, 23 May 2026 12:11:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gq9FjGic;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779538274;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfVu5i9oGVrZKznwyVgNmlbhPXsqzMVnma+Gfjw5hT0=;
	b=J8SGYflcmZQKxQTCHVgDNgE1/D+frREQfVwUunSqVZxgqpZ0xXAvVjtNhQtxEpkO2n6tKE
	/AHKLuF201XySx3coWJAO50zGat1NnbcJifxc0FsLaSTDu6KZXJl/wPfIRy+4S2JCC5mR9
	n9n/Ol94o8CDfzCJZWc+W38fuKzLxqg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779538274; a=rsa-sha256;
	cv=none;
	b=VycCTTJ7JIyOFRhXyyu743uf3GAA7GPo82MDqNK3GxkJqZ5wjnOseS2LHJEGbP0nFh64Sn
	cJmhiae8wRXHXlNrUA3bgRlKLwNSKOrHqxVkGD32FNEhb8u/l/DoRwW3FLauMc1eGxc3iK
	e76m29darhd5iwuXmxgjFfEv+Au47x8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gq9FjGic;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5E92960200;
	Sat, 23 May 2026 12:11:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A652C1F00A3A;
	Sat, 23 May 2026 12:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779538274;
	bh=HfVu5i9oGVrZKznwyVgNmlbhPXsqzMVnma+Gfjw5hT0=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=Gq9FjGicG/zRK826fjDvqZ3DNNSrEVuvl/In1/2siNoMiy8lRY7iPDcvE0IG+d8M3
	 n9Woa1s10C/TRp75UdcsWyNKF2a2IAXmZEeoQj5V4oVPQvjCkz22LqGdfW7cl2w+70
	 PvCMY6o7V+V6XMRQV/FiribnrVEB2C1hJ2F62+SHvg8GaiInYMyN2dVl1XqzRQd6Jk
	 +Af7KS0c1Q4MOfEYcqRhRVhxt1RYIdxzqg8aEDMzEKvjKPGxwUcAfMSlQXg9SUDs99
	 5lZd+OUUTrwETdSU3glSYm3ja4R153L9IrgsaoX5mic+Q3ma8j+KyMNNlMBkAs1ZTJ
	 yrxZn4N689JUA==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 4/7] mm: extend the template fast path to
 zone-device compound tails
From: Mike Rapoport <rppt@kernel.org>
To: Li Zhe <lizhe.67@bytedance.com>
Cc: apopple@nvidia.com, akpm@linux-foundation.org, arnd@arndb.de, 
 bp@alien8.de, dave.hansen@linux.intel.com, david@kernel.org, 
 mingo@redhat.com, rppt@kernel.org, tglx@kernel.org, kees@kernel.org, 
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, x86@kernel.org, linux-hardening@vger.kernel.org
In-Reply-To: <20260521040124.10608-5-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
 <20260521040124.10608-5-lizhe.67@bytedance.com>
Date: Sat, 23 May 2026 15:10:52 +0300
Message-Id: <177953825220.3959652.6200899011132427221.b4-review@b4>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Stat-Signature: c335o4f1ub5bcs3apotpjhhxnrrcygt9
X-Rspamd-Queue-Id: C92D140007
X-Rspam-User: 
X-HE-Tag: 1779538274-125099
X-HE-Meta: U2FsdGVkX1+B+VyF1fd3LgvI35EvvjoFzAwH0UdjZkqwiyYgsC9voGFUvY6g4wadxtA53ov02YNr7AbDOQUgurS8R81UTtiLq7tCu030AUYwLAZaQqQpYIeqtUgJ5swZYdeuYw5Iog43ARhu8dKFWbErk1fNqh/iltaLmet7YhqDjjgNMk6UXhWpabpWkhah+i/VV/g2i1WhF03TVZvsl4o/SBNd0qbmn2aJw1IV52wJ5ydYydOQop26oJRHnno064QFHefuHUDM1gFlS2QFirV/sDq9Itao1Zn8HilOwwpxuoI3rvl0Ii8NDtWhlgXmYK004R3QI/lLz+1ZpoMcgb1TM1OK1HUhgY+RoJtc4GSfeEU0KUQDKRjA/EoGv/uRuItL73dFhUtThDd2cHhIjTOF50Z9uDrOUINyuaoB+DQslBJkWiUkkmkxNBOV/nVNWteua0NIBV9GTeHwNCVWUx9n54wqmTK4mdSJ2v16bhnRF4DbyPSOTJptSyQpNXj91SWMCJXoFQy3CQM0TlQDu8NG5kK5mkjV3g988vsqG+N7N43UG+JlRAuHZ55CH2nHsNXgrCUlT7478lbwxT3P7/refTdHK9v0g9xmXOMeGXgPy4YZ02g6z9WI7c1W4IFAwcq2EXb8iP0ja9c4bn4kziU3oK8lCQIxPW/ytlblnMQ4MoijRMK5FIQ2JPgRJeEDyfPk2B8oplqTaJxwG87FpDemPVHhyV2M2EVW4f/ys2MhDeeQ5StZF5CeT9fsmClC0YxiZBp6fULoVKWA4JrRTY7FsB+d2NinfINGBnT35G3BJFiWQ9IyryvKvIs0TpmNF4oMzZ9OkYCal6Plgpcv469Lx0fs8BtBwhluiEvdfBlA70Ty7ClJ4gB4LK3G9MwO/jamJCoSpRxUWdj3JbwHPfjmFw4pul3LDZekyGa18JDtaYrpAPSVa9jsQlK6ND7nYt6uBD4B0i3MENKbt7L
 iOytff1h
 4JbfZA897Mz6sQmlJU8Lw8HDf84+Ro5wvsjQ16+qdMZZ8WLkPPF49pLaKdnqLRUfdQgc4o/9ng2/ZHuXKtlkCbvfTKC58mBi1AlUoklaCU3qtp+rqfIoTsszo2Y1BE7Qpx94qNJUq0fI7xzRnAoaLHlDtYyJxkd+Od/wndST8hHhi0ILNdHxmseqoc872NVseu4k/CK310UUx0zdUJGWMYoPZdJHro7yfevtx3S+CNdH4iTjLKFpcPFivRbWxSbfERMH+MKRIW1k08D8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:01:21 +0800, Li Zhe <lizhe.67@bytedance.com> wrote:
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 2992711351a0..17a84d4cda01 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1084,17 +1084,25 @@ static inline bool zone_device_page_init_optimization_enabled(void)
>  		IS_ALIGNED(sizeof(struct page), sizeof(u64));
>  }
>  
> -static inline void zone_device_template_page_init(struct page *template,
> -						  unsigned long pfn,
> -						  unsigned long zone_idx,
> -						  int nid,
> -						  struct dev_pagemap *pgmap)
> +static inline void zone_device_template_head_page_init(struct page *template,
> +		unsigned long pfn, unsigned long zone_idx, int nid,
> +		struct dev_pagemap *pgmap)

Yeah, two tabs from the start would be better :)

> @@ -1156,12 +1166,28 @@ static void __ref memmap_init_compound(struct page *head,
> [ ... skip 17 lines ... ]
> -		zone_device_page_init_slow(page, pfn, zone_idx, nid, pgmap);
> -		prep_compound_tail(page, head, order);
> -		set_page_count(page, 0);
> +		if (use_template) {
> +			zone_device_page_init_from_template(page, pfn,
> +							    &template);

continue here and there won't be need to indent the slow path.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


