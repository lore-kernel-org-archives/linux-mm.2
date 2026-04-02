Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FB1CC6B00
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 06:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CCAD6B0089; Thu,  2 Apr 2026 02:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D456B008A; Thu,  2 Apr 2026 02:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA1F6B008C; Thu,  2 Apr 2026 02:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28A786B0089
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 02:24:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BE6291A04CB
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:24:18 +0000 (UTC)
X-FDA: 84612626196.22.649E473
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1CE7120008
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 06:24:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aiWV8iIP;
	spf=pass (imf03.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=aiWV8iIP;
	spf=pass (imf03.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775111057; a=rsa-sha256;
	cv=none;
	b=pPm/I5xh53tBFjpmySSC8oaiaY+kPwg2j8uncjIwEiZ0bBVvrwJ/AEhnKkNgadjLbF1Vi+
	zcGMJQCFwCah/qimlnjrpYESnYYWl0FU0EV8aCSo0wOujgwTkGIzcT+/trhCbo4Go1rCK9
	tPkzL2elVKaWTX14M2Dv+QYGKUF7eE0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775111057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMbp+sYgjyqgg8Rmn7tnpa9mpV75dW1kYsbpBQmfGWo=;
	b=SLphsrp1xWKL6DcTImQ+kOSHBZJeAc42XjnBTKnXWFkCM7WpRiUp6jUumvUHloh/fyKA7J
	LcwQGv3tNK4/mXSaiPe5L84HmukqP16fPoiaKqqy143/CkYPkBlgSE6LDUdM5C2ilugngb
	AqLeqNVXvDtpoklbn4NYn1+Yv+4FLZY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1775111052; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=YMbp+sYgjyqgg8Rmn7tnpa9mpV75dW1kYsbpBQmfGWo=;
	b=aiWV8iIPf+un6mrBrqQFSroikJgvnL06r417vwRRtOv+bMTymPLGwXa5LTqn/mr1gtihbdBLuBwcrCfFecdUjCS5PSuEDboIlrX+mECtfOxPKXMkIhhy7yDRHijHocEDlPy+GjIui2wxpnx0NRCZsMPyFKsohv7gNvatiGll7Tg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0X0GC4RJ_1775111051;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0X0GC4RJ_1775111051 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 02 Apr 2026 14:24:11 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Donet Tom <donettom@linux.ibm.com>
Cc: David Hildenbrand <david@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Ingo Molnar <mingo@redhat.com>,  Peter
 Zijlstra <peterz@infradead.org>,  Ritesh Harjani <ritesh.list@gmail.com>,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Baolin Wang
 <baolin.wang@linux.alibaba.com>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  Juri Lelli <juri.lelli@redhat.com>,  Mel
 Gorman <mgorman@suse.de>
Subject: Re: [PATCH v2] memory tiering: Do not allow promotion if
 NUMA_BALANCING_MEMORY_TIERING is disabled
In-Reply-To: <c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com> (Donet Tom's
	message of "Thu, 2 Apr 2026 10:29:39 +0530")
References: <20260323094849.3903-1-donettom@linux.ibm.com>
	<87wlyqt52m.fsf@DESKTOP-5N7EMDA>
	<c571bb69-82f2-4346-9f99-6a7258e28a27@linux.ibm.com>
Date: Thu, 02 Apr 2026 14:24:11 +0800
Message-ID: <87o6k1ubg4.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CE7120008
X-Stat-Signature: jd6ren41unr6b9dbccug7s9genfgdc75
X-Rspam-User: 
X-HE-Tag: 1775111055-825512
X-HE-Meta: U2FsdGVkX18BTx0D1tN81zWNQat5FyCQ59s5YOacJNaUYue+ntMNvFrwKhKVTMHpL80kPczNux5AuXWR/7nLf2EUztE3KUUAAnPnpfQkaG9TM1Tl4l7MOL83g2t09UEI+11MOYeZnziJq4zDO4S6ZkkpyQtKW/GkJW8M3kRrs1xQvG/g5svYwRZHFip0vMsB6NQ7fz5IVj4pydrCLecnE7aj7zkjejvamONboB2GShILj1cHl6S080Rej2MCLUd5CyxC/hnfGJYJU9m4G68azTsGl0ezMu1iNEg1oJgxniG3+7OVthxLOemar9lHwtLpXKWXQaPy8Z2XvWR5WuBjKzTMYqBIxpeSgaxVr3qYEid9YSwNrEcIdVUzHOn29IN77BUwwfFEvBXcJilhY9p/DlGBwdE9RLEN5BHbs3kn2/9//9Hdef0R40Lezov0Fhr+fwt+udxE21Yf/CHMcv8E9gVUV8YL0PLpKQu0OnlPr020bbk/mWUOppKRywAm0N78fnxaQsxdfy3eo5NXYgHsM/AHKsp62VddfH2ZythajzDZu8mioFwCTrkKLCSgdXE6VbOJjC6aWQLYk23Ql2tzovWn6SmvCsMWE0oGkZ92I7Y9vAOufTV+7F6eyx+XQo5vj3fAnXtiJgpMEtVqD8LipdB/53rlv9bdxZvQJ3kxZX1esh910y6gdxzkWMWfOVKIn7xApSXiHvrfb9ukIr4n+jgB9+zrqF0c6di68yxHT3fS4C9KUrvCk5V4K6h7iQWUIqxgk7wwuTrjL6FUvvcPoe6EGqifUirMlMedlgGjCnzBojac/0B1CuawuH0w+GKpKc6EykLNFgDKTBTexBy1tsihZTbq5f3ytXrBDO7z63taGBIY5KKbFuJLwYNcSgKbRsV8ksyYOB4fqaL7xWCmM3jx8MFEjJBMqqUuNkVUIUEjMrdPgwqqZz0pQxxW1Qgk+/MS6/3kdmtV4Dp5ekR
 lI7RLmHD
 9qlDJdY56pcB6DDTSsbzPCC7wriphLGv+UGzTNiW9K8bBq1d0uZxZlRGGT4Kxgw/aiXcFOCnh2VbrfSIsei/83ZbNPT+p2EHTh3GaZGUFDOlBUoYilVPg67QJq/ZLOPMHyf4/YIffD8I2vpTr3lcUUDtXhaY8kmK/8nJ05BuYoq2F+QLzdqmI/pQfSnFtJbS4Q2NwcrrVrBfr8shx0GKSzIWC3PFtI0MtvG0dyORD5baoMUV29hMaOfuB4zECYWmTXXHOWppv+whkU8lNb8pqRXbB0lNQ23stZdJLaZmuP11WwU48vcbH5/QixrZeLiyLv1aulT1TOpp+piNH2NTm8S7dTFQ0ue+28CvBGBaDqoDqYyUUdj5uI3vUxUBvcdvZwiJeazThSvkha6v8xiiXd/7nB02zhSzCsHMN1mqPEuvxF8KNQCaMjpmVqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Donet Tom <donettom@linux.ibm.com> writes:

> Hi

Hi, Donet,

> On 4/2/26 8:57 AM, Huang, Ying wrote:
>> Donet Tom <donettom@linux.ibm.com> writes:
>>
>>> In the current implementation, if NUMA_BALANCING_MEMORY_TIERING is
>>> disabled and the pages are on the lower tier, the pages may still be
>>> promoted.
>>>
>>> This happens because task_numa_work() updates the last_cpupid field to
>>> record the last access time only when NUMA_BALANCING_MEMORY_TIERING is
>>> enabled and the folio is on the lower tier. If
>>> NUMA_BALANCING_MEMORY_TIERING is disabled, the last_cpupid field
>>> can retains a valid last CPU id.
>>>
>>> In should_numa_migrate_memory(), the decision checks whether
>>> NUMA_BALANCING_MEMORY_TIERING is disabled, the folio is on the lower
>>> tier, and last_cpupid is invalid. However, the last_cpupid can be
>>> valid when NUMA_BALANCING_MEMORY_TIERING is disabled, the condition
>>> evaluates to false and migration is allowed.
>>>
>>> This patch prevents promotion when NUMA_BALANCING_MEMORY_TIERING is
>>> disabled and the folio is on the lower tier.
>>>
>>> Behavior before this change:
>>> ============================
>>>    - If NUMA_BALANCING_NORMAL is enabled, migration occurs between
>>>      nodes within the same memory tier, and promotion from lower
>>>      tier to higher tier may also happen.
>>>
>>>    - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from
>>>      lower tier to higher tier nodes is allowed.
>>>
>>> Behavior after this change:
>>> ===========================
>>>    - If NUMA_BALANCING_NORMAL is enabled, migration will occur only
>>>      between nodes within the same memory tier.
>>>
>>>    - If NUMA_BALANCING_MEMORY_TIERING is enabled, promotion from lower
>>>      tier to higher tier nodes will be allowed.
>>>
>>>    - If both NUMA_BALANCING_MEMORY_TIERING and NUMA_BALANCING_NORMAL are
>>>      enabled, both migration (same tier) and promotion (cross tier) are
>>>      allowed.
>>>
>>> Fixes: 33024536bafd ("memory tiering: hot page selection with hint page fault latency")
>>> Signed-off-by: Donet Tom <donettom@linux.ibm.com>
>>> ---
>>> v1 -> v2
>>> ========
>>> 1. Dropped changes in task_numa_fault() since the original changes
>>>     already handle runtime disabling of NUMA_BALANCING_MEMORY_TIERING.
>>>
>>> v1 -> https://lore.kernel.org/all/20260320092251.1290207-1-donettom@linux.ibm.com/
>>> ---
>>>   kernel/sched/fair.c | 6 +++++-
>>>   1 file changed, 5 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index bf948db905ed..4b43809a3fb1 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -2024,8 +2024,12 @@ bool should_numa_migrate_memory(struct task_struct *p, struct folio *folio,
>>>   	this_cpupid = cpu_pid_to_cpupid(dst_cpu, current->pid);
>>>   	last_cpupid = folio_xchg_last_cpupid(folio, this_cpupid);
>>>   +	/*
>>> +	 * Do not allow promotion if NUMA_BALANCING_MEMORY_TIERING is disabled
>>> +	 * and the pages are on the lower tier.
>>> +	 */
>>>   	if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIERING) &&
>>> -	    !node_is_toptier(src_nid) && !cpupid_valid(last_cpupid))
>>> +	    !node_is_toptier(src_nid))
>>>   		return false;
>>>     	/*
>> No.  Even if NUMA_BALANCING_MEMORY_TIERING is disabled, we should still
>> allow migrate pages from lower tier to higher tier via
>> NUMA_BALANCING_NORMAL.  If we have precious DDR, why waste it?  This
>> follows the semantics of NUMA_BALANCING_NORMAL before introducing
>> NUMA_BALANCING_MEMORY_TIERING.
>
> Thank you for the review comments.
>
> One thing I am trying to understand is that page promotion
> appears to happen regardless of whether
> NUMA_BALANCING_MEMORY_TIERING is enabled or disabled. In that
> case, what is the specific role of
> NUMA_BALANCING_MEMORY_TIERING? Do we get better performance
> when it is enabled?

You can search NUMA_BALANCING_MEMORY_TIERING to find out what it does.
We can get better performance as the original commit message says.

When NUMA_BALANCING_MEMORY_TIERING is introduced, we didn't change the
original behavior of NUMA_BALANCING_MEMORY_NORMAL because we had no good
reason to do that.  In fact, you change its behavior, so you should
provide some supporting data or bug report to justify the change.

> My initial understanding was that disabling
> NUMA_BALANCING_MEMORY_TIERING could be used to turn off
> promotion. However, it seems that currently we cannot control
> promotion independently. If NUMA_BALANCING_NORMAL is disabled,
> neither migration nor promotion happens, and if it is enabled,
> both migration and promotion can occur.
>
> I was under the impression that:
> - NUMA_BALANCING_NORMAL would handle migration within the same tier,
> - NUMA_BALANCING_MEMORY_TIERING would handle promotion across tiers,
> - and enabling both would allow both migration and promotion.
>
> This would provide more fine-grained control. Is my
> understanding correct, or am I missing something here?

You can change this, if you have some supporting data or bug report.

---
Best Regards,
Huang, Ying

