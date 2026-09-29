Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5B52CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 02:15:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCE7A6B0098; Mon, 28 Sep 2026 22:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA66F6B0099; Mon, 28 Sep 2026 22:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3116B009B; Mon, 28 Sep 2026 22:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD4E56B0098
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 22:15:03 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4666BA681C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:03 +0000 (UTC)
X-FDA: 85265182086.21.4E441C0
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0878AC0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 02:15:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oAq8l7OU;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790648101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6DglEALNAKGkWEGvueXO9BQlH0pS/TEfFtEcVQ+wjE=;
	b=rqQAi66Ieu4BHhS4n1TsD11Qrw27+Tb7yAwgDVFh9RGTLzMsJkr1w2oCSvRZzbT7IieZ7N
	ukI+Bsg6vaNDZb0qlasCu3LTqNDi3v9hxk7IsOqevLyRnBL62y9BN1P65799J32v4ECZlr
	XSzfCdoPL76jQnS5HHZmneYYBU53r0M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=oAq8l7OU;
	spf=pass (imf10.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790648101;
	b=M0LiJcM9R0BRE3kYOw/dOj8OddfswRNd1fGv8WQZbcMzaxlxbKBsLc8F/oFxAMcGmKgr6L
	x1ufjZ2BA2uxGv8w9HAK79/Nd4bNmrd5+cGfxT1zB5zPZgITZVIVZQ+QV19HkeOaZkwiwE
	BJsxjijQ/N2XTVITi/PnEoSjUi/Hhg0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rxdTIgO5tcoa9utEwRzu8owIHZ/ZCgjiYbAZjXqF6OE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790648099; v=1; x=1791252899;
 b=oAq8l7OUuuYc+MVRYRppT4AhxJE90KNG62JUkLAHM/iRY2XDTfF81D7iEdX9UKQQA+xywSyT
 SEl/7yCsCbQ6zwh/cnMl1ONKHooAGaPtE1L8d7Mcb6gKUr7PvnmUv3bCP7nOH0PO22VLQ74MgIH
 Rz2WzvL4GTvrMxtjW9P3Pkrs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9cc80926e911e7b9;
	Tue, 29 Sep 2026 02:14:59 +0000
X-Mizu-Trace-ID: 9cc80926e911e7b9
X-Migadu-Flow: FLOW_OUT
Date: Tue, 29 Sep 2026 10:14:56 +0800
From: Baoquan He <baoquan.he@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, hch@lst.de,
	harry@kernel.org
Subject: Re: [PATCH 00/13] Don't use GFP_DMA when calling dma_alloc_coherent
Message-ID: <arsfIPGMwKxm0iyY@MiWiFi-R3L-srv>
References: <20260903111836.1777265-1-hebaoquan@kylinos.cn>
 <aroZD9TBlOKoprQm@MiWiFi-R3L-srv>
 <20260928170756.815406182a70947276446122@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260928170756.815406182a70947276446122@linux-foundation.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0878AC0002
X-Stat-Signature: dpfdxmt1bqd3j3jmc189a4xtjscduksf
X-Rspam-User: 
X-HE-Tag: 1790648100-828015
X-HE-Meta: U2FsdGVkX1/C3fVhFxh+k0PogaBJF+s7ijQMjjMwLzzYqSw0hKz9kMKokf7mQLsdtUj4OJWyWVYe1QcblA1m1MIQNEIXZDYbzKjKIax2ZhAeQiuJ2JH/YdGAw+16nwAjv/o4NQCfLJgUm6X0GXX+pmN2HXHo6Lsx5ehAb3rlVn0ytlKrq8GLshc5Ab3+LGbuHKWB48lyfUsTO+P3VPigYrYyomtVMZ2edE5e9pffI/yrswPy1Wtq8Fk69ngnKjVo16eBd6NlFmjQimjCZAYl0kqbWqekXx2Qvv8j13L5DtlgapqT6Z6lCZZ/oKFTvMto9Z5vOb74eTQ4UTeh7qzvrbNmz4gbXsxnYDC6+PJS98OBsrrnpte1vyQJStvZUip0iM8clnDgul4f75TVVF1i5pgVCip8J7wX0pi6p4qfmIt/wOlvZlVM8fnsc/JNdK9Wf/8cfYCf6qvt6DWMLC3GHEvZixIdjXVE1zrnpNnD7XaDdGcNcelQ3q52X4kE9mlBafpHuZw+94aC4zhZl5FRXFJ6Zl/u273anup/tLARrkhRLFmmwOhdw27o9f37klqpbm/XmpTwRqT7/rF4OmBSyw5sEplwEEefZPocYUYWw4glbmQvzyMOF+fJczjIJR8JwjvwSB7jXGWZnEfofNmj8W8qxqvG9EQsXxZQnDiuGXXp62axN+gUR/dGZaQK0Yzc8JvLydsJLM1q4iN57naP6kqvoTMYhomeg2fuafW8EoOD9KbLg8dEpPSpXIUVzMiIZgNeFbohQHCk0Sg2WBf+XlEyC3UKZstfPbvWGRpWvtwa0+LAexwFrVL4AWZ9QVtqqbwHDP2jqIi7v6EtCY9bq5thOmQmtOnX6+r3JokRv3dDzDpvr/zqg3+NXp1jJm2JO/2V/d2vIW651EcgJQrK25MXbi7p4oTjAUGDD4WIHOKRuC6ZOx5DGRLdwW301EmLfT+Ru5q050GSkE5668R
 s5OaG3m5
 6LVrJjBBtTWlCIdFYGeFgVJgyqcD0zeTGrKKbHx60Tk7YubMAqxu2etiqHHBqS8z08C+jkfOaneQGKMXFYSHAIHOc9y+y0fmJJqtzMSeHmHPFB/djDvyI970I1I//sppA1oFiAa9gYtCm+aHmoZ45pFEkes+iT0F3wgMIOzBZQ7oiDL5Pk/sZJePjjUsle3MW7Ci3maYthnYH9J8h2ZDujBkPCVUdYmDDR/+ft/Rrs1kufPnqQGzG2XULIOddeQbxEUmp25k3r4NwP7RLmUohMzDS/ykqcU2BD2Cq9Yoa9SalsjCLevpjJhwDehxoFJmEYRyjNlnMARG5tTWJGjPq9W/mk+WeNuQWmEkBz9wOjqC9wMH5z9acRSWxSggCbzOl5yEU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09/28/26 at 05:07pm, Andrew Morton wrote:
> On Mon, 28 Sep 2026 15:36:47 +0800 Baoquan He <baoquan.he@linux.dev> wrote:
> 
> > On 09/03/26 at 07:18pm, Baoquan He wrote:
> > > This series picks up the first part of an earlier cleanup series [1] that
> > > was prepared back in the year of 2022, but for various reasons never made
> > > it merged and has been sitting in a local tree since then. This subset
> > > only touches the call sites where GFP_DMA is passed to dma_alloc_coherent()
> > > (and its dma_alloc_wc()/dmam_alloc_coherent() variants), which is the most
> > > self-contained and least risky slice of that work.
> > > 
> > > That GFP_DMA is simply redundant here: the DMA API derives the allocation
> > > zone from the device's coherent_dma_mask (together with bus_dma_limit) and
> > > ignores the GFP_DMA flag passed by the caller. 
> > > 
> > > Removing the redundant GFP_DMA won't harm anything, while keeps it from
> > > being blindly copied into new code.
> > 
> > Gentle ping!
> > 
> > Wondering if Andrew can help take this, or anyone else I can add this to
> > ask for help.
> 
> oof, mm.git is overflowing and I'm trying to stem the flood.
> 
> But this series is so modest so what the heck.

Thanks a lot for picking this up despite mm.git overflowing — much
appreciated.  I see it's now queued in mm-new.

> 
> I actually kinda prefer that this sort of thing be done in a single
> "treewide: " patch.  It reduces the patch count and reduces the chance
> that a driver maintainer will cherrypick a random patch from mid-series
> instead of saying "ack".  But many disagree with me!

That's true, maintainers have different preference. I got requirements
asking to split patch according to arch-es or components. There's still
one place left because it's in network device driver code. I heard
network people has different patch submitting and reviewing rules, so
leave it to net dev to handle it.

Thanks again!

Baoquan

