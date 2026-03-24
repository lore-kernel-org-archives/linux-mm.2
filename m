Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C03F532E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 07:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8EF16B0005; Tue, 24 Mar 2026 03:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F476B0088; Tue, 24 Mar 2026 03:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 954E66B0089; Tue, 24 Mar 2026 03:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 854F66B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 03:51:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DEDE490D34
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:51:46 +0000 (UTC)
X-FDA: 84580187412.01.E7E1A0D
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2FA54A0006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:51:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774338705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VWxxJmyJEuSSbZY7EoFOwePoPWe13rX6uB3k0SYWwFs=;
	b=RNQ3/3ETc38UvZktXcIaNwgbmruY0djtuzB8D2BU0WEakQr+SbDsKp4VrIjc7+mc7UVYsN
	Q/OxCd6TgJPN1lhvsOQZne7kxI7zNgq1V1O0wA63mqTfpVBP48E1g7AgAH74Hvi6Be+ev1
	O6RCuKJWCRL3PqiHOH2y8Z0snG/pk64=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of chenridong@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=chenridong@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774338705; a=rsa-sha256;
	cv=none;
	b=eWxYBIhyoHps2LqxDvJ4XP8iVZURLLpw9MXB/XkwyTppH6ww/YZRnVaeeesi3hLX5HilST
	ckLe1+pIlUTzkSD1u5uu4DEUJonQvEzKSut8A7s5ylpBaAw/nslBZI3YurhdEumtwOlByt
	gx/4gBNQNuB+4AS3KuF4osQYfOOAbiw=
Received: from mail.maildlp.com (unknown [172.19.163.177])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fg2Km15lDzYQtyD
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:51:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 775DF4058D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 15:51:32 +0800 (CST)
Received: from [10.67.111.176] (unknown [10.67.111.176])
	by APP3 (Coremail) with SMTP id _Ch0CgD31VKCQsJpokAaCA--.50448S2;
	Tue, 24 Mar 2026 15:51:32 +0800 (CST)
Message-ID: <a17d5daa-8f2a-4c64-81a1-5121c81daac4@huaweicloud.com>
Date: Tue, 24 Mar 2026 15:51:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/8] mm/mglru: use a smaller batch for reclaim
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
 Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org
References: <20260318-mglru-reclaim-v1-0-2c46f9eb0508@tencent.com>
 <20260318-mglru-reclaim-v1-5-2c46f9eb0508@tencent.com>
Content-Language: en-US
From: Chen Ridong <chenridong@huaweicloud.com>
In-Reply-To: <20260318-mglru-reclaim-v1-5-2c46f9eb0508@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:_Ch0CgD31VKCQsJpokAaCA--.50448S2
X-Coremail-Antispam: 1UD129KBjvdXoWruF18Zw13Jw1UCFyxXry5Arb_yoWDWwc_ua
	y09r1xZrW5JFyvya4rCrWftrnag34kZrWUur17tr4xZFyUZFWkWrn7t345XryUJ3y7JFWD
	A3Zxurs5Ar45ujkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbxxYFVCjjxCrM7AC8VAFwI0_Xr0_Wr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUIa
	0PDUUUU
X-CM-SenderInfo: hfkh02xlgr0w46kxt4xhlfz01xgou0bp/
X-Rspamd-Queue-Id: 2FA54A0006
X-Stat-Signature: gpenfew77989frxensn9sjrxj3yxjfhx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774338698-873099
X-HE-Meta: U2FsdGVkX1/ivqirXPylEDdVPOIvHbv2KwUf/cy+4XhNo48I8Ezx1E1KQcpFs08jJhK5lyPhQ6oJgZE1Hmg5M+XI2+4JKYZDZSEtLLF1iisVgWORjxQapcJJLsSNnAbbMObYy/cyzIO2YKCfueyqr575oJGX1Q/XqoS21VujSMWvpF84SPdXTaupFsODrcXcUEzKYF7nepNitTxFBKkbDhrWxTXGGrybwQ7WA8XU/Z72FlYnsGbldAKGBnBd4hOyZup8V3KJsIZwwAb7OMF/NH1kqXplbMXNUFpSij7kOmVKQoL+PZRhQqTB8kgNyArPS+R4zkQJtN+NfQvDPpRYfxrURfO+Kwze0zWZ+tMJkgrx9aU0qX36unDqGlF/1yHXykEjVOEv4NAWMhSHQEjdCfWV03V562+oyEeLFA2i3cOKWTkitGDreBDEt0F/mmdQ/8p2w+OH2a8wA6MxzTIWnbF5sEAmy/yLkbxKdb3V/jf16p/hlW021PjmhiyZMeLlNGqrwpBr4QDEAbOVLfRYA9I9zooDfLUhhCrWgJXU3LBWuDvsST+IQ8NLIOAZJIrs8+/AZWsGzstTeGTUSiEmiMF9MUsE8KDJNCPpEISuRZh5R/GtDNX2NAdohxktTzdW32WjK74fFrkB36Ty1UICs918yIoHcVrk43c5CtK7jMRsG55htJ3uKpzI03+HpMed9aOT9l95O5h+8WzHZJbuf4DZH5xGo7/ftcMeWlsiG/pWiU6QvMh7govuqAs55UbwYw06c8hHky4ektqnMBAP7ik7Wiqkld85VWseM6Ht4iD2wf16XbRaRN0rtMw7D8FoP+gcfjy8UbYaURadqzALd7TbNCzcjPjuvY3dMUVq1m7STdHQERHDsIZt1/ByPXSdq5P8KqPgyY/536phbyUyz5924ypKvztYgmg0qS5AVn/VlTWEqpvZhLbwb6gTBq38Ntvz+03+hSxfDbCTJcN
 cT359Uq7
 1Z3kNsBTcoYvFtzhP0WjavfPmi0wKTqB7UiXl5+f4Pf6JbYVCa64JMWT7uIg1Lh174EkU0bn+NccNKlNn+oTj5zTSnT+wrWNEJIPtSgTlTC/bEvRA/sBijOlXQYipOhujGQmcTmPxY0huitCOtOuXeWWpgVg1ZMef/S8rgOLhbvt/AUvXMZfEAcLd1rXHtxS46IaUxgGiSNtfmNYNxt3H0XCepFBqZBhIiIb08pYF5uattus2kiPM5kymVq+ciBGWiAUvZBk59cyi33plu08WdRfK/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/18 3:09, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> With a fixed number to reclaim calculated at the beginning, making each
> following step smaller should reduce the lock contention and avoid
> over-aggressive reclaim of folios, as it will abort earlier when the
> number of folios to be reclaimed is reached.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 4f4548ff3a17..2ff1609ff4de 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5007,7 +5007,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>  			break;
>  		}
>  
> -		nr_batch = min(nr_to_scan, MAX_LRU_BATCH);
> +		nr_batch = min(nr_to_scan, MIN_LRU_BATCH);
>  		delta = evict_folios(nr_batch, lruvec, sc, swappiness);
>  		if (!delta)
>  			break;
> 

LGTM.

Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>

-- 
Best regards,
Ridong


