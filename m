Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12C310AB839
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 00:54:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F6976B00A1; Thu, 26 Mar 2026 20:54:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 380706B00A2; Thu, 26 Mar 2026 20:54:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F356B00A4; Thu, 26 Mar 2026 20:54:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 128CA6B00A1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 20:54:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B23B4140F37
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:54:36 +0000 (UTC)
X-FDA: 84590022552.16.D6860A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2C9DC1A0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 00:54:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RCUN1u2P;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774572875; a=rsa-sha256;
	cv=none;
	b=vQOpo+pbRDcp3lk8DPuUtAt2KE22xAt+prxQffEd8EgCcUX4B6WxC8mIgte+flVj+Wlekj
	34bcEcrfIFXjlmLU4LRLNq9Zz6DBwm+oIiVf/daWp0xSIyE0J7nYiYVogNSpA8sSuX+ZbC
	whr0NYqhcGUwICnX8TvfrgCMBuRFjT8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=RCUN1u2P;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774572875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BsG4Oif5fMkrCdA5x9h3xggC6X7ShoZolUiiN+zQ8vg=;
	b=Ve/tEeIBmBw+hwLjHjORRYBQ9eCDg+tZCAnmdwjQJSw1G6c/6kgbQPbYx8/9K+mwxJJiAH
	KIzDuZzXbnM6krZSIA2g7aNAVNor8a5UfYUBrbWgrYZiZ65uvBDJ53D86ZikZdCFph9ixI
	LL865mrxpVP3yQ4mRQfAP+dbfSqPDf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8D33B60054;
	Fri, 27 Mar 2026 00:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB864C116C6;
	Fri, 27 Mar 2026 00:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774572874;
	bh=A1uSR7ZMVXc9+x0Vd/fZJiBYrJDicq9K19jaALu3MLM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=RCUN1u2PKz2KarhxjiCebWq0+7ynRrjL4dRmllJbwPV8Bl1Bm627qws56257wmWR2
	 YyNI0a8eWA/rq73gbyfbyYqaIAtsxeMiOl2OfLerfmDvIkZgTJc3yf70qCuXivqY09
	 Klmpoj6Wr98tH177GxCRsghsIEU7p5sbMV+89YzU=
Date: Thu, 26 Mar 2026 17:54:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org,
 willy@infradead.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: reinstate unconditional writeback start in
 balance_dirty_pages()
Message-Id: <20260326175433.5cddde03a0eb201042a1ed55@linux-foundation.org>
In-Reply-To: <20260326215127.3857682-2-joannelkoong@gmail.com>
References: <20260326215127.3857682-1-joannelkoong@gmail.com>
	<20260326215127.3857682-2-joannelkoong@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3bjqzhe835acdewgz1pkyyop8pmb5s4z
X-Rspamd-Queue-Id: 2C9DC1A0002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774572875-570809
X-HE-Meta: U2FsdGVkX18AuLYoWIretEarnn2bmAMVeNUxInk6W3ijvEXwDzrGEZhQN5IoNhks8RxkLNbMg7qsx3Ple5EfxCm11w7gWiVbyKKhr0EPSlDM6oTNX9H4DouU40/1+PF4NTKDcTV8ZkE1GDezt2nxe7zhivU0eFAZ+SreZGaIaSdE1pspTCB5gwVq8K5AQt/oC8N1ugbFZ6f/ICQIK46dgEQouN8MfuXO4PjyNmCoL83P5vUNDageqMKKFZKT3SirC4b0MM4g17XUeX/MJw0KQDpcLBn2y8TmpYv7Q4InAaWkb3Rzvgljfsl+AJIE3hxuFsxG/3B15R3V5oeDrHQ3gzkLDfD3TJMfiOgZqZ8lqG1GsynBVsMmlDf90AOsd/F/uDB6/qV3BMNF7ftn5DvN9+mPjpERIKrq04Pa+Et5pIURXOP42zQDtEfibyWlnk13RrxXPZGRy5MeL896AImiSmkhckgC43fHe74xoPXTf71aWB190F+u/ppF+u34RftnFKKJGRO86w8sHtAEb+HRZZAI+27PtddSkptG1uxBNR+ALc5xT5bd55u0NJzhylP/oI1YQf5YN5g6C2WbJSK2tc/83J1Yq1RKsW/S9TLkZrYL4zbMepmqMCOUM+Tlneno8H1O9Dr9dwv93qFRQ8teAs1iMFnHkz/xLHH+xJXPFAJLAg+7lzY6L5Ypr/PK0CPOs4vKXCgdMKphvZZagVlB72sk37/AyY7LtCn0DT0KJ4unMN4KIneJH29Di/Rpx4PFX6UY+sCgQmzDNEJc5qdyYGLhpr3XoyWoSF+SHiqXYWbdljRCkEe3q2GHGU8Pyte+qbNERnfUSzNqdayUQiT9Zr/a3FCIoPUTlTqyAFr4QpN80mAEeKmkOnSzSxraSKEdwngVefDzDO8gO9C/zOsTPVA1oXuaSk8iloq5yXt6zqwNbzR1q8/Sgj9oLbHA/uVHD+bGa8wM+sNvw8kbmVq
 uFnD5TYZ
 7H8g5n4+h1J/9Qs6RzSosa+fNcN2kW9KdhIQ2XiHlJ6gfekm+bMJA9EJHOr+7N9IdLKZjtsNny28/D+TXLqOgMln0g7k66xX7fXD8ihfEiC+4MnzBkBKKWV+DE3+ozogJhNvTAS5Y6rU9JEMvJmhxE4BY5nuKbcNctoBmwRj65qoeLU6JH48cf0V26MLS2rvp4xwZe9dnfoFdgsemZdBBuLJbGsfTKfr4hVYEe2Gj9ImVQ48d7WSMIo8pB25QGQMAJ/8EhoMy071sWV93SuDRdxyP+XjxaNQVhrXRv9LNkgNedRZhwHSRWVFvC7avOOq1v0m9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 14:51:27 -0700 Joanne Koong <joannelkoong@gmail.com> wrote:

> Commit 64dd89ae01f2 ("mm/block/fs: remove laptop_mode") removed this
> unconditional writeback start from balance_dirty_pages():
> 
>        if (unlikely(!writeback_in_progress(wb)))
> 	       wb_start_background_writeback(wb);
> 
> This logic needs to be reinstated to prevent performance regressions for
> strictlimited BDIs and memcg setups. The problem occurs because:
> 
> a) For strictlimited BDIs, throttling is calculated using per-wb
> thresholds. The per-wb threshold can be exceeded even when the global
> dirty threshold was not exceeded (nr_dirty < gdtc->bg_thresh)
> 
> b) For memcg-based throttling, memcg uses its own dirty count /
> thresholds and can trigger throttling even when the global threshold
> isn't exceeded
> 
> Without the unconditional writeback start, IO is throttled as it waits
> for dirty pages to be written back but there is no writeback running.
> This leads to severe stalls. On fuse, buffered write performance
> dropped from 1400 MiB/s to 2000 KiB/s.
> 
> Reinstate the unconditional writeback start so that writeback is
> guaranteed to be running whenever IO needs to be throttled.

Thanks, I queued this in mm.git's mm-hotfixes-unstable branch for test
and review.  This starts it on the track to mainline before the 7.0
release.

I assume we want to be prompt with this because the fuse regression
sounds pretty horrid.

