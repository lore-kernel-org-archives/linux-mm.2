Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0175C87FCB
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 02:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D42796B007B; Fri,  1 Aug 2025 22:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F526B0089; Fri,  1 Aug 2025 22:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C56B46B008A; Fri,  1 Aug 2025 22:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B69FA6B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 22:00:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 384241DB876
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 02:00:50 +0000 (UTC)
X-FDA: 83730163860.05.0E6BB8C
Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	by imf09.hostedemail.com (Postfix) with ESMTP id C46E5140008
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 02:00:46 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754100048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v28SVHXOuEBn2vg7x94b2PP5f6c/vq1tubv0K4AzDXA=;
	b=m5iWJ732CdUgk0mRrObHlUtoRIaTnAF2nVDxz964zqhgOd+bcvx9lWtV2WAkgGEA4MJJbb
	Oe6X4WsRBuwp4Ns0DK/sXqb0VrXmqnXkx5k7JLlf1ZTsS2YgQ4srOpjWw36RIHnoHVAvGU
	xomkIQrhsmPHig5wXHpIj/Qqw6o3bpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754100048; a=rsa-sha256;
	cv=none;
	b=KGM/b6HBQAMzJdXaNELKhkX85P5VEcXjm2zdCiqV0mWbmuYJ/GsekPskwiyedxslYWYOYF
	QGYMsGbkf8U7HSBYIGrvmjkbPAGrU2355aTG4QLjpN+95bNBHzB9lwtnTTgxpZBsr92dpj
	5VoSjCZ33bv//pKJ4HXq9PmTTFnaiFA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.32 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4bv5fJ14mzz27j4R;
	Sat,  2 Aug 2025 10:01:44 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 27DF51A016C;
	Sat,  2 Aug 2025 10:00:42 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 2 Aug 2025 10:00:41 +0800
Message-ID: <dfdefd27-d395-4d42-8baf-6d83c24e7dd8@huawei.com>
Date: Sat, 2 Aug 2025 10:00:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: Support only one page_type per page
To: Matthew Wilcox <willy@infradead.org>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Hyeonggon Yoo <42.hyeyoo@gmail.com>,
	<linux-mm@kvack.org>, Kent Overstreet <kent.overstreet@linux.dev>
References: <20240821173914.2270383-1-willy@infradead.org>
 <20240821173914.2270383-4-willy@infradead.org>
 <2d19c48a-c550-4345-bf36-d05cd303c5de@huawei.com>
 <aIwp48CTft68fssD@casper.infradead.org>
 <6feb2506-aaa6-479f-a7e3-b4503b7d6ffc@huawei.com>
 <aIzO4OLr1GPK2RMm@casper.infradead.org>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <aIzO4OLr1GPK2RMm@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: C46E5140008
X-Stat-Signature: 4swk76u3ofbba74jazhjmn5thq8rfri7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754100046-300263
X-HE-Meta: U2FsdGVkX1+0G3Xx52Vu0tCI9LzrL4+RZuvCVEOUykWnw4kSSCpRqUZ/FiLMsYUOS3HiHlayUxX1uUClQCh+quKyK7mbpSQTx5qM1hr6P3QpT5DCwpJSGAAx40TpUzKn7dkQ0RlppNVRLFp38+GI47V6+lW2T2wP9BLL9UFgK2P4+f+9SjHgpP2v3T3L4rACe4WEMPLQsbObVoBUMvHG3qNHOhX2r9zAdAimReaU3paABCC0/SjNkiEgQ1bcG6RkZ8uoY91aS91rcSRC6i8bxYVRvgYPJGD+1uMgnRgzUos7aiGqSmx8jTok5D6qD8178nANPwmea4csmxyu0K3RVBMecR0j7VH4LOCm6K0roICg5xU6cbqQuSDmzxHlR3qmGIijOC3f5Yk8evKWxpT45A9T0+kBXtHF5t9TFq6fd3u5yS3FbCOOafs//KWKMbJmFjpeDsEdk3aQTDyHJO37d6ih3TVBj8Ul60a6WbAQyAYWXI1E124bY9HYJSSW758WjAOuC0yTpEsSLZ51Hn4oH2KGPcWlFsW5oDQ4TlLs0zwUgJu8l30bHfG+fq8vbXlVBrS4pziHNzX5viCQvAy/6TpNBJ4hJjURHUGJRAfLu3paf0o2MwqztDeT8uftI1FARfd+XRa6KRA4sDIn97C+rpypfHljWXOeO7Fnt6ycv1Z0UXhvs5DdNgGzrfuDiqwCUbUEml/9Ys8ZbJkh4w9n7VIpKWQzISXTVo2YF/807/tP5soX33VfUs/j113kbqbrA4Mj50F7qwoaYRUZ7VRXVTRqAWX5wE1hApqpRKD5z+Jwta9ME4BVt6vaCcD3SQIwdszk8PPtqKSTYrfSyJIV+R0mmzdVTRwCHL7Gi3B0woDB2lTY5+awlsXYn5w5K6Jgw9mV4Gq7DiU5+H/RC+yeUK3hApny8687Q+/WIlEcJa+lvvWNRkN0fM+MkWCtcN7t02kVbWmydf6FXqlo6+X
 CbXMC5F0
 C2/bsJpx9MrZFfxF1r62nFz90DgpntvQgUOj7E1pab1ezrxUoIoPRkTNfhpYMkSd6xsQowAfoEfdFYwfRVuTe3uanq8cXKqueQQcWOHDmD4to9Ug5roycHaIYC7S8uxWt4/bDgIbJW19bhwXgTA1HYef/URFYX0813EPNT+nWJiSeqVpZ0UZhJ/DgbsNzlvY1nVqsyDRrZNc9BMQGaFQ4LduoLT/kfhbZA7TqoSjLSxXUcWd2uLnTfhaD3aQC8Hy8jyAbfQ+eJxd1ty6snZK5U+QofF2zbadwHvl4wTLP4tOtpIQN+/0U9dMmn+QX9mtCjloBWraUusI8uCw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/1 22:27, Matthew Wilcox wrote:
> On Fri, Aug 01, 2025 at 04:13:33PM +0800, Kefeng Wang wrote:
>> On 2025/8/1 10:43, Matthew Wilcox wrote:
>>> On Wed, Aug 28, 2024 at 11:35:28AM +0800, Kefeng Wang wrote:
>>>> There are some UBSAN warning about  __folio_set_##fname/__SetPage##uname,
>>>>
>>>> UBSAN: shift-out-of-bounds in ../include/linux/page-flags.h:998:1
>>>> left shift of 240 by 24 places cannot be represented in type 'int'
>>>
>>> I can't reproduce this.  I know Andrew merged this patch in, but I
>>> tried backing it out and enabling UBSAN and it doesn't show up for me.
>>> Relevant part of .config:
>>>
>>> CONFIG_ARCH_HAS_UBSAN=y
>>> CONFIG_UBSAN=y
>>> CONFIG_UBSAN_TRAP=y
>>> CONFIG_CC_HAS_UBSAN_BOUNDS_STRICT=y
>>> CONFIG_UBSAN_BOUNDS=y
>>> CONFIG_UBSAN_BOUNDS_STRICT=y
>>> CONFIG_UBSAN_SHIFT=y
>>> # CONFIG_UBSAN_DIV_ZERO is not set
>>> CONFIG_UBSAN_BOOL=y
>>> CONFIG_UBSAN_ENUM=y
>>> # CONFIG_TEST_UBSAN is not set
>>>
>>> (I tried CONFIG_UBSAN_TRAP both on and off)
>>
>> Hi Matthrew, I work on arm64, so the above OOB should occur on arm64,
>> I remember the OOB appears on linux-next, but I tried last kernel and
>> some old kernel version, but can't reproduce this too, it was too long ago,
>> maybe gcc version related or some other changes...
> 
> Yes, I can't reproduce it either with an arm64 build.  I'll ignore this
> issue in my refactoring, and if it pops up again, we'll deal with it.

Agree, it is easy to be fixed once it pops up again.


