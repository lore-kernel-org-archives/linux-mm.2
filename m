Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C2DED3B7EA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Dec 2025 06:36:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D4E6B0005; Tue,  9 Dec 2025 01:36:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E0D6B0007; Tue,  9 Dec 2025 01:36:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC4A6B0008; Tue,  9 Dec 2025 01:36:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A9C66B0005
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 01:36:56 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 153CB8A4F7
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 06:36:56 +0000 (UTC)
X-FDA: 84198974832.23.CA258C2
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 43F63180002
	for <linux-mm@kvack.org>; Tue,  9 Dec 2025 06:36:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RD9/65sP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3hMM3aQgKCDsgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3hMM3aQgKCDsgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765262214; a=rsa-sha256;
	cv=none;
	b=7f4k7GgVDkxFBFs6CUsbKdutqFkjg2TUR/GguG2SXo8ALDP1ExD65LYreUNJFU+nO7LjXQ
	xMEENaVSpGJk/lVZXKN+PIJTOAe+qt/z9mrbuxvFWsJ3QZNZEdS9H1Ko9bZ9YM6mDou6ur
	JsHgbRtsQbN2B/1x9k0TIocMYEeVqmw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RD9/65sP";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3hMM3aQgKCDsgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3hMM3aQgKCDsgXZhjXkYdlldib.Zljifkru-jjhsXZh.lod@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765262214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pBlg6N0YGJgNDGWLE0hR1gRUpuGlTlt32WJRdXYRD2Q=;
	b=N3k34S2+FPu6moPzQHUoDS3NQ4OcySmdftwNfmiyUR+WG/2VOlIjNBAkbBCOscZxuvocxG
	S3p2Rn51YLbtfrAdPKNGn/iiCbUOvPfkfzVcCSI5WgnfddWrR636TdcnAcLCbT12APyzGg
	i++d3N15pCB6eQGsVt5LHbWNrxkHTnE=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6495cc3e622so343185a12.2
        for <linux-mm@kvack.org>; Mon, 08 Dec 2025 22:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765262212; x=1765867012; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=pBlg6N0YGJgNDGWLE0hR1gRUpuGlTlt32WJRdXYRD2Q=;
        b=RD9/65sPsSnYSymn78adkB8QsZ1llTf4UT/sLTUiwKf3P62mFsu6yR6uBhOo78sOan
         F+YpA6GF+LTwkPfoxGUQCROU73xU3Vsw5/oLPfVwtIEc5tqwwtQEYhu8xKBXHz5A+Z44
         qWdmyL1JW/7I/PlAz0RCm01oB+F7FDQyCx4Pe7Y6CSL+M74Fvw749D+7k6hQha/jbdnR
         SEgpQlBRJZo9/YnVy4upSsoawiIYusmOFskQs3/K7hoGkDzkwGposx4Z10BElGUKPw+Z
         RiGZHhQQbDG2vF3bIybX2SZ1qt/jxgPlxNnYsheGE2i1uNh3CSJs9pQUX7dTWGyTLOI/
         znRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765262212; x=1765867012;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pBlg6N0YGJgNDGWLE0hR1gRUpuGlTlt32WJRdXYRD2Q=;
        b=G1XnoQA7lKCsHfNNL4frdylQzvgctW3p3TjE3HmkX26/kOAGOtX61w+KVs2RQUgr0x
         a1qn/aEK6g3QkUMFQ5IbwhORu8VBGOZciY+WAu8LXk3Mw/7cHOgnGwM36mjAXhlJwO+t
         N5j/t4/UM++33QPAgc4X5QpJhOK2+WliLoSqzGFXFu8amT3Eulafz7pn6R7UErvR68gK
         YmrAOo5guS6cRsrQm2mlUyR5zYHq1aumUY+dVIWJ5K/vZlXfqVdPcXSStAnXLsFBVhuE
         +hF29HY7WsLv5rfBOWR2Jx5P3dqV0Bz5LF/dwyO/r6ub1EZDpECcIL0+bmLTKCoO2L/n
         nlGg==
X-Forwarded-Encrypted: i=1; AJvYcCWr+9MGSASx+Xq9+xzsmg6xpNNaktMHSUgkdnGWya7qquQx5dG+BrOYaRB1rhsCSJwvu466UP9LjA==@kvack.org
X-Gm-Message-State: AOJu0YwWh4t/ayGvzhD590OmxFlAmGDcigDpcmiBfXWiWXMimNhMG/P9
	2XC+m1tvH9G87QVv6kn4ESngkiVU9TuM2nFnRz9eF50Rm3U6fCLOpIpY3tjjTK8d9xptdsmFh23
	RP6O1V9+QlYYmTw==
X-Google-Smtp-Source: AGHT+IHCnkhtu+erinZRjzHU08DdBwFzraMet61P9UwT8esvB8HjyL7gPlKocQZ3b3SJKLvMZ7snSMNitdCnUA==
X-Received: from edbek6.prod.google.com ([2002:a05:6402:3706:b0:647:5ed5:87dd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2816:b0:647:57e7:472e with SMTP id 4fb4d7f45d1cf-6491abf2749mr7780459a12.22.1765262212352;
 Mon, 08 Dec 2025 22:36:52 -0800 (PST)
Date: Tue, 09 Dec 2025 06:36:51 +0000
In-Reply-To: <20251209-b4-vmalloc-might_alloc-v2-1-2462ba26ead1@google.com>
Mime-Version: 1.0
References: <20251209-b4-vmalloc-might_alloc-v2-1-2462ba26ead1@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DETH88RP5U4O.QACTRJIY5Y1X@google.com>
Subject: Re: [PATCH v2] mm/vmalloc: clarify why vmap_range_noflush() might sleep
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 43F63180002
X-Rspamd-Server: rspam10
X-Stat-Signature: p4ymqn5sqc5ynpbgoigir89z95w7ii9h
X-HE-Tag: 1765262214-859960
X-HE-Meta: U2FsdGVkX194M+EucU8uzPBjlKDyD03WpvARBa6fLNy0CiP0OheCsef1wnBnru5Z/C+bhbBjly3DtLMBCQP1ZyZ8gw/Az6OqpS6ncKw04GRT36rd4rJzyZKNz55bkyuVy+C+aa23qikqa/fMt6x+haPyQWOTQpuIDw2TauDKgzYsXeJQIyhZqpFuKnzlHBuipO4jyTFQqrZgkgOgEZDXDRGvt6PwN1NBoBRyS7V9+OqUF0K5bm2QdB2o6v7MyShRAxmHlbXkBIz7es4s0MIYG0PKpKQQqsxqtJSFQr7qNcnHjDFXB7YNLKlWG/tKmPuFV1fyF2oBv/YolrpHwna9+PVuTLtuPBKsbW3aHp7sjZLTc3RqfAz+qq9gmhhmKKbbuVTmuLq6oexgifLDb8PWD09Ni+qexhDsiCjuUCDZW7tnE/1w34BsUv3zg/v809QTIrgzTuZbaQpO6J2QrIcj7cIyHezj/7t5lPN3mLTHwqukB/prfl5voT6XlbX2B40JhIR6lGpBWdbeExDYa/zIBbB4U39J/to1ns2tbbC//xKLxZL6y8zsPJnU2UWAcogGwnf2FMigZoIey4R4tc6bU3N1yGO+AgsQXZ3HzPKfumKg1WC4WIFqAp9h03u7D6+sN6Q/PUevl912mcy6MpeJDfQMD432MJ4O4WTvAKXof5PpZEDSQ7s+bDibnoZOGB8WE69ZzMVgLnVWNJqq0K8nXIrfqhoeBwlFGBjtg3S0G/ivGbS8MBmsnzKpXkGZUIRlf8PQ/9iGr46o86VMz9d8xFjeO7RPqGTbfAwR31jY6/gCIkam4Jnh+yufqARfSU7XU5UFGbkIQPGX1Zy23jrxrAIGuzZ6j4MFXhS/uCy1XLgE0w9EyUjkXNgsymCdMWOWPHS3hZShBqd5sCTX57t2zkJdJ0IqCMSIeD9mffHMCNFv2Ux9IwHAPAE0pc2Tn7Gra2XCdykPhLAgHbIJgH8
 j9AznmC9
 sqAx9i2GJQ5A5Nawktu5TDW5NKxvaIeiVEKfu0NaJNGSa0LTj1cvqoV1V0/UbOF1ffeV5DOHEoZ8FheLV2X7IeXeIr0QXoBLgMybhi9r5UFRB+TAm8MGRHQx0SYTzHRUOCXXL/F/h9YHZ0Xou8s8dJY3Vevrq9ZJRwZZqPULakrzgr1E7scsAgu5UK73fHHiOVNnDZmhMsZmz4ukjNpYvvFMG5PfD/p+RWOcJWm70kYxnReLp5w5MO4MDAlzo/6M7pvOMKi2agx19R01zxnTulcNCBAMVJz+59Tx4VyTe2FZyEiC5nI4DPSLw0Ic8JXBivpnj750qo+srAqHrqmmKcbTeenebfrFL8W/DD867/GeXcsDmf/4HyLRq5jHPwLrEV+SdtE7sVXCfF22TGKLS+B2FbOWct2TxG6heySZp4PFcdMvpsA2eOtQGGm5gz8EnITc1JFAz9leJniylilpDqPlwBQ+B2gDDAXTVPh8JDYFcdv6ghoR8mH0ZjxpZ+d/wYBNYLIPO5Kx2tURerjpnZ51NZ251EQwUJkfAFnZ+SKVHTd2wYcb71RNnJ2sDCk5Ae3rNzcW2Q8stwzKVA8bbyTLz2u9qvMG0wkncdM8Pw+5A/Bvj8ngzS7xs1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue Dec 9, 2025 at 5:44 AM UTC, Brendan Jackman wrote:
> The only reason vmap_range_noflush() can sleep is because of pagetable
> allocations.
>
> The actual allocation mechanism is arch-specific so might_alloc()
> doesn't work here (what GFP flags would be used?). Hence, just add a
> comment.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
> Changes in v2:
> - Switched from might_alloc() to keeping might_sleep() + comment
> - Link to v1: https://lore.kernel.org/r/20251208-b4-vmalloc-might_alloc-v1-1-94a9bb8ecb08@google.com
> ---
>  mm/vmalloc.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index a53c7462671bdd896f95712af71398ffbe22fb80..c23d378dd4446e2784505ec3d5bb9568fb0d3c9a 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -305,6 +305,7 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>  	int err;
>  	pgtbl_mod_mask mask = 0;
>  
> +	/* Might allocate pagetables. */

I just realised that for x86, there's also TLB shootdowns in
pud_free_pmd_page() etc. So I guess this is also a might_ for the the
lockdep_assert_irqs_enabled() in smp_call_function_many_cond(). Should
probably mention that too.

Anything else I missed, before I send v3?

>  	might_sleep();
>  	BUG_ON(addr >= end);


