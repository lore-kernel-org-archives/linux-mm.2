Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09FD3C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C997B6B009D; Mon, 28 Sep 2026 07:02:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70DA6B009E; Mon, 28 Sep 2026 07:02:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B604D6B009F; Mon, 28 Sep 2026 07:02:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 934EE6B009D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:02:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1815D1401A0
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:02:01 +0000 (UTC)
X-FDA: 85262881242.29.FD7AA9F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F7FA180015
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:01:58 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ndx/x6nw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZkSQyWzu7T/0A3a31XNu8vpxdHKsJ4rnNLYcnd0bezA=;
	b=LnkouH82iDRbAFAk/BZ2JwwUkjrQwQxxiCuKvh208aQ12ZdSK2OY/xhS3CrKR1ZwK29oU1
	YHzU1RCj5FdMGxcUucwfLq7dskzA8dA0lOja7BdXI4CIILiByN3f2nW64uHKeniOGgdxlX
	6+tyLhb9c1lah6aJqf4BTtmtROgOb2o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ndx/x6nw";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593319;
	b=RVDkdhf5FACT4eEsYh+1yamdF8msdCb0jFUFHVuoz8zx0c96yc/d+5EbR6zYkw5Yk5P3yI
	XZ+D8nBV21yLPJFoum3MzJS4Tt+jn8n8oeI8cRW+Quv35YVe8xi7zlGAoVwcNHpu6B44bR
	Iafmo4wfJlUd9RxacFDiAfXwYx91BqI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 834F9600E2;
	Mon, 28 Sep 2026 11:01:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819E21F00898;
	Mon, 28 Sep 2026 11:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790593318;
	bh=ZkSQyWzu7T/0A3a31XNu8vpxdHKsJ4rnNLYcnd0bezA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ndx/x6nwMj46Es9rYHZ9z5o5JqF6jxdKphwEJZh+flA2ah0VkSrN1HPEkvBpTZ55l
	 Ec140TtlDd00Tm8VtLGdh+OYVKZXZ0cixKbTgzq/h0Jrs+rr0ZvEOC8OG3Xkgg9QsN
	 sPsYC2pc+Yqt/UI424ddW2XK70/rrvc1WMUH306WX7q6ii+DiFZaGC8+1oeExOv1le
	 IyMP4ppESpTjASvi8x0OInxnclTaAPXeNrazQgAAnd2ENyXioV7QTp6iRQKOApdZwH
	 WNYK0ElfQrsxviktM5lH9ifaxdewsw+Ij7RF58oCxfzkZWcVw9CfQgdsm+NISW6BNW
	 XNEDMAFhYc2gw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 51887198003A;
	Mon, 28 Sep 2026 07:01:53 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 28 Sep 2026 07:01:56 -0400
X-ME-Sender: <xms:IUm6amGRh7ivfHDvq4z-E4J238NnRqeDSKn55_llFW07u2nvIC12gw>
    <xme:IUm6anzTLp0eOfCljLLN7gd438Ibx6XI9YP_osT2WClEWug6PWQZEYIJVekIUzG5l
    Tr-0rptENVwcMoqN7WMkBrhNoGTT2U18ORsCPfW-OmiEc3ZRh8KTZ_i>
X-ME-Received: <xmr:IUm6alm3_1G1yWMrJZAP6YyyEhFHpAW59SEB6sArwbs_1HFnH1XDQTTvpZs>
X-ME-Proxy-Cause: dmFkZTF0aXYM8k99TJSKePzPlV0De8TMZ2NIzeehRzclNPyyK+ntmJJe9xCW5IfIQqBvZb
    4B//Q8aA+dg+pkoM/Hu4RNB1DMHP9RcAheVWJjNEUWscLZxr0DKXN45dL8/VHoXCApqgdv
    9kyt5mrKg/Qv0CHkIWHqHnTGVENgrqiQhzXgV4SFDHQCtMPP0dbQrKV7Ld27CUqdi/llIg
    RPOyyKS2epukrnxpRUIDWnbAA6KMEqtKVW7p8XcJ5GCOI0cRyClu1cuGLZi8XLbNZuRw22
    4LFnKw9fd81HwwydQsLTyoqMNRUkKJLfz8JqZMNAwQBJE82qW8VZnUdBtFke/U1qNBefWu
    WHCWENgAaAF7ORaIKprhr7jnkKBAHlQytYXZ4nF9v7PeatMRQz3kA9MLoHMo1ubFNX0htR
    ZZnUVdeBxwHVo2Q9B2+N3Eh6miyohAYEhBv+2AdOVJT3RUAG90m8Ht+cdygxtl1HsmeT1u
    dMRCTmtfi2+cS/qJp0ga1/cmugkZ3GHpjh0iUJnBpTvAIMXsHbLE0TciO9UV6aYwEnsIC7
    A51LzFfDGTFIHQMkDkOfmf1YIk0tochZfIOTFQ97CEiVXCYXjRhwr3QG4FQYMxJPb2BhM2
    tLlFSoqklbLoC9YaXpInfuYnQIKOYnUc28/ozsBsi8pb+OVTDGPgFXtN/eWw
X-ME-Proxy: <xmx:IUm6auBd3_IhSHMMW3j4FKZja0Mq6HFnH8XR7kq3VggHYchzikfyFg>
    <xmx:IUm6agKxqdn9FF9woV3mgkBZEhkETPfU_LNFx8CsGvUEeAGGUsoXpQ>
    <xmx:IUm6ahwx6SH2NL2nvBSCuoCYvtrA-MntLblDciCkdhYYgjLUBxGdoA>
    <xmx:IUm6akz2-uaDiSQsTbDgrPDCV3AZqJhHwdzK44hNCNp5pwAqq_41GA>
    <xmx:IUm6aj3NRI4ihvxFUzsqZuJuC6btbpULou_EwtGCUY2EM-zl6oWB9zOE>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 07:01:52 -0400 (EDT)
Date: Mon, 28 Sep 2026 12:01:51 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	Brian Geffon <bgeffon@google.com>, Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/mremap: fix locked_vm leak by splitting VMA for
 MREMAP_DONTUNMAP
Message-ID: <arpI-wmzRXU5aSOG@thinkstation>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-2-6ffb556f8f8b@kernel.org>
X-Stat-Signature: wpks5a34nikfx4axe3nqygr4xsmg1uae
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0F7FA180015
X-HE-Tag: 1790593318-419452
X-HE-Meta: U2FsdGVkX19HqDFfRTMV9s+V2HA0ByrxtP7hwtsjKnplES1e5Xm0NueahSmbQtyfz4jGKbKsuxxQmdJVJSaDqvkm0RrA2mDzWDCInkH6awZ15WqYHuXxaM5vx505lnHn2vWf3iv4wJagCaa6CLNaRPeQnRMwlZ2LmsHCeyBmnDJMT1Nv9cFOgAQlqS/VfquduWsOhO2xFH8ctLyiXy+UIPdC9sh7aF9vPpdEB3k+Gmyx338qj40IWxm0wL6Xbng0W0at7aFUDixdx+M5kSwI+B3YlORvxb9d6JF9HDMlO9RjzlTipe5ne46yPmQKc0QfVBujANLZCMe2oBgVXIRz2uIgT6TiZNUC0quStj0//QAPp/qe2zKcM2T0vb1RSCmZkEaCcTyOl/78DZwNBiMRJYuUpwJhpVgxl7hfnckvwFCsvLbgGaKt9YkvvQ6Yl+XW28+uUTWvVZeqzq3SRht4v5+0beVqHaTAYpgI/da1l12EkV8hqRIQa9/twGimNnTcuq8YhnRKuEigORUiKn2tuClF2Q1zoB0odtpsDhR8zfJFktNgm8yjNw2edE9SGl3ZMxYg39TR7qhMlpyJUDr3bojawZfn0QFpjkGQiZwpVuioSlobRPtG7npCS/uCp8d50vdGHYw1STgCkOI9PMeWDTDD1v5l+BNd6lpSAtVQFxtKaIO/asc2c2vpceYLwLzmnw7EmjUHyqXdjwuTO4VYWWwdTjxNsRBrR0LKkSMw03t5qgGP993AzYw+voV5ioiTD3rD1HxRZZjsYdYuDGJphommI8XhSY2iWUuQLilZLlO8msW2MhDkWoo40ahicyC9gEVX9ea3gyf9JuoCxaBQMTD9uFYsVMToa+mUya7bNWF3H48+PIpiwG1UOI7841roznHXevUr075dKtTJe3Gt/n9xsgVOHPoDuzXioOzpTgLydr9UGY/l6yj6gai2xyz6cM5QqEtREw1YnIm7Fso
 UiMBtnhX
 tT+iNwLcunkjiV0pDZS+EysSLO0Lhw2lzOIeAUe1TTbrVqUZuFBVAwkRrZ2dqrMenRb9JfsMfvoU5XMbOoYO6mPPepkOHDV14bZUhN6H2yOwjJo1wnDO/a6BVWAfTOo9KBgRjYZeRnQpbOwKdt2S4JnAK2p8rjCdjcpoaRrRwX59uorCAATzew1RpcHJfPHxEx1AiwC4HK7O1mu3k1GyR2cDmibJ/3YAxrEfDgb7V5qxXAk9MKUwTEDuJtowsxWNgN3ffUOFjUnFIiI8RbuhR8PQ0FuVxXIqcT/jndO3PrFYChuzK4JzY7Do4zdhUpem75kJhGjMcfTwI+efeppDf2BqW7riI51gnKiiA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:11PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
> 
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
> 
> Fix another of these - partial copies.
> 
> The long-standing mremap() partial VMA logic has the baked-in assumption
> that the originating VMA is unmapped and thus moved.
> 
> However MREMAP_DONTUNMAP defeats this by performing a partial copy
> instead since it keeps the source VMA around.
> 
> An mremap(..., MREMAP_DONTUNMAP) operation disallows resizing of the VMA,
> but the operation can be performed partially:
> 
>                            |-----------------|
>                            |                 |
>                            |                 v
>                         <------>          <------>
>                         .new_sz.           new_sz
>                      |--.------.--|       |------|
>                      |  .source.  |       | dest |
>                      |--.------.--|       |------|
>                      <------------>
>                          old_sz
> 
> The page tables in the specified range are moved, but the original VMA is
> kept intact.
> 
> This interacts poorly with mlock()'d VMAs, as the VMA_LOCKED_BIT flag is
> cleared for the entire source VMA and set for the entire destination VMA.
> 
> This results in an mm->locked_vm leak as the change is therefore not
> accounted correctly.
> 
> The clear solution here is to make the portion of the source VMA which is
> mremap()'d distinct from the rest of it, a.k.a. split it.
> 
> Therefore resolve this issue by splitting it ahead of the rest of the
> mremap() operation.
> 
> In order to make this change re-expose split_vma() in vma.h for
> CONFIG_MMU (nommu doesn't compile mremap.c and uses a static helper
> instead).
> 
> A quick search of how MREMAP_DONTUNMAP is used in the wild suggests that
> the partial case is either unused or rarely used, so this should not result
> in unreasonable VMA proliferation.
> 
> Since this makes every mremap() MREMAP_DONTUNMAP operation operate across
> an entire, distinct, VMA, also eliminate now-redundant code checking for
> this in dontunmap_complete().
> 
> Finally, update the sys_map_count check to account for this case.
> 
> Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Makes sense:

Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

