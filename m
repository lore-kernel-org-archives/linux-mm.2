Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 599FFC624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 07:29:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A336B0088; Sat,  5 Sep 2026 03:29:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441756B008A; Sat,  5 Sep 2026 03:29:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D996B008C; Sat,  5 Sep 2026 03:29:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 152196B0088
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 03:29:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D84216028F
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:29:15 +0000 (UTC)
X-FDA: 85178882670.16.5C6F1FD
Received: from mta0.migadu.com (out-7.mta0.migadu.com [91.218.175.7])
	by imf19.hostedemail.com (Postfix) with ESMTP id 423991A0003
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 07:29:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sn8e1vKp;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788593353;
	b=bA44mveuudT8EHZqDXeolbQsMX7X/1EkS0uGl/5njph3PUCPiTttyypeKuCoW7xtEJz19V
	IAA+FNdIKAhyHaqroRoSp2Bs83VVwqIRbrUD+3xLjuxnQ5d2ixwG8GJ6topz2jBVCL/uHN
	LJjom/5qwo0smeugM1JxfBZxaXNioJ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sn8e1vKp;
	spf=pass (imf19.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.7 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788593353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVDtc5o3Vg32slMdUgnQqcVwTfeVellkY+yhbIFEgvo=;
	b=hps6GDbQTN4eY29zxfrK3X5ip19WpHR/qp/OUlmQO+gu5NRLiGXmmCGwS79JKbDHrBQLJn
	zSdHrj3hv7+Rsxq5NhUZvSWXethUelsHduz4g/GUFyHn0UAngO/drt0PamR/mvncvm8uPc
	XSzlgFsdiOL1PrQHDQuX8EnaI6p/T2M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FO7uk+ZczJKUWeZKSugD0fmMxualw4LCIKgewWBGV1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788593350; v=1; x=1789198150;
 b=Sn8e1vKpmMPzdYYzJRR4lZuz2OnF8SaOrtUCfRegQ6mwhNhdspWOSbjzHto9eMcCEipcYypD
 bZA+B8dRa3NfRSh/30yhj95DT0R3f9UsbzmvtmFT//sQPmCEHFQlD/LQAvgsBO2mYu/SeNnEG6L
 FzA8qlxdk48nthKbhlHy2qCA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d6a05955758b5d40;
	Sat, 05 Sep 2026 07:29:00 +0000
X-Mizu-Trace-ID: d6a05955758b5d40
X-Migadu-Flow: FLOW_OUT
Message-ID: <c3bec318-ef9d-4d96-8a98-a68717c17201@linux.dev>
Date: Sat, 5 Sep 2026 15:28:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2 4/6] mm/memcg: return the memcg when putting
 memcgid
To: bingfangguo@tencent.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Dave Chinner
 <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Bingfang Guo <bfguo@icloud.com>
References: <20260901-bingfangguo-memcgid-rework-v2-0-8edd7f7a7251@tencent.com>
 <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
Content-Language: en-US
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260901-bingfangguo-memcgid-rework-v2-4-8edd7f7a7251@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ct3khwbegdrihjahodsbfnsftjz67arr
X-Rspamd-Queue-Id: 423991A0003
X-Rspamd-Server: rspam06
X-HE-Tag: 1788593352-337180
X-HE-Meta: U2FsdGVkX18ah44kcs+letB6Op5IqUKp7VWfZq9QwX7uXcF9+9njNB7No1WycIAc4pyDxek1GVy12wwY1Y8CH1KXxB3q7ykeaWF7U9FobZ9JI5UCuZQhx/7wy4n5fLqYWeAJCcNergMacnFaXoEADuhLFKA3dCKHFKjd+SYGuly4Ysym3ZrUgtk2dl50CGOVPabestXBWoj4lIcQ6mxZT3eDRocbQz0Pnxl4zj+lbHRZECmW6YRcRCLI2aFGNT5hfJKGs6O4r63FTfKNNlJwh1m2BxudjDKXNkQ0Y78ggsBYLsuE6PRs5iBaIrW3Jq3DmZvhshTNOGVtYj+Ps3sPSffhXvHOPcTrj1B2lQYrDwqSL9MexKqEQt6B0Aw19+8mer0ajwEeaC1PBRG5rk+87wreeIEIl+1CZEaJd9izoQziLQc8cb7xdNd+ZiKUBCYU8SoVVHe2XfnHwLmHkEx2bSlVvDA+lnaDIwhLrQfRTpmZfYauwsk3HG1rJnZvH/S78t0qLRpN2HCA7394i85JXc0tyZzJqf0UzWROxkWgFqu9tNoYMeyNhVYnqwq1pJOYOx//zxQHkR4lxyirj06mi3ifNVFivfSH79TYTiGbfFFjUd3W1RMSpQ7T2OGz8uWZmtQzcVnSPpYFJhWFBe5b8PW65qBHRlyPYVwtg3db+YD0MgRPrwLtRHe8ym1SQpurRWzZIzb/45wnRkVHkZ6dEROg1H8BcBdUEE/8wMuNnUT3F9sDRrIMdnih9LP6qo3JsXlfCZI/C2MD1Xv+W+DFGLBde/qaVNTQhVnzgpB1jnOFAS3OZkd4IWtzlCSwlKENHNnbLO7InGDXwO/mXqQLN8OvgQ20zIdWrWFlcGZnIsdDm1YLN3rOjqrNXzuNVQiyDqBtSKeVzc+gEzVCodvE3Use2KBa/zzRccM3Xz3AF9ZM3HtDP5Eg23d6uzQKUDrkk60MF6AqRVFQQHfuk0W
 Rv+Lfyej
 m5Qkow4u8I4cCkvvD1tgwQA3Y8I4HbyxK7ysJ3IzSV1V7fW7PC2eKwnhyDeuhHMl+yC6dpVc+BaL2jTHtzL9rYwmwSARwj/C8uBtVPeqx/0+ct/nKDfjxsSVtxYXWhJKvYcgUeUuSOYMXNJuMLq0FNIiYX3ArDMb6jwRQH7uEY8e/pbS1Mqddonc+e5ktasW59xd83iryAc6A+BMfLmQUqA8KTo9eK0iVBC58pOmK/biroDULTOD/+991m94fDbO6xo+3gAWcOegtfsoPJ6MgA44BWBcmQcuG8kUvBEkB+XgLth0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/9/1 16:58, Bingfang Guo via B4 Relay wrote:
> From: Bingfang Guo <bingfangguo@tencent.com>
>
> __mem_cgroup_uncharge_swap() needs both the memcg and the id refcount
> drop.  Right now it looks the memcg up by id, uncharges it, then looks
> it up again inside mem_cgroup_private_id_put() to drop the reference.
>
> Make mem_cgroup_private_id_put() resolve the id once, drop the
> reference, and return the nearest online memcg with a reference held for
> the caller.  __mem_cgroup_uncharge_swap() then uses that memcg directly
> and drops the reference after uncharging, avoiding the second xarray
> lookup.
>
> Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
> ---
>   mm/memcontrol.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 048c9bb0fad79..f0503a1e5492d 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4048,14 +4048,28 @@ static void __mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n
>   	}
>   }
>   
> -static void mem_cgroup_private_id_put(unsigned short id, unsigned int n)
> +/**
> + * mem_cgroup_private_id_put - put memcgid and get the nearest online memcg
> + * @id: the memcg private id got from mem_cgroup_id_get_online
> + * @n: count of references to put
> + */
> +static struct mem_cgroup *mem_cgroup_private_id_put(unsigned short id, unsigned int n)

Having an API that put reference-counted resources return a struct pointer
is a very strange design. Please don't do that.

>   {
>   	struct mem_cgroup *memcg;
>   
>   	rcu_read_lock();
>   	memcg = mem_cgroup_from_private_id(id);
> +	if (!memcg)
> +		goto out;
> +
>   	__mem_cgroup_private_id_put(memcg, n);
> +
> +	while (memcg_is_dying(memcg) || !mem_cgroup_tryget(memcg))
> +		memcg = parent_mem_cgroup(memcg);
> +
> +out:
>   	rcu_read_unlock();
> +	return memcg;
>   }
>   
>   static void mem_cgroup_private_id_kill(struct mem_cgroup *memcg)
> @@ -5816,7 +5830,7 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   	struct mem_cgroup *memcg;
>   
>   	rcu_read_lock();
> -	memcg = mem_cgroup_from_private_id(id);

I think we can introduce a new helper like obj_cgroup_from_private_id(),
We can use the ID to get the corresponding obj_cgroup, and then get the
mem_cgroup.

Muhcun,
Thanks.
> +	memcg = mem_cgroup_private_id_put(id, nr_pages);
>   	if (memcg) {
>   		if (!mem_cgroup_is_root(memcg)) {
>   			if (do_memsw_account())
> @@ -5825,10 +5839,10 @@ void __mem_cgroup_uncharge_swap(unsigned short id, unsigned int nr_pages)
>   				page_counter_uncharge(&memcg->swap, nr_pages);
>   		}
>   		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> -		mem_cgroup_private_id_put(id, nr_pages);
>   	}
>   	rcu_read_unlock();
>   
> +	mem_cgroup_put(memcg);
>   }
>   
>   long mem_cgroup_get_nr_swap_pages(struct mem_cgroup *memcg)
>


