Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F148606A330
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 05:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PU6M/JuI
Received: by kanga.kvack.org (Postfix)
	id 0CB266B00EF; Tue,  3 Nov 2026 00:54:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CA36B05B1; Tue,  3 Nov 2026 00:54:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED6C36B05B2; Tue,  3 Nov 2026 00:54:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CABED6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 00:54:20 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D77641402DE
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:54:19 +0000 (UTC)
X-FDA: 85392742638.07.92823DF
Received: from mta1.migadu.com (out-223.mta1.migadu.com [95.215.58.223])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB4E5100009
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:54:16 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PU6M/JuI";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793685258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f6tohwCPgHiuZF8eRH66ZKcFUC+TlKOu4ZWfBkxIU9w=;
	b=Am6blCuTf7tYMlzD0kj7VC9x+N2nWm5Yl0bf6jkeo/Ilhuqjd1eDEmn8NusHMi+9RBIir9
	QzD8rtjwFzlnnLtD4F/TveAOfpsmzAA33xEt6LcdEdP0Yt6UqISD6wD/xqejkUyp4SA0Fg
	6npmWe5LcALg7qwx5g9PHAWdRMFXh8k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793685258;
	b=ZpwaAtTvmKHyZxQbIQVMpvr0z4b6Q+idRVGshvCswbD9hVYUUWvv7ck+rGy24EETos12PJ
	45MAd5eyGN0OG344tj6kTeApNwfWgLEghT4cWunTSfMARJuKqORF4juKINb4N5JNypFxVl
	meqz1bERJdma4VePUN2diT2nbr6EHJ4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PU6M/JuI";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.223 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0iTU/obU9AJ9W0pesgfQNaEftQkREMOsnsvVS/OmldY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793685254; v=1; x=1794290054;
 b=PU6M/JuIkSLzUXuS6JZKKUvE//74A4tu1nNGmYcFb/OMTL0YL2iWlmVRngQpvLppWY+UhK4L
 kOzLqJsPN0sy3ZFQ/p/WeBzIG0EjJn/+UE88cigpF9T1Kfjp+xeur+8O/wE60EIjkouagxq2puf
 25tElufqBKwzf+kZFylFCdkE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 4e3eec371c58ba17;
	Tue, 03 Nov 2026 05:54:14 +0000
X-Mizu-Trace-ID: 4e3eec371c58ba17
X-Migadu-Flow: FLOW_OUT
Date: Tue, 3 Nov 2026 13:54:07 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v6 6/7] mm/mglru: add lruvec_gen_size() helper
Message-ID: <aul2_8m90FuzSnqv@fedora>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-7-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261103025610.3738894-7-ridong.chen@linux.dev>
X-Stat-Signature: q85dszkce86zswxcqpbf4spe17n4xsec
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: EB4E5100009
X-HE-Tag: 1793685256-666044
X-HE-Meta: U2FsdGVkX1/mQUC7rGP6SCCvD2xypOsdLW4rIFYwTQ+grgjV6rGXWuxYziAdULpYtTj49nAopRok6DnPiXB/uxFJx5COKnIdInhhMw9/AYU1e3bxALUKLf4ZHqJ04Bd9xRXP+1e8his+isPJDFRxWz/nHkGJH7oSImLcLw8ZaD71XGHSv42x0XYxxtRLeJbaCnutvHaH52+UUezEUdi/Oba9EcDUcs1F9uIIsS8hy2r9AOodCHarVpX7GqjwXulI9nYcQIki88XmKbZfexAN3apOJX64VChSDNGvTCOvvZ3Y2xCa4TL/FfQPobtENjIIFw+KFSDfoTK+ov3NMttyJege9Xrs5ZqkdG3xHDxw0VfXzXeA4SYJeRaTSlUMrm7YYUijnQBc2oYJ1PeOVNFFW8M1LhE+50+vtRICzwpwTK9Q80WBswYoX9KcOM/RLIaVISXADRPzxpRdXrO5NBhT1sklNxAY4wwc/q//29qeZYmtc5Jq6AlQ3lOB92jQJiVa19cO3G8gKbTEwPpq+G8Ngd85wTkdTbmeUXzl18hZwc7zzEENaLinUXssHSoRIdNpa5/bcdtQHfR2yILOpCyZJIkiSPFaomCtH7xRYXE/yg0shXGijz+VcHumF6Y7rgmXP0MkxV1MlvxK05Ryqyc+kKX5E3q+86mVCEaxnQpkJJVmq/Sh8kQJnJ4d3yi4iYcBA4aX2HfzVLpaiIL5441RA0m80/LrriDhjTIsm244PJDZvuD3Ehv3i6icpdUejVObtclbcYLPaTSowqMBDDBqag9Xc8gYqesrvihrlvwB7FyumScYU9aKo8CxlM2PIIfHvYsKlG9HYTo5AmCyqKzW9hf8BrQ+JiLhMD4RsVMKYSykWZIPvOfOm3u+cEA4yF1V0Z/JjkLP+8IjXMUI8/zrzi3Cl46qx4n7zD5+/+xxo8GVLI5kqns1+hpjIrCV3c1dZoDtoZBnAyoCv2ONKwb
 4qzjH7A1
 qfHjUmk88ywamfPS6Z9Z3JaTIJoYLuYL+zzUAipykowebm5fMC4VGivLLDjEexhI7ocSB6dC3U7/rD37WALSNk7eOUV7/A608u/yXCQSZp4qOOIJ4Fmau/6diggLMeGo0HVsGUwVd5sgICIey5jHwR44urL/kfofp9EWAD4+IL46Yhc77BM5HynicT35o9Ni3tcFP5EZqazBTXunjn7uG8FkucQyFDGgeVP7yT82b7agaXM4sK/+syVPtegXT9EoskzZSI4e0ETsKU/WqM1j4y/YiJIdr1lwo8eeV0k1hTHxi/RwKIdH2AWQK0lSCBJ/JwGOkZBiLx6dVdS/BZ9pDGNp/KoCXU2oHdycSoWrKGR565Pc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/03/26 at 10:56am, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> The number of pages of a given type in a generation is computed by
> summing lrugen->nr_pages[gen][type][] over all zones and clamping each
> per-zone counter to >= 0, since the counters are updated locklessly and
> can transiently go negative. This loop is open-coded in
> lruvec_evictable_size() and in the debugfs lru_gen output.
> 
> Add lruvec_gen_size() to compute it from a seq, and convert both users.
> Put it in mm/vmscan.h so that the vmscan tracepoints, which include that
> header, can use it as well.
> An upcoming tracepoint and the MGLRU swappiness rework will also use it.
> 
> No functional change.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 18 ++++++------------
>  mm/vmscan.h | 16 ++++++++++++++++
>  2 files changed, 22 insertions(+), 12 deletions(-)

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 3054175717ab..1581b73aec56 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4207,18 +4207,15 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
>  
>  static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
>  {
> -	int gen, type, zone;
> +	int type;
>  	unsigned long seq, total = 0;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	DEFINE_MAX_SEQ(lruvec);
>  	DEFINE_MIN_SEQ(lruvec);
>  
>  	for_each_evictable_type(type, swappiness) {
> -		for (seq = min_seq[type]; seq <= max_seq; seq++) {
> -			gen = lru_gen_from_seq(seq);
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> -		}
> +		for (seq = min_seq[type]; seq <= max_seq; seq++)
> +			total += lruvec_gen_size(lrugen, type, seq);
>  	}
>  
>  	return total;
> @@ -5723,20 +5720,17 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
>  		seq = 0;
>  
>  	for (; seq <= max_seq; seq++) {
> -		int type, zone;
> +		int type;
>  		int gen = lru_gen_from_seq(seq);
>  		unsigned long birth = READ_ONCE(lruvec->lrugen.timestamps[gen]);
>  
>  		seq_printf(m, " %10lu %10u", seq, jiffies_to_msecs(jiffies - birth));
>  
>  		for (type = 0; type < ANON_AND_FILE; type++) {
> -			unsigned long size = 0;
>  			char mark = full && seq < min_seq[type] ? 'x' : ' ';
>  
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> -
> -			seq_printf(m, " %10lu%c", size, mark);
> +			seq_printf(m, " %10lu%c",
> +				   lruvec_gen_size(lrugen, type, seq), mark);
>  		}
>  
>  		seq_putc(m, '\n');
> diff --git a/mm/vmscan.h b/mm/vmscan.h
> index adb22e80d760..c6b583fc7493 100644
> --- a/mm/vmscan.h
> +++ b/mm/vmscan.h
> @@ -3,6 +3,7 @@
>  #define _MM_VMSCAN_H
>  
>  #include <linux/gfp_types.h>
> +#include <linux/mm_inline.h>
>  #include <linux/nodemask.h>
>  #include <linux/swap.h>
>  #include <linux/types.h>
> @@ -115,4 +116,19 @@ struct scan_control {
>  	struct reclaim_state reclaim_state;
>  };
>  
> +#ifdef CONFIG_LRU_GEN
> +/* The number of pages of @type in the generation @seq, summed over all zones */
> +static inline unsigned long lruvec_gen_size(struct lru_gen_folio *lrugen,
> +					    int type, unsigned long seq)
> +{
> +	int gen = lru_gen_from_seq(seq);
> +	unsigned long size = 0;
> +
> +	for (int zone = 0; zone < MAX_NR_ZONES; zone++)
> +		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +
> +	return size;
> +}
> +#endif /* CONFIG_LRU_GEN */
> +
>  #endif /* _MM_VMSCAN_H */
> -- 
> 2.34.1
> 

