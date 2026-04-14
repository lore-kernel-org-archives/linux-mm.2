Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45950F531FA
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B6FF6B0088; Tue, 14 Apr 2026 03:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 667D86B008A; Tue, 14 Apr 2026 03:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57DF06B0092; Tue, 14 Apr 2026 03:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 460526B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:43:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD96F1604CC
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:43:35 +0000 (UTC)
X-FDA: 84656371590.27.C894059
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1BE0A140008
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:43:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776152614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uOxZcwlIxYVbz2yr6yP4drg3m3MVgW1yk8a1J4hfOtI=;
	b=0R+Ge+EtuLvBV0gvJRlEvDqtN9FwU8OBeMqcHT4Svw7gH8m4Di36SclSTKhJ6XPBo86a9D
	bZBzRP5EQ02B/LR71pqBDVKliFHYh7SnecacGBdzMoZxvbSmQD3ACiplSrLiZkGuHwB7Wm
	WVNYNQAgJEAMk+8e2W7WByLUBRMi1LU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776152614; a=rsa-sha256;
	cv=none;
	b=oVyyHe67kM9LEiMyust7E3mA9D2nSJ33HkGApjWsBCCHRYmMdsSkJHQ8NXuaTGnjliKhLr
	Tw2Lb8PT8VkaIZEKpMwETB4hE+vRey12z3xDDGCJQj8f/qukziOpocS9w0ChHf/q42P+Ce
	pP9DiVnhK0gDmtmNSQcwE76XWSBc9xw=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4fvx8j5tSYzKHLvh
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:43:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 97F8E4058C
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 15:43:25 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP2 (Coremail) with SMTP id Syh0CgCnim8c8N1pDrluAQ--.1789S2;
	Tue, 14 Apr 2026 15:43:25 +0800 (CST)
Message-ID: <fa857b2e-1471-44a4-9784-3f051f41715d@huaweicloud.com>
Date: Tue, 14 Apr 2026 15:43:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 08/14] mm/mglru: remove redundant swap constrained
 check upon isolation
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Barry Song <baohua@kernel.org>, David Stevens <stevensd@google.com>,
 Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>,
 Yu Zhao <yuzhao@google.com>, Zicheng Wang <wangzicheng@honor.com>,
 Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan
 <surenb@google.com>, Chris Li <chrisl@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org,
 Qi Zheng <qi.zheng@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com>
 <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260413-mglru-reclaim-v5-8-8eaeacbddc44@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:Syh0CgCnim8c8N1pDrluAQ--.1789S2
X-Coremail-Antispam: 1UD129KBjvJXoW7uw4kJF13JryrCrWfXFWfAFb_yoW8Cw15pF
	Z3Ga1DGFWrJF1UWw17AFy8uw1Fv3y5Ka1UAFW7Jw1xJF13Wrs5KFW3tw1rJFWDJ3s8Za1I
	vF12gFyxW3W5JFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1BE0A140008
X-Stat-Signature: m3ac4z75ifwztmg7ebhek33spbpy1z7w
X-Rspam-User: 
X-HE-Tag: 1776152611-171131
X-HE-Meta: U2FsdGVkX1/7FfQ4fRU4qDiGXMjn2+Bb1by62NDosCPONWFjDl4mfe6vqZM8pRAyehAzu7R0NDMH9gsrQgzMCRmR6w0g0DgDwbHOHBtYI6uCYywOe8FFjQKot3uZwK/Fnfq91di9urm1fCVN5+Oj1BgnwaORHlAUmsx/Rjozbtyokmjz8adkwl78u/W+1mzkIBHThOciiq+1nV4E2dFDShOzxjhLtMsy1fRB0qOmd2ChQ3VMt85UhiWl/C30FzmiT/qEGYmAZlJPZci+Yoso7NT2NVgA323A9ZsgHemKgGDmp/CV874Q+DjZlen4vkZKEGwRCsY3mEVIBXYZujSZVoXUT3rJkGv96l3dVQyzJxL6RT2xZ9LL9knMs82o32Goawm6zYxecc4kADgXnwxnx0b7dxLsPB5OZX426Cmbhs7Y3Ws8Sx265MGQIgeTmGsxut+7M5LVKYhkZwABEEjZ9QXgWduX4G2cqodH9WFdIO4RAbMkRCaOJKIzC5gDEcNt2PoxvXneWQxd84lDEFUTECqRNhaOr1WhVIvm8AQmeDvuQsJtQ0OF1CbE2jd6LOXAgsyREsVSHNdtXlrEosgBTt34gUJ5CkgjazM6dxLryKNmJqsYjkZr5DiW+cq0NRBkSbSdZRjIc1DP7cK6SfvI6Or7rabZNFJ2EWPeUx2kbncS1MEWqwTmL4kVrQjE2uFs7ugNQzITjGRfZ7qiynXbX5CX7RGIaYPvzj7ciaQaV3KFA24GINV3Rr8MFS0DcXzwURyCv+vuR67ijVuBiSMiBfxoP2RW1Yvb+BVz/9YV84coVwlYTF1iQAwkglkKiz+LmqFGjwuBdprD2VGtIbh3cQXBa9mYzx+jyjYNJ/a6PIk4B1YKL5CNQtN1C4ynQiO1GgHYLGVNSDsh2WRirDyoHuY6XRBL60ocjNfsbz10/lD4nwXNFudCf7BCeUgUS9igpafVUjLk+MkNHNaPn+R
 IqqO6vsh
 jurPjABmauglVH/SHeefUzgUuRC+Q5A3yumgb6lgp13EiQT9InSgW4Ujzy15TRFp7OnQwYHUPEBtnctTD8X3qB4PXOS7hvY0CsiNV1bA0CbWqj1LYz5TaDQAOqrsr7PwePEIpZS6G+klFFJ/wUZCnZaEmO8ieG5xfXe96U75Z5E6gt5IbXfi0ctbf9f79R/tgQESZGxMAU7uxa5xQukKVrB+rxVVfFd7sz5QV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/13 0:48, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Remove the swap-constrained early reject check upon isolation. This
> check is a micro optimization when swap IO is not allowed, so folios are
> rejected early. But it is redundant and overly broad since
> shrink_folio_list() already handles all these cases with proper
> granularity.
> 
> Notably, this check wrongly rejected lazyfree folios, and it doesn't
> cover all rejection cases. shrink_folio_list() uses may_enter_fs(),
> which distinguishes non-SWP_FS_OPS devices from filesystem-backed swap
> and does all the checks after folio is locked, so flags like swap cache
> are stable.
> 
> This check also covers dirty file folios, which are not a problem now
> since sort_folio() already bumps dirty file folios to the next
> generation, but causes trouble for unifying dirty folio writeback
> handling.
> 
> And there should be no performance impact from removing it. We may have
> lost a micro optimization, but unblocked lazyfree reclaim for NOIO
> contexts, which is not a common case in the first place.
> 
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 5ae6bd967b17..965d8905a4fe 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4650,12 +4650,6 @@ static bool isolate_folio(struct lruvec *lruvec, struct folio *folio, struct sca
>  {
>  	bool success;
>  
> -	/* swap constrained */
> -	if (!(sc->gfp_mask & __GFP_IO) &&
> -	    (folio_test_dirty(folio) ||
> -	     (folio_test_anon(folio) && !folio_test_swapcache(folio))))
> -		return false;
> -
>  	/* raced with release_pages() */
>  	if (!folio_try_get(folio))
>  		return false;
> 

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


