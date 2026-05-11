Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00964CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 12:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C4336B00A5; Mon, 11 May 2026 08:33:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274C66B00A8; Mon, 11 May 2026 08:33:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A736B00AF; Mon, 11 May 2026 08:33:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07B626B00A5
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:33:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CFB7C20BB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:13 +0000 (UTC)
X-FDA: 84755079066.06.86E47D2
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB99BA000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:33:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XEw8Vzfr;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778502791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQ8GDHoMMadB1aUvI6LaksXBUBP52lqCBfDle2B67JU=;
	b=Avs/nmCNxChTVUHNsyBUJ7AV3oydZ6jQ7a8upC3nEZnWFIXD54irznj8SS5H5o3mMECUYr
	DuL0c3kgMUrdm5GUktkZXrEgX15/9cSNbzhlxtEhnBWvxxx/MY/wL3gKHa3qc9HfIuh44y
	et21PPTY7EhdZyZE5a79z6V8dxkit5k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778502791; a=rsa-sha256;
	cv=none;
	b=b1zwqLM9jt8s2B5IYG17XHRGxGHrsSwxcsUf6tHrUbgOc91c/G7R/EclsM5npTs99fTSQR
	1okR2Ek4we4jei5fCeowyp12FAKgjtL3HB5++pe4Eff4o07Ab+UBEuigCDWY/09jR71UvA
	/9Cwtqaf9ReChtHJagZwPakBJIrGGHE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XEw8Vzfr;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf15.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4891f625344so40900655e9.0
        for <linux-mm@kvack.org>; Mon, 11 May 2026 05:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1778502790; x=1779107590; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=yQ8GDHoMMadB1aUvI6LaksXBUBP52lqCBfDle2B67JU=;
        b=XEw8VzfrSFMbzGsoc0EePaiiGkbJkQFKxz3+wBwuh/x2wN7DnpRXdTzN/ZxxEX4Ycf
         U9USZ4T4agAaAoPd8iW1ctT0ICwwvcQ+FRlcp46bpEe2Tv0SdkLtXWMPqx/h9bVjFC5J
         95tkvT9r7AWjUoDpmUyVmNEA0A+AKORrP5yuDkhxF+KVZBZajy0NFmbLCeWdbuTvW5Y6
         Q6QmIC/ok5+7E/EIB7FNzs61krl3oFYJ10reUAqaQiaANFVN3Zg/xUCBJQCMSq3/QMuQ
         0KVlL7npkG8MBn1zDdf5hBjHr2IT7RZJk06cUTORxZnb4ZeoSOde81vikTRIRHmnY9rw
         Nn+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778502790; x=1779107590;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yQ8GDHoMMadB1aUvI6LaksXBUBP52lqCBfDle2B67JU=;
        b=kY9yjdyVUR8uYM65qZZINFibZjAFnQQoKGe7R148h0UKIbvd+Se3t26UlBwd0F3kVF
         RfAZRbVOYir34SxSo8dMU3zSxi1uG3iTLHFeQAtjYLd6d/t7aSxqv2Cv+sOjFzP2EJrB
         KFw5HYCZJuAOrj6dn7cGAqmNceSOKyZ4HFnlcxnhTVNBV2rvjFJ0G26DtFZyaFDWB1w9
         JeklRexzwfLPVQV7FCwV5a/u3nuH5+Dbpi4tv3Ym9WWLjjmBUhXS3ypYmzuEmZxQ0mmi
         /8q48IygC+vftXeOXDhTCcbK+XJqjZdZxpnI8+XyqOrtAp5ypZZ0DtvGFEczo/+0en9f
         /+Og==
X-Forwarded-Encrypted: i=1; AFNElJ/hba+wyRjmzyapIBpcYrwZLfmhs7D5VKmtvtKCN+OwN7bsVUyHnfa0HO/dcl6spctLd6qIaekgQg==@kvack.org
X-Gm-Message-State: AOJu0Ywu2Mz3rFF3ZYH/Kq9p7ehvK4ykUM8uHoKoYJHUoGKjeDQRcQBd
	M5uArqMFEsn9eaTjsRFJ7ZzJMq1xs1zdmzgv32Bvg3ZWlDaMExW10wC7ZScenwgRHlw=
X-Gm-Gg: Acq92OHGTHuX951rA6ICc9C12rV3AUdkoN8fgd4hJkgIVGsCcEd7RXYgHcS/diidUO0
	qVC/seeW02yUg+wi7HUnXzFrF3oQ7VX0xPV1gu/9KutZjBae5Rt4uI3icY5QLLbBVp6dbdsdUgQ
	y4NtoCCbWG7xrXuPHoJYCzkkamNYW5fLH/UBHfarocvj6rmfgFOWImhjQJoSJrwA9LdjPPhM2BC
	2tsg4sY01EdtueeqRr+2+VoX3251+KJYjTqTBHaef5AKQenZJmiNubmaAzw697vvYhsR7sg9XN5
	oE52TlO6Vd0waZhzlJES6ELrsBfwhN2SUmUIZyqKyQTpbTIbszMYoAhIa41tuNdq4RmpdsU8q2f
	r9h1YAqxI9WngA0AzdNU9kXHanTD6rvR9r60jHvBJ0V7rclaBdYpZ2r4NTW6EPpOlTclWJz1GA8
	PI/TgWaAw6ypjD7JW3KxrcbjagWFDCOOBPH6fb
X-Received: by 2002:a05:600c:3b20:b0:489:1d7a:4537 with SMTP id 5b1f17b1804b1-48e5dfcd4a9mr262253605e9.3.1778502789997;
        Mon, 11 May 2026 05:33:09 -0700 (PDT)
Received: from localhost (109-81-87-110.rct.o2.cz. [109.81.87.110])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e702f48a8sm177455525e9.15.2026.05.11.05.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 05:33:09 -0700 (PDT)
Date: Mon, 11 May 2026 14:33:08 +0200
From: Michal Hocko <mhocko@suse.com>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	zihan zhou <15645113830zzh@gmail.com>,
	yaowenchao <yaowenchao@jd.com>, linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: Re: [PATCH] mm/page_alloc: Fix zone reserve update serialization
Message-ID: <agHMhEBAz9sol3TP@tiehlicka>
References: <20260511120409.2264209-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511120409.2264209-1-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: BB99BA000A
X-Rspamd-Server: rspam04
X-Stat-Signature: hs3snrm1o4sxn3xsgb4yyh5fqzj8db3r
X-HE-Tag: 1778502791-570227
X-HE-Meta: U2FsdGVkX1/U3kaSQK2+6x71q2/9Undx0AuhbpVfSfrbXUKDqJ2/eJ8S+1IYA8frDvq+RqWtkMFNIZg6DLjTnx6uIUXKU3/dUfepfgkOiADtxShIKPRuEtoteuFhF6WbOMib4Ym8WUIQqK/NYTFYOdWSB6bCiZedyS7Qzw5svUn2JGGnr4vKeV1eoOE6v23B2NniorNKAgq06RuyOgItbF6NlxV8aw1nfVLKKQdlBvyjvuf45q49E8M79oyG8J/8uyOu2bqTifQtjeYr0d/5wTMENijuxJ+uiVHmCLO5eJxcLQ3Uu3S9ZFBGFC4B2Po4ngQ5K6OxtK0EttSIV3uA59I9rsh4EevxJWtJAP4XDjYz0FW8ufWtRhWyhv8GKu9kKmfavV8YfXReE5Z7palZjZ6M8n9ODyHPVy0FABSWfGi9PMVNFcnoM/Vymun0OUFQkbH/hHnFp+XqwOiLnO6ajd4KIsOBHrjrB6Yhoz2T5yHYWkSN1eFyXLErsX5EwFtpN8QabP3HeYq3twyMMkil0ZBlutUFRF0qrAnZ5PcOZ/QaVSD4i817C19TQyJ1BcQ3RPFRU2qGoWe1lUY2bJQHHZITkhxUXU0xajVB58DjKumoiaIK9ZfKRbOhm7F8wfedZqz98NTlCV0FtYMID542aKwDp3njZdCVYDDH21qTVp1f7B+DSsNHTqWAPqch0XkdH9bYPKMtGyEn3PXiAHaq2Rqmjro15QVRJJiscLxy86g9vKjC4Fqn5KAFq/WfLs9Um8sEitq5kmcPWKMRBG5ayvmjtEVek42JLWoeAejycdbaPVlslsfJDsh2HILEzDc/74jturJ8VgEHTSRFnbVuwUtnhO0WlDLTbTIrp9kFM/0yLmxefYuKwnMKsPSsHHOJEhlffOeUSciw0G2bB1/IBLcUSo2DZhg98vzlrL8q3n3pUa1jrxqqaY7SYPjGeEpNuemFd+9tS5bwNQJ/OrR
 enoQXecw
 7Gnu7GdjKtdfEOxzC6tj5mhwBmGKEdfghnpaSAcGg1IU/qSjDhDiLURDAftQ6zPwk0WenI+E0Is4sWS4Oy2YyaTnnHP3zCsnxlSNKkOCQAJs5OV58R/bJX0dJYz5X1Xd5QPqF5cRgnzNTXFBoHSECiDLJkyJ1JygRKAD0sTFUXWlwDnC2MIAdSqZumipLys/0XY6Rt3nxiOm9ppYTGbIKidOCu364ENXNRymn+ceoqAeDcmtz035z8UucehnxEfa9fZALWSYrnoYOZ/zYE3gs7iLBmlOVAbvwZ6qbqzW3sTiGM6l6TDdNSPegNZjuA/d6WynQOG85u4giIIa0M6lORDszwBcvbF5BUeJJHrLoXQT+6WdkY27bcdB2uDhPo/JFrz4r6xx5hLL7JBLa3xcSj8ty8Rw7Yu+puDknFWrHk3bs1HxFpWKQOTPlcCQPOl8SzkDosAdWmFOin7t+83cyhdo/5yTdDXINxZ9pOMMK09I9xlCrDD/N2MKlzeCy9wPEXrY6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 20:04:09, Muchun Song wrote:
> Serialize lowmem reserve and watermark updates with the same lock so
> calculate_totalreserve_pages() cannot observe partially updated zone
> reserve state.

Could you describe the problem you are facing?

> Fixes: 9726891fe753 ("mm: page_alloc: fix missed updates of lowmem_reserve in adjust_managed_page_count")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/page_alloc.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 3a56825a7fc5..0989067da588 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6384,6 +6384,8 @@ static void calculate_totalreserve_pages(void)
>  	trace_mm_calculate_totalreserve_pages(totalreserve_pages);
>  }
>  
> +static DEFINE_SPINLOCK(zone_reserve_lock);
> +
>  /*
>   * setup_per_zone_lowmem_reserve - called whenever
>   *	sysctl_lowmem_reserve_ratio changes.  Ensures that each zone
> @@ -6394,6 +6396,8 @@ static void setup_per_zone_lowmem_reserve(void)
>  {
>  	struct pglist_data *pgdat;
>  	enum zone_type i, j;
> +
> +	guard(spinlock_irqsave)(&zone_reserve_lock);
>  	/*
>  	 * For a given zone node_zones[i], lowmem_reserve[j] (j > i)
>  	 * represents how many pages in zone i must effectively be kept
> @@ -6509,11 +6513,9 @@ static void __setup_per_zone_wmarks(void)
>  void setup_per_zone_wmarks(void)
>  {
>  	struct zone *zone;
> -	static DEFINE_SPINLOCK(lock);
>  
> -	spin_lock(&lock);
> -	__setup_per_zone_wmarks();
> -	spin_unlock(&lock);
> +	scoped_guard(spinlock_irqsave, &zone_reserve_lock)
> +		__setup_per_zone_wmarks();
>  
>  	/*
>  	 * The watermark size have changed so update the pcpu batch
> 
> base-commit: e98d21c170b01ddef366f023bbfcf6b31509fa83
> -- 
> 2.54.0

-- 
Michal Hocko
SUSE Labs

