Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C9BDC79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 189DE6B008C; Wed,  9 Sep 2026 10:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 13B426B0098; Wed,  9 Sep 2026 10:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0517D6B0099; Wed,  9 Sep 2026 10:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CF2CF6B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:39:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FFE840290
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:39:37 +0000 (UTC)
X-FDA: 85194482394.04.769FE24
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 25A5B80007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:39:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=AMbUYPw3;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788964775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgkh+lnCPR9ToQ7RKu6WNXgaTBz3MWmsuMW/EsVHOjs=;
	b=FZSJtLem9UmpHrVrSVbX3wxy+ER0GcGlYSAEWC4AzkXWIX+xcHoZMbxyMexlGmTxKSmK/G
	kQXyobdr4dghh+a4xvtSZbSUh+G1BtOGXI7laX4JbHiW0ToyZwZlo/2NHYIg3R8PociVSb
	PD7i4w2ptudvfP1Kb+oWE9+cPOpQPUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788964775;
	b=kH4JeFxO/aJtuKW5eWEDYuoQwze7zcbbyrvEDw5e9E1xZcCIqMC0fv0HVGmgzCU5mmQW5s
	CnMBj6P1xZCH39nhyc7jHZpmk3pT+8EooPKorNZb1ChyC5Opg46/p6IZjL3D4EFgSOsupB
	W4yEO2NpW3L7saxViu1AvUTcfSJjM60=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=AMbUYPw3;
	spf=pass (imf30.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=hgkh+lnCPR9ToQ7RKu6WNXgaTBz3MWmsuMW/EsVHOjs=;
	b=AMbUYPw3HWqJHuMzyv7Oatsol7IMXbL2hnF0W1wanh6yMZMdr06iXV187VlLtRigXMmOlnImM
	6HYry6tOtOhVjG8QA0chN8xhVsVCXcmd5Z8obKK40uCQoqYzYKhN5tveEKJvB2DCYef3Yo93kDA
	OCNE0uCBXOVF4amHc79YWwQ=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hg3ML4m88zHnH56;
	Wed,  9 Sep 2026 22:38:22 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 77DFB4057A;
	Wed,  9 Sep 2026 22:39:24 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 17:39:23 +0300
Message-ID: <8f193651-9a6a-421b-91a7-df4a231786fd@huawei-partners.com>
Date: Wed, 9 Sep 2026 17:39:23 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH REPOST 0/5] mm/damon/vaddr: support {prep,apply}_probes
To: SJ Park <sj@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260909143143.106666-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260909143143.106666-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: 9m8pcia38pcj5m1xwercc7ij64rwmpx6
X-Rspam-User: 
X-Rspamd-Queue-Id: 25A5B80007
X-Rspamd-Server: rspam03
X-HE-Tag: 1788964773-305378
X-HE-Meta: U2FsdGVkX1/s5ApZpzbxS0+/WJ41yExjQAuogQEpUWmfnRMycjZ2VqgrY4m35JBAtcOG2JhhXRzckysE8/U6tE/1jTAZnlCpIQCQgeloFRYZStt4CBRQZ57NahyRN4/aUD6gyCm+c0/dEV6W0hKg8KdhrkNkJM1jZg3vnxI4mDD4C21Wsi+Y4v63K8X96zYSPVGIrdmKZsxQUh19dwJcgxkfDgpZdeGcP4aTTBu+yTB4TbMCvcw2FBJDnZ5r4PKi3EEAKzj8iYKwjr3Ns+yRU8mCmFxoUTKdGhhAWo2hdl8rH/D7j6KOz7rHwc6mVbI7+JZEBrnTjS3d6MermGi1XRYIqfLzXAq2GP2viQD3kLCvYhkzF0KylQeJKX7MtLRyaFeyrV+/n9lYq/yP1JHPETMFH+HH65NTR0DgJUDvDEHtGeZRj8uvD9rRKoxkPJoD49DxoutJ0b++ZWE7aS5V5HVqgYuuRwp3apRoNX+lhQJg9CqMYDibE4AE/lmdSSMWVI0LJztKQQI4CSWi2nL94Jx4TcLp8/oQSKhvr9HoIhcXnAJ22UM0deuRqbRB9tMdJ0eaHAs2fAx5hVt10paH7L+1kmFYZJq/oJtCXjgvvlYyyBdX9BOP2HRFlleUkkLjAAC/dtfR2cYcUcYcUQPMaO3dbTNJWuRz4h8hcjmV+8OhyMXUGQebQfX4qb73GVSoRgLAw6g+hHMqxf9LrewCHWtATrmYtdEAgcsdesohqltB7NIDd6JIgPdkyGmbvtmUNjVYfQe+HXimy89hV0pf4wLGpbDyGlyk3M0Pv2GnuL89FQMawqSKoUpKpIk19YN+gnq/30XbGhTUdyI72OFamOm5BnZT6w/D5eJ/LWtLjMt5FtJK1rdcuXsQ+A+3TtkLPgQ49JKu+LnO0MPvahIMK2aUvy0abmlL0/54SNWHihs+E3Dx5Q/6G9JCxBmNRDASQSLB/8+IHaiSyhwJ+qQ
 dWB7W8mi
 BXEy+2U0GXLMcej2PDyVODxO6KUJoxK9s95J3fJ4sFkaw1Naot9lDD+nV2GAZGvbD9hbYgtspRlCYM826FQpBvOiXEKLvjhtk8MQU5l4sSpmKuzUJhA9POIRE1oqWRBQn7vy0GN4LYAfuNjwEnWU3XvoGSCZZBtjsqc8Xarukxxl251cNt04TdRRfVAIsQbb06+NODmx6vr6kWYNjBlJ62iiKdnbbiRaNE8cnnKLrs2eRdsZRCiB7fQzzCaGOM+W2Z9JdLYxYrdCDS4uJ9rTZnSp71NRO4Uey2pY/VCbraGQvyaYgsaFTfwX0LnCbvf5WgF0P5Em2Vc+oeRyRC65CTKrImnf7eBSCfKCGkbmF/lNZ1OYcsKT75SBMIn5DSkf7XV765ofgk3Dg1O/pOuc9Y6Vv5X9LnBcFhJGN2mHBzOJRiJ/xrbXR0wh0jnaG/NIeW3xhMBabaUK44eyQOkanld80dR2y4F8aG6DMf+4/VgA5usFfpdEnxj5/Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/9/2026 5:31 PM, SJ Park wrote:
> Hi Asier,
> 
> On Wed, 9 Sep 2026 17:25:51 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>> Hi SJ,
>>
>> On 9/9/2026 5:04 PM, SJ Park wrote:
>>> DAMON supports data attributes monitoring.  However, only the physical
>>> address space operation set (paddr) is supporting it.  Add the support
>>> to the virtual address space operation set (vaddr).
>>>
>>> Patch 1 adds prep_probes support to vaddr.  Patch 2 moves probe filter
>>> handling code in paddr.c that can be reused by vaddr to ops-common.c.
>>> Patch 3 adds minimum apply_probes support to vaddr.  Patch 4 extends the
>>> support for hugetlb.  Patch 5 extends the support for pgidle_unset
>>> filter.
>>>
>>> Test
>>> ====
>>>
>>> I confirmed it can capture ~48 mb working set of masim in vaddr mode,
>>> like below.
>>>
>>> First, start masim [1] to access ~48 mb memory at a time, in the
>>> background.
>>>
>>>     $ ./masim/masim.py run \
>>>             --config_file ./masim/configs/stairs-50mb.cfg \
>>>             --repeat 10 --quiet &
>>>
>>> Note that the config says the working set is 50mb.  It is 50 million
>>> bytes, so ~48 MiB.
>>>
>>> Start traditional access monitoring of masim's virtual address space
>>> using damo [2].
>>>
>>>     $ sudo ./damo/damo start $(pidof masim)
>>>
>>> Confirm it can capture the ~48 MiB working set as the 4-th region on the
>>> snapshot.
>>>
>>>     $ sudo ./damo/damo report access
>>>     heatmap:
>>>     11111111334[...]3000000000000000000000000000000000000000489999997777777743333333555556[...]8
>>>     # min/max temperatures: -1,150,000,000, 80,009,499, column size: 6.963
>>>     MiB
>>>     intervals: sample 5 ms aggr 100 ms (max access hz 200)
>>>     0   addr 85.355 TiB   size 55.703 MiB  access 0 hz   age 9.500 s
>>>     1   addr 85.355 TiB   size 18.984 MiB  access 0 hz   age 6.700 s
>>>     2   addr 127.183 TiB  size 278.516 MiB access 0 hz   age 11.500 s
>>>     3   addr 127.183 TiB  size 7.570 MiB   access 0 hz   age 900 ms
>>>     4   addr 127.183 TiB  size 48.133 MiB  access 190 hz age 800 ms
>>>     5   addr 127.183 TiB  size 54.977 MiB  access 0 hz   age 1.700 s
>>>     6   addr 127.183 TiB  size 55.113 MiB  access 0 hz   age 6.700 s
>>>     7   addr 127.183 TiB  size 37.902 MiB  access 0 hz   age 3.900 s
>>>     8   addr 127.990 TiB  size 120.000 KiB access 0 hz   age 11.400 s
>>>     9   addr 127.990 TiB  size 8.000 KiB   access 70 hz  age 0 ns
>>>     10  addr 127.990 TiB  size 4.000 KiB   access 0 hz   age 11.200 s
>>>     memory bw estimate: 8.931 GiB per second
>>>     total size: 557.027 MiB
>>>     record DAMON intervals: sample 5 ms, aggr 100 ms
>>>
>>> Stop access monitoring and start probe-only mode access monitoring.
>>>
>>>     $ sudo ./damo/damo stop
>>>     $ sudo ./damo/damo start $(pidof masim) --probe_prep set_pgidle \
>>>             --probe_filter allow pgidle_unset --probe_weight 1
>>>
>>> Confirm it can also capture the ~48 MiB working set as the 11-th region
>>> on the snapshot.
>>>
>>>     $ sudo ./damo/damo report attrs
>>>     heatmap:
>>>     00000000113[...]40000000000000000000000000000000000000000000000001111114999999533333336[...]6
>>>     # min/max temperatures: -840,000,000, 330,002,000, column size: 6.961
>>>     MiB
>>>     probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
>>>     intervals: sample 5 ms aggr 100 ms (max probe hits 20)
>>>     #   size         address       age           probe_hits
>>>     0   8.000 KiB    127.990 TiB   8.700 s       0
>>>     1   120.000 KiB  127.990 TiB   8.600 s       0
>>>     2   55.543 MiB   127.183 TiB   8.400 s       0
>>>     3   110.008 MiB  127.183 TiB   8.300 s       0
>>>     4   55.352 MiB   127.183 TiB   8.100 s       0
>>>     5   55.605 MiB   127.183 TiB   8 s           0
>>>     6   55.691 MiB   85.355 TiB    7.900 s       0
>>>     7   54.430 MiB   127.183 TiB   7.900 s       0
>>>     8   50.391 MiB   127.183 TiB   6.900 s       0
>>>     9   18.879 MiB   85.355 TiB    6 s           0
>>>     10  52.844 MiB   127.183 TiB   3.500 s       0
>>>     11  48.039 MiB   127.183 TiB   3.300 s       20
>>>     12  4.000 KiB    127.990 TiB   8.500 s       20
>>>     memory bw estimate: 0 B per second
>>>     total size: 556.910 MiB
>>>     record DAMON intervals: sample 5 ms, aggr 100 ms
>>>
>>> [1] https://github.com/sjp38/masim
>>> [2] https://github.com/damonitor/damo
>>>
>>> Changes from v1 original post
>>> - v1: https://lore.kernel.org/20260906184417.96621-1-sj@kernel.org
>>> - Rebase to latest mm-new.
>>> Changes from RFC
>>> - RFC: https://lore.kernel.org/20260905202634.88102-1-sj@kernel.org
>>> - Drop RFC tag.
>>> - Rebase to latest mm-new.
>>>
>>> SJ Park (5):
>>>   mm/damon/vaddr: support prep_probes
>>>   mm/damon/paddr: move probe filter handling to ops-common
>>>   mm/damon/vaddr: support apply_probe
>>>   mm/damon/vaddr: extend apply_probes() for hugetlb
>>>   mm/damon/vaddr: support pgidle_unset probe filter type
>>>
>>>  mm/damon/ops-common.c |  32 ++++++
>>>  mm/damon/ops-common.h |   2 +
>>>  mm/damon/paddr.c      |  23 +----
>>>  mm/damon/vaddr.c      | 232 ++++++++++++++++++++++++++++++++++++++++++
>>>  4 files changed, 267 insertions(+), 22 deletions(-)
>>>
>>>
>>> base-commit: da659d141e9797b3a2e5d0e2b457bfa4e8a8cb2d
>>
>> Nice to see the progress with probes.
>>
>> Since you are adding prep_probes for vaddr, do we need to check for
>> the existence of prep_probes in kdamond_fn?
>>
>> How about this?
>>
>> diff --git a/mm/damon/core.c b/mm/damon/core.c
>> index 645cb367019a..7b308cbf21ab 100644
>> --- a/mm/damon/core.c
>> +++ b/mm/damon/core.c
>> @@ -3935,7 +3935,7 @@ static int kdamond_fn(void *data)
>>                 if (kdamond_wait_activation(ctx))
>>                         break;
>>  
>> -               do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
>> +               do_prep = damon_has_prep(ctx);
>>  
>>                 if (!access_check_disabled && ctx->ops.prepare_access_checks)
>>                         ctx->ops.prepare_access_checks(ctx);
>>
>> And maybe change the name of the variable to has_prep.
> 
> I'm sorry but I don't understand a benefit of the change.  Rather, I show it
> could cause a problem.  Later code does below:
> 
>                 if (do_prep)
>                         ctx->ops.prep_probes(ctx, access_check_disabled);
> 
> If do_prep is true but ctx->ops.prep_probes is NULL, this will cause a problem.
> 
> Am I missing something?
I was under the impression that with the change, all possible operations would
have a prep_probes handler. I just noticed that we also have fvaddr, where
ctx->ops.prep_probes is NULL.

Ignore my comment :-)> 
> Thanks,
> SJ
> 
> [...]

-- 
Asier Gutierrez
Huawei


