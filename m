Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 292BAC5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 13:04:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D23B6B008A; Mon, 10 Aug 2026 09:04:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 283706B0092; Mon, 10 Aug 2026 09:04:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171E26B009B; Mon, 10 Aug 2026 09:04:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBBC56B008A
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 09:04:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 847D2A0E33
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:04:28 +0000 (UTC)
X-FDA: 85085378616.07.763CB0C
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf17.hostedemail.com (Postfix) with ESMTP id A978640019
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 13:04:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QzACqpQ4;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786367066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmWCD/D7PFkQWTWKXm0x5gIDV1EYLJG81k7aS8klGqA=;
	b=hfgQ0efAEcIKEMAqsjW7bLUVrD4a+jDs5LBqGL/TxY270CXtD4Mr1DvR6XiaTwzJ1UI3HB
	+HkCFORwVUFH+hxeYY84wb7p83fA3YDOQuLPYrznySUwJl21yWKLrFJK6aREXE+WhU9lO1
	5NZNp7g0fVO7by9GelOONLn+Bh9bgYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786367066;
	b=YR7rXOzsCEd+5lvo6viAdB0NoXD3qWdJwWYpDv24O5IWswt+LM7kHoAUUBgCF3T5xduLYC
	z09siauekevA42v0f9ur6sxdrMrA9tzDW3BZkGkcElv4ES+FbG2b0bwsggvZaV7WC9yxV9
	AjFelZGz4vnybJrReRz6dAoDLlqlgPE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=QzACqpQ4;
	spf=pass (imf17.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48000c5d6d3so795504f8f.1
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 06:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786367065; x=1786971865; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wmWCD/D7PFkQWTWKXm0x5gIDV1EYLJG81k7aS8klGqA=;
        b=QzACqpQ4znvMVUhDfW5xRzLVCUq3p15+VXKmIk/1CEk1fVEwZ9cVM0aYcO99Qvxvzk
         jWDFLqA4OQjYeOV+/A7w/LHgHGkcJchebJ0g4NIjC77aHIeB9lpumnQdl7BLiNQ9kWGS
         XKn9WE+vFFN+fjaKFGoc0y5w7Usg/yLwxednpt9K6+XjryJxyBGWHgJsG7B4MR9aq4Cg
         YgTjOluIaKP+icH18QWsFBDwqHYHDjPSM2BFABhmciqxV+8oGN/gylAMTY4BtghiVsMo
         KpO2GFHxPmMPSS3FTvZyjobmoJvTGF0YDNVf72nPy82xp2DRo1nIujIRtts7vQc+o73u
         KNdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786367065; x=1786971865;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wmWCD/D7PFkQWTWKXm0x5gIDV1EYLJG81k7aS8klGqA=;
        b=dGr+yXo1yAFg+bBDn62728OsQgFbvJjEiv4ttu2VokdXfn3N9Y/4LEDrFwU7ciUhhe
         drIspp1h18oOm4uUceL3Q1EANoiJ+dn8ot9/DVt2DaglvQ2HiATcnzRUaq49pU3TLW6d
         8LngCMs2miMngSdXgZNqR9risSHAguZ0lOY6oSdWAQTZESmhbxOz+fARZyUpcwHcDr/N
         NwADOkJSq67BYUXIDwrUck0h4B+fHWGlYsFZpkXi/YEInEfUol96w+do6fuyvWav5x98
         Coaw4wbQUCyBO/56L8S6W6MWiVdUkhEuVGIWvW3V7MpnMPQcWp+nYBOhkP35PCZm71Em
         g+TA==
X-Forwarded-Encrypted: i=1; AHgh+RoZSCNprSVDg9TVzNoWllUOsIvvXChKeOvrsECdXlR4FGFk25RRj9PYlqf5RBshDPs5Fwzqz9fQHw==@kvack.org
X-Gm-Message-State: AOJu0YzUkYRPPiNPkog5omkJeANeiSq7ks4zvDjkh4EcuohEWG3XMaUc
	X0mCswhAILdWAeC7KtF1GXRIyCCTTbw7YoXcOzLeTTQKQ7ksyc4FK+Y6sBGfxYrAadY=
X-Gm-Gg: AR+sD11EGmSGRLCP77BMCKNVfKS2VxAeiMwg7H1TYR27S4ePDmZoxM5YJIamQ3/cjuS
	amsm8ae+q56xROmE+2qwLL17GxhDWalB3zIdnz41t3f2kFxWVV38iDM6XpQLgOOAVObtK1UBOGS
	0XB4uWC+eIAVp2QqumTiQLr7SB+fENv7kN8faZpWeS2ndGC0VWTAr3HNTdYMokUA8QaXYTRFLfb
	75dn6Rx24bLvCgiJFbupJTd2wbWGArRTPRfoDfkEF/aHFKfE96MsjRK2EH3xohOoIx/qgZDIES9
	QaQTtpVnYFNjlmtvmydY4QSQ9jMMZTp//xCIFOAeLTbK0vy8FlNFTib0Tn2s/9wUvbxLa3XXjBY
	c+OeOn1DepXup+R29Yxu3VGC3HeqxmARKndEadh/7BFZyOAayJPmXuCXV6KzUmWdDdySVPmHhI9
	pGc1Wx2Q859hi7QV8kYWNayMP3+fTZv2fiU/FTbskoAZq/if6Ah2UWZ91Tu0TAszUuydT/s4fy6
	A==
X-Received: by 2002:a5d:5d86:0:b0:47f:8fc8:a8b1 with SMTP id ffacd0b85a97d-480026c89d2mr26784095f8f.14.1786367064903;
        Mon, 10 Aug 2026 06:04:24 -0700 (PDT)
Received: from localhost (109-81-83-166.rct.o2.cz. [109.81.83.166])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021f8f33sm40375893f8f.27.2026.08.10.06.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 06:04:24 -0700 (PDT)
Date: Mon, 10 Aug 2026 15:04:23 +0200
From: Michal Hocko <mhocko@suse.com>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: shakeel.butt@linux.dev, akpm@linux-foundation.org, hannes@cmpxchg.org,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: fix memory.memsw.failcnt accounting
Message-ID: <annMVxXm4tZ4h4FZ@tiehlicka>
References: <20260810074247.52747-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260810074247.52747-1-guopeng.zhang@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A978640019
X-Stat-Signature: ynfe9p9drspb3kheabzus8ukdeegyjoe
X-Rspam-User: 
X-HE-Tag: 1786367066-970704
X-HE-Meta: U2FsdGVkX1++Rme9PZl6VmUvW0BnJhErCjKiW1q1fI22R089Jm17lYqDg9TI/fPQ0ARcF1PK7i7ADR2j5MKACpTOhYkzOXX8ELfyTFmRfGFBv88OcN5tpCeZddxWZA8ejfFB7Jm+t4Cq+aZ6o+3AcQ2+DEBZVqkIdVPO+Oe3kSu33rQ1R6whOy7RqQMCa11+1l1oZr8r9fZ8/y2HaLYpKWGMyiHRFMyRX66jgLk9vO4P84Lfmlz2ipj8X98jnh/5fblvx2El1/N6FprLxSR2hCM6/NpURPe51OwAmpElx98OxkGOS8RwPhl5QANjJxiEKniRBM1zxtRFp/3H/S3JMLUZ9L4lrMMr6RNV6iJzcqhpubdHDIU33XuRbKRuuKGTcFyufC1P7cnGrTEy6r0rGUO1GkhN/CldyquJFp0rGcLIKo/YiNYdXzQ/z0xykD3hIN6gqcxnh7bO7l8jfoLFqfg6XLOWlamdt0Q72FRLuM+3vzRs6ZMij7NEKPAxGG/mVKP0OFN4jTCuXdi0O7joS9Wernu57LTKVdkHU3ywRvbWto77RzvuJWs5wUJu4U8DAKF5m3oq1C5nSgW8Vn8inxCHfdT2bmJ0niyNmWshYcncyQHQJQuA98Ocp/a4mOBaMULSxDLeTzf3URDJ//1+08ifp5ef5sppdNKmfzKLE+g0GThCToM06R7H7hGbjOzbUghiSUHtJ8O3+OIUihegbJrthMeFlBiPGJdZ+IzWTXXMc5LEUbnK7g0EWVK1ayk6nEEJrXHRo4ISZwlUek3GcTuTdpCwYSSgBOCb4S+1iCGosxBuDo4XbO1N9cUbuO0vaEJdUWFc0WZXHuC2G4LkIems8pCt0P72iB1gbxtpZRe7ZPFa/iXl9f1mViX3ml6tkSy2cj9oL56S/IdQS9a8DHKRfb1ffuBov+zbYwejU2FA0ccL/PUVcTWdtrGE/T7bwGOx+d8uds2POb88hqH
 8txt2DaD
 hIhNA5UcIsViDCfHpGJiTEJzTJ+3zBqAQtZ1KJ70eoLNhnlXxDr/u7Po4punL8LVXjRm4jhtQnPYBLO/FWQN+nPMwWIAlZxlMKJBanWCwsqUeT7aOcZW8fk4aPE82A3EPXWpRL8W1Nl8+lMsnrIBaxnV4WbZBA6/O1S6RornpOXGbf0t/pIt+VwoIKggy/QsXWgqwS0X0p4RUpTSI/m2gj3SzksLDYw7yz0MM87UbGQ+k7oOdwifKZSmRsKSoxwGagY78KTHeyd6YQ2Yn2oRDiDA1vEHXFyhnctIE94sYGk2sp4F9VD4qDUAQhl8eHiLqjXbULRj0NP/Zmq5EIHy1WuvPyr8B4RU0QZSg5iHNvV/odNm1Dtj2LWA123WJRgfBDyZ8pyM8fIu0Uoxj6Gmjlm4xoJjrCm0H5JJf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 10-08-26 15:42:47, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. Enable failcnt accounting for the v1 memsw counter.
> 
> Reproducer:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.
> 
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/memcontrol.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 6939a4fbb991..4ffe5b3733d9 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4235,6 +4235,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
>  #ifdef CONFIG_MEMCG_V1
>  		WRITE_ONCE(memcg->swappiness, mem_cgroup_swappiness(parent));
>  		memcg->memory.track_failcnt = !memcg_on_dfl;
> +		memcg->memsw.track_failcnt = !memcg_on_dfl;
>  		WRITE_ONCE(memcg->oom_kill_disable, READ_ONCE(parent->oom_kill_disable));
>  		page_counter_init(&memcg->kmem, &parent->kmem, false);
>  		page_counter_init(&memcg->tcpmem, &parent->tcpmem, false);
> -- 
> 2.43.0

-- 
Michal Hocko
SUSE Labs

