Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A46CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD2D36B008A; Tue, 12 May 2026 01:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A83B46B008C; Tue, 12 May 2026 01:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 999576B0092; Tue, 12 May 2026 01:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88F716B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:49:32 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1734DA038C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:49:32 +0000 (UTC)
X-FDA: 84757690584.22.5276946
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28EE6C0011
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:49:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KLS2vJfV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778564970;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yf/rjkJnF6ix6CnaWGK+0TUZNZ/xr04WoOIRenF1ChY=;
	b=eRp0VNfFmmcCmbjJ9eWE+Nqd/fCWLe2SIzescKPH2Tq2RBnPsH4Su388GH2AQ7/+KOvVsS
	GcQk/8KDpKJ2fWW+3gMP67likZ1gl5o6Duc7Js96aNVKpsZmgHFVldRghCyRe1n9U3zkDz
	lGWkxSbbItYBexNB4RWg5Kx2wNLqZJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778564970; a=rsa-sha256;
	cv=none;
	b=MyDanZ4StQfcviYWmCZWSe4h3bbnLGZ1HHbsLPLTipzBSG4W681lGp2tMxS9jnyqidnwGZ
	2Za9jmHQTTw07W7d8YawXGSe5qRPJ8ddNMhyO4gqY4xIcAKyuT8UYdVTLLRS54XgZmopUD
	XGyXiwTC1nX16JyMKdusI3SY1uik7Hg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KLS2vJfV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06B7C43DD2;
	Tue, 12 May 2026 05:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B518C2BCB8;
	Tue, 12 May 2026 05:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778564968;
	bh=dXNDi5K7xGLXKkPBukeUtCbaxwuxP81XBDAJAQGRAHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KLS2vJfVDWXc3BCHd9f0sWBczi8Wv3E2rQGermj8XBqnyFJXyDv0/DOPjZVY++REu
	 jbd+g2RBXbQM/hwNSRSUVgcVexVoPO6SYyiuiy00lB/gpo2WHM2qxAgCQpy1iCSgRv
	 sDc8mvIBtQg0KRAFSpMe3ig08fNemjUjhzg1yWOxw32hgmo021WnyKXznvPMS0ktyr
	 5zeP9mm0sAk0FS2bLdY+9T1mJmpEK2MHqC09/Ryyl6CitM147OGDvZTrF4eBCJ8ePp
	 TAipaglW9RUgEDNyDWl3qCm1c20A8PlRDkomhU2OOFRtsArR7TfyOLQo1s6C73LNrS
	 A3JgeLSznII4A==
Date: Tue, 12 May 2026 14:49:26 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	hu.shengming@zte.com.cn, Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: Re: [PATCH RFC v2] mm, slab: add an optimistic
 __slab_try_return_freelist()
Message-ID: <ilvntlpu67ihrbna6hps62flwtiwrwddljoqg6olos7c3qstz7@gsxg5bhcnwbz>
References: <20260427-b4-refill-optimistic-return-v2-1-1672467a792d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427-b4-refill-optimistic-return-v2-1-1672467a792d@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 28EE6C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: e7rx7j8phuoh3k9g9tti7wmjh6dxfh9h
X-HE-Tag: 1778564969-399046
X-HE-Meta: U2FsdGVkX1/ud2vrHbxCTjkT1CwavqdRyIHeTYkjU8OKcC548R0ojqO7LOj2FySaNhZkpyL1ORS9qWZjFfxjMwcrOna94NseDKudVM3gD9dJutCDTIx0AQCu/83JXVhcAnJc81Fkh0H0+dpFbDLEVcrjlAwY4pGIvr7HkoG1WWlZxhP6qWgNkbVjFLk8rcQ25SqGIfArJYyD+OXUJuPL6mgx05bd5LorznSet2/xPQSeI77+qltD/YGzTVRDKHJQe0Z8rh4w2F3S3i7tcDOQiw2yJnmMtXn0AHQCP2yjcrTTdNR3O5cIUJ3uLwHvmtgh1A8Ed8l2MEl420z/RaDmdscBKQFFY6Qk7j4aFawzx7R+VeknIiJzUJrQtRZmWA8F8yowY5O8AUj0Q7KZISueJp3HJHpemAZgqXVAHmyCkuS12hvu9WmX2rFUuYhHQ0L+na3U+IamoCoiltJHeXJgzVAbJfB/+Ky8sl0kw5TeiDWQEHuYyq3W1b4HtisAgSyZos8tq/9t4kgyHUItle2ijt5A1p+9a7hODD6RyVO4mJJazM6c/C985V77YP/GPSxCUAjxpPP94PfJftMK5P4TnwSkc7xy3v20yAxiYla0eUWvQ0YShhX/K4zWjXP48CQiG3gS4Mc6BAB0UZpWKFnW5Fyse/pMrBVNENXgZ/kC0ROemgM2BuItXVkHkqKPFdRJcC8Qhuzcxf0+ZHqKEOgLRVBw8m3Q6VZnS1mayXYpSTqvXcg4ogjHhGVM6w+QZqhoNYVIgVtGzt0En2Z6GiAzbIYWZRrSaKl0SJX+4X/8UO8yIcTEdVDIh58TKbwfObtShi8u6oAZoeK0Hdbe7jsnpKWOBeh8gwvUZEcCWc/nH5RQwt1GEIOuqu/TSMnDOsvtEkFkiSOwwL4df55uGKQrN7ErK8sjeQFsRD3KQAu4QgoGr1QOeiwNM2DGw+rWxUM5iUSU2BLx5E8O1JErZOu
 YXLXhjJu
 D7Ls6vG5/pXNMwqhTwWFrJrIJ27y0Xm04HrbNBG78k04RuY3kbO5Hh9q84SySvlkDmwx5WAd2KAnMl195+h2d85ZmPpc6dJdGLdw+1ww3H61P1ASk2V8TNTxKIGzF944WosYbqsqE7i+0GQmir8y43Xqfs8mw+t0WGu6MO78yHXeidHGrm5Zc1fObd5O012jK3QDh0uKerF7Rw00pahL1Ydz9ZtHez/veqW6bdgNZbr7oQ+UAc8iQKSIUMnYwmMkcH4ps78vs3T+7puRz5Vc+/1NESRql4+dJ7Xg5MWhe/7/7sCSlzk3f5apzUrZgIrUI8rl0hdy1y812QjDg8eZzFHWtjm4RflD4G/MbXjC4DH4docDQVBMRu4yr10l2y+eiAftevMMI/QoxRWf0+loAY8Nl1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 11:42:57AM +0200, Vlastimil Babka (SUSE) wrote:
> When we end up returning extraneous objects during refill to a slab
> where we just did a get_freelist_nofreeze(), it is likely no other CPU
> has freed objects to it meanwhile. We can then reattach the remainder of
> the freelist without having to walk the (potentially cache cold)
> freelist for finding its tail to connect slab->freelist to it.
> 
> Add a __slab_try_return_freelist() function that does that. As suggested
> by Hao Li, it doesn't need to also return the slab to the partial list,
> because there's code in __refill_objects_node() that already does that
> for any slabs where we don't detach the freelist in the first place.
> 
> Reviewed-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---
> Optimizes the current refill leftover handling in a way that should have
> no downsides, so we have a better baseline for any further changes (e.g.
> spilling or caching the leftover) that involve some tradeoffs.
> 
> Git version here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/vbabka/linux.git/log/?h=b4/refill-optimistic-return
> 
> It's based on slab/for-7.2/perf with "mm/slub: defer freelist
> construction until after bulk allocation from a new slab".
> ---
> Changes in v2:
> - rebase to slab/for-7.2/perf, drop RFC
> - simplify to reuse the existing reattaching to partial list (Hao Li)
> - Add R-b from Hao Li, thanks!
> - drop the stat items - they serverd to verify the optimistic path was
>   succeeding, but are too detailed for mainline
> - Link to v1: https://patch.msgid.link/20260421-b4-refill-optimistic-return-v1-1-24f0bfc1acff@kernel.org
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

with a few typo fixes below.

> @@ -5502,6 +5504,34 @@ static noinline void free_to_partial_list(
>  	}
>  }
>  
> +/*
> + * Try returning (remainder of) the freelist that we just detached from the
> + * slab.  Optimistically assume the slab is still full, so we don't need to find
> + * the tail of the detached freelist.
> + *
> + * Fail if the slab isn't full anymore due to a cocurrent free.

nit: cocurrent -> concurrent

>  /*
>   * Slow path handling. This may still be called frequently since objects
>   * have a longer lifetime than the cpu slabs in most processing loads.
> @@ -7113,34 +7143,41 @@ __refill_objects_node(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int mi
>  
>  	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
>  
> +		unsigned int count;
> +
>  		list_del(&slab->slab_list);
>  
> -		object = get_freelist_nofreeze(s, slab);
> +		object = get_freelist_nofreeze(s, slab, &count);
>  
> -		while (object && refilled < max) {
> +		while (count && refilled < max) {
>  			p[refilled] = object;
>  			object = get_freepointer(s, object);
>  			maybe_wipe_obj_freeptr(s, p[refilled]);
>  
>  			refilled++;
> +			count--;
>  		}
>  
>  		/*
>  		 * Freelist had more objects than we can accommodate, we need to
> -		 * free them back. We can treat it like a detached freelist, just
> -		 * need to find the tail object.
> +		 * free them back. First we try to be optimistic and assume the
> +		 * slab is stil full since we just detached its freelist.

nit: stil -> still

> +		 * Otherwise we must need to find the tail object.

nit: must need to -> must

-- 
Cheers,
Harry / Hyeonggon

