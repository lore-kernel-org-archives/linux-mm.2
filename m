Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BD40E7AD78
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 931BA6B0088; Thu, 25 Dec 2025 21:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5686B0089; Thu, 25 Dec 2025 21:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B77B6B008A; Thu, 25 Dec 2025 21:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A26F6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:29:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BA121408F2
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:29:26 +0000 (UTC)
X-FDA: 84260040732.15.913D10A
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6FA8B140008
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:29:20 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766716164; a=rsa-sha256;
	cv=none;
	b=Dv0HG2jQZFoXHItAUoGrkUan94jCD0WbIYhNql88HwBwmWBFTwhQtaXr9M7k4aoBrNEMC5
	HG1KRWlBRy4oI1JFMa9dQ/w+jW1S7B8fer1V9pfa3Fjd6JslGiTQ8SyZkgBOZkHkDrQ9+2
	DKgvCjEXPCqiz+AlWGzMIWBsYPzTq+U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766716164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EglM8RmrzRaeH2nN610Fc9DffZwAgKEyt3X5gxV+fUU=;
	b=N8RY20tuSV3V106VEewEiHoviQyufCudiFHnxN4dHfmA1JZjYH2QP0apvtiNpWoUn8lQaI
	gX5n/8ZRdS2MDeySeLH4uQzoxK6jKKSRNe8c0A4A5dWOd90ZnRkmt0kZeggd5fo2B1DL9/
	HG6nOFWVABpEaFOlSYpt9Ku3Rhz0krE=
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcqLF4YZqzKHMTQ
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:28:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D3CA040574
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:29:15 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgAXefn68k1pwXQEBg--.55072S2;
	Fri, 26 Dec 2025 10:29:15 +0800 (CST)
Message-ID: <76e134d7-19ae-43dd-abb8-6ce8ba24670c@huaweicloud.com>
Date: Fri, 26 Dec 2025 10:29:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 15/28] mm: memcontrol: prevent memory cgroup release in
 mem_cgroup_swap_full()
To: Shakeel Butt <shakeel.butt@linux.dev>, Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4dd1fb48ef4367e0932dbe7265d876bd95880808.1765956025.git.zhengqi.arch@bytedance.com>
 <hvta76slujbvyb4av4cgipcevd7jctjrq2tmyw2pwpynfpjytg@ihr3aqp2brzq>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <hvta76slujbvyb4av4cgipcevd7jctjrq2tmyw2pwpynfpjytg@ihr3aqp2brzq>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgAXefn68k1pwXQEBg--.55072S2
X-Coremail-Antispam: 1UD129KBjvJXoWxJw4fKr1UWr1DAr1fKryUZFb_yoW5Xr1rpF
	Z5Kas8AF48Aw4xur1aq3Wj9ryFy3yIqws8tFWxKw1fA3W3Xwn8CrW7Kw1UXa45AF1xuFyx
	XF1jv3W7uayjya7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	jIksgUUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 6FA8B140008
X-Stat-Signature: 1gwj6ktu9r4np7jcrcxa1s7r7a59qbes
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766716160-843832
X-HE-Meta: U2FsdGVkX19jCj9rFtP2n9hruI/cWbWFg19UKxZ+820kccu8kN+e0zqzKuCMtMk0FezOwYyPU+cgV5VDJ1n2O5i082wNWDhao7L2GHfAT+hqj54Kxl3t0pMoZghjo80C/TDE3OaoU9MJeYm0d2jz6dPb6KRItDK8sKiMcFkOwahJhP+XSjp9LECmAydnWoik8ePTRdc3+WvIjgJrIIAA2gslARS15P6PwqMf0NtXsRUBMncmzjsnsCEixdrZlAx8fKAQrtnNheQKFZIa6Y1qDkk+N+IxJ01kBa/Wqg3yn6rIIrAUdtsSYAAt6EKm2NrrVbe97BZa0LdPZ7dhURpx9AqrLUG/idvWJArJa90DWa0v3AZ9DGP6XH1AR7eK7tJkdlYklXe8ISyWF5biJt8ZcZYUOLiLAefgp5yGVNWpWasGmMkrfng37rxBzaAhI0vY1v2vPhhLdo4gEhOS2cjjh2sqN5yzB9gljabjjgMj3WL6i8TwMVWFfinYa98HINI/iHbBGiXVczqWkv5zzrAQdSvTakp25PqZrmA4k3baN0MHk450A76R91PXzofg2PcgRf26+XadFdmXtId1aADV6TdZCTkpGTh/w+JOp1VjLfAEbFrJE14D3IlsaXT3j19YpG+HR4ExzuhLfILx/u2Q2GFV/AhSS5OLLSSNSOP5CGth/tSnG/YbqayZTQFChpejfikGe3ejNiTUyByCoD6I1UMnRvFThFVRZRiANARJHsT/OLEQkb3iBCkRI2IGWZAoNwR1n+Ipflu4g02y88WH2SNJS9GjccUOIu1+vV3gsW+OiOFmLjSJPa2S6cQfT5vZqtBtxlySYG8dSfsKa0nBMsJ6lpUgQlUHOH/BsY4huuOIM5zUJfSTtg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/20 9:05, Shakeel Butt wrote:
> On Wed, Dec 17, 2025 at 03:27:39PM +0800, Qi Zheng wrote:
>> From: Muchun Song <songmuchun@bytedance.com>
>>
>> In the near future, a folio will no longer pin its corresponding
>> memory cgroup. To ensure safety, it will only be appropriate to
>> hold the rcu read lock or acquire a reference to the memory cgroup
>> returned by folio_memcg(), thereby preventing it from being released.
>>
>> In the current patch, the rcu read lock is employed to safeguard
>> against the release of the memory cgroup in mem_cgroup_swap_full().
>>
>> This serves as a preparatory measure for the reparenting of the
>> LRU pages.
>>
>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> ---
>>  mm/memcontrol.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 131f940c03fa0..f2c891c1f49d5 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -5267,17 +5267,21 @@ bool mem_cgroup_swap_full(struct folio *folio)
>>  	if (do_memsw_account())
>>  		return false;
>>  
>> -	memcg = folio_memcg(folio);
>> -	if (!memcg)
>> +	if (!folio_memcg_charged(folio))
>>  		return false;
>>  
>> +	rcu_read_lock();
>> +	memcg = folio_memcg(folio);
>>  	for (; !mem_cgroup_is_root(memcg); memcg = parent_mem_cgroup(memcg)) {
>>  		unsigned long usage = page_counter_read(&memcg->swap);
>>  
>>  		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
>> -		    usage * 2 >= READ_ONCE(memcg->swap.max))
>> +		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
>> +			rcu_read_unlock();
>>  			return true;
>> +		}
>>  	}
>> +	rcu_read_unlock();
>>  
>>  	return false;
>>  }
> 
> How about the following?
> 
> 
>  bool mem_cgroup_swap_full(struct folio *folio)
>  {
>  	struct mem_cgroup *memcg;
> +	bool ret = false;
>  
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  
>  	if (vm_swap_full())
>  		return true;
> -	if (do_memsw_account())
> -		return false;
>  
> -	if (!folio_memcg_charged(folio))
> -		return false;
> +	if (do_memsw_account() || !folio_memcg_charged(folio))
> +		return ret;
>  
>  	rcu_read_lock();
>  	memcg = folio_memcg(folio);
> @@ -5277,13 +5276,13 @@ bool mem_cgroup_swap_full(struct folio *folio)
>  
>  		if (usage * 2 >= READ_ONCE(memcg->swap.high) ||
>  		    usage * 2 >= READ_ONCE(memcg->swap.max)) {
> -			rcu_read_unlock();
> -			return true;
> +			ret = true;
> +			break;
>  		}
>  	}
>  	rcu_read_unlock();
>  
> -	return false;
> +	return ret;
>  }
>  
> 
> Anyways LGTM.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

More compact.

LGTM.

-- 
Best regards,
Ridong


