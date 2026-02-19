Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DBA2E9A048
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 09:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C5F6B0088; Thu, 19 Feb 2026 04:42:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 319DF6B0089; Thu, 19 Feb 2026 04:42:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2263B6B008A; Thu, 19 Feb 2026 04:42:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6946B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:42:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75C9113AFA2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:42:35 +0000 (UTC)
X-FDA: 84460716270.24.9B59837
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 945B8160005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:42:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4TvFP9N;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771494153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8QsMn638cdRmwk3AgZMXyCq27Z00SOyz9lVnojbN1X4=;
	b=Q189IWLVq6I3vyhzVKyVr8hbFliPllqkVWuE5Qe4GerxaZB00cE17VDipora3312HmidbM
	cmbskQd0PzkuuFhu/9d37bTjr6d0mLdpuTmmVSfzZiXoLTJ+dHp2SU+gnGUDb6vm2z7Hkq
	kuE6yNZQhrXZjnObUNaiUlfR2vBahEI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L4TvFP9N;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771494153; a=rsa-sha256;
	cv=none;
	b=BQrSanabWFidaMqqAy8u93VQdQ/V1GEYX4Rfooh5wUt9Rn2gZokp1K44vEYvKE9v3rYDGu
	JAnE2qkRP9QcD7AdeWiU7RQXObkbnhosvRB4S1KXiIAudEdiiQCZTFfPv+evy4i/2d700k
	QtnDr53a4UYitE7SgYnqu3NhoLfnS7U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 650D543796;
	Thu, 19 Feb 2026 09:42:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F05C4CEF7;
	Thu, 19 Feb 2026 09:42:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771494152;
	bh=cu/PlxXbGok7ckcartXddupH1N/6QXZNtaFeQrDMmFQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=L4TvFP9NqDPDX9tszEtIQBCAA/SIckD/DwbyRzr51GIqV9LbvuDIfQvfFi+4m6EQ0
	 7pwExaAF7GyMhYqzMSH7/LnhnvDNH5V3RDhxCFOcluu6hUpyVlTkaUS4lqauL00CLj
	 WpSG4wCafcWRg2hNJhE+5Fe6dRQKIArNKg5dc+PmzokVTPwzgoKqo1lA8QbNvp1pI2
	 Z41Weo4j0PBOChWBrFB1dGX4bko0HnwH/MGOdMZo91bfq5L1Blcw9eB4jOk8vAEK+M
	 7COokWyZ4gYCyRBWoVbZX9dGwe+GmbyGeR3mMBB0vcXh+5R3R879W8iCah5LCtFm6n
	 YIuEhZEbS2T4w==
Message-ID: <94f03cb9-c7eb-4a7e-8952-ec56697a2816@kernel.org>
Date: Thu, 19 Feb 2026 10:42:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm: gup: cleanup the gup_fast_*() call chain
To: Aristeu Rozanski <aris@ruivo.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>
References: <20260219050250.061598056@ruivo.org>
 <20260219050250.266876166@ruivo.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260219050250.266876166@ruivo.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8widqznig9pamhqycmbnknot9wd5c3eg
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 945B8160005
X-HE-Tag: 1771494153-969040
X-HE-Meta: U2FsdGVkX19DiDXmr3sdjKkepz5oLMF7UFkwU3PrJVJzBh9+RQyz9apW/ydUCwttxztrC97shydqw0YABDOWanfdfSo4ZG2bsSmY8YXzhgsE6HUtRJ0B5axCxCgd907Ts3sphFlaSKSJC4k+iKRQvGfNwMApyFiV89HUqG/Dp+5dE1on1/A5fK+Be/4othYNA5R6RLZl9wiyvdRugEdS4NmSUSh7ySaCGtMmLcUAgWuQFFpHpqDZ4n8z3osqCi7XBSGD6oLm0LWiDn+440lAiRgcM2R8SDH77W23YScUTdRZ5mTSEXSEzx9oUuvD9uMehct49dOs/hv8PaLlKzgRWM5jxumkwjOEZDHg+g27DSobcQWuv1Mbv9UGWB+ZQm229LSCp13vTATw0IvpXQf+4a9vq3Cl67RSU9nXyRBRF3SmhzpUQ9nyUcc/lP47+SxPlqJgiH/cV7rpSlgntoNTXtkEyXyApdHrqVeJlVPVmW0CE4LkqM1QHCnHm5NZEKP8BTpf3OK00f7G++p64p3x9l5FKUwoc5gLzdjvK2VZntWkp/T6FZuIBkrYlxirOEtU89SmG6Dj2Yto13lZZKM+beLBYODlQwxF1XJmumndsTAk6m7Js+YHxkU2pA+lzjccA9haZOO2OTNwXZcLuzdCMPGTyEgYs3MgY8BVKQECq5TR9DQd/d37eX+UtbfEWSgz3PwzLOXH7gPpq0veXKDv2DY9wG+j5eG2RkT1BD7SOs/jfNVjlVwSl2JnA2aZXcHlO1UyjNOT7WEVJD/MeAdNq6RM7SdkX4MoaWiZ5ccKNx6XAm4Brot5viYEDjI/+dwrCwPQR3cz3NkC7X/JHlb2iUk0utcAuANnNWsBgusnPRjoZPCLPiqNRT8o5kudZQtWqWASk8L3V5okuCgeppv9Ydpyrc+9UnzLsvSHbFpzUv1IDMVdXq9DrycdV3OkNI1sb3Utx+HoQNoZNC6axME
 +rmFAZR1
 NMFXw/ITzgkA2uiHrWdvsf2Zw1c9wE3GNREuS/0n/Ff/zKJh9FfgFDaQnlviTQXvNuf+4qdruwV/IE2qAt3MGRxHCE7cux+YUcjU4q014/gY0oibg8NTTvVuK52rdfGcFTKKWNCGwXus3TpRrCqxeZYdOQ2ZBl9SHdUHwtRnGkUh9frsQE523ulkRk6gV6o11sLzIuNz/+9fHlB1JptYZr99dwTKgCc3P0kvv+yJFw66IE5x22tHHT99ySiIIZzGqfS2l3tK3ABP7wm7CEdDyirB+yIU7athPVpWtKQWjLrEz4G8B4w7eJkStAk0JNvzvYvSdoZaywMFJYxXsKyLQCq5iGkEodyWvsYojZQ65+Y2zhjUeUTN5NzWS4jDu41udvetVQBRUt/DXvD/Pk9KTaNvU6erT3qMlQxdruzdFB96R3dnbR6Zyc4kdx4t/IQ3M9rdJI3d7mag/iVoZXFdedgCDtbtgbJNKr5y78XtFhqbOjsPie8qk+LTrj7wtys0dztH3tGd5nlJqdg7wxofB+btb/sPK9Eqp/P0qTBL7iozx/dE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/19/26 06:02, Aristeu Rozanski wrote:
> Refactor gup_fast functions so each step of the way returns the number of
> pages pinned. Because the previous step of the chain knows what the number
> it should be, less indicates an error. This way there's no need to pass *nr
> along.
> 
> Suggested-by: David Hildenbrand <david@kernel.org>
> Link: https://lore.kernel.org/all/85e760cf-b994-40db-8d13-221feee55c60@redhat.com/T/#u
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@kernel.org>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Peter Xu <peterx@redhat.com>
> Signed-off-by: Aristeu Rozanski <aris@ruivo.org>

[...]

> -static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> -		unsigned long end, unsigned int flags, struct page **pages,
> -		int *nr)
> +static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
> +		unsigned long addr, unsigned long end,
> +		unsigned int flags, struct page **pages)
>   {
>   	struct page *page;
>   	struct folio *folio;
> -	int refs;
> +	unsigned long nr_pages = 0, i;

I don't think there is a need to initialize nr_pages to 0 here.

[...]

>   
> @@ -3129,8 +3139,7 @@ static bool gup_fast_permitted(unsigned
>   static unsigned long gup_fast(unsigned long start, unsigned long end,
>   		unsigned int gup_flags, struct page **pages)
>   {
> -	unsigned long flags;
> -	int nr_pinned = 0;
> +	unsigned long flags, nr_pinned = 0;

I don't think we have to initialize nr_pinned to 0 anymore.

>   	unsigned seq;
>   
>   	if (!IS_ENABLED(CONFIG_HAVE_GUP_FAST) ||
> @@ -3154,7 +3163,7 @@ static unsigned long gup_fast(unsigned l
>   	 * that come from callers of tlb_remove_table_sync_one().
>   	 */
>   	local_irq_save(flags);
> -	gup_fast_pgd_range(start, end, gup_flags, pages, &nr_pinned);
> +	nr_pinned = gup_fast_pgd_range(start, end, gup_flags, pages);
>   	local_irq_restore(flags);
>   
>   	/*
> 

In general, LGTM, and our gup tests seem to pass.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>



Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

