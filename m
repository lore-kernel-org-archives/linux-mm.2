Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E71C98318
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 19:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F336B008C; Thu, 24 Sep 2026 15:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340576B0099; Thu, 24 Sep 2026 15:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 208036B009B; Thu, 24 Sep 2026 15:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 060376B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 15:21:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 95FF040459
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:21:10 +0000 (UTC)
X-FDA: 85249623900.06.18D9538
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id B885D4000D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 19:21:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f38RuqRb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790277668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WMAAGZRwKUNMIhAnHmdwYlinnRJBDD/spjkoWxSduck=;
	b=nzigCOJBEdF8tuWeaGXjVx7O3g4n0jsd4j8/2hBUpO3w8DnocZ6cBvlnHvN7L+GvLKlrBu
	G/Aco3FQrmUJCt5wdxXp235V0R/uTnFL8muBMlKxqfnU6YJH+x+PCRcMIBV5T6m8zLPxvd
	XS/d+0BYAJR57ZMn0MW4u2MEOVk85nM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790277668;
	b=z5wbqqp1NIRM6bfar24kTPnVyysWTGnhRxm1XqtanTvb3e/bgBP78CID/nYnTDcwFD1lxq
	64GfGl5eAkdApymzAVczW91VdTYLMk14YZPCjdwYv+USPdABp98OOldxnuTadjfVYjAEGK
	VO2tLW3SlLDU2NRwEVvEaPNeBz8F0Rg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f38RuqRb;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4CA8A6022F;
	Thu, 24 Sep 2026 19:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1759D1F000FF;
	Thu, 24 Sep 2026 19:21:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790277668;
	bh=WMAAGZRwKUNMIhAnHmdwYlinnRJBDD/spjkoWxSduck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f38RuqRb/jrM+Gu/zWGyEm8U1rNgYFWSu/zmUMeOkW75CjJN0V0r8lVTqRQ6O2MjE
	 pVE4GWkkJqIxi0tRj1fuPyDFE6oauN0qrnN0tK7dvPO6UigbDVzzNDUtOiXHd6dpUQ
	 Zynck6PTGpALVUAjh/In0G+ob1p0AjWhqt7GWgvbbIpOtSQX8gheKNvmsSNB+atxPp
	 BlVTBYARoKk+uEsYkYWJGb6uaPmmqvUxcY5R9aJLTSiuZhebK2uQbngYX+xBgY32UH
	 lq4GW3AxC90fT1d6vvnnf3UjFmc4eQMwH/cR0sESMpsUbIpETaK4y9H1voydMNDoKm
	 TPmbIt/gBWkgQ==
Message-ID: <7ae258ae-b694-43f5-8244-688ddd2ec666@kernel.org>
Date: Thu, 24 Sep 2026 21:21:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/15] hugetlb: Use the has_hwpoisoned flag
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jane Chu
 <jane.chu@oracle.com>, linux-mm@kvack.org,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
 linux-fsdevel@vger.kernel.org, Christian Brauner <christian@brauner.io>,
 Jiaqi Yan <jiaqiyan@google.com>, "Gregory Price (Meta)" <gourry@gourry.net>
References: <20260805210557.1118966-1-willy@infradead.org>
 <20260805210557.1118966-9-willy@infradead.org>
 <a51a6236-8881-4479-8f04-39676e0e1f14@kernel.org>
 <an3uN4TAAZ2miXhe@casper.infradead.org>
 <7608c80e-645b-4d07-bba3-ef45ee36fba4@kernel.org>
 <arGidwZQrrWVPAoj@casper.infradead.org>
 <7a23511f-365f-436f-b934-6a520510409c@kernel.org>
 <arQkP2uEzog8ChN0@casper.infradead.org>
 <6121136c-de9d-4577-a30d-f00dbe244e5d@kernel.org>
 <arVxle46OHWjL7Sk@casper.infradead.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arVxle46OHWjL7Sk@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B885D4000D
X-Stat-Signature: 1tdbr8i5ociit9m99gjdg89cbzxu7nzt
X-HE-Tag: 1790277668-263489
X-HE-Meta: U2FsdGVkX1/HMFfv+nH2FIa6J5iqsON8mar4TBa9Q3qHm6V5X5JhPPdLQKh3x7aAofeXxRuOYwHBUVPdtrwVgZuIH4nPSNHojdsyRgPhunA0csuMypl+nbUhz4ZTATSI0VCvOCkaCGlR9s3Yeq3JBqr98t1rho3wAYU7BQY1Ko29AWlCRZvskzTlKmCiugb2EgUb61ixla5rkfLa2M1O/eaKqLJ07LJQ2hloRBIed8QY/m3ndh7MOWqCPOjLJpJFxNk2RZqCALD7vVvgVy6NH/1YOUrJ6f/J8oFO2zjetQ7QKY9OKqXrXaPFj6ka1+PDl7slJEqEyWuaTNilUFjYHUcXkmGQVVXNViKEnjCoEVNEfRJZpodlSlZ0fuxN0zZiypUDEYn9bBt8b6R8wU0py7bvG2GByeaSrObwI5Z85xl4S2oQumwLYlur0Jy+Ko/n/uIHL5C53++kiGk4UpqDpqkpZXLyBfXU6YjxiuUP13gJBp9v/RjSWse8cW9aMCMhE9CEgNZhNTFM9iBq6wHjorx+mJhL35p0Cqk/TYyuSlOND+o9CLVPnW+hxLtkcVMFucyFId+H5BjMWElzOdOyjVtAg2kPr9uhU+u6M2EmapOHO8yOw5ERz9OtBXQe1atdgyhjHFheaYhtXxku98a1yKh0hPD/LacrtXEm8nK8UrU4GEk7X9eL7XDRPA4vHL4HF1GkS2KUo2cWhtKvYWRAaCSZj2ehJv/W4FuHPYe7pTLvYZCMKX4Yxfqc3lHl7oWblB7/itwdwTgV0UXQNnOmhnkFlo3R1s9CkY3zTDrP0vJzXQUTX30roEr4st6MSIJnAbRB3pGokt5UQxg7HzLEClXg0Km7SGe6FFrXEb3A6ecc1w0aWOF7DaU7dToBMz/h9SGbayyT02QDFFmWWLg0j0OTbQ9TIO0HJmLSPWD0Y+Of/oxB2tRQuTAnzRJTInO2Rp7vM9JSdKO+ofGSMRr
 5bN4Zfa9
 OEt4FGWRFbd3/2Bxiq6MBRs/kWA88yX8DhqW0QPwTXEadF8/4OOHrwOxLcaJ62qkjlxgXUcuL44Fd887vQjcYC0WIM7fwL0SvUKfRf6iwvlHpZVZ/8DWdP1PRS7x41qp6lqRTdy4lvFPoy2vu7Ug2CDBWI28g3CJQ7Qhrdku51aQdxJC7o0ceCzRKVVIuKtGqJpXRyprhvmrZXcYpGC+X2gVdKI24ZdSmLd3UUfDe/Mvy1A/oBjh/72hmH77WGCU6M6ZaPjifA/7yLhoqMlJ+AkbxD0NOeTWqfQGND8ZCHbqpXJA9S7d7UsjeCS9of86oQ2d27HXH746C7M82akGOWQQMxFt9ETv8NumzdRx4yA3Ebx8T30Dq85orAIc1TYAE3LO8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 20:53, Matthew Wilcox wrote:
> On Thu, Sep 24, 2026 at 12:32:13PM +0200, David Hildenbrand (Arm) wrote:
>>> Oh, no, it's awful and complicated.  We could strip out the two bugfixes
>>> which are at the start of the series, but why would we want to do that?
>>
>> Andrew usually wants us to separate bugfixes (especially stable ones) from
>> other work. Unless we all agree that they are not urgent and can go in in
>> the next cycle. I assume that's the case here.
> 
> I don't understand that preference, to be honest.  As long as they're
> first in the patch series, they're easy to pick out and don't depend
> on the other patches in the series.

I mean, I agree. However, Andrew tends to fault in the cover letter into the
first patch and tracks them in one unit.

> 
>> I am not convinced about the huge_poison thing though, that originally caught my
>> attention.
>>
>> So trying to understand the race we are trying to solve (that is independent of
>> the original idea of the patch set), I realize that these races are only on some 
>> slow paths we don't particularly care about for performance.
> 
> They are not hot paths, I agree, but they are user-triggerable paths.

You seem to assume that any of the users would be triggerable by unprivileged users?

Remember: you need to operate on arbitrary PFNs without taking proper references.

/proc/kcore? Certainly not.

/proc/kpageflags? Certainly not.

/sys/kernel/debug/hwpoison/unpoison-pfn or any other software poison injection?
Certainly not.

-- 
Cheers,

David

