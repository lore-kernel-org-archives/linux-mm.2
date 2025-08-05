Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF07C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:22:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB468E0007; Tue,  5 Aug 2025 10:22:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56C928E0001; Tue,  5 Aug 2025 10:22:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A9D38E0007; Tue,  5 Aug 2025 10:22:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9608E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:22:42 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ABEB01402E9
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:22:41 +0000 (UTC)
X-FDA: 83742919722.29.1BE98D4
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4AE1B40013
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:22:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754403759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5djVYtKtrg40KrLimX9KCx+ytzebHH0UVgW85aFWseA=;
	b=TOzxKlyNl5g0mVZh2dTvY+gaDR24l/UPukXVW9dDiZGUQxbHf3iALsiFNFdVbTy5g4zVoS
	YXrGQhad26ft7GS0clGM8OlF4YReu7Xpbr2pKG3BuRQ4jUQqRVuxs2DfvBLjQ5eQWEUVOX
	zsYLOk1A6IQG7SuYQ6dgSzyHhZ4u/Fg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754403759; a=rsa-sha256;
	cv=none;
	b=eZ9kbtH8o/ZgGXw81D5qFVCuMndDQoxY65XNYluPhuleX21rQE7tlEVDFAOhVquYUU621v
	EFHcFP1LBYnX1jBYk5N8hTq3W+ltFmTFl0t38z0A2SsYNR4Tf3stNfTkG8SJZT452FR6gB
	ClDABcmdi4YnbxbvN8+wfjK9OwAnFws=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4bxFtq44yPz2TStD;
	Tue,  5 Aug 2025 22:20:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C42D114010D;
	Tue,  5 Aug 2025 22:22:33 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 5 Aug 2025 22:22:33 +0800
Message-ID: <bf294842-b7cf-44db-8891-d1e539b8e005@huawei.com>
Date: Tue, 5 Aug 2025 22:22:31 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/7] mm; hugetlb: simpify alloc_buddy_hugetlb_folio()
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Muchun Song
	<muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, David
 Hildenbrand <david@redhat.com>, <linux-mm@kvack.org>
References: <20250802073107.2787975-1-wangkefeng.wang@huawei.com>
 <20250802073107.2787975-4-wangkefeng.wang@huawei.com>
 <aJEeYY_T7pEhBbll@fedora>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aJEeYY_T7pEhBbll@fedora>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AE1B40013
X-Rspamd-Server: rspam06
X-Stat-Signature: o3wh9b5ucppwttyhtb5477judth7tbn5
X-HE-Tag: 1754403758-421051
X-HE-Meta: U2FsdGVkX1/0zzpiNM7nCp9M3narbqrvXSgR8CF9fRsLhoRvvwx/7H84VuubykFKTeWzMJXcTGd4RrusPQCZ+RZNyXnIQ3EL5ji4bHV4LX/C8+SlrFDlsd3jL88ZHxNTW8vGVQg7FN5JL97sqBTSBHiQUpg9375ZV/kAAmlTK8rGWbNb6uAR5V1QiAizbr+kJIJDmy1oggVSzUfnJYar8i0PO7apBkQnBThCXpRRnQZVJu1sgdXQq7wafULFnFRPsSLZSxknUBRkRkSM4xJywns7qrYJv3c1N2Xbx2vVy36tMOSj2xhpH1mrlb6QNXfN/VVoFbfl7ofWqgBd//dNCfQ7kjRWrtxZZyPoBzmZMbdSnOhbUmwEqTNP5+fkgw85IV61SETcYgkNbEtJ+e9mFeXCErFBQzi9kA0QcWywdFhcJpklTMhq3alL1HlVbMBbKQmJSPbV96jEKrMPaAuwU8I8AO2jiWgqeEbUTfV78Lfe7gVj14QFLpXPfqaLp8q/zoUfyxIME+9WKxybbQMSZihKblDbag8PvNgd40VGgZpRNYt/dTKGIMCepKqoMDKRVn+IqhivEpdsmTYUr4iwBwY4CFrfl2OXY6wyjMQ1FegNtMLR2QC9Pxdphwkc7WYnjK6+7ToVagkpda2ZnGE3enphGQWh3eUPtZ3vxewQalO/wkx4p5vrWbC/9s2UhLqm5YvRsRAGUSbnI4/hcLr+MBitxZawhziE/qZGdLkWp3id2g+t40Sc2hR4GXnFgjG+9LwO8duiwcs7+lRSFiuwRZQR42rZYv/7PAEyGSxolBWscamg+t1ZZQ+vvX5gmkVXFo8DuXkBDEqUXdu0l/aeRE05/GAIOQD6HGSLRNueizr/kXOuXKTVGFdmBvA7sDo0Gqh/gQhcgE8x+ECOaMtCPUHnLcdIPNK6tzhFNuLubN6e2NmmB0IVLy4rASSzwk+iL2USNfdDQouqm8tpwoC
 E6BYjAk6
 1kxxm1tyvoD86U2kdD2jmw4wMq2uDOZR6AK+35dqrPJuD9QGRKkeFXsciAmYPWyeDAhij1tyOzB1mQGcbUfnbgYigiMpLMP4BfRZxHImYEzx+ymWG9+RNGwUxPUa4RrVZ3B3N/7AccDoPsil25Zsr/sb+FVQoMRm12QeLJ3HUzWQSKeJ4aILGz5K5hEwQi+JMR4Ub+p+tpTAWLWpESErqTTxZBehZd1hpbryM6GkYMMKNCLvkc9nWcmtt5ehafl7aFnW3wzYf2IUabLKbfPqiwF10M/yHCrpfXxmv2TD22h1XPfVHQM/u69YWw3QebdoKBuEKhbHT7HVYz7h5i7nedCDX8eNHy2OfroDk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/5 4:56, Vishal Moola (Oracle) wrote:
> On Sat, Aug 02, 2025 at 03:31:03PM +0800, Kefeng Wang wrote:
>> Check folio once instead of three times in alloc_buddy_hugetlb_folio().
>>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
>> ---
>>   mm/hugetlb.c | 37 +++++++++++++++++--------------------
>>   1 file changed, 17 insertions(+), 20 deletions(-)

...


> 
> I really don't like the way you've done this below. I feel like it makes
> the code harder to understand since it feels like we've effectively
> divided this function into 2 different ones (depending on if we
> successfully got a folio).
> 
> I don't have a better idea, but I also don't think eliminating those 2
> extra checks is worth increasing the complexity like this.

Sure, we could drop this changes.


