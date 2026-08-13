Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B775BC5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 07:16:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C09266B03D4; Thu, 13 Aug 2026 03:16:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBA176B03D5; Thu, 13 Aug 2026 03:16:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA8046B03D6; Thu, 13 Aug 2026 03:16:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 830286B03D4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 03:16:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A53B1A0595
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:16:10 +0000 (UTC)
X-FDA: 85095387300.17.2825426
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4CA091C0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 07:16:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D1BNo2nI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786605368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O3g5nELbAhjnGJBVIqGr20ppxUR47qzdMMu2xC8LPoc=;
	b=ENDeCty5pGzIsnKPwNIavXbXug5T4fxS9j0ZUOkHh3oNOtqw3/D+3rsnYEvArAEvNzFQ3T
	QEYHtsLmu9cba2Ca+8Mq8wsWomvKXntd9+K2Y6J3ltamlUaG1UCdO18BREGUB1V8+cJqeu
	y8xQ+nLD/uah91o40IbkCVNgEjerduY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D1BNo2nI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786605368;
	b=QfjtY8mUgxjl95r9wNP9TB5dskzzGaYJgerv4rofQod/Aa4ig+r4QdNDVJITyjkhas/fY1
	P7Gn8vqzMU4l9V0kU6UTsBdaOr5a4HqfbTiDVYy79fv5dXKQfwnOjPgEtBKzH9GUYbnZ4L
	pY4kIJyLOvGHAy9DjwMG+nE908taZJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E77740949;
	Thu, 13 Aug 2026 07:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481231F000E9;
	Thu, 13 Aug 2026 07:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786605367;
	bh=O3g5nELbAhjnGJBVIqGr20ppxUR47qzdMMu2xC8LPoc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D1BNo2nIV+HSDi6z1y8ym3dnn6NAIFXQbtLF//sD5Lmx5ndOodsV3KsA0k5L87JR2
	 y+DNCHP8ZwUCDsoXDDMYoqo6cmCxgDFigHTtKi90Nm278m/Zca1t5iCxdbcjmvCUCk
	 Nlw9lcmTLscvyjaE5FgiiAHSWdWjUX3SA1Kz6KUd8i/dy56Ug8R5fLqlItTX2XqNyQ
	 ssnWPsMqJiBvJe9eiSViy79F7cWCWLN2ui9Hv737MbT4WZHd8+zGH+egsHt3E2XaZr
	 fGuhzLZy2BZF33uVp9RViDwz18LG29hlxaxNG6qShg9uydfB4iVPIjlBibWISwE0io
	 mvrzvlhcl3eoQ==
Message-ID: <a47d1a57-309b-41a8-845f-7f1313229d0a@kernel.org>
Date: Thu, 13 Aug 2026 09:16:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm.git review status at 7.2-rc7
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <20260811205836.59301ca91b65781c6292a439@linux-foundation.org>
 <6023e19e-32b1-4110-b9ce-5063f7976108@kernel.org>
 <4535a2ca-d145-48b7-aacb-027e9ba258c1@kernel.org>
 <an0F5e6I7OJWTCLa@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <an0F5e6I7OJWTCLa@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CA091C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: f8g95kpf77uqfqxe3ty8c3wzw4wce5pp
X-HE-Tag: 1786605368-491077
X-HE-Meta: U2FsdGVkX1/Df6guouXSdtYVOLQAYdTb/a4ukYKkUOsIpJm5MRv+sonmSZs8HwDa960zZAwRioDaYNPNEEedDgsAoThwjhy0abtgDmgUHVD0+Vzl9aziWFuupjqZwartt/m2AuFER2WfFzp8KpFAZ9AFRDCUZtZhfEmxruDtEahRONm85XsYcC/Uf84F8XNheRNywFsE3hJBIa9ZudM+aWmAXcJ/vkCGCtntdEr4VI3bIKQA/iy4NHM7F8iG58rYInfNKECpvkyV8cZoiveGjAjeDUma/8Mql+8gpvG6xKmWnB+CP1O+ExnsqX3I/PFTUxSFQUO/fOdpfsNQaVvlcV4GE362vZbpo8VSJarqF6cEE7L1NGZZlzfzJhP8ukvDO5SsJewa9jEfbnptXK2Tze8RxYENIxZ5okl1EBZ0x5UTFVBVAm/AqN6Oi6fURsprt943VVvuo/wrjENpT9tesyYCVk0aTkbvSzdPLqjbvu87p2I6GFIvrXLKBGJBSvnT53zFUbMBLm7Wf+cE2MnsQGTrt7Lv/mMM/w4G4sihszbkQrgaf1iczp4ty/P+Zb5guH4VbGy9nf4w88KPlAK1PQwvgo+Tvlogr9OQw1xShFHiA6QDPpsU0LtQ0XKK2qAu3ekrYZWECcb8WJRmdDIw2hRCvqmLyTGuGu6ecHZ+2scdYb5rR7/1TY9kgnJemzs6LG34bgZAjIz6B5R5RhS2WmqNJgwz3M/AjTVOmW4RNcQbCtEdBuAnyRkN573nvQ+1gcmszYPIv0B8mLBlpqjCwvRFRCKpp8X6WpEyME3Jpze9d3tC62m4w1BiD3xhzEbu305uX/wXLnT1JJVXT9mQ4xki0fkl6v+hfLYUkqhCyAjCrCNVWDRJcmjBDaDfLM/pas0tojRxxgqWorwpuAWj+3r3b2ybmVBLG+InpFmX+sPfOahEMtD7MsJvEf5iTP5bYOdAtw+9W9s/qtiXQ7s
 yJ7wZdzY
 iCLhVucPjquN+76zZLyYrEXgGAWmmFFZx7HHQ7UkTSzxXS0FP6cfWJOR4oJu8pu02fbrapMYlyhZZ2zrNpqY73MDk2gRNgyOLct2SpLXeu9fUvGOK+qHoX/4J8WNZsaUa5HGmS0PztuTGOTC7GUhoyvjqNx6u7tbGMj55YLarwQd5KyVD6pFYXI0D85dfu6HTnGYL3ZJgU+kF3XJvzMi1hHloj4hNafYf5YAR9oZCrVDd2wKY4bUkcv8Ay2RM2T7RytoP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/13/26 01:46, Matthew Wilcox wrote:
> On Wed, Aug 12, 2026 at 10:37:13AM +0200, David Hildenbrand (Arm) wrote:
>>> We really need more maple_tree reviewers.
>>>
>>>
>>> I want to review that. I am still not convinced that we really need that right
>>> now. The fix was the important bit.
>>
>> Oh, good, we fast-tracked an unreviewed cleanup as a stable fix upstream.
>>
>> What is happening.
> 
> Meanwhile a well-reviewed series which includes bugfixes is apparently
> not even being considered for this merge window because I spent a lot of
> time figuring out what Sashiko was concerned about?

The bugfixes (especially stable ones) are best sent out separately, or cherry
picked from the series, so they can go in through hotfixes. (I prefer the latter)

-- 
Cheers,

David

