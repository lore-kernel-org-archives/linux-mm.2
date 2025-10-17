Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E61CCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 469DA8E009A; Fri, 17 Oct 2025 10:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441098E003B; Fri, 17 Oct 2025 10:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37E658E009A; Fri, 17 Oct 2025 10:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2A48E8E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:13:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D27211188E3
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:13:54 +0000 (UTC)
X-FDA: 84007799988.27.A53DDC5
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9E471A0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:13:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BNGwtebI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760710433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cgMNRuiDptLhcbEXNfgS++ifs9lJM5TQAuFOYvo1d08=;
	b=FTW60FrtM5i4bNgdZl1bbb3os8c2SauPwBlPzQBFkdgvfrmZzfs4z7xHWLQf7o7ITCAAWD
	1xmzS3RrfEXyMi6P3XFVKtuLgK4L17n7TDmkvxHykdkUDbURHsEozjN8Q1Oj504c6g6iLp
	y4Q8dFhCwZ+v4cGkPXDXzWG3ikO9R18=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760710433; a=rsa-sha256;
	cv=none;
	b=pLYpJq33Il/8Kxjo6qZ4VIFlRRiT3JxpO6G5Mjxa7kz5VJ3W7YiVsu4nJVnnAH71FGkK7S
	8Q8XPHrZWjr4hIRdgaSSk+v0KYXhfQnpdBqWEoUFB5R0RXFvF13irtj4TVNlHaGsqwNbb8
	rfLMJFPUBv19dz3M3UCIbRTcrElFVCM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=BNGwtebI;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf15.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=cgMNRuiDptLhcbEXNfgS++ifs9lJM5TQAuFOYvo1d08=;
	b=BNGwtebId2Nqcwxb9IuJArDD2P+YJ5AjvLTqPISgFqGeHOybb4fHYtLThZ0vp08ybEXVXB+GL
	Ad39sKxpc/xC77Nfd9FE/uSyjoz6E1h09Efe6LBf999CpKwqhNUtmZXQv5+IEQ5zw3yp5CbKsUa
	4+KzRfztze7Q7drhNek4hKw=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4cp6HX3yk4z1K96c;
	Fri, 17 Oct 2025 22:13:28 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7D8401A016C;
	Fri, 17 Oct 2025 22:13:49 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 17 Oct 2025 22:13:48 +0800
Message-ID: <ddb542c3-3467-490e-b325-9cabb914b70b@huawei.com>
Date: Fri, 17 Oct 2025 22:13:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/3] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, <linux-mm@kvack.org>, Zi Yan <ziy@nvidia.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, Lance Yang
	<lance.yang@linux.dev>, <Liam.Howlett@oracle.com>, Sidhartha Kumar
	<sidhartha.kumar@oracle.com>
References: <20251015123516.2703660-1-wangkefeng.wang@huawei.com>
 <20251015123516.2703660-4-wangkefeng.wang@huawei.com>
 <edef569f-7956-4a66-ac1c-59743724731c@lucifer.local>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <edef569f-7956-4a66-ac1c-59743724731c@lucifer.local>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam01
X-Stat-Signature: pm1emso6auusw38h58h747efemduezo7
X-Rspam-User: 
X-Rspamd-Queue-Id: 9E471A0002
X-HE-Tag: 1760710432-686474
X-HE-Meta: U2FsdGVkX1+Yf8U7X6U7mlSrj/EXlMDK8HOdSGr3Mb1Xgyqnq+0rl4iSPZaZaTPpPXCVusdRHPGe1uf/zohg0re4fBTUFQSbBawfrzqRHQ4TLLct4iJM71oGtW8FlxvrbcsAoJtLI0KsX2pYOrQ5dQqqr/4seq/4yNzjQ1L4LHoWJqR+3IdapCMjuewtFXa1b3MNFW+hmb4+GahaMGuW4LkMZQQNhFwkmwBthIxGq3k2AlFESYsrZl1nzhyUTtqaZYvNaJmB2q3/M/cCCc0jWiGJWiDPj6IEeOhkENgecbjbpbsxwMJadBjbBSu+oM6c+e8WDn8beB3uusDjPqfeAp+OtJsp/nz5z3nTIXCzqcp5zkp4mKSfgul1bSJbcFZhnMLm+5NFOJbOXIREQunX9M99pj7xhuglOk6Vu/9XIgmZN59gVAgbBuieGvjNnuVujVAsdYecPLSoulRlFT3z+u/3sz3ciREaD+IjeBAUuIx5QKuYZLxkPIEkC3yadrr18EUV7bF6KwtJ/z/ZryRgijiHQ6z2Av+2MOszawa7XBDrUAp+crRIFYyTYnwfI3GR8cpExiwhFUg+D6f1Kd7+mBC0QznrXAd+Nyjvghe9vgs/7fqwVIzvMtH4qrBAKMzWOtSRAINpCXbcu3OhGpyRVshMx2Fpa89dudGlhg2TH6fiw4lufKAKK1ulP/2Jk6nS6ewPgfxldFdz1BzKriX6fcLUf1GbjyrYqsG001WUK1guLJHSOs989iJUXOzlwp/st2fJr0fPQmG5TkanqQzSlqPTVU7V+QCmvh7IA4xSJ3frmYaAByK2hFtQXAGK61xBOksF9+kq+Jvw/Rx3iSVkM4VFI0l7x00LyowamIYCCXV2JtGVJ+rYF3xx1HtQvBuG0p8+0mEqqOGpkqWpUOX5ssorr3PGvlLIQKGh690bBOJWutqfMT6KFGw08cCkxRYXpD9u9VKpi5tJ44MR9/F
 3usBcJne
 HHY9/Iaky4iKLZwCXBY1ROQzG9JFz2EVAPrE8pjkzzJl23RI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/17 18:07, Lorenzo Stoakes wrote:
> On Wed, Oct 15, 2025 at 08:35:16PM +0800, Kefeng Wang wrote:
>> Rename prot_numa_skip() to folio_needs_prot_numa(), and remove
>> ret by directly return value instead of goto style.
>>
>> The folio checks for prot numa should be suitable for pmd folio
>> too, which helps to avoid unnecessary pmd change and folio
>> migration attempts.
>>
>> Reviewed-by: Sidhartha Kumar <sidhartha.kumar@oracle.com>
>> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> 
> Yeah you're doing too much at once here.
> 
> You seem to be combining refactoring with changing actual functionality which is
> just not helpful, could you split this into two patches please?
> 
> Otherwise on bisect if you break the PMD stuff we'll end up reverting the
> refactoring too.

OK, the refactoring will be the first, I will split it out.
> 
> Plus it makes review harder.
> 
Thanks.


