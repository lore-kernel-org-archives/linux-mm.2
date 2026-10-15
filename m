Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DA99CC6B1C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 03:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 733CA6B0092; Wed, 14 Oct 2026 23:50:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD1F6B0095; Wed, 14 Oct 2026 23:50:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 586896B0096; Wed, 14 Oct 2026 23:50:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 34A236B0092
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:50:09 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB27B1A08E6
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:50:08 +0000 (UTC)
X-FDA: 85323482496.01.2163478
Received: from va-1-111.ptr.blmpb.com (va-1-111.ptr.blmpb.com [209.127.230.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id 348801C0003
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:50:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iHdBvxLs;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792036207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6Om/DEKPFgRQsjS9jvWBk11FC4wZN19UjaH+0CqwpAI=;
	b=m7S4pGH4Y5xKjH6nziZ4tndqjZfqzMg8uIIWH6XRq5y5q4PbEJf/a16+e5h9Zl2nJWGwyW
	C66rtg/73rpzqCTCzKoUYlNwYQdomvaVIvD1VLvYpf7nJeMq67kNFWAyhkcv+Tgs+ujkqW
	11IvVu9WPDgOTS29AXBM+NGihg4i8Vw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iHdBvxLs;
	spf=pass (imf18.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.111 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792036207;
	b=yx+YTfGxa9EYLnLCtunwTtduyK/+Gk/Aig4oCgTRAA3FHtpKg7YgZ4TdgG0QXG9Z3nBV9i
	rKtgSd9W6EN1Ac2TLiekQC1DhlFQSKP7Ogf/tF7Hy0pBLnNBxzEhTg156Q33oW1pUjW2HG
	QDRbkcbIrar27aAtNHlfOYTb+1PIPb0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1792036201; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=6Om/DEKPFgRQsjS9jvWBk11FC4wZN19UjaH+0CqwpAI=;
 b=iHdBvxLsCe6VKML1UDBIVBEVbKFLo8DnofGbc4InJp/VkH0NorH0ufmuscxP1G7twAATN3
 CmP83p9NDUhyYjKXCOGEFWpO0Sdc6uTwB/sS0Iu29+9CbcUPQtprMYn+eO0+7zA8+RU3oD
 +/ixsno8GJFxYEblRSEGPkIkwFu+FaD+D1HwhXIUgf3K2611v/KUQF7xzmL1X/ViYqQ6+z
 uhKlDrO+TLma9gYWn5K0atgx0XV89Y1EEBUZEncqHVch85+t1pw4ljwQDuOUF331ViIOYr
 OPltrvhl65RsendTykWgj3U/3aTJSc8ajUuu0ODrlRwdZH50JDHkr83CFKX6Uw==
Date: Thu, 15 Oct 2026 11:49:34 +0800
Message-Id: <4231150e-ea20-473b-bec7-cf2787c1b567@bytedance.com>
User-Agent: Mozilla Thunderbird
To: "Gregory Price" <gourry@gourry.net>
Subject: Re: [PATCH 2/6] sched/numa: fix scan-period ratio denominator checks
From: "Li Zhe" <lizhe.67@bytedance.com>
In-Reply-To: <as97rD5uxYva4ayg@gourry-fedora-PF4VCD3F>
References: <20261014094347.99157-1-lizhe.67@bytedance.com> <20261014094347.99157-3-lizhe.67@bytedance.com> <as97rD5uxYva4ayg@gourry-fedora-PF4VCD3F>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, <mingo@redhat.com>, 
	<peterz@infradead.org>, <mgorman@suse.de>, <riel@redhat.com>, 
	<juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26ad04d66+daffea+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 348801C0003
X-Rspam-User: 
X-Stat-Signature: ao4z678zreyg1aso4ubd15epqmeendue
X-HE-Tag: 1792036206-621713
X-HE-Meta: U2FsdGVkX1+L9/uYKJEkBtDTUcHGHTWOPevtApk3fkE/DS0yXCGuqU00hGKYuiQHUO43SwQoolc0Xh7AAi5q9SGirvT2hG28LPU4/qZMUCuemD4ruYC/Z1W6RnNuA6cnyAXiHa0iT5cB+bleXkI8Ts4HS3gFc8Q4K6l0nA63rHxIJEi6mJwP8Pp2/L/wnjXnmragPhZ2Vw5oOuwRJMZoVgPJh/oZjo2u1XFLGsuu+MTBHyK+muQGvAhtM5NRv6sSzU45ItwXx+53SJts7VFfC0QMW30FSRaHaaXStIfp4OgzxUY4SPvdcnjNvErSzyeY+NLitbq0xgXcT4jXaMo3iJ3TCeKLN+tA82qLMNYdt5ErXNTl5MIWo77KL+TI/PoX5eqLuARAk7dYk8G2a/aKv9bU6YOnj5691YvETlQcR0p1TpwsiI/YYJzkPXhRgtDxDThSdK6bEzuItExOQrCaUH2BLkIZGcCrDnqLU3sE1BttvAeelND8bcfFkjlUke6A6zGwFZwwLygZrMRGOJf+x6T5CDk/9acIgcGtkWavaNeIlxMxV78nM77/5eSOcl/aYDDMuVDNcVFu4wWcMOC9M715NjAhgPOvThTBCCbxRk1mRVZUMafx31lwGnD+B00zePE5fBu63Crg/IZCaLfDsZ2MbIp7H5hslRhjfuSFtDnCMByFpzYiwFM/AeieA44YTbzXYiD+1IpN28DUXWYpARM4kbxbMMiDWCzcNH+2m8vt2Ym978UwRT8IhrCobW9CjzgZAPgQ2oCeSGMKZYProJ132WN28tBz4I3WkR1KZ9jyhHXZZ6DRWjZBVAMbPDW+Xm9Din8dTkREYE7RggE7Z9ulW6y+PypZTvUmGQC8f+zja62wUQU9unRgsdFhJc6UF/l/q0jU3PGIhPbrhLiSvNAyghIFk8av3yvWMtTDXyvcm2Elm5ZEi/5lFvpz12js5j88K7r3tMuGtQFp6XQ
 KgzLmIhf
 tkCNEvdkSMzBhGx8vLGHMJVcJyzzzM6kJoYe0o9uVTN3jezOAcERCZyelbeYXKbQyUVNiO2lgT1qRmMBnpjR1evyJ08s/g3fi6AQlONJFRcf/w4XxPS1ZBqRwrY4zbwG9O0oahwGQ8M/ZHwRzjVhjIsTn7IxfyJ3pUgXkLpYda0VooAOFMJjSryEK/ff/m6P0dWHFc8GWaGz2aTOzELDc5zkPwC6eusAwXOHKpeeoONMWHJj5kFYARctyyHH0zfncvYJr4q0oq6KOwN3lw/MCDE88EjVgWChxrCWe9cylA940A0LBKPnka/bC2UPmDZ2wFF7GpoIEvqU/yiMQmlrkPtAJ4nAf2GbP1ACP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/26 8:56 PM, Gregory Price wrote:
> On Wed, Oct 14, 2026 at 05:43:43PM +0800, Li Zhe wrote:
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 1053437933ee..76532b8202dc 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3698,6 +3698,8 @@ static void update_task_scan_period(struct task_struct *p,
>>   
>>   	unsigned long remote = p->numa_faults_locality[0];
>>   	unsigned long local = p->numa_faults_locality[1];
>> +	unsigned long locality_faults = local + remote;
>> +	unsigned long type_faults = private + shared;
>>   
>>   	/*
>>   	 * If there were no record hinting faults then either the task is
>> @@ -3706,7 +3708,7 @@ static void update_task_scan_period(struct task_struct *p,
>>   	 * migration then it implies we are migrating too quickly or the local
>>   	 * node is overloaded. In either case, scan slower
>>   	 */
>> -	if (local + shared == 0 || p->numa_faults_locality[2]) {
>> +	if (!locality_faults || !type_faults || p->numa_faults_locality[2]) {
>>   		p->numa_scan_period = min(p->numa_scan_period_max,
>>   			p->numa_scan_period << 1);
>>
> This does more than just change the div/o below, it changes the behavior
> of the function overall.  It's not clear to me this change is correct.

Yes, this intentionally changes the fallback condition.

The old local + shared check mixes two independent dimensions. The
ratios below are computed from local + remote and private + shared, so
those are the denominators that decide whether the sample is usable.

The old check can also classify a pure remote-private window as an
unusable sample: local == 0 and shared == 0, while remote and private
are non-zero. That is exactly the kind of signal that should go through
the normal scan-period decision, since commit 37ec97deb3a8 wanted to
speed scanning up only when many private faults are on remote memory.

So the fallback is meant to be used when one of the actual ratios cannot
be computed, i.e. when local + remote == 0 or private + shared == 0.
Otherwise the sample should not be discarded before the ratio logic.

Thanks,
Zhe

>
>> @@ -3723,8 +3725,8 @@ static void update_task_scan_period(struct task_struct *p,
>>   	 *	 >= NUMA_PERIOD_THRESHOLD scan period increases (scan slower)
>>   	 */
>>   	period_slot = DIV_ROUND_UP(p->numa_scan_period, NUMA_PERIOD_SLOTS);
>> -	lr_ratio = (local * NUMA_PERIOD_SLOTS) / (local + remote);
>> -	ps_ratio = (private * NUMA_PERIOD_SLOTS) / (private + shared);
>> +	lr_ratio = (local * NUMA_PERIOD_SLOTS) / locality_faults;
>> +	ps_ratio = (private * NUMA_PERIOD_SLOTS) / type_faults;
>>   
> This otherwise looks fine.
>
> ~Gregory

