Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34FADC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 07:29:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E70CB6B00AB; Tue, 30 Jun 2026 03:28:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48E96B00AC; Tue, 30 Jun 2026 03:28:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36676B00AD; Tue, 30 Jun 2026 03:28:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7D916B00AB
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 03:28:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 23FFF1C6D80
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:28:59 +0000 (UTC)
X-FDA: 84935752398.04.53134EB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6A1FBC0004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 07:28:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFn1H9jl;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782804537;
	b=idc5/+rFll1QDr9Kjyi8pzxnXzB6cs9p+oNF/J9Z7Qyxr6+Kbb60OXg/JluHdoHcv4zC0X
	5mDHsz1D552JJluzMFOKU64GJnpLtckk1jVdbRXm9qumv4rOYjfcFm2nJWtzLkZjNx0ZEj
	6mIXxYpfEEz7rGDhheofrXOVyj/Cu5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782804537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e98YwUYuEo+jW47qdB3B72qgzQCPcBwfH7OsRH/ROPs=;
	b=fKg1RFnxqJ6OD+7dxOjMcp5Ip28ZDKMBA3Lf+aRCrVkhA5iqjD9FQqNLuhwtoXf7Gw83eA
	cWR0WiGUYuDOyE7ZNnaEzq3z+X+q1Rpg5CBRjZJcWJ7iGXc8Y7tZbIixFI09CXj9wJE/x7
	01tVEHWohsUKcH2qXEDaosBiDF+Xnts=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZFn1H9jl;
	spf=pass (imf28.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5F02600C3;
	Tue, 30 Jun 2026 07:28:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B7FD1F00A3A;
	Tue, 30 Jun 2026 07:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782804536;
	bh=e98YwUYuEo+jW47qdB3B72qgzQCPcBwfH7OsRH/ROPs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZFn1H9jlfNmlH1zT6vtcHSnaiSbi+w7BvliNM5mVDFp+wwRol6gWi8l9XJFmyVO4V
	 ZC1OzZrcylNAncXXABpRL0ALxO4K0qJwrvq4T8JaZ0mF0FJDHf/t1F0M0aTTptdnGV
	 DekqlyscJV/ndvE/m1VWbF5ajxosTl6fQCgEMhkhHvYEtCbwwGiPwS22eCKS3vFCNn
	 ds5NL/4mLjXeCEHrOH8GvdmXJ7DOAxUDaCZRo4Otx6TJe/MQV3VzXtdtDd58ZYvjV7
	 peUS7KnRBrPkttuQkrZbMkvM+YX+uFCx6hhhtWH4ZAt9u8l6FTINtva91gsMByKy6v
	 YiKx4MywKrGtw==
Message-ID: <ee317968-4aae-49e5-80f4-0c31587344e5@kernel.org>
Date: Tue, 30 Jun 2026 09:28:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/7] mm/page_owner: add MR_NEVER to enum migrate_reason
 and use it for last_migrate_reason
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Alistair Popple <apopple@nvidia.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
References: <20260630015331.147174-1-ye.liu@linux.dev>
 <20260630015331.147174-3-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260630015331.147174-3-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: cstfpgdye11zbknr3bzc61oben7gpc8c
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6A1FBC0004
X-HE-Tag: 1782804537-213870
X-HE-Meta: U2FsdGVkX1/qA1fKceanyO6mgQxy0GUe98/rp4zVcDDZkwLCkKCc3Nd8MUhkftpmrrCsTjBCZpJqSrlBXda0a+G+g30vJ2Hrno8PpMnDH/NpdCn50+OCYb0axOLWn0yhlkT1ITvung8ohBQjQIrVMhDKuAD8i2YuEBgOVVz9/xlitPGyMkP/q8yhrdBSf536JHZ4K1e46YZxRH23SLm7IAJ9GOCNrvolcCqf4tOQZkE8ZusHJ+1fFAs8O69wSJKkLNwuoZg6Pf1dFILgosugiPmqzKLHvsQ9Qw8+wyKZAeh9XejP1CU7k6GwqKtjDLMH1YsSY6Qm8ddB6MmIbWbRH5DSR4WoJ/dHwpj5moCqz0rLRfoB8ee8SpZk4J7ZEqqlbD3irtLi0cCvTHFDiI55FE0sqb/jiYGSLbaTVurqe77lwXuSIjR8NMiDQWtXerhYZkcs59o0AgY7CAF30Qdb3Lfk8lZnUjpNte7VRIu01G6ww3uyb06aICYHcEg/V4ORU6mGweSAv4/2H86BUairuI7D0eYtk+hMR/O58uphijlv/kRAVu6YaocbCBIqXkQtnJrVFlEjeOy8v6pOQ83gjXEDEbd02r0zf6te7HBq35jLWMUnuKhMcA5UTHlqpYKRfDZXpE/FLK2VWTN2clNHSP5LYFRqMghbDQw0cbnwgFusOSIaDF7y/zsXf27WtPjC5SIhSIq2vB7O57bcse5UDfGKnHLJzuB2ZrHipSJXyVtjX2t54DdYhewuNoFIn0qzhZ7yrpd/W+NocUAa1n5nQSb7fv70L6ZCmZN5glnd7WpG+qt4YQAfd0agfhYs3PmoiqHWCUkde3VAq3DoRgOk0kNmIpb9qvto9t2ZJpXP8mby2N+FOwJQR5wAaKZqWSM5bZENLnfApLIyTA+PwTHqoDu2brc2LFWYy0Szb+ToYKPcp2FD1H2K6ljuNzINvN6RyPvQCNkjEePJrIkCAnW
 YTh4rFWm
 vtvZlavgvMcM6QbgqiMCuDj7Xgm7dkmIeusePwe9W0ayEUGCo17iL2eiooHjQSs6XnGSY2JZUaLy690F9QSWdoJCQFOrSbYeXC458ya42C1pKapc2c6Eu4GDoNd5v+mOMOcEsW2cDStqcE4nvcvrp44ivtmzAgimpKjQ2HvPmpt6uNFiqkh0V4+XbKH2XQnNa1r2h0TKynU72TYFx4B2XJV4BIGyWSLA2INHDAlfXMdzxxqodzLxZI3OL81QfDZWD5jTsaNuNomPHLDq40HLdeQk4OObaQmNAYeQ0Nph3ijTiTfcRZVmgr4PPUN/vOV5RyT1RmmzSml5AODIf7/bkuyQV+jAFLYD9frv92m0QyiU03kR/jtQy37xeenKTm+mL3AAcNl5xOspIaLzbNyQbDBNtaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 03:53, Ye Liu wrote:
> The last_migrate_reason field uses -1 as a sentinel value to mean "no
> migration has happened".  Replace the four bare -1 occurrences by
> adding a proper MR_NEVER member to enum migrate_reason, defining a
> corresponding "never_migrated" string in the MIGRATE_REASON trace
> macro, and removing the local MIGRATE_REASON_NONE define.
> 
> No functional change.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  include/linux/migrate_mode.h   | 1 +
>  include/trace/events/migrate.h | 3 ++-
>  mm/page_owner.c                | 8 ++++----
>  3 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/migrate_mode.h b/include/linux/migrate_mode.h
> index 265c4328b36a..05102d4d2490 100644
> --- a/include/linux/migrate_mode.h
> +++ b/include/linux/migrate_mode.h
> @@ -25,6 +25,7 @@ enum migrate_reason {
>  	MR_LONGTERM_PIN,
>  	MR_DEMOTION,
>  	MR_DAMON,
> +	MR_NEVER,		/* page has never been migrated */
>  	MR_TYPES
>  };
>  
> diff --git a/include/trace/events/migrate.h b/include/trace/events/migrate.h
> index cd01dd7b3640..11bc0aa14c7e 100644
> --- a/include/trace/events/migrate.h
> +++ b/include/trace/events/migrate.h
> @@ -23,7 +23,8 @@
>  	EM( MR_CONTIG_RANGE,	"contig_range")			\
>  	EM( MR_LONGTERM_PIN,	"longterm_pin")			\
>  	EM( MR_DEMOTION,	"demotion")			\
> -	EMe(MR_DAMON,		"damon")
> +	EM( MR_DAMON,		"damon")			\
> +	EMe(MR_NEVER,		"never_migrated")
>  
>  /*
>   * First define the enums in the above macros to be exported to userspace
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 342549891a8d..c2f43ab860eb 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -339,7 +339,7 @@ noinline void __set_page_owner(struct page *page, unsigned short order,
>  	depot_stack_handle_t handle;
>  
>  	handle = save_stack(gfp_mask);
> -	__update_page_owner_handle(page, handle, order, gfp_mask, -1,
> +	__update_page_owner_handle(page, handle, order, gfp_mask, MR_NEVER,
>  				   ts_nsec, current->pid, current->tgid,
>  				   current->comm);
>  	inc_stack_record_count(handle, gfp_mask, 1 << order);
> @@ -596,7 +596,7 @@ print_page_owner(char __user *buf, size_t count, unsigned long pfn,
>  	if (ret >= count)
>  		goto err;
>  
> -	if (page_owner->last_migrate_reason != -1) {
> +	if (page_owner->last_migrate_reason != MR_NEVER) {
>  		ret += scnprintf(kbuf + ret, count - ret,
>  			"Page has been migrated, last migrate reason: %s\n",
>  			migrate_reason_names[page_owner->last_migrate_reason]);
> @@ -667,7 +667,7 @@ void __dump_page_owner(const struct page *page)
>  		stack_depot_print(handle);
>  	}
>  
> -	if (page_owner->last_migrate_reason != -1)
> +	if (page_owner->last_migrate_reason != MR_NEVER)
>  		pr_alert("page has been migrated, last migrate reason: %s\n",
>  			migrate_reason_names[page_owner->last_migrate_reason]);
>  	page_ext_put(page_ext);
> @@ -826,7 +826,7 @@ static void init_pages_in_zone(struct zone *zone)
>  
>  			/* Found early allocated page */
>  			__update_page_owner_handle(page, early_handle, 0, 0,
> -						   -1, local_clock(), current->pid,
> +						   MR_NEVER, local_clock(), current->pid,
>  						   current->tgid, current->comm);
>  			count++;
>  ext_put_continue:


