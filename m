Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36AED606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 15:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=okADKsBv;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ookcr4Qy;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=NTS9H0Uy;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=SUx3dPdq
Received: by kanga.kvack.org (Postfix)
	id 5A8286B05B0; Mon, 26 Oct 2026 11:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5592B6B05B1; Mon, 26 Oct 2026 11:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4484D6B05B2; Mon, 26 Oct 2026 11:14:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 199F36B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:14:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8BE9AA07DA
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:14:32 +0000 (UTC)
X-FDA: 85365123984.05.A7CAAC6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf28.hostedemail.com (Postfix) with ESMTP id 65DE2C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:14:30 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=okADKsBv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ookcr4Qy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NTS9H0Uy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SUx3dPdq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793027670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A390b+RkOufGHgkEjGHNdu4x5HPryHev6YTwANlMKMQ=;
	b=sVQy4lO9dPUVLJ7h1xWjCkjEPVGfz1na0gE+U83cqQJ216+/8iushibH2F1l3ZnC3BwabS
	gyrGCjh1VC5ddWwRrgvo9BIpIvcrZrLrcy2OwqN945BlJ6M6duxYflQmF2VsY/pb67EdKE
	VlwSsgLKdzWfr22d4SiT/N5YMawCZDk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=okADKsBv;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=ookcr4Qy;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NTS9H0Uy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=SUx3dPdq;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf28.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793027670;
	b=BXdlLong6BVfejN/sAQ5lddycXR2IB4ab/uDcgmGDoztOBt1aBTy0P1lI5TPc+ayN3bBhW
	glxLB79CclDiSdIKBmv/E5DSEIZKfXFGcKtu2SZx9Q7e/994uU27aPwMk3Jqmt/OkwRFO3
	kW+1bPGpj/ouq1Y0XGwWJ7mmqWLlX0I=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D120E2211D;
	Mon, 26 Oct 2026 15:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793027669; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A390b+RkOufGHgkEjGHNdu4x5HPryHev6YTwANlMKMQ=;
	b=okADKsBviTfid89FMXFeDRM8EJUw2C1sWJJZsEVk7e0Vp6e06w6ck7+oj/pPwrvx4ReEZ3
	ksVnr5glsgNqQYJORiKjtUBTqLyKtllbDhqI6gb8wMbpF4uoOoTtROHFykZRvn6xy7Ii1+
	893dfVR+HmLQoRle1prQpmyfkIJnyuI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793027669;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A390b+RkOufGHgkEjGHNdu4x5HPryHev6YTwANlMKMQ=;
	b=ookcr4QykwNQ/NdHhJtHrMhKMqk8N8I3PNoeVCAkMeHDR1+iwHGIpvEveVWMzU7bpheFmh
	Tqd1TI8QhJZGaaAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793027668; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A390b+RkOufGHgkEjGHNdu4x5HPryHev6YTwANlMKMQ=;
	b=NTS9H0UySzS9ohriVwrte8GIrkpmqPVao+ls8fqbTdVt+2Cti+LmXhgtEvZkfiZ3FiOAXC
	hhUa2nQuTa4BnSb/Kt2ycb1UvqqLdmCwfYTnkDG3ylaRzi+n1kiApPUb0Kgl6aV7k2Qmsz
	UzGTb5EuLDysD4D5mYCeH4UuSIiVIDA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793027668;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A390b+RkOufGHgkEjGHNdu4x5HPryHev6YTwANlMKMQ=;
	b=SUx3dPdqUjrsTRC1YkBdtvGKZ00LIIvl+tZJjwjXt4yQ/6fIMG3MIODzRNmiojpszCZsqg
	QsFMQv9KynNVxuBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C2B4613408;
	Mon, 26 Oct 2026 15:14:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Qp7jI1Ju32oVZwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 26 Oct 2026 15:14:26 +0000
Date: Mon, 26 Oct 2026 15:14:25 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>, 
	Carlos Maiolino <cmaiolino@redhat.com>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Stevens <stevensd@chromium.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, William Kucharski <william.kucharski@oracle.com>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org
Subject: Re: [PATCH 06/16] mm/shmem: hold off eviction in shmem_writeout()
Message-ID: <at9hs0Unq0EOg2M2@pedro-suse.tail5790ac.ts.net>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026-fixes_shmem-v1-6-703206d5fa0c@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 65DE2C0002
X-Stat-Signature: qx8k3oh8n9r8arzqn4iep3i6hqhun3ej
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793027670-45008
X-HE-Meta: U2FsdGVkX19wwGGgmS0StmZZUjzvyUfp0qfVkW12ACyv7Ux+KXNIMoRV08z+gU65Vxf2MuMaYWw8H/UgX6X6WtJrOx5sral9vOBbuoWMUtKCfmtAxQO2h/MmAaHNlGQSd8pqTDOLBnFDW78+fZGAEC0qmshgNsLNBNmt67fCyzUb0l3EfTZI+frFy0b//7kBGf7DOTNnD5EwylQA0uec3roPD0WSGQOC7V5te1oJEfZ/p/J/dOgJHcwcXdx+5CYzC+CmMVfgQ6Wfv+ZzDCO5I5/FnpgZC/jCyD7kh8hVezjmSKVapH0XVZW85HFacOVB/9s9CupKT3LRJK1HZkobBuFe7YoyI8ltvTwdyIbYfF2uDFxiRnsP2wkXbk56g6sppSJOdsdIEp1d+2PcXrF2t9c3hopO8xu8FH9PV+ldT0FUypYy05ip080QT4FpiiTncVdEgO6qjHpGvUu7XQ4cDONCY18MoKS68hoqOPoJNHT+YX6u6ey5gRziEe7FbBZ32aST6ymGUIdt9ctWiT54wk2vHHaHy2v39Dot16UA9l2IOdKF8kEdsypCW7uoO2zgipvpWTORhkwPOWKO8yV+tqitQ57sKoKfUZnrxb1dKnLCYbpdbKVNhPdgJxiv1G6510UjJu/jSTDSFpBTzWvT8u0c7lcM0eETM2ABgpPoTd8n5DoY78zI/1v4VTBT2qZORc0pg3BpBLC70aQnliI1vJV3ezELpqGZzHR6bZLkLG3gJIC1dHl07bXnRyh5oWuTvKXrXDFRqaAfSEeoOuMRoHRK15UqHKi97FUZAUayyDzPxu9NhXA8MGh8SCnRNeFEJ91OitViM+gGDPgyhdWDw9rnkXV/jv+qGzivsFnQ8A9jgpivZXgp/PUgkKbr4AU+7n6N/GTjvuX0XLyZWyzXZfqzbykz4pQvD5vviPLwXFY6mMUISw20/NkGQKhN2gP51EzswY8erUaCp1+ciLV
 iZpxyQAs
 /unMxLVxOSwaUq5EpTVFCWIFcAgtLVULorJzKb5lqyqjuVrTwh++P6FRGe5V7X9WV+FxbdagCV7qxV+h/m0VpzCQvpJVhy1QFSM/NoEV1B91Z+Hq/xbOYlOQih4Qi9MDDOGSWARzoUlXJPdyZoCpLYD6zSW8YcMYTir3PWk8t/+4sX5KQa2hzz1FWxeTgCy09OpDIGPSh8bdZvYjY0eCd4M/Z7/OHSuOgFb+SYNxhdir80Z8jrstULLlOUq3ohCZZOPW721OuKmuWx6Ge8l7HjVzX2ViIY/myYoLL4GEOOH+2Fq1D3nPvkOqVwAr6bBFT5OfDeJvaCnSRyYLbhK9R9IVwRK29j/oZWsfKDFs7Wf2movitUfSD5nrIMjFAHo/G9xbne2V2drtmtgroRd93tisZ8EjkqnlN2qJry6wFzwNhSzbXaS5OH01iXXyz8jTLhm0b57NNo9QKlepkQF4FeM/DKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 10:40:39AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Once shmem_writeout() has moved the folio from the page cache to the
> swap cache, the folio lock no longer keeps the inode alive: truncation
> and eviction find a swap entry, free it and do not wait for anybody.
> That did not matter as long as swap_writeout() was the last thing the
> function did.  But since it puts the folio back when swap_writeout()
> returns AOP_WRITEPAGE_ACTIVATE, it uses the mapping and the inode
> afterwards:
> 
>   reclaim                               last close of an unlinked file
>   shmem_writeout()
>     shmem_delete_from_page_cache()
>     swap_writeout()
>       zswap_store() fails               shmem_evict_inode()
>       writeback is disabled               shmem_truncate_range()
>       return AOP_WRITEPAGE_ACTIVATE         shmem_free_swap()
>                                         destroy_inode()
>                                         ... RCU grace period, freed
>     shmem_add_to_page_cache(mapping)
>       xas_lock_irq()            <- use after free
> 
> swap_writeout() behaves that way if zswap is enabled, cannot take the
> folio and the memcg or one of its ancestors has memory.zswap.writeback
> set to 0.
> 
> shmem_unuse() already added infrastructure to deal with that.
> Reuse info->stop_eviction to protect the inode during writeout. Increment
> it before removing the folio from the page cache, and decrement it after
> swap_writeout() and any attempted reinsertion and inode accounting.
> In shmem_evict_inode(), wait for the counter to reach zero even if
> swapoff has already removed the inode from the swap list. Add some helpers
> to make the code easier to digest.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 6344a6d9ce13 ("mm/shmem: writeout free swap if swap_writeout() reactivates")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: code cleanups; improve description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

I've been looking at this for a while trying to get a smoother fix, but:

Acked-by: Pedro Falcato <pfalcato@suse.de>

Things I looked at:
1) Could we just drop this logic? No, it's fairly recent and seems to have
impact on zswap setups with no writeback.

2) Could we reorder swap_writeout with removing the folio from the page cache?
Perhaps, but it would be a larger change. I'm not sure if the logic all works out,
but you could possibly have a:

error = swap_writeout(...);
if (error != AOP_WRITEPAGE_ACTIVATE) {
	shmem_delete_from_page_cache(folio, swp_to_radix_entry(folio->swap));
} else {
	/* the other swap bookkeeping */
}

But I'm not familiar enough with the swap logic to reason about possible
races.

-- 
Pedro

