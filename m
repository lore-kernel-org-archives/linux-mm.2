Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C7B3C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 04:30:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADE716B0095; Fri,  4 Sep 2026 00:30:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB5D86B0096; Fri,  4 Sep 2026 00:30:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2F06B0098; Fri,  4 Sep 2026 00:30:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3976B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 00:30:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E04A806BD
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:24 +0000 (UTC)
X-FDA: 85174803168.27.629C3C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 508E514000F
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 04:30:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mur/72WL";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788496222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfftmsa8TDfeo1LBQjT5xMFLuIxo7M1ZT1hU+UD0CYc=;
	b=X0OwLOOF9qjFIgnoFpbKLDtZgVHKMzUv7h1RssHPuFycT98A6xBifznecj1jZsEH/fFmSC
	CnDQisjY6vKmyhf47k3P8jYFMSIpyF10pEA5+oNjUI6yf24gjuj4KQF2LAkrIflcNNT7u0
	TeG6hNwEjWpk3NbAdWQGhnP+DdQv7q0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788496222;
	b=kJxyPnUz2TEet9bmwmYQNaRRNsIT5D9Vtl79GvAxAFn72ymm/MSjc//gjXp3vlJSA5lU+z
	4v9rmFu3ab/fCgm+rib854Afre3tijNEbl+Z/7tckK7LWoSNdQ71iOxXfBYdMYtMYE5Tz8
	X5OcfTgBmvSyKkmpqx0JPmw6QPID+Ik=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="mur/72WL";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BAE5660A62;
	Fri,  4 Sep 2026 04:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 145D81F00A3D;
	Fri,  4 Sep 2026 04:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788496221;
	bh=hfftmsa8TDfeo1LBQjT5xMFLuIxo7M1ZT1hU+UD0CYc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=mur/72WLEwGUsqBE9CU4iMK90/oNqx7DHImjtz5FgERS0n5U713zNsRz7c4jP/BY3
	 zSo+9KRxjYkXSdrud+BzuO78sM38S0pKYiZhCQJe4K7DytBT9mhg7UZ88bFoihra8F
	 bnB1wVxJquR6eLc+ACOMfUbTGFgN8prdJeOG6tak=
Date: Thu, 3 Sep 2026 21:30:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Lance Yang <lance.yang@linux.dev>, Qi Zheng
 <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun
 Song <muchun.song@linux.dev>, Dave Chinner <david@fromorbit.com>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>,
 Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
Message-Id: <20260903213020.6c609d3ec36453f88953d367@linux-foundation.org>
In-Reply-To: <697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
	<aphXPCn8isUVV87k@localhost.localdomain>
	<0c5aba0f-137a-4aaf-bddc-060118322602@linux.alibaba.com>
	<apktMn_hwvZwsRUG@localhost.localdomain>
	<697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 508E514000F
X-Stat-Signature: ecmheeyecyn4eten4zrfe9saxmh813h7
X-HE-Tag: 1788496222-28730
X-HE-Meta: U2FsdGVkX1837zy6iFtHwe9CZrSH/Uqv2IHW286czLBmcYCjpsD3l4XPZJml3tCz0EQHFFOn04K+OGTYyo6T6fgbrjsDbNJx/FQbd7fLVpETC0r8dPCkc0zsc9J6o55ciEhSM3/bSQNyaMwQXzV2H4R0hyjA0OiOXhbS/VrWt/ytlgOfoiK0xrHpXnP+k+06lcodomEDMObWz59GRVvpavcgCtmlKPX/ZpPClvZQqSMzzOMqAlfaqkJ+cJuAgBMTwpK0qylJejIgM7LRqiOOQThhAMmqfbkm059v3JQSYKPngttveklfXsnA2aFTZouF75btXy4h8bDuewtnlIqwAGtAIfP5FaRmAJf0JD0e1k1RWF+pprzyOlwbMO9YE8pLmz1tVjlB/zqXj0CCFM1SuGQAjA8eTYYMtczUWA6tZMq+73PSt5OoPSlgvEMuLXFxlr5/PEg4CYjjYOuv7P+x+AaM64QCZXvOPy2khLEXwa42P8EEaMDgTVS1dPnEDtNlGP0o1bcPVK+rTftlxWmf53uH7Cf5KxIJ7VByla+mw3dr278mmnjbGl8MZUCyFU2Lh3KTc0wxw3YkFDXKGffG+sZvtR9PDz7xsYXQMQceRI/JvbaGHD7hdczTViuquj3mGhzw/mdlc03WIQF2oWabI2TdDFW/K5dnIgvQhLOoF5x57lIL9HC/5lMYf0J3A2fbLfjUtTn3Opsbe9bQ3hsL11DYX/hAKJLa4/dE1nsyzoQ0qwuGQ9av7GhoSsrwK0QaOHe2gfIIm3aV5OLMlJ7p8tNKrT0+CGyW3JbpyK/Flj12TekOmx0mHEMx0Od/hguvzbVrQlBuCkpDb1NKPy+OkeZ8ZAivYyWNBl1i1murFogCkAcj/koFsSTnx8G6aSPHjhcSzfKBteKrAc1+BMwNduyvFVI1GFLxrsgRsc014i27V/BEfFVTHWrdB8Awipr1gZhGA+Peyyj0/qtuJ9E
 yffIQ/rQ
 Zszls/62daVniwNLvk/56kp1gsab39qlukVjaJ8RUnC8Rc1ejN4xKAuyEAihM0aO2zZTKou36Loh1CgG1s0j3Y6Jp/xpTFVaPAdVuZSh5rq8UZQxQWLtZQ95ptVoO1EjdnnY2wNQgWys8QmVMDlCIf6PRRFEr3H968mfOJnkqPwptWWWRZ6PxcCrHywynP971hqCOaugDMn9cX/erjHQD3WJBhtHttU1goaz8wBt1q32tvq7bFHGgBAc606blzmw21kXK3Wz5r2aCV2DaTX3hHwfF5fnsYba3+ZANV0pWVrIyuG5/rL7g8K0u2URl9ljqpkuE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 4 Sep 2026 10:10:20 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> Andrew, thanks for the sentence fixup yesterday.  If Michal agrees,
> could you please also retarget the Fixes: tag:
> 
>   -Fixes: 03375203e1da8 ("mm: do not allocate shrinker info with cgroup.memory=nokmem")
>   +Fixes: fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")

Done.

