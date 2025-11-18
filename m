Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28ED8CCD19A
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:52:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8452A8E0026; Tue, 18 Nov 2025 02:52:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F5AC8E0005; Tue, 18 Nov 2025 02:52:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E45E8E0026; Tue, 18 Nov 2025 02:52:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 591EF8E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:52:31 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E525312949
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:52:30 +0000 (UTC)
X-FDA: 84122960460.28.9B07D28
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf14.hostedemail.com (Postfix) with ESMTP id 402B910000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:52:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c7PC7sq1;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763452349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8o0lzY5+KXKP51IAC5h7ABQJPt8SMWT+JESmyEuQ4GM=;
	b=o1JbwzvsYJb6480c7z+YO8WK2gKm7VXmzrs5xBxWcLz+BZhU2YwJ3djpnnfsZS3JtWHtfm
	mZpmXXf7aPgU5V+tJN0wkgp18PXSkIg3ZvsIi+xfPIlo048HJclUnyL3tx3rfnVASTkvi6
	XMJyuQxn/73GqqhluXO6BdFhhytzvrc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763452349; a=rsa-sha256;
	cv=none;
	b=VJG7sTAA750AyZdAlalitPChqN8LGitMXkUpGC3XM4HeHG6XQxomMHSDn7vMuegkEyx5tg
	v/tBlby/CiUQjjoUjlHknbCvRwHXJd81jtw/kX0TDWIIMZcEkjgg5lBSVv1pksByDMHaaJ
	pMCNfd7aMrlPgHM3TXYfB5LypXmTHE0=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=c7PC7sq1;
	spf=pass (imf14.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.181 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7a9cdf62d31so6327577b3a.3
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:52:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763452348; x=1764057148; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8o0lzY5+KXKP51IAC5h7ABQJPt8SMWT+JESmyEuQ4GM=;
        b=c7PC7sq1Swab8pZInhMolMgPmpyRoEe7hh2i3s+zhEI6lUUohKtv2bT9iXm2BBpn5o
         KwWHnFRnuZzHrma/Uf6j19L723LYgpbr0/plymElpSp1cBchSFjiI0pdaK2HJjrKpv6p
         8i2NbMyLyViw33u/pch+/tXXPfu2wDC+TGmeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763452348; x=1764057148;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8o0lzY5+KXKP51IAC5h7ABQJPt8SMWT+JESmyEuQ4GM=;
        b=GmRXefDsJlfob1rW+X7XQrA1yar+DbpFHhNayOyjJe+p/cBdxkhRI6wRvhv3/7lC5i
         goTUEa8Mf4jZiBV/t+Yyf5ULNjAWv/S9EF4IvPMkGVzSsE++PVfc5JZYTDHUUkhsygVW
         LX1MEX8/JQ/KZZ7IHcqjhEm34Ya8QH3OygaBieFyAI0djUYzhprauzjdlkwmsKOO4RKM
         vQ8R0+GclDB+kVo30jo+P8Y+WtlFBdWd9Io+CkX+w7xwhCcwylyQSbPuyi/brrh+Iztf
         rZhIJROSHsar/i6INs6LPmHUZpruvzUJddGLwAOxnz93UTgwQjkmowoA3j8qdBDH/lSa
         HZJA==
X-Forwarded-Encrypted: i=1; AJvYcCUQ/5NqA160p3hFs9S5DRJWnQtPX7OFKdutqLkEjr2skpoPCFW+4CH0CI4oDvEYeNIyxK1yVcLIYw==@kvack.org
X-Gm-Message-State: AOJu0YxA2YROjXSawy9vnQNv4PZsBnoUaoLEQ2PXXhWi5TVxpzbd4vxW
	gl6v5AuvoffgMGCoQcehH5LnEWDn4vlWlqkSX3tgHvyA9ewEcuuB7/X98nw5QKvrKA==
X-Gm-Gg: ASbGncvi4TgJcR0yZr8LjEfThF3a9daraPezzO5gCCr153/k24HMOWLR/f7SC1pMxlv
	FX8XRzdoOMRH9etHonj6/b92fHmMOm+qVgRZqSpd7EVSt+ngYH6H6t70StlydEhKI2PWUsdTpYx
	pKECDZWvgAc9iNtbNV0EAMKf3tri+nSchvyotouEq+jCY0XAGbxypeweDgLoQK1TGh6QZF9fklW
	Wb15T3o8syKcqb5K7pWrTDS1T74t//rf3NWswzjsXk1NB/s1WUzcmfS7S4+cCb6i7VvbFA9t/JQ
	FPtX9dbN58Jw4hIL3HEXxiWGDX8LIY/vZx8Jubx1d0kaymWb6p0dFda/GVqICdcBAUJLO3rX+l5
	9kAnjdMxou7hDfP6OMtdBCSy+2Hg9VrrsO5wmtHMRKVczAbYDTniaTG9Jl3SdZOjNQGwqM7J6yW
	8Av+XaCjQdS5cQyRA=
X-Google-Smtp-Source: AGHT+IFA5v96ReJAqZwqn5Ht/zD2TwsmTS/QwZ4pMs1RMftRZA4u6b3AE4qcFjb1+ZXHb5341uOCmQ==
X-Received: by 2002:a05:6a21:6d95:b0:34f:afaa:125b with SMTP id adf61e73a8af0-35ba1f96f23mr19782645637.50.1763452348006;
        Mon, 17 Nov 2025 23:52:28 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7b924aee147sm15609775b3a.13.2025.11.17.23.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:52:27 -0800 (PST)
Date: Tue, 18 Nov 2025 16:52:23 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yuwen Chen <ywen.chen@foxmail.com>
Cc: senozhatsky@chromium.org, akpm@linux-foundation.org, 
	bgeffon@google.com, licayy@outlook.com, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, richardycc@google.com
Subject: Re: [PATCH] zram: Fix the issue that the write - back limits might
 overflow
Message-ID: <bo4g7erropsvl7vulufdsjqlkkbjycaounh2vv4a6urttxvubr@f22z5wlgntox>
References: <tencent_80150170978D13BAF69D63E57D7F5175F90A@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_80150170978D13BAF69D63E57D7F5175F90A@qq.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 402B910000E
X-Stat-Signature: wwseqz6pgn8bskshecesbrn7n7ihpdj6
X-Rspam-User: 
X-HE-Tag: 1763452349-323326
X-HE-Meta: U2FsdGVkX1/udkd76fd7POjPyx8BFgQN9cwEdOBPUNxxY4XUnRr7kZ4j0dQKtwG/A1WUtJHZXLM3To0ubDIxbcoG4PfKijE4aVkRBVQs7PkNEM8e3ht35I0pTR25Rcx9owJi2eh6onP0GXU6F0TDUAGaqTE6knYlkF4JKZfHidzVvwqvfGQUuR83edMR53m7JNsgwkMvCFZayQYXvETjxcdWsdANSIBJ1Uq1U5VlGsPQje9WZtkRC/N7gTEvXb1TcwqFPyu8Ef3zI6wKNjGCGlnKBHCHkvH8FQABJ3ldsbe4zUm2TGtXLSJviFKuW41eqI2/QJigeZtNfJlWOfqRwjiNcLoT9mLrMD93AXTGo35uDnDYk2l/G/36vbJUdmYntqthXMU5Nbbin6iM6wlryCiR9TtESUb+SXfRNHi6HOLhSfIF0kpiOoTdYpNtgRt7ppXa2h1U5NR8Mb4BTK5e3x28+SmTYlFG4/6OY4UTvrKHZ64hKT7X9KrhnSsSNfkadmSMUFttem07rlKK1Lf7OgB7P1bc6tNmxDJ7lFnDS88kXRBENcDWcDjGBqPmj/XMcP1X/sHjgWoifiLbgvqU36+8kVTgiGEPgtHRs/mOQcsO0QCCJ1UAQahM7IehfQdLGRmwvpTUPI3l45pfVKlKzwOsAf3hqFxHiBgpTuGu+yVklBjXIpjG/7oZWV55eVMH7uZFYCp/Fg+2VIb/WFf9U6QuPyA/bGBACJrYtrQH/zwBP/7XDkREnrfa1nkEKqRpRQ2LOt1T57+erhxZybPffevSSVBoGnR58uSmIg5T651wJ37+IIQsvnAWgt5DD4aWUMRdMJfb8bMm2LgnWJ7Q/QDXfRWKpS60KS/v7MpGRg9i4kx9Ljk+/6szWC13KUTBtatW4voUEdz+ZRkpvr8pxQqU9ciSbzDitQOPjQ19wHS1upxvtUhXOkIjuQxXw0KzbBvc90Pk8k1vHDMxZVQ
 qgMFN9tE
 gdJS9ZpgCE93YrEKZP0/cmKfdRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/18 15:39), Yuwen Chen wrote:
> Since the value of bd_wb_limit is an unsigned number, when the
> page size is larger than 4 KB, it may cause an out-of-bounds situation.
> 
> This patch fixes the issue by limiting bd_wb_limit to be an
> integer multiple of PAGE_SIZE / 4096.

I really wish we could just change wb code to use PAGE_SIZE not 4K
units [1], unfortunately it's probably too late to change that now.

[1] https://lore.kernel.org/linux-kernel/20251110052741.92031-1-senozhatsky@chromium.org

