Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2DC9C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 07:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D82BF6B0088; Mon, 31 Aug 2026 03:29:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C556B008A; Mon, 31 Aug 2026 03:29:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD42A6B008C; Mon, 31 Aug 2026 03:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 900526B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 03:29:17 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F2BD7A3BB8
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:29:16 +0000 (UTC)
X-FDA: 85160738712.10.DAD62B3
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 24CC61C0006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:29:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="HS0Q/svA";
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788161355;
	b=bBmgDQenVbCjXrWFk7r2tMraTtXQMRvZwJHacx8/z/EeFwWMC7JYWmWQUEwFjObiJxtLJK
	cZcSdyRPdU+AFpD8yLI+EAE3M9Z0czFYCeY5ErcRmvBtCUYL1jxoP89R/8RxMZrXmRJ0TW
	I8HMEJuhorW/CbxE1k7id9QWMTWghPs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="HS0Q/svA";
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788161355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lObPyH6kdWwL+DlBFF/s5fn9Kq4aH8qpCjM9SPcedhs=;
	b=Cp1+ndU1wOAFry+1af0zWVb3hgFTsx/u/Uy2VS8NU3/lVe6VUgcZQ6aAnR5M/MTC1VY4uP
	Fb4/eqqDOZ+dpPxyNiHkKgjOTr2oEI+imtk1pcWil9KnIAk/jmaxeiIEC8+Jbe7M9aZZ8o
	vL+YiaZUtCHRXiYAR657PyDx6LUypM8=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4953e04ef16so30809315e9.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 00:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788161353; x=1788766153; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lObPyH6kdWwL+DlBFF/s5fn9Kq4aH8qpCjM9SPcedhs=;
        b=HS0Q/svA5nKW0nQXwxTWBYEI4cDPgKFIRj7uXwwvGXAC9G2s2V42WoGM7n8Qj1SeyM
         rTtdLdsKgsuGfWxoxNmcY2zZBGbD96NRBIu3xWBkFdIX/wTL9M680xz5eVVA1VM43g6W
         fy/Y7sQe/ycuTov8tMAWX3Ogi4q0csiZ6Ks2RUGB6+tDzzZYYxlZ0AOMvwjHleHm1RXA
         iawoV/QDMnV7b1NoCmFWyYr4JtJaplbaw7yMvZ8fKtnyquSJpho8wAr20PloIFvGDHl8
         icBd7/9Zn2jTUo0MXuYuuXzGweg7AVpDi1O7ffGBP+D0yAQDRMtNKXvzM/fAcD+P9zUU
         TVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788161353; x=1788766153;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lObPyH6kdWwL+DlBFF/s5fn9Kq4aH8qpCjM9SPcedhs=;
        b=li+irlYccPJ3aEQAoCZt0vBOTAtkECex9TaWbsdgXiLREup76nfXsSNpfpK/SlynUx
         0PrY/MiWhg1PJQ8+ir+C/wtsLM2gg+mFsyEwuU3bKE0n8Omko6eLSanr5aKQu6e55v7R
         0psKDHpLn4G9JchWDPc6AIeXVUYQ34N90lBfc8ghJeHjtbz11yZ0Nb2H+XvtjhgiLrW/
         i0+95NIN38ViYehiA7eM28cuY27O8LjcsHmovM43woe3bD7pmKd5MYUafIxrWCYhM5/r
         tg10LhkYqDYyfXBcBKU1A1dBGM112FpUu8+5issBw99HUOVRJlGbvioK+n2UtYCbsmu/
         vIkQ==
X-Forwarded-Encrypted: i=1; AHgh+RoPKarjxF332+AuvNaKAkoYswEEUxugyKl0L+MmW8Ra3K1JzSTRV5WF7I/KLTfH6NQ7s6E5KjCZvQ==@kvack.org
X-Gm-Message-State: AFuF++kTVaJYJ1As7sLAjtY+f7B3j0g8E6b1bzRN2+wd4k2TuwaLS/Tf
	znCk5VqeQ8Z2nfqRHtYzAn4kmVHs8CTNkBZtAwwO+xgOssKBC4cbPqghatIZwxj13sQ=
X-Gm-Gg: AR+sD12VLZ/edMsf9nan7BgiivJER5KJ/ohTFMT1/Uixy2U0T/b5uC9b1VpkOZ9BfW1
	20RFjD0lsVV7N/kH66yN3kliAYzpU1asDGVt2gomvIun4JihKVR4HSB/VfyujfQadZpL8U0NoLq
	SBjkOZfl7U6ph/HT/7SDoBwGlm/uyp0KqWy2JaQH3vrBFOUpIU9dilcV68HqssPkRVASISG6fhY
	W7Effz4jN0/Es9WfY2Jwfr8EhsD3VME5Hcg5HyHnbPi6GIw9NELrCUUPbD+DoIIdpdiR3uNrUq6
	b5hJiM5CfUSS7WzL8/rka5mYMk9xOHTXFvUrHOFctm+x40x+FlfZlmvDBAWv4e9AZuOM0qFk+GV
	tDnaFRUrLYxgGrp0twz9vH32tQZ7T8k/caZA4OyoAUOdq9oh3gsznYUHEdYQyAbPGttNEq7k4zw
	6FvvXogtQu2rKKnLlreVrLFwm6LZ1E6nsCN1MtWtIZ7VspVA28VSRpNYDcWmJ5cJygZ64XPIXbB
	Q==
X-Received: by 2002:a05:600c:b85:b0:49c:c96a:d36b with SMTP id 5b1f17b1804b1-49cc96ad411mr275821535e9.12.1788161353524;
        Mon, 31 Aug 2026 00:29:13 -0700 (PDT)
Received: from localhost (109-81-17-247.rct.o2.cz. [109.81.17.247])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b94dd2517sm269889955e9.7.2026.08.31.00.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 00:29:13 -0700 (PDT)
Date: Mon, 31 Aug 2026 09:29:11 +0200
From: Michal Hocko <mhocko@suse.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit
 on isolated cpus
Message-ID: <apUtRwonTCUF07u5@tiehlicka>
References: <20260828135036.7d44361f@fangorn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260828135036.7d44361f@fangorn>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 24CC61C0006
X-Stat-Signature: 4r4yfqktu7897pu64mbt3nz6xku7ztkf
X-HE-Tag: 1788161355-882342
X-HE-Meta: U2FsdGVkX19+aOHDFYfSCDD63qvJR/Jj/iEh/BJ/vgfWIxQ6Z2ppcdDLeo0n16UGxlgFbCiX+WiqvdZTBg8G/1TTNOmhXctXQYgo/xvKuOgKphemIThAyihSLygSt+t+M5Z/FSrXeumA8x3K4P1UncCC7FTJzvYlOkkncz+qoQHSyEVV/ibK9cdkqmJzlAOtr+7E9VBt1HEA7lVpKzRHRE7bvXMIcTkmHGWOc65jkRwec3aUpfYI3R9wfHK7xLtEFTmqO2j/h3mOdTX35oNaGTcn90D8AgdZPbj6fZ1GfpVM9vYscQUZVEF4XJ+F4/HfNiQSNydi4uTlTcp43P9CuQYNjjFHX+QbK6XEgVA0ebpTLEAy+BONF9IjJ8sw+dIUbCvUf5+LgWHHwMLthn04jUHqUQHlyrUqAKs9FT+KIeUMngV2zLG0rPEhLQHsRA/tG4Z1YFjSK09ezalp7cSI0r5MTyNyJokoDlbIb8u7mzg3+oex7qsdbETjy71rWDqM0q18aETVN9ISycYjlV7Mx65Ga6zF9pF3j6LO1RfqqqHrXMuPKeIKMOv1p7YC666qXOa6juOXfgiCigLl98t6ukvMClAY+8E5KrOsAQKrUfCigHcwO+bbzzlfQB5Ndn/uG5wAF8LWM0rLWZHU5m4rphB+xqA3tdx5roypqH8iEDoQPR2HPo/3bcH4Gmfev9sh1ejHXdeKcBvgS6W7owf28k22EgSstYxP+F/zIdqiV/AYdHMqKPQsQHiYRhh1PpryHhDimBS1IQx4vzOFy1WUueN9BBdxzMgnQ8XouhiDKJZ6RHD1rJNjgay6pFsHg37I4aLtPyOKs6rtAFx/TZP0YAkji18X/nw7bGR7M8RULweyLP06O8gk5nVNcdJIFhpOYOHhbs8LvqaVDpnUEjFTPoc1SZNJYNYBi1l4/bhIYCkTHsul2xEQxpbMyEObcsWHFXyA9qsjhsxaTxdsP0c
 OBa5QcLp
 wZwZex+mw+3ZPm/uwzN8BjKQ05eTI+dLG7hC+G5eqILadcSdb+jaxKWPjNQJfjL4PX0/ScpngLa+WPNCBsyxo+/79wMlJWYClaats8LnzGHVTuZmQRrfUgOdwocdqsc6CQTbxAjjBzZbWSTLN70EqLoPm1oiBk35IZ+sx6rsWQr2sy28y7TlsKa6wFx70qon3IH689YZwC5ADXfbT40m072dsMQN+CpwYgWJPhsemXqa9TIpTL4Ncz10RwpxlX4IA/EegyDRkETVZCTeDU3M/xAV52Czlex7ssYGMW/h0fHxFsZLkIvLJC254GxFe+6jlFAUuQmUzUmVm1OGmd3wxtW7EDyykU8mxvR92yEoU8rW+O/P93A40NfHJEpmY94IrZORyazKcNzGZDe7FA2aexT+Nhy3pqXVWP52P/VhnaK7H/lvp8lUm7fK00zRAUyw5jQDePYMJKf7MOWsH7u9WmOPvOZPRIo0pgelEXS3vhbe+zQRfIYiKTTtD9jfR1Y3W8HsuoS5gK1sZyUQ+4XQoRFqZRN34MH+TsuZl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 28-08-26 13:50:36, Rik van Riel wrote:
> When drain_all_stock() sets FLUSHING_CACHED_CHARGE before checking
> isolation, schedule_drain_work() can drop the work in a separate RCU
> critical section, and housekeeping_update()'s synchronize_rcu() can race
> that second check, leaving the flag set.
> 
> drain_local_stock() only clears the bit for work that ran, so the flag
> remains set and the stock is never drained again.
> 
> Have schedule_drain_work() return whether the work was queued, and clear
> FLUSHING_CACHED_CHARGE in drain_all_stock() when the remote CPU is
> isolated, so future drains can retry.
> 
> Fixes: 6a792697a53a ("memcg: do not drain charge pcp caches on remote isolated cpus")
> Cc: stable@vger.kernel.org
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Rik van Riel <riel@surriel.com>

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks

> ---
> v2: use the approach suggested by Michal and Shakeel
> 
> Link: https://lore.kernel.org/all/cover.1787890328.git.riel@surriel.com/
> 
>  mm/memcontrol.c | 19 ++++++++++++-------
>  1 file changed, 12 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 1271d390b617..309398e943ca 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2306,7 +2306,7 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
>  	return flush;
>  }
>  
> -static void schedule_drain_work(int cpu, struct work_struct *work)
> +static bool schedule_drain_work(int cpu, struct work_struct *work)
>  {
>  	/*
>  	 * Protect housekeeping cpumask read and work enqueue together
> @@ -2315,8 +2315,11 @@ static void schedule_drain_work(int cpu, struct work_struct *work)
>  	 * pending work on newly isolated CPUs.
>  	 */
>  	guard(rcu)();
> -	if (!cpu_is_isolated(cpu))
> -		queue_work_on(cpu, memcg_wq, work);
> +	if (cpu_is_isolated(cpu))
> +		return false;
> +
> +	queue_work_on(cpu, memcg_wq, work);
> +	return true;
>  }
>  
>  /*
> @@ -2348,8 +2351,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  				      &memcg_st->flags)) {
>  			if (cpu == curcpu)
>  				drain_local_memcg_stock(&memcg_st->work);
> -			else
> -				schedule_drain_work(cpu, &memcg_st->work);
> +			else if (!schedule_drain_work(cpu, &memcg_st->work))
> +				clear_bit(FLUSHING_CACHED_CHARGE,
> +					  &memcg_st->flags);
>  		}
>  
>  		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
> @@ -2358,8 +2362,9 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
>  				      &obj_st->flags)) {
>  			if (cpu == curcpu)
>  				drain_local_obj_stock(&obj_st->work);
> -			else
> -				schedule_drain_work(cpu, &obj_st->work);
> +			else if (!schedule_drain_work(cpu, &obj_st->work))
> +				clear_bit(FLUSHING_CACHED_CHARGE,
> +					  &obj_st->flags);
>  		}
>  	}
>  	migrate_enable();
> -- 
> 2.55.0
> 
> 

-- 
Michal Hocko
SUSE Labs

