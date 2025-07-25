Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D99C87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBB76B0088; Thu, 24 Jul 2025 22:02:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37C816B0089; Thu, 24 Jul 2025 22:02:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292016B008A; Thu, 24 Jul 2025 22:02:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 199316B0088
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:02:14 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F4F3C0589
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:02:13 +0000 (UTC)
X-FDA: 83701136946.12.6180410
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8FE9E16000F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:02:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753408931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zAtVQhqaqNe5YIAzOFNh8lOZA3P1d3SZ51STVZuBsCQ=;
	b=BTXDZLn1PHlpk4S7DtIQ3PWz+na8VJepvcAAufx+mpPkIg4zZWA68JiHSpQpaViaSQ53NK
	hoJWjM54hLvqwZNLXOOwgmRphQrLqmpJqj6rH0tWD71jWycqMcrVLaDYGurGMHXHdohFxk
	9HA3AFw1LDK7cyyF6BRX7SC5PPKMzTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753408931; a=rsa-sha256;
	cv=none;
	b=XC50xL3ejjhaoX2/+58tjmfZIG1CGBOByk3i5YFDbGks/Ko60ATPIFIrVlGhhXaUK73qbd
	yBWiSmz9F6e7A6TvTM72RU6jABQlfqaCKqjORV8HS2zMjb8agOMWPjWzJRwxTGSL/s55zh
	fgiEjFuTOfyke3oZx5FcRj1olHKiseo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf08.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bpB3b00Hdz27hxp;
	Fri, 25 Jul 2025 10:03:06 +0800 (CST)
Received: from kwepemo200002.china.huawei.com (unknown [7.202.195.209])
	by mail.maildlp.com (Postfix) with ESMTPS id 6BC741A016C;
	Fri, 25 Jul 2025 10:02:06 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemo200002.china.huawei.com (7.202.195.209) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 25 Jul 2025 10:02:05 +0800
Message-ID: <9d8f49c3-f808-4ee3-891a-f921ae85272d@huawei.com>
Date: Fri, 25 Jul 2025 10:02:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] hold PTL for several .hugetlb_entry callbacks
To: David Hildenbrand <david@redhat.com>, <akpm@linux-foundation.org>,
	<dev.jain@arm.com>, <catalin.marinas@arm.com>, <lorenzo.stoakes@oracle.com>,
	<thiago.bauermann@linaro.org>, <superman.xpt@gmail.com>,
	<christophe.leroy@csgroup.eu>, <brahmajit.xyz@gmail.com>,
	<andrii@kernel.org>, <avagin@gmail.com>, <baolin.wang@linux.alibaba.com>,
	<ryan.roberts@arm.com>, <hughd@google.com>, <rientjes@google.com>,
	<mhocko@suse.com>, <joern@logfs.org>
CC: <linux-mm@kvack.org>, <wangkefeng.wang@huawei.com>
References: <20250724090958.455887-1-tujinjiang@huawei.com>
 <e6e22324-c681-4073-95b9-bb6afb918371@redhat.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <e6e22324-c681-4073-95b9-bb6afb918371@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo200002.china.huawei.com (7.202.195.209)
X-Rspamd-Queue-Id: 8FE9E16000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: rsauam8od9jwjzcrwbn8bf5or4wmnwfi
X-HE-Tag: 1753408930-731529
X-HE-Meta: U2FsdGVkX1/sWNVZ4pQvmaugkCpP7AVv4ovuBHHGcVdn3Em2fV4a9SY/DrW/M9zLKwz37c5AdDStWveMWQkz3/uptiNarLq3+XBG02cz0XjtXXJC4hn4hSjlGPDat8RCgVoFGlkrYKQiHTxptLmrQ6x9bLag2TDL7zuU04rKiZq78MFOHXLOO9PKDqzZMHP5R+SVrdfHN2DMp0Veij0p7uZXwDaTtJOnDPuhx/1hnIRbHn8JqZ0sHlNnDhxnfiGrfxY7HcC91Hj60Xs0+6ekfAm/UpUEIdpnQdyTWhlEhdfaMDTFChXgU2QOdzX+KJuFusWqjiqgdz+LQtkzI07ZhMVr7BnmrvQjAXUEVZaeutv8Y4IZNLYX7XlMATntcGAzGsGllTvxnArIYtqdZp7R0Djak6vpqpaVX7Dkykv9ZMiWdbwbXptd7Qiz2O8U6mgQTa23GKbCg6Izw+moOEp7pRJsORwYJI1BCK6PN/1fAYXWLnmu3aVfqaNLZZBKAUq8JrckD31jfkcU/d2e3wMxO7rpNYuw2KoOm057BAKAiLjQDMCTnl0mrQWSkWeuubIdIKvd76aZA17OcEAF2qAsRXmz+iPcpdut/Znatz+XvdbT1+duOFtQd4MeABgYVhrlrrYH11fYdYq83Y1i+faudd0gh0QKfakY7PhJW1oPuJJ8lkwsxA4quqHaQ2Qyo11OcOLnLIfKqAn4bct+FM8FQFrdAGZqxHjpXmz2lK5BMO/ejevWpr8rRtm4c2xyMgJHXDs5Y/35lANBFGBRTzKwh7y2K2K5OPnKd51p48ufFxp73jGN9LA68xnp2K0sLL79aeADpeQ7+oe1mcAX3/SLtTbs440psWh8t4QAhdHtFnAKq/4XhIlfJD+mAZEAGOwMdTvGP6OiM2cnsBAQF/t2GoOXeS0IA/qBMAyWL5deMbEr3PftCv5cANjcd0RznqfRjn7UiLZva3wQZM1eb/H
 PxyedCBJ
 PDP3UHlkZQ3joPeSKp9tExLcK+MGA67ItzJOgxWKJbgwFOtlM7y/I9v6JA7VXKmZhr7h/URHV9Mv+ZptAlBm81fFt2Xhz30qmWkC7Sg5ZkHFnG7jzON59AHRtdFmgHtppJTFB6E3WbeHg6T4pO1veKOxNmTLGpE9+jxFtP/kijNQh1FVrDtwZGlf/b220xx56m0QMTZRT7UE+d5OWlObQ2VBylzeMlGzp3M+t6V6ZvK/NVzJN8ekVk3o4arbrVl1aZKj8MwgZMQqntqQHnFS/vIJHWHO+x1o/5YLyfu4uGLo5fQMEZBAWaFjnwF/7IHYdna6pc4ykARKK63WIt8SbHn57yzfM8gPJ5uLi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2025/7/25 0:26, David Hildenbrand 写道:
> On 24.07.25 11:09, Jinjiang Tu wrote:
>> Changelog since v1:
>>   * update the subject pacth #1
>>   * add patch #2 and #3 to hold PTL for some other .hugetlb_entry 
>> callbacks
>>
>> Patch #1 fixes a race between smaps_hugetlb_range() and migration by 
>> holding
>> PTL in smaps_hugetlb_range().
>>
>> To avoid operating on stale pages, add PTL for several .hugetlb_entry
>> callbacks too. We don't hold PTL in __s390_enable_skey_hugetlb() and
>> prot_none_hugetlb_entry(), since the mmap write lock is held.
>
> There could be rmap walkers only holding the rmap lock (but I recall 
> that s390x does not support migration of hugetlb folios, not sure).
>
> In any, case, ok to leave that alone for now.
>
> We don't
>> hold PTL in hwpoison_hugetlb_range() too, since it only reads the pte 
>> and
>> doesn't operate the page.
>
> Not sure ... we should just handle it like the PTE/PMD case and not 
> play any tricks.
>
Indeed, I will update hwpoison_hugetlb_range() too.

