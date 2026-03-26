Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8ABF310A3D8E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 12:40:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F159B6B00B4; Thu, 26 Mar 2026 08:40:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC6756B00B6; Thu, 26 Mar 2026 08:40:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5386B00B7; Thu, 26 Mar 2026 08:40:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB2556B00B4
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:40:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6FE441601DE
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:40:58 +0000 (UTC)
X-FDA: 84588173796.16.97AD98E
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3382480008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 12:40:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XxNYHuhA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cpmFxKVH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yTtwOT+j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K0XKrSKM;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774528856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LFeHX/jlp7hMxBkxuMMv2ohEtsp05V0MKXHll/5bH6M=;
	b=iVsQwmDXGJga+ksUJvIyBqmsiolhX7vu3WhKgtYRw5eyXBx0g3aKJ4gzEchsX5HxeZn8Ow
	KCdzvFjzrLkrFfjTyezdu6UBeNrvmYxSVGzlgMfHfGEz+1iRKb2Qsxt6z6jDx254mkc/0o
	TohncLuILBQ79TEe4J2qCWd28clk2SI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=XxNYHuhA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cpmFxKVH;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=yTtwOT+j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=K0XKrSKM;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774528856; a=rsa-sha256;
	cv=none;
	b=JdpiD17K6015iQZjbT1xZlfbuzhuf0Jxb4FqH7E9T7Z7zrRhIMyWON7KEHr+jihXWzTuMA
	KoYXCY8nY3UCxzej1kxO0XKj9hNqZkw8JRR7po3KFZkCbdNe/hG8YT1fJLNrwpSP7CdiNt
	LgfK3Ok/D9/n0jfYw1vGrnb47UDREek=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8E7FE4D282;
	Thu, 26 Mar 2026 12:40:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774528854; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFeHX/jlp7hMxBkxuMMv2ohEtsp05V0MKXHll/5bH6M=;
	b=XxNYHuhA67qP3aIYpqHcvFzzmxRivroPkdCJPE60yA6sKuajtGGRxjWnPpLWJRon26qhVH
	i+I8C6AOGDqsLy8JE+7fpLPHrn0HGmkgjIXqPU2D3cBE2YcdzLG5I1XH4U4c7XjMQPpZIJ
	M056gz4LLgeihgCHu802HMVgTwjnRa8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774528854;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFeHX/jlp7hMxBkxuMMv2ohEtsp05V0MKXHll/5bH6M=;
	b=cpmFxKVHHEuwGU4YVTe3YOcnCWmrRiXFwv40Fsx6HjHVJtFDdhHk5wBTpt5f/K+wwYoDze
	lUJ1a1pfYjHsymCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1774528853; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFeHX/jlp7hMxBkxuMMv2ohEtsp05V0MKXHll/5bH6M=;
	b=yTtwOT+jHbgk52d8P7LxD94GHo3SEQE5P+I+j2uYjB8S8DM3GO+FvgOYyPeAWnUh5zdjG/
	vKrma2cZrbp0q1wxBMk0Rt5CYOhYQbihperzqErPpxNZNKHctsmVA+qqDblZ6GYoMxs3xk
	JcmOMEH1jtXJIlUnVQSkUeFO+SsZ6Io=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1774528853;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LFeHX/jlp7hMxBkxuMMv2ohEtsp05V0MKXHll/5bH6M=;
	b=K0XKrSKM890tVC/2oeIfhGVHnCh+6QYqqDessiD1c7S68Lg0MAfQ4ZaG+PpO/8EbGw988y
	aPFY2Hie/0344oCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 414084A0A3;
	Thu, 26 Mar 2026 12:40:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id b5R9DFQpxWleNQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 26 Mar 2026 12:40:52 +0000
Date: Thu, 26 Mar 2026 12:40:50 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Zhang Peng <zippermonkey@icloud.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
Subject: Re: [PATCH v2 5/5] mm/vmscan: flush TLB for every 31 folios evictions
Message-ID: <tq5bx3gz2mzqyf3mylay22bcdo2sxt5urvpbblqej4v4sbk3q6@hwjqs4y3ghxf>
References: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
 <20260326-batch-tlb-flush-v2-5-403e523325c4@icloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260326-batch-tlb-flush-v2-5-403e523325c4@icloud.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: epxtefm5kgmthg8wdsgtx31heqjdhui1
X-Rspamd-Queue-Id: 3382480008
X-Rspamd-Server: rspam09
X-HE-Tag: 1774528855-820936
X-HE-Meta: U2FsdGVkX19eC+AV+x8BZ3ZuFHhbwgjONkADsbqTGDVDiZn0/yOC/3L3y+Wtwj8I5B2phP2ptBfFsTqBPYZsOu3/OXmoeDc25olhgiyaCAX4c7tW5a/ybePCM8mw1uy/fZ5NMxNcnAZoG+fQ5VzZkEot6UWVV91J500rVX3cbaCnWcvKpT3+ucMq6+pM8FFqif+EbvXG4agA/kZcXyuWmkLkJl1Z812qDCl25CPDo60RNn+VSCv5mbqwfK6SkNe1b1IZ8yYg+b2gmwU79p7oOPI1XN/MCsEuJTRgwfqWS9sMRgHkjxVHM94aRpPA+/mj1i5C8DHuC7xtoUS3P9jSzvpk0DlO9Qgug2HtOe5MmlzadQ0GqWW6GFC6sZDFAISMCHEPITYuojvaEJEz0Ph8IR5NakZvqjaK7lBdXBRURk5VoEkrUgqc8kQxljk9fDioDedoU0fgvs8PClIf4Q9aogTEJIE+5yqN3FtG0nkHmJAusX+6EUq2CgTwn40ggYCdXC6MAdQfd6xVgpynUBB/odrvxpjdXjXSAPCy4StQHc6DYeBZ5AtqBT+aXB2TE9T93vG1vSRN/Jwonz2Z/kT9V05O+lfY6aeTuuk+SQybYPfjOYvMkctjiLlrJ2DPQVrTOvF9F5S54+720KzfsubhLhz5JEYZj6PlQVKgB2LGNqlNh4xV8/4T5R6tLBoTCuzf5EaniPmAyK42qg1znfyZi09yvUnjb33ekp4d5QdGeWXfOeuZJ7ITJzSlISsorr1D4Mudw2koow7rcRWENDNJcbCWm0xrjhbops3Lk+WFmE8YzwzKfYNfIJAGGNU8gphX/WkdYifblm+/G5qUvtKMtm3E8bhg7OYN9zt+iNZcrtS9N+tnzhQXMEDwCxBk5FxcbvMcQx1W05+ocOnlqMUiVAtEOmI3uZswUzZxN25VtyUaeNQjTqw7/eEMe8yTrMyufy4zf4MuRkfssOm8Yi4
 ozUyneYZ
 5obnILL7/4859nP5JkhfoQMIA/pXvnXt97wRbHOyp9uv2XYNeVOQNpy8Kg8vTpwVEcj0xPkVr197N6/PjfMPcK2yPj7rxiwq783zE4SAbqAPwJ2VvL9ySQcdrk4E9m9USl5espVRJYhebvUx4Rs9+3HAUdsZN0tAYoz4FxtKSN435VsbPqiXqq2mj6hRbVa5T3ywBulwceu2jGej2vMN88Po+6D7e0y1M6QcfnSxAn2PwF9wQmkFJsjRuFOlZDtxsjMsubDydGIGu0kZ37CHUgHS28h06gjIWcMHkAWB1Z/XgzhCEy9nIfmwkE9egumz3ikfRmbZyc3ACzt53RKv2Xbftz3RzlCddvwTj3Mex1Cp4oS0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 04:36:21PM +0800, Zhang Peng wrote:
> From: Zhang Peng <bruzzhang@tencent.com>
> 
> Currently we flush TLB for every dirty folio, which is a bottleneck for
> systems with many cores as this causes heavy IPI usage.
> 
> So instead, batch the folios, and flush once for every 31 folios (one
> folio_batch). These folios will be held in a folio_batch releasing their
> lock, then when folio_batch is full, do following steps:
> 
> - For each folio: lock - check still evictable (writeback, lru,  mapped,
>   dma_pinned)
>   - If no longer evictable, put back to LRU
> - Flush TLB once for the batch
> - Pageout the folios
> 
> Note we can't hold a frozen folio in folio_batch for long as it will
> cause filemap/swapcache lookup to livelock. Fortunately pageout usually
> won't take too long; sync IO is fast, and non-sync IO will be issued
> with the folio marked writeback.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
> ---
>  mm/vmscan.c | 69 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 62 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 63cc88c875e8..27de8034f582 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1217,6 +1217,47 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
>  			folio_test_unevictable(folio), folio);
>  }
>  
> +static void pageout_batch(struct folio_batch *fbatch,
> +			  struct list_head *ret_folios,
> +			  struct folio_batch *free_folios,
> +			  struct scan_control *sc, struct reclaim_stat *stat,
> +			  struct swap_iocb **plug, struct list_head *folio_list)
> +{
> +	int i, count = folio_batch_count(fbatch);
> +	struct folio *folio;
> +
> +	folio_batch_reinit(fbatch);
> +	for (i = 0; i < count; ++i) {
> +		folio = fbatch->folios[i];
> +		if (!folio_trylock(folio)) {
> +			list_add(&folio->lru, ret_folios);
> +			continue;
> +		}
> +
> +		if (folio_test_writeback(folio) || folio_test_lru(folio) ||

If PG_lru is set here, we're in a world of trouble as we're actively using
folio->lru. I don't think it's possible for it to be set, as isolating folios
clears lru, and refcount bump means the folio cannot be reused or reinserted
back on the LRU. So perhaps:
		VM_WARN_ON_FOLIO(folio_test_lru(folio), folio);

> +		    folio_mapped(folio) || folio_maybe_dma_pinned(folio)) {
> +			folio_unlock(folio);
> +			list_add(&folio->lru, ret_folios);
> +			continue;
> +		}
> +
> +		folio_batch_add(fbatch, folio);
> +	}
> +
> +	i = 0;
> +	count = folio_batch_count(fbatch);
> +	if (!count)
> +		return;
> +	/* One TLB flush for the batch */
> +	try_to_unmap_flush_dirty();
> +	for (i = 0; i < count; ++i) {
> +		folio = fbatch->folios[i];
> +		pageout_one(folio, ret_folios, free_folios, sc, stat, plug,
> +			    folio_list);

Would be lovely if we could pass the batch down to the swap layer.

> +	}
> +	folio_batch_reinit(fbatch);

The way you keep reinitializing fbatch is a bit confusing.
Probably worth a comment or two (or kdocs for pageout_batch documenting
that the folio batch is reset, etc).

> +}
> +
>  static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
>  			    unsigned int nr_pages)
>  {
> @@ -1264,6 +1305,8 @@ static void shrink_folio_list(struct list_head *folio_list,
>  		struct mem_cgroup *memcg)
>  {
>  	struct folio_batch free_folios;
> +	struct folio_batch flush_folios;
> +
>  	LIST_HEAD(ret_folios);
>  	LIST_HEAD(demote_folios);
>  	unsigned int nr_demoted = 0;
> @@ -1272,6 +1315,8 @@ static void shrink_folio_list(struct list_head *folio_list,
>  	struct swap_iocb *plug = NULL;
>  
>  	folio_batch_init(&free_folios);
> +	folio_batch_init(&flush_folios);
> +
>  	memset(stat, 0, sizeof(*stat));
>  	cond_resched();
>  	do_demote_pass = can_demote(pgdat->node_id, sc, memcg);
> @@ -1565,15 +1610,21 @@ static void shrink_folio_list(struct list_head *folio_list,
>  				goto keep_locked;
>  			if (!sc->may_writepage)
>  				goto keep_locked;
> -
>  			/*
> -			 * Folio is dirty. Flush the TLB if a writable entry
> -			 * potentially exists to avoid CPU writes after I/O
> -			 * starts and then write it out here.
> +			 * For anon, we should only see swap cache (anon) and
> +			 * the list pinning the page. For file page, the filemap
> +			 * and the list pins it. The folio is unlocked while
> +			 * held in the batch, so pageout_batch() relocks each
> +			 * folio and rechecks its state. If the folio is under
> +			 * writeback, on LRU, mapped, or DMA-pinned, it will
> +			 * not be written out and is put back to LRU list.
>  			 */
> -			try_to_unmap_flush_dirty();
> -			pageout_one(folio, &ret_folios, &free_folios, sc, stat,
> -				&plug, folio_list);
> +			folio_unlock(folio);

Why is the folio unlocked? I don't see the need to take the lock trip twice.
Is there something I'm missing?

-- 
Pedro

