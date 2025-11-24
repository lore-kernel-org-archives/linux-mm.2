Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A214CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 17:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4EAB6B002A; Mon, 24 Nov 2025 12:27:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E25916B002B; Mon, 24 Nov 2025 12:27:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D14A86B002D; Mon, 24 Nov 2025 12:27:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BD1146B002A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:27:25 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 742C289756
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:27:25 +0000 (UTC)
X-FDA: 84146182050.29.2D142E7
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3BD5918001E
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 17:27:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ju68e9fS;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764005243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=53HUP+p18ROArguaOr5CiVNJvWgLYFuwy860PsL/bOU=;
	b=IZjVvwkxM1GX6oPvIFj7sNxvsawmJDAfI5mBOZlOCCOGNcgU/+ltpehpw5hp1DGoYcyeQr
	wNQ5ZpN3jStXUB4PM9+BvKpW8O23HIUBf2+PBd6inLEhU0M7aV9UJBtpcouCz0U6bAu852
	e+mYbpE51O3l1ztmuHacGDTEQKPxFHo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764005243; a=rsa-sha256;
	cv=none;
	b=pG/Un0vHeXvvxJtRl4yBDblAoH/sPENxXvhGfbt6wm+C74sHt1ttyo5gh4FIfrUog3rayp
	QOTf3j7pDXTlfN25Dy2l1EVVdfh8/wFT36oPmWh6Vki271AvznRHvNjXeWfcukCLAIJQSt
	Lx1H/DzUkqWfgcD6xID3ZvDZB81zNqQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ju68e9fS;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b1b8264c86so451111485a.1
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1764005242; x=1764610042; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=53HUP+p18ROArguaOr5CiVNJvWgLYFuwy860PsL/bOU=;
        b=ju68e9fSCZ8OBspEsua7EbR/sSg26Klu1fouy6his21TMYWs+ttbS33xOO06FUW5O7
         oQAsBg8dFU3qBPqgnqOILM4s20V4znPsnrSONVKMI22V66usJ2l+dlAhW5COhLkhcGp+
         IRQgBUXK+9NC6HZ1RM8GApR1gbxr4RtO3cqPrhrxAvzMgVSK9EcT/bE1L+OmZ6QcTU6a
         U0nworbfafuUJOcveR2TFmAqqBZU9f1mDo6ERaCgaKSmgtOugT3yyFdu7zLcSkEWEz2g
         j0CfPjgkxeKlrsLEWKyb4EG2OI3sLfBxZMsopoRLx/O+esYZzu9sIhpOE3TgZN/eieqn
         WmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764005242; x=1764610042;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=53HUP+p18ROArguaOr5CiVNJvWgLYFuwy860PsL/bOU=;
        b=RjFg3MPF9s+KE5IcWTbGoqoyKz0B+6FWzfoTmMDQXqhF8RvYtPuOFro/WnkjVI21e+
         pEi0365pfyEmGijpZVP5fzL7BnH0aT4VQsd9lXkosQEh6fXkd9/QVXbIcRvOHffDCdWL
         QCB0kIDPBadTKPEo8WARM6zwzc3qUJqf9JhE38aEmjF+N5WrHZKGc3r/FvsTtWYB5Idm
         GAo5RK2Nor6e2O8EbFGzbtUFATwdM1NlDIxJaKf0VwKEmWQWvNahNzrEHwomLJ3v2ziB
         EorHvy8+G3f8weGxrsDl9H6+3f5eIjAr7B3NFyiYaWJgKAegW/Ksyu4zFukJrXGDBpTa
         hsGg==
X-Forwarded-Encrypted: i=1; AJvYcCWxw96UYCQbOrK+ALrnAOZ8nJGJmFuO+V2moPk4OJiDWJWb+Ef/d50VUE7z95r8Ml3d+UJE482gaQ==@kvack.org
X-Gm-Message-State: AOJu0YxjwUTUSRbic/u8iXGCRuCQEXdWbFRntND/vOE4OM7c6KfLas6h
	20jbmUtFfjXpVDQKk9aiWruu+wVrmV958mtWUsUUGJjZTAKdnwSYK6qx4bMS5T+YmjZUpLp8SjZ
	IbxH3
X-Gm-Gg: ASbGnculAYBAlTOKigL0SxyUN/73EzWJbygLtDBvfP88k1adMOnTa/kRSEiSdMszfRi
	WtU+aXRUVIZdIRMiFsW+qC1U/YAFMsBG3BzxMygxFsxyaNfJQ/YzUgTewaBuh833JALGh7XJfSs
	dy0N1P7a7G867UQTYVhhGS5E/rMpnMI5oZ3tyCiMlTWi1+yuKM2Gb61izaS70lSCXy6yOJ+N2B/
	zaCcZf/KvF7jFrJyhoDi1uC+f7FzzKpNkWnywiyFpu0RfNZ3aIZn40TZsrok8a61PaSl0gPE6Yq
	+snVPiV5frhx3Z6Y1/fMtFPAXbblqC2YO7YwF7B3Qn8FIR+KeHdR6zfYVFaGU9BbpCqtSRTjAQe
	2S5Z9gtRkiOG6xKtWAP32Iyy7rKraq1VwYOjw0dOBnM+tMjPg0hW740UpbaZBpi6Vu7Kn/Ti7mf
	Xwm/+GyuLGQ6fzM9qXcByi
X-Google-Smtp-Source: AGHT+IHKduITjRZgFsxf3yZBdRQa7pPuvh/WM8xvhhS2h8K5RQK3iDkeKzriK0L3X6SSLeXOlUtobA==
X-Received: by 2002:a05:620a:3728:b0:85b:cd94:71fe with SMTP id af79cd13be357-8b33d1d1146mr1383638485a.33.1764005241928;
        Mon, 24 Nov 2025 09:27:21 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:e601:6a28:ae2e:9b22])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295f2f6dsm987992585a.54.2025.11.24.09.27.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 09:27:21 -0800 (PST)
Date: Mon, 24 Nov 2025 12:27:17 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chris Li <chrisl@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, pratmal@google.com,
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
Message-ID: <20251124172717.GA476776@cmpxchg.org>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
 <20251121114011.GA71307@cmpxchg.org>
 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3BD5918001E
X-Stat-Signature: toxnznwzscokapg4z43ujsrqdp4k1crn
X-HE-Tag: 1764005242-727528
X-HE-Meta: U2FsdGVkX1/kEP4pHOo9oUGkN6mvlohMnHLtPa996dDXqkIq1B7PAklRa2qC+iN/0t/13B+7PLjf7UOg/a8IIBpw1ZxpmdU83owZgDpq6fcN2e6JT0/c0cYCy3X2jeZ3BPbnCZBZ4Q4FDthTqSe8l82/ArJJXqdLLvYntJIHua1++vXrWdTSvF/GA+TGUgs2tExEmMyPrFUl/bPhe257K5UyYn9hnBlrOVD56nfSJdnoa7uHpa8mx64pXUx3aD/iRrrzoVtVCL0+y8X7Y9KzqywBfmlk92rBVwc2z4AChm1jahGHpkqD9N/zoDVcejHcv/+KMmzwdAcRnfbRv50BycO0WPgXRxjwRrnHR+hm/a8K2Jarw450pMRGJ3mRXragnG3p+BRknNXcNwBCmYN+MiIa1oZguupsv5FutnaI2ejFT4DNtdJBEbu6qJZnKZ3jYS/7kkjhX0pv7GyOljdIKsEnvH6ZrqzLUB6UGd0cT4zJkltTGXDgkXQg5TbfqCL1Lw7dbPjCUjqtUGos7njGOe8mqDCoV+i3oj+FjB5mESoT2s37i6F41ZfJhQoo+zUbpa3M5csck0NivrSV2oEUOZ2yFDGgeJrf4KcsqVbj5+CmsbtvSL5RVzgEdjzOlXqroHG64M9WxLGQF8rrHGqvfbN5FNUgegiS61kkP52Y+ChKYsaCxTgh6QH3K8180epQclO7KdG2QT+brLI3yevFkCmCSvAF7HGuB7gLR3toM5jmfUUNG0n83a5tA9gNJkwUfs0RIO2QbysT3XZLMNJu/yeHIyFGjNigBz4qQPK9skqMtMDdrc7POgykYgdLaWc9gl2ZCi4KRB8d/496JPDdFjTZ5sQ7XwKkxusPuRtnmgfstpsuzHX66hkm65GwrUnMosnXJj2BRZ9v/gStXnCfVQLa12n4GUHRTxYz7IghjWdRIUNTLBTl4cgx+RnnrSIQRVVWqdD8Wwz6n80Taki
 VP49spJ0
 Gx64HTUiJGivXN6tRJZSg9WopL+cQIWeJBf6Aq1XCquE2EmlTjKjOYEmmU0kDDFXKO4icxP6C4Nu7i8pqvgc/Q8HFHHmaqv+Ck99rrOQGNvKIY3jN71cfAk5+ZjbQ05T/dKqzw0vWFiK3IiYbVc3tZz7ZDpwKm05w/pOfJ4640oJyUEy5Nu1d0wJVbOUyg7DLst6vtunDPwNR80E9/eoVpJIIvSSEc/yBWfs9LUTO8GUH9IRsr6jl4/OaMlPh62B0KAGZVSWOeiNyr4POA5+KFrgYAGHowtLhLpLil2D8D+SiPKsJSXsoSvshDEar3qRpjGptcN2jIhmcRAL2q/V04c9uAd81emlwLJDiNAW84UoRGxaZJb52xJvbRO3pHZ8B9qyRjDiu4PzSu3yLydedtTr1F1HzWsbabeWvAyy8aXSOTlA59rieBpTVDvvXPQ7r4/XLYXEZUIRMfg8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 21, 2025 at 05:52:09PM -0800, Chris Li wrote:
> On Fri, Nov 21, 2025 at 3:40 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Fri, Nov 21, 2025 at 01:31:43AM -0800, Chris Li wrote:
> > > The current zswap requires a backing swapfile. The swap slot used
> > > by zswap is not able to be used by the swapfile. That waste swapfile
> > > space.
> > >
> > > The ghost swapfile is a swapfile that only contains the swapfile header
> > > for zswap. The swapfile header indicate the size of the swapfile. There
> > > is no swap data section in the ghost swapfile, therefore, no waste of
> > > swapfile space.  As such, any write to a ghost swapfile will fail. To
> > > prevents accidental read or write of ghost swapfile, bdev of
> > > swap_info_struct is set to NULL. Ghost swapfile will also set the SSD
> > > flag because there is no rotation disk access when using zswap.
> >
> > Zswap is primarily a compressed cache for real swap on secondary
> > storage. It's indeed quite important that entries currently in zswap
> > don't occupy disk slots; but for a solution to this to be acceptable,
> > it has to work with the primary usecase and support disk writeback.
> 
> Well, my plan is to support the writeback via swap.tiers.

Do you have a link to that proposal?

My understanding of swap tiers was about grouping different swapfiles
and assigning them to cgroups. The issue with writeback is relocating
the data that a swp_entry_t page table refers to - without having to
find and update all the possible page tables. I'm not sure how
swap.tiers solve this problem.

> > This direction is a dead-end. Please take a look at Nhat's swap
> > virtualization patches. They decouple zswap from disk geometry, while
> > still supporting writeback to an actual backend file.
> 
> Yes, there are many ways to decouple zswap from disk geometry, my swap
> table + swap.tiers design can do that as well. I have concerns about
> swap virtualization in the aspect of adding another layer of memory
> overhead addition per swap entry and CPU overhead of extra xarray
> lookup. I believe my approach is technically superior and cleaner.
> Both faster and cleaner. Basically swap.tiers + VFS like swap read
> write page ops. I will let Nhat clarify the performance and memory
> overhead side of the swap virtualization.

I'm happy to discuss it.

But keep in mind that the swap virtualization idea is a collaborative
product of quite a few people with an extensive combined upstream
record. Quite a bit of thought has gone into balancing static vs
runtime costs of that proposal. So you'll forgive me if I'm a bit
skeptical of the somewhat grandiose claims of one person that is new
to upstream development.

As to your specific points - we use xarray lookups in the page cache
fast path. It's a bold claim to say this would be too much overhead
during swapins.

Two, it's not clear to me how you want to make writeback efficient
*without* any sort of swap entry redirection. Walking all relevant
page tables is expensive; and you have to be able to find them first.

If you're talking about a redirection array as opposed to a tree -
static sizing of the compressed space is also a no-go. Zswap
utilization varies *widely* between workloads and different workload
combinations. Further, zswap consumes the same fungible resource as
uncompressed memory - there is really no excuse to burden users with
static sizing questions about this pool.

