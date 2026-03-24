Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5866EF54AC7
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 15:01:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6E66B008A; Tue, 24 Mar 2026 11:01:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70E46B008C; Tue, 24 Mar 2026 11:01:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE9996B0092; Tue, 24 Mar 2026 11:01:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 914B36B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:01:37 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5F28A1A017D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:01:37 +0000 (UTC)
X-FDA: 84581270634.28.910CBBA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB52314001C
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:01:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774364492; a=rsa-sha256;
	cv=none;
	b=J/DNdLKhtvJBhZg/nmbwR1qSzZvQMriTu0TpiQfaXDdt441eRtt9+ptzcl/3kk+FJ6JggF
	m5vAXbdIyyKUtLMmsktspMAAUjItJQgwzspIZIrr/9Mhl+2Opj2Z6jetDYM6je0RhooK3Z
	lDht9VKc6Nha8A/mOkaBTUtSayqkSnc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf26.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774364492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NQbYpiaVaJP4B52H3Nml6LdEH/x20Gxc4bJVWy/6bmM=;
	b=RZGzxfTnGTPUz7uTm55zOs+veZOGOjpasyAfjsohH5tfOWss+3B2i6D7r3SiWJ2jtKoyDQ
	UgwW7MPFKyMHpGhPkBoD6syrjO9rYWHS8o8n0G2enDgvMcZQMLelRevoBuYwnMuNHPQY7x
	2dD7Mwa7bohJFIDY5E3J74oYLXSzYgs=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4fgCsG50R3zHnGfl;
	Tue, 24 Mar 2026 23:00:50 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 3EA784056B;
	Tue, 24 Mar 2026 23:01:24 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 24 Mar 2026 18:01:23 +0300
Message-ID: <6a07479d-0ddb-442e-bc1b-027f4c6d3b77@huawei-partners.com>
Date: Tue, 24 Mar 2026 18:01:23 +0300
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
References: <20260324141257.91322-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260324141257.91322-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: bs1fswhxcwgj9ukzu1u4hfff6ysk5r1w
X-Rspamd-Queue-Id: AB52314001C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774364486-720981
X-HE-Meta: U2FsdGVkX1/DDm/hr7mTr9XzaK35dUf8+7k7EeswNEI03RyN0uHuDky/wVM+YivXSztOHoT+SbO1w3G5vssnPQHXaVMPa4VmR1miGM4oiQLwYBHcfg9dQ8RcYHRgH2qQndvUr7zuX8Pb1upxLBKt5SQxZugOedLALV1EgUIIxJgfOIwXh/DN7W3UQ3K1GLTkBHVCtuX9lPo9LDQBFEma5N1GlgrZWQARarIUe8arcAyQuw7Nl0AQtQaHavVEgXbQYiIMFT97cK0lyDCWvqWTeR1dIt2RvlFHmk+8MKgW4FrKpUnw22kMWXFI4uNo2ETNbVNoJBoaWmlzA9iycMgexB0SGOVtdoPt0FgFRHxYb0S1ubaLEtLTlvt/EOL4rsA20SZ1fgNSPUJQZozDK3883hLq26LJKCPN+SCJoC2Vr5mnVBz4PzA3fys7GvAW7awax7IHxvQNEN6heBDxA60GnTKVCNWeC1icFaCe2Mcvpuds2R5gcH9t5DArBprR+eOP6jUyLTUkEWXfzYpeFOSzfGjRdMDqzR94JdoW3iGpykFqIILhafD1OchTWz70ygcZXaqLBduh/W9rp2vgTwNZCqduX1ejY5tvwfKyZFvHoB1k1eyx2Fp6iK2YJTRzc1q78OIX/OJZ5BJn2wdYvVdZWce6f76DMVgIyYnmKrax+20JifOKoAea4QQOW1cUWF5M8eXljGxIHxdbw5JVnd36HINbzt5UINk/8vrwX1fGOBrP/Fg5LYM1zE2mmVhCLwhK16r7IT+EnFRsftaMlu+DjyMma6ElHHdZ1VxLykzmDXR8QZakyAjEOZgkAbFceqej2Vsp6OZZuMRL9VzJoGfVfQ5i8PdirYio5MFslGj0czrQwcD2Rr6jCJ3uiMYUCZ2QL7SKb4YPfZQrirDSyMeAXXZ6mvqazpAQcbErkEE3CVsi+u2mKi6458PRfYEmVJoZy3bWVel7xB1ykN9SVVM
 XuhJt2Hp
 N3kvHfdNe9RVHPD4AnjxfpieN1rcBb1vUZN+bUcoVw8d9EBDo5xBRmaNSW6UcTcodnDmrnsEzQdfVFxfZPgHFdBOsTSKEkpDLZsCv+ETAWdTs30dEdT1g0EZspRd7x8UYkef32pmm/YrkB4fxJVYQp2bejZAyBvhmv6j/mgD62I5mM6BuGbgAL+VUg6nF6rb1PfFKOV4UheLw1RIWhfV99+vpiGERJlYmHn3Dj9hO5sAiSNn1u70GvuIjKzeA7CG2OzlfkZudAZgviLYIxSJgdb1ixwZ5TPWSrnS84UjvlJL/TFkLg/1e+pl9kvpeDqACZIKK1LXiQqM7hJEWdwcxALtHPFK9fTt3Y4thokpVc8WMmcYgjtWT2z6tSaIU40rci65fh7ER/b7s4jfcK4AYSCTA58x7ugMifUwAry5Cp+KjmxFsjugIr83Fc8TPEuZjL8O7VIE56lTTk0TZnBh+ei34iPpomoY9wHi7XXWdxQKmrXxz8HOastLkqbrB7TgU+NPginL2wFngBxlFnOLHe+l56vYPlji0ypyNRUlMApyJhmtUEpCal3awNruoNcl5HIGN9XO2ik6ZbXbUr030ma1DtjTZ3e1DKSbLIvn8SJtQtUa5n7VCR+w77CzTuQEPIJwpCheJahAFKbz55fkBsrqdmkK5qRd9VVqz3JLp+xEA/HnvVk9Nndh5Ssj64OMMu9PYjUljmQM6CQr8Oc+bO/haQAUTCZTmy69Kv7fxWdUAvVfzb5aZFARnICpERkkSxaSHoQ/uzVUMaEfLlINo9F2nJ8t0i0nTqE33qwCRc7c+fh9YzRMDDAzKC4f4hZKsWv+nKcJzXwS/RhAIVKaXmEOhSAwwwDYX30VuhGjgBo4GSYck1w+++J4Tzgp3/Pk1AlErZFPiNn5zWWgKCmExgMi+TVL5zyML3rGfQyilJdVpIg+1JC8lhbt3Ibb9FYw0xZiOk/54rk19X38CPMEnWlM8Sfdm
 9dHN5ASu
 MP3h/UQWJ3+Bb+ABO+cFuTTg4uX4TW6uNTckolTqjcgyPt9vTPqSOfayrY7Enao0Wv5OgckVz3DWSH1fOZBNXk36jfQ6Og3eo4kxV2Od+bA9OyJ6lMXsHHeL+h6o4tbc9RPBi98obiMg7NRnmoZGnj4CmTJgmG49W5KNWETz38/Ljbd6j4XTNPV56Du6PCXcaYt/e/Oz9g4J1DN15jB2fLgonpqX15uTLsWqG37yMTRewpKYj2D3Q5LfCxqIlX1ZwXNDRLJxF8GwqCvN93NCjVFzp1b1Ybun9hSmPpJuoAumzvyd4BLI7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/24/2026 5:12 PM, SeongJae Park wrote:
> On Tue, 24 Mar 2026 16:57:22 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
>>
>>
>> On 3/24/2026 3:39 AM, SeongJae Park wrote:
>>> Hello Asier,
>>>
>>> On Mon, 23 Mar 2026 14:56:45 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>>
>>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>>
>>>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
>>>> working, since it relies on hugepage_madvise to add a new slot. This
>>>> slot should be picked up by khugepaged and eventually collapse (or
>>>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
>>>> enabled, khugepaged will not be working, and therefore no collapse
>>>> will happen.
>>>>
>>>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
>>>> the address range synchronously.
>>>>
>>>> This new action may be required to support autotuning with hugepage as
>>>> a goal[1].
>>>>
>>>> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
>>>>
>>>> ---------
>>>> Benchmarks:
>>>>
>>>> T n: THP never
>>>> T m: THP madvise
>>>> D h: DAMON action hugepage
>>>> D c: DAMON action collapse
>>>>
>>>> +------------------+----------+----------+----------+
>>>> |                  | T n, D h | T m, D h | T n, D c |
>>>> +------------------+----------+----------+----------+
>>>> | Total memory use | 2.07     | 2.09     | 2.07     |
>>>> | Huge pages       | 0        | 1.3      | 1.25     |
>>>> +------------------+----------+----------+----------+
>>>
>>> Thank you for sharing the benchmark results!  But, I'm having a hard time to
>>> understand what this really means.  Could you please further clarify the setup
>>> of the benchmarks and interpretation of the results?
>> I will fix the cover in the next version, which I will submit soon.
>>
>> I tested the patch in a physical server with MariaDB 10.5. I run
>> sysbench to load the server.
>>
>> I check 3 scenarios:
>> - DAMON action hugepage for the database task, THP as never
>> - DAMON action hugepage, THP madvise
>> - DAMON action collapse, THP never
>>
>> I compared the memory consumption, both in overall in the server and
>> anonymous huge page consumption. The results are in the table
>>
>> T n: THP never
>> T m: THP madvise
>> D h: DAMON action hugepage
>> D c: DAMON action collapse
> 
> Thank you for sharing the details of the setup, Asier.
> 
>>
>> +------------------+----------+----------+----------+
>> |                  | T n, D h | T m, D h | T n, D c |
>> +------------------+----------+----------+----------+
>> | Total memory use | 2.07     | 2.09     | 2.07     |
>> | Huge pages       | 0        | 1.3      | 1.25     |
>> +------------------+----------+----------+----------+
> 
> Could you please further share interpretation of the results?  What these
> results mean?  Does it show some benefit of DAMOS_COLLAPSE?

In the first row is the total memory consumption in GB by the server
and in the second row the huge page consumption.

What this table shows is that DAMON action "hugepage" doesn't lead
to any hugepage collapse unless THP is set to madvise. If DAMON
action is set to "collapse", hugepage collapses happen, even when
THP is disabled. The memory consumption for DAMON "collapse" is
slightly lower than with "hugepage", since madvise applies to the
entire server and other application may request to collapse pages
through madvise.

Regarding the performance, I saw improvement from no hugepage at all
to use of hugepages. No significant difference between "hugepage" and 
"collapse" actions. I will have a look to the logs and publish it a bit
later.

> Also, how is the performance?  Does it show some difference?
> 
>>>
>>>>
>>>> Changes
>>>> ---------
>>>> v1-v2:
>>>> Added benchmarks
>>>> Added damos_filter_type documentation for new action to fix kernel-doc
>>>
>>> Please add Changelog on the commentary section [1].  Also, please consider
>>> adding links to previous versions.
>>>
>>>>
>>>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>> ---
>>>>  Documentation/mm/damon/design.rst      |  4 ++++
>>>>  include/linux/damon.h                  |  2 ++
>>>>  mm/damon/sysfs-schemes.c               |  4 ++++
>>>>  mm/damon/vaddr.c                       |  3 +++
>>>>  tools/testing/selftests/damon/sysfs.py | 11 ++++++-----
>>>>  5 files changed, 19 insertions(+), 5 deletions(-)
>>>>
>>>> diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
>>>> index 838b14d22519..405142641e55 100644
>>>> --- a/Documentation/mm/damon/design.rst
>>>> +++ b/Documentation/mm/damon/design.rst
>>>> @@ -467,6 +467,10 @@ that supports each action are as below.
>>>>     Supported by ``vaddr`` and ``fvaddr`` operations set. When
>>>>     TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
>>>>     fail.
>>>> + - ``collapse``: Call ``madvise()`` for the region with ``MADV_COLLAPSE``.
>>>> +   Supported by ``vaddr`` and ``fvaddr`` operations set. When
>>>> +   TRANSPARENT_HUGEPAGE is disabled, the application of the action will just
>>>> +   fail.
>>>>   - ``lru_prio``: Prioritize the region on its LRU lists.
>>>>     Supported by ``paddr`` operations set.
>>>>   - ``lru_deprio``: Deprioritize the region on its LRU lists.
>>>> diff --git a/include/linux/damon.h b/include/linux/damon.h
>>>> index d9a3babbafc1..6941113968ec 100644
>>>> --- a/include/linux/damon.h
>>>> +++ b/include/linux/damon.h
>>>> @@ -121,6 +121,7 @@ struct damon_target {
>>>>   * @DAMOS_PAGEOUT:	Reclaim the region.
>>>>   * @DAMOS_HUGEPAGE:	Call ``madvise()`` for the region with MADV_HUGEPAGE.
>>>>   * @DAMOS_NOHUGEPAGE:	Call ``madvise()`` for the region with MADV_NOHUGEPAGE.
>>>> + * @DAMOS_COLLAPSE:	Call ``madvise()`` for the region with MADV_COLLAPSE.
>>>>   * @DAMOS_LRU_PRIO:	Prioritize the region on its LRU lists.
>>>>   * @DAMOS_LRU_DEPRIO:	Deprioritize the region on its LRU lists.
>>>>   * @DAMOS_MIGRATE_HOT:  Migrate the regions prioritizing warmer regions.
>>>> @@ -140,6 +141,7 @@ enum damos_action {
>>>>  	DAMOS_PAGEOUT,
>>>>  	DAMOS_HUGEPAGE,
>>>>  	DAMOS_NOHUGEPAGE,
>>>> +	DAMOS_COLLAPSE,
>>>>  	DAMOS_LRU_PRIO,
>>>>  	DAMOS_LRU_DEPRIO,
>>>>  	DAMOS_MIGRATE_HOT,
>>>> diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
>>>> index 5186966dafb3..aa08a8f885fb 100644
>>>> --- a/mm/damon/sysfs-schemes.c
>>>> +++ b/mm/damon/sysfs-schemes.c
>>>> @@ -2041,6 +2041,10 @@ static struct damos_sysfs_action_name damos_sysfs_action_names[] = {
>>>>  		.action = DAMOS_NOHUGEPAGE,
>>>>  		.name = "nohugepage",
>>>>  	},
>>>> +	{
>>>> +		.action = DAMOS_COLLAPSE,
>>>> +		.name = "collapse",
>>>> +	},
>>>>  	{
>>>>  		.action = DAMOS_LRU_PRIO,
>>>>  		.name = "lru_prio",
>>>> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
>>>> index b069dbc7e3d2..dd5f2d7027ac 100644
>>>> --- a/mm/damon/vaddr.c
>>>> +++ b/mm/damon/vaddr.c
>>>> @@ -903,6 +903,9 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
>>>>  	case DAMOS_NOHUGEPAGE:
>>>>  		madv_action = MADV_NOHUGEPAGE;
>>>>  		break;
>>>> +	case DAMOS_COLLAPSE:
>>>> +		madv_action = MADV_COLLAPSE;
>>>> +		break;
>>>>  	case DAMOS_MIGRATE_HOT:
>>>>  	case DAMOS_MIGRATE_COLD:
>>>>  		return damos_va_migrate(t, r, scheme, sz_filter_passed);
>>>> diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
>>>> index 3aa5c91548a5..c6476e63f4fb 100755
>>>> --- a/tools/testing/selftests/damon/sysfs.py
>>>> +++ b/tools/testing/selftests/damon/sysfs.py
>>>> @@ -123,11 +123,12 @@ def assert_scheme_committed(scheme, dump):
>>>>              'pageout': 2,
>>>>              'hugepage': 3,
>>>>              'nohugeapge': 4,
>>>> -            'lru_prio': 5,
>>>> -            'lru_deprio': 6,
>>>> -            'migrate_hot': 7,
>>>> -            'migrate_cold': 8,
>>>> -            'stat': 9,
>>>> +            'collapse': 5
>>>
>>> Comman is missed?
>>>
>>>> +            'lru_prio': 6,
>>>> +            'lru_deprio': 7,
>>>> +            'migrate_hot': 8,
>>>> +            'migrate_cold': 9,
>>>> +            'stat': 10,
>>>>              }
>>>>      assert_true(dump['action'] == action_val[scheme.action], 'action', dump)
>>>>      assert_true(dump['apply_interval_us'] == scheme. apply_interval_us,
>>>> -- 
>>>> 2.43.0
>>>
>>> Other than the selftest part, code looks good.  Please consider dropping RFC
>>> tag from the next spin.  Clarifying more details about the test would be
>>> helpful, though.
>>>
>>> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
>>>
>>>
>>> Thanks,
>>> SJ
>>>
>>
>> SJ, should I remove the RFC tag for the next version?
> 
> If you feel comfortable with it, please do so.
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


