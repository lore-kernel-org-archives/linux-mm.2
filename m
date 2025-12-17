Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E564DD66B82
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 18:19:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FF9C6B0098; Wed, 17 Dec 2025 13:19:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AD7E6B0099; Wed, 17 Dec 2025 13:19:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 182506B009B; Wed, 17 Dec 2025 13:19:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07DDE6B0098
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:19:38 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFB24140857
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:19:37 +0000 (UTC)
X-FDA: 84229775994.08.DF26E30
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id A969D14000D
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 18:19:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F8EVWL+k;
	spf=pass (imf26.hostedemail.com: domain of groeck7@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765995575;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBmZ7kW2H0lhdwfnREYdQswN1wdrxsMyFH0NyQJeWtc=;
	b=UPd3RyJYMHuXNmr6VwOPRrMfabjVvEXR4mS4as21RT0FbL3Piz10zbr+N+kVuF1M7yVJlD
	ERrkVmKJccCbcQv5ZRKzmI6uLo608AQlVjHIP3XB1/vsgpKEN9Os5mst4Y3/FRduAmk48P
	m6NuiePFKqppPgAgQX/QEk5IkhpSX0Q=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=F8EVWL+k;
	spf=pass (imf26.hostedemail.com: domain of groeck7@gmail.com designates 209.85.221.179 as permitted sender) smtp.mailfrom=groeck7@gmail.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765995575; a=rsa-sha256;
	cv=none;
	b=bhIDJbhpneO7ag2kFIzyAo5RfygegNvfB/Wuunhw0vViw9d7SU7DDyeJ/KdTiEHPiur32I
	NEXCMqLm6v90ZTu5vsy4112gZ8SYCdMYKwEMbD2A+OSbQaub98RDp7pajE46jsRSmE5PJt
	t9wqUlawJxCLQgVMGs/PMdqNx40Qy6A=
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-55b09d690dcso2325997e0c.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 10:19:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765995575; x=1766600375; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aBmZ7kW2H0lhdwfnREYdQswN1wdrxsMyFH0NyQJeWtc=;
        b=F8EVWL+kPW77sdsm8FO5kFlvS+UT7mLFi3T2hzHoK/1w/krwy+2x7B+hhqz4P/130P
         XFCtaPReKwXrvwGzVm1qpYJ0/IKF5iF7JKr6GuO9S8gWUDk2mDuBkC3OwFQZFgxZi9Ep
         YpwsOJD21C5qBE/3gTDXxoQ7NvI/zJJCeFxZVa5ewMN91Pp9OrsVI4qMIfNmtEc7mRiN
         OvIGRPC9tvJ2mxaKMPuETRLgj4OGnNikz8077WuT/x8e4YTOd+7z6oeC04OsPtYqWnsM
         NQ81Fp2x3uV6Yx3DuGOEp0HA5UqZrQiW3Arg2UlFfDgE4SQot5dgI2ozjmdSO4WM4xLd
         5jNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765995575; x=1766600375;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=aBmZ7kW2H0lhdwfnREYdQswN1wdrxsMyFH0NyQJeWtc=;
        b=NPTUTvyztDARTBs0hXGLWt8fFfFJZM7MWJKsXAr5RSuk08kNEqAWJUOmqiOCFZXMpG
         cOKuVu5gT8GqjL3rFqOpNLolyOcENEZyTpjSmAgVfUXc8o9HpoQ7CdsDRWjg0Q2pfkDj
         EGMID9M6uXOvz6GpwJJNMzYirD6itMKexYwygtxymrQK4ZMmR20edF5VxTGkPd4LK/Fk
         A/n+iZT58kNydO3AYWDffCuuPhF1kifbhbZKKOopWT4R4OAvUfSo9H/0HMngapw5GQSj
         IBY+t1zcdH60ykTxAbgdrFMCLcTA9rNsb+eVCE0FhGFsxvMSyBoUfUZTc3cx2+k9lSrZ
         8mCA==
X-Forwarded-Encrypted: i=1; AJvYcCUajgSwWYnQFQqbIdTGffCWOUzWIM4t9apvkynuskQfMwYtlPjreBi6FV1qzDGFCqwqxKSwgHJ38w==@kvack.org
X-Gm-Message-State: AOJu0Ywnc87NMCDNZXUi2ajuJ0nqoaCQORNdu0+UHEHjVFDZNVX/CFCS
	lG1+Xn8Vtd2w1V4L4ImcVACwjwUKL5bndoxIkgYIgzTC5jCPatq9At2Zc0E67A==
X-Gm-Gg: AY/fxX5vOgOyDHhOaVHFa8LUdv4GYL2Ne4rSPTPsF9koNMjI7OtTdFhghhDlmSm3PTk
	UbuRxqs3fex2/p3gTBiqrjbB9MwR/QYzWEybLwwpx97S49X49c2UF+pRNhBaRVv6a4/OzTuTAOX
	nvW0MpAfBKg3rYXTxCsP+joqL5fnmPXaKjk3jGAn2ljWeAgaRRMfJ8xChLBPJFXIJm9fMWfpPAh
	SZp03M3zJM+mO4e2iflgZsk+tNfFXsvSgDHgJ47V5AFxYEqcUiH4eGIKpBiJqZ/l+DneSP/Azir
	bDz9T4fxVWsBSx2TRiOX/gkXX3E0SU7W3DDH5tDkAk+I5SSpjba5Kgs+W3H1FbWWuJvbstrRwjn
	QhbGZ6J2xP9BjV9+VLs7okgh7UJMhxS0vNyNdVRqGmKR4ogP298fAifyw6HzBViKJC1WkbdwUWa
	ozCpYjl0kQcQKD3RH/KGPp3/lz
X-Google-Smtp-Source: AGHT+IFqmleOdEgL72/9jY1EOHmPumC/1MQqky+E6Nwsf8iy9iWznwntY6ixXDysEPK3wEDlyrqiiw==
X-Received: by 2002:a05:7022:6991:b0:11e:3e9:3e9e with SMTP id a92af1059eb24-11f34c35ce1mr16363752c88.49.1765990033618;
        Wed, 17 Dec 2025 08:47:13 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f446460c8sm26892234c88.10.2025.12.17.08.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 08:47:12 -0800 (PST)
Date: Wed, 17 Dec 2025 08:47:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] mm/page_alloc: restore 0-handling to
 zone_set_pageset_high_and_batch
Message-ID: <db40ce77-4762-4d99-b03a-439c977ba1b8@roeck-us.net>
References: <20251217060505.681923-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217060505.681923-1-joshua.hahnjy@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A969D14000D
X-Stat-Signature: 5topzihp9tbinxaxbtn4iuz9cugs8baq
X-HE-Tag: 1765995575-6317
X-HE-Meta: U2FsdGVkX1/w9QEBE/UiY2YWuW819wLDnfJ3ujPQSJlEQL1JMcleZ0jSCKgbJndssqN6t43FWGie6bdWIelOBKoVWY9gC5uRww19kPp6XmeXhu1HiWQhACCsd3uhOvESdxXc1Q4GZK8f5PPicxlUiOQ9S1eVL6sAVXH2FXytRlt+5+l5JbhJKM/7nB0EKE4BJS6/doIn1OsNOQ2QcFlr8Wy8R2DLR+ChEFAtI1WYyHIBpKzUDEwzq4rBKYwyntK9tZDboJ14whmtXlse8drLohG7KAS4tI2MOSwb1Jfkb16QPTgbyh0gPERxeEws+MJHXDBNcnHj4Ox8gP7/bjORWMXYiwLH3CAKYsw9xQi+ubnM7mZWiLHarLwKsEeAROkIaB5iTMtAzrY6v64YhFNmohFpSFgOo3Z6jIi4DeJDCz/ANUi/771VD9ET/VnLvvG+01F//br9/AdlwvsMM21vNTzEE7E4u/SYa3xGBkFAlDU1aNrNDsSpJHpZZwYkqFCZxkessDbYN5aMiRusUAPV+tPbjdisMGDi/cf9lDNUvQ00St+MZmHYFmwHU9El9W29uZKWJetGQtmM3F+nmnXtzGrY0coPxichKWbCdLASQ/ZzUIjtR9kDJp/NU03KmJvu9B2NKb1gGM9S0u6X3Il4LDwiHd1AJPNd70Y1gG3e7G1AlSS6vPRzEJO4UIxhU+QGN2Sdm5V8u/o/0IARm6rmk383bTvhOXRt02SU9C1Tvznc405guyqDBUubAZX6yMXy8cZmfy/vb2sqSef2l1YUUEoD3/5A3Js913W9zVR6TEMZg5ZksoMS+bgPZdZGobYpqDq+/63LWGMxS9Ahs5hk4Xhej6RFfFe8M9G+ELeVEmmckVjwI15n3B+Y49Q7Qqeq+Of/dDJyDsXtYhTEwIyh5KWNBgNQL0S3gnx0EiM81NX75bajdWRZ94Muj0zGFNs68k7LicyPlKUECqRbOIK
 LcG2q6Ky
 wLGllAsoZQ383bxE7er5vUzb1XbF+3y0lyaGiPLFL//KvC0+NkYF5ifGpo7oyYzuJH/JgR2OIoXbq4fllpFRos99Yfz5XnrNp2cyfJgTNUdblaAu0xQ+aPMLxNMlh/4UHmzQoqblio65FBZ1SLEakt26qUm0zUmaKN27V51AXORDZ21SLjbO/rAkRlYPyHKZUTGJgCfGhaOgW9Ohi8vR7fjYwYiaPh8q2Z8H1gdPufkBXK7EiHKWWcFpE2G+3YfJBUTBamZ/BM3PAZUcCPsiBYB2tqVYXJQ+zKz76QaTOxQkhf88TcbXU/QNiSuRX/Xt7JRIJsoZQ4v5sMLMB1xxUHhFvhfnBm3l+bZy8SGaipu9zPwTqKmrWM5wtZBBDk+UfMFmwNKD9hz9G7xSVEGgLRxceONIgYeMZa3IA6hUi3NtXD21uRf4H0eVdsG7369BUqHsUwfYtCvvDoFdaoghvkxySZFiuvLgZE4EjD9x/GuY6BVjp07H4tBy+yql4VL08HC1pH//hGT0nH+2DZoOHa2oOrDPDbEKM+Z2ccz7bGwsDKShu5hN8lYRswxQGME763ugYLRDCNu+TarODTv8CNBiVlorraaA0l5qilkZ27MpPzVD56RbDYUCmEEIKta9X77bmJp/bAF4qVwZNWIUUrD8YCfxZVSDlBpb7xizxFDBtQOaijkPPKqeeHPJ7PSuLMqsl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 10:05:03PM -0800, Joshua Hahn wrote:
> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> moved the error handling (0-handling) of zone_batchsize from its
> callers to inside the function. However, the commit left out the error
> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> 
> Since in the NOMMU case the reported-to-user batchsize should still be 0,
> we would only like the error handling to exist in the callsites that
> set the internal value for the zone (i.e. zone_set_pageset_high_and_batch).
> 
> Restore max(1, zone_batchsize(zone)) to the callsite to prevent errors
> on NOMMU systems.
> 
> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> Reported-by: Daniel Palmer <daniel@thingy.jp>
> Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

For m68k:mcf5208evb boot tests with qemu:

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter

