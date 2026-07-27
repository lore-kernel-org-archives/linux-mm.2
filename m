Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3BC3C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:11:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F199C6B00D1; Mon, 27 Jul 2026 08:11:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAC66B00D3; Mon, 27 Jul 2026 08:11:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBC1A6B00D4; Mon, 27 Jul 2026 08:11:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B0B1C6B00D1
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:11:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4105E1C0DDF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:11:12 +0000 (UTC)
X-FDA: 85034441184.01.61565CB
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1DC841A0011
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:11:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eIN1J/zh";
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785154270;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FqRDMJ385c9CEd6uthhS9gKVU+eex7894C+QhK8tFGU=;
	b=GdbhEXQ4EcunEbB1CVi+FSO+LgFe8AuAMjjlsfRMKCTCP26MmRLkuyVo8t+jHjSGnHMqm7
	sZMbrLoSi0rWyQNJpObymZf/LxU5pFQ5KkDylFfRDyZSKeCNa1T4YDNQTv49r0ZvLOTyQr
	Qn9miT8YLX2eDsmjPfTgEnqVCgLNNiU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785154270;
	b=5pZoaN9eZCL8HjKHys/1L43lhGBj2bBlkoWi1uXv+vXp9iIzWk0QSAa5UaG0zcxEQaPDFs
	MIfLGox84IolVhHtJ7RxHbU90UJde3XRuRTyJIxSw3nEw/+hbwegG+1p0LdW1KHClFC2gy
	43y7ugrgcQB78W0QymkOCy4vdpfA38k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eIN1J/zh";
	spf=pass (imf19.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785154267;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FqRDMJ385c9CEd6uthhS9gKVU+eex7894C+QhK8tFGU=;
	b=eIN1J/zh87o7cJi166fmqwLOwxGSkLpAFu7ZEoQQWmIhhdtNP54qw7VJ5bVgxhINNsw3Mb
	oBY+cCBtQqywHbvs0sO1F99YtzmnSmd8ew6SDmY3d9IkVDWjhaGFYOoLodOmk/uJFZEwpM
	AkeMJjHVZM8Wc2sAjl0dzWjCjcGjojQ=
From: Hongfu Li <hongfu.li@linux.dev>
To: david@kernel.org
Cc: akpm@linux-foundation.org,
	hongfu.li@linux.dev,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v2 2/2] mm: Extract non-swap page handling to do_non_swap_page()
Date: Mon, 27 Jul 2026 20:10:47 +0800
Message-ID: <20260727121047.4140-1-hongfu.li@linux.dev>
In-Reply-To: <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
References: <10c60511-c841-4bd8-aa5f-0d826b676533@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1DC841A0011
X-Stat-Signature: jgk7jjx858qbhrhi9s56zg5kkzqhojep
X-Rspam-User: 
X-HE-Tag: 1785154269-907464
X-HE-Meta: U2FsdGVkX18huYeMtRv/26rR3OwYlvEivqC5dEN0lTTJSAMJnZ1O+A+yQrSWXDId49NtAlSI0qIjdX6TRLwHTeEMnInLEliUY5kmBAjo56Kuy3fn4ScmQGooQBiB90SCew3AM8zB0RJEa5BFYMDCmGW01bLNx+yTkz/SXlTsw+8F/Hf/5avFSoCae+qJHJfDi9hM7Kwu3/yObFL3NLkuR9Pcqh81IA5QtKqtdqWWBToYQsJeZV0ZGI9mN5hya0B0hQjpBzfbzNNHIo0CVLvqmBMMyYbmBg90m3hIEf7dOhoBZ+CfgqZGBm1W7VnLdC/sWaBHPJhXDCdzp1fe9Yz79MlRUINyWE+JXu1GxVhS3BsbrsibyqaIj1vyn36QO/8zv8Tz3lG6yblgfeXyzQfz/QLhsHWVnZPVwZcNJP3f/gCLW7zWilqzPMXLl/xr6pwDrfRoik6/uFC0CwPz2BcQVNiYNMK6+DaFimuXdEAwEvF4y0vnkKb6QxRdDOZAxF53DaBYiGULblTdMgXcAIgntG7H01suqIMdNjCB6UezqUIzZirZXHCZyVMbG8YE8RGVsVEDYTKdn147GAroZU3+mKVquRFZrH+fZOb/Q/b9RUDNEMjlz5d+B0DGaoa/hk39wGBK/x6EmWBNYUbnQsNyfSeCu0F7OSo3gMaFhtPBXp7SDHTgmj0XjjruObY9ka81mydEn2+Oul0ZKQm8iJ2VIqvWfz1obfnqcI6c+rJBMwMjHT2JBJeGBGbZI9sb5mJwXU2iZ8f0ZXzWwNU/Qa64qFqf9gi/mKeJ1jeejU1GFLi9WAgP6h1IkYxRXcMakAsaWDxJF+pFI6+7uc50j6kYX7ddq+9z12IZPV8/Mw5Pi0KWi3tpdZw7p6EwQYKsz1Le84JsdTtcusgAaBnWvUCAJqHeK0OZh+GJCg/C+CqCCyJ+SN1Ao94g6hmJRR3M8WLYlH+Q7nvD7tnUBUWtSHS
 H/FVwaVj
 Zok2eK2hsA9aj6xerptmvYCq04BCYxWMooOF+PG240SYClffmARpQmRGm8zvVxYkKrSXleisVaygCJdU/hXddCptWTJSbqFrKfuevJyQ3974WWc1Q0dECNG/dvEJWFA30uJrSNiiKkC4ArOi4pNvBw9rRMoaFgIAhOhP/OkaK+v2taozQ5oKTP/Y7YtfpUi5PuwF0KXq3NUt9HMhZJA03dznIaFNpEDr4z+YQp13k99fpsxUQkhrxIpkx3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >  mm/memory.c | 120 ++++++++++++++++++++++++++++++----------------------
> >  1 file changed, 69 insertions(+), 51 deletions(-)
> > 
> > diff --git a/mm/memory.c b/mm/memory.c
> > index ae521baa8c84..50d8e92aef91 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4815,6 +4815,74 @@ static void check_swap_exclusive(struct folio *folio, swp_entry_t entry,
> >  	} while (--nr_pages);
> >  }
> >  
> > +static vm_fault_t do_non_swap_page(struct vm_fault *vmf)
> 
> We're handling softleaf entries that are not swap entries.
> 
> do_nonswap_softleaf() or sth like that would be better than talking about "page"
> if there is not even a page.
> 
> But actually it should be the other way around:
> 
> do_softleaf_entry() [currently do_swap_page]
>    ... non-swap entries
>    do_swap_entry()
> 
> Or sth like that. Then, maybe in the future, we can just move do_swap_entry()
> out of memory.c
> 
> So we're factoring the wrong thing out in this patch.

Thank you very much for the detailed review, your analysis makes perfect sense to me.
                                                                                                                                                                                                                                                                                
I'm glad to send out v3 shortly for your further review, with 
do_non_swap_page renamed to do_nonswap_softleaf.

Best regards,
Hongfu

