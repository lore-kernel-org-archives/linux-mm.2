Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A435B10F6FD6
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 15:50:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA3316B0005; Wed,  1 Apr 2026 11:50:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E54056B0088; Wed,  1 Apr 2026 11:50:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A026B0089; Wed,  1 Apr 2026 11:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2B9A6B0005
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 11:50:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 67B6016092D
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:50:15 +0000 (UTC)
X-FDA: 84610423590.23.2D401F6
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3DF0D40014
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 15:50:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="luC/chPf";
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775058613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tIZAcYqdA6GrIHmU/xfIR+EG2WmYL1cpIUsbse0D6I=;
	b=DfMmnoB0YSYd/nqwHHT2gxPNrfv9MP8+1nh5Mc9HwPkcQV+2AYJ9qizfdPSMjmg40KVkNx
	fECpYE0ND7JzRoOK9X4tkpTEPz02o8gElVTk5YOTSsxSi4Ahiac4Y2hhHv5zuRayMug2dk
	1viswqjN5qFvkue+XJARABtOEJZDGDk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775058613; a=rsa-sha256;
	cv=none;
	b=2J7J5Are4Fz9v7YhFxBnOz0liIHDraoS7ony6PExthFK37ulLp2E8qXCVeYYh1cr9mlGnF
	wr9VFqBIY6AuxUA8PXzE/JGErTzm+4G1080aWXUqcUyLvcIz0HxLvz+XBgkOPeTNiEy9MB
	l+iTgoWGjLplGbx+CCMPH5TP7D3ZM6k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="luC/chPf";
	spf=pass (imf27.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <8ede5e20-9309-4d1a-8f12-13603fd92014@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775058610;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4tIZAcYqdA6GrIHmU/xfIR+EG2WmYL1cpIUsbse0D6I=;
	b=luC/chPf0F7PM3uPuRnFdGRXycwcFQ0t5/WHBlGLpgP7l+GiJNIYa7ZN95YouGXaRXbf8s
	bmgU5hT8XUJx0YzvZlfsRwyC6iWTvOYFCErdCBztxLLrVPoxoz7bDh3Uei5JNM31g6NgDk
	Yyw5VGDNSqlLJBxBGb91v3ffO1sNlpE=
Date: Wed, 1 Apr 2026 16:50:03 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
Content-Language: en-GB
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
 shakeel.butt@linux.dev, kernel-team@meta.com
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <20260401152343.3294686-1-usama.arif@linux.dev> <ac08dcv31J5_lAHs@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ac08dcv31J5_lAHs@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: rg4w9e7a8g7omh34peyt6csyywqwuahg
X-Rspamd-Queue-Id: 3DF0D40014
X-Rspam-User: 
X-HE-Tag: 1775058612-798278
X-HE-Meta: U2FsdGVkX19NViqnCuJUOw5Lv42/o9prqeHt+J0qZideSXhdwjQnCtVoBCbaF4a23Jq6VcMUjXBQYQHR+rznL95XiWCxXEE3OPoflNAhxx57w90yO3wbpyTBNuptGIcdtiZFoG5QeIkx6vDKP2lSfPm2VCnDf+UAGSz9uWLMXMVda0sCE6msonE/O/Y2ppjIZbpRhMwt9sF9y10NWrvWefaXXfaygOUQbfsYdCvb4DgGqoQcf+5YBzcnRdknOvGLPLVUe56RqdSvY+rMC00Dx94C4549xX6hsmzUksTbNJMgcF/1DK8OUujIEgwpCxIUx2YgRWe0FZUA8/LqjmrpmeaPw7lZ+CKemAw9LQtQ8FWRdXyLcui15ghEuMUphLGci5wRcx1BUyLMwzNy5Q6sw3WSQBbEyYWQrTsdBSTVV5QxxkDvV/CkOmGTp1b5H3d7KIZMk7M8FPF8erm7qhcJY5b1oyeKOMyxiqK1gv9g9YT9MdJqUsFwegYSkaE8n6F/MaJqepTiPaYpfHK1tX+S025uVhYcOjo4SjUe/bCG0Ov/ramJW6NF+Tfv1ZNjnXARpAN07NTnWPEaK4GhYzoMUjowVfGhGP8B1Fw7Z6ToV7ZwCPhXSz9TM1DdRCPLvEvk1Ey0+1wqrP85rATZJj+vryWafzO9s+Nux5pSLYbNhGBLtW6LHYPXHWhj9V+F8MruQXbJlCIeTX8eNCnV3cQhmA5/+K3/8t+9cEarSjAhJ5a3sFRVbxMoQ7XPM0t28ZFwG7PrZ1sTXbwHucfqwsY7kSY2zTYasgXmk7LXEyNPQZTiyd4vik/wgcuQTpnfLHmcCnlQsQDMpVqckccWn2qayJVKjhEwo8oYwm6KmDZ5obRywxMNWQAAPdalvWnsITmpr7y7jXHXWvRjgKA4l/Xyg/3m2X3/8NWLjyPURv9XFT8CrGQ0DCVbFhhIvDd8Xd6ZIWxuntjdwptOjMQ3mwC
 KgzdCNHD
 LxIcM1IzMTeonW623MFw6mLnjBVhwaadZuJUGtGYqbz4EpX0fLxf4/6POLxXimdKeIa6yPkRes1fK+X8t7sfi70Tx8M0+69cbzswOqkxTAMZFPpADmXn7o0CnlMGsIa33JDD66cPiN+FIX5fmGaauzjDuAqgqt1/HZMiRe2NP3qBmOr7MinuDMlWCZR8BoupWFpuhTUUL65qJdp8hclVQlFB8MpH7Z5k4fNrTq2Cmug8YZ3xHCZ9wh2g0RAoyHtUmR5ZA8xqhvHrYTINBHFjiDGFPeSysrVOmfFltiBUvuKXQpyltVLja1w88sg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 01/04/2026 18:43, Breno Leitao wrote:
> On Wed, Apr 01, 2026 at 08:23:40AM -0700, Usama Arif wrote:
>> On Wed, 01 Apr 2026 06:57:50 -0700 Breno Leitao <leitao@debian.org> wrote:
>>
>>> vmstat_update uses round_jiffies_relative() when re-queuing itself,
>>> which aligns all CPUs' timers to the same second boundary.  When many
>>> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
>>> free_pcppages_bulk() simultaneously, serializing on zone->lock and
>>> hitting contention.
>>>
>>> Introduce vmstat_spread_delay() which distributes each CPU's
>>> vmstat_update evenly across the stat interval instead of aligning them.
>>>
>>> This does not increase the number of timer interrupts — each CPU still
>>> fires once per interval. The timers are simply staggered rather than
>>> aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
>>> wake idle CPUs regardless of scheduling; the spread only affects CPUs
>>> that are already active
>>>
>>> `perf lock contention` shows 7.5x reduction in zone->lock contention
>>> (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
>>> system under memory pressure.
>>>
>>> Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
>>> memory allocation bursts.  Lock contention was measured with:
>>>
>>>   perf lock contention -a -b -S free_pcppages_bulk
>>>
>>> Results with KASAN enabled:
>>>
>>>   free_pcppages_bulk contention (KASAN):
>>>   +--------------+----------+----------+
>>>   | Metric       | No fix   | With fix |
>>>   +--------------+----------+----------+
>>>   | Contentions  |      872 |      117 |
>>>   | Total wait   | 199.43ms | 80.76ms  |
>>>   | Max wait     |   4.19ms | 35.76ms  |
>>>   +--------------+----------+----------+
>>>
>>> Results without KASAN:
>>>
>>>   free_pcppages_bulk contention (no KASAN):
>>>   +--------------+----------+----------+
>>>   | Metric       | No fix   | With fix |
>>>   +--------------+----------+----------+
>>>   | Contentions  |      240 |      133 |
>>>   | Total wait   |  34.01ms | 24.61ms  |
>>>   | Max wait     |   965us  |  1.35ms  |
>>>   +--------------+----------+----------+
>>>
>>> Signed-off-by: Breno Leitao <leitao@debian.org>
>>> ---
>>>  mm/vmstat.c | 25 ++++++++++++++++++++++++-
>>>  1 file changed, 24 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>>> index 2370c6fb1fcd..2e94bd765606 100644
>>> --- a/mm/vmstat.c
>>> +++ b/mm/vmstat.c
>>> @@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
>>>  }
>>>  #endif /* CONFIG_PROC_FS */
>>>
>>> +/*
>>> + * Return a per-cpu delay that spreads vmstat_update work across the stat
>>> + * interval.  Without this, round_jiffies_relative() aligns every CPU's
>>> + * timer to the same second boundary, causing a thundering-herd on
>>> + * zone->lock when multiple CPUs drain PCP pages simultaneously via
>>> + * decay_pcp_high() -> free_pcppages_bulk().
>>> + */
>>> +static unsigned long vmstat_spread_delay(void)
>>> +{
>>> +	unsigned long interval = sysctl_stat_interval;
>>> +	unsigned int nr_cpus = num_online_cpus();
>>> +
>>> +	if (nr_cpus <= 1)
>>> +		return round_jiffies_relative(interval);
>>> +
>>> +	/*
>>> +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
>>> +	 * use round_jiffies_relative() here -- it would snap every CPU
>>> +	 * back to the same second boundary, defeating the spread.
>>> +	 */
>>> +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
>>> +}
>>> +
>>>  static void vmstat_update(struct work_struct *w)
>>>  {
>>>  	if (refresh_cpu_vm_stats(true)) {
>>> @@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
>>>  		 */
>>>  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
>>>  				this_cpu_ptr(&vmstat_work),
>>> -				round_jiffies_relative(sysctl_stat_interval));
>>> +				vmstat_spread_delay());
>>
>> This is awesome! Maybe this needs to be done to vmstat_shepherd() as well?
>>
>> vmstat_shepherd() still queues work with delay 0 on all CPUs that
>> need_update() in its for_each_online_cpu() loop:
>>
>>       if (!delayed_work_pending(dw) && need_update(cpu))
>>           queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>>
>> So when the shepherd fires, it kicks all dormant CPUs' vmstat workers
>> simultaneously.
>>
>> Under sustained memory pressure on a large system, I think the shepherd
>> fires every sysctl_stat_interval and could re-trigger the same lock
>> contention?
> 
> Good point - incorporating similar spreading logic in vmstat_shepherd()
> would indeed address the simultaneous queueing issue you've described.
> 
> Should I include this in a v2 of this patch, or would you prefer it as
> a separate follow-up patch?

I think it can be a separate follow-up patch, but no strong preference.
For this patch:

Acked-by: Usama Arif <usama.arif@linux.dev>


