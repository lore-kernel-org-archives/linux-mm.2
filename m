Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4889FCCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 14:54:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9760F8E0009; Tue, 21 Oct 2025 10:54:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94E5D8E0002; Tue, 21 Oct 2025 10:54:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88A738E0009; Tue, 21 Oct 2025 10:54:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 784628E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 10:54:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2F02F16054C
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:54:32 +0000 (UTC)
X-FDA: 84022417584.06.2B12ED6
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf05.hostedemail.com (Postfix) with ESMTP id 38BAF100015
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:54:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jGZ6xyvQ;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761058470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+Qi5vS8iEF7QtyXh07bja2k/V4HvOygxjGkF4YKo9MQ=;
	b=dbFD1KGVuTBtPP0hX/ByvsY0D3Un01y02FAvkNXtsGZYBUNAuTWJRoSF9xqHG/Pd9ddw4c
	skWCSnzHKOs0/d2Kdu0gCpinonR6NKkejMdO19Rmwy6BLMh+PRSURIC5yKdD/j6WykOEBg
	Fj39O1wN7iQa6erc5CYXv9FMIw/UK5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761058470; a=rsa-sha256;
	cv=none;
	b=vDs9tqADSsbzpj67Yyx5hn9zvMaWO3KJAWsHUnJQqT5oVCe6/NzWdsM0KkcqROMdruQFtb
	JjhWv9mK7bGHq+98AVAg69wftO0nfX19/qCLL9x+vCsbsYEj2b2hu9Z/ee8GkBK2qvgfJ0
	SIuQVBCs8nNX8w8w0DphcMmoeWZut7g=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jGZ6xyvQ;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-63d97bcb898so7955357d50.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 07:54:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761058469; x=1761663269; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Qi5vS8iEF7QtyXh07bja2k/V4HvOygxjGkF4YKo9MQ=;
        b=jGZ6xyvQ2r0Mupir2KDVa/jEIt/nq/6C5qKRCHsQqqQH86285IIcrW/p/ylM7Yav0f
         sS+Gzsq65TxGwtl134n/Q2O3LGmYv5Z1M1i/guuuMPsyVwgmZn+KzWulXGLQ4tk1kzhj
         qT0DnHm4sdJ9E/eFWt7c4HZ1Cxep62WVe28N80pv/IzUGGKAFPvh18w4D9Vy/hphlCP2
         gOc12BDcXURFS7LJIX3GSJQOZ4blcQAVESdg0HFKCxnSrRZj7fDaxdXhT0Wv6Yy4+0ZG
         CqAqcCyaEItyodQwbIG4ucTllQRBsM5TyQDMGmY15E+GYPg+nqzdkYjNno83m5pyJAYH
         SG2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761058469; x=1761663269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Qi5vS8iEF7QtyXh07bja2k/V4HvOygxjGkF4YKo9MQ=;
        b=qDqEUM9m3EyxjyhSfcFzlJEgtHLbAKEZcFuRndR53XTmmwUUvC6x86WkcnYUBNegwh
         cTR0RHaqxOlLWsUWp2DwHzEjcJixE0GHddyJUSqRuJJZYW71D9kKa6J2slMHdZb3Rk2c
         e62Wzg5l5geLscLYiQScvv37nc50OHecpxnI9zGRzLqrk3AnKteKAEjAAeIsal0fngyi
         u13bUqRghVUhHuxbi53WvDgQAx71UkbDSyNkuhIN013tgO8JMDYn8qbe1fycQvTGFQki
         eCE6pXNu28Pcxa2yzNeNW4ZKdPl0Bcb74/KH+4QkuNWxxlZs9tLSE0vPQPgPwd1kUoSu
         RjJQ==
X-Forwarded-Encrypted: i=1; AJvYcCXItre/yg6XkXYmEVxkcLMs+/x+2aZpZQLly4w7tR18UjEtmkQgLgBhHd4ioUzhRXAWd1gqa0yfSw==@kvack.org
X-Gm-Message-State: AOJu0YylKVt0w0ge23VXqibXiOjBVNDLwolW3xNm8N2Z2iiEPBq7pf51
	Q4dvp9mi3G0bb7r3slmf7SLMyiqmwUqlXBAhapFCNwvNHZIjFDMSZdV5
X-Gm-Gg: ASbGncvILDcaI/Q0TspLcRCej5TMqrpoSy7LuObrVMG4M51jKF6MdBbzjv11zuvNZRL
	ALR7piTeLmbFJ4dVe60u2XfCBy8dESkVf/AaSFRsF+XNGs7woyzMlrjEiR3iA8Y+Ld/DGkzv2Gh
	czuvKkzTAhyf2jPuJyrRIgnpLOvsKubtqJGQgWlsFd+Ct8ZhhXysAQXXJ0nvtcCZnp85wNUp9Bz
	22VPy2eMVlQKyJ0PueDv18eoSO0WRxQh9W04x1bynqJVgiydHhXx8KUWKzcMh16f1ObkLWXs3GL
	pWJRXt7UI2mvWIrJL0s22+aN1BMcUsSE0MpaQqgYuZdxfSkqLRPdZ9RW4jlt/BeaJiwUsNWuGKU
	bACgolnAB0m5EfNSCtyPQ8CKnN3Yk2HnMyOGYGpdD2abDQX7D8imEUClqna1kAt3o+roJOJInBS
	fK7niJyqOZCg5bDW/t4BtQiniKpiilQiaQMyNf1qWe819Sz2jAAQ==
X-Google-Smtp-Source: AGHT+IGxPdsEqlA6SzXzoXcdF+PZJOGhAIN4Wj/cO37w5ASLEJUIVOHCB/yQlrssEQq6UGl9fxNsCQ==
X-Received: by 2002:a05:690e:4195:b0:63e:2286:e6e9 with SMTP id 956f58d0204a3-63f27e387d3mr48108d50.15.1761058469224;
        Tue, 21 Oct 2025 07:54:29 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-784674d6361sm29679307b3.38.2025.10.21.07.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Oct 2025 07:54:28 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: zhongjinji <zhongjinji@honor.com>
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	liulu.liu@honor.com,
	feng.han@honor.com
Subject: Re: [PATCH] mm/page_alloc: Consider PCP pages as part of pfmemalloc_reserve
Date: Tue, 21 Oct 2025 07:54:26 -0700
Message-ID: <20251021145427.3580609-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251021095004.12157-1-zhongjinji@honor.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: f7jtgeirf96extktssmyzdoa7y4twne5
X-Rspam-User: 
X-Rspamd-Queue-Id: 38BAF100015
X-HE-Tag: 1761058470-564256
X-HE-Meta: U2FsdGVkX1/qUxGuqLQ1mpkN6ViJL33I4cWO/xTx6pIJ7vrUxwEAqjxKWAFegctt16rZVJMo5LH86tOdGzalD230PDJcruGH5E+2WmEqc50kzmfIQku7tcGGGt2vywCVEDWBZprqqU55uxvyZ3GfL+k6uIOMVWzCftquApAWfY6gUHXisDZoLSeoKEYIU7GqwKonFHdJ08786z/4+Gd/qO1rjdNOlD1SSJMOuVUHl3hOPc24GcVimZPpBRAbOgIUBXYF9vXx7BDKcgUrVuctvAyIt55kSwjl1x2pdw7Kv+dJU/mS3GW1982XeqigDVhZ0CIXpFwdEys7/DotiH5cFyLa3gHdVvWIvdydoZPaT+yCdDfcAdCjbWFKZAUIx6zO3ztFdPWQdQ0bxZFjxBKiyRiqsx6WxwCS4q+tmYVYPpzPUfAYzOP2Ev7KiRUf3A1I3hOixRdvHsnqiL6G4wCFpInmBZjV9VWT22hlF24BXiBA2DPf8jClfnP8WQXS1LaOWnEzzVouYB8xLc7QMk1D7dpLAxtOX5P9gfOn54C4fhf0JzkAM2g1fjYGK6HSkAX/ufbcgdtow2KEvRzTTaRpZUD3bKyflOJK+xrFaLzoXfjGOEpyp9+w1jur9H72LQrFAhcUGLbXg3Q+NXCNyC6XAzfhcoPqw8SmujxdQGSobh9GRCDiSKXHMeVtngIOyKL25X21kmSk9CbwGTjoa8zA5I0O422gEs+jFvZmoDkmCZovGC7i49FoU31Jyy2S7XBMgvDNPel9lZnqChxhf5jznHuT12qeWx5+Xm5BjQav17BmK+9KefOnplY66ej/laHJ7CSu+3iOjJWUM5chbL9vMt6ZCMIAublI/n1MBjxX7pNY6n2FwZSx+cjSfEZddcCeHH86F2nW74gswEuRjuxIz9ivkRhpGCs836VbD8P2FGB5vW5UoKu2GFZp8WfxKo2Ea3h2EnSHWqXeQGUjjiD
 DVSbDFWM
 nDGU2yRdtInEFNqDx2qXUdZUCbHaiSlmwQBGIgKRgTWJudDbj6E2fid42wVEDOqkPVW+bo3HoxT6Vb2pgAaxHuWH7M4gKSkDxuItbhjV+l2aHfum8c29PZ8xY1mf8ZGiQf8UFFB9JhsGTHMTZX0RL6MRUo0OLHbWMpP+jUZpQtMZ5u5UFTt8tm1d35NzkMsyUTfsi2a9HXNN/5B1PpkF3nuvyqzvSq5xvkkdCaFYYnioGv0sJ7Mdja+qoaMP6ij3WvPBoC0UiG1jAqR9Sye9dTfh3xrl/50LU4m+DzccSE1FWEfbh8DkIlHg+pOZ/fUvbSulPfWfwU6GAasFxWE1Ouq+pxBKn9VeE9pZazrLaAYrCArceQpWw7K78r4k6sxU0CXwk84YJlHky1jYs0/SEp9CgZJAtgnJ5B1u5iE+rtoTiOGC9As75M0P/XikANciujiVnF9mGq3WgVZbJ04TPVjBMx/WNRL4sVsv6h7mdaJW/DlZFXYk0AjdhW286FKylLPpVuvb3rNtYl9PC55Px7h5/ARQMESgRsC2Aw1hCVcDAMrkpUlBZpjnryERJI/m47H7nWwa1lGpPgU/Y0J+hjDYGV9xVGIkOjq6ozBG7A4rzLf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Oct 2025 17:50:04 +0800 zhongjinji <zhongjinji@honor.com> wrote:

Hello Zhongjinji, thank you for your patch!

> When free_pages becomes critically low, the kernel prevents other tasks
> from entering the slow path to ensure that reclaiming tasks can
> successfully allocate memory.
> 
> This blocking is important to avoid memory contention with reclaiming
> tasks. However, in some cases it is unnecessary because the PCP list may
> already contain sufficient pages, as freed pages are first placed there
> and are not immediately visible to the buddy system.

Based on my limiting understanding of pcp free pages, I had a concern here
on whether this would really provide the desired effect. That is, the pages
in the pcp are not available to the buddy allocator unless we drain the pcp
lists (and this operation is not free), I was unsure if there was a clear
benefit to allowing the system to go unblocked.

If we are already at the point where we need the pcp pages to have enough
free pages to go over the watermark, perhaps it makes sense to just block
tasks for now, and enter direct reclaim? Allowing more allocations might
lead the system to be in a worse state than before, and will have to
go through direct reclaim anyways.

Please let me know if this makes sense! 
 
> By accounting PCP pages as part of pfmemalloc_reserve, we can reduce
> unnecessary blocking and improve system responsiveness under low-memory
> conditions.
> 
> Signed-off-by: zhongjinji <zhongjinji@honor.com>

[...snip...]

> +int zone_pcp_pages_count(struct zone *zone)
> +{
> +	struct per_cpu_pages *pcp;
> +	int total_pcp_pages = 0;
> +	int cpu;
> +
> +	for_each_online_cpu(cpu) {
> +		pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
> +		total_pcp_pages += pcp->count;

Could this be racy? What is stopping the pcp count from decreasing while we
are iterating over each online cpu, over each managed zone? Under the
memory pressure conditions that this patch is aiming to fix, I think that
there is a good chance the numer we get here will be very outdated by the time
we try to take action based on it, and we may require the system to be
further stalled since we don't take action to reclaim memory.

[...snip...]

Please feel free to let me know if I am missing something obvious. Again,
I am not very familiar with the pcp code, so there is a good chance that
you are seeing something that I am not : -)

Thank you for the patch, I hope you have a great day!
Joshua

