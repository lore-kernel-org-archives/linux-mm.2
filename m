Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C835CCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 06:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A74E16B00AD; Fri, 26 Jun 2026 02:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4CE56B00AF; Fri, 26 Jun 2026 02:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BCA6B00B0; Fri, 26 Jun 2026 02:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 745BE6B00AD
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:28:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE159A03B0
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:28:11 +0000 (UTC)
X-FDA: 84921083982.03.294BA5F
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf24.hostedemail.com (Postfix) with ESMTP id 772E0180002
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 06:28:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="d2VXtxJ/";
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782455290;
	b=1MoB9dDmcmVTGxLSImRjn78620Opg2lpmoWLt4gWXprGuKbudxgD0g+OhXIYY990oZDmOm
	8+7bXECW+aJ8IVyvevu2kRnikMNcZZ8u+CZTqTuXT0jAsXkkx8eM5QBVeRVwq8ms/S6xuQ
	Uvea8RAtundd+ovIzqR/5nd8srVfSMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782455290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5xy3UeQtOde3ibok9i44GRzCeqbo5Q19T26Lwk+n438=;
	b=qzXutu8nBCzPQe/ynbpU8t4IRB/XNMdVG5UeTXHysJXahuJ19dbShCUUzayycGjDMrgraq
	/A6YZ/AdKcNA5gfsgJvlr5Ocx0uHJ9+WevrVIcdlIens4PtGyibf8PEBZZIx/b5Ct2Kzaj
	h8cg9yq/UEZuItWOq/I30BKnpUPSqbo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="d2VXtxJ/";
	spf=pass (imf24.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=5xy3UeQtOde3ibok9i44GRzCeqbo5Q19T26Lwk+n438=;
	b=d2VXtxJ/pV347NldSW0ZbGuS8gmd3vVvzbQ8gNBGEH9uHxOQFZXjXoLJJE13G2MyKoyfmcua8
	3OUWuS3faSrAQIxAm21RkF2doyO4GxohwCKu1QUJYVL2Q7j5dbsQwOG8XyPiJjpHj/BhFTjHUH/
	Nlc7mgu3WL4/sgXrjH+lRdM=
Received: from mail.maildlp.com (unknown [172.19.162.140])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4gmlr54HLvz12LCb;
	Fri, 26 Jun 2026 14:19:17 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id A1B4D203B8;
	Fri, 26 Jun 2026 14:28:03 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 26 Jun
 2026 14:28:02 +0800
Message-ID: <cc9a18a4-6b9d-49b5-a6c9-a45ba561acc3@huawei.com>
Date: Fri, 26 Jun 2026 14:28:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] fs/proc: fix KPF_KSM reported for all anonymous pages
To: <xu.xin16@zte.com.cn>
CC: <akpm@linux-foundation.org>, <ziy@nvidia.com>, <david@kernel.org>,
	<luizcap@redhat.com>, <willy@infradead.org>, <linmiaohe@huawei.com>,
	<svetly.todorov@memverge.com>, <chengming.zhou@linux.dev>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
	<wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260626100902993K04Lc3GM32AnCvCmzGequ@zte.com.cn>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <20260626100902993K04Lc3GM32AnCvCmzGequ@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Stat-Signature: rwrgfuynysmqwhon7mzdp8a1nxabrhrt
X-Rspamd-Queue-Id: 772E0180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782455288-247845
X-HE-Meta: U2FsdGVkX1+s7QsyHPglhpjVeZk/a8j28KFlOSlozBYPAii8l+inFgXR6pNXEUdeE8QLKAnFNDmViQ14UaYJ+CP0fuzpwy+LsdTZz6HC79BJSe0lHXedCoPyJFRdd4xdgEAqULA4Nb2sZ24XzjuMvlMtORCjOvYjsc72wvJ8QP1OGeEktdyRnfI9Ut+1AxHPh3H6tcfdN26I/K5ht7/qz8eemehCTYIi+acfQRRCvXLE1NcOIvZxCO24p9pNtBafKA43p48+03PsnBTHk/2QPzM4mKcokDlPrqB7GvqW7WcRzGyp9UW54EdonM8Q6VkAMS+hFVy9i4VM/c6KXXhVWtywt2H+72Kocuhnwy/wMRkrAi/SuyeNum144GNpAkNwKMM/1wmMI2ATIQ1QB2cByfpNkWktOzXNrDYnOyRRtmRlVfAapk5eRPLzKgHxuiJyszAUHXf7NgtCKjG4OndrRkqUNbr/8Ph5dbdxwz1EFC0vGW1LtsE/tZohNBJU82EvzXBB2f6jNYJJU7swHtHmW8calu9mRGExxfE/oC2vPhrVw/6uPPo0E4dIKhVRX2OFlY2qdXoiDmmap04Kiskv56ETbOch8jk1hahzA3nXX4blAhs9knh59hma8bJ/Mh2UyVCNKw1bFnF1rvmaRvcj+UP+opfIW+cjqv95BXj0wlENe8mB+BUO6ckqh2ml+AyU9zhEXsqMvgFn1to5lHLCY9ncGuf9btH1yiRvf2P+Mc5uTbWVA/9ahZm/+JKtWRSBd+4IF7XJUjwHkkNvi9rOEU/iltv/CeL0q0MR7NSfPkkgkZ938vE4/YWIjIlrMmMonGgllKQSWuA2xY7c2ZLQ+iHoD2lv507fnmkT/cMy11MXxjFPFz3I+jayHUf6OPYJuvISh8y8x8JdG5H8lx/VY7N68OfexZP1OXkxzrRAK/mij6z01aJeJmkM0W8IYvpi3MdO67X+lvRanqABBrr
 mem5dVEy
 T7FKCLIgvafWtUehRtlJAB12468dv+sJWLK+VJo1VRhbrwR1UNuonsmWMXwF/oXoY5gd/NLM9XtHarLKU1g+O86aCltxnYk/dW+WFecK30w4VIRnp+Kj0+XgE33vzjgSPMs/9lahWfaCmTa80ojj6xPGxb5I+46eJBdQEnDJY9jqXtyJsnvwODR+c4S2hPLQ3wyw3YkP8qPSVjRjrQ1T/DnZhCqoUJ7zZxdhN8vkMVpCxIyJEBt8cYUWN/AKJoaD6ZgMY1KlI10snf62Idk6eJGpauuA3s3vAVjJSKv8fBTFQwhRSN+1kZ/+W1WBxl/S+PAW8a/79zDqf+WNpEKwIEedlpar+6F6O3cdUPhSk5P2P+gQQw+LUUyiZ5jbbf3YmRSt9v5wcOGGFhsgsR6ZvNgG7isG1KzN10dgQbJzoDSdJeIJoBF7C7m29wROtvpeC0TwRXMPnvaDq+mgK/oYJ5RbY0F0iW9b822Ct
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/26 10:09, xu.xin16@zte.com.cn 写道:
>> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
>> when KSM is not in use. As a result, tools misclassify all anonymous pages
>> as KSM merged.
>>
>> In stable_page_flags(), if the page is anonymous, then use (mapping &
>> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
>> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
>> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
> "returns true for all nonymous pages."
>
> should %s/nonymous/anonymous ?

Ah, yes

>
>> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>>
>> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>> Changelog in v2:
>>   * use FOLIO_MAPPING_KSM to match explictly instead of use FOLIO_MAPPING_ANON_KSM
>> only.
>>
>>   fs/proc/page.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index f9b2c2c906cd..7d9387143435 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>>           u |= 1 << KPF_MMAP;
>>       if (is_anon) {
>>           u |= 1 << KPF_ANON;
>> -        if (mapping & FOLIO_MAPPING_KSM)
>> +        if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>>               u |= 1 << KPF_KSM;
>>       }
>>   
>> -- 
>> 2.43.0

