Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56D4F606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 19:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eumAA3k4
Received: by kanga.kvack.org (Postfix)
	id 3BA156B0773; Wed, 21 Oct 2026 15:19:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 36B0C6B0774; Wed, 21 Oct 2026 15:19:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 281F46B0775; Wed, 21 Oct 2026 15:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 00F8B6B0773
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 15:19:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6AD11C066C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:19:45 +0000 (UTC)
X-FDA: 85347597930.29.849524E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id B785640002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 19:19:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eumAA3k4;
	spf=pass (imf12.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792610383;
	b=F/Jrw1lP73XyLFtb42FRWxWRToulESkhMIRetR4eEMnZIGEFP1wnhHQ8QMgyO2tHqqfu0T
	JzOSLUxxNPyDd017ID3bT7t6E9MkyqjfWyHQItLL9pgsW9AdaU6NKeqw5xcydAB3X5Ffj4
	58UYjkrS7YprLMDGVR/bCwhZk39CEag=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eumAA3k4;
	spf=pass (imf12.hostedemail.com: domain of kuba@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kuba@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792610383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WKM0XORuuhLQvH0dOGvlGgJrze/6esCqKxEQFA6bgwk=;
	b=iXtWESSquG8nyQTRpFbnVA3uCMC3wZEfTqhrqrOc/ZRfu6J27TDovivphyecSyWD8648Kq
	UkIopRCSEq4d23JsBA7qzG3InQL6Kc2ne/WuSSv7nQcGR1HRd/2HIXAE1KNGMdJydDduJW
	PPVvKS8W5aH82rJiCEZwz/omMuOX8q0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEA0F43DB4;
	Wed, 21 Oct 2026 19:19:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0185A1F000C1;
	Wed, 21 Oct 2026 19:19:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792610382;
	bh=WKM0XORuuhLQvH0dOGvlGgJrze/6esCqKxEQFA6bgwk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eumAA3k42K6yB6RZB1WU+xt5GGoRMa4EQmog24F7MJERClHfXOFO7yv08z0jvcCmv
	 w1uGdCt3PZw3rvBVei3wJi6cCcD3YrMWXxLfyGjV51YUCT5H9CZY1WM+9FX144+H93
	 PbZXbnow1re3NMVT8taE7YypLSXNbeCdMQ9VMh/N4vIxCxnzqR+n+ANhYyXcwaR2LP
	 ErhyGeSHX0HKoX24vZ3qa4ipO1l0uT48xXwBaRaNYnFv0DT7AJJcJHK5ZmiJRcGVLJ
	 I0vWNgkubvcElxaySbtT9b0dgXpVM3xx00admRyflohfS0RgxZbaTECcufe52mCwT0
	 K/hcSks9Awr4A==
Date: Wed, 21 Oct 2026 12:19:41 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "Harry Yoo (Meta)" <harry@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Andrew Morton
 <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin
 <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Muchun Song
 <muchun.song@linux.dev>, Hao Ge <hao.ge@linux.dev>, Pedro Falcato
 <pfalcato@suse.de>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>, Willem de
 Bruijn <willemb@google.com>, Mina Almasry <almasrymina@google.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, Sebastian Andrzej
 Siewior <bigeasy@linutronix.de>, Jiayuan Chen <jiayuan.chen@linux.dev>,
 netdev@vger.kernel.org
Subject: Re: [PATCH slab/for-next 05/14] net: skbuff: specify
 SLAB_MAY_ACCOUNT for skbuff_head_cache
Message-ID: <20261021121941.4d8f8edf@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-5-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
	<20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-5-096800aa3330@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f9jgsbgftqcsi7jb3nzthhigj8agerqw
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B785640002
X-Rspam-User: 
X-HE-Tag: 1792610383-799520
X-HE-Meta: U2FsdGVkX1/iDz3KbAWxkRefBFSLpWk60Mvs9HvTMD3vQ8sc7lUG5WRSExSzQohX1GDV7MvXEYqMeGBgPGP1+XxX01nSjTmMf2I6qUzLLZkuDnx/R2WYKVJIEhvybcIdtTefRBTBLWbJ8DxKEbSHMXNQeQy0uwtsNEGSBeNZ6ptArzetpMWyDggXyiacI1F92szmCzjza/Cl28+MFCfPpdN34LgkeijhuRnPZrbgnCqVNwgBdbwMxbWmIK4IIHoxcpPjNIUmIG0tHkX3KeBJ4U7Hqkxx1NCI8pYwa83QHsliZCUnSIeKqeuKod43KsyBVBLGROXSt6sgjQot0Lv4TuCOGTm0rHf24WlsMt+/hpVA7MTeH1Lm+wTMOi2EfuA4sZ80H8+dlD9JzOhNPlTzCwlqsYOmV2/34GmktvUElXWNlwr/q7xS3moqyarwCQD9EePZ+tnii3fy1oQ7Nyfngm9MD5M3jT2S/OhWuL/xyrMokVYXFdKYVGgxHa7bcei4j75XToK+W+2+NifxygF2eNnYf0xyuJuW1vELDqLdxlwRgLxOra3fzQNJyhCdKl9iiz3KMXNyKL0AST3VJxx+1QkQWpl3srgxsWQv5QRKIYLzLYipDkhYL651jUDEKcEOPGBrmqcHx5MKuqnUQUxpzmJvhOek0Vr7n0JY3y76HBJMy8B5xb83QconrtiZMjrqJFcqDM8W09E6k5k0t4lCPnlR4s3UjpjdEmAEfV90vspE8L9KzhDpWVadxMm9miLet0vowC6ild9A+bS+8Mcj9V610C+VVNYWKm6xfLd9URpCJZfYDuWi9UoQSE4jaraZTmlt3B17c9dSZA/x4AAsrC00y33C/U2dTwrhEcmor4Fs5UxMCnIz/Ub36b4dGJntmCnqdnDesr8sbCzQth/NcshqG2OGx6/CaDY4sDYAy/yPPl0Zm2eiWuWXBMyTArJZUovJZro7jNJIX5/N1FC
 joOoIUdx
 hFLVUGPY6apIFxirU50HIdqW/SCpT5/kXveP2k0Rj4MEUDmtM7siELlcj4bMQa6IJx0JsytZC49OSzRqirfe5OBx6cdC7++9i4ZQDLkMua1px3Rxj9B6nlsX38ymwsTlOyuMKvjfSUlqGOgwZq7IUzzaKVR6hCi8RtvZY8bIwk3v5Zuadwq+gwfsXUN3gmesebOS4lQbjn40T+yRWfo1m5Wv5T/uV+qkyWa5czBNKjXREaqnC2y093k+1aYTAd4tLNnTDMEKp729W3NVvDcaJ0l8HMaRXr+FFZUfOLdhwWpou9oubsyGYLmKKVNy/J2EbC6YrJKzI1qgov+8zYxySLCl5BxHuiJK+q62XSMZcNC6XsfD8YWo+lcJSl3BXwhTWUGiZXiTRxCFh/7YLZ09fhdN9TsI9LHNXrmhulg7vKtCo1IS4zd4IqYAB53tqZtncpuYLOlE6jQ/XJgDthJz1TU/G5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 21 Oct 2026 12:46:46 +0100 Harry Yoo (Meta) wrote:
> AF_UNIX sets sk->sk_allocation to GFP_KERNEL_ACCOUNT, so skbs can be
> allocated from skbuff_head_cache with __GFP_ACCOUNT. Specify
> SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
> __GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Could you please skip this for the first batch and resend
later to net-next?

## Form letter - net-next-closed

The merge window for Linux v7.4 has begun, and the net-next
tree is now closed for new drivers, features, code refactoring
and optimizations. We are currently accepting bug fixes only.

Please repost when net-next reopens. There is some uncertainty
about how long this merge window will last, so please check
https://netdev.bots.linux.dev/net-next.html
before reposting. net-next _may_ reopen on Nov 2nd.

See: https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#development-cycle
-- 
pw-bot: defer
pv-bot: closed


