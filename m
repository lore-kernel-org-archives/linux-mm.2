Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE8B5C531CC
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 00:00:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 682886B008A; Thu, 23 Jul 2026 20:00:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633526B008C; Thu, 23 Jul 2026 20:00:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54A176B0092; Thu, 23 Jul 2026 20:00:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31D4A6B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 20:00:33 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B8B17A024C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:00:32 +0000 (UTC)
X-FDA: 85021713504.01.8561AE1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1A987C000F
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 00:00:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VInGeHuM;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784851231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1882OtUsatNzO6ECKrSoNPT3ltj2l2kRQNMq1cLxwrA=;
	b=fiMnJKqbWxWapWBbLr1+0xemvpLQ8umgU37FsZEThkYNaAH7iUCV+yDdSHwttgBekzLFTP
	Xd3q+EW9vwM8Pz/Wht2cvQHt5lBr426mjTYHF3dYE6q8cfKNEUU5xDC+W4myl3YsS6xs2K
	UaxFvYnjZcwDr5mUievnSAd3JY/GxR8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784851231;
	b=HPYb0L2d+yCIKov6C18dUFa2ytdjOxHuURUE9UWILgBLJhcEZGg2/GgUzJHDePCV3aGe7g
	rPK+Orhe0jiS8xQ6gZNgEqugeYBsL+0rlo+jNe41ZCiuw++xtvi5mAtrD5pSDVyVcYM5fO
	BSW9dzBjNwCs9t5aXksW4sEUSP5djEo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VInGeHuM;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84420600B1;
	Fri, 24 Jul 2026 00:00:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF01F1F000E9;
	Fri, 24 Jul 2026 00:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784851230;
	bh=1882OtUsatNzO6ECKrSoNPT3ltj2l2kRQNMq1cLxwrA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VInGeHuMf+dOL9WihIj2ynvAIWAvGRxj4xf1cpO87KGCv62xbra4Xz7hmdH1oNx1d
	 RCpaVX8mlvhbEYwBhYJCbURGchpSzpoANkU97W4dHmxaIlSibYuOlI2pVYeP4h3Fwm
	 Qlv2LGUIiQN6mXwbsw6LPs2oOQTieBF4ClS9h8QU=
Date: Thu, 23 Jul 2026 17:00:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Sasha Levin <sashal@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan
 Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, David Hildenbrand
 <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Shakeel Butt
 <shakeel.butt@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2 4/4] mm: page_alloc: fix non-movable reclaim storm in
 defrag_mode
Message-Id: <20260723170029.0c076f1fca7677fbf156eaa4@linux-foundation.org>
In-Reply-To: <67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
References: <20260722150006.3848560-1-hannes@cmpxchg.org>
	<20260722150006.3848560-5-hannes@cmpxchg.org>
	<20260722162207.31a2c491ffaf36d1e8948c14@linux-foundation.org>
	<67e1219e-9d47-4a30-a8dd-fdcf03229f58@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1A987C000F
X-Stat-Signature: f93jgpiuq6epwn4m8cqyt1derd3r7cne
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784851230-788226
X-HE-Meta: U2FsdGVkX19O4Ft5ZOIRLQoRHaL44pEtOYsHQUCEUouG8HtVVGu228ME+1NGMZg13lSKL+DDY+sbdM+nBDJy6unXd10BDlDU1rwfo5+4qJQzyj7EuS3mXx9NCOZ6NbiNTpVGRWv+ix2gAG6YzpfJRSy4Lzen2Q0z04vB6tf2fCskXn+p/LIVoE9KlZ6lEC3uz5jKS8oJP91BqnXNUGBtA6dCHPN/8VKrlpN84ahcf0eftxQqBeMLKQvIiq4LUjKcJYrkRcgVqDyUH1lECZoO03TnW4eLB6orpXO9Tlrv9eC6KF0vnh+FAArGSpd3wWz26gPdUSWxyyjYFVd+DRLKaSETivQTLDQzmXLKm//KgrTQG1V9YtiCPaUToefaU27fnlsfrbCDQNsdDYt6lr10dZoQkYu0UjW0rUOteDlcabUDsThjxKV8Ai3nTApt2jKx8o0KGv44Xg9qnnkfd3Sy3epE09jhGDe2292/q1FEqBsBM/iJkw7+cHYLany7aD1oTwyi3Kqwek4JITZZgdOqcFsNTn/IGLtVhKovnVFsy7q+ex68nhFEggsWsKcsirIzCRTyzSf7oqB3ERNqMSgyng/Es9pcRgYStNa2tiozxs7IzRbAbheYdttok4WfeekxODfxshFwCSHM/HqRPFtYWf0ufj/je4ItGS2QBJauRSsJ8HQBctH2J8zf/Ec62/RyMqK51Xyx6zPmWRSur3VHPIyYnHWYYMUErrMGNtFZdaKpFR220Yme6FKMP1Ee9oYLbCM3ZmjG0fET86NcPzEJtuG1UONwYndO738L+10GEkejDJLWzoAWic+4GTuKruKAsQZYyLbhwFLzbmkHdD73TbAwzRhs39JP9copDTuFd3zEnb0M17NHhiPesdoY3sS4K2a8fXUkEiHyq+oPgixB49keToS4O0qi3vHwetBwYY93JXTS3bpEhuoAXC1cps8Bqpqo3GEx9AZaRfqRHes
 S9OqA7qz
 Ylb/lCwsael+j3Y3IWc3giqSfF2CZjwyKppvszpGVXggVdKyXIWSgb3XotkOa/dK5D9LclDZuVIp6xL6Pl7vScHb5rzLOOjXvD4maxs9LiMESruFK6AGaLEvGQEBJ3hbZa34StkoYYoWC+CbIO7yVBprQ/rrzg/utPwmJlYPS8M+Xj+bj0y6LaPIDAzZ71KeOxFmdUEIjSE13UpSLGIVSw2pJkAnPCYFVjwee9+d8pCaJOmeWejApHub0oe/Y17Sdp+TTtB2RbmkriplzC0wQXz7P3JrcW4WUGO0DMWCBa0nKPDyLkQ5Y/s++SjTvM8G21H7Kbuq49AYELD0VlQ/1zU+DKU/KQp0CZFZScB7f0ZVJ/TOsk0jP9Yt7+nB0oYI7FTb7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 23 Jul 2026 12:22:58 +0200 "Vlastimil Babka (SUSE)" <vbabka@kernel.org> wrote:

> + Greg and Sasha
> 
> On 7/23/26 01:22, Andrew Morton wrote:
> > On Wed, 22 Jul 2026 10:56:47 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> >> 
> >> Fixes: e3aa7df331bc ("mm: page_alloc: defrag_mode")
> >> Cc: <stable@vger.kernel.org>
> >> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > This cc:stable fix doesn't apply to current mainline because the
> > preceding non-cc:stable patches get in the way.
> > 
> > This means that the -stable maintainers will have to ask you to redo
> > the fix to make it backportable.  And you'll then be preparing a patch
> > which hasn't had standalone testing in mainline.  All very cumbersome.
> 
> Or they backport the whole series, even if only 4/4 has a Fixes: tag.

Sure.

> I don't think it's necessary, the stable team are quite capable of figuring
> out the deps and backporting them with a Stable-dep-off: tag.

What's that.

hp2:/usr/src/25> grep -ri stable-dep ../gitlog Documentation  
hp2:/usr/src/25> 

> IIRC the
> "fake" tagging is discouraged? Maybe they can clarify.


