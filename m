Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD912EE368C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 14:45:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50DAF6B008A; Thu, 12 Feb 2026 09:45:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C4596B008C; Thu, 12 Feb 2026 09:45:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39E006B0092; Thu, 12 Feb 2026 09:45:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD786B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 09:45:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C647FC09D8
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:45:39 +0000 (UTC)
X-FDA: 84436078398.26.9707806
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9367DC0011
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 14:45:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YUwmYWU9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IFwzuFnU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YUwmYWU9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IFwzuFnU;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770907537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8yWiZpt7mAXel9iraTjJZeMPphqi5GEr73S5STPQUnI=;
	b=LRaWkXL5lSaAXSsAFlDnMp6IXgYq3R5Ue5fzWQD2WFloCjcf6gUys8Hwsw9itlWfnYLzwL
	ZVgwLt7FvM6th+ss7DJa0xgVcRSLMKVdtyjClktL/KvwMirMe07X+o+tCPKeIVXNyfO5TT
	+3OcCeC4OcD5u2KiGFtrI8ZDiJSOp90=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YUwmYWU9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IFwzuFnU;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=YUwmYWU9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=IFwzuFnU;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770907537; a=rsa-sha256;
	cv=none;
	b=VCTsXV/YQO3asPly3QZNmOeD537ikXr2hGtNwrZCIRSC+MMgqn50zpOiFCQrteeDuFbeRh
	QtEvA10laoh13DgXCS8W6UcPopJv9dkgdyp7aSMtB33ZJ/ROpSn+mExpDgeGwe0YpW+mM+
	Y2FJJAHi6R+YTc3p3RssVLI+py/TZNY=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 02AF75BDB0;
	Thu, 12 Feb 2026 14:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770907536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yWiZpt7mAXel9iraTjJZeMPphqi5GEr73S5STPQUnI=;
	b=YUwmYWU9F4fICSa46OJide6CARfC1w0n4TwK5ZaZPXm5lf1q+GAjfytoTW5tDpVGjV/nPN
	pZtEgFtdGv2UlcFD7fLjV+L8SAWFLX1JBf3hbAGgBG2weMTZuKZFczGxG74RqDrYX+yjUB
	Txg1sKfRtJzC2vbpIkMgLW6eUHTkI/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770907536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yWiZpt7mAXel9iraTjJZeMPphqi5GEr73S5STPQUnI=;
	b=IFwzuFnUzczquIrFMN3nNqwBahn+0alV7b2nS8L4viHyycTpZy9wUR5JEN8DuxC5gTKUpB
	WghJZeheGkW+5gCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1770907536; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yWiZpt7mAXel9iraTjJZeMPphqi5GEr73S5STPQUnI=;
	b=YUwmYWU9F4fICSa46OJide6CARfC1w0n4TwK5ZaZPXm5lf1q+GAjfytoTW5tDpVGjV/nPN
	pZtEgFtdGv2UlcFD7fLjV+L8SAWFLX1JBf3hbAGgBG2weMTZuKZFczGxG74RqDrYX+yjUB
	Txg1sKfRtJzC2vbpIkMgLW6eUHTkI/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1770907536;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8yWiZpt7mAXel9iraTjJZeMPphqi5GEr73S5STPQUnI=;
	b=IFwzuFnUzczquIrFMN3nNqwBahn+0alV7b2nS8L4viHyycTpZy9wUR5JEN8DuxC5gTKUpB
	WghJZeheGkW+5gCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A41B73EA62;
	Thu, 12 Feb 2026 14:45:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id i83MJIznjWl2TAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 12 Feb 2026 14:45:32 +0000
Date: Thu, 12 Feb 2026 14:45:30 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Nico Pache <npache@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, matthew.brost@intel.com, 
	mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, 
	shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com, 
	thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, 
	vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v1 3/5] mm/khugepaged: define
 COLLAPSE_MAX_PTES_LIMIT as HPAGE_PMD_NR - 1
Message-ID: <mluzy3dphgcmus37y5bdjg5prky3itn2ed7mwniycvnmjf7rn7@iszswich6mls>
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-4-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212021835.17755-4-npache@redhat.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: ttd16pf7nz8kpibxhqxi5mbgt6tbwhai
X-Rspamd-Queue-Id: 9367DC0011
X-Rspam-User: 
X-HE-Tag: 1770907537-627946
X-HE-Meta: U2FsdGVkX19tk27rlxtrBfCXLfAms4IoBxXu8PrQ35wdnUBfuNjVQ7X/fQ/Ls88bWq6C95yp1fZDy4w+6yYhe7sH1yS3ZSFYBuCxOFLxZ0aUUVo/SqMCN57ga3fBKN6lxeH4GlwtV58DpUWP0yXXp2znM4OQMjDYA4f0wy8BzhPkWc3XuH3E7ve0Lixy2APSxN8G3sRG7JjdIl/CrayTsQ2855PI1TY8G0eXP/3Mqrij9lRpRhYYufqtPOgL8at16wI0IXkBjjkyDEe2ydOAH7CCaEeODq6C004qxIyt4BeE4e4qTGVgjfA7hIaPxImpLF/RMS3ASJbAqBzWJDIqgCASnHJAEaQL1D0Q4j4zDqQme15xffvqpmZxqkrICiG+D0F+5pUI2uCTTMFs4KXww3HgM4RwzsW/EMezxsDVX4FkqG9QloF1Z+7Z5Gf3C6srKcE0UgfFPIaWQnJaYK3Hs3HV1a/z4r34nL9vFA3BqHcQnIuFEIH9cD7illt/fF9Xfi3oTM/jr6gGlXkGN8nmquddGoJ3QgUoPeNEAVK3L+Z7uXF22pUA+LynhHawA/RyW34x3hiabgR/qR+53IhKnRY6ECXaCYYq0cmC/6zuND8yne4469yMMCnYlJB938KFIcAoKp/xMo1cPn1L0xbgnYmly+NigzDnt2QqixHyj9qiko6MYBreKBmp8NrsIpraTAtyeYU7YXydVd01lXrmUmu0HuTjks/3b5q5zhUWLt27VMt3p3tR2crjkBNuzQPInNKQu9VBGaEvDLe1s5B3gORiGlzEW8i8Hv8VSLwOvy2gK84KgzINvLPMui7GRe+ODtqtqVbT/1sdNKQRFORCDRw+UBBvBsQr0XMjU5/WggdhTBvAQQwGYIR2YxAZyhXA9isUDu6jLjsyBZkEYy8Cqo1/wjvoqiPIDvlVjP0cqgwQkhTqEDODMWTZvVrDfhcKbDce59ezWY1kc3jjuIv
 /MZSUEFp
 Q5mzmZmBw2ytuZRR6IImm4ZjlZZjl22OBNoNxF/SXlxcxg8xuWeTOs/SR+cF/+emdHE2B8s4LgDfE7pMw8b5RHV4UaXlhOKFJD+ug4+hVJoXkHr35yjuUMO844EtDCngBgJklhf3/vw5aYNUgw4mKON8mDQcOknq6ryLGvItgkitInWU98+lQiI3C+iPHOGfqoY8GhnsXNEh6o8f4rd+cCVEAD1sRYSGn0mV+wMwZyCFu6kVQSgzT2Q1al58OcWWupPfj3qYQvanR4YhWmwRCav5aoYh3R5tobE+pQp8eS3ALQYhyekCxBHQgVZrnPODVnvn82/My6oRm0sUTat6KhFxJhMDwBqsI4pFyGxHtPWe4D82lkV+aruiLiXDrCkilNNYOiX75ZL7TR+xsIc2AlxpS/fk4HRhT3HxTgd8aI0AnvohqgSEL1O4WXPkpaek0NSZE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 07:18:33PM -0700, Nico Pache wrote:
> The value (HPAGE_PMD_NR - 1) is used often in the khugepaged code to
> signify the limit of the max_ptes_* values. Add a define for this to
> increase code readability and reuse.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>

Acked-by: Pedro Falcato <pfalcato@suse.de>

> ---
>  mm/khugepaged.c | 15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index c362b3b2e08a..3dcce6018f20 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -85,6 +85,7 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
>   *
>   * Note that these are only respected if collapse was initiated by khugepaged.
>   */
> +#define COLLAPSE_MAX_PTES_LIMIT (HPAGE_PMD_NR - 1)
>  unsigned int khugepaged_max_ptes_none __read_mostly;
>  static unsigned int khugepaged_max_ptes_swap __read_mostly;
>  static unsigned int khugepaged_max_ptes_shared __read_mostly;
> @@ -252,7 +253,7 @@ static ssize_t max_ptes_none_store(struct kobject *kobj,
>  	unsigned long max_ptes_none;
>  
>  	err = kstrtoul(buf, 10, &max_ptes_none);
> -	if (err || max_ptes_none > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_none > COLLAPSE_MAX_PTES_LIMIT)
>  		return -EINVAL;
>  
>  	khugepaged_max_ptes_none = max_ptes_none;
> @@ -277,7 +278,7 @@ static ssize_t max_ptes_swap_store(struct kobject *kobj,
>  	unsigned long max_ptes_swap;
>  
>  	err  = kstrtoul(buf, 10, &max_ptes_swap);
> -	if (err || max_ptes_swap > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_swap > COLLAPSE_MAX_PTES_LIMIT)
>  		return -EINVAL;
>  
>  	khugepaged_max_ptes_swap = max_ptes_swap;
> @@ -303,7 +304,7 @@ static ssize_t max_ptes_shared_store(struct kobject *kobj,
>  	unsigned long max_ptes_shared;
>  
>  	err  = kstrtoul(buf, 10, &max_ptes_shared);
> -	if (err || max_ptes_shared > HPAGE_PMD_NR - 1)
> +	if (err || max_ptes_shared > COLLAPSE_MAX_PTES_LIMIT)
>  		return -EINVAL;
>  
>  	khugepaged_max_ptes_shared = max_ptes_shared;
> @@ -384,7 +385,7 @@ int __init khugepaged_init(void)
>  		return -ENOMEM;
>  
>  	khugepaged_pages_to_scan = HPAGE_PMD_NR * 8;
> -	khugepaged_max_ptes_none = HPAGE_PMD_NR - 1;
> +	khugepaged_max_ptes_none = COLLAPSE_MAX_PTES_LIMIT;
>  	khugepaged_max_ptes_swap = HPAGE_PMD_NR / 8;
>  	khugepaged_max_ptes_shared = HPAGE_PMD_NR / 2;
>  
> @@ -1869,7 +1870,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	bool is_shmem = shmem_file(file);
>  
>  	VM_BUG_ON(!IS_ENABLED(CONFIG_READ_ONLY_THP_FOR_FS) && !is_shmem);
> -	VM_BUG_ON(start & (HPAGE_PMD_NR - 1));
> +	VM_BUG_ON(start & (COLLAPSE_MAX_PTES_LIMIT));

nit: no need for the () around COLLAPSE_MAX_PTES_LIMIT here

-- 
Pedro

