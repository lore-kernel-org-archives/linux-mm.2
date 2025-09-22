Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04E0ACAC5A7
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:48:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E9368E0002; Sun, 21 Sep 2025 23:48:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C0478E0001; Sun, 21 Sep 2025 23:48:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FD7C8E0002; Sun, 21 Sep 2025 23:48:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2C3948E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:48:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E15BB9A9A
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:48:41 +0000 (UTC)
X-FDA: 83915504442.17.21D62BD
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37507100005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:48:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of zhengxinyu6@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=zhengxinyu6@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758512919; a=rsa-sha256;
	cv=none;
	b=roOhBfNf3qoOGvi5n8CbB3y7+ms4n1avGIzj9BhoO+WLu+LtooZSfakC4wYT0DC04XL9e+
	oyeDw6SfQKOyQaOhWB81VEWbQRAwxtMUNM0zYQQMYMTGNVyFZWBN6eaFXYmwHNDLPUp3+L
	rOlRY3yonxGFmq9u8a7XaIPknqaXCzo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of zhengxinyu6@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=zhengxinyu6@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758512919;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OGh1a6NvuF+v0HjEcEfaH5Bs3yxOtrRUC1Uy6ai8wZw=;
	b=wfqggPG+dq8sZDmZDNyBrQ6cCziAl+Mu8ehXnJ5446MRkrik/IcKjsXuXThGpeio0yr9ww
	kLOuLzXH6Dw+krvYDSepoH/LYoAfgtNyv2mVTGeac+hlRFKUj3xjaKEZCCylphJ/nez55e
	1Y+P2nK3+lsp/wT8A2xHtmm5MelW48Y=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cVTbf65n2z14MTN;
	Mon, 22 Sep 2025 11:48:14 +0800 (CST)
Received: from dggpemr200006.china.huawei.com (unknown [7.185.36.167])
	by mail.maildlp.com (Postfix) with ESMTPS id 6C6D1180486;
	Mon, 22 Sep 2025 11:48:33 +0800 (CST)
Received: from [10.67.110.83] (10.67.110.83) by dggpemr200006.china.huawei.com
 (7.185.36.167) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 22 Sep
 2025 11:48:32 +0800
Message-ID: <d7f78b73-6bb4-4ccd-b604-5bfa6473fd2a@huawei.com>
Date: Mon, 22 Sep 2025 11:48:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [BUG REPORT] mm/damon: softlockup when kdamond walk page with cpu
 hotplug
To: SeongJae Park <sj@kernel.org>, Hugh Dickins <hughd@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney"
	<paulmck@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	<damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <zouyipeng@huawei.com>
References: <20250920104220.1399-1-sj@kernel.org>
Content-Language: en-US
From: Xinyu Zheng <zhengxinyu6@huawei.com>
In-Reply-To: <20250920104220.1399-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemr200006.china.huawei.com (7.185.36.167)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 37507100005
X-Stat-Signature: akdh4pdc8irzde6iy71ijqcn66e7ewu9
X-Rspam-User: 
X-HE-Tag: 1758512917-132168
X-HE-Meta: U2FsdGVkX1/4I3YHzH8cdzxUfXMvFEzQdkBQv9uIImqC5aYGYOEzrcyWtAKBEmd6xHiFCTZi1GKMk3FbeTHT0tm5cZ4CkJyFxK5XGg+LWcYQdacJQIcocRHuz5ATgvH+Fg81tixrKVBl4bXAT3fnG34nVP6G980VL06ONqvIj1VvJ/MmCzVTDqc009Mj1q3HiCMLphOFVtgCnMAEM9PLdPYaqECFMIRGt7wgVV5vcDwlBBNdjhnJxI4AxC2Spt9vRztc1NMpoZYWRQ/cfH56Sp0hiVoBYow7ZP7IZb46IaCgUrEaG/KPlGr4wMVKX1aUCVBXyhG0lPTAyf9Wh4n1clKyC7+ODDPGFLVp6icjcY53mYaFMHuJTg7rPFcMB1YvwiLomgfecCwvLa6HimqgagfANTyrHKShn6A/0Ou9uUUwxcLOQ+lXWPpKAQS1yKH7B+pNP4EmcL1ldhBvOO6UJnMu3wLZ5YIKI3O14KSh8BBA8Y9em9G0Fe9x5WD+lewPtthO0kzhIGm81GMF99Rg11EfLnSunk923vM2YeH+LnEiRe5Uc57tGAbMPsBS+zpHVOAzrrkG7aDkxUNlc/YmJEoGJ/HAnccTGe/sw5blg6itRu3eW+iotcxgVYlvbkMd3oupLH6Y6r22SZ3C+XLqnHaxrgnj7J9mqGp33qpLtIV4dsOdlIgVPH7EelWgzh3VXGSvrYWGJ4rfC1QbeKERwnmR7fOQ2VsoDmBj0NteJ+eLIyV5M8LHHMvSLLASulKUpGfWQ2J9/shqsIfruHzdepLZd7Zhpx8E5DDWIrMfcattgp0eOdViL4cm0RntZTUcp3jJ/6Uq75yh82f9jvqGnKbU2AtpVWKpXBDx4MMo8hNsq4iEYgsVlh+HB6D3X3n2hQS7QOafPOv/r8rrXC23gYA9Ykq/hb9GSeCF+Ay2tySR+HepWetCBssTgMuZvBgdDkp1IdBfZcz9XB+PyLQ
 b+V4yjJ1
 GWvjUVgUmmRJ2RjaWbSCZhMzJIUwZDOok67TvnPIvcKlj756PQgZwzuzpuyCuZK/djblGylHUqmniL5Tn26Uw1gbKDfAXLBEjMr5mr8nQVz1PHd9c4DVZKvS07Eqqxk5fCt/E43twzEzmvMdFQwuVQVgzsUQNI+2VoliUi2BHA8tu+0OH/ncLM+dP/Avv5eU201Q+Ssb+El87+cgTQun4hWFk9VQBt8tr6rUboktXFddVuRGc5YJPKQV7ADBNmoqltp6cVG5WEH9LlZDdwpS7xA3e0rrb8b1Ptm3+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/20/2025 6:42 PM, SeongJae Park wrote:
> On Fri, 19 Sep 2025 20:56:56 -0700 (PDT) Hugh Dickins <hughd@google.com> wrote:
> 
>> On Thu, 18 Sep 2025, SeongJae Park wrote:
>>
>>> Hello,
>>>
>>> On Thu, 18 Sep 2025 03:00:29 +0000 Xinyu Zheng <zhengxinyu6@huawei.com> wrote:
>>>
>>>> A softlockup issue was found with stress test:
> [...]
>> This had me worried for a while: thought we might be needing to change
>> lots of other places, and scatter cond_resched()s here and there.
>>
>> But no: no need for cond_resched()'s, this is all just a confusion about
>> where pmd migration entries are handled: a pmd migration entry is accepted
>> by pmd_trans_huge_lock(), but is not accepted by pmd_trans_huge().
>>
>> See fs/proc/task_mmu.c for mm_walk examples of trying pmd_trans_huge_lock(),
>> then pte_offset_map_lock() if it failed, or ACTION_AGAIN if that failed too.
>>
>> When I ACTION_AGAINed damon_mkold_pmd_entry() and damon_young_pmd_entry()
>> in 6.5, I didn't realize that the pmd migration entries were reaching the
>> pte_offset_map_lock(), with corrupt results (or did pmd_bad() filter them
>> out? I didn't think so, but it'll take me too long now to work out whether
>> a pmd migration entry counts as pmd_bad or not); but knew that the new
>> pte_offset_map_lock() filtered them out safely if there was a race.
>>
>> But they've been reaching it without any race, so yes the ACTION_AGAIN
>> would send the mm_walk back again and again for as long as the pmd
>> migration entry remained there: not good, and Xinyu finds a lockup
>> when hotplugging CPU without preemption.
> 
> Thank you for your detailed and kind explanation, Hugh!
> 
>>
>> My suggested patch below (please take it over SJ, and do with it what
>> you will), converting damon_mkold_pmd_entry() and damon_young_pmd_entry()
>> to use pmd_trans_huge_lock() as I'd been expecting, so handling the
>> pmd migration entry up in that block.  (Side note: patch against 6.17-rc,
>> but I see mm.git adds also a damos_va_stat_pmd_entry(), which would
>> better be converted to the same pmd_trans_huge_lock() pattern -
>> though I notice you're not setting ACTION_AGAIN in that one.)
>>
>> But I have to admit, there's very little gained by using ACTION_AGAIN
>> in these functions: it helps not to miss the range when racing against
>> THP collapse or split, but you're already content to miss the extent
>> if it has a pmd migration entry, and there can still be an instant when
>> the range which used to have a page table does not yet show the THP.
>>
>> So if you prefer a smaller fix (but a larger source file!), just
>> dropping the walk->action = ACTION_AGAIN lines should be good enough.

Hi, Hugh. Thank you for your patient explanation and solution!

> 
> I agree all your points.
> 
> I'd prefer the smaller source file following your suggested change below (using
> pmd_trans_huge_lock()) in long term.  But, for a short term, I'd prefer the
> smaller fix (dropping walk->action = ACTION_AGAIN) since it should also be
> merged into stable@, up to 6.5.y.
> 
> So, I'd like to suggest as following.  Let's drop the
> 'walk->action = ACTION_AGAIN' like the below attached one, for now.  After it
> is confirmed to fix the issue and merged into relevant trees including stable
> trees, let's revisit the code to cleanup following pmd_trans_huge_lock()
> pattern.
> 
> Please let me know if I'm missing something, or you have other opinions.
> 
> Xinyu, could you please test if the below attached patch fixes your issue and
> let us know the result?

Thanks for all the reply and suggestion, SJ! I am trying to reproduce 
the scenario now and will send the result back very soon!

> 
> If Xinyu confirms the validity of the fix and no one objects to the above plan,
> I will post the fix as a formal one with a better commit message.
> 
> 
> Thanks,
> SJ
> 

> [...]
> 
> ==== >8 ====
>  From 743cafda8982624229541741dbfe5ff252328ac0 Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Sat, 20 Sep 2025 03:35:34 -0700
> Subject: [PATCH] mm/damon/vaddr: do not try page table walk again
> 
> For a quick fix of a softlockup issue:
> https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  From 743cafda8982624229541741dbfe5ff252328ac0 Mon Sep 17 00:00:00 2001
> From: SeongJae Park <sj@kernel.org>
> Date: Sat, 20 Sep 2025 03:35:34 -0700
> Subject: [PATCH] mm/damon/vaddr: do not try page table walk again
> 
> For a quick fix of a softlockup issue:
> https://lore.kernel.org/20250918030029.2652607-1-zhengxinyu6@huawei.com
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>   mm/damon/vaddr.c | 8 ++------
>   1 file changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index 8c048f9b129e..7e834467b2d8 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -328,10 +328,8 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
>   	}
>   
>   	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> -	if (!pte) {
> -		walk->action = ACTION_AGAIN;
> +	if (!pte)
>   		return 0;
> -	}
>   	if (!pte_present(ptep_get(pte)))
>   		goto out;
>   	damon_ptep_mkold(pte, walk->vma, addr);
> @@ -481,10 +479,8 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
>   #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
>   
>   	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
> -	if (!pte) {
> -		walk->action = ACTION_AGAIN;
> +	if (!pte)
>   		return 0;
> -	}
>   	ptent = ptep_get(pte);
>   	if (!pte_present(ptent))
>   		goto out;

-- 
Xinyu Zheng


