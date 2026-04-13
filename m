Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2229E93807
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 00:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C0CB6B0089; Sun, 12 Apr 2026 20:29:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 271D36B008A; Sun, 12 Apr 2026 20:29:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 160456B0092; Sun, 12 Apr 2026 20:29:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 092036B0089
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 20:29:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FD3B5CBFC
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:29:51 +0000 (UTC)
X-FDA: 84651649782.01.AE97EE7
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	by imf24.hostedemail.com (Postfix) with ESMTP id 88507180005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:29:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RQusuEJn;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776040189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+QXCRNJsvBJXHEfK6416uGa9fOl7qqDApTOq7sS6hE=;
	b=dJsGXArVy1iHR1ykrYUdRcuTjVO35Xwn5S7iLHGvGRbM+uTrhcW7IRfBBhFfhbVJqAkqgj
	JRXXFuU3NDRhq2x9S2rMXPPcjc8T2kUoIY72mSFUBjli4RhevK7KW+1Q7NHLAKd3kAoATz
	WYbBrzo9OvWl4ab+MbtglvszFI/y2xU=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RQusuEJn;
	spf=pass (imf24.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.50 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776040189; a=rsa-sha256;
	cv=pass;
	b=FwNMZNsnKK6aN+fVg5mqmh31L18sPL6HUaAXyugxjCAyqjfhvWb6O+ByuXRLiAUJQKMhoZ
	mkMAuVSCgOuF3U0fcYcwSISzsyZs0zFDgzc7U4WAiYzltDLi8QYU7I+6tnLRNPhX9x+vhF
	/QXP6kE8pucqZT1xjgh/fc+8d7uUN6g=
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-43d7605ec91so544693f8f.3
        for <linux-mm@kvack.org>; Sun, 12 Apr 2026 17:29:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776040188; cv=none;
        d=google.com; s=arc-20240605;
        b=dbyIxaIJc25H2apy40OtpMc81xgPA0nu1TVsfmtTLlVibMRzwbj3uyk/WX3+gN1sOn
         RU0QPECSD+Z0HtKYsKe8M0h3my3sA2sT/RqbvCQbKEaTiDDVH4K3IRlb7eBzj8DVhKGa
         XWBKQX/CUXYoz/wkEwSzxGUuVMzcwou1gzgiGPb+5CpsA0WSPEwjmOhE8qA2pDSv8uvs
         frctUckruTjnIVwRlZ0yoLLKcrkaslYHQ/riQBPEr7+KDtu9oN6Me0a3ETeYhWN8JIvu
         NuNOSKzkp7LUEru+7z2tfRG/TaLebhMKcuz5tkJZXOQjwEPdfdUhsz3V9/zbFLWC4v16
         1G8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p+QXCRNJsvBJXHEfK6416uGa9fOl7qqDApTOq7sS6hE=;
        fh=MzGYqjXv6SUgrnuXqDKTTmdhH5r3+Pg0dfQwCdVtIuE=;
        b=AMabcSvH/NL1xz4QF3nTgvH3F0U0V+K7yHWdciw02RMo/+YNRont/JQh62Zw4OlvZg
         Ufcxc1K4FbF8PyrYG8JozyapPcSuIxsyudojKmnkoJt8h0MQcdUZXES/JeDHXMOMXdD/
         8B4wMv8GyjfkWQQQY+sLNBqm1HvweLp3UCrexnz6Ym/p4NkrDZ6uHt3u5FUFhcy0hXGR
         ynbGf0Nsy22SVhOQW01RdqmUDdDtHkNcdux0Tg4mcmBPStsTIOU5srVKJuig+FF9mrEF
         G2B6A50YQd8CMEul0+xmAKeDtTGXztz3Sj3zm6879TAWTYnfE+hXZcbmtgfWjSG14oad
         G/MQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776040188; x=1776644988; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p+QXCRNJsvBJXHEfK6416uGa9fOl7qqDApTOq7sS6hE=;
        b=RQusuEJnuuLhrofvgiUZRLYTdYVtOx/s9shIU88YewvJCT/FGUNHsbkAiqmeL8DB+F
         3EC29c0SHz5UJLeizhF3DzWZvl6nRK2x5JpN8g95tKY8oKWNVoaefBzFlk4HyWY6Xxgf
         rQI0cHd220wxc8jlU/TB1IZpviORJ4hHR5lZvsum1bVgjoz2jwxLv6A+RxQV3ogo8bbE
         2UKbQfbEV/C/X9BrpY3g6G9Iz/OdSaHdKzcGrrJbo0rtOt0Yj1QKv01RnT2A4f+51Thq
         603Ixnoft6dWz7H6lzUmvyCSnnput9IiaoYJuNMsnvOEEXw104fi7R/fdbftEIeD2VaM
         5ZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776040188; x=1776644988;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=p+QXCRNJsvBJXHEfK6416uGa9fOl7qqDApTOq7sS6hE=;
        b=Oy+P1PTrCGcSUma2hjbznlr5Q/Hqs9pi7B5WMCHTOdsErQbgF8LxwtLdkeQeSXOAlC
         QFEmwdBdQ3aH0tpvW5WdFaJkb4emOJzRm58niDRvcrbGP34UEteePZzEqqclAlJltA0t
         5Y4RqiNhxZVuU8bR36zjYz8yjxB9roZXiSyKX8v+t15a/1QIowgOfK29926QVxu8wEwF
         VuNoV1HuyL2wZqf5Elw3ZrENZKrtrBJ85nCnjaH4BG53d2uMaLAsxzYsgA5s0Icy/Jj/
         WeTYM4Wq2yxekMPdoybefv0bLftxC57rz4CSNOg27B2EsBnZZTJUQ7vJmPRPDuidROGM
         sPGQ==
X-Forwarded-Encrypted: i=1; AFNElJ8JQkwXnt0OfTLOfxdo0BSv9DiSrdWODsMqcZYPwcAMRGZzNkMVEECdaGO0or7wpXqp7ol/DU8xOA==@kvack.org
X-Gm-Message-State: AOJu0Yz+ukSGHUqAdmjMJi0wnxcpR571yxDUdVfPeIisvzPJVNsIj8X0
	KNetdiYPpPLG8WXKb/UwxvzkTQuSZo2Lo2bpb653rCGDSTmeyAnhw7+psRrrRNu39GMUms0z9h2
	9sT/YnZl0vQy7+TfKbR5KVxaNwPiTZZ8=
X-Gm-Gg: AeBDieuSsvqI2tjvK7wYdKl6KIquP9PHPYedgkHJyrGK9dISTG6idK1rLuCYyetJTWT
	afROM0D6/qKWEh8q+uSGYhA66jsUeAXQ1jby/M3YcHk9JYw9Z5jh+bltt96UgpgXlcvI6+quSwo
	n0BKtYO52px+1ZPQMYtjXTl1TMagXORBbcJVego0SwlKsFFF/jpBSK18X1Dgntf0MipX37Haqno
	37y7hlmp9sQSng3tn/fj9YHqze2CJeF0rC4s2EM46zbOMXoK8qLof0FNjdnfWrrFJyknEgthnJO
	xwB5oTr+gXalk6TeMgl933mwMd92dleXIwTFUQ==
X-Received: by 2002:a05:6000:184d:b0:43d:7b23:bc99 with SMTP id
 ffacd0b85a97d-43d7b23bdd2mr577667f8f.15.1776040187608; Sun, 12 Apr 2026
 17:29:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260402063714.55124-1-liwang@redhat.com> <20260402063714.55124-7-liwang@redhat.com>
In-Reply-To: <20260402063714.55124-7-liwang@redhat.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Sun, 12 Apr 2026 17:29:35 -0700
X-Gm-Features: AQROBzDA_W2wnhZr93RNMhtdQJumotHsjmSnSZPteOoUEt7sHLGd9BTXQt8gj-w
Message-ID: <CAKEwX=M150Hw0Ncs69SCWRr7J+vK5F0biotkz=MSFvFG3rgjow@mail.gmail.com>
Subject: Re: [PATCH v6 6/8] selftest/cgroup: fix zswap test_no_invasive_cgroup_shrink
 on large pagesize system
To: Li Wang <liwang@redhat.com>
Cc: akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org, 
	hannes@cmpxchg.org, yosry@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, 
	mhocko@suse.com, shuah@kernel.org, chengming.zhou@linux.dev, 
	longman@redhat.com, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 88507180005
X-Stat-Signature: 9yzhbeqsnxiw6ggs5x83mj91j4z7psgt
X-Rspam-User: 
X-HE-Tag: 1776040189-178771
X-HE-Meta: U2FsdGVkX19Uc+8qVxQmU+sGrZ2GDHzsNENcV5VruLt5csphrz/WT+bjnTexigaesmovbgUuFRar7YIniIEpgwVz6lDL2KWheUwcDWoZ4zVGb8GrgoDgbNiG2QclmzlMsfRtf5/LgiQODSsME4bB51yOA1VmvkaCPV17QA0kaZX47Idu84rbi18DUs8/YbuVVjHQUhOLTv7Ns4HH0gdU9hqHCeBZD3MEGKcM1JYQ/f45sfQWRWMcRKUSjCxzMB+ulYJpGMQBPtPGiGduaxzQS2XEJ70MvAbNrwhVLPu2WeA3FDDsOMXubliXzk1OWwfhiMp93Ard4XxCnoljK5YiZzI4wXVKn99DRAHoOV/VO86Cc0L9XTHuzURzh9XCCcSoQq0+vYvM+7FmegQmNhmZIMvbhCu8RYrSV8gLXYlLypDUOUFJI2uWZN4eJ0zllktDHXOIEleQKNTyJEo0uMOTp5XQZlZbSWRm/FAAxrYA1eI8EbeLOYAt51dipZDrPrPzr2m7dg3gHK8jkVtKTMgf0TtgJ2cGUG2WzWcBw15vJL3SyWI4z19pSMwrSAXo1xNOy51kZQm8civC089bxWkPdRQrCaGfQu7tsQJbdh61wH2Hpi17sqEDDt363Ut4Sgbut7gQW4Xr9Ho9Or1om5DbIJhk5LBByk2vaWlidjlmhWwgFNe+wWGyYkThWwLidI1ex5zARqicFe86XVcZUwaNvlfckM+RMpzFjkaAjecDTFlpLhiczFygYJP+TJnTIRpC8gm9YWMXFf2B5cDFYDGn7nwm/ui6NgJgnmOWbdV1brW6z98Op3rWCsxOT//qsth7pGyycVGudOijD11HaPyvgIi3GM4OqVTM63DvzUQFxzLWVeBaFCRiqQtzu/VmiB0xycvymCODyLvoHruLWgA0ucqjwuXX2pUL5B4XU/ZbL3OFEUOAMzSb+wjnsgYLTbwZbO6YgI+YossXFuijaqO
 BYBkXHjB
 WAgSJjK4ZzeASRyss0hmXN7AOFJtrOMJu0JGyR8mm4YS8v60T8e/l6NGKoc6eS/queB5DT9YUPF1W6u3fQFOd3HGtGvulxWsvAzb6yyNcxXfaKJDaiVBX7EjK7vLfMNa1S2dOCJMHDq658hOA32fE0JKEtB2zhPCNyIT++hUZShbvMNvl+GHEOmxGvjXOtr8IrbcUeXRTYkKSQclp26wEDJwhawxxZk9f0gxauLEXTzB0k6wdSKD7Omd7Sl5+peIpj8BQ3p73ayow5WhiTmicwjrc7J+XvKo0WEjipgXyEeyFP0r26Y/vvMz1I4VrIjlS5Ys6LeW8Y4RjOI5OKqZHMW61KiF+LRH2pJk14u9z3Q0UZ0/NKboJ0NeCbu5op+9vOmrHbDaHlf69bO0SbY9Ieo3JspOuiWutSsocDv4ibN12rtTsQtIPqiASYcmrsMzbyPUmayArmpj2BuHlaczVdgtbmXswrwU0KTn5xH9cnnR+EqaBbnJFJYBF2KM1I/L2PUZmewpG1t7Hg4GS6Rvp/OdlDbIv4DJKn8nLVTn2E+pEvdqdWFHNxCGFgqLtS0IajmKXaF5dpIn+gobatTKmKVD99vN80LF6D1wHUkVMDx3AMCd48YuzwRGN667SlmcUNNuW7WFre76rpEyJcP51AqOS+PJYajVGurYZQLbR4Ax7Zx6oR6o3ilyFtrDQR1UlGp/KupkFehLB+naTHBcHxrXkpS6AsMLij9dpXaKDXChSX4MtFWJbTI73UA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 1, 2026 at 11:38=E2=80=AFPM Li Wang <liwang@redhat.com> wrote:
>
> test_no_invasive_cgroup_shrink sets up two cgroups: wb_group, which is
> expected to trigger zswap writeback, and a control group (renamed to
> zw_group), which should only have pages sitting in zswap without any
> writeback.
>
> There are two problems with the current test:
>
> 1) The data patterns are reversed. wb_group uses allocate_bytes(), which
>    writes only a single byte per page =E2=80=94 trivially compressible,
>    especially by zstd =E2=80=94 so compressed pages fit within zswap.max =
and
>    writeback is never triggered. Meanwhile, the control group uses
>    getrandom() to produce hard-to-compress data, but it is the group
>    that does *not* need writeback.
>
> 2) The test uses fixed sizes (10K zswap.max, 10MB allocation) that are
>    too small on systems with large PAGE_SIZE (e.g. 64K), failing to
>    build enough memory pressure to trigger writeback reliably.
>
> Fix both issues by:
>   - Swapping the data patterns: fill wb_group pages with partially
>     random data (getrandom for page_size/4 bytes) to resist compression
>     and trigger writeback, and fill zw_group pages with simple repeated
>     data to stay compressed in zswap.
>   - Making all size parameters PAGE_SIZE-aware: set allocation size to
>     PAGE_SIZE * 1024, memory.zswap.max to PAGE_SIZE, and memory.max to
>     allocation_size / 2 for both cgroups.
>   - Allocating memory inline instead of via cg_run() so the pages
>     remain resident throughout the test.
>
> =3D=3D=3D Error Log =3D=3D=3D
>  # getconf PAGESIZE
>  65536
>
>  # ./test_zswap
>  TAP version 13
>  ...
>  ok 5 test_zswap_writeback_disabled
>  ok 6 # SKIP test_no_kmem_bypass
>  not ok 7 test_no_invasive_cgroup_shrink

I assume the test passed after fix? ;)

>
> Signed-off-by: Li Wang <liwang@redhat.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Michal Koutn=C3=BD <mkoutny@suse.com>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Nhat Pham <nphamcs@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: Yosry Ahmed <yosryahmed@google.com>
> ---
>
> Notes:
>     v5:
>         - Swap data patterns: use getrandom() for wb_group and simple
>           memset for zw_group to fix the reversed allocation logic.
>         - Rename control_group to zw_group for clarity.
>         - Allocate memory inline instead of via cg_run() so pages remain
>           resident throughout the test.
>
>  tools/testing/selftests/cgroup/test_zswap.c | 70 ++++++++++++++-------
>  1 file changed, 49 insertions(+), 21 deletions(-)

LGTM. Thanks for fixing the tests :)

Acked-by: Nhat Pham <nphamcs@gmail.com>

