Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85DFCCF2E7
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD7D6B0193; Mon, 19 Jan 2026 06:32:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A5766B0194; Mon, 19 Jan 2026 06:32:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D20A6B0195; Mon, 19 Jan 2026 06:32:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0C35F6B0193
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:32:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C624A13B9B7
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:32:27 +0000 (UTC)
X-FDA: 84348500334.07.08CCE9D
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id D0C5DC0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:32:25 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H9fF1520;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768822346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=789MzptrG4PzrEbzbBX5NhrBO/HqtHp6WbidgwoRfUk=;
	b=s/ydDvpgJEH7HBpgc250abO00m++rc8B5/F/Y2sHGk8LcSP8fz8Y5MUj1WNF3RdKSqKOjO
	5HJLyBD1q4fwg/fTD9UJgpVU4lP74DRPEBq+nZRGEyGQcUMXCXcA/Ym49qjmaMaQ34DsTz
	zfY06NuUpZQtYpKt2Vtqbj5+51fR+3M=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H9fF1520;
	spf=pass (imf10.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768822346; a=rsa-sha256;
	cv=none;
	b=lNwoi7WsVBGR2O3D++DI5KBxP8ok/o7YSfaH+cxesXR2rLN+7MLOdxd8z6cK6ZinkgZjnU
	QTXbijzfL7XOf4jmgVqgsUyDyRZ10uyExwRu7mVK+8njRdOP5PZ3svqu9a8bI7ZfSHI9yj
	8X4A+YTgimnK4gzgBURDXQdkk4m1OvU=
Date: Mon, 19 Jan 2026 19:32:02 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768822343;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=789MzptrG4PzrEbzbBX5NhrBO/HqtHp6WbidgwoRfUk=;
	b=H9fF1520nTXpUXbJdEUKsJPkUR7QlwqLisA4sSHkjwEzW6WG/BZYQu2QP5NS5D3ZVnhoHx
	IiN0B0a+yuZ8khDQjssO9enemzO4yyMEprBH2fjp8USw4KZP7r9ihWXBbUU4X8WJwBwpVc
	jTZ66RElxzjmOQDdIULcFR7cwYwuojM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, bpf@vger.kernel.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH v3 06/21] slab: introduce percpu sheaves bootstrap
Message-ID: <7rzlxxqawgasthkhlk2fccync42blr3mehtfbylcsihy7kr5m5@m2bzma4qifo7>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
 <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116-sheaves-for-all-v3-6-5595cb000772@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0C5DC0003
X-Stat-Signature: 8goshqwptuwsxu3pz9co118ga8xmjrc1
X-HE-Tag: 1768822345-583605
X-HE-Meta: U2FsdGVkX1+vSSyMGdi6fWmNhooQXMC2R3008QleP0zC5d75sa7G6sFFEf/LVwaXyYamPbw0dnBwbnGEFv+4KSLYCdFy6HkjmjwBbOJ61UMr9+ZDS80jHEdD49wNfBdnKPuHFSsXEUzw8L44qSUHCkaJGObfjsop+hAdQPP+4lGCYwkU37IZl0cm79y3WEkgRgrNGk7GMP7XMVGew0988t+Nrm5gpvdyFzgpudhoV7h7vIsfb98PL1e8nGCQ4Uq+WcAeVdGlrdiLItthCe6Rlb8xUHDfe46qKFhZCO3Vgbki+imODKMQYOEcRWNU9hGR2ZB8YdQQGfHl3ItUVTuSy9baDbDPOtFGxa/o/1rtLu6nV+dOwgr4k681GFLya9wU3hTQBP1esYgHCVAuFFypirRG/oD1mHxo+E5+jx5Xbbv7C+IoLinZM5dm6r1Z7piZ1OtMCHad1i72cyAiw/uahEmu9qLXToDCVdlE8FroqJfanNxDprsdcAq6ueBS6VCyO3xVKrTd9UVKru52Przf/eSG+2aohJhUPwIemOxyOZzSBfhQRJLJCqey4+ewDygtY+gCTav2MRzGqYWOStRQ9kjcKWdcHBUbnzessFpQrP8hAUI7uTHyVdihGrfjYjtdBe9bKPIm6dVBfgP+AR3Wl0MzvC6YlnPkya7Ks4LYOJ31IN71xzRHqT+gIWBBE6WvFoQs3LsUDWcIPiQ1RMiY5mTPcmDkb8qDWC0kyQK6LGEQZBANEZhWOvSAcqldc9+gpK2ZuXINbrulSU+ilyyr+UgxfCMWTIeMK7D3Jpt7sQMOXeXustXMlv130O2RKh54BM9CYJG42TTT/skZsqWF9O5scJYc9sPFhYtAfyFMeHolTrpzLoW58h9xqK4W8eYwFk33W1hHBM+K0g7ej7nrW1oaKhr3o+3mWqqvWPg/pCe63+30IvlPw9a3UK6jtFSeXgOQTgi7GqYBPR2XXR2
 Gk+1u/7I
 g9VfXmUJ5oWdjOs4d45NkhFWh6HubXM2cktxf8v6+7dv1ABT1hYM4MG4tBspgE3+hfiQMmfXutGPKq97gLQVduRT/MEZMiM0MyK4KS3A05s2m2X8TTk74QfSSpIDpCM22RDqd6Mk8BlxLvXouFHqbGuydGYSOTIOBGqL+gygCfoLSVJbvXA3F8fgSARK8GVr1fEI8ySgOG3s0Lrc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 03:40:26PM +0100, Vlastimil Babka wrote:
> Until now, kmem_cache->cpu_sheaves was !NULL only for caches with
> sheaves enabled. Since we want to enable them for almost all caches,
> it's suboptimal to test the pointer in the fast paths, so instead
> allocate it for all caches in do_kmem_cache_create(). Instead of testing
> the cpu_sheaves pointer to recognize caches (yet) without sheaves, test
> kmem_cache->sheaf_capacity for being 0, where needed, using a new
> cache_has_sheaves() helper.
> 
> However, for the fast paths sake we also assume that the main sheaf
> always exists (pcs->main is !NULL), and during bootstrap we cannot
> allocate sheaves yet.
> 
> Solve this by introducing a single static bootstrap_sheaf that's
> assigned as pcs->main during bootstrap. It has a size of 0, so during
> allocations, the fast path will find it's empty. Since the size of 0
> matches sheaf_capacity of 0, the freeing fast paths will find it's
> "full". In the slow path handlers, we use cache_has_sheaves() to
> recognize that the cache doesn't (yet) have real sheaves, and fall back.
> Thus sharing the single bootstrap sheaf like this for multiple caches
> and cpus is safe.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slub.c | 119 ++++++++++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 81 insertions(+), 38 deletions(-)
> 

Nit: would it make sense to also update "if (s->cpu_sheaves)" to
cache_has_sheaves() in kvfree_rcu_barrier_on_cache(), for consistency?

-- 
Thanks,
Hao

