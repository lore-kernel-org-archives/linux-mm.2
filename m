Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5271CD64074
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 05:18:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC2F16B0005; Wed, 17 Dec 2025 00:18:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6CB76B0089; Wed, 17 Dec 2025 00:18:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F7F6B008A; Wed, 17 Dec 2025 00:18:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 857416B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 00:18:08 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 28BEF8B612
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:18:08 +0000 (UTC)
X-FDA: 84227806656.20.61867AC
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B1EC2000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 05:18:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FSg7n69I;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765948686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2anOrP0xVCL+Jbr+Dqygt+dHRR+qw2sgfwGJ1BYaHxw=;
	b=4pR9UdSrptOM1KvZEoRil4Q/zwW0ag8ZwiqMLpcpBCaRHbDPOru80ypHM1/wVYcLSGcusX
	y1aWXjzmzOJcGAlRWdkHdIRRvw5BoffaXwz7dzms2wWvFqeZJCZOsXKHrW2QZ++R2WJSeA
	/X08qTfCjDMYG/1QUT1EJCQjIFTeO74=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FSg7n69I;
	spf=pass (imf13.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765948686; a=rsa-sha256;
	cv=none;
	b=ShuTQpY4Wm0tMQw0Qs0PVSn5gqOSFi2DuxNVBR5h7Jwhf4B9sHhqPQQNtLFecoG/BSdz7E
	/Pak1nuHF1O3wtCmHNGJ9DC7tdg5i5Hgnen2hX4r3JZ3uNWj4S2IEtKsVBBriAVta4maol
	ONDaGnDPraPjFNqXd5tD1QUcv+OJQhQ=
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-78c5b5c1eccso3037607b3.1
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:18:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765948685; x=1766553485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2anOrP0xVCL+Jbr+Dqygt+dHRR+qw2sgfwGJ1BYaHxw=;
        b=FSg7n69IdzJ0k8UaoifCLSI6cGN9V8ByPNmqoXlPc/fhkcIngeqtabp70sMBBrk63f
         JmR/wnBG983UDGmu1FXNoWI/628gNrVCrBEbufMwhrCi9ni8gr4Xm0LrGx6OcKUOMpPT
         9jh+wvJKF4LpIHmxFUHrpXpmDfH0OZSGeG/7Zju2Zp0XgQVnjDZB4sGkR2fzvGoMXKr1
         9jKORpZ+hJ3XkzBcQ9dpqdIYQOOPZsXzwvI28Q0WHDVvM046mqjo5yatKV1PGFbFcFJr
         pSiUovq07zSumOb4M+zK5sybZc2R6WsIvGbUwfQnG5biAuOUPZWan4yCNL7QrOsqmDoR
         f6jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765948685; x=1766553485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2anOrP0xVCL+Jbr+Dqygt+dHRR+qw2sgfwGJ1BYaHxw=;
        b=Gugh4ETZbIpDUUCq3vHh3lj7hwoDKAhwz9f6ggb7Lak7H7J0NZp6TIdCjIrgn0L09S
         mOONB5YteQCe7E/oA7xWGXCDI2L4kbi0o2L/EWQCG19Q6f6W8vpuhxxtleaS9fq1QYNy
         HUNs60oZ0ELYPHthfDv1yecgG8Eg9oT1Ey+PJzKR9RT9QGVzJ8DrPvVC4gjA6rfLKQHm
         h33p1Vj/YY8Gk7L3RjygrS8dBBMSlKjQdwLl9kg4agzYC83OLpZwkUMZN6I8JDKcm4iL
         Foh3f7fDjCYB88U4iCjoMQPkL+ad+oZOAiNe8x92O83Wq7k/BsuPGMqmIGi5uzNB7cN/
         OfMg==
X-Forwarded-Encrypted: i=1; AJvYcCV1u1tqCStEM/6bUeAGptfOTdDj62UWNe2DYz1WdEi6qmuPbcmM9lhtM+FPoXuYw6UYt21ZcwNXWA==@kvack.org
X-Gm-Message-State: AOJu0YzVtglsjaGzqdrpPvQ0PW40cYolfOo2uyhHQNi2pcCyUv1qQTdr
	MtYjtf61fIX2JEIR1pQqJYa/SaoN3TOrjIEkyJ9SYar9+gn9Z3SKDSqW
X-Gm-Gg: AY/fxX7x9Kl/RtSOS+KU/HkCVifCID29TwDpdiiXifyrBIZL6GQ47pVAvKJtuOaSoTe
	GnMuJxYXKsMb2ror+VxsYFF/ArKGbPFh19qnabkHVUC1GsAwzvPYAifdeIDW1M5l66nFGwNa0n1
	TbMRwEqYlzkFDdySGLJSVvgTNJTjQpW3xdfMAzVcJ24T3KQy2rtXxGSBxVyCrW2/d8HjZwpwLv0
	HBvgVV74gVNlaUCnOR48QTqGRae57XUaUD4wN1zPG0sePwx/0xg3tuLQo1jo8sVtC4b4iAub9OM
	0728Wt3SXPnk+aHkevQldY9M2pZKSWI7anXCi2VR3Tmyp8gtmRWiXKMTRrtdhVlhS6Nn/9CrtHp
	mF7gbZ9gmVqhDPYLnGodjRnhMuv2lsGf2nPzJl7U95gI5GkuVKt3PWpl8L4GAb0EztQiES0Jgb+
	lkWwHFcTSvnUS2mBb9T0RU
X-Google-Smtp-Source: AGHT+IFTh5UrsnE3aPhMBKEHXPd4JmUA3m4FDvKhZSc0MEfZN0xTDRHHnB/MD9iVwyuFUiBF7ZAz7Q==
X-Received: by 2002:a05:690c:61c3:b0:78c:2ad9:b541 with SMTP id 00721157ae682-78e671a1ad6mr140386417b3.31.1765948685220;
        Tue, 16 Dec 2025 21:18:05 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:8::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78e749e5ae2sm46668267b3.27.2025.12.16.21.18.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 21:18:04 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Palmer <daniel@0x0f.com>,
	Matthew Wilcox <willy@infradead.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4] mm/page_alloc: prevent reporting pcp->batch = 0
Date: Tue, 16 Dec 2025 21:18:02 -0800
Message-ID: <20251217051802.86144-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251216102205.1d008d1432446956b079bfff@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B1EC2000D
X-Stat-Signature: diqn8zt5h8fnkixk4446jagziyjasmoe
X-HE-Tag: 1765948686-650857
X-HE-Meta: U2FsdGVkX1/3OePxYD2jrwkGdrnbD8mQ0lCRZrrHJ0imczLHyw4prp9ubrD7u9zWGRoe0sCuT8ITvLSnOgO64qDyuMNXTQtWMF08kl21mB6GsL/gFNIwqSJ446S7hB69R+cYoIcI0FM+g12w8FplI8CD7lxRUDi+Z6etaDmWmMIXQJv9kevGtapowbrGJVTF0/BoYqMnlTq2SJ/BkZ2tffac4J/bIeB11NmU38iNoO0SKKi2ExF9+T8MqR5PnI1XcAdYDd8P7AkTzxbPpqZUvHeCv0hVPbAluKYgY1sJp+9C346+jB90OOomBC+1f34xicQe4llFYmphEpMmQPbURV9E7ZZXW3u4toxtVlJjR9bdKjNRuptsJ7Xgaz2GPZOdHseZrAFdoQHmI7ZceAOi2ZnUMBWQGbkx43p9iv6j8exIKf9Nxt2cyuXLHgPeJXyosLRfTzOVAngGkQf4yLYWQKR/nJrKINQ3KVOHspYuD+9KVT9um2Iuu+XEnL1419HraYgsNkWlycxqCU38ZG4XsKuKuL/scl+bKEgxgUGjLloqVG71ETMCxuD6RbTERbqtI8Hevl+h7XiRX6qOod1fJe7BBbmoQD/IYW30tJaMns3m+kuThr1AEOQ5aLYQtBBEaXmxdlIEBMWMQ/6Tvo60S79bXKzBYoe3Z0FKb8R5MSC23MoKbHeRcne52mhn+vq8DPB3jZ4psGTdDDY5KAWrXJ25pJvNx2ud1zJvcJwtTZnwfGkHCcD6b/cWz8igL6qVzTZTeCC9j/ag9o0eM/wSewtaok+ewR1Mkn1kNKe0N9shQLu/kuE5oNocefVqEElP6NMOfzN/9VsYcm1j8yxRZrrOxZeOZY0Alkj6iOq1p0wWzx2w187REbcC/jNu/YiykCeHDySGIKWSIcWzLYHPOJ2mM3XwENNgQduj9//B49uv4a+NE7ogxu+ZjBNQ8Ziq0Wg42qFwoBVKWVqf3hE
 5WxzXgEP
 VrKLRT4pzw6Pz+Dw1zrs0EUxchVd4jHlARLPqbPS2XC77w/bu4acNlAPSGTc6/QvpOE3518oFZBDcCh2w6RszNhQGMtVgTdKSTIcBuM/DhRzCdsmyJwyYmblDrowxZcwul4fVQr/wJSOjH0HRugtFTuDikhFLq04hyjxPYZlFiJA+mSNIalcD90oimPLWnY+xftNhwoA/M9fRctt4B937ZH1swQu7KFcK9B3NgfZL05KGGKSrhYvGdWF1g2PMxPguEJXOYllmSbFL6hh3dNOjh5AFmAKG8hYFas1vFBK3mxtwDwEfaDpOnlnnR9aA5lZf1HGYDd24whQF7QPOQdaSw57hf0GQhZmFdyrXdZnLLkv8LMaXruVXlY1eyR2vkUxY7IGrrrzdtkWRQzPxtINKcmnul89F5VTWX/nq+q3XsVfb3mStpdAfrNZrRpsph95Bto0RpR5w4x32nin85/svsV7UvErZN+1LUgaLoEsK/vmUjqvcA8U9sluLNJJ0BThbzpulN+cOwguDuZJuIhTgfj10lQ0d4K6U9nRi3HltjeCTEGlamLCAL352r6Ub5w6ZBYrLn8Nmw1+qyw4lX0JUUcrCxprazMjoed7Ea0/liUVcOzo5COsYpBq5xJEjfj4Q048Icl/HYzov+zZtt+qKvDbLEgEx+J70lUBZaUha9LXm8FnL1UbWaR5fig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Dec 2025 10:22:05 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Tue, 16 Dec 2025 06:48:11 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> 
> > zone_batchsize returns the appropriate value that should be used for
> > pcp->batch. If it finds a zone with less than 4096 pages or PAGE_SIZE >
> > 1M, however, it leads to some incorrect math.
> > 
> > In the case above, we will get an intermediary value of 1, which is then
> > rounded down to the nearest power of two, and 1 is subtracted from it.
> > Since 1 is already a power of two, we will get batch = 1-1 = 0:
> > 
> >         batch = rounddown_pow_of_two(batch + batch/2) - 1;
> > 
> > A pcp->batch value of 0 is nonsensical, for MMU systems. If this were
> > actually set, then functions like drain_zone_pages would become no-ops,
> > since they would free 0 pages at a time.
> > 
> > Of the two callers of zone_batchsize, the one that is actually used to
> > set pcp->batch works around this by setting pcp->batch to the maximum
> > of 1 and zone_batchsize. However, the other caller, zone_pcp_init,
> > incorrectly prints out the batch size of the zone to be 0.
> > 
> > This is probably rare in a typical zone, but the DMA zone can often have
> > less than 4096 pages, which means it will print out "LIFO batch:0".
> > 
> > Before: [    0.001216]   DMA zone: 3998 pages, LIFO batch:0
> > After:  [    0.001210]   DMA zone: 3998 pages, LIFO batch:1
> > 
> > With all of this said, NOMMU differs in two ways. Semantically, it
> > should report that pcp->batch is 0. At the same time, it can never
> > really have a pcp->batch size of 0 since it will reach a deadlock in
> > pcp freeing functions. For this reason, zone_batchsize should still
> > report 0 for NOMMU, but zone_set_pageset_high_and_batch should still
> > interpret it as 1, meaning we cannot get rid of max(1, zone_batchsize())
> > in zone_set_pageset_high_and_batch.
> > 
> > Suggested-by: Daniel Palmer <daniel@0x0f.com>
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > ---
> > Reviewers' note:
> > 
> > This patch was originally a part of the 6.19-rc1 pr, but Daniel Palmer
> > kindly reported that this patch causes an issue on NOMMU systems [1].
> > Thank you, Daniel! I wasn't sure how to credit here since it was a
> > report on an unmerged commit so I went with suggested-by. If this is
> > problematic please let me know and I will change the tag.
> > 
> > [1] https://lore.kernel.org/all/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> > 
> > Reviewer's note (to Andrew):
> > 
> > This replaces commit 2/2 of the series titled "mm/page_alloc: pcp->batch
> > cleanups" [2].
> 
> That series is in mainline.  2783088ef24e ("mm/page_alloc: prevent
> reporting pcp->batch = 0").

Hello Andrew,

Sorry again, this mix-up was also avoidable. I'll be more careful in the future.
 
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -5888,8 +5888,8 @@ static int zone_batchsize(struct zone *zone)
> >  	 * and zone lock contention.
> >  	 */
> >  	batch = min(zone_managed_pages(zone) >> 12, SZ_256K / PAGE_SIZE);
> > -	if (batch < 1)
> > -		batch = 1;
> > +	if (batch <= 1)
> > +		return 1;
> >  
> >  	/*
> >  	 * Clamp the batch to a 2^n - 1 value. Having a power
> > 
> 
> So this doesn't work.  Please send along a fix for current -linus and include
> 
> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> 
> and Reported-by:Daniel and the appropriate Closes:
> 
> Thanks.

Will do, thank you for your patience. I hope you have a great day!
Joshua

