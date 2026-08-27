Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE644C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 16:26:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E29C6B00AC; Thu, 27 Aug 2026 12:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9C96B00AD; Thu, 27 Aug 2026 12:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF4D6B00AF; Thu, 27 Aug 2026 12:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1F63F6B00AC
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 12:24:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F4E112010B
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:47 +0000 (UTC)
X-FDA: 85147573014.18.603EE50
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 75953120004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 16:24:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Jjs2JmgE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JJTDJBOO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yFaQVxBL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=S2VO7JQZ;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787847885;
	b=QdDogE+0XRMKWFwSzQdw2w6H6Ve8bPePeEChaSkWT57oHmv6HlIbo//lWgWsnn8iPONhSr
	WFwkBZ1XorVbouXY4skDdEv9YFJP3VhUHFHoH3vXrrG9Zt4zfl1PEnbXTciqmjSLYJ/1lr
	4opfgVWfzgBub3S4Pnp1KmA1jbpVBLk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787847885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rh27INqa2xwHCVt1R3WeNRy936qHTTbLRu7Tqal0mbE=;
	b=nZXem/XyFpbri6Xa+Ih0jydwBfT2EeMnf5hG2f4JzgjhfhEdBoJrWACp7y6TRR7ADrciM1
	ZVBRIH1AzdAjLtst2IGTerN80fS+k99NkWhyQzuI9bVuDnWjjvHNMHoH0Bf8vgUwTNDk5S
	FDTTh4ZPO+fEilzCuGeWl33jX6/0s0Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Jjs2JmgE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JJTDJBOO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yFaQVxBL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=S2VO7JQZ;
	spf=pass (imf29.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A95FA21AE5;
	Thu, 27 Aug 2026 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787847880; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rh27INqa2xwHCVt1R3WeNRy936qHTTbLRu7Tqal0mbE=;
	b=Jjs2JmgELdBqtRjnwhRR6RMvjwxOm/Vt65Pn5YAbv99l2Nj82l8/HeArhnN/26Z4LfGyFM
	mVsmGhIXyPGSthGj8x0rX2ZdQFvHz/04j4iEZh8/UmwVGFDorRygh3rokc2bmqLvcvmm/m
	ge+r8ucvjnnNRxPp3ymjwITQu3EMBV0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787847880;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rh27INqa2xwHCVt1R3WeNRy936qHTTbLRu7Tqal0mbE=;
	b=JJTDJBOODznNlzy6S0DqMKn785KlM+XSkWVXNOTIYz0+jcHbx9u3THcjyR8ugbDS53/sij
	0c3FMlkEEynGMmCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1787847875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rh27INqa2xwHCVt1R3WeNRy936qHTTbLRu7Tqal0mbE=;
	b=yFaQVxBLr71zP7TNiWSMcxQOFvM25RmWNY1xHAVBOrhU0H2myTWD7SUU2KubbXHluD+rW5
	hHLNxvm+gxgRHgmQeilzJHSo9vNWczzOghJ2MziqaIZNNPcTpM+PXJI7YM5RsITllwqlWz
	vJosx5qnoDwubwgYbFp28Wjygpzb/uQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1787847875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Rh27INqa2xwHCVt1R3WeNRy936qHTTbLRu7Tqal0mbE=;
	b=S2VO7JQZ18yiOQ84l+2K2r51yFliJwBv48LleFHEqlTJqyVGP98XPto50X2s6Nq3B0W2PC
	A+QHZyDDmHhaU5Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A72A13354;
	Thu, 27 Aug 2026 16:24:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pqjgOsFkkGoEHwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 27 Aug 2026 16:24:33 +0000
Date: Thu, 27 Aug 2026 17:24:32 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Hao Li <hao.li@linux.dev>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] mm/slub: reduce list_lock contention with slab
 parking
Message-ID: <apBioBxd4VkmaGhA@pedro-suse>
References: <20260824122004.3652-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824122004.3652-1-hao.li@linux.dev>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 75953120004
X-Stat-Signature: ao89j5b64zafeywm5cxwyn5wdpjda3ed
X-HE-Tag: 1787847885-218702
X-HE-Meta: U2FsdGVkX19dLqsu53ZXxpxU56CS9W15pjG6owJkWg3uWjbLfxzB57O3OrVLHCN0ReEfEOhJkVYunHV6Yx2t41wQ6XuziTgN+EHAuCAIyFnqdyl3YNa83rIEAhZ69C+xX5VerSCNtj/heDAVWsIy9pgsH70XLDni/ut3cDoQ0hIZAIUa3ihEdEb2PVTT1BSjcBY/xPpE8npyJMEmg7BMZa/5P+9495bUK6MQOK/Eoh2x2tWF6smQengcEH/LlNNxrdYy8px0qZs5A1e3NAVhIMtaU4B66KYC8MmqsNPSZ2DR2xoIl40xqhCusItkDoT4ACiUxAvzOWFr4ugBt+1rE2ekjxTxb3vzc2yjRgOrR593cdwzrxL3lDmaeatvDXo0LIY8AvT8lYOc5QgsmPwI9AGjI88miAl65wIR808nYjtCOIk8Myx83Y7rLU72wHbpL04oRH0VAQYPhvHGcXIpJWvdfJXLY442VKfPBq0GMUNKtILAqBb1r8qG7o48cLGg7nK0Ant0JNnLY+UEVA4aXymgC0g/BoEBsYfqZlfacTs6ULyuRR4vvoD/a0kvk3KJ3fI8HAtRR5iyakXPNn2vqcDiBK5t97ujZLDl3A319VMIttJ2EuCXQJRRM2XGP3pAM+EeLCfWxFG7awNyYH4VQHSlKrJ+TV5ldWT/HafcHoUUk1lkt0RyWqfrwSax8Cd5iyxtkcFo5gOOeqXU852wyCYov5cNc0Sab47ydYEggnIgw9fHUH03E5KA+7ywWMWM8XdRCD/IeZbd2y7+ZtKp8V8umx5z8D02Nvrh49Guoq6GDN+dOeO880rUimaJ30fi2MD7kvZLe9K5EJiHURVufWdFWzR20Mw/1ZV8ZhvlN25sXCvEJEgVtzuZAPFbEr0PBmezHqJjhvGml9e6JVVZjtAdkr7iism2V+94/3PE0f0xlgBAomyY+XWezSq6DLRhTEpaXJHHc3zod1pENF/
 CgcrnHfS
 7laIr4qu9Vqt6vQ9WbcSUrHGBp110+sKEmdTfkQMBcr/PflN3JEke7tO0li6sTQ2QAjw8YRdgS+pcYIJt4VvJJGnNuOfFGk+vAgTzMju5sfB9Ul2Alf9wLLLU5DZl4ow5zXY1tDnuMAKQWfgEcq2EFXbtB97jnBN5LKEn8nB/ntkk5M6cwOGOBVa+HDu1jCuv0Fj7lxykryZzqg/vH8XX5Y+ui6VJHOE6yTn1JJE4qwgPaTBS9UYG/PMmcRZPO7gNq877yJkWBQxk+s1qm5B85GYEtt+4fbYGoe3rhiFeScZ0vfBtFjrdachleg8AHURyzEsK+BX0SWx24BhLB2TGDKpmDhl+dEopE0fW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 08:19:50PM +0800, Hao Li wrote:
> This patch series might sound a bit wild, but the initial numbers don't
> look too bad so far. I would really appreciate any feedback and
> discussion :)

The numbers look great, I have to say ;)

> 
> On a will-it-scale mmap1 run with 192 processes, list_lock is the top
> contention point: __slab_free() and __refill_objects_node() together
> spend 44% of cycles in native_queued_spin_lock_slowpath. The free
> slowpath takes the lock mainly to add slabs that became non-full to the
> partial list.

Doesn't this mean you're hitting the slow path way too many times? I think
that's the actual issue, no?

> 
> By adding extra instrumentation to __slab_free(), I collect the following
> data for the maple_node cache (in counts):
> 
>   partial->partial    843017414
>   full->partial       550719384
>   partial->empty      17459564
>   full->empty         2
> 
> We can see that full -> partial transitions account for a significant
> proportion, and optimizing them can help reduce lock contention to some
> extent.
> 
> This series introduces the parking mechanism to address this issue.
> When the trylock fails during a full -> partial/empty transition,
> __slab_free() parks the slab on a per-node llist instead of waiting. The
> paths that consume the partial list (sheaf refill, alloc slowpath,
> shrink, cache destruction) unpark the slabs after taking the lock, and a
> delayed work covers the case where none of them runs.
> 
> Patch 1 cleans up the case handling in __slab_free(), no functional
> change. Patch 2 introduces the parking mechanism.

This looks like fundamentally the wrong fix, when we want to find out why
1) you're hitting the alloc slowpath so hard
2) you're hitting the free slowpath so hard

and ideally find some way to tune it properly. Maybe if sheaf size is scaled
up/down in some way (by default at least), according to amount of RAM or amount of
CPUs.

-- 
Pedro

