Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850DE606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 23:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=D9aNQXoJ
Received: by kanga.kvack.org (Postfix)
	id 54B616B00EF; Sun,  1 Nov 2026 18:47:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FBE96B05B1; Sun,  1 Nov 2026 18:47:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EACA6B05B2; Sun,  1 Nov 2026 18:47:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11CEA6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 18:47:26 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E68D40B56
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:47:25 +0000 (UTC)
X-FDA: 85388189250.02.41B4CD0
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id A06F540003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 23:47:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D9aNQXoJ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793576843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGKq3X08/HBTqu+TtIKLeW2xAMA2Xfd1c0mdem9B3G4=;
	b=UzzsCzrmCFasddM9ymPFr9Arp5Qy37rWReDlAAAZ+RBoPa1ZpLaW+aXwDor+NT+jJDfHCy
	RoWboMj+06RjyPOxw1hXSyy0qNThBzTmvQargBgBtWhW/0lULTQRqMO6c8m4gcIcnD4vFd
	fEL2W2762DWRlymp4wOfPoAsSk8hi7o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=D9aNQXoJ;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf04.hostedemail.com: domain of senozhatsky@chromium.org designates 74.125.82.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793576843;
	b=yB1ScuJXlp4bD58WrOWBPn5ICdex3QozmXGrdVyGjSrlgHYrS9bG7uxWka61B1oVrvEJJQ
	WpPDCVsJZdNbMPHVNlQeIBPiCTXRiTB5eD1ySMDv3wgDM7gBEL1kscL8rkTMkN26AmC9SL
	QoH2Sf3NQDA0FJjEcVv5DwFqhKt2IQs=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-35829219da8so4091921eec.0
        for <linux-mm@kvack.org>; Sun, 01 Nov 2026 15:47:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1793576842; x=1794181642; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NGKq3X08/HBTqu+TtIKLeW2xAMA2Xfd1c0mdem9B3G4=;
        b=D9aNQXoJqBkdJdWr8NtIhIKjeBTabK7m9+VA1bUPphbkHA9gZgnpMCEacir5smp4MI
         jUz31UXTiOROlHMWelmYbs3YSl7L4Pg8kx7FlZnzAicJrjQvMyGwrbxI7dxgXXhh3Ues
         EZJqoQ4z/DkX8IYxdGSfiGpQSoomGMLIlnQkc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793576842; x=1794181642;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NGKq3X08/HBTqu+TtIKLeW2xAMA2Xfd1c0mdem9B3G4=;
        b=h2a6xGWReodtWi6CnqRIJBoIYmEm+y1e+i58T+3BCwGyGLNWc1fchU2EYNMM643PBa
         11eCP/2K4ql6OICfdq5MWXzPSCO4zTiNXfTCOSAysmpz5WOJWuJ4omUadux5o5TxUogy
         frxlrDi8JM5ZvLFSyAG85w9nNwKaD/ntQL3w/tV+J9uIO6m9/ZA7VLjT9OrXNmlPlL7y
         Pox9oJk9YWn8+QW96FR4lq7FXRrV3lRJOeDY8VVjeROaxONbwNlcQyLj4UWnzn5qnNP6
         0cSW+KnOtwVa1li8M1nW7+WSD7EYKQ8dq5j2X1/AkbFgnoQlpiqIsnBIvIxbgj2o0Sv5
         3ByA==
X-Forwarded-Encrypted: i=1; AKwUvBzF6fcl7KPGdTcRz7q7KUm2Gz68WmZn2oGpzaTHTxrk2p152rA1zYn3LcSK2LXd1y3H/qVwZX7TWg==@kvack.org
X-Gm-Message-State: APuU4Z/ngvrAAb18Se9UCtHLNCyNENJjqXdvqDNDn+eUprv9Jx+Z/BFc
	Oz0qyyrouRYQpYtzuUAOGpzLdLuhe0bo4vihnZnXfMhWH+SIzWhLTHnBl4l6SL6pNayh7Or0pL3
	xL+Y=
X-Gm-Gg: AYBFou1ZBTzguLKiQWvr4BASDqz+TcAnABE12vSeu7RyYnJuAGel5uM+JkUQoCT1LI+
	+dS9CrzdYRIQTAwX3STEpfkrYby8xZaqwUKRf43ypU8TwTyTcce0kO5dfDQeUp5mpOYBUGUfvj4
	XlGecVoongu648lkqqMvOfm2LSpw1PSToqfOE7AiQFL9ViLz3+0Qm6stOH55TyudkKZ/TwISlZ0
	w7XVq0SsiGKH7mo6G+eoOLiHQ5r0jLmqTzlaCU9AdoZT7a69N+yD8H78XlozpeGBebpQ6i27OGw
	5GfNorJ2fsrNhTpC2E4XH9PBGJfrECyKURVbj/zT62wv7kgqUV1xyE0cruoXw9yNZgeSFKkMjWb
	QloBTmz0SYS+zqyljOZ6u2UttDPqOjT8Ffbm5ofSJV1om5eC5fh+P1P0pnvFIoKUpdchoO9o0Vm
	Mxaq3eT4BOWCaknQmAuPAZc3shAAntNwR6SrYbFY3Woqa+qzzVFq6hmSbJtBc8qZg3FSmVDUV0E
	T+TvtQ6kP6aWDkFxxM0cuUN/QH8aCmjo8jLayP8PtM9Y0vKkIvAg+mucVCusPfLvSfx/PkVCN8a
	RKWKGQ57kZJqc7X6QJbqNNfKjRPW+ZZqNH5RkWKMiWSo30B8QQISeNtEhAcinFCvM2EM
X-Received: by 2002:a05:7300:f40c:b0:351:606f:2832 with SMTP id 5a478bee46e88-36a42340896mr11385000eec.3.1793576842036;
        Sun, 01 Nov 2026 15:47:22 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:2bf9:d7d2:dcf1:c2a2])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42662f23sm35840147eec.2.2026.11.01.15.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2026 15:47:21 -0800 (PST)
Date: Mon, 2 Nov 2026 08:47:17 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Nhat Pham <nphamcs@gmail.com>, Xueyuan Chen <xueyuan.chen@vivo.com>, 
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Chris Wiseman <chriswiseman@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	xueyuan.chen21@gmail.com
Subject: Re: [RFC PATCH 0/2] mm: zsmalloc: make shrinker compaction
 budget-aware
Message-ID: <aufPMirl4cD7tz0X@google.com>
References: <cover.1786003779.git.xueyuan.chen@vivo.com>
 <anVWZVOt-xeD0dMH@google.com>
 <47ed45b5-de67-41aa-aa21-a3ba3479a7cc@vivo.com>
 <anXJ-5_vO7-toSe1@google.com>
 <CAKEwX=Mm2tXcen-quRXHf1Y2qSHYvpEUe4xiw-mHYaJnRUR-EA@mail.gmail.com>
 <auKqt6b4AxCLziIH@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auKqt6b4AxCLziIH@google.com>
X-Rspamd-Queue-Id: A06F540003
X-Stat-Signature: u1iemmcukw6uf8imkhm7w9gttqpfjbcq
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793576843-509651
X-HE-Meta: U2FsdGVkX180uDpSpVsdMWve9q3QG6SZl/YqOrS6/0bhwWUBUzg2JHgQsh8y4hTVlFPA5qUuGjpRqNCpKa9wa44BSGXarlv4Tz489Oc+2hEop0QKbGRAPXVPJkKSJ6jDHu9Vbe+kL7FNRtcT2SQ6QzCOBFBtqx9c4AsSGFpRWVchtwoDBCh79Gi3n2ZzCn33qevVFJBAF5XNIxJbh6o6R+1Wb416/m2wie+e40iKodd+U8JKJbET7+sbMj6vkG7DiQu2/2FKVGzZt+fqW5WjfTr9nRwyO7YQzOhnOKwT6JrXr8vX8hPqiDCFyZ9N4wEcsIZ85LNZdBZhi6m1Qe1LPmLY/XeRyWxo7SsvPA/2CjVQydVq5XIuvi1PJc948kJM9sNKnKtezmdWvVAaFXX5nRk3OkR9rOkAstVD6LMVr9e3KqotVps0cL/+9GmRi5Zr/xuLvo0m0V1fWX18OIOtjH2NEar8X1YudvkwMoR7WGvwLf/cS2l0LeHz5tbYocEnxn2WnW1HMbcDCGgTKBwlkvZbZJ1e6KRQJVLmTXjkcWi9gtjK31A3G6/wgwamY7W+FDELnU73o9lxanlE607s0COENZs7kTNSUiG6WDSq8YTXKU/FXwDjMAAjqyD34lHiTUUrZvIpW3RXJngdRmkQpl3DiUhCgwFJCPj1km5fMVmuB0FL54V1K7wPTMH79gNwq0QruNE59JjZ/SIyb2kw0BTmsE+5hG+Rx3t1EDkvNYbNEv/t9lEAF5NIGGvVM2Z/ZcG+QU4FHVpaHHBi2Nd3LGl4POowoWplcr2yXzlNlP8xb4QCYBX0mvaW0qTYs/fFX+9joP48TWUfDgycXFOQIUhnK4NUc/oLRi0mmIW2PlxseuPsyDwd817wNG6v6Ltmv5XlmctUlYhceQpLnuQlNIK5k+3OgHgvOiUneLBQ3dTFHiKY3hy19j49Ne2JAU6NJ+Klo3N7LDFQNFBMD7K
 0XRmBs7L
 fzKLEBe/WW8/XMQz+JQJOCgzFS4byHLaHR1Hsa2CcSFFqk1wz2RsBR8F7D7xTFHG1ScjwJYQ+nL1G6i5+lJtoo5UHUEGXYr1nnlGZZPkRdweTlnKKLyFtSJh0AFDrY1KsWzmk4OVPXZi81pRMrXbZWkWeLq3JftqzLD9fXfCi6CUyQEQTWp+ii4zVUEfMS72I6Ba6giFsuJ1Ki2x+rff+6MW/MbJfnALLnh7VwBkfzq2pj1iKE/WkJ2NbbJG4Vy9l3tlu45Il0kw0/4D8AQCt3nxRs7xpc0HdnbFnSujgUWIxq6irMHQD9+NbPtRp3mr5qPg5I24r64zVrquMaJ0Di/8db085DedUzUcaDBEyo5nTS8ShupZpHXDpR8+mVm7EABN8t+1ow41BhvNpr9VKuhD+FO56YHGrba+93qUaCdt+bds3TCUMa4033g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Adding Chris for visibility

On (26/10/29 11:26), Sergey Senozhatsky wrote:
> On (26/08/07 09:25), Nhat Pham wrote:
> > Hmm we'd need to collect more data in our workloads to determine, but
> > if we can compute compactable ratio (freeable_pages / total_pages) on
> > a per size class basis, can we just skip the size class whose ratio is
> > too bad? Would that at least cut down on the vast majority of
> > fruitless memcpys and lock acquisitions etc?

[..]

> ---
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index afff1b25b543..72542946bc53 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -157,6 +157,17 @@ config ZSMALLOC_CHAIN_SIZE
>  
>  	  For more information, see zsmalloc documentation.
>  
> +config ZSMALLOC_SHRINKER
> +	bool "Enable zsmalloc pool shrinker"
> +	default y
> +	help
> +	  This option enables the zsmalloc pool shrinker, which allows
> +	  the zsmalloc pool to be shrunk when the system is under memory
> +	  pressure. The shrinker will attempt to free up memory by
> +	  compacting zspages and releasing empty zspages back to the system.
> +
> +	  If unsure, say N.
> +
>  endmenu
>  
>  menu "Slab allocator options"
> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 7ef80e0da626..e0d7ab9142bb 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c
> @@ -276,8 +276,10 @@ struct zs_pool {
>  
>  	struct zs_pool_stats stats;
>  
> +#ifdef CONFIG_ZSMALLOC_SHRINKER
>  	/* Compact classes */
>  	struct shrinker *shrinker;
> +#endif
>  
>  #ifdef CONFIG_ZSMALLOC_STAT
>  	struct dentry *stat_dentry;
> @@ -2050,8 +2052,9 @@ void zs_pool_stats(struct zs_pool *pool, struct zs_pool_stats *stats)
>  }
>  EXPORT_SYMBOL_GPL(zs_pool_stats);
>  
> +#ifdef CONFIG_ZSMALLOC_SHRINKER
>  static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
> -		struct shrink_control *sc)
> +				      struct shrink_control *sc)
>  {
>  	unsigned long pages_freed;
>  	struct zs_pool *pool = shrinker->private_data;
> @@ -2067,7 +2070,7 @@ static unsigned long zs_shrinker_scan(struct shrinker *shrinker,
>  }
>  
>  static unsigned long zs_shrinker_count(struct shrinker *shrinker,
> -		struct shrink_control *sc)
> +				       struct shrink_control *sc)
>  {
>  	int i;
>  	struct size_class *class;
> @@ -2105,6 +2108,10 @@ static int zs_register_shrinker(struct zs_pool *pool)
>  
>  	return 0;
>  }
> +#else
> +static void zs_unregister_shrinker(struct zs_pool *pool) { }
> +static int zs_register_shrinker(struct zs_pool *pool) { return 0; }
> +#endif
>  
>  static int calculate_zspage_chain_size(int class_size)
>  {

