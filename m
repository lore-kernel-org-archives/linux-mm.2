Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE3C6CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 00:21:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0CD86B0088; Mon, 12 Oct 2026 20:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4056B008A; Mon, 12 Oct 2026 20:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD3BA6B008C; Mon, 12 Oct 2026 20:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 81D146B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 20:21:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D1C81160AD0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:21:55 +0000 (UTC)
X-FDA: 85315700190.25.1E1D1F2
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	by imf31.hostedemail.com (Postfix) with ESMTP id 128F420003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:21:53 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hOIAbn74;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791850914;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=26R6QjZja8iwEgaIS7NPevZdCEiibaTu0MopPJ7UPos=;
	b=z19CPJGipTCkZGplzmHFO2te/EFAnEXoa1WGMiNjtF5kIRFTPF5tcle3rp1/0U+ntVS6Fx
	vT2PAzLIaYtu1iR6iZ1F45ZfRQYEWB9Gd13NuIG34EQZfLvaccqUAu4GDDg9gLndXP028I
	SNabLC8j/11HnJl/H9/B6JIr6tONOxk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hOIAbn74;
	spf=pass (imf31.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.173 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791850914;
	b=hIF7t1wA0e4KNVuvdUsziEjmq+sF3KDQIf1bZmo+o0RxKxdEk/cwvJRbkv77S+Ce+eyNnS
	yUclrDA4XuWi6G+B3OrYD7AdKuODZ4Q0x0ah61QCy4oMzPDwhHRh7C8LviCSAacNhgOyO7
	o5rPKXc9scI04SH46np+1ElgRNMKQo8=
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-33e6279a1d7so1400011eec.1
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791850913; x=1792455713; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=26R6QjZja8iwEgaIS7NPevZdCEiibaTu0MopPJ7UPos=;
        b=hOIAbn740NMUM3BtT6lm1NMbh9jfPOCWQqRG8NZZsUIz2WVU9ll0i3lt/MOwMHiyIF
         fVUnS9lHJqTouag2VXmU1XHktQi5sWDnGFFFmzQvUFo6FgGfdSCg7boDNbvmopZVKp1m
         ZmgDgaYeiqvcG/dkbczu5mSNtc+90f1Srq0escVmJCMYnJqfPCsEWjuEVI/50PGoccsV
         ecq4hpw3ZNNcjlgmb7YveSmn7JZYEn9RP7V8gKDqOna4cnvbOTBVRCoM0vO9cdNyNZqb
         BVXx+iINz33ha4HFI68SxEH9GMVmI3HMuoRN8rJr8SUxGDLaSo/c+bMzhbt/biaH5Lzr
         dZSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791850913; x=1792455713;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=26R6QjZja8iwEgaIS7NPevZdCEiibaTu0MopPJ7UPos=;
        b=WaFiwvCCTvs5X3TKLk8dhNjp5NrTHsJMfc05xNY/tU5ptsszaAybedn86eunf1nNPZ
         z9DJ3KkoIN/31DPOaFUyomupMAJRgxP/lF0226t3f12m6lREFS6VFzd/QydQ7qTjsSnW
         wTQI6jGcFa6+RuUqUxpEGSsgZ5UUdIgO0Df0eP93fl84bjtJ1YVA4RqkSF/BitYU87KA
         U2Qs+96Tui8M3z823KcsR0+3f4pGU14Cy9wIQTqIMdbEu5pXlWve1WrX0ZvbhzfLNEF6
         9/naZpTuCkY+sUGa1HZH5KuSpel7XTD1MvK7sbSE3Fgy2sZY7GHJL1jYBAWr+PK46D0f
         9k4Q==
X-Forwarded-Encrypted: i=1; AKwUvBwNioqjUa1+wTg5jSCHEWB+V645VVlscdXni2oeXv+i9rUSGviAIcRK4bibeFhz45sEBH5jtOINow==@kvack.org
X-Gm-Message-State: AFq9FYKT08t8rbrpegDPNbB6I4yj9dVa9ILSPwRFJDl8kbsJzVEmHzSd
	/aQLFRdE2Cp/8fue7lqoqvyPX8pJIw5xF7zPTm2AieZSFv4+X26KnAIO
X-Gm-Gg: AYBFou3Qo5Gwd8n950pfEq8aKGa07+iiK6XarSFV9mDnJWCJk7D3VrPCjfDyF6+VwLB
	8Q5YZe57hSt60H3S+4HMSZ1r4TrRO2PAy57HJNRkbKdaqn4BlpOnJTcb0hAumAag3OCexpDu6IM
	gmx9DklX2LQmMdXeoN9/8rlKPm//DaTxc2JV6pokc6PKqFxftUsOqZLIBYybUoIO0veyFcaTNu4
	EeoFV/PS1WGhkBnoCq1jflgZ7L+zaFoOzm/nQIF6i1DOGQsMI0DoNvA1W6JB5uOoJV0ifnMb8Xc
	YNlk7I1DTdiHmMfdcswSXLyXgQqwAFg/2Iw0h+CI/4uk8Px3uUxO2E6lk/hrgR41OyCthF5AKd+
	EUNkLEpn3gf8XTxYGlfjGGmDtmkUdSrRicj9Hr4EAk7Tw/W7A0wHBn7iUfalXiH8MouNm30hI62
	bggNCJokdzd9+Ar8nWN9IiUlsJkt4gSeisQekpqty6Tf0b9/HN5vMt2urRT+1dfn+HJIAwUg8EZ
	KoVGuh/pF9UhNAp2ADuHw==
X-Received: by 2002:a05:7301:7d16:b0:350:2a5c:56c with SMTP id 5a478bee46e88-3537e08eee0mr15924457eec.20.1791850912519;
        Mon, 12 Oct 2026 17:21:52 -0700 (PDT)
Received: from penguin.lxd ([12.187.136.98])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3595e0858c6sm23646723eec.22.2026.10.12.17.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 17:21:51 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: usama.arif@linux.dev,
	akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	kanchanapsridhar2026@gmail.com,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 1/2] mm: zswap: use separate compression and decompression requests
Date: Mon, 12 Oct 2026 17:21:40 -0700
Message-Id: <20261013002140.28880-1-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261009163146.83112-2-usama.arif@linux.dev>
References: <20261009163146.83112-2-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 128F420003
X-Rspam-User: 
X-Stat-Signature: swaro6gt13bx1d1598b93e6gt3k5ky4f
X-HE-Tag: 1791850913-480714
X-HE-Meta: U2FsdGVkX19oN2t32ojzGBxSAv9FxHiiwc7mZ4fo5KvoTYzT2NKQqeri3Kak1dc9gGlLiv4rmjxQkiqfHb37nruuTANR56x9awShTq2IyscHg6TrTEFEW4hfBPt+us1LCApMjmwrA1CAqM+3OUfpPxDIRse9yc7uEkA5o3YUnHkYsfzNwIxBO4xuLRb2F5Yaz8Xy4Tnia9WtRPNY8GuRp5K3d15W+gzfT/nsilUvq3+pu3AOXPTXAdLY6tImRa6/wXzkFAvLH00VcoyHs+KNaz6Ys/Y+Jo/0IQeNeFOIMGtJ+yrq+NPIWaam08fnJwi2hwnG9Q5YGW7G6wqg3R0JAQpmfG+VYwTaTN3mmNWYwHbP0aWhvTpuetU0EO5qzkthhAHH7fUlLOjgPP7cHR4OZU9HaWthU8s2LCnHh5ItYaQNOR3IV7wZDwPVGoYQwZZ+ruoRTHVHWfqF+IY2swCSHQUn+ztaeBwL8K04GWCKf0eaGEJmDe3yyLuaGx58OkzUhqQS56wImLb9aI7CBrip/fiNQJyawPJl/Oj+wGCQQ/0eOuDtL00jWJNUulCjrbiJmpRobOBXIigLacSfikSdhiBarx8qA/SMuOuXM6/dkJZ74Fv1L088P/O7QxTN01B4XXoKN/M9nGm+niZTTphEL97NoLCY00QuluSgGbLnWP+Dmy/aKJv5hLZGI67JYr215H1I4IlB05o9Hy6DctIf+zbgH4pc38ASvEs0eHFWLYH0QiDQM0xh5k+XQ2Y5Dq855ScPhl73y93k4EpkZmfo/6YnIkcecv9JFxLNgPh1KuiLUbhgLBOihwTg0gQKs8xxrCFlDFmWBl2pboOH1+jbzBreeI+i4ACzr/7GNLSpSd1sZfW5E6CWsXDQTIFNptv6txkw0aNfNVfY3e6Smhv3rqv7/o77UmKwEg7ltuo8epP+Zs9Y27deZx1nJUreHYolWxEzZZmrNqw0/R5sNmr
 KT0Oq2b6
 BStgD3yHkWUO7eDdCiI+Xcjg2xGzgAIjKCnVJxIsPCzzGLJgKy5le57/Xtu6nTbY1S3t2ICMzd3HDtgk1kyNF/EzCc6rqDy3lgxMwnvco1gV2fOPzFFyMEBdQAZu3ipZ86x8M3NML00+vXLslXm0zPSLpyPO7nmZKRjau7rCSPIom8Q6bRDLYpU6ViSZfU9U0l85q1Kg+0x4ewap1MalPulfV+ouaOMGrMOjZLsZGD418k0uXGWeN3cWSXura3mCbeeGsC1Tr99Kr6kZjATsafEFH5F/IVda9+0qxLXdbjz6JjoNJvr7cA1JygIdxzpsMQsNtcw7nm5tTocus5aNphxNR4FxQnxlmOPAMcl/WygD77bVCr+sbzHI0hupr1r4TM17xzfzTdUTWdnNysFq6b0FCQYRogTJNsPZmDnQ2wTFdV5B2TiQmC+2H1/tR5lx4oSCr5kVGUwAGIkXFTSOl+LBy2iqFXflhA4Y1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 6:31 PM Usama Arif <usama.arif@linux.dev> wrote:
>
> Stores and loads serialize on the same per-CPU acomp request and mutex.
> A low-priority store can be preempted as soon as the compressor drops
> its stream lock, while it still holds the mutex. A higher-priority load
> on that CPU then waits until the store runs again, which can take a
> long time when other tasks are runnable.
>
> Give compression and decompression their own request, completion wait
> and mutex. Since commit e2c3b6b21c77f ("mm: zswap: use SG list
> decompression APIs from zsmalloc"), the per-CPU buffer is only used for
> compression, so group it with the compression request. Independent
> requests can share the per-CPU transform; the codecs and drivers
> synchronize their shared state internally. Loads can still wait for
> each other on the decompression mutex, and stores still serialize on
> the compression mutex.
>
> acomp_request_free() ignores NULL requests, so drop the check in
> acomp_ctx_free().
>
> This follows the proposal from Sergey Senozhatsky for the same split
> for zram [1].
>
> [1] https://lore.kernel.org/all/20261005122036.718976-10-senozhatsky@chromium.org/
>
> Signed-off-by: Usama Arif <usama.arif@linux.dev>

I have a question with regards to this patch. Is the intent to allow a
decompress thread to run concurrently with a store thread for a given process?
If so, I wonder if incurring context switch/PTE/TLB shootdowns performance
penalty is worth it?

With the proposed change, will zswap_store() continue to run on the "old" CPU
(i.e. the one to which the process got migrated), or is it a requirement that
the "old" process is in sleep state? If so, should we codify/document this
requirement?

On the new CPU, is the same process "runnable", and if so, how do we ensure that
the "higher priority" decompress is handled while the zswap_store() prior to
preemption is still not done?

Thanks,
Kanchana

