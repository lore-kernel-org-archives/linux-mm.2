Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6006D72355
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 08:59:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21A176B0474; Fri, 23 Jan 2026 03:59:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DA146B0476; Fri, 23 Jan 2026 03:59:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12EF56B0477; Fri, 23 Jan 2026 03:59:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1F0E6B0474
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 03:59:26 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B41FB52D60
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:59:26 +0000 (UTC)
X-FDA: 84362629932.25.455BE92
Received: from zg8tmtyylji0my4xnjqumte4.icoremail.net (zg8tmtyylji0my4xnjqumte4.icoremail.net [162.243.164.118])
	by imf26.hostedemail.com (Postfix) with ESMTP id 57B5E140009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 08:59:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769158765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mNDdidm6tinVhHByr2zJoD9S2kdicahCGqDIgOC7Rhg=;
	b=YuwcdTC4tROwRqKaTxnPXdGN7B/1Qnj6qDi3Uzuk6VSsnv24G5UfNs9L2kbiXCfLOdAlSp
	0F4eYdU7sd1fal+LJ98DVERJRc7DfJ8TPi4bFC1rvIMcY/thkycEadnhROqfXO3+mTbLte
	xO1nxa/8nEITg9s8EhvUjS0DovPjmng=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of cuichao1753@phytium.com.cn designates 162.243.164.118 as permitted sender) smtp.mailfrom=cuichao1753@phytium.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769158765; a=rsa-sha256;
	cv=none;
	b=1+iq33oyxeKeOMzpOBE+7rWaNvPEW7+I6c/U/Sa5wqNUKrbkqK19Ak3AksG11uolCr4UNb
	Cl7EruGkpBWiilfvZ+e+4lLW8ImqNqyQ/P2L0iGBIlIHn2DIcDRQzDN20geDX4mBS0M3vl
	Qs9NY2WxEzrU+CsgOjDM9LIy+pkaj9w=
Received: from prodtpl.icoremail.net (unknown [10.12.1.20])
	by hzbj-icmmx-7 (Coremail) with SMTP id AQAAfwD3_mJpOHNpwMQ7Bg--.591S2;
	Fri, 23 Jan 2026 16:59:21 +0800 (CST)
Received: from [10.22.77.56] (unknown [123.150.8.50])
	by mail (Coremail) with SMTP id AQAAfwCH3eplOHNpQ_cVAA--.23981S2;
	Fri, 23 Jan 2026 16:59:17 +0800 (CST)
Message-ID: <7b3e1f2d-7a6b-43c4-bab8-cb34d2d57991@phytium.com.cn>
Date: Fri, 23 Jan 2026 16:59:17 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: numa_memblks: Identify the accurate NUMA ID of
 CFMW
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dan.j.williams@intel.com, Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Mike Rapoport <rppt@kernel.org>, Wang Yinfeng <wangyinfeng@phytium.com.cn>,
 linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260106031042.1606729-1-cuichao1753@phytium.com.cn>
 <20260106031042.1606729-2-cuichao1753@phytium.com.cn>
 <20260108094812.8757ce3ad8370668eaafb29c@linux-foundation.org>
 <9132054c-3017-4af0-84e0-e4359b0794a6@phytium.com.cn>
 <20260115101858.85fd7b8e837c1c92a4fdc5f0@linux-foundation.org>
 <696944eca1837_34d2a10056@dwillia2-mobl4.notmuch>
 <2d1e23ad-7ec1-483b-88b3-70ce19b69106@phytium.com.cn>
 <20260122132807.7204b83e97e33290f6eb7d82@linux-foundation.org>
From: Cui Chao <cuichao1753@phytium.com.cn>
In-Reply-To: <20260122132807.7204b83e97e33290f6eb7d82@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:AQAAfwCH3eplOHNpQ_cVAA--.23981S2
X-CM-SenderInfo: pfxlux1drrlkut6sx5pwlxzhxfrphubq/1tbiAQAEAGlyhIsEfwAAsq
X-Coremail-Antispam: 1Uk129KBjvJXoW7Zw1kWr45Xw47CFy5uw1UGFg_yoW8Aw13pa
	y8Ka9YkFW5Gr1Syws2vw40qrWj9rs7GFyrXw15GryfA3s8Zr1ftr4xKFZ093WDWw4fJ342
	q3WUXrW5tFW5ZaDanT9S1TB71UUUUUDqnTZGkaVYY2UrUUUUj1kv1TuYvTs0mT0YCTnIWj
	DUYxn0WfASr-VFAU7a7-sFnT9fnUUIcSsGvfJ3UbIYCTnIWIevJa73UjIFyTuYvj4RJUUU
	UUUUU
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 57B5E140009
X-Stat-Signature: uj5juwm19ni7g3n5hkfmjjykr863wa9p
X-Rspam-User: 
X-HE-Tag: 1769158764-363527
X-HE-Meta: U2FsdGVkX1+aNarOhkQBZhcxigG8HU2f2xTUmYYcan5IfVlISrD4Iei3a4VWIdi0HtNw45GE7i8wTO46oTzKeXphmm0ltRaZ6ZkaFE8i3x7npvwDtXZowZg2UApDeCphAoZhFGMyPB3adWNqW6JXa8FKrx/DAFkRurARnu9GP+LUcqG4q3wqayof0pEeaPla8dRt/R98WUrCgDxCjedglyPFA9R47Zi3fLerc1xSzmxi3JjMQmdHQ/EE9fblcfbn3q9s8by6wEQc3xovOyXHaUuSAQlZp+PGARwdzsZMZZVhBDE6YJdm1SphFduQsUp65/95IsCrBgXRFuuoXf1906o+XgBQiWmhFe5ii1mj4I10ovOu9TaBmCuoVNQqY47H+0m9NiUqmIELC5sisIAa6SOnhSPVZskHVF4Hkvnxy0ChOWTsWW+9J6WJbcWmJpxOik2D+jyrhzQdAKBzU7S7uk9PP9JPzIQ4hDwxf3pPOJo3ojHwdnl+AZgSTRzsl2J93mhrfOfYw6426x8Tav7YZdTQUy14oeXAU/jN2z3B0/0w7YVUEWQGZHazcS4op8yrpRTM0vE0U2QjFHm/jeczXxKP5awri7ldJqxWhVXwe3yHWT6KtbhPOMR+/ME0vY1rgnrKXraD7DEfZDzJlkkkENOjpnPh0gn+f5wgFM0rI85Hd4B4olWXHzc7ZwEi5tmuxJsDdHG/MZwLr14oRvliEYfM8DaUjwquqFmUkhRSK4MPb+YViXe6DrAvN6XC9/9BRdQ0jVjJo15azBOuiUAG9D++WUpmvVJM/Was1S35RewzPNiJ8RkafbwY1TopMP7HhcD7D/ctoPkAw29QvAyjhOB043A4iCL8fBBF2JsD4UP2tsIo4k10Mod8g3qpLKIIGlk47SpVROR/02c58VogT52qb8C4jDAeWjWInffv/e7Z94Arr1eZU4rEp/6sodeUOLeuQPC+0Rwcwhk3Pe5
 QFlVb6mr
 uhcey1/p1r02HRjSFzGMsqdB8vD8blAOCBceXzC7PVyC2ydXiBN++2QH5D44CZ6Yo2gELEmmSTsqCkkTLMhePrWwXHvuwm9eDC5E04WG/IubeU6xgrwQXnB3tHczhJcVRVhe0VSFClLWYTHSDPEi+6BOm55fb/Zom+I1oDXwSQ8GEhdY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 1/23/2026 5:28 AM, Andrew Morton wrote:
> On Thu, 22 Jan 2026 16:03:49 +0800 Cui Chao <cuichao1753@phytium.com.cn> wrote:
>
>>>> So please, tell us how much our users are hurting from this and please
>>>> make a recommendation on the backporting decision.
>>>>
>>> To add on here, Cui, please describe which shipping hardware platforms
>>> in the wild create physical address maps like this. For example, if this
>>> is something that only occurs in QEMU configurations or similar, then
>>> the urgency is low and it is debatable if Linux should even worry about
>>> fixing it.
>>>
>>> I know that x86 platforms typically do not do this. It is also
>>> within the realm of possibility for platform firmware to fix. So in
>>> addition to platform impact please also clarify why folks can not just
>>> ask for a firmware update to get this fixed without updating their
>>> kernel.
>> Andrew, Dan, thank you for your review.
>>
>> 1.Issue Impact and Backport Recommendation:
>>
>> ...
>>
>> Thus, I believe a kernel fix is necessary.
> Thanks, I posted all that into the changelog.
>
>> Therefore, I recommend backporting this patch to all stable kernel
>> series that support dynamic CXL region creation.
> It's helpful if we can tell -stable maintainers which kernel versions
> "support dynamic CXL region creation".  We communicate that by
> providing a Fixes: tag in the changelog.  Are you able to help identify
> a suitable commit for this?
Although the modified code is not in this commit, it is possible that 
since the beginning of support for dynamically creating CXL memory 
regions, this physical address layout and the issue of incorrect NUMA ID 
assignment needed to be considered and resolved.

Fixes: 779dd20cfb56 ("cxl/region: Add region creation support")

-- 
Best regards,
Cui Chao.


