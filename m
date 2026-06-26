Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10EA5CDE008
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 02:39:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE7E6B0099; Thu, 25 Jun 2026 22:39:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE8F6B009B; Thu, 25 Jun 2026 22:39:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4226B009D; Thu, 25 Jun 2026 22:39:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 986846B0099
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 22:39:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A7CCC188B
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:39:24 +0000 (UTC)
X-FDA: 84920507448.28.E67B38E
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf14.hostedemail.com (Postfix) with ESMTP id C4F5F100007
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 02:39:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HlxqWPhj;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782441562;
	b=7mX30ejnuliXM3r09YHe8uF9BgNKqE9gUF2efTo+QjIwy3VxOLnVQmoScmbHGaNFLqrpSy
	UM5zhCM5WPa/cS3d6cvfG323NX5TX/1OkS4aayqP2BDTDD5x68FGH9tCN+xakcN/+zzwkp
	y7LvM7g3Fa7H7hZFo7SlsDP8mNRJhl0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782441562;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMiBjpoG5x/PF8SzAf5XymHhBXZlwVkuA+guTc6Tz+s=;
	b=kJi7R4UqYR9uL6C+VVtSAMmb/aOkgXogUm+XXAa8NznLfbPD/yIlzZsWmRItw/WoyxxLEo
	V0ve/9SKDElC6HX/aJ35jgWrrZQkSZfDLyZbErzwmEhLmQmWi5XbEftP7Gv0H3YTQ6O/Zo
	ScF6rsDfNqFMpjgmmTU1R+hrSQ+0uXw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HlxqWPhj;
	spf=pass (imf14.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <dc62c93c-2dbb-40ab-8e3c-2e2b1c9ff0e1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782441557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eMiBjpoG5x/PF8SzAf5XymHhBXZlwVkuA+guTc6Tz+s=;
	b=HlxqWPhjhC0j9hY/ieFKCrb9rfUDoIAlwoC+Sk8MOyqCqBiTsnN35cs89wF5SYH1TEWLOi
	qzU92R1k5+LncMjCk6o3/6qcDbYVn5k6wg7D8VSJCiDmMAkD8vPvVrqWPIfU5iR2Bx+jJI
	0er9sGgDMCZzJFFnjaiRH1MvAimy1aA=
Date: Fri, 26 Jun 2026 10:39:00 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3] mm: mglru: fix stale batch updates after memcg
 reparenting
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hannes@cmpxchg.org, harry@kernel.org,
 muchun.song@linux.dev, peiyang_he@smail.nju.edu.cn, mhocko@kernel.org,
 roman.gushchin@linux.dev, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>,
 stable@vger.kernel.org
References: <20260625151554.55105-1-qi.zheng@linux.dev>
 <aj2MsQ3tF0ACCCGi@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aj2MsQ3tF0ACCCGi@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C4F5F100007
X-Stat-Signature: 9poyrdgq54x8nza7ws41ti48us8pidmz
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782441560-57733
X-HE-Meta: U2FsdGVkX18t/ZMevztl5X6w5DUz0v5RCWVAKeYyPfq+s7Lz/NuuhnkNsl/rsvNCcQSK3GEKh8jR101mRjmBOIyyaYyNJ1irbRUbZknVMHG5YZT3KOxfpRvVJcBITkTOBwogS2j3NNLHFzXfj8zW5nYi9+LsbuVO9Ej7oS758+Gl+8pzYZ0iwM1NFTSTP6DlOb59lly0h6aeJA9w+b0Rtztf365Yv5UNUaTLv8FIoUDXOX7cx7Di511usRW4f5TCdttcag7FXk+QCXLTPKgPk25yjNqW6+f028dlqI341maDm0C6KP8DisA8pDqs7XXePtq0dWF+Jy2OtRaTI7qsNgOV3m6ll3PpIvZzKSLnqwjI+TLIzJdN5Af08e1giQBqSgl1+L74j0UGFBo0GvPBtAKZnCtosiUa5PB9s4+ul+LKLbTm9ve7sboNw4qc4UALFt5eYFgFGIzlCKPtBPcd3zkMrnwEmW2/6s+VfvQ2mWOIcHWz9LVM/d30NCGC1wSb/Xtpry3tzRTe2OLY4or7NnO58L4WfJAXzjQ06Xue4GrOdpxxt0ve4pCF0kkUMOtJuZTATYkDRjhWsS7aBERt2N7HpzJleUGk6ZS4/JVRC3LWXlDVbWU2Cn9F5HxyG5dbSH1RGXxQcTPjWabK+H39Mwr8Q+W/GJfp+GTFO1DvjxgZ+mVrkw9I2B8TT8leJY40GNx/Fx3vdP/vH493HeUXwFS/uWGO1Z1e5Fh7geg+yee/lnXbsiYeelDL08uFWHMpgIG6/hzIaadwGGxkhuLXnHIv6qWc+J/QO2KVf8TURbFpqvn0c0hdcUPeykAV9qG/xEvM1rr7Em/qA1OJu4BiV/0E0+0LUyZPFp0z0aFJ06/qebtA8t5mjATpKAcUvI+tWDBFnymG9GZtkB7glM2bOTIEUVCnbRrcstv2Waxqt8GzZXmvV43kVqcn3NTNGRHM/+5MwQL1WzSs+4uH1j5
 1LWYxChl
 G8nwSouDS4CE//w9psGnSv+SQWeKNoWsYcN6ereD8v2VvdPb61kezRCqC+eYa3ddl5M0cfjOyIboDNTr05k174oIEMDBJUdo8c9xukD2io0D5WiA5DEm1UKZZX0WIBCKztf9928Js8RD8AgNKTAZL2fEisDVxnoC4v+i4aVa2C0zBhi4i9MLlFrTJ3XupDt1O+h4QTDwkIAuIr+roPH+ywRr62FzMLCxs0emWbe2Lj1ecd5QDzMDgVoE/JDqT0Tw/rExy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 6/26/26 4:22 AM, Shakeel Butt wrote:
> On Thu, Jun 25, 2026 at 11:15:54PM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> The mglru page table walker batches per-generation size deltas in
>> walk->nr_pages while walking page tables without holding the lruvec lock.
>> The reset_batch_size() later folds those deltas into walk->lruvec under
>> the lruvec lock.
>>
>> The page table walker can run concurrently with the memcg reparenting path
>> as follows:
>>
>> CPU0                           CPU1
>> ====                           ====
>>
>> walk_mm
>> --> walk_page_range
>>      --> update_batch_size
>>          --> walk->nr_pages += delta
>>
>>                                mem_cgroup_css_offline
>>                                --> memcg_reparent_objcgs
>>                                    --> lock lruvec
>>                                        lru_gen_reparent_memcg
>>                                        --> reparent child folios to parent
>>                                        unlock lruvec
>>
>>      lock lruvec
>>      reset_batch_size
>>      --> child lrugen->nr_pages += delta
>>
>> This will trigger the following warning in lru_gen_exit_memcg():
>>
>> 	VM_WARN_ON_ONCE(memchr_inv(lruvec->lrugen.nr_pages, 0,
>> 				   sizeof(lruvec->lrugen.nr_pages)));
>>
>> And the user-visible impact of underestimated nr_pages in MGLRU was
>> premature OOMs because MGLRU does not try to reclaim memory when nr_pages
>> reaches zero, but there are still more pages.
>>
>> To fix it, make reset_batch_size() check CSS_DYING under RCU before
>> flushing the pending batch. A non-dying memcg keeps the original lruvec
>> stable against RCU-delayed offlining; a dying memcg redirects the deltas
>> to the first non-dying ancestor.
>>
>> Reported-by: Peiyang He <peiyang_he@smail.nju.edu.cn>
>> Closes: https://lore.kernel.org/all/5A9E929D82717101+12fcf643-efb8-4b9a-a53a-1e28cc894f0b@smail.nju.edu.cn
>> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>> Changes in v3:
>>   - re-implement lock_batch_lruvec() by checking CSS_DYING under the RCU lock
>>     (suggested by Harry)
>>   - update the commit message (suggested by Harry)
>>   - temporarily drop the previous Reviewed-by tags
>>     (since the sync method has changed)
>>   - rebase onto the next-20260624
>>
>> Changes in v2:
>>   - update the commit message (pointed by Barry)
>>   - collect Reviewed-by
>>
>>   mm/vmscan.c | 45 ++++++++++++++++++++++++++++++++++++++-------
>>   1 file changed, 38 insertions(+), 7 deletions(-)
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 35c3bb15ae96..1ec8c23c72b9 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3262,10 +3262,44 @@ static void update_batch_size(struct lru_gen_mm_walk *walk, struct folio *folio,
>>   	walk->nr_pages[new_gen][type][zone] += delta;
>>   }
>>   
>> +#ifdef CONFIG_MEMCG
>> +static struct lruvec *lock_batch_lruvec(struct lruvec *lruvec)
> 
> This is memcg specific function, move this function next to similar functions
> like lruvec_lock_irq. Also put irq in the name.

Currently, the lock_batch_lruvec() is only used by reset_batch_size().
Are you intend to make it a common function for use in other places?

Perhaps we could defer making it generic until we actually have a second
user. Since this is just a fix, keeping it self-contained within
vmscan.c might be more compact for now. ;)

> 
> BTW have you checked other places where lruvec_lock_irq is used and if similar
> kind of situation can happen?

I just checked and found no such callers.

Thanks,
Qi

> 


