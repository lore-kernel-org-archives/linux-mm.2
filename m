Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4794CC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 16:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8F6E6B008A; Wed, 14 Oct 2026 12:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A665E6B008C; Wed, 14 Oct 2026 12:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A4306B0092; Wed, 14 Oct 2026 12:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC4D6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:06:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 18F1380644
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:06:07 +0000 (UTC)
X-FDA: 85321708374.16.EAD8331
Received: from mta0.migadu.com (out-53.mta0.migadu.com [91.218.175.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 01305160007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 16:06:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FwaBZg2e;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.53 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791993965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/He0bb3H4CGOph8A7SkplED41TN0wj18so725QxgLo=;
	b=J0+pQZoYtKJGhWsYXK7sqlmJJPh3uU/WHQeR2rV/G7/rytdJDxwqmYzJasxU1ICPA0c8J6
	Y/Ulz6MaVu0pxCPm7HEShkJLG+0HljSm+ymbaQpwyDE3g8qtVJrq0I2efMa3JOMC0sQs8G
	iMdlyey9mZwXl9q5B67gmKHkWMHHia4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791993965;
	b=0tfGfmKCEig2DOw3XEwHRi/DcWv3uzcBXa9cDoE8uAkHo2Cb6FW/8X4T7KH10tNvmJeFd9
	HOsaicPPanvs1ivpT/xlnUa7gC+MtsSM5vzGfFT13K0Zu3NYMaqVJe5Zu2JkoxRb9iwTL0
	8rf7jrNK1IVJd1PF52FDvrbT5G6XDjE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FwaBZg2e;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.53 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Ke8/Rh7e75umDrgNFQd+uBhuuNnz5z+dEUkUPgAImPk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791993963; v=1; x=1792598763;
 b=FwaBZg2eq3VhmsBTg9fp+TgUc+hVxRwtrbL08KUSyDZQz+t272ehLbGesowe40gOETm1o+Lp
 0KjUZ3KdC1ZZGEksiLNdmsd51PUT0KA/FHqHhC76L5Lwukg1swCXHX8ihGcLHhFyQbm7Gs9/5bq
 uCCFfF27YeICVpirSAdsS8Xw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cba1a5ea51b66b58;
	Wed, 14 Oct 2026 16:06:03 +0000
X-Mizu-Trace-ID: cba1a5ea51b66b58
X-Migadu-Flow: FLOW_OUT
Date: Wed, 14 Oct 2026 09:06:00 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 4/5] memcg: avoid queuing high_work from reclaim
Message-ID: <as97Nzob4XuzO9Ss@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-5-shakeel.butt@linux.dev>
 <as9p2uFqCQprwdnI@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as9p2uFqCQprwdnI@tiehlicka>
X-Rspamd-Queue-Id: 01305160007
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: uj4izj9esx5fduedu4ugntmoskenfwo1
X-HE-Tag: 1791993964-481333
X-HE-Meta: U2FsdGVkX18ERlz0xE4MXogCS9ZihX/2faIOmaQLj1+wkGg81eNlFo1MpuLOVgvxonGCaIu7+eP5uVDDSi57QSXLKkRc0LZLL1TLoP/UL+NeDb5hIR4LuEJ676+Jv8L9ehzMib5VfvGALbekUz7gcrTI4A3eWOSv+mJQwHvY6SP9Vg//ox2EHPyoGMZyxpOtl0vzeqjs07zStbyim+QXTv6k7xOTwEgAgz3n424O/ESKvu2WYaf066AZVbapXLS051Zjrjl1j1pN7PsKsEAjOv715T/JAIJqFE/35YmgKp1cXP59eJM6yO2eevW6q4Wf1hdfrc1yy9lNgADRzEvWyiK18bDTrVUN/L6uCXe8qPfQDpeE2clQAH46uieqo6O0KJfIvJdM1gv/Uht0CGO3y+PSwcPC33tvkQSdf26dIrhKTDe7E+K+JikEMtukdN3sHS5ILbEXjAinqoIn7FpFW45Uc1nAZFmrySHG1aqjSflUaXkTBh5/irD/7gVNh14hWWWVePV3N8W+WNgdGierJnspitsaFblOsTpKvxB3Cdqm4N1Qfi5uhfc3+rksmXalER6e4a2cGJM6nH9lRw2DPgZIHlbKm+pYaYxrp/F2f7W9rWtIQx/Ew8nkmd2/2f0mS0FmYLtTUrkPm+bUbcL1lrci4HTTP1dCZkVcD43DA58L9djpNP1RSodQpVj/tydLz9H5/aD9HmZyhv63vNveDv16ttBxZRh58z1Utp34oPeAkWgPTgbyFldqBbPdZUOsN8HqpyZ/FDPrL98hoRimg1SdZnL5KrQbjwx3sccbil09+s6TCxJlJw00RU0q1WtJDZi2Yx40c4whjDKJrszJ30sCsav+VKH1o0zIebF7Ug0yA43RSFZiSxL+b5YmdzyZ1IBBFavRu77L/ZGD5KYT4wVeahqTzh3ChSLarUuUDNGkyvnW1dx7JC5+3QnTF5R4tPe1wCFZTxujORdIVK/
 H8+eEVCA
 z2ogVSaL0JCqFGTjhfbpzNRax/pbqq5cRG4MKhIH5moVikufWDCOw2mpxyef+yXjQpbslirDnSz4xHebMcn6lpKrMqLGwndgGINlu8DZyYweHPJqDNTo/UAvLq0qqgRxwzVj6BQnHN4j/icwjxD0hcG1BRKGhKedUr3NoS6Rn86qzgWbl7YepsNDjkTnKZeCyVg8Om8YQjlQ25iabXJsLouqIVfdtdZJ8meR/tWoiprkVQX5WFN+qQN0hug4pN6E7Vk6xVHP0mBOfGZ+iuP36VEkcI7RyT8eWDIMKX4307Z+qUPfHnqppHojR+mnV3ftcuDXF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 01:39:06PM +0200, Michal Hocko wrote:
> On Sat 10-10-26 14:09:56, Shakeel Butt wrote:
> > Kernel threads and remote chargers use high_work when memory.high is
> > exceeded. Their allocations during reclaim can also charge memory,
> > for example when zswap stores a page.
> > 
> > Without a check, the high_work worker can queue itself from its own
> > reclaim. The pending bit is cleared before high_work runs, so each run
> > can queue another run.
> 
> What does that mean really? Does this delays the actual run?

It will not delay the actual charge request. This mainly means that we keep
enqueing the high reclaim work even from high reclaim context and can
potentially keep wasting CPU if high reclaim is not very successful.

>  
> > Skip memory.high enforcement for charges from task context with
> > PF_MEMALLOC set when they would use high_work. This covers kernel
> > threads and remote charges. The memory is still charged. Interrupt
> > charges keep their current path.
> > 
> > In a VM with incompressible zswap data, the worker queued itself 163 times
> > without this check.
> > 
> > Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> 
> The patch itself looks OK. I am wondering whether we can unify the check
> with the existing one which forces the allocation through in main
> charging path.

The force charge (and ENOMEM) paths bypass the memory.high enforcement
altogether. Only successful charges (done_restock label) goes through
memory.high enforcement. So, even if we move this check in try_charge_memcg, it
will still be a separate check before calling high enforcement function. I think
this check is very high_work specific and better to be in the high enforcement
function.



