Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4FFCA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 14:04:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551EA6B0006; Tue,  2 Sep 2025 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5022C8E0013; Tue,  2 Sep 2025 10:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43F638E0001; Tue,  2 Sep 2025 10:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 350E36B0006
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 10:04:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EC830118B7D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:04:19 +0000 (UTC)
X-FDA: 83844479838.21.B135CD5
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 55ACB8001E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 14:04:15 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756821857; a=rsa-sha256;
	cv=none;
	b=KtXxcdpJpIgF39zErpIhBGmy52hpmP4W0U9dFnanoCYI+KsuE4/Pr8siP+OINambvucuBO
	t9mVloollKdEZzuhc0IhJtF8ApL7QpfdHYxYS8wWGvdyGn1iAkBT1BxaCo2KWCVf3wvLW4
	s7SlSOdesZZZjpaGvuCpkMI3GqdFJHQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756821857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kdzL/EwM7llcwpFarbfaz6DrQLIKfLcBCbpQLx031S8=;
	b=jJwgkhfZewNW38zGRpR9K/IKcY/Z1k9q/ozWJdoZU+1uJuWLZfz2Nveiexj2TBpnFERUzR
	m9ke+x6Hd/IIgGp8tODo0THcd/yglPlGBejwjniCIdJlTEsSvCJT97PknDdYCdrMySmxzV
	0DXkeXLJvj+4QGpSa35OejOWVAdOSTs=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cGSBV40fvztTV2;
	Tue,  2 Sep 2025 22:03:14 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 1C2AC180495;
	Tue,  2 Sep 2025 22:04:11 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 22:04:10 +0800
Message-ID: <1c51623c-818c-4135-a9b1-28d0b4edbc89@huawei.com>
Date: Tue, 2 Sep 2025 22:04:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
To: David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>
CC: Jinjiang Tu <tujinjiang@huawei.com>, <fengwei.yin@intel.com>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
 <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
 <aKcdBrq_xwOeUQTp@casper.infradead.org>
 <b990aa82-bc98-4739-89e3-44c96e0117a1@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <b990aa82-bc98-4739-89e3-44c96e0117a1@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 55ACB8001E
X-Stat-Signature: jigqd4cfkjkgntxe46pjeqbzh9g7ssg7
X-Rspam-User: 
X-HE-Tag: 1756821855-324002
X-HE-Meta: U2FsdGVkX186fB7Tnfwip8YXyDp73WPs58HuSKyhafwvTcDxak182tpAo+OET5hc3KP5zQksPUzaNImBfouGd3oW1yQd1wDD01l3Gu+SZePx99qR1oFpl6aQtVD+B8UZ4cG3gJMQBCHr2i1r+vGoMpAKhsoz66t8h+at5t8tc0xI6kcF3QUiuWTjBuWdrvvEX1cdbjNZzKSOXgrgYqA+DEpfSxoKuN0o1CoAq1xssBPqqQ6EdXpFDJNfEXIsjDafD2VglS8fkJ2HUeM7C604ikYbF2VBrURoxcDOcd7w7AciQsEPkIPu0Zc4BjaRnMpOpGJUFeLsoj04MKQxFZh6hTl0rzGyxXktiX8DZXfmoANe0Mc+R132opvvLIie9YXLbHmdZIjvam/xfdjcRdo85v11DajtY3zdSD/eCj3lx578TyLkx9wTeL0/i+zXod+dAF9oDwitcmQeW6oF6HsPwHIR9AXCv4Jr6oEd2QUyXUo8ldy7ncBOaU94SLyvKcMzno0tJdZ8htNF/PwNWwC4pdeh30iX3Or7B+Tz8fIGK2VTIy2fopaAAiE096e2IXjst8XoJxMHWrkDYS01kSh9IRvNmyw96zhf5hYw8vI7lik+sV3E+k9LFNrK0NPo2H1p8WT0DidD+1L6xAmXrwSxBOqMOCNUeqO95pP3cRDPLK0Vg3uF74wrWKnmE1+Iu1yuSeiBDyFPKQ3O9YRp+7j+3qVnfFrHDUscRhS6KLZxkxO6f/L+tKcs6xDnGcS3iD4xVJH8JnF4SaKvQ4EPIbRstLVHLq9eIoFRHr07ml+QehgZemkxrnfBM94kgS31P1Pu9tujCsIuxJXZFxnMh2XcDcPbtRJnWONZ9TT6OmQXMJvnLyABfC9MmLLzL2hiNmheaPG71XbqKZeNeDyuNKT1nHENJB7EU6Yn1+yAxMnoc6bjs+rq1/5sedcQtLOClwOww5vtJmRZw4O5yBo9VjO
 VYSDQ8n5
 hFB4DxM3cNBhUWVzTWSwXnIJW4/fk4/oczyXUcMuWcwMFgJb83shCsEZLdN+8InLlBmvvR4zqL763wHxq8n161VddrhnRt65/kzYMYv5lBgXzxaQaDMs17UDW7JmPVJ7ZLe/D4k8uMPlMkkniavu2JN9rcuUq1OyTADuDstSbN99mWDYaEu6o5rKSs2Dl1uCSWpMtAwMlujXKh9bYiGrzoryjhsqmxAmbSZL/F9G0/26es9a+Th4uK95PdkG2N/42AVMl9zbbMf/D4l/wEuDn3G/tNZ9koDj0ysYS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/21 21:35, David Hildenbrand wrote:
> On 21.08.25 15:20, Matthew Wilcox wrote:
>> On Thu, Aug 21, 2025 at 02:57:54PM +0200, David Hildenbrand wrote:
>>> On 21.08.25 14:45, Matthew Wilcox wrote:
>>>> On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
>>>>> 在 2025/8/20 20:42, Matthew Wilcox 写道:
>>>>>> On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
>>>>>>> We should call folio_unlock() before folio_put(). In 
>>>>>>> filemap_map_order0_folio(),
>>>>>>> if we doesn't set folio into pte, we should unlock and put folio.
>>>>>> I agree that folio_unlock() needs to be called before folio_put().
>>>>>> What I don't understand is why we need to delay folio_unlock() until
>>>>>> right before folio_put().  Can't we leave folio_unlock() where it
>>>>>> currently is and only move the folio_put()?
>>>>>
>>>>> In filemap_map_order0_folio(), assuming the page is hwpoisoned, we 
>>>>> skip set_pte_range(),
>>>>> the folio should be unlocked and put. If we only move folio_put() 
>>>>> to filemap_map_order0_folio(),
>>>>> the folio is unlocked when filemap_map_pages() doesn't hold any 
>>>>> folio refcount.
>>>> Oh, I see.  I misread your patch; sorry about that.
>>>>
>>>> However, it is still safe to move only the folio_put() and not move
>>>> the folio_unlock()!  It's a little subtle, so I'll explain.
>>>>
>>>> We must not free a locked folio.  The page allocator has checks for 
>>>> this
>>>> and will complain (assuming appropriate debug options are enabled).  So
>>>> this sequence:
>>>>
>>>>     folio_put(folio);
>>>>     folio_unlock(folio);
>>>>
>>>> is _generally_ unsafe because the folio_put() might be the last put of
>>>> the refcount which will cause the folio to be freed.  However, if we 
>>>> know
>>>> that the folio has a refcount > 1, it's safe because the folio_put()
>>>> won't free the folio.  We do know that the folio has a refcount >1
>>>> because it's in the page cache, which keeps a refcount on the folio.
>>>> Since we have it locked, we know that truncation will wait for the 
>>>> unlock
>>>> to happen, and truncation will be the last one to put the refcount.
>>>
>>> I agree that it is save, but is it worth it having that subtle detail 
>>> here
>>> instead of just doing unlock+put?
>>>
>>> IOW, what do we gain by doing it differently? :)
>>
>> That was in the initial mail:
>>
>>> With this patch, we can get 8% performance gain for lmbench testcase
>>> 'lat_pagefault -P 1 file', the size of file is 512M.
>>
>> Obviously the exact gains are going to depend on how good your CPU is
>> at doing atomic inc/decs, but reducing the number of atomics is always
>> a good thing.
> 
> Ah, yes, obviously. I misread your mail, assuming you would argue for a 
> further change.
> 

So, Andrew, could you help to pick this up?


