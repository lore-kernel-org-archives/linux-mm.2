Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1385FC88E51
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 06:14:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67CA66B0088; Mon, 26 Jan 2026 01:14:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62A946B0089; Mon, 26 Jan 2026 01:14:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5369E6B008A; Mon, 26 Jan 2026 01:14:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 43A5D6B0088
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 01:14:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CD0FCC2562
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:14:06 +0000 (UTC)
X-FDA: 84373099692.05.6673D95
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id C42E414000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 06:14:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pmKuYWar;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769408045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fRkLP4BJZeXuj/pQ6WlXqQb5hFaywSSeMSj8bpxWqBU=;
	b=6f9ztf+BeFLnkOwZRkLKZ50RcRG/YPKy7UKkKS9D3fgzAt/k6jzfpaN/2e12AUVj+roq+7
	pbwATwYaC4pI+2RgBoPG2DHNyI/fX76btIUDeMOESCjjUtZ3tQjh8jWfdWR4DIp4G8g8tK
	Op5IQ/G9njvGfZjjKtprDE2BqWqxtFU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pmKuYWar;
	spf=pass (imf23.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769408045; a=rsa-sha256;
	cv=none;
	b=LZGbEDopacU+nu6WhHuRZ3WawI8/a/b3iNsPDKrmdGCJ6PxY8f2wnEAeBumTRXs7ByAtjP
	b2sl0RmxTSbn28Jd/iDVFnHLleUdo7LIkxSxNchtEnnVKaY7/p5YBBSgdmvj/oimounv2O
	84M78sOGdAjpaobboQNvZANyD0Pj0pE=
Date: Mon, 26 Jan 2026 14:13:51 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769408042;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fRkLP4BJZeXuj/pQ6WlXqQb5hFaywSSeMSj8bpxWqBU=;
	b=pmKuYWarxQVGBmbrGyx+AIbSk7QyLVpDVeYsyHv71m/qtrh+9UwB0Q44cC21P4FGhUyW9H
	uEE9U9BQ67bvF03/yRwaeGlBmpOEVdX9UFKDAwiaFU8e7PVcG3e4N0/jWVF221cNf11SsV
	scA6aa3AZfL4OecVK1El6ZGfRc+HDa4=
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
Subject: Re: [PATCH v4 07/22] slab: introduce percpu sheaves bootstrap
Message-ID: <qrekwm7js5t4kmahu3toqnrepnvk7ve5h624f6hm262mmybvtx@rewwd4rbvf3b>
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-7-041323d506f7@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123-sheaves-for-all-v4-7-041323d506f7@suse.cz>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: mjdkfa6oa5u7zskfxbfejx4e1itw1uyw
X-Rspamd-Queue-Id: C42E414000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769408044-826413
X-HE-Meta: U2FsdGVkX1/DZA/aEZXklqmTytwvno/YOgrxDRlzJiYl7P5jeDFUOyCYdEo1gYHDqN/sJFmKZsuahLEcVvX06uW67Ce4d1LAnMO2JTgirEuozglMDm+mxlyjPYlHKYZvbir5M+mGWhoZFWc+a9BY5vLGKrrM+Hp5vThVaC8SxERNP+wBWQhsstJVSC178oECIcCrk1Z0MY2LI39n1Ny/HZVgYVEiz4dI9n2LqcNjqTVjr5bzIdYL86qwKD6tErrLfSzAsstv9dHdQCDkGVrEepoHbME5AUEVDzO837Ke9lPn09VxCIS87/hGZhl1CM3gctjH2n8F1zKGrQUqInHhrQf1egQZfALO5Fj173h+/HsCnPSvyEgypLJ4FNO1EWHu5ge8LVXO3/Qyazcg8MvwVRZ6oTSOFXXHAn25mvexvILmG7vNC/o3uNZel7FkprisHVbt4BdnqthaWqMOlAZlkFUvCYD3OOG/FqnuFm7aOXB+VBgV/MO830J3rlUUYGABoP7gH60l9dYtUcAdEMynSj7TtugGrHqIqmj+/34CvuaT4NMNY4v5WADdBtXhFRVpXtndtXMpxdOXBntSZEnwqvIYGfGd2xu0S05n6bgM7NyziSDGG2XDdl+CNAFbiczSiI30OrezMNdipB51UybvKjWiLK8SzPn2i5OfUg9S1HqeVGbkB1KIk6p8PUc00716ZBdbsvMRwtMvgwbjEvzr43cXs2p7qQVwpal9x2nOOIbBnAK7kz3VUIF65OD73LuRudvkK48djP92XGuS/hsNi25LuF8vep4IbKGpenmlT76vb/xJrYE71hEEoLQcozX7EcRnK1W5X78s/UE1KPSRDQMU4/sXeDgu7PATLGTitlc9O/s2nK66+PeBnWn2m+N8QwjbW9o4wOx8o32thzUckk3Z7/6878UWx2PEf4O3Ky6D63zuRNvEU4N+i6EgXDLsWCQ/r7rEsCWh2r5h89V
 Eb0P5Ilp
 yQLK66OGs6Bj5W6wofThTAXAlBQl4f/UO4s0D0YMl1eup0QtKGdHnXP5R6KtPRj7tODiEbig0zgdAKupMKDePIkThMdK/P+ojxBRRB8XKCg3yzNqDzk25gqRfqhUbLqOzJKmu1E+G/0wxF1zrcFSNBx6coTaRK4IsDRsi4ZVsIeDhVWrrn1L6lbpBS3Ms9j7/LPGx9N9WsHjERtxHqjHctdBR76mHm7R7btgvrFvlYaWp3zA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 07:52:45AM +0100, Vlastimil Babka wrote:
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
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> ---
>  mm/slab.h        |  12 ++++++
>  mm/slab_common.c |   2 +-
>  mm/slub.c        | 123 ++++++++++++++++++++++++++++++++++++-------------------
>  3 files changed, 95 insertions(+), 42 deletions(-)

Tiny consistency nit: in kfree_rcu_sheaf(), there's a remaining "if
(s->cpu_sheaves)" that could be replaced with "if (cache_has_sheaves(s))" for
consistency. It's trivial, so no need to respin - happy to have it addressed
opportunistically.

The rest looks great to me!

Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

