Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73A31F3C24C
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 13:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 936A56B0088; Mon,  9 Mar 2026 09:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E4366B0089; Mon,  9 Mar 2026 09:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EFD76B008A; Mon,  9 Mar 2026 09:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6B5586B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 09:10:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0C4013975E
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:10:46 +0000 (UTC)
X-FDA: 84526559292.03.E63F093
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3411040011
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 13:10:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5PSGon+;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773061845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YtYIpxat1ElHx86bDoqDQrXXNAbz2JDZAasHWLs3Zqg=;
	b=hy1JTVQ3Sqf7cOLFchuNKHp5cZ5lSOjjLRcBjbvwA6xxjG/+3doStdFlTokytD8bbHEuaZ
	AS/VeVdq/V4bQnilsC40s33Tqrxvx337WdWr7Es9p7/Ht8F2F9IVh3WG4aBHyDDm18v51b
	3ZS0Oy1FRD7qyV+D62Ji5XDVfyqr5GY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773061845; a=rsa-sha256;
	cv=none;
	b=tDO6fA7H7KJT18UTl8aryzgCuKo6KbcYAZzdFKzjQUmDprOYzhdGXyW88FgnpyYXextf1T
	nre9GgwWFQGPDafszEsizLVLVb7pR7GiLK6K29Me4qWqd/r2A3nhH577S9HvtDZaN+kJpk
	o+prwbieZffWagXpViiDANMA5R+mqts=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X5PSGon+;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 847A360130;
	Mon,  9 Mar 2026 13:10:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98142C2BCB0;
	Mon,  9 Mar 2026 13:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773061844;
	bh=YtYIpxat1ElHx86bDoqDQrXXNAbz2JDZAasHWLs3Zqg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X5PSGon+CiqxQ1OSXzmZMcEp6SNKahmRdaXQn/eDa1aRx8nrwTBiQxSFAQJTcb+Xz
	 EnIbzjL1uDYBfurn4CRlDdkm7bZK+XX+tlbsooja3Yzzy+/dMp3V2lv7qke1HYAP6Q
	 fH1+i3/myaxlrf8S1kNeO47F0gSUjKgU6zegwyuZt9tx9b/nzeJy3uBim7RtTw14Qg
	 mqOpaq5KyaKHgAmh8deL76ylLeaSdJx4oZCxfVai5GpMUUVhJzAdb6efCVxvwV3QAS
	 gWrdCuvoQ9MRkuVR2tpa88AL89br4ll//YClQtyjSDIiDJLbzFar98ExwWnr1RvvJL
	 UKxx5A7JAObxA==
Date: Mon, 9 Mar 2026 13:10:41 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Matthew Wilcox <willy@infradead.org>, 
	Suren Baghdasaryan <surenb@google.com>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes] mm/huge_memory: fix memory corruption on
 huge zero page move
Message-ID: <aca15b45-24b0-41df-be16-211bcb94ec79@lucifer.local>
References: <20260302170619.867056-1-lorenzo.stoakes@oracle.com>
 <901fec30-c5c2-46c5-b48d-f9a8f5e5c928@kernel.org>
 <f11357fa-29ac-436c-a9a9-8406f516ea30@lucifer.local>
 <20260302125032.313797b0ec908cd133f3ed82@linux-foundation.org>
 <a1e787dd-b911-474d-8570-f37685357d86@lucifer.local>
 <20260303174226.1b9079ccd60164fe0b28a3e1@linux-foundation.org>
 <c4d29d08-50c3-46f8-a9ad-95f3ce552734@lucifer.local>
 <aaw-8SNI6FK14yxu@chrisdown.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aaw-8SNI6FK14yxu@chrisdown.name>
X-Stat-Signature: zwrek7nc5jhshzcdin9g6pj9sqi34cp6
X-Rspam-User: 
X-Rspamd-Queue-Id: 3411040011
X-Rspamd-Server: rspam12
X-HE-Tag: 1773061845-321239
X-HE-Meta: U2FsdGVkX1958V9JlSjGq6uE3FhpnqRZZYqxRABR9w7A2jpPREV7JmcPFEmqbSdgYo4/IMsSXqbW2xMcoml9bEk4dVPhbKwYHZAL/xMIc2rWfSL7O/A4XiK+fmZ1/i1bjMUE2lfxlLL0ENy1mEx+Rq6JDwsoGpR83aJiRs74x2ds+ezlikZlyjYFHUyEwF1bL4NPIiWiAIEXxSwMYYQ8cUOwHOhfAZAAbokVXhMO1YeaCw1K9N1jNeniXRZkXpOeTNELl0/SxILkT/6hasjjxzkY7urrW6sLcEADT16C8f+T5+tGDMQEQS6g1gL3tXXWxoA6EMwJTvA3PyJ2UFBA6sbvdvn/bNGP4xA3V1SKPOAf/brC+K/NCR2GFU5xhL3GLcScDJZWYhBe9warHCYPQ3KMTQUlaw6Tcemq+N864otj+v0Vs0Qod6XxTQ8z5g39lsPqr5WARVWBkn7OhTYJe7NZ1v8YYOea3HUpQVKMWMf+13YxWvhQXOZwvevSQziO0xQZ6+xKBBrKOF3BpuzKs+qxGWJQZ/IdHjZWyeZKTxFcWzaAk7CcpYN8+9pNHXsHDxEPe4Jp/h38okgCeErrV29UU5c5zYG/sVo5L42yzBiJJnXWHWPY2rGCu3LZuJZDR2p/MOpiz6JxmeHe0DfbEFJS5HvaQkDxfb5Izrk3GQ5nY5+dRx74lReXtaUhImkcI9aVFmG9BmVL4FI5z4Jgq4FeMpNlodkStQztEFXfUO8dp2NAnMPWGlcujzrz0aIlG0ERa7SDHA0vbIHZfW+GrsQK9Y7iypXuxoRu65h8vnSscEwJoFZz49n46UkbUytP3/C83g/XsX/SI9cHJ1qlJVNjH/vbHsIBargzYqz0rIYo8XO+lupjEw6WKTsxQgsI9P1SIw5nFfpsoQ9x2fET1NdU9zNRyjI//CoLAROKf/iTQt4xnvr6ijkMWtA9icRTxHhfZUEH5+nDzfL64vx
 7WrPX4PT
 aSK3Fmn4DVrw4GpN/GIzKFHyQqa0w7w+ipft/qlULRSGItYGxWsqXXMCQ8PU+jedeQWyZD+arDAR3TooN7d0ItRMbwi9QFXDE7rIdnp2MNEB79T078FGdEYg9oCJ32iBI4PxUmiAvKEOSdNVnUSrr1VlVxzrGULd419YsMwOdimIhTP5+dLlIrkO2DYlcaFk9m1OhEC32RWA1wdJoao7/PhcEmKEGhcetP/2wHtFx5yGHTiQJhBws2HfYN4TNUSqE8M8SbXzHTYDM/ME=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Mar 07, 2026 at 11:06:25PM +0800, Chris Down wrote:
> Thanks folks for sorting this one out, and my apologies for not being more
> responsive. I'm in south eastern China in a remote area until tomorrow and
> don't have internet in any form most of the time. The end results looks good
> to me.

That is a... very valid excuse tbf :>) hope you're having fun out there!

>
> For context, the reason I originally split it into two patches even though
> the second supercedes the first was to make sure Fixes: can match up to the
> right offending commits. But it is true that it may not be important.

Ack :)

>
> As for the threading, clearly I haven't been using git format-email enough.
> :-) And my apologies for neglecting to cc folks from get_maintainers.

Thanks :) sorry was probably overly grumpy in my reply, grump levels are
variable during the day/week ;)

>
> The end result looks good to me.

Great! Really wanted to make sure YOUR patch was the one that landed correctly
attributed, and of course to take into account the feedback from David, so I
think the end result fixes the issue and achieves all that.

Cheers, Lorenzo

