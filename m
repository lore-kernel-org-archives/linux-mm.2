Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7A79D25051
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 08:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15FA46B0088; Mon, 12 Jan 2026 03:30:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117A76B0089; Mon, 12 Jan 2026 03:30:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F916B008A; Mon, 12 Jan 2026 03:30:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E5BF46B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 03:30:50 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FD931B87E
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:30:50 +0000 (UTC)
X-FDA: 84322641060.28.BCFF92C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf19.hostedemail.com (Postfix) with ESMTP id 72FF51A0006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 08:30:47 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768206648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3JX1O+9LZrPvnpGh1HgvwB9ZEk5sAQSjWM6oT2xhmOs=;
	b=dWDTtjujVu4VO/Ln58O8+s7cvA+h5La/0y3WKzZUvhPH7l1ZnxHR8CWeKAKXvL9BfqeWuf
	Mfd8p58mHwgN63lDbxzVBQdOTSkRhS/35aKLEPaQLWCP4okoiRGJ91lideMw1BacFhEd/e
	Q8Ap9e413PMz2HZxwG+i7Y8KIA7FC9s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of gladyshev.ilya1@h-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gladyshev.ilya1@h-partners.com;
	dmarc=pass (policy=quarantine) header.from=h-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768206648; a=rsa-sha256;
	cv=none;
	b=IISkRbA6fX7T2dn3t/pVwJ2EpJg0/hPpxg7MYyDn9CJMiJc+jueBDwwpO/zGSAOVdD/aCt
	6mP3TV5LaBiJu8mQ2u4j6MiYPAq1GyasVyA2G4Jq7F9CM02Ocp27nV7wjgj/3YIoqbAPWI
	ywjKSEFoPkVmJ9QwAWHBfzzhHqU6xN0=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4dqQYc2qxdzHnH78;
	Mon, 12 Jan 2026 16:30:28 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 0AE8C40572;
	Mon, 12 Jan 2026 16:30:44 +0800 (CST)
Received: from [10.123.123.67] (10.123.123.67) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 11:30:40 +0300
Message-ID: <ec023298-c26d-437b-a023-b49509f83c5a@h-partners.com>
Date: Mon, 12 Jan 2026 11:30:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] mm: improve folio refcount scalability
To: <gladyshev.ilya1@h-partners.com>
CC: <guohanjun@huawei.com>, <wangkefeng.wang@huawei.com>,
	<weiyongjun1@huawei.com>, <yusongping@huawei.com>, <leijitang@huawei.com>,
	<artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<alexander.grubnikov@huawei.com>, <gorbunov.ivan@h-partners.com>,
	<akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>,
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ziy@nvidia.com>,
	<harry.yoo@oracle.com>, <willy@infradead.org>, <yuzhao@google.com>,
	<baolin.wang@linux.alibaba.com>, <muchun.song@linux.dev>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
References: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
Content-Language: en-US
From: Gladyshev Ilya <gladyshev.ilya1@h-partners.com>
In-Reply-To: <cover.1766145604.git.gladyshev.ilya1@h-partners.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.67]
X-ClientProxiedBy: lhrpeml100011.china.huawei.com (7.191.174.247) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: u74rk9uno1dmz97rcmt4s6qbiswfymh6
X-Rspam-User: 
X-Rspamd-Queue-Id: 72FF51A0006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768206647-387210
X-HE-Meta: U2FsdGVkX1/DoYcAQenhLJl0uKkhSXHr0H9NupxJX4i+mRqFPDKek+HsiCfwgaweVh3wubOJng39TdmTMem0osqr3THaJO4fNq9BdD+4pA4naBNwxJ/CfwcXxN4EJ3E5nKfnHnhdkqXfkcqT8COpynWfHNodxSzZWNMZekwX49lhIc+t/vl3fjeiKPqLNd52ZbrE35/v4XogALoOrLSKzpG8PIOAO6SNbai3uNoWT4lINWoNkJMjqaIFBsy7b9p6ui0A2kMQUxak4EKrnqpcwIs3kOTdRXP+txllCOFlanwBARnZNKg8b0Ym4ovC+35KmhVW9WusZHZbuMBEaMP0/fPGdSacwaGO0Juajg/9V+AvRf+jC2+bv2Jh4slgpFPM/Xc+sbU4poQ9dgENhptXp5iwDg15vLwJL5EemlYBUSuzsDmQ0a9ejK0XU9awkmfc17mSPSJ7swsZK4pUMPPPdQ94o4mbaYO1pklL4ecJ5ClAweHQAAvAfPAIp8+J0kDG4fg0Q4fORm+D0ZCC8Sfhw1lkjqJUwERffmoQeJeBXOkgvYxQBsl29awM+s8OsPnuwLa1rjkC6daXsGEMNadYPlR3BcG4tD8+rCp8aimntVP0Ujq/2tUmXEKgvcO9R18lQDpzxj/FU3qkRhABQYnBeqzQBDZlvPGzM8Led+YVygvTSvllVFbOOg6wLhylF+HF+HjaGRX6bj5sRKN2ISccuXrcXDbZud+YGp/XxzDDRaW46+0RCIyWC58XOK6lZoDwpoi/3Rjfq3GZsYD4/9UhRWE4RsYQ6Pnq2NOk883+grH4/Z+4XFKHKf/5n9wamAiKGpwQOyeLyV+ZjsQtOhuBRdpOsLxHwFG7SoVzDpp0vN2veIYYsdeH8hOfKCtAtHNg4yJUq7nGMrzH7n/e9VE0oHFHB0j5hqdnlIOCtRaDhN4u5EebGIQlHRjnA+R35mSyYQDszgVK+Ydk7rz/eFW
 iJGTwUCd
 Fl86JAYAKYxpZTtpZWzpcTu/bX3wmOeD9MJ3s9l95Xp922fL+J8oCEKHtRLdJ44QftoVxx5i/g0CPjiWjccBfc9DRviE/kCyzj+L4PfE5P4zuoq8aLjySB/hutKBqJTNOfiDK+l/jPnHWsbr0pIvy2luvP2U3igDq3SBD9IK9OnJRsyOd14ZoPT/Yi2tpWOSJSOIFGQla0IH93PsubOR3dsl1mYHVI68qRk3jM/atEqWgOKPFE0BbDSpvmOwQFM6ki3Q70D5ugX1BZQx/uDCP5gkFQ4hWevIepzyC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping on this proposal

> Intro
> =====
> This patch optimizes small file read performance and overall folio refcount
> scalability by refactoring page_ref_add_unless [core of folio_try_get].
> This is alternative approach to previous attempts to fix small read
> performance by avoiding refcount bumps [1][2].
> 
> Overview
> ========
> Current refcount implementation is using zero counter as locked (dead/frozen)
> state, which required CAS loop for increments to avoid temporary unlocks in
> try_get functions. These CAS loops became a serialization point for otherwise
> scalable and fast read side.
> 
> Proposed implementation separates "locked" logic from the counting, allowing
> the use of optimistic fetch_add() instead of CAS. For more details, please
> refer to the commit message of the patch itself.
> 
> Proposed logic maintains the same public API as before, including all existing
> memory barrier guarantees.
> 
> Drawbacks
> =========
> In theory, an optimistic fetch_add can overflow the atomic_t and reset the
> locked state. Currently, this is mitigated via a single CAS operation after
> the "failed" fetch_add, which tries to reset the counter to a locked zero.
> While this best-effort approach doesn't have any strong guarantees, it's
> unrealistic that there will be 2^31 highly contended try_get calls on a locked
> folio, and in each of these calls, the CAS operation will fail.
> 
> If this guarantee isn't sufficient, it can be improved by performing a full
> CAS loop when the counter is approaching overflow.
> 
> Performance
> ===========
> Performance was measured using a simple custom benchmark based on
> will-it-scale[3]. This benchmark spawns N pinned threads/processes that
> execute the following loop:
> ``
> char buf[]
> fd = open(/* same file in tmpfs */);
> 
> while (true) {
>      pread(fd, buf, /* read size = */ 64, /* offset = */0)
> }
> ``
> While this is a synthetic load, it does highlight existing issue and
> doesn't differ a lot from benchmarking in [2] patch.
> 
> This benchmark measures operations per second in the inner loop and the
> results across all workers. Performance was tested on top of v6.15 kernel[4]
> on two platforms. Since threads and processes showed similar performance on
> both systems, only the thread results are provided below. The performance
> improvement scales linearly between the CPU counts shown.
> 
> Platform 1: 2 x E5-2690 v3, 12C/12T each [disabled SMT]
> 
> #threads | vanilla | patched | boost (%)
>         1 | 1343381 | 1344401 |  +0.1
>         2 | 2186160 | 2455837 | +12.3
>         5 | 5277092 | 6108030 | +15.7
>        10 | 5858123 | 7506328 | +28.1
>        12 | 6484445 | 8137706 | +25.5
>           /* Cross socket NUMA */
>        14 | 3145860 | 4247391 | +35.0
>        16 | 2350840 | 4262707 | +81.3
>        18 | 2378825 | 4121415 | +73.2
>        20 | 2438475 | 4683548 | +92.1
>        24 | 2325998 | 4529737 | +94.7
> 
> Platform 2: 2 x AMD EPYC 9654, 96C/192T each [enabled SMT]
> 
> #threads | vanilla | patched | boost (%)
>         1 | 1077276 | 1081653 |  +0.4
>         5 | 4286838 | 4682513 |  +9.2
>        10 | 1698095 | 1902753 | +12.1
>        20 | 1662266 | 1921603 | +15.6
>        49 | 1486745 | 1828926 | +23.0
>        97 | 1617365 | 2052635 | +26.9
>           /* Cross socket NUMA */
>       105 | 1368319 | 1798862 | +31.5
>       136 | 1008071 | 1393055 | +38.2
>       168 |  879332 | 1245210 | +41.6
>                 /* SMT */
>       193 |  905432 | 1294833 | +43.0
>       289 |  851988 | 1313110 | +54.1
>       353 |  771288 | 1347165 | +74.7
> 
> [1] https://lore.kernel.org/linux-mm/CAHk-=wj00-nGmXEkxY=-=Z_qP6kiGUziSFvxHJ9N-cLWry5zpA@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20251017141536.577466-1-kirill@shutemov.name/
> [3] https://github.com/antonblanchard/will-it-scale
> [4] There were no changes to page_ref.h between v6.15 and v6.18 or any
>      significant performance changes on the read side in mm/filemap.c
> 
> Gladyshev Ilya (2):
>    mm: make ref_unless functions unless_zero only
>    mm: implement page refcount locking via dedicated bit
> 
>   include/linux/mm.h         |  2 +-
>   include/linux/page-flags.h |  9 ++++++---
>   include/linux/page_ref.h   | 35 ++++++++++++++++++++++++++---------
>   3 files changed, 33 insertions(+), 13 deletions(-)
> 


