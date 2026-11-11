Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEC7B606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 04:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=NpTzVifF
Received: by kanga.kvack.org (Postfix)
	id C502B6B05B3; Tue, 10 Nov 2026 23:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C00956B05B4; Tue, 10 Nov 2026 23:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF2896B05B5; Tue, 10 Nov 2026 23:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7709D6B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:20:14 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D69C81C24CE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:20:13 +0000 (UTC)
X-FDA: 85421535906.09.833B834
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 03C98180004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:20:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NpTzVifF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794370812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tUypj32nZSwBas8qX97kQX7vq5hG+6Yam8/Va9N0Am4=;
	b=n1najiP7MQrm3qm2SwEzt7L+T1PgYKE6V7dTx2ZQRzjMyuLHD11zbSnGVWhf/Gnx1ftIIh
	Hf8F2fn60kMHYDfqdQMPly8BuehFukdUwK3MErBVOzh26bgi8goxk+t2PFHwHCyLrVsNOM
	mm0ThVOxEcmP4RrjH2/G+gaQ5UD7LKk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=NpTzVifF;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf06.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.215.172 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794370812;
	b=YpeStADrnr3hO1dUJIgwh5JX3ZGYUx6eCGMysTp4nlwZPjkJgziZJEPIkuEG15KV5/XkaG
	MhCHRpf08ll+EN+UtdPItF9NVJe7ys4ligNoiJXNxCKeTWcBHImG4h3u49/cUJOM2mpEXq
	kQ1MJQJCQr5oZCBQQEdf3dhGUJjzunk=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cdd4dafdce9so1130783a12.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:20:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794370811; x=1794975611; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tUypj32nZSwBas8qX97kQX7vq5hG+6Yam8/Va9N0Am4=;
        b=NpTzVifFyfUwmLvWd/HbernrMEu97PJYGgwLFg3B6IH9dJth8zT2Pr682mP7KIzasP
         pZOzvNrrtNwrUsXOOa/EM2QO+Qw5uzCnC140XeOttTuSFGZClYs9+XK/2fyweiYsM+X4
         Wvzm4jxUewr0zSjNgeRSANf9+DHV/zTSp7KQg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794370811; x=1794975611;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tUypj32nZSwBas8qX97kQX7vq5hG+6Yam8/Va9N0Am4=;
        b=SENxinFKoo1lJx/bA7oXT7Qh8nVjMcKoBgJ6VN71wA8i5+YHvtXIcHmgIzn/fqok9q
         vlx6YUTHyRD5BvoqrOFHU0XyhFOrvCEnpvd0bVP0mPLIvAAYskkafhduRd2AvSAWGe5c
         BMxeRNNve9yROiOVadbl988QukW9HlR8mOBYgHoSe/0PWVKdJ7E1kAQ38uRLHy6cXZhM
         8rhyjFzyNpsjacdCkl+ZjMo+TgjuFfs+x2iQpKpt7mIHyBpkXngtGX4kZeNVTjqjMTJ3
         5NYJl/81zeChg/de70KXBc8G3gQdNVlbdgYdqrEkO83Bqryqt9ej9jdkIUgr2W/9op91
         tPhQ==
X-Forwarded-Encrypted: i=1; AL+hErEmnSPfhwRCfe7o0n5+LdQBhrz/Dh8sXnpkjn/UYRQsBvqU9I92ZFaTdpaapscw8Aq5u0o+t/UsLA==@kvack.org
X-Gm-Message-State: APuU4Z8rB2QPe5vX5ovI/f8BkWdeL2UhvH1dPWt0b+bUzxcuWLn0W6st
	TZ6gSsJdV7HPxEhnE+YFN+ho2feTOOQ6MoZKkw8rZxdCVNeu/GCwoLlYsmSlQ5DyAg==
X-Gm-Gg: AYBFou2yXGaN7iUQQxbI/NLvDFIXCINJdUAZAHRaYDBovpsZRsMboWhZRMN/cH5uTbu
	Lp/5PG8KD9hte7Mz1QWvnTYJcAzvgHG03JABldAIK+ZGpRsLIf0oXUL+/fP8kHOeVQ2egy4ltO/
	Squn4nPPXW+B470SwzQxJRtAjQN2v6FBE8dbEIhdO63YfgbmU2cun2bKa2YtmSgVB7CTcH/D8iS
	F2hsD1ByJnDeSJSW1BetecUfAoKFiaIvlaNNzuoWudj80gIFzfrCpNUVPKKhp1mgU+4XV/KLWE6
	BS5IIoA19wx+ahpLZ8+G0La8ttMMYWP76wmoYFm2U4qjZXzgNrJXd+Iq/DGPTivy7c7QaPv2yZo
	MPrTIs1H/UZZuxuTZhhrIeMG4qWohY3RypMmGjE9/uRRvEzwSd9wYrsPjCNToR5tje+uABmgmiM
	TPemkYrmAvNsoKz+zOSpu06hOneC4Pb94WgLoq77UqEqmkh4Jg95G2NPyU19eQmSkwgA7+sGpbr
	94vBs2sXfYu23ayQqAYoJMQAE/94VOTm3QYo7uMl3s6JdIcq1JgHpMonjvQzD2jsW9SNZdqWK3g
	lU37/oDbsGs4xyR6UfcROdDTVfMfNzpZvPaALK438vGVY5uHQU8s4MPUh7auuOfkGi1XhA==
X-Received: by 2002:a17:90b:37c3:b0:3ab:413:49bc with SMTP id 98e67ed59e1d1-3b182ee2462mr1396102a91.37.1794370810775;
        Tue, 10 Nov 2026 20:20:10 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ad6a:b446:df00:78dc])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b17e0d0e16sm2532464a91.5.2026.11.10.20.20.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 20:20:10 -0800 (PST)
Date: Wed, 11 Nov 2026 13:20:06 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: sashiko-reviews@lists.linux.dev
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, 
	Richard Chang <richardycc@google.com>, linux-mm@kvack.org
Subject: Re: [PATCH v2 05/11] zram: check mem_limit before allocating
 zsmalloc object
Message-ID: <avPshTNHkZ5O64Xf@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-6-senozhatsky@chromium.org>
 <sashiko-outbox-207587@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-207587@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 03C98180004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: pkecya51sryn9tg3mpzf6fd84w3qa94z
X-HE-Tag: 1794370811-485395
X-HE-Meta: U2FsdGVkX1/7r4jZitB9feOl8wWhFmUQ5IJ6BNAM0JJGMeKcSwR604/gdII0M+DVvG5E/tmjBCKJFqJ9mFkEopC4ZWM1dZxfZE6O2hfKVy8ZKDb7KQ4vJOvO3/D7x/rfJGnrb+viYI/SiBeY9Go0DQyJTdCvF7EsOhD/sgFYFA33mRO1dbpXpzDnCuJnnt0t4dsLOdLMMtSMRUK63YkcI9UshSyM77bJZD7zqMaiDcKwYsbeugRNL4psuMQ0RUCb/n7Pp6v0BXyCEs0E8DMdsDSqOZYK9hQkjmp3z1ZcMwfPUDf+oZlWsDvkXIpijVRp2sjscj+XIJ7KUYCCfkA4j43p0aIIQ8zKqBz36LqA1I4V73pAgmu//VRaQHqeqSRupdMRZoJuDvsfS1IGe42qB6m0bwy3OqNe9taINdLly7WQ8xVxhXVDel/y6VYN9dtvUgfmGowjSDeW0efabjFgfZgRVRTzOV/jBKZB3JJabLh08+Z0b+Hu/pQw/r5dDfiYe8Nxt8t347q12w7sH99/SFiZq9TuN2oTL5yB/lSoXQuwv17yUaDxMn535SlT9wJNi+sOlrN6cOwDoe7p4Sz+4teUXLhOpG5u+a/kCvGvBK4fHcFk8xEKgF8S+xOAg4ejIFcwDWam4Zx9y2i3fk+V0s5gSt7KWrJ4zc8tU2yxGbJK/6uV5GLJ9AAxqbkBjbSjBWUuL1z35yLJy1/7EvTP9C+l81Q8fa2wsnDeY6Vgxdu9x4S/9ztZYO16OIkaUoiu9ojswATtfi+r0BdYxxM8W7/puRS8OGo1pTGd4Ut7zPXzgd3G9nPqQ00i+soYib7weZPR0yXlDxt/AioaVlkTnB2QP9+XZ0xpeNX8P5MMYxQ2vrfwoP984iCUBoDRVlYvniDiGMXd2/xyK0v2Sh9+vUZdDQfwTmJaMu3/3mLk65Myb1mZIg2egeQP1oDwUHESVxa+La/NsdfCVHNl3XH
 dHcScavz
 ZkDB/Ty6nb0WpkGU1mbW/SeDJwGEBHv+scSFGOVghQMXGdxzuk6E3AN1X1iY2DZN/+dTwHM1NrTxMNLyMJPaPG4FEFi4wwOMTuy+j+7Bi8rzfhy4QNbs2tY1jEHHFtHu0vyh26huArrmNIoIk6OnKbO/FCdR6yF+MDe2RRAc4s5IWAOpCeA8Eqtlc5QhxAoh+8CpLCP/cRXhp4yzZ7He34azTfiZqLlFZ6146LC2wM/WQP72etvh3r2YAc9y+K0z5YFQaL+uzqNGuIexjN3L+rGb39Z9NX0fHlQw0mdsCFULYaOvP8LqMeb0eqVUC2R1yURZYhZ+Ql2WWOn0pkWkYmcrOTVBQgDlH9foo3ZO++Thm6xXrOJpei6j1BipPEPWVcMmiLb2016J9ccnMAKvldMK2T0Sb1FYTkpW/Bsropf/kxNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On (26/11/10 18:37), sashiko-bot@kernel.org wrote:
[..]
> [Severity: Low]
> Can zram_can_store_page() return false when mem_limit is cleared to 0 at
> runtime?
> 
> The write path does not hold zram->dev_lock, while mem_limit_store()
> updates zram->limit_pages under it.  Because zs_get_total_pages() is an
> external call, the compiler reloads zram->limit_pages afterwards:
> 
> CPU0                              CPU1
> zram_write_page()
>   zram_can_store_page()
>     if (!zram->limit_pages)
>       /* sees non-zero limit */
>     zs_get_total_pages(...)
>                                   mem_limit_store()
>                                     zram->limit_pages = 0;
>     return pages <= zram->limit_pages;
>       /* pages <= 0 is false */
> 
> When at least one page is allocated in zram->mem_pool, disabling the limit
> causes an in-flight write that was within the previous limit to fail with
> -ENOMEM.  Reading zram->limit_pages once into a local variable with
> READ_ONCE() avoids the second load.

I guess I can READ_ONCE(), but this scenario is extremely unlikely.
(I'm not even sure if anyone is using ->mem_limit.)

