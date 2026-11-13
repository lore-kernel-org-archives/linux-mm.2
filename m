Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E21606B214
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 08:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jJ/iIGz4
Received: by kanga.kvack.org (Postfix)
	id CB0776B063C; Fri, 13 Nov 2026 03:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C60796B063F; Fri, 13 Nov 2026 03:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76E36B0640; Fri, 13 Nov 2026 03:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95E586B063C
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:53:44 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 19ABFC038F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:53:44 +0000 (UTC)
X-FDA: 85429482768.22.B73FD9C
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2B8F720002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 08:53:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jJ/iIGz4";
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794560022;
	b=bG5DEY1/eM/sl7/BcOdxGdrGUqOSRE2CNnZ2PCpnn+ETfIZqV4f86dZY9vadCfHyMgQBKz
	kUqGhB29GGzt2NUCBQ8zCpIIV2MEFJqtUalARJOVa00aSC14gtmQ19UnIXu+EBc6FWFFqq
	cgLCbuOEQErXf92dTc1AS2HJ/BZPn30=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="jJ/iIGz4";
	spf=pass (imf31.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794560022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cjQnjpho+fyRhgUTZY5Z+DHRvjFJ19pcEbfZyNg/8uc=;
	b=Tf0MhOubZe0GA2OGhWaSP4ETdPBmXRaG7fFrD4RS1k9MAxnpdP8bZmU/gnSh6fJuAhYerq
	EsGHJiSD4Z/2/uo94CJv/RgkzVENd+M9oUGFIW9xmsGd6xm6dvKqFm9y/k5PmaEMQW8vGQ
	bZtbskHq9r/JGWXF3Hd42D68qzhzUSg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CqTuTBJUY5nbUP9k6g85314MB/qlykyFWA7AeA8gtPY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794560021; v=1; x=1795164821;
 b=jJ/iIGz4xJtTBlVk7sS80UqXlRpw54Qna/snuriOIzh3X08wZH/3ipRFnVHogOt5qM8Y3r2C
 mX7M83EwtJBNpBo4XrP2fDZInfOh9Di2RNNxDc1eC4OhoJ7XLKcRo5lY1NIjq1NoBqK+V/fHFEV
 skJjKSPONmuw0YHbw+hwBIlU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f62f24c4a9f7b48d;
	Fri, 13 Nov 2026 08:53:40 +0000
X-Mizu-Trace-ID: f62f24c4a9f7b48d
X-Migadu-Flow: FLOW_OUT
Date: Fri, 13 Nov 2026 16:53:32 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, kasong@tencent.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: Re: [PATCH v3 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
Message-ID: <avbQDAw6zKe5dRzH@fedora>
References: <20261113084953.412919-1-baoquan.he@linux.dev>
 <20261113084953.412919-2-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261113084953.412919-2-baoquan.he@linux.dev>
X-Stat-Signature: hk4oxqcfh9uokb6wtj1bedg1gh4rdsqn
X-Rspamd-Queue-Id: 2B8F720002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794560021-907645
X-HE-Meta: U2FsdGVkX18zF750U7t9KEhYeUm+ZCMpMCoefUbtfs4CjuDSuhGDO6BGAB703a7K+n9GVeDWpRD1yUqPSTxfAi7+Sx1q9BwI/ANs64C7RUCYMF4SKcEneniWpAaP+8UYZqnGGsi4j/WEVJ4usVJkKsSsjbR+2rWfJfno7DCMO/Fo/sUmjUr9Y0+geI09ghwQG4ZjiyieWuZvKb1DzU6C6D3zmdMTYmxS38+No9QJlBiYOy7RsUMN5DVr/RAsyzTZTkYViPrhibHiUE5fFhz/rp0/cwRIVxr+iPnnAxkPAUOzav7GIF3vUtHVFQL55qHseiTy4iH5Oqt6MTq3dD9ivqfln3v2v9EC49Pfw6zFwuUGlyp0qmmuQcp9ucwFCMfApn909Xd6+Amx8Qw5Z2inhHrfi5B7PNMwAZLbBW822hnRGMSNm8ZmErlk1zq48ktvN0nncJmHTaMuBGfJotN7Bih/zH3XQfeF4+LUCX+yoE8e8tCouK8QIlN/f8oKrNusm71GJixsNE8E/VuTUz2tFXSE4Pjk50PRhMUjjhQdPLaEj37gSUWmupdW4ViiHBbHJv4VGp/yavSc7/EHPcNlgxJxPsDDDqwGeBzf25qyKgJjB8vQy+lWWFrFT2R2Qe5mb5VaXi0NWn+RdZPVRgdJ5Q4cU8BcDe8nNoL15qu3nw4ojoGthLaINuAM8oTzc14OJew+BdW9GRdzb6PYn896BJUXgTEWmF7KI4/DUdmAhf5CcUu2tIcSCua79M5QIBRwaycxQUm5i8pMUUcY3uWPV+JH04Epi1pcE+AupVyGz18fzbXM/e2BEqXci8RJzbqtF7vnGcLSRR+sHWhAuj3Rr19IZ9UZpkSPAsdtZl7FysdLEx9FL+U7rc5Ipac2evkEjoWkak7BW/RRGbvJkN/iMVoL1qshJfeBtgl6xul0LBPfGQrvmuiB8VK5IIRV2GQO3ga93a/XH09IHFueTbo
 JXAnab8k
 shfqKhU7U8fPAP2sDYT7pWM/CECvGq2PUQs2k0pJ4zl49ChXnZdngv+RIbBbUiaavblkVd71JcAykkAPRfcYVCxrZft9UgwjBzvVs3xfyah+BX3J73OpZ1bMhovmFLkpI4erJK52ThLS4BPPANDhpji1uiG4PRnWeyjKoEFbZ+VgEMlnYCa6B3YGVq1rcMTeFGDk0+pxBJXSbb4zsHZQCYdpH0yfpbXfENdUCByw2GyOKtWZQHL90hX6Vv2/dW344cXHwTWCvilfu8+ffx2pbdAWd6LFqTCpW3BHK2bxpxSJskVTNZkqZT8Jt55MCdZD/at8ZCJ8rxU8C3H/ujYsOLNw6Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 at 04:49pm, Baoquan He wrote:
> From: Baoquan He <hebaoquan@kylinos.cn>
> 
> Add per-walk counters to measure empty aging walks which traverse
> an mm's page tables but find no folio for the current lruvec (node+memcg).
> These are common on multi-NUMA node systems because lru_gen_use_mm() marks
> an mm for all nodes at every context switch.
> 
> New counters (accumulated in mm_state->stats[]):
> 
>   MM_LEAF_ASSOCIATED   - leaf entries whose folio is in this lruvec
>   MM_WALK_TOTAL        - page-table walks completed
>   MM_WALK_EMPTY        - walks that found no folio in this lruvec
>   MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks
> 
> A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and the
> debugfs lru_gen output ("TYFALWEE") exposes the new counters.
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>

> Signed-off-by: Baoquan He <baoquan.he@linux.dev>
~~~
Git format-patch automatically added my linux.dev mail address, I should
have noticed this and remove it.

> ---
>  include/linux/mmzone.h |  4 ++++
>  mm/trace_vmscan.h      | 28 ++++++++++++++++++++++++++++
>  mm/vmscan.c            | 32 ++++++++++++++++++++++++++++----
>  3 files changed, 60 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index c161d563ce8f..a49efd9b74ed 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -579,6 +579,10 @@ enum {
>  	MM_LEAF_YOUNG,		/* young leaf entries */
>  	MM_NONLEAF_FOUND,	/* non-leaf entries found in Bloom filters */
>  	MM_NONLEAF_ADDED,	/* non-leaf entries added to Bloom filters */
> +	MM_LEAF_ASSOCIATED,	/* leaf entries whose folio is in this lruvec (node+memcg) */
> +	MM_WALK_TOTAL,		/* page-table walks completed */
> +	MM_WALK_EMPTY,		/* walks that found no folio in this lruvec */
> +	MM_LEAF_EMPTY_WALKS,	/* leaf entries scanned during empty walks */
>  	NR_MM_STATS
>  };
>  
> diff --git a/mm/trace_vmscan.h b/mm/trace_vmscan.h
> index 565c56428364..4884fc7a35b9 100644
> --- a/mm/trace_vmscan.h
> +++ b/mm/trace_vmscan.h
> @@ -763,6 +763,34 @@ TRACE_EVENT(mm_vmscan_kswapd_clear_hopeless,
>  		__entry->nid,
>  		__print_symbolic(__entry->reason, kswapd_clear_hopeless_reason_ops))
>  );
> +TRACE_EVENT(mm_vmscan_lru_gen_walk,
> +
> +	TP_PROTO(int nid, unsigned long seq, int leaf_total,
> +		 int leaf_associated, bool empty),
> +
> +	TP_ARGS(nid, seq, leaf_total, leaf_associated, empty),
> +
> +	TP_STRUCT__entry(
> +		__field(int, nid)
> +		__field(unsigned long, seq)
> +		__field(int, leaf_total)
> +		__field(int, leaf_associated)
> +		__field(bool, empty)
> +	),
> +
> +	TP_fast_assign(
> +		__entry->nid = nid;
> +		__entry->seq = seq;
> +		__entry->leaf_total = leaf_total;
> +		__entry->leaf_associated = leaf_associated;
> +		__entry->empty = empty;
> +	),
> +
> +	TP_printk("nid=%d seq=%lu leaf_total=%d leaf_associated=%d empty=%d",
> +		__entry->nid, __entry->seq, __entry->leaf_total,
> +		__entry->leaf_associated, __entry->empty)
> +);
> +
>  #endif /* _TRACE_VMSCAN_H */
>  
>  /* This part must be outside protection */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 96201eae0ceb..98037a562ab6 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3590,6 +3590,8 @@ static bool walk_pte_range(pmd_t *pmd, unsigned long start, unsigned long end,
>  		if (!folio)
>  			continue;
>  
> +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> +
>  		if (folio_test_large(folio)) {
>  			const unsigned int max_nr = (end - addr) >> PAGE_SHIFT;
>  
> @@ -3688,6 +3690,8 @@ static void walk_pmd_range_locked(pud_t *pud, unsigned long addr, struct vm_area
>  		if (!folio)
>  			goto next;
>  
> +		walk->mm_stats[MM_LEAF_ASSOCIATED]++;
> +
>  		if (!pmdp_test_and_clear_young_notify(vma, addr, pmd + i))
>  			goto next;
>  
> @@ -4151,8 +4155,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruvec, unsigned long seq,
>  
>  	do {
>  		success = iterate_mm_list(walk, &mm);
> -		if (mm)
> +		if (mm) {
> +			bool empty = false;
> +
>  			walk_mm(mm, walk);
> +			/*
> +			 * A walk that traversed page tables but found no folio
> +			 * belonging to this lruvec (node+memcg) is pure waste.
> +			 */
> +			if (walk->mm_stats[MM_LEAF_TOTAL]) {
> +				walk->mm_stats[MM_WALK_TOTAL]++;
> +				if (walk->mm_stats[MM_LEAF_ASSOCIATED] == 0) {
> +					walk->mm_stats[MM_WALK_EMPTY]++;
> +					walk->mm_stats[MM_LEAF_EMPTY_WALKS] +=
> +						walk->mm_stats[MM_LEAF_TOTAL];
> +					empty = true;
> +				}
> +			}
> +			trace_mm_vmscan_lru_gen_walk(
> +					lruvec_pgdat(lruvec)->node_id, walk->seq,
> +					walk->mm_stats[MM_LEAF_TOTAL],
> +					walk->mm_stats[MM_LEAF_ASSOCIATED], empty);
> +		}
>  	} while (mm);
>  done:
>  	if (success) {
> @@ -5638,14 +5662,14 @@ static void lru_gen_seq_show_full(struct seq_file *m, struct lruvec *lruvec,
>  
>  	seq_puts(m, "                      ");
>  	for (i = 0; i < NR_MM_STATS; i++) {
> -		const char *s = "xxxx";
> +		const char *s = "xxxxxxxx";
>  		unsigned long n = 0;
>  
>  		if (seq == max_seq && NR_HIST_GENS == 1) {
> -			s = "TYFA";
> +			s = "TYFALWEE";
>  			n = READ_ONCE(mm_state->stats[hist][i]);
>  		} else if (seq != max_seq && NR_HIST_GENS > 1) {
> -			s = "tyfa";
> +			s = "tyfalwee";
>  			n = READ_ONCE(mm_state->stats[hist][i]);
>  		}
>  
> -- 
> 2.52.0
> 

