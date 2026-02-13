Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86DBDEDF16D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 14:56:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADC46B0088; Fri, 13 Feb 2026 09:56:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8F5B6B008A; Fri, 13 Feb 2026 09:56:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D91986B008C; Fri, 13 Feb 2026 09:56:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CBBB66B0088
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 09:56:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 67F5C14051C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:56:17 +0000 (UTC)
X-FDA: 84439733994.11.A2C8E67
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8358A4000C
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 14:56:15 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fOQZLGOb;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770994575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwsEqaBdw1rxnJ7KogulxbizNtd5F5e30OQjotZBOO8=;
	b=SyumbhYulVW+3B2N0uKIiVyVcEGt+WDcwOkz2D/wGgstqK64KvFvnbPHmryS0H27c/rt32
	VFsa4XOBwRY9SdDuAAjtkM1DvfT0jfDF2ejYDxsNT+7zLQrFy4Au15/9KtCG8UXMMl7dSg
	lcMscd/QkzC7jxXSHNuLglceyCeVOTI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770994575; a=rsa-sha256;
	cv=none;
	b=beBlPDy3yCGmToZYuD82Kx/vzwv5Q4BBCzQwYOtPtMgqAhR2E+0XVcCAcyB/ak0aAB4h4c
	UfKpaHKH3AlkQIkJCcf4xfVdHafqyMiDo/Y4Ns+WMdZnZQSvegEKDNz5CHmHq/fw4h8Iyb
	e7ufc+JtI7BKnCWe4PpU7EDt2r5Fdik=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fOQZLGOb;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-506a3400f30so9979251cf.1
        for <linux-mm@kvack.org>; Fri, 13 Feb 2026 06:56:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770994574; x=1771599374; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qwsEqaBdw1rxnJ7KogulxbizNtd5F5e30OQjotZBOO8=;
        b=fOQZLGObEC4LmANTfQXVYRXspSbkYnwDKvgMBXsMqTM1Z7safxhHnSnYilLgwuv8Kq
         Wi8UA0vTwcbuEEBrcJGW1olBoOv9QPHz/Hyfi2M0MeGLBeH/LrKAKFdGAZ700iZCi8PY
         aq+y+xPUXkxkQAAIaQmOls+AZTKdX3jj97AQu4M0BoY6kY7LzC+ikNLZ3PmUhusv11sl
         gAkg2hb4XWWBJqpLEnDx7X/SnBTnRzC4CbetLwYbGo2/ndKrEQ7/Y1HU2naPHU1eZfLG
         BsB52OPi38VyM5n5eq+9Y3jVBNIHi58NrDdZC4gBRNe4jaUUrpsYLL9RR9ir7h7FqjgL
         JIfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770994574; x=1771599374;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwsEqaBdw1rxnJ7KogulxbizNtd5F5e30OQjotZBOO8=;
        b=atjiV0pbLc2d8uhxy1RyKsa5qJnwYMAGk8+kLthqfYehrDJbIzFVp4e6hkPFFDDpM8
         zt20FwTnG3pg+NWWh2XvW7ImiTCNE/hsIstP1QnQQQ0j4MWgQtTeCu28QzgLsqp6jJw2
         WnVs/Tfm2pHB9/mXYCxjhsId6rxzMMQAvIEPglIbcwmBF4+6W7PPvWEw5n490zzDIdS5
         1gvV7DyGHgnnatLHxfep0jINDC9a73OVhRp8JeHATlEKKAehYS8V3XCILCKRaPxKkJep
         d7hrp9vJdlWYar2gnWg1vCxdA+35rsycChfLS1gThW3yUQKv87Mqi2oJgYIB1L8g7FFn
         t8/A==
X-Forwarded-Encrypted: i=1; AJvYcCVyMDbhrcAJ2BsKxprSRwjm48wXUOY1hNJfX32MLimHYk3ja/wm/sGU/9yZ1Xkaf0eUUVBqyfC5/w==@kvack.org
X-Gm-Message-State: AOJu0YzZyC1vtm6I3xKBrR4VD+qNbXpQJDSMNh6WR1O6L2KLFpw6FoLN
	xnIyQbtL7+NU1IJvlEoU3ang59qgMtdFfR5AIzSv4xIVHilzLapRnph2ZBAKUaer4Gk=
X-Gm-Gg: AZuq6aJ2jwW1Vka/gSuCBGwR1sOc8pJDnwRUv8f194+IHkwlaBvH9tpvym680tqxG+n
	b78iK+XYZhSSqDJ22IpusMbbrK1kAP7MnrxgKC5Q+J6RsWusQTvVxJ5mU7jsOGgPsWjr86q5rWv
	Q4EvMID1DHktHz5jfMJvX2dBtw0rgQ+5VJKTJ6C2hu01La/Owzmg215OLZCEmT4nBAdT3Qbh2TU
	eUWvGrjbfrj6U78GfhMjf0QH2y3b13R49UyhNCqYk1HeWMLUhiXXbBaKfTiXRO0Xr4Jkwtoxi8N
	sZhJ0aLDVGhDfBxlcNpYpuUP0UxP1OlZpozygXWGFGv0mKg5zRfNqSPsOh8IIpPNQ5OkrkADGFU
	f1nbIIlQp7nmEnNvMYjcQXRryETrJhMNRPdbUpNzYK/9HRDfdWxVE15DYRSN6fEuiPEVIJOwvg7
	Pv+p/GMKKRpCSogEru1LDPyNXuqoV7wmWolyFXq/B0Xn6NuCSlEXJtVMKN0hlmMVA8pumAAicjm
	f6G2p7xsd7puhc+gtkq
X-Received: by 2002:ac8:584f:0:b0:4f1:c601:3ca4 with SMTP id d75a77b69052e-506b2731b93mr5466181cf.32.1770994574508;
        Fri, 13 Feb 2026 06:56:14 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cdbf972sm64521896d6.44.2026.02.13.06.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Feb 2026 06:56:13 -0800 (PST)
Date: Fri, 13 Feb 2026 09:56:11 -0500
From: Gregory Price <gourry@gourry.net>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com
Subject: Re: [RFC PATCH v5 00/10] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aY87i3dG5xmDpWkE@gourry-fedora-PF4VCD3F>
References: <20260129144043.231636-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260129144043.231636-1-bharata@amd.com>
X-Rspamd-Queue-Id: 8358A4000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: tbwbdiuri1d7aj9jfhtg1tndhzd718oy
X-HE-Tag: 1770994575-400391
X-HE-Meta: U2FsdGVkX1/CpG3qPE+B1sdH1L0sEfuq9GcFWOqDXYSBq7KJYhcidw+rbQMY5ANi7mXihuL+kggeWaGg1ghX/MFE/6xg2IbLG+D8aJOn8IlgcRb07nP/Bsnb8Yf9bZ6R5rpsRUQdOk3yw4MXU1Mot8lpbldcW+mRqKp2vxpRWXakOxg4TmHX4p1RkKA0n32gNdqsAuqR2zJXtkDkEeP0cIldXWpNRSqFB8BPJAD374QFqB17gaLdxRqaMEFW0NCg1EFlAkz5hLqYKUC7auiynBwwl2jB//rRok+BlSU+U2IAVpA+RiuCneylSyzoYBDwA/6DDJB649v0XzmnOYVhe1Q1fZsMVCrIn9fg5t0iSr/qW154hLnbALFgWPAzefY5OP9dgIEgKEwt5y0/9lcNFge+nBYbUH391ObJgj954SAQGm5NXgkI8e3BYO6akaFHkIxweUmpUI9hUWUKRsiaw2DzgLf/PPpuCNim9bmw8qfRZ0lPbTVDL8O2ticH6/I/dNkj5ew5aMbj2eDnHhYGtCo3LKKOfc9F89S6QB3wqlthlNky+JsLPvrp0bVIpdjKf9WfNS1/uwkxUaeEkOQ3qB1NMIDk4oDgU6NBX3UTou94IYRmZMmqghB3pAQQ5LNu7Yrt6lc3XYuE3vBbw6GH7Bw+M25UT9UNue69rornN531efWXQHW/BjSRTHyuN4AToFYiJsxrfgDlnoCpdpQTgXanRkwm//OHjgqFFrofJ2aB1P++Nk8rvIzsXmLiuvjZvAFntBIb+iCz/ZfAaOfUWj2nQ/6r1GTRx/6znfyDBS9BmclDaDjaeETWXgxrzavV7I5B5xKsoOMhnLIepOGurcK02iLR6B5pA6xdXxZ/mfcJEalDWirpmPe0GwdAePuC5782S1MHD1iso3owKTQrpso7uYU9yeMCIX5wIY6Vw3Zcsy3BJVMYeTo5uVMhdBGWKVzmY/T/goQXA4N1e88
 lWcaF3be
 mdl+Xu7/9yNDWpZd5D1HPieV9YPaNrZxNMXgFbsPkhm82uQ0dmOfWnqDhdKy4KRBjml0tdw5JEUahelCGfkOysmni/YRPzgz/IPUUI5S/JJdiE1XGFKaBm5iHogrFNS8l5IT7vfgYGIU0fsWp4Gkn0y0rC6TdhwXCkor+B+DBGCMmEX3qaFgkqgJoGqM8VTWFRpbWOpZgHGV7oDFKI4o77yZupwEC7XSycB+A5tzW/6WgnSbv7E+2XPqDXJWd7Es9X4bvE7YNhJCwTbEcbt6aWuztvbGh8XYcIGYbC8lc0lJFZLDhVeG/mvHvaosfoRp4xkMxkaxxN8Ya3p8VEykjfln1zZ5LfD6+vCa4R5igeCKL6moG/pAcIAkmvOD4yGZ2LA4nXiug3TIWX0DkKTz38b0vjA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 08:10:33PM +0530, Bharata B Rao wrote:
> Hi,
> 
> This is v5 of pghot, a hot-page tracking and promotion subsystem.
> The major change in v5 is reducing the default hotness record size
> to 1 byte per PFN and adding an optional precision mode
> (CONFIG_PGHOT_PRECISE) that uses 4 bytes per PFN.
> 

In the future can you add a 

base-commit:

for the series?  Make's it easier to automate pulling it in for testing
and backports etc.

~Gregory

