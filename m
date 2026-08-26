Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB1D4C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 12:43:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACD476B0088; Wed, 26 Aug 2026 08:43:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5496B008A; Wed, 26 Aug 2026 08:43:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E2556B008C; Wed, 26 Aug 2026 08:43:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E3806B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:43:31 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0D4A11202DF
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:43:31 +0000 (UTC)
X-FDA: 85143386622.24.F98270B
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf27.hostedemail.com (Postfix) with ESMTP id B21EC40012
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 12:43:28 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ovJcYHDq;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787748209;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOafpWk1uqTzp7/09OYOrzFz6lOilpk2D9E27kir2wM=;
	b=PLmCCqDFFf0VH1ozliqvWOtuFDAVKK19VCPRK4qI5nDMYxvKRnq0GlMwG+CIzNfbM62tPg
	IMoC63A4mxPLypclDaTxvrHOwkkpThGMaZKF5JRpHc0/nG2u9Mq+ULtGbQUKMcM9mjX9Ej
	WgP3QAQGEiOqfe/XcdQm3CowMX6xgos=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ovJcYHDq;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787748209;
	b=7rpq4i3sDZ71ROAYXAA1MHwVuftzIFawS5pFlu/Kj3shjF6BHvQXZ6v5UWwbDYmjPGAvUN
	HfntZ7qJmnLzJZZ455ZB2hHbiJviNDVnKC285UGaefpepXsbiw+dK1gi/v8wwnJTYiugSG
	FXeb/Iz7wpm/80aotXPhSBa0iK7ZFco=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=dRZqnAdU/1gz1hPYT2CpYwf16xguN/jACTpU56xyZJU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787748207; v=1; x=1788353007;
 b=ovJcYHDq/FfYj0Sj1AhiiyajwpDFBztEaVQc5xIjID7nzj6T4GM3ZWPkO3f9phMIhsXwqSGi
 QQEm6rFhOm5+QmoB5/rl4QGs3ut8HcC1wTonEFLHwMGzzLZnsl8UY3fpb9Q14UKv7hU3jbCFQiG
 Y3x7lkcUy2kMpbl+efFeJda4=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id a185f76d2de5e8a4;
	Wed, 26 Aug 2026 12:43:27 +0000
X-Mizu-Trace-ID: a185f76d2de5e8a4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Date: Wed, 26 Aug 2026 20:43:16 +0800
Message-Id: <20260826124316.80455-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <ao7Nr_FALfP7cTY5@gremlin>
References: <ao7Nr_FALfP7cTY5@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1xg5jgg4o7qy75d9gsqkwu553obf5s6w
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B21EC40012
X-Rspam-User: 
X-HE-Tag: 1787748208-44158
X-HE-Meta: U2FsdGVkX19YZQZOypTETRLeoESrFoMNsoJkLjjq2TXbO4OyfG4YVNeDUz538aOmpYkE3mX63VmB1nI/98AvhdF84pOkQRce0gIgms+lues+1FE8DeJObVWGMR6piignfhaakj4JHTb9EWn/CHR6noUuSeAojSN+dAXfvz5diWpUsL1C16sBBQYXHgUyxuCsJFvLG9c4/3CYU77bZLfQeUp6RSJlLDyb24JcLhKNMqLH/52Ry2SFAkuvcP5erq78STGPNbuvUTeRcPrBEnxkBBKIMC06Kunyp594awBBQVc4lk917KAMdjvj8kHcLHmV9IwbbafnPDrQKgWU+NNui/cgAmvthfKRd2mUh7aSwTwUfmyqC2OmTYBJ2XGupCO3Ob33UxFiXDHGZTpkLHSSi/MkTfu+z2+dQOSQRQ9C39d6tZKhbBoQQ3NKxCv3WIaQtZ+fQ4wT9L7AbltrxzcgxYYT8NJMYcDoKrbm3qKEhR0AWhz+bwVi4BpBALLhKL55y/Dvv8ZoMXytujp9UpPWSGprkvndRC3qnfbvq2ps6pBi4PVgPRucmQ/tc4UA3oWSy2S0DBdRqbd2O9GERfpSizOQKFAHMzSSi/xrJbTfOfFPhtF/QTqCbhYS1T+12EX/gCNkja/vj1zY10XT3+fzJ2upz4LpMH5Im9nhcPPysMBtykg2P7LtcxqNNxaQ4s5krfvwgcQWquzT1Hm5ZInpyyzGkIk5zekQ+JIhTzHr6q3Ugf7FpBb90hHmXH63AWFpqt0l6jlP7jXGNpmjcECfyyokVvvjrNW1wkLh7BYaRN5Y2YuP3v11P/JCSDObcQ+1iYNndAMFlkHFHjsx7RINHogCA363NW/udmIiDfjLoxNLydXDfkG4uldgfsrZynBsdv68pYWgml6jggxV7rQDY9yIp1eB0j9PtCRWE8XaU/Yjuxt+gnjCa7Hz4rAO9IOdC3HGuH7RMMK9/9fmDBw
 ClOfSjrw
 hoLqLAUzAl1lnUPH0M5KR9jSvgZIcC+4v+QmTVIHGQhVtuMYs3w2+7zSU5zuG2qvjoX2vL0M8YXRf6RmbkrUjr3+x840Nlhe9+X8KlKnUBCBvntugIL3a5of1taEVf2GHg7pR15F5oq0XhJkhnKtjvbzeE5i8BhZbSqTCUuzLol+V8v8t+nww6N/KEIZrZzTDyHBq43NVYDZlHqmaiXyH6hnzvQd+1aikXE0QkZI0XJlBOxQYOoHMPuVKBzZwi1/1Qk2JSvty73fsQJn/ZORKGXs2fM0HvPAx1Ogumh3qeF07wuKgJ95hV1yfTw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Aug 26, 2026 at 12:31:09PM +0100, Lorenzo Stoakes (ARM) wrote:
>Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:
>
>	~107,000 words of review across 948 emails (in 279 distinct
>	threads), counting only prose you actually wrote — quoted text,
>	signatures and attribution lines stripped. That's a full novel's
>	worth of review commentary.
>
>	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
>	and your longest single review was 2,404 words (mTHP collapse
>	support, v12 — the khugepaged/mTHP collapse saga accounts for most
>	of your top-10 longest reviews).
>
>	Estimated review time: roughly 300–500 hours, centred around ~400
>	(i.e. ~7 hours/week for 14 months).
>
>	1,615 THP-related emails in the window: 948 reviews of others'
>	work, 278 replies on your own THP-touching series threads (~31k
>	more words responding to review), 382 patch emails, and a handful
>	of MAINTAINERS bits. Busiest months: March 2026 (131 review
>	emails), June 2026 (113), August 2026 (111); quietest was December
>	2025 (5).
>
>Think I can be happy with that!

Aw, man ... I totally get needing to step back, but we can't let you
disappear from THP that easily :) You've put a crazy amount of time
into it, and your reviews and judgment have made a massive difference.
We'd miss you badly.

Could we talk you into staying on as a reviewer for now? Zero pressure to
keep up with everything or carry the maintainer load. Just hang around,
jump in whenever you feel like it, and come straight back as a maintainer
whenever life gives you the room.

Seriously, Lorenzo, THP still needs you. Please stick around!

Thanks, Lance

