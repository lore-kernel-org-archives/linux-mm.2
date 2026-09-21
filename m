Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68650C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 14:37:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539E46B00CD; Mon, 21 Sep 2026 10:37:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 511BD6B00CF; Mon, 21 Sep 2026 10:37:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4276C6B00D1; Mon, 21 Sep 2026 10:37:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A5116B00CD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:37:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 93F311C1B6B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:37:33 +0000 (UTC)
X-FDA: 85238022786.16.5630E35
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf19.hostedemail.com (Postfix) with ESMTP id 603231A0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:37:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Nec/Y5qu";
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790001451;
	b=NO07ds11jVi951GyjXcei9djPzT/ro2BNSwnCEmTT3lzO6CAH+8zFTjcuI47TI4m1vACqr
	grkJRrSonutxZSYxZql5XjcSn4rsBtZjSZ4KC9uBlj5BBQnMwC2BtB4UlmVSEeafJis4lL
	NkFaz2FHZM+355lWLsNwyCurs9pDYVI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="Nec/Y5qu";
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 74.125.230.205 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790001451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vUrOHpknLsQODHI2VwdgOODmPETkIBd14WWg0Q6gUI=;
	b=jZcv8CbN1pE/6VaSAOAKHCVOuzoZW7khf1ckZNFneIbSTWyGYj/q/a20bpzQwLc0dlLbK4
	Re/EpqF4CFLmtzNeBUsvg24if2h0Aa1bR2UuFUPZOOrZPShCs+VI3ZbdQddvi4OElAOZm8
	gaahePBxkM56qYh79UQ8LafPbMKlLyM=
Received: by mail-qk2-f13.google.com with SMTP id d75a77b69052e-530e2f50d01so38269841cf.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:37:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1790001450; x=1790606250; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2vUrOHpknLsQODHI2VwdgOODmPETkIBd14WWg0Q6gUI=;
        b=Nec/Y5quBu+mGkT83eF+8W1oBK86yAIy1Np7QAxa6i0m+rTDEkXeUlwTD+wnP8leny
         0otxtvHYWbZfmftuefN5AaNpFzrPvaXzCUPtOrW4jJMVErO7GbLJq65dh6h/swIYjXdQ
         gKC3sJqApL+fgb/xo1URLAHYyJbU/1ixC00B01kxH8Das+Fzv4yDUYZzqbYFI9+TfYOJ
         EAWklQwSkFGsilcEySDJiJQho/V0inPiWgZPIfQLRyfIwzO+IVLZ5sgQerYTZlOp6AQP
         EopJsQaqb/GTHa+Vxy3eVg2An5RlZ78a1zUR4o1N8d46zRco+m/7I2SJZ7GYR0kIYlLX
         sQPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790001450; x=1790606250;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2vUrOHpknLsQODHI2VwdgOODmPETkIBd14WWg0Q6gUI=;
        b=INozaXrO47kF4qDDA0JxNAlkhDT4xbyN9W5tkaekPbw22AbpLPTlYAVUfIbbxqySYp
         iX4bp/UujPg4qEoOyZzkBat9KXkvHg/9F/tzgg+PNTpJ6yfVWW0Gad7yfPstGtyK8w1V
         yWlutliVIGWW3lBJlMb5WOfi3pz9QNxwsMeMUCByCn6HiXPmQqp6i0JZVaN+XZhvkCAA
         TXhpLjoD0aPnUytvqEsiWRFK96vPz1/hi9M1he4Hy9j6UbNlwgPAUXywUT1GEqIuK5k2
         ka2tPoOIdQNwOBQyQAIjSmHWcMebP9NDlyKad3COM4u7tYy4HKK+9RZSSaV3BYosmjke
         h1zA==
X-Forwarded-Encrypted: i=1; AKwUvByIJO7Zcbwyo2n43LDGIgDKkInp507yvRc3jD4y78orCrbdm97QYJ0WmLbbE8M7YMf0tPiZObIKpg==@kvack.org
X-Gm-Message-State: AFuF++mGnhubu7tTF+dSaIjAzApNfk0lIHdetqY9QyJyWdbvON0wDxtD
	c3IU8xEsAOk/KeTPy+mnLI2zmmLJ3kr75QDehzl1k4x5NxNhsWx8iSSGg5sYZ+E8IJc=
X-Gm-Gg: AYBFou2jKUz4yWWSC3Qzr8F46EgvboD8e/CFjDQwUWOwWcAktbPqLQsfq8m7oA1chXw
	//ApiGrVkRe0R2HFLZ+137GaUAUgsRZ+1wezXNs/4BAkczxBGuN88SpcB24QRBdQJ1/0emyUEP1
	eDpP6vTMnrbSHBYWTNM6ACb77eHE/1X56dOsKgECMftv1pm4VgSYIDf6kIdOwEDHhDRF4LyCOLh
	lTPXFDm7VvDtoALR2YUY+I+SposgzjKgE465FzX7SL/4Z5b1jLGKytEAtdjohSJkOuYCDIxMJqz
	90LgR9nVKt46kd591QEfn7KT7Q3eUGqTzi0dwujtgbOSel1Ry4SrdyltQ1c6uIVjE/S0IlNJWtc
	kcOEebR4Gckr15twqJu5RzUEpOBPpvKWmswnrfWB6xzSLD+ZOYOJC40+wC2OJjBWUZbz81+8lkH
	E7OUoAlG25PSsSu0MA9FkWiSFTSEki/mge25L2MF8FbvQzY1VexCKlIpIz3W+VJSZGsu58
X-Received: by 2002:ac8:5e4f:0:b0:532:ca19:afc1 with SMTP id d75a77b69052e-532d8d8a849mr9913591cf.29.1790001450247;
        Mon, 21 Sep 2026 07:37:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae511210sm65434551cf.2.2026.09.21.07.37.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 07:37:29 -0700 (PDT)
Date: Mon, 21 Sep 2026 10:37:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Matt Fleming <matt@readmodwrite.com>,
	Salvatore Dipietro <dipiets@amazon.it>, akpm@linux-foundation.org,
	abuehaze@amazon.com, alisaidi@amazon.com, blakgeof@amazon.com,
	brauner@kernel.org, brendan.jackman@linux.dev, david@redhat.com,
	dgc@kernel.org, dipietro.salvatore@gmail.com, djwong@kernel.org,
	hch@infradead.org, hch@lst.de, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-xfs@vger.kernel.org, mhocko@suse.com, ritesh.list@gmail.com,
	rvvandan@amazon.com, stable@vger.kernel.org, surenb@google.com,
	willy@infradead.org, ziy@nvidia.com
Subject: Re: [PATCH v4] mm/page_alloc: avoid direct compaction for costly
 __GFP_NORETRY allocations
Message-ID: <arFBJdYaRx_iJNDA@cmpxchg.org>
References: <20260905174239.99e31515fabe220aa7d8e6fa@linux-foundation.org>
 <20260910114602.926944-1-dipiets@amazon.it>
 <aqQlUr-1h07G8JWM@cmpxchg.org>
 <8d6a8a63-4adc-458a-b548-a47bf5ff8eb7@kernel.org>
 <aqq8pWI0u1IZNWHT@cmpxchg.org>
 <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9f415dc7-adad-4161-b20d-7c3173f50ff3@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 603231A0002
X-Rspam-User: 
X-Stat-Signature: tzbxx3egyah99uc1f1wnbahig3yfbh5z
X-HE-Tag: 1790001451-450004
X-HE-Meta: U2FsdGVkX1+N5ESfz2di71WKUvNXdMPr297i5XgkOTfsPXMma9jIB9z0nxcFHSvDVY4vNInOyWE+UP4G73zaibhrI2vp2WBEhN9rqqNBb9yAjrcAuLoHWt42yn7SgtQIzMFYqV4874B/Gupuh/BFvDczEMqad2Gm2cR747pPZ5QSOZPA+5skr8+HtVAY+qu/gORyjgiI9p0dsd04IetJX/82B3KdJJNTxP7F1UX2NEM4YBWB+7GU1qb4AwOPzopVAF4OBRVUyjbBc7z8Lyj9V9U3/ubtY935HwFp1oHshVhfxEGkZQdJH/3NnTQCuJQZYJz8DAYnV1K1P8h2zf1oW4QcPuMFFd1MVKhTEqpP8HxV/0XqCdY3CieXqoCbNZSDSL0vjxwLRlbq61niFufB4WsoJApH/cT+mpIxk1PGCZM4mCi1sbpz+WTg6JJutzjzqyZ5PrvIQ8ILOao66N4jV4JBxCWiCjCQhCON9yFQHQsU9esLtcAJHZq5F+cDDR0rspxVnd92LNlW55cRj3Pziq/SuOos6RuyWE347smYcU9UVx4HQiB02CsxcQY5pHvqgaguR/Sjz2K06Ti3i/IrKpaJIxczXiryUhX+weCiQeUfaaanlhi4yMydb4BolZ/XQiAdXD56FmKLvpV3y8yt34SYYhuPLpUz2QmJXSH0vzwBnTg0cQja/rIHZL0Q7XSmAES5V6umB9xvxnjBKVVtLnOpeur+9HFP4WXIbRhD5xkmNzVb05LBUIATIgBs1VLCOhEnOfT8peYvELM5Ok8BqfzOez72DUJMlw9Lh7XahvvgsKKB+5K3Cu5rxQjn0cv+nfzXteigyEIKIjJ9g+0lclAgZqmtXnaNxZAxaPvPvsJ4E/IRKJVauqKZjBEoZ5Uec9IoOD6nfKzEX43c+tUdL6Qjj4tOOGZ+Ea4QcAKVeYeIURU7W4a92tgj0gIE2UDuO4BXgNvNCfO5NAOW2jq
 XzOY+nCQ
 pvWNfdTLJw3+UK9Mb5qNflJvZVvvvrEDZvr1dcavzB3kSxspDNF3/GZuu7uMbDmyNWIcagbiBwU5sx17WfAMghsCDgFXr3jTDHuDoSu8PK1Zz//47q8lsn9OfI53BTEmHUoXf2P+g26lEMSzw9zUUyHKL33KHxwhqDxdsk6FU5dETjRHqK1TRRazMHei+gppPHztJwrXtl2h4yCqFPfEGWV4uB8BlCfHnsVIMb9FNPBkdONqBIuUAd3bPDYvSXJL5tzEvxLrdz4pmlQahekbnTPgn0VRVpWkr0MhAa/C/1hHPUxZTpns//QFjTrvdwZisxuwl9vCJqPIdRHBpx6qjxTq0COqTdqJT8cTzoe3dUuIBlOpo9u2IWPZCtW292aHSXNq365eBV6nRqpbG3H21l2zE704N1WOua3VzwezKOt4/PlrwRBB1Z/uArzBb/CIn9LNdTxIZfKcVZM3/VDugR11IgoSmCGb9x60UTi/SYSVmxKnuQNKX+pPnrAnYpgRcHMiranE/FxN6jQJ2W/eKUamqMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 09:05:40AM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/16/26 17:58, Johannes Weiner wrote:
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 12fac9084c48..c79cc7aa4dff 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -3246,7 +3246,8 @@ struct page *rmqueue_buddy(struct zone *preferred_zone, struct zone *zone,
> >  			 * reserves as failing now is worse than failing a
> >  			 * high-order atomic allocation in the future.
> >  			 */
> > -			if (!page && (alloc_flags & (ALLOC_OOM|ALLOC_NON_BLOCK)))
> > +			if (!page && ((alloc_flags & ALLOC_OOM) ||
> > +				      ((alloc_flags & ALLOC_MASK_ATOMIC) == ALLOC_MASK_ATOMIC)))
> >  				page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
> >  
> >  			if (!page) {
> > diff --git a/mm/page_alloc.h b/mm/page_alloc.h
> > index b9259deddb59..11714ddca254 100644
> > --- a/mm/page_alloc.h
> > +++ b/mm/page_alloc.h
> > @@ -60,6 +60,9 @@
> >  /* Flags that allow allocations below the min watermark. */
> >  #define ALLOC_RESERVES (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
> >  
> > +/* Flag combination from GFP_ATOMIC */
> > +#define ALLOC_MASK_ATOMIC (ALLOC_NON_BLOCK|ALLOC_MIN_RESERVE)
> > +
> >  /*
> >   * Structure for holding the mostly immutable allocation parameters passed
> >   * between functions involved in allocations, including the alloc_pages*
> 
> Should work.
> 
> > 
> >> Unless I'm mistaken about that MIGRATE_HIGHATOMIC part, it seems all sashiko
> >> concerns can be dismissed and then indeed v4 is the better version.
> > 
> > It looks like a real issue to me, but one that already exists
> > independent of Salvatore's change.
> 
> But Salvatore's change (v4, not v5 IIUC) will make it worse because
> __GFP_DIRECT_RECLAIM + __GFP_NORETRY costly order opportunistic attempts
> with fallback will start eating the highatomic reserves too?
>
> In that case the fix for this should probably be part of the same PR to
> Linus and be also stable with Fixes: 281dd25c1a01

Yes, agreed on both.

Sorry for the delay - while poking around I found another oddity in
how the reserves are accessed.

I'll reply with two patches that I think we want to go in as fixes,
whether Salvatore's patch goes ahead or not.

