Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DF1C606AB21
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 15:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=PiZ6pLno
Received: by kanga.kvack.org (Postfix)
	id 7CAE36B05B1; Wed, 28 Oct 2026 11:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A2346B05B3; Wed, 28 Oct 2026 11:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B88B6B05B4; Wed, 28 Oct 2026 11:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 47BA56B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:24:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8480140120
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:24:03 +0000 (UTC)
X-FDA: 85372405566.10.09B0886
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf30.hostedemail.com (Postfix) with ESMTP id B06CF80013
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 15:24:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=PiZ6pLno;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.161.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793201041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2lKISFaBYtFQkl6whcZ+TLSbktmxJHBA6VayRzr31Z4=;
	b=xLOSDXQZJBBexF306LAucWF0rqspc4UfFBAdBbL8hC1Qy5kb/Oohr/dbFJwNOZTUc36Zm8
	7UytM6wpxEmGbDGd25Phzu2Gim+IilyjNRfgMVp7ql80juyGuCb/vjmOt6ytAd5mpIRuV9
	DyiUnEoIPO2AiF/xD+WByLFrJXsDq/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793201041;
	b=jxDr8OxqbY3SONlSiHW/MGt6hyDiRn+Fs1tFpj9RvekruOSIEvjsFhjNZYpnjQDc1RCGjY
	OGx5O6JMXrxoJwGaAj7LvnlTki8/XnMKVYLIVNd3TInhaR81o987JA+IwNkhpcKgmD2K6S
	n2qJx6KxggysyMSwQkNzmOuR2lmTbnQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=PiZ6pLno;
	spf=pass (imf30.hostedemail.com: domain of chris@chrisdown.name designates 209.85.161.41 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-6d68de53053so612835eaf.0
        for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:24:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793201040; x=1793805840; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=2lKISFaBYtFQkl6whcZ+TLSbktmxJHBA6VayRzr31Z4=;
        b=PiZ6pLnoBxPHpJQbhx0SpQyviwHDTIPLppcpiLvVgP5yOqNKp7KnXUSXGYWjC4vfaT
         i3f6CiBBLgDemEz4HM1Od+ZcGyD3Vy5SJSScDJSYPkfRC0pCT0VSzFqLaW1CivTOT60x
         gWr9fNl1L6sdgDtbLQg3lKHAzT7iCODGXAUXY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793201040; x=1793805840;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2lKISFaBYtFQkl6whcZ+TLSbktmxJHBA6VayRzr31Z4=;
        b=OA7S5SydPqhOpf1ugUYeCVf9wX3hTjIfmAWc7X2FyQT73NY9+QPVx5xdLCgu6yRJqx
         YgV5bzR3YJWqx0oWTPg2DPSThvBmqhzI6og77vBkLVrd5gffg4n9F6kjfULCrdP/R5ar
         gI+ajtojr5ogpxUllisRsUssI+fALiWj7Q+4tY6KbJJkHi3n3JB75kbsm4ZKV6rYWCAq
         eKePK2jiDYY8fmCrSECqYu/BxWPUC49S1Oo/i65HVFduZaKb1aBcx2XRJRcQDjzFA+F8
         KQShD2CODsM71d12SHg3ke90UuiF+iYXuRqmcSfk9XXYJwlOiN/ItWT/OghKyZShKORO
         6GYw==
X-Forwarded-Encrypted: i=1; AKwUvBy4ugvME4pIo27KXt0mhxwzLJ325HdHp4o1QHRjzuBFHheXGrGBAC/A9vOYOLor7+eqaIJw2arXXw==@kvack.org
X-Gm-Message-State: AFq9FYLIU7RgYll1jFO+PSbjC47KkfecVD22O+1SpzxTNf8662yAAjY9
	xR0rPEWJKKxWwKAz3JzbahRoy6wmA2uEqBigj5vZUWNw4cx6gtsJQqs9jdcuNqX4LS3eKw7nqpJ
	edbCX6iFLy2ys
X-Gm-Gg: AYBFou3Qmpy7P9uTmQUDzsKMj+0F6aDD0+QWWjAUGEoEJoscBFRwDDrRhMD7y8LSaZq
	xaFWJB544XIpOiFW5rTCj+1N4Iz+yA7NwyQB5kxbvPIVGFbzNm8zeovKQpv++AtL79o5sDiThzb
	h0NBvQiaL4QoJRmMtIR84KoyT8hnSega4Tu27AC2i6hidaWJzqgwduwPZxRzoTmJNBikWQoKSFt
	lzNlpEaTpw1iT0HaVe31RWiMko5k96CeHmLy5H79Q9XYC49fQs1HNrCDZs0hkRsS4OooWzhvcIv
	wS2WdMKUc7avoujhzK6oQulyYtIYpdaV3jyf1hdY1s6ESQyV/c9DkGUxvCJyW2f04+YZnFyFNrW
	OHJm5T64CxX7VB7uzGLZMsKjPb9vOmN6hDsqmMwdQUk3sPaiP1ib4QQvlKixWhyWjbCI271y2P3
	3yS03LhCbp+ZqfWFn1MVKdtZ3p8KJ7A3Z3DnQHnPOby19Xoi15JOZVK3oTKbJuS6gvOx/l44+Qf
	PV9uW9PX/+13hxfiqmQfERuxgxFNsjOjF/kc1o0Mri5OfEZd3OBVrjQFSxTgssa49IY+wuaTPi8
	W0r86r8pBPrQVzsiLr4ByZEBc6lyzET57E2Sfbm3xr4tGsaBhtRB+Xf8uLMZRc4DlHW0xaGd23l
	i32HO3ksyE8wxmu9atiUumE1Q2JIB9WdmAwpWZ/Pg8U+iN19m371G9Cx9hQ1yQDcaL7Z5fqiqen
	vt+nORnsokhsJ7m3HkGj4=
X-Received: by 2002:a05:6820:8597:10b0:70b:8379:c170 with SMTP id 006d021491bc7-713ee85c744mr964651eaf.27.1793201040161;
        Wed, 28 Oct 2026 08:24:00 -0700 (PDT)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-7142c736d4dsm1749066eaf.8.2026.10.28.08.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2026 08:23:59 -0700 (PDT)
Date: Wed, 28 Oct 2026 23:23:55 +0800
From: Chris Down <chris@chrisdown.name>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>, Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 0/8] mm/slab: Support selecting slab hardening features
 at boot
Message-ID: <auITixAJMfLtfa7i@chrisdown.name>
References: <cover.1793086056.git.chris@chrisdown.name>
 <16121542-acd5-4727-b64c-f8d519145b63@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <16121542-acd5-4727-b64c-f8d519145b63@kernel.org>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B06CF80013
X-Stat-Signature: 3ub4etepm8hgpp4x3kxdfsiesreeqhqf
X-Rspam-User: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793201041-584037
X-HE-Meta: U2FsdGVkX182A6sE8ClOKGZcuGzh7yxgFVAtuH1mqE4xtYFeka9+/CCxgi27md/VqBf6dX5n7S0DprzOARax2g1yFDBqGMgfKD2jXn1+p1wVwvEffZUBB58S7L3Ck+tK+dq/U0OuLgX3U6cKHKaC09qHRyYtxF8+0G8ck0Owya+ZEB5knnObn0NNWPia10Csdr6LoINltyC7bjCzpQ4eghpsY1zEaMRlVEO0gc3MhpuVSxxOdrP1SekY8UMVAHr8x7etOeWxN8oI67vaieDkqF2Bx7TmjgCo7n5slvSN4ZnICvB8B5Zu0vE4OlmT86WEkngAhiM44YWto+1BuKJO5afcNpi+hVyfmSlrw59yajfjUfgsYLpq/5msZT7Dg6dLqJLxfunMQX8qfzfzYMngT91L6yoEA8m8xVtCQvEfSf/r/mb21TFU3nM6AKCgSGSJG6mLV3VV+1mi9ysvlcFPXl/lp9A8/67pTU2OPmk/p5L/s0mYC55WKYvdQt03TpauGhpRFg/US3tVTbkJePYkYCsYBEJXG4uUv0T3OSgjE9RbIQcYXdYjPzbCGEzdcWFGa/OHiQd54cne0KMqc8tZjRU3G6wqlcNb2uWPQyrbOMHYTpQ6FzIfyANbtidUZpM4D9gOhUCwWXKTTnkNvdjbBT7LtN+NMjlxZlVEznkkLUZqQEg9s92peryKuTR4mNfz4k5eAxUUsTQTLQmo1gbTDj9alhcLOLefEmzO1OB3YgI6w7p1SaULjVs8Fu0dAFJIkqMRdgtcjnsxpQFZNK0eeRe0GT+gdD9T9KdTtTEsQXEIL+P4LDR6uBpYJ4mbqXJDXH8vhVLAHRw+jrRfbaHPfmmizNOzXisXLYFANZSMENQ1tUZES2KT97A+sB9nIWvN1iIQLfUTocrZiZ3J6NlnQR74ssBY0pKh4wqTiSoaki+5+HBjdRXpX7WlbOTa/qdGstRxFt2blK1vEPeos1x
 eQXSlcv5
 Z9gFpUtcedGX28bcLHlczUwku4LcPMU3vzwbbpfqyvC14KH0pPo+V5zq4gJyl95luAYRQT5/9j5KaupctznmDiSb94xgh/aSTlAGqEMaOACPVdmDiGSX9hYpJX0AgfjWQF35JpyYqRhCrwpvmU7kXNV7kZgYwt+b9Q1zszujlpAIrqZCh0wdKW2t6/jITflHJCEvfS+mPeB7846XTema2/dbHIYWeS9/bOLlR/sqOBhoQnlPzAypSVpOeUMsFTmxUhnvPPsoBGydDXrsykuA5oGlf8ynAiq6MbNbAdIaK5F7t+IGE6ZQPzuhO4rDZJausfc85jyU4Suacjn94/f7+T7YfM4dVca9O2LlRpudezUFJvF1Tyg5rKOWGErdrlh7AWztWb15iucKDfSyx25DWeaZjkEPajXiswxAI2srbz92vJaqEffvUu6ouo6DQevgGUcgzRwzqLj9kchLb0RerYqq6Vw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vlastimil,

Vlastimil Babka (SUSE) writes:
>These two should be only a small cpu overhead, which is why distros
>generally enable them [1]. Also the code basically only runs in slowpaths
>because percpu caching doesn't use freelists. It's possible the static key
>conversion doesn't help anything. You could try to measure the impact, I'd
>be surprised perhaps :)

Well I measured it, and you're right :-)

I built kernels from d15d7703166d ("mm/slub: initialize the free pointer of the 
bootstrap kmem_cache_node") toggling SLAB_FREELIST_HARDENED and 
SLAB_FREELIST_RANDOM, with SLAB_BUCKETS, KMALLOC_PARTITION_CACHES and 
SHUFFLE_PAGE_ALLOCATOR pinned off on an AMD Genoa.

With both on vs both off, sched messaging, perf bench syscall fork, a 
tinyconfig kernel build and netperf over lo all moved by less than 0.8%, which 
is within the noise here. So the slowpaths do pay, as you'd expect. Here's the 
change in ns/object vs both off, over 64, 256 and 1024 byte objects:

                       hard           rand          both
   batch alloc      +5.5..+7.8%    +7.6..+12.5%   +13..+15%
   bulk alloc       -2.0..+3.9%    +28..+32%      +33..+38%
   batch/bulk free  +0.5..+4.6%    -1.7..+0.6%    +0.8..+4.5%

These are from a small module which just does ktime_get_ns() on one pinned CPU.  
batch allocates 4096 objects with kmalloc() and then frees them 1000 times.  
bulk does the same with kmem_cache_alloc_bulk() and kmem_cache_free_bulk() on a 
private cache, so it keeps creating new slabs, which is where the random seq 
gets applied.

So for us the right answer is to likely just turn these two on rather than make 
them switchable, too.

>Maybe we should just make them default=y.

Agreed. In v2 I'll replace the boot parameters for these two with patches which 
make them default y, and keep slab_buckets= and kmalloc_partition=.

Thank you for spotting this!

