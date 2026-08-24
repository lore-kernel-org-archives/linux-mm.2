Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD972C5DF94
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 08:42:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 695686B0095; Mon, 24 Aug 2026 04:42:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66D4B6B0096; Mon, 24 Aug 2026 04:42:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 583426B0099; Mon, 24 Aug 2026 04:42:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EA4F6B0095
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 04:42:28 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A93040478
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:42:27 +0000 (UTC)
X-FDA: 85135521534.16.5F23215
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8CCC4C0003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:42:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QrzUD3io;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787560945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GGTqSFIdIFnX5ZwL1pucBsR+p2FUQcaSYFkmH0uw2Ps=;
	b=g9xVngxb5qLvLXzUrFiWGx0SR47iDBbAjIxhxc4gqetlTxVY8c2HD+7zDiMSb1W8OmDCES
	QnAG34NRw4vBQr1ot+6zzhyYbe7qCB/zdXGMvmaWj4nwDUNI1xqq/io/PzK6XAQ6NKYtdj
	MrM4aC+NFopnHwbkdkC/Gw9QmRqfgdA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QrzUD3io;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf10.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787560945;
	b=WuCybmlVuvXJYGN+8dQUJM5N9jrvUYlqrtJCgfwtbuov5zTBDesWLTSoX+zCuQz5jVJGGC
	w5UiLw3r6sKm4yCSzw5s1BUG0gwG9rcog9fmF7YscEKgiTGXBx96JyVJ0wWDMFZjsrMqAF
	nj5umie37dSGEpUAS8lWQpOOSdOiNi4=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a422090b2fso4712834a12.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 01:42:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787560944; x=1788165744; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GGTqSFIdIFnX5ZwL1pucBsR+p2FUQcaSYFkmH0uw2Ps=;
        b=QrzUD3ioQpafO40mrOj+VxhDlQAFGbmdPhcPeHhMhnRU9x0OLAnovWvM8+Alf6BS73
         frxSKULlc9dWcXx3JfPm2I9DRrfneCmSbbPTLGpRLeAfS4QK0GpYfkZXInKu6awA4vzq
         wbDWmYpiTwbrfancbWuEJuWmPFIsLp4WaqeLzEWuD2P4cN/2Q7keFl6gn7rYgN7cy2sL
         KtOWQ/2400dIxybv7lXE3NQx3I7BBYH/ZOA7w90xLfUWTz4Lw7GT9El54OjregINUZPY
         AKchxTbWYiVgotbbz2fvwyCzHb9+WEfLu9sM8F5jC1dTcOzyQl+kkRq+oV5675IGC7qK
         32TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787560944; x=1788165744;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GGTqSFIdIFnX5ZwL1pucBsR+p2FUQcaSYFkmH0uw2Ps=;
        b=UVv7CcTbO8Hsmzl4NmLQhmtoIJQ4LY9f/Nzawc5UnNOjUb299GtI9nlrtLV1ttCZZa
         w9UXd/62z1mm8tyA31mbeOqkoz9NX85ZpYWlMqPzfdv24JfExW/9dprYOpnZB8l0q9m0
         pY1jnDdKCOOq7J6mEhtSO/uwLC1F+oLWwFRQpYFPJQ42f0liZQFDRbBlFbXwaKvzM8hD
         +KT7Ycj74PDPan35y5rGtlwpDAJbJXKhy8h2VJIPpVwDb0Km2l5WBWVvsjSmPwAr9ZsJ
         y93jDoXQTqEcCYC9XnBcmFasvDxwVGu21jPMiVCuOY8nJSsuAizZxB7MvB3F+oR42xyo
         5EsQ==
X-Forwarded-Encrypted: i=1; AHgh+RreFXOr90rJvzR8WRftOBhK4EkxniR+nCTyuzAGVnQ2QyhF7+kfTp8uGtICG7n9ima+uur9mOLDqg==@kvack.org
X-Gm-Message-State: AFuF++lU3xefFk55I+XHntQMRYhydf4/6YeKgIaYXbolTBmOMyuJ7OhK
	O6U8mblw6pfWqT07p6kG/s79WxTxJVJIZeXGHn7bFtt/UwUAhmrMXMqfGaGjUpWhgBw=
X-Gm-Gg: AR+sD10UlEnGXUAbxuVxPfcsed+WkA/5KejG5or/Vs/JMvWGsLbV7gw/n1WL+oTXCcS
	1EIkTNMuPnSXVyQUCeQ7QXLj03W2Ue9veirkUSC6SqzaZ6nHmAjxLMGbH86PZiVfGoGA+vGSl5G
	CwZOG+dCrbht/E/ITDgBXOQcHuoXazD6sgSCXBNj2rzPUfSVL2a8pc0x1d6uRixnYDMRewvyaF6
	T/xwyp7pvwwHQZo4i4uNXoGSF5jUYMJZzwrBDisPJCT5eon7Fu0eBPKYJHeD+xUVIYN0bFFsJJe
	5o6bz17Zo/zmn4U/kqJEs/BGcldQytutofBFj29y/RctAN0QVOxJw0BgJMU03Fo4yE71UJtAvAB
	6nNSKTSliw4zaKtuTonmwI+K/R60rpEzHUa+BgPGEIHrZxUtQfboNJxLwZ86GG0n422xsNtmhBT
	JpZicKzmyXvyz5oxjk6bNgv6ZUZXfsDFJOxVxRNBSban+uroR1PhrUUsnNck5DH0rUofHe4D2uC
	w==
X-Received: by 2002:a17:906:2481:b0:c1c:2007:298e with SMTP id a640c23a62f3a-c246b4c5e33mr2142741366b.24.1787560944031;
        Mon, 24 Aug 2026 01:42:24 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24968abf18sm1238314066b.61.2026.08.24.01.42.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 01:42:23 -0700 (PDT)
Date: Mon, 24 Aug 2026 10:42:22 +0200
From: Michal Hocko <mhocko@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aowD7tUUIUbhjJQj@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
 <aogZZsXwCyOXISaw@tiehlicka>
 <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
 <aogwUac-sjfcs7Vi@tiehlicka>
 <dba83897-9bbb-4a44-9021-8f938bb6a12f@linux.dev>
 <aog0ch0u8BtkR-a1@tiehlicka>
 <de7d583e-bd9b-464f-9e28-73075c0211a4@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de7d583e-bd9b-464f-9e28-73075c0211a4@linux.dev>
X-Rspamd-Queue-Id: 8CCC4C0003
X-Stat-Signature: t4wy3b8nkkt9rqquo64571dagmiikoum
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787560945-189037
X-HE-Meta: U2FsdGVkX18nCMVWkmFLzSqvYcJHGe9j09tVgGsaKKqo9P0QxxTXSXEEDt5RCiLOK5J5lhwNeDsFFjyCgkdHkua++896DtnPQwt+RH1KqQLLG/pbo431YOAMZ56IfS31sXofmXqrRGd3yRkS50MZfeQZsaktARlpTZHipR9pKN9OIYOMIJbHoDprLBcA8Cy3ZIkbDx2Yz7aGYrthq7r+G9RtJBNlNlq/DT6Jai9AUU+iyynwfWdJ/GjjqPJoBdTaE3UC2y2jjTO+Ep8n2VlFKcs9+IUbNDjLJO6vthS8HPLea5GwTrH86zOJomAY6g/p2MX3RFe20Mj4fFvN/TUMUWLg3SKjdXadSfQeAM3TWWaYTH2e1j+gSJFM0raKOsYWSBixUumsuIih+keMBtHSiuwRUosbKdH+RlFGafOO2zP1Wa3GKLb+8Oz791Hcm2YWY6WnvgnvnNWBYiq9cNxussq81KGC0AJdPXY3G1lgSQX9cEZbGNyjNz7Ury3+cBzWLhm+ug/7WgakhUgl4PbLM+FsQM6RBisQCV/bjVk1m+indPRGIcZPSKg1DSmZy0ILVcDiRCyfbSH59PV8YgK6j1TUjSFssKSwuwBl5PtgeX1UEFThBFCoh7zRCVm802nnext3lPHVh9j7ti6qw/uO6ppVT4HcfS3EQx9M/6+RAGkx6zwCJjyHUeAEp8nB/w2HDs82vbAl4X9SvRULoDUIiLgM1Nn+VPG4snxWakdEKRKAD5yZYFlhyk10QnVVed/yRGkh5VsLAF8sRYUlrd7XYnWeDs7xv7ndeoe/yaeHCjO4iMrdvIHGSpr924cy8kWYWJQMbUBMMn+ycXB/jOZA9bk6xSymCORi+Xlsqr/mQ5oD9Oggxn61vQGS7fFGixe6eR/WZUQthcWQ+VuRzSnxrH9ifjx8a6Q+blTQ9gXtgQWgxo2d8j7AQTA7rcOp3MCuyK56Fzc4wXG+jBhE1VW
 1SRs5i0W
 ur+8GI9T09YTZDW5d4bJqT/NgKDdMLzmJyCI38kkrTc0Vh84caUVNhu4DD6rurGy4fOsVAi7gzUcHwYJeip9Z5TI03qvUNtXAfYVHQLRqQvxrq6M20zhcLLUX2yAJmBMBa7AmrPerbkdPC14cYEQiapDs86h3QWc+Ar/Q8JJ5mGG62QPewRXMyC7tGGV1B62gNw2WLEce7Q5IFXzBXuXD32co+voHjy0vtrrkIAxD8AOQg6ikVyQqvXI1Fz2YyRTIjcr3Kx/MFUBOgA/jjsZTkUQq6Nu9aV3BL83X6MtQMMSBOUkHhaE75flDfkkV0gMeYUaTANWPU15MyNU2mGUpbeo5jTdEVI410qqwpRr2pbQsaOk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 24-08-26 11:24:46, Ridong Chen wrote:
> 
> 
> On 8/21/2026 7:20 PM, Michal Hocko wrote:
> > On Fri 21-08-26 19:10:45, Ridong Chen wrote:
> > > > > Did you mean that min_slab_pages and min_unmapped_pages should influence
> > > > > proactive per-node reclaim?
> > > > 
> 
> I apologize for being incoherent in my last email, it was after a full day
> of work. What I wanted to say is that min_slab_pages and min_unmapped_pages
> should *not* influence proactive per-node reclaim.
> 
> > > > Nope, exactly opposite
> > > > 
> > > 
> > > I would really appreciate it if you could clarify this further. Sorry, I'm
> > > not sure I fully understand what you meant.
> > 
> > pro-active (userspace triggered) node reclaim should completely ignore
> > all those historical node_reclaim tunables.
> 
> Yeah, this matches my understanding. Apologies again for the confusing reply.
> 
> Since Johannes has acked patch 3, perhaps we can simply remove the
> conditional check in __node_reclaim and keep the shrink loop as follows:
> 
> ```
> @@ -7906,16 +7906,16 @@ static unsigned long __node_reclaim(struct
> pglist_data *pgdat,
>  	noreclaim_flag = memalloc_noreclaim_save();
>  	set_task_reclaim_state(p, &sc->reclaim_state);
> 
> -	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
> -	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
> -		/*
> -		 * Free memory by calling shrink node with increasing
> -		 * priorities until we have enough memory freed.
> -		 */
> -		do {
> -			shrink_node(pgdat, sc);
> -		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
> -	}
> +	/*
> +	 * Free memory by calling shrink node with increasing
> +	 * priorities until we have enough memory freed.
> +	 *
> +	 * What to reclaim is gated per type by sc->skip_slab_reclaim and
> +	 * sc->skip_file_reclaim.
> +	 */
> +	do {
> +		shrink_node(pgdat, sc);
> +	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
> 
>  	set_task_reclaim_state(p, NULL);
>  	memalloc_noreclaim_restore(noreclaim_flag);

Could you post a stand alone patch with the full description please?
-- 
Michal Hocko
SUSE Labs

