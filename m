Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CDD1CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68F38E000E; Wed,  1 Oct 2025 10:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40C48E0002; Wed,  1 Oct 2025 10:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 956568E000E; Wed,  1 Oct 2025 10:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 820B18E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:56:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2B4F81CF66C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:56:19 +0000 (UTC)
X-FDA: 83949846078.07.96EFA74
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id D0FFA40010
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:56:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B8beRsMw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/fpq+Hfk";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e7B17Kkc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=weQKRlnn;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759330577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZhtT0gMzluiTXihxlk/KdiCQJObMccQuGLJ1fCA3Tw=;
	b=2Qgl3fpczmfcSwZ3zT4btmogr5zbgP2xO0FWdr4jtJqWgvxXnnP79Y9HvR+mgzttFHL/f1
	r7B0dJtHfQFSEpqP0MegmaoGLxgDDUdTGjqSR3FcVgU1tCkRgeBmT5ziXBm0nKMF1kSos6
	R4iRg9ilUpj+e+oc1WRe2FWJxCrAJc0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=B8beRsMw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="/fpq+Hfk";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e7B17Kkc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=weQKRlnn;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759330577; a=rsa-sha256;
	cv=none;
	b=ALFwCsjsEIh6jBqlqiovn+y76INQxjeDbYjrbNvP34AMKRqmU/RzYM+bmKlhRol95Ep0IK
	rc3VjxpYyBN6hKn4Iv9YOE9mMIoEYv3NJfQTRNZqUHFdPo95tWAeFPMoPQjdPnaoEOJxkq
	yEKNwh0w2U68o+r2fxociQ/KKivriE8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F1C221FB68;
	Wed,  1 Oct 2025 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759330574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZhtT0gMzluiTXihxlk/KdiCQJObMccQuGLJ1fCA3Tw=;
	b=B8beRsMwsgThdOpOnz46NTYz5Yw7rY5zsGfZ6HBNpLQ3kO4xnFd95SzbOwz5KWr9F/Qi/1
	QRxxzpaRbJ4wiPMuyE35Wo/060bcGYB/d9Aexvh8xtOEnlOIGHT6ToyTZcjzWVxghp7SX1
	TdhOld8jVhjPJ1NHmcZxRgNVLNxy3sM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759330574;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZhtT0gMzluiTXihxlk/KdiCQJObMccQuGLJ1fCA3Tw=;
	b=/fpq+Hfk71kDH7JbsCDVNdqbMlK62EG1d7p9A4Dw9EO2S1gyunXciSOwZI2aS4sYiB1nVj
	aP7nEnRDrnO/IoBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1759330573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZhtT0gMzluiTXihxlk/KdiCQJObMccQuGLJ1fCA3Tw=;
	b=e7B17KkcDsAGU+wBEg0xMqKhca2+w3HspG/SG/oscV8W8+NY2xf8Oa96zLMQGCQXTWCdlX
	wzOnREFosnjQ2VoXm+axUyUBAfsYBUNEmHMSoHyx7nJO+Xz2ZEnKP4XQhvje2bsRk5nOQZ
	NmxYTOdFhLyy2pG/X+197K+4SI90Cg0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1759330573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mZhtT0gMzluiTXihxlk/KdiCQJObMccQuGLJ1fCA3Tw=;
	b=weQKRlnnB3ehydu6Q5++VBJftePIMuk/48sR33UW6Iatb1SxCFSDMooBITsTMot0VS40TD
	BXPz7pUFYk5ugkDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E399913A42;
	Wed,  1 Oct 2025 14:56:13 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lmZZNw1B3WhrLwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 01 Oct 2025 14:56:13 +0000
Message-ID: <4a793133-6cb3-42d4-948f-84eae6fa7df3@suse.cz>
Date: Wed, 1 Oct 2025 16:59:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: page_alloc: avoid kswapd thrashing due to NUMA
 restrictions
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>
References: <20250919162134.1098208-1-hannes@cmpxchg.org>
From: Vlastimil Babka <vbabka@suse.cz>
Content-Language: en-US
In-Reply-To: <20250919162134.1098208-1-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D0FFA40010
X-Rspamd-Server: rspam05
X-Stat-Signature: nw3wrzrjnbr8dp4jitsh7rhfi4opmxpz
X-Rspam-User: 
X-HE-Tag: 1759330576-633791
X-HE-Meta: U2FsdGVkX196OtoCBPZGtndBk5H5GHtpEOL6d7urtRMBCSSQw/Ood533XcL8fhfyqZmff6YLLV4pZze4mLxY/MG2mnDbcrMOWec6mSpPwp2E08eiQsrbsh68cBK+s2wsmRehPnH4CI52StccyTGzOOkgh2DiuaH4rqCixs0QuckLV3UnMpy/nb0z9o3qbAUVKos2pFtBWQgxmYa04SxxxSt/0cIya2/YZFMoRkz0tjopXtrcsKKQB/ARu7VZnTEBXoOzlpI3UOpCPxjOzMCu+vi3U5oTFMqY7fGJN82dIH2mAbrySwcDC8QlQsxzPkGkegCeMIdGLJBbIkEZk596P93sqXIObzB3b9BPLfMWEAgqzdhn2udOWnnqjvsYkkKD5WWGUFtUY8IYI/BSEIOvBw6jHOHHGuB9CRp+VCZcW+SVT9mOGV/guoEsHpDDp1sMBL4It9ZEs0v5Swv8Ptd45yn8vapsBrb483bCq1sDbFtw08JvROqNToNF2uQdjnOSuQfBXdxr0msO8MyL8M41Vd1qSojbjfIpvqus0XrF/+6AZ4o2wDT/p+Eeg9tAqIACbBGElmN6GiTHmU8L/VfTWp5ASmG/4jLqMndweGcZ7iMxm1vKgw2ON7uTmRTjimUheOaJv/jGO/jxkdZIlP5tmswfiRYvtuLW1J6BLCs2qr733rIBCyIz/53EIzmQieUIcAzdR+ZOmthOASYuqBXBWvzECkHheEhnjRAm+rVsW/iwBLEewxyuK+fYEcH11DF5m/l6/O4LS/wJUrlkVdPHyktT0ObBln6YYUyoZW5B8Zm6A7qt/dPzMYTeKi3xmfpuffo3II0LnKTPidPgJqbbO3lT/igbfkgre0YXjZ57dAvtxhs5+wnlJo7gV6Fytd6GzauHjfOCzpSP6R1xbVa8QVywmeL6CzzGg85DQwsUVQhnPJJ4ONsE4Qaj/TFzc6GXYYINe5ZsOw0znJMXxXD
 GdLL3ljt
 3gWHbQEZNOziiC9fcUMbpsgfVXNA60jMqMlG2i3hqeafvZ6Hw7gzOFGcjBTmzly5fvxOMy1/Yc9rDNAT7/FB1eOQsjXgKACQkPwyoQL+fidbOFC1BecORwrxKQUmF98oOSGzXF4a609X2uqxXVYlQ5Y4jbXNrprXEVfb8ocmKAlUm7XJBEva+Tgyj+A3tA+cEUOcJAmaxj2fV/exIG3PWjLgVyw3Cb6Y1yreJnTPjIo7PooHqouEUl/gFj8kpJRV5sovYnU1k0cQBFrX8xsxU9B4K09+d4qaxLukAs1uyuC2kTG5P/b7jUMuYA5zGm4ixh0H7fLLclYE/f+VNIFWibp7qHkY0HWW1QjqcgH/zwSkOMVt5fUIMjsffXVJIOsW+NlgiUtN35QMvMnQMZ3wxflWHYfEXRvHjgr6RsKGBzr3wrhbWEor4oAh1bmnQS4kcVjwg269DEghH2k121yqRSrZaArrNp15k12ATaJIdxztsFhpHPvDnF1IKKcMfOf+AxiCM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/19/25 6:21 PM, Johannes Weiner wrote:
> On NUMA systems without bindings, allocations check all nodes for free
> space, then wake up the kswapds on all nodes and retry. This ensures
> all available space is evenly used before reclaim begins. However,
> when one process or certain allocations have node restrictions, they
> can cause kswapds on only a subset of nodes to be woken up.
> 
> Since kswapd hysteresis targets watermarks that are *higher* than
> needed for allocation, even *unrestricted* allocations can now get
> suckered onto such nodes that are already pressured. This ends up
> concentrating all allocations on them, even when there are idle nodes
> available for the unrestricted requests.
> 
> This was observed with two numa nodes, where node0 is normal and node1
> is ZONE_MOVABLE to facilitate hotplugging: a kernel allocation wakes
> kswapd on node0 only (since node1 is not eligible); once kswapd0 is
> active, the watermarks hover between low and high, and then even the
> movable allocations end up on node0, only to be kicked out again;
> meanwhile node1 is empty and idle.

Is this because node1 is slow tier as Zi suggested, or we're talking
about allocations that are from node0's cpu, while allocations on
node1's cpu would be fine?

Also this sounds like something that ZONELIST_ORDER_ZONE handled until
it was removed. But it wouldn't help with the NUMA binding case.

> Similar behavior is possible when a process with NUMA bindings is
> causing selective kswapd wakeups.
> 
> To fix this, on NUMA systems augment the (misleading) watermark test
> with a check for whether kswapd is already active during the first
> iteration through the zonelist. If this fails to place the request,
> kswapd must be running everywhere already, and the watermark test is
> good enough to decide placement.

Suppose kswapd finished reclaim already, so this check wouldn't kick in.
Wouldn't we be over-pressuring node0 still, just somewhat less?

> With this patch, unrestricted requests successfully make use of node1,
> even while kswapd is reclaiming node0 for restricted allocations.
> 
> [gourry@gourry.net: don't retry if no kswapds were active]
> Signed-off-by: Gregory Price <gourry@gourry.net>
> Tested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  mm/page_alloc.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index cf38d499e045..ffdaf5e30b58 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3735,6 +3735,8 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  	struct pglist_data *last_pgdat = NULL;
>  	bool last_pgdat_dirty_ok = false;
>  	bool no_fallback;
> +	bool skip_kswapd_nodes = nr_online_nodes > 1;
> +	bool skipped_kswapd_nodes = false;
>  
>  retry:
>  	/*
> @@ -3797,6 +3799,19 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  			}
>  		}
>  
> +		/*
> +		 * If kswapd is already active on a node, keep looking
> +		 * for other nodes that might be idle. This can happen
> +		 * if another process has NUMA bindings and is causing
> +		 * kswapd wakeups on only some nodes. Avoid accidental
> +		 * "node_reclaim_mode"-like behavior in this case.
> +		 */
> +		if (skip_kswapd_nodes &&
> +		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
> +			skipped_kswapd_nodes = true;
> +			continue;
> +		}
> +
>  		cond_accept_memory(zone, order, alloc_flags);
>  
>  		/*
> @@ -3888,6 +3903,15 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
>  		}
>  	}
>  
> +	/*
> +	 * If we skipped over nodes with active kswapds and found no
> +	 * idle nodes, retry and place anywhere the watermarks permit.
> +	 */
> +	if (skip_kswapd_nodes && skipped_kswapd_nodes) {
> +		skip_kswapd_nodes = false;
> +		goto retry;
> +	}
> +
>  	/*
>  	 * It's possible on a UMA machine to get through all zones that are

