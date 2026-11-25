Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC23E606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=x3G2Yh+W;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BX6TdYFy;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=x3G2Yh+W;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=BX6TdYFy
Received: by kanga.kvack.org (Postfix)
	id F21BC6B094D; Wed, 25 Nov 2026 04:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFA6D6B094F; Wed, 25 Nov 2026 04:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0F246B0950; Wed, 25 Nov 2026 04:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B9F776B094D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:14:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4ACE2A0E4E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:14:36 +0000 (UTC)
X-FDA: 85473080952.27.5AC8354
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf30.hostedemail.com (Postfix) with ESMTP id 19CE580005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:14:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x3G2Yh+W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BX6TdYFy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x3G2Yh+W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BX6TdYFy;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795598074;
	b=vUzVua5mNC44kA/TX1OI+1m6gdabDVc/MrQgVA2Q3RXT9dJgoeOx/HZyEPO2Uyjb4fW2Ci
	DBN+pNsCQUbnjS2aNO6SRcsAVMJdfpGjDYH6iIZbVn/uuFGcm1GO1KDKyxfrdYbjI4kAPa
	WlWBEVdh+WI+a/ywPqmizDsahIyl6Jc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795598074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ruMhBL6geZHtZpeVeqePM4fPGxZEpg6PQ9GdOn9Qfc=;
	b=1yw03n5IYaYll0XspFieAN9W8IecB5ynWePJZsgHpVJ0YX3SBclE+lLiQFvXax0kJ99zDJ
	/fpKSoSRZrLo3EFmPnS3qKZRvV3Zj6qJWM9amrp4qiMaNBZ/L0QMhDfVhipPo5HGGRYtjH
	Sk7jSLwQ+yYjS3U48TBfU/2iwjWbBaI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x3G2Yh+W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BX6TdYFy;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=x3G2Yh+W;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BX6TdYFy;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A5FCE1F456;
	Wed, 25 Nov 2026 09:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795598072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ruMhBL6geZHtZpeVeqePM4fPGxZEpg6PQ9GdOn9Qfc=;
	b=x3G2Yh+WF8bse2bC62OJJaDoSphgPQQV5gJgM8+KNL0txwsG45ahWusw4L/hZo1OD6j/q6
	C5rl1V7XJjK04M/WpBwOPdFENLOHK+NgMG1ew84cFE8Xk/sC4w/lkGxIrBEFwmb/qrxyqm
	JiYEkZjBOnsS7ck8uGt9bcBw4sel3IY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795598072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ruMhBL6geZHtZpeVeqePM4fPGxZEpg6PQ9GdOn9Qfc=;
	b=BX6TdYFy9nKZNMhG8YeDvFJ4MGChj9K8CkJWw0Y32c4LF6QEM5Gl11K3mKe2Okz1D6UPdw
	g/ZdUtFMJKyLoeBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795598072; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ruMhBL6geZHtZpeVeqePM4fPGxZEpg6PQ9GdOn9Qfc=;
	b=x3G2Yh+WF8bse2bC62OJJaDoSphgPQQV5gJgM8+KNL0txwsG45ahWusw4L/hZo1OD6j/q6
	C5rl1V7XJjK04M/WpBwOPdFENLOHK+NgMG1ew84cFE8Xk/sC4w/lkGxIrBEFwmb/qrxyqm
	JiYEkZjBOnsS7ck8uGt9bcBw4sel3IY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795598072;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9ruMhBL6geZHtZpeVeqePM4fPGxZEpg6PQ9GdOn9Qfc=;
	b=BX6TdYFy9nKZNMhG8YeDvFJ4MGChj9K8CkJWw0Y32c4LF6QEM5Gl11K3mKe2Okz1D6UPdw
	g/ZdUtFMJKyLoeBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B3141339F;
	Wed, 25 Nov 2026 09:14:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id v3WvFfimBmsDGgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 09:14:32 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 0981627BD4; Wed, 25 Nov 2026 10:14:28 +0100 (CET)
Date: Wed, 25 Nov 2026 10:14:28 +0100
From: Jan Kara <jack@suse.cz>
To: Henry Martin <bsdhenrymartin@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm: report all-zero cachestat for DAX mappings
Message-ID: <mixn4cl5mnx5e2o3e5tlklaa5ynlu6qadorrlpifywqstbep2w@o6tylgke5umz>
References: <20261125030432.274396-1-bsdhenrymartin@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125030432.274396-1-bsdhenrymartin@gmail.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Queue-Id: 19CE580005
X-Stat-Signature: jtaccqecoqj4fzg4muhoz9otdpdmr396
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795598073-278782
X-HE-Meta: U2FsdGVkX1/5oCbaT/t6PxncojoFZVpwSN7nuSFhEb3U8zmGDubPcD0EpOcPrUF59/GziGxT3cU+M/q/vKXQ5a8mXa8d3hXKBQHvPZB4PYXA0AWbAtgX7AedHjpW1R68d2dtX/oPJAB0/j5XmmapyBI8TBTgKZSi/N5wS+sf7BM4Q/c0aOJWsv8XUM4Ceu8O8MguXGR1uyswso+k1VixIob6+nEObUVHXQvhIUikw9ntf9nOyD6w2IQDSVsHY0DOAWkO/tCrugSXpNFi5TgXBq3i/WrKrWMkr+1/aPBJv/abo8dOvkw+jIQJc0AvJAagijX5xRuwJDpDDqA1YBl5LEle4BME4E08gCZnMARB1ZQMfdH9CKkvAd5x5Y2677tSNiSLVkXO4rK7AfTxlL2v5jrzR9A3sF6ybTEe7+n9YKIe1i4uQh2Fjv47NGOY9qycocJMiJa3RrW/IOi++mGg6+Zx0bZrsOXbpAPgoXqfetJggcCF6z43saLqRrCARtvOIyPtv5KwYKpTGFN/m/eDlibwrAnIdkJlw0W9uDHSTSneRw1xJ9UKUp9bNWK6WCWBaKdsO8iK2Q4rW3Ad1EeZbgUVebRUTZekfGGAlhK44eUGRQt1VgEkaGTEMhAVf0MmNTtpxGvZDp6cwq3446FQIK9IudFx/hYJMuSPX9yYVPN+p06fQpUppylipEusFhn8+qrYr1m/E3JABloDqfeWOY7cBYZkoU0dOCp5ps4H0Kh1Bta+qjs+vrgnWtdXqHXnvX3c5h7NiLBNBuMYGVgXRkcc98kPAe1ZlGlFlzfODGB8l3S40ZOIHSdD8HZ9t6RIT2fUzW2WsKVrdE+o3A1Jdt9h89gnS26Aug/v6aUCtlYoxVUuH3rnEauIBFVivbCytL8PgBOt2eQReEE/wfEjoxhRlsvxSxn9kE9rkWUREY8eRalEiRzYP3UeSinVJQNZafyT09pFCYhhp2cDqlH
 FxfAK59X
 Gujt/SfUJeGIRGL/D+SFz8HSLyUreCUGdgVcgHBZ6znkh8xutn855zFbpMO29oKaBwQ36wbDowBvHsaVdmtz8arA/kDEeJEvsOxu2iN4EJcz32mysA8KQX1Hj3PIP6m8T6bTH5WjR5oWLBkk+Ahhkyub3Kyjpf4RTr/JZfhXf7T37s66kl6AGMENj5hF/Mvi4QQLN0TWflYIO3mqNCs9qLGxoP51TlrjiA22RnYF9plm1lKnyJ7NuE4KxDgi1uGFEGoY5szI2bAQx9cjYXznMt0F6pMtwE9RSOSzZjgn1KA9gkV7uSXR6eS/LwV4Und836ngjMWx57tl94iws+G3qLQymDynYWELUx6ep8uDS6hqJ8MdX1p3c1oa8xHwM9EvCyra5lNniCjAFJ4r+4+ng6TbbfdH/Ux7TOBDaOzqUswbz+2+F3zHZiH0G9ThsU1TjQanACmdFtaVpLygDu+5CAwMItoqdgMDDQRBNWBr/bSq37u9nfcyRWkMFrr/g0qxi/b2bdwB7otjrhFEddfDc3dzA1X2x8ek7u7AH0RcAY2Bi1EuCCN/LPndzF6Qxq+Hl3xKfu7qNuDatf3tC5lV+I5rUl93qZIPbLGNLJRf4KE+4wFLR21nM7c83Ww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 11:04:32, Henry Martin wrote:
> filemap_cachestat() treats every xarray value entry as a workingset
> shadow.  On DAX mappings, value entries are DAX exceptional entries:
> same value bit, different bit layout (flags in the low bits, pfn
> above).  Decoded as a shadow, a DAX entry yields a bogus node id;
> NODE_DATA() for it can be NULL, and lru_gen_test_recent() then
> dereferences it:
> 
>   Oops: general protection fault
>   RIP: 0010:lru_gen_test_recent+0xde/0x300
>   Call Trace:
>    workingset_test_recent
>    filemap_cachestat
>    __x64_sys_cachestat
> 
> Any writable file on a DAX mount triggers this once an mmap write
> fault has populated entries.
> 
> DAX mappings have no page cache, so none of the cachestat fields
> make sense for them.  Skip the xarray walk for them and report all
> zeros, and document the behaviour in the syscall's kernel-doc.
> 
> This issue was discovered by Tencent CodeBuddy Security.
> Cc: stable@vger.kernel.org
> Fixes: cf264e1329fb ("cachestat: implement cachestat syscall")
> Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
> - Return all zeros for DAX mappings instead of counting DAX entries as
>   cached, per Jan Kara's suggestion (Nhat Pham agreed).  This also drops
>   the dirty-accounting gap and the inaccurate PMD-order claim from v1.
> - Document the DAX behaviour in the syscall's kernel-doc.
> 
> Link: https://lore.kernel.org/linux-mm/lh4cnpy2kw3tdtmhubwhhvim25kxpqxo6xttt7sihyx7x5hqdf@3tvivew2qh7m/ [Jan Kara]
> Link: https://lore.kernel.org/linux-mm/CAKEwX=Py7W0vOwxKdWMCZu3d=BbF2OkgDt6Tu_AHhEJZ06w0ew@mail.gmail.com/ [Nhat Pham]
> Link: https://sashiko.dev/#/patchset/20261123030014.3116755-1-bsdhenrymartin@gmail.com?part=1
> 
>  mm/filemap.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index a1b2ca5b933cb..4f6fd1f4caedb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4779,7 +4779,8 @@ static inline bool can_do_cachestat(struct file *f)
>   * The `flags` argument is unused for now, but is included for future
>   * extensibility. User should pass 0 (i.e no flag specified).
>   *
> - * Currently, hugetlbfs is not supported.
> + * Currently, hugetlbfs is not supported.  DAX mappings have no page
> + * cache, so cachestat() always reports all zeros for them.
>   *
>   * Because the status of a page can change after cachestat() checks it
>   * but before it returns to the application, the returned values may
> @@ -4824,7 +4825,10 @@ SYSCALL_DEFINE4(cachestat, unsigned int, fd,
>  		csr.len == 0 ? ULONG_MAX : (csr.off + csr.len - 1) >> PAGE_SHIFT;
>  	memset(&cs, 0, sizeof(struct cachestat));
>  	mapping = fd_file(f)->f_mapping;
> -	filemap_cachestat(mapping, first_index, last_index, &cs);
> +
> +	/* DAX mappings have no page cache; report all zeros. */
> +	if (!dax_mapping(mapping))
> +		filemap_cachestat(mapping, first_index, last_index, &cs);
>  
>  	if (copy_to_user(cstat, &cs, sizeof(struct cachestat)))
>  		return -EFAULT;
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

