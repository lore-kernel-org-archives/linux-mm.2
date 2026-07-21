Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEA2FC44532
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 13:30:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09BF6B007B; Tue, 21 Jul 2026 09:30:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE07E6B008A; Tue, 21 Jul 2026 09:30:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9C06B0098; Tue, 21 Jul 2026 09:30:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A31C16B007B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:30:18 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 277211A014C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:30:18 +0000 (UTC)
X-FDA: 85012867716.27.B8EC678
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf11.hostedemail.com (Postfix) with ESMTP id 325464001F
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:30:15 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HEtwQgoq;
	spf=pass (imf11.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784640616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LizSE8PjQwP9bFRM6MFQjQlF1mQYaBSLa7F5psPMWLg=;
	b=3v2IlfKbxUtaI/1+AY/ZEJrBc3xKsvYg9wZ63oil24KbZd31VACWxIZoTYVAFFIDN6HF23
	f5QXYikbirHf9fjYDKLMPTXwkVaUFPWHsRToJ09oxS43EpxM/luaCu+MsdIvz+0O8JnEj0
	aTmovW2vOXL2tUlCbSNWzByhWlAhU6o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784640616;
	b=2eqw6M4JCB29IMrZ9GPmjtkQRnHZAymXR1GIJk2biF/ltfyrlB7ziPKbQ54iciauit5wzV
	EWXnDESLKHEYeW9sR9PS90s+hhrTOq70XkDVTc76zMGxOm0rMQlgQs3EaKyO0sk/8kmxC1
	3mVgpGaUYtKAHpNN0EZC1Yir213bQGU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=HEtwQgoq;
	spf=pass (imf11.hostedemail.com: domain of xiqi2@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=xiqi2@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LizSE8PjQwP9bFRM6MFQjQlF1mQYaBSLa7F5psPMWLg=;
	b=HEtwQgoqV9Hbu518/n/qfXaRWb1uBnGP0UHH2pS4GO8+ZkhymXIbFgm+CRL7roh9XaD3j6OJY
	GidcLfryRHPKNg0nD00S5/Ocy24D7FVabW5xvSwjutEb0jwHBZb/hGpn9dR7etI7JexX4MjIM48
	nbT8oWoxyjzEdtXQgsr47bo=
Received: from mail.maildlp.com (unknown [172.19.163.127])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4h4J0t1VXlz1cyQQ;
	Tue, 21 Jul 2026 21:20:46 +0800 (CST)
Received: from kwepemo200010.china.huawei.com (unknown [7.202.195.178])
	by mail.maildlp.com (Postfix) with ESMTPS id E6F3540572;
	Tue, 21 Jul 2026 21:30:06 +0800 (CST)
Received: from [10.174.178.56] (10.174.178.56) by
 kwepemo200010.china.huawei.com (7.202.195.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 21 Jul 2026 21:30:06 +0800
Message-ID: <95b68d90-19b4-4020-a024-1fac3bc3a608@huawei.com>
Date: Tue, 21 Jul 2026 21:30:05 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH stable/linux-6.6.y] mm/memory-failure: fix missing
 ->mf_stats count when hugetlb folio already poisoned
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Naoya Horiguchi <naoya.horiguchi@nec.com>, Andrew Morton
	<akpm@linux-foundation.org>, Sasha Levin <sashal@kernel.org>, Miaohe Lin
	<linmiaohe@huawei.com>, Jane Chu <jane.chu@oracle.com>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <sunnanyong@huawei.com>,
	<wangkefeng.wang@huawei.com>, <stable@vger.kernel.org>
References: <20260706084118.1284271-1-xiqi2@huawei.com>
 <6a756801-f4a5-44a5-abfd-e9ae57432c56@huawei.com>
 <2026072112-lapping-turf-bf90@gregkh>
Content-Language: en-GB
From: Qi Xi <xiqi2@huawei.com>
In-Reply-To: <2026072112-lapping-turf-bf90@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.56]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemo200010.china.huawei.com (7.202.195.178)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 325464001F
X-Stat-Signature: 5firanzcsan6yajaqi3ajt7qr15b1afk
X-HE-Tag: 1784640615-849906
X-HE-Meta: U2FsdGVkX19VAFEEnhhcBTxHNQ6hZL9kSopYDnkMiWXvBBY9ETXSv/KDELBhTa/491BzeiCF2ua1/FumjJfWc4To49LV9qNO6jgGwTsyDuVn7cZso/xh2BGvfgNWN8KP78N8pTI18++igdUvtgjFruqv4RumnL7en+xx70QF3jHWYQVrKHyaC67j8xhWQL0FtwDQyzfT30Z842t8Kz5YbhiAKhAoQdCkpGIWeEp99wsDjjXqYYnmloQvsYmCaPoZmQPssvYUpGd/uRyZOKn8hnwfdDphT9gtFUXLO2WmC85UNu5XIa0KK6NJhGR01X/oCL9yLAKfIBgV2CtYpL++ulcb1ieDBn5+0IaBSYIPqBiDP576qtOEJKDFVWB69rfEKvpsdWUIGhK1LOpXITcj3bLbuQDTxZJRAp8Qo3BVyMGf7adaPs4nnUPZozzCEsRasr0jASfSnQl73PotUweNE6nslwiSfbIjSyVIGkptK9Md9+bYeIs+EhyxhSCgvwxADWiNok5CUlGmkHTV4mwIQnWUSdOqUGkcb+epSW9b+EA2MC8LJEM+I/LeF0xZ8C4358rUbYCbx1knWyWh9q5fQHxIQHBY0ivVzzFAHgujvuxcPAfUhPcyxol/3oY1wKTDGEkRhMsLdcm+utAyTzoP1uPuTpkabUVHYiHbiOjk/lVC5xrE9fhPYRaHuuzhUSo3i+cv1/04ItqtOlz8CBCqUstHT9mtW7Z+4RqkmSFlW0pDpPSs7vNPV/4b6llIFKiS7HCkwOgR6BO2+uzst9BGyzROzzUteCwXyBg+L6P08dDYYFUd4mshkzUbmnF2WTqdVcJMhL31DtYoGtsTyRVtRJOprNCV5O0C3ptVJ4q0d3QCXxj2JOe8laqTbPMQCtaNs5JVSLyHUcz0MAUnC23Vs7IgeSw19wv7PL466EqnJqXGs2vCcF93NnEpzdbTcxgC7WQWBotHxI5dKR8Ll+i
 PCiXH4fd
 CtHYEqZ3wkIJxrQqiUhlGU02Nvt8oN8qYlapMwYhbEopQ9YGdRj0UWMkUiHClIxVx2APPgKGgcS3uCDV7bd9ImUJsz47wr2W/ti+tIe6YWchw9Pob7FOnGb/kmzSrkvIs6b2npyGDfCjiEiPzvVZ1YKg3OEuxmNU4eeI+DziOpKMXvymWb9aSZhRyqeopmxLW5d/1TJo8bDV3Nd+J6KXoEKrhDoPSGGT4B8MJO7Q2+uJAkNUAi3bis5IijTUDYHU8MWpRjbvGYH3B/rceH/G6rRsx1GCxA603tNCDkrIraAqt8ZSWJFOhfo3Iu/l4/1n0/AkEjyGSYVNwUV/vzmoe8C68sjcUQF828iDLnMo200jQfh0z5YvpWR+0n/Xq/gMhq9EHkTmiUYTLt8VEN3Dd4N20CLR/QQAwivqD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 21/07/2026 21:06, Greg Kroah-Hartman wrote:
> On Tue, Jul 14, 2026 at 09:45:03AM +0800, Qi Xi wrote:
>> Add stable@ to Cc.
>>
>> On 06/07/2026 16:41, Qi Xi wrote:
>>> When a new subpage is poisoned on a hugetlb folio that has already been
>>> marked hwpoison (MF_HUGETLB_FOLIO_PRE_POISONED), hugetlb_update_hwpoison()
>>> increments num_poisoned_pages directly, but the per-node ->mf_stats is
>>> not updated because this path bypasses action_result(). This leaves the
>>> two accounting counters inconsistent within the hardware memory-failure
>>> path: a new poison event is counted in num_poisoned_pages but not reflected
>>> in the per-node mf_stats.
>>>
>>> In mainline, commit a148a2040191 ("mm/memory-failure: fix missing
>>> ->mf_stats count in hugetlb poison") fixed this by removing the direct
>>> num_poisoned_pages_inc() from the helper and adding action_result() calls
>>> in try_memory_failure_hugetlb() for the already-poisoned cases. The
>>> backport to linux-6.6.y as commit 252bb328b36f ("mm/memory-failure: fix
>>> missing ->mf_stats count in hugetlb poison") applied the refactoring
>>> (naming, constants, switch-case) but omitted the core counting fix,
>>> leaving the inconsistency in place.
>>>
>>> Fix this by adding a matching update_per_node_mf_stats() call alongside
>>> the existing num_poisoned_pages_inc() in the same block, so both counters
>>> stay consistent without restructuring the error path.
>>>
>>> Fixes: 252bb328b36f ("mm/memory-failure: fix missing ->mf_stats count in hugetlb poison")
>>> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> We need acks/reviews by the relevant maintainers before we can accept
> something like this.

Thank you for the feedback. I have resent this patch to
stable@vger.kernel.org with the correct format (including upstream
commit reference and proper stable submission format):

https://lore.kernel.org/stable/20260721121956.124887-1-xiqi2@huawei.com/

I'll also work on getting the required Reviewed-by/Acked-by from
the mm/memory-failure maintainers.

Qi

>
> thanks,
>
> greg k-h
>

