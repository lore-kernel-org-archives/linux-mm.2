Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E690CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 504096B0088; Thu, 18 Jun 2026 09:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B45E6B008A; Thu, 18 Jun 2026 09:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A36C6B008C; Thu, 18 Jun 2026 09:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 11C636B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:09:34 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3DE97A06B5
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:40:41 +0000 (UTC)
X-FDA: 84892689882.01.CF5D3AA
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0619F20006
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:40:36 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="m/5OGJwW";
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781779238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YvJNyjq92QggB+Dsna/lDkH1fsgK3tngrIPitiv4w4w=;
	b=qaiMub8CP2MEuUmbFz3PT/fN0SjqlXUKK4R2OmVXdOibo1Zz8DldYo/K7rzLFNGUMPND4G
	SWeq45apnnbIVXWShcZUtmdpW4Tf2R0NlYAWg9KoHHyHIPlu2vdYXo5XD4y4X2RagbIGJS
	ba5i1XU5RzZjXvXD8mFte/Lvf3JqKJ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="m/5OGJwW";
	spf=pass (imf03.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781779238;
	b=u0nf+OJNpLEy7v/OsZXNJpFUgvhIYvAfJ1VdI+0zZV0ePL81pWLCv/Pc487Q1N/Ya94eeq
	9QTyPehNRcPD7fw5yghiJOt9lG+syTY33viBgPfPwIqBAgTK2UdaP31btg1R9CBmSuMRab
	I+22mTBU9bthKE/BNg6T62l257fKvGA=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=YvJNyjq92QggB+Dsna/lDkH1fsgK3tngrIPitiv4w4w=;
	b=m/5OGJwWKPxhNlqFS3MgoJbmCLHf2bDGu574Prvw1h+oG62gNWT/rpHh1/aWiJ49PUIxMsJvP
	Ao/+c3Vv9QhApClHkEsjQTXdrpnzPMLtTkClIAvoBZgyssawsdTFzzqws+XVl/7owkQisEH/l9Y
	IQl3mqZQsfnpLJzO8pbBF+A=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4ggxq10lWlz12Lcx;
	Thu, 18 Jun 2026 18:31:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 8EB2040569;
	Thu, 18 Jun 2026 18:40:31 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Jun 2026 18:40:30 +0800
Message-ID: <3b5d0b28-742f-4f8e-b709-b3a2348ad653@huawei.com>
Date: Thu, 18 Jun 2026 18:40:29 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove PageTransCompound()
To: <xu.xin16@zte.com.cn>, <david@kernel.org>
CC: <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<chengming.zhou@linux.dev>
References: <20260618180813523lpg_cRMfdaELojCmC8Ap2@zte.com.cn>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20260618180813523lpg_cRMfdaELojCmC8Ap2@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0619F20006
X-Stat-Signature: orhnwfpxzbh6dbt4rot3y4wh591qyj64
X-Rspam-User: 
X-HE-Tag: 1781779236-337276
X-HE-Meta: U2FsdGVkX1+65p5lzKevVpqXola8wlABc1Ugf/UB7fRq41IBULM4u04ODy/l8TJzmh9e927rar40f/gqYhoiRT+WvwsAVpJlcHKfgcwgl6Nw/24joYVky37W1SsGS6ZkSqEv/xzOHj/E78V7lL8QeIoW/N5YcC8NuYnttbsJ1ssX3soS20OdaUCXGhf8vyJLAdQ5r1ttmADBcgws6AFMo9tRSSYortfOphqvs0DqV6O4Ki9J5IUZ5oUGvuUofUMb+Jq51+HARDmOxGt3SxoUdvkc6+ux1gr5/nPuxXYh4XsEA0egAjm7QRGd9a5ia0dd9etqJZxvj2V9ZTavk0h4pRujpdSsnN7JvhGF3yl+5h+xbdpGwn5NgFxrjepf2vDL8ECAjdWoKdDOD2PCQF1ZmQsTZA/KWfeSKcOaidywwbbu9FqOY+p1bvIwDeyYEe/8m/tx+q+J59Atworp7BZEcMoyFmn/uOmhFFmsQac6i7rs9S0MykFXX/nzH0VO7pdGt4WGETKA7k2/qtzMs77d6vO/xmimpVfmJEyeoa32LMtUWAkNvpFeZ28Ec/0+YB2K7kmD11s+Ugs7X1+V/5YS5PNPpzTI2kvAsYFjxZfCav08tpKV64gFCf+WUAeT3Quvzoji90hFdBLGIxPhJlzmjVwqv9cWjOo8KKH1P/zcOsnjEUOjcL5E7QRz56hlWQc90r/YiwgGXzTwBogr8v6k1aFeQN8x7HfFLDXalI2QgPLv790eeIKYXP7l1A1s85j/7dL4iS3/rtSw2heHIQNwJDaCiP6adUb2W80BEqRRnmFdAC4ahs37dLfAResKYvDOYMdcYKdk7DBAR8uE9wzshbqutqR2eU9bcKmCHXs8bSkufCP0kLqOVGySVmxUwEVkg8THAFQ63RnS1uBwMFJx94CtgQskNDp4/vL9lgGJV4MgcC2FPxnx3F5g9O2hCzY+cqMbccqYZOczPx4l7x8
 uAmyOM4l
 uBhvCRLEkaUp2M3MNbc70kxLcIXEepSD6Y5UK3Mq8czb7uobpica/laQAbtXgc2HkkldYKnOu/MC8V3grX8xUyPiaqQOriPmZD2DeZ9xpLa2fWX05lUJT3iLWPaWRL6ntTuVlPuzB/ys7V02ZWJcvMHJU+ZzWJNRCeXeAiBo9LuchcyUrZeHlCcd3x6GtfGjZl4qweI/HYQBISXZq2/peihd7ViFyRss2IEEzt1xyozTQtqsd1d5WJkYX4t2/T9nAMT7ldIXIQciWaiCvXLAYKpc5c8566mRN42wEo+hF0S4kHJBa7lzLHoAkJRiWGCvJcw5GPMc1A2RInH6lnGOvETBoOJJfKF/kwZEks0LOaBY67qMhy7UWF4fcLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/18/2026 6:08 PM, xu.xin16@zte.com.cn wrote:
>> Nice, but ...
>>
>> we already have
>>
>>      struct folio *folio = page_folio(page);
>>
>> And we know that we work on folios.
>>
>> So can't we just work on folios?
> 
> I think this will work.
> 
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 7d5b76478f0b..41ab25aa2a82 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>>          tree_rmap_item =
>>                  unstable_tree_search_insert(rmap_item, page, &tree_page);
>>          if (tree_rmap_item) {
>> +               struct folio *tree_folio;
>>                  bool split;
>>   
>>                  kfolio = try_to_merge_two_pages(rmap_item, page,
>>                                                  tree_rmap_item, tree_page);
>> +               tree_folio = page_folio(tree_page);
>>                  /*
>> -                * If both pages we tried to merge belong to the same compound
>> -                * page, then we actually ended up increasing the reference
>> -                * count of the same compound page twice, and split_huge_page
>> -                * failed.
>> +                * If both pages we tried to merge belong to the same (large)
>> +                * folio, then we actually ended up increasing the reference
>> +                * count of the same folio twice, and split_huge_page failed.
>> +                *
>>                   * Here we set a flag if that happened, and we use it later to
>> -                * try split_huge_page again. Since we call put_page right
>> +                * try split_huge_page again. Since we call folio_put() right
>>                   * afterwards, the reference count will be correct and
>>                   * split_huge_page should succeed.
>>                   */
>> -               split = PageTransCompound(page)
>> -                       && compound_head(page) == compound_head(tree_page);
>> -               put_page(tree_page);
>> +               split = folio == tree_folio;
>> +               folio_put(tree_folio);
>>                  if (kfolio) {
>>                          /*
>>                           * The pages were successfully merged: insert new
>>
>>
>>
>> I'd assume we don't need a check for folio_test_large(). We'd have to double check whether
>> folio is still valid after try_to_merge_two_pages() succeeded, or whether we have to re-fetch it.
> 
> It doesn't matter whether folio is still valid after try_to_merge_two_pages() succeeded, because
> if when try_to_merge_two_pages() succeeded, we don't care the flag 'split'.

Agree, thanks all, I will resend it.


