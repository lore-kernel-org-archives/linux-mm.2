Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51DA8CF8564
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 09:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB8676B0032; Thu, 20 Nov 2025 04:08:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A91A76B007B; Thu, 20 Nov 2025 04:08:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE5F6B0088; Thu, 20 Nov 2025 04:08:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4098E6B0032
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 04:08:01 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E90B31607C5
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:08:00 +0000 (UTC)
X-FDA: 84130408320.06.BCA1F96
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf19.hostedemail.com (Postfix) with ESMTP id 819771A0004
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 09:07:54 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763629679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ac3uWtfTAyePA5mNNGNdOPxK0TMligvWp0ovus97q/4=;
	b=oL0J5sqfAMSTFYJ5PU07RuTvm8AhrlRoZrhgtYmZ0zvsXj1GEbtv+5l/PoSWPB8TVffYRL
	zPsP94mCREyCIb9pS2eNylPKQ8Ubr5sXSciAT7YvAmFJpPb0dZzu2N4MNTplcsPdiBN7nF
	uI05eESDY+WVvAGFH8rzfaJTO6lDk0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763629679; a=rsa-sha256;
	cv=none;
	b=LyuvviKpvW7ivN4L0mhxycGdK98OyDWy+fyh5wcT1qZlDDJVniYte4+aMzomIxaXk1RiWp
	yy12YiBYITYcpy8OvBsQs0jok8V2Ti3Z06zQnf2jsIugYNZS0VV6J3au5npViTXgCKpmJn
	sOW1567smRit4etSlagm8E+xKPgWIy0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dBstM6Sf3zYQv5C
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:07:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 7CB991A14F9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:07:49 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgC3YXhk2h5pdWOOBQ--.29493S2;
	Thu, 20 Nov 2025 17:07:49 +0800 (CST)
Message-ID: <0d78a4cf-0973-4874-ab6a-978621a17068@huaweicloud.com>
Date: Thu, 20 Nov 2025 17:07:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 01/26] mm: memcontrol: remove dead code of checking
 parent memory cgroup
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <b13ff669bc3f52922e97fa0cc99e54df05585810.1761658310.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <b13ff669bc3f52922e97fa0cc99e54df05585810.1761658310.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgC3YXhk2h5pdWOOBQ--.29493S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4kAw1xtF1kAw15tw4xWFg_yoW8trW5pF
	sxKa4UJay5Ar4UZF1aka1DZa4Sya1fta15Crn7J3WxXrnaqw1jqry7Kw1xCrZ8CFyfXrWY
	qF4qv3W8Kr45AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUv0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
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
	Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU0
	s2-5UUUUU==
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Stat-Signature: aci61wz3ishw79wedpnuybetetfuwqfc
X-Rspam-User: 
X-Rspamd-Queue-Id: 819771A0004
X-Rspamd-Server: rspam01
X-HE-Tag: 1763629674-312365
X-HE-Meta: U2FsdGVkX1/qa174b/Z8kgL6U0cTpdd2t+zllZLyRuBK7jV4T5brScg49HP/LR1qUb4yJ8HFjYKp5Nf4/PhLvYTuwsDQeMX0xWTdmY8fqrMDhkDKJ6Wjc9wz/K8vDJ9P0j08+Ug3McEV8Cv+WpWnbDYgkEvSssxnPYExfHNFXVPGNc+h9IKGDpExYhvNb5MJS7phrdKxe29Ia2eX6GTiGd6VMMPhyuU5ZzQIonXjOm9btzv4MYFDyyLAOjhCIFaAb1HGQL6YYg2TzV3Jnb0M8LXOtgjuQQnTV5O51iz5CQhSlTdLxhQ1wd8OhcKADybHGDHhVAdCjHJyeY2XWkMTier5QAHIy0p2MgT4trfBsLcH91sRdMRKDloCstlvqSnf7lfPp09gb6lERHywB5lT688gT5krGtmbGdIXKO5TqH4t+bNDkGEydHZ9oMzZWX7MqdZthFVQA2u7uG7q7sRjH7CloKQk1N319iq2u7+LJHmEeA0wkEJEBTwMgCPBEH9/rtCYs+4MnIlj6fkPpIT2G9yv4W12PjNEKqkfcGq1x25cBd2uNNYeOOSKE7Un+s2Psl5s8XxxMCmx2Ca2h+y8mnAwz6EX5XTabOI6a7Nv9hjwN7IWTvfxQiM3KCR0YtP89BtFyNYgGtIYiG8fKCt0ELCiG1tTV95TeW4FjqK0jCzWD4V/8l54yuG9NLssb7HQSRelKg3dEylKb0NUMD8gI/MEywmIN42cQBzfmADVjyu02TmyZyAcajT3sy0roUjfvarxlQztSo9YfflQNgCxHqnSt1VdtoVGQoBXoLBGK0Y4OaQ1HiBEF6x+LAjMo9CfECtpo18vxaXtJh8PhVzKfxDsvedKglYn1c/IEhKFGzV48Zekg3uoOJXvddyRIxDjRtcZC3v2Juh3+zBWKW40iW/PnalowHMFtJDt+5HcJZMShRljyH5cNm10FGEiWbGT88STm7Y3+qEA6XFHod1
 d7hnfMNz
 tsuzs9tLc3IBgNSlqKAQ9hwiO9/TpkfIPqrFo/4zJrdlx2kTkfLx4078HQ4j0Ve/SSZZ1q22QEyzzFXVlLrrMt8EEclGEzrmofdzIkcvFbe3cfneJyNqyd3vwIGJE9PLeiBia2f3U9r26kpiQiVOLj0leqNCOKTY4/Fek/W4Zs0xtHjSGwa/66QVRdylPb9fMhMug
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/28 21:58, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Since the no-hierarchy mode has been deprecated after the commit:
> 
>   commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical mode").
> 
> As a result, parent_mem_cgroup() will not return NULL except when passing
> the root memcg, and the root memcg cannot be offline. Hence, it's safe to
> remove the check on the returned value of parent_mem_cgroup(). Remove the
> corresponding dead code.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>  mm/memcontrol.c | 5 -----
>  mm/shrinker.c   | 6 +-----
>  2 files changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 93f7c76f0ce96..d5257465c9d75 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3339,9 +3339,6 @@ static void memcg_offline_kmem(struct mem_cgroup *memcg)
>  		return;
>  
>  	parent = parent_mem_cgroup(memcg);
> -	if (!parent)
> -		parent = root_mem_cgroup;
> -
>  	memcg_reparent_list_lrus(memcg, parent);
>  
>  	/*
> @@ -3632,8 +3629,6 @@ struct mem_cgroup *mem_cgroup_id_get_online(struct mem_cgroup *memcg)
>  			break;
>  		}
>  		memcg = parent_mem_cgroup(memcg);
> -		if (!memcg)
> -			memcg = root_mem_cgroup;
>  	}
>  	return memcg;
>  }
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 4a93fd433689a..e8e092a2f7f41 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -286,14 +286,10 @@ void reparent_shrinker_deferred(struct mem_cgroup *memcg)
>  {
>  	int nid, index, offset;
>  	long nr;
> -	struct mem_cgroup *parent;
> +	struct mem_cgroup *parent = parent_mem_cgroup(memcg);
>  	struct shrinker_info *child_info, *parent_info;
>  	struct shrinker_info_unit *child_unit, *parent_unit;
>  
> -	parent = parent_mem_cgroup(memcg);
> -	if (!parent)
> -		parent = root_mem_cgroup;
> -
>  	/* Prevent from concurrent shrinker_info expand */
>  	mutex_lock(&shrinker_mutex);
>  	for_each_node(nid) {

LGTM.

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


