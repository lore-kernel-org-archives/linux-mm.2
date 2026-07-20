Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A1A1C44528
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 09:12:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98E16B008C; Mon, 20 Jul 2026 05:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49F06B0093; Mon, 20 Jul 2026 05:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D39266B0092; Mon, 20 Jul 2026 05:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA6C16B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 05:12:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38735406F3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:12:06 +0000 (UTC)
X-FDA: 85008588252.15.D67E073
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6282A10000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 09:12:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HqP/Bwb+";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784538724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bIMIMnD9F07/WlLx80PJuXQoWwWGI+wP42qXxuV/w+E=;
	b=5u0hclYPUS/4wk4yN+60gVaOWvwU/4fL986FjYmP30ZLzwhlf4+IM1CLnR+h+M8EO761jk
	E+H651XQEw0y3ZQFiuL9DojmP7/s1WNSBYJymyFs2njRD75XGcFFkX9rPJ5Lwx5kugNGij
	SBoMUifx6B41XsjKUxbdZAiNAZ8fvgU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="HqP/Bwb+";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784538724;
	b=yVZzCkwsas+BuBWUVrRLQnsaC1Y01m6KyAISHNYnXx4BQaHd/lJIL3IRsUHpox277UysSr
	mBgVYNfeljXI5nWgOt0cZlMe67SUGpiZIMtpJ/QsWFR+ZMdWhf1lu4K0ZpYxFqypsouIjw
	Pgl+gdxbpbXS8qJSCTjHFtlR/J6Qe2w=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ca64c3ce5fso111253635ad.3
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:12:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784538723; x=1785143523; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bIMIMnD9F07/WlLx80PJuXQoWwWGI+wP42qXxuV/w+E=;
        b=HqP/Bwb+G6mI19PzkcsiSE+5uXCihh5GAzXbAaR7R1shanCzluZs1WcQMKdziuTdOC
         m0nGZmDVjrC0kAk2ZkrwG0E8mxRnEUa20pNoBjDgqS6ASQSIiK2BMz7nozYqwyCOoH0a
         q4SlzhjtYGZTuYK03UMuxf/h67fIUH8ZDfWs5LfBX/lXjnEM9RvvhyeRJNJ1Vm/evMs+
         i8rgskUgH5zyGy5i3tSTRoVzDCUmVZIhETRqal/OB1E+4bbpX6YLMCEG0aoWTwk7fW4v
         kxfHJU5BqmMz3uL3jmNmukoFDIk+sL1muKbUXWXsSKrIctDcnb6iPxVXwfWgXNHk7R3p
         smFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784538723; x=1785143523;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bIMIMnD9F07/WlLx80PJuXQoWwWGI+wP42qXxuV/w+E=;
        b=KvbH2MYRE4OehjFMSVLoYKmexy5XVrLpuR+dQwZwRlZh2QA/TGJMRNCBvMvVk6C2ZA
         GQXVg/c0XjBKKSpUdOzezBZpYIAy4oeEtxEyLKNv9Iv9ewZ8c667B7BxYvXJbX4ZcikL
         LVpdP6BjksYO85JgxXeL94vfPGNfzbn3uI2PnDzNk0QGwsOf1ar+yxWYEL/60GoMGApE
         G2hFB6gb3u/rUaNStfE5DHO3q8v0JtT0hMO4TvH1g6pP57+nRvSXQgbitRi4xz9WncYf
         upLDCYgHfn/QH5+hzdrnJ6A6IN21F9jRQYFXY7Kx1Q/78N4byNm3qQNscmVu4ZCM/Y+3
         HAow==
X-Forwarded-Encrypted: i=1; AHgh+Rp7/7nmJBrlQJzI+MiBupucBtZ6jFuaSlyZ8kRxZIibGikAfz8gVaG1V4/Yg8nA/hcUCmlKqiN5lA==@kvack.org
X-Gm-Message-State: AOJu0YyhsDfrMhv9VIuIT3qwAYK7gap4RxH6G8914czAxtYmzPfCQfQ6
	L25DGIwbw+zHADCLFKGltOl+644SbVdu4J424NF2fCs8AslxLJRoZdCV
X-Gm-Gg: AfdE7clCXJSQLLg5jQq6Klb0whMu4TDc6aRNNt5UMsXejxymcBM0oXUM+eOUgu62e/5
	10QBTQwzTzsN1vmoDmEyxHQRWbgcruKfCB1n2upYtk5vS6QU5O7xLexgl2ywkDNBTnmbRHAXhAM
	8J0CUeTmluuTPjhC9fbG0waL5kkz8AOoEAhHEOhnqAaK29gmgQK5p9Q62r5WQLHud3q9OtfDnRo
	196cHgK/UPNOIt4HylTCqeANpz8VcJXVNuj0JRugx2xw6bV2GdZM4rpo2wnFP+UwmN+uzWHa4Ia
	R6xCrsssFYIVlQP9rFORC3ZcEEoMymMn295heAK6PMH/7Is92KQ85lgUjAEcAdWMKKOIJrGnk3Y
	8ZAO9aiR7/Ybh+EpC63AAOjOW9fvPBuZQ4wbVXeBYRCWvoDCGKIuEjmZ/tVlBUFv2nubSMMsHiT
	eMMJjMjTwqHjXkAlQAfJ6pci+q+3eR1L8rJ0qiSsrBJuf5meU=
X-Received: by 2002:a05:6a21:4c0c:b0:3c3:9cf4:a982 with SMTP id adf61e73a8af0-3c3ad8ecbbfmr13496010637.37.1784538723072;
        Mon, 20 Jul 2026 02:12:03 -0700 (PDT)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb51a1cb3ecsm4625716a12.29.2026.07.20.02.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:12:02 -0700 (PDT)
Date: Mon, 20 Jul 2026 17:11:58 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: Fix potential NULL dereference when trying
 a sleep table allocation
Message-ID: <al3WqZ45Tapey-eB@KASONG-MC4>
References: <20260720071342.50742-1-shikemeng@huaweicloud.com>
 <20260720071342.50742-2-shikemeng@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260720071342.50742-2-shikemeng@huaweicloud.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6282A10000B
X-Stat-Signature: ay4hurofoa5mxqprmcocarc7t9ugj99w
X-HE-Tag: 1784538724-318330
X-HE-Meta: U2FsdGVkX1+KGI22xHoAtjN0DgQc70ZSw+Aaqdvtt71HIwrooSyxA3CTiEZ+X8LQ6wqxX7vwQymwJegNYIEtwnYOKYWrlYQ192r867qdHsgLkOPSRhLpV4g4IrOLTQuC7OnX38jXg1sskCCsGosp4wZURXZwYrpLzXE2HUoABSI6RkLL51V7XZ7KzEobuwOWJcSBIWG+Ucx3UFSuTWo1k6RgfypKbDmL+O8qss5qgT4kPB6yY0X6XfuGlzOfJVlxHJoLfzAh4GtlXwBaT6nleNrrLoNnlFq5xLh/1BZlhuUWNerxwr7YHr6aPIDL/u8/lXWR08IZYtZhbNvjpYNM0VmOs2j2djeaNufVn3XaFpZxGzoSGnMmp1BXt1HBvLIfl6faUDuk0jW4rN+l8BfM2s3Q4qIOsIkznmchaLGe6AmcZwGWrR0j8AsK6ZOTFdHzJnO1c3CyrH67vmqTBUQE0mXdNc5gYD4WEDa1RshspC4m/4puOlWm2vI6bsPQqlxkxm0mbbWDiSdkoDhxg7FKecCT6QVzhSwyTRRDuDxqJ6QALPvxvwjKmlGMvMYdjGpYbbDmF28ZPFOjZ8R2DWclya6Lm/asyhMjKTk9wz4VtZeH3D14deex5MEcA2elYoNV9fx6mjEmwQarlitwNNwAgaPFIsRp0SKOkVFLykrfDN2YjT/bFOznfIEz0Vmurner1z4p8g5QnYjtX7821WzibVGowmUflHcJTWu/hYdtPHT1NoMVfWufSSh0BGO4kmfIxyr4ujMXHbi2bbJe2ee17PzO31dCLego1Pg1PNAZbFcverE+VKgG0pnXGLLkX81kDgl2pm0uB1fL2p2ADxPxu9TXhMQMRNLNml7D2UBPdjrctktXa8yQDlPr5Qg+ss+e7OLPLxPT1NvWKE1UCTRF+J4tv2jMoc5aq+IuyI4JlWmgV8BU0O1bBfDqlcCkAOC8R+AeStgX53MlcNa2SsR
 Kj3XG+wR
 SBl8u5JT9zWxin/wuNy4tOcFelFi/N5mbJt6c376m3y6ILlNuuTRkJ06k69HYIoPTTw2XzXgTL/AiPcpNswHmVXUQNNMK53fWDLyF1hjtHTSZNyfeIWEFUrLvu9KjQzCz4S7pt9NkbQsak9Km8DD16E3t9U+I7URzL2RhEodQEGrWeIA8TMkMQDYpZhuz9dRnd9W/rZlB5P5RO8w/k3q/cawTDsgKkLBZ1NAq8tlErgZbsuD1Sv7q0XmNkzW265StD8WlQ7/wnfRdON8CPsLV4QadHfAZP6oHNqES36QR2rp/nkrOJ7Psj5AQKCqUIV0ppUGrvc/wPgxBGA2j+SLuAacc2groLl460C/z5r0/fFPj8NrmaBiTqsfMUGNDI5hz+WFa/KfbipUhmWFp4C1mXBo/ziDDHB2SBD75vErlRXaAA/DFi48h1Hl2fVUSb9L9mQA6aHzFf1R4ScatZbKMv1rbF5mCbFBIgzo4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:13:39PM +0800, Kemeng Shi wrote:
> The root cause of this issue is because multi-tables are updated in non
> atomic context. To be more specific, the issue could be triggerred as
> following:
> 
> swap_alloc_fast         swap_cluster_populate()
>                          /* Try a sleep allocation */
>                          spin_unlock(&ci->lock);
>                          swap_cluster_alloc_table()
>                           rcu_assign_pointer(ci->table, table);
> 
>  ci = swap_cluster_lock(si, offset)
>  cluster_is_usable(ci, order）
>   if (!cluster_table_is_alloced(ci)) // ok
>  alloc_swap_scan_cluster()
>   cluster_scan_range()
>    __swap_table_get()
> 
>                           /* free table when more table allocation fails */
>                           ci->memcg_table = kzalloc_obj(*ci->memcg_table,
>                                                         gfp);
>                           if (!ci->memcg_table)
>                            swap_cluster_free_table()
>                             rcu_assign_pointer(ci->table, NULL);
> 
>     table = rcu_dereference_check(ci->table, lockdep_is_held(&ci->lock));
>      atomic_long_read(&table[off]); // NULL dereference
> 
> Fix the issue by updating allocated tables in atomic context.

Thanks, that's a really tricky one, good catch.

> 
> Fixes: 2fe7a6f5024b8 ("mm/memcg, swap: store cgroup id in cluster table directly")

This commit doesn't exist, you mean b197d41462c2 right?

> Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
> ---
>  mm/swapfile.c | 21 ++++++++++++++++++++-
>  1 file changed, 20 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 615d90867111..d29062d9c3cd 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -490,6 +490,20 @@ static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
>  	return 0;
>  }
>  
> +static void swap_cluster_copy_table(struct swap_cluster_info *d_ci,
> +				    struct swap_cluster_info *s_ci)

Nit: The name is a bit misleading, it not copying the table content,
just filled the d_ci with s_ci. And do we really need a helper for this?

> +{
> +	rcu_assign_pointer(d_ci->table, rcu_access_pointer(s_ci->table));
> +
> +#ifdef CONFIG_MEMCG
> +	d_ci->memcg_table = s_ci->memcg_table;
> +#endif
> +
> +#if !SWAP_TABLE_HAS_ZEROFLAG
> +	d_ci->zero_bitmap = s_ci->zero_bitmap;
> +#endif
> +}
> +
>  /*
>   * Sanity check to ensure nothing leaked, and the specified range is empty.
>   * One special case is that bad slots can't be freed, so check the number of
> @@ -527,6 +541,7 @@ static struct swap_cluster_info *
>  swap_cluster_populate(struct swap_info_struct *si,
>  			 struct swap_cluster_info *ci)
>  {
> +	struct swap_cluster_info tmp_ci;
>  	int ret;
>  
>  	/*
> @@ -552,7 +567,8 @@ swap_cluster_populate(struct swap_info_struct *si,
>  		spin_unlock(&si->global_cluster_lock);
>  	local_unlock(&percpu_swap_cluster.lock);
>  
> -	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
> +	tmp_ci = *ci;
> +	ret = swap_cluster_alloc_table(&tmp_ci, __GFP_HIGH | __GFP_NOMEMALLOC |
>  					   GFP_KERNEL);

This allocation could be largely simplified with mempool, the reason I didn't
use that is due to lack of RCU support, which can be done later to clean
this up.

Please fix the Fixes tags, other parts are mostly fine, thanks agian!

