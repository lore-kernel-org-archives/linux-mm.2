Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B278D35666
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 02:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 748166B0092; Tue, 27 Jan 2026 21:45:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F5AB6B0093; Tue, 27 Jan 2026 21:45:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618266B0095; Tue, 27 Jan 2026 21:45:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 50BA86B0092
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 21:45:30 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E912A8B89F
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:45:29 +0000 (UTC)
X-FDA: 84379831578.08.EE7E3CB
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf05.hostedemail.com (Postfix) with ESMTP id 8CDB4100006
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 02:45:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VgKSZkqv;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769568328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Di8cZJ5cc8VbrR7T2nMJ6z1aTcg0ByBxctmpLWPm4y8=;
	b=XqGAZeM7Sd451LEjlPPZvIaD9etukalZllKuAmEP/cEokHg0TQdBVTeA1Q4OiXRDHD89/p
	g4U0S6sFGjyeH20FIPInE1oOE/PbePpl8K9pVufB5/1i/Ju+ONaSB76sZRRTFF32Bcd00Y
	sSlfr5ofsynl6Q7iCXHU2W9oLrXrdTI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VgKSZkqv;
	spf=pass (imf05.hostedemail.com: domain of linmiaohe@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=linmiaohe@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769568328; a=rsa-sha256;
	cv=none;
	b=YD5WvxaPn5/mbY5AJmLj13QnBusB+fcVw1WvZt2cNv2op6nGrIooGlosqBSYPmfd6hi26O
	5VFdN5TtMJUPnJgeDBYlrtG2p9nSgxIXw4yuZedWFkvsjciUa7itzKPf8IZlpyg9J6OsTc
	80WnJ48srf1ubjW/T0ca0+fVVcqSK1I=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Di8cZJ5cc8VbrR7T2nMJ6z1aTcg0ByBxctmpLWPm4y8=;
	b=VgKSZkqvSDQAOgdPwRZLAbVqlZ19Hnk19J8msr8OrxyEA/Oghz4KDorgKRnDscCUSXi+YHRqf
	/NdbSMTPfXEeT5Kggxb5CEIpPcDwmqw0N0dCkZBXeuTGx2x99cTEuybNWiiB1qVdl+Bs+SYv+LO
	Tidu2PHAZX8uX7fet1nL8bU=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4f16410f2nzKm4R;
	Wed, 28 Jan 2026 10:41:53 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 956094056D;
	Wed, 28 Jan 2026 10:45:21 +0800 (CST)
Received: from kwepemq500010.china.huawei.com (7.202.194.235) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 28 Jan 2026 10:45:21 +0800
Received: from [10.173.125.37] (10.173.125.37) by
 kwepemq500010.china.huawei.com (7.202.194.235) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 28 Jan 2026 10:45:20 +0800
Subject: Re: [PATCH] mm/page_alloc: Fix freeing of failed-split poisoned
 compound pages
To: Jiaqi Yan <jiaqiyan@google.com>, Boudewijn van der Heide
	<boudewijn@delta-utec.com>, <ziy@nvidia.com>
CC: <akpm@linux-foundation.org>, <hannes@cmpxchg.org>, <jackmanb@google.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <mhocko@suse.com>,
	<nao.horiguchi@gmail.com>, <osalvador@suse.de>, <surenb@google.com>,
	<vbabka@suse.cz>
References: <CACw3F52D8=s_uj_jRtw1J-GjAvt4c3HNMKb2sJGUjznvyAK80A@mail.gmail.com>
 <20260116141157.29578-1-boudewijn@delta-utec.com>
 <CACw3F529=PC-pwXOX0gbNrnS7HTwXq93oVT=V74J4FHLqcZ-ug@mail.gmail.com>
From: Miaohe Lin <linmiaohe@huawei.com>
Message-ID: <3ec3f4de-2c38-5ec4-4b4a-d7a801efe558@huawei.com>
Date: Wed, 28 Jan 2026 10:45:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <CACw3F529=PC-pwXOX0gbNrnS7HTwXq93oVT=V74J4FHLqcZ-ug@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.173.125.37]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemq500010.china.huawei.com (7.202.194.235)
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CDB4100006
X-Rspamd-Server: rspam07
X-Stat-Signature: ci7thtez5prpfsoynoiejbfekne7ezom
X-HE-Tag: 1769568326-634856
X-HE-Meta: U2FsdGVkX18u9p3diJ+kyoMsgoA56NL7okeaB3GoNtIk7S8aXGvxdmRSzV+tVQHwyus3XZMTJEmKR7cXNeO9/zN3oDWLJLjtpQ1q7Mner4MSVAxih25q8K7z3dJDNXZWBxgBRIzPEyqsK3pvlsPjZZkhqMePG0ZHKnTaoLkB13kSnccQKl5SBerYpiOBH+ZCQynbWZu0BLYLIUYADBdF8PHoiRQwA1aRnhlqQxSnTzW2XQrlQsz1xFdotAf++QFzT2yPi3UcDTHRcEag2iVuykkNh2DrEaT8SgeTnQNf1SDN6jGViSiKhzxlghrfoktuPhcgi8sXtbWE6IlO7QBo3a/d2ABdBuLx4GjuL+N/HOhv0hgQmW/RR8yvvwAWL/RJbhIi+92ODGkf0Xzff0bIimLAd0SIORwaKF4YGxD/yV/fZtTQxCrLSgpo3LdkmJacglBuzIjLUVYePV1t8vnw625uSKx9Q5cmDpbK98PuMGEVidi0CIywI42/A54GtVxWCyL3nDf0FTIreEbuP72ArGhHwrgdN82aoDUhQlV7KhR8DoEAUaRWjUgVEbUEVLvVfqPQPbDSngxEbzObPlnGL/HqNQy/0/Mpp5r/bWa46iuFsFddqJutCma7Z/tXqUQRIKgKc36UBOYrqFPoDbcpH+YD4wWpgUlbaUSoHs8dj5a5sZNM3wyQ+lL1m64J9s/mgGShr8VowX3rQtkXDoGr+hJrXn7pKnk5n27CkPzcgmekVdjGO7BxCUiJZJ++C73Ggy/0sUszqTh6NQDfzFCT0/tz3g2ZbaJ0XRAiFQd5X9hKBHAVIl7Zb4IDIODXsvIu2ddBoxkWWGt7pCxzVzyZt6536o5qvHNwj7dEQyLs20RXWyYs+Ip6u83Or/adr8Ttj+rHw2o+KSPhYsrkecrdFT2rWV0Wln8T5zUjLM0FFBzRiFbHal1goh4pRnV/6eyyffM8IixGWMnvCfSH2PB
 qI1Jszcj
 cpSAzlE+g6McwXyg7RHcbGIm+U/NQGyvkdUAOHwsBjpTE7V10jxrMN49LRaocHievi/Vt1S7WNHgPg5OjKk3gJEWND3x+0255/ha4A8DYLyVVKfpCI3BbdSks0Uz/bYGDAJv/s0gNS9jKkeIj3ETyDNsUxie20TWHkINX2PUN374iDu5Okr2WaWcFvBq0ocvNMA9dhIjewffWQmlUxq4cS06x25pZQqSyei3DW0Q0F6bNjRtKSXtxLT8AHBY/YveaDXQqXK1ip/KiQENi874eR8SIj0Bmkwvzael2LnECoCCD/WrIda220vAQFI2w6xq7S4Xawi5RXVBtM8eJGZ2x60AZg1RNjVJYLff+YAdnXM48qOdS9QVzRHH71Zgk51N73xlqSVDQlLVu2gIBiOYjnwiwgBbkORZ3aURLJdYfVJVPsRibmdi1X87jweshUOHlx55hNH5NJ/BhUDG+r10J/2Oo2NWpeXCVbLLE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026/1/24 12:42, Jiaqi Yan wrote:
> On Fri, Jan 16, 2026 at 6:12 AM Boudewijn van der Heide
> <boudewijn@delta-utec.com> wrote:
>>
>> Thanks Jiaqi for the feedback, that is very helpful.
>> (and thanks Miaohe for connecting the issues.)
>>
>> After going through the memory_failure(),
>> I can see it indeed puts the PG_HWPoison flag on the specific subpage pointer,
>> and therefore my fix won't work as-is.
>>
>>>>
>>>> Yes, this is also a problematic scenario for Hugetlb HugePage. And Jiaqi works on
>>>> it now [1]. I think Jiaqi's patches might apply to THP scenario too. Add @Jiaqi to
>>>> verify this.
>>>
>>> Yep, I think my work will also help solve the concern when
>>> try_to_split_thp_page() fails.
>>
>> Your fix makes a lot of sense for hugetlb,
>> as it linearly scans through all the pages.
>> From my understanding,
>> your fix also provides the perfect architecture for also checking THP,
>> though it doesn't yet cover the in-use THP case outlined.
> 
> Oh, sorry I went ahead myself and assumed the split-failed folio would
> eventually be released to the buddy allocator at some point when
> userspace processes who owns/maps this THP are killed or exited.
> 
> Zi and Miaohe, am I right about this? or do we need explicitly handle
> in-use and split-failed THP?

IMHO, it's enough to handle poisoned sub-pages when in-use or split-failed THP
eventually be released to the buddy.

Thanks.
.

