Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06571CAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 02:51:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63F448E0008; Sun, 21 Sep 2025 22:51:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F04A8E0001; Sun, 21 Sep 2025 22:51:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DEE88E0008; Sun, 21 Sep 2025 22:51:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 39CD38E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 22:51:26 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE46A58F9F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:51:25 +0000 (UTC)
X-FDA: 83915360130.05.EEAA443
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf13.hostedemail.com (Postfix) with ESMTP id 19E3D20008
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:51:23 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KI+RVJ+j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758509484; a=rsa-sha256;
	cv=none;
	b=Y6HQlLd6jSw7QifK8oIKSNmUtFglKMrxP/3S1s92SqnF2ANZYFHCgFWo+wsXqu61hCYCfO
	A/ld4OcA8dltanq16uquiOj6FUqtHOTe0jMjfLit1Ymvyz4idMK3J3OJ11CuqSOf9uLYwc
	Y/5qgIavBr6I0nQesk5DWpukQkIJNV4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KI+RVJ+j;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758509484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jH+DrKSNruoUAxCCZ6Vj2RaXFgJa9oKCTsnV5uqgSrE=;
	b=bXqU83is++oEa5saWgle/OYaEUkchNgcWVkDNFBTe0jNkA8dca9dZ1iKv6qd5qydBNdE4m
	of4WLz2/nXWoAG7hQP4rukkeesJ8004fq15Gx4XIDkrT36SkXyJCbZK3DjpMr1bj/fwEM2
	TAZDdyXycyLzPE79Y7E4jyepSanYiT4=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-25669596921so39889415ad.1
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 19:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758509483; x=1759114283; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jH+DrKSNruoUAxCCZ6Vj2RaXFgJa9oKCTsnV5uqgSrE=;
        b=KI+RVJ+jFF5cv3uPu5P4KwwewEUSGXaGbl0cwqFRZADlomoV0UYAff2RYLNeF4hk/U
         1DG+PKFSPV68wYFpcQXokHwKvqBbVGlciVixz1ROzU1vdgVsFiOX1nEFTfqNduzIgs07
         xjfILZ8MP+6kpFfwkDsHFKcfM55480J1MmpQ0hLIJdN8en6lHuMzke2CYCeI3cQMH9Ms
         ZFackn49K3ZwWDs/34Gp62kxn7lNzBGMFG/Fc/NCh8b7vOGWYxvoCvWCLyTQhRdSjRrA
         o7ZnLyV40duvA1r5//NmlDxBEQPnuU/+w2ZzTvEdpi+sEUiatFTpCj9k3DztYAnD9W7v
         3mdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758509483; x=1759114283;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jH+DrKSNruoUAxCCZ6Vj2RaXFgJa9oKCTsnV5uqgSrE=;
        b=qw/l3lFpzffH6E94PPbm34lfAoO05jVQB8fvkOvzpI7NvfsYhnWiSjU6DJLVz20dLt
         4u2zav0zu9d4SV0uVYmRrrSg21Sj9eFiU6yrpaUCoyyF7nb0bjCF9qKuv65Jkkje+8uW
         csGi/80Na3EYwwVgtyeC7MF/zdug/GOl7odvKq7sT0jbGkiOZ/+5ON6JpzFs1mStBLH3
         Ymh07liEeXRsAKXhHA1bKXvYzozTeaWQQCcXPcAxvV6TluQp/BiO4dvOK1W7FTPEt+rd
         BKO1n5gmoJurKSkDePA2THiUuNT9jvN68DP2QeC65nVL/XIS7SoSQeNivkXgSuAhAatz
         ylMA==
X-Forwarded-Encrypted: i=1; AJvYcCWZYHtaveIP40M6dWAM1etMZXMsvr60Q7UpWV5LkvwkuCDxPkfcoPWkwf0VsulzA/mlYV6QhNlK2g==@kvack.org
X-Gm-Message-State: AOJu0Yzj+M2C6vlF6nZ8R6sfHu2y81+DcnA/nYBfxZRzHretvqa5GEe1
	cyzosv5ZJidPiiz0g+3Ep61dPjLhg5IHyG1zu5IkGDPyQSjafHBqi/Qo
X-Gm-Gg: ASbGnctaNg5bZIm/Gbois6vATJYWxDQSrbQ/KX0ybTl4eMbHkwQQXVr++4jas87ChJn
	Wc8PVTap5oc2ZFT8xgktyiIsL8I1bVeB21BxSYNl67xWiKrctgdzR0aPDGP3TxjG5l7Zs8bkxDT
	W00Y6FYM5hxTRsaf3ODAo1GBW131knuUHsdVwq9HWch9i/MPrZMwJQRHDRaAuloM2SLcxNkTLLk
	uz6ubr3KABAwOa0cSnFC/u+kmW8XFNwTA3M+Hn/171lqNuRsIEq2A0MJRAhnPLkT5QaUvv+PFaj
	fkVHlKlu0OfIVMWtXC6kT2mCaRstFRs89EV+su6kuFm0G2ab0tmNiqquKQyFg4Rs+UUItt+16On
	DVhy7NejPvTC/BgF05lGHXZ4BGqe/zJS+tcs=
X-Google-Smtp-Source: AGHT+IEwa3F5+Aw9ZdMexHvGOoSY1jJqiIO6Tj+RjacyuxTVxr4cEf2DJqUfKe3twh04nT5Dkwk0bg==
X-Received: by 2002:a17:903:3846:b0:267:c984:8d9f with SMTP id d9443c01a7336-269ba45919fmr171335405ad.24.1758509482553;
        Sun, 21 Sep 2025 19:51:22 -0700 (PDT)
Received: from localhost.localdomain ([117.86.193.224])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-269800529cdsm116978635ad.22.2025.09.21.19.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Sep 2025 19:51:22 -0700 (PDT)
Date: Mon, 22 Sep 2025 10:51:10 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: hughd@google.com, akpm@linux-foundation.org, da.gomez@samsung.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
Message-ID: <kh5nq3ycj5neufhmiqetl5vtosictiflk73xyb2fdl2p4txmu3@4ndr7cw4b2j6>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
 <c245dbb5-2e2b-4308-a296-f711b74002eb@linux.alibaba.com>
 <3349E5A6-BCDC-47B9-956B-CB0D0BC02D84@gmail.com>
 <fd0664f4-2ee7-420c-a63c-b4b1c923e1c2@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd0664f4-2ee7-420c-a63c-b4b1c923e1c2@linux.alibaba.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 19E3D20008
X-Stat-Signature: 3j43oddazdtsgc8sjhcyf8ahxdjftih4
X-Rspam-User: 
X-HE-Tag: 1758509483-721926
X-HE-Meta: U2FsdGVkX19lyYUjPe2Biqgg91a1TqupRRJ/gsjIGl3xVu0uH7RIrpH+gijqk3GILVGWTUArfsdtG5UXjytBtGtf2yWTVBKfTgSZQ7J0smDdkgNhcJWNlhNT3v14Tu7KR2OaDjlfhCqrIPAgIU87beNac6D5ihvaxJ/jJEJVQI7UKQskHcKFHJLnA6cu0lVx/DWMYA2cTprPgnTTRYQFruCdf80FH3VrnlSwwrHx3j1u8UWUXnl7cXmSH+EpY6OAqlSWz7FlGCGykBhr2yv+v7lkOOqCbpIHaScSWkrZF9vg55+5U4nb6fTcwQXvXVnI1t9nbgX90Psl2l3cLpVdN2ms/WRpC7Z+Shf6M+XVzpcDOLeQJLusiUotYTeNuauawzZq1Kz3WLSO/B+PezZAomJb0FcfEVEqJQb1oJYbBHFk2ekktg3fd4RaukYNOELL+mYLUnwKpWWdGJFGZBVjBDLlAGbsv+i3oLGhjVZnqDlN/wOXUZm6DXJkU1WaLGAU2CKWDJHhR362E0/2XjYKkIxnH6ZfT1N40h3aOEzeCeGnGlFnkApiuslui9U7bUkDkPQc9GwrJpmXj+zDCUPXkN8AqA3UJxx1O6Zgp/nMt9ZkArPV21eRHaTUhKVskeRRUjM83gPbrm1Os5+5k01Qc6Ur2KZ0LsoBAxP4RaH7mngrcXAIk6oTv0rPk0LSKcQ96/de/zt+mnbERj8K/t6TjQ+3SUMcn3dN4XKgHA0663WKnAMCpShfJvojF0hfSt6CYvaRz+7JDRUvieM3QUtv5fofsgXohyfHkuNqIztF5Q2WLSO2FfYsocwhkA78dpvZrkgVIAYhzajpb1xMj1LOkt1y8qlKZxCeFyedqTuopPE9GHC8eznDTdhGYBOqwJKSA9s6iruvtMYb7enRquWML+7LbyQ/5XPN8Mtox2uQUjQl8D7Y+w+6Cqrdo+v2rW996uUCm6yTmreGXw6KpP3
 GbapcO+n
 B58UJLP2ybC9/BxRWYRy9uTPjXhxcz4i/ANUb967kkk6HddUAfq8mu6JlQw6gPwiEJCum+f5mr9ztvDWtSwgGi5ATlf0wmIIWGwQzS2TJSWFEh3i57Aem/6yAdYPG8Q4BxY9F8Ni+2IQ55eb7YWKHcA6pY57EOtqxR6yDm3UntlLYE8c3tHBrRmNjW4A7Eni1mIoeWoFbu3UP48GyyFdcL/yc+5xfr7vn4oOAFb6uDWRGeKTW3fK/nb5HcRPBKj0ghPHHN4GJ1fEorE0fyjS8AYVm5skNZQkg69O6AwDz+P8vshvn/l+KjQeidPKO+hELDV6qTY2ksCsY3sMwXTz2O53BN76J+F8GpRI1HwY2HU5/iXdSiLp+f1j8OBjl9sZsLUN8yBn03y2wSOGZE3YZuOrBJCmCcKIn0iSowZNk+XGXp9r4S/DgvdZ1PSd/JO2LcTVlJGsNze97EdNu84yYH5ymkRzlNUCa3fXnNVF1V2fgWlDoBpmhtD1Ej1quQEjlJEcjfgdwIPGLUhPsgSxMKixlyeaGMcfzEEVx9FA0uUGfvjg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 22, 2025 at 09:46:53AM +0800, Baolin Wang wrote:
>
>
> On 2025/9/9 20:29, Vernon Yang wrote:
> >
> >
> > > On Sep 9, 2025, at 13:58, Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> > >
> > >
> > >
> > > On 2025/9/8 20:31, Vernon Yang wrote:
> > > > From: Vernon Yang <yanglincheng@kylinos.cn>
> > > > When the system memory is sufficient, allocating memory is always
> > > > successful, but when tmpfs size is low (e.g. 1MB), it falls back
> > > > directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
> > > > will not be tried.
> > > > Therefore add check whether the remaining space of tmpfs is sufficient
> > > > for allocation. If there is too little space left, try smaller large
> > > > folio.
> > >
> > > I don't think so.
> > >
> > > For a tmpfs mount with 'huge=within_size' and 'size=1M', if you try to write 1M data, it will allocate an order 8 large folio and will not fallback to order 0.
> > >
> > > For a tmpfs mount with 'huge=always' and 'size=1M', if you try to write 1M data, it will not completely fallback to order 0 either, instead, it will still allocate some order 1 to order 7 large folios.
> > >
> > > I'm not sure if this is your actual user scenario. If your files are small and you are concerned about not getting large folio allocations, I recommend using the 'huge=within_size' mount option.
> > >
> >
> > No, this is not my user scenario.
> >
> > Based on your previous patch [1], this scenario can be easily reproduced as
> > follows.
> >
> > $ mount -t tmpfs -o size=1024K,huge=always tmpfs /xxx/test
> > $ echo hello > /xxx/test/README
> > $ df -h
> > tmpfs            1.0M  4.0K 1020K   1% /xxx/test
> >
> > The code logic is as follows:
> >
> > shmem_get_folio_gfp()
> >      orders = shmem_allowable_huge_orders()
> >      shmem_alloc_and_add_folio(orders) return -ENOSPC;
> >          shmem_alloc_folio() alloc 2MB
> >          shmem_inode_acct_blocks()
> >              percpu_counter_limited_add() goto unacct;
> >          filemap_remove_folio()
> >      shmem_alloc_and_add_folio(order = 0)
> >
> >
> > As long as the tmpfs remaining space is too little and the system can allocate
> > memory 2MB, the above path will be triggered.
>
> In your scenario, wouldn't allocating 4K be more reasonable? Using a 1M
> large folio would waste memory. Moreover, if you want to use a large folio,
> I think you could increase the 'size' mount option. To me, this doesn't seem
> like a real-world usage scenario, instead it looks more like a contrived
> test case for a specific situation.

The previous example is just an easy demo to reproduce, and if someone
uses this example in the real world, of course the best method is to
increase the 'size'.

But the scenario I want to express here is that when the tmpfs space is
*consumed* to less than 2MB, only 4KB will be allocated, you can imagine
that when a tmpfs is constantly consumed, but someone is reclaiming or
freeing memory, causing often tmpfs space to remain in the range of
[0~2MB), then tmpfs will always only allocate 4KB.

> Sorry, this still doesn't convince me.

