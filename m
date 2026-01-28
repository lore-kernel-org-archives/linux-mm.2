Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B056CD46BF5
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 19:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0853F6B0005; Wed, 28 Jan 2026 14:18:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05DA16B0089; Wed, 28 Jan 2026 14:18:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBD06B008A; Wed, 28 Jan 2026 14:18:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D992F6B0005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 14:18:51 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7F7051B0C4B
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:18:51 +0000 (UTC)
X-FDA: 84382334862.07.E674804
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5B2AC140005
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 19:18:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w8CN0m3J;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769627930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WlevcV+s/Akx87IZT0lp1ZcnLiIY5tgyZl3WZ+5t1Bg=;
	b=KVHNnHUy5Z9xY1W0kVnB6CDUP3TJjImNBxUER7HqJ5knb9Rk8uOiBByqVx3+wV5ANT33jw
	jXPiohiYzYR3TJSP+jdDG/nWSc10zBD/Nkt5qZhAV3OizdLk+x9eJwgIgb+Z+REvboFqly
	+T0r6kCCHNX9qE3oN/cyrw1HJYA6LCI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=w8CN0m3J;
	spf=pass (imf09.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769627930; a=rsa-sha256;
	cv=none;
	b=A+WgZ0n2InFSr61fHxybfa1ri6cyZZOj7K0suRy1WFk9qMLqaCbQqUJji6toedCQz0icwU
	xgKOmhQItgQ8e7OK06buh5kYTtuqtNpr5K+RfZsPIQrvoO1ErEoGw3oOI3akFFzHJr/YhX
	PA3MpXHpyBYWUv0/M1SHRYDbIYSZUJ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769627927;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WlevcV+s/Akx87IZT0lp1ZcnLiIY5tgyZl3WZ+5t1Bg=;
	b=w8CN0m3Ju240SyX0s68sp64BVQ7qbMjsgdzT4R0XLdDqgi+es2vRzkfCFkf58/hI2VWQk6
	h6vjyoAzx2SVJKgfSd9aEBK/Sn/6AnVrx+LgNcSCAXu/BBk2BvFsvhLIBwYXzWLUJBfRL+
	YZ9Byu9GXWh1VQNU4IZvmBD/pRqi2a8=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Matt Bobrowski <mattbobrowski@google.com>
Cc: bpf@vger.kernel.org,  Michal Hocko <mhocko@suse.com>,  Alexei
 Starovoitov <ast@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  JP
 Kobryn <inwardvessel@gmail.com>,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org,  Suren Baghdasaryan <surenb@google.com>,  Johannes
 Weiner <hannes@cmpxchg.org>,  Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH bpf-next v3 02/17] bpf: allow attaching struct_ops to
 cgroups
In-Reply-To: <aXnyKw5sRt_MB-8A@google.com> (Matt Bobrowski's message of "Wed,
	28 Jan 2026 11:25:31 +0000")
References: <20260127024421.494929-1-roman.gushchin@linux.dev>
	<20260127024421.494929-3-roman.gushchin@linux.dev>
	<aXnyKw5sRt_MB-8A@google.com>
Date: Wed, 28 Jan 2026 11:18:36 -0800
Message-ID: <87tsw5y29f.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5B2AC140005
X-Stat-Signature: b1rno3ohw15b5iwrc4zacdikoyrf84xa
X-Rspam-User: 
X-HE-Tag: 1769627929-845364
X-HE-Meta: U2FsdGVkX1/AT12gwcYRbrgyjYGXqQ9dNfI8h9zFHu0MxW7QgyTEW9CmAIiuEyNTkafc+5o3rGO3UYmzkfyRTYS6zDMBO7ckcY5xF2YQBSmjKDqsyPvDyKRTCsMS1T++IGMClSYUS9NzjLD4c+CPb+lPPJ69ZlnckSO2tdB687xAgyzlR8D0uyoqBkFEy6hECTXy+ZrfHaAvjGl8FmMcTSA++8/Yb63ACZWjC73XWxbbDr2OCFs+eAB5GvCtD6ccs9xEjYbCSxL+o344siCb1U6nPJOzPiU6aJdpbkyTnrzQwpwXjdiHCuL/9ja4U/vuinyK9l5YjCyOey1au6oa9Q6jwmYuCxPVQMg6YfMty1+Qxgoori+zID48Bw+ZlJ9fMFJV9xQAUkP5zvXGQKC66z9MOMCJplmiP0AK+Z6TX67JjopwmgpdrjPlkFc6odBGFR0LZtuu5qOkh1lVWHXXjDq7ssRrnySCA43M9qBBCOAP0mwaAeQLtBtzSlgrXWnbv8oia7LXQeSBJ9UHT+dlOlsoTFW0WvAtvNl3c66kJGMe74NmgYx3Fm09R1YLcVwkZ50OnZjc18yjMCSCybO40MGqlHtl6ABphfOnx9G8CxYscQMQ+7xWPebzgr/zFEf2ThlYVJln64JLFMqizrmSaOx3F32Z4ZdgjazxU65rU828O3mt4DI3kcrD59clItck1wrdHnkoxOGFsK/slam3gdrtGauhXJ2CWGvdCZ6GZz6eqzyqrKJgJ1XieuYS1ft9ZmYjkwa8UF52jgX7OFl/CJq9spLZH3I/RqM7bmv+RFE+ybym5ltrPaKq6vh/kGDTCIRcNFpXUR78wtT2Aqq+GbBGWTjPelYm84UWDgZuikqiYk/l1rNKKF0hHmHGHY8GdA3cy0h4e4i7kd7rvY6SJ7Znxocq56CrPrb5vf8UBF7ECi4GBLWpbUqLTqHKh558Z9vGx7OorJLPdcVzrb+
 a8d7Zq62
 eIv12uVDjkZwVxEGqitckDcFpZnJu5ulYAKH+Q9sZXD+HHDgx+bYFTik471yJmqpq09g8UVr0h7xf4+zPutC/2gf3kjKQdAKcjSyl9kIzrZ9UsfSD5CYl5YIITqXHOU5QBzay2KgAmb6XJG5SmMsuGQ7OlWXSB6aNHL4H1guGW01gJ4QhRnoY1wWnBC5kXLtV911WXMvcFuFQxg1r6TLQzhxMZgA9MW2O/bheL1VeVAunro/BLdGKn2MBkooD/jKqSmLMVK1lCKUPmyg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Matt Bobrowski <mattbobrowski@google.com> writes:

> On Mon, Jan 26, 2026 at 06:44:05PM -0800, Roman Gushchin wrote:
>> Introduce an ability to attach bpf struct_ops'es to cgroups.
>> 
>> From user's standpoint it works in the following way:
>> a user passes a BPF_F_CGROUP_FD flag and specifies the target cgroup
>> fd while creating a struct_ops link. As the result, the bpf struct_ops
>> link will be created and attached to a cgroup.
>> 
>> The cgroup.bpf structure maintains a list of attached struct ops links.
>> If the cgroup is getting deleted, attached struct ops'es are getting
>> auto-detached and the userspace program gets a notification.
>> 
>> This change doesn't answer the question how bpf programs belonging
>> to these struct ops'es will be executed. It will be done individually
>> for every bpf struct ops which supports this.
>> 
>> Please, note that unlike "normal" bpf programs, struct ops'es
>> are not propagated to cgroup sub-trees.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> ---
>>  include/linux/bpf-cgroup-defs.h |  3 ++
>>  include/linux/bpf-cgroup.h      | 16 +++++++++
>>  include/linux/bpf.h             |  3 ++
>>  include/uapi/linux/bpf.h        |  3 ++
>>  kernel/bpf/bpf_struct_ops.c     | 59 ++++++++++++++++++++++++++++++---
>>  kernel/bpf/cgroup.c             | 46 +++++++++++++++++++++++++
>>  tools/include/uapi/linux/bpf.h  |  1 +
>>  7 files changed, 127 insertions(+), 4 deletions(-)
>> 
>> diff --git a/include/linux/bpf-cgroup-defs.h b/include/linux/bpf-cgroup-defs.h
>> index c9e6b26abab6..6c5e37190dad 100644
>> --- a/include/linux/bpf-cgroup-defs.h
>> +++ b/include/linux/bpf-cgroup-defs.h
>> @@ -71,6 +71,9 @@ struct cgroup_bpf {
>>  	/* temp storage for effective prog array used by prog_attach/detach */
>>  	struct bpf_prog_array *inactive;
>>  
>> +	/* list of bpf struct ops links */
>> +	struct list_head struct_ops_links;
>> +
>>  	/* reference counter used to detach bpf programs after cgroup removal */
>>  	struct percpu_ref refcnt;
>>  
>> diff --git a/include/linux/bpf-cgroup.h b/include/linux/bpf-cgroup.h
>> index 2f535331f926..a6c327257006 100644
>> --- a/include/linux/bpf-cgroup.h
>> +++ b/include/linux/bpf-cgroup.h
>> @@ -423,6 +423,11 @@ int cgroup_bpf_link_attach(const union bpf_attr *attr, struct bpf_prog *prog);
>>  int cgroup_bpf_prog_query(const union bpf_attr *attr,
>>  			  union bpf_attr __user *uattr);
>>  
>> +int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
>> +				 struct bpf_struct_ops_link *link);
>> +void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
>> +				  struct bpf_struct_ops_link *link);
>> +
>>  const struct bpf_func_proto *
>>  cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog);
>>  #else
>> @@ -451,6 +456,17 @@ static inline int cgroup_bpf_link_attach(const union bpf_attr *attr,
>>  	return -EINVAL;
>>  }
>>  
>> +static inline int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
>> +					       struct bpf_struct_ops_link *link)
>> +{
>> +	return -EINVAL;
>> +}
>> +
>> +static inline void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
>> +						struct bpf_struct_ops_link *link)
>> +{
>> +}
>> +
>>  static inline int cgroup_bpf_prog_query(const union bpf_attr *attr,
>>  					union bpf_attr __user *uattr)
>>  {
>> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> index 899dd911dc82..391888eb257c 100644
>> --- a/include/linux/bpf.h
>> +++ b/include/linux/bpf.h
>> @@ -1894,6 +1894,9 @@ struct bpf_raw_tp_link {
>>  struct bpf_struct_ops_link {
>>  	struct bpf_link link;
>>  	struct bpf_map __rcu *map;
>> +	struct cgroup *cgroup;
>> +	bool cgroup_removed;
>> +	struct list_head list;
>>  	wait_queue_head_t wait_hup;
>>  };
>>  
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index 44e7dbc278e3..28544e8af1cd 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -1237,6 +1237,7 @@ enum bpf_perf_event_type {
>>  #define BPF_F_AFTER		(1U << 4)
>>  #define BPF_F_ID		(1U << 5)
>>  #define BPF_F_PREORDER		(1U << 6)
>> +#define BPF_F_CGROUP_FD		(1U << 7)
>>  #define BPF_F_LINK		BPF_F_LINK /* 1 << 13 */
>>  
>>  /* If BPF_F_STRICT_ALIGNMENT is used in BPF_PROG_LOAD command, the
>> @@ -6775,6 +6776,8 @@ struct bpf_link_info {
>>  		} xdp;
>>  		struct {
>>  			__u32 map_id;
>> +			__u32 :32;
>> +			__u64 cgroup_id;
>>  		} struct_ops;
>>  		struct {
>>  			__u32 pf;
>> diff --git a/kernel/bpf/bpf_struct_ops.c b/kernel/bpf/bpf_struct_ops.c
>> index de01cf3025b3..2e361e22cfa0 100644
>> --- a/kernel/bpf/bpf_struct_ops.c
>> +++ b/kernel/bpf/bpf_struct_ops.c
>> @@ -13,6 +13,8 @@
>>  #include <linux/btf_ids.h>
>>  #include <linux/rcupdate_wait.h>
>>  #include <linux/poll.h>
>> +#include <linux/bpf-cgroup.h>
>> +#include <linux/cgroup.h>
>>  
>>  struct bpf_struct_ops_value {
>>  	struct bpf_struct_ops_common_value common;
>> @@ -1220,6 +1222,10 @@ static void bpf_struct_ops_map_link_dealloc(struct bpf_link *link)
>>  		st_map->st_ops_desc->st_ops->unreg(&st_map->kvalue.data, link);
>>  		bpf_map_put(&st_map->map);
>>  	}
>> +
>> +	if (st_link->cgroup)
>> +		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
>> +
>>  	kfree(st_link);
>>  }
>>  
>> @@ -1228,6 +1234,7 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
>>  {
>>  	struct bpf_struct_ops_link *st_link;
>>  	struct bpf_map *map;
>> +	u64 cgrp_id = 0;
>
> Assigning 0 to cgrp_id would technically be incorrect, right? Like,
> cgroup_id() for !CONFIG_CGROUPS default to returning 1, and for
> CONFIG_CGROUPS the ID allocation is done via the idr_alloc_cyclic()
> API using a range between 1 and INT_MAX. Perhaps here it serves as a
> valid sentinel value? Is that the rationale?

Yes. Idk, maybe (u64)-1 works better here, I don't have a strong
opinion. Realistically I doubt there are too many bpf users with
!CONFIG_CGROUPS. Alexei even suggested in the past to make CONFIG_MEMCG
mandatory, which implies CONFIG_CGROUPS.

> In general, shouldn't all the cgroup related logic within this source
> file be protected by a CONFIG_CGROUPS ifdef? For example, both
> cgroup_get_from_fd() and cgroup_put() lack stubs when building with
> !CONFIG_CGROUPS.
>
>>  	st_link = container_of(link, struct bpf_struct_ops_link, link);
>>  	rcu_read_lock();
>> @@ -1235,6 +1242,14 @@ static void bpf_struct_ops_map_link_show_fdinfo(const struct bpf_link *link,
>>  	if (map)
>>  		seq_printf(seq, "map_id:\t%d\n", map->id);
>>  	rcu_read_unlock();
>> +
>> +	cgroup_lock();
>> +	if (st_link->cgroup)
>> +		cgrp_id = cgroup_id(st_link->cgroup);
>> +	cgroup_unlock();
>> +
>> +	if (cgrp_id)
>> +		seq_printf(seq, "cgroup_id:\t%llu\n", cgrp_id);
>
> Probably could introduce a simple inline helper for the
> cgroup_lock()/cgroup_id()/cgroup_unlock() dance that's going on in
> here and bpf_struct_ops_map_link_fill_link_info() below.

I'll try, thanks!

>
>>  }
>>  
>>  static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
>> @@ -1242,6 +1257,7 @@ static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
>>  {
>>  	struct bpf_struct_ops_link *st_link;
>>  	struct bpf_map *map;
>> +	u64 cgrp_id = 0;
>>  
>>  	st_link = container_of(link, struct bpf_struct_ops_link, link);
>>  	rcu_read_lock();
>> @@ -1249,6 +1265,13 @@ static int bpf_struct_ops_map_link_fill_link_info(const struct bpf_link *link,
>>  	if (map)
>>  		info->struct_ops.map_id = map->id;
>>  	rcu_read_unlock();
>> +
>> +	cgroup_lock();
>> +	if (st_link->cgroup)
>> +		cgrp_id = cgroup_id(st_link->cgroup);
>> +	cgroup_unlock();
>> +
>> +	info->struct_ops.cgroup_id = cgrp_id;
>
> As mentioned above a simple inline helper could simply yield the
> following here:
>
> ...
> 	  info->struct_ops.cgroup_id = bpf_struct_ops_lin_cgroup_id();
> ...
>
>>  	return 0;
>>  }
>>  
>> @@ -1327,6 +1350,9 @@ static int bpf_struct_ops_map_link_detach(struct bpf_link *link)
>>  
>>  	mutex_unlock(&update_mutex);
>>  
>> +	if (st_link->cgroup)
>> +		cgroup_bpf_detach_struct_ops(st_link->cgroup, st_link);
>> +
>>  	wake_up_interruptible_poll(&st_link->wait_hup, EPOLLHUP);
>>  
>>  	return 0;
>> @@ -1339,6 +1365,9 @@ static __poll_t bpf_struct_ops_map_link_poll(struct file *file,
>>  
>>  	poll_wait(file, &st_link->wait_hup, pts);
>>  
>> +	if (st_link->cgroup_removed)
>> +		return EPOLLHUP;
>> +
>>  	return rcu_access_pointer(st_link->map) ? 0 : EPOLLHUP;
>>  }
>>  
>> @@ -1357,8 +1386,12 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>>  	struct bpf_link_primer link_primer;
>>  	struct bpf_struct_ops_map *st_map;
>>  	struct bpf_map *map;
>> +	struct cgroup *cgrp;
>>  	int err;
>>  
>> +	if (attr->link_create.flags & ~BPF_F_CGROUP_FD)
>> +		return -EINVAL;
>> +
>
> BPF_F_CGROUP_FD is dependent on the cgroup subsystem, therefore it
> probably makes some sense to only accept BPF_F_CGROUP_FD when
> CONFIG_BPF_CGROUP is enabled, otherwise -EOPNOTSUPP?
>
> I'd also probably rewrite this such that we do:
>
> ...
> 	struct cgroup *cgrp = NULL;
> 	...
> 	if (attr->link_create.flags & ~BPF_F_CGROUP_FD) {
> #if IS_ENABLED(CONFIG_CGROUP_BPF)
> 	cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
> 	if (IS_ERR(cgrp))
> 		return PTR_ERR(cgrp);
> #else
> 	return -EOPNOTSUPP;
> #endif
> 	}
> ...
> 	if (cgrp) {
> 		link->cgroup = cgrp;
> 		if (cgroup_bpf_attach_struct_ops(cgrp, link)) {
> 		   cgroup_put(cgrp);
> 		   goto err_out;
> 		}
> 	}
>
> IMO the code is cleaner and reads better too.
>
>>  	map = bpf_map_get(attr->link_create.map_fd);
>>  	if (IS_ERR(map))
>>  		return PTR_ERR(map);
>> @@ -1378,11 +1411,26 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>>  	bpf_link_init(&link->link, BPF_LINK_TYPE_STRUCT_OPS, &bpf_struct_ops_map_lops, NULL,
>>  		      attr->link_create.attach_type);
>>  
>> +	init_waitqueue_head(&link->wait_hup);
>> +
>> +	if (attr->link_create.flags & BPF_F_CGROUP_FD) {
>> +		cgrp = cgroup_get_from_fd(attr->link_create.target_fd);
>> +		if (IS_ERR(cgrp)) {
>> +			err = PTR_ERR(cgrp);
>> +			goto err_out;
>> +		}
>> +		link->cgroup = cgrp;
>> +		err = cgroup_bpf_attach_struct_ops(cgrp, link);
>> +		if (err) {
>> +			cgroup_put(cgrp);
>> +			link->cgroup = NULL;
>> +			goto err_out;
>> +		}
>> +	}
>> +
>>  	err = bpf_link_prime(&link->link, &link_primer);
>>  	if (err)
>> -		goto err_out;
>> -
>> -	init_waitqueue_head(&link->wait_hup);
>> +		goto err_put_cgroup;
>>  
>>  	/* Hold the update_mutex such that the subsystem cannot
>>  	 * do link->ops->detach() before the link is fully initialized.
>> @@ -1393,13 +1441,16 @@ int bpf_struct_ops_link_create(union bpf_attr *attr)
>>  		mutex_unlock(&update_mutex);
>>  		bpf_link_cleanup(&link_primer);
>>  		link = NULL;
>> -		goto err_out;
>> +		goto err_put_cgroup;
>>  	}
>>  	RCU_INIT_POINTER(link->map, map);
>>  	mutex_unlock(&update_mutex);
>>  
>>  	return bpf_link_settle(&link_primer);
>>  
>> +err_put_cgroup:
>> +	if (link && link->cgroup)
>> +		cgroup_bpf_detach_struct_ops(link->cgroup, link);
>>  err_out:
>>  	bpf_map_put(map);
>>  	kfree(link);
>> diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
>> index 69988af44b37..7b1903be6f69 100644
>> --- a/kernel/bpf/cgroup.c
>> +++ b/kernel/bpf/cgroup.c
>> @@ -16,6 +16,7 @@
>>  #include <linux/bpf-cgroup.h>
>>  #include <linux/bpf_lsm.h>
>>  #include <linux/bpf_verifier.h>
>> +#include <linux/poll.h>
>>  #include <net/sock.h>
>>  #include <net/bpf_sk_storage.h>
>>  
>> @@ -307,12 +308,23 @@ static void cgroup_bpf_release(struct work_struct *work)
>>  					       bpf.release_work);
>>  	struct bpf_prog_array *old_array;
>>  	struct list_head *storages = &cgrp->bpf.storages;
>> +	struct bpf_struct_ops_link *st_link, *st_tmp;
>>  	struct bpf_cgroup_storage *storage, *stmp;
>> +	LIST_HEAD(st_links);
>>  
>>  	unsigned int atype;
>>  
>>  	cgroup_lock();
>>  
>> +	list_splice_init(&cgrp->bpf.struct_ops_links, &st_links);
>> +	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
>> +		st_link->cgroup = NULL;
>> +		st_link->cgroup_removed = true;
>> +		cgroup_put(cgrp);
>> +		if (IS_ERR(bpf_link_inc_not_zero(&st_link->link)))
>> +			list_del(&st_link->list);
>> +	}
>> +
>>  	for (atype = 0; atype < ARRAY_SIZE(cgrp->bpf.progs); atype++) {
>>  		struct hlist_head *progs = &cgrp->bpf.progs[atype];
>>  		struct bpf_prog_list *pl;
>> @@ -346,6 +358,11 @@ static void cgroup_bpf_release(struct work_struct *work)
>>  
>>  	cgroup_unlock();
>>  
>> +	list_for_each_entry_safe(st_link, st_tmp, &st_links, list) {
>> +		st_link->link.ops->detach(&st_link->link);
>> +		bpf_link_put(&st_link->link);
>> +	}
>> +
>>  	for (p = cgroup_parent(cgrp); p; p = cgroup_parent(p))
>>  		cgroup_bpf_put(p);
>>  
>> @@ -525,6 +542,7 @@ static int cgroup_bpf_inherit(struct cgroup *cgrp)
>>  		INIT_HLIST_HEAD(&cgrp->bpf.progs[i]);
>>  
>>  	INIT_LIST_HEAD(&cgrp->bpf.storages);
>> +	INIT_LIST_HEAD(&cgrp->bpf.struct_ops_links);
>>  
>>  	for (i = 0; i < NR; i++)
>>  		if (compute_effective_progs(cgrp, i, &arrays[i]))
>> @@ -2759,3 +2777,31 @@ cgroup_common_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
>>  		return NULL;
>>  	}
>>  }
>> +
>> +int cgroup_bpf_attach_struct_ops(struct cgroup *cgrp,
>> +				 struct bpf_struct_ops_link *link)
>> +{
>> +	int ret = 0;
>> +
>> +	cgroup_lock();
>> +	if (percpu_ref_is_zero(&cgrp->bpf.refcnt)) {
>> +		ret = -EBUSY;
>
> If the cgroup is dying, then perhaps -EINVAL would be more appropriate
> here, no? I'd argue that -EBUSY implies a temporary or transient
> state.

Idk, I thought about it and settled on -EBUSY to highlight the
transient nature of the issue. ENOENT is another option.
I don't really think EINVAL is the best choice here.

>
>> +		goto out;
>> +	}
>> +	list_add_tail(&link->list, &cgrp->bpf.struct_ops_links);
>> +out:
>> +	cgroup_unlock();
>> +	return ret;
>> +}
>> +
>> +void cgroup_bpf_detach_struct_ops(struct cgroup *cgrp,
>> +				  struct bpf_struct_ops_link *link)
>> +{
>> +	cgroup_lock();
>> +	if (link->cgroup == cgrp) {
>> +		list_del(&link->list);
>> +		link->cgroup = NULL;
>> +		cgroup_put(cgrp);
>> +	}
>> +	cgroup_unlock();
>> +}
>
> Within cgroup_bpf_attach_struct_ops() and
> cgroup_bpf_detach_struct_ops() the cgrp pointer appears to be
> superfluous? Both should probably only operate on link->cgroup
> instead? A !link->cgroup when calling either should be considered as
> -EINVAL.

Ack.

Thank you for the review!

