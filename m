Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DC31E784BB
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 03:45:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED7456B0088; Wed, 24 Dec 2025 22:45:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E86BF6B0089; Wed, 24 Dec 2025 22:45:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A356B008A; Wed, 24 Dec 2025 22:45:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C655D6B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 22:45:29 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30D28138C7A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:45:29 +0000 (UTC)
X-FDA: 84256603578.21.608EE40
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf05.hostedemail.com (Postfix) with ESMTP id 84133100002
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 03:45:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766634327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I3LGe94tFyDw5TBs96I9+rE74L0gcXmr2AirwOtZN0w=;
	b=wIon3mcP221QfY1UftmCNXsWfS3ua0tRiGBD5Iu0Vf6aFsWSGU+aIc9IwzbtLW6SK8JZUv
	eJns/6/2ADfbVX/VLnIwqUiKCUuQaoE41/hzKk8QIv5/I72qNB9pCihJIM8zNl8QQ07ewD
	bXEehGEUP1cOM+CvJt5irjao1GXGKtA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766634327; a=rsa-sha256;
	cv=none;
	b=vl/EvWAGwJH1Pzq6Fg1uAUYjTk+TmbxXh22vfL+y/jcLL8k2f2X/CL+BY4Rj+r/VUCsnFN
	mO4yXZGjESktxpCYytvSyHN/WMbMVOYl+X1Zfrh1OJlugA9ZVr5ge4Iz/1NjpyxtpDfwGp
	1k+VJtfIpAvjR1LCV9sePuSYIrqS3qk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcF4T6GRhzKHM00
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 11:44:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A379E4057D
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 11:45:18 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgBXBvdNs0xpIrWSBQ--.52398S2;
	Thu, 25 Dec 2025 11:45:18 +0800 (CST)
Message-ID: <9c0be55d-0b02-4f39-a871-3ce495e32a87@huaweicloud.com>
Date: Thu, 25 Dec 2025 11:45:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 04/28] mm: vmscan: prepare for the refactoring the
 move_folios_to_lru()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <4a7ca63e3d872b7e4d117cf4e2696486772facb6.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgBXBvdNs0xpIrWSBQ--.52398S2
X-Coremail-Antispam: 1UD129KBjvJXoWxGw45tF43Ar47GFy5ur43GFg_yoW5CFWfpa
	nrWryakr4rJw4agrZrWw4DW343Ga4DKFW3trW7uF4ft3WfWr13K3WYkr1YgrW3J348Zr13
	ZwnIgrn7Zay0qaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: r9eky7z4cxp13ttgitmidr3qopawq47q
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 84133100002
X-Rspam-User: 
X-HE-Tag: 1766634323-685978
X-HE-Meta: U2FsdGVkX19YNT5yk3ZqHdIJaSYh0fPdLPV7hgHBYV9ZHKyNev8AqS00ePTX+uOkroF1JiUFKyW1wupO2/2joJ7gqJjLwSXwjdOvfN6KPKKaf1Tqf+6Ea9fHOFYnpEzWKRLbY2o4g6rkt+il8jbb9dA6n1UbH38Rp+kCL6GziRjofmI5EaVaXoEblagX7uku/2bVSkd1TpkB9ZUjAJ7tK+zV/S2ga8kGc9s45n+TjiJiGoT4cOajE8EvH1FHms6JDetw50WlbCDv5lBhSjW8g25RcstnZDNE98cxgU+1crzonb7w3ZZUgxPYV2XSJByFmsXm1y7YgM5vIZSGdO7Jz6IkozR0r94xqPTlSlD7JDfHPMwuqJN0KosGyGBmytYgFqM2DL7I+TrC7emg1wnhi/LA4txUIHPjWxl0awoz5oBramcH0sGusWjGpWGnUshPK7mUOKbSBAIahEPT5X+UMPRj7VDq2X2hRM8rJlQYSXMf04iUTuznkG2ItoARzbmu0rZtacBTUMN1sb5eglhHK9qWPyFmzTvRkgkEdzBLASZnxCCmiL76PFK2MwsMqJhtppYmOB2ZyDa2WwrWkhKN3fykegtA7ccZowLsUTfLTB6KhZMzp+9+zmO6TMaUlWSkgIksEggLs1JxHCRax/78gr7/um06BAnSwPbSqfX59MVLFcwDgGApuIHLRqqIvDQA7ZB1vmNPl6OkAz+82HLGsNfLCPVSpKO+s2yPQieWwcaVIlQf4glhLR68O7yXaHxoZIbf+e1JcshitY9RHstc/yUaKFlEljyAzp+P4tedEq/QVB/RWd8A6rUnC+PLDCTv4MaDhNle2nVo++ZsXMRwkbqNZfhNU7et+WIJo4a+sxgs9sO2OvDfppsqCSnnPy+8hU3c2O2XTVFNKVZb8KUW6oNUjJgQDiEliJ7vjBjIBh16F3ekAMegMKxhq12xaBa7W7tKPOfzxqZzkfVav8h
 AY2r75mo
 gtndWoctCzpr+Shaxlhr9KwkRVDXpzXuvQIdFArC/3hq2izKtQsCCgi0jON9JZ4vTBGLzKvJRzalZAB4Zgj+i9xi8ln8djgVt6wTDSEVAUaMvrWGH8LmI/VyWFSv0xtu852ebfy8aiKyJRpU7w4bzO6EUlCwT57kaEa+lMPbxIBDg+5EP5eg/DREtwYwTfxU1RIQKcovggSQg5/N89WM3RG4rNw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 15:27, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> After refactoring the move_folios_to_lru(), its caller no longer needs to
> hold the lruvec lock, the disabling IRQ is only for __count_vm_events()
> and __mod_node_page_state().
> 

nit:
For shrink_inactive_list(), shrink_active_list() and evict_folios(), IRQ disabling is only needed
for __count_vm_events() and __mod_node_page_state().

I think it can be clearer.

> On the PREEMPT_RT kernel, the local_irq_disable() cannot be used. To
> avoid using local_irq_disable() and reduce the critical section of
> disabling IRQ, make all callers of move_folios_to_lru() use IRQ-safed
> count_vm_events() and mod_node_page_state().
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/vmscan.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 28d9b3af47130..49e5661746213 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2021,12 +2021,12 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
>  
>  	mod_lruvec_state(lruvec, PGDEMOTE_KSWAPD + reclaimer_offset(sc),
>  					stat.nr_demoted);
> -	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
> +	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>  	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
>  	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, nr_reclaimed);
> +		count_vm_events(item, nr_reclaimed);
>  	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
> -	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
> +	count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
>  
>  	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
>  					nr_scanned - nr_reclaimed);
> @@ -2171,10 +2171,10 @@ static void shrink_active_list(unsigned long nr_to_scan,
>  	nr_activate = move_folios_to_lru(lruvec, &l_active);
>  	nr_deactivate = move_folios_to_lru(lruvec, &l_inactive);
>  
> -	__count_vm_events(PGDEACTIVATE, nr_deactivate);
> +	count_vm_events(PGDEACTIVATE, nr_deactivate);
>  	count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_deactivate);
>  
> -	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
> +	mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
>  
>  	lru_note_cost_unlock_irq(lruvec, file, 0, nr_rotated);
>  	trace_mm_vmscan_lru_shrink_active(pgdat->node_id, nr_taken, nr_activate,
> @@ -4751,9 +4751,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>  
>  	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
>  	if (!cgroup_reclaim(sc))
> -		__count_vm_events(item, reclaimed);
> +		count_vm_events(item, reclaimed);
>  	count_memcg_events(memcg, item, reclaimed);
> -	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
> +	count_vm_events(PGSTEAL_ANON + type, reclaimed);
>  
>  	spin_unlock_irq(&lruvec->lru_lock);
>  

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


