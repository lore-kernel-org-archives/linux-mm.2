Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D1D8C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 10:11:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F40936B008C; Mon, 13 Jul 2026 06:11:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1306B0092; Mon, 13 Jul 2026 06:11:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D943D6B0093; Mon, 13 Jul 2026 06:11:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6D516B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:11:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 48AE7140A8C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:11:42 +0000 (UTC)
X-FDA: 84983336844.03.0F41A5D
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5797480004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 10:11:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bMGNmjJ0;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783937500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B7iIgOh4QNobVdUpoap6YvKLETqNCDd+ytv+al45uGc=;
	b=Lycv8XI9xJ3XIg0gm0fHsNDY7P6VFAuiJWUwxpBjheetI35AQB7IcKSelWPKhqSTacyK+t
	GnVWUQd2fqhWkUfEgfFLjw4tpwrCFFsoCdSAzmWcbrIYE4fdycxs1BbckAXWhQuUpFNVSE
	iDSbXxi8wEAw1RFGASolfX9+fvurABA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=bMGNmjJ0;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783937500;
	b=YHMzhusTRvuCJYnX62B2lVj/DETx70AIvOLUv5DHnSD0Kyt/cFav7cgVyh2NPM+tTCJaLi
	UqQxSts/HPDOW7X5Q36RLEIQWEWB22XFNLvuRAkchUq8ZpZ27nxla+jrPAtzyqFnERSQSO
	Ni2bKWlsP9avVC8o9M45gwLfnTXmvWI=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47ddf7b09aaso1921520f8f.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783937499; x=1784542299; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=B7iIgOh4QNobVdUpoap6YvKLETqNCDd+ytv+al45uGc=;
        b=bMGNmjJ0TOoaTB+MZpAmDjeCyz/9r7BmLg/oj6C98U1jNJF06L6QO8qx/6/Rodlu9x
         jUTBgYXKkiTef7ahlUODdr3JdJN2zDbbIpXgLQ2A/ifAmns32NsdI1UAHOxsncE13uIq
         7KeMcN5Ls93N7931SbB6u1EeKTfJOpCytvrsg1Vdu+zyZoFvPBLm6oLcyJntcKTTTuNx
         tBIR5zSXs2RJfguCnALSgIqPRlCC4A9GjH60FdsHRdZcMF4e4TxHwIyRzTGqwiilGJ3I
         UJ0lCC5CsfYrQGjyh2hUeQ2gtlrCEOywVliH04TWm6hoOed8OuOICwU1T/qwPzQfZAS7
         /rXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783937499; x=1784542299;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B7iIgOh4QNobVdUpoap6YvKLETqNCDd+ytv+al45uGc=;
        b=bXw4/pkRdJZFkA//+Fiy3xbfeSPSRu6Tz/7olkXfKGv9sp+qnOLRnIdMWFfUyikKAS
         XFT1FKbPIkKnz1gKEYdSh9X0vwn+R7emcfCFZqxRH9+I94GuTnx2gaifbr8VJsCs7/m4
         Q9MqNc/w4mkgcgSPjcJNrlcFemQVQZM1H5SON90lhSUN6T6WqfZRTjPHmS1VI8/jIF8U
         buWU6Tkh+TMWpp1LU9wBqELe1L0fvEtA929eRUNr9ELXLC+jbozKfyiDERVtXcn8bDG1
         vkKQPDtGhsYRXQZ/VBHFeb0CEs8F6W2vWJ1cwI57E/CzBhy1yK5zllgszPISDaC2jNsT
         g11Q==
X-Forwarded-Encrypted: i=1; AHgh+Rr6FRgLXJXa9zYrAygXTM2trgL5Rv4nMcD2XvJbpj8sKMeuS0/nI0NSGkiR8mwFoNGbW3Jb/25eyA==@kvack.org
X-Gm-Message-State: AOJu0YxyEgzhtR1WoetdHAN2eagY+ZeFIVvux+f3WuzKuMvu/YCYFL40
	VKTzHIXbXpZk6zGHjtkU/5tGszC9HaIt9cMLlq/yVQM4SkTTy2KHF6gmdVada7X+fpo=
X-Gm-Gg: AfdE7cm7x8t8rgw8abtRC1eGsNrGrjDGIiV39LVDzw8XmN7+HIMzYgBLOh08Veu99ti
	5Wv3lxJe/5geJQHPeALa5yzow+cO+4TYc/B3aMpzKXZxN8ay2Pgf7R70VdtbZlqrqxiPuwfEYAp
	VkcKHiQs24/QvDAD2fqk5WyIBepbe6CKi+Hsrs4ieoaCg7c/K3JaCH9GmN7mbW8STsfGrKi85BH
	ni86pQe3iQYymKhGPA2VWqnQ4UhtQrK5/F3W+CCU7SwXpeYq11NgQ/s84fg2Bc/0jNaKnA+CsE2
	j7erXQ/y3CYioqRgg3Sthk5x1uRp2WV5U9Eqi8mzAPwM7+r/hhCvljgRHse+zAPrFkZ8s8lL2Ue
	MC/Yxbaqapj1qWnAHL0AoNvW/tBtyAIFbP6Li/T8UfikijkdkXVdD6grDmTutRkjNP92pts8giR
	cqv4vSiT58BMt9NV2PBfFMIH8=
X-Received: by 2002:a05:600c:4ed4:b0:490:e5c1:b8b9 with SMTP id 5b1f17b1804b1-493f8780525mr96750285e9.0.1783937499056;
        Mon, 13 Jul 2026 03:11:39 -0700 (PDT)
Received: from localhost (109-81-90-85.rct.o2.cz. [109.81.90.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47aa0a55be4sm79380244f8f.31.2026.07.13.03.11.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 03:11:38 -0700 (PDT)
Date: Mon, 13 Jul 2026 12:11:37 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Message-ID: <alS52SCoict_OkLp@tiehlicka>
References: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
X-Stat-Signature: 81osenfz5ocp6cqeagxpymjj588gogjm
X-Rspamd-Queue-Id: 5797480004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783937500-571784
X-HE-Meta: U2FsdGVkX18pQ80NmW7fmmYGcE4nPU25EKVFT7IsIq9m5Al9BX68rPpWuQVN/1dfLhvo6baGSIFzTvQ3pHGCX2oLyULHi2+4eF6Nqh/4DI1z1KwNblefcZl7NbQwwFynCDF0tgstwoGrdJeB70GgzSnhO+1o+XUlZCma5gbTsyW6YYKYjU01I2VW7NuGov5DEh+2TfOOhFi9YhhdCbYI/43TWlu2QZzA0p/29SIx4NdzWg2Sekkad+2+fHOzjclyXg5PXS4i01tMZq5/ucHiBChREIw+GOoQSevxuBTo6ax+EVLPIsHlhMCDpCVuFpMR+q0stosVLaN1vc3R8H52a8H2RrHkbMlTScV7f9TKX3q07ED3qy0BlTEJ1/uY4IoDNuvw5Pbt20UW510V/9JjX3l0VIdHYhHxEy4Jsh8YUXSkqZTVOgj/t4KN3jH9zRRh0GuuumIWWiZYp6ow+3+IWUF80eNZ5B6Aaw7gAK24uR168JUt7sJq+TyQmCh+v7QW47fm2ASW9pcp7j+Hj2fmMcAHymn6F0TCq5r7v1FSZuRhTT15RUyJ+qmHTh4qcINLhODnNVv9BwuXmf8UdOPXyO++OiFP0dQxoFTGu4yoj9npWrkeDcY68koG2IlIHu5GPQPaUMo9ZR+BTOt6xeAPtLScPLxraU+i9JiRUYRZSWcf9pZyCO1OhSXuaXe24kr/Jw0JPn6jcPlr0ELd5wjI7TrNAv4u5FDNQl+MvPUQlDUxrp89Y5bd4+CW365jI6muhtGYJJfgfDn5t8eiqXGa/Qnm2EfOuryTxPi8HpfNSEX2wyDfpV0BHUxkeBWf9udziqJnksO83Acrq/qMAAi2mVr5VkLOPPe6WDnRALovsI6t/u7dxBYhBeMEE4kbMCWgofrNzZOaO0oURlswQmyW0yUfcJ/gkwi6UThTQ2jNWYrTzyb4OqHRLbt0nvFVfRpNPsQb13heIlxOU2QtgyY
 aoSYTNOm
 +EJwHj6y4BEVaQtxLNOrkbjQYZzYiUdm5pb+QGSQSwgd+mF96cNOORSsuXJxOkrA86SycUVr3lmJYeQTJKmBHDgGbKNVukojAf6EueDcKH+dunLHFZkXBQdcd+dvHtyNLVcPgM8pBGRyBcNx5J015ZS0bsGfchlNgX9cRAR5FjADUU8DTj+6Tw9EZKZSzllRVHsn9k5AdeOadii6mTxxC82Hyrmdz4+OWFNSNRnTkySiWsxDUdNOlGHgCCOARj3eqkrcFBbEyLZoauhD40xgBahoTKhfGDX3aOpPXNtdoPH+chhijWeBSRaFW9Sb7RUpILMmUOnaCV48/7+rnCuXOigLSDqecSWxJ6HcnKb+ELTHigezOAGoC/0XoTP4wd8K5KIe+qx9GCxnPhsVudghAI5V3hm99eh4JwoydZMKnjsdL4pW8BATgjzGXKGvkxlMDsb08xofSY48aOb4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 13-07-26 17:37:37, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol-v1.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> index e8b6e1560278..73bea1b5c8dd 100644
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -752,7 +752,7 @@ static int compare_thresholds(const void *a, const void *b)
>  	return 0;
>  }
>  
> -static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
> +static void mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
>  {
>  	struct mem_cgroup_eventfd_list *ev;
>  
> @@ -762,7 +762,6 @@ static int mem_cgroup_oom_notify_cb(struct mem_cgroup *memcg)
>  		eventfd_signal(ev->eventfd);
>  
>  	spin_unlock(&memcg_oom_lock);
> -	return 0;
>  }
>  
>  static void mem_cgroup_oom_notify(struct mem_cgroup *memcg)
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

