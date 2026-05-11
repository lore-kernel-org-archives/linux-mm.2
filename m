Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD607CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201DA6B00D4; Mon, 11 May 2026 12:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2C36B0160; Mon, 11 May 2026 12:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9EE6B0161; Mon, 11 May 2026 12:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF81D6B00D4
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:58:57 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 95D8FA01E9
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:58:57 +0000 (UTC)
X-FDA: 84755748714.11.231BFED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id CBAD8C0011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:58:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWi4+eNE;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778518735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0VZ7h8GyW3jE8XThztGt+2kChFJkvDlsVTSldzWFb0k=;
	b=dF2mffLZ2mtQJ19kDMgnt1ynfwj3deLaHsoVLPKo23h2Evxy8ntCy4GMgffVftQys5qux2
	5D/AOujzYzv5V6NKi6hluLc7Rq8121MOHbzfiN1B58vzLdxEhPJjGhvZaW79zIWymVSWvv
	ipMIlSdXST6U8wYbbql/+1fDo8Zn7Us=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IWi4+eNE;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778518735; a=rsa-sha256;
	cv=none;
	b=Co9xopnvDA4vJhTzSsHaQbFGfrbFojSCKW5pd8HxjqEO/6hqaMt5U/8FkEXIu+m7kEWOW+
	DlFmLbDKplOcot19fHVWtmn0RJYMme8G6qgk54i6AUV6uwUhnkLxdiLTRMjq9v7tjBcffv
	N4PV5yC1nj0jr//qobqX2QagJQro0O8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E386742AF1;
	Mon, 11 May 2026 16:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE7CAC2BCB0;
	Mon, 11 May 2026 16:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778518734;
	bh=O6u/tdsx3GUXSNNLyrJ9hKvN+wQ3uWRAHq+zudrygTc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=IWi4+eNEZjgT9drcZu+/r8N1ndrdAgICycZQz80OUeOEfU15tX7MQDhAQGaKAtuWI
	 F9rROCcdcXGTCrAQGngEPn8azYdMALOotyTB9CDBOj+20BlinGxUuWmdm75BibVUlS
	 ZO0YGA571hSUcD+0/2HHE+xHuewUfsRbm09piUPClIy4PKk3xyOyv+yKdtEMEQct6G
	 G5ARu7xR6huF9EEqpq+foAupdAiWdZbH79bA84UAe1TMuxqh3kdwg2wNTQ6mli44Ke
	 pcsUd4pY8pOLMdqDU8B7GULudJuZ95SLPiYKPw+hl0GGWpXbGzbjDfp2HV1iPoriYn
	 M5dHAcAKSGvUw==
Message-ID: <f9e2664c-8368-42e1-90cd-3804d276bee3@kernel.org>
Date: Mon, 11 May 2026 18:58:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/22] mm: introduce freetype_t
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org,
 rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>,
 derkling@google.com, reijiw@google.com, Will Deacon <will@kernel.org>,
 rientjes@google.com, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
 patrick.roy@linux.dev, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 Andy Lutomirski <luto@kernel.org>, David Kaplan <david.kaplan@amd.com>,
 Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-10-28bf1bd54f41@google.com>
 <016c8bef-57ef-44ef-bf60-86dbfd368dcd@kernel.org>
 <DIG02IRTZEXG.22IYXOVI83DJD@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <DIG02IRTZEXG.22IYXOVI83DJD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CBAD8C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: qy8m7i9z63omfz1uegocc16ajxnz95wy
X-HE-Tag: 1778518735-251128
X-HE-Meta: U2FsdGVkX1/ORd/4gsxlxA/+SlotQXnCd0OXdyHDjlKWqQyVuncMIpgf+y3C3MkomXw8EIiW4krMW4pu8WsloWD6wuaMlqGk0+ENgWZ6NSn7XPG3APKGn7MvSkTI9jyBEfhLxTaRkPcdiK6jwBtK2wkqnlhwUI4K4QWij4WkrPTlhD9y71uanvC5RAANQM3JnwR1AHTdPJcIBu6N7pYRn7MBzZ1g9sLQHSHPql73e9NNwfeeFffi+BM8LEpe1Smy4Szc6V8lvKWWX5Y2SiT9yhbstF32lqWV6IUYykvvZI8K4bxk/VYnTgoE7MhUJ1mmbmJXNAsVlvsEUuUgOl1lPEh/Sp1B4hs3jni/7DWvutE0NkDLSozC2uOWa7I/sDvjqOhbwnpg8HQpUhOJxr0OghN/dIb7RA2ITEzB2QBOvn92sNY8dTAtJCDTB/dATlyI4xtttsodHeSvCfZLI7BD8PuBr5wL3v6BNigeBGevz9xKT2G2m491yp0rtw73cneS6j7mhfiW2S81ls/v8uQ5HbeQsc3TrplE9zubAxmOFjF+MTzxF7xUb88BsshSs+nO+XcIbN/THgN1NZYJQBZwbL9Rzej/GMTVcm3KCPj8mttHqgS6z9YiBPyEwtRmKGmu0n0rDYNAvkTCBOGrU90iNE503pU/ZWx0KUb+Bu9gkH+RUKZWZCATJfuG72Y4gFevHO/h3mfllaBvDHYr1S5oQQov9mVOhTbMlvTRDWCLIfR5iz3+yqE3DbvmYvUa/ibKKb1qy26CinmJjg21QWn3pnYxeDbVDIEREBLFqiwq/DtDQRqdhEXlJUX6YLLmrGbhvrCJC4q478KKiCJo3ox3GNUz2sJQUzPcizv0c0IICqM591p5bBYiVzjl6rcGVuBl9olYHado2gaipodz6VwWL4yopw0ghKZiXfw1DK0qc1m7RCUP0H8Yh09NAf4UtZKN+y+JCMg2tf7n/aeio/d
 8QBlZNNR
 kpsM0oLBKfl1c+VMOyQMrBHTHZw4SXD7d9+Et/+fF8PtyKSCwrPZb8eET/UGqkXYOa9jaXTEaTeSKZoIiXgk9r+r94W8uwFnA4Y/9wCdMOE0cGTV2L5GQQ4siA8BvcOoJb1elfJaGvpKBhPToazWA0N2dNhqeltRNOJ+kw5ZatduXDiDCFdr5zlWt040BYLd86Ab2D7YlqEWuUFnLipr2jae9YeSW3F/5ipO29zRuciypFQDfiAoqMH0sT4WhtXwZ0knTlWnUfbPmhI9tsMmNmt1wsom4hPVJ+6cDygrHHhaslWY2gaLdX1Az8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/11/26 18:49, Brendan Jackman wrote:
> On Mon May 11, 2026 at 3:34 PM UTC, Vlastimil Babka (SUSE) wrote:
>>> +/**
>>> + * __get_pfnblock_freetype - Return the freetype of a pageblock, optionally
>>> + * ignoring the fact that it's currently isolated.
>>> + * @page: The page within the block of interest
>>> + * @pfn: The target page frame number
>>> + * @ignore_iso: If isolated, return the migratetype that the block had before
>>> + *              isolation.
>>> + */
>>> +__always_inline freetype_t
>>
>> 'static' too?
> 
> Yup thanks
> 
>>
>>> +__get_pfnblock_freetype(const struct page *page, unsigned long pfn,
>>> +			bool ignore_iso)
>>> +{
>>> +	int mt = get_pfnblock_migratetype(page, pfn);
>>> +
>>> +	return migrate_to_freetype(mt, 0);
>>> +}
>>> +
>>> +/**
>>> + * get_pfnblock_migratetype - Return the freetype of a pageblock
>>> + * @page: The page within the block of interest
>>> + * @pfn: The target page frame number
>>> + *
>>> + * Return: The freetype of the pageblock
>>> + */
>>> +__always_inline freetype_t
>>
>> And this is declared in a header so the __always_inline is not really
>> applicable?
> 
>> (seems we should fix up get_pfnblock_migratetype too)
> 
> Um, I think  it probably still forces inlining in calls within the same
> translation unit?

True but I don't think we try to do that consciously, seems like it was just
an oversight for get_pfnblock_migratetype, maybe Zi Yan remembers?

> Anyway I am pretty meh about this, I suspect humans and compilers are
> equally bad at making this decision, I was just trying to be consistent
> with the code it's replacing.

True.


