Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68787CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 12:37:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0688E0028; Wed, 15 Oct 2025 08:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA82A8E0020; Wed, 15 Oct 2025 08:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABE6C8E0028; Wed, 15 Oct 2025 08:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 983598E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 08:37:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4082B16015B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:37:24 +0000 (UTC)
X-FDA: 84000299208.27.554D466
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf14.hostedemail.com (Postfix) with ESMTP id AE7BC100007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 12:37:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MEBzZxFz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760531842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M+rqM+zYrs+orV/NJzae2nBch0EoD+ES9RyBHODQCvo=;
	b=YyaBdwnnXIvLOKyyuKviq5PUzXMdNfCvxxyqsEcaRWj5LjOWbM6q/NJxnR63gFAn+wOKNc
	9v8/318OcnYMMIDlZIZGoQ70Tehmb950V9Z/AWbK6QViX38zS7vx9gqIy/RsACOi+RAcqJ
	hNDi9+eZFZVPZaIr/hjB0pGdAHkUDtQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760531842; a=rsa-sha256;
	cv=none;
	b=zLijCTo2wbhv44RqvTt0M3BTpM1gQ7FpwghU21hMB69BVPoqYFBFeuYEnvi2WHKpZrROmB
	nOhw4gnXSzQtBvUc0Jhi+fgqRvb8j6uMWwh1T0zaRNq7RDLyIihMtGbpstPb1fN8XijarX
	ZO1FfLAn3e5T+EqHqzXkjGQKlq9kvWw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=MEBzZxFz;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=M+rqM+zYrs+orV/NJzae2nBch0EoD+ES9RyBHODQCvo=;
	b=MEBzZxFzWypDlWsTK01CaQt6xnVsus4KmhfVpflUvf0voR7BWioNRdm9aA2gdpxUvhdGB915Q
	bgxArfTu38Rr/nOWOtkeDw/hXsCW7KIuP+0mFTLEcdvmibEcLZSkhTVIYI1h254oIrNqx1ETf+c
	mSn4Ha/niyCuJU18H512KZM=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cmrF508V0zmV6g;
	Wed, 15 Oct 2025 20:36:57 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 5ACCD1A016C;
	Wed, 15 Oct 2025 20:37:17 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 15 Oct 2025 20:37:16 +0800
Message-ID: <94bd087e-0b62-480b-af48-bddc7d600183@huawei.com>
Date: Wed, 15 Oct 2025 20:37:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: huge_memory: use folio_skip_prot_numa() for
 pmd folio
To: David Hildenbrand <david@redhat.com>, Dev Jain <dev.jain@arm.com>, Andrew
 Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
	<lorenzo.stoakes@oracle.com>, <linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251014113349.2618158-1-wangkefeng.wang@huawei.com>
 <20251014113349.2618158-4-wangkefeng.wang@huawei.com>
 <1c020f8f-4722-45e4-af1f-ee3d4a67068b@arm.com>
 <92490858-fa4c-49dd-bb3b-2820c794a8dd@huawei.com>
 <77fe5471-ed9a-4448-8a0c-75e41729bec4@redhat.com>
 <c5f19802-3d40-4e0e-a9ab-1de64b6869e8@huawei.com>
 <cc278ae0-ecfd-4385-a497-eb2a35fa662f@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <cc278ae0-ecfd-4385-a497-eb2a35fa662f@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: AE7BC100007
X-Rspamd-Server: rspam02
X-Stat-Signature: kfa9co6c4oam4hkbt8hqwzuxw8kdjj7g
X-HE-Tag: 1760531841-210608
X-HE-Meta: U2FsdGVkX19ARuVE+rV8TzCSO9b2LDw/8s2gIcnvwmyuJ6FyLmrvcnDpWpMsO6IAQXKE+JXwG7FT6O/KwgDZtIoyW1PPLDsvCtCIoKz1Hr5oGJnu0uhylafwF/mt6tOadjS+ABHI/RKaoUl9Iojz55mD9dj/r4IK+0/6PouPh6GFEMveFW9JKW/QPlrv0ojpsbQH/Qrre98IcwVXBWAmnl5vJqR4SQuuAbGb1THTMd7CmlGQcYBqrAESc0b8WZirY4wYxsMDKAeLH3qgVmdRMWSNOnDZjZDzNCfkDRgrKo4t4yrDTyzTl1zfcm3fZOrjaDexWkrCR8VZIxvZSdz5EbgcRtgjY6yj2okZ1FpbHDzmXIJ5O/VaN32C+VXk8ZaaPxe7Q0hI52bM5mIC3wwJyFaIzPFSLZhBY30JwwEGjEqCVtd4DDo9STcOAEleTioQTzAUKhQscGMiARM2J3WzbwOBlUkX/HcELyqUiCUf+nCdFSsd6apOVvDftMXueifrlEiZ5qSmNpKb3xEPClLLXV0Fqf6g0prwBoEwRIPiKhTF9/sNCVJBPeXB9+pAHTtgFYeQLYVxLtAhWl6iMpntWb0D9OsUcIn+GFcaMlIzr5is7MhGFSHEmlIkFKFjiTPVMJd8OAQI/DJEACMyNu/zLrTmwyASQSsea9O8HyoEjigplSD1FJwxB2D/y0qARVbNJruFRLlVUL/3cRYw7aN0uAkr9BBKz9sDPBEMdos65VJAWeEWSukv6+V/GxRpRgigiPtFZTaNhZU1JDaWjlCUv5HOyiFP4XMcePq06Gfhbh0HbgJbZvsV+Nkkl9FOZqaTPn6VuTVsREuS4x9ep/aIRs981L42SzydoHLeHD81bT9EmImDyOlPTHtYBFNpIMx30eEl5XyOiTluwjXkFO1eeTl1luZSfs52MeUK36klPNRA5rfnvJM6MgJuZmtFzYcRfwUD5t92/oWyIK/3Ulu
 vUHT0Xct
 RNrVc5b30rWbiCHbMJqucJWTSFPRJYj3RTuCFzGxMnQPDzeCqS34GJMDFjv3/8ID0WnHUAqSD5+v132Zfr63jMEYqE9s8l43WsROsCLfI45aV5VKtV1iQv2EFpc6KXjp1vPQDfoG41o8tOLNdupiKZIT6lK/yLFcVJpJBzbv674VZCeXs3z3/aFoOwClta+E2FCYARULN/UXGEw5Ew3edbQmun01O50Un+D5Vkv9PdvlrPs6/Z2pVwdjPSH93VJnNzrSjPFqwwSScZahHlF+3NZiM0fsIv2xVTvdfMPJ1tasnhWAJ4xhNsgRrRlNSuDxOWa9Wvt1392vkxQ1brl8vTfOiBvg0p6OUlXMfG1E/cxBgwgJqgLznVEd6bQVkB+YXfL8BzaaXkizdxaEhHDoW0BJmP4Qhk80DSXAurS8lijZnDp+mv6kNNQd4Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/15 19:30, David Hildenbrand wrote:
> On 15.10.25 13:04, Kefeng Wang wrote:
>>
>>
>> On 2025/10/15 17:54, David Hildenbrand wrote:
>>> On 15.10.25 11:21, Kefeng Wang wrote:
>>>>
>>>>
>>>> On 2025/10/15 15:30, Dev Jain wrote:
>>>>>
>>>>> On 14/10/25 5:03 pm, Kefeng Wang wrote:
>>>>>> Rename prot_numa_skip() to folio_skip_prot_numa(), and remove
>>>>>> ret by directly return value instead of goto style.
>>>>>>
>>>>>> The folio skip checks for prot numa should be suitable for pmd
>>>>>> folio too, which helps to avoid unnecessary pmd change and folio
>>>>>> migration attempts.
>>>>>>
>>>>>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>>>>>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>>>>>
>>>>> In the review of my mprotect pte batching series, reviewers had
>>>>> noted that the branch "if (folio_use_access_time(folio))" in
>>>>> folio_skip_prot_numa() did not belong there - it should be done
>>>>> outside of the function. But I see that that would duplicate a line
>>>>> now that this function has two users. So in light of that, would you
>>>>> mind changing the name of this function to
>>>>> folio_skip_or_process_prot_numa()?
>>>>>
>>>>
>>>> The name is a bit long, and it only update access_time not change the
>>>> pte, so maybe we leave it as is?
>>>
>>> Any such name might make the return value weird (which indicates whether
>>> to skip) I'm afraid.
>>>
>>> We could invert the meaning and call it something like
>>>
>>>       folio_apply_prot_numa()
>>>
>>> And return whether we have to protect it.
>>>
>>> Maybe that's better? Other naming suggestions welcome :)
>>>
>>
>> That's better, or folio_needs_prot_numa() as there are already some
>> similar names with folio_needs_ prefix ?
> 
> Yeah, why not. Then we can also add kerneldoc to describe that it will 
> adjust the access time if the function returns true.
> 

Done in v3.

