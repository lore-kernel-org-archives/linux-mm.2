Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E10D3941D
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 12:40:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295236B0088; Thu,  2 Apr 2026 08:40:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26CB36B0089; Thu,  2 Apr 2026 08:40:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA1A6B008A; Thu,  2 Apr 2026 08:40:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3846B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 08:40:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1DE013B599
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:40:48 +0000 (UTC)
X-FDA: 84613574976.16.22E603A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id F190C4000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 12:40:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Keh6EsuO;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775133647; a=rsa-sha256;
	cv=none;
	b=jPCO0u4K9u/T1gDFX7LvE5st9CD/pTVwE6ndEvXLI20d3B3RnonugAC5CjuGIMLkraa4ln
	kNgwoXeDrtgWB6GNE+7iOtL5t/uSuE2IIXwJTBo0s/OHi7m6d7gC6g/sDBcKNUOEsgvU4M
	Z2de1Qy3CHY8FjfR1XzQ8IHIuC+hQys=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775133647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLA05bBe6rRZN24pSZJeCaHi7t53jEaZTHgPn6KuNuc=;
	b=wqX/T9Y4FGjTIQ2JhKRnNzgrNMxGz4ZqANN7xAZsBnwQ17hRu2Aov1pwj26JxKybxYzUUf
	c3/uRyuurrD8UnzT/C/pBx+uMV6ILSd40akj1dQgQLUNftxts390MycixgoJJTz5HHHeU+
	RLq+FwCH/cNVPN/d5VC+sScb1V2hbGQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Keh6EsuO;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 45ECE6187D;
	Thu,  2 Apr 2026 12:40:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B01CC19423;
	Thu,  2 Apr 2026 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775133646;
	bh=XYeq/PNjyN9HI+842/AHDGKzcK+nvNQ4ceQ2oKePnds=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Keh6EsuOB14aDnPKmGZxn8GvBhSg0AkRYDDA/mzz6BEuCd30UWuNQ1etMqXWdkYU/
	 vBLJfLWNTtSw5UYBWCHZ44KE4IlRlSLyVw1vRd0vO1aC04VI83RC0DjCZ/MGVBdv46
	 8NKcYAZ7RusqRFBvY6WaMW68MegqH4HvuyY0/pf2xuwory48HklD9nY5Lfm4VrAoJi
	 sY5AU3xQQ0zD5Ug55D07OrKz4mFufyw57QS/06bPwuQJwprxF5olIrj2VpVMcBX+WH
	 GPp8tAQM/Fg4aYfeYYgSsT0gDPTVBccCmt2nb5pfeSI2wl9elDz2BPdIXnTyVvHVmi
	 l3Vh3P6Qo8RKA==
Message-ID: <a55afddd-8c6b-4a7a-bfd9-5140013c764c@kernel.org>
Date: Thu, 2 Apr 2026 14:40:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/vmstat: spread vmstat_update requeue across the stat
 interval
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kas@kernel.org,
 shakeel.butt@linux.dev, usama.arif@linux.dev, kernel-team@meta.com
References: <20260401-vmstat-v1-1-b68ce4a35055@debian.org>
 <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
Content-Language: en-US
In-Reply-To: <fa089716-1bed-478b-96e3-a2ef5465b52f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F190C4000E
X-Stat-Signature: howympm33jok8sara8whgm1na8bu4se6
X-HE-Tag: 1775133646-187756
X-HE-Meta: U2FsdGVkX1/0/wXP1cMWiDGXs3ggu2o52OoavmF5uJQE9Ef/UNAY9FL2jYahWo6bxNnsaaBD7Z0PBaSr/tvvug73Fpqw0wbfx4gFUG/8Wq1j+3+zIMlRyCHjWFX3EaDCdAn4bIrb+UWr4hYPMBM5NGZtw2C9lEYLyNXIBi29XGMeINLP8jh9U6AZBdFveSuqxVB9RKy9T9nQ6nTCKd8fhgbQ7HDv++TQ6Lehu1OJCRpVT1YLpAaK5GSgPNKdnIgcK7fu+vHVCDTu1n3111Nh35NKkGZywBSSe7kIiLGn390Tl3930M7adJD3NpUF8SSk/f8hz8pQ454unRJPP7FSNeLNY5Z2egQvZD/svyA0+5OVr1mbFEDIZgUHbfz31/uirbq7+OsisIqOqnvFVnVv/A4ZTju+9SlfTXf/cQfVJKAMwyeKhSlXwbT8D7Y/G4A63N6eOSng0y4MqPCExqxVZGttbnpiThc7OwTBnj9f+TTQY22iuuxNPsueDxL6E65eMQ2Dxc+ofES3plN8QTHJIQK2Rdlekwm9ot6y95jLq1h4ld/Al7gh9DnscfMyRwjS1rZ5zidxfu9bUsWC8lpxI0gSStb690XFAYM4G2a5Zy4kgrg1ZF2gfk1wFBN72M+oCEyHgsl4qAxWgyD7Voxdm5j4F64pJLtSEtMHL6lJ3G1XozGPU3rYgKPhDPHm6h8NsSaBiB18QdKrUD6A9/la8++R1Mol1V+RuPxGqJinOpBrnM00iMjj72iEfxwaeCECT7ro/TVKZw+ikDZyuETUTxH11qu5p/NHqny6vucbfuPE3yob3MgU7gWmTtHu5GvRmPJDwoslnp8sBCEAWzyjofudpHk9vJxVwsUM+FIvrVENnK+ju2BW4yfSWqae6+yvOwpFF/uIJA6Ih5jON9OrSO1kumroiNHkkL0qTL2KO8MhEAsL+S6dMZO7azcqe/A6kEUE/1f2paXvHSR7P26
 zJkNKvQf
 qG+jt5IMO3qJcTORlZO99tRcG7euxWVGwJ1uKe1j/Rb1eB64LKdc7kpNDPAspU+TRfFJbvhsqSdh0RrULwuZ1Ymi8Z/btc4cbSKRqc1k4K0IgjL0zOcGEPdX74zzZ5qDzCqdu90/jnBhOe9p1UjzGM7hdoPhmRVuPrjyInJ4X+nD1gHeBiVyi6859f5uFS612/YTb0n2IdgGv2tmhpluZHxyN6xWMSjk0wbaqywghgjLnmf2wf9fgVRQi/uDzKpdPjBHJo4QBewTWyQGUBI5ObF47Saczm1NqwSNuqpeC3rRLnvEO+usHXyJNxlLQ4gnuFdNdvjV+rhEnWo1ZMJRUFFjNMbkVHWW5eUfQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 7:46 PM, Vlastimil Babka (SUSE) wrote:
> On 4/1/26 15:57, Breno Leitao wrote:
>> vmstat_update uses round_jiffies_relative() when re-queuing itself,
>> which aligns all CPUs' timers to the same second boundary.  When many
>> CPUs have pending PCP pages to drain, they all call decay_pcp_high() ->
>> free_pcppages_bulk() simultaneously, serializing on zone->lock and
>> hitting contention.
>>
>> Introduce vmstat_spread_delay() which distributes each CPU's
>> vmstat_update evenly across the stat interval instead of aligning them.
>>
>> This does not increase the number of timer interrupts — each CPU still
>> fires once per interval. The timers are simply staggered rather than
>> aligned. Additionally, vmstat_work is DEFERRABLE_WORK, so it does not
>> wake idle CPUs regardless of scheduling; the spread only affects CPUs
>> that are already active
>>
>> `perf lock contention` shows 7.5x reduction in zone->lock contention
>> (872 -> 117 contentions, 199ms -> 81ms total wait) on a 72-CPU aarch64
>> system under memory pressure.
>>
>> Tested on a 72-CPU aarch64 system using stress-ng --vm to generate
>> memory allocation bursts.  Lock contention was measured with:
>>
>>   perf lock contention -a -b -S free_pcppages_bulk
>>
>> Results with KASAN enabled:
>>
>>   free_pcppages_bulk contention (KASAN):
>>   +--------------+----------+----------+
>>   | Metric       | No fix   | With fix |
>>   +--------------+----------+----------+
>>   | Contentions  |      872 |      117 |
>>   | Total wait   | 199.43ms | 80.76ms  |
>>   | Max wait     |   4.19ms | 35.76ms  |
>>   +--------------+----------+----------+
>>
>> Results without KASAN:
>>
>>   free_pcppages_bulk contention (no KASAN):
>>   +--------------+----------+----------+
>>   | Metric       | No fix   | With fix |
>>   +--------------+----------+----------+
>>   | Contentions  |      240 |      133 |
>>   | Total wait   |  34.01ms | 24.61ms  |
>>   | Max wait     |   965us  |  1.35ms  |
>>   +--------------+----------+----------+
>>
>> Signed-off-by: Breno Leitao <leitao@debian.org>
> 
> Cool!
> 
> I noticed __round_jiffies_relative() exists and the description looks like
> it's meant for exactly this use case?

On closer look, using round_jiffies_relative() as before your patch
means it's calling __round_jiffies_relative(j, raw_smp_processor_id())
so that's already doing this spread internally. You're also relying
smp_processor_id() so it's not about using a different cpu id.

But your patch has better results, why? I still think it's not doing
what it intends - I think it makes every cpu have different interval
length (up to twice the original length), not skew. Is it that, or that
the 3 jiffies skew per cpu used in round_jiffies_common() is
insufficient? Or it a bug in its skew implementation?

Ideally once that's clear, the findings could be used to improve
round_jiffies_common() and hopefully there's nothing here that's vmstat
specific.

Thanks,
Vlastimil

>> ---
>>  mm/vmstat.c | 25 ++++++++++++++++++++++++-
>>  1 file changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/vmstat.c b/mm/vmstat.c
>> index 2370c6fb1fcd..2e94bd765606 100644
>> --- a/mm/vmstat.c
>> +++ b/mm/vmstat.c
>> @@ -2032,6 +2032,29 @@ static int vmstat_refresh(const struct ctl_table *table, int write,
>>  }
>>  #endif /* CONFIG_PROC_FS */
>>  
>> +/*
>> + * Return a per-cpu delay that spreads vmstat_update work across the stat
>> + * interval.  Without this, round_jiffies_relative() aligns every CPU's
>> + * timer to the same second boundary, causing a thundering-herd on
>> + * zone->lock when multiple CPUs drain PCP pages simultaneously via
>> + * decay_pcp_high() -> free_pcppages_bulk().
>> + */
>> +static unsigned long vmstat_spread_delay(void)
>> +{
>> +	unsigned long interval = sysctl_stat_interval;
>> +	unsigned int nr_cpus = num_online_cpus();
>> +
>> +	if (nr_cpus <= 1)
>> +		return round_jiffies_relative(interval);
>> +
>> +	/*
>> +	 * Spread per-cpu vmstat work evenly across the interval.  Don't
>> +	 * use round_jiffies_relative() here -- it would snap every CPU
>> +	 * back to the same second boundary, defeating the spread.
>> +	 */
>> +	return interval + (interval * (smp_processor_id() % nr_cpus)) / nr_cpus;
> 
> Hm doesn't this mean that lower id cpus will consistently fire in shorter
> intervals and higher id in longer intervals? What we want is same interval
> but differently offset, no?
> 
>> +}
>> +
>>  static void vmstat_update(struct work_struct *w)
>>  {
>>  	if (refresh_cpu_vm_stats(true)) {
>> @@ -2042,7 +2065,7 @@ static void vmstat_update(struct work_struct *w)
>>  		 */
>>  		queue_delayed_work_on(smp_processor_id(), mm_percpu_wq,
>>  				this_cpu_ptr(&vmstat_work),
>> -				round_jiffies_relative(sysctl_stat_interval));
>> +				vmstat_spread_delay());
>>  	}
>>  }
>>  
>>
>> ---
>> base-commit: cf7c3c02fdd0dfccf4d6611714273dcb538af2cb
>> change-id: 20260401-vmstat-048e0feaf344
>>
>> Best regards,
>> --  
>> Breno Leitao <leitao@debian.org>
>>
> 


