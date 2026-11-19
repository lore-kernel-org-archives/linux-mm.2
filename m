Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92C63606A326
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 05:35:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=cRBaF73d
Received: by kanga.kvack.org (Postfix)
	id D991B6B05B2; Thu, 19 Nov 2026 00:35:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D227F6B05B3; Thu, 19 Nov 2026 00:35:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BECDC6B05B4; Thu, 19 Nov 2026 00:35:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 79B566B05B2
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:35:21 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FAF016094D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:20 +0000 (UTC)
X-FDA: 85450755600.20.9393EF8
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8B8D5C0006
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:35:18 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cRBaF73d;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795066518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSA9twBPbKzxpC9yFC1nd7ceP7zJ811GD8sMG8gtFe8=;
	b=CKSFFg07r4MXZWN4Br58lFh9dNR3l48oQMnTiinVSrraNtrTJoBux5j9fDL8PxE/z5Y+5T
	syZ0PRZknao5VchAnmVYJUsgDM9WEI/TLIunf/u+JUpV0nBOwvaWOyKxirZpZ/32XoeCx/
	j7yrEGgnAd31Ui40nS7G1ynnyTmNfXo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cRBaF73d;
	spf=pass (imf10.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.216.53 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795066518;
	b=7+6wmKT1pwqH0WTsFZguVuYUmEqXDv1xvaFqDy4mrEtOEuIeS5dAaDY2knWMVuIVcPr3sW
	l4JAhNKAu/WvYOtSZ/nBzRuuNXDoZAbfP2tqKwzpo4AM0XK1+00sYZqCFqKB1sJ1TnlBKS
	KDJCHz6y7xM9d5+ED9BCrj+AuGv3SWM=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3ae1b34e0d2so313171a91.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:35:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795066517; x=1795671317; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oSA9twBPbKzxpC9yFC1nd7ceP7zJ811GD8sMG8gtFe8=;
        b=cRBaF73dmkDoeYIvMO3yx/2uIzen58K4vuWzhYNIod26RqeEVMo8RXCFIkEG45Kli7
         OqZN+kmxxfViBYSIDTz8uiN85VwsTkcClSkAZsPvo9mndm4FMj2qrF1hTihbFgNdP7lD
         UbQvnosHTwIMI/uLpThEuVc0NtzA7GNSeTOM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795066517; x=1795671317;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oSA9twBPbKzxpC9yFC1nd7ceP7zJ811GD8sMG8gtFe8=;
        b=lSGkj/IdFaeF0BxSzrMdhyjsTxbHBHsIkX8hfx7/sDJK/jRm+5PupPIOu3Rc5MTzFZ
         91z9oxjtGLb0J90cmyiebUUfenB/8jc0GzkE94oq028gp71Dkv9MgcuLajXpswkzCbvD
         iW5WnSmf3AwwY/3SeV1/Wi3V3SctmUEma+4iQb5VWq3i0xmlao8BikYoQ/I154JdA224
         DaseGfPd9vk1KB9GP1cf2iSoq3weUbA10WV0VDyXYYr0HIFVyG80cofYU3rvYr4lmqxi
         sTHGmGyGZGB+SOum0+nwsC3L+azqHaE8TkIDlVjlOZRAW4Ep5XPKhH5GABkxaQL7rWDi
         1FhA==
X-Forwarded-Encrypted: i=1; AL+hErFrm6wz6Xc2eATcdZC7LTdkt2XoemvTEoocXFb85MdRRHNCvxoYJohXlaC9W5DMcTAXPyFE3hLz5Q==@kvack.org
X-Gm-Message-State: APuU4Z99RSbG87A+Gdap1x2Utj8GxBeuNHpBAZup7YhE0G3efe+4qF5R
	Xv5r4fpzActOUT5OX0IsfuV8dWN2khYIWaA3PTXIG50CDWti9mIvhBQjbtyOC9GQHQ==
X-Gm-Gg: AZFdTZfrkPMywxCKDbbZb8vZRT7XEKAAcW+7xbhD/HtfQSFfoCg2Aa4intELJy6eplR
	fpYR2qDkbIiZaq5rV1dURP1i8VoDdgcchQZmdIE3Oy0qYzzr4k7ImQGq2vuw3uWjOFci1bczvJZ
	yxteCyTmGnyrjENzfyJ5mj1e/MVRPn/EMncARDt82HReqhEvjhwPRaau49Yb2FYOatcv1hQ3J9K
	NqpvooW2ZGLJFFa4Nr1WhnLrsAAH3qmOO8TJt5kI+EgGmDFpI3vyPSTR3w8kdyyO7spqKChlIWw
	Fiy3epGSWisfcr6JgxPregU+xuTUPyGhaJPKVIud5kDoszc2pMi/3mU2XaMaXBPpEkRPa81PHz6
	BngXgxNsEi5DRWFGcV3Ubt/W9qyiFarOYN7fR0Q3QvwN7IJhdhT75eMTUqVo9B/AThG7Oiv/7p8
	2Y0Xon+tNZkHhHWlLiR8t5lWliM7QZ/5rfacxqvJtJkJuUlIWujJeWlGrR7lwAac48W5Ls9YN0Q
	XkgUl6+R31hVTliJXQ4WkY1aA9qLyv6L2jK6gJe+SwKkEqyg/1DT2fCQXUE77dUNbod4sM1+YsN
	v3VSYZ/PdxqViCuOaaPyG4j++zeQlx36cr6ZNYXHfRrRyN8UorDKbMKn2A66PiYv5hDKeA==
X-Received: by 2002:a17:90b:4f4a:b0:3ac:84b8:c0d0 with SMTP id 98e67ed59e1d1-3b40a62dc20mr36559a91.47.1795066517234;
        Wed, 18 Nov 2026 21:35:17 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9297:4989:4c44:dad6])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde534aec9bsm1050833a12.22.2026.11.18.21.35.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 21:35:16 -0800 (PST)
Date: Thu, 19 Nov 2026 14:35:11 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hongfeng Chen <chenhongfeng0212@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, 
	Hongfeng Chen <chenhongfeng0212@163.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	Minchan Kim <minchan@kernel.org>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hongfeng Chen <hongfengchen@xiaomi.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu
 batches
Message-ID: <av6JvaCh358eSMCw@google.com>
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
 <20261023123736.1542117-1-chenhongfeng0212@163.com>
 <CAKEwX=M4jTnxmq6cj115Gw4u5jdY7Ex65jPtVTEopW70jGzfuQ@mail.gmail.com>
 <20261109105957.2577351-1-chenhongfeng0212@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109105957.2577351-1-chenhongfeng0212@gmail.com>
X-Stat-Signature: sw97qd1ib7zkegsauc6ue3icmdet4xd4
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8B8D5C0006
X-HE-Tag: 1795066518-371459
X-HE-Meta: U2FsdGVkX1+zuLBCiZGCKwvji+zR+1TU4voJ5Pk7tC/vKCbY5xEtvABb5tkqVSYDEcLKg7uridzgwxaBlXYiBA8KHiZB/hgRv5/UivqMkB2f+BwEypDUQeIrEZcAmc+Lmc3kZDdeGGUXKwwk2+Bd9RAbmGMZJV4S0s3j2U+mUW82HXKcnzi9MZlKvaVdvOwn68G0VWIRysS93eQtQn/ECPluIle4WCm3n03P/MCsr3dtoCTsKSq4YumGx7oAAz+nDL0Uwm3KR7OZRptYCrOCWlG0CM2f7UFI1pG0pjzbUaSP/Sn7skxMxFvEQjDZB/uAFowy1Q8aD+yuIbrEIADO/A0hcBQfeVxCLpmRdn1VFSDegKQtbuaFo96YcPoxGPDiU9b3C6Th5+2zKifYDvYpp/31tqOBrefyjPcQeD2jBr4fXPfhgw7pOpe4mj5WAZfdSZm2R+oDnhEJG785XImX66sdbj7BJUOD8CsatVSapnp3CVcpVd95Mu3sTqtJsLRH4HAie0aELnb4dYP2gkU3N5h7KNxUtWPXe2KXspGAqyavAAs1bL2O0NHvClxgqhLWmkXOGbsAWArnZE0Gew4o/Y40WtK2L+SExYinPNAgHR02tbgU+Neu3ohSQwIz3haTRIcXlw3SP6NjU7sC3cVYyJBtB0PCFumgbaN7lxY55MjZ2yqekaL3ZYiEslssiQ6CCPJRyBl7//jYeBPn/UQwtyRhbfZH76J49TvdYojtHJuqbadPTbougTP26judsHHa9FuopBNEcOji94s4hsHTH4vSsPwah/u6pvzaXxc/eRnbuvUNsX3jV40B/akm53CaYPgMARpUc+QR51i2myxc9KCZrMi58bY1EXYO5Jox+L65s9cbRgHgRDYx4lTzHfRbX6xDy+7KxMnrLMbOmYhw3ydHfDzrbXSC52z2YEvTkgjrCJsXmisaXwAe3XlkEXi40cBV8p+QtkadwyLeyxA
 f0sa2XD5
 liZqWOSYyOS2rz3bcqd4X+pSDEKTlMwTnuIRkEf3Zw11YApCguqGwCFfLmaO6iFynR4JakRw8qyPn2eFMKGs/xdvnsRFiKjKzj++BhQqgKghti/shdDFLY6CqVIRFpiZ4n3dLoLeFHlw7agDbdtBAPhiakrPu+jjq1kTspql8NVltRdi9YO6H/t1k6XZ+4nzIaxdxaArDl3e+cv8N7ox/Q7rxqfF6Gp7nzL+nWKo4Q2WK9WQlguy7VbI5CzDOohanz0PdD3CfGMr0HbyIwX5liPLcV6nDQlAgJ4StYDkMdQzc8vy85yyBp3cn++LF5LPg6tfmKYp396A4I4Yi7IjlFeMDhklgBhv00zgNqg45g2CrCkpw9NOXk3ISnoVf00e/ALFDWheKATot3L0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Somehow your emails landed in the SPAM folder.

On (26/11/09 18:59), Hongfeng Chen wrote:
> On Fri, Oct 23, 2026 at 11:19 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > Is there any more juice we can squeeze from zsmalloc in that case?
> >
> > It would be nice if you can perf zsmalloc freeing. And yeah, maybe we
> > can't optimize any further, but let's eliminate that first before we
> > rely on offloading.
> 
> Here is the perf breakdown of the free path:
> 
> zram:
> 
>   __swap_cluster_free_entries        90.28%
>     zram_slot_free_notify            86.01%
>       slot_free                      74.15%
>         zs_free                      56.01%
>           __free_frozen_pages        19.85%
>           kmem_cache_free            10.15%
>           _raw_spin_lock              5.53%
>           fix_fullness_group          3.31%
>           dec_zone_page_state         2.43%
>           obj_free                    2.17%
>           trylock_zspage              2.12%

We removed one of kmem_cache_free() from zs_free() [1].

[1] https://lore.kernel.org/linux-kernel/20261110054836.1515030-1-senozhatsky@chromium.org

