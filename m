Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CED25E81A44
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 16:42:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B78036B0088; Mon, 16 Feb 2026 11:42:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B25F56B0089; Mon, 16 Feb 2026 11:42:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A071F6B008A; Mon, 16 Feb 2026 11:42:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9DB6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 11:42:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28C661B524E
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:42:35 +0000 (UTC)
X-FDA: 84450888270.21.787564F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id 2AB674000D
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:42:32 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YrlbQhzh;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771260153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oFhCarEUO09Uu/U8iDB3xuYqQii9sFIgHbs/DlTAlHE=;
	b=MhHdB7DaPcYtZ77OuEi52ZFKhGGL4l5eLjO5bG6i/qWebsiXBRANhixS39fNddIZcOpQ1+
	gD2GEbFY/3oOq3k1/WWVEaQaLHuauO7IbWcZAym4GMsTN4NTwgHiocF8QZoixMW8Y0oDHn
	C/aIPqhQzIIIE504OFFsMyJ7Mp4XnCU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=YrlbQhzh;
	spf=pass (imf12.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771260153; a=rsa-sha256;
	cv=none;
	b=uI5QG+zafxxsq6Knnevc57kPeEGFe1OLKoa0Ll/5Py0ZAbgNHCDrFiGPrGhpcM4ky1BOUn
	JRjIrM4NHC+TeOfKm9iZ2RI19VO8WlojSp7VHcjz0NxakjeKkgM4dPdKFtPwA2GgRZ1fbk
	EdKE7gAMaoT76hPbXYT6smxUBCdV9D0=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-48379a42f76so19487395e9.0
        for <linux-mm@kvack.org>; Mon, 16 Feb 2026 08:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1771260151; x=1771864951; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oFhCarEUO09Uu/U8iDB3xuYqQii9sFIgHbs/DlTAlHE=;
        b=YrlbQhzhmCWA23KmGAtC/Wf0NdXORPeGDc4RPGR4PfO0bGB4IdHLI23ZdAZRkTEqWJ
         DXF61DaNTuOkVK/K+H5qy0QnNvxB/YzXhMvxQuxOquTwkIWNswNZYFp28YMx8xOYFZVM
         IoL4s7lTtkW8aRnJlau3zyZMhRYu38tr7iw9j1dA7ENSQ8QtoBtb2+BOOdlVhydNB6lb
         wgNryOa4whKRxA7ADIVG0biEptRMWR8v6GJnL1MSrs3//Qt5PuL8U5lN/0bQ4NP2TFDA
         DnEzWWC0no3sjQCftvibP7DrPCjdIb52yjQe6v8lWX4ixoyXSKngR5ncYUPAuITm16/D
         6ILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260151; x=1771864951;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oFhCarEUO09Uu/U8iDB3xuYqQii9sFIgHbs/DlTAlHE=;
        b=Zef3fVTqPFGGQqQtO34H+47qi2HJJ0m4afkQNl0lUubfTGlXpzj9pago/i10l4EfJ9
         69Ht4nuSQqhsb1ffvcGBqZJk2OvU6ncTej2/D8zcYL9lckQB62iipiKWXUKmcB0waWvk
         zfJOyzBHuOQKJvFonmxbT3HiNL873ggRqAV12cH4K+I9ep0RSVQQZeNFManFRrKwjKeh
         0TPvb0/qjwEOn4eLjsqzrFkmlLdzOY3eF/6kTsqyH+aLsFAJvSbSrDMo9YkRAqba4Pn6
         tDb5omJkky5vuBocoR2kHs5JNqWU9/auD5BWVEteoZUgJxb8btcqtY4+sONPHQc9zHj3
         4ysg==
X-Forwarded-Encrypted: i=1; AJvYcCVhAKdQIAeeaiin6jD0CeLwaTWtjqAct+Q5ZxiFHsFtWjgzNnqegxG4pS9G7U/ETP2h4OmOZiZBvg==@kvack.org
X-Gm-Message-State: AOJu0YyyUCk3DhRytDJkNWc11BuqH3EXpX5uZaeOVZDbZ5aN8+KkYDiu
	BwRghyyJTKTzuixu4z7tN4JxkMDprsPM4Zos3uqpzVMuJsHyaExLyI1+DwMvpq+eUW4=
X-Gm-Gg: AZuq6aJnfhxot8ai36gCpmVZ7eFHXjVhxXwuhTTQyw9tMLjJ012bSZXdN1Bj/S+SxMh
	nbR9BZupBX5yxrqV4sKUmyxFEbu54XwLttYhoR8XAcLdR7bC24pOaDdkm9//l68ynkYCYqDS5yk
	Qp2n/4iw4v6UT+raB2UK56LJBEuqsHQjd3qUjkAfBoVMnTJ2ONgenI/eWEz5IDkqR/XXm7/CLgD
	Gw87/HHYBM2ScsGuHa6/T9wFGc3UGs2MDemSFuvICsslutnEnE/zLi7et3cab+/GeMJPo5KM7XX
	wX0gx4uVwujZu9DfWPqELgCRjQx7rnqrgVgUAL/Lbw0cEJ/0iIbMDl2WXkLHDZ/T1NUC1UTPTZk
	0BkBtpErAjSVp0tD/YrmLqcLzae/JbkCN28MJ8WnlFIJRyxoO1BaUsTXY9MLykhvvPlGW5Q8Xof
	/BU1XNCEVCg9OvtUVY+X5Pkb40/jTefmTE34Bb
X-Received: by 2002:a05:600c:4e93:b0:47a:814c:ee95 with SMTP id 5b1f17b1804b1-48379bbcbd0mr141094425e9.12.1771260151407;
        Mon, 16 Feb 2026 08:42:31 -0800 (PST)
Received: from localhost (109-81-87-131.rct.o2.cz. [109.81.87.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48370ac3564sm244993715e9.5.2026.02.16.08.42.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 08:42:31 -0800 (PST)
Date: Mon, 16 Feb 2026 17:42:30 +0100
From: Michal Hocko <mhocko@suse.com>
To: Wenchao Hao <haowenchao22@gmail.com>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
Message-ID: <aZNI9mo34vs27DXz@tiehlicka>
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
 <aZMAVF1S1kP5Gny_@thinkstation>
 <ddb0d3f8-a617-49a2-8fb1-e6293f376030@kernel.org>
 <aZMEvl7WUKyxmgIh@thinkstation>
 <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOptpSNMx7moZnLP1Q9xX_6zw2xJL4OV4N=f8rzyZBLuTMEJnQ@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2AB674000D
X-Stat-Signature: tt47irwypud3jym8nkijdsxcnfqu6czh
X-Rspam-User: 
X-HE-Tag: 1771260152-281813
X-HE-Meta: U2FsdGVkX1/J0w7LmdIKqeMQRAtelmcZRHCbHG8PP0jjs7LV2Iuc/sEWHtlzquG2AmkYnVeA9RuMwmE3JoaBu50wEDeU7nbtFljonQZ+lpX0m1mXSgysyFsy7tiVa0ZJdtQKvZbUG4QyZLyzx2h7rVbeYpO7y8tlpS/gi8qs/+VNJcDdj0r3KquU8ZRZEM83XNp0G4NTQ8fLBsxkNA4QOKZ5oY8Zt2vFXD9G8M0CpOAnNCUJn3hn1VESDA4sfkLgBZ9NGEC0QFgHse/OPgDH4Y0d5l5NESMCwJsJOq+lkPsmShE0iADpYd2564Xg+QxeOigMBbuUQCAnyYYWtpGRRK4ukNCbTBULz7R65OoQH5J6Mi+pGjbcSgQ6BxxXg6ipwW3GwS1u93Eiu5r07GlBH2M1Xee+awr8L62Pv3FlNZvCZ5A2IEf+ePllj+sQSsqx8P+Zgj4pck1EUxZtzJbxjs81m5i/kQkkGhCRkZ5YHuKjzQqaN3/8S7lO7Gp+qLORl8UH2rq5+saGJCgCiday30dRzuclWtKUGIFA9a96Jq28gHQ7eg2SEoclKFzMJg1O2OS63Zm2JuB5bxej3mTWL8cxUDUuWyfTh0M7UGhROMmcm7fhzIOr+EGYwOxVPlrPu1be+Dq68sArEFy2MT/t8VJJ8/l85fwqEvPS4fXm8/IPx9aCvySS3hfCuivAqz/t68ePVSqR+xnq+46tLclfFA5a9YUmrkdre81lz7S92WMKofSAylj1lvaLbn/iWUQWajltcgFMl+20lbXfvTTB4sNA8/RL/dWo4Yo+eBiWOWB5lbZLd8U0hhMcbxCTZh8mcyr/RhXuZ4VK4tGBUEK4SntQB2VtxLxu12Spjy6xOLXXJ6wV0IvzmuwagaDtTZUXToFFY27JVbemOGxyRSgpzWWPhmwRbuoQtfVOEVTJRW6UZkE8pWmMhCwVJ8pSLZAvXu1Uegg/O3G/6Jtts9a
 xAF1nswa
 beBJ4A5P1cSp4VZAN9aEsJIrrwh5y3JJV6tRoEb8lY1yyHJedH3m3FexBSlAuyqiDS0f65zxWhzDVJGganJ563ssNzcXL+enU9UgfAX6O9Lx3kBRs06nx6IwNxVaZqsDZ2YKwaWeA7CP67GHD9Mzh+xgyG6MfT7JFDKpTvN9UA9UP7cv6dd5Q3tbHlOVsY5iFkJcah/5TkbioRQT9Z6qc5ZfTvMoia5LPPsqFyhwRoVyoCzg7V+cUpCy7qz0WOqxR6nivxrPfTJtOJ3wKDGWARf+jveiNo90x55eHE1+iqMyPalWP558vkcJwmFGv9/lMK81sRKJ3A4nMY3ai99LSt+uvJFqYWdQSAxEp+MHhWm4nJg9gZl3Sq/y30o6ENhj61vW5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 16-02-26 23:59:50, Wenchao Hao wrote:
> On Mon, Feb 16, 2026 at 7:58 PM Kiryl Shutsemau <kirill@shutemov.name> wrote:
> >
> > On Mon, Feb 16, 2026 at 12:45:13PM +0100, David Hildenbrand (Arm) wrote:
> > > On 2/16/26 12:34, Kiryl Shutsemau wrote:
> > > > On Sat, Feb 14, 2026 at 04:45:14PM +0800, Wenchao Hao wrote:
> > > > > Add kernel command line option "count_zero_page" to track anonymous pages
> > > > > have been allocated and mapped to userspace but zero-filled.
> > > > >
> > > > > This feature is mainly used to debug large folio mechanism, which
> > > > > pre-allocates and map more pages than actually needed, leading to memory
> > > > > waste from unaccessed pages.
> > > > >
> > > > > Export the result in /proc/pid/smaps as "AnonZero" field.
> > > >
> > > > I expect it to slowdown /proc/pid/smaps read substantially. I don't
> > > > think this line in smaps worth it.
> > > >
> > >
> > > That's why it's enabled through a command line parameter.
> >
> > One users want the stat and all users on the machine pay the price?
> > That's a poor trade off.
> >
> > In general, smaps scales poorly. It collects a lot of stats and most of
> > them are ignored by user. We need something like statx(2) where user can
> > declare what he is interested in, so kernel won't waste cycles.
> >
> 
> I initially considered two approaches:
> 
> First, exposing the needed information via smaps. This does incur some
> performance cost but is the simplest to implement. The new feature can be
> dynamically toggled via a command-line parameter. When disabled, the
> overhead is negligible—only a minor if check, which is insignificant compared
> to the full smaps cost.

You are comparing content of all anon pages, aren't you? Depending on
the content this can add a lot of overhead.

> Second, adding a new system call or extending madvise with a new command
> like MADV_GET_ZEROANON. Userspace tools can then use it to measure
> memory waste from zero-filled anonymous huge pages.

MADV_GET_ZEROPAGE would make more sense to me. But a more fundamental
question is whether this metric is really what you want long term.
Kernel can do all sorts of optimizations behind userspace back - e.g.
map shared zero page - so just learning that a process has a lot of
pages filled up with zeroes doesn't tell you all that much. Or does it?

Also think about what do you do with those numbers. Any action performed
later is inherently racy. Aren't you really looking for something like
MADV_COMPACT or maybe even MADV_COMPRESS?
-- 
Michal Hocko
SUSE Labs

