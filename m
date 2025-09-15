Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40AA9CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 20:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9ABCF8E000F; Mon, 15 Sep 2025 16:15:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95C448E0001; Mon, 15 Sep 2025 16:15:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872858E000F; Mon, 15 Sep 2025 16:15:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73CAF8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:15:05 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A24A1DF822
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:05 +0000 (UTC)
X-FDA: 83892588570.28.A337771
Received: from relay.hostedemail.com (unirelay08 [10.200.18.71])
	by imf10.hostedemail.com (Postfix) with ESMTP id 05191C0012
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/i2I5DeaWOvcMJn5TU1coJuYZxH6rbblO4Do7zaM7lQ=;
	b=p3sEQu5x6lIzXfR4p0Ydyix8ZykM8BfLkeRMVvocikRIIX7dyj5PINCg0ovfm/35Vej4Tt
	nVlajRYZ06ieUlUaLgFiXbvke/KV1NzU/vluMed0PUO/7i2UoyymqRTe0zeNSvAQ2K5cO4
	q7Qkn6BG+R7WWfQrCDV+64BwChq/uiM=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	arc=pass ("hostedemail.com:s=arc-20220608:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1757967303; a=rsa-sha256;
	cv=pass;
	b=Whk8VEtqsf+SoTZGpoYpvx5Bz+oD8XNyvaDSsTsyW/S7hX5pboG5qZ9pE8FKpO65vgL5gp
	4wSF4A4N8ojSiFTObxnHRqjMd8TSZfKdQsEa8AWwPm5NOhREeOoiW9jB1k06PPynIjzxfs
	Bv+kLhvRCXHG5IPpyQUbNdlTgC0XCic=
Received: from relay.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DF13140777
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:02 +0000 (UTC)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 611AB5A8D4
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:02 +0000 (UTC)
X-FDA: 83892588444.30.C5737F2
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 66BEFC0009
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 20:15:00 +0000 (UTC)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757967300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/i2I5DeaWOvcMJn5TU1coJuYZxH6rbblO4Do7zaM7lQ=;
	b=eIyfcLaQ0TMX1QEUuskr7gH1r3cuUXw4Z13HrSk2psneWeYSdh1pprrckAOW/EYAruiZc2
	DH0h36zGliZORD6XmFkxdvY8/FLk1IfnxuISbBmTG3FPY5BAlduzGGE2u5EqUBNiU1/qBx
	TSkBKng5YVykJq2tcow6UxEg3ySSGWI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757967300; a=rsa-sha256;
	cv=none;
	b=r1ZMvbHc0lLd4YC+odyoMVrx4rE7Y+l+nh/1+v2GdbpnYKEPcyP+COOnlu2t6lJTyeV8bh
	wV0fhaa6MwoHTPwTiTr1gIZaSJPRFcOXMyJ83N4X7iAHTeN6xnYlcb6h4vKjKNVe9PiFda
	Hp4Isv6kAwiBh7EP3Rlm1om9SyBwPiw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=p0JxLlYo;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 15 Sep 2025 13:14:52 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757967297;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/i2I5DeaWOvcMJn5TU1coJuYZxH6rbblO4Do7zaM7lQ=;
	b=p0JxLlYoGJ9/kmI9rASJEFGviUAXrEweuYwFpc7XvrySnalbtunyuVtgagnOYv6ZRp6LZa
	v1AV3z3CCCg6AFVYIcvmX8f0adPpHfd840BJaMi+NHS2qZPnRWWMk9Erf03W4GcRqw8P9R
	o+qSI2BNh96FbOWSz6l2NEKON2w/0Ag=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>
Cc: vbabka@suse.cz, akpm@linux-foundation.org, cl@gentwo.org, 
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com, 
	alexei.starovoitov@gmail.com, usamaarif642@gmail.com, 00107082@163.com, souravpanda@google.com, 
	kent.overstreet@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/2] slab: prevent warnings when slab obj_exts vector
 allocation fails
Message-ID: <wb63gbfs3x7hyhy6kzkg5ggn4mgngwrumkpvkg4fg2ju7oeg35@2ls4eggjpfqv>
References: <20250915200918.3855580-1-surenb@google.com>
 <20250915200918.3855580-2-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915200918.3855580-2-surenb@google.com>
X-Migadu-Flow: FLOW_OUT
X-HE-Meta: U2FsdGVkX1+ijiOwsbK9tVg8hMbRmTbtfGYtPaSH82MjR2aQWhSzRTcddhR18f4k/6UdHI0jCQlJb5r+K6k0ceHouaBed3A3mq6WQz/LGacvcPnbFXbo+BfTJNAUgrZ6P1z20OHntfgF9du4tiMqW9+qNYrWRAuRAv7fLoA6JuxrJec3p3Stk4wpLl7Aq3+3GcAMc1/LtVaqOJXFWA66MBbiR7P/k0vN61P6A8HRgYr5YZI646Fq9nwapNYuR7oT85QH26kbhVonBJ9oLIIxR/ohYcF6n+5xJ39VhjgUTf1m47ROomMYFVrN5+f54vcM2t/iDlrFTdNif7J77oZSYZHT16ysEYva0fUXF1ig6cceXwgG/HefjdGIur19voXiBmsKUwqoCm4SmhzMY4Ud1OEmXDRQrk3JPh2d10O1Epyq6mwQC1GwzZD2t6pMiSyWrvA1QbbnOnmj7dgzhiXSgyrT1XFEJUZvtwDh13cFJ5xYqPCMLcp1l2/CTYkqWs14ec3hs/rDQMGuOVwCIC8+cif99VVHgZBSlr1TD849KQdecJzk8T063WNHaCEx6RP7hSCdIqawhDKO4w9F/iFfEGRhNmi4nG6Yp/20I2bl4c9SXZZBOOwNOK0fhr/DyKIaX1Z0FsZ1Puj4dZiBj2KGiNWseyA/2iKthGtikqERYza9y18n54zecnEvS7JKtkGy56iloj/+CxeQlxwAPiOCfdrSSm4+iAi4M5EcKjMIpnIu1VPSzAYOlVw52NudR3ntHBYmD9YXmfxVmMZzicUkCFPeYYe/EawE27VxE3nJOOcCA2sDli07AxqtOJ9drKalp//J9AeA995Ftxb3hkpM5joigfGhcZJFykay/yaIyyDU7gBNjwApe1qFsw3HZM4atdMfqFTVSK8BHCPixhd12zpLP3uI96FcUwT/tl0gjTCY9sTSWitqKtKfzdVzH2QHVYgKL7KMrHorcHcUvU2
 vakEhwb1
 n2vyoNFjai7I1y0L1SSUpV4Q8Ze9D6SfSOOXHb8dsebls+6s1g+pquge2g7/PWsrkmHWQNiHitBhq0yy772rEEOcRnN0cqIcV9uofL2V/40lNNbduAWmdnMh5906AutmADasknzJQNGgI+cVJPQIbsAtZ676A1uvo9BvTc2OHIZ+11jvOgj+VYZd5SEX/RJ2nnpiNUdEH8FyNNsxqIRK0i3WinUUJdyA4eJygAvMJ1+nGdHbQ/Yen9i9as3XlperuDj10kDjAGvCI2e7exbtvFBfkoABxw+LAt6QLprgNH5A4qoz+M/2xzyAQ0LOdI2ATTikIlGCv8GOgOfPuomHxrFCZQ8aMr2dFqi8rrqVJtFQdbkDxPeHvZ9Hd6Q==
X-Rspam-User: 
X-HE-Tag-Orig: 1757967300-756593
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 05191C0012
X-Stat-Signature: i8zmowqmjief4a5tjfjtx8msx6jhgsug
X-HE-Tag: 1757967302-787703
X-HE-Meta: U2FsdGVkX1/pXfc2r9WnmnXKiYMvCN0LRfKeT+h38yHQ6hgO0gKia82uVxi67OSQAcBSOD/h4xUFlTf0+fKswtkxTCUGtG3mVYyEdNdXxWT4+ARq8R5YIwNsPrwEbgtnvsw73eoEa8nt4VebBCqZFIRPwFZuPTaQt00q+oisULwGvDc9WjaamP8Ls6KMdiLugpZWXe7u6C9V7xmWg3GTczkEf3aArk5OlKUZW0nAlPpSbSD1WLOEO5MF6OVaf3kUZzmrtFMi6Ozd9a0oglLj6oqjVDIb7sI35rwBBVNr5zcWHRyTlDHULH8twyrgKqTFRbqqw/RPU17QBbWxbQtz6idfEH/Piw1VGaHQIRnWl8VGAqnPGrLDRbvjigr+qCOgryDZbwBe+b86AZ1A9xxxmvypST0mHBwmJr9eO0uRg3sVRwny65VyJr5ij7kV3tCREncpumM5nkIPhtDPqiq/Qt4e5VM8Lma8rdFl8ucsJtB6ayUk59ET8gq7rJfnzVkznNjHmn8h7zZ45Aqvaw57s/JuBRDIUpXPx6lncXO5NUp4dtYZ94rsE7GbI+jvkU0R7rKDwcitvQR31DeFuDTjROGZjy3Ea7iIPKg08OzhEOXxbFzrqSMnYMLicGGFnR2lRNGbin2m4tX1sxzTTmzjO2puofia27vGfQ/3Q7l5TWhPMWAIlyrJvZGgyjjle2OP2H2318rXmoH1RrJrCdG5fXqvSD1mDzb7KeDUEPpLRphsHSpTP6wYnuIFcATTb7S3HIxlurUW7rvSTHjjkjq6aOlSpBWHuVKWvphlf1n/UApVOxcRFu/lV83eD/661Rw/tzctxJT+vck9wnRIcCoLkocqXwLsRpZXyVJmvGxDdnHWeAk3cuwja6D4E9TKjPAFqrGi0/CwsNJ/h3zNkpN9YFWJ4fqJEqRH3SqCdswjsAT/ySgGNP139/Twd9jSTfXBGwuTa4mt4Z4jCrPaIag
 3wWPlDz3
 00YbpsONk5cScoGeKLShrkpaXUxnZ+2hSFThhXXMWnwTMLRhFARj6P1mIIX//YsdRGSrKR4MjVZl72O5yRAHDUH/Lfs+GOqFG+QTJffxKl+AVDf+tN54wn4YJah5IUOTnU7IgGwtwzebZFQojoWHirbOqhgYta27kuhf19Hgy3HqtBYuqVYJR5qEDDFugAakqk9VNYSMDd51S6E+d9B1tIiEBbw6kIJoSIYXGJao3MChq+ByYvPa9gs85MO5gi5BvmaLMICRpR2g73CTuhgNEpeZNTQSVo1p4mymjQ+rWwB57/ka7SsdJCgR2RlmlL0UUt95YBzN+uzYyjC+P4MEHR2/H9EmkmYC1UJBD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 01:09:17PM -0700, Suren Baghdasaryan wrote:
> When object extension vector allocation fails, we set slab->obj_exts to
> OBJEXTS_ALLOC_FAIL to indicate the failure. Later, once the vector is
> successfully allocated, we will use this flag to mark codetag references
> stored in that vector as empty to avoid codetag warnings.
> 
> slab_obj_exts() used to retrieve the slab->obj_exts vector pointer checks
> slab->obj_exts for being either NULL or a pointer with MEMCG_DATA_OBJEXTS
> bit set. However it does not handle the case when slab->obj_exts equals
> OBJEXTS_ALLOC_FAIL. Add the missing condition to avoid extra warning.
> 
> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
> Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
> Closes: https://lore.kernel.org/all/jftidhymri2af5u3xtcqry3cfu6aqzte3uzlznhlaylgrdztsi@5vpjnzpsemf5/
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Cc: stable@vger.kernel.org # v6.10+

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


