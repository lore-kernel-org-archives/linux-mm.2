Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1AB1CF6BE9
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 04:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D886B0092; Tue,  6 Jan 2026 23:28:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E34C6B0093; Tue,  6 Jan 2026 23:28:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFDB6B0095; Tue,  6 Jan 2026 23:28:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0FCE6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:28:21 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C089C06B8
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:28:21 +0000 (UTC)
X-FDA: 84303886002.18.90FDF19
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 80FD4C0006
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 04:28:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="HdF/iqCd";
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767760099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHnkuioL4uAKz+quBgfo5p0xKOWMA07CTVehzvC4g0g=;
	b=oo6L9fZ81mv8i40RAzdlTgsFyo7Z0nZS8NseA0jy8GjvH1u+UntoCi6G5rRgjNv5/3PAWn
	SnhaSZbFjKQeWtLplv22j9J7BSq4G03qkGHEcA2VKRtdvQ/Hf/kOeYtBlVboSsZS7FuLi8
	gw5J4F+Xoj/3AbltpzV5hLSR8wJtup4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="HdF/iqCd";
	spf=pass (imf22.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767760099; a=rsa-sha256;
	cv=none;
	b=LNslg82PLk+qv63GKShyQmHIeMIvOjLtDJYFkxvmM3hq8B9eCu9vX6yUBiwjkLKoIrM4zq
	r+HEWA3qboKxwY3DRWc0qO/Q2CojLgMMwP3I10voJrhZkRSBzOTD8zbtNptZoDO53QdasX
	gAT1t0nQUWk09vzW+a2+CEGB2tWJHYU=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-34c93e0269cso201385a91.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 20:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767760098; x=1768364898; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lHnkuioL4uAKz+quBgfo5p0xKOWMA07CTVehzvC4g0g=;
        b=HdF/iqCdRVTVKg7fcwJAKr1mKm0q4eNev2IH1qNLLKIV9VuyiV6a+DgDtEoHXBzPQb
         kBW2tdNQS5ZfsgvqU/d/odWhwS4y/SyDHG65JPil+jF+51J6eopihpH1Lq+6umUA6Fs3
         X3GB4gCjq53PTkKyxU61PAOf2DxEVsQM1QcqE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767760098; x=1768364898;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lHnkuioL4uAKz+quBgfo5p0xKOWMA07CTVehzvC4g0g=;
        b=PDwQNlcovNLHezmUjSyqAVKpVS6LrQAFc9auveGadIHHs3SupKmhJhlW24jWVbvVDK
         7NXJiqCJdnCjY+An0gl5l+VwU4gCmH8orv0wNIfNTmTXhVfI0nHrFJ/WDXyHRjvsM8/n
         oZFEhseaiRYAzVxppvQiVWpuO830GtuNdyg61mx43kDq9xsLdaSHelEwEBBfZxgWmHdr
         HxwR7Y38ehhwVaDl8F+6xE/93wMy20CRJbSWsnNaOOWgEg2Kt8r3Bf5PE1haC2xH5V04
         HXHL2hjOwPuCg5gfONx5/O+UYczSY8RgwN0uaVydppUi1j4moYYI/zLe3WtSF5XrfvTq
         zuEg==
X-Forwarded-Encrypted: i=1; AJvYcCUORnsK7NYwS2xnzhx+cctz8i6OehyOQA1SCVIGADgJAvkuvMiNGdKpGe3ziRNAXhl9tSg6cf9jkQ==@kvack.org
X-Gm-Message-State: AOJu0YyvFkccgYSHQWmDl/Ump2u4HYQC4/6EvkINaVxUucmKRoLMFrvq
	zc3IDix70j1m+Q+hTPFbqASQlu74hbaaJTN97a3xsLruOEmTcDjYqFJC5uHiP8b1aA==
X-Gm-Gg: AY/fxX7RbQJ6a5mKZ+nYDgKWTWhAgpG+t7WJ3Jld/mSjTTosJQG/acI6nzHpxWGdA7D
	pgti2MeLIW4kV+BPrsMptM5mmhqxzUP0bqKUMG99eIadiKWublqZlAyl55wslCXEh9m7rb0V2xx
	dAEkBJ+jZkJicDiYMWF1vVqcBnc8ctvBWyhed40rCfb1LfayAEVbn4M0Fh31HIFweMazhXJkTaF
	VOxf8wViDpuDNQAQT06auDbnNgxpknzu4jbizWWSDKX90SURqSAK/FpKLGJZ3h2Pdbfb6yijZJf
	M2iXNyVm61HrrTIq8/wVp3K7btcfME7e0JnWDDWlMMeIhDp3RVvc2QHgPno4jbmhIrU8FVS8Tl1
	mRgooBjnFU7qNTlrR4KYu8hVaN5NR4Azi8g9OBCRq8yBQzCu+Ulfcf+yOCCyDZurl8MRutoHyKz
	WItTSkk++uJaR39YMmD0TzHTxzOEw5lg/YQ/7lOV2EuyX92F07j4g=
X-Google-Smtp-Source: AGHT+IGeUQkxH4Y6IawwUJQJllB/6lg+8Ctvx8R3Cj+8E1aOahzcqPjitaieJ2XpuHPozrGfu9gLJw==
X-Received: by 2002:a17:90b:49:b0:340:8d99:49d4 with SMTP id 98e67ed59e1d1-34f5f831cabmr3930755a91.1.1767760098369;
        Tue, 06 Jan 2026 20:28:18 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34f5f7b1d81sm3584165a91.1.2026.01.06.20.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 20:28:16 -0800 (PST)
Date: Wed, 7 Jan 2026 13:28:11 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: zhangdongdong <zhangdongdong925@sina.com>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Richard Chang <richardycc@google.com>, 
	Minchan Kim <minchan@kernel.org>, Brian Geffon <bgeffon@google.com>, 
	David Stevens <stevensd@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [PATCHv2 1/7] zram: introduce compressed data writeback
Message-ID: <7bnmkuodymm33yclp6e5oir2sqnqmpwlsb5qlxqyawszb5bvlu@l63wu3ckqihc>
References: <20251201094754.4149975-1-senozhatsky@chromium.org>
 <20251201094754.4149975-2-senozhatsky@chromium.org>
 <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <40e38fa7-725b-407a-917a-59c5a76dedcb@sina.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 80FD4C0006
X-Stat-Signature: 5qzep176z15im1pqhz4d8e5oghaahfmd
X-HE-Tag: 1767760099-982200
X-HE-Meta: U2FsdGVkX1//h38WoPqdyixnKnx5XpeCmkdOWhImWP0gVqzD7gTkhHZSiza30X+zD+clazSiNYm4OsagvFB2gVNSQlT9Ixo5iP0QApUbgqa12G2jTpV4CH+Dt3heCNV5gR02pznf23tGDW+wqQBlsy1RCKp3j0iJVyqB16MbBp0AX3VYQnzl7OuRv56nzXlMwXfRYo5xikHjhhUuAe8uRl8mHrCiJKEX+DvMpW5RDd1IwT27X8L0j1p/5Sh2tAa7LZ5gpmMlf7uUfs3f8ZgZc/oIxhjbBukaBHLhwtd+B5iQPteZwtelLTv1uIuY6grSVUCABkgqbAGS8cKtwZbdYxY+kaFfg1DiA0fu9uZ2lb4fzHIs2di5UvUJWa9V8pLPtbWECRv5RERLM9+Q2gjtP56Nc/lFLf7mCQe2kqTTezR24ine1m4lCW3lLhwSH/AbATiJc7iUUzShooNJCMdVfjdW9RabiLpRcNxMuoVoSAmFPP4yuZ/27P8qwpyAEIQwtSMSOuW9ATAeH14lNzaLX6chej2jwqm48zZLtHIuk8MmUxQ4v4xY7i3xfrLNEVoDgjTZ/XvUAK4BL/Oob0yOUMTGjgfTt2XX/pTqiGQ6wzHG/IvlclqQ6wvFZphvf1bb7DVTVgaE5SJVwK6f3/lRz8zNm3GXzudYWIxKXZ+T4qq7+2mSTcOIoJlJFazNAE/Nv9d7gjJUNfsrcuVFo136bHQXPSAIum3wKxehuLwded+yuHZGNnDTPSLqfyP3HqvDFroxZnypAL2Efa2I7Z0DZlYRhgYf89VqMiwhdCXtsEZuzEJTXG9yyrhTmEv3Gao8ZMAofJQv1DPUmIs1q/QDNDazgxZeVo6lmJY1fEMqcAngLiQyeTIJb62raiZN7C1t2A2leR1HBa7r1zv418onLMEHYmgfIWlwB+1hp4kMzyNyMVq9DdE9PePSjRxflMDOLe/gczAQ8o5fE4cykxA
 xiPPu8z3
 m40Ikng3ij7CWnLycyM/d7gXsFWBE7z1k0CmiKq/c2cPVE3zHJPRyEotLjlVDgeDeOLDSIke4/V/BbtuR0UXo9RqQ9yqkk7VnZyghcdjZgXtbSI5Tx5Z5zWg5b7uoRE30HwHcgA0D0Sa1IryphBLk4qG4Bm/AazEgx42M6qQTJI/uRxjl2b5vX4ZYyhFvzSjJmUDFJofu3Whsyz5PLndX+oUGnnJxRDzJE7I7MpO0EuzVlL8r8x8h/pgI7NyqcwCejBe+8M8crbkJ+ENqvRLlYxAJGwF/kHTOnuhJ/GfY76j0cOaQNk+hm6tLg0nCV5fZ8u/27ph/J4Noy7I0jTxTHzQZ/51bjgjB+iKRRCxbCVa06jgz+Sgjp0JAR/FWSGhOFeQq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 11:50), zhangdongdong wrote:
> Hi Sergey,
> 
> Thanks for the work on decompression-on-demand.
> 
> One concern I’d like to raise is the use of a workqueue for readback
> decompression. In our measurements, deferring decompression to a worker
> introduces non-trivial scheduling overhead, and under memory pressure
> the added latency can be noticeable (tens of milliseconds in some cases).

The problem is those bio completions happen in atomic context, and zram
requires both compression and decompression to be non-atomic.  And we
can't do sync read on the zram side, because those bio-s are chained.
So the current plan is to look how system hi-prio per-cpu workqueue
will handle this.

Did you try high priority workqueue?

