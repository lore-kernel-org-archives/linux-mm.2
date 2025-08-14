Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24C84CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 21:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACF4E9001E4; Thu, 14 Aug 2025 17:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F859001D5; Thu, 14 Aug 2025 17:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 970759001E4; Thu, 14 Aug 2025 17:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A05D9001D5
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:52:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F048914072C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:52:06 +0000 (UTC)
X-FDA: 83776711452.29.9808165
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3A9E8140004
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 21:52:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IrN0ga1A;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755208325; a=rsa-sha256;
	cv=none;
	b=AsmjTEezFlNp1y1FbGArWczIgqNssMMZw+DKwoeRuwIbktUghE6LImqTI6v1+4jicO3idt
	adrQSskJ6rYDqUUJ3JqaNsjjLAAidRXAaHQrsaFCpf98PE80nreCZblQorAnREfPdoB8jO
	CtsnFnRRzZFqGEOazTpToxSMLWHE3Ak=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IrN0ga1A;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755208325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rqdnKsJcJkYJnPBTXkMaUgB7UwMWndORjmIX+sJaJew=;
	b=MEwhCxi5BmYwL4HHXgTMu8eA9TuCbausY/uQfW/iA/nZn5vWDOs0cz6Gz4Erp0A+I/dQRe
	VuYuP1gqNwSA86J3HrwiK4UEiqHq5UqOXYMQBk7cQdMZ3qctNyjZKNE4FK+E5n82JABrUh
	H1LAI24zlLieQObuw6GIOUJVHMoHsqE=
Date: Thu, 14 Aug 2025 14:51:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755208323;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rqdnKsJcJkYJnPBTXkMaUgB7UwMWndORjmIX+sJaJew=;
	b=IrN0ga1A477YwjqiZcuceGQzNznS3SzlrYd+7GS0ASPe9/mRFVQjDkW0St+5h3Wo6IfN2U
	bK+IB04vdumaMqVNLxQSTUp64UctuI6IKtdcHZ+O6X5+e+u0taBRiEekPEbeFSshyg+tfF
	kXJ5/xN1Bf+d4xMzPkNwJiRaL+xoqw0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Mina Almasry <almasrymina@google.com>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v4 net-next 07/10] net-memcg: Introduce
 mem_cgroup_sk_enabled().
Message-ID: <abrvz262kbbw7imirtl5675x5mq2xaymvrzt2q6zlpw3znfiij@4rwtubwxkx6v>
References: <20250814200912.1040628-1-kuniyu@google.com>
 <20250814200912.1040628-8-kuniyu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250814200912.1040628-8-kuniyu@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A9E8140004
X-Stat-Signature: oca9ij3jkn6i697c7m4ezatnu6sqworu
X-HE-Tag: 1755208324-503978
X-HE-Meta: U2FsdGVkX18r66jj4MrXTVO2vTF/VgP+sp+anlD11rcrmwmRGbomltRQDejTvQtHijriaFtB/Q1wCwQ5Mh2Jw2TTwob2yJ5vgaiXcA8npJx2aoLWWfeb/PRJGUEX0NTLj0tyypthdhDcB1e8bC0O7Mao5TZIY+k1+fcBkkBBahGucsMEBayUHhxqVsNSAhI1bt1JtHqeTHw9FfwYCMT3adOkWx3VfxknK/K/fHVCELieoO1Qap125sXvYyBL7z2OH/mvGys9KwRKNYEzZHsyKHmgzD5nPrRFy1muP59H5LdWyIE4/AU/los5gYzj7eUWwry56mz4qBdSGeMyqJV2TVzrCJODuY112neOpifsuJFRs6Xp5LIgMtpFOD9PQxe6B4F4/dcpTd4+C82jJouoEf4Bln0FX1Emh1R5K5mTojdPRebmFhkaTczrwSi9DbsLU4s8Ju/k/pMWZpk2hJyP2kEES3yNENL5KN4AJAiJVNwsIzMe2tW0b17oHwehnZd2gLg/LUeX/cFjGRxoqEBtKiAKg4a6joWQl2oA5xK/LQJADiZ3Ohy43YhK5qFncUefu0pUueS0u7Fz8aC+BSXy+k37cxl3iNUynXVlIwTmzdOnGq3T0yxY41q8WSclHE2TrAxasq7Wfw5myzbcJVNKWr3KI2ZM3gKyHbS3nghj9t7tzduvuOIjfNj4x3oNPgcvVsRdTw0Cgxuth5PfzWjoclKW82Yr+HqBJSFXPTdfQslNQGkuI3p8Z8P1YvItrMDyIdCW3DTanSAbZFzQYhWjsF2X2KjWYZBFYdnLbapqQPSu/7K/xmA/wWupQRnIXZBSmhAOp6JWIbEJRlUszolJN0MWqmFbPVi2bss8WAP9VH/ZBHa3PKCMc6QjjH7zR0pV8fSJcbPGbiqF4n49UvQ2dtX+wBVAyvGmaxapUz9iG64O0kXE+vkbrhlc0gfDl3RMmG8c1/1V2IoIkRP0Y3R
 yOCIzypU
 Mo+G6aIIB8hMgN4KaKQ+P0z0WallgP4Qbjg6Yrwcjg/qzZ08+o7J3673wyDmoT3zLz9pzP/+aokAzZdZBHnSwjB7F+sPkK3hsehW8rV/MzdLj3tKpXXu/ZqBhX3zjGqK9RPsuDqvvOsvMzVBadtXsa745VSD31wlKxs7GfqmC4ZLBc3oSdBKJWvGVUTaO9asEmr/hfR0psi68CKOaY773M/+TQ1VnoMNK/vKOFoHypiepZb7RvPx3HhBnpSR6nsIT+bRhL0i3WVTDQhpjQtbYKubnBWBy/hwPGi40HpIEIrXMF+jjlsf/GLBVcT8LqQVYFe0m
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 08:08:39PM +0000, Kuniyuki Iwashima wrote:
> The socket memcg feature is enabled by a static key and
> only works for non-root cgroup.
> 
> We check both conditions in many places.
> 
> Let's factorise it as a helper function.
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

