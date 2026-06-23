Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F865CDB466
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:38:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D24716B0088; Mon, 22 Jun 2026 21:38:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD4EB6B008A; Mon, 22 Jun 2026 21:38:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC5986B008C; Mon, 22 Jun 2026 21:38:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BDD66B0088
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:38:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D766C166BF5
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:38:07 +0000 (UTC)
X-FDA: 84909466614.17.58B4FB6
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf28.hostedemail.com (Postfix) with ESMTP id 454FCC0004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:38:04 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cuCO3gs5;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782178686;
	b=kZl4mky2Vt1oG/u7YlXLR9HEAwBhjcfBBMvxmO60330PXgCjbwmXF39vYmrMPBfYcY+toQ
	DBUY+pS8wwZqiUnCH4fuT2vQL5oLDeNLOoQi7lciSKxuusWFhYYzPZGXo5GUGyXGBrhbD+
	KlIBQe2yrDa7BST7dmkBxxL6gZzZk0I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782178686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1HxnYaFAzm8U5OOXij8ylCTKpYTXv8afbfuywpH9SU=;
	b=jDUJfyV7MQcQUUc3W/5HiR+oovMJ+3Hal4nTQ58I8rQT1njs+ESw4vHq5nlefH51KK9Wfm
	w3DICatsTFIJz7XXNsnkD9BjQJ15v0bNJnq/VeTZq1+lvEil/W/ZDwUslHni2KydvxNvL9
	6i2J8MoAMsbo5C90na5iNLRunIij4SI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=cuCO3gs5;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=G1HxnYaFAzm8U5OOXij8ylCTKpYTXv8afbfuywpH9SU=;
	b=cuCO3gs5UxA6mkL0Q+gGsNlSTLv6cKrzcE8xO7/C3WY0gpCEs8C0Cw82KjiRM9y9swYNSk2DL
	g+LyODIB6By+Gg3gt4triFmGTiOXdO2JUGqfRFP/7g+Hir/3/Ss79wgifEEyQqeOht7DHBoAu9s
	kpQYL2wBOlXN/cMXANpY7zE=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4gknYZ2zmhzKm73;
	Tue, 23 Jun 2026 09:29:54 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E0EE24055B;
	Tue, 23 Jun 2026 09:37:58 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 23 Jun
 2026 09:37:58 +0800
Message-ID: <601fb5dd-18e1-4a6c-bc99-dc2a655240e2@huawei.com>
Date: Tue, 23 Jun 2026 09:37:57 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs/proc: fix KPF_KSM reported for all anonymous pages
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<ziy@nvidia.com>, <luizcap@redhat.com>, <willy@infradead.org>,
	<linmiaohe@huawei.com>, <svetly.todorov@memverge.com>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <linux-fsdevel@vger.kernel.org>,
	<linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260622091539.836531-1-tujinjiang@huawei.com>
 <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <93e9c643-f6fb-4377-ac5a-d91e203ad1a6@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 454FCC0004
X-Rspam-User: 
X-Stat-Signature: 31wr47hrono3ob41fs9xw93r1ptdrkta
X-HE-Tag: 1782178684-963158
X-HE-Meta: U2FsdGVkX18v6w8WfITj7fiwQznJHHdeKggeyKQzJT64rNNrG1iOmAKo/BZUbNC+yTSGHd7UEaybmUHVx0dbIC3TtNjfl1X31xcJUT6rXzG3moIS425LPhODqql5lPm191ugMTMxQ56tlhxTvJ+JUeKzPYHitqBSu8noDB5lskt7ON4gb70KzpMR6526klSOYpwrbMp8CuiJD83sDT1mr2kY+NG1TdANiuO1Y2W8ynxXETidYxY2fG8cqfYJA20RJMsPtDMZu6m2RFgXu+f8PN+A1bRxlJhFLEMqVed8jGXCmaSXttCUIEDPpoqGzwQSINWo7sKxjvaKeDp3QkZhuclY/D8W48drIy+1xCJpV6+tLfIsOmwh3/mIKE6DAJZ5TKRg8/L4pilX1d/Iy+/LryMv4fqqUTCKkzGisXTNKhtOcoltn/6NiD8BseBw2F4hCMypQ574B56d6BrxiijeDlwHcnZZJ2IDGDt5UvCoFE7ypRDqB/LRHTMMaEWjzlap3pIpOe2ErzHYq4euqnj3HbdmlwWKtkqpEaMaQdGx9zLZZSEqLqRHkuVC0BNtDuKCWRDBhwMLc7+NX7yGpnn3ELxdJevVX0twfPAUCOWrXaMaqBL0/JxClu8ztftFiKhSadc7Mv5kuUara9rdQNbrObfzrHo2RImncaUo2ode4VuEjk0+7t/XEBENKrUY1ROfvgO9Kl1c0NvuE1BdGB01JXK+TccqwkRG0xj39SLhyXzR6vrtYRjxQyEEuXyi8XvW2jFoCNfwsQOdwQA1lv6pOWPLrF4sd7IKSOG9fC2lSEBkjI5cZTbkrmteCFXQ29tMxTdKd35dEtT6SgV2/t0y8akbdDxsUIQohraPX5fkYQuqpOW6HLZUOLdx4+LD+cUPNGHJBJXUbAjBnqwjKAoP64gtCDXztSAwjTsFezJv0ZSYwb7j1AqZkFKNOpRQPt6kTtJsuHIDkXdecLWK+hg
 AjNBS4a6
 zNcl0dfIZQiiHkWruqCPddhqiguC3Ly1+CjtREoy2/YGp2hg6vU6qEukV8sYIPiyiQ00O39qIVyisxgtEANsKHPw2EEGja3glvrOL6roOrm4BOf9gxVI08TdH+PZnmgQxzCvbr+x1XFJUZJMlQfowya8MasaRosiPL3sqzn6+at6dTepMwF/85eG1pHbcnV22SSijsPSBVggbFVVfsV9J8b6/4rnOcF7E+qcgbaaY7sVnHoymBBUBcslAzmHTXLtxm1qsxILpEAbul5CyX6QnJ8ii86EX0391dZD4O0uY45Gv+RAFYhvJy2bHbRJjulmmWOtSi3tayHzUV/QWzvATgf9pqlELb9uCtQGsLxZhprAlDumd9SJXAXBrVAQayCQpyNxZAl+95mUkhypQ33zUTXjUDqotCGR6tgHr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/6/22 19:45, David Hildenbrand (Arm) 写道:
> On 6/22/26 11:15, Jinjiang Tu wrote:
>> Reading /proc/kpageflags for any anonymous page returns KPF_KSM set, even
>> when KSM is not in use. As a result, tools misclassify all anonymous pages
>> as KSM merged.
>>
>> In stable_page_flags(), if the page is anonymous, then use (mapping &
>> FOLIO_MAPPING_KSM) check to identify if the anonymous page is KSM page.
>> However, FOLIO_MAPPING_KSM is FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM,
>> (mapping & FOLIO_MAPPING_KSM) check returns true for all nonymous pages.
>>
>> To fix it, use FOLIO_MAPPING_ANON_KSM instead.
>>
>> Fixes: dee3d0bef2b0 ("proc: rewrite stable_page_flags()")
> Right,
>
> #define PAGE_MAPPING_KSM       (PAGE_MAPPING_ANON | PAGE_MAPPING_ANON_KSM)
>
> Which we later renamed to FOLIO_MAPPING_KSM.
>
>
> Before switching to manual flag checks, PageKsm() translated to folio_test_ksm()
> that checked whether the values actually matched:
>
> ((unsigned long)folio->mapping & PAGE_MAPPING_FLAGS) == PAGE_MAPPING_KSM;
>
>
> This only affects /proc/kpageflags (well, and hwpoison inject on a weird testing
> interface), so it's not really that relevant for real workloads (debugging and
> testing).
>
> So not sure whether we should CC:stable. Likely not.

/proc/kpageflags is generally used only for analysis and is unlikely to be
used in production environments. I found this issue due to I was analyzing
pfns allocated by which stacks are KSM-merged. So I think it's unnecessary
to CC:stable.

>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   fs/proc/page.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/proc/page.c b/fs/proc/page.c
>> index f9b2c2c906cd..cef8ded97610 100644
>> --- a/fs/proc/page.c
>> +++ b/fs/proc/page.c
>> @@ -173,7 +173,7 @@ u64 stable_page_flags(const struct page *page)
>>   		u |= 1 << KPF_MMAP;
>>   	if (is_anon) {
>>   		u |= 1 << KPF_ANON;
>> -		if (mapping & FOLIO_MAPPING_KSM)
>> +		if (mapping & FOLIO_MAPPING_ANON_KSM)
>
> Wonder whether we should just do
>
> 		if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
>
> To match what we have in folio_test_ksm.
>
> (although I doubt we would reuse this flag for other purposes, likely
> it's more future proof to check it like that)

Both are ok. The following check has checked FOLIO_MAPPING_ANON,

	if (is_anon) {
		if (mapping & FOLIO_MAPPING_ANON_KSM)
	}

So it's equivalent to do
	if ((mapping & FOLIO_MAPPING_FLAGS) == FOLIO_MAPPING_KSM)
or
	if (mapping & FOLIO_MAPPING_ANON_KSM)

>

