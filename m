Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28151F53D81
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 18:18:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80EDD6B033A; Mon, 16 Mar 2026 14:18:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FA4D6B033C; Mon, 16 Mar 2026 14:18:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7105F6B033D; Mon, 16 Mar 2026 14:18:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E97E6B033A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 14:18:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0C8E01C464
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:18:43 +0000 (UTC)
X-FDA: 84552736926.02.BA2C7B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4C658C0007
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 18:18:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZO8LSCe3;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773685121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdsFxZKqVklhMCc2ezVa0B23c9GGYqlzYvJOca5zp+4=;
	b=JFBpPT8MxflOpJM1Iqdd67U/5KZUnaCA3B7b9DmUMKc0NEjVHqCOOPX/clC0XeNqmbh21C
	nPwRAmnkm0/vHbxA1gvRWvXeD8pJnhuPDEFQZgKHzhQOGGI/WPQGIgRp7fVBK3rTrGIsF4
	igNgH8bPHGLucsgpBepPHkxxpY3ippE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773685121; a=rsa-sha256;
	cv=none;
	b=RBKxCmz3yGC9BavSIQYOpKYO7ZyKXWWSkB+JyMtuAjpfzL5Wyrit2oXDagKa8A/61PjN31
	Yzkj5sisq2QQxlvaX4C9ws5OuuAtmbU9l4ivTXyMffnFNpueYvDmWuDb91p29bRvDMFaqZ
	djqLBaRgPFqOq0XvyhZz/Ruu8/jf18o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZO8LSCe3;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 070B840AF3;
	Mon, 16 Mar 2026 18:18:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E254C19421;
	Mon, 16 Mar 2026 18:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773685119;
	bh=MMg0evIPGaTN/2UdyQI4UEe3CJoma3zLEV+L9ukhSjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZO8LSCe3Yfj91WA6DeilqxeaBn/768zT8gNpM2Ujdf8Li0pDTmXUqaUAWELebibXA
	 RHN91Dx7+UL81itDRTW3safhSpvaeK49P1IljPCkfZprMN390o5xjL30tcu5lTPb1m
	 Ubumwud3YWR8uzBg8REs6DKjdmI34T4NI8el7tiQo9YsjCYI1Cot8zuUtK6rRaGu2t
	 woUltCaoM6x+1tf96rWz9Ed9X8cmgkrSckZ74IL8NiN3qT/fsW52eSCaxQdSpAONt8
	 hNWVv2iU3g04//bsoK2+33NcNmHPwbQNRSaw9P0qeEvbp5+7UoEBAzJ+exg/fpFPlQ
	 YA/BRNF10sxgg==
Date: Mon, 16 Mar 2026 18:18:38 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, 
	rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org, 
	richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v3 3/5] mm/khugepaged: define
 KHUGEPAGED_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Message-ID: <aa7a855c-88b6-44a6-a470-e1ca410057ec@lucifer.local>
References: <20260311211315.450947-1-npache@redhat.com>
 <20260311211315.450947-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260311211315.450947-4-npache@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4C658C0007
X-Stat-Signature: uqw67okj5dfkxzh957kqremonkefkn33
X-HE-Tag: 1773685121-824688
X-HE-Meta: U2FsdGVkX1/efglMNZHsu498CNYCo9OKQIfqHNkrCM8K3QjF9UoMGfEmuYLOxWrIarQz8hHRxkvNGl1qB2YztYko0k9IiYlPMMSw8xV98+qxXfyPoRSuQdyhfOOypQ1/8g2G/Q/0YXnEWVbrPNtqLRJPW9yjiBWfcsul5uyiAkt9pUZ10dZFblf+CRv+vOrtXez4Dh8wsVdhJijFu4nIGqdJ3Ha8rM8Xuc3yHXumXarMfTJ+FJU052QK4/+yYmMUPPnDZkdB4zzjloxFwPpu/uLIiDjtbQyOtph6YKbC6DKT/CkKHKkceXAu5nap4qZLmucw4JWZcm9+FkvDN7Zxkf1ZGwOWbiS68sQs+Uyc2i4qIT4ta8nFlhYWgmWyOKrVPnFlkDhUEJ37vNQawQrSfvmlFSj1xvU6BCLbODEz75D6HCD+I44RceR9/dTcAv70bPVyDtQ1cAJ8j1fT/bLpEvMCPdHQN9rtyfXeTEQSbAjw/7a5zkTT/TvKQh2lfE2MvG4K6IvTDgSmH5CnhXYHMiJydT/lNreJGl7qI0YOsPxrSbaITrR9Hm2dTFIBCoCI2Rc5GGzqXFT8s9MmUTWVWWCDpgFpZjFHilIgROfbwfJSuU2BOh95iIpitGJ0TQAzKXzkTVpNex27Nt/RvSiMb9kElRUXFvhKqnEcp3xlt+cgK2XQopcpBjvR8gGgBKjPAQXn6ttnpBqFfOX3/5Patvj06/wFpUJ8HstXr/5Ggbma4G+vdxoR7Rityy8IZd9XvvUo3G3WJKo9fCDCZSF4PXDecttRoawfva3V4teca8NOeMzoCCsBE+FEVl6zMTYtgD2MjFmCaPipuzNZ/imz2FJ4EWt9Kwk6V9UOjxO/HQ/0v2X9NvWbnu6F+835i+xMRDkz4LYbN8C5cwzjDj1QAHsaW1CbiqRloDQRii33lMG4LB6ewf5rQrwacjGJleM5SHEy/xcLJYCJBAkRBOE
 +AitJttR
 YzBHFJRuL+gG0zmVZKnxKGYAS7Hj9c1fGPy1wv+2xjhNbC3l71QiWVC2h8FjPuXMTYej/QcloK7BQpqzqbolJZecANBoq11CjYNj2M6fOfMOvdScKyT6UJiLewKIf0bnHLtYd0gZRmBUfoRi6iYoYM8QCkm5t7u+QIqIdzQP9rElkgVtSWePkr4VcF7VTnVC7WeR/bA9hWZzvbQP5fHrLfE624WKxKpLGUPAEdaBH9FOHZUMluc1PBIythRRb9Z7jvlPdURLhN1+CczOgp3kf1JyB9l/J4qJVtAySgRvWbkxiLcdHbAWp7y15S6N/vdSXzFEfTFfvsH4/56bbwWfzjFzES6odZA/n+DywxWKtk+DQfMPIvZne8YFyunXptEojEzV5zq2AcCRDQmz/jRV866kOoc8ARDlRpCyPwT9WQLnoslg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 11, 2026 at 03:13:13PM -0600, Nico Pache wrote:
> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Nico Pache <npache@redhat.com>

Hm didn't I suggest this? Or actually I can't remember :P

Anyway LGTM, so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d3bdec4ec61b..db77ab5b315e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -89,6 +89,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>   *
>   * Note that these are only respected if collapse was initiated by khugepaged.
>   */
> +#define KHUGEPAGED_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>  unsigned int khugepaged_max_ptes_none __read_mostly;
>  static unsigned int khugepaged_max_ptes_swap __read_mostly;
>  static unsigned int khugepaged_max_ptes_shared __read_mostly;
> @@ -259,7 +260,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
>  	unsigned long max_ptes_none;
>
>  	err = kstrtoul(buf, 10, &max_ptes_none);
> -	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_none > KHUGEPAGED_MAX_PTES_LIMIT)
>  		return -EINVAL;
>
>  	khugepaged_max_ptes_none = max_ptes_none;
> @@ -284,7 +285,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
>  	unsigned long max_ptes_swap;
>
>  	err  = kstrtoul(buf, 10, &max_ptes_swap);
> -	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_swap > KHUGEPAGED_MAX_PTES_LIMIT)
>  		return -EINVAL;
>
>  	khugepaged_max_ptes_swap = max_ptes_swap;
> @@ -310,7 +311,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
>  	unsigned long max_ptes_shared;
>
>  	err  = kstrtoul(buf, 10, &max_ptes_shared);
> -	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_shared > KHUGEPAGED_MAX_PTES_LIMIT)
>  		return -EINVAL;
>
>  	khugepaged_max_ptes_shared = max_ptes_shared;
> @@ -382,7 +383,7 @@ int __init khugepaged_init(void)
>  		return -ENOMEM;
>
>  	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
> -	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
> +	khugepaged_max_ptes_none = KHUGEPAGED_MAX_PTES_LIMIT;
>  	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
>  	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
>
> --
> 2.53.0
>

