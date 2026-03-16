Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81524EFCBBB
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 07:03:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF6236B00AE; Mon, 16 Mar 2026 03:03:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCDB26B014B; Mon, 16 Mar 2026 03:03:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF036B014C; Mon, 16 Mar 2026 03:03:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA996B00AE
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:03:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5185CBCEF1
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:03:51 +0000 (UTC)
X-FDA: 84551036262.13.4EC4238
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf10.hostedemail.com (Postfix) with ESMTP id E26C2C000E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:03:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773644629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GMAJ8f5ee/n68cqH5JEPlrlhEpHRs9hnb5qO0N2iLcE=;
	b=yUbXEfY74E9FJnrentnpLCWOLWJ2nlHqCns8z1XSIAsc3obv9yhNMZbJVdVLwkoJJSzLtv
	Da9darFuzi80gJWK4zLnfjfRibdnpH6naA5hUwLlh0DX7xHTh2QXP3p8FkbTEKKnRFMlEQ
	aiUZRyga7VBLUct/y073PyC14EYzcJg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773644629; a=rsa-sha256;
	cv=none;
	b=AwiSOiadGuiBrPBkHtZMS+7jWuvJ8AsBP3mzsbwZNqvwZM25fMBl2SH7yJ8LBrcWsfp99b
	N5sdMOlyimTqGmJLOuaK7GMhdJXBGFUiJ/QLLRpLpJ9PMhnEj6AuSaaXberedtbs/Tkmqz
	bF+eRiE/w+tDlDWTXiFT8jeX4iUh0fQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fZ5dR06FQzJ46CZ;
	Mon, 16 Mar 2026 15:02:51 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 1229F4056A;
	Mon, 16 Mar 2026 15:03:45 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 16 Mar 2026 10:03:44 +0300
Message-ID: <66131775-180b-4b9f-b7ce-61a3e077b6e6@huawei-partners.com>
Date: Mon, 16 Mar 2026 10:03:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/damon: guard THP-specific DAMOS actions with
 CONFIG_TRANSPARENT_HUGEPAGE
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260314165156.86647-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260314165156.86647-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E26C2C000E
X-Stat-Signature: edmwdobdc6sxor9jk1bpzhuoeo3yidtn
X-HE-Tag: 1773644628-310342
X-HE-Meta: U2FsdGVkX18rikO7cVSTbRYIeD9wFBjplf6Valg8Kv8zeorBm54LOn3FYQKxP1mJTKpd9AujC1TLKs3DDQc54IqvWQhvJrA1pt2ueO1S5VvSgZny/lRuyWX9ovjXxNyAAgj/sBtZvLyD7li4/Me1gnLIggG9/daj77NLUCh0CNbFYFPHiwrJXGldB86RQOGvceLfVKA2+eBcPtsQ8ou354lkiCoPMUwdLPCIt3xRZwzGjret7j4ulconSpFRH3fDQYgn5dTn0B+G2XrWuA3ZaJpZ/pteLo1zC07DVHDvSwfV7+kFtS2zbaZMO813wL1GzUpo7dFwlIptuLydzQBPJQYN3N1EhTVqbqndTgeV24FzBnuNtAJhy1CYjSboQwE3BW1fiHB+w3wZfXpapj9mqb2v97fgfZCSMrKkHNwNTbZOsGWWuAa2V8JBvK2B8/w9L6zbxlAqpMsFTJHu5ZAvkQ39G5XWDI4HwiHNYObCFgmQY4IxMiGizxwD24OtO0nyaaVN8A15s4YcEkGPsB0B/oVN5Mk2TA3pwLy+vy061TaJi5gtDOfzZr/3CIsG2A5iA3wJFHOm2d8liuwvOS6BfQuBKtLLAu/E/daGpvvLl8oHbLDWQfDBDnTndXrE0dh6toUTFoDsq+CI+PfnxB6DggZAsBl53RRh/sjiz6oqhnZCwNvRjMr0TF/R+p/5amRxc2A1GQKtd9KTUHVTu3/YWkReAVp+AENpmG4B7a3tSMfBS5ni6XaxAX6X4c3hPF0AnIOqj5+i4zNQXss3RnrlsBpChTjTYdd7FSNRkerjpg7fRdyWLPiNurK2l8VJJvvD/872Te4L6Y3WTJkVGOur1UQMhLVqCLrYeH/ECmhJJWI68TUrARxe3I0N5B/THGkZbRXtr9dr4dtENgstIziy7y9ERMakIU4MsnAtnxZOs0o4Z6b4dCCqOQrL7Y+0igb6/wHygDsP+X/t2Rvf0SJ
 Ks2S+Nqi
 /i/sl0fQTl3irEYL+DAZ9AvKZWqiiX3J+uOAWyICZGGsY+MEP8VpGAfK6UwpaoNFQ/ZxhEg+YPbva4u36pjtHhuxnioHQWmUqxEy9QoJYSKXSCgcK76CKsh/npIamo62kukq4PFeSBL+0wuII06Jl3CMoGlRZNsmSdCN4wiqgTKT6g3i38SHNrXVgTz55HoX9qsMDV2DlatI4M20LR15MvvxShMaLQMMdq6wamAC7hxgcsjKos5mWUfeaMTPk1dte1loVthIzN9X75S1YNPlTMgrrK27UrDZbhY1dZzWMb2Kl/2awEKxQbwEi06CUu1yEFnpvwlmCPUYN/72BEjVIilXixhLntmOJUyDh1IW7VMU+mcYzXtJN5B1CYaoB29yECbL+vPpPPZeo73M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 3/14/2026 7:51 PM, SeongJae Park wrote:
> Hello Asier,
> 
> On Sat, 14 Mar 2026 09:38:12 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> MADV_HUGEPAGE and MADV_NOHUGEPAGE are guarded and they are not
>> available when compiling the kernel without TRANSPARENT_HUGEPAGE
>> option. Therefore, DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE shouldn't be
>> available to the user either.
> 
> That makes many sense to me.  But, I'd prefer having ifdef as minimum as
> possible because ifdef increases amount of code that I need to maintain per
> different configurations.  I understand use of ifdef can make the resulting
> kernel image more optimized.  But, unless the benefit of optimization is
> obviously big enough, I'd prefer simplicity of the code in general.
> 
> When TRASPARENT_HUGEPAGE is off, DAMOS_[NO]HUGEPAGE will just silently fail.  I
> think that's not a bad user experience if the silently fail is kindly informed.
> How about updating document for that, but keeping the code as is?
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  Documentation/mm/damon/design.rst | 6 ++++--
>>  include/linux/damon.h             | 2 ++
>>  mm/damon/sysfs-schemes.c          | 2 ++
>>  mm/damon/vaddr.c                  | 2 ++
>>  4 files changed, 10 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
>> index 29fff20b3c2a..207219ee10d4 100644
>> --- a/Documentation/mm/damon/design.rst
>> +++ b/Documentation/mm/damon/design.rst
>> @@ -460,9 +460,11 @@ that supports each action are as below.
>>   - ``pageout``: Reclaim the region.
>>     Supported by ``vaddr``, ``fvaddr`` and ``paddr`` operations set.
>>   - ``hugepage``: Call ``madvise()`` for the region with ``MADV_HUGEPAGE``.
>> -   Supported by ``vaddr`` and ``fvaddr`` operations set.
>> +   Supported by ``vaddr`` and ``fvaddr`` operations set when
>> +   TRANSPARENT_HUGEPAGE is enabled.
>>   - ``nohugepage``: Call ``madvise()`` for the region with ``MADV_NOHUGEPAGE``.
>> -   Supported by ``vaddr`` and ``fvaddr`` operations set.
>> +   Supported by ``vaddr`` and ``fvaddr`` operations set when
>> +   TRANSPARENT_HUGEPAGE is enabled.
> 
> I like the above change.  I'd suggest make it just describe the current
> behavior in a better way.  E.g., "Supported by vaddr and fvaddr.  When
> CONFIG_TRANSPARENT_HUGEPAG is disabled, however, the application of the action
> will just fail always.
> 
>>   - ``lru_prio``: Prioritize the region on its LRU lists.
>>     Supported by ``paddr`` operations set.
>>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index 3a441fbca170..b3fcbe84b5d7 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -138,8 +138,10 @@ enum damos_action {
>>  	DAMOS_WILLNEED,
>>  	DAMOS_COLD,
>>  	DAMOS_PAGEOUT,
>> +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>  	DAMOS_HUGEPAGE,
>>  	DAMOS_NOHUGEPAGE,
>> +#endif
>>  	DAMOS_LRU_PRIO,
>>  	DAMOS_LRU_DEPRIO,
>>  	DAMOS_MIGRATE_HOT,
> 
> Also, sashiko.dev commented [1] some conrens as below:
> 
> '''
> Does adding this #ifdef shift the integer values of subsequent actions like
> DAMOS_STAT when CONFIG_TRANSPARENT_HUGEPAGE is disabled?
> The kernel selftest tools/testing/selftests/damon/sysfs.py uses drgn to read
> the internal damos->action enum value and expects hardcoded integer values
> (such as 'stat': 9).
> Additionally, modifying enum layouts based on kernel configuration can break
> BPF and drgn tracing tools that rely on stable DWARF/BTF types.
> '''
> 
That's a good catch, I didn't think about it.
> There is no selftest using DAMOS action that defined after DAMOS_HUGEPAGE, so
> this change should be _safe_.  But the code does have a hard-coded mapping of
> DAMOS action to value, in sysfs.py file under the DAMON selftests directory.
> Maintaining it correctly with future tests for different configuration may be
> challenging.
> 
> So I'd again prefer not adding ifdef.
> 
> [...]
> 
> To summarize again, how about fixing the document but keeping the code as is?
If the expected behaviour is to silently fail, I agree, documenting this
should be the best option. I will submit a new patch with the documentation
update.
> 
> [1] https://sashiko.dev/#/patchset/20260314093813.1359737-1-gutierrez.asier%40huawei-partners.com
> 
> 
> Thanks,
> SJ
> 

-- 
Asier Gutierrez
Huawei


