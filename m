Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 069FDCA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:39:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D15C8E000F; Thu,  4 Sep 2025 02:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AD88E0002; Thu,  4 Sep 2025 02:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422BE8E000F; Thu,  4 Sep 2025 02:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B11C8E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:39:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD027C0A01
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:39:32 +0000 (UTC)
X-FDA: 83850616584.02.DD0063F
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf22.hostedemail.com (Postfix) with ESMTP id B29A0C000C
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:39:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=CRjOmwF+;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967971;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xeSKYt59tE+FwuwJ50nVCu801bgC84aFDUoKejqvgzE=;
	b=oVe/4zuqRqwzrXTdJiArggwdrd6HwF/TeUTsfNS+xO4yxqslTNwy+dVXFoCj1OraYV6UAE
	A3BI4OHQN+5DEhcxh37lJH2hDgmdai/OXysZWBfwd4C1NihCeAn0vyGlNSGnIjb8jL1/lj
	0NMbPyJ0YShqvfivpwUTSkk13zNTntw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=CRjOmwF+;
	spf=pass (imf22.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967971; a=rsa-sha256;
	cv=none;
	b=vGJDvCsx+f/l0IuyHx681DqtJjB8dX7hQreZVxJi5+GMHMo/98eH245Ys50GhKwVE0t556
	1jQIc9py0SXonZNFdzy/LAmUZqvhwzSnZggsDs2CCvMyftWqUVfG3SZXagmTjCS06Y+XJC
	41laVvLwJNTFlKXEN/RAEOIwp+GJj4s=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45dd16c484dso1308965e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1756967969; x=1757572769; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xeSKYt59tE+FwuwJ50nVCu801bgC84aFDUoKejqvgzE=;
        b=CRjOmwF+u6W0+MJiiwS/jp2cGfHLeJCCR64qnVqkpmYNhnTe16nN7JWv+xwINyZPF+
         QgWzUhU/YvlTloFgew60gBr9A+wR8y16iMiq4RiDp+Ko0TovE8e0Ij8vnRYyR3gjoDj1
         NTCh5RXtaAOhAuPJaCTO/JPn0/lk1cOOJfbu/kNAx4XpVd0qIyf/aKOg6jwBXP4+jRWq
         d90z3qgMey8gHUnovcyy76YjgAKA5f4cSLVb3nkjAwqP5S3yjr/UnDIOyO53+S2h8qp8
         NA3MVOgjpWL81MHL1vYEpSh6VHMTYxgCpXb7BmpT1q/qdZH1HVMOx1vm9akmVWXCt7Hr
         TfEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967969; x=1757572769;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xeSKYt59tE+FwuwJ50nVCu801bgC84aFDUoKejqvgzE=;
        b=j9FagHyqmqUhGeB8T3D6gvm90+OVlk3R8H0bv3JInQm407QgNfRaFlyAvaHWFZpLQK
         LtEjnUCzCCQjqMsm0oY/vV9HoNKwaSLiH4nxM6B5rayjWr1WQwcbTMirmSKx4BLnIbcq
         AJidwCYIQdV8kL3YxFqnvy+b9/OApECcEloG6x6dPqsoe/734Ee098LyzaflybOtDa9x
         oz8khWDB8XA6+GtOUCYn7KmKrH05w5Rm8jYPASWM1CWkNVR10SnuVhyp455dXyon5HDF
         sNkgmRNjhpF3GSASmFayqN1PqrHRMUj1vMg/l4aIhy9EoZOMdiDh6xk0Ao9ca1GoGTfc
         fAWg==
X-Forwarded-Encrypted: i=1; AJvYcCWXkZZfIxUIjXBF2PmFugmdkfLvJVs2oVCLHxDF5dOwOSfJb+Z8Jp+mANePbu1RCPtgB0rmkARwKA==@kvack.org
X-Gm-Message-State: AOJu0YytlzWNocpkPjk//W9+DK35YhHqkRK9JBcGTGk7X3CeJlZCsdbj
	Mx4eQLcF5DXELWefBI7z7RPVIc0ueJASIIUF3dXoZf4uq90SORziHgdzH0F2ma7igMQ=
X-Gm-Gg: ASbGncuMTRGU+PWzQ6x/SH8cjCg5nL7DKWeLpg+s9fZWkuUgvGT/uDICdjOohffva1B
	0R69lWdVLvo9J6Kcp1TYdjb4c0bhabjKGly2PBTLt2kAJjG0imn+GSYF3qcA1/dN2DZIiL0d/QR
	WGPcAUv0ur5quWc534aZO4w8yCwkEQUIr97qGvK6Sixm3KNZi+1eW6q9jCwWskcRXM+0mJRqllO
	r6tZ4Qgs7uRkfREeLkIpYvA32Xn2KyLxTiqUSf0nDOEWFxoNp77GnwGq6uigEQAVF9la/+Uukpe
	mT9ifDzjlhoR8LYS2kj67wCgCx3YfR3mToljH2s8jQrGqEXc5vLvpGoXbsdwGzGgptbm1Kjez4U
	8V+BTzl70xa7L8XbelySDKndElj5kaJmBxAGTu9ffhjjlltnFqh9VhQjPkd/9YyU2
X-Google-Smtp-Source: AGHT+IFiegQ522bjOvcDiJvdCYWpwG2rkOTJd+XipLaBdBULaP3mS7skd+Ceh64ohm1QHJsIGG2LZQ==
X-Received: by 2002:a05:600c:3ba8:b0:445:1984:247d with SMTP id 5b1f17b1804b1-45b8552853amr151642065e9.7.1756967968915;
        Wed, 03 Sep 2025 23:39:28 -0700 (PDT)
Received: from localhost (93-46-179-206.ip108.fastwebnet.it. [93.46.179.206])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45dd2df4c8dsm1068485e9.15.2025.09.03.23.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 23:39:28 -0700 (PDT)
Date: Thu, 4 Sep 2025 07:39:27 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-dev@igalia.com
Subject: Re: [PATCH v2] mm: show_mem: show number of zspages in
 show_free_areas
Message-ID: <20250904063927.GC2144@cmpxchg.org>
References: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902-show_mem_zspages-v2-1-545daaa8b410@igalia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B29A0C000C
X-Stat-Signature: 16q8b6qiihqes67s6kmkxi7sx5s78oic
X-Rspam-User: 
X-HE-Tag: 1756967970-809123
X-HE-Meta: U2FsdGVkX1/JR+8hJobnrUwf1y0SVpm7MCZrm4+jbXKI9EgMXevPnSrK33r+L60TDKJL9l65Quw0guetBmniLlgekmgbpQhzPpkgaar2L8Chx/xVUCqtc+X5TagM0x6MHh1Emp2RalGmTH1CW16c9aDMOzbGSZ+q6P8msYBcEtZO2U1ynhio2brWLCRgwpkrSAvPar+e0QcQD07P68w/AurVTzqJrq+6vFK7ckD1RLu7DBQVvZkYroyHvPR0Td5IsRCEiCw+PRwaHsVMQ5IT0YdwFhdGsPCQqIdAkGMpSx9u7HtRKAwh5sHqnZZB//U4fkG6Ne1geDNvgs1wpW9FqJi8R44Jk+RMHNUWpeTjV5RKcOfwJ8Fa1jxyRw25eKrbCGSeVvhg2ISsHUyHE71Q3yWVwXgE5xoSAbQOUCXSL2lPt2l6uPV+ewgc5bLyNSzNzH4vzI3XJXY+CFhpeY3zjz2D4PN2Fd7okcRs9f7tofj5cP1UGdhyYsUXmyyCblvj4DOWd6Hd/h9GHdGJplNVcZgjcw6n30zclsJleoLnnuAe167TlZK1bZOUcPEXPEN7gQ/1/C1hjVBH5RqmKqzKyJYdN5JSI79l+b2YoCUrTzEGuwT+se/LQ9cGcuIMWaBQOPny9q6yb6GmsDLgbLPPKuXw1ZyTFKyd/gbt/XolQJdkgCpdeTHdzYDaIuPaDtVBZPUxO+E1LS1LMAfdoGTLbAcCzKh7CGV0kJa0bm2LrOYJvJLbJWwIpeFTWVnyh9qeymGgH3X1LIk8cD4QgFKvJQXgoQyMpFPA+iE3JRcF1y9olySpH5NlW7pNVs4kBdC6GP9y30WJJQab1T3TtAgTb8aPw/SncZErcBVpADFV86pLzzoX9s86g6dMxKGDOvHbbOMcgJk8L5cTLsyvhPhSCb0VYkQhzoPylwTLqB5nnJtC2tEvcxkqgDbDP0FujFDc440o5mn9gQbmYsNQrds
 om+ONl7E
 9acsK+t/I/d/fP/I3fnHpq8pBc7++WsG9XwQLgB83MgbYwZGsxdt+yjY/196t0t/G7KrSkt4do4kLA/L04j+GikJ7CpAyDiLkn2pbY1TY3UlNywbz8O5crWCPIdcftOa87n54t7YvWuLQaUq0GL+6tewWEeivvzJq/x2WyTrSfHJaf6laSZ7U3PPn0bYq0cTs0BBMHxweFJK0YWjUtu2ZbjVVGBX+ri+tA2SOOsAJLvsqKKs+IycuqlU5L+gScSK3cJZMzJYBtJF7YaoNQrE9fDUWyXGAoqGAHfA6YjD2oJLlMcahORb1dMbgtuKp/8sAjPWDFNY2ihLnHinrU/LUqnpzl2rHgfAQS6VYVAZaRBCA5GxbBgn5d6QeGZJ2UjsXwultoZQsfaSc+StYermpD4FoUxIwm0UIoiha3WozXTFlaIPbszgYK9RAxFa7CPqAVI5T0aWWmYHHG1+gGROWvx8xvgvjfrpAfLp9f/4i5XHzKVHi7pafmzz/235optkZUvtsh42ZDTvuVmtmgnjuAeHFEGcyHrkeo9eQ5ZysLSMbR8wlUXfLy9yIjxBdT1tbM1/GC7ESyvYNshcucR2yDVS6ng==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 09:49:21AM -0300, Thadeu Lima de Souza Cascardo wrote:
> When OOM is triggered, it will show where the pages might be for each zone.
> When using zram or zswap, it might look like lots of pages are missing.
> After this patch, zspages are shown as below.
> 
> [   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
> [   48.792962] lowmem_reserve[]: 0 956 956 956 956
> [   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
> [   48.793118] lowmem_reserve[]: 0 0 0 0 0
> 
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

> @@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			" inactive_file:%lukB"
>  			" unevictable:%lukB"
>  			" writepending:%lukB"
> +			" zspages:%lukB"
>  			" present:%lukB"
>  			" managed:%lukB"
>  			" mlocked:%lukB"
> @@ -332,6 +333,11 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
>  			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
>  			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
>  			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
> +#if IS_ENABLED(CONFIG_ZSMALLOC)
> +			K(zone_page_state(zone, NR_ZSPAGES)),
> +#else
> +			0UL,
> +#endif
>  			K(zone->present_pages),
>  			K(zone_managed_pages(zone)),
>  			K(zone_page_state(zone, NR_MLOCK)),

Longer-term, it might make sense to simply iterate enum zone_stat_item
and enum node_stat_item and print them all.

