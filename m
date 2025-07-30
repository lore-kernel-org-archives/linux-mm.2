Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0DD2C83F26
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 20:02:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C86B6B009A; Wed, 30 Jul 2025 16:02:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 479006B009E; Wed, 30 Jul 2025 16:02:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38F1B6B009F; Wed, 30 Jul 2025 16:02:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 29BDD6B009A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 16:02:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AFF6C1DB39A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:44 +0000 (UTC)
X-FDA: 83722003848.04.F8D208B
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf05.hostedemail.com (Postfix) with ESMTP id 2068410000A
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 20:02:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SWq+eFBN;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753905763; a=rsa-sha256;
	cv=none;
	b=AMO0wepXDLfMh1sBDPVtyb/rlTXFiyn9ts7LiqXUcNUE+wEBJJjk3EokYMAv9tGUWcXHbS
	L+gvrOsfvx5UvOWUTJkF8cHxjkW4ZaWGo2s/25q733/qfe6+pGIqESi41OPRCnjGRZQOjk
	iiu7H7/Z4IPwFqe/vWQSGemobzjqOps=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SWq+eFBN;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753905763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkJNhtBvrZk5C66WOWasVUHqk3itPHS2yJFxSHULYtc=;
	b=yS6EAWRBZCX0ev20gQSJnrG9wZcj8fWbHSRytcY5XulgVdZXxIdBJ09ajos5sm4ityxUoM
	uf+Ekp/MOCg46oMmWLke6rfA4R4JJct9PgRAKyBwSLj3Mkr7Xdh0ac9ZdvGEjxDVDqzSgm
	2LnALOFW/OauTMRtxKjxYpTyOrhGjNw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 4EC7BA554A4;
	Wed, 30 Jul 2025 20:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E44C4CEE3;
	Wed, 30 Jul 2025 20:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753905761;
	bh=dIsX0oxgpw98gKQ6TNOqvSsrt9blwqaLCC5pGxia6zg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SWq+eFBNOyR8w0I3ocYT703G24D1cY21SPPSy5rDUj1YKQuc5KYbexihbYwvICScD
	 iK55DJX7malZ+S3Btr6UZrTKkSeeF+Dio/+0nDAM9/7QbvXZ6A9lwch7U0YO9YTXTj
	 YDz5KtYSZ3XeUjOycBOMqEZRjU9JY15OWFUQzNsCtxYo7Pw2KlWcmXJwk9Urieqtut
	 EM0Jmxsrv01juDgQMMs3/6JdbgveBFXXjmELH75DWA/pAIQFA7e1XBAAVT084Y5Iof
	 zq3l/fS3g96SzmX+R8PJglg1ltZjLN/ag7h/7C925q4LKSgGx2Z7oaIPM6KAwIMCKz
	 r1RbgWIOK9kpA==
From: SeongJae Park <sj@kernel.org>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mm/damon: Add damos_stat support for vaddr
Date: Wed, 30 Jul 2025 13:02:39 -0700
Message-Id: <20250730200239.60984-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <cover.1753895066.git.pyyjason@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2068410000A
X-Stat-Signature: tisxf9ae3eaqesrfwa647rx6p8pcimn6
X-HE-Tag: 1753905762-110423
X-HE-Meta: U2FsdGVkX1/B6qp/JCiuYWXxKAuYqoL8hWYIOE+q5CsJ0C/ymmiR3VNmf54UClQ7bnYC+7GRg5OZt4T3mRNhAqzAnzAp4Dboc1mZ0p6PLyg6QaySP1cw0fJL/OKJglRcx9fpaX4RhN6KXhdHozJ8cpXxFaQL8yzPRHJuY+T2dI0uf9AITb7FG7FH4TARaAglaf/xSp0tgnVKEI4E+NUgDFGHxp7yq4su7M1U2/qjeRXQnF0koeaSIyoxnYVnLRZeJdHb4Fd4T4Q3rTRMTTmuXpxBUWupb9TXQSLkoWvAXGoySWDvvNZI8zBOneFl5m7H+o8dIt3Zq2zqo5GNbvXysC5jMmzt28fMbmbcxqvW2htDnS5yqR0x07JB1bejxhA14re36mkbSWCkXHEphyZpdFgr7CODWuuLDmYqrEK6z9FqJger912NOTuuQByq6bkSNdp+XmrM0Z/PTSQsGvOuOZiwuDaBV370alVKA0hgbIjkPQb7puBtZwKJC4Sp5lQlhCHzdaMuK/4av8ykK3PAJrqmsoMyWWPEP14Kq9Jlv4bLUwmbJXux1vt/XI6QWzR2zFtURa2AIegedU5HmMOw50ihOe1lZYWWpzr82wftEnkB7t4z9ytwVEb2fZX9tsbVAyoqhgv4GTDDyIJP/JrOX/hRT0vjl/Wld9gHdm3ROfvR0AylMA6GqjHF4Tfv1HDOTqi/ETtMFA1IoO6+xFFlUjkCL5X47xtU/jswTiYWXZam96g42ZRKXPo0iaMMMeURLBOwMno24wl5lb1CyrvCdTr5sFXT7NfpQGxteefkqnqaf+CvNXCm2vGc2UHC4Ac4/gxteNAhY+355zdHzqItOR0Ycp8wD+cLa7Pv4BVs9AEn/QNpXU8josSu3Uu5pu1kuwtlWl6JhdiDRGlvAhDIZOeBeoq67ARaNgbQE3UAV9TI4yqvYZ3zHxzd8vF7MZxfuTmNav62kfclNumTd3r
 DY/QZref
 7Izrv15ZNL4jhjzEplUa2DdlInMBvrf0B5wXSCrNOxG02hbdJs9ubDVAOorxelP6IzVJXvhuKRzUFBLtLgc8Q1TTXZtP2KcXE6UKJW8tIrpQvc08SjSylvfDkWPyQaAaAj9M3vVl+3sLpiLoMxijt5cZoyAbBpA45jxVEyWlL6ibQYw93Su7x303xqDiSsaSV3jaoxcR6Pix5+WkWSC8GZnSbdffX7qXCpbYtHjMWgE4Ed4m1exKQazYmjqzSu3dhX224CN2G99qIs+c9CUAJmVYBnTOW88VVjOOmTWzlHCTFfQM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 30 Jul 2025 10:19:54 -0700 Yueyang Pan <pyyjason@gmail.com> wrote:

> Previously damos_stat only supoort paddr. This patch set adds support 
> for damos_stat for vaddr. Also all different types of filters are 
> supported. 
> 
> Functionality Test
> ==================
> I wrote a small test program which allocates 10GB of DRAM, use 
> madvise(MADV_HUGEPAGE) to convert the base pages to 2MB huge pages
> Then my program does the following things in order:
> 1. Write sequentially to the whole 10GB region
> 2. Read the first 5GB region sequentially for 10 times
> 3. Sleep 5s
> 4. Read the second 5GB region sequentially for 10 times
> 
> With a proper damon setting, we are expected to see df-passed to be 10GB
> and hot region move around with the read
> 
> $ # Start damon record
> $sudo ./damo/damo start "./my_test/test" --monitoring_intervals 100ms\
> 1s 2s

Above command is not really doing record, so the first line would better to be
updated, say, "Start DAMON" ?

Also, it is easier to read if you give prefix spaces for quoting commands as
well, to make it consistent with their outputs.  Fo for example, above could be
something like below.

    $ # Start DAMON
    $ sudo ./damo/damo start ...

> 
> $ # damon report
> $sudo ./damo/damo report access --snapshot_damos_filter allow \
> hugepage_size 2MiB 2MiB

Again, I'd prefer having prefix spaces for above commands consistent to the
following output.

Also, maybe the first comment could be more detailed, say, "Show
DAMON-generated access pattern snapshot" ?

>     heatmap:
>     # min/max temperatures: -600,000,000, 100,001,000, column size: 137.352 MiB
>     intervals: sample 100 ms aggr 1 s (max access hz 10)
>     # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
>     df-pass:
>     # min/max temperatures: -400,000,000, 100,001,000, column size: 128.031 MiB
>     0   addr 85.373 TiB   size 745.555 MiB access 0 hz   age 6 s           df-passed 0 B
>     1   addr 127.608 TiB  size 877.664 MiB access 3.000 hz age 0 ns          df-passed 878.000 MiB
>     2   addr 127.609 TiB  size 219.418 MiB access 2.000 hz age 0 ns          df-passed 220.000 MiB
>     3   addr 127.609 TiB  size 316.613 MiB access 1.000 hz age 1 s           df-passed 316.000 MiB
[...]
>     memory bw estimate: 6.524 GiB per second  df-passed: 6.527 GiB per second
>     total size: 10.731 GiB  df-passed 10.000 GiB
>     record DAMON intervals: sample 100 ms, aggr 1 s
> 
> 
> $ # damon report again
> $sudo ./damo/damo report access --snapshot_damos_filter allow \
> hugepage_size 2MiB 2MiB

Ditto.

>     heatmap:
>     # min/max temperatures: -1,100,000,000, 2,000, column size: 137.352 MiB
>     intervals: sample 100 ms aggr 1 s (max access hz 10)
>     # damos filters (df): reject none hugepage_size [2.000 MiB, 2.000 MiB]
>     df-pass:
>     # min/max temperatures: -900,000,000, 2,000, column size: 128.031 MiB
>     0   addr 85.373 TiB   size 745.555 MiB access 0 hz   age 11 s          df-passed 0 B
>     1   addr 127.608 TiB  size 579.715 MiB access 2.000 hz age 0 ns          df-passed 580.000 MiB
>     2   addr 127.608 TiB  size 144.930 MiB access 2.000 hz age 0 ns          df-passed 146.000 MiB
>     3   addr 127.608 TiB  size 452.453 MiB access 2.000 hz age 0 ns          df-passed 452.000 MiB
[...]
>     memory bw estimate: 5.297 GiB per second  df-passed: 5.297 GiB per second
>     total size: 10.731 GiB  df-passed 10.000 GiB
>     record DAMON intervals: sample 100 ms, aggr 1 s
> 
> As you can see the total df-passed region is 10GiB and the hot region
> moves as the seq read keeps going
> 
> Revision History
> ================
> Changes from v1 [1]:
> - Follow David's advise to combine *pmd_entry() and *pte_entry() into
>   one. Also remove manually setting walk->action
> - Use vma_normal_page and vma_normal_page_pmd instead of damon_get_folio
>   to remove redundant folio_get and folio_put
> - Follow SJ's advise to only move damon_pa_scheme_has_filter to
>   ops-common
> - Change the command used in cover-letter for more natural illustration
> 
> [1] https://lore.kernel.org/all/cover.1753794408.git.pyyjason@gmail.com/
> 
> Yueyang Pan (2):
>   mm/damon: Move has filter to ops-common
>   mm/damon: Add damos_stat support for vaddr

I also left a few trivial comments to the patches.  So I find no real concerns
but asking for a few trivial cleanups.  Could you please make the changes with
next version, after waiting a day for giving others to chime in for things I
may missed?


Thanks,
SJ

[...]

