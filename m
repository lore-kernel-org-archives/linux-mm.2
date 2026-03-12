Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22062103E302
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 03:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39E336B0088; Wed, 11 Mar 2026 23:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34CB56B0089; Wed, 11 Mar 2026 23:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22E666B008A; Wed, 11 Mar 2026 23:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 153136B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 23:05:14 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 92CDB160687
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:05:13 +0000 (UTC)
X-FDA: 84535919706.29.BD95A0D
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id B04ED40007
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 03:05:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="T371fNb/";
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773284711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVafNQGOmqCBcaIXAXRVtsYI4i0x2w5zQE36DJ2wfDU=;
	b=VXrGpGuKYLrUB3XBMiBXRkdSyLZ1eLhW6G5wpAP475kmrIEKI/l1gj8+s9feleUnMzzYId
	vyk35sKq1eXhQy4Ofn/y4i+AowaREr5+O7eCPMCSDNtadj/GqfzTVMQotNvR4Zochjc+v+
	mVFSGDNCQ0w9Xv49wp6laxPr5qlVDjE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="T371fNb/";
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.51 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773284711; a=rsa-sha256;
	cv=none;
	b=TmyuNL4MYyKsFNAqRPrFur5iS8FucmN6v8mfScfMg5HJqTXzFgkF08fuF4TlyIBWsLNJZi
	xSRKKuKQluWmaWsHGOe+6nNTOpI57UUOtlF7gVDziSOroRJmXA/9vSuFYEgAtyUMzSCLOf
	0nyMNIIgvd8ssVqK/cYwM7rnsOMvoeM=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-35984cd0335so714295a91.0
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 20:05:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1773284710; x=1773889510; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bVafNQGOmqCBcaIXAXRVtsYI4i0x2w5zQE36DJ2wfDU=;
        b=T371fNb/O1ehKFG+HNZXhd9FGhVwvHMBwzT2W7u50P/Z0UcQQRXHu6O+CeUPGf/I25
         jzqF2ZtR/Hs4T4DMCag8vbi5YUt9bO4fuXuvBXWPoyxjcokdWWUmimm9zPSy6MChWmNR
         NZtGrgRQXZ/zwswtxhuu6+9DArha0fu0j4j7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773284710; x=1773889510;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bVafNQGOmqCBcaIXAXRVtsYI4i0x2w5zQE36DJ2wfDU=;
        b=h1Ef+/49ygsGY3nbPi+NgdwAGRNmihIPdm2g8O/bzuyDGmYCDFwokyFqkGcaVQ+sD0
         J7VJ/zHwtKaB2hZb44bmHu39k/k4dMXrD2PQzquBaeMSBs5ofPWwR++vG/jwO+deMwVb
         E8/xMnHLUx5IqWoVThdyz7mhz7CTY3RRJzt/wcwB59Fk1wJYJOPqA/PiJ1YIB3t4ZBI7
         adwAPn4sZdD+jeB8cnNRodltZUrMfNW4YWwZXpySWoizEEEWqy75/7a/4ZKgtLAlEcRs
         0C+BpDiS8IKRqvF+RFIfKQKZtB/cp3LFoR3DYi7i/ygt094w6t6lS+E4+JaFsZDw+s8r
         IGFA==
X-Forwarded-Encrypted: i=1; AJvYcCXPkwGj2ebt0Mll+Jfl1/sX48kIYkbuOCQEADiQMQjh30xKjSK9okl0LYe6cSaXnRgULnmv2+c16Q==@kvack.org
X-Gm-Message-State: AOJu0YxZIrrF9ubodPakkjNsGwzAswL3KizohkDickW7s80y/IouBMxy
	xa3OUxW2cCvL+7HlXLriyxlO0NXXD/LAUQjQIufir658E37lew32GbN9265ZcB1DXA==
X-Gm-Gg: ATEYQzyrBj4pYwHBsIPMUsReEyfmYM3QN5r8Yre2+tZ6px8q8uyteu9cutDAm1Dem6i
	O/RBOgCNw7aiBTWOguPilDva/2KcxJdxQe6aH04HngyKP2eA/l5VP28v2z3RK4ZOZaOKKJrdZuM
	re0jtUQURllSyqiqf+qnjjjeHcSs5L3l4Rq3vs8AchEmfABzTKe8BbkEhXc0MOk9+cnYUZzVYDL
	3AjSz/+KknpR8NO+fFpZ6uYFIGNlrHXj3qSYWuo5RY7GgIaEijkdZ7ArI9M0X+N/bHaGD+AFn8x
	fimGJ5Xmmkgc8L34SpWJ+igC0Sj8p0Fnm1sgwKKiJ14MQ/6CAofOPjqSjuIbbJvicoY3tR6DCeB
	d/OjTHgvw2CmmoB1hcbxDtjB6Kf8PjTN/kyiazq9ceXyQ7RWO41Xw98FqmH+Y6JON4rIRrpS7VR
	jRqmqwioYlOHUuw1pfz7rpSj9VMB5H+CvIdoc6gXIHgWFl5MSrfh7tk/KYqEzAQJw=
X-Received: by 2002:a17:90b:1d92:b0:359:ff9f:916a with SMTP id 98e67ed59e1d1-35a11a06aeemr1634661a91.8.1773284710478;
        Wed, 11 Mar 2026 20:05:10 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:8bb8:36d7:daf6:bf85])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a02fc8465sm3647444a91.9.2026.03.11.20.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2026 20:05:09 -0700 (PDT)
Date: Thu, 12 Mar 2026 12:05:05 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	kernel-team@cloudflare.com, Matt Fleming <mfleming@cloudflare.com>
Subject: Re: [RFC PATCH 0/1] mm: Reduce direct reclaim stalls with RAM-backed
 swap
Message-ID: <abIsoZHvJExS6A3b@google.com>
References: <20260303115358.1323188-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303115358.1323188-1-matt@readmodwrite.com>
X-Rspamd-Queue-Id: B04ED40007
X-Rspamd-Server: rspam07
X-Stat-Signature: w11d937f639zwy3dj9axyz34jgukcfbh
X-Rspam-User: 
X-HE-Tag: 1773284711-639698
X-HE-Meta: U2FsdGVkX19OeFysVHZdA3HwqH0WifD0zg3Y3EoUz0NdcppAO1i+rCVon4L1ZoBnKiktNQ7cYjA396I80yofBjjm4EKvwLdqKofdIakgZSppYJ9JQ+LkJdXTQGMEDpyQ0s3qL10tM5ygOutJNkU4OFv+Uv7gtulo0wJle5wnYOpxn3QUVn6pqXhAAfR05+VoHTN6lG1RvQWHFnUN4HztCuWmBb+PxovUN+ohc/U4rHrLqjmDBOpysBLkcPCkkRQNWVET8G+dvxrWhsye4Sdi/VFBtJbWeq4PcKApCK0FKeVKtKDxBFN3D0QsD/YqeNWY0EPWPIp+5bV+470mi+Pr3comSqweQaL+iHfDdiVb9mfsWiD6g/d+SqgAGJnGw09o3Gm94ijQGFS9cJX/5qsRsLMXqgWstSucuwWl5F5OZAAsblCLX7tQqDTKTvFJ25SeeOvv8ZRcn7cUQXenLymwPDZBbk2Aq8ikSMt7dLFr7HeMATaPDrhpKXRx1/rPm9zYloWDT11S9D8yXHfdnXfhOZuAR7us94jRXNf7cumpB64O70Xi3QPEQqFHEBa+vTNkJUO3uV4UNhDux5OMQTnsIQ8PJprqMBCmilowGT7NCLCjppHQUOzIG4JA4/A6ZvF0JjLV4Av2OXvism9WddmzOztYCW/+jHSXm/6/LAviXgSaVAMQUAHuuCwU9mhUPHWsDR6HVjz7z+iFKBNdoX+kift9TFC9+ydqsMV4cB8cAE8dF4YoSIeEG6bPtG9Cm0Od+6vqqUd1wBzI46h/XalA+a02pQn9XH2KYACVt73auefdsSzr7JeUuQEahfkYPnkfQJY5OK3iHVA3equJLd1R5Ne2j9ESsdH1/bXof+UiYY4BaqiCB7+SHwQ21vUAx1tNTDU++XDfZZcyZE5U6q4Tf8V01LmHceRDhvBUzRV8AQTsEbrjEGb8nxmdCSGjKvDL1m5iydzMRu8NVPNkH1s
 co89x8Rn
 rW/gb1ySDMSUp9ejuGaxGC+vW5VyL0fA0wJe0ao6EQ57xXExMBekU+/DC5zuCx/dL9WV4zuukuXceJxOjWewvJqO/9QLTt+FWNlG8g29QESpV3loNc+LeGhfMuHtZed7Ohqrs5iH2iSEfYOyBb0xM6URskSGg6iV2e5gJ1GoQvj7qX1QkXlbPowjmgFCy7qWGSaKn0/hd90ltd7jpvlzsYl5crtfsxogjVqYaryTTjiYcY96PN6OG1YV+ViG92CovbUaNb5+FNK2l8A9902Ywmh8NOHOKSTRMXdsnPMCdxXngAU+eGCFqi353UsEsa6pdYOeo7nPtZYzqdb03I/9VKpxZqcHVX3dO6fFZfxuSgLbQQjY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/03/03 11:53), Matt Fleming wrote:
> What about mixed swap configurations (zram + disk)?
> 
>   When at least one disk-backed swap device is active,
>   swap_all_ram_backed is false and the current behaviour is preserved.
>   Per-device reclaimable accounting is possible but it's a much larger
>   change, and mixed zram+disk configurations are uncommon in practice
>   AFAIK.

There are also setups where zram is configured with a backing device
(a real physical device) to which zram writeback pages, effectively
releasing pool memory that they occupied.

