Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C4D6C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:03:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58BF36B00F0; Wed,  2 Sep 2026 11:03:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53CAF6B00F2; Wed,  2 Sep 2026 11:03:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4050B6B00F3; Wed,  2 Sep 2026 11:03:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12D1B6B00F0
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:03:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 290681A025C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:03:51 +0000 (UTC)
X-FDA: 85169141862.13.E710335
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id CBEFE4000D
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:03:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=JjR28d8t;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788361429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4M78E0ObIENsRiRRK+u7y9UbS3R6BJ4hM9bzTVDKV7o=;
	b=HaRd2Yv9+TU5wFNRiHAgr6vLHNFwWQL6TtxnHbc2fexsiRR17rIL54Wp0nklf273JbOSfX
	4Xloza0F6KNwknPx6QcpIvhNolgtgxHFGFf4eRePwLytF8GT/fPmFkAoRCK+ZYAW7exQmV
	otTeqme42K7HBhSqSFaFZsPgoVlpAJ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788361429;
	b=tLA6U5Umq1V9Cttk+j3c+BU8iCn0alpXIK3hR/Rb6bldCkm2twedRIuMblyxjiAO5N2ePy
	Ul14BxMVVOUllkdiwXUR7t9mlPwTJK2wFmLaU1WSPr5qR82Fw7mPiaGJd8KetoUc0444QS
	gaG4g20/oJ8n4IvlgORs8tBoQuTIPhI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=JjR28d8t;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=4M78E0ObIENsRiRRK+u7y9UbS3R6BJ4hM9bzTVDKV7o=;
	b=JjR28d8tmO/cLBZzM28RFnyU2knLbRFYR2FV3FdhZxKQvodPP9FwXxFlgM5Nga5o56RYcTtSl
	+SXgpKW4RWSvwDgFcjgLOvZbttMeR80lVBOD5kRCJe2Z7U5Eb8Thv07bV288/Oxa6HWq3yDnegO
	/EzpcIZ0a2YUXxpnir7u2cc=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hZmF93FJxzJ46Dn;
	Wed,  2 Sep 2026 23:03:09 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id D5D4740571;
	Wed,  2 Sep 2026 23:03:40 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 2 Sep 2026 18:03:40 +0300
Message-ID: <9ac2a10f-1551-410e-a9c0-173a1daeb1ab@huawei-partners.com>
Date: Wed, 2 Sep 2026 18:03:39 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/3] mm/damon: Introduce DAMOS_QUOTA_HUGEPAGE auto
 tuning
To: SJ Park <sj@kernel.org>, Lian Wang <lianux.mm@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260901142307.100701-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260901142307.100701-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: 94dheuc9m1c1ou5cywj5w4awj5pud1wr
X-Rspamd-Queue-Id: CBEFE4000D
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788361427-194571
X-HE-Meta: U2FsdGVkX18sQzLUTN0I5UVJA36W63tajE9hJBa+oOjxozPT+rFS71kXPB177SqqiBdFlLgLHLbNYGc3hp8ndtXhlS7xq82fdDnJuyOf2XIuELIXJID1sIkX/dlzuewZUW7VSVUa6fChlsjNrpLqd330tM/2Nse0A5/RA1AcFR60LJokLvi0WiPJOXhzR7t5TVA7iHZi/nMg0qr9hpQ55Qykpc/5QVbLARoYHNoPPOAvkKcDKL0ErDzys4rwAk2Pku9C3ZT9p5sQadU0D+O4rcuJvxZIJmc7aSM9hrW71tUQJYkXVmFsIkHQvFqS4ypVLRUU+UOafplnW9MBr2eYt/cxy8jR+dTn4Pvz/b5jEq0do0pZqVhHCXfpRczpaWwrFF9OR0QdPYhh8cXJaRxs43eUgBIGrzgoOGHuDusHlmvOWuDZKrh8/qd5f4CBa7bwkB/Shn9TWDPTi9jAEfGJhX7c7s0sGlSG1Xa+lF/ETcWU3Bbaidd+LhOvxK9m/u+RKPmQQFra2zDI3jAis+Jx0tzvIm1EYDkn+T52j9OZlcLrKdJQpNa3EADCkMabSGZXC8AiYU1/YRh3oFucND2DyN5kFGLcowM9MyUIgc48PWqsD7gzcmS5Qi+BP+GeS3mtTWsq9WIzqvkvz8ME25DFvGMT0Rzqph7rEGLOUozVFXxOePSRG3+SGB5Kdn8MR+N4gfjOPZOCyA814093zngJSabrw+aoSuEGzUZRUbZTjyBpRIcR0Wonh87AOWLa5tkEWx/CbX7sAWouRCtbTGo71lXxKHuU67e0dgHRisOTXqHdEHXokKbr8QoVmsAVJLwZLGEfUH//Ee65TfzCDXT39hX2D60PjZzqW9UXnND99mKvt7x96xoKWVwN2gnCbWOyTxheDK9nj1m9INsOiPzJmBTZK+jBd+pXrmG9MB8F5zLq+CfQMMdKh8i1F72qeKB6Gwk9dVbn4SoIKGN7AQ4
 LPv+yljO
 VQ9XaR7kK7WTKrv2u3Vui6IYZeNmXE8N0Ch8SBP8cIqr0YJndwDiwondbpySICiojztxuquTr1+LS6228O5sEjSiHyYs6JvbdKrwwuzvuymSNKrWMTLViuZzjx6s/vPlAWLNKvRmFSTh+kU6BD5uwyxagcjl3Y5OqnuX2u5Iuu6VOcWw9HDynbORv3oEWAvHBh9Ca8BO7o2kH/ix+buaPnaSgML/+8KJq8Fk4VVBJEWmzXIPm7L4qQ85GKNJ/ZbT3aRVoCcklUvaUzaKL6xf9Rey2dYJkTndFZzlbX6TZO3acYnIJUkBeyqrpv9Va+zvhXU8ua33yKU0QlA0sCklgbIpTiE505WAj0nB+o6p3UeWWiBws51e2cBcWRm2jNwguwg47ZSJmVSpWXZcDnl2JWBKMzuW/EkLLgbZVdo9hco4I/DOJu9/mTOf+LQDkTtQbkurTxicS+1MTrtCRVpFniTo/fMRtqf+9LaEouMXeEEuP40r+tTg/W9PftqhQ0epYkhXRDGmE3x9nuok=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ and Lian,

On 9/1/2026 5:23 PM, SJ Park wrote:
> Hi Lian,
> 
> On Tue,  1 Sep 2026 14:58:35 +0800 Lian Wang <lianux.mm@gmail.com> wrote:
> 
>> Hi SJ and Asier,
>>
>> Thanks for working on this and for providing the server results.  I have two
>> questions about what hugepage_mem_bp is intended to represent.
>>
>>> Introduce DAMOS_QUOTA_HUGEPAGE_MEM_BP auto tuning. Add a new DAMOS quota
>>> goal metric to measure the amount of huge page consumption to total
>>> memory consumption ratio.
>>
>> First, NR_ANON_THPS tracks anonymous PMD mappings, while NR_SHMEM_THPS and
>> NR_FILE_THPS track PMD-mappable page-cache folios.  Therefore, splitting only
>> an anonymous PMD mapping can change hugepage_mem_bp without physically
>> splitting the folio.  Is the intended metric PMD-mapped memory or physical
>> large-folio memory?  Clarifying this and adding a mapping-only test may help.
> 
> Good point.  I was just missing this.  So, hugepage_mem_bp is not accounting
> anon mTHPs, right?  Since hugepage_mem_bp is for general hugepages, I think
> this is better to be improved.  Seems using MTHP_STAT_NR_ANON that is exposed
> as 'nr_anon' can be used?  Because this is an improvement rather than a fix of
> a bug, I think doing this as either a followup or new version of this series
> are ok.  Asier, what do you think?
Agree, I will submit a new patch to fix this behaviour and account for mTHP.

Lian, thanks a lot for the review and pointing this issue.>>
>> Second, the metric is global while a DAMOS scheme can target one process.
> 
> Actually it can target multiple processes if those are in single DAMON context.
> 
>> THPs from other processes or NUMA nodes can satisfy the target or dilute the
>> monitored process's changes.  Is this intentional?
> 
> I think it is intentional.  The user should have the control on collapsing
> hugepages, or believe the uncontrolled collapse mechanisms.
> 
>> If so, documenting the
>> scope and testing a background THP workload may be useful.
> 
> More documentation and testing are always welcome :)
> 
>>
>> The temporal results approach the 10% and 25% targets, while the consistent
>> results overshoot the 10% target to about 20% and 45%.  I would describe this
>> as control-response data.  TPS, latency, TLB, fragmentation and collapse CPU
>> data could further show the workload benefit and cost.
> 
> Yes, those would be helpful.  That's not mandatory for this simple change in my
> opinion, though.  I would let Asier decide whether and when to make and share
> such data.
The idea of this patch was to introduce auto tuning. I think I submitted thebenchmark results when I sent the DAMOS_COLLAPSE feature.

Anyway, it shouldn't take long for me to get more data. I think it may be useful
for people to know the actual results in real application.

SJ, what's the best place to publish all those data? I believe you have more
experience sharing this data and which platform is the most useful one.>>
>> If I have misunderstood any of this, please feel free to ignore these
>> comments and correct me.
> 
> Your comments are very helpful, thank you for your review and comments, Lian.
> 
>>
>> The enum, quota-goal wiring and sysfs exposure otherwise look consistent with
>> the existing DAMOS autotuning framework.  I consider the points above
>> follow-up questions about semantics and evaluation, rather than blockers for
>> this series.
> 
> I agree.
> 
>>
>> For the series:
>>
>> Reviewed-by: Lian Wang <lianux.mm@gmail.com>
> 
> Thank you!
> 
>>
>> Please feel free to Cc me on related follow-up patches.  I am happy to help
>> review the code.  Besides my own DAMON work, I have recently been reviewing
>> and learning from other DAMON and MM work, and I would be glad to continue.
> 
> I'm curious if you and general reviewers need or prefer to directly be Cc-ed.
> I was naively thinking people can search and review DAMON patches by
> subscribing to the mailing list or using the archives via lore.kernel.org like
> tools.
> 
> 
> Thanks,
> SJ
> 
> [...]

-- 
Asier Gutierrez
Huawei


