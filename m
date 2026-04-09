Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B0DF364A0
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 17:01:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DBA66B0005; Thu,  9 Apr 2026 13:01:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68C736B0088; Thu,  9 Apr 2026 13:01:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57B2B6B008A; Thu,  9 Apr 2026 13:01:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 427AA6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 13:01:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D76C61A08D7
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:01:10 +0000 (UTC)
X-FDA: 84639632700.06.8787CE6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0B43A100026
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 17:01:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hw8QJZXj;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hw8QJZXj;
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775754069; a=rsa-sha256;
	cv=none;
	b=nVH+D+EoIAPsg37oLvKS+YUDFgnsjUwZWw6EhF5DLST6bmauKErt816gIOzyyHE9FlXE9b
	1MmKYNkKQU/qiYS5nTT7wdh1/Sk1SUjMdmMRPUxfOk4DKrB0R/zYV+oQ79fnRSusTSizkj
	kPR2fK92ZZZfQeZ0qA3pTdlYs0FR6z4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775754069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Xp1yAyByb+meT+jdfJQgxP+Q+P6R1SDArB30IHs2tM=;
	b=zbNLm2IDQgpIOcVCoS8EyrwCBcZtFAAG09mxIwUZWiMpz89ex6/vg5L2gEkYbptfESb+0T
	iHcR5+BEEHinkalMD0ozdRb1ICjlFVc8aSNbJQo+f5nxJGjBqIv1FBLwGTvRBC0MGmvH6e
	DofKc2OAAwmCeLx+xgkgkeVkljTXGNo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 32E2360103;
	Thu,  9 Apr 2026 17:01:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EF1C4CEF7;
	Thu,  9 Apr 2026 17:01:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775754067;
	bh=vpM1p9ulFwkMeX6amQbAGlMHW7aiCUgASpTF7AU0vA0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hw8QJZXjTX2OaAUte2QPQNb/SI5CU8gtmzAs5q1zKUAa9jrkl780bwqp5a+Rm2+jY
	 TQS9ynebRxWSpO+4XyYObpmh8Iy6ywSsdXQH+ixBm2HZugeubmwNKDfyb9+xpvXIVe
	 wtXVBuvFscwu6I2i/O7ItLjUrsAAia9QQs8zR50365kJ12ie3RQ/knWQcYWeuoU8bO
	 gOVNIlwMk6X4Ie4k7X1CSa3vnZBXgoZD0zYvUaG1mqKzGyawxfUW50B11oWfnW/oDd
	 vywsyo6MjEzmeoRZNjRWBHQ5kuPmT5GjTGSNYyPIV6JdAv14rCmCv9zEgEWEEOnlzN
	 fXEEoS8OsPcUw==
Message-ID: <7cf39b82-ff21-4d9e-b2fd-1636c3e203ce@kernel.org>
Date: Thu, 9 Apr 2026 19:01:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/vmstat: fix vmstat_shepherd double-scheduling
 vmstat_update
Content-Language: en-US
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Christoph Lameter <cl@linux.com>,
 Dmitry Ilvokhin <d@ilvokhin.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
 shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
References: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260409-vmstat-v2-1-e9d9a6db08ad@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0B43A100026
X-Stat-Signature: 3itrmo7dhf9jdym1q459977gxqmr53ja
X-Rspam-User: 
X-HE-Tag: 1775754068-220892
X-HE-Meta: U2FsdGVkX1/FKs8BEFFuLQxHvN4ZFLMM+zBuuMRk/LujAvjJDMM4FrkWuBgJK73v3v/JmqEGchFiSW9JQdIIx5JNWYcVS64WRt8pZk2U+T96IeVmy/VjmvGTM23GAV5pFMGxlrtcvygwTIw7NMGWwOYzZQZNdEQjnx852ZBaqwTCHoyYUYHp/KiS9DLIKCDt9zqFzQ1O1GFcJ63sFoQH6UHLJDVLrJGN8F5R4hiwsOKU4XY52/9aMyt30bZhk+HR5Bwt+/mW0168HrvqkosngLQfHYUiHKwgwAsp+yzwRkiEZZM2epp3tZvpCYD4EqMEzMuaV9IRshRGrxGZK71gX0+EQvuYjCVRmO7zF7Ae6AEJqsLbqZd6TQ0W54Aa16YamQwnZzyzzHxxiCAFsTR5EreMpgFuq4Er10J5XCI2CdQfiYaD8unBi8P1Lt+/GedvtfSC39SV5JeXSlWQioKl5oGdLxnWi2Q6QUyRnBcOjghUagTPJ0Ug57flggfajdoVdSfM1hTFr8EgfwZsTewkrFbfNCQDDn04+5efjQ0dqf0Zs2RDD99zou8JeO4+4yMuhcMwxb4BJLkMEo6RwzBAHAkkmAXAzLhDSBtRZuJgH4sQXeuryOBVqCfLZNE8bDT3yzqTmg3ntI0xRIfSGh9TukfJ2zWkqfFkgvR7PfJxIAZTvSn5d6wKF8yLX/B/sH9qMNs10GYKSURniISSC6YtztG/3rw15ViLxqc1aMyH0CBRd6mPD6TtpBDb4pKa5yO20LEL7cmmDqMb5fj3QUkRsKHjt0O8/OHmIUHhjxupWTMpvBZw+8TMDC/rgCppl28WLFe7En6xV+Xc9KEIcYuhRaWw3BHhpupEn0VYuIxAFj5l3zrgeHmRFit2AaoIITiN5z/YorCwDNixgmUotTCSMiobE0zF5XUR/AcKmpHbjGZSCth2dJGz8+qyYmewbgE9X2S7nxyYxQ2saSaXpLG
 E8/zo7DK
 y3WJzCVIrNN/jgXC9zEqBQlQOAGqWESzm9cEThcMPGvxGMIBA9wdVK3tCX+gdNzdy3umvOeF6CPbt1dNnXKa5t9x8giFlNWDN+enTM9WAs1Cso7ZXSjO/tYCECLIOz4VICIb0dbWZv5jnLXQZm/YqT85AIKxPKyf5umgUfwOMvAQvAU7LWxNFUia9DPYBYdQeCaoaakDFLK09y+6XHW0MQxVCgi0FyVNJDQdvues/i7EIVR6NruQdXnIig4602lJ4/Hq5qgybJMXQ+mhQI1u0AWxTgEaRGXJjct1p3oUt+/nz7Vo8pON1Wqi6xQAfUPET+irvBYmXh50PDMRXGhr06z3gtudhZL5yjVhntilJpdsrOBttmElvZUiWfg8ELhxQ9DODOyFaTRbS05GyPrgNYpJX5yWFZavWia3EsHhcVfY5d35hKVCSCX2Gh+XlSvDUkhdtjPJ4HUmOlW6ySccjtxZnxwWZ9I9ecUghmBjvciYBkkt3KZK4dEHmGy2ZexA8M6hkScRt5Jh0Y7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 14:26, Breno Leitao wrote:
> vmstat_shepherd uses delayed_work_pending() to check whether
> vmstat_update is already scheduled for a given CPU before queuing it.
> However, delayed_work_pending() only tests WORK_STRUCT_PENDING_BIT,
> which is cleared the moment a worker thread picks up the work to
> execute it.
> 
> This means that while vmstat_update is actively running on a CPU,
> delayed_work_pending() returns false. If need_update() also returns
> true at that point (per-cpu counters not yet zeroed mid-flush), the
> shepherd queues a second invocation with delay=0, causing vmstat_update
> to run again immediately after finishing.
> 
> On a 72-CPU system this race is readily observable: before the fix,
> many CPUs show invocation gaps well below 500 jiffies (the minimum
> round_jiffies_relative() can produce), with the most extreme cases
> reaching 0 jiffies—vmstat_update called twice within the same jiffy.
> 
> Fix this by replacing delayed_work_pending() with work_busy(), which
> returns non-zero for both WORK_BUSY_PENDING (timer armed or work
> queued) and WORK_BUSY_RUNNING (work currently executing). The shepherd
> now correctly skips a CPU in all busy states.
> 
> After the fix, all sub-jiffy and most sub-100-jiffie gaps disappear.
> The remaining early invocations have gaps in the 700–999 jiffie range,
> attributable to round_jiffies_relative() aligning to a nearer
> jiffie-second boundary rather than to this race.
> 
> Each spurious vmstat_update invocation has a measurable side effect:
> refresh_cpu_vm_stats() calls decay_pcp_high() for every zone, which
> drains idle per-CPU pages back to the buddy allocator via
> free_pcppages_bulk(), taking the zone spinlock each time. Eliminating
> the double-scheduling therefore reduces zone lock contention directly.
> On a 72-CPU stress-ng workload measured with perf lock contention:
> 
>   free_pcppages_bulk contention count:  ~55% reduction
>   free_pcppages_bulk total wait time:   ~57% reduction
>   free_pcppages_bulk max wait time:     ~47% reduction
> 
> Note: work_busy() is inherently racy—between the check and the
> subsequent queue_delayed_work_on() call, vmstat_update can finish
> execution, leaving the work neither pending nor running. In that
> narrow window the shepherd can still queue a second invocation.
> After the fix, this residual race is rare and produces only occasional
> small gaps, a significant improvement over the systematic
> double-scheduling seen with delayed_work_pending().
> 
> Fixes: 7b8da4c7f07774 ("vmstat: get rid of the ugly cpu_stat_off variable")
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Looks like v2 posting raced with Dmitry adding R-b tag to the posting in v1
thread:

https://lore.kernel.org/all/adebKQaiAP4G3liv@shell.ilvokhin.com/

> ---
> Changes in v2:
> - Instead of changing the timings, do not double-schedule.
> - Link to v1: https://patch.msgid.link/20260401-vmstat-v1-1-b68ce4a35055@debian.org
> ---
>  mm/vmstat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 2370c6fb1fcd6..cc5fdc0d0f298 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -2139,7 +2139,7 @@ static void vmstat_shepherd(struct work_struct *w)
>  			if (cpu_is_isolated(cpu))
>  				continue;
>  
> -			if (!delayed_work_pending(dw) && need_update(cpu))
> +			if (!work_busy(&dw->work) && need_update(cpu))
>  				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
>  		}
>  
> 
> ---
> base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
> change-id: 20260401-vmstat-048e0feaf344
> 
> Best regards,
> --  
> Breno Leitao <leitao@debian.org>
> 


