Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97126CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 15:26:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A41F6B00D8; Tue, 26 May 2026 11:26:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A7F6B00DA; Tue, 26 May 2026 11:26:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2BF6B00DC; Tue, 26 May 2026 11:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DCBB06B00D8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:26:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94C2F1C1440
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:26:01 +0000 (UTC)
X-FDA: 84809946522.27.1615479
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf31.hostedemail.com (Postfix) with ESMTP id B4D8920002
	for <linux-mm@kvack.org>; Tue, 26 May 2026 15:25:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QuQPpghs;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779809159; a=rsa-sha256;
	cv=none;
	b=lM3ZDEE2oaxQ/1h5iFmh6cD01rdUBZ+zzv0QewVpku21pUzA7di3NEqFgZzThey7S40HAT
	/e970l/mSEDy1YQZR4ZJ6plw13yoVo3klZfn31S3NqAqPtOLerE6yMbm+qd+jMcgPjyrNl
	59KCo/Fvn3be28ztzGzf0uB1bfDQeW8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QuQPpghs;
	spf=pass (imf31.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779809159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVjcG15pNpaOurZH1fYL0bMY7EmAo4rTVh29axQ41G8=;
	b=K9JwVJI9fe8Y6RlpTtmHbgdtAW1j3qYxKVKIshJJw/wgKOReenKbDeC+YD/IW8KIUN+XPE
	Bazbz31X701Sh7gL4q6edUxVstkkB4+pZojrfRevnTWyCU8z6Pv/gjbRxaRNPOtFWceIgm
	cVz8KRM3FJulQq7U5QwyXjtq91Ck30g=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b1f2b7f1bcso165857346d6.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 08:25:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779809159; x=1780413959; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wVjcG15pNpaOurZH1fYL0bMY7EmAo4rTVh29axQ41G8=;
        b=QuQPpghsbjCxAjMD+9BsqR9aOYVF9MgvBMdFiFdIO+U/va9/KW4PUyJP2569tEUpk8
         1pk4jhXOYuWoqMMlRB/NO2nEBIiD9MPH/rJifqwaFTGcT+5mhDxB2/P47qgWGmvTRo3M
         CDpQsIeiylJ73tOFXaabLolrLfljkdGbswSTL4WTevU4VzcCAsbNeD0ZxRATrlabY9J9
         yuM9+dbtDmAmNvuJXvnEskjzpyoer6gCmRlYTVXttWJuAJz+8Rcn33/8FBA4DzbJuAra
         twGS4eiil6ZKRri6WQSI6KB7DHF+mbF3Q/Q3nhoIzSbxOGPtG+NiVMyJvLHmBnSy2IWM
         3QtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779809159; x=1780413959;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wVjcG15pNpaOurZH1fYL0bMY7EmAo4rTVh29axQ41G8=;
        b=JGwk7WZURufAqMF83Ru9YPHl//u/h3pXG4UOIFhg6lorZoPl02688XfhSnrK0Ekxm+
         hMjnz/bRhykQAuogn25FTrKB1x/Fa2SR0Vpx7p5fqSavYloEmuL9ycQomiH1KyEEIJo6
         SNqwAVyo1pOQLSnsKqO8e3UtsC0/3g/ww5m2Y27wjEzRub7tvaRLQd3xnTJXVlZX4z9g
         QTzbfusWz689MTHc8fRYQFv1wsW0sD9xu34zXqRR6r977bu64TcpZpomvBqrLX5Ksxou
         P/FC0RW3w1iX5p5wrSunUkTmpWNYl6fpprOG/balzDZBE+F8U8CqsjnqjkgS8ZoKVg0q
         Bajw==
X-Forwarded-Encrypted: i=1; AFNElJ+/H5ulnwRHBo6Fj3Sk+TsiwcaY5zyHofOqhgUsaJLfGzi9vOsgKuM+19CLFHn95k3twrbmte3Ogg==@kvack.org
X-Gm-Message-State: AOJu0Yy8S16Lr6B8VaWrLlv6KFKR2mc89dxXIsEYnvbVbJhqn6qVlBZX
	6MpMVcJDdprUPuTP9ZQBGPCJpP7+eU9kuOwzsxF1hHrcEwl/JJMI1w0uIjxp2OZklQ4=
X-Gm-Gg: Acq92OGQSfmcP61HvRafbepb9EPmseWYiKkPEn/czQ061K5DZ3HimF+KIoF9MuytXo3
	4cQVyCcTCyCcU0ibIwYiBoNh9FNN4v1X0zlSOwqN9NZ+mItmdFt74PFuObIvkbLo0YMVPc8X45g
	fCcagp1kNG0bAiD50MRUIA9o0++2eQXpFbBlraSQirs3VxhOuJZZN/7cXiyS89GaV2heo1380HK
	8DBBj5LwAf1a1u56lAWVqlZXSXVeZ1WabdkDtS31WuONDc9lhoxKU04iNWybETqy88Lr0XbI+ub
	cojSRAUTmAS+YcWq8j7QXFB2a35TUf7f7Zgw5yyckjHtm7UXbxWJn6jPnU9pZi+goU8oJQNm4fb
	fEN2oC8jQDe8sNWOwjYZvQLKz3ABCgXgLa7CfpA5jjqvtjlfHyGm/uRjtLQFF47goIwmo6HXrGo
	VHkjDqV7psfPob7ZzRJ6zh+2Nrr/9YJrKIansP7bQHoUaaEQSZuMtYS4MkfglYIGpf3/KHFcSxK
	JZPByunyeP1
X-Received: by 2002:ad4:5ba2:0:b0:8cc:3546:2625 with SMTP id 6a1803df08f44-8cc7be71b20mr263886306d6.9.1779809158646;
        Tue, 26 May 2026 08:25:58 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc80decd31sm141907226d6.13.2026.05.26.08.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 08:25:57 -0700 (PDT)
Date: Tue, 26 May 2026 11:25:55 -0400
From: Gregory Price <gourry@gourry.net>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Rientjes <rientjes@google.com>,
	Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Raghavendra K T <rkodsara@amd.com>,
	"Rao, Bharata Bhasker" <bharata@amd.com>,
	SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>,
	Xuezheng Chu <xuezhengchu@huawei.com>,
	Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net,
	Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nfs@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	Alirad Malek <alirad.malek@zptcorp.com>
Subject: Re: [PATCH RFC 3/3] mm: use non-temporal stores for demotion
Message-ID: <ahW7gwgaF0zIPTAz@gourry-fedora-PF4VCD3F>
References: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
 <20260526-rfc-nt-demote-v1-3-eb9c9422daef@zptcorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526-rfc-nt-demote-v1-3-eb9c9422daef@zptcorp.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B4D8920002
X-Stat-Signature: qaq8rtonk516bs9jo34w48hcp5zxj1uj
X-HE-Tag: 1779809159-127643
X-HE-Meta: U2FsdGVkX19zi6pwRFVUuBha3H7VkV/BUNr2lL5ku1yVBvGD54LUeytC7rG5nVY+fn3irHNUr6j88do42i6NlLuO9JyAANgZcHGW1Vp5dlmHbrV6ViwOly6cXs06J2CuxZLLhLHZCNNQrf3wxNssH2qtgXhoGBFPn38tGPIRyUR8CnDE9pxFdbDF4+wKZsGTMUZy8BlwpBslBvKnjPQLRakh2lblDxkcUf6TwrL19xx7xo8ubhnqiPS9joNInyAiDgL+xvSnlgwtp2iJL3tsyCnsoaqrFKfasrSM2oT3AZ1xOKTMjhIaAGopb1QY50y5SbknuW6B+QFcbqRGR2NGN+uZGPbKwdiE/Zfw4esmI3zbsMZgHaijyJ+QW258fCOVQweWaZx2b2Q7EtZWtOtQbn8CXltkHOxmlJri4lBLTGiKm7YL8KH1IyUPJ8OAZJDn+KIIUPJmasQkliV6g2fPYd7ZqB7oOb6y30v+CgXWXYdAW3LMIfWeB/Ry24cJBheMSUmdXhsKErcy6d8pUwEhlnlXZGiQ+cn5GUuwZE5B6UDGGAX6THsWEH4v1ywjfddI4//M1+GLqhy+75kxWuG53OIIWAj4e9QyvnD6ZeB17kZTCUSrMovEq2QoX24CS8E6rnNggbHJuVEA1TgiFWOwR3wUA8YiLpXj9/Zwczmiqv8pB/cyZVrb0XSrv8BrObmyJzYSelRm56mZQ23WO9bawXAVh5hVKRn2JxeRAHvCOYqsukvWkbjZWO0zDRXQqCdAO5aB6fJ340dStrEWjv+3AiK6D61JeKWA4TkVwpJiLhTP2hGLXFetQjofJ2N0rxPm2V3NNlnnrCg79TSJZb3ABM+4zdwvP+0aJUxgmXHO3q5WVvNNOjNs8s49GHydlwwMEVvD4kYIjXCrR7oPE2s3Vd584ROvL9ztCr1lA/eQdwz9/AKBd0heUQNkL51TBxjg1yB0fNBMwrx5OANHdhu
 fC2JcxLc
 5/soDBnoFbqbM2FMb42v1XjkjvT7xCHQXUoG2IRmp4N5OqXkOlJmCY92JQWRdJxCqPXWVF+1q3qUP1qQ9yhgXy5QpUS6/pAiO1VRGQWoOaVYokKf7hbVYfJpcXAzX5NbIYy1f5sRF6NTv8Y9+l0mQNEzH66Egnjb1ToqttxebpJ1f4RALXXpgES2udpYvu15xEBeySW7nq2jdKHWtYrDQeUmMSqozbpdVmThK19RwLIPWi7tv+EsFH7SLXfHhRbCCK/6qCcvHKXPQ7WTvW1XtJcgAPfDwYnQRjU6EXyT2M1QDTPEbCeVjhYTXla7nzisE9V3alTlq3yDv6Mvt8J28HFO6L8miExwayGhJH5zobg8qMOcZCkCFLlvwd4CatuAaV6FJnuoPI4Cp1K+fHo14UR+Od/n6y1n5FQITQ0/wG1reWhysGO2IjmeLFNhLkOY5LJLHGDUedaZKR6eAKhemhdnM5mLRU/ILatqUkQsWOl7LbcQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 01:37:04PM +0200, Yiannis Nikolakopoulos wrote:
> From: Alirad Malek <alirad.malek@zptcorp.com>
> 
> Memory demoted to a lower tier is assumed to be cold and most likely out of
> the CPU's last level cache. Additionally, in certain demotion targets (e.g.
> CXL devices with compressed memory) the bandwidth can be negatively
> impacted by the eviction patterns of the last level cache when standard
> memcpy is used. When the feature is enabled, use the
> MIGRATE_ASYNC_NON_TEMPORAL_STORES flag in demotions to trigger the folio
> copy path using non-temporal stores.
> 
> Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
> Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
> Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
> ---
>  mm/Kconfig   | 8 ++++++++
>  mm/migrate.c | 9 ++++++++-
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index ebd8ea353687..4b7a75b57f6e 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -645,6 +645,14 @@ config MIGRATION
>  	  pages as migration can relocate pages to satisfy a huge page
>  	  allocation instead of reclaiming.
>  
> +config DEMOTION_WITH_NON_TEMPORAL_STORES
> +	bool "Use non-temporal stores for demotion"
> +	default n
> +	depends on MIGRATION
> +	help
> +	  Enable non-temporal stores when migrating pages due to demotion.
> +	  If disabled, demotion uses regular migration copy paths.
> +

Do we actually need this config flag or should we just default to this
(if the arch supports NT stores)?

>  config DEVICE_MIGRATION
>  	def_bool MIGRATION && ZONE_DEVICE
>  
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ff6cf50e7b0b..368d40dc8772 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -862,7 +862,10 @@ static int __migrate_folio(struct address_space *mapping, struct folio *dst,
>  	if (folio_ref_count(src) != expected_count)
>  		return -EAGAIN;
>  
> -	rc = folio_mc_copy(dst, src);
> +	if (mode == MIGRATE_ASYNC_NON_TEMPORAL_STORES)
> +		rc = folio_mc_copy_nt(dst, src);
> +	else
> +		rc = folio_mc_copy(dst, src);
>  	if (unlikely(rc))
>  		return rc;
>  
> @@ -2081,6 +2084,10 @@ int migrate_pages(struct list_head *from, new_folio_t get_new_folio,
>  	LIST_HEAD(split_folios);
>  	struct migrate_pages_stats stats;
>  
> +	if (IS_ENABLED(CONFIG_DEMOTION_WITH_NON_TEMPORAL_STORES) &&
> +		reason == MR_DEMOTION && mode == MIGRATE_ASYNC)
> +		mode = MIGRATE_ASYNC_NON_TEMPORAL_STORES;
> +
>  	trace_mm_migrate_pages_start(mode, reason);
>  
>  	memset(&stats, 0, sizeof(stats));
> 
> -- 
> 2.43.0
> 

