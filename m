Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D461606D824
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rOKNBjA0;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Gzy3PFy5;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=rOKNBjA0;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=Gzy3PFy5
Received: by kanga.kvack.org (Postfix)
	id 501D16B05B9; Mon,  9 Nov 2026 09:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2A86B05BA; Mon,  9 Nov 2026 09:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C8FF6B05BB; Mon,  9 Nov 2026 09:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3336B05B9
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:11:32 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D91F31C268F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:11:30 +0000 (UTC)
X-FDA: 85415768340.21.19440BA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9E5BC14000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:11:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rOKNBjA0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Gzy3PFy5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rOKNBjA0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Gzy3PFy5;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794233489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UixA2iMxrYGuaa7Tk4DCMrXBPONdRbn3XUlAnW90aew=;
	b=p7DeVhszPyj1rmhGR0HqYh5Khx6E5vsFEUJ+YWdrTN0G9UC+QStTKaSVx8e+OtTTv0k/CY
	dn8THsSdiczNENhNEmHAHudbNr+y3Q5bgXDACORa7ldWXBizeeAuPrQUSyQ0kYupsfI1cv
	Xa0nUysbY/8lxHsiz/ozCQn9BCNyrIA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794233489;
	b=J+2sPKl3thWPitZ96TtOJNIKDFI1WtZQaYS1ZlhW4fIvSauoUxyo2Rs/Yc41kccBtuI3nf
	9I/xgvyrimhwPcbDqW0cXqqOAkM5NDG0nfMyobyxqY7wNO88gurdcvxwBiE8zzukvhK/bz
	Adusnkiy+fwCxuv7dZi48d/ta/C0d50=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rOKNBjA0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Gzy3PFy5;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=rOKNBjA0;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Gzy3PFy5;
	spf=pass (imf26.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id ECF22220BC;
	Mon,  9 Nov 2026 14:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794233487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UixA2iMxrYGuaa7Tk4DCMrXBPONdRbn3XUlAnW90aew=;
	b=rOKNBjA0FSBris6AaCuG53CFa1lbSnDchdh4z5Qm9m+APT1ttY5nGS1/QFBpbbKbOF4fit
	Qx5pilstG5yOIutRfIJpS19NHu2MBhVFFJtm7JYfwf1lqI1iDEkXmvpvi5Myfuq7i6WMrv
	Gqx3KjRJ96W+IfjLqQ1q+wbsYuVilh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794233487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UixA2iMxrYGuaa7Tk4DCMrXBPONdRbn3XUlAnW90aew=;
	b=Gzy3PFy52hA5KNQwVmyvZfo9FuqdMa803s8oS+B0tWdDGTH4N3v6HeWVDlo1Wm9ycM9lho
	bx2oBjSOMngmjhBw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794233487; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UixA2iMxrYGuaa7Tk4DCMrXBPONdRbn3XUlAnW90aew=;
	b=rOKNBjA0FSBris6AaCuG53CFa1lbSnDchdh4z5Qm9m+APT1ttY5nGS1/QFBpbbKbOF4fit
	Qx5pilstG5yOIutRfIJpS19NHu2MBhVFFJtm7JYfwf1lqI1iDEkXmvpvi5Myfuq7i6WMrv
	Gqx3KjRJ96W+IfjLqQ1q+wbsYuVilh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794233487;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=UixA2iMxrYGuaa7Tk4DCMrXBPONdRbn3XUlAnW90aew=;
	b=Gzy3PFy52hA5KNQwVmyvZfo9FuqdMa803s8oS+B0tWdDGTH4N3v6HeWVDlo1Wm9ycM9lho
	bx2oBjSOMngmjhBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B0E2313319;
	Mon,  9 Nov 2026 14:11:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FTbKH43U8Wo8VwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 09 Nov 2026 14:11:25 +0000
Date: Mon, 9 Nov 2026 14:11:23 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Sashiko <sashiko-bot@kernel.org>
Subject: Re: [PATCH v2 1/2] mm/memory: recheck PG_uptodate after
 ->page_mkwrite()
Message-ID: <avHULH5Irb3byJkG@pedro-suse.tail5790ac.ts.net>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-2-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109120403.82361-2-kas@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Stat-Signature: we79j9xcbprccin9gxuhh8aksiqiyohp
X-Rspamd-Queue-Id: 9E5BC14000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794233488-558821
X-HE-Meta: U2FsdGVkX1+IoxxE7d4uBrNtk/vzIFIGCa2egwMS9RbQP+CyFavvPC676RYmLQPykDwlQWxHViXzeSLJKLhtkC2w2wtqw7cDQvjE1jLz9a3k1eqo/bnKreiy1eI+odu02wJzNw4jP7uUGh8OD72clFPZZ1nS/sakFbqMEIwKsVqtRRRNsHA28/uIROmUlbCh8c1+pq9tn39kpNZU7rq7l9Wo2mgszlCOhw35vCxST/866tsVl7BqZSMte0aSmN3qTlHvgDr8HwUq9Yl0AQBFK5OXMHu00sY0K/dtPIMShL8g9tTQpzYjUOivvX4+9rLvC3b3ARdpw5jhDM3DmRGXoibi2gbdUrgVe9VieE4OrnHpQI/CXvyncNL1LHWz+VEEK5Pv1jOwyC5UM9JZavuD85WtYZKBT096hhIeuHN45Ji91E12ls0G8AOM2c4fr2eaLuXOVeCzcj4d5m/N+ZNReSJxXqFlUnl7e8LT/HRDeO160eLRmwKYbwToPVV/Js7wSUhVK87ylkIKm6BaTmeCdHpZeZJGz6nq/A0D113hE8NZhEqv7hp62fLcA7wDk0Ay6IUry+hS8HaOTRJTfQTxc0h+1kXrqZolCmt6rln2CdRmIReeJXxRl25E2nVHZiEOBFo27tkaQa+Ct31rOX6xuazFAw3upWYWwzWLTPwz2wkw2tQP4J0rveQT0TsvbxoBiUgAFJE9hFMwmQTu8uegecpDDPM9uzdjEKOBAPXEFq/NnwXmfhtCGVDPDQsiaEEaFtN2uzhczYdite2WR99m8iAq2un+K2sIq6P0owu6s+lO945UA/R7bIll1KLhKFJbWfHv3FMQv7374XsfT+7fsAEgTB3FPIfvLKqarS5iPo2JHIzFUjXTaKqDRpnJvn5fyyZfPzREenmc0eJ3hCJUzkxDhDFEp9QE7SLA7LlKql09rdePPOZ3XhLgfnYbMovwK/ZPSnrWDOSZMFqdZxQ
 ARkDGT0T
 5o7Zb3uKGqH4t3gaVILwcvG2m92ByyhXOFmntpB0NMiHmzpqvlEN9HcnO3XqfjQzvnFlFd9NmxFl2bfy4xtN1XbxOhctG45bfxR3Xn23ihh02t4N3WiXosgq54QVSPnQSAvyJSw38aOcsKwLyoCrUI15TZrLt8eXqORMTGjyE0nEMif0Ig8nbSk5TBhoY5zlWXzY7fE8Ir4MCuM8iOVBoD+YfYzV7Ilanj4wn2OtzFezzYBHy77GTQt3GiEGbij/Y6HCN66/ho9pXvmpMu2/pl50FkgZWQTYnIKqhBdiA2Gv4fstqEYjYPw2Q3cZU4Z31eMBz/8A6+MCwIsEWXyx6LYrPbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:04:01PM +0000, Kiryl Shutsemau (Meta) wrote:
> do_shared_fault() unlocks the folio around ->page_mkwrite(). Writeback
> can lock it in that window, fail, and clear PG_uptodate with the folio
> left in the page cache. ecryptfs_writepages() does this when encryption
> fails. filemap_page_mkwrite() relocks the folio and checks only
> ->mapping, so the fault maps a folio that is not uptodate:
> 
>     CPU0                            CPU1
>     do_shared_fault()
>       folio_unlock()
>                                     ecryptfs_writepages()
>                                       folio_clear_uptodate()
>       filemap_page_mkwrite()
>         folio_lock()
>       finish_fault()
> 
> The next read(2) or fault on the folio reads it in again from the file,
> over anything stored through the mapping in the meantime. Those stores
> are lost.
> 
> Recheck PG_uptodate once ->page_mkwrite() returns with the folio locked,
> and retry the fault if it is clear, the same way filemap_fault() retries
> on a cached folio that lost PG_uptodate. Skip folios outside the page
> cache: driver pages from ->fault() never get PG_uptodate and would
> retry forever.
> 
> The check stays out of do_page_mkwrite(): wp_page_shared() calls it on
> a folio that is still mapped, and a retry there would fault on the same
> PTE forever.
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Closes: https://lore.kernel.org/sashiko-outbox-202966@kernel.org/
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---
>  mm/memory.c | 22 ++++++++++++++++++++++
>  1 file changed, 22 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index fe72e66c9c2e..cc1d0b7d15c7 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5613,6 +5613,18 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
>  	return VM_FAULT_OOM;
>  }
>  
> +/*
> + * A page cache folio that is not uptodate holds data that was never read in
> + * or cleared, and mapping it leaks stale memory to userspace.
> + */
> +static bool file_folio_not_uptodate(struct folio *folio)
> +{
> +	if (likely(folio_test_uptodate(folio)))
> +		return false;
> +	/* Driver pages from ->fault() never get PG_uptodate */
> +	return !folio_test_anon(folio) && folio->mapping;

FYI you can wrap this line in an unlikely() and it has the same effect as
wrapping every call:
	return unlikely(!folio_test_anon(folio) && folio->mapping);

> +}
> +
>  /*
>   * Either the VMA lock or the mmap_lock must have been held on entry
>   * (see FAULT_FLAG_VMA_LOCK) and may have been released depending on
> @@ -6163,6 +6175,16 @@ static vm_fault_t do_shared_fault(struct vm_fault *vmf)
>  			folio_put(folio);
>  			return tmp;
>  		}
> +
> +		/*
> +		 * The folio was unlocked for ->page_mkwrite(). If it lost
> +		 * PG_uptodate meanwhile, retry the fault to read it in again.
> +		 */

The "read it in again" sounds a bit too prescriptive but, apart from that:

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

Thanks!

-- 
Pedro

