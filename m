Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1E13C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 03:59:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DAAB6B0088; Sat, 29 Aug 2026 23:59:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58B4E6B008A; Sat, 29 Aug 2026 23:59:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A876B008C; Sat, 29 Aug 2026 23:59:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AC7E6B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:59:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2C7EC0233
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:59:03 +0000 (UTC)
X-FDA: 85156580166.11.B9A83DE
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1B9B940004
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 03:59:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sQI5fuVu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788062342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQ8dbbiBgPJ6FDZbDcbGb0ykdxb6d7xQ7LY+xp+A1UQ=;
	b=uut37+9FNcmMgsRP45SVOl3M4s42g+CaSzm+aNo8Xz8qKr5uEQRarqoBV4Av7mwegeEPsb
	B2hCxW2sebKV6tufIDAtVHQJRTfKKCC2HQkrtdwG6T9IJ+yCl8ZGDa4UC/e/qk4LLZQE69
	un+JeZp5hY4GGoa2qU7Y5bS0t+RKe9A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788062342;
	b=gxVosZGmCZmMPJd9efapiGixNGuuOsCxmSMgKMv04/aT+9T4he1cKQS9hqWtPFsf7C9czg
	+VtY5I5W6N086gkFJxv6snBEAOtxklztHZoSa6QaIT83oW86CjZ8c14NbkEz7D7HqqOIAa
	W5qst9ND9bA4dk/z3ltuA9iq0NdE8aE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sQI5fuVu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2d6f55a7089so23042345ad.3
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 20:59:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788062341; x=1788667141; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mQ8dbbiBgPJ6FDZbDcbGb0ykdxb6d7xQ7LY+xp+A1UQ=;
        b=sQI5fuVudaYunS7OMmaYCRPWvVxTN/sL62FxXjfvYGWoG8TkG4/tbmJBR9W5ZTM4Ex
         oAk6FbyR0MKNnqmX2ZxglL8mbjCd2bx2gEfqFH5apyqV47mg+C4MVMBx/9YJs1MjsUz5
         OVM/AWju5F6ab+dXLUJYdiOHHYDt8OEChCoUzLTocoNfIAJdogjAWSxRW9V4fu7VEvNn
         PhGMGwDoV6I4t5jdcj+sUhO2xKRmD2d6h9KDTwIB+CIU82Z96O2lEkKraJedUf3gtWaF
         kOi81WGkoXsNxbcbAsNxoa+FU6x2huf4aC/WF5N75Pg+AxfIe/a2T4Tny/chk/rc2K+n
         6Sjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788062341; x=1788667141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mQ8dbbiBgPJ6FDZbDcbGb0ykdxb6d7xQ7LY+xp+A1UQ=;
        b=pzjTqGT4U/uTRd69mhurBd+qQn1vLgmkIE7SnI/SRwKkCRqXHwIuFoyGrSvu0Z5ebx
         730zCeL4Pjk5q+hzibv30AIh9s9E6PSNLxxPgDswZqgv/wGl2qNl+uhzhnXznMamPbQW
         BH7qakLbc1m2oofdlOuSWmaKR/Ksr9cwvKbod/2ebHMy4N0gcgL38d6tpBHyGFp6q6Pf
         e9Pv7WoTxltSE/nPAFXWPUr/Z2/KaqEhTYXuQ16v+Uc96weSkHXPYSDQYs+Z+6K3cnm1
         GBzf8Ph+KjKgUsnzSSxuecMWhQz44NZ+jNeuHiuZEDWBHDW/UHY8u9RgPWzTurrjW1DR
         gT/w==
X-Forwarded-Encrypted: i=1; AHgh+Rq000YsUQj1JWafGL/eObTgr+KLsXMNEWR6iUUzB1lw3AzvHg45f9AefpsLUS2cCPrafxM+pF2BOg==@kvack.org
X-Gm-Message-State: AFuF++kNRZ8nSNFRVkuVptijZINjCrZuEQDITZEviTYzMCkDmkgyAk5r
	mSMY3zyJsnSAnifXVPbuS4PNuxrGuFlTcK02zn/hf1AJkD1OwizAi+Do
X-Gm-Gg: AYBFou1RmeD/qmTwIJln37KbHMBjPIcL6fbg3lPXlVHA6hyiK875Cbp27yARUS/Hw4e
	EMKYgAHppP5yNUUeKEY+dDyL6ef/akzL/W8NsPQldlKvYiihwbEekjmbSW3jtn2hcONmeL7tEYp
	zhAgtD3/rhpxdbCFT5GAZJZbpWUxxMR8NrX41w5cC+xreQxbTYewaWxxTqQ3NKgFZahJmFhESec
	UnPPC/7alb7tUOiN76opLUzORgElC191xQvwgsKiMdfelOnB03wGTcOooxXHoouQybMajRmL3MB
	E5uiKWstKJj9PT43oTp7wlgSQ0/ihAyZSAmDfgUjRJO/vsYlQn/ZTNG+8s7b+/XmGr/tQQo9/Xi
	YZeHpt6VB8eGUysIdyJTJz5FflBORiNxRzDIP4bFc7g/10gJSt67LCDZIGomXh9YPuAAR/Ww985
	+rpiNQFbB57j/DW06GKy9P5IBfDM39a38MCaeatyxoPOyNFxx+k/qHNDnMMdju
X-Received: by 2002:a17:902:f78b:b0:2c9:df1b:e948 with SMTP id d9443c01a7336-2d74dc78debmr295950455ad.4.1788062340334;
        Sat, 29 Aug 2026 20:59:00 -0700 (PDT)
Received: from gmail.com ([185.220.238.38])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d75988d184sm18386975ad.62.2026.08.29.20.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 20:58:59 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: "Barry Song (Xiaomi)" <baohua@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	akpm@linux-foundation.org,
	lianux.mm@gmail.com,
	axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	chenridong@xiaomi.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	kasong@tencent.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	stevensd@chromium.org,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	Xueyuan Chen <xueyuan.chen21@gmail.com>
Subject: Re: [PATCH v2 2/7] mm/mglru: batch update lrugen->nr_pages in inc_min_seq()
Date: Sun, 30 Aug 2026 11:58:38 +0800
Message-ID: <20260830035843.712320-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260827234704.63163-3-baohua@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B9B940004
X-Stat-Signature: apk8kd1864zjmt8eecx7iwbjurk5ikwz
X-Rspam-User: 
X-HE-Tag: 1788062341-69113
X-HE-Meta: U2FsdGVkX1+VtxQekaKWlMEJYCd7pkcvc114/FTjwQlCH3ObncHun4pnNFAtcT53kwQV65Rk2Cteu9PLI9FlwZTRPKVikTVXF6H5rlnwsXWCsnxsZXyzr3xfP6JwEF23NTxCNLRozEnDrFrMYyHXn5nfSzzcEj/lfW97KBdTldhUdp7pyCK1nOigLwgPptKO02NbmgcuTWYGtAnNpgqM07qm0rsJy2ixjIacAaQ2CYkYZEzNMSFFIg/FL8SiT+9toJuMXU6rV7AwvpkjnRdk/vAsgGBZRXsON3RMW+laxGsisdkFuh/0RyWCP43Fm8RjjWnrJ/2oFXUduhNhvNvC/+4aNCXjVQtOAtB8MLwzO6fvY/OaHuuTEq82DzXFIfXf6e4pvfisDnmcnL7d6mEeBKgvg2yRqYmEwT/kctEMybMbsb3x4RRcIfr8Sa7BzoSYIkLhqr5079Kh/ULnyNcZVIILgRKOvjsD57Ban1Fb4mzwSMg0dRMMhpgYC/3fsxh4DatYMDKsf33XCeZf1L3hMAHOyTIK2x6G4vk33k8j6HeWVS+WqZlQCp3QPSeNUnmKODV4Zj1Sn4LlPQ3bNMj22x+jTcU4qZxaHX+uc+M8q6sZDWgBu0YV4a3wXujEIMpN50oH0JG97cBAX0kUSOmrjfSi9v0+qW9UmLinPGjvAEi6I+CgCYoTgJ7y4TvpjooXNcHY12V5aeJQhmRaUox+/ruohRvzC5Ym6I/auabBy1HZe2Zai5Eia2m4e1gLDVvFe9uO5cnab9isAziv13zEF31VLtglKYVz7h+boeRNlfllaXmVEZYeo6XqcpjL4f9+ymzVXiCed8QDw+Qku/Lf7V0Lc8x9mgCRL7YXCFlz7NUJrBhufcblihanRaccXKrvXlfvREbzEFMcLivik/yFG/ENzKkHFowG1cBXy9ckOjbDmcDHhby8141KkYsFiVv0FDJrz6DvC+A6ZCj2YSj
 9JMjnv+L
 YBQIE+bP4c+eUkHCow8wQWJALr7AJl5/U7SbLhlPyq5yb9GrmqiRBRzAaYKdYM1NbAvnjE8qifS27JTg5NvB7uoT4px/6G6x1YTmroLx/Xg/+mr90xKDwI4a0d5na5UJesG0uetBf4ypVcumHUoQ7RiYKyOFPjpSTzvs19hrSBioJkgoJziZD57qcHg9ovKhT0SrF39AW/G9Pfr8slN5bbu7+uQylSuCPLpsaDtJj39PHiDjc6IQAPXVlqkAkIjzRRLAPoxq2ryjEsEi53aWhai6MHTdbliArhGHelfi1hhmTyp+cGdWU/22Q/wnQ9dIdUZqHkRia8OknB6dzNmyIDo7nGf9K9KOIQ7qhsi7w1ulsiRgYv4QWa2oSHU/XOZ3SuKc7cwC/WwygV9wX+PD9BV4VQ4DgupOIjhTez5CowcKOzkR/E6dlucX1oyCfXGJAut26t5Ne0zLNN8IVb5bj0kD1vXVYTsTqNNdP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Aug 2026 07:46:59 +0800 "Barry Song (Xiaomi)" <baohua@kernel.org> wrote:

> Currently, folio_inc_gen() updates lrugen->nr_pages for every folio
> as it advances generations. Instead, accumulate the size changes
> and update lrugen->nr_pages in a batch after scanning the entire
> oldest generation, or when the scan stops because remaining reaches
> zero.
> 
> Since we only move folios from the oldest generation to the second
> oldest generation, the active/inactive state cannot change. We can
> therefore skip __lru_update_size().
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  mm/vmscan.c | 23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 8f187d296b8e..07c22d51debd 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3918,6 +3918,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>  	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
>  	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
> +	int target_gen = (old_gen + 1) % MAX_NR_GENS;
>  
>  	/* For file type, skip the check if swappiness is anon only */
>  	if (type && (swappiness == SWAPPINESS_ANON_ONLY))
> @@ -3927,35 +3928,47 @@ static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
>  	if (!type && !swappiness)
>  		goto done;
>  
> +	VM_WARN_ON_ONCE(get_nr_gens(lruvec, type) != MAX_NR_GENS);
> +	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) !=
> +			lru_gen_is_active(lruvec, target_gen));
>  	/* prevent cold/hot inversion if the type is evictable */
>  	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
>  		struct list_head *head = &lrugen->folios[old_gen][type][zone];
> +		long delta = 0;
>  
>  		while (!list_empty(head)) {
>  			struct folio *folio = lru_to_folio(head);
> +			long nr_pages = folio_nr_pages(folio);
>  			int refs = folio_lru_refs(folio);
>  			bool workingset = folio_test_workingset(folio);
> +			bool gen_increased;
>  
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_unevictable(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_test_active(folio), folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_is_file_lru(folio) != type, folio);
>  			VM_WARN_ON_ONCE_FOLIO(folio_zonenum(folio) != zone, folio);
>  
> -			new_gen = folio_inc_gen(lruvec, folio);
> +			new_gen = __folio_inc_gen(folio, old_gen, &gen_increased);
>  			list_move_tail(&folio->lru, &lrugen->folios[new_gen][type][zone]);
> -
> +			if (gen_increased)
> +				delta += nr_pages;
>  			/* don't count the workingset being lazily promoted */
>  			if (refs + workingset != BIT(LRU_REFS_WIDTH) + 1) {
>  				int tier = lru_tier_from_refs(refs, workingset);
> -				int delta = folio_nr_pages(folio);
>  
>  				WRITE_ONCE(lrugen->protected[hist][type][tier],
> -					   lrugen->protected[hist][type][tier] + delta);
> +					   lrugen->protected[hist][type][tier] + nr_pages);
>  			}
>  
>  			if (!--remaining)
> -				return false;
> +				break;
>  		}
> +		WRITE_ONCE(lrugen->nr_pages[old_gen][type][zone],
> +			   lrugen->nr_pages[old_gen][type][zone] - delta);
> +		WRITE_ONCE(lrugen->nr_pages[target_gen][type][zone],
> +			   lrugen->nr_pages[target_gen][type][zone] + delta);

Hi Barry,

One subtle point about the `remaining` handling:
when `remaining` reaches zero, we now `break` rather than return
so that the accumulated `delta` is applied before returning.

As I understand it, this is required because `__folio_inc_gen()`
has already changed the generation of the scanned folios,
while `lrugen->nr_pages[]` is now updated only in batch.

So the invariant is that every successful generation increment must
have its corresponding `delta` flushed before `inc_min_seq()` returns.

Is this the intended accounting invariant?

Thanks,
KunWu

> +		if (!remaining)
> +			return false;
>  	}
>  done:
>  	reset_ctrl_pos(lruvec, type, true);
> -- 
> 2.34.1
> 
> 


