Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D92EC60713E2
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jIHacxSG
Received: by kanga.kvack.org (Postfix)
	id ED5B26B05C1; Thu, 12 Nov 2026 03:38:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EACC26B05C9; Thu, 12 Nov 2026 03:38:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C716B05CA; Thu, 12 Nov 2026 03:38:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B210A6B05C1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:38:41 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41B26A0500
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:38:41 +0000 (UTC)
X-FDA: 85425816042.15.D0FCFBD
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf10.hostedemail.com (Postfix) with ESMTP id 61A45C0003
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:38:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jIHacxSG;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794472719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dvTW0HYPuDs0zvfRlKwp5jFkeDKeUCmm+3AkWFYGUPc=;
	b=SX2faAFAjCy+OS4WxZVppPMKjxgwfPGWNP/Aqk016SAp4wKZJlzsxD/tQ4WF4BezS314+z
	6mlZ01s2ADwJO6uknwKzGO4wda9YnRZSxikmDdQ1jUzHykdG41Gb6RUtx+wlnH2I9j2EbQ
	CiT97Pf9U4EZc01Jq1HUXcIiLv7TH2A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794472719;
	b=h9p54UYh6xcWgL27FAPsAbYhi4ELMm9hOLHIo+aKgIqtN6MhAJLwFFpTYjA5/4DOqeO43P
	uT5E+SZ3rSqUU9shSCMI4uFT//RMiN98I3bzlDs8c7NTghvYiLEgmY2+d/LGVOkR5gKOXP
	Lg+AkqKg8hUaW0fkOPjPQXAi5tcqTY8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jIHacxSG;
	spf=pass (imf10.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3b10ca4e3f9so2287200a91.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794472718; x=1795077518; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dvTW0HYPuDs0zvfRlKwp5jFkeDKeUCmm+3AkWFYGUPc=;
        b=jIHacxSG1onuY15ypdA0qfXSq0NKvpyYFceaVaSZfITOLypbhyWlU9cpDI/cYOZgHc
         iOO22YORmvtdr0A/yXZSEHBkUDJ6Gtb+aw+XS0yzYi3hHWtg+0YZnlHsPyem18sOkOuw
         VyNnruO8JItTvpX2iSb8IljISw3R9op4O55h9cfWeUXKPlpL9ZQvuYvAIoJi9Gbgg+Kr
         N7OwdLvsHwaIjnaJREAU5rukTpviiMGL9l5RYSNQcs5xUnT57z0Tag3rJLsvw0sf9ZHb
         bepfby5v14F1nRFsrJ0kFQerIOnpzpiod76WUtG/m3F4kX/tXL21C9za7KIufA89mCh2
         BdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794472718; x=1795077518;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dvTW0HYPuDs0zvfRlKwp5jFkeDKeUCmm+3AkWFYGUPc=;
        b=YsGv7EYgVnBcixq9sKNoAZibD9Y6mXvZAS3ItDa/7+MhjwExPvklI87XAGyzEVu5MY
         fCmIG2Z3xRjhzkcSXRHG9ZTBIz2zbdxDCop5pOtAZsNuI2PL4JcjRhgH29JQTlGDj4yr
         AGRPm5tJXqS8wplsRwABLenSPsrvwhz3W/o9CBx/q53RrzeBCaDfCcKId8CwuEZvEmaO
         JNJBc9MknUg7k9WxwGXCYT2uO38NaYgGQaixDZUFEhsQhSB0c3vUnpc5lcLwVrNm4F0y
         RxXd1frhSBJXfoy7JXLLJOJks5bOaBA0gbiw9wlyXZi6rs79dApZW/LmvE6BhRMbFpxx
         52Gg==
X-Forwarded-Encrypted: i=1; AL+hErG6DbpDkDIMjtZeV5UAFz9ohRylP84zhka1ClJyPRyp5f3b3N+UvgcpfJPdixoWMCqQuyVloi+nng==@kvack.org
X-Gm-Message-State: APuU4Z9SPUmWpTHCXXBO3TexSeGzz9fI9Sc7Qf/+y3VIDha0AsbersNO
	kLOQ9AJs7usg//vDw3z0x/3RhYrKLrh7Q/mi2nKzj4DO3B8s7uweonhx
X-Gm-Gg: AYBFou32MLDpK2608Fw0EbFFgM5Aemcm4pG/nawmQZmPCNRkZ+VCvgMmiL7sMYjCcGl
	d1ObdCQg1s3WX+79S4C7UltKN5QQpj8kRYK/x6X/XwP4ymjOQjDupCbgaA4/r8Vnlo+kLD06m3z
	ZKP44oeYGgrLE6j4ZgEQt+z0JzXP/JrecL7dJ7iJyRBfo+pMMlF3/G6OldJ5XdYhUfgWu8JsVPK
	K4v7FxdFPCWwyt0vcpsaC55S3QS85FFQttBnStJGQHQDMj3U3Wp7f4hRBv0Wn3z40lZFAood7te
	svq6FSGlBjb4+42IVc/nvtXeTJ7BJxn9o09msfcAn9APwSNLdEB58CxKSMZBHOOvm4Hl/4rusKb
	suCEZeC4jMeKMU4XNgzU9KQKTSLKouX2cFddj/qeGLjt4P703oF2PDWrN967vaOW2n5Rm33U08D
	bdFO4K2phua0wFvpaRL4sbbdez3t6CwWqCAQ3LSWpTH+xGeTUvORN0AkY4uSjAb+hX8/utGSl4d
	YdIpfrKBTN3x2bP0fGJpqNmlO75iVgFgN4pApr/acq8Tt2U98E9+BCARJ3MlPgaIYroqVutqCsb
	1QuGeE/RMWEwXI2qwObTXX1uSDHbJZRu7AozOoVocl5q7eOuf45a2iLATzKQSjQp5epavWsKkw=
	=
X-Received: by 2002:a17:90b:1d0b:b0:3b0:bd53:8e5d with SMTP id 98e67ed59e1d1-3b182fb601fmr3766750a91.58.1794472718076;
        Thu, 12 Nov 2026 00:38:38 -0800 (PST)
Received: from KASONG-MC4 ([43.132.141.24])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b197c8ab32sm3786590a91.13.2026.11.12.00.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 00:38:37 -0800 (PST)
Date: Thu, 12 Nov 2026 16:38:20 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Yu Zhao <yuzhao@google.com>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm/mglru: deactivate anon folios into the oldest
 generation
Message-ID: <avV52J2rD19cjM2J@KASONG-MC4>
References: <20261112081928.3014946-1-ridong.chen@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261112081928.3014946-1-ridong.chen@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 61A45C0003
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ru5zydnbge4tfdtg8mmtt56pqs3geuin
X-Rspam-User: 
X-HE-Tag: 1794472719-133918
X-HE-Meta: U2FsdGVkX1/Ip+2YkkvdW/ludC86g3HD+FycGsXtXXBZ1U9ApaxUf1u2Wk3RJBUO5mvD1WB6o6Y9H35xH1x3dtern9k3Qiup98myeiJDP1xmHnyQatDVDqDJiMdjRhlSdS2PWxhVugNi9woT11JaGykCyXLWs5z4mlSuN87+zvhsmeXHckL7Vd+cBt1tp5SCOpFkLbwyx4X8SYUD9zX938vWkf2tCq97FWHf0E55ncwv3zcok0nj2wzrJ2T/gDQAubO7nnRzLFAqInun40vhkbQSYcsVB26XpHG0Et41p2y5qGYAkwUT7kxtCDCAtAt27/WtuCa5MITs0SWzWTVCIInx5HnFIJZ9O2cnB+ZyOLlosQS06yYU4g8aicLY9Z+4g4q26xrtgCzD0E4GDSi1AcmljXTV0reUu/lGVuTk8w/+EbdqfRrNEVmUwLYG+/2+HbckjJipD1V+dzBRzTDMKARAbR7CVTzX5EWtJjNdn+cybJv6BUgiaq3Zipf6bH6ddssbcFsvhUEAbX8ZvruG/c6OVC6tY6bcP5r3g6SXuA2b5SSfDMe/CUDiTQ98LeijrrzPX/O0SdVhrqkqztaLyrR1bM/aXV7dzVB4hrdOP3KAp7gfcFK1yvv4vIb7E0cZi7vJtmNFI9r6pkYiU9xEj78SwXL/Fcu1YGaBfKBqeGZsoZfx7viJrKazgbA/3KIsI/dwwuVXQYDwpCG8jEPfE8/4s/EhLkIogfVvVrUTWZqfSPoaYxSaastpymZe1k63IT5yg/tgXlCUfcbnl6lVwgOdlQSBel9+afLwazdRJXQ2agJ1FXPnZRdwGtDCe3mZppKRwvQ54jRuZFGvP5BpdIprf4//UrULud8zlqXKrZfX8zGXvYe00mNhB1hy0g2wYVbs52MNrIb62SSI18fXJBQsrT/Rr82CBu+okOobHpL7F3sIt3Z3gJD4MXzELTfRbiBdBf0b1PwlUOksyqj
 2OmDo42l
 iOlpUe6WoiDQyO2bvJF2722GzfydaSUEvsKItSCCeu2lLPDhNDVZ1oyF7g8OLC1xGn1KAmsbUEYKRcp8PZnQECPbXG5fwwYLauJ98uQHc8Bocnh4KJTWNYSji9CBUfTaCr7Hx0tu2yAmEv9XqqshkvKJIDcxXxjQQ3ffEBpVXQAMZ4vpilD1r0rSZfMqMrR5KvjGXBUoOBm96lN2c7Xrn9J0lTd8WIln29TDwfKaf9DHXM4+CCmgEZXZaO6pRlFjKRGaK/ZCgamkPGxGsp6GNziAQKvT4FLiv0S6oC3si12A44qDZxZGk4uDq8/w97qawLcauGEhWV9AzHTfohxgIfN514PrPWUrVTF+D6aYfNMoDJm9QIcXG6R5p2g8H3wjFbED5ypyCoB6a6uzLY7c497IGKfi392zbwmhjNKqVwa5wiNIOqBiaZGFVjxfhyu6jttocc+OIpwct6JU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 04:19:28PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> folio_deactivate() is used by MADV_COLD and DAMOS_LRU_DEPRIO to move a
> folio towards eviction. lru_deactivate() does that by deleting the folio
> from its LRU list, clearing PG_active and PG_referenced, and adding it
> back with lruvec_add_folio().
> 
> With MGLRU, lru_gen_folio_seq() places a swap-backed folio that is not
> in the swap cache, i.e. an anon or shmem folio, into max_seq - 1,
> regardless of its refs. That generation is active per
> lru_gen_is_active(), so such a folio never reaches an inactive
> generation, and a folio that has aged into min_seq + 1 is moved to a
> younger generation instead. PGDEACTIVATE is still counted. Other folios
> are not affected: with their refs cleared they are placed into the
> oldest generation.
> 
> On a 4-generation memcg, 64MB of aged anon memory in min_seq + 1 ends up
> in max_seq - 1 after MADV_COLD, while 64MB of file memory in the same
> generation ends up in min_seq.
> 
> As a result, MADV_COLD can make anon memory less likely to be reclaimed.
> It can be reproduced with a single process in a memcg with swap enabled:
> 
>   1) map two 64MB anon regions A and B and fault them in, A first;
>   2) age the memcg twice through /sys/kernel/debug/lru_gen, so that both
>      regions are in the same generation, min_seq + 1;
>   3) apply MADV_COLD to B only, A is the control;
>   4) reclaim the size of one region from anon only:
>      echo "64M swappiness=max" > memory.reclaim;
>   5) count the swapped out pages of A and B from /proc/self/pagemap.
> 
> B is expected to be swapped out instead of A. Three runs on mm-new:
> 
>                      A swapped out        B (MADV_COLD) swapped out
>   before             16384 pages          15 ~ 128 pages
>   after              0 ~ 157 pages        16384 pages
> 
> Use lruvec_add_folio_tail() for MGLRU, which treats the folio as
> reclaiming and adds it to the tail of the oldest generation, the same
> place lru_deactivate_file() puts a clean file folio. The other folios,
> which were added to the head of the oldest generation, are now added to
> its tail as well, so they are reclaimed first as MADV_COLD intends.
> 
> Fixes: 081488051d28 ("mm/mglru: fix underprotected page cache")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---

...

> 
>  mm/folio.c | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/folio.c b/mm/folio.c
> index ea3adb6a89d7..c412d9b398e4 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -583,7 +583,16 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
>  	lruvec_del_folio(lruvec, folio);
>  	folio_clear_active(folio);
>  	folio_clear_referenced(folio);
> -	lruvec_add_folio(lruvec, folio);
> +	/*
> +	 * For MGLRU, lruvec_add_folio() places anon folios that are not in
> +	 * the swap cache into the second youngest generation, which is an
> +	 * active one. Add the folio to the oldest generation instead, like
> +	 * lru_deactivate_file() does for clean folios.
> +	 */
> +	if (lru_gen_enabled())
> +		lruvec_add_folio_tail(lruvec, folio);
> +	else
> +		lruvec_add_folio(lruvec, folio);

Hi Ridong,

One question here, why MGLRU/CLRU have to use two different ways to
add the folio back?  Will this cause over aggressive reclaim of the
folio?

