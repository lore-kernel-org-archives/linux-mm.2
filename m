Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B84B606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 12:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LLGp4/+8
Received: by kanga.kvack.org (Postfix)
	id 3515F6B0246; Wed, 21 Oct 2026 08:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 328626B0248; Wed, 21 Oct 2026 08:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23E9A6B0249; Wed, 21 Oct 2026 08:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 03F836B0246
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:31:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AC43804D2
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:31:43 +0000 (UTC)
X-FDA: 85346569686.18.1E123A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 006A94000C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 12:31:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LLGp4/+8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792585902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qd4BaSzD1LGTx2Y2uGB3Eo4kEo7F1O6DGIb4zjdHo44=;
	b=LdAP+RGelMaOtfansJ7aXb3w1JxL17b5vYBEoZ/J8AyC+Xa/eHpgRyZV5mBEeUtijD3z0S
	OMs9Alj84K2vbNiyK8C7SUjEbo6YCxZV7nSOX4QDvxX8kaBN1UjqMW1snJfWeQz7Y5I8yT
	Llwwc5uTAepw7I4v/6T9CdZ50J8L+/Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LLGp4/+8";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792585902;
	b=Yt7OUBvui9xqKbDVqmVAFDmxXuHqWyysjjffliIAY3Z84dLRXB/5YuEB9+PctnaoKm1E9H
	R1ib6dEnfH5zC0YoUVSmHoihCYJjEg1eiFJcVqSR2LYI4H1JdqLPxSSLiTpNDuy8SSuDbm
	UlYn6WAek6FqtmVYL7kz0Qggvgnw+eo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7469A60142;
	Wed, 21 Oct 2026 12:31:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACD001F000C4;
	Wed, 21 Oct 2026 12:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792585901;
	bh=Qd4BaSzD1LGTx2Y2uGB3Eo4kEo7F1O6DGIb4zjdHo44=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LLGp4/+8kHfG3XaY9MW48NgLFV00TpK3bldoGF2u2IsEIe01KBpuQWuKk7hhMBjPQ
	 JKhplgPH506WX1RmYtr3rcCl5N1uZ3qTepV2ikpQMkVY9e3Rsunc0Eq+MV8UYICgn2
	 DHLP8HxsWjiTqDwOpxdHXt/gUcT33tnpkmWF+YtKYxsdJKFQq7GCA3942trBjm19N8
	 /taG2iuEYzP4vgcD+YuryfApu1ijzfHoWtl8LIF55gFLsjNC10D0UMsrFWJD9psn61
	 n+W38tnK2hhNLZ/93IcvdfnskEbM2fDBJ7wzh1SGJTF7dvupS3I395I70Ei5C3wXO2
	 aAGqtsDFdVveQ==
Date: Wed, 21 Oct 2026 13:31:32 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Gregory Price (Meta)" <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, 
	baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, hannes@cmpxchg.org, 
	david@kernel.org, mhocko@kernel.org, dave@stgolabs.net, roman.gushchin@linux.dev, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: reclaim every zone in per-node proactive
 reclaim
Message-ID: <atiwhEIudhnK0pmQ@gremlin>
References: <20261019185002.3428594-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019185002.3428594-1-gourry@gourry.net>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 006A94000C
X-Stat-Signature: cbcjsfxuenjqte8iqgrahyj1gxbdw37z
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792585901-161145
X-HE-Meta: U2FsdGVkX1/MuMbb8cGtys2Ao6ruXK295nR65HR+rxbyfGcPh8ftY5wwQGQPoajiUYrWKV3F48q0R0PwhXFLiE+BdgF4gklgZptG4Rnh/k2OL15u22vLw6bbudiGqeSgJcOzyun4MmO9rEzLupdb0bc6mcJspO/i58Fs0+uVkifjZzpVuAUu1Dr9sHwfRDPp8ZwRlg9+Q9sypfNyy9rwYMjvve2vQP0Tf9D1cwjk3rcCxVPJoJqw1nlplaNU2HgSXs91n8lbwTiEyvsrNN5km97i9Gxh/ZGiiguzQ/14PzeUvQCHN/ajUpGwlxUr0CC0Rj8C0Iwa95ugJzoA8D/ixs+mM41eH0coNdbmoz5NuohDezNomoVsUfStZejPEjZ3El7OXVWosw//MUr540LfEEU4LNUOTWAN1urH7UHgc+JVXeSizfNdR3+UAj0k9dFKXB6S43hND2WNJEKw0vNC84iVeTMFK85Uqar5xwTDA9Nkmj04TAbmR/J6bOY52bOoPaaMy2X8qWnYGqkI6TgwxOmSeknEeLLr/uFP4dvF//O9CiaM+NdwMA6UJWNDWzkuAlFhB97JTaDeit5Dh7lWsmLPwMNfDtWoTLNYUi+EQ4EEAhtownmBqvOFuCu8Nbl37xnZP07J4pgeEtLhgIXjeQkNnP+xO6mu7IieydrOYKXdfNrIw97uPw3c3PItUBL87OMcXqRW3nebal6b2TSRrfaoOlyZB6hX55Fv5tn3loHp/8S2E4ebIKM4YE/BetsCNFWYvv8tUlIaikw9UC5xhGV6b5ViL5n/yz7OLMnNowjsdXnPSvQQf/znwNxYLfNJ4WoPs3T+q/hoKWkVFC5s2H7vv3vKI+mhnqAkWe5qHDNKFdWHuz45Oa+Rav6jeDU2Ja0ldgpxeld+q5/LhWPjthAM0ePnWzdRMXY5nC7qxt9Iu08MsbGxMoWVXCiUBdm/6ZqJNKN4IpsP+3kn3o1
 4Wvf62sv
 rpGi8JTFTWvJF04Xu3cCoq/aG4TVAfhsJc8PcMlc93xrWm2HAFESh/ZX3DFA12foPNcOKDZ+7ximNxlMjWSfOfx5i/IdU1/Ekc/HQWGaCvEZgFrJ6629EUDUiWiwtu09wttay67UhpbhuLnffKeHc401M06wFeXxv86eD8h1oMhY4TV7q2DXH1p2iFhcqmHIO34RBlALHEKO/L1VKD3Fzd68lcqiGWJEwPPantXvPEXVJOYnXeG0EASTwipWiqT+smkaafF6UU6DbWNz9Vz4zybYfXG7prKsYKLcBSzp7hvtA0dehmnifj/DNh+gJAao5wnvPL+o8EQ6260UVPM6q46RQDg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 19, 2026 at 02:50:02PM -0400, Gregory Price (Meta) wrote:
> user_proactive_reclaim() limits per-node reclaim to
> gfp_zone(GFP_KERNEL), which is ZONE_NORMAL. Proactive reclaim serves no
> allocation, but that limit makes shrink_node() skip every ZONE_MOVABLE
> folio, so writing to /sys/devices/system/node/nodeN/reclaim never
> reclaims a node's movable memory. A movable-only node, such as dax/kmem
> or hotplugged memory onlined movable, reclaims nothing and fails with
> -EAGAIN.
>
> To reproduce, fill a movable-only node with clean page cache and write
> 200M to its nodeN/reclaim: the write fails with -EAGAIN and the page
> cache stays. The same write to a ZONE_NORMAL node frees 200MB.
>
> Scan every zone, as memory.reclaim does.
>
> Fixes: b980077899ea4 ("mm: introduce per-node proactive reclaim interface")
> Cc: stable@vger.kernel.org
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Seems sensible to me, and since it's become the review of the ages (TM) let's
try and get some kind of tag record here :P

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e82ba737c028d..90f7a7bf4e426 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -8180,7 +8180,7 @@ int user_proactive_reclaim(char *buf,
>  		} else {
>  			struct scan_control sc = {
>  				.gfp_mask = current_gfp_context(gfp_mask),
> -				.reclaim_idx = gfp_zone(gfp_mask),
> +				.reclaim_idx = MAX_NR_ZONES - 1,
>  				.proactive_swappiness = swappiness == -1 ? NULL : &swappiness,
>  				.priority = DEF_PRIORITY,
>  				.may_writepage = 1,
> --
> 2.53.0-Meta
>

--
Cheers, Lorenzo

