Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 992F6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79D336B00B4; Wed,  8 Jul 2026 07:16:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E5B6B00B5; Wed,  8 Jul 2026 07:16:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63D836B00B6; Wed,  8 Jul 2026 07:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F0C26B00B4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:16:52 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 98405120742
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:16:51 +0000 (UTC)
X-FDA: 84965357022.29.E2AB487
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7712310000C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:16:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Za4DuOW8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6r1x0ynR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i0hMqNmj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Aj3XLAhY;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509409;
	b=6/VXc5hCFmdX//eSQj3MDC5W21wT3l8vrmzHq6nX4MJuS9GPWzXgR6Cfyx1oGTYS2cfgEo
	aNza1ui62+pW18RDeNUrrgM95pZccfsPw7KFIxcqKzzNu1fKKNXQ2v6vUlS6NuqNsUC+0L
	RckLB5ZGuvcFDSP/pNN3ZlTPME2VJfo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Za4DuOW8;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=6r1x0ynR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=i0hMqNmj;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Aj3XLAhY;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zf0N7hyL9ieefPaK1hQyYaoHoBFLf71w/CV6PNdQScA=;
	b=xZgTm6Yc51UNUxmSDtqKBY6e7b3Nm7kqa6YKX08jGF1p4bOaHeY5qZEWCM6tBKGtpa1Ovc
	vRqoihaYV7IAEwRPfhL3EeqVPhP/PpjG/nqahhCzRhcbCvKk/Sbdd7dXf03ukMtpcuRl+3
	2rBR6O0XGMuxGeYy3ETjZsfSqboO8x8=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D033D759DC;
	Wed,  8 Jul 2026 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783509408; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zf0N7hyL9ieefPaK1hQyYaoHoBFLf71w/CV6PNdQScA=;
	b=Za4DuOW8aViDWdGKSRqUx+4l0Wiat9bfqmZmUpcJU4asPLP2SHTX5SRpROgsQ08eJN1xBi
	qY3On68ubhYOTy4etsXYgv/c32bIZQGW+2iDNmvI4CtOn5ojw4nE2pMXfUJTy8nRjeiYcm
	lD4lqTtj3TUUTUSMzpPF5psGnesq2AU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783509408;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zf0N7hyL9ieefPaK1hQyYaoHoBFLf71w/CV6PNdQScA=;
	b=6r1x0ynRj86u7sQ1VQIc9IRfOk/cBqFF9KRYm+28V22F8wBxU+EUCOncVAtBQ1OtmqH5eI
	EI4VRIkQK9uUlGCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783509407; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zf0N7hyL9ieefPaK1hQyYaoHoBFLf71w/CV6PNdQScA=;
	b=i0hMqNmjGuh18zyd9w7EBeCsH3kQW85vULtgyHNjuKGx+sz2m8SL74PJLqYEReu9RZbtv+
	OMnuopjq1kf3VMNu1oF9xcqtPGRKZ6u6Sp041aF9TbrJvcx0CeAUP5g95t2Rpu+TewoSVm
	38IEf9OIvW51n7bf1Nz5bDcochaADvs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783509407;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zf0N7hyL9ieefPaK1hQyYaoHoBFLf71w/CV6PNdQScA=;
	b=Aj3XLAhYXjGFu1orWSrMrTIBuRA+FR70+NILNlEteFudv028P9a5xA0UZdzNJLRM8qzlKX
	KwpBM+z5LjKsQABA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E0590779AE;
	Wed,  8 Jul 2026 11:16:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GMK9Mp4xTmriQQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 08 Jul 2026 11:16:46 +0000
Date: Wed, 8 Jul 2026 12:16:44 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Paolo Abeni <pabeni@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-hardening@vger.kernel.org, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>
Subject: Re: [PATCH net-next v3] net: skb: isolate skb data area allocations
 into a separate bucket
Message-ID: <ak4w2k4Woj55E0On@pedro-suse>
References: <20260702170728.168755-1-pfalcato@suse.de>
 <04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7712310000C
X-Stat-Signature: omdp7p8oqbby9jhf5ganf5gj7fh8xj5d
X-HE-Tag: 1783509409-669302
X-HE-Meta: U2FsdGVkX19/rLoS1q/NRoKO8o8Zx8JXDYihH1SVJ+S0gCFR7ZKKX1VKwJSO9BeEIve4WrfTI6HdCamiGnz9f0oJdo3mcYyLpB3W1z780dMovJdtfcLjKEKcbWTAf+ECHI7O0+tIculS0vfEV1x6zPXzADOw97TkLm7ucNYPXoNJlgjM4/XRZD41CG4hVtt/Pzq77qvZqobdMZGixF7bZGEE4xt9cxIzHWzn4jZ4LajkLyVCmO1fSvQ+kMZL5HGVOSZ4F7Kk+7UPs8hWisWJejmvCI6izU/YeMKMDQvGpwfU1O37zxMU6zpmBBOORGCGskKGFffawI8cGASrV4itnmOie3fNduKEaEBoKv91aEtDp+QFUKtDLVPyPzaybtcn6ppth9pXC3I2vDu1AYpswXepVfuhmVAFsBuZ6bFK2H2p7sYot9ndrJdBCKVWroUmRCHuMDheRyWhQDjHUTNy1pLbiLR5ScdOJbNDaTd5LLEWvC0w4A12Yl9DG+Evv/umm9ZcafO/W39Ufip6oVIVpIzggnAdGgNi8FD1yuZIifoa6HYKwSoK6MpvkOxAjke2/kh1kDuqlFkw6n4au8dt+AUqwgkl3qtnnt0wT6JJfbon0vI0IHFLGTRC9qjD4UykYS/2ZAowsMCTkZlgDTcUT3Mk9bt8NkD5OuzxI0I6xplGX3SLV0XgODHTn7WoC241lgsKyRLmXl5QbN6RaNTEJ8ILgq2oktaUFSOcqZ+cYEFHGlYSkejaayDe4Sbm49prqOAXXfVYxmPkPTVt1hN4Gcu6Ts5T3gW0lpCHDctJQ5MGyan9NyaYQEsqs770//4LR8nb9cEaU8G33F11pNu+e+Zrl9FDpkK0Bm6g9RzEHsDKQel0ElSqH6I/2aSNcrGV01hgG4xpUXTx4RQ/wRrcuCLF6uHutH+DJ63v4/c3QPbc86oHk6ac7Jg7zmpNZsP6KIHQ7VR7i8NRzd1dzw9
 1kY3DU6N
 C93KJYPvVZxUya6n0fTI2ejb82WwW5iHoPaLobPkwfifut8gK4ihv1TQcDa2QznYBf97e0Y2tDCyYEw1ZS26hg350c1VBnM8pHh8ZXRtzcXQfgVxMyzpCVzEmDhbPnXGRt+v7JNrs2o9YKNrWiwrHsqmV+kihkY/3N49v+1TFhEC+EfIAf9jFPivPe5UNuXMNUnKvtXiinqfFvNd24GLVR95rZlwDwU1rF5JS1Euez8a72tXE65a1FxJpH8Sz0p3FA0jW9H5UfTet+gxwCXkJdJNE88MWeU2Gza28e0LAgnTJ+cdxVts/pAkXJ2zFdcessoIkEWP2e5GR+Dk8nnWkHT5/OwuPmoYInt6rAJFog7+IqQ0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 08, 2026 at 10:30:50AM +0200, Paolo Abeni wrote:
> On 7/2/26 7:07 PM, Pedro Falcato wrote:> @@ -586,6 +586,8 @@ struct
> sk_buff *napi_build_skb(void *data, unsigned int frag_size)
> >  }
> >  EXPORT_SYMBOL(napi_build_skb);
> >  
> > +static kmem_buckets *skb_data_buckets __ro_after_init;
> > +
> >  static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
> >  {
> >  	if (!gfp_pfmemalloc_allowed(flags))
> > @@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
> >  	if (!obj_size)
> >  		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
> >  					     flags, node);
> > -	return kmalloc_node_track_caller(obj_size, flags, node);
> > +	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
> > +						    flags, node);
> 
> Sashiko noted that some drivers may require GFP_DMA buckets, and the
> above may break them:
> 
> https://sashiko.dev/#/patchset/20260702170728.168755-1-pfalcato%40suse.de

Oh, this is really awkward. Adding linux-mm and slab maintainers for input here.

Considering the current slab bucketing does not seem to duplicate DMA or
CGROUP caches, could it make sense to duplicate those as well? Otherwise we
could add a branch like:

if (gfp_flags & __GFP_DMA)
	/* use the global dma kmalloc caches */

> 
> >  }
> >  
> >  /*
> > @@ -634,7 +637,7 @@ static void *kmalloc_reserve(unsigned int *size, gfp_t flags, int node,
> >  	 * Try a regular allocation, when that fails and we're not entitled
> >  	 * to the reserves, fail.
> >  	 */
> > -	obj = kmalloc_node_track_caller(obj_size,
> > +	obj = kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
> >  					flags | __GFP_NOMEMALLOC | __GFP_NOWARN,
> >  					node);
> 
> Minor nit: checkpatch laments WRT brackets alignment.

Will fix, thanks.

-- 
Pedro

