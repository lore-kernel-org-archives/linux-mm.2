Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9821606A889
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i2lF6/10
Received: by kanga.kvack.org (Postfix)
	id C2CAD6B05EC; Mon, 16 Nov 2026 06:30:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDCB66B05ED; Mon, 16 Nov 2026 06:30:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACBF76B05EE; Mon, 16 Nov 2026 06:30:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 898786B05EC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:30:07 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBA9012087F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:30:06 +0000 (UTC)
X-FDA: 85440763212.28.AC59AA8
Received: from mta0.migadu.com (out-79.mta0.migadu.com [91.218.175.79])
	by imf14.hostedemail.com (Postfix) with ESMTP id 830F510000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:30:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i2lF6/10";
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794828605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MkYPvtNGN0RhdD/DTofBA5aCK7VL8OaqbvoHLj/J3vY=;
	b=yLxunhwe1UFmAZi+kGrU7/CR1SkQkA6qXXbW3RqIkTY4eRjJokvVwippKtuC3HhAfEXrzV
	/uPp7L+lRuOaGt9F9uSD1r0Estd/LCMbZLjwh6V2/YPPDOAwpMkv/g5TpAijs7gWjegNra
	Gl+cwkBICrB6UJvVvKQ4iDg8xJXXDoc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794828605;
	b=g16ExlWipjly43Zk5biRPDaBfO6GDfpfJ/mR4zk5FCVWcxO0ZUeIUPsq1mCX7R0YRiTAfa
	3xleH3y6sd3oEJNeDxm7tczxWNqikBSEknNnMRXrRyzpdoDcdvUnYbF52pHbS4nfifdCdm
	ZHE82ArCHj0i11q0x3fojJ3adDIdgjA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i2lF6/10";
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.79 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ie4RzWFhry2MN3P8FJFlT0JqjLp78vgtKrFUT1SVLWI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794828602; v=1; x=1795433402;
 b=i2lF6/10/tKqW7+jjlsiqUbSErRov+b5YnPW5cXNHPrUh6VD97+SFBon5+ntzEpAiP6/y4nj
 kt4PPLltsQD0+5aq9LENyeXEVOsO+XEMEY4sepT5gPG4/aroL4gboPIhJ5uXQVnYkGPKFpwgPUo
 NDwKtDzMZJKskYI18ybD3SSQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ea6ad778d8d8c0b8;
	Mon, 16 Nov 2026 11:30:02 +0000
X-Mizu-Trace-ID: ea6ad778d8d8c0b8
X-Migadu-Flow: FLOW_OUT
Message-ID: <ec16f79b-3a71-4790-b91e-ea73d361bd16@linux.dev>
Date: Mon, 16 Nov 2026 19:29:52 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/16] mm/mglru: report evictable sizes per type
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev,
 kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 zhuhui@kylinos.cn, sidchintamaneni@gmail.com
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-2-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: okyw5kgfxuetkdj8q11fgryiwepuzmnm
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 830F510000C
X-Rspam-User: 
X-HE-Tag: 1794828604-133904
X-HE-Meta: U2FsdGVkX19uyylcvR55eyPlbgCuCdMg5kiS8diPiOC8Ri5MFr89EctpyLh092PYosnYXthOwfYjNOD3kU7rU5oS+jdNGsJ45YWTHoDC+MbYaazQ7araZvEi/+dj4mLbCbDVhEwE4ryPTkLUfYNlgvtp+iZGxG5zwjvDXeTkbdV5fYJTpnoYzZEYjWx/b2mE0T6qmsgBEKIFpaZHa/q25aIxd7rU9FhNam8imqtIzagiIMEqCB7BSxcx5ggFG43jp0CaLO7OnzXcvq0suWiGcpyWrdurO75KLwyA4WCS6akaxJV416vj6TvRjlfvhtAFyd/5ytzNZ+hiFmIR9V6KK5xn/4ybaeHENzM8lrpZ+ZFsRP4T4NGixSKC/1nl0FW8J3ETZjVKqUeIxOJXTBqcbYB3lmiCVeeAiDIZN1FYqvLn1/xbYy0A/p2Mwf0BFUw3vP1tqz+/GdmtfpeBi9Qut7XnToKM9rninOgIUqxezpcM6vtabVCIvnfBEyfDReYEsMzPTrbJKkmpQlvMWfinft9ceDhMcAk5/6VcEC6qZUifsik0WXdD3DzBUkI9OGzleeaRXrBMLl8c1Hq3WOgNa+cJn/yOeaCE/1pABBvDBCAC3zVpEZul+jw/5UoTcmvBq3cOHI+HepZOUM1dbdvXLM4U4Kp6z2jCsOqSd9t/nHXaBqOm35qocieDynuRxUHlY714FFKqLQ1UGzmL+kfWjxjE4FEXsYKttwzTT56w88ITXhWF0+sOzDeg6KwqPTs6fKqc5MqiNkEiztm4bGQIkC2M2CjgWjFWrF5PUGKK3C1QVHXXUd1bR/3/ZdnHMnrgoUCkM7rtPVmr+jjGYSUMoF3U7pf+2CkKZM1jLztSShnCWAU5u3AF7iAugxWf0qSmm5qNY5TITivACFWQb2gvFequURe9oG8t+/LkYWRW1dwNYJ/5R5ShViCaO7zj5Y0FZwN0EscjL9QkMqrUIoz
 89kyOUx0
 d7Xoo8zastssdATtOF73PD52eovRJTsjyGvMNauF9oQ8FKreo45VSA9Tjvzq9HBwrYHc0WS7IND6K3MgWyENLuMUaOgsAM9E4p/c3TA9Y9+0ZcJD9aubBvk18yVJR/hOOuECrU0MQGqUJfA8rNBvfq467ou9JYZvhlTt+JVgMAavgQ5RZ0QTa+tETVb/+nRPS74wYFvbpH1e60yDlRCdM1MBuZGYOey/7tYZm4Zi5JGXEmBKfxkIy342Xt31q7EwjVQFDQ8vg6cSBnGdJ2qbI9segvrYwXdDqgs3VvD1nHS0iW/A6Vvpx8rtIAxFuHTnwF37Ie8TkObEAAKynvLtVFw7m8/y/5RrdZ8GkeIo4oDnWLsOlNpl1A3DFtOD445pUngNr6Bbk246thE+gagEbzFMPcX0sSk8mSXu0fEuZyAhb+qxNzIoe3zVXkBW9MGcz9gHY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Change lruvec_evictable_size() to return the number of evictable
> anonymous and file pages separately instead of a single total, so
> that callers can weigh the two types independently.
> 
> Update lruvec_is_sizable() and get_nr_to_scan() accordingly; the
> summed totals are unchanged, so there is no functional change.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>   mm/vmscan.c | 22 +++++++++++++---------
>   1 file changed, 13 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 46be9c7e967c..400f87fc51e1 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4193,28 +4193,31 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
>   	sc->priority = clamp(priority, DEF_PRIORITY / 2, DEF_PRIORITY);
>   }
>   
> -static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
> +static void lruvec_evictable_size(struct lruvec *lruvec, int swappiness,
> +				  unsigned long nr[])
>   {
>   	int type;
> -	unsigned long seq, total = 0;
> +	unsigned long seq;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	DEFINE_MAX_SEQ(lruvec);
>   	DEFINE_MIN_SEQ(lruvec);
>   
> +	nr[LRU_GEN_ANON] = 0;
> +	nr[LRU_GEN_FILE] = 0;
> +
>   	for_each_evictable_type(type, swappiness) {
>   		for (seq = min_seq[type]; seq <= max_seq; seq++)
> -			total += lruvec_gen_size(lrugen, type, seq);
> +			nr[type] += lruvec_gen_size(lrugen, type, seq);
>   	}
> -
> -	return total;
>   }
>   
>   static bool lruvec_is_sizable(struct lruvec *lruvec, struct scan_control *sc)
>   {
> -	unsigned long total;
> +	unsigned long total, sizes[ANON_AND_FILE];
>   	int swappiness = get_swappiness(lruvec, sc);
>   
> -	total = lruvec_evictable_size(lruvec, swappiness);
> +	lruvec_evictable_size(lruvec, swappiness, sizes);
> +	total = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
>   
>   	/* whether the size is big enough to be helpful */
>   	return total >> sc->priority;
> @@ -5028,7 +5031,7 @@ static bool should_run_aging(struct lruvec *lruvec, unsigned long max_seq,
>   static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>   			   struct mem_cgroup *memcg, int swappiness)
>   {
> -	unsigned long nr_to_scan, evictable;
> +	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
>   	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
>   
>   	/*
> @@ -5044,7 +5047,8 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>   			return 0;
>   	}
>   
> -	evictable = lruvec_evictable_size(lruvec, swappiness);
> +	lruvec_evictable_size(lruvec, swappiness, sizes);
> +	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
>   
>   	nr_to_scan = apply_proportional_protection(memcg, sc, evictable);
>   	nr_to_scan >>= sc->priority;
Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong


