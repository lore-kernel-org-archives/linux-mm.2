Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB112E784A6
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 07:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C3186B0088; Thu, 25 Dec 2025 02:52:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 970EC6B0089; Thu, 25 Dec 2025 02:52:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87D186B008A; Thu, 25 Dec 2025 02:52:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 73BCC6B0088
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 02:52:24 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D01A138A1A
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 07:52:23 +0000 (UTC)
X-FDA: 84257225766.18.BE6E817
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf05.hostedemail.com (Postfix) with ESMTP id CB5AC100004
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 07:52:21 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C7FQV/EO";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766649141; a=rsa-sha256;
	cv=none;
	b=YJVa0Ja2mkEaJ4YXxlYX928TerDY5NxCFZTlUDQ89+h74M/d3VdxfqFPNPs82n5luKfW97
	YSuN3VdbNssj3cslXASXrNsEfemuXOvhcYZB4vofW/U1bbvjXGYQyyNzHxfOraFtdkbX6z
	VF+7ClLbmaW7GAw2MYW1GhA72qdI5cE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="C7FQV/EO";
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766649141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EJMk3We4wenG5+4u01UJ7E/ZHg5vbest+jb4fQJ6qWo=;
	b=cAQvHLhq1Nu7RBhsMoQ+wCrEqRRiBVF8pUmKiEWEgzyJGeb6pLr58wS9U9jlL58A3klGbW
	dU70SXwgcv/bx66f5zILkTDCPFKJnovvbo4XqLtm0hES6JwbzX7/gS//r9X9kSi7qvCluT
	6/I+doyoIt5qRMeR/4F7Rn/nxIfWPnI=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-7900ab67562so5024167b3.0
        for <linux-mm@kvack.org>; Wed, 24 Dec 2025 23:52:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766649141; x=1767253941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJMk3We4wenG5+4u01UJ7E/ZHg5vbest+jb4fQJ6qWo=;
        b=C7FQV/EOKUrqSyMQWo8SmpzEGbeqPCCDOShzER7GC+9fYj9xG7xbwodA3uQNQBZmGn
         CjJqYW/WvpBozFqjVAokV+6GoTF/sFErWx6ADJYs8rqDKI5Pjxmh0pp5dMZf8k03JQXm
         kkNpBah3v5y2pVcfbyBYTN5cBCwKC/9cgkOPPO1HfuGX5xwrbTcmEKgH2ThOrGjJG0im
         lVTpAJetIWfI2dg63XAmUod707rI7AYSBY0ABeZbP79nXcDZFkkPz8P+c2l+G6UIgeTd
         icBYwVKxI2BRgaUeosvcmaAAIm2bGjEjOkK3LRceNyGczva1Wze6+MuKpqZvriyg9n4b
         6xgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766649141; x=1767253941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EJMk3We4wenG5+4u01UJ7E/ZHg5vbest+jb4fQJ6qWo=;
        b=HNtLcum/HKIgecbPxTB6VeJmUrmFLlGeEP/rLMM4mXXw71U6nwXwggfdcNTgGryCHm
         FXjaBslNG6LZZcBjR2E5QygdNam7GUXubyTfZM8LoPM8aBWL5npZChPrTYq18mtf4ZP7
         jnB5U4uak5Sz15A69igxmGSc+5F0IAfQoPETo2i5K4u8450RVk1zxA5xSsb3VNpJAfr6
         aZd7RnPoS6DL5Va3oScCOk2oPePsCZJfY3uSPunr/1jQ9N+6WEj2XkbSseNZHD3cUdfY
         zAgwaSvg7v3Q8wUOveI8ZCRnzuVdLcCYzpBY0TD8l1cUratJszmVlIs75EH0nfTDxp78
         Z25g==
X-Forwarded-Encrypted: i=1; AJvYcCU+WNDOaXqtkSGq4CA3e3NAS1Ak3XZgoPORSdpOTORiqfDMT2wo53pC6fOJx33sr03vHs3OfH4y0A==@kvack.org
X-Gm-Message-State: AOJu0Yzxc+fYXV/MENRXMG6Alo6//wCcW553wveskPxsdF+BZeGflU6X
	/UuywrnuoQ3G3tbTFSCkRp5gZgIhcISjVAEFaLHLfR53ZZHtCPu0sdg9
X-Gm-Gg: AY/fxX4ojnpCIF5xBrkng8F+1mHSiuR+4EgXyyhSmz3TAYnbQFjtEJN4KASQeFfOil+
	SKbA6BMwV073DozVxcd+F3BH9vtgvrHFeuPht7rllL8eN3fVPPkDk+1Wa/U7WW5JXfbeSNQuRXd
	CRUhIloco38nBI8vzrY/JmpZxheCEA0lR0YpMxvknLd4QV8t3QV+QTZB3v93ZcIqBMo2+HIws/l
	z5ha+i0Sv5rAjwGA1S/+oMmJw7nA/v55mnaJRkzP2QWAUVgrvgBae5nC9E721IPCNquezqlDFIH
	gLOBw/Y6g4XpIl1VK4KyDoYbLB2Owg4ZAV0hhclHnDhTBUSiJZgsEyoA4eND0x1CGDnYPEan2VS
	MMQO/xGfE3l2ru8XUerKhrBa8gu1x9Jpr72iY2rGg3us+OtHPsdZJQA/FdD79CbDGB/SDTwywyQ
	Ip3QYA4TuddVk52UTAOGac
X-Google-Smtp-Source: AGHT+IE1yw+T7Ywo9wfnwG4FkPlzgN1eey9sqMVh+DrQy62zIGBtNmSZbr8vl5ofKBXPeRnA+0TX3A==
X-Received: by 2002:a05:690c:7244:b0:78c:6572:6e5 with SMTP id 00721157ae682-78fb3ed510cmr146961707b3.6.1766649140840;
        Wed, 24 Dec 2025 23:52:20 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:5::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78fb43b2690sm72594127b3.18.2025.12.24.23.52.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Dec 2025 23:52:19 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm: remove unused function inc_node_state()
Date: Wed, 24 Dec 2025 23:52:17 -0800
Message-ID: <20251225075217.1298303-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251225015445.16727-1-richard.weiyang@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CB5AC100004
X-Rspamd-Server: rspam04
X-Stat-Signature: z3yx4zjzgibe9oc778djg1wn48rt5rps
X-HE-Tag: 1766649141-75992
X-HE-Meta: U2FsdGVkX18OnupwvuKuAVeVSLeegSy95o93WgQAz3Gvr14m32BD7yOztv+NizGt3OFjNTIkrQa2dIObIjzYoOIsf9H9H34YRoFtYuJKcRS5ojkc1WC2Uy/6uu3LcxqyxHDbGjEQq/17sgysf3n3T8FXryYXlq+hbjF6Ze0kr3Lm0AuBZyn8kUr1H7C4fiUkbjeGMCIdTDaK27E0BYvqMsxBjcOvd6l1vKJsWIMPFk2LtCHD5eYKYwrR1vxriRAcigNkL7pa9sQGLCxNM2K3rVYawnFeul2TwaW7PZttt0BH81ivgnnWt0+cfihgx2Ea1fdecAIcvaWzMuid2vvWx4Fa0tjhYFnciCos8slm+BZPlQa6x61ZLUtgsINgjv2gTJW+7pVVB5N2ZHTP8OEfOxwsi3sH8QDjViu+5Q0DsgowKutynqCp6r3ty/qGRwbp5tCqxY8wMSuH45QaQx4EMgnUeXGZhdWv0QcGtvWNGZ+pB2guwHTkNMAQYNlwjL79Z7Vcx1B8+t/x7sQ+n6a3DR/kqY/SO4ZBByoiJCDeGWyua8lhhwaAgou1eNWcjGo20USSmiYl3QwBbL4GjUgtnhZCrH4bGwKHvo0XIh8aGpptOT+Z9pquc1nLXOAsIYaaMbYorBHnhdHGxzNu3kigBZvMTZv686Nf+b2HGd28q3B60j8nZb8uAzdn9izs4kxRf6aF1rv6z41I1HPGuGYPXkutOMGGda9YK6v8QSqLbokCwEIcj/gAea4HJgHvXPhJBHGDw1VHxAx400KG5Rrz984nONxsIFVg7hvVZIGNLdf2fLu4iEMFNqW+DCsCXuIagX3Njae3AmJZY9NlXlQv4gsPIN3wottTnGkyuoktJHPr7gjbbpuWRcioUljCy022dnMRh9Ta6pvn8spUkvlILYLuwj5VJ6mVZka1SxG3iueJFJrFkfLSBUJLbjjJ3dbq34hKorDqYd0VUg+1lZl
 WY8wmmZ/
 rzUNZQMVS44GcCxFR53Venj+mG8e8usPJ6nJR3B45qimCi/POAULaUzMXxDzi7pucCqUrbWHYrgyiT9RCBQVedguX3H1PIglreNXIQzGH1zs35S+mc8zfl7KU+8Al+wh1rye8gG5z+18oTzRd2nq5WKxLYdPkc1m9k3hoTiZ3dYt3nMLmuygrgVTGHYWeLRMaE7Ou6j1PLSRJAyrxkcFnr+h4/OSGk6TBAiskQVZEOyrbp++rboY8V3/0kwhicect8351rmGRzhh+yaSgnoQ6JJTPO+lxwLY8dfqCJgC2Wjl2RAX6W124attGAOJfvhFYile6Q8UhZ7bNmY7OvM8OJvt6cfu0+dAh80Wi5bOglBJxp/PzfF5qrmBszrG465h3eRtULu/1XQRKeQh+1dYxTYumLPj/HW+vfO5Ym5tk/nNrs/f6UMYSx/j09mWYys+Csgn8gkohBGd9ULgXGHDTifa9ryZZGClFcn0ku1jYnRbMYd9LudQJQvzdWRthtw5bWBXTwwewJz7DNDstFiJPA6d+Rdg3Yjnp4mUCfHPay1YjCnMeZPdiZ6G2yGkNXu3chgHa5E2v6oukhYcP/W6VI1LXsSNOjMCG46z9K+6hVf1NgLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Dec 2025 01:54:45 +0000 Wei Yang <richard.weiyang@gmail.com> wrote:

> The function inc_node_state() is no longer utilized by any part of the
> kernel.
> 
> This commit removes the dead code.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

Hello Wei,

Thank you for this patch! AFAICT it seems like the last users were removed
all the way back in 2017, in 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats
infrastructure"). 

Maybe outside of the scope of this patch, but I think it might be a good
opportunity to also remove dec_zone_state and inc_zone_state as well since
they are right next to the functions you just remoted : -)

(Interestingly, dec_node_state does not exist already).

Thanks again! This patch looks good to me as-is, but please feel free to
also remove the two functions above if that sounds reasonable to you.

Have a great day!
Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

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
> -- 
> 2.34.1

