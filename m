Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9D4DE7AD79
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 02:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 060496B0088; Thu, 25 Dec 2025 21:12:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DE96B0089; Thu, 25 Dec 2025 21:12:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5CA96B008A; Thu, 25 Dec 2025 21:12:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D152B6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 21:12:13 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A3408C127
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:12:13 +0000 (UTC)
X-FDA: 84259997346.02.97D8B9A
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf30.hostedemail.com (Postfix) with ESMTP id 75EFE80008
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:12:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766715131; a=rsa-sha256;
	cv=none;
	b=ojgqIuKXRINEpWaqpE4onF9Z8eIfaAdlAqddRfuVe/SEke3TB+mVPtOdGxR7JGwRJgfy1A
	6m3fSA4FqmlfFLaCtW4/HvB1SOxBVzgBffc++0y3yRJPyg1a1MSXcZWmZfLrz+SX2Rn/Ux
	2CY+kCRnSDrC6+szot3DFwu6w1ylRlg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766715131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EC9PlpSlHlSGM8vUpGB7O9CFtRBGbGwH+yCe/FQZv30=;
	b=zRkkZ8w5QuPJL0Y5nnG7eri4zaCsn9azlTu1YqsXPmSU7a9gO02gkIU4mvvz0kudAMDXjD
	2dzKEtxn0QEGrbNW56vaxtt/VfyhW6RBfBLMkUcu13Xa9t3eUV/SLUOtpAGLevibRIrAHX
	CypjBkxYY6Z55BFpTBgRPrfya8dje/4=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dcpyN4nkhzKHMLL
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:11:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DB47B40590
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 10:12:02 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP4 (Coremail) with SMTP id gCh0CgA35vbx7k1p_fwCBg--.54121S2;
	Fri, 26 Dec 2025 10:12:02 +0800 (CST)
Message-ID: <8354b8b7-2d94-431b-b60a-6a744ab7ca06@huaweicloud.com>
Date: Fri, 26 Dec 2025 10:12:01 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 11/28] mm: memcontrol: prevent memory cgroup release in
 count_memcg_folio_events()
To: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com,
 mhocko@suse.com, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, david@kernel.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, mkoutny@suse.com, akpm@linux-foundation.org,
 hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <5f8032bc300b7c12e61446ba4f3d28fba5a7d9d5.1765956025.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgA35vbx7k1p_fwCBg--.54121S2
X-Coremail-Antispam: 1UD129KBjvJXoW7AFWrWw45WFW3WFyDXryftFb_yoW8AF4fpF
	sxGwn8Ar48JrW7urnxK3W7Z3yfZ3yvgrsIyFWIkw1fZFyaqw1UGay7Kw1Yq3y5ArWIkF1x
	Xa1Y9rnrWayjqa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvYb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxkF7I0En4kS
	14v26r4a6rW5MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I
	8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWr
	XwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x
	0267AKxVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v2
	6r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07
	j7l19UUUUU=
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 75EFE80008
X-Rspamd-Server: rspam03
X-Stat-Signature: kifqksxwd7ekmapcegc9yeb1piq6fwb5
X-Rspam-User: 
X-HE-Tag: 1766715128-740931
X-HE-Meta: U2FsdGVkX188/Avq0ATqi7uIadhruurNEDLPjmK5Cju6OnnAZzMEzIP4Vlw7f51fnc1vdyaC+NFhSq4783WZsxQN3ag2BECFtktVTpoB7UnetznGzTfsOLYQBMjUAem0SjclacwodvPm8s41gJdH+lc/KXLDWmikyT0alcHdG3YmPnWLSK/vi4XE3/3a2ywSzfRIA2e4WmLFLgt3QaWZ4hP+GqIcAmT/6crJOph+sF5b0T+OXQpcKiTRnznNNGsYkwnD5FYo59yaOivoDx2k5b7LgAHDyf3frYIfCXq7AW/+7kBEPdWQJC9PA7Rcy7LGlHQzb2ubAnA2O9/OfYoPJ1GCo33eHYQccw2Urgt/++pNxdA+GsOV8mT1Wr7ITEb+y6r4KQ5Bz/N78K1wbxKfTMiSaOQhtavsBEoOeHby2dZWt1g/U8LpkXlIs5mOaHMjMuqHyUXbaQ9kW5AqlLMYSue0y8MFSvDzZM+BqRwA1kxXyP0htLtPYktzKZUhuJL/fQvSD2Xxpr2kLzYA3tUt5cxIL2TNpqCTtKpTOxyx/acfdW8NRS+IfamAS6PQJ5+AItTwgEjXtcoKikZ5N15NeiYbCC0h0DC6eRYH+Fw0N57LCCqXC1tW5SprBDCO2UQAPoUj6PmpkqXtLF+kl76E4pQktYZLXtYN2XyzdwRhlSMX3iL0pkhEam6eIS2qDyc/7raojjgHYXmTQj+nguMJLMPzscfRYyMrNvgCSL5zhY8o+37KkxdMF6cffowXln6Fw/w4qumKrWktQ5df2GWuMZ5cQFcg46CaEVmzcv9nrH19/qtnew32wo6f7sQrMK+6gZ6triTfm1jwnZ/Skc8PMaQOuUGU3t7wxBKxETCzVJfEt2BXMNnaCUuKXoUrSF4tiyPEMRAKKHKvaMUAszTTfRB2UWR8CDdYNux6BpQ+V5oAGmZWuc488nivxiXAszMisXo1cSxbRFV61L+fS1h
 iDwR92Y1
 eVYkJ5gzPTo/FWvyHvzkXQmhplyc8E3P39PzKeD0gikVkKIuHrfLOvCOsL1pYsjxmskh3uIZq+s9/xUR4GrKq6dimmG81L4xd+TVL7+6K8ntMAUovjMREEHHfOKpxH4LPllgM5NG4/l705nyCri/I8alkPatDHo5cl1EFtgGP144QfABVYSXXwgQ9L9of/x9JHGnKuJ7jku8WkpX2+LbqztUPgdUqTyJB712wKrnscI3N7Zlc9bKhxjbXyUkG/iTNqDv7Eja5WGAlnE1mTmaF93GK1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/17 15:27, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in count_memcg_folio_events().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  include/linux/memcontrol.h | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index bc526e0d37e0b..69c4bcfb3c3cd 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -974,10 +974,15 @@ void count_memcg_events(struct mem_cgroup *memcg, enum vm_event_item idx,
>  static inline void count_memcg_folio_events(struct folio *folio,
>  		enum vm_event_item idx, unsigned long nr)
>  {
> -	struct mem_cgroup *memcg = folio_memcg(folio);
> +	struct mem_cgroup *memcg;
>  
> -	if (memcg)
> -		count_memcg_events(memcg, idx, nr);
> +	if (!folio_memcg_charged(folio))
> +		return;
> +
> +	rcu_read_lock();
> +	memcg = folio_memcg(folio);
> +	count_memcg_events(memcg, idx, nr);
> +	rcu_read_unlock();
>  }
>  
>  static inline void count_memcg_events_mm(struct mm_struct *mm,

Reviewed-by: Chen Ridong <chenridong@huawei.com>

-- 
Best regards,
Ridong


