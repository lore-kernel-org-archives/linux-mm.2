Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E619C5DF74
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 02:28:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D7A96B0126; Mon, 17 Aug 2026 22:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 088B46B0128; Mon, 17 Aug 2026 22:28:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0F16B0129; Mon, 17 Aug 2026 22:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C63A16B0126
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:28:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BB421A089E
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:28:40 +0000 (UTC)
X-FDA: 85112806800.21.F7443A3
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf29.hostedemail.com (Postfix) with ESMTP id DEA8A12000B
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 02:28:36 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RP+HWovR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787020118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BwG3+/eW1U2Q5NmRKM3Ulxh9NPgPJjBj/aoaDVhJaoE=;
	b=N7GUlqk2XHsN9NDJIH0y65W72HjnehIsXRioP7ZwYm60MJ07Jr0ODaO4I8GQsbJgX4+i5s
	Ft7VzVNlJwOjelbkGjG9mJ5XTHsec4E/mBQorpuZtIHnfwXSWxO09nwPycNNNqA9yFgWTH
	AQy2ezAGm/WzftmA1t0/yZChC9tdyAY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=RP+HWovR;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787020118;
	b=SWxd1Qe8whITzdloDOqXzVGJq0OINMrGJWTMInERzjnflOEMzO7/V9OkRG2rAGAw0d9n7J
	fI44FrisNUwvNOMPx3yaqM5VqY1jNpDXmOK3wYdzr8Xh1191Afb6enOxGXpn/U2luP8AuT
	0TXcBBSp7o4fFVmfs8wfDH1sSYCBXlE=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BwG3+/eW1U2Q5NmRKM3Ulxh9NPgPJjBj/aoaDVhJaoE=;
	b=RP+HWovRAZtuANBcKD7Gh61ix9TlZPCtDw5HwDs4/k54BGKo4OWAWedZY0PLmIWUW6T2q6KWr
	NfHmB/uA3n0a2Lmd0ea5azAf/u1iIKRP5WvJcHfoyu8oUkv0VYB3HApHBU8oMLG/fPfTyoJTiWs
	FzTDe+QvTgEQfs6G2yX8Ea4=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hPCyz2yZkz1K96b;
	Tue, 18 Aug 2026 10:17:47 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 077084055B;
	Tue, 18 Aug 2026 10:28:28 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Tue, 18 Aug
 2026 10:28:26 +0800
Message-ID: <9dcc2527-21c5-4092-8ad1-d0755e787931@huawei.com>
Date: Tue, 18 Aug 2026 10:28:25 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/ksm: fix advisor_min_pages_to_scan description
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <xu.xin16@zte.com.cn>,
	<chengming.zhou@linux.dev>, <liam@infradead.org>, <vbabka@kernel.org>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <shr@devkernel.io>, <linux-mm@kvack.org>,
	<linux-doc@vger.kernel.org>, <wangkefeng.wang@huawei.com>,
	<sunnanyong@huawei.com>
References: <20260813031722.569983-1-tujinjiang@huawei.com>
 <20260813031722.569983-3-tujinjiang@huawei.com> <an2g39TIN9v87enG@lucifer>
 <b35d14b5-65d8-4b8e-8754-de35f03d4b2d@huawei.com> <an3RcQgDuhmcAb37@lucifer>
 <238c66fa-8144-4cad-b90c-e7992b14ee6f@huawei.com> <aoM8bbWNeuEbfCdy@lucifer>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <aoM8bbWNeuEbfCdy@lucifer>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Queue-Id: DEA8A12000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 695btkbr4bqwni6igi6bo933aof46dpy
X-HE-Tag: 1787020116-830448
X-HE-Meta: U2FsdGVkX1/qLutZrx3bHvsQXUSypCiqxFHREbE+QnPicoXq2N25dSLCDflw8KIbAUVLk0hu9WktPMSmO6DgYnDFmduwBSmhL3Rj2ygo1J2oqTKyt33b5GqtMdOYlAltM6ShV9avG57G/SINYI+An+3SoTpLq69gAc70JZnbfsenef4zvAxLomfMTHJmRLK8JqX4S2G9kaJQMWDyFb6we5tt7/k8gto9PPyPOMzeFHmV1Z/u5WbrTOIQcdAKejN1ewPNdfs1294x3X4gzqdNgGD10w2+bLpOiTz5H6Cm8r+/tEiVIYP0EHvP2Z2+t+aw3bnMbmMirmomG/3KYztYTskNMIVLyC3/9gdpPXcFXY+eStsoiVS8gKRi7jp2SeJ1uSD2/cuwBDgtXdLCsVY2xGu2imG35ZxUVuG2IjxbAbG8zBmHXl7g+9uFmsAzQtofuDtW9PMTE3Q8ifwDeBwK5NaH/nUiIz/pAM6YhIJcXKt2NbYNgrQIKmwQym98XQA6eNgPddcxHTBhxroXre1rqnx0USHe6BKc1jabaap16F8pD+MfKYG1Qf2s34U/k0Yy3W2gP9CvPXt4KGBKs/8Smuw3pPB1P2sVZgDwtjT1TGfSxaAWkonC1xd2fWBgzSyNBE9qlUh42MeTxyV2xuFhe5yI48rqIRCcGinmblIjB2XAQ8DIxCRFPaznIjkePMtfNFPnN4eg5MVANCDAhfRwqY8DEUzsraqyvU+FFdeCp5Lj5jzjbtJouoWS27IO8V9dVtYTHxSv9F3Bn2LLXK0l6qY6wNIr2QGR/DU0qnoiwqnaragVCWP1nWBeb3CKMBCIUHUj+14LmYIW5gg7K2jyrtw+PNgMiW0coW7HcQUV1p6DZRAymkiQNP+P6SFRflvl8qoDHsBAuaW5qPdwg4t1y7spRl9krpP3M9oEhvIbCd1cn99H6sX5fAiD0cJLmryFdPJByW7uc42fH0Lp6fk
 apeG3XmR
 XXaInxwwUQ0JZG3lsLDmWtVE72kdndlK3hLcRPuC1AV8bt8/+g3A+FeefczaHiNPKLqbGrZI9JAbWjVD5VifJQzzehlhB1foWz61fVody7jXN7/RUXl3twuayLjE2//x0/fXUYShJsSDD2IKB9IACZMTmfs25kHzmsYRTJVzYOe96lLWWVV1Fmnk7SFuzZGc6+jrAO6cqxlnpspbXsOLBmzBHREp6iwAMZTvG8r2NSgQUPhc1Z+fUeIwiYcGfeDWcbbxC6HOdVV843n8Tf6DZ4AYCuY2sSAUOvCSCA7fX4RUfOrxatushftalLXR6SjvZtISQ0qfSK/6eLpcgARqh3AIlnmt18RxAmBusZmwOVcmXdO1Pm8oJF0KkuzN/jeWhC+nTtRQXPE5w9kY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/8/18 0:55, Lorenzo Stoakes (ARM) 写道:
> On Mon, Aug 17, 2026 at 10:54:52AM +0800, Jinjiang Tu wrote:
>> 在 2026/8/13 22:32, Lorenzo Stoakes (ARM) 写道:
>>> Please show me the common courtesy of responding to _all_ the review given,
>>> not only the one point you want to respond to.
>>>
>>> I'm not happy with this patch, sorry, for the reasons stated that you chose
>>> to ignore.
>>>
>>> On Thu, Aug 13, 2026 at 07:17:05PM +0800, Jinjiang Tu wrote:
>>>> 在 2026/8/13 18:56, Lorenzo Stoakes (ARM) 写道:
>>>>> On Thu, Aug 13, 2026 at 11:17:22AM +0800, Jinjiang Tu wrote:
>>>>>> Both Documentation/admin-guide/mm/ksm.rst and the comment next to the
>>>>>> variable definition in mm/ksm.c describe advisor_min_pages_to_scan as a
>>>>>> lower limit of the pages_to_scan parameter, but that is not how the
>>>>>> scan-time advisor actually uses it. commit 4e5fa4f5eff6 ("mm/ksm: add ksm
>>>>>> advisor") only uses it to initialize ksm_thread_pages_to_scan when the
>>>>>> scan-time advisor is enabled. This will mislead the users.
>>>>>>
>>>>>> The semantics of advisor_min_pages_to_scan was updated in the v2 patchset
>>>>>> [1], but the documentation wasn't updated.
>>>>>>
>>>>>> Update the documentation and comment to match the semantics of
>>>>>> advisor_min_pages_to_scan.
>>>>> Umm, firstly if this were wrong you'd need to change the name of the variable
>>>>> too instad of documenting it as something completely distinct.
>>>>>
>>>>> But secondly AFAICT the logic in scan_time_advisor() suggests that it truly does
>>>>> act as a minimum bound as well as being the initial value for
>>>>> ksm_thread_pages_to_scan.
>>>> As the cover letter[1] said, 'The initial value and the max value for the pages_to_scan parameter can
>>>> be limited with:', ksm_advisor_min_pages is used as the initial value, not the min value of pages_to_scan.
>>> (Wrap your lines properly please, it's a common courtesy to learn how to
>>> send mail according to community conventions.)
>> Thanks for the reminder, I will follow this in the future.
>>
>>> One of the part of my review you ignored:
>>>
>>> 	But in any case, you are making a claim here yet have provided no
>>> 	evidence for it. 'It is just the initial assignment' means nothing
>>> 	- if the logic can then only increase it up to the maximum value
>>> 	then it still acts as a minimum.
>> ksm_thread_pages_to_scan is adjusted by scan_time_advisor() after a full
>> scan finishes. ksm_thread_pages_to_scan could increase or decrease depend
>> on the real scan time is longer or shorter than the target scan time.
>> The min value of ksm_thread_pages_to_scan is only limited by
>> KSM_ADVISOR_MIN_CPU, so ksm_thread_pages_to_scan could be smaller
>> than ksm_advisor_min_pages_to_scan.
> OK thanks :)
>
> With this explanation put in the commit msg somewhere on respin then we should
> be good.

I will update the commit message in v3.

>
> Probably we want to rename the variable too but can save that for another change
> since the attr is called min still (ugh).

Yes, I have considered to rename the variable, but the sysfs knob name is
advisor_min_pages_to_scan and couldn't be renamed to keep compatibility IIUC.
so I keep the variable name unchanged too, to keep the variable name and sysfs
knob name consistent.

>
>
> --
> Cheers, Lorenzo

