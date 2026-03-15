Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBC1610854B4
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 00:11:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0464D6B0088; Sat, 14 Mar 2026 20:11:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F157E6B0089; Sat, 14 Mar 2026 20:11:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E21746B008A; Sat, 14 Mar 2026 20:11:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE2A46B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 20:11:54 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F53F5A246
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:11:54 +0000 (UTC)
X-FDA: 84546369348.04.BB3DCAC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BDD8040008
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 00:11:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dCOqyIoY;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773533512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Juoobn9SenIBsZDJw8uxAIZt8pyxLrXCQFAdOrJaUDk=;
	b=kw0knzeULCa4UL3fxqCYfQ2zJOYaySRaXD9BrEYsFqDBuNPJcK6ztT9EqPfqaLWoASJR2o
	1l8/WVldqDiPlyh+G16f4xRxiq5uNcJjcZ8jOeZRGPfeBTeJqbvI4Go4/IzbJccZrWjgRL
	l+3ypI9udAr8k0a5QJOVcRJAM+KKrK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773533512; a=rsa-sha256;
	cv=none;
	b=DGZt/jztS/8HfZ3NFLo8Ed5Z/bIizoBMUg2JbHtBJ3JDKOdNfZWb0EFXsHc9Vh1wqwui2S
	t0+51XupoH3zqetxysea6bajQICIAkW5v/+36Z/DQZz98MX7PsybbTq8083t6AN59xNpKJ
	xRqbwDHGkzok1awxhBgY8ebuNBUeeL8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=dCOqyIoY;
	spf=pass (imf17.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AE1FD42B61;
	Sun, 15 Mar 2026 00:11:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C328C116C6;
	Sun, 15 Mar 2026 00:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773533511;
	bh=L/1c8OBPkRGOP7RJPGO4H36hjk4kgyL6lAHh9ls8NYc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=dCOqyIoYfThGDfYzUlIfU7lplof7zJXlU2c/1xJH29lmvTzocBoJakIccAly3gOBc
	 1MnvHynyYj4yV/aNLELFgyfQUnAZnO/cIdTGjeE6GR/DRh/m0UAkBkcBZCfiyiKHL0
	 ehzot4uwNzzK65jYC8LZCnelO/dU8NloJre5X+Bs=
Date: Sat, 14 Mar 2026 17:11:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com,
 chengming.zhou@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 herbert@gondor.apana.org.au, senozhatsky@chromium.org
Subject: Re: [PATCH 0/2] zswap pool per-CPU acomp_ctx simplifications
Message-Id: <20260314171150.fd6a80a8f51a5390144d20d6@linux-foundation.org>
In-Reply-To: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
References: <20260314051632.17931-1-kanchanapsridhar2026@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: k8jwi37zhupmhemgxhdyxbkmsx8p311y
X-Rspamd-Queue-Id: BDD8040008
X-Rspamd-Server: rspam03
X-HE-Tag: 1773533512-345241
X-HE-Meta: U2FsdGVkX1/RKToPDBIr0x67yj9Gra0bMUQQjn8Qu2gSe3mzO9fPgrCrgk/Zin4u1Ox22AZuVU46npbv2K1JyTZzxMLU9qrGf/80HFUZaAYhWmtaQnvTSC2D0PmeDWiF2ySy6mi81wcxmSxcxyEmMRaDYpuxq8yBYP8Ton+EtzwAsgU/Gx9lp6BOJnMPOgI5Phx+FMPewuHkGn0L/mejgH3T87cej+eh+XCE2sGkLjLRIl12x2a/LPL1r4Akk5NSeFkfdMjmAYuIumFVg3qOSZxSIBIn8nxWA4RqiiQoDqsz5mebAyhBR2Mz5qNwvDqhUKBpuJPqEQM566wWXjCYkWsVVQLRoYZewyZSj6eg3Dqk+ND1kB2JeVCJcbfCdB+2pKRx19DW33r33bBFX5cK8m4kxx1+vVqnmj0rE/BApG3CvTpSbXW4Bv+MuxonsOs/8qnT806Ww8kYUKmCJgL/r+DVveBYwClptarxPD1X6vfoz8hhPdMvADukEtcNnojmObgxFBuxE6PDGyyE+wjja6tysYeRnBSKAaYDgvirDbC2ipPQR4UVgAuL1AFSLqnG/DZYUM5aOM8qoeaRQgny3dKKdV6e4AoSijJhnGKgo8nYKPAUeL3Rt8zLym+RQvDJHRYT4Mlg/ZQVzqfvGPOZaAdVuL7Do+8f8o+ZOoCKzrHBuDbd4c6PSqiSeMTyFxGJg5CVAGO8bvulQfFaS3bBxjY9kDaJ5jZC7lxmR5E0hT7k6lH6Dt97L3HXsXhgewm0dkA5a2gHzYMyCQQX+OvCbAmBCclqhypRw6NwK5yNIgBJxpGWC56xchHHsZVqtuEkADgPcnhUXwIlwvlbLoLfQfDarL0vjgSxQnRLd3mNHkH70Q3LayjirK4vIBGyJGFHBg48bqyb0zlkkSX+pzhSlhPoxYSwin6K59iogHaLE91/azLn6GyRuR4BRPtHkHHkZ1pC8mEL+GJNr0r8kYt
 /VP1PsaH
 8t3mq34LiEkDAskjY/eG5Ajb4EW5eVEZHRMIyiKsrnoP/lbqvMTlh6gztk569w6PJUUXvdsjYN9+IvBFpl2isTaKLF6WGmPsFKQ2tN5BkB1im0YjtB7WdNQqYTf1nV8o1fCcwIVqZaOWdaoQZ5sVn0vuTaKh4nljzpXdIRiidRSM5aELwjqwqkCsH3us9qxhRooiiwz6kUaZdxUTceliAGwVvcMk8z0/ztZ51pC/znZRyQCB4s+tamI9ZKTJKZH/gYVSy9o/YZQzxGyXELav6M1GBh2nZcJbsMDpzIKEPp3mG50saKGyWj+3lW+RCIZdmIO9YlmkFWqvYn8jzFCB6tmVTbA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 13 Mar 2026 22:16:30 -0700 "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com> wrote:

> 
> This patchset persists the zswap pool's per-CPU acomp_ctx resources to
> last until the pool is destroyed. It then simplifies the per-CPU
> acomp_ctx mutex locking in zswap_compress()/zswap_decompress().
> 
> Further, it consistently uses the same checks for valid
> acomp_ctx->acomp/req in zswap procedures that allocate/deallocate
> acomp_ctx members.

Sashiko has questions:
https://sashiko.dev/#/patchset/20260314051632.17931-1-kanchanapsridhar2026%40gmail.com


