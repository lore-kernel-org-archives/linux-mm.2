Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6682C5CFEB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 14:28:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99D06B0292; Thu, 13 Aug 2026 10:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4AC76B0297; Thu, 13 Aug 2026 10:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987526B0298; Thu, 13 Aug 2026 10:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71A076B0292
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:28:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2E3E401AB
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:28:02 +0000 (UTC)
X-FDA: 85096475604.15.9B7AFB1
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 37027A0003
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 14:27:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=Ji+tqZc8;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786631280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Oi6n+pIbtn2p/PtSVSa90n9gJGnn2kr5BFRe783XBY=;
	b=FrueK5SFJzp+EltS6ECORbPZLP9lY34s5raSjQDJhd4LYErtwZsRwBKZq33+tME5yE57aW
	z+IwL80dprNICnW5e+YgKaBewzuGKHA0PoCtn5qYr40cJ4p4+ywjq6xJmQXk0PANitUR8o
	3ipTmQZLgGqDVO4rULuioebLHY9JR6Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=Ji+tqZc8;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf25.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786631280;
	b=57iAFxYJVqJsjdejLUcK8PkKTsx6xMcYHIqdOiOpAzqw6RtOO5fo9dBrwvkfYSicH/2NNm
	uXP1rXIx3w1kZub5yJDcimLqakHUCxWIIfZpPWWkL/WPiE8jQQhLYT8wU0CB2eCZAqeXko
	YMSI9allMazmNoK5xAHdrWEhFnjkC3o=
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=8Oi6n+pIbtn2p/PtSVSa90n9gJGnn2kr5BFRe783XBY=;
	b=Ji+tqZc89R8Ep1quUgbgA6lMFuqZRkdN8JfDhGM5D+97Cv/uPFb/I0OucCxCjAqpSkySdbHKH
	Ru2frcYgmVVa5SK0B6ojK3E0AmSkKKurO94d5ddFK96FQhD77HtN4n4U1enM+X7rMLi0qGuw9i5
	Z6uNAafHUKSQT+ux0KSbUPQ=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hLSNZ1WP0zJ46dM;
	Thu, 13 Aug 2026 22:26:54 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 80BF54058B;
	Thu, 13 Aug 2026 22:27:52 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 13 Aug 2026 17:27:52 +0300
Message-ID: <c55a94f4-6ad2-4b60-b0ce-bf670dcc2f7b@huawei-partners.com>
Date: Thu, 13 Aug 2026 17:27:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm/damon/core: handle NULL ctx parameter in
 damon_call()
To: SJ Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260813135536.103668-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260813135536.103668-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: mxxckxnnnpk81xwburww3u9gyasq8458
X-Rspamd-Queue-Id: 37027A0003
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1786631279-473197
X-HE-Meta: U2FsdGVkX1+wY2q+s4yIJA05tcvnh6UJqZ97igel3Ng/8K5CzW8Gm0TkgKPtV9covP6r3WLJQO1e+GXl2QgWxn+1cxLllFK5lkznRNGe5pnrByspb52hC7q9xcGyi5VwBymLte/56oEtvTV9mI/IMrFBEA9C17sVFfityOt4e4sKQgpmopahDomSBK2QrhTWc3ndKP3eblbXfPwizJoJ7FU81QruzaNP762KN3JUDFgqXOAQQ1qie8ZH5JiNRN1SNbyoJ6RYu13LHL9Vv/sVyd6nYrZlM0DMObn5Cwql/xv4jpkBRpmXNroxV0Q3S0HuqdEHMGCkNerY3hVOqXimRx2PxW6slsgfPxlcbAeW9cmXBeXOm7/TIXWmPEeFKjnsNYrSVYyIfmn9Wy4LNKGkBB+XoiXN4CK4OTyKkqp0tUmaqGxCOOV9cfDyIuNen2HNyQ28DldG8zqYHNAXNUCGFFtEeKdUgKx/qrBxX/K4E5V4wC3fPlEhmYU+OVijWTylYURDf0kJhPQXTUtCsTy6ppN990kv6Jbv29xp0sxuumpUxPSougeSBCQH3DLVYEzuwZ17JGOVt6S36x5wdBX8NJRdeWE4AMV33b8YlT8uQ3eq1s0aMRQV3kGz5+qenV61A3oomEUh3Xl6qdZeEwLolG3RWIYzldKDbi80gVXV8r/wYEzVc1JBhydB0AtvYrTHgW6K0rA6VGy6WsSqY0Wbzwqa7wy6VwIEL7uoWJEAuqNHuqZeHL1xZZWHcx0ewPSFozID16WveiES5SvJAJDcpipTSBP0lTVunvUqgd2KzpBerTzpnTJcFn1gl9ktsUQ87E2OuGprjM4Ba/ncnVIheH0Qt1nyUHzKh9243W1kbdTmCSG6FncxvdYHOHTJWpSgIdPuP81L5buieUJ4jshLK7wrcN9Rv+oEGDbGd1V6x0sPyUmliD7826BcCWbckUS7tWV88ZMPNhYwZEZAZmd
 cGHDoaKm
 TLDVqudGMNN9irvJAuvsORd5Cfy4IbacZA79ezPexrowj3Pk85YxkTi2mqueZvzIVq02SbUvNAff95K0yqdwiQmlaCgl20aXWx1krriY6960sbYTKyR9+YjFRjA6eEHB6k720x4eGJGvUZrSX9prScTHIjOagpJ6mN/fMW0FyKT1EJJN3v7scY4DPpkOExvl+tRWWR/spsaWHQHfZxLQQS6b4/w+3wdCvd0v6irgSq45GiCUVyQrolCtx7EFO52pp4dMcvbqYpPrZiFVm2fLNeXe0I5oIurGfdiqRjtPbKOKIHSj4cuUFUHG2+jeWMWv8FlkvQIQaS7W4TpvQJaZldAUBTuUy5vLetAS8aqgsJm3jg6CZ/CePO5odakr9U1+IoRRTIUA+VJ+EQsFyIi1z2rjMV/3g8etiFoJAFbpDUg6F/r5Z/ALK/oS1w7m135FZ40Cd/NKVqHD4oMx74sQkKRJ+ply85paD8yet
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/13/2026 4:55 PM, SJ Park wrote:
> Hi Asier,
> 
> 
> Thank you for your review!
> 
> On Thu, 13 Aug 2026 11:33:01 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> Hi SJ,
>>
>> On 8/13/2026 6:49 AM, SJ Park wrote:
>>> When NULL damon_ctx pointer parameter is passed, damon_call() could do
>>> NULL dereference.  The caller is responsible to avoid that.  It is easy
>>> to forget, and there are many damon_call() callers.  Meanwhile,
>>> damon_call() is never meant to be performance critical.  It uses mutex
>>> and completion.  Add the NULL pointer check inside damon_call() so that
>>> callers can pass the parameter without NULL checks.
>>>
>>> Signed-off-by: SJ Park <sj@kernel.org>
>>> ---
>>>  mm/damon/core.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>>> index 92631a36d7b51..5882f9c94c47f 100644
>>> --- a/mm/damon/core.c
>>> +++ b/mm/damon/core.c
>>> @@ -2188,6 +2188,8 @@ int damon_kdamond_pid(struct damon_ctx *ctx)
>>>   */
>>>  int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
>>>  {
>>> +	if (!ctx)
>>> +		return -EINVAL;
>>>  	if (!control->repeat)
>>>  		init_completion(&control->completion);
>>>  	control->canceled = false;
>>
>> I know that this is a minor optimization, but how about moving INIT_LIST_HEAD(&control->list)
>> to right before list_add_tail?
>>
>> It doesn't make sense to initialize the list before checking call_controls_obsolete.
> 
> I agree it might be more efficient.
> 
> I think my intention of the code was to to keep the call_controls_lock critical
> section minimal with access to things that really protected by the mutex.
> Moving the simple initialization should be fine.  As you mentioned, it should
> be minor change.  I'm bit concerned if it will confuse people if the list head
> is also protected by the mutex, though.  What do you think?
Good point, I didn't think about it.

Given that damon_call is not called often, I believe user experience should be
more important than efficiency. Anyway, you have the last word.
> 
>>
>> Maybe this suggestion should go in a different patch.
> 
> I agree.
> 
> Thanks,
> SJ
> 
> [...]

-- 
Asier Gutierrez
Huawei


