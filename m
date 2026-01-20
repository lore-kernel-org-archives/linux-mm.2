Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB423D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 07:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A5A26B0373; Tue, 20 Jan 2026 02:19:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 033236B0374; Tue, 20 Jan 2026 02:19:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1AF6B0375; Tue, 20 Jan 2026 02:19:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D98A96B0373
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 02:19:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7EFD513AE88
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:19:49 +0000 (UTC)
X-FDA: 84351492498.17.D36FB58
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id A58E64000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 07:19:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ms2mAtWJ;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768893588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/HlxvZX2gPKCzNfgWKeEIdwyaofi4etP4O/2x5X3mrQ=;
	b=HvFEC/pVYV+SoT4F16CZU/hUD49FnqN5fKHsI6VmeWJNuwK2nhsE/R10iV4TOSAaMfgbw1
	qzQnNnJedcVOCqekvWhMXavDaaJA1LTdqrh9t9C86dgBByqNsjNozu1q/2Ny2gcbbkG9Qm
	HDhsqQbw2bj1J09KUoZdTtlyPxZLLLM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Ms2mAtWJ;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768893588; a=rsa-sha256;
	cv=none;
	b=wenRiltbpp4HDxURYHgFFEkttGpLjzM+F7lXSmbQo/otDBZGQokDVk9s2v9EH77pS1egxf
	FvVBrFKg0dwlZL0Um/RZFxjRf9hThOMdQ7wXm5goV7ONWD2DgH+p1EA2pca8/CJI7eSt1f
	Dlxehiol1cz4Tt+i5byXmDYaHdWXHnE=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768893585;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/HlxvZX2gPKCzNfgWKeEIdwyaofi4etP4O/2x5X3mrQ=;
	b=Ms2mAtWJVCJ3bCD2diLe3CLeoi8jlKaH2qIr4FlGtR6V3qhfMJT0Ib9OAeVP03hAHK9ufe
	MNzGg4ABpc3blKV10kpt/lBWMkPSHtv7OVMYSw/apNXrvrVm0wXIxChAGS/BmkfqH1tDNU
	jQYdymDeTksa5BeyAQvFkDsjGyKiCwM=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH v3 28/30 fix 1/2] mm: memcontrol: fix
 lruvec_stats->state_local reparenting
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
Date: Tue, 20 Jan 2026 15:19:00 +0800
Cc: hannes@cmpxchg.org,
 hughd@google.com,
 mhocko@suse.com,
 roman.gushchin@linux.dev,
 david@kernel.org,
 lorenzo.stoakes@oracle.com,
 ziy@nvidia.com,
 harry.yoo@oracle.com,
 yosry.ahmed@linux.dev,
 imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com,
 axelrasmussen@google.com,
 yuanchu@google.com,
 weixugc@google.com,
 chenridong@huaweicloud.com,
 mkoutny@suse.com,
 akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com,
 apais@linux.microsoft.com,
 lance.yang@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <A13923AA-8200-4863-8080-EC4B254BA3AA@linux.dev>
References: <b11a0bde9fe18673a61a79398f226ad7cb04a894.1768389889.git.zhengqi.arch@bytedance.com>
 <e5afd1b5ae95d70f82433b9b4e13201342d16707.1768473427.git.zhengqi.arch@bytedance.com>
 <ifcth3hxyrwmmeo3nejettdtkw2ndxdjbylszmhq3vohuhsncl@k23pew6gywko>
 <5a18658e-2076-4cbf-bc53-5b6e99c1035f@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: ijsrbbzsdxm4pt61qhfd9brehyydnumf
X-Rspamd-Queue-Id: A58E64000B
X-Rspamd-Server: rspam04
X-HE-Tag: 1768893587-270907
X-HE-Meta: U2FsdGVkX18NOhnRegZoqFpnN1+1HpqNbtX+f5RqVlD9BhXfUcaAWm3k6Ys3mii++uMkRvYqnQRirmIaRwl9L8dN17vOvIS0smZiQXrPm2g0k/DrzhASGMAZme8L2k8U4yVJz4sPamlhfTLvXH6jqaonDt+JDHwJCVHnxLEa6xeIMKX01J+dZrue/xFp5QWKJmMAVF5BUWK8boovmv4PDTKYppflw0O7eghoVqao86Qi/lc4vR7MSHzb+ZuMWvcszkK+dkFQffcu+G5nWBRoJTfZ9A3n05UWo5xMvza4XF9nPuqZb5ZiNRv5li9ATSfdc8qIlFjI0x2ZrME7APrdEhydg1pXe3dtd9BE1EKzB+T/iDiWeFm2z82OgXpB/CdMz+/78BesXjCziC1k9tQd5gAzKqnWOWqHMxncfz9TNNWrYF8w5AXYI2tANJ+foXEFtKKDj0OWELsesBVc8OypyLOGKhBvbyZvC/XIZdf/+mN1aIw/8IV4Fa37/jl1XPRcenY79L7XH8yJlTGMVtmwQKGuGsbUz4F4T4L5066SPVBSj0eNgUesoSkCr4zXLPc5cJm3cw2D2gCfOnadR+dBcsqzYFaQkgygzyHg8wF9TYxa4gHgTzshwSKxG5qzWWu4BGVt7coMvwnd2/FajkmnfzR75PD3AzpkWXBUkgjFq7yf5X+r7f6vUY071yDu7VfrY5DVA5k/0fvIE8PSYon8MTkFXyq5n+GrnIZIxfRks+4EncsVu3hvCVrsHTRk++RZZX0ILcpC1JPD5MU+qUxaAiRsMxjOpgcFZMq5/Q5XLXZTB1PhZzBlxIidE+G0gUmJyALww3LVJ/du5IRrcXNUyoASD5Bu2PlaKkCcOw+I/u8ZC3Z5sC6Fs4bcNksJ0WkMmJn0uQflYuB+4kBSdJAlsd9jQuAib2eD3NzSlJEXJlwrTtJg7ac/Y6KuHDvMpV0jNHQUKhrDFuPn3sf7pf5
 CpFF7GnL
 ykSp6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 19, 2026, at 11:36, Qi Zheng <qi.zheng@linux.dev> wrote:
>=20
>=20
>=20
> On 1/18/26 11:22 AM, Shakeel Butt wrote:
>> On Thu, Jan 15, 2026 at 06:41:38PM +0800, Qi Zheng wrote:
>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>=20
>>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>>> ---
>>>  include/linux/memcontrol.h |  2 --
>>>  mm/memcontrol-v1.c         |  8 --------
>>>  mm/memcontrol-v1.h         |  5 ++++-
>>>  mm/memcontrol.c            | 19 ++++++++-----------
>>>  4 files changed, 12 insertions(+), 22 deletions(-)
>>>=20
>>> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
>>> index 1fe554eec1e25..e0b84b109b7ac 100644
>>> --- a/include/linux/memcontrol.h
>>> +++ b/include/linux/memcontrol.h
>>> @@ -944,8 +944,6 @@ bool memcg_vm_event_item_valid(enum =
vm_event_item idx);
>>>  unsigned long lruvec_page_state(struct lruvec *lruvec, enum =
node_stat_item idx);
>>>  unsigned long lruvec_page_state_local(struct lruvec *lruvec,
>>>         enum node_stat_item idx);
>>> -void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>> -        struct mem_cgroup *parent, int idx);
>>>    void mem_cgroup_flush_stats(struct mem_cgroup *memcg);
>>>  void mem_cgroup_flush_stats_ratelimited(struct mem_cgroup *memcg);
>>> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
>>> index 03b924920d6a5..daf9bad8c45ea 100644
>>> --- a/mm/memcontrol-v1.c
>>> +++ b/mm/memcontrol-v1.c
>>> @@ -1909,14 +1909,6 @@ void reparent_memcg1_state_local(struct =
mem_cgroup *memcg, struct mem_cgroup *pa
>>>   reparent_memcg_state_local(memcg, parent, memcg1_stats[i]);
>>>  }
>>>  -void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, =
struct mem_cgroup *parent)
>>> -{
>>> - int i;
>>> -
>>> - for (i =3D 0; i < ARRAY_SIZE(memcg1_stats); i++)
>>> - reparent_memcg_lruvec_state_local(memcg, parent, memcg1_stats[i]);
>>> -}
>>> -
>>>  void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf =
*s)
>>>  {
>>>   unsigned long memory, memsw;
>>> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
>>> index 45528195d3578..5b1188f3d4173 100644
>>> --- a/mm/memcontrol-v1.h
>>> +++ b/mm/memcontrol-v1.h
>>> @@ -75,7 +75,6 @@ void memcg1_uncharge_batch(struct mem_cgroup =
*memcg, unsigned long pgpgout,
>>>    void memcg1_stat_format(struct mem_cgroup *memcg, struct seq_buf =
*s);
>>>  void reparent_memcg1_state_local(struct mem_cgroup *memcg, struct =
mem_cgroup *parent);
>>> -void reparent_memcg1_lruvec_state_local(struct mem_cgroup *memcg, =
struct mem_cgroup *parent);
>>>    void memcg1_account_kmem(struct mem_cgroup *memcg, int nr_pages);
>>>  static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg)
>>> @@ -116,6 +115,10 @@ static inline void memcg1_uncharge_batch(struct =
mem_cgroup *memcg,
>>>    static inline void memcg1_stat_format(struct mem_cgroup *memcg, =
struct seq_buf *s) {}
>>>  +static inline void reparent_memcg1_state_local(struct mem_cgroup =
*memcg, struct mem_cgroup *parent)
>>> +{
>>> +}
>>> +
>>>  static inline void memcg1_account_kmem(struct mem_cgroup *memcg, =
int nr_pages) {}
>>>  static inline bool memcg1_tcpmem_active(struct mem_cgroup *memcg) { =
return false; }
>>>  static inline bool memcg1_charge_skmem(struct mem_cgroup *memcg, =
unsigned int nr_pages,
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 7333a37830051..b7b35143d4d2d 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -225,13 +225,13 @@ static inline struct obj_cgroup =
*__memcg_reparent_objcgs(struct mem_cgroup *memc
>>>   return objcg;
>>>  }
>>>  -#ifdef CONFIG_MEMCG_V1
>>> +static void reparent_memcg_lruvec_state_local(struct mem_cgroup =
*memcg,
>>> +       struct mem_cgroup *parent, int idx);
>>>  static void __mem_cgroup_flush_stats(struct mem_cgroup *memcg, bool =
force);
>>>    static inline void reparent_state_local(struct mem_cgroup *memcg, =
struct mem_cgroup *parent)
>>>  {
>> No reparenting local stats for v2.
>=20
> It seems that lruvec_stats->state_local (non-hierarchical) needs to be
> relocated in both v1 and v2.

Here we might need to elaborate a bit. Specifically, in the function
`count_shadow_nodes`, the use of `lruvec_page_state_local` to obtain
LRU and SLAB pages seems to also require these logics to work correctly.
For SLAB, it appears that the statistics here have already been
problematic for a while since SLAB pages have been reparented, right?

>=20
>>> - if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
>>> - return;
>>> + int i;
>>>     synchronize_rcu();
>>>  @@ -239,13 +239,10 @@ static inline void =
reparent_state_local(struct mem_cgroup *memcg, struct mem_cgr
>>>     /* The following counts are all non-hierarchical and need to be =
reparented. */
>>>   reparent_memcg1_state_local(memcg, parent);
>>> - reparent_memcg1_lruvec_state_local(memcg, parent);
>>> -}
>>> -#else
>>> -static inline void reparent_state_local(struct mem_cgroup *memcg, =
struct mem_cgroup *parent)
>>> -{
>>> +
>>> + for (i =3D 0; i < NR_LRU_LISTS; i++)
>>> + reparent_memcg_lruvec_state_local(memcg, parent, i);
>>>  }
>>> -#endif
>>>    static inline void reparent_locks(struct mem_cgroup *memcg, =
struct mem_cgroup *parent)
>>>  {
>>> @@ -510,8 +507,8 @@ unsigned long lruvec_page_state_local(struct =
lruvec *lruvec,
>>>   return x;
>>>  }
>>>  -void reparent_memcg_lruvec_state_local(struct mem_cgroup *memcg,
>>> -        struct mem_cgroup *parent, int idx)
>>> +static void reparent_memcg_lruvec_state_local(struct mem_cgroup =
*memcg,
>>> +       struct mem_cgroup *parent, int idx)
>>>  {
>>>   int i =3D memcg_stats_index(idx);
>>>   int nid;
>>> --=20
>>> 2.20.1



