Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37F41C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 10:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4786B009B; Tue, 14 Jul 2026 06:57:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB3A6B009D; Tue, 14 Jul 2026 06:57:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2066B009E; Tue, 14 Jul 2026 06:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 075596B009B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 06:57:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7A51B40369
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:57:06 +0000 (UTC)
X-FDA: 84987080052.17.D561577
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95368180003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:57:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gc8GFZ+d;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784026624;
	b=EHb4Y23UqPRKed5Zm4a1QWAwSNoFJqM63wKWaN0crWFzlD45IFne+eruiKqjDoi4XrvbKI
	yqV1dlKqiFifedqms4+EV9KJXckQKt8oiuVt82b+39QLo4m32e3mtOZEyG3ELxee22imLy
	rCLtUiHAvhUW4CnhMHfLVeoRBUwYj7A=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Gc8GFZ+d;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784026624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b+/02nV5PKCig2GWCVlTdDIGXiyzApjtVUV59kIrcLM=;
	b=bM1/5gqYkD6bazJkYgYD2ZTHe0Quz5iK70PCCCZ0pdRpGjoKhfIbkGVwKegaEjnJExngbX
	cHoaxSQegYTK+JIpIhgiaab4Q5NEba3KsRIji3cP4XE/wcdUWY4LgFQ88UWHuV7N/wHUDX
	tXPGAwFXUPmp52b1Ih0umFMbD4OKehU=
Message-ID: <3b85c8ec-f49a-45be-8e40-fe729c908e0f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784026622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b+/02nV5PKCig2GWCVlTdDIGXiyzApjtVUV59kIrcLM=;
	b=Gc8GFZ+d3zpJbug2thf9FF6OZIE897xwN3vzOQlKoLCTS9pePGJ+vnyvp/ZqCoaevVxpL0
	MABYh96Okw4r16h1lG84PA/X3/WsJLyqTYjIvO3ZWyboHtGV+FpE0REbcJaCFGqmtjZB8i
	U6IvaVO/osbGa73qzG0SU06B1xld1E0=
Date: Tue, 14 Jul 2026 18:56:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] fs: push nr_cached_objects memcg gating into individual
 filesystems
To: Usama Arif <usama.arif@linux.dev>, brauner@kernel.org, jack@suse.cz,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com,
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org,
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com,
 kernel-team@meta.com
References: <20260714101454.1202449-1-usama.arif@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20260714101454.1202449-1-usama.arif@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 95368180003
X-Stat-Signature: 3g3er5j1grcbgygayt6oxs5scfg9zps6
X-HE-Tag: 1784026624-304413
X-HE-Meta: U2FsdGVkX18XNjbnAmQHILsBHUMIlTQGmJ3RP5oWCx6klBndwV2Ovx6T+v9CPlZB9CYhrKNbb6R1WMrVPEgLG471c6D3bo/udL25eHod1u6JLYvp7MhoGDidpEwsi7PHxJRh2PMYAjo7Ks2R5nIb/R9l/+ZVXoM9Mnqmo5gM8H46iqdzq/VLe3Up9WOc2lxAJ3ujY9nibqZ1pAk9hHo5VP/NaNFXQztEinOD6d/375zR8zXiaifQsY/yaGQk0aUgYQiaZlX55j7WM3j2j1B7+zlO0H5LWK4KtxiGMFG2foSypob9CeF4R+1d1ggJw8wxvYnjJFi+hU+vcpzsV5ChrfNzxXbgOYwiSOcQx0lgs1FI/6F4qpGKoGgsSu+CSjUNcDZBVwRpWQLnb9A3saNtTtUFRQLlq9RPBgB8vtIGqtN95zq8ia9tysXlt+tg6OADp12TWTq+6L/rkkL0zf9yowQ+W9GZSQihUMufKBldK/7XHbpiQQtGaiTMEX/Dd9RhEt8xP4EXZRqB8D1LyljRTw10bshKBysg/NJX4G+CcOH7BjcHDf9WQSI42pyXfC4YNvIgByhbVdw9S0ejkNNo935Bw+28TAyDaMfJZlcvEn2SCZeCKfen+Ounk1Bwteq9GtwdbTWsREz54++GzjLbd3/fXfZ1pjD1W2QEksukElW04SVDeBRLhkemQlal1+KKA7WfExXaejQ3rKVGT8soMlS8enEVaDBDvAtRmJ9OMcKNXHRB85jx4Nc3TlVX9vMOjV029+/hE/cZUkJ7FrYbnRlSybtASnMNFa0HF7RXKtIieLUdAyiM4houjyJuv/0RjIzBO2DkUnsiofxR0LiXi5z5riEzhf/kVmYt1lSrHhXAyUjqtVRMv/5qdvJuyWisTNEHb3HAZ0x57KlMZJTIjLwrGEUmx75h0twXhXvnf/o399CGGtgHvaRgntMLUbQnk/nMvdJcs0rQxubkZCf
 cXc7DTDR
 Ozl7E3JxnEZmttvqPooASzZjMKsvUzm+2MBAiOObN53SkRPx7UJUxmd5eTI6y83KAuN4XFCcD+DczO0SJYXR6kMR/ilnH5+u0fOOHsyWxS7S2DxVlJF9zQh3yKM/xY3MAJelxS/chW+QpU0aTj2sm8XaaKR1yGqzK+zSZxV9bHVIlS2Ho92WzMDDDAOTz1tJIJtMS8Lv2HsQRCuT07cJvOx0e5g0DmgVL/PbcT7AfA+/01Q51guGcO71znvlDeRufK03n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/14/26 6:14 PM, Usama Arif wrote:
> Commit 0baad6f9b997 ("fs/super: skip non-memcg-aware nr_cached_objects
> in memcg slab shrink") added a check in fs/super.c that skips the
> ->nr_cached_objects() hook whenever the shrinker is invoked for a
> non-root memcg, because none of the current implementations (btrfs,
> xfs, shmem huge) honour sc->memcg.
> 
> That policy is really a filesystem-owned property: fs/super.c should
> not encode the assumption that these hooks are never memcg-aware,
> since a future implementation might legitimately filter by sc->memcg.
> Move the check into btrfs_nr_cached_objects(), xfs_fs_nr_cached_objects()
> and shmem_unused_huge_count() so each filesystem can lift the
> restriction independently once its underlying counters/scans become
> memcg-aware, without needing a coordinated change to fs/super.c.
> 
> Behaviour is unchanged: calls into these hooks from shrink_slab_memcg()
> still early-return 0 for non-root memcg contexts, keeping the shrinker
> bit clearable in each memcg's bitmap; the global (kswapd or root
> direct reclaim) path still drives them as before.
> 
> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> ---
>   fs/btrfs/super.c   | 11 +++++++++++
>   fs/super.c         | 19 ++-----------------
>   fs/xfs/xfs_super.c | 12 ++++++++++++
>   mm/shmem.c         | 11 +++++++++++
>   4 files changed, 36 insertions(+), 17 deletions(-)

Looks reasonable to me. So

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks!


