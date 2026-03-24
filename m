Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D4B7F54ABA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FD0D6B0005; Tue, 24 Mar 2026 09:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F726B0089; Tue, 24 Mar 2026 09:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727176B008A; Tue, 24 Mar 2026 09:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EE556B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:50:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13C361BA2CC
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:50:04 +0000 (UTC)
X-FDA: 84581090328.19.2C5C3C6
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 9014140005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:50:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774360202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vpQQDu2m75OLNOSG52K5n+yj3hqTSt00WOQpyiLWZWk=;
	b=awzc8okRfmAiBJI3l/o9xndFN5TxhrbmHFp1iBiwnNjKPC1bP5HccBRif3cbVmIpP+l9Es
	AlfRRvbQ849I1I0RUZ33QCc02ivOvekwa4nUwyQtufOavcTIVgni3cDb96Aa4KDVcIAK07
	wucmpIk7wLarhoDYysG4pJTwGjmJraE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774360202; a=rsa-sha256;
	cv=none;
	b=CnmOnEY4Z/y85v/EkAQsOybSC9VmizbcarzzC3S35VlyvItkXz3NH5tuwlnRksAhZjV3lE
	5k15R8p9G5LuloUcN7qSriHMeCTaqgvWOpCIJj2nusHJZM2O/A+O3RAcL88Jl8LBs4pGNv
	iX+8mEfeRhckxRrRW7Ji5IOZJaJG6c8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf12.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgBHJ2l1wzJ46F7;
	Tue, 24 Mar 2026 21:49:48 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 5629E40584;
	Tue, 24 Mar 2026 21:49:55 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Mar 2026 16:49:54 +0300
Message-ID: <b1922673-9900-4c15-a8ca-b086115b1e86@huawei-partners.com>
Date: Tue, 24 Mar 2026 16:49:54 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (sashiko review) [RFC PATCH v2 1/1] mm/damon: support
 MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260324004119.87026-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260324004119.87026-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 9014140005
X-Stat-Signature: 9a5cg7g3kkkwg8tzecp831ptg45kb89u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774360201-348608
X-HE-Meta: U2FsdGVkX19j9EuFKF65ViAHGf7bfUkQB3k8qzvLRhZO2OUkKybxYTVkJLjToWHapeiJLMzBTVyP39hOHYU32exLRxQYXjSvhLnleXFtJddKLBCnUSNql0nPxhCPO0zkhFqi0HNFBRvRYgAyhHos5ADh0pVEhLzAWv4+Lxe5nJnHZHXnFyPh2dx8EQLvP0Z+xxAJjFONop+FAcW2/SZSucCcUPysGvKQldXpiZA/XuYTD+iP7QIy/b+gYCkdh4XxxBws3Hu9nx635avg35HZ4hD2biyye+1jhfBY/hOzKDX4mbf1OX/qgQ9NfrC4Cj0oGaB8YBCnEPVp46oBQx9IQpL9EGkUb40Ol9V1Z1uVINPBFWd86xf9qy5P/pqjSaveOfa4ANshkHxNwTUFMwoDDc2f97yEeeAi3zB05L5euSr0RldUwc9U6K+tPQ6w6MTmqw84XtDl6FFRpNohEBVERFbBq7XE4Ws+RzE7Fuso+3CdCpMycCIjlpPjViJANUv4+RuuXMD35MOILHdO9Uo72781vS24HF6spaPIDcpHgdJph4L9zf69KYFGkVwJePRMH61g3EbBY7QnSZ2qjjW/PgQ38KaZHoA5aeSDx87cj/iWue2alnP5lDUfwBQVfAZSVZEv5b0AzXkt6kJcNIiaMItyGALDm6r2UFmn9sXvyVCcf5ng7R1DKa5DGzoY3XhuBmSlbhF/uKX3xadraTYOi33ma+BUk56pqpF7Rxt3SG8IbB6DD0pXQSGxpFISU9iwtlURFYVNd0hIPSXJhpWYK3ory/xhDiEOK3zKOmPEXELhWV5KxPYUrJipiwZcp/ud97tF/mBY2evGTIv8RHsv1Yjj7v1c+fNfDscCzVMtY+BseVQDXFakVV8k43aeAOgRhWFzFgrOXKx5X8FyKzMqH8gm4LGEuYkqcKhISkgR3awDDbx5CYBiZ3pNZde6H971WbL7hs2yOUMixbKAkCz
 JQOWDu3J
 KZBLSkSmGMlx85b3nCCfJCeKC005LE4NF0/KFht3pGlSOmHc0X5sQtZn89LVxoxKZHckiHbVy6P1VFCcdgZJKDnw50pYjtqnn8ZpI1PUs/TvySRLw8Fv2vLjxs+AYERBSsiTSSzEO+yGUwYBKAVRdy6gEcKlWMiPgh3QWcSilIuKR2WXZ80kG98WRF5cTvpHRq7mDN2CJA+95/Wqj0D2icS0nkJ2f41pgH2/tmQ6bZq/TttAowIbs12sNw2KSLNkneMxM3JPUFYGjhQFpzdcxF0enT8hHbKpR17U6MLzhiLC723rZaJsLXMi0tJqBieY7U89KeG1XXQrj8kRi3atuHb+4RWkoCOiIqb8ycjoiKc1X1FsUnMYwxolXMXYHe2BToflI6oFjK22fipgd04TbswYynX3HbcOlelzp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 3/24/2026 3:41 AM, SeongJae Park wrote:
> On Mon, 23 Mar 2026 17:29:36 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
>> Forwarding Sashiko review for doing discussions via mails.
>>
>> # review url: https://sashiko.dev/#/patchset/20260323145646.4165053-2-gutierrez.asier@huawei-partners.com
>> # start of sashiko.dev inline review
>> commit eaed291e6fae91842b1836c68bab867d53525db5
>> Author: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE scheme action
>>
>> This commit introduces a new DAMON action, DAMOS_COLLAPSE. It allows
>> DAMON to synchronously collapse an address range by calling madvise
>> with MADV_COLLAPSE.
>>
>> Link: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
>>
>> [ ... ]
>>> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
>>> index 3aa5c91548a5..c6476e63f4fb 100755
>>> --- a/tools/testing/selftests/damon/sysfs.py
>>> +++ b/tools/testing/selftests/damon/sysfs.py
>>> @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
>>>              'pageout': 2,
>>>              'hugepage': 3,
>>>              'nohugeapge': 4,
>>> -            'lru_prio': 5,
>>> -            'lru_deprio': 6,
>>> -            'migrate_hot': 7,
>>> -            'migrate_cold': 8,
>>> -            'stat': 9,
>>> +            'collapse': 5
>>> +            'lru_prio': 6,
>>
>> Will this cause a Python syntax error when executing the selftest? It looks
>> like there is a missing comma after 'collapse': 5, which might break the
>> execution of the DAMON sysfs test suite.
> 
> I think sashiko is correct.  We need to add a comma.
I will fix it. Missed it, my bad
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


