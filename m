Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4423BCCA462
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 02:51:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00B3A6B0092; Thu, 15 Oct 2026 22:51:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFDA56B0095; Thu, 15 Oct 2026 22:51:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E141C6B0096; Thu, 15 Oct 2026 22:51:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A79A06B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:51:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B630A1602F8
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:51:03 +0000 (UTC)
X-FDA: 85326962406.24.3BB32E7
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id E442640002
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:51:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FgMKPCwb;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792119062;
	b=OTbcke3I1ZGeyfvMM/bwuujepZmfMk2ooKAbhrH6zeURzBW5nwIk9Hs3iFSmU5D46XAqi/
	8dpWyPtZWubxFH3+KbKHxvzkVG+tujVjbgFRdf+mZCBqMi2sdJDqdE96NFab12m15TBbm6
	JZkX1sbxocyCsL9Y8Yibpo/u9kuvUrw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=FgMKPCwb;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf11.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792119062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te0aRe2cAvi4B71/ALfBS1DPp0JoXviSgYqxKkN67ro=;
	b=jnWJbsINMYwtn86cALAbQThfxhK6aZVsWrKNAtoyLb4cWOxn1bHoH4dQE4TVN+UXmZtE+O
	uF77Y4fdOLWiWH91/04h70PZ0KXUGmAUxdYYpZ4wKDWmiVpSVX/vZDy5Oj1GHvBDUSH5Nf
	74j+q1AiY31FYfolb56vYTnrjMzMKp8=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-89edb9bc666so737054b3a.2
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 19:51:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1792119061; x=1792723861; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=te0aRe2cAvi4B71/ALfBS1DPp0JoXviSgYqxKkN67ro=;
        b=FgMKPCwbY6wQXPI9OTZWoJe4n/C11j2Nmmy/CO9vX1rv2cc/9o19h5X8znEr8eKpC5
         RtK8e3sN5Yf8VnhKhtIdGrHwZ/Nu9+Z3WeVitAgo5pGFCY5KD5lz8fY008OSaXbFU521
         LIRJIqj5ncrtyNl7Q9QtDusEZXXQBu0N43FGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792119061; x=1792723861;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=te0aRe2cAvi4B71/ALfBS1DPp0JoXviSgYqxKkN67ro=;
        b=yVrs/wW8BDKu3x0bxK7rpU1IJLVkexuyo9Do7r+lLYQDrNP8bEb+e30VCInL19sANe
         Gv1Lueev21yzc1dcQTU6QwcvI86HlchneQfkW7Q4fv1SUyAHkUullO6zR1qfzjprlYfe
         fQ0H4KwuQmxVrv+FH/tZNMVpfT7WqqaCjZGHtrXHNyF/U2nKJsF12fX8vJpwO2w9ypEh
         afTOEfJuR3m++GsMZcmd27qCkMYc4G8sJu5VSAe5uZuXPfHzuJP0rjEAJoJ6a7Np8hHD
         0CAemxPamIYiFkPy8iQv52qg8sA8O9pILaKM94bNc33AsoqzFqoqYwEqgEgxWB8ySZQH
         KRyQ==
X-Forwarded-Encrypted: i=1; AKwUvBxU71KR/efErcyb5ZpUSDvdZ1WWpZ6tCFSxFO4Iy4NpidNRT1j3AGoRzXH6aRdZ/yyoAhuBM6ggow==@kvack.org
X-Gm-Message-State: AFq9FYIj9WwRT6+qTKRhcj7nWm7VR5moJQGO44hHLE69Wxpcx4UvGhmx
	IwWuQYX9cF94BWHt3tsLQEvY2dWtVyTPUc8LB5+SG24nhS3f6SOhypJluZCarjrsKw==
X-Gm-Gg: AYBFou3wf+Y+coNrdqL60SlK5a9AGukMnI2MxcVSCTFb2NiIYGLAMsnMxxd4KqF9631
	UTGN/PLCY5ODF3H97FVXKsbhNOJSTrN6Sw6+0HylN5CJXMyNW6jQwiCM/CVC4jpverMTX7WwBlL
	ZYD8U8KmY8v2N3MGJzAaALrP3rdot1qBTNEoCp3wThJFcvbSm4cvS3wS+5aPf0XVadzlY1odr9T
	dOoPTDkmKVtARYk0x4lqFiL4ebR5Kq7j7C7fAr6XfueodAbUQrVLUACLgvfIhR1dJwE0IyVV+q3
	/bn2NzTjOre67dnGsw8VP1j+7X7vG4TrHn/O68AIWgTIESywMELiadSnQQvZfMHChPojTFFYC+l
	9KNxtFLQaZF7oKM/84CySLgyYZtwFX/5ng2OiB7klwkn06AS3MyK3aH8fhj92U0aRuagSn8UCsX
	SeRY3WYO1h+ag5Dj9H6/MHk1lZT2v7zVlPtmmeroTWSskfDU+/ev26O5X0epWBPAG+qAhm1h20s
	HgWs2tpmDE4yUvNb2DOiWY1DOCtEd4YPk1HnxlRMu7ZM68rnC9AlmKL7tYxuvhWH2lY/U4Is6uW
	BFDVtwN6bWMVTjxvBTsW
X-Received: by 2002:a05:6a00:189b:b0:88b:7278:ebf4 with SMTP id d2e1a72fcca58-897c70104e6mr21100989b3a.18.1792119060609;
        Thu, 15 Oct 2026 19:51:00 -0700 (PDT)
Received: from google.com ([2a00:79e0:2031:6:a579:8b87:8304:7ac2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89f56c87e66sm390668b3a.13.2026.10.15.19.50.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 19:50:59 -0700 (PDT)
Date: Fri, 16 Oct 2026 11:50:55 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, baohua@kernel.org, 
	bgeffon@google.com, minchan@kernel.org, richardycc@google.com, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 10/11] zram: use rw_semaphore for decompression streams
Message-ID: <atGPwJL6XzlRaMva@google.com>
References: <atBh9xfpOji_A7A_@google.com>
 <20261015112440.1491168-1-zhangbo56@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261015112440.1491168-1-zhangbo56@xiaomi.com>
X-Stat-Signature: 76cdczu3w9pbjkfp16g7f9u3uxnbycjs
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E442640002
X-HE-Tag: 1792119061-129859
X-HE-Meta: U2FsdGVkX19AIoTux/ZmsV/Bs1hZN84Tzcxyc6gjDFw9ggo+0/s1MLD3+Zb91iGOpGu+/z14AH7tQmyVwlYaVuLgaJthXX3zYUTlf9qAff7+rDLKIDOyq7FqjrqcUKAOvi+3W+BPUvwXEMZFsnnQ4wW0w7PpgQm68/oKHbJhMzivWkXi+6sVutAcfhagBwouspb9gafNwckjr0qiPZBYVyP7bvoKtXiAz2oc/oNj3JOTWfZPtS4ZYU6n1iinq3FMaVxqIp9aRsaX70bkGbNIs0Vo1oslnHC9ugfJY1sv2zn7biwfuthUFqHBbewb5GhEGBR32xq/eBFjTdW4l7KCLfIENjRGKlj9Rppo65Mz0bj0+sXblVsY7oJ5IotM/EkWfPVJd7Qj12JqSOXrc1MmZVzUcNsAL4e+SzZ3S2RaNnepggroe94mti6D45cBcDuAY8dUWDoQQ7S4sqhfglbJ7XcFZyxTpKfdtMDQC+FetCbjzmWn3G1gcgzpImYXw8JxXCbeILzq5gCuaOWBBw34QRZDKjACFualGUXDNdDap9JlDHIjIkKK79Js22ZT9sLM3aYhUACnZZ8HSbSHoxmCg3X/tFpvvnDFTkFZdjRFgcOgzNedGVJwkAKXf5Td/+toSs05cRiQj/SDuDTGuHTuDkCFcJ9aNNUF/gXhTiRWCUitN1uMajemiAEQ3e0oORreXbS6OUa5gk+eN0fB/kR/EvstFqFP42Krsd889QiOt/GX9u/0gl3KuSdmtxKDd6De8/O9g2KgbIQgOWvX4ztEPphQCSVz5dDiO/Dw82Od/lmYGzJhnV5YHpMTYi2KJnOc8/LDte/8UZnxzRtfXPcYzEYPO6MokQl2JFNaaz2fsUAjpdh4BpY5OxxeXeCtWn+n/alrDhhEBZ7HyVeRywB+6i1uHg0BOWC803PblZ0smWHfp8MASgVnf2IQ5ruIqpfCa/jDLsZ3VSzEGIHQt0J
 2kgPGkk7
 8TaInMcn36CFumdbr4cSBIFIx1ISrXyf2IaK6dgb2y0er8NAikyzbIr9z7pN6wlkO838UYiEwey1PsIoO/QB8RmvjGiCWEje1p98W1konpNvRcKIN5tpGArr6KrLFRIjSHN4045Xtos87Zk9JdiU9uZx6aFDOXqIKDBRKSvUiTUrH/dazpSKURcO2Vbpqscw/invmuZNVXaHvpVOO7cRUEApxuKPKCMCIDqNiZqmAm8ZQ5IBKiXagRLm31VfCdYVkNYcrtXkwDCNjJlpnGPgPlKH6Ocn5JHxKouDlNyuy1fHweRlWPer/k2UCVHqV8ZHdulLhl3FVbuJ9XifVqCCBYGAEt+q50djd+3wjUI1qMx0P9fcxoSepEifsUIg2nKU/wrqTL3nNltfOfxM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/10/15 19:24), Bo Zhang wrote:
> On Thu, 15 Oct 2026 12:19:49 +0900 Sergey Senozhatsky <senozhatsky@chromium.org> wrote:
> > Or perhaps we can avoid vm_map/unmap.  A slightly different approach.
> > kmalloc on fast path + memcpy (zsmalloc objects are strictly less than
> > PAGE_SIZE bytes)
> 
> I applied the kmalloc+memcpy variant on-device and re-ran the same
> Android A/B. It removes the exclusive path entirely in our workload.
> 
>                       9+10       9+10 + kmalloc fastpath
>   read contended      ~1,959     0
>   read wait_ns total  ~12 s      0
>   read wait_ns max    72-96 ms   0
>   shared              76.7%      100%
>   exclusive           23.3%      0%
>   dpin_contended      0          0
> 
> Every decompression now takes the shared (down_read) path, including the
> cross-page objects that previously had to go exclusive. The ~1,959
> residual contentions on the exclusive path are gone, and pin contention
> stays at zero, so the full read side runs concurrently with no stream
> contention.
> 
> Read-side contention end to end:
> 
>                  baseline   9+10      9+10 + kmalloc
>   read contended 24,749     ~1,959    0
>   shared         0%         76.7%     100%

Thank you.  I'll include kmalloc patch to v4 of the series.

> This is a stateless-backend result (lzo-rle). zstd/deflate have
> create_dctx and stay exclusive, so they don't benefit from shared reads
> at all - which, as you noted, is the sad part about zstd on that list.
> 
> For those backends the serialization is unavoidable, but the actual
> root cause of the long waits is still the holder being preempted or
> migrated while holding the stream. So on top of 9+10+kmalloc I tried
> a quick-and-dirty preempt-disable for synchronous backends. Allocation
> can no longer sleep under the stream, so a two-stage zram_zs_malloc()
> does a non-sleeping attempt first and, on failure, bounces into a kmalloc()
> buffer, drops the stream and retries with a sleeping GFP_NOIO.
> 
> zstd backend, same A/B workload, on top of 9+10+kmalloc:
> 
>                        9+10+kmalloc   + preempt-disable
>   cwrite_contended     14,880         48          (-99.7%)
>   cwrite_wait_ns_total 137 s          0.32 s      (-99.8%)
>   cwrite_wait_ns_max   243 ms         43 ms       (-82%)
>   dexcl_contended      15,919         54          (-99.7%)
>   dexcl_wait_ns_total  109.6 s        0.68 s      (-99.4%)
>   dexcl_wait_ns_max    145 ms         34.6 ms     (-76%)
> 
> zstd stays 100% exclusive either way; the win comes purely from the
> holder no longer being preempted/migrated, so the hold time stays short.
> It's the same mechanism that took lzo-rle read contention from 24,749 to
> 406 earlier. So the two are complementary: shared reads remove
> reader-vs-reader queuing for stateless backends, and preempt-disable
> covers the exclusive/write serialization that stateful backends can't
> avoid.
> 
> Quick and dirty, for discussion only - Patch below.

Yeah... I need to think about it, before I can join discussions
in a meaningful way.

