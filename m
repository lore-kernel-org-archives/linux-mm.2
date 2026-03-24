Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8086F54ABA
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 13:57:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F220B6B0088; Tue, 24 Mar 2026 09:57:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED3116B0089; Tue, 24 Mar 2026 09:57:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE8576B008C; Tue, 24 Mar 2026 09:57:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD0326B0088
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 09:57:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89638161C9D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:57:32 +0000 (UTC)
X-FDA: 84581109144.17.9E6C086
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7D3BE40005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 13:57:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774360650; a=rsa-sha256;
	cv=none;
	b=0+hqGYrn02UGpBQG7UTTSJSDJdQpNIT2FUtecB3VbVeKn7ke0C5jXwfn58JKmQRG3AZ1WV
	ZTPt/kRMfz4I1OI9jbnBfEPPcjqIsV91+JztN4O039dH8iOrF+LSZDQIg/eC7ORK5OdCdB
	BHlnl1zlJ8oBDtQeAdFsvSBOcaRnKm0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774360650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAGLYL98cn64Ar92fWklTYuP/kmnxLf6a5coknNhv6M=;
	b=GD1xGDXG/JXICr3cuKG33Ip0L3qH2zy04jzkr16/KofROeJj88/QQ80PeLAR+ZAnCw1Bqu
	ULgYEgSx/dukTsbmw8kHHl9z41A9t74OJUtnAhfUk4/NR38c/qZhlepC7ENzR+1u1duSaH
	KTeBg+IJVSVVz1ypYsvw/gA6dTQJTNQ=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgBRw5T95zJ46Zl;
	Tue, 24 Mar 2026 21:57:16 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id B4F9340086;
	Tue, 24 Mar 2026 21:57:23 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Mar 2026 16:57:23 +0300
Message-ID: <48580762-eec3-49b6-b17a-59fa486bebec@huawei-partners.com>
Date: Tue, 24 Mar 2026 16:57:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 1/1] This patch set introces a new action:
 DAMOS_COLLAPSE.
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <ljs@kernel.org>,
	<Liam.Howlett@oracle.com>, <vbabka@kernel.org>, <rppt@kernel.org>,
	<surenb@google.com>, <mhocko@suse.com>, <corbet@lwn.net>,
	<skhan@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <20260324003952.86819-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260324003952.86819-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7D3BE40005
X-Stat-Signature: ohdjj5asix4fwtx9pmzimusmqc3bom5h
X-Rspam-User: 
X-HE-Tag: 1774360650-891926
X-HE-Meta: U2FsdGVkX1+VdU5SLTQgKEm94HuZMNfMOhKgOUkDUFnFtC4v01qUYLVtd3CV7PM7uheQ3E2iBKC0PunTXNlcOTgHqVJDD7L9bJSx7h6f3+wnfXQqv4Iei4duQLf99R6m7SBkgZTjHSomMtzFL1/Jva8nA89C6yMIIuNmDhxDfvyYTA/HQhwXUqLga8dr5FUNtgQT+aOMhVy8qZlVXx2HiLTV+9jL7kTuhxoEmahzP5DlXJYQAXjXySkun6ooGkNOLNnWpYdEzhEgoZ/20eh1J6wDST9lRjHTf8pRnR0Zrp61VWoMkhTu0CF9RpKr+LBArpSWVi5YvanRgOOU2GNC3ozD/eHwrQ1L8eJcM58zPaHo+XpsfMfolJEKy2BeH0DTNTxbqWTXXKgG2d7Fj9r+BlVjoBzbrDXZF63aOzvXxo+58ydT1jTUBK/+w0n/QjOlAKm/2ZPyhW0n/jdrKSLZWTlyDIWCSBYzUITp8/CCtjMrH03/dZq6ckqtTX9PwgR5QF6UOGkPyXOirXE22zuXJLjVAB+lAQteX9nl1GWQLrUYNVjVFHIbC8Jf+/dbxPU1CyysnUWTm2bpj3CKJFzo6To1HfcwzXFF+W7gnaLGZv7O0rPJec5UCnvynPoyRRfofM/wJwZNw2ecsuFAQJOfGfc6WU4ArNjfILplivIvKG14yH5Kq3G0pDgFn46qXcN6n75zHtBdjHLfDn6AMRZp0M9BG4J3kXF8GMg8vPydWdMPBZ/N8qgWhqW1hFfph5QP36WGI1IPW+7EpqEZGaTr9dxuPMstPAhqk08/O6M595U9pPhk9aVoPdpPzUaxb1zUkTy9D8Jco97YBMBarkvLR2mJxdAXmJbC+c/Xr4IgSaLmd8FOt/hwNbP/kTPtqJx6kx/WmnztB5VowSaNdFD/P4Be6mAlNWlXTzRHuKq3rb9M6kbs+TkCyoWBWZ/b0404G5j9pTGJSYzWlFLLT6A
 DB7YIO3l
 k5f9r4l+jvCLgO7Frzbb+xQ2s5v9+IgDJ4R7y6vnE7JOQ+Zc7gw6kmuVErv+lRppv3YDCsTKlasPK/IvMMZ12pEfJAD/Kl5DlYblMLscGIAWXWd0uI50TwP75xh8pbnondAikJ7u6LVgGAnuyzHjL+Aj7u74AqSg4BXgmtcOOwBX+1WmBk5456u4AXk33mne7NjIUC+WvjlDtVRK/y2lN3XCcdx1eyhZjplm6llu/bKbfgL7JZeV4L79zFclof7jijLBXs0cJBZBNG/MOhXbTN89rGTovrYqb/iIYce3jVUMbNyvRkSPAyot8ZkhPgg/73uekVXd0/SPxDXrETI9zzL9exgF1CgysfOoDgYcY2TDVN1Syl0GV5g2IzDa6JVaPbmQo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 3:39 AM, SeongJae Park wrote:
> Hello Asier,
> 
> On Mon, 23 Mar 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
>> working, since it relies on hugepage_madvise to add a new slot. This
>> slot should be picked up by khugepaged and eventually collapse (or
>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
>> enabled, khugepaged will not be working, and therefore no collapse
>> will happen.
>>
>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
>> the address range synchronously.
>>
>> This new action may be required to support autotuning with hugepage as
>> a goal[1].
>>
>> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
>>
>> ---------
>> Benchmarks:
>>
>> T n: THP never
>> T m: THP madvise
>> D h: DAMON action hugepage
>> D c: DAMON action collapse
>>
>> +------------------+----------+----------+----------+
>> |                  | T n, D h | T m, D h | T n, D c |
>> +------------------+----------+----------+----------+
>> | Total memory use | 2.07     | 2.09     | 2.07     |
>> | Huge pages       | 0        | 1.3      | 1.25     |
>> +------------------+----------+----------+----------+
> 
> Thank you for sharing the benchmark results!  But, I'm having a hard time to
> understand what this really means.  Could you please further clarify the setup
> of the benchmarks and interpretation of the results?
I will fix the cover in the next version, which I will submit soon.

I tested the patch in a physical server with MariaDB 10.5. I run
sysbench to load the server.

I check 3 scenarios:
- DAMON action hugepage for the database task, THP as never
- DAMON action hugepage, THP madvise
- DAMON action collapse, THP never

I compared the memory consumption, both in overall in the server and
anonymous huge page consumption. The results are in the table

T n: THP never
T m: THP madvise
D h: DAMON action hugepage
D c: DAMON action collapse

+------------------+----------+----------+----------+
|                  | T n, D h | T m, D h | T n, D c |
+------------------+----------+----------+----------+
| Total memory use | 2.07     | 2.09     | 2.07     |
| Huge pages       | 0        | 1.3      | 1.25     |
+------------------+----------+----------+----------+
> 
>>
>> Changes
>> ---------
>> v1-v2:
>> Added benchmarks
>> Added damos_filter_type documentation for new action to fix kernel-doc
> 
> Please add Changelog on the commentary section [1].  Also, please consider
> adding links to previous versions.
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
>>  Documentation/mm/damon/design.rst      |  4 ++++
>>  include/linux/damon.h                  |  2 ++
>>  mm/damon/sysfs-schemes.c               |  4 ++++
>>  mm/damon/vaddr.c                       |  3 +++
>>  tools/testing/selftests/damon/sysfs.py | 11 ++++++-----
>>  5 files changed, 19 insertions(+), 5 deletions(-)
>>
>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
>> index 838b14d22519..405142641e55 100644
>> --- a/Documentation/mm/damon/design.rst
>> +++ b/Documentation/mm/damon/design.rst
>> @@ -467,6 +467,10 @@ that supports each action are as below.
>>     Supported by ``vaddr`` and ``fvaddr`` operations set. When
>>     TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
>>     fail.
>> + - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
>> +   Supported by ``vaddr`` and ``fvaddr`` operations set. When
>> +   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
>> +   fail.
>>   - ``lru_prio``: Prioritize the region on its LRU lists.
>>     Supported by ``paddr`` operations set.
>>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>> index d9a3babbafc1..6941113968ec 100644
>> --- a/include/linux/damon.h
>> +++ b/include/linux/damon.h
>> @@ -121,6 +121,7 @@ struct damon_target {
>>   * @DAMOS_PAGEOUT:	Reclaim the region.
>>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>> + * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
>>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
>>   * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
>>   * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
>> @@ -140,6 +141,7 @@ enum damos_action {
>>  	DAMOS_PAGEOUT,
>>  	DAMOS_HUGEPAGE,
>>  	DAMOS_NOHUGEPAGE,
>> +	DAMOS_COLLAPSE,
>>  	DAMOS_LRU_PRIO,
>>  	DAMOS_LRU_DEPRIO,
>>  	DAMOS_MIGRATE_HOT,
>> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
>> index 5186966dafb3..aa08a8f885fb 100644
>> --- a/mm/damon/sysfs-schemes.c
>> +++ b/mm/damon/sysfs-schemes.c
>> @@ -2041,6 +2041,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
>>  		.action = DAMOS_NOHUGEPAGE,
>>  		.name = "nohugepage",
>>  	},
>> +	{
>> +		.action = DAMOS_COLLAPSE,
>> +		.name = "collapse",
>> +	},
>>  	{
>>  		.action = DAMOS_LRU_PRIO,
>>  		.name = "lru_prio",
>> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
>> index b069dbc7e3d2..dd5f2d7027ac 100644
>> --- a/mm/damon/vaddr.c
>> +++ b/mm/damon/vaddr.c
>> @@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>>  	case DAMOS_NOHUGEPAGE:
>>  		madv_action = MADV_NOHUGEPAGE;
>>  		break;
>> +	case DAMOS_COLLAPSE:
>> +		madv_action = MADV_COLLAPSE;
>> +		break;
>>  	case DAMOS_MIGRATE_HOT:
>>  	case DAMOS_MIGRATE_COLD:
>>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
>> index 3aa5c91548a5..c6476e63f4fb 100755
>> --- a/tools/testing/selftests/damon/sysfs.py
>> +++ b/tools/testing/selftests/damon/sysfs.py
>> @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
>>              'pageout': 2,
>>              'hugepage': 3,
>>              'nohugeapge': 4,
>> -            'lru_prio': 5,
>> -            'lru_deprio': 6,
>> -            'migrate_hot': 7,
>> -            'migrate_cold': 8,
>> -            'stat': 9,
>> +            'collapse': 5
> 
> Comman is missed?
> 
>> +            'lru_prio': 6,
>> +            'lru_deprio': 7,
>> +            'migrate_hot': 8,
>> +            'migrate_cold': 9,
>> +            'stat': 10,
>>              }
>>      assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
>>      assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
>> -- 
>> 2.43.0
> 
> Other than the selftest part, code looks good.  Please consider dropping RFC
> tag from the next spin.  Clarifying more details about the test would be
> helpful, though.
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 
> Thanks,
> SJ
> 

SJ, should I remove the RFC tag for the next version?

-- 
Asier Gutierrez
Huawei


