Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A66C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:33:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D86BC6B0092; Tue, 15 Sep 2026 02:33:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D38C96B0093; Tue, 15 Sep 2026 02:33:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26ED6B0095; Tue, 15 Sep 2026 02:33:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FEDF6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:33:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C5D33A033E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:33:05 +0000 (UTC)
X-FDA: 85215029130.27.6AAD696
Received: from mta0.migadu.com (out-127.mta0.migadu.com [91.218.175.127])
	by imf17.hostedemail.com (Postfix) with ESMTP id BAC2440007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:33:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hbsdzFZt;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789453984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbU+uGnK1gqWzah0HlYL1cRHWdd51PFSkVU0YOvTf3o=;
	b=kI3j3CtegYcnhd6oqDVowuyODmIyCzegHjctzntMe58DTaXrrStbI9sRNCIgblrsSDYy3q
	C3Wr7et4e3aWVpzj+QyEkoDoOToEBCLSFbIXHzwz5kUew007Ipk97o5cWsepHH7pGznqee
	nq96GsWh60OWTZkkQbcEPfG/gkGzZjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789453984;
	b=AwLP2qZenRDy/9PKwahhKDxF9mWzjpZQ+fmSPiKMJarE7X9dN90lKseIWnR3kdhej5iTvP
	6eTu28Cj1W0qhrXsS1LPzhnSZLCDlUM4P+i7wMFo1HPGXZ1+F7q9ODGFiAu4wDxFKymMNV
	rpdYy+LLvHB1UAiUaCmjkoiN8zyHKj0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hbsdzFZt;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.127 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IPOCbVBUgdVnmtzzR7HtI43I8h8P7ryRrCKMwyBkjBY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789453982; v=1; x=1790058782;
 b=hbsdzFZtGFX8VSpgDFGdiaKIfeyF+EbVmaUOZgEJcvsMF1K1mwOgQJ5K+XrRn8cDTFwuPHig
 IGmFReifd/8syYwSk198OsEQjQYZh9qM5nEnkhM0roHU69WHo3n4NzAdzHqhBYpD0vLFi2jzWna
 k6ZhKE2loEmn/XIbq1A7ptFM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 3a2ca07b71f21ef2;
	Tue, 15 Sep 2026 06:32:52 +0000
X-Mizu-Trace-ID: 3a2ca07b71f21ef2
X-Migadu-Flow: FLOW_OUT
Date: Tue, 15 Sep 2026 14:32:46 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH v2 1/3] mm/mglru: factor out lru_gen_seq_nr_pages()
Message-ID: <aqjmjguIzTssbpUt@fedora>
References: <20260911102939.2485750-1-ridong.chen@linux.dev>
 <20260911102939.2485750-2-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260911102939.2485750-2-ridong.chen@linux.dev>
X-Stat-Signature: c4j9mdthbyhbu4zr6ap37ajiwdd5qmsk
X-Rspam-User: 
X-Rspamd-Queue-Id: BAC2440007
X-Rspamd-Server: rspam03
X-HE-Tag: 1789453983-890456
X-HE-Meta: U2FsdGVkX181+ED2nqB5Vux5yQgRYYmho9esDgAqkqrFmU8PjzP36usgsHRRaHrMIiQGgFiwCCQroohPvq7s3O9oEhFFOVtJbYnRPOkDEBpS6ObhCwZidu3bSjj0SgUgJ/cn2LmqgTU8M32zlri7W70k8OnUtHt80FVkl8VAQk9tr1erbPl23m9WC2HwcVweVq1eF+/qzqBGS4VgSZvJEBN8WgD/w5oL3kBy1jFpwPtS+MLjWIEwmQ66i/RjqUfWIgCGZw7+33a69ujWJI28e0WMo4GFffyFvnarp4BmAhs7aVobWwoBoGOh1RZkiYDdtDlrZZGhTG9kbtyovJd4FDtKpi0zUjWi55iROAKAUQabuNN29MgYShqiJKTy/uHN0MBdfAaLxiQ0vtZ7R55ZoXmbPfv9ZZeBPAqkwyMfBMK37rc36PP7uZ3hgeghE/mGt3wL5Or2/tze78/SMvFSSvaJuk18P3rU62LRbCHmRpXVXM2x/MtVCZHpyMldQfqDBuDbcnhzKdkspG7qS68rmMWSyYkFWuA8243hWHomQsX/yLRNN6z5JiLWT3n7t65RPDlSZ7m6hVxWiR+Q63suqrSv6cmukT9LJXDiH4gwbcNDcitJmUB+jHxP5eyQCn90AK1YMFId/wkLOr30nB82JAX04zT7+dVjdOf6oi/8VRV2zAGF/0YAcY3YX7064HIkNyoxOsv49EKV5sAwcoNKXMx6fMxRilsHkilQULnZD3+Q1WOXmDkqc8p8dCpua8kLi95QYnoBNYaelZLnwcqaxG5Nblm78udr0xUYK4efLRmWidkx4r8AvTyK8dfq08rQW1RRMsvTLJz7xz3EwudLhbBSf6uC7BQ1fe/sNeuPsRm3bKhp24k/ItsCwrw+vOaqkKkKl9MnGLg7LJM50CIz0WZL6EgzHbFH5HUVBUUMRRQ3Sy6usYVZ2p1jhzMiPS6dT1YMYYe18jT1bO2tvoT
 k7teqgIA
 9kwCSpJ+Es0uM8NSAlJs8wtEP7tBRzbvSP/ILRItT4EXMmUWM3KUogK434emP7zbNYl2vM8Y9ExSje8HW/+1xAPkiuGbBHNXyrI1Y5qzmVfObSFMx43n0BGqwTv7oSzvOZqUqcBnOT+I7j5EBg/yUzLt0cSvKwW9OlPyBSL6B6JiUkCwhrFmIRkWWTnn6J+dqsCQdTbZiDQmERm5roRtraJBpXdq/z4+eb865f9h5a80n3GwCCdXMjbqyohtCx09CNcad4h3f/z9V56MIiW2t5LXil0c0Q2w5dHSelEDbSiaO6WQG5CpQ7MbbePWT7rDTaWkEIzW4wY8WSMqIWlWTA7RMeib7/o0Lkb1aYJ2a/5eujrs7S0J4cIVTqUuN8FMflH5y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/11/26 at 06:29pm, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Both lruvec_evictable_size() and the debugfs lru_gen_seq_show() compute
> the number of pages in a generation the same way: sum lrugen->nr_pages
> over all zones for a given (gen, type) and clamp each term to >= 0.
> 
> Factor that out into lru_gen_seq_nr_pages() so the open-coded zone loop
> lives in one place. No functional change.
> 
> A follow-up patch adds a tracepoint that needs the same per-generation
> page count, and will reuse this helper instead of open-coding it again.
> 
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 40d3f1b48a74..2554a6513aa8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -2813,6 +2813,18 @@ static int get_nr_gens(struct lruvec *lruvec, int type)
>  	return lruvec->lrugen.max_seq - lruvec->lrugen.min_seq[type] + 1;
>  }
>  
> +/* the number of pages in a generation, summed over zones and clamped to >= 0 */
      ^
The first letter should be capitalized?

Other than the nit, LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

> +static unsigned long lru_gen_seq_nr_pages(struct lru_gen_folio *lrugen, int gen, int type)
> +{
> +	int zone;
> +	unsigned long size = 0;
> +
> +	for (zone = 0; zone < MAX_NR_ZONES; zone++)
> +		size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +
> +	return size;
> +}
> +
>  static bool __maybe_unused seq_is_valid(struct lruvec *lruvec)
>  {
>  	int type;
> @@ -4239,7 +4251,7 @@ static void set_initial_priority(struct pglist_data *pgdat, struct scan_control
>  
>  static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness)
>  {
> -	int gen, type, zone;
> +	int gen, type;
>  	unsigned long seq, total = 0;
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	DEFINE_MAX_SEQ(lruvec);
> @@ -4248,8 +4260,7 @@ static unsigned long lruvec_evictable_size(struct lruvec *lruvec, int swappiness
>  	for_each_evictable_type(type, swappiness) {
>  		for (seq = min_seq[type]; seq <= max_seq; seq++) {
>  			gen = lru_gen_from_seq(seq);
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				total += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> +			total += lru_gen_seq_nr_pages(lrugen, gen, type);
>  		}
>  	}
>  
> @@ -5738,19 +5749,16 @@ static int lru_gen_seq_show(struct seq_file *m, void *v)
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
> +			unsigned long size = lru_gen_seq_nr_pages(lrugen, gen, type);
>  			char mark = full && seq < min_seq[type] ? 'x' : ' ';
>  
> -			for (zone = 0; zone < MAX_NR_ZONES; zone++)
> -				size += max(READ_ONCE(lrugen->nr_pages[gen][type][zone]), 0L);
> -
>  			seq_printf(m, " %10lu%c", size, mark);
>  		}
>  
> -- 
> 2.34.1
> 

