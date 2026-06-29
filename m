Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB940C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:35:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A189B6B0098; Mon, 29 Jun 2026 08:35:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C9496B0099; Mon, 29 Jun 2026 08:35:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B92E6B00A0; Mon, 29 Jun 2026 08:35:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 68AB56B0098
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:35:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CAB3EC3320
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:35:49 +0000 (UTC)
X-FDA: 84932896818.04.8C0AF1B
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf25.hostedemail.com (Postfix) with ESMTP id 68B6EA0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:35:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mamFXK5l;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782736548;
	b=uouohdM5bI646OfuVucUpcw9ILHeOpNsc7XxcAMWKmToOIbMQ/KvSubfdlWy2TW2UjSHfe
	pbDYXCfiHwpPVnN2axIKKZ72nXAhq79bucV2Bc8JlDzLEQssMQmMfGuYuMvdZ8t+iW1uPk
	ZPL2MesvQC3QRMUrBQ899sI+qnSJNhI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782736548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opehZDGpTitGHCW3KLQ03Dmka13u7l/NNBz83U1Ssck=;
	b=PYo2dNjKf1mN+Fk1q28u069896ZD68ooXRDrm42wc4Dwyo5uVZEwd9Oulk1xqwoZEhq0+R
	nQVXZ2SbDNrZbaamcsZtbUZmIZDmn9P5TTLIbFqc1jCnDA2EgtzIfKsnWQR7HADkeDQ0+B
	y+LQb9VQOfcFqaPNvM0iXHNZZIUbnhw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mamFXK5l;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782736545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=opehZDGpTitGHCW3KLQ03Dmka13u7l/NNBz83U1Ssck=;
	b=mamFXK5lCyd6VO7MKQp7ZipL78nOeRCOVQ7oELE4VpvfjQngRj22XzOSpN27NExPwzsrlc
	CSg3QI1rZxXFoMoRrROhLB0slZxnkq/HX1+2RBWwr7wiabUjoNyB2qodXv3F9ktXopMgV0
	HOFEnlRgZaAF2vZXRSwMjLj24ueZjTA=
From: Usama Arif <usama.arif@linux.dev>
To: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Usama Arif <usama.arif@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	linux-mm@kvack.org,
	hannes@cmpxchg.org,
	tj@kernel.org,
	shakeel.butt@linux.dev,
	roman.gushchin@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH 1/2] mm/vmpressure: skip tree=true accounting on cgroup v2
Date: Mon, 29 Jun 2026 05:35:32 -0700
Message-ID: <20260629123535.1663050-1-usama.arif@linux.dev>
In-Reply-To: <ajzuUMLm6ClyRVPQ@localhost.localdomain>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 68B6EA0005
X-Stat-Signature: xuqmyoh4dobtm4ycmdda1f5q1iaiq4t9
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782736547-631994
X-HE-Meta: U2FsdGVkX18r8QTf3QDAcx+A77PVENdyEus0ApTfBhWteuWnLSPaVmdfR/HoQCuHNHj02gnKp04+9+NEsLIU9Pwj2uCy2y4Vvq+sFPfTx0DsgS4tEhfFFU42LtaXFaj+esp3ih5ZfP6FU+FkxCl6Q8H6jJ+FZiKjzKyM9ZkVPVEHg/v+En2yMs+Je/Q6EekIe+u1k2tkoBv9uDglEOi8zEYVpmSc33JgatQNiCPevS632NSPgQ6nmD4vuROxzpDOUUAnEdFb7F9VN0oXwCvbUn/n3tq+hSsUzt8mCje7zTmOLuwLRaj2xDWrdOA///mo+ohWGIBmRmbqXpE2iXulRiqrq99FGKyjs15YEGN6dY0RxR2PjBtDBhcfdiGxZYmrOH0sW8Vvs5TMSz/fqQZaSHmszys6nAHFbUpSSAV862ATW48QzlzUVZn7G4NERrXWPpgUD61oO7lalksdJAdKPeEbBMSupTINhHp0YoPL329+bqe6z4mD9oLaLvgjwLqSmsNW/FijxGxjukzoJkHvz+3XttxAM67jn7u854lM+MR5RatU9S6NxjqyyhUsqXO54l8zJ6XUCrirhmhK+FImClzcEeHtJPpPEQY8kg20WGmsY4BRMXLOVrVAVZ98b1MhykOnWwha0n1mMSl1a//dSIsC/680I1Qvy7PemvGq3lgA/bJX8uHA3eZ2Ti3tpyGcqUdOdfQNnLcATIEgSDzOi6auL+pBMh+MjDxt+Y8zFPZRYG5Mrnea/bm3h3TNwiuZpGCXcbD7gNCIB3+LjpeVIwgYVvn9twJV+qK/uM3MjPO/NCzCSUPtvU5czPI8Op98HoeO1AkSkhphL5ESyuQ5RbYvZDtFJBkbib+90xaYIkHCYiNsuxA0NYBcbgOpq1SKxEKTEuqsIgB3KOjWpoyMEJbHCI+NPqglAf69jO0kSPbywEHbcQ3wiwS4g96+nshosUouFZR2WVVaW66lx2C
 LECEbkyX
 3aApjzOxpNG7+ClfRxkUg/GMryqkP/KJFsxVoTu9AbEBhstBB9Is6dmw9udBJrc/W6jhcYC8pICYUO9C2XIw6MsLLEQ1qhqPcIO/CwucoCLqRI7ExJMy2ejNGaH0ZIrEe6QIsww3ylOldvrvZ9oA9O66DXMzWodJjY4H10O7Gm6ZPYMpvyPumsmVCiMqLyUrSsVaKvHPk6DBM8o1ZA2hZ4ZcesoqHTN0sAhtGt733yK3MYKwM0+Ni4wamGPRJBRo/ona1rUl4Avn4D6SMxSLA9X8hy7J2y0p2bjPnHnkJ6X+sYM0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 25 Jun 2026 11:04:15 +0200 Michal Koutný <mkoutny@suse.com> wrote:

> Hello Usama.
> 
> On Sat, Jun 06, 2026 at 04:41:33AM -0700, Usama Arif <usama.arif@linux.dev> wrote:
> > --- a/mm/vmpressure.c
> > +++ b/mm/vmpressure.c
> > @@ -246,11 +246,13 @@ void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
> >  		return;
> >  
> >  	/*
> > -	 * The in-kernel users only care about the reclaim efficiency
> > -	 * for this @memcg rather than the whole subtree, and there
> > -	 * isn't and won't be any in-kernel user in a legacy cgroup.
> > +	 * Only two combinations have a consumer:
> > +	 *   cgroup v2 + tree=false -> in-kernel socket pressure
> > +	 *   cgroup v1 + tree=true  -> userspace eventfds (memory.pressure_level)
> > +	 * Skip the other two: nothing consumes the result.
> 
> This is a good finding, I had some troubles convincing myself that the
> v2 has really only the memcg->socket_pressure. I think swapping the
> order of the patches would make it easier to comprehend.

Thanks Michal! I realized when trying to swap the order that the splitting off
v1 commit will end up doing more that what I think it should do (just splitting
off v1 specific code), as the tree = true code will not get compiled in at
all for cgroup v2, and it then ends up changing more behaviour. I am sending
the next revision with the current order, but if you have a strong preference,
I will respin with the order reversed.

> 
> 
> Michal
> 

