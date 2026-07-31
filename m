Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C2A0EC55167
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 09:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBE4F6B0088; Fri, 31 Jul 2026 05:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6F4C6B0096; Fri, 31 Jul 2026 05:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5DFD6B0098; Fri, 31 Jul 2026 05:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB2C6B0088
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 05:24:38 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F28911A0374
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:24:37 +0000 (UTC)
X-FDA: 85048536594.20.A190429
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf22.hostedemail.com (Postfix) with ESMTP id 34F4BC0002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:24:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bbF1xHMj;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785489876;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fMy1bKNlmKm92iiMqIZc2gaIjdmgUkv45tpOPxAofmE=;
	b=SB6Z27XxUp5nAbaDfTEoSg+ZXjWFv1JLepyMjILmqEDhd+R8HgTJpXuGrtuAGc4fQ+yMnA
	1ptfMWA9oxHvRpVvc6kSHEQnaAcPEzUjdxYleyi4q1sCFqG8r6rlSHdXOQcFOgvpdOZY10
	CmBVFlWwJ24O1ICBqZWU+P+q5jsKk7w=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bbF1xHMj;
	spf=pass (imf22.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785489876;
	b=4KFcYRVBHAg3Uc3172XmAsev7vbBdcbOgASSFWEzTEb8iqbfb16QydUskWchkuF2FAqfpG
	DlBxcc0n2+BIebhZN1Tj/lf+qpmI0yRCwORG/Qxjzwu3P6+QTIJKzb9ysWaBmUXhVKPPoD
	HOSvPt7HDPJKP214nKepBIGwqLFN8As=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fMy1bKNlmKm92iiMqIZc2gaIjdmgUkv45tpOPxAofmE=;
	b=bbF1xHMjNwJo08H1DndeJBncdYtUkRgor62rhqgyyl3/t1whuzxJ9s27VT5konMiyilo9k0Lo
	P7UW0LRbKZvtJgmYIK2+Z9myCjidUNWi7c3plJCX1TKwUfa+7PwS+jwpk5R4IwLR7T71qVmRS72
	VtQNh/dTCxBS8aIcf5sGGzE=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4hBL4b4mr4zLlTg;
	Fri, 31 Jul 2026 17:14:55 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id E287540565;
	Fri, 31 Jul 2026 17:24:23 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 31 Jul
 2026 17:24:22 +0800
Message-ID: <46e3002b-3c1b-48f3-b4cf-88b9725fa07e@huawei.com>
Date: Fri, 31 Jul 2026 17:24:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/ksm: fix advisor_min_pages_to_scan description
To: "David Hildenbrand (Arm)" <david@kernel.org>, <akpm@linux-foundation.org>,
	<xu.xin16@zte.com.cn>, <chengming.zhou@linux.dev>, <ljs@kernel.org>,
	<liam@infradead.org>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <shr@devkernel.io>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <sunnanyong@huawei.com>
References: <20260731083526.3953421-1-tujinjiang@huawei.com>
 <20260731083526.3953421-3-tujinjiang@huawei.com>
 <33b55954-71e7-4e8d-868a-0440c1b28ae8@kernel.org>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <33b55954-71e7-4e8d-868a-0440c1b28ae8@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 34F4BC0002
X-Rspam-User: 
X-Stat-Signature: b9begy54hxrcu9pnsk3nrbibo5ezbkfs
X-Rspamd-Server: rspam04
X-HE-Tag: 1785489875-590039
X-HE-Meta: U2FsdGVkX18MOcW+4wVArllmzyOHtej2CJZkAgDYhXkYdM/+YaxbS9UU2RF9a+JerYUdKz2j+A32BjuIP1UgB3Zm1Ebd24KJXg1ZcdNPcXVs6Q/wm9o0a3d5/TanKEmLAbzkGoLXUMYSMFsEXyHswhWgV9S0UmoC2jA5NORfg3bch28iQRq8A/HHyhcK1hMTxawdCakf6zx4v0tHYAA79fTwkwnDZ/vSj3RgcdBJMll5Nr2IhAzSKCi/J7yvwE3rN6nAzzctZVC0sB6DOenyCEnSuWPPa3DvvmH+0qnkNmXj63GzXe40kXKCb+9ki5oxrqbKBYrr8MGAIFMBgWkGXeEDzcwkTkqvsp0xwUxt8qnSCq7ZQ0vpW7SmU+aUPnVjGBDE1a/O535YubitqvkobOBN234OcV0bThVmZS5ZreTDAxyqxIBTYAb18OIEsNq5dR6ULMq9B4zKmpPCLHivlBHGxkkDJLGkMg5c4EzLYugWD8/IhtBKH+7bzv5IvLYoK/Wla4M9FEa5G3puEgprbh/D5pAQJYVFD1rPsP0AbEzp/JdOkkT8n+28lC5nmhU1YlAbL3xL0CfCxQ8Ty1uO0DUbfECeyx4kKg+qjEqYhkL8pj0xHLcgCge/stGOvUD83thNwWuW0B5CVKB2bVJ1KgjScZvg/5hKI5pDXLzViVvo48tCPRcENnx+XW+x3QpChA9Vh9SDM90n3lLlmnbY/urw1jYsDOe0D/6wttMtdA9PKpSs9o7OdAXFy2C7loJCP2FQSBiYtmIyTtYR7U5L4anNgUiOcljrWlYiZia8qWgNQW22LbAYV3tMVlDuXhMw9jl+MI0xa9+muU73qO9+1UaO+uGVDB4lU7jRYZqBkCSir9osrN2SjpVM6lPoEqguocj7YhavBRRe0kmYjp91HO5BvSy8Ats7PPbLifPcOv/QQOo7J0WBLgS8BOj6T50A6XEDSLnivWFgGsCHMmK
 OSufJJvD
 Wf65EJqsRsny7bmx4xvrdAy1UmVHc29rFylPT51yNrDAgEz75IrkAZcvPysdxJHPDgLHyuWYTHWja7Zo0l0aTT4cqVfFwy85dtOdZ5CkNlf3/ZhQLMxxQs0ZeUplsxst3S+vt2d/uj26NusywVs5ViLm7VvE6lXcGdCBtKj/QtJ8Pl3ubqOgk0eAT3kO4DRJMSvMCVKFn8pM+RWkUwB1dKERfNsdr9xdDasXILWEK6IbH+WJttLAx4syM1uCs19zFujzcA+p+JpCTr3VCF6gGaLqfnwJ3zcO77I+oPkEG7KpllmRl8Sbmiuq3Hb0+mmeiEDMFujUHfxIRS5MWLDP+hQ9NCdGu7kTGpck2PS+NZcGOqP/y/otC+4t8hKLOc6BmajbLtMMb5zX4tBoz9Sb1kRJWp73T3qgKwOrCdh2Ykk7lk9/2umXH+V2IDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/7/31 17:17, David Hildenbrand (Arm) 写道:
> On 7/31/26 10:35, Jinjiang Tu wrote:
>> Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
>> variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
>> lower limit of the pages_to_scan parameter, but that is not how the
>> scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
>> advisor") only uses it to initialize ksm_thread_pages_to_scan when the
>> scan-time advisor is enabled. This will mislead the users.
>>
>> The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
>> [1], but the documention wasn't updated.
> s/documention/documentation/
>
>> Update the documentation and comment to match the semantics of
>> advisor_min_pages_to_scan.
>>
>> Link: https://lore.kernel.org/linux-mm/20231028000945.2428830-2-shr@devkernel.io/ [1]
>> Fixes: 0710f38ad26a ("mm/ksm: document ksm advisor and its sysfs knobs")
>> Fixes: 66790e9a735b ("mm/ksm: add sysfs knobs for advisor")
> Drop these.
>
>> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
>> ---
>>   Documentation/admin-guide/mm/ksm.rst | 4 ++--
>>   mm/ksm.c                             | 2 +-
>>   2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
>> index c9f533b10f6f..c329ca747b8c 100644
>> --- a/Documentation/admin-guide/mm/ksm.rst
>> +++ b/Documentation/admin-guide/mm/ksm.rst
>> @@ -183,8 +183,8 @@ advisor_target_scan_time
>>           pages. The default value is 200 seconds.
>>   
>>   advisor_min_pages_to_scan
>> -        specifies the lower limit of the ``pages_to_scan`` parameter of the
>> -        scan time advisor. The default is 500.
>> +        specifies the initial value of the ``pages_to_scan`` parameter of
>> +        the scan time advisor. The default is 500.
> Makes sense.
>
>>   
>>   advisor_max_pages_to_scan
>>           specifies the upper limit of the ``pages_to_scan`` parameter of the
>> diff --git a/mm/ksm.c b/mm/ksm.c
>> index 7d5b76478f0b..1e3a9c657a64 100644
>> --- a/mm/ksm.c
>> +++ b/mm/ksm.c
>> @@ -342,7 +342,7 @@ static enum ksm_advisor_type ksm_advisor;
>>    * Only called through the sysfs control interface:
>>    */
>>   
>> -/* At least scan this many pages per batch. */
>> +/* Initial number of pages to scan per batch when the scan-time advisor is enabled. */
>>   static unsigned long ksm_advisor_min_pages_to_scan = 500;
> "when the scan-time advisor is enabled" is clear from the variable name.
>
> So I'd shorten it to "Initial number of pages to scan per batch"

Thanks, will update these.


