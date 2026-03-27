Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B53DD10A62E8
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:38:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26CA36B00BE; Thu, 26 Mar 2026 22:38:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 244026B00C0; Thu, 26 Mar 2026 22:38:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180F66B00C2; Thu, 26 Mar 2026 22:38:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 084E56B00BE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:38:26 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B4F0C1B8D72
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:38:25 +0000 (UTC)
X-FDA: 84590284170.21.8E51A5B
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf21.hostedemail.com (Postfix) with ESMTP id C5A9E1C0003
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:38:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=imxpd0OW;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774579104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0W1Ju5RwHqCPiIN+oh76SgqeeInA8ZXDJcYeDdqF8Fo=;
	b=OM8yC9S7CI+SGndN38BvxaHPMW60zQX37UsmuhCdgsZ5KZg34wDMjOnpPJhvx4q9+mO1UZ
	ndVcr2xyONfwUeHYwDa3o2NXmUGCGe10gByuhgIDywhKJHbrJgX4UHoJcsFGjdh612jM4i
	6Eus5My9Km/fPN6GQAvC0Jc/rxXGHzM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=imxpd0OW;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774579104; a=rsa-sha256;
	cv=none;
	b=LdDkXM3NoAb2RAAI8NVT/vMPVaAAxBU7TicOfznaG9soJJXroMk6o34C2YisY4+sv6HM2M
	sIYoWmsCN94sdgWTUt5bleIzjDwJnYzOIiJciy3lvH+ConmyyPus9R53ql5sbjg3PE/6ZL
	hbwCDMepxCQ3MEJuKZmHkTi2nxYecxE=
Message-ID: <219d7312-d64c-489c-8b22-02288f7c161c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774579098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0W1Ju5RwHqCPiIN+oh76SgqeeInA8ZXDJcYeDdqF8Fo=;
	b=imxpd0OW7eZRKBn5Jo3KVnug5XTYpOf89zj9KxHvfbjzOaKj1pojtX+yxWBOBIolNHq99N
	yk2CFNgOBNFjwDRKtOrVVoFJSl6/SBSIiotTujGCCmMgUr3+h5iYwEk1jcaDdQz1/Sw9YW
	yhiQ4Qgdl6HVcu9jupjV9uRzm9Nv3DU=
Date: Fri, 27 Mar 2026 10:37:57 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/4] mm: memcontrol: change val type to long in
 __mod_memcg_{lruvec_}state()
To: David Laight <david.laight.linux@gmail.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ziy@nvidia.com, harry.yoo@oracle.com,
 yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1774447069.git.zhengqi.arch@bytedance.com>
 <5c42058df0e52a4698da005e502deb2fae7bf819.1774447069.git.zhengqi.arch@bytedance.com>
 <ac9c3d78-6244-424f-82b0-d5501145484c@lucifer.local>
 <20260326143736.12d22e38@pumpkin>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260326143736.12d22e38@pumpkin>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C5A9E1C0003
X-Stat-Signature: ghmri17f43a454smy3sxfqnuzciknbzx
X-Rspamd-Server: rspam06
X-HE-Tag: 1774579103-819645
X-HE-Meta: U2FsdGVkX1/Q8UnupmAxcXjO6uW/zqSy9p/QF5R3/2DP7yTHi0VUWMhK1jW/C4179bdnIdCjZvUT4wSvTCaeImzdKccy16v/amj0lLB3Vpc6oo4G5Pe3fdpQ4j5UjCb767B0Ni3L6Co0uT9jYrVpERSpaFaeaKsK27EducNxPI2tgbCeJdE2oiLd4EABKF8cuYwhw2EfAQ17xYYgmd2Ce87FY0Qu4qvgZa20sJrUgws1Z3nMvbt6DMzNSUs8FHts2O8QaWgWa67N2SgyyWrun91jVRuz8jTK75wk1GOYjLv4FLtafcVKnuFA9cCoaQjLk4+E3IYKxkWj4Xfh7r2GeBZ26tpckVEI0WEobhejmaiKJFXRGXu8gU8+p353s0IZGnB/CH2ig1bZwUYbzFy5hqOUlq/FifIBMAEHoj2DfbM3kPQmK6w7kspaEr64n9lYFd/rbvJZUlskbUzMp/qZ0uDl2iRbgaqa2aMlym7mmNIt0HoPpPQwsK+IGZWiZ68+R52te6I+qPqNX47oT0AaBGWAJ0tHdt1dyDCyCjSLaXWaoPcuerXQOT3nB2xEbzXJIOWzg/xVWA6gcc82xZm6iVrNRSGOf6D5uALP4AbQTuAxL80D/UkszUUyBvFV8R74d/yN42pI4j9hDZ93jodmKqkzJ6AKsnhhxrttFvDoT+fDqg1rQZvvm0Di0YQNyAtUb2K2wnyl8xH2t1X7hzpodMff47JF1YzkBhDxOXFN3s0UUSg+b30odFx9HDWTDjG82Nzb5v9ob0agwjBZA8LfmjipCj1ZjSCo44fmWY73myRT+fff/EaLj9VWmbVV5riU9hKnNgVK2nX+7vpKr4Y2YmCu/WS5pnnXEN8WAB3aQBeUfUSJtRngDlFA/MQl772+Hp5PXrrGowont8VrzxWHNbP/mJwdnFtCBl0H4P1ipWeO6btemLihFwvrBJmRmkEk+E5jNumf/gXJEdr4+8h
 0VVDmqUa
 QnPersdpk5TDU12D+dAbhykBLInr7bXY+oCy1vvM3c0+lYMVSh89DFCinOHGj3V7VsAn6OmkvwK85EepiX1jtrIJTC31NOEf4HrPlvjVGLwdRedpTfcD+GcI4Z4PT8MnjRCXQMdM7cMbMIfiZp5T9vA3/y1K4JY3SVRN5Ho1WOxsDEwdT0nrMSAJYZpkjzCMNb//tWl61tur1Tx/F2DJ8jCNwZw6GGgycM+m5isxH+FmmfYbpnb2e00KvURY0ghb/0sfr8BwdBtEqCVYeVjuvJ2rCmmzn+Q1b9iVI9JsqUWn0t2CLV3b35abYa7ThyuQGdbX04mBh8ODZA28DVofAmGzp0hedQBcr1m7mQTleLStKBu0QvUyAPdgO5sS6neoKSRKA0EOENgp6fRVANGQmNONs1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/26/26 10:37 PM, David Laight wrote:
> On Thu, 26 Mar 2026 09:19:29 +0000
> "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
> 
>> On Wed, Mar 25, 2026 at 10:13:23PM +0800, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>
>>> The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
>>> used to reparent non-hierarchical stats. In this scenario, the values
>>> passed to them are accumulated statistics that might be extremely large
>>> and exceed the upper limit of a 32-bit integer.
>>>
>>> Change the val parameter type from int to long in these functions and
>>> their corresponding tracepoints (memcg_rstat_stats) to prevent potential
>>> overflow issues.
> 
> Won't that are be true on 32bit systems?
> Which means the underlying values need to be u64 not long.

On a 32-bit system, such a large number of values ​​should not accumulate.

Furthermore, changing it to u64/s64 would mean modifying
memcg_vmstats_percpu->state and lruvec_stats_percpu->state,
which involves significant changes, so I think it might be unnecessary.

Thanks,
Qi

> 
> 	David
> 
>>>
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> LGTM, so:
>>
>> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
>>
>>> ---
>>>   include/trace/events/memcg.h | 10 +++++-----
>>>   mm/memcontrol.c              |  8 ++++----
>>>   2 files changed, 9 insertions(+), 9 deletions(-)
>>>
>>> diff --git a/include/trace/events/memcg.h b/include/trace/events/memcg.h
>>> index dfe2f51019b4c..51b62c5931fc2 100644
>>> --- a/include/trace/events/memcg.h
>>> +++ b/include/trace/events/memcg.h
>>> @@ -11,14 +11,14 @@
>>>
>>>   DECLARE_EVENT_CLASS(memcg_rstat_stats,
>>>
>>> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
>>> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>>>
>>>   	TP_ARGS(memcg, item, val),
>>>
>>>   	TP_STRUCT__entry(
>>>   		__field(u64, id)
>>>   		__field(int, item)
>>> -		__field(int, val)
>>> +		__field(long, val)
>>>   	),
>>>
>>>   	TP_fast_assign(
>>> @@ -27,20 +27,20 @@ DECLARE_EVENT_CLASS(memcg_rstat_stats,
>>>   		__entry->val = val;
>>>   	),
>>>
>>> -	TP_printk("memcg_id=%llu item=%d val=%d",
>>> +	TP_printk("memcg_id=%llu item=%d val=%ld",
>>>   		  __entry->id, __entry->item, __entry->val)
>>>   );
>>>
>>>   DEFINE_EVENT(memcg_rstat_stats, mod_memcg_state,
>>>
>>> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
>>> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>>>
>>>   	TP_ARGS(memcg, item, val)
>>>   );
>>>
>>>   DEFINE_EVENT(memcg_rstat_stats, mod_memcg_lruvec_state,
>>>
>>> -	TP_PROTO(struct mem_cgroup *memcg, int item, int val),
>>> +	TP_PROTO(struct mem_cgroup *memcg, int item, long val),
>>>
>>>   	TP_ARGS(memcg, item, val)
>>>   );
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 7fb9cbc10dfbb..4a78550f6174e 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -527,7 +527,7 @@ unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>
>>>   #ifdef CONFIG_MEMCG_V1
>>>   static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>> -				     enum node_stat_item idx, int val);
>>> +				     enum node_stat_item idx, long val);
>>>
>>>   void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>>   				       struct mem_cgroup *parent, int idx)
>>> @@ -784,7 +784,7 @@ static int memcg_page_state_unit(int item);
>>>    * Normalize the value passed into memcg_rstat_updated() to be in pages. Round
>>>    * up non-zero sub-page updates to 1 page as zero page updates are ignored.
>>>    */
>>> -static int memcg_state_val_in_pages(int idx, int val)
>>> +static long memcg_state_val_in_pages(int idx, long val)
>>>   {
>>>   	int unit = memcg_page_state_unit(idx);
>>>
>>> @@ -831,7 +831,7 @@ static inline void get_non_dying_memcg_end(void)
>>>   #endif
>>>
>>>   static void __mod_memcg_state(struct mem_cgroup *memcg,
>>> -			      enum memcg_stat_item idx, int val)
>>> +			      enum memcg_stat_item idx, long val)
>>>   {
>>>   	int i = memcg_stats_index(idx);
>>>   	int cpu;
>>> @@ -896,7 +896,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>>>   #endif
>>>
>>>   static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
>>> -				     enum node_stat_item idx, int val)
>>> +				     enum node_stat_item idx, long val)
>>>   {
>>>   	struct mem_cgroup *memcg = pn->memcg;
>>>   	int i = memcg_stats_index(idx);
>>> --
>>> 2.20.1
>>>   
>>
> 


