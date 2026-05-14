Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 231ACCD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:34:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5096B0088; Wed, 13 May 2026 22:34:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B96066B008A; Wed, 13 May 2026 22:34:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AABA26B008C; Wed, 13 May 2026 22:34:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2D16B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:34:37 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41BA8A018A
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:34:37 +0000 (UTC)
X-FDA: 84764456994.05.BB3AD8B
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf09.hostedemail.com (Postfix) with ESMTP id 17A2314000F
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:34:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PvRk2BIN;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778726075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=boc/tXm2SaLDDUgOlirebYOcZ1PigGu0D7lf30tmB0s=;
	b=PoHeuK6kHuvxDbsDedRjFmH9nMfIYvxKiyAogHhUYQvN6JEcLUKG75hg3wsxXWtVj3WWNb
	1XtYc3e1Cw4EdK+740ayGGyCb2xuKrBtp3eFDpqFiQO38Ksu/i8fw2rtajfLeBsPoxuOQ1
	+95r6Z4z9Uvx17mYL64ULrGNYfbveys=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778726075; a=rsa-sha256;
	cv=none;
	b=Apc/jGNh70BKsqkgwhDArLhG42QcY6eUha6BoX8x4LCVcA7RuYg7BVad4T5EL6T3JeWN8E
	GJSWgTUashUYaDpGpGVTH2FAIO7Y+FVXZfeHPB6hm3hIr9yZjD7sbDTYW942ob8OMAExLW
	At5NFuE4iPP3IlB6ANcBsihh8eTrAII=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=PvRk2BIN;
	spf=pass (imf09.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=boc/tXm2SaLDDUgOlirebYOcZ1PigGu0D7lf30tmB0s=;
	b=PvRk2BINp9atYeg2WEmXPi+ds83uDczKFcS1KT3SFbhVxVviESY7jkHKoSxeo6VO4/7TQvjNk
	KJbriMyOU2DR78iaTHo9aolNg9J6vL0CbzBPsXXnw/n9MZmIFYUDmhYWXWLUaCjEvhqIVwb/RtW
	RMeGoBNtcxN+u3qpaoAbiA4=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gGDk30W26zcbP4;
	Thu, 14 May 2026 10:27:07 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id AC4114048F;
	Thu, 14 May 2026 10:34:29 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 May 2026 10:34:29 +0800
Received: from [10.173.124.160] (10.173.124.160) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 14 May 2026 10:34:28 +0800
Subject: Re: [RESEND PATCH] mm/memory_failure: use bool for hugetlb indicator
 in try_memory_failure_hugetlb
To: Oscar Salvador <osalvador@suse.de>, Ye Liu <ye.liu@linux.dev>
CC: Andrew Morton <akpm@linux-foundation.org>, Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260513024853.65566-1-ye.liu@linux.dev>
 <agPx2woN458Co5Us@localhost.localdomain>
 <fe1f36ac-84f1-4557-9411-41497737224d@linux.dev>
 <agQ4cAK-QOvy0otT@localhost.localdomain>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <f2154751-03de-bf9d-b25c-d9b7458cc084@huawei.com>
Date: Thu, 14 May 2026 10:34:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <agQ4cAK-QOvy0otT@localhost.localdomain>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.173.124.160]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 17A2314000F
X-Rspam-User: 
X-Stat-Signature: y45774ru4761dct7t76hgkgoz468499x
X-HE-Tag: 1778726073-878436
X-HE-Meta: U2FsdGVkX18Y8ZnjAyo5XNEHwCmyNIfhs96+rAfj33XZQlTrdpFJEKqRXv6wYy6pmZhhtFunV7VvzzYvo2l9UOe2T9kBBkSuJCTTu/PoQf55D3OwjIJGk6Hivb6NfFwm6gDNK3/cIfAxGyIIhu1L+5JIqVtZntb1GLpFUsnRFdsiDyUlAfHxLY86GOGHdM0zkvLd0Etzl8x+ywA1lA+CBL0JRtUcKTSzA91y3Jj3kQrccfdOrdBzsUZVFMHv8bBIRXztaZex/kppVpLOrmL7vK80ZX3vaUJW0xjz+7GAVNWqTYKKMhWUOie+ohJIySPSCXregG85H0URv7QoHDy3sicxK9IZUdLL8kXWMo7Kdq/HrHDnof/Mrlij7Ffz3I0pPEV1XylcOjTVJeFDC0cpZjZLY4aRd2i9gufgQjmyArgn/MqW4DPwq5G8P8/tWDRVSLiGBLYzTddJVGnxNFtkJt3OKeDY8Nt6ZXDcagNqiSprZ1yDzDt8OiygiHd42l+TVha4iyacZ0zpCTmz0ywAgfuhxFb9AjAMdr5kmbpXdp2jzo33s68zj7V9z9WBcVkuIzUMzSahY61+/unL7D0imzarpeKI9Gj45SRYH4VCfac12tkdJ9SH7/0Fag/SFFRL7XgFK3ofdugT9O+wP61WLiyB+6xNcaIjZdg3ckQlh1JJUUNi0RPUVudPqLfm9ljsZGE+GAuyLpZ2hhzg8ok0DFw1MUF+k1lo8u6l9sNdHfvF4GBrvTeh5xBYt8vGLQG0Q5pROHGaZv2sG9zK9huzKedLQknIzKO5MmdzDIokGLNdI5gSvSVtwFCQWlapa9vcHxfHYJovaXO64iTTBuInzHg7/GaIFz2719QnqpAHakt8YD3QxznBeyzAq1OFmSdx6mOuqLoT+Ge+Z4hsymSOPcB8r5WlNJZuX8rdIEiGmPnR57/6sDcv4X6YjOHFvl3W9HBHxPRZFbKPAblZXz4
 S5jZXbNU
 gEe1UZtZGwd3UvAH7Ji0fD6xMiMcgGytg650p+b4ejw9zqADpdllBaAxz1EEbyvptX1bKvs9HdNBx4/P7I74YV/YZEtGWHZAELh3ofO+zpjpVxgbtdY3GS5jJb7mIM4RXwQVKzGS0A46/ZkiKThRwa9X3WBZUw8dEEEUCeoSq7NaBllXdXGlGCjuWknKi581fCiFW9CvTmNsQ8GRwIv9pKXixbEhFshjwfCFeTuDG8EHA8gUODJdwx8DgLo9m+EndfX9Z9MpzPd+UE8TuaOviQV3c5Kf5bOdLNCGzhkjZJuj5tinzbbdG2pgq3FFnVGMr582lgf8THcCfckSk1vYTyQen/oFetCYO8aX+g0dA/7SBFtbkH16dtNQwWmz++4DoFJjOz79r35tju1w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/5/13 16:38, Oscar Salvador wrote:
> On Wed, May 13, 2026 at 02:50:56PM +0800, Ye Liu wrote:
>>>  -static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags, int *hugetlb)
>>>  +static inline int try_memory_failure_hugetlb(unsigned long pfn, int flags)
>>>   {
>>>          return 0;
>>>   }
>>>  @@ -2386,8 +2385,11 @@ int memory_failure(unsigned long pfn, int flags)
>>>          }
>>>  
>>>   try_again:
>>>  -       res = try_memory_failure_hugetlb(pfn, flags, &hugetlb);
>>>  -       if (hugetlb)
>>>  +       res = try_memory_failure_hugetlb(pfn, flags);
>>>  +       /*
>>>  +        * -ENOENT means the page we found is not hugetlb, so proceed with normal page handling
>>>  +        */
>>>  +       if (res != -ENOENT)
>>>                  goto unlock_mutex;
>>>  
>>>          if (TestSetPageHWPoison(p)) {
>>>
>>>
>>
>>
>> Hi Oscar,
>>
>> Good point.  Using -ENOENT to distinguish "not a hugetlb page" from
>> "hugetlb handled" is indeed cleaner than carrying an extra output
>> parameter.
>>
>> One thing to note: the #else stub when CONFIG_HUGETLB_PAGE is not set
>> currently does:
>>
>>     return 0;
>>
>> which with your change would mean "hugetlb handled, skip normal path"
>> instead of the intended "not hugetlb, proceed with normal handling".
>> It should be changed to:
>>
>>     return -ENOENT;
> 
> Right, let us see if Miaohe sees any issue with that approach.

This should work for me. Thanks both.


