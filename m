Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE3EC2A072
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 09:17:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C33F6B010A; Mon,  5 Jan 2026 04:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86DB86B010B; Mon,  5 Jan 2026 04:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B13A6B010C; Mon,  5 Jan 2026 04:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 63ED16B010A
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 04:17:36 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 658E5589D8
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:17:35 +0000 (UTC)
X-FDA: 84297357270.01.352BDD2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id A6052140002
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 09:17:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767604653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RhLP5B31GVWHlt/ivM1nj7dcXJt80hzBYMukEHbJkSs=;
	b=4dzjrTRvI/MCg7UtEUjN7Iia7x3ncphmrkYwVTul4OGoEjS2nxHFE+Esuvd/A/cHnQ/SM2
	/83euodnnX+ZUT2hNQJtTPw+9kpMVlIlp+KAY1oAB4/HhmM/c1cwW7Gx6RpqRfarzuZgf1
	27LqixIttG05/rxBwgA3b9aVKjoXpsg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767604653; a=rsa-sha256;
	cv=none;
	b=73jt8jzEDSMpBoW9jlMG8UNlJIPH0eAy+s0assZr2rGsFnxaGgZkaa9HLEUtbH5Ffb8P4f
	KPQdfQWj61U2v2FyBE6ei5ZvqWfdiVeOwPS+nohSfO2J9qoXLU5v3890b7ZPO7tfjG0VaM
	faqXp5PrP2cX6gwZizx55MvQRSkQM7M=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A8548497;
	Mon,  5 Jan 2026 01:17:25 -0800 (PST)
Received: from [10.163.86.15] (unknown [10.163.86.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EE64D3F5A1;
	Mon,  5 Jan 2026 01:17:28 -0800 (PST)
Message-ID: <0bf0cdf0-2518-42ac-ae82-9c9c1c8fc2c7@arm.com>
Date: Mon, 5 Jan 2026 14:47:24 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: remove unused function inc_node_state()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Cc: linux-mm@kvack.org
References: <20251225015445.16727-1-richard.weiyang@gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20251225015445.16727-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6052140002
X-Stat-Signature: pskm714bn9tzzmsg1axtxx1mo5z71uyq
X-Rspam-User: 
X-HE-Tag: 1767604653-92946
X-HE-Meta: U2FsdGVkX18hqPC1ujW2Q9e+dkukNXf58JkN16/SdO5xmJue9oJB1sqjUy7Q4XCnoJmduspj4LcGCnhy603JAzowCGp4C4hi7HakJ6kpu0hVLIrkKINxigcgKInmrKigmiaBfSlKIBhkme7nppcZpkGDPz8pmw3x1F6OvpIEujQCegXQIjaL5C2ps9sD6J30R8D3AP8hpyN1X57eYXbRfCD1KYq6raHm4y5Tc4laojUPAILnQ540qVvtlw8D3adHje29rXUcU95baTEe+mLwTDsd9Hb7IdzVPf2FeDEsEQhOfxFb3OiP9tWfWaCy1uawBzZl0gmSO/LHAGOz++rnzPweFeV826rbWDgPf5t1P941qufVUDeXF1sj+ZHuWEDa5bgj6vNwpsZnRlpgOd+ANYfJpqb4fdQkUxbw+T1Wv1Bll0Qkjxxpad/Y7Z21cI2U06/ufMk5eqWSY1OmtwEQX07oqPNmr63JYWYlWgcc1mBFwlsRJePpOz9WeUIX7UohHBjuxmu2D592+7WsoJc+WFn2JjZQPdA1p7k8NGA3WO4Q+Ap+Q1mCk7FN0WXVkZW1JdN0N18CNGJAfGKhlLUHhkwGr/R6wh5jaJJL0y1TPiVgKsfNFJcT2bC9atmaEtqrKJc729sWXQq/2eACIyWaUBAXBWVKjtWWw3OgJYNGj6uU4RF3LVn03qTdtk4bu+E7Y51/vMt0RLRPqmd2ewLIwJeOJ4mxBNL9ijSc9k1zUlfV0K2v0AOSIFPVENwyOUA9UwFjSa5GAJx3NrYrI0kr9BoEaSBY7FW/8r4RDhl3IHU8rbYWmgWxRpGrQM0teDOfPFKvrTCuUWwul3qEL3UvacOJiyB7VGDwN7AI9+Gu769CZjflQY1KrIw9k2tbukkW8zH6VrXlTX14SmjsCoatgMRAzBr4f0MrDhs8OE3WKLXc+RHSizqpden8XOsUzG5CPNxNqDhNe04y65YE6RE
 +FQj8bIF
 COB0MpCWiA7eNAqO41rg5dN41s8OdCWEAb7mPLsrsuZgtqifoCHyrf25ohcWEGXa5SY3G9nZYeoVe0qqKW0/YLEUHeGWyvkoVqcMsrULMGxQzKidhjKPevaz4QxRrw2jbxZwXmEP7yiQR15w4wwtQF9oZiisYtVKp/QQdUzSmtiMcMZ1xBmj357dyMGfDLzeAGsL0txlXWY6L+UWtaP0kcnZDGDLR6VlwotJ0Nuf29jwUjkj7/zNZfcniTZdgzdPb/Dq0/cQaYfptK9FOc2E+9n87cdTjmIstAkbADcXV8aoVPlvpRP9ADIgKpStZmUTWQs0BV7s20IjjZPYd1/HgeEjw9eXO5CkA3TquOHkHK+6UbHcJNcPWPyIlOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 25/12/25 7:24 AM, Wei Yang wrote:
> The function inc_node_state() is no longer utilized by any part of the
> kernel.
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>  include/linux/vmstat.h |  2 --
>  mm/vmstat.c            | 15 ---------------
>  2 files changed, 17 deletions(-)
> 
> diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> index 3398a345bda8..864a78287371 100644
> --- a/include/linux/vmstat.h
> +++ b/include/linux/vmstat.h
> @@ -286,7 +286,6 @@ void mod_node_page_state(struct pglist_data *, enum node_stat_item, long);
>  void inc_node_page_state(struct page *, enum node_stat_item);
>  void dec_node_page_state(struct page *, enum node_stat_item);
>  
> -extern void inc_node_state(struct pglist_data *, enum node_stat_item);
>  extern void __inc_zone_state(struct zone *, enum zone_stat_item);
>  extern void __inc_node_state(struct pglist_data *, enum node_stat_item);
>  extern void dec_zone_state(struct zone *, enum zone_stat_item);
> @@ -395,7 +394,6 @@ static inline void __dec_node_page_state(struct page *page,
>  #define mod_node_page_state __mod_node_page_state
>  
>  #define inc_zone_state __inc_zone_state
> -#define inc_node_state __inc_node_state
>  #define dec_zone_state __dec_zone_state
>  
>  #define set_pgdat_percpu_threshold(pgdat, callback) { }
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index 090b5c5294b9..16b7cb24d411 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -671,11 +671,6 @@ void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  }
>  EXPORT_SYMBOL(mod_node_page_state);
>  
> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
> -{
> -	mod_node_state(pgdat, item, 1, 1);
> -}
> -
>  void inc_node_page_state(struct page *page, enum node_stat_item item)
>  {
>  	mod_node_state(page_pgdat(page), item, 1, 1);
> @@ -724,16 +719,6 @@ void dec_zone_page_state(struct page *page, enum zone_stat_item item)
>  }
>  EXPORT_SYMBOL(dec_zone_page_state);
>  
> -void inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
> -{
> -	unsigned long flags;
> -
> -	local_irq_save(flags);
> -	__inc_node_state(pgdat, item);
> -	local_irq_restore(flags);
> -}
> -EXPORT_SYMBOL(inc_node_state);
> -
>  void mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
>  					long delta)
>  {

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>


