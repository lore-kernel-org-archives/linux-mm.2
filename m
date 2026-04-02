Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0B7111224B
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 02:01:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 564FF6B0088; Wed,  1 Apr 2026 22:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 515D96B0089; Wed,  1 Apr 2026 22:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42BAE6B008A; Wed,  1 Apr 2026 22:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3217D6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 22:01:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3F27B835F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:01:34 +0000 (UTC)
X-FDA: 84611964108.15.5B7FE7A
Received: from sender-pp-o91.zoho.in (sender-pp-o91.zoho.in [103.117.158.91])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0E1B018000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:01:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=uhEkm1jV;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf06.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775095293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UyQ2HgQdC5wspVAf2OjejzOyJAL3/rLH1bt4Ed9la48=;
	b=u8ID36zotug4FmumG0sP0bxULfsI1Mrhs54m4EP2OqMtm7FfMj9qiQeN8feVSiARqrYKkI
	iHDh3NIz2lUp5VdRrctg8QpM9wb0THe3kzU9/ifSWw7I90zgzzZ/FBW5FssIIvr0EZxKcW
	pXmJBKyGX+/QGwNY7XvThnr6V1IX12M=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1775095293; a=rsa-sha256;
	cv=pass;
	b=J3L3hUoFaUFwZJQvLHGcFBgL2bcEu2sIVXFt0XHskIeLu0A52c0tnPwT25KAhAdWpFvcOm
	7/+BOswZ8zKgdJ4jai08Uh0Sf1SeREZpEbKIHEEVJ0WuR3C/PZS4DXvM0k/pDhf5/WvwiD
	QLpZjv/a+iP+NLjWxNLqgemoHNSoRSI=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=zohomail.in header.s=zoho header.b=uhEkm1jV;
	dmarc=pass (policy=reject) header.from=zohomail.in;
	spf=pass (imf06.hostedemail.com: domain of shivamkalra98@zohomail.in designates 103.117.158.91 as permitted sender) smtp.mailfrom=shivamkalra98@zohomail.in;
	arc=pass ("zohomail.in:s=zohoarc:i=1")
ARC-Seal: i=1; a=rsa-sha256; t=1775095268; cv=none; 
	d=zohomail.in; s=zohoarc; 
	b=LewQDIUAGP/X2uvT3+RRX2g8PWpZWSbScAFx0pgRkcx8kCfPelnsZ41HVJlo/F7ZVMh+ec1XZ24UTUM9dLhiZSZU2YSLMl6a73MelR7f3ZVSXSn+1Ko6NO8Au0W3x3/VtBl6+U8bbIufe+D//n4I0fzyNV9PVhQjGRMAJR7xOn8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.in; s=zohoarc; 
	t=1775095268; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=UyQ2HgQdC5wspVAf2OjejzOyJAL3/rLH1bt4Ed9la48=; 
	b=VtjBnBcgoZDnMQT/4Iyk2mjywaKtWGXzUp57UJtDYJpyalH5HT+NErv5CnL4vhDCLIV3ybUG+WYdvPePVh2hZ62+LFF8xis050pPV09LZK2fcQSPu7T88ynfubHqTJgWDLfKozrHrsQPt+Qj3hjm+oP/ouaM/jYDU6Jpy1FUJik=
ARC-Authentication-Results: i=1; mx.zohomail.in;
	dkim=pass  header.i=zohomail.in;
	spf=pass  smtp.mailfrom=shivamkalra98@zohomail.in;
	dmarc=pass header.from=<shivamkalra98@zohomail.in>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1775095268;
	s=zoho; d=zohomail.in; i=shivamkalra98@zohomail.in;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=UyQ2HgQdC5wspVAf2OjejzOyJAL3/rLH1bt4Ed9la48=;
	b=uhEkm1jVxhbXJQoRHPd4YOa3NhEudV6kT9YOf44i5vP9XA+xQIEqrBNTL0EMF0vj
	+Q+wfYWqYOeOnDOhFTisbhHFECli6WEvAK2eecCTzyj83NtAfHt6aqmqLl5U8jMyUrq
	a875m9LnC8llisU8UgZSXElZvM1IWLLcK+/28sZ8=
Received: by mx.zoho.in with SMTPS id 1775095266475417.7375448390844;
	Thu, 2 Apr 2026 07:31:06 +0530 (IST)
Message-ID: <7bc4bba9-24ed-4a69-b9bd-d45d647f48b7@zohomail.in>
Date: Thu, 2 Apr 2026 07:31:05 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 3/4] mm/vmalloc: free unused pages on vrealloc() shrink
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Danilo Krummrich <dakr@kernel.org>
References: <20260401-vmalloc-shrink-v9-0-bf58dfb997d8@zohomail.in>
 <20260401-vmalloc-shrink-v9-3-bf58dfb997d8@zohomail.in>
 <ac2L2VNExpp8t7oF@google.com>
Content-Language: en-US
From: Shivam Kalra <shivamkalra98@zohomail.in>
In-Reply-To: <ac2L2VNExpp8t7oF@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 0E1B018000E
X-Stat-Signature: mmu8ohsa5p47f6qz9xphiw8pnecemt9c
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775095291-726338
X-HE-Meta: U2FsdGVkX1/Knm4cBqxhyz79/1BgdR0ncOr89tYrTnFdtVIq0ESvMCF85eZz2eEV0P2AfLCisy7vsB3jkvYHSYDBCpZO/90M9OXeZEvh860x5FLwv2PlCD6rTXt2vbw1wj69/I9OHiShq0GGYCzFA6g30e1NtuqxOwPTM+e2v7YpI/p13zTi+m6bm5TBtmmYAZ+awETVEAynCqYiWrPT2oXErvxD24qGmPrhbpQ9Hh1PcOWBgZ6T6XhjXL52qEoMtVQqlZ/zOxZkQhqI3DBVbfahEuCI0QuZ3K8hNt1vS7incRrSlnAgGpgh65VWtgd5gALLI2rYmt2vnB4iBiEIf5uTxigpp1Uuf6NonwN6cxmK6CqgEzcy9sw0VgVnanIZIgzCfS8QB9X5JRU2uzC4wcryoqNHfwvDKyMU8VZqsVdYVQvvEsBa3geHUx/wgzJbTc/Ev1lNIcIirlaFdRql2XTiiVwSvanN8KKlmtWN8NBz38U4jPEI2tWzLgLQZXSQeN7afQAZssrynENwE/HOJkUwpZMFF5d6goyaOx6l6QHmM0GCRH8FfTBBaj5qRKT6aYUqn/cOa+35iq0jHOfVYk22Kz3rMDBwn8bqHU+WZdvckcKgzM8jOdn5+ztLFfsteUwOWcC+JFJ/5ILnEByxLDey1kY2oAsyp5fOQgxvFg1OegPCZLH+vePBzDXy14b1ublEttzmfcasHRAuNI+jEnZor3Qmlr32wJYbKnWV8pdHU3vFVVOUUT3wTn3Zc/bRCaF+laZTrfmvB2p2I6EYlFwnGOrbbEuow6Peik5wjzD1Ag1ac+0mPI4j3hKkQuWI62NWj0isNzI0OoD2+orn/0K4DhsH4mg9IpSQzSh51M/38SSbFpqQopvQqSg+ptW2a57o8/N4pk/Nq1ox7xUuoLcpOYxk9JURnCelJG7gRoOYllREybAhctFrzB3QGiyA+tWZxBaHkp49xBTvj2p
 OcdGDVuf
 Ts8XCPE5Q1d1jdeyTHFcD+QXN3vf/rn5O+RqquGnAYvSqdAaSArYxTzGIb+rs6tBqsMnVJa36nEO00ifPwrMjjTA/aRNRdBCjel3VDCd6/7rIVkw5pMVct8yTsTkBgYROYgzbnzxaWgdhpFyj2KvSktxzNEdiMRFuRf8WGwRFbX+Y3s6NJXi2HTz1PPF5byFRQoLH+9+9BnGlBH7pEo0Vv0uVWg1rJunlLUiElq8LUQ2o+yDCVPETiL2HaD3pZcAqOaOXTs0iDd0NWIK2s0W55aUb35Up3U41FGvASewtDyRoR1CSdWX2TNoj//gVDw4uxxpjiAFUYrYLP2nMgxDFyHg/4Wo6LLIJRGyHthoGZqU7Uvs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02/04/26 02:49, Alice Ryhl wrote:
> Should we set nr_pages first? Right now, another thread may observe the
> range being unmapped but still see the old nr_pages value.

Isn't this exactly what the spinlock is for? The observer is supposed to
free the lock after they are done observing the value.
Can you point out the code where this might not be the case? Or am I
missing something?

