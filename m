Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1139CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 07:39:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4092B8E001B; Tue, 19 Aug 2025 03:39:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E2308E0002; Tue, 19 Aug 2025 03:39:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7AB8E001B; Tue, 19 Aug 2025 03:39:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 187F78E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:39:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A38731602D0
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:39:46 +0000 (UTC)
X-FDA: 83792707572.14.44253D9
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7F32180003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:39:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M7TFl/JU";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755589184;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JlGG0MimgPVuD1cdmYrztEX7ylcMD0YKZDmGx1Z6TgU=;
	b=DDyRV9/05J85QzV/Hbt4O8PfvwSMxWl0rZpPdrlirP6G2RCK0xJC1CTxmyw3gEKrZpSY/H
	qMtSOC5ndJINHYxIMfrKNG9GGRiQEsFVDVVqDlDnGogIMvpq6mUFXda1cNo3PMvbwBThup
	ukKOUH1UOtKhaOOLU2a2Ohy1AZK9QTc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="M7TFl/JU";
	spf=pass (imf24.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755589184; a=rsa-sha256;
	cv=none;
	b=FRWZIdmfTEFwt5DdIDbCjpYKgVqejOwvsfXheKAz2+YXwjkHmESJDeVM6GMHR/agaFfhF8
	SaHeWU8BCmELgdNyrG5bBUftPvMKwgXko3UNn27siNJHRh6bRds/noQoPuqrP4mWC8F+jx
	HjpLpNYy5G02QMxt3KezDx6gdzM8xG4=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb79f659aso749020666b.2
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:39:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755589183; x=1756193983; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JlGG0MimgPVuD1cdmYrztEX7ylcMD0YKZDmGx1Z6TgU=;
        b=M7TFl/JU4TzisiGNHTp+VE2lGkz/2IQHxNDx8zR/Ey5eYrjm+eSciMpHjbK+Yw6Hd3
         t8aYuPcnCi7x60Pxw7W03YZ6YLl+lPdsuHHqRmHZeoguojIm5l3jdSB2/SvzAJ2Rtt2T
         kB8PUVJlYGzlarIZJX38EHJ9b7SAm7b01fpxlIK9B66bEnHUcIOAqgGGpyx5e95u6lLz
         qgFWntz5W5kbuB+Jgfd17JB86Zeb7zunudL1Mm2tWPk2ZJ0BQWlcVKp/Q8sepMZezxqe
         P6FME/6SZDT5ZgELJ/JyQIvj/eoOaxYqBaUmIW2x/hfrdx+yTUdi5a+vifX7heAg7/C8
         VD1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755589183; x=1756193983;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JlGG0MimgPVuD1cdmYrztEX7ylcMD0YKZDmGx1Z6TgU=;
        b=lAg+XdG9OAwD+zfb3g2FYGy9w1T89xsvHAvHWuvusrtIYSe42tzTFu8qENOd8waJNT
         rHXqepb1WQJEDLxB2mTONecRmMmWGEpBYxqH5eelLkE95ahWa8RNEvWLKf+vmwNXqbMI
         Dnzx1a7bxm0DvKvDhsTP6uzhvUuJ4eXOBk5hZeB2YfNNR4bwMnKid0Z2tw5vdounDxGy
         cnZ44jKIgtwKhgVW8VO1N0AgQE1O1qiptDwOmuJz4epU1G/KBetxPjY19QnPjYpdZiow
         BFezdViIAyF1bNQzrJKiUlNd+cINu2UOoNnZigDXztOKQ78ikI87TSZs06VX3MC9voHr
         wmeA==
X-Gm-Message-State: AOJu0YzkdRikcmj3/VWGDCciToBv0nKJ4nyP3+vqV6C7JG6cPObZTeZQ
	xvgq+EiD9nsCFHwvdJDweA/zrE/RA6h5KpuG6eB5f4gPy+oqBjhJ/wAk
X-Gm-Gg: ASbGnct9DseuaE7PvYeENorFHrH1n4uok6PEV30vnGaEV9KaVpWUYPboDP8LUwNMO7Z
	MCurcrYF4o1SvRGgnUQUgj1ImsKAT75QnCmKn91BQXvchXzWY7UWlHBFmtMD8/z3efdmy+WnPj0
	LyIHsbkzznkLWjE1lFIwNsGJqBPVH6vxITdncnPEH70lAQpswpuYLuAQH3eBDg+BUN6sLwQfQtL
	XjaZLOgebLNwPrkP6N0aP5f98gPmik3h6TLlOJBIino2l/UURNgOingohardOBhoh2SGQQtyuu6
	01H5EYPdqDldosZ00sg6vGX8STsbGZ1BmrMp+uh4t+IVr5b5DXTsTFqRz6XEXn7vS+ml9bKXuL+
	/MiyBGlQIOrw4byOfRqMC1A==
X-Google-Smtp-Source: AGHT+IFDydZFQrkosnxXfosEK8EVZgkb6qLnlT4kiVd7o1+cVB/7rTEUO0G9UdoGYY9iwV3LjvIXOQ==
X-Received: by 2002:a17:907:3e1d:b0:afc:bcfc:b3b7 with SMTP id a640c23a62f3a-afddd0d283amr142302066b.38.1755589182644;
        Tue, 19 Aug 2025 00:39:42 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afcdce53f2bsm973006866b.4.2025.08.19.00.39.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 Aug 2025 00:39:42 -0700 (PDT)
Date: Tue, 19 Aug 2025 07:39:41 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 0/4] mm/mm_init: simplify deferred init of struct pages
Message-ID: <20250819073941.esl7z5ibqqeabunh@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250818064615.505641-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250818064615.505641-1-rppt@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A7F32180003
X-Stat-Signature: ziwe7iaepc6xytrmohtryd6wp1istfjb
X-Rspam-User: 
X-HE-Tag: 1755589184-960349
X-HE-Meta: U2FsdGVkX18vO5TZk/acg4UZSqrjIib7/2hL81sIeY0Ld0OtilOoD/M8WBbfBZikDIMJ/siXnJpAaczK4ZQs2Y91g2Jhm980/YZc71UuKo0AFXLN8HOLw1XBY3bhWWE2dZXK/r349NRsqjfGtMjIHOs35k+G4GvIt+gKJySZrImooi52cr5noujBhVkYWsjRdnoNVjD7cg1ijL8WAjOk+bgH1AhU3IwjqovS/+2wQddfJXZzDnsxl3O3WR0iBFqMMtn5rbdn9myoqjPJVvDVQHIHhnb1TxHCd/YjvOwanh/tnHWrjcFfseZTIpvPjqVynN6+lSeegUIaghLEKIenu98qA67GzAJpGY3UB6FshEJ0+X6zvdqlox9VwIPWS5M7GbUP271Iej9hJ7CEhijSiBeeGrvyMBNjMLmC6B8ItroOppg0dezysQ4gYvaKwLKtHi3UEFNNpEBfImNxYdIyL+R7YLQETLE57GZLfnmChEkKSCp7izuUWeKYZJFsa+T/gGgdi8Bu+6urH0DWsbAScj+d+KFmymNy0XOKlpWZYk6dFS2/tuGnAeu7WCWp61loTkHxvw5EZGU/xVdYSpx8jVu2bvNAjuJd6vHHE0ot7PanBT+OxWkY5GlmfYMXWkGmB6q58LH1dbUpIdzwKz/b8TuNf+LP74G5cSNh1zmiQPXNRxVZmTy1zoNunqYYFtSUSpD64vbfRu+6vD7YdMbQFv6n/j6pFaWOMDmQiy/l2qZMBhJ5+qRCnWNghvdwheFQnnDEjbOf6QG9bst1BKnAdhRHpgi50CEEmcq7S8EXmhbqil8WStdTbmF1G37h2ujGv3Icm07ow+JGw7RpQ/W+kSXapP7K/5I6td9ysg6OTCxugSCZaeKFOirdT6Enm5NlojeoN3x6xQO/fnOYG2Ld3GVo5ClUW8blr1kT3IDweQGfM8euLCaFMAd1wiiUwi9KCqGMVNcx+FBr/B+vc30
 ViLAv1Dh
 GgMazoqKmq68DI04951237K9s6AIpZKiE6mvjV1ybjwBjaxA8+24GNKGHRHGwRfOvBgR7aF5dxcth4qshv32y5/LOPQrL2oKmmREZHsLaw/oupIGC2KDc9FnU+SKKoTK4wh1xRjX86mt/OvfOFkIEXRaR4inqi+zy0vzi7pg2wHcObC+vGI/4GqYZLSYxVSwPECeTZN8LPR5oSo+E5fa50XnqWS89nlYt56hiH7CuanRQIqGsC8ApIPK6quqC7zs//K7BCUEihlM2EFMmbK9tRrazTb0kO1dBKqPbGR6gfyuBRZ88qIasqZbHcD/5uIPRy5FP9Gudoc60I4qD/08D16Od70l4URSZIKI+rWHgTtYswovkYZ5Ay/vNmHTw2wnXoSVv+5SAYf//SRYoLY2Q5UQmNhuQ3DTMEfo4xFjkzrT7B1i8XRMkfq57wDLK6GQoQWzhnwvmlRgHIOEHBt+SoBLAfRHKbM50VHQ1Da0dDyB2QdK+yw4WCpKmMSnwXzCtpVCu4QToxvxXb6o/jL759ZkfvWHlZPpTe/1cOCkN+Z4ROeL8jb2vjvg0/FbROUmuAkMot99rdaym0eY1AaaRsEjjJjqFsi9iYECyQ2E7VKWFuiPD/aTBhcVTxudppZCWxKk5euai7XsvEVygM98g+SHLtaR5qQFs8kms+6azcZCgPwzV68nVsKxmoqrnjF7oa2H007K1xIFrdvvoYha8N4ad78MOTr4WjRNCvQEah9QI1nhuIU+Vhz9mN+XwMJrkc+cfxy+0YbErx+7sM9BPCLJ0VHMwgP23K3uCYGmgl/XQP7lQ2FWYbluGhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 09:46:11AM +0300, Mike Rapoport wrote:
>From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
>Hi,
>
>These patches simplify deferred initialization of the memory map.
>
>Beside nice negative diffstat I measured 3ms reduction in the
>initialization of deferred pages on single node system with 64GiB of RAM.

Nice cleanup.

For this series:

Reviewed-by: Wei Yang <richard.weiyang@gmail.com>

I guess the speed up is from "use a job per zone". So we do initialization per
zone instead of per memblock range in the zone, right?

>
>I don't have access to large memory machines, so I'd really appreciate
>testing of these patches on them to make sure there's no regression there.
>
>The patches are also available at git:
>https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=deferred-memmap-init/v1
>
>Mike Rapoport (Microsoft) (4):
>  mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
>  mm/mm_init: deferred_init_memmap: use a job per zone
>  mm/mm_init: drop deferred_init_maxorder()
>  memblock: drop for_each_free_mem_pfn_range_in_zone_from()
>
> .clang-format            |   1 -
> include/linux/memblock.h |  22 -----
> mm/memblock.c            |  64 -------------
> mm/mm_init.c             | 195 +++++++++++++--------------------------
> 4 files changed, 62 insertions(+), 220 deletions(-)
>
>
>base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
>-- 
>2.50.1
>

-- 
Wei Yang
Help you, Help me

