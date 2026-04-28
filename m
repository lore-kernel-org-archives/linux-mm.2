Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48CA5FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:09:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13456B008C; Tue, 28 Apr 2026 09:09:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC3E96B0092; Tue, 28 Apr 2026 09:09:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DA616B0093; Tue, 28 Apr 2026 09:09:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC206B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:09:39 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1CBE5C03EF
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:09:39 +0000 (UTC)
X-FDA: 84707996478.01.917E194
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf15.hostedemail.com (Postfix) with ESMTP id 22084A000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:09:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rVCrypK48GiO3JHRTZBgwpbtpNOWzqQSv3/LRtYIj34=;
	b=VzueK7MLdLPxdEx5Hf5tOF1lbu387VcUouJEBUc+10xB39u0y4wA40tJX/ExbEFVZilDFI
	uY3sGM8wpKFV4/NYZgHTAkryDcaK0GormarfDQO8Zw05t4ZJlFA53EWruizvufRz9sxEPo
	bDeLxTk7ozrX2dVTQHhqRAvZk+yI4GA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381777; a=rsa-sha256;
	cv=none;
	b=FMjCweUU94AApHRD4j4WoAHi+0k9ANPcw1Lkw8r9hzoz20EPMj9TGbGMNukCzYNC330rcm
	nzAUcsO/LVCzfIoNcZFpwGtTMp6XYK8b/s05ioAqhS+BKXeHyCUa9yKVaSSeKaDpi7fIU0
	m6NSgdHZzPq3vwsvhwWHAOSq8L5TIgE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf15.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g4gjy05mKzHnGdy;
	Tue, 28 Apr 2026 21:08:54 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D452940571;
	Tue, 28 Apr 2026 21:09:35 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Apr 2026 16:09:35 +0300
Message-ID: <2d2415b3-d7e8-4b8d-aaad-c4fd27eb18f8@huawei-partners.com>
Date: Tue, 28 Apr 2026 16:09:34 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 02/19] mm/damon/core: embed damon_probe objects in
 damon_ctx
To: SeongJae Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260428003559.113178-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260428003559.113178-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Queue-Id: 22084A000E
X-Rspamd-Server: rspam04
X-Stat-Signature: jboueckqojpf3hi67x5uxegadgi1z3ou
X-HE-Tag: 1777381776-811496
X-HE-Meta: U2FsdGVkX1+cSBW+SXLXzthw+DejtrNUD827Hxg46M4N0tfMRNzIpHZU1PhougaM0TM5WhNHc7WuxjBlFS2Ze+QMCGZqaNNZwTqcUqcV3hsTKzbjsCGgmSJjIW6Oiv/l5dm0562ulKv7TDIEIKOWg8y22Ux+a2te5iXU0/hGpINhPBxldDFKgLIiTojCvmxhvYXZnm+4Ipn8Sg0k+YoSLbbD8weZ5NZIBkRW+UAlZVM/zOksVv48kL9aKAyF6zsgueeX3eiZlup65k5QqXfaRNdl0yjYTV8o4i/k5hL7zaftYZUhxyniJ/sBYws2l/AGmYHVMSAsE8ntDkZH7P51o23Yo8CFAHxbBscjSeW5YU8N8nDnYsjw9Rj5yZB5uqfTxg5CTKn1lBk4abv1nzHvCLtbzPM0QyGI8PEJwBfU2JqYih3N9OyRSdrduts2PR+ZVabuzBhi7t2aMqFtbu0D1uNoBcNYR1ZUmvi7kN9PDayXWjLsn0cigcD1r1d6Q6BZyKSyG3UCZ84FlbHMgmLUxXTt3pX3eS8iqI+CwU36bI/fsjN8afJjf5V7UBBSKv6cStallipk4JZ+JexS++guB0sFlxG1BDXD8TShGFTaMHZpUMgPNlIcjTOGDpy8W2wYH7K6UbirCHav5veBuALTYZnuDiJZVzT955zD26po1mt65tcLbq0yauXUgYTFbKpc77PWcvS19wgVWfUTgRxmWKCU4OyCmD9QsqA/yfPsB3lHpLSFZAVOPnY8g5+sP0kgxOianGvASIQzowsiCM+DJaONq36bCeEjXpFgnkPQ9G31G7ph0YckFDM8IQkObD+HiQi5/jnAD6VzhsCo1IGo43W/WOgu75ZEVSIe4ja+t13/nL0DMaR+Tk8vrGMBRPy3RfSOCKAFzLSQcEe9JPpA2gSf0t9+IG+FVeRM/rKp6asH7emvJpPaHeUm+DlIdnrhlgJ9uCc+Y5JdQ6fWf1Q
 sN9wYW4Y
 Mgn/EZFIB0QmZmP+26AJ7/BnXHe9341WoiOB9JN/O/x+DMDGoRCPLHcgwRfs4FEG4DQaNlAeopSnhSZ6eNwkbrIsexVj+fxblFHXiqVvB1OE4qMroh4J6FBEiOSkuEwln1OmjdQGbKC+JnIYL1mLz+UkBjjeWVWIEaDJ5dqw/fEeALojSzREeQT9qCvyOe3SESvK5HrFa+xGuA6i/kgSgkgcuDXV6wySXh4lb/K5YiSDlLTYP8rmJY/xQi/jzp+l5GvGq2RlA7XYkCNZYSUhSgtx3UYsmAqVHYTQcewqmT9bhYxy2/QtYzKH9zcq0oEXIwKRoQ88VDDfAjykA6tvsiwtt1C1iIzMmafi/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/28/2026 3:35 AM, SeongJae Park wrote:
> On Mon, 27 Apr 2026 16:18:14 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>>
>>
>> On 4/26/2026 11:52 PM, SeongJae Park wrote:
>>> Let damon_probe objects be able to be installed on a given damon_ctx, by
>>> adding a linked list header for storing the objects.  Add initialization
>>> and cleanup of the new field with helper functions, too.
>>>
>>> Signed-off-by: SeongJae Park <sj@kernel.org>
> [...]
>>> +static void damon_del_probe(struct damon_probe *p)
>>> +{
>>> +	list_del(&p->list);
>>> +}
>>> +
>>> +static void damon_free_probe(struct damon_probe *p)
>>> +{
>>> +	kfree(p);
>>> +}
>>> +
>>> +static void damon_destroy_probe(struct damon_probe *p)
>>> +{
>>> +	damon_del_probe(p);
>>> +	damon_free_probe(p);
>>
>> Why don't we inline list_del and kfree here instead of calling
>> damon_del/free_probe?
> 
> I want to hide the fact that we are using linked list.  This abstraction also
> makes it easy to control the calling paths of the data structure manipulation.
> Meanwhile, smart enough compilers could inline these if it helps.

I see your point. It make sense.

> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


