Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53332EF99EA
	for <linux-mm@archiver.kernel.org>; Sat, 14 Feb 2026 00:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B6CB6B0005; Fri, 13 Feb 2026 19:57:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38E746B0088; Fri, 13 Feb 2026 19:57:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAF16B008A; Fri, 13 Feb 2026 19:57:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6166B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 19:57:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 51EB31607B8
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 00:57:06 +0000 (UTC)
X-FDA: 84441248052.23.CD243C8
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79B1F100003
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 00:57:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771030624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TzE2JrKPEpT8ZsMZk1kjQsBlsFrjgL0kTfQZoINMbMU=;
	b=eTG8WeZCGrexzO+AGH3dBZwAF1cLFbKnRiESohRihvavOmy2F97HmtOTBveaWqvPeiJxs3
	jiIQLPCpfZvZ9ktUKSyd6jv91nYoGEmi5nXtgKiPi6MVHRQAM0Ovu4/SXIw8H1Vuh+ZL+G
	/BqALQbYUjCeQhryEoFGeSCFTiBvyb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771030624; a=rsa-sha256;
	cv=none;
	b=uFgKEw72F5qAEkJt48jjSr2Npo9sUV7B17jJI0Uj9F2ohr2fdd7xnCskaCogjZfmX3BraX
	AYRRAjBWtOg9z1B2HkReo8HDxCi7RVdFTSytlC9ijeEVsw5Oz0TJVfZ8spBsI3RwODndd3
	gs2X6YjGFxzmcjBzcrrSrVisyl6l9kw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fCVwL041ZzKHLyB
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:56:18 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E96204058A
	for <linux-mm@kvack.org>; Sat, 14 Feb 2026 08:56:55 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgB3I_RWyI9ppdNrHQ--.4951S2;
	Sat, 14 Feb 2026 08:56:55 +0800 (CST)
Message-ID: <f96cb0e5-da3d-422a-aa14-2a52f5f0aad9@huaweicloud.com>
Date: Sat, 14 Feb 2026 08:56:54 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: consolidate private id refcount get/put helpers
To: Kairui Song <ryncsn@gmail.com>, cgroups@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
 Kairui Song <kasong@tencent.com>
References: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260213-memcg-privid-v1-1-d8cb7afcf831@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgB3I_RWyI9ppdNrHQ--.4951S2
X-Coremail-Antispam: 1UD129KBjvJXoW3Gw1UtFWkWF15AryUXFWfuFg_yoW7urWDpF
	sIkan0yayrJrW7GF1Ska429FyfZa18Xw45XFyxKw17Zrnxtw15XF17tr98XayUCF97trsx
	Jan0yr1kGw4YyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUF1
	v3UUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 79B1F100003
X-Stat-Signature: ry99f3eczw7n48p8stq4nry6fzwkqm71
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1771030621-189814
X-HE-Meta: U2FsdGVkX18A8w+M8FG3INf8x1SEJ3lCVSCK0WH9nAXmaf6b7+yHLKVjs3IYF1nHtA5yiG7gYYp/J685N/lvSeImUpj2JGei4rIpwGJSQI7uhbI01wRZWVlBWHcAz9BwlYACW4dBx7XkeRpxQyDB2ril/0hXJflFr5yyeRVYhZPIUbfpLyJGkFolErQqRlMOqu/aFjUD6U1gPh1LNY8JiSWypJPUUzhnKElxVBRA8tEZyMXKIEMNfOKDaDeH7vWtJ5oTidDznAXVRt9HC7OosoaosRVH24C/7etjLivPBUtKWF2oDuuRZlGgUM7PJo7aeRxAoU4xPW9yAhNkypve1XgnbXdCK2hnRmjGeufxycCeDekX1EhS78AIptVpw2OyTpAKPIsFzATLbWJ7LgGP4JzRakP7PVIZ+zKIsoAvsmVWTFlsMbJcN1p+b4EotovrzlJaqiYK59EBTNT5kpROpdr2fNaQTBNDFQP73ufzH93L4sCdCbmNqT+fgzzCilF0/xvul474A+2yG/8Hld/jT+5jwtsRNHEoeMsNzHuJf6LDS8p6pHfuhg/WTyQ0UivomBTkbrUH9BFVdyMRWPtynX17kK8gZ1ZgVT+AWzWydtenyOejY8QNOmSGWlVBwLtC7ad2YmC+H2SL07noK6aA00/1vhoGE5SGRq8fjkaLwWBC0ZiQxJ5hZrpAdS7vnajW2jkA0WV2b8XrIT/VEwGU07WVr0DO1X7757VDF1QEQFBTDRVTKdSkljgvMFpsCaTLMCgKvbxCfxRIKBij5aBOS9dE2adYgR5GophsyT4TrKhzEI8RltAIulVU+VnkvjqzIXOzVDhf0BR4YhjsNf3RrLAv+wJFdhFVihRcXjPzTiyoc4Uu6r3wq0C1vLZ7AdwDQLgiSO4ZL9jr7xXzr735vVVGrnvB+ijqMjbAYbIt3G0V762CnarLyCJYFRn4VZWNNxISCYu76gaqOSejKnJ
 RA+R8Xle
 AxadW3JBYErsFHuhahM9DO/5OOh1ts32i7qYVXZN5Xn+9A3xR7gI2EKYB9L/AHiJMrFIXOwAF30tmgD8FBCoeisivrRZPsJ/xtK7tIf7Me9FLHpLJrtbpRIgyTG8sGl9JEJiz1nhMr9hCpKG5osmVSEPujImdmnCMroGH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/13 18:03, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> We currently have two different sets of helpers for getting or putting
> the private IDs' refcount for order 0 and large folios. This is
> redundant. Just use one and always acquire the refcount of the swapout
> folio size unless it's zero, and put the refcount using the folio size
> if the charge failed, since the folio size can't change. Then there is
> no need to update the refcount for tail pages.
> 
> Same for freeing, then only one pair of get/put helper is needed now.
> 
> The performance might be slightly better, too: both "inc unless zero"
> and "add unless zero" use the same cmpxchg implementation. For large
> folios, we saved an atomic operation. And for both order 0 and large
> folios, we saved a branch.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/memcontrol-v1.c |  5 +----
>  mm/memcontrol-v1.h |  4 ++--
>  mm/memcontrol.c    | 29 +++++++----------------------
>  3 files changed, 10 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index 0e3d972fad33..c28a060abc64 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -635,11 +635,8 @@ void memcg1_swapout(struct folio *folio, swp_entry_t entry)
>  	 * have an ID allocated to it anymore, charge the closest online
>  	 * ancestor for the swap instead and transfer the memory+swap charge.
>  	 */
> -	swap_memcg = mem_cgroup_private_id_get_online(memcg);
>  	nr_entries = folio_nr_pages(folio);
> -	/* Get references for the tail pages, too */
> -	if (nr_entries > 1)
> -		mem_cgroup_private_id_get_many(swap_memcg, nr_entries - 1);
> +	swap_memcg = mem_cgroup_private_id_get_online(memcg, nr_entries);
>  	mod_memcg_state(swap_memcg, MEMCG_SWAP, nr_entries);
>  
>  	swap_cgroup_record(folio, mem_cgroup_private_id(swap_memcg), entry);
> diff --git a/mm/memcontrol-v1.h b/mm/memcontrol-v1.h
> index 49933925b4ba..dbbd0e13d4ff 100644
> --- a/mm/memcontrol-v1.h
> +++ b/mm/memcontrol-v1.h
> @@ -28,8 +28,8 @@ unsigned long memcg_events(struct mem_cgroup *memcg, int event);
>  unsigned long memcg_page_state_output(struct mem_cgroup *memcg, int item);
>  int memory_stat_show(struct seq_file *m, void *v);
>  
> -void mem_cgroup_private_id_get_many(struct mem_cgroup *memcg, unsigned int n);
> -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg);
> +struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg,
> +						    unsigned int n);
>  
>  /* Cgroup v1-specific declarations */
>  #ifdef CONFIG_MEMCG_V1
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 007413a53b45..4425ef51feae 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3564,13 +3564,7 @@ static void mem_cgroup_private_id_remove(struct mem_cgroup *memcg)
>  	}
>  }
>  
> -void __maybe_unused mem_cgroup_private_id_get_many(struct mem_cgroup *memcg,
> -					   unsigned int n)
> -{
> -	refcount_add(n, &memcg->id.ref);
> -}
> -
> -static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned int n)
> +static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg, unsigned int n)
>  {
>  	if (refcount_sub_and_test(n, &memcg->id.ref)) {
>  		mem_cgroup_private_id_remove(memcg);
> @@ -3580,14 +3574,9 @@ static void mem_cgroup_private_id_put_many(struct mem_cgroup *memcg, unsigned in
>  	}
>  }
>  
> -static inline void mem_cgroup_private_id_put(struct mem_cgroup *memcg)
> +struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg, unsigned int n)
>  {
> -	mem_cgroup_private_id_put_many(memcg, 1);
> -}
> -
> -struct mem_cgroup *mem_cgroup_private_id_get_online(struct mem_cgroup *memcg)
> -{
> -	while (!refcount_inc_not_zero(&memcg->id.ref)) {
> +	while (!refcount_add_not_zero(n, &memcg->id.ref)) {
>  		/*
>  		 * The root cgroup cannot be destroyed, so it's refcount must
>  		 * always be >= 1.
> @@ -3888,7 +3877,7 @@ static void mem_cgroup_css_offline(struct cgroup_subsys_state *css)
>  
>  	drain_all_stock(memcg);
>  
> -	mem_cgroup_private_id_put(memcg);
> +	mem_cgroup_private_id_put(memcg, 1);
>  }
>  
>  static void mem_cgroup_css_released(struct cgroup_subsys_state *css)
> @@ -5170,19 +5159,15 @@ int __mem_cgroup_try_charge_swap(struct folio *folio, swp_entry_t entry)
>  		return 0;
>  	}
>  
> -	memcg = mem_cgroup_private_id_get_online(memcg);
> +	memcg = mem_cgroup_private_id_get_online(memcg, nr_pages);
>  
>  	if (!mem_cgroup_is_root(memcg) &&
>  	    !page_counter_try_charge(&memcg->swap, nr_pages, &counter)) {
>  		memcg_memory_event(memcg, MEMCG_SWAP_MAX);
>  		memcg_memory_event(memcg, MEMCG_SWAP_FAIL);
> -		mem_cgroup_private_id_put(memcg);
> +		mem_cgroup_private_id_put(memcg, nr_pages);
>  		return -ENOMEM;
>  	}
> -
> -	/* Get references for the tail pages, too */
> -	if (nr_pages > 1)
> -		mem_cgroup_private_id_get_many(memcg, nr_pages - 1);
>  	mod_memcg_state(memcg, MEMCG_SWAP, nr_pages);
>  
>  	swap_cgroup_record(folio, mem_cgroup_private_id(memcg), entry);
> @@ -5211,7 +5196,7 @@ void __mem_cgroup_uncharge_swap(swp_entry_t entry, unsigned int nr_pages)
>  				page_counter_uncharge(&memcg->swap, nr_pages);
>  		}
>  		mod_memcg_state(memcg, MEMCG_SWAP, -nr_pages);
> -		mem_cgroup_private_id_put_many(memcg, nr_pages);
> +		mem_cgroup_private_id_put(memcg, nr_pages);
>  	}
>  	rcu_read_unlock();
>  }
> 
> ---
> base-commit: 9fff1ab283e0982c2b8e73f1d2246fd38caf40c8
> change-id: 20260213-memcg-privid-6ba2773b5ca2
> 
> Best regards,

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


